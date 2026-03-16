Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF2BF506CD
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB146B0272; Mon, 16 Mar 2026 09:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8B66B0274; Mon, 16 Mar 2026 09:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290F56B0275; Mon, 16 Mar 2026 09:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 159526B0272
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D73ECB7086
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:25 +0000 (UTC)
X-FDA: 84551957490.04.DBAF7BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2128A1A0018
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UtBNJgia;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZRXNXNor2DP2ofyWQpr+m0PQ/g8MFx52e2958Xg5gg=;
	b=nlaRCggE9mwCpJrB9sGjD3LpDcIstaIKPszADiz+82yY1PEauE0XWfK+6/gwPVbW0VgzRD
	6iiC8XSsCu6i9i1mHAC6JHPswIdbk9EAKE4YxdqacrTCBIbsrExQInc/wEkTgLyfKUj4U7
	pj1jgezNBH90d9BPtifJBfmGm9y39Bs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666564; a=rsa-sha256;
	cv=none;
	b=uJznzZvk4EptCfDvCIpJorrzbOc4z5OXEiUw99A1idiPEWhPWW8sU3Im4XqiqK4QK5rUR8
	392K2+Ti5X00jgYk73AtnLRFWLmvu0nCN+0JhyVzOpkYuHG39jt1/RE/ZK9HsDBaTwKCpW
	dAgCYvZ9fEL8BLkDXv9EIPLLLSUCRAY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UtBNJgia;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 386EE4182E;
	Mon, 16 Mar 2026 13:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77504C2BCB0;
	Mon, 16 Mar 2026 13:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666563;
	bh=AKYVRv3x3CItXP70qtJAvJRfqFdFnb30pis7ztM7kK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtBNJgiazULZLRCvs0zKEDpDb/K+HnJhBZ4agNIlKD8uiAAucMs7wft6vhSfAZunU
	 OyqZOgxnhoDGW9l9DQM0oDFVcMaJEGdcP1qXJwAMQRKcKRyiTNuZkpk6N2GQ7CqBRB
	 J8ndEj+CMVrIS43/P7hmwhwNcbcJeOA1vrJzj+Um7XmPiI6mq/9gsWgm0Zg8ml7Xqh
	 bTkXY4PbR/UtIavif3Qu4QMIqEXQ+Fx+lo2sasQEIdI/wZJjCmRn14n6cppYe04Zb5
	 7NSMwOpFj5vDW5Ywkbh8EuirUCgH9Fig+sbuxhsF7nIzV1DuaBPw9h+Bo3Ecxfx1nj
	 dDb5w1OA5tCkw==
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
Subject: [PATCH v2 10/23] mm/vma: introduce vma_flags_same[_mask/_pair]()
Date: Mon, 16 Mar 2026 13:07:59 +0000
Message-ID: <393378bdcbb49141304d5eff7b8dad2966b73c30.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2128A1A0018
X-Stat-Signature: 6e3xpr41k67nym4ij7c1k1nccuwntxnk
X-Rspam-User: 
X-HE-Tag: 1773666563-223418
X-HE-Meta: U2FsdGVkX18xJetAR2CSpJsKb2Dyf4qNmiPpFa7NExl8IA7tF5++YHnNpswDJ2S9jF4U1/2gnZ4NIpYYgoO/a50GFa0jGpLF2DPemkc3X3zjiD2ArufbZ4XDbNH8APwdgVT3W3E1vjezA5rjVR3Z0ztLUGphnGeIwDHJjRhyLCVL2WptAzLSV3fzCj/cysUxBmYnaC528Ls6TbpX53vG6G1XSYH2uKGV+W2gMA49wXNCHFbPXd3S5qYyNMvoOs3rvAlS2pJ2z/qClk7JyYzIM9L313izf9W1ap7klXg/rXlmEXr6/WOj3vUQIjn7YitVBrHBfOphK0yMdR8Z7XkpNozlAG5zd0sEvwWB4nO61aakAhxlTH177k1USeEuinsXJxmBedrswYgl6LJOFwWxC4nlEcLcaNvIeU7VuiiXNTBOhx2rX11nG1/JZPl31E6KGAkuaisW5N5sZ+9ImkxtqWFtK1roLSg9yxGtww2ZmdpeliOHWt6gTJwpEU4Df9p0q7PhKzNl4+Owfx1gtlFaCK6q31oKHuw/RwvMxbWh7iEZQruIDX49L8bvl5SkAA6vRi8s2UDtWiKgKAgtEt0QAvHxfb+gWSTfu1en9ENpjUK65AFBU9QgYQgqlA9GBOiR985E4A1hxUY/m8TDaPH/DaRQvB+cKEiiss7PmKrZ9vRi7e2iD3vMKcHbZFsszTMln14V0DXdALQKl033F/8qud/ePanR7MdsG+Cb7azqevYj5pY/LCtgGF4myF0a0Eb9mCk0+yyv+JyUmGqkb7qju7Ink0gDrn9Hb8L6pNCylIh9s9Y6Dhdky44u9JdaSGbnty+Nc2IYkZB+j4h3gWys9Wv5cWlRHQ9HHOu/GbdnAsiDz0FCnINqIPmiF69maGSTJaHoOANSLAC4EL8ov4RKcm3SyTmh8EfzZqvojknSzZRFCBL0rA8RNviwrwxQZO07shmWfJbexOYqMGnVeDj
 GwTYbt3i
 0+LWgUtr9UdEwY3pU8Y4+aVCZn/SBlMR0sL97vBOX7wPJgUx/Muy6ppdMO6eI0xPRsPudwrYWynJXse64pchKHfS2TJyvpOXvdnSPDOq1iqxdRoHBsJYZQBRAU0ha8+8ge+PHG8Vzgh0bnlNnw8fgl+6ixRHs0lhLf5xaqD1CZplYfVa8pAPXBqYCqWp2ufxHoBJMJKaszO7I6i6At1cPgZ3OlP6ZID5bziYUlOiwm/PfZ+fUGmRcVfsesKFdkDPSWV/UhnnL/GKnn5Fcg54M27Op+ODf5j+oUgc1rA1ZXLCXIkt76eE67ZIKTDFzwWm/m6+nsxZrA6m24ND3Q6H8o37jRfy9lq5IRl/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helpers to determine if two sets of VMA flags are precisely the same,
