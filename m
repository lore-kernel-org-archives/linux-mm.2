Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1534C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 01:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2AC86B0099; Fri, 26 Jun 2026 21:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02606B009D; Fri, 26 Jun 2026 21:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F1706B009E; Fri, 26 Jun 2026 21:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 560396B0099
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:22:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B669C1405E0
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:53 +0000 (UTC)
X-FDA: 84923943426.25.246F493
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id E1A42120002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Rt1bbRFH;
	spf=pass (imf29.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782523371;
	b=W6tE6YUHheZiq6iCvAg+LQ18MnEjGVtLMugrmaCrprNM1BhEXpnmmJcAQHjbfHMCrC/xIV
	fKohy0jrSteI1VEu/va06hhkx9rD7TcQ31cbXt0wqm+6JmJePG4e+qtKJTNshkTXo4Vtf/
	VmW29/ghmCbJ1LRNspQ4eSSEJHTq550=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782523371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWtCPDokU6T0UBPdQEQX6r6UHv8Bcq6A9irz995yEd8=;
	b=A/iz33Qe7Y8egCUar/RmykeXBQTXOjljnBc6WSRYj2XPa9ZmPgjzjFIONNidNgsIajB5ap
	itH24xD+AjYh2isWWloloPO7BzDJKtK9r2MBtaYNOimeNdly6uUTm3x2DPfyNjQn5SbKZS
	TOevYTprDdnd4n1udrGOpTW/1TWgWD4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Rt1bbRFH;
	spf=pass (imf29.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-139eee0707bso948607c88.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782523371; x=1783128171; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWtCPDokU6T0UBPdQEQX6r6UHv8Bcq6A9irz995yEd8=;
        b=Rt1bbRFHdF2cyi4qYKpcn3c2adaFuMmxIsdAHzjZGrjFhMguK0KngA/flcyqemmCbK
         zIhYy7wFsOhPxyh4P3NcH1nauGhcZ/6xDkta4Jk6ZolGufBYIcWtU95XpfSCcQK9gRLi
         bS+BAp1rhQCy3VUf6O31264pfBlC33rTLGCTrrs/DrETUTohpf5vVOe27Oes2EOI/WvA
         MdcIvmPW/P1LzVNd53UAkwR8anKOmH/fYSwOx4JZVH33zdGvIyjAt0ln4o2ylJDB4DVS
         w5E5cIjdha3XzZseSEZqrv7kr0rbvHmELQ90Ig7ocAlarLJgZW7Qgo7BIVsFh9sZodql
         2WjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782523371; x=1783128171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fWtCPDokU6T0UBPdQEQX6r6UHv8Bcq6A9irz995yEd8=;
        b=Em/J0SZ4+z97mlTRY0YPPGwFx1uwHw6SDrc0mVB03P08/l0JMvgGDxuAzNDbW+NOZ5
         3RYAUcabMQ7n94wcbeZ7b2af1bjvUV/qCjUWLOq+YzJXOtwlpIf6pWZ2eO00Ncls9Nd7
         tXiLBUepNCdydEqUs1zewYglQ9ZE5un/Crc+iPD9BSVQBh8l37KlHTKz70wbVkn1ZOpJ
         v0M3PjwpEw0aevkBn7d4PwLkhkrovNFZHCwNCFUvUpnTsTJkxgEQtuHLQ4UnTusR1nJc
         SUo10TASNpfgIL6T32WpJzezKMNspQAcFSGvXbnJcBVYxxs2cDJOZtwXvXAspn2/tOLp
         W3gQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq6vxH4YSvrUVrCh3d4U/ioKja7uIvY/LqqvyNqDFBy1J+OspyekwSnQIPo/j3IxyinxPrGvyFhJw==@kvack.org
X-Gm-Message-State: AOJu0YyFhoXG1MyowIU01ZwNMOi6S3pH64XGwcLOIfuDxQNA9XBwrCO7
	jiW3unS0OUDtbU6PcGuHsFMy6kNWYeI9NArw8fTSguaUc/NEN2XEm26LGMPh5A==
X-Gm-Gg: AfdE7cnOubk0sT03p6tV5pDZK/rYCSaG5iOmhv70OMDdOwRiFm9TWPogAf1NZ2pmn56
	UAZoVv08FoB38c6bGvb2H3Ctzj1PCiFrUXZqwxqFSq/cEmuWsVv23SQ2ThjeTgayCByvhJ9Ssvr
	u1DcppPNn94akiJfbrWsJh/CDgmAQJkROiQnkJTPLaTHevQnBzQd9NZBStUqRUCKOtCC/2p1I2Y
	DZZV0JJx/7ZqJ2IbWdeIali8DLjBU04MkXZzumhhFwBC3dHSXH0tWGDvfA7j/vtiB/75+pYG6z6
	ROGcCqE49xeaF7RBEyx8Gq8qBC1UtgCX4TVjExoFfv9O1q2JAe1tDYAQmD/wZfP3LadFZmtC1H2
	qQRuKMag0wFFribAU0Q4vLklSnMCCFklbDJ9hotdopnnd/Bhc5fXQlV1IXwj88Yd3xW56HH0uwv
	n82G0VJuR9iuibHOhGS+//235rbR97tgYTYUMuPYAkJsS+yfbz
X-Received: by 2002:a05:693c:3945:b0:304:e566:e000 with SMTP id 5a478bee46e88-30c850a8f7cmr9002834eec.31.1782523370484;
        Fri, 26 Jun 2026 18:22:50 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:fe0d:366d:f00:1840])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c9e9214sm22883437eec.20.2026.06.26.18.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 18:22:47 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v4 1/6] mm: add __do_mmap() and vm_mmap_seal_remote()
