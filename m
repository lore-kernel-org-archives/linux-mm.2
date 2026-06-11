Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C834CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F7B6B008C; Thu, 11 Jun 2026 11:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC756B0092; Thu, 11 Jun 2026 11:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9266B0093; Thu, 11 Jun 2026 11:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA886B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:03:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FB8FC2624
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:45 +0000 (UTC)
X-FDA: 84867951210.28.BFBC275
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id C89AA40022
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf27.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781190223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xbyQYisdIYg+Me3GpiAseO+wWWNsUBL+dR9UiBIYGY=;
	b=iYHspSXFuhZVWUW4nkmFdOxUPMhcwhKOGDRL45iIVMFXO3Nvk8gN4OAz/a8rrKT458eYC/
	9g3kmhOnimVLFtCo9QPyPdX5fbZgkPtZY0Yln0m6NUii6tQLXZYStmBAWAg3bUd3DeJqvr
	tnwjAeuXdCphsvXH1et0ior2Wn6W7cQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf27.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781190223;
	b=SuCzTzeXr5Yp/8PTIuHZDvCX0Ejz/wNQCD9GNMjfUHtzlCiIyJdFaqFoiFNMuvXGdsgucZ
	TIwOhNE4GGo0O7n3GlMlPMgzzvQvV0Wzw/XTeUnWOKoTabh/9sNLKba5mgX0FsnWjtJvb0
	FFjITiSiyg80HyivKx0054KlHmKyPng=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gbm9v6MQXzHnGkb;
	Thu, 11 Jun 2026 23:03:31 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 79AA240575;
	Thu, 11 Jun 2026 23:03:38 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 18:03:38 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 3/4] mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Thu, 11 Jun 2026 15:02:43 +0000
Message-ID: <20260611150244.3454699-4-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
References: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C89AA40022
X-Stat-Signature: tsozmh73md3pdu1fxbinme9c1csjxb3k
X-HE-Tag: 1781190222-546401
X-HE-Meta: U2FsdGVkX1+fZ6QfzVhubxjmGGsoYdnY99mGkPjJV2kSnzyc+ZutQxEUxuKT90ufUhNMIpD7FEVD48Ha+bdxPPiciVOSrzP2OcPQEE1ZW0hnHiaqgQi3R01SDrjTvpOt4Qj5jl5G2I1lo72VzkVSMOC2Syv2TwhwtcsVkwEH7jvMKOUvuCP7fvvsK5PqbszLr31EltktrMG9IOE4UBrJwd/vcQYJVqRIuWTUTg2G/nm16BxFcKSSU8/Nw1DVGLqk1NKySOxTwaitdupbJwrpomzuFSwRaA8RRnhn2rK0OFh7WOIIgKIk1oGehtPtDtjpqoJzJ5TXRwVbel8gKMkfQC9XmojD2ypUTxnC89rjnncB+7mUfxS0/tBaqdgMxpN47BPpQuSvPgA4ki1rg58fZCQbpYMTHmlImN0Mz7rKP5HnBYiDkVc46OsIoixWZ1T1O+8fIiuJc9GoCB+d66bKke1fTwEi5Fcl5RFgWqnhWZ1Ot0xH3wdC19gKwyt4fdauPaxlIg4tSlNzrwVZW5lxWVTFALstSLocCyngzmU44MRs8jNmE5N79H9NMYWrDH/3ELPe1uygCnC6sjr7XDgTLBwhQX82xb+HUqRZX/De8BTvPJ9ggNFX7XQf2Yc/ZSlu3bbeqsAAompeDG7ztiYmDHXiV2iYLuaA9tVCxzKsqiNSxacvqJMLnJGC8UhHLnvrzrHWqpK0eAEsycCAmsK0+D/rhEJMiD6pkssj401bSzAtq2+dUWvHWLPySme/ATXmErtJXupqpQ0KxlieIeM5yWWSj10SQVfYwC4sx5gScsqMmbUO+vvmJSR5MUZsBYDYLQIEjipZAsaEOy9Y5GYDZatsQpDZYjvOtPHI1/qhtVMXsa0TVO1dDP/qhicpnd68nc6rCPzjtRF0SVjNMbdzI9bo3Mi71WQ3oigphOW/uersilqvGXMYlHfawMbUpPiG4dehUvmgAMzbao8Qqgr
 2IIGhdJH
 8k9VMvJfcdgHOXFf3UgywOYA/f4K69ZQi9Hq/7tcGbER0bXgH0iOAyzTlaO09+5YQC+D8SZ4iqXR33zaE6As9vAKGIouyjQN9R2LYvRnNO8oSnqzUlIhrzFOY/l8ipExC7ERZ6anf/nJ3X08j7tjMShixzsH0c4dae2iXvJBV6BKAkpSRT2kQ78FKAGLR00yGj/LDs+7mHsLfF04cyku7Ut2UgQkvL+xN3B5GuPBg5kr7+OidRjjg6GePIBxvhtCa+pBNNk2HT6oxYkdQLHbkwNmLuTjQ7PVhOc5Iez6GPOpozBakif80a2ewpgm0kSv+B+cM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Add the "hugepage_mem_bp" to the sysfs-schemes interface.  Also handle
DAMOS_QUOTA_HUGEPAGE_MEM_BP when constructing quota goals.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 mm/damon/sysfs-schemes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f..dc46ec128083 100644
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
@@ -2877,6 +2881,9 @@ static int damos_sysfs_add_quota_score(
 		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
 			goal->nid = sysfs_goal->nid;
 			break;
+		case DAMOS_QUOTA_HUGEPAGE_MEM_BP:
+			goal->current_value = sysfs_goal->current_value;
+			break;
 		default:
 			break;
 		}
-- 
2.43.0


