Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 096BBFB517F
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE1B6B0095; Mon,  6 Apr 2026 21:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE446B0098; Mon,  6 Apr 2026 21:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0639E6B0096; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE5406B0095
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93501140603
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
X-FDA: 84629967366.06.6787A0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C84BB14000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XlbS/48M";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXvdSW5zPhZVvhbBUe21YR4ZXv7EJNoiQn7cpzUUXrk=;
	b=i+gIxozAFA2xiKVUADsHWBHCqSKQBol9Pnk9eRwRi9MmnF7ibX3GPbY5Jul2oDwQNkDTDa
	3T0n+aPUCOmHrWsEoe3Rhqm+7Ro/HUlZsGpJmC/WRlB3gvF3+sB3WJ8ykh2xhdFqOTmm3c
	uo/C0v42bmsKlU5AI0tw73NeZ/SnA7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523942; a=rsa-sha256;
	cv=none;
	b=OjdO7HnV9MEhighfd4/YIq8mkp0C9dHLnBoozCMu8N3KWHI3IXbJob05mOXlPoIyEfKxL0
	WgIfBGuTbgZGzMpAhhNLzrbclq18dz47Gxx5KQZW8xs/rL9RWcnpIx1NQRPv5GgNfDmRGl
	WUO2i0FBqEJJ+VjBHsVAh/+pCRB/6FQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XlbS/48M";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3ABC445A0;
	Tue,  7 Apr 2026 01:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B023AC4AF09;
	Tue,  7 Apr 2026 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523940;
	bh=F/M9rB5L2tN6LoRT9CXC/JolkzvZc5e3+oNuxF0asr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlbS/48Mf6uB71zliEu31bKAHgwyOtoyJP5Ejkh+bI2n/vpXjLB6HGgXgfKGEDxec
	 bLzIyJDspvJ7BgjPWmxzRyELNhhqbLo+j5JpAmjJ1cP9ZK0Ig7jpagisnWGl1PWwue
	 lxEwyBhyb44d6vZHpHdH3v7DmOHDRfU383qdUz10zKv7FFV3633vKREBK+O6b5pcYY
	 MiNuxsWbaDZMb1/S8N6YckqNOiVYuVK8PclMEvUvB+/Cl+Emm1NXPpzv2GGoZS+Oqe
	 aJvd1m+RUHmTm2SUi8BOeVWJgSKN7DwqT/yDoAA/NE3UUn1hB7NPzY5k6JZIGWA/+H
	 jtEZXvT3e7THQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 03/10] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Mon,  6 Apr 2026 18:05:25 -0700
Message-ID: <20260407010536.83603-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: juo691wqmebak6y1eox413utgmqx151h
X-Rspamd-Queue-Id: C84BB14000F
X-Rspam-User: 
X-HE-Tag: 1775523941-666943
X-HE-Meta: U2FsdGVkX1+sEbsovaP4h4AXNYKe3UhfXHvNNg1fkbSOx11TrpaiqsVxnpEAAEm+0ctpr6oteAHEkLSUg4QrMq4FWeZx5oTQmlHznCpWOFere3UI8kZnEkHMbIuXAtpLzxUSkCtW2Aq9FWwZqOTo5QDpJ07Clyd4CukHFRD2n3R/Iiihh1k0rk/MPqE7YaybmiQrdEmPHalhYkvNDR5Fr7G5e3zDJ0p5f1UVxjoPytnQ9pjnWKRzpvV8wirwYrtNj1uXXTy7Umf/WHMUJPUaoYHps4DgKufVlDCCcp/vvCfa+hY2U3a3GxMDxbQEvLz2SPZNhiHNOeBJbUIxKUeFxWKalMjMauYGUHAXxRO1O+wF90HYQ8FQM+oO8Vc9cYR6R6B+D1PpsXH0YcAiqXDW/vosWKhIiCRi5yCoAjsE3uBbEGVUrRa+4TZg3T3NUlOrhAqV30dNsyYqjEoIEd8I9uq6GXd/qGAbYzt0XKKZYKQoZsOxgxa0eZjvAiITNpc4yO/PQjxguNvWb0uVrzxAVoAXqlpDDvpRyXFSP9IpjSFC5a0ckgJSOyR6ucace7/eDfu3PS+Wth5vz4wsTJWBUjFBkhV0Uv5eBIjOF0asLi+ja5dAeZOV22UHxa4pLLHo+azCnpKRN0gvwCdwMhrxkCl2mcBqbvYFR0zsPBmwHU+Duj6QY+R8UfczkaPVaCY7zFrMek0DduY5UqhHKuHf3rmW59WaTyetXysWHWHGDE0OkgOI6wrESYAT8GRR1q3HRnincitXp6EAONboU3X+CJHmHVRxDygaSOhRr26OFxG3F+sKsf1AJUzlwNrTyIJbSTILWRfseqs/aNzdXUcmc3mNpHcJAzGbxJIlysg34YSgywC3KteRfwkvwGY9MuktuOd1+G8kmyNS830bLFCzH6U2sJb1JARhS50MJNLrglX9HSfbwRroyGId89FoDeCgN6VnFpiWMg2c6D0mWcz
 HxamN7ie
 HgmmpF7dOJ8eGt+bp2ayr9Iq+gRy2rFteX7hULtSscsfzVw4CNjhbBIBAhG6iGp198XaYSSVa6ia81AOSLmZ2WCubyjzxfYlrI7K/amSxn/zXDYs1GEZaZcSz5Er0WCYcrngd0lLALAJbX9z+sZ1ishi43i2Ud0JrWO+Es6yQNrRo6OqWInoS3YdlPwweEHtqWGB97256D7R3q+8BQo2V1H9xtRkPuEr8Lfz/BOsnWgHuaEGFRmpQXgJ+rH8nHUbH+mIGCIjS5jSKmplr9syEnqfXIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the user-space ABI for the DAMOS action failed region
