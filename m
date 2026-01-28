Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C315ED3F071
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 14:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011AA6B00A4; Wed, 28 Jan 2026 09:35:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01096B00A5; Wed, 28 Jan 2026 09:35:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3106B00A6; Wed, 28 Jan 2026 09:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C68A56B00A4
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:35:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FFCF1406A6
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:35:02 +0000 (UTC)
X-FDA: 84381619644.19.BE78604
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6D29B40005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:35:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6t7Qu64;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769610900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhFge7Zc5F2kHYYk3c6Ukwi1tTUU8E/SmQ/BFpvdQIM=;
	b=7fl4dHein315SpX6yw3eitXU+KIJXOiqVKoEo74VKVWONSJlqGH1QTjgV/qzTK+FZkre9X
	z8n/EeaFNtIMDmZy6xxE8TnqjgpRpu+Fw1yuVOx3pPKJ4HFVGxl06ULcpoiD9CrUG7W1r4
	MRLJGV7lSiIGJvs2fR9N9earOEG6xNc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6t7Qu64;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769610900; a=rsa-sha256;
	cv=none;
	b=kjNW2wE5IBX6fN6i+N70ynkHLVj/QRleZSw09YsnuJVuzCupgsX4yr98kLGZhAc9NF2KR9
	hZli4wbb1VgX6w2s5eWXWNx0/bKi38zwnWVojz8CukwPbngn/VYV3p9TAJr2J7UgW3CcQz
	IPz8LNDkiR/lK2lYGHkAuTRaIUvR5BM=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82307c6902eso3221302b3a.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769610899; x=1770215699; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HhFge7Zc5F2kHYYk3c6Ukwi1tTUU8E/SmQ/BFpvdQIM=;
        b=K6t7Qu64UfzWt3s9JVAQ6g7vUmNnercO+1JXtg7A8LzsZ3sjw3B65U5PwYeHcwv8UI
         jvezJfvKjfo73iWZc/GUWuD0RUc+hVSTUjjneBX14ipVP1M8Jl9JW0phpmMABuPY2rzI
         krbGFAH9w9l3wUvRuXQryY52XUIPXUXGKywbh+zMWTsmX+HZGn5TYXzDOxdzC7+ch+tt
         MIxhmG2ZKUMyotMDnCqbpxcB1VeXXCBZGWes3BuJdaqasV7dUk5Sr2Pgxm6d1VzYtxUy
         BKBtLD0FVq9c6TXDAFXFlEBXJ41XbBaGRo6tTpxu2y4Lv/ldqARg+sJyVEGwgKTleePo
         KWtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769610899; x=1770215699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhFge7Zc5F2kHYYk3c6Ukwi1tTUU8E/SmQ/BFpvdQIM=;
        b=XS8cXiftRlNdtOmwF9NKPgtJo8FXeoRF5iaPCcoNpW2/ZywCJ7i9SfGGhHaTjInPmx
         y0Pu8d26clzQnr7ZHyEN0dFdp9IyKBzPBKIL47SbUkuwh41/TbxxbBOcLN1CuJxQ36yL
         Ui5MprEcoUTkgvp77Y5Q+HPvr40tC1o9h0wWi8Vt+mWRa42qoo21KobBArx7LuE7bxf/
         nSg+FpcVW6u4hWbVWCaAtTrNIMxxAnM+RJprn4JfvPrkevpMJyYkcq8Ld3FThGpbacsx
         rWbEm3nAExInhLx9UmeBpBm1qAlmuwoBL1RjfE+zTlWxXjXsD0wkmxYdqrqufqWjTkGx
         BWSg==
X-Forwarded-Encrypted: i=1; AJvYcCXyffx0XGlo5GxaBRe7u5vGU0n/wgX7/u4lYI9XW/nceRJ9yx5CByxUpG1lhBvcFOlZuE8kuI7WNQ==@kvack.org
X-Gm-Message-State: AOJu0YzYBGwinsg8XUQOvLSDsdBlBuybd4+QlGqh+L1mh2xTnclQSSrV
	20cxyMvFrd0QcchiiR3iBgQQ4BClrt+Flf0xMtz7aIchXOAWjMnnCVta
