Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC9CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884B96B009E; Tue,  7 Jul 2026 04:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7146B00A4; Tue,  7 Jul 2026 04:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D68A6B00A6; Tue,  7 Jul 2026 04:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43FFC6B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:26:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B323E120381
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:26:42 +0000 (UTC)
X-FDA: 84961299444.09.2EFFFC2
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9297AC0007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:26:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zwj3pO6E;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9ihXWGN4Yr26k3bShB4RRwMn22NraC0vuJJuiUB3t4=;
	b=FPTEBU/UGaHLic476vubpBh/DS0/g8L3+iIGO+RE1EjCu0T9q+EUd8IDW4lM3No1kZJMtd
	/zXU6mdx05lSxiQ8WqAI76LgmKVJAOsAZ4KYS08aAgfFq9q7+oWioS3VFWUdm5X25vcrOb
	eWEs7bmhV5upzel6AYSNRzC6mXCY0pc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zwj3pO6E;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412800;
	b=6wnzmQBymH/Yqg11+2bU9ZvfuZyz1B3lqVnEssvs2XtADYxl5dfr6QRnEjnugmXc8WtiUl
	lh3D+jW3OxyjZmpp5OqhbOUmNwP5paszQgyaB4rwg/l7+wMu5YTerCvWXWcFcycciQsO6Q
	gvQX2pmOcRjsS45ARSao8UABUjtEic4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d9ihXWGN4Yr26k3bShB4RRwMn22NraC0vuJJuiUB3t4=;
	b=Zwj3pO6ERe7pxf8BJHHpSLN7EX17lLaBwNvIm5wPMvZOx48TG1itaDT9VgsUm7xX0lGIBv
	X7nKTXi6MeOMzektSfFsFZwnT30UGhscKw5W6qHu9sdyWml3Z2VmXfsYjLxeG6153VBl3n
	ktyO7czbd0T8RNnVtC4DjcAHZ7afvic=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 02/10] mm/swap_table: add Redirect entry encoding for ghost swap backend switching
Date: Tue,  7 Jul 2026 16:26:04 +0800
Message-ID: <20260707082614.95030-3-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9297AC0007
X-Stat-Signature: 57nmbptrskkhjwsui95ozd7ttiq8mrn3
X-HE-Tag: 1783412800-153060
X-HE-Meta: U2FsdGVkX1+blj6hsrUzagARQaKpcI17VToKaZe+oIv4aNUty7RAjiR/NBQkSxkmqYUIDorXi7cVV0by4e0fyXlhu87Cl6AbWtE9KgvaRB9vatt7hQrHPLYPgwQhcM0/1LC/kDA9GjiGB0qO/h5PLgtBeW9CxN/YXX0Nj8oz3gR0XYzcmU8uQAcUiuXMC91Swy9oZNQ+q1S0+O+6qd4XIlOWpmFWwr/TyYuY0rmAMtVMxFWVeJZH5nUxJnvXAwFQdDR7+UuW2I3k+FR7mmcbf22rzNQr/d/AoPQ5R8RaPC0sIotasSW6L4iyMHSDvQn+KRppZVmoO0rLDp3q4gygLOWLoAjus1KvPvZiU845a7Wbjt55UykoxhHIpo0+CLCGGkcDaZVv2yenxJRLmBodPyrdwDzuBlYemr62kUaOEUQjUGwEqRnhH6EFi194zoltdWCheag9+oqulQ0gfSqoBtxeeZxwNuDakAi6pLth/JiBPxyO2G+qSNWq50zK3wV72EZTZbouBopYr85KqZNm5Ip3TnC4HIJDvyB/C+1WkVFdx8Us+XnbhsPCZLQeTlUZvEUAKVt/KDDxih8FS3hFetdTyY1EsAJNcnTQF/F38jZ6LOOTxgE6ZpCavPCqfsAntG8VvDO2GiElg3U8OtNUg0nOLFA00rE7InFaKt5ZsQCU3Pad69FdBXJLjqKxxVbnmXfSpgvzWsL7OAFvxa1NCK2In8pfi2KU7s/IAFZkRzkLLLFFYKZAd12oo4F5UAStJRiJGHzY9G7ACwdAqTEF0casP4wFMelMxuPZkfzvvUTtOCKT2bWMWsw++mfb1vPYoWfGgrjVSWtKVEd5drQGVzaM/9Z+LxrkEPY63BYiZr4UL8NjMMAqkzFjfRjWG/I1RIWYbmwIwr30T8F8ffkmhztkfzdmhd08zbTZjr3Gx03MJIMLzOHpijCUgeAn1ad4YAxaCN4xhtrW5RiBl7B
 oDkvaMSR
 EwmiaBGL7dpYH1EhaBebHdsU2BsmtOzIh0h5UnLXPDqX3cchlkgarGdMTQ1P0LPmZ5wWC/mwvvAzXdaBpYOlRhrqQOsTWwuTOGDvzt4uKDVlA7FGkjT8rNpOZ4eZWNRjuvooUOfIc+kMiL1lWdVxDQtAa71zqBgvkA5RV6C+W/A4oZrefsr8ASL5BOxXarXnMI4dmt5Kk/PbYLKbZAL99F4/vcVAU58NAT7AI9hrlgKDeYm5VkFRDznqUtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce SWP_TB_REDIRECT_MARK (0b101) as a new swap table entry type
