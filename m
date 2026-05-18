Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC73CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74AF36B00B7; Mon, 18 May 2026 19:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4A56B00B0; Mon, 18 May 2026 19:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464F46B00B4; Mon, 18 May 2026 19:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2718D6B00AF
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF534140ABF
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:29 +0000 (UTC)
X-FDA: 84782164698.17.24419A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5BB70180004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qyonSZK3;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZRcHwid0T/eLSg97MMM/ugD+bkyafmqW8w2OvBUHpw=;
	b=vh+0HPlVBZN8cpk9pAqyWyPsODJv1x3yGjd45UhbhDcuFPsZmIXNmcd+oIf91EVhU/vAie
	jEVq+auy5h9dIoMY3pLOyYGWBdj5zg4Id48/RsA+kcCEJcFtRUstHNfeBMBsbdL/Q+LVv0
	3T5mPu1hkaqF3li5qDKq2kFVNcByDrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147688; a=rsa-sha256;
	cv=none;
	b=iEwiOLVZ80fIMuV/B2VoI6zYvHhleHH66lGvQWKE5Hu/dDGFnG+5uLPrqSI6CAGXUcqnEl
	9ItU9Syc+6K1DtDSOrPs5NG5EsDTX7aMtOU7z3S/9XjlHhOVfBRHNfBc1TRqpYzVcTN1xx
	IzOuirxi2E9dsgsAaZuqcWCq0dAtUE0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qyonSZK3;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E06C560210;
	Mon, 18 May 2026 23:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C8EC2BCFA;
	Mon, 18 May 2026 23:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147687;
	bh=rmhr/Vph30m3uPvDxb7GClUtdzs7jhuiQ7mtlWz+jJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyonSZK3Sqo3vxcEuYFvvHUuU2LGTdr/Qq/X+Jxog9MN45lEOPuM4v11XQIP+ZCnR
	 8P1XjhPRdjPyyebInFoG8NJ5U5S9boE40lOzlWjnscbXl7F9pTuKghwSCcPDf9d1Q/
	 yhNmPKPJqrq95ptQuNHR0ORwPZD0gBYhHYv/4XS0Qg3AX3HVVu1eAfeJa0N75h+XOO
	 xzkT4wxI/iu+yf6gE6U4xvF6VjviObSd2Jlt61BG1SrcHSii+yRmm0nw2wIojqJvxf
	 /JG/SSJt+sQ4RcTMV+eAaYuDKjKy/HghbqKudd1/AUd1rdMga/ow5JTRrENztyZSsI
	 xRTtUJMJx59JQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/28] mm/damon/sysfs: implement filters directory
