Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705E1C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 21:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D916B0092; Sun,  2 Aug 2026 17:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330836B0093; Sun,  2 Aug 2026 17:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8FF6B0095; Sun,  2 Aug 2026 17:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E05506B0092
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:55:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7106F80549
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:09 +0000 (UTC)
X-FDA: 85057685538.30.C8DFD47
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8698180006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="t3/Ovli1";
	spf=pass (imf16.hostedemail.com: domain of 3ubxvagYKCEw685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3ubxvagYKCEw685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785707707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WSGwwxyjjinJPQxJkdVG/Ds1Cy6oHGCMAupIBKVInM=;
	b=fKszSx51+Aybk02yHoGmiZANmPHelulMF58fzG0zN9yp0OVhllOAf/1dqcKwfcBpDh3uRC
	j+qzIWe2CV9vhYR1sDuekDrcVpgQSdPY2KpaC6ORk5rgRy/3SrSdGvS5iwMPjSQyPuQ3QA
	kzgTBMx0fJN3ZuI7ayUaftcV4at38R4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="t3/Ovli1";
	spf=pass (imf16.hostedemail.com: domain of 3ubxvagYKCEw685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3ubxvagYKCEw685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785707707;
	b=WrnCMA7U7m1tEZcpTsvDF2tx9/cIgBeTxDRIZkHMePCep9oMssgjNuj817VQ6gPwXWnc2E
	zBjZbk7sZFzSL4M349fZd+sClaGpvwMOnyXl5/RBCuk07brXxSOoUfdpDKSmV9XsTP/JSw
	cGdGQmeffHiKwtsPgz6G5uslYY37r34=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbb6433e9d4so3635870a12.3
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 14:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785707706; x=1786312506; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5WSGwwxyjjinJPQxJkdVG/Ds1Cy6oHGCMAupIBKVInM=;
        b=t3/Ovli1OBzKB6//QVC8OYUHvFi+8SvcHxDsa55JBlz79m+tLUfthlHnMs/UiW2FVt
         pwEpLRujawwLl1R6d9vITDsDQeN/X4CKQJCaTMR8DdVfu/sr4Jak1f6Fxshp96wRYKVX
         XeVsZ2eu93++/qMOJ70BIMokbgmlc837R+zA+6/DIydX1fHfZPUYdoPet/FeTiOZMu51
         lkB6Uf6/j5lA/+13YekBhRPRag4j1bCiS+oV72xX/rzJPvKSkzXGnYGpaQiEfsSJAS9b
         Qnca219pBr2cf2+z0u8IzzaGl6OkKff+rVFsbTNFL7Fgixai785KNGPery9zI0PD58Pi
         IbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785707706; x=1786312506;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5WSGwwxyjjinJPQxJkdVG/Ds1Cy6oHGCMAupIBKVInM=;
        b=mBfYJc5HctqiuXuGt/K9KDyI01wLwPsxQAeqlHciftZOu9TXmCzWw42KYdjGK6lgNY
         cPWcGn9KlmT60sFpc2J7x66yHM14cyrgUEHeZyhXF3stX5wuwiAph4iTynbUGGa47Ktr
         fF6SNI664McGDpDMa5cJowLgF2wpj7mF7CcNGebf3fgWWum1KAyfazVb2vyN5vbWc5sr
         cwmq/RiJHGKfblKVlR1gCVpiG/eFbPYzA2iz1LAcu8YjX0kPhlr+6FMcPU7ZsfB0tqVh
         UB9V8VE+FrfvqWvUeaJlUQJUWr156FU3zGjE+eiz+EMVU0N6YBkTCsiLB/dCw0sWhoa9
         /k9Q==
X-Forwarded-Encrypted: i=1; AHgh+RqmqFj4KiCYjj3LQYf9BbLKHOSKgdfF/R4X/gVEAvS3h+Nfjh1BXeCohPN2Hnll/Qd/Htf/v3m+jg==@kvack.org
X-Gm-Message-State: AOJu0YzhfSvDGFg4LKpwtxleMMSGP2gqr3rp/0kZ9NvsFeZq7eISYWXG
	8NV1dR4vf+5rMMz2jhofMWYYDlXRAbQAQo8VPDKbYLGIG7mj0cj7A3evpl05ahkoiDcT83N74l8
	uFaftOQ==
X-Received: from dybfx23.prod.google.com ([2002:a05:7300:c397:b0:30f:1818:9ce5])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431d:b0:3c3:bbe6:95c9
 with SMTP id adf61e73a8af0-3c92a524e5cmr6759651637.16.1785707705981; Sun, 02
 Aug 2026 14:55:05 -0700 (PDT)
Date: Sun,  2 Aug 2026 14:54:55 -0700
In-Reply-To: <20260802215459.2769283-1-surenb@google.com>
Mime-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260802215459.2769283-2-surenb@google.com>
Subject: [PATCH v3 1/5] mm: Make per-VMA locks available universally
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
X-Rspam-User: 
X-Rspamd-Queue-Id: A8698180006
X-Rspamd-Server: rspam01
X-Stat-Signature: amuddhmoqbx8itrtosuuy6wwbnbytmak
X-HE-Tag: 1785707707-1617
X-HE-Meta: U2FsdGVkX18MlJOg0DtswhHBcfpwaQvEyJ09abbetPBdNz9UZagcKwDssmNvrFedBcQvoikTGCPMSSMAbr4j6EqMSLPY0XLXrem8djg6H3rXMmg+5Jv/kb2Wq6PqdUpc1eSiB85YFVKEfQoBGZpYdlRmVV2x6bzCZdRF/fPsumSb1kF2a1cKZWj8Ma2wNDL+/RW4rvj6i6Cu9sAogmGRYVgncJOcjomUfqYmBNI7w2kj8AVpbkHZ7JD/cUvmxoJl5Lw+HUfi02t8otrCtgVtuYN45OwEGquT5AJwdj8RQDpOtxo4DflN7f7+H23+0BwqnbGmR0Cy38xTQSYuXmS9xJeZ1pThxHrQJy3Ea0PFevPDF5hrI9X2dwJNo1eAcU7Tbbx/ce4PB9rYPMfVC8s+TDI/rVdWbWCTUfMSrCgaO5A02qj1Ywe+ehYmc01o0mYcQk8MUKD3T8n7kseN0jITmPxLouVa2FDTl/amGiQuKFx57ssXXWwnbEfw0GXZJBovrUUD362ldS+QRFPlafd1FGdK9BvPNo+A09tx1zTqpYBIiIh70VE44T87U9mjbWokpUeTqlj031/Tatf6Or/V62JTwcJ2VM5J/T60p+bO02EOMnLxOG2z9GHyXQabA+KNVnvLzV1PdMR5vu227PGs5MVvlkjV5Sa1urVfyUQwqD32yz4nivMq1idJRqVQvbDVdpKwFqImOv4Zl4oKD7cK3MWajPOqAYJaBDbUKxcidPCbnO5Zmw09ZXI9qpo+Sf7MZEtFMNxI9qAaPA8fUxPjtJg3PSjZJxdqc5koYPVgjRuMIeD1AHOx2hrlCiZYIUwt1KiYQSYQgFJ+E6+OTcDp8SD7Dou5mAZE8bUI3Q4mFVrzHxM1B7BI/opNKo1TiG2hqnCfxgNukV2zJ3hEZIFe7tFBl+BIXoIrSmEt7BXa4/yM7K6zwAY/fYUcI+hk5MOLqkfVNWwpe3lPVK0+3gM
 89DwEF5c
 /lSuNYcTz2RUsxu7PWObKzwM3fuh9r/CcEnSrfxZb6pVMnJ4gJzKkAzgzsZmxiTkWy5IXKJi7/ifxm/jOdOlwex+o7r08cutzOS3gvCI1PhQIkHDmZmR6H4OVmLgfok8xYAvDuxmKBmoUttR/Re2UW/ey4Z//gP6zl9UOSvgSfS7D39nZWzMW7ZcuLypmfrjkUJ+YBFHMRj6bUALfdkGr9J5Rj2fHUk4vAtalWgcsb9XvvmY/P0/LPXNZ1G4EwgPJqDHv7jeqC6aAEp8BX0Gj6zhAimat9m00IDNo5AmeS7MU9rHqLiuFV95cMFUCWqxmh39RHoH0CE+jTrsm/lKmSeUqCqr8EPEmfCe89cl1amsebTkt2/IXnkKCmCw9YhtHemSkFKZ5xEX5gc5tUbbHnJ6Q5yl66uzosL88XRyO3HMu94vNYVsOlMuAKFBF4Z7Jh068HKvzkQZKPvS3cKSA5Zy3MELSUTkht3ZVGaPRJlBHuQSePvmh31T+gskJZXU062aCej7Q/WfKc270cuAT8qvy7vKx4ID+MfDStPgufEOpRfhrfp4hRnzVA7le5XU5xmn0ZDejMWinD3zh9kYhN0bizgIKBNO0QOy/5eG0HJALLoIJsgb5AIHlWVGQavw5Noqms8sisAEQ/MQ2IS4aICuF8uK4LUMvfAGHbjxPuAga3KTjorF1/hwcmR1baYueAmtauus+Cl1Xsvd4ROOgbRxdCeJLav5EhLAnVyWttyjt5fsdWqUhNc1/EfHBA0V6RzqvoN2bZu4KTFBgeVDkdEj3wZIsd4LEk+v467vq01xuygJVWp9VV9mM3X7nZrnuqPbSKXX10jwlD9JNleup6D6PRsTycNS4LFI+vjW9DEu4LZzRC0f1sF8tkU7bA5XVUABFk6uedyof0qhlVdr87jdrM33UkI+8PIZAqPh2SzULxzCFyGX54FrB7hh/25bTmleRvDgbavgqWyo3OxwWd9D+WUar
 yDda9Nmj
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

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
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
 include/linux/mmap_lock.h              | 50 --------------
 kernel/bpf/stackmap.c                  | 16 +----
 kernel/bpf/task_iter.c                 |  5 --
 kernel/fork.c                          |  2 -
 mm/Kconfig                             | 13 ----
 mm/Kconfig.debug                       |  1 -
 mm/debug.c                             |  4 --
 mm/init-mm.c                           |  2 -
 mm/memory.c                            |  2 -
 mm/mmap_lock.c                         | 24 -------
 mm/pagewalk.c                          |  2 -
 mm/rmap.c                              |  2 -
 mm/userfaultfd.c                       | 55 ---------------
 rust/kernel/mm.rs                      | 22 +++---
 tools/testing/vma/include/dup.h        |  5 +-
 tools/testing/vma/vma_internal.h       |  1 -
 28 files changed, 13 insertions(+), 317 deletions(-)

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
index 817e3e0f9194..096bf0b0b9e0 100644
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
index 7fabe6c66b4b..d9850f846242 100644
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
index b5d4cd3b067b..d8e246fd09d3 100644
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
 	 * Low 32-bits of virtual page offset.
 	 * See vma_start_virt_pgoff() comment for details.
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
 	 * High 32-bits of virtual page offset.
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
index 87f77e3da77f..eb32b482434e 100644
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
@@ -484,54 +482,6 @@ struct vm_area_struct *lock_next_vma(struct mm_struct =
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
index 41fe87d7302f..8848e26ef581 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -272,13 +272,8 @@ struct stack_map_vma_lock {
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
+ * This returns a VMA with its per-VMA read lock held and mmap_lock
+ * dropped, so the caller may sleep.
  *
  * Returns NULL on failure, in which case no lock is held.
  */
@@ -288,7 +283,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, uns=
igned long ip)
 	struct mm_struct *mm =3D lock->mm;
 	struct vm_area_struct *vma;
=20
-	/* noop under !CONFIG_PER_VMA_LOCK */
 	vma =3D lock_vma_under_rcu(mm, ip);
 	if (vma) {
 		lock->vma =3D vma;
@@ -308,13 +302,11 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, u=
nsigned long ip)
 		return NULL;
 	}
=20
-#ifdef CONFIG_PER_VMA_LOCK
 	if (!vma_start_read_locked(vma)) {
 		mmap_read_unlock(mm);
 		return NULL;
 	}
 	mmap_read_unlock(mm);
-#endif
=20
 	lock->vma =3D vma;
 	return vma;
@@ -322,11 +314,7 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, un=
signed long ip)
=20
 static void stack_map_unlock_vma(struct stack_map_vma_lock *lock)
 {
-#ifdef CONFIG_PER_VMA_LOCK
 	vma_end_read(lock->vma);
-#else
-	mmap_read_unlock(lock->mm);
-#endif
 	lock->vma =3D NULL;
 }
=20
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index e791ae065c39..6cf815bc84be 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -835,11 +835,6 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_=
task_vma *it,
 	BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) !=3D sizeof(struct bpf=
_iter_task_vma));
 	BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) !=3D __alignof__(=
struct bpf_iter_task_vma));
=20
-	if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
-		kit->data =3D NULL;
-		return -EOPNOTSUPP;
-	}
-
 	/*
 	 * Reject irqs-disabled contexts including NMI. Operations used
 	 * by _next() and _destroy() (vma_end_read, fput, bpf_iter_mmput_async)
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
index 060190e12bce..77103b46b679 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1425,19 +1425,6 @@ config LRU_GEN_STATS
 config LRU_GEN_WALKS_MMU
 	def_bool y
 	depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
-# }
-
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
=20
 config LOCK_MM_AND_FIND_VMA
 	bool
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
index a620d425ec95..f109f6c87b28 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6813,7 +6813,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_area=
_struct *vma,
 				 !is_cow_mapping(vma->vm_flags)))
 			return VM_FAULT_SIGSEGV;
 	}
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT because of
 	 * the assumption that lock is dropped on VM_FAULT_RETRY.
@@ -6822,7 +6821,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_area=
_struct *vma,
 			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) =3D=3D
 			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
 		return VM_FAULT_SIGSEGV;
-#endif
=20
 	return 0;
 }
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 898c2ef1e958..e20d01e8d38f 100644
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
@@ -431,7 +428,6 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *=
mm,
=20
 	return vma;
 }
-#endif /* CONFIG_PER_VMA_LOCK */
=20
 #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
 #include <linux/extable.h>
