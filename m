Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F41D7495A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366BB6B0088; Fri, 19 Dec 2025 01:55:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311946B0089; Fri, 19 Dec 2025 01:55:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DF56B008A; Fri, 19 Dec 2025 01:55:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13DA76B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:55:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE0C713679E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:55:25 +0000 (UTC)
X-FDA: 84235309410.23.8BDA37F
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9381C0004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:55:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QAfHK0iV;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766127323; a=rsa-sha256;
	cv=none;
	b=Kpve1FLJKLFzS9C9OYodox8DAtajRxzi8VdN2yTNTy1bUM8YChozlSssYUGQR5DEb7oMrM
	cv1MkxBIl6pbxhiqiMFD7xthWBD13CtgNubfNNBjSLh67JpksW/azppwzkHPedf0bIVi6w
	2hDcY9ZOADyHHBn8qiOwyoFs7OuT1h8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QAfHK0iV;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766127323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GicAORaQTtn70Bhd4n65cah4A4M454XvAKFCQLeoD8c=;
	b=KoIF7veMmrKqXOkLX2qLdyIZvoDwi5D2g+jg2Q7h+IfNH7tavsGmJONWO3E9+VppgJ72nc
	hLCkNtflhcDd2tCd3QQWkZDAR4yiQcMh43Ka36koj92AqpzfxLBLC6bj/smO1qKJTcR8zf
	CyMSJXJCdbdSc4JZWAi4Q7ziQ2azyUQ=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so1610510a12.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766127322; x=1766732122; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GicAORaQTtn70Bhd4n65cah4A4M454XvAKFCQLeoD8c=;
        b=QAfHK0iVUp1Mn1z9ebuMi9mvY/4v4FO4V50jkSRbb/6lmdmeLGjJTuM3GxJ7kMkUNj
         OqL6Wy0aJ0++ltWZA+Vbih3f7LdjwkCkC+LE9UoAyWasU+8OTqdI7KTzDSamsJcMy+1a
         Tt25J2V18vfaUHQZxTvBNZZy6rTb1grk0nJ3AUGm3iIa9O+umJrOKuEnJiofcPtKnVCk
         AmzMbyb+dDZeeT8HKrPOEaN+iQ0EG3bG6uRi4Yis84GBAW+kTTasvyZi8h5JUx6ZWlG4
         jJzSa4NOqQRF4MPb0MSLfIrSA89CxQ29h7YH7bA24UVRYtAFLC9tM0trdeHoIocPRb9W
         yocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766127322; x=1766732122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GicAORaQTtn70Bhd4n65cah4A4M454XvAKFCQLeoD8c=;
        b=py17frmnf2aHTms1Cai3SEP4+cBMWvVmO2NuIhvdWiJugLElFKWCxIiHpF3Mv13p2C
         c77Q2Rg7FauwwgsKs9Bt88KW8/J/ukZl7bYR2aMbghaVLo/VT6AM8QM2uTItfIQELKWw
         5EXrj6sGoJCDKMC9+ZBYLzcOwsauutLkCdDircZ2sCW9QLfA/MJmqBQ9qRdwkMVWfZvf
         6cEeguZGaz17+8w/4QppT8OVyO/vHq4ki6xx3oNnEyEYx78qtBbpwWd5qDIUXQRrK9vL
         bzggJJmc05ynWR+IDykpKlr8q/z3A+eF8SCsTjV9RoM9gs8AzpA30cYeUBBCitGQma1n
         rj+g==
X-Forwarded-Encrypted: i=1; AJvYcCVSxJjK6uBH+2EYlpuuKta2gqP9WfXHKKJrgT1rDP8M8SBdtBWklPXQwYXuQugsJ4+U4VNyrLrDXg==@kvack.org
X-Gm-Message-State: AOJu0Yy8T281M3P9a9cwgrsjoBdxDTGclnFpKJlU1nDIpXWiGj1jaWlW
	eMieBP9Oebjam/83E4VfeCi9ZRwEpCm74P44Dpt0ObfG8fSFXSjR64l2K2pDT5huTfaXvTl/aav
	huRn66AV0L6veUeSHB/ccHRdFuyT8/64SCWB6P5u+IQ==
