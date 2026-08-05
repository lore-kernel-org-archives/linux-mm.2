Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF04C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB796B00AC; Wed,  5 Aug 2026 05:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0957E6B00AF; Wed,  5 Aug 2026 05:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7226B00B0; Wed,  5 Aug 2026 05:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFB5D6B00AC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:07:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48D56403E2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:07:25 +0000 (UTC)
X-FDA: 85066637250.30.A7B998F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8340718000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:07:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBdhs7jU;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785920843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6j+r2aySq3vbagzG6uXiIoHKnNOhVDFA/2TCxgRiS0=;
	b=cHx30ib2MK+vg4CUrvqC+T6fqaehqmOaNhwMzXwmM97g4GR+ZfG460v6UXcAPzZat6+IpK
	0kyQJ0bKUYvLrxF81zRzhtoEh5PwfbiHq+gRuXr1/btRFvm1SLjsSswIcnbBqBNAz9Tu5m
	wunYUScVY1v842TvXOe4USy4rBk4QZw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBdhs7jU;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785920843;
	b=7h33vslNT3HoyBDNDGfvEOz6ICMx0SxM5f+A9zFhLn2B1hGmpcjEZlo3HlLB4Pa9LEQE7k
	GaA4dRUrvgC2fwHjsQeQmCAlqA+hZmTywNdZ1WJrd7urWxIsuN/Xj/v4DeLzxq/327Y6s5
	eEyd+kVU/rouLXWjimpSdTrtNE1pwgU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EABB60A6A;
	Wed,  5 Aug 2026 09:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536EF1F000E9;
	Wed,  5 Aug 2026 09:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785920842;
	bh=n6j+r2aySq3vbagzG6uXiIoHKnNOhVDFA/2TCxgRiS0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iBdhs7jUQaHuD4S0GiReJEJbIqkaUBKtt7iV461bZhDSVS24pXpFDQazjk6hUJNZU
	 a3/vHMxqwTi6TSXMWvlmCKEaZpI+MDD+su2F6wyYH9BCDj9NUJcFnb+KElhOVS17Wg
	 yQ8jUnmcYvQo4DuXxZmvEU0SYCsMDGdXIYxK2LUxrmQyVzqYvacOIlCb89UJNflFhb
	 HQwNu6HU+f5lSVKhOu9/EhcPnDfyl+5nBXXQiMbRaO2prRQV8w5H2klhbHC5hGRsR3
	 jQkDNqRpfkZf7TVSTVW9uqIch8DCeFz4KRHDtf40QbQNHSiVC08Bjc4TnrwHsYPOMI
	 JyykHZjJ2P86A==
Message-ID: <dbdb0f70-669b-4c68-a9cf-89d30c20f12f@kernel.org>
Date: Wed, 5 Aug 2026 11:07:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix concurrent access issue in
 min_order_for_split()
