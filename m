Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782E7E63FE3
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EA56B0088; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A1F6B0092; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3676B0088; Sat,  4 Apr 2026 12:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA7266B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:39:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56F18BBA68
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
X-FDA: 84621435234.30.0A04353
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 924F2C0004
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bsHm6Ox+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXvdSW5zPhZVvhbBUe21YR4ZXv7EJNoiQn7cpzUUXrk=;
	b=hEPuYLs+RuTPgbctfxwhgCIntBjMgEqhCv4uSO0L0drMYKRphbITFQbI7RTHC2hxYCfTV9
	WRRdMQXTwRIk9NHwUY6zkdmkB/Z+MaJEuRU3og+ZukCtHkRNp+U7LTIaS9r+Q2278uf/wW
	J1cEW425Qznb5Z6tlwfAWiHLOQxaY1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320795; a=rsa-sha256;
	cv=none;
	b=1WLdvBSy7XFO9E5Ov5X31twdu6PITMZib8jOCY3mfWZ0qHfawqvTZq8ir1Xo65/JOOnwiH
	je29WKClcTqrYa887Sw1g9M7MZKu/vypEV5P8cNBr/gazp2KGNhKs9/8C/4E9LVRuEeL0F
	A6+XBnIZq8czRPJFM7wW8FECMOSr6yE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bsHm6Ox+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC88E44504;
	Sat,  4 Apr 2026 16:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CACC19424;
	Sat,  4 Apr 2026 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320794;
	bh=F/M9rB5L2tN6LoRT9CXC/JolkzvZc5e3+oNuxF0asr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsHm6Ox+bssIRAHtF44fTbr23jm1N8ZBo820dEmyWtDkK+0cMUyNqApalavJxXgpo
	 lFsQbP6XbDIEWIDqcDn5LVDjrjKjyJLXpEjrygVX//9m/a3JLjIBcxa7y+1LfItrxx
	 kbzF0vOWxEAGkTbEfAja98uNiEnB2mNkDaatyKjAlEsOcJ+xA9u0sKX+nJekGDtsRT
	 jzhU1CfVOocGiGoEKVer1lv9g0uW+miZFHSguzacY3thwviBsZ0S9a7VrWjfdY9qlM
	 BIFZuPh+MSMwqbvSLpcUswM5wTpEFXhmL00N5vsHn4eYn5kK5KlReu9JKkdUQ8h2VB
	 M2Y2mISVIUdIA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/9] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Sat,  4 Apr 2026 09:39:32 -0700
Message-ID: <20260404163943.89278-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 924F2C0004
X-Stat-Signature: ntq7oyk5cfr9c4soi4pmn57phiixsdoz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775320795-824687
X-HE-Meta: U2FsdGVkX199I0akzT2dCpW+++GpH8e4MdpAre9Oat1XLwtKqTGBVzNOmZiKDldPqUsJ6gTJyfyWXoICekr4jiYmTN/+0TSmwdrM6BNEcsU81dOi0ShD1TEgrOpjezun7dObJIuxtrc74Q6BVYh5yFei80s6oe+IJ8lmMCzcBKItAbNSWBnyQmwyOA2htVR7xm4keVCL15Nw+/MVVzzPi9tPt8m6WqqQ30CKr4tJjFWv1GcZOeL2ndF2wWfmB0cDiWXYzWwRdXdV3E30tD2aGFK8h/3gFC70/gt9f2I//c+j5PhRZdMVxm795ThIpzbcrJUb4xQiRGEjmEzI20xQo1Zzwx0WMpSdRSicBegdUp2G6/1iW4cujZFg/hWRs36MT4SpOvmi4y5JREoMS/eNcnNtV+E/6CesUR49SCm7kVs3+Ustsi7aygltpIPhORNEWfZeLho787eztptr5erLMNtxEPTsytjNUcQn4J/rQdqJssZTOiTBvB2SqC5VQQpnIp3Eu9DA/w5sYnMEYabt483SAUK/iohFSwwfS9UU+GUZskxmjqBFp9EycjzlOj3GJHVV+vIbp0BT0/cr/IPDCzcHxgCswa5BMx9J1JEsVNFeuusqjPTKeuQctz7JxswjQx4IVA2zcJdnDPO5+ZTj2IDZgIDS/gj5PCHpdIXYgGcxvmZbFyyrJ2J8jple6XO+pibcUqIhaK2LV0A1GDkfh74Km0jM9Dwf0kbS+r0Fmqu8rSouaP0FCf5ayt4E7GlzpXOsfko6sP+05tJmhlzm1EhOxJ/IfaZ3L10I1KqJ9rNNZYUyI2GsJ5e4CYBH3oyy/dNttfLobg/uzPudfcOUQdZUOBqyVfpZ5cBtbJK+swFvoaV/sZiIlz3R6qXtUktOwahxnxrHxLp5TTOFRjmjkkNvdkpyqFogj+Rmmira+dL9XHu75AB5ua9MPiGWKChdAEmnvWX+AlQucMT80Yg
 QuLSKoiR
 Ux31/Q87NEzs3VYfjUeQZS7hGFOEBayLlGxa5X2xrVmn5L6uhXA1EBLQSmIkLekN8T3FTAsSCdEp/gC75IXkqQaIkh3pNPk8lKoWNTLvmF47E6hNykMjLjZQvRn5bi79P37klYlriQVdEEPBMFuWNBLctsaRnatwwTrxGZLMvDJJtYdgretwqDCK+hVs6MTz1uGsRWb+BKX77WFfI6Gzg7RyL2n81hacxxUSP4PMPRwfv+DJ5wxIuRqmZfcX7JZWly47msSCosI1shIwGYNNNRMnQ+Q==
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