X-Gm-Gg: AY/fxX5jLNMgWvf0vKlSLDNYH6pR+ZJs1Iyp4VlrYGCzo5qyLjXpNUz5Dwic9ZLpluQ
	CjAWgkUjlDlEh//Wlv+A/T3fYdqAfnNxP8+TVzlzZOWqsKAWb7vv0cVIzXxCl7xt2Hae0wIzNW8
	i/UNysIO3BBNQtS1BC2ngIFxTeHFgnWEt3FYPflUkbRlP2Sblf6Q6sIrUmBxFlLsIdYs9LxAB6q
	QIO4p9IKYoF+9Bl5cxMTXHy13hg94fFyV25zsAoJHXQUjEJefN7PcsfrfadJ6paMflBRhcWbArH
	wu/gMYV0pre18pZHFusPy8LZ
X-Google-Smtp-Source: AGHT+IHou/JmfF2RQNRr+BNX5nbXM6p2fRExcXxxWltOFGH7Sn48CRcP4gufZNoRYM5h+C8CtxTzr2wMwR5Fivp2QWM=
X-Received: by 2002:a05:6402:274e:b0:64b:8d7a:71d7 with SMTP id
 4fb4d7f45d1cf-64b8f214ed4mr1769650a12.32.1766127322243; Thu, 18 Dec 2025
 22:55:22 -0800 (PST)
MIME-Version: 1.0
References: <20251219030854.3527871-1-pasha.tatashin@soleen.com> <aUTzrnz3ZBm_APmv@kernel.org>
In-Reply-To: <aUTzrnz3ZBm_APmv@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 19 Dec 2025 15:54:46 +0900
X-Gm-Features: AQt7F2psjUUg-_HCNwgY0wO0vsLXifNun1OdtrT8zx9aE6aRw32yyAylagurnxg
Message-ID: <CA+CK2bDMcx-no18J9OA7zEfq6sdo511D=dW6igJciSyUhGpZcw@mail.gmail.com>
Subject: Re: [PATCH v2] kho: validate preserved memory map during population
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, graf@amazon.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, pratyush@kernel.org, 
	ricardo.neri-calderon@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C9381C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: 7a7fabfiqhxj9tf6zde1fqtfzit67zmt
X-HE-Tag: 1766127323-762627
X-HE-Meta: U2FsdGVkX1+cEKRBGIcruL4geAVihRFrK+dGKDw63WvASKHNPSMfR8Qe0JlCE5oUQfoj+TVYkYAKBdgEBWxneIa6N9bnso6x9Q1Yq5OYYDp/aX/MDdqDlo4nARpKkqScDKXv+IVrS4k0LEPMxKnS6B3/fujOzaTxTRgIsvN9ja7ftprAEMwQqOGeuBglAWfjBRKpxgoD/WUh+oNHtNjYw3SayHIeYaLYwe2I/Qj7YAj1pFLChOaeW/kRMDjGJLB6DoEVWwGV3hyvr+vPNcFgFzVk8zpGTLcGvPVEWxabasxiju99JfAGfdTytuCHqAFEIyoTIGqJOHv708lnUgwfHRu/qCFbiPdnVu929pMKwtP5R1J7lC6HgqeQn97wth6QZx5FUuwkpXvIekNSddEVxqbvX65i6DThDMQ7N5XMvmPehX8iR3lE31mHR0r83VNsBVKySjCHkEpfhZrIm+k9Z9wRq1u6n9tn15x9jwCTtJ5oaB7R/MtqUl1X4uRKaudrvVRMg5/E1nejLeYEQr8yllJkcGke9KRmTL+sNnGgnZfsAamw6q/tOjIz2DBBU4Hc/gPSZ3t1IxLj9LvtkF/jAXcSbMzesiPdmKHAtgDzugIPnoEjiR9u1fixGZDPT2jQszNyTVWwhKyLbJEhCl6N74QY+lPb0DK9QosiLC4X8RaBE86zEKTyzdS1XVKWOx1O51TbP69YToN3d7jb8iM2z+aSIz6NDkzWwSp+fWwCoeZzQZtOFGnoCf8l2acv7P8hm0gCIivlxoe7O9GFCR+sX4VlMbfpDdZNj62Qz0l6Ywu0SqQXXAhIOcphu/C7pj3a2YT9gmz7bxQDzkYx8BETMR5Anouoj2D4xz7H8rmyQ+yTYY0eh4sbdk3wtXLV2lXcL4FP5q7/h3ET1JyGK4SfRte85lwFWCa9u5P6/7aqy0BuV/YXgUKLZrJk418yKWSxeLCQg9zxgVPW14C8EZH
 NJYCuGvH
 RxKtrJn9VfPf3nFdRuR1yLXD+BHKLkBmTEBQm/dDrC0Vg4vstipjpkrGNbROl2RjkeUOcZIYli/Cj3YsO6svQKpYlcdhRUonIkhBRqV3Mecb9atJyLumBUWem3E5hLwLYzOfZrqOkYtbgVYzre98IMJTAMneo7gwQd+M7snFFrSu8XvPjbhs2xtk3ZaO6bJXc5lE/Rq1ZgYMGR4tW8h6lKH8uzsS87W4xe6ku1O70/8Z8xBKWs66H1DqPw9ZTBiiXM6psfMrRj5eS2bPWL3agbM8/0hA++qJAgNUWkiu02qiFHOHoi2LRbbEANsoXjo42OfJ9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 3:41=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Dec 18, 2025 at 10:08:54PM -0500, Pasha Tatashin wrote:
