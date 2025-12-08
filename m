Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68F5D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB766B002B; Mon,  8 Dec 2025 01:30:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00186B002C; Mon,  8 Dec 2025 01:30:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0FF6B002D; Mon,  8 Dec 2025 01:30:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8656B002B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B09A1A0972
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:20 +0000 (UTC)
X-FDA: 84195329400.24.06B3AF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9DB9C0002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBamaiLI;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175418; a=rsa-sha256;
	cv=none;
	b=HKdzX9/bnEnridxTU6ogwmGA6GSSBUYTGdyGBruH6jUlDsr+/4+dsqncOAn9nT+CBQnMky
	CJi7AwTlksWhg32YRS0zhhOO5ztkquVbZUR0ygaF8TdCUcSMws6KH5yuC9sEAX5QmJoVhq
	rLcXeLzIzk7SqM3vPCrhQkiSS4Cm4E0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBamaiLI;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06MRJO3UNi53n+yedi4NsIAIrXh5lFhqe6c7PvqCgWY=;
	b=QLLc2o9IECdau4SM6+8gWClXb4xN0H+jAaHuX64dHoNhEVxuhA2o861sTRFPRniDjOb7H4
	t1eIVuSPJQT7Ls0KyXUb3my8Po05ElpdtAmYNzXE0zniqUMsfqNh5ZlkkrY2d2XfDgH/9z
	OPLaJ7LtchYAoRDS4tepW9kFA8rWFLw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 168956013F;
	Mon,  8 Dec 2025 06:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7B3C4CEF1;
	Mon,  8 Dec 2025 06:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175417;
	bh=R9m1eSl/V//tH4nv+68KXrctOAqXsKHuChO2fV0643Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBamaiLINXILpgvGkgCQPbnTIHWtwp2rObqcA/i3cCRUkLuYOUTyDUBNU0lqHPqWJ
	 gVbtbaaGI3dPObeMnBCW58NnnqLc707Oiqa7T8R3biwJ9nF94DTs0P6XVf6hOPpLQF
	 l1+UpWH3GBSnC0/rp1YEGAABhen7ltyKK3nHuk42tlZDfVzhbzsIWfG1pTwjDTW3pK
	 gmRChhrcxN7V406wIiciL5N7BlFleI+z6LkmuU00RUgoAr8vXhBFf6XLE0I6VadldR
	 X+di5Q5FhDiFvn5zl+dLDLPKZDnzLSJRp0shJ6RhRJ02fowl7VGccZra1NDAEqaNg9
	 DCh5eL0wV/IPQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 19/37] mm/damon/sysfs: implement sample/filters/ directory
