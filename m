Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF44B606E4A4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ox+ilU9O
Received: by kanga.kvack.org (Postfix)
	id 7BB826B05BE; Tue, 10 Nov 2026 00:02:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B7D6B05BF; Tue, 10 Nov 2026 00:02:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE466B05C0; Tue, 10 Nov 2026 00:02:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8CE6B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93F55C0878
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:17 +0000 (UTC)
X-FDA: 85418013114.24.83B4ABB
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf17.hostedemail.com (Postfix) with ESMTP id CABA240009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ox+ilU9O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3VqXyagkKCMk8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3VqXyagkKCMk8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cb7nq1igl8hjGZd6Q7sjhu2jG9fgOV2JfLPhKUQGV+M=;
	b=lfXvImyBEMwyjnnoIZqOcnW/EA37Xzf4AAZgMcsuNdBFnOsxFx3DQgHZXvyPp746Puu8he
	PQ3UqjLH392mgPEvxMHY8DTqXQCqwNGsdQh6q3eASa8wgbtLxDeNmUMoUEwHiYre8ZH+3K
	z6vxPITnNEE0U+GYFj+qq+AUZoEd3iE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ox+ilU9O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3VqXyagkKCMk8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3VqXyagkKCMk8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286935;
	b=Kt6o4EKQzJq8ZSxElyR+iLQh9NP8W7nu2leTonJu0mhUQF7K3G1IFQ60J8wwstPyccy/G4
	a2PYIcG686KU3LM6/SD+tp1qzgnaUPx1CtcBz/jqLZB8nf0S1pao6Sr6Et8CM+NLkyoS1D
	sTOHwfLHD8XKE6gNo3iw8mUPpTSzd/8=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a99c6e4d78so994351a12.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286934; x=1794891734; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cb7nq1igl8hjGZd6Q7sjhu2jG9fgOV2JfLPhKUQGV+M=;
        b=Ox+ilU9OSLKwBtfm873nCV5x7hblyyIBVAvzXoGdeWtH5dqzv60V4254k0m5klFyFc
         aBT1AwhIc+XgIMCevOsgmxv0vsn0kiXkOHJIZOejf9J2GmxjErjjWlxLp7/AL6AzMJDi
         NhaH+zSUR6QmbjZ5FcrKZTANdV0oCTJKfmC/UYoesOqlaSzadaAVUEck1WzIkEeGC4fA
         Pt1xZ0TuTUjlGr22zVZfTKSd0udzLWwQoCh+Q/m8frIqhk8mniAP5Ro2B0Cg1m/1IBD0
         ggItxqEtbTadory8apkM8iSnjqGuLbiTEyMrf+qZ/fjZzqpr9Os9yM6/l/mUb4bIly2b
         vizQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286934; x=1794891734;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cb7nq1igl8hjGZd6Q7sjhu2jG9fgOV2JfLPhKUQGV+M=;
        b=HSusq/5SEijeutAv8boh6COq2qvmuZyRyx+jfFDUHisYgCKsA/t8KM78hfIRZ/winU
         xTE2hpuv5HFGityv3tXQ+jFaCbnPqo1RGtEaC7smuTFg6T0dMKgc4R2IXk+Xj6F1G7EX
         rIdpsRbUFo0l9L/Vl5Wk5tkxSpKdoHMS2Zi+nYtPi97mrzZ1PDV2tPmgXufmEo1OdSrl
         JnenCzBxo9yMb8/I2dENdg22Vg9J6X+m1JgpzNtdviRU3JlfEGhFXa0YxWqDvQitdULT
         LmZSyWKNBE/RTP86i+UHQ6/yy/tzsNoLARqyzgDgAzSswOnqKTLBOauWGOqXFcLd83x0
         0nMA==
X-Forwarded-Encrypted: i=1; AL+hErFkz3Sqc2KkIZPGktQORk5cDdmtOHxoiOxH6dCIhZIzpEMpazdJXSdcMXqr39A5j/tVNB7i8wCqwA==@kvack.org
X-Gm-Message-State: APuU4Z/YaBK0q5euUY25MG08QdWDtvswZGzgO9TBB7pTCjt1MjL6trZp
	X48q8KvZjdbKivbdB1hDEJZl6GNVswxG7K5zz5gLsZaXjCn+7zJCaW0NeXCOqD1jZ21IVXLWhNn
	6J4hqqw5aM995xkOMTA==
