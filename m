Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC2EFC53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B096B6B00A2; Mon, 27 Jul 2026 05:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA576B00A4; Mon, 27 Jul 2026 05:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9246B00A5; Mon, 27 Jul 2026 05:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFD56B00A2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:55:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D96451C0E46
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:54:59 +0000 (UTC)
X-FDA: 85034097918.03.9B688D2
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2ABD9160007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:54:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pu+k9Hkn;
	spf=pass (imf08.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785146098;
	b=BoVy/DXe89b1R4d0jIu5o3Pk+1k0+5tT+YG5V5LWBHxq/nKhXo1LvsgxXhXsMgf6MVasFl
	MJgoIeYZrjb77mqKlkfpXJIJ58qTXIrgZA3aEk6WJOo7fH5Z8yerIvsdjoSJCn1JhgdypH
	tsQqrH30PfwV5HMvsuVQu3mLXdma7Xk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pu+k9Hkn;
	spf=pass (imf08.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785146098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FgYVRL1tlXQScTSC3dysRI0YQkKByHkMOxweBGBsepM=;
	b=IAI9dFIEni8Ly+iqMSTNvwHaTPLAHoL8EoZ1V5zRKzju3BC9ToC1F2KHKKdQCb9zt9Nzr9
	zvUUzpvKm77OvuF8rQL2+U3oQO64VNXZGlrXPtqnHsSvqHTyjy1w+OB4dVMjL9ZfPliPit
	jlDiQK0AoeVjHXthgKgVwdHDWZvg/EU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785146095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FgYVRL1tlXQScTSC3dysRI0YQkKByHkMOxweBGBsepM=;
	b=Pu+k9HknezyVEwEXvqKoksxaMAHsADHucnYz8DJ26j7yYxOB1esAumkh/Ph9j3igBv82FQ
	OolxG26WW9AzUc2RLVk40iWO1Oh5J2bN+cWwEyWiEMIN+qvt5LrbMa0tbKOJzOZIRW/DhW
	I6ZjLElXBXFDMZXcpKDGm2jqAydhG4Q=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/2] mm/damon/core: cover discrete System RAM areas with per-range regions
Date: Mon, 27 Jul 2026 17:54:22 +0800
Message-ID: <20260727095429.143527-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2ABD9160007
X-Stat-Signature: z7m84ifbz5aboo14a8c7ax88r5acmgu3
X-Rspam-User: 
X-HE-Tag: 1785146098-64581
X-HE-Meta: U2FsdGVkX1+8B1Cam70aD674vz6jouWAqcMYQDeGppIX3aurqzdFUEzk12dHYhsFQDixbPoiUmZJXg/MzRd5V9XgCfhegEAKg4f2JPaT6P6I+wrTVn1pV9X207/dzWQtKIbHjy5qsU309br+YjDWaJatZ0qYW1s8u2clR2K1Sl7R+fKFyFXKyPCGdxnZOjEqO0WrabXi+y/XkkKTf9jIYdrPbbNgWTZZQXDhP8pnldkRF0U3VL2vlXq3H3DfA6R9cwDYqT+LaeL9tZXG+vGDI8luegVEfIbd9JB37pRPmEdZu7TeyopL8X+BN7MTx47Pan0MBy+H3doZHWJ7IwNNA9LsRE3CPLYeyURxrLM8MHCfozosvy4iYa6+wanwB1k1RcB82RaOR/NvMGZ5mdsMCYSSkyVDkajX3yQKwaHZcHrnSDlLI11EolZ8IlMbGnvZbsfgu1oO5YS9rMlXjD8UN699anqeNNPhE3xsLm4UJPk+ur75/V5WzZMURM8+3f71g2Ql6xwq7PPyLEQYTrGX7yuIZDIxG2KJ7C9Hhaf9g6ze8fATUXDLfokLUP0UWPyv7L71C7RFgRJOonFRoI3ghJGK45pqGnqEf0RlfaAtH4mLKa5F6v0hp2rXOfMdjgxeYHd5fDeJW79je5aHUs8vntJiEO634QDXVHkEMr68IhJI5JEorgg06Tscyp3B5Cwi5wLC2Iv9q6Bp9U267JWr+pGk9c3EMqq6febPg2b2hsSFPNCguWosHrcMC0eS2oxcwnB+m5hGPhKnBC+J3XRwUQQLyevBZW7btk7edKtjeZ/VW13oqIwRAQvelN859++iNfphJMT5PWkXRoZiWwFdIlbrOnpcMWLRkSrmUlZKYkHpwRNXPEjGT6CTatEweI5Z4PE29Kp3KEwoQtNpe2/fe9rqAlY/McfujhOGbtgKiDRQbc5mZBTNFbiQUYv8xZpc5CmW8PaeC7wS50kYOYV
 ok5CqpHl
 WDolljaEPi+G6sdDkCHrdm8WPcOvK7v8XJJLhiQAyh+5p4eahihyAH6hWjuhT/H0TLstQSftAuU87YrYUy/JMAATxlurnSTRdz6KmqunXRm5as6M/nM1xcxQ+datb7teu1AAPtPPtOt3adpyoV42lnDh1WdCiHSHmnXb9MCNPaooiGJ1xS3lGasMvU4Z+JkQeB0WXiDav8m8hG7MbKD2ZbrJanohGOAQNSUdxh8WwmjVmoCBZ16n/JLS1J7pm0RX2jzf0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

damon_set_region_system_rams_default(), introduced by commit 70d8797c15d6
("mm/damon: introduce damon_set_region_system_rams_default()"), is used by
DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT to set the default monitoring
target address range covering all 'System RAM' when the user does not
specify a range.  It walks the 'System RAM' resources but keeps only the
start of the first resource and the end of the last one, and then sets a
single monitoring region spanning that whole [first_start, last_end] range.

On systems whose RAM is split into discrete areas that are far apart in the
physical address space, that single region also covers the holes between
them.  For example:

  $ sudo cat /proc/iomem | grep RAM
  00001000-0009ffff : System RAM
  00100000-4848c017 : System RAM
  4848c018-48550c57 : System RAM
  48550c58-48551017 : System RAM
  48551018-48615c57 : System RAM
  48615c58-48616017 : System RAM
  48616018-486dac57 : System RAM
  486dac58-4e563017 : System RAM
  4e563018-4e627c57 : System RAM
  4e627c58-4ef39017 : System RAM
  4ef39018-4ef3f057 : System RAM
  4ef3f058-4efe6017 : System RAM
  4efe6018-4efec057 : System RAM
  4efec058-50247fff : System RAM
  50317000-56720fff : System RAM
  56722000-59c19fff : System RAM
  6bbfe000-6bbfefff : System RAM
  6bc00000-777fffff : System RAM
  100000000-1007effffff : System RAM
  67e80000000-77e7fffffff : System RAM

Here the last two areas (about 1TB starting at 4GiB, and about 1.1TB
starting at ~6.5TB) are separated by a ~5.5TB hole, and the single-region
setup makes DAMON treat that entire hole as if it were memory.

This is harmful in a few ways.  The monitoring target regions are limited
by max_nr_regions, so regions that fall into the hole waste that budget and
leave fewer regions for the real RAM, coarsening the adaptive regions and
degrading the monitoring accuracy.  In addition, DAMOS actions on the paddr
operations set walk such a region page by page, so a region that covers the
hole is walked for its entire (empty) span on every application.

Set a separate monitoring region for each discrete System RAM area instead,
coalescing only truly adjacent (no gap in between) resources into one
range, so holes between the areas are excluded.  The reported *start and
*end still carry the overall first-start and last-end, so the user-visible
default range reported via the module parameters is unchanged.

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/damon/core.c | 116 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 82 insertions(+), 34 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 760559d495b3..8dd4a0d22064 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -4394,22 +4394,14 @@ static int kdamond_fn(void *data)
 }
 
 struct damon_system_ram_range_walk_arg {
-	bool walked;
-	struct resource res;
+	unsigned long addr_unit;
+	/* NULL in the counting-only pass */
+	struct damon_addr_range *ranges;
+	unsigned int nr_ranges;
+	unsigned long prev_end;
+	bool has_prev;
 };
 
