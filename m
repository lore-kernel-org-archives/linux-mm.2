Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1105606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rc8WWwT5
Received: by kanga.kvack.org (Postfix)
	id 535A56B0763; Tue, 24 Nov 2026 10:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50E176B0765; Tue, 24 Nov 2026 10:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A956B0766; Tue, 24 Nov 2026 10:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 172826B0763
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 829E11A0BCB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:52 +0000 (UTC)
X-FDA: 85470415464.12.856E075
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D664FA0010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rc8WWwT5;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534611;
	b=4evQIRcZpJgoG1Wa2jLrMlnbvdp/7nannkPb+EISJv099KO5i5RqDoDffXnGTvpunGMccU
	9vpQGhVtPaG9JCx+EZJ/WVsMzlhc3AIMTQlTvBwuIBdFQzIBAV5SM/EinGupDAjHX/OUbs
	/jwtYDykT6y+PB9HC0tvBohRezgOuXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Zxj2eMwaIXgQbhu9dalRInbQK+/1v4vmTweukww8fE=;
	b=g29BV9FGVgTBphr7kykysMtPj8SZS/ab0Sz66SMdR/eqR+6b12798td4wTZ+xrQ0Jp7F17
	lQbX3bOtte3vatD0Sx0TgrenVq67cGTtBx9GwAMJKoYldrQImE7KYACXMVGzLl1y8auNAZ
	/50UUc5wyERcZ6+zZbWGoz95bqQ58MM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rc8WWwT5;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3517343CF7;
	Tue, 24 Nov 2026 15:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A78A1F000EB;
	Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534609;
	bh=/Zxj2eMwaIXgQbhu9dalRInbQK+/1v4vmTweukww8fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rc8WWwT5/u9XB1zyZGcWpMkhXSxCnSEgtTmaos7+Ro8G/XWbNTzl+E8xXnhpS4nGB
	 pvzNzn/eou0+vhvSJoQ8PhftHLzDIVS41qhB71YKV77l5D7JLSZ4Vnn7VjDrpsM1RT
	 ADm8+KIAjoQlx9CgHp1AnZC7IFEvluRWtBCGn98dVCDGwPZirg9M1JipAX/s5FrhyP
	 cI9FXbLo/kdBIKvpvaL+Ytd+dv3g5N468H7aciNUShOp11554MmSotFuDhnfHvSZu8
	 +Df1+PNb+HKSaizQGAFplOfEy18JxeorgW718NbnX3/i1BqOmMjzTWS+KDAQbQ9WHF
	 uinAvMa9GRlbA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 08/27] mm/damon/sysfs: implement report producer type and state files
