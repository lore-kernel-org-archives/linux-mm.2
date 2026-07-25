Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870D2C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD9D6B008C; Sat, 25 Jul 2026 13:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F5B6B0092; Sat, 25 Jul 2026 13:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C4F6B0095; Sat, 25 Jul 2026 13:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79EAC6B008C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:21:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE98A1A039D
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:21:53 +0000 (UTC)
X-FDA: 85027966506.05.2457E4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 398BD80002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:21:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WtfXeI51;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785000112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmT/6roT1kwL/qDIR/q2nRmsuARqI7eTSUoDfPCwI3o=;
	b=inv54PQ79d3f+Yay1mOongufLlRTSjbHEgVnSGvEiYneiZi4hulwK2aqnkL22EeXTxMj3H
	AlfU3dN5Ts9pPvNbgDoAo/1zT8Z70jBZeF/JsdZsaejhY6EHHWgMuobWQKz5dehsBrOdcv
	eOIOR9icdtveKpR0ndnPvLZjowSozZ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785000112;
	b=Y9fTT2RbS5zzMFDQu37SGNMZFK0IDgqCg9R6mp50Knruh9G9mho+bzH+keWa8tk3C2sNMW
	0aa+Yki0Rj9+jPNckR24fhJ8xB/iWx3NruUx9raPQmbTbhUUVfI8x6Qre5dGI8izQy8AyZ
	jRNMxclYIcuzDhe/cnc6adfNO483l9s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WtfXeI51;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02EAB44E9D;
	Sat, 25 Jul 2026 17:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E091F00A3D;
	Sat, 25 Jul 2026 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785000110;
	bh=PmT/6roT1kwL/qDIR/q2nRmsuARqI7eTSUoDfPCwI3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WtfXeI51Twzy/ijI0jUUiqEZozeRV7tA5iCxHFkqBzN7dAoX5hy75KdvdyRMVLjMp
	 1tRmTt5JQkE4yd0B1hRfXtu7G3ELBPiEYK++pg+J2jS2svYFm0iRkQIvsZb/Bclr2F
	 uWwWzWHhyK5rLg/6Ig/i42xxkk9npaBi21xhjhJtWQ/hR+bgLymnvaf6UitdSuo9f2
	 Av++jXhQ9pJpmNfZYF5PPiSuVihELl/neHf89YO8bl5jBShIXgXiKy1Z29FJlV9j62
	 RTUAuGkS98sdJhEXVOoSfoqoCYoYrUs7ocwd3ht0mwxn/y7ofHb91yqPcAG6t8ybqP
	 sWK+PwfRDzTIw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/21] kho: make radix max key width more obvious
Date: Sat, 25 Jul 2026 19:21:02 +0200
Message-ID: <20260725172133.4018491-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
In-Reply-To: <20260725172133.4018491-1-pratyush@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 398BD80002
X-Stat-Signature: si8re5z8dy7iugzp8qdjqbuzb6qeimco
X-Rspam-User: 
X-HE-Tag: 1785000112-929161
X-HE-Meta: U2FsdGVkX19nLYSK/6ROIbZP+2VhhvHK7OGDDRC5k9pSukOtUQO/1Z0mo0TBk+l6DLDQ7lz+tS2Vp031dceQHLz+96eJrJcU64a31rfzlrJfUCXQW++h4vVOhcg9G6irMuaBGhnzFvLCU4+q2G+G8aZmT6qS7rexRPcjvPzropdbpGTvkBe6wTI4xWgvxpPTTZSjJl3jEwfrx2hSudLHESZbTcWqLdSuflvsms03m8CzXzFxbV+NkjpYnwBixVEONXf+cNpt0h3qkZHzgEg/6KDNBdusTO+JaEy41MGRhNFVHfPPRj0AnEaVHZeHPLQyrE2BnC/50Tp6q/QlAmXXMRYgQAjzp0bx/dys0CR8lqv8B5hCHAU61AoRt/KLDB0wd3Z9kIibkmhGzrZP2dFSAXwL8YICw2/nB6CkqIjWmR/7hG9jyiE6HtQj40Ms2vl08xyt4BUSxEHM/d1ybNrN/hZHPjTqsO44mCWzjJ6z0k1RmE+WfBCLcrmDHKgOf8Btmzc4utd6RbJOqIQhqr2odQcDgXhyqbh707q4vf9bcvFY2lyQqWVmHybuQ/Lq8Dz7sR5nJIvMtoQln3ttqWxeBkmp96gbpNnrCPixjJHYA3ZwZ+CLSSKqizxgWCUerfXT/W5phljK7INlhNQVCgI5MIOkw9ckkarTmt1P4fvJSbnZzrKveMv652rx2s3bTpnpfgK8rmEJQXaIPvEZMtE8CWwuFhIad8czeVn/YyLLXsFVa/QIRef5IASjEwVH216Q0kN4HPCwTr8MUjO7+6QsOoWX/hX1FZxGuhv204xndQRLG9xJ2jecryiXQQlEVr9aQQWfy84h+WGgHJkBki+FswEYiZLZnu2PaACOvXJOOdOl/3TKOKUevftJhkNpE20AJtNrDBWoSr4SRk4yN+YzPh/oYAOmZcqSzRNWsFlYGVLo5pu7CYFdmknjGZJPvAALazEHpeH289OnXYH61G5
 IXJ3fhdr
 2FPVaXAcMGV4+snda5KtDKnbv7yLVRX66EbwicmtSGpubJ9PbbYoWfy04UQd08OKIe/bcSkNGwQ08WaWropeR8+nFC5tLFhe/u1yhQZdjHytw8fOiDf3g2Sq6Xo0CHYAhQ8XccHlGG7IcRpmJ9nyY7bv6Db1M8p6CwjPW7phCpveqjBZAtG1kc1iV5OWB1vocsW3gPZTrSOeUaJbGwKpo5Ua6x9IuRoxMVNYoesS3K76lIGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO radix tree constants are somewhat hard to understand. The tree
