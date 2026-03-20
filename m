Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885491099B44
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4466B019A; Fri, 20 Mar 2026 15:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A858A6B019C; Fri, 20 Mar 2026 15:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973C36B019D; Fri, 20 Mar 2026 15:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 836C76B019A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 498AA8B4D6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:25 +0000 (UTC)
X-FDA: 84567455490.22.D228992
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7E87540007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TVAj20P4;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDQNe7B8T8GoWlhRML6I3VAVyznuzOHtBDabsxQSGW0=;
	b=A0oRWxLwxsdQL5hI5wkes8qK1oJaUQW5V312yxczIGxdBc6EjVHBtGj1b9szFrSBP/xxcp
	gs3eX5aV5pA9bSbrqzAFQn234rJIKDJnOlQwjfmSvjq4HAJRIMKy6/iYFBanzJ1Lf+hR/G
	UNptyL2O5qQV/TWI3dC31bHJh9g8UPw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TVAj20P4;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035563; a=rsa-sha256;
	cv=none;
	b=a72MlNsU5P5Pq//owbRG4NNyBVRPbDt8sMQEvwo4DvfIdlH2Bd+OFIIdin34UWa8JKuu05
	Q2te2BP+9M6PiCpgHFPWaItOlbdZ2hSByIfczFLHhUOnSsl4CpbNdqAMo0+NaulKk/IRe8
	M77wTRTYWcN55SFmxXfg7FUuFMWINvg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 981E14063B;
	Fri, 20 Mar 2026 19:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1005AC2BC87;
	Fri, 20 Mar 2026 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035562;
	bh=DKchaSx9IYFfEJDgBJsz+nw/dVX3HzjbTrBNkXejuMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVAj20P4XIPmxpbQnE0KPnJA4wgWfIUMCttbS+dyXWLHTuihR88wwJuiKiNdMclby
	 9kbgsfC1loRS/jZt2cWajKSSPvA5sG3fNu1fDVH2ahMssY7eao+i8sSVJAy4g4JQME
	 WLxCUFnOZ1DvoGuVmiA5RUwDb+Jfq1f4oSvEdBw6IU/DgCZ2QKqjuPleOku5jRi3E4
	 IZumXhulCNA0gHjWh4zzsxEL77T5Jfa0r6a14ZLD8QxMZhStBvw/ggqmcLtcXKF+BY
	 herSpfit0Li3xJgopabrV8mZjRy4qCKmwoV4OkIA6gv3Wuz6ePxKOm2Fnaz1cxig2E
	 Xs724S1ccNzpA==
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
Subject: [PATCH v4 16/25] tools/testing/vma: test vma_flags_count,vma[_flags]_test_single_mask
Date: Fri, 20 Mar 2026 19:38:33 +0000
Message-ID: <4af95d559cd2af0ba3388de1e1386b9f94c0e009.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jmcn57qnjdmjowkifjbsqsr8s3iy99f6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E87540007
X-HE-Tag: 1774035563-374597
X-HE-Meta: U2FsdGVkX1+JbnyTbEL/3/UH6tcoMkUkVODc4BNYRBx2ILhrE4nOUxU2DGKhqyaKV44Z00lDq42cxApGO38jQkZq1d8OlsZRIWAdRjRlR2zBWTyLb0c2LMaeG6gZ2ZYGjbajEh6jwpm4PcvRPm6qdprBa75GiNG+BFNm9EuzNf58cqfi0mAHq3/IICeNbjCESSwY5EVDcrRW6/BfU0TzoRwc72nRkeQNzUcIq6ZWggY4/QRLhFN/bfrqyo80xwdCPk0x2Q6OSGJZxHjqYrnSqzl9E7wyEROgvzaVi+jlAX1+f7RFx1/kF2YprjRQkxBgTRxwBpwraGn2wifj6W5ROZ3F+ANKuCI461EDEGF5G/flTZxzR5BYzt+iLo2ZXFHFDcIsYd/2N/Jqj5L1xex/cghyBrtYt1mH/6kZItQ72d62ZTJyqBiurhFU7NSnT9/Pcww32OcXXNCX+yMYQEvbPX9N9nd/ym3IuhPzvJggT6n+6dN3zTqIvxQTewN2oQGiZ/Xh/OWlnqVw9UiIP/zIjoe3gOq4fWUOtLfESYhbI5WbvEUZrQkgZCVubfae1dpTKpci7DbhZepv7wHqvcB6kPl6GzyB+7brB3ybN+T5uh99Q1sW+g0/BUNIg4FIlBppUpIFDaZTfPm0zQ8VrnJvkKkU0uSFN85mIlUrzkGf9qs0ujfObWyIC7qyv13/ztKMwWM4QgfKWXL3F5kx3/l5Czs2Tgx/TojTzIe243OMjFImgepN8A5OdqAC19B7BevNiXxI8rpytnZdm+dYetiHdrGr+y29qutx6JJBX9WOsFiaYncSdc7XdkqRJmRshiw3uowb52Sm7faWXfBRsQaXSjVvPH0INypDkbKJNoPxUfrJpRqDsaMCvEcZjcYfO5xAAjJRWXt6HmJJJmbgo7qLupHVJ7vdmp7sUT966UFeda325GnyUjTdUS3U7cOwKRBkNtENrz95WjNnf1SJUL9
 O+i2EGyJ
 3dIjayZlWXqZNkRhaDxSBp9TNlYzBHZR1xCNvvN3dWWWcM1EdKImSjJLB3On3ku1j8H/g6DZ9ym2yypR9VDcySczEPSa7/kJdCoXRUEFsBvjDb99aDcMD5iInevBuFQcmIBDtQ0e63Be7pEay1WoFPfhxG6031ooCTNfNprIbLqtNNv5UqR0dxBBU4m02By/5nCUvgzcRlvY8p0KFFM6Z7Qg0P7rDIMCukewDbUp7iO6/cKhu2rHXl7ngKuLX49gGstnxZHpHexqIfZGTzP7stUhmJWTPnv4sqbHnY7+QU+knsK1sj+FqE35wttuRh9IpzdoNSo+u66wWVMj0mDjsS2reO1VSlpcIj+xl
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