X-Received: from edt12.prod.google.com ([2002:a05:6402:454c:b0:6b5:6cd3:e463])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:c6d5:0:b0:6a9:8863:ada4 with SMTP id 4fb4d7f45d1cf-6b7571c10acmr763572a12.3.1794286934091;
 Mon, 09 Nov 2026 21:02:14 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:51 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-9-tarunsahu@google.com>
Subject: [PATCH v4 08/19] kho: block: Add the feature header to blocks
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CABA240009
X-Stat-Signature: njwuhd5785xuxidiaio1h4gd96ersbiy
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286935-446621
X-HE-Meta: U2FsdGVkX19DCzRy4BinnXdjdo6wUeu+VNeL7Zb2X8sE9I4zsn33dQQe1W54xJlOVJGWoPL34aeUeoYBAgbrDoQgLhJtklTmIvwAprlI9I3AzHZNGtdzupjHgAaH+uz+/RglbOMzbOAECZO6Lv0EenCPRk61nfURMtUvfwMv1g60Qpo6BbA2CVMoB4zrpGeUIb0GtFv215pYBYH75WQKtWNTjyRgJKKTpijhKNYL0e2/3QLi2FkkE92rtSp2z2yNnaoxUOCJUdKpZ2rvGpdQwXyAP/1uh6LQx5fxTvrm1ieOcg9NTuomdxtMlo59/H6YqEXmXCNHmv8JCueKg310cnwIAzuwmTfnRqT+VC8ybgm89Dcp+PNNu0HRx6mD352/YXInlrWRWKnNSYhuL04/A1prQvakcLGJORotEa+3tCIG4BO3DYOIRTY8+JVmjFM9gvivt7LsGakIOXSfeghJerv7oaWomyxiLP9l9n41vk6Btv0pJTWXv9ps7cacatt9tkoAhj48H/qSIQdYrktWtAM418N4NyD/rVs4+GtSjWXYaBbvZ7ryABWe2u6mPGtfTYdw8HzDyrEcNpglpklmpa7VBIVt9jvlHwScLySXPP9T6NIM6i0vO8sW3mQAwjfh1dtzWyn01HdwFQfGKGQ1cnbpQuRAzgRqyHFYlo+w3hXkZ4NbrfFEl7ZBViPkZ4GsWEXNA84naQdrKnZXQoUGliLhrAi7hf85FEa3doG6n4U57ibJYz7xoY6M+GR3YeBKETJiUlOsiygTvvRKXKc+bx5CMD4TN64oE0Z8I+skhHbS1EHOuP6oW1hQznGaPcbTo3PiHrNMf3/Ryuuu75hpSd4gMu/0vjb1PxmelvtASorF0F3kABR60MD5AbND/yzioKFr8xG/bwth+6AIy++dI+akpnjzvZAT8jccIgXZIcqP1mZNnFGQ30tPas8FmN42hpSdXJk+1Q+snLDH43q
 9RgEfGH6
 GznujU7sT0VSoWfTrQVNtlIVt8VamF0bbhoefSeOZB+feE6XcLRQ5DwSEkeHiMpZ8XvESrlcrESL9hngbMU4O+y1n+0xmdMHrEx4O1jKQGwtVvV/UcCamhR6F8OoZtQqXWAnB7nOnGiE0HGpAe3oR95U4hfmcttdI4fs/JIU/ibayDUe7jPtTt0TWj1hj7fpB7f4T50xQOTAjQc74MIa/fkMmM79PajrQTIou3vihG45K+SsDAa/V+zaAoT7UXqcZpG00tKJ5DRuhBBwsLyH3rgGgSOvAqktpGwUv1vIwoYCtwtlurKXATODMNg3EP3mPR/dr3KrKbYV1eapES1CEeRtzuvg0UFig9fMRxVLoy/+uJb+dpXmR64E2oMsbJpICKMfz7/f4dq15lf+0XqygLXpwR3icq8+2l+eByidOm1t5L3kp928SxEI2Sy6zXIq3bLq6gYajc50hUEZZjExoPB3uQm2ocl4CJhN9QlOsl4lsIzaCZzrxFrDXwfrKDqk0L99lj0kfGZhGpIEPkYrozqbdqnl6lHRfjktJZUbs261vtcglvbSA/H5y56hiURC6HPNp4UxzTvhEgzPIlHOi7cjDnCXSbqjqqiYd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Subsystems using the KHO Serialization Blocks framework currently rely
