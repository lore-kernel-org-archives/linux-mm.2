Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1919D358D2
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 07:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F4D6B0088; Thu, 29 Jan 2026 02:59:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2CA6B0089; Thu, 29 Jan 2026 02:59:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584B06B008A; Thu, 29 Jan 2026 02:59:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 432AC6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:59:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D4F21A08EE
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:59:49 +0000 (UTC)
X-FDA: 84384252498.09.40CC89D
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id BB26D40002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:59:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yb+yUs0B;
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769673587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MT71gg8746Pjuhw9TUmhNvf7Zlb9cXcuv5ybdCfJKE=;
	b=VwDA8blHDl5SD5U0weeh9XZYwZuBynNlToXcHHzDqfeTueEo0IKaLfUmfbdOnLZbLP/ArS
	+D+TMToGmbpLWSo4HqUoVe3t0a8j5CP59u4fszbBgO+6/4urliXyOoDi7DqUc9AdxmueBz
	0s57/r+gJru6YdU3IlFpKKRRV6cbwKI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yb+yUs0B;
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769673587; a=rsa-sha256;
	cv=none;
	b=NmsZ0eeQ47zdlTeNdU6zXMfcWm11pJVc9l0fvHfoTdI2MMwsRAMXqftsSxLqGZsPS0RW5C
	fFh4oi4f68eOO2R44mr56gjr9eIxFF6xfQaPYW975ZaaTyghjmb3Vi9K5MMp98/v7ErhZL
	kooGiM8OZ8PlIiBQwQyR66vaqYl3a38=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8230c33f477so351786b3a.2
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 23:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769673586; x=1770278386; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9MT71gg8746Pjuhw9TUmhNvf7Zlb9cXcuv5ybdCfJKE=;
        b=Yb+yUs0BAJp/PHeaIeWRI0lcmZsKuF8q+MsENpQ2yXxDZy5dVtHRq7zftaq7ccjEND
         zfBlaF837tih+NQqDivobGqphCz37KSBqn0OnygwJn3M+2qUxbdqTcOLLx5txZ57xsxg
         YXhgkVvaL1pjTkcb+8llk9UeMeiEOCXbwylnZYBF3v/SckAarYQbBUFsJZre+iG+QCD3
         EmGU6IZZk8komlFZgPJdb4dfqa2TK4DGe0oQU1MesJ3Uv0Vyi2N3oyHQ5Bk4N3J2Bff7
         OUAGf3igqrDQdszum2QKpR/pBlzUv77MfYIpgBjQbGoMIKA6OlzWPTIWskukXiyCNbij
         kURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769673586; x=1770278386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MT71gg8746Pjuhw9TUmhNvf7Zlb9cXcuv5ybdCfJKE=;
        b=s1GoMfkPuADRahLhEK005AxpcDoDzo8fYkAPY/Euz+D4cTMvITjOyFK3hJF6NfDT0F
         koxYiM/l1Mjrh/Ps+gFgCajpSCrg1MwSiOxG/v1fP5W59s76LnhTH7/DYbEIL1w9MDDd
         plMITDMtRnOnrx/fgmtLzlhk8r1wKjdjcXqUC2M8/12sA0o9Fq+bZ2aOCpOuvKvK0KrY
         zD4lqhiFmd/1tPYYtk0fE95M5GllcCTyAhKOAlL91OG1w1brsUUUQxUtgVZM8fWsRVRq
         RJ1Eoy/yMov/b0rhilHnjzoIn1g/JbgwCAiUcm6ekjH2jAozQkiz0CFvD0V9xBai9r0W
         KVGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCipKnUdn4ccx0nI+rSRqaYCnaBNxa1r9DwTCeoF884UUDFPHP6KoQmlnQXOVh0xLv0URX0vctEQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+pqA7SYcDyt3m9WbxXpS5FkBMdhlx9HwlQDhzjaIRHIWFU2We
	W/werIUWDQsMg88KJ5yV1OawwE9aGG2BTYAMzRbjNTLOVJkCbDyQZA+f
