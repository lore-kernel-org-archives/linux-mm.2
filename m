Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BCFE7DEF3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2716B00B7; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FDB36B00BF; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1B96B00B7; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12AF46B00B9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6B43D3545
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:57:37 +0000 (UTC)
X-FDA: 84399820554.17.2839BBE
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6833B1C0003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:57:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770044254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3sQNMAcbCPnhqIE8/Qp3LTaiff/X86MFwoLWJrBQoQ=;
	b=LGa7FCo8yGdWOaWSipFmWngMPkmdsg/ZUXmaCXdktMr3SWA08Zor58GtCo8ETkJIquwPol
	8MmWTrgMKIaRIaCBeO3qmm2DpJWyrDAQzqz+vU+COjQUUPN5kg1ZCASl1wUyW6WtiCX2qZ
	leH1VdWLOd35iuyZ/V0b9IQfAXqshN8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770044254; a=rsa-sha256;
	cv=none;
	b=zQL20euFEXsqCCzmXZ324z/Dmw6+P8hW6j+itLcxBeZuGS3uS/oHLJWE2ckzfT5anUPxvV
	eePIiOObZqj1kKrS3De04SY4mKWXYDW3Pg/Fki0Lry1mA669v7LVEPv4d0Z57xFN4Pqoa/
	Zt+Qv30G2izlig2XJe232B2RD37lVsM=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4V7f4Z18zJ46cY;
	Mon,  2 Feb 2026 22:56:46 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 8438C40571;
	Mon,  2 Feb 2026 22:57:32 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 2 Feb 2026 17:57:32 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <sj@kernel.org>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 2/4] mm/damon: Support for synchrounous huge pages collapse
Date: Mon, 2 Feb 2026 14:56:47 +0000
Message-ID: <20260202145650.1795854-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
References: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6833B1C0003
X-Stat-Signature: krwzbwoq9z4n8hckpq1dyqftdufeyd33
X-Rspam-User: 
X-HE-Tag: 1770044254-655346
X-HE-Meta: U2FsdGVkX18pOq45eeQFKKRJyEViFxnOeFNwP4REhYNMHmwhKRhy8WFdlu2BhGl4PUoBp4uLCTHwfLTj6p1Qe5ILTeBI2Lk3gMqL6ey/d6AmPeN7+7jONdQni6GNfIR/Lq3MhfDJln0iIMqpWN31opJYJ9H050LaFOCCpOYxa+ngbcrFc1azObnuDFKD+rLr0es0p8nbZkfWux4rDGV7ATtLNuZvgdosQ5RoX7L8Y6O1MEYIwjI6n0WPsVI52vzKWY8qduXnvN6l8b6gAFITmoBjX2QKqZyNZetYN9kuR7VEh/Lwxga+4nxGokGpyJWE1rM0rJKa7hjRBCWAIFn4Auf5Tn23HegiRVPRunL0ZZgFy6cZl8oWLaoWMijkuigA3poSFTL0rkiGSOEDA/DOyW8k32GWX236BcyoshH9zJYfyl91IrkJiLBEwhRIs3ZWNHLHKoytwMZqNqv7dz4rP9Cq0ofZ9Kv3HSiBkEL+e/0WPnVoRc9zibJVCG5gxS3AQ4j8uVyDjiYegPRpSLolZO71urt3p8K21pB0hqzTKSTVdVYPxXSZcWz+FcXMG/yyuV0SBLooyxSCRfmik7DAfKjbxYBgA0c857otwUKUgV1yzKz09vw22MPdP9xY+PUGGaeYCglZmuiher92dHyFCvrkv2M4lWcQm7ZwRR6JDa2nXIibU6JtPMSusBXw+Kwp5wag+ve58YfBPcdS4arxVJ3nWRdwqLL0g2JI2jqAP/43up4X1CdEw4Kaz2DzC5/vdk5JjHAaouxDXqtb5a/aAV/NG0adhFygYsfPGCjNPmaJaOjcudHeC3UVqYJn0Sh8S53iK4C/qBxxWYvb64j1bX5gE0lEju1mcI6qdHNAewMvPP7XY6Y0BXVhMnRyy3lL3Ij/CS45VrVeBwBplaUHcfFGkkvKRYqXmqMqcRSIrZhNrXw6OklneIBpj36P2DLY8fS+ptNIF9pEaEn8+Iz
 NpMJYAU9
 1976LMEb5FpuUpQJSUB8MnCinBEhMjnIKVrLoTojJ8ldEuOzzOeql0GTYvYh3l+daB4ZJnNAOHD2lH67ewazPJd+BVXQMvK7gRhAzeevjJvZGodVDe6vRruyGd+UxGn8w2xQMHIOX7O1wWOhdKjpdgI2GUl/CJfmtDAzNvVoJRei9lPUkUtFkugFnLwZAws7cPdOFnnIrKVrr/xYzZuc+j6LdsMpUTq/B0SEI7o02vvYHLM2dnGyB1kClAYdJ1ASJbe50
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

* Support for huge pages collapse, which will be used by
  dynamic_hugepages module.

* Include the new module for compilation

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 include/linux/damon.h | 1 +
 mm/damon/Kconfig      | 7 +++++++
 mm/damon/Makefile     | 1 +
 mm/damon/vaddr.c      | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3813373a9200..de5a994f92c2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -142,6 +142,7 @@ enum damos_action {
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
 	DAMOS_MIGRATE_COLD,
+	DAMOS_COLLAPSE,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
 	NR_DAMOS_ACTIONS,
 };
diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 8c868f7035fc..2355aacb6d12 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -110,4 +110,11 @@ config DAMON_STAT_ENABLED_DEFAULT
 	  Whether to enable DAMON_STAT by default.  Users can disable it in
 	  boot or runtime using its 'enabled' parameter.
 
+config DAMON_HOT_HUGEPAGE
+	bool "Build DAMON-based collapse of hot regions (DAMON_HOT_HUGEPAGES)"
+	depends on DAMON_VADDR
+	help
+	 Collapse hot region into huge pages. Hot regions are determined by
+	 DAMON-based sampling
+
 endmenu
diff --git a/mm/damon/Makefile b/mm/damon/Makefile
index d8d6bf5f8bff..998bddc17819 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
 obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
 obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
+obj-$(CONFIG_DAMON_HOT_HUGEPAGE)	+= modules-common.o dynamic_hugepages.o
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 23ed738a0bd6..4acbc1a6a5be 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -970,6 +970,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_NOHUGEPAGE:
 		madv_action = MADV_NOHUGEPAGE;
 		break;
+	case DAMOS_COLLAPSE:
+		madv_action = MADV_COLLAPSE;
+		break;
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
-- 
2.43.0


