Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA0D103E197
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241E56B029C; Wed, 18 Mar 2026 11:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2199D6B029E; Wed, 18 Mar 2026 11:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108906B029F; Wed, 18 Mar 2026 11:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED2756B029C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 139F95B6F6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:28 +0000 (UTC)
X-FDA: 84559623456.12.B5F4D6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 628A880003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=opdVWCuu;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDQNe7B8T8GoWlhRML6I3VAVyznuzOHtBDabsxQSGW0=;
	b=69gCv+UbDCRHhewZ3wDVSb5XBUlVEGr8weYpaHarGZblqm2Jr97xHV3hK3W147Ebvovzil
	lUojs4SPc/7pm2MgmfYqdbff+RgcGJgj6pXIR67Mu1t2+ajpyNvmc0fUnYGUElI+x6C/kN
	Sqs94N4+UzmIhNqu4yy3lSZSPE5yrtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849086; a=rsa-sha256;
	cv=none;
	b=MUbv5qGKktdLsF+09Dnf5adI9uWz7UvgsI92g9GFiZWIHkeY55pbjEX7r+K+KbmDeV3xw4
	RyIB7n6+2XC8bqWYG+MChDFrp8x+PFnXwuS/+JcpsBWqjpvxGqGiZ+sJezYtNfL9hrS83Z
	EU0aj5S0mAGFa21zJw/MaOo3Aa/6+ko=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=opdVWCuu;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B04626057A;
	Wed, 18 Mar 2026 15:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1115C2BC87;
	Wed, 18 Mar 2026 15:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849085;
	bh=DKchaSx9IYFfEJDgBJsz+nw/dVX3HzjbTrBNkXejuMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opdVWCuu0dBW3ReAuXwII4bhfLTvACRV/CB1iFnyg37NE8PTPtHpmHIdDM/7QJWNU
	 tsxLq7Rmm+IxRtGGvfViDg/ybQHWjL5b8Ii9K9ft2pqhil6w0tG73WvkWOCfvlADw6
	 IrGXuLvwkZV6c29emNWpKe8MIszwMWy7SoBTmOD+X7PDEAXWeY8E3K98hlPGSzaFmG
	 juLRmDvq9uOnt8vnnIps6nKmsA4GfmKNKSB7KKoKNleqGl91+KwmOYP99mC26D3KIe
	 z90d9+IO06xMzN+d8iTU9CU5VVPPdtZUz6ezBKKhdq6o+aJzsaXRy7WfAP1nWraFVK
	 3E8J+cJJHxOIw==
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
Subject: [PATCH v3 16/23] tools/testing/vma: test vma_flags_count,vma[_flags]_test_single_mask
Date: Wed, 18 Mar 2026 15:50:27 +0000
Message-ID: <3ed8fb69ba554dd3c765a74fd66991e05cf87509.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 628A880003
X-Stat-Signature: 5unghzzzsgz7kthdk7ptmo5pq5dwfd5j
X-Rspam-User: 
X-HE-Tag: 1773849086-167398
X-HE-Meta: U2FsdGVkX18LKeMG3QopLCE18/AMhe+l7bf4V9JrxX5oiXAvK1XELxansP2iVP5k5BihtVNV6ZG+N9Qwy1jpkU/AbOcaGSm8+L3dg2gx8WpL37MpIBkASCnFtLHxsgfva88dUzFqoMKPx4uI2iJ1C55ZXuz5f5fFOE42HdHH2KjlUWlPRv8ZXVSTBYMp5iPEUZzTuJDZp2qctUlJji+mxKt5125uwuEuJM+jME7bqOrqOB3U3ImJ4htTuI4tyuUBdoOSaGP5ueBujqvuf0oBGxNlCBE0lKLV9oZLspPEdazobaeVglGkF4AmJUB6ZLNiX3pW3crPkkcJ1z3T/rVTEkvWMY+Lo+dzydUsPpzP31MR5B007wqwxMZXI7YxOrU8r/mut0WMbICL5KNXuqkRViZln2oCIZSt+4ZWD4jJOzI5OUp+ysSkjYpWipfnnDbAsBzp+c6bFVVSt7vdJsSZOrYdydV313ObKMpkBI7xUCQHrZ0KGYxKWoq75E8XTAVTwHnabdeQ1zlkOB6LmhqwtQ0L3ytqhPpR+Uve8IEVucnK5Hbx1gSYYIOQuoolh/nfwxju22z51JIap2lWwxCU0UENcChro/gZAA4MN3AC8059PK3NQIjDqfw65bn6KWWgghwfCXN6NiFe5Io+wj5uXAavTKrCsQdX4mtOrtEk0o17DiGbZr9iPN+n6W3g0aTwopcAJIsJ0wltWVfQ+zkjHGPKFdm2HjJlqTME4dKTsvDwczNz6Geq7zOIIGGMYREKwtvOcjxFKH86s56viUjsycs5P32bCTaLOrK9Dm0YsVhiEgA7QL+XMEazBBrzSuHm8nssTqqXmC4kcAsHYQsBH8DEVp+VKDRn5HRLMO5q2Nd24+d9KD4UHnnF9PHDbuab2XWrml1G4aC6njeOi4JewUywxIG9yNGGacYkAMqp+FLQMF5rO5SZny+jtL4pTg32nkNjIWGdYqBX6EEnEDI
 qAXrZ8mp
 XNLJ492XDnKUDsZyg+cfzqyH8jLyu1kJgZI23w1tE/P6kh/NiBQ79OHExBU/pEdSPb/hQ+k6d0+CMCvFf5goYZ8wxaFtU5ziSYwen/HP9dERXpmQystdyl73B9CiL9DoI45AN2LVe0iZIMDB4X3OT4O/Mr4MR4IY265nOJf6V/ih+V5VdtXNgfV+vpcLdnHvImp8Rcxa1630B+hziSJ9ywSiQCx6yJK8y/A9hfFUjbtS1kVILItlxB8Y4xwtG2a3gCdwYpmBfexo2/sV2k19LNfUsw2PH3uFo3ZWAMCfabfrAca+koPsJPAEtsYDCZM0Y5kVaVITUIWRJzhJ/6Uepq5y5OSp8e3V18zh3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the VMA tests to assert that vma_flags_count() behaves as expected,
