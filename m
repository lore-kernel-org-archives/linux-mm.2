Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67748106ACE2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCA506B009B; Thu, 12 Mar 2026 15:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95A26B009D; Thu, 12 Mar 2026 15:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A949D6B009E; Thu, 12 Mar 2026 15:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 948D06B009B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:17:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59DDEC1ACB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:01 +0000 (UTC)
X-FDA: 84538368642.13.29CA695
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9643A1C000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cEiK7/n4";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXNtwefo3DI5PZqVhmiWEXF190WSl3hBxhRdARXxK9g=;
	b=66NOa5V8RttAzMhA0GRVL4fh5Maz3FeKc3o5En05qBm9OB8uc6ExXdWFwnfqx6X4ukkJ8W
	Ggs1KN8uWcIXduRSUpfq1+jJu2V3BoxG4O+6OtzrRR4qwumjQxxV0pA32JNXP2TiDcEgS3
	ablmwXzOi59E/1+0F341hU3RoBCiVzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343019; a=rsa-sha256;
	cv=none;
	b=qm3ufWsTOZphpphp+KHc4QXc5nLXhPY8aL3hHpXpbibGGUnY5Kc4VehPTlVbMc0GMdahUJ
	Ky4DQkyCO4uEmWBdUOjszR4zV1um7vkl0tHRjEucUxxDoO0kFgOM3/Zu9TToHvdE3sAekb
	4kwXRdmH1ouPrDhFaGAJub1I3wLMEuA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cEiK7/n4";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3BDB44517;
	Thu, 12 Mar 2026 19:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126E0C2BC9E;
	Thu, 12 Mar 2026 19:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343018;
	bh=cMZvtYTbVi8gGI62iqsWZ4caZrMQ/fPLlqyhjNcRyx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEiK7/n40R+U6XNkiSalA/AXJ/bEgYclxYDzCqR94yWMygwmC794VCL0NxoNYMt3J
	 RHgWYcxQkKel2D7y5Qt7KDsDDMbbnor8tS00TxPxTu7yixFOVnFjv/PAKh+RDo3tpd
	 yGc6lmIpIhzsiJVtCyAB02NBMWdKtc6jRMZms3t37fq7iqSAm8xvmcKPPar1qbfOd9
	 EvzQJ8XXrWFAYsPwnjWKyAaJA6DLfoLru6ENVdQxEMDyebpaZ7Ji0O9VLo8T3kTXXo
	 yolKRFYDkMz5uAmNg47v7Mny0fse4ZkcVEuNAaoLI86leo+dqL+SZpfMRoIRQSV5f/
	 wEw5+9/hlVO1A==
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
Subject: [PATCH 10/20] mm/vma: introduce vma_flags_same[_mask/_pair]()
Date: Thu, 12 Mar 2026 19:16:08 +0000
Message-ID: <64129ea327a7280732291e3481f1fd138aaf4caa.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9643A1C000A
X-Stat-Signature: iuysbmczb4qdqyqwbfufqbyttodzg1q1
X-Rspam-User: 
X-HE-Tag: 1773343019-459393
X-HE-Meta: U2FsdGVkX18ZkwDUNoWM/nb3BnY78wAwOHk13aDP/qfp5EtovFzGf8FYmL5dhn9wWdsGv9fptD9fvA6/CQWo7BpBh93mXfigf5f2z0pJULz0fMiiqAUcXjjItNwsMsDZttA4UVqh1YcA3C3CF6+7OaJmT9GB2SibtyLZW+4saLq7SZBpjcSAdZc0uQ1Stz16rXtC6X/TJcZRFhRIP2lef/gVHcboWknCkE7mU1F3qVXu1vwSC7KNpT/0FNt56FPyWO3vkI/FEkFURqVuL1lE4OBhobyvI7Jxxc4ABCJIgFRqKu++gLedMNpgp7y1S4j8GHLZZwEQBJDGRKYNyOb7pL8YGcnF7WTxPFphEpzmiZc8aQBu132WLxOfhlgxAoVD1cHxm3WLS6RkhZM2zEojlGu3y+PNqlhIlxeal4Xb2Z8J/j4P1+8yhwaSSMn6izj6nUscwppYr0YlaSsjNRSX39YuAzt7OUq5/FMgHv//Ibxvjn8xt1uKfeDjS1hnSrmG+yqDG5Utje2Wgoe8r0YvCGFsnNXDJfKP2TwpeNehtduAHAPXL9Gg9xFTkNIdbYE9oVTTyzqhHb/SISobrlqxzxTAzlHk3HIdCGnEWrf7rY8rJBwUONzFQtjNEqHwJTrqtIMt6AFGsvMdd6Ss2I9lEkuK1lLbg7qo3eqXt5j0t1MNtApjw2Qrp1WOaz20dXKdm7eupA60s+dTmgCWkqbveZ7fbJxkSAHU7DR7EvKyqky2Bisq7NhBsiP51bzo2Hdb06shJnaYAb7w/N0RzRku8f2eQL8vQC+FUlyGAGlrCxWeWmzfCjlVBVbCswS4BM3fWc031Mzqr/ZTLYnn1R08d0VbNpaBEYelCaLxHs4D0Lp2J6lJ7QpdyNCovilpaZjg5vQu0jRqRWO1qA2tq+dggGtTid0pXF8j3CAHWbzTp2VGUZrk2J/0/ciXNw0vqOwEWuc8+iauC54XCFlZVft
 YRoo+7NC
 UlL+NZzTWQmf/lK39XUyd4SoTn4QDysEQHAjzMxFr8ip3LWBSivHcNPpIGZapHzALGSXj7xYb4Cvpe9FGhvrwP8jzeRY/TR/37xQtS+2eLYqA22wAE5JQJkKvyVxjzuv64ZTFgvZQSAA2B4XwWLea74RlVOsmNV9cp+E/s0tf5aK/UIRXR4T+/1uHeRHfFcqAWYpukUMzd0+JH5hWkZQFY4YZifO6UU4iK99PjoTImltzZHDzboPv/THRFdAHgOAEFCOxnIa+r3yTW6fNY9uIdhp4kRJHADPHyrl9RNGds58GszmpbPZOikWaSkDLjxJz5+FHCT52s22oTIVXTnXIbrSIgQdpW1RIyzOU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helpers to determine if two sets of VMA flags are precisely the same,
