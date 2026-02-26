Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84FF0FCE095
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F886B00B6; Thu, 26 Feb 2026 09:31:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CAC6B00B7; Thu, 26 Feb 2026 09:31:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B8A6B00B8; Thu, 26 Feb 2026 09:31:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 911D96B00B6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:31:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45DB0160127
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:31:45 +0000 (UTC)
X-FDA: 84486846570.19.2073DD3
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4D077C000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:31:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TSuprh03;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772116303; a=rsa-sha256;
	cv=none;
	b=AqQ5DY2mjMNGxb5USOtXGkYX7zKb1SXACCgB/dza9FsNUrvZtv2QMnHb2thrU2ty5rUZ6E
	SqGywYY7cmxd7mim3ju7YNcPWmA/BQ9Kuu7vHunqKzqrTaUkWpfaABwfr2K57B7EVmLZ0K
	GvZICx7esCjDVHQJbaQrmS0Z7TPhrdY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TSuprh03;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772116303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cthuG3bjITdl3wd51K6QVFySe74BJ7q+Ebd3+GqNmz0=;
	b=4a6hVsGrwb3UlAt0vLrpr2KVY4PdFSf2XjFzHB8cHQvSrcTELn6rt+zSjH8bM/Jr2V7BMO
	nP1Ymsy09LJrXi6zqGdBCmbX8XPutyUPF5cRwbxK9RT2bLWKCwt1/wHg6IxW9WB35gnXHL
	VYQ6/W31bg3Zw11m6uvdZgHNTBiQZh4=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c7103601c8cso300142a12.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772116302; x=1772721102; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cthuG3bjITdl3wd51K6QVFySe74BJ7q+Ebd3+GqNmz0=;
        b=TSuprh03CBskBIIxS+1Wd7eD86hdM4g7f5mMMFTBsoTMJu6TIDUpcISD0F3iIkDDW2
         Qu3c6Zy9iWonjE1z21rc12LSBoLsonU6x84HtLMjaKffIvDBJUa+ThVKj/z5tKKUZYUb
         EZeLR2aGYe6s2K+IC0vT3QbEGkwkWDF9GGhEiz1Xro9J1iwXkTvyOoC6Fv7vT9ln20n6
         pSt5DJ3jLgPC+tfmk3Qf+rGSArUHhSBCiw9pYzJiH37QeTuJtAY9r72S7Ic8njO/RsfB
         YgZPsWgRYyTG7PfqhAf0QReLSpt/Eu0Q6jFmFnE/LJXZAcD6rPFrHkSGyJ/ByOkO+apm
         dE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772116302; x=1772721102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cthuG3bjITdl3wd51K6QVFySe74BJ7q+Ebd3+GqNmz0=;
        b=fZBf60tRFtzemRDsdN1KXTH/l2CLhpiXRnvSz6qbJZ7Vml05Oq8fTgOBqLQnygnV/I
         LpYGXRS2CGEosZNQkCAGwhaX9j/roxMnviybfXkIOJyIBkzBLtQ8XVdH7FqdhOlsMlBz
         fDWDaYW7h/g+iS2izsMh0BNG5OeY0/oMUK7hXF4/gklPlAPesMm9qQn4N/25Zodod2u9
         xl7TLqbmJgaMBrh5k3xxfUCAtd2teti143ID79bxuX3MzUf6cRw0WKhZxxo3t9a30gn3
         L0OnqQszg16suqguPy6PY2bBzpuPhQnHokswlkhZxuUEY5ueTauMT5Vz+l9WWHHJG9qo
         Cz4A==
X-Forwarded-Encrypted: i=1; AJvYcCWbWm0LGQK6LeVcufhra0EIES+lIfBrBmSz8hcSo+ETipfbBHsoHpUymygiAiZHHNkwu5ltrmhf2w==@kvack.org
X-Gm-Message-State: AOJu0YylacHXrm6OxipLRalSchA4NMGdM34B3ur5izhn/iim6qo68RsK
	z7kQYaviSPxEjlXkQrP3xu5SDCbVm/nU0728h2bVx281liMD4qd6esJ2
