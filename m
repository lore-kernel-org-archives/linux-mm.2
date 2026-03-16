Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B0CFB5E88
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 23:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B736B03C3; Mon, 16 Mar 2026 19:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709096B03C4; Mon, 16 Mar 2026 19:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B7E6B03C5; Mon, 16 Mar 2026 19:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1EF6B03C3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:51:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6AD81C245
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:51:29 +0000 (UTC)
X-FDA: 84553575498.12.F73D7DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5786D100011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:51:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BU0ZTXFD;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773705088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=35LVLayqqrad8/sJnY88qvwBiLFUToDo4v5j5kijepk=;
	b=aFFvILp1RNlUgxwBmBcwC16TeTsC32akTgfgXg4kTky2s94OjVa9FCNcsYTabbKC4AuWj3
	1O7/aJ2o9njFGolWNYEzw3NKKfaHG6VsKlTXZSWpQZ/1wW8imayKZucU+2l9DLbTjGx1Sc
	+RnTlX0rIDaWGLXTz98KKZ3pxEyleKg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BU0ZTXFD;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773705088; a=rsa-sha256;
	cv=none;
	b=WlJpYxi1aehi8stTF/G/XOFrX8KMoflQXD2oNbvIGgeCK8zSdA0IrQIIfz+OH9QeH4cOIV
	kMOPD9SdxFbCfK8xsISFgIKqcRN7LiH3JSS6cyFy6tzQS3O3t4GqZMzgApu9r+m+qJ3l7Y
	PrH8d1S1t3QqcSthw4bo4o7Ls/2elhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 948B66013E;
	Mon, 16 Mar 2026 23:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A991C19421;
	Mon, 16 Mar 2026 23:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773705087;
	bh=2RCyDp6yxdkFkrGuSTJt1rP/JNUEB1SMSr+RxZLc1Yo=;
	h=From:To:Cc:Subject:Date:From;
	b=BU0ZTXFDpWubidgl3UQVb54EaQZZ8ggCdnoXsw55JpLalSmMYn1MHJaoMJ9YkzDox
	 6uY7qUvHyQEp8cevIiPGRAkRaJXrxiCzsHt6Y4XjhGBgV+6yjBgLXi9U7o7AC9H/WS
	 NGsM5+KXu0+tUT3VLMh+74u2xjCcySAr2684Ke7n2fCT+WmTu6qjz5J37MZkBI1Ufq
	 WGfiQq9bqNepsmiZtT9qblRdCiYyq0sy4Op06g3F1HDjijsLAOALfWTmonkKPOog3u
	 GF4/O/4w9gr7aq71he6g1nyVr89t7BLblLBkJSKF8EJ2ZHL4vfh3yx1re4wayahpGb
	 dGNOlTTnjyZ5A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3] mm/damon/stat: monitor all System RAM resources
Date: Mon, 16 Mar 2026 16:51:17 -0700
Message-ID: <20260316235118.873-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5786D100011
X-Stat-Signature: 37egodtgdk89ie7ujns6h64yx9ky7zbk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773705088-41758
X-HE-Meta: U2FsdGVkX18s5IF64ymkI9ILgBVD/+PC+SQQ3o2ldBTiTZKZPOJzyc6Ib5FUNbbN9JS0+gELJvXKm8l92VruZ0x1Joaw1gDFvW/eK1r+DZ4NXguyA09XfO9fE0qxqS9IybeUCnyf3/vRFPME7BmXPQxvKcJwjJG+1tvROJixE1CyhAdiR4f1tS8PMvkYf5rGd/BKWVRipNDZEnvt+aPba+T/8XihcLRYFCINpuqCoF6vg+VT/xi46pHGKpie63WXLqL7o0JPF4WYnCuZP0dPxZJdV/bjHTvbQ398fQz32xBXvenuVy6rZErq5yIBqewlVHM7bmhNuwNixVpsYerG6qQt2jfmZ59xWC08TG0bgHUsyTOk+2Nc5YWkb5g7les5cwe1T9kqMvTqS8XqGwRKWHpsB/vxeKFGfj5fRfKkb3goXy8eBA5yaYdZiuBOo8Q0rtVeuZwCaT2eS6fBf50oQziImE8Bp8OvgK6RpcI+wOFLafscTOJRPxPYAxf4qlquOGNKQFif/Zw3RcTgVyfuNB3oOqwBCOphosHeGeuiOhayCbMT+HogPy8K/rh2vd7Gig7J7Z3OndI/urXmT+Hw9FTCDeCFf4q2cZOQq3VjoHNTM5LSHJG0z0GnkwjunVvGzkKCe55jRCBhBvdtwd2YLnhfKawEY5E+Qn3ql1bAphrCJwf2ZjS1jKliTv13en/RDKNpB0O/ahjOac+7awWL3avX/rJVYN/uXU6V5Qs/gnzmQ15dtlbevPpRar+XCW2E26nN/TwzA/yVujyQBpA8WJnetjatWoIP0fG+PIE7hjxWyFKi/zGnYdwPbwMXnJD+Cv4JExetNQQDOJkWdcnU7q8A12jzovvYEBQxq30KqpZtn5J05OcatXLt/FSywcK6AbLEf0Bu/vhJOOe8QqqYNrUQ+plwgQts6Qwxuq+NUvdjNlIrunk4Q3csjxv964aG88ZHNIHAiywrLSx61Tg
 7V7Bo+94
 NzaE9F4NSPXDpoOLSgqVRDsO2sKH1lqHmFJshBu0T7lbaVFTNtI3+7pMZBrSa7osmjAUNbADe+ZX0n8y5jASmrig24HJ6lPW3WNL16ctov8TnsMo7gTDZxYciDGbV/xsyftCVUXsiKHHgX1dsowLupDQqmXe15/5eYGol+KcJ0ZReoqpzRof/eCgMkBSatmfHKc0N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
