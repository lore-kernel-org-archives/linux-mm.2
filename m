Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7924FFF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618976B0093; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A066B0098; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FD86B0093; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 296D46B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E75CE14039A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
X-FDA: 84706244826.01.2FF6B73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 38F8720003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4qRrqkH;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLjdATH2O1ryfj2fhnHDdG79b8OhohGWApdDS+cVGYA=;
	b=UodJRBGw7HtruGbivzzjDYe42mxXRyvKtpf4XYu6vNkwyBfYolRMztrehHcKgpl7nWZh8y
	4K07aS8UBqmTaLbcZJurJj8gDjKePs2X6+1RA39IeG8VFEBjwRvWU9RWW0PHESs4xDOo5D
	OUAzJQhtBHX0AE8s76ZdzYYgEPbLEaI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4qRrqkH;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340072; a=rsa-sha256;
	cv=none;
	b=2ppTLdCd61wsB+yApi/TavI2WIOKEk/mlKU1cIkeOp8/00RxelB0W9/+wpy2Cqji6uXbFc
	xhUYabzWQ8uZRpuq/FvxZq7YxPLeBbZIfOD71GrWBTr7HP7JJtFYFwq2wyURw6IxvXjZZD
	Pvn9T2q0U9gaGp8j+KntBwIfBuV66ZU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36E314442C;
	Tue, 28 Apr 2026 01:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8600C2BCC7;
	Tue, 28 Apr 2026 01:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340071;
	bh=/lVNhShO2zb1X1uTWNv+AxJ5viNdvqRDf7CzT4VF5M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4qRrqkHf0V8geYZjNhtGXFHjdk3orzEf904/p6dcoJOm/7ZSBIk0pMo2cVUdpWge
	 n9hQCsCOKKO7mU289JAH4O6FtQYPlDT8O5+w/pUARa1YnWdB4G0dQV8OoQMqUq9W3L
	 gFqC58D9WgNwvFqDG9KtuOeQDeyMys0zV6iZcg8oEwVW4kEt1K5xXTZDgpD21WL39A
	 x6+zZ1pukmrnk1YduWej0KWig5Xsl4PQy92cjprBvepQElQqDnMiCmxu3AKvqnPjMr
	 P2uqYzSCfAf09cyZPADCraT/5ciLHB4Oi336B0OVNbTNX6TekgNmJttHQ7IVUzL3aT
	 73EeJFp6+/9Wg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/11] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Mon, 27 Apr 2026 18:33:53 -0700
Message-ID: <20260428013402.115171-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 38F8720003
X-Rspamd-Server: rspam06
X-Stat-Signature: eb6c4n99goxti8anzabpqzb1rq85byfr
X-HE-Tag: 1777340071-709062
X-HE-Meta: U2FsdGVkX1+hf1+bd3Nl3BTxdGWmfmAy2j9ckaVVpxdergXxWUTJcA7tTsBNleqc02hI612UkGGu6mW+fgJ1tRpSlecmZ25qla6gbLmtVLe56nztLe3i0BaCPtW6mUVqC41RMJa31Aydj5ljCDTokEFea9bt0czFYS5SeNIZ4NIXbajBzlaLMJzSIY3piGAYo2Ohba3BMfnt7Zz783bMq89nS+rzPcPEHAHCr1UyRSeHUXDfBPrhmduOqrB1Zj0vdXdHSzidSnSgvMhfjFWtq7fnPcFyqqGTM2QKwQocusAEzqCDkmczsjKzr2eJI05G5A7ieu5dcJKLU9rUr3MeDVg4hCB5BK9gDUQH8N+crhLVwJSyn1DJYEy6j+hsLhAAjTpoqsYvjZm0YibMCncI6dfwjqEZNCFKVtQY9uu1WofXPUxUr6+x9K6rxmHtyagZe0m6Dlxm1N0WP5HHACDPdze++qrWyPN/z47zw4qj/3wPSziPDX0RBUA9p32PtFV2rmwf5Bbda6Ud4Ulz9JkJ0W5KOgA2k41LDh8gzi7FxfkElvdekSmZiNL9eHEhWCdllZ2UZURtKA3Gk92ckjoz9cP6Iqz00liMXAuS5vENBER34EaanhbRMBSsthUbInhYJpZ6lmHW0jDbDwUhnAUwEWTQkMRwfWdtR3cgt97UdCDxSi2cQKAOxxz08pjxC0J5cTi7lnBsgnW6ZQAIAZiqjwNOd2cS77Id2oCo4HAt0RJfx6JiMuxrmnwq6oUr7hzl05BZDspJTACicJA2dHOnXnNCz91xsCfJs4c+Ax2Bb0JTf41nWohg56GzAaQGoUfuE+fdlVgjBVa1prsKOxAZQ32hD3AEioblNqQaCJAxgr1OIJbpqLeIXAQ5q3qn8mydOF2QS7daqChW9+vG9STQUSXuZKNiYQ33mlpjMdd5hkjDCeS7iqbPI3OuzCExdOuwMBgJf8Z2Syfw5uXdoiT
 V0a/4Wrm
 a2gJ+fro4UKMW+Hzv37+bbKx9UlMp3f0xt2QRcFXOJJoroIlEKlt3UGpx0eNfIff6ck7KXqZ+BtsL/yw2TEJTGPKPJWycmN02/0DLt7JZ9xA54z34xZsZzkKdY08B+JOD3HXu1Qgs7ZH+08jNYQO+BA/n21lTYOvLwtyRuM9iPdIBeDbazjb2Qhoj2mPsbVPUmN76t/+fcbrtTzjy+bmTjFs78XUxqHU9l4XbzuSojH4kGOD2XM1HkwkdBvqwA+o6qg82rTdAV/TeJ0BfioHP2C1hXQ==
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
index c14a564dd8218..c3c1ff6108863 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1509,6 +1509,8 @@ struct damon_sysfs_quotas {
 	unsigned long reset_interval_ms;
 	unsigned long effective_sz;	/* Effective size quota in bytes */
 	enum damos_quota_goal_tuner goal_tuner;
+	unsigned int fail_charge_num;
+	unsigned int fail_charge_denom;
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1683,6 +1685,48 @@ static ssize_t goal_tuner_store(struct kobject *kobj,
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
@@ -1703,12 +1747,20 @@ static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
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
@@ -2801,6 +2853,8 @@ static struct damos *damon_sysfs_mk_scheme(
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