X-Gm-Gg: ATEYQzyq0eSSF5Mr1qw9atbSDu4mK3a61SQpzJBeL42IUpYA9SySpUuWHcp+2hBRshC
	I0dTWAcISVZZ9ZQ9MAkizDmPT66K206bPC66/4T5cZ9U4wxK09vAmihgoXJBwxv0pQmnwMzdkcA
	htxODki9wMCH9I1UrStYs6AWAdQLWRpLK+bpTRUyeis/G2vx08qLb9l8gRkcBcKKKoZwF3pTRhz
	GqTQbDXuKc/a+kUAeRsH0JAsX6kX9fQYqvjGc1vCKKvjlnYdOTXHb1VfbQHSRkJ1xioxsDIiELY
	ZrL5QkRssawKDUQoE/AVfsPFU5ZPXfDfnVUVVMcUJ2wN8AisJCM3lI6ilGVZFwJ+aYYB4CdlmpD
	xg1m5pv3U1wCNAsgdI/6VmXhlMKThTxtoLkfwiyVgZE8PG9aKRk9F1WikemVCmnW1CFGPAW0hrf
	tCUw3hhbaCqyB9vl83FdaUrWtLSLIVUcIUUoayxmHiqVGoC0H5GvxO8qggcCr/Vfr1XCEEQm7jp
	+uxiA==
X-Received: by 2002:a17:903:35d0:b0:295:24ab:fb06 with SMTP id d9443c01a7336-2ae03465292mr22316305ad.22.1772116301781;
        Thu, 26 Feb 2026 06:31:41 -0800 (PST)
Received: from localhost.localdomain (n058152022206.netvigator.com. [58.152.22.206])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b0691sm35583035ad.11.2026.02.26.06.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 06:31:41 -0800 (PST)
Date: Thu, 26 Feb 2026 22:31:34 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org
Cc: Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master>
 <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
 <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
X-Stat-Signature: 68tegi7bi71nhozzdctz96etdfazjssb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4D077C000C
X-HE-Tag: 1772116303-21167
X-HE-Meta: U2FsdGVkX1+8LlF1aiztLJ3iMxMxFu2jXbR83yJzj23HUUgIgtQTA0V+d94z2BTws1vRepETtW8Fhmj0L2W2q/IL3XOOGqSD/0WMv3vOb1Vz2NsbkSz+rO6m2xXIcLKtG6hrmOjQG5+f99RVH5DyPJJTIwZlROnLGO3x/CssLYM77LTXiIYJG8/0VF11xi4/nK1eWA3g5QRMNPlPhVN9/edh1iKcTxv9qYLwLjEQpoXFjcuPO1MKJGFFVShK3ffjfSDumbXrz/fkUTXqHjGl/PEe1eLKXOWePVvkBvMBecF0u9cdX/Vl4du9ls5svF1h8NfL0e8sP3W614e/ha8d/4/vpENDbXwGd74Gg9Qcr3owYYp9lEF1eK/AybTLTjfri/b9lqQ9BXWUCbuXoPzfzXGwvPJ1ZXA5b/v6VVER0drWE0MHmFuzVr+gPs4doW/TV9luS5evamtenW9k3rgEe7rk17p8Bu1vBQx5DfdqqlsTJFwlZdVRZGtwAmvYqMOGSx92OBDs8M+kPo7eip3CUv9cVx94p7/wuvvjTjfYw+AkucpOYZDaFDXYmMHyDjO6lG45N4QCu4QLm59E/uyYwM5THBRJubRE6Me5sKQaBUVmQ5ehYhpgv/Kqyy/IU91QpKnNIP8RGbzJ2CRUkZhX8sqTzakXWy6fTRLdHeBPImW0r3rOPd3MAziaEacI5ATvzdNC+deRlONSkTWk9U3lx1eUaiede0ZRwdN+z3uE5YKCTw13H5XOZF5vFYyhol+rHX1bqa/dXxkpdHhWFGKjTbmVCXE6iwSLyUFGvsYtkuwciq1Vwx4NmvHRPD1wBxG/0oP1w4L1+IIznQVDZ6jQTf+LnB7bmFzIKcVowxF4aRcR020cGTg44/F7eHJ4KT2v0b14pOHmENtWDOaZbFsNxRiHFJMibwID8rJN+3MwHlnu+FR7CvUpxscR7VujQStOsEMZels4sRzqR8dRVfn
 2JT2EwA/
 p/cmu32RMahq72iGRo2hcfTRTRsve566kjt7FvMZde/C1+McdbAUJ8FwDp8PxC5NpBhdd2mrVLbtBGKOG5v3gSv1SbTPwcWLKGh3/K1x226+CyJFZg/DXVqv62S2zM2BhAWSm0ZcTXutJNTifYL2A5Px23VbD8XIUGQcwtIgiSDC2KtbrfpoYm47SlgPESdeiIwHk/lHCuZo4qfl8ylyPzC8MDDzATKydsSUw2dhwVokh9RS4/dVOPYtkR4Jnie+coQpFAdf4Cg62rRgf8Z37wlSb9Mv5EAxYHp44Vmj6gC4k+jrc6aIPWUX9xZRuFEykCoE5BNAEdGFl+WdGVAah+rgAaJrWUsk1bR2OZ5kjY+vHVM5OepKyNTSGt55lDoMWK7V3hRsNW+mE/PPWTIgLOGhNPkaFA3tNqsg84m/5laOht5QZo4NZ5BYFrHXeANIbpGMiZvy3qoUB7M8aCKfEKoiK/ofi/JCE7ZG52oo20ObONRdyvmOq5c+0q+2f5jxX0NsqmknY+JMGQQDS19RXqEChM97VP9zqqrUhD+bkmaeHEwPEO/A16PIjdAN1+AGBh3h2DsiYmP0uQJE61VpsRhiMIBpUx4qrBwwBiHTFo6uhO8pV4mrMPGzWSImUtZH3gNz5vlNGJySZbmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:29:05PM +0100, David Hildenbrand (Arm) wrote:
> On 2/25/26 15:25, Vernon Yang wrote:
> > On Tue, Feb 24, 2026 at 03:52:47AM +0000, Wei Yang wrote:
> >> On Sat, Feb 21, 2026 at 05:39:16PM +0800, Vernon Yang wrote:
> >>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>
> >>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> >>> even if only scanning a single PTE/PMD entry.
> >>>
> >>> - When only scanning a sigle PTE entry, let me provide a detailed
> >>>  example:
> >>>
> >>> static int hpage_collapse_scan_pmd()
> >>> {
> >>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> >>> 	     _pte++, addr += PAGE_SIZE) {
> >>> 		pte_t pteval = ptep_get(_pte);
> >>> 		...
> >>> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
> >>> 			result = SCAN_PTE_UFFD_WP;
> >>> 			goto out_unmap;
> >>> 		}
> >>> 	}
> >>> }
> >>>
> >>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> >>> directly. In practice, only one PTE is scanned before termination.
> >>> Here, "progress += 1" reflects the actual number of PTEs scanned, but
> >>> previously "progress += HPAGE_PMD_NR" always.
> >>>
> >>> - When the memory has been collapsed to PMD, let me provide a detailed
> >>>  example:
> >>>
> >>> The following data is traced by bpftrace on a desktop system. After
> >>> the system has been left idle for 10 minutes upon booting, a lot of
> >>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> >>> by khugepaged.
> >>>
> >>> >From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
> >>> following statuses were observed, with frequency mentioned next to them:
> >>>
> >>> SCAN_SUCCEED          : 1
> >>> SCAN_EXCEED_SHARED_PTE: 2
> >>> SCAN_PMD_MAPPED       : 142
> >>> SCAN_NO_PTE_TABLE     : 178
> >>> total progress size   : 674 MB
> >>> Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs
> >>>
> >>> The khugepaged_scan list save all task that support collapse into hugepage,
> >>> as long as the task is not destroyed, khugepaged will not remove it from
> >>> the khugepaged_scan list. This exist a phenomenon where task has already
> >>> collapsed all memory regions into hugepage, but khugepaged continues to
> >>> scan it, which wastes CPU time and invalid, and due to
> >>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> >>> scanning a large number of invalid task, so scanning really valid task
> >>> is later.
> >>>
> >>> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> >>> SCAN_NO_PTE_TABLE, just skip it, as follow:
> >>>
> >>> SCAN_EXCEED_SHARED_PTE: 2
> >>> SCAN_PMD_MAPPED       : 147
> >>> SCAN_NO_PTE_TABLE     : 173
> >>> total progress size   : 45 MB
> >>> Total time            : 20 seconds
> >>>
> >>> SCAN_PTE_MAPPED_HUGEPAGE is the same, for detailed data, refer to
> >>> https://lore.kernel.org/linux-mm/4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq
> >>>
> >>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >>> Reviewed-by: Dev Jain <dev.jain@arm.com>
> >>> ---
> >>> mm/khugepaged.c | 42 ++++++++++++++++++++++++++++++++----------
> >>> 1 file changed, 32 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index e2f6b68a0011..61e25cf5424b 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -68,7 +68,10 @@ enum scan_result {
> >>> static struct task_struct *khugepaged_thread __read_mostly;
> >>> static DEFINE_MUTEX(khugepaged_mutex);
> >>>
> >>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> >>> +/*
> >>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> >>> + * every 10 second.
> >>> + */
> >>> static unsigned int khugepaged_pages_to_scan __read_mostly;
> >>> static unsigned int khugepaged_pages_collapsed;
> >>> static unsigned int khugepaged_full_scans;
> >>> @@ -1231,7 +1234,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >>> }
> >>>
> >>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
> >>> +		struct vm_area_struct *vma, unsigned long start_addr,
> >>> +		bool *mmap_locked, unsigned int *cur_progress,
> >>> 		struct collapse_control *cc)
> >>> {
> >>> 	pmd_t *pmd;
> >>> @@ -1247,19 +1251,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>> 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >>>
> >>> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >>> -	if (result != SCAN_SUCCEED)
> >>> +	if (result != SCAN_SUCCEED) {
> >>> +		if (cur_progress)
> >>> +			*cur_progress = 1;
> >>> 		goto out;
> >>> +	}
> >>
> >> How about put cur_progress in struct collapse_control?
> >>
> >> Then we don't need to check cur_progress every time before modification.
> >
> > Thank you for suggestion.
> >
> > Placing it inside "struct collapse_control" makes the overall code
> > simpler, there also coincidentally has a 4-bytes hole, as shown below:
> >
> > struct collapse_control {
> >         bool                       is_khugepaged;        /*     0     1 */
> >
> >         /* XXX 3 bytes hole, try to pack */
> >
> >         u32                        node_load[64];        /*     4   256 */
> >
> >         /* XXX 4 bytes hole, try to pack */
> >
> >         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> >         nodemask_t                 alloc_nmask;          /*   264     8 */
> >
> >         /* size: 272, cachelines: 5, members: 3 */
> >         /* sum members: 265, holes: 2, sum holes: 7 */
> >         /* last cacheline: 16 bytes */
> > };
> >
> > But regardless of khugepaged or madvise(MADV_COLLAPSE), "cur_progress"
> > will be counted, while madvise(MADV_COLLAPSE) actually does not need to
> > be counted.
> >
> > David, do we want to place "cur_progress" inside the "struct collapse_control"?
>
> Might end up looking nicer code-wise. But the reset semantics (within a
> pmd) are a bit weird.
>
> > If Yes, it would be better to rename "cur_progress" to "pmd_progress",
> > as show below:
> >
>
> "pmd_progress" is misleading. "progress_in_pmd" might be clearer.
>
> Play with it to see if it looks better :)