on whole-structure compatibility strings to validate serialized block
sets across kexec. Any modification to the block structure layout
constitutes a breaking change and breaks compatibility between adjacent
kernels.

Precede struct kho_block_header_ser with struct kho_ser_hdr using
DECLARE_KHO_SER. Each block in a block set starts with struct
kho_ser_hdr followed by struct kho_block_header_ser. Serialized entries
start immediately after the header payload at offset fhdr->size.
Block capacity is computed as (KHO_BLOCK_SIZE - fhdr->size) /
bs->entry_size. Subsystems can append future block-level metadata under
new feature indices without altering existing offsets.

On restore, the location of the first entry and the block capacity no
longer depend on the caller. They are derived from the header size and
entry size the source kernel serialized with, even if the target kernel
structures have a different size. Fields that the source kernel did not
serialize are absent: a subsystem must not access them unless the
corresponding feature is present in the incoming header, as doing so
reads memory outside the serialized data.

During restoration, blocks whose header does not fit the block are
rejected, and the chain walk stops at such a block. Validate each block
header and reject unknown required features.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/block.h |  15 ++--
 include/linux/kho_block.h     |   8 +-
 kernel/liveupdate/kho_block.c | 144 ++++++++++++++++++++++++----------
 3 files changed, 113 insertions(+), 54 deletions(-)

diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
index a40b0906c821..5f26c23506e9 100644
--- a/include/linux/kho/abi/block.h
+++ b/include/linux/kho/abi/block.h
@@ -28,6 +28,7 @@
 #include <asm/page.h>
 #include <linux/build_bug.h>
 #include <linux/kconfig.h>
+#include <linux/kho/abi/feature.h>
 #include <linux/types.h>
 
 /**
@@ -40,14 +41,12 @@
 
 /**
  * struct kho_block_header_ser - Header for the serialized data block.
- * @next:       Physical address of the next struct kho_block_header_ser.
- * @count:      The number of entries that immediately follow this header in the
- *              memory block.
+ * @next:       Physical address of the next block.
+ * @count:      The number of entries that follow the header in the memory block.
  * @entry_size: The size in bytes of each serialized entry in the block.
  *
- * This structure is located at the beginning of a block of physical memory
- * preserved across a kexec. It provides the necessary metadata to interpret
- * the array of entries that follow.
+ * This structure is located at the beginning of each block of physical memory
+ * preserved across a kexec, preceded by &struct kho_ser_hdr.
  */
 struct kho_block_header_ser {
 	u64 next;
@@ -55,8 +54,6 @@ struct kho_block_header_ser {
 	u64 entry_size;
 };
 
-static_assert(sizeof(struct kho_block_header_ser) == 24);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct kho_block_header_ser) == 8);
+DECLARE_KHO_SER(kho_block_header_ser, 24, 0, 0);
 
 #endif /* _LINUX_KHO_ABI_BLOCK_H */
diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
index 93a7cc2be5f5..776b57ae83bd 100644
--- a/include/linux/kho_block.h
+++ b/include/linux/kho_block.h
@@ -13,12 +13,12 @@
 
 /**
  * struct kho_block - Internal representation of a serialization block.
- * @list: List head for linking blocks in memory.
- * @ser:  Pointer to the serialized header in preserved memory.
+ * @list:     List head for linking blocks in memory.
+ * @fhdr:     Pointer to the serialized feature header in preserved memory.
  */
 struct kho_block {
 	struct list_head list;
-	struct kho_block_header_ser *ser;
+	DECLARE_KHO_SER_HDR(kho_block_header_ser, *fhdr);
 };
 
 /**
@@ -63,7 +63,7 @@ struct kho_block_set_it {
 	.blocks = LIST_HEAD_INIT((_name).blocks),			\
 	.entry_size = _entry_size,					\
 	.count_per_block = (KHO_BLOCK_SIZE -				\
-			    sizeof(struct kho_block_header_ser)) /	\
+			    kho_ser_size(kho_block_header_ser)) /	\
 			   (_entry_size),				\
 }
 
diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 9b148009085e..20e85ce7fd5f 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -21,7 +21,9 @@
  * append fields to an entry, so the kernel that writes a block and the kernel
  * that reads it can use different entry sizes. The reader steps through the
  * entries with the recorded size, so every entry is found, and it does not read
- * beyond the recorded size of an entry.
+ * beyond the recorded size of an entry. Fields appended to an entry are read
+ * only when the feature header of the structure that owns the block set shows
+ * them present.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -54,10 +56,13 @@ void kho_block_set_init(struct kho_block_set *bs, size_t entry_size)
 	WARN_ON_ONCE(!bs->count_per_block);
 }
 
-/* Serialized entries start immediately after the block header */
+/*
+ * The entries start at the size recorded in the block header, so this works
+ * for blocks this kernel wrote and for blocks handed over by another kernel.
+ */
 static void *kho_block_entries(struct kho_block *block)
 {
-	return (void *)(block->ser + 1);
+	return (void *)block->fhdr + block->fhdr->size;
 }
 
 /* Get the address of the serialized entry at the specified index */
@@ -68,22 +73,23 @@ static void *kho_block_entry(struct kho_block_set_it *it, u64 index)
 
 /* Free serialized data */
 static void kho_block_free_ser(struct kho_block_set *bs,
-			       struct kho_block_header_ser *ser)
+			       DECLARE_KHO_SER_HDR(kho_block_header_ser, *fhdr))
 {
 	if (bs->incoming)
-		kho_restore_free(ser);
+		kho_restore_free(fhdr);
 	else
-		kho_unpreserve_free(ser);
+		kho_unpreserve_free(fhdr);
 }
 
-static struct kho_block_header_ser *kho_block_alloc_ser(struct kho_block_set *bs)
+static DECLARE_KHO_SER_HDR(kho_block_header_ser,
+			   *kho_block_alloc_ser(struct kho_block_set *bs))
 {
 	WARN_ON_ONCE(bs->incoming);
 	return kho_alloc_preserve(KHO_BLOCK_SIZE);
 }
 
 static int kho_block_add(struct kho_block_set *bs,
-			 struct kho_block_header_ser *ser)
+			 DECLARE_KHO_SER_HDR(kho_block_header_ser, *fhdr))
 {
 	struct kho_block *block, *last;
 
@@ -94,33 +100,38 @@ static int kho_block_add(struct kho_block_set *bs,
 	if (!block)
 		return -ENOMEM;
 
-	block->ser = ser;
+	block->fhdr = fhdr;
 	last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
 	list_add_tail(&block->list, &bs->blocks);
 	bs->nblocks++;
 
-	if (last)
-		last->ser->next = virt_to_phys(ser);
-	else
-		bs->head_pa = virt_to_phys(ser);
+	if (last) {
+		kho_ser_payload(last->fhdr, kho_block_header_ser)->next =
+			virt_to_phys(fhdr);
+	} else {
+		bs->head_pa = virt_to_phys(fhdr);
+	}
 
 	return 0;
 }
 
 static int kho_block_set_grow_one(struct kho_block_set *bs)
 {
+	DECLARE_KHO_SER_HDR(kho_block_header_ser, *fhdr);
 	struct kho_block_header_ser *ser;
 	int err;
 
-	ser = kho_block_alloc_ser(bs);
-	if (IS_ERR(ser))
-		return PTR_ERR(ser);
+	fhdr = kho_block_alloc_ser(bs);
+	if (IS_ERR(fhdr))
+		return PTR_ERR(fhdr);
 
+	kho_ser_init(fhdr, kho_block_header_ser);
+	ser = kho_ser_payload(fhdr, kho_block_header_ser);
 	ser->entry_size = bs->entry_size;
 
-	err = kho_block_add(bs, ser);
+	err = kho_block_add(bs, fhdr);
 	if (err) {
-		kho_block_free_ser(bs, ser);
+		kho_block_free_ser(bs, fhdr);
 		return err;
 	}
 
@@ -137,12 +148,12 @@ static void kho_block_set_shrink_one(struct kho_block_set *bs)
 	last = list_last_entry(&bs->blocks, struct kho_block, list);
 	list_del(&last->list);
 	bs->nblocks--;
-	kho_block_free_ser(bs, last->ser);
+	kho_block_free_ser(bs, last->fhdr);
 	kfree(last);
 
 	new_last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
 	if (new_last)
-		new_last->ser->next = 0;
+		kho_ser_payload(new_last->fhdr, kho_block_header_ser)->next = 0;
 	else
 		bs->head_pa = 0;
 }
@@ -203,6 +214,23 @@ void kho_block_set_shrink(struct kho_block_set *bs, u64 count)
 		kho_block_set_shrink_one(bs);
 }
 
