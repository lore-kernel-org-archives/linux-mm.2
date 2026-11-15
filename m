Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE1E606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GJuxqnA7
Received: by kanga.kvack.org (Postfix)
	id BE0836B05BD; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7E36B05BE; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD886B05BF; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77B9C6B05BE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB6A3A07FE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
X-FDA: 85438492692.05.1A80D41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 61F021C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJuxqnA7;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774545;
	b=Syy7lH96T867vJtztngrZEblK+6SjW2hwQirMjyAEbCdaTF/Mc+9OKwu73s2P3QwZrB57y
	zBonWLtYOpYIEKiKR/tJhtiQ0rRBGRJ+kfHKYCNKEFvuc02tv2OOu4m87TY6iD8RqSx5au
	H4PSXCyOxvdq+UuIeZ9iP8BMlpibR0s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJuxqnA7;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=en0GKVo205/sJ+JMMbLGyOQzR+GcMBoehXLNhDIZG2Q=;
	b=p7dEMTwSOYmbGIgpyXakeR1yqQR0I4i/oYI45amdoSZVPH6LXUbHkPTnxqJnEyeREztk6p
	jvj0jvLHGnqfgVPigLvdLep75l69u0Yza4/7r9p6vP/5TLHbk8sqpAQH3zgvW+11uD8z/m
	OjSIMpAviOB0ZvjXyF7GKiGGeoHUEDs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBC1A623C5;
	Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8661F000C4;
	Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774544;
	bh=en0GKVo205/sJ+JMMbLGyOQzR+GcMBoehXLNhDIZG2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJuxqnA7vCp+b7FmpsTnPT/ZETKdJLtT8hzrwGWgawQU0wSHI4xPt2MYGec7EVwhZ
	 Ambag9w6oVGrZDBczUmsfZKfv/U36LKWQW3yl1ycxMx2TOzgpxacqCW6Qu09V1A9kt
	 iUPB2YbdfJ8vgTQdatGiXmt+nuMTHm2svueCjB2uTI79tITU2caVy6DHS7iQHbLVE1
	 T10wYQqQvcEJUW7tvnT53Y9wtpPQW08nAJDIn3K77siU1ZFV0wEcfbITs7PbOm7l0r
	 7YfSQ2P6CL+3yv475+wiZpoDN9puFN/TZfLw2QNZAr+tmh83uYOn0SGeSSt7YRYFuv
	 1Zplg2L46BODA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/27] mm/damon/sysfs: implement report producer directory
Date: Sun, 15 Nov 2026 12:28:25 -0800
Message-ID: <20261115202849.99134-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 47hfq5czsdgn5x6k77s6af6381txxhft
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61F021C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774545-729579
X-HE-Meta: U2FsdGVkX1+xMgYCPvSGtV+WgxirreaqyxMCTPH/nri4JGAGI9Qgb3N82iIsYu5tf9NG4wU72U3ptwMswztG2Kx8tXO/zXWvxHqKoc2b6NxX2Kz+pFczGPTU4hnDbgb9UzyF0/x1pLa5dZSFlfO+MJe5xQzNelKzFG+K7rycIwpFP+HA5tTrqHG4FJlZKZFtocWeaaThG3UgC9PXlTI6dEiHN02UwNSDHOuDHB6uM1zGaAIAExjbhkcXOOypQv4WsNNTTknnF4YwffAiPxZ6WEBEYuFjhCR1lb9PhcQAsXnaMaqwGeYBAZ9+dGZSY0RqdMV6o/lneBHduHHWGzKG4yjU9BzvJl+JgbXRFLVjOa1nLFcIL+K8OaLqWgL09FWZLu/FmOFXV3h054RdOzh7wLjeMjg4G7R9LrJTBvDZ0Toq/O+V7apVZYjVgHj6xubM9YCM+g+NdygDTWfS9FAIP/K65LH43Sx8/lcM3Oke1ZV0Mhg8kYxp5I9fxtA1dLzCjW/ZJWIlgbbAnMPkBeKsZbQoCxsUY2OTVfqvoxvWkWOUWyR4ziTlBV5X84YCCkGuFVn4CidLDaeehGjOzLIJoUsqWEhAY4nj8YVFSQmkI478EyJy0x0w9BfLGbHDYMPDlvm4WtZd12wRjgsn5u2JQ1y5gjD5xEWF/+utE+IP1dxLyYDFSFFWZxHdqfcwi3AZwrBkqZ5XaUc7NXg+tH3kz7M+atjY8Zr4trdzJW2b/D1x4D1cTdvgId7EsTJXgKUf6UryVLlMhADcLX2q51ogatzQkj5teMDYGIU+c+N09v0eCD7B1IvlU5Qom2Xbizkqj4OpBlhe5AB1aoDpKPGooZeUIab8D9JngCZRixAzQXXHlh0EP+x9Aj8xkB3jFez21i807w0mn0fwcwuUQw5Am0Uq0yZbRu00UzypwlzuGS2UNvDiO7faCcMBgHGQm7nZvOrLYC9Fov8Uw5258Di
 PknVyN0a
 k6MCCAamKKm5qOv7wX5O6XaOufv6MXQ3KutSN8oJFKDy58kU6iBfd2GUmY8r1I+RDZv2cbc8jK7vf2nrq+CQtdLPOHfLXCtJRnC5GUOJb9ZrJ+w3tj/PoA2ki8dHEeZT2T8Kzt6esDuwpDGdtS3u9Hkqism02Ef48nPzqPvCwCmC3M6F9t6Wy5Oi6F1lXXyvc3TF7qkMG1oAxrhlONH7qonQfHO2Potc/nwDNmUPEu6pJzNLdbfIfOp9q1d4Nlo/CaJfw8Gec4A+TnxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement a sysfs directory for each report producer.  Create and remove
