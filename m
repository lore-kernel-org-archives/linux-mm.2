Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D281C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9E66B009D; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5821A6B009F; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3381F6B00A1; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFC6B6B0098
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E82C803B8
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
X-FDA: 85028522880.11.ED9D6AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CBA38180007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cx0j7pIQ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dF7Ex+634YBMzvQotb894Kf5fDsXB/EcytIewIXnnLs=;
	b=wFgwyOtuOwHsL47zEJCz8KjB3k+fS+mvi0vLdKFklyIUObyIBY+BiwOvTKX3XIGLgWPyls
	/az87bhZyfoC3LU3qFFRaMBKD7i6S5jcvDcTVbRUaJtRg/hz8U4zxfDcxIWTWEfVX37sdr
	DCBSj3vf/KjXocZJ5zNCMh1rBvFKjZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013358;
	b=QpqwD32nA74WksLXQFWqPVd+AijH6z6+SJIxgNM7CO1jE8mPdHfKzdAMU+XY9pgWg4VcG0
	LDeyTr54vZPEbZMeBKvR6hau9J1n1dKcqdJgf1CJLIeRZbDInVEwcQb97geYggzz/bj91s
	A+2usaDssEX+FeULdF0CcqTEa96cH6A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cx0j7pIQ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A53D360A95;
	Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B641F00A3D;
	Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013358;
	bh=dF7Ex+634YBMzvQotb894Kf5fDsXB/EcytIewIXnnLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cx0j7pIQ1CGMQtYnYVEl0J+ohRFAAu+8Mb2jpW4GzqMUoR4qA2k1X1Qm0pB2Lqp4Z
	 zMUbb9SOteK3XgPqA9tjOSyvYvs5Xp0qC1xrimaFRB8dE5V30tJMKF754Sq//+hLdT
	 tyzwKp0kPndobOlYF+9NSlmlzTTlUAoLIE8eaKug7AHLIXJSQu8PyBMqu4AhDdbTXk
	 j4Aj6L3SoAbmmzCFzxtYxGeJG73fY4r/FZG7Jt8yOtxm51ef4ZRcATP9laS6OZueA3
	 jZYXTjk3lMgd57uSyI/ivs0qd1V6+WwAas6VsVevQ6PYc4fDl2Crr5/Nx2WuF+mOsL
	 bQ8ZCz7fOZGUQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/17] mm/damon/sysfs: implement probe prep directory
Date: Sat, 25 Jul 2026 14:02:15 -0700
Message-ID: <20260725210225.129944-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CBA38180007
X-Stat-Signature: 4tagace785jnfby5cezwir8t6uzsqnpk
X-Rspam-User: 
X-HE-Tag: 1785013358-664101
X-HE-Meta: U2FsdGVkX1+vZlSyMDElIjqtH96Eav4QaBrZrkgcRrrk1j/1Gp86vb+m104kSIKgbIQcSv5lNtRldLDLzltPHGxzy/v/Y/YWlQ2J8xDi7KehuHxUDgvwYAYDoVHXFlI0SNxIcgvGMRpPAAldZLWlFgd276qYS5JugFfOlSVq6eCn+NBp53zkfc2f8AgxzByv99lbRRGsjHp9cC95G0lnm0BO3vxy9N1CMotG9b+P/evJsMcNJ31eUf4st+1rer6aMaMaK9fE4Ai+OWTAr9J4IzSSREJLtFfYpuL4Rzy9UXvEW2ZPqlh5nvkM4u4Aq9nLYGsDKIPwibgLZ8Qt4Aakp6XDSKpOcFugjyG+dUYcY+PUO9p1cF9JyKsTu9xWEtCguQ8cbgKOzja8ZT5Ia+7u0AurFId7z9p26KPihMCZkDWzzmwisXjpyanEpy8eJTBWN6GkenooGM80PPl7vrkkRfnw+Ate2XqtxHiD6audTd1Z2LCdcOMGSQoAT5ZFHsN1N81xATGgx9RsqrjM+6RkBD1R+MIGoS4dmpZowBQLhTRSbay8ccLke+8nsc5WYPlk6WdLymYpbVWpq7UZSqIWiIPK2auOvTC9hVaXI/7FvA/dshHHC5pRWKVG2aXdPgItg5dnTqCQsIknzwSg3DsxAuKA8IwRnzWf0Fi5vKbQF1oBI09YCHTHT45nWIhX8/hlUkvayvKAC4UjFtWdBkV4/s1wlNQWt4HF6Ih3lJTlchNPcQsFjJ5M4sKqoRu6aIe0cnK/s0PF+mpe67D5oP2wNzL/bjR54m38DmErctsgG6HrdsZXvu0DRtE+Xd/SndE56mAXDwwj8lqBFaysK3Ir8WphhPUXI/45mXxFuFESa3oRWZyRP/2rEcJcZD63F8zyjuWHFtLdWLiqBBpffYsJOWevw8ge+mJ73196BxpNw35y2zB7vHZxPZ69LcDn4PbiJxNRaVF3sIpBEnBCk9X
 jrsXCtOB
 Kf90W05JqqQad9IRtCy9fHvJskhSmqt4SKHjcSThqzNcCaNlw+v4MI/MZDDEVRGFbLMbv5//CKCvVwi9FpE2eFPX9Kktx7K4Q1zke+yq59/CiQd2XrA7+JEEVDO4U/m2AruQp5cXW+NnHRIGWhPLyY4YduOU4y3SuoGDspT3PG+THfExhMmp7BF/oPOrCSqMiJStr4Qhad78O1SlFrFTY8Bi6jhiMmGN4HsBEhhUD0eIPHPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMON sysfs directory and files for specifying each probe prep
action.  Introduce only preparatory data structure and functions.  The
files are not really being created under the sysfs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d3ed80fb2eb1..b15ec082109b7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -750,6 +750,89 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * prep directory
+ */
+
+struct damon_sysfs_prep {
+	struct kobject kobj;
+	enum damon_prep_action action;
+};
+
+struct damon_sysfs_prep_action_name {
+	enum damon_prep_action action;
+	char *name;
+};
+
+static const struct damon_sysfs_prep_action_name
+damon_sysfs_prep_action_names[] = {
+	{
+		.action = DAMON_PREP_SET_PGIDLE,
+		.name = "set_pgidle",
+	},
+};
+
+static ssize_t prep_action_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (action_name->action == prep->action)
+			return sysfs_emit(buf, "%s\n", action_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t prep_action_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (sysfs_streq(buf, action_name->name)) {
+			prep->action = action_name->action;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
+static void damon_sysfs_prep_release(struct kobject *kobj)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+
+	kfree(prep);
+}
+
+static struct kobj_attribute damon_sysfs_prep_prep_action_attr =
+		__ATTR_RW_MODE(prep_action, 0600);
+
+static struct attribute *damon_sysfs_prep_attrs[] = {
+	&damon_sysfs_prep_prep_action_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_prep);
+
+static const struct kobj_type damon_sysfs_prep_ktype = {
+	.release = damon_sysfs_prep_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_prep_groups,
+};
+
 /*
  * preps directory
  */
-- 
2.47.3

