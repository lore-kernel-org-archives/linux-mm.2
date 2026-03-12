Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85FD106ACE0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5443F6B0093; Thu, 12 Mar 2026 15:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502246B0096; Thu, 12 Mar 2026 15:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E566B0098; Thu, 12 Mar 2026 15:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27BBE6B0093
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:16:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDEFDC1AE0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:51 +0000 (UTC)
X-FDA: 84538368222.28.C27D47F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C28014000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kc2bIDmr;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gukifNPVmxiYWGKmsIm5DRlEy23h3gScgka1tW8j/WY=;
	b=w2Kv9zJEWKLw7nwsfmNudQ9wI3iZKS1/Q2gtMOxJkGBwmrkc+qoLDI4y6SjwSUZXSV2dOX
	bAnoYZkqmnO0HYhdbNic52CeiTZeqMZFCnain2mT43IRwA0LUALghnxku3jRhHceb8D2+M
	snC9YErx05eS8MEod6MbMCfGRZBIcn4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kc2bIDmr;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343010; a=rsa-sha256;
	cv=none;
	b=T6ivDcShpA5BXYwTvaNgqnyza+90roygRJT4T1YrSI1X7fiYi4Z6Wue94xd0TRZrvBF/NA
	yPlGqu47WtKYQRMVNCyyfe25PH6SKA0+wjJaISnMQp+Cr7oXeVAXTVd1ZYcfdiPIY+WiFR
	TpAgyNdCWYNz+xz/5+rxzD6tnxmuRrw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 381D444529;
	Thu, 12 Mar 2026 19:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D92C4CEF7;
	Thu, 12 Mar 2026 19:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343009;
	bh=xB3bkgO57EModmdmiLdzTE62iI/ypq3Bd1g0ZEjOR5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kc2bIDmrYN4dElaB4e0OoP/AY9mPHHAayKT/zERy+Kmu9W2IWwXs+XxhXGDyo18DM
	 R9NrbRxAvbh9enn3YWikXoRa6xMdZr4rFbIMs80AqMfBCcx9/4/JUXPjxmgE3Lj3Ek
	 0inVEuPsIdX0kPc7999jMVKy7d7Mn+eE2yA7L4PYwK+RAw5Vcjhgyn1L2AFABmBPz+
	 EklvkygxmiFlJV1E9IIrxt2fAqjQ9u9/Gq48wNHLnKU+6JIoUIBgj+sr12tnbVMRlk
	 uYTSHZebWxiYvn45M51kOGGWuovHhKsdcqLuLyd+MxJfJpqUhw0KurFPrR1tuJzi0n
	 J1aU+So9cp6Mg==
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
Subject: [PATCH 06/20] tools/testing/vma: fix VMA flag tests
Date: Thu, 12 Mar 2026 19:16:04 +0000
Message-ID: <a724c44adcc5f3dab4410b469cb812ad1f616a13.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ec5qzmb56si1oh4m4suytjko1xojjudg
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C28014000A
X-HE-Tag: 1773343009-610263
X-HE-Meta: U2FsdGVkX19tUT+APtfUi+lwzEYew+JIjLxR1XtMDYjv/MH9itREQZ/ARs4gYvSgD9qrkIHwVH4KY4C7RSZSP7pYW+u9peq38KkIxfg3/7h80K0zJpKIE27uvpP236hJWOwPDBsyLddDqCm80dhmYtZiKX+2wMtbebMceNdy+KjX7DtJCSCzOpDxVtM5r6YazzFfZFhAJC5F28rl0XiQmTaGza0qEwc5fuJcMaiyPXY7dNWVa1H3MQIhjyKldunu+2VK6GSxAjd6goU8toFoMGCTaSKp2nofY35XQf29nZr5KPEJMty72+mX2cPLqquzyiPcnC0QffwHMptW7f/K1rf1jm66qWMjWeZ4abn1D7CmH5kPAyM/Xi8/x018EKA2FhVy/QHJ9nhbjBO30n2LQ1jdJ2/VjFBC9VJk6BgRfdUkheQ0z/Cci+qhoobrcdOKAD+RGXXjjr+xe1vZtP2abZPu57ys/rD9R/XxtI80o1UN3CJugDQyoPB9H5rgBNIJT5Cq4Dl8wCxbpx+S1No7KuMmjEEWP+jEwDmgTWUgXVbpuLWqAjLNbgdGAw6vt/oBdqJqSy27N1YkaxZaPKjfFCi6jUpWFFjPKTUA2YVooxfzLmGlkFXHkuX0eAy28Y3BHOjcjdGfZxna50ulFwdZFYZ7kS+cZugCuGLzv66hDQr8stq5wUbEaVtVTSb3vdrnO3lo0Zzg70hstp9v/F64XNfh/cfzdFtTS1lfmZ0Qk1tGlFKBaHT5776n4Cmutfd9dRyUpIp3buKkFmNRoDCtlRvyCyTNMLxcZ8KMOvkpBjMRBhMWrnK2izd65Uz8Uq9zirU476ggTvdL6+4rnzKPEeGzEEsudxv0A/OJFPB22QDyfHBddkFdUqI4NAky/3WQZj2Oz1fZBvKBR3JNEetue9Np4mgY93f4lJ3jVkFAdGVOXr2XW7rqnzA9ifMG7qlbBCb8e3h008RWEDrXa0+
 t3xBXPve
 qZAHVKJi4dwfxaL+YsOpimeM4IQEs1qgCcZbfT3ZI7egUJ4vpH0FmWk1JHxO3DvB/lWaeB5GyjLlnx8/8Nu7kplmw/RQnhImwckRn6j7LndG7f1HYZCsw7M9hG5Ils4KgxLt1llreuBbsyrl1bLOisyFXksugagDc/Ye2t/GJryA5Sulyml9dqbME7gu441wk1hQdU7zD2djKO4ws2IDESZ2AlwaPRkOvi8GuF9hOVtGBzxMNwm9GLSACQlIeL7jSjG/Cg/e0DVhr6RUAD7C3s63N8csZGSiJtYnp496J6jSudgl4AjjGJZvIZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMA tests are incorrectly referencing NUM_VMA_FLAGS, which doesn't
