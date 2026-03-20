Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B001099B41
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668B96B0197; Fri, 20 Mar 2026 15:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2F76B0198; Fri, 20 Mar 2026 15:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CFB6B0199; Fri, 20 Mar 2026 15:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 322066B0197
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E61E9B8579
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:20 +0000 (UTC)
X-FDA: 84567455280.01.7A83734
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3D4F94000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HsnajhtQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WflG39A2ouZ0xljmsR/bB5wW/UudjNQ1hu6ijwlE4H0=;
	b=8CsUXFFMSxnPltz2r1sSUOWT9/epDIyT/EXMTk3QYbAfonq7B3CxvyQ+3VTAvlQKYN8Fg2
	8hv7p6REioPF9ALM1b78lJJWUPsMVWPBKxtkSKc+WBM/Kry7JDJHeCrCJERbFRpwlX9DrH
	eTuEXyG9Kk6skZIbxRfSp5xfFFo2G48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035559; a=rsa-sha256;
	cv=none;
	b=IUi5G5KoE8h+1643bAfE3/fO2h6yYfCi+9qxg9rfzsznexeY7NlHFbyTD8o7O3UsAm/v0S
	5tesuMF6TyZoveQFi1tIyuQshzMHOsKyXh+j9Pdcd2YvpJEJzgn8n8FcJVnBOxW9EfmtRN
	Z4Wcvxfg+4WvCNetTWJQiL9raDC9nDg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HsnajhtQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EA4B40459;
	Fri, 20 Mar 2026 19:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF04C19425;
	Fri, 20 Mar 2026 19:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035558;
	bh=5OA6L01HT6P2sb2CV4zMHF2SwBn+dEQzEmLD6KvnAPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsnajhtQpoaLV4aLokju+6Y91/55QViRTLAO4TcMOVNYsbVr9XkGG3VIcIZccy15p
	 DjXIXZY8RqYkvOYCY7iLUDBd4WrN0omATYlPx2IHTJCZgQ0bufuTg1rZr5dxm87ogg
	 nEsyoV3UcEMVpVXNEqjZ3TPmOr4t+ineY/5H9xj4VtiLiPOiMkTkE39m5vQRIOfna2
	 zFGKw2+DP1JGESm3SzLd6fyDiNPL7VTlHRbWR1UlrKkpgy4mx2z5nNzshpcMILHQrI
	 WuhVJbLznN62jaqZkoHH6RAxTl69XEWxY7a0xNZz8UqgrRxVyE5nnQCfAN9pnN9pYC
	 W1+DxXi01Eoig==
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
Subject: [PATCH v4 14/25] tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()
Date: Fri, 20 Mar 2026 19:38:31 +0000
Message-ID: <dea3e97c6c3dd86f1a3f1a0703241b03f6e3a33f.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3D4F94000B
X-Stat-Signature: met5hyeghaa5of66a3t4picjjydbtrxr
X-Rspam-User: 
X-HE-Tag: 1774035559-268815
X-HE-Meta: U2FsdGVkX18YRGZAeV/r0cpJ5BdhiXU8+gJE6RJL7URL2Q4zOScSxAXwg1r3pmQikKXi2FD0VI/VNRSk1geDg1HpSwXXrO7Y2NMTHX9dQi5EWH4HwYqFGm/fN+w/eO8OUxKrTXgkskmO23havycZ7ZzAL8KNlE99u/X+rKnMImgzEL2iWu3zQ0MunkXM5wOh0CmlZo7eVOvPStGMDXrecYzbGfdaZnCUEZkdCcMzFu8xoxfZWTKghTZa3mzZMB7qUaKy/a6lEqstLvP+ExuDu281NnM7ACRNW6imVg/K2aKsMZKP06kJNFuCJ6FLV+iWpF785WdOOb55PIdIjxbk3hgBJepuXyKLIBeI17/Vp2J+iFnGfKDT0RlmawZXLLCoCB1pyMHH6a14l6Qa9WV1P1zbFPmHdxsKjb8qb1xHOr6Yw+cUdinZAqXq8K6c7AD6WUYwW+5wcQC5NobU0YwoIDB5h8sNMQn6Zuhm4U+2QUAp3iPNH7zcY5f84zvVOONPCZreIpeIXRVAJvlJa/NLqXtIrJSTX98itKPKN6HI+yd9WnV70JBzA+lI5g5a4drZZyNFgj/BrHJ1G3oAv2x5dwSqPmcSq+sVuxxZeymrT3+rgLJRLwLh5iCim14RBIhPQtKtUcRFMZ7je8+MUBPJs54cMe7kNeIknK9fegN0Kpt4b7Clhg9wLNpxymiSM8aMkYSrjHuQQW/XJ3KWBFMbZXBDIeEa3vX/96zkZ3mHS5eTXn7UOQgLTWkIAHxPFCZ+HLwr2KdDCNfXtmN33YS8G+6R/ss3xP//xMic8BSyyI5Mmjj+u7/5PTsj8hki+hA1dIRKX634lMlkhbQ9/3i05J87/scWvIB+28qGnUq4TO+CTHYtYiLKu02lx3MRfweG5IY+1Gsg3OG/PuacUYyA+PRvb/sFdqR9362N70Tw1V8mPM8F/EvWnuWgZYHBoF2eG++nRNZNwF8wNT85+sQ
 ROWN4gR2
 KIMuOJfhQmKuoPwbqO6VSgP29D8uu6aBfJv/+rRXf4G/4dZa7S0nYswJsckqgwoAPPqevM2uNEy6xAeHE1zbGKPlpjVqdolpEO9oQoJ4Av0gBuHs9/Rt3S4szqCLlv8TIUK6XQ96NH5EyOP9Ihvm3CxGH6G5+uNKA20nzLbkBV4KADZ+hxhn+5fw6MLpqwqQ7gBAgc7zQtbp8JluVHSQ6akuOk1Xcj8i0GyfUdSI1el6UnDn1mxp+d/2NHRCDm7Ulpz1giu7z3LFS7VmaijoUSVAIB1klZDdGRv/Ctvx2wpBjZHksTcAQgTN5/ei61wPu21dA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the existing test logic to assert that vma_test(), vma_test_any()
