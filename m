Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31FE2CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0FC8E008D; Mon, 25 Aug 2025 23:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2188E0038; Mon, 25 Aug 2025 23:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEE68E008D; Mon, 25 Aug 2025 23:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7928E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:18:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0AD648419C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:18:42 +0000 (UTC)
X-FDA: 83817451284.15.4665002
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf01.hostedemail.com (Postfix) with ESMTP id 53E4240005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:18:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756178319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=+T4hPLOU/9/3jQXX+4zFIg9Q2fZ1hWLLujpvosXl4iY=;
	b=jkird5TwUuxDHbQ6Ve2PgZ0jC4gcM8YO5dk1D4sMRhU1UQRl3KR1xaUjSEu5gSfXzhzHcg
	T67X6pcogUHfIG009sQ/tYaJtN3HvkidOzQ2DZmjRGjaWbo/aZWHCGo+gcrVQvkhijaXLJ
	POS+y6SyT5iE7EMeuVzs1clpl3iFS58=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756178319; a=rsa-sha256;
	cv=none;
	b=e1hHwYeIg6xs//Vbl6LA3j2TXVoRB60zHFiKOLTxBQcNOjliyNUFzjQGLw4eIeectbuYKg
	hmKZHWe4pN4Spa9c4gpACgexaczK0og+/k5aaU0r7ChrmmRHr1TG44t7iZL/QcDbiQusOP
	+yFssCL75YpkdcB4JAofSWpkafQbCZE=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c9t6n4rfGz2CgVm;
	Tue, 26 Aug 2025 11:14:09 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 040011A0190;
	Tue, 26 Aug 2025 11:18:35 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 11:18:34 +0800
Received: from huawei.com (10.173.125.236) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 Aug
 2025 11:18:34 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@redhat.com>
CC: <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
Date: Tue, 26 Aug 2025 11:09:55 +0800
Message-ID: <20250826030955.2898709-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 53E4240005
X-Stat-Signature: 3sra6mzrt3s8ymogyzmz3qb7cx1g34jt
X-Rspam-User: 
X-HE-Tag: 1756178318-748525
X-HE-Meta: U2FsdGVkX18BslQDD44gnQWApU6CYhkSuoW6WKNZohh1/RbAZrGSvVXZ67AduoHcU6gQSZgdJ3UZuPgjjq5HKkjROzVMWmhNsPulgX/+CXMbywwfw0t0ie7lA3wjb4HFDEYz/TshJzWoSSJA57ljCD5KiELH5q+EdPirGbZaB82JZAmfMX7EJ1UN35e0WcbQazzhYLgKlqamx8HxEvNMsb5d8pDpvAhgB98ldZ6pNBVMc4CVyXAROaNRvUL5BFE8hy4QSqKYRj061S2bKwkoTn1YD1+7Idy/XjCz7nyAWMsMUo48empidSts74ey6bw0ulvS2M/7aIXWCIyx0XqoEZQAK84+HFIK7NvOLzHbYMsqlos6z2rMEW9LNBc1DotRmHFLsnGsjV/apZyyR2Eqye/swe73pqAY8pS5rcoBuByVwyny/ah6Y0E7zhQd3wKD29fHr+0k7nTOW2pdQtPcbpvfvQnWKo/PBSckEge3Cuf9L3eYRzxn+ul4gMNouk9mKIrISzI/Vxv9OLiBVjV5iH7CMDM7uks980+6RpJldZc6TfQzRdfYsMyaezsjmq18UyGsIDhjvNFJz8nbs/j2mCkOHZ1j1+uhmhfd2edD9RYZLIyTTudNT11CFqjsz5YGUH8sYkQg6piGSBJeONDxkMnNnDDEK9HJV0HVUOE9ehwJjHAZ9kMggguqAB6Vb9FyV35+LxDIxM68oAqMbhHYfVNo5DKAiLrf1V8Dsbm9QenU50ul/q8Mme0ikFvBa7aIpTl+Z1ymuAM32NXX1bAVUnVDNrt5tJglD0QkrVoBtcL58ttG4drYhVzLGDZOp31o+zhffFesJHsZi1X82/8MRqzv93pI3A43oT/Ywi6adfJ5oa5I6S4KXR5z9zwE5u2fx1Iz9GGZgH219D6oqNrPOxKBacTMFNCRyve3woLovfG/BcnHVP8WDO/XUNPI2/S5RB+q84rqJFzikX3Yww1
 uJeEB0sZ
 vso1a+TEwqjq+wsgndA4lFWCCp3SpeKIXKLUXLnwrzfB+UsYg9wnHGwsjifXGT9/SgbNGXAeCMYiYc7ejGiMPv5OJbKfr3V9VHD6Gg2GO7AZYtt1j6vI8VENmddBccx9UNQ5MZfZoR8A82/5vY3o4rf1xPZGwBPKPyVDiKfjc+Bu/YD+7JFG1MT+w9ytHwRIaWx7NNcMcj/9L1WNwHJ2DeJafAxUX86T9d97cbeMZTC4lUVPGxNL/1y3myG7ohofF+pTndJLFKsG2Gu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit f8142cf94d47 ("hugetlb: make hugetlb depends on SYSFS or SYSCTL")
added dependency on SYSFS or SYSCTL but hugetlb can be used without SYSFS
or SYSCTL. So this dependency is wrong and should be removed.

This reverts commit f8142cf94d4737ea0c3baffb3b9bad8addcb9b6b.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508222032.bwJsQPZ1-lkp@intel.com/
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 fs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index c654a3642897..187a75440aca 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -250,7 +250,6 @@ config ARCH_SUPPORTS_HUGETLBFS
 menuconfig HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on ARCH_SUPPORTS_HUGETLBFS
-	depends on (SYSFS || SYSCTL)
 	select MEMFD_CREATE
 	select PADATA if SMP
 	help
-- 
2.33.0


