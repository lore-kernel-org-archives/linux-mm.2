Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D3BFF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707956B009F; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F46F6B00A1; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448526B00A3; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20CDE6B00A2
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E29FB1B821B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
X-FDA: 84701905722.25.5AA8D26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44F8CA0008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NH9APUYW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6B6aapufCswd2Ibc0iPkA4Nn5dMSrgat7o7QxerHjo=;
	b=kBijGoruwSRa3ODN6KKI30xQSoGN9c6O3XjAOZDjsJJ7rGelu9pjSBUgdPeKygOgj6X18w
	b0i/c1fms5ealETb9Yv9GubptV3AOSyb6+O6lCbLjbFYEEXmZzQRtmf2dTjRAdBCWs/Vmu
	2UwbEbKrBCxCzjB9S7axgFXky4qS38k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236760; a=rsa-sha256;
	cv=none;
	b=mGe6evKwZlKPblk+n+JlOqumSyyDHhoO62INjbXVyTOFk4p1/AE6W9SY1RpoUB4kAjmTUR
	5F/hECoMjxAKWCHRVk1sA85Bc3JYB/ZSiWyBMXKhAEHqBL8+h+sd5au46eC0ztTvJ8AKf5
	1QxRJHgH/TsCngB24MHTt9WzMDqhsE8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NH9APUYW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E14D744708;
	Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970B4C2BCF4;
	Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236759;
	bh=n8NHvN0HAPPSe4MQZU6Swveu54v2WkmDhfNoQjsKaCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NH9APUYWZFrbBawnXc54h5wO3jk22Ljsb8FDaKjTPE4XtsmgvJsPZWYjK7R+cE1oC
	 9E4cSDT7r3TU0S8msSsBt0coiwCm78j4lonit803zJjWXwVgLf45ncS0frVteVeilU
	 3WllJgUzE9vksddpywRtfMEM77ScUhUc47u7VmPm3zEfNx2QbIEUqb3Q9CPvxuVwzX
	 H1hGcCSB63BG32JEsucHLoiInOAUEn25GLjBFF8Tz7a+67ib7WNeuxBTIEnmPiyjZn
	 16wEiGIygzm+g9iwxzJ5M89VcwKnk0j0qEGYqAKxQt/MYgMYJVMKqB1tFNg+Ievn5A
	 bFup5naqx51XQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 15/19] mm/damon/sysfs-schemes: implement tried_region/probe_hits file
Date: Sun, 26 Apr 2026 13:52:16 -0700
Message-ID: <20260426205222.93895-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 44F8CA0008
X-Rspamd-Server: rspam04
X-Stat-Signature: a7i6p184ytq7w7roqxht8ib85fmzrce8
X-HE-Tag: 1777236760-849161
X-HE-Meta: U2FsdGVkX18WXcnPEiK3LAWLrnlU3mzfiX4KMOwqiaGD2rPdIu+tSts2BTqjjDR2+BCM8hzmexx7qsLply6u15G6fTcuNHUu9QwmpobQKN80tW59+llpFJV4wr/rB0A/HHazDzoPbgbVUB8bNB0DvZZ9lL+xySj0Kf66r808Iweted2GpaJlDLgurUHJFD8JDAQ5KCPoETA/kMwFtw0UdTOgCGADUXaamQ7kWayM31FHz/T0JD03ncV/JVHS2U8U7BpH80x5IjzfB23prvlpAoWJoWaOGiWYqbJqrdQAAME6vPcO8TytYb16Zd0ANOWyebXdwxHVEoBBrUEtB4GhOI+dAvBXYVDlSMpM9jL5BcndV8zS6hbtxpewoY1WUHhBa+Z/d112BCLccXFv5Y/c8m+yT/G7BIvsHbJkTAtay9Q8deXChbSyRuTZcI0qmpfkf9JJbvOqSkStvoPejGGhAIqqkYmraEbtdJHxJg85jMcgjsxXeph+cpl4LwtkhMBkQf1tagwAVCa6CopZmsPAI7+8X/CkY9XYF9rYhbs4TiK9YXUQJM3JZnhwS71QLGvBLZnLN473/Shp5AZHyLwxUB/ZPe2uAaxFhaTAn8BetcS4/Y+LpehKtosmGit77NAg8SaVgM/HzrZIsPJbPR9zaIsIPyAlM4BmR8+H10mzAMVJTrNI6OoMA/QWwc7dwAAjULLrNzmecHN1GiOQ4FlzA+5sNbCBAA/AUqAVBl8uA5n2CtwVs0EmZHTsktQuac+JzpQKtbsMwmG/UOsUWiuEtltXYWcFZdC9JIqId1F+X6jmrjnzdxyXysuQtRl5UuAZp1myXDmmoCX/6Zjpcw+EflQTLJzM6GTsEEW1fHpkjcrkvWnbijKKTYlu4HkPgHBBSJHak3SvHsyloWiHnWqK+tUMx6TH6gapQar0uSAdhsx2GzHEUEcmfVNUkkT8cJijCb7GUVWvGvpy4xzJ119
 TBJNDC21
 Dxsqz7/uMnXwrZsWys1xtcj1+fZY9zfy6NaXbqKDdtNo2VoUuUYevFwj+Rx7VkfH+QutaSLO2HqLCgXg9SaZGcUvPElM1Lw1iV8QgmXoKGhdl8KOzSx07E7H74fmWUbPbbq+CRu7ZmMZX09D2b4LRAjOuQXfwSUa/M2N6ykNQBhn5mBqTw98K/BePpXNClFvsPdwQ3u1d4LWLlzuvHub3GeVAGNrAmLelcGXtQQ/NKBp2Crxjqg3RJGfvOgzFlxpICIaWDt26GqQevkV7G8sG/2aEFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a file for letting users read the per-region per-probe
