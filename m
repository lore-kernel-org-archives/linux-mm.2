Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF27106ACE0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C386B0098; Thu, 12 Mar 2026 15:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC866B0099; Thu, 12 Mar 2026 15:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC576B009B; Thu, 12 Mar 2026 15:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8F76B0098
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:16:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9ADE1B7B6D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:56 +0000 (UTC)
X-FDA: 84538368432.01.1BF5997
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1882880003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKZZ1baF;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DLBHkG6vqRaForNf+t/VbytL533ZBOTwVda3IYaYoA=;
	b=NT09F+3zxMa1WU3KDN1BmqYjc31wZYMuYYnN26SwZUwJ35yIJjA4NJGiwfs9GxcFFBDnoz
	cql+S2buB8pBRtUPtH7oGQ9GCDcycju3V57Bkawa4JszaoNIZpwszL3F/UjAiQ9MMw+1Qe
	/ZKEa0DK+DeOG7vUc6XkVXT7yhc6hTI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKZZ1baF;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343015; a=rsa-sha256;
	cv=none;
	b=DIZFEh7PJeieY7SpbmUQN4OIz11NmMcUPCtFNY0mnXTVHLkXUsrkiGV8hCw9LKnaxMTGQz
	/DkEVcy0YbBMN4TEnBagrxf3KOSIMue98anT1H647IDuMPYq/wkBBX01zuygPlXJmvYURZ
	pWFM8F3v94J9XojIE6EsEbsUOnwxL2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FCC044541;
	Thu, 12 Mar 2026 19:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD78C2BCB6;
	Thu, 12 Mar 2026 19:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343014;
	bh=KRWYCGfl5lbWVhLpxZ5/m8TfhMQA6wilm9HLXB+msSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKZZ1baFCEA0tzjGFaVeqWf2HDaTcqvoB759G8Q5c0vtNk65QKPFFb0OOdWERryQY
	 Z3Oz+Kznf8ItIS34XxfiFsfwlsWjWLR+h5CdDLZNZe9BvCWuvWJsQsICOhpd6qgwWV
	 +khw9B/HheqAmqpee+fmPU9+S7iD5GfsB4F4HLtwfkLI/42aZIT9SVfH1Pti6XRnSv
	 aK8563R9HFe4tiVDHAAXgxxOT8G8GXdbYPRuVz2EmFYuDJRou0rDdLcEZYX8Kd/T37
	 e15K9f8C7fYQPjJrUHkUrTlCU077d0Qq+FJ/Rl3mZ++7VcVkyvUgbDsZ32NcKggkfJ
	 7+JNRNBD+FfXw==
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
Subject: [PATCH 08/20] tools/testing/vma: add simple test for append_vma_flags()
Date: Thu, 12 Mar 2026 19:16:06 +0000
Message-ID: <60ad2ccb9e975247ba52748cafb6b988b79a1168.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1882880003
X-Rspamd-Server: rspam07
X-Stat-Signature: kx3fm7pkuehuymxnajpr343k3arcox5c
X-Rspam-User: 
X-HE-Tag: 1773343014-634053
X-HE-Meta: U2FsdGVkX1+i+jOiBCjmOdaZDCRVZmY5RnubIcsmL2t7z99tJiriCwKf6Fo2PnItzhwF3Q28LyNtWgkqkc5MWLo9PEqaN3yLCZn9h7k2gActi95B4B08h/u1K0Ji6cHs5UGKA2+vyYPwv2ExDLA2E1bjgTdjbs9PV2uEV+0smumDi6aUZfOiO1R4X4LRJ4Bf7Mp37U4vuI3NDUkhudoQgnCUcvD4Lk8Qt11e+epI1E4YpGyvaugohAj8YJ/SDu9dqeWzQrbpW4d/SBAXwoDDwMKDBkiUSTXO4X/U+xsCYa8qbs7sQp++RTgGG6gGsrp30HvrQf7qOcHUa9Q4g2gATFpZYIxZU+k31udPJbpp9Vj8Ni0/uDU2bzhcstmwASyinEicbEm8lqyg77f06+xYt06ElgkmlEpI/YPzP/zR2nT4pThNuzIg+g5/SzKv5/fF64VigxGkdLX4EC3RjvDHnVb59EqQBt9rkLZP2d/aV+NmGYVI3aoVPWKtqv7iG0GYl430869dFQc/w5Lmp1voKKI2Webk5GydoywkOP/nWwEi1iYY9H0Jer23zxlDood6uM7yzbJ3dYF283BdwEjft3WVjsbiypZYemRd4T4P8pSkzncJXaCIujGpofco7xeWPIuk8kTcoyO8KAog3rP2uDvq0kHgiPATwvBaeA8OtyUb9q/ET5MISezoel2D1Gt8xqygvbQbN2hQeGArDrMC7pdoWzZruMVpUHmxguPAIblLzj9BtXFm+GF+96+/GOysPBjrdktn55xr3dp785D9xKPL6rzD2VgnDgjACIzaTb5Hov7DE+qtq/aHTUccCDY8OVlDxSlgND6FJBPcWOVUuPhhjMO2lW15GMmQD181ZlATTstqtJRTw/Z4JZRS6tF7qOaEmepP+4Mvms9OnyPaJHnILI34mi3EqWfyhysj9L96f425X2W4AYoOOULpdhCS32lZTPLZWdbO95qEIF3
 k+KtkjkV
 Qa5/5Mh97VyMdA/totFzGtLZvWXl48bod4xTWrrZ5BTJYX65enhkM/PB0C7S58AHKB3kfNbh7SLlpy0m82diD+2p96gUYHhGdTQdOpHw+jnoHfG0Rh2iWETSA9PwFmMHXqpP9/E2WBgyU5K7/aLfAM2hMJ3mjeX5ZoQ0ALLdfB6YWM01JqvYOs9fhm8cj85Lpn6LSlHRISFjZqfJ6LGIC67fsQVayaaDMbM9ybTSveJHBOnFtBv+R8MmPp8LSwISjo4fEsVq5oj7YQiIQOUcOyoB5jOa3lX4TMZE1sq9kAltNmUlHj012v9hCNpH+G7FSh45fApWvMOstFtA5hZ3ivLPcs2fxfA4tgCI6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple test for append_vma_flags() to assert that it behaves as
