Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4040F44874
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753DF6B00AE; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FC26B00AA; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333006B00B2; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9CA6B00AA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A438416053A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
X-FDA: 84642857376.21.98BD46E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D05BF4000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SrMOdejW;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKJoLhYZxKzLgCjk7k8+gdgr2mR+SAqaMIjO2eK13RY=;
	b=sFYVqm06i8RZeLIXLhdR/sfAgCtsuwRlLVUXK0lEDQslPmUSg3FldIUL4f2yR34pnvj2Wt
	7saUY8IyHGXgjKXxVpOu6lwjSXgHeCOti7oVmOafl5V8+WFlCCXL+llsNiZfJMK7omNoCq
	LzDOwo8fDcJPLwqKikEL7H5Z0mBupTU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SrMOdejW;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830847; a=rsa-sha256;
	cv=none;
	b=Y/swn72mt/9rkC4q0ZlosSbSZGaR1PYp7VXv93c3eios564ylVWVudrEe3XyDUAcBnbF/v
	/2FeXcYrHi15o1KWoAc14YQ0Un/zRFCzddq0xvjvipDEUjaTViVmUGIApQkvLaP2TRYeVx
	8UcDqKbBr7JF8oL4DKT1Iz8ptNhs+FI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E817C4458A;
	Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9C6C2BC9E;
	Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830845;
	bh=sGB3rlU6Wo00dN98XUbINMBktp7aAzb0KnYDPk0v+Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrMOdejWtVnL+yvD2N2HQfsDXNP/XXaxfJjFNfkoU6pptbD9RwZfrVa6r1mBaXO0L
	 gNohPfrPbU4RvIRh57DeB80OVMRQEmTT/Fgw8QqQbKDIrw2+vIRvEkEbpzrcanSFtr
	 7isJB0XeRROzNAfD6k/baja3hmIjuqdz1t9moNX7z22rdsOHKkAmKasktO4WSXXK2u
	 piPGY+BnUPubXbLSG5pp/to8mLsAjkpUKWgbsceHySYuPupzBU1abU6iPn0w8PACq9
	 k38tZtHrC6TTpu1b41qWNdP4oMYb9Hb0s/CO6coRqRSR19MYXWJ3006ois0k4idBIx
	 mrHc6+CGVYCTA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 04/11] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Fri, 10 Apr 2026 07:20:25 -0700
Message-ID: <20260410142034.83798-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D05BF4000A
X-Stat-Signature: rdruuydxae4ixpg7akytf4n479cx7oqa
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775830846-198288
X-HE-Meta: U2FsdGVkX1+ksUNSAWukDGDaIIZvABWLnHIBKEpElFofhm0mK6Rqm/zuUEZzawfg8XWbYHdTtlEMMT2bSgRhkce46ScAxKZSUqAwEvtfvdAo7Kowau8Z5rab8o0Aq66joS3REOD7exBnISAAItR+h4syjXmIxGw+RyXJkkMOlx349707RDBgqkZ5EY7XZ6SuuQFf6ZXBrWMNTqh9eSMNiP7diSLQ5tbVGgVc06OVyBpFVo/TwZDMTzUabXG4461DV0gAl7BhjG3MJCEI6N9qgC/mx7nzmQeiKvOfTv1KVp/bs1DKH/felhQPWEnDwn5MRLHfuCqRsHp4d61kWHywuDTvchSHYkK9J7EFwJM/nr46n/Put0H9IkG5m0xD425A6vE2cN8Z3xvlZFuvf4khi9ujWcKX9FE7U/JEGZ+446ehnP1KpK4XS8D9V/Apke9eGKrMzqN0IDCVq2wZT940+amr/jkwAo6DKH3wOUVKdypL3G/3mnCHGNyBUotzZLYtoYULf4NRZtFCukwIGWgfmGYmZUG5VgHTtA48AcusXOh+QrIIL38xl+hnk32ImTwvlnsRXdriD3qXCmirTpJGAKfxRYfAh4/BoTAt+c4E2ysKZNWEAZC/TJh1WbWwEjEf8xuqwZEBDJtrHYTTRwKI//ehmf6yhHXnBwIjsmXe04wikHO2PUL5Ahhi2Lm0u5lQktQPSQSx2+9Oxacn/6iHD7jeCntdSPTe3f8qMPBCADmFqpFeGzGglR4OfYBvi9sKsjC32fIFAb21XSJPDoVclpHqXDkM+PPgpBxC5GcwWRv10wmgqhDxyHRq7l1skVsWddLti697Z0Z8Fk9xcPVBx+LQSUHU6WGGtl4ddwcaM8T+xAah0BH2kXmrrIZK8g7XOsYXJ17kGLvPDbfkF2NlL88vpB5wLemqbl79UUU3hlUtvAG5ruaGnUg+YHuxWuVOatmCApyxZDaYPwwIkru
 ypxL+Ke1
 8tiyX6JBH1g/AqyXej0KSWobx9KrJ4x+jOdQzzLp38lepa20+fRXrEf1kzwK63foWfhZJY8LlnlVFMSycJirqupFVt3I0eo+DSVdWCEOxRGI5Ld26UC/qxONZ+E6QvKCQwN8JLvmwK+OgGIq9kh9CTU0WyAmita5qGmlUaawyC4s85QmAD3keaMjAdR7qlHu5J5hxgm0AoCPTKLIXMMYj3cQXLc6g2EBffheau4YVU3NvDbmo15+voOOnK7akyv6NnsKqperPZyaPHKsdAYT2mBTJCw==
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
index aa08a8f885fb0..edec3566bcd11 100644
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
@@ -2780,6 +2832,8 @@ static struct damos *damon_sysfs_mk_scheme(
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

