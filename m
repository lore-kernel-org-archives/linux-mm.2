Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E03C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFAE6B03C1; Thu, 13 Aug 2026 02:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1456B03C3; Thu, 13 Aug 2026 02:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641F96B03C4; Thu, 13 Aug 2026 02:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8986B03C1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:34:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3315A053C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:13 +0000 (UTC)
X-FDA: 85095281586.20.9AF8D69
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id DE6BB40007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J1CpVwiS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786602851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VydE882aeZh4C0XeyZVTmtWlDmuPadzLk+Mgv6C7/A=;
	b=c/8HJyZnfHBCv5OXIw21TCNXtPK1D4ecqnPVtoC0zMolni/VKwoqsTDqF5SB4vgA6XL/zY
	F45XPoPkRB8XbHsqJAQ9wf7Qeu3+beBSDNyKCpW39mw73HwKh1OTNjQGKmQuHMi61DXZ/E
	JPubUd2Htdj69wvh5iigwtj/QU5WvSw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J1CpVwiS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786602851;
	b=tdeBxrFQ+sRHjdBhwVr3sbymSeZVe52rJHx3Bsw/pUQckckk+1oAJuihOnD8jivkIj3WpC
	vZ9GritfksRJut63JZUxIv0feqOJ0zddDjAxSMqKe2oZqiexSIr1EeQtAPuLN0WwSBP8ie
	67z1wd1CAFcnOlU4P2EhtDnZqaGnqBc=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-382ef647e20so433066a91.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786602851; x=1787207651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7VydE882aeZh4C0XeyZVTmtWlDmuPadzLk+Mgv6C7/A=;
        b=J1CpVwiSeUCCRzNfUSXBY+sy+9Lf9p2T7YCMwH2FFrSEofEayu04Shk9aF17zWF5TN
         eN9R6zNpMTKyimtwiWnAH/gRVTf6ras4lXLlISSHdzQl1Z87evGvpSIiryGhHPh+Cwu4
         4cLWo2JBTAFxH8pKvL/0BokdEPhzXdAUuuOhOdMU9VFfG7nWTa52DONMCcoShpozcfMt
         IlEcVSppTu4JYT3vL0LeVhvLvYXLEgW/cPYhHa77Eef4R/RRo6YN578FZmTdieLhOGY7
         0cTmf36XTjaVYQR4rx9jnTB+Vxp2oq/qptSol2/bTbU7/9FG0AsXOhoVkCAwRY+bdyFc
         pqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786602851; x=1787207651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7VydE882aeZh4C0XeyZVTmtWlDmuPadzLk+Mgv6C7/A=;
        b=ef/zAS+P06ipWUySbpw0RV2q2zHv0c6dxtDquHNLwgJjrBw7VLMQv4IrarvwC1wAy9
         jHlXyQKHgKqzPsotMOi9nNf6VJ8CEYB62zMJHgYgnclEqlz6aYDakpzlgt2+FEAiBX6W
         4tNAq/8pP5lqxXdlmC25yJXyzX/+TZxmJRa7eIgVJMx/CwBfrgt5fjUffEsqD8Tz/0BM
         H0el9kWaXBeEAPuHscNdLRWO3SmW1r8GA3qRbyxNzbHwpOSYSLKCoGlfGrpq2/Y1ap+R
         s14wX6dL24LZ0SE4y83JAVBk6w0KqLGKd/hiEr03bad/AcHkNueVNjflKOXFn1Pyqgm1
         IdwQ==
X-Gm-Message-State: AOJu0YxTp94rL1PqwGKBxezBrNEoh/mH6OUR6OuIOE284F/lD/rXLcE+
	qAviYUnbxbW0sDyqdmQtJCpAeVsaXxE5FC52frDbNHG45Rd6mJyYGkWB
