Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9916CC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF896B0096; Wed,  9 Sep 2026 10:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7116B00A0; Wed,  9 Sep 2026 10:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE096B00A1; Wed,  9 Sep 2026 10:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62CA96B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:52:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2C7B14013B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:52:24 +0000 (UTC)
X-FDA: 85194514608.07.B89B147
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id D05B2140010
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:52:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=q1HJF9+8;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788965543;
	b=bUfMu4UqxTWkMpgJPmU/o6AiER0AWhxy1jDMV6svmQAQumGH3YTvgKDv0BrbOYQTmHdKNb
	LRXZQGPlAKQeFe/ZI167frsWePGv/FHCjYX4aHskDJlJseNEna3fO0JgsDYRtQIELaNQCD
	7NWTlHQVDsO3gBwVOpQ7uTl786VQWwc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=q1HJF9+8;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XuKEpjzAlxAfLAh8CKafNzWrcgcJNa1sz/QoxOR2nY=;
	b=vglxWb2BhzaupGPUNkdCsbaMh28+UFkAc48yEGAWzxtHNYbKsCz+ikJ662+Td8+eEHWDI8
	YtmTLiLTH2t6bwdU1i2u3zyPpXhf55i9QDVG5yrAqoibmhPPaHEcONEH7B6qNDH2LAX4US
	OtQu+FdBQ1gNUQN920CgAppoJps1FFw=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-90cc372d6b2so67995256d6.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 07:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788965542; x=1789570342; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2XuKEpjzAlxAfLAh8CKafNzWrcgcJNa1sz/QoxOR2nY=;
        b=q1HJF9+8csDQrCE+1kuWQexs4IBLKJNbG8509AI8Ufd8FqUDSdxyQydEhdMM7dsfXv
         kg0Pw6hmeUI9hYy4k/rt1XD9p/GoxffhOrpfFaOiladC1wiWaxTcKzNNshgnKOendtyq
         5Py1KNs2SWNTWWZOVrf+7Yh72+UZ/RJKkd16YWTvmuoY9ZLaX3JhP3+pG5Lb3ID+s1xB
         9qJXYrwMOLNzU/+t6iTkzsEVmlOz7ijXeQMUMXoEWPC5UN+4Nde/zKkz4DfbQqL03VDM
         mTds1secRe4z67Vli72evFJyapvvmOkYGBq+N2kJYZwWuFZxng3U7sLtyLQ9DfHrBR/T
         aKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788965542; x=1789570342;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2XuKEpjzAlxAfLAh8CKafNzWrcgcJNa1sz/QoxOR2nY=;
        b=j21kyfrxTXl+nTYkX166jZ+s/jmYsJxuRrSWLuhkV/sphLQVv/CXbOYNJXv0/cyciz
         C9jXqqAw7DZg8xMuBsvT7RQP3NbCe/JycvXiViyuRL2iUX1YPjP9d3ilScELuevYM8wr
         Ql6orSIjEia48P7oTsVW2KQX0cYMCMZVvGsfo32OPIe1U1hxRexvkMi7yyhpCuOovos0
         bHmRfc4kekMyuceRP5IggzdBZQz6kHztLN2Y8W1OuEgK4LRGnH13psYvdH+P7YByya8y
         IHQCA3wxxFza9N5HDzQY0yHwy+bAqxdwoA8ioYK0VMOAnCVLEUE9G/PajblWaBaerFGk
         oONQ==
X-Forwarded-Encrypted: i=1; AKwUvByB/REQA5czjBKzYZrkRwZ4dOiOLI569xaaMa47P2hHdA/HgvZ+TlUU9TMnzY2a7dd3say7ykXjyw==@kvack.org
X-Gm-Message-State: AFuF++m/8avOTFafb1czHiRpghmeWIPadneyq1H2RNuNkhoQg+aWWu7u
	gmdkPwhTTk0oaqhLdhBC6LSMZUHe+jywJvgtJB9iIwIWy2u9/2d9fkldlioB+FH5n9E=
