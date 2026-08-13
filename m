Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7A5C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511C76B05AB; Thu, 13 Aug 2026 15:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A8B6B05B1; Thu, 13 Aug 2026 15:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363356B05B2; Thu, 13 Aug 2026 15:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5316B05AB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:34:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AE3AC0262
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:43 +0000 (UTC)
X-FDA: 85097248446.26.90C43F3
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B32C1C0009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y02GRQF3;
	spf=pass (imf21.hostedemail.com: domain of 3Txx-agYKCNoOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3Txx-agYKCNoOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVKDsEOiP5XOiV/zYnMVBB6cDeA7ADkLeaf/81j+3TA=;
	b=wH7C8fU4zHXM7kCyiU3OmfwhHGNG8SX3Yl19gXDJWKne2BxoMSMmtM5ABCZydgH1W8GnM/
	yMWdcRe6Bo/UkVE01lEJ8mqQOZTjWc6+G+NCXruq548ouC8kcR5a4elFcFByyJZo1JbHPX
	i3+PK4OY2No22V5BaH+QPVqPgkxEOiE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y02GRQF3;
	spf=pass (imf21.hostedemail.com: domain of 3Txx-agYKCNoOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3Txx-agYKCNoOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649681;
	b=nhMS+hZhi7DZmAeDxqthJEGxv5fTueJWedWppaEBeHp4yHW9RjNaAKLIvVmkNJGWceDh4e
	hL4e1nYujyK+rbKWdDp6xMy8QsxRPC2NGe1/ap3oZ4Hbmi/rzvWUIiH0m94cku69aXN/b2
	in1PAG12p2pBY5aMtJsjNTgVD22IJQg=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb5cc1e13f8so145023a12.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786649680; x=1787254480; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QVKDsEOiP5XOiV/zYnMVBB6cDeA7ADkLeaf/81j+3TA=;
        b=Y02GRQF3Cn61/UslV8FGQpMCw37p+LZye0CJ+mRiahLkMYIdJctkxxfiL6b20Va1+e
         /IkW0xe8EFe12mPPTzqcnt3kNXawMQ2gFa+wGmH+00ry2a/UZdhvhehjIlVb7SgDqpDb
         wL557y5Ckq8kCxJWpPn96PkordQvyG3awih1kmzwphndpqY70FexDgeg4QY4UjxocdpB
         oBB4g7DvUlwvMChL4tv7f4c32235+yxKxMya6dyYUiN011dmehpBNi9M3DKO1BkKMkll
         R/899EsA4mrl6ZPl2WX5umU7lZyj9zlnVnUoUP1nRQWB7tPu3/Gw66mdNSdrXfQuYEVx
         z/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786649680; x=1787254480;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QVKDsEOiP5XOiV/zYnMVBB6cDeA7ADkLeaf/81j+3TA=;
        b=bC9BZMR2X7VsP4cui7zeb6gbfRp66cy+rjxdoqCMTiO3nAaMPZ+lZh0GIZYgRhbgh2
         jcU43d0nSGs1vQqgt4vNgVixY/OVTD/ho1Ok9jVWhw/PyDcWJRhCZWFIfqphfTdL5Ptk
         ty2xqw3aWMdIVlF8sv6ZfX3peGwfARwUuun9dHx1mqHYdJ5o+DBBkEQp/WSm4+hWdKGp
         tB13EQW0sEczTfnZrQVMFGzZ9mzjCU4l5g0JxwMGw6mv5EGbz4vyAz2fyKJb1M750zoA
         3IL+hxeu9U52DRlJ4Q4JAaUxlQxPaoYm0MOsqcVDlphUej8YuKzTXnHL5h/7lSbSA4Ds
         dU4g==
X-Forwarded-Encrypted: i=1; AHgh+RrM2CFz7b+EFVCVTS/tZZn8/0mTE1HvoZpDcZB/oQ5r3+tFZfXAyGk7BYh03fPv+wrJZgpMf5oSTA==@kvack.org
X-Gm-Message-State: AOJu0YwuAzuFun6CrdCReXgyd8FgdR2eycRSxezLzmwRGJ6jBWazA7T1
	37QxjVr/YSHT87kPfB70idRH5VZBTWG0GXDHkpz/lluGX8Sei1IvyHOuGYLdpD97JDCJagu2zvX
	BWENfqQ==
X-Received: from dlbvg26.prod.google.com ([2002:a05:7022:7f1a:b0:13c:dac9:90ed])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939f:b0:3c3:a1ed:3c36
 with SMTP id adf61e73a8af0-3cc71cef032mr121010637.24.1786649679638; Thu, 13
 Aug 2026 12:34:39 -0700 (PDT)
Date: Thu, 13 Aug 2026 12:34:29 -0700
In-Reply-To: <20260813193433.3318288-1-surenb@google.com>
Mime-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260813193433.3318288-2-surenb@google.com>
Subject: [PATCH v6 1/5] mm: Make per-VMA locks available universally
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B32C1C0009
X-Stat-Signature: efmfu4kgot637drjbi6urey5dracgzar
X-Rspam-User: 
X-HE-Tag: 1786649681-290560
X-HE-Meta: U2FsdGVkX1/pxBOEojIw/F0VwYcmr3hhGL+R1NYJNqqEBdET7+g+NfsJ67Ekcx3O4VzuHPKwNLlsV2FkBWy06iTpt2ctk8Du0rvI7CgxFC37E+2lvdPs+2fBnDG+eDTmD4Nu9xLDRdVCOZ93PXrqCfqe3sepYbNJVyLCB2MdWF59vExa6Kd8Y1a+Hs5vIZHJ8xWqSX+J9q8+8zDAyACwexUlSdETUkgLHCx7ShXiFhL5vMWYHWOWvjqQQT9QirYhczKC7ayhzP2ASMYbS7wAplc1oc2nInfM7HN2YXSkAVSRIHdZof31Eg9uCedYaJ/jjWkcQBzWScWPqiYyEvNGJTC94YplXVRR59t1qKCmeaRqIzYhgGFe1veX7ilsrDeCkSb9CJHkf6X7rbqDVdsKDFMX+mDsL0AQUr2yo9NpnQjR1Cy3FhIOCaHRgaASRmgjiRYZ/96an0A82vWu5r2MpgFEA/qObabLktawKcqeovjIXnrlA0JYxA2HoytmnW6VOaXZ/uVJH3i+uSHFtnD+4TBx/xvujGW5XuLGv6xqYECoAhYxMtHRjKLC3fwlw/TOgPJa2Koz9L9M7KDQw7DTPqlzLhMN6RQDypqN48eLSZtnb5c8rkC8RsYFO0u2kZBR06yJqxcJ0vQ/WHvJHf3WQQzfQybdUMomIhPsx758Yw3tJ4/7UXW0434Xgjv5SGDIsUwWBs6GJZDbszeeQdFRZgpzTRS29up0dQeNlw1loNvfDmU7FzC6DaYzOZXOUQ3gEzy8PkDlRZTVe41I7W7ABaqdKk1D2x75udVxrYYGc6UyJeLklkp7ATYUYaKvir57+5Jd48kcSG4AfD2pibvVQB7NBVbPM8D658tIaFpa71b6y1OBPkaKSiis4J4tDUywDPzEWv1ijBCrUey+JqW8K9eaS2J34cNlyXd4jKBMawyzwtx48idhdj9U0eMPjsF1c3ZIxkeJywkpZwo+9Cy
 mwo3aOwA
 T87ACBR44g/uWASiDnhvDmYRoI53RyPiZeSte0x8ut9MvBsnxPhU0FXN415gwBM8s1mXnvFvxAKquBHqOiS1QYvnHJqgf28VW9fFxKVPhKhutFitngQ7I8iRTXhcbsDX6C0yuAyRPn8nOqxU7sJ2DCE8pnypEBwn8+NkUzdBMUFxo4VF+hiKs08JEeUGkuPYaTcOc/2lpffhOfgOyWbX7f/4b1DgROY+R9lXbak0OpBQLpHain5O0ZGct2Fx0CG/iabYIOcUiWTG1s8kLJKk58eATXf//yApOJGRSAj0n9wpdrXnTg7TYeqw85qxBPj4xxN7t0qPJ3ks06RFwwR+Mnh48T5rpQrQMa0o/LKubR7J8JvZBHI8hXq6QyTZjnbooULdwe8UntdpzxEE+OXj0Aq+V/97GUBytnYBv6dP6vrcbZPk3HpDCPobrB2XQDd93uzXg8nwf9AzfV7cFzOhork3KK/If2HLH1bp3/roc9UC+EUjUW04Jfa2nR0TexgHT2xs+Ozw1jL1kIrMmM//RJlYctzfr4RR92LXj3pPaH/CSuttlahO2W+Hn3Hfm8x1w83jPUD/4ifcPZ5trp8n6e/TDEurG2tZFbhAcRx/OCVKBCfFwLIM4Nb5kogUutZFHXcFj5lYWnAfEtFvaKqS8Ys+gOL5loPOJfBnV3oNUmyg18dhp6ppPf09RutnxWnIVMHnbaIkmf8iC0XwHzQiHLH2xWB1QwUzgrDFrhWrJPdFD69rVUZD4qhHiQ07Ic78Cz4Ik82YAVzMoe4QOw2yxQWhYmMxuVFi3i09/EunxKiRWvYNsxPnvZQgnSeWsPsmTSHBI/VrS//GDRXERxSLpuTK3fQEemmYfQu5vvSKuWCNsamxSpVyrLIihpWcWjx1GliwWQdNVUOdG1icmAsqakwfKBPQU9GUcLRgVYki4sxUPQNXQZTRjPY9tLIFr81gK3xxuN7zPPCNvFhFKZeeuNIAffPh/
 CX6qbR4d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

The per-VMA locks have been around for several years. They've had some
bugs worked out of them and have seen quite wide use. However, they
are still only available when architectures explicitly enable them.
Remove the conditional compilation around the per-VMA locks, making
them available on all architectures and configs.

The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
when the architecture started using per-VMA locks in the fault
handler. But, contrary to the naming, the Kconfig option does not
really indicate whether the architecture supports per-VMA locks or
not. It is more of a marker for whether the architecture is likely to
benefit from per-VMA locks.

To me, the most important thing side-effect of universal availability
is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
per-VMA locking in all x86 code without fallbacks.

Overall, this just generally makes the kernel simpler. Just look at
the diffstat. It also opens the door to users that want to use the
per-VMA locks in common code. Doing *that* brings additional
simplifications.

The downside of this is adding some fields to vm_area_struct and
mm_struct. There are likely ways to optimize this, especially for
things like SMP=3Dn configs. For now, do the simplest thing: use the
same implementation everywhere.

=3D=3D Considerations for NOMMU config =3D=3D

NOMMU systems do not write-lock VMAs, therefore read-locking a VMA
would always succeed unless VMA is detached. Therefore for NOMMU
config we make vma_mark_attached() a NOOP, which keeps VMAs always in
detached state. This causes VMA read-locking to always fail and the
caller falls back to locking mmap_lock.

The following functions will have a different implementation in NOMMU
config:

- vma_mark_attached(), vma_mark_detached() are made NOOPs, keeping VMAs
always in a detached state and preventing assertions and refcount
underflows;

- vma_start_write(), vma_start_write_killable() are made NOOPs to avoid
warnings in __vma_start_write() due to VMAs being detached.
These functions are not used in NOMMU code but __vma_start_write()
is an exported function, therefore might be used by drivers.

- vma_assert_attached() is made NOOP because it's reachable from NOMMU
code via split_vma()->vma_iter_store_new()->vma_iter_store_overwrite();

- vma_assert_write_locked() is asserting vma->vm_mm is write-locked, as
was done before this change;

- vma_assert_locked() is asserting vma->vm_mm is locked, as was done
before this change;

The following functions work for both MMU and NOMMU configs:

- vma_lock_init() performs the same initialization as for MMU config;

- mm_lock_seqcount_init(), mm_lock_seqcount_begin(), mm_lock_seqcount_end()
are called from mmap_write_{lock|unlock} and update mm_lock_seq correctly.

- mmap_lock_speculate_try_begin(), mmap_lock_speculate_retry() work as is
because mm_lock_seq is updated correctly;

- vma_start_read(), vma_start_read_locked() will always fail because VMAs
are always detached;

- vma_end_read() will never be called because vma_start_read() never
succeeds;

- vma_is_attached() always return false because VMAs are always detached;

- vma_assert_detached() will never trigger because VMAs are never attached;

- vma_start_read_locked() always return false because VMAs are always
detached;

- lock_vma_under_rcu() will be safe as the attempted read lock will bail;

Changes in the following files are not affecting NOMMU config:

task_mmu.c - not compiled when CONFIG_MMU=3Dn;
pagewalk.c - not compiled when CONFIG_MMU=3Dn;
userfaultfd.c - not compiled when CONFIG_MMU=3Dn (CONFIG_USERFAULTFD depend=
s
on CONFIG_MMU);

The following changes in the BPF code are made to keep NOMMU config
working like before:

stack_map_lock_vma() - keeps mmap_lock in NOMMU config;
bpf_iter_task_vma_new() - bails out in NOMMU config;

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 arch/arm/Kconfig                       |  1 -
 arch/arm64/Kconfig                     |  1 -
 arch/loongarch/Kconfig                 |  1 -
 arch/powerpc/platforms/powernv/Kconfig |  1 -
 arch/powerpc/platforms/pseries/Kconfig |  1 -
 arch/riscv/Kconfig                     |  1 -
 arch/s390/Kconfig                      |  1 -
 arch/x86/Kconfig                       |  2 -
 fs/proc/internal.h                     |  2 -
 fs/proc/task_mmu.c                     | 93 --------------------------
 include/linux/mm.h                     | 12 ----
 include/linux/mm_types.h               |  8 +--
 include/linux/mmap_lock.h              | 75 +++++++--------------
 kernel/bpf/stackmap.c                  | 17 ++---
 kernel/bpf/task_iter.c                 |  2 +-
 kernel/fork.c                          |  2 -
 mm/Kconfig                             | 12 ----
 mm/Kconfig.debug                       |  1 -
 mm/debug.c                             |  4 --
 mm/init-mm.c                           |  2 -
 mm/memory.c                            |  2 -
 mm/mmap_lock.c                         | 26 +------
 mm/pagewalk.c                          |  2 -
 mm/rmap.c                              |  2 -
 mm/userfaultfd.c                       | 55 ---------------
 rust/kernel/mm.rs                      | 32 +++------
 tools/testing/vma/include/dup.h        |  5 +-
 tools/testing/vma/vma_internal.h       |  1 -
 28 files changed, 48 insertions(+), 316 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9187240a02db..f815209167cd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -41,7 +41,6 @@ config ARM
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_CFI
 	select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 11a9c534b7b4..21eb64b24a2c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -81,7 +81,6 @@ config ARM64
 	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SCHED_SMT
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index e20acbe5fe7b..7741e39eca2b 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -69,7 +69,6 @@ config LOONGARCH
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_HAS_PTE_PROTNONE if 64BIT
 	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platform=
s/powernv/Kconfig
index b5ad7c173ef0..dd8f6060fb7a 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -17,7 +17,6 @@ config PPC_POWERNV
 	select PPC_DOORBELL
 	select MMU_NOTIFIER
 	select FORCE_SMP
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
 	default y
=20
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platform=
s/pseries/Kconfig
index 74910ce3a541..7d125e288f6e 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -23,7 +23,6 @@ config PPC_PSERIES
 	select HOTPLUG_CPU
 	select FORCE_SMP
 	select SWIOTLB
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
 	default y
=20
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 7b9c373d82fa..faa85a031fe5 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -70,7 +70,6 @@ config RISCV
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
-	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
 	select ARCH_HAS_PTE_PROTNONE if MMU
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ab8fccc2cc4e..d1274bca8c39 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -151,7 +151,6 @@ config S390
 	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_SYM_ANNOTATIONS
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fb298e219179..79479d29576f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -27,7 +27,6 @@ config X86_64
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_SOFT_DIRTY
 	select MODULES_USE_ELF_RELA
@@ -1846,7 +1845,6 @@ config X86_USER_SHADOW_STACK
 	bool "X86 userspace shadow stack"
 	depends on AS_WRUSS
 	depends on X86_64
-	depends on PER_VMA_LOCK
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_USER_SHADOW_STACK
 	select X86_CET
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index b232e1098117..6713757da099 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -385,10 +385,8 @@ struct mem_size_stats;
=20
 struct proc_maps_locking_ctx {
 	struct mm_struct *mm;
-#ifdef CONFIG_PER_VMA_LOCK
 	bool mmap_locked;
 	struct vm_area_struct *locked_vma;
-#endif
 };
=20
 struct proc_maps_private {
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe2118..e671b4fd8ded 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -130,8 +130,6 @@ static void release_task_mempolicy(struct proc_maps_pri=
vate *priv)
 }
 #endif
=20
-#ifdef CONFIG_PER_VMA_LOCK
-
 static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	int ret =3D mmap_read_lock_killable(lock_ctx->mm);
@@ -233,46 +231,6 @@ static inline void reacquire_rcu(struct proc_maps_priv=
ate *priv)
 	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
 }
=20
-#else /* CONFIG_PER_VMA_LOCK */
-
-static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
-{
-	return mmap_read_lock_killable(lock_ctx->mm);
-}
-
-static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
-{
-	mmap_read_unlock(lock_ctx->mm);
-}
-
-static inline bool lock_vma_range(struct seq_file *m,
-				  struct proc_maps_locking_ctx *lock_ctx)
-{
-	return lock_ctx_mm(lock_ctx) =3D=3D 0;
-}
-
-static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx=
)
-{
-	unlock_ctx_mm(lock_ctx);
-}
-
-static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
-					   loff_t last_pos)
-{
-	return vma_next(&priv->iter);
-}
-
-static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
-					 loff_t pos)
-{
-	return false;
-}
-
-static inline void drop_rcu(struct proc_maps_private *priv) {}
-static inline void reacquire_rcu(struct proc_maps_private *priv) {}
-
-#endif /* CONFIG_PER_VMA_LOCK */
-
 static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppo=
