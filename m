Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 063EBF3ED59
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1AE6B0095; Sat, 11 Apr 2026 12:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C406B0096; Sat, 11 Apr 2026 12:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3ED6B0098; Sat, 11 Apr 2026 12:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 200DD6B0095
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D744F13BC86
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
X-FDA: 84646860900.18.626448E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20828100007
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ao04Vg1p;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKJoLhYZxKzLgCjk7k8+gdgr2mR+SAqaMIjO2eK13RY=;
	b=fAqQmKdxlisQI/jaekOR78GnDFNe5ZmChvDp6ISQK1zobG87TOVvlAq/g1WQx1v0eBAT0w
	Iau8+LAZPUuN2RtXYT5cPdzj8GkhGQ5acLZnUFoXenXFAMflgqmDyKcoX9aU71lMAkm3md
	ZSzDJ1UsEBTxwF3lbPlFMFqWfoI+XDc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ao04Vg1p;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926169; a=rsa-sha256;
	cv=none;
	b=iIJKWS+dbSt268qsMpadY5DS4U2QnE85cnsoeqovEf0oZJ3t+X5ZlP30ef8286+Ssk2VkA
	D1QRO5k3fMMh6Hanz4ViAHJwDaAAkzKAFbIGPJFtb7L5W1PyueaA20f0KFEyewGUouyVbz
	aYDFp76W6F4qmbjDyw1m8dPKxAVBFZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A47F4451B;
	Sat, 11 Apr 2026 16:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D379CC2BC87;
	Sat, 11 Apr 2026 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926168;
	bh=sGB3rlU6Wo00dN98XUbINMBktp7aAzb0KnYDPk0v+Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ao04Vg1pC2h7ahiOQjT5272QwRmCO58ckfIBxt4p7h35inI0qqSWlB/FHLkp6VLWJ
	 HqqbbOCVpzEKB8VyRFCoEm2DLqVcD8jgSsfit3YEpuQBJKHtTQuXDIwlvCSYlvBIq3
	 V76NJZqFhdUQ+fWlO7UaXdHthlZrZldiOkFCDiQqqPygTE8d9i/OUz4rHAgG9VJlOA
	 BoGKU9Uo0cKFi+cZaNBmc8hfLqdMhgGVZOHAsuRg3oQRZDFCd3Kojn8eLWPRuvu+IO
	 qFw0Qog0Hee1XV/buZB9ov2k0KbGRvWVTSwnlE3sFyhBnjbloxwXX9yglwjaT4P32c
	 fDI1dvk1SBo7g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 04/11] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Sat, 11 Apr 2026 09:48:57 -0700
Message-ID: <20260411164908.77189-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: au89istxgcwf38ucdo99w5pcu6d4xfeo
X-Rspamd-Queue-Id: 20828100007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775926168-538212
X-HE-Meta: U2FsdGVkX1+YerINQOgLBj2U6uPL7g9fiCV3JO1YOnae5W3SZ3nYiT0WKBz/ecDcCN86Lwx7WfBQ04+CTN/v1uDWvCqv1jbRQEd7WlmgPyVXwOItmGXm8ibRkTWcFx4KrMIBZe6iViIOvGYYeuI0XzN4Khsfq2XiDC8uG+rmf/IF9IaIZDao8jA8aFAElfmiGKbhASt0xohMViI/cCIjx83byPhs3sl8EWNf2vvo23W8JNU6eGZUu0AdSYELecbSAOdfbDJfFuMGcqOJigPRdpO117U98xjj1RA4VKS6S4S5JA1q/7gDLoB6795dMJj5pZsAIvEiC7QO4jpv8IYMoD94E8Srgs2FU6dCkT4Oh24fmxGVPqkw4NRUQN/9u84BW5J46lJu38Jx4XYD3V2b7wDy1EibF7DvEVgmypCjhl3B8Gg8K816nWU2+1gDPggxCtYT6S9HW/zTEpX0a1MAGLbZ4UrsdH/xCppxmeDt6kj5lfYAwQufPuqH2mSgB7iJugWbkZuxRHVvxKeRKnFkkBw8jGnjGWATEPDKpCohMxARHeObleON7Vre0AoMagp8znGPQDCaoG67p8lUvEjytw4CIrDzJE/7cSMPae+pdC6YMAIXrwF5H7H3EDWGaQrGwG2E3rw7aOSUuQ66eayaEOd35tFQfj0WslJnp6Wk+vn5jECBQah7Eah15GoIG2uHzRjfVhLaVJ3t3+zHzrReZlkh1xaL7OKcymZpSSyU7Icswek4k1TSV2BVe/ki0Zt0iNv11yHa8X6JT5f8JIjAGv9GFuF94hXPD1hn7rlHKt4CUeLdy/+sb0/BJGMZ3IOBNAe2cCnQN3RVpO8JIRBK6nT33QwLeBoRHEad9MpU7DZRnbfmuqWZE4HO9MIyIUo4gVsVqKk4KUUwQWPSgM0GlkgTaEEGYgKEcIoAjmxOaCa0Bs4RFGYJasKOHCrWuytHxsCVpCeCuwnS9vuc3UX
 5kiN9CRo
 QMmozqMp5ocg9l1S7CI63LX43yfd0gPJfPubdbnlaVEnAkea1poO2/dd4ku/cFfJgdYp6XtKCf/NS7Wg3ac3ygvHBP8wWCTMZYiGwyjhQTESOWNqmPCAd2/0dQ8ecQba3/8/0BYOmJs1W/N8bbqD6dnNGOU1zoB16USoO8vQp4vhKP5YGBoHKwz3AwnisH3LM1fZrq9Sq+C/rcNwrBfsxdPDFuVI7sCrYcF8xdfr8zprY/jaLiHzJqAAh+CkCb0Zobsn1G8CZzVUB4RpAC535sQyETA==
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