X-Gm-Gg: AYBFou1J1xlqc3ENSjCJMRz+CIFDpDRjA9lqGQaJo/xGpWXRvhbZIv2xeewgS0yqfXl
	iMHXwpgsoo0tGTnmPJ5Tdq5d4W5/3e3HT0AZdP5RUcP8uBi7iTTRqR/bhXoPYdDNUGAFX9qTQ5I
	X1XhaFuUEImmTcBKrmANyiL4h47hC1ljMUEQHTNz9P53Nhk14SQc0f/y77J2agdpm3kJTUf+XlB
	trAx6evHMPpvaOwI9+5p0lt6vZ5GRNb+WTI8+cUcKB1+Wij7O82D9Gq8kyd3Au8uOaD9cHI9hGM
	bfhyv2h4/XJ+pADAO47H+G/jRqAyTzVJ9DoFQAtpXa8JlfoSB+RrGpYCgsyS0YmMmtD4sRE2i4L
	IOz97NsIwJC5QyYLdCnKItyNIwdhfujq0jD4ngF9GRCDGAUs8ULAe77+JKaKkuKTf1yjaAvu38e
	5INoIqNQKOoXLfC7gfPk+b2M+4bkhgcYxsBHNIoTnhdM19oSVMp67SUTrF2QOiIDPu5SfYQQ==
X-Received: by 2002:a05:6214:2386:b0:910:42f4:f92f with SMTP id 6a1803df08f44-91042f4fc5emr392109786d6.13.1788965536863;
        Wed, 09 Sep 2026 07:52:16 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406b0f51sm145078036d6.42.2026.09.09.07.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 07:52:16 -0700 (PDT)
Date: Wed, 9 Sep 2026 10:52:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] mm: zswap: avoid unnecessary xarray lookup in
 zswap_store()
Message-ID: <aqFynNC4wJnoTnjj@cmpxchg.org>
References: <20260909123548.296955-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909123548.296955-1-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D05B2140010
X-Stat-Signature: jciuk5e6nxubm6j6d1eiistat6668oqa
X-HE-Tag: 1788965542-226684
X-HE-Meta: U2FsdGVkX1/2EOWV8twRFQAFhMVmqrYn8OK5C0faOedAcjRjNFwGCqzIuILv0o+DugVjLpMTgRX67fD7Mvh1Boagqo7aRxXXOsBrLsk4/S5MoHBHHmnmwU9NbFRXpWhP90Kt00/g0ZiAveDMGCDvkET7hUpv7XdRBGkkBS7ZtYkarFUqWeSJeweh6CJlAW2PZHMss+U6C6RKKdTzemQ8Qr27FNWOaJy4avKb/ORCGQ1lVR/LbMO/uoW6BaB3GwSASBTK+bf7tOCz9uzyCTvvbL0IT59yJMSp/k/YRpzeQHBmvwzzMfXkTGsy04Gvpmbi2R5UKnmpw3+wl4e341149mPhlenYE5cgnsuz/Z3+WeFL1brRMUdR/ym44rmBwg3ompxqVqJR62gxVJJAcs6Ey2rG9IuIy1vuQkU8AyEncgO/hMy8gOfOjDuSuWm7JRLMvCG0+XapUMreY9Zwhe7MWHexISA7nXLyUH/ZRIvrCvkYMyQyGLPNRrlDOCDkyY3Uh/ORKbyViwrGAcyQoXkptcG3kxMrmrc0wNM/ReNUbPR6vjku6lCmGDDWRSOwraz+y8kzm2bLBXeMZ/ilxRPJRkZw5VvSRdU7M4fLpaCNYyXDJzo0moQOIFJML7L9s7+UOJw5EU50o7uVPgPjWF9JkKZrQmSbpBv0hPowjwrCgHq/Ltr4Ju/l1uzZjtHxfgR7HnZ4+41r3oRfaHZNRsaxiCv5Lh4yeUAHxpbSpnkfr0LVkCGATvUw1VUYZx8M9SU2dLHUzeZGinlapNVrNvqxnkQnRlbaJpgf63X6S9cmXvmnjy1qgCMvMyYAewB2+9SqWGJ0vCaHRUaXVxk1Zcmu5iSKKSmECbqrFLOahoTXu+cZ9H7h2NED0LvMrWoRocdGxclYDaoHKwCd5TSr2QCTnf/Xog2Cp/r/jlzcjon8kFRxiMVDA1yL0dMWad+cP1I6SljFs3Yc39ty9SvUKZN
 awlFMKE5
 QjU7Yfn0dHFbmaXupVSuG4d9uqyxavdDON9IlT1VJYZi6XWDjNV/A/CqUwWvEBllt8aXSdxIae4uf2NTf1+9IHGe9BzxTw28kdN0bRR/KyxMKgCHy+iKEEHFtWUvMg6bMHBA4yJuQIa0CfXgjIq00g++NTqPXPtavhwvwwHfAtq9YYygXHkZ/Ukp+9hSbiVPbwEfzvSAwQiTh1fVUOvghDN+JuU9Xe7W3LpnsmeAxT6CnnJL7XlgkI2B0DXO65AaODeNbrBj4XrrAQGWsh5EFFSdTOAQJPrGw78aMlC85IbgAFs5VXCcyaD9swgtOzxU5OROcjdFEAFtgY+dJhmqy7D4rRS5TxvqkRa3CKsKMIlcYrf9FiAp7bqjQ34ZRRN2miFQkcPOKINqzeX95MIQV8mhjGddOkZGJCJfZmj22PwpiqfKY+SvonAB/TzaTm5yeIs5hRmVSiyi6p/KC28cPkpD2QX4eeN7A01JrIcPsKwCkGMEZhTv/gRA1Z03D353T3nZWd6C5KHY1AWsZExY2pIUrVzCXOgPINkIUDL2ohQ19x3Whyis4bEYiNN2OAMBHhT3ja/Jusi+9DuGjLhLLGcDNTZ5NpuPx2QvYQIgAdH2r686Tbd2DNsJgew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 08:35:47PM +0800, Kefeng Wang wrote:
