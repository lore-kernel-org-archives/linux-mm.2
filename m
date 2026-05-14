Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C26ADCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAEF16B00A2; Thu, 14 May 2026 10:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CFA6B00A4; Thu, 14 May 2026 10:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D246B00A2; Thu, 14 May 2026 10:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8826B00A1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47AB21A01BB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:25 +0000 (UTC)
X-FDA: 84766207890.14.3611168
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8CAB34000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PtrY6V/n";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPpgt8uQhwb5QEc0FW5ir3Y+kErBExDQbIaI9fUx4lk=;
	b=FQR6ieWKwWZzJ45p6iUP2b1X16TJmae29NeMqTHqJzUt/DV2Mip8Kw0USEf/rrEWwHka78
	urO98ht2qFVs/DZyVbCyhq1QVhETF5/RgTPXhVurEjHmtM3U6APm3Qxz1fk4B5MZIpm8sG
	+WpD2xoIT/J5WwLA1Qrwr/IEhmqCnbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767763; a=rsa-sha256;
	cv=none;
	b=CVODv2+FUm6dWCwvTanuLnK9Dekgc0cSdApyWcgKI57pnqo7Dl83D+q/HTM0TyGqf2po5U
	XoCrc+QuBzBdbAaqi1fSjyy5Xs1REwLcoiVT0lZUpa+Wmuu480DJSA6qVlhL0r9eJHRBhI
	o3fUraHiKrZn+RwMKxpq2e8bvlxMEXE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PtrY6V/n";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9732244444;
	Thu, 14 May 2026 14:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B8BC2BCF6;
	Thu, 14 May 2026 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767762;
	bh=xxAnM/x521/ipQQKxInfDno6KUEv3MR4zVVk+LBGBIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtrY6V/nk9nMrEMw11QgSISVE9eYaBsF2lYv5NkmWqcunA0Tif6ZrmbYPzwxoqwaF
	 yXsn+QvTIiAbSNRjoeYtxUioZRa9jrtRiX65j9Tks7vLvEGU/eGY0hCYtZat2V1RB/
	 yGZ8/9w9Po5lIjDycFGA8OHNsfojy+uT9+n8+i2SBg189AIHBt+gK6EoeSt9xaSH8O
	 iVzX9/pF+2SjoQ3zM/AntmvnijAnftp89NwbvT2zdlkiR8z0GRRApPKC6geldmTU85
	 IEU3PrQMlW9Bl9BEaNJVy+16sYzHqS/i5hv7WnxpFIkzWDC72cdiAqZSyhKMFXE635
	 p4voqvA6UjbgA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 13/28] mm/damon/sysfs: implement filter dir files
