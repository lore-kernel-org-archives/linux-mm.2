Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163D1FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED5A6B009D; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DD36B009E; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8651A6B00A0; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70B6F6B009E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C2908C0E0
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
X-FDA: 84701905722.17.6C59C71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 58F7520005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEjdlSR1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236759; a=rsa-sha256;
	cv=none;
	b=WoUIelpaIcBr/1P4/jpt8CMkMBy0Q9covpAaidghfDS5TQDdPj9KAwOEalpalIttbmZ16n
	5OtX03erngPTiZWPcZ4WAuMq+4GVUB7G5bJTGsWrqee56vx3bnZBKP4wz94tFcc7+q4Nt/
	f8OrlG1r2qu0RT4NtVY3n+mmSQU3/FQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEjdlSR1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOW0LT6+toGfbl3Yy8g9HLidMaXBdN4qVHviztm60B8=;
	b=DRpFEcn0zl3Smmz6o/i7IEXhvVjRTgm8FvLnDIu11qR2+6F3GoIXPDPGrAtgU7N8Zyz4ta
	zKRfy2OYGG/PF+LNKjLn47+tBpO6oa7SyhXeQ+jEDfy3yy4Eao+e6xobTQqijNNmKsRHod
	04MLVeC6/glV7quRotsjIx9eiUab0Ws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87B45401B4;
	Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7DBC2BCB8;
	Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236758;
	bh=1X/9elsFEwb1GaGkMj7npSZAXZWCxyW00t9PKZHBG7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEjdlSR1yVbl+gKDDdPas54B+DvBcCMZFzXzhSS9T/EwvC+WIjSxbcGSDCCpL1Ayv
	 0wpJERPKk9rxezxVGi7kk+WvSDh66h6U5zSpBjtdvHw9LtUe1p+dZHRpZl69kMuZ3k
	 JcL83ApzIrGgGZvc+4BGSMaiPiwEB+FGx2QsUiu393OmrN1jc/CKwTufzK+wwJsiJg
	 oVLzdlByWVLvJFWFdfmPgvPm5TeL67hX5zxBur8XnKce3VIe/QctKLyp7KYzpNJgjn
	 gbhTUZJlYozYkqPyJZc6hyTUHKz879AO9LVAtpAKqQCx6TINPNOnKHVeASDwsQIC0l
	 ZwXzeMMRIKPcA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/19] mm/damon/sysfs: implement filters directory
Date: Sun, 26 Apr 2026 13:52:12 -0700
Message-ID: <20260426205222.93895-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5ncu7xjh9skc3tmrkt7ayrzytxk75zrk
X-Rspam-User: 
X-Rspamd-Queue-Id: 58F7520005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777236759-351494
X-HE-Meta: U2FsdGVkX18fA63Fu5nsDumoDv/4PiZh6pKku4dk99/TTUhWCs1tBqp2Wvx1BL6TroYdKAr2cO1J/m3c6AyF4JDOcktvHff1H4Pvlyv3CP44N/5nz0hC2I5m32cVJbYZ3BFA3XJyx/W9wgx8TzDnYFTAxSMYtFnx1Yr+XPor3rrHNkf8r0I+ONy2H1MswDS5GOIQnKIXfuTe5H0CTf00E3oiqnicceA5e8FC/RaEd4winlPmqkJceLUiyYXB5RxaebUmiqSaGvog+WBn2DqC2uhj+FAwIT19gQU/gd1Ied3oO0IviGgDT7/nW78m0k9Xbk7xWN5Tz9jAvWgmrQLOqdGSsbFRmq/2FkHPR/+iywk9mjkX3y7H1+/s7npm9flSxHnpZpg8Z6nEB5wvhPvZ9Q/UqAxqu3AyWNP4qVgqZZNQGEgW+1bwe6yYGxlq9af4eDyLc+jGm82f3QufS1DGBAu6DhFRBJ3mppSgdrDtWL6dv/7yOmf3CgGAAUjY20IFWHw/JLQCAbGSdubSGpMsQJ+CysG70z2vydT8Viy7RNR0yCwHA2OnGY8Abe4mbeRQRAb+VwTfxz38wxlLjpR1zXNVwVHH02kcEanvKwS5OWwyS/uMSW38ggDCBa1aURjVZJfqJ9ZMEYUNXsQ4UKZD5lv9kz9y1cHnU+BqrxX2qWkh1P76bDpLNzXihmQpTXvWuoj9pX6emOLEdeHH1LWCDInrO1EjXQZTmI+ro5F1soBYHnRYDlhhIZ2EqRpZaSMZVzH1yzPbC8qmfGIMLZU/6drvIjKEPd2ke/tdRM+A6vSTXUi8+L0aqhSnQtq8xxUhDWZamhBUPbuW8k0DFNpssplQr7PZ1zjxaDKCpJsaMf2ToX1H+SjeOrM1GSVukV0m70cgI5JMUMMlELUcP5/whkdpuIkKEO7j4VFVgClrXeh4MVxnyWmkT4r6LUBudtVUWGQnkIldoeDMwk5pKkq
 eNBzmDd3
 wd8n+MsVLAxnA5CkpUCZtaN7F5YTRdoJQfxL/KBXsuXk6TfMA0oAY3wsrAObv/K78+sLB7NGUk3rm1Fo+q2+nPsdz2DbBzhC4vgmXvg7ptmKtrYNc0NU+sXhryuAKGqWzBI8/q+AvtOUekMOHRxSoW8TTrZLohQPPD3y+nmP1QmeOLKwYI+uZLjghlqiVqZ04746K9SboXYRQ1SjiDPA8N3NykI6/S9UfYfuZUwlu/QE25ro=
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
index fac4e37aa2851..250208d3de21b 100644
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

