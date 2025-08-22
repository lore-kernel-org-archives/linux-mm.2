Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD629CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8C78E008E; Fri, 22 Aug 2025 05:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A8D8E008C; Fri, 22 Aug 2025 05:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB6C8E008E; Fri, 22 Aug 2025 05:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B53428E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8889183D8E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:17 +0000 (UTC)
X-FDA: 83803917834.19.2800409
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf13.hostedemail.com (Postfix) with ESMTP id 617B220007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=13Tur2gWNLiTMVq1r5t5oC8tMwxDZ2/wrMfAMFdnyrg=;
	b=ZBrUsy1qpzaVSKdcD3YpALlIwp00qY13O/MQBzyLb/y9D4jKhgeDjwSYbgZOAZ8WdQmxR6
	JHqaHsEx8Iae4LDGwqnbKQmNLYUhUPtYnJevuOsBIAlWX1dRHvJTgljC3yqY+YimgtQdLF
	5Lm9tTonVkfwuZ4N3MQJf7OBMVOrFiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856095; a=rsa-sha256;
	cv=none;
	b=BKPtrYJdS+Jx2SbjgmpBXLw4SbUUFLAs+dhKDwfj5dMcglUwrleBJKJSoU7Xj0syD111HV
	ADQJDt54epesnBtFf6c1GhVZYcuPh56NaVuGUZF77rTyYHf6Of98MA+JCmeXBgoQizavMB
	A9i/dmGA5rA80U9wFBUgxo0ToZkOHS0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7Zzz4d4Lz24hr6;
	Fri, 22 Aug 2025 17:45:19 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id D12B0140109;
	Fri, 22 Aug 2025 17:48:10 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:10 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 08/11] Docs/mm/damon/design: document 'address unit' parameter
Date: Fri, 22 Aug 2025 17:34:16 +0800
Message-ID: <20250822093420.2103803-9-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 617B220007
X-Stat-Signature: n3jmbjcy7wfk69kaaxya731jpg7u915z
X-HE-Tag: 1755856094-195686
X-HE-Meta: U2FsdGVkX1/O1Xto2v7Cw0Gy0DCQAy18SS8kXc8V4/qYWEGJVkSXRnpAiVSYMKcPXAyu06ExWcznSWmWqXDJ0CZa2DY+bhpvPuAcDeir5GHdz7UNXvfTSuCWUNgPGaF8rk58gdnyYirir6a7JokSp05ova8YVc9Xaw3jgrjJIz0zkxLf5sI1Zgd7vrcntNFZ6yXU27kdUPzVp3olYBStQ5Fpxg2MVmjXHhxRyDDnh5gYcaO4ZX9DKzLaOjarZ1DMmM1T0K0b1VRYCLE0EMaKUPb0yu/WzVsUTmst2qERiwuoBGakiuFkYnPs7bPpGwKPSz1MIWu17poF1g809wyQ8lrFeVxv/PPialVbjiVdRn3pOIDw6jMRLGJDIlcnSHqeuwIH6DhC79mKcgLcvAbb0inLsCUdocUuR08lpXnh3zRBuI/NLCudMG59PmbbWJpKCpi7a35hgP86+F1sXMNlvTFu8NiLkEplgNhhr3kNDMKYvzWPiTD2g2gkNEwtiPHJ0CZkt9WwOfiC+Cc4Hek1RqgMAMdMrH+SudathEnbVBvjJ1DAIqhzIrm6QRmdMHMagiTr/y7mAKjql2vbe/o22jbTygVcMT7/b7lsv/eijTFnLv+J+gENBMgLUY/h4RN/U9D8GxVEOuqRmj3WfP4wpnzEKC8bhXb8khFhrLEsuO2i0iuYervTFBk1MyzGDtAP4gVuSiNTs1BhSM/W+Ooz5qhQ86HR9Gv/Jxx/ulQy6dQ7PPKOTm8EMrMaQPt+VzUUYGnXVoktNJEq32xM6NHmgJiZN25FZghu7OuQS5Ol8E+YlyPk2Iz+E5gspVOD5hS60qi+OtFiS96sKdSUA+PqqtyWUtF8PjvgqJV73J4DDwNOFuQPPFJNhN5bKvkQXnrvEhFz9NkuKCPGIqkg2aTePYII/L48zx5Dc4I1HFiF3zAoJN8ib0FwoprWGBy7tEd01YFKfOmROSsAJWRGO33
 spyteaot
 xXVgcsAHHp6HrGyZ1gdFpHQnBmTb2dhTpAPo1+CLhheizY+flniyU0VzTHQSyJwk2T4teVPLv5HzdaqjXAIQWpEQcQZ++9cv62blxr36mcoSUVLAzdDp7gvbgHpeVgGMmgCOa7+wqca8s4geX0aczUyEUDMN5rYxH/EfDL0xWKVokn+UbqEHifA4CK6nrGJa9AnU+CIzQ5J1yFFI428YkIJl5iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add 'addr_unit' parameter description on DAMON design document.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2f6ba5c7f4c7..d9d5baa1ec87 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -67,7 +67,7 @@ processes, NUMA nodes, files, and backing memory devices would be supportable.
 Also, if some architectures or devices support special optimized access check
 features, those will be easily configurable.
 
-DAMON currently provides below three operation sets.  Below two subsections
+DAMON currently provides below three operation sets.  Below three subsections
 describe how those work.
 
  - vaddr: Monitor virtual address spaces of specific processes
@@ -135,6 +135,18 @@ the interference is the responsibility of sysadmins.  However, it solves the
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+Address Unit
+------------
+
+DAMON core layer uses ``unsinged long`` type for monitoring target address
+ranges.  In some cases, the address space for a given operations set could be
+too large to be handled with the type.  ARM (32-bit) with large physical
+address extension is an example.  For such cases, a per-operations set
+parameter called ``address unit`` is provided.  It represents the scale factor
+that need to be multiplied to the core layer's address for calculating real
+address on the given address space.  Support of ``address unit`` parameter is
+up to each operations set implementation.  ``paddr`` is the only operations set
+implementation that supports the parameter.
 
 .. _damon_core_logic:
 
-- 
2.43.0