that is - that every flag set one is set in another, and neither contain
any flags not set in the other.

We also introduce vma_flags_same_pair() for cases where we want to compare
two sets of VMA flags which are both non-const values.

Also update the VMA tests to reflect the change, we already implicitly test
that this functions correctly having used it for testing purposes
previously.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h                 | 28 ++++++++++++++++++++++++++++
 tools/testing/vma/include/custom.h | 12 ------------
 tools/testing/vma/include/dup.h    | 21 +++++++++++++++++++++
 3 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2c16c744d49d..33d0c2af2c75 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1209,6 +1209,34 @@ static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
 	return dst;
 }
 
+/* Determine if flags and flags_other have precisely the same flags set. */
+static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
+						const vma_flags_t *flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other->__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+/* Determine if flags and flags_other have precisely the same flags set.  */
+static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
+						vma_flags_t flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other.__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Helper macro to determine if only the specific flags are set, e.g.:
+ *
+ * if (vma_flags_same(&flags, VMA_WRITE_BIT) { ... }
+ */
+#define vma_flags_same(flags, ...) \
+	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
+
 /*
  * Helper to test that ALL specified flags are set in a VMA.
  *
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 433b3396c281..92fe156ed7d6 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -99,17 +99,5 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 	if (reset_refcnt)
 		refcount_set(&vma->vm_refcnt, 0);
 }
-
-/* Place here until needed in the kernel code. */
-static __always_inline bool vma_flags_same_mask(vma_flags_t *flags,
-						vma_flags_t flags_other)
-{
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other.__vma_flags;
-
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
-}
-#define vma_flags_same(flags, ...) \
-	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
 #define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
 				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index c3be8a2381e1..fa2df96f9dee 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -951,6 +951,27 @@ static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
 	return dst;
 }
 
+static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
+						const vma_flags_t *flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other->__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
+						vma_flags_t flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other.__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+#define vma_flags_same(flags, ...) \
+	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
+
 static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
 				     vma_flags_t flags)
 {
-- 
2.53.0


