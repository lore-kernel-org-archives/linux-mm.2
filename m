Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE61C103E19D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637C76B027E; Wed, 18 Mar 2026 11:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F536B0280; Wed, 18 Mar 2026 11:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FEC46B0281; Wed, 18 Mar 2026 11:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA306B027E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:50:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD96A1D992
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:45 +0000 (UTC)
X-FDA: 84559621650.01.2B5158F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 318641A0014
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fmWRhrM5;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVTZQ+yeUqKhkhONzpkTYOn7TNXwc4UEXHZxWuz/yyg=;
	b=RZgdk0gQM967yK6eNIulDd7MVcp5gMaTqoIXxQtTEK+Xi/GiIQO5DuAmITmzkbpKoU1LWO
	lSi7G57jDEMyRSmh7y8/rqct32v5H0RzkDiUVw15937MBWmgIDwU/ktf6iUjGkaAyNyOJa
	6AF7K7Lj2VN3uclyrS4n01bxuHb/xWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849044; a=rsa-sha256;
	cv=none;
	b=DA09Vv4w6IJu7pXzV3U9pleqXuCx3XON2BrJy8opLyeJ1kI6/TJ4vymSfI8pUyqwOS3xq4
	oSGESctNOHDrohloY+rIV2xIqUdz+nNF7UrOflXVYyCnrOgrnm5tK+MqHncB1efNq6V2iY
	Vm5DGEL3rBAW8+AG0Djcqjy/IINkKPI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fmWRhrM5;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B66060123;
	Wed, 18 Mar 2026 15:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52453C19421;
	Wed, 18 Mar 2026 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849042;
	bh=XNaJylMB4ToYbiyO76kSgASv2eZo/bh0bkFERIO4NSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmWRhrM5nH+kjm/rkpDWtdAzEUZpv8wThhQZJsq318tUoOS8qjV0VdqDX9AEPIHeC
	 iKsGU4vrLmkv5KESEJl52p468hqffcju858fQAQeWXpMwzJFkpMY/AQSfokagglkpd
	 T0ADc/b1mpIwCW0JE2u/wcDs1YGe1Nb2Rf7MJYstv5dGvc0DK1oLWcE1lZwZuAjY+Z
	 GdGGR2UQRTzDPpuHCuaDO/fcykWeNNeB/xjRv/8SC+vU6uEuubAosWdTnRhpmCliE/
	 Yo3qqkYf12v8TONAkstM+2DQ7EVbRlPFvU/FHUcVMxNVZApBMXf5p9T5w9ypwUU8o8
	 kabGMlOpHeJiA==
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
Subject: [PATCH v3 01/23] mm/vma: add vma_flags_empty(), vma_flags_and(), vma_flags_diff_pair()
Date: Wed, 18 Mar 2026 15:50:12 +0000
Message-ID: <ca9062b3d08ae38bc149e98eb146c44c8a113b7d.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 318641A0014
X-Stat-Signature: 5cbad6m96zthqqkrhhrj9ng86xprdg8s
X-Rspam-User: 
X-HE-Tag: 1773849044-802319
X-HE-Meta: U2FsdGVkX18BQ08aXsCOEeBFyLgEfBVw8Wj7L1G8vvRqo/X7yPm4nRujwA7Bj5w5nj+m1IXBZ5pYDvTRgWEbfwnm9Ip6ASaI+AFnpacJW6Ac+i7ewSyONUM2LY5duXJBqqXG3Dx9gxbf+dBnZRywOOxgVxMvV3w33Fmn0kor3/pD5dX0IEzcyj9ar3+bu4WpRtg8kAkaCpE/0vh9Lkd49+MvDbTqZpnrraYzOJ6v1cLAVnnyHWq1LvH3n2BaxN4k4TAJZ4AaIaNjYTBBRruu/AcoqcKXN3wvepP0JLTRRQDBojXXbnzBmezWdOONJUTXBf3ul5fqEAiFcF2lvLtygbX9squcl5gRFfyUEb15J182bv7YYUMKd9b3b8IyvcneyjzhEQMh/WRijfJT9qp26GMVL4oR7P2WdLm5M8Gj+yWI032HYGzZPdOPcbvsbZcVy8yomAET9d5jTnw3Csye1fKzqf+mIWX5vrQ6sJAW+BqAk/TiJN6TeweUstM84uq2ZyPh+1OnTEsizAtETwvYtQYT2my7PAQ6Tl8agNfefQ/b91FXhwHvG0LsRVpc8YqejHDz20bI+XjHxWHOYaUL/gZmBaDTE2kYktZMzNDPBltOfzRakaQV/Yv/vaSpBb5Pepscrk00j1+vfzhBr4LMa9g32Nril/WpAspHv5zIeJOCKIx+6KYXs2HGMcbr/Cxh74owg0qXLI2VCDkAxA/AfetlzRPJgAXdj56qBvLOM3M7QIIOnFUDLTYH85uwFcLVeNJOB7S0gtBgYkUEDXSQGDRyDli6mQCZwn6zaOB0bqNIbG6LirZx1Tx8WrmbF7G0Sf9RehDAhJ7VQODSuU/8LjBYG1Pat87G1gF92OXDZQpiIukvHbFBXQDtHMqOU4vJIL7idSjOPor2ykBn8Cci3PxCKNk7VXFru0GKbg/Z1qclETdTWzgIOznZ4r+pVl51Go1ToXS7z02GFQ2WyMT
 WyHELhzK
 gauLFapwbh48bJ7nj4kpNC4LQ3Rfx+cvwVuJefvjQcOP8drhgRlJJAHIhpYGuNW33W8rw6YIC3ouIagHAeYHJ57p6uHg4QFp6tLVk63P5JKqnpTWm8fjPy5a7zzzzyX4HH/n7Xr2jp99fEY5V50EPoE3ZaKIKp3s4k00u4SyPKfonaPx3MBw2k8ZhyU6dIsTrkdUe09ZiLefi/UIt1o1kEYLPC9JEJymEsiEeEBZW+5Y1mxf3m+oHsOoYUrwJOlqqwaW/d5BT2Nv6hHYQdQ9jqDBOjhY3V+E0sOLOnS+a9BSlVvy//U3pLCAhW7SfEF1ifmu/nWlNNrVAF67kLaxXWXnC/PAfCYK9cA3M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Firstly, add the ability to determine if VMA flags are empty, that is no
