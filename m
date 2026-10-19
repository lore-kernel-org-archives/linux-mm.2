Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EEF2CCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2974E6B00E6; Sun, 18 Oct 2026 22:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248636B00E7; Sun, 18 Oct 2026 22:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D456B00E8; Sun, 18 Oct 2026 22:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E15CE6B00E6
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68E4C405C7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:24 +0000 (UTC)
X-FDA: 85337748888.16.5EE9DA5
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD51340005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ABaOCQEg;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Puhhw/KYQlkth6JZ8nHBxXQPEXoRo970byZVNnmTOX0=;
	b=2oMpbxhX8RdQm5JZiFqdm/0wQz+SWJgrWtCxTCdJRuva7+BNMCnxHZoMIs7crgf4FSLbtP
	nq2tfB000bgNiQtY6oJym77Rv4YiI1BVoJBlkgIV//H//m2m/hs+otycbFRPodN9KfNk+4
	C7yAqLphZo0JOL5D0quxcWfO8jEG8RU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375882;
	b=qgLOqjWBHarEdIZTPyYh/BoSk0kRY34JLAOitAT7weCXUpnLjdU4Cql+X6Rb0opJfduNYc
	YF0RDk5EfxCFrG3QPz/d8G1y4C/vdurrpm2ZfBin6Bd5YSmWvAlFKietEbGYXNWaPcHvNa
	vb2PoyrxbQj61FNN2EnmGVeOuYqBwqo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ABaOCQEg;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5e930a11148so1138828e0c.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792375882; x=1792980682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Puhhw/KYQlkth6JZ8nHBxXQPEXoRo970byZVNnmTOX0=;
        b=ABaOCQEgJKPTqalvqi/G5AU6VO9ueGOOKC2ocSt7JlHIxo5+iBypdbO0Rb3ZFl4Iqn
         WhivwmqJUg+Oaa2aGW74xNihYx7YZZ39GtQSoUTGSkxklSDW034ziAxTWIL1MR2d6Tkg
         x0QcvkDGmJPsHbGslHSKX2yuvsTau3TP7j9Ci1u0En2FW2hMgtXsCOfKDIgVSRDrjq8i
         QwmEhrmF2/CXIwvHu5PVFzcBqqgdvQSpawOJvNKn9Wg1NNkW73A+SCCmtCNuXmL0EqkF
         gaA2uew51zMZIcZmlGpulyu20y9CHnQOAe6kFRfRuJoTXZFKIxxTFiVoeZcRJZIHzdmz
         qGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375882; x=1792980682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Puhhw/KYQlkth6JZ8nHBxXQPEXoRo970byZVNnmTOX0=;
        b=HC0MeG6xAsSSoj20g34Dtwpa1xopslxOgxWqEkJpzXOlfTP5GafpbIoh9zeN/FX6bj
         Ia21/gM3FMNfR9u7W0G02TDW+3jnu6ZCGTnNkdf90nfT6NQycHKyleKkqSWwCh9kIIOp
         ESwA/0nEuQGcn4eJZfEWWUKzwQl2kISNN1wtiX8elrO8sNygN5DtJW+QltQKaOhBsZzZ
         e4UeD2UV7UKMQWquNsX6dOfaxAD9A0CdJ3PBWhBFE5+EmeJc2Khyl+jnqePYwl9iFGbB
         /5mI29ksuLmeWsxCmB1HIGB08TYgHhKr+mkgW/86X4INkc3JrWc7qvH3yen6gJkHizSd
         4GDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzq9lzjED7UJ9NaF/GjdAnZgZ7hGAm0pqdcNr/ohYK2m+uMc7T1O0Ocpzp4QmsWRuEMNPBL/Avr2g==@kvack.org
X-Gm-Message-State: AFq9FYLi9OiD5CFjHdNyakxRukOx30YAE19mYVyvBEJQNNVK4DBnl+N9
	W92H2yTM523ToESXbVPiV5DHNUX69eqvRJdHw3NfqyMI8VN5szlmZM3rWH9GrHBxzkiR1slES0i
	6ypnY
