Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA4CC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED906B065D; Fri, 14 Aug 2026 04:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CD836B065F; Fri, 14 Aug 2026 04:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5416B0660; Fri, 14 Aug 2026 04:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 599126B065D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:55:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C525A0396
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:55:18 +0000 (UTC)
X-FDA: 85099265916.22.ECA29B5
Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7FEC940008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:55:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ghHDyNWy;
	spf=pass (imf12.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.225.64 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786697716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M7Pbg3qHy9dUvw/2GBMFVLtK9eJ8QsOBHb0QGZCzF6E=;
	b=rbqUYDVLFW2FWngzr0cssu5IMVv5AAghxZTeF89oj7RajfgLRFtvUiu30kkQydsBwzamq8
	V0LjZXY3ISTYla78z7uKp03ZOCqz1j6Hi0+DV0xLZnDnoENXWn6FgFHQbfFZovrpR8nlOR
	/9bdfN0K9E10gVvOBgvqILLdph4Fn7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786697716;
	b=1c0L8kpYY4qVewNNsJXNqaHyVX2fX9PhH0fQPrKhloziRWOlkt/Ho4XsBsfbEGC7k+INRV
	Qk/qHqM5436NBsxbZgwJ+5Vx4FMS3AOYM8476w8m/ZFz1k0U2H7m/iL+yBSt9mgdYKpzzf
	yDVZi+YbSbaCelerd8DqW3j3C4cbWVk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ghHDyNWy;
	spf=pass (imf12.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.225.64 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-4744516a312so45428f8f.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786697715; x=1787302515; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M7Pbg3qHy9dUvw/2GBMFVLtK9eJ8QsOBHb0QGZCzF6E=;
        b=ghHDyNWyUyzFs4ZLgqZtcM204cvO0HvjN7VKTxvaNnz43UwUkbHlUwJjYeUlBapyRz
         CPGAUZGedCgFnUEZNaDiOEwHADz09xKHvpqUSjDepbBdpLhqI3wB60wfav10CMO9gazW
         +AiFRgViJY3aXKMmU5gQZkWDeEUA+cX+KecuT11UhQl3ZKrCO9SP945pJHH74U44a9P/
         qMaO9OeMd3sfm2xmZQ0arnxeS6BH/K16to2bi8ewssPK+JC0e/YTdxYvKxAR3ogkJQuP
         anXzKSjSZGE5W+/h50aP7g2XaZWW496QjHDoUiknt1vvbqEnvan+hM86JIVqr10MCaFJ
         REkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786697715; x=1787302515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M7Pbg3qHy9dUvw/2GBMFVLtK9eJ8QsOBHb0QGZCzF6E=;
        b=Gtn7sy8fW2YRxeVF8QRt4mSrtQFtcGoJGIKzz/P078yqasKzIlLu2N+d9W4Yf0J6DW
         qXHx5a5lxEKHBxdjbSrvF7y7Ty8yI/OixFaIelI+PZhe8odTINQZJ3LVedg9qF+desIw
         jncrg3XfCchikpwhMcDNL3PC/00GBr5wArRBggm1mhZaNrBZT4JCg5pXHdrpKYsA08ks
         i0Zwp1gJkXXQRgeN/5Sq9XJXMXBuMEY6fmLanAy+XwCP6VoqJGK0YERfNQpxlmkcpPlu
         JfhCAR+YQN8pYaGoRbY6T+Ez06J/ruxNI8hSU3akBx64ihiwtTLGDZFBxVGo9ngIGLdG
         cQZg==
X-Forwarded-Encrypted: i=1; AHgh+Rret7YDJpQfvEvysur3P65YpXkwseueGzWWiUe/9P+ueTQNuv+YlSu/LUr54pO8z24aNskhLb68uA==@kvack.org
X-Gm-Message-State: AOJu0YzQoM2XqXTeSLIj45JWBUXuOboQkjCMzDJdKQx13ezbKV87ND4T
	znpikqfCGnVpUXebPLmX4M3BjFGaWcCOnaRwfEEsZ39uQv8+SoCLPG3t
X-Gm-Gg: AR+sD13Fbzt/HPNlASYD0r5FGpWIRctjIB0Bld14QmXUBiR5MQwI5MjxFaMZVoxDiA7
	EEW1NOOBb0rPIp1NahQlzpzTArVLn8Fduav5fXpPV5jlFqzVtbyifIO9LwnOsnMaswHLmnBsk6m
	RHSYNc8pZrXKymJfo/zJvjdj7frSfCWBgLfXfDftTbBg69N61VsbSBX/hle7EIKZ9NoWrF0kNVn
	9Ul7rk7tfNa7MeNkf3HYfG1H/kIEQ2ZLHEb9vxGP9EhsPlqaq8kesPUEqJg197rvY9n3+n3GnT9
	j36oZCIkuwoXcDAg9Msb1LLcx35ct8S6Se8H2YYk8eV4vWFivURWh/Ra2SiCyp/uXhrXLFGleMB
	pCKEdXtVfl0PfRj7vfc6GsPohgnf0Nbrp2g/88kjxIn73TmPPWbPT2QT6tiW1Gj2zLQ7CO0YEdH
	sjmoSvR1MuMluYRUwMDc4ig8uqIvzn9/V/rslTs7I6e4XYMzAojl1DxdI7omSHAlXVEY0dMC03w
	o4+lFs3z0pkBI4=
X-Received: by 2002:a05:600c:4e14:b0:495:3bc6:d381 with SMTP id 5b1f17b1804b1-49987a4f03bmr50711495e9.2.1786697714519;
        Fri, 14 Aug 2026 01:55:14 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:10f3:285:31cf:47aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998777d428sm28760795e9.0.2026.08.14.01.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 01:55:12 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	baohua@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	willy@infradead.org,
	zhanghongru@xiaomi.com
Subject: [RFC PATCH v5] mm: retry page faults once under the per-VMA lock
Date: Fri, 14 Aug 2026 16:53:00 +0800
Message-ID: <20260814085300.399107-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 41649r7zrfwcko4b9drdbn4h9w89k9ff
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7FEC940008
X-HE-Tag: 1786697716-824402
X-HE-Meta: U2FsdGVkX1+0iQen7qb57FceTPHjL9B+R1yIIrVd5e0F048inRX479AaxX99xZ5UWiRnFr1GEtIyoIaYId5jUpY5E72lmI2duhWGOVnx/CG+rD1vAomRNdjeivVAHMBgfsk9fEmOQx3SqGJt3NYDGfUTr3VWz35JSeAk6mIlpyc/6hL6SF8vlX18U6H00uP4y58aqTEharf6u4ZKgVX8d6OTR/FJindKFTBjuoxJuwUgigS2zHjo2uVhen8iERa+JLX4TPBRMMhspX/wqg0yPUd/xzlbKevzvcDSSpwKZr5bKyfrlSx4jOxHDCDO485WMOSRKEiuL04tV0Bxe/Zorp+f82EozOVWvyZaa2Xd1FeP+h2TU7WsxIjcShExwRaKh1tnx/FMU67wjjdX2FHwN9wEtjah+yJn1rw/P0C9yXQhHaaN7IvmcdO+BoAIN9G7RQwctQAsV8vhyZRppjg9CX3FpD6nqtXe/1zfF5L1VbdwiY7Qkmgw2AZ157GikMYDN+mvVy4SztXjs/VXktsSVvm+A3a2Xnq7lP+rWsWFGTe5qahPSF4rCd2xrDOoeM3lCamWgoU0wei2ybHvq0sCSb0QFicsgxo7O907XSk6aTaLSFw/YjuB8jQVEUioXp7WiQ0ueLwEaqSmS6cOD3EbWGPIYKiety1yKW/8bgSGM+fJKjxTI3Y08JWhOLjFqagNhwxjsYgQckDpvu3ZIV4tZ4Eo+GU9+yfxnHir8+r4rfDzItE7uVv4uqX/xZYVTdYvcqukfNyDsGr0drJuEZRvvLhwIGDjgDo4inAyIdBP9opeqSOZjt81Hla7B0Ez5e3H4CQWCOGnYEO3idgxYTFbNFRGmhyky26t1ibfJKuwqE4XqFCJp/zTkV2Cdswp/RhE9Gs3+RSJYvSpN5RI/kXMVRTyhZTctW3R3cAXmaZfdo7qzBYQ0MTKChbPGr8ru9sWPb2LNS8pvxsoAeBg2IC
 PJAqBuvj
 KRoXc2Yg9TmQW0COu0cUUh11fKuW+Rf344xJop52c14vwluCQwvfR2yHkSTVXus0EAVW8/FbgH8qKJacH9Gy/6tYgrMm0BakYtuz2y1cq3VNfMp1LLIXbNb8Mm+Udz9TmJvewSvWvBpRMf2L9T6ddNcBDoAFNMnf8U599dGeC9sMBfGOnUlf1L7HyfV+3mp1gOej846oLeb5sSlbhv9VJVcG2+z+LjZOiHJChDPiooEqi6gNZ7u4eNgTLSYB90IezwrY21ZNpuAuoqGu5i9hhxbLQz5gRYQcSoF2nqbz2Pqnop34YahMUMeVfW+fuD9Biyq9dmqfeCcLkDOCb+qxNZNptMXj18/fzyH0uZRDgufwrOOhS9N2jC96YjKNKXF14AU9BaW1BDIfzNK/TepcKBvdUZ8shUMHBucBkO4yRygxDfVpfSyzU9lz24g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongru Zhang <zhanghongru@xiaomi.com>

The per-VMA lock fault path falls back to mmap_lock on VM_FAULT_RETRY.
When mmap_lock is write-contended, the fallback can reduce page-fault
throughput.

Add a single retry under the per-VMA lock in the arch fault handler
instead of adding a new VM_FAULT_* flag. This avoids overloading
vm_fault_t with retry policy and leaves the lower-level fault handlers
unchanged. It lets faults that can make progress on an immediate retry
stay on the per-VMA lock path, avoiding waits on mmap_lock when it is
write-contended and thereby improving page-fault throughput. Some faults
may retry unnecessarily, for example in the __vmf_anon_prepare() path or
device-private fault handling, but these cases are expected to be
infrequent and only add one cheap per-VMA lock attempt. If the second
attempt still returns VM_FAULT_RETRY, the fault continues through the
existing mmap_lock path.

Based on the stress model from Kunwu Chan and Wang Lian in RFC v2, we
adapted a benchmark [1] to a 20-core Intel i7-12700 desktop by reducing
the thread count and adjusting the memcg limits. The benchmark uses
concurrent page faults under memcg pressure with parallel munmap to
amplify mmap_lock read-write contention.

Filemap Throughput (higher is better):
+---------+------------+---------------------+
| Threads |  Vanilla   |       Patched       |
+---------+------------+---------------------+
|   40    | 1069.34 /s | 1400.13 /s (+30.9%) |
+---------+------------+---------------------+
|   60    | 1038.12 /s | 1683.37 /s (+62.2%) |
+---------+------------+---------------------+
|   80    | 1042.62 /s | 1767.83 /s (+69.6%) |
+---------+------------+---------------------+

mmap_lock contention count (lower is better):
+---------+-----------+---------+-----------+
| Threads |  Vanilla  | Patched | Reduction |
+---------+-----------+---------+-----------+
|   40    | 3,187,336 |  52,086 |  -98.4%   |
+---------+-----------+---------+-----------+
|   60    | 4,385,154 |  65,079 |  -98.5%   |
+---------+-----------+---------+-----------+
|   80    | 5,337,890 |  69,708 |  -98.7%   |
+---------+-----------+---------+-----------+

These results show that retrying once under the per-VMA lock keeps more
file-backed faults on the fast path, improving throughput and reducing
mmap_lock contention.

Using benchmark [2], we tested this on a 20-core Intel i7-12700 desktop
with a 2GB swapfile. The benchmark uses one pressure thread under memcg
limits to keep a 128MB non-zero anonymous mapping under swap pressure,
12 reader threads to fault it back in, and optional mmap writer threads
to amplify mmap_lock read-write contention. Each test ran for 60 seconds
and reported completed reader rounds per second under swap pressure.

Swap Throughput (higher is better):
+--------------+-------------+---------------------------+
| mmap writers |   Vanilla   |          Patched          |
+--------------+-------------+---------------------------+
|      0       | 17303.09 /s | 17899.48 /s       (+3.4%) |
+--------------+-------------+---------------------------+
|      4       | 12596.23 /s | 16095.20 /s      (+27.8%) |
+--------------+-------------+---------------------------+
|      8       |     0.58 /s | 15420.57 /s (+2658619.0%) |
+--------------+-------------+---------------------------+

With increasing mmap_lock write pressure, Vanilla degrades sharply and
drops to near zero at eight writers. Patched kernel holds up much better.

[1] https://gist.github.com/zhr250/c36c2c54d9351df37e12fd072d4926ef
[2] https://gist.github.com/zhr250/218ffe693f842346b56434483127422c

Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Changes since RFC v4:
- Drop `VM_FAULT_MAY_USE_VMA_LOCK` and always retry once under the
  per-VMA lock, based on feedback from Lorenzo and Barry. Thanks!

Changes since RFC v3:
- Keep VM_FAULT_RETRY unchanged and add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit
- Bound VMA-lock retries with FAULT_FLAG_TRIED
- Opt in filemap_fault() and do_swap_page() to VM_FAULT_MAY_USE_VMA_LOCK
- Rebased on mm-unstable

Changes since RFC v2:
- Redesigned as a single blacklist-based patch (v2 was 5 per-path patches)
- Added retry_vma loop to all architectures (not just x86)
- Rebased on mm-unstable

Changes since RFC v1:
- collect tags from Pedro, Kunwu and Lian, thanks!
- handle case (2), for uptodate folios, don't retry PF

Link to RFC v4:
https://lore.kernel.org/lkml/20260804095135.45897-1-zhanghongru@xiaomi.com/

Link to RFC v3:
https://lore.kernel.org/all/20260626075019.1833065-1-zhanghongru@xiaomi.com/

Link to RFC v2:
https://lore.kernel.org/all/20260430040427.4672-1-baohua@kernel.org/

Link to RFC v1:
https://lore.kernel.org/all/20251127011438.6918-1-21cnbao@gmail.com/

 arch/arm/mm/fault.c       | 8 ++++++++
 arch/arm64/mm/fault.c     | 8 ++++++++
 arch/loongarch/mm/fault.c | 8 ++++++++
 arch/powerpc/mm/fault.c   | 7 +++++++
 arch/riscv/mm/fault.c     | 8 ++++++++
 arch/s390/mm/fault.c      | 6 ++++++
 arch/x86/mm/fault.c       | 8 ++++++++
 7 files changed, 53 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index e62cc4be5adf..319fd89c4263 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -340,6 +340,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 	vm_flags_t vm_flags = VM_ACCESS_FLAGS;
+	bool vma_lock_retried = false;
 
 	if (kprobe_page_fault(regs, fsr))
 		return 0;
@@ -391,6 +392,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -420,6 +422,12 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 			goto no_context;
 		return 0;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 retry:
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0b52557652be..b8633863380e 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -610,6 +610,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	struct vm_area_struct *vma;
 	int si_code;
 	int pkey = -1;
+	bool vma_lock_retried = false;
 
 	if (kprobe_page_fault(regs, esr))
 		return 0;
@@ -678,6 +679,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	if (!(mm_flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -724,6 +726,12 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 			goto no_context;
 		return 0;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 retry:
diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
index 2c93d33356e5..ef6ea847b1e0 100644
--- a/arch/loongarch/mm/fault.c
+++ b/arch/loongarch/mm/fault.c
@@ -181,6 +181,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 	struct mm_struct *mm = tsk->mm;
 	struct vm_area_struct *vma = NULL;
 	vm_fault_t fault;
+	bool vma_lock_retried = false;
 
 	if (kprobe_page_fault(regs, current->thread.trap_nr))
 		return;
@@ -219,6 +220,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -265,6 +267,12 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 			no_context(regs, write, address);
 		return;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 retry:
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 806c74e0d5ab..06018b6d7086 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -422,6 +422,7 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	int is_write = page_fault_is_write(error_code);
 	vm_fault_t fault, major = 0;
 	bool kprobe_fault = kprobe_page_fault(regs, 11);
+	bool vma_lock_retried = false;
 
 	if (unlikely(debugger_fault_handler(regs) || kprobe_fault))
 		return 0;
@@ -487,6 +488,7 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -517,6 +519,11 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (fault_signal_pending(fault, regs))
 		return user_mode(regs) ? 0 : SIGBUS;
 
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 	/* When running in the kernel we expect faults to occur only to
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 04ed6f8acae4..ff861793dba9 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -284,6 +284,7 @@ void handle_page_fault(struct pt_regs *regs)
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 	int code = SEGV_MAPERR;
 	vm_fault_t fault;
+	bool vma_lock_retried = false;
 
 	cause = regs->cause;
 	addr = regs->badaddr;
@@ -347,6 +348,7 @@ void handle_page_fault(struct pt_regs *regs)
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -376,6 +378,12 @@ void handle_page_fault(struct pt_regs *regs)
 			no_context(regs, addr);
 		return;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 retry:
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 028aeb9c48d6..faae0e91b90b 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -271,6 +271,7 @@ static void do_exception(struct pt_regs *regs, int access)
 	unsigned int flags;
 	vm_fault_t fault;
 	bool is_write;
+	bool vma_lock_retried = false;
 
 	/*
 	 * The instruction that caused the program check has
@@ -294,6 +295,7 @@ static void do_exception(struct pt_regs *regs, int access)
 		flags |= FAULT_FLAG_WRITE;
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -318,6 +320,10 @@ static void do_exception(struct pt_regs *regs, int access)
 			handle_fault_error_nolock(regs, 0);
 		return;
 	}
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
 lock_mmap:
 retry:
 	vma = lock_mm_and_find_vma(mm, address, regs);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..c3ab30d32a15 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct mm_struct *mm;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
+	bool vma_lock_retried = false;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1360,6 +1362,12 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 retry:

base-commit: e737cebb8de0d38e8f64584a8bbfbcf9176c7537
-- 
2.43.0