X-Gm-Gg: AZuq6aJq1GH0QtqrkoZ9aiQqw8lk1LM9wYjUSltw7JSqEFvkWuYUz9vLJX8MO8S2fv9
	4jnRaB60BVwt8+h9iXU0g0M/f6GwCVMfVOFuireMM0u3uBBHhmTvkBPL01dZYiK45zQyOa2Da/7
	ZdpBKi4NolAvNFHp40Qyeo6ZHdg4o9hEVuTTY3SoWL6Kp925e6ij5b2Q2/bIlyftmNklmx5ntkb
	BfIIVNntJ+QcwYv+Uz7QXAuNNEfUnIq5spquN6/BelvM+93Ru0KXn2RBicz/Omyi7zBmH+D5BAa
	4sbabL12BN/jHZ/cdCwc5cLK7UfoKlNLJuyEgMEZgdjn2+mxe+aLwAatTtTpjQLMO95WKJaA1UO
	lZpieGUvLRuWVaqKFZb2Bk0sgf2vu95JXr8/qjq8eECpZozvR5cmSP1uE6Kgw7kCtTn2txZM8E/
	xLzRcvWTAkQlgowEKeCUvCbqcMdaC5+QMCArg=
X-Received: by 2002:a05:6a00:37c4:b0:823:3fc7:4c84 with SMTP id d2e1a72fcca58-82368f99148mr6145084b3a.0.1769673586342;
        Wed, 28 Jan 2026 23:59:46 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfd71csm4552041b3a.35.2026.01.28.23.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 23:59:45 -0800 (PST)
Date: Thu, 29 Jan 2026 15:59:17 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
Message-ID: <gzhittxi6dn2o6a3wf4qx4fafkdc2pumfuz3xtprh3ifs2t47q@slsfcb6kqqcr>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-3-vernon2gm@gmail.com>
 <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com>
 <4exllw7pf4yfhfzpyg3ictsnznf5lepv5tjd7zvycldjwmh6jm@j6rara3ogrux>
 <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BB26D40002
X-Stat-Signature: t1g6td8b7pissbu7u8z9p5ti6otnerfp
X-Rspam-User: 
X-HE-Tag: 1769673587-624342
X-HE-Meta: U2FsdGVkX19mFEKaUb179whyAWsHlnP/wDY6K7WbiXl35TuEqZydY2UGgmWmt/U6ChIdKjTXeYDo86QgQL3xrJ7fqKEst3c2oMisMzLDJYK1CWed305HkZDKQJglXfm3eP5hfRIibz8kRXCuKf3kZ+2ejL3tlZsbT61q2qf3/zeuTYSXA/A3/d/skCqJMNTBR5hr4/ClDVdtvt5zQQdYx0PxUllL5prZFu8r2NZmqrwT5ZzjLiWiK0GgdFPfYVHMLW/AjVYfxU6u7muw2SNbLBpuJnsp57w5dBM1X3leyFrheHTHyOWW9zttV56V1ewkmbHh8UOm5SkehNllKAq6HeqndkMwPio1ZGy4V5MP5rsp14R6zHCv28t9X99tnhx+EJyL74QWTfxfWuqcko+vAq80o+4B2sm3SN/CqpdGE1ATYO8NZyFFygTgXsiXmlQ7KK4HKyyUl/SsbvlymAK7owDAjIJ9GHpgC/yTtfrsBKdSunRJ1JL3knWgWe90D6t9oJR+aDCCbg7dYkmO+hpti56zJa5n7fAIDBsi0OVYq1mxCyZ7yG1+lO1zvuDwfnKw8JJ+RIttc0SncLxG5seX/TGm8PVpezSvbHBqxLJo9mp6wuOP/rlg3NfAwWuYT6ETccmO4/Lsl1ykxWHe9Wx82QST0mn0X6kMLfOlHhCCzu4jb/G1va9uaVBTge9N13kuBfDG8oGXHP6UdomybGtaUNO85ZPANGYAqkkDy3B9bXQYq7XY/3lfAwXzIqJCC5PRpqs+rqPedU27H22kx08ox7PxF5fg+U0wMsjM/K/sngQz3d6Cu81OFb778bMAGmvBvOfYFgoOL02ok3NDyXXEBkCRdFrO7FWHq4uvwcvnoILU75H7NV6ZxC0acLEPD6wuAgu6hSIlQEZ0bQ8sgr/1IcvpQIk5awrIS6VLGLnJHudtvZZL6dFJAcRlx8W9sUx9jXIebBbcevse4rwFXTm
 qEdKlr1F
 QifaBQhUdkLQ3WTiDbb7nNe8EEoxs6So5TYkQpVVgph3u4XsME+sLGjRX9w1VsSQoPcFTxLeV8uSfOOMMxBAFJ/AFnBR/JtaCRgtmdtQoAPCG++ySp6J3NrTfGEIKWu7FC6lIUVK+T8c9bp9v5sEn6MUzTWO/ZCoGwk4u2lmiSGsb8vFj5X3ThKe7flrkzZ3Kbll0wvmNqEOM4xNw7PRuKBXkVbIA2fMEDFdI1TKO20vGfnbmzPPJDkVrKYcNyFEGw0Ug82caxFpPT9Xpf3WMzdtORkCREc67wFcD95aPhYyETwXLDDLL0Y+Ngdk2OwjIJJM8a+YzWIgj9XhadVwW9mvy1JxrxvxPLuNy80Oop+M+SQoKbGNVsxHE2dM7f9iL4m1ObtxkNQuR+NIU34da9pGpdi0UMEzu/kgvp7MZ2wTUOV3DEhcioq6KREcshyIQoadAbkVs0oMSHTfP+gOCkqcqIiOnszY6m/rLAg7wCyyguzkQeslVC5iKdyPNa0mH8wHlIvV9Hm2hXnCFJrgloHyTJYKMN0wY6JN06QvlqKtvvCw0lgYRQkMJmI8lVSgJX64D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 11:05:36AM +0530, Dev Jain wrote:
