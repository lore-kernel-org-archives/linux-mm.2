Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA21C531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59AA6B009E; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04926B009D; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F686B00A2; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5036B009E
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6D84C050F
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:50 +0000 (UTC)
X-FDA: 85031640540.20.8265D97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 37A28100009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dp/eznQT";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNousysqLsJ6fyRgDH4abbL4+a0evZY6zs4U/XKn18k=;
	b=yrZ49e1Wva9hZK/7R6G5Cg2x7nm8n/PO0ckG7hrsmTwZ+swLrXg65cFIFtk1sWDvKf0cGt
	39NtDc9u/zn8hzCjl/dEN2wW0UEOzCi94MAGDZAZY6I+NytHV7F7zeMWmvgZ+dr9fAKQeo
	wOHGMVH4N3YHS6teBCjZTmfPSBD3vl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087589;
	b=PeTTE4cIQxjxRqqeT+bjHuVERliR+jE/1qQ4iXejJWMIfdQrKc8Lwqljmm9CaIKKvvTbgS
	X81ehrWzWSZ1vwJZFhz6ole1mjfTiSHxY3zvavHeplrDN8HV6gGfGzP+feE4XSJ27JU6on
	TcXId3U61zEvGlfUOYNSfzME5br/w9I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dp/eznQT";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 826DA43917;
	Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5621F00ACA;
	Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087588;
	bh=uNousysqLsJ6fyRgDH4abbL4+a0evZY6zs4U/XKn18k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dp/eznQTbrGx4uFd+xaUjo2TbfYpwQM2fjrEwgtMB2kP7L5Y7u+wtzynAivlU4alJ
	 a0q4sDIX4AAHPiuiqyrJ/Tjf/hvz7VGjsFkk7LefcI4B1bWaYDTYoKtmByd4Xz02PH
	 dWkIEOXKlsD2HDHdIRfUpp4wznVDeX5aw2L9kWehx1M05NSfaiepVqxRi342mjturk
	 C8YVj1tKvJ0KzQjRX0xBOJaufz4k/aFeWZfGYz0hCA1FdtgrX5dCBTkcWXPy+YZvS4
	 h3UhzyqN7iBxdi+1NZCHRYPlM+hQ7IhFnBMeQhcT5qVMdg8hV/UHX09iVqNcwxtj3b
	 /RTzG7d/4moIg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 12/17] mm/damon/sysfs: create probe prep files for preps/nr file write
Date: Sun, 26 Jul 2026 10:39:28 -0700
Message-ID: <20260726173935.94046-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37A28100009
X-Stat-Signature: j4qwkoqy7ohrqe7ic3t9h4wpu3cekact
X-HE-Tag: 1785087589-901098
X-HE-Meta: U2FsdGVkX1/x8Rjk+Y7fxmtGk5bpvIibBCuClt0vLRlaiJcys5t3hR7nkvEDQTU2SNSFk+J5R8Hv3L09mn/asTyGLOmctLg2dRzZo/QPYjjDeFigZFicUMhzWC/Ei3EoO/gXzPhADmB+VEXjLrbqvqjHanWESCLQWgAW3h870oX0XgKaVDazg0CgdwuEPrfkFRvILMwDeKgMrqpG7stLsViKgEL/yFD5ELcFz+D9UiyulkIF384xURyXUYg1tXj2AuHrPIIs7+U1V+Xu36vyvOs4g5AHuli2/n9MjorWns6nK4Cssvmcaf3f9L2XU+J7LB/swqqUsvu08Q+mf5G31bl6gJrwNYzRXEb/23f/WCJuYU+qwJPrU4oRU3zJrSc8HZps9KvrpZs8bRt0IRMOK8zzPRltrcPqHzEhc9bovccCvDWMMx8xiF3yFQrUQzeAK0sUtlzQjBrefVxZVcijoXGK03di07zjQ5B8JYSlsBYOoX9/Pjnfp9rMYuQ13dQkeYet2TDP3FXap3x3qCWQwI29H+O1iyYFu7V5ruC2bpllsHE0yWp3NSbuku+HPAwwKcc7UTVK42O78GatqdTu7hxLpLZvMSaF0nkU36QsMBhjfAjrJZno2pSYkcEK2zsQWo7B0f59/YTriEOL2Xzql/aLPtTG/fp6TtXeJOwC62L4jhVEBJsiPpFx5tBXqklQcifxjkXJ7JdViH/wj7bEngNfjweRS1sBbb5qGfMRZqXwrEi5rgi0Ka7sWx87CnovjqImlW8AWDG46vN0xeO4NHi+m4JU0zk698I0gVtc4mF48VvSzlMw8kPRqO9WKd9V1+IJPk5aKfc92kqRUC+iTRY7oPPiqXkdh3z096GHfIswwYC8kszyLrrz4YUu1mgXktlvyse1oHssJac0tYxdcvmGHnPxNdCEKnU0riPSFA9eVmuvwqTr33YtUNRME6hrvHf2UJopeH3+zSST8R7
 EuFTgZYF
 ZjPF9q6xPSlBFmcbM4CbZLkbCAqVKJaGlW1MeGZkNAoWge0ORJ9NiogqK9MxODQ2eCX/VO0D+hltFpjvJ9q6rPaJXc6wLPxR42IFrpf4SuziB07BcHVGb6h12wkRIKpaUFTNvR8sPfhEVcEgMOtrSxkMdYrz7MQg/PIzXmelC4fpt3DTX0zuSd5YcZl8XoZyQCHLybqZ82qRJGvnVdrqxwxmu3gmVMES1UxZi51+s0+KmDcOYceJ3lfH+m8pF9rkqeP+cuIjq2fE5I9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement preps/nr file write operation to really create the probe prep
