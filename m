Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A2FFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F47F6B008A; Thu, 30 Apr 2026 10:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBC56B008C; Thu, 30 Apr 2026 10:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709056B0092; Thu, 30 Apr 2026 10:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6455F6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:25:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33687A1A50
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:42:00 +0000 (UTC)
X-FDA: 84715335600.12.3332BC0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 535994000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:41:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777556518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GYsMDRPnF2C5uu9BkTQHhJ1kBB1CRU8e1sWQC7zZnGw=;
	b=rkNJurw6negQ4aa0HCsYLG5w/MQemWiVAIQpgvMgqSv4gJl4dNS9LKdMxR/R+ZkHfAtY5L
	clp7abuyA/aommvqqo9uH/QSMj89Utym27f6Mvi1ZuD7k2NqkmlV652Vwd/PbCFnmccQRj
	Imuyzp2zYZZ0DdA5YWvz6J1fsVp7kUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777556518; a=rsa-sha256;
	cv=none;
	b=XFFFbJDiwTtoqrWZHIKA5RxAVkStaZ3YeXPpXOlm8/IhBW2ehgGq04VlvhhoH4ApuxJDUb
	BAjqM/YfX8FPxmszxosk0RKuESCEJZxkSH0Zv786zdrzHigMtZNd+W689zOyxfAuLBv3Mt
	Ef9ysbl9JofMWbUFe6jb2HhGxVNuoPs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g5wLF0n6NzHnGkJ;
	Thu, 30 Apr 2026 21:41:09 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id EE7CC40569;
	Thu, 30 Apr 2026 21:41:54 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Apr 2026 16:41:54 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 2/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Thu, 30 Apr 2026 13:41:37 +0000
Message-ID: <20260430134139.2446417-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260430134139.2446417-1-gutierrez.asier@huawei-partners.com>
References: <20260430134139.2446417-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 535994000A
X-Rspam-User: 
X-Stat-Signature: 5uu8u9d7eoofgg7hpwfrtfkhn9j71soz
X-HE-Tag: 1777556517-946467
X-HE-Meta: U2FsdGVkX198LDuVdTy3gi0bqWgYzOGp4vXr4rY9GcTKuoTMp6JO+siU8pyRiAdU9svTfiPLYQuUthSHg9Lt9z/LZYtpsul7dhf3zpVciKfegHy5hv1VHexS/bMnjv9Gdt3NAmvIn/Kn1gNKXXt2H+P2h0EwdJQhOfzLONplkSiIltXdpTNk70X6WZ9zG/XXZIlT3k5bUEPTeCPt4k0kaDZ4iRNnoGE4eEELvpoYCTa7hyoH2iIwp1zvglO0pHlDZzMCIkTIcTE3LUqXQtOd86Z5SSrdHpyZP6pOHnwnH4JlsEVppzKA7Fd9NsnLbL14FbkSPvnr0IuA76/6Vt7v45Os3K/lx8Os0Lq4xzmMC9KsGmDmLWnP7DFdd6lfIQcCRDISpKA+DRQziBosVHj5QqTjtwyJAbO9N8RktZgjsTI6/QoxuBrR8IpLfT5dTR21XuNIAXVQqAj3GFnUS5HrwGp9cZHVW++7RPCkxEiwPcEdLK8JazGRkP3GCvww9qj0K7Q47RtxKbTsWjdIKoW2NiveBu7NFHh59aX7W46YJGz7yvTJ3kt6HjHGjnn/WWMjLoEUb9bSVFOhVRQ2+pc8fr0NmayF1WHkDUgQk4AGDJxyvgNZKnVS+qXhwr8+zr/dMWi45miQkDBk20DcrXBeKu5FgymBnnuZPBwYNv2smnVmD55ahkxHjjfxcQvc7Jg0T6zrIyQYTTwc4WSs6CpE7IOv/q55zSe6Ko7itMLmHqxJE8tsQIut+IX/Kstzg1tMIWsN6mmfw2O3e/VdKU5II4bmt+bro7b0KcroFALYf+lcrqKWsYRvcetO5foRLWfm4e3vdw4R4zv7TKsREIBg9ynw1o51WedlSHopwYML0mCWqZ+okHusLzJvdOliKv9VHmLRbgMITDyQtbnYLlPHqM4gdfUY2XrCvVX5HKE1jiXbZTXeDPqQog2BBhjUH5CepG6JrP574zCjAvTNf4K
 3rS4G343
 Nc+CfxggYbKLqaq8q5VjlBJtEabnuFAQ3PkfzGji/0M2zLaQftQ6UrB7eGYu4htkSoEuT1PG0PDhxtwFfek5n0JXzZ2AkuovJ9Gcle4gELoBDdKkeE5xbNVVoaKkksk659s9maf1LogK3KTwekZeXSr0xAIZcp0opqUsgwZSChyRaYhVhJEnnWJNxlDODGVT5n+MxyM+eEftF7E9Q2iqZR/IjPkkyiasQRZdp4t4DAdyPC7BHG+7dzST9BXFvdy0HPBAudPjusQ0VjurqL25Op/YtPBSr4aveh5Ew0JXiBd/0kI/lq+VzuhIYl12mG/eLBaUw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a new DAMOS quota goal
metric to measure the amount of huge page consumption to total anonymous
memory consumption ratio.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2cdb7c3f5e6..97201e9fa407 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -172,6 +172,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
+	DAMOS_QUOTA_HUGEPAGE,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3dbbbfdeff71..06547e590ff2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2319,6 +2319,18 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
+/*
+ * Returns anon hugepage memory to total anon memory use ratio.
+ */
+static unsigned int damos_get_used_hugepage_mem_bp(void)
+{
+	unsigned long used_hugepages, total_used;
+ 
+	used_hugepages = global_node_page_state(NR_ANON_THPS);
+	total_used = global_node_page_state(NR_ANON_MAPPED);
+	return mult_frac(used_hugepages, 10000, total_used);
+}
+ 
 static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
@@ -2345,6 +2357,9 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		goal->current_value = damos_get_in_active_mem_bp(
 				goal->metric == DAMOS_QUOTA_ACTIVE_MEM_BP);
 		break;
+	case DAMOS_QUOTA_HUGEPAGE:
+		goal->current_value = damos_get_used_hugepage_mem_bp();
+		break;
 	default:
 		break;
 	}
-- 
2.43.0


