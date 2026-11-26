Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5B0606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cDUnZJ4u
Received: by kanga.kvack.org (Postfix)
	id 9AF0A6B05DE; Thu, 26 Nov 2026 06:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988376B05DF; Thu, 26 Nov 2026 06:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CFB6B05E0; Thu, 26 Nov 2026 06:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 615E16B05DE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:18:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3AEBA0689
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:05 +0000 (UTC)
X-FDA: 85477020930.17.83BAE62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1C0F98000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cDUnZJ4u;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691884;
	b=rhMuft666T0SoOArtIp+uvUJSChCYmJXOm6oOOvayW27L8g6TpIbiE59PY2BuevG21s7n0
	e5NUAZqcU0ysyWFuqN9hpon1+Qkr6anDeQZ/fFUIfgtUDiTm164pU9PM9P+FSgjxitOrkP
	OecM6iGgiZsgEdjcd70+oe33aE1iNLg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuNg/+IqwDeUPgc4V4ONbexk5EhrBaEXT2bA4fFnVk0=;
	b=0JzBphBtl2ATzJ2Xc1pPrjrlIZy/PA/bDuzUWcgzYuybC/YbgBATw9jtGhMpgGwg/Ij+4z
	0vCFPE2Tn+bFzOUKTo9Q7Zd7uxZV+R9W4HDKMr8FD9OYjJQSCcDJkfj/+ZOahFXl0cLiFM
	nV8eQjsttw4zEJlemXQ5oM2wbA5uKEw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cDUnZJ4u;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6859244156;
	Thu, 26 Nov 2026 11:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72051F000F4;
	Thu, 26 Nov 2026 11:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691883;
	bh=LuNg/+IqwDeUPgc4V4ONbexk5EhrBaEXT2bA4fFnVk0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cDUnZJ4uBXhYX+uCkx+TJWJMvuT4HdvtrIKy9YiOGubEbW2WpKhS7HgZHvOCnBP9n
	 UdLkBCN6aehYkFqrEm4ektZzoNieAkCVohQY0jrHFfUd5fNnqkAQ9UQc8vVBMSFymi
	 aP0MitFMb+lHpiJ/8DQRnNuJ6+YWVKLLF+rOzyKpj2w/hsZfCoJ6EHl2IME8K1iGPZ
	 WIDk+cGgvkbKtKRvs8On0tR4pdUNkEd/M2TmEUWHjsxXBBRjMBBQeSlAk6JqWDPfUP
	 Bd//4zNaBlwKksvSBxOr5bBzuABsGs0npCyMCO4HNgEaoTe0b1igiIjsFbaryo4Uhi
	 bMeTZBhOSNX6Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:35 +0200
Subject: [PATCH RFC v2 22/54] x86/mm/pat: consolidate calculation of the
 new protection
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-22-723f1e33c3d8@kernel.org>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C0F98000C
X-Rspam-User:
X-Stat-Signature: zf4wyuqwx5mdwnkko8rft5tbe19m73oc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691883-729613
X-HE-Meta: U2FsdGVkX1+FLJHkC3ZRNIfMFhba+P+92/6jE7wE/qZhh5PI+5wWu+CDt6n/ozL3mdxryFEZIKjIPDgHEaYRPP19FjwMj4KqYejJl1aIhG+H1M5cuX+lcsssta9aYobcKFajC6uTdlzL1ThmzzIHCObFFBQSP1K81iluKBb+aMDlw/9kvuzf5mKOI7kBL/h0oCEdo6TiX7bLkTq5cec1JOHL8Kl9leoa4EQkDrsN+8zPs/tubeBkGqm02qTbEhPx2xKs0s5Ycs+SdocPkhselzEp+0z7mCkXUoGAMj7IOkiLg2TWycQShscTEyb03asoMpXCdO0MNLU2taDfV6e3EYVNrF4SVPMlszt9biWeVUvQqSc0J+6iAL/bFKzBGX/6jRIDt6oaAF29QTFKAV0d4MwDWIxHSoPL2RXUTknL0QjCXvFT4B25RoY6LLv+hSl/PjAbXPSbq/xtltttV4VPP2aFMU+4yqOfh9Wyv2rrvFubENGQPaGw2UthER3umBm39z3KbDU5zavt0kOAbUxhs5aEgK6itR6k336fAs1pAIfQsT4A2uJqVQABxJG1PIgbP1GiEye/GhMki/7NOEKWJAilP1acm+pjs8seGq4KxEfYmAgNYdugwBJY02MB+5//lHo4UihusosC9dEJya2xw2nThmpkNU4eYOnF9GeR2WYBwhNVYa+B+YdoY6kE72fzLAKNl6/LHS15HIrplUp3+KHKxD5ZNMOk3oqzz1j2mgTRS/S1T5JDa3vWhDHCzqqtanmFemH78+xwQgNeL+Z5irh8mOUzsqNTpGzrE2R/nXTfX/LJh45toRdeuvHgIOV7z8M3fvlynVtymtqm+GFZRDDppMvkKJOGEVYEDXpdSX1gQgDZesM/iedFfCd1MgRCFgNyuEDJcORouX+BVhWnn7ppZQY2J5O2ZvrHupudLaK/bn2282h8wPKErvfZpchGvnJuDprUKlFk8VtWxEP
 VhebG5qQ
 EsaDk3Gdw7jXXtRKQ550uqQl/kpUQITjAm/rVjHS+FggMgL/7TdPAcxUc6rUpCmT8fRDYuZrj+6ZSmZKkCfDHqdXarYxtLZhglwywmcwjIAJVxGnW9kq+SABWRF7PLzEmr1MeeuEfDOQtkyuFE6IZlJr4SbLPLc0N3CRecZkRKKEWn9sr04ysEM0+L2zLnuJgVCtigLFrpdLrio3MlWpV8/TouqngOV34JiulnVCKk0ruftXax4vBPeLT6ONpeZA/UEzkkUOETIBn9/u6Wpgk6W3e6+TMyl20RpmZzGwu463IFuASOO0iwNByulI3ErQTLhpvUbOz/+VN85Sg7SArxHjLg79aTatnDHzxlCglZyUVlbge5xPH/xv+Iijpsn9pomKRMGxtChnidSimZe+llW5jAyJbyZ239MhvGNE/19g/Z9sTv0DmLGEr8KVwurcmSuEk0mJnpvDI5KtPxPNIO5lZQ5mj15utkQNd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The large page path and the PTE path of CPA both apply the request masks to