> > If the previous kernel enabled KHO but did not call kho_finalize()
> > (e.g., CONFIG_LIVEUPDATE=3Dn or userspace skipped the finalization step=
),
> > the 'preserved-memory-map' property in the FDT remains empty/zero.
> >
> > Previously, kho_populate() would succeed regardless of the memory map's
> > state, reserving the incoming scratch regions in memblock. However,
> > kho_memory_init() would later fail to deserialize the empty map. By tha=
t
> > time, the scratch regions were already registered, leading to partial
> > initialization and subsequent list corruption (double-free) during
> > kho_init().
> >
> > Move the validation of the preserved memory map earlier into
> > kho_populate(). If the memory map is empty/NULL:
> > 1. Abort kho_populate() immediately with -ENOENT.
> > 2. Do not register or reserve the incoming scratch memory, allowing the=
 new
> >    kernel to reclaim those pages as standard free memory.
> > 3. Leave the global 'kho_in' state uninitialized.
> >
> > Consequently, kho_memory_init() sees no active KHO context
> > (kho_in.mem_chunks_phys is 0) and falls back to kho_reserve_scratch(),
> > allocating fresh scratch memory as if it were a standard cold boot.
> >
> > Fixes: de51999e687c ("kho: allow memory preservation state updates afte=
r finalization")
> > Reported-by: Ricardo <ricardo@example.com>
>
> I believe Ricardo has a real email ;-)

Oops :-)

>
> > Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr=
.sc.intel.com
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> > Changes v2:
> > - Removed phys_to_virt() from kho_populate().
> >
> >  kernel/liveupdate/kexec_handover.c | 39 ++++++++++++++++--------------
> >  1 file changed, 21 insertions(+), 18 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 9dc51fab604f..6ba554208c81 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -460,27 +460,23 @@ static void __init deserialize_bitmap(unsigned in=
t order,
> >       }
> >  }
> >
> > -/* Return true if memory was deserizlied */
> > -static bool __init kho_mem_deserialize(const void *fdt)
> > +/* Returns head of preserved physical memory chunks pointer from FDT *=
/
> > +static phys_addr_t __init kho_get_mem_chunks_phys(const void *fdt)
>
> Let's s/mem_chunks/mem_map/ everywhere please.
> And the comment would become
>
> /* Returns physical address of the preserved memory map from FDT */

Sure, I will send version 3 soon.

>
> Other than that
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks,
Pasha

