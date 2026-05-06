Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237FECD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 16:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A81B6B0088; Wed,  6 May 2026 12:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759806B008C; Wed,  6 May 2026 12:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F0B6B0092; Wed,  6 May 2026 12:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56FBA6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:18:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFF988978F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:18:41 +0000 (UTC)
X-FDA: 84737503242.16.FFBE86C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id E1746100007
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:18:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=RcaAJx5i;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778084320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlhus1pwx5VmyD6fvjLI+ZlJDA72kCWqRJZzTJuDlVs=;
	b=x94BMf5SLCmkLh5/lS15yV3O9frMiV/5GPC5DJjceWnsvtRSk38iPVQtbi+JPDJWgOroeG
	GbFLdRkF5MUUyE9w+tXR60KKG3gx0KVfVPxmUTzI83O/atLfIP6W84idcZIYe/YwQumzvh
	FBy/U7a3EctZoPZ8z6pf4rfphMUBwZE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=RcaAJx5i;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778084320; a=rsa-sha256;
	cv=none;
	b=vcFfUdmV4FtcDtpDJ+PXZgTP9Mc/yra7klExJsevRY1zhO7r16deCm17ROX/xDfxccOg9d
	isK0hb668bv0O+uPY6UsDxnRDI99hbiA1UU1Yz2fquF1l+kyFQka8N09rKPSB0IqorU8dP
	ZBXjpnfKEVRCXpu11TrGdFA9ZB13JBY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=wlhus1pwx5VmyD6fvjLI+ZlJDA72kCWqRJZzTJuDlVs=; b=RcaAJx5iIvZ739Tiu7zXz4RS0e
	x4Pz8iu6KUovclJrPLP8oMBI2gn9wPg1QLLiFUpP/wbTRzeR2uBQJ5SFcvHsHLn4LEY9FtlhWVVWJ
	QdDbO+npzRivvwnkryBi580L4pDrJf8imyXHRNMhS8v51K+GoA3lLl1UEREIUZ4/NXLYB5OOfePY+
	HuhMpwMzKwb7oInmNgILSBMl0ADmlIKOWn7tZ9sSB12v+wt7zCKK7iSN7JsaSN+Io+sgyHm644qtY
	+pTtjk2BHEznKc3IpUcB9gALFtGFQvYWIbXj+90K9LLj+BM8wtF4M2EnKF8+sbV+Yjkuz4+OTSgcz
	5osm1Edg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wKex0-003iLk-00;
	Wed, 06 May 2026 16:18:18 +0000
Date: Wed, 6 May 2026 09:18:12 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	akpm@linux-foundation.org, corbet@lwn.net, skhan@linuxfoundation.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 2/4] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <aftnSfb15G92JON5@gmail.com>
References: <9d365395-051a-436b-9017-352ebc889770@kernel.org>
 <20260428030721.51274-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260428030721.51274-1-lance.yang@linux.dev>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1746100007
