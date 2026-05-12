Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F9CCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3F96B0099; Tue, 12 May 2026 10:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584D36B009E; Tue, 12 May 2026 10:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4260B6B00A2; Tue, 12 May 2026 10:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25D066B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA3211C036A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:03 +0000 (UTC)
X-FDA: 84759019926.28.5994EFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0CD96A000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6WNwwQv;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3liSG0ipqmKK1n5gionglB6GxOeMU/B395uBwpEVKRE=;
	b=F8/X7LW9PC3trFNzNWq5SQMhmqr4mFzCpNt/qRZYenAe0HnZcoh27CE/wL+/BizyIgzG1z
	xOSdw79VPFyFirUMXOHlEYMBzL2mAmVRsBBrug3YUIfGdYTcmNt6VQ9cRxoDEKo5+vGKaL
	Q9e4NBTwJd+P0/kXaE6K90yLWisOyaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596622; a=rsa-sha256;
	cv=none;
	b=YynP0KyA+OOjBHOzsOg9mCkxLPhMGQkgGfYq/wvrSmwyviSJsWT/JWUTAp2cObKt2z5Sdh
	AIc3fJWN3tU9VvDhVLdey+NvchJUBWzLhEGr9nYOHy5ECQJymrEDclUZ9tEuE76ByC/hMb
	+kUlHzs4IJyCA0v1XJngyr8pRLQYC80=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6WNwwQv;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D72D44A96;
	Tue, 12 May 2026 14:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8147C2BCF7;
	Tue, 12 May 2026 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596621;
	bh=MsWu2zyYAy4V2rgxAX8KgVIMloArlsZthg7SEALRXSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6WNwwQvGd4KqutwoIYQ2sBnmm/3oYmk78Mtm6HYhHckxSakRl4ARm0b7uwRfd/Ko
	 v8Uv67OlLLlrEflPV7ZJiJ1MV/BofNocP6xoPRfR/xmHvzc+Pb2WKh9cDJZdqPUVeJ
	 SusGM1c1eAfrXbLfEuhrqUCBwDYI02hqlbrgipo3Rwp1MNoQUEfwZjY2xuTJsqBGm3
	 uuL5uJ2iruOrcbPQkz4WT5mikUeF2dg4jVkBQpcegkKtrBuw3SYsK1rM4f/HUG153h
	 n/E7SG/EFG1trclw1lyF+JBTwXNLIo1fNV2IpFJwo5t0k6siz97SValGPt9HPLE4gs
	 +McRVtnOb/Xjw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 09/28] mm/damon/sysfs: implement probes dir