as well as vma_flags_test_single_mask() and vma_test_single_mask().

For the test functions we can simply update the existing vma_test(), et
al.  test to also test the single_mask variants.

We also add some explicit testing of an empty VMA flag to this test to
ensure this is handled properly.

In order to test vma_flags_count() we simply take an existing set of flags
and gradually remove flags ensuring the count remains as expected
throughout.

We also update the vma[_flags]_test_all() tests to make clear the
semantics that we expect vma[_flags]_test_all(..., EMPTY_VMA_FLAGS) to
return true, as trivially, all flags of none are always set in VMA flags.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 63 ++++++++++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 1395d55a1e02..c73c3a565f1d 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -174,10 +174,10 @@ static bool test_vma_flags_word(void)
 /* Ensure that vma_flags_test() and friends works correctly. */
 static bool test_vma_flags_test(void)
 {
-	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
-					       VMA_EXEC_BIT
+	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					 VMA_EXEC_BIT
 #if NUM_VMA_FLAG_BITS > 64
-					       , 64, 65
+					 , 64, 65
 #endif
 		);
 	struct vm_area_desc desc = {
@@ -187,14 +187,18 @@ static bool test_vma_flags_test(void)
 		.flags = flags,
 	};
 
-#define do_test(_flag)					\
-	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
-	ASSERT_TRUE(vma_test(&vma, _flag));		\
+#define do_test(_flag)							    \
+	ASSERT_TRUE(vma_flags_test(&flags, _flag));			    \
+	ASSERT_TRUE(vma_flags_test_single_mask(&flags, mk_vma_flags(_flag))); \
+	ASSERT_TRUE(vma_test(&vma, _flag));				    \
+	ASSERT_TRUE(vma_test_single_mask(&vma, mk_vma_flags(_flag)));	    \
 	ASSERT_TRUE(vma_desc_test(&desc, _flag))
 
