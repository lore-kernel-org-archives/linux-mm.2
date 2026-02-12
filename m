Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F4DEDF04A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E86D6B0005; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF546B0089; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD496B0092; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 367A86B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFF7ABAD55
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:30 +0000 (UTC)
X-FDA: 84434812980.27.E57480E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 37EA0140004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u6eqUhu5;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EjVozywm930em4MKEAgsMSzMzNIX/uZ/QPyyoY1w9Y=;
	b=xvez1e0sCB3G1kZdkOlb5AOLHM/9bsWLBAwzpiKA4O0yZ93VCXKy2ggaM6h/vy39+YztOh
	MixzOP9GAqmhMpxqr8yqOLAtQ/+wPLBHAGn/C9PCVji/MTcK1vjYZYueyBKk0Oc18E6AbU
	Wp4Isbj2EUM/beqLIzpZ4pfUuUOQMJY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u6eqUhu5;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877409; a=rsa-sha256;
	cv=none;
	b=AEhTwXUKxK7gden6MtjAjD1QklGyYLvlLwPnC138VmiawXyDQxILY7KGCS4iIjOp4OrXBM
	2XAe3BELq81HxIDc3sNNudGAWmU9MAYjIPHJHuqDpooOtDZDpdysq43pk71eCtmMtA0iKI
	7O4iNFxSZbuuv3RdSsa01Bj4rKGTZxM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60C3244427;
	Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9A0C19421;
	Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770877408;
	bh=K7N0OnHx6SU/UFHKtEBzt5r26kfuQxAuPfXTSNUkEbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6eqUhu5Pb1SeEwzxPLxiEKY2W2TNF/CekmBWoPuOPMTVJQU/Ec2DulNPSiDhNalC
	 SaZDYe+AaGycq3IQAAi02BeHN/A67aygGAEdTb+dmqrMpEvZ5VrvdRmbjXb8dLzojZ
	 ooVm2TG/EC/kNr7CRvf8KWwTtCWsNk/M8TWnh5zbnfG5tKti9SIBTCphFarAeJMmjm
	 2fJS45jZfbf5yO51iajk27Vdid9mbM6Qnyzeazd28GGQGySaHqYAhvc9T5JcnV6k5D
	 r/VdZISAjGoDiLFmydism5dM8IhCivD+z/ynuVDqtQFRBI6kLxGY6VernWp6Mxepv/
	 M7GvRggOFAUwA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/5] mm/damon/sysfs-schemes: implement quotas->goal_tuner file
Date: Wed, 11 Feb 2026 22:23:10 -0800
Message-ID: <20260212062314.69961-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212062314.69961-1-sj@kernel.org>
References: <20260212062314.69961-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8qkc35rjpfud3y1y49ekssunyfdj1grr
X-Rspamd-Queue-Id: 37EA0140004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770877408-230044
X-HE-Meta: U2FsdGVkX1/3NOymVALYpNb3pRQZ5Bg/346yFkvmBW5a1zhcNnZnSvksukO/wThYn7AOeHGZTzxTK7czMkeRFhUiV/thB0LptWOBo45EfFCDs4scBhzhrruGVoSqCE1AtsKnhJF5inESKMX1NWqc9l3HK6402rzQ5k1afTW8E85gZ+90xYcNHtKVHMS4Xse/PAhVtAh/SeFiublbeqY/zDgDlyGjdEQvSF71qNT9MAn9Ole2Ezx+OA0iU9+fmOJyBNmn0MHHmJtv9h0f0/nhgxx0H3kYY/j9HmjtRr70GafpRC6nGpEf4eSUrvZC+VUXgFCkCdxItQiyXzL/ORbeR0BNhNKJfcIEClOlYn0xKbaodIdoucW8+l4EXoYFxLZn79iltMxzz1YoYY1jRKkuxIow/t6ZswgiNIb7ptXLbhJaiTgKhaDse6YsmhtDeXd9S3IQ/+jznaRhP/939+QWZvzZTdj2esYqpM18Muhu/HJ7lLxykhNo5P/3WwHm7xLtjUEzzyqAg3hwLknV496NlU5KRjO/cTfMns761kAP7EraeLvrNPQoU47Rw1yiMQS1qJRShfwojZNW23j6G2cmqsz/6G591b1krDMT1tTblMEzWDXP5xJtTdeXjB5bKUHsKwUcaf3WnopXJMU9H0iLmF+tnXdXaVGcIWvQHW4juTQ3yrkCzl2CA+vSNmsSmNNvUpnK8hJAN0JILYHcpPUm+8PFDRXLJfMnPwPxgXMWnoDx0nfA7m2qjuO5QcYdkw+xnfQIjINQP4J3kvXd+lrakPlJRtFpwUKhfC4+AHl+Uqz1VJ9gM3/dEdTlJO/G5viX5kLw85fLlkcfM/nSbszCXt4cN72o+ZtAcL+6qU6vNZDl1zSh5OtrVO7fhqYhUiRvO3wYKifXm+fTR/dGAX+EolcAPvVwry1VA9PhJ+1sfpkpeHkC75eqaV3zFnB/K2VtHr9zQKDThFccjLIK81k
 07Yftsq7
 iDGVvJmsDdoupMW+hbkW0BjOMmz6voAzJu5kWzWLH6+nobIXkIJ2YrXOD3lWLr0RaVIOUEqvTBnNDzOKdaJp1BFgra7tvzuogDb8A2NDRMZfYphLOfZ+kho+V92iqxg60/I3lNz26tNFgkY3sc1DdLumza3qhFrrVn/Icl+hqP5BImvU5MvV5izYfd9IBGqpjmlJ0xJWHtKXi1RLFLc11Cg7NcCdxaA7Ozcf4HzneBqgwNjrgHektyghehVQyRJAlM9x6p8uBwugWgTRyrl688a21wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new DAMON sysfs interface file, namely goal_tuner under the DAMOS
