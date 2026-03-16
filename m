Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5595DF506CF
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1BE36B0286; Mon, 16 Mar 2026 09:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF406B0288; Mon, 16 Mar 2026 09:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6CF6B0289; Mon, 16 Mar 2026 09:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87DF36B0286
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D7EB139F7C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:54 +0000 (UTC)
X-FDA: 84551958708.07.51DAE05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A06F6120014
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c/PwSF9M";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oi/7QCuKcE5JasDMku9JB2IDtLRArnIIVwaTbfdVvXU=;
	b=nWxvQIHFgjL/Jea1bp+3GBoGEHRpmDDA7ce8bkz5JYyrF43Axt7EuPWlxO01FJoEPGQe9z
	Y4eLPVAQYf6TU8naJnoC3D+bKx+HugNsp/ZJmV2r/szHjDeOQ1mlKD/gKHj8djUklu6PHX
	MBvxoU5KWJuBBJpRmiN5fc5ZshRVJIc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c/PwSF9M";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666592; a=rsa-sha256;
	cv=none;
	b=kmaialg4OGfBFrt+tDln/xk9vgsmAgmZXImRoujt0C4zDzQJYkCNvKuoeCcsnpYUQB3Ohq
	cZeRO/MvkznL3R8Dlte90exyJOxjXIVSiAep5VI07GYO1laIWk1fTJEaO5vqCK5OQwPCtE
	ILkLyyIKikm1ym7gobX5nEqrrKJa9qs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B90AD43A2B;
	Mon, 16 Mar 2026 13:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA407C2BCB6;
	Mon, 16 Mar 2026 13:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666591;
	bh=8kH/hY51Bfx/3mqUs9iRzX2ISmpdgA0zopXy2XbwBhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/PwSF9Ml2Ej+qaeF+f/TtuQSPJqv/46C+YOWp0lYbddUKK3j6m0S8lZSLAGPhQIv
	 A4BkVLlifz5AK3UPfaLpvxZ7YgQNR4ciJ09lzcUXWmWU3FAWKZkE6/KOkCqWOVaq/y
	 g0hmOhDRikdE8J0brmXGV73GTzLjQZKKohFtdjvD9on1SnYmY/pyu5zO+ciopeCNEY
	 r2FwQYu8OiG01dVUzCEb9fAuuBFn/gjZlFqSMl8kiEx2HvCW73UisSWS15NFcurbxI
	 /fuFG3GwTl0xhOJMEU3k16TVY2SUrba+z1tRkz5bm1SPqZRvq89c/noXzhACv7BemF
	 QvsZKUFrEpKPg==
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
Subject: [PATCH v2 20/23] tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
Date: Mon, 16 Mar 2026 13:08:09 +0000
Message-ID: <65bc0bbd98698f4dc68c046e6f867274b1497d8a.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A06F6120014
X-Stat-Signature: kn7frkd3w5fy1hr8ptr6sy7t9uoq64mo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773666592-198697
X-HE-Meta: U2FsdGVkX18Al0AUKQOryDJDxrFbnj9CPUTSg/42plVijmYFwiiDrTUjwLpIfNwRQK95MUU2pKOoDX4WgFVOFEWxSx8BmaKc2xNme6+WMmziI0vPsvXj5Muo8jdzMbbdXy7bayaUMDw7l27GODr9jJL1UGXXZGKLWemgXJ3guM/Uh8MwQdcIJtUXJ56/9ubgEiJKRQxCVHYFV9HQsSXCMpJUG5HJ8swnOwP9xBXtt1qIJMZFPIVKIU1pO2671ztz9Lhc91jJxAFMUq8PoxBamttaGlfT6Dyk14cid2r4ivjmjDKntOnSRilbE+zlAirDXA0wZIjR4QDn+HM8maxPZC5AU0Ld55nNUfffcXVsTaBu7qVezppckeZgSMuCT/mvSGRrBDHUbFH+bsulr77zLGTyDtuTae6iU0AVxJhEZtvXB0Dd6c4QHWbEHsoODoxo2fHkOJrfdHqXhmGMCodlDRm28XQBJHMZvjqlaTOnc+/s1IXvc/Vcljj4dMGiiEkjYr1IFbZSITH3OuZcMifjJ9iMELEnqwZPRHCRTxXqv6mTyw3Ybm/EFtFVkbd82V2QOzTGixTfBL3y2E/B7Zmy8zDwe1dQt99Y2LFEzIdF9buZ6QPATl/s8O0HavJIuzWhRmQDAP/1E7qZiWfMT40XZNoYftYRhRiynY3RxafVVlHip7fb1E2ux/n2P2DZDMGD069U7FLzyDy6OZYAgfka5q0gePgDf/TiDpcE/kCi0myMPoTJ5hTfVB1T+5/DZLuCfEtEypbHT/8pFeDiupplmtfBkCY/tP/SaTFEfo7x8Gt9OrR6YxqiCGzBwCoTtPNEvA+nsnhdFjdW9NdoSXOzZNjCnXxwL5dXk963GtpRXJSGXO0z67Xk4Oe2IJINNQAa9ti0XGgtMHE3GvlKVbNnuPZxHkJfpHtGtF467pWjVdyFT7j5lvmYaRXwF74h+/f7CYtwZ8xwc07HGacjbFM
 4/JZ2Cs5
 heXZkpcIwj0fRlHuKQGRojuBQTvROOqtUm7k/QVOY9FPHSedYDdILfIuMHJj6rPL07TzuzHtBNEfLSC4PDwJizXoWkOmRIG5CMaNBzhGZG91ldbt1wI9ZyjOLmG0FBznSdTJpEahCnw4hS0I1wosswqZpmBX3NaiKjHIcGdOQbkDx7QuV59IVcbv0MZ/vCguiw43na7DTq3ml0xT2iFmnNI9oaNmJjXX4+ZJHzkg6r6RJ4ejHY5Koppl54nRJi1Ih6T/hSo+8cowB9pi9LJZXWrMKUZKEywqLLf8D386QY03neNnMO5B8mpV80Hnn65n4hCiCzB9DuF6XnHhftkjX2sCt1lY+DLHENLHp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test have existing flag clearing logic, so simply expand this to use
