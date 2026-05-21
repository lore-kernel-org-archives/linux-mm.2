Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2EFCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 20:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6C46B0096; Thu, 21 May 2026 16:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060756B0098; Thu, 21 May 2026 16:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B386B0099; Thu, 21 May 2026 16:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D06D36B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:59:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50AF014082A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:59:13 +0000 (UTC)
X-FDA: 84792642186.22.D473B00
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6D6F140009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:59:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=gyZvdHKT;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf23.hostedemail.com: domain of kameroncarr@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=kameroncarr@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779397151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zZjL9udFwn6W4wb/ID8EFAgii+j45nXdSF7vNb7mlSY=;
	b=HC3K6zUvm4HbhvgPnpQczz42USbQRey9HMs46QtULlM1APCS3UHZo6Y+e6BA6kW84VWwbc
	9j0r/nP/pMXcizuBcLBI9wxT2iLTogVV/Krvdr55a+brQwSQNq2vWJsKhR9jw/O1WtZLSu
	FTjCQjAa7TAoW2IvRjZCB27LV7krBeU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=gyZvdHKT;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf23.hostedemail.com: domain of kameroncarr@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=kameroncarr@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779397151; a=rsa-sha256;
	cv=none;
	b=TbYC5rPu3ImYDOEc/1oKaVhhWN9SFKZvMar9wCqqklajcZCnUcrrqPxNrh1hVn313s6hqY
	v2LR/vv/b0gbHEeYt44nZvMEzwR3YdrZgGwGXNO1iBIx5C5IGwPNmJFRCinofK8Vw4U3eg
	JE5xNr9k4xVGm/5cwd7Nzk1e6TUSEXg=
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id E17FA20B7167;
	Thu, 21 May 2026 13:59:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E17FA20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779397142;
	bh=zZjL9udFwn6W4wb/ID8EFAgii+j45nXdSF7vNb7mlSY=;
	h=From:To:Cc:Subject:Date:From;
	b=gyZvdHKTjs+bUew1d1t06iSTvj3AkZsIvPu3cLKcknyeHxF0Bcg0Kerz9Lp4dG5T+
	 08vIqN/seEQRXM8wbrbiEK7BriT6jAIYR7mWLoDYYKGeRYZ5sFEXwK41b1fgtnflZZ
	 uHbdwDIAXZVQwosV0oEcLRoKj0PsZQ2ueZi04+ow=
From: Kameron Carr <kameroncarr@linux.microsoft.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	catalin.marinas@arm.com,
	mhklinux@outlook.com
Subject: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and vzalloc_decrypted()
Date: Thu, 21 May 2026 13:58:34 -0700
Message-ID: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qiy1cs4iuh1yp3jgbcf6bpt63c9mzekw
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6D6F140009
X-Rspam-User: 
X-HE-Tag: 1779397151-847801
X-HE-Meta: U2FsdGVkX1+DnUBjdsqAujSB5AeC86Y71rn4vnbBvP/AtoMpgjQ+RSZ/8ATzXqOz/Be1A56NFEZkglfWpZX4nE2c6YCwBJ4YEpSOwSEQYqJJhqMmBSgPewahs/uFdyXfr8SxGjtN6fjOO9OAsM115EOaKVnyI1+alakgLLRkiCOrbgyicvNxg3A8JiBjdDANJ2U5kQpqJoFDP7UhM9zI+tgP74MTs65gicNJbLxvg+TFsNH6jQddD6roUKkVhF9faPwPkvp8iHEWxEVfkyUj3qGlk/2YpGnRXQ2xKnquVz7EPbCG33e0LqOF3kziy2RLNwmwxf5EWUfCG7kQxmxR2DeHjRo84aBWPqKKzFQ1JlnHjBN34P35jqpNYgnUONlZFjjmsvCoE4sMSMpVDNb8uV9wV3HdDJ5Oq/mtz/rOJb+PxtW7rZ1ibf6pNVbNL0MFW/UeGDdQCDkjMTwHJBKnfi9CNi3TqnU4ro8Fwd3Gc2jwhYAuSfTColdyMrixtRFD7+UzRVMqvBokiyUYa3GGMwx5HMqCJhGeetO33z1McpVNAp462zMSKocj5vcR+OVOfrdJ5gOxFjnLSTkuHa92zWg7QSi3opKErrDqGwpD3zfik/OA7DZpeRbGdexMU+ukimbjVUg5rWKwLY9w9KZk+P8YJ8ZtBrmNXSzS9Gyw3mT8fjs2fAOBm2eNOTL+NXEuZyct+UJGbJzYHou1sGk0A2nH8v0Nf7rFYdibRp4rsFhWNec/ynqEGEX4XW+FbRQTv9DlPE2ng/bPbnYbcNeMoyHXj7Z5QYEhLtpsA/yufkkGU1FRwKo3I9h658wM22DcXN7jW8Z5XDolV8wKts/NTmyXwf28YU4y1srAx1rWpwrjRmcl47TVZL6bEy3OR5IuIyxAq/snJI4LDIrwD/qULJjirwXhRSDkmkAz3zXt8PwgdSXnvbDND87KaRssd10e3ZKsH1wmevbgehxywJO
 Jji3c8Gy
 AhCBarUeAeiotxRloBsMk3jz2jPQHRweX/wZ98+3+HtNwdjs3DxDrwkgkuh3i2bQt+eY1+hjbajuRoOqx202LOfwRz0z0gqk+X1G3iceOtt8AcoC2CQIsTU5dD25Vguh3rcgrcjgY77jePk6U5t78mBRzbV/yAIueHe9GrmbY5sm60L5Cn4QGRI75bLbLTInQj95NHGzm5Tl0aMVJ+VjTbZBvznyrdLqOI5bEF5OCw/ZMKn4aI8CVG793U1jsbw/7ybSEvXKh2T9nu41kZOvW114UG00tD4lkYH2VSF2ZLv6s9Us29YqX1rU1VLvWuPBKX1nUnw3z+8XzfTVPFo5+QPJtn5mjoMMhobtrPUuSJpdiGiixKPEyzHzvRregZTX20E6E8Q2qoEiETzeGNr46fgAskcvO7thuHYIz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In confidential computing environments (arm64 CCA, x86 SEV/TDX), guest
