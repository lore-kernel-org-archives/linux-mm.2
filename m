Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8952CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86506B0098; Fri,  2 Oct 2026 20:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D8F6B0099; Fri,  2 Oct 2026 20:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99AC76B00AD; Fri,  2 Oct 2026 20:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC7F6B0098
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:33:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E86EFA78DF
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:23 +0000 (UTC)
X-FDA: 85279441086.09.6DCDBF7
Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	by imf15.hostedemail.com (Postfix) with ESMTP id 213FAA000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l0a+wyRECDVxATrZy6DhSpMephCWfVS2Xqsk5D8Ec5I=;
	b=bban04nEoBETPTYcDqR/fVMT3ZfSqb22BjB9YFmd398fNRWjLIwj7DOsfNroV9azSsx/qU
	jjaJ2G5cAoRvCsO7Xtg0n+iTqwH4UU3dpP+GW+YRfKTFyB8A7Ztrj4+jlU508lX+Cq2LZI
	XlJAC4Q1WyQO08/QjwiqCYAEhfn2J5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987602;
	b=cdkXhxG61OwYvyv39UeoNECquXWbwPBv965upH/0A3EnZs2IlXXpHpCylXV/3N4HXi1e7P
	bJOBngVWuSbXtd2YO0LcwmxatQtqtEjIxI0OYohMCqfBIGZQwCw/iWtJwKnjDqpYV0hPoZ
	7tYRBhqDOEiDGvG3EmyCxI0D8v3Jjgc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3df834e02bca565c;
	Sat, 03 Oct 2026 00:33:20 +0000
X-Mizu-Trace-ID: 3df834e02bca565c
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 14/14] mm, swap: let the command line set the xswap device size
Date: Sat,  3 Oct 2026 08:31:36 +0800
Message-ID: <20261003003136.750633-15-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9t4ezrh19dqc5ydkphpmz98en4gytzqd
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 213FAA000A
X-HE-Tag: 1790987601-651935
X-HE-Meta: U2FsdGVkX19REI5BEb2R1JPSA8mOgskfDRPuvOQBAORq3TMNzBoJs5aY4ezJybPizWOlUw4AXDfINx6swU3qwx+OSw/OfpP97ft0rWHYbot7iaK3cmI+kIEPzoLn5ge4ipOI9JTvGo5haFCbRrBwswnftSupWCV6pW0zgkiLfyQ1x7YdgehrYRITZB9juK3SUZwVt3jIlXaOnKIOqnysi3sPqHtml/wFZJGyKGc0/6JLUSC1RDGgy7EHBrUHDv8V3Qol3Sg7sAr/sl04hkmFhvF/ogDtSb3lfxsE2nLHhdpFDoiK/zYR4gKDbeAbyGdXzT1XZeVhgkZCuQhNk2Ho4+zLxO+MfnPA31hn4bTu8Hi5bsk605EyYdFStwfoVFH+9SXtGVC3P/ykDyGGbab8jFZ+8tZwDOgNF+d+B8G4sgCVWtI3MWwROiJUE5q6l8WJydMCmBs62ujuZtU+c28j1voJ51VuTLrTRfHEofGIHKB8RNr24b06UT03UVc7VfVNlXvWV9/iqQVp/9d0sC0xaSQZAFKMkiVzrnNcv29SPvtuDwLgsxrLlsbZ5AQGH9KE9AA1NY26g6n+yg+YMboD7nlUuaO8yujYb1uY1FyMT1AIboInDY66HLKkWeBo8znP7gjIhUQ0dQiNi9GAN6omvN44YW0AOOJCwOxAMra5xCzXjGEtq35jHaFfh1avzcxu2hcH2DRWd7QSBTrFHXjcwz/WrBjJPA7qa5iMwNJ/EiENB9aTHX+8XflMUnGuGOG2o+ofJL4AmQDmgVvjdMJf2HrIbFJYBMpfJ3Khb3RERRrkSqcHclr5Y9GPZYIbXgbpLDr0dd59C4AseFGbbZNm2y7bEkxppxc3Fw52xeaedjd9EZep6ofqwujaZic45CjrYEQyoSuec8deOcm1ep89DnmmqdWgQWRLawSbHI9o+HkKnmKM+EnU/HGxQwgRbXpI9YpKO94tN+4d9rOIizE
 +his4aLv
 RoXnb+HmfJK11aT76RLKUYrXDSshiZW/kZqQgLD0c8LknzDk0YF3ySFm2Q9VDeaYAp5SOq5qtkenEsC+fUG5BwXIUhJO7T+71POIm9UX8JjOqNm9u85ODw2DlhtvOUA855Uc91P2B8oH74T29vgAG/6O+KBklEim05dO/4MpGdjW+DJaHR8FGTNqhcqi9vjjSIWfekb7vZn2MuEyRWNRw6LkwqH/f3a6RkdUyTOAVSzIBW0CT4/phf0Y2pQlYDHmWBHRMTFvM6tHbp4GJGJiKkPsq1gAfCV+bK2Vwto8z56zF3B4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A new xswap device is always sized at twice RAM. Add xswap.max= to pick
