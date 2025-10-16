Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9563DCCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01A98E001D; Thu, 16 Oct 2025 07:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B438E0003; Thu, 16 Oct 2025 07:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79FE8E001D; Thu, 16 Oct 2025 07:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 908318E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:02:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38C66C0298
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:02:47 +0000 (UTC)
X-FDA: 84003689574.24.0DFB013
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf25.hostedemail.com (Postfix) with ESMTP id 09A46A0016
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:02:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PVH3AjvB;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760612565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YA8D5I96zsXRtdPpR5at9hJZuoUIlUR0M7FDNK1mdqI=;
	b=u623InkN1SlHjCRFDfJaNYxvDE7xqtbqMaYEFkX3GIcHccyQl0tfqKS4+PQMgbMDFarN35
	cxKh4uE8UXaAd17ssssfDVSAiDnFQx8Vf1sjhsrx+PrVIJvnYZYBF6ar5ZO+B8gs+HpmnF
	jpSc0W65wFTpLRdbw2kIty6ChKPZUA0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PVH3AjvB;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760612565; a=rsa-sha256;
	cv=none;
	b=TSVD3ybWVk0Nxko6bL/38fbOVxDME6sNq9t77zUvH8pVykh98Y/0+M/zidEnCRjEx4ToD8
	dvexNaknqc9ftVlhncNQz6kAgwI0YyOGpR88f0tSXKI7yZBmFkPMcX7JaoYF/jkoP5njIn
	/34pYIH0Dgdzl75Wun1/sSdhRIAYdI4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YA8D5I96zsXRtdPpR5at9hJZuoUIlUR0M7FDNK1mdqI=;
	b=PVH3AjvBH98EWotO5/VLOPldqTmMmYiNlNV+Bl1atBgPKDreShqY5goNPA2WDOeykki2sMx+v
	HuoZc/ZGEjExlvoTSYoJa2ZX9GHgzDRJIWJJHOQd0P/bluTH5tSy0cGYmZjBO7pIiUhiKfbS7wf
	J9/mqUs/wLmtNaO3PU/CgS4=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cnQ4l3rHFzpSv6;
	Thu, 16 Oct 2025 19:01:43 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id EBF2F18048B;
	Thu, 16 Oct 2025 19:02:39 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 16 Oct
 2025 19:02:39 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH] mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