> zswap_store() falls through to check_old and walks the swap xarray
> even when zswap is disabled. Add a zswap_never_enabled() early return
> matching zswap_load(), and reuse zswap_invalidate() whose xa_empty()
> check skips empty per-area trees to avoid unnecessary xarry lockup.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

These are really two separate changes. Can you please split them out?

> ---
>  mm/zswap.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0d8bd72193..fc6c5e0db5e4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1488,6 +1488,9 @@ bool zswap_store(struct folio *folio)
>  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
>  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>  
> +	if (zswap_never_enabled())
> +		return false;

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

> @@ -1545,15 +1548,10 @@ bool zswap_store(struct folio *folio)
>  	if (!ret) {
>  		unsigned type = swp_type(swp);
>  		pgoff_t offset = swp_offset(swp);
> -		struct zswap_entry *entry;
> -		struct xarray *tree;
> -
> -		for (index = 0; index < nr_pages; ++index) {
> -			tree = swap_zswap_tree(swp_entry(type, offset + index));
> -			entry = xa_erase(tree, offset + index);
> -			if (entry)
> -				zswap_entry_free(entry);
> -		}
> +
> +		for (index = 0; index < nr_pages; ++index)
> +			zswap_invalidate(swp_entry(type, offset + index));

That dance through a swp_entry_t was already kind of awful. This would
be a good opportunity to refactor things to avoid that:

diff --git a/mm/zswap.c b/mm/zswap.c
index e6ec3295bdb0..df18fdaae703 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -228,10 +228,15 @@ static bool zswap_has_pool;
 /* One swap address space for each 64M swap space */
 #define ZSWAP_ADDRESS_SPACE_SHIFT 14
 #define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
+
+static inline struct xarray *zswap_tree(int type, pgoff_t offset)
+{
+	return &zswap_trees[type][offset >> ZSWAP_ADDRESS_SPACE_SHIFT];
+}
+
 static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 {
-	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> ZSWAP_ADDRESS_SPACE_SHIFT];
+	return zswap_tree(swp_type(swp), swp_offset(swp));
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -729,6 +734,19 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	atomic_long_dec(&zswap_stored_pages);
 }
 
+static void __zswap_invalidate(int type, pgoff_t offset)
+{
+	struct xarray *tree = zswap_tree(type, offset);
+	struct zswap_entry *entry;
+
+	if (xa_empty(tree))
+		return;
+
+	entry = xa_erase(tree, offset);
+	if (entry)
+		zswap_entry_free(entry);
+}
+
 /*********************************
 * compressed storage functions
 **********************************/
@@ -1554,12 +1572,8 @@ bool zswap_store(struct folio *folio)
 		struct zswap_entry *entry;
 		struct xarray *tree;
 
-		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
-			if (entry)
-				zswap_entry_free(entry);
-		}
+		for (index = 0; index < nr_pages; ++index)
+			__zswap_invalidate(type, offset + index);
 	}
 
 	return ret;
@@ -1647,16 +1661,7 @@ int zswap_load(struct folio *folio)
 
 void zswap_invalidate(swp_entry_t swp)
 {
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
-	struct zswap_entry *entry;
-
-	if (xa_empty(tree))
-		return;
-
-	entry = xa_erase(tree, offset);
-	if (entry)
-		zswap_entry_free(entry);
+	__zswap_invalidate(swp_type(swp), swp_offset(swp));
 }
 
 int zswap_swapon(int type, unsigned long nr_pages)

