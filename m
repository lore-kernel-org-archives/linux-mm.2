Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0767606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c+oq892n
Received: by kanga.kvack.org (Postfix)
	id AFCC76B05B8; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85CE6B05BA; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99AF46B05B9; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 619196B05B7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2396C05D6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
X-FDA: 85460344410.02.814CEC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1A597140003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c+oq892n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294824;
	b=REJs4im8bvATe+VI2u7n89CYqAMWuFY9cIReHNLn5IraIlq9PyPA2q8Q5Yx5ww+oLTnOSc
	8BsulxxqN9AvU+rm1Aq4Rn+vVRuFoVnkYniEmTYBMkDX1jLUyMdod0OLaLHe2kNJq672bs
	UIopN+W/pSlixCtyyH+m/1mjG6kQPCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoY4hnFbJ5g7c+Vl7aZxcV0uXn6NxmdIonYYm4S4XhY=;
	b=s90RmBqGuSvzTeOTdYTIVXhZohTratOhG+M6g5+lO3Iya/YqYI7V2/xw4vxWizDqk4rafc
	X+hfkyxBOdIG1kAQqMNhum3h3SeuAVuoWHEktwN0NMZjZwMGRZplI+XTqT+OAMlygRic86
	CJd672L/TENCjsqpuFPk1oDNQ6IuhRg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c+oq892n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D39161D12;
	Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2FF1F000CA;
	Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294823;
	bh=ZoY4hnFbJ5g7c+Vl7aZxcV0uXn6NxmdIonYYm4S4XhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+oq892ntVWyJ1YEx08mPaE1T7ozX6X9bt8h3AkLHAJZU03txkrSykNiibVGqpnsi
	 57qRTXoffWcB4LbH3pNbjR6GL5rbP023l7GXOMieGc7ku7xE7fne9df8ML5a2rTPP6
	 qdXmrAXbATdudDNxVmkgv5UOa08fZTJS2uPXEPI+dIXgaImLVnL56oLK/5xdyjxb4k
	 weh4L5Oa3/ozcOfCXYpWqvz2ImBcGpo9KaRKLiQyOqwmZ1TLZ35CNfca+vI7MympJj
	 L7n20JcnENZR2nCI6AUOXPfwwpAA5OzK305gwXUJX88SiyXLO1REQntnvXYu9kv+Tt
	 13ETmp4NmP1Rg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 06/27] mm/damon/sysfs: add producers/nr_producers file