Date: Fri, 26 Jun 2026 18:22:14 -0700
Message-ID: <20260627012219.1079851-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
References: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j6sfrziynbw99r8soj3rmdp4n51i4d94
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1A42120002
X-HE-Tag: 1782523371-157173
X-HE-Meta: U2FsdGVkX18Ze3hYxQ89UK/+XbQyM803tnhFmBUs6in+yD1YhJ7UFIiEBpsLAlmV6WXPgLx9LjcrX+q8YQs1kgH+JHY5gyCN2RxMSlNL5aHjOj+Iz0T96rMev7c6k/xa2WdsXW5dI55QGYnB+tTecZeFGrQMCV8e0rVleK0J1DPJZ3sMbqVAIe2uM65yiZnJ0tEe4w860kcfnAWfkJ/tDmPP2O58O/2+gdCLYcdVLptcDi0yBPDgzO9NO9u5rZsA7iMU1aTewonySFJBz7KFAgp7XedUD5CapiEVlbMobb2izb52fxhisnEHLZZVgervlRO7ezE+2Y7BUSxiNRD3C1TUoOtr5OFp7tlOtqz7rvlAJd400jVMkzdQngahOTtmUu6WZwIs1H4JNJMkdjFNdwEMWjwZPFpysaGBc3lmGlRnFx19Rmwt0t09YlYq/wZGIffTONPUxbVCb/meKUGEV1fnVrzUhtDF8mFIJwgP1AQwNGivbe7TnIHKm0EyTlfTWZxA4+S5eW2mkG1LHHUlCEfJLanA+pvSGTYYj0A9QpQ3ddG7lJ7Z/c5WIKLxdxYWHojohwa63+FJjy/jG1nzSfZiczLN0yBq+nsjZ3RV6GYWlkmXSo8ibw8Qv/8q0Kr32FcBwxYFlD91tGiClr9LNBRJYDiiKv1pDEawouln6vjXXqHkm21Tn1/U+xuyFzvJxQyv3u40a5wLt1YR5aY0UMvCLYUL2SaLw9E1zeH7qg++LbMEn7tpD45LxbY3W4esdqKrjJkcL6ODiZULIMekehOrj0S2QMl6fEynXoPLsu5/G0KuWEjiW++4XVi3R91k+ahUC55V6GSFwErfsky1EIDgAY2L9AdePf4fqB1bZmXPH2tF9pKOLKUakRuqu4fVzveLUHXYqhQIAQNjzwGituq8lBs6lxK9c4Ca/yVunOJ5112SoskdIb/EcIfT+e705RPP/Dt94bhuyDgx/p8
 zl8x/mcV
 j+CetMNtSJ45s2SzXfNJNmdCW41s06J9fWUoDvFnApAK6frXjsNKN2L2gPO4RTkHI8sxrMLlszFKK1fALX+0Rvmp/sbPHNO2LNrCZ60aXFMr+XaMiI6rYzVSozUPEwlvPNxunvqhkhvLTGvjY/qkmalMgrvWRlBxt0ZHLcZR7ntJcNYaTqJ/4BJdmu7cuIA3HrSs++wg+0O7suAQyXs4FHJcbCcf/jGxx1WqfMnjDF/nVXP7eChGoYSHFyEDjkcQz5AiaXkn4AVght2c4R2JWzvD4DXoTGCWjdCVHX9r6sfcHaSnZ/3wygGojLY6vTJetf+Wv5fR4MqEwaUKN3WB+4cSbbLXZczIGL2T1gNueRaPFi3eNXVe3N10U0KUKTrmvwLE06mRJJ+dVCPCU/Cts00BT31HlQ6fB+rlsvUO0wcPStMbC0mqMUk4ran8XTwyH8dpWgMYsyb0DocsBBaoIO9vUFQ+rU+3Mt338OnbC6VLaWQjt87x6T+VUMSypNmm6/9nnlWXSw5J0ufWNQhxoXjI0/11+zJXBqqXJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add __do_mmap(), a variant of do_mmap() that installs the mapping into
