Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9FBE9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5725E6B009F; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3996B009E; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235F96B00A0; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFB9E6B009E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8AD8140B4E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
X-FDA: 84624844080.03.7B3DBED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E3A621C0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d1kfa/Ns";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXvdSW5zPhZVvhbBUe21YR4ZXv7EJNoiQn7cpzUUXrk=;
	b=NCgtQokitzshIHmS8P/Kf49aG2yns4p+2cb+Wu0XmwMZmOgAFq0/ijwedR6B2SOrotULvS
	ONrTv0oYzy7C28je4wsmwFFzxPUa/90XDw62gMBK1GKOv3c7C6GcGUaKjXnx1GD3WZQHZx
	sH0GQHOr20IP3gGKzxlobysQ/CMaI7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401959; a=rsa-sha256;
	cv=none;
	b=ZxJCZHPVxL7GkKx100MMUxMc+sogH3X5LzfXzo11fSwes5Hz1vHXbpDfod7h2r1fLut/ZB
	WCgLazxuO0v+Qyf51NzO2u0jPhkKUUw8ppqaVYzSBF6IROPHbRg9GA0nbYt8lUkyocrLBo
	WMKQYiXCPTsuv8sOEYPRZO33HvcrPxk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d1kfa/Ns";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B840C444E2;
	Sun,  5 Apr 2026 15:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A09C2BC9E;
	Sun,  5 Apr 2026 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401957;
	bh=F/M9rB5L2tN6LoRT9CXC/JolkzvZc5e3+oNuxF0asr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1kfa/Ns3Ym2KfHtxsUwFYe/XWcAKWvFaP2qZzlrKAW3VKX29/wE1s+1eRBZwgNAu
	 r7cAaseHUVs6+nwPzAeOI4/BCxy+R/appQYmNSr1+6Mkm9d6gNQln3L5ItT+lBuved
	 aTsRoMCNd4J4nIJ2IwyVBpUUHVacg+kSMvtE+kHAl2W/rX0wtfaJ+Ryq5DB1TL9iS2
	 ilk7bovc2OPI+8uNSw+BLPv8c10apW7jhgS3e8z4im2+WWBH9HojOFQlNK9YTPFZ4q
	 uTrcsQMNVjCjNBajSGjZZzIwiesNHE8rWl9Qw7O9AsIw9t9pmk5pUoy5lZ1kzs6ygm
	 tuKb9ssE8UYOA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/9] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Sun,  5 Apr 2026 08:12:20 -0700
Message-ID: <20260405151232.102690-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E3A621C0005
X-Stat-Signature: waie4bshjy4cbtzo7dfbzuiu9jc4yieq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775401958-170829
X-HE-Meta: U2FsdGVkX1+pPXPyIfEfh8VMuONfvW4WlYHphorIHCmnHT0PXvDgcEVjM0tbFTl7uKUeVpmv17I9JLTegawn0LQcHSpUQFHz9msZm30J5nwyK+MFsYDkBev+mEyDsFvYgFFwt2LTz1oTVnC7dps/bMwKeNpnWDzlhRPJxLNMRihccUGA0zFn/FPVEXcOuHaremYFypQ18laHY8hqtAdjT0YC/eWo3boMDiZJWqjYOt56Cy5ONvkGp+Y8chmv84VpVpN8pJwaeZMLbNUHHgXeXQQRs4zGyQErL3on3DqMK1IPZj1tsj4phUIOkpHxBWL2JzPO2h8p0CE4JzvkebCpVB6wXejziLYERJ0YKuBiuUapWp0/m8w1NaN4WxEhDEerPvTdLnfCW6IaZgA6l1UkgFjp4iOD1ufNnaaO62/ss1POW4BGhGTSHCaKLFU68lQeLPci/CbqI2Y955hz4hBe2QNKpiZzttsOIBEbmwPhpIWl9vnqYxzYbdu29KRIny3KqpXaXwySDjYQ4aKn4FnmJ80PUaOmIWfKtNT0MjlktC1OPvwwLmyM/EoUm9xkLt1rtJ6vmSUWgnq2VfcMHasd3dqecOiJwAHIXOPv03cvFBx4jpraXZIVy7SIqNl9cYWoxy4LfKtJ/MPVFcABjOFAjWhj1vIWuUG9QqTKZ5iZtHb5EFUgJJpfomc6OhpCyYhqf5UJ50mVA4f8LQQ3P+SKqJbvyB2F0HAkCqvqOIzoGCHztv9jPJQpXZJ1/kb/nk9ptmA6P0SLjqo2np9HlR4/oz1V8GSfRpXTxSLAGmsI7SyodMq0pMbiNyOSOkHRf3Yg5rgCzy0W50SsgeDR53fJ6LEYWW4eh3Pk43D//RDOn2EBOZfLdFCA7yw+SgtixkUEsPV2dUfKRF2EuFX2Ao5SswZRkNVkiy/VN0TW540BPh8q6myRDGODFmoBiLgd3Hu8IoJSiN6IOYldst41vou
 uFk9Am17
 sIISH3AoZivnv/GobPtGLNANFnrt5Yv+HqaeperzVXcEJve3BUce1ygynsEI9xwtee8JWGhtwBwhDwEIiW8Cs9UGeZ8WSxM2Y0EeYEDaPMNUYCSq8ZVinRLLRdgq90vtFefzUnkFQRJnRKfArUUl0++dIcJLSnl9loWrY+XpikPiMtPDiOjqC+No7r5cv6xYnaIsAWZ0xQKn4bU78IlXQ5P4/EDixJTBoB8VRhMBf0a31ZtXmlCHJtcFHr4UG98uOgkkXjP1fDOxlDhzpvb9eDlAg/w==
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

