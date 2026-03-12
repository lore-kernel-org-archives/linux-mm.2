Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08B6106ACE0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628A46B00B3; Thu, 12 Mar 2026 15:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EAD76B00B4; Thu, 12 Mar 2026 15:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516FB6B00B5; Thu, 12 Mar 2026 15:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40D236B00B3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:17:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F1D88A457
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:19 +0000 (UTC)
X-FDA: 84538369398.20.36B4FD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B67A980010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6biTYW5;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhMnv5mmN2PItMUZRkAdo/GwoeVKV/dEwdSk9XVYG6M=;
	b=OqA/EYRtXh5SuQ5dsMZEyOEvKpSJ3p8oBWO4iFLOCuiNOeOvbkKpY60jMZ0nxEESSQcWTH
	YpWeFlEAw5W0C7SPEjZiRGp+h/3pf1J/rs/qm711gK5MbU0VNpll84HDQCoTATBpxFugUE
	cOT2VrLrabrDqxctg4u7fvwEF8ucyrM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343036; a=rsa-sha256;
	cv=none;
	b=ZxOo5BB7po53fFxvnD5RekNcJBesLl4G8npnKy9n/a2m5ireoevv44pw4/wfQKW3ERxt6r
	j0HLSpjK1T6t5TuHce8XujiYO3+wedtmVBd0VW5rnIuFYwcCw5is/wFGq+GrEoIZ/e2yV5
	GFHaGbXxWB7HH9PhXwPW4n98JKnACFo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6biTYW5;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D270444532;
	Thu, 12 Mar 2026 19:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B21C2BC86;
	Thu, 12 Mar 2026 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343035;
	bh=7VXWMMb8aKJSoBfGPrIqO8IUEnKlulnIJYLzAvN6j+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6biTYW5jbYbTepby7X/BkqorLcHBb04qPmImr1kZ3nSuHLOZ/ZrHAZMp7JPqfDIU
	 93qlU0/T7LPgAQM4z9toGawMEUM2zu9NNeM1y8fElbpKwQ1pcdqqqVlyJhZ5zp9jxx
	 eHYm4l+oIEImlYHb7YnIskEY0EsKtxwm9wnq27GBF3d02vQNa6HpL1wbvyJOYyt9ho
	 YJkN95McMgQtPBs1+M5qUXxKitxLXHTtQ72b3LaNkYsE/k2D+DjqvMxtmI4DovAmUt
	 hU5vyYvKqDoNkCdwzA1gU88jk950A5cER++yK28TcRIsoA7mCT6fbLdmO9EyS5xnK+
	 aanewocyJ2dxA==
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
Subject: [PATCH 17/20] tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
Date: Thu, 12 Mar 2026 19:16:15 +0000
Message-ID: <c391ce76c41eef0941d3e6c2e51fec73994a8316.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5ipec9nfoo85zriik75a5xo6ctxfoo64
X-Rspamd-Queue-Id: B67A980010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773343036-108662
X-HE-Meta: U2FsdGVkX1+LaLDUsOzbBehgSsfeC8WOwx121SYdPR66oFIzOOnRaP7WaiP2Y2uxRGvTQixXV/II2S4e+rZqSbYdR+o1TW04I8tIWbz+SXIuXcoEwz/3+l9jd6Uu0Ia6/kjD6Rs7zHZGHu36OKIGOtC26hgF6FV6fMDcVwZDMIFsSUYFTTtaX4JHERVz4jBnpEfcw588IZYxs2jGCEfd80L9qJFAHTUpYmb12SkB2yFVn7x+ZA/Qh6PvcnhIUuUDCddZYSS1SiTMb698pmYp/pvA/NEGRkIPpLaLkkwmvd3E8kjwsRRdsfj5sJjcnPq2zVV5DGNa631FJSvuK2WRUTRjDqCwjzvlsqb9OYeipHnX8qV1q/jdpBeswcw1SnY0RRLOP+fcllfXnZyisVT7PpnqSG7OEpvAh2PGWaYAY0k/OuUntAm4GJZ1rT9k/WfUqUi4tWWfL5mkfxr4G+xSiGYf3jm3MBTzmuYjpLuI1eB2u/adhBGhL5wg+GB+8uG0UQQDLgka8I9OdA6hxATgJuW98sUUskXPBVr71JdeWFEkGoNdJcwvHLzqRYWbHRvdRWWBMiITPnA+oPioDxEZzk7iUiCalxDgzoc2Ubs+LEU0QX0fZS3ynvLrOrj4GVjH5VdU+n9rfQNrF3c0XY+S+c8jOc09jSNbPXwXUVcFwDzAri7PndRA744obBqOe4NXUhEzk3RuzUbvbTqk5fVZbOH8yVTI/pq3j33nvB2P6RR2CPdKR1SMxspIweInvBZ59dGA+f1oiR+09UCTbUwgFz4oOBXxFEeFG456//OTs7l28NFVmh5iTfbp8wtu/rb0haSPsFb+0NxxWCGTsTrkq0R+ZQ+9LDz4FxQtaMclxQbSoeKYmNRX+ltONV8VcsqSCTlTR2p5Bv5VASa2emqUEiQcPgBrVZCked39LB9+1HLwcYbO3kdupir3zjHI+x0Dn6rslDLLYnSiwtp7547
 e9YJ/Utj
 6wgmglCOqb+L3Z9Y4OO6sGJxs6dNrtM3H0mimz8n2chp5IL0t5Yqnpf0By1CWUCAktZ2bjEamko9UuZEh3rESZh70dtXAbrfMnmR6BW4dFRO3WbTDsFshYAA+ld/d1OzXWOlTrBC5gMxZ5jKy0axwO0txhcpcQ4rwPmZzTJIflgyFTuVXt0Q/jJpSuTioneDSgNclfPKvmgNmY/YUi8vMxrvDsyQbXPiTVHyxP2BqXyMjaOZV63SMLI/lEmunXS8rNwrENBE2YSjHn5H4TAAB1KU1toVB/frYiYQmCfoB/VO2bXBcPW7kRMdZKiCSobYVDQtLlta2Mtt3ffulCwQstFZix5vFWoc6ZEnv
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
index 1395d55a1e02..340eb3119730 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -330,19 +330,21 @@ static bool test_vma_flags_clear(void)
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
@@ -354,15 +356,15 @@ static bool test_vma_flags_clear(void)
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