a caller-supplied mm rather than current->mm. do_mmap() becomes a thin
wrapper that passes current->mm, so all existing callers and the public
do_mmap() signature are unchanged; the same split is applied in the
nommu do_mmap(). mmap_region()/__mmap_region() gain an mm argument
(their sole caller is __do_mmap()) so the target mm flows down to where
the VMA is inserted. __do_mmap() is mm-internal, declared in
mm/internal.h.

On top of that, add vm_mmap_seal_remote() in mm/util.c, a high-level
entry point that installs a mapping into a caller-specified mm. The
intended consumer is seccomp_unotify, where an unprivileged supervisor
needs to install a sealed pinned memfd region in a supervised task's
address space without target-side cooperation (the existing mseal-based
pinned-memfd flow only worked if the target installed its own mmap+mseal
during a trusted setup window, which is unavailable for fork+execve
sandbox wrappers).

LSM hooks (security_mmap_file, fsnotify_mmap_perm) run against
current, the supervisor installing the mapping, not the target
mm's owner. This matches the supervisor-installs-into-target
mental model and parallels pidfd_getfd()'s cross-task fd install.

Cross-task authorization is left to the caller; this primitive
performs no ptrace_may_access check. The seccomp consumer gates
on listener-fd ownership.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/mm.h |  3 +++
 mm/internal.h      |  8 ++++++
 mm/mmap.c          | 63 +++++++++++++++++++++++++++++++++++++++-------
 mm/nommu.c         | 12 ++++++++-
 mm/util.c          | 62 +++++++++++++++++++++++++++++++++++++++++++++
 mm/vma.c           | 35 ++++++++++++++------------
 mm/vma.h           |  6 ++---
 7 files changed, 160 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..73e5580442a6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4152,6 +4152,8 @@ extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
 	struct list_head *uf);
+unsigned long vm_mmap_seal_remote(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long pgoff);
 extern int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 			 unsigned long start, size_t len, struct list_head *uf,
 			 bool unlock);
@@ -4192,6 +4194,7 @@ struct vm_unmapped_area_info {
 	unsigned long align_mask;
 	unsigned long align_offset;
 	unsigned long start_gap;
+	struct mm_struct *mm;	/* mm to search; NULL means current->mm */
 };
 
 extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..3d698bccc100 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1436,6 +1436,14 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
