Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE96AFF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCCA6B009B; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F6B6B009D; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8246B009F; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A0E576B009B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65F1A1605E4
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
X-FDA: 84701905680.02.C7044B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D820F40003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RszYeCK/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mH6giCxdh124Zq3I+dXuH1/1rU/xZgVOnEr3DNyTuh4=;
	b=H51Kw0dnFUANsKYo5P63HE8AW6I1Xjip7C+P9Uf1J2FvyPNsV4CjD+hxb4P9+W2v91UOBm
	998tshwzZDRiUd/fJRnQ9P3E9zQrEOqN0Af3jghliglvadxESTw6jW2CYkMj0sBL6ER+ur
	rrrZQ+MACEWYmGpCJULvDhktZb6yMBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236758; a=rsa-sha256;
	cv=none;
	b=OQ4ZHbSK4BlHFVAADpiSnMMJyzaEF3DBJsH5fr2uQyEUk4U5yemQqlgmoYqASGV6QZqzZ+
	8r/pqDIklmwwgRxcsXQbfFfL97d7hXBb0DTceU0DVDE5p0S7yPndhJhb9WUFMgPWvcu9dI
	8JuMPEbpac/HuWf6qTLMkBflW0S/S+g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RszYeCK/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D9486015B;
	Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF33C2BCB4;
	Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236758;
	bh=SZZB/8Y34d4c5OpPrN0Tt1+a+YDiqj7LFYZQ5Lka3iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RszYeCK/blYhK2m9WFnoBbe2hjrXRWV+VXfeFXYKhrWVzfuV/d8YoeCV1o+t1txxv
	 NJg6uGYJX4zqwrCX9E4Enfmy+ojzPihTFyS6EPM1Posl3NRIQ5FEaAGifgfVh+xb9V
	 K9KuSYJ6NlzPFxZS4Hve8faBOuxDLtb3fTKS4K8wkeqFsq5G+XGKuEPEh7h2ozhEni
	 hLt2iRka8fobuAqNWMjtR77IRjRVidj8+ohyq/u/wshqoLkKxX7OVx6A+zB7De8afi
	 gUM69orKJE4naCQtC3GBQ3nbPDv6QG0dsjoK5fDheFBJGeUVcIyKF5G8982C57L4O4
	 etKo5RAMHabNA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/19] mm/damon/sysfs: implement probe dir
Date: Sun, 26 Apr 2026 13:52:11 -0700
Message-ID: <20260426205222.93895-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D820F40003
X-Rspamd-Server: rspam04
X-Stat-Signature: ifurrhwbutdqx5deqr1qeu8me49gjhxn
X-HE-Tag: 1777236758-89200
X-HE-Meta: U2FsdGVkX1/i5ZoiW5MiFCRhw76e5hFG35NfZxjBGfspZdyCBufhG4+99PXpdQGp+z6WFZwr0CMlNGKhcPu+f/AdCZNV/qtGqdH3+dWykJ5outFWGm5vwWCdBzebZQBRX8O77UM6l3J5soUCL1M+p2WVi1I176vD8uyiaMPFwJCdcFZKwS7sJZhvL8EMTUX4OZiDreead54e7JebWB3PLU78b5Cs5FpfwJqPIb30WtPfhTjV4fDdNvvTPYMG6UcKQJYWBEY57WOtzCpv9ytRa0ukzulzQgAJxBi8IjFdsOhvq0ENdJ6X3lhBN9Yq3w+A9ZNqPK3oEthBBHuZT+et7M50yTnSms2xnt4UUI+NEg96rnp4mLW/Fn3tlPHiFTLURtKCY19DXX6NJoDPedof6tPjtWsR/m2FCOeVvOmb8tJ3H07G6pyTEzHt5hlDMoCgyodyKyz5qPGHRI0msf9Z5cvWz7tLtLjHN9aSVq1JVND2OloGQCLa3wDOFQhaur03d6hZz5is5yn315OW9XQ7fTiwL49ROxR/9oZg/xywNopN88hHkH+S+hKjtmjYGAaJ6l/d/sVoNMndlyQ7iXNfonucaLbKOXNrOvVsKY8+ViVc0v/FVP35/Ar5tD5NuOI+0ughAmQn+SjZMobwztLe2bQHlW/l4F/EyJ67CXs+MRCaR2v5X3tXiS+6e9kDfD7wDKLUd4p9fwk5BartO1RJJswJTEE3StjNQc2wRdrt7JYrrXG1D4/2NPb/T4/fXe2pDvJNZwJgTFG0H03P+O6OIsQsIiHCSFcYayJ9owPcgPmhxl52jiKhIgDPrltFvbWLNXEUn4iFkt51N2F/FIXFFST15keQ6XdSxh6Y/1KAWZIzD6pPFAmhsu3zSx7/9JfAuosb9Fv3Lx+8CYqQuWwqsW9FxL8uS3WAQv5qfdX0JPMxCQLY3KhVwE2+ININVPKJbSncL3Ucqp1KApR75L3
 oxAmIJO1
 rmAxzT+L6b/MMLsoB+AeJ/+BtK7yF6RD64kll4DTb5/qV7GIZkmuh3zZVOxmn5u/Pr8mfPF5hNPpxAv4C4xIS2q8f4KpeUI2sriV15NjepB/CXdXeZqjNxIF+tk5omsaeeCXDVSoFE1m8k63F2ZJ+/+BtOKmBcRcFCXL9BlYZWuz+bQIZsSmz3CGgfbed4hVIV3OKrxs1uKpxBSPiKZUiWUvM2EWienvxvcdVaTCzZXqA6N+FKH+Yjy7LuODrcwLGLc4kebvDOUuitGk=
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
index ccd19fc062f31..fac4e37aa2851 100644
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

