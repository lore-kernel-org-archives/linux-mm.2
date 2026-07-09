Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 669BBC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A096B008C; Thu,  9 Jul 2026 13:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1856B0092; Thu,  9 Jul 2026 13:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7756B0093; Thu,  9 Jul 2026 13:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 052876B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAA5B1A0248
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:39 +0000 (UTC)
X-FDA: 84969947958.05.BD0BDCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 414F120007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AjrtR2kE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+qAC8+pWCAwtA9QFanjjmN8UXpbT10T8+2PuoaEVOE=;
	b=mg0Nq5pzSvd+1gTGUqlvomLdPceB2W3HMXkt0OtBwb2qib0Kq/Mihq2EeGsHmQhlzg95YX
	lLrnMv3jpCFCFYRif/R7cHZRbT64eEO+gxkMk1APNL7wZMxcJ7Fb3SxspoPIxxfM6PvhX6
	sTKmKSOlUaV/zVE8aPyR+ZIKwaTvv20=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AjrtR2kE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618718;
	b=jiSS0uvA5dl883awGoTtbkGb8eL56L4PVyB4sONrFyXlXeBJMVsrApViPEkh2p/wF5V+Cw
	p6BRRNVvnnklz7RMpro6gpCBG01DFpgZroJHlMfOukapVDctYS+QhNfJRX93bkoT5qFB0x
	l21/ryd105gV+Xg/SAxKKNWnpIhExKY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C849161831;
	Thu,  9 Jul 2026 17:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6DF1F000E9;
	Thu,  9 Jul 2026 17:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618717;
	bh=n+qAC8+pWCAwtA9QFanjjmN8UXpbT10T8+2PuoaEVOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjrtR2kEG7ScPH0YTa21S14aCTavvagxpns2YPuJtlQr3BafqUdylg6Sk4gPQ25xq
	 MnP3JR+UVB7zLV91etQkiBEVgqok5MlxQQqYWhkMPs0trKm3qkCTq6TbHCkBRN0e9L
	 9bRx/uivF57NcfiCuz2UbRVrO0FgYtG9djsNJxH7G0gr/FcCc0SPxuAeFFz0bChbAz
	 0UibzXHjI3ol3jTdRrQdimsDN/qpzZKtZEsJ8cCTkKzwESMXs2afr+k7x21vCU5fLg
	 t9RnF4UAxWIyD6HI/oENnMiw9FdipSAEhUpIHeFjznnXXnnIKFQgNDPJuwKLAwe0WA
	 NhpnttEbo7Isw==
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
Subject: [PATCH v3 02/21] kho: make radix max key width more obvious
Date: Thu,  9 Jul 2026 19:37:51 +0200
Message-ID: <20260709173821.429921-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 414F120007
X-Stat-Signature: dyz7rkdgtkqb8wzfstrkbbnpsamrabsk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783618718-418337
X-HE-Meta: U2FsdGVkX1+Kh9tKMK8tZyNiGk9Du8SHJAcOb8aDBk1AyiYWZ+IVOle8eWY9NWI583MLU6GjRI1fb00lZok2+kJnn+1zDqvt+rXIJ05TXpc9O6UU0AGVGBd1uzyx53+LpDvXhmb9n3IFjE2UeTbYKlBI/odaAa4rzOVSScIZWcl6sbnPbtLqhkVzy8Gyv3pCGL7Jp/LaDsu0SVgO7GOujhCHOXXNPRPh2ctpJRIJlDsnhHSSBCDFk0XLwvtx3EefcrIuTy5X43Tad2Uqhmb4HGFbVxK2PFkFo2bJboOc30TWuG+l/VI6XBE6UpxkXZNwnV8vbg6KV4qrcK8gWCMZorgNAC3MkjOc06lbRtguXcUws8TOXJLJKkkLAJrRLa9hYtvOedPFOCh0f0NXYmgD+ARhDPE4maAMMCJFTThDHSAWSVWu5talHvxHzOB8vDnKJQc8GTvvxIlEH7e91uweU9T0Khf8zomA76Z5/+LPaaiTtggZclek+L9dDK3fnnlXsyKEg0GWjH8eX9fTvrpa5ToQD/XG9bZz0wFDMafquI8zBRmgEAWbDfnK3O7lARPwgZQCqSFBw0D4K94YBNiWwyOtsFfoRvbhRcgkppS2RLSVB5r1A7Sr7JRD5bovR79mDt/CJZQsk0Rs9PazNEMoTHxDSrMFplmtSaWbP0KbTrjp6ZDBmzRQxjhB+qTt4BFzXm7+NFVegkdEfABeiQOf+DbZzGHAIttMW7vvlv3gJLO/K7/7iUyJWpSbrLPUKs2DK0wNrGQZ+/zqapBAsRlNoDn2a7TOmNxTbdgPqTLEmQPm9JBd67nd/cemmRQw97n7flD5dftVkKT22/2F1z2dU0nhVA5K4oQOyNdNvvJT9SHPCd58VdPoLTJFQ/5G/MJvviQ0VnMCQjPYpmiZ8TsX7sANKSR7fcPfq0AuLaXXaqT86XE6et1YAGEc+yaNWqSwE+2CM1iVSsVU27i4jeO
 dBfA5SmF
 RMAYUuPBeW13rT+sz1xJmGAWBbBXa+qT9BJ1WUvl4DV7sY8JPp3OE6D+SCU6joNkRvlwEopJoodIlDfV8soYjmqFqNcwYOd9N/ovPvMvf18UEgdzl7TOINBaHag7ICMi3Uhh0bvWPOlgdLNR+yhpvoMb3TYWZ7yBejv6nFhge54BgYGJFkxsQ5gGjoJaY2z9N3gxnJyZFR8COAshg5OXJvceDT8b2rYZKJtJ2wSUokC7fxkk=
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

In kho_encode_radix_key(), add a new variable for the shift for phys.
Use that in calculating where the order bit goes and in calculating the
shifted PFN. Update comments to make this clearer.

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
2.55.0.141.g00534a21ce-goog


