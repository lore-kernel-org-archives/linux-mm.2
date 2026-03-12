Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E731106ACDD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E6D6B00AB; Thu, 12 Mar 2026 15:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC2C6B00AC; Thu, 12 Mar 2026 15:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDEA6B00AD; Thu, 12 Mar 2026 15:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD416B00AB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:29:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 010CB13AB0A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:29:08 +0000 (UTC)
X-FDA: 84538399218.04.4E0460A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5037FA000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:29:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D5HD7ub6;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McqqJ/O8xeq2UYW4/r1rFqCQDgZ0JT5zmWWDDok3uPA=;
	b=tWJt++v5maMMv8SjU0Vbho+jojWj6aIiZ7nNIMepVQQtbwVKlAR6S21qwmmQz1lIXBQHZo
	TgLRgd4RpQ9PzG93JBRfXGXiANd6x65ggVTWLwVgt8ac4XviAojIj0nOtf1uRlwz6Spbr1
	FVlSxlhtRKKnVsmlAK6TgDJhRk1FI2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343747; a=rsa-sha256;
	cv=none;
	b=7iX7N66UFGrJNTw6YErRaC9+bVpiyOaBF/xKSysTsMnE6Rmyd/yfiFX+VvHuC3kEO9UsuN
	HAHbD2AWpJ5BrP8n3EqGdZc7nJ98DKMRtfSDbG0pjHLhaMtU9olWxpOgjxvLIBNMs9gore
	bQOFKiMAi5lrRGfRAr6BJCKsHMcQeqI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D5HD7ub6;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FB6D60142;
	Thu, 12 Mar 2026 19:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1CFC4CEF7;
	Thu, 12 Mar 2026 19:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343746;
	bh=YOpLJ11dYkodZx+8r67n8RhJ76dQINyNi6epYf/ZdHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5HD7ub66roaJWE7nrlmZAdflnSN0hO7otfgMZKtfYptdRiQTxOped1BoFkMJPpjl
	 mH9m12adCkTI8dW3Uw2bSQccqFmWiGxOgZgwkl8VEI3kLYpji0j6otmhnt2X8pJBkS
	 d9n2kEACyQQ233Akhzuf1EUppbZ76a/Fh6nI/O3LY0UyrGQfiYI/qFTHHZzhUlZ0Wc
	 RH11N4B7/2JfpXNL3XfCBwtHe1XgaZATYAGzrYiPQoeKPR1+AKl6IpUrkktXCzQFV2
	 xZs80hRlOi6SdjYJHSHauWWQ+yIS/dw25//+hVMfrNvAegcqoCSuk8G1c2FCRi4X5A
	 9x6bga13XCQVw==
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
Subject: [PATCH 02/20] tools/testing/vma: add unit tests flag empty, diff_pair, and[_mask]
Date: Thu, 12 Mar 2026 19:28:57 +0000
Message-ID: <ae25ef9cd48e20553babaad3868da1cf74f16af1.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hobwx83i14qymt8kj1hg7bk1s15z6gm3
X-Rspam-User: 
X-Rspamd-Queue-Id: 5037FA000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1773343747-675167
X-HE-Meta: U2FsdGVkX19yz8/MnbVwDYz4d66pbf4e4nRemJFsJo2fhIhOqjNgsrg0kQRWYp96McsK2/AQoIG7P0LGBGBfzeGHD6eHr6U3+vNnze45n+WnM6Tgyt4L7mYg77f7X806Bb6FYFpRQbJ+/25E/VOHIzsYKTjctfxie39RTBXd0zKZckpyPBxYqbYbePnB5NtYlE5gdvF8KscYPRctkcX3NTkISelQi31b6dindg5CPLqUbJMan0nxIJUYuGtpPTa75owJWN/3sZEvCDnSXqLlPTYCI1yq8OyOiImG498+glWhuMN8l9G83RYiR/hICODU/nuzQxaZEkrN6sPdkw/enfMArLcLLeM7x1i7vh2yXf1+ZAoc2iE2TqHN8Qb2GSLWT3Oy1A/rkebruLFE4EPPhB4JJOtJQ+w2MRuBoeLWeftnnrDW6+8ICLaevRcBaCXA4AmXdFxqHWZdDbu24oSRbdFT88QoyBcAy/bXE9CPdjKgOZG3mWNghDYI8Kf7B4bKME7/yUPb12XOX/xctOkwpTRbdI+BM9+QgCdQGc2DhswynKKSJrcKPAIgfgR9AfAxoUl1SMHdejdIqBEQulKp+mFB8ERihUQYB+IpxZ6DomXs0p+pQo4Swyd2LK06HKVL03R9Xw1PmNpOjahts4NwLIfvuc3aF0SE/sk98SCstwKD3UwrNoiACda9/wbbv4AVlzYxkKukOkQrYC2yQd7b87QYz4qOqDcfRhVkufB4kCwGKp2TCV/n0CoB3rnu9Bsdbp/poGtnPEYKl9W8cX4auiFrSPJlIKtFo9tLoJxfteFht0qwOe2TjKHxrHugvW6WKtkU4bVmuCxTEx3bu1WiSsk+jPxndGY8klVEzW/YSP85htEGpBp9hu/QpE6ME+HH7dr5O0yoangzmATfaFeP8Sz+LbPwbVdN0FtgwyN+CBae4uNF4L45aIbaQ7wgZByJqGgABmTZc0tghL3hrUw
 u/4/7BUd
 PY7B+aJFGlWsGJundiyuoRZRNdpS0j7fOoowg88LyRcmkYuiFA3y1Nl8KMNx6kmjQHVVAYFzrC6yswZKIewsHS/5WC1fowkuFG8i3soYbVDVaPz8Ld7dIbkjV5MiVgMORwIPCLeqSR3wzE9MvCjbctOEa97Hq+hkQF9eXt0Fxy3kq60ybmJ9Xi9zCpkKOquseST2NZoAAxd2u6EAdBSn5Q1ebx12e7tW9Tnjx1tXDbCQvj1IyvoNEwYJ7QlvWCa7MhuxxREDMN0Djs2PSMjpi47gD6tJ50LEmcUAlVEEcGp6HTv+fnLVcXQCyNZrPdjyACRkrD2n22QNrTEbawZrjfEtdOvm6N/IoGI9y
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
index 833ff4d7f799..ce056e790817 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -118,3 +118,15 @@ static __always_inline vma_flags_t __mk_vma_flags(size_t count,
 			vma_flags_set_flag(&flags, bits[i]);
 	return flags;
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

