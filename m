Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C253F506D1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8996A6B0279; Mon, 16 Mar 2026 09:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813A96B027A; Mon, 16 Mar 2026 09:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FBB6B027B; Mon, 16 Mar 2026 09:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4DD6B0279
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E9FEB6250
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:34 +0000 (UTC)
X-FDA: 84551957868.06.295524D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 52DDD120010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNWelni9;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0oSNWAm6uJ/dVM6QRgFm8r7HKCiIb/uF4G7CYGmEr8=;
	b=uGoXYpgNxT3zwszKnhvDUczjtlGJPtaRv0oHYCJf+tM29z9jePSNZnZl1Vl6YCUzM1Sd8l
	8+u1ns+I7xPGgIbZO1ew+afxrbBrDEv+2NeaE8wNat0r3DUxVWUidUsf1qIz28gIw7GK/J
	3o3ggVN3DEnOgb9kCECg9VVBRTvnbVU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNWelni9;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666572; a=rsa-sha256;
	cv=none;
	b=qE5uY0nNqfrL84c8cqine5WHrmq8AMUoKW6wKebJmqV3IVwbK2hNGPf5In2iLG27DkI022
	fVAuT3+cxvBdiWsaOAI0AQ5lbrfiWAyb2mWBMtrs9dzpwzsFXOG2md/Z33EE9jfKnUT7iu
	slUtWe8NRt0C+yF/Bx2NUhZ+Of+CufY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 762E041A1C;
	Mon, 16 Mar 2026 13:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68F0C2BCB0;
	Mon, 16 Mar 2026 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666571;
	bh=F2tybfAGdPnh+Tv/0HGbZI2fLINm8ptQx8MC00GVkqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNWelni9/2N9P89CcC2jtZYRNjPR5YrxwNVAm7RMhOpS+R7piAV3xGLQ4BmWm5/nv
	 8+hd8d9aO7yAuuFqk0Hpc7aTLPx14HXjeNBoqngiRz2gKe1Cx0+MCnwAixwbiGasxS
	 XyVLPd3HtniOS6bAEL/EsgozFPSD/7iAH+WhC5JHPbWManda/jVW3yy99P7/YAIBvT
	 /EdmMdDry8LCwiGSKv5NShqGWl97xxXOi+SI9Hr5RzSYeSwW3OeXCYi62l8h0PhlXZ
	 80Npt2RWNOFuJmrPY4TYkjI4lnkAHfihlRvEsLvglMRu9mZjXe6p2i66o4ybk/7uhx
	 GBqunjWhbQ0YA==
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
Subject: [PATCH v2 13/23] mm/vma: introduce vma_test[_any[_mask]](), and make inlining consistent
Date: Mon, 16 Mar 2026 13:08:02 +0000
Message-ID: <8aeaf08d153c3c3196855fdc9ddbacccf673ef82.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52DDD120010
X-Stat-Signature: tmxzxozocnw1d1m7fzae9o5sggacx5pp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773666572-732420
X-HE-Meta: U2FsdGVkX1/UWJHtLf/5Uf2wh3l0tc7D4cPJL2YnktRsBcWNqby7JeX59HruhM5/C+UGCuAW0/EM5Ayzv3jAvQK9ZikNgcx0VriWWmHFdQoYXC8l/nBajdzZ9vfc6DW1Xb37daGU5+IVxvrNEfCiVemKQ9DckfvWxgSswske/0RBhGkdMfVCuzk7ZJ6vczGuIARCvJkR03i7AO4JdK88cNhrAQQeFYs4kEUSQSsIb4hp7pJNZ/u6EeuSmAAgxQ8KzGoBWffqt8HdZOiNREmSv6NmZZVoS7f5q6beVhzC20VhAqUhslthNpkAsmnMmaIBf8Msy0/shSBdS6vLJKbaK+1wdmHyhcegBXFXIKNbdYqt+j5yTZKzm2nztrGdGpanINk4EczkAc+kQOVQbwa6pTvGGPpgx1ehEs/wkhLGFUWodYv5cO5MF26vQrKr+Q3DkC30pnsoKm3MJXKUpce5y58E/ko7WjzkWB/zsWHqE4PXZt53eiKvSEqq6qLHZcVeu6pwGSVxgqoaz4RZjf9DX9/HjNDJ0Fw4ZomPNBnObiv/p6D844AkoFxpBlGptZmmtajUhZ4+4cWNEh4UwU/IoP5mjWjwjpXu4avmV+TdShClKhwvA69sXsAmiTr6IVUMgIcmdEg/oe1dt2dOFsq5V9jnKBScZI4bnNNEe5jXwSHf7UDjV+pz2Tz1kicg+gulqnrpRNF5veBTr3JRxScqJ8l7KkI/pI+yGM3tlxf+DLPZJeSHggJ/LAJf/QSykzH1oGpmfMqqF3ID2H7ZQH+dsd7GG7p2rAMi7OAhyb4oSRFfF2QOXigenUnI9jU4BH6gvYIvxAX87vKQIOaa2SVr+43o9k1KI7jTclNwMQxx/8oys3TcnXebKkTbQxr+BJTqE5U0STfq4/2eSWl0K5AWTAe2j8w8TzYmWbCVzieZdb5tO3m7KyBmaUSsyiDlJ2+bpovGZFVk2RVzTS1HH4j
 44dACm2+
 7dfXZ9foduyiDLLP3kjdu+TGImMMM4ZOvw475uIQjCHWMDQ6+4qkZRfv9Off6DmwO/D9nH4+PaJUoFATfKEmtajjPk9Up/AqIwju+m6beNmqxQd9u4Vc7YCYOyGuuJwVYfCww3RQuH0brIE6BHoJmwMORD6VZEpuM6CH8lfOeHc6/iW87uYNScaspiTGfWWUCtUpkwJMOMFQs1CqrE+AiCeaKiGWLjJJ3hkLpHlXZuJUcf7Dq6HmFnAX+v5WM6WXkYrHwHNoN2KNMwVfpV3GwSv+4s3vNUCquwsSPg2ixGLkeVVcZdLD6LTY3NKcz5h+yACeZ+RwykquaQd7oA2U8yIVJFmHtcdThKSHD
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
index 63a25f97cd1c..4a229cc0a06b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1101,7 +1101,8 @@ static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
  * IMPORTANT: This does not overwrite bytes past the first system word. The
  * caller must account for this.
  */