Date: Sun,  7 Dec 2025 22:29:23 -0800
Message-ID: <20251208062943.68824-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9DB9C0002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: wypupt7p4bdxq77y6s1k4qjnybsn71f7
X-HE-Tag: 1765175418-995039
X-HE-Meta: U2FsdGVkX189q0ANz7Gr3K2iZZdSyFguhEcBFxdBJ2C6SCLBL1IyGJM38yRb7IFbvsMNjkT5RIT09fNBeZwLKH2pCYKyoAIIVx5rasmlE7ecpY5BnYJUoFUyeNfV0dnazBVeQih1CylfONb95LF2PWbVIogdw7yCom6PxKaNDuyfSu5LolB2VgFIQTNAHT/PJ4zKKt9i1Zn3E1By7lHSTWVonLcuwki1ObFzEXDCiNB1I4lD2q/eOo2AFUWYWfRQ1zdiD07IVZ5h6a7zJXCNz6j1RroPhx18PPlMZCOCj4Tn+B2Ii3HHh4DekdS4uYnEwI+bnpC8+HEbgWM8VcilJG1gqnrEdW3dSbxzQTRQxKrLyz54541EYdAgRVzpmX7+pExBcK/SotF7Xjcf9G5pfaz3kXIVBiotigSOkXdm1ndiab6xcUAsrsZTMyC0HZ10ambqvBYYu6VYln2joZCnZnFCdok8Xkfu3sEe34bimkI63WadaARIi//4AFDnT91MCdeACjCGipvlMAzcZR6ce2L3kwi1vAbbXE8CK3EaXIgkFX+CGmQoEEZBs9ryx+3uqif6GzrKd6usRdKaesLCIXQlN1ljDetQfA6sBNzS0XU9SqbyNH3uCe07JJzpcuHT5f2bs+innHXzjK3dKqW9WVTAJVchzfZ7H87BQ6U0GEX6tGGFuqWwh7pdJOQ98q7QvvxsA12/jiM4U0qzjHH80CkledONUFYF6n+XCHb6XB+CIGY6+Z16BY7Lcp1jSozruLb7bltJEKYuIXDc23Rtk1x22Dh1hvy+ReHEIu75Jod93Zvl7lJYCtU3KGHE7eIg2uudMaizmSPa7H/8xnRs1bKu9UMCFF3eZTiSBc/igDFq+xSGaGgzGF6Woe9bSnEqas4WWw66EPuuLZonrpm23OSibpvyakX1WXJIUizXj4Qz5t7Y6h6fvfLAOdVhN/eusZPJNykIsTS3eXZHuGP
 B83inuE4
 pYUdHP2qgTaGdvGfQQltL0jRE1d6nAh92iNzomi43Fn0mGjhQbhuiaYp32qZQNTVHJs2fttnXwK/+Kozt6D9kIN5SAepVWf+ibXPG2L50J+NpKxdRXTzypd0C2fUmYwy4oMS/LzCPqxziKLHr9hh74jRoG9WqwO2ZQre91Y1ka+JUKPnOSwjHt0G6BHEzEkpkhonmatCRDHVK5d7VFO+PK58y3V5FuvKKv86oDUs8e9/bl4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a directory for letting DAMON ABI users install and uninstall DAMON
sample filters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 16d58cde03e8..4208fed2b8df 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -749,6 +749,36 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * access check report filters directory
+ */
+
+struct damon_sysfs_sample_filters {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_sample_filters *
+damon_sysfs_sample_filters_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_sample_filters), GFP_KERNEL);
+}
+
+static void damon_sysfs_sample_filters_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_sample_filters, kobj));
+}
+
+static struct attribute *damon_sysfs_sample_filters_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_sample_filters);
+
+static const struct kobj_type damon_sysfs_sample_filters_ktype = {
+	.release = damon_sysfs_sample_filters_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_sample_filters_groups,
+};
+
 /*
  * access check primitives directory
  */
@@ -854,6 +884,7 @@ static const struct kobj_type damon_sysfs_primitives_ktype = {
 struct damon_sysfs_sample {
 	struct kobject kobj;
 	struct damon_sysfs_primitives *primitives;
+	struct damon_sysfs_sample_filters *filters;
 };
 
 static struct damon_sysfs_sample *damon_sysfs_sample_alloc(void)
@@ -871,6 +902,7 @@ static int damon_sysfs_sample_add_dirs(
 		struct damon_sysfs_sample *sample)
 {
 	struct damon_sysfs_primitives *primitives;
+	struct damon_sysfs_sample_filters *filters;
 	int err;
 
 	primitives = damon_sysfs_primitives_alloc(true, false);
@@ -883,6 +915,19 @@ static int damon_sysfs_sample_add_dirs(
 		goto put_primitives_out;
 	sample->primitives = primitives;
 
+	filters = damon_sysfs_sample_filters_alloc();
+	if (!filters)
+		return -ENOMEM;
+	err = kobject_init_and_add(&filters->kobj,
+			&damon_sysfs_sample_filters_ktype, &sample->kobj,
+			"filters");
+	if (err)
+		goto put_filters_out;
+	sample->filters = filters;
+	return 0;
+put_filters_out:
+	kobject_put(&filters->kobj);
+	sample->filters = NULL;
 put_primitives_out:
 	kobject_put(&primitives->kobj);
 	sample->primitives = NULL;
@@ -894,6 +939,9 @@ static void damon_sysfs_sample_rm_dirs(
 {
 	if (sample->primitives)
 		kobject_put(&sample->primitives->kobj);
+	if (sample->filters) {
+		kobject_put(&sample->filters->kobj);
+	}
 }
 
 static void damon_sysfs_sample_release(struct kobject *kobj)
-- 
2.47.3