memory is encrypted by default and must be explicitly transitioned to a
decrypted/shared state for host-visible access.  Calling
set_memory_decrypted() on a vmalloc address is not supported, and not
recommended as it would be inefficient to decrypt the pages after they
have been mapped.

Add vmalloc_decrypted() and vzalloc_decrypted() which decrypt pages on
the linear map before creating the vmalloc mapping via vmap(), so
physical pages are never mapped with conflicting encryption attributes
across aliases.  A new VM_DECRYPTED flag marks these allocations so that
vfree() automatically re-encrypts pages before returning them to the
page allocator.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/linux-arm-kernel/ZmNJdSxSz-sYpVgI@arm.com/
Signed-off-by: Kameron Carr <kameroncarr@linux.microsoft.com>
---
 include/linux/vmalloc.h |   7 ++
 mm/vmalloc.c            | 163 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3b02c0c6b371..d87e1953da55 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -38,6 +38,7 @@ struct iov_iter;		/* in uio.h */
 #define VM_DEFER_KMEMLEAK	0
 #endif
 #define VM_SPARSE		0x00001000	/* sparse vm_area. not all pages are present. */
+#define VM_DECRYPTED		0x00002000	/* pages decrypted for host-shared access, re-encrypt on vfree */
 
 /* bits [20..32] reserved for arch specific ioremap internals */
 
@@ -153,6 +154,12 @@ extern void *vmalloc_noprof(unsigned long size) __alloc_size(1);
 extern void *vzalloc_noprof(unsigned long size) __alloc_size(1);
 #define vzalloc(...)		alloc_hooks(vzalloc_noprof(__VA_ARGS__))
 
+extern void *vmalloc_decrypted_noprof(unsigned long size) __alloc_size(1);
+#define vmalloc_decrypted(...)	alloc_hooks(vmalloc_decrypted_noprof(__VA_ARGS__))
+
+extern void *vzalloc_decrypted_noprof(unsigned long size) __alloc_size(1);
+#define vzalloc_decrypted(...)	alloc_hooks(vzalloc_decrypted_noprof(__VA_ARGS__))
+
 extern void *vmalloc_user_noprof(unsigned long size) __alloc_size(1);
 #define vmalloc_user(...)	alloc_hooks(vmalloc_user_noprof(__VA_ARGS__))
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index eabb86b13b7e..0e7f0033aa84 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,103 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * Transition a single contiguous block of @nr pages at index @idx in
+ * @area->pages to encrypted or decrypted state.  On failure, the block's
+ * page-pointer slots are cleared so the standard free path will not return
+ * the pages to the allocator (they are leaked).
+ */
+static int __vm_pages_enc_dec(struct vm_struct *area, unsigned int idx,
+			      unsigned int nr, bool encrypt)
+{
+	unsigned long addr =
+		(unsigned long)kasan_reset_tag(page_address(area->pages[idx]));
+	int err = encrypt ? set_memory_encrypted(addr, nr) :
+			    set_memory_decrypted(addr, nr);
+
+	if (err)
+		memset(&area->pages[idx], 0, nr * sizeof(*area->pages));
+	return err;
+}
+
+/*
+ * Compact @area->pages, removing slots previously zeroed by
+ * __vm_pages_enc_dec().  Returns the number of leaked pages
+ * (old nr_pages - new nr_pages).
+ */
+static unsigned int vm_compact_leaked_pages(struct vm_struct *area)
+{
+	unsigned int i, dst;
+	unsigned int old_nr = area->nr_pages;
+
+	for (i = 0, dst = 0; i < area->nr_pages; i++) {
+		if (area->pages[i])
+			area->pages[dst++] = area->pages[i];
+	}
+	area->nr_pages = dst;
+	return old_nr - dst;
+}
+
+/*
+ * Re-encrypt the linear-map alias of all pages backing a VM_DECRYPTED area.
+ * Best-effort: on per-block failure the loop continues so as many pages as
+ * possible are returned to the encrypted state.  Pages that fail to
+ * transition are left out of area->pages and leaked.
+ */
+static int vm_pages_encrypt(struct vm_struct *area)
+{
+	unsigned int nr = 1U << vm_area_page_order(area);
+	unsigned int i;
+	unsigned int leaked;
+	int ret = 0;
+
+	for (i = 0; i < area->nr_pages; i += nr) {
+		int err = __vm_pages_enc_dec(area, i, nr, true);
+
+		if (err && !ret)
+			ret = err;
+	}
+
+	leaked = vm_compact_leaked_pages(area);
+	if (leaked)
+		pr_warn("vmalloc: re-encryption failed, leaked %u pages\n",
+			leaked);
+	return ret;
+}
+
+/*
+ * Decrypt the linear-map alias of all pages backing a VM_DECRYPTED area.
+ * On failure, the already-decrypted prefix is rolled back to encrypted.
+ * Pages that fail either the initial decrypt or the rollback re-encrypt are
+ * left out of area->pages and leaked.
+ */
+static int vm_pages_decrypt(struct vm_struct *area)
+{
+	unsigned int nr = 1U << vm_area_page_order(area);
+	unsigned int i;
+	unsigned int leaked;
+	int ret = 0;
+
+	for (i = 0; i < area->nr_pages; i += nr) {
+		ret = __vm_pages_enc_dec(area, i, nr, false);
+		if (ret)
+			goto rollback;
+	}
+	return 0;
+
+rollback:
+	while (i) {
+		i -= nr;
+		__vm_pages_enc_dec(area, i, nr, true);
+	}
+
+	leaked = vm_compact_leaked_pages(area);
+	if (leaked)
+		pr_warn("vmalloc: decryption failed, leaked %u pages\n",
+			leaked);
+	return ret;
+}
+
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -3457,6 +3554,9 @@ void vfree(const void *addr)
 		return;
 	}
 
