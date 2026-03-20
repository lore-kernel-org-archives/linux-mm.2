Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134C7109878D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79BAE6B0098; Fri, 20 Mar 2026 10:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7733C6B0099; Fri, 20 Mar 2026 10:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6897D6B00A0; Fri, 20 Mar 2026 10:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6436B0098
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:47:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0ADCEB6C1E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:47:45 +0000 (UTC)
X-FDA: 84566720490.28.57A5937
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6AC6E140014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:47:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UnBL06xQ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774018063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZq1cW/sqT9Pg+RwpnonA0kSbvdgUhu8wln+Ko+2Sh4=;
	b=ViVgOqKpwfe3A4uY1szt6HeNZQuVwy8mPnuTXCd/h4y6cdP3UOnjsYLJPFNYAuVaXRFTJd
	UL7hJGfFFJtNrLWnvGQKedtyu8OSa3b7vrqjtxC4SmOO2wiSCE2TQkqfuFLChDul5eUgYd
	sd559uZ+wbuyWMSyrO5poKhUKJjfq/4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UnBL06xQ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774018063; a=rsa-sha256;
	cv=none;
	b=ZSzn/2ysJsQIOCQ82xgdtvOJjH8H0Lcet3L9+qDv9xvH92XsBf2ka2574LOQ5sOMxUe1fz
	F9GCjINwUSEj1y7vHr1dcnXYDwNwq3JryrjG2aAEitHQM/jNy5wodywGupkoTuyACXPCe4
	Bh2VJ8D2FoDLBsVF0kOFJYNYn1Zi5mw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C87326185C;
	Fri, 20 Mar 2026 14:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7B8C4CEF7;
	Fri, 20 Mar 2026 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774018062;
	bh=xJo2T4vc+YcK0Zp0uhjPMvQz9+xZATwcssrwN2pYBAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnBL06xQzPc5XvlnrVn4NDvd8X+YFlTc/+xOq8Y+z/xBCzb4FFIy7PGInTy12pQGz
	 RfWdT6uiyt921qgEvimwLWKgRxVkX2SXGctJ93xh7hlfoILxeer9vvh+x3+Lobt/r7
	 v61g4JwXjHVsyRXefeaOtLHXGfKpvxDV95pKgrXvOgwvvNNHasnXdoa6RewHVaoLiT
	 F9JjfVfnCKwjkHAK4dIKdxhWc6P6qZkrG7jMb6ix3GpK0YFnktSyGbQFCqe1OSdKhi
	 sbVeGWBWdlQg5wpm+MQNKllgT4ZPmc6E5Bii7xz7UBX47nFQVfkMrCFElumW+CQl6H
	 5gh1uFWBtiCBg==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/damon/sysfs: check contexts->nr before clear_schemes_tried_regions
Date: Fri, 20 Mar 2026 07:47:40 -0700
Message-ID: <20260320144741.91848-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8F30B2A1-240C-43D3-B756-20E327F5BCF3@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t1m88pb8sup7zr7a8c4cc4rdtugf5fcr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AC6E140014
X-HE-Tag: 1774018063-58148
X-HE-Meta: U2FsdGVkX1/eV+m7N8zkBcxsWKGb2E4pxqK5T0jMYGAykwHaFibIX8fmgJeKxbWlBxFlj7jWtk14QG+qU5tTj248FV7I4E8vU2wfq8YQWwKgsRzy3kPBaqGrjiwuhGvvjeK1krVoJdhNjIq433E00wwlDvAYWVjosCMJmCONPFWP2DR+X9cSOo/Va9B1etDsaIkbJbYqVW7UgiUmRlSXzJ76MadIkv4M0JfrTaEWJhiaH1BsWN0JLYOXeQ66+zF622lvnrhK3XiMVx62DEP4ka9QtvHrGZzgMvuzqzxiCvTbZnwZsT5YE4lIVrVdsjaPoFdv7kVRux7nKVYz/vOcgOOHW07jK/OswGE5f4hrSVFOWi8AQsGfC4+dvcsN365G/TklUlPFGU4Ew8N6+PJSxPNdLnJg2/TXObkeUrJ6Hmkiy/QQTe/bIcxoU8PbCt5MbQ1inOyn5cBuXRjQH4qfhgEsQlxG9644rzRpNvkW6oCYXWFEhGpCf4hnGiZjgDB0QmHfRslrPaOWdXeussAY8DcvNx7TE1szwAmEh1pJfRLhpBCh+eQrMJ/3n700CwuvGsDieb9qOj/ooOmzMGjF6K1eOammTCnhqCtxHdD2CZsU3aZU8YOeN3B9y1bm0l7MbEU2bATlIJFigoO4gME9DR+JRWiaStj7IyJ6t7fVyYawo0S6VDhvRUvJx4PNko9AR9cKgweFKyCsQ8IxifRuSx6E865RWVkQHQtXHEGNXoghJJtbuhOsbjGDPlUrXor+KhLpGSnSOffwgQdcXKJrZJdrPMgRaF5K7IEFa5wGbL4iszwRmQzsckYA47ptDzOKJEh3SUHocNS1haUgBISDKoTIyfPYslr5S9AX+CKiwsUhRvf8O0j0Sf873FJS7AQrpvxDUSOJWkcDsEkhglWw5paA75264hmQyhHacYOmrHzFCfKHyLDZ93FCBGp78FHaWQXsNGcKwpvtVYrws7r
 iUjqMr/H
 gpXeB+Zg54UiRm0AhrJLjn/TXPwmq5yzqnAt7iCMMd8Tycdhd9h7GnnnX+M/OlDmq+SMa970f+TLreneABk9y+JGEx2w11TM1txqudYtKHLtMHznF/2iABJ/xNRg+/nUmNNb+uFq3flizhKjQhAtfJGOcQP0b/XQZX96DrBdswdurAUR/+tpEk+NwKG0xB2vXRoAlbWSypFq/ppCnYGdmUV4xGeL74kZ0p8UvxBxfoDu69n0MzTB3Xnyw2CD6TfKn3mjCFZZxBMTw/Gy1RYGun/rr0K4sK3iTC+KnqM4/NOzQERO2vRmICzYYedCMWHLxXw+Q1XbvhAA6QjzEeoQLPZmIs9piyMbCP/k7wyfdrFoHA6eJzr+1lHy+TRv7Z02sPpKtPrcqiC5lZag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 07:06:48 +0000 Josh Law <objecting@objecting.org> wrote:

> 
> 
> On 20 March 2026 02:13:17 GMT, SeongJae Park <sj@kernel.org> wrote:
> >On Thu, 19 Mar 2026 15:57:40 +0000 Josh Law <objecting@objecting.org> wrote:
> >
> >> The CLEAR_SCHEMES_TRIED_REGIONS command accesses contexts_arr[0]
> >> without verifying nr_contexts >= 1, causing a NULL pointer dereference
> >> when no context is configured. Add the missing check.
> >
> >Nice catch, thank you!
> >
> >Privileged users can trigger this using DAMON sysfs interface.  E.g.,
> >
> >    # cd /sys/kernel/mm/damon/admin/kdamonds/
> >    # echo 1 > nr_kdamonds
> >    # echo clear_schemes_tried_regions > state
> >    killed
> >    # dmesg
> >    [...]
> >    [63541.377604] BUG: kernel NULL pointer dereference, address: 0000000000000000
> >    [...]
> >
> >Privileged users can do anything even worse than this, but they might also do
> >this by a mistake.
> >
> >So this deserves Fixes: and Cc stable.
> >
> >>
> >> Signed-off-by: Josh Law <objecting@objecting.org>
> >> ---
> >>  mm/damon/sysfs.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> >> index b573b9d60784..36ad2e8956c9 100644
> >> --- a/mm/damon/sysfs.c
> >> +++ b/mm/damon/sysfs.c
> >> @@ -1769,6 +1769,8 @@ static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
> >>       case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS:
> >>               return damon_sysfs_update_schemes_tried_regions(kdamond, false);
> >>       case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
> >> +             if (kdamond->contexts->nr != 1)
> >> +                     return -EINVAL;
> >>               return damon_sysfs_schemes_clear_regions(
> >>                       kdamond->contexts->contexts_arr[0]->schemes);
> >>       case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
> >> --
> >> 2.34.1
> >
> >So this patch looks good as an individual fix for the individual bug, but...
> >
> >Sashiko commented.
> >
> ># review url: https://sashiko.dev/#/patchset/20260319155742.186627-3-objecting@objecting.org
> >
> >: Does this missing check also affect other manual commands?
> >:
> >: If a user writes UPDATE_SCHEMES_STATS, UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
> >: or UPDATE_TUNED_INTERVALS to the state file after setting nr_contexts
> >: to 0, damon_sysfs_handle_cmd() queues the corresponding callback via
> >: damon_sysfs_damon_call().
> >:
> >: When the kdamond thread executes the callback, it appears functions like
> >: damon_sysfs_upd_schemes_stats() access contexts_arr[0] without verifying
> >: contexts->nr:
> >:
> >: static int damon_sysfs_upd_schemes_stats(void *data)
> >: {
> >:         struct damon_sysfs_kdamond *kdamond = data;
> >:         struct damon_ctx *ctx = kdamond->damon_ctx;
> >:
> >:         damon_sysfs_schemes_update_stats(
> >:                         kdamond->contexts->contexts_arr[0]->schemes, ctx);
> >:         return 0;
> >: }
> >:
> >: Could this result in a similar NULL pointer dereference if these commands
> >: are triggered while no context is configured?
> >
> >Sashiko is correct.  Privileged users can trigger the issues like below.
> >
> ># damo start
> ># cd /sys/kernel/mm/damon/admin/kdamonds/0
> ># echo 0 > contexts/nr_contexts
> ># echo update_schemes_stats > state
> ># echo update_schemes_effective_quotas > state
> ># echo update_tuned_intervals > state
> >
> >Not necessarily blocker of this patch, but seems all the issues are in a same
> >category.  The third patch of this series is also fixing one of the category
> >bugs.  How about fixing all at once by checking kdamond->contexts->nr at the
> >beginning of damon_sysfs_handle_cmd(), like below?
> >
> >--- a/mm/damon/sysfs.c
> >+++ b/mm/damon/sysfs.c
> >@@ -2404,6 +2404,9 @@ static int damon_sysfs_update_schemes_tried_regions(
> > static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
> >                struct damon_sysfs_kdamond *kdamond)
> > {
> >+       if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
> >+               return -EINVAL;
> >+
> >        switch (cmd) {
> >        case DAMON_SYSFS_CMD_ON:
> >                return damon_sysfs_turn_damon_on(kdamond);
> >
> >If we pick this, Fixes: would be deserve to the oldest buggy commit that
> >introduced the first bug of this category.  It is indeed quite old.
> >
> >Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
> >Cc: <stable@vger.kernel.org> # 5.18.x
> >
> >
> >Thanks,
> >SJ
> 
> 
> 
> Hello, did you give Reviewed by you? Or not..

Are you meaning Reviewed-by: tag?  If so, no, not yet.  I want to get your
answer to above question first.  Could you please answer?


Thanks,
SJ

[...]

