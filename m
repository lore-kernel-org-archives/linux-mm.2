Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC410C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42FA16B0095; Thu, 10 Sep 2026 21:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8EB6B0096; Thu, 10 Sep 2026 21:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2334C6B0098; Thu, 10 Sep 2026 21:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D840E6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30F3180674
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:42 +0000 (UTC)
X-FDA: 85199709084.03.A718866
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B29B2000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZ+hOY1s;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789089220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	b=AhwGiRu7FD6EzlbND2nY1fy8j2QGvuV+FW7sOxMMcNDrXYekPcociOEQNlU7nmoSYm2cmG
	epXEwK+eo62uePmbNt1kk2QvA6oRhBEHl3nX2IJNMOiY4cvR4Yr91Jvcdnp/6INgkcEqJq
	QjnQi8ag1kurS+zRXpD6qcBs+x8RxBk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789089220;
	b=JjlpbRaGSGd7fIb/ad5KhS7gA/OXZYSJfdoVu5ejyIBkFobWKqyiqihMCoKok76S3wrIaf
	w2MKnMezk/hKPwMlZABrE+lMmmA2CyjICTlFcJLLG1NTw87QsjQ5uVVq/M+Ykbde8DioD1
	juJ/DvSeZG1ZVyolk9hJ96Qdmdly7Pw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZ+hOY1s;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C88B76020A;
	Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5359D1F0089B;
	Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089219;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZ+hOY1snr3ywtyWN0AfsKVlu1LNXjLbLvxNq9Zvwgrz7CZ1i182/WQVAYPeiIdQD
	 8pGjmZa9C1HYvZQZM4U3NG77A+SGZboGxATVR30z6xGauKG63vS0KC15NogQcJ6Pv0
	 WNuQYZUwPfVjlVYgCYdzJqcPaPAfqlctN9yb6HS0AIyTsA3smj5XN9RkN+8aPhwO7O
	 rojiyDHiSt/EhD0svJ0DP9fQ7aPWLo9cVQf/0PttVpu9xNi2S+WnWwUnbN/3Oq2Zzz
	 ijBuFMBYA5R1qO8RJXg83hO+mWheZTNvK8GbNgHxHSANQRWleNLTnQmHRrDk0W+oR1
	 43xoXhLB2r5kg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 4/7] mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to range_{min,max}
Date: Thu, 10 Sep 2026 18:13:25 -0700
Message-ID: <20260911011330.93678-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911011330.93678-1-sj@kernel.org>
References: <20260911011330.93678-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7a3j8cwpbpjq6g7mz1wc9zjmhp5dg7tz
X-Rspamd-Queue-Id: 3B29B2000F
X-HE-Tag: 1789089220-202761
X-HE-Meta: U2FsdGVkX19ctkDmtGv3S+efHMfX2bRR24BDKnURkPlDf2tfIr7dUcRVomXjgRyV3Rrv5Nh7fQ6n4BCTG0wddANDZI11UpsqXIAFIJ3winbuTMdXQR1BYH8fFGix2U/yKfjSA1UGVNq+oJ3o+uJXCfsa43gR2LpJ4P00dUgjKFK1M4WixK5IzOg/c4/e+ANjPUg0HZbBO3y3DMIJJKOWiRdFnuFgH22s4XrmeVR366VV6rThxNg67JvHhS2xZQuK3m4/DyzzSYqLqZBjrOcn/NSfJCMKduHSvIUmGDyxJFI3yKRDMmmp4Di1aicxigkKrT4FdjhMIyoKtDTHGnf4eJn6La6BN/Jx0JHfpXbE24Y52pkrSrENWCvz07Ff0Q6s/ayBG0swS7jBN3apqHANdEUtaWGnTM6XuzcLBMRZ6hIYho1xeuouFBQDaiPERO4em4c3fyUjxIiALUEDVeX7T/xw15pgjl1S74vbPp1zmgJLjXw0IFUai2RYZFZDlRq0crRMBsR0QYW9ZGadt8Ho1z1xRxllXZRYcNbzd2rl7uiO82nhPk35VvM1b0z16o1lu7gnKjmfxfzaZ2VTZ+a+3oRKyOs6/f2oqHeobIKhPqXkb7wzWL6o6l8ftCM+Z5d/ICXYReGoEnhTEUCvMrW3YzEXHJxEo4p3ScZUKetY7ipUTEe1g2S12brxUfaWb3Ry+Je9FDqOwKVFi9MqbNvRObAClxjdM0M5uVRNUFGm7Rvy9uzC2WRNEvgkf6O7Fo2NQNnO2G2qNRgXcYEBlIvr1+onRL51fo9QlfLA113+YncuqGdM6PXgqN80trnMe6zMSyEM5BukpGjfUp+/sqPFSz/l4Rp7TmaORVIVzupY7lGWWHkE4BGN0e1wcIT7DxwufBNSVjYJbEYxXc53gh2REPOb0VDVzre2Sml7lEhFPREWVmifxc6Evuk3KBPpw8JouJwCzdae/KyPO0DpD/L
 vzHR6Koo
 DC72cH3aNza8emaFOLW4b5uEPK5S6kILXGMt1HmdDvBGou4bngMrl4Fnfnq8O05PkONV5sTWnjOHMZ25T9xnEryo0xA2q1uGFbnzVieQtl+fJ4ZGjxFBZ2VIoNKy7nlxnK+mrWojfzK71mGrOGNA9oOn6yKyBqKEw9RCIEuyfxFC3kXyAhTlTJYLUEzaoCETBGTjjBuFSWvP8IZNAa0525X4n0RC28H7S1lJjo7H68PXB4EuQkclIuA86O8wxrcbszTlqUoTd4kHqA7D/giv3Z6WKlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface provides 'min' and 'max' files under the DAMOS