the size of devices created after it:

  xswap.max=300%      three times RAM
  xswap.max=8G        eight GiB

Twice RAM is right for most users, but a machine with a lot of memory and
a small workingset gets a SwapTotal much larger than needed.

The size is resolved at device creation, not at parameter parsing: a
percentage is relative to RAM, and totalram_pages() is not ready that
early. A size that does not fit, or is too small to hold anything, is
refused, not clamped.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 86 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ab040d24bd2f..bf95663c2593 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -164,6 +164,63 @@ static struct attribute *xswap_attrs[] = {
 	NULL,
 };
 
+/* Size of a new device, from xswap.max=.  A percentage unless bytes is set. */
+static unsigned int xswap_size_pct = 200;
+static unsigned long xswap_size_bytes;
+
+static int __init xswap_max_setup(char *str)
+{
+	unsigned int pct;
+	char *end;
+
+	end = strchr(str, '%');
+	if (end) {
+		if (end[1]) {
+			pr_err("xswap: bad xswap.max=%s\n", str);
+			return 1;
+		}
+		*end = '\0';	/* writable copy, see parse_args() */
+		if (kstrtouint(str, 0, &pct) || !pct) {
+			pr_err("xswap: bad xswap.max=%s%%\n", str);
+			return 1;
+		}
+		xswap_size_pct = pct;
+		xswap_size_bytes = 0;
+		return 1;
+	}
+
+	xswap_size_bytes = memparse(str, &end);
+	if (*end || xswap_size_bytes < PAGE_SIZE) {
+		pr_err("xswap: bad xswap.max=%s\n", str);
+		xswap_size_bytes = 0;
+		return 1;
+	}
+	xswap_size_pct = 0;
+	return 1;
+}
+__setup("xswap.max=", xswap_max_setup);
+
+/* The most a device can address, whatever xswap.max= asked for. */
+static unsigned long xswap_size_limit(void)
+{
+	unsigned long limit = swapfile_maximum_size;
+
+	/* A cluster index is an unsigned int. */
+	if (limit / SWAPFILE_CLUSTER > UINT_MAX)
+		limit = (unsigned long)UINT_MAX * SWAPFILE_CLUSTER;
+
+	return limit;
+}
+
+static unsigned long xswap_size_pages(void)
+{
+	if (xswap_size_bytes)
+		return xswap_size_bytes >> PAGE_SHIFT;
+
+	return div_u64((unsigned long long)totalram_pages() * xswap_size_pct,
+		       100);
+}
+
 static const struct attribute_group xswap_attr_group = {
 	.attrs = xswap_attrs,
 };
@@ -4601,7 +4658,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 static int xswap_create(int prio)
 {
 	struct swap_info_struct *si;
-	unsigned long ram, maxpages;
+	unsigned long maxpages;
 	int error;
 
 	if (prio != DEF_XSWAP_PRIO &&
@@ -4612,6 +4669,23 @@ static int xswap_create(int prio)
 	if (!zswap_is_enabled())
 		return -EOPNOTSUPP;
 
+	/* Refuse rather than clamp: xswap.max= should give what was asked. */
+	maxpages = xswap_size_pages();
+	if (maxpages > xswap_size_limit()) {
+		pr_err("xswap: xswap.max is larger than the device can address\n");
+		return -EINVAL;
+	}
+	/*
+	 * Below one cluster the device is not cluster-aligned, so its only
+	 * cluster would hold slots past si->max.  Nothing masks those, and a
+	 * slot allocated there is past the end of the device: it can never be
+	 * read back or given up again.
+	 */
+	if (maxpages < SWAPFILE_CLUSTER) {
+		pr_err("xswap: xswap.max is smaller than one cluster\n");
+		return -EINVAL;
+	}
+
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -4619,16 +4693,8 @@ static int xswap_create(int prio)
 	INIT_WORK(&si->discard_work, swap_discard_work);
 	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
 
-	ram = totalram_pages();
-	maxpages = min_t(unsigned long, ram * 2, swapfile_maximum_size);
-	/* A cluster index is an unsigned int, so cap the cluster count. */
-	if (maxpages / SWAPFILE_CLUSTER > UINT_MAX)
-		maxpages = (unsigned long)UINT_MAX * SWAPFILE_CLUSTER;
 	/* Cluster-aligned, so no cluster holds a slot past si->max. */
-	if (maxpages > SWAPFILE_CLUSTER)
-		maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
-	if (maxpages < 2)
-		maxpages = 2;
+	maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
 
 	si->bdev = NULL;
 	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE;
-- 
2.54.0