s)
 {
 	struct proc_maps_private *priv =3D m->private;
@@ -560,8 +518,6 @@ static int pid_maps_open(struct inode *inode, struct fi=
le *file)
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
=20
-#ifdef CONFIG_PER_VMA_LOCK
-
 static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
 {
 	reset_lock_ctx(lock_ctx);
@@ -612,26 +568,6 @@ static struct vm_area_struct *query_vma_find_by_addr(s=
truct proc_maps_locking_ct
 	return vma;
 }
=20
-#else /* CONFIG_PER_VMA_LOCK */
-
-static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
-{
-	return mmap_read_lock_killable(lock_ctx->mm);
-}
-
-static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
-{
-	mmap_read_unlock(lock_ctx->mm);
-}
-
-static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_lock=
ing_ctx *lock_ctx,
-						     unsigned long addr)
-{
-	return find_vma(lock_ctx->mm, addr);
-}
-
-#endif  /* CONFIG_PER_VMA_LOCK */
-
 static struct vm_area_struct *query_matching_vma(struct proc_maps_locking_=
ctx *lock_ctx,
 						 unsigned long addr, u32 flags)
 {
@@ -1314,8 +1250,6 @@ static const struct mm_walk_ops smaps_shmem_walk_ops =
=3D {
 	.walk_lock		=3D PGWALK_RDLOCK,
 };
=20
-#ifdef CONFIG_PER_VMA_LOCK
-
 static const struct mm_walk_ops smaps_walk_vma_lock_ops =3D {
 	.pmd_entry		=3D smaps_pte_range,
 	.hugetlb_entry		=3D smaps_hugetlb_range,
@@ -1345,22 +1279,6 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *p=
riv)
 	return &smaps_shmem_walk_vma_lock_ops;
 }
=20
-#else /* CONFIG_PER_VMA_LOCK */
-
-static inline const struct mm_walk_ops *
-get_smaps_walk_ops(struct proc_maps_private *priv)
-{
-	return &smaps_walk_ops;
-}
-
-static inline const struct mm_walk_ops *
-get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
-{
-	return &smaps_shmem_walk_ops;
-}
-
-#endif /* CONFIG_PER_VMA_LOCK */
-
 /*
  * Gather mem stats from @vma with the indicated beginning
  * address @start, and keep them in @mss.
@@ -3497,7 +3415,6 @@ static const struct mm_walk_ops show_numa_ops =3D {
 	.walk_lock =3D PGWALK_RDLOCK,
 };
=20
-#ifdef CONFIG_PER_VMA_LOCK
 static const struct mm_walk_ops show_numa_vma_lock_ops =3D {
 	.hugetlb_entry =3D gather_hugetlb_stats,
 	.pmd_entry =3D gather_pte_stats,
@@ -3512,16 +3429,6 @@ get_show_numa_ops(struct proc_maps_private *priv)
 	return &show_numa_vma_lock_ops;
 }
=20
-#else /* CONFIG_PER_VMA_LOCK */
-
-static inline const struct mm_walk_ops *
-get_show_numa_ops(struct proc_maps_private *priv)
-{
-	return &show_numa_ops;
-}
-
-#endif /* CONFIG_PER_VMA_LOCK */
-
 /*
  * Display pages allocated per node and memory policy via /proc.
  */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f940d20551d5..73a6244e1dd0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -931,7 +931,6 @@ static inline void vma_numab_state_free(struct vm_area_=
struct *vma) {}
  * These must be here rather than mmap_lock.h as dependent on vm_fault typ=
e,
  * declared in this header.
  */
-#ifdef CONFIG_PER_VMA_LOCK
 static inline void release_fault_lock(struct vm_fault *vmf)
 {
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
@@ -947,17 +946,6 @@ static inline void assert_fault_locked(const struct vm=
_fault *vmf)
 	else
 		mmap_assert_locked(vmf->vma->vm_mm);
 }
-#else
-static inline void release_fault_lock(struct vm_fault *vmf)
-{
-	mmap_read_unlock(vmf->vma->vm_mm);
-}
-
-static inline void assert_fault_locked(const struct vm_fault *vmf)
-{
-	mmap_assert_locked(vmf->vma->vm_mm);
-}
-#endif /* CONFIG_PER_VMA_LOCK */
=20
 static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
 {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6d815f6440c9..5413bd10fff2 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -950,7 +950,6 @@ struct vm_area_struct {
 		vma_flags_t flags;
 	};
=20
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
@@ -966,7 +965,7 @@ struct vm_area_struct {
 	 * slowpath.
 	 */
 	unsigned int vm_lock_seq;
-#endif
+
 	/*
 	 * Low 32-bits of anonymous page offset.
 	 * See vma_start_anon_pgoff() comment for details.
@@ -1003,7 +1002,6 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA_BALANCING
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Used to keep track of firstly, whether the VMA is attached, secondly,
 	 * if attached, how many read locks are taken, and thirdly, if the
@@ -1046,7 +1044,6 @@ struct vm_area_struct {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
 #endif
-#endif
 #ifdef CONFIG_64BIT
 	/*
 	 * High 32-bits of anonymous page offset.
@@ -1254,7 +1251,6 @@ struct mm_struct {
 					  * init_mm.mmlist, and are protected
 					  * by mmlist_lock
 					  */
-#ifdef CONFIG_PER_VMA_LOCK
 		struct rcuwait vma_writer_wait;
 		/*
 		 * This field has lock-like semantics, meaning it is sometimes
@@ -1274,7 +1270,7 @@ struct mm_struct {
 		 * mmap_lock.
 		 */
 		seqcount_t mm_lock_seq;
-#endif
+
 		struct futex_mm_data	futex;
=20
 		unsigned long hiwater_rss; /* High-watermark of RSS usage */
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 87f77e3da77f..db2dbf84943c 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -76,8 +76,6 @@ static inline void mmap_assert_write_locked(const struct =
mm_struct *mm)
 	rwsem_assert_held_write(&mm->mmap_lock);
 }
=20
-#ifdef CONFIG_PER_VMA_LOCK
-
 #ifdef CONFIG_LOCKDEP
 #define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
 #else
@@ -297,6 +295,9 @@ int __vma_start_write(struct vm_area_struct *vma, int s=
tate);
  */
 static inline void vma_start_write(struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_MMU))
+		return;
+
 	if (__is_vma_write_locked(vma))
 		return;
=20
@@ -319,6 +320,9 @@ static inline void vma_start_write(struct vm_area_struc=
t *vma)
 static inline __must_check
 int vma_start_write_killable(struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_MMU))