X-Gm-Gg: AZuq6aIj39ebWuHbBfMAqCpoejSoPU89go+3A6d4+ins/EvMOclsSzchb+miH/8mx+y
	V+dD6TpLsYvRNo4UH50+4hEItuDQndcAfqnWrdnOCpABLP91vdQ6kO5j9RDQTiiPTJcgfCTtRXp
	MkztX/idzlO7StiAxc10Xw5PNM0WY7DqTHaui4d1a5qerpBCSTqwfQOp5VQKvrJYr29RMfuJIPF
	S4ZCI1CoVi7Qxx/aL8kYSIV6nVeZitpvGQK2xFY8UEVD5hKFCtrUQLM1nL5yQymcGvjBexK3vrQ
	OQ6UV1gEjX5zX865ng+mWbCGYjyHJk/mohrlL0rtVYyT9RTxobnDgWHlc4ZodlAIuqaKLb3tysU
	OxkJbQn7LQiLc8peiE75JwBFeKiWRMojmi/JbgjjydV0gtw12h1g01awhyuGdeRq18iFpejTwaU
	Q3NFt5C3N39pBDkv27SnetuBjH/U9QBfb4GB0=
X-Received: by 2002:a05:6a00:1ad0:b0:81f:3bfa:f0da with SMTP id d2e1a72fcca58-8236919d370mr5421302b3a.29.1769610899035;
        Wed, 28 Jan 2026 06:34:59 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379c1fc6esm2829879b3a.47.2026.01.28.06.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 06:34:58 -0800 (PST)
Date: Wed, 28 Jan 2026 22:34:50 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
Message-ID: <4exllw7pf4yfhfzpyg3ictsnznf5lepv5tjd7zvycldjwmh6jm@j6rara3ogrux>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-3-vernon2gm@gmail.com>
 <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D29B40005
X-Stat-Signature: ywskxwd1sw8kdsnb3n83qzphofqfmjor
X-Rspam-User: 
X-HE-Tag: 1769610900-890847
X-HE-Meta: U2FsdGVkX1/b3S0Yz9MGvnUPGj3eiKc786WeZVa22DYMNUa0Ngyw+pQbTRduXPOYa7pMRERB5S6SgYeL/1hsv0nx0SZjYgi2bSmP6UmjagpQb+74xXfUuA/9WnNykwFAgcgfyQLFFoNkHV8hW2Xj07MRrYqNAmCXlVtn9R8LuUg1hsggcpbn3bIBzj1PBX31p1cbrEZCJWAuQii/8syAdokJhuBaKb0PWYCEkELrXYimDgHOUsx9jNIu6pOUd/3sFtvxsxH67YnHZXCMw+31WFvvVRhDUrKBFC6sxUW1hV7KLfAfALmqAPCs7yZ0JHKIE8tK1TtCNUggcUNUV5KS7X+tPB8sbrobSqMbHDb5GG+G1tVVUAxU1JWwtTH0Yfa34a0A/lKQ76AVdnVO53O0mixAKj4RhPG15EtdJglXpHvOmFC2J5EBh38TGDuhTYAKUQRBnJGVfS/Ni+ucmaDQ137TtcOd5Ts4964NXFhFsLCQBdjp1q23Qj8gc8Jv9Ie+iWn8IltvuYN0FEohD7VU7w7JuKchszeOFyjN8naBN+1Jef+PTOpqe/mgZ2rfE4WGekqng3iJ87v/uWelbtLFwdunOdrZQDyRYF/jYsqi9L8tIBGp9i2gWOnkzZLrQ2DZUhIEiCWHG9CkacROFUzkaYli7fkNkcsqui3zPh78ZKfUoMoHDj0MH+vxWul2JRmDM75cA5lV4yRDwV+50HnRf8qPzzRmo+oZGLVnOUPrmkKxQ253H0f3dDSSO1ylpjeqZHLciPAwIwQ565KvzMWHONHe9uQZmFknjvCw7XNpxoY+JhrY1+ATPsPhq1UO0lGL2LblBdYDVDwHQm7H+N7owfhmGADIH+mlrpD3L1CPbG6rk1uP60AvHhZtaSwxr2m7FFgOV1w5XsgA3yyQ+2cNL4k8zPvmcPgUlztkPLw5Gt9xCIBgp7bkKDE8Sxt8W1oZQTd9dBhcxAAeFs/8td4
 Dy2n4sNy
 pJsccsWwXz+WdnVQHLGkH1C31x2Ljg1ca26nGHRKbNKbovOeAbLYszFrTYOW1pUFojWur4QBDWtGNO4GCNt9xDn9ZDvogDFhI21zCLBMsShMQYx5NJ5IUL0uohfWh1liy6c7ky6tcb/tNbTGrdDA/t5sDeZMfC31vCgoNsYUKQ8irOtk9pq8mHC8u53+eeGfLhd/4D/oUP9pWTF/RLs3dehnDl+tlhQEJUj4fcQqKBKJHn7qH68JP/ci8KGOmklP2rFaGs9wHTtPIz9AGNqCMFqltQzHfaNkFl3H7OpvkEHTd7Tt0e/LU+2Pi4ZCzNPsgtojc2VlRgIwyryyl459Bmhgx7IKmlIXKo6spr3YcREd4JemGoc3BpDi1rAPgEMg09dsBLxII6rCPNz9KvG2JgqyvD2E8mEsltyAEuQrboTdiS8wv1KXMDAMH18wjXA5UYDe67m+xMLwfSrMcGLmZndu/9Kcrjkd8P22crSRvzsoXDC3L46XNHXNvAx4TXK4hs0QT5jB+vBt2lVi6OsXGdYpGAv45VGSHvzKsFnX+MTU3N+8B8QZR6SQDfXdqQbL9eS9L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 01:59:33PM +0530, Dev Jain wrote:
