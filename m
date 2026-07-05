Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5200EC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3176B00AD; Sun,  5 Jul 2026 16:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0739C6B00AE; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBE16B00AF; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A78A66B00AE
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DBFF1C0E81
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:01 +0000 (UTC)
X-FDA: 84955935162.08.94F1F53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 85F26C0003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VX9GHMPj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	b=eZ00hOXPUZDqUt4p21spU5iYvX6LtGKZYBL+w4qQOB+yg/7BtceL/wCNE8ASNgJcVWXlPY
	XpGUFd+DhZPZd1prbW1oW8Xbzgy5g94SmXxCxRP6RcKqpTmcGq8LDLXumqAxMdvePLdagd
	ieruzq88xRq58JfdDMzlGNROakLIY1Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VX9GHMPj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285079;
	b=PxsagSql3e/iADu5VUXGEaRVJzWpgWp9ajg+ByNzl137Bjxbpv7gsrG+YmULgHmx9oCea/
	zY+amSkMSn2eO3qZBlBMPn0uF/lnP1ZSatLXTD+L3UxjYcw/6TCFc6+9rlK8PGfDgAgNbk
	WUJP7pRLOpsWQf8i0pW52EBL83xXO8Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B67960018;
	Sun,  5 Jul 2026 20:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFD81F00AC4;
	Sun,  5 Jul 2026 20:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285078;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VX9GHMPjitYbgUhbD/eOt0yomF/5zLP6SWMvxfHtW0JGPH746SuoFNYGBrDz4lyxT
	 Kga7TpJYKyWu/7LQUo1wg0bN2sNSYJrHEqxF/DU3iYzasJM7t1jv3TiWp8GOtUdWt+
	 1r2QSeei00367QX6veNOZzaX7U5NdDI/AkcznfwKnedgUvXacjuWgyHo6Cj5Yj+IO3
	 y9UBnpl4mkWOe55YEyavsEjXeUOhY/U1Fv2wS8RWIwRBGAfcEMsHWcxm8PXrkNWqHd
	 IioLQheZphLpXPxRvD4/DNUA/bkUBMsMlp1SSQKG1v8sw/OGVTVgnaDjfzwblbh2R/
	 F8oeo7BD4HFQg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 13/16] mm/damon/sysfs: implement probe/weight file
Date: Sun,  5 Jul 2026 13:57:35 -0700
Message-ID: <20260705205743.98656-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85F26C0003
X-Stat-Signature: df1ctchqkyi3dddi3f35fogq59ktsfyh
X-HE-Tag: 1783285079-543597
X-HE-Meta: U2FsdGVkX18I3Kt5lr0SO44mmcqH88jGzM2RPLvaPxdysAMMyXFYY57dImA2Xy2BgO4DJqDY/q+90quhv+pu3Xzq0lFRs6GUVJev6t+ILhFyw6MZmQcI3JoPbXqCFC5cRule4JlukEf3NCVWJPXZpj8xzy+zs+fmbCIiGUfnb4jQIBePE9+xH8k4hEik2yr6kY1+DjHVkV12pFnjQtvbCC1XWE1spaQ/wXiswKBYmtbGovTV5/Pa3StwKq4P5KTqxBlf3eWBvimQz3rEJyNPX2DMLHOKaJ4oBZLA9XEoO7FKBI8S39VWOZRKqT39rKOyjtV+6qPljflPoRpx+2yF0scadbLPDcf2FLQnqJeP853T1sXYYsOmJewvQf4o67+BY0spVzak+Y2WsNV63cjUMyqRUAzzT9qlQ5k6oYnv8Qla6uQHL43PV8RRP2nMhCzcxSw4Wwrb//RPpWIRayE6GBPw4WDgpKV3MOArg1/SRDxa9rfrB/+L/Z1VZJmN/KkJ8XuVbRCovUSqbbF2N7cEkMCMu+BCCcjMQpPMDXKG7nLwH1nn4L2iX/lKZ8p5TA/PVOpulvXwd9CsA7pkgbnvlbHa0CdemA4uRT+P3SiPU/940jMosxag7hfOUq8oWES5kVcTsQH/ezVaoFepYfyR1ciikWlmP5RAGX2Pp1dnflk726X3NFoNzhrhSgptSyXEnpDHs/htUhb27S7Wcrrhz8hZEfLQbMgXmagfgzt7NYFfkgUonrfLywMz0XQQ5Jgty3U8TJWxlbPFFnioxOa5rdY9vWzHEgAJ9/RiyUA+7WX6do/M4pQKkLex6Nk/yd0nDyw6UoUKd3aFeybnErw0elnvOVObRJG2nJCQ82rD9KH9SmaTW3nI08HixcOloATOcfCm0db+fq2XM10V6nu7XSHyoX+FUA+bKgYGMOgU8O+J4sbskmsNYlIx0MnSsGZUJxAlwxDP9XXSH8COhzY
 6yy0tzMr
 pKwqfp5+ORVAs8UQzPWuNj94z1Vk4P3e3l9oJLxjJHukWJttdT/UwrJq7eCjYkCpjLSSkBhketr+SDzmEWn6/Z1YGxlUe34x23ThKFO4Cyn9DZG99fIHrgPn3390Y/Z8E7rFzVtfH3Wp3MD4SYzIek96On9maKo1PoZy5eP7+7Vrthq2Q2sN12WnuDTsePjJMB9yxoX1KfBzgvUzh0lYYhUq4iMHIAbSmqtlqjM7UycpWKKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a new sysfs file, 'weight', under probe directory.  Users will
be able to set the probe weight and enable the attributes only
monitoring using it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d7e36c9e509d..b5fe036f78015 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1065,6 +1065,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	unsigned int weight;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1100,12 +1101,35 @@ static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 	}
 }
 
+static ssize_t weight_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+
+	return sysfs_emit(buf, "%u\n", probe->weight);
+}
+
+static ssize_t weight_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+	int err = kstrtouint(buf, 0, &probe->weight);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probe_weight_attr =
+		__ATTR_RW_MODE(weight, 0600);
+
 static struct attribute *damon_sysfs_probe_attrs[] = {
+	&damon_sysfs_probe_weight_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probe);
@@ -1965,6 +1989,7 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 			return -ENOMEM;
 		damon_add_probe(ctx, p);
 		sys_probe = sys_probes->probes_arr[i];
+		p->weight = sys_probe->weight;
 		err = damon_sysfs_set_probe(p, sys_probe);
 		if (err)
 			return err;
-- 
2.47.3