expected.

Additionally, include the VMA_REMAP_FLAGS definition in the VMA tests to
allow us to use this value in the testing.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/include/dup.h |  3 +++
 tools/testing/vma/tests/vma.c   | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 0d75ac23ac4d..c3be8a2381e1 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -345,6 +345,9 @@ enum {
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
+#define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
+				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
+
 #define DEFAULT_MAP_WINDOW	((1UL << 47) - PAGE_SIZE)
 #define TASK_SIZE_LOW		DEFAULT_MAP_WINDOW
 #define TASK_SIZE_MAX		DEFAULT_MAP_WINDOW
diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index feea6d270233..98e465fb1bf2 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -555,6 +555,30 @@ static bool test_vma_flags_and(void)
 	return true;
 }
 
+/* Ensure append_vma_flags() acts as expected. */
+static bool test_append_vma_flags(void)
+{
+	vma_flags_t flags = append_vma_flags(VMA_REMAP_FLAGS, VMA_READ_BIT,
+					     VMA_WRITE_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					     , 64, 65
+#endif
+		);
+
+	ASSERT_FLAGS_SAME(&flags, VMA_IO_BIT, VMA_PFNMAP_BIT,
+			  VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT, VMA_READ_BIT,
+			  VMA_WRITE_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					     , 64, 65
+#endif
+		);
+
+	flags = append_vma_flags(EMPTY_VMA_FLAGS, VMA_READ_BIT, VMA_WRITE_BIT);
+	ASSERT_FLAGS_SAME(&flags, VMA_READ_BIT, VMA_WRITE_BIT);
+
+	return true;
+}
+
 static void run_vma_tests(int *num_tests, int *num_fail)
 {
 	TEST(copy_vma);
@@ -569,4 +593,5 @@ static void run_vma_tests(int *num_tests, int *num_fail)
 	TEST(vma_flags_empty);
 	TEST(vma_flags_diff);
 	TEST(vma_flags_and);
+	TEST(append_vma_flags);
 }
-- 
2.53.0


