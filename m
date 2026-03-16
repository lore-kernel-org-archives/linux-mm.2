Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D47CF506CF
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859706B025C; Mon, 16 Mar 2026 09:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834C26B025E; Mon, 16 Mar 2026 09:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D106B025F; Mon, 16 Mar 2026 09:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBB66B025C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 096621B710D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:02 +0000 (UTC)
X-FDA: 84551956524.08.3E66D8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4F1C240007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dpyiPZiJ;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezlq9TJabZW7e2+qy+FPdDMufE1Fk+ZuKqs8A1tMVB8=;
	b=8LDYahZEFGA923ej9wfnPjv9SxnrMxJ5/pJO6E+sQo5+WLLJ06hayz9G8TVkgDUzRdMTHV
	anzxVUl0svyubm3DBSGRLSRXhUX00Ihbne0fqBCXjHOvz4Le72zPM7ckuxh/96DfrOH9t8
	oy1kairctEg4ZMPj/EV6oi7yVGZ0Wio=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dpyiPZiJ;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666540; a=rsa-sha256;
	cv=none;
	b=XCVLyZkA7P9yN5zi1dSbmWcNYbSkSGo5DD8hkpU46d/vDyMJ/m7OpfSyr4Yf02fB6tItOo
	ozuJNNo0QuFLzvNouz4nZ7YUM1JBoI5SwcqEQnOV/JXsrxwngx3txLKaxIeuwJ9jsP6WTt
	+dDp32ZOUezMf4gTW8IySqrET8MmmRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DD7444580;
	Mon, 16 Mar 2026 13:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820EAC2BCB1;
	Mon, 16 Mar 2026 13:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666539;
	bh=ge1tPGRj8e4pymgBfLqAhUO+vEuqkOcfcegXmeBBeLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpyiPZiJf1Db69/A0vbskfWhDsG8Ef7iBxBMZoI/QRAmU/tKUWMV4J5yTtgjAynjl
	 ll+8Q/WNXV/N4/ZVgwBtEgDIyPKAgFLwPVaFHTdiDRFJ3CfOd9/s5mB3XV8ZfGoVdz
	 XIeDMixf0KAVMM3XofWy+ipMjGvkrkCNlmWBTTeSuFRDXzuc+2U3ib1D8JLAcjIdm9
	 qqwA8/gngGKccLSZPq/rHFAvP62A2scjJGlA0xv08MNtOfos1OllojTU34NbhryWlP
	 mwA9lMqDpqJ3XmpGlDjDcj0Sh+H3HhC9GWq51ZFV+IgoHGM2+yOdGw9Wuq3QQXl9Md
	 IKVjxP4AldtRA==
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
Subject: [PATCH v2 02/23] tools/testing/vma: add unit tests flag empty, diff_pair, and[_mask]
Date: Mon, 16 Mar 2026 13:07:51 +0000
Message-ID: <1d789fcc7dba9f93ec844aa87a48b13451dba211.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9u48kqpzo66jiq5y6i6w3hgio9sk5jgk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F1C240007
X-HE-Tag: 1773666540-558603
X-HE-Meta: U2FsdGVkX1/Q3PuqPgUCvDSyGX1zRQxXoNzT1NtTvmKT7TRepxdTdURQM5GWAEYKIlxhcNW9IUqGpyGEQ2cgfEWmMqWDiuSiNCL7gmDsOMGMAE8MgdASNPtrj8RI0xEIoIi0QAGvbbkZb+uizEiHSUzNPZdJMFX+KoryLwApCfAb5FUkJ8DE8ZQcEaRDLnKjmh9QVRs1Vx+4vqH6UcL9cxPPszi8byWcYM6wm7Q/afvbdwxaTpwfdyiUyMCYr2xcRTRb4iiLCyquyoLstrN09WGwnLgSIPELJwL4loTZNpjkwdUynnK8hPAfZtW75CSI72eR/c2P4WXeBj6A2D6kL2FvYUnMOdWd5HySKcIWk+R25zlt+kGAR9rN0GzOLYdjLlfLE3M9vMC9o1n+SifBizCHodui4fFlq/6mAfBJsy69M99Q963HYEptUEkbeiQctC+mPx6T6HgoAHAKfkcEpAqR9+ozVHFcYi4VtX5t6z2/hnRfp9DIgBwWbdKA8reirpitWgRKruA7nqsw1PBdiKR/tjIiV4WovgApUvAYFF7SnV4P7egOcpPpOSW3xNA0ccqV1ekpejaAH3Mv7vFYRjwu65s55nPXD39sGmA1Ns+bhJVq6YHt443NZ1oKTkGIvVxZbDA+eS6sMxhekkNjZ+PfSzzEqjtN6CGuaCKnAiuUtPqXrZ8yWryrvuI4r/k/mvOq3MQhELERWAJEzq1+MwcwvUOawLasFnqsxVdsIfXcfWeY/+BKIVELlvDpQpwNag0jsi+tTpbAgQ1D8KIB3ln/YHJmBrjIC0UoZOa/iAyTODIKbk5ORkU3AUBHDRDPe6p7yuT/HRtSq43wqec9Mwx/Ma4szss3qNmT5nVMBWoQ145u9Ax5D5hBQtJc+GQQS373AMMJ6u3WQNXMhdhwLCGEh/LxiCSxOamc6BqzLV/7teTlIy+F85xmLjlbWvixAqxoZJ4wDPK6RL/np3s
 4kVntJfC
 +L2JiRSO3s3nDvIeIix5fLBdrcvI4oQt5V/7Imd0HL14IIM4vAiuRYdurPdzQisXJy91DpF8lr+LosqUF21vZuQatLEyA9e9DnelKPbHgCUszqpMiCPVR5q3XgYvp92KmM0z+sUM51S3JuADV0jug2gbCTMxpkrP8aoIx7mKBKa0lU+ZkkraPOH9t9g5Baux5qYZOhAGk17kpMBpDaOJ6OPEGyZNQ0W5Yarrj2cGF6DiRqb8S565s2kaRXxr8KQmnDOsv7qhy+SaSq0rThdxNsVyQ7yfmdG6aApih7UYpY/EYOIRX6OFV4DBR43CwYg3MVi9enXDZ/UTvLmIAizwyajTUF8b3Gz7pxfxi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add VMA unit tests to assert that:

* vma_flags_empty()
* vma_flags_diff_pair()
* vma_flags_and_mask()
* vma_flags_and()

All function as expected.

In additional to the added tests, in order to make testing easier, add
vma_flags_same_mask() and vma_flags_same() for testing only. If/when these
are required in kernel code, they can be moved over.

Also add ASSERT_FLAGS_[NOT_]SAME[_MASK](), ASSERT_FLAGS_[NON]EMPTY() test
helpers to make asserting flag state easier and more convenient.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/include/custom.h |  12 +++
 tools/testing/vma/shared.h         |  18 ++++
 tools/testing/vma/tests/vma.c      | 137 +++++++++++++++++++++++++++++
 3 files changed, 167 insertions(+)

diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 6c62a38a2f6f..578045caf5ca 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -120,3 +120,15 @@ static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 {
 	return PAGE_SIZE;
 }
+
+/* Place here until needed in the kernel code. */
+static __always_inline bool vma_flags_same_mask(vma_flags_t *flags,
+						vma_flags_t flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other.__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+#define vma_flags_same(flags, ...) \
+	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
index 6c64211cfa22..e2e5d6ef6bdd 100644
--- a/tools/testing/vma/shared.h
+++ b/tools/testing/vma/shared.h
@@ -35,6 +35,24 @@
 #define ASSERT_EQ(_val1, _val2) ASSERT_TRUE((_val1) == (_val2))
 #define ASSERT_NE(_val1, _val2) ASSERT_TRUE((_val1) != (_val2))
 
+#define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) \
+	ASSERT_TRUE(vma_flags_same_mask((_flags), (_flags_other)))
+
+#define ASSERT_FLAGS_NOT_SAME_MASK(_flags, _flags_other) \
+	ASSERT_FALSE(vma_flags_same_mask((_flags), (_flags_other)))
+
+#define ASSERT_FLAGS_SAME(_flags, ...) \
+	ASSERT_TRUE(vma_flags_same(_flags, __VA_ARGS__))
+
+#define ASSERT_FLAGS_NOT_SAME(_flags, ...) \
+	ASSERT_FALSE(vma_flags_same(_flags, __VA_ARGS__))
+
+#define ASSERT_FLAGS_EMPTY(_flags) \
+	ASSERT_TRUE(vma_flags_empty(_flags))
+
+#define ASSERT_FLAGS_NONEMPTY(_flags) \
+	ASSERT_FALSE(vma_flags_empty(_flags))
+
 #define IS_SET(_val, _flags) ((_val & _flags) == _flags)
 
 extern bool fail_prealloc;
diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index f6edd44f4e9e..4a7b11a8a285 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -363,6 +363,140 @@ static bool test_vma_flags_clear(void)
 	return true;
 }
 
