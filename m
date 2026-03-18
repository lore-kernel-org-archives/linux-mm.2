Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2192A1077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82AAC6B0326; Wed, 18 Mar 2026 16:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8028B6B0328; Wed, 18 Mar 2026 16:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F356B0329; Wed, 18 Mar 2026 16:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 630666B0326
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18F781BC58
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:18 +0000 (UTC)
X-FDA: 84560351316.04.32B19FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 858ED40009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R66hjQO9;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H38OMml19xGvo8zfUMUNys43HHD6NSpcsL6N7yjB/rM=;
	b=gK3JMrfRDpGiCufKl8oBgV8dz0uLBPKxsCSdRSI6QlQ4umdFGBFW3pr6lCrErwEHmk4Szd
	h+vm+U5/mFQyaYsGf5FQ+qLiu53T0KuR8ZT58WGu1Tb5RWotBZolJb3sLJRoaWaYytA6Vk
	CwczKVl/h7ontMcIWMFFTokRHbeaH0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866416; a=rsa-sha256;
	cv=none;
	b=mwRepIwInWE+np8u8FAsm+X4gAqTTO81P8r9HGrVawTUxdDiMFRUPp6pICRBmBW3YASknQ
	sUwwfuoMRMLrl5vK7jYxZ1l0YAre9cerArfI485tBTCl5LhZvdkpzv60tH1Bn8k0TfBqFe
	BFcJxjIfmO+74nWDqmGyR2T9v797eHM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R66hjQO9;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FC2160103;
	Wed, 18 Mar 2026 20:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563F0C19421;
	Wed, 18 Mar 2026 20:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866415;
	bh=af0POnNSVHYyaB+ZRCwPVvoBRXZ0k7zusmNNNRbS3RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R66hjQO9gPI/+AqeZ9wyB7YmnSLhPg14m/GgYHcdPrKGGWOPEBeYRRAaW8M+mT9FM
	 kRSvynMt0d/CyxlFDyKRzJK6uPAapKi8NjH2skSRO2QjHKXu8dVoLl77TysXPl+c+h
	 9Sw4lz/NdnC89NKj9VCEjDgSqhLypsRE1fxV22l/UbIPPmK3dkCpBZTUNqdRN65cGp
	 A2SJrA0PtZEB0SFjYJDmRQIKBg5Hn3c3KgyPd258Ca+xLffH/nFRSw3ILoDUCLQfru
	 afJ7rEtLQLN4db4HxwFSl7yWuLEeszTPu6gqmHdvSfJwTXkveFAvjEtFynMGSVTXWZ
	 GotTE+OUZj2aw==
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
Date: Wed, 18 Mar 2026 20:39:28 +0000
Message-ID: <56df2cf900132ae12e8b71ed95519b5b476e1618.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773865827.git.ljs@kernel.org>
References: <cover.1773865827.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n8ftos5wjbhgkwuxkzctxhnphmxbxdy9
X-Rspamd-Queue-Id: 858ED40009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773866416-689801
X-HE-Meta: U2FsdGVkX18JdxmNweME7o9r4iFVpNq2TSECcWJAb9YCtgI/zV+4lYUL4Of6t9/BFrBWGbF78xpir6plXmw2V/VvxvYV/D9bbzpnyK9/jDc680kwBYiJ7Hmbfy/qORN2BlvVu19Idxww4K/DbjdYRA6CpVugGaHtb3TzvVm7dYmfHA7PQEPr5RS+HDruuD4pnECpfUVOkieAq1QOipTahWK68HXBRmKha9Yv+oeiT3HLU02N2RvgIznTguJgaFyypKD4kb9aP3kXX6erGlmT2ZCJ32/W42My2+kQbKUF7ziv1oNgzuxSvI5LA9rgSJItfBCpxPo+FQlzGhOLhAczza76p8cWHh8U31/sBE/bHVEu9LBPTkLbPWDgy/REAS1iIcwGImLlTj2cRzK/XJLaMlPjDYG+QxylXhlhl1vikodD6JS0Rbjzuna/iwPi4asXf13tNWBIKbQcIfkESQtnvRNoAeQajH6v1xybbhYGwkdDopiOCQWbnGEoEPUs2lmLjEPZ//Df4uf+xkkhqGx9nmm66Y0LG719v1OhBfv4L4cMVrwPbbLp4XsoEEdXiw+NUQiwBDBYYktnWl80T4ZWiDofTSnEJAFWxZcQL/Eu/PeUsseAu7Kjinxj2xqL2SLdTOE2y3m6y3sBPP/WJgb0l6TUbT90VcMkscCJZgTQYeYNCFAlgvFdHUAC5+yQpGHbpp9UHa3otsxoGFRJtCG1nZDASK4l8iXMztERTzwFQx/7vcpI8y3+7xnvbSf/9USXpKPDBdfUr4oHpkdPm1RS4F6DMG2CIPsEguqFgA3G3mvGxiDtRFTMoF9K38s6ieCnJ2UNB/89P11ohDMfgq3zCJVhogAbTnj0Ibn4oBwebSgn0qRlrnY9X7XrtbG05iPsFuRGF1zWKnvffHDSZSfhx2eRoye7LLhUAAznLN4/kcF2CDx3Z82TSxDOIYKc8mU7A2rpDtHfq4K3y6rp67x
 8IrM89ZB
 j+QCq0yzE48NvM8yDMZe53S0lS3k/LJ/AtqK0nZVDG5UU54NTX2qkcIlWO2HCtS0uU0ZjbjnrsCR2WXn7mT2n1MqPqpeWgzBPmcD6/J7vqSy1nd9bC1lzgofVY1KuK1Lu7oCdtJSt6X1L6W9CJhi7h4Tthxx5rBfhaq8rc9oljuV0xREhatbPV+2B+loJPE16WFQDeI0/Z6z/rgoPqr4Ui763k3KZlDJiDdQV+Dk10yIQAzf+uXUGdV5oQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This has been around since the beginnings of the THP implementation. I
think we can safely assume that, if we have a THP folio, it will have a
head page.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 724e1de74367..015f6d679d26 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2469,7 +2469,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		folio = page_folio(page);
 		folio_remove_rmap_pmd(folio, page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
-		VM_BUG_ON_PAGE(!PageHead(page), page);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
-- 
2.53.0


