Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22029CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F766B009B; Thu, 14 May 2026 20:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077AB6B009F; Thu, 14 May 2026 20:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59936B009E; Thu, 14 May 2026 20:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCE1B6B009B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9828CA0652
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:52 +0000 (UTC)
X-FDA: 84767809224.17.2BBF5CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B280A20005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bkj++EYu;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/xlby3R/O/Kn+AYDuLBx/++VsKdF6GrZwQGHTwyoMg=;
	b=Fd+8PbXrMvep92SJ0/5bIB1qFw9WauuxbbWJQVGl6syTkG4vY5i8wS+cF24a4PU50UHUuJ
	p7dPwbRv0F4UUUERwpBtirIWsAwEJr6qUjA1vxcQeeneccR2obJaKwPsc4fD9a/ufqCZCJ
	8LkLWc/wNFHyGnah24bHrsfP2+cAGYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805890; a=rsa-sha256;
	cv=none;
	b=cUK0C3GfZsTCvqr6GvF9Ncl1XFqZebCyVSQlBFUvzURxE1pdEFh0HJVGJTocVRiJZyMUk1
	VY6COVYJ3NL3eb5tLRyUjlfONbYKg5T4WPb69fLeDUPYsE5IoRNWexW4fMcwAoiREWJ3W7
	yjdPgKDR5ImAYGyK+Rrp6ZUAPTDqwhU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bkj++EYu;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 692C742A92;
	Fri, 15 May 2026 00:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F6FC2BCF5;
	Fri, 15 May 2026 00:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805890;
	bh=R8sw7cd3IqpXiTp+P06ij8H6WLOiT1rj6PEiqecHRpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkj++EYumGm7QpLo9MUXQqAklmyNkKzq6wQNzFE/Ka0cCt/LHT0LM2+EG+KHnZ/Si
	 OYvymtS01FBY3rMx0tSOVwgxs0CJOJL0e/hk+TmAZDg/0vdqJ6cpioG4uZrrEmqnqQ
	 zmBN68KF1RtSE3TCv8iD3drYf7As4v587QaZGAKxD1pjSaUHOsvvZusUY/StWSfEPr
	 OR0JxnMkS63jozC4CkTfbnwDcxJPG8qIs6a7Ayp4SjoDkLkINfuJWAyrI/xQQoBOhH
	 muaTTGsVNtCwqqZiIQDhW3TNdbWDwJ9PklqyONceV0WdFhIlf6pCksEdCH0TiU6XRt
	 t6pmySXni8JGg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 10/28] mm/damon/sysfs: implement probe dir
Date: Thu, 14 May 2026 17:44:11 -0700
Message-ID: <20260515004433.128933-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B280A20005
X-Stat-Signature: rgie8a6cbp8gj4m8eh3anjr48mb891dw
X-Rspam-User: 
X-HE-Tag: 1778805890-487685
X-HE-Meta: U2FsdGVkX18s/4VOZ2mxiWqW5LUcuiK5qbpRARxDPjh9jkdUxHYPmqGscvcsA3W/+aYxxyH5B2J+OFzYtdWy5IwoGE2MbMS41EtXlFo9oRSJyK0zpRALX+fHC5qLZS9T8T9dihMdZ+EUmVGYV3VFYvqmBcglSGdOGGcUPOgh0ZM2FLIVUrNWvciTUP2mKyJPNj8Eon6j/8Pha+oXnO57Nc4BRApQlT8Vv06RYeVnzobV41wLDkFyzx9mQVtOs0Z8mrw7Qk/dHdYoI27E6PDURhfbFjbTBxAk56i7wWJEazqjjtZ42CRydNI9FqL9N/tWtXAOcTFfEEyfC2WRSBP84FG5wpTsSumZMR7CFnGThuB31EMcN2j4TBqF7dNmzbxCDwS38GsHX422UxM8YfToF18BIvbnxt+qZMhnaeGiwVx15WqKwp6vXAxku/nHqbCh1sSxfVS0+wGwyT/iM7AHJBzyPbMfyuPTwef9wohUOKbNJ6KdZ4ZUcdrFGXhbtnY9h1maZ2JbCZM3Eo/Bl4wKIN5V4JvAYi2mgkXYK2LiUNw3oJKbpdP49hqWMusXL8Qa9Kvp/3Ov8A4AOt38fVh4D/Jb+uORcXX+HCv+FqyWIlScXslcmhJw7Qt2LCJxWFHFpDs7Aua8IR3BVSvj3+6vGg+kVbUwAiEwI1tIky30x5QcOPSYi78DqFmALvvQk3TQK0qgHs4Oa6JJaktMnHXcw2G3S29agpN2mPTlECwLg/P6ru9Uyxh4jsQZWKuXW/sd0IgVMQbTRyxt0yCVEIVGVulpmgoj0qGHGztbfjHOORQnsGl7GeoHWXs+fMbcyiJFMWEAzpcTzVMs6oI7sk32AZStrzhgpNCZuoB61O1Mo03XG7QuKAWMDij4xmryLd8l6GbcmnlRIU9itXPvObQ2icpDNRTo9CJSSAShrZ3Uh0S+NRC/Xw63jyTY8RsZfeRgGxekRfvaMyCXsCj2ao+
 MtD9Cpk6
 TB/w2xCoTrFHXhcVrxZ43h5da5AJ1RtIR/4yktcTQ2rwo7VCkHrKriGNkLECs17QrDHjbpb+FSKqyXntIyGBy9nhCR2qmEH9AC7kqmIRU4Dv9ldIqfUAV/DxD1f2SfJKFlxK/naY1ZsUUUPQndTknVCWdyJtUsXdCqoA+oPsci5SZmNaf1FDtp5LFnUlqsqWsP3lUu4hfQjLePdXcsMOHffV3Pkf6jH1U0S6vWDvvcN9DrLHU9z+TUcjpkolBz90wf7Dr0/63sQwze7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory for letting users install each data probe.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5f3b253f50ebf..c028e4b1281e6 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,12 +747,43 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * probe directory
