Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326B8CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 13:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FE4E8E000C; Wed,  5 Nov 2025 08:23:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AECB8E0003; Wed,  5 Nov 2025 08:23:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D8D8E000C; Wed,  5 Nov 2025 08:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62F848E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:23:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 082731A0353
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:23:55 +0000 (UTC)
X-FDA: 84076621230.07.CE68263
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 15830C0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:23:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OA3+ByI5;
	spf=pass (imf10.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762349033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WNWzl9UPAGqC0OeojGWF3FUUOCD6lJ7lBCWbQ62ZwI=;
	b=FORj+ej+NOmT+R6zJhZx8HMGnBJz+Yz54QnPvc0hDWgVG+m4s4mqw/jNI2m9dgd1W2gsTe
	M1WwUjBh5QMcmtC855ONuEbFzr4nFb1gAd2xJU4c4tqwqj2OtY4xYq2jW+Xko3jD66cAub
	tjSMUId2KtvAyfYK2wvO0o6IzRYV5kM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762349033; a=rsa-sha256;
	cv=none;
	b=qVmzLp4+bUHu9YsPJxKpL2CybkJ0bpHBaCDCq+7LiNj5nER/Ipq1SB/6n0oDZeukHUARTE
	NBFtOmqovpcJFVkzoslSAxCRcpekav1UtbDBU3I9VyacIRvP/U44WQVMH/fXi5HAu9WSgK
	Hs+pDEz7fH8pmMSSCSYzDsuIWCaNghg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OA3+ByI5;
	spf=pass (imf10.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-378ccb8f84aso69944711fa.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 05:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762349031; x=1762953831; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2WNWzl9UPAGqC0OeojGWF3FUUOCD6lJ7lBCWbQ62ZwI=;
        b=OA3+ByI56ZD8dJlBnAPqZzrs+WeH6VIfyludz76Cb9h2aUuEKpRIpuPXcjKxSIAVth
         6yAXyZA3d1USn6U/HUhSwAaX1IjpgMYXZcig499snsCeguFEtlPrJCxkxEklJEjaVMG4
         bDSvPSoGGG/knGBVf74dvqqg9jjnQJK43f1W+7Qa3QEml0vGMqpfYA2kbKwS6KUUpr2G
         f0XEF1lGWmqKrw835VQmdUZWZwq4VV5PkNw0IyKMIg0DPqvclgaIPH515ADWZLe4omNR
         8hlcKdaGisqiJPkeA20C4GaxfVN7PIb4sZpfL3/fvsD80bVwCcv3Vj+tS1clNye+waFP
         unXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762349031; x=1762953831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WNWzl9UPAGqC0OeojGWF3FUUOCD6lJ7lBCWbQ62ZwI=;
        b=pEKnVrOZ+aEUD+cEhpAIs0lEbgEw+3x4KXrAqnIUeVQHvP9lORRVlZ6hV12eWluI7x
         po2csAvQ6PcWJp5/Np/s9F1nzcoC+nknmJ0Z1KDhXucyFcBFirzoBRIfLq7wsGUPHKBC
         x8LvVgKxx25rxGGBmGrfdtB+kB8SN1fEV6wzu1sae2D7pImgBFqs8EqkbT+cnXfi2Ycs
         twUGIfQQJ6BC+Q77EC929a7fX1e+Im1DYYP8MEZ8gK0U16gUy8cLAVpbaCt+jAYxbeXH
         DUvq++qF1gAmflOJF1ScvvkR3E89c86ZQvlUee1KdYg1zz/za2vqoIMKUlWKAdzyrUbj
         fLsA==
X-Forwarded-Encrypted: i=1; AJvYcCXB4a49Vzao45vC3axh6GhhIo8W/xLqBrRf0QXK+G2ltfQUHpfL71XRFmADBFi0YLXsAOe/4ZoEKA==@kvack.org
X-Gm-Message-State: AOJu0YwezF3sOq2/06PJ9a4NhNj9UQRtihq4htLDAyFFnb15K5nslcdQ
	6AEWAUdDB+BZOln0kUKmzn1cbAqdQueQzNoDyBKvNkgmS+5strLdeEn0CKBWJtkOP4q4A+MuNj3
	G0V8ACr8+kTqFTZHOlLogDrrjsbGHMhmibvB1
X-Gm-Gg: ASbGncs2YNoi9c8BPuPCmoMs3cnkZFT116RVcK5o4h/s0LmV9ozRyJlUxZPjUrsaZsl
	O/yMrYN+bRVYEqDs9XiIXkz7m1H+vI8AiIh5723mgyqzucKJMlALHMIf3hHJlRxVsvmtvhIIk8z
	XbHhf/hIsAeQLMoi5UAeVe7CTV6dgvALJqXDN7cO/joQN+PGjy3STKVPnCoodep4kHzUKO/WQCU
	+gXbCF3oMTvacCLiE1zMQJcJsNTs9Bey99MYXdIx7+D2nqQTcDOKsbTMtBDtCFGgNLC8aeLu3yF
	A57uSFkLEJe8
X-Google-Smtp-Source: AGHT+IGdn3dvXTFfnd26oUCEg5vL/XwsKbx6eN6B7iFUvvLn+iruzlQSAGzvDJ9vCiy6F+m/VX5r20KcdkbP0rV3R/0=
X-Received: by 2002:a2e:a109:0:b0:37a:3033:16f6 with SMTP id
 38308e7fff4ca-37a5142e2c8mr9741151fa.35.1762349030972; Wed, 05 Nov 2025
 05:23:50 -0800 (PST)
MIME-Version: 1.0
References: <20251104003921.9707-1-akinobu.mita@gmail.com> <aQo1VjjQw1OZG8nY@kernel.org>
In-Reply-To: <aQo1VjjQw1OZG8nY@kernel.org>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 5 Nov 2025 22:23:39 +0900
X-Gm-Features: AWmQ_bm7dSG6fty0drtbxuWvBO6bGxhtYdnsjyRSa0aF5n43MfZsmtccLtweZyg
Message-ID: <CAC5umyigiSS+ynr2JnNSaR3irW0eEWFuUVnJvY2QvJJO4yfP-A@mail.gmail.com>
Subject: Re: [PATCH] memblock: fix memblock_estimated_nr_free_pages() for
 soft-reserved memory
To: Mike Rapoport <rppt@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 15830C0008
X-Stat-Signature: tuqaqimwhkuzfhqw167ip8zzauuiasey
X-Rspam-User: 
X-HE-Tag: 1762349032-405826
X-HE-Meta: U2FsdGVkX19QclpazeOajigSTz8p80VmUj8ejMw2z7cHbw8M7P2T38JnBV3CktcS4B9Q3VTnEekexkulcY+DmlJ5EPP1zXfHxQaIFA4vjbiXT/F7FB767a/h3p9IIHB6/v3XSlT6jOuuwD/NiGn23otFF3c6gI4te/bvW4I/iyq7S8PVg6r7svqEdpOap1DRZI2Qvo1B3bI/MwcKynkc7Xkrhz0IUZ5At5AdsP72whHf1YOEd4Z5aAIpLbzk94rs3nOuLUN2MoE/w+wlT1u6Hghx/LWE5SajKnXdM4pLy7CIdt7szGpTBHlOGBdKPJ7BFLfq6FBtXRfd9GbC1Z4GF0e4TMSPUJ6oijdDppltzjAOffoiQhY6mLnCblGsBAwpt3E1axAg5q5TiEbS+EZz8lNzg0QpkoVEqIqvQLcfVtHflmO61iXn3UScPLuBXMZoLb9ic+ukcyNd8t/W7ePL2tQ6XWsEzuZNEpaayqb0lV/t7i6KHWpLpZFUe55QFg4jEUIhAuP4/8AYkS2tGfMM7Tvj5N+qLnbJGt9sbXooMMcXTSvjHcONFD9EkqSiR344QSExlk58QKpxNUE40FO43ktz9eTascuveASKUc4ZgjBJjd2oa3CGzRV7A8r9c2eZV2ju7SyWFoiXNHnR3iXSEul6IH4HR25Iem2rbBVnbwBTv9h43VNc00x8mYLPD31V3twmO14PDG3dtYngNI0aGF2B7jbx/Nr5AzlrzJvaWqjmlnsalnbPApkuv5BKbeb5dtQWViHXz64Q79vG2+00ufxNrqyVG0vuaU+ZBF4HxGjRNpVKchEQDAgMyWCaiVvZluAT+wjh4LC4PmDlxJvip1uj02YpBx3iChnwdDdggi1PLnVPm2mzDeQbb/iy6vnFr6ua5D5YWtg+LJ5Uf5Rhv38/BiFhmYFHPH/dedNWhZT+ltQRcfGFauOJVIcwAZKodLO3ObG4ubY209W/dOb
 zCTEDdlN
 XEoi2QuIGXHkqk6I1qmgBLaU4HK9d66zka3jJY3cHSsnUoEy9LDYcPRNFsqJKc16Pil4MwOIm52+gOWj2MzcpUIhfndjEQcF+ZfVGVe6agcHoljpR9xXnTS1VfIxS4ja/EupWA2DWTzLoCalIzAYMeQD4NdDQZvc7Vgq0X/DmNomqNd+jetPiuZJpQuhG7MGdAip4hYDYlDfUh00agFMXDlvbOsiN4FqYx8LzLjGCZSxQK8b1FmORz6oEVTBD7W9a3iZdoWTUIEnjjZHfPM7eyzI4h6r/A5B2wvYaxAJ/P8z8n5luCItnzreCRQee3PPRLnd4uIM/2w1ANoFhvcTmfL4f4Gs+FN2lXTWJZXY/1ZMxOyoHxri+unrA4WaM5pq6CMb9yEcQcbCAHt+Ry1QT0+O9v5ZBFDikdXNrMDqzNNoRFFCWuQcp9RR66dKvfxOXcN5zShm+Aj9COjEiOfRwcsJGS1ZG4aEe6rMX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B411=E6=9C=885=E6=97=A5(=E6=B0=B4) 2:18 Mike Rapoport <rppt@kern=
el.org>:
>
> (added Dan Williams)
>
> Hi,
>
> On Tue, Nov 04, 2025 at 09:39:21AM +0900, Akinobu Mita wrote:
> > memblock_estimated_nr_free_pages() returns the difference between the t=
otal
> > size of the "memory" memblock type and the "reserved" memblock type.
> >
> > The "soft-reserved" memory regions are added to the "reserved" memblock
> > type, but not to the "memory" memblock type. Therefore,
>
> @Dan, do we really need to memblock_reserve() the E820_TYPE_SOFT_RESERVED
> ranges?
> Quick scan didn't show anything that requires this, but I could easily mi=
ss
> something.
>
> > memblock_estimated_nr_free_pages() may return a smaller value than
> > expected, or if it underflows, an extremely large value.
> >
> > /proc/sys/kernel/threads-max is determined by the value of
> > memblock_estimated_nr_free_pages().  This issue was discovered on machi=
nes
> > with CXL memory because kernel.threads-max was either smaller than expe=
cted
> > or extremely large for the installed DRAM size.
> >
> > This fixes the issue by improving the accuracy of
> > memblock_estimated_nr_free_pages() by subtracting only the overlapping =
size
> > of regions with "memory" and "reserved" memblock types.
> >
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  mm/memblock.c | 33 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 32 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index e23e16618e9b..af014fa10a44 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
>
> ...
>
> > @@ -1826,7 +1842,22 @@ phys_addr_t __init_memblock memblock_reserved_ke=
rn_size(phys_addr_t limit, int n
> >   */
> >  unsigned long __init memblock_estimated_nr_free_pages(void)
> >  {
> > -     return PHYS_PFN(memblock_phys_mem_size() - memblock_reserved_size=
());
>
> We have memblock_reserved_kern_size() that tells how much memory was
> reserved from the actual RAM. Replacing memblock_reserved_size() with
> memblock_reserved_kern_size() will omit "soft-reserved" ranges.

Replacing memblock_reserved_size() with memblock_reserved_kern_size(
MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE) also fixed the problem. Thank you.