Date: Tue, 12 May 2026 07:36:24 -0700
Message-ID: <20260512143645.113201-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0CD96A000F
X-Stat-Signature: e4ja56zq5y4yaewh7yq4txrxtswzp1wk
X-Rspam-User: 
X-HE-Tag: 1778596621-439629
X-HE-Meta: U2FsdGVkX19cZkIRhsqmAbRalcraZOxIWifAQDa/tutAmz1lGdKxXNR57Vk16FbBpyaW2pnevgv8NC4JxqELOKtOw4ciEFPBoUlni68sV9w20OeiS/zzAj7Ndc2LUwMM/myN9KQvVoDYmoWx4931blDVL+J02pChyXLl8FgIJu0ytCqWyrbkxlGgE/oiFNxaKCvIgppVWFsVFbMBDqCKTQwQPhBMybIk+SYo4pKr5Zt54q34P+Ht6hG9etSYIX/21dYPvOq68QAb+mcF3uhAIbemcETD66l5T8BtAEByXmipZy7amzLqtfRAd0peBc+GB5SbBMA5OqaP1hFGC8N/BeEPYv0/wpqfFdK5iCU0+SWAQV42IbIdCblQV+GtRPwjE/i5IZFRNDuutqKMFUt1Hwne9M8nQ2KQaIZN+mJD2HxSqxKCw/VLNEzEkGgx5rczNUtvJ3OZ/Ag7Y0MGS2qGRYvllvIxnchzUT0jEsi11Yla4KJ83QAij6SRCNjjS6KUM/v+K2OEVBzin9Og0MZK7vondSJKLd3LLRpKOWigTbzVl5dc+XB32TlttAjPSosJpbqJUzN9Y6AgFUoHvElCluVqAtkFFWbsmYrJxJe2cIInkZGaF3J1RN2ngwUVDxX+Qzy+vwIA9G4axs9Vani1ULULitiXVdr1H7Y2HKjhM8Age3PtbQ5t9Sz/yDMXZC2rPhxuttHNUCXnl4HMfVXd5GQl1j+v5DFuPNNhS/CraJ4pLgMmDxV/fviBNoMvxwtznzEBL1gabt2z/zi6IdxbEBuVrj8hINCTU6UJGb1ZVBwtaum9EoQzVb7YEOIhhfDi4h0WjFeV1F8+hyWlmNTUv/pXIObKhwVik8SPkhgiDTiTgHZc722SQlHVvcJ+qMaPLFthmyyPWq89dpxorcy2abJzn/lD/CJfwcpIiUUCjbxiNTDsqcWNAm9JKCcyTBWCPzG/fHZaWIUmCBSZnJU
 /Xb9jwv6
 z2ljj0AUrYOK7r9iReQsXkSS9TInkkSC+ZfzIKIpGJ7L0C0mEQCqZojK8GbKxsXbGHUTrr5Ng924Lqve4spMRt7RUPz25NtIbXYn4jDyMry1fxTxVR46YmONLi01jlsGx157jHpHCvmbOQ6occAV+voIMNg4A7wlDDDe17zuVhjZaaJgQpVCW3M40hWx8DsgHiD213OVHR0+x4JawLplxN0uozHTdarXk6c/3sXD7tKwMYMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory that can be used by the users to install data
probes.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d5863cc33d230..ccd19fc062f31 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,6 +747,35 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * probes directory
+ */
+
+struct damon_sysfs_probes {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_probes);
+}
+
+static void damon_sysfs_probes_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_probes, kobj));
+}
+
+static struct attribute *damon_sysfs_probes_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_probes);
+
+static const struct kobj_type damon_sysfs_probes_ktype = {
+	.release = damon_sysfs_probes_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_probes_groups,
+};
+
 /*
  * monitoring_attrs directory
  */
@@ -755,6 +784,7 @@ struct damon_sysfs_attrs {
 	struct kobject kobj;
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_probes *probes;
 };
 
 static struct damon_sysfs_attrs *damon_sysfs_attrs_alloc(void)
@@ -771,6 +801,7 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 {
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_probes *probes;
 	int err;
 
 	intervals = damon_sysfs_intervals_alloc(5000, 100000, 60000000);
@@ -799,8 +830,22 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 	if (err)
 		goto put_nr_regions_intervals_out;
 	attrs->nr_regions_range = nr_regions_range;
+
+	probes = damon_sysfs_probes_alloc();
+	if (!probes) {
+		err = -ENOMEM;
+		goto put_nr_regions_intervals_out;
+	}
+	err = kobject_init_and_add(&probes->kobj,
+			&damon_sysfs_probes_ktype, &attrs->kobj, "probes");
+	if (err)
+		goto put_probes_out;
+	attrs->probes = probes;
 	return 0;
 
+put_probes_out:
+	kobject_put(&probes->kobj);
+	attrs->probes = NULL;
 put_nr_regions_intervals_out:
 	kobject_put(&nr_regions_range->kobj);
 	attrs->nr_regions_range = NULL;
@@ -817,6 +862,7 @@ static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	kobject_put(&attrs->probes->kobj);
 }
 
 static void damon_sysfs_attrs_release(struct kobject *kobj)
-- 
2.47.3

