Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42407F53D88
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9996B0301; Mon, 16 Mar 2026 14:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6972B6B0304; Mon, 16 Mar 2026 14:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F356B0309; Mon, 16 Mar 2026 14:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 438586B0301
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:39:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3B861A042C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:39:31 +0000 (UTC)
X-FDA: 84552789342.23.47F939C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id E82E0100010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:39:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773686370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=0CB5GKudPiGYyuQiFI2pYiORxmDKYtzN3F5Yz48Q8uw=;
	b=6s3ku4Cve8yDl6/5uxkOpoa+eS40Gksbz6FknoCbsPv6ksTCaA/z3kQYwLdgBlIBPqOR5x
	bkvsyGTWpDMlZey6ZylW5L8xKhERiChzdQukpA8rkUwsamocYKBNywNxaTXioCQZXaTm4G
	JDxovH7qp5O5JgYPiA+BMjx5lOq2VBI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773686370; a=rsa-sha256;
	cv=none;
	b=K4A3kt3pZSdp6ViImM6Gx7U0UL4Ab6mvkVzY8SUVBnjaPWXnRWRLwo1pBtovMvFkO3JgXk
	plhO+ODDLRCYSvkQyxXMSERcBXKNh7dmO1ZqMPFG1JO59Ss4IOh2AljfqH61Fq96L0Abvt
	/a54bSPke8sH+5g4wy0gSrJO29bilKU=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZP4p6stTzHnGfH;
	Tue, 17 Mar 2026 02:39:06 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 042C140584;
	Tue, 17 Mar 2026 02:39:25 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 21:39:24 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Mon, 16 Mar 2026 18:38:05 +0000
Message-ID: <20260316183805.2090297-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E82E0100010
X-Stat-Signature: a7hc1djh5b9jjzjymqntfaxbdudfnmd1
X-Rspam-User: 
X-HE-Tag: 1773686368-819783
X-HE-Meta: U2FsdGVkX19/IAEThoYOHmJBYPfEX+sYd8pumWCiWaG+QEKuHyv08zQeJ9QoLAe/IJyYxNoZM6x/JEcHykwKM9ZZCFyz0yGMNe72mdsgGV45K3tQe9DajeXfBYqP1F24ED/ZyA78o4VU49ZVuOfQ/hgfX3p86uHJiALY+x37J1lvXkS8ufv5YnmGcl6VjUJ2Gs3l1cxn2tQeAXJHE5lBr5xr82tW36xhPtiG4Nxt30KJP6yUGTWczY7+ZElSHtQT7fOuPuSdJ3GJbjEYS357iqNxz9shljf88Vhc2DGNVVhydGPeMk0cETGfknwCme3VcWg7/8vXJobgbiWEnbwB7vb2jcQ6DcyU5IZUdILk9d7F9YVQixtd6+HXxhVULhHlqgiG9oa1HRAF9IJWadx8Z3T+6HKk3L1tjLgkrz6axP8SR9j5iTWENV8dv1Bzk6Jj+SHT72tb7nMtYxZElzewk8ihNw0pTADnx5nr3XfLQUhLWgkT5HS24m4NTL+l/H/L+OX4Dq3vqCEJNTYVjrj/UUhCjBT5AIjHH1yw/UmH9G/bEtgUCxKCCyz+GnJqK4eqrOzvdrVtw4ymrIlXVHcPVh1memGw0MkbKlHT0+YXFiL35EeS8JjuH/gDCRlneb+jeSywQ+oA+kql6BVgf87IdqQDxE63UEhreT6HS5ZgtB00Ogkn8i+n96/D6CWS1H9prIdLvFMzS+FqiySeK4YH/+5y78780tihs36DDodh3FRNCcwHhKy3UxnhlM7iHvkwDx2CFHUzQ+CsyPKlXMee9b2DOzXbbnLb8mk3Mh8XPtzSqqgEnHXR+cw3LnGvmpz7pf04S9ydNgrbZMpJwGZruhfHtYs+LoKqcfPknmzzaL8cX8xdPS58sugRA7tVPo4pAPq3WOmSFzK4pLJ21jHkWDn2EZSuWsJEcrpp/XKsKpjhFf9p767vwxEzX95dA0WEr7Y/uGiePJ6tEvZiUlk
 R1CzOJ9u
 oqFOz/sdpZ//bxTg/4O7m6ufroxOlg9XT87NRqsNj83UJDL+xJZR7/DJPAh2VeNvCf+JyWvBUi4lus/9FE0Mt1M1y8PLQne9F3GuGQskzgbbYT8EdGesRTtAxyjkIomY8+P/J+yxLjFpjdOojSppFkuCmFYbCnpv8AS8SQaI6dOJbxx8uUP3xUe/eog8M0g/8Wy13Rwno5nlA9Hbn+mCbBcKQ5h3mNCjkFKLsNCC9RbUlFT/T+rRRd9EsSPwh7C1ywU+bvGpSzLqKtPKPeB8w+aQvWjoWxRPoDrbMNfkj4Fza6Ec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

This patch set introces a new action: DAMOS_COLLAPSE.

For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
working, since it relies on hugepage_madvise to add a new slot. This
slot should be picked up by khugepaged and eventually collapse (or
not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
enabled, khugepaged will not be working, and therefore no collapse
will happen.

DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
the address range synchronously.

This new action may be required to support autotuning with hugepage as
a goal.

[1] https://lore.kernel.org/lkml/20260314165156.86647-1-sj@kernel.org/

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++++
 include/linux/damon.h             | 1 +
 mm/damon/sysfs-schemes.c          | 4 ++++
 mm/damon/vaddr.c                  | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 29fff20b3c2a..3b1461f42987 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -463,6 +463,10 @@ that supports each action are as below.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``collapse``: Call ``madvise()`` for the region with ``MADV_COLLAPSE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``lru_prio``: Prioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3a441fbca170..6720dc70c487 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -140,6 +140,7 @@ enum damos_action {
 	DAMOS_PAGEOUT,
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
+	DAMOS_COLLAPSE,
 	DAMOS_LRU_PRIO,
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5186966dafb3..aa08a8f885fb 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2041,6 +2041,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 		.action = DAMOS_NOHUGEPAGE,
 		.name = "nohugepage",
 	},
+	{
+		.action = DAMOS_COLLAPSE,
+		.name = "collapse",
+	},
 	{
 		.action = DAMOS_LRU_PRIO,
 		.name = "lru_prio",
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b069dbc7e3d2..dd5f2d7027ac 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -903,6 +903,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
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


