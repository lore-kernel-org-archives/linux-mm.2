Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294C9606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dcA/LQZJ
Received: by kanga.kvack.org (Postfix)
	id 4F4F36B05E1; Thu, 26 Nov 2026 06:18:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC576B05E2; Thu, 26 Nov 2026 06:18:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E20C6B05E3; Thu, 26 Nov 2026 06:18:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC5826B05E1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:18:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A69F403DB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:24 +0000 (UTC)
X-FDA: 85477021728.04.E1F6BEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CAFF41C000E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dcA/LQZJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691903;
	b=eL+bAYq+6ucxVFhBbKWp7xnMzm+nJyihu8YgRMbdq+Qh7L8t6rnjJZUdG9lTI31wuugIn5
	Q2ogZb4Gmpz+2CvjgmqyUeeSARdrZDKLzHtvRfdnAME2FZI6rc1tHOgVGh1d3j38GNgKSM
	s3ZUcs07o6y86keEz48tCt/rRu2C/2A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZILZfKisda6VydMd2eX+gp7jxSdYsZR8fHOcYz6Cqew=;
	b=s5dd0K5NYptFYymSiHZLmJkkCsy2FvTINbcd5L1pa3r+EtG7HXYSP5pTyRULY4sITNiEOX
	sCoB6zW1Wz9qwnTqbNdA1finFZstr+g0RiBZ8Z7ZpIUEEvHiRFP50xmDP3yspkbMxj7JqN
	0tdzVaUg1wG93yMU7P83fAh1aTxv5FM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dcA/LQZJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FB18433ED;
	Thu, 26 Nov 2026 11:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612A11F000EB;
	Thu, 26 Nov 2026 11:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691901;
	bh=ZILZfKisda6VydMd2eX+gp7jxSdYsZR8fHOcYz6Cqew=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dcA/LQZJNTRxAXYiSO3ecetRk8UeUJ6G6eowyblPb3SceghWJPlB47dy81dO3ekpo
	 8zDVpbCPPwxS+gP2aWUtngwOLnVGrkWp3lbRZc00nMGGvENyrC+LUZsSkDTGn2a/Df
	 Ykat0AJi7F5ysyrmoP735e9b3JtJOJkyBZb/r31kMWVXdrscOhgdsETzfdXnYLy3Oa
	 9MLDBL0FuPwbh5GLhPshgP2x2ZO3LV6BIDUNOwy6XdbqpNWoRFGlguk+SsxHNgl76s
	 ing/lUECgznOONlhV/K97ITTVUhM1RAQes1Mo/It0ScWnHTtRza5jJ7IGIDCXcwDNm
	 NDSCBoaFdVjlw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:37 +0200