+		return 0;
+
 	if (__is_vma_write_locked(vma))
 		return 0;
=20
@@ -331,6 +335,11 @@ int vma_start_write_killable(struct vm_area_struct *vm=
a)
  */
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_MMU)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		return;
+	}
+
 	VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
 }
=20
@@ -343,6 +352,11 @@ static inline void vma_assert_locked(struct vm_area_st=
ruct *vma)
 {
 	unsigned int refcnt;
=20
+	if (!IS_ENABLED(CONFIG_MMU)) {
+		mmap_assert_locked(vma->vm_mm);
+		return;
+	}
+
 	if (IS_ENABLED(CONFIG_LOCKDEP)) {
 		if (!lock_is_held(__vma_lockdep_map(vma)))
 			vma_assert_write_locked(vma);
@@ -432,6 +446,9 @@ static inline bool vma_is_attached(struct vm_area_struc=
t *vma)
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_MMU))
+		return;
+
 	WARN_ON_ONCE(!vma_is_attached(vma));
 }
=20
@@ -442,6 +459,9 @@ static inline void vma_assert_detached(struct vm_area_s=
truct *vma)
=20
 static inline void vma_mark_attached(struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_MMU))
+		return;
+
 	vma_assert_write_locked(vma);
 	vma_assert_detached(vma);
 	refcount_set_release(&vma->vm_refcnt, 1);