depth essentially comes from the max key width. The max key width comes
from the need to store a 52-bit PFN plus one more bit for the order.

All this is very obscure with the corrent code. The PFN width is defined
as KHO_ORDER_0_LOG2, which makes very little sense to a new reader not
already familiar with what the value means. Then the fact that an extra
bit is needed is hidden in the KHO_TREE_MAX_DEPTH calculation.

Simplify this by removing KHO_ORDER_0_LOG2 and replace it with
KHO_RADIX_KEY_WIDTH. Update the comment to explain why this value is
used. This moves the +1 from KHO_TREE_MAX_DEPTH to KHO_RADIX_KEY_WIDTH,
making things clearer.

Update kho_{encode,decode}_radix_key() to not use KHO_ORDER_0_LOG2.
Instead, refactor the code and comments to make it clearer how the
encoding and decoding is done.

In kho_encode_radix_key(), add a new variable for the shift for physical
address. Use that in calculating where the order bit goes and in
calculating the shifted PFN. Update comments to make this clearer.

In kho_radix_decode_key(), turn order_bit to 0-indexed to simplify the
eventual calculation for order. Touch up comments to make the
computation clearer.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho/abi/kexec_handover.h |  9 +++------
 kernel/liveupdate/kexec_handover.c     | 19 +++++++++++--------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 5e2eb8519bda..2f4fb9c63942 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -257,11 +257,8 @@ struct kho_vmalloc {
  * memory. These constants govern the indexing, sizing, and depth of the tree.
  */
 enum kho_radix_consts {
-	/*
-	 * The bit position of the order bit (and also the length of the
-	 * shifted physical address) for an order-0 page.
-	 */
-	KHO_ORDER_0_LOG2 = 64 - PAGE_SHIFT,
+	/* Need to store the PFN, plus one bit for order. */
+	KHO_RADIX_KEY_WIDTH = 64 - PAGE_SHIFT + 1,
 
 	/* Size of the table in kho_radix_node, in log2 */
 	KHO_TABLE_SIZE_LOG2 = const_ilog2(PAGE_SIZE / sizeof(phys_addr_t)),
@@ -274,7 +271,7 @@ enum kho_radix_consts {
 	 * and 1 bitmap level.
 	 */
 	KHO_TREE_MAX_DEPTH =
-		DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2 + 1,
+		DIV_ROUND_UP(KHO_RADIX_KEY_WIDTH - KHO_BITMAP_SIZE_LOG2,
 			     KHO_TABLE_SIZE_LOG2) + 1,
 };
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7349cc82f6dc..ea24f23ce292 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -97,10 +97,12 @@ static struct kho_out kho_out = {
  */
 static unsigned long kho_encode_radix_key(phys_addr_t phys, unsigned int order)
 {
-	/* Order bits part */
-	unsigned long h = 1UL << (KHO_ORDER_0_LOG2 - order);
-	/* Shifted physical address part */
-	unsigned long l = phys >> (PAGE_SHIFT + order);
+	/* The physical address is encoded by shifting the PFN by its order. */
+	unsigned long shift = PAGE_SHIFT + order;
+	/* Order bit goes right before the shifted PFN. */
+	unsigned long h = 1UL << (64 - shift);
+	/* Shifted PFN. */
+	unsigned long l = phys >> shift;
 
 	return h | l;
 }
@@ -118,12 +120,13 @@ static unsigned long kho_encode_radix_key(phys_addr_t phys, unsigned int order)
  */
 static phys_addr_t kho_decode_radix_key(unsigned long key, unsigned int *order)
 {
-	unsigned int order_bit = fls64(key);
+	/* fls64() indexes starting from 1. */
+	unsigned int order_bit = fls64(key) - 1;
 	phys_addr_t phys;
 
-	/* order_bit is numbered starting at 1 from fls64 */
-	*order = KHO_ORDER_0_LOG2 - order_bit + 1;
-	/* The order is discarded by the shift */
+	/* order bit goes right before the shifted PFN. */
+	*order = 64 - (PAGE_SHIFT + order_bit);
+	/* The order bit is discarded by the shift */
 	phys = key << (PAGE_SHIFT + *order);
 
 	return phys;
-- 
2.55.0.229.g6434b31f56-goog