positive samples count.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index c3c1ff6108863..48a949484a052 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -20,6 +20,7 @@ struct damon_sysfs_scheme_region {
 	unsigned int nr_accesses;
 	unsigned int age;
 	unsigned long sz_filter_passed;
+	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 };
 
@@ -34,6 +35,9 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 	sysfs_region->ar = region->ar;
 	sysfs_region->nr_accesses = region->nr_accesses_bp / 10000;
 	sysfs_region->age = region->age;
+	memcpy(sysfs_region->probe_hits, region->probe_hits,
+			sizeof(*sysfs_region->probe_hits) *
+			ARRAY_SIZE(sysfs_region->probe_hits));
 	INIT_LIST_HEAD(&sysfs_region->list);
 	return sysfs_region;
 }
@@ -83,6 +87,28 @@ static ssize_t sz_filter_passed_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%lu\n", region->sz_filter_passed);
 }
 
+static ssize_t probe_hits_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_region *region = container_of(kobj,
+			struct damon_sysfs_scheme_region, kobj);
+	char *str;
+	int ret, i;
+
+	str = kcalloc(2048, sizeof(*str), GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+	for (i = 0; i < DAMON_MAX_PROBES; i++) {
+		snprintf(&str[strlen(str)], 2048 - strlen(str), "%hhu",
+				region->probe_hits[i]);
+		if (i < DAMON_MAX_PROBES - 1)
+			snprintf(&str[strlen(str)], 2048 - strlen(str), ",");
+	}
+	ret = sysfs_emit(buf, "%s\n", str);
+	kfree(str);
+	return ret;
+}
+
 static void damon_sysfs_scheme_region_release(struct kobject *kobj)
 {
 	struct damon_sysfs_scheme_region *region = container_of(kobj,
@@ -107,12 +133,16 @@ static struct kobj_attribute damon_sysfs_scheme_region_age_attr =
 static struct kobj_attribute damon_sysfs_scheme_region_sz_filter_passed_attr =
 		__ATTR_RO_MODE(sz_filter_passed, 0400);
 
+static struct kobj_attribute damon_sysfs_scheme_region_probe_hits_attr =
+		__ATTR_RO_MODE(probe_hits, 0400);
+
 static struct attribute *damon_sysfs_scheme_region_attrs[] = {
 	&damon_sysfs_scheme_region_start_attr.attr,
 	&damon_sysfs_scheme_region_end_attr.attr,
 	&damon_sysfs_scheme_region_nr_accesses_attr.attr,
 	&damon_sysfs_scheme_region_age_attr.attr,
 	&damon_sysfs_scheme_region_sz_filter_passed_attr.attr,
+	&damon_sysfs_scheme_region_probe_hits_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_region);
-- 
2.47.3

