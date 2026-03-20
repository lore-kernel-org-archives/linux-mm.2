Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FFBB1099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE226B013F; Fri, 20 Mar 2026 15:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C59D6B0141; Fri, 20 Mar 2026 15:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAFE6B0143; Fri, 20 Mar 2026 15:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8206B013F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:38:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 248B21A035A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:38:52 +0000 (UTC)
X-FDA: 84567454104.12.C2FF457
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CA1A4000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:38:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JLPa5D/8";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ukc9NHL97Rm8JNZRkaoYQL9WH+ox7Z+BrNTdzp7sEqk=;
	b=QaUZpWRdU+goXzzSMkYENQRMpkkzHLnaMFPEQSWC6KccMEdqJw870Zfi+3zebFfsRv6GQ2
	KDenBHNQrRI5sWZtYAdLeEmuSQbZNNnF9H1Gh9a7ulJ2jphPk4qTjxPdub5MYk6t7BnWz7
	pwFB1TRz5TlEn7RFN2Cx+3Jy+vbizhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035530; a=rsa-sha256;
	cv=none;
	b=dfFAYiiuFsQfgjmvysGZiY64vYfVKrSsP7bzSe8yDenLyT1RPGQbhGclazSKKBUH3fhhId
	JUbxXC22rm2qmySXstUY2UZicWcoiJgxnEM5seid2OzYLJ8qsOM2stsya/ERLwbxi4DW/G
	+j0/6k1ZjytIMdzJhi8H59MXu1NzukY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JLPa5D/8";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECF594451A;
	Fri, 20 Mar 2026 19:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64789C4CEF7;
	Fri, 20 Mar 2026 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035528;
	bh=ioQTkBV6m3Y37Bfrju6maslIwd8eJKDuKdyHXU3PF84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLPa5D/8a/lpeDSeloPdDrACck5k02GKPBWI7+D4njafMSn7rjrBTHddDGqU0MnPG
	 7bEotti4zoelK0VSxeeKJfCekl2UIeAawfpmNmr4tmnisptPH+pgmC58mj6lj29ju3
	 5vEUDsXS90jdc7fXQiWFL0fVMSSVGMBH3XGLb90DVUtxmEQ2KQMbW94wrwzm0u+uZa
	 2HeAepfK94bhZt204Wtqo+tRggWN25Z9xYV0W8aG2ItlTvvoa/iJ/9i+zROvJmBOVI
	 r1dexFW/PSOCktuwQlMPWgD7bJzUaz1ZBNE7K7or5LafaYN0Xb7sjaZMEJW8lFaG2g
	 vEAbJ0N97rIuQ==
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
Subject: [PATCH v4 01/25] mm/vma: add vma_flags_empty(), vma_flags_and(), vma_flags_diff_pair()
Date: Fri, 20 Mar 2026 19:38:18 +0000
Message-ID: <53ab55b7da91425775e42c03177498ad6de88ef4.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ujochc7t73jdrs54uaj9woepfgjqryf7
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CA1A4000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1774035530-186265
X-HE-Meta: U2FsdGVkX183oMat2v2aMfJFouhTFE8jM9Zxrkg+s3Lh9nFcWCjspdaf/j4caQgtDs8XgEb2i9NwVdl3cBuYxAolXPfitqcTyoDiv1piFCDCExG527Qt2IIZTC3HqstkGh5e2kEQAuFklaquXJ0eO2NZbq4yGRnI7uyIQB03UtWVhwgTaPXbVT+Sdm4EypOB6hWbK5ABpW4w0PKmyovbTOnfXOZaoG10hT+5H1p42M0wkpN0VI3I/fN30fnJb65Nqr1bIq151ZkDehU7/BJCeMIvnOBwOWr7JSLyvlvAHeS7FRqORVJpF1wWcYiWSuxImKqeWU8uZlgjpoMZW5JwWyJgIeJYM24YZBbnLZOjalMOVfUhoXhEV0Kyqi9x/k9Kq9+r4mHNS4sWqWDcJFQ1NE4GXV51U6LZO3cWYI8rB6eDk7Xm494kdM0GmzdFrqIDIeMsslxhgArkk5uhDADM+7aa0NT4ZM0SuD8fQOFIxLEKV0o+w4gCAFV+hGvJrVDpypkcX6GKIznr0XcgYMnyc4MmaI2kTol/wsYyI3Iw//5EFhC9d7LnyDLf1UdPw9AkccLIPVHGGFB94RkQ4lTRWOoRJEL3mYAMIm3f9cB0wws7FBI0VSGr6HgDeM1Oob0ThcMynOfadL0rnETqMGZi7wPGP8v1zQFxngUBgKzF35soWNzGCSa/Csj9Tn19HBTwkSfOY6BG3AT/1Vm0sNmgkrk6W1XeHRvjEW0FElWhMXIADFNk6O0xM9HykWmHoyKRfa9h0clbfz2zxolnxpOS5KOTNn2xtKkPCVd819LMkp5ISPmaN1KwEN50F9bfD/Sx5sCZkDn9qSqq6ZSGH5Ixzqcphq91lo4G/f7fqydTfLBC3ymYx65Ti6l5ZW54fHRM9ZukhR1P/h2QNmVQVs8lX3a2Zqlm0UDAfhuRA0nvrWvHZ0jeh0UrNsEDf6rwgcD3o1J1jNlvamxmYSB0Loq
 lZWBFqP4
 wMBS34jj6Yb7lzj0/yGcKRsN2h7vi29viB/kplKtd1UUW/C8v/aHgQhL/4ziD5PfqDno8vlaf88Mfj1IeaWVNyUjjqacS+W4z8EvjzAQWMU8fwsQekyfxMfYQYY5vII48gtMp+Zuon79sFTYdlPWm+reQtOh4jqCe2c4vehKiZ4i4/sjmBmUWif8ys910SDH7vBdXTr70uxb+d03VhJ5eK271nGVp1WeCmEFj82ux5Gt603epr1E9WiFRe95+i296GUPyfa/mH9AUVaZ0oj25k9EfBtHrlSB8YKzX70vXxdBbD+0y61hzBgf7rresvEzBKvD1kmwBhwR2CwTj7zauLhYXmZF2gry8Yph4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Firstly, add the ability to determine if VMA flags are empty, that is no
flags are set in a vma_flags_t value.

Next, add the ability to obtain the equivalent of the bitwise and of two
vma_flags_t values, via vma_flags_and_mask().

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