To: dayou5941@163.com, akpm@linux-foundation.org, ljs@kernel.org
Cc: ziy@nvidia.com, linux-mm@kvack.org, liyouhong <liyouhong@kylinos.cn>,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260805072625.2437636-1-dayou5941@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805072625.2437636-1-dayou5941@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6okrad5r4sjah1j8ob6bmqjuh4ss3mhb
X-Rspamd-Queue-Id: 8340718000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785920843-990940
X-HE-Meta: U2FsdGVkX19kXcjfv1eRj7I8rUPqTOE0/anjjstyGv/xi9Z97SCqNpXzbABqGzsE7F7ZXAGC43kKAjdw4zx1Jd7uWoVAXCbuK39cF3ityLW+d268OQDa4DsdnfU5H87IqpuTRZ5+I/MTVKfv4bZjD5qrsv0Dv/gXFRNZd2E36c7UQR+s1IgIA2eCcssOd7WwMUnwDSmYXqNC4Es0vlhxSXUxEycQF+jX+9ONOzfyclV5U/iz8OutK0ydL+htHmGSJyVg5hU2L/dDSrTx0sil1g7hicec6HQwZJtMOuiviUT7XXuVxkDDUwI5Oie8JQqdvqPegaKChcETSQmd8A9NKE88/HRIl9vnVLXJhZ49rt1iJYqqwimoqP+oeLF7CEJ8ghW6LxNsxASwgt5UkoN7S3sMtMWhYqT/A1oUXNKHfroGdogx/8rhnnEGkB7qOGhRglEhqmRQEQrNziCeQ1OhhhGkiXC0tB9DedY5NOCm9hTD1qT5h0INz8Wwc9BBd74U7JsQadQjFe5PU1zkrjnVbxs3fAC4MQT2haqU6BKtlLdUwE3TSYzqpGnpUIpEkKfAWjgh/XQ9F5kO2yMKRDCaiq6K/+OR9F6sAD1laD41/4W0vuCKaaJCuiHV/jqURJC+VgXMauBR/3gTxPm6z+yH1AEpCbNMfjV0CdtOTguZc5xUEOglTIvSW85fWZ4WGq0jW6027H60A/PfTwtkxubk5LAaramqqUKbNTOdInkjT8PPyaKUIvPHLKqC8impq6WHTofhKczJjsuRytqci0gkcRztXq6jOa68mpzTRvfb0p3c4BK2GI9ISmcRIyLybOf4kpRUhYgNs7uhfIQ6Mh2sdoI0LELRFGutPTz2KXi/I6B51AVp43kCq9/I841O6EGmDS1BaMIXYT5TpHpl1s+SnCVx3l+gbuWsOwqEEL/EI3lhuVcc3+txgyjz+uv/5n5CbPtEYKeHsgMw8mIcbQr
 7xtBxPW9
 iBnzOSJQOV/oU5jbO7UAYAHYK0Ol27NKZa/FaGh/HcNhWtHdWBvMWZI1Tg8ID5RtwS1MCxQ0ydutYxulxrxIwUh4Em41VIqD6siyWRmkPJzIfUEtBURnSTSQuXCimCJIijyNBvKbDh54+ohiYXC7unWH0fZnLBRzzOWZuEgGkw9HuFgENUEdZsS2Yx59zD+DzW7BAnFHyAxGfltZqY5/PuVC4mIdnxJi0P4Z4fnYpm1kdha7Co1fKbiYZlzBEKTAk9doenlAphK4gFINVhfb0MxB+mwS4UmjqN+Upww8O92RIIXgqerqCaUGeVzjIveSANo48IUeyn+kJsTfHciyzZuVyyG3ybls9gSaGI+HqTsePJUZuGnecGvJMVmyYxySSEtSzZ7f1lNOVPbxqOnuBx5bbWj/GyViGoRx+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 09:26, dayou5941@163.com wrote:
> From: liyouhong <liyouhong@kylinos.cn>
> 
> min_order_for_split() accesses folio->mapping without proper
> synchronization. While the compiler typically caches the value
> in a register making a NULL deref unlikely in practice, the
> real issue is that the callers in memory-failure.c do not hold
> the folio lock at the time of the call:
> 
> - memory_failure() explicitly drops the folio lock before calling
>   min_order_for_split().
> - soft_offline_in_use_page() has not yet acquired the folio lock
>   when calling min_order_for_split().
> 
> This means the value of folio->mapping may be modified by a
> truncate or invalidate operation while min_order_for_split() is
> executing, leading to a torn read or use of a stale mapping value.

I recall that a mapping can get freed after truncating the last folio.

But Lorenzo had some cocnerns about the validity of the report, so I'll let him reply.

