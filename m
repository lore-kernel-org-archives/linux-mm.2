Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DC4CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EFF8E002F; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EBF8E002D; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833F78E002F; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68BE18E0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 150851DD07C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:11 +0000 (UTC)
X-FDA: 83796438222.22.5074B55
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C6854000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TovJbRcHxafgJJBskPVUJDgeJScVJY2MEKqQK2bUCNU=;
	b=45gjwE9XPuVPi95UpDkFaosnecgpzrPhhqPQ7EZiiRxHQV8e+wWyhkFubdr5w0r0ZnspSG
	lkG1kjgQ7MIftnEO3KOsxs1AkS1U+pRt3fe84P6wN1fps8vXBks7zVdlgDIpsyypqUDQSA
	41JvlQ+xoVQHOre7g9lJm3UGFc/olcc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678009; a=rsa-sha256;
	cv=none;
	b=8KADlssK5slt8GcMFXhRhVeAO3D35LStq1RHZtis9HfbO6tMlWAqONI3A/gcc2uhIlG9Ej
	+hYc/T9jyRQsx82o6U4jIXhPOWREcYBQCJC55FjAMTMs3l5khcwPDsE4eLCSUzeWk+CbOi
	HLoVWxm1L2jBOLTvkhsOzXjstrY0wpk=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c6K5S5WxQzdc5R;
	Wed, 20 Aug 2025 16:15:40 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id BD65418007F;
	Wed, 20 Aug 2025 16:20:03 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:03 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 01/12] mm/damon/core: add damon_ctx->addr_unit
Date: Wed, 20 Aug 2025 16:06:11 +0800
Message-ID: <20250820080623.3799131-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: npn5fw51wbx51a7ra7atj1z811assjjk
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C6854000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755678008-652178
X-HE-Meta: U2FsdGVkX1+OOX9ALhCE78pnlON1tU/FOF9T4GY5M196swgqPYm4xJiq+Uuud9RakKhkmRbH18Sfu8uzfbGppgLmReZJUDpw94rdzHp/v5UeeK1mFPQ7kOWozC5iSz7ol+Oq4wW7galW3gYXtNkeJ3o3KzYCH9UGm+g6z1AUeqk6iPz0nD9c/nSJr/V1n2GaeSG1EwW5pK2NXVR/ZMYXvSGYMXivzwK6oXb7sdYmKZIBxWWyfb9U+Giurnyuqlmen9oadmDbJ6iQhWsQu6ePvmM3fpCszJelQ1ob0OH9asscar91/mR6FxEyt6JZsH4wz4DEny0x2FrfzJIAzeprAmzw+cgWMzq2fW+zkrMM4TinNnBgNgMhUK9Hy+OC4cN9giTxaiLizlpE4vPSfd0Mvpwi0tCTMov98e/weqEYmDCYsyRheos5F9D7co9zTB/3iRcoM5V3FEo+Ti76b8z+riEhJed7kqMYVgov4hMBmpvG/NR3UnVsvIn7REqGiiDxUeGo7tXkU0gIcQ3YMugSErJ0urHazUiSrqAEyItXkTzPJXK+E+bO1RIHwtF4x889hJzzzHkWHLpKFY1tYtecqEqSwRDODNokoyF5jiDTg/ODadHJMj7lI1HTyXCu9+paiGtDiCuhC8TLPM3VlViFzmEZLGVDsgO7D9Os1ZQObdqcy6yL8qQxW82uMxOWxZiVLvd7XGqJhEY2xOMDtAHutGgAp9NUpguLLThyHoHgVXqztlt+kpL+g96qnJdu2KC5LiNSVWoLS/nE7hklZm+HGXDT9N5LuXhG9BWiHucoaLDBdSYkZpXWOSyFMGx2VAboF9Tl0TWyX4bMMxgVN5zKv46UnlHaT4+W4LSy0JL8ZhDW5oT8FJGji+BoAZCSs8CbLcc56cxFW8um1k+HQUSOE9jW9K24u4LyI3ULBnhidn7j3F0sEYlFIUb1QQ8O/JlUbRkqYncHtn9JUFGEtVA
 4LGofc/L
 3jdRC7JCc0bOvx2HnrnBBOY66iQb0DVz85OXf1JhZuYfO56PEF//rKdrVmHYxzqrEe/RairUpEDmMQkH9OVpjumelFehkJkQsXuN4OfPhzoNQZ9dK7m+UomD2zFUTnIYd6z+fzGrPmk071RKUsAlVYEQVV5I+ntW9AGTRSkvFEwYdIvNcNoKzcbP9+Dv+po86qg4+OSbTYPCM5cIDKDOEEMZtQT5GkBOf7y6sxZWKga5d6m3BlRz8c/0Jov7wQGI8oS/r
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


