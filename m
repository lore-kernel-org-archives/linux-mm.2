Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C227606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j1j0LVS7
Received: by kanga.kvack.org (Postfix)
	id F20A16B0760; Tue, 24 Nov 2026 10:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1296B0761; Tue, 24 Nov 2026 10:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DAA6B0762; Tue, 24 Nov 2026 10:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B84FA6B0760
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 506A4140AE7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:51 +0000 (UTC)
X-FDA: 85470415422.25.999263B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B71EC8000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1j0LVS7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534609;
	b=J/cLc8nYkJstCyQH5M5TEgd/jlR9WhNSXAfMFGEBnoffzguegm6cp/KFL3d2PPa0K3n7Jo
	8ZiuyDK7GLNDyJfxAld97qus8UQPEaFxC4Z4zQSHb44Jjl3SZrBM2KVnbkc8tE/W9+/Wi1
	zCSYvJalGggz756lR53Nt4vFzfE81rE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oM0h67SAKmFyTFD9nC0NrJmlaLbWaTm6qMeGXdW4+E=;
	b=Fu3R/+KsFbNCnNkH5whvsNFp4I9VFWlfo8/bU05Xs/sa1vOpM3BqBVxKHj9lPlyRZm9SML
	poLvVyv09zqtOzFNJGrUQddLNOwMCAZ0Fe20+fvw0dhMhwh4XMJvcF4CSKL3emdoSF5ecy
	/y1CGKnD7XBqCy/9LjeWeYSDl+hj8Ns=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1j0LVS7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13E0642378;
	Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A9E1F000CF;
	Tue, 24 Nov 2026 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534608;
	bh=8oM0h67SAKmFyTFD9nC0NrJmlaLbWaTm6qMeGXdW4+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1j0LVS7s4HyKVUICEvLqjmnPEZgCbfK0q2A5F70gjZ42p6kppPkJogURG55isoOh
	 R9ZDDnRqHDSMJbzy9H/O2ocxGLrG2vtbFcszYbXGjpGLYJcscg40dDScm2VZHXRz2J
	 kdCOdEXtytNWu6cdH9zgpbXLTwcObGBXmHY5k/ce+7eUOrXv1aBvjgsXNVoUeY0VvK
	 NM9zWcn3z4Jr6ME12JfIzLg3AOcN6WcaqbUfVudRnSTk6b+q7ihOZp6+Nq9cArRmQB
	 +hlPp/lmH15NFMBqa3TQ8LyTHnx8Lj9zqeXf+86vRMB7NQfl2MpJsZZs9U+NQd6veT
	 zplhL9HcS73tw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 06/27] mm/damon/sysfs: add producers/nr_producers file
Date: Tue, 24 Nov 2026 07:36:12 -0800
Message-ID: <20261124153636.91854-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: B71EC8000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: do6r33tkc56bj93it4sow47d4k6yb1ra
X-HE-Tag: 1795534609-696217
X-HE-Meta: U2FsdGVkX18wQHpH946GOO8jXgUX1N8CAczupcniIR0wtCBixyg1y14EhW+ZVxzIJf4WMM4bCzAX72g3Vh1Pc2CLUbp3yUofKgu16JggAOLQ1U2AAOW3OcJsaAtEN/44tyPSZwUJwqH7nGV8Rc8M7slO9zJj0sxxFwfO3+GQ7imQI3+M0+eSTAWlTHq+TPgGWToLWUp7fhtTTkeeurw0cfm0/1UrlBx48eleYutF5Sr3emSnqeacY1zWADXw3U9ggK39Qal6+/mG4UzyQPKDWHYmPkQ+Xd1VdBmH74Nh1txJ8tqqW+w4yOl4lenxarosB29qBipkr02Dxaupvs9aOERndTHO9/3ZB6oyhIvd+as7/ta+Pc3htowKE7OWNP0K5N4LJxlv6M1MEjqhet+4EFumsS5CkBC9n7feeJRyLwDmkxAv3NXy4C+ETMBo4U+cGGbpBBQrzclahGt0w0a3fGypeTLFvlviomC3OAqA6Wutd0m4K6cQURdBjyNBRcESo2KJ5k6tmLtpVZzEOWx3anOPRMRqV1LfCHNEpj6K5B0jX6GC1NC91eDmeJw816We3ZzS2GANA2q6XRu7XsS7AcP8iB8Z2Q8baqrY+ND1JjrS/55ZjF3ib/WlKpJ4JNKvHL+C2aP/hhVypotPBuGNFE+pHzmObbjHL2FL3y+fMiIPnHuXp8NN4MV7ELfCPfnTuxi286bBPTPq+d0jUo3211XipVXbAGsILJQlC50qbAF11AchqTjRytjkDIVcv+Vwdepqe5D4X1mW5HC4gdU2eUOjz+B3Wdjv+D9m+y2t0/ZK7b5EE1Ofxhs2CP3BGU/ovokLxCAA8aHG0Y699j5kGA+P48tKCSpcGv8WeJpt8jXyGI+h2NdnN+pgxw5nwu5BADRICVyBcCuLfu3vUYq+/sScxwxlyGd7PEJGqbS2FPn/4SG7/Vu+wBcZ91WXSm7upQA/UV+CKbt+Fa1PLxR
 Xl0DJ0ZK
 NrZT/7mDSF+WQ3NX2cFWvcycTLEWZBh0PAtYx0QmMzDENEB/JM0chLLIG+q8PomZAZaq8X0lvisOY5B5hcPS9Hi2UOQNePxj95lRj/1Fht9GDxTMGDtQvtpEu2LsHU/4atf8AHm9HmJiuNooKhYwpAL2vaEUdztKxdU4txWEWfFqO5g22Z7wAavViZQX5CzeHxiT0qVgB2wBQFPVtWOSAn9p+vFsF9tgoy3MR3TUOpHucrT4EZ9+ytuaVyBbA0ywkwKMJmiDoWBzSS26lXxXLOCEQaOadDDmE7rhrnfrUFGKVT4fzZRIBhcKtD638k56Ww4ZWnmCfmalEsLwMPsuk60ZIpObZClY9/d6But0CcayqiQc7qrR1NlH2S6iD38JtLwOejA0Mvd6NU+cPbwJyazBZk4L6IQoapIxf2cgk1nRitZjTCy0RFDH7r6ly2wHbTbOQNd988aYIkWfNexf2GpYlp8rOYfK/04rsRtjgw939tIoB74UinfT8DigDRlxpLjpsTO+ianzH7kYJApnDRoWj9ws4b0veXrQTYmuSjpyEet8ZiKXE54198JX8cBbEEbDF98jr2+a25/Va+Kf4oK0Gw/qQB7D3jhtX
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

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
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

