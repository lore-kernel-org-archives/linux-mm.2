Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982A1C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5F08E01AF; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350828E01AC; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF728E01AE; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07F8D8E01AD
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7D5D822C0
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:41 +0000 (UTC)
X-FDA: 83770362522.25.C567A33
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf22.hostedemail.com (Postfix) with ESMTP id A047DC0004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iITa+NUwhACoMD5FnlwmuMqJ6SJOmtABvjTvzkmHrDY=;
	b=GSKvC6oYaDma5l9229/+FDMWICJ1BUSUgsqkzjNexgvq2Yzf2Qh9YIYpreaJZchzWxMtR/
	nBHzN/hIKMM6HHwSyQKreQqNpqB1a8G84AJ4uEvf147zbOSZsDKrxY7mK2aCjV6b8jArVk
	XGpP1cOGS3HDdzbP8TXRpwY+I/dyK+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057160; a=rsa-sha256;
	cv=none;
	b=2s3HpUq+3DLvJa2WqnC8wf5Hz607D8npbw/M/0SktUD0TvDGgmweC8Kv5u2GujqET0Y3uw
	pQvt3RIIXWbGno+A9x/9AbH48K5d/Z8hyzpiY2ZY0OdrTKehiKXfBz0AjkQqaVzFm2DnMk
	CFt241P43PS1s6zun6u7/sRxueDlAOQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c1vV90jyvzdcGJ;
	Wed, 13 Aug 2025 11:48:17 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id D403714020C;
	Wed, 13 Aug 2025 11:52:36 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:36 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 10/16] Docs/ABI/damon: document addr_unit file
Date: Wed, 13 Aug 2025 13:07:00 +0800
Message-ID: <20250813050706.1564229-11-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A047DC0004
X-Stat-Signature: 8qk9kwutdhyik493dxqz5fshejoz1nbx
X-Rspam-User: 
X-HE-Tag: 1755057159-337289
X-HE-Meta: U2FsdGVkX19LMm8Jcs47CiB9XoEhxAebzusPT4Cf+5PnizopYeriV04cR+7zgj6bD9tEdE0N39aLzT9Dvfc27HEYVkyuiBXMlFbU70K4ZwNi1a8T6gm5KgMFwUEREUKA3Xrnc6i1CTs9YiVEwY7M7ANst88O8gfH5pbgNzZvQIw/h87DQXx5I0pssD9HTKS6QrYec9pm76Ziu1xbv4MtBQvvHQ3tWs7HQcntocffYLl83ow6fODK916zIXTswP+Rk401+4SPDRDUJj88gQTQmCJLl9LM+OXRgfmpDejfRlxgcxGdJfh31OJrKP3AIh0H1wA4CdtolJWt5iVLjEy/g/b86i0DiSoa7FJ5btUYBpacnoGsfSvP7ZbUFyC0WKPZrFSUWum3ioRwMVeqfN44And4jleKzsRUVj48ryOwC464nGVbggGZAt5Hz3wPcuCL/kbf2aeFYIdpgr5oc1dep0ettunEcgr5TWvnLhHD4ompAy4CecboFg/UPTsvAj3Bd9s5MN/etAue0gKdo8HGXGzblv63mRMRTQm2C0lQAX1qkvb1h5Y35An9GbLrzLOC0SVtPsUmlQdJd1jt2c6+imxPhblECLFbqCdGdh9RriUJNcyW06pldwX8l2scrJD3kywnG5gOPKOr9AS61yQjyqG4cxXuhkUGvHH6vkEkJ2En16Vdq/NE5NaupOqLICWSsDplS+TiLONJDfIypUaNn9GQ1gx2Y0VEu5JMaGUwB5nA1L6/G4kkswebM+tft+xycXijU319hEfOhMa8hUR8+thJnGjtR2EZ+T2tkQYezyWpXxmWnynFJu/u1AZosG0wzCN9igZNq93UIQ4cDrdnkrEHF2B4lQOjEyyTX3FOzYHViVGLno88NfloqJN9q/RmTBSQOQ3Q4hholldGrwDY4B6vTX0PmCqrK6ZA+VTx8V2MV+37dHtdSBspWjxzuN9y93qETMdiYsIdOf5RPbj
 9f4z359o
 ZBlM+0IZmhP0jkHrdV7ipYbvMcisz6xHVeeLHldPjOCUXZQLlmiRu2s6q93hTodEn6uekDXIC29iomCRGuB8/7ZxjaCAVBW7shaUcZJ/GucmIlt4pD0J6KnIFggovdEBAmFNlb4UcaPN1uRhRBYDANnAwcAnLVHu3j7Gqp8xT3aBsLd998909Bj61WnSaXmsMM55sEULlqVjDMjE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Document addr_unit DAMON sysfs file on DAMON ABI document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 6791d879759e..cf4d66bd119d 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -77,6 +77,13 @@ Description:	Writing a keyword for a monitoring operations set ('vaddr' for
 		Note that only the operations sets that listed in
 		'avail_operations' file are valid inputs.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/addr_unit
+Date:		Apr 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing an integer to this file sets the 'address unit'
+		parameter of the given operations set of the context.  Reading
+		the file returns the last-written 'address unit' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.34.1


