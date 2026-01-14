Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0CAD37E3F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2026D6B0089; Wed, 14 Jan 2026 10:20:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1840A6B008C; Wed, 14 Jan 2026 10:20:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BADB6B0092; Wed, 14 Jan 2026 10:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F08246B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:20:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85F728BFE6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:20:58 +0000 (UTC)
X-FDA: 84330932196.03.4FB8BE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B153214001C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:20:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CoVWVWto;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768404056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BE+dSupHqcy3zUsEyof1iEo44gy2K6FXsNqqEaEd8M=;
	b=zcuHkHKKhbcATHjNnSGtDkmkZC/6hFEWPxP3CM32EOI+2CLDnpfANMn3WL9smnzwO2Sxpi
	/5pGOFqnYTGwwWRPFmPdSIQxxREGzmFITmooV/V8As6gMMZErdzDgqBFCgiqXq9puPDSU0
	TdJyDmiVg6mX3dHEoAgFc1AWt6VYruU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CoVWVWto;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768404056; a=rsa-sha256;
	cv=none;
	b=FH/stZRUG+P46uZjXe01FCNW543Jpjp0Qx2/wSaKaEmQp+zyyL+06/tVp47ktLgAYnnPzQ
	FWiYfmvY6JkyBFP9Ht7pomjEmBSnlAw0apf2LUUgwmtbfDykH5EngGxgqQsK5yG6lc239U
	AytxHTIhB/LXiwyIjpuq3BuaaxcPomc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D852A40611;
	Wed, 14 Jan 2026 15:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98387C16AAE;
	Wed, 14 Jan 2026 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768404055;
	bh=D5tB8wxme+mhdJymsubX32VBj8KaE1ZvdlhzozuhqS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoVWVWtoNYSIuaM67czxWeeltkCUUM80TykrLoivBpiUQqYxmyWbnuHJnKczmocJH
	 8ocxMluyjqNFYjFautQzhwSISBzNuifxGxBl9smTmeva7k2IsUuzDG0ieIzKMseJXz
	 nxFWOMJhyK8cEDM/9V7VR99FNq5YytDF9ncfv+F+jDejbMJQVrOr48Xm1OzLFMWeiE
	 Ot/fX6A4c2ETe+rlKCRiyZ/Ef0t8rzFPicEa0EtWjA1LbPDCRY4LBMglfvGzr8JNNI
	 ezoyqtnr6hS594O2HbIMd0j4QL6D4T/hAZc46Teem52N+zfOnJyGyFN/nnL1IgfQrm
	 uwBDEOX6o+5cg==
From: SeongJae Park <sj@kernel.org>
To: Chris Mason <clm@meta.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 01/12] mm/damon/core: introduce nr_snapshots damos stat
Date: Wed, 14 Jan 2026 07:20:48 -0800
Message-ID: <20260114152049.99727-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114122959.1164957-1-clm@meta.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5kzhwf6itf7t835srimhdxypmszs5s9p
X-Rspam-User: 
X-Rspamd-Queue-Id: B153214001C
X-Rspamd-Server: rspam08
X-HE-Tag: 1768404056-528791
X-HE-Meta: U2FsdGVkX1/oivxV4SSR/m2bzCeb8FDNx1OFoMZeOD2AZoY2xakcdrNtdn5hD6IrT8DDQuB/c+AgVFk6UrvQGmvmBmojgGGPM/yF1FBuo+RU3srwHhv7UuN31cnQaZkwEdYIojW/GMSKRlSECM4aUM7CelgRJk51AJtkpB92X2W7cg6n13JYmU+t/nOxijH06B6I+iwPkn7M/y7z2l7J39iBjtV8yeRXVrcyv8QkTrAuBLBMdYA+zUJiWp7ZFDfKZoihJAmGHgIewMWtLjFeF9fwDq5IrOEwcq5V+Vi5oK6fhYObc9uTOzMK/LpRsaWdBKYuz1fqbxA3kyb/Uv4ScLOSYHNWkiJ186oe9Ha208qVfg67Ino/u7drGw81zhKqkHGt0ZpKak0TynInBh+OeFnZRxGnPRYY3XfZ4hnbvrkPU1RBpfdO4av9WzjHFRUpq12NFKTx/hKFFtrVmEYw/8F32DpOILhxZzromv+QThT1MBe92M19FY9W6evNTLp3MjPMm7oMu94dQmHbqrqct2cdc8+4h8BTWzt2siAmdWHzuqP9erQsx9TgiT60A6h+23YrxdeDpWZMCEj0ldRt3q2n2Xl5HnBncjzOLtRSavWpmWEdvbk/E+E4wWO1GCBtWWcCJ13ZLG8cz1O/6oQnQBTggPhl2aI3jqHcPvIvcvmcwwwdbevqcHF0vXfoSAAvs1NN+b+SXuqTLFZcTLxlflnRwskns7GAomzqDwqaA3ByXae0zqNYgFS9YnHtvpku9ck/yCwvoDMbM53URay7GDjXl8z35B77WURhBCx50Tq3F/4q4MtAOoaO6Fg4XxgFAz8J3krqT1oNfPxRQJHQ14ojvFxE1GWwGOvGGlvy42NTRgmfCNaOKILYYBw//OoVCzEiUVnqDC4CUdevmQtZ0wAoHJ6Xs3VKNq6TX90uSS+bQU1wohumZqXbVOA40DbFtoBZYhn/xBSMtxLyeY9
 Gx7AAd83
 5o7SsNOFDHKpkFG4KFCCEBvNX8DSljdKa72ETg7TeTPKjDf/NHkVfoCW8Ohl9D7iU1nQRTN87YAiwD/VtfIOCrlpNJoFbnBndJSHoFiux8ob01bUkcOXeOuNvy9GjYHMlBU8k+xzcw4mU7QXiEV7CRFzVdLUe+qbVjT4eTAG2Rz0CfNLmJKVRQbhnelVe686ymUUSOxorDzOoE5MCQ/nCmm3yyCpLd4o8slYZhvlKVc+jlhIKn9XflrADlAJkFnp4NgrfR/fOarfJ4jct3Z++2jSLKw05/HppC/CcKWh1a96eW/wrbrxvXUpko77Fb0sG8ZwWO3BSeGsuUQE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 04:29:56 -0800 Chris Mason <clm@meta.com> wrote:

> On Tue, 16 Dec 2025 00:01:14 -0800 SeongJae Park <sj@kernel.org> wrote:
> 
> > DAMON generates monitoring results snapshots for every sampling
> > interval.  DAMOS applies given schemes on the regions of the snapshots,
> > for every apply interval of the scheme.
> > 
> > DAMOS stat informs a given scheme has tried to how many memory entities
> > and applied, in the region and byte level.  In some use cases including
> > user-space oriented tuning and investigations, it is useful to know that
> > in the DAMON-snapshot level.  Introduce a new stat, namely nr_snapshots
> > for DAMON core API callers.
> 
> Hi everyone,
> 
> I ran mm-new through the AI review prompts and this one was flagged:

Thank you Chris, this is a very helpful and great gift for the community!

> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -157,6 +157,12 @@ void damon_destroy_region(struct damon_region *r, struct damon_target *t)
> >  	damon_free_region(r);
> >  }
> >
> > +static bool damon_is_last_region(struct damon_region *r,
> > +		struct damon_target *t)
> > +{
> > +	return list_is_last(&t->regions_list, &r->list);
>                            ^^^^^^^^^^^^^^^^  ^^^^^^^^
> 
> Are the arguments to list_is_last() swapped here? The kernel's
> list_is_last() expects (entry, head) but this passes (head, entry).
> 
> Looking at include/linux/list.h:
> 
>     static inline int list_is_last(const struct list_head *list,
>                                    const struct list_head *head)
>     {
>         return list->next == head;
>     }
> 
> The current code checks if t->regions_list.next == &r->list, which will
> be true when r is the first region in the list, not the last.
> 
> Compare with the existing damon_last_region() in include/linux/damon.h
> which correctly uses &t->regions_list as the head:
> 
>     static inline struct damon_region *damon_last_region(struct damon_target *t)
>     {
>         return list_last_entry(&t->regions_list, struct damon_region, list);
>     }
> 
> Should this be:
> 
>     return list_is_last(&r->list, &t->regions_list);
> 
> > +}
> > +
> 
> [ ... ]
> 
> > @@ -1978,10 +1984,11 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
> 
> [ ... ]
> 
> > +		if (damon_is_last_region(r, t))
> > +			s->stat.nr_snapshots++;
> 
> If the list_is_last() arguments are indeed swapped, this will increment
> nr_snapshots when processing the first region of each target rather than
> the last, causing the stat to be counted once per target instead of once
> per complete snapshot.

AI is all correct.  Note that this is not making user-visible issues, though it
is clearly a bug that better to be fixed.  I explain the reason in below fixup
patch.

Andrew, the commit to fix is in mm-unstable.  Could you please squash below
attaching fixup to the commit?


Thanks,
SJ

[...]
=== >8 ===
From 551b89fd05f0c40c824d2a5c0ca6c2a63766fbab Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 14 Jan 2026 06:57:38 -0800
Subject: [PATCH] mm/damon/core: fix wrong list_is_last() call in
 damons_is_last_region()

damon_is_last_region() is calling list_is_last() with swapped arguments.
As a result, it works like damon_is_first_region().  Not that this is
not making user-visible impact, because the function is only used to
increment nr_snapshots stat once per DAMOS' regions iteration, and the
stat is exposed users only after the iteration is completed.  That's why
it passed a user space test.  Nonetheless, the bug is a bug and could
cause real user issues in future.  Fix it by correcting the order of
arguments for list_lis_last().

Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/20260114122959.1164957-1-clm@meta.com
Fixes: bbb3a45f1923 ("mm/damon/core: introduce nr_snapshots damos stat") # mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 385900733a0b..5d7e58cbd9fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -190,7 +190,7 @@ void damon_destroy_region(struct damon_region *r, struct damon_target *t)
 static bool damon_is_last_region(struct damon_region *r,
 		struct damon_target *t)
 {
-	return list_is_last(&t->regions_list, &r->list);
+	return list_is_last(&r->list, &t->regions_list);
 }
 
 /*
-- 
2.47.3


