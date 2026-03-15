Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB1EF3026D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 16:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E532B6B0098; Sun, 15 Mar 2026 12:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E018B6B0099; Sun, 15 Mar 2026 12:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D036B009B; Sun, 15 Mar 2026 12:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1C286B0098
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 12:27:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F7A7160BF2
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:27:29 +0000 (UTC)
X-FDA: 84548827818.06.F01DD51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A278C000D
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:27:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TO2iYOBY;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773592047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o6htyqhM49xNz27/JmrMMLrryPChkWfdnkxT/MbOGUM=;
	b=3KRYnBLsfpM79GBBAEr0qSuLD13858bSLK7n4uOI9IBOWejvJNCC/n9Vt5wSSjYgZ9ZqiD
	t/1FKvihuiw7CPkgtgw1LrWlZ1OvBHBJI69pbgztE1+kAacLzXp0WOg/3EN7LlwHep1WwH
	5qQk3VX2oGIE2FSeuyFDGAEnjIB2OiY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773592047; a=rsa-sha256;
	cv=none;
	b=NA6ne/oq5W4aIYx8cU8pwGh6RifZFOBP7Lg1UTc/hzMsK4rgsMrU2OxwVc+v9OkHP4bZA5
	LlmT07Qg5eybiMSxbKejmhm6aVWqzFNacpWiYNhUQZMnz/CtR9iYisriPy7m6fXC51hcIB
	H6PgC3f4vhU9UViKFClhC+Nqw5iI7R0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TO2iYOBY;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48BD243F70;
	Sun, 15 Mar 2026 16:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D85EC4CEF7;
	Sun, 15 Mar 2026 16:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773592046;
	bh=tcDHnHCQtRIlyRPX5ixjq3/dMmHGb3WsrPaGYv6W6Qg=;
	h=From:To:Cc:Subject:Date:From;
	b=TO2iYOBYXd9YTDOZ+wRNqysoS7zh+UAqoGhPHNJ8rX46Jyk0TOVb7ww+QnfV+7i5u
	 k2QJ7+YkUP2rqREu2BVlNRwq0pwD/bAQAroYAxLH6q/UxCOufoPaf99xtfE5TafSW/
	 zBYHMhniMVx8ZxYkx3oXQufylMwBEgACCOQIaDqoO+MIP2Mc4ENMdBF7z47P+1YUh5
	 Lr0KLO0JyOV+wmANZaX7XK/Iu3zaSumy62RxOTFe4iOVnn2dPagoG8FLTekr94Tj5d
	 umRgydpqkAoo6g25CIUpTCskVHR0hEV8ny+E6JqOa9+VgnvYHX/3EGiXtwAKa5Fgsg
	 Brusw26ggm6qA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/damon/stat: monitor all System RAM resources
Date: Sun, 15 Mar 2026 09:27:15 -0700
Message-ID: <20260315162717.80870-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8f69gz3gbxmeb19mpg6rq9mejbrxj81t
X-Rspamd-Queue-Id: 8A278C000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773592047-135753
X-HE-Meta: U2FsdGVkX1+rYsFF86k59cb7UDYTPZMcKtM0oCYxITaUNDwHSa2NjVrSRjwFBicInqv8rv4NvT++2EW0PMKrWE12+S/SwA8VzR0icFipcjI54FYqAd8w+TEXTe8HsbeNoFgNEmWwoR6U3/MT/kX1cfnStdW2dIsJL7oc8HFzQBDAJnXY1c6Di8Qop0EPIvZhHuroticHQjjNrrXpsVC6sh/jbp6y5ELZRZ62A4rv64Jgb5dNLZX86pUPxMnpgn3GR6b5W3KyR1iweMjbHkEV2fCCgKilVNQGdtChfmQXVEh132UsjO/1fB9fkEdk2mrhh3BqJQWgTLlgIYq0unnmIbW4OXF5rH3Oi8qEkA1cSWjRqZIR9Coa84+4BJMve8g50eHVaQwZmwLLZCIfnf8QlS+S/Hp2tWZ0YpyM7dFe21CCx4OeLPZubWkPH3m65kltgMfRaRKOi/sDHnzCXM/ploeIdexlXeZyEvFJFyea7/cR0wDVnJqMRUWBVdgwgxBEsTUHE23KnuejTJX9W8D4NIFy+HH4AgZUOSVOtjRvkHcCu5VLrW/YL7DG7ajybhvH7EwmmX3fimr+eRfbWx49wXWrhBkvCiXDdiwIvljssPg0y7R+pNpnzQ/t/S408DFnyGjo3/nASTgy9O7BRi1guw0NY9+HCqCL9WYtLDnUJPZ6WW79G72r2X9TkzwUQ5ZIMNAZcde+Ok7S5s4GIK/BanZIsPD+Sc9W0b8bECl/f488QSKKCZH9FzvbsnqnQ0IfmSZ+lPU4SyA0kcZUZrMPaESZ/MnpjANEGmg6lpUmTgIVkTzQ4KVfXUG8Wsoz/sSdG7Vm1DrnKUW6nksxq2koWMAtX6c3yWt5em6oYbCLw0XgRVqueaY5alw5KZI8MtxGs2HegYFbvqYCZWXYiX4RFk2KuMJhctK2SkgjL5JS//vcM9bpTQejegqC15qNWLINWRR9iYT2sH0al0P5vdP
 Fw7T/l3E
 MUQ34BkVhPVLfFKoBqcGdwuWzNFx/pETA1/9rYMJo/MF57KA+SD1XcJa9kdhQOrrwOG0kwcYaTYAyKLZ8VcMRvij9M1Zb7hiW9xuyL0bck3w3oMobFGhcPShIVst5Vh8Q3M+hjnYPM7Q+mNjJHGjhOcrD8QEBJhmyJ+s08aSV3XEt4jBht4TozHsxuiLqJVn73n6R
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
Changes from v1
(https://lore.kernel.org/20260313044449.4038-1-sj@kernel.org)
- Fix wrong argument for damon_set_regions().

 mm/damon/stat.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index f9a2028483b05..c5af8ad4bcb65 100644
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
-				ctx->addr_unit, ctx->min_region_sz))
+	if (damon_stat_set_monitoring_region(target, ctx->addr_unit,
+				ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:

base-commit: 209f54c1171365f1d942b89554808acce71aadb4
-- 
2.47.3

