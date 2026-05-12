Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9212CCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2ADB6B00A1; Tue, 12 May 2026 10:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B047A6B00A2; Tue, 12 May 2026 10:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F11F6B00A3; Tue, 12 May 2026 10:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0D06B00A1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 528FA1404C5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:04 +0000 (UTC)
X-FDA: 84759019968.26.DCBD87F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9D27A40014
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udB7T17M;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOW0LT6+toGfbl3Yy8g9HLidMaXBdN4qVHviztm60B8=;
	b=UDxRu059mIR0tH2Hsd9YaSTGRbyQROCUDOjjiNB8TN7eZHSeFIVDKr1cfKKLHa9VzCPpdv
	im3ED25kvyYdJidxV1SUpI56ZZJ6XVVgCJopGb7hMNs3oSFLZCeGCoHgPSahpqzk7Am7d+
	+51qj1pck6jlsLljXIbkfIRalMfi6rU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udB7T17M;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596622; a=rsa-sha256;
	cv=none;
	b=MvOZ2NVXtxPwYXZt82AxzdOawm97MlTPum0Jz7Qj4H8jge9E854IkuyNF2Ip0bUXs3m6vs
	B6gUFAahc6dWthoN7oaF6JekqizTo22n+/8ww6eUpKseG3R/31TJ/7DvbNwfxfi8CepKqY
	oU4mXRfWMBp2Ql+VLofBNSFooTfDrj8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D594244A99;
	Tue, 12 May 2026 14:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE6FC2BD01;
	Tue, 12 May 2026 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596621;
	bh=1X/9elsFEwb1GaGkMj7npSZAXZWCxyW00t9PKZHBG7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udB7T17McUue+rBn6sKZSQ4RXr6c77fO3nYal8+9cDMnrXlNLerfBLGPKey1RpBj4
	 r1XTA7NmSs8cDOXDAYB1dTwetlEb+yA6SAjqvexxaFq2EQjTmEGlwJph+cNlzZrPKc
	 Eb/g+Dk+kMZVh/rU8j/RLdj1S75SoI+by2on6uC6kvrGQphytTxYGBzYMZ+sbYV6cS
	 H7IvQMpsHU6hnSH5zTt6ZamX5cinUmVl9jeNfO1zqoKvO67xKlva8iYeyO2C0w5i7U
	 nydwrOiPH6cE6wMef7qAxwKX4GjZCpOBANyi3qFyZUCJ6ACHp3x+uqfYg/FVbojnes
	 ojEbVsuP5ejhw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 11/28] mm/damon/sysfs: implement filters directory
Date: Tue, 12 May 2026 07:36:26 -0700
Message-ID: <20260512143645.113201-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9D27A40014
X-Stat-Signature: fudg9bibh4t6tqhwufaku9tqs6drrifj
X-HE-Tag: 1778596622-835214
X-HE-Meta: U2FsdGVkX1+lQ4V77IWlAj93KBOrzifOdsCLBsFxO0sOxfEiJTBPXc6q2teKE2etUByzklf5fG9TLQIIguHoj79CTVPaJTJyveJVG8eoxPDhrE6efQAOuQ4rtXDPNKR2XPN+erflRXQyRR3UcbR1YLONyODaSEdsVfMxgmFP8j3fw2xLiUozofE5t+gvPyEEkjCKVppBLVMWN6VboG3k1zkycE53I5y01GfZUbOpXAkV3cE7/gJBt09Q59gWF/Ci4eGS52Gm66Q49cbg2x2Hz0V9qXYJ49Wc2zu8nzKMDQzj6QBSXq6TWe3p4qm+PnBXP4z8KGYf4ccF7M3Yws6Z0h9U/8VwBpAllOEG9gYXrcvPZtlgcp4zReI1zpqxsOSgcT2046e/746Vtojx200KyMjF1dmfM0O8rTMqUXK6ZrWrbiDnRrkhYspFIc3KGLM5JFQFPZM6xPb5335cvmyQp7N/cB7XjtfO+OevXi8ALHZ0HkrRYe2qw5AgVo6GNAMDbQfmHWpPrFzzI+e8eEwdjWpGic8rtStz+zMvF9YE9uliemioTW6m5jCdjUAXDv9wTi5e+xzK795jK+S9m9n5Q2sCqb+xtjgtxn+M8MFqTgktAkhuK7nbL1sgPzBBZB+lA9vXVo3ua/HtBKQ4rHxbQUe6hkzIeIglpFg4gVPIyQM9IxSq2A5cm+BLuijPWx0SJibngFtkflCsvvRJHB68q9iwxRup48C6UBVeATtxBrWgidBmMFdGDqMzbD+rPLLI4Hmj2BYeikP3iHlr+sEpngFSuy9Thx6kw8ufMvqP4bmSNDLS9DvLqiznCAMBR09o+umfru5SR4KXRF7IIJnD0XB74g8p1wHLxAyprn+UNuuJKFcymCLzhh4vsIpiy83i+LcmafsxA+K9eQXHYDmQuaZmEc06AiL5lcOvvEDRS08RHd50ytvnWxTaq3qJXayVQ9SYTs57b7wwj+P0TTM
 SXA28HIa
 eArYDRe9YvA00L7mn7OOAITCt83d1i2BuPetL4jmmdI9mwIaQCvEwuVOUwL+tLbiWaywrUiqM2P9oNiCjDuoReC5jmmB35phkTs2mFPFTO/7AX0mt7+5R8YwOIMs90uck1zqRNWmY1zz41QcuEZ6YpKxzT5ecI6ayoneLp9AbGQ2b3aePiIKuCYTfkiFIEf7qbHX6+hGz8seTUVCDdkl4PPbHKcBk9ka070a+oH5YFB7JOKc=
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