Subject: [PATCH RFC v2 24/54] x86/mm/pat: detect unchanged mappings by
 comparing protections
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-24-723f1e33c3d8@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CAFF41C000E
X-Stat-Signature: 3hhps88dndkmh47xc4u41pieafhnrgq9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795691902-131366
X-HE-Meta: U2FsdGVkX19K6501nGpMhwIuJ1xxyw06Mg63wRRdI+uTjkKgwTvojMBNmZcHL93/r80LdjCjH/BhcwgRf40/e563boL9FdrydKv5oeD+5wvYZV34IIURZTJMGOvxBRSQHp8P8GmnPhRyDnbdxuhd/+vHaMIsdioq3Sis/5icU+ARTpJpqmBNHpXXFQKBprALQl/DHCdKQPpzwsrOYm5dCkedRYWTcbYRfiNjX+54hHHv2DHzhEuVC2RvGYeFu6JzbFGbTWr4Iz1ZQQN/TxjR/AGzZsEWwUFsa54DASfgMUK6ja7nw25+02gyUxV0ehF4/ei5kMZHnaycdw8DPP36AdYuQcyAK2JVdZjgIJmQotOc87bluMBY+9DDryND1wSzXoKhmssRMKYW5ML/CoeQbdLfJlTTE9PZDghwUYptHOMHjsd6o93tE7sLKz7gcYakCn9TabHtGA//IK0+ix7XNwurmIaDM8vYcK8i6QI467Oatuh4YUExJSAhNg5FiLbovvKmjkG9dUxKMkUWFz9LbFPu6kieoW8btPOf7jBnjOx4yMFU48Rnf4rgYn8ztnx+knLAy7VS0rZptIG7O61o2DmOxV3EtxNItF1nkqYM88NJcn6Hzxqw+Prq54onHXZv6CjUHGDQyEBp2R8M0jRf/n76EMluvUjDODEIoTy4BSjaORpqSmXIjdgPYTuqryN+WY6MKB2KUgcBrFtaPOJ1DhmisuD/qt1uod1+bXumxIOM45qu4xgwMTh7Ud/XPXtjg1qJR7eaRSOmT7/e+Zq8EpNcTP3WcSrHeuolufZR9hVbOrzi2kR4lsAziLLzF3prITnGUBOyrUgZtpON1NwT8jPuq9jgbmVoi33/eWAcMBV0H1nQAcPwFfT2ZV6AvStPpvN5TVDMyMi1MiOAkUmjPfrNbGYZ06GFaphLTtxwkZBOzuwkSMWXl3b9N/Cc0Z4RbiD0UsvehOC5DI7pL23
 ihxjXOfP
 vG8KfpmEcsO/TEzNVZpT768xyluTx5wBQbqCJyCN8+jxPnUiweBw2UT3QDyNsuBkPWgDClvIlGV8lVu6wpG1jm88uhijktZe3qMKdTxjwbK3Vc4pGCmhD0RF/pidEzyyQ1ZNyxGU+fiLHuimQg2K2Xc86PKpVczPsQlZ7rI/Y5NNpzOF+OnrExKjjJKXeL9gOq9ZmjfHZMrR4BBKPVxnA/KrVGujIVm2j5Y6BhMGSFnv6at7JQddHRF6WqpYb7qmOBO2cmpN5ERzgsJxIOoNwNS7nJAXSsKxa7jf/xXHreymIvQyUm41VIPgLcLuSjyEdSMb/N0GCdU8Dz2OqQUmYnnIVA3RD7s8U/Amy2SwJ44Xbww8wL9pmswwGuAd3FIjNg4801h4k+lNZCPDTgc8dHrRlnV1MRG8c3sTHulCG+xP9Yu+HLyj4+NSlF702QZ81S/Hc9DEJAFzYENBrUSiU1SMKtGFWUyTE5tJj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CPA decides whether a mapping changes by encoding the new page table entry
and comparing it with the existing one.

It would be suboptimal to encode actual entries in the generic code for
every comparison of the existing, requested and new protections, as every
architecture would need one more out-of-line hook for it.

cpa_leaf by definition has the decoded protection which can be used in
comparisons.

Compare the new protection with the decoded one and encode only the page
table entries that are written, as the last step.

Encoding masks out the bits the CPU does not support and _PAGE_GLOBAL bit
of a non-present entry, comparing protections does not. set_memory_global()
on a CPU without PGE or on a non-present page now rewrites the PTEs with
the same value and flushes the TLB. Its only caller changes the kernel
text, which is always present, once at boot.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 0a2d19064f23..f4d3e2d9c3c9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1917,26 +1917,18 @@ static int __change_page_attr(struct cpa_data *cpa)
 		return __cpa_process_fault(cpa, address);
 
 	if (leaf.level == PGTABLE_LEVEL_PTE) {
-		pte_t old_pte = *leaf.kpte;
 		pgprot_t new_prot;
 		unsigned long pfn = leaf.pfn;
-		pte_t new_pte;
 
 		cpa_inc_pte_install();
 		new_prot = cpa_new_prot(cpa, &leaf);
-
-		/*
-		 * We need to keep the pfn from the existing PTE,
-		 * after all we're only going to change its attributes
-		 * not the memory it points to
-		 */
-		new_pte = cpa_pte(leaf.level, pfn, new_prot);
 		cpa->pfn = pfn;
 		/*
 		 * Do we really change anything ?
 		 */
-		if (pte_val(old_pte) != pte_val(new_pte)) {
-			set_pte_atomic(leaf.kpte, new_pte);
+		if (pgprot_val(new_prot) != pgprot_val(leaf.prot)) {
+			set_pte_atomic(leaf.kpte,
+				       cpa_pte(leaf.level, pfn, new_prot));
 			cpa->state |= CPA_ST_FLUSHTLB;
 		}
 		cpa->numpages = 1;

-- 
2.53.0