> 
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260803060001.800638-1-dayou5941@163.com
> Cc: stable@vger.kernel.org
> Signed-off-by: liyouhong <liyouhong@kylinos.cn>
> ---
> v2:
> - Dropped the approach of caching folio->mapping inside min_order_for_split() in favor of adding the folio lock at the callers.
> - Added VM_WARN_ON_ONCE_FOLIO() in min_order_for_split().
> - Updated the commit message to clarify that the real issue is the callers not holding the folio lock, rather than a TOCTOU race.
> v1: https://lore.kernel.org/all/20260804035828.2684059-1-dayou5941@163.com/
> 
> ---
>  mm/huge_memory.c    |  2 ++
>  mm/memory-failure.c | 12 ++++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 58cabe6af33d..e3f16dadc1d4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4300,6 +4300,8 @@ int folio_split(struct folio *folio, unsigned int new_order,
>   */
>  unsigned int min_order_for_split(struct folio *folio)
>  {
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
>  	if (folio_test_anon(folio))
>  		return 0;
>  
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3b1e6946821b..7391524b5046 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2437,12 +2437,17 @@ int memory_failure(unsigned long pfn, int flags)
>  		res = -EOPNOTSUPP;
>  		goto unlock_mutex;
>  	}
> +
>  	folio_unlock(folio);
>  
>  	if (folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
> +		const int new_order;
>  		int err;
>  
> +		folio_lock(folio);
> +		new_order = min_order_for_split(folio);
> +		folio_unlock(folio);
> +
>  		/*
>  		 * The flag must be set after the refcount is bumped
>  		 * otherwise it may race with THP split.
> @@ -2796,8 +2801,11 @@ static int soft_offline_in_use_page(struct page *page)
>  	};
>  
>  	if (!huge && folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
> +		const int new_order;
>  
> +		folio_lock(folio);
> +		new_order = min_order_for_split(folio);
> +		folio_unlock(folio);
>  		/*
>  		 * If new_order (target split order) is not 0, do not split the
>  		 * folio at all to retain the still accessible large folio.

We already grab the page lock in try_to_split_thp_page(). I think these
needs a serious cleanup.

While at it, we can fix the missing put_page() in case new_order != 0 in
soft_offline_in_use_page() ...

So i think we really should do the following:


From 58c4ccbb04e13c4c14ef7a94f4b44f8901183081 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 5 Aug 2026 11:01:46 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory-failure.c | 46 +++++++++++++++------------------------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aaf14608b30e2..de97a7a36764d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1705,26 +1705,6 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 	return page_action(ps, p, pfn);
 }
 
-/*
- * When 'release' is 'false', it means that if thp split has failed,
- * there is still more to do, hence the page refcount we took earlier
- * is still needed.
- */
-static int try_to_split_thp_page(struct page *page, unsigned int new_order,
-		bool release)
-{
-	int ret;
-
-	lock_page(page);
-	ret = split_huge_page_to_order(page, new_order);
-	unlock_page(page);
-
-	if (ret && release)
-		put_page(page);
-
-	return ret;
-}
-
 static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
 		struct address_space *mapping, pgoff_t index, int flags)
 {
@@ -2509,7 +2489,6 @@ int memory_failure(unsigned long pfn, int flags)
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
 		int err;
 
 		/*
@@ -2526,24 +2505,24 @@ int memory_failure(unsigned long pfn, int flags)
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+
+		lock_page(p);
+		err = split_huge_page_to_order(p, min_order_for_split(folio));
+		unlock_page(p);
 		/*
 		 * If splitting a folio to order-0 fails, kill the process.
 		 * Split the folio regardless to minimize unusable pages.
 		 * Because the memory failure code cannot handle large
 		 * folios, this split is always treated as if it failed.
 		 */
-		if (err || new_order) {
-			/* get folio again in case the original one is split */
-			folio = page_folio(p);
+		folio = page_folio(p);
+		if (folio_test_large(folio)) {
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
 			goto unlock_mutex;
 		}
-		VM_BUG_ON_PAGE(!page_count(p), p);
-		folio = page_folio(p);
 	}
 
 	/*
@@ -2862,8 +2841,7 @@ static int soft_offline_in_use_page(struct page *page)
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
-
+		lock_page(page);
 		/*
 		 * If new_order (target split order) is not 0, do not split the
 		 * folio at all to retain the still accessible large folio.
@@ -2871,8 +2849,14 @@ static int soft_offline_in_use_page(struct page *page)
 		 * preferred, split it to non-zero new_order like it is done in
 		 * memory_failure().
 		 */
-		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
-						       /* release= */ true)) {
+		if (!min_order_for_split(folio))
+			ret = split_huge_page_to_order(page, 0);
+		else
+			ret = -EBUSY;
+		unlock_page(page);
+
+		if (ret) {
+			put_page(page);
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
-- 
2.43.0


Likely some more cleanups on top are possible.

-- 
Cheers,

David

