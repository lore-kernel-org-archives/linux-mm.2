Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64CCBC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A73E6B0092; Sat,  1 Aug 2026 04:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730726B0093; Sat,  1 Aug 2026 04:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DED6B0095; Sat,  1 Aug 2026 04:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 470C66B0092
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7BCB8024A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:03 +0000 (UTC)
X-FDA: 85052075766.24.5B2AEC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EF8E5A0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQoIkJWY;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oW24OSgY+02kiGUyGuv6YRB0JlDE5wjv3dR4PPzE/Do=;
	b=74L9FSGIJN6gThbBbjDYK0LcM9ycHOoz2KoF4K34T7X3cl/ZXof0rd+a9Izli9mw7xbMGA
	fxY+lPzs4NSwSbzEH1zvau5xw0hxr1f0SZqBai9vLtka/bnf7quobqa6CHnwCXBsCmfjVa
	wf45YiLY9SKKiPqlmjt9RRPZNqz1D8o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQoIkJWY;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574142;
	b=Yl4+t2fnTmWXmjJN63AV2++L4pPQlp+TarrtEmJY1DJn8D3nmSe3+dnaCTT3GPPTXKhc/I
	2mYXpWT1hcVRYlZNG/dWhZ3YtFX/R/l8a5AjSMgSVk+HY7BTGIO9423aeP7F8XRmImyvX4
	AF4v60lyZkR62Ghm2sws5vuDoaV/A6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BABE45274;
	Sat,  1 Aug 2026 08:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46621F01559;
	Sat,  1 Aug 2026 08:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574136;
	bh=oW24OSgY+02kiGUyGuv6YRB0JlDE5wjv3dR4PPzE/Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQoIkJWYTAvsAQv8VrdnjyxabkPvfgPjzaOhUwz0mE1PbNvBwjjRZsQbEPz0skHqm
	 3IRj025y9mp+vNFteaFmVDoS7I29HLINzSlBq0wW1salKV5kCzKdWBGEyS3YVkHxC2
	 +jBSMCnuKJ+HHT5KdczqbXuyj/r4tqKUaqnCI7BLRgOHlbyCpWL0L1W8N5DM4V5Mj4
	 dN5NkKtFWB9UvdZ2ibw6+mZSUAQtubKXX443aPI4lXSBOchrJMnlYQPFoVgMs5JqAv
	 uQ+zukTE83aXZ6melPsHCXod95nNmTykOSkkMkY10a/mHHeMHDWzGfqfd5S+nJXSsu
	 FF4eDfQrH7yBw==
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
Subject: [PATCH v6 02/22] kho: make radix max key width more obvious
Date: Sat,  1 Aug 2026 10:48:11 +0200
Message-ID: <20260801084833.1897543-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF8E5A0003
X-Stat-Signature: fpjejsnuy34874dao4em53esfk77e4s7
X-HE-Tag: 1785574141-519846
X-HE-Meta: U2FsdGVkX19CIIoQPa/IfoY5ABwvpejvura6f9sEtc/YcpE7gy8KDL5gs4gfEbX4UcXBSd5tTm7KWTy2UGKTBVJK2sYVfuqqn8wwdGWw0LdwWgHrg/hrzJ4EUEis4R0aISimBVo9TPxyWgImaSz2mEbSjNrzAoG9ohTEnSyxhOIxdRh7GiXNX+ui8FBjKxQ8kPf+Ety4l3SlSzzDsI2hQ9BWekrzK9rJUKszt/BcCl1ZnzboyED/Ua+g7Q+quEJ7Vx1yKWUR4sRqx2b2pV6F6zR8QlnSzJJw9dl08TdmMQGi8WCe201GGww8qQR/eU17ooaWDFqWNUQZkQTrYdYyA/vASHTolsWtT6d+4Df89Yw9ba8o2LO9rXP7dyrpgcWtb7Gdt4TGnqxmrDc+8mmi/nysbG5UsJWd3U/vuTnqk+CS3Oj/XpSdUTQ4wEeI44uQEKxesGauXJSHvNIDoE1CIq8jMkqgMnxe4NiytDi7kbHuUOl1ha/HLQ60J8Pbnjy8frwPB/WGXUjOnUdLDil+qydEsATLsthZkGQC4KsVGmqMZj1KzAR81Z1lkM09Nx4sKoOSv01uoy/5vgsoMB8ADDVCnEr6ry7JCqqaSrR0bA+A4pYF/eSPHt517NMuxMb+eSDAvCdL+tHSPSFPAy1cMnSyylb+F0WtPK4CTdRsDPaWEQybsl55i2nqD/Q9af5+hyX9+x57wtwHxbaQCpsxwsNky83EHSIbgJWDLkJEA0rSrrU86qSULUWd+Ydb90YfLu65xV1sVMw9xRsK++OjfsLPI7HbPsIgdYhx812pu/Ur1FsuENy1hz96JERsSfdGGaYGNDELgm6Bg0BOVBQXcuC/1sYyaqE4m/jFgopf4bNm71pRdZF10ppF1jiv22pEp8najxGG6V6JcNuaPrR6t/RQOWb0bVqxrWxnTU7pRIBe+f5tlmu/05wXxbbjSQDQnonXCR8jCFxDkq3p7a4
 9TzGEYXB
 z1I+yz2zN2KP0fusu0vwVEOJQj05gC1mu3JvkF3A91ifoMNHD8ce7Bo4qi5zw1t8V52ekngx9nQ/5ID/G49gOOilTl0FCsPQ8AukVuqqTlZDPpWQxd1Dy4ngff+P0jqKH0I3IJLZZBV9tEPwMNFO0AHM3z/Sfg9PPWarQzxXCB7b14kyeyN2wyXmO1GBN/PAAcoJqG+X6pvCSOyk8A+Zh5jUFOkmpPkP0uekLL51lcobZbV8=
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
2.55.0.571.g244d577d93-goog