the directories for reports/producers/nr_producers file writes.  It is a
placeholder for sysfs files that will be used for controlling each
report producer.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d3a7cb170975a..7c6bc30c12125 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2979,10 +2979,40 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 	.default_groups = damon_sysfs_kdamonds_groups,
 };
 
+/* producer dir */
+
+struct damon_sysfs_producer {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_producer);
+}
+
+static void damon_sysfs_producer_release(struct kobject *kobj)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	kfree(producer);
+}
+
+static struct attribute *damon_sysfs_producer_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_producer);
+
+static const struct kobj_type damon_sysfs_producer_ktype = {
+	.release = damon_sysfs_producer_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_producer_groups,
+};
+
 /* producers dir */
 
 struct damon_sysfs_producers {
 	struct kobject kobj;
+	struct damon_sysfs_producer **producers_arr;
 	int nr;
 };
 
@@ -2994,14 +3024,53 @@ static struct damon_sysfs_producers *damon_sysfs_producers_alloc(void)
 static void damon_sysfs_producers_rm_dirs(
 		struct damon_sysfs_producers *producers)
 {
+	struct damon_sysfs_producer **producers_arr = producers->producers_arr;
+	int i;
+
+	for (i = 0; i < producers->nr; i++) {
+		kobject_del(&producers_arr[i]->kobj);
+		kobject_put(&producers_arr[i]->kobj);
+	}
 	producers->nr = 0;
+	kfree(producers_arr);
+	producers->producers_arr = NULL;
 }
 
 static int damon_sysfs_producers_add_dirs(
 		struct damon_sysfs_producers *producers, int nr_producers)
 {
+	struct damon_sysfs_producer **producers_arr, *producer;
+	int err, i;
+
 	damon_sysfs_producers_rm_dirs(producers);
-	producers->nr = nr_producers;
+	if (!nr_producers)
+		return 0;
+
+	producers_arr = kmalloc_objs(*producers_arr, nr_producers,
+			GFP_KERNEL | __GFP_NOWARN);
+	if (!producers_arr)
+		return -ENOMEM;
+	producers->producers_arr = producers_arr;
+
+	for (i = 0; i < nr_producers; i++) {
+		producer = damon_sysfs_producer_alloc();
+		if (!producer) {
+			damon_sysfs_producers_rm_dirs(producers);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&producer->kobj,
+				&damon_sysfs_producer_ktype, &producers->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&producer->kobj);
+			damon_sysfs_producers_rm_dirs(producers);
+			return err;
+		}
+
+		producers_arr[i] = producer;
+		producers->nr++;
+	}
 	return 0;
 }
 
-- 
2.47.3

