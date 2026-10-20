Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B435606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=SYMhujjY
Received: by kanga.kvack.org (Postfix)
	id 7456B6B04D3; Tue, 20 Oct 2026 09:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5EE6B04D4; Tue, 20 Oct 2026 09:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5646B04D5; Tue, 20 Oct 2026 09:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 374566B04D3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:33:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE3F0A01D6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:33:22 +0000 (UTC)
X-FDA: 85343096244.14.11E82F5
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf02.hostedemail.com (Postfix) with ESMTP id C8EE780010
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:33:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SYMhujjY;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792503201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CGrzPuac4BCqviRdihOooPny/4+gPoANGJ4ge/fXpto=;
	b=WodiL1vnMNDxlqMSNrPQxHKhp0eDy6Q0kd53EGfHKF9ecHpSSWXXSdH6CTmKaHxKeoGoR7
	vrMGJ31DfeyjzoFh8vGC2AppmlEIhaRrsPFXyYTM7ufH+viMcbr8atcUPLQFlv9Axyn+sC
	7ey6Xw01ZtJtnxChTIVk6dLd2Vi4Hsk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SYMhujjY;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792503201;
	b=1vI+dWUjqyX6GpsZd+qmi7lo7lD6EnAUMu3ogBSCg22rE98O+rYc0dJz+G2DLLY1IRmKRk
	iN6ecn6Zz7Se9x2czr8ywFXxRH1Co8ejvgokIxTRCoAlKttN1qioUyZqk2AstGM3M08Qap
	Zq8bmU6yOpkJqtVxYckgIN9D8C1ncZ8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CGrzPuac4BCqviRdihOooPny/4+gPoANGJ4ge/fXpto=;
	b=SYMhujjYXT7SQgfydoLP1stjj1ocdmWvEW6oVNA6z65TUczBhtqvsIDYw6fnaZFmNwq9YVzzR
	pI5s3Ne8X+PS8UJeMYG3QinHxAbWXPYlAKfX+wZL87XDZaI3OEQ7SjPbNVItz1TAozqQJFB5ReY
	rWrEEmbxVFBDIFYaonvC56U=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4j8Cz11mS6z1prKf;
	Tue, 20 Oct 2026 21:33:01 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id A9A684056D;
	Tue, 20 Oct 2026 21:33:04 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 20 Oct
 2026 21:33:03 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <sj@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [RFC PATCH] mm/damon/reclaim: allow disabling watermarks to force reclaim of cold pages
Date: Tue, 20 Oct 2026 21:32:33 +0800
Message-ID: <20261020133233.3920818-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Queue-Id: C8EE780010
X-Stat-Signature: 4g7b67u47s1bpoo6owhju58ao4h5o44b
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792503198-459786
X-HE-Meta: U2FsdGVkX18sFjdkfg0wu48ig38O62j82jaLGGOhkUYXi7me9CoutOj4xgYD8zHfUqjgPRQN0ikw+kJ/T2+xaZ4zHAmpIo1P9LAW5P5o4xH1eUk3eKFvvGQBxkh95QSym1IfUcXbuFT/S5chV55eey3ugNRD9NzqZdBsta93YwB8i0Z44m5T0YTZAfwMEIMzpjzd1FmlIzQpF8ctKnKskbmHyjMG6FUQOKv9lbo4OZl1We1VthVQdReqlXKoc1+fqDuhWG5S4jxZqZ5rNw8ZMf4cUvl8ICruBg5GwadvFcC1BqyCHYDPTFFT+TEL2oroejBSbLOz73s1jSkY4GlAWyj066UhAJVTLtYhbWRDevUt0MCJ6qQaQjziLjG91+Ut3m0J7qItOFd83FONXAKhAGQK7uafKR7lCBvLGvj0uJvqnsI1Mzz+UFJIyLJCkVvF+9KpklWWvds95Sy7/DwUjjNz8Xeo36S9JK5+m1Q/dolgJy1NzsXaQGmc6+DFLErq8w+j0+9JojVFYjN+hB5M+QK70SjWei4ed38tut7kwnn2XKX1VkR+e5YzAxaCDEV6Wx4rEHfe24PEF8nV5K+NoMKigvrZwDfjF/w8XWraZt4X9LurW4zTWHgS1kfFMZXh9rkGr/dIBvz64e5DTdi9nh0Ech0CeqV2ij1QynVjwvkX7lh73qBbKjXQ9ffVwdAtfJB+jXJFUEzUqjEP6vuiYH1XI/15SRZQHKT3TffppREkh5/4xVtPF03PeH+aG1GKD5oKNTVdRv8C2+EP5vWIGAOQLP8Qet/sdx5GnhqZ5lZM5vjgs00qcnbhdc+NjowciG9uDmFhV3QTU+g9eelNbV8laK3goXSMKLT2e4IPBwDDw7dj2Tcn6kQr050E0W4k+24l0FGgwTdHe1LQyK4eKKjpuMngvsw5aAHf4ImCTSzS4nbkE6ihXHpmEkd0Kt7Y0XG2SJdkXq6yqpnPFnA
 a6X1d86K
 QGHE5Ue/w9PYkIZwjX7O4L9qhK1N9LCZeWm9tA+0e6TJ5tmfZkXeqfue1wO/C1kddrjs/rc1KGJBJADYFmzs4D6ij/lwAqDQ5qzXzfV0xF7zLokaO2nTj5yUxiK6XnxXIo4K5ud6Xq9MaD1+4DX866C5d3EQoGc1Wbk1I6L6BE/jXAfurczhuVekKMr+PJ/bHt5vXbCQqdLEbIx2AlBCld3JcNdglfAGoI4FNNyOO8ZLg50wZxYkefnEgsibsNdxeneXUY7IGH7lWNKMO9Gpqksopo6ZtGFDoJ+Yot5yPWi4C1nU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON_RECLAIM runs its scheme only while the free memory rate is in
