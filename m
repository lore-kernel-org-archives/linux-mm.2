Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99F6CF3ED6A
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 23:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351FC6B0089; Sat, 11 Apr 2026 19:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBCF6B008A; Sat, 11 Apr 2026 19:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2119D6B0092; Sat, 11 Apr 2026 19:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 137F96B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 19:34:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EBF114012B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 23:34:41 +0000 (UTC)
X-FDA: 84647881962.27.444BA10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DEACA4000B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 23:34:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6X95oTb;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775950480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Clx8Snq53we6+HtY+eAaVrHa74a1ZGYolkfOQUgr3KQ=;
	b=N3RLo0lGLL/4rkj6lR5onIkLooTRcoumfn/8rnpXftNu5ppVkKhC2guV6L7nCGcK4M1DZ1
	sSLGBYoxdUl0a7WUdKcR3+lYInk+vNQ6sMkDIE5DrwYGxhl1lz8vuYwOUREwfvWODRqaea
	DQ88ZDNeVsHl35pvBLRy/8aSP8g5nxA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6X95oTb;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775950480; a=rsa-sha256;
	cv=none;
	b=KiuH1UhbQCY2xW7Lod1G1qQ/gTuHBO2qMzH887yh+mG7sdWWRuNsJHDwwwPQXnQv7NiaUF
	kKmlWDp+XsYF1B5uuBNiZsrVrEzXtopqR+MeVmoI/VPfZY/eWqPBOlvVgOU/4CUzUXxALC
	F9zUZ4uwOxbYGD2Arpq2LfcUeUF4J7Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C4FE41B0B;
	Sat, 11 Apr 2026 23:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5133AC116C6;
	Sat, 11 Apr 2026 23:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775950478;
	bh=6hgRkVSjVQ54vQbr1xRhJZ/6jdyx+6uY8s9yPTjVW2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6X95oTbOAS3XyTF0Dmt6wrD17Kvgl97r+sYxRrN3bzDEaNkg+d2uLZfGFngtgb9a
	 rahioNH2tDN2hSjLgrp49QPC5chnLUOXdclMlOl3EjWCR6AJ4JG0XcB9mtn2e63AaN
	 9G47GhDisB6kb4+bOH4cqao/EDJW6bTWRbh6H8QZ9S8Nc7AhbFEnaQGr3V8e5fn+2E
	 PrLcdPKyHMukj0XKaa2J57USMBGYr/JI4xH9Rrja6wYCd89g0p/ZiJfo/rOnyacf4U
	 HpW0xB1QdECfsjlYxYkgro8hIeY7IBCaw18ZNWPUzB28ARfFk8X6wf8Bf33aTzR7/m
	 2LxJ5v/6Im24g==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon/core: disallow non-power of two min_region_sz on damon_start()
