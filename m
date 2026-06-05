Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 598FDCD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02306B0095; Thu,  4 Jun 2026 23:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD96D6B0096; Thu,  4 Jun 2026 23:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8026B0098; Thu,  4 Jun 2026 23:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABCA6B0095
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:33:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EE35163FDA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:15 +0000 (UTC)
X-FDA: 84844438350.09.203FACB
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78F1E14000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KV3DrsNp;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gH8mRD7OHBJqm1quLMa7hgev2fQ64GiB6Pr4Gxty2sM=;
	b=zw7j5vEfrQR12eF7dN2Il0Zc3v+Mp3NlbhVquOfKdrIX6ho91qhCO6RjbZ9CWZz4kwVmTV
	oad/zIW7K5woQJF9OmQqI5SsUUjrLRfa9vRpQPINL7u4EF3YsQK2ciQYENcNGIYcpki5kS
	Y12OEzMmKYoUj5aML2WIscVmLKoT54Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KV3DrsNp;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630393;
	b=p7NM0g/PirR4tQ87ogXNz7kUden3aM48Rhj7WhUlCFggVa4u9YRifQtNnJwXKKAvvytSvM
	hXA+CUVIN9FIqnIvJ2RZjDEev1g9zIOGR2yle2TF4OYV+KBtFO9eIgGcZtInBaFABTpI+U
	1ZQUM6FdX5Qbgn0idUOvfNG+AZk3TyY=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5176d4c14f5so12044521cf.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630393; x=1781235193; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gH8mRD7OHBJqm1quLMa7hgev2fQ64GiB6Pr4Gxty2sM=;
        b=KV3DrsNpkQYGgyauGY37rx9+aw6p9/Lkpaox29FSoKw37YJY6DwsmL5XuSn4tJvlnH
         rv/MunyyuGAI9jgXNSO6dE2Ub0iRyps65ympI7UgMxI0qaVpLaLa0wW715112z4NKoLk
         uoidSu8Wsi7K1qDSpKG0szr+yj2195uXaBq/vDsN++6tvGjFeDRppQMSv9TrRTsXuiRQ
         Jrz945SzFZayqCJz6yTh+2os8AY0DEdksoQ8FlCGVFnMPnIelX8Gq8a0Bck8D9g6cB01
         DYZ1QSvOGQ7u2PlRTpvIGlZxevBwXWGCTx2OGYCeWBjXWYO+SEGl3myUzvLKa6Ky2Dby
         Vvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630393; x=1781235193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gH8mRD7OHBJqm1quLMa7hgev2fQ64GiB6Pr4Gxty2sM=;
        b=sBwbfrUI8I46djy2nqcd3unQq3HZATNaxI47B1VFfsjRbSiYoLzbhODaRDAjO9OBud
         gnvGrTuZKfoOWP9EAfVwW8dO4j/zBmbvdh12TqkJGMXJtWSTMM2QFudzUWXgAAn2rWN3
         /m+tiVvKTmgM8C7ADdGaO+sGWmWI9hwf3AKDztJQw1YEFLcg3bclDXQwk5s76TlGbpQN
         M4lMgbo/9E2JEylBCLFpS/oBwhsyNjprzej2lgXP2e7Fc2ke87rwHy48BaBkZu4b6dcu
         TX99R4U9ur1IbWQIXWCms8GtRRaTXQ/w4t5zUbKkCIjlAvmM3v6Jjn8frn+HqXiMhYoE
         x0ww==
X-Forwarded-Encrypted: i=1; AFNElJ/onjIFzjt4p6zjcgR/Zw/1n/iwXplKegq6vPHWkYMjf5fbcpuxeOk+EszwQg0u+YxO3cdq9o8LBg==@kvack.org
X-Gm-Message-State: AOJu0YwIBwiq1x8NJMkQV320LXq3891E68EbsnZb4kbFZ/dGvytMAK0J
	IFxRQVG150YLtRHyQeKmiacSAgEmhrYqz61Dlk0N2MjiJcoi2ktofPzRbukKMXGblFQ=