>
> On 23/01/26 1:52 pm, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> > even if only scanning a single PTE/PMD entry.
> >
> > - When only scanning a sigle PTE entry, let me provide a detailed
> >   example:
> >
> > static int hpage_collapse_scan_pmd()
> > {
> > 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > 	     _pte++, addr += PAGE_SIZE) {
> > 		pte_t pteval = ptep_get(_pte);
> > 		...
> > 		if (pte_uffd_wp(pteval)) { <-- first scan hit
> > 			result = SCAN_PTE_UFFD_WP;
> > 			goto out_unmap;
> > 		}
> > 	}
> > }
> >
> > During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> > directly. In practice, only one PTE is scanned before termination.
> > Here, "progress += 1" reflects the actual number of PTEs scanned, but
> > previously "progress += HPAGE_PMD_NR" always.
> >
> > - When the memory has been collapsed to PMD, let me provide a detailed
> >   example:
> >
> > The following data is traced by bpftrace on a desktop system. After
> > the system has been left idle for 10 minutes upon booting, a lot of
> > SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> > by khugepaged.
> >
> > @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> > @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
> > @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
> > @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
>
> Could you elaborate what is [1], [6] etc and 1,2,142, etc?

These 1,6 are value of "enum scan_result", you can directly refer to the
notes on the right.

These 1,2,142,178 are number of different "enum scan_result" from
trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file.

as example, SCAN_PMD_MAPPED has 142 times during a full scan by
khugepaged.

