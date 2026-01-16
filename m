Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F59C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF916B0098; Fri, 16 Jan 2026 11:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587F36B009F; Fri, 16 Jan 2026 11:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493BC6B00A1; Fri, 16 Jan 2026 11:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38D4E6B0098
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:27:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1A02AC875
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:27:07 +0000 (UTC)
X-FDA: 84338356494.12.6EF16A2
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3894C180005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:27:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ldoN36fB;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768580826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAf1EpB3RHV5nguc56M5OiGGTGDZlSOZIyII2hjqUoc=;
	b=A8VDBc+qufq+7LBi7/2TCLv+fe5cFVk8b/vD7K77jWbqEsi6vkezgCfP0AFZXw+J/VmkZ4
	t7pKPKDUBnHl0WdHlyChOWXtbsr5Zq0wklj5nrO/WcrpkvoDTQjoZIJZ/d3VabQml5xKio
	23qGKfjoKn08cYhqTVzctKprmyN3QF4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ldoN36fB;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768580826; a=rsa-sha256;
	cv=none;
	b=r2oX1cUNk6NXI5mIM25KadxRz/VaRp/UcVLdi9+Wq7sZTDjILdRBsVVhx7E4GnhIy1Lfhf
	znQlIKF1/VuKWffkBUAT9v07JB9eZ+qVtjC0AOjFmV9dDnWXxozchRIcj72qZM8vs1uLZ2
	EXQ3BY1hMkJJDvURZaRAvwOPUOacfYo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768580821; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=FAf1EpB3RHV5nguc56M5OiGGTGDZlSOZIyII2hjqUoc=;
	b=ldoN36fBHrKj4RJrWIvPSPCav8UvCL0ToHV1D87N8YSwrA/25lgIFtVcuS9id6fBGkhWxGa3khCW9pMmNbrWUOIrGM8/LkzT375S+bJxbe+wgM4ONv5J+/Untql1IrJ4LkeL5ydUrilq10RLn0LLsVLILD3SoJ+Ngx25szDP6H8=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WxAk08M_1768580817 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Jan 2026 00:26:58 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: baolin.wang@linux.alibaba.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@suse.cz,
	will@kernel.org,
	willy@infradead.org
Subject: [PATCH] mm: rmap: skip batched unmapping for UFFD vmas
Date: Sat, 17 Jan 2026 00:26:52 +0800
Message-ID: <20260116162652.176054-1-baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
References: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3894C180005
X-Stat-Signature: qdikxzr1rqhmnf6darhyjhcu976jzd7e
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768580823-388862
X-HE-Meta: U2FsdGVkX19V9RZcPWe6AuJ/jGCZwhvlh9WZExAvUwDLIC4jFSFj2+it8btMAAI8Ub6xOiRRwErm30aveTBoxnbmS2qoMQwmegQ5yL0MTKOnZhbwGnBnhhoX12KUg6Oi3qjQWXTqJ2Dzlv4YpUsdaWCRVqpXSJDL6BgpYTjSBemGk2S/DCX2a7L4U+bdKMk7Ep6hMs3F9jG7ZCYXbVVIKsYK2DtuvU1+IIPW0b7CO66O9jWCZ4WlVhg3XPr1T+V/fDFbdZqBtryEXQ2WrG4G11+l/7fx8RNVY4wl4oD+16sgeqtjOgUt7iIOPTLNQvm1Bp/wD1GCp1liHDgo7ruKNuKtHgJrzhbOIEkjn4JFQATfShUyziqlVpu1kuP6FXP4dSggrGbL6gRqEYp633ztoaRHxzOXbExHKlk9A8IqUyqZ+nqMCs1BVeXLf9e6xjGTJWHC8ZtX6B+uzEDYkzdvnrCytNdvALcpjgtVzJCI1oEOT2kueqlQXgW9PWW6v6iwYGgjT1E0zJQfj/bymOy4/0BcsAIMOz2DM6gDEqiTx1L3+/JEP0StwDw5qzHCEbmIa+o0ebAnJib+qLrhPEaQ+lQ/BY7l/ee92dUg4f6cjGMvlaG7LpYDZ6hSoKEelrTgpX9WKgC77ybN0ylXQPZuUHYXWO5dWJlW7gS0wJ2ld8yIJ8ZnRzz/THa/bn8Xk9sD6GLg1nHX3I+HMAM+rGDuYcxfFjEqbT+HM/By4XAQCzzPEF1i4RNgl6TR8PKBzwsJoRhdtiVrD4tSQqmdLzZp6Lr38UhsMlN9BlR00I86tYUVWjE+bzunLSToGGdaxQRNatwnRKqnbmYVkklL1yf/4sgPV2YDm3C+Tp02lmh13plblF4lsOV3uQXVQJ6wn/kv48gHK+2zUVJ9vnZ0/xPR9nd5VxvNaBhgT0BOL0Nr59kiprGu2jS3F3D8CWi2hOdRWkvfERN+BE02vSOQBq3
 8AWNSS+2
 2dtqhe1VyXdgeSKkF6zGcE0iARMqNLFH33A+8xQLuWvBtUCUA7X2xrS3VXHoSHREx2nv1GqfmiOCaS84IWdt2ieQcrcYtSZnrMiY7tLldRmedNxP+zhGnlQgrfWIRsgmibmeGpiYypbFInUyJ0xRcPfuvIZiPBlz6qg2GpTR3zl2UYkuz5AMKy9cochkgtu5Uwj8N1bEnSmc2ISJhAITGs4ezZAskrvA3PRk5ZY1JTUJS85n9OF5/JnBBcdil0gkOOaCyYeTNKempIaC6V73yS0OMs5J985OIlq4VDVat7k5LRg7bRVrqX7T4aAAB/sMG/KBZF1d6+/AvrUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As Dev reported[1], it's not ready to support batched unmapping for uffd case.
Let's still fallback to per-page unmapping for the uffd case.

[1] https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/
Reported-by: Dev Jain <dev.jain@arm.com>
Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index f13480cb9f2e..172643092dcf 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1953,6 +1953,9 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
+	if (userfaultfd_wp(vma))
+		return 1;
+
 	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
 }
 
-- 
2.47.3


