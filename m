Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9D6D2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 22:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F866B02F3; Mon, 19 Jan 2026 17:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46DF46B02FB; Mon, 19 Jan 2026 17:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A41C6B02FC; Mon, 19 Jan 2026 17:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25CEA6B02F3
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 17:07:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6EBF1602BE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:07:22 +0000 (UTC)
X-FDA: 84350100324.23.F5F46F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 43A382000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:07:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kJSJA0Ye;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768860441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiDleIKjdzUx+LVLbBFSBxN3hIW5+M/VGmR8Vdt6RDg=;
	b=QNazepTNn4XcOyVmUsP601y9SPWqFJJJaoaKezgOsO8PJaYCcA77FC3C76AvQVXnveWusm
	1hRrIewIh1tNzb3EZkIyrdJcZCyHSl9tDsZrjmcYzaODp2LGHJyaWlnYOWBW57SM4LyBRg
	VyrssDQvHPZnL7I1/2gfyIMjR7oBsi8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kJSJA0Ye;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768860441; a=rsa-sha256;
	cv=none;
	b=RIveh53lV+R1wsBiWtcgkZnxvoiWnxDD+5zBM4dVXupR/P3AxWInYNmGocJb9RXhUpoHRE
	jCIr0oDkYZny+t80BB0t7Q4EI+WbJGfkPGN/JMD2CjwTtTW/qK70iqVSzSe20wX8HZivcS
	18McTwcCf+vykLR37STZT7gaO9DCSsY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6809444458;
	Mon, 19 Jan 2026 22:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59401C116C6;
	Mon, 19 Jan 2026 22:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768860440;
	bh=Uz+rgdCACY4xIfDsBJdwJG1Wp19Ieqw85OkYIQtZgKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJSJA0Yex7DNtH457O8X0WqNKsu9ixkcZRM/TTyY4EYQV8NQUNuD4KbD2p9teGs6q
	 d6zn4/v7fCR3N30JmDUlvQAoPdRhzWAr3MUhVV29GSCsI3wSKqhe7Gt56UIAJUEnDB
	 LBBXRpjcYEY2sIz8agcCU5MittvsbydGbHOuHt7kl3NzlEQwj47lukZLwK3/UZLLQv
	 JcEG+KeuJCx2k1mMTADQ61A/ZJcBfKA/QdA8pa2+Z4P9tqBDab8J1AZRx8s/x8ARsw
	 +rc+7Cqs5rCU6MjaI25AqwZmETUFiCZePv3rXlZNU+FrLPTIOi4Ese/gE+sdsMnOoK
	 M05bKsRL3WFpw==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: [PATCH v1 2/2] mm/memory: handle non-split locks correctly in zap_empty_pte_table()
