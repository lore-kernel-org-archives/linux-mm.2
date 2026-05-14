Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546E7CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F216B009D; Thu, 14 May 2026 10:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51F06B00A2; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4656B009F; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66FB06B009D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C3B61C13DD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:24 +0000 (UTC)
X-FDA: 84766207848.23.0C1FC5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FF831C0014
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sjf5pZe0;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3liSG0ipqmKK1n5gionglB6GxOeMU/B395uBwpEVKRE=;
	b=Ut2lz3RwWPIQwNJDxtNw71z+kvJeuU8gwfIKvyoezS66/OP9sCwQd1W4TkGugHREEZWOm/
	ttsbyJ8Oof3cTTdl8dyaV2ziuL3VaKLdou+iDdTBWLok4NYSJ0IlVcJKQs5v/QYWTeLX2C
	yAbuT9UOHbk6gBGIzehZrUPVqRuk8VE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sjf5pZe0;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767762; a=rsa-sha256;
	cv=none;
	b=eXQj4YmLXHNiYAiLLbqUrzp+glUPJWmz179fiIAcI4CPMl5W0WuKZbu32CYaohs3EP/dS7
	3R8Pdv9exT7WNZ1AdtsY//JF6GUgbH0EibvtpN9S4mTGS+eEb2pYQyB7oMVw6SWHe/2sbk
	J3ke6nToWwDFVmXCLp09IvDxgZCyfbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5058F445B5;
	Thu, 14 May 2026 14:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB21C2BCFA;
	Thu, 14 May 2026 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767761;
	bh=MsWu2zyYAy4V2rgxAX8KgVIMloArlsZthg7SEALRXSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sjf5pZe0cBh5aXrpjcORrXx6Zd8i8sFTWDQPNJeNj9Px/IoUTwdOzDRKar3U+wdBJ
	 14QVa7N8/vbm0uaB/PfvoMQxKgLOPhvcltWO/eftrGRi9cAp5d78xjj1UuQ8q6sJw5
	 R4+utRwuGK64K6aEaYxMnIkLbevWyeW7lGqldzFoZwgVlrgiEIXJub/XGQ4zn8t0Mc
	 4sNjlU418Q6tfjcAjPDEbzmpgmTQxvwbpyvTzl9wBefL9406dqwDLO4fwVufI4AVWZ
	 2V/XxZ8zMp19QiFp4elOPhc93T9VaR6Xvfu/m2MBCJdzPf5S9ycDTJccgItNvHoks9
	 nIIayvn7bjv8g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 09/28] mm/damon/sysfs: implement probes dir
