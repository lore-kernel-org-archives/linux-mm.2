Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88EEC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 02:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237FF6B0093; Tue, 29 Jul 2025 22:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FD16B0095; Tue, 29 Jul 2025 22:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14CC56B0096; Tue, 29 Jul 2025 22:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 019176B0093
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:23:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17A611601BC
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:23:33 +0000 (UTC)
X-FDA: 83719334706.22.05FC021
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66F96140007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:23:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753842211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=w6MRxO4LqbvXokVHMH9r1toJ/I/9e98xgR38DZwX71Y=;
	b=hD51Vn/PE3p9wMCPa+fz/IW8HHVxxPAp2+yAtceGpNl9dut8xWT3SGVyLI6ZP267GehlHA
	A6doBj2dLZQIntUogJXHTqFxbWPxADZc3LVE8DCbuAmmhPRvnqqPUJslkxHsNKMTszOJ/+
	/3tVJUe7d4GrzfazAC+nglW07tKurpc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753842211; a=rsa-sha256;
	cv=none;
	b=75KzK6gLaNNNHjkm8v+ZL2D33Rp5vA5qh0lZf97ATFjksCnstRT7D/pdg1qA1k8vLivlpm
	5+2KIgRo53MSJ+5IDPOGfw5dghKD4UfHZZKxHtYTm3jGNrf7JL4r8o1qbNi/ChjczpIV8c
	/+iJChzc/aL7doJkxaYFoFKWO5xo0vI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bsGHv3N4wz27j6G;
	Wed, 30 Jul 2025 10:24:27 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A3B51401F1;
	Wed, 30 Jul 2025 10:23:26 +0800 (CST)
Received: from huawei.com (10.175.124.71) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 30 Jul
 2025 10:23:25 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <wangkefeng.wang@huawei.com>,
	<zhangqilong3@huawei.com>, <sunnanyong@huawei.com>
Subject: [PATCH v2] /dev/zero: try to align PMD_SIZE for private mapping
Date: Wed, 30 Jul 2025 10:22:06 +0800
Message-ID: <20250730022206.1349706-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Queue-Id: 66F96140007
X-Stat-Signature: u3gqe8uhgqp98txhneuns1amr4ub351f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753842210-77296
X-HE-Meta: U2FsdGVkX1/nSNLUz/6G/SOJh3nX6CKJKVBG78u+WrIOVI2smWI8JKZBcZ5slrJucodGVYEjqegHAWH27ecOcgQDxZmuNFZiSNS5ixtnYOne+wv18/drv5Rf+sRqouAt5XTuPd3giXJygRo/qHGgUsq7CflFBrv6YJUPcxoy+xj1QMYonOwo417R7m0Vo3nsY7FJzVHrkU+XAUbzXbAAb1flYxZACC3FJj4BEqhEfoyixlml1k5LRWJA31J93MuJOfSa/rTzgsGu1oPQpW5GjuRi8ztdFV/KC4WOlcfi8+bB/MJrCdjhKdTYj4Z/absX2ue8FUgrBWCU9iKaWwvQU8VK7V7OZlp/3yd9Fz3JlHWkyN6AQdlzAfgAbrvCzk0M/CfFj/TgPnlZle4gkrgujw4RUQr0BFRRg9B4hxhaxC4jrf72LiwrD9zjjMUJSgbYcdo2tTg54v/7jbh8TUE4uIYQcnLHK0w701w7Hl8m9SpsQm7J3JHEWV8zYzKSxD7qO+mmPJ8eP6Dtb57Eizfeqo491n8mo8YruCv71WPMXBqLZ9x6kF1J0cFZtjTh0J7ohEQhN6xRXufv82nLOvXgfjhR0iHUUvfw30r/b/KZIklclGKVEDN1ytypqvkTUCB5z/qs1eCWMlXrP3ZHNATqeDXU6WTZ3dfU/uxfxO83+FFIeyHVClu/fm9ru4CjGP6JXWdPsOWlsUq4YOSK6lw2A+r3Bj0nm4E1UT6RavLepYQjY3dZK/HPLnaQy9/TCyY2gLrIfbKFC+8s9uk7BGV0540/xXuNojTgP3KrrRfXhi0n2Coc7yP++I+yEwinvWlz/fPyly6cSZft1CVoPfcRExf1cho0cyX9QNRcrAp1++fWiOxRq9z3Bm+NMwo1AByrJxnVyJEzR8pjKS2SHGLsl19XCwUduQMmVB0O9aPOPMlZQpJQe9o1GNknPpaC/vUZ65vo6ezrIB9FrZwMRxD
 dl2xy9nv
 k8qNP/Iku7E6FknXKav0bsnrJjWFVDiNo9PMz25o03PrNx6ERQlZPcjrmt9bC/dq8lp51D+HO1ScVsmMwN7Hjk1WewHKggUF1sdIKCtSU4vOGrCmnCdRHS2l4GiawWAXdsMSa2nnWXBEuyj49zqJjC3pBZTS0NbvzciW58TXqCb7ueoFmCa8OtX5Zujw8eXqd7mjGUxaG5XylQckD7tAmaHzi+xvYja8LuZURHbh/XpgqDbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If THP is enable, mapping /dev/zero with a size larger than 2MB could
achieve performance gains by allocating aligned address. The mprot_tw4m
in libMicro average execution time on arm64:
  - Test case:        mprot_tw4m
  - Before the patch:   22 us
  - After the patch:    17 us

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/char/mem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 48839958b0b1..3699e716b84e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -525,12 +525,20 @@ static unsigned long get_unmapped_area_zero(struct file *file,
 		 * so as not to confuse shmem with our handle on "/dev/zero".
 		 */
 		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
 	}
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * Attempt to map aligned to huge page size if possible, otherwise we
+	 * fall back to system page size mappings in thp_get_unmapped_area.
+	 */
+	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
+#else
 	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
 	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+#endif
 #else
 	return -ENOSYS;
 #endif
 }
 
-- 
2.43.0