>
> On 28/01/26 8:04 pm, Vernon Yang wrote:
> > On Wed, Jan 28, 2026 at 01:59:33PM +0530, Dev Jain wrote:
> >> On 23/01/26 1:52 pm, Vernon Yang wrote:
> >>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>
> >>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> >>> even if only scanning a single PTE/PMD entry.
> >>>
> >>> - When only scanning a sigle PTE entry, let me provide a detailed
> >>>   example:
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
> >>>   example:
> >>>
> >>> The following data is traced by bpftrace on a desktop system. After
> >>> the system has been left idle for 10 minutes upon booting, a lot of
> >>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> >>> by khugepaged.
> >>>
> >>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> >>> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
> >>> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
> >>> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
> >> Could you elaborate what is [1], [6] etc and 1,2,142, etc?
> > These 1,6 are value of "enum scan_result", you can directly refer to the
> > notes on the right.
> >
> > These 1,2,142,178 are number of different "enum scan_result" from
> > trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file.
> >
> > as example, SCAN_PMD_MAPPED has 142 times during a full scan by
> > khugepaged.
>
> Thanks. Can you please mention this in the patch description. You can simply
> right it like this:
>
> "From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
> following statuses were observed, with frequency mentioned next to them:
>
> SCAN_SUCCEED: 1
> SCAN_PMD_MAPPED: 142
> ....."
>
> and so on.

LGTM, I will do it in the next version. Thanks!