+ */
+
+struct damon_sysfs_probe {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_probe);
+}
+
+static void damon_sysfs_probe_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
+}
+
+static struct attribute *damon_sysfs_probe_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_probe);
+
+const struct kobj_type damon_sysfs_probe_ktype = {
+	.release = damon_sysfs_probe_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_probe_groups,
+};
+
 /*
  * probes directory
  */
 
 struct damon_sysfs_probes {
 	struct kobject kobj;
+	struct damon_sysfs_probe **probes_arr;
+	int nr;
 };
 
 static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
@@ -760,12 +791,99 @@ static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probes);
 }
 
+static void damon_sysfs_probes_rm_dirs(
+		struct damon_sysfs_probes *probes)
+{
+	struct damon_sysfs_probe **probes_arr = probes->probes_arr;
+	int i;
+
+	for (i = 0; i < probes->nr; i++)
+		kobject_put(&probes_arr[i]->kobj);
+	probes->nr = 0;
+	kfree(probes_arr);
+	probes->probes_arr = NULL;
+}
+
+static int damon_sysfs_probes_add_dirs(
+		struct damon_sysfs_probes *probes, int nr_probes)
+{
+	struct damon_sysfs_probe **probes_arr, *probe;
+	int err, i;
+
+	damon_sysfs_probes_rm_dirs(probes);
+	if (!nr_probes)
+		return 0;
+
+	probes_arr = kmalloc_objs(*probes_arr, nr_probes,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!probes_arr)
+		return -ENOMEM;
+	probes->probes_arr = probes_arr;
+
+	for (i = 0; i < nr_probes; i++) {
+		probe = damon_sysfs_probe_alloc();
+		if (!probe) {
+			damon_sysfs_probes_rm_dirs(probes);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&probe->kobj,
+				&damon_sysfs_probe_ktype, &probes->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&probe->kobj);
+			damon_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+
+		probes_arr[i] = probe;
+		probes->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_probes_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_probes *probes = container_of(kobj,
+			struct damon_sysfs_probes, kobj);
+
+	return sysfs_emit(buf, "%d\n", probes->nr);
+}
+
+static ssize_t nr_probes_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probes *probes;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0 || nr > DAMON_MAX_PROBES)
+		return -EINVAL;
+
+	probes = container_of(kobj, struct damon_sysfs_probes, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_probes_add_dirs(probes, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_probes_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probes, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probes_nr_probes =
+		__ATTR_RW_MODE(nr_probes, 0600);
+
 static struct attribute *damon_sysfs_probes_attrs[] = {
+	&damon_sysfs_probes_nr_probes.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probes);
@@ -862,6 +980,7 @@ static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	damon_sysfs_probes_rm_dirs(attrs->probes);
 	kobject_put(&attrs->probes->kobj);
 }
 
-- 
2.47.3

