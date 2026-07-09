Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95247C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2136B0088; Wed,  8 Jul 2026 23:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363186B008A; Wed,  8 Jul 2026 23:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254576B008C; Wed,  8 Jul 2026 23:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC8F46B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67A1A168F3F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:48:57 +0000 (UTC)
X-FDA: 84967857114.29.D63DC04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A5BBD40002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:48:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ey6omSp1;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783568935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWqonKtM4F3uLr7KBmbpx/TrfnzDPiskloBr1860j2M=;
	b=XsujjEuJFdRpg9FqeHgLvz9v+KhLArXHF3yr1qshQ3Mx1v71YkPiSoC7qwEWDBqyMCYpXJ
	40u5flGPh0FjwXOyCWlV42tPrACKCQuXBwlaGH3vbmEspxHUvss9MpaeXYrRizyfL48Aig
	MNiqoUBdlHDKgD/fw1OuOF1KSM9HMpM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ey6omSp1;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783568935;
	b=3i9AEOy06IGummgqlAckGLe3ap9zFRBYW95dWEexF3a/2Bb7fn7PQ6FIOvNnpl0vX6SbS8
	Xe+yEMjwL2ICos7YbOjzhdinV3tcuEnznLL/tIUMZk91n5hb/gInj6RIoOhAsxirjBjRpD
	FkGMx+7M/Eo/QMnHSAG6smwqlQwg8UM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E439960EEF;
	Thu,  9 Jul 2026 03:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32871F000E9;
	Thu,  9 Jul 2026 03:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783568934;
	bh=GWqonKtM4F3uLr7KBmbpx/TrfnzDPiskloBr1860j2M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ey6omSp1UGywZOoCct0axZFb0BPm8vsCdgcoDYXBos8zGWrCEeRAJzjl+g2stWunU
	 7E8MNeMI63wFFgfWGXfeOWnNvrjtcVbnSalsx3tUfwCtQlRs91ollPb+6ABPtzxkEh
	 VMX3RCOmkQQxq1W1NZhVhoKl1ieh2VBNKPb1tito=
Date: Wed, 8 Jul 2026 20:48:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui
 Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v11] mm: fix ASSERT_EXCLUSIVE_BITS by passing
 memdesc_flags_t by pointer
Message-Id: <20260708204853.8542f27d6554c1ff3ce7162e@linux-foundation.org>
In-Reply-To: <20260708083308.747930-1-hui.zhu@linux.dev>
References: <20260708083308.747930-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fkxs9wy96tastn7pokufeydz3gcnacx4
X-Rspamd-Queue-Id: A5BBD40002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783568935-960268
X-HE-Meta: U2FsdGVkX18b7ew3odYAWFKwpU799Tr78SPpZaQFglgmPoeIkdF8DiairrhJrz9XgtvOtHN3ShabjMcaef9hpXvg5yT0IaqZsypgMlfHxBZ62qMjqteS6P3QE8ORVOLTy8DLeqXDt7y1fbsOV/ZZPI4ahktJQQTuyFCDhnqndvT/x5L4sIJLPOutxaM33TxQW5TX1nDROLJcQu8JQZs+YAbvawgwjILOwewqvNZXuSR1p3MEmHR/p02pV/JWE9AdGWfnwtAaR235fqmUy9rKkT5RFDmBkKf3YCQ2b/XfWBzUornPvm3pAp/EJNFFyYZ7uyuiSYMTk5U1tsb38Ip4G1aL8CVEbQK2IrBaq6QuiNfbqp4t5/rYiBqLm9i/sTxEZdewH2Fq4dBBPe66nr5ITJgRNUWEaqBELGZ3rHwmKygbDjlg+l19LLH0sbVMdaWcKeiE7TnalQe8Xsosz6fl/dQSpLbpNpVjf6zFc6YPew5loYxKP63GLIk5ia7bJ32dUjYm/wYwSa3JDJqymlZ8lwvJbljpGczMIh+VE9zrPc/8de5FO+y6edkLLZqSRbuQL3sfVBlpli1P5Zn6NXPpZKPwgfOTdkzOPR/qT1O6YI+OqEy/BdAzZRWWFCA6eExPMC1eMIierAlLq+1OROMZxR2Lb4LIQAx8I9+vcKp/Zmjj9wIle7N3BspSMKE/96XXYijTT+0D49FbdrpjHntHfyI90lfC2MLvTOj6CbgNPA/Yp/SrEzmAiV7q4xK4WyS1/ZtFjMyDQJ6wuCcKDQnkLNGM713pvh4r32Mbws0uMiJEkXs/+A9Fiuf1TrTp9t/935/N1tYyqVAigjAvR/+gMC+JxjJsGvqnyh6LJ2/cjuToxYhxb5VGNQ9hic5ni2vQmkgA8sEwuLJCZct1mP/W8uyAZrl7mYdrGEDU+JP1Lj2qq3vIXETSUcKv+E9MuuHavp15Lcedipw1WsMn0p+
 eZ/EpRgf
 OyfnJIQoizdQOYKT67s75McaKM011JeR9lZgaxroHNJthTW7pHKRcSwPKJtXqI/qmLqhC2ySu5sb0xewTsqw+TG27roN4twpk/w2aeqFn7ehembnBHBrJASUTDcclJO/t14JLDQ1unOOt/Xkt6ALeh6jZ1IyP6Ldkn4HhoWkKwJ7DC3ekGP2AXXS9b3X9/FLWfHzFQgwgf/Qq2QpallN79TjXvhm5sjOsvGqOyUOaqOm2LA3maIQGi5lai6ylJFicLNLEeoAfTRKuUg5k7imi+/lud+JRxO2sVSOOarKxgnRcBSxkzYs5B57Cfft/UDTvxTZV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 16:33:08 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The race is benign: nid/zone bits are set once at page init and never
