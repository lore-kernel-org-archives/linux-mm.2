Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD7AD3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87C16B0022; Mon,  8 Dec 2025 01:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C264D6B0012; Mon,  8 Dec 2025 01:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25556B0012; Mon,  8 Dec 2025 01:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6396B0012
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55E47C09E5
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:04 +0000 (UTC)
X-FDA: 84195328728.05.97B5CCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 92C218000B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WrME62N/";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175402; a=rsa-sha256;
	cv=none;
	b=gbhNCHtZcdU04UNng97wjIBfSxnY/2hLzezBuxq/2lf14eA1cy4O3XB4sn3Ttfjn6dJ87M
	3zyRRhcyXunv3QdRC7AnhiR49Pg/X/yJAEM5IxsBiS47h8bqQl99hXfSpfjKnzHyas64WX
	pZilnlgivIgv+DjFhiPFYOy16HdJYEo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJXgNK1U9tPN1bCsTCOCygoqbt0/ZSMFxmSlOTmL4Lg=;
	b=0AIY9XYPsS7vhws6ctB5/Aw2Lyol4u1E1aWq6HBbBq+PlIzF1BauL7osD8wVKqo+sD3Is+
	cKDj2KlC4gogevie9ok25R4xj0S4njojt2/DHx1CH/ISewU11lAd6lbMEEFFChbLO7+Jm0
	uVZPKkatPMcq05S8LnzoTtMzbnCVZi8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WrME62N/";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F48C444AB;
	Mon,  8 Dec 2025 06:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEA4C4CEF1;
	Mon,  8 Dec 2025 06:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175402;
	bh=yNKU0Z4igXUk3W3EuJXr4KHd7edg/Rmbwvdbsef5Gq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrME62N/PIHC0ErSD9JgYLo9mp27uJj3fEFSvF32aAnvVB0Mc9jn/hxaAvgLXa3Zy
	 HKLkMxqoIIIYF2fMInXLwCbzYMSF4F6isxZ5pkA+LWtHcntMpjy72AiBnmrtm3Fzsd
	 Jl5Jxw6g3zU66UjAL+5M3P1ftZ0GstG2jEsL57AfRFuqmF49XAHTpKOKxmkjH865zp
	 39h3e/whDgUHJzw+ZhkCLPumPQv/WsrDdeAFrubui+vA69poFTnVqTMYpFmzMoRZeK
	 3xsr3NSLbACB/5uT0gEFuTjM1TxMdzEaXwg3H7qAWiuBrdhShHMvUyRvp6QSTAirD/
	 DJs0J+I5eOpjQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 09/37] mm/damon/sysfs: implement sample/primitives/ dir
Date: Sun,  7 Dec 2025 22:29:13 -0800
Message-ID: <20251208062943.68824-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92C218000B
X-Stat-Signature: 5jfbn6tginicu63htpwht7y48z11o1rx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765175402-774824
X-HE-Meta: U2FsdGVkX19ZKv6o2BN53QFX8afyjPA0c+zzAKIL4mrPaViK8xVEOoEAlFpKGOE2rOlZHgjEccwx4DPnTnzq3txpOT2QsY6k6zAvE1kWgivHG0QWm2vNL6NErQMqc4GSKIRxYB8a7TpNQoQ6jyeIh2MOWim0h+NhuEppbX59+ZVO9Qq6Gu+PzabZnpdB2FRUDGzWQeOaZmSct4jUKYHme6rheQF382smSPQZ2QAd9JIpOdzWylOWnUA9GDq/yTpVFTBtBhKLxYUFr1MIPj35szcH2fCBbXwWZN9n2U2t/kRNwJPN2Hkjl+uCGkbSh91N4oVoOQYnCtSCF6dEtdBYkaQoaVbOkUyjGnRQTMC37k4ccvZ1Ve+l+DdXu/EXTUThgFcw3JL8CIHU3PbbenahIBvNsTt5YONxdl/3C3CdJiEwg97I9vQVCogB/59M5xIeOOtuVV1lw+9gwfxn6KZPfPlUK52i6RybAVZYS/K7m4xg8y9jZTfZKI0O6AavFehoaMh6v0Hr6P6qwFahuy1NRO1khCPVzwrcFYZNL3AiJtpHGxk864z/hsbRP1LnFSkpJq7cW72yjFeP4R5tXCSF3I80PVAy+dvZ+ENRFLmLXsYaWByH+4RBxozyFD8rlkT7w4B4jUcgDiBcg8ZK+F7/NtTW+zZMFqle20Rxuqtr0NX80qpVUHbvayUuL2koYbXNT/+M665/FY9yFfsWAqtBw2r6UTKNtrVBXBVH2PBsGQYWYR05SvHeH7DIRcmS8VSZUqbY9TmT02zn2pp61PpZxQAOSta8kHXa1nJhFy/wUTrmB71Sz/cXwBY7LDy1AE/UOH7SrXqaF3JJkH8WpTHqZXI9QKZ/nBjLHTvPLYu4JPObfC894th1KuJukqG8wxk5hzQebo9PVNCy49ebJDeW7Gnl3aoxOKUt00A1vQl2SIT2OGPhG7H/Hwd2mGcID8BH9AOGLNEQ3lck8GlYR8K
 tXi+3S3+
 8BMVe58wIywurBAZe2ybwbHJ0RsZ/6Vfm3Z2NkjAts1GgbMin9BcQOLp+5ISJgF/2axAV3qRHkDIDg0ZXWj0JiwHE6DvjoSXKBcBb4m0v+psyfH4tbjAAeZJPO+HkoWP8+Fua+5IgkiB1LirUC3I97z8ooJyekJwe3MgvFsHg8QU+6h9fj9mrdomRZ0Iqz4tKCEaV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sysfs directory that will be used to let DAMON ABI users control
