Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC5ECD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 14:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CB06B0088; Sun, 10 May 2026 10:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D946B008A; Sun, 10 May 2026 10:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A531A6B008C; Sun, 10 May 2026 10:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9542B6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 10:42:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C62A61C0319
	for <linux-mm@kvack.org>; Sun, 10 May 2026 14:42:50 +0000 (UTC)
X-FDA: 84751776900.03.4E8C93A
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF05E4000D
	for <linux-mm@kvack.org>; Sun, 10 May 2026 14:42:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AKU9sa3m;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778424169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtLBmOnLto9xVpl00Lw1ozKRruIqiqHPeh0/9Zkfe0o=;
	b=jClnPtkH6PRR5SZRQN9zZ4WxQEOrAGBN/ukfGao2gZLR+MP2wn+2WxhvpuKSQuQNmlMv2A
	4wu5td5zf1xvgdrrMAuotGOCFofoj85M7VE8psqIHazkGYEERAP6evtvbmP7JvYlaU6jsR
	SiyBw6kweLoS2OdjvZhg+UFTb+uHM1c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AKU9sa3m;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778424169; a=rsa-sha256;
	cv=none;
	b=OcCHbgPQTgX7/MWSAj7Llo0dRYeArC72lqVJQLGdl9BCqkBMWAW1aK2SnAIysL7UUfGWrD
	5VVdvT4tnKiqq3Gc6EEWnGBUHbiXyU5dVYq4CP0HY5Gpt/iC1LZy2ndCeRPC4rTE2VQaTN
	l6MoWg/CvSjXH0X7ALZ/aRYYsGCqcYk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778424164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XtLBmOnLto9xVpl00Lw1ozKRruIqiqHPeh0/9Zkfe0o=;
	b=AKU9sa3mbc8Lf4eG+ZJ3/JPyUGJKV03Jh8cLX0X/7ND+D857JbKPc+nHzAbJNq0NxICQyJ
	tuEnnY1xfi9aVuvTaoiMm5MIUYsDprNgZrpLHckKiL3NObxIgrQVHxDsVrEh+R13x24gjk
	QCV7SLdc3MrI8Exwa9n0n1qX4E+Koq4=
From: Lance Yang <lance.yang@linux.dev>
To: leitao@debian.org
Cc: david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v5 2/4] mm/memory-failure: add panic option for unrecoverable pages
Date: Sun, 10 May 2026 22:42:20 +0800
Message-Id: <20260510144220.92522-1-lance.yang@linux.dev>
In-Reply-To: <aftnSfb15G92JON5@gmail.com>
References: <aftnSfb15G92JON5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7s4om9nrrfhj677wayf89ffemwbawbon
X-Rspamd-Queue-Id: BF05E4000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778424168-631056
X-HE-Meta: U2FsdGVkX1+UFJmVC5YXA5+shI6pxK3ZgTTlod9ZiwX+dKrkPObhTl4gdjmRd7ekrpIazL4Nr0L5KmEsQARFrYkojjxQgjT7T9h8h5SBmjDDTK2wNpGjp7sfappQqdlYAfphuh9Z5xZnKb05++9z9uvBM/l/4VR0ltcusN4XGN6903rq0fK37e9bWTyIYWElSw+yqiNu9ZrNIxNwMmmIuIEBk8AaUlVsXb17HRzZc8hAuvn2Oes8PIxAWOczqUdu9b2t8feFepenjkkjWuCWvr8yklK0G9Fkv4fCGTvWkCiKhcNpb/zVKas/PvjUJjAZCUzlyDJ2TwB5YUbhWhLxqC0bzAWZtxomwNL8uCEvKMTPg4v3HiqIc7T0wg7IwXBjmU+OQ3KcE3N04jp+rpkyTWwgNkkVL9dcsb3bIoyqeDK5mQHHQq4fwU/+77CVXrdqnvuAH77j+zQ+VXMioH/OgkbZRHg1Qw+1lktDduRP3t9xqmL1aunTk7L4TTpnehRHzTcXq3Gvq4rbSmWNA3DljOATNOsb/9WzLDCnYIX6pxLMRCnS8lOkdgA7l6zK8+sRvkzYYD852UzhjzORVPOJPHAy0x3m+fMp3Fgyt+2TOY3qTaHPi7dtyR91H+Ib+DXcTl+GKleVfTCBJHHeAr8/Oy3N7De2xnGxeLIaQAHeXdamiKa6OoBdnXZy3J4DH/jkrufffoZBL/f5m++JP5LJPQWaCRS2+xoxrHyrNF86OjrnBbqawrZuMH4ZwALyBSi9ZMwQw/A3P4E76j6l7O3ml9/EEv9gTfxHLQzjx7INDcY9nLF02l3H854zW/++jmyLxIta9xKdGuzbYUNGLcC1QWNX1KMBp20HkrX+uW7wVllQHPGfY7N7ThKWNHIZgnITaukcAuUnKMGqccbGXF+Whev7LadT5kzJp0oLNOVjoYga66nj+rMvvoyyWkzAKrhYYGP9X+4+jY4rn8XWMrp
 PmKm9nyf
 DUmHQYTsCIfKs2p56P8ETyEPyfScpW+oVLS/t36/2ZlaJ65LhAgvnl9cF3Ju2NfiSsScjIWp/6sXttFlUX/E49zf/akfpAovgQ9lLzh3C5oLINrwK/JoVJIjA+mLDGsmaPS6UInyWQCSaKDhFYVfcGJD7xLfTO1UhmmvLc2nwZaT29lD3Wtg9PeN60u1Hs9+ENTRtgNpI5nepVS/y9o+tilwJlry6ymGDq8tlR5XDq+Dk8J+sMsPcFt5mXQMbYHHfBivxh/LoLNTTque7xiASAzcw7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 06, 2026 at 09:18:12AM -0700, Breno Leitao wrote:
