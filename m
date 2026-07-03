Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE84C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622E36B0196; Thu,  2 Jul 2026 22:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA026B0197; Thu,  2 Jul 2026 22:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F836B0198; Thu,  2 Jul 2026 22:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22FAE6B0196
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:26:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AF09403C6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:26:26 +0000 (UTC)
X-FDA: 84945876372.27.35DA050
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id B878B180006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:26:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HAOh61zc;
	spf=pass (imf16.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783045585;
	b=SCBDus6dMKHSJQom494Nilkl9kRy6mPH6AJvWtpPaaLAlyirRnt5fsPc2tZc7hNu5lIf6M
	TrFq9Vbk8BtAjnLPhOYaNQvObOgB1I7hFRur/SRjks4GGY8NRqQf9jCL37F5+cjdKseqnx
	9vMs1IW1s/7tvAWnMP/s1+yBdxe8tN0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783045585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZI0lTmkO/UHIT4+QlSIiK8ejRok32RfZUe5uhwcA5/U=;
	b=GaC0m1FhkI+9v06zMzJB/Aj6NQUT/+Li0vrhr6BMU4tb8O9PSd2zvz40x77FeJg4ewR1CC
	DmDY/QWcvQKSI8ETuE/fQTpGe1GGPbp443QUv/9Ihhxidi4Isrf8a9Qx+3GxVEeAyC2Ex9
	eu6MFuCF0+vMYEkveTdjIycq420mAr0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HAOh61zc;
	spf=pass (imf16.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783045581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZI0lTmkO/UHIT4+QlSIiK8ejRok32RfZUe5uhwcA5/U=;
	b=HAOh61zc+mozxiYtcPNEO5Yx8iORG5T8Mkpg/vMHNt2052hHUqbiQmAarZ6Dw+Wa155V9M
	3s5333q3wzpR9SONk7wmKAVZRq1Oa6jrucylyEZauSAr7GDU5Puc5fP1m+9Lie//AcBW+2
	G42rxvyD2sX024RzcWXP/b0U8+rU9uQ=
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
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Leon Hwang <leon.hwang@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Alice Ryhl <aliceryhl@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Anand Moon <linux.amoon@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
Date: Fri,  3 Jul 2026 10:25:07 +0800
Message-ID: <20260703022507.187457-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ky5rkpo3o3qr7h1n89ys85jubi9m1t5p
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B878B180006
X-HE-Tag: 1783045584-683587
X-HE-Meta: U2FsdGVkX1+ttus7ns/pIoU5jry5MRqm2fN7xo5EPyXAPsOWGgLQyn7ePi7IkQdqMmqwca6UvbQxzEaku3423/oskKHy4RDT0Wx5r/vJTsV6PAIzXiaQC41CxErr6/WFYg7O0vziRDyCnZnGyPQfOvLqnx22BgnEIPZpyVDWlLemOvEg1xDUS5EQaRsQP9OeupdQU4nHxgMkKw2ayON3AwNq9dmWAwf8nxrW2zZZCPGe9J1VW8hH3+YBvyzgjvC3FquM35vuMXIQ74oIKvpSMKvm3ELVsjxqCcYvLtdOatUPNBTip3JIQObGRG9Vnq1FVKZ6H4XGYOIdtUy4/brXAUUXzHklDvtO6TS8FqfpDeFUYqXG5z3UMnqRNBxgBeViYsd02cY5O03mHwYAHHQvMaSzd+pMURwhuapw3oz8nr8Y/UOW31kd0vQUlYmliMEpL2bGxUj+K66Cy7JlwI9k/P/ZQCNXclF2CQTbaecAIcpwTUkLzib+lzAhpw9jblAlLIyxw+tXm1kPN8WP+iBcUORX094h5VLjvPqAUeZZbtutjkoRW07OcO+AfnWLVfpjGvngWML2J4RnDdFi1t8dy7WTwnDxu0UJVOrQsaxrsMiGoDDkuV8UnGYYAYPS7nR0QUpKE5RRLsuZuzdFrsa2olD/ZsPfP88Y9GOHGZC7Z8p6oN34Cq60iRr5BfpjjnzCVHm90wyziiiclecuBIieF1kOsjioVG9xxXCImDirY6XSb8abBP4DE8m8MsDRJEwWF+YTjYEc8+iKv4lSMSu2Ymh0j/LfcJzTz2foR4RtoNBwTjmtB3ZlYbHyfS+GylH03/DOoPlnhlFoqkKWwqnJ3sJheDKNDa1CmThpQUD65y5fMLXZS7xAL/7uGIiVcsBjXz/QFORjb0k4HumwvE4llPN99a00hl8EBXUvU1di2HNv7E+i5JMNAH9EOimROTU29yS4EQpPBI2KmUH9BVG
 9yflWg2o
 rFfWRM1f7PlgZM4DGZLRZ6NKzvEQyVgWsXNZa38jqjvJhVlwRZw/XEkdKAj6DJ/nwOJTQC3U94MOUyEgDpTLeOg08GO6S7tv3zvV+QUUsG9CXDbCL/Vc2d0wryJ/uaZ6BSjM7t5s3gDix+EuGKLfIG8Lh7iMjQA9vp+dsVSWYrk9soumjhJbAgCd95Mxs6bVZX7pAIbIIUHqdzkinrlLqaRO9F7zaM+o0Lnul+QKABpp+J/ppRTrQsa4lmFhExKrtiWqDlyENOrQ6e5S7kMDoiCAY0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back
to sys_ni_syscall() and return -ENOSYS rather than -EPERM.

Document the -EINTR return from mmap_write_lock_killable(), fix the
CONFIG_MSEAL_SYSTEM_MAPPINGS typo, and describe system mappings in
terms of VM_SEALED_SYSMAP.

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 Documentation/userspace-api/mseal.rst | 18 ++++++++++--------
 init/Kconfig                          |  2 +-
 mm/mseal.c                            |  4 ++--
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
index ea9b11a0bd89..1f1cf206670c 100644
--- a/Documentation/userspace-api/mseal.rst
+++ b/Documentation/userspace-api/mseal.rst
@@ -50,8 +50,10 @@ mseal syscall signature
          * The start address (``addr``) is not allocated.
          * The end address (``addr`` + ``len``) is not allocated.
          * A gap (unallocated memory) between start and end address.
-      - **-EPERM**:
-         * sealing is supported only on 64-bit CPUs, 32-bit is not supported.
+      - **-EINTR**:
+         * Interrupted while waiting for the mmap write lock.
+      - **-ENOSYS**:
+         * The kernel does not implement ``mseal()``.
 
    **Note about error return**:
       - For above error cases, users can expect the given memory range is
@@ -62,7 +64,8 @@ mseal syscall signature
         memory range could happen. However, those cases should be rare.
 
    **Architecture support**:
-      mseal only works on 64-bit CPUs, not 32-bit CPUs.
+      mseal is built only for 64-bit kernels. 32-bit kernels return
+      ``-ENOSYS``.
 
    **Idempotent**:
       users can call mseal multiple times. mseal on an already sealed memory
@@ -131,20 +134,19 @@ Use cases
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
 
   If supported by an architecture (CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS),
-  the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
-  architecture.
+  CONFIG_MSEAL_SYSTEM_MAPPINGS seals mappings marked with VM_SEALED_SYSMAP.
 
   The following architectures currently support this feature: x86-64, arm64,
-  loongarch and s390.
+  loongarch, riscv, and s390.
 
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
diff --git a/init/Kconfig b/init/Kconfig
index 5230d4879b1c..12bb39f637b1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2112,7 +2112,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	  from a kernel perspective.
 
 	  After the architecture enables this, a distribution can set
-	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
+	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.
 
 	  For complete descriptions of memory sealing, please see
 	  Documentation/userspace-api/mseal.rst
diff --git a/mm/mseal.c b/mm/mseal.c
index 9781647483d1..0464c7b94ab9 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -132,8 +132,8 @@ static int mseal_apply(struct mm_struct *mm,
  *   addr is not a valid address (not allocated).
  *   end (start + len) is not a valid address.
  *   a gap (unallocated memory) between start and end.
- *  -EPERM:
- *  - In 32 bit architecture, sealing is not supported.
+ *  -EINTR:
+ *   interrupted while waiting for the mmap write lock.
  * Note:
  *  user can call mseal(2) multiple times, adding a seal on an
  *  already sealed memory is a no-action (no error).
-- 
2.54.0


