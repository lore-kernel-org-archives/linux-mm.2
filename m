Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1477C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC376B009B; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E096B009D; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2642B6B009E; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9E706B009B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 345B51604E0
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:50 +0000 (UTC)
X-FDA: 85031640540.05.89BABDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8D2FE20004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGt9oWV7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NW04Ik3DgSNfNvyKbAbVk3ac4IvNSq5SmgWKpuJrQTw=;
	b=IKzARKhsZQArN2j1Qj7BIS7h34fTGsH87ax+oxrBPo/CGIBrSn7r7UgKj/F6OypiPssxql
	WjZzabh4i6efEzMGY3v09vKmVVjMrc18bi1juh8JMcKxaKErDDyZ/FJJJBzIOZTDtjD8A/
	k11/YFDzdSyf++hinad823FBiaxsaI8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGt9oWV7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087588;
	b=aG2LnqGEtNg0pxQ0AJjJO+al00+193KZs8KtRydFw1SeQyOvFs6kq+HapKtY/mKMlTDzZi
	sPYQCj8AEWNK8Q+MhvLLGFfHgu7ol3iQHqY7yz2A1OqQ7u3OY4Gd7F/MdjmoLwMo7xAisU
	AwJ0EQ3ko9nsEmDEdqtLLvnTf17C9Q0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9A4344F61;
	Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9583D1F00A3D;
	Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087587;
	bh=NW04Ik3DgSNfNvyKbAbVk3ac4IvNSq5SmgWKpuJrQTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGt9oWV75l5KF+YsDjwm1Ffgls3T3/EXZ4bmxwXAUWJ9BwDJh+jlb02I7v9LMz2XD
	 W8GEzq9wTQAcbDLlAkujdN6D+inoaX0+UlxaYynBBn0e/y4PfeCMSSAgmQPn6/gXI7
	 Bdovx9r+MV3d9kSkzPZN2d+ZSI4xb4fZ7h0GkOg6zynJzeq3vieO1Nx1Lr2VLnrxtg
	 LbAq2VcqTSbU6tMrT2PixWq0roeVphMPRfSQ4aBkb2c/6aysTOH7DOzSFy5hzt6j6g
	 uA8aBg7giE1uizJ/sNn6FX7GZPNj94ZcAdoSJGJkfQnPQo3JbdwKIUzNK/Cs3IKZ6l
	 QJHighYDzT4PQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 10/17] mm/damon/sysfs: create probe preps directory
