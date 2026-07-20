Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B6CC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD956B0092; Mon, 20 Jul 2026 08:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17EFC6B0099; Mon, 20 Jul 2026 08:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BBA36B009B; Mon, 20 Jul 2026 08:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D28746B0099
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:01:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D0DB40166
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:01:51 +0000 (UTC)
X-FDA: 85009016022.19.93B97C0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 41130180006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:01:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=l0RYnj0d;
	spf=pass (imf16.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784548909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IsJhOa/Z1KGfdfHrs3xDiPTpetSErP5ztLNsSTsvK+s=;
	b=KLnT9ZxgrwzBl1+ZGG20gUMzCwvm50TrPIi3ltN01mo1uX3Iljoityyay5dafFCfktCryO
	Ms7ACqoBHaV2kOBJlN2tuNz4Nn9y26LQKDzeo+BbDygT/bMQHwV+Bq+A6hIf0vqnoMI5x9
	TJSCGXxPIfU2mxEmqc/v4hWIbPN67gE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784548909;
	b=DxkZo9B7gJdluT2khVYgVjJzQ2DQwCpGCe4XGWPlhj8HiZfeLpx79MOc9497SWrgT8yoA+
	y+81HiYQgkZHMO9xgfS5DLKKVBBxHBraWcRCS5Bj2WVyPpVT/s6JyG3F8PkCHDCigmE+IA
	3azf1NqP70R4pn2RmP/94dcYuvdp1KE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=l0RYnj0d;
	spf=pass (imf16.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IsJhOa/Z1KGfdfHrs3xDiPTpetSErP5ztLNsSTsvK+s=;
	b=l0RYnj0durVJjLO1JPNhWxPWahYDusTT8OpLKHlUAycuv7RT8/AXANQ9NW9QAl7MqucCK1+zk
	nfQtT8a8UNAmETQ+NnVRwNz9+09/IDus6ZjOmyUVqCanhPTnC0HcCjig2ifXgANBUnuoX2iPim/
	PapqlgS7tGxpYuj2hrY2NSY=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h3fHn3Px9zJ46ZJ;
	Mon, 20 Jul 2026 20:01:25 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id ED3DB40570;
	Mon, 20 Jul 2026 20:01:43 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Jul 2026 15:01:43 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Mon, 20 Jul 2026 12:01:38 +0000
Message-ID: <20260720120140.881468-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720120140.881468-1-gutierrez.asier@huawei-partners.com>
References: <20260720120140.881468-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 41130180006
X-Stat-Signature: 7fzf11d55oandsyrxdg675543srsm9gi
X-HE-Tag: 1784548909-783918
X-HE-Meta: U2FsdGVkX19CHn55dpz7ZluDgwuQvodMO+p59JO9AHtWGxZhS9S/UqBaTlrqzW7mGAzqjo96piSDfeoQirc0N+5YWSQ8QMyWrAYBmg05M26oYGN62VVfvoVnKM8X4bpuAw4qYhd+frGYUGHS57+CiqDsBWgSmgZvvQEIleEUb0GkpVSh7bqYTaNOaZwIZARjJz6AUJrZ/wTBocFDP9UjVGfZJOVBdqIraKj1F7vWZgJYOxNVrlwru5/jLzEX1ipENKhrMp5v/sh/ewXYzJydq8wPQcIRCfQJcH157Ey4lhoiFzG7Qwogitl3IPMiL27revom/q2SVEU6TUBMBcvhBzRqyvJ01qammU8vdeCJXFtslp93a7RZ1iDHLbks2ujcWgqIk8biIIKPWlQc/BwcfRu/cQJiJRS1r3FjKK+4m0c+HarqapZwLCtvsB5GXtp0kV8f7tb1qRgaVJkLdv/SpDd4UxoSWT6PCIzAVFHBAUju5LT/16TiU8ngiiOSDZ1foFGnxFLCHOfdm5iBEQSZA+6/ggHM/gvzE/eXXrzrwHUEFjLgw4ro6twbl5it+OjYmVxe8k4Whriee0fzx6hOHMvretP8IyFXvsOldKZ3qAXyPc1mcFHG9nV1hhJws4SX4OCP0H+F2gZBpgMbEJPt/04vVg0syxTW5FpoxvZADpi12waIWq9+kAX8jacRcey2wiT6l2rSqf1Naie9H5lM4EJBIERFEjZ0A/HM6SHZARuRXYD0TW+dvWPF+Q67e8QnNzdWR1jn090OaOq4B8XGaIdK23ah0+L/a1Ce8waAGnjE2O+BQrn9aYn0Od/sYBIeyTUlt/8iXWmYZ64aSAElUiRMOF9zpSdSPe1fmNxeC/F7p8BlB7t2nV+PsHQSA8kcCDWZvrnHSBM3EQLs/b9NmJnM7ZtFeNGpvt2woVSkapd0AcEy8IsjQnVNnPg74Cqv4Rv4dY6ZxzfVMuLsQQX
 gwQE5ERw
 SRBUFV5zGR4Lb4PEYNErLQs/rQ6BKQ+bYUNc5y7gUnj8kPhMztnNAaLECwSCtAnBnlJrBzGlg0ZbRnWy6rQEPUV3zfy1oO54kp/b8wuGCZGwaxM27eybtni2JSt9RNgmoG1tr/zKvB6/EU/8Qq79dBYaedcvdg1s/BVNIq+aziF2t7I/TQGcVbZTcBKX+g+I+9va8poKic6jHb04iKMV9mVnHyqqYsCGDVMjAhGo5z0DMoLDjwFaT34mXw31R6W2GY+p/SFDDM/tCZOQ108HEvTaQCfPmCZsEZnPZc6G2WWaz0rz2Fgf3gRNK5fcxgnPl1OkLfKGYqwGKI4yY4ZRVvgyUG7f6so2PICC64wzzqXA3Ksx/hYqio61iKpyZj1bUkr1dAZmTqJjMzDumFhh/4kaS+475E578Pa0w7WUwR1Cdqdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP auto tuning. Add a new
DAMOS quota goal metric to measure the amount of huge page
consumption to total memory consumption ratio.

Vmstat may lag, which in some cases may lead to NR_FREE_PAGES
being equal to the amount of RAM in the system. A guard is added
to avoid the extremely unlikely case of a division by 0.[1] In that
we return INT_MAX, which should be enough not to apply any DAMOS
action until the NR_FREE_PAGES is updated.

[1] https://lore.kernel.org/all/20260715151615.99767-1-sj@kernel.org/

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 327f534696aa..0d0b7bb233b7 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -153,6 +153,7 @@ enum damos_action {
  * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
  * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
  *					node in basis points (0-10000).
+ * @DAMOS_QUOTA_HUGEPAGE_MEM_BP:	Huge page to total used memory ratio.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -167,6 +168,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+	DAMOS_QUOTA_HUGEPAGE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 603b102ff80f..73aaee43c6f7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3004,6 +3004,24 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
+static unsigned int damos_hugepage_mem_bp(void)
+{
+	unsigned long thp, total;
+
+	thp = global_node_page_state(NR_ANON_THPS) +
+				global_node_page_state(NR_SHMEM_THPS) +
+				global_node_page_state(NR_FILE_THPS);
+	total = totalram_pages() - global_zone_page_state(NR_FREE_PAGES);
+
+	/*
+	 * vmstat may lag in idle systems and lead to free pages equaling to
+	 * the total RAM in the system.
+	 */
+	if (!total)
+		return INT_MAX;
+	return mult_frac(thp, 10000, total);
+}
+
 static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		struct damos *s, struct damos_quota_goal *goal)
 {
@@ -3035,6 +3053,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
 				goal->nid);
 		break;
+	case DAMOS_QUOTA_HUGEPAGE_MEM_BP:
+		goal->current_value = damos_hugepage_mem_bp();
+		break;
 	default:
 		break;
 	}
-- 
2.43.0


