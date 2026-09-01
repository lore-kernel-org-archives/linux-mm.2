Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD2AC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81E76B019E; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B096B01A2; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9F16B019F; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95FAB6B01A1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 210FF140416
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:21 +0000 (UTC)
X-FDA: 85165264842.30.A4910C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 713AE180003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zn/Ucqy7";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269119;
	b=Igzv9zleWuLSEHQamaKo2UaiX5TY9NoslwXg+LyRU6ibI8LU3e1em3Gjd6BkYK6w4EBHjb
	6C968yo6n8BQqu6mupe12xf6ZP/snJfghkNGhDlw1m1ghG6YR7VvE1pdlw/eSKyCp/sD7m
	eCfSVpCh31WnXr20jUrwuxSqHLcT+28=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zn/Ucqy7";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rl5ADA+9J/l2w2quHKWsOoHjOvreI5jvhgmI+c48UlQ=;
	b=1aGiNwrIyMPrI2p/UeJISdCnD+xKOA4MxxEnCfC6MKNC5BDPkfwJ+26YBVNtcmVWJNWgdE
	Je/1L/lH8If3XIFqjXHTlq7hobC/BQRp027as+6V5JIBJxA3o2Wtp1BStQLfl4SaxZ/KD4
	IHZ/7f3M5odRP6CZjbilEoBcSbjBF1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C0EF6053A;
	Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10081F00A3D;
	Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269118;
	bh=Rl5ADA+9J/l2w2quHKWsOoHjOvreI5jvhgmI+c48UlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zn/Ucqy7kh/RrUKBA3Rnb708DRV8FvFU/uV6HVXV+JNeufRgIotpUS0FGPWf9hkH/
	 Nst7rRFBdIfd4aUL/BoFWMaOVI4bJzeIjlunTVfnBtjmoecShXHKCUlI1e3KMPO7yj
	 f1k3iXAVjRted5Ig9wcmOJJVRjfApUJM0X68inisJJ62V7c+cQycx71YJFvLP9iTwY
	 sFpb92M8/fGwEy0tbQFlGS/xmGReRSOrO/+f7rAlfUz5XOqm8+UHKY8YwiUQWGLAhK
	 Y1nR4dsBemfJTe8IojAv9U7C2Yfsqp26qBgWgLvCDFgKpE9R6BYCsXJ9EVUMnsD4Xk
	 Cgi6BXop3ZTKA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 12/17] mm/damon/sysfs: implement prep_action file
Date: Tue,  1 Sep 2026 06:24:59 -0700
Message-ID: <20260901132506.99243-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cx7b7q9fyt9xhogxhzyworw75o9tzg6i
X-Rspamd-Queue-Id: 713AE180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788269119-789355
X-HE-Meta: U2FsdGVkX1/Pr1xTdUrVBfBhzqFwufxSwJUqWLtcZ0zUYlubE0o7JXLp/02Yu1Kd7X8qjnzca5vaFOnfI518uJqJenUSYGutxKNtjaYMDkiEngnwtbpZAAmcyK1SQZHs5h0Gk3vJAGdcbfvezcc0nrb7M+4dmIqvPhhCQkwwbCDwTmJJZb9AgF0AucL13jpTv2s01GlMliyP7btjycC8P/ifoa7T1KDAug4sMujF4q2NmkjHOw8PlyzLnWCcCwAlq1vxla0rd07Vla+UDBUlUPst8bnwg6P05vYUPFRu0Q0p31Fz+w7ZDvgTa8NHaNhUd6ZylRbdNcyBsQ2WapzKR7ADwDkLocFhehdmiJRIowvsK9oK5oOwa5OOk91QcKD9s4ecCt8aVm80S73/zy8QRIfXUmuW/mFoyASj0XCa1LAac/EglYFi4hJJOThsBtmcmHRmrt1a8XefOuFUJQYOaAV+Aa5hrjrQ6bJx8gZOd+KOcck7EUNbNCy3zTuSRe59glr3FxdNGQesjL25fZflbUIGxFHafmBKhW5uwhDjz0oYDAPIG8oqDbm5sZBx7lZ4mh+EPxNTTSYaOr+9uFjJEqRgiGmiPI40cfi6ZcoGwZ7xWl5JRP/Z7i9/70OiCAdT7k3XLD24OhmxbHUrO7nIS3FMdZgWqiVYj0rzXF0SBfxp0GvhIvduse4c96yxqm+9pMTrbu3m845RUjhGeY9i9RVC2zhlnMlOUkf85vTxLGQRunDApfEfXyHMZ2roVs+mBjDWeyh55G84+P/jWPzQIUF1yr8QFVLotbFHdRtmoM3GKX9DJ6W2zq31qNnYeXnsgzr2J6fCNf20otgo6y64DuGEVt5EF7gQIth1pcd3x/GK15cZzMD8iDieHehOVsKbi259Iz71eGzpRiC0f0YefBC7VaFqfHE7OkNziN3Fl9vvT6G7P+Gq0kAHZfUE0mlL7ZdueXenfNa2u1Y0k6t
 b57yPTdD
 6ALEh9+96H2aXP2SCbroneDO+k3nSEk2B1D4ET/kJGZN1/yLQmF8dFCFWgnbji+SVkctlt2EdlYaOnF6Yzs7a1Ewaonnxhs1j+o1VXy2oaJohRxQxYR8TmlEuRAwaK3HUmPilaPk0I8nFqjfKalPspj2BXBBh2180At1J6iQRBeLCsyRkVhGZ7E/Kxc4a2zc99wlvtLsv0nXKQAyfYLBGKfYNiRcHyRM43SlkniG1F8WtPsnR5v6vydnaYpa7IgKsz8ZvdR8izt2exmaWVRRxl0vJXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a file named prep_action under the prep directory.  It represents
the corresponding probe preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3749abb781566..1ecf194f71ddb 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -755,6 +755,7 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_prep {
 	struct kobject kobj;
+	enum damon_prep_action action;
 };
 
 static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
@@ -764,9 +765,61 @@ static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
 	prep = kzalloc_obj(struct damon_sysfs_prep);
 	if (!prep)
 		return prep;
+	prep->action = DAMON_PREP_SET_PGIDLE;
 	return prep;
 }
 
+struct damon_sysfs_prep_action_name {
+	const enum damon_prep_action action;
+	const char *name;
+};
+
+static const struct damon_sysfs_prep_action_name
+damon_sysfs_prep_action_names[] = {
+	{
+		.action = DAMON_PREP_SET_PGIDLE,
+		.name = "set_pgidle",
+	},
+};
+
+static ssize_t prep_action_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (action_name->action == prep->action)
+			return sysfs_emit(buf, "%s\n", action_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t prep_action_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (sysfs_streq(buf, action_name->name)) {
+			prep->action = action_name->action;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
 static void damon_sysfs_prep_release(struct kobject *kobj)
 {
 	struct damon_sysfs_prep *prep = container_of(kobj,
@@ -775,7 +828,11 @@ static void damon_sysfs_prep_release(struct kobject *kobj)
 	kfree(prep);
 }
 
+static struct kobj_attribute damon_sysfs_prep_prep_action_attr =
+		__ATTR_RW_MODE(prep_action, 0600);
+
 static struct attribute *damon_sysfs_prep_attrs[] = {
+	&damon_sysfs_prep_prep_action_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_prep);
-- 
2.47.3