-#define do_test_false(_flag)				\
-	ASSERT_FALSE(vma_flags_test(&flags, _flag));	\
-	ASSERT_FALSE(vma_test(&vma, _flag));		\
+#define do_test_false(_flag)						     \
+	ASSERT_FALSE(vma_flags_test(&flags, _flag));			     \
+	ASSERT_FALSE(vma_flags_test_single_mask(&flags, mk_vma_flags(_flag))); \
+	ASSERT_FALSE(vma_test(&vma, _flag));				     \
+	ASSERT_FALSE(vma_test_single_mask(&vma, mk_vma_flags(_flag)));	     \
 	ASSERT_FALSE(vma_desc_test(&desc, _flag))
 
 	do_test(VMA_READ_BIT);
@@ -212,6 +216,15 @@ static bool test_vma_flags_test(void)
 #undef do_test
 #undef do_test_false
 
+	/* We define the _single_mask() variants to return false if empty. */
+	ASSERT_FALSE(vma_flags_test_single_mask(&flags, EMPTY_VMA_FLAGS));
+	ASSERT_FALSE(vma_test_single_mask(&vma, EMPTY_VMA_FLAGS));
+	/* Even when both flags and tested flag mask are empty! */
+	flags = EMPTY_VMA_FLAGS;
+	vma.flags = EMPTY_VMA_FLAGS;
+	ASSERT_FALSE(vma_flags_test_single_mask(&flags, EMPTY_VMA_FLAGS));
+	ASSERT_FALSE(vma_test_single_mask(&vma, EMPTY_VMA_FLAGS));
+
 	return true;
 }
 
@@ -309,6 +322,10 @@ static bool test_vma_flags_test_any(void)
 	do_test(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64, 65);
 #endif
 
+	/* Testing all flags against none trivially succeeds. */
+	ASSERT_TRUE(vma_flags_test_all_mask(&flags, EMPTY_VMA_FLAGS));
+	ASSERT_TRUE(vma_test_all_mask(&vma, EMPTY_VMA_FLAGS));
+
 #undef do_test
 #undef do_test_all_true
 #undef do_test_all_false
@@ -592,6 +609,33 @@ static bool test_append_vma_flags(void)
 	return true;
 }
 
+/* Assert that vma_flags_count() behaves as expected. */
+static bool test_vma_flags_count(void)
+{
+	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					 VMA_EXEC_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					 , 64, 65
+#endif
+		);
+
+#if NUM_VMA_FLAG_BITS > 64
+	ASSERT_EQ(vma_flags_count(&flags), 5);
+	vma_flags_clear(&flags, 64);
+	ASSERT_EQ(vma_flags_count(&flags), 4);
+	vma_flags_clear(&flags, 65);
+#endif
+	ASSERT_EQ(vma_flags_count(&flags), 3);
+	vma_flags_clear(&flags, VMA_EXEC_BIT);
+	ASSERT_EQ(vma_flags_count(&flags), 2);
+	vma_flags_clear(&flags, VMA_WRITE_BIT);
+	ASSERT_EQ(vma_flags_count(&flags), 1);
+	vma_flags_clear(&flags, VMA_READ_BIT);
+	ASSERT_EQ(vma_flags_count(&flags), 0);
+
+	return true;
+}
+
 static void run_vma_tests(int *num_tests, int *num_fail)
 {
 	TEST(copy_vma);
@@ -607,4 +651,5 @@ static void run_vma_tests(int *num_tests, int *num_fail)
 	TEST(vma_flags_diff);
 	TEST(vma_flags_and);
 	TEST(append_vma_flags);
+	TEST(vma_flags_count);
 }
-- 
2.53.0