X-Gm-Gg: Acq92OGtqVaxwZdhrCDf5jGZBLFVdsVyRhDrlFc+EkN2DBXY2gwNadJPfgEc7c6Fd0u
	p36oeT7IwGDVExZtje+Sn/SvDUYaLCTge+DpVGlQYzW4QonrXCWtHJ3QRakYpzBrtVjpBWzo16Z
	ED0YKOfYPMpeXgY1TwbmF7NpL2Rqgesm21CzE5gISQzTlGlus4IJ2q6gHGKvy6sBJmyW/4HB4OJ
	aE4iD/6auD5H9VRVnqYfDtGTUr7/uBKIvEroWfDP8IKOEA6d8oVeXSFjZC8joN/OEka/YHN3m12
	vt45wu6/SiE9oBr5xDLyFl80ZqbluCgIAEVpvCyKMsCprR++wKVQonYGuq3Lz6gqNGynmtLuMVj
	Iw0KvTMABW51j/wK1KDes1/mn1HX/icdijVo1mH6UK95HMfJN9wvkhg+L3l70Fg+hJglILp29D1
	rTtApSMmRoTOpeMllrjPtrzja+QctZWLVxh7lTB4aTwv8ziJinfpwmbPA819hufw==
X-Received: by 2002:a05:622a:4390:b0:517:7b11:70ea with SMTP id d75a77b69052e-51795bbf9bbmr20136841cf.31.1780630392493;
        Thu, 04 Jun 2026 20:33:12 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775dcf367sm70258631cf.25.2026.06.04.20.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:33:12 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 3/9] kho: split out vmalloc preservation into kho_vmalloc.c
Date: Fri,  5 Jun 2026 03:32:29 +0000
Message-ID: <20260605033235.717351-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 78F1E14000A
X-Stat-Signature: fayywwnddjaxrby1sd1g5k4dbs6s73et
X-Rspam-User: 
X-HE-Tag: 1780630393-323667
X-HE-Meta: U2FsdGVkX1+ohi2ks7DdHECCoq5a/d/lzIlalWuBgLBX9erCvpqvoZw8vhLv09Zwp8Hmko/tN+BM4CK+q6liUGSeGXOaAiPXsG1TbLZoX4NNbn2X/UmavC6v/oYyLDGUfCgbqW9HeWuDrV4S14El3sz05oEyI6w5ntvbRLyWmwqiQl4JlE3RTu+JY9cR76fdEHw/D1wXQMCzgp3lDKTr9Q2CqIaqEZwbo7TE9RyiTbfAK2KgdeYKs061m3tRsaREfAyFzdKlDZElyVeWf/2SgNcJZwTF91gqvhtKOLo5g9w7TIXqpMPAdtA5nw8DYbY5GZs0NvHQjPZbtXR64lkcfBJxPwVWQX0lZNesVr6yD3VKK39OCE8UHInqne6dxNrIOb3/Ex1bkM9lvui7LD21AVAGFdgKVq3T5VmG2tOJzFcm0BSqhtjLIqcoOa35rjbpjPKI3DLgNBElwBayTPYOeDPpTGv7Gpe2oiNliJls7aLiSa+ySC3wWw9di0SqParejGSkdzc6wsmXyZHAPHgV+pWGhl9LpDMxYd3r2cm4YicQC/o3YAYE67v/PJU/fhXqwO3TCLqNn6EXwHXFY3VEsJx/EXXzz9QoELX7ot7QsXO45qzVYPkwCDWy/X8LJI0MVTy8Qsyr9P4A3dWycet3tEJ0jlLHZmzr25jiv4Zs9RrCTg5ITMIRAlNxFgelKea4GFV/xYbMphVXgkmamYE8jsGRLpgwBvtEA2EoiFq6cQoLcEtbN60wdn/BfLB54jhQF1ffFloxbg038MWTtAK7K7aaniAeu/d7LD0sXMog5CCjBCS1TIRsFHpGCt4TZaPAxYFGhPgmjKQejwfJZdmiLeDRfcq9qUg3CJ9dwvJzU635yWqcGHW2TTVNBwGO3eBGVSC9b3S7LSLM0LkXz2Iu7ZddVjvhUnUIci8SRhPSyh4yKEKxbhQ1KbFyHnCJpY/K1uRL4mycsoRiaJt/NVU
 aw2NFGXO
 0JQhaeqLhuwo4XmS617jepCWmBtfwdvRj3RKxSpf5sTBlfep6IfnYEUAhMczvdiyUs6lr76svP175Ec8Ufr9O7HRFCZiHgSYd55IQ/h/Q0rj5Yhk6eNlgohn5StNpVxQGw7+bzg6nYlQ9RRQGzE1jhSuBaJobHbpRtLTDuhMvKT/1020P2g0So5n+5uMofuhtlxhgJn8RIxM+mVAYI9uQ9sduapYCzI9+sPlUYNfTFE17I0GiCfi/dUD/IDuVH5MnDD9X6RVQLbVITF0U6oSeizH6QzKK2jEuz3nA0Drh6AwlPIo6fa9CZgrj0eoX4By+I7Dcvm2sOi67ANFsQDJEkphcRn+0M9ERD0J8ANd8/+6b9k1XZpWCnPcxJnf5CDXuCS8yZS3HKvNlb4pJc6b1bUzEz/2KszD9/+ZEruRhLar9TYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the vmalloc serialization and preservation implementation out of the
