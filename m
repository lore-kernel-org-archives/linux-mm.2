Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FD3CA0FE1
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725858E0056; Fri, 22 Aug 2025 05:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663A98E0088; Fri, 22 Aug 2025 05:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263678E0086; Fri, 22 Aug 2025 05:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E5BB08E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A47BC1606E7
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:13 +0000 (UTC)
X-FDA: 83803917666.20.0D5AA51
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8488B4000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qr8LwLgwp5jRzny/RKHZHN7klL+M0TjylUTPDMze4OM=;
	b=t2naCMmEI6RQhAt8v2wJhN2WtioFnV5jNiL7F+nrcVrMQxtmzwI/LmO0glFYMkhL+BN6Kn
	rpMj01PKsp/tvNuP+Qn0+cTioZnDXH92I/YM0TMuu3IFMWTKkAbHX0k0oXwBYYFERIgJX8
	DICWHwYExJLth7pAGF+gQqRK9tE668A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856092; a=rsa-sha256;
	cv=none;
	b=H/Y9DDuBncCzMH9p+ncOiV/DBRWDteE8zTS07+ulPtachNraH0ikJvYiT4goHERV93cW8z
	3SGbhrBV38fgCOpkkzIS8waS00D6ZN9VKl8zVlfbVJqGdD8Bc01HuiZXYXgR9EpyV7s1Ms
	R9OHj7nBrOhS4EFa+FM5V2bBWUnbZUs=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c7Zxt4M4fzPqM9;
	Fri, 22 Aug 2025 17:43:30 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 8DC7F180080;
	Fri, 22 Aug 2025 17:48:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:05 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 01/11] mm/damon/core: add damon_ctx->addr_unit
Date: Fri, 22 Aug 2025 17:34:09 +0800
Message-ID: <20250822093420.2103803-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 8488B4000F
X-Rspam-User: 
X-Stat-Signature: pcnnjf814wotysd6gged87j38wzw6ngw
X-Rspamd-Server: rspam09
X-HE-Tag: 1755856091-759624
X-HE-Meta: U2FsdGVkX19c5qRBlIZ9G4nVTkrAFhYh5nirxHQd2kMj7W6DMBPH29QPlkTvNaPAtqMXgzS+0dlmrXhRuuJke7gv8LupCoiT5Qpuo+Ib2G8zHyj4fvlKQxWHVfqewAGUW3NEnfWqbCydYIxgozq9B47rwR4SqoSxs60Ux2lz8yz1uvhsR3TEmfRjt9KWOwPIomiTfeAw04mfShYFyS5uyrRJBA6oAfZM2sylZUFFzhPTXX66eZfpZvW9uJULBoiG9zPzXyXs1A0GhdCjMHH3RKnxtob1o/P57/H2gbmIp5JDJKc4P5qHVxQrRub2S+V7pARWFvtCWe+t7yyKGOzm4lotUzOPZ+Cd1iQjUPmo1hFXGjwdSMNhOwgKhjxIA9szszeyZVcTYi3EfiRYqU0mKgG+BjCKPppvV+ApLuvu3u56XIEM+crEByjC0T+Ss0EuDzapHcfV9DKBRDz02ixKBsaypfpIiGmct69tmdCu/seyVgc+jVjNrd0r4wN7LM4DF5+ZRRN0JchqMTI6UdP365z+alxKqsdMSgQIhF5z3/I6I8dx0sR1XMFOn0ONEsyBJq9RBARGuiK33p62X0v7oTUklRy/fwDbHiARc2QjoFYgrqqpiVmL/xmDQu4+/eBUiwPWbqMkAUBv4Ms7jeZRb0Izl8a0uxSw+ICZ2cDoWl/DV/kQbE8lyuQ29W5X9k9O8IhleB9ZRWnkhLuT658iDtp4ZgZE8KCvxhQgvUlvi/S24dMFA2pSsN397aYPUgR6mY+t97opHXpB/5zA9dFD0+zP6a7Lj8tXH1vRUYx8HlB3a7pcuD9sSy5bFnj2gR2yShH2mnfq/QXa5rqEN1h8JI7cI6qaqCM2Fcx/5Yjz5eKGAneHhkCiRGdax1+lj4EPfSd2gWMTMYkKiXpT3NPOJYfySg6YK0jSaV9eRYKO5A3brJSR8Eqp1I12JpitMfxUVJGZp3oP4vBejXC6cle
 Nw5XEtSF
 ytQiphTOZoTcXdlH35YhZBlF0+xrWj14Bg6NQfjhqO2Zr8j0aR6gNK0aH8VRWMtZ/seli4fexFpMwb/Y/quahLmNKmSSM3+3dtqn45a2R+N/7DZg95rIlPLM3yQGfp3M+F50ZKMHoOpW7NtOa0UCcfzVSaliRTyEX5brhXpNLMPK8DyPY+H1HOh8/zMJLFp9JgRzg8bGRFwMYo6G+JvFaTyJG7NHKQz7Ueo50bRXcJsLKTIv3q596L9gZyjrv/36ULrx4
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
Reviewed-by: SeongJae Park <sj@kernel.org>
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