directories and their files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e348c1feed1ad..f275a6f73eee1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -759,6 +759,17 @@ struct damon_sysfs_prep {
 	enum damon_prep_action action;
 };
 
+static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
+{
+	struct damon_sysfs_prep *prep;
+
+	prep = kzalloc_obj(struct damon_sysfs_prep);
+	if (!prep)
+		return prep;
+	prep->action = DAMON_PREP_SET_PGIDLE;
+	return prep;
+}
+
 struct damon_sysfs_prep_action_name {
 	enum damon_prep_action action;
 	char *name;
@@ -827,7 +838,7 @@ static struct attribute *damon_sysfs_prep_attrs[] = {
 };
 ATTRIBUTE_GROUPS(damon_sysfs_prep);
 
-const struct kobj_type damon_sysfs_prep_ktype = {
+static const struct kobj_type damon_sysfs_prep_ktype = {
 	.release = damon_sysfs_prep_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_prep_groups,
@@ -839,6 +850,7 @@ const struct kobj_type damon_sysfs_prep_ktype = {
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	struct damon_sysfs_prep **preps_arr;
 	int nr;
 };
 
@@ -849,13 +861,53 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 
 static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
 {
+	struct damon_sysfs_prep **preps_arr = preps->preps_arr;
+	int i;
+
+	for (i = 0; i < preps->nr; i++) {
+		kobject_del(&preps_arr[i]->kobj);
+		kobject_put(&preps_arr[i]->kobj);
+	}
 	preps->nr = 0;
+	kfree(preps_arr);
+	preps->preps_arr = NULL;
 }
 
 static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
 		int nr_preps)
 {
-	preps->nr = nr_preps;
+	struct damon_sysfs_prep **preps_arr, *prep;
+	int err, i;
+
+	damon_sysfs_preps_rm_dirs(preps);
+	if (!nr_preps)
+		return 0;
+
+	preps_arr = kmalloc_objs(*preps_arr, nr_preps,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!preps_arr)
+		return -ENOMEM;
+	preps->preps_arr = preps_arr;
+
+	for (i = 0; i < nr_preps; i++) {
+		prep = damon_sysfs_prep_alloc();
+		if (!prep) {
+			damon_sysfs_preps_rm_dirs(preps);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&prep->kobj,
+				&damon_sysfs_prep_ktype, &preps->kobj, "%d",
+				i);
+		if (err) {
+			kobject_put(&prep->kobj);
+			damon_sysfs_preps_rm_dirs(preps);
+			return err;
+		}
+
+		preps_arr[i] = prep;
+		preps->nr++;
+	}
 	return 0;
 }
 
-- 
2.47.3