core KHO code into its own dedicated file (kho_vmalloc.c).

This is a pure code movement patch; no logic or functional changes are
introduced.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/kho/index.rst |   3 +
 kernel/liveupdate/Makefile           |   3 +-
 kernel/liveupdate/kexec_handover.c   | 258 +------------------------
 kernel/liveupdate/kho_vmalloc.c      | 274 +++++++++++++++++++++++++++
 lib/test_kho.c                       |   1 +
 mm/memfd_luo.c                       |   1 +
 6 files changed, 282 insertions(+), 258 deletions(-)
 create mode 100644 kernel/liveupdate/kho_vmalloc.c

diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index f69367d217cf..a10b10700fb9 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -86,6 +86,9 @@ Public API
 .. kernel-doc:: kernel/liveupdate/kho_radix.c
   :export:
 
+.. kernel-doc:: kernel/liveupdate/kho_vmalloc.c
+  :export:
+
 KHO Serialization Blocks API
 ============================
 
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index a3ee8a5c27a2..b481e21a311a 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -9,7 +9,8 @@ luo-y :=								\
 
 kho-y :=								\
 		kexec_handover.o					\
-		kho_radix.o
+		kho_radix.o						\
+		kho_vmalloc.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kho.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4a3d6a54a17f..6672bc168e57 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -13,7 +13,6 @@
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
-#include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/radix_tree.h>
@@ -23,11 +22,7 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
-#include <linux/page-isolation.h>
 #include <linux/unaligned.h>
