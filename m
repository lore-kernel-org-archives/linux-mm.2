Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D397AD68BD8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 04:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081C46B0088; Wed, 17 Dec 2025 23:41:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F886B0089; Wed, 17 Dec 2025 23:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52F26B008A; Wed, 17 Dec 2025 23:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D27286B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:41:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 729625B987
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:41:27 +0000 (UTC)
X-FDA: 84231343014.12.DD27734
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 921711C000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:41:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UNMixVlT;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766032885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JuzEIWvl3W7GlEA1OYeC3H4ZtKMzn/SCv7fuo7FX468=;
	b=Sn2DJ9xYI7n03uNWDBS6xOxOQUM6TNFTHUvhkRPB/Mcm49HibtT0PAzyLSvcphF+tOFBVw
	AKGEWzeRx8XPvDzctadhW2PhJSqlqE74PmxCbI10SBL7+Mwa7wcY2l8Ie9W3ogqLyd9qa5
	2StJ3nW6RU++cB+a3PRGtVD3I1I9kEk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UNMixVlT;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766032885; a=rsa-sha256;
	cv=none;
	b=DKUcifgtJXhgvcgjzjwJy3GMGYVZpcbrPIDpycM++1f7jIJXsagjubn1lZcvY0tBTK6xA9
	JyULYIVWh9DkIKdTC9QD0VBJ/c1W81IL/JVUokSwsqVuj6TDqdS86aXJsJJSSkScF1TgEi
	iP3GjMJ6fXM4vpEdLUfKnUeflaFxdU8=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0c20ee83dso2743235ad.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766032884; x=1766637684; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JuzEIWvl3W7GlEA1OYeC3H4ZtKMzn/SCv7fuo7FX468=;
        b=UNMixVlTOvTyvGskpgmn/mNeG6Ad+bDryVUlgeFKgdtLiYVObuFD58Yu8vPIsZsXDS
         p97s769unSAGQ57RXG8cFuaA+IOpNpVJcokdCkm3G74QRFiGb2MZbVKRNv8TjBoz0oK2
         yKXJ46vS6nvl7NRhIYWbG+QZZl6S/igzEUyqWYOF+GO9eIEqR/aoH/uxCEiPgkY4MCok
         UULjHGoP8qz1rdrNk6bpl0HO+B8bBmzQIZvo4Cr9mUkpqarYY/sojott32Bopv6Y1FUK
         OC2fUp3qUFMUIXx34YlJJh2mHiS/hIXg2TPNjpxqVdbFkEsC6oYWUsD4+6pBNz1pc9Hg
         wsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766032884; x=1766637684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JuzEIWvl3W7GlEA1OYeC3H4ZtKMzn/SCv7fuo7FX468=;
        b=jHeI0gX1lyXluYApKD5s8ZooVOE5yvGL7O2L0Sc+Jp1qEMPTp66YmZjypd/q0MCBoM
         Mlaa3R6abjj1Y8ow9KXhqYXL1uVGnnl5JlFHvBsrABtB3Zs89W46X667+CctuBER9K93
         Dq72MJTjVTYJwZcBXmBj/BwmCfJLvZUHVA/tQBpQZmHn/nGluTNjCXPCVsqrpqS65hJH
         NX9PXZHr/K+hN/TETsYZDtXe1SWnwZ7xkK8I1oW9UMp1jpL2dqFlZpVsvlSQa//sjxAh
         iSRlUUk+nQzM79pPO9pwOVENNXGc9LZrfWQoMeaHIRoUwTJyt4gIb6qDRZs4nAXJsXq1
         unbQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8u4G8fld/MdfI+eiKYLaU6HjM7tyqHsntt/+8E0In/21OKNlf8mbSYooTSwihnwPQ/D2XyoSh/A==@kvack.org
X-Gm-Message-State: AOJu0YwXuexhE5hbRwfu2tKpujTvnhWnm98LFCB1fu11sBJUkiyMmbLk
	HxGt6qSy4i831Vo93RrUIOxw1f3hYoxPW7lv4f1bWqQIL4RNtbyvARVA
X-Gm-Gg: AY/fxX48NZrNtY7IAEOaou5IvuTa2VUIeb5bWmjSxxNQ+Pi2EATWeKyVhscDXl2yTpo
	c7h/pSrVs2i4ddpsyJ/XHvm+h7A5IQCdzQltNUiE8nDwJ00TNOAgogE0rZRXvRO8yBYwo66kNSA
	iG3dgh0PQLVQ5PG/qmOlKePXAOz9vOY0g47KqeuTj7GEcc3tsmLuJrESwTawelMcpoP1jwltC7o
	GWxyuLMM+Nc8JHpUsKPnbCCS3aB+GriNumwiJp+hy0I7gz2+1yH6QAGJxUFcY7KY0mCgC1267n8
	o7lYoU2CEmRxvicCFkaHTCs+dvET5foO2i/Fzx+atYLnx/D3HbNtXoXGKrTPTCOOCnOXW4pjzWI
	+o/lRV8iAfgZVSdbwm8JNhgZzL5lh9A/jVaIQCwmNfpGEl90V91bhuGi/C7R9BnGYcg4ycATSto
	4pxbdjQKyxYXv6oeR8nV5Z+Eyn