-static int damon_system_ram_walk_fn(struct resource *res, void *arg)
-{
-	struct damon_system_ram_range_walk_arg *a = arg;
-
-	if (!a->walked) {
-		a->walked = true;
-		a->res.start = res->start;
-	}
-	a->res.end = res->end;
-	return 0;
-}
-
 static unsigned long damon_res_to_core_addr(resource_size_t ra,
 		unsigned long addr_unit)
 {
@@ -4423,23 +4415,66 @@ static unsigned long damon_res_to_core_addr(resource_size_t ra,
 	return ra / addr_unit;
 }
 
-static bool damon_find_system_rams_range(unsigned long *start,
-		unsigned long *end, unsigned long addr_unit)
+static int damon_system_ram_walk_fn(struct resource *res, void *arg)
+{
+	struct damon_system_ram_range_walk_arg *a = arg;
+	unsigned long start = damon_res_to_core_addr(res->start, a->addr_unit);
+	unsigned long end = damon_res_to_core_addr(res->end + 1, a->addr_unit);
+
+	if (end <= start)
+		return 0;
+	/*
+	 * 'System RAM' resources are visited in the ascending address order.
+	 * Coalesce only truly adjacent (no gap in between) resources into one
+	 * range, so that any hole between discrete System RAM areas is kept out
+	 * of the resulting ranges.
+	 */
+	if (a->has_prev && a->prev_end == start) {
+		a->prev_end = end;
+		if (a->ranges)
+			a->ranges[a->nr_ranges - 1].end = end;
+		return 0;
+	}
+	if (a->ranges) {
+		a->ranges[a->nr_ranges].start = start;
+		a->ranges[a->nr_ranges].end = end;
+	}
+	a->nr_ranges++;
+	a->prev_end = end;
+	a->has_prev = true;
+	return 0;
+}
+
+/*
+ * Find all 'System RAM' areas and return them as an array of coalesced
+ * damon_addr_range.  On success, *ranges points to a kvmalloc'ed array that the
+ * caller should kvfree(), and the number of ranges is returned.  Returns 0 if
+ * no System RAM is found, or a negative error code on failure.
+ */
+static int damon_find_system_rams(struct damon_addr_range **ranges_out,
+				  unsigned long addr_unit)
 {
-	struct damon_system_ram_range_walk_arg arg = {};
+	struct damon_system_ram_range_walk_arg arg = { .addr_unit = addr_unit };
+	struct damon_addr_range *ranges;
 
+	/* First pass: count the coalesced ranges. */
 	walk_system_ram_res(0, -1, &arg, damon_system_ram_walk_fn);
-	if (!arg.walked)
-		return false;
-	*start = damon_res_to_core_addr(arg.res.start, addr_unit);
-	*end = damon_res_to_core_addr(arg.res.end + 1, addr_unit);
-	if (*end <= *start)
-		return false;
-	return true;
+	if (!arg.nr_ranges)
+		return 0;
+	ranges = kvmalloc_objs(*ranges, arg.nr_ranges, GFP_KERNEL);
+	if (!ranges)
+		return -ENOMEM;
+	/* Second pass: fill in the coalesced ranges. */
+	arg.ranges = ranges;
+	arg.nr_ranges = 0;
+	arg.has_prev = false;
+	walk_system_ram_res(0, -1, &arg, damon_system_ram_walk_fn);
+	*ranges_out = ranges;
+	return arg.nr_ranges;
 }
 
 /**
- * damon_set_region_system_rams_default() - Set the region of the given
+ * damon_set_region_system_rams_default() - Set the regions of the given
  * monitoring target as requested, or to cover all 'System RAM' resources.
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
@@ -4449,9 +4484,11 @@ static bool damon_find_system_rams_range(unsigned long *start,
  *
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds 'System
- * RAM' resources and sets the region to cover all the resource.  In the latter
- * case, this function saves the start and the end addresseses of the first and
- * the last resources in @start and @end, respectively.
+ * RAM' resources and sets the monitoring target regions to cover them.  Each
+ * discrete System RAM area becomes a separate region, so holes between them
+ * (e.g., on multi-socket or CXL systems) are excluded from the monitoring.  In
+ * the latter case, this function saves the start and the end addresses of the
+ * first and the last resources in @start and @end, respectively.
  *
  * Return: 0 on success, negative error code otherwise.
  */
@@ -4460,14 +4497,25 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 			unsigned long addr_unit, unsigned long min_region_sz)
 {
 	struct damon_addr_range addr_range;
+	struct damon_addr_range *ranges;
+	int nr_ranges, err;
 
-	if (!*start && !*end &&
-		!damon_find_system_rams_range(start, end, addr_unit))
-		return -EINVAL;
+	if (*start || *end) {
+		addr_range.start = *start;
+		addr_range.end = *end;
+		return damon_set_regions(t, &addr_range, 1, min_region_sz);
+	}
 
-	addr_range.start = *start;
-	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+	nr_ranges = damon_find_system_rams(&ranges, addr_unit);
+	if (nr_ranges < 0)
+		return nr_ranges;
+	if (!nr_ranges)
+		return -EINVAL;
+	*start = ranges[0].start;
+	*end = ranges[nr_ranges - 1].end;
+	err = damon_set_regions(t, ranges, nr_ranges, min_region_sz);
+	kvfree(ranges);
+	return err;
 }
 
 /**
-- 
2.43.0