-#include <linux/vmalloc.h>
-
-#include <asm/early_ioremap.h>
 
 /*
  * KHO is tightly coupled with mm init and needs access to some of mm
@@ -84,6 +79,7 @@ static struct kho_out kho_out = {
 };
 
 
+
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
@@ -702,259 +698,7 @@ void kho_unpreserve_pages(struct page *page, unsigned long nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 
-/* vmalloc flags KHO supports */
-#define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
-
-/* KHO internal flags for vmalloc preservations */
-#define KHO_VMALLOC_ALLOC	0x0001
-#define KHO_VMALLOC_HUGE_VMAP	0x0002
-
-static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
-{
-	unsigned short kho_flags = 0;
-
-	if (vm_flags & VM_ALLOC)
-		kho_flags |= KHO_VMALLOC_ALLOC;
-	if (vm_flags & VM_ALLOW_HUGE_VMAP)
-		kho_flags |= KHO_VMALLOC_HUGE_VMAP;
-
-	return kho_flags;
-}
-
-static unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
-{
-	unsigned int vm_flags = 0;
-
-	if (kho_flags & KHO_VMALLOC_ALLOC)
-		vm_flags |= VM_ALLOC;
-	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
-		vm_flags |= VM_ALLOW_HUGE_VMAP;
-
-	return vm_flags;
-}
-
-static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
-{
-	struct kho_vmalloc_chunk *chunk;
-	int err;
-
-	chunk = (struct kho_vmalloc_chunk *)get_zeroed_page(GFP_KERNEL);
-	if (!chunk)
-		return NULL;
-
-	err = kho_preserve_pages(virt_to_page(chunk), 1);
-	if (err)
-		goto err_free;
-	if (cur)
-		KHOSER_STORE_PTR(cur->hdr.next, chunk);
-	return chunk;
-
-err_free:
-	free_page((unsigned long)chunk);
-	return NULL;
-}
-
-static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
-					 unsigned short order)
-{
-	struct kho_radix_tree *tree = &kho_out.radix_tree;
-	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
-
-	__kho_unpreserve(tree, pfn, pfn + 1);
-
-	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
-		pfn = PHYS_PFN(chunk->phys[i]);
-		__kho_unpreserve(tree, pfn, pfn + (1 << order));
-	}
-}
-
-/**
- * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
- * @ptr: pointer to the area in vmalloc address space
- * @preservation: placeholder for preservation metadata
- *
- * Instructs KHO to preserve the area in vmalloc address space at @ptr. The
- * physical pages mapped at @ptr will be preserved and on successful return
- * @preservation will hold the physical address of a structure that describes
- * the preservation.
- *
- * NOTE: The memory allocated with vmalloc_node() variants cannot be reliably
- * restored on the same node
- *
- * Return: 0 on success, error code on failure
- */
-int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
-{
-	struct kho_vmalloc_chunk *chunk;
-	struct vm_struct *vm = find_vm_area(ptr);
-	unsigned int order, flags, nr_contig_pages;
-	unsigned int idx = 0;
-	int err;
-
-	if (!vm)
-		return -EINVAL;
-
-	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
-		return -EOPNOTSUPP;
-
-	flags = vmalloc_flags_to_kho(vm->flags);
-	order = get_vm_area_page_order(vm);
-
-	chunk = new_vmalloc_chunk(NULL);
-	if (!chunk)
-		return -ENOMEM;
-	KHOSER_STORE_PTR(preservation->first, chunk);
-
-	nr_contig_pages = (1 << order);
-	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
-		phys_addr_t phys = page_to_phys(vm->pages[i]);
-
-		err = kho_preserve_pages(vm->pages[i], nr_contig_pages);
-		if (err)
-			goto err_free;
-
-		chunk->phys[idx++] = phys;
-		if (idx == ARRAY_SIZE(chunk->phys)) {
-			chunk = new_vmalloc_chunk(chunk);
-			if (!chunk) {
-				err = -ENOMEM;
-				goto err_free;
-			}
-			idx = 0;
-		}
-	}
-
-	preservation->total_pages = vm->nr_pages;
-	preservation->flags = flags;
-	preservation->order = order;
-
-	return 0;
-
-err_free:
-	kho_unpreserve_vmalloc(preservation);
-	return err;
-}
-EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
-
-/**
- * kho_unpreserve_vmalloc - unpreserve memory allocated with vmalloc()
- * @preservation: preservation metadata returned by kho_preserve_vmalloc()
- *
- * Instructs KHO to unpreserve the area in vmalloc address space that was
- * previously preserved with kho_preserve_vmalloc().
- */
-void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
-{
-	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
-
-	while (chunk) {
-		struct kho_vmalloc_chunk *tmp = chunk;
-
-		kho_vmalloc_unpreserve_chunk(chunk, preservation->order);
-
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		free_page((unsigned long)tmp);
-	}
-}
-EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
-
-/**
- * kho_restore_vmalloc - recreates and populates an area in vmalloc address
- * space from the preserved memory.
- * @preservation: preservation metadata.
- *
- * Recreates an area in vmalloc address space and populates it with memory that
- * was preserved using kho_preserve_vmalloc().
- *
- * Return: pointer to the area in the vmalloc address space, NULL on failure.
- */
-void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
-{
-	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
-	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
-	unsigned int align, order, shift, vm_flags;
-	unsigned long total_pages, contig_pages;
-	unsigned long addr, size;
-	struct vm_struct *area;
-	struct page **pages;
-	unsigned int idx = 0;
-	int err;
-
-	vm_flags = kho_flags_to_vmalloc(preservation->flags);
-	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
-		return NULL;
-
-	total_pages = preservation->total_pages;
-	pages = kvmalloc_objs(*pages, total_pages);
-	if (!pages)
-		return NULL;
-	order = preservation->order;
-	contig_pages = (1 << order);
-	shift = PAGE_SHIFT + order;
-	align = 1 << shift;
-
-	while (chunk) {
-		struct page *page;
-
-		for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
-			phys_addr_t phys = chunk->phys[i];
-
-			if (idx + contig_pages > total_pages)
-				goto err_free_pages_array;
-
-			page = kho_restore_pages(phys, contig_pages);
-			if (!page)
-				goto err_free_pages_array;
-
-			for (int j = 0; j < contig_pages; j++)
-				pages[idx++] = page + j;
-
-			phys += contig_pages * PAGE_SIZE;
-		}
-
-		page = kho_restore_pages(virt_to_phys(chunk), 1);
-		if (!page)
-			goto err_free_pages_array;
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		__free_page(page);
-	}
-
-	if (idx != total_pages)
-		goto err_free_pages_array;
-
-	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
-				  vm_flags | VM_UNINITIALIZED,
-				  VMALLOC_START, VMALLOC_END,
-				  NUMA_NO_NODE, GFP_KERNEL,
-				  __builtin_return_address(0));
-	if (!area)
-		goto err_free_pages_array;
-
-	addr = (unsigned long)area->addr;
-	size = get_vm_area_size(area);
-	err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
-	if (err)
-		goto err_free_vm_area;
 