@@ -451,6 +471,9 @@ void __vma_exclude_readers_for_detach(struct vm_area_st=
ruct *vma);
=20
 static inline void vma_mark_detached(struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_MMU))
+		return;
+
 	vma_assert_write_locked(vma);
 	vma_assert_attached(vma);
=20
@@ -484,54 +507,6 @@ struct vm_area_struct *lock_next_vma(struct mm_struct =
*mm,
 				     struct vma_iterator *iter,
 				     unsigned long address);
=20
-#else /* CONFIG_PER_VMA_LOCK */
-
-static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
-static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
-static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
-
-static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm, uns=
igned int *seq)
-{
-	return false;
-}
-
-static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigne=
d int seq)
-{
-	return true;
-}
-static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_re=
fcnt) {}
-static inline void vma_end_read(struct vm_area_struct *vma) {}
-static inline void vma_start_write(struct vm_area_struct *vma) {}
-static inline __must_check
-int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
-		{ mmap_assert_write_locked(vma->vm_mm); }
-static inline bool vma_is_attached(struct vm_area_struct *vma)
-		{ return true; }
-static inline void vma_assert_attached(struct vm_area_struct *vma) {}
-static inline void vma_assert_detached(struct vm_area_struct *vma) {}
-static inline void vma_mark_attached(struct vm_area_struct *vma) {}
-static inline void vma_mark_detached(struct vm_area_struct *vma) {}
-
-static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *=
mm,
-		unsigned long address)
-{
-	return NULL;
-}
-
-static inline void vma_assert_locked(struct vm_area_struct *vma)
-{
-	mmap_assert_locked(vma->vm_mm);
-}
-
-static inline void vma_assert_stabilised(struct vm_area_struct *vma)
-{
-	/* If no VMA locks, then either mmap lock suffices to stabilise. */
-	mmap_assert_locked(vma->vm_mm);
-}
-
-#endif /* CONFIG_PER_VMA_LOCK */
-
 static inline void vma_assert_can_modify(struct vm_area_struct *vma)
 {
 	if (vma_is_attached(vma))
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 41fe87d7302f..6bd6022b6b84 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -272,13 +272,10 @@ struct stack_map_vma_lock {
 /*
  * Acquire a stable read-side reference on the VMA covering @ip.
  *
- * With CONFIG_PER_VMA_LOCK=3Dy this returns a VMA with its per-VMA read
- * lock held and mmap_lock dropped, so the caller may sleep.
- *
- * With CONFIG_PER_VMA_LOCK=3Dn it returns a VMA with mmap_lock still
- * held; the caller must snapshot any fields it needs and pin vm_file
- * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
- * the VMA may be split, merged, or freed after that.
+ * On NOMMU configurations, returns with the mmap_lock held.  If the MMU
+ * is enabled, the per-VMA lock will be held instead.  The lock
+ * should be released with stack_map_unlock_vma() which will release the
+ * appropriate lock.  Once the lock is released, the VMA may be freed.
  *
  * Returns NULL on failure, in which case no lock is held.
  */
@@ -288,7 +285,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, uns=
igned long ip)
 	struct mm_struct *mm =3D lock->mm;
 	struct vm_area_struct *vma;
=20
-	/* noop under !CONFIG_PER_VMA_LOCK */
 	vma =3D lock_vma_under_rcu(mm, ip);
 	if (vma) {
 		lock->vma =3D vma;
@@ -308,21 +304,20 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, u=
nsigned long ip)
 		return NULL;
 	}