Date: Mon, 18 May 2026 16:40:59 -0700
Message-ID: <20260518234119.97569-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BB70180004
X-Stat-Signature: 38uppt7gsop55mrbiqx6xftswp3f1mec
X-Rspam-User: 
X-HE-Tag: 1779147688-319323
X-HE-Meta: U2FsdGVkX1/gGK6+sfuHplkgxwmOHL96/VzRxXfAIcMBJMC1R4eBVFYkdtEWFyf3BuIPNPo6trSWNJLGq3XU1RP4p0qq/9VBwcW9XBl5+3BhV7sbEVt8dMFSe86ifywrUarfVw68QRTNrKzmewMkZMfOvzxPB3eQ/5qdI9zJqtrUQ+xYsoN3ElxlG3p2rC/mskSHxoP4PQr8zBV5HgQLIQLFkZV27SszJUDEg034SUZVo9PCR284DCMqhAIivZ2Hs3wrIDJmd8S7KGgTr924bZw4VVK/htbSaJDDY6Jlt3Oq2kNWM/PJeLi+InyFd/xkbupzVr9zI/aa1rTb9EBEMIEZ0gy4XygDXxbFK+aELQAqfRaJJKxM1cWubQqUOHqAnq+DUddQnxzCEfrcpkX1Ri9Zu3ADY3HPRpfONydkmGMmOr5eMNsEaFAD2zubOgAB7Z1OSnAKKiBhcZS0piAxEQv1bnlrMVDK7aNu/j1RyyFmalz44EwY45LpUp1fOFRyJNNLzCMd17kvLvLTU3HwKjW8guZV2c1rqf9t62FKlWfFBwom7xhyCVIbrHx/3mhERjRudKGTNk9wEbwqUcLqiMTp/FX0Pd5bDOr+ZFFJRvfwG5k8VoUlnQbSI4FwOgaTYzu6aL8tltjAD9R5Iwy8Qmd80+JmBYFI+eflSlzkY/VziwFHM+KoEQyeqDNq48A+M6bv57562HlcwPlm2QSRMq49EhzqFisv4Zkkc17cPconR9VpmiydzI8iMcD6em1GZGBuWnsO5r8tyjQv2MDkOBS8IzHgRFZkxKTLTB8uesGW1K+TikSiWQFE0DJ9nXyW9hybSlA0kDpnDqWx/3NM2/5PQqc3Lm0FURWMfo+F3rVrIO75P+RtVtFvjJ6CpZeCNvTj8EEB71ObHB+Ph1Y5aK/7TZRrqwmdERL6DjHdonp98rLJMnz/8o9QzMLZmkAVD8L/qKcQF/BqS7G6vLk
 GDyyp7Ze
 gQd9kRkE10LFVRDcoXxjyaRkM4gWDUf7QaJ7naStqLLoH1C1co0IcK8uw2JJoBQNXtpZSPQWleDxSOMuB5mak42ZZZH2FwkRqje6Z44FQQirkjvShy58JpSlbbBh5HRzX5ywYn4u0tjLKJx0hiR6dQlBLITvy2GETlK5MunPMDO9Xo++8ByqlTGKFbx3vZLmWwpMkAkoKMkJ9NJ7wSixEDY4jsUimu6BEC1Q6QnitejPEkzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a directory for letting users to install data probe filters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6cef3eaa4431e..dad4985a826db 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,12 +747,42 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * filters directory
+ */
+
+struct damon_sysfs_filters {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_filters *damon_sysfs_filters_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_filters);
+}
+
+static void damon_sysfs_filters_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_filters, kobj));
+}
+
+static struct attribute *damon_sysfs_filters_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_filters);
+
+static const struct kobj_type damon_sysfs_filters_ktype = {
+	.release = damon_sysfs_filters_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_filters_groups,
+};
+
 /*
  * probe directory
  */
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	struct damon_sysfs_filters *filters;
 };
 
 static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
@@ -760,6 +790,30 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+{
+	struct damon_sysfs_filters *filters;
+	int err;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters)
+		return -ENOMEM;
+	attr->filters = filters;
+
+	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
+			&attr->kobj, "filters");
+	if (err) {
+		kobject_put(&filters->kobj);
+		attr->filters = NULL;
+	}
+	return err;
+}
+
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+{
+	kobject_put(&attr->filters->kobj);
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
@@ -797,8 +851,10 @@ static void damon_sysfs_probes_rm_dirs(
 	struct damon_sysfs_probe **probes_arr = probes->probes_arr;
 	int i;
 
-	for (i = 0; i < probes->nr; i++)
+	for (i = 0; i < probes->nr; i++) {
+		damon_sysfs_probe_rm_dirs(probes_arr[i]);
 		kobject_put(&probes_arr[i]->kobj);
+	}
 	probes->nr = 0;
 	kfree(probes_arr);
 	probes->probes_arr = NULL;
@@ -836,6 +892,13 @@ static int damon_sysfs_probes_add_dirs(
 			return err;
 		}
 
+		err = damon_sysfs_probe_add_dirs(probe);
+		if (err) {
+			kobject_put(&probe->kobj);
+			damon_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+
 		probes_arr[i] = probe;
 		probes->nr++;
 	}
-- 
2.47.3

