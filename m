Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B881C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3402C6B00B4; Tue,  7 Jul 2026 03:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1326B00B5; Tue,  7 Jul 2026 03:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFEE6B00B6; Tue,  7 Jul 2026 03:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E44336B00B4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:32:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71CD71683F0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:32:39 +0000 (UTC)
X-FDA: 84961163238.29.4EB4A27
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 53ECEC0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:32:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IKnm4gSY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BvE+K5bdGTJ3dl6kLTj9wqReRw0pyGG48Az9faXHbw=;
	b=rZ/GdgXgzfH21lGVO9EIzF3SJMKnJpPdufQkpe57eqOr+umGgEMbeRhYPmdRxt5+RI1g7U
	+T1a2+W3UmfVAj30bB+T+e71db1zrg/v7XnrA/t8vSVa2yYhjqCRoC/BW7kFurOQ45xiSY
	WN+H8I7NEWE6PUY1fdsmtT6VPABYpps=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IKnm4gSY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409557;
	b=wC/n6249EBByyZeKj2PSQyLSXTk9HaXIQcJWKk6tD6k17ykw6YULlWR0GViQjfJ2CjnoHa
	utk0ukpH7kJnljC+espz9aygp/c/lnZ5D5yCfyn/vuk3mYkJPH8xap6QXv/lQ6Bf9bJQN3
	h/7U9Dtf1W8rlgqRiNADeyff6yrcxb8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783409556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1BvE+K5bdGTJ3dl6kLTj9wqReRw0pyGG48Az9faXHbw=;
	b=IKnm4gSYYpt8scKSqHBiAEHkRn6NJRwmHYqKzg3Y8Gf5h19r39u+p58gyxgm+rVMLgVxv+
	m5kAwpzsOiz3z3Zegz5t9Oat3T+VjriA+v89FlhJM4FWkJ+o5RninL5tYIeMccrrmG6VuZ
	BNqvp91Xpra0/1MKCBhVjeNpqZQUeD4=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 1/7] mm/swap_table: add Pointer type support for zswap entry storage
Date: Tue,  7 Jul 2026 15:31:58 +0800
Message-ID: <20260707073215.72183-2-baoquan.he@linux.dev>
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
References: <20260707073215.72183-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53ECEC0005
X-Stat-Signature: ys3bdeii18gwxgmnsp77ph5ybcdqukcx
X-Rspam-User: 
X-HE-Tag: 1783409557-399284
X-HE-Meta: U2FsdGVkX1+mkse3rKls1IteoCrDYPMj+eJE7dUYHSI2JiDxQb2FMldut6AdGFVaRDMj9Yfxvc0NEmHIotUBCTAKLlDqjZMc3OI3clGfQNcVB/GzYbjpi4YFAkZALkhutunaVxw7VEqOzZsVDOGeDoGfM34/qH2+8AqtpPcxyGrf5t9LIpRnHQL9ymv1WkMWDSsGwytMsGgi+iUNUwpgZm72hCULL/j5eg9baIBJY+XpNjD0ac9KyXSpVJzcLGcgcDAuYf6t7EbmUIJ1dylYumRwIirnVetZWGonf1eWvk6KsvSUuavHdjFipFiRcsIrmUir+A4ptC97zBnpfi5ScgrwPjVjneJPprSS57UhjOWLhZm+3bhW3e857P5d/VhgNBAD4sW/LxD7JnXy1RgIhkLGkCkNGvdB5qZ7e0Pr/mz7GiaIo0Oc9zIADPczElU5oqmymuYfwOxXDATpVX7iBRKBrWVLR26dEf7xfVfjK+NyKaA3WU5a95LfChv/9HZiOmO1ZTrHni8OCMButoU8+bdzZND8mQqzTZzhH5rDU1Thejg6Sq+km1ETS8Ruz8CfPeo2ERrhJMQ9qT3YWg9yPP4sHkP8BgZztypxeV5tZcYs4gF+gREOsqHyrTAGkbnCzYdZf3YsJb4IDoEP2QvfmVt6Z2MAN+MtGkQ4TIGB0p1/fufUfNweb2VjexFpE0qls3wYa1gQDE57R549etKX3yDKpSPvOPiO0WHmvPfak3PFfF12CxRKVmw7VkBdgvu3yuisLYMjGY9gqLDX8XL2DpVsVP9xaR3lMtNoh0y90gH2gbATSCDAIOYBYfjfA9FxMKV6wFFiJEf2uwpEIWO2pi7wIMGLqmbKx7WjKD+W/YKOeqSJzN2RGsM+zOsTdo/D0dcuAVVKAtPZqixBQ4TgTGuW2K9T83d7BjxD8bLxYGK6zrF7rch2LUMCcnw/tuDAgGsTeCwXzlXBQxyuEgw
 oTWE8Yby
 7zzRtDEUkNTJLp2ER/T3w7+SkHbPnwFEFGesxJQyXF68Sur1S2m9kVbfd0KMOeDM6Y+axaovcEyBUO2wVMxk9VT3G2lBMeizCB57aZ4vRPLoqWsioAC9jj755MJFl3ty/HbDnuVNtcDteVD4e26fwws58LTZue9mMRNOXJ9iton0wRZ8MfQ74uUFW+6QlPIh7OKnWIKQfN+ILwfoJdgKDnCb4/1EmkamGvpJygnsoWYDFduxLpCLZzPodjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the Pointer type infrastructure to swap table entries, enabling
