Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCA2F531CA
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070C86B00BE; Mon, 13 Apr 2026 15:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020BC6B00C0; Mon, 13 Apr 2026 15:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51F36B00C2; Mon, 13 Apr 2026 15:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D1D1D6B00BE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:50:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93B9F1B7082
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:50:10 +0000 (UTC)
X-FDA: 84654573780.08.DCA9E60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7FE1B40003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:50:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XIQI+3Df;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776109808; a=rsa-sha256;
	cv=none;
	b=iiKSIcJT5q7T28s3xB/hknbk5k7Yfpe7W7jblJOkBC7iDrCmHrhA2mWGQijDNbOYDMzyPB
	PU9vN/ZqM/9tziYY4ajBitJD180PludDOdde4hcT3fGfAPo7qZfR0/GFpqHfJ7Pdx68PuD
	pypKv4m9a4U2sOg7/2egEYZ+Aw4Uhqo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XIQI+3Df;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776109808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFQYviYu5IERsK9WZ4rZwOi+7n5BFxSsKXE2pfOu77M=;
	b=mnHsxcWaNqO7I+4dNNaSKgdW/53MTjev7SJrMo94niH9g1/vC9YZdLIZmbNIErzvtTsUFM
	S93xlG4kczm66E+xeTG8n2QvcfzhMmYZFOTVOKxVv2HFqOAN/azFS/1/Nq/PuKepvLoF0Z
	NFy3u1042pMbbU2CD2VGxnhJW5hc5Pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FE6C44508
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B653C2BCC7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776109807;
	bh=oJxljyVFYnJlQ71cjOxsdi4l3kBeDgjEaeIU1wDEovQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XIQI+3Dfu1tgIlOd7I9GwqUKy/UHOa+d6+MTpZjl59E8NqsIHW2EmcRPPonI8lMe8
	 sIOIlYsx+sEBhXkKpnAXxSWNep6CkxYmGwJ3rjCuI7l4zWhke1LU+/fxOI5PTLAYEz
	 lhnJZmxwArId51Z8KA/e/gf2lZ/ksGe/+1epkfXkvgt3JLMmgCSnGmDOpCnREiO83a
	 1UoPHwUHw0vZrWO8GgUTfB4Yjx1PpBtea7pv7IWEvQhDzfIQtPLHP2i0YuLrnRurle
	 p+xuDMMxw0joJd9Ig08+k5XaPOhh1KTTAqaDIjO4DC1HyIKLWPp9ya9PAN+xGgq0UV
	 nZSWf0JDuSZcg==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8a4b8c3a30bso54266026d6.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:50:07 -0700 (PDT)
X-Gm-Message-State: AOJu0YzoL0yIelEBIM3HXmIhtvEa+0Hv2p6oqguc/KwmBd7qc1iFlfQj
	v/vZ/cke0y2ts5WCz2yw9C9O6Ch/nSlLm2ZORJi4fm4HcPurld/5k2H7eW92qRXV0ZnozGqcO2Q
	cHz+DDX60vocaNf55DlkUO0c+3il+BnY=
X-Received: by 2002:a05:6214:c6d:b0:8ac:a57e:ec1f with SMTP id
 6a1803df08f44-8aca57f19a6mr113901546d6.29.1776109806510; Mon, 13 Apr 2026
 12:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-5-baohua@kernel.org>
 <ad0Wyq5--L0SeIqr@kernel.org>
In-Reply-To: <ad0Wyq5--L0SeIqr@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Apr 2026 03:49:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zuBXjm45w3h=x=iK8weVEajW_yaksXa35w0eBK6eoyxQ@mail.gmail.com>
X-Gm-Features: AQROBzA1k3Am_KfJGvo_jQMK1NqwlYnHYsaB7gQDCvz7fR6iifxM7skZxpHGLhk
Message-ID: <CAGsJ_4zuBXjm45w3h=x=iK8weVEajW_yaksXa35w0eBK6eoyxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/8] mm/vmalloc: Eliminate page table zigzag for huge
 vmalloc mappings
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com, 
	ryan.roberts@arm.com, ajd@linux.ibm.com, david@kernel.org, 
	Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jgq9k84c5f46i34h7ewyhgo6mieckmok
