Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A83103E19D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90916B0296; Wed, 18 Mar 2026 11:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B680F6B0298; Wed, 18 Mar 2026 11:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57876B0299; Wed, 18 Mar 2026 11:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91FC86B0296
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44AB2160864
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:20 +0000 (UTC)
X-FDA: 84559623120.26.E8D2340
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9271740011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=flX+JrcA;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Szhpzheb5+x60/pkbi+PmmRjqrrdj799ncAlFW1BCCs=;
	b=Lp5o1ygkElwrdjlCbDrnOUKlmooJCTZmH+/r8zPjL5lF2DIGJzCD3uxdwGPxXhHbcUvJ/t
	t0cNwGoOeiAfRMSWjaa2lbSfWiKnK1LG9pyWZzu9g059/UGUEnAwjgPG216xk79tlEXroL
	y1DTEZxojnFNhi5mPdPLw4Jq9Sz57GU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=flX+JrcA;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849078; a=rsa-sha256;
	cv=none;
	b=DXCFW6FDZf45Bw1mLxYTrJhU9qMiJSeoWYJSa4ElgoNyhDAMIzLvQxx8iwJIwPYk+dtWY/
	/eC4lX0Ruyj92IEIcGHpO2p3SSuhEKITHyKHSSTTKDolPqi52C30dm/BTHij3HFVdGft+t
	kfOx8lW80XrVbK3aFeCSGFl7QjLTR+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A83156091C;
	Wed, 18 Mar 2026 15:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA0FC19421;
	Wed, 18 Mar 2026 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849077;
	bh=5aVx5Ao5857cPCABjWXjupBGI3eGTimuzba0WTpAO6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flX+JrcAzh4ALOwqLhpYfnWNYaWfc7u00pGMRIQz0nmX/2ETrd1uLVrZzBTOE0aCe
	 1RZQ+08FUazW6cAwp5wHChA1xuQqaNI2YL5DleipUAV9rDuh8We8+3HSOqDfygrXlI
	 m+RqbGkWp3F7n6KG4lnjyfVgrmUXdcAMuECFxtFZIbfPj997avKoPGoYKTHUMw6sTu
	 itpy34AbZKMwX5s/o2PFny3uY3t2UqTSoEGBX/XnRG0QPIjh8f2YhF0i7sOY7VcFJ/
	 ZsKtOyyWuVyCjbVRtq2+CLb8Rq69C51gXZYXGgQQuwNyyvfLWIRFvQVSxEX3lpm6Vt
	 64CvBAuebkKZg==
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
Subject: [PATCH v3 13/23] mm/vma: introduce vma_test[_any[_mask]](), and make inlining consistent
Date: Wed, 18 Mar 2026 15:50:24 +0000
Message-ID: <7ea63af87bd35f20b204a14ad4912592e02b15a6.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9271740011
X-Stat-Signature: 94h8oc9z6cs7smdim7t3961gmpdwtro8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773849078-209928
X-HE-Meta: U2FsdGVkX18azcMZJ9Seb66krXa8m0fRtxJhbINypp9L5BkdfwJhaQ6P+sToFEYitIQIsjNfIxXxpdUN+Afdh6rv8FcJeWB8Ti+RaFmaIqtF1Q2cHyWZagauHf9m5CKiOCQ80D5dpGD7Z3vKV2NnOtKT/F1mXPUZhXtMgvzk08muI0jzGeHxdFHObNk0Kx7QybPTOD/koCw5khmazknz3nqhBucy4U2YTG3FWl49iAz0YFwacPbLA+gmNUtgWQyH9yVXrIuyUU4xORheZ1RMzG9CUAxUQJiZmE9pMeK+7fKJD3/prkg1hB9Uxs0P7sY0C9BVqMxuyCX4IuMvX0SQmtfjVIgu0fI0IjkRQfkXq5GbpptrCluYv6Pxgt+PkzUr45ZB1b9cuRXPf7OJFm+MIMXoYx9/6bsXpJ9uPOyEJ1PNViaq1ab0bDDAyL1ASsiQp1w/IiX3n6uEgJEPJgyrCQBDAWpg+rGKArWtQuna30KcawwuMS/E/yJIHg8mXsBrrlm0B3xDP77haBuxK1NQoikxXiRFoj3a3yzIDh4wYv8nS5yU6j1T5MFkQTvLzcOwpUDJVlmYtCu1p0TeIaCuybl3SarRIRBiCyJIrfeJ7GNxaddJKBNdJbwj2Bq1EP1tdYbzkHuuH3se/UxNPvw3/XLwpFmPzMdmK7urwpxwFpXLMfvvXb4O+YXdSvGeFTICpvUNgoHmWRD7AcfVfZxtnjR/hUvKllv5wuvwizITb2ypQATOCVNocI5cs8I2430Rr+p/qeRmTBMpiAIU+Fs31bJLUq4QkGAQePeNGZaBhbaY12q0GuUQWjxob0qwJxAr0y7DWcjkYR6KmupTqGIN3R4lICNzWbhkagLhRCVeG1u2AlmtIWALs3Q4Ose9muAWuSS5x/200a72B5wmosEA8PRS3xpON91Gt3KgFhgb4mtS7Eui+6EgVtMV/FAoDT4+wGX8s/nZkSbdXiE5+YH
 a4BOinTC
 PvYyIR6nTH+aKUT4QtshfOZEYaU1grxOpNT1HZjyaV8qN7iBuEpYKjLHTB0vl50lCbW15DUWjXb57eJGgjd3IMrRCmBNnlAtviKmEKLFlTYJnS1HBH6APzN5t1YS4J8WtDGPG9og0lA7fFLFAMrCeBoooY6JXO79hJnB7ZUvbkgz34vaxWtKEfblxXZJJBJSLSgcVLM5ZzTlw2jLHo/xivyJcD2fJXAaYzty/R2S7Lz/wdFWRzHsNX8b5yFvmHCWU2thw7hDHEeHsGWll0jMwHIc/vAP+duyAbQpdMmPMgmCHEQaGtV67GLWQ9SZRiRzae+bG4pP74juIXyhbx5zALqfwTFt5epS/FGll
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce helper functions and macros to make it convenient to test flags
and flag masks for VMAs, specifically:

* vma_test() - determine if a single VMA flag is set in a VMA.
* vma_test_any_mask() - determine if any flags in a vma_flags_t value are
			set in a VMA.
* vma_test_any() - Helper macro to test if any of specific flags are set.

Also, there are a mix of 'inline's and '__always_inline's in VMA helper
function declarations, update to consistently use __always_inline.

Finally, update the VMA tests to reflect the changes.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 49 +++++++++++++++++++++-----
 include/linux/mm_types.h        | 12 ++++---
 tools/testing/vma/include/dup.h | 61 +++++++++++++++++++++------------
 3 files changed, 88 insertions(+), 34 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b170cee95e25..47bf9f166924 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -999,7 +999,8 @@ static inline void vm_flags_mod(struct vm_area_struct *vma,
 	__vm_flags_mod(vma, set, clear);
 }
 
-static inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma, vma_flag_t bit)
+static __always_inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
 {
 	const vm_flags_t mask = BIT((__force int)bit);
 
@@ -1014,7 +1015,8 @@ static inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma, vma_flag_
  * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
  * valid flags are allowed to do this.
  */
-static inline void vma_set_atomic_flag(struct vm_area_struct *vma, vma_flag_t bit)
+static __always_inline void vma_set_atomic_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
 {
 	unsigned long *bitmap = vma->flags.__vma_flags;
 
@@ -1030,7 +1032,8 @@ static inline void vma_set_atomic_flag(struct vm_area_struct *vma, vma_flag_t bi
  * This is necessarily racey, so callers must ensure that serialisation is
  * achieved through some other means, or that races are permissible.
  */
-static inline bool vma_test_atomic_flag(struct vm_area_struct *vma, vma_flag_t bit)
+static __always_inline bool vma_test_atomic_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
 {
 	if (__vma_atomic_valid_flag(vma, bit))
 		return test_bit((__force int)bit, &vma->vm_flags);
@@ -1235,13 +1238,41 @@ static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
 #define vma_flags_same(flags, ...) \
 	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
 
+/*
+ * Test whether a specific flag in the VMA is set, e.g.:
+ *
+ * if (vma_test(vma, VMA_READ_BIT)) { ... }
+ */
+static __always_inline bool vma_test(const struct vm_area_struct *vma,
+		vma_flag_t bit)
+{
+	return vma_flags_test(&vma->flags, bit);
+}
+
+/* Helper to test any VMA flags in a VMA . */
+static __always_inline bool vma_test_any_mask(const struct vm_area_struct *vma,
+		vma_flags_t flags)
+{
+	return vma_flags_test_any_mask(&vma->flags, flags);
+}
+
+/*
+ * Helper macro for testing whether any VMA flags are set in a VMA,
+ * e.g.:
+ *
+ * if (vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT,
+ *		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)) { ... }
+ */
+#define vma_test_any(vma, ...) \
+	vma_test_any_mask(vma, mk_vma_flags(__VA_ARGS__))
+
 /*
  * Helper to test that ALL specified flags are set in a VMA.
  *
  * Note: appropriate locks must be held, this function does not acquire them for
  * you.
  */
-static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
+static __always_inline bool vma_test_all_mask(const struct vm_area_struct *vma,
 		vma_flags_t flags)
 {
 	return vma_flags_test_all_mask(&vma->flags, flags);
@@ -1261,7 +1292,7 @@ static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
  * Note: appropriate locks must be held, this function does not acquire them for
  * you.
  */
-static inline void vma_set_flags_mask(struct vm_area_struct *vma,
+static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
 		vma_flags_t flags)
 {
 	vma_flags_set_mask(&vma->flags, flags);
@@ -1291,7 +1322,7 @@ static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 }
 
 /* Helper to test any VMA flags in a VMA descriptor. */
-static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
+static __always_inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 		vma_flags_t flags)
 {
 	return vma_flags_test_any_mask(&desc->vma_flags, flags);
@@ -1308,7 +1339,7 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
 /* Helper to test all VMA flags in a VMA descriptor. */
-static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
+static __always_inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
 		vma_flags_t flags)
 {
 	return vma_flags_test_all_mask(&desc->vma_flags, flags);
@@ -1324,7 +1355,7 @@ static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
 	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
 
 /* Helper to set all VMA flags in a VMA descriptor. */
-static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
+static __always_inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
 		vma_flags_t flags)
 {
 	vma_flags_set_mask(&desc->vma_flags, flags);
@@ -1341,7 +1372,7 @@ static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
 	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
 
 /* Helper to clear all VMA flags in a VMA descriptor. */
-static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
+static __always_inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
 		vma_flags_t flags)
 {
 	vma_flags_clear_mask(&desc->vma_flags, flags);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index c5ad55b8a45b..16d31045e26e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1087,7 +1087,8 @@ static __always_inline vm_flags_t vma_flags_to_legacy(vma_flags_t flags)
  * IMPORTANT: This does not overwrite bytes past the first system word. The
  * caller must account for this.
  */
-static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_overwrite_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
@@ -1114,7 +1115,8 @@ static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
  * IMPORTANT: This does not overwrite bytes past the first system word. The
  * caller must account for this.
  */
-static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_overwrite_word_once(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
@@ -1122,7 +1124,8 @@ static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned lo
 }
 
 /* Update the first system word of VMA flags setting bits, non-atomically. */
-static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_set_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
@@ -1130,7 +1133,8 @@ static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
 }
 
 /* Update the first system word of VMA flags clearing bits, non-atomically. */
-static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_clear_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index f49af21319ba..f9fe07a8a443 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -764,7 +764,8 @@ static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
  * IMPORTANT: This does not overwrite bytes past the first system word. The
  * caller must account for this.
  */
-static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_overwrite_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
@@ -777,7 +778,8 @@ static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long va
  * IMPORTANT: This does not overwrite bytes past the first system word. The
  * caller must account for this.
  */
-static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_overwrite_word_once(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
@@ -785,7 +787,8 @@ static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned lo
 }
 
 /* Update the first system word of VMA flags setting bits, non-atomically. */
-static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_set_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
@@ -793,7 +796,8 @@ static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
 }
 
 /* Update the first system word of VMA flags clearing bits, non-atomically. */
-static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_clear_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
@@ -1003,23 +1007,32 @@ static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
 #define vma_flags_same(flags, ...) \
 	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
 
-static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
-				     vma_flags_t flags)
+static __always_inline bool vma_test(const struct vm_area_struct *vma,
+		vma_flag_t bit)
 {
-	return vma_flags_test_all_mask(&vma->flags, flags);
+	return vma_flags_test(&vma->flags, bit);
 }
 
-#define vma_test_all(vma, ...) \
-	vma_test_all_mask(vma, mk_vma_flags(__VA_ARGS__))
+static __always_inline bool vma_test_any_mask(const struct vm_area_struct *vma,
+		vma_flags_t flags)
+{
+	return vma_flags_test_any_mask(&vma->flags, flags);
+}
 
-static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
+#define vma_test_any(vma, ...) \
+	vma_test_any_mask(vma, mk_vma_flags(__VA_ARGS__))
+
+static __always_inline bool vma_test_all_mask(const struct vm_area_struct *vma,
+		vma_flags_t flags)
 {
-	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
-		(VM_SHARED | VM_MAYWRITE);
+	return vma_flags_test_all_mask(&vma->flags, flags);
 }
 
-static inline void vma_set_flags_mask(struct vm_area_struct *vma,
-				      vma_flags_t flags)
+#define vma_test_all(vma, ...) \
+	vma_test_all_mask(vma, mk_vma_flags(__VA_ARGS__))
+
+static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
+		vma_flags_t flags)
 {
 	vma_flags_set_mask(&vma->flags, flags);
 }
@@ -1033,8 +1046,8 @@ static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 	return vma_flags_test(&desc->vma_flags, bit);
 }
 