Date: Tue, 24 Nov 2026 07:36:14 -0800
Message-ID: <20261124153636.91854-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D664FA0010
X-Stat-Signature: yyw155wpijpmf5x9osqtjox4kk5mp37a
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534610-264421
X-HE-Meta: U2FsdGVkX1/2nv+cvp6WjXecgm0Ac8NnaCuOxzwiTzufQ/MPMHNfpu6Asu4VL1+FZs5kdxVMatxfg1Kztz3PZxaMnBdwonu9U/7Mg5nydYYq+8qFTW3Pks0+bYMjjmoh9T+nWgXDN1PljjR80UCeu3PuLEoKKFSNPfJilWSIP3jvdBuByjBlL+07Ias4Krpt9XJVqTL1avb8C2KeiEC8Ax7fSvKWzIWE1GhNLd/DBqxHDvLfCLy+os/BO2e4IBOdNh5wV8nxEREhIUaIpTRZ2M9xhP+mQyCZvF2itm2rtOC9jWTJH2eO0qQkWyhTfUgu/yGgqqMQVinSMVnhSubrHJPnBUPWXgmUkQlOEm2YO4UvtlBVUHjvG6nGFucN4TJKOy4PxKPQ9qaKv/PQ1v28b+a835IsLEBJtM/ZCjdnJYfkxscGstr9WY9FikIH7l8Yc60UBrJ4vD9+WdcAPNsay6W3+YgQqE5lnEMhCu0Ne+4b7JcQMWrywUzKv0BEDDbBIGHvC0PdN4+Mt6Gb9n3VbVoI9VbwBdoDFf+oQmbVDDTl2y4UIuyZOPv4Od51YcCWKmOM2KLVKSCkOqXhMAzqRT6N/VfPglg0JL9ug/BeXHg1z0ZYLWD347/5mgRhHHlSLm+m4SGiVXb/5qFrYwG0axN55VL9L/1H/lAj/ZY7BJkp7UeuIJJnvcxGk70nVHwN7SD3dlLvGc9QBgA8GFj3Xy5AlhT3WeyPpT1CvEjNjQmsKd5imeTJWxomoPV5oJ+mWnZiLJpMY9sFTsyjvJCkc0prPHl+Omtad02Sk93buC7NCHQHy19feN0mjWaV/M8dZj+03SXpAK8sR8kQTxLhxiOexSxP0+teHf4FetH3mWi21Xaj9ZRzSZSa0qHcqNwf0ysvakO0ysKdtJsTEksg9mzUHPuikD/zUJcmnlfQvTRpN71sEeqwXw9gzaU5Ew0kOqb3WNAnl2I4yQhIbL7
 lxyICx0u
 VfKx1l89rzFNKjMfOm7S7Hp1tx7eIaBxHlWJzuPETCfQrtyicsbgI/BnhJmQ7E8QNiCidDdNi9qOTecA18MSZXDkrtI6zlbO4TR4BayXuPLxxxFvWiEuroe+Znreulvn8v1rEvY8O+snzeRQStnpXAgI06l7GD5NCYh5zNwLWoytG9MoX1X9xJBg8BC/Wm30bnsO0yi+x49uegbBihWZcVbTcqhPEWQE6VWtntcq/kPQ+4VMFMnJ0ZFbPO6dR2k8SwcFKMjxA36VKwhvb+oKVvpc5SEvf1oH1lEEvRY/GQ70MjU3UZSJVm2OdmcEEWEP3L1X0FInQeYJtS+jPmp4tTkIaNHRrwwJ8bnjmAmFNuY70JWeUWUK01+6fvH2icm2Mu40ZYFMGpAaCl0w47Yo8tIArqI6UdMTePCZd9a/IY8XWw4HTfNP4QQKKwK75XAjGzxlvCFYMjKkPzLZGsr+/C3Jwmq/BLkTYmy/570HxWxCGnQG+13AOZzjtj8zzaB3uknVan6SVnSmDpSaKajqb5J2zDqa8392+uOhKzVYqq8jc1qMe72XVcjPWnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement report_type and producer_state files under the report producer
directory.  The type file receives the type of the reports that the
producer will generate and submit to DAMON.  The producer_state file
enables and disables the producer.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7c6bc30c12125..7cdbe2fedf7d8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2983,6 +2983,8 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 
 struct damon_sysfs_producer {
 	struct kobject kobj;
+	enum damon_report_type report_type;
+	bool enabled;
 };
 
 static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
@@ -2990,6 +2992,77 @@ static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_producer);
 }
 
+struct damon_sysfs_report_type_name {
+	enum damon_report_type type;
+	char *name;
+};
+
+static const struct damon_sysfs_report_type_name
+damon_sysfs_report_type_names[] = {
+};
+
+static ssize_t report_type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (type_name->type == producer->report_type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t report_type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			producer->report_type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
+static ssize_t producer_state_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%s\n", producer->enabled ? "on" : "off");
+}
+
+static ssize_t producer_state_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	if (sysfs_streq(buf, "on"))
+		producer->enabled = true;
+	else if (sysfs_streq(buf, "off"))
+		producer->enabled = false;
+	else
+		return -EINVAL;
+	return count;
+}
+
 static void damon_sysfs_producer_release(struct kobject *kobj)
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
@@ -2997,7 +3070,14 @@ static void damon_sysfs_producer_release(struct kobject *kobj)
 	kfree(producer);
 }
 
+static struct kobj_attribute damon_sysfs_producer_report_type_attr =
+		__ATTR_RW_MODE(report_type, 0600);
+static struct kobj_attribute damon_sysfs_producer_producer_state_type_attr =
+		__ATTR_RW_MODE(producer_state, 0600);
+
 static struct attribute *damon_sysfs_producer_attrs[] = {
+	&damon_sysfs_producer_report_type_attr.attr,
+	&damon_sysfs_producer_producer_state_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_producer);
-- 
2.47.3

