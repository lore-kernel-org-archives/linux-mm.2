Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07695C5DF6D
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301BE6B03BC; Sat, 15 Aug 2026 02:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0236B07A4; Sat, 15 Aug 2026 02:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CCE76B07A1; Sat, 15 Aug 2026 02:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3DD6B075A
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:54:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEDE8A0319
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:54:26 +0000 (UTC)
X-FDA: 85102590132.18.10661B8
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id E711C180003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:54:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PeKV+lsp;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786776864;
	b=BcMLVy5Q+pYiYMRgAofMbapjHHg6PMezcUXppaipYBf4bWD8NE/mVjQIBnQ5Xxk7mk2DbB
	31qKqQhL9uF4YT4rucTYgwhD1VPKUL+cMS0P/z43hHinZwS8c3PqItMti11ZpYjUqrXJEU
	WAoxroYakDM5lNYuWVg8G8zyx0gOhWE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PeKV+lsp;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786776864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LB66jlKU4CiUMoYa9Xqd6V/xDZ5/WArrBjIBC1saW6k=;
	b=v4LU9TnQsb9ebHqIKe5FEUmiSCDhbc5Ay8RlqJVaMqPjalIvIjWunFlttcjazRIHy/Bg3N
	hG5G8vzjNElENZUCIQH+Bm6lzkym01/XNjcAZgQvhKmWhze18v4U16JBonaj8NfkI0WFA5
	BTbkgw5qnpkGFCcSGwKNEc58Q0bjN6Y=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38dcbade417so1859102a91.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786776864; x=1787381664; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LB66jlKU4CiUMoYa9Xqd6V/xDZ5/WArrBjIBC1saW6k=;
        b=PeKV+lsp3FqIOfPnQzG0po5drKPumbzw8BC8GslECEidAPuo6ZAotQA7xOpk/UjuDe
         OcdWXlFRXRjosVWi3HbL36reSSYGSAXGXFFUTgSo8fdyyRNm07bK1gOU6AMpmCfxtZgj
         WMbRRr4+ePWWZYGFdxQyORPdi2uS5khhXg5Ws+wkSnLggpORbGvLTppPrjbM18xCxQAG
         T8OmiBaicsDFCgTIzlHwVbC5d924+ft/0yJUwq16ez+tmT6gVLX91GOjTf7sGeeUQ4MR
         NsagxMtmHHHFt+j+Ak4FegPAxLcO/XcKUXoKI7z7qEGFpM4zk5NdLzCjYcQalW7uomk4
         G50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786776864; x=1787381664;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LB66jlKU4CiUMoYa9Xqd6V/xDZ5/WArrBjIBC1saW6k=;
        b=fN9M1DsrCsHYr8y2YhU8kbudIdmm950fZ7tx8Wbcp4AFnwE+kDVr4Sd4BxaorC4B18
         J3upeMMfvE2/unP4yN4gJEix3HfrM2XPkHsXpU5Ec/b12cgLsEELdGM7sWfeB5PuJOXg
         tFoxuzD2DNDqGk6c6R3Oy4eDdLJfMDwNAQaw1scHcuT58Bmuv56faYKXElBhT3w6he4l
         +Buu9HE86z5MZmUXjIaOPpm3N5jAjCvITHYu5LAWppvwaJcmEGeTLp6m96IEP8ioIHEp
         lg7MdLoxfYMVD1OjdQ+Yeo7FzauvacBPjFoiUFsETba3cY9d4Mf3AAdcqjdcdVzPt36L
         N63Q==
X-Forwarded-Encrypted: i=1; AHgh+RpWJsBm0yPsaVRmJ4fJYanQejeItUHlKU/KqikBTFoJnr227x1AIZ5FsMqSqMGBIHZBNm4SbKLP2A==@kvack.org
X-Gm-Message-State: AOJu0YznyCGPJfNIUw41EUqpDTbjGEmrHMVCksm67P5ncCBwRwyvH3i9
	nakfuwlayUqNTPZhshc4n3kLtKYBKwt2RzAhp1JsAxylCe/wska7M2fpXWFkDiRW
