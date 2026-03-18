Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9C7103E197
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7566B0298; Wed, 18 Mar 2026 11:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE206B029A; Wed, 18 Mar 2026 11:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D52C6B029B; Wed, 18 Mar 2026 11:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1166B0298
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D8B31407FE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:23 +0000 (UTC)
X-FDA: 84559623246.01.929502E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2D8802000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhiUQm0b;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WflG39A2ouZ0xljmsR/bB5wW/UudjNQ1hu6ijwlE4H0=;
	b=fhUlxEa9/8oGmZhG1kA7QUo1sMpzkVt2HF58R6MToR3F94QoKh1fiPHsqK8aPdz+Tcg0SV
	mJ3TZQEyKLWqOSU6z6zOlNniShbfQwn3lPqUJPhckINX6Wp9CzI5cmNJF6M6kQ6oj9/7vj
	ldvxkj1CUhcmbekepIvyqFvDXg53EtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849081; a=rsa-sha256;
	cv=none;
	b=dRA8CIJZR7JPE7WLRyOq8Aeq54JwYSacAUyeV7oR/nFx8I1cpICmEE0tW+KGF0mTAiCG/K
	E/9hsCAsLcVqqol4nxs1rnHHaeMl9e9pHqgg3S8TNu1fj7y0g9U/DDJuVZfigS+oGyoY7+
	hB5o2QIfhezSA+2I8pF5ulHcuKv7ic0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhiUQm0b;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F812434B8;
	Wed, 18 Mar 2026 15:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78470C2BCB2;
	Wed, 18 Mar 2026 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849080;
	bh=5OA6L01HT6P2sb2CV4zMHF2SwBn+dEQzEmLD6KvnAPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhiUQm0bjd4gQBVZbED8/g23Abqc6i1QyzYx6Ik1AtVps1gsMTyVwLq9ONNbAVPxD
	 Gbja4fHfrvOMtj+xJNlL487f+HiIoyenN12ePVbWrvV/5Fy/evcCAM7QM0/nrVGNfx
	 qwKY52PC+kxzhxWA8FuPcu/5MSW4CNT4zGNMLkM/dGRfuT+sq/d0kLD2fjtE0zxPJ8
	 ZDlRfa984J1/VpyjE81M6xk80lMpNYMteVDPvZ/3X+JsYrZvH9g5GGbnFgAUcrYBu5
	 Tni0NODGP8jpmHoTDBb3RVd6cccdIYj2zQ9xNUA5VVmWJdEcUHzqwayiJKdCWhhAko
	 bIz4fzGE51gjA==
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
Subject: [PATCH v3 14/23] tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()
Date: Wed, 18 Mar 2026 15:50:25 +0000
Message-ID: <7dfbb4e8b24808b7e94470717a560a52130907bf.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xsks44i9hg1t49rzcfhj6qfgg4557z5s
X-Rspamd-Queue-Id: 2D8802000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773849080-113777
X-HE-Meta: U2FsdGVkX1+FccDsuvkWWkTU+3mTI60D5DYj8AY9rhGqBOnbiOkB51ztRCB/YBLoIMVxqPuD6L0PbEqRcd0oESusUmq4LaeGtdV6Wi2mCk7buJNp/C8KtFoZboGSL55dY8pDrSA2f998hFbv6/kOmx3ksHHpUClAw90AklEgoNfcRA5wWoCCk51OKKyRbbNqQVIthSVQvmQFyrbpv2HFYalQfepSK0TN54AUBbBOJRfoPZJGWtlO/6S9/XKmd3jIxb49Svh08s8ClbBkhpSbGh1ER8pZm/RGu9/NPuaPFr0qP+5aWgAH0IVsbsZvBie2pj2+wkMPpcI/wshTxP5Se2gVIy2FKq8UaafPpg4mN8FYvVD8wKk+zBgZtvyewwOj/3VdGdtU28LsNz1yv4dLgh09Mahvw3EbHU7lpWKXMNayhcFDyhqVNrri1yipDY3lggYDJi+t0ihGyIq6sMqen1E6Hbm80jC+1P1RNVAFxSG671SVBU5N/H6nLvwqhODfxpdaKeu4DhXVeEy0yBvixHIJxOMtNQ8eA6AnavlmrJ0GwF5qQZoCu/ui3muEswts2WbxxRL4eVG3MX1qdWEV5qAiszIUnsTuvxJDSho+ZGO/5D5ektis62B71dlqnMcbe/5pjLXlS/Y7HeNuA9UXb/Xn0EwLVcL1nKjHMeonekGJ1Y+zedCa30JhkLJO739iPOrMC31HaSGlSCt++oICt0jbwTs5yMI8DvGc/SMDotrOVoSFnj2yxJUpvWaUgBh/KtMaGzdhVh0HKaXqMteQ+xNR3TK10joCHhMi5YhXxTTKAdMX5NGHildPSupOQ3cfe73ZwbwmAmLGbNnqTi/KrUoyoMKPV1+O00girbcZ/+vsGldYReiDRWqcFocMhn5gCh3T+3PDLDUhimCLYqQObxNF6PEqGksdlbKAxCP7BD3zirX3HYDeUi7gV5HBQ2aX1U1lXfV3344CWVoK+7L
 VGVJT0vu
 F0vIau9vxlSqh3U210I/cyJ5FYUNLvMyP4FlRMs7ysNFsrK5uYNhYjj0AUhJ6HConwN+/EiKET5osCOdoeP0WBD0k2sUgO6cbcl02uqmHW6UZi6XBjF56qGkRYOrac/N3zNOb8vagAOeAC4k/twHOXloSqmSLdYbiNVtiz/wP03nvX1LdJtdm8HlveI7Sp96yCZZRu+vunmXTeW+QnZYZ9fo1AAUIURu6ZqlVUB8Z73fycT7G4PXVciqbZIKPUrus+skAELn2QcKiKwvZrihGxQcL7DsPzec+Q+E1NESekEFyNYIuwus/BmAt5mhYp6k35GJkMQ28PxH5LvR2Iyw42prd2ZZT428Kabku
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