@@ -548,23 +544,3 @@ struct vm_area_struct *lock_mm_and_find_vma(struct mm_=
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
index ed4860c01936..fbcf64c59a97 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -446,7 +446,6 @@ static inline void process_mm_walk_lock(struct mm_struc=
t *mm,
 static inline void process_vma_walk_lock(struct vm_area_struct *vma,
 					 enum page_walk_lock walk_lock)
 {
-#ifdef CONFIG_PER_VMA_LOCK
 	switch (walk_lock) {
 	case PGWALK_WRLOCK:
 		vma_start_write(vma);
@@ -461,7 +460,6 @@ static inline void process_vma_walk_lock(struct vm_area=
_struct *vma,
 		/* PGWALK_RDLOCK is handled by process_mm_walk_lock */
 		break;
 	}
-#endif
 }
=20
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index b917431759ee..4e4a4b747977 100644
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
index 258b03182a78..edd90892f8cc 100644
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
@@ -1852,7 +1823,6 @@ int find_vmas_mm_locked(struct mm_struct *mm,
 	return 0;
 }
=20
-#ifdef CONFIG_PER_VMA_LOCK
 static int uffd_move_lock(struct mm_struct *mm,
 			  unsigned long dst_start,
 			  unsigned long src_start,
@@ -1927,31 +1897,6 @@ static void uffd_move_unlock(struct vm_area_struct *=
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
index 4764d7b68f2a..2633e704c83d 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -174,26 +174,20 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::mm_s=
truct) -> &'a MmWithUser {
     /// When per-vma locks are disabled, this always returns `None`.
     #[inline]
     pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadGua=
rd<'_>> {
-        #[cfg(CONFIG_PER_VMA_LOCK)]
         {
             // SAFETY: Calling `bindings::lock_vma_under_rcu` is always ok=
ay given an mm where
             // `mm_users` is non-zero.
             let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_raw(=
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
+            if vma.is_null() {
+                return None;
             }
+            Some(VmaReadGuard {
+                // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr,=
 then it points at a
+                // valid vma. The vma is stable for as long as the vma rea=
d lock is held.
+                vma: unsafe { VmaRef::from_raw(vma) },
+                _nts: NotThreadSafe,
+            })
         }
-
-        // Silence warnings about unused variables.
-        #[cfg(not(CONFIG_PER_VMA_LOCK))]
-        let _ =3D vma_addr;
-
-        None
     }
=20
     /// Lock the mmap read lock.
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/du=
p.h
index 800e5fa02d78..362feda28526 100644
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
 	unsigned int __vm_virt_pgoff_lo;
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
 	unsigned int __vm_virt_pgoff_hi;
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
2.55.0.508.g3f0d502094-goog


