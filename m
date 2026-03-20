Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5631A1099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C205A6B00A8; Fri, 20 Mar 2026 14:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6CA6B00A9; Fri, 20 Mar 2026 14:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5D16B00AC; Fri, 20 Mar 2026 14:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 856B16B00A8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5723FC17CD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:52 +0000 (UTC)
X-FDA: 84567224784.15.7AE8E07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B56CC40014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4BPbH29;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtAFQV6tlkJrYDQFYJhkflgW0qCBQvoTzsYZsVp4QTI=;
	b=osDt431RSfGIiWnM0d2fJInex6tmxyVvCvm0agVD6ffB9Qn43//GzvOA41Gu5iHBijm2a5
	0tTwMhaCyVvgH7iLekhFSRXxhXJ7/oMbMCyuy9XvMfOkXJ1H/mJcssUEm9iOT7DUSRvRBY
	7eGyCOEEVDf7tk2emtcHGuEmmp2jORE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030070; a=rsa-sha256;
	cv=none;
	b=nUVmhi3aPht3tfnyLJPpKmMdpj6gSIBV/iETK8rQrzWp8/3MqtQozFn+U3Wk1NQPbRg8zb
	gCmcLEtKnZ+o+mJ1aciVxTc3ftqB3r9H2eL4vZ8FlvzZS4lj7gXNs/AMyaHhE1OhNBLL0i
	wogNaM/sgm5Np7sP6nQn2N71LVcSL0o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4BPbH29;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4564060128;
	Fri, 20 Mar 2026 18:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCBAC2BCAF;
	Fri, 20 Mar 2026 18:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030070;
	bh=T6ecK45s9Uwsgz6Ib7sYknOiCaTzzdT93VdENnaa6Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4BPbH29BVr91MzEuSzgIx6CdXy4kih1RxRTEx5sa0mOh3zp+4OiXv3XaegdadVPx
	 V5N4CNgx/H7wmHm7GW0Zoklg2FEbEwwNipTe5TFxfa2U5zguUNQ4HoGK045B1ovHa7
	 SoVaD7InCps6sRdcPgB7vQJCOKkpKQxSG2uDO2qG3ZGlwnlEf35/yx+kiIVGG28uG7
	 uh/fo/k2BaWuOi7W4077ogPlVVMrWSK+9gSuNoRlv98dIx2LGZcYzQNxNDQnfOdJm0
	 BVSexAWDwkIdfyQzhpP9bT5oYRf5T4nY1YC7wuILcRjSnBluxAsLLh534poxGCqJDK
	 MfGrawTbPgGUA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/13] mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
Date: Fri, 20 Mar 2026 18:07:23 +0000
Message-ID: <f3fa8eb4634ccb2e78209f570cc1a769a02ce93e.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B56CC40014
X-Stat-Signature: r5g8wkim315839bt58wehqsso1gbbd83
X-Rspam-User: 
X-HE-Tag: 1774030070-587614
X-HE-Meta: U2FsdGVkX19Riy1zrKIqD6JJRO6+AsnUiM5TWsyHFfgPply+WtCF+h1G/YYQnfaan7RhbNCGyMK5teEzy4Qk5WfTiIWZJVL/ZBLUZVKWSeRee/cpR8Bpzgcw5EGXDFt8UlEljVp8jfkqSkVJBjH8HJe+BFvYD+deNXdGrobqU/iogBnflTr/anupF9DUThrcFrrQ6b4varJKwPW5jLPsZ9WMp71witf/O8+ILZePJwWOFhDXg1r647Q6Odo1oOqvNDCiZZf8/+i7XGyiflKMGRdde2t9UF3rsoq51UHN4/0HWYASDop+pYr4It2a3pioSNILWgluDmc4FUwe1Xl+/F+Q8EvB3mG1jrJPTtUzOA5CHUedA5jWtNkUykhzo7Ixv0EG2exBv+vZo+LBKRR4yzESL/HyCB134u1BOng4kCK5hyDtuqmX8wCuCyaPRs8S733ntPhU6lZ7Cx4Ya/MCjLnSqKSbEBKpg77sGaMEoQEA5SyuTiah4skcDBdpN+YPrxzminPqmwCupiyYrdMFFgikdHslBaY+HM0EEY5WiLA6ogIkwsDY1ZchM6t3qVzsEGL8+3qiY1oVu7O4Y98C0vrnbhsxBSHm6fNC/1NZ51UvA9cy9mUCT1kUsQ1szxqntZs9z4lNonG/auU7ahFfkbb3FxEKEhQ+lqGlGfQ2PdKXLRrpGE85rUdCdKAtmJLM4eTiwHdqfre5bzncO8g+UGPIW4P5JUnXzaMZt6nT6MPuKnGQByMths/dOi3KThevjLh690i6dqkqG5w49YcFu5Gz0Bn7P+RhkcE+Tqg0bzng02Cbs7RONX0fau3l+RbmNEld6b17SBAz6t8ZZqIfSKkmtDHYOYvhoRhveKIYsfBAC3vxObP910xy55Q0TCnxGX8cRq/RN4FgfZNS+bqBOjUNKResEEYKxYmq6X1y0LY185j6y5OJf6KDmembDt56hY1+E/ksOPExeRe2CCB
 +HZx6uWr
 TokBg1hTUy9MX9lqJS/Jf8hCUCkTYyo+fRXWvWmt94JsMnT7ZXeOYIoOPhyX5v17nf9QuUcVDHHEnwJkfWtpoAwnpns/iG5DF6rmj1VwXZ3POC62iIH6cV9q0EdmGHLFVVTN6O5iJjONsFc1qW+GXh8R6NGb7dRxKTARTSfIUpfvpJI/6RR86H3bw/6iYKwzDNr01V5aFEalIvqN8xZefj/ljvvcxqVS4Z+5S2gZV0kJ5UuOK52afjCWoEwBlMmWII71R1jx0Vmlo1OQSBrmqeyIlSQ4CFGm7NodMY/s6EADHgTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This has been around since the beginnings of the THP implementation.  I
think we can safely assume that, if we have a THP folio, it will have a
head page.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b9d9acfef147..4add863cd18f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2375,7 +2375,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		folio = page_folio(page);
 		folio_remove_rmap_pmd(folio, page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
-		VM_BUG_ON_PAGE(!PageHead(page), page);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
-- 
2.53.0