exist, rather they should reference NUM_VMA_FLAG_BITS.

Additionally, remove the custom-written implementation of __mk_vma_flags()
as this means we are not testing the code as present in the kernel, rather
add the actual __mk_vma_flags() to dup.h and add #ifdef's to handle
declarations differently depending on NUM_VMA_FLAG_BITS.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/include/custom.h | 19 -------
 tools/testing/vma/include/dup.h    | 21 ++++++-
 tools/testing/vma/tests/vma.c      | 88 +++++++++++++++++++++++++-----
 3 files changed, 92 insertions(+), 36 deletions(-)

diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 6f43bbc494e2..433b3396c281 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -32,8 +32,6 @@ extern unsigned long dac_mmap_min_addr;
  */
 #define pr_warn_once pr_err
 
-#define pgtable_supports_soft_dirty() 1
-
 struct anon_vma {
 	struct anon_vma *root;
 	struct rb_root_cached rb_root;
@@ -102,23 +100,6 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 		refcount_set(&vma->vm_refcnt, 0);
 }
 
-static __always_inline vma_flags_t __mk_vma_flags(size_t count,
-		const vma_flag_t *bits)
-{
-	vma_flags_t flags;
-	int i;
-
-	/*
-	 * For testing purposes: allow invalid bit specification so we can
-	 * easily test.
-	 */
-	vma_flags_clear_all(&flags);
-	for (i = 0; i < count; i++)
-		if (bits[i] < NUM_VMA_FLAG_BITS)
-			vma_flags_set_flag(&flags, bits[i]);
-	return flags;
-}
-
 /* Place here until needed in the kernel code. */
 static __always_inline bool vma_flags_same_mask(vma_flags_t *flags,
 						vma_flags_t flags_other)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 069910f63b84..29ff6c97f37a 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -851,10 +851,21 @@ static inline void vm_flags_clear(struct vm_area_struct *vma,
 	vma_flags_clear_word(&vma->flags, flags);
 }
 
-static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits);
+static __always_inline vma_flags_t __mk_vma_flags(size_t count,
+		const vma_flag_t *bits)
+{
+	vma_flags_t flags;
+	int i;
+
+	vma_flags_clear_all(&flags);
+	for (i = 0; i < count; i++)
+		vma_flags_set_flag(&flags, bits[i]);
+
+	return flags;
+}
 
-#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
-					 (const vma_flag_t []){__VA_ARGS__})
+#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__),	\
+		(const vma_flag_t []){__VA_ARGS__})
 
 static __always_inline bool vma_flags_test(const vma_flags_t *flags,
 		vma_flag_t bit)
@@ -1381,3 +1392,7 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
 	swap(vma->vm_file, file);
 	fput(file);
 }
+
+#ifndef pgtable_supports_soft_dirty
+#define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
+#endif
diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index b2f068c3d6d0..feea6d270233 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -5,11 +5,11 @@ static bool compare_legacy_flags(vm_flags_t legacy_flags, vma_flags_t flags)
 	const unsigned long legacy_val = legacy_flags;
 	/* The lower word should contain the precise same value. */
 	const unsigned long flags_lower = flags.__vma_flags[0];
