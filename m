Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C960606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bn5mKTE/
Received: by kanga.kvack.org (Postfix)
	id AE9A16B05B2; Thu, 26 Nov 2026 06:18:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC14D6B05E3; Thu, 26 Nov 2026 06:18:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0056B05E4; Thu, 26 Nov 2026 06:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DEBB6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:18:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F273C1603B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:42 +0000 (UTC)
X-FDA: 85477022484.04.6464645
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42423100006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Bn5mKTE/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691921;
	b=ry9Mgg/DLP/H4DX56ZKbvTVRs2xPsgYK/iAnWvUMXtj35DRB/H+mMmjB3hgp8R2YpasWGP
	k4dO8uJ4SEZT19Zhkk1a6+KjsvKUbnEjqm7HCx2/IswvmG5o7IxwqnCTOIH68kq5A1e1mw
	OwH2rlNvCUSi0g/I2mAu3ePZnlQyaxI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktJ4sBRXGqvJMbIXWYsuN6usspS+V4heWNTrcbuxgIc=;
	b=PfJBZk4Mz0sPIKKfjZDXXO1lfDwkYTtYrDBJxWmwYNvZI7QC+CAwSebGr+x2c1V3Nx/4jv
	MpHwqheXFN1H4Gz1AzX4R4AJz9hLV32Oz2WuSKI+jpyFjLI1Kth4J/DDf28dcL0pB83vj2
	27cu/EgqT1gXx6A7wIcRAFZeYGW7YBc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Bn5mKTE/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4202630FE;
	Thu, 26 Nov 2026 11:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6DB1F00A3C;
	Thu, 26 Nov 2026 11:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691920;
	bh=ktJ4sBRXGqvJMbIXWYsuN6usspS+V4heWNTrcbuxgIc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bn5mKTE/VKF0HJEEoCN0Lbpnlc3goN5OBDOvDBpKdffqcM+AUpAHhRIM6xAf6UuPq
	 288ZdRDBV8joQHv1fPm2LkZ2YM4GN52DDLnOGbi33khOgCJhf31P39Zk7Br47p2A9f
	 YT8TicuEe2cXONCKMBJbUEy3C6k9jptyndArWLGucL6L+G0fZ585921z2saIBKMJDq
	 v+PQ6T0GU09nZ3Ght95fzc1ZloiDWK/J9zRlxnBRd4gZLdNYL3e0uv1lAsyRFXIo3a
	 RnTkrQeImkHiGHyirJdrhR7AqsaXVb2A0dVsGEMw9fonvAGasUOHAfgurGffcuU10F
	 MfilxsToEh6bQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:39 +0200
