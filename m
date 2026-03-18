Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC08B107BCF4
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B67B6B029A; Wed, 18 Mar 2026 11:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28EB06B029C; Wed, 18 Mar 2026 11:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17ECD6B029D; Wed, 18 Mar 2026 11:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 011F96B029A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8753C140856
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:25 +0000 (UTC)
X-FDA: 84559623330.17.68D71E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B5D918000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dChUK4Jh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KM3/VJdqZd9eNbQi9ex7ze9E1ZNoFEpRf7bs9SGgn40=;
	b=SPWHzyqJPzXq2WRFa7Gr8L2wdBpPaIkKrHgDYxO3TfB2F412LNsX3QQN1CpP5J2qulEZEF
	848RpcbZ0iTABEmto5u9EZwrlQgfLtxUJFPepxNh4VACPcP/gYawc/gwmyF+g4D1bcva/V
	ec7hMnM1B0d88w9bdCd5+FnHf8qfZAQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dChUK4Jh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849083; a=rsa-sha256;
	cv=none;
	b=HSV3OZo6tlh2uTxkGJkdSfLbqlxC5gB7Px9NBO56svY+9zJii2RnHCDR/RJxt1zygC0kCQ
	vR3BGpO8/XeFrd/YwBnP77clFLQ3yukc4c5DHySd9bbW5UejhcX5RElDaU4NVOGiCxnAQU
	0lNuHpRWQkz+5G0Uuia4DAFOW2vAkHw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15BD261118;
	Wed, 18 Mar 2026 15:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30483C2BC87;
	Wed, 18 Mar 2026 15:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849082;
	bh=WTtdyZXbISPP1kcYqp/J+dovRgyrhT8ehSC7WOVjmko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dChUK4Jh9ZIVsDSCCL8U8ZytT0/xMqCscZqdj29DI7Wsx3plLasi+0/pKgtulbkz8
	 DUJ5FxuumcOv/B0D39i9fxvUzDGq3ecUq2dQuzdMXJaHW/nfbyjMVwQD1Y9H4fDhsA
	 Tq5XhQIk+U+l/1xNy1wgtvkpgNuUACEN6N8NwulBz+B3yQgNC/YSODcALTpNRWPE2o
	 ElObt07L2oCIKwEVUsrqELHod10F2ixGRftVlh82X8tunP//IVGxOse4nYEeIqRrjg
	 Mya9vUT0S1mvtnVJUp2KLTRvyIOIWVjMuJHoqvFj7b7hp5/ARQZrb0DPIvf/UIEVr1
	 eiBNfvTgH7pJg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v3 15/23] mm: introduce vma_flags_count() and vma[_flags]_test_single_mask()
