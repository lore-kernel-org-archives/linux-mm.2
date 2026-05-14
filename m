Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32968CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1524C6B00A3; Thu, 14 May 2026 10:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4516B00A7; Thu, 14 May 2026 10:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21606B00A6; Thu, 14 May 2026 10:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB3766B00A3
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63742120596
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:25 +0000 (UTC)
X-FDA: 84766207890.02.6FC065B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8A97C120013
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLj2LUYA;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ULDK/TnSfLd9MtX82JW3Ej1Gak5V8YvFYrL2vCQeZc=;
	b=VNRVDxPezVViGBNQRWnPRihhJxL+gQkNR1pybV2NuO5BWE7u+X02f0sIObIS43WX6f5bbH
	RMs19v5h+NlR88QFB6xrngK9poprrGTcGRjdOjWAkas5cuFNSVQ1Ck97nFPkAKp01KnCAR
	mRfey21Gg1WByKucMOVzw/UNVaeXyEM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLj2LUYA;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767763; a=rsa-sha256;
	cv=none;
	b=xqUI7fEzVza+4SWQlynC2pFs/LloO3kMz6ApUvx49pdfYbQH9luZ3OAGfXlL5+nVOyjRBn
	kD/WhkKEA/DgMF+q/dWezLye4GPG8n/Gtf689sPZfxlNgCy+mR1X2Ra0MKW2yVDsjGgwM5
	pKcVrvbmZ8+PYzo9iCyZL0PSd8ZgEco=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B46440AA4;
	Thu, 14 May 2026 14:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06093C2BCB3;
	Thu, 14 May 2026 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767762;
	bh=RwyqlL/z+o4fkUQKNxBQap95FJCMMs79UsQe2MpywvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLj2LUYAAjDv3KibVQLG942RbXXvyGZn6uI9MoeJF0w2YqJII9TqT4AwGz7XPXhtO
	 yq6nZjbIAZq71Es+6Fs9ShIbNv/FnyZXc1vIG0FdGE/dXO291Ai1nzRQjfGXAIFT6k
	 v/LvC5FB1Gon7Re33vgHUiLlq/iy6DlN+fkOkYUfJj+nCv1kKEW7+f8MfuX/UHgqZN
	 dl6gREY4gMaHjo0iCcTO3aXBsThFgIVlBBQOa01iX2IDL107v/cQaH4mTa3ecVu5Mz
	 zAvSaJKF1+v+QM6P1XUstWJnWVZqMxji2RxcSs3LPNw2HDo6OSsURNa8q8foOSJB4f
	 WIFOdjBaOt73g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 12/28] mm/damon/sysfs: implement filter dir
Date: Thu, 14 May 2026 07:08:45 -0700
Message-ID: <20260514140904.119781-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A97C120013
X-Rspam-User: 
X-Stat-Signature: 8n8ccikwpkdbzr1jckwc1e44ub14hup5
X-HE-Tag: 1778767763-399271
X-HE-Meta: U2FsdGVkX1/An+9WTFDh4OSRiY9MDJiDoI6WePplJ+cPJMEYzvuljU4C9jMc42Ux8FjCrDHCvHJHn1qbMJCAmHMt/jOuLJVLRsG/arKqxQ//kTJZmxsT7nLq8Bonvgde+tm0U+0rzIJ0fBvHqvpkmQJR+be3HlZGvEI3Pc0HYPiXdbq/e1P771huMCHrA7eSkZYvfnz7EdREoecGBREqyx0mowBsOJOXpayHJ2hRQ+WPxdHtbDH7IT7uk6olVToXMuMgmPGTZrrJBRjNTsQlibPt4uJ+ShAQJTwvDw1F7EgD9s1YD5UVEavJIlhCHE5bHREt6K3/LTcC0eXdGLYlmr4AWNH3ZRcbURN3S9bYiPDxRoHcsC6yYct/h2JdEa78XiAOxJb3yHrwdCOEQNZGhjLA6z+z3JxdY19slQypM3RvTAYg2/hSf+ArjFvuXDtDN8Fq2Ok4R8asbTwsjVRvjzTR6EiR3RU1ugEAGtxUmMTsgV/p5lj2WVA3MZtJ5R8Zxpgsc10NgEUYcnT+4tKtLvX2S/DIkT0FUHQEQBu0M9EjDzJ/3+in2u8AAF7522OwqMS12QisGjbjrpD5KmaX/g2K/6RRsbaygt5PYdRMiU0UaZeWmP+twcTs9ymFQn4eeoS9ABQWFqETtcDMCRT7bh1vhbIfcYwQ53mBPJSpBdwFJakL8uYCPyn69Wqq2roOqi7voI+3ON0/0oYDQ2lfp1IHbx/VCylw5RVolkhDJ1HkH2GZ7NLJqZat97QF+MOBPKRD3Fl/7zvGwXwyb9kHbe7U+jhepvzwsNsJqfC/+EZ5VVID7kD5ASt67jAsO+OBEOZzf0hCo7cWrjTDT+UfyVbd4z9Z5ZGvSRHsl5DcyHv3skW5W5NGGLnWKHXKXXdJ0Fdbv36PMEHGHCBGkbF6z6sXCc88HBRL8vkX5NmqRanPpro6/tdUyVPXxxgFSDn45Fl19WsXdXqb6eiiZJN
 9qka0NQv
 FpF/9dHZNU1xWoz5R5RMKRpS72WhEXohKY0lwLM3qWMmf5LSRSq8JFvj8AFEljzShoKcnqoA8wCpzUgdK3mDWyOthbJfcmB4GsWxLzEAQn9Wjlg47PBjF9LNCVC7lpI8Uo7aMRCgL3fmG3Gnju/VNYsFx3P11XN4/Lb37BBhzh0YPOdw1L+b6La62d14KwaogSLaDHL2j98P8zhCjPkINRPmHyvUOXO0ebM/XTzBd3eKzqLA=
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

