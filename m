Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6378C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747976B0095; Wed, 15 Jul 2026 17:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E876B0096; Wed, 15 Jul 2026 17:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571196B0098; Wed, 15 Jul 2026 17:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F25EB6B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:20:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4DCE3A02ED
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:40 +0000 (UTC)
X-FDA: 84992280240.27.2D63BAA
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2621214000E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fd6pBvyG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e43R4xaFHGGewoyIAXRGUwlW5zXEdJcZOJjfptEDTYE=;
	b=pQ5fsYes/4BFFgkXWICgsHcKUrDCxGJwUaQRKyuEqrzngVc6hh1RlNYiPfJSfOmlKcCpW5
	OlS1AiLULj5lDtJCYlIoTVhyoCXOZ1IgvJjASg4fDnUWl2h0m1SYnSNqvMiFBw0IUWh3sV
	tLFpa1qCOE4700Q+kA95r3ltwNAPZWU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fd6pBvyG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150438;
	b=WvbaVz3297DOgHUuBswomFKUvUvYlkkaWkvN72QEm5cs/Q0TViRlV7umCUpVUp6gwbNvlH
	ta2p7MSuoDTE8HBQTi5FBx5Y4zdc2yJeTUDcd5dcZsJVqqgyDSjeEavoJz75UeYho9+XEg
	UE0uraNZxyZPXPuiCT4X5aGyHZeRBsU=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c9c26a5fb98so1697041a12.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784150437; x=1784755237; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e43R4xaFHGGewoyIAXRGUwlW5zXEdJcZOJjfptEDTYE=;
        b=Fd6pBvyGiU95jPqbKmiy8/QUqu7DCCEc68pod5agiDvXEGa3+aqKU8h7nKFkofz/GD
         eHbMbNQZ6u1nfeWtAk+vgZdzlzQwBr12Z/4Q1+Eq6EOZk0hm8vcIu1Rka3tvZEY42tqh
         aVVJmEICLqKUveKn0D4T7lD3DAJFhE0Y5OLeqvYuc5hvgp9KNmgoBVRpF6ZZdLV44B2M
         0eqi65ahGZO+x0ho37R8al1VUK8d+jXMEJGA52DBp4xFGZuY7uN84ix9e7is+fbbRnGs
         JoklK6BKIStLJJCI2HhtFF/S6n1RU7ib6Um+aCFFfYpimbc3DpP0xSlE0KccvkojKUHg
         VTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784150437; x=1784755237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e43R4xaFHGGewoyIAXRGUwlW5zXEdJcZOJjfptEDTYE=;
        b=UzHjsWXlClChctHbbm3OLaQV3G4zP5tuE2qnklkRASwAG6ia9KV8CJqIZIq997Lpv8
         sB8l+7HwV5zEmAYLPjcYU1WaqP8Ik0xSujOi0YDZCUeGuwOUfnU2UeBY89ecimWTrckU
         TYZNG5K7GOOoW+yysfggNohGCkxDO6QwlWR5naekugx4p2P+6kWGA39bEeFyBfTzgZ3G
         oJtgaF9BlGguVbz18dEn53t0doiH9Xl30x+7tzfile5CTsRVZYP9+AhOsiYHMa7qMMik
         0z+TWKcaYZ1shd41LwY2tWJWDKSsjOolpm02FIyBcVNkP1zAfxUzhNRAFIW5glwLbawP
         zJ6Q==
X-Forwarded-Encrypted: i=1; AHgh+RpMnirNxtGHGZerbsBHwRRTihuTsQTQOcrTtNt/gf4ncx6UlOSTzYT6lvYzC5heuNI9o0JM8EZ8bg==@kvack.org
X-Gm-Message-State: AOJu0Yz9Lb7L1IPSI05PfhBYKE5V4iwyoG1dLbzji+MnaRKac43vt1mJ
	UrvmEiHN8N+JL66W4dMOCXNv8ungP0ny0C4DynS7JzNpDAhySd85CoxA
X-Gm-Gg: AfdE7cn/8+QD4ofzJPQzWrxY59q/LdtHfk7yXziCX2TsD7bbyzVkNxBcm8j0O/FRsC+
	MJyeGATRLpmg7pM/Fsd8qdztMDCc9RlyId82qMz9XDZzk2VDl+x0gmFgFiVvT+wiV1HY2GSUC86
	fkvLVRhIczImBv5MdT6XeEtBUvDlSFyuzQBaRkwAzwHvLcLbFgxgvI2HVFprTBaPKRXyU+m4gYP
	HK6KpJqvmQND5Y0iZuhP1dzHVqvoV5k96iUnFL0mKLhstK+EfKzRzPQmTKyarvIuh24PFBhFOZ+
	+yClZf503olBpP6KlYn+dT5pZgxghRL3Tfi14tyZ0N1wN59gdXdYxZe2yj8JKstzlMYNpDgm9b2
	lC5H72mWNsIMMZ9K6kDkQG0nVOzh1njHDPWemayzb9aVbtBEP0axeETWgkPzKhSxfZ/L1CqOiGr
	TRFBza45PKxFhv1f/9sYZP5DRvmfP6Hn5hkbRV9b6qSt2arZYCT/HamPCv2A==
X-Received: by 2002:a05:6a21:389:b0:3c3:750f:3cf9 with SMTP id adf61e73a8af0-3c384a8f977mr1117970637.11.1784150436129;
        Wed, 15 Jul 2026 14:20:36 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([129.210.115.107])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd403a7f7sm4126844c88.0.2026.07.15.14.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:20:35 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v6 1/8] mm: pass the target mm parameter through get_unmapped_area family
Date: Wed, 15 Jul 2026 14:20:00 -0700
Message-ID: <20260715212007.2382846-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
References: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1f5jxhz6cqyrqjisjuqh8wdanzyj8rko
X-Rspamd-Queue-Id: 2621214000E
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784150437-37662
X-HE-Meta: U2FsdGVkX1/oIhHBHilkAPDdBmd5r1KSXjf6qNgl19NxQo7akkfYwXUB/GHFlg4R8WszzomeJyFd+6LHMnP5ufXH37Ju3xiMuGW2O2DWFaNA4xXL+4LOU58p6XeZKH3VjxgXE9Vh6fTQlxOjsRVijuLVBbOR96TOglo7YpIJaSeJrz+q5A4jGXrpugni1101EPaSr7+D3nRvJsEt++Wn3U4oQLqKbkt5R/JMt0mNNMSRy/QYE9v6Q0tZsT9qaeQwdpeJ+nZObkCOiuEVAXcGHx10Q2fKHjotQGdEe+jjGJnsFAeRZoD+Fdbe7GgC6TOPpdB4fTxbVDgXvql/EV1lyTMP/vsLQqINzbsXZe3eObhAbzv0Jo3iO11Fr5VOXorlqW6S238f3EWQkeWRstCjagLGxCKt5QylZE/Ah6d1Ol6bpd3m3gCNDvrBbQVEgrumHi9Td2SNC/ZatbubL/rxAJ87hoJiMIj/rDfQLdMkRTslATkXtcLfuUYRe5t+nCb99fdh9GjwgKXzsLdAEHai1XXc+FTopZCw2ibA1lRF3khol5Op+FXI1B2SPpJktep0mniBWs0SCYmAHO85hfmrwlXZuHgXu8vX6yrL30MsgkjVsym8JhlPFlVwRTgCVPA1yXsQI1g2AmhFmLeHdfY3YjFLw0P2eyEfT143ZWUQ3bC2oO5v8UGo2V1TgE+/GCTThFb8rxdx8Z0AVOB0jGF0GAOLSgsI+r1v23B2VbXH9mr/+DX9N41+Y+nIrNUsbu2B7tevpYX3BliMDb79gGmanVZwbz/BeHOe9K8w/+ANag4h8RYqsk34SWddwAGKxBv3FRIRRyn5ZgUvzb1ZlT9A5V484ucesgvXc74U79ItsATB6hEzNQqbQjsnTxrniZVuM2A0MqVWx3ZGDY6Abj33Fv+uyu5xt5+wrKzzx1zIYu4Dosx/5tKH7YbU4zr3XWz54sE635QRXURyO1qAGv6
 Aa8ge+t6
 hOreSH9lH0CVinmZAYL/kEv1JHRoQLXhaqt86J/5HZ0eRpAPVXinZWTQTU7gsoGgO+Ojg4lv3CO+WUrYhNZcvvO6wKmUoGEFXgEQ5LggvSWAkStWRoOIcFk2Nb+tDbJHS6sCNGM8bxqcfJM4FPGZWC2YcsDLzmTjGFf+ZkbewfsAnZuBnQvGnzRc9pQaZeSLvTtTxvuMFU3r78xQGbUMCE5Sk96BG1bU+EuYPeAU9UVuGP5QDlHIKBKIfC2FM/SO3Ul7I+kFzYpzpnuLviAm0LEoPwKovOScPzYKNkhKTBIfFY0MgiPtbCHTStxGn810GBheN+2phty1PU05j5bmWCJ3lmXIaGn3OI+nsLGp4kvFDv0hk0LgxdbeLpvO9kUjyOtMIurG29r9eyowE4/Q+KPMWD4442HMLw2lNix70LQ980ZZjFd3ZxjVXDoQlU/A2DVNHCODsd0c2W18KG118v+Rd7DREK5gY67UzUO3vuBwQWzAtetl7kFazNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Every placement callback in the mmap path implicitly resolves against
current->mm, so a placement cannot be computed in another task's address
space. vm_mmap_remote() in the next patch needs this: without it a remote
install cannot run the file's own ->get_unmapped_area() and file-specific
placement rules are bypassed or rejected at MAP_FIXED validation.

Make the mm an explicit first parameter of the get_unmapped_area family
across the entire tree. It is difficult and not elegant to avoid such a
big change.

