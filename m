Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DC4606D807
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dEOUANCp
Received: by kanga.kvack.org (Postfix)
	id 70F3F6B05CE; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFE66B05CF; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587A56B05D0; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB106B05CF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96884804DC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:51 +0000 (UTC)
X-FDA: 85394334102.05.CF6BA85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6A5718000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dEOUANCp;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723149;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWEAyU+bxDF0UfL07Lt+/IXCJ1rL/BoLdkIrtSn8JJw=;
	b=YTbj9XlyYqY8Z6IcpA4xUWW1zfsxpz18MxKk+31ppTvkfuMe20JEnXcf63lmaGqbcClLft
	/+kBvHC3ppOiLAFAx+wposy6o/Dax/oXdBrRuB52npOWKc0RXUlqolWDZxH0Hykcj2mbrj
	vlxeXL2rsjwvCh93JCGuPsoHF5bnl1k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dEOUANCp;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723149;
	b=eBNJ7U8m9U9LsOrEcJk5vRDJHIC+AyRM0AGC2NuEc+CNhJCvRCgY+iRlhSXsZcNxYvDg1k
	l7w1veA0prYpAUfKCuIhij0tuk5RhIcnex/MrF+h7EpGLMeBdj+CBS4/m4vq4i82HBZK+A
	95EIqhJl/DbSXjotgCBx/ADbMakOWi4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B25EF438D8;
	Tue,  3 Nov 2026 16:25:48 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793723148;
	b=A47VhKvPv+92i15ss+obebZiPzC/U4XmLvxo+odb2CSeDT7OMr2k+jpvLliIFd79xLEd
	 IraeISKmfHQoVqF2bTnDszMwM0CIJy6fCjV8VcCrTdI6uiSPcA5vmW5m6w7Vcl8jyeyb5
	 xMlJDp6Cim/GUwzaAbgyK7R5NAdMnvwBMtSxl7ldYn02SaqdhBrJN1B9rTjY29qAXqw/u
	 0zebBC+gqimTAx1FNc8hJezD0fn/ALGr3jAVrI8NoVTTjrQscIySsQ4RTl/EXd7zIn6jz
	 DtFdyNxwr31hIB89E+XJicpJtMSZjv0X0DVB+H5v4V7pv9A05x6kjXDVPrAMaZwzstQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793723148;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=iWEAyU+bxDF0UfL07Lt+/IXCJ1rL/BoLdkIrtSn8JJw=;
	b=LWsgMKmW4Bw/npQDTYPO/Jy2ByfDngkW9NCwUyMpgBG+Mi57MBapYHQeTW6HSTrRo8ui
	 IdYThiK1UV1+sfpv+B0CDNS66GTJoKrnF8dbNBwVk8ur8GoO9Hum+CWsJId78jrAnTqc4
	 KKQ6Gsuy9+qvSox4T7DIBUaDGZjEWgSY64LAe8vE6QBK9rk6YG66HQ3t/gMlo8tUOPsI4
	 zAN/FIKtuiPkYrZlOSLL9I90GNnNqh2ZRi68INTz1CJNUEoIRHynLk5D6xhtJdWfb78BV
	 RCe5yOrY28mzSfXCkcwoomL0O6ZbayT4CQ+Sv2ZuhhBr4+cV+NXP62Om4wZ9Z91YkSg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C72761F0093A;
	Tue,  3 Nov 2026 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723148;
	bh=iWEAyU+bxDF0UfL07Lt+/IXCJ1rL/BoLdkIrtSn8JJw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dEOUANCp10CongROoPeFCT2A2PINRg5ELoefZ6e5//bCriUnDXwIhW/I780jlRe5R
	 flXI5z9GTZSqgmGSlD1eWHWq9grZvMEQ5JexBsOk6f0fTA4fksGEW6TUnE9FcQPYUY
	 yWq25wIn0FJQmWULwPwPokdjyAfcSJy4QkrXOobr8c/SDU7exS8AzHR08rlOZeR/7G
	 0OAf+DCIZbTEgI/91KsHiGnxyYxP363YkXxogWCv07ERPGpO7JkNb7ggoeIfny/6Bj
	 mw7EhNO6LBgHHUi14G7ZZgD5HmWWuwetNBvFtPD1uAdKwKhEidCig9sJ6Vjf2b8Tzc
	 iu5WjIFqAbetA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4327546A26;
	Tue,  3 Nov 2026 16:25:47 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 04 Nov 2026 00:25:46 +0800