Date: Wed, 18 Mar 2026 15:50:26 +0000
Message-ID: <02a6b26542ab70d60175e0125cff5fd00073c7ae.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B5D918000B
X-Stat-Signature: bjmdyu9i4975m96y5mmzf9o7zy4mr1nj
X-Rspam-User: 
X-HE-Tag: 1773849083-23274
X-HE-Meta: U2FsdGVkX19plDFpzIKexmMHfA7kqvEQcUOTjNxzny3exGAPuJzWZP1lNWVaP8CIgqELSeTItrz6Asc7aCDjXyaRAcbCyQcWBShitulETIzkxPgBjvxTcaZ8OYlxAVHoKo5smlF7Qafvz6riE/XDj+0/yPcJGQK2Q4mD2cfSFErSkdMN0Zg78SQKMA6jrntbFfcj6wa/r9pJkCaRPwt4VbS4lvUxjmIsY4Nhzp2D0fEvp+niktu+Ud3Z1g7ZIwMEeTw1twhP9kEqjUZVyYsZiYQc2TOx7FaKljIPWoTqLUUAHiI/FVVSO4sHashmkHKqVqd1X15AJiil5KLTVyo/oLkMzPHxddSQENyBIGQw8buuMHEnW28FrWtbAVyszVYOej7ByWd5CmJW6Em5KejlvukCstS4I1c8o3a67KLohALAFkefl5aSyUiPBwFfACh8hTX9Z6PShZ2RCqKSo2mXkDq1Lz0krxVMIFFjYMM4xXQLobYQlTNFTKcYEOY0FHzpEHM8wOOP0p/OZJ2JVQ/S6evRGuae1a6kBjPNSC3XEqrkKW+v8nTh5UhEkfZ8BNRN3E0nES6779MCp8T07HKEcBisph97m8EuUuWPkrW4VU/yaEszr7/pmJFTl9eXukO6EWDPw4dpmOSyUjzrsww3AGyUK514PVs9tE/K3DcTWQsvc9uqUzwm4CB7hx+Cf/a58kOzmhecckv49JGqaegCKx0T2mNkYpFfJAVtPbJMmctziGb/Uc8l+piknEfqBfs9hJ7lmdYe1hRNN3AHoXsILRatWJI9UdC0VvbR/3VltXGSzcNYa/3OvCqbVBcijsqEPCW4wq+5NnyvwSDXoiLDkz/P5/5DjCOtM+H/oAa0XGJdTlHMeWFfEqxJKMw8Ft3GbzQ8rOapQX3eGxbC2xeJJjuPSrESR7hU19KjDO04rygz4qiT2cjZ+bIGv/TkhrEmEuG0dF170dO9pREjZfe
 FiTDqmZk
 Ieo0cW47e8i0nquMDh7+hRGcArPzeXauxyglHIepwLf5o2hdfTY1fNwNWSxPICMVn+fDcb0ZTw/tgi7mL5un2vrf9DbQcChN9YSguiN+5iqyGeCA5XkAEKkt7omsa2Q36iujZ8rIQjLGzH4BXwaIz7gih0blAJ7jjULIjGtrJmqMj4OVwhhI2x2aHIly6/WP1gYLcr6E1Wz07J2RhTo4lcozvUqmbAZkxuDfprsjpUuRIyIASInmFLnLiK010rZa8ME7jeCjIUTzzNUwD54PhBUux/1agEesBv5Jtvnygj1jXHzGqgwdLCQyZk649xmgADqxykuFHzjh47FspSyNs/1R8dxhiTZk8ZD7o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_flags_count() determines how many bits are set in VMA flags, using
bitmap_weight().

vma_flags_test_single_mask() determines if a vma_flags_t set of flags
contains a single flag specified as another vma_flags_t value, or if the
sought flag mask is empty, it is defined to return false.

This is useful when we want to declare a VMA flag as optionally a single
flag in a mask or empty depending on kernel configuration.

This allows us to have VM_NONE-like semantics when checking whether the
flag is set.

In a subsequent patch, we introduce the use of VMA_DROPPABLE of type
vma_flags_t using precisely these semantics.

It would be actively confusing to use vma_flags_test_any_single_mask() for
this (and vma_flags_test_all_mask() is not correct to use here, as it
trivially returns true when tested against an empty vma flags mask).

We introduce vma_flags_count() to be able to assert that the compared flag
mask is singular or empty, checked when CONFIG_DEBUG_VM is enabled.

Also update the VMA tests as part of this change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h                 | 46 ++++++++++++++++++++++++++++++
 tools/testing/vma/include/custom.h |  6 ----
 tools/testing/vma/include/dup.h    | 21 ++++++++++++++
 tools/testing/vma/vma_internal.h   |  6 ++++
 4 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 47bf9f166924..324b6e8a66fa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1083,6 +1083,14 @@ static __always_inline vma_flags_t __mk_vma_flags(vma_flags_t flags,
 #define append_vma_flags(flags, ...) __mk_vma_flags(flags,			\
 		COUNT_ARGS(__VA_ARGS__), (const vma_flag_t []){__VA_ARGS__})
 
+/* Calculates the number of set bits in the specified VMA flags. */
+static __always_inline int vma_flags_count(const vma_flags_t *flags)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return bitmap_weight(bitmap, NUM_VMA_FLAG_BITS);
+}
+
 /*
  * Test whether a specific VMA flag is set, e.g.:
  *
@@ -1158,6 +1166,26 @@ static __always_inline bool vma_flags_test_all_mask(const vma_flags_t *flags,
 #define vma_flags_test_all(flags, ...) \
 	vma_flags_test_all_mask(flags, mk_vma_flags(__VA_ARGS__))
 
+/*
+ * Helper to test that a flag mask of type vma_flags_t has a SINGLE flag set
+ * (returning false if flagmask has no flags set).
+ *
+ * This is defined to make the semantics clearer when testing an optionally
+ * defined VMA flags mask, e.g.:
+ *
+ * if (vma_flags_test_single_mask(&flags, VMA_DROPPABLE)) { ... }
+ *
+ * When VMA_DROPPABLE is defined if available, or set to EMPTY_VMA_FLAGS
+ * otherwise.
+ */
+static __always_inline bool vma_flags_test_single_mask(const vma_flags_t *flags,
+		vma_flags_t flagmask)
+{
+	VM_WARN_ON_ONCE(vma_flags_count(&flagmask) > 1);
+
+	return vma_flags_test_any_mask(flags, flagmask);
+}
+
 /* Set each of the to_set flags in flags, non-atomically. */
 static __always_inline void vma_flags_set_mask(vma_flags_t *flags,
 		vma_flags_t to_set)
