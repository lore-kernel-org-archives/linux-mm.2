Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F250FCC9B0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C11F6B008A; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27ED26B0095; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C98D6B008A; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1E266B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EFD31A05EE
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:34 +0000 (UTC)
X-FDA: 84532654668.23.CAAC8D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8781E40005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H6jRZJTO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773206972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0kgF2GvZg2fzI9tiF9omfKy8z1tolLMkGXfDEMkdXk=;
	b=1ioxVrSWPjh5DBUfHGYSXpu/djwiHwRziU//tlJfQaYuGr7fy+XhDgHDd2f5hde29ckX09
	D8a0w1Edx2pPG3ThvWvEQcbaUBJMfZ5/M0OXRm20efLoB26q08ruJ7HbKt1ywMHg7lVDk1
	rpSpEfK+eKnPIXgX/7Zn1HRwleOoLQQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H6jRZJTO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773206972; a=rsa-sha256;
	cv=none;
	b=ffLd1jtcudbl5WOK+E/kl0p+Uy3dAARNK1daHKrWgDHW8n14J5Y2KjKG62jWkKLc9Wwbqg
	QFbKh0iOK1S9Jb3bfmkYOIyN5s5XBH3UMngO0G7WcOp5NoBMlUqdz0TUD9p2O84UuEUgDZ
	oIs2oYWv+ZvU85C+7apDhCoVTJvK4YI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD99041AC6;
	Wed, 11 Mar 2026 05:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74136C2BCB1;
	Wed, 11 Mar 2026 05:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773206971;
	bh=aGbllmaaq9J7Qd8uyVbLEXseWZd1bfmXTBQJFAjpS5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6jRZJTOTU4p8b7NVG4ikk3Ufgt08EDESkq6teQ6x1piVHyuyBVy12Jopkr+JSBGR
	 4QUIxeZEbR1zhDZfR1KhtbTeL3gf30/ZXNRFyk61is+06IVPMMWhC7Fhyq6F1O0jVL
	 IHst+/bFywOsmwXmA0cs8u/XEiuhDmxyA3IGoLLMzepARhSRFOpaBDsmyIH9D2L8lK
	 CHZa5Y+Ntg2/gMQnRZE02bO707dvqaOEn6h0eYz0ekCsSa5pq6P/DAfNbleTESFid8
	 rTZ0po2uJjVdzTKF920YK1wkXR9dZgugdCkA7WDDvQcNGBfHKIPBpqGJ3eM0rWR+XH
	 89NfYufvRjUCg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/5] mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