-static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_overwrite_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
@@ -1114,7 +1115,8 @@ static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long va
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
index 7c22aeb736e6..ccf539b42e72 100644
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
 	*ACCESS_PRIVATE(flags, __vma_flags) = value;
 }
@@ -775,7 +776,8 @@ static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long va
  * IMPORTANT: This does not overwrite bytes past the first system word. The
  * caller must account for this.
  */
-static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_overwrite_word_once(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
 
@@ -783,7 +785,8 @@ static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned lo
 }
 
 /* Update the first system word of VMA flags setting bits, non-atomically. */
-static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_set_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
 
@@ -791,7 +794,8 @@ static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
 }
 
 /* Update the first system word of VMA flags clearing bits, non-atomically. */
-static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
+static __always_inline void vma_flags_clear_word(vma_flags_t *flags,
+		unsigned long value)
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
 
@@ -1001,23 +1005,32 @@ static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
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
@@ -1031,8 +1044,8 @@ static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 	return vma_flags_test(&desc->vma_flags, bit);
 }
 
-static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
-					    vma_flags_t flags)
+static __always_inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
+		vma_flags_t flags)
 {
 	return vma_flags_test_any_mask(&desc->vma_flags, flags);
 }
@@ -1040,7 +1053,7 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 #define vma_desc_test_any(desc, ...) \
 	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
+static __always_inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
 		vma_flags_t flags)
 {
 	return vma_flags_test_all_mask(&desc->vma_flags, flags);
@@ -1049,8 +1062,8 @@ static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
 #define vma_desc_test_all(desc, ...) \
 	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
-					   vma_flags_t flags)
+static __always_inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
+		vma_flags_t flags)
 {
 	vma_flags_set_mask(&desc->vma_flags, flags);
 }
@@ -1058,8 +1071,8 @@ static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
 #define vma_desc_set_flags(desc, ...) \
 	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
-					     vma_flags_t flags)
+static __always_inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
+		vma_flags_t flags)
 {
 	vma_flags_clear_mask(&desc->vma_flags, flags);
 }
@@ -1067,6 +1080,12 @@ static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
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