> >
> >>> total progress size: 674 MB
> >>> Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs
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
> >>> @scan_pmd_status[6]: 2
> >>> @scan_pmd_status[3]: 147
> >>> @scan_pmd_status[2]: 173
> >>> total progress size: 45 MB
> >>> Total time         : 20 seconds
> >>>
> >>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >>> ---
> >>>  include/linux/xarray.h |  9 ++++++++
> >>>  mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
> >>>  2 files changed, 47 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> >>> index be850174e802..f77d97d7b957 100644
> >>> --- a/include/linux/xarray.h
> >>> +++ b/include/linux/xarray.h
> >>> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
> >>>  	xas->xa_node = XAS_RESTART;
> >>>  }
> >>>
> >>> +/**
> >>> + * xas_get_index() - Get XArray operation state for a different index.
> >>> + * @xas: XArray operation state.
> >>> + */
> >>> +static inline unsigned long xas_get_index(struct xa_state *xas)
> >>> +{
> >>> +	return xas->xa_index;
> >>> +}
> >>> +
> >>>  /**
> >>>   * xas_advance() - Skip over sibling entries.
> >>>   * @xas: XArray operation state.
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index 6f0f05148765..de95029e3763 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -68,7 +68,10 @@ enum scan_result {
> >>>  static struct task_struct *khugepaged_thread __read_mostly;
> >>>  static DEFINE_MUTEX(khugepaged_mutex);
> >>>
> >>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> >>> +/*
> >>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> >>> + * every 10 second.
> >>> + */
> >>>  static unsigned int khugepaged_pages_to_scan __read_mostly;
> >>>  static unsigned int khugepaged_pages_collapsed;
> >>>  static unsigned int khugepaged_full_scans;
> >>> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >>>  }
> >>>
> >>>  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
> >>> +		struct vm_area_struct *vma, unsigned long start_addr,
> >>> +		bool *mmap_locked, unsigned int *cur_progress,
> >>>  		struct collapse_control *cc)
> >>>  {
> >>>  	pmd_t *pmd;
> >>> @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>>
> >>>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >>>
> >>> +	if (cur_progress)
> >>> +		*cur_progress += 1;
> >> Why not be a little more explicit, and do this addition if find_pmd_or_thp_or_none fails,
> >> or pte_offset_map_lock fails? The way you do it right now is not readable - it gives no
> >> idea as to why on function entry we do a +1 right away. Please do add some comments too.
> > If this way is not clear enough, we can directly add 1 in
> > find_pmd_or_thp_or_none() etc, BUT it's a bit redundant.
> > Please take a look at which one is better.
> >
> > case 1:
> > as the V4 PATCH #2 [1] and #3 [2], only hpage_collapse_scan_pmd().
> > [1] https://lore.kernel.org/linux-mm/20260111121909.8410-3-yanglincheng@kylinos.cn
> > [2] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglincheng@kylinos.cn
> >
> > static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> > 		struct vm_area_struct *vma, unsigned long start_addr,
> > 		bool *mmap_locked, unsigned int *cur_progress,
> > 		struct collapse_control *cc)
> > {
> > 	...
> > 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> > 	if (result != SCAN_SUCCEED) {
> > 		if (cur_progress)
> > 			*cur_progress += 1; // here
> > 		goto out;
> > 	}
> > 	...
> > 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> > 	if (!pte) {
> > 		if (cur_progress)
> > 			*cur_progress += 1; // here
> > 		result = SCAN_NO_PTE_TABLE;
> > 		goto out;
> > 	}
> >
> > 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > 	     _pte++, addr += PAGE_SIZE) {
> > 		if (cur_progress)
> > 			*cur_progress += 1; // here
> > 		...
> > 	}
> > }
> >
> > case 2:
> >
> > static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> > 		struct vm_area_struct *vma, unsigned long start_addr,
> > 		bool *mmap_locked, unsigned int *cur_progress,
> > 		struct collapse_control *cc)
> > {
> > 	...
> > 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> > 	if (result != SCAN_SUCCEED) {
> > 		if (cur_progress)
> > 			*cur_progress += 1; // here
>
> Let us be more explicit and set this equal to 1, instead of adding 1.

LGTM, I will do it in the next version. Thanks!

> > 		goto out;
> > 	}
> > 	...
> > 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> > 	if (!pte) {
> > 		if (cur_progress)
> > 			*cur_progress += 1; // here
>
> Same comment as above.
>
> > 		result = SCAN_NO_PTE_TABLE;
> > 		goto out;
> > 	}
> >
> > 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > 	     _pte++, addr += PAGE_SIZE) {
> > 		...
> > 	}
> > 	...
> > out_unmap:
> > 	if (cur_progress) {
> > 		if (_pte >= pte + HPAGE_PMD_NR)
> > 			*cur_progress += HPAGE_PMD_NR;   // here
> > 		else
> > 			*cur_progress += _pte - pte + 1; // here
> > 	}
> > }
>
> I will vote case 2. In case 1 I don't like the fact that the if (cur_progress)
> branch will be checked each iteration - and I don't think the compiler can
> optimize this since the body of the loop is complex, so this check cannot
> be hoisted out of the loop.
>
>
> >
> > case 3:
> > 	current patch, and add more comments to clearer.
> >
> >>> +
> >>>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >>>  	if (result != SCAN_SUCCEED)
> >>>  		goto out;
> >>> @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>>  		result = SCAN_SUCCEED;
> >>>  	}
> >>>  out_unmap:
> >>> +	if (cur_progress) {
> >>> +		if (_pte >= pte + HPAGE_PMD_NR)
> >>> +			*cur_progress += HPAGE_PMD_NR - 1;
> >>> +		else
> >>> +			*cur_progress += _pte - pte;
> >>> +	}
> >>>  	pte_unmap_unlock(pte, ptl);
> >>>  	if (result == SCAN_SUCCEED) {
> >>>  		result = collapse_huge_page(mm, start_addr, referenced,
> >>> @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >>>  	return result;
> >>>  }
> >>>
> >>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> >>> -		struct file *file, pgoff_t start, struct collapse_control *cc)
> >>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> >>> +		unsigned long addr, struct file *file, pgoff_t start,
> >>> +		unsigned int *cur_progress, struct collapse_control *cc)
> >>>  {
> >>>  	struct folio *folio = NULL;
> >>>  	struct address_space *mapping = file->f_mapping;
> >>> @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
> >>>  			cond_resched_rcu();
> >>>  		}
> >>>  	}
> >>> +	if (cur_progress) {
> >>> +		unsigned long idx = xas_get_index(&xas) - start;
> >>> +
> >>> +		if (folio == NULL)
> >>> +			*cur_progress += HPAGE_PMD_NR;
> >> I think this whole block needs some comments. Can you explain, why you
> >> do a particular increment in each case?
> >>
> >>> +		else if (xa_is_value(folio))
> >>> +			*cur_progress += idx + (1 << xas_get_order(&xas));
> >>> +		else if (folio_order(folio) == HPAGE_PMD_ORDER)
> >>> +			*cur_progress += idx + 1;
> >>> +		else
> >>> +			*cur_progress += idx + folio_nr_pages(folio);
> >>> +	}
> > The "idx" represent PTEs number already scanned when exiting
> > xas_for_each().
> >
> > However, the last valid folio size was not counted in "idx" (except
> > folio == NULL, "idx" equal to HPAGE_PMD_NR), which can be further
> > divided into three cases:
>
> But, the number of PTEs you account in these three cases, are *not*
> scanned, right? So we can simply drop these 3 cases.

