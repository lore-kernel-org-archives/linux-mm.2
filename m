Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFB4C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3682C6B00A4; Thu, 10 Sep 2026 10:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C0A6B00A3; Thu, 10 Sep 2026 10:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F446B00A5; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C13E06B00A3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12C21A0587
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:04 +0000 (UTC)
X-FDA: 85198059408.08.11A8788
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5D7B31C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZmGB171;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	b=6ehMzjwgaczyH62Zvghspdp+m0roZ4p3ERafnuzvkZV1NnCdTB1HsekqUc6bJa+1WjWntl
	VMEOOeZ5qUf0w9ZNQspmA7GyYxdrB1PSo3ByhFcDA6Ub/gP8FAIj/uOv9GVXRgJwFe7pI4
	hdiHz1OXwf3qmZAbml+6wu4n+U60Dmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049942;
	b=kaqu/UOzB5bbMUPdzYPHeVXoAx2/nyE7Mu10rHWDuDQmTd2DZcqQspEzRKKxuk6clNdRgO
	LkFkFPr0GFvAkSCRppawmGvKHnBwgPK/t8WqKjJUt7zj4rWkPY0AqXR+YMAUptqlmY5Nio
	XEgy73vIQdVKAHnH1ebUPw+fxjYTFUA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZmGB171;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE42843B1A;
	Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9501F00899;
	Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049941;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZmGB171Z8YtFpiMyv6D5GxB4EDZwCezzp+D6uct9Plsd8XSd0XAavCRhmEPsIQLn
	 FSrnIvak9wyOjMLczs70ISJMJ2ZgJ4/nya0ShwsKxx5TdvWFabSEPgUDI4BuNMirx5
	 klfl9h607/UrENPnEa8y4ft+oQ3FUHtB6Y7unzxNOZvqvhAIxO58wphDL3+suC9S37
	 OwRbNvWBRWcid7PK/Xh/xutRV6bjNycuyFeHBWU+bjRIDuLyEjXFcmpwfcfiEenEN/
	 1W/qJK1uBX3BIexhGr6xI3LwY0ULqB37eZJT1b7qJLGrN/KEM6Crcw00lOixOlsDVq
	 glMPiN9V0ehNw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to range_{min,max}
Date: Thu, 10 Sep 2026 07:18:44 -0700
Message-ID: <20260910141849.170896-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910141849.170896-1-sj@kernel.org>
References: <20260910141849.170896-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gjjxykibsotf7ju5isnwd8u8jwtj6ios
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D7B31C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789049942-659975
X-HE-Meta: U2FsdGVkX18xI3RT5//7N+JnhOS8m3cnsu+uynpcBYS8zYfcmZ4xatzypTdEwUaoBesz0Yrs3I0N68DUlNtZRKQpM14vFE0kIiT3hU6qRa+mnRnuRCzDU/ZKOmFd21FIZRi2EJ0ox0QuXAIR8HO20DMIpFXxqbBlX7mBVJyxzoImhgeDUsQELH2+gB/QlSQa6KeFzgm+ekewjsytSSCLKVfaLZd/vgincha6vPgXgjlF/cKLv2k8dwyebJKdd9h/aAJ2h6SXEFpVNWwkKEQObo7X7Azr2ioi6s1Ha0uPvN4EjBLoDAzvQtAPRK6BxADmWmJKp1/DHvDdMn4tpz/lVsMJWvf9ROovgwPC9qNIjhKMryH2QoXnM2O3emdIrhX+e7xSWLEAVm98k+ohEpl6qf/rLQYGF8fLZqJyoTQ++n6cEi/lu1aINoRzaKry/ydKXj728jj8GNFqTttNI90erndLeuleC/SLTX45DBsHtYIQhEzl0Q+bFsFGhqsSFhUAg/dJuuoJ5oW1WIP1jyDbz27DlWyJXwEkLwj0DCLEpDIdPc9dF+T6luLzdjNfNxBWLilW53G/6RZxkA0esvH3mawp48aNK+MPHHtMfzlqXCAN5eE+DaW4TrZRS9iftzHT6Dtxcp4AR8vIjMyIEmffc1lDqvwWfCD0ZAGH5lBGEg4BmCXCmE/fn6VFMyIge7RZHyzsC80DFtCG2s1oeTuDzVbznlgxfE0Iv8W8deDCI7wpi1oRwnTYvjL8T54GaNN6cdIyVBxu+xbE3hURiJhXqsXV/5KrBxqw5Gykev4AP77Z46UjNci9So1Id+tS2MFOvCXw4pnefhnl6eF/iUzkMOtkZ87Nl2Uia+PE6uEdySxaU5zyJ7iOY9y0olm42KG9gXwdjkGR3VRMlBFsVdfhPmpGxHkO/FkJ8SUEf0/PHW9naloLdMnhT98cSZGl13zWS6XXse3remCBnP4iOPW
 uiuchY4S
 Mi1O38B1LKtW4Z8yn8Gs8zB+LWqYwWOKKgeyFJV1ywilXWNZbYbVRfsuM48a1SU3r5bviLypLheydbphfcxh8oTWtNGL+y8aSbtXQ/Lqjx3jSxGPIgALqzrd6v1J5MG2BRIeMaey/WJiK8UnAyT/ahNVF+46/6jFEjfoUKfzVFNiHtExUJQVauAqUp/TRDGSkaXSvc1n9asH2pIZXGbhBvBQivmBL+OBhMxBpwmDctDsvvms6MfkdtrRx6iiNg8d0cdn85LrUVTnTt+Nek6z5zL27wA==
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