>On Tue, Apr 28, 2026 at 11:07:21AM +0800, Lance Yang wrote:
>> 
>> On Mon, Apr 27, 2026 at 05:49:28PM +0200, David Hildenbrand (Arm) wrote:
>> >> +	switch (type) {
>> >> +	case MF_MSG_KERNEL:
>> >> +	case MF_MSG_UNKNOWN:
>> >> +		return true;
>> >> +	case MF_MSG_KERNEL_HIGH_ORDER:
>> >> +		/*
>> >> +		 * Rule out a concurrent buddy allocation: give the
>> >> +		 * allocator a moment to finish prep_new_page() and
>> >> +		 * re-check. A genuine high-order kernel tail page stays
>> >> +		 * unowned; an in-flight allocation will have bumped the
>> >> +		 * refcount, attached a mapping, or placed the page on
>> >> +		 * an LRU by now.
>> >> +		 */
>> >> +		p = pfn_to_online_page(pfn);
>> >> +		if (!p)
>> >> +			return true;
>> >> +		/*
>> >> +		 * Yield so a concurrent allocator on another CPU can
>> >> +		 * finish prep_new_page() and have its writes become
>> >> +		 * visible before we resample the page state.
>> >> +		 */
>> >> +		cpu_relax();
>> >> +		return page_count(p) == 0 &&
>> >> +		       !PageLRU(p) &&
>> >> +		       !page_mapped(p) &&
>> >> +		       !page_folio(p)->mapping &&
>> >> +		       !is_free_buddy_page(p);
>> >
>> >I don't get what you are doing here. The right way to check for a tail page is
>> >not by checking the refcount.
>> >
>> >Further, you are not holding a folio reference? If so, calling
>> >page_mapped/folio_mapped is shaky. On concurrent folio split you can trigger a
>> >VM_WARN_ON_FOLIO().
>> >
>> >
>> >Maybe folio_snapshot() is what you are looking for, if you are in fact not
>> >holding a reference?
>> 
>> Right! Maybe we should not try to make this decision in
>> panic_on_unrecoverable_mf().
>> 
>> By the time we get here, we only know the final MF_MSG_* type. The
>> real reason why get_hwpoison_page() failed is already lost.
>> 
>> Wonder if it would be better to split that earlier, around
>> __get_unpoison_page()/get_any_page(). That code still knows why
>> grabbing the page failed, either an unsupported kernel page or
>> just a temporary race we cannot really trust :)
>> 
>> Then the later panic logic can be simple: panic for the stable
>> unsupported kernel page case, and not for the temporary race case.
>> 
>> That would also avoid trying to guess MF_MSG_KERNEL_HIGH_ORDER here:)
>
>This is a very good feedback, and definitely what I wanted to do, but,
>failed. Once we have the reason, we don't need this dance to guess the
>reason.
>
>I've hacked a patch based on this approach. How does it sound?

Yes. This direction makes sense to me, not an expert though :D

I played with something similar (untested) on top of patch #01:

---8<---
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 432d5f996c64..a2799f063913 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;

 static int sysctl_enable_soft_offline __read_mostly = 1;

+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);

 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };

@@ -1281,6 +1292,18 @@ static void update_per_node_mf_stats(unsigned long pfn,
 	++mf_stats->total;
 }

+static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
+				      enum mf_result result)
+{
+	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
+		return false;
+
+	if (type == MF_MSG_KERNEL)
+		return true;
+
+	return false;
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1298,6 +1321,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);

+	if (panic_on_unrecoverable_mf(type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }

@@ -1389,11 +1415,27 @@ static int __get_hwpoison_page(struct page *page, unsigned long flags)

 #define GET_PAGE_MAX_RETRY_NUM 3

-static int get_any_page(struct page *p, unsigned long flags)
+enum mf_get_page_status {
+	MF_GET_PAGE_OK = 0,
+	MF_GET_PAGE_RACE,
+	MF_GET_PAGE_UNHANDLABLE,
+};
+
+static void set_mf_get_page_status(enum mf_get_page_status *gp_status,
+				   enum mf_get_page_status value)
+{
+	if (gp_status)
+		*gp_status = value;
+}
+
+static int get_any_page(struct page *p, unsigned long flags,
+			enum mf_get_page_status *gp_status)
 {
 	int ret = 0, pass = 0;
 	bool count_increased = false;

+	set_mf_get_page_status(gp_status, MF_GET_PAGE_OK);
+
 	if (flags & MF_COUNT_INCREASED)
 		count_increased = true;

@@ -1406,11 +1448,13 @@ static int get_any_page(struct page *p, unsigned long flags)
 				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 					goto try_again;
 				ret = -EBUSY;
+				set_mf_get_page_status(gp_status, MF_GET_PAGE_RACE);
 			} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
 				/* We raced with put_page, retry. */
 				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 					goto try_again;
 				ret = -EIO;
+				set_mf_get_page_status(gp_status, MF_GET_PAGE_RACE);
 			}
 			goto out;
 		} else if (ret == -EBUSY) {
@@ -1423,6 +1467,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 				goto try_again;
 			}
 			ret = -EIO;
