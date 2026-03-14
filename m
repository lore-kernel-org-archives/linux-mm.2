Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9320107BCEA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A9A6B0088; Fri, 13 Mar 2026 20:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B706B0089; Fri, 13 Mar 2026 20:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17EB46B008A; Fri, 13 Mar 2026 20:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0511F6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:36:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CACE13AB4B
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:36:37 +0000 (UTC)
X-FDA: 84542802834.14.82E8897
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C2B6C40006
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:36:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NXyJMDzQ;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773448595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zR8A4LwqtzNeV7v2ENMNYUy6hadqlaIs2hPGzsU7sCI=;
	b=iuYO7BaD0Tq3URkh87ZJVylyAl4/hM/9X9JWb+fVffz7fExR05P7JJ3YGplLhRWlflXWKL
	jTdvKGuGHFOsPt9RjIM0mGDxewzSffbiUL4kjhlHOrCAzUT988I9lQQYfPwu/LzcS4pNUw
	GRC4qSql4pg08mN23Gl9NNyXaUxCa3s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NXyJMDzQ;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773448596; a=rsa-sha256;
	cv=none;
	b=MSu9TZvS+vClybuvSbv2Bz6fFYvoa9Rne2Q35HYlahx8HZNFEXc2ZbrjNwbtntCGJQs8xF
	HHblgTH/fIkgcHiEAoQInbYQ/i22LVUEpiz9s1Hfcxdq4amkUaC0Ks+SLUiydE4RNSq2cT
	U38s7TsXX/6cWWo8jZiGiZeyBSCvIjg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7A9F41A8F;
	Sat, 14 Mar 2026 00:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8326AC19421;
	Sat, 14 Mar 2026 00:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773448594;
	bh=FowyrWUPuB+tCjsK9lYkRm2bV4LqWIMEHeyNsO7g9Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXyJMDzQX02Gd4BouBC03Hr5qQIcmmWyOuKp6xs0qijRdX7gQjQHsSx3x3Mb9uL4v
	 xH9oB2aT7KFxmF8WM+M3R+WmMucOjIIOArKqLmnpzRG/dAj59gM9qQtDQboVIG8MdO
	 kkzJGzjFy2huALBnU/wxkCzchnR4wereOemiTF/077M8NoKv5S2flAB/jXFDwxjgnX
	 +MnfiOq/vbbfQFbCW6ds0+ro/QL3RPDimUxx4CPOteO988ebzKeVUmbCJZLLMubZ+/
	 MOXp+Wk/HjLaBMl3YAp3hqTqEhVwHdSL43XDrFqoH+GS7xImFCgXgHSYDNzG3iUzZK
	 oiZMFF/TJNayQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/stat: monitor all System RAM resources
Date: Fri, 13 Mar 2026 17:36:20 -0700
Message-ID: <20260314003621.80567-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260313234026.48872-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bzoqw9qmwamxzjaz1zk68dxsgf87w3ux
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C2B6C40006
X-HE-Tag: 1773448595-13082
X-HE-Meta: U2FsdGVkX1/892A58DeiLeCM6ULA4Wv1hTABQK80q/MdNSXbHZ0BsmslCcVXQV92ZQ8x5UDfF/U05bdPUFOK1/zyX5faDiy0U+w4AM/PtbXQdAfXIKxjcSvXt3V5m46uT2Q0lBLaF0ocdSr7AYiHWjlp+3LRNSRofszL3nHWddBhv6nuxkDEJF69qL+dBo+ad4cw/8JeU1L7Pz7sBF2Jw+DjMpg4RzNqyvJUELd/cPvbXdY6rEYSblVq7k8SR/UXYmDdClCFwULONGTgy03xV0L+pwwgvkM5cjkIKpfH4s64j7OXwuIwE8z+nJGLCrzC5ptjZENlAWBOa8LIaU+BF633xe1PZtrIsw2acFMC6lH99SL2NwNMWOIJF33fYVIhwGiElVmJJktA1aHH+7eo66dPz1RaLkKToxyFsHNG+pwXb1g0bt81KFPCxHiRNOc0XB8AIf572h6Wq0ZpekXtieCzmJ8GDO+V0bs4thv3gVJBUVyov/f8U20nn3ot8lg06peHXZUKrqEdJxOuA8oauRkhcZgfEeSN37di1GbVZ0uStaZ1diogN1WKGFCM5IBipRrGvt+1edAdcr6ohRdwCv+3ygG5m4GDmurMV7fIF9IjZ7ejHPE41D92KFcvgTDIpRiclMMxRLFAREKKFLLeAo9H8YmdFOSfIpSXg0xNHP/k6vgOMrh1bIMO8uDq3C1amYl/C0nUs/fMm0rma1a2DG4b5q2qgIn/Pt6Sk0yCMBnTc93JQTuK/ciqFBnyNuXJWkP74RwHev7ChORS6t/1zfNClhKyA4oCUiLJoxWh8VywcO8WxCUL+nu7uD0ITF8FXBg/g1xNGlkCDvO/+Rv8UjrfdMdRH1e+JaEFnMaaRu5g2QWrW0DXXFL0/irlOfm7+QdhPTeJXnWflnweERHZYQ4chyxNOiBwrHalXpQ0HepMRtFY5p7GPRQmsSsFun/8PFeFTSXJWmXTMtxbj+Y
 n1XtxEtK
 kZlwB8cRznF77atqS1O1CmiYxL1LmswuCpPp/WwFYzVa17O3pmlrgZ1m5OyEgo18jE6HUs49kgI69ozaQ073faCqY5fPk2+OexrJfeWsBiehHh6HD9FTrFYb/7u2sGECqnNEwIHtTXhD10JPt1DAxkq1h2Dhf/u/81ppZWlsPxR4HIiEGKuWQU23RDepUd37DGw/IIS7byvQ957BqrnxwBktmEOSGbBkTC5ayikFJ58VxcT2WEd5tVwXbYQxkNA3VqOYvj5koixdaAYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 16:40:22 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 12 Mar 2026 21:44:47 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
