Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73AB4F506D0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9EDA6B027E; Mon, 16 Mar 2026 09:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72C56B0280; Mon, 16 Mar 2026 09:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4BAD6B0281; Mon, 16 Mar 2026 09:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B27166B027E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7529C1C0A7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:42 +0000 (UTC)
X-FDA: 84551958204.15.4059A23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B8B1E20010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TJG/Go8A";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96FoYXx5DdJNjnJjdiL9x4rpswYHhSc9RCyN6+I8ZG8=;
	b=myGr1alm0l5MddXUP1q+eOF0QwyxVCbpE7JFF8vrMcNGEoebp9fRTbavgr1Luj6uSH33ma
	cIhDhJe/KQFpH5ICWeFBU5j1WtjPvVkyI9a3xxeZ0VfWbF7oUhSOM5rRm6eRrzQH9epjXt
	hXcn/ExBWEidqGv+Fy1yjL+GYylbIQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666580; a=rsa-sha256;
	cv=none;
	b=Vk+kPKFMMrmCmF0nKeEkLb834utmyr5QWT+c4jkbHwDRoyIpLF13fcNb2r2FkcbuBUK2I9
	9HGzFGAWmgTRLgUPI7dRgm1tcC4Lu7C6WatdNyGfAh5mvoaOOY4uCZ8F/p0uRnWXQnTeIZ
	m8tRh8rQKc/5RU2RP1ODawksqPpQqLU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TJG/Go8A";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B9356111A;
	Mon, 16 Mar 2026 13:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4350FC19424;
	Mon, 16 Mar 2026 13:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666579;
	bh=dLJAyLW52YxQ0AN/NeuZQy3GzYiIO3sQ/ClSljBmA2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJG/Go8A1cY8XS5/cAwBFroFXuBNyK85BM7BXdepftLaaH0hgiTtnWt94hTv5NzQk
	 mi9JB6jBKDTXIVd1hpifEwkrt4trzZ01AHPVwLAJZGZsYdYo/sYYijNdcV3kU2ycvb
	 xS3rsbNrAw2IJTDx0eyKMX4KxE17kIEKHD1bLFjVP8xJBSvxRirbu4wU6Ek2CSMghZ
	 IBkA/mfuSfU/btp4YszcI4RKptelvWUc4mAENue7y7fw0OdVRAlzoR+tvmrvu6llBa
	 hjs0IVHsjxs08YA4JEMwdB9gsTNAPwrbsSRB3yRw4iEgqXIW8+N4/BZ0XXiWAtToyu
	 vrXuiockp9v1A==
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
Subject: [PATCH v2 16/23] tools/testing/vma: test vma_flags_count,vma[_flags]_test_single_mask
Date: Mon, 16 Mar 2026 13:08:05 +0000
Message-ID: <140b9b77da1ef463f969cbeb2b5fb25627301cd6.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zr3xbmrso5howownjp3r8grepbw7gtcj
X-Rspam-User: 
X-Rspamd-Queue-Id: B8B1E20010
X-Rspamd-Server: rspam12
X-HE-Tag: 1773666580-859907
X-HE-Meta: U2FsdGVkX19LJo0cGE81PZUd+Pzd7pxD+38uyPmmEWTuy+tJMvyfTJ6YHMt0S4bXjFjEUcPfCFC1CWOHdldZkw3rh+XKBg1izdh5Yn9FR3gpGH0H9tqw5ytol97YT0RjD627u3keONMrEga3RZPUeEBM3DtEpMLeVx7txiGHkhRfA+4b6rqqsX2/i0mTGTtyXohtR34UlRAwu8xgGwK1XrLFzbWMPvEgWEDx3BODYv842a0u/R9NoTRjag2pJnz0njV3CreBy+VuWgd9EgRzAIxTCawoRGASbQJc15M0kauu43gVSs+Y26sZXtOev+FsNoQs5ltWOVIBmPJEWXIb1hq4V6Zx7VRq+7nmZE53b5pDR/QT8pGAlUQIoPsu5DRM3yhONdINeFcHP2I677kuRKIDU9Wfer8fKBUoniDXrBCy3auVOT34BI5rXVroh2r054YyJ9172LXihvjUdmJiaJjL29EKRhPwzTjJHetpsHaYAOgL8Go926zkrbhA9x72b/8M+2al1tqFXFzrxDCCZiWle0Zbe/ShHxodfzLhUH2HNfvOgcD18vbKSpi9UXB2boUp5tq8NBzHTujKssPaD8A77VFqLimqenL4GESZpDp73Q1UHOo1B3K+fKp46Mg/SA+i/9S2SdMx9HY37NIyYFvC42v3YfXIcYeONbFZa5Kc0xWWHc5gZlFV9g5RO759pr5gWbz8lLiGQ+IwjPMnnKIK5VLnAjd5wAKdKC18axZ6ObLFXzRvQD0fu+iauI75XX6EVZOETgH/f7PdHb3eAluQdET5eYicbBH0rWfam4lZmi55Fx7CNbt6AM3V8XuY5wcCxYvbRDy+3Pdnn0YbaWy/ia+s5JBg8g6jMeKDaOBzoqG1ntW7x3Hn2PvWWa3JhUohvZlwSz4uqpqyhFQLjTKuZT6Fiu+7C8YmThakNRzD0nXrG6/09+ynfjcOdmIr94F9yt5vKuVlfmdWp3f
 Atri2+BW
 oVsNPq2yzGhSPvrpL3xx3b/2Ev59O2HssIB5o5klzVtsGBmvwSux/SeADqZhkuC6RYO9e8de/EMTwqHhY555vl2bwq741fZWjLDGhtd8odTSZjQquUGpE1OJ5qyqZynOM+9e5xtE9xueo74ix1kOtaPm2YQ7S4MND6+O4MH/3xZDfPZzctNcsPT7Fx7dtPhdC+GBy2cJ+zR7fUaCah/JSQCiYj27c4ZQzusQoC4Mpg4dLCNwxPBdv1qveTodDtZ2uy0Whxki3eDiT7tcB55nvCbUClHuwShMkqXwetqQ28k0Ny7nx8TYlc2K3GrgFQ53/gjbZRFtPGlLQHRBIlmJY2dPPEAzv+A4ikLgT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the VMA tests to assert that vma_flags_count() behaves as expected,
as well as vma_flags_test_single_mask() and vma_test_single_mask().

For the test functions we can simply update the existing vma_test(), et
al. test to also test the single_mask variants.

We also add some explicit testing of an empty VMA flag to this test to
ensure this is handled properly.

In order to test vma_flags_count() we simply take an existing set of flags
and gradually remove flags ensuring the count remains as expected
throughout.

We also update the vma[_flags]_test_all() tests to make clear the semantics
that we expect vma[_flags]_test_all(..., EMPTY_VMA_FLAGS) to return true,
as trivially, all flags of none are always set in VMA flags.

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