=20
-#ifdef CONFIG_PER_VMA_LOCK
+#ifdef CONFIG_MMU
 	if (!vma_start_read_locked(vma)) {
 		mmap_read_unlock(mm);
 		return NULL;
 	}
 	mmap_read_unlock(mm);
 #endif
-
 	lock->vma =3D vma;
 	return vma;
 }
=20
 static void stack_map_unlock_vma(struct stack_map_vma_lock *lock)
 {
-#ifdef CONFIG_PER_VMA_LOCK
+#ifdef CONFIG_MMU
 	vma_end_read(lock->vma);
 #else
 	mmap_read_unlock(lock->mm);
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index e791ae065c39..245f74ec491d 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -835,7 +835,7 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_t=
ask_vma *it,
 	BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) !=3D sizeof(struct bpf=
_iter_task_vma));
 	BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) !=3D __alignof__(=
struct bpf_iter_task_vma));
=20
-	if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
+	if (!IS_ENABLED(CONFIG_MMU)) {
 		kit->data =3D NULL;
 		return -EOPNOTSUPP;
 	}
diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a9a5..ff91f5f66c80 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1077,9 +1077,7 @@ static void mmap_init_lock(struct mm_struct *mm)
 {
 	init_rwsem(&mm->mmap_lock);
 	mm_lock_seqcount_init(mm);
-#ifdef CONFIG_PER_VMA_LOCK
 	rcuwait_init(&mm->vma_writer_wait);
-#endif
 }