X-Rspam-User: 
X-Stat-Signature: xbbhpzdycctwjqdikoop7q45nhyuiobc
X-HE-Tag: 1778084319-610547
X-HE-Meta: U2FsdGVkX188qucECqsHxPfiL6EABITzN/j5KhQ4MjodvhkR+tUMeTYEDuY9fw4n3OGEuGbQJDUxRnKK32xRTH2L+Jb6IAJc/X/DfIZRZ5dZgzCocKCDs3ny/OVSWjU/O9mqEdVVSDPxZs70OEfIt8v2Qkza/jN/r/dyas9XPI0pE2d3Xyms8qXgPYwKTSsp5eOPfs88qzLTS21L2upll1kzaG2LsA6HWc0k2lXzkPum7+hq7ZgOC7Vyz0n5PApawjemOw2zXHpo6AO1HZ/Vmd2dClaIl/Fylmtf32TUcURQmQ2v7D0YhNRWIuPbY9jC6hx8l5EN1JXH1ttqa2dGKefXHFyHzGzPvvDgLq7WZAY+msJzF036WanygOYDkTeXs+yntH5ivViMj4nBE5z9J2mjaTszNnBASC98ajMIo3caw7C+b/M5tiQBgSjzwtww6Ib9ZPvK0sOhDKkiwd5xpVeC6Qb+EuxQUMzqvn79FVi2+IC/xjCSDDKaLIXXRhZ781jM5LR9F3l0T7UWeeENIYKspcklw54movOwxwEbXZCsXsp+kzP6PV+yHKdryPdYw35mqbhUrv5JdeNR5hcY2vc25kIQcYrXNawMC18p3v0Q3TXUrP5zbIB+OXZIROTmwuHmzcKPL55x8laeXzJq06KFylyGek3dSdynhGN2YpyX01ajJ1QDYbBQtc0/wUtL+VGd8DUGsASFIrP1g6sCbm55AEB6ns6x8XKQGQL/abb3/OHA+nMoRUQGuipxN+roakL/jfLqmUAlVmk18ZLyurBKMi36GS38IaLGxa077ILESpeh1pt2nzUFR0dicav9n7wrY4eLkyxInLFKUunOhKVtf5iXCAuUcXdek4Pwfvz2r3Z9HaupjiprIP4ZyK2Te1kqiCG28ceNVpV0Wmwwi65DQc4A0mOZ6H7VwELdwpAW6yMun3ifCV0p4Use3k4F6ub1g8kFxeg0Ff1wM8/
 ScpK1tAb
 e2vgoxwWL0HLiKb+0khlyn27bHRWjhB8Yj6SerP34xYFOHHPFTDpsBGH1wiGG+/+7OmFR6h/GTMEolVRpcZEJdSEmE5MrDH84EA10FyPwjd6F006Zf8K+8lrk9zDE4uKSbOqdEOlmVmwd2rhooGSOFOEvT7NX94bYG7cNCp8TNKO9y0NeVcxYBdCHN95ArIe4Q7MXxqLZC4uyR3b0upxA5OyPcTHP4n8u73VrneBGMUZSs7PReRTUrJ1Tei6YHzi/iZ8tEmZsu9o4wYS1+UBNDuBfAVCy4BPUhaOPhxTYme4338YtpQC957HTnCntXklXz83hYwG3ZD7A/qA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 11:07:21AM +0800, Lance Yang wrote:
> 
> On Mon, Apr 27, 2026 at 05:49:28PM +0200, David Hildenbrand (Arm) wrote:
> >> +	switch (type) {
> >> +	case MF_MSG_KERNEL:
> >> +	case MF_MSG_UNKNOWN:
> >> +		return true;
> >> +	case MF_MSG_KERNEL_HIGH_ORDER:
> >> +		/*
> >> +		 * Rule out a concurrent buddy allocation: give the
> >> +		 * allocator a moment to finish prep_new_page() and
> >> +		 * re-check. A genuine high-order kernel tail page stays
> >> +		 * unowned; an in-flight allocation will have bumped the
> >> +		 * refcount, attached a mapping, or placed the page on
> >> +		 * an LRU by now.
> >> +		 */
> >> +		p = pfn_to_online_page(pfn);
> >> +		if (!p)
> >> +			return true;
> >> +		/*
> >> +		 * Yield so a concurrent allocator on another CPU can
> >> +		 * finish prep_new_page() and have its writes become
> >> +		 * visible before we resample the page state.
> >> +		 */
> >> +		cpu_relax();
> >> +		return page_count(p) == 0 &&
> >> +		       !PageLRU(p) &&
> >> +		       !page_mapped(p) &&
> >> +		       !page_folio(p)->mapping &&
> >> +		       !is_free_buddy_page(p);
> >
> >I don't get what you are doing here. The right way to check for a tail page is
> >not by checking the refcount.
> >
> >Further, you are not holding a folio reference? If so, calling
> >page_mapped/folio_mapped is shaky. On concurrent folio split you can trigger a
> >VM_WARN_ON_FOLIO().
> >
> >
> >Maybe folio_snapshot() is what you are looking for, if you are in fact not
> >holding a reference?
> 
> Right! Maybe we should not try to make this decision in
> panic_on_unrecoverable_mf().
> 
> By the time we get here, we only know the final MF_MSG_* type. The
> real reason why get_hwpoison_page() failed is already lost.
> 
> Wonder if it would be better to split that earlier, around
> __get_unpoison_page()/get_any_page(). That code still knows why
> grabbing the page failed, either an unsupported kernel page or
> just a temporary race we cannot really trust :)
> 
> Then the later panic logic can be simple: panic for the stable
> unsupported kernel page case, and not for the temporary race case.
> 
> That would also avoid trying to guess MF_MSG_KERNEL_HIGH_ORDER here:)

