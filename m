Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F411CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539A78E002D; Thu, 21 Aug 2025 07:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2DC8E0030; Thu, 21 Aug 2025 07:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315D98E002D; Thu, 21 Aug 2025 07:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4BB8E002A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0A4C117786
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:24 +0000 (UTC)
X-FDA: 83800485888.19.BCF797D
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6FAE81C000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TovJbRcHxafgJJBskPVUJDgeJScVJY2MEKqQK2bUCNU=;
	b=Ede6jLnLuWg9OZ8Z8u3eVdLpGtajj0oous9JXabkk2ZdIhwYOTWHGutliM3nY93oiUZOQY
	FH8PpcU/VZTQ1sw/HYoSpKE3F/ufIs04IrZgvacb61hn//CBl/OW7eDw2mKTo2hCcE08Qc
	010/gfPDEicPkfDfMOfPWhPny4HMYbU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774383; a=rsa-sha256;
	cv=none;
	b=2+1TdebKwCS0H6zvhNuQcBC2N0Knij0RmdVwrFoGicYOyY5GivdR7j9nLGJePrkR84l8Pf
	GShVHa95rETSp9ZryTpX64Ekrp1GwB01w1K6PQBIrCmo/twd9Po0d9APoitB0mkECfk+Cu
	cH0c/PNbQxBLTlL4EO9F2pDgFK2ySW0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c70rT0CPQz27jH5;
	Thu, 21 Aug 2025 19:06:49 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 821041400DA;
	Thu, 21 Aug 2025 19:05:43 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:42 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 01/11] mm/damon/core: add damon_ctx->addr_unit
Date: Thu, 21 Aug 2025 18:51:49 +0800
Message-ID: <20250821105159.2503894-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6FAE81C000D
X-Stat-Signature: gts5yyeutts3moyhp46mfbayrid1sywn
X-HE-Tag: 1755774381-750109
X-HE-Meta: U2FsdGVkX19cSupIz2jzjHqQWNo5r9joFsi+dSscQ9fFtuF5IMzpQ6HgT65ZOs26nZz3RchIlQXI3ptjSeUTngL7fmbnQRRu8boHoPjiwFIaOLJB2yFOXr21UCp/9A4rUh0CMww34C3uNEonXgxLSYLWH/k69cusFxdwa+dpt8oDbFwzKSwbRY7Rqmu4mvBW5IPeXoS8rEuvzn6kzrSIa6ezEn6F/FwEvKhPwNNg9hcMfkoR6io5D9eh5DeID4lsKEqY7/ofji0ERswf8AdSmOrPTIUpM3fyH2OcDkQ05g2EdZSbczIzsAizVWt8QObX13efAcS5C9XsTLKO5/iOhWcI90hnT+MUuzLWWrBwJB5FXtNy/4Wrcdkg4fzrGfWxz286I+fqiNS1sFAymj/GbNt3ltr/Ojpy5ii7AXqEZ4fPGMVrV/pXCwRIM0wdwdEMO6TUMCjEBoQFJ6uj4d7KjFjibuMKMxC4sjTo9epzbTr7HLJBNQ5yhyR3RVyn03lbNAl9NqlMma4wHoV0WwxEGhUUfRVjLpsRtshGUusyJzT+VtBfpPte8ev/aK1HXGCoybvKZCJnv8Q5qmkrd6fbviLP5oOozGgaz+xv1GOiVGX/7jq+TGlkQFZphTvjhtj50s6OdXm3NyD/mQu3DPBg1NJgFjSW4z2HSGzfZlIS2grebyxtp8P1LepDvCma8FH7Zx+xcsaOqYg636C960Ss+VzKksTVrRLPpclV4uwSh4ZmBo2U7E8XjJV48WwLbaRiTQgawfWiWGFvgigkgmgM9x/u7BJPTn9Lgt0d++PDHeWVAiJ3imIKPF7dApwE3tjZTnuG6jGr7sNCxebz+Mqix23I1hSCmjBqWToG3WtdlKUknFmMqidh42S5MkZat5p2OYY5CGof+ANUjdPQSNB70hevoDSMUaLrnKfvrsh2ILTWkUFVvCqtU/IrLXYRpdV9FeV4xsHXgpogLFa93em
 XUWHn3cc
 XkMvmVSoyQwV0PKkmS5CEJdc0Dbo9YY545Cn1j2wDT/CGkasnefs3Q7/+Vwyw+2hnaKqRQicCHfpjQZf2S7VproyhB5ic7hYDL6fduw1CjO7h++tJLRcgCOatSrSuqyWjRxviqpXqXRNnI4EHrbqyWsO2rPEO247QQuxnkR1vbzXbE5hGmV20+RMIIwrqcZuAAcHJqYdXcfrPoZMJLhGCPldHp8vA2y3O0g38H1Xb0TTxYk+sNWVVgEDbWuyndGiiAf5y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

In some cases, some of the real address that handled by the underlying
operations set cannot be handled by DAMON since it uses only 'unsinged
long' as the address type.  Using DAMON for physical address space
monitoring of 32 bit ARM devices with large physical address extension
(LPAE) is one example[1].

Add a parameter name 'addr_unit' to core layer to help such cases.
DAMON core API callers can set it as the scale factor that will be used
by the operations set for translating the core layer's addresses to the
real address by multiplying the parameter value to the core layer
address.  Support of the parameter is up to each operations set layer.
The support from the physical address space operations set (paddr) will
be added with following commits.

[1] https://lore.kernel.org/20250408075553.959388-1-zuoze1@huawei.com

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 include/linux/damon.h | 3 ++-
 mm/damon/core.c       | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d01bfee80bd6..6fa52f7495d9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -746,7 +746,7 @@ struct damon_attrs {
  * Accesses to other fields must be protected by themselves.
  *
  * @ops:	Set of monitoring operations for given use cases.
- *
+ * @addr_unit:	Scale factor for core to ops address conversion.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -788,6 +788,7 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 	struct damon_operations ops;
+	unsigned long addr_unit;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index cb41fddca78c..8f8aa84953ac 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -544,6 +544,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	ctx->addr_unit = 1;
+
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
@@ -1245,6 +1247,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 			return err;
 	}
 	dst->ops = src->ops;
+	dst->addr_unit = src->addr_unit;
 
 	return 0;
 }
-- 
2.43.0