+/*
+ * Payload of a block, or NULL if its feature header does not fit the
+ * block. Used on handed-over blocks (restore, cycle check and cleanup)
+ * to bound fhdr->size before the payload is used.
+ */
+static struct kho_block_header_ser *
+kho_block_get_header_ser(const DECLARE_KHO_SER_HDR(kho_block_header_ser, *fhdr))
+{
+	if (fhdr->size < kho_ser_hdr_size(fhdr) +
+	    offsetofend(struct kho_block_header_ser, entry_size) ||
+	    fhdr->size >= KHO_BLOCK_SIZE ||
+	    !IS_ALIGNED(fhdr->size, sizeof(u64)))
+		return NULL;
+
+	return kho_ser_payload(fhdr, kho_block_header_ser);
+}
+
 /*
  * kho_block_set_is_cyclic - Check for cycles in a linked list of blocks.
  * Uses Floyd's cycle-finding algorithm to ensure sanity of the incoming list.
@@ -211,28 +239,35 @@ void kho_block_set_shrink(struct kho_block_set *bs, u64 count)
  */
 static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
 {
-	struct kho_block_header_ser *fast;
-	struct kho_block_header_ser *slow;
+	const DECLARE_KHO_SER_HDR(kho_block_header_ser, *fast);
+	const DECLARE_KHO_SER_HDR(kho_block_header_ser, *slow);
+	struct kho_block_header_ser *fast_ser;
+	struct kho_block_header_ser *slow_ser;
 	int count = 0;
 
 	fast = phys_to_virt(bs->head_pa);
 	slow = fast;
 
 	while (fast) {
-		if (count++ >= KHO_MAX_BLOCKS) {
-			pr_err("Block set is corrupted\n");
+		if (++count > KHO_MAX_BLOCKS) {
+			pr_err("Block set exceeds max blocks: %d\n", count);
 			return true;
 		}
 
-		if (!fast->next)
+		fast_ser = kho_block_get_header_ser(fast);
+		if (!fast_ser || !fast_ser->next)
 			break;
 
-		fast = phys_to_virt(fast->next);
-		if (!fast->next)
+		fast = phys_to_virt(fast_ser->next);
+		fast_ser = kho_block_get_header_ser(fast);
+		if (!fast_ser || !fast_ser->next)
 			break;
 
-		fast = phys_to_virt(fast->next);
-		slow = phys_to_virt(slow->next);
+		fast = phys_to_virt(fast_ser->next);
+		slow_ser = kho_block_get_header_ser(slow);
+		if (!slow_ser)
+			break;
+		slow = phys_to_virt(slow_ser->next);
 
 		if (slow == fast) {
 			pr_err("Block set is corrupted\n");
@@ -257,7 +292,7 @@ static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
  */
 int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 {
-	struct kho_block_header_ser *ser;
+	DECLARE_KHO_SER_HDR(kho_block_header_ser, *fhdr);
 	u64 next_pa = head_pa;
 	u64 entry_size = 0;
 	int err;
@@ -274,9 +309,25 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 	}
 
 	while (next_pa) {
+		struct kho_block_header_ser *ser;
 		u64 capacity;
 
-		ser = phys_to_virt(next_pa);
+		fhdr = phys_to_virt(next_pa);
+		ser = kho_block_get_header_ser(fhdr);
+		if (!ser) {
+			pr_warn("Block has an invalid header size: %u\n",
+				fhdr->size);
+			err = -EINVAL;
+			goto err_destroy;
+		}
+
+		err = kho_ser_validate(fhdr, kho_block_header_ser);
+		if (err) {
+			pr_warn("Block header feature validation failed: %pe\n",
+				ERR_PTR(err));
+			goto err_destroy;
+		}
+
 		if (!ser->entry_size || (entry_size && ser->entry_size != entry_size)) {
 			pr_warn("Block contains invalid entry size: %llu\n",
 				ser->entry_size);
@@ -285,7 +336,7 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 		}
 		entry_size = ser->entry_size;
 		bs->entry_size = entry_size;
-		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
+		capacity = (KHO_BLOCK_SIZE - fhdr->size) / bs->entry_size;
 		bs->count_per_block = capacity;
 
 		if (!ser->count || ser->count > capacity) {
@@ -294,7 +345,7 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 			err = -EINVAL;
 			goto err_destroy;
 		}
-		err = kho_block_add(bs, ser);
+		err = kho_block_add(bs, fhdr);
 		if (err)
 			goto err_destroy;
 		next_pa = ser->next;
@@ -307,10 +358,12 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 
 	/* Free the remaining un-restored blocks in the physical chain */
 	while (next_pa) {
-		struct kho_block_header_ser *next_ser = phys_to_virt(next_pa);
+		struct kho_block_header_ser *next_ser;
 
-		next_pa = next_ser->next;
-		kho_block_free_ser(bs, next_ser);
+		fhdr = phys_to_virt(next_pa);
+		next_ser = kho_block_get_header_ser(fhdr);
+		next_pa = next_ser ? next_ser->next : 0;
+		kho_block_free_ser(bs, fhdr);
 	}
 	return err;
 }
@@ -325,7 +378,7 @@ void kho_block_set_destroy(struct kho_block_set *bs)
 
 	list_for_each_entry_safe(block, tmp, &bs->blocks, list) {
 		list_del(&block->list);
-		kho_block_free_ser(bs, block->ser);
+		kho_block_free_ser(bs, block->fhdr);
 		kfree(block);
 	}
 	bs->nblocks = 0;
@@ -341,8 +394,12 @@ void kho_block_set_clear(struct kho_block_set *bs)
 	struct kho_block *block;
 
 	list_for_each_entry(block, &bs->blocks, list) {
-		block->ser->count = 0;
-		memset(block->ser + 1, 0, KHO_BLOCK_SIZE - sizeof(*block->ser));
+		struct kho_block_header_ser *ser =
+			kho_ser_payload(block->fhdr, kho_block_header_ser);
+
+		ser->count = 0;
+		memset(kho_block_entries(block), 0,
+		       KHO_BLOCK_SIZE - block->fhdr->size);
 	}
 }
 
@@ -371,6 +428,7 @@ void kho_block_set_it_init(struct kho_block_set_it *it, struct kho_block_set *bs
  */
 void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
 {
+	struct kho_block_header_ser *ser;
 	void *entry;
 
 	if (!it->block)
@@ -384,7 +442,8 @@ void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
 	}
 
 	entry = kho_block_entry(it, it->i++);
-	it->block->ser->count = it->i;
+	ser = kho_ser_payload(it->block->fhdr, kho_block_header_ser);
+	ser->count = it->i;
 	return entry;
 }
 
@@ -403,10 +462,13 @@ void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
  */
 void *kho_block_set_it_read_entry(struct kho_block_set_it *it)
 {
+	struct kho_block_header_ser *ser;
+
 	if (!it->block)
 		return NULL;
 
-	if (it->i == it->block->ser->count) {
+	ser = kho_ser_payload(it->block->fhdr, kho_block_header_ser);
+	if (it->i == ser->count) {
 		if (list_is_last(&it->block->list, &it->bs->blocks))
 			return NULL;
 		it->block = list_next_entry(it->block, list);
-- 
2.56.0.506.g506a7eabc5-goog