Subject: [PATCH v4 2/3] mm, swap: give hibernation swap slots their own
 swap table entry type
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-swap-hibernation-slots-v4-2-0ba9393609e1@tencent.com>
References: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com>
In-Reply-To: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Jianyue Wu <wujianyue000@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793723146; l=5422;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=D1R/jLGgi6pquHPzj147tbH7cVtRgUWaR7W1/WKarbM=;
 b=t2IliMLVx2WrDHtLnP1+KhYaf7Fd2wx52llfctOfsBYngOFhThc7P/EgeSo3isI+f2oXQaJz0
 EexZhSYQCudAbyicaWr5OnefJxKjhDF/Cu3MJRLk6Thlcjafimnf4Jg
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: ro697fsqrsy7sx1x9jxoq6b5po7qbbwy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6A5718000D
X-HE-Tag: 1793723149-261391
X-HE-Meta: U2FsdGVkX1/kcfge30cGiQ1nCvT8fR1lBOmCNyYI25XkyrBPWVMN2LGTR5IfDDqt3wArGFX76zP8Tyg1R51vF37LHmO3bxc1FTt7W+TEUdEJ1+8yA9YUoJ3rFxhMR6gl/dNSmBhsMYB/SZvRSEJ13F2CgmkVG9HpANDoQ2le2+nEXR5A5t/6513sPgB6SC44AwdpkEBh2pog8+f8LGhUKHoS2Ue+koGW6PI1VKD7qAgMv0bB5M+GICqwXZ9uEj0nCOGrHp2M7/KemA5BdbDvYgwHPLHkg8ykfd/aHB2xu8UlavMbAmnEYHoypWNrkP29/KUSGmKIf1XpaVSoNBw7HANzQ+35+0s2+tq14xS2eq7HocUZmnHWVJg+8U8QGoiPVWsdwlPmczne/PCXe60bF0P7B96eqtsMpq0ZnRRjk/BuK/KdcTlN+IfsFmgyRFMbdT+XYh4Kl6kxg/De/Ux1ynYKTksirxEvHxdvZVHgKiwfFKGF6RUzoJhQFlKKYqgtxLGPXd36/UAmb6QHk2qwpUVwqe8FPRNg/wP0s5qRSwj7D/av43F12bEQHP8tDkit6w88XjQFaKCImp64K6YKho54badiu3kys8tB9Sb+fZ5/FIxe0UbnAhzVOUf95LTZ2YtGQW7qoq8ULgYxxhGnCsgleR0EqJHlgKW3RSx8kTbPJzM9n1ddHGsETaj8+tdVrL65HpI2z0EvRowJh9IEy35hM8wW1MA/cHdL8wMKkO0u+fKvPDvyYSTATzFQzPifr+h9EK38qs/vBRuggmbIpOPzu8Z04xbYAojGgCxtHfwepcYbUqeZwRUfC44t37BcIXITdIx5zBXd9rM5IwHQLYz40wSmcfjROdElALRzd4ZyPNXEts9Iq3/snYzKX5S3KbnsGVSX1lFmNQqAEZpgy34vKeM9UwdcIIUNTgRHSZxiS892TteVYxkK3ujkWB2su4TN/kTpiKLCrwf4pCx
 hSsALQHH
 jpSPBgr8nR9z9RGsMzqfqcivor/FtD3VUkYtHbaMOPVyDFo87qm1IGE8MY+Ek9Uq2eIxOj1kyIsDEMFUMafAiJbrlN4utbzQOYE/w5WDIiitZNjCYBGDNsO9vE/Sl6MPRGemzjZyGtQc9kk75t4XQrXR8qn0CATJwNJcZyQ5TWwVquRCvW57pjpy175a5L1cnztPZZszubLUl1IfvZusLYqlM7YVt5ET3fqU3dk4E9zt2FlUEyL8EJ+wVEBqacl3El46vWf1U53+bjyIbUAMecNp2KRJ0jfKriyOueXt4tpgY4xBCgh8T5zCJ9qgabZeb1T+TQD3TrxV+rkhzTF93B6Ppmx+QWvyE64sMyk4B0BUeOc5/+dUCQi61sRoBLYrdlTEaEanu5E2dBHHXuaEYVZzTBMV68irdTw1GZGX56RFCu/fli46S19ZqWOXxTcuwq+slgjD67xoQaobryKbdBeioXUoU+OEQ4wb+2YR5Kamu8S/nvVrnbJqdqOxeegw2tVAaKNWdUD0n+RQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Youngjun Park <youngjun.park@lge.com>

swap_alloc_hibernation_slot() stores a fake shadow in the slot it hands
out.  An anon slot swapped out with no workingset shadow looks exactly the
same, so nothing in mm can tell the two apart.

