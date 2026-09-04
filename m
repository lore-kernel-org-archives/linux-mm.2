Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC196C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 23:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C436B0088; Fri,  4 Sep 2026 19:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D3E6B008A; Fri,  4 Sep 2026 19:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FBBF6B008C; Fri,  4 Sep 2026 19:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6046B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:21:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B936140250
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:21:14 +0000 (UTC)
X-FDA: 85177652868.02.AB97611
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf14.hostedemail.com (Postfix) with ESMTP id 837DD100007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:21:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PF8UcNeZ;
	spf=pass (imf14.hostedemail.com: domain of 3Z1KbagcKCNQM54B8F46EE6B4.2ECB8DKN-CCAL02A.EH6@flex--wfelipe.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Z1KbagcKCNQM54B8F46EE6B4.2ECB8DKN-CCAL02A.EH6@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788564072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kJKXKrq7yq1xNiVeL0CLanUf8ioKHs425feCWZPQVgw=;
	b=7MLpGiJ+XvXpRMIBLirS3fhkdOM7oe6j24YBdPLxE3gXuAaWMBEE3vT+YI7y/srRBkMdN3
	0sj2fDk2KqnC6hyjYL1gEw2ALx3cCtFoU+tBrgAMZzpOkYZQCWXBJANJzEsrclxjfzKHWp
	FC7G/kQ4DiJOSD2NMSFd5yAZHBZvsi0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PF8UcNeZ;
	spf=pass (imf14.hostedemail.com: domain of 3Z1KbagcKCNQM54B8F46EE6B4.2ECB8DKN-CCAL02A.EH6@flex--wfelipe.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Z1KbagcKCNQM54B8F46EE6B4.2ECB8DKN-CCAL02A.EH6@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788564072;
	b=OM7uP3hgZ9umk99IEr1QCPihJuTQf3g5egM1cD3XTzOZ7lfaw1QDMQjkURKVYS3g1K2ETH
	y7fI4vifC/TgpaJ0ol9/yhSaRfIcpzoLSDLGTJ/j5BYzVV8MzJaSEESftBIHiRs0gbzP5x
	khO3fn+kXdK1Aj3TqOkPW1yUUO9Q1Ns=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbedb8673ceso1317458a12.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 16:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788564071; x=1789168871; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kJKXKrq7yq1xNiVeL0CLanUf8ioKHs425feCWZPQVgw=;
        b=PF8UcNeZSUm8NdM0TfvnaX07mkw7j4Bn/8ZXW7UYvjq+OntszCAOR41C0FIZAyVBgm
         HekDVu5H9dMBZBpHneeolTMp1zK9bGeJIrCkyEmofl9x9OoPreXvi3aK+xx95mifYmvG
         z2Faco7UCX1qtR6VDKMTX7uGVtSxSwto4GFgeBB79z3XjU8iV91N+y9tZ5ZfaTOmTSeO
         fLlKCPjdeWemZ6xLPbNuercBTuvXBpogFYMnLVyIjQ+nNViZa4zHnGljwMrxA4jqsP5Y
         6zHaMQqgIL7A8x9cMzQ0taMe5C8PoN5KdfvUFBvqai6FjZq5XdUtkRtYLg4XXNLASVmE
         lsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788564071; x=1789168871;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kJKXKrq7yq1xNiVeL0CLanUf8ioKHs425feCWZPQVgw=;
        b=df/jeMZ9D4zKzpU53KJ3G7aF8nhI40wFTukgDvF2eV/PlRMgWMf2m9rcpSAHv6SMA4
         kyFf81gJTF23hQOrIyOvSCB452duXp7DwyMM8hhYRNvD+qAGC3I/rRr5FK5VDZoq6wX9
         K2eY1XrCZ/kQwTzzvU/XnMOD+I45Iy5oDCZl51zA7wRMcO4awP7XwS2H2wmpf5xR/z0I
         mkQEo5w0jF6oNFJiRJJUKKHxYxpm6KjTJMgmkjOJInuPhVk71Tg3cdRcKcX4Ryh6U86O
         pqY2ESNhzJAVghd9isqiOgFmv4DSGk+zPKNN1T4ZR2d1L6SXYYJcEpko92D+PFYrI0nk
         pkUw==
X-Gm-Message-State: AFuF++lv07dvzawguISJgkMsVFbhqAr7yi4cnD7/+C5ljlewz2vLwnsU
	6/JgM6P333Cwv0b1KHlz6Rf1xJtfdiMEEUgrAfFQzLjm8VEgovAIQ91Cc60yPOFlHXthVmyCowf
	pMgv8qtAcpA==
X-Received: from pfux26.prod.google.com ([2002:a05:6a00:bda:b0:84e:1951:8efd])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8009:b0:852:3726:dfde
 with SMTP id d2e1a72fcca58-8616809429bmr12694250b3a.9.1788564071116; Fri, 04
 Sep 2026 16:21:11 -0700 (PDT)
Date: Fri,  4 Sep 2026 23:20:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904232108.3034333-1-wfelipe@google.com>
Subject: [PATCH] mm/zswap: convert zswap_store_page() and zswap_compress() to
 take a folio
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6watow5x8i6roth7cubxqzg6hmddrtfr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 837DD100007
X-Rspam-User: 
X-HE-Tag: 1788564072-675747
X-HE-Meta: U2FsdGVkX19L2B61uPQEnvH/6q3vFvb5XMUB1igzuOZwy1C4zUyXvKbzBD+3pL9JdzukjGlYpy5bGtol6eZlzXh0bYhFledCOj6JxjzcwHujR+EAwrXJhqbR7R3hMheAkY6nteZW26lixU5X4bTIygdDucHT+4phTh600ydgLdoTc63e/UoFXekBiH4D4SJISFbHTaQ/ReYtwefoCUhmo4F9lm6XF2r68Qbiv6X+npAP7X4/FioO8JDmPLa7/yLlg7ye+vmgVfeeREyokCH9KLo8+0hPnJq80H8tboxFuX7U9/wngIoUrbalSMQN7eo65aVHmpMi6XHGRPOYtVNjPkUgpP0i0X8nrFjAvCd3Swayk1GJUlPsEku2aCg4D6Z85ke/1kFrraFt9//BCXRLFVcb0fDiBwVcCVOMDAXJUd3W5mLs2sg3rpPPQw/GAPvRqLGn+SWYHXG10DTCsFNAV7wzgbz0ec4rrKflWhakprEZ7KSbfBbpVThLDV/HX/b++sobaWCRsLQJqJ2ZemqMotp7ALvd4foMR9hfoeRJW56SxXnUyEGjgitkrzH/o4mYsqGfVJ6kl6d/PT+zdXletNofKohtiOuA1iLmGgHvWXCc53CIpH+PBDCEWbEkSwDx9FP0iYNNxGs4gn5Z3gEDHj1tXZe6pIMOqOANhu5vlIo4a2FwbZXb584aa6hQ0edOMjh+v/kBxAPkHIVvkC2P8Pf0dR1vJSBdmB3QQxmNKslVpdhPZgvldce+wkXgObfo+f9c95v7Wxvug9a/rXiMrhjKVEsbrycvEGrPzN/e8RauG6mwozBTiszS+OqQhOUkZs4TvGcjjcrTJ/JhdQosDlIRBM2BtLHoXHX+3pAvD0KopNZLZ+0B5qUezsMXqkBgdVmFGKN8hZ5TutjPEjBMTjxCb89kld/i+Bn8L2Eg4Z6Cia+hhmqwGK0E2ZQg5fZT/miVnt+FPiTRC99G3+s
 AAo2NpFn
 18vEBT6fxNmYjy9igqI0/MHV+LieilP9Eq8teTute0/frl2d8X8v7hCNIUeNkKSeOnFFzoXOaZZo2fPksXLFOcCsYEPp+i/kVe5nxuQKsVQ+MVQ0u37KnIwwaMC7/C6bS3gvlIiFH9pf2AfoU+rzPrq3YcrG3OJ3W4OUSaDSiuIXnyTLmDCbQZ/820HNQTRMGzAuwfYUo1YarRxkHvAJnvVwfOqz0SPugCAghbP2aacqJxFnrjoOBAwGiJ7PbhlfHS80U/cVkwIrwYT9l9Q9aHL1Baw+m0pPGzBTFbt9TEyTn5lXnA0TzT1jqDMczr7wt7Uwwz6EbQKbEN26XGkuypWK9ohDxYE6YG6YcYFfp5DFscw+mDHcRegFdS8Hwegt2Rmg2brANKCKrJcH/CmSWarCyCUOADzwsSb/krFBmIdcuC7vtZTwAQYyylJofu+vaKMl7upPYUheWMAEKr9ogqyi9tOuS9SaDKwb44SaW3UfcMrNARWbhr/7PO8zFn5uo99vAPCbZhBQyGPshm/D+I7RE7aNIxeDQ4BPZcp+GHGNiR8W4z//jaUtfLjMyLVgEuYZwlphdomazkj45AOjTIJnbR3o7crSFxt4u0RLrVgSIbwDJJg8j9kog6hY2WwhqJJtT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, zswap_store() iterates through a folio and extracts individual
struct page pointers using folio_page() to pass into zswap_store_page()
and zswap_compress().

Pass the folio and the page index directly into these functions instead.
This eliminates the need to materialize struct page pointers inside the
zswap_store() loop and replaces legacy page-based accessors with their
folio equivalents:

- sg_set_page() -> sg_set_folio()
- kmap_local_page() -> kmap_local_folio()
- page_to_nid() -> folio_nid()
- page_swap_entry() -> calculated via folio->swap and index

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 mm/zswap.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..225308c195c7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -837,8 +837,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+static bool zswap_compress(struct folio *folio, long index,
+			   struct zswap_entry *entry, struct zswap_pool *pool)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -854,7 +854,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
+	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
 	sg_init_one(&output, dst, PAGE_SIZE);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
@@ -883,8 +883,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
 		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(
-					folio_memcg(page_folio(page)))) {
+		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
 			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
@@ -892,12 +891,12 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
-		dst = kmap_local_page(page);
+		dst = kmap_local_folio(folio, index * PAGE_SIZE);
 		mapped = true;
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
+	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
 	if (IS_ERR_VALUE(handle)) {
 		alloc_ret = PTR_ERR((void *)handle);
 		goto unlock;
@@ -1405,21 +1404,22 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct page *page,
+static bool zswap_store_page(struct folio *folio, long index,
 			     struct obj_cgroup *objcg,
 			     struct zswap_pool *pool)
 {
-	swp_entry_t page_swpentry = page_swap_entry(page);
+	swp_entry_t page_swpentry = swp_entry(swp_type(folio->swap),
+					      swp_offset(folio->swap) + index);
 	struct zswap_entry *entry, *old;
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
+	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		return false;
 	}
 
-	if (!zswap_compress(page, entry, pool))
+	if (!zswap_compress(folio, index, entry, pool))
 		goto compress_failed;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
@@ -1528,9 +1528,7 @@ bool zswap_store(struct folio *folio)
 	}
 
 	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
-
-		if (!zswap_store_page(page, objcg, pool))
+		if (!zswap_store_page(folio, index, objcg, pool))
 			goto put_pool;
 	}
 
-- 
2.55.0.979.g7e5102b832-goog