+	if (unlikely(vm->flags & VM_DECRYPTED))
+		vm_pages_encrypt(vm);
+
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
 
@@ -3895,6 +3995,22 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		goto fail;
 	}
 
+	/*
+	 * For VM_DECRYPTED areas, decrypt each
+	 * page on the linear map before creating the vmalloc alias.
+	 */
+	if (area->flags & VM_DECRYPTED) {
+		if (vm_pages_decrypt(area)) {
+			/*
+			 * vm_pages_decrypt() re-encrypted what it could;
+			 * clear VM_DECRYPTED so the deferred cleanup path
+			 * doesn't try to re-encrypt again.
+			 */
+			area->flags &= ~VM_DECRYPTED;
+			goto fail;
+		}
+	}
+
 	/*
 	 * page tables allocations ignore external gfp mask, enforce it
 	 * by the scope API
@@ -4203,6 +4319,50 @@ void *vzalloc_noprof(unsigned long size)
 }
 EXPORT_SYMBOL(vzalloc_noprof);
 
+/**
+ * vmalloc_decrypted - allocate virtually contiguous decrypted memory
+ * @size: allocation size
+ *
+ * Allocate pages in decrypted/shared state for host-visible access in
+ * confidential computing environments.  Pages are automatically
+ * re-encrypted on vfree().
+ *
+ * Return: pointer to the allocated memory or %NULL on error
+ */
+void *vmalloc_decrypted_noprof(unsigned long size)
+{
+	return __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
+					   GFP_KERNEL,
+					   pgprot_decrypted(PAGE_KERNEL),
+					   VM_DECRYPTED, NUMA_NO_NODE,
+					   __builtin_return_address(0));
+}
+EXPORT_SYMBOL(vmalloc_decrypted_noprof);
+
+/**
+ * vzalloc_decrypted - allocate zeroed virtually contiguous decrypted memory
+ * @size:    allocation size
+ *
+ * Like vmalloc_decrypted(), but the memory is set to zero.
+ *
+ * Return: pointer to the allocated memory or %NULL on error
+ */
+void *vzalloc_decrypted_noprof(unsigned long size)
+{
+	void *addr;
+
+	addr = __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
+					   GFP_KERNEL,
+					   pgprot_decrypted(PAGE_KERNEL),
+					   VM_DECRYPTED, NUMA_NO_NODE,
+					   __builtin_return_address(0));
+	if (addr)
+		memset(addr, 0, size);
+
+	return addr;
+}
+EXPORT_SYMBOL(vzalloc_decrypted_noprof);
+
 /**
  * vmalloc_user - allocate zeroed virtually contiguous memory for userspace
  * @size: allocation size
@@ -5271,6 +5431,9 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 			if (v->flags & VM_DMA_COHERENT)
 				seq_puts(m, " dma-coherent");
 
+			if (v->flags & VM_DECRYPTED)
+				seq_puts(m, " decrypted");
+
 			if (is_vmalloc_addr(v->pages))
 				seq_puts(m, " vpages");
 

base-commit: e9add7501ad3297dad9b90ce201266830a68ab47
-- 
2.45.4


