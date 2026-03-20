Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3401099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4926E6B0177; Fri, 20 Mar 2026 15:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A766B017B; Fri, 20 Mar 2026 15:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332396B017C; Fri, 20 Mar 2026 15:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 190826B0177
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4A671402E5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:18 +0000 (UTC)
X-FDA: 84567455196.08.D2F40C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1338A1C000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8NRizsP;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXbFegQ1usSGqy18R+Dr40oO6qgyRj1aQGeTcQb/bQs=;
	b=l1jG48zCHZGG496+GJ1Dt+j9IOOBuqQxb/X1M9HQvnVptPdCxEyt1lHttqLCc+3DnlOMg8
	MKLwyHrz1HhqX1dnmy8leBarz6ICkwG0P25xGalNXe3AjHV9m0r5OJyq8zwynu+Tabuhv0
	wsz+KH+oI7b+OGlg6fBucI68TVIPAvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035557; a=rsa-sha256;
	cv=none;
	b=A7RdbrWEdr7UbCvjL78BnQZIWVE4Bpz6WYYtLYhX4h+M9Jdhgvr9mGh20hufLYoo7V4Rcx
	Tc9b4yU19dZi0htFWkEs3ocB7JizqnMZkAPQETKXQKifZ3A3C6UJZQ+J9lCZ3CRE4x6XTr
	DrvKNpmV6R6fCjRLHpNUrp2FA7nKC9c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8NRizsP;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2054A42D56;
	Fri, 20 Mar 2026 19:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE46C2BCAF;
	Fri, 20 Mar 2026 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035556;
	bh=75AA3POmnrofOVgvNS3ujKeXMtoo1Jxrkj2CrXjWe/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8NRizsPEt9w1+zxcwQQBo/8SouKkTjJUjmM+1HXJ+fc9GLhVOIfL2m5bYYUMo4hN
	 jMBf4nwCQUQK0uuFOxGb29ymlICAVjgmyxYU7U4Htfrcpearf0vUD7xWLp3XrmD6j5
	 RFxHxOFT1fofzUVCtX15NjQvSJs9D4CEGt0zB+ELRt/f42Z77Iqz/RgLwu6XKDtJh8
	 IqA7DfXCv1me5BNDMlGqBapl+SMFPHB8AC2HkcMbBOdb507pqrNWDmk3tVNUNoSOvz
	 4ydixNFUpwekgmvpgoP+OqgicQnaqM0KjZbaCrgM8FYolJy0Syv2NiVzW5Zru+4Ssg
	 4v1PFsyBmqI8w==
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
Subject: [PATCH v4 13/25] mm/vma: introduce vma_test[_any[_mask]](), and make inlining consistent
Date: Fri, 20 Mar 2026 19:38:30 +0000
Message-ID: <be1d71f08307d747a82232cbd8664a88c0f41419.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1338A1C000E
X-Stat-Signature: nbzu8yutsbk44fzxs4yxq5butbdgpz6m
X-Rspam-User: 
X-HE-Tag: 1774035556-23889
X-HE-Meta: U2FsdGVkX1+cKPb8mbJWE8dD4rX3OZxTut0X5tsm1XJuMJ0v0vQYkKVl2zhT0ZIlKMiV5+3JCprhPCjfRVAUGwbnYpqmZXiNu/O9REPleKFyL+NALKfAzW0RyXoN8cjxQ2BmbHqqGxW4owZj7Bk5mOcOCA4j92Bf12YNRn+PqNEAkja2iIkIDgEBk+8db7e8B4P+ajFq/pSf6bHzZsb9rHWlGELtukuVVEADJenuohX0A7tAtnLGV3JNPjVCg+PlrPW5OkNEj8TVBVCTUe4abtXFdR6qA//0R2fhR79rpIir1jKGRfbITHdsQpldpKfMQLCqwVqjoMpWuoV3nfh+wpTVLbgvmjkwn36rMLD/9tWz7MB6IvDEAe0+hT0cN6olS0yYNKD9rTuuPNNWblTwd1NrCbDEeHoeFrHd64JnFXNjsUiA8FN/AGdcCwJDICkxlPFbwOnd3JAd7fVgLw1bH5Qq9kMx7s5T7tTQPBUwjDjmSFEmy6/toix1FlMpUD7pJPHoLxhV49XczK9v1UiklkfFhPknM9jIL9FEUlyxcKnwqtVTUFFJ8XKAjc9IrJ8lFtfnYoyC+Vbwav9CflRRgCbGGBSoJg9apWXut7HvK0UWIOxIORhhh2iB0+1yodDyHPROdWhfBfwutyGKtpOYxV7XxGZe5wjis47ehgBt7O7E2SmGSGb3NJOHAzchoRAKtHWda6CH+8ywfuY7QIadnJphOi6XZA3aiMwtrqMortjzmalgxRv5sjyTZAasnO7hCCFdYy7UdVNqyDG2Eq0xXR17PYVuxXzuSpyItsk8gNXp7cr1pWYxW3NnfUlYxACaFStwi8wFd04HyBZN6opb9PmfqoxanmkWA+onBZ0RBRF+biR1yglysYLJ5zyxAncc5HAgw0X2hMLYeTxFY0SpETBRTZm3E7I8mzhST0FPyBfSMae5Gq9sbeEma+/r8Z13K/AzktDsN3+Rga0M53H
 GbeoH2Ay
 zl/K1DropnGUW2NQQDsNFlv4fzCPdWKFYIUi/ZK0gIDmz60p/Mpcwf0+MpmCj53h/3snT5Fvp+ACRV/EK/itIdzSHW9LP1VBouMkqCm2uyS/XvW0cAA5XI2zHMIZNj8Lh9nAzMNRx5brEeMc0j5iE4M9X/r3j0nOH6duRz/uoFn9RKA4SJ5ZxwxTahEWMkDj4NhLXuj+22J7f+NYpKYlhQlk7rhkg5/NdamtODDcUmjqRVtAL0rpyVKZjfcGIPEe8J00D4TmwcfC8r7YxL4QZnFQUaoO1fkjiO8hoyMr0Zsh6vaxDHx5Q/DS0W5Wq0RXR06T1tDcdKIYv4lNp/7iEGxs72okspEKyk7s/
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

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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