This is a very good feedback, and definitely what I wanted to do, but,
failed. Once we have the reason, we don't need this dance to guess the
reason.

I've hacked a patch based on this approach. How does it sound?

commit ae7a09c989afe7aaed7ac4b5090d993ef1de0b38
Author: Breno Leitao <leitao@debian.org>
Date:   Wed May 6 07:41:30 2026 -0700

    mm/memory-failure: classify get_any_page() failures by reason
    
    When get_any_page() fails to grab a page reference, the *reason* it
    failed is known at the call site but is not surfaced to callers: the
    HWPoisonHandlable() rejection path (a stable kernel page hwpoison cannot
    handle — slab, vmalloc, page tables, kernel stacks, ...) and the
    page_count() / put_page race paths (a transient page-allocator lifecycle
    race) all collapse to a single negative errno by the time
    memory_failure() sees them. memory_failure() can only observe the
    conflated result and reports both as MF_MSG_GET_HWPOISON.
    
    Surface the diagnosis explicitly. Add an mf_get_page_status enum,
    plumbed out through get_any_page() and get_hwpoison_page() (NULL is
    accepted by callers that do not care — unpoison_memory() and
    soft_offline_page() pass NULL). get_any_page() sets the status at the
    moment it gives up:
    
      MF_GET_PAGE_UNHANDLABLE — HWPoisonHandlable() rejected the page
                                after retries.
      MF_GET_PAGE_RACE        — exhausted retries on a refcount /
                                lifecycle race with the allocator.
    
    memory_failure() then promotes the unhandlable case to MF_MSG_KERNEL
    alongside the existing PageReserved branch, and leaves the
    transient-race case as MF_MSG_GET_HWPOISON. The user-visible report
    now distinguishes the two; this also forms the foundation a later
    patch will rely on to decide whether an unrecoverable failure should
    panic.
    
    Suggested-by: Lance Yang <lance.yang@linux.dev>
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f112fb27a8ff6..a83fabadbce99 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1389,7 +1389,32 @@ static int __get_hwpoison_page(struct page *page, unsigned long flags)
 
 #define GET_PAGE_MAX_RETRY_NUM 3
 
-static int get_any_page(struct page *p, unsigned long flags)
+/*
+ * Diagnosis of why get_any_page() failed to grab a page reference.
+ *
+ * Set when ret < 0 so callers (notably memory_failure()) can tell apart
+ * a stable kernel page type that hwpoison cannot handle — slab, vmalloc,
+ * page tables, kernel stacks, etc. — from a transient race with the page
+ * allocator lifecycle (allocation/free in flight). The distinction
+ * matters for panic_on_unrecoverable_mf(): the former is a real
+ * unrecoverable kernel-owned poisoning, the latter must not panic since
+ * the page may be destined for userspace where SIGBUS recovery would
+ * otherwise apply.
+ */
+enum mf_get_page_status {
+	MF_GET_PAGE_OK = 0,
+	/*
+	 * Transient lifecycle race with the page allocator. Recorded for
+	 * symmetry and for future callers that may want to distinguish a
+	 * race from an unhandlable kernel page; no in-tree caller acts on
+	 * this value yet.
+	 */
+	MF_GET_PAGE_RACE,
+	MF_GET_PAGE_UNHANDLABLE,	/* stable kernel page hwpoison cannot handle */
+};
+
+static int get_any_page(struct page *p, unsigned long flags,
+			enum mf_get_page_status *status)
 {
 	int ret = 0, pass = 0;
 	bool count_increased = false;
@@ -1406,11 +1431,15 @@ static int get_any_page(struct page *p, unsigned long flags)
 				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 					goto try_again;
 				ret = -EBUSY;
+				if (status)
+					*status = MF_GET_PAGE_RACE;
 			} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
 				/* We raced with put_page, retry. */
 				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 					goto try_again;
 				ret = -EIO;