quotas directory.  It is connected to the damos_quota->goal_tuner field.
Users can therefore select their favorite goal-based quotas tuning
algorithm by writing special keywords to the file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 58 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 2b05a64771884..b30d9139b1c23 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1492,6 +1492,7 @@ struct damon_sysfs_quotas {
 	unsigned long sz;
 	unsigned long reset_interval_ms;
 	unsigned long effective_sz;	/* Effective size quota in bytes */
+	enum damos_quota_goal_tuner goal_tuner;
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1614,6 +1615,58 @@ static ssize_t effective_bytes_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%lu\n", quotas->effective_sz);
 }
 
+struct damos_sysfs_qgoal_tuner_name {
+	enum damos_quota_goal_tuner tuner;
+	char *name;
+};
+
+static struct damos_sysfs_qgoal_tuner_name damos_sysfs_qgoal_tuner_names[] = {
+	{
+		.tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.name = "consist",
+	},
+	{
+		.tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.name = "temporal",
+	},
+};
+
+static ssize_t goal_tuner_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_qgoal_tuner_names); i++) {
+		struct damos_sysfs_qgoal_tuner_name *tuner_name;
+
+		tuner_name = &damos_sysfs_qgoal_tuner_names[i];
+		if (tuner_name->tuner == quotas->goal_tuner)
+			return sysfs_emit(buf, "%s\n", tuner_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t goal_tuner_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_qgoal_tuner_names); i++) {
+		struct damos_sysfs_qgoal_tuner_name *tuner_name;
+
+		tuner_name = &damos_sysfs_qgoal_tuner_names[i];
+		if (sysfs_streq(buf, tuner_name->name)) {
+			quotas->goal_tuner = tuner_name->tuner;
+			return count;
+		}
+	}
+	return -EINVAL;
+}
+
 static void damon_sysfs_quotas_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
@@ -1631,11 +1684,15 @@ static struct kobj_attribute damon_sysfs_quotas_reset_interval_ms_attr =
 static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
 		__ATTR_RO_MODE(effective_bytes, 0400);
 
+static struct kobj_attribute damon_sysfs_quotas_goal_tuner_attr =
+		__ATTR_RW_MODE(goal_tuner, 0600);
+
 static struct attribute *damon_sysfs_quotas_attrs[] = {
 	&damon_sysfs_quotas_ms_attr.attr,
 	&damon_sysfs_quotas_sz_attr.attr,
 	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
 	&damon_sysfs_quotas_effective_bytes_attr.attr,
+	&damon_sysfs_quotas_goal_tuner_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
@@ -2726,6 +2783,7 @@ static struct damos *damon_sysfs_mk_scheme(
 		.weight_sz = sysfs_weights->sz,
 		.weight_nr_accesses = sysfs_weights->nr_accesses,
 		.weight_age = sysfs_weights->age,
+		.goal_tuner = sysfs_quotas->goal_tuner,
 	};
 	struct damos_watermarks wmarks = {
 		.metric = sysfs_wmarks->metric,
-- 
2.47.3

