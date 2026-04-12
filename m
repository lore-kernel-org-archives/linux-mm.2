Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37F8E937EA
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624536B0095; Sun, 12 Apr 2026 12:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AACB6B0096; Sun, 12 Apr 2026 12:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2296B0098; Sun, 12 Apr 2026 12:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC346B0096
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9C435C666
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
X-FDA: 84650415570.14.C6A3B40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03EBE20015
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+zSVCZl;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKJoLhYZxKzLgCjk7k8+gdgr2mR+SAqaMIjO2eK13RY=;
	b=04QXTn9zxXNp8n+u0AIq/ABerdLpRTvneTnsaLl0kcMd81GC6CDR7B7SLA8dIiaCWmMA7P
	ebFBOSKJU3X0ekl8moxaVl9bvClkdEkQGqLP7pZ84yYgrLQrpuskRah129qpP6VvTPM+rK
	mLf6qElLaZckeOFVpN3V9m4El7hWtWw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+zSVCZl;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010804; a=rsa-sha256;
	cv=none;
	b=DknxYVuYEVu79nYWlYmcknlC1vYPzIM+eq0rPog+AKxVwgLlKOFZzfqyPdDUuJBK6kNk3o
	/wywx2vx+GMAcmzVyCPI9fhkQ/7N+PETQdGRU6/YAlbfi+JRx6R7EmEKyTM+kpx71rback
	rugQUsFIpCK4nHD282UczVVrto20onY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 318974457D;
	Sun, 12 Apr 2026 16:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2385C19425;
	Sun, 12 Apr 2026 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010803;
	bh=sGB3rlU6Wo00dN98XUbINMBktp7aAzb0KnYDPk0v+Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+zSVCZlLReom3ZJxDoS2UT18i0y5x4+T8XOYWnWJPU8WtHC5aMsDmE9csTaM7VsF
	 A6hrTlbRzJiUrjavNolZlRgxNa7Zj2me+fxLcABRaQ5HbuN2KPwUSTa756mCcSAAxa
	 k5Wm5wDl6ErTr9sLVJK3213vlQjizxiO3m4ouYBOfZkTzpZtWT6MigJRuQbc6d+PWg
	 wWEGraxCrxTd47NbGdpLjxow1WAMmHPYIAT7rAh70kcZbvgkpQrgBtYx8ICnf3kGy/
	 4mUaxdX5zvYoonWpSC6CKwaYmIov5y83CEu3KrP7Ihqm7u0xuRNfLfxDu73ImeDqr5
	 acKXuTiSvnXtA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.2 04/11] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
Date: Sun, 12 Apr 2026 09:19:47 -0700
Message-ID: <20260412161957.82835-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03EBE20015
X-Stat-Signature: w5g6ds5h5kcothc9pk87f9u7mo3bqs6k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776010803-366417
X-HE-Meta: U2FsdGVkX1+MM3EKivX7ODM6SzeMxGMcZfEeBf43VBaahI4pCwE3RA46qRw9/OnVQBItYntnGJO5I0KiTwHNTwy4Y5hJDbbRCyaCOD+6q8v6kR2XTuEgsyByxTKMUTXViUSQpZKCThZLZk4HD/E9PNTdDRlDZBs3nE30dTGoL9ujJ2IM3JMonKFBuheO+EfEtQnN62kqZMuAZWHGdWOkWfbDirBuAjIIIJ0uo+HsAoMyiM/QcCSHFiJDdzM1zG0aCa4iHFRkapBL6zhQ8oI/TcFgpL40nAPI6+xFmRNsG2d3pddYmCQ4OGDXw80BgvjVBgBB+v6qq1bzHcAghGo7kbhBvJZrd1p0Su7krAmgdLLvyDFSqCiWF078TapVTQmXPogUBlrXI9KC3b+D+KW0H7+ghNj+vU+No/ePb5i9C3dktgze6/YobyBmXu0hIHeNK5RmNiKVbBOPjQJf3tMWzys7GEicYwz4MtZiN141T7DlO4L2y5F6gz5WKXefvfNKmG3cpL4R7LoLNV2C1E4a8fElZLokePjCV+raXwibSw9nNje3I/Kr8YwPUpWK1cc2UxJHgieGZOGpAGOJCavy03zjlcn6twORDTuFjJLdakTR+IRddQX5JVFmR/42/K70zlvX73jtg3PSCVhM/VISpo4Wzpuq70QO/lKAMLOXw4A7GQj+7JsQ1ie1Qkc7jBopYGCSU0oI73MLhyMYWl9s8XJILYVjQBfVDMfp+RrYUmKg9HaHPkG4pB2cAjY0UCfCVCQETRsWO967tSt0/WJyDtaHMmQ0fQ7O9SK2jNXnmoJAjSycimtoXNLGZoMXqEnia+F7dfFvhKTp+dA6OWvraVIzSJsqZIncjfbHgKeWA3s4S9+jrT46HueMACd6AUnrDjxTef4r6MKFFezSCO/svxB/YCF1p78+CRGvXDDBsP+Le75hQG+FtHdAx2gwD5YlUmUIYKX2DLAYWVTJQLJ
 e978l7oz
 E7KB7sTl79CNbLEoqPDJL9BAhGRpbwwNm+EQFUQEUpUIZpIXF2f7YDmxuKPPFTTvPz7RdsuUZ/iZbgODMgCSkfZcN/qDjgKD7AzklUUfFu7uH6tB++xzKxw1LioaMMaKL2zkcI/Zei8U1vsf3ebwwsqvWAzkk3skBnvHVlOyCKJprm9vkqJWzrc2PQbmrmXWWGYoVwiknwB7mH9b+BbH0GoDBwQ6b2COPQ8NUwd3JX9+bqey2jO0NOPw57KvRlPT0J/OElvOLy8yG+ZzVKulZBKEG9g==
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