Hi Andrew, David,

Based on previous discussions [1], v2 as follow, and testing shows the
same performance benefits. Just make code cleaner, no function changes.

If David has no further revisions, Andrew, could you please squash the
following clean into this patch? If you prefer a new version, please let
me know. Thanks.

[1] https://lore.kernel.org/linux-mm/zdvzmoop5xswqcyiwmvvrdfianm4ccs3gryfecwbm4bhuh7ebo@7an4huwgbuwo

---

From 73e6aa8ffcd5ac1ee510938ff4bdbd24edc86680 Mon Sep 17 00:00:00 2001
From: Vernon Yang <yanglincheng@kylinos.cn>
Date: Thu, 26 Feb 2026 18:24:21 +0800
Subject: [PATCH] mm: khugepaged: simplify scanning progress

Placing "progress" inside "struct collapse_control" makes the overall
code simpler, there also coincidentally has a 4-bytes hole, as shown
below:

struct collapse_control {
        bool                       is_khugepaged;        /*     0     1 */
        /* XXX 3 bytes hole, try to pack */
        u32                        node_load[64];        /*     4   256 */
        /* XXX 4 bytes hole, try to pack */
        /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
        nodemask_t                 alloc_nmask;          /*   264     8 */

        /* size: 272, cachelines: 5, members: 3 */
        /* sum members: 265, holes: 2, sum holes: 7 */
        /* last cacheline: 16 bytes */
};

No function changes.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 78 ++++++++++++++++++++++---------------------------
 1 file changed, 35 insertions(+), 43 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7c1642fbe394..13b0fe50dfc5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -70,8 +70,8 @@ static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);

 /*
- * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
- * every 10 second.
+ * default scan 8*HPAGE_PMD_NR ptes, pte_mapped_hugepage, pmd_mapped,
+ * no_pte_table or vmas every 10 second.
  */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
@@ -104,6 +104,9 @@ struct collapse_control {
 	/* Num pages scanned per node */
 	u32 node_load[MAX_NUMNODES];

+	/* Num pages scanned (see khugepaged_pages_to_scan) */
+	unsigned int progress;
+
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
 };