direct storage of zswap_entry pointers in swap_table entries. The
0b100 marker in the low 3 bits distinguishes pointer entries from
NULL (0), Shadow (0b1), and PFN (0b10) entries.

Add helpers:
- SWP_TB_POINTER_MARK: the 0b100 marker constant
- swp_tb_is_pointer(): type check for Pointer entries
- pointer_to_swp_tb(): encode a pointer into a swap table entry
- swp_tb_to_pointer(): decode a swap table entry back to a pointer

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap_table.h | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..6318bf8aa76b 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -28,7 +28,7 @@ struct swap_memcg_table {
  * NULL:     |---------------- 0 ---------------| - Free slot
  * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
- * Pointer:  |----------- Pointer ----------|100| - (Unused)
+ * Pointer:  |----------- Pointer ----------|100| - Zswap compressed entry
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
@@ -49,9 +49,11 @@ struct swap_memcg_table {
  * - PFN: Swap slot is in use, and cached. Memcg info is recorded on the page
  *   struct.
  *
- * - Pointer: Unused yet. `0b100` is reserved for potential pointer usage
- *   because only the lower three bits can be used as a marker for 8 bytes
- *   aligned pointers.
+ * - Pointer: Stores a direct pointer to a zswap_entry when the swap slot's
+ *   compressed data resides in zswap. The swap count (if any) is stored in
+ *   the zswap_entry struct rather than inline, since the pointer occupies
+ *   all upper bits. `0b100` is used as the marker because zswap_entry
+ *   pointers are at least 8-byte aligned, leaving the lower three bits free.
  *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */
@@ -78,6 +80,9 @@ struct swap_memcg_table {
 /* The first flag is zero bit (SWAP_TABLE_HAS_ZEROFLAG) */
 #define SWP_TB_ZERO_FLAG	BIT(BITS_PER_LONG - SWP_TB_FLAGS_BITS)
 
+/* Pointer: zswap_entry pointer stored directly, ends with 0b100 */
+#define SWP_TB_POINTER_MARK	0b100UL
+
 /* Bad slot: ends with 0b1000 and rests of bits are all 1 */
 #define SWP_TB_BAD		((~0UL) << 3)
 
@@ -166,6 +171,11 @@ static inline bool swp_tb_is_bad(unsigned long swp_tb)
 	return swp_tb == SWP_TB_BAD;
 }
 
+static inline bool swp_tb_is_pointer(unsigned long swp_tb)
+{
+	return (swp_tb & (BIT(3) - 1)) == SWP_TB_POINTER_MARK;
+}
+
 static inline bool swp_tb_is_countable(unsigned long swp_tb)
 {
 	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
@@ -188,6 +198,23 @@ static inline void *swp_tb_to_shadow(unsigned long swp_tb)
 	return (void *)(swp_tb & ~SWP_TB_FLAGS_MASK);
 }
 
+static inline unsigned long pointer_to_swp_tb(void *ptr)
+{
+	unsigned long val = (unsigned long)ptr;
+
+	BUILD_BUG_ON(sizeof(unsigned long) != sizeof(void *));
+	/* Pointers are 8-byte aligned, low 3 bits must be clear */
+	VM_WARN_ON_ONCE(val & (BIT(3) - 1));
+	return val | SWP_TB_POINTER_MARK;
+}
+
+static inline void *swp_tb_to_pointer(unsigned long swp_tb)
+{
+	VM_WARN_ON(!swp_tb_is_pointer(swp_tb));
+	/* Clear the low 3-bit marker to recover the original pointer */
+	return (void *)(swp_tb & ~((unsigned long)(BIT(3) - 1)));
+}
+
 static inline unsigned char __swp_tb_get_count(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
-- 
2.54.0


