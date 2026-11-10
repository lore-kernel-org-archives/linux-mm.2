Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC4E606B884
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jqGnBRI6
Received: by kanga.kvack.org (Postfix)
	id 98F8B6B05B9; Tue, 10 Nov 2026 00:02:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918C96B05BA; Tue, 10 Nov 2026 00:02:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7933D6B05BB; Tue, 10 Nov 2026 00:02:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AAE66B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B306712088B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:10 +0000 (UTC)
X-FDA: 85418012820.19.3C11F3C
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id F40C020003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jqGnBRI6;
	spf=pass (imf31.hostedemail.com: domain of 3T6XyagkKCMI1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3T6XyagkKCMI1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286929;
	b=jHJVX8CCEXVOL1QaVoz21ZQOm6qCNfKHu0ieQ4EeLPK5MsfVm46YcliBY0z73nDaQ3A6re
	CK2K5x7H5dCBQYvg3V7SWv1M83Llnc42GmBrwSoICLnyarEXAzpqFavnqas7VmR5S8U9TR
	JSMBQWMCFjORN14uow/bixAXFqtPsPc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jqGnBRI6;
	spf=pass (imf31.hostedemail.com: domain of 3T6XyagkKCMI1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3T6XyagkKCMI1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCVasoLTZkfDLPIf3+UIMM+CIyIOn5HRothnXhPkfvs=;
	b=DhKfVPrVag/66clhrV7VI3r+4iZBrIzB19Ej6Xz5IMHRhRBoJFvo/Rzupzmu36XRkNQI8s
	c71eFk5MBR7eCxpF8Ryi+QO40gM0BbfIGk7fgzL+EA+7AcDZnF/HUVosKWTuCIhIsQ+im9
	FLuC6V0h+fKPX2hxeQdWg+RhDzhHvX4=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c4322d31021so170411366b.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286928; x=1794891728; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gCVasoLTZkfDLPIf3+UIMM+CIyIOn5HRothnXhPkfvs=;
        b=jqGnBRI6qbXwion5yUkBOEcoDWBf+88lm7rzSUg1r/oLQvJ/XnS3cghIeZ34mfhX8V
         +PCHIGDjPmDQnJZQ907Dj5Mxp3HyuCfP6IehiBXgIvGzEW3Oi2oEnCgg6Wuh2F3i6GfH
         PAFfIJrdnBGMgXVv+tiDc9o8ZMNePUBFoa3L4zvx4eoEuVlXMcTBZWr9M8ICevG7KBsb
         OnGh82hSR4UGHAQq6PyxQETI2c8CXGcixfBBH6cJNam6MrFSn1gUHRbwEhq5QgWfff62
         dHEIKhzgjClxlMIP5kvxJtmHxcbByXkqwPTdkxZNLBAJPAq4uOTNm5Dc5VUsL+jZ9oO9
         hUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286928; x=1794891728;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gCVasoLTZkfDLPIf3+UIMM+CIyIOn5HRothnXhPkfvs=;
        b=nPtCRgblWfoRzUETvUrwTF4MetPmAkQOredrjNxLE8dx6K5ee8g6n4fJ7KP0qMyvxL
         WSP2nP6SyXfgW3PXYgs/Em0xDV3vtOBHahBnYzowQrP02Nok+wfM9BOTRgfQTV3rkCPG
         I/+5oK/h35BK7TuiLYWctZDMC3OJp2KKY3v5EiHyULWfoy5oFBfajl0TT1QOQpxi4vCM
         dmX1au6imd4K4Ae/B7MxWfCJ3YQ027PPSTJg9da4SPGyNx6TACxhYeW8wKTFvyIayoqM
         VYG/8zIbpSkbv0X6cCI7H8h12uX4U34iAnlAgmlgBcVJAV2mLz8ZPnCTtPrDDQq4MWZK
         YN9w==
X-Forwarded-Encrypted: i=1; AL+hErGu3rw22d0i9FcqyzJULF3xJdQg564dJBw8S5B4P1t75vXSU6Dv/YMf7ipX3Vx1qO6IM0EzdwQFdA==@kvack.org
X-Gm-Message-State: APuU4Z/h7p3xzY1o4ky6w5WiW335YZrbzBrQUoH2ImGnLKxz/sDHWzj3
	mrsINvTrvE4CwOx2qrexz+rZPNhCe930UYvmuVp+uPet4HE/fn4LR7dQVGHBLJX1Q4SJzPUDx6r
	p9MpdPrVtWBZo3YgmwQ==
X-Received: from ejzl18.prod.google.com ([2002:a17:906:a412:b0:c4d:1fbc:e718])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3dac:b0:c31:5bb8:4b3b with SMTP id a640c23a62f3a-c5048f79e02mr108053466b.2.1794286927522;
 Mon, 09 Nov 2026 21:02:07 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:45 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-3-tarunsahu@google.com>
Subject: [PATCH v4 02/19] kho: block: Record the entry size in the block header
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
X-Stat-Signature: 7wc6pk6hb4s4dsgbry6duqdmhtmjm6x7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F40C020003
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286928-325156
X-HE-Meta: U2FsdGVkX1+ftr7/4+d9ko/cI4aXF6XQCbpXmTcU4HNOw+UWw1uUqY+oBxz7e3LEzBW7NvbRczB976r1rpls6f4VbCUwwJDuTnL/6/4/NA3W7gt7V5anFfXLujuIqQ9r3HTPXs5Rr7W4rnsYTsxUc3iE0y5KrLXu53qmBjLlhzYwHLZ6cIaJefaocZBvZxEm9HvSBaKKk3V8oFipa+TT8TOKEo5b/3EJo99NZw9wJ1/pxoaCSsrmEfobSmkJ/AJVzaaF00AMcCsW/DaE76OEqi9Er0EkDxBUmAzjpK0/r6ueoI8xIM3CAO67Adz2UzZ+7qZ93M7bbYYKl8HQwHH1AzOYAwBGqQqUZewoDDeB0UFRCeHI6eziu3de/gGwMqwGODRym72s6fP8b8DTaw/Gc4fTOtL9BBJWWMoSgi/jGmMSGb6pGsNUCo46OhwRb3ZlV73/aoThmVPy/+aP+VJdt/S0HWxMv+ZT4+Ugg6OeSdclFhrmQny18UEqd8M1bHLaYyP5P2M/E0KV+NpxE4KqDmXz8Xkb8blUZzo9SFYRjq+GXcYyVFjGSrUvd+dYLq9gD5vh3IMrXdZYyIk/45CQGN1jloZFIvVgzsjXb50xGHqnnSSWKew72maQijgxcztmqM8OAPGaxQbyZ0Bf1RbHopvEQfBROar/DA9HGPsI+GKLDV3DFv/aMLpitR5fm8gEWucQhSBEbQvQAvzPOTdcJ6LUXXq/9DpT3PB9r/ApSccQIrieMo8EnoT0JRdW+gI88HsuwOwNztcMfTsnwkfHFBKX3gD2es16Y/Czjq1zn1U8mDWB3qyyhW3mxMoo9xRdvQ1FZ9BMfD7sFa9hMIg4pIl5my2iPyA3EqMUaNW5DYZHXunEePGfKrYStpvFWf1fJ0hL/j1GrMroLwP9EFDkKy9Saaq4GCHfe00ohGoTBSmrjixAJYrC9Qv9EbCyIV9Ue69joi3Pm26Lp0Uwn3b
 bAEqq6LJ
 FPcnzDHvmCSQYPYstTvqr4YwG7hVAGhk3v2Z9zYD5gxqVh8mdTvRfhUM4k3VCKmRWNucEtHNJa8Y3WG1KeY3olSSjfpyeC/Cc+XhiXuIoN4XzjitzDpo2WxJMd5a7JhOgwIg1gYw5xQkSXATiRPJs38Ysm6ijHBLy3UUs5oUFrBTZjOTsOcI/RGfMuNvpYWFbOFsuLh7KrPwScWc0eEwXyY7MHsKDLvP36t13MOd5fQlV2OKcancc8FDAwUIKOV7xhllvzyQx5awOnEWci9fR4eOO7qlrsV9H9mxOKjn9KPbUNCHQ9E6RvHZNgFqbJYXJExI05w9evny4mWvjBlsQ5MZtOoIcwKAL2r/9d8IHhfQyKzecRH3h/UEABkjbMcMBhH8l3CLaB87WgTPPDkGgp7i1RvuJalOfC/HIGBQrxDtbaWdRzRb+zb/hNDDrHgDJw5JjJecBJTocj9e7MPO5wMIvXZoBhwZwwHRey/uvOsCX3Epfs6VWuWcf/XvYMj8PYBUHAbhYwKvwlcWzwe/z4KVq8htOqiGd9mmpDAeEqOlIxlczY6kj4ZU4assOgU0Jq/nDA9dwsi0hPziplzv5M+k3GWjI7ciLOqPwAKCnJI98nIrY78fS7ojgMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Subsystems using the KHO Serialization Blocks framework currently do
not record the serialized entry size in the block header. The entry size
is only known to individual callers, which must track and store it in an
owning serialized data structure. If a newer source kernel adds fields
to an entry, the changed entry size breaks the stride when an older
target kernel iterates over blocks.

Add an entry_size field to struct kho_block_header_ser. On the outgoing
side, record bs->entry_size into every block header during allocation.
During restoration, derive the entry stride directly from the block
header instead of relying on caller-supplied dimensions. The
kho_block_set_init() interface remains unchanged. A zero entry size,
or one that differs between blocks of a set, is rejected during
restoration.

This change modifies the serialized layout of struct kho_block_header_ser
and shifts the offset of serialized entries within preserved blocks.
Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
kernels cleanly reject mismatched handover state during boot. Also
update the stale compatible string example in the documentation.

Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/block.h          | 10 ++++----
 include/linux/kho/abi/kexec_handover.h |  6 ++---
 kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
 3 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
index 36bdbaf9b3b8..a40b0906c821 100644
--- a/include/linux/kho/abi/block.h
+++ b/include/linux/kho/abi/block.h
@@ -40,9 +40,10 @@
 
 /**
  * struct kho_block_header_ser - Header for the serialized data block.
- * @next:  Physical address of the next struct kho_block_header_ser.
- * @count: The number of entries that immediately follow this header in the
- *         memory block.
+ * @next:       Physical address of the next struct kho_block_header_ser.
+ * @count:      The number of entries that immediately follow this header in the
+ *              memory block.
+ * @entry_size: The size in bytes of each serialized entry in the block.
  *
  * This structure is located at the beginning of a block of physical memory
  * preserved across a kexec. It provides the necessary metadata to interpret
@@ -51,9 +52,10 @@
 struct kho_block_header_ser {
 	u64 next;
 	u64 count;
+	u64 entry_size;
 };
 
-static_assert(sizeof(struct kho_block_header_ser) == 16);
+static_assert(sizeof(struct kho_block_header_ser) == 24);
 static_assert(!IS_ENABLED(CONFIG_64BIT) ||
 	      __alignof__(struct kho_block_header_ser) == 8);
 
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 2f4fb9c63942..6f12f5037ea5 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -41,7 +41,7 @@
  *   restore the preserved data.::
  *
  *     / {
- *         compatible = "kho-v3";
+ *         compatible = "kho-v5";
  *
  *         preserved-memory-map = <0x...>;
  *
@@ -62,7 +62,7 @@
  *     };
  *
  *   Root KHO Node (/):
- *     - compatible: "kho-v3"
+ *     - compatible: "kho-v5"
  *
  *       Identifies the overall KHO ABI version.
  *
@@ -90,7 +90,7 @@
  */
 
 /* The compatible string for the KHO FDT root node. */
-#define KHO_FDT_COMPATIBLE "kho-v4"
+#define KHO_FDT_COMPATIBLE "kho-v5"
 
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..9b148009085e 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -16,6 +16,12 @@
  * array of serialized entries. Multiple blocks are linked together via a
  * physical pointer in the header, forming a linked list that can be easily
  * traversed in both the current and the next kernel.
+ *
+ * Each block header also records the size of its entries. A newer kernel may
+ * append fields to an entry, so the kernel that writes a block and the kernel
+ * that reads it can use different entry sizes. The reader steps through the
+ * entries with the recorded size, so every entry is found, and it does not read
+ * beyond the recorded size of an entry.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -110,6 +116,8 @@ static int kho_block_set_grow_one(struct kho_block_set *bs)
 	if (IS_ERR(ser))
 		return PTR_ERR(ser);
 
+	ser->entry_size = bs->entry_size;
+
 	err = kho_block_add(bs, ser);
 	if (err) {
 		kho_block_free_ser(bs, ser);
@@ -242,7 +250,8 @@ static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
  *
  * Restores a serialized block set from a given physical address. The caller is
  * responsible for ensuring that the block set @bs has been allocated and
- * initialized prior to calling this function.
+ * initialized prior to calling this function. The entry size and the number
+ * of entries per block are taken from the restored block headers.
  *
  * Return: 0 on success, or a negative errno on failure.
  */
@@ -250,6 +259,7 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 {
 	struct kho_block_header_ser *ser;
 	u64 next_pa = head_pa;
+	u64 entry_size = 0;
 	int err;
 
 	/* Restored block sets use size from the previous kernel */
@@ -264,8 +274,21 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 	}
 
 	while (next_pa) {
+		u64 capacity;
+
 		ser = phys_to_virt(next_pa);
-		if (!ser->count || ser->count > bs->count_per_block) {
+		if (!ser->entry_size || (entry_size && ser->entry_size != entry_size)) {
+			pr_warn("Block contains invalid entry size: %llu\n",
+				ser->entry_size);
+			err = -EINVAL;
+			goto err_destroy;
+		}
+		entry_size = ser->entry_size;
+		bs->entry_size = entry_size;
+		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
+		bs->count_per_block = capacity;
+
+		if (!ser->count || ser->count > capacity) {
 			pr_warn("Block contains invalid entry count: %llu\n",
 				ser->count);
 			err = -EINVAL;
@@ -370,7 +393,10 @@ void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
  * @it: The block iterator.
  *
  * Iterates through previously written entries during state deserialization,
- * respecting the actual count stored in each block's header.
+ * respecting the actual count stored in each block's header. Entries are
+ * spaced by the entry size recorded by the kernel that wrote them, which can
+ * be smaller or larger than the caller's structure. Fields beyond that size
+ * are not present in the entry.
  *
  * Return: A pointer to the next serialized entry, or NULL if all serialized
  * entries have been read.
-- 
2.56.0.506.g506a7eabc5-goog