flags are set in a vma_flags_t value.

Next, add the ability to obtain the equivalent of the bitwise and of two
vma_flags_t values, via vma_flags_and().

Next, add the ability to obtain the difference between two sets of VMA
flags, that is the equivalent to the exclusive bitwise OR of the two sets
of flags, via vma_flags_diff_pair().

vma_flags_xxx_mask() typically operates on a pointer to a vma_flags_t
value, which is assumed to be an lvalue of some kind (such as a field in a
struct or a stack variable) and an rvalue of some kind (typically a
constant set of VMA flags obtained e.g.  via mk_vma_flags() or
equivalent).

However vma_flags_diff_pair() is intended to operate on two lvalues, so
use the _pair() suffix to make this clear.

Finally, update VMA userland tests to add these helpers.

We also port bitmap_xor() and __bitmap_xor() to the tools/ headers and
source to allow the tests to work with vma_flags_diff_pair().

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 60 ++++++++++++++++++++++++++++-----
 include/linux/mm_types.h        |  8 +++++
 tools/include/linux/bitmap.h    | 13 +++++++
 tools/lib/bitmap.c              | 10 ++++++
 tools/testing/vma/include/dup.h | 36 +++++++++++++++++++-
 5 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 70747b53c7da..6d2c4bd2c61d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1053,6 +1053,19 @@ static __always_inline vma_flags_t __mk_vma_flags(size_t count,
 	return flags;
 }

+/*
+ * Helper macro which bitwise-or combines the specified input flags into a
+ * vma_flags_t bitmap value. E.g.:
+ *
+ * vma_flags_t flags = mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,
+ *              VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+ *
+ * The compiler cleverly optimises away all of the work and this ends up being
+ * equivalent to aggregating the values manually.
+ */
+#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
+					 (const vma_flag_t []){__VA_ARGS__})
+
 /*
  * Test whether a specific VMA flag is set, e.g.:
  *
@@ -1067,17 +1080,30 @@ static __always_inline bool vma_flags_test(const vma_flags_t *flags,
 }

 /*
- * Helper macro which bitwise-or combines the specified input flags into a
- * vma_flags_t bitmap value. E.g.:
- *
- * vma_flags_t flags = mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,
- * 		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+ * Obtain a set of VMA flags which contain the overlapping flags contained
+ * within flags and to_and.
+ */
+static __always_inline vma_flags_t vma_flags_and_mask(const vma_flags_t *flags,
+						      vma_flags_t to_and)
+{
+	vma_flags_t dst;
+	unsigned long *bitmap_dst = dst.__vma_flags;
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_to_and = to_and.__vma_flags;
+
+	bitmap_and(bitmap_dst, bitmap, bitmap_to_and, NUM_VMA_FLAG_BITS);
+	return dst;
+}
+
+/*
+ * Obtain a set of VMA flags which contains the specified overlapping flags,
+ * e.g.:
  *
- * The compiler cleverly optimises away all of the work and this ends up being
- * equivalent to aggregating the values manually.
+ * vma_flags_t read_flags = vma_flags_and(&flags, VMA_READ_BIT,
+ *                                        VMA_MAY_READ_BIT);
  */
