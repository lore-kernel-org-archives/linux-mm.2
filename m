Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0BF606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wf2mGbVc
Received: by kanga.kvack.org (Postfix)
	id 0FDD06B05C0; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0129D6B05C1; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42E96B05C2; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAB0D6B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F76A1405AD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
X-FDA: 85446641154.22.CE55249
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A7838100002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wf2mGbVc;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968555;
	b=xD9ZDmWSMEz54NEPxqMMmZVuVOFb3OkLOjUB/kSHqy+UDA0i8dqDGy+cfzFVIPTgwA+w05
	EBrmfGsobQuaAbodQly1HYM7O1wt7WJM/la0hBo3JfKh4ucbhIO2RL8zLXPKw9h28EAuIv
	ucMCoGhhlTKzj9KTXwaM7u66uA9j0Y0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=en0GKVo205/sJ+JMMbLGyOQzR+GcMBoehXLNhDIZG2Q=;
	b=3K5J8jAiiPmyMq+0LKqdbKXrkS6wwaZdLXyIKg0Bs5y7rqWaxiiwxD3ph8uWzViXpIRzkX
	miphsyzXSCYJbr2tU/HL8VutGUzMD640Zkz+alZCqDQHvgcIN7wChs7vrvFCcX/VQXkqm+
	n7xiWSo9BwclgYjBGjtuse9c0Sho6H0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wf2mGbVc;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D38A45BDE;
	Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27971F000C5;
	Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968554;
	bh=en0GKVo205/sJ+JMMbLGyOQzR+GcMBoehXLNhDIZG2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wf2mGbVcpLyrzgFwZdtlw/Io2GXH4yW8sqWqJtJXJZhUHHyCNgrd72KE621L4bg7w
	 h+xG+I/p4gV+J9HfHjQjQPQd79Sdcy0BkqowQ9Uok5VBJeCVOR38C61ZHyJ194T2FI
	 YufUaMKdixYOP1tnawV2nNbL0z0oPh8PL0BwzFOp1QdRtPiruJWsGzSh93V4s6t2tQ
	 tpjXd0DyMvqDDJRvXPDLxpGbB1faUxymoZnJ1MJnAZ+juzUb0uhUFSwbf8H/7FW/e1
	 oHu9Vs2sToiX9rwjgttKZqEDRHikYGHYaVlypKfhMBqLdnYYsFS4JH0iVOw7fGz4Nt
	 VdgNGYNDCSv4w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 07/27] mm/damon/sysfs: implement report producer directory
Date: Tue, 17 Nov 2026 18:22:02 -0800
Message-ID: <20261118022225.100659-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A7838100002
X-Rspam-User:
X-Stat-Signature: cqpfebyazfykms9p47b84dxszjfqgt1w
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794968555-265238
X-HE-Meta: U2FsdGVkX1+T6pFn5CbFcNba9FQeEYmoLZQ8sdQic2HbirUP5JUz9p5YVgob3DLhlkgJGUCWBFuPxdPROYj4qPZEgap/JkKN16GnKj0PiqqfmO7YRx+amgZrRnldGhfkeKFaojZuzEIaApaK8pkIYTCziy5+X6K222GClrKWTgqI8swe8MBQFFZ4aVZuGh1a3YFNVMWHWh0NRrW8zgbNaCTJazNW8HvR6JCUPK7Tbd/op5/qJTWA0ukfI1CZa8QRk1pm8ow5mGsL3WUYEvGMpe1KFzU99zm6I7L+GeI7LTyQxw4e+z2FUcVFcBvxiKD8CNAPJB52bbz3vGLVHq+UR7oCQKFSlBpgNr2IS4qY9QkRIYOa41IfDUq8DqsjYjBl+FzbLAM1FSs7h295+kpmypFun1angnz/5SK3jOd3P6A0/P0/OHcPKERQLqIscu0D7WzbcwBV6tE9RHIOtjXeD+bm7mpTLyht3+Kpw8K95wk1pplVDKaQLgYvY+fDBSvpuM9wmQGnUQf7Pax73ZDIFwjAC9FRdbIzGst7SjZu+6nkB8z0qJYY+KwUwmyle+csv/IIpxEb21WyqJtxgYiVTDxKW9s91JeCyS58SEa3Pamp28f1zHySyYveGmlUpDGjPQU6dJk8z4vXbsUcOgMWUbHsd9XA0Z7RkE4icXdZuPPeD1vM3URyUSlJXeP/GxIwO3wwLqypX9/8bbYH7U+Pl4FtiybhbunK2/Ia6GKpjX7Ww/+xrHq9YzWmG/7idPd/opKoIIW3v0wreaLTkAOhH0NWiv/y1NqlNlYcwRpT0KMU/fH3BOlQuvIE7W6fPa0ev+gkIV93f0lsjbQ/OwzQ4Yie976kt6w6aKCRA1mefMrBYeZtcg5FRR2Qq7NgHsXRQ41PXJWIuHP09mv0y/5mH+6PuipJiY4xg8BFcfZp4SnbOPbTkuTv+ytO8DKI+jhqLTujvrPg6QOCrKCCTJx
 PDMxlGUU
 70p0e7J1mylYlUfHJKZ33gf5m4w5fYVFfkiwUiHdO1VdKIPqLIjIO5ynPxwjNfdJ4gWJKNkBUO5C6VNcRFTyaVeJv79Tp4QFRoOf/yrz6fpt4FujWMdmzEuc4WLNbKrCveZQAy8/mlcQEXPp1ev0L/21WX3BWLG52JN14mqgKHrhdKKjxG2ApFxMGvcVkel3Ok3RPvl097g4E9ed1h8Md20acGfwiUheLba64slRh+hQXFF76vIVJFWF0PY0O4QgdcjvTQx+Jm9vuzHUS7fQ7OS0CGPk6mxNT96dpe9JmduSptUq+NlE/4cesQ2DU/tChrOWNl6V/AwSIvZ+Ca+rvMS/BlVyu3RmMPWa9cXnqrtB4mapCuofXxhvB5qlYbCCI2odG
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