Date: Thu, 16 Oct 2025 18:47:17 +0800
Message-ID: <20251016104717.2194909-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: k758mhmfm4whexrkehicyiiuf3hfnn8b
X-Rspamd-Queue-Id: 09A46A0016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760612563-26887
X-HE-Meta: U2FsdGVkX1+aIumLRgGYrFQa9s5m5dj8DjNSCl3SXbPoOE64wR62bmkJls4oP/EPoyexi0vUyXX6HcyHUR4AJD/S5R8DgqvocrQ37KEUiUreQJRLmQiH9dbZKu397Nf7RDytr4cDH8a1oY/l0JXKVDDPAkdUZKMisiKR+Tmta1AZAfxJ1ZllMvTu+XMBgN/fPXdWa3eEGqgVPsfmpL8nAdGoRYNBR/vQNirVIO/tT+i0NYvbnFoOqkhzncs036skMu7tzwTKy26ns2VLkb0iBd6F6tJ9fvgHOgN8wds3zP2whG9ehvDUCh476qTB22r8Prfb8L1DkcjYE5wQXGzzbGRm3pnYsktAtuIHHSyMfrBmNFoc8Zj8W5i0Ap6d9XzGKhz3eaGl5yo3ZSSG39ipxS+GeXMv3JCX98qN/a5PL0pn+O8kQyROYwHZWrUhDtn4id64/CHGEoDDpXK1XTuwEPJlhf0GQMwRkiKUMzk3CiDyth8bbbetbLrztungMKJS72ZHaIFjGUW0Tx7km67Jg57oz0zOPWEsVa6WssaZ2h2InJwVfioyJJinwlP7AhBUt9oCLuccDm1QVFwli/O/p13HtYjI46OWWNjM0IxKxozbO5rTku4iMEldR2iVogIvtObqSnnzzk9sT7Q8I8WMMFrNxtt8TEPTbHWGw1JO+h5TqYtYkLzJsiZsEIka3w/JOSa5OFvhCL2AuXuLUBic1RJk0wJlM9BE7YeEjCinOxvCyINg3xZAnewLbiHeTpdShEDTdI69+nyVQ2ZtZpqydit+nSY3pxBZEXw2KmOrFqc3A4i0xGtROz5lODOtuuolsK1QLYhN+hSw+vujjjOpQ3gNt7CE8uUxFPqkGNNPKHdBQPgISKUVNuDepOpHmP9jBXSr2Qi5aA3WjroRJVPiqpz5+WbzP9ZVqFg66QG969g5haI9KbJmdF68GMruI1SZC1JzUIwW03Mf03dkkYu
 FFEFbyvS
 dWPQKZluWeploMtCnLTbrd9cPOgllYKP9nLMPe7SV6E8oObbS2tsPjgCzr8Tb6esPsscV6TCu3BXvq0NB7ksy4Cz3MArS6NSN4KM2tftTXfJdKrYLWSXJAoee0uA5xzfFHS6zlhpNDrLNXEOiTic5TNEcEqR+GjeiJcZ6L5Pj9BZaPyBfZ0DWo+5QHi2PhXNEOPrbpdSWk4zCM+nvfVExD+a5fAH5IlYUvxFvOGMv4gVRw8XjTX8v0MncCaQH5VVEcWTEGz5NXKgkL1Uy+Jc8upqLlislRAzC+ZgqzL/yHyM7Kn+f3FxFx5t41NlgMWHytA5RumPYUg71QBh9ywMmq6raKAwJSwDvjgV1A9IKDdmqNzoJR6Okwzr9ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After adding addr_unit support for DAMON_LRU_SORT and DAMON_RECLAIM,
the related region setup now requires alignment based on min_sz_region.

Add min_sz_region to damon_set_region_biggest_system_ram_default()
and use it when calling damon_set_regions(), replacing the previously
hardcoded DAMON_MIN_REGION.

Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 include/linux/damon.h | 3 ++-
 mm/damon/core.c       | 6 ++++--
 mm/damon/lru_sort.c   | 3 ++-
 mm/damon/reclaim.c    | 3 ++-
 mm/damon/stat.c       | 3 ++-
 5 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cae8c613c5fc..1ce75a20febf 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -947,7 +947,8 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-				unsigned long *start, unsigned long *end);
+				unsigned long *start, unsigned long *end,
+				unsigned long min_sz_region);
 
 #endif	/* CONFIG_DAMON */
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 93848b4c6944..e29f08b8a114 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2767,6 +2767,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @min_sz_region:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds the biggest
@@ -2777,7 +2778,8 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-			unsigned long *start, unsigned long *end)
+			unsigned long *start, unsigned long *end,
+			unsigned long min_sz_region)
 {
 	struct damon_addr_range addr_range;
 
@@ -2790,7 +2792,7 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, DAMON_MIN_REGION);
+	return damon_set_regions(t, &addr_range, 1, min_sz_region);
 }
 
 /*
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 42b9a656f9de..49b4bc294f4e 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -242,7 +242,8 @@ static int damon_lru_sort_apply_parameters(void)
 
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
-					&monitor_region_end);
+					&monitor_region_end,
+					param_ctx->min_sz_region);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 7ba3d0f9a19a..36a582e09eae 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -250,7 +250,8 @@ static int damon_reclaim_apply_parameters(void)
 
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
-					&monitor_region_end);
+					&monitor_region_end,
+					param_ctx->min_sz_region);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index d8010968bbed..6c4503d2aee3 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -187,7 +187,8 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
+	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
+							ctx->min_sz_region))
 		goto free_out;
 	return ctx;
 free_out:
-- 
2.43.0


