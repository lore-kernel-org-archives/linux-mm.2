Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26C5C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914A56B00B7; Mon, 14 Sep 2026 08:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8156B00B8; Mon, 14 Sep 2026 08:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D7C6B00BA; Mon, 14 Sep 2026 08:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4826B00B7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E10061403D1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:05 +0000 (UTC)
X-FDA: 85212305010.11.4C977F9
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1320E2000F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vaoZxFPW;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5oYm7RYYh/0ZcOga2k+AH+M9SDlDq5X2FtnYEwZCu18=;
	b=K4aPSp22xtNT/Kwu1p21FbO8OzQnuJtKU1uUsKGQAHRJsmlL/6OSJNH0PajfrRcWxMzw1Q
	Wq0pJL7ax31kqU5ByZejKdFV5sti72RGZih+UHZceKkJ8qkG4cfTuf6x8yenscjrY58OAU
	CokBARkuakykK8J/yIgwVyUpGT3WXGY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vaoZxFPW;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389124;
	b=u7evazvU7wR1eOb6KWak6FC0Nd2D64dtCNaGvUyXwg3/NGmlsU7M3AFMXlIrOGAaQP4iUN
	uVN5Oy4C+DWTHIJEQ9V0nuEV6Hokeu7V/VETmifkvde6JiqHWXj1Yq8Dqdrz2UQocgN7uY
	6jwl9DSaHbJFy2VkYQ+4UXW8GmI5EDg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m4azhIZnpKty8kdqDwfR1PkRU+4t+lf/1EC6ZF7XDMc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389122; v=1; x=1789993922;
 b=vaoZxFPW58NPBJERz2EtXd8Al5/rqFijluUw/VJzxskhpxXUGAe78j2sv/XZQ7C82EzGmoua
 eZIy1wkcm4ZxlTkQZCfbeF7ePnxsHNDm7mafdx3sWC6lhz+mM2V+IY5KIAJAdr3PvPac1nkubds
 7++FO+sjhjO6hslgFPDZAsQk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 25c92a897014d0e5;
	Mon, 14 Sep 2026 12:32:02 +0000
X-Mizu-Trace-ID: 25c92a897014d0e5
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
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
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 23/29] mm/khugepaged: treat PMD swap entries as mapped THPs
Date: Mon, 14 Sep 2026 05:28:13 -0700
Message-ID: <20260914122950.3283997-24-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1320E2000F
X-Stat-Signature: akbh574sm5cg6pktiw4wn86n5314a6jk
X-Rspam-User: 
X-HE-Tag: 1789389123-24174
X-HE-Meta: U2FsdGVkX1+/ELHUQGMA2h+J+lDBy9/q69WzWn9Nbih0GXyR6wixJJBWx2Jpxd+CUKG4NMQhPEegAfXDUp3EBB8cJlm4coOWY2PY25DPdjqYZMr+pKo89s9qWsPyFHXiU6Rr823xViaRfy2PsiR/htuae4tQ43MYlmgVq0f4bUl+35OsOolRIFcDcw9QU3nfc43eSYtjw/Fj4+kOZUfd6sr1dQ8f2zTipvx6VDFs56eTnh5tkCzDApgk4MUlCWsXVy7oqJNDKOX5eUnyU8f16463fXMsSbxp8ptIKodgtK7gRq5tiFKEEwHjwmwAhLrHHvF00deT9vUcRY0Mv0yEQkq8sv0o8ctTBDqVi6NOwbsH8MBKiOyP2I/4ydq3+wu7MVPkcI6r1scEp8lu7ZEoY0q3u/hx1nugLu104yrOrbBaRQTN5LugyKShs4kptd7snOH+YDNrwPyJ22AhQKPWkRfKxZUuMKkLhtCP9ltOfoMLksGjT5mgAV+6eF/nKggFjOViiMS8vAuygC9OGE1e3xtEPhkf8E0eDM5N7LOzscAItmdHWsnWAnbFb/0FGrujHa1oLsFysE3jbw9uoPFsmk+FqmPy1e3+wDEeQSHNKs4ZDrz1BlCXGR9A6Khw4WuVteI392LeNI7p0Ehl6zpv1t2zOneQpf1Yg+L13cnfa0uDLZquxiSY1b98PZdYxB9GoMi+AxKmdHc+lc3dmQr1vMK/IYvlvVDhdbXULOGDe0GbsSiqjUKbZwPAZ6xtMdmAFGyi+zm/oiUUf9Fr+sBsdpi4VDxQ3499RKFPNJ779fTushCJFP6tlh/d+EosVkvvykbxVaeUiv7CXg4ReZfYz5hSUDYGNMMzVSSWRNyWbi93I4BjE3s+QaNDAufsiAGTtdqPAfaFo/dEEyH+d4/lZWCjuHapeeSHfR4tJVPvlxsralkNfVXT7GD0UmQbVRHlwsAT52GnKE7ecI47Rxo
 oq2AoP8W
 mM90NojqNS5G/PjSL657BGlZCT1i3U6WR8x+YAaZiUEPR/MPxEdz27EJXdT+Oq3CaLvyl4K5dYx8+iQaX9nxeu8XVnvSyL4DKI9xB0WFLCL3z70nAGNeg61QmXxPyI6GGBBtBMFlJlJW4N8Bq8kwFD1mJ6+Je2SO/Ru2YxIcviCLKfPIiglZ8CkGeVUKwxi4ejxrvRIfWeAM1SObf4Oappw/dgE+AiJOTze9Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_pmd_state() would report a PMD swap entry as SCAN_NO_PTE_TABLE - it
is not present and, on x86, is also pmd_bad(). The range is already a THP;
it just happens to be on disk.

Return SCAN_PMD_MAPPED next to the existing migration-entry case and before
the pmd_present() and pmd_bad() tests.

This does change MADV_COLLAPSE. Today a swapped-out THP is HPAGE_PMD_NR PTE
swap entries and MADV_COLLAPSE, which ignores khugepaged_max_ptes_swap,
swaps them all in. With a PMD swap entry it reports SCAN_PMD_MAPPED, which
madvise_collapse() counts as success, so the call returns 0 without making
the range resident. It still faults back in as a whole THP on first touch;
only the point at which the I/O happens moves.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/khugepaged.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0d8cd44b14c57..bbbf96c616295 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1052,6 +1052,12 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
 	 */
 	if (pmd_is_migration_entry(pmde))
 		return SCAN_PMD_MAPPED;
+	/*
+	 * A PMD-mapped THP that has been swapped out is still a THP from
+	 * khugepaged's perspective; treat it like a present huge PMD.
+	 */
+	if (pmd_is_swap_entry(pmde))
+		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
 		return SCAN_NO_PTE_TABLE;
 	if (pmd_trans_huge(pmde))
-- 
2.53.0-Meta


