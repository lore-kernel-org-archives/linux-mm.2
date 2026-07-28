Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05BEC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E352C6B00A1; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C7F6B00A4; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB0B6B00A3; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB726B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16A9A1602CF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:58 +0000 (UTC)
X-FDA: 85036864836.04.13F8AEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8BC4E180003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xyxjh3QU;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgUZwUoU8BIl3mw05ttJnd7LdxesVWGSbPXBRiEQeMQ=;
	b=Q8+fuRDJ7AeW+E25ggdn9kSPz3DR6GyjMPg+p9XLt8Q/n/7rVVj/gXpkL6lnyosUl4OCk4
	JNo2Z6RKxzxeqE20BUq3tKMiQXQT7mXV/PDRIRHJHuETbvmp0b0i38iDVGQVgGu8UP+f1y
	lf821x8fXR81DI9ejI7nZfyqigFDFGQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xyxjh3QU;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211976;
	b=bP5Od2J7c893KIhuyaYlhj0oic6+9iIt8O+PpAgu6rsAuOEBvh+pgIA31tD5//T0wsuiqF
	n2a2OIlexINqXSoHiOLVI61ojEQ2E1mik+I2XusMD5EGzco8APo7lWrcZuRJdbvBThNMLA
	o1aSHl3bXjOD7cr7vXNwC/VljndYlOU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C33F60A77;
	Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7A21F00ADF;
	Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211975;
	bh=tgUZwUoU8BIl3mw05ttJnd7LdxesVWGSbPXBRiEQeMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xyxjh3QU3OC66tCGLcocjG4phVqYA0nwfNKDz9aUUpsJBEWSAtbfzj7kx5k3rdn1S
	 0KZ+fbObrCtBLQ3ZK7uaY/svbiTgdZnBq2Yex16T2qfe7DBJx67NNITCuYFHa/SJ+j
	 Pp4OBC+eXtuzja0t8yTDXS3m9oN864RsEcZLxt6kgIcmUCoE4//W0RNs17Cx0NO2sr
	 Ri6lcE68xV2+VlItOt9B84SPPk+K0RCr6ZWw8cpB9HBAwwcvmtp9QuQ2gl3pv0+tyJ
	 0jNXSH3bIfGxAczc4l+hniYwjgl7C5EkdcNQBUKQLEVKxuANtsQzO+SSvpLNVFkUWC
	 odZmsxxH8fo6g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 11/17] mm/damon/sysfs: create directories for nr_preps writes
Date: Mon, 27 Jul 2026 21:12:32 -0700
Message-ID: <20260728041242.187380-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8BC4E180003
X-Stat-Signature: 4xbqefdw1eaaa1tp3cutqyxrwacerheq
X-HE-Tag: 1785211976-317276
X-HE-Meta: U2FsdGVkX1+BcQqQ3rOrOrxjOrN+jPXibDbakxxr0W5KiuE/Zf5WzDHxPlstavCMlmmxTSvq3GKLgIslyW5W76dtZBHxaJA2cuDm4PVDtYLVkSceKhcLqoefQ0XdepjMC1NQpEbXLXWS+OZ8EZvkrLkNGtKJ4SF1oRDsEYxOMwEUCjfumloriSMr0wZq185xnZQNub+2Emti5TeD6jRGcbSVPwzHNfkx0RkL74V1LBuYo+4bGyn6DqRymUp4P9TRlqfcJV92P4n2aIborZdQwuHPqn714s7HkdMTwEOIeFaNuFkTD2ZVuGE/hnYIDI+X8A3bd7VddBaj+zrx1rqe3UEam5fHeG42g1wOMUQS868bTp0S+KmZTGqjEv45TtAVJmKR9x64bTor3zT+UD843qrurBjKWv5pok+T3wopoQUmOZ+FKf1ovhixx2oRD/Z2kX14nsga6jyEJ7PlM72lI2fkTrqOO6nrrQMZkw1k+12OzHwQJ0m5OELf/OEMj1bmJcivGGwCh6zS89f1bbZ9vyE1KwFxFhvZ6o6TX1XS5FYWcA7xHrQGRE/O8l0HQVYVsa5PT4tF4CN2MuVE6ImFaqHiFIVR+6anuiabqW59cKCpUbCx2vFEtdVXUIKBhZEVBAIUThTZPrdHxqD3uyD1nrdw5utvMyv4m5B+OjQwUL13AbvkXJBinYHUwrlEdRlN+EI0kZ7RNJB0FwsYT9/VGldz5OL496G+C27YXpRFnsmzOm8KDJl9iRhlKuHx+S97KEsFP0MYmGfA75hs/0F1Zc7crDsMv0z5PVDyeyohM9thvfZASXtbYep6NufyE9ocP+rJU3J3bCabgL09L9lgfLdJEkRUJG6Vjcp4Qiixe8NYpVDhk1y9XC2XqlYMbwi0ja9CmeAsr5O6PLeosK6sbfY7lvnJqinrYgcfcnAV+J3t4n/PHjt6Pv3aZBYN+P/MuIjobpr+k505f2c6Ul5
 GwhwCn+X
 pOrXt+sFyMZkHyw6i7vAzObfdADTVe1Gl7g8648F9yy7ozpfX985FNK5EJBdPXCx04qxs1OIj5PoJ06/OABQsswjsCCNBbfBaENIKwQcsUoLr4ziTHYo0RLltxRh/ei6xm70j/KXVD4PVRVwUZ3fhBCFALHT5nzLoBjscJrRKIn8beDE61kfHePFVwxxXw2JQIJpLS9bITJvNGzohDOiSAllw/JaVIBpN8inY3PiiFQjcuwIkp9nj5tuOWRKHLmU3FuHZnMh9Z3V2txSG8E89Gi33DaccBdWA/6X9gtc/RngjXJF1KbDHJW2ikg==
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
index 38affef08d0fb..afd39659d6b84 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -750,12 +750,50 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
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
 
@@ -766,13 +804,53 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 
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