-#if NUM_VMA_FLAGS > BITS_PER_LONG
+#if NUM_VMA_FLAG_BITS > BITS_PER_LONG
 	int i;
 
 	/* All bits in higher flag values should be zero. */
-	for (i = 1; i < NUM_VMA_FLAGS / BITS_PER_LONG; i++) {
+	for (i = 1; i < NUM_VMA_FLAG_BITS / BITS_PER_LONG; i++) {
 		if (flags.__vma_flags[i] != 0)
 			return false;
 	}
@@ -116,6 +116,7 @@ static bool test_vma_flags_cleared(void)
 	return true;
 }
 
+#if NUM_VMA_FLAG_BITS > 64
 /*
  * Assert that VMA flag functions that operate at the system word level function
  * correctly.
@@ -124,10 +125,14 @@ static bool test_vma_flags_word(void)
 {
 	vma_flags_t flags = EMPTY_VMA_FLAGS;
 	const vma_flags_t comparison =
-		mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, 64, 65);
+		mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT
+
+			     , 64, 65
+			);
 
 	/* Set some custom high flags. */
 	vma_flags_set(&flags, 64, 65);
+
 	/* Now overwrite the first word. */
 	vma_flags_overwrite_word(&flags, VM_READ | VM_WRITE);
 	/* Ensure they are equal. */
@@ -158,12 +163,17 @@ static bool test_vma_flags_word(void)
 
 	return true;
 }
+#endif /* NUM_VMA_FLAG_BITS > 64 */
 
 /* Ensure that vma_flags_test() and friends works correctly. */
 static bool test_vma_flags_test(void)
 {
 	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
-					       VMA_EXEC_BIT, 64, 65);
+					       VMA_EXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					       , 64, 65
+#endif
+		);
 	struct vm_area_desc desc = {
 		.vma_flags = flags,
 	};
@@ -198,7 +208,11 @@ static bool test_vma_flags_test(void)
 static bool test_vma_flags_test_any(void)
 {
 	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
-					       VMA_EXEC_BIT, 64, 65);
+					       VMA_EXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					       , 64, 65
+#endif
+		);
 	struct vm_area_struct vma;
 	struct vm_area_desc desc;
 
@@ -224,10 +238,12 @@ static bool test_vma_flags_test_any(void)
 	do_test(VMA_READ_BIT, VMA_MAYREAD_BIT, VMA_SEQ_READ_BIT);
 	/* However, the ...test_all() variant should NOT pass. */
 	do_test_all_false(VMA_READ_BIT, VMA_MAYREAD_BIT, VMA_SEQ_READ_BIT);
+#if NUM_VMA_FLAG_BITS > 64
 	/* But should pass for flags present. */
 	do_test_all_true(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64, 65);
 	/* Also subsets... */
 	do_test_all_true(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64);
+#endif
 	do_test_all_true(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
 	do_test_all_true(VMA_READ_BIT, VMA_WRITE_BIT);
 	do_test_all_true(VMA_READ_BIT);
@@ -291,8 +307,16 @@ static bool test_vma_flags_test_any(void)
 static bool test_vma_flags_clear(void)
 {
 	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
-					 VMA_EXEC_BIT, 64, 65);
-	vma_flags_t mask = mk_vma_flags(VMA_EXEC_BIT, 64);
+					 VMA_EXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					       , 64, 65
+#endif
+		);
+	vma_flags_t mask = mk_vma_flags(VMA_EXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					, 64
+#endif
+		);
 	struct vm_area_struct vma;
 	struct vm_area_desc desc;
 
@@ -303,6 +327,7 @@ static bool test_vma_flags_clear(void)
 	vma_flags_clear_mask(&flags, mask);
 	vma_flags_clear_mask(&vma.flags, mask);
 	vma_desc_clear_flags_mask(&desc, mask);
+#if NUM_VMA_FLAG_BITS > 64
 	ASSERT_FALSE(vma_flags_test_any(&flags, VMA_EXEC_BIT, 64));
 	ASSERT_FALSE(vma_flags_test_any(&vma.flags, VMA_EXEC_BIT, 64));
 	ASSERT_FALSE(vma_desc_test_any(&desc, VMA_EXEC_BIT, 64));
@@ -310,6 +335,7 @@ static bool test_vma_flags_clear(void)
 	vma_flags_set(&flags, VMA_EXEC_BIT, 64);
 	vma_set_flags(&vma, VMA_EXEC_BIT, 64);
 	vma_desc_set_flags(&desc, VMA_EXEC_BIT, 64);
