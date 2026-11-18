Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC1FB606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BDJGyrGl
Received: by kanga.kvack.org (Postfix)
	id 8F4586B05C3; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4296B05C6; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8376B05C4; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 491D16B05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFB974061E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
X-FDA: 85446641112.14.D17D053
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 480F440006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDJGyrGl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoY4hnFbJ5g7c+Vl7aZxcV0uXn6NxmdIonYYm4S4XhY=;
	b=PzAWaNJbtSzBQSScnYdALiWvc5OZCWUe5oh5fFvQw1HBFh+35Jj+JwwSDKLy6SU8Ug4YEg
	DnyuZ0y6ZUW7ySXi41p9eQRMBtTY4XDtwsgq1wSIZMV+cQ6ChUy9U0sNoNg2cQoaJy3QgP
	KxnaS8XN8/AuMcmt9ePTJ+eEs+NVvqQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDJGyrGl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968555;
	b=x9+4PAdy3A1dMjid8QmnVUohkFO3NHGsqIIQKpkWrkW0HdU6ff9dWHg/ypFP4JQG7ysFvv
	VYMX+QWmu2J2NwK7w3nVJENF6YLXgeUfaN+P5myWoFZJ9s+WyDSsyZV2DcVgQbwNeK0Ui5
	uBIszzpugXb4f4LPXOzVFsDFzTIV5Pg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7FF461F17;
	Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7629C1F000CF;
	Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968554;
	bh=ZoY4hnFbJ5g7c+Vl7aZxcV0uXn6NxmdIonYYm4S4XhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDJGyrGlsnnCrzFaIATHzHA0Z7QPT+Q64Nl76ExxPjh+o5nloi1fFAQcweOqz0g5Z
	 SVvprU2m4+hjJbdPqLkI3HGdqyBo402LtyfRsGwBhqOi8hXbceS/XGXR2GOJ7UAsOE
	 WUDqG+At3xylwtcVfFKv2rPQ+fe/jfxELLSdNhXwFyK0FkLBqi1bzhDwAjbo0ZcfiF
	 VuJ0KlSB42mGgfJlX/y0E90hgNeicUvF5Hzodm5syQ3SwdD+FtThrYVbLqUSroPBii
	 weK3ncRvyvvPzvI+GWKCfd2S5aps++kqFep5fimbRxJ96Q46Sn4APic5hng3reB7NP
	 C+PbXkmv9iBbg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 06/27] mm/damon/sysfs: add producers/nr_producers file
Date: Tue, 17 Nov 2026 18:22:01 -0800
Message-ID: <20261118022225.100659-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 480F440006
X-Rspam-User: 
X-Stat-Signature: dc1ekggfgekmk4xb7p9kkumefyybjgxs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794968555-805715
X-HE-Meta: U2FsdGVkX19vqoUZz2EQk6PUsVR/WxcoTmxGFKsgBhVTrhPJCMtwmuWcGVA4tgSDWYJ822bIh6ezHxwvpxvLU8gMOEVhsK4hzBPce4rLl8kvF8VzMdEfGuyu6z56Z5z8oFYhzjGGuV6cQOy6YGmITiZsWa/N7SEAad+X4xajeZCKrap7JZvGYI6nsr+utQLleuBF4WWz9mfrxm3V+K/eU7Csh2oqigHnq+OE59OZ7JpEJRJLbYOd4TJYlI4WE591mdtepH6MA2jnPd2huDANQGQ4JOsEgyDpuVrNll7tSWRhKaFA9Wi4lmFFSdFGvp80lWuChAXwbFI8utTTVEYg+JmaBLDqZuSoeJ5vg0VG/7s96tmSeXI26jrL0G+jrybLH8CiOfewAdCFXBgQFj1kU7AlSv2nKUOH+3rJZkHDvRNetZwPkbU4eaVCl+bx69eZ/gVS39A33f6eMiBurulNxlJMF9PccdV71ojMujcrVL5EAXbsEKkj51gXoH0Iosi3keI0XRTrcJNt+qseFPEBSCWFXbkeriWpQeEBCxXomY29CP522z7AM6diLwey1l62Q1tmy1f3NNQWrd+6eQrdD5bs18EO94bLQPkn/7nsKUebr4cvt2HX1da9Up7tZgF0EZg47RETpMADKd+DG0C5ZNS4X6eZyJS1hc+5rV9PfrQfAqQQ4T/ITkj2/y6XCqBjPjL8oWzQGM43SxriKpQPue01C1JBRJdLiDVtdTPESD3tNNxkAICRr4HJCuFp97LgWDdYevL158C4jFUTjBMvbvKnJlYC43Cxi6iGC8CgBtbwNyxzhVx31uqwCmxetBZoVr9W296j1rpCQEHQ9A0mpad8wSWud+YIhAOI+NMV+AFSKyGdlwjYHmDrgLy2WvA1P1Skk8KZPANHS2uWJ9ih7vX8vJzdxUZ+bInGUFynzgTdT7wBBgI6KcD7Qq7CDsNweQbHokLux32rBUohaX2
 kgBgaOXB
 1REBkVq8vecmYDz6PhuxAZUxqeFBDP2zuHdGv0eRIAwd5oS4nl1YlsHPd481q1CWD2Etj0svM8+4svc+XF76mjMHAB2LUKJnR0Q+T0X9kkpf98rQpcc9JgU5bstI28Dlh96YAKVBHw4WKudT08fZSDg8EEa/TuLLpCthJx0OhcBc8lJqBhOpdMvEpnq9Cg7L+UNAwePU6nM1fIf7I72a1POCME0dpwpmY+CvUKBH+gV4AOaTp2PKscDseCTjb2z55GaOsT7rC5Pv8oJr8u5+D413zZA==
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

