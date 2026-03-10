Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2AF4FCC9A5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D007A6B0005; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE54C6B0093; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960BC6B0098; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1B36B0096
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CCA08B5C3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:42 +0000 (UTC)
X-FDA: 84528360924.24.EFE1E97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92276A000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S5bB3l/0";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8ka91Kp5vF8fgwhMUGB7eZQNZvw5YwTf06xR9t/g+I=;
	b=ld/6XdfdD9UirV2wrgvEhgyxb1TpaIm/V3/yJBaV0+pGP2KQpoHDt6m+CM5/3ZlxL/8eOF
	j1k4dpNGT1Q8K7gT/M7mUC3DjJadfgnaAayma6UHuwvSOEsx0Bv72+wxbjASQEPxsaUFZZ
	uTHI/uFykFarC2QS1xbFG2h7wf9Ty7k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S5bB3l/0";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104740; a=rsa-sha256;
	cv=none;
	b=7E8a5u6hBSCnTZXGhsLj/SVsFXvLLAlvoKJqKNoUlpjDgN1HrAzkXx3+0UQapQsveZV7w2
	fWYMBNVS8joTT6WHmbJZvueybg/4jOob8AIAfIuwZMOovFMAcPMs5kcmrbr23o8fXrmppQ
	rAezxGx81EWdyTsIaVt7mhc8L7/Ftro=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD7E86011F;
	Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77363C2BC9E;
	Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104739;
	bh=Cz0dujDOIX0D2wsuyXTUh/TXx2EbdEyN7109tlsNnZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5bB3l/0m9unxgS+qkS3UArseKP+wJiPVsVgupZfgOXPIWS3SRaTfVl9OfC9cNRd9
	 xrbuMZ43D8y28CXYotQMm7UEFYOeKknNxMDlcRfmRD2a1+U0tV3YCoIatMxuPvWSfZ
	 +Iyl1X696Tp2nHJKrekAyoVU22CWvKLjBt4ymYZqhGtMBOUkPMTLOGywU1dqimhLMZ
	 vJb5ZvaoAUlBdYk/r5UEgE8s6njfCjk42hAYFOZ7Hcoj/JQL1HB8X4P3VvxHbt1g11
	 lnHcC5vg4w4PABYPOsDO3U5fUn/Djl4KlJcOdPzQsmIvVfI3I8n/D9koGvnFG4jYnU
	 FFYvUkTMcI3GQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/11] mm/damon/sysfs-schemes: implement quotas->goal_tuner file
Date: Mon,  9 Mar 2026 18:05:20 -0700
Message-ID: <20260310010529.91162-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92276A000D
X-Stat-Signature: gnfgy7fmo35b5iy8hm4pkrg1e3k9egtf
X-Rspam-User: 
X-HE-Tag: 1773104740-997804
X-HE-Meta: U2FsdGVkX19diPvyxosYch8fzUtA6ALIPaBRBzStY36QNQC58dmwjB+wP/3IIuH2JDbabii2fhHfIIyJ58kp5hz/o+JgeCaza8HE2ps01ZfKUaTJoxpkal5FYmWlraHmoVDPiihHQr5P+kvdav+aIUP2dtcQI6iigI7B9vJRnhwxNZImNUyUC9CQX9Vx+xVBjsFA3p8Q7PAzBKpK/fthz78EtlGWoHgZelDBueJPYN63YwHeX8FsKPY3Yevg2+ekE0vls3h1uv98/XGeHg4s5keO0tTWU/d1tqyMGsxY0t7SRukgXauEbVMrKeXyoQ2w2XHwXKgxUor1h2sGWNhGn+y2FUOUEq7wg+TaDE/aQfiweoljHbYs+dgjLv/A4bgNAPjydt31HQ6U8k1NtLE6MPpvOlDUpg7wTdqq8+rtdJQCReMrCDbj501pRL+diWsNh4zfO3J+QpKx1d7Tm6XofwXcaR7RVTNEQtula8IYQW9XtMyWzP+lG1HlhctwHjFnzPAOtzXNoO4eF/P8ZoCGXQAX7Ox8O89IO3yS70X1PvqLsdJpSG5V+a4WgFV3Rr1AXjlTJ28fmUmH4z2i57KQqv/VmhIZJLYGM/FRF90vVnWTPrN5s61DT826qNKxerX4UH8XKIes3kOV5jdGv1KBKh6jdEfcQ3pjDvK+4M4Mv5GtyT9BegT59DamT32PjlsHbY7CfKcgCURPUf+NpbwGCqe9+LVLU7DTfiIwfE8znGydNRr3YdPk1U+amnLsaPYZREEdjzPz9dKGyCobRDPuRJQuZds5U3TT9sgmsOQ5Oy7nCDvPANrMrr2YsVhj4aQWkW3T7d924UEqQm/FRXbbnM/CMRiG2jECTyQzyycI/2W2dUxnvDKebLwb3xCsNiQFi5li3fcMRYKSn32L/T9B1UZNqWWOyvo1L9J//jpzJA3AKLgrjaOvmyNMr3ncS3ieGSOAJVkiTNVIkS+2f9l
 etb8VWC1
 ngCv1lah28sskJHfGFzd0DyHWQIChoq1NWf6n4JraH2gtDC9oT/4XzmiTQXcoYZbnILuWw88pCbnHORt5NRGdbGeTHQ5r+v4Ud2nT7VPERHh/TjsLm5BE83lX1cxowrw9IVabHgVDH1MraXWEajVG94Juj6RuFs7udD2fyDnfoBGnIDRgY9iAS9AYmM04+kW/+cgpuNx6gU1Yn/jL52iWK96uLJg7snM0uFrdp80pHOKNkmzbuU013BkURVlS8g3xok4mnFQaBidrhWlBELvn3V6raA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new DAMON sysfs interface file, namely 'goal_tuner' under the
DAMOS quotas directory.  It is connected to the damos_quota->goal_tuner
field.  Users can therefore select their favorite goal-based quotas
tuning algorithm by writing the name of the tuner to the file.  Reading
the file returns the name of the currently selected tuner.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 58 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3a0782e576fab..5186966dafb35 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1488,6 +1488,7 @@ struct damon_sysfs_quotas {
 	unsigned long sz;
 	unsigned long reset_interval_ms;
 	unsigned long effective_sz;	/* Effective size quota in bytes */
+	enum damos_quota_goal_tuner goal_tuner;
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1610,6 +1611,58 @@ static ssize_t effective_bytes_show(struct kobject *kobj,
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
@@ -1627,11 +1680,15 @@ static struct kobj_attribute damon_sysfs_quotas_reset_interval_ms_attr =
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
@@ -2718,6 +2775,7 @@ static struct damos *damon_sysfs_mk_scheme(
 		.weight_sz = sysfs_weights->sz,
 		.weight_nr_accesses = sysfs_weights->nr_accesses,
 		.weight_age = sysfs_weights->age,
+		.goal_tuner = sysfs_quotas->goal_tuner,
 	};
 	struct damos_watermarks wmarks = {
 		.metric = sysfs_wmarks->metric,
-- 
2.47.3

