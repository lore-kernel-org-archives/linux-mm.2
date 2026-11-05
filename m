Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D59D606A33D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i2tPQtNY
Received: by kanga.kvack.org (Postfix)
	id 471426B05BA; Thu,  5 Nov 2026 13:40:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4482D6B05BB; Thu,  5 Nov 2026 13:40:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385656B05BC; Thu,  5 Nov 2026 13:40:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 155246B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:40:14 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DCF940C36
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:13 +0000 (UTC)
X-FDA: 85401930306.03.0F418E8
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	by imf29.hostedemail.com (Postfix) with ESMTP id B3BEB120009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i2tPQtNY;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1LeOnb9CDFOnmMEzFnVdGeJ3OTcUQn2u1YwjX7C1y8=;
	b=cwIz3ydNkP06VGq9bOzbu7GYc0f+3631KymKBTBinXUBqNj8hJ8sV/jmpdW22gtbWqm1k2
	Ol5DbndhUO6ARg0RMc/GVsdtbw3doQwMj8EqaATGiA1umnNBDGmE6J/MhQtOhDS1sZ4jdP
	454zVRIUAxrEQ4Qq5oMoloM0v/AsVi8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i2tPQtNY;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904012;
	b=W/gmuQqynHwxol5rNqpzv6/6/l2Jw/HaF3E5Mr2V/8ThDnaALQrdPYNWeRHsQ9Eey+59tG
	rS0E4F7KTLGVhco96bKsY9zb9kVNuW+nd5bAP6Aw0VAjD6hIXIjvXhmBzkr9HtbOlxP4ni
	nRJXqDIrbXYmy+RSsq2n+s/PN4aXYMw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XHwomVe1Ix4OLLbQmSLS20ZMN+cx9WZ34HyiAIQySOU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904010; v=1; x=1794508810;
 b=i2tPQtNYYNLf4YXmZJg4/0AUKJ/Iap0x5UW1xMY8nrEteDXPuX5kXsQkBjIb8zj9gvMQYBYW
 b+Hc8mStA9CAVe5QQo/IjE66PSTEmRwY5n0W+5LzZYaIoQ6umqSeuXSrjC3w7CNreY64+aOSyxh
 O8NAbTlqAqgoSnXtv6AeYPS8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id e0c6df93f7b2e87a;
	Thu, 05 Nov 2026 18:40:09 +0000
X-Mizu-Trace-ID: e0c6df93f7b2e87a
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v9 04/32] powerpc: mm: add PMD swap-exclusive helpers
Date: Thu,  5 Nov 2026 10:38:48 -0800
Message-ID: <20261105183940.2236717-5-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ndk74cds973s75m7ujuwqkqf8f9w4uij
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	T_SPF_TEMPERROR,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: B3BEB120009
X-HE-Tag: 1793904011-152560
X-HE-Meta: U2FsdGVkX1+kKyltdjfAWfRA4QniePTzb62Ypxrbav1NKYBkvij4q12wGumAjdmg0pm2kUY9gGGE156p0UCqmIC1wynYFAmnqhbZCDbQsO+C0OKFFbQWaJl7Eq0uIWb//gESDRoxC2dVasqMXavfhIMQUoh15/fGJ8I5RIH4ht4J0g//CPXgG2PZ5lYfOBl7niFhh1qINDbNMSK9o0g4Un9dFuB9l0nJRD7UWPYyE71r9yZBddhw2dO1FafyW0ZKrFXuALdKER+GjSW/KgpoZoAiVZN1RaF1L0TcfAtlEWroie9qCI5ZglJhzTswRvv5pmI6At8XykIWivvCcxgTrWsAOMUCDh6XBPL2K6VATCFSFIMzgyq1k/g/4KWjE7gGuyYMUc14dnwkHFxmXGVK0EYlg/+4qa1bD9fiGUv02JfQXW8XA1bTXSqwBigCUrslzx4YfxbHtM5jrljvRX1WXK4jFD044mvb7iYXazGdnkqV8i9AqY50h/KYXQnYcFJMQG88SoAdgGKtMoOCGvbPIA8YOgBhch3OHh0COaAa6subQ1WZOyykL1ca6xB2Zj1xhBDsroQiuiMbRLcTcZomEkudVxi5qS31LuD+Ku30e7l/LxwnOHr+wL4yuf3hZtKxaLILXEa7UNKi89dJE37w8mP0YzK3iGgr7H3hrDQa7LsYbj/09Ngf4DRntKxgriNl9JgUlfZDkCtCMwYYlwIsB32Vyu8F7um1gZl0+KSNvZVoNbJrVrrJCUwD32OnBuSZUuRhZei24kYMif5p+38k+ad70sxxO1rrVw0M7MNjQjUqsonE2qGGnqtgUC7YvyUQoFu8uomdDSZe2KpJysFRBuf5kFRdCLl1j0WFlwWiF5U5NjXAcGM53IFwFRVRONAu1HypluYC817ko9NSxR5kMAaFqO7aJOAgAfKaydqzXlceLEZQhxtLX8m4WJOV8BFwhAMROlm7Y6I89GHoVNU
 FiI5CK57
 7oLc9eFVy12XnNPlOL7FY/04BpPbxdVY+rM3TNHOvKLI7pYMTFGYv1QInaQP2rgHKLcUtg/PPlPw0YMjKNV5BYuQQQNu4u5oh+BoFnrmb1LkC5nuB9bJhQUI+TcxWOcl1MVjjwe5895VdpcQ9E+aeMLqOqvUDPoNzPj0uZU/Nw90rG3s+BUKP9CZc9jumsivUbHNhYKppKpMpZABImYsRCzl4d49MS98ZzKfWjgRgu1kTFtQ9hTTNFSSU+zx1/Jy5QX3WyKkb28c9aVrr9QRjwMlD5IjVqN7rDg+u+gEaxVHpoiQoL8Am2dHQ8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, which makes PG_anon_exclusive have to survive in a swap
PMD and not just in a swap PTE.

book3s64 builds a swap PMD by running the PTE encoding over pmd_pte(), so
the PMD helpers wrap the PTE ones and reuse _PAGE_SWP_EXCLUSIVE, exactly
as the soft-dirty PMD helpers next to them do. It is also the only powerpc
variant that selects ARCH_HAS_PMD_SOFTLEAVES, via PPC_THP.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index dff8790a047db..458c85cebfa65 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1060,6 +1060,12 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #endif
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
+#define pmd_swp_exclusive(pmd)		pte_swp_exclusive(pmd_pte(pmd))
+#define pmd_swp_clear_exclusive(pmd)	pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
+#endif
+
 #ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pmd_protnone(pmd_t pmd)
 {
-- 
2.53.0-Meta