X-Rspamd-Queue-Id: 7FE1B40003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776109808-951404
X-HE-Meta: U2FsdGVkX19aCC3Iu8mQKUkPhDGSvV62c1ijbE589tGUNNpdJJ0WF0Zkau7+jMDoQ7SDlTOuxsz1/UGrWt+zU7D/6YXcBWRVJn8NBiv+YzH3FRZ5hz3lwW1Vuv5mJExXxNEhcA9YL/W3LLrt1xJmY1f3NFTHPMcQnhwNGUPugMn8bBdcD+NiSwgNiwXmRflpwK6RNPRKTxF0f1TBelaFnNHIQNElq0huRDHJCUCgbcK0uw8RwALXCTZE3ezFDPQQ5m+ojF7Ziery/KlZH1nPmU3Wpe419q+oSqNMUr+YfCSw3agOJ2uyUTEwl3Hxu4cNNXyT/1zfjtRpeYr5q8bIdFFT599hj4zBkHgwJJJKAq++eZR3Y3N3vcFRb5RN91cwLeHaM52/f0P+Nu8GxwzIPHzJBRZmv+154W//zJTwUssWYgBXyhNh5RxFzNPgrNbrhpExRWqCjxEBF/lTFAq3AfY2Lm7LyDl9GLw7xgn0KPAVbkthxSmubaBtSw8cvTGKJK4tkPpJERsLYwD4lMUjy7WB3cWnS9oJn7GgmKNYUNgpXJ6AKrWJHLVrRsnwGV4pVOzxXn9WJD/mLeUSRX/L2HIB6j8coyE0YLgBZ4lJgiFOdnJqXiDqJEkyTixdrSjpQm/cCo+sXxBwi6CwKujuvc0HEeVfcB4VeiFomzOgfAMydK7yoytrlgP3ssJycC8vLVqLonNUPrZ986ihVAlSXST3fQ/0zlQVv/uLc5ijaunaueUwUklIliTa6/62wUYtXmvEHG9izTU/OzzwOZG00F8ad3ONnQ1h3U1eAl8ewnRVE/+18DpJq6d4P0TsA57IcokTDxcyrMOV6z0I/0KAkjcXU+HrKi7ethaEwcz+OonPawSmg+Bb1tp6Nypk1CQvUcdlN1cpZoQm4I5cK4pRvARWM43otAz8Qm0DhT8nYkzcfSkjm8Xcs7Kseo2FvyVBT4UUk9nVF7e4O9AsL62
 tpvyxxwT
 YULeU1YwnCn+NqVQa6DehCT0y1ltMtBJLGrcc7cLGG5YlPbqJQJt8LKZkKO8SUDoCS56YqgClLQrvEnF+oU5zWlA9T10Lj3Votr5YaHjefQDPg2DLHxmjHrlEKyeneaoLxvo8j7LiFSNCpOKjGbwnuAfKmCFwzarkjUvZtC+kRqE3c+zg5gVzMXDlCVZBogld/lJ9n9kv7zjbcm6m1f5O1XY0VxXCAvFR1LMiC8D7fYy9k1WcwD6uo3MctVTJHaOvt1XRjUWIWnK2rG6cAGaa5h+6TGKHeNxj9N3LgB5Nt4ZrXCa9d/VXs1OWg6ams8G8Q9b3voN8YHUI1EUC6CPRY5t306If64VDLIet881UCfZDK+w1K4lShYsVmYXT/Y2hfJAJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 12:16=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Wed, Apr 08, 2026 at 10:51:11AM +0800, Barry Song (Xiaomi) wrote:
> > For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer
> > need to iterate over pages one by one, which would otherwise lead to
> > zigzag page table mappings.
> >
> > The code is now unified with the PAGE_SHIFT case by simply
> > calling vmap_small_pages_range_noflush().
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmalloc.c | 22 ++++------------------
> >  1 file changed, 4 insertions(+), 18 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 5bf072297536..eba436386929 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -689,27 +689,13 @@ static int vmap_small_pages_range_noflush(unsigne=
d long addr, unsigned long end,
> >  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >               pgprot_t prot, struct page **pages, unsigned int page_shi=
ft)
> >  {
> > -     unsigned int i, nr =3D (end - addr) >> PAGE_SHIFT;
> > -
> >       WARN_ON(page_shift < PAGE_SHIFT);
> >
> > -     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > -                     page_shift =3D=3D PAGE_SHIFT)
> > -             return vmap_small_pages_range_noflush(addr, end, prot, pa=
ges, PAGE_SHIFT);
> > -
> > -     for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE_SHIFT)) {
> > -             int err;
> > -
> > -             err =3D vmap_range_noflush(addr, addr + (1UL << page_shif=
t),
> > -                                     page_to_phys(pages[i]), prot,
> > -                                     page_shift);
> > -             if (err)
> > -                     return err;
> > +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
> > +             page_shift =3D PAGE_SHIFT;
> >
> > -             addr +=3D 1UL << page_shift;
> > -     }
> > -
> > -     return 0;
> > +     return vmap_small_pages_range_noflush(addr, end, prot, pages,
> > +                     min(page_shift, PMD_SHIFT));
>
> Wouldn't vmap_range_noflush() already "do the right thing" even without
> changes to vmap_small_pages_range_noflush()?

vmap_range_noflush does the right thing for the contiguous physical
address - ioremap case where we map contiguous physical addresses
for iomem etc.

for pages array, they are not contiguous physical addresses. they might be
multiple contiguous physical addresses, but they are not contiguous as
a whole.

>
> >  }
> >
> >  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> > --

Thanks
Barry

