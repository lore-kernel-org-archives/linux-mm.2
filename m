Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 574D9C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63586B00EF; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50036B00F6; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7596B00F8; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 301D96B00EE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FD6D1A0344
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
X-FDA: 85163927142.26.7257791
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E134120008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhPCvOky;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qO65UFbEI2bWLHkGPNlwAeuwDLu8u+FPN4dY2StdWwY=;
	b=dUw8/y211U49vro8SBdT1opPYbtRSSKimNeVa6l5HfStPk6wIScmShtwctjuiox1SiuhoM
	66ygJ6X0lhBJoI6yYDBCb/G7cSRvEhYyPQ1K9w55mEPWEqy0qyDJXjVvqlldrVPLMASPCT
	WpN+4yc5gou+qafjQSMpCcKSXaAh7EA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhPCvOky;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237270;
	b=NPNLjzCDmAvvTKskIQo+FzIwwRaIKFpoxPww70tnDzlqIPiB3+drkg25rtL8/t1XbEyl9R
	KTypMy3WL0+kdZbdORg2wsAgGs5KybACd1lJVYiblSRDuPE4B+2dw9XlNecLn+Qnjus6zT
	tdB2FXErdSWOMWbrWPtRl0teSxYIgAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A00AD602C3;
	Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320C61F00A3F;
	Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237269;
	bh=qO65UFbEI2bWLHkGPNlwAeuwDLu8u+FPN4dY2StdWwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhPCvOkyGIre7Q+onP76+JRNY756AT4FgWxoIf8w1w0G7umlbdmNPZGlbP10XmFoj
	 q9PQFP7kp/fcpHygxKkHIvDVuNABh2ijdxK0VqU6/RZ7eE+WZTXZlkfB1AuDhH8DTu
	 gsXT2fXJ0j8PASfzixxOz9gh4AE+rR+IM9P0gdNCO6yIhqF1Unm4gE/8u/SPuCW//Q
	 fTYnzXynPDZ2Xgv4i5lpv3flsC4HTpp2rikMGju5W03pYzdmhQR2jtrdLivMJkh7iz
	 T7Yb/2om6psz4w1eirMTrozvAkCQbvNGS9bI2AegK2SA+Mh77C4hnXfii5oOJyQh4m
	 YPZU+paNf1N2g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/17] mm/damon/sysfs: create directories for nr_preps writes
Date: Mon, 31 Aug 2026 21:34:07 -0700
Message-ID: <20260901043417.2165-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: eryhtfpko71sdc15a34rj95mmddnmtx6
X-Rspamd-Queue-Id: 0E134120008
X-HE-Tag: 1788237269-35496
X-HE-Meta: U2FsdGVkX19y9vDkuesvz6MGOvbbPHrltrxM65I2Jw0x8UTNl6ssv2Y3ROnGsMTrOwJozM8TJ/xuovJNc4yCm0DYwy8ZIlaDiqhNKOLLG4sP1gxgD8OPFZIo3yxjcIS22G20YMpGuZDIN9HzZnY5AXz8F2ZZsCg4abSKSnWzXwRBW7C0erUsrGZeQcq0I0F6ViiVH1X+QBVHc3uz8ZQUCD7MdMattUf+4pv53KVE8ccuDqmHBrhQPRQrXLDxOVR+IACRdxn2/wLAJ+uyc1hpY68jyarW5TB0TV9FiUjQ/fw57LbthRNny2SwosL/N2GxXrFKr0udXZOHtutfXCFKwK/kN2CrU5vcmYsvwYQwYS0ttCxp3Fi2BcKFYgnOYZD3TuPIX0i/bUD46XW4eiuhDCO6jxGIa2TuTmJJ+o6DBj5IrZ/X4+NlP/4hVcFfFDK9gYOXSMiGUbWfowe8Iew1pK0ar4YqrZBBdm9XVWJ/SM6rCf/ZuzNWiW8Nw5Wt+VLidhWeMmkNCaT+ZoyUhnfts88XF5D+XKX0IPxAu9wwnPCev0Ixg7Iyx4ChXQkNsV/wtHBBtZLRCdxSlpxyppGv8UvvrNMbIJPQUuj9u8KupUXbCtvaAS9fYWHwFDnl7BJdHKWqPpPn12pCaEHk5u1ytOIVIA0oTZXnoNUpwtXXbPmRWIFIr0ZZBRVHSmCkZTKXqzRKYxJ2/BvuAlSxObhfF4KIy68kVExjWBpTxW4FO/Co42uJ51CzJPXHaEa466C3ndVmC+V7fbyVR7vDFXeeYRpXuaFOZAOwVcM10v4rh5bGlnI2/G7dpO5skptsUpO7hevx5QHPebrlm42v9gdTYWaDTr+pNgn2aXeY/9HFl+isOiHdM0ONOysnOzK2IkGeBYSrQi/QyCKWAoGEY8p2NBfgmRruqXtJH0HnHB4ZZe8PURuSHEpRRQzklSez9RndEbCMrnt9Se0AVYxpIPG
 XbWnjObG
 bdJ2Y+QJkb6EaY1AwsBrQ4VAqwtmex8VgNJKsQYuSeZylw01LGh6BZqt4a321iycbqne0c3vzPmh+PiG97cbwGBnE+bJ26Ys/NzYR4EaIKpuQ2rwZ+YiYjjNO6KHRXYksbYky8zkU3ysU+xnTzHnTtW/qX2heyDkPQ9jJi+v8piga9GB76ilb2YvfIgDHloB18BPChUJkkB8oA1ymEcEd7sE+BJ424tocxR0pZvDoKPhlff65kgSDbqc2Qjvus9XR260yRQja1OlphdFvjFR5+ULzLW+7ZGItdrEPJ0B47cLN4TxuOedLg5S2aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement nr_preps write action to actually create subdirectories of the
