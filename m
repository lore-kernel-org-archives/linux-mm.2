Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFE2C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C5A6B008C; Tue, 14 Jul 2026 11:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534256B0096; Tue, 14 Jul 2026 11:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D846B009B; Tue, 14 Jul 2026 11:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9056B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:02:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C94240421
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:02:46 +0000 (UTC)
X-FDA: 84987699132.29.E2E1664
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2143040013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:02:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=qPFJWhnh;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784041364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IT/yVAiDabUqiE4USPZqQnbFTAYiEWdtK+BgXtb/JJ0=;
	b=gt9fp0jy6OuzL/0gzs+ve87/LAWsHDiAR1kfZJWVbJq/qhO1eeNjvQu4aaI+mr1Lkn3WpI
	7BuJevhuZmf3qUO+dgyuhLP3Lyex6DFrIsVFCkhNJso69dv3iZtd2aA6nC+a0X25vtatD+
	AbofNQT5/hIzOAXXvty9rrhP4hH8U0I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=qPFJWhnh;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784041364;
	b=VhQRVfAd8Af7A3s6KJtjsN3qg1O+mCikqpIoRz4t7JPQi14rOv/ZGrWkK9wrWvbpFNrokH
	q8j5oumKNhmryQdBpJXb2QtWblizuDw1J7yhuZ54lf2uPlplsMoiN5ynLxpuoQCX5b/uPs
	b6S1MTnjABmscMEhJD2EfF3+P5WlgFk=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IT/yVAiDabUqiE4USPZqQnbFTAYiEWdtK+BgXtb/JJ0=;
	b=qPFJWhnhyCVI3xBc8dOhh1yOmaVoHfxNx4zX6UxJlqAqLHXI3S6qXQWbaNnx2fwSovqHzzykP
	BtsRjfeiDMCqW4QQF30+RAjh8kFULQnsvz+/IeDokWhUj6cJnpipsXCfu4VhnKKmDafh06ZXDXh
	223hBGHDuMpRVxVi0yP6KgM=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h02bW5K4BzJ46b4;
	Tue, 14 Jul 2026 23:02:31 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 85AC340584;
	Tue, 14 Jul 2026 23:02:40 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Jul 2026 18:02:40 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<zuoze1@huawei.com>, <damon@lists.linux.dev>, <sj@kernel.org>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH v2 3/3] Docs/mm/damon/design: Document hugepage_mem_bp target metric
Date: Tue, 14 Jul 2026 15:01:16 +0000
Message-ID: <20260714150116.382521-4-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714150116.382521-1-gutierrez.asier@huawei-partners.com>
References: <20260714150116.382521-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: cmgn3zj3imqtob9pqfjne7ow76wec7w1
X-Rspamd-Queue-Id: 2143040013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784041363-239146
X-HE-Meta: U2FsdGVkX1+qz12nbFQ+E2upk752zxrc8E2APC1366KjaV6inBpL1JIwb7wX/4Y48yZQm7SDdRoUJgp3UZoMRT/MMbpnC6vUDsp/TVgxHYRbDcBb7rWwfiSP5UsztV+TkeH08K2zGSyXZv/dQrbeslYdqgexc+q3UEcHvZbv2NIwOw1CUI9CJD77+1ylb0tth1f/q1oH+LUMpTxy2NZ+k3TytDgcSRQJAYsjSKtMEi0ahVjd1CTi3YRVoSMOonSmhFLa3ZBAT3Q/Zaj3/AOgZaN4SWd9oHIVu5H6VY40rtONw6lFfllLh5pyF+8aNtzqGm/hkBWmNh0UxXyRkietsobNDOEVW8qfuasyRSs8bvU5R3nWME8SDh31lzLWujHSpDWH5VQx6ICJjmqfVmCxvvjax/mci6QcyCayyDjnWx3uFDteKpyUlX/GLf9nnS3jSJt5IwWv7gWUvbjuCNH6TjF+FsNzMZjpogzn+iDOsSf6VDUYL3CfwQMiZ2TH6yUta7G+sKqtGuOgQMruYPJ9YsWQfPOXPSmhITmxe638/AiM3tF/CJZH6uUtq1GzwuYclGZYhsARWOwv0waBCPO2KQziq0VK/0/hd71MmGIwY9wRILTJ5DrgfHTUzXf4NObTTmBPRWZXEOylVxGya98emwUKObhPmLcRdvBUEmIJTh6WStBMRnntWh/XObLKpl/waNz5PVpfM9k1E9r0GfL3ffehbWkMSt0cwAe/5ZvgmGIbElP/u8dU9FoTlC3uHh4loOPUxCziUP5M54hh/lAVaYeEO0p2ICSrQprepDTWMnsUWYMwJGVv3WmVjPzS1meceqRbjLOZSM2qyhdAjyFwYlbMrHjjltbq/pW9eG3CNmpTi2pLdlcxmZnLpXsU4X78wHC7QjS6MpDHkO+8eZA+qo/sr/Tk0Y+3Ez8lYHJ71NVbd7cYFMMFMGTyfVmDOt1pBOiNpcfkdHiAyfwQHeP
 hpzf2Uq+
 Efg3rEM1k8HC8pvJ044ck2BSVKpE9Z9dQZVs8Dw6DIBSsZl2fdcZ+TYStrJmqnnJaL8pzoNabRHYfW7ooPphNbDZZ/0egGy3Pnq4nXwgnSmvoFvHXBmFxB/hyklg6iKf/xX7pI03K2JFswHr6vgAsDgDlMcT2chYWYpbBTagONPMN507HHYd6GECc7r7fKoCKHxCGZ8gfaxMAQ8cS3KcEHsY7GtNXkCQynKyzhEaMBU9efKgRXWOw/nfzuNNiERyPBSZQsSiYLjkCErnL3GT8VwL19mpC8kvcbQlYr1AxKFXs0OTT3ekmHCjJnRQlH3VaBCIjE+ib0W23f/85mCjgr3PwJ1hSmW0tn+BQeALNXjW+BQ4bKjIoMmpTWxemYkChAuA4ktshVcifnbei90iLMr5fnk6lDwGcS070qgMGxq0fGtDUDmVc6cuT0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Document huge_mem_bp metric exposed by sysfs.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2da7ca0d3d17..34d940a13a85 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -686,6 +686,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   (1/10,000).
 - ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
   bp (1/10,000).
+- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
+  (1/10,000).
 
 ``nid`` is optionally required for only ``node_mem_used_bp``,
 ``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
-- 
2.43.0