-#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
-					 (const vma_flag_t []){__VA_ARGS__})
+#define vma_flags_and(flags, ...)				\
+	vma_flags_and_mask(flags, mk_vma_flags(__VA_ARGS__))

 /*  Test each of to_test flags in flags, non-atomically. */
 static __always_inline bool vma_flags_test_any_mask(const vma_flags_t *flags,
@@ -1151,6 +1177,22 @@ static __always_inline void vma_flags_clear_mask(vma_flags_t *flags,
 #define vma_flags_clear(flags, ...) \
 	vma_flags_clear_mask(flags, mk_vma_flags(__VA_ARGS__))

+/*
+ * Obtain a VMA flags value containing those flags that are present in flags or
+ * flags_other but not in both.
+ */
+static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
+		const vma_flags_t *flags_other)
+{
+	vma_flags_t dst;
+	const unsigned long *bitmap_other = flags_other->__vma_flags;
+	const unsigned long *bitmap = flags->__vma_flags;
+	unsigned long *bitmap_dst = dst.__vma_flags;
+
+	bitmap_xor(bitmap_dst, bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+	return dst;
+}
+
 /*
  * Helper to test that ALL specified flags are set in a VMA.
  *
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3944b51ebac6..5584a0c7bcea 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -870,6 +870,14 @@ typedef struct {

 #define EMPTY_VMA_FLAGS ((vma_flags_t){ })

+/* Are no flags set in the specified VMA flags? */
+static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return bitmap_empty(bitmap, NUM_VMA_FLAG_BITS);
+}
+
 /*
  * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
  * manipulate mutable fields which will cause those fields to be updated in the
diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
index 250883090a5d..845eda759f67 100644
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -28,6 +28,8 @@ bool __bitmap_subset(const unsigned long *bitmap1,
 		     const unsigned long *bitmap2, unsigned int nbits);
 bool __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
 		    const unsigned long *bitmap2, unsigned int nbits);
+void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
+		  const unsigned long *bitmap2, unsigned int nbits);

 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
 #define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
@@ -209,4 +211,15 @@ static inline void bitmap_clear(unsigned long *map, unsigned int start,
 	else
 		__bitmap_clear(map, start, nbits);
 }
+
+static __always_inline
+void bitmap_xor(unsigned long *dst, const unsigned long *src1,
+		const unsigned long *src2, unsigned int nbits)
+{
+	if (small_const_nbits(nbits))
+		*dst = *src1 ^ *src2;
+	else
+		__bitmap_xor(dst, src1, src2, nbits);
+}
+
 #endif /* _TOOLS_LINUX_BITMAP_H */
diff --git a/tools/lib/bitmap.c b/tools/lib/bitmap.c
index aa83d22c45e3..fedc9070f0e4 100644
--- a/tools/lib/bitmap.c
+++ b/tools/lib/bitmap.c
@@ -169,3 +169,13 @@ bool __bitmap_subset(const unsigned long *bitmap1,
 			return false;
 	return true;
 }
+
+void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
+				const unsigned long *bitmap2, unsigned int bits)
+{
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
+
+	for (k = 0; k < nr; k++)
+		dst[k] = bitmap1[k] ^ bitmap2[k];
+}
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 8865ffe046d8..8091a5caaeb8 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -422,6 +422,13 @@ struct vma_iterator {
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)

+static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return bitmap_empty(bitmap, NUM_VMA_FLAG_BITS);
+}
+
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
@@ -855,6 +862,21 @@ static __always_inline bool vma_flags_test(const vma_flags_t *flags,
 	return test_bit((__force int)bit, bitmap);
 }

+static __always_inline vma_flags_t vma_flags_and_mask(const vma_flags_t *flags,
+						      vma_flags_t to_and)
+{
+	vma_flags_t dst;
+	unsigned long *bitmap_dst = dst.__vma_flags;
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_to_and = to_and.__vma_flags;
+
+	bitmap_and(bitmap_dst, bitmap, bitmap_to_and, NUM_VMA_FLAG_BITS);
+	return dst;
+}
+
+#define vma_flags_and(flags, ...)		\
+	vma_flags_and_mask(flags, mk_vma_flags(__VA_ARGS__))
+
 static __always_inline bool vma_flags_test_any_mask(const vma_flags_t *flags,
 		vma_flags_t to_test)
 {
@@ -901,8 +923,20 @@ static __always_inline void vma_flags_clear_mask(vma_flags_t *flags, vma_flags_t
 #define vma_flags_clear(flags, ...) \
 	vma_flags_clear_mask(flags, mk_vma_flags(__VA_ARGS__))

+static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
+		const vma_flags_t *flags_other)
+{
+	vma_flags_t dst;
+	const unsigned long *bitmap_other = flags_other->__vma_flags;
+	const unsigned long *bitmap = flags->__vma_flags;
+	unsigned long *bitmap_dst = dst.__vma_flags;
+
+	bitmap_xor(bitmap_dst, bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+	return dst;
+}
+
 static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
-					   vma_flags_t flags)
+				     vma_flags_t flags)
 {
 	return vma_flags_test_all_mask(&vma->flags, flags);
 }
--
2.53.0