+#endif
 
 	/*
 	 * Clear the flags and assert clear worked, then reset flags back to
@@ -330,20 +356,27 @@ static bool test_vma_flags_clear(void)
 	do_test_and_reset(VMA_READ_BIT);
 	do_test_and_reset(VMA_WRITE_BIT);
 	do_test_and_reset(VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
 	do_test_and_reset(64);
 	do_test_and_reset(65);
+#endif
 
 	/* Two flags, in different orders. */
 	do_test_and_reset(VMA_READ_BIT, VMA_WRITE_BIT);
 	do_test_and_reset(VMA_READ_BIT, VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
 	do_test_and_reset(VMA_READ_BIT, 64);
 	do_test_and_reset(VMA_READ_BIT, 65);
+#endif
 	do_test_and_reset(VMA_WRITE_BIT, VMA_READ_BIT);
 	do_test_and_reset(VMA_WRITE_BIT, VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
 	do_test_and_reset(VMA_WRITE_BIT, 64);
 	do_test_and_reset(VMA_WRITE_BIT, 65);
+#endif
 	do_test_and_reset(VMA_EXEC_BIT, VMA_READ_BIT);
 	do_test_and_reset(VMA_EXEC_BIT, VMA_WRITE_BIT);
+#if NUM_VMA_FLAG_BITS > 64
 	do_test_and_reset(VMA_EXEC_BIT, 64);
 	do_test_and_reset(VMA_EXEC_BIT, 65);
 	do_test_and_reset(64, VMA_READ_BIT);
@@ -354,6 +387,7 @@ static bool test_vma_flags_clear(void)
 	do_test_and_reset(65, VMA_WRITE_BIT);
 	do_test_and_reset(65, VMA_EXEC_BIT);
 	do_test_and_reset(65, 64);
+#endif
 
 	/* Three flags. */
 
@@ -367,7 +401,11 @@ static bool test_vma_flags_clear(void)
 static bool test_vma_flags_empty(void)
 {
 	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
-					 VMA_EXEC_BIT, 64, 65);
+					 VMA_EXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					       , 64, 65
+#endif
+		);
 
 	ASSERT_FLAGS_NONEMPTY(&flags);
 	vma_flags_clear(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
@@ -386,10 +424,19 @@ static bool test_vma_flags_empty(void)
 static bool test_vma_flags_diff(void)
 {
 	vma_flags_t flags1 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
-					  VMA_EXEC_BIT, 64, 65);
+					  VMA_EXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					       , 64, 65
+#endif
+		);
+
 	vma_flags_t flags2 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
 					  VMA_EXEC_BIT, VMA_MAYWRITE_BIT,
-					  VMA_MAYEXEC_BIT, 64, 65, 66, 67);
+					  VMA_MAYEXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					  , 64, 65, 66, 67
+#endif
+		);
 	vma_flags_t diff = vma_flags_diff_pair(&flags1, &flags2);
 
 #if NUM_VMA_FLAG_BITS > 64
@@ -432,12 +479,23 @@ static bool test_vma_flags_diff(void)
 static bool test_vma_flags_and(void)
 {
 	vma_flags_t flags1 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
-					  VMA_EXEC_BIT, 64, 65);
+					  VMA_EXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					       , 64, 65
+#endif
+		);
 	vma_flags_t flags2 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
 					  VMA_EXEC_BIT, VMA_MAYWRITE_BIT,
-					  VMA_MAYEXEC_BIT, 64, 65, 66, 67);
-	vma_flags_t flags3 = mk_vma_flags(VMA_IO_BIT, VMA_MAYBE_GUARD_BIT,
-					  68, 69);
+					  VMA_MAYEXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					  , 64, 65, 66, 67
+#endif
+		);
+	vma_flags_t flags3 = mk_vma_flags(VMA_IO_BIT, VMA_MAYBE_GUARD_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					  , 68, 69
+#endif
+		);
 	vma_flags_t and = vma_flags_and_mask(&flags1, flags2);
 
 #if NUM_VMA_FLAG_BITS > 64
@@ -502,7 +560,9 @@ static void run_vma_tests(int *num_tests, int *num_fail)
 	TEST(copy_vma);
 	TEST(vma_flags_unchanged);
 	TEST(vma_flags_cleared);
+#if NUM_VMA_FLAG_BITS > 64
 	TEST(vma_flags_word);
+#endif
 	TEST(vma_flags_test);
 	TEST(vma_flags_test_any);
 	TEST(vma_flags_clear);
-- 
2.53.0