Date: Thu, 14 May 2026 07:08:42 -0700
Message-ID: <20260514140904.119781-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n4xtnre9ue6rczy5pafbicpcpkhysure
X-Rspamd-Queue-Id: 6FF831C0014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778767762-152707
X-HE-Meta: U2FsdGVkX18XF6vSxm+mcxjfaHF9Q1FqtXnbSXbR5kO+67GVpde6V2IsSVBl2UyCGSNWXsLLxArsL0haB/Nqj6e+N7Lx/AZIZ6eAIaw1Xb92xe4dQUOR5vCuZoxedOkux4Tr9RgGBcPz+QBq+bSe3tRoXXaThZzDdlIrfTQKKb0HZ+r5mUxGU2VdIAWMbLxb7RfXWirdzsJ+6awmqFelXPOTpdqRL2f1GO+HD0FNVLSHgj88xo9G2iqMB0C527vnUdTu6+JaA7vXpeBGEzQpgLhAj3krM36TMWw6XPpd+RIUXL/F57tWlsPTleVYI8vl5nwWhJcskZoZbsIU2RVuARVBDqudXaDRAeyUFL6lMLzd/i45VGaiv7TTFjrj9UJxQXhsgLm+VzwKEggZpR+CT0Hxbf6Kz94zeUnw8lWIQugoyVh0tE0EbYwDqmscIMQnZWm/B0xk1/tPI8QoxBAf5u2EIgyIZSou3+FyFqQD4/8dBwKULS/rJRk85eVKLvA9J16tn4Ah4nhOyu764ZCuPJEAUv41ac1IVyArCdZ3oY8Su+vwAog28dGu/MFUGh0tVs0gViiBBI7G+jERveU0PDs2LUB7fTwaZv75Yfql8vG7VYU/5EWufam/Ii97nqD8TtsJnbUUlpJL4mdwR0EOXHzRYzk67WzQoIyzK/BBcBzk9Sw/J96lQqIb7Dgr9+j1eCqmdX+mIU6RL92txTRLn0ZqDjIL5snBAXmd7Yg8mk2zBlCIGpIm86PdjfEJ4v9xt4Eyrk/nB3toUOThBo/iXg8OpjkJkX/3n6BKUkcnlf0sPh9wOUa7un2jbJo3jptMV1Q3/epPTvLu0W/mXb29xKun0mBNWg1S/IcoUObAFhbKXYmDx824UJWGE8kyj5ofG/MRQhjdRQFsNBzCK8TTOo/lrL84v12tO8fuBoy0aKKKjQkyJvDs91MSNJHeA93KcoB0JHWVOiN6JxML9Jd
 rXqs42Al
 0mOQHIz2sY/AjdiqmIJSX53s4Qow4SToRF5D5Gf/UEHbliIR2oMfh2Zh33viEtKmXphopYjbam6+KDsnstfAPdT09dxtrLRJd2AL4FlvBvHLKoXrOTNfZjUG9RBYtCtHkNxbu9TeLnD5kWF/AiLeHZ4qu7IPR3ygaMSOPZ9nfDaIi9AcLURWG+1UMGpUB+XARRV1kiobj6Ovw2eb0N0I5jUQKXqPusVBhl8XZO4bNl19c9qU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory that can be used by the users to install data
probes.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d5863cc33d230..ccd19fc062f31 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,6 +747,35 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * probes directory
+ */
+
+struct damon_sysfs_probes {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_probes);
+}
+
+static void damon_sysfs_probes_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_probes, kobj));
+}
+
+static struct attribute *damon_sysfs_probes_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_probes);
+
+static const struct kobj_type damon_sysfs_probes_ktype = {
+	.release = damon_sysfs_probes_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_probes_groups,
+};
+
 /*
  * monitoring_attrs directory
  */
@@ -755,6 +784,7 @@ struct damon_sysfs_attrs {
 	struct kobject kobj;
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_probes *probes;
 };
 
 static struct damon_sysfs_attrs *damon_sysfs_attrs_alloc(void)
@@ -771,6 +801,7 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 {
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_probes *probes;
 	int err;
 
 	intervals = damon_sysfs_intervals_alloc(5000, 100000, 60000000);
@@ -799,8 +830,22 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 	if (err)
 		goto put_nr_regions_intervals_out;
 	attrs->nr_regions_range = nr_regions_range;
+
+	probes = damon_sysfs_probes_alloc();
+	if (!probes) {
+		err = -ENOMEM;
+		goto put_nr_regions_intervals_out;
+	}
+	err = kobject_init_and_add(&probes->kobj,
+			&damon_sysfs_probes_ktype, &attrs->kobj, "probes");
+	if (err)
+		goto put_probes_out;
+	attrs->probes = probes;
 	return 0;
 
+put_probes_out:
+	kobject_put(&probes->kobj);
+	attrs->probes = NULL;
 put_nr_regions_intervals_out:
 	kobject_put(&nr_regions_range->kobj);
 	attrs->nr_regions_range = NULL;
@@ -817,6 +862,7 @@ static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	kobject_put(&attrs->probes->kobj);
 }
 
 static void damon_sysfs_attrs_release(struct kobject *kobj)
-- 
2.47.3