filter directory.  The purpose is setting the general range arguments
for hugepage_size like filters that require range arguments.  So far,
hugepage_size was the only filter using it.  Hence sz_range field of
damon_sysfs_scheme_filter struct was connected to the files.

In future, we could add a new filter that can reuse the 'min' and 'max'
files.  And the filter might use a range of a type that is not size. For
example, probe_hits weighted sum.  In this case, simply reusing the
sz_range field would make it a little confusing.  Rename sz_range to
range_{min,max} to avoid such confusion.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index d9b81d7b5910e..4d9147d2a269e 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -534,7 +534,8 @@ struct damon_sysfs_scheme_filter {
 	bool allow;
 	char *memcg_path;
 	struct damon_addr_range addr_range;
-	struct damon_size_range sz_range;
+	unsigned long range_min;
+	unsigned long range_max;
 	int target_idx;
 };
 
@@ -588,6 +589,7 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_TARGET,
 		.name = "target",
 	},
+
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -778,7 +780,7 @@ static ssize_t min_show(struct kobject *kobj,
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
 
-	return sysfs_emit(buf, "%lu\n", filter->sz_range.min);
+	return sysfs_emit(buf, "%lu\n", filter->range_min);
 }
 
 static ssize_t min_store(struct kobject *kobj,
@@ -786,7 +788,7 @@ static ssize_t min_store(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	int err = kstrtoul(buf, 0, &filter->sz_range.min);
+	int err = kstrtoul(buf, 0, &filter->range_min);
 
 	return err ? err : count;
 }
@@ -797,7 +799,7 @@ static ssize_t max_show(struct kobject *kobj,
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
 
-	return sysfs_emit(buf, "%lu\n", filter->sz_range.max);
+	return sysfs_emit(buf, "%lu\n", filter->range_max);
 }
 
 static ssize_t max_store(struct kobject *kobj,
@@ -805,7 +807,7 @@ static ssize_t max_store(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	int err = kstrtoul(buf, 0, &filter->sz_range.max);
+	int err = kstrtoul(buf, 0, &filter->range_max);
 
 	return err ? err : count;
 }
@@ -2835,12 +2837,13 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->sz_range.min >
-					sysfs_filter->sz_range.max) {
+			if (sysfs_filter->range_min >
+					sysfs_filter->range_max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range = sysfs_filter->sz_range;
+			filter->sz_range.min = sysfs_filter->range_min;
+			filter->sz_range.max = sysfs_filter->range_max;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