The get_unmapped_area() convenience inline keeps its old signature and
passes current->mm, so ordinary callers do not change. So no functional
change.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 Documentation/filesystems/locking.rst      |  2 +-
 Documentation/filesystems/vfs.rst          |  2 +-
 arch/alpha/kernel/osf_sys.c                | 21 +++---
 arch/arc/mm/mmap.c                         |  7 +-
 arch/arm/mm/mmap.c                         | 19 +++--
 arch/csky/abiv1/mmap.c                     |  7 +-
 arch/loongarch/mm/mmap.c                   | 28 ++++----
 arch/mips/mm/mmap.c                        | 28 ++++----
 arch/parisc/kernel/sys_parisc.c            | 28 ++++----
 arch/powerpc/include/asm/book3s/64/slice.h |  3 +-
 arch/powerpc/mm/book3s64/slice.c           | 28 ++++----
 arch/s390/mm/mmap.c                        | 25 ++++---
 arch/sh/mm/mmap.c                          | 21 +++---
 arch/sparc/include/asm/pgtable_64.h        |  6 +-
 arch/sparc/kernel/sys_sparc_32.c           |  7 +-
 arch/sparc/kernel/sys_sparc_64.c           | 32 +++++----
 arch/x86/include/asm/elf.h                 |  2 +-
 arch/x86/kernel/cpu/sgx/driver.c           | 13 ++--
 arch/x86/kernel/sys_x86_64.c               | 32 +++++----
 arch/x86/kernel/uprobes.c                  |  4 +-
 arch/x86/mm/mmap.c                         |  4 +-
 arch/xtensa/kernel/syscall.c               |  8 +--
 drivers/char/mem.c                         | 15 ++--
 drivers/dax/device.c                       | 11 +--
 drivers/gpu/drm/drm_gem.c                  |  9 ++-
 drivers/gpu/drm/drm_gem_dma_helper.c       |  4 +-
 drivers/media/v4l2-core/v4l2-dev.c         |  3 +-
 drivers/mtd/mtdchar.c                      |  3 +-
 drivers/video/fbdev/core/fb_chrdev.c       |  3 +-
 fs/cramfs/inode.c                          |  3 +-
 fs/hugetlbfs/inode.c                       |  9 +--
 fs/proc/inode.c                            | 15 ++--
 fs/ramfs/file-mmu.c                        |  5 +-
 fs/ramfs/file-nommu.c                      |  6 +-
 fs/romfs/mmap-nommu.c                      |  3 +-
 include/drm/drm_gem.h                      |  3 +-
 include/drm/drm_gem_dma_helper.h           |  3 +-
 include/linux/bpf.h                        |  3 +-
 include/linux/fs.h                         |  5 +-
 include/linux/huge_mm.h                    | 18 ++---
 include/linux/hugetlb.h                    |  6 +-
 include/linux/mm.h                         | 12 ++--
 include/linux/proc_fs.h                    |  5 +-
 include/linux/sched/mm.h                   | 37 +++++-----
 include/linux/shmem_fs.h                   |  5 +-
 io_uring/memmap.c                          |  8 ++-
 io_uring/memmap.h                          |  3 +-
 ipc/shm.c                                  |  8 +--
 kernel/bpf/arena.c                         |  5 +-
 kernel/bpf/syscall.c                       |  8 ++-
 mm/huge_memory.c                           | 27 +++----
 mm/mmap.c                                  | 83 ++++++++++++----------
 mm/nommu.c                                 |  5 +-
 mm/shmem.c                                 | 13 ++--
 mm/vma.c                                   | 16 +++--
 mm/vma.h                                   |  6 +-
 sound/core/pcm_native.c                    |  3 +-
 57 files changed, 391 insertions(+), 307 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 08d01bc62c31..b5defd74e302 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -471,7 +471,7 @@ prototypes::
 	int (*fsync) (struct file *, loff_t start, loff_t end, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long,
+	unsigned long (*get_unmapped_area)(struct mm_struct *, struct file *, unsigned long,
 			unsigned long, unsigned long, unsigned long);
 	int (*check_flags)(int);
 	int (*flock) (struct file *, int, struct file_lock *);
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 7c753148af88..4f95a272eab8 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1023,7 +1023,7 @@ This describes how the VFS can manipulate an open file.  As of kernel
 		int (*fsync) (struct file *, loff_t, loff_t, int datasync);
 		int (*fasync) (int, struct file *, int);
 		int (*lock) (struct file *, int, struct file_lock *);
-		unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+		unsigned long (*get_unmapped_area)(struct mm_struct *, struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 		int (*check_flags)(int);
 		int (*flock) (struct file *, int, struct file_lock *);
 		ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 7b6543d2cca3..80ae6d03e266 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1201,21 +1201,22 @@ SYSCALL_DEFINE1(old_adjtimex, struct timex32 __user *, txc_p)
 /* Get an address range which is currently unmapped. */
 
 static unsigned long
-arch_get_unmapped_area_1(unsigned long addr, unsigned long len,
-		         unsigned long limit)
+arch_get_unmapped_area_1(struct mm_struct *mm, unsigned long addr,
+			 unsigned long len, unsigned long limit)
 {
 	struct vm_unmapped_area_info info = {};
 
 	info.length = len;
 	info.low_limit = addr;
 	info.high_limit = limit;
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
 unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		       unsigned long len, unsigned long pgoff,
-		       unsigned long flags, vm_flags_t vm_flags)
+arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		       unsigned long addr, unsigned long len,
+		       unsigned long pgoff, unsigned long flags,
+		       vm_flags_t vm_flags)
 {
 	unsigned long limit = TASK_SIZE;
 
@@ -1236,19 +1237,19 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	   this feature should be incorporated into all ports?  */
 
 	if (addr) {
-		addr = arch_get_unmapped_area_1 (PAGE_ALIGN(addr), len, limit);
+		addr = arch_get_unmapped_area_1(mm, PAGE_ALIGN(addr), len, limit);
 		if (addr != (unsigned long) -ENOMEM)
 			return addr;
 	}
 
 	/* Next, try allocating at TASK_UNMAPPED_BASE.  */
-	addr = arch_get_unmapped_area_1 (PAGE_ALIGN(TASK_UNMAPPED_BASE),
-					 len, limit);
+	addr = arch_get_unmapped_area_1(mm, PAGE_ALIGN(TASK_UNMAPPED_BASE),
+					len, limit);
 	if (addr != (unsigned long) -ENOMEM)
 		return addr;
 
 	/* Finally, try allocating in low memory.  */
-	addr = arch_get_unmapped_area_1 (PAGE_SIZE, len, limit);
+	addr = arch_get_unmapped_area_1(mm, PAGE_SIZE, len, limit);
 
 	return addr;
 }
diff --git a/arch/arc/mm/mmap.c b/arch/arc/mm/mmap.c
index 2185afe8d59f..d33d5443b616 100644
--- a/arch/arc/mm/mmap.c
+++ b/arch/arc/mm/mmap.c
@@ -22,11 +22,10 @@
  * SHMLBA bytes.
  */
 unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff,
+arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags, vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct vm_unmapped_area_info info = {};
 
@@ -56,7 +55,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
 	info.align_offset = pgoff << PAGE_SHIFT;
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
 static const pgprot_t protection_map[16] = {
diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 3dbb383c26d5..5d1169539ce3 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -27,11 +27,10 @@
  * in the VIVT case, we optimise out the alignment rules.
  */
 unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff,
+arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags, vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int do_align = 0;
 	int aliasing = cache_is_vipt_aliasing();
@@ -74,16 +73,16 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.high_limit = TASK_SIZE;
 	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
 unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
-		        const unsigned long len, const unsigned long pgoff,
-		        const unsigned long flags, vm_flags_t vm_flags)
+arch_get_unmapped_area_topdown(struct mm_struct *mm, struct file *filp,
+		const unsigned long addr0, const unsigned long len,
+		const unsigned long pgoff, const unsigned long flags,
+		vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
 	int do_align = 0;
 	int aliasing = cache_is_vipt_aliasing();
@@ -125,7 +124,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	info.high_limit = mm->mmap_base;
 	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
-	addr = vm_unmapped_area(&info);
+	addr = vm_unmapped_area(mm, &info);
 
 	/*
 	 * A failed mmap() very likely causes application failure,
@@ -138,7 +137,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		info.flags = 0;
 		info.low_limit = mm->mmap_base;
 		info.high_limit = TASK_SIZE;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 	}
 
 	return addr;
diff --git a/arch/csky/abiv1/mmap.c b/arch/csky/abiv1/mmap.c
index 1047865e82a9..62eaca7a0d50 100644
--- a/arch/csky/abiv1/mmap.c
+++ b/arch/csky/abiv1/mmap.c
@@ -22,11 +22,10 @@
  * We unconditionally provide this function for all cases.
  */
 unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff,
+arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags, vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int do_align = 0;
 	struct vm_unmapped_area_info info = {
@@ -68,5 +67,5 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	}
 
 	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
diff --git a/arch/loongarch/mm/mmap.c b/arch/loongarch/mm/mmap.c
index 1df9e99582cc..600943121362 100644
--- a/arch/loongarch/mm/mmap.c
+++ b/arch/loongarch/mm/mmap.c
@@ -18,11 +18,11 @@
 
 enum mmap_allocation_direction {UP, DOWN};
 
-static unsigned long arch_get_unmapped_area_common(struct file *filp,
-	unsigned long addr0, unsigned long len, unsigned long pgoff,
-	unsigned long flags, enum mmap_allocation_direction dir)
+static unsigned long arch_get_unmapped_area_common(struct mm_struct *mm,
+	struct file *filp, unsigned long addr0, unsigned long len,
+	unsigned long pgoff, unsigned long flags,
+	enum mmap_allocation_direction dir)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long addr = addr0;
 	int do_color_align;
@@ -74,7 +74,7 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 		info.low_limit = PAGE_SIZE;
 		info.high_limit = mm->mmap_base;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 
 		if (!(addr & ~PAGE_MASK))
 			return addr;
@@ -89,14 +89,14 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr0,
-	unsigned long len, unsigned long pgoff, unsigned long flags,
-	vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+	unsigned long addr0, unsigned long len, unsigned long pgoff,
+	unsigned long flags, vm_flags_t vm_flags)
 {
-	return arch_get_unmapped_area_common(filp,
+	return arch_get_unmapped_area_common(mm, filp,
 			addr0, len, pgoff, flags, UP);
 }
 
@@ -104,11 +104,11 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr0,
  * There is no need to export this but sched.h declares the function as
  * extern so making it static here results in an error.
  */
-unsigned long arch_get_unmapped_area_topdown(struct file *filp,
-	unsigned long addr0, unsigned long len, unsigned long pgoff,
-	unsigned long flags, vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area_topdown(struct mm_struct *mm,
+	struct file *filp, unsigned long addr0, unsigned long len,
+	unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
-	return arch_get_unmapped_area_common(filp,
+	return arch_get_unmapped_area_common(mm, filp,
 			addr0, len, pgoff, flags, DOWN);
 }
 
diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
index 5d2a1225785b..8905bba30aa0 100644
--- a/arch/mips/mm/mmap.c
+++ b/arch/mips/mm/mmap.c
@@ -26,11 +26,11 @@ EXPORT_SYMBOL(shm_align_mask);
 
 enum mmap_allocation_direction {UP, DOWN};
 
-static unsigned long arch_get_unmapped_area_common(struct file *filp,
-	unsigned long addr0, unsigned long len, unsigned long pgoff,
-	unsigned long flags, enum mmap_allocation_direction dir)
+static unsigned long arch_get_unmapped_area_common(struct mm_struct *mm,
+	struct file *filp, unsigned long addr0, unsigned long len,
+	unsigned long pgoff, unsigned long flags,
+	enum mmap_allocation_direction dir)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long addr = addr0;
 	int do_color_align;
@@ -79,7 +79,7 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 		info.low_limit = PAGE_SIZE;
 		info.high_limit = mm->mmap_base;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 
 		if (!(addr & ~PAGE_MASK))
 			return addr;
@@ -94,14 +94,14 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr0,
-	unsigned long len, unsigned long pgoff, unsigned long flags,
-	vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+	unsigned long addr0, unsigned long len, unsigned long pgoff,
+	unsigned long flags, vm_flags_t vm_flags)
 {
-	return arch_get_unmapped_area_common(filp,
+	return arch_get_unmapped_area_common(mm, filp,
 			addr0, len, pgoff, flags, UP);
 }
 
@@ -109,11 +109,11 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr0,
  * There is no need to export this but sched.h declares the function as
  * extern so making it static here results in an error.
  */
-unsigned long arch_get_unmapped_area_topdown(struct file *filp,
-	unsigned long addr0, unsigned long len, unsigned long pgoff,
-	unsigned long flags, vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area_topdown(struct mm_struct *mm,
+	struct file *filp, unsigned long addr0, unsigned long len,
+	unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
-	return arch_get_unmapped_area_common(filp,
+	return arch_get_unmapped_area_common(mm, filp,
 			addr0, len, pgoff, flags, DOWN);
 }
 
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 1a676a9bf80c..b9bf734cf678 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -100,11 +100,11 @@ unsigned long mmap_upper_limit(const struct rlimit *rlim_stack)
 
 enum mmap_allocation_direction {UP, DOWN};
 
-static unsigned long arch_get_unmapped_area_common(struct file *filp,
-	unsigned long addr, unsigned long len, unsigned long pgoff,
-	unsigned long flags, enum mmap_allocation_direction dir)
+static unsigned long arch_get_unmapped_area_common(struct mm_struct *mm,
+	struct file *filp, unsigned long addr, unsigned long len,
+	unsigned long pgoff, unsigned long flags,
+	enum mmap_allocation_direction dir)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
 	unsigned long filp_pgoff;
 	int do_color_align;
@@ -152,7 +152,7 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 		info.low_limit = PAGE_SIZE;
 		info.high_limit = mm->mmap_base;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 		if (!(addr & ~PAGE_MASK))
 			return addr;
 		VM_BUG_ON(addr != -ENOMEM);
@@ -167,22 +167,22 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_upper_limit(NULL);
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-	unsigned long len, unsigned long pgoff, unsigned long flags,
-	vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+	unsigned long addr, unsigned long len, unsigned long pgoff,
+	unsigned long flags, vm_flags_t vm_flags)
 {
-	return arch_get_unmapped_area_common(filp,
+	return arch_get_unmapped_area_common(mm, filp,
 			addr, len, pgoff, flags, UP);
 }
 
-unsigned long arch_get_unmapped_area_topdown(struct file *filp,
-	unsigned long addr, unsigned long len, unsigned long pgoff,
-	unsigned long flags, vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area_topdown(struct mm_struct *mm,
+	struct file *filp, unsigned long addr, unsigned long len,
+	unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
-	return arch_get_unmapped_area_common(filp,
+	return arch_get_unmapped_area_common(mm, filp,
 			addr, len, pgoff, flags, DOWN);
 }
 
diff --git a/arch/powerpc/include/asm/book3s/64/slice.h b/arch/powerpc/include/asm/book3s/64/slice.h
index 6e2f7a74cd75..d95d9e292443 100644
--- a/arch/powerpc/include/asm/book3s/64/slice.h
+++ b/arch/powerpc/include/asm/book3s/64/slice.h
@@ -25,7 +25,8 @@
 
 struct mm_struct;
 
-unsigned long slice_get_unmapped_area(unsigned long addr, unsigned long len,
+unsigned long slice_get_unmapped_area(struct mm_struct *mm,
+				      unsigned long addr, unsigned long len,
 				      unsigned long flags, unsigned int psize,
 				      int topdown);
 
diff --git a/arch/powerpc/mm/book3s64/slice.c b/arch/powerpc/mm/book3s64/slice.c
index 28bec5bc7879..ab8b24f6287d 100644
--- a/arch/powerpc/mm/book3s64/slice.c
+++ b/arch/powerpc/mm/book3s64/slice.c
@@ -311,7 +311,7 @@ static unsigned long slice_find_area_bottomup(struct mm_struct *mm,
 		}
 		info.high_limit = addr;
 
-		found = vm_unmapped_area(&info);
+		found = vm_unmapped_area(mm, &info);
 		if (!(found & ~PAGE_MASK))
 			return found;
 	}
@@ -362,7 +362,7 @@ static unsigned long slice_find_area_topdown(struct mm_struct *mm,
 		}
 		info.low_limit = addr;
 
-		found = vm_unmapped_area(&info);
+		found = vm_unmapped_area(mm, &info);
 		if (!(found & ~PAGE_MASK))
 			return found;
 	}
@@ -422,7 +422,8 @@ static inline void slice_andnot_mask(struct slice_mask *dst,
 #define MMU_PAGE_BASE	MMU_PAGE_4K
 #endif
 
-unsigned long slice_get_unmapped_area(unsigned long addr, unsigned long len,
+unsigned long slice_get_unmapped_area(struct mm_struct *mm,
+				      unsigned long addr, unsigned long len,
 				      unsigned long flags, unsigned int psize,
 				      int topdown)
 {
@@ -433,7 +434,6 @@ unsigned long slice_get_unmapped_area(unsigned long addr, unsigned long len,
 	int fixed = (flags & MAP_FIXED);
 	int pshift = max_t(int, mmu_psize_defs[psize].shift, PAGE_SHIFT);
 	unsigned long page_size = 1UL << pshift;
-	struct mm_struct *mm = current->mm;
 	unsigned long newaddr;
 	unsigned long high_limit;
 
@@ -649,7 +649,8 @@ static int file_to_psize(struct file *file)
 }
 #endif
 
-unsigned long arch_get_unmapped_area(struct file *filp,
+unsigned long arch_get_unmapped_area(struct mm_struct *mm,
+				     struct file *filp,
 				     unsigned long addr,
 				     unsigned long len,
 				     unsigned long pgoff,
@@ -659,17 +660,19 @@ unsigned long arch_get_unmapped_area(struct file *filp,
 	unsigned int psize;
 
 	if (radix_enabled())
-		return generic_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
+		return generic_get_unmapped_area(mm, filp, addr, len, pgoff,
+						 flags, vm_flags);
 
 	if (filp && is_file_hugepages(filp))
 		psize = file_to_psize(filp);
 	else
-		psize = mm_ctx_user_psize(&current->mm->context);
+		psize = mm_ctx_user_psize(&mm->context);
 
-	return slice_get_unmapped_area(addr, len, flags, psize, 0);
+	return slice_get_unmapped_area(mm, addr, len, flags, psize, 0);
 }
 
-unsigned long arch_get_unmapped_area_topdown(struct file *filp,
+unsigned long arch_get_unmapped_area_topdown(struct mm_struct *mm,
+					     struct file *filp,
 					     const unsigned long addr0,
 					     const unsigned long len,
 					     const unsigned long pgoff,
@@ -679,14 +682,15 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp,
 	unsigned int psize;
 
 	if (radix_enabled())
-		return generic_get_unmapped_area_topdown(filp, addr0, len, pgoff, flags, vm_flags);
+		return generic_get_unmapped_area_topdown(mm, filp, addr0, len,
+							 pgoff, flags, vm_flags);
 
 	if (filp && is_file_hugepages(filp))
 		psize = file_to_psize(filp);
 	else
-		psize = mm_ctx_user_psize(&current->mm->context);
+		psize = mm_ctx_user_psize(&mm->context);
 
-	return slice_get_unmapped_area(addr0, len, flags, psize, 1);
+	return slice_get_unmapped_area(mm, addr0, len, flags, psize, 1);
 }
 
 unsigned int notrace get_slice_psize(struct mm_struct *mm, unsigned long addr)
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index ef7bfc87758c..92332e9f5229 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -75,11 +75,11 @@ static unsigned long get_align_mask(struct file *filp, unsigned long flags)
 	return 0;
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-				     unsigned long len, unsigned long pgoff,
-				     unsigned long flags, vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+				     unsigned long addr, unsigned long len,
+				     unsigned long pgoff, unsigned long flags,
+				     vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct vm_unmapped_area_info info = {};
 
@@ -103,7 +103,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.align_mask = get_align_mask(filp, flags);
 	if (!(filp && is_file_hugepages(filp)))
 		info.align_offset = pgoff << PAGE_SHIFT;
-	addr = vm_unmapped_area(&info);
+	addr = vm_unmapped_area(mm, &info);
 	if (offset_in_page(addr))
 		return addr;
 
@@ -111,12 +111,15 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	return check_asce_limit(mm, addr, len);
 }
 
-unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
-					     unsigned long len, unsigned long pgoff,
-					     unsigned long flags, vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area_topdown(struct mm_struct *mm,
+					     struct file *filp,
+					     unsigned long addr,
+					     unsigned long len,
+					     unsigned long pgoff,
+					     unsigned long flags,
+					     vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
 	struct vm_unmapped_area_info info = {};
 
 	/* requested length too big for entire address space */
@@ -142,7 +145,7 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long ad
 	info.align_mask = get_align_mask(filp, flags);
 	if (!(filp && is_file_hugepages(filp)))
 		info.align_offset = pgoff << PAGE_SHIFT;
-	addr = vm_unmapped_area(&info);
+	addr = vm_unmapped_area(mm, &info);
 
 	/*
 	 * A failed mmap() very likely causes application failure,
@@ -155,7 +158,7 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long ad
 		info.flags = 0;
 		info.low_limit = TASK_UNMAPPED_BASE;
 		info.high_limit = TASK_SIZE;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 		if (offset_in_page(addr))
 			return addr;
 	}
diff --git a/arch/sh/mm/mmap.c b/arch/sh/mm/mmap.c
index c442734d9b0c..d7a790521539 100644
--- a/arch/sh/mm/mmap.c
+++ b/arch/sh/mm/mmap.c
@@ -51,11 +51,10 @@ static inline unsigned long COLOUR_ALIGN(unsigned long addr,
 	return base + off;
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-	unsigned long len, unsigned long pgoff, unsigned long flags,
-	vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags, vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int do_colour_align;
 	struct vm_unmapped_area_info info = {};
@@ -94,16 +93,16 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.high_limit = TASK_SIZE;
 	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
 unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
-			  const unsigned long len, const unsigned long pgoff,
-			  const unsigned long flags, vm_flags_t vm_flags)
+arch_get_unmapped_area_topdown(struct mm_struct *mm, struct file *filp,
+		const unsigned long addr0, const unsigned long len,
+		const unsigned long pgoff, const unsigned long flags,
+		vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
 	int do_colour_align;
 	struct vm_unmapped_area_info info = {};
@@ -144,7 +143,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	info.high_limit = mm->mmap_base;
 	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
-	addr = vm_unmapped_area(&info);
+	addr = vm_unmapped_area(mm, &info);
 
 	/*
 	 * A failed mmap() very likely causes application failure,
@@ -157,7 +156,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		info.flags = 0;
 		info.low_limit = TASK_UNMAPPED_BASE;
 		info.high_limit = TASK_SIZE;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 	}
 
 	return addr;
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 74ede706fb32..b8bed39cddc9 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -1141,9 +1141,9 @@ static inline bool pte_access_permitted(pte_t pte, bool write)
 /* We provide a special get_unmapped_area for framebuffer mmaps to try and use
  * the largest alignment possible such that larget PTEs can be used.
  */
-unsigned long get_fb_unmapped_area(struct file *filp, unsigned long,
-				   unsigned long, unsigned long,
-				   unsigned long);
+unsigned long get_fb_unmapped_area(struct mm_struct *mm, struct file *filp,
+				   unsigned long addr, unsigned long len,
+				   unsigned long pgoff, unsigned long flags);
 #define HAVE_ARCH_FB_UNMAPPED_AREA
 
 void sun4v_register_fault_status(void);
diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index fb31bc0c5b48..930ca7f8a7dc 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -40,7 +40,10 @@ SYSCALL_DEFINE0(getpagesize)
 	return PAGE_SIZE; /* Possibly older binaries want 8192 on sun4's? */
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+				     unsigned long addr, unsigned long len,
+				     unsigned long pgoff, unsigned long flags,
+				     vm_flags_t vm_flags)
 {
 	struct vm_unmapped_area_info info = {};
 	bool file_hugepage = false;
@@ -74,7 +77,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	} else {
 		info.align_mask = huge_page_mask_align(filp);
 	}
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
 /*
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index ecefcffcf7b1..e9f5e1b37ee9 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -98,9 +98,11 @@ static unsigned long get_align_mask(struct file *filp, unsigned long flags)
 	return 0;
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+				     unsigned long addr, unsigned long len,
+				     unsigned long pgoff, unsigned long flags,
+				     vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct * vma;
 	unsigned long task_size = TASK_SIZE;
 	int do_color_align;
@@ -147,25 +149,25 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	info.align_mask = get_align_mask(filp, flags);
 	if (!file_hugepage)
 		info.align_offset = pgoff << PAGE_SHIFT;
-	addr = vm_unmapped_area(&info);
+	addr = vm_unmapped_area(mm, &info);
 
 	if ((addr & ~PAGE_MASK) && task_size > VA_EXCLUDE_END) {
 		VM_BUG_ON(addr != -ENOMEM);
 		info.low_limit = VA_EXCLUDE_END;
 		info.high_limit = task_size;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 	}
 
 	return addr;
 }
 
 unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
-			  const unsigned long len, const unsigned long pgoff,
-			  const unsigned long flags, vm_flags_t vm_flags)
+arch_get_unmapped_area_topdown(struct mm_struct *mm, struct file *filp,
+			  const unsigned long addr0, const unsigned long len,
+			  const unsigned long pgoff, const unsigned long flags,
+			  vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
 	unsigned long task_size = STACK_TOP32;
 	unsigned long addr = addr0;
 	int do_color_align;
@@ -215,7 +217,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	info.align_mask = get_align_mask(filp, flags);
 	if (!file_hugepage)
 		info.align_offset = pgoff << PAGE_SHIFT;
-	addr = vm_unmapped_area(&info);
+	addr = vm_unmapped_area(mm, &info);
 
 	/*
 	 * A failed mmap() very likely causes application failure,
@@ -228,20 +230,22 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		info.flags = 0;
 		info.low_limit = TASK_UNMAPPED_BASE;
 		info.high_limit = STACK_TOP32;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 	}
 
 	return addr;
 }
 
 /* Try to align mapping such that we align it as much as possible. */
-unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
+unsigned long get_fb_unmapped_area(struct mm_struct *mm, struct file *filp,
+				   unsigned long orig_addr, unsigned long len,
+				   unsigned long pgoff, unsigned long flags)
 {
 	unsigned long align_goal, addr = -ENOMEM;
 
 	if (flags & MAP_FIXED) {
 		/* Ok, don't mess with it. */
-		return mm_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
+		return mm_get_unmapped_area(mm, NULL, orig_addr, len, pgoff, flags);
 	}
 	flags &= ~MAP_SHARED;
 
@@ -254,7 +258,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 		align_goal = (64UL * 1024);
 
 	do {
-		addr = mm_get_unmapped_area(NULL, orig_addr,
+		addr = mm_get_unmapped_area(mm, NULL, orig_addr,
 					    len + (align_goal - PAGE_SIZE), pgoff, flags);
 		if (!(addr & ~PAGE_MASK)) {
 			addr = (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
@@ -273,7 +277,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 	 * be obtained.
 	 */
 	if (addr & ~PAGE_MASK)
-		addr = mm_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
+		addr = mm_get_unmapped_area(mm, NULL, orig_addr, len, pgoff, flags);
 
 	return addr;
 }
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 0de9df759c99..12c66609889e 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -307,7 +307,7 @@ static inline int mmap_is_ia32(void)
 
 extern unsigned long task_size_32bit(void);
 extern unsigned long task_size_64bit(int full_addr_space);
-extern unsigned long get_mmap_base(int is_legacy);
+extern unsigned long get_mmap_base(struct mm_struct *mm, int is_legacy);
 extern bool mmap_address_hint_valid(unsigned long addr, unsigned long len);
 extern unsigned long get_sigframe_size(void);
 
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 9268289cd9f9..f81652086909 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -121,11 +121,12 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static unsigned long sgx_get_unmapped_area(struct file *file,
-					   unsigned long addr,
-					   unsigned long len,
-					   unsigned long pgoff,
-					   unsigned long flags)
+static unsigned long sgx_get_unmapped_area(struct mm_struct *mm,
+					    struct file *file,
+					    unsigned long addr,
+					    unsigned long len,
+					    unsigned long pgoff,
+					    unsigned long flags)
 {
 	if ((flags & MAP_TYPE) == MAP_PRIVATE)
 		return -EINVAL;
@@ -133,7 +134,7 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
 	if (flags & MAP_FIXED)
 		return addr;
 
-	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(mm, file, addr, len, pgoff, flags);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 776ae6fa7f2d..d9c4353913a4 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -89,8 +89,9 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 	return ksys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
 }
 
-static void find_start_end(unsigned long addr, unsigned long flags,
-		unsigned long *begin, unsigned long *end)
+static void find_start_end(struct mm_struct *mm, unsigned long addr,
+			   unsigned long flags, unsigned long *begin,
+			   unsigned long *end)
 {
 	if (!in_32bit_syscall() && (flags & MAP_32BIT)) {
 		/* This is usually used needed to map code in small
@@ -108,7 +109,7 @@ static void find_start_end(unsigned long addr, unsigned long flags,
 		return;
 	}
 
-	*begin	= get_mmap_base(1);
+	*begin	= get_mmap_base(mm, 1);
 	if (in_32bit_syscall())
 		*end = task_size_32bit();
 	else
@@ -124,10 +125,11 @@ static inline unsigned long stack_guard_placement(vm_flags_t vm_flags)
 }
 
 unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
-		       unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
+arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		       unsigned long addr, unsigned long len,
+		       unsigned long pgoff, unsigned long flags,
+		       vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct vm_unmapped_area_info info = {};
 	unsigned long begin, end;
@@ -135,7 +137,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
 	if (flags & MAP_FIXED)
 		return addr;
 
-	find_start_end(addr, flags, &begin, &end);
+	find_start_end(mm, addr, flags, &begin, &end);
 
 	if (len > end)
 		return -ENOMEM;
@@ -160,16 +162,16 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
 		info.align_offset += get_align_bits();
 	}
 
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
 unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
-			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags, vm_flags_t vm_flags)
+arch_get_unmapped_area_topdown(struct mm_struct *mm, struct file *filp,
+			  unsigned long addr0, unsigned long len,
+			  unsigned long pgoff, unsigned long flags,
+			  vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
 	struct vm_unmapped_area_info info = {};
 
@@ -204,7 +206,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
 	else
 		info.low_limit = PAGE_SIZE;
 
-	info.high_limit = get_mmap_base(0);
+	info.high_limit = get_mmap_base(mm, 0);
 	if (!(filp && is_file_hugepages(filp))) {
 		info.start_gap = stack_guard_placement(vm_flags);
 		info.align_offset = pgoff << PAGE_SHIFT;
@@ -224,7 +226,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
 		info.align_mask = get_align_mask(filp);
 		info.align_offset += get_align_bits();
 	}
-	addr = vm_unmapped_area(&info);
+	addr = vm_unmapped_area(mm, &info);
 	if (!(addr & ~PAGE_MASK))
 		return addr;
 	VM_BUG_ON(addr != -ENOMEM);
@@ -236,5 +238,5 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
 	 * can happen with large stack limits and large mmap()
 	 * allocations.
 	 */
-	return arch_get_unmapped_area(filp, addr0, len, pgoff, flags, 0);
+	return arch_get_unmapped_area(mm, filp, addr0, len, pgoff, flags, 0);
 }
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 3af979fb41d3..417153d02c54 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -661,13 +661,13 @@ static unsigned long find_nearest_trampoline(unsigned long vaddr)
 	/* Search up from the caller address. */
 	info.low_limit = call_end;
 	info.high_limit = min(high_limit, TASK_SIZE);
-	high_tramp = vm_unmapped_area(&info);
+	high_tramp = vm_unmapped_area(current->mm, &info);
 
 	/* Search down from the caller address. */
 	info.low_limit = max(low_limit, PAGE_SIZE);
 	info.high_limit = call_end;
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-	low_tramp = vm_unmapped_area(&info);
+	low_tramp = vm_unmapped_area(current->mm, &info);
 
 	if (IS_ERR_VALUE(high_tramp) && IS_ERR_VALUE(low_tramp))
 		return -ENOMEM;
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 82f3a987f7cf..75c864f3c0d8 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -143,10 +143,8 @@ void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack
 #endif
 }
 
-unsigned long get_mmap_base(int is_legacy)
+unsigned long get_mmap_base(struct mm_struct *mm, int is_legacy)
 {
-	struct mm_struct *mm = current->mm;
-
 #ifdef CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES
 	if (in_32bit_syscall()) {
 		return is_legacy ? mm->mmap_compat_legacy_base
diff --git a/arch/xtensa/kernel/syscall.c b/arch/xtensa/kernel/syscall.c
index dc54f854c2f5..51bfe06746d7 100644
--- a/arch/xtensa/kernel/syscall.c
+++ b/arch/xtensa/kernel/syscall.c
@@ -54,9 +54,9 @@ asmlinkage long xtensa_fadvise64_64(int fd, int advice,
 }
 
 #ifdef CONFIG_MMU
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags,
-		vm_flags_t vm_flags)
+unsigned long arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vmm;
 	struct vma_iterator vmi;
@@ -81,7 +81,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	else
 		addr = PAGE_ALIGN(addr);
 
-	vma_iter_init(&vmi, current->mm, addr);
+	vma_iter_init(&vmi, mm, addr);
 	for_each_vma(vmi, vmm) {
 		/* At this point:  (addr < vmm->vm_end). */
 		if (addr + len <= vm_start_gap(vmm))
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 63253d1de5d7..204bf406173d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -280,7 +280,8 @@ static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 #endif
 
 #ifndef CONFIG_MMU
-static unsigned long get_unmapped_area_mem(struct file *file,
+static unsigned long get_unmapped_area_mem(struct mm_struct *mm,
+					   struct file *file,
 					   unsigned long addr,
 					   unsigned long len,
 					   unsigned long pgoff,
@@ -515,14 +516,16 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
 }
 
 #ifndef CONFIG_MMU
-static unsigned long get_unmapped_area_zero(struct file *file,
+static unsigned long get_unmapped_area_zero(struct mm_struct *mm,
+				struct file *file,
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags)
 {
 	return -ENOSYS;
 }
 #else
-static unsigned long get_unmapped_area_zero(struct file *file,
+static unsigned long get_unmapped_area_zero(struct mm_struct *mm,
+				struct file *file,
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags)
 {
@@ -534,7 +537,7 @@ static unsigned long get_unmapped_area_zero(struct file *file,
 		 * get_unmapped_area(), so as not to confuse shmem with our
 		 * handle on "/dev/zero".
 		 */
-		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
+		return shmem_get_unmapped_area(mm, NULL, addr, len, pgoff, flags);
 	}
 
 	/*
@@ -543,9 +546,9 @@ static unsigned long get_unmapped_area_zero(struct file *file,
 	 * fall back to system page size mappings.
 	 */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
+	return thp_get_unmapped_area(mm, file, addr, len, pgoff, flags);
 #else
-	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(mm, file, addr, len, pgoff, flags);
 #endif
 }
 #endif /* CONFIG_MMU */
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index d0c9b4e03b47..80df897b6535 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -295,9 +295,9 @@ static int dax_mmap_prepare(struct vm_area_desc *desc)
 }
 
 /* return an unmapped area aligned to the dax region specified alignment */
-static unsigned long dax_get_unmapped_area(struct file *filp,
-		unsigned long addr, unsigned long len, unsigned long pgoff,
-		unsigned long flags)
+static unsigned long dax_get_unmapped_area(struct mm_struct *mm,
+		struct file *filp, unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags)
 {
 	unsigned long off, off_end, off_align, len_align, addr_align, align;
 	struct dev_dax *dev_dax = filp ? filp->private_data : NULL;
@@ -317,13 +317,14 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 	if ((off + len_align) < off)
 		goto out;
 
-	addr_align = mm_get_unmapped_area(filp, addr, len_align, pgoff, flags);
+	addr_align = mm_get_unmapped_area(mm, filp, addr, len_align, pgoff,
+					  flags);
 	if (!IS_ERR_VALUE(addr_align)) {
 		addr_align += (off - addr_align) & (align - 1);
 		return addr_align;
 	}
  out:
-	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(mm, filp, addr, len, pgoff, flags);
 }
 
 static const struct address_space_operations dev_dax_aops = {
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index e3ed684ddcf2..f3d4f71e61d4 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1316,6 +1316,7 @@ drm_gem_object_lookup_at_offset(struct file *filp, unsigned long start,
 #ifdef CONFIG_MMU
 /**
  * drm_gem_get_unmapped_area - get memory mapping region routine for GEM objects
+ * @mm: mm_struct the mapping is placed in
  * @filp: DRM file pointer
  * @uaddr: User address hint
  * @len: Mapping length
@@ -1336,7 +1337,8 @@ drm_gem_object_lookup_at_offset(struct file *filp, unsigned long start,
  * If a GEM object is not available at the given offset or if the caller is not
  * granted access to it, fall back to mm_get_unmapped_area().
  */
-unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
+unsigned long drm_gem_get_unmapped_area(struct mm_struct *mm,
+					struct file *filp, unsigned long uaddr,
 					unsigned long len, unsigned long pgoff,
 					unsigned long flags)
 {
@@ -1348,9 +1350,10 @@ unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
 		obj = NULL;
 
 	if (!obj || !obj->filp || !obj->filp->f_op->get_unmapped_area)
-		ret = mm_get_unmapped_area(filp, uaddr, len, 0, flags);
+		ret = mm_get_unmapped_area(mm, filp, uaddr, len, 0, flags);
 	else
-		ret = obj->filp->f_op->get_unmapped_area(obj->filp, uaddr, len, 0, flags);
+		ret = obj->filp->f_op->get_unmapped_area(mm, obj->filp, uaddr,
+							 len, 0, flags);
 
 	drm_gem_object_put(obj);
 
diff --git a/drivers/gpu/drm/drm_gem_dma_helper.c b/drivers/gpu/drm/drm_gem_dma_helper.c
index 1c00a71ab3c9..59f517a4f283 100644
--- a/drivers/gpu/drm/drm_gem_dma_helper.c
+++ b/drivers/gpu/drm/drm_gem_dma_helper.c
@@ -330,6 +330,7 @@ EXPORT_SYMBOL_GPL(drm_gem_dma_vm_ops);
 #ifndef CONFIG_MMU
 /**
  * drm_gem_dma_get_unmapped_area - propose address for mapping in noMMU cases
+ * @mm: mm_struct the mapping is placed in
  * @filp: file object
  * @addr: memory address
  * @len: buffer size
@@ -344,7 +345,8 @@ EXPORT_SYMBOL_GPL(drm_gem_dma_vm_ops);
  * Returns:
  * mapping address on success or a negative error code on failure.
  */
-unsigned long drm_gem_dma_get_unmapped_area(struct file *filp,
+unsigned long drm_gem_dma_get_unmapped_area(struct mm_struct *mm,
+					    struct file *filp,
 					    unsigned long addr,
 					    unsigned long len,
 					    unsigned long pgoff,
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 5516b2bbb08f..1cf7c36fc945 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -373,7 +373,8 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 #ifdef CONFIG_MMU
 #define v4l2_get_unmapped_area NULL
 #else
-static unsigned long v4l2_get_unmapped_area(struct file *filp,
+static unsigned long v4l2_get_unmapped_area(struct mm_struct *mm,
+		struct file *filp,
 		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags)
 {
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index bf01e6ac7293..e208a8de8716 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1340,7 +1340,8 @@ static long mtdchar_compat_ioctl(struct file *file, unsigned int cmd,
  *   mappings)
  */
 #ifndef CONFIG_MMU
-static unsigned long mtdchar_get_unmapped_area(struct file *file,
+static unsigned long mtdchar_get_unmapped_area(struct mm_struct *mm,
+					   struct file *file,
 					   unsigned long addr,
 					   unsigned long len,
 					   unsigned long pgoff,
diff --git a/drivers/video/fbdev/core/fb_chrdev.c b/drivers/video/fbdev/core/fb_chrdev.c
index ba1d0bc214c5..cf8590b64b54 100644
--- a/drivers/video/fbdev/core/fb_chrdev.c
+++ b/drivers/video/fbdev/core/fb_chrdev.c
@@ -383,7 +383,8 @@ __releases(&info->lock)
 }
 
 #if defined(CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA) && !defined(CONFIG_MMU)
-static unsigned long get_fb_unmapped_area(struct file *filp,
+static unsigned long get_fb_unmapped_area(struct mm_struct *mm,
+				   struct file *filp,
 				   unsigned long addr, unsigned long len,
 				   unsigned long pgoff, unsigned long flags)
 {
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 4edbfccd0bbe..d3aee6705b8d 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -449,7 +449,8 @@ static int cramfs_physmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -ENOSYS;
 }
 
-static unsigned long cramfs_physmem_get_unmapped_area(struct file *file,
+static unsigned long cramfs_physmem_get_unmapped_area(struct mm_struct *mm,
+			struct file *file,
 			unsigned long addr, unsigned long len,
 			unsigned long pgoff, unsigned long flags)
 {
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b2..f5d3c182cc7c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -170,9 +170,9 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
  */
 
 unsigned long
-hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-			    unsigned long len, unsigned long pgoff,
-			    unsigned long flags)
+hugetlb_get_unmapped_area(struct mm_struct *mm, struct file *file,
+			    unsigned long addr, unsigned long len,
+			    unsigned long pgoff, unsigned long flags)
 {
 	unsigned long addr0 = 0;
 	struct hstate *h = hstate_file(file);
@@ -184,7 +184,8 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	if (addr)
 		addr0 = ALIGN(addr, huge_page_size(h));
 
-	return mm_get_unmapped_area_vmflags(file, addr0, len, pgoff, flags, 0);
+	return mm_get_unmapped_area_vmflags(mm, file, addr0, len, pgoff,
+					    flags, 0);
 }
 
 /*
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index b7634f975d98..3e542fe3118d 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -435,22 +435,25 @@ static int proc_reg_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 static unsigned long
-pde_get_unmapped_area(struct proc_dir_entry *pde, struct file *file, unsigned long orig_addr,
+pde_get_unmapped_area(struct proc_dir_entry *pde, struct mm_struct *mm,
+			   struct file *file, unsigned long orig_addr,
 			   unsigned long len, unsigned long pgoff,
 			   unsigned long flags)
 {
 	if (pde->proc_ops->proc_get_unmapped_area)
-		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgoff, flags);
+		return pde->proc_ops->proc_get_unmapped_area(mm, file,
+					orig_addr, len, pgoff, flags);
 
 #ifdef CONFIG_MMU
-	return mm_get_unmapped_area(file, orig_addr, len, pgoff, flags);
+	return mm_get_unmapped_area(mm, file, orig_addr, len, pgoff, flags);
 #endif
 
 	return orig_addr;
 }
 
 static unsigned long
-proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
+proc_reg_get_unmapped_area(struct mm_struct *mm, struct file *file,
+			   unsigned long orig_addr,
 			   unsigned long len, unsigned long pgoff,
 			   unsigned long flags)
 {
@@ -458,9 +461,9 @@ proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
 	unsigned long rv = -EIO;
 
 	if (pde_is_permanent(pde)) {
-		return pde_get_unmapped_area(pde, file, orig_addr, len, pgoff, flags);
+		return pde_get_unmapped_area(pde, mm, file, orig_addr, len, pgoff, flags);
 	} else if (use_pde(pde)) {
-		rv = pde_get_unmapped_area(pde, file, orig_addr, len, pgoff, flags);
+		rv = pde_get_unmapped_area(pde, mm, file, orig_addr, len, pgoff, flags);
 		unuse_pde(pde);
 	}
 	return rv;
diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index c3ed1c5117b2..e070ca06499b 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -31,11 +31,12 @@
 
 #include "internal.h"
 
-static unsigned long ramfs_mmu_get_unmapped_area(struct file *file,
+static unsigned long ramfs_mmu_get_unmapped_area(struct mm_struct *mm,
+		struct file *file,
 		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags)
 {
-	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(mm, file, addr, len, pgoff, flags);
 }
 
 const struct file_operations ramfs_file_operations = {
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 2f79bcb89d2e..2e20fc9c0d37 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -23,7 +23,8 @@
 #include "internal.h"
 
 static int ramfs_nommu_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
-static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
+static unsigned long ramfs_nommu_get_unmapped_area(struct mm_struct *mm,
+						   struct file *file,
 						   unsigned long addr,
 						   unsigned long len,
 						   unsigned long pgoff,
@@ -199,7 +200,8 @@ static int ramfs_nommu_setattr(struct mnt_idmap *idmap,
  *   - the pages to be mapped must exist
  *   - the pages be physically contiguous in sequence
  */
-static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
+static unsigned long ramfs_nommu_get_unmapped_area(struct mm_struct *mm,
+					    struct file *file,
 					    unsigned long addr, unsigned long len,
 					    unsigned long pgoff, unsigned long flags)
 {
diff --git a/fs/romfs/mmap-nommu.c b/fs/romfs/mmap-nommu.c
index 7c3a1a7fecee..18c1e8545b0d 100644
--- a/fs/romfs/mmap-nommu.c
+++ b/fs/romfs/mmap-nommu.c
@@ -15,7 +15,8 @@
  *   mappings)
  * - attempts to map through to the underlying MTD device
  */
-static unsigned long romfs_get_unmapped_area(struct file *file,
+static unsigned long romfs_get_unmapped_area(struct mm_struct *mm,
+					     struct file *file,
 					     unsigned long addr,
 					     unsigned long len,
 					     unsigned long pgoff,
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 8a704f6a65c1..a99d525f0369 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -536,7 +536,8 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
 
 #ifdef CONFIG_MMU
-unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
+unsigned long drm_gem_get_unmapped_area(struct mm_struct *mm,
+					struct file *filp, unsigned long uaddr,
 					unsigned long len, unsigned long pgoff,
 					unsigned long flags);
 #else
diff --git a/include/drm/drm_gem_dma_helper.h b/include/drm/drm_gem_dma_helper.h
index f2678e7ecb98..127f52f192a9 100644
--- a/include/drm/drm_gem_dma_helper.h
+++ b/include/drm/drm_gem_dma_helper.h
@@ -232,7 +232,8 @@ drm_gem_dma_prime_import_sg_table_vmap(struct drm_device *drm,
  */
 
 #ifndef CONFIG_MMU
-unsigned long drm_gem_dma_get_unmapped_area(struct file *filp,
+unsigned long drm_gem_dma_get_unmapped_area(struct mm_struct *mm,
+					    struct file *filp,
 					    unsigned long addr,
 					    unsigned long len,
 					    unsigned long pgoff,
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7719f6528445..d72a5ba49654 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -147,7 +147,8 @@ struct bpf_map_ops {
 	int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
 	__poll_t (*map_poll)(struct bpf_map *map, struct file *filp,
 			     struct poll_table_struct *pts);
-	unsigned long (*map_get_unmapped_area)(struct file *filep, unsigned long addr,
+	unsigned long (*map_get_unmapped_area)(struct mm_struct *mm,
+					       struct file *filep, unsigned long addr,
 					       unsigned long len, unsigned long pgoff,
 					       unsigned long flags);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50ce731a2b78..58e00b320efd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1939,7 +1939,10 @@ struct file_operations {
 	int (*fsync) (struct file *, loff_t, loff_t, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	unsigned long (*get_unmapped_area)(struct mm_struct *mm,
+			struct file *file, unsigned long addr,
+			unsigned long len, unsigned long pgoff,
+			unsigned long flags);
 	int (*check_flags)(int);
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c179..5760710c3c5d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -388,11 +388,12 @@ static inline bool thp_disabled_by_hw(void)
 	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
 }
 
-unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags);
-unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags,
-		vm_flags_t vm_flags);
+unsigned long thp_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags);
+unsigned long thp_get_unmapped_area_vmflags(struct mm_struct *mm,
+		struct file *filp, unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags);
 
 enum split_type {
 	SPLIT_TYPE_UNIFORM,
@@ -614,9 +615,10 @@ static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 #define thp_get_unmapped_area	NULL
 
 static inline unsigned long
-thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
-			      unsigned long len, unsigned long pgoff,
-			      unsigned long flags, vm_flags_t vm_flags)
+thp_get_unmapped_area_vmflags(struct mm_struct *mm, struct file *filp,
+			      unsigned long addr, unsigned long len,
+			      unsigned long pgoff, unsigned long flags,
+			      vm_flags_t vm_flags)
 {
 	return 0;
 }
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e9..b2743931f927 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -543,9 +543,9 @@ static inline struct hstate *hstate_inode(struct inode *i)
 #endif /* !CONFIG_HUGETLBFS */
 
 unsigned long
-hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-				    unsigned long len, unsigned long pgoff,
-				    unsigned long flags);
+hugetlb_get_unmapped_area(struct mm_struct *mm, struct file *file,
+				    unsigned long addr, unsigned long len,
+				    unsigned long pgoff, unsigned long flags);
 
 /*
  * huegtlb page specific state flags.  These flags are located in page.private
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..560bc369a54c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4138,14 +4138,17 @@ unsigned long randomize_stack_top(unsigned long stack_top);
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
 unsigned long
-__get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
-		    unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags);
+__get_unmapped_area(struct mm_struct *mm, struct file *file,
+		    unsigned long addr, unsigned long len,
+		    unsigned long pgoff, unsigned long flags,
+		    vm_flags_t vm_flags);
 
 static inline unsigned long
 get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		  unsigned long pgoff, unsigned long flags)
 {
-	return __get_unmapped_area(file, addr, len, pgoff, flags, 0);
+	return __get_unmapped_area(current->mm, file, addr, len, pgoff,
+				   flags, 0);
 }
 
 extern unsigned long do_mmap(struct file *file, unsigned long addr,
@@ -4194,7 +4197,8 @@ struct vm_unmapped_area_info {
 	unsigned long start_gap;
 };
 
-extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
+extern unsigned long vm_unmapped_area(struct mm_struct *mm,
+				      struct vm_unmapped_area_info *info);
 
 /* truncate.c */
 void truncate_inode_pages(struct address_space *mapping, loff_t lstart);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 47d7deaeed8f..e7998a303519 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -47,7 +47,10 @@ struct proc_ops {
 	long	(*proc_compat_ioctl)(struct file *, unsigned int, unsigned long);
 #endif
 	int	(*proc_mmap)(struct file *, struct vm_area_struct *);
-	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	unsigned long (*proc_get_unmapped_area)(struct mm_struct *mm,
+			struct file *file, unsigned long addr,
+			unsigned long len, unsigned long pgoff,
+			unsigned long flags);
 } __randomize_layout;
 
 /* definitions for hide_pid field */
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 95d0040df584..adc11009fedf 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -181,19 +181,22 @@ extern void arch_pick_mmap_layout(struct mm_struct *mm,
 				  const struct rlimit *rlim_stack);
 
 unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		       unsigned long len, unsigned long pgoff,
-		       unsigned long flags, vm_flags_t vm_flags);
+arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		       unsigned long addr, unsigned long len,
+		       unsigned long pgoff, unsigned long flags,
+		       vm_flags_t vm_flags);
 unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
-			       unsigned long len, unsigned long pgoff,
-			       unsigned long flags, vm_flags_t);
+arch_get_unmapped_area_topdown(struct mm_struct *mm, struct file *filp,
+			       unsigned long addr, unsigned long len,
+			       unsigned long pgoff, unsigned long flags,
+			       vm_flags_t);
 
-unsigned long mm_get_unmapped_area(struct file *filp, unsigned long addr,
-				   unsigned long len, unsigned long pgoff,
-				   unsigned long flags);
+unsigned long mm_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+				   unsigned long addr, unsigned long len,
+				   unsigned long pgoff, unsigned long flags);
 
-unsigned long mm_get_unmapped_area_vmflags(struct file *filp,
+unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm,
+					   struct file *filp,
 					   unsigned long addr,
 					   unsigned long len,
 					   unsigned long pgoff,
@@ -201,13 +204,15 @@ unsigned long mm_get_unmapped_area_vmflags(struct file *filp,
 					   vm_flags_t vm_flags);
 
 unsigned long
-generic_get_unmapped_area(struct file *filp, unsigned long addr,
-			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags, vm_flags_t vm_flags);
+generic_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+			  unsigned long addr, unsigned long len,
+			  unsigned long pgoff, unsigned long flags,
+			  vm_flags_t vm_flags);
 unsigned long
-generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
-				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags, vm_flags_t vm_flags);
+generic_get_unmapped_area_topdown(struct mm_struct *mm, struct file *filp,
+				  unsigned long addr, unsigned long len,
+				  unsigned long pgoff, unsigned long flags,
+				  vm_flags_t vm_flags);
 #else
 static inline void arch_pick_mmap_layout(struct mm_struct *mm,
 					 const struct rlimit *rlim_stack) {}
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e729b9b0e38d..3912836b375f 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -109,8 +109,9 @@ extern struct file *shmem_file_setup_with_mnt(struct vfsmount *mnt,
 		const char *name, loff_t size, vma_flags_t flags);
 int shmem_zero_setup(struct vm_area_struct *vma);
 int shmem_zero_setup_desc(struct vm_area_desc *desc);
-extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags);
+extern unsigned long shmem_get_unmapped_area(struct mm_struct *mm,
+		struct file *file, unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
 bool shmem_mapping(const struct address_space *mapping);
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 23e8a85111bc..255fd80fd2f2 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -318,7 +318,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	return io_region_mmap(ctx, region, vma, page_limit);
 }
 
-unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
+unsigned long io_uring_get_unmapped_area(struct mm_struct *mm,
+					 struct file *filp, unsigned long addr,
 					 unsigned long len, unsigned long pgoff,
 					 unsigned long flags)
 {
@@ -361,7 +362,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 #else
 	addr = 0UL;
 #endif
-	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(mm, filp, addr, len, pgoff, flags);
 }
 
 #else /* !CONFIG_MMU */
@@ -420,7 +421,8 @@ unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
 	return NOMMU_MAP_DIRECT | NOMMU_MAP_READ | NOMMU_MAP_WRITE;
 }
 
-unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
+unsigned long io_uring_get_unmapped_area(struct mm_struct *mm,
+					 struct file *file, unsigned long addr,
 					 unsigned long len, unsigned long pgoff,
 					 unsigned long flags)
 {
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index f4cfbb6b9a1f..40104ed26dbe 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -12,7 +12,8 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages);
 #ifndef CONFIG_MMU
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file);
 #endif
-unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
+unsigned long io_uring_get_unmapped_area(struct mm_struct *mm,
+					 struct file *file, unsigned long addr,
 					 unsigned long len, unsigned long pgoff,
 					 unsigned long flags);
 int io_uring_mmap(struct file *file, struct vm_area_struct *vma);
diff --git a/ipc/shm.c b/ipc/shm.c
index b3e8a58e177d..c49e1461ff9c 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -649,13 +649,13 @@ static long shm_fallocate(struct file *file, int mode, loff_t offset,
 	return sfd->file->f_op->fallocate(file, mode, offset, len);
 }
 
-static unsigned long shm_get_unmapped_area(struct file *file,
-	unsigned long addr, unsigned long len, unsigned long pgoff,
-	unsigned long flags)
+static unsigned long shm_get_unmapped_area(struct mm_struct *mm,
+	struct file *file, unsigned long addr, unsigned long len,
+	unsigned long pgoff, unsigned long flags)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
 
-	return sfd->file->f_op->get_unmapped_area(sfd->file, addr, len,
+	return sfd->file->f_op->get_unmapped_area(mm, sfd->file, addr, len,
 						pgoff, flags);
 }
 
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 80b7b8a69446..839ebaae301d 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -543,7 +543,8 @@ static const struct vm_operations_struct arena_vm_ops = {
 	.fault          = arena_vm_fault,
 };
 
-static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long addr,
+static unsigned long arena_get_unmapped_area(struct mm_struct *mm,
+					     struct file *filp, unsigned long addr,
 					     unsigned long len, unsigned long pgoff,
 					     unsigned long flags)
 {
@@ -566,7 +567,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 			return -EINVAL;
 	}
 
-	ret = mm_get_unmapped_area(filp, addr, len * 2, 0, flags);
+	ret = mm_get_unmapped_area(mm, filp, addr, len * 2, 0, flags);
 	if (IS_ERR_VALUE(ret))
 		return ret;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6db306d23b47..5092fc8707c5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1150,16 +1150,18 @@ static __poll_t bpf_map_poll(struct file *filp, struct poll_table_struct *pts)
 	return EPOLLERR;
 }
 
-static unsigned long bpf_get_unmapped_area(struct file *filp, unsigned long addr,
+static unsigned long bpf_get_unmapped_area(struct mm_struct *mm,
+					   struct file *filp, unsigned long addr,
 					   unsigned long len, unsigned long pgoff,
 					   unsigned long flags)
 {
 	struct bpf_map *map = filp->private_data;
 
 	if (map->ops->map_get_unmapped_area)
-		return map->ops->map_get_unmapped_area(filp, addr, len, pgoff, flags);
+		return map->ops->map_get_unmapped_area(mm, filp, addr, len,
+						       pgoff, flags);
 #ifdef CONFIG_MMU
-	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(mm, filp, addr, len, pgoff, flags);
 #else
 	return addr;
 #endif
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..708faf4a0e37 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1193,8 +1193,8 @@ static inline bool is_transparent_hugepage(const struct folio *folio)
 		folio_test_large_rmappable(folio);
 }
 
-static unsigned long __thp_get_unmapped_area(struct file *filp,
-		unsigned long addr, unsigned long len,
+static unsigned long __thp_get_unmapped_area(struct mm_struct *mm,
+		struct file *filp, unsigned long addr, unsigned long len,
 		loff_t off, unsigned long flags, unsigned long size,
 		vm_flags_t vm_flags)
 {
@@ -1212,7 +1212,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
 	if (len_pad < len || (off + len_pad) < off)
 		return 0;
 
-	ret = mm_get_unmapped_area_vmflags(filp, addr, len_pad,
+	ret = mm_get_unmapped_area_vmflags(mm, filp, addr, len_pad,
 					   off >> PAGE_SHIFT, flags, vm_flags);
 
 	/*
@@ -1231,32 +1231,35 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
 
 	off_sub = (off - ret) & (size - 1);
 
-	if (mm_flags_test(MMF_TOPDOWN, current->mm) && !off_sub)
+	if (mm_flags_test(MMF_TOPDOWN, mm) && !off_sub)
 		return ret + size;
 
 	ret += off_sub;
 	return ret;
 }
 
-unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags,
-		vm_flags_t vm_flags)
+unsigned long thp_get_unmapped_area_vmflags(struct mm_struct *mm,
+		struct file *filp, unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
 	unsigned long ret;
 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 
-	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
+	ret = __thp_get_unmapped_area(mm, filp, addr, len, off, flags,
+				      PMD_SIZE, vm_flags);
 	if (ret)
 		return ret;
 
-	return mm_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags,
+	return mm_get_unmapped_area_vmflags(mm, filp, addr, len, pgoff, flags,
 					    vm_flags);
 }
 
-unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+unsigned long thp_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
 {
-	return thp_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags, 0);
+	return thp_get_unmapped_area_vmflags(mm, filp, addr, len, pgoff,
+					     flags, 0);
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff4..54915ac478ab 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -405,7 +405,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 	/* Obtain the address to map to. we verify (or select) it and ensure
 	 * that it represents a valid section of the address space.
 	 */
-	addr = __get_unmapped_area(file, addr, len, pgoff, flags, vm_flags);
+	addr = __get_unmapped_area(mm, file, addr, len, pgoff, flags, vm_flags);
 	if (IS_ERR_VALUE(addr))
 		return addr;
 
@@ -662,14 +662,15 @@ static inline unsigned long stack_guard_placement(vm_flags_t vm_flags)
  * - is at least the desired size.
  * - satisfies (begin_addr & align_mask) == (align_offset & align_mask)
  */
-unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info)
+unsigned long vm_unmapped_area(struct mm_struct *mm,
+			       struct vm_unmapped_area_info *info)
 {
 	unsigned long addr;
 
 	if (info->flags & VM_UNMAPPED_AREA_TOPDOWN)
-		addr = unmapped_area_topdown(info);
+		addr = unmapped_area_topdown(mm, info);
 	else
-		addr = unmapped_area(info);
+		addr = unmapped_area(mm, info);
 
 	trace_vm_unmapped_area(addr, info);
 	return addr;
@@ -687,11 +688,11 @@ unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info)
  * This function "knows" that -ENOMEM has the bits set.
  */
 unsigned long
-generic_get_unmapped_area(struct file *filp, unsigned long addr,
-			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags, vm_flags_t vm_flags)
+generic_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+			  unsigned long addr, unsigned long len,
+			  unsigned long pgoff, unsigned long flags,
+			  vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
 	struct vm_unmapped_area_info info = {};
 	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
@@ -717,16 +718,17 @@ generic_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.start_gap = stack_guard_placement(vm_flags);
 	if (filp && is_file_hugepages(filp))
 		info.align_mask = huge_page_mask_align(filp);
-	return vm_unmapped_area(&info);
+	return vm_unmapped_area(mm, &info);
 }
 
 #ifndef HAVE_ARCH_UNMAPPED_AREA
 unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		       unsigned long len, unsigned long pgoff,
-		       unsigned long flags, vm_flags_t vm_flags)
+arch_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+		       unsigned long addr, unsigned long len,
+		       unsigned long pgoff, unsigned long flags,
+		       vm_flags_t vm_flags)
 {
-	return generic_get_unmapped_area(filp, addr, len, pgoff, flags,
+	return generic_get_unmapped_area(mm, filp, addr, len, pgoff, flags,
 					 vm_flags);
 }
 #endif
@@ -736,12 +738,12 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
  * stack's low limit (the base):
  */
 unsigned long
-generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
-				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags, vm_flags_t vm_flags)
+generic_get_unmapped_area_topdown(struct mm_struct *mm, struct file *filp,
+				  unsigned long addr, unsigned long len,
+				  unsigned long pgoff, unsigned long flags,
+				  vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma, *prev;
-	struct mm_struct *mm = current->mm;
 	struct vm_unmapped_area_info info = {};
 	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
 
@@ -769,7 +771,7 @@ generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 	info.start_gap = stack_guard_placement(vm_flags);
 	if (filp && is_file_hugepages(filp))
 		info.align_mask = huge_page_mask_align(filp);
-	addr = vm_unmapped_area(&info);
+	addr = vm_unmapped_area(mm, &info);
 
 	/*
 	 * A failed mmap() very likely causes application failure,
@@ -782,7 +784,7 @@ generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 		info.flags = 0;
 		info.low_limit = TASK_UNMAPPED_BASE;
 		info.high_limit = mmap_end;
-		addr = vm_unmapped_area(&info);
+		addr = vm_unmapped_area(mm, &info);
 	}
 
 	return addr;
@@ -790,31 +792,36 @@ generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 
 #ifndef HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
-			       unsigned long len, unsigned long pgoff,
-			       unsigned long flags, vm_flags_t vm_flags)
+arch_get_unmapped_area_topdown(struct mm_struct *mm, struct file *filp,
+			       unsigned long addr, unsigned long len,
+			       unsigned long pgoff, unsigned long flags,
+			       vm_flags_t vm_flags)
 {
-	return generic_get_unmapped_area_topdown(filp, addr, len, pgoff, flags,
-						 vm_flags);
+	return generic_get_unmapped_area_topdown(mm, filp, addr, len, pgoff,
+						 flags, vm_flags);
 }
 #endif
 
-unsigned long mm_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
+unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm,
+					   struct file *filp, unsigned long addr,
 					   unsigned long len, unsigned long pgoff,
 					   unsigned long flags, vm_flags_t vm_flags)
 {
-	if (mm_flags_test(MMF_TOPDOWN, current->mm))
-		return arch_get_unmapped_area_topdown(filp, addr, len, pgoff,
-						      flags, vm_flags);
-	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
+	if (mm_flags_test(MMF_TOPDOWN, mm))
+		return arch_get_unmapped_area_topdown(mm, filp, addr, len,
+						      pgoff, flags, vm_flags);
+	return arch_get_unmapped_area(mm, filp, addr, len, pgoff, flags,
+				      vm_flags);
 }
 
 unsigned long
-__get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
+__get_unmapped_area(struct mm_struct *mm, struct file *file,
+		unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
-	unsigned long (*get_area)(struct file *, unsigned long,
-				  unsigned long, unsigned long, unsigned long)
+	unsigned long (*get_area)(struct mm_struct *, struct file *,
+				  unsigned long, unsigned long,
+				  unsigned long, unsigned long)
 				  = NULL;
 
 	unsigned long error = arch_mmap_check(addr, len, flags);
@@ -841,15 +848,15 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		pgoff = 0;
 
 	if (get_area) {
-		addr = get_area(file, addr, len, pgoff, flags);
+		addr = get_area(mm, file, addr, len, pgoff, flags);
 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
 		   && !addr /* no hint */
 		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
-		addr = thp_get_unmapped_area_vmflags(file, addr, len,
+		addr = thp_get_unmapped_area_vmflags(mm, file, addr, len,
 						     pgoff, flags, vm_flags);
 	} else {
-		addr = mm_get_unmapped_area_vmflags(file, addr, len,
+		addr = mm_get_unmapped_area_vmflags(mm, file, addr, len,
 						    pgoff, flags, vm_flags);
 	}
 	if (IS_ERR_VALUE(addr))
@@ -865,10 +872,12 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 }
 
 unsigned long
-mm_get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
+mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
+		     unsigned long addr, unsigned long len,
 		     unsigned long pgoff, unsigned long flags)
 {
-	return mm_get_unmapped_area_vmflags(file, addr, len, pgoff, flags, 0);
+	return mm_get_unmapped_area_vmflags(mm, file, addr, len, pgoff,
+					    flags, 0);
 }
 EXPORT_SYMBOL(mm_get_unmapped_area);
 
diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..d6393bd2844e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1145,8 +1145,9 @@ unsigned long do_mmap(struct file *file,
 		 *   tell us the location of a shared mapping
 		 */
 		if (capabilities & NOMMU_MAP_DIRECT) {
-			addr = file->f_op->get_unmapped_area(file, addr, len,
-							     pgoff, flags);
+			addr = file->f_op->get_unmapped_area(current->mm, file,
+							     addr, len, pgoff,
+							     flags);
 			if (IS_ERR_VALUE(addr)) {
 				ret = addr;
 				if (ret != -ENOSYS)
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..1349e00bc7fd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2711,7 +2711,8 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 	return ret;
 }
 
-unsigned long shmem_get_unmapped_area(struct file *file,
+unsigned long shmem_get_unmapped_area(struct mm_struct *mm,
+				      struct file *file,
 				      unsigned long uaddr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
 {
@@ -2725,7 +2726,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
-	addr = mm_get_unmapped_area(file, uaddr, len, pgoff, flags);
+	addr = mm_get_unmapped_area(mm, file, uaddr, len, pgoff, flags);
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return addr;
@@ -2803,7 +2804,8 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 	if (inflated_len < len)
 		return addr;
 
-	inflated_addr = mm_get_unmapped_area(NULL, uaddr, inflated_len, 0, flags);
+	inflated_addr = mm_get_unmapped_area(mm, NULL, uaddr, inflated_len, 0,
+					     flags);
 	if (IS_ERR_VALUE(inflated_addr))
 		return addr;
 	if (inflated_addr & ~PAGE_MASK)
@@ -5730,11 +5732,12 @@ void shmem_unlock_mapping(struct address_space *mapping)
 }
 
 #ifdef CONFIG_MMU
-unsigned long shmem_get_unmapped_area(struct file *file,
+unsigned long shmem_get_unmapped_area(struct mm_struct *mm,
+				      struct file *file,
 				      unsigned long addr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
 {
-	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(mm, file, addr, len, pgoff, flags);
 }
 #endif
 
diff --git a/mm/vma.c b/mm/vma.c
index 9eea2850818a..9a6cb0338ed8 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2957,20 +2957,22 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 /**
  * unmapped_area() - Find an area between the low_limit and the high_limit with
- * the correct alignment and offset, all from @info. Note: current->mm is used
+ * the correct alignment and offset, all from @info. Note: @mm is used
  * for the search.
  *
+ * @mm: The mm_struct to search.
  * @info: The unmapped area information including the range [low_limit -
  * high_limit), the alignment offset and mask.
  *
  * Return: A memory address or -ENOMEM.
  */
-unsigned long unmapped_area(struct vm_unmapped_area_info *info)
+unsigned long unmapped_area(struct mm_struct *mm,
+			    struct vm_unmapped_area_info *info)
 {
 	unsigned long length, gap;
 	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask + info->start_gap;
@@ -3016,19 +3018,21 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 /**
  * unmapped_area_topdown() - Find an area between the low_limit and the
  * high_limit with the correct alignment and offset at the highest available
- * address, all from @info. Note: current->mm is used for the search.
+ * address, all from @info. Note: @mm is used for the search.
  *
+ * @mm: The mm_struct to search.
  * @info: The unmapped area information including the range [low_limit -
  * high_limit), the alignment offset and mask.
  *
  * Return: A memory address or -ENOMEM.
  */
-unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
+unsigned long unmapped_area_topdown(struct mm_struct *mm,
+				    struct vm_unmapped_area_info *info)
 {
 	unsigned long length, gap, gap_end;
 	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask + info->start_gap;
diff --git a/mm/vma.h b/mm/vma.h
index 8e4b61a7304c..d0a45718deb9 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -467,8 +467,10 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		 unsigned long addr, unsigned long request,
 		 vma_flags_t vma_flags);
 
-unsigned long unmapped_area(struct vm_unmapped_area_info *info);
-unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info);
+unsigned long unmapped_area(struct mm_struct *mm,
+			    struct vm_unmapped_area_info *info);
+unsigned long unmapped_area_topdown(struct mm_struct *mm,
+				    struct vm_unmapped_area_info *info);
 
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 7dc0060617f1..f01465a70ddd 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -4202,7 +4202,8 @@ static int snd_pcm_hw_params_old_user(struct snd_pcm_substream *substream,
 #endif /* CONFIG_SND_SUPPORT_OLD_API */
 
 #ifndef CONFIG_MMU
-static unsigned long snd_pcm_get_unmapped_area(struct file *file,
+static unsigned long snd_pcm_get_unmapped_area(struct mm_struct *mm,
+					       struct file *file,
 					       unsigned long addr,
 					       unsigned long len,
 					       unsigned long pgoff,
-- 
2.43.0


