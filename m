Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A38C2EDEC01
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 03:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0C46B0088; Tue,  3 Mar 2026 22:19:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D076B0089; Tue,  3 Mar 2026 22:19:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69226B008A; Tue,  3 Mar 2026 22:19:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C075E6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:19:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E987F8B540
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:19:23 +0000 (UTC)
X-FDA: 84506925006.18.7928F96
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	by imf04.hostedemail.com (Postfix) with ESMTP id 43C834000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:19:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=ISFFZiOA;
	spf=pass (imf04.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772594362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KfnvDCmMijENkfP7CLbZ+G9AhpOwRR2K7/fT4/nxWQE=;
	b=0qde43IfqeHLJXMfLznGW3hCK7IGgjVQ1Uasibc0ziV1DlZp3hYAIzAwGLFMbbAlFhXSsL
	vwrw6fziZmH1NBd9SuEtg/I0jusTtL7zT8qU5FJW/ez1Br4pmQhzBHBYTF2hIIlxcStcW8
	dhcag2MJtaUWJaFGqeGsv6W5MVQBlpE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=ISFFZiOA;
	spf=pass (imf04.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772594362; a=rsa-sha256;
	cv=none;
	b=Hv4XUoqPmgDMxVZB/Qv6273/9b4olC+E8xzmXrNabyeR2H5L6SzaXfgtu8zjSRIFRiSpJB
	OxhJqeVuwlr6qgRPqu5purifxj2dwmRZ/ZogJ250hnQdVf4jTq0LnSNX+B/45QCnSSyA/R
	07aS4tJoNvPNYgmLq2XOUP8U/YHiiv4=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 6243FnAK024267;
	Wed, 4 Mar 2026 11:15:49 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4fQd7r1Zdlz2K5B73;
	Wed,  4 Mar 2026 11:14:48 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 4 Mar 2026 11:15:46 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen
	<axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand
	<david@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Qi Zheng
	<zhengqi.arch@bytedance.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCHv2] mm: bail out when the PMD has been set in bloom filter
Date: Wed, 4 Mar 2026 11:15:38 +0800
Message-ID: <20260304031538.1258114-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 6243FnAK024267
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1772594154;
	bh=KfnvDCmMijENkfP7CLbZ+G9AhpOwRR2K7/fT4/nxWQE=;
	h=From:To:Subject:Date;
	b=ISFFZiOAQyTI3Pcoxp/NEOkldDEe7O+2vDWQfM1dVJ8B0Aikkho+l9HEbMswv+Gcy
	 9oEJAQFQ9OMmTq0t/I3okjfAEFGUHAoKFFAbwT02xyyXkz0Fy/hJ6WFMBAnX/0uJOw
	 3x8mAPSU7+smhr+GaocoeguKAN19VQ0D8GdCCog/+xwe2srZaxvftcM7jpaS198UYW
	 oI25DaZAEdFXiRKgZrPzMbhpYdctxkkLjtTxYjvD8z4F/4I93p6dcZrvNzuIbJ1khG
	 zqOkuTvvvkHA56HhhFXTxac76QxIgEFOx2jfPNcd/eiESsxQHEpvolD92uNsccXmTz
	 XWZTpJVf0N2qg==
X-Rspamd-Queue-Id: 43C834000C
X-Rspamd-Server: rspam07
X-Stat-Signature: mkan846wfa1uyynihoi71n41kn1npcs9
X-Rspam-User: 
X-HE-Tag: 1772594358-63054
X-HE-Meta: U2FsdGVkX192oXDsNnXrRkAK4hLL95FTkTJJJy6zpwIKZd8bg6iPgV57l1BA8Fd9LH8IjDo1xv1EZ7RJhFOPgqFD/NA6y/glS8IsXgBphsHYPZC40tdg0qD0Gz5nUr2OLX0emZFedWCeSXLMe+hc/pPDiagKEGBs9nomSAoOv7A+PtMSPVtrj9xcnV807HKxUmEuZhqAwWhrOtUJ0GEdOzrPusT01gJJFW3dK0ZcK2LXK1ApMN+ZZH5alyNJlqmJbMx9Wr2T3zgxaB2NasZ8sSG2VT09FDp/9URBdJ9iNlkRLU1WsXdFtGITqLQ15//Vh86l71+NTzp+0t1soAtS7eu+nqwcmSwh5nfMv3tIG0ehUnma72kkwqgzRuv1zmAjvTYmHk8gBZne+EB92n+8PtwZxCopigCXzPAWvpi+WHoi2XPyAz8G1et1+aeuEvBzhKclG6Lqst+ZwwPs/7O4a+VC1JYxdfyw+SH+Ulzr1vgryjrwUcbsl2mw8/O74CErBLgphCA6KuqkLTF3RKzhg9Ji8sFiJQmm/5xhSFG2p7byP5IlufsguCxIpG3fxL+Bqi3uZ5yrht4yWFnKWs05Q0KUXwu6032g6x47FL1sjPVSjXcq8xyWAO9N8AtDQJ0XnxiMTE1FQbFqm7muNZ9mBDyB7CxAqreYFhmGMsIlFklSwyrsJQ/L3DqO+OEMPwoQbAWsMoQ2hjF2IbAI42SlwaO+PFXln60YkVElLcdG24JyosUOSy2ZnUHv3QzJfkK8/4Nx3VCswz2GA0OpxlWPtPN2sfbcDul9EkyyJv01ZIghi+5AXx7JCswn1gkJ+PJ2CFv/RnXFxUsFlpnw4Uf6Fik3fZ+fEovkiFGB6vZ6o4tBfFQkDo4q1gu008CG8JkeswFgEWYlsoLOamdzD29WMG8/b8JbK1RUkTJPHThOvVSpAevqDXf06NqnWSEYvta0uinFXJ8RRSY16f3hPnS
 wTQPOvc3
 mvO43Owl3FKzbXqLONEmPeY1ecfJ54lJ8d9q1IHbAs+AVbaiADeZqDg45EjyfYSOSEqajFq7mUJc0ZayjLu1j6BX8vJxHJ6tiqrTlDm90sLNUkLuE3uAUDGkoFMuDl3mqetPSOCZ9OJhFEuG/jP6gEF1iic/ud/fRCtnWO4VlEZJ3gHc/bH26WVA0BKSj+OgVwhHyyi4OqPyJBr5rF0DzoZlyz7P2JVGz2LTXZY+oI9blULZh7r/EAdaZpBPCKVKeTWPgr06HajwEdfzlrHsxNBffTtKVbGObqTBA+jWnmuHtG89YnrpfvbHQsmUwvlkdNowC8nJbyONvcBYsPLQLw5g0ze1qrICEbfLhIOZYze+zAkNDMKT1hXVO546r4DddScQ/18D00eqPomi1oBlBPl/q5DfrdHa0p4t7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Part of bloom filter utilization in MGLRU are listed below, in which we
can see that the step '3' will prevent the hot PMD to be carried to new
gen since the new arrived rmap_walk clears the page's young flag.
This commit would like to suggest to query the PMD in bloom filter
before starting the rmap walk to improve this. In terms of the cost,
test_bloom_filter only consume 20~30 instructions in modern processors(25
instructions in ARM64).

1. rmap_walk set suitable PMD in filters[max_seq] while all page's turn
   to be non-young status
   * rmap_walk->lru_gen_look_around->update_bloom_filter(max_seq)
2. young pages gathering on the PMD if it is a hot VM area
3. newly arrived rmap_walk in the same PMD clears page's young which
   are set in step 2
4. walk_mm test the PMD again during aging, which will bring the
   suitable PMD to filters[max_seq+1]
   * walk_mm->walk_pmd_range->test_bloom_fitler->update_bloom_filter(
   walk->seq + 1)

Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
v2: fix null-ptr-ref of mm_state and update commit message
---
---
 mm/vmscan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 10f1e7d716ca..5558a24d1564 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4234,6 +4234,10 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
+	/* may the pmd has been set in bloom filter */
+	if (mm_state && test_bloom_filter(mm_state, max_seq, pvmw->pmd))
+		return true;
+
 	start = max(addr & PMD_MASK, vma->vm_start);
 	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
-- 
2.25.1