the current protection and then run static_protections() and verify_rwx()
on the result. Each path spells the arguments differently.

The generic core will need this calculation as a hook.

Move it to cpa_req_prot() and cpa_new_prot() and use them in both PTE and
PxD paths.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 54 +++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 304b7ad26c45..cb503e41340b 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1085,6 +1085,38 @@ static pte_t cpa_pte(enum pgtable_level level, unsigned long pfn, pgprot_t prot)
 	return pfn_pte(pfn, prot);
 }
 
+static pgprot_t cpa_req_prot(const struct cpa_data *cpa,
+			     const struct cpa_leaf *leaf)
+{
+	return __pgprot((pgprot_val(leaf->prot) & ~pgprot_val(cpa->mask_clr)) |
+			pgprot_val(cpa->mask_set));
+}
+
+static pgprot_t cpa_new_prot(struct cpa_data *cpa, struct cpa_leaf *leaf)
+{
+	pgprot_t prot = cpa_req_prot(cpa, leaf);
+	enum pgtable_level level = leaf->level;
+	unsigned long size = leaf->size;
+	unsigned long addr = leaf->addr;
+	pgprot_t old_prot = leaf->prot;
+	unsigned long pfn = leaf->pfn;
+	int warnlvl = CPA_PROTECT;
+	unsigned long lpsize = 0;
+	unsigned long numpages;
+
+	numpages = size >> PAGE_SHIFT;
+
+	if (level != PGTABLE_LEVEL_PTE) {
+		warnlvl = CPA_DETECT;
+		lpsize = size;
+	}
+
+	/* A PTE hands in lpsize = 0 to enforce the protection mechanism */
+	prot = static_protections(prot, addr, pfn, numpages, lpsize, warnlvl);
+
+	return verify_rwx(cpa, old_prot, prot, addr, pfn, numpages);
+}
+
 static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 {
 	unsigned long address = __cpa_addr(cpa, cpa->curpage);
@@ -1114,9 +1146,7 @@ static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 	if (numpages < cpa->numpages)
 		cpa->numpages = numpages;
 
-	req_prot = old_prot;
-	pgprot_val(req_prot) &= ~pgprot_val(cpa->mask_clr);
-	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
+	req_prot = cpa_req_prot(cpa, leaf);
 
 	/*
 	 * old_pfn points to the large page base pfn. So we need to add the
@@ -1148,11 +1178,7 @@ static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 	 * Check whether the requested pgprot is conflicting with a static
 	 * protection requirement in the large page.
 	 */
-	new_prot = static_protections(req_prot, lpaddr, old_pfn, numpages,
-				      psize, CPA_DETECT);
-
-	new_prot = verify_rwx(cpa, old_prot, new_prot, lpaddr, old_pfn,
-			      numpages);
+	new_prot = cpa_new_prot(cpa, leaf);
 
 	/*
 	 * If there is a conflict, split the large page.
@@ -1873,20 +1899,12 @@ static int __change_page_attr(struct cpa_data *cpa)
 
 	if (leaf.level == PGTABLE_LEVEL_PTE) {
 		pte_t old_pte = *leaf.kpte;
-		pgprot_t old_prot = leaf.prot;
-		pgprot_t new_prot = leaf.prot;
+		pgprot_t new_prot;
 		unsigned long pfn = leaf.pfn;
 		pte_t new_pte;
 
-		pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
-		pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
-
 		cpa_inc_pte_install();
-		/* Hand in lpsize = 0 to enforce the protection mechanism */
-		new_prot = static_protections(new_prot, address, pfn, 1, 0,
-					      CPA_PROTECT);
-
-		new_prot = verify_rwx(cpa, old_prot, new_prot, address, pfn, 1);
+		new_prot = cpa_new_prot(cpa, &leaf);
 
 		/*
 		 * We need to keep the pfn from the existing PTE,

-- 
2.53.0