=20
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct =
*p)
diff --git a/mm/Kconfig b/mm/Kconfig
index 8a24c130d008..bf89d7d3be4b 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1429,18 +1429,6 @@ config LRU_GEN_WALKS_MMU
 	depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
 # }
=20
-config ARCH_SUPPORTS_PER_VMA_LOCK
-       def_bool n
-
-config PER_VMA_LOCK
-	def_bool y
-	depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
-	help
-	  Allow per-vma locking during page fault handling.
-
-	  This feature allows locking each virtual memory area separately when
-	  handling page faults instead of taking mmap_lock.
-
 config LOCK_MM_AND_FIND_VMA
 	bool
 	depends on !STACK_GROWSUP
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 5737a504efbb..1dd150edfe71 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -310,7 +310,6 @@ config DEBUG_KMEMLEAK_VERBOSE
=20
 config PER_VMA_LOCK_STATS
 	bool "Statistics for per-vma locks"
-	depends on PER_VMA_LOCK
 	help
 	  Say Y here to enable success, retry and failure counters of page
 	  faults handled under protection of per-vma locks. When enabled, the
diff --git a/mm/debug.c b/mm/debug.c
index 9a0297b3988d..655e6bcc0e8d 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -157,17 +157,13 @@ void dump_vma(const struct vm_area_struct *vma)
 	pr_emerg("vma %px start %px end %px mm %px\n"
 		"prot %lx anon_vma %px vm_ops %px\n"
 		"pgoff %lx file %px private_data %px\n"
-#ifdef CONFIG_PER_VMA_LOCK
 		"refcnt %x\n"
-#endif
 		"flags: %#lx(%pGv)\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_mm,
 		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma_start_pgoff(vma),
 		vma->vm_file, vma->vm_private_data,
-#ifdef CONFIG_PER_VMA_LOCK
 		refcount_read(&vma->vm_refcnt),
-#endif
 		vma->vm_flags, &vma->vm_flags);
 }
 EXPORT_SYMBOL(dump_vma);
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 3e792aad7626..a1bb2c2d0284 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -39,10 +39,8 @@ struct mm_struct init_mm =3D {
 	.page_table_lock =3D  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.arg_lock	=3D  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
 	.mmlist		=3D LIST_HEAD_INIT(init_mm.mmlist),
-#ifdef CONFIG_PER_VMA_LOCK
 	.vma_writer_wait =3D __RCUWAIT_INITIALIZER(init_mm.vma_writer_wait),
 	.mm_lock_seq	=3D SEQCNT_ZERO(init_mm.mm_lock_seq),
-#endif
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock =3D __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 4134ac607ee0..21a4d95cb409 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6818,7 +6818,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_area=
_struct *vma,
 				 !vma_is_cow_mapping(vma)))
 			return VM_FAULT_SIGSEGV;
 	}
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT because of
 	 * the assumption that lock is dropped on VM_FAULT_RETRY.
