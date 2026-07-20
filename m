Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B43BDC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EDE6B0096; Mon, 20 Jul 2026 08:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9201C6B0098; Mon, 20 Jul 2026 08:01:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836366B0099; Mon, 20 Jul 2026 08:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55C6C6B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:01:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C73EA8015C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:01:49 +0000 (UTC)
X-FDA: 85009015938.18.A66E20B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 81F3740009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:01:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=GDnvskj1;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784548908;
	b=q16FDYKLY/OsC/B4qZAQSCdSVA+oHVWfX70ICLDMeEr+cB+dxz1HrD3VADhPWynyHDhL4n
	Z7FXxnP52Ch/ttpZfoQhNRiDTYEkWuE1iq6zROK5I7iGWJ32z4IKgB1sonmxj0Q2oOkAPT
	ok+a6S6VgBhawPeBasaiPoLIjqH5bys=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=GDnvskj1;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784548908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7VcgX5vIHVzpuEW1mQLqgVH3WPDkCDx6B6ye8bU6SE=;
	b=PH8u1DHIU+lSLfteHU9tWlimh+HcmaPRR0CUfT98laSwzuCc6okLZPSrr6wd6UECB9dkt+
	kUkEa04gzgu5aCNEV7ZO3jq1PdMQ1HpLeAw3bruTOeB+cwyJ1OvUV6vzs12OInkkuHlBs/
	DD3zKz+f8UqzqyxsGlRaQXEXav3AR8I=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=o7VcgX5vIHVzpuEW1mQLqgVH3WPDkCDx6B6ye8bU6SE=;
	b=GDnvskj1Y3CRxQwlfdqkMCVN7KbsUN9TRUXS6qtHZJL3c3/OfKyFY4YHsbTGCPrwi4pcPyBWo
	iMYDoqAfLmtTarkKKHMkjTgqop2hDVexyj09QbH0Z6FW5sxkdO+/X+WQktbMhS4lkrnB3EovgmD
	Amwn80nGqOFofRoaMRIruWs=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h3fHj6t8bzHnH5k;
	Mon, 20 Jul 2026 20:01:21 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 21FA640570;
	Mon, 20 Jul 2026 20:01:44 +0800 (CST)
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
Subject: [PATCH v3 3/3] Docs/mm/damon/design: Document hugepage_mem_bp target metric
Date: Mon, 20 Jul 2026 12:01:40 +0000
Message-ID: <20260720120140.881468-4-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720120140.881468-1-gutierrez.asier@huawei-partners.com>
References: <20260720120140.881468-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: h4a3krpujb184pw1nya1y6zmp9mat8dn
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 81F3740009
X-Rspam-User: 
X-HE-Tag: 1784548907-878885
X-HE-Meta: U2FsdGVkX1/8XQXU9DUipi76ni9ql5GX3B3gqfqyesl3blFKc3NHSdjR1MeAYTxS8FaOxxtMp9YCJKfaMrpdE4CXdIBWoHLsKOCumnggqw8lMvctXRaT8kKJ8nM/rL1neY9WsE8QV/ufw0cWuHBfJnWje5Up9KINgLK5gKqcUUUQjlk5oHa55u38tNrL7+s6uN7uBMC5FUGJUdhuLDmxBLVRj8aWtYLXNS/QP1YeGjVVkKjvVaSoXqxJ1yCyB/gTiZlqmHUyHjN56/O6vUwCatMcniu08Dhvg/EMge0Bo+LeHrlNESSQJB4QIMlzwqOXFGSSWfbgB2kxkTthxAiFBhrVDRpBb8qdDsX0GM3dihcbM/t/t007EItaWNhWdLNacgYFbC1mIxA+HKZf7WW3jifcfsrY4pIRYL7GYBVq+RysIO7dSQxuFHhC2tfV92KTzX2BSNbNarOHzdoCS9eIdvaEArhTtIUuD6AGoOA26P78WU4OX1DdfHmPllmv6KUZRUDUOmqeoZuXjO0lzO+pFpnF0AAl3lK8ovNB/Z8sUhWGV/oZlwRo0lyUG7OXoAPlaCvgOss2LwN+4C+flYtWf+DNIXiQHNzaUlA394tIVxIWlzgamCIGgV+OFJhfZRMKRRflHvWLRHodkQp2T2ZYAc/RoCb0/DAcSoeI0LG6NGSeYALka4ZqAu7sDHxU8cwNsGwi0tQKTxtYxMh0KStc5R4kWBPxZR8HO+k/qHfEXR3vhtj+E9IPe5It5wAhQhgjTCsld9uj1xGoB65ywUREmcUnkM0k9ccF2UUosJnZu2UDtmsBS6+LUhWta4svCzEcNHCKMyT/hjqurIC+tyVXhZCDqWIicudKrZOABbkp8lfGIPq6EhiGwc/x4cS4PvwIygJ1BOLTfl4lpjxCEZQU9XTPZae3NiLkLa4z9vufFhP5WVWOlg/raxl6w5lBNQbu3O8+V0X2h8ReG97MA4R
 fG0vkCMG
 P5DvhvZVxgozm+g7Hp+Ckh0tJLdYJA6ynrq6hPelVxbuT+w5AJafrpV3B+lTgu2Rclm2S8Q5W5jSAiQkv1nxN7Fq/ebfgpWn84eKNIk6Uze5ozs9zRF+hhZUq7/87viy+FEiTWKoIg8EhbdmpZtpjAdSXKtgbMQvg3HRRFTw1xtQZftaof6tc2kIJuGtCT8Jf9zfl9c3Lxrb84HGLTJVbUnd1Dwzitbdk/WvI/0Vr4mAkM+lDPnTIvyRrbMlPPbUM2kVWWOOB45aV4Z3CnEmIIUFVXDKdHg04aM7Gwm73XP4VFaLBHMeJWoHaxZ+hPq7BzR2Q7ceHUdjse5AQ9lgIJkqITdi0FX+CmXYeQ2lVOygJJ9ULGakFJV0aoIl7DA5ytWsOeoMYn0LEKMWnK5YwoDwQHDoyJQ419y5x97J6zlC0A3fKRlzfLehC8+4pByfg/DFDptZIs899dFm31b6w/UaFcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Document hugepage_mem_bp metric exposed by sysfs.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aed6cb1cf483..a8c163475ef2 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -713,6 +713,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   bp (1/10,000).
 - ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
   of a node in bp (1/10,000).
+- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
+  (1/10,000).
 
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
-- 
2.43.0


