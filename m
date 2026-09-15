Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F7BBC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A066B0096; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545286B009B; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481896B009F; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20B506B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACF5114040F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:36 +0000 (UTC)
X-FDA: 85216340832.27.01E8361
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0124220006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=J+YFrG+y;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf13.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485214;
	b=7tQnYWChcV15DrInuS/9lE+ChAQPk97wZY2kFAl52yxbUUpGjgket114ex/24kSv4luLcw
	nnktYeS6+Jwm89fumdrtrVpbTiohLNekRZiHTg8tdIvzs90ptUj2Khe5fs7X3dTSQFFz3g
	XEH2AkNTAsSpHlSlKcx1DCWiRFEIrMA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=J+YFrG+y;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf13.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIRCRjaAuMv2QZADS7mCIjWRPfqdJWUY1VCE1j3QO9U=;
	b=bYTJGAmMDzJ6+OSb81dY10UOg/u8G4UnZOwEVd1Wm3MGwyufFlc5YkZ70AjZUlzx4JzhAf
	ytYr4qx99wN9yb4hhKygf53fFfx8eXa4A9eRTRDJoRNpv3W1WggHnFIlzcOhF1G95mXidT
	Atu7vUFigMkbUt3BLhogXMD34A/uMGE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=nI
	RCRjaAuMv2QZADS7mCIjWRPfqdJWUY1VCE1j3QO9U=; b=J+YFrG+y/sUXr5jGUM
	4QclUUaid2LCELZzDqL4Zq8aCvoIqJuPKGHpkj190HDoeTKUWKZuf7YkEWHsj9+v
	GKX/8HXofuiCFNvnl9+4GFf/Ui01OplJDI2mc+ldsKulQbjYLaSEYkOVABUe8cPe
	7IxFuetiQHAMcjP+de7DHsEqs=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S10;
	Tue, 15 Sep 2026 23:13:23 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] mm/ksm: document the two remove_rmap_item_from_tree() calls
Date: Tue, 15 Sep 2026 23:12:22 +0800
Message-ID: <20260915151236.5200-9-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S10
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrykWF13XFWUAFWxGryrXrb_yoWkuFgE9r
	4qqrZ3WFWDJrs0yF42gw13Wr98Kayjgw1UXryqg3W2q34UJa1kurWv9rsrXrWfurZ29F93
	GwnFy3yUC3W7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0eRRtUUUUU==
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+BNBOmqpYJNWAwAA31
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0124220006
X-Stat-Signature: fmoryx9s5c3wh5akm78qufmpfhmhps34
X-HE-Tag: 1789485213-721002
X-HE-Meta: U2FsdGVkX19RBem6xeKtwQskNPCH2McHYE3m8l2GSrWudiZ7c6TGRNSdh0EU4kURubPGINNzkT6aa6MPhHpBa8NgnxAXqhPfhWPIjPb1+H+qWg0Eo2qSJjNBlVH9DMvpu7g70yplR6mg61c3Z/CzSHGK8yBkUAPqPMShhtxD/K4xF2M+nj11xUf2ywzOMiDLIeGKxxqHYHyShDJGvcv3QEljHfsnDhTl5TRpvQneGgXGp2VJMKOdmNjhmgAnaqoinDXZqYsKAHRscNHe5v6l5ivwFydzEM6TV+ESr73VMV8YVNVF+Z1SgUfC+YXmTMyy9Bcdg5jatwmV4W/vR8tQnyx7N/nemb6cjpT43PY07ykFrSbusHTJ4DHD/AQffAU2mSNAZ1/ubcEXKNAETYsFpFe619+coF0Cywsr3aPGM0JvzIb0rrdqanjk0xM2EWlh6yGf+OiKp+Bwkm00IA6AYm3yfVgYl7E1Ol/WzCfJM6RH4yDM+DPf0l4dgR1J3ZHX+BGv6l+MIQ4GjGZlAktnzoCCLQJZ7mz/WHiFQlsAP37w1d9dXvTWlHS0DViw/lR9EhCBO+hHUmMy3iJR00/X6NZ6WyjxwFXhS41UlL9FnT2epVnib1mr7NbHqZBKOgbm1xOYilgj5C61pDmaAExWRZEsb+Uis09Z3QZwX+Fi049IGWgkfEFyXOuVsI5s/c7MdXRxERTi9JW9F4WYeqz8LrQEnyY7Tsz9W5DyQve/8Q33Vn7k4Ax3yCOdfDPQ/wbrghLV44CkjVmF976iaCOMACmHJXqqkHDj9gHvt2WC8R7/zEzmxIhsJeovvD/TrAr2bAL1w4uP6D8Ipupb/y8SS1HZi4nzE+aEkS7/DuJBm7u1VTX9q1vwPJlP+lMNXM9pab7J3TXe4RggY71lLDrs6AF154mrxwvwgX2tRitTvrkHlw7SGlQpCC6T0oXAi/x0JM84iStF7VZWsU4aaL2
 tXEJaas4
 q/7hESQoi8TDWjMY0ZLe2Bruc8Ow/3FDeD0rVyI6m3y+tYWU3wI7pK5npO5bF5Y2DCTG74z9tWI27b2Tbe2Qw5QpjuR2A8U8kupyjTXXBEoRngik0bfYbXgu39dmhus77tD9CZ5qCGqDLLHCm17a5BBD6KGOLikwyJSVo4/EXgGt5Hi7o4gAg0nJVc1URtC/svxBL1E0sAO+BuI3Eghdigras7JOwrs1OlwNYfse2sVQVRIjGEDH3RZkBq5dQ4tBKlQr9VfM4oxWtWcZV4r5X6c+MSCP55M2phqkasLp+bSjlPVqp4qCya4bhYyijzhrSZrRtPAK758PhVnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Explain why cmp_and_merge_page() needs both tree-removal calls:
non-KSM pages are detached before the early returns, while KSM pages
are handled after stable_tree_search().

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7fc9dac5d67c..1733b23cfaa2 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2313,6 +2313,10 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 		if (!is_page_sharing_candidate(stable_node))
 			max_page_sharing_bypass = true;
 	} else {
+		/*
+		 * Detach before the checksum and zero-page checks, which can
+		 * return without reaching the removal below.
+		 */
 		remove_rmap_item_from_tree(rmap_item);
 
 		/*
@@ -2338,6 +2342,10 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 		return;
 	}
 
+	/*
+	 * A KSM page can still have an old tree association here; non-KSM
+	 * pages were already detached before the checks above.
+	 */
 	remove_rmap_item_from_tree(rmap_item);
 
 	if (kfolio) {
-- 
2.43.0