says it monitors the system's entire physical memory.  But, it is
monitoring only the biggest System RAM resource of the system.  When
there are multiple System RAM resources, this results in monitoring only
an unexpectedly small fraction of the physical memory.  For example,
suppose the system has a 500 GiB System RAM, 10 MiB non-System RAM, and
500 GiB System RAM resources in order on the physical address space.
DAMON_STAT will monitor only the first 500 GiB System RAM.  This
situation is particularly common on NUMA systems.

Select a physical address range that covers all System RAM areas of the
system, to fix this issue and make it work as documented.

Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v2
(https://lore.kernel.org/20260315162717.80870-1-sj@kernel.org)
- Rebase to mm-hotfixes-unstable
Changes from v1
(https://lore.kernel.org/20260313044449.4038-1-sj@kernel.org)
- Fix wrong argument for damon_set_regions().

 mm/damon/stat.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 25fb44ccf99d0..c5af8ad4bcb65 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -145,12 +145,57 @@ static int damon_stat_damon_call_fn(void *data)
 	return 0;
 }
 
+struct damon_stat_system_ram_range_walk_arg {
+	bool walked;
+	struct resource res;
+};
+
+static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
+{
+	struct damon_stat_system_ram_range_walk_arg *a = arg;
+
+	if (!a->walked) {
+		a->walked = true;
+		a->res.start = res->start;
+	}
+	a->res.end = res->end;
+	return 0;
+}
+
+static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
+		unsigned long addr_unit)
+{
+	/*
+	 * Use div_u64() for avoiding linking errors related with __udivdi3,
+	 * __aeabi_uldivmod, or similar problems.  This should also improve the
+	 * performance optimization (read div_u64() comment for the detail).
+	 */
+	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
+		return div_u64(ra, addr_unit);
+	return ra / addr_unit;
+}
+
+static int damon_stat_set_monitoring_region(struct damon_target *t,
+		unsigned long addr_unit, unsigned long min_region_sz)
+{
+	struct damon_addr_range addr_range;
+	struct damon_stat_system_ram_range_walk_arg arg = {};
+
+	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
+	if (!arg.walked)
+		return -EINVAL;
+	addr_range.start = damon_stat_res_to_core_addr(
+			arg.res.start, addr_unit);
+	addr_range.end = damon_stat_res_to_core_addr(
+			arg.res.end + 1, addr_unit);
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+}
+
 static struct damon_ctx *damon_stat_build_ctx(void)
 {
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
-	unsigned long start = 0, end = 0;
 
 	ctx = damon_new_ctx();
 	if (!ctx)
@@ -180,8 +225,8 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
-							ctx->min_region_sz))
+	if (damon_stat_set_monitoring_region(target, ctx->addr_unit,
+				ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:

base-commit: 10125b79cb0e7037fff6cd8cc9fafacfda8113a0
-- 
2.47.3

