Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332A3606A885
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ID7qKCGG
Received: by kanga.kvack.org (Postfix)
	id 864586B05BC; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7666B05BF; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE406B05BD; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 343B16B05BF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98E92160806
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
X-FDA: 85438492692.22.F2DE9F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 05392140004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ID7qKCGG;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoY4hnFbJ5g7c+Vl7aZxcV0uXn6NxmdIonYYm4S4XhY=;
	b=66IxL5gG12Tvpl1pH5uLwXPTEurtmdm512gZPUWUyZtaz0NmBqtTd0Spm28C9R/8YXlXX3
	2UM+ahFV79dz5gHcREoJaFFYUxxa0wvlNDb4EIguwM61mCVDS0KnmbIyrepI8VtwVHYLpO
	1CTJhUPosqyUq3aYlwX8OPxnDyCX3Yo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ID7qKCGG;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774545;
	b=fSGiaZQ1GJg6NtZGjGIVV8lGMvU29G4ByErF7SfkYNvT21qg4BbkyO9oiboA9a4hM3M8j2
	DuX6Gi1C97NURHDWPUS/hkou6fQmROZi7FCzX7i7BggxihJFPxgnSfnCBdKaJmPOZ9Ybs0
	u59UHYwDhmhNWB8x+74if64UIx01+V0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0EEC61DE2;
	Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A2C1F000CE;
	Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774544;
	bh=ZoY4hnFbJ5g7c+Vl7aZxcV0uXn6NxmdIonYYm4S4XhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ID7qKCGG0jU87u+XHV8aN1YanclyRV6UBKKMWWFc1i2tX+AUbVyZCHg7TrXjekIp7
	 Md5Puh/1ufVf6260SbS3E9hJfUOQaOSeaZrXRPx1g2nooN82FSGJPi87vdookoA4WR
	 0dKMK8ZonhTNBf8ucbMPCsFx5rTbFWoV/ud9JFhN78pYYcB4hBxvFwC1pZ1fmnyciU
	 G/l/dsgWHSIBWxZTaPoufsfhssljAYwjqrvWZ5lWuF8x3TwbAXMC1tr/isngaWUkJe
	 y6itdsxU9ox6oMKqbu5rIIhWKQiUyZF0qXg+YqUWFYPygGSDZNdpi9pATLfz0mS820
	 QASKWo+l9EsPw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/27] mm/damon/sysfs: add producers/nr_producers file
Date: Sun, 15 Nov 2026 12:28:24 -0800
Message-ID: <20261115202849.99134-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: au9kejgcb7iu9w6ycpo5jfwwdjz7pftw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 05392140004
X-HE-Tag: 1794774544-285340
X-HE-Meta: U2FsdGVkX19ZTLSvwrRxqvChlrT9d8pBoCVP/FZHDmopmqyq4e/kbJ+UYp7httP0Dq4HF1Q3YgpwPPq8zcBrFwT4zuF0oC0pif3cNDVBgGMRt2oPFN9ApdGiEQxki9j+Hqt8P+/yeTxxcVtjMVfNmXVQvbdNqppo9YqbBLAOYMnvHbt/yNAaBp98bvwvGb/F/QZmX3aog77C9o12gZjCZoAaNDNhvoyd4uFg0tvldSPyHFEf39ddp9iLenEQGtXruF6+QJtdFWYFc48z0uS/vq9M3NxrIhSRZLBGmvKmT+M8SNxhYrvyze/b/4JkH0Qnd0Jxpq24lzu5pGm1S8B62ug/tZGPVm1zaTpl7nRCxdTsZgtGQPsowJXSkuiv4oGb2aQ9sg3oygNhgLvl+nylgK7wUOF2MvMCMFzDclcrDAvsWhbTJ4jR6ylS0UlFKvdihxmejfgqRVCVJa3i5LN98rpD5RL/iT6lGMpppJZiMruqYDZLV9JC+L+i3uGjahKd6YGGT3D56DcHCnnBx5kcaGwMAZ9c5TFNpE6BvUxpheqcX5NKM39dAk0dW08DBys61REq4scGimKNhoLp8TDE7CIqBA0VfRvtNrANGEysD+4i4bb17PJTHuIE4lKy0l+5eMe0JWNaFvt6y/3gqNd6Ad/J9gvgUzGcx3/rBqr2Rba4rE0NsKtQD/oidbfLxoSIkerXB9mzJ1aPdDAPaqscYJbNXqqHS1lznGsn5P/mrZYmaL8M62M81hSW28BWdeq5hFJxQCd/iI4L2MxFWvFKQirKrhT2rqV5y3ectJ+48MqAlHw0qPdKh8Uqj2QZng/mpOsWBkFAdXskswDIkRAWQCrIvp2RpO8W9iLR31JmOIcYGmgV25jWraQ2JZJtO3SGmX5Dh14/w82dLNEB19r1rsCj7xLR9guMztWiNzVIM9a8nDFiN+YZjsxmzxhMPr/GSgBK+zez3KisjNULCi0
 KUcK5nrq
 z+zREfnnNoKyF++7KjTdxVUi1fSCKBc9XLCU8ATQdLx8QYuy/k3JDvgGaay/t73XDT770ay7Wn45r8KpHVLzGRkx7eYoOghLG/FG/ZNKcT9EaCTLfJZN7Dvn32FAPrAg2iLOfX4AdaaWKRjoI+/lvY9KQJmyY4gKAe/yNEjwput+RtNciN94NG56NU7yCmj+7ukJ16ezA97Gt96uYHijHQt8q0kVqvWPB9Uw0rSstrvUq3yWevfBSH1lLVN9UIn18Bvu5GXdU74OYWg4O8aLs3eIcYg==
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