> overlap with PG_locked.  However, ASSERT_EXCLUSIVE_BITS() inside
> memdesc_nid/zonenum() was checking a by-value copy of the flags word,
> not the live page->flags, so it failed to annotate the real access.
> 
> Change memdesc_nid(), memdesc_zonenum(), memdesc_section(), and
> memdesc_is_zone_device() to take a const memdesc_flags_t * and update
> all callers to pass &page->flags / &folio->flags, so
> ASSERT_EXCLUSIVE_BITS() operates on the actual shared word.
> 
> Guard the ASSERT_EXCLUSIVE_BITS() call in memdesc_zonenum() under
> ZONES_WIDTH != 0 to avoid a zero-mask check on configs where the zone
> field is absent.  memdesc_section() needs no such guard, since
> SECTIONS_WIDTH is never 0 wherever SECTION_IN_PAGE_FLAGS is defined.
> Under CONFIG_NUMA=n, memdesc_nid() itself is stubbed to "return 0"
> instead of reading page->flags, since NODES_MASK is 0 and the check
> can never fire; page_to_nid()/folio_nid() now just call memdesc_nid()
> unconditionally and rely on that stub, instead of duplicating the
> CONFIG_NUMA split at each call site.

Thanks.

> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Changelog:
> v11:
> According to the comments of David, simplify page_to_nid() to pass
> &(PF_POISONED_CHECK(page)->flags) directly.
> v10:
> According to the comments of David, drop the redundant CONFIG_NUMA split
> in page_to_nid()/folio_nid() and remove the SECTIONS_WIDTH != 0 guard
> around ASSERT_EXCLUSIVE_BITS() in memdesc_section().

I'm having trouble comparing this changelogging with the actual v9->v11
diff?  "drop the redundant CONFIG_NUMA split"?


--- a/include/linux/mm.h~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
+++ a/include/linux/mm.h
@@ -2303,29 +2303,15 @@ static inline int memdesc_nid(const memd
 #endif
 #endif
 
-#ifdef CONFIG_NUMA
 static inline int page_to_nid(const struct page *page)
 {
-	const struct page *p = PF_POISONED_CHECK(page);
-
-	return memdesc_nid(&p->flags);
+	return memdesc_nid(&(PF_POISONED_CHECK(page)->flags));
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
 	return memdesc_nid(&folio->flags);
 }
-#else
-static inline int page_to_nid(const struct page *page)
-{
-	return 0;
-}
-
-static inline int folio_nid(const struct folio *folio)
-{
-	return 0;
-}
-#endif
 
 #ifdef CONFIG_NUMA_BALANCING
 /* page access time bits needs to hold at least 4 seconds */
@@ -2566,9 +2552,7 @@ static inline void set_page_section(stru
 
 static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
-#if SECTIONS_WIDTH != 0
 	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
-#endif
 	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
_