X-Gm-Gg: AR+sD10y+sQ97vPuJanq2WLnoyoZzOUrM1IZoUNU3goIgPgzx/RL33lh9vxI9UsVFSq
	vV2niyxbqTBtMhVPvA+zTKlX1Z4BJciP2vG/e+qXbBJCb6YB4D3Tb5mQQ/vuL1qd1UbqKFE6PFD
	ODnxII+yETeprLFKTbH00IpmbongZayV6oFLqnx8AX2joscJbf4uR+2qiW4SsNIGZv9NrMhyai+
	XiZgeCToKcvOlJHZy0iI3dGpEd/vBcHkyO+y1wlM0kxWoweXe4JeWraEPIR3MD/xhRKwRqwbw4p
	q5j5Y5+kLRTpmsNQFJQsXUL33Z9eVwA8DgQrVUxJ/+dkkUUldQ7rjjzUOfRJRJ2040YZvbl31y4
	tz5usxnMPfJ32PMDKjRcGYpmzPkqp74oS9UqoI+M+lIvs4lY0PT5wpTGLt9e5x2LcrSZ/x/bsH5
	CYskvgpFnq/oy6RRCAwVcKCjLRCMUC42IuJvO0fjt81Qf7fFlWxP5Ut1g6em9S29auo9ZgTZbXq
	KlFd0iWV0YrX3FNcxYftnIGdaafx/XxCaE4rNw=
X-Received: by 2002:a17:90b:4c8f:b0:38d:dfd1:7c1 with SMTP id 98e67ed59e1d1-3933b77fff8mr11003337a91.2.1786776863659;
        Fri, 14 Aug 2026 23:54:23 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394eb752fe2sm5691360a91.14.2026.08.14.23.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 23:54:23 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sat, 15 Aug 2026 14:54:09 +0800
Subject: [PATCH RFC v3 3/3] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260815-shrink_zswap_entry_0815_v2-v3-3-0171bd86a667@gmail.com>
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
In-Reply-To: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: E711C180003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xtsh1aof33dten6n41skf6inq1dj5pdb
X-HE-Tag: 1786776864-838937
X-HE-Meta: U2FsdGVkX19IoJXdvetT8u1MACORJFBqJQq8Td+JanSwab8HEqpI/gBSrZUBx8dZb4bRJ2j+hUxL9ANRYxXzzq6ew/sYmbKfFdxzCcd4+ZxKbEy3PJG0uIYxS6Yraza8s9qM/KSTuhQgWcBU/DEKrZd3YpLAfhxer7Io7DQu0zBu8VVTwjhAyNzzppahHYskmJBOqERQK4jB6AlP5xbjwtw++She/o9ObmVzipCMx2mcHIdJPuoHeXMIB19663KnL/XTrJkSI3aH3QnoPCnsBTIuB2wxkiIuGszfZJV044jabYrageYuQGxW7k7IS/DRle5hJFAcIYp2MsX+jg4P0jkPOpXtuaYqK01r0fLAzN7U8fBzAPdTtGSob38oRBCFYa9VDtH88KHwL8xkbhoHZp45vGDkQwh315gIhAiaIu2UYalrQEAhjXduZfLCijefck2ZOLiOZL/+R7DjJkluMguHdpSfN/qTfFWm9TrH6F4Bj4Vnn2VqOsCfIvzkPfAHwjsyY9vtJ6UGccK8puZY7uVHW9f8R7k7O5YVcCOYmVSqmx2ezxc48xnYhCkswI4MygR/B6OVsxqvzu6W0u8PxjRz7IXtr92Qj+hgwcMjQmay0qh7OfCATvopyUoYxOszEBW98reazOxCSxJwBVV6Gep3qoJEx1t8cOpeX8vvLt+ib5fjUZPeRIu5DbtPo1ccTjOTKJm1wWVmQ76JGmu7Dm2Qqry7JpBCMuEhN91jZi18KOKqcEPHTRLOA8DEiFixi/gbri1GEo4RFDAnTXl2NsP81vqgMpK+vs/pFVa4CAY+xxCaW1udP0W80WYTHDiggVxDO6AY6ecPD9GWVa0ookU075mP1uF/1wQTiJ1YHbSrXZNZHrow0zRZYgbgAtIDcW/GpafTsH3HJdvZSSENC4NkvriwXGtdKknoWRBs6nKyVT6nAFQIrHUap1HO6Y+ijmUFbo/jJmyaq0THL4g
 kjyy7off
 3rE67wDFb3GkvoXy8dagJddK4YCLGJtx/2xlxxzAVUfPQLVwkBOon6/z7Piucw4Kts4I/wJtFKmH1VMsjuJwERIFlNxiDIHfs714xuGKRUXbEKv5pRLfXDYPIB7mUuzvyZii2HiVXhXCVgWtVtmiiBsZ4uf8g8ujyhpBMcungkzl0/plvx2+ZNnIdAuuLiMZFBUsAAhzdVImagOThDABkglGoePkR0Ccu6kI/QQRX5opKqb/TFfaUli+rRomRUgZSSa4jbSZpRyoiUsAegw1DppwGkT9pGb8Im72KFZJr2zrxe/Df4+I9o7YzH+sDIe1DLJCCN7kobmd2hk2LDcBUWU53XU3lr3s5hR7GucH5vOc8nBLZggyFy/aNBEvSsl6v6Etx6OiUaa9xFaCOFcFjyGO9NPJjMgJSzDJqWAE91iGzbeDEQtIta8DmLsj/lfNlTqefW+XkOIsUQZXT49B6In4K3r0e+rt2IUpduzwBruUCIiYgHig58zPl6i71tsiMLQP06tk4z+9q9dw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct zswap_entry is allocated once per stored page, so any reduction in
