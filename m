Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8EBC87FCA
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 04:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6436B0088; Sun,  3 Aug 2025 00:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80316B0089; Sun,  3 Aug 2025 00:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47876B008A; Sun,  3 Aug 2025 00:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFEAC6B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 00:22:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E4CE16063C
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 04:22:25 +0000 (UTC)
X-FDA: 83734149450.28.2D040D5
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4708D40003
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 04:22:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCcG1A2I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754194943; a=rsa-sha256;
	cv=none;
	b=nFfzPYfXogIiOvoThETPp+JSjPpXDMF+6Cw+7mOwDFcyuAM0/2nXUeH2ErhDS66Dw2BfNV
	kFHSAX4rggtJgEFLk4qqRnesUnxN8vcxHVK+Q9HZmGduuGkuRlZrPY9GDpvOu9SCkRWXnE
	80AmvdEt09GJyvYPQDokCmYnsqa4YPc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCcG1A2I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754194943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3WirzoXDcQuZeT/IjvUfRShis1ZBAwAXKZaiOZcl/8=;
	b=S9S8qsvn41Md8evpM/CuBx6a8K12XXPBG5GyN5VwZ4AOAnGD+bMDR9oXRk+/lCVoKBMvZ5
	DtJ0BEK6GMv2ZcTb01lHKMnlHNb1jDZHRRW5c89HlcZdeamjCYCb6smp+Hm2BXJ51UuMM2
	GiP8BsgqRCQbb4AnUTMjd/+TzqJihO4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id F414A5C4816;
	Sun,  3 Aug 2025 04:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49502C4CEEB;
	Sun,  3 Aug 2025 04:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754194941;
	bh=rU2/nZhmKJhBBZeJC/j9jwGy8NEdWAZKnIzen89p4qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCcG1A2IgXQrRkvTkY6jGec0AtgxPb/A4jhksq+t+uP7H/taHWvhMazC0LS0gF48l
	 HzUZOXqpfkisEiTkmH9Vd0opWkEd40Ngh/9IEWaZDk0RZjfuYckeUlKnEcwVoP1j/w
	 rPLYgp1+i24M4KDdrZWAk8MHujXNfhHwW9U/O63sWhJiaRsh2nLVq3RRP/pYA5smDL
	 CTI/xcZZ07R0v89rAWVQOMLvtmAxfKu9SxMe+taeduYGa9elwdwSvMtyMDwVCTwlcu
	 RoeAwLqZqCmrWFzgAdoM5lUu3OHuPOKXeWq7smETG+l8Qfxcqc83Uk5bm0V/UpZGI/
	 GsjtmUI1FrHTA==
From: SeongJae Park <sj@kernel.org>
To: Honggyu Kim <honggyu.kim@sk.com>
Cc: SeongJae Park <sj@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	kernel_team@skhynix.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Date: Sat,  2 Aug 2025 21:22:08 -0700
Message-Id: <20250803042208.50634-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <a31c84fc-71ac-4aa2-9bfb-123868a91cd3@sk.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4708D40003
X-Stat-Signature: cidy87eezugxufbp5b6fkh4yaq1k9d9q
X-HE-Tag: 1754194943-969789
X-HE-Meta: U2FsdGVkX1/1+3SybdR7dO1B/xd3KFLUft4bH4lDral6fvtscvvkg85VTe5MCLRMK4271YN4Sb77Tmm1XMYT13YLABQE43y6/6EMtWx/3AGszr1THJzZJFDkDjyMJZCpVf56/NkhjV0u1NsPuHJIyUSwn7T5q8XqEfwc1bUIWpk0ljRS0sxPYGsSVJyzHeiwppyvC60L4tJVJf16fC8cvlQF43Jn6b+HT8TZxBbNo0aIrB9+ewtNVxpycWF9D4mjeaEDy0orJOwKYZTy9r//20ZB3mLTpNVCTFataZWaBuX7V3SW+v6mFRECXxlrM6NDdNOqlf1x+qh4y3SpniZryyz4kX+X5im9E3PLlhncU0mxlsNm0+Ae05iVuLfDbv/I/av9v4p10CIBAhMFDr5sstR29rVPzbSTgxKsAEUv1052uNLBQFau6eeIrb/lptnQj+pilG0isiZPiqZ53EgqjOMr6i+CoDMtlNQInDqYWCX/Jd1l2OStt4oEj6P/3WcgaqGY9tz3MMaoStTSF50pcf8WCnSY4Ms85D+9Uj3RK5ExNQlUi7MPyumWLTFcX3MBT+cAa0/KqPo7tlYO+EHm8tBdwYSzFX3OcE7m6+ic2sb09x4x4JZhtfUK17vnI3YlDbA+eP7l3Sp/hwv9zhrX6ZvVgoZdLA53LJtg77c6ouaIhRt4gAySuXM85ox4B40WeM2SMvVFpkSUt7YSawK3jU6NGuMrDWYm+fa+pX2FYxLnStv2aUHy1qwiRaqFhYsKRNbcnfgdvceKQQ+AE0aOpH5kIIhH2tYl9XXunqidkbWHJfyTa9GzbOuhzR5TXB2gjLSJoJT7cKrYxy/8DLlY0hSEW/n8+mEIt6aNhKMUh+k6qtT4pz18lQ+S94JOlwpaT5wokJmGuImus1IO3+xCIuLJ3YckGeIGdr4VD0j85QbLup9t0ShSGh/lx6KlF9an9vIXBXwBLWW7H2eRiMC
 R00iuwuZ
 37Il8BgRsSR07stQmFLKtqASQupi4B79NQfz4FDcZtsnIO5jnF+3MPBX0lCV1SiWownqSwCs3Yf6EiNh98lWtZ8ZBGEq3APZwTOnkoknEkIIKEyGOjJCVyiZ4bO48tGDAqtvj2JPATJZT1V9Wp2G+jlEFBsQh0vARbXXERmg2d8NTEUhbzazULQk5Eq0lRb06G6YB0ql2aS3NVJvzSAEsyHGXCOVNKzwCZr2MpSyMfXlcn7os4WhlKu6aalUIoEeozFKzV7ZhtnKxpge5DiNOdcOTBj1CStQjL8cjpKxN/ZHteupnJ5wFKa+KAS9h7i+pG1q2cwoUdntzAXgRX7oaKcvHMrO6tiTpe3+yRhoOMGtIALcxGhwrP7GvfX23PTeD1GAiqdgBcHHUqMg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 Aug 2025 11:03:12 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:

