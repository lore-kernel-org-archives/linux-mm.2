Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327D6FD5307
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 07:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456C36B0005; Fri, 27 Feb 2026 02:55:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405EE6B0088; Fri, 27 Feb 2026 02:55:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303806B0089; Fri, 27 Feb 2026 02:55:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8F06B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:55:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9676D8BF2B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:55:43 +0000 (UTC)
X-FDA: 84489477366.10.580A5F3
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf15.hostedemail.com (Postfix) with ESMTP id F0F82A0007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:55:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=LYhVInJ9;
	spf=pass (imf15.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772178942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2QQxJgo2nTQ+Zw3Bf081QKEft/GBg6KAyskkWtN3Ze4=;
	b=X7Ysb/RHNvAvF6M3J5BWwzNU+ESomqpk5uTtYps5L2qZ/qsitzY06mB2w+0/zOLwJpLI5z
	45NZ8WrT/4XfEjVvhkvQwQOWMsqRhksBdBQk9d6yYxyjXi1oLhGe43wlz9z3tsmgsNNzlY
	qozhvOVi5fQrit8l6WtU7EpN0FTp2pY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772178942; a=rsa-sha256;
	cv=none;
	b=Kvyvr8HCKSwyT8j5NcjWc0X6uwf4uGxuDRkSvgZ4+y1FKoYPAi06I9bqJHS6SSWhqAIA+h
	olSNCkXIOUXDSB3IutpnTOoWHQmKxH2F3YY4fjtsu6Y0YAw4CkMmN7QYba/K3h4ZbdBBMs
	uVnPj5HEpL5UEZ3GHClZNCSy2/PmH2I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=LYhVInJ9;
	spf=pass (imf15.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 61R7r4ij010189;
	Fri, 27 Feb 2026 15:53:04 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4fMgXF4db3z2P5pqq;
	Fri, 27 Feb 2026 15:52:13 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Fri, 27 Feb 2026 15:53:02 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm: bail out when the PMD has been set in bloom filter
Date: Fri, 27 Feb 2026 15:52:50 +0800
Message-ID: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 61R7r4ij010189
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1772178797;
	bh=2QQxJgo2nTQ+Zw3Bf081QKEft/GBg6KAyskkWtN3Ze4=;
	h=From:To:Subject:Date;
	b=LYhVInJ9Malc6NILuWxejbXJ5GxewAQlHfOA6+1Af3L7l6159yOr47zzBxe5MWJjU
	 CUPiuazfvVR2c28Rx5zy+x+vjpDxxmYNy4+4xaztPl0NkxWdWDBgo20NMaHx2zI45Y
	 VE7NnvUEtS80jNYhKoC0g/2azoRFSr/PBLGk9QIrBGkXtZv3nFM8TjDLPKxJy1mmq/
	 fKbj3gKpZTZ8Fy592zo7Ft5iPlWgnsIYhGlvO2PJonP2l+a4Yqf2+PEqDf7HVqXJXJ
	 n+0fr77rnZIqKMtk46WIzaLjozZ7lB0SjTZ02xFdoYDMG0daV9bz4IfUzflevvwxF3
	 2LXaHN2DBR9Fg==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F0F82A0007
X-Stat-Signature: xujp5ztigi1sxut5s6r4w19h4hu6ofby
X-Rspam-User: 
X-HE-Tag: 1772178938-607212
X-HE-Meta: U2FsdGVkX1/Fr3vWXKFeLwhMQXpmvf8UboCI3+U4Wp+cL7s+JyvnKUHnLxIq+zIwkKHiFU+BAJO/RQhvLDYtygvk/y5ufT5elFietaEyDQydoi1v2gQmVxLamhYbse27mmrTVWqszq3063NlIhc5/FvjkJaO3jAXjqjYCjNz+AUAZ3gztKVAI05atfgFvMG/ZXhIIb5RaNXc9nbXZRN0CkP8Pq+cQfZMOKJb03TY6CEYRhIAYAi9ueyyTr1s6dCNxWe78BclquJdsfN2xYHRxDuG8omjbrFPa7unL+28b+HXSGr85EgheK4rnLw7u4kWd8SCIQdFjEKzBp3l4e5ztlu5eN8e1iqHHYDjPs55f3t5Q0H20BYbRQu0UVA0RAQO1LGRWbKzZo9EYnmI7k75uAgQwDnN/K/v688EkoVP5qm5zx2uVhobHe4VdP/8G+7ZmoDfAwLO811jRLtGu3/FV1+Z0OJ9+d6ibmGOII7Mb9d60EbGrFhp77W4Psx1fkls3GURmhg96t/nbOQ7odjk/Ne67zkyv4gZpIVPlxs9EY3oUOTYenmakB0pXkWKhItpbL+JdkJELXxlCVKUDgABUFxxf5uEfpvd+Kv4hkPRLEfqLIMrE/P6onYEyvMalCegG77xPWK+vNS0lqyr63vGkfbgqFw70R6JGaz64rJNBLNJ/SzP7izxVMdrSGajfS2XAyMNxvHVhkrM6FYywBAqBqQS9BjdxYPjoy+rvZrlCB/2O860T8EF2BZQHPHWHKDS83ITA4iDsEe/oHjPZslEeAsiUXOufYZap1b292xvBlvm/9jtVFCv5OxteUc0ojHBZaR+eiNcg7LrmMCZ3Hj6uL46Jdec04RDHqauvFXAB1t52GA3pzCV8rhlvwdCFyN2CxEkgi+6TGRFAOiuMpRsoOvAJInPT6Ll+9uQJZiQOF+1QaIROMLlgVMrkXXFFYyMyOh+4t0dohEYZQMazoV
 HHjWphfW
 3O4rzM3Tl6Hg0898ewKzsx33Rej1haDLARQEBSggDdZ8uHVdXiSvTBnHoc+W0K04yLqmC12BzVwHkqTtKBZ8l4XBVFEVRPf4F5eY85n02LHGtlEhFcQqjLYHy7zwEx/MYrpQ7DCkRJFWSmVZemdpHtDQg1tk0+cdYCLwMVeWyGvODPv4rdgdF7ZuyyQFBmShxahkWm5cOYzUYhCLBQOeg8AzJnnjRa86SCAr3JtgdvwDoVliInM0+V4g+8yy9Vk32fXTUEnDKg2E95Avy8hU/tr9/HYRFyd+JMY4AOm3iZbfOUAgj6kJL7HSsUqkCrVDZwlog1wP+lBpj60HUbSETSt/ibVfdGPHq9l0k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

There are two reasons to have the recorded PMD bail out from doing
the following iteration
1. It is worth of doing such a trade off thing in terms of reclaiming
efficiency as test_bloom_filter only consume 20~30 instructions in modern
processors(25 instructions in ARM64).
2. The PMD needs to accumulate young pages until aging happens while the
new arrived folio reference checking under current max_seq refuse to do so
which will affect carrying hot PMDs to new generation.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/vmscan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9d900be478ea..e50e98291d0d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4227,6 +4227,10 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
+	/* may the pmd has been set in bloom filter */
+	if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
+		return true;
+
 	start = max(addr & PMD_MASK, vma->vm_start);
 	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
-- 
2.25.1


