Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1021EFF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0CE6B009E; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6A16B00A1; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA9B6B009F; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7099C6B009D
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 080451C091B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
X-FDA: 84701905722.18.9DB6F53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7B72B1C000C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDgndp7j;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ULDK/TnSfLd9MtX82JW3Ej1Gak5V8YvFYrL2vCQeZc=;
	b=lMw7Q331xFJKflCk8ycJW0J73/rPemdu8SO9L+eOaC3Mabg515RJ75OiO/Xyj74XPUWs+y
	NqQandC85wNsj11/Eh3udRFt6xbU2C2XxRjTBwJwpiRD3zGDIsXz05Any+tCoGlI6jRL5T
	VGmJJoMt0T6HRpOsCkoFd5awJqNy+iw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236759; a=rsa-sha256;
	cv=none;
	b=0KNycM19y/2l6bF04fBktPNEKcNt/CQObTjSmsOzSmereiOQ4rfwVZg+7o5UIn6u1k2VaB
	VW580OSvq7Lo+vimAH5kMSmwvl7amIRrv3lUQPNQ0YScj2VUzYh3OlpWQjlDvx8Own2epk
	KUULHYuuHlRRcH80KpHyA+/KcOlfHDU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDgndp7j;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1240B60145;
	Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFA6C2BCB4;
	Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236758;
	bh=RwyqlL/z+o4fkUQKNxBQap95FJCMMs79UsQe2MpywvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDgndp7jN1PfXy2bb28amtVbildpF/U5g5j6n0mItxpbPyyGcBnlofjj7jSVd3aI9
	 fWd/aeV9+93ivO/j93n6EKq84oY6trRNCxA1yHfOqira9eEwa95sizpqv7GxBPkoFg
	 UMX03Rdhq9QO6aKKlGOkYKp8OdeVKhMd5mF53roU3FGF+OqDcqmf5AS6CI0e6lx27d
	 gycxXtEVX6Elrr8fWiybo+5wd8AEq8kDcC0T3M+iHBV+CIJCde0IuLtu6IR5BsZwV/
	 d89STqKfd5wC2yK6d2Zgu4ynK7Ntqg95mC3bvVQK2KrIdwdWaQCKaqRNuIAuFFQL+2
	 NCWU4pVitJgtQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 12/19] mm/damon/sysfs: implement filter dir
Date: Sun, 26 Apr 2026 13:52:13 -0700
Message-ID: <20260426205222.93895-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B72B1C000C
X-Stat-Signature: 3isfow87yt37ukypxzbxcdppuwu9hfox
X-Rspam-User: 
X-HE-Tag: 1777236759-284679
X-HE-Meta: U2FsdGVkX1/OXzhmxW162fDS52oOV69j4YgBdxXEv56k0fukGmR8bGtmt306xW6LSVa/IHYIceuTeZanS+dxoGSxl9mx8CrDtBhYD8hLU1yoneXj3zsJS2tWxWT474v6hHFbHU7p/8cK+r7scx8X3lJ3/IFvbYYfTa5lPC8+FrwO3wOX5eS/G+npqmiP8Lxu5mVyaxvoquum+pMmVYV0yYdKoKPLk373NqGMO0P/azYg2B3uVOY1VrMfW+ew7NBO5PtDC2TJB6L42DMHU1p0aN5Xxs+gY3Iv3tSsVqFu6BMJ6UIgTz8MnnDXnHTXNfgCzVpNRekNKUsj8A+U31+N/80CbhRMsg3hI/05KfsB5qv6uOhLjRRuUXTM/iyjLM95wCeGDr7ivH5pEHW/OV3deingSbfIjLuPES1SeVeMz5CTT7SlT1HvnGz/WSOoqgurLAclWXcUL6ICQNO36Q2K3KHh8tj4RmXkpfg553Nnkanmytw7Tjo+JWpQN+BPI38+aOS95WaFhs1xgu5Z6Gmeexol6xvS14WLDnHcWSNVRTXmf7GClVf5T1bexavi5DzPlZHq13Gyp0U7ofYRiIriLjEpoYw2epVqZ/fKjc7Tj2GD6qS2OUKV+EhbSxU4bzlvSHL4u4Iczfs9A+5Gph/ypZvwEp+V8EGaqHlEW1KpwT+Y+kB1iscaxwLj77NLkb8nwscQhHyXRYpc9RDU82UfyZMVJpW73MuDcJgQYpue2zuYMZVAtc/XAHmeh2d8euwVixCjKgoUYHUOue+2ha0cp6/o/EtXnysrC2Tnib0tLlc11ywVYwMxTtAuLUDNnLgTvM4c3IhQLIQVVN1MzYc1CZrZOpf/G68/4RSL24W/mWMhOeS7ZZv6WgqSuzfBB1fiU2Dr5bpXguPRDmFWpxcxxw3PmBNtUPLcSKo7BJXwzG1V4jqMicnibSs2bqM/WNwtVdwn6zqUMvRcHC9M1bg
 UNNmadnm
 l/mDmLZzpCyfkYhOmmYDSVnlrbiPNDKnnfCNOXsCXL+/HHev/KCFrqXJPLeSWTz+dWMtDePn5U2tySutPPcllSe4U/G81c46cAQuqINx91MreN5M3y7fQEXg1U12fnJYqZvOZob7iOMa+ibOS6phJ+BaYviSUHhBRJM/eRIqMesWSHJu/ENFsGUNj1d9IKHIrN7lZO5zHoKwpuRWpXCu4EcRCjLIeyQXkjTAX5dmTb2pdOKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs directory for letting the users to configure each data