-static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
-					    vma_flags_t flags)
+static __always_inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
+		vma_flags_t flags)
 {
 	return vma_flags_test_any_mask(&desc->vma_flags, flags);
 }
@@ -1042,7 +1055,7 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 #define vma_desc_test_any(desc, ...) \
 	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
+static __always_inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
 		vma_flags_t flags)
 {
 	return vma_flags_test_all_mask(&desc->vma_flags, flags);
@@ -1051,8 +1064,8 @@ static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
 #define vma_desc_test_all(desc, ...) \
 	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
-					   vma_flags_t flags)
+static __always_inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
+		vma_flags_t flags)
 {
 	vma_flags_set_mask(&desc->vma_flags, flags);
 }
@@ -1060,8 +1073,8 @@ static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
 #define vma_desc_set_flags(desc, ...) \
 	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
-					     vma_flags_t flags)
+static __always_inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
+		vma_flags_t flags)
 {
 	vma_flags_clear_mask(&desc->vma_flags, flags);
 }
@@ -1069,6 +1082,12 @@ static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
 #define vma_desc_clear_flags(desc, ...) \
 	vma_desc_clear_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
 
+static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
+{
+	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
+		(VM_SHARED | VM_MAYWRITE);
+}
+
 static inline bool is_shared_maywrite(const vma_flags_t *flags)
 {
 	return vma_flags_test_all(flags, VMA_SHARED_BIT, VMA_MAYWRITE_BIT);
-- 
2.53.0


