Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB9C103E19F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DC76B0280; Wed, 18 Mar 2026 11:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3EE6B0282; Wed, 18 Mar 2026 11:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723276B0283; Wed, 18 Mar 2026 11:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 575C46B0280
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:50:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2355816085F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:48 +0000 (UTC)
X-FDA: 84559621776.08.A57D9C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9802140010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IU2OGKrp;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpr/64a3loyiC0S57Hg9JhlEbnlFbdvSJvew4MxJczw=;
	b=XkNoaU9O3PyWbOp9SW+SkKBtTS6eJ2i2vlVN2IOkcpmmd4Om5duJI9zTL/3aAvCEWzBj8W
	IC0mzdoBZbVx6nDjcTTOd7JVOd+35xxaVLASj5y4UCpwXlDFUP9jnIYLNHcqskqkPA6O5l
	NY42K8IHy5OWuZgr9Dup1lB4LKSz2cw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IU2OGKrp;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849046; a=rsa-sha256;
	cv=none;
	b=niTxK7HgwxoA/ZHXsnowzBEb8bxm4mzhpDfZZKMXwe3ODM2ITe+Hwrl42IBgDI+q0bMRH+
	4I/uBsUYoQIu0a7M+ZWdbJJBeek01jz5ih0JXPrxqDeg7PMDE5RZTlBzjzrNDIA725JOBi
	GJqFCCDG+pwI4IVStEaryy9d3tB1IsY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C4456013E;
	Wed, 18 Mar 2026 15:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2433EC19421;
	Wed, 18 Mar 2026 15:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849045;
	bh=NUcYO8sRiJXczuLfZ/k9Sxo/9SW/SjvpmCKwjwqD0qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IU2OGKrp5WnjkvaT0XX9nFzCAkDTe+oQNwQaS2KDuuzt7hHTA3wP3XTVRB/Umkdjy
	 Lc7ULv7Coel1AZkPJ8Cvmi099u5/6F/UeljrIwwF9FNAJWyyGhYhG4C68fdR2TK93Y
	 qN52E95g8GDFzx4qNzv+pp3zd9kAsdTLjR4BNMgYZmoLvHEsWkOpgXAzkudSxMlM25
	 raeQJxcbfyfTUj2m1TaI44ErZT0TBD/ZwxNEs/KVws2n34EoDhKOucRvPr3edRo0F0
	 hhBoG3tuJduaVI8HzgBSs9yv+zSHbxdS//ES8UZKcR4H6LkLHOvEAB4K7Iq2q9bscL
	 FXqrJg9PuhzRw==
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
Subject: [PATCH v3 02/23] tools/testing/vma: add unit tests flag empty, diff_pair, and[_mask]
Date: Wed, 18 Mar 2026 15:50:13 +0000
Message-ID: <038076638f6e828fa286cd5d19653506f56da8b4.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B9802140010
X-Stat-Signature: ipp5zyinnjxjw589q6ii7q96p8wugyof
X-Rspam-User: 
X-HE-Tag: 1773849046-895507
X-HE-Meta: U2FsdGVkX18uCJBUkKoLDl4ryTfIfUJwSqBNLg6qnCWA7Vg2ti7xAH7imLrrgNCz71W+YKL3UrfmyD4eTTO3FJqBBueRDp5chTgTfi3Irogi9+Ch72p/ZZhZ0jVwT5jnNP8HPywC3P/82grh203YUjHz3ZuLLOXkMlqXTEKe4m0li8baRCmNDQlpb7bjUXGDSiu4UJe8jY2lg3lC23OkZkbKT3JpyrpXnu8fvKbExWyRgyboL6jTKgfgL9/ihuBjEqk+QT3oDA+2g6I6zhGvsDV/wt9Zgm5jGHRQ6v7qOZ7YQKOyyiiA0dkAqn3ZthIXghJXr8BYOKjJQHfx5P07rNZ16fRetBSoHqIYBUFR1eljsdQLvHHnrd6WKFa+W7lyUnx4IWaYzLsisMA2qgus4PsWyGQ1VVGl146UtmMZ3WxyuGINht/A7LnmJvUXs2QlDpXrpIgra/NqYOtnTqNToW0vqzzmBZhO//T5ABVriEetWukRSsT3B9y2zV0J40LE1Z4mapbzd2PCFQOTrrrRZAZBeOfhBWVQNorUcnNUfgofZ7kBY41V7Qcy+p4ARJpHaJBvFq1UJnvMoJ/6UAnhQJBfY51ZOsK1NFIDgfnI7JD2lWH+3n8AlKw/SXKwCJ2OSlLJP5L/CStRfY4lmNFHwO/ElHNCRNv2+O+mWcd4br9H1HOGEZIW0+B7nRQdwNwRNyrvEfBhtSO6ALh0/SV8DUxDXFFIksbofsNamm1YlO4adiut+QiSo0OgVbjFnAII9Xk9Sw1brIhxUZArGWx9yOG58v/E52O18/SAQPFid+4KUsiUKXIK3AKNzEXH2bOwokl48wskWwaoMXbXf0imWgr8P1cMC5q53nRqORKkgJRJ5gJTSIhZKUQxJ8bgjKxrKJZ/oFvnSj5p+BQhKIX1yuPPBafCX1i7cr/+fiwOszGqFcPcMxdaFL5iZLdis58FQUq8I0UbYkxnmSJnVtp
 HQvqFRNp
 81kvuIicE2Cf5a6+X1c3iRjzBlkMvAOiT8whJuGgh2qSQsdrYLMZU8dt6ERzjCc55nH+JHXmJKi4DPrw=
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
vma_flags_same_mask() and vma_flags_same() for testing only.  If/when
these are required in kernel code, they can be moved over.

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


