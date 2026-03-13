Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BEE7106FD7D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF486B0005; Fri, 13 Mar 2026 00:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552246B0096; Fri, 13 Mar 2026 00:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454496B0098; Fri, 13 Mar 2026 00:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33E546B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:45:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA4BB1407B3
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:45:00 +0000 (UTC)
X-FDA: 84539799960.02.3572225
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1700E1C0009
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:44:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0aA3IvN;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773377099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UbYjMnnropCNS67Uq2qJz2es0royPzDhs+Rlw0ZTqFA=;
	b=TYRiFLnbLHHzG9MeTiaiwV8odw7P0Pa1jcQDU9Q/49FSanMQ/Iht4J6Ew0luglzUxup0oS
	UhK1+lK3Apu2ov4YwlhCarXrCkCC6jEDfKfOz0f8CVu7GhhQQCwqhl3Rkt4PkDx2o4nSOE
	kQlJj9mAu7z3W4fh/rpRxWQnlOAY900=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0aA3IvN;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773377099; a=rsa-sha256;
	cv=none;
	b=y7luIZdeuh+fgPktLV1z5xPEAT1KsihR6tb3siaCKkFeBUAtx5SLJLk3jsK5zsSeA9EoaE
	HgQkc/AfGuIVCK0PWwA+Ysojg40jlG873MeMV4Ibd0ci0E9dZNvcXu/wcgQQv5iMaf2TaZ
	cxl05jUGa538mgWapeaUlcvh/a5sgIg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C77A4440DE;
	Fri, 13 Mar 2026 04:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B247C19421;
	Fri, 13 Mar 2026 04:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773377097;
	bh=XrYj7XvkjVOrSZUvKRwcxWJvhLvpmnJnSlNXlwKIaTg=;
	h=From:To:Cc:Subject:Date:From;
	b=H0aA3IvNRoRHgjcHUUzksuzmMWNJLmK4v9Lp48NTbH9e0AkbLkElRqbWZayjAPLbg
	 x+GoXKm90rStryfp+ullE7dqATkwSMnrcpKaYaeFX28NCEdDzvVn0Zw5jDlW0czAJs
	 eX1rDZXX+XK1ViKtJ+/lAWC+24LB3/EoKAoROgDjSRZ+bQMnxT6nyw6YwaZfvpA619
	 toeR62XHeVE55FV2ujkN7fP4gCs26O3txwrcpEttmrZ7jnoX2lJQmeXM8B14v3e6HA
	 yxeDVZFPCQzeYhHuRM9y2E3JShr3xKYpyMr7hRWVZxTCBbxueKef6aHjYAOpSEyr+h
	 cFgG9SxQo41Aw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/stat: monitor all System RAM resources
Date: Thu, 12 Mar 2026 21:44:47 -0700
Message-ID: <20260313044449.4038-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1700E1C0009
X-Stat-Signature: myqb3rx4xbfebwwtrhd1xcnpikse6uqf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773377098-323896
X-HE-Meta: U2FsdGVkX1+bNjrdvO1GLjsmhcw+n/VMWxb91BsSXf48p7nQ3qUXBTYYrnZlS93uhj5wSeap7fYDq5XYC6R61YyxSO+9iUnQTngXD7mI98Vged7F3Gh8M+SUhYAplWzUUXCsIVjTnqHTps06Fy6OJs80HJhUHmuxKNaeTusSiRHO8Rxn0eyX+qlwjwWqU0wD7gGnU1K6S47/QC0MWpkC3lHKQLjzDvvC8wPN4pafREueFVwyPgEulqFZND1/NBYIKZIOKDsAxZ01luS86t8ch7dbO4fE7C+/7Oci5pUm6xBPHiGbM9I6wDiSMY+2WpRwP2Eh8uFu48I/w0oRjJj/gD9xoNA95Nqskgd8uB7s00yxFiCMxc2L8eW8NFDS/W0HTL41CHfd0QcAEmmlhoO4QSCytTBQ6KZJDCAzMCEckuCaULrwRefbPMVxEJ/wOfYu5/Sv2tHXE4D9/ig+Gg5hmGrKwEIyNk4AjkUSZsRdWC/IyV9fGUfUPAHGsKXZuO8Me0fhUAaF7+a5kAXfHqPj4aw5jeO+WJCgyywZjKoQoeb9HNPNVqAHIfhPtdGrju3jxyAfKpMzY0hrDqLQjKCoQIJlNIqSODo1ovRTqDtFu/aGowAlDzF8sG+LkUb0zpyh/Yo1KmK1l68HNW8Gzbnc77+fdRCqMNNi94G9pI7bdO1U3LyjCjuHoDVDJRDn6EUTX9tKpuz8RZuoYigaKaboyZoYGTh0rFfJ8KeocrRHroogpAYSc3iyY1GeQBqBPUniMxOG7IUJ5h1mbr0X3vNvVuR1NDXn90+xfxuaP/7p/8n9jiFE/GfmTG1zVlqrrL3grdBHaoYU2IllifPRtoz0Mb94B+AxLll3RWoPR/d0JxnljwPiO/SeJwFg9i0QgOLLBxqDXJ4TDb8k+FeENhHG1Ud9DLbokkRnGaHNSj3PJW3vSqijQw0mEZyDU/EUMBFAsQlMqWSE1kkQpniC9wJ
 vY6TYZe/
 /gwGbMyFETh0dF6fCNlNgJRZVyeG0T9HNuF8+v59Y/qnjY+ntvwVepoUlZULwvpz73SPDv9Vv/npdrF8JafQ5fN0nTjfyy6LpfICcILWuU3zgvIlr9maAJtWEsHwKDKiVR9Wrekz86w1XPHcOK9ZHa1FK+Mhra+lfZH0tNKP/UwgTI07K+/FPkTu2OapJsIT61WNr
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
 mm/damon/stat.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index f9a2028483b05..3ed71db33e899 100644
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
+	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
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
-				ctx->addr_unit, ctx->min_region_sz))
+	if (damon_stat_set_monitoring_region(target, ctx->addr_unit,
+				ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:

base-commit: ef772f765091af645985f2bd70390143a9820970
-- 
2.47.3