its size is multiplied across every entry zswap holds.  It currently
embeds an 8-byte pool pointer, even though the live pools now sit in a
small fixed array indexed by a u8 slot number.

Replace the per-entry pool pointer with that u8 slot index and resolve it
through a small helper that indexes the pools array.  The entry holds a
reference to its pool, which keeps the pool alive and its slot occupied,
so the lookup is safe without any lock or RCU read-side section.

The u8 fits in the padding after the bool referenced field, shrinking the
entry from 56 to 48 bytes on x86_64.  This raises objs_per_slab from 73
to 85 and saves about 2MiB of metadata per 1GiB of data held in zswap.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 603fdc418041..3974fca40a4a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -213,7 +213,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
- * pool - the zswap_pool the entry's data is in
+ * pool_idx - slot of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
@@ -222,12 +222,24 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
-	struct zswap_pool *pool;
+	u8 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
 
+static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
+{
+	/*
+	 * The entry holds a reference to its pool, so the slot cannot be
+	 * cleared or reused while the entry is alive: the read is stable
+	 * without the pools lock or an RCU read-side section.  Non-zero
+	 * pool_idx (slot 0 is unused) also marks a live entry for lockdep.
+	 */
+	return rcu_dereference_protected(zswap_pools[entry->pool_idx],
+					 entry->pool_idx != 0);
+}
+
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
@@ -861,9 +873,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+
 	zswap_lru_del(entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
-	zswap_pool_put(entry->pool);
+	if (!WARN_ON_ONCE(!pool)) {
+		zs_free(pool->zs_pool, entry->handle);
+		zswap_pool_put(pool);
+	}
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
@@ -1020,12 +1036,15 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
-	struct zswap_pool *pool = entry->pool;
+	struct zswap_pool *pool = zswap_entry_pool(entry);
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
+	if (WARN_ON_ONCE(!pool))
+		return false;
+
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
@@ -1061,7 +1080,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name,
+						pool->tfm_name,
 						entry->length, dlen);
 	return false;
 }
@@ -1564,7 +1583,7 @@ static bool zswap_store_page(struct page *page,
 	 *    The publishing order matters to prevent writeback from seeing
 	 *    an incoherent entry.
 	 */
-	entry->pool = pool;
+	entry->pool_idx = pool->idx;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;

-- 
2.43.0


