Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAD6C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2958C6B00C2; Wed, 15 Jul 2026 09:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246016B00C4; Wed, 15 Jul 2026 09:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184436B00C5; Wed, 15 Jul 2026 09:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8F0D6B00C2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB9E6120180
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:13:37 +0000 (UTC)
X-FDA: 84991052874.30.6FE86A4
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id A5261120002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:13:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QA80ny0f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784121216;
	b=yVrS6TZ8Drs0bxFoOo11C1mbCWvXsc7OHeSZDV3PUHZ+b9CIPufm31nF3CT8kifCQFGpxR
	qjrodJqPwsaQCOREJeXvpL5QUfcRvKxwjr/HUnAr+YdXDspj2FRSkWssQC2e2RougYbbMW
	OcF/VWAYZ6wmNfpobawl3FbhYlHc59s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QA80ny0f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4WBE3M/nI/ozpD58c8KdJqhsFEjd9mM2a+4L8TirpAc=;
	b=y8jWqR3jqzLO68yLiQFGqjg7paxMAT5hvH3g9NlbcG14jItMYyDdFc3mgIv5jEklkUoQbo
	d8YRxrHiZ13yj/mZFssn0bBLR2dXHcTgSxUjaI4WsYiqwFbJdm3Ikwttzs/g9c/Zc5iVMH
	A0Iy/USPdlCMLl1Lx8UT3VhP2hQFBZ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784121210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4WBE3M/nI/ozpD58c8KdJqhsFEjd9mM2a+4L8TirpAc=;
	b=QA80ny0foxBzYr02oXTnT7KL8JDbwj1CGFV5k5kcasnKKjxzsZmuFpySC1fJ29WlP6bhuQ
	h1VMgFU13pTUefpXTiEQ5Z8UBuzAcMQlPqu6gPxNu62D7dYKgMCoIZnYoZh1tkzvG5jcbm
	PlibFk3jAHIqspoJF0qfZj//bk/9PDY=
From: Leon Hwang <leon.hwang@linux.dev>
To: linux-mm@kvack.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Alice Ryhl <aliceryhl@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Anand Moon <linux.amoon@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/mseal: fix mseal documentation for 32-bit kernels
Date: Wed, 15 Jul 2026 21:12:58 +0800
Message-ID: <20260715131258.55499-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A5261120002
X-Rspam-User: 
X-Stat-Signature: qr6f87zkonwz48atcumkeo3utyd5uhhq
X-Rspamd-Server: rspam03
X-HE-Tag: 1784121215-12344
X-HE-Meta: U2FsdGVkX1/PagG4b8Uc4I2tlKCiHhT0Grjd46gCoD0FIrIrRWBEbT1QK4T+W6g2j7RfKaEEgXkKGmH2aP8bgkH4Y7HtujrWh5JtZ13pzkcKSyJLhwIm0I1qu1yX61+n+w4B9UJc7AMfRhV/G+wYS/55S5ZMhCPDTbYNdu0+pzl9Lre7OtUSx+uhb1QFLT38t3ITlc1VJvGPA1bsQ/P/l/E6mDbHGT4oxtsnirKks2N7pTDucpADZ+x0if/gn6F5bi4JyHxEsTWc6mkw/kenNrn/P3j8ffKGKes4BSab1jk6y6mWjNzoYnXIZyp7rQ1Az5af9xfXwE+uok1kkVXYLwVS2+aczw8qS+A408PUGOSUh1SMSLf5heAyCAO12uyKz26NorfKgcDDbmvLDbYZrkcA4pC3+KAvVy5rkzZluHflXsy1jsMajVT3qYnfR4kFumhKHmM9jsi1Mf2IWIBWnxOMfHXTNiIxKXRm33O3H+wWyeLeDoM0zqQizAabPP7GV8SXhz6fKEGXn68iyaSXVnCKcwhoqz9uwTp454EQIb5pZlKssHPJr6PjwNHBrKgHbPjW8HRaOqOWm1NACg4WhEetJ6lm8UCUm6n2APxZHfg8dodJciwGOiD3j/p5J1WeQO0AzxTOtmygEWmN/LdXMGwzXxRlwLiLNsrrk1oJBpKHMby985IWXOa+8cut1Si5MXdZhw5zSJODhhIP3akTDp3uniH313zMFfxuJg/h45YCf3TgkcCtce8Gr1vUBmMST/XO4wW/FyoBjUwA5p+kNBjUhRvOIdxIhNMye6JEXzRiEkRxldYu0GwrWXxL6bthQ0EtUIADEjVZKIRNKbjMcBFsAAQ3teLTwLQHt6i2HyvGq6HHtI9mPdrzDnyiJ240xbHw+M4b+iE5AY6MKmMg3n0apN/99Nu2r/kGv/KB+Zvoiu4oUUgxi/vJEhpvasbBFgQwpbmTB7uqLEDgVxS
 2wwBr2yL
 e+hyOWPYc1JHD7WKd4u3UlaJczOWP/ZmV213Rx7DefKC/BLraZi20O5k2DOfkyB9zzU2FGaOpNTN2wmaZ8eT44RGgb9phnTv+X0V2MOdPVbV1CfmyUttSvpzIhVMxA6Ge4P9rNnz1PQKjuWrvklRgfruRSSc9R5Wx89MDA0WpO3Spf/b9PdADIXPvx6QOfmxYw8olTb/rzqehRchJLCx8i7AGNzFQ3ODLcMDls3fCl2ZnY9y5mBAHWt79YhCtpqp5wMHC5A1oPdxNqeUvDUrWqGD9MJPP4OizUiV3ryYG8h8MuX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back
