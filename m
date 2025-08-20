Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8270FCA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945DF8E0033; Wed, 20 Aug 2025 04:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6548E002D; Wed, 20 Aug 2025 04:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E648E0033; Wed, 20 Aug 2025 04:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3478E002D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34A4E1403D3
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:13 +0000 (UTC)
X-FDA: 83796438306.26.3593828
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04E6AC0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mX++GZdmc6UWUYIFpTUepiEZ7h0iUQtlSO7KiQSQJrs=;
	b=alZ4A4Wyl85qd40Lxm12uTxUc8ThYdiobVzltS2P3uF+HVW9lITPu36mk32x/QRb54+oQB
	mUfXomzdrsfeRPIqN7N0WWP469fSf52f9OgGcubD0lUTYAlzF8eihAykZdIhrlqvkjp5JM
	6vTZlcT39DuYxcP59bg+OQz+WWoWZ1I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678011; a=rsa-sha256;
	cv=none;
	b=pubwTlYyyciOzbvvVtsDKa1/989LMSNAZDYTligYGXM0dn2W0kapbo8POgcduBFNzusEcW
	UMK/pgJA6bFMLji+CVYBJ1M4VG6Rvgq8IEWV+yuEZlqtn9JZL33ZxhFJklMGRZ2WnoeYh0
	f/62NYMqn/PSMlH8rwqeA347bNMFftM=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c6K5J0YcCzPqYd;
	Wed, 20 Aug 2025 16:15:32 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id EE2B4140123;
	Wed, 20 Aug 2025 16:20:07 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:07 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 08/12] Docs/mm/damon/design: document 'address unit' parameter
Date: Wed, 20 Aug 2025 16:06:18 +0800
Message-ID: <20250820080623.3799131-9-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: 1eg1rehz9mko4rnamfhe5iu8uma11b4k
X-Rspam-User: 
X-Rspamd-Queue-Id: 04E6AC0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755678010-343248
X-HE-Meta: U2FsdGVkX1/HF2Qh6U2qJZOcB1jD53+bfIGkdl8o6J1n7faXyfIFMV5ypuI1fjFIaGL6Z8uucgN0qwcjoqL2j4z1KVcr6II+a68Eg9Bdv0OoOBS3w0JYp4RRYF9D68dRnflpRUGwHILzul0S9PtalU1vO5TSmEV1EPmSfVG36bpX78ovi0/hV+Vee8YxJjQt3f5u3pWLdQufwXhkIPY+LG394V32D4cOLBtIh8m39V0PEh01uYEcOC17Z4R3J7LMD3S/BHbxjo7yipnHNcL4VpGYmp7vXzihUrt+W+2Dkq1IUbtQTt1jztSlI+vFMzZPMCqVufF9thZWnEkzMoSQKwSITyyopiRHk0QQgyHYV5r/QRHqufJgnwfXfwCRG9WJsZ6ikRH9oB8J2uKkj4aZachvc/ls4T3iJekHV2ErWflO5Za6GyTGRkKm3YcOUHPBop2dAVx7tgAgvGnU+vKj8YXmM/H4loe3KLQO6/ExobZk7Zkf7RGS4KGIzw3I1WErsbsG1HGHFwepkJD5INhY9btZZLTBgFULVs+hfMlGq/eMnfh0kB/8PrepC6ONUT9+wBo1bS5fgrabdekSl5/8P1OYFgarb549Gr70gUZFazG6TQrqQhYk7cv7u/4dBP1+cAwzuc8W6jtPwyB5DJqgIlLwocWoGW+h7OkwfbnS4i29AVY3mMO82oIZlju53dHnfmBkl2I3NA+3O7Id9iLfAXBCq2wXmx8MFF+j1WgSmZmUBN6CQItOPeQmYq4TyQLx+CwxWcYyjjJYvxMmPC7lw7wg1HDoeZjoOQzKQsK2W9E3X9x1DzTy4Aq/KmdINvAK13Fb57eB+urbk1MviotMd4dWzh+PAZquVcuy34alC0F9nNYaxMavytSpFCZ35slgM8nOqpj9CE8R4Yu2CjFHVqDA5aF0gPYZMV+HTznE/ayvcCBvkbbfABUOsUBYGsjNnogUqCB98Wxh1PYn8lM
 FyaS2UjC
 X6Awe7DwmPG82ALWcM9CFIJlHSiBWzEHLVXTvWc3CsKRcXykbOD+Ei60tZbl4C5K6IWWtSWgCKRbx1f2FIfNLbbhRjVZstP4dmMyeBakdwA/0xdOYBkL/iyplO7gzhhbEcJYRy7GX2wnCW16A83C8bMnb55wOw1nriqqGRgII4AmBaLluhYSKrui98fvYQQuoxqGkRtZv9w9ZzMywnjsTczhthA==
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