@@ -6827,7 +6826,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_area=
_struct *vma,
 			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) =3D=3D
 			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
 		return VM_FAULT_SIGSEGV;
-#endif
=20
 	return 0;
 }
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 898c2ef1e958..272f9ac762b9 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -43,9 +43,6 @@ void __mmap_lock_do_trace_released(struct mm_struct *mm, =
bool write)
 EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #endif /* CONFIG_TRACING */
=20
-#ifdef CONFIG_MMU
-#ifdef CONFIG_PER_VMA_LOCK
-
 /* State shared across __vma_[start, end]_exclude_readers. */
 struct vma_exclude_readers_state {
 	/* Input parameters. */
@@ -299,6 +296,8 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_str=
uct *mm,
 	MA_STATE(mas, &mm->mm_mt, address, address);
 	struct vm_area_struct *vma;
=20
+	if (!IS_ENABLED(CONFIG_MMU))
+		return NULL;
 retry:
 	rcu_read_lock();
 	vma =3D mas_walk(&mas);
@@ -431,7 +430,6 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *=
mm,
=20
 	return vma;
 }
-#endif /* CONFIG_PER_VMA_LOCK */
=20
 #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
 #include <linux/extable.h>
@@ -548,23 +546,3 @@ struct vm_area_struct *lock_mm_and_find_vma(struct mm_=
struct *mm,
 	return NULL;
 }
 #endif /* CONFIG_LOCK_MM_AND_FIND_VMA */