number.  Each of the directory will be evolved to represent each probe
preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1d2d9950716e1..3749abb781566 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -749,12 +749,50 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * prep directory
+ */
+
+struct damon_sysfs_prep {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
+{
+	struct damon_sysfs_prep *prep;
+
+	prep = kzalloc_obj(struct damon_sysfs_prep);
+	if (!prep)
+		return prep;
+	return prep;
+}
+
+static void damon_sysfs_prep_release(struct kobject *kobj)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+
+	kfree(prep);
+}
+
+static struct attribute *damon_sysfs_prep_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_prep);
+
+static const struct kobj_type damon_sysfs_prep_ktype = {
+	.release = damon_sysfs_prep_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_prep_groups,
+};
+
 /*
  * preps directory
  */
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	struct damon_sysfs_prep **preps_arr;
 	int nr;
 };
 
@@ -765,13 +803,53 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 
 static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
 {
+	struct damon_sysfs_prep **preps_arr = preps->preps_arr;
+	int i;
+
+	for (i = 0; i < preps->nr; i++) {
+		kobject_del(&preps_arr[i]->kobj);
+		kobject_put(&preps_arr[i]->kobj);
+	}
 	preps->nr = 0;
+	kfree(preps_arr);
+	preps->preps_arr = NULL;
 }
 
 static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
 		int nr_preps)
 {
-	preps->nr = nr_preps;
+	struct damon_sysfs_prep **preps_arr, *prep;
+	int err, i;
+
+	damon_sysfs_preps_rm_dirs(preps);
+	if (!nr_preps)
+		return 0;
+
+	preps_arr = kmalloc_objs(*preps_arr, nr_preps,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!preps_arr)
+		return -ENOMEM;
+	preps->preps_arr = preps_arr;
+
+	for (i = 0; i < nr_preps; i++) {
+		prep = damon_sysfs_prep_alloc();
+		if (!prep) {
+			damon_sysfs_preps_rm_dirs(preps);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&prep->kobj,
+				&damon_sysfs_prep_ktype, &preps->kobj, "%d",
+				i);
+		if (err) {
+			kobject_put(&prep->kobj);
+			damon_sysfs_preps_rm_dirs(preps);
+			return err;
+		}
+
+		preps_arr[i] = prep;
+		preps->nr++;
+	}
 	return 0;
 }
 
-- 
2.47.3