the new VMA-specific flag clearing helpers.

Also correctly some trivial formatting issue in a macro define.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index c73c3a565f1d..3ccbd8bdf5e3 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -347,19 +347,21 @@ static bool test_vma_flags_clear(void)
 					, 64
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
 
 	/* Cursory check of _mask() variant, as the helper macros imply. */
 	vma_flags_clear_mask(&flags, mask);
 	vma_flags_clear_mask(&vma.flags, mask);
 	vma_desc_clear_flags_mask(&desc, mask);
 #if NUM_VMA_FLAG_BITS > 64
+	vma_clear_flags_mask(&vma, mask);
 	ASSERT_FALSE(vma_flags_test_any(&flags, VMA_EXEC_BIT, 64));
-	ASSERT_FALSE(vma_flags_test_any(&vma.flags, VMA_EXEC_BIT, 64));
+	ASSERT_FALSE(vma_test_any(&vma, VMA_EXEC_BIT, 64));
 	ASSERT_FALSE(vma_desc_test_any(&desc, VMA_EXEC_BIT, 64));
 	/* Reset. */
 	vma_flags_set(&flags, VMA_EXEC_BIT, 64);
@@ -371,15 +373,15 @@ static bool test_vma_flags_clear(void)
 	 * Clear the flags and assert clear worked, then reset flags back to
 	 * include specified flags.
 	 */
-#define do_test_and_reset(...)					\
-	vma_flags_clear(&flags, __VA_ARGS__);			\
-	vma_flags_clear(&vma.flags, __VA_ARGS__);		\
-	vma_desc_clear_flags(&desc, __VA_ARGS__);		\
-	ASSERT_FALSE(vma_flags_test_any(&flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_flags_test_any(&vma.flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_desc_test_any(&desc, __VA_ARGS__));	\
-	vma_flags_set(&flags, __VA_ARGS__);			\
-	vma_set_flags(&vma, __VA_ARGS__);			\
+#define do_test_and_reset(...)						\
+	vma_flags_clear(&flags, __VA_ARGS__);				\
+	vma_clear_flags(&vma, __VA_ARGS__);				\
+	vma_desc_clear_flags(&desc, __VA_ARGS__);			\
+	ASSERT_FALSE(vma_flags_test_any(&flags, __VA_ARGS__));		\
+	ASSERT_FALSE(vma_test_any(&vma, __VA_ARGS__));			\
+	ASSERT_FALSE(vma_desc_test_any(&desc, __VA_ARGS__));		\
+	vma_flags_set(&flags, __VA_ARGS__);				\
+	vma_set_flags(&vma, __VA_ARGS__);				\
 	vma_desc_set_flags(&desc, __VA_ARGS__)
 
 	/* Single flags. */
-- 
2.53.0