Subject: [PATCH RFC v2 26/54] x86/mm/pat: implement set_memory_*() with a
 table of operations
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-26-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 6n78cymmfp78ph8wp1bhtiurdkxoscrx
X-Rspamd-Queue-Id: 42423100006
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691921-82450
X-HE-Meta: U2FsdGVkX1+MJ5DtMvxv9Tf5Xk3tQiVZCkw95gyplFuNKlhcKuxP/9Kprcd7a6KKyViln/yEsaEs3znmkZOwza/AwsGls5TuQJk6z8IHz1U1VWSTPdTI1efcQjtr+G1vkX5ma/r/sZW7H1J8iZYstcsp//fS1I1uTSkYj75h9Aa6RvkbWXVw2T0xviOKiipVSdIOyRcT7jTFS3EPEizSjPJ+LCmhScsq/wKJLQYUzR0yaYE92ExgrmzFBn7PJm9Ci85OoN8B//rEdAOq+5qunJ5y4wOlMkCaz1k2vQClEPj5t/9Vav+Kwe7kR+MpHO68VNLdLF824M67OWlpvv2wHQmboqOHI0JMLK+lB1wt6FxO86nDPynjWfJ92qoW2r7212OXetgyevu/8wh2oahRfTnyYsbL7VJZYf9RdSkB3tBbsIstm+MeKGNFzpf2sAT5bZeljpIoummxLQvMCZWMtALnz8yOINxVeVXQoqU7lWZFnBe5g4Jz8pWSjVHYx3jC51g6KatNQgkrsT1lwlpJ/vk+Drie5z40PT+ZNa/+xkMSGNdylVcb0eT27nFASGkdZHdhLUGWHoHz3KNNa7W6oEwa8tJpBSNqZRvgp+U+ScjsZKQMBmTrVleqOahUNOyEFUS+5dF3maZ6irF+3DSearorbcrgcGzPg7HaQU5FDPISm6jRLK/OFs4R/goXFTAEXtm3eiZwzEA0WqGhNL6zdIV+ykzdN1oXqxfOkm1TEtYGbXkufpRiFLS449XjWLCpv/D84dhaRfukSX7fMrfRvGjAj8KUI5ZtSnei7+l6JG3E+Lxdt9KdSH8UbTX06mOmXkrapTYO1Vprx4Vp+cNkQWZ1D5pFHP6UiRbiXhww3ycd0F+0+b4583mHTUZ+vRnedaebf8ttRdJVe3rzQPSuYHmqkpcjur/enD9prbRbmOp1+DBl9cmuKDgB3Ezqm390b748jGKCROmVKmLC9l6
 u6tLCSfI
 hmTzuaQJAHz2R62PKSxHlzG/rx2llgC61XEXQMx/RCDNDVuLyacigVFM6fc8NNY582EIXxBWjwB42WpgyAt1D4rwGZZesDX4Di87MEIQ2XdX0E02Rhf6jLDySX2kgLRkMt9BVu5Sb5Je+/6uL8WRAsLLKk9JKJm3aO9lgUF90VKW8xwnvEeYYtQzQWfCrGxLUWdDMPaTbC0p5v4yja4qAEIGT6K66IAxX2sPmgalsGem5bz7lmE9vL91ph03wNu/oBiH+28J67OJsB6GX9Tl9SuD5IcdqnLi/kpqovSTrFuo3F3p+6MlahbGGBvBaWJZEmUKY4KgyHEq/oCLxFKXDWFZTYuD/AiTr7hUcRrDrTdSl+M/vpe97S5N6O/ED4gTdzzElRmXu/KjVaHfKs8DN2fKGvy8wyTtLZVZFfCtBTXdVXUJDvem1coaVNlMEjMMvp8NwSMziRA7j3M1R1y4/gbEHBqYnBPI9CZaEOsakgjQMzp0rWFdBrYZy3yD2DRbdydDx41Act9K7SWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every architecture that implements set_memory_*() and
set_direct_map_*_noflush() has a function for each operation, and the
functions differ only in the masks they pass to the page table walk. s390
and powerpc already translate an operation to masks in one place.

These entry points are going to become generic, with the masks of each
operation provided by the architecture.

Describe the operations of x86 in a table of masks and request flags, and
implement set_memory_*() and set_direct_map_*_noflush() with a single
function that takes the request from the table.

No functional change.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 136 ++++++++++++++++++++++++++++---------------
 1 file changed, 88 insertions(+), 48 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index cbbc51be4de7..08dc69317931 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2392,42 +2392,98 @@ int clear_mce_nospec(unsigned long pfn)
 EXPORT_SYMBOL_GPL(clear_mce_nospec);
 #endif /* CONFIG_X86_64 */
 
-int set_memory_x(unsigned long addr, int numpages)
+enum cpa_op {
+	CPA_OP_RO,
+	CPA_OP_RW,
+	CPA_OP_X,
+	CPA_OP_NX,
+	CPA_OP_ROX,
+	CPA_OP_DIRECT_MAP_INVALID,
+	CPA_OP_DIRECT_MAP_DEFAULT,
+	CPA_OP_NR
+};
+
+struct cpa_op_prot {
+	pgprot_t	set;
+	pgprot_t	clr;
+	unsigned int	req;
+};
+
+static const struct cpa_op_prot cpa_ops[CPA_OP_NR] = {
+	[CPA_OP_RO]	= { .clr = __pgprot(_PAGE_RW | _PAGE_DIRTY) },
+	[CPA_OP_RW]	= { .set = __pgprot(_PAGE_RW) },
+	[CPA_OP_X]	= { .clr = __pgprot(_PAGE_NX) },
+	[CPA_OP_NX]	= { .set = __pgprot(_PAGE_NX) },
+	[CPA_OP_ROX] = {
+		.clr = __pgprot(_PAGE_RW | _PAGE_DIRTY | _PAGE_NX),
+		.req = CPA_REQ_COLLAPSE,
+	},
+	[CPA_OP_DIRECT_MAP_INVALID] = {
+		.clr = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY),
+	},
+	[CPA_OP_DIRECT_MAP_DEFAULT] = {
+		.set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
+	},
+};
+
+static void cpa_init_op(struct cpa_data *cpa, const struct cpa_op_prot *prot)
 {
-	if (!(__supported_pte_mask & _PAGE_NX))
-		return 0;
+	cpa->mask_set = prot->set;
+	cpa->mask_clr = prot->clr;
+	cpa->flags |= prot->req;
+}
+
+static int arch_cpa_prepare(struct cpa_data *cpa, enum cpa_op op)
+{
+	cpa_init_op(cpa, &cpa_ops[op]);
 
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_NX));
+	if (!(__supported_pte_mask & _PAGE_NX)) {
+		pgprot_val(cpa->mask_set) &= ~_PAGE_NX;
+		pgprot_val(cpa->mask_clr) &= ~_PAGE_NX;
+	}
+
+	return 0;
 }
 