X-Gm-Gg: AR+sD13zmKGhL8HOYr3Py3l1pHZvxYrYiPAgtWSDrHYK4zXlsvb8zOcmI6Bv/JT7Owu
	slbPl5Ia5PURUi8UQ+Mkw/AyGPgMPmUUuerxsfm93GJcxzFsCn22IJ7rRV+gJgMXI9TbLNw1EKQ
	BeOxYwBF9pJNhq73iOC0jkIzNiq88MVWWF+y/KW+xOwSZIKxjUM4RGTxOFAs+D+kVWMUoJnzXz1
	+cw9yTrW7UN8V3apvz3oVXqhOV+BC/6Li8EJ18uoBxSDI9vYu3I4MzJRezo6gQumkskf0OXMk1b
	jvyYDW+p53B591R+UJKwdf9KW5JjF2Mp5VFtXIaHrTCiQSCtDmpnpXyxQPpcKGhQuqoCm50Pml4
	GSXtWh/TqA6SBhx5NSZMYgFa1OjT+SPQv8qxWCu2WHRUWca7HL+Yk+xcNXeaDc3NDF9mV+cvUUt
	Av+cilGvb9iPQNZftGxXhINoam+JhD1NYtxpGA3RTsp+9JGMhpJzaCKwP6Neu8/MZXe70NQbYM7
	sQ/b+6aPrs9+5cPwBi5W17IURPyp2V9HkbLcFxiCmcfd2DcRfwN9ZtT88wl+JnxgZFLfQP5+hMh
X-Received: by 2002:a17:90b:3c8d:b0:38f:de97:b06 with SMTP id 98e67ed59e1d1-3931e05c56dmr4216541a91.5.1786602850753;
        Wed, 12 Aug 2026 23:34:10 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931f41cd2fsm1576275a91.12.2026.08.12.23.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:34:10 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id E79AA15B042F; Thu, 13 Aug 2026 15:34:08 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to /dev/zero
Date: Thu, 13 Aug 2026 15:33:58 +0900
Message-ID: <20260813063401.1786548-4-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813063401.1786548-1-thehajime@gmail.com>
References: <20260813063401.1786548-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE6BB40007
X-Stat-Signature: mxg87p8yfaa3m9q5jpg4frwrfjsiwfky
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786602851-98221
X-HE-Meta: U2FsdGVkX1/u5hQugNoGQ3vqZ0wCRY1TYM/gLZrOsyVlFOi5kt2WrBvNBAISI6xuIdUZ1uIFJJvl9vRlyb0GRt8JbherrQ9UPUukT0LGXM8SGPsA3qoI5/HiRrDm1PKEIj1JEKBgeO8rPGPsm5PMbt1z3kgPRJ3LMronqzjeIw1LKvOQmdv/4/NtwNwn2LPtBqlwFbOyFIaU3fqxfrc7ktuqtPfkVwZFLDEFka/HOuMe7C5f5UvH4Xu/jGM+p5ZDe4y9ngB+fvQZAufOejvluxWLmFS4dpdgGg40HH3tPAw54AJ4SAHIsB2HF/JS0rn3unL9OFSCUvbcOi311cKXXb7fZ0qc4m6P9rFN7tfwsQGtz1SnicmyLD3T9+aw71vnwrMkdRPrTuRbLoRziuH2K5/R3kFEH5McU9U8uZAPEeKU3XzdsOsRqM4FLO9KtsKjuC/e8GxM8nILP7Klryldy7AsmeIfKeaIE6ZZQI0k8po3oovlpAJL9l8bBtMs6PWr0HQjdK5OacBr6CKgAOHuqndyMLb4qUvT0PLv64H1P8MbdJaBnPi3k0rNZdsdyRVDP64hvteiwMob8Ep89yIKqWONtRxvJ80tx7vvO4X9+9Zo322xMKN4pLr2t+NSL0Tw18pDG8zKsxpJBonOYk9zGTtCPwMxOL28ifdqPsjH9W7sjMCUGUtVFsTGfWDK4mdkOY8apTo1JKdoNbzTCJAQ96y85Ea3ai54zM6+U3yY2n+G2dFipZuUr+K7PwShpNe+7vytNtgW9YjMtdtIdwzkP5hR22s3vCKWsakY1EUwZ8qFH1V+jjl674iECnlMZV9VGtjUuG5ZdouVicO8ILVamjZa/wdSliPZv7vTXO6QpiutBqPOGY9clsspCpKd9CodGfNTUDx537ALZmYJGwFcnw33z1txKpq7vxxXsC/SY/Aae54A3xGJJpYAZ4svIcFCA0dsMsuKiEdPFvr100Z
 lPB9L1V0
 ZLsq7mmOYDpplKIkOXzenGCHtJhshPsQnbG/pqk7W3vJYO7ol2Q/HlvY4WeZbZgdjjhJerEb78UWvTG3wUYJNSvke8XfjozAOYc568ugNXx5Q5BtR+drerE+S0hg2k62zbvak9HMkPs2Vg+Nkcq8jz1Fvehibbi3oJVBcEnx0LAu2ERSbEqr+Nh96o+9FZFBjfNHvb+m9Z8L40Hw7Lfe87hdiQ3nnXkvG9Sd/mfNUbKIhCuk+B6jbbrKWgr+e69OSURnEKauKVULqNx9aIQFIPzV1N+GyN0BYVd8SWq5Yq6Y2vr0dh7CA7bOfS/USq7VvG05zO/62WgDBF4kgwKHa3+sMgtW30wG/tjPe/MH3BAqJ9FsPpW0hZeIYTzpwVk+ykBjsS860IV6U/He+QEv/hrxWfWAoEMzy10MHB3ehkOTUr41vz2sUgIkdrUG7Y4dBHg2zAk/4uIiyshlm+dyBdoDG4Odd2DQ1lg6B/lQPshGn3dARjby+m1KusxDvcn8btdI4MwF3A2PWl7iVa/w1A3C4mnX5evsA5VYtSl+dxWVdaGq5FIJakSpr+Ax5vcNiu1xc4U0Kmarkpi/mBFsxlmCDLcQhR9eToMAkXpRZZ4wtJEHRQdy6uUuhSQcNmItuLmnF6CY+1Luo9hf2Ps77M0/prQZxYaF+rjADU+TU/e6MmPWHyFO91LS7KzSFmVPBedmh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upon a private file mapping request to /dev/zero, it calls
