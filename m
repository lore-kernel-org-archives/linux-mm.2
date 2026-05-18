Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F16CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B8B6B00AF; Mon, 18 May 2026 19:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2966B00B4; Mon, 18 May 2026 19:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749866B00AF; Mon, 18 May 2026 19:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8A46B00B6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1877692ACF
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:30 +0000 (UTC)
X-FDA: 84782164740.25.AB52DCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 35ECC180008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DEzq2doy;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdy3f9tVd/dF9mOinzcFuxCXM10adPPnKW/BWyDiHI0=;
	b=B8UlzHpZsOnNup3W+oxv60zIhYO+WuaS/r2uRcOQG2sDJrWQCwcQ6yS/6AKuQErY5NdPW7
	KwdQ7qCR2yKg4pVaUpvxi1Sp3JADkbYT+rOkwGZknL0mBmZv92jvK7Bvp51f6tMtRsbntt
	kJoEoJYSTL3xq5YNYc5YWgNgVw2zfC4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DEzq2doy;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147688; a=rsa-sha256;
	cv=none;
	b=lhzMcUK2n9v9DdqY+H38j7wJ/XqXPQhIVO2r6YdOJjYCSyoDslvW+9AY+DJT/EZLLlbVwT
	EvtO3znq7kv6jgpmkpWXUfsBMy/SEt/zbo70SBPOBxpMV5OUFxJq6PgZXlQGqlGR3AwY4d
	YLgM8/8uo/ZYr/J+6O8oyj+4Wu8vaQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6152C438A1;
	Mon, 18 May 2026 23:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B75AC2BCF6;
	Mon, 18 May 2026 23:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147687;
	bh=k36/Xcej0i3WC6azEdy4/45wiJ+RQaA394vMsLmcu6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEzq2doyKH3jz7AF117WqLyGUs7NJpLCgGzJ6BPBdAmNUm32uy2D+Gc3gQCiuCl9g
	 eeWJjBZp8Vr1JVtFZq4eTYJ09Wn9H433ix+4OyOVyf6SpE6pG+WaqEjgICGhlXBcVF
	 TqSOwYDd5hClHdnX/hGBn9nUrn0Y91xbDSxHmIcuc0LA3LzelvLRlPEoIy6Zg/6Pn7
	 8rJONbOySgYCBNMH6O9QbgUfzv+pBxGbihLghC19PaOXB8+wA2nxvpWa7KJATXtliM
	 SKuySbALiuWH+e4wSRaqUoiz536aRTEZoiMcG4VEYFF44wiQDy9re63ho/rVm6LdfW
	 iSlwNVCIZcu9g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/28] mm/damon/sysfs: implement probe dir
Date: Mon, 18 May 2026 16:40:58 -0700
Message-ID: <20260518234119.97569-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 41mwsxr1euyjgo3fjumgkkb6m1h9nybd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 35ECC180008
X-Rspam-User: 
X-HE-Tag: 1779147687-835664
X-HE-Meta: U2FsdGVkX1+3zWtm50lkd4fnoESiYHKqCPYMqCxzvpShzXo9g4OmHJdsZ8lG3pzizi/m10XE0JXfL2DFn8UvvyhQ+OzRkqTQCji512Sv7vTvpzdGJcnJilv67T2jwCK7BgqwqhwSgrYX92YpdR1MBoS3virTmNa0RfOZO74v+tQPgn8mhudkhkaMAinA04Sab1N6t1kUlYq42QlPqW1Dvirxrcz63Hz10IuR6Nsi2n0mde8SBCqwTpvtHY5hg6h0AZeHKyqpRA+PAQEJUlESjK6eF9aego7giBVxTpjMQ+50i6TX1Ar0fohiMVtw/RdxuKXkFFVxaP0D46LNxXQ/15gvXIZbdqZix5RXbYl/Kyp1mgEIaY9ouFW0hghqej9PIvMCLy1cr0xzqWvPEZFbSD0ivvSb15naCUdQObGF4w2dOlEDX7Ay1VM62Sm5jrhd0a4oWW4MycRVR7uSUbQxL4+Xr+ya40oMD5TO3WFcpx9PRAz3L9A3GfuRNCm9eQ8dGk9Zs8uZ+wl6upiDe3m2MMN3h/OvAD20sXDyY8QSic9NYKpPr5lN8MLITjx8O4R539okiwv97pv9xBtSl2Y9ystPuT8NsR/pbJHXRjcZcgKG+6L0oA5FPICgnbKgmtJ2XYMdIgn3YaHEQJY/oLLJlaX/1tqG+rl3JEPpf9q9Yuf4gn5v80P5SuGTHnvV99OvLa31oFMVhhj4ZxTLHVxRqvawr8twqNj1vrfbqyQWuBgGi6yp78Ld1gfD9SUlgnyZfqWcfjgIrQddjURcpV0AoNFzTcW5aIwaPPuyhFQCxN8ls2T7bm/oG6IWbVaLK7GtKIHQmzA9MJ3N9xmy1C1jt8chSY0+rpg9NwuGX2kqAGQuUE0dRKpoEUAkMRF9xAcz8KxVe7Rg8EyybFWZtT//NEAlVeN8WT1GkYqQ6JOytgcrp8HIcv92Hoi3AcUzKe0qzOG+uhsGME4l11WucpF
 D4/C0UnK
 82DSWgF6847PgJl2gM6HtLX6gtLGP7dyD129C9F6ZVIvQqVJVNwu9YOkmguGfTAUQ8ZPBSCOCGXZnDhZRogw1uPJ0voZstfbaGgYxq6nilUqZk54vQfjXxj2n4ePbXkXpjh08QzajcH0/sXoQM6TJW0pIIU51cGYlhyNxs5cW2+onuVZjbGXuUbviNKBujb7AYbiIgpEcbikxFgvyCvO4pl66r8w66K515FUXn/S/QlGhs0XQN0UQVr/hdoKbW/hT2DY5YCkZkOyT7TI=
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
index ccd19fc062f31..6cef3eaa4431e 100644
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
+static const struct kobj_type damon_sysfs_probe_ktype = {
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