-int set_memory_nx(unsigned long addr, int numpages)
+static int set_memory_op(unsigned long addr, int numpages, enum cpa_op op)
 {
-	if (!(__supported_pte_mask & _PAGE_NX))
-		return 0;
+	struct cpa_data cpa = {
+		.addr = addr,
+		.numpages = numpages,
+	};
+	int ret;
+
+	ret = arch_cpa_prepare(&cpa, op);
+	if (ret)
+		return ret;
 
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_NX));
+	return change_page_attr_set_clr(addr, numpages, cpa.mask_set,
+					cpa.mask_clr, cpa.flags);
 }
 
-int set_memory_ro(unsigned long addr, int numpages)
+int set_memory_x(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages,
-				      __pgprot(_PAGE_RW | _PAGE_DIRTY));
+	return set_memory_op(addr, numpages, CPA_OP_X);
 }
 
-int set_memory_rox(unsigned long addr, int numpages)
+int set_memory_nx(unsigned long addr, int numpages)
 {
-	pgprot_t clr = __pgprot(_PAGE_RW | _PAGE_DIRTY);
+	return set_memory_op(addr, numpages, CPA_OP_NX);
+}
 
-	if (__supported_pte_mask & _PAGE_NX)
-		clr.pgprot |= _PAGE_NX;
+int set_memory_ro(unsigned long addr, int numpages)
+{
+	return set_memory_op(addr, numpages, CPA_OP_RO);
+}
 
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), clr,
-					CPA_REQ_COLLAPSE);
+int set_memory_rox(unsigned long addr, int numpages)
+{
+	return set_memory_op(addr, numpages, CPA_OP_ROX);
 }
 
 int set_memory_rw(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
+	return set_memory_op(addr, numpages, CPA_OP_RW);
 }
 
 int set_memory_np(unsigned long addr, int numpages)
@@ -2692,50 +2748,34 @@ int set_pages_rw(struct page *page, int numpages)
 	return set_memory_rw(addr, numpages);
 }
 
-static int __set_pages_p(struct page *page, int numpages)
+static int set_direct_map(struct page *page, unsigned int nr, enum cpa_op op)
 {
-	struct cpa_data cpa = { .addr = (unsigned long)page_address(page),
-				.pgd = NULL,
-				.numpages = numpages,
-				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
-				.mask_clr = __pgprot(0),
-				.flags = CPA_REQ_NO_CHECK_ALIAS };
-
-	/*
-	 * No alias checking needed for setting present flag. otherwise,
-	 * we may need to break large pages for 64-bit kernel text
-	 * mappings (this adds to complexity if we want to do this from
-	 * atomic context especially). Let's keep it simple!
-	 */
-	return __change_page_attr_set_clr(&cpa);
-}
+	struct cpa_data cpa = {
+		.addr = (unsigned long)page_address(page),
+		.numpages = nr,
+		.flags = CPA_REQ_NO_CHECK_ALIAS,
+	};
+	int ret;
 
-static int __set_pages_np(struct page *page, int numpages)
-{
-	struct cpa_data cpa = { .addr = (unsigned long)page_address(page),
-				.pgd = NULL,
-				.numpages = numpages,
-				.mask_set = __pgprot(0),
-				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY),
-				.flags = CPA_REQ_NO_CHECK_ALIAS };
+	ret = arch_cpa_prepare(&cpa, op);
+	if (ret)
+		return ret;
 
 	/*
-	 * No alias checking needed for setting not present flag. otherwise,
-	 * we may need to break large pages for 64-bit kernel text
-	 * mappings (this adds to complexity if we want to do this from
-	 * atomic context especially). Let's keep it simple!
+	 * set_direct_map_*_noflush() change only the direct map, not its
+	 * aliases.
 	 */
 	return __change_page_attr_set_clr(&cpa);
 }
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
-	return __set_pages_np(page, nr);
+	return set_direct_map(page, nr, CPA_OP_DIRECT_MAP_INVALID);
 }
 
 int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
-	return __set_pages_p(page, nr);
+	return set_direct_map(page, nr, CPA_OP_DIRECT_MAP_DEFAULT);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC

-- 
2.53.0


