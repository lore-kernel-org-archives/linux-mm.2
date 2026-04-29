Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D12BFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E96C6B009F; Wed, 29 Apr 2026 00:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A656B00A1; Wed, 29 Apr 2026 00:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588E06B00A2; Wed, 29 Apr 2026 00:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46E3A6B009F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:14:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40F731608BD
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:40 +0000 (UTC)
X-FDA: 84710272080.09.45D4F2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D7D620005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eWKMXG0I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777435958; a=rsa-sha256;
	cv=none;
	b=Eh+CMiKoEvjYOEygVco2drrkqcns+fl/+5lndWQZMQKH9WtL2mD7lMOJ9yt1YvXd5Gj+7n
	ABhMC17VdDWjfOBxxdTWGJ7P8eN3mtAkXWy3nkNl6wiw/ksTLzl7LaxKYYuBXOrOi//LMA
	RwUskchOSJ6BBO+IJ/q+xQXfIN6NCmQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eWKMXG0I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777435958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qRo+kujvYLGq/ktDqV5UCwjBqgYCOUOS6frvTxMnz9s=;
	b=OcYHJCaGLbWSOCtwYry3p1pUGcr7KJfmySIdZH2HnnXHlm9o7qchMTyx7pSD6JWW3YC+45
	uub14ytDv30TC9Nj6qIctd1VLzQBMDsyFDrGM0GHV/vxe+3aJ5EcSglqIW94j5VlBfwezl
	+Io3DLzxZsBPVpOlfQZOlD40ztmDm0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86DAD43BCC;
	Wed, 29 Apr 2026 04:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD9EC2BCC7;
	Wed, 29 Apr 2026 04:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777435957;
	bh=049URIRLtatALXiIb20Ra9ky+XPPw2/kMGej8Y0Qt0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWKMXG0IMklhPdaxeBYX9oMzqREyU6hFq1jpu/fIIuQaAM7/rMlX4vPrVESytswcu
	 XW6zsP8OraCnhmpOGav40Hsb60LKkIxyBFbm/PDZC3kCs9sa/7w889R7C0eOUFXuoA
	 iq57SFgPpdfR82+wUwDT8Y+kENBBiXDdaURiRX1gKbfpvOKbqkAqx0cbWMCQsmqTdI
	 nziK45o/iiY+PGrhvW/WmyVmf3nuKTo+il6ra5vz/ybgxEzfMsLB4c2679g5IftMpo
	 2zjAr/gNWDiEkyXjd8/sbKVGIUOZDNCTC5XhJxdyjZnXBBzGldS3tSk8hpU5bqcHQb
	 qxkz4vfkZATUw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon: introduce damon_set_region_system_rams_default()
Date: Tue, 28 Apr 2026 21:12:23 -0700
Message-ID: <20260429041232.90257-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429041232.90257-1-sj@kernel.org>
References: <20260429041232.90257-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1m7mo5nkiojopnurkzygro4ztrejyosi
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D7D620005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777435958-174062
X-HE-Meta: U2FsdGVkX18xHI7m4F7kBPlP760UAwwn8wEuj3JCCJsDSOP72AN1bjarNLl0t+SwTUkvGo360cFu+Cy7Uq1VTywuU3d8sgxw+wC/XWZyvC0VLpFoIcbkATMpiE81TTlHx3nX0HVCSMcC2MokRNsTOscM07N2yZHt+fCtDCnfSZluyjPZ+rpRanTxAyfYN8GjhnIoDd13Md9x3OUiuZPbABqajPMRdhawwT8MJxsXXYuxgEl4iSg5ky9Jnbb7r9VdrwN03Cr87G9nmnzkmUO4t6yQ4RYSiSgarkcyjdV+Mjx0Kt2WAJKJdnbLzwAKsPz5RtJ0z+RWyH9dscszt8JMOwE1CscYFGo1aQbpHPc49IrnalGmRu8TacPKd8v+psL+NEj61I+u+3UW+SbWecbnNdW/lUSlgFS7ftOywDLyG0+EiWKkO6qRcyWF9wWXUXzo0Mx5qNiw7uwsOrgcBfXzRgLIUJJpwBm6jzCmU8BAEw73D3z95OuiqSHV84b4J/NLv+Vacnhj35YT4JxcJgAbkeKbClM4Qq5aoOGWjrDGoX5C0nSDkrPTV3GPflBXAcz2F6eJ/mBMYuGMa+xHYztANrWzZqPyeK/7Il1wproCxw6cCpGbikmDoALhMuQva3IyhrNwiZ1cL0eaaX+hpdDj6iH4QYHOYOb/q/5MNVwwH6+82gRR+TEP0fSvnCJp8VwCt9l5j95ov4d6mjcqRFwJG2Jpql/tWD2ODrlIu++PbS0It7jn1M74lIBa6xDQnFtVcderdtDi6b56JeVQM6nT5uM/MzB9N9LR6eyYJfWIJIl4JngiuXFt/rASk/2hysT0S9NjBQ/7WrUf4xCK3/CV5zofRSOUyNTAhfE9PS8xuf+X05t9JNPfZrl1UevavnE/KCiVxXJ8vgpVtjR8EEnUzkFYRwCZujmbU3Wvq71LKs7qCi+32xMr7oN02goOY+fDYPlb4cYyVb/GY4hWoZP
 pEXuRiNL
 dTgK02A7uLU5VTWDiWjvSRIOSuuvqzSEFz9qdJer2+kdEkENl1MazOH96fu1FoTt/v4kbK2a4RTWRwQ7ea3WM2BkGAWCoNDbM8tduMJcilGwhZ+Dc4t0KMgptILYa+mYNxVzJNLMDrDjENpBMZ/nYNyKg9jzOx3EB61kQR0RNhIy+daRSHG5RDIXMC9jmsgx7WyxYczq36ww5IKLnS5c/jWpqVQfbeI0uAVbG1PAqW64CehrXl8cTYurE1LplFIXxNnKDLAs/9K6eS7OtG7yMYISh0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_region_biggest_system_ram_default() sets the monitoring target