Date: Sun, 26 Jul 2026 10:39:26 -0700
Message-ID: <20260726173935.94046-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D2FE20004
X-Rspam-User: 
X-Stat-Signature: trtyhq5ypqbuywmbicwz7k9tw5fmf63p
X-HE-Tag: 1785087588-586279
X-HE-Meta: U2FsdGVkX1//tr7M9O5ZHm3iz7Uxv0qk+Nkm/E81V+r76hfSOhM4sHUrEKCOohl4A9KsC+24LQMEJPgBtctY8yUmV/RxAtNt6IhRLCjqtbSCS4jBtXycncdggsIHcouDxFWaELIRxKvFCNumKjSUqx1h0+3QpOFATekohfivHiCBpSKKK+VuVy2sT3lPS8fhTo3sqH2o+MznGNphN6EPyvd0ZIiNcrsPgvoKVTzC1SgrcoXpZrLKRsw+OAdYn9kcQLQDM6APjWs/rj3Y+/q9NNIJ5d5dgIgfM5yAkXjc9FQPDI+QFnsHylFGdG06JRmDHPKLVXsrZ1QKmb3RcTUdjN4gqyD1yWJlkkKkhCPG/VQ0XZ2MQ6kEf+CrdZ4tpHKHeqUbjPOSxXdk5p2jQmcRZJMoXYFkndDo/OgvXOjlsWXNd4S4/a5mYprjR6Yo45iNmYAtu1HM6SPUqBXu8AKMCikENlHEmRS6V9COWmnp8YkeyrtGf+QzOxhIIafIHG6Xz3szOy67ibDGvOQxEMQj/mH4Eg1PK8pKFCsMxohcNTFWPI+VcpNFThx2L8sEzCej5OrA7qSOA9Q4HNiBjQqWwt28jQ8axoOt5HIyNm97dHxvNxvTqo/VhAkC9rt0/kg6+bxPugc3YX4vM5mPHjpRBBSVT16OeGVIulcZe1e7gjnMuIazx4dBdhTYMnObtN7WrnQeXpmoRrHdVJPFg344t5wRiWSKkxqcW8/mlAfTZk+kejeEtGlIYX2pxnUeRN9VXNibaZ8/xENxh4b8mFZsExGeq9UaiqHloGP4kdm9yGMU4tjqztBt/8OpGwnqQrFZYDp27kjAyL0jMOsE76aDEvNYGckzQutBKpr+QzMs3d3nxZSZswrfBQ125RivD2CLFdgUeQBTSFfAZdIakELLXbX2MEGjI87VG107J2q9Q0ma+nP+5bMi7OPY06jiUoYEth0r5Xd4APp5L5ibehS
 ZUK6STd0
 w3Cr+HwcO0AAsCxQ1r1fW2Yg9GdjqkSLC1jnTL7IY+J02gU8DjJKfW2QCQHgOL9Vwj6IzeHYFzkON5HdhX1DxneSGqd3tedA8eCOBb00Dvp5FgsRalxW2zreT7BSGtz2e5Ucz/6XSgzywQ3j9nVM33AP7yq7JTRsLb6dC1tAPTFtZIqE0eytLq4a8WxxKeTPqdNONHm8G5wAjQn6+xCzNz1uWWbCy4DqUAGSpwx+2Tudbuf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create probe preps directory when the probe directory is generated.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 50 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 0e4d7a50545e1..6d3ed80fb2eb1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -759,6 +759,16 @@ struct damon_sysfs_preps {
 	int nr;
 };
 
+static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_preps);
+}
+
+static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
+{
+	preps->nr = 0;
+}
+
 static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
 		int nr_preps)
 {
@@ -812,7 +822,7 @@ static struct attribute *damon_sysfs_preps_attrs[] = {
 };
 ATTRIBUTE_GROUPS(damon_sysfs_preps);
 
-const struct kobj_type damon_sysfs_preps_ktype = {
+static const struct kobj_type damon_sysfs_preps_ktype = {
 	.release = damon_sysfs_preps_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_preps_groups,
@@ -1138,6 +1148,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 struct damon_sysfs_probe {
 	struct kobject kobj;
 	unsigned int weight;
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1148,25 +1159,50 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 
 static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 	int err;
 
-	filters = damon_sysfs_filters_alloc();
-	if (!filters)
+	preps = damon_sysfs_preps_alloc();
+	if (!preps)
 		return -ENOMEM;
+	probe->preps = preps;
+
+	err = kobject_init_and_add(&preps->kobj, &damon_sysfs_preps_ktype,
+			&probe->kobj, "preps");
+	if (err)
+		goto put_preps_out;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters) {
+		err = -ENOMEM;
+		goto del_preps_out;
+	}
 	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
 			&probe->kobj, "filters");
-	if (err) {
-		kobject_put(&filters->kobj);
-		probe->filters = NULL;
-	}
+	if (err)
+		goto put_filters_out;
+	return err;
+
+put_filters_out:
+	kobject_put(&filters->kobj);
+	probe->filters = NULL;
+del_preps_out:
+	kobject_del(&preps->kobj);
+put_preps_out:
+	kobject_put(&preps->kobj);
+	probe->preps = NULL;
 	return err;
 }
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
+	if (probe->preps) {
+		damon_sysfs_preps_rm_dirs(probe->preps);
+		kobject_put(&probe->preps->kobj);
+	}
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