[wmarks_low, wmarks_mid].  Reclaiming cold pages raises the rate, so the
scheme self-stops as soon as memory looks plentiful again, which is wrong
for a VMM parking an idle sandbox that wants cold anonymous pages
reclaimed immediately.

So add an ignore_wmarks module parameter. When set, the scheme uses
DAMOS_WMARK_NONE, so damos_wmark_wait_us() always returns zero and the
scheme stays active, bounded only by min_age and the quota.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 .../admin-guide/mm/damon/reclaim.rst          | 17 ++++++++++++++++
 mm/damon/reclaim.c                            | 20 +++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index ec7e3e32b4ac..ef57f60a9105 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -159,6 +159,23 @@ this auto-tuning feature.
 
 Disabled by default.
 
+ignore_wmarks
+-------------
+
+Ignore the watermarks-based scheme activation condition.
+
+If set to ``Y``, DAMON_RECLAIM runs its scheme regardless of the system's
+free memory rate, so the reclaim is bounded only by ``min_age`` and the
+quota.  This is useful when cold pages should be reclaimed even while the
+system still has free memory, e.g. to squeeze the cold anonymous pages of a
+just-parked virtual machine out immediately.
+
+By default, ``N``, so the scheme is activated based on the system's free
+memory rate, as described for the watermarks below.
+
+Changes take effect when the scheme is rebuilt, i.e. on the next ``enabled``
+``0 -> 1`` transition, like the other DAMON_RECLAIM parameters.
+
 wmarks_interval
 ---------------
 
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 45d5557cc575..03b9a57694a6 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -112,6 +112,23 @@ static struct damos_watermarks damon_reclaim_wmarks = {
 };
 DEFINE_DAMON_MODULES_WMARKS_PARAMS(damon_reclaim_wmarks);
 
+/*
+ * Ignore the watermarks-based scheme activation condition.
+ *
+ * With the default ``N``, DAMON_RECLAIM runs its scheme only while the
+ * system's free memory rate is inside [wmarks_low, wmarks_mid].
+ * Reclaiming cold pages itself raises the free rate, so the scheme
+ * deactivates as soon as memory looks plentiful again.  For a VMM parking
+ * an idle sandbox, cold anonymous pages should be reclaimed immediately
+ * even while the host still has plenty of free memory; setting this ``Y``
+ * makes the scheme ignore the watermarks, so the reclaim is bounded only
+ * by min_age and the quota.
+ */
+static bool ignore_wmarks __read_mostly;
+module_param(ignore_wmarks, bool, 0600);
+MODULE_PARM_DESC(ignore_wmarks,
+	"Ignore watermarks: reclaim cold pages even while free memory is plentiful (default: false)");
+
 static struct damon_attrs damon_reclaim_mon_attrs = {
 	.sample_interval = 5000,	/* 5 ms */
 	.aggr_interval = 100000,	/* 100 ms */
@@ -226,6 +243,9 @@ static int damon_reclaim_apply_parameters(void)
 	if (err)
 		goto out;
 
+	damon_reclaim_wmarks.metric = ignore_wmarks ?
+			DAMOS_WMARK_NONE : DAMOS_WMARK_FREE_MEM_RATE;
+
 	err = -ENOMEM;
 	scheme = damon_reclaim_new_scheme(attrs.aggr_interval);
 	if (!scheme)
-- 
2.53.0