that stores a physical swp_entry_t directly.  This allows a ghost
swap slot to redirect to a physical swap slot after zswap writeback.

The swp_entry_t has its low 12 bits clear (page-aligned offset), so
the 3-bit mark is ORed directly into the value without shifting and
without losing any type or offset bits.

Add inline helpers:
- swp_tb_is_redirect():  type check
- swp_entry_to_redirect(): encode a swp_entry_t as a Redirect entry
- redirect_to_swp_entry(): decode a Redirect entry back to swp_entry_t

Update the swap table entry type documentation to include the new
Redirect type.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap_table.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 6318bf8aa76b..5a971152cf23 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -29,6 +29,7 @@ struct swap_memcg_table {
  * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
  * Pointer:  |----------- Pointer ----------|100| - Zswap compressed entry
+ * Redirect: |------- swp_entry_t.val ------|101| - Redirect to phys swap
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
@@ -55,6 +56,11 @@ struct swap_memcg_table {
  *   all upper bits. `0b100` is used as the marker because zswap_entry
  *   pointers are at least 8-byte aligned, leaving the lower three bits free.
  *
+ * - Redirect: Stores a physical swp_entry_t directly, ending with `0b101`.
+ *   Used by ghost swapfiles to redirect a virtual slot to a physical swap
+ *   slot after zswap writeback.  swp_entry_t has bits 0-11 clear (page-aligned
+ *   offset), so the 3-bit mark is ORed directly into the value without shifting.
+ *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */
 
@@ -83,6 +89,15 @@ struct swap_memcg_table {
 /* Pointer: zswap_entry pointer stored directly, ends with 0b100 */
 #define SWP_TB_POINTER_MARK	0b100UL
 
+/*
+ * Redirect: stores a physical swp_entry_t directly, ends with 0b101.
+ * Used by ghost swapfiles to redirect a virtual slot to a physical
+ * swap slot after writeback.  swp_entry_t has its low 12 bits clear
+ * (page-aligned offset), so we can OR the 3-bit mark directly into
+ * the entry value without shifting and without losing type bits.
+ */
+#define SWP_TB_REDIRECT_MARK	0b101UL
+
 /* Bad slot: ends with 0b1000 and rests of bits are all 1 */
 #define SWP_TB_BAD		((~0UL) << 3)
 
@@ -176,6 +191,11 @@ static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 	return (swp_tb & (BIT(3) - 1)) == SWP_TB_POINTER_MARK;
 }
 
+static inline bool swp_tb_is_redirect(unsigned long swp_tb)
+{
+	return (swp_tb & (BIT(3) - 1)) == SWP_TB_REDIRECT_MARK;
+}
+
 static inline bool swp_tb_is_countable(unsigned long swp_tb)
 {
 	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
@@ -215,6 +235,24 @@ static inline void *swp_tb_to_pointer(unsigned long swp_tb)
 	return (void *)(swp_tb & ~((unsigned long)(BIT(3) - 1)));
 }
 
+/*
+ * Redirect encoding: swp_entry_t is stored directly, with the 3-bit
+ * mark ORed into the low bits.  swp_entry_t.val has bits 0-11 clear
+ * (page-aligned offset), so no shifting is needed and no type bits
+ * are lost.
+ */
+static inline unsigned long swp_entry_to_redirect(swp_entry_t entry)
+{
+	VM_WARN_ON(entry.val & (BIT(3) - 1));
+	return entry.val | SWP_TB_REDIRECT_MARK;
+}
+
+static inline swp_entry_t redirect_to_swp_entry(unsigned long swp_tb)
+{
+	VM_WARN_ON(!swp_tb_is_redirect(swp_tb));
+	return (swp_entry_t){ .val = swp_tb & ~((unsigned long)(BIT(3) - 1)) };
+}
+
 static inline unsigned char __swp_tb_get_count(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
-- 
2.54.0