+unsigned long __do_mmap(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long prot,
+	unsigned long flags, vm_flags_t vm_flags, unsigned long pgoff,
+	unsigned long *populate, struct list_head *uf);
+
+unsigned long mm_get_unmapped_area_remote(struct mm_struct *mm,
+					  unsigned long len);
+
 extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff4..4328dc21272d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -277,7 +277,7 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
 }
 
 /**
- * do_mmap() - Perform a userland memory mapping into the current process
+ * __do_mmap() - Perform a userland memory mapping into @mm's
  * address space of length @len with protection bits @prot, mmap flags @flags
  * (from which VMA flags will be inferred), and any additional VMA flags to
  * apply @vm_flags. If this is a file-backed mapping then the file is specified
@@ -307,8 +307,11 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
  * start of a VMA, rather only the start of a valid mapped range of length
  * @len bytes, rounded down to the nearest page size.
  *
- * The caller must write-lock current->mm->mmap_lock.
+ * The caller must write-lock @mm->mmap_lock. do_mmap() is the common
+ * wrapper that targets current->mm.
  *
+ * @mm: The mm_struct to install the mapping into. The caller must hold a
+ * reference and write-lock its mmap_lock.
  * @file: An optional struct file pointer describing the file which is to be
  * mapped, if a file-backed mapping.
  * @addr: If non-zero, hints at (or if @flags has MAP_FIXED set, specifies) the
@@ -333,13 +336,12 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
  * Returns: Either an error, or the address at which the requested mapping has
  * been performed.
  */
-unsigned long do_mmap(struct file *file, unsigned long addr,
-			unsigned long len, unsigned long prot,
-			unsigned long flags, vm_flags_t vm_flags,
-			unsigned long pgoff, unsigned long *populate,
-			struct list_head *uf)
+unsigned long __do_mmap(struct mm_struct *mm, struct file *file,
+			unsigned long addr, unsigned long len,
+			unsigned long prot, unsigned long flags,
+			vm_flags_t vm_flags, unsigned long pgoff,
+			unsigned long *populate, struct list_head *uf)
 {
-	struct mm_struct *mm = current->mm;
 	int pkey = 0;
 
 	*populate = 0;
@@ -557,7 +559,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			vm_flags |= VM_NORESERVE;
 	}
 
