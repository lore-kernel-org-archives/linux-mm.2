Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25497C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780176B0095; Tue, 14 Jul 2026 11:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757106B0096; Tue, 14 Jul 2026 11:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FF26B009D; Tue, 14 Jul 2026 11:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE086B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:02:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5191A0410
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:02:46 +0000 (UTC)
X-FDA: 84987699132.19.E148DD5
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 037EB100006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:02:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=kAbHnaBT;
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784041364;
	b=f+QMvIAFafEyhqODgr+mLqYClk2X6FOln/bippXzL6ZY5nROfqBxg8LLrXBGghvJueikiV
	/pMy2MZ4EEu8592p/1Y3aYHUZnIFnOwAearhhCAEqdEyvbLFidXbSIXgRPqYjkirb6ZHz5
	2+T/Q/ZWpFq9Mr4zFIGhvKicv18jdiI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=kAbHnaBT;
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784041364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7udkS0ORBoH1kTobq9oFkHI6hkL3+JhRQTcgtNL2fyU=;
	b=5bnATxyGKE9TatyTkvsBz4TS4d/pe0AZ9aEYnkQS4yvXqSdEw234L1S/DKfibVKESIfmr0
	IwRDottei6xIZX/iuvpqK3raFL1k4Vpd67qse0cmPIRGrtHl8yQuqa/cYDoqM6HNjB3e2X
	tuiDvM/Z6j3Jcw1WAfY29hCpcDo3XN0=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7udkS0ORBoH1kTobq9oFkHI6hkL3+JhRQTcgtNL2fyU=;
	b=kAbHnaBTwiRu1zbuyXnb8C3uIUyz9lTWISz+AeWeVft1iZbk8FxGUN3Jnl0TF9dFcbERvFePb
	wBl8jMs6PjmLE0llWgeLeJBeIDi6Od2QgY4mHFgUe68KzB3/kyfHGqZZ/yD2puh3XV9ofQ67Ttm
	4omcuMjimuOw26/G3GTiJ9g=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h02bW48qnzJ46Zl;
	Tue, 14 Jul 2026 23:02:31 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D6914058B;
	Tue, 14 Jul 2026 23:02:40 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Jul 2026 18:02:39 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<zuoze1@huawei.com>, <damon@lists.linux.dev>, <sj@kernel.org>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH v2 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Tue, 14 Jul 2026 15:01:14 +0000
Message-ID: <20260714150116.382521-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714150116.382521-1-gutierrez.asier@huawei-partners.com>
References: <20260714150116.382521-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 037EB100006
X-Stat-Signature: kqjcaqspjqr16ikx85neyzaypdofirxe
X-HE-Tag: 1784041363-332720
X-HE-Meta: U2FsdGVkX180wfgkFq0GzIlRwkfVIhZRjKonUIPAwmVFebDKBM4Jfv1e+YhrBk/SFeEu54ffjx7SCfrTJA9BJmIc91tVo6aBpXBwO76ZwonT0tt9b9ZO6j3NrQyrn1SgML3fpnaik2ObJV2yAZuT07mvymwZ6KuLDPMCfku7WqCtaGHb6rzGKhckKSgDpJ1v7h/iRh6Cf7IVJMxYdzJtdhf/TEU4+Jei6q0KBKwA7cv0jqrRgfOYE2plE85fSaHk00W+tDrcXcd2xBL83pbbUYcn7j4Pa+gYGShjsnc1cZxF17Isc4HwkVPpTOc7ElnmztPYYegnWcdIq9pkLn2L+1UzEqWOjq5uzhwycEqCB+qxT8MOT1SOi1mHK/pQjHzcMilH5IAk7AvZsBlZug7DngLnAnei8N8znd2+Mriu1ZlJ4HVOrJ8BMjwZd/h7zDKvmJM6M5Ymvof7YD3qUpJkkgEjd8EC7SaCne03ndHnN0Q4IXa1D9TSq2f68fynInwcnxP6WNOZ67MVjXowZvlURRi3KmPqyXP32Fxm7Pv6n53HV/ZEnDuQpX9ID4Kqs2m3GepT+TjKvlpaZxHWNaTQmCBjF8xHEpitSYFjrqe7fRNGxlcJSKaDPql87g1RXe1wnXRceY3SGgbchFKDgeLEi3UCwRdE4PvxI0MxggUdwyIX4JpsWya73B+bDeQkke4MFuyuI0o1Aqje6Yuf4mTCMzRk0mRC0NsDwWzd3XMhIXZCjWulR+TQI5NT9r5GEoQnRdVnliWBNk4C74dbzekNU3JB96eT8dFpm350clAHOjTDIFif1xd9Dy0LUUaVtFFVw9oUX/Kb4HE04X5TK70oasJN3eRYL1lN3q5su5uRXZ5MBP3AjtVHSvL0PVtLCYsopT6hShhqvp1lom7wofbL6GYXykK63wAnasVyo8jcbYVJCr33h0DSt+I+i51/5os1ia7lK3KLUbmx8GO1iR0
 kmNhu3of
 vLVULk4jbffGGRyMmFg7axEbcCSHeFPtTnY0/2ISqtemeiYopuO5p03oBSOy1kGnU8gTBd4nF2UBHZQxTMLWPI5VZM5gDYz2SUJqXxJlORJNMwLTR3xTeDvN7F5z36lP5k4wrZeqWpPeR3c7qG7MNuSgM3hXXAgcJaI0XFNFLra8hedX7RIOra3vqxtkx1CoLAJROi3ATEEzzlO4rzSmTcud0ZtjDQoQhuRrnhWznrewvXAygOx+0NxUNEJCkvIGM5PTgDbgPfiWqlBcvdv4cEbu4aCVZQ1i2fcEIG/p6WHWQo7hjuQ0FyvCc9JTe6n4x8hlCT8qNCGm9DjJ2olEtCRzsELA4QjpxeobPLtZy23/5Wo/ZSuSWrekMfb9zNn4xfWEgJBxsnpfm6F09+DldajaR1whvcVggEuGCF50I0zHnwHDYwaWaXC+HbQ==
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

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f69442a9d431..a36be33a6da4 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -151,6 +151,7 @@ enum damos_action {
  * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
  * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
  *					node in basis points (0-10000).
+ * @DAMOS_QUOTA_HUGEPAGE_MEM_BP:	Huge page to total used memory ratio.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -165,6 +166,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+	DAMOS_QUOTA_HUGEPAGE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6c4215cc809e..d1f0af4f02b1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3004,6 +3004,17 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
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
+	return mult_frac(thp, 10000, total);
+}
+
 static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		struct damos *s, struct damos_quota_goal *goal)
 {
@@ -3035,6 +3046,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
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