> Hi SeongJae and Sang-Heon,
> 
> On 8/2/2025 1:50 AM, SeongJae Park wrote:
> > On Sat, 2 Aug 2025 01:11:09 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > 
> >> Hi, Honggyu
> >>
> >> On Fri, Aug 1, 2025 at 8:35 PM Honggyu Kim <honggyu.kim@sk.com> wrote:
> >>>
> >>> Hi Sang-Heon and SeongJae,
> >>>
> >>> On 8/1/2025 2:58 AM, SeongJae Park wrote:
> >>>> Hello Sang-Heon,
> >>>>
> >>>> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >>>>
> >>>>> Nowadays, damos operation actions support more various operation set.
> >>>>> But comments(also, generated documentation) doesn't updated.
> >>>>> So, fix the comments with current support status.
> > [...]
> >>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
> > [...]
> >>>>>     * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLNEED.
> >>>>>     * @DAMOS_COLD:              Call ``madvise()`` for the region with MADV_COLD.
> >>>>> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEOUT.
> >>>>> + * @DAMOS_PAGEOUT:   Reclaim the region.
> >>>>
> >>>> Nice!
> >>>
> >>> But doesn't it make confusion about whether this pages out to disk or does
> >>> demotion to the lower tier memory?  It's because PAGEOUT action doesn't do
> >>> demotion, but it looks "reclaim" includes pageout and demotion together in my
> >>> understanding since /sys/kernel/mm/numa/demotion_enabled was introduced.
> > 
> > To my understanding, DAMOS_PAGEOUT can also do demotion when demotion_enabled
> > is set.  Am I missing something?
> 
> Actually no, please see below.

I'm unsure to what point you are saying "no".  Are you saying DAMOS_PAGEOUT can
also do demotion when demotion_enabled is set?  Or not?  Could you please
clarify, and add more explanations about why you think so?

> 
> do_demote_pass in shrink_folio_list()
> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1122
> 
> The do_demote_pass is used here.
> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1293-L1302
> 
> can_demote() implementation returns false when demotion_enabled is on.
> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L350-L351

I'm again get confused.  Isn't it opposite?

```
static bool can_demote(int nid, struct scan_control *sc,
		       struct mem_cgroup *memcg)
{
	int demotion_nid;

	if (!numa_demotion_enabled)
		return false;
```

It returns "false" when demotion_enabled is "off" (unset).  Am I reading
something wrong...?

> 
> The replated commit is as follows.
> mm/migrate: add sysfs interface to enable reclaim migration
> https://github.com/torvalds/linux/commit/20b51af15e014cac63b58a4f8b8b323ac35bccce
> 
> > 
> >>
> >> My intention was just to synchronize with the Design documentation.
> >>
> >> So how about changing the description to `Page out the region`, Would
> >> this be also confusing?
> >> I feel like it would be clearer than using word "reclaim"
> 
> I don't have a good idea but it looks like recusive explanation.
> 
> > 
> > In my opinion, "reclaim" is good.
> 
> I wish there could be better term that distinguishes between swap out and
> demotion.  In my understanding "reclaim" includes both swap out and demotion.

"Reclaim" also includes writeback operations.

I agree we have many rooms to improve in terms of terminologies.  But, I'd
argue we don't need to have only 1:1 mapping terminologies.  Othrwise, maybe we
don't need any documentation at all but just code.  "Reclaim" is a good general
terminology for describing an effort to get free pages on a memory domain (NUMA
node, zone, etc), in my opinion.

To be honest, btw, I'm not a fan of "promote/demote", and that was one of the
reasons I insisted "DAMOS_MIGRATE_{HOT,COLD}" instead of
"DAMOS_{PROMOTE,DEMOTE}".

> 
> I also found that man page explanation about MADV_PAGEOUT is "reclaim these 
> pages".  If this is correct, then maybe demotion isn't included in "reclaim".

I interpret the term "reclaim" on the man page with a flexibility including my
above definition, and hence I don't think this is contradicting in a very bad
way against what I'm understanding.  That is, I interpret the documentation
says MADV_PAGEOUT can also do demote pages under certain conditions.

I didn't write the documentation, so I may be completely wrong.  I also
frustratingly lost my resource to validate the main question of this discussion
(whether DAMOS_PAGEOUT can also do demotion or not), for now.  I'd like to
continue this discussion based on code rather than a documentation that _might_
be right or wrong, and preferrably based on real tests if you or I have a good
testing setup.


Thanks,
SJ

[...]

