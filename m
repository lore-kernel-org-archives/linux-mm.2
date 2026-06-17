Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA81CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B666B0005; Wed, 17 Jun 2026 02:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB126B0088; Wed, 17 Jun 2026 02:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0FB6B008C; Wed, 17 Jun 2026 02:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3EC6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:58:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4E008D370
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:58:21 +0000 (UTC)
X-FDA: 84888500802.11.8B81717
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5928C0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:58:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781679499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=jWL0l2/uXOcgrXqllx7Dp+o1IU0yNqgnIbMBEVuqEyY=;
	b=qdOpGOYEQ+JP/yNHS7UCmW+5psM/ayUuGSlUqaRyO0UiL3rlsnVRaRMAL8JawxTlIg6fUc
	5BX2pcvOdWyrE+I8SexMoKciCzFOjAv88+4WbpmQKaUscfmjGwJtokh5w3/q68KPUg3deX
	c3XDXK/seMECyBuDvMrBzTKz24cS2kA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781679499;
	b=ar9yQhJRL9ENi+N4oCHM9yknPdCifFqH4Y3JNlDxpzvGTmEhlZ2eEv0iOvuKp3r2cazGUM
	2uSWFnuIIQTGLBSCMlcudWiMXGX22MgjNc5HYJNeFrAPYaFWbtenU/wT4RkMITabd8FoHT
	NL9nwC1rDOPs/BiDPuQPn7vO1+kPrzM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ggF6s2tqvzHnGg3;
	Wed, 17 Jun 2026 14:57:57 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 412E740577;
	Wed, 17 Jun 2026 14:58:15 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 09:58:14 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] samples/damon: Fix typo in Kconfig help text
Date: Wed, 17 Jun 2026 06:57:16 +0000
Message-ID: <20260617065716.750179-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B5928C0003
X-Stat-Signature: 5aqqeysqjr1k9ynpp1k8jsnh3xacznq4
X-HE-Tag: 1781679498-210166
X-HE-Meta: U2FsdGVkX1+W1qmcysC8CNjMAvyVW6YZCiZVutb20hEH6LkgHHJGa24HRWclgUnnjfOkshjHiZPBYIslU1Qc5e608Y5Z5vpZhFKTRcjZUB6u9Box+3IustVRfFrw1YoQSRonjE1X/PH/HLVvQqyv+WVjkQ+ZFCXY2mbaMO189L9EKWfD2C0CBvq2Gi1g7NGIi+p01xjz4tstDaOaPBuQ/yX1duVvPKgKYCliL9qnIb/eSJ+L90HlU1dxHSeW56Mj3Wzl8sXcIi2GcPytSCb1dw4js2nfTvsiZsAl/oCICPVnZZWNumpYS6SIhVH1jKnKCqhm3HgR86ErBB0uQk34pK8WfDH1xmphGY6ZbTWYGdyJo7AH+XAY9DnKPCgED5T3VwdvbPzl9ZFVS84dhvBDp7YHkSM/l5Nwg8Kl8j201yET/vWbemt6W9FdQAOmOY7XTh1zrmzADKgzx5nBpkpBfRBmzS5fXgvNBvlGcA/FJotLkixmAnVWmH/pE7eHaBLi6UGl6Bjkr3yjO6yHMaqUOZhJP4qw8VXXIGbUWmAHfx8TH/FY2I/5/uWR8ewygzm4Ah3iQJuHQIuQPlIzyjd/bqaLKolohdhX3zhXT0Y81cBS4mlnVfVyiFS+Ep6JBAFtCbsvG50kMtdKD9sMkWXpOVkqQfOz9g1y/fVvzWatZXQ5iv5u5AmfjnEa+faQtVMjxWEDlAM2QhKuXvnHpe/2HDw/DITVJraQA2yEvzXDq+1YwXLCSjawOVz61kvTLc9nC2Ou4nszpLuikpEtpjGSY8wues2bfIDLkWRGy9cYOlzhudwXZOCyoDBYLbFeaZ+xjRGimTEX3svsr3uDkDOt35qT9rcM8dCSOxguMbwqthb18CKJQYmtNmB6QHTAqdmpH4Jzy6MLAm44CK1uPCGmAiTzncjHBNlrvzeQ+2p89DVK4HVbj9cGQxtRJAl95molkCGWfC6v7I/+opkPYGL
 nL5CPiAv
 frEuk9GTde6nX9WXbHnjT1iX1hnKBzmnrmlThsKgInrYBRIBKAmiya0a2+MF3H+ueI2LXjZ5rBgRn05TNoen8mNmWXixpF5tgO0teJuvBNnVKoFwERsolKBEKxa5zKtJO10el6gvGZXEsFXnofGLpMQrlISW98P1q6gV/sEM2/301/jyGYNUm05sugqtjYsG1SmPXaB972qLYuVEOspkPBz3X6gMdDeZJUnfrIcE9qX0k3QnI+LpZMk6RS7u5y4Z3/OZfMtSunZ9lQkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Fix a typo in samples/damon/Kconfig help text. Change
"Thps" to "This".

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 samples/damon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
index cbf96fd8a8bf..182a59722879 100644
--- a/samples/damon/Kconfig
+++ b/samples/damon/Kconfig
@@ -31,7 +31,7 @@ config SAMPLE_DAMON_MTIER
 	bool "DAMON sample module for memory tiering"
 	depends on DAMON && DAMON_PADDR
 	help
-	  Thps builds DAMON sample module for memory tierign.
+	  This builds DAMON sample module for memory tierign.
 
 	  The module assumes the system is constructed with two NUMA nodes,
 	  which seems as local and remote nodes to all CPUs.  For example,
-- 
2.43.0