X-Google-Smtp-Source: AGHT+IEDhyyOq5CLCSkoDRkONzcxl/kuIzlwrV8ZzwOlhICK6M9JvZE/38R31kmGuBkhw+NMMIEFHg==
X-Received: by 2002:a17:903:22c2:b0:2a0:980a:4f0b with SMTP id d9443c01a7336-2a0980a509dmr181194865ad.40.1766032884244;
        Wed, 17 Dec 2025 20:41:24 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d1927169sm9325885ad.85.2025.12.17.20.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 20:41:23 -0800 (PST)
Date: Thu, 18 Dec 2025 12:41:17 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <kquic3rm55tf3yafdpy3cpmlcmlevfq7c7dk5gzfr6jqxc2qzg@k7potqbeys5q>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <20251217033155.yhjerlthr36utnbr@master>
 <77paexkefc7qkfjgv6reuf7jxlysgkinuswsck5tthqkpcjkpr@aelvplwvafnt>
 <20251218034801.jyuu437dbtvcnpzw@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218034801.jyuu437dbtvcnpzw@master>
X-Stat-Signature: x9da79wqxwk7zyneygsdcd18eiahfs4h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 921711C000B
X-HE-Tag: 1766032885-23607
X-HE-Meta: U2FsdGVkX1/jgOkwXqZ7aenSTAjg/2BvtMFxcR7MPePki8SqK5mhmbtt/qBA0sbuufHYwPKYBKiHq0BzCX8mAPnEuYO5LalJGcJABjWWswnOn8YhKLGkTgf7V0a9XtyVHx3UWX2Shr1RVnKB8zrbb7M4rGWCmkLShL0gaFQ3ZbcMdoSSE7WdLInqkchSpQJpI5uWSnaGPAYkzZR8+xJb8ayJkwz/q9qszxRyxwtFI5xHrnV8rxPDFX1sFni0vRcD+JoSaSXdwkYVxoXpvuOusGjE+MEXo4AGOsWr75oVp0IHskAJyJHge9+wSe5hcT176wBMBZQ0l/Oj4KS8JW9S+Ft/GiAMj8irKAnubsAhQ5o4R9kPKDnU2cd7N0o20kJXod2+p+AvzEY7IHhj42OVYQq6O+mUNVNcmplgXq6rLHimEp0y+EOzFnr+TGHM822K28/DpIH5XN9S5JNLgy96ddZVwwRU4iGEka4L8VtCHZUmLcb9qOf6qvlUG2G8Kuy54CVDLKwoWsgrgDY44k3Sk34NBd/nKG7OAa9jFK7f17JOGPgIdPzY/CQn2fJlNrgz9Is9PcurxLkiieZeKMjQ7XPXkrzbhlW0Y/w2H34Lq+T3W1XcBGBPYk2J3Gjdl47V80hHxmbECvaq4PWI683TGwtVuxVdQUHckCzDwaWcPU0hWulhK0+yYwDpLCFuTRWeyAuuN/AYeOX9Vlvka7Nv7wFD7dAPQgkBKuPUXaKEu+Biu9479qTXSysQgtmDiug3j31hmJPDGVaEJgAAL1is9CBxis0ECV8yCMjPmpTGpwbAjXeg/jgBTpwBMlRaArMJFHXFc7gyB6l4n1fKVW38LWjl5RfDXEBQsdm9xLbsRjT1PHU1MbziGXRvGY8gGdcbS27vCbNLDsTRr1yVzP2BbfEKZnMtgjXoEUQtdSik65l/qmX94hR9IrnPN/XZbiUfxQBHxMQn5XtY2aXjYi+
 u7n2rcCk
 SgeWaC/sYUCDv1LBLYKo+0npFogwU7oJqgjat7pudigC2NVAKUvI/veQ13Hif4X1glJfFGPlg0P0kJEICzM7OTXDYn7nxPhjLmdcbBcp0KMJx1WYnVfePKl2z7YkBdLnUBHv5Pgy4iHpFujCYs7SqyCNHxFG8gSB6zoXfi5EVfJXt9+qqzXUvl+zvxoo3DceahHy4qOh/MvaY+41MTOh4631U8Olh++qFDE6gA4W4hj3R+bVdHmzg1ZdTx/ZT6NAnTNPECcUC4FsBlvbkeAAUjwsQlTxfSLZ/s7U+FcZ0tKn/ZCVO+jHP/t14wz3pjOS7Jr6k6upATkxoIFujXgqb4YICDNkD4ySLwILCIUgeza2+qLjYklv9gvyuPy+TsfqCE4Tm1B/Q486pGRpUExGZBhOolB3TU8Vs0pKunvyccX9o4zeFbf0shFQ7IrTRsmLgO1sX7yLmR0xjSw/YYcygNmW9pnxGvfbbLKlfIPjgglo5b2LfF2+cRv4wgF6oCvX4T4rNu+U14LOLOvcLTnGnUa6HQWTxqysklDvTSPmNT3/zYGVqGZHza1Ffv1YwRBXN6sicCWDSeLWVaopamJo/TcmnwpRuNLKyrJnc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 03:48:01AM +0000, Wei Yang wrote:
> On Thu, Dec 18, 2025 at 11:27:24AM +0800, Vernon Yang wrote:
> >On Wed, Dec 17, 2025 at 03:31:55AM +0000, Wei Yang wrote:
> >> On Mon, Dec 15, 2025 at 05:04:17PM +0800, Vernon Yang wrote:
> >> >The following data is traced by bpftrace on a desktop system. After
> >> >the system has been left idle for 10 minutes upon booting, a lot of
> >> >SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> >> >khugepaged.
> >> >
> >> >@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> >> >@scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> >> >@scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> >> >total progress size: 701 MB
> >> >Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> >> >
> >> >The khugepaged_scan list save all task that support collapse into hugepage,
> >> >as long as the take is not destroyed, khugepaged will not remove it from
> >> >the khugepaged_scan list. This exist a phenomenon where task has already
> >> >collapsed all memory regions into hugepage, but khugepaged continues to
> >> >scan it, which wastes CPU time and invalid, and due to
> >> >khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> >> >scanning a large number of invalid task, so scanning really valid task
> >> >is later.
> >> >
> >> >After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> >> >SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> >> >list. If the page fault or MADV_HUGEPAGE again, it is added back to
> >> >khugepaged.
> >>
> >> Two thing s come up my mind:
> >>
> >>   * what happens if we split the huge page under memory pressure?
> >
> >static unsigned int shrink_folio_list(struct list_head *folio_list,
> >		struct pglist_data *pgdat, struct scan_control *sc,
> >		struct reclaim_stat *stat, bool ignore_references,
> >		struct mem_cgroup *memcg)
> >{
> >	...
> >
> >	folio = lru_to_folio(folio_list);
> >
> >	...
> >
> >	references = folio_check_references(folio, sc);
> >	switch (references) {
> >	case FOLIOREF_ACTIVATE:
> >		goto activate_locked;
> >	case FOLIOREF_KEEP:
> >		stat->nr_ref_keep += nr_pages;
> >		goto keep_locked;
> >	case FOLIOREF_RECLAIM:
> >	case FOLIOREF_RECLAIM_CLEAN:
> >		; /* try to reclaim the folio below */
> >	}
> >
> >	...
> >
> >	split_folio_to_list(folio, folio_list);
> >}
> >
> >During memory reclaim above, only inactive folios are split. This also
> >implies that the folio is cold, meaning it hasn't been used recently, so
> >we do not expect to put the mm back onto the khugepaged scan list to
> >continue scan/collapse. khugeapged needs to scan hot folios as much as
> >possible priorityly and collapse hot folios to avoid wasting CPU.
> >
>
> So we will never pout this process back onto the scan list, right?

No, if the page fault or MADV_HUGEPAGE again, this task is added back to
khugepaged scan list. Just doesn't actively put this task back to the
khugepaged scan list after splitting.

