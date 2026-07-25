Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E01D4C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714DB6B0099; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C876B00A3; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB9B6B0098; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 046EE6B009D
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E02F61203CE
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
X-FDA: 85028522838.13.F025981
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 52269C000B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMrXA5xj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIpwaE1F4B7icWh20zYavmSeZ7bnIpg0bIGzZcATxDM=;
	b=3Jz91J4qvvCjst9IzvfpTam5N/kDqgJYYekqbLiYYZRADtaNwEs3PkvjF8zTK+NH7fylUh
	vRqLHaaDAT+71rr6VdjbhYjdeoytBFoupiP3Wur9HeDeE7n2G8mliwwUoK7BWXoPV3OXkW
	wUgjOPhN5YHxMNPirSIlGTEJSYFrOWc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013358;
	b=KaJ27J+cjqwH6u5hCsbcFh/dEMuqJ1Hcfi4Rpn83sMp6uNjfe1tP63Z+UX9NIDAVKzvTuV
	ds/qsnyf3frYbRO6n6hGQRZvMQgVUiLHg1cIuAwbaxqdMbA6Do++CMKwqCQGdJirUzPjiv
	7kpAI83XKOuztASO69mhARkPt9AK4P8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMrXA5xj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1CFA60AA3;
	Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE391F00A3E;
	Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013357;
	bh=yIpwaE1F4B7icWh20zYavmSeZ7bnIpg0bIGzZcATxDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMrXA5xjIrtPAhMEUTygO8ENTmBP9+IcdtREH0BFtsDYP/NlCF9343zmp9dagdHr3
	 KXs6Pk/7uMf7OaUSueb1ZuwzlYEwxisCpTghF//Sdko+jaFX3OQksE3hW18luXK/rf
	 jkvG5mkCyyo636Bg7qXJoQvB1oeEFWmCmo6R7xuQtOqTAJKfEXK7VAfX9i7hEy4k4V
	 QodqOaQIjf4lxFLd88LhD7tpx4zJC0L71f1Ly3XUUhsXFJ5E3Fq1AKXDGOCTVT9xNt
	 HHubGLyqzS57s8dpuBBgvUwwSevzTWsmv5DATojYLCev9tNyvTI4WtEGmOwtH0ObgY
	 dcelrHvVgPu9g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/17] mm/damon/sysfs: implement preps directory
Date: Sat, 25 Jul 2026 14:02:13 -0700
Message-ID: <20260725210225.129944-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iixbsgs7pkaohzz6iypai4j4csjm1wpc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 52269C000B
X-HE-Tag: 1785013358-898239
X-HE-Meta: U2FsdGVkX18CD7NpqVDBR2haqqGo84t0LlljDR4xg5AMPlBhT+xtWk2tQZ8q/BToqah0RxttP7SJBF/0qfL4nglZKWl9pxXiCMywLC69Qc6yIeGrfB1ISXie1F3KZZ3nALKq2RQWMVYyrLu8J2aokkg9G+uayxKDSVfgtBYwY8CE2gh+9X6OxbXNnUkWFWywSoNkWZs51HfFZaEnUjo4zbT8vm/iGrmOIsoR/0HYu+gZ89TN0u/NB78V/z1PJeY+dSElAxPtKcyDl/kDKz1g2I3033qd2PdgT8fkjZu1HCRrLN3m2nEFOgWOoVW+xFCLG1Btflsn61Hw027j7l0mzJpQaDL1j0Z/U4Jm09b/6IwQbuONYKTy4emT3vj8Xfpy35YT7UR4ME7ti4fJXsPuA8SJ+bg8aPOsROROCsHtPmwtaSxiv2aJtQc7U3eg1RBY8Jr9nWmNOk8TWfLhPRfF4Yw4PP17jj/QE+jR1MiFAm97MOQrUqMVaHjO4C02vLhryfDbBrgvh7Fko2R/dLU61Y5LV0haEFyLxQNhzhUuJyhi5Yqrxsrb7SD/lO3OLHMiGj2PHl7tWawenK1z2yCOgHeGTBcT8+M4j7AVN8R3sjcdRSMigm3qm6+6Br4P26lywaawqLhJnCQNHS69c9sYTJtNgR6/NPrxiQOIA4JWHCV8MGFmExsK7ApugFDHobolB4RG26JOjYVsrLYbpmpv7UnSq9rRgMTS5XQYwWehtMdiHkmRPVG+H1b2Akhzl7cqC72jOb5BM3IGmempQbe14akFgyxxY5HuX4aDmk0qqg/G3M8vTeeVtK0l3d4/ReYusaXDzm1W2xFTgVY6rOEJNjrx9a2If0oqNy89MON5OdUFrcclNW8hQ4gCBa6POjrPdG5WhBEVPBg6aLQ0VUtTY6zQ3roGWEpI2dO2b/etTcZRZlo5GR//KQI7cWFN+HCbXcq9Uma6iflVoFl5lfN
 B9suxTNF
 JFgG0NrWVpVugCJ1yoPvCCW0UbBYXLUGmxisPsLtKuGZXzfqrPFx/mCYIkU6rG9/ck7SzoICJlRm6hS9yOkjwiCIwaCm1w1QUiQAYrEXa8m9ACtZveWyl4VOdEVWT3eQPnaGK9gvd1EvtJQs1EhJSZh3sheSZqsUC25HVh2V90CEauxipWx3GBTKrVWWduWRG9Y/pVVrYino+/lIBumvaQrdBKkSl5rAD+6CZEs/5YsSKhEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs directory and a file under the directory that will be
used for setting DAMON probe preps.  Implement only preparatory data
structures and functions.  The code is not really generating the
directories at the moment.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 376c6ecbd4bf3..7b971bfd1169f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -750,6 +750,74 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * preps directory
+ */
+
+struct damon_sysfs_preps {
+	struct kobject kobj;
+	int nr;
+};
+
+static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
+		int nr_preps)
+{
+	preps->nr = nr_preps;
+	return 0;
+}
+
+static ssize_t nr_preps_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_preps *preps = container_of(kobj,
+			struct damon_sysfs_preps, kobj);
+
+	return sysfs_emit(buf, "%d\n", preps->nr);
+}
+
+static ssize_t nr_preps_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_preps *preps;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	preps = container_of(kobj, struct damon_sysfs_preps, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_preps_add_dirs(preps, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static void damon_sysfs_preps_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_preps_nr_attr =
+		__ATTR_RW_MODE(nr_preps, 0600);
+
+static struct attribute *damon_sysfs_preps_attrs[] = {
+	&damon_sysfs_preps_nr_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_preps);
+
+static const struct kobj_type damon_sysfs_preps_ktype = {
+	.release = damon_sysfs_preps_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_preps_groups,
+};
+
 /*
  * filter directory
  */
-- 
2.47.3

