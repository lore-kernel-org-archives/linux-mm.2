Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 354FFC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5856B00E8; Mon,  6 Jul 2026 10:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8518F6B00EA; Mon,  6 Jul 2026 10:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7671F6B00EB; Mon,  6 Jul 2026 10:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A53D6B00E8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE5F7120432
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:26 +0000 (UTC)
X-FDA: 84958559532.17.1CDE3E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 261461A000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCFQU98w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	b=p/xgL/8a0imzTNOYE6UdKeJ4IazAO5+TAAX0nqOrJSwr5Tw3cxY3Hk1SI6/WpGUZlzwjv+
	Z2bYEwP2XbllZTey/Jafg0M/GsfiG8Y8fwV4/kf/ULOLW70MHRvVBGyHXoJPssWoAIlr3C
	zRRL3BBHP+6hcqSjrGz9Ffv9Wg3JC2A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCFQU98w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347565;
	b=JAQuvCM6ffC6PsezBdpvAwgQfFlyHyzO8GBW3ASRMKSIDwZkhRksQNb975VzsEXGsdViqz
	Lu0GrlRBX6WMV8zxinrhGCbSsyWrfI1cvC1Up56jij6HnHhtuxxe4ubYj3eIRWHRIjXeTP
	qj14+ZXY79wMMkj+tVsITKyb78ZVyfM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDA9F60098;
	Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8101F000E9;
	Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347564;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCFQU98whh3Z83+9WS/sIOLJTtgnuUq+PXZYs5xCChKyY/Eqs6kxZmUqLRXSf2eK6
	 eN6urGj6dYEJS2/ncuE1JfATWN3U97Oeqeue+GZlcinVbTMFJiG4KNMXNoWR7c88M5
	 joOd3LCCjYi1j8iohJdvPShDaItsQ9k0PBYhX2HGFCo3XbUPm8yfyKSmw98Nd6gZvd
	 6xoPlgXgSV6iFf83o12lFUnz1dLKIcJmz8jZ1S/U2qFnzIYMmh3MbccCIAbfl6FBHu
	 bDfRhUpFxARcwbA39yy9UL4JJTRt4pkTnUiPzbHjyHOPMQs7dmUcYQed6LDHgBdUy3
	 B1M701CGBv4+Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 13/16] mm/damon/sysfs: implement probe/weight file
Date: Mon,  6 Jul 2026 07:19:07 -0700
Message-ID: <20260706141912.88445-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oi61hwskk3xe7p19grjt9mk7xzp88kgr
X-Rspamd-Queue-Id: 261461A000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783347565-699703
X-HE-Meta: U2FsdGVkX1880FYwv/dn0ql0uyN1cb2r0aX1qyJ7hKSCN2q1UdtHctg0kG1kPP/tp6nP7uB8BUMTRsM/liCoJ6gIPOrJcsWWAQViFfM7xV+fgb00SuZLO5upfAzautJh2/G/vxP0nsE2hKq6NxMq6R43uUrv4SNB1bqv3X14ttqn8uInxyaK6DyH2MnPpv/GuRAyRUE8hVdsPe2z0t9hONMd2gZQjeT//RnKaBY6JNazAUap2kA7trCIj5bDPeqDu83Ua8kOCTyWbtJqQlwA69kcNrMoEBzIh8KobDjfCsyhHa5G5uXNSMb7OjVmwq2XqMYRfx7U9OxZ4qAp/RmGYEg3ROtWOpaHLnyzTifhx5ejazsHicQiH8IVuqh/LYAwe9c76RmI6sHXUw5GEoxf7tfqXCJSHrwGyVPr5egxjQ1o8rXzCivd84BhiEjyZoN2wAPykfwcrwL/Y38v0ZlBJoId9zjH1FCTICR1LpjbMlRgnalQnEKsFyGuzWb0yRLZom//W4zjmq/2HOvWB0B7BWyg4Cgmoqq6kId/FMGG8LopAVAX0qvYif2Kdcd2aqeQgEypeiTdsPVz5StUlOlV47yEBGf3qsojNK99dj95BTO0bJB3W+QGwtgHpTRBIHoNll3vjde2nCTWCzUY2i/GMrOs59TXOM5Y9Rz1bjs6/QhRgxQ/5+emaZrURzsRCkwF1oV0hNBuYZQHyXo2XhzcpqD4/HqF10KTf+Srd0ZrB2PVmjr1he00z3pEHyJV9bgi3CzPza9ktSZslGDokrqsdLwY9r5JH0Xj7xXjqL+8PyUDH3PeUg9F6Of3Zvi+ZJjfbn0lByZ0RqzJkgNBSvKpJ9Eo35ZPKIGYyvHc1xw3BEvFjpZXJ+4nopGCqiSyuAI1Pt7HdD4YeS4bXBW90f1SSNDKsd44o1QvgrZpUAMmvnE+pnHPnDH/bGGlfWYCGYODXYkc81MUkTSqSCGV5VN
 xzbfhCLb
 inNr3V2wnYASs7YPPxWHRiocBkurPsgL+nI/XPNbvlPHSUhWLvqjtM/ANs7ZO6tFWLgPfD2VMiF5r2UfofdReKWS+vcDwLG2w6ZO9GfgqjZovewyQj0RldWRpDxBVdln04T+2iaEfxnV5A498f457TV0scOd80hYSdSzy8WrywtyONm4x6YD3rB8tjDYvH6RGBNfwVbUHys060pxKDWqUUvEmKcbftCF5eUW9Dh8CDHyuHHQ=
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