-	area->nr_pages = total_pages;
-	area->pages = pages;
-
-	if (vm_flags & VM_ALLOC)
-		kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
-
-	area->addr = kasan_unpoison_vmalloc(area->addr, total_pages * PAGE_SIZE,
-					    kasan_flags);
-	clear_vm_uninitialized_flag(area);
-
-	return area->addr;
-
-err_free_vm_area:
-	free_vm_area(area);
-err_free_pages_array:
-	kvfree(pages);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
 /**
  * kho_alloc_preserve - Allocate, zero, and preserve memory.
diff --git a/kernel/liveupdate/kho_vmalloc.c b/kernel/liveupdate/kho_vmalloc.c
new file mode 100644
index 000000000000..84c17b7a81ae
--- /dev/null
+++ b/kernel/liveupdate/kho_vmalloc.c
@@ -0,0 +1,274 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kho_vmalloc.c - KHO vmalloc space serialization/preservation
+ * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
+ * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/io.h>
+#include <linux/kasan.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+
+#include "../../mm/internal.h"
+#include "kexec_handover_internal.h"
+
+/* vmalloc flags KHO supports */
+#define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
+
+/* KHO internal flags for vmalloc preservations */
+#define KHO_VMALLOC_ALLOC	0x0001
+#define KHO_VMALLOC_HUGE_VMAP	0x0002
+
+static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
+{
+	unsigned short kho_flags = 0;
+
+	if (vm_flags & VM_ALLOC)
+		kho_flags |= KHO_VMALLOC_ALLOC;
+	if (vm_flags & VM_ALLOW_HUGE_VMAP)
+		kho_flags |= KHO_VMALLOC_HUGE_VMAP;
+
+	return kho_flags;
+}
+
+static unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
+{
+	unsigned int vm_flags = 0;
+
+	if (kho_flags & KHO_VMALLOC_ALLOC)
+		vm_flags |= VM_ALLOC;
+	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
+	return vm_flags;
+}
+
+static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
+{
+	struct kho_vmalloc_chunk *chunk;
+	int err;
+
+	chunk = (struct kho_vmalloc_chunk *)get_zeroed_page(GFP_KERNEL);
+	if (!chunk)
+		return NULL;
+
+	err = kho_preserve_pages(virt_to_page(chunk), 1);
+	if (err)
+		goto err_free;
+	if (cur)
+		KHOSER_STORE_PTR(cur->hdr.next, chunk);
+	return chunk;
+
+err_free:
+	free_page((unsigned long)chunk);
+	return NULL;
+}
+
+static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
+					 unsigned short order)
+{
+	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
+
+	kho_unpreserve_pages(pfn_to_page(pfn), 1);
+
+	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
+		pfn = PHYS_PFN(chunk->phys[i]);
+		kho_unpreserve_pages(pfn_to_page(pfn), 1 << order);
+	}
+}
+
+/**
+ * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
+ * @ptr: pointer to the area in vmalloc address space
+ * @preservation: placeholder for preservation metadata
+ *
+ * Instructs KHO to preserve the area in vmalloc address space at @ptr. The
+ * physical pages mapped at @ptr will be preserved and on successful return
+ * @preservation will hold the physical address of a structure that describes
+ * the preservation.
+ *
+ * NOTE: The memory allocated with vmalloc_node() variants cannot be reliably
+ * restored on the same node
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
+{
+	struct kho_vmalloc_chunk *chunk;
+	struct vm_struct *vm = find_vm_area(ptr);
+	unsigned int order, flags, nr_contig_pages;
+	unsigned int idx = 0;
+	int err;
+
+	if (!vm)
+		return -EINVAL;
+
+	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+		return -EOPNOTSUPP;
+
+	flags = vmalloc_flags_to_kho(vm->flags);
+	order = get_vm_area_page_order(vm);
+
+	chunk = new_vmalloc_chunk(NULL);
+	if (!chunk)
+		return -ENOMEM;
+	KHOSER_STORE_PTR(preservation->first, chunk);
+
+	nr_contig_pages = (1 << order);
+	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
+		phys_addr_t phys = page_to_phys(vm->pages[i]);
+
+		err = kho_preserve_pages(vm->pages[i], nr_contig_pages);
+		if (err)
+			goto err_free;
+
+		chunk->phys[idx++] = phys;
+		if (idx == ARRAY_SIZE(chunk->phys)) {
+			chunk = new_vmalloc_chunk(chunk);
+			if (!chunk) {
+				err = -ENOMEM;
+				goto err_free;
+			}
+			idx = 0;
+		}
+	}
+
+	preservation->total_pages = vm->nr_pages;
+	preservation->flags = flags;
+	preservation->order = order;
+
+	return 0;
+
+err_free:
+	kho_unpreserve_vmalloc(preservation);
+	return err;
+}
+EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
+
+/**
+ * kho_unpreserve_vmalloc - unpreserve memory allocated with vmalloc()
+ * @preservation: preservation metadata returned by kho_preserve_vmalloc()
+ *
+ * Instructs KHO to unpreserve the area in vmalloc address space that was
+ * previously preserved with kho_preserve_vmalloc().
+ */
+void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
+{
+	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+
+	while (chunk) {
+		struct kho_vmalloc_chunk *tmp = chunk;
+
+		kho_vmalloc_unpreserve_chunk(chunk, preservation->order);
+
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		free_page((unsigned long)tmp);
+	}
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
+
+/**
+ * kho_restore_vmalloc - recreates and populates an area in vmalloc address
+ * space from the preserved memory.
+ * @preservation: preservation metadata.
+ *
+ * Recreates an area in vmalloc address space and populates it with memory that
+ * was preserved using kho_preserve_vmalloc().
+ *
+ * Return: pointer to the area in the vmalloc address space, NULL on failure.
+ */
+void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+{
+	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
+	unsigned int align, order, shift, vm_flags;
+	unsigned long total_pages, contig_pages;
+	unsigned long addr, size;
+	struct vm_struct *area;
+	struct page **pages;
+	unsigned int idx = 0;
+	int err;
+
+	vm_flags = kho_flags_to_vmalloc(preservation->flags);
+	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+		return NULL;
+
+	total_pages = preservation->total_pages;
+	pages = kvmalloc_objs(*pages, total_pages);
+	if (!pages)
+		return NULL;
+	order = preservation->order;
+	contig_pages = (1 << order);
+	shift = PAGE_SHIFT + order;
+	align = 1 << shift;
+
+	while (chunk) {
+		struct page *page;
+
+		for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
+			phys_addr_t phys = chunk->phys[i];
+
+			if (idx + contig_pages > total_pages)
+				goto err_free_pages_array;
+
+			page = kho_restore_pages(phys, contig_pages);
+			if (!page)
+				goto err_free_pages_array;
+
+			for (int j = 0; j < contig_pages; j++)
+				pages[idx++] = page + j;
+
+			phys += contig_pages * PAGE_SIZE;
+		}
+
+		page = kho_restore_pages(virt_to_phys(chunk), 1);
+		if (!page)
+			goto err_free_pages_array;
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		__free_page(page);
+	}
+
+	if (idx != total_pages)
+		goto err_free_pages_array;
+
+	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
+				  vm_flags | VM_UNINITIALIZED,
+				  VMALLOC_START, VMALLOC_END,
+				  NUMA_NO_NODE, GFP_KERNEL,
+				  __builtin_return_address(0));
+	if (!area)
+		goto err_free_pages_array;
+
+	addr = (unsigned long)area->addr;
+	size = get_vm_area_size(area);
+	err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
+	if (err)
+		goto err_free_vm_area;
+
+	area->nr_pages = total_pages;
+	area->pages = pages;
+
+	if (vm_flags & VM_ALLOC)
+		kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
+
+	area->addr = kasan_unpoison_vmalloc(area->addr, total_pages * PAGE_SIZE,
+					    kasan_flags);
+	clear_vm_uninitialized_flag(area);
+
+	return area->addr;
+
+err_free_vm_area:
+	free_vm_area(area);
+err_free_pages_array:
+	kvfree(pages);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
diff --git a/lib/test_kho.c b/lib/test_kho.c
index aa6a0956bb8b..6907e09688dd 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/vmalloc.h>
 
 #include <net/checksum.h>
 
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..ade2aa24c7b8 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -76,6 +76,7 @@
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/memfd.h>
+#include <linux/kho/vmalloc.h>
 #include <linux/liveupdate.h>
 #include <linux/shmem_fs.h>
 #include <linux/vmalloc.h>
-- 
2.53.0