+/* Ensure that vma_flags_empty() works correctly. */
+static bool test_vma_flags_empty(void)
+{
+	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					 VMA_EXEC_BIT, 64, 65);
+
+	ASSERT_FLAGS_NONEMPTY(&flags);
+	vma_flags_clear(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	ASSERT_FLAGS_NONEMPTY(&flags);
+	vma_flags_clear(&flags, 64, 65);
+	ASSERT_FLAGS_EMPTY(&flags);
+#else
+	ASSERT_FLAGS_EMPTY(&flags);
+#endif
+
+	return true;
+}
+
+/* Ensure that vma_flags_diff_pair() works correctly. */
+static bool test_vma_flags_diff(void)
+{
+	vma_flags_t flags1 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					  VMA_EXEC_BIT, 64, 65);
+	vma_flags_t flags2 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					  VMA_EXEC_BIT, VMA_MAYWRITE_BIT,
+					  VMA_MAYEXEC_BIT, 64, 65, 66, 67);
+	vma_flags_t diff = vma_flags_diff_pair(&flags1, &flags2);
+
+#if NUM_VMA_FLAG_BITS > 64
+	ASSERT_FLAGS_SAME(&diff, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT, 66, 67);
+#else
+	ASSERT_FLAGS_SAME(&diff, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT);
+#endif
+	/* Should be the same even if re-ordered. */
+	diff = vma_flags_diff_pair(&flags2, &flags1);
+#if NUM_VMA_FLAG_BITS > 64
+	ASSERT_FLAGS_SAME(&diff, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT, 66, 67);
+#else
+	ASSERT_FLAGS_SAME(&diff, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT);
+#endif
+
+	/* Should be no difference when applied against themselves. */
+	diff = vma_flags_diff_pair(&flags1, &flags1);
+	ASSERT_FLAGS_EMPTY(&diff);
+	diff = vma_flags_diff_pair(&flags2, &flags2);
+	ASSERT_FLAGS_EMPTY(&diff);
+
+	/* One set of flags against an empty one should equal the original. */
+	flags2 = EMPTY_VMA_FLAGS;
+	diff = vma_flags_diff_pair(&flags1, &flags2);
+	ASSERT_FLAGS_SAME_MASK(&diff, flags1);
+
+	/* A subset should work too. */
+	flags2 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT);
+	diff = vma_flags_diff_pair(&flags1, &flags2);
+#if NUM_VMA_FLAG_BITS > 64
+	ASSERT_FLAGS_SAME(&diff, VMA_EXEC_BIT, 64, 65);
+#else
+	ASSERT_FLAGS_SAME(&diff, VMA_EXEC_BIT);
+#endif
+
+	return true;
+}
+
+/* Ensure that vma_flags_and() and friends work correctly. */
+static bool test_vma_flags_and(void)
+{
+	vma_flags_t flags1 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					  VMA_EXEC_BIT, 64, 65);
+	vma_flags_t flags2 = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					  VMA_EXEC_BIT, VMA_MAYWRITE_BIT,
+					  VMA_MAYEXEC_BIT, 64, 65, 66, 67);
+	vma_flags_t flags3 = mk_vma_flags(VMA_IO_BIT, VMA_MAYBE_GUARD_BIT,
+					  68, 69);
+	vma_flags_t and = vma_flags_and_mask(&flags1, flags2);
+
+#if NUM_VMA_FLAG_BITS > 64
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT,
+			  64, 65);
+#else
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+#endif
+
+	and = vma_flags_and_mask(&flags1, flags1);
+	ASSERT_FLAGS_SAME_MASK(&and, flags1);
+
+	and = vma_flags_and_mask(&flags2, flags2);
+	ASSERT_FLAGS_SAME_MASK(&and, flags2);
+
+	and = vma_flags_and_mask(&flags1, flags3);
+	ASSERT_FLAGS_EMPTY(&and);
+	and = vma_flags_and_mask(&flags2, flags3);
+	ASSERT_FLAGS_EMPTY(&and);
+
+	and = vma_flags_and(&flags1, VMA_READ_BIT);
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT);
+
+	and = vma_flags_and(&flags1, VMA_READ_BIT, VMA_WRITE_BIT);
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT);
+
+	and = vma_flags_and(&flags1, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+
+#if NUM_VMA_FLAG_BITS > 64
+	and = vma_flags_and(&flags1, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT,
+			    64);
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64);
+
+	and = vma_flags_and(&flags1, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT,
+			    64, 65);
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64,
+			  65);
+#endif
+
+	/* And against some missing values. */
+
+	and = vma_flags_and(&flags1, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT,
+			    VMA_IO_BIT);
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+
+	and = vma_flags_and(&flags1, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT,
+			    VMA_IO_BIT, VMA_RAND_READ_BIT);
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+
+#if NUM_VMA_FLAG_BITS > 64
+	and = vma_flags_and(&flags1, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT,
+			    VMA_IO_BIT, VMA_RAND_READ_BIT, 69);
+	ASSERT_FLAGS_SAME(&and, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+#endif
+
+	return true;
+}
+
 static void run_vma_tests(int *num_tests, int *num_fail)
 {
 	TEST(copy_vma);
@@ -372,4 +506,7 @@ static void run_vma_tests(int *num_tests, int *num_fail)
 	TEST(vma_flags_test);
 	TEST(vma_flags_test_any);
 	TEST(vma_flags_clear);
+	TEST(vma_flags_empty);
+	TEST(vma_flags_diff);
+	TEST(vma_flags_and);
 }
-- 
2.53.0