Date: Sat, 11 Apr 2026 16:34:30 -0700
Message-ID: <20260411233431.78220-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411213638.77768-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DEACA4000B
X-Stat-Signature: rugkzmt73rspg75ge4qeh5h7kkbpxbk8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775950479-675542
X-HE-Meta: U2FsdGVkX1+/R11UbiKNOovY2Fnu45y5k7Jm34QycdGX2s156rDYD598pB01TTCaom8Txus7VplyXJYZV/TIOe5DT++kgu5feh+ReymAs+3YgjXpIcgDmwuo5sY/GJbwWDWMiMkexwRqf0yBWKncNJKh4bQ2JjOUCBxu7ziqqvjUmNiOlNexsUcbsVaswM+dpoGL7bs8NXmEY3YBQgnfezb4TFlsQwnC8x8xiIdt+i8vKjD6NSyUA1SIAsGa/ae/Em/sTndr7tyk8XTRpGIKUMOkRogSQhqjJPGUdSPoNx8Gh1OEG58W6el8GbKDwotmysSkr6e6VkBNJHpzt/shqNyQn/Xqvs/CHkJ31ybWed+/FUtCRHPeF/GOlorTLvW8CZtx0JPc4IDHlohvUQ4T/tcVzePdRsrEBMGGYgITjEg+c9Lgdas0SXZiIq+Wi/s+wrOfPJ8/F/T3vlWvzAI1RFxIcgysCT6D4r+08eMvm4J7xvUiFgCK5w7aJjnufqBj1rP+5W+tTDJ35NayKFBSccOIaacecFwCO58V4rOl9vSfsEjaIriH5NyixBdbSnK1H5ycejCqH3bpBy4bAKYO5kV4UY4s/x7mC5IMsO/uz+AtgiBtNR7Jf6PWUDlunHUg9EirURamwAfeL5zn7wezqt//SRZfP4ra4rLk+iuo2SPah+VmDYQ2fVQQyZOGMUw1oQNYNtaEi1PMf6utizMS/UJis/WY2N2zLjSALY8eB1meTWP3InDP1CqCI+CFA2V2SBc7vVmNIRtgbZrAvd+f/E4k1RD8uvar9aLYnES+yx/XSsPPnhUPRSDO/n4+da8lCGON15La8RWLKeP0ATwmzVK18XBCZmK61VSLJCgU9c9SKNaulCvnCZ7TpVSR0/xLypCN92rdRFYv6wgq8Q+nuSYG/LGEzmCp/UYcLYfggIm0oaZkiUNyPOVFAxIjjg2fVrm3aZvBllXwWbuxHAG
 1KvMfQZE
 +gYLPNO+q7SB0VFlR1ZaAEMbQp3sJR4t//rBF0PIJ5epfS5DoEiYgc6R2mkbloNdc/3vS4InvE+8kvn0dEcTGjkGluqyliTnHI4ttt0krUMRshjVN2t6Hwd7/8IXvtAUez8H2PLHFz8NKurZVt4nPbsDfOPchYyPU7/wL+CMw7jNmgCSHiDm9tuD17pavDv8DjlQf4dkHsMA/x+R+//y5eIMrXCjhxo194vf+9QIT1Bko4JM4wrFUzPGq0og9ATMc/Oz5XYWrFvy7Fdn9/fQRXnepvZ+sU7zoqoH1uQMscmXHkjUD7mF5fo+yWlIrnNFXCW6qLf1cw/YeIQD7oXB6gTEt+9XnA4BcmkBUDlzCbPUYBUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found no blocker of this patch.

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260411213638.77768-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit a125056db470cab021e84ad481a0f51ddfc426c2
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: disallow non-power of two min_region_sz on damon_start()
> 
> This commit fixes an issue that allows unaligned DAMON region address ranges.
> It adds a check for power-of-two min_region_sz directly in damon_start()
> to catch invalid configurations from the sysfs interface.
> 
> Link: https://lore.kernel.org/20260403155530.64647-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 3703f62a876b3..c107d74c77e74 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -1368,6 +1368,11 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
> >  	int i;
> >  	int err = 0;
> >  
> > +	for (i = 0; i < nr_ctxs; i++) {
> > +		if (!is_power_of_2(ctxs[i]->min_region_sz))
> > +			return -EINVAL;
> > +	}
> > +
> 
> This isn't a regression introduced by this commit, but modifying
> damon_start() brings up a question about partial failure handling when
> starting multiple contexts.
> 
> If __damon_start() succeeds for the first context but fails for a subsequent
> one (for example if kthread_run() fails), the initialization loop breaks and
> returns an error:
> 
> 	for (i = 0; i < nr_ctxs; i++) {
> 		err = __damon_start(ctxs[i]);
> 		if (err)
> 			break;
> 		nr_running_ctxs++;
> 	}
> 
> Does this leave the previously successful kdamond threads running without
> stopping them?
> 
> Because nr_running_ctxs is incremented for the successful starts and
> running_exclusive_ctxs is set to true, it appears the internal state
> would prevent starting new contexts.
> 
> Would this result in all future calls to damon_start() returning -EBUSY?

Yes, this is not ideal.  But as Sashiko also says it is no blocker of this
patch.  I will revisit this later.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260411213638.77768-1-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260411213638.77768-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