quota-charge ratio setup.  For this, add two new sysfs files under the
DAMON sysfs interface for DAMOS quotas.  Names of the files are
fail_charge_num and fail_charge_denom, and work for reading and setting
the numerator and denominator of the failed regions charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 54 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5186966dafb35..d5bfba79f105f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1489,6 +1489,8 @@ struct damon_sysfs_quotas {
 	unsigned long reset_interval_ms;
 	unsigned long effective_sz;	/* Effective size quota in bytes */
 	enum damos_quota_goal_tuner goal_tuner;
+	unsigned int fail_charge_num;
+	unsigned int fail_charge_denom;
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1663,6 +1665,48 @@ static ssize_t goal_tuner_store(struct kobject *kobj,
 	return -EINVAL;
 }
 
+static ssize_t fail_charge_num_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%u\n", quotas->fail_charge_num);
+}
+
+static ssize_t fail_charge_num_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int err = kstrtouint(buf, 0, &quotas->fail_charge_num);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t fail_charge_denom_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%u\n", quotas->fail_charge_denom);
+}
+
+static ssize_t fail_charge_denom_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int err = kstrtouint(buf, 0, &quotas->fail_charge_denom);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
 static void damon_sysfs_quotas_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
@@ -1683,12 +1727,20 @@ static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
 static struct kobj_attribute damon_sysfs_quotas_goal_tuner_attr =
 		__ATTR_RW_MODE(goal_tuner, 0600);
 
+static struct kobj_attribute damon_sysfs_quotas_fail_charge_num_attr =
+		__ATTR_RW_MODE(fail_charge_num, 0600);
+
+static struct kobj_attribute damon_sysfs_quotas_fail_charge_denom_attr =
+		__ATTR_RW_MODE(fail_charge_denom, 0600);
+
 static struct attribute *damon_sysfs_quotas_attrs[] = {
 	&damon_sysfs_quotas_ms_attr.attr,
 	&damon_sysfs_quotas_sz_attr.attr,
 	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
 	&damon_sysfs_quotas_effective_bytes_attr.attr,
 	&damon_sysfs_quotas_goal_tuner_attr.attr,
+	&damon_sysfs_quotas_fail_charge_num_attr.attr,
+	&damon_sysfs_quotas_fail_charge_denom_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
@@ -2776,6 +2828,8 @@ static struct damos *damon_sysfs_mk_scheme(
 		.weight_nr_accesses = sysfs_weights->nr_accesses,
 		.weight_age = sysfs_weights->age,
 		.goal_tuner = sysfs_quotas->goal_tuner,
+		.fail_charge_num = sysfs_quotas->fail_charge_num,
+		.fail_charge_denom = sysfs_quotas->fail_charge_denom,
 	};
 	struct damos_watermarks wmarks = {
 		.metric = sysfs_wmarks->metric,
-- 
2.47.3