-	addr = mmap_region(file, addr, len, vm_flags, pgoff, uf);
+	addr = mmap_region(mm, file, addr, len, vm_flags, pgoff, uf);
 	if (!IS_ERR_VALUE(addr) &&
 	    ((vm_flags & VM_LOCKED) ||
 	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
@@ -565,6 +567,15 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 	return addr;
 }
 
+unsigned long do_mmap(struct file *file, unsigned long addr, unsigned long len,
+		      unsigned long prot, unsigned long flags,
+		      vm_flags_t vm_flags, unsigned long pgoff,
+		      unsigned long *populate, struct list_head *uf)
+{
+	return __do_mmap(current->mm, file, addr, len, prot, flags,
+			     vm_flags, pgoff, populate, uf);
+}
+
 unsigned long ksys_mmap_pgoff(unsigned long addr, unsigned long len,
 			      unsigned long prot, unsigned long flags,
 			      unsigned long fd, unsigned long pgoff)
@@ -809,6 +820,40 @@ unsigned long mm_get_unmapped_area_vmflags(struct file *filp, unsigned long addr
 	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
 }
 
+/*
+ * Find a free @len-byte area in @mm, honoring @mm's mmap layout direction.
+ * Unlike the arch_get_unmapped_area() family, the search runs against @mm
+ * rather than current->mm, so a supervisor can place a mapping in a remote
+ * task's address space (see vm_mmap_seal_remote()). The caller must hold
+ * mmap_write_lock(@mm). Returns a page-aligned address or -ENOMEM.
+ */
+unsigned long mm_get_unmapped_area_remote(struct mm_struct *mm, unsigned long len)
+{
+	struct vm_unmapped_area_info info = {
+		.length = len,
+		.mm = mm,
+	};
+	unsigned long addr;
+
+	if (mm_flags_test(MMF_TOPDOWN, mm)) {
+		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+		info.low_limit = PAGE_SIZE;
+		info.high_limit = arch_get_mmap_base(0, mm->mmap_base);
+		addr = vm_unmapped_area(&info);
+		if (!offset_in_page(addr))
+			return addr;
+		/* Topdown exhausted (e.g. huge stack rlimit); retry bottom-up. */
+		info.flags = 0;
+		info.low_limit = TASK_UNMAPPED_BASE;
+		info.high_limit = arch_get_mmap_end(0, len, 0);
+		return vm_unmapped_area(&info);
+	}
+
+	info.low_limit = mm->mmap_base;
+	info.high_limit = arch_get_mmap_end(0, len, 0);
+	return vm_unmapped_area(&info);
+}
+
 unsigned long
 __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..7f2136129c72 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1009,7 +1009,8 @@ static int do_mmap_private(struct vm_area_struct *vma,
 /*
  * handle mapping creation for uClinux
  */
-unsigned long do_mmap(struct file *file,
+unsigned long __do_mmap(struct mm_struct *mm,
+			struct file *file,
 			unsigned long addr,
 			unsigned long len,
 			unsigned long prot,
@@ -1246,6 +1247,15 @@ unsigned long do_mmap(struct file *file,
 	return -ENOMEM;
 }
 
+unsigned long do_mmap(struct file *file, unsigned long addr, unsigned long len,
+		      unsigned long prot, unsigned long flags,
+		      vm_flags_t vm_flags, unsigned long pgoff,
+		      unsigned long *populate, struct list_head *uf)
+{
+	return __do_mmap(current->mm, file, addr, len, prot, flags,
+			     vm_flags, pgoff, populate, uf);
+}
+
 unsigned long ksys_mmap_pgoff(unsigned long addr, unsigned long len,
 			      unsigned long prot, unsigned long flags,
 			      unsigned long fd, unsigned long pgoff)
diff --git a/mm/util.c b/mm/util.c
index af2c2103f0d9..21568dd0e9f8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -588,6 +588,68 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	return ret;
 }
 
+/**
+ * vm_mmap_seal_remote - install a sealed MAP_SHARED file mapping into @mm,
+ * without target-side cooperation.
+ * @mm: Target mm; caller holds a reference (e.g. get_task_mm()).
+ * @file: Backing file.
+ * @addr: Page-aligned address. If non-zero, MAP_FIXED_NOREPLACE is used
+ *        (-EEXIST if occupied); if zero, the kernel chooses a free area in
+ *        @mm and returns it.
+ * @len: Length in bytes (page-aligned).
+ * @pgoff: Page offset into @file.
+ *
+ * The mapping is read-only. The VMA is created VM_SEALED, so it is immediately
+ * immutable against the target mm's owner and its CLONE_VM peers. LSM/fsnotify
+ * hooks run against %current; cross-task authorization is the caller's
+ * responsibility (no ptrace_may_access check).
+ *
+ * Returns the mapped address on success, or a negative errno.
+ */
+unsigned long vm_mmap_seal_remote(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long pgoff)
+{
+	const unsigned long prot = PROT_READ;
+	const unsigned long flags = MAP_SHARED | MAP_FIXED_NOREPLACE;
+	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
+	unsigned long ret;
+	unsigned long populate;
+	LIST_HEAD(uf);
+
+	if (WARN_ON_ONCE(!mm))
+		return -EINVAL;
+	if (!VM_SEALED)		/* sealing unavailable (e.g. !CONFIG_64BIT) */
+		return -EOPNOTSUPP;
+
+	ret = security_mmap_file(file, prot, flags);
+	if (!ret)
+		ret = fsnotify_mmap_perm(file, prot, off, len);
+	if (ret)
+		return ret;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
+	if (!addr) {
+		addr = mm_get_unmapped_area_remote(mm, PAGE_ALIGN(len));
+		if (IS_ERR_VALUE(addr)) {
+			ret = addr;
+			goto unlock;
+		}
+	}
+	ret = __do_mmap(mm, file, addr, len, prot, flags, VM_SEALED,
+			pgoff, &populate, &uf);
+	/*
+	 * Do not mm_populate() against a foreign mm; the target task will
+	 * fault pages in on first access.
+	 */
+unlock:
+	mmap_write_unlock(mm);
+	userfaultfd_unmap_complete(mm, &uf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vm_mmap_seal_remote);
+
 /*
  * Perform a userland memory mapping into the current process address space. See
  * the comment for do_mmap() for more details on this operation in general.
diff --git a/mm/vma.c b/mm/vma.c
index 9eea2850818a..2f9159ab5123 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2731,11 +2731,10 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 	return false;
 }
 
-static unsigned long __mmap_region(struct file *file, unsigned long addr,
-		unsigned long len, vma_flags_t vma_flags,
+static unsigned long __mmap_region(struct mm_struct *mm, struct file *file,
+		unsigned long addr, unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
 	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
@@ -2809,14 +2808,16 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 
 /**
  * mmap_region() - Actually perform the userland mapping of a VMA into
- * current->mm with known, aligned and overflow-checked @addr and @len, and
+ * @mm with known, aligned and overflow-checked @addr and @len, and
  * correctly determined VMA flags @vm_flags and page offset @pgoff.
  *
  * This is an internal memory management function, and should not be used
  * directly.
  *
- * The caller must write-lock current->mm->mmap_lock.
+ * The caller must write-lock @mm->mmap_lock.
  *
+ * @mm: The mm_struct to install the mapping into. The caller must hold a
+ * reference and write-lock its mmap_lock.
  * @file: If a file-backed mapping, a pointer to the struct file describing the
  * file to be mapped, otherwise NULL.
  * @addr: The page-aligned address at which to perform the mapping.
@@ -2830,15 +2831,16 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
  * Returns: Either an error, or the address at which the requested mapping has
  * been performed.
  */
-unsigned long mmap_region(struct file *file, unsigned long addr,
-			  unsigned long len, vm_flags_t vm_flags,
-			  unsigned long pgoff, struct list_head *uf)
+unsigned long mmap_region(struct mm_struct *mm, struct file *file,
+			  unsigned long addr, unsigned long len,
+			  vm_flags_t vm_flags, unsigned long pgoff,
+			  struct list_head *uf)
 {
 	unsigned long ret;
 	bool writable_file_mapping = false;
 	const vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
 
-	mmap_assert_write_locked(current->mm);
+	mmap_assert_write_locked(mm);
 
 	/* Check to see if MDWE is applicable. */
 	if (map_deny_write_exec(&vma_flags, &vma_flags))
@@ -2857,13 +2859,13 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		writable_file_mapping = true;
 	}
 
-	ret = __mmap_region(file, addr, len, vma_flags, pgoff, uf);
+	ret = __mmap_region(mm, file, addr, len, vma_flags, pgoff, uf);
 
 	/* Clear our write mapping regardless of error. */
 	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
 
-	validate_mm(current->mm);
+	validate_mm(mm);
 	return ret;
 }
 
@@ -2957,8 +2959,8 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 /**
  * unmapped_area() - Find an area between the low_limit and the high_limit with
- * the correct alignment and offset, all from @info. Note: current->mm is used
- * for the search.
+ * the correct alignment and offset, all from @info. Note: @info->mm (or
+ * current->mm when it is NULL) is used for the search.
  *
  * @info: The unmapped area information including the range [low_limit -
  * high_limit), the alignment offset and mask.
@@ -2970,7 +2972,7 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 	unsigned long length, gap;
 	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
+	VMA_ITERATOR(vmi, info->mm ? : current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask + info->start_gap;
@@ -3016,7 +3018,8 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 /**
  * unmapped_area_topdown() - Find an area between the low_limit and the
  * high_limit with the correct alignment and offset at the highest available
- * address, all from @info. Note: current->mm is used for the search.
+ * address, all from @info. Note: @info->mm (or current->mm when it is NULL)
+ * is used for the search.
  *
  * @info: The unmapped area information including the range [low_limit -
  * high_limit), the alignment offset and mask.
@@ -3028,7 +3031,7 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	unsigned long length, gap, gap_end;
 	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
+	VMA_ITERATOR(vmi, info->mm ? : current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask + info->start_gap;
diff --git a/mm/vma.h b/mm/vma.h
index 8e4b61a7304c..4f5222ad2e9d 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -459,9 +459,9 @@ bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 int mm_take_all_locks(struct mm_struct *mm);
 void mm_drop_all_locks(struct mm_struct *mm);
 
-unsigned long mmap_region(struct file *file, unsigned long addr,
-		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
-		struct list_head *uf);
+unsigned long mmap_region(struct mm_struct *mm, struct file *file,
+		unsigned long addr, unsigned long len, vm_flags_t vm_flags,
+		unsigned long pgoff, struct list_head *uf);
 
 int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		 unsigned long addr, unsigned long request,

base-commit: ab9de95c9cf952332ab79453b4b5d1bfca8e514f
-- 
2.43.0