No, these three cases are the last scanning folio to break, I think we
need to add them. Imagine that if we trigger HPAGE_PMD_ORDER folio
firstly, "idx" is equal to 0.

> >
> > 1. shmem swap entries (xa_is_value), add folio size.
> > 2. the folio is HPAGE_PMD_ORDER, the memory has been collapsed
> >    to PMD, so add 1 only.
> > 3. Normal folio, add folio size.
> >
> > Is the version below more readable?
> >
> > 	if (cur_progress) {
> > 		*cur_progress += xas.xa_index - start;
> >
> > 		if (folio) {
> > 			if (xa_is_value(folio))
> > 				*cur_progress += 1 << xas_get_order(&xas);
> > 			else if (folio_order(folio) == HPAGE_PMD_ORDER)
> > 				*cur_progress += 1;
> > 			else
> > 				*cur_progress += folio_nr_pages(folio);
> > 		}
> > 	}
>
> Yep, this is unneeded complexity. This looks really ugly and the benefits of
> this are not clear. You can simply do
>
> if (cur_progress)
> 	*cur_progress = xas.xa_index - start;
>
> >
> >>>  	rcu_read_unlock();
> >>>
> >>>  	if (result == SCAN_SUCCEED) {
> >>> @@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
> >>>
> >>>  		while (khugepaged_scan.address < hend) {
> >>>  			bool mmap_locked = true;
> >>> +			unsigned int cur_progress = 0;
> >>>
> >>>  			cond_resched();
> >>>  			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> >>> @@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
> >>>  				mmap_read_unlock(mm);
> >>>  				mmap_locked = false;
> >>>  				*result = hpage_collapse_scan_file(mm,
> >>> -					khugepaged_scan.address, file, pgoff, cc);
> >>> +					khugepaged_scan.address, file, pgoff,
> >>> +					&cur_progress, cc);
> >>>  				fput(file);
> >>>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> >>>  					mmap_read_lock(mm);
> >>> @@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
> >>>  				}
> >>>  			} else {
> >>>  				*result = hpage_collapse_scan_pmd(mm, vma,
> >>> -					khugepaged_scan.address, &mmap_locked, cc);
> >>> +					khugepaged_scan.address, &mmap_locked,
> >>> +					&cur_progress, cc);
> >>>  			}
> >>>
> >>>  			if (*result == SCAN_SUCCEED)
> >>> @@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
> >>>
> >>>  			/* move to next address */
> >>>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
> >>> -			progress += HPAGE_PMD_NR;
> >>> +			progress += cur_progress;
> >>>  			if (!mmap_locked)
> >>>  				/*
> >>>  				 * We released mmap_lock so break loop.  Note
> >>> @@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >>>  			mmap_locked = false;
> >>>  			*lock_dropped = true;
> >>>  			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> >>> -							  cc);
> >>> +							  NULL, cc);
> >>>
> >>>  			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> >>>  			    mapping_can_writeback(file->f_mapping)) {
> >>> @@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >>>  			fput(file);
> >>>  		} else {
> >>>  			result = hpage_collapse_scan_pmd(mm, vma, addr,
> >>> -							 &mmap_locked, cc);
> >>> +							 &mmap_locked, NULL, cc);
> >>>  		}
> >>>  		if (!mmap_locked)
> >>>  			*lock_dropped = true;
> > --
> > Thanks,
> > Vernon
>