X-Gm-Gg: AYBFou3U7lLOmhOGSdR2KNMlZmWUOe24D0wgH11HVHWC6Vnz/W5xnO3epFsyKOINsk9
	UX16JeAqSPMNJylpeI67sppw0MQJrQj0FuSSqJnYmaZo6QAhxnQMOT02XpZN4Zqc06k/KZ9lwjw
	lQPn5R3RQD3DJhTbJ9G/goDW2LSladnvO1sMBknFS6lQnsWTIap8KwpgaIqanMfMDd6RdY+8b2f
	ts8J1jOy5FGlf6MWLP1t7u01HoW6EDX3bIPkMmDsMFxp03HVJhO5xglvxGVCSfcE4rDvPJ7xg0f
	0T5tcMPgtRBh3ey3+KxuxhsBFl8c0+jYbQzIpYlJzpMC1YHYhDB8MRxBocSIVgdZqyP2kFG/BCF
	dh3BDkX7NsrnUj+/OKRl7pcbbE+55m4VbJzoRV5wz3VrFfH/VBQQPcBjHuq5p3Tw/Kpzob3wAAA
	KUMKl363v+TCR7/S1/CnhyLiiEubCYVjkfXbN5eAZTjEKjkcYtG0przKis7Vepl7V3kfd1NEIFf
	FZi/GS2eOKf6NFqdKAyDLhx2QrzSj4MvYB8lXDIlFTPdxFKnoelMugFDwpUcfgVPVAQ9TNaQwOn
	RnKM8znCZJmAddwiRqY=
X-Received: by 2002:a05:6122:d19:b0:5ea:c90d:d1b2 with SMTP id 71dfb90a1353d-5eac90dd9bfmr480991e0c.13.1792375881262;
        Sun, 18 Oct 2026 19:11:21 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabbd9ea2bsm4271383e0c.2.2026.10.18.19.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 19:11:20 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v1 3/8] kho: validate preservation metadata in kho_restore_vmalloc()
Date: Sun, 18 Oct 2026 22:11:06 -0400
Message-ID: <20261019021111.990394-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019021111.990394-1-pasha.tatashin@soleen.com>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7rgbrh157zahmx3xcp35tn5myrucynxu
X-Rspam-User: 
X-Rspamd-Queue-Id: AD51340005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792375882-574051
X-HE-Meta: U2FsdGVkX18KP/5NGDVUtk2kqTNzSnaFbDgQ2KpUjLjhJEJ4Qsi5L+tYvG2lhTBqgdX1jtk+md4aiQYo8KkhoturbSLnpooA7CsjWvqX6VMWzWVaq/7mBb4oINrlaT07+zErojUqzLbgMI0ad0lVbmNwhxXa4swvZkX67yrgmP99sbVP9rJu7CdEFxvMBFm623kWZUAvhR0tW8fzciRtFdX+3LdOmhjlkWXPEhS+sGVU8X+7UoS8qiHiObW0yrUBvBeP+8gvqo8oIb/6lJpGM5pY/UKHkZmM7oXOf2FxwYZmbiLXq5teeQ9uQV5O2B04MyBj12gPGz7GxIw1lWMirBFTlh/LVk1WB7qU8YXu4tHaGSUS5nWq+5Ch23PFjGDeS4qo8Rj3wVAxmkHbejZfdPcbA7ADUTlDA3TYlWtHsP2DrZ41/r+sYfyTGV5Wi2HkA+A69+6tZt8hoL4jFhi2AlLb9SzKdDgNNoccYsNEjKc/LaMEzUkVbG9bWiHaHPWzVShRcU9xU9cnoxRdsToEfWvqRXIbTylEXtOeFyjyl/5tGPoH4iS776sqKmVRvl/pJkZdwHUz4bwvORC5bn/N2spF1DClyt21zIi6RKEIMlUAH7Nyx7AWrb5YeqzMIa8OSI+Jz4f54XDZTp4yJ1//JMLJvlJrZpfRHbeMqFlnoH5UeBBWgAB0dIgy597DuxX4bfFQ/ml/X5j/Xe08wbi23o+tbOb5VrFrWgw6qfCrDUV/Bpjo6O0Mg16ydKWbri4musgxX4hUyCnJ2o/VWS3/KSS6NLYNKZHgJgsaTiaMwT9DxtHvT/WWjMGUOxKFxgJ9qcNAswWdA1tqJNgklOPfRPHN87bvaZsOGSIUKf4Fsx9s44gIUgbu1JeY9NNfGWR1TVUHLGtTHNLk41Q9+6YHNrEdNSRc2xX2uixyCfsvQS8dmWUbZpY/2WXreBWkDHW30gZvuelyEynEsrVivFw
 RVhuBQ4n
 taHVnRX5BMEsqHGTjvoGHKT0OansxRVNXvLcPkO9q00PgR6vctRamjAXWLSwEDcgzEqQUiBftu6XyWP76a4DHgG4xj2aDqIAfdQMlXIXK05/kY/uPG2pW7xNmRdL7sr4TnDo8w/9dJy5NsoA59hG8eSziUAcOK+QUsak2vyKQqdA1EQiPJ8Z3rPMGrc5T2Mj2ek5HK31TfR8wHGXlvS9vFHIc2bo4AEVhaW0RzsiYKc8RasRdcWd/vJt63zv0uH6a8jtjnTnpB8Fsury2q+ptLzR3pwl3X6HyV2TvbzRt9yM0bt3X+QwipRX/YNyNLIc8dwjgEivJjwPqhhTxJ+WgqryOXKVC51lckxqDe9xcPdPeD2fWTx8g2CvJ7JHiiewAEjWz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_restore_vmalloc() currently dereferences preservation before