>
> >>   * would this interfere with mTHP collapse?
> >
> >It has no impact on mTHP collapse, only when all memory is either
> >SCAN_PMD_MAPPED or SCAN_PMD_NONE, the mm will be removed automatically.
> >other cases will not be removed.
> >
> >Let me know if I missed something please, thanks!
> >
> >>
> >> >
> >> >Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >> >---
> >> > mm/khugepaged.c | 35 +++++++++++++++++++++++++----------
> >> > 1 file changed, 25 insertions(+), 10 deletions(-)
> >> >
> >> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> >index 0598a19a98cc..1ec1af5be3c8 100644
> >> >--- a/mm/khugepaged.c
> >> >+++ b/mm/khugepaged.c
> >> >@@ -115,6 +115,7 @@ struct khugepaged_scan {
> >> > 	struct list_head mm_head;
> >> > 	struct mm_slot *mm_slot;
> >> > 	unsigned long address;
> >> >+	bool maybe_collapse;
> >> > };
> >> >
> >> > static struct khugepaged_scan khugepaged_scan = {
> >> >@@ -1420,22 +1421,19 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> >> > 	return result;
> >> > }
> >> >
> >> >-static void collect_mm_slot(struct mm_slot *slot)
> >> >+static void collect_mm_slot(struct mm_slot *slot, bool maybe_collapse)
> >> > {
> >> > 	struct mm_struct *mm = slot->mm;
> >> >
> >> > 	lockdep_assert_held(&khugepaged_mm_lock);
> >> >
> >> >-	if (hpage_collapse_test_exit(mm)) {
> >> >+	if (hpage_collapse_test_exit(mm) || !maybe_collapse) {
> >> > 		/* free mm_slot */
> >> > 		hash_del(&slot->hash);
> >> > 		list_del(&slot->mm_node);
> >> >
> >> >-		/*
> >> >-		 * Not strictly needed because the mm exited already.
> >> >-		 *
> >> >-		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> >> >-		 */
> >> >+		if (!maybe_collapse)
> >> >+			mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> >> >
> >> > 		/* khugepaged_mm_lock actually not necessary for the below */
> >> > 		mm_slot_free(mm_slot_cache, slot);
> >> >@@ -2397,6 +2395,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >> > 				     struct mm_slot, mm_node);
> >> > 		khugepaged_scan.address = 0;
> >> > 		khugepaged_scan.mm_slot = slot;
> >> >+		khugepaged_scan.maybe_collapse = false;
> >> > 	}
> >> > 	spin_unlock(&khugepaged_mm_lock);
> >> >
> >> >@@ -2470,8 +2469,18 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >> > 					khugepaged_scan.address, &mmap_locked, cc);
> >> > 			}
> >> >
> >> >-			if (*result == SCAN_SUCCEED)
> >> >+			switch (*result) {
> >> >+			case SCAN_PMD_NULL:
> >> >+			case SCAN_PMD_NONE:
> >> >+			case SCAN_PMD_MAPPED:
> >> >+			case SCAN_PTE_MAPPED_HUGEPAGE:
> >> >+				break;
> >> >+			case SCAN_SUCCEED:
> >> > 				++khugepaged_pages_collapsed;
> >> >+				fallthrough;
> >>
> >> If collapse successfully, we don't need to set maybe_collapse to true?
> >
> >Above "fallthrough" explicitly tells the compiler that when the collapse is
> >successful, run below "khugepaged_scan.maybe_collapse = true" :)
> >
>
> Got it, thanks.
>
> >> >+			default:
> >> >+				khugepaged_scan.maybe_collapse = true;
> >> >+			}
> >> >
> >> > 			/* move to next address */
> >> > 			khugepaged_scan.address += HPAGE_PMD_SIZE;
> >> >@@ -2500,6 +2509,11 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >> > 	 * if we scanned all vmas of this mm.
> >> > 	 */
> >> > 	if (hpage_collapse_test_exit(mm) || !vma) {
> >> >+		bool maybe_collapse = khugepaged_scan.maybe_collapse;
> >> >+
> >> >+		if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
> >> >+			maybe_collapse = true;
> >> >+
> >> > 		/*
> >> > 		 * Make sure that if mm_users is reaching zero while
> >> > 		 * khugepaged runs here, khugepaged_exit will find
> >> >@@ -2508,12 +2522,13 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >> > 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> >> > 			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
> >> > 			khugepaged_scan.address = 0;
> >> >+			khugepaged_scan.maybe_collapse = false;
> >> > 		} else {
> >> > 			khugepaged_scan.mm_slot = NULL;
> >> > 			khugepaged_full_scans++;
> >> > 		}
> >> >
> >> >-		collect_mm_slot(slot);
> >> >+		collect_mm_slot(slot, maybe_collapse);
> >> > 	}
> >> >
> >> > 	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> >> >@@ -2616,7 +2631,7 @@ static int khugepaged(void *none)
> >> > 	slot = khugepaged_scan.mm_slot;
> >> > 	khugepaged_scan.mm_slot = NULL;
> >> > 	if (slot)
> >> >-		collect_mm_slot(slot);
> >> >+		collect_mm_slot(slot, true);
> >> > 	spin_unlock(&khugepaged_mm_lock);
> >> > 	return 0;
> >> > }
> >> >--
> >> >2.51.0
> >> >
> >>
> >> --
> >> Wei Yang
> >> Help you, Help me
> >
> >--
> >Thanks,
> >Vernon
>
> --
> Wei Yang
> Help you, Help me

--
Thanks,
Vernon

