Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4215BCD4F4B
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3B66B009F; Sat, 16 May 2026 14:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D776B00A0; Sat, 16 May 2026 14:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF3F6B00A2; Sat, 16 May 2026 14:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6B46B009F
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E30088CD9D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:30 +0000 (UTC)
X-FDA: 84774141060.20.90D8980
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 37E3480008
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YN8D4JCL;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bukbMFU8ZI+F+bjapGu8hnUTnw+0T70M80Qy+ksQ/uE=;
	b=WFqBBll1XESygUPv+zOonIBgnTS/+HHBYpBF1rVxhLT/H2TxHbyC1LWAxFvJ6xnQNxgS5N
	T6nNyK7T/x1G0tqQCXJJSDKEXfOFuBOvhd3YBbPO0aqThpf+TSfcp+lqVRGOsdwl2viB1Z
	i5wyqKD4nWbqSXRg7oAqGIyLuH1pc6o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YN8D4JCL;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956649; a=rsa-sha256;
	cv=none;
	b=dsqM8/lMmfPyk11MsXUDNWfOop6WA3CQV8kgeiXtlSBBiJZxGSx6ruihqJeM4EIN7v27lh
	dQ5fO+I2vA42iGvSclcLjCz3TvisfI/cCtgkty027py9da0tXQJgVsJc/xcenI6yd20xZy
	TPhgFU0snr0OLWJqbJqxRRZTQ4iLx8I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E11B445D2;
	Sat, 16 May 2026 18:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2391EC2BCB8;
	Sat, 16 May 2026 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956648;
	bh=OD0wZNpcC+Au5uSOMmYUQ5fPYaQIj7kX/hZbz/+GPQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YN8D4JCLL+HrxEMBxVZFpgIiDelUdXI8eLib16Et2mzONInWwqZ+q984uO3TThopY
	 TfIUXhYEyeUADwzARLTb7jgaaw/AJnGzBycrAHpVjHqSAscVqFYb0Q73/7LsRcD7vf
	 trYd3BUSXdmUUF7N5nlM2CUyRP58lYTFivQ6o222ytUqyVpORNTMcq55SRtG+Jk9mH
	 8o8qniqKBdFE4avz+qYodiYmFtqHMaWbcEFsilYeTUOHdKCDXDzqrRpTEwHk5wR1Ag
	 xbegDnyf5iltMACaUMI0suK/15F65RBvC2yoAKcR0i62fBNIXre3lOxQRnnDigLyhQ
	 a5bUJ1ZbjtgTw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 11/28] mm/damon/sysfs: implement filters directory
Date: Sat, 16 May 2026 11:36:52 -0700
Message-ID: <20260516183712.81393-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37E3480008
X-Rspam-User: 
X-Stat-Signature: ziseyua3xibdxjuiwgp8f7sxo3nmqmxi
X-HE-Tag: 1778956649-262507
X-HE-Meta: U2FsdGVkX1/HBahXHO8jwFjCmqfor9dmpXbVu2OeXgyKldpSqCYiLurq4B4WfkJbFZnPRM6dIUXYURJ6gADlswxxIN9Fn5RedKktb+KgteHI1vvj7fw3VHcwsI+KB+x+9JUg0IbBNznbLPor5xekjP9eLgYJcMsO5WoLWTve2cJRcVUOh/+33sRMJttYk/0c2TD23WJ658peNScuKNzrhQwvBzvMw3kJP7/egc8N67fooOcuKbqLufflUEwGA+k3FZGdth7XNt6I86AA2g/d6nSjuQ1qefWg2p7IF/WWYWbCBTo7AffndQp02Jr/6RT0Z5IH/WBwG085hETXtr+Pjc4U/tl6lTj6EnUyNdHWnvpr7+zRPskSYeTuPol+wd377uUl83jNVM4f0bIpmsobnLHiygxwARWDqZz+1iGCimw87m+OWp5lJJtbO/74ac2LGCb6EM7RGuKxzC57+ZT8kiyh9K7i/BLd236AoMOiLCbBbO8qxvAIH3KMH4M3iBC3p5pd2OLW94n6af5Uk4yz63wBjkDBndXSi6PQKPa40vrL2P/n4SYMf8LzqUogxEwZ/Ykiohjsyex0V4IkWqp4EDqGIrHHAvqvzDgdtBFBxgnY8scsd9jyFJLRLK7Uj/Y2EX4iu3cbXosVSjJBwbwiAHqnUityKSt/zJ8ndEVM/irRY6WoV7JIyrLUv4zXo+UUXuDOLDhClK8Zdz0vLaAeNbMC2rEKKJg+QFsDib0e0+9zTQP9GkYjiYxRR00Zp2MCOTPTX2G955u+MjaF70Nu8K/9K7V4KaxGV45WK+ly0aTwGF+b9D4vO34gLDXoLgrfT+Ei43+iGjHBVju6YXzDsXwFpZrG3o6wFhFXeB+W30wMkL07IQKWyMv5Boi03/GdkeIpXPetv7FBfxC1AyGb0RqngHTYafxZTyWqOKSJTNBkBUx6RFasTXEQ+0h4L3NHQvCZugf9aDsrMdvGvpH
 GS7w83JF
 CMLU2iyTLDu9AXl1164amOlZnsKOLrJdL3f/+XzeTFfWV90JmHVbr4WEa6E7YeodHZftyTas97zadZjNQYmhorGuqAHRYWVCkfKV9osdnqJonKCVudtwZkt8fBFrdBLZnWTkowLnVVD37x4+MReqhBwPMybVW7s7JwGrEgipGh0TBmivufhtiVTcNyaC8RvsrnuiPyi8Vox8eMmPcDgSAhPVywAEqidlCCRxNPCCoQBm0zjU=
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
index 162d2d55be08e..184613538d3aa 100644
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

