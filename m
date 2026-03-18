Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B653A10706ED
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2684E6B0288; Wed, 18 Mar 2026 11:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A3C6B028A; Wed, 18 Mar 2026 11:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BF36B028B; Wed, 18 Mar 2026 11:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E53BD6B0288
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:50:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B15671A084C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:59 +0000 (UTC)
X-FDA: 84559622238.23.0D71858
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 220BA40006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="K/Iw+dkz";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyWoGHB40e9zmtkAnucvBo3IE3FL6byo69xHowl4Y+0=;
	b=Tb4jYkZZMKtSqVvCjKDhC1ETmaFgYOXaSJfEHE+o6KJhI3LfMlSZD/+decQVW4pWLvG68E
	MzBHT/QRrH5GlqtYKStiw5WWv2yWs3niGDZBLQW8dSBiVYE8IdMjJSfLsnPqJXcs6sz1ys
	QsOOKN4t0acDYGsmcWqkHYoEhKSeuHc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="K/Iw+dkz";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849058; a=rsa-sha256;
	cv=none;
	b=6zQ26U7bDuYWW9hLs3HHoeZz+lF/9flc/GmG84A2bbs1AiQGGdSPHayGCLYeJ7yYaqy0f4
	CgmYHiSLlTVTTbGFHNLVG/Hjt0cmPPKJ9VjcYBIDCPKTow6LOpwr8d7zGNprHrpofxdW5a
	HmGg0E+lkFerUXCKKfXUPBXwrX8LgBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73ABA6013E;
	Wed, 18 Mar 2026 15:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A56CC2BCB0;
	Wed, 18 Mar 2026 15:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849057;
	bh=sXTA38aR3D+fdGqayQPYQbnT5BeFDDGI8fzyIj7UQaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/Iw+dkzcdg0NlPM33x+vkwnW6DVOT0gLkmkC2ylMxTmGXsA6eVnqRCwn1OsobAi0
	 6P8PhOl444c2jzI7Yutrtsqi/16jje6mjnFKzxXqhvyViWYifCjm+3kGRdh+dCobaj
	 zxL7vpSW7cIhmXKd5FDOkIDkfA8ANDckQ55Q7Ds7aDDK+JTzrsbB7OSTnjw2THYC8n
	 GpqQ2RLdq+L5K5M3icxa5/k//wLEEU4nl2I5t4ggnxZLw01A3Kp3GCNl57C2/OUYyW
	 VgcEHin3BstoJsJIemDpHCgpLSWm0XFf03WvvXKNV9iT0WNAHF145MbAvoZrqeKe4s
	 npRiCrtMSzaMw==
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
Subject: [PATCH v3 06/23] tools/testing/vma: fix VMA flag tests
Date: Wed, 18 Mar 2026 15:50:17 +0000
Message-ID: <d2050c8d8d7ef7ef118267031df73bb5c747df3e.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 220BA40006
X-Stat-Signature: zkbkzwgsb6g5ct6wp55bhs7bu4rgfkuw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773849057-704892
X-HE-Meta: U2FsdGVkX19O1U6aZnJHIN7NQtz/8OqWB/cdVL8Be1lfMDzDBcZG29LbA+FHsVLIk7C75OYAjUKAceCPWL5q4OGTr55kXto/nWpzs0dw21dOPKKHhU4hfR60HeKt6MtHAdYHZchuVtB51F+klHtrvtS9Z5lZ6hdhmFr5i3B9k+z65MVwDFKtyIKAmodeV22yOZ6XBoGdk+1T3YevcpxMY2LPjDi1KidGDy5freYqkLp/mydyO6/rg0V9KRWERqrBT7P/MLGKEAUNzLl6ofauYvldXIfh1srcBxp7jh7GNrczp1uKjDZfl760MUgXWp7Lzfl2yigI2/ePEvkceWxTmGxG+4470sgDFdisrDc74bDYlkOR4dGRHM+X8q0zRKtB+8O5nS+pH/CnkXm6/SmKcq52v57V4JeXjqm++NF44DEkMjaABMFA2TAoxNzcT8onSDyVDp0iYNT9p1iP6/AjudXpuC1Rxd6cZEKRj5pN4I39bckjYxYqHE7Xauacxt7MpjMwRLypZ9QKQefgFO1wbgxBfw+e7UTVEAnUnEMCQWvg9Z4ezKz1bVFWDWcEMLFpMnaSXxyl54yfRYfE+wO8XLdE3FBteXiM9MilOoPy23OIhxvKNHi5PNCj1guS9GVr8ehQcY5PmhPhbCzZ+YyEqGVKQWovzx1GaxLfT0GBSAKjSN71eFe8eRe7Gw5lpQ+DLTTo8OhPx9FxhM8pARhzksf9/Eb9WRUEKEKzlGiThozACopOLxr5H2kjSz5WT2PyEh/uH2qwPKLIOAp0vPOxkoCR4Zv2HFhNMCOhbq+q2OgRMRVxtyBpw635V84SM7DG0QNPCq1SPluB0oi5d/Tb4sNe8xuBLT1ZeDoBrcqrur+WI56wL1TxfidOPH9tZ5gEMYO0htV6iu+ev8X+mdOeObfk+30K5lVtCyXpZt68LvBrtSD/TDu6yOkOaWhGBChJDg3T86UwoOXPShgDbiO
 1s5thUFH
 dteGUobtViWvJutj6MSSrpijhJ+y7jjOZXOC2qG10qANZLrAKNsZzi+aGU3/BfHYjS2GyzErIQ8yApPx+np8QOKtmB/D029YpvQybwzRMYE3k+8AZkollSn498b5Lj7GZxf8Ir7ryx56IXKz4O6GRAsDjH/FzNNHz/F7DwIGK0wNN4ylL6C6TfCCL+dKJhMZ45l+jlp0JQyAUT0MX6um/HFlak4Ar02o8bX06jTMux/x4vhKyXfnDxKP5AXkDuu7SfxTvxEgdpwgpEs3pfW++iORAuTinLfmYXs6F/CQA5YapD9I=
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
index 7cdd0f60600a..8f33df02816a 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -29,8 +29,6 @@ extern unsigned long dac_mmap_min_addr;
  */
 #define pr_warn_once pr_err
 
-#define pgtable_supports_soft_dirty() 1
-
 struct anon_vma {
 	struct anon_vma *root;
 	struct rb_root_cached rb_root;
@@ -99,23 +97,6 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
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
 static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 {
 	return PAGE_SIZE;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 65134303b645..3005e33d1ede 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -854,10 +854,21 @@ static inline void vm_flags_clear(struct vm_area_struct *vma,
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
@@ -1390,3 +1401,7 @@ static inline int get_sysctl_max_map_count(void)
 {
 	return READ_ONCE(sysctl_max_map_count);
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


