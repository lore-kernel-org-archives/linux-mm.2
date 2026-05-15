Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC962CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3F66B0099; Thu, 14 May 2026 20:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB356B009B; Thu, 14 May 2026 20:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8916B009D; Thu, 14 May 2026 20:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18DE96B0099
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D45C5C27B1
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:51 +0000 (UTC)
X-FDA: 84767809182.14.AC990F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4258E40004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I8zVs/ck";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOCOUXrrGOmkIShfzA+sqGvb/yyciinb78vwJg3AWMM=;
	b=vw2Yz0NZQANkDQLSNHG1AuiX7YkKXBT9Rf207xdQBATDkCFhUB823rsPwo9K/4T0Wz2yWB
	MlRPM9XvT2xraY7dDDshQ689xVXf/vB25RMReCtHYheKFExzUP4j+7TX1SUSbTJAIWhhhW
	VCtqmySdire0raVtEhfR+I2vAxXifGo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805890; a=rsa-sha256;
	cv=none;
	b=nlIZ8b45ERpDTv/X/yzfaySwwSVb6nFcYyntsKlrK0nKhHkh8JJwRmMvnOAJcIVXw8kVo6
	HKxewgD6e/X7G6K6nTdR9NupyNx177div2NsOHE9sHjc0h7ugEkt+MASdtBcamreEUv0E0
	ndgrZuiQivGWa22T9SCG7M1x1TkS58Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I8zVs/ck";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B320961146;
	Fri, 15 May 2026 00:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3588FC2BCB3;
	Fri, 15 May 2026 00:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805889;
	bh=iRZBRbnhuMWGPc47mimwPtAfnZSCPltTg9pBo2Ew2oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8zVs/ck7Bg7BtG7kEZLqI6rs0Oo0A07j0/cTzcoDGXKtRDkOl0ob3zWdfbg64CLE
	 hKwnZLNo1No2WgaUCsvI6qV8Gmah6VCi7U3Jhf35LrKleChJySgl2u9v7TRARtbdag
	 nnmV92+xmHF6+0XJJ9KVoYXEnKjjeeV1RpO7TyzdqRiQiIQDcPXH05MHX1M7tKuq7E
	 Xp4URpN6fGNvcmAJJw0TYWRxNbBsa01ytMeJbuBzBA6qZt89cvkkdMV9dzDbV2x3AE
	 S8YSGM0f3cA7NFjYormjyTFwpCzsotikv9Jvb9b2Ky51AP8NkUDbCuIlaQJoS4lKdI
	 +IGtNzzQaDgmA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 09/28] mm/damon/sysfs: implement probes dir
Date: Thu, 14 May 2026 17:44:10 -0700
Message-ID: <20260515004433.128933-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4258E40004
X-Stat-Signature: r4tp3f7m61xdgx31i5pz9ns3c6i1whr4
X-Rspam-User: 
X-HE-Tag: 1778805890-913789
X-HE-Meta: U2FsdGVkX1+dCQ3lThfMhjREtSmPYgRja5n3ztb17k2TMakApITXKJKno3E8oXTHCo/SvYin0Nolj37vsHHnXJzc4fE4hYyA1B585dVKT/i66fdSjkNpkuCHrtDORurigiFFH5XJgxpmo0HjXuI13IfMdvlvPbo3WHNnN6rak1kEWUZdW4l6JIz4tNHTHopGSk7lWX4bkM0A8ipTE+yaY76Lr9jYIfb1vcImfxKXPcQ0b/9YbtkkcVEzj2czuBlz1kXUuC9Za5BdssltS3BusG2lcADSOMpJv2qITAWwXE3J2dFXXMc/fSaM2vcAmjZ9QoiglsG/2HpeKvOaFP18FmwpH8KhOsgrKomXXKLMt9qxXgct7oQRoV/ShqRxnfxXy4tIsZgui0R+jUlvCPrnFnvqZT7Ah8dhXFtdi+shdCPJqlmCEni7oUHMIRl1KTTn8lnSpQBqfpHpJBanL3VO6drmGQpAzka8edUxlZNy50/ZvmyxyYV5XSW1WNRCTUTeQl/lIJeOe+LwJwGZV3xTs/Ts41wXwC9cA6T4qa+Jw6OSrX0m7+IeF804yV8nJ5AUprwHBxA3cTxYhSX1JEfVdA853TmC4cWbaCcTiq8pC5HnDj+9t6jhMLsUW71NFuSh318XWeWRuMDrI5o7pM5HoLmn61w+6I6N3SoUvIWZDoo89giHBj5AniW7iqzYj8Hb4NlGbM5YxMw846Dh4x5W8cZoypx7ty8eyzCJvYk3o6KTB+/c9PJWUWXqgun1s4NkKxlTsaegG5ryCblwKV4SV8ugeI1FGjGPj2E3sLzATcmXVTBsKrTTxYdrCSNpUQYfYv+cnWA2d2VbbPsQ6BRihvVoLguzTW1HWTwDN9AzT6UoRWScNO8As30vbG8FVzO+3TKIpuFEsmgbRYyGkYbZ3VwYQc5/F+wQSuSY15hqaa1wrktJUVjhhPBppWYO5n08V6KLfFD/AzZuG+AmL6h
 EvZtEhOe
 zlHQcQ/1xieEiffCYB1NOvLSbMDqDqUEOO4WQZR1PWEZ0uasJHDIkshVYbX1iqIGfzkg7F07yXvXNfkKcyszmY6B3lIqFC28VyYTsVM7lSur3nXIGq4Mof5Dt0jPjAjy12qVwdIXxiQkGc0LRi9Ubf6851cWEtItoNmp1LuxjXm5QkFzwZAc1876+8jL4Wk0Z+U2R35wWfIJq/6xrVsSGxgNe7nMuigSgYkRa
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
index eefa959aa30ae..5f3b253f50ebf 100644
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