and vma_test_any_mask() (implicitly tested via vma_test_any()) are
functioning correctly.

We already have tests for other variants like this, so it's simply a
matter of expanding those tests to also include tests for the VMA-specific
helpers.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 1fae25170ff7..1395d55a1e02 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -183,13 +183,18 @@ static bool test_vma_flags_test(void)
 	struct vm_area_desc desc = {
 		.vma_flags = flags,
 	};
+	struct vm_area_struct vma = {
+		.flags = flags,
+	};
 
 #define do_test(_flag)					\
 	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
+	ASSERT_TRUE(vma_test(&vma, _flag));		\
 	ASSERT_TRUE(vma_desc_test(&desc, _flag))
 
 #define do_test_false(_flag)				\
 	ASSERT_FALSE(vma_flags_test(&flags, _flag));	\
+	ASSERT_FALSE(vma_test(&vma, _flag));		\
 	ASSERT_FALSE(vma_desc_test(&desc, _flag))
 
 	do_test(VMA_READ_BIT);
@@ -219,15 +224,17 @@ static bool test_vma_flags_test_any(void)
 					       , 64, 65
 #endif
 		);
-	struct vm_area_struct vma;
-	struct vm_area_desc desc;
-
-	vma.flags = flags;
-	desc.vma_flags = flags;
+	struct vm_area_struct vma = {
+		.flags = flags,
+	};
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};
 
 #define do_test(...)						\
 	ASSERT_TRUE(vma_flags_test_any(&flags, __VA_ARGS__));	\
-	ASSERT_TRUE(vma_desc_test_any(&desc, __VA_ARGS__))
+	ASSERT_TRUE(vma_desc_test_any(&desc, __VA_ARGS__));	\
+	ASSERT_TRUE(vma_test_any(&vma, __VA_ARGS__));
 
 #define do_test_all_true(...)					\
 	ASSERT_TRUE(vma_flags_test_all(&flags, __VA_ARGS__));	\
-- 
2.53.0