Date: Thu, 14 May 2026 07:08:46 -0700
Message-ID: <20260514140904.119781-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CAB34000F
X-Stat-Signature: jhsu4s8nyqeht4m4rgidmuf8ze437pph
X-Rspam-User: 
X-HE-Tag: 1778767763-117634
X-HE-Meta: U2FsdGVkX1+XDtZMYQ/Y2/pZ1/KHPDdidms/ae4O4npvSx14qJiu/LbpEXj8qljbkQBc+OHn+VTZ2gOSGEEEeQD8nA+rXTP3+mue/owZZvni89B93inpIeyMuy7+txfL05DpOB15qwtDLv2lzjwEMQu3WuX+VSX6c7vq8ahS2y2W5E9j/ZGLMxdej6/hBSf7gS+suzOnXyn7PMsWz39BB5bsAW1TpHCIGBZzjSwrFX/N57KHK6utUDMzRD3S8q37f+SyMlPpjs5T3Y5lTU1VqPloKY2WXXsZiDpi9NRlk6vfiF88DsUUQ842+9FWSs30n8YjrowkG2H3wWXBsljdrnNu+JbEalXaHJ9F4YUOxAhOwsV5v15+kG7JfoUZcHJoW1/ZhX+xgaj8QzgfiiuH+WfTBSJvA5fdjdpucHXLD5dyHX4j1nNCrtTbj8POykzVmeiY7b6A6ww1pMnWEEPtR/0Vw7voI5xDPOrPNuiTVt+ARhh5ei6tPa7JbMFCQyekRXwkldgBjcjQyKD5+e2B+xWTIPT4QawvdXzixgt+KXmPX7Yd35k7NJZD9aE3HUVV4i+9TLc4yV4d3Of0jaU3ZpfKVdwtgIWcJCzRbZkNfv0Y4LIB82jbszTtD/h3ry1H5TZPvXvYyv0jtLkEjzaSSloQiguSODkyt2zVNpV89ngMISzymEE7Y2vyY+YuFj3qXAGj2dSzLXTSuHkCew4j8WFuOM325VAuDyS3TkgK95Fr6QtY/rYpmIlY/s2MtnusF9w+p05kvuHxEZNJihTsdPb26SqKypn8USfFqxWvUwcnpDzzQpTqIAwKWUeAtH+LKfhTaCeJ7bgekQILih8w2pFLvXMg3WHpQrZQmPuN1M55+lMRIaf6dln0HeQPEdlY0wVM+lpmRJEhAHTJETI6dxCFlueAyzyEsqlmc3YNjLTFXWtgs8eh8YLjk1Z+vp1ooIeRPxpbvdVE/Ml4Mk/
 rbN8g+gE
 D+N/LDg0NuKCpVrrRzqo908kruwzOaIQGfMx1MsANnw+ePsSHLiIN/VyZNPDYnq9rtUUKKai++PefyQKShPTn8Pzi6M4TktZ+VreQLZM00Is2VETVBYgv7YAcUsq55bsd+Jh2I5lzBD+aleWvRlYpceoPakJUX/gq2gzU47fl29jQampG6WZAP/qEan/C2NvHeGhpMIl7pfPciY7ve2zC5HkA/dSbJcCL7b1umjQWLbJiuWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs files under the data probe filter directory for letting
users to configure each filter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 25487a0268cbe..ed7bb734a236b 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -753,6 +753,9 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_filter {
 	struct kobject kobj;
+	enum damon_filter_type type;
+	bool matching;
+	bool allow;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -760,6 +763,105 @@ static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_filter);
 }
 
+struct damon_sysfs_filter_type_name {
+	enum damon_filter_type type;
+	char *name;
+};
+
+static const struct damon_sysfs_filter_type_name
+damon_sysfs_filter_type_names[] = {
+	{
+		.type = DAMON_FILTER_TYPE_ANON,
+		.name = "anon",
+	},
+};
+
+static ssize_t type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_filter_type_names); i++) {
+		const struct damon_sysfs_filter_type_name *type_name;
+
+		type_name = &damon_sysfs_filter_type_names[i];
+		if (type_name->type == filter->type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_filter_type_names); i++) {
+		const struct damon_sysfs_filter_type_name *type_name;
+
+		type_name = &damon_sysfs_filter_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			filter->type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
+static ssize_t matching_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->matching ? 'Y' : 'N');
+}
+
+static ssize_t matching_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	bool matching;
+	int err = kstrtobool(buf, &matching);
+
+	if (err)
+		return err;
+
+	filter->matching = matching;
+	return count;
+}
+
+static ssize_t allow_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->allow ? 'Y' : 'N');
+}
+
+static ssize_t allow_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	bool allow;
+	int err = kstrtobool(buf, &allow);
+
+	if (err)
+		return err;
+
+	filter->allow = allow;
+	return count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
@@ -768,7 +870,19 @@ static void damon_sysfs_filter_release(struct kobject *kobj)
 	kfree(filter);
 }
 
+static struct kobj_attribute damon_sysfs_filter_type_attr =
+		__ATTR_RW_MODE(type, 0600);
+
+static struct kobj_attribute damon_sysfs_filter_matching_attr =
+		__ATTR_RW_MODE(matching, 0600);
+
+static struct kobj_attribute damon_sysfs_filter_allow_attr =
+		__ATTR_RW_MODE(allow, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
+	&damon_sysfs_filter_type_attr.attr,
+	&damon_sysfs_filter_matching_attr.attr,
+	&damon_sysfs_filter_allow_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