Date: Tue, 10 Mar 2026 22:29:23 -0700
Message-ID: <20260311052927.93921-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311052927.93921-1-sj@kernel.org>
References: <20260311052927.93921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8781E40005
X-Rspamd-Server: rspam08
X-Stat-Signature: riprgzn64ap5ozueu7gp47roxcjf7pbq
X-HE-Tag: 1773206972-484381
X-HE-Meta: U2FsdGVkX1/3zIOBfKBbE2JFq2+nIDvg37ogT8h1DoLj42rGjOS5AoTwlV/YkU1PgywEh5JGDL6pXGtGNrb+uFtm/57vgKLZcgWS3U7RXJzLBpgvlQv1MHbbpxIg6oCqea0crcgMR85eHkd8UYySTWmcls+4JSx52MWbNmCsxaTGq+pzY4BUnRaUYsNQNSloYZIzIrnZTSZWS4GeyUhkP2D79GRd7vFR74Scw50UVLQuQD0uRmny5fSVuzPAE2TT7uwMVar+X8xsh5dPCl8i6MohDjDlFh8FydGPQEzCUWxHSDDs1KSCqG0GkApiEA5TxXJLByG8gzPHHe+M4XzBlD2gxUdqa11upA2KQsfxzxTgc1EKVxhnBw2DUf/dBME2AKkWqZUf6fF2ngC4NpbLcNEzwixP74bBsDveSbcnMUqNrhFFr8W/aFgAeG3VHlURToXIhabEscpxLm2y+/gvm93S45sA4CNxjuuHhYucSLAsb+MV9oV5LPBYCI9p6vCrOrYPfpHo+9a3OBHAf1aqai00bECWZj61HaYmiOtSn4ZOrgluuM+zfaF6E+J+FVmxaKen9iq+CUGVK6D27cW526fu7R2t1+1dk45/6FMOW2gGwhe4znRafRlMpsMbyTZqcgwYOhSZfMkAJKaUjpqdgkRJuhy/6WQwNkUkcqt4dJHY7xyRQwApm8Zsrs6pFW85fg1+mP7806fv+S9cGL2nYRtIAOKRza0AY3jkxavLZXb+IeGuyoFbFB5EEDPrbRgHBk4/gyREsfoNR0LoR0djvsBj70MTDBYC6Jk6vKOMwp1nOVdZZhmhi0yILav93Uf61DJajF+Iipa+p1WLZXdl1wM0EMo6DcmI9euo7zefeKrs4Oz+Jgpev+ld5ihYshxo6kqK6DOUNErIGd9CdEy9p4fC7eom+NayL0JHkRRvjnQqlwVqg7vdn+ogERj/cT+v5fIVIEAzIvggUTHWxoz
 U9TuL22A
 JOypMgDlgpAQjXiLnwWfcNmizMA/TQ1gIVBItmPym0FubJNh8dyUw8YxT5PofBsXHddqmY6iJyt8rc8s2j4+bhDO3cvwS8eQhjDJQAUMUrB3R8rag+cGj/xaRxOmFOza5GnF3ZxNUqKVPWt+sz/kY+uO9GuDEJqNt/IMkUO78S1YFxf0+hQL5gqtQe30SzShRKkLAbwlEwK85T/pOuhurcaXPai7ZWeHin0CrlNPHaiKvWRz33/YEz3/Pn0qYyPRwvozES//fDuEujasjf6C1yobyFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_find_biggest_system_ram() sets an 'unsigned long' variable with
'resource_size_t' value.  This is fundamentally wrong.  On environments
such as ARM 32 bit machines having LPAE (Large Physical Address
Extensions), which DAMON supports, the size of 'unsigned long' may be
smaller than that of 'resource_size_t'.  It is safe, though, since we
restrict the walk to be done only up to ULONG_MAX.

DAMON supports the address size gap using 'addr_unit'.  We didn't add
the support to the function, just to make the initial support change
small.  Now the support is reasonably settled.  This kind of gap is only
making the code inconsistent and easy to be confused.  Add the support
of 'addr_unit' to the function, by letting callers pass the 'addr_unit'
and handling it in the function.  All callers are passing 'addr_unit' 1,
though, to keep the old behavior.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3925720a172a6..aee61bf991baa 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3056,31 +3056,44 @@ static int kdamond_fn(void *data)
 
 static int walk_system_ram(struct resource *res, void *arg)
 {
-	struct damon_addr_range *a = arg;
+	struct resource *a = arg;
 
-	if (a->end - a->start < resource_size(res)) {
+	if (resource_size(a) < resource_size(res)) {
 		a->start = res->start;
-		a->end = res->end + 1;
+		a->end = res->end;
 	}
 	return 0;
 }
 
+static unsigned long damon_res_to_core_addr(resource_size_t ra,
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
 /*
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
  */
 static bool damon_find_biggest_system_ram(unsigned long *start,
-						unsigned long *end)
+		unsigned long *end, unsigned long addr_unit)
 
 {
-	struct damon_addr_range arg = {};
+	struct resource res = {};
 
-	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
-	if (arg.end <= arg.start)
+	walk_system_ram_res(0, -1, &res, walk_system_ram);
+	if (res.end < res.start)
 		return false;
 
-	*start = arg.start;
-	*end = arg.end;
+	*start = damon_res_to_core_addr(res.start, addr_unit);
+	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
 	return true;
 }
 
@@ -3110,7 +3123,7 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 		return -EINVAL;
 
 	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end))
+		!damon_find_biggest_system_ram(start, end, 1))
 		return -EINVAL;
 
 	addr_range.start = *start;
-- 
2.47.3

