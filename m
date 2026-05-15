Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3CECD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97286B009F; Thu, 14 May 2026 20:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20946B00A0; Thu, 14 May 2026 20:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10AB6B00A1; Thu, 14 May 2026 20:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD3266B009F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7714B1C197D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:54 +0000 (UTC)
X-FDA: 84767809308.11.E8E8925
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B96BA18000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cE0MkSsO;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itlNkHi0S0BsNDncWZZIv+W54p0GnivaB8ld5BnGMGE=;
	b=W/OEcp0bxL0HKkavvMjl6rBfC3mZpFagCLg6c3zg/sF+jrUhFqwzm+Lvu6mIAYVr/2Qy9+
	2RkijeToBT5JQnZyTtsVfXSzHqC2Q/f0BIr+8CTpXKCkoIgrkvFC/P+rjl2BL1296Xo/eB
	hRvg5ANQmSrBYO4a/DdKeAX8tkuUZbo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cE0MkSsO;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805892; a=rsa-sha256;
	cv=none;
	b=xkoriltXGTcqj6cyB7Q+9yiUPAX91+C3DXIhEZ6p1lVc0ouIjSroWegnvL789IcyDeGm0u
	YLl5NVFd+FFUaYV/uSIlElePvvoC19/stOvnvV0rYvuk8jXUc99lmBSYVfJ+Fj6UwH89vM
	A/WijVxJxf+H+tq76xkyQN8u0IDCzkw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E96C843A88;
	Fri, 15 May 2026 00:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9690EC2BCC6;
	Fri, 15 May 2026 00:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805891;
	bh=x+zVZsyuCxQFI5S2rBudXwEq23hlEWV/J5n5iFgOKyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE0MkSsOf4Oay144eBv+qMcYAKnn6DW/g0GQje+aq768q7hFjacIpeI2QbYQiq43F
	 Z8K0FG8tOBh1jjN678WfVdZhNBD/USZS43ckYkUVdE85qgVTJXrUxlDVccyKNYoE56
	 UVQPum4oXColJsUFxTmf/YmtGH2Tt+cRSm/51pufMXZJUfiQk8Z7BnIyRh+XDEXmre
	 kMIORhJch/mvbrl5c4qqdQl68OkQUlKOOaRwggdMCOx+Euqzjaqyl+ShSomxL1BLAJ
	 anpLVyNmE5QtPhpKMDdPM5tlGw6EJMUcY+KmZA3uhwI5poL2f4lbGtO2Vk0/0Kt9l6
	 8sPF2IIt1uFYA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 13/28] mm/damon/sysfs: implement filter dir files
Date: Thu, 14 May 2026 17:44:14 -0700
Message-ID: <20260515004433.128933-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: op8zjxytr7wj5gjgq889sm9gxb3mn8qw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B96BA18000A
X-Rspam-User: 
X-HE-Tag: 1778805892-627434
X-HE-Meta: U2FsdGVkX1/H90KO6YSRv+YMCK5nhz+1lCTcvXOqKb2ASdW5Zf9Uk0vH45AuI1+Wf2XPkFtc2XmEEPI5c1idTsrOzsNiNE7m7nmWKDx8vjloT8+85VFPPmCnKS3lStiKw6UyR2AfcQPWcEuY/3A8mh6N21w/GcjjvfYD+Cg9hkVtgGVki2TUPEvJRDUQ072f7kPIVHaRTFb+kMOml7+pKK4O3Bntj8gd2W99fbV4SM/Ch4hXn1v+VzT3Lsp576yn3I9lMtPQjen1hQvgkKVpDmS7YLMBeTHbzXAE/VTTtV7rNSzj9OV7lwLlT0M/2xigC/97FotxSsdo7h+mTWwA9GBmiiHqXvA6+Fackz8HCYH4jeCvJejO+RTQ3aqchiQrtkybo5wbK4ejEphmK7q7nASvH6u0QHKHJ1GGoRZnvwYPqtz0hDfbULADL3nOvhjyQsnukcbD5vJkSd5rXDXI9ItO3bAjMNhHY3dAa44KRWpC3por0jZDTBWcnTtGQugG/Lp1GZ0uwRSoFWsJcZn/c+B2CMmbH/kvGYfKj+4ymaOxOrL9WID/iS4W0Sl8vU7cTo2rOp2tJPonfn9jFDBhg8X38lUp4VOwAKCCow7GJMrhCsPUXMaNN62IGX/FJ/y7lQ6kbJaOqaxTPfxJNsHg2h0RXR2REwgMrYTBFeUxYIGxHpRKb1tfAtk9S8EOZx/03dH0YWBk0AYbjRL8gaAfL/hyLLnS4oj2rDufFqfgPhroeDUT5dYTkjO9GlQky/5oibRIAHYqVxbgU+X2T7LJFNwmrPd5yH7VRki8I32DKRXYvGpI48NUzi2+2e8rJ+DyD4f0XEFVcPVhXYOxOowgQjNYY03vwBBlPTTMFyeAzzeA81hBI3V30wBOj44g++2MWevzSUetBmV8QconfOyfhiryjpdayyPGi7UMXMLsvCClK2qpXJYcst4jhja7KfYrP/1euxrVAaXu/y6qS0/
 O3nKwqMg
 aCKqVt0/fOS42w4awbVWsMcjw3rgkFTLLqMDEUfAKOmvE5TXsB1WWr9DRvFvKVEE/0Gp8lm1X3Ee7v8RD4c1qSdaLxaVdX/pLczmbsz+y5vmmteUlOxrFN3VaUdd3bPZ9IjIY61cn+9aSqRhErB9YmhZ15nHO+zsLtPwaYhuulEnymKOA6V6VPyRgiltvYw7xkx7oPIlqt9fHmcyclt8N70b/Ox8LRwikQJn1X4fox92J4cU=
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
index 9f4ab28cf8734..dd520e39d3602 100644
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

