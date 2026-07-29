Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4B1C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD8D6B0156; Wed, 29 Jul 2026 10:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85746B0158; Wed, 29 Jul 2026 10:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B576B0159; Wed, 29 Jul 2026 10:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF7156B0156
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CF861C0DBA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:30 +0000 (UTC)
X-FDA: 85042115340.16.0FECDA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8B30620004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jij6GyNU;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9FCJr3mhqy7Y7W9bUA1VftkSAFbZe4TwxjPNvtu3TI=;
	b=iUPA3op1cb+mkA80Dim1ZWRNCYRVlCFNjVT6NwRE41AHZGaCbuqVEFWHBVddqbDDX/BL95
	opjo4/8OSpe1/j/kkyikEhAwoWkhv28DyNW8dfJm65dvYW4UzF4rQVA1UlzlZdnJbO9f4d
	LOJBIcqlyFySLrkFUqyG9kdk2s7Yock=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336988;
	b=rcHqyv++lKWobTmIBY+VG6ci+pBSBsU5yce55XGcRnNyriLllKD1poA32/MrxmQytJXkTh
	tXH6X/WuPCvcmL94soA0O1jc7qPy6oC/gWOrW31/Gm7fMUN28DKq6ZRTfZrJcCfnghL+0c
	X7wgv9dArP1apG39GHLboKFIiChAlEI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jij6GyNU;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 288316011F;
	Wed, 29 Jul 2026 14:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F841F00A3E;
	Wed, 29 Jul 2026 14:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336987;
	bh=j9FCJr3mhqy7Y7W9bUA1VftkSAFbZe4TwxjPNvtu3TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jij6GyNUgIBoePjK7TyXRoecmHjNEYU8lCjAbIoboz5oGa0Zph2QNL/SrKOekfXu4
	 +FER5VqJf1YShzxZLFiPiCQfm2JukZ5X1elnPZzC6P24k4G4NF4QqK/1ktJm+/nYwz
	 6e6UgGIEi74cCfX/4Zn6TkQIo9y+yz8pejf51chbgpXPtFIf6KYLY/H5um5cKhDfm7
	 qcSPqSRgCjgMml1C05+8OrUaqWrCOwM5y8+CnBkrR4LmoYvgPUW7u+Pvz14MIR5dl1
	 HuWpo2pL9UuJoU+a8Iy076T7UAowH0hYRCCslGOgItVDhbvRZj4ceWE0bg2v+fLVbB
	 IyvTrYiL64+6A==
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
Subject: [PATCH v5 02/22] kho: make radix max key width more obvious
Date: Wed, 29 Jul 2026 16:55:47 +0200
Message-ID: <20260729145610.2827231-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B30620004
X-Stat-Signature: zgf55tctxyxhj6s95sx83r5i6er859f3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785336988-988911
X-HE-Meta: U2FsdGVkX18LinQDlFIE+etdG6GCNwyRjcKQt3V89TUdaA+e1PS9XgSQvY6bnrvv0mlqjjndx2PFsjNH8UijEAfBmGbquSAzyERxymNRRZt8fonGszeRNyKuW8Tr7haYLHc5/87AjuaEEvEF4OLycPkREf46dPExjh2CrJs9OHNfDQY7ZGvWXrQn+a6NDEjNZ0B82vn3vUcjiyUAOfGL97HaFxt9p3jxRqlzZWe/1oDHvqhEPuy20hgy8K8f/KJB3KyjJ155xYnsUJe7d+pChSQA2nM1EJb3uTTbMFrJtsdxM20TEVQSerYj1DPK8agBa9beaLGRM3gS8xmkN8B8qu1R87kX37haDOwG9TuaUGzKdt9v6LwqGVSBAh4Gak7mdbAkj3+oz6+QwVJtE4oY2AQIi6LLKX0GDic+jsXbkdwRNqUvkRXMw927WamQYetU59UORFU7+bRjDe2VSzueUpfTaB3y5Mim+8QElUtzpP4ANDy4Zn7vXKV9oTu3YLnjaCPoeRF59KZazHbUythFhFwrrKwi4ufAhE9RFAiHDYqqYISn11hq/5ynQV3yBQzrCPGUxVjqGHOC7iinYx+WvVjukAL15nDhZ9Pg0M2XH6DTmtjRnnv0NLmLZbIsu0zgCgJPWJBp2qvc6Etr7JbXSPylTuQLdW8fSzix+tB2/F2Sf61NEhd4lIcCuTGOGzHcAbSDzCYET8FSV9fHQRW6OJjsdif63StumVKl1d/fedsXbqNdqThNyZl7OoD6SEvvjthOcVhzB4QO3QUKVwo/Wh57U7VTMurPJK0/YnrA3KwacEVnRNti/KaNkF/2qjhb3+FrNi4Hc067UMhofBvogcAeW3TtwGjVDEtHPGn64aKNjG/740L4u895P6nz42+CO4bAm6BPjGma8ES1hN0Oo3Z0ntWpfyyA/X6LCfE/uVMCGbOhvlb5LTdPG0ZfVojlEK03zmJziga5L98gY7/
 IogI7ZJ5
 T+JXXiS66QHPbyt9gDjWglbAfE8LmCY6JwJORzsJzCcE47gmMxchgwJ0z4dRw4RdGFGZ70mU///lRFF8Z1VYrzSUzMBZyPjjhxLiW3wBEyuQBXvGRpXpb6nrOdYwLjWhVRDI5VfcJNmU4Y8S/8AXjH0KGpPKKD40rlZKBGJE/EwB32hpzsTZOI7H5sFabYV50aTPpnosWszcLZlr9Y5bvtZz7LczwxepHeLI3Ny3wcpebI0g=
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
2.55.0.508.g3f0d502094-goog