that is - that every flag set one is set in another, and neither contain
any flags not set in the other.

We also introduce vma_flags_same_pair() for cases where we want to compare
two sets of VMA flags which are both non-const values.

Also update the VMA tests to reflect the change, we already implicitly test
that this functions correctly having used it for testing purposes
previously.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h                 | 28 ++++++++++++++++++++++++++++
 tools/testing/vma/include/custom.h | 11 -----------
 tools/testing/vma/include/dup.h    | 21 +++++++++++++++++++++
 3 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 42d346684678..b170cee95e25 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1207,6 +1207,34 @@ static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
 	return dst;
 }
 
+/* Determine if flags and flags_other have precisely the same flags set. */
+static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
+						const vma_flags_t *flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other->__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+/* Determine if flags and flags_other have precisely the same flags set.  */
+static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
+						vma_flags_t flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other.__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Helper macro to determine if only the specific flags are set, e.g.:
+ *
+ * if (vma_flags_same(&flags, VMA_WRITE_BIT) { ... }
+ */
+#define vma_flags_same(flags, ...) \
+	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
+
 /*
  * Helper to test that ALL specified flags are set in a VMA.
  *
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 8f33df02816a..2c498e713fbd 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -102,16 +102,5 @@ static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 	return PAGE_SIZE;
 }
 
-/* Place here until needed in the kernel code. */
-static __always_inline bool vma_flags_same_mask(vma_flags_t *flags,
-						vma_flags_t flags_other)
-{
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other.__vma_flags;
-
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
-}
-#define vma_flags_same(flags, ...) \
-	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
 #define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
 				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 47ad01c5d15e..29a6f62b01db 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -954,6 +954,27 @@ static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
 	return dst;
 }
 
+static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
+						const vma_flags_t *flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other->__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
+						vma_flags_t flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other.__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+#define vma_flags_same(flags, ...) \
+	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
+
 static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
 				     vma_flags_t flags)
 {
-- 
2.53.0