+				if (status)
+					*status = MF_GET_PAGE_RACE;
 			}
 			goto out;
 		} else if (ret == -EBUSY) {
@@ -1423,6 +1452,8 @@ static int get_any_page(struct page *p, unsigned long flags)
 				goto try_again;
 			}
 			ret = -EIO;
+			if (status)
+				*status = MF_GET_PAGE_UNHANDLABLE;
 			goto out;
 		}
 	}
@@ -1442,6 +1473,8 @@ static int get_any_page(struct page *p, unsigned long flags)
 		}
 		put_page(p);
 		ret = -EIO;
+		if (status)
+			*status = MF_GET_PAGE_UNHANDLABLE;
 	}
 out:
 	if (ret == -EIO)
@@ -1503,7 +1536,8 @@ static int __get_unpoison_page(struct page *page)
  *         operations like allocation and free,
  *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
  */
-static int get_hwpoison_page(struct page *p, unsigned long flags)
+static int get_hwpoison_page(struct page *p, unsigned long flags,
+			     enum mf_get_page_status *status)
 {
 	int ret;
 
@@ -1511,7 +1545,7 @@ static int get_hwpoison_page(struct page *p, unsigned long flags)
 	if (flags & MF_UNPOISON)
 		ret = __get_unpoison_page(p);
 	else
-		ret = get_any_page(p, flags);
+		ret = get_any_page(p, flags, status);
 	zone_pcp_enable(page_zone(p));
 
 	return ret;
@@ -2349,6 +2383,7 @@ int memory_failure(unsigned long pfn, int flags)
 	bool retry = true;
 	int hugetlb = 0;
 	bool is_reserved;
+	enum mf_get_page_status gp_status = MF_GET_PAGE_OK;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -2424,7 +2459,7 @@ int memory_failure(unsigned long pfn, int flags)
 	 */
 	is_reserved = PageReserved(p);
 
-	res = get_hwpoison_page(p, flags);
+	res = get_hwpoison_page(p, flags, &gp_status);
 	if (!res) {
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
@@ -2445,7 +2480,12 @@ int memory_failure(unsigned long pfn, int flags)
 		}
 		goto unlock_mutex;
 	} else if (res < 0) {
-		if (is_reserved)
+		/*
+		 * Promote a stable unhandlable kernel page diagnosed by
+		 * get_hwpoison_page() to MF_MSG_KERNEL alongside reserved
+		 * pages; transient lifecycle races stay as MF_MSG_GET_HWPOISON.
+		 */
+		if (is_reserved || gp_status == MF_GET_PAGE_UNHANDLABLE)
 			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
 		else
 			res = action_result(pfn, MF_MSG_GET_HWPOISON,
@@ -2750,7 +2790,7 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	ghp = get_hwpoison_page(p, MF_UNPOISON);
+	ghp = get_hwpoison_page(p, MF_UNPOISON, NULL);
 	if (!ghp) {
 		if (folio_test_hugetlb(folio)) {
 			huge = true;
@@ -2957,7 +2997,7 @@ int soft_offline_page(unsigned long pfn, int flags)
 
 retry:
 	get_online_mems();
-	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
+	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE, NULL);
 	put_online_mems();
 
 	if (hwpoison_filter(page)) {