Date: Sat, 21 Nov 2026 12:59:50 -0800
Message-ID: <20261121210013.130397-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1A597140003
X-Stat-Signature: pehityp3a8dtb7p4ai6jqpsi56wtqzm5
X-HE-Tag: 1795294823-29504
X-HE-Meta: U2FsdGVkX181cYZFkqf/AtOPd/ybDNytYjiBPHgUSHHKA46roaQVEbddkFK0N85HfD6dzG7rpxMk+8smYBl2rXhwhn3lus0i5RmS7AGW2aue8Msu/EJgZ9feJzOpEKp/dVYnDDagbksW5YnRNeuOvWCSRMM/04u8yhvp0bGwLDZi8btJClwFhx9KczCmzN2m+74zAhuwSTXJ4wU/TEKqrIVl/hQMec3nV2fJR4ToPvoPKit8wzkX3P7T2/ry4erU9/0GNu+qE3+x2bgzfOsln8xQOsDa1XpgulILgkHUgVMZo1eS/y6VIXTv59k4Y+1NjS34MAkibZkE7zwtI/QIkGafM7oIHfYksqDTBkhtSBp+DbdFDH54ZUVnZBcGq539/q8G4fQAvo+aSaTQlQgxO0Debn1NmMveKmZvzP7dAa2/ZkS20uhVEbR1p0JUGGSfsByuykbsYd4jAjfJD2X7otZOJDabuEqgO3w7UJ41AugACQ0U6LisiKF7+mLRNw8qt0i3ww78CPV8E/1Cqv43PWJx/TTBnbpPYlTkkY9bKpK9lSheV0YjBQi4kCvBdEnrQlbs2yAdMxzxpm5/X6tmGVs4mERIvjaTxqxdZKqDCNDGH8cHMTvpoOBOYKAhtw5TBedterF9v2XHVkekeLZ2XLs5ggnfq0BJYBN8K/94eouOnOnYSPyfDXG0D2ZEGrOVekOSyCIvfGXO2Xrm2Z1s5dHcJa1ybDOXdMRAtTzsyeePwj0IhxEXNC09nq7mareUyjsfwC/NTHQT6dysi5nfoiP7tWmTu19ODxTbF1ZR21Jo+1/TjycGFFxWBqHZzwJJuHByO0CmVw8fY6J8BOCLsknzeVSWVF+tWs9Q2Q5HscQjm5ke+7Mo59Szmm78HB0Ru3W5CI5KNZnlhMwcGiy7kOX3fYWUjDwap4jnCbW5TMSubcnctIvARe7+tcVlI1/V2FMrckj/vNp8RrPH4AI
 t5IllEui
 NEFsjYJJo9tJZGEVE4id1oKOhV+Qsj2SWxzrLLcQbG0wwfDRW5p5erggXxEkvyymCaDr351ha1EWLWxZ//kP08+nNxH+YkbqLz2j/VL0mlbyytSmZIkRgHd0NIGL2REOWTIqQwMINCHJJ+dHp8l9g3TSie4tIdSsLClreyJ+q3H0msgpz+003BF7zlr5oistzIMEvsdEfaRt3MbeJdi39Y/vOEAvy4Q20y5qO74xYvOTfmy0/u8xeeHt/RcLgaCMZQsfMKtQ+poqt5Xl7Q5K+feINOfjIXYAvbhi5QB59BLJQ77y0YrdMuUvB67JgrLaR0fQRjCW4tXV7yV/v+F1KcrSJnHtLjpUWxS1kKZc7AEog8EVBc0O/RgExy1VacwjdHKP1a/vkS+V2sDVXENkqcRoYCwpNURQSkmuzsx+KgWVSkg69PvihA4z1mkHB6yk11n0wLx9XdgKIS2jdmhn7G/WYjU1dObBxvWBJ6sm4Zp8qE9MDojGldLlCarp8tfEgQpT/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement a new sysfs file, nr_producers, under the producers/
directory.  The file will be used for generating directories for each
report producer, in a manner that is similar to the nr_kdamonds file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 75701ed662222..d3a7cb170975a 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2983,6 +2983,7 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 
 struct damon_sysfs_producers {
 	struct kobject kobj;
+	int nr;
 };
 
 static struct damon_sysfs_producers *damon_sysfs_producers_alloc(void)
@@ -2990,12 +2991,62 @@ static struct damon_sysfs_producers *damon_sysfs_producers_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_producers);
 }
 
+static void damon_sysfs_producers_rm_dirs(
+		struct damon_sysfs_producers *producers)
+{
+	producers->nr = 0;
+}
+
+static int damon_sysfs_producers_add_dirs(
+		struct damon_sysfs_producers *producers, int nr_producers)
+{
+	damon_sysfs_producers_rm_dirs(producers);
+	producers->nr = nr_producers;
+	return 0;
+}
+
+static ssize_t nr_producers_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producers *producers = container_of(kobj,
+			struct damon_sysfs_producers, kobj);
+
+	return sysfs_emit(buf, "%d\n", producers->nr);
+}
+
+static ssize_t nr_producers_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producers *producers;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	producers = container_of(kobj, struct damon_sysfs_producers, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_producers_add_dirs(producers, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_producers_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_producers, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_producers_nr_attr =
+__ATTR_RW_MODE(nr_producers, 0600);
+
 static struct attribute *damon_sysfs_producers_attrs[] = {
+	&damon_sysfs_producers_nr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_producers);
-- 
2.47.3

