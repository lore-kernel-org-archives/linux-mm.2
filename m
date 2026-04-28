Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCFB8FF8870
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F172D6B0092; Tue, 28 Apr 2026 03:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0E86B0095; Tue, 28 Apr 2026 03:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3DF86B0092; Tue, 28 Apr 2026 03:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0B456B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:11:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60C328BC1B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:30 +0000 (UTC)
X-FDA: 84707093940.17.EBA367B
Received: from mail-m82133.xmail.ntesmail.com (mail-m82133.xmail.ntesmail.com [156.224.82.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1A21F80006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf30.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.133 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aPCCGRuozaZabrcSWlpVblEJwESeDrS+A29k/YXGq3s=;
	b=KMRzEAk1055MQxqVpN86Z0nl5LHeI+yfqp4hqfgRoNrktZ/jVY0Ofdu8cpux+iRrgtqPeA
	GXuhqG9wdKWPvv3ApyB8R56olNqetN64A5gZP2rxBv88GeyYEMOZWx8coCYEtaJazgFWlx
	9SPFFKj7PcaRb81lC5HZxvb2LV/bets=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360288; a=rsa-sha256;
	cv=none;
	b=LdNC7gMkNExg6tYxUW0Eu5nNQFFiGDWOT5jmmuZX+oGcTHNdXGYPEp4v0XZFxE5fWHpEvj
	6McLS2/OdZZAYsb+OyRt40eCt/uW3KRZBHPKccVG1QqRq02t7NtgqRGSkYDJ4Tp1xtdcgk
	xfOWoB6889Me2dJvWBnaiVK1bBc5F6o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf30.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.133 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 197b492f8;
	Tue, 28 Apr 2026 15:11:24 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v3 1/4] mm/page_owner: add filter infrastructure
Date: Tue, 28 Apr 2026 15:11:09 +0800
Message-Id: <20260428071112.1420380-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428071112.1420380-1-zhen.ni@easystack.cn>
References: <20260428071112.1420380-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd2eda9d00229kunmb0c223f1156f03
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGU0ZVh9CTE4fHUNPGUNIHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A21F80006
X-Rspamd-Server: rspam04
X-Stat-Signature: f8mqsgk5oii3msfyydzhanc5zaeq5kbs
X-HE-Tag: 1777360287-29312
X-HE-Meta: U2FsdGVkX1++tZrwyHJtRuWdpnYDP83vHS/Pq3ZZkMRpeQo1ViF3Qe0+srY3Nw83YHOyAk/UaJR2aVTDfjvdbqREgfknhfNpfMkL/bpyZR4WpwbauRd/rKeo51aoZcoY8sw/DL5QuCGqljXkCL5uGN1NaMRmhfU/QSbvo8SPoaDbgGyHCC8kcFiNd54yUlruN6Qt+DVjhg0/u/Z28en4wJ9eEs+aHacvH9cYUlG21eEdXLtJgqPDW2F+B/Cvk8YTEMpDbvV5HoaT86P+VoUWhWQUa7cMinog8ACCgMSShnO7ZwrVhw4Wojbw4Y+ikTpZlEhRlxbqGj//UTawOgHcxYv8VQyiXFt+sdGBQNmFnbkgB3zJNr2+vmnrnePh42qNbkevH8giE3sqyXrczv+h54DpSH9+RP41uKOPDnJU0Oep3tZB+EzarlzTgWw7Z9rUhLP0Qywb28yobXex70+gYydZQdayBZVSO2CKVnItkCL2kwEi/+u50U/rckPkVgw1IMNGjhRYriOpATH7vvkDJzieyM42aFSqRiaClHviPF3xAiU2s2Y6GE59wVvPQ7pLeU+sVpcyQj7VdVJNgkE5tdv8KHI4st3DA3W1goVQSuBVyegLu+Ar1XNsFhsyy47Qv4wayKpUKd7HNPJDVh9gqeL9wCXfw98Xy5Xsr2R/4CFFZmypim1WeRrDoOOfKuasZ1M7LwFzux2TEONAZF/oApJTSv5a8LyjoJ1uASu9GPuDMbybVx2u93cVooASRiEKefcZHEKbWs/X9upA2UcJtP53JecMoiusNE3ZNjnJCNW0MeGm4imnjHhNQy49jurQeBTjx8+r4YQg9iGKK2b9EfxzItAyuc8kcTL697EtKJBpz2EgYVb0Pw94cUftUS5iO/XD8fRCfPvLSzFXiTlFj68WglSxna03S7kkJmZidbcQaCOeVGbpdN+kdfut8Yn7Hljr1RC7RwcLTY3AXPJ
 19W9jpLf
 Khj+u7aVzmhmTsDK+VIeFiYn46BmLAykqH+/KXlrQpWUb0pzBfuoYQ/2Se1/33YZscujtjL9kNQ0kquxthcOWC0+gydW06VqHBw0TKZddPQ5EpVb6XVZYZm/e3b1L38tjqEtHtVJ9xPN5Y6ktNrdEUK0Z9sz2oxDM8tCxY/XFLP/qX38oKDivqruM3wctt7fyTuJr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add data structure for page_owner filtering functionality and create
debugfs directory for filter controls.

This adds:
- enum page_owner_print_mode with values for full_stack and stack_handle
- struct page_owner_filter with print_mode and nid_mask fields
- Static owner_filter instance initialized with default values
- page_owner_filter debugfs directory

The filter infrastructure will be used to add print_mode and NUMA node
filtering capabilities in subsequent commits.

Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Changes in v2:
- Use enum page_owner_print_mode instead of bool 'compact' for better clarity
- Use nodemask_t instead of int 'nid' to support multi-node filtering

Changes in v3:
- No code changes
---
 mm/page_owner.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..5884d883837e 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -54,6 +54,21 @@ struct stack_print_ctx {
 	u8 flags;
 };
 
+enum page_owner_print_mode {
+	PAGE_OWNER_PRINT_FULL_STACK,
+	PAGE_OWNER_PRINT_STACK_HANDLE,
+};
+
+struct page_owner_filter {
+	enum page_owner_print_mode print_mode;
+	nodemask_t nid_mask;
+};
+
+static struct page_owner_filter owner_filter = {
+	.print_mode = PAGE_OWNER_PRINT_FULL_STACK,
+	.nid_mask = NODE_MASK_NONE,
+};
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -973,7 +988,7 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 
 static int __init pageowner_init(void)
 {
-	struct dentry *dir;
+	struct dentry *dir, *filter_dir;
 
 	if (!static_branch_unlikely(&page_owner_inited)) {
 		pr_info("page_owner is disabled\n");
@@ -981,6 +996,9 @@ static int __init pageowner_init(void)
 	}
 
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+
+	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
-- 
2.20.1