+			set_mf_get_page_status(gp_status, MF_GET_PAGE_UNHANDLABLE);
 			goto out;
 		}
 	}
@@ -1442,6 +1487,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 		}
 		put_page(p);
 		ret = -EIO;
+		set_mf_get_page_status(gp_status, MF_GET_PAGE_UNHANDLABLE);
 	}
 out:
 	if (ret == -EIO)
@@ -1480,6 +1526,7 @@ static int __get_unpoison_page(struct page *page)
  * get_hwpoison_page() - Get refcount for memory error handling
  * @p:		Raw error page (hit by memory error)
  * @flags:	Flags controlling behavior of error handling
+ * @gp_status:	Optional output for the reason get_any_page() failed
  *
  * get_hwpoison_page() takes a page refcount of an error page to handle memory
  * error on it, after checking that the error page is in a well-defined state
@@ -1503,7 +1550,8 @@ static int __get_unpoison_page(struct page *page)
  *         operations like allocation and free,
  *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
  */
-static int get_hwpoison_page(struct page *p, unsigned long flags)
+static int get_hwpoison_page(struct page *p, unsigned long flags,
+			     enum mf_get_page_status *gp_status)
 {
 	int ret;

@@ -1511,7 +1559,7 @@ static int get_hwpoison_page(struct page *p, unsigned long flags)
 	if (flags & MF_UNPOISON)
 		ret = __get_unpoison_page(p);
 	else
-		ret = get_any_page(p, flags);
+		ret = get_any_page(p, flags, gp_status);
 	zone_pcp_enable(page_zone(p));

 	return ret;
@@ -2341,6 +2389,7 @@ static int memory_failure_pfn(unsigned long pfn, int flags)
  */
 int memory_failure(unsigned long pfn, int flags)
 {
+	enum mf_get_page_status gp_status = MF_GET_PAGE_OK;
 	struct page *p;
 	struct folio *folio;
 	struct dev_pagemap *pgmap;
@@ -2413,7 +2462,7 @@ int memory_failure(unsigned long pfn, int flags)
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	is_reserved = PageReserved(p);
-	res = get_hwpoison_page(p, flags);
+	res = get_hwpoison_page(p, flags, &gp_status);
 	if (!res) {
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
@@ -2437,9 +2486,13 @@ int memory_failure(unsigned long pfn, int flags)
 		/*
 		 * Pages with PG_reserved set are not currently managed by the
 		 * page allocator (memblock-reserved memory, driver reservations,
-		 * etc.), so classify them as kernel-owned for reporting.
+		 * etc.), so classify them as kernel-owned for reporting. Do the
+		 * same for pages that get_any_page() still cannot handle after
+		 * retries: likely non-LRU/non-buddy pages such as slab, kernel
+		 * stack, page table or vmalloc-backed pages. Transient lifecycle
+		 * races stay as MF_MSG_GET_HWPOISON.
 		 */
-		if (is_reserved)
+		if (is_reserved || gp_status == MF_GET_PAGE_UNHANDLABLE)
 			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
 		else
 			res = action_result(pfn, MF_MSG_GET_HWPOISON,
@@ -2744,7 +2797,7 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}

-	ghp = get_hwpoison_page(p, MF_UNPOISON);
+	ghp = get_hwpoison_page(p, MF_UNPOISON, NULL);
 	if (!ghp) {
 		if (folio_test_hugetlb(folio)) {
 			huge = true;
@@ -2951,7 +3004,7 @@ int soft_offline_page(unsigned long pfn, int flags)

 retry:
 	get_online_mems();
-	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
+	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE, NULL);
 	put_online_mems();

 	if (hwpoison_filter(page)) {
---

I would leave MF_MSG_KERNEL_HIGH_ORDER out for now. That path still
has the allocator race David pointed out, unless there is easy way to
rule that out ...

Also would leave MF_MSG_UNKNOWN out. We don't really know what it is no?
So it's not good basis for a panic decision :)

Maybe better to keep panic_on_unrecoverable_mf simple: classify the
get_any_page() failure reason earlier, but only panic on MF_MSG_KERNEL.

IMHO, making the knob too complicated for memory failures that should be
rare does not seem worth it. Just covering MF_MSG_KERNEL should already
help crash analysis a lot :)

Feel free to pick up any bits that look useful :)

Cheers, Lance

[...]