what access sampling primitives to use, among page table Accessed bit,
and page fault events.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 132 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 851e8c0dc989..14478fd79953 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -749,12 +749,111 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * access check primitives directory
+ */
+
+struct damon_sysfs_primitives {
+	struct kobject kobj;
+	bool page_table;
+	bool page_fault;
+};
+
+static struct damon_sysfs_primitives *damon_sysfs_primitives_alloc(
+		bool page_table, bool page_fault)
+{
+	struct damon_sysfs_primitives *primitives = kmalloc(
+			sizeof(*primitives), GFP_KERNEL);
+
+	if (!primitives)
+		return NULL;
+
+	primitives->kobj = (struct kobject){};
+	primitives->page_table = page_table;
+	primitives->page_fault = page_fault;
+	return primitives;
+}
+
+static ssize_t page_table_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_primitives *primitives = container_of(kobj,
+			struct damon_sysfs_primitives, kobj);
+
+	return sysfs_emit(buf, "%c\n", primitives->page_table ? 'Y' : 'N');
+}
+
+static ssize_t page_table_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_primitives *primitives = container_of(kobj,
+			struct damon_sysfs_primitives, kobj);
+	bool enable;
+	int err = kstrtobool(buf, &enable);
+
+	if (err)
+		return err;
+	primitives->page_table = enable;
+	return count;
+}
+
+static ssize_t page_fault_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_primitives *primitives = container_of(kobj,
+			struct damon_sysfs_primitives, kobj);
+
+	return sysfs_emit(buf, "%c\n", primitives->page_fault ? 'Y' : 'N');
+}
+
+static ssize_t page_fault_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_primitives *primitives = container_of(kobj,
+			struct damon_sysfs_primitives, kobj);
+	bool enable;
+	int err = kstrtobool(buf, &enable);
+
+	if (err)
+		return err;
+	primitives->page_fault = enable;
+	return count;
+}
+
+static void damon_sysfs_primitives_release(struct kobject *kobj)
+{
+	struct damon_sysfs_primitives *primitives = container_of(kobj,
+			struct damon_sysfs_primitives, kobj);
+
+	kfree(primitives);
+}
+
+static struct kobj_attribute damon_sysfs_primitives_page_table_attr =
+		__ATTR_RW_MODE(page_table, 0600);
+
+static struct kobj_attribute damon_sysfs_primitives_page_fault_attr =
+		__ATTR_RW_MODE(page_fault, 0600);
+
+static struct attribute *damon_sysfs_primitives_attrs[] = {
+	&damon_sysfs_primitives_page_table_attr.attr,
+	&damon_sysfs_primitives_page_fault_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_primitives);
+
+static const struct kobj_type damon_sysfs_primitives_ktype = {
+	.release = damon_sysfs_primitives_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_primitives_groups,
+};
+
 /*
  * sample directory
  */
 
 struct damon_sysfs_sample {
 	struct kobject kobj;
+	struct damon_sysfs_primitives *primitives;
 };
 
 static struct damon_sysfs_sample *damon_sysfs_sample_alloc(void)
@@ -768,6 +867,35 @@ static struct damon_sysfs_sample *damon_sysfs_sample_alloc(void)
 	return sample;
 }
 
+static int damon_sysfs_sample_add_dirs(
+		struct damon_sysfs_sample *sample)
+{
+	struct damon_sysfs_primitives *primitives;
+	int err;
+
+	primitives = damon_sysfs_primitives_alloc(true, false);
+	if (!primitives)
+		return -ENOMEM;
+	err = kobject_init_and_add(&primitives->kobj,
+			&damon_sysfs_primitives_ktype, &sample->kobj,
+			"primitives");
+	if (err)
+		goto put_primitives_out;
+	sample->primitives = primitives;
+
+put_primitives_out:
+	kobject_put(&primitives->kobj);
+	sample->primitives = NULL;
+	return err;
+}
+
+static void damon_sysfs_sample_rm_dirs(
+		struct damon_sysfs_sample *sample)
+{
+	if (sample->primitives)
+		kobject_put(&sample->primitives->kobj);
+}
+
 static void damon_sysfs_sample_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_sample, kobj));
@@ -847,6 +975,9 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 	err = kobject_init_and_add(&sample->kobj,
 			&damon_sysfs_sample_ktype, &attrs->kobj,
 			"sample");
+	if (err)
+		goto put_sample_out;
+	err = damon_sysfs_sample_add_dirs(sample);
 	if (err)
 		goto put_sample_out;
 	attrs->sample = sample;
@@ -869,6 +1000,7 @@ static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	damon_sysfs_sample_rm_dirs(attrs->sample);
 	kobject_put(&attrs->sample->kobj);
 }
 
-- 
2.47.3