@@ -1246,8 +1249,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a

 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *mmap_locked, unsigned int *cur_progress,
-		struct collapse_control *cc)
+		bool *mmap_locked, struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1263,8 +1265,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,

 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
-		if (cur_progress)
-			*cur_progress = 1;
+		cc->progress++;
 		goto out;
 	}

@@ -1272,16 +1273,14 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
-		if (cur_progress)
-			*cur_progress = 1;
+		cc->progress++;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}

 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
-		if (cur_progress)
-			*cur_progress += 1;
+		cc->progress++;

 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
@@ -2314,7 +2313,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,

 static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
-		unsigned int *cur_progress, struct collapse_control *cc)
+		struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2404,12 +2403,10 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		}
 	}
 	rcu_read_unlock();
-	if (cur_progress) {
-		if (result == SCAN_PTE_MAPPED_HUGEPAGE)
-			*cur_progress = 1;
-		else
-			*cur_progress = HPAGE_PMD_NR;
-	}
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+		cc->progress++;
+	else
+		cc->progress += HPAGE_PMD_NR;

 	if (result == SCAN_SUCCEED) {
 		if (cc->is_khugepaged &&
@@ -2425,8 +2422,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 	return result;
 }

-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
-					    struct collapse_control *cc)
+static void khugepaged_scan_mm_slot(unsigned int progress_max,
+		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
 {
@@ -2434,9 +2431,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int progress = 0;
+	unsigned int progress_prev = cc->progress;

-	VM_BUG_ON(!pages);
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;

@@ -2459,7 +2455,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	if (unlikely(!mmap_read_trylock(mm)))
 		goto breakouterloop_mmap_lock;

-	progress++;
+	cc->progress++;
 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;

@@ -2469,17 +2465,17 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result

 		cond_resched();
 		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
-			progress++;
+			cc->progress++;
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
-			progress++;
+			cc->progress++;
 			continue;
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
 		if (khugepaged_scan.address > hend) {
-			progress++;
+			cc->progress++;
 			continue;
 		}
 		if (khugepaged_scan.address < hstart)
@@ -2488,7 +2484,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result

 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
-			unsigned int cur_progress = 0;

 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2505,8 +2500,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff,
-					&cur_progress, cc);
+					khugepaged_scan.address, file, pgoff, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2520,8 +2514,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked,
-					&cur_progress, cc);
+					khugepaged_scan.address, &mmap_locked, cc);
 			}

 			if (*result == SCAN_SUCCEED)
@@ -2529,7 +2522,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result

 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2539,7 +2531,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				 * correct result back to caller.
 				 */
 				goto breakouterloop_mmap_lock;
-			if (progress >= pages)
+			if (cc->progress >= progress_max)
 				goto breakouterloop;
 		}
 	}
@@ -2570,9 +2562,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		collect_mm_slot(slot);
 	}

-	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
-
-	return progress;
+	trace_mm_khugepaged_scan(mm, cc->progress - progress_prev,
+				 khugepaged_scan.mm_slot == NULL);
 }

 static int khugepaged_has_work(void)
@@ -2588,13 +2579,14 @@ static int khugepaged_wait_event(void)

 static void khugepaged_do_scan(struct collapse_control *cc)
 {
-	unsigned int progress = 0, pass_through_head = 0;
-	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
+	const unsigned int progress_max = READ_ONCE(khugepaged_pages_to_scan);
+	unsigned int pass_through_head = 0;
 	bool wait = true;
 	enum scan_result result = SCAN_SUCCEED;

 	lru_add_drain_all();

+	cc->progress = 0;
 	while (true) {
 		cond_resched();

@@ -2606,13 +2598,12 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			pass_through_head++;
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
-			progress += khugepaged_scan_mm_slot(pages - progress,
-							    &result, cc);
+			khugepaged_scan_mm_slot(progress_max, &result, cc);
 		else
-			progress = pages;
+			cc->progress = progress_max;
 		spin_unlock(&khugepaged_mm_lock);

-		if (progress >= pages)
+		if (cc->progress >= progress_max)
 			break;

 		if (result == SCAN_ALLOC_HUGE_PAGE_FAIL) {
@@ -2818,6 +2809,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	if (!cc)
 		return -ENOMEM;
 	cc->is_khugepaged = false;
+	cc->progress = 0;

 	mmgrab(mm);
 	lru_add_drain_all();
@@ -2852,7 +2844,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = false;
 			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  NULL, cc);
+							  cc);

 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2867,7 +2859,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, NULL, cc);
+							 &mmap_locked, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
--
2.51.0