-
-#else /* CONFIG_MMU */
-
-/*
- * At least xtensa ends up having protection faults even with no
- * MMU.. No stack expansion, at least.
- */
-struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
-			unsigned long addr, struct pt_regs *regs)
-{
-	struct vm_area_struct *vma;
-
-	mmap_read_lock(mm);
-	vma =3D vma_lookup(mm, addr);
-	if (!vma)
-		mmap_read_unlock(mm);
-	return vma;
-}
-
-#endif /* CONFIG_MMU */
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index cc07fcf50e87..7411702a37f5 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -444,7 +444,6 @@ static inline void process_mm_walk_lock(struct mm_struc=
t *mm,
 static inline void process_vma_walk_lock(struct vm_area_struct *vma,
 					 enum page_walk_lock walk_lock)
 {
-#ifdef CONFIG_PER_VMA_LOCK
 	switch (walk_lock) {
 	case PGWALK_WRLOCK:
 		vma_start_write(vma);
@@ -459,7 +458,6 @@ static inline void process_vma_walk_lock(struct vm_area=
_struct *vma,
 		/* PGWALK_RDLOCK is handled by process_mm_walk_lock */
 		break;
 	}
-#endif
 }
=20
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 14f2f9b07572..7515220dfea4 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -260,11 +260,9 @@ static void check_anon_vma_clone(struct vm_area_struct=
 *dst,
 	/* For the anon_vma to be compatible, it can only be singular. */
 	VM_WARN_ON_ONCE(operation =3D=3D VMA_OP_MERGE_UNFAULTED &&
 			!list_is_singular(&src->anon_vma_chain));
-#ifdef CONFIG_PER_VMA_LOCK
 	/* Only merging an unfaulted VMA leaves the destination attached. */
 	VM_WARN_ON_ONCE(operation !=3D VMA_OP_MERGE_UNFAULTED &&
 			vma_is_attached(dst));
-#endif
 }
=20
 static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 23fb68fce000..0b279b82eaa6 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -122,7 +122,6 @@ struct vm_area_struct *find_vma_and_prepare_anon(struct=
 mm_struct *mm,
 	return vma;
 }
=20
-#ifdef CONFIG_PER_VMA_LOCK
 /*
  * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
  * @mm: mm to search vma in.
@@ -182,34 +181,6 @@ static void uffd_mfill_unlock(struct vm_area_struct *v=
ma)
 	vma_end_read(vma);
 }
=20
-#else
-
-static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
-					      unsigned long dst_start,
-					      unsigned long len)
-{
-	struct vm_area_struct *dst_vma;
-
-	mmap_read_lock(dst_mm);
-	dst_vma =3D find_vma_and_prepare_anon(dst_mm, dst_start);
-	if (IS_ERR(dst_vma))
-		goto out_unlock;
-
-	if (validate_dst_vma(dst_vma, dst_start + len))
-		return dst_vma;
-
-	dst_vma =3D ERR_PTR(-ENOENT);
-out_unlock:
-	mmap_read_unlock(dst_mm);
-	return dst_vma;
-}
-
-static void uffd_mfill_unlock(struct vm_area_struct *vma)
-{
-	mmap_read_unlock(vma->vm_mm);
-}
-#endif
-
 static void mfill_put_vma(struct mfill_state *state)
 {
 	if (!state->vma)
@@ -1850,7 +1821,6 @@ int find_vmas_mm_locked(struct mm_struct *mm,
 	return 0;
 }
=20
-#ifdef CONFIG_PER_VMA_LOCK
 static int uffd_move_lock(struct mm_struct *mm,
 			  unsigned long dst_start,
 			  unsigned long src_start,
@@ -1925,31 +1895,6 @@ static void uffd_move_unlock(struct vm_area_struct *=
dst_vma,
 		vma_end_read(dst_vma);
 }
=20
-#else
-
-static int uffd_move_lock(struct mm_struct *mm,
-			  unsigned long dst_start,
-			  unsigned long src_start,
-			  struct vm_area_struct **dst_vmap,
-			  struct vm_area_struct **src_vmap)
-{
-	int err;
-
-	mmap_read_lock(mm);
-	err =3D find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap)=
;
-	if (err)
-		mmap_read_unlock(mm);
-	return err;
-}
-
-static void uffd_move_unlock(struct vm_area_struct *dst_vma,
-			     struct vm_area_struct *src_vma)
-{
-	mmap_assert_locked(src_vma->vm_mm);
-	mmap_read_unlock(dst_vma->vm_mm);
-}
-#endif
-
 /**
  * move_pages - move arbitrary anonymous pages of an existing vma
  * @ctx: pointer to the userfaultfd context
diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 4764d7b68f2a..f4fa54616085 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -170,30 +170,20 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::mm_s=
truct) -> &'a MmWithUser {
     ///
     /// This is an optimistic trylock operation, so it may fail if there i=
s contention. In that
     /// case, you should fall back to taking the mmap read lock.
-    ///
-    /// When per-vma locks are disabled, this always returns `None`.
     #[inline]
     pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadGua=
rd<'_>> {
-        #[cfg(CONFIG_PER_VMA_LOCK)]
-        {
-            // SAFETY: Calling `bindings::lock_vma_under_rcu` is always ok=
ay given an mm where
-            // `mm_users` is non-zero.
-            let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_raw(=
), vma_addr) };
-            if !vma.is_null() {
-                return Some(VmaReadGuard {
-                    // SAFETY: If `lock_vma_under_rcu` returns a non-null =
ptr, then it points at a
-                    // valid vma. The vma is stable for as long as the vma=
 read lock is held.
-                    vma: unsafe { VmaRef::from_raw(vma) },
-                    _nts: NotThreadSafe,
-                });
-            }
+        // SAFETY: Calling `bindings::lock_vma_under_rcu` is always okay g=
iven an mm where
+        // `mm_users` is non-zero.
+        let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_raw(), v=
ma_addr) };
+        if vma.is_null() {
+            return None;
         }
-
-        // Silence warnings about unused variables.
-        #[cfg(not(CONFIG_PER_VMA_LOCK))]
-        let _ =3D vma_addr;
-
-        None
+        Some(VmaReadGuard {
+            // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr, the=
n it points at a
+            // valid vma. The vma is stable for as long as the vma read lo=
ck is held.
+            vma: unsafe { VmaRef::from_raw(vma) },
+            _nts: NotThreadSafe,
+        })
     }
=20
     /// Lock the mmap read lock.
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/du=
p.h
index 41203b1c2323..a0d1d563da24 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -582,7 +582,6 @@ struct vm_area_struct {
 		vma_flags_t flags;
 	};
=20
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
@@ -598,7 +597,7 @@ struct vm_area_struct {
 	 * slowpath.
 	 */
 	unsigned int vm_lock_seq;
-#endif
+
 	unsigned int __vm_anon_pgoff_lo;
=20
 	/*
@@ -632,10 +631,8 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA_BALANCING
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
-#ifdef CONFIG_PER_VMA_LOCK
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt;
-#endif
 #ifdef CONFIG_64BIT
 	unsigned int __vm_anon_pgoff_hi;
 #endif
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_inter=
nal.h
index 8a48b231aa7a..54d5c3360aa2 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -15,7 +15,6 @@
 #include <stdlib.h>
=20
 #define CONFIG_MMU		1
-#define CONFIG_PER_VMA_LOCK	1
=20
 #ifdef __CONCAT
 #undef __CONCAT
--=20
2.55.0.691.gc56d675ccc-goog