@@ -1286,6 +1314,24 @@ static __always_inline bool vma_test_all_mask(const struct vm_area_struct *vma,
 #define vma_test_all(vma, ...) \
 	vma_test_all_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+/*
+ * Helper to test that a flag mask of type vma_flags_t has a SINGLE flag set
+ * (returning false if flagmask has no flags set).
+ *
+ * This is useful when a flag needs to be either defined or not depending upon
+ * kernel configuration, e.g.:
+ *
+ * if (vma_test_single_mask(vma, VMA_DROPPABLE)) { ... }
+ *
+ * When VMA_DROPPABLE is defined if available, or set to EMPTY_VMA_FLAGS
+ * otherwise.
+ */
+static __always_inline bool
+vma_test_single_mask(const struct vm_area_struct *vma, vma_flags_t flagmask)
+{
+	return vma_flags_test_single_mask(&vma->flags, flagmask);
+}
+
 /*
  * Helper to set all VMA flags in a VMA.
  *
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 2c498e713fbd..b7d9eb0a44e4 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -15,12 +15,6 @@ extern unsigned long dac_mmap_min_addr;
 #define dac_mmap_min_addr	0UL
 #endif
 
-#define VM_WARN_ON(_expr) (WARN_ON(_expr))
-#define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
-#define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
-#define VM_BUG_ON(_expr) (BUG_ON(_expr))
-#define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
-
 #define TASK_SIZE ((1ul << 47)-PAGE_SIZE)
 
 /*
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index f9fe07a8a443..244ee02dc21d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -905,6 +905,13 @@ static __always_inline vma_flags_t __mk_vma_flags(vma_flags_t flags,
 #define append_vma_flags(flags, ...) __mk_vma_flags(flags,			\
 		COUNT_ARGS(__VA_ARGS__), (const vma_flag_t []){__VA_ARGS__})
 
+static __always_inline int vma_flags_count(const vma_flags_t *flags)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return bitmap_weight(bitmap, NUM_VMA_FLAG_BITS);
+}
+
 static __always_inline bool vma_flags_test(const vma_flags_t *flags,
 		vma_flag_t bit)
 {
@@ -952,6 +959,14 @@ static __always_inline bool vma_flags_test_all_mask(const vma_flags_t *flags,
 #define vma_flags_test_all(flags, ...) \
 	vma_flags_test_all_mask(flags, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline bool vma_flags_test_single_mask(const vma_flags_t *flags,
+						vma_flags_t flagmask)
+{
+	VM_WARN_ON_ONCE(vma_flags_count(&flagmask) > 1);
+
+	return vma_flags_test_any_mask(flags, flagmask);
+}
+
 static __always_inline void vma_flags_set_mask(vma_flags_t *flags, vma_flags_t to_set)
 {
 	unsigned long *bitmap = flags->__vma_flags;
@@ -1031,6 +1046,12 @@ static __always_inline bool vma_test_all_mask(const struct vm_area_struct *vma,
 #define vma_test_all(vma, ...) \
 	vma_test_all_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline bool
+vma_test_single_mask(const struct vm_area_struct *vma, vma_flags_t flagmask)
+{
+	return vma_flags_test_single_mask(&vma->flags, flagmask);
+}
+
 static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
 		vma_flags_t flags)
 {
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 0e1121e2ef23..e12ab2c80f95 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -51,6 +51,12 @@ typedef unsigned long	pgprotval_t;
 typedef struct pgprot { pgprotval_t pgprot; } pgprot_t;
 typedef __bitwise unsigned int vm_fault_t;
 
+#define VM_WARN_ON(_expr) (WARN_ON(_expr))
+#define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
+#define VM_BUG_ON(_expr) (BUG_ON(_expr))
+#define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
+
 #include "include/stubs.h"
 #include "include/dup.h"
 #include "include/custom.h"
-- 
2.53.0