Date: Mon, 19 Jan 2026 23:07:08 +0100
Message-ID: <20260119220708.3438514-3-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119220708.3438514-1-david@kernel.org>
References: <20260119220708.3438514-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nh4euc99dkh6gx5ek4bkgakxjemnuft4
X-Rspam-User: 
X-Rspamd-Queue-Id: 43A382000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1768860441-695650
X-HE-Meta: U2FsdGVkX18Pzca166dII0Gh6N1G7aLlMoZVXNaD/SpCiYCXE391Sng+wVJIC7kOaZP0gAnALNHiOZXY/d2OFYF6ApJrEOAOPnS4yxH7kli8Tc2mMxJUt47amZcoL4agvnjGA2FSnxL7cZXNaL6pAnNffMSmj6uxeLHSG30VaXVR2vPl3KbfHKwoDOl4yIvzQk/JD4/kd2qpsRs3sIWa2zWN+tyWu4cmv1e3yiqA7Ql1ZEL7luw8wPkTa9vOY98ViW+wQxmU334iK1Ns/ne2nSot83j+pp0cYZoZsVaC703ZOKCAYtUizFu4nXnB1arlFaFOmwdypjb2wcgpDbQ776a1K1soGFv/bWRtYWOBERXzJCIvjc420SKCUKMrGNaXUwXt2B2getmBQ7Q9rQvYADUTVdOtUDx12CQdZOCmT+Y2OUa8tRSCzC6qBv58mWoUCpX1twxUalvS4VOmjqA8jC1xbUYlgqKi+S8snCwkgfWk3W8qHllJ5zpfYkATcrBMsX/F0IwvSdD0/A3bi5Yx+OXQ8vou2ROBwipkNC65GGKDk9E3Ws6JkZYXWLnGYbgOGAARGvGq//uIc4x8QP79Z7UvehnXbwW+LDx6bA6fR1oATYbTuG7blPXcvXuDfttyEO0OmMqkMkuHitvvGaIrLMem5m8SS1KX6DPhWIvvcCEn5h67M3fgtJXpeIYs3msR0gAjnlyCx5aFX+UVRgbF3BfuM2ytAv2FU2e+Bw5rxaov/2fqrIYjWTCmvwNSqDk9/CaHvs2Xc57tB2+B6P8pI5thQ5onQC2Mn0lDuCC10f06CVF070+kiUtTsOBVsz0mlJUP2cZ6ym0qVbFEctQHrJnfDAPmsWF+zHrHaUVC+FxOG7JG3aF63Eg7AEJ8xPemaGS/GzBLRE/lA8xUFOVABkAPiVk6MKxWBvxPtxBBnjnbz+UyJmOuuwqYIJgm/g+jXBxFf1H2TXqYXeHtqit
 4+nZyvz6
 dmXqsG9UgA6UuWA1h/j0tNCNrOsQAS7mGaVGg5EV7C5V3riLlYxjS5UAU0p3Dv/6iOO6fULYKYvfcuL0NH4qlnG9rYT6O0dyKafBvTz8yobrZ7GP7OX526BT27lNerB+2DD8Nsl63z0UM5GQHwSerwA0oN1Bb/bnKXQKSQDrp7+JPlFEqvUSs/4/MlmOL3WmtWhwpUc99SDapHLl/7xEskBYq0oFFJ7H/ZYyIaSIBnvk71XqAlu/RiTzhYAjRDEvt837lrgtigxuoj2d3Ixtvw9134pNRKSRrJEBB6EglaKESGDhbkhZ0PO3LNFzsSxbZwJVb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While we handle pte_lockptr() == pmd_lockptr() correctly in
zap_pte_table_if_empty(), we don't handle it in zap_empty_pte_table(),
making the spin_trylock() always fail and forcing us onto the slow path.

So let's handle the scenario where pte_lockptr() == pmd_lockptr()
better, which can only happen if CONFIG_SPLIT_PTE_PTLOCKS is not set.

This is only relevant once we unlock CONFIG_PT_RECLAIM on architectures
that are not x86-64.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/memory.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c3055b2577c27..3852075ea62d4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1833,16 +1833,18 @@ static bool pte_table_reclaim_possible(unsigned long start, unsigned long end,
 	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
 }
 
-static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
+static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd,
+		spinlock_t *ptl, pmd_t *pmdval)
 {
 	spinlock_t *pml = pmd_lockptr(mm, pmd);
 
-	if (!spin_trylock(pml))
+	if (ptl != pml && !spin_trylock(pml))
 		return false;
 
 	*pmdval = pmdp_get(pmd);
 	pmd_clear(pmd);
-	spin_unlock(pml);
+	if (ptl != pml)
+		spin_unlock(pml);
 	return true;
 }
 
@@ -1934,7 +1936,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	 * from being repopulated by another thread.
 	 */
 	if (can_reclaim_pt && direct_reclaim && addr == end)
-		direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
+		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
 
 	add_mm_rss_vec(mm, rss);
 	lazy_mmu_mode_disable();
-- 
2.52.0


