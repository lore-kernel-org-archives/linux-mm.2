Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A9ABC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2492B6B00A1; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FABA6B00A9; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09ABD6B00B6; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8C506B00A1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 507E01C0ED4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
X-FDA: 85034812716.03.399D341
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B7B554000F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hlimw8ML;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75WNvMQ88+SBOSCD3WYFyt6Ye1FE/Gea2+Axargrbvo=;
	b=QfDAoAh96a70wXgB6Adnmsn+EU6l2dbWKLP2tTq5OzZFnV5aufCzY4escJ5fIvBVdIE3Ji
	xDALB3GRey9SOiZL82zZve8+YfXMFZD6YIy+44jIuuiH9qG8B+UuUxc+MfSjrCzqk6b8c6
	w3PkMPXrX0xfd8VfHYXGoc9E1TnZ+qE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163116;
	b=jRqvmRe0qCFsLsHKiHdZ5x/6sjeCJY3Ho8aTGElpYYoF7NWESmJhjzhZejPy2Hm1/9JrnG
	//Wj6fkIHN/8OzGaUHMn38FIj6xadt//ez0/QlaMNjetTks0wM/j9ZD4+PQm+aXD/qs7VY
	PzHpQuxYdBl5PNQesT8EvMoiq6W+t4E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hlimw8ML;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 580DF600DA;
	Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD541F00A3A;
	Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163116;
	bh=75WNvMQ88+SBOSCD3WYFyt6Ye1FE/Gea2+Axargrbvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hlimw8MLamfcIrZSFABY2AOxhNJvK+Env+BYkcO4rULDAAdIeojPvF1FmQ32BPadr
	 HMr9O4rW3u4r7t7o+u2zTB9lSIBPJbVwEpQtICTiz1k5iFq7APR44bwDmgm26ApHD5
	 9lKuVZR+NKxj6P8FOBLqyiteVZ4bG0CGdPaajGIsMQqrIfXItUW3mEKE3QD1p23JlU
	 nicHTogsY+aTI9CKkjNH+mhFCLpZNvvPL2mCSloNyLAqczFBKgYIHo6MPBewNJm/Nm
	 8ZRQcIwipNVNbfZ37s01mNOrJlm6OszYFpfZ3OKpRlXCtiTcuk7ZfQ37Ll7kfFJX3q
	 twBw05Hkn7ncw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 10/17] mm/damon/sysfs: implement preps/nr_preps file
Date: Mon, 27 Jul 2026 07:38:19 -0700
Message-ID: <20260727143829.86236-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B7B554000F
X-Stat-Signature: hktxqmwr4heigojw6mh4d7f153cko3df
X-Rspam-User: 
X-HE-Tag: 1785163116-886416
X-HE-Meta: U2FsdGVkX1+5obCa0zsUrkmrzKkt2MV1jAWfbQKMytmrqCsFJgU9le7YTEFQCIQ72Fd1d0PsAj70sxdEkBP4IKB1RN37m0RsQ8Y1zhnfYLGkNPP7oxlwXmJcWCues6YH2pYVlpt7MliJpwAtabv/e11cN8Ex4b9MLBSncgMYh7svX4kxf65wRQewEOJX+IhLWlz0BXgBgihS3ydWHVCLt/NRtHE70uCnvHoiUxw8iNwgXq63ulkxCzkKzykzgQ8CrtT1kq2TkNvkWzo6iC+RO5uxLpSgubRzayWtvILj0apb3rdsfsVDC3BRyCiy79q+JHMxmXLhgiALFmTfjX47G3otoDDfwuNkLIkCJb573Gp0sjcVnKejyhRdHhs/PuiiczYUBlzz/cjZgfuLrscrMNu8hW2brM6aZWvHkcZLH7nMwsBZHQaoHyuGwXFiiO0SbMYVwRCLydbAd7Ku+Wg9QpILJbPn6wurJHN/+ZrDkmMAsnorzNCmPnjKKbv1fm27wuB4ndvIzgZQDp8yuYjGo7cUD1f/DrulGZdg6GbJG/pQH+sU00TYgH3SchMWYFQ9GHFGiskrdKwGLLsoCusNGx84q2nF1Ieae5vnA7eog2grVHZQVKc31rvviJRwmNN3hSxF5Ofbx/TUDEg+q3thc1hiE8chtrWzYiEkmEF8Yz5qhBCPV+ABGKowfNzIvf/QEvFFGEV35WLdFgNcnAJmDFTCkv3Gul55nixTlRmWx20v4p6iHcy283jgmGnIbUrb98AdIi4+zJrB8EohMBd3+vmxRS2vgxY/NZjBBUssO5fKIhpFTGgtye609Tv1jtoBs+/EGwei13mBBtCr+H+RUcZzvIuFtSNDrM2ELFGy2TVfk/68a9NMseqP0TLPCSvvCvhkPjuF05ax+IpeKAYxVSBVdRVEor6ELtIxbD8GJJ/qnrdNkFs2PzviRqL6OI7+AQgLzBMDvqAhxZSz7TD
 LpISMOmE
 gQea94b9TyPX3CAYt7IoiMY8ckaVAv1L+44ZNePlyTdwx5TySOtrrr45oT9ZnmXmfFeapSW/NjF22lj4dIkxeC/Bp9Da+JmWsZMLAjFnCd8Tj1gAMzqAiQmQYjvInq+97EEpnLLTkAfGr5LSC3cHhr/tUg3E/DV9A1K65gl2LQU2VeTM2kI6bzquDMZUHK8Wmcu0fq/iNUxKzVhurMvLAmymW5HLvq0hAg8bQHYJqJkfulaZdmLKM643e2vdvUfpZxV74ylPpZJmR7xFTWCLGmJz8Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement nr_preps file under the preps directory.  It will be evolved
to be used for generating sub directories that will represent each probe
preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e33070d2cbcc6..6d3ed80fb2eb1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -756,6 +756,7 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	int nr;
 };
 
 static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
@@ -763,12 +764,60 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_preps);
 }
 
+static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
+{
+	preps->nr = 0;
+}
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
 static void damon_sysfs_preps_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_preps_nr_attr =
+		__ATTR_RW_MODE(nr_preps, 0600);
+
 static struct attribute *damon_sysfs_preps_attrs[] = {
+	&damon_sysfs_preps_nr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_preps);
@@ -1150,8 +1199,10 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (probe->preps)
+	if (probe->preps) {
+		damon_sysfs_preps_rm_dirs(probe->preps);
 		kobject_put(&probe->preps->kobj);
+	}
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