checking for NULL, does not reject unknown KHO vmalloc flags in
kho_flags_to_vmalloc(), and does not validate preservation->first.phys,
preservation->total_pages, preservation->order, or potential size
overflow before allocating the pages array and shifting by order.

Introduce kho_vmalloc_validate() in kexec_handover_internal.h to
validate the struct kho_vmalloc header and convert its flags before
restoring the vmalloc area.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c          | 17 ++++++------
 kernel/liveupdate/kexec_handover_internal.h | 30 +++++++++++++++++++++
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index f427cdd9a969..a9c52d998855 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1384,28 +1384,27 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
  */
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 {
-	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
-	unsigned int align, order, shift, vm_flags;
-	unsigned long total_pages, contig_pages;
+	unsigned long total_pages, contig_pages, align, idx = 0;
+	unsigned int order, shift, vm_flags;
+	struct kho_vmalloc_chunk *chunk;
 	unsigned long addr, size;
 	struct vm_struct *area;
 	struct page **pages;
-	unsigned int idx = 0;
 	int err;
 
-	vm_flags = kho_flags_to_vmalloc(preservation->flags);
-	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+	if (!kho_vmalloc_validate(preservation, &vm_flags))
 		return NULL;
 
+	chunk = KHOSER_LOAD_PTR(preservation->first);
 	total_pages = preservation->total_pages;
 	pages = kvmalloc_objs(*pages, total_pages);
 	if (!pages)
 		return NULL;
 	order = preservation->order;
-	contig_pages = (1 << order);
+	contig_pages = 1UL << order;
 	shift = PAGE_SHIFT + order;
-	align = 1 << shift;
+	align = 1UL << shift;
 
 	while (chunk) {
 		struct page *page;
@@ -1420,7 +1419,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 			if (!page)
 				goto err_free_pages_array;
 
-			for (int j = 0; j < contig_pages; j++)
+			for (unsigned long j = 0; j < contig_pages; j++)
 				pages[idx++] = page + j;
 
 			phys += contig_pages * PAGE_SIZE;
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 094b4917a0f1..878e21bd8b00 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -7,6 +7,7 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/overflow.h>
 #include <linux/printk.h>
 #include <linux/types.h>
 #include <linux/unaligned.h>
@@ -23,6 +24,9 @@ static inline unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
 {
 	unsigned int vm_flags = 0;
 
+	if (kho_flags & ~(KHO_VMALLOC_ALLOC | KHO_VMALLOC_HUGE_VMAP))
+		return ~KHO_VMALLOC_SUPPORTED_FLAGS;
+
 	if (kho_flags & KHO_VMALLOC_ALLOC)
 		vm_flags |= VM_ALLOC;
 	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
@@ -31,6 +35,32 @@ static inline unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
 	return vm_flags;
 }
 
+static inline bool kho_vmalloc_validate(const struct kho_vmalloc *preservation,
+					unsigned int *vm_flags)
+{
+	size_t alloc_size;
+
+	if (!preservation || !preservation->first.phys ||
+	    !PAGE_ALIGNED(preservation->first.phys) ||
+	    !preservation->total_pages)
+		return false;
+
+	if (preservation->order >= BITS_PER_LONG - PAGE_SHIFT ||
+	    (1UL << preservation->order) > preservation->total_pages ||
+	    !IS_ALIGNED(preservation->total_pages, 1UL << preservation->order))
+		return false;
+
+	if (check_mul_overflow((size_t)preservation->total_pages, PAGE_SIZE,
+			       &alloc_size))
+		return false;
+
+	*vm_flags = kho_flags_to_vmalloc(preservation->flags);
+	if (*vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+		return false;
+
+	return true;
+}
+
 /**
  * kho_encode_radix_key - Encodes a physical address and order into a radix key.
  * @phys: The physical address of the page.
-- 
2.56.0.176.g3575e65682-goog