probe filter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 125 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 124 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 250208d3de21b..25487a0268cbe 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,12 +747,46 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * filter directory
+ */
+
+struct damon_sysfs_filter {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_filter);
+}
+
+static void damon_sysfs_filter_release(struct kobject *kobj)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	kfree(filter);
+}
+
+static struct attribute *damon_sysfs_filter_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_filter);
+
+static const struct kobj_type damon_sysfs_filter_ktype = {
+	.release = damon_sysfs_filter_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_filter_groups,
+};
+
 /*
  * filters directory
  */
 
 struct damon_sysfs_filters {
 	struct kobject kobj;
+	struct damon_sysfs_filter **filters_arr;
+	int nr;
 };
 
 static struct damon_sysfs_filters *damon_sysfs_filters_alloc(void)
@@ -760,12 +794,98 @@ static struct damon_sysfs_filters *damon_sysfs_filters_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_filters);
 }
 
+static void damon_sysfs_filters_rm_dirs(struct damon_sysfs_filters *filters)
+{
+	struct damon_sysfs_filter **filters_arr = filters->filters_arr;
+	int i;
+
+	for (i = 0; i < filters->nr; i++)
+		kobject_put(&filters_arr[i]->kobj);
+	filters->nr = 0;
+	kfree(filters_arr);
+	filters->filters_arr = NULL;
+}
+
+static int damon_sysfs_filters_add_dirs(
+		struct damon_sysfs_filters *filters, int nr_filters)
+{
+	struct damon_sysfs_filter **filters_arr, *filter;
+	int err, i;
+
+	damon_sysfs_filters_rm_dirs(filters);
+	if (!nr_filters)
+		return 0;
+
+	filters_arr = kmalloc_objs(*filters_arr, nr_filters,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!filters_arr)
+		return -ENOMEM;
+	filters->filters_arr = filters_arr;
+
+	for (i = 0; i < nr_filters; i++) {
+		filter = damon_sysfs_filter_alloc();
+		if (!filter) {
+			damon_sysfs_filters_rm_dirs(filters);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&filter->kobj,
+				&damon_sysfs_filter_ktype, &filters->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&filter->kobj);
+			damon_sysfs_filters_rm_dirs(filters);
+			return err;
+		}
+
+		filters_arr[i] = filter;
+		filters->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_filters_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filters *filters = container_of(kobj,
+			struct damon_sysfs_filters, kobj);
+
+	return sysfs_emit(buf, "%d\n", filters->nr);
+}
+
+static ssize_t nr_filters_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filters *filters;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	filters = container_of(kobj, struct damon_sysfs_filters, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_filters_add_dirs(filters, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_filters_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_filters, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_filters_nr_attr =
+		__ATTR_RW_MODE(nr_filters, 0600);
+
 static struct attribute *damon_sysfs_filters_attrs[] = {
+	&damon_sysfs_filters_nr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filters);
@@ -811,7 +931,10 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
 {
-	kobject_put(&attr->filters->kobj);
+	if (attr->filters) {
+		damon_sysfs_filters_rm_dirs(attr->filters);
+		kobject_put(&attr->filters->kobj);
+	}
 }
 
 static void damon_sysfs_probe_release(struct kobject *kobj)
-- 
2.47.3