kernel_read() in do_mmap_private(), getting a failure with the message
like: "kernel reads not supported for file /dev/zero", which is because
zero_fops defined in drivers/char/mem.c has both .read and .read_iter
definitions.

Even fixing this issue, the map request to /dev/zero works fine without
errors but the allocated vma isn't marked with anonymous because
mmap_zero_prepare() isn't called under nommu platform, resulting
vma_desc_set_anonymous() isn't called either.

This commit fixes those issues by:
1) use vfs_iter_read() instead to avoid failure at kernel_read()
2) calls .mmap_prepare on private mapping in do_mmap() so that required
   preparations are done even in private mapping.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org (open list:PAGE CACHE)
Fixes: 4d03e3cc5982 ("fs: don't allow kernel reads and writes without iter ops")
Assisted-by: cubic.dev:unspecified
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 drivers/char/mem.c |  5 ++-
 mm/filemap.c       |  6 ++--
 mm/nommu.c         | 84 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 87 insertions(+), 8 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 63253d1de5d7..dba24d0a7b33 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -500,11 +500,10 @@ static ssize_t read_zero(struct file *file, char __user *buf,
 
 static int mmap_zero_prepare(struct vm_area_desc *desc)
 {
-#ifndef CONFIG_MMU
-	return -ENOSYS;
-#endif
+#ifdef CONFIG_MMU
 	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
+#endif
 
 	/*
 	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
diff --git a/mm/filemap.c b/mm/filemap.c
index d721986d5f46..cf02faad86aa 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4077,7 +4077,7 @@ int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
 }
 int generic_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	return -ENOSYS;
+	return 0;
 }
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
@@ -4085,7 +4085,9 @@ int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 }
 int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
 {
-	return -ENOSYS;
+	if (is_shared_maywrite(&desc->vma_flags))
+		return -EINVAL;
+	return generic_file_mmap_prepare(desc);
 }
 #endif /* CONFIG_MMU */
 
diff --git a/mm/nommu.c b/mm/nommu.c
index e40990e15831..a29a53c1c80a 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -37,6 +37,7 @@
 
 #include <linux/uaccess.h>
 #include <linux/uio.h>
+#include <linux/major.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -856,6 +857,22 @@ static int validate_mmap_request(struct file *file,
 	return 0;
 }
 
+static int is_file_anonymous(struct file *file)
+{
+	if (!file)
+		return 1;
+
+	if (file->f_path.dentry && file->f_path.dentry->d_inode) {
+		struct inode *inode = file->f_path.dentry->d_inode;
+		/* if the device is /dev/zero */
+		if (S_ISCHR(inode->i_mode) &&
+		    imajor(inode) == MEM_MAJOR && iminor(inode) == 5)
+			return 1;
+	}
+
+	return 0;
+}
+
 /*
  * we've determined that we can make the mapping, now translate what we
  * now know into VMA flags
@@ -869,7 +886,11 @@ static vm_flags_t determine_vm_flags(struct file *file,
 
 	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
 
-	if (!file) {
+	/* private and file mapping will be marked anonymous later (do_mmap_private()).
+	 * and /dev/zero is marked by them at .mmap_prepare,
+	 * which should be _before_ this point.
+	 */
+	if (is_file_anonymous(file)) {
 		/*
 		 * MAP_ANONYMOUS. MAP_SHARED is mapped to MAP_PRIVATE, because
 		 * there is no fork().
@@ -923,6 +944,29 @@ static int do_mmap_shared_file(struct vm_area_struct *vma)
 	return -ENODEV;
 }
 
+static ssize_t nommu_read_iter(struct file *file, void *buf,
+			       size_t count, loff_t *pos)
+{
+	struct iov_iter iter;
+	ssize_t ret;
+	size_t done = 0;
+
+	while (done < count) {
+		struct kvec iov = {
+			.iov_base = buf + done,
+			.iov_len = min_t(size_t, count - done, MAX_RW_COUNT),
+		};
+
+		iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
+		ret = vfs_iter_read(file, &iter, pos, 0);
+		if (ret <= 0)
+			return done ? done : ret;
+		done += ret;
+	}
+
+	return done;
+}
+
 /*
  * set up a private mapping or an anonymous shared mapping
  */
@@ -993,7 +1037,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
 		fpos = vma->vm_pgoff;
 		fpos <<= PAGE_SHIFT;
 
-		ret = kernel_read(vma->vm_file, base, len, &fpos);
+		ret = nommu_read_iter(vma->vm_file, base, len, &fpos);
 		if (ret < 0)
 			goto error_free;
 
@@ -1080,6 +1124,28 @@ unsigned long do_mmap(struct file *file,
 		vma->vm_file = get_file(file);
 	}
 
+	/* call mmap_prepare function if any */
+	if (!(flags & MAP_SHARED) && !(capabilities & NOMMU_MAP_DIRECT) &&
+	    (vma->vm_file && vma->vm_file->f_op->mmap_prepare)) {
+		struct vm_area_desc desc;
+
+		vma->vm_start = addr;
+		vma->vm_end = addr + len;
+
+		compat_set_desc_from_vma(&desc, vma->vm_file, vma);
+		ret = vma->vm_file->f_op->mmap_prepare(&desc);
+		/* private ramfs/romfs mappings fails with -ENOSYS so,
+		 * fall back to copied mapping.
+		 */
+		if (ret && ret != -ENOSYS)
+			goto error_mmap_prepare;
+
+		ret = __compat_vma_mmap(&desc, vma);
+		if (ret)
+			goto error_mmap_prepare;
+	}
+
+
 	down_write(&nommu_region_sem);
 
 	/* if we want to share, we need to check for regions created by other
@@ -1196,7 +1262,7 @@ unsigned long do_mmap(struct file *file,
 	add_nommu_region(region);
 
 	/* clear anonymous mappings that don't ask for uninitialized data */
-	if (vma_is_anonymous(vma) &&
+	if (is_file_anonymous(vma->vm_file) &&
 	    (!IS_ENABLED(CONFIG_MMAP_ALLOW_UNINITIALIZED) ||
 	     !(flags & MAP_UNINITIALIZED)))
 		memset((void *)region->vm_start, 0,
@@ -1247,6 +1313,18 @@ unsigned long do_mmap(struct file *file,
 	ret = -EINVAL;
 	goto error;
 
+error_mmap_prepare:
+	if (region->vm_file)
+		fput(region->vm_file);
+	kmem_cache_free(vm_region_jar, region);
+	if (vma->vm_file)
+		fput(vma->vm_file);
+	vm_area_free(vma);
+
+	pr_warn("mmap_prepare failed for %lu byte allocation from process %d\n",
+			len, current->pid);
+	return ret;
+
 error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
 	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
-- 
2.43.0


