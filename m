Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E2FEA71A2
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087CC6B031A; Sun, 19 Apr 2026 11:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038286B031C; Sun, 19 Apr 2026 11:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68FB6B031D; Sun, 19 Apr 2026 11:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE01D6B031A
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:56:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 960371607D9
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:03 +0000 (UTC)
X-FDA: 84675756606.21.6213F3A
Received: from mail-m82144.xmail.ntesmail.com (mail-m82144.xmail.ntesmail.com [156.224.82.144])
	by imf28.hostedemail.com (Postfix) with ESMTP id 207FFC0009
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.144 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776614161; a=rsa-sha256;
	cv=none;
	b=oKsZHp7dQ60UPC315uKHdZpMOD0fJveKm6dKy9dquNToK9ktxAuEhK476/atOSHW4po0oJ
	jUht+9OaZwfcsii8pJPrggk9jE2GreX9hWVQN3qcBWArVWxT58LoitmGjMvML5TZxJnxhT
	/+M++M7FUR1B7sOtbEb4PwAFtRd1A2k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.144 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776614161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wx9OlUC0TK8oBwuCTKrsbiipTUHboSxxJb75pN7wKMY=;
	b=M6rGQ1sv19EmYawf5g3m+UAsG1Bt22NHYkOtYjT4SoafyvKun5gGcKEC6jgEBgv+zUKuPz
	CyWwzujbv5it9b/lq7mcTg7po6kyT8nDQvH7ViaD58hmPD7SRd1K0L2tASOSZVoo8qGUNP
	U/d5YnnVr8umywfA4hbVgSM2pwcffPE=
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:ef7:a5b4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1918e52a9;
	Sun, 19 Apr 2026 23:55:55 +0800 (GMT+08:00)
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
Subject: [PATCH v2 1/3] mm/page_owner: add filter infrastructure
Date: Sun, 19 Apr 2026 23:55:38 +0800
Message-Id: <20260419155540.376847-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260419155540.376847-1-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9da674a44d0229kunma1b4aa74234e87
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDHkNKVkgdTEwYHkhPTkJCS1YVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHh1MQRpOGU9BQ0NKS0FDHUxPQUMYSU1BSVlXWRYaDx
	IVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspamd-Server: rspam10
X-Stat-Signature: sbhmr1k4r5itccsrr7j537r1b5a849uo
X-Rspam-User: 
X-Rspamd-Queue-Id: 207FFC0009
X-HE-Tag: 1776614160-501044
X-HE-Meta: U2FsdGVkX18w8rEgCOTSsFeHximSFpupTSY2A8VWs0AcAUw4vN6H9plBpnS8fBmIuLC46aV6xg4YczgpFGKe26LVi1J+attq2wRpeQ5m3hoOoDgTum+acNKowvHj/kU98KzgqHNL51Xb0agzh5y1jIWNNT/LIta+cB4DHCQxxFYOQKHi4rj469zVheuGrWfTmaexF9Nezrb3vb5eBcWXENjMbavgJhN0C2CrXOBQE7z7ZG0JW2/hwj8ao9tee4/Z8bmB454U1KkaVN8DLAgXe5rrflMrOkvLIKgrDD4kSGc1uGVGbf6qX5GHbJqKV0ZXJFpFz/OQeErZnuwAVaQIT0eKLENFbgF6zvG33Gvv0FLLGyfu/9eqT1m0ADSrm5aLmDjRqkSEL6ypSOk0vSv1fCXUdMhqr2uq8knNKp4AmHcgMxi9LJd96TPzC2snw2q9WSXlelM70GFODJeBHsZYhPn2XJdNlFVY+hrzo1ZLUXoZF6hQpo6Y5lhTUeemjn4hFRazDNy77tqXU9MRp3dWn2G50OijUN5oQpNg7QJSkTfrD+r+fLpYDUbh/ARTS7VnRpKbwYN5HGEX1ZV+HsOdETbueH3OrPfjIstMuqJHrMgZCHar2MEEKz97IPUASZJnZUqXEUSAHR8V2SN0k34ZzzMZI2hXIVMIPw1OurqfypYKj1/rlirsW4pGinS52Rab4ZMPTSwFSM807ig+HHvRxg1iwNlHufJevxczcczAsSJmGu4cDdSwfn8ZwOfubHlVYqyhF3S8A+hh4ttkG2Apd92as3/sUJOH3nz4LwR2N/XQAsVXX12RBy7n/1gVVD1wfGYj1GEFYvcmzjm1u1qLY7yVE9AtGH5bG0HP0bxdH+5t06Z39UJubROnWAZJgfibKzPh39VqNRWyeA3U2JI1B6cs5WnMutM0tPWurphafhTTR4WVQJcGKeIfntrz+EPjNAxwiNfvw4jyGwNmIfg
 0WWKC/oq
 rBix7HUlrGqHS1Khvm4jCFq6zXjS8Ef/QT/128Zydz/AThRnAem650/UZcz+J2pF50KnmDK5SRy5UJe0cWZq6+YvttmPddcxnaRkao22bp8nos1mdan4opKr+ZKAplrDgNo6d65C37z+WZJqticWsxJ55lySc+HMJOumbAZaguREyOY9fAX7OySBnJCqMp1+C4D6ycjhwVKLG5j2li9F5v3lX3A==
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