> > total progress size: 674 MB
> > Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs
> >
> > The khugepaged_scan list save all task that support collapse into hugepage,
> > as long as the task is not destroyed, khugepaged will not remove it from
> > the khugepaged_scan list. This exist a phenomenon where task has already
> > collapsed all memory regions into hugepage, but khugepaged continues to
> > scan it, which wastes CPU time and invalid, and due to
> > khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> > scanning a large number of invalid task, so scanning really valid task
> > is later.
> >
> > After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> > SCAN_NO_PTE_TABLE, just skip it, as follow:
> >
> > @scan_pmd_status[6]: 2
> > @scan_pmd_status[3]: 147
> > @scan_pmd_status[2]: 173
> > total progress size: 45 MB
> > Total time         : 20 seconds
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/linux/xarray.h |  9 ++++++++
> >  mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
> >  2 files changed, 47 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> > index be850174e802..f77d97d7b957 100644
> > --- a/include/linux/xarray.h
> > +++ b/include/linux/xarray.h
> > @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
> >  	xas->xa_node = XAS_RESTART;
> >  }
> >
> > +/**
> > + * xas_get_index() - Get XArray operation state for a different index.
> > + * @xas: XArray operation state.
> > + */
> > +static inline unsigned long xas_get_index(struct xa_state *xas)
> > +{
> > +	return xas->xa_index;
> > +}
> > +
> >  /**
> >   * xas_advance() - Skip over sibling entries.
> >   * @xas: XArray operation state.
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 6f0f05148765..de95029e3763 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -68,7 +68,10 @@ enum scan_result {
> >  static struct task_struct *khugepaged_thread __read_mostly;
> >  static DEFINE_MUTEX(khugepaged_mutex);
> >
> > -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> > +/*
> > + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> > + * every 10 second.
> > + */
> >  static unsigned int khugepaged_pages_to_scan __read_mostly;
> >  static unsigned int khugepaged_pages_collapsed;
> >  static unsigned int khugepaged_full_scans;
> > @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >  }
> >
> >  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> > -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
> > +		struct vm_area_struct *vma, unsigned long start_addr,
> > +		bool *mmap_locked, unsigned int *cur_progress,
> >  		struct collapse_control *cc)
> >  {
> >  	pmd_t *pmd;
> > @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >
> >  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >
> > +	if (cur_progress)
> > +		*cur_progress += 1;
>
> Why not be a little more explicit, and do this addition if find_pmd_or_thp_or_none fails,
> or pte_offset_map_lock fails? The way you do it right now is not readable - it gives no
> idea as to why on function entry we do a +1 right away. Please do add some comments too.

If this way is not clear enough, we can directly add 1 in
find_pmd_or_thp_or_none() etc, BUT it's a bit redundant.
Please take a look at which one is better.

case 1:
as the V4 PATCH #2 [1] and #3 [2], only hpage_collapse_scan_pmd().
[1] https://lore.kernel.org/linux-mm/20260111121909.8410-3-yanglincheng@kylinos.cn
[2] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglincheng@kylinos.cn

static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
		struct vm_area_struct *vma, unsigned long start_addr,
		bool *mmap_locked, unsigned int *cur_progress,
		struct collapse_control *cc)
{
	...
	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
	if (result != SCAN_SUCCEED) {
		if (cur_progress)
			*cur_progress += 1; // here
		goto out;
	}
	...
	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
	if (!pte) {
		if (cur_progress)
			*cur_progress += 1; // here
		result = SCAN_NO_PTE_TABLE;
		goto out;
	}

	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
	     _pte++, addr += PAGE_SIZE) {
		if (cur_progress)
			*cur_progress += 1; // here
		...
	}
}

case 2:

static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
		struct vm_area_struct *vma, unsigned long start_addr,
		bool *mmap_locked, unsigned int *cur_progress,
		struct collapse_control *cc)
{
	...
	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
	if (result != SCAN_SUCCEED) {
		if (cur_progress)
			*cur_progress += 1; // here
		goto out;
	}
	...
	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
	if (!pte) {
		if (cur_progress)
			*cur_progress += 1; // here
		result = SCAN_NO_PTE_TABLE;
		goto out;
	}

	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
	     _pte++, addr += PAGE_SIZE) {
		...
	}
	...
out_unmap:
	if (cur_progress) {
		if (_pte >= pte + HPAGE_PMD_NR)
			*cur_progress += HPAGE_PMD_NR;   // here
		else
			*cur_progress += _pte - pte + 1; // here
	}
}

case 3:
	current patch, and add more comments to clearer.

