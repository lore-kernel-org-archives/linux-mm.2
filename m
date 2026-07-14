Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA707C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2386B009B; Tue, 14 Jul 2026 11:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A72A6B009D; Tue, 14 Jul 2026 11:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471856B009E; Tue, 14 Jul 2026 11:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F74C6B009B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:02:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEA411A03F7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:02:47 +0000 (UTC)
X-FDA: 84987699174.15.349F281
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC5902001C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:02:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=iK7wgLjs;
	spf=pass (imf03.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784041365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY0zsgQNRGdot1/GBvs74WqAm7W6VQas7soUq+EVbIg=;
	b=vFWeKDzPhNCCw8ufKJGpOOHk5ukytDfcLsTqBYy8NuDpMoIdumXDe+NAbz1EbivT9FIIHf
	D3padlCj0dIfq8QJs/ScE3vonXpBfX3eGt1njkE4V/oxmdNNkmLIOVJZ2o/h21V+VsLQO5
	HoNTrwPWaz7P3VzdgBM6CgOhxmhb0as=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784041365;
	b=ZwmtrlkRDFppnmjUAPK/veqpet28+f/1ibch1Xm8J0EwqY3ToSIxjYjSEDqTGGlYMdROzr
	kbSx2wDFkrGbv7ent/3KrRkFhPwb6L01a9LYAnQhegCGhOWY2ro6k0mS+Iuf64AasuqdbZ
	yoW3r1ICKqyfpkrmeSBfEw7h+LInWto=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=iK7wgLjs;
	spf=pass (imf03.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bY0zsgQNRGdot1/GBvs74WqAm7W6VQas7soUq+EVbIg=;
	b=iK7wgLjssLwLPnP0T4ETwFXjueno/++Y7R9yq89uF89iG3mOgLMpDubzCgLnf+c9eFC5jlwhK
	IRSp9FNYEeyjLCgFV0O23LJbJKvYzPycK3u/7mz/DP/oaADJ2Faa9zafnovPsMcLOK9G1tTCNY8
	lC+Sf9o1zI8bihC6/RckxzE=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h02bV00PDzHnH4Z;
	Tue, 14 Jul 2026 23:02:29 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 71A8340584;
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
Subject: [RESEND PATCH v2 2/3] mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Tue, 14 Jul 2026 15:01:15 +0000
Message-ID: <20260714150116.382521-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714150116.382521-1-gutierrez.asier@huawei-partners.com>
References: <20260714150116.382521-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC5902001C
X-Stat-Signature: bbgiqb46pafu4dr3n1f14n57qky9zj83
X-HE-Tag: 1784041365-54428
X-HE-Meta: U2FsdGVkX19DUUSOALO1uIEwAxT2f6SajHpuDuRNU2SfTzTHQlAk5UbpUIY8Y61o2Ye34qhCzZj0jkOBwxG4W/lLnSSFrl8tHD6aTlKPpRaQtk3/ulytgS7nAxCTvLEV7S5aprXA4ispVaOGDBqxfkxp3/XWz9kyX1Nz6Whghd1hfik+oqOsMLpjNfywV5mlR+2Ehco9iD1CXZXVb3YT+RhNqTVNXFqvU1HHgRQjo14WcZcTJ0JVmYUFDDF8qmizgcmTAR9DLOgFhO4qyiKElReoxsJsCP4t/uU12et71T9Axvu4QXajbgoMx2k4UvSoEkG8e5FV92jGRiGwG6im4Us01dHaMemNY04BUJoJxVxS/sfAmEy5kTN4K8bdLhPitAdhOjd+z3rSQ9HQTkWZmmBJe1DebGuN0UkwgK9G5spkDI1rx+etBoagXsqQjhqkyMVraAlqRv5tEjtF4JqPPRGNU8SWKxDurCBMqXZNJlX9b3SkAFrqrdu7KR6Xo6r6GhDggTTDDuf49O5MiMH5kP66Grc9CxlQPP0sX2aAW06Q2U3fnojiJjZf8w08yBX/0g2zahchgQ0n3Xf3n+1+eMGuNA0odztyX7DQ4rYemM1q9PJlZu6SN6nWb98t0GH/NiPMIehqfW4KFESiZrlcbHFH5YF0oTB2QXqUbNo0txrRrQ9Aijpbg+nScfSEEp/LuOs9sBv3zQ+VOyPAU6BmvO4fDva5x+X1TSDhqNHzo9eWoZuvb0N6BZDLK4SshBw0gY9TX5a2B7++e0IpAZqR0G8oXQK/obSP0o0Q2V7JZ8cUmrOpqfrq5XbR235KIqVq7hffCVIbaxKKLavZ2cU6h3YRzOK3V/pHNpwUujEbPKmeUbRX2LEnzN+DZ0wPMFe+y0JZClfGmY1iVtIMQ3SRGrQbCkwaiAiek5GfC1R1OXS4Li9fhtzS1FsN33M/84FZSnOfhRJVR4cu7yKC4LO
 kza6V0l+
 zlx65x1dKJBu8z9AbCWTzTeE8wiSiUPDl98bbsZoIlGpjobNOFxW/Xf7M8Iqn0WQcas7Noil4iuNv6c6XRuKz6uCjC6R150PMGrAq6qv6zgqvfHvh0PS3A1JBDPRQ78y9X0H7Rr8meX0cHZRFUjgDb5EyDtdh1zMcHDyoQjKRVmq1VGICDI+spyx6DmFaiS6lmTz8FcgCDcIeN+m45+MUaLOHRDtSXCMEsM0XRaer9hi46tmZ5tBmBKc6jx5BY9CvzVYsdl2UNniIL9lPAHH9uvIpDTmxTfHMfx4JI8og42P9kEuzDf0ipQwqG/7KiPnyQ1a2Q7o9BvbdgxOYh1+9pDJOCT/TUKCdZhuaLA+0ggt+TqlV1Jwz7bPjra4JCInAsD4Pz6XmsdClQ89C8FS8Td9K5I55WyTWY+UtFbyZ+vANCFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

DAMOS has a new autotune policy metric: DAMOS_QUOTA_HUGEPAGE_MEM_BP.
This patch exposes DAMOS_QUOTA_HUGEPAGE_MEM_BP through sysfs.

Add the "hugepage_mem_bp" to the sysfs-schemes interface.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f..4b5429a5b415 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1267,6 +1267,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 		.name = "node_eligible_mem_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_HUGEPAGE_MEM_BP,
+		.name = "hugepage_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
-- 
2.43.0