Give hibernation slots their own type.  Bit 4 and every bit above it are
set, except the count field, which stays 0.  Bits 0 to 3 are taken by the
shadow, PFN, pointer and bad marks, so bit 4 is the first free one.  The
type holds no data, so the value alone says what it is.

The entry has no swap count.  Hibernation only allocates and frees a slot,
so a count would never change.  swap_free_hibernation_slot() frees the slot
directly, there is no count to put first.

The slot is no longer a shadow, so the previous patch keeps it out of the
swap cache.  The count field stays 0 as well, so code that reads the count
without checking the type sees an unused slot instead of one at
SWP_TB_COUNT_MAX, and a wrong put is caught by the existing underflow
check.

Suggested-by: Kairui Song <kasong@tencent.com>
Link: https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
[kasong@tencent.com: renamed the layout entry to HIB and reworded its doc]
---
 mm/swap_table.h | 14 ++++++++++++++
 mm/swapfile.c   | 13 +++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..072625d60d54 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -30,6 +30,7 @@ struct swap_memcg_table {
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
  * Pointer:  |----------- Pointer ----------|100| - (Unused)
  * Bad:      |------------- 1 -------------|1000| - Bad slot
+ * HIB:      |    0     |------- 1 -------|10000| - Hibernation slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
  * and together they form the `SWP_TB_FLAGS_BITS` wide flags field.
@@ -54,6 +55,11 @@ struct swap_memcg_table {
  *   aligned pointers.
  *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
+ *
+ * - HIB: Swap slot is reserved by hibernation for the suspend image. It is a
+ *   special pin, like the swap cache pin: the allocator treats the non-NULL
+ *   entry as in use, but the slot is never duplicated and never enters the
+ *   swap cache. The count stays 0, so a stray put trips the underflow check.
  */
 
 /* NULL Entry, all 0 */
@@ -81,6 +87,9 @@ struct swap_memcg_table {
 /* Bad slot: ends with 0b1000 and rests of bits are all 1 */
 #define SWP_TB_BAD		((~0UL) << 3)
 
+/* Hibernation slot: ends with 0b10000, no count, rests of bits are all 1 */
+#define SWP_TB_HIB		(((~0UL) << 4) & ~SWP_TB_COUNT_MASK)
+
 /* Macro for shadow offset calculation */
 #define SWAP_COUNT_SHIFT	SWP_TB_FLAGS_BITS
 
@@ -166,6 +175,11 @@ static inline bool swp_tb_is_bad(unsigned long swp_tb)
 	return swp_tb == SWP_TB_BAD;
 }
 
+static inline bool swp_tb_is_hibernation(unsigned long swp_tb)
+{
+	return swp_tb == SWP_TB_HIB;
+}
+
 static inline bool swp_tb_is_countable(unsigned long swp_tb)
 {
 	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 189f04d8838f..c26243140bf2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -941,7 +941,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	 * upon folio unmap.
 	 *
 	 * Else, it's a exclusive order 0 allocation for hibernation.
-	 * The slot starts with count == 1 and never increases.
+	 * The slot carries no swap count and is freed by offset.
 	 */
 	if (likely(folio)) {
 		order = folio_order(folio);
@@ -953,8 +953,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 		order = 0;
 		nr_pages = 1;
 		swap_cluster_assert_empty(ci, ci_off, 1, false);
-		/* Fake shadow placeholder with no flag, hibernation does not use the zeromap */
-		__swap_table_set(ci, ci_off, __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
+		/* Exclusively owned by hibernation, must never enter the swap cache */
+		__swap_table_set(ci, ci_off, SWP_TB_HIB);
 	} else {
 		/* Allocation without folio is only possible with hibernation */
 		WARN_ON_ONCE(1);
@@ -1953,9 +1953,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		old_tb = __swap_table_get(ci, ci_off);
 		/*
 		 * Freeing is done after release of the last swap count
-		 * ref, or after swap cache is dropped
+		 * ref, or after swap cache is dropped. A hibernation slot
+		 * has no count and is freed directly by its owner.
 		 */
-		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
+		VM_WARN_ON(!swp_tb_is_hibernation(old_tb) &&
+			   (!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1));
 
 		/* Resetting the slot to NULL also clears the inline flags. */
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
@@ -2225,7 +2227,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 	pgoff_t offset = swp_offset(entry);
 
 	ci = swap_cluster_lock(si, offset);
-	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
 	/*
 	 * A slot with a folio in the swap cache is freed when the folio
 	 * leaves the cache, the same rule swap_put_entries_cluster() follows.

-- 
2.56.0