> > +
> >  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >  	if (result != SCAN_SUCCEED)
> >  		goto out;
> > @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >  		result = SCAN_SUCCEED;
> >  	}
> >  out_unmap:
> > +	if (cur_progress) {
> > +		if (_pte >= pte + HPAGE_PMD_NR)
> > +			*cur_progress += HPAGE_PMD_NR - 1;
> > +		else
> > +			*cur_progress += _pte - pte;
> > +	}
> >  	pte_unmap_unlock(pte, ptl);
> >  	if (result == SCAN_SUCCEED) {
> >  		result = collapse_huge_page(mm, start_addr, referenced,
> > @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	return result;
> >  }
> >
> > -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> > -		struct file *file, pgoff_t start, struct collapse_control *cc)
> > +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> > +		unsigned long addr, struct file *file, pgoff_t start,
> > +		unsigned int *cur_progress, struct collapse_control *cc)
> >  {
> >  	struct folio *folio = NULL;
> >  	struct address_space *mapping = file->f_mapping;
> > @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
> >  			cond_resched_rcu();
> >  		}
> >  	}
> > +	if (cur_progress) {
> > +		unsigned long idx = xas_get_index(&xas) - start;
> > +
> > +		if (folio == NULL)
> > +			*cur_progress += HPAGE_PMD_NR;
>
> I think this whole block needs some comments. Can you explain, why you
> do a particular increment in each case?
>
> > +		else if (xa_is_value(folio))
> > +			*cur_progress += idx + (1 << xas_get_order(&xas));
> > +		else if (folio_order(folio) == HPAGE_PMD_ORDER)
> > +			*cur_progress += idx + 1;
> > +		else
> > +			*cur_progress += idx + folio_nr_pages(folio);
> > +	}

The "idx" represent PTEs number already scanned when exiting
xas_for_each().

However, the last valid folio size was not counted in "idx" (except
folio == NULL, "idx" equal to HPAGE_PMD_NR), which can be further
divided into three cases:

1. shmem swap entries (xa_is_value), add folio size.
2. the folio is HPAGE_PMD_ORDER, the memory has been collapsed
   to PMD, so add 1 only.
3. Normal folio, add folio size.

Is the version below more readable?

	if (cur_progress) {
		*cur_progress += xas.xa_index - start;

		if (folio) {
			if (xa_is_value(folio))
				*cur_progress += 1 << xas_get_order(&xas);
			else if (folio_order(folio) == HPAGE_PMD_ORDER)
				*cur_progress += 1;
			else
				*cur_progress += folio_nr_pages(folio);
		}
	}

> >  	rcu_read_unlock();
> >
> >  	if (result == SCAN_SUCCEED) {
> > @@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
> >
> >  		while (khugepaged_scan.address < hend) {
> >  			bool mmap_locked = true;
> > +			unsigned int cur_progress = 0;
> >
> >  			cond_resched();
> >  			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> > @@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
> >  				mmap_read_unlock(mm);
> >  				mmap_locked = false;
> >  				*result = hpage_collapse_scan_file(mm,
> > -					khugepaged_scan.address, file, pgoff, cc);
> > +					khugepaged_scan.address, file, pgoff,
> > +					&cur_progress, cc);
> >  				fput(file);
> >  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> >  					mmap_read_lock(mm);
> > @@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
> >  				}
> >  			} else {
> >  				*result = hpage_collapse_scan_pmd(mm, vma,
> > -					khugepaged_scan.address, &mmap_locked, cc);
> > +					khugepaged_scan.address, &mmap_locked,
> > +					&cur_progress, cc);
> >  			}
> >
> >  			if (*result == SCAN_SUCCEED)
> > @@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
> >
> >  			/* move to next address */
> >  			khugepaged_scan.address += HPAGE_PMD_SIZE;
> > -			progress += HPAGE_PMD_NR;
> > +			progress += cur_progress;
> >  			if (!mmap_locked)
> >  				/*
> >  				 * We released mmap_lock so break loop.  Note
> > @@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  			mmap_locked = false;
> >  			*lock_dropped = true;
> >  			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> > -							  cc);
> > +							  NULL, cc);
> >
> >  			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> >  			    mapping_can_writeback(file->f_mapping)) {
> > @@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  			fput(file);
> >  		} else {
> >  			result = hpage_collapse_scan_pmd(mm, vma, addr,
> > -							 &mmap_locked, cc);
> > +							 &mmap_locked, NULL, cc);
> >  		}
> >  		if (!mmap_locked)
> >  			*lock_dropped = true;
>

--
Thanks,
Vernon

