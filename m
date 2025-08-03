Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62043C87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 05:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F496B0088; Sun,  3 Aug 2025 01:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1096B0089; Sun,  3 Aug 2025 01:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFCD86B008A; Sun,  3 Aug 2025 01:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C187B6B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 01:30:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86D4081056
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 05:30:33 +0000 (UTC)
X-FDA: 83734321146.03.03A368B
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1464AC000B
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 05:30:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ivfNHzAc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754199032; a=rsa-sha256;
	cv=none;
	b=XOFPARpWvFOr0/hYZO14mPYmDL5a1EKsYhTivRDyibl9LSw4H4bPLuZlaXoie+Psz8jlp0
	zoxVr5dRAJlDTuVTfA5zLu41cAFpQfg6VNn6VBFrpXZXuVmF5RA0fa5nn4Wq6/zViw/Yhw
	d13f03dKuuZVv8r0ehDCiFLsMDD5H8s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ivfNHzAc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754199032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xgsR1GfKsfUlPsLZqhHD+dTNnyvmQNIFW4Iwg9nnK0=;
	b=nSVKVb1LzoWhFuUInPZzJHksAgjpD9CZiPPqTgKx4uZYhJSOJS6LtIIU55CAmKt4rsV7Ja
	UhwSHoUXAJPlCElfgkqsxBv0euWXLtgHrel9EpkNatUg2DQ3ptkzi31Lu+bkVLnW015a4h
	FJLKx5FxIFhVTXkmprHt8Zl6JNGEGsU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 5C325A4BEC5;
	Sun,  3 Aug 2025 05:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7164C4CEEB;
	Sun,  3 Aug 2025 05:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754199030;
	bh=MkwO48Cyq60e/luJ0nQYGYvpsWKdgTiBB5C4p3DKei8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivfNHzAc1rwjUJFCGtPL8tApG/XuOXeS2VvqyWoOX//q5MUOo+SWhrMnBsDgpIZkD
	 uy+SD0aL/8W9qiL1cXrOG/G0Bp2Y92eGxfccKlHNi4HsMHT/tybAkCCzZKnU6BtkNf
	 ips0BPijRsoXaxnukiQ0AUiMqYrlZ5ZuG8RSy8WMm0y9zQkZtbeuY3RpRGN/UEqbKx
	 ZHBLFFk/QC+yd5M7JSLBON5JcnsIcnctvKWN+07NxmmTOx9OncMpwMeAu+aWUI/LqD
	 9ZF96LeXYL36a1Hp6yVXzOix5ANTubUdT+ogQPsqQ2H1IeNu1P1XDiHHbLxXcAFIrm
	 tUnAadYcYFokA==
From: SeongJae Park <sj@kernel.org>
To: Honggyu Kim <honggyu.kim@sk.com>
Cc: SeongJae Park <sj@kernel.org>,
	kernel_team@skhynix.com,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Date: Sat,  2 Aug 2025 22:30:27 -0700
Message-Id: <20250803053028.51309-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <68a36ae4-5dc0-4023-b850-2af0401d6d75@sk.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1464AC000B
X-Stat-Signature: i183md493ei55eqxhy757em981xj5fgo
X-HE-Tag: 1754199031-100263
X-HE-Meta: U2FsdGVkX19mVNzPiYzlXHUMOuS8bFibyIh9NQiQ5XTDKRECLM6qX+M0Bpr2KiEx3C25ZLOf65fdRhbs0yxtlO2f1uMzS93hGafailizUz0FNpMM51N7Fc1YKILsalTbUKcOt+1R4uS55Auc2QPAS/0PlA1BYPM4r4XxhLA36kk2Z5ETjmoUei6kTdrOtvWsCmWmAvUP35l3loqSe9L54XlN77SWHkj1WkOjNQYJzCHwhQ1jcfBwZZQPS0eIallRfX8Ld5qKg3wZUChFXMCPmmyMXTv8QtZIT9J35vdzWN6s/GTddgzB82T/lcWrGWnvLc9RUC2t4wW+FyDeBMKMLD8ImpuBsz3P5CoNz+YxO0s/35i7U+FtbQXtAHTQSEetjZbZm46N6Uzcqcg3fGQNt9oDdp8iVfvvi6pB36A01tJxYAUtHUCIpoaOq6XE1m7y9/lynesJqdY/2WyxhT6RK/DzZqiVrncHpkbZhzYzGP9g2vjbZKqS1aJ3R3tsVrKv90xGbEiAyGHi4p/2lf7noq2T6MZk9YZHPtTX7CWq+Nv80HsljKIVLuRAP8Rccdzgd20Z19XDoHYDwWE20YK3LuUHfQseJuNXpryjxJDhcPmYV+ukzLr5CTjVKk1JjrUr8X+FN/kQGyzXKkzBBLNn0zRm0zWIMosd8TqflokDQWah17ygIfqDA4acw9wC9dED4QVrRBtOx/QCg/XwFKAdE+i+nL+CuO7broWhIH/A9ESGt5Rj3DocYqDj3XeG36VOv+hoLH01RBvN6eo4Pe/bEvduZ0Bl2v1RiEidyAh1MXeUQoZxb1o6HIYnJFzdWhb1J/+SLZFZMfsbgmWffxPbgUabiu2GeUoWnX6b1Jfgz+QjJf4X3o6YMbLNaknf5BYpvpNTk+7kGTavWyeeslaarCOaafpxzdFMSk9p3NDERg5DcwnDEk4Liw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 Aug 2025 13:43:03 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:

> Hi SeongJae,
> 
> On 8/3/2025 1:22 PM, SeongJae Park wrote:
> > On Sun, 3 Aug 2025 11:03:12 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:
> > 
> >> Hi SeongJae and Sang-Heon,
> >>
> >> On 8/2/2025 1:50 AM, SeongJae Park wrote:
> >>> On Sat, 2 Aug 2025 01:11:09 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >>>
> >>>> Hi, Honggyu
> >>>>
> >>>> On Fri, Aug 1, 2025 at 8:35 PM Honggyu Kim <honggyu.kim@sk.com> wrote:
> >>>>>
> >>>>> Hi Sang-Heon and SeongJae,
> >>>>>
> >>>>> On 8/1/2025 2:58 AM, SeongJae Park wrote:
> >>>>>> Hello Sang-Heon,
> >>>>>>
> >>>>>> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >>>>>>
> >>>>>>> Nowadays, damos operation actions support more various operation set.
> >>>>>>> But comments(also, generated documentation) doesn't updated.
> >>>>>>> So, fix the comments with current support status.
> >>> [...]
> >>>>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
> >>> [...]
> >>>>>>>      * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLNEED.
> >>>>>>>      * @DAMOS_COLD:              Call ``madvise()`` for the region with MADV_COLD.
> >>>>>>> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEOUT.
> >>>>>>> + * @DAMOS_PAGEOUT:   Reclaim the region.
> >>>>>>
> >>>>>> Nice!
> >>>>>
> >>>>> But doesn't it make confusion about whether this pages out to disk or does
> >>>>> demotion to the lower tier memory?  It's because PAGEOUT action doesn't do
> >>>>> demotion, but it looks "reclaim" includes pageout and demotion together in my
> >>>>> understanding since /sys/kernel/mm/numa/demotion_enabled was introduced.
> >>>
> >>> To my understanding, DAMOS_PAGEOUT can also do demotion when demotion_enabled
> >>> is set.  Am I missing something?
> >>
> >> Actually no, please see below.
> > 
> > I'm unsure to what point you are saying "no".  Are you saying DAMOS_PAGEOUT can
> > also do demotion when demotion_enabled is set?  Or not?  Could you please
> > clarify, and add more explanations about why you think so?
> 
> I checked it again and found I pointed out in the wrong place. Please see below.
> 
> > 
> >>
> >> do_demote_pass in shrink_folio_list()
> >> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1122
> >>
> >> The do_demote_pass is used here.
> >> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1293-L1302
> >>
> >> can_demote() implementation returns false when demotion_enabled is on.
> >> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L350-L351
> > 
> > I'm again get confused.  Isn't it opposite?
> 
> The thing is that DAMOS_PAGEOUT call sequence is as follows.
> 
>    DAMOS_PAGEOUT
>    -> damon_pa_pageout
>    -> reclaim_pages
>    -> reclaim_folio_list
> 
> In reclaim_folio_list(), it sets "no_demotion = 1" in scan_control, then invokes
> shrink_folio_list().

Thank you, this clarifies.  DAMOS_PAGEOUT doesn't demote pages even if
demotion_enabled is set.  Thank you for enlightening me.

So, "reclaim" means "reclaim".  shrink_folio_list() can do demotions when
demotion_enabled is set.  I hence still don't think this patch is saying
something very wrong, and how it could be improved.  Do you have more specific
change suggestions for this patch for an improvment?


Thanks,
SJ