to sys_ni_syscall() and return -ENOSYS rather than -EPERM.

Drop architecture description in mseal.rst, since the arch feature
doc has the latest state of mseal for each architecture.

Fix the CONFIG_MSEAL_SYSTEM_MAPPINGS typo in init/Kconfig.

Drop the whole comment of do_mseal() to avoid stale info in the
comment, as we have the doc in mseal.rst.

Acked-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
v1 -> v2:
* Drop -EINTR description in mseal.rst. (per Mathew)
* Drop VM_SEALED_SYSMAP change in mseal.rst. (per Pedro)
* Drop architecture description in mseal.rst. (per Pedro)
* Drop the whole comment of do_mseal(). (per Pedro)
* v1: https://lore.kernel.org/linux-mm/20260703022507.187457-1-leon.hwang@linux.dev/
---
 Documentation/userspace-api/mseal.rst | 14 ++++----
 init/Kconfig                          |  2 +-
 mm/mseal.c                            | 52 ---------------------------
 3 files changed, 7 insertions(+), 61 deletions(-)

diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
index ea9b11a0bd89..c039d782f9f5 100644
--- a/Documentation/userspace-api/mseal.rst
+++ b/Documentation/userspace-api/mseal.rst
@@ -50,8 +50,8 @@ mseal syscall signature
          * The start address (``addr``) is not allocated.
          * The end address (``addr`` + ``len``) is not allocated.
          * A gap (unallocated memory) between start and end address.
-      - **-EPERM**:
-         * sealing is supported only on 64-bit CPUs, 32-bit is not supported.
+      - **-ENOSYS**:
+         * The kernel does not implement ``mseal()``.

    **Note about error return**:
       - For above error cases, users can expect the given memory range is
@@ -62,7 +62,8 @@ mseal syscall signature
         memory range could happen. However, those cases should be rare.

    **Architecture support**:
-      mseal only works on 64-bit CPUs, not 32-bit CPUs.
+      mseal is built only for 64-bit kernels. 32-bit kernels return
+      ``-ENOSYS``.

    **Idempotent**:
       users can call mseal multiple times. mseal on an already sealed memory
@@ -131,11 +132,11 @@ Use cases
 - Chrome browser: protect some security sensitive data structures.

 - System mappings:
-  The system mappings are created by the kernel and includes vdso, vvar,
+  The system mappings are created by the kernel and include vdso, vvar,
   vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.

   Those system mappings are readonly only or execute only, memory sealing can
-  protect them from ever changing to writable or unmmap/remapped as different
+  protect them from ever changing to writable or unmapped/remapped as different
   attributes. This is useful to mitigate memory corruption issues where a
   corrupted pointer is passed to a memory management system.

@@ -143,9 +144,6 @@ Use cases
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
   architecture.

-  The following architectures currently support this feature: x86-64, arm64,
-  loongarch and s390.
-
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
   of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
diff --git a/init/Kconfig b/init/Kconfig
index 9d91074c5d0a..a1402bd82026 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2120,7 +2120,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	  from a kernel perspective.

 	  After the architecture enables this, a distribution can set
-	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
+	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.

 	  For complete descriptions of memory sealing, please see
 	  Documentation/userspace-api/mseal.rst
diff --git a/mm/mseal.c b/mm/mseal.c
index 9781647483d1..69a53207ab57 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -88,58 +88,6 @@ static int mseal_apply(struct mm_struct *mm,
 	return 0;
 }

-/*
- * mseal(2) seals the VM's meta data from
- * selected syscalls.
- *
- * addr/len: VM address range.
- *
- *  The address range by addr/len must meet:
- *   start (addr) must be in a valid VMA.
- *   end (addr + len) must be in a valid VMA.
- *   no gap (unallocated memory) between start and end.
- *   start (addr) must be page aligned.
- *
- *  len: len will be page aligned implicitly.
- *
- *   Below VMA operations are blocked after sealing.
- *   1> Unmapping, moving to another location, and shrinking
- *	the size, via munmap() and mremap(), can leave an empty
- *	space, therefore can be replaced with a VMA with a new
- *	set of attributes.
- *   2> Moving or expanding a different vma into the current location,
- *	via mremap().
- *   3> Modifying a VMA via mmap(MAP_FIXED).
- *   4> Size expansion, via mremap(), does not appear to pose any
- *	specific risks to sealed VMAs. It is included anyway because
- *	the use case is unclear. In any case, users can rely on
- *	merging to expand a sealed VMA.
- *   5> mprotect and pkey_mprotect.
- *   6> Some destructive madvice() behavior (e.g. MADV_DONTNEED)
- *      for anonymous memory, when users don't have write permission to the
- *	memory. Those behaviors can alter region contents by discarding pages,
- *	effectively a memset(0) for anonymous memory.
- *
- *  flags: reserved.
- *
- * return values:
- *  zero: success.
- *  -EINVAL:
- *   invalid input flags.
- *   start address is not page aligned.
- *   Address range (start + len) overflow.
- *  -ENOMEM:
- *   addr is not a valid address (not allocated).
- *   end (start + len) is not a valid address.
- *   a gap (unallocated memory) between start and end.
- *  -EPERM:
- *  - In 32 bit architecture, sealing is not supported.
- * Note:
- *  user can call mseal(2) multiple times, adding a seal on an
- *  already sealed memory is a no-action (no error).
- *
- *  unseal() is not supported.
- */
 int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
 	size_t len;
--
2.55.0