> > says it monitors the system's entire physical memory.  But, it is
> > monitoring only the biggest System RAM resource of the system.  When
> > there are multiple System RAM resources, this results in monitoring only
> > an unexpectedly small fraction of the physical memory.  For example,
> > suppose the system has a 500 GiB System RAM, 10 MiB non-System RAM, and
> > 500 GiB System RAM resources in order on the physical address space.
> > DAMON_STAT will monitor only the first 500 GiB System RAM.  This
> > situation is particularly common on NUMA systems.
> > 
> > Select a physical address range that covers all System RAM areas of the
> > system, to fix this issue and make it work as documented.
> > 
> > Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
> > Cc: <stable@vger.kernel.org> # 6.17.x
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  mm/damon/stat.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 48 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > index f9a2028483b05..3ed71db33e899 100644
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> > @@ -145,12 +145,57 @@ static int damon_stat_damon_call_fn(void *data)
> >  	return 0;
> >  }
> >  
> > +struct damon_stat_system_ram_range_walk_arg {
> > +	bool walked;
> > +	struct resource res;
> > +};
> > +
> > +static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
> > +{
> > +	struct damon_stat_system_ram_range_walk_arg *a = arg;
> > +
> > +	if (!a->walked) {
> > +		a->walked = true;
> > +		a->res.start = res->start;
> > +	}
> > +	a->res.end = res->end;
> > +	return 0;
> > +}
> > +
> > +static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
> > +		unsigned long addr_unit)
> > +{
> > +	/*
> > +	 * Use div_u64() for avoiding linking errors related with __udivdi3,
> > +	 * __aeabi_uldivmod, or similar problems.  This should also improve the
> > +	 * performance optimization (read div_u64() comment for the detail).
> > +	 */
> > +	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
> > +		return div_u64(ra, addr_unit);
> > +	return ra / addr_unit;
> > +}
> > +
> > +static int damon_stat_set_monitoring_region(struct damon_target *t,
> > +		unsigned long addr_unit, unsigned long min_region_sz)
> > +{
> > +	struct damon_addr_range addr_range;
> > +	struct damon_stat_system_ram_range_walk_arg arg = {};
> > +
> > +	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
> > +	if (!arg.walked)
> > +		return -EINVAL;
> > +	addr_range.start = damon_stat_res_to_core_addr(
> > +			arg.res.start, addr_unit);
> > +	addr_range.end = damon_stat_res_to_core_addr(
> > +			arg.res.end + 1, addr_unit);
> > +	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
> 
> The third argument of damon_set_regions() is the number of ranges (length of
> the array passed by the second argument), so '1' should be passed.  But the
> patch is passing 'addr_unit'.  It will not cause a real issue since the value
> is set to '1' in this case.  But it is an obvious bug.  I will fix this in the
> v2.

Or, Andrew, if you prefer to, please pick below attaching fixup together.  I
will post v2 on Sunday if this is not picked up with the below fixup by
tomorrow.


Thanks,
SJ

[...]
=== >8 ===
From e5f029441de038289320a7cb99a249800d99471f Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Fri, 13 Mar 2026 16:41:00 -0700
Subject: [PATCH] mm/damon/stat: fix wrong argument to damon_set_regions()

The third argument for damon_set_regions() is the number of ranges in
the second argument, but the code is wrongly passing addr_unit.  Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 3ed71db33e899..c5af8ad4bcb65 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -188,7 +188,7 @@ static int damon_stat_set_monitoring_region(struct damon_target *t,
 			arg.res.start, addr_unit);
 	addr_range.end = damon_stat_res_to_core_addr(
 			arg.res.end + 1, addr_unit);
-	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
 static struct damon_ctx *damon_stat_build_ctx(void)
-- 
2.47.3