region as the caller requested.  If the caller didn't specify the
region, it finds the biggest System RAM of the system and sets it as the
target region.  When there are more than one considerable size of System
RAM resources in the system, the default target setup makes no sense.
Introduce a variant, namely damon_set_region_system_rams_default().  It
sets a physical address range that covers all System RAM resources as
the default target region.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  5 +++
 mm/damon/core.c       | 77 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2370a3a4a9a3..f656908b2d389 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1010,6 +1010,11 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+int damon_set_region_system_rams_default(struct damon_target *t,
+				unsigned long *start, unsigned long *end,
+				unsigned long addr_unit,
+				unsigned long min_region_sz);
+
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long addr_unit,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 05e4bef367dbf..980a31cd3498e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3328,14 +3328,20 @@ static int kdamond_fn(void *data)
 	return 0;
 }
 
-static int walk_system_ram(struct resource *res, void *arg)
+struct damon_system_ram_range_walk_arg {
+	bool walked;
+	struct resource res;
+};
+
+static int damon_system_ram_walk_fn(struct resource *res, void *arg)
 {
-	struct resource *a = arg;
+	struct damon_system_ram_range_walk_arg *a = arg;
 
-	if (resource_size(a) < resource_size(res)) {
-		a->start = res->start;
-		a->end = res->end;
+	if (!a->walked) {
+		a->walked = true;
+		a->res.start = res->start;
 	}
+	a->res.end = res->end;
 	return 0;
 }
 
@@ -3352,6 +3358,67 @@ static unsigned long damon_res_to_core_addr(resource_size_t ra,
 	return ra / addr_unit;
 }
 
+static bool damon_find_system_rams_range(unsigned long *start,
+		unsigned long *end, unsigned long addr_unit)
+{
+	struct damon_system_ram_range_walk_arg arg = {};
+
+	walk_system_ram_res(0, -1, &arg, damon_system_ram_walk_fn);
+	if (!arg.walked)
+		return false;
+	*start = damon_res_to_core_addr(arg.res.start, addr_unit);
+	*end = damon_res_to_core_addr(arg.res.end + 1, addr_unit);
+	if (*end <= *start)
+		return false;
+	return true;
+}
+
+/**
+ * damon_set_region_system_rams_default() - Set the region of the given
+ * monitoring target as requested, or to cover all 'System RAM' resources.
+ * @t:		The monitoring target to set the region.
+ * @start:	The pointer to the start address of the region.
+ * @end:	The pointer to the end address of the region.
+ * @addr_unit:	The address unit for the damon_ctx of @t.
+ * @min_region_sz:	Minimum region size.
+ *
+ * This function sets the region of @t as requested by @start and @end.  If the
+ * values of @start and @end are zero, however, this function finds 'System
+ * RAM' resources and sets the region to cover all the resource.  In the latter
+ * case, this function saves the start and the end addresseses of the first and
+ * the last resources in @start and @end, respectively.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_set_region_system_rams_default(struct damon_target *t,
+			unsigned long *start, unsigned long *end,
+			unsigned long addr_unit, unsigned long min_region_sz)
+{
+	struct damon_addr_range addr_range;
+
+	if (*start > *end)
+		return -EINVAL;
+
+	if (!*start && !*end &&
+		!damon_find_system_rams_range(start, end, addr_unit))
+		return -EINVAL;
+
+	addr_range.start = *start;
+	addr_range.end = *end;
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+}
+
+static int walk_system_ram(struct resource *res, void *arg)
+{
+	struct resource *a = arg;
+
+	if (resource_size(a) < resource_size(res)) {
+		a->start = res->start;
+		a->end = res->end;
+	}
+	return 0;
+}
+
 /*
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
-- 
2.47.3

