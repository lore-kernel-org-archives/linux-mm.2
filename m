Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4D8C87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 17:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A036B0088; Sun,  3 Aug 2025 13:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161EC6B0089; Sun,  3 Aug 2025 13:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F0D6B008A; Sun,  3 Aug 2025 13:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA7896B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 13:42:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5186F1607F7
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 17:42:41 +0000 (UTC)
X-FDA: 83736166122.04.1973298
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AF38340008
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 17:42:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FspGJBtK;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754242959; a=rsa-sha256;
	cv=none;
	b=cz7+RKeFTzpBQXFpqv2fmsG7xpMKD53s7F5mZ8on/62UuD6MsBYUAgAfAvi2itLreMSvpT
	+XUtWkRyBXLUdkdqwEN3y0UKgtJn2M1g1AWo/lNbTZK4cX7yXzwP/1Ogl1RRG9QD4UlysC
	GR8pqb3Bp3D8uIs+f7bzkoKEOuOx/iY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FspGJBtK;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754242959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtlBW1C1g+tEbVVhgG1e6hE2ZYKfzijkewSuyki5MmU=;
	b=RQiH50XOhZyrGkhNMFx8nZm2HMf7b3wmvws30wv8wmwwN5Uh3rsQFSbV4tDJGKk0MXqRwt
	vJfkUUd+3ulQjSqeBJ6QlbGJ1aBiwiYap/x4BVSGLEVl+I7aEJREuX1wDUoplj9gXOzoWu
	vUkKqcsB7v80Xn4sYvdgsP8tvW3tEV8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB78E601DD;
	Sun,  3 Aug 2025 17:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44470C4CEEB;
	Sun,  3 Aug 2025 17:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754242958;
	bh=0AexdTSmWe/R0yl0rbF+c7H4VGOBukfpyCog3Tqe8xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FspGJBtKpuQ37fXykz8fzqu2dzo4KDUlZNXRVObfEzshf+GA2kWGy5uAWTjvvLtNu
	 3YfdYE/N6QVW0yflvP3u2j+1pZs9a5nIPaDd2mwRLxkhynwcHFc3YX3NEk2PUoLorI
	 74rGrnqy7gb/hABAZYNQx/fW+zHQFCDgQL5mj+6GcODUzrofhpiUf/6vBO0hGadOHg
	 H8eqYUxaLFmzgljuRVhUKZDY0t+2dbBi/VAou3F7jefIkOOlLCGGz34wmDvPKYLXI0
	 +Op+TVW4gaoaHW+FsfTTVGtZSmG1BjjULcZ8pMwFHsU2BZrx/ogzXlYZiKFxUkOU5d
	 bR/R04IdflCKg==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Honggyu Kim <honggyu.kim@sk.com>,
	kernel_team@skhynix.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Date: Sun,  3 Aug 2025 10:42:35 -0700
Message-Id: <20250803174235.55846-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxME81-oWdDzc6EzCEgHnXDTe_fQT0s8c2YuqMA1EDbDZZw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF38340008
X-Stat-Signature: a7uig1oyjhu578ic148zxue7rm46mjxn
X-HE-Tag: 1754242959-839292
X-HE-Meta: U2FsdGVkX1+vejz6HYqcFiXonS7luCjfEVYOeBc06S1MCP4+3C54QdGfqxcFzSu8nYN0Hkb44GU/t8hMp0y1jfmx5qMn8Ziq1uklVaCva3/Jhowjn/jpOiVuJrgTtUgFR6KpoDFqy1nX08vLLv97SVXTx6QQQ5+CTUf6dLkudTBXHrQvY2hHyMHeFl7SsVNUHH2vVAGhSHTBzp/aJ2TwM8aRYmvxEWzM2UNUTFGCbwwnKKOR1K719ou6pFCt/Crq4O9oeNFpUE+u/lDjcJLWjD7gwWl0oowBwrO0l2q7fFNdw4m7fC2jHiBGjoZdRI5nXw0UIO6kUcbta56wRHcK4+RaypDltnXH4X/L96m90kDUeMPaR0gFet0NvO0g2JmhE8XRgkJ0HDhOohctKRYRFwokXAzq5SxhbR5Yrh6f6F+K8faqtQ+SsfrX2TuRKAT3JzvCy5G0Wg0vnB4ADneS/7Ey1vJ7QDoV5n4l4G6CxqA+3mMJe/RieQWInMcXrTZO7MAHtnNRz/tQs4gmXjtmiwk94L0Ky+uc/pEpzQy144ZZgM5QV2fzhkesXQ+bnSeoHPxeEDyuulYwwyda82WKOT5IukpjQ+oMWzBO9ldDBwLDz+ItLjEu5olx4mFLaEMAnFk4Czjl6A3HFW6avQV/qLJCJOfEFaVbDxJa2iEyMWOSMt6wiL8Axb+OhYtK/nAwictKMl7fhklAzlAeuCMv7N0eaazg3SPCWbMB2uLVHOlLLVt/npsHmaDvFwXtExON2MoZhkbnntthNA4XE1qgoOtSNH1gOnjcj7J5R5uZQkwcqMktd7XSqO20S7uZsCvTkH7H75Tk8gy4zXk1qEyI6ar61v046tFLwoOhaRoigTwFc1Ys3tpLM5djHNJ0lfeicdwCGEr//ODRdSt+9oOj9uMHQn0cdXI7it0MqPkVYl2J3r4nKIPc1vuY+XaWK7miNsXOopQOkUzmblZsDeV
 E/v/UYS+
 t+9XfTzAclhboerw3JOwtBnfM5pd3oCZp/cLqhhbEfsccAAO7+r99LTjmuHPyWF2qk91Iw7a4Qujjg/mzI7TndN6aa0dn7DcRWGtfMHXq3fCxnmsKlBLyMZaHG1ySgkv3u7B8stgdBvK4IbR9CBDVoc44UmKyAw96PPK/9dKECJeqs3DbLFEoTPt5PaVbUAwIpJVPSjTHtMJ1ZZVIAXedsrnUC6xlRJKi0XisdjjDkR+d9Hp6amHC6QO6RkB8/ZZsiOaMri64NXAZSa17sMfoPOyKxZHfMtChtc9JOlfdjBA+Adk39TdzSfmdrsHHLBffLe9K457bCRMw4QL3XOIXcM5Rr56DDhW86a36KXYOdUR9E6DcYGIhDjRC4seS3ALLDoolLqgoTCjuyKx91/+4S8xwkaARiHlj/sqU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 Aug 2025 22:22:05 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hi, SeongJae and Honggyu,
> 
> On Sun, Aug 3, 2025 at 2:41 PM Honggyu Kim <honggyu.kim@sk.com> wrote:
> >
> >
> >
> > On 8/3/2025 2:30 PM, SeongJae Park wrote:
> > > On Sun, 3 Aug 2025 13:43:03 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:
> > >
> > >> Hi SeongJae,
> > >>
> > >> On 8/3/2025 1:22 PM, SeongJae Park wrote:
> > >>> On Sun, 3 Aug 2025 11:03:12 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:
> > >>>
> > >>>> Hi SeongJae and Sang-Heon,
> > >>>>
> > >>>> On 8/2/2025 1:50 AM, SeongJae Park wrote:
> > >>>>> On Sat, 2 Aug 2025 01:11:09 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > >>>>>
> > >>>>>> Hi, Honggyu
> > >>>>>>
> > >>>>>> On Fri, Aug 1, 2025 at 8:35 PM Honggyu Kim <honggyu.kim@sk.com> wrote:
> > >>>>>>>
> > >>>>>>> Hi Sang-Heon and SeongJae,
> > >>>>>>>
> > >>>>>>> On 8/1/2025 2:58 AM, SeongJae Park wrote:
> > >>>>>>>> Hello Sang-Heon,
> > >>>>>>>>
> > >>>>>>>> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > >>>>>>>>
> > >>>>>>>>> Nowadays, damos operation actions support more various operation set.
> > >>>>>>>>> But comments(also, generated documentation) doesn't updated.
> > >>>>>>>>> So, fix the comments with current support status.
> > >>>>> [...]
> > >>>>>>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
> > >>>>> [...]
> > >>>>>>>>>       * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLNEED.
> > >>>>>>>>>       * @DAMOS_COLD:              Call ``madvise()`` for the region with MADV_COLD.
> > >>>>>>>>> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEOUT.
> > >>>>>>>>> + * @DAMOS_PAGEOUT:   Reclaim the region.
> > >>>>>>>>
> > >>>>>>>> Nice!
> > >>>>>>>
> > >>>>>>> But doesn't it make confusion about whether this pages out to disk or does
> > >>>>>>> demotion to the lower tier memory?  It's because PAGEOUT action doesn't do
> > >>>>>>> demotion, but it looks "reclaim" includes pageout and demotion together in my
> > >>>>>>> understanding since /sys/kernel/mm/numa/demotion_enabled was introduced.
> > >>>>>
> > >>>>> To my understanding, DAMOS_PAGEOUT can also do demotion when demotion_enabled
> > >>>>> is set.  Am I missing something?
> > >>>>
> > >>>> Actually no, please see below.
> > >>>
> > >>> I'm unsure to what point you are saying "no".  Are you saying DAMOS_PAGEOUT can
> > >>> also do demotion when demotion_enabled is set?  Or not?  Could you please
> > >>> clarify, and add more explanations about why you think so?
> > >>
> > >> I checked it again and found I pointed out in the wrong place. Please see below.
> > >>
> > >>>
> > >>>>
> > >>>> do_demote_pass in shrink_folio_list()
> > >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1122
> > >>>>
> > >>>> The do_demote_pass is used here.
> > >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1293-L1302
> > >>>>
> > >>>> can_demote() implementation returns false when demotion_enabled is on.
> > >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L350-L351
> > >>>
> > >>> I'm again get confused.  Isn't it opposite?
> > >>
> > >> The thing is that DAMOS_PAGEOUT call sequence is as follows.
> > >>
> > >>     DAMOS_PAGEOUT
> > >>     -> damon_pa_pageout
> > >>     -> reclaim_pages
> > >>     -> reclaim_folio_list
> > >>
> > >> In reclaim_folio_list(), it sets "no_demotion = 1" in scan_control, then invokes
> > >> shrink_folio_list().
> > >
> > > Thank you, this clarifies.  DAMOS_PAGEOUT doesn't demote pages even if
> > > demotion_enabled is set.  Thank you for enlightening me.
> >
> > Thank you too. Glad to hear that.
> >
> > >
> > > So, "reclaim" means "reclaim".  shrink_folio_list() can do demotions when
> > > demotion_enabled is set.  I hence still don't think this patch is saying
> > > something very wrong, and how it could be improved.  Do you have more specific
> > > change suggestions for this patch for an improvment?
> >
> > I would just like to make the term "reclaim" clearer and we may be able to
> > define what "reclaim" is.  I think we can choose between the following two
> > different definitions.
> >
> > Definition 1. "reclaim" includes "pageout" and "demotion".
> > In this case, we better clarify all the other documents that mentions about
> > those terms.
> >
> > Definition 2. "reclaim" only includes "pageout", but "demotion" is out of scope.
> > In this case, shrink_folio_list just do pageout, but "demotion" is only
> > exceptional case so we can say the "demotion" escapes from "reclaim" logic.

I was thinking in the first way, and apparently I was simply wrong.  Now I
think the second one is more correct, at least for {DAMOS,MADV}_PAGEOUT.

Yet another way to do the reclaim would be memory.reclaim cgroup file.  Seems
in the case, demotion can happen since user_proactive_reclaim() doesn't set
scan_control->no_demotion.

I didn't read the code, but apparently memory pressure-based reactive
traditional reclaim logic would also do demotion?

So, apparently "reclaim" can mean at least the two definitions.

> >
> > We might have to clarify the term "reclaim" for those cases whether it includes
> > "demotion" or not.  We might have to discuss with other mm developers together.

I think that could be a nice discussion.  Looking forward to.  As I previously
mentioned, I don't think we need to have only 1:1 mapping terminologies, though
I have no strong opinion here.

Regardless of terms, I agree there are many rooms to improve on our
documentation.  At least DAMOS_PAGEOUT documentation may better to clarify what
you pointed out.

> > Thanks,
> > Honggyu
> 
> Because of the above thread, I got to know the details more clearly.
> Thank you guys!
> When the discussion of "reclaim" finishes, I'll make v2 patch as soon
> as possible.

I don't think we need to block v2 of this patch for the discussion.  What about
adding a note about the demotion behavior on the details comment second, e.g.,

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -150,6 +150,8 @@ struct damon_access_report {
  * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
  * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
  * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
+ *
+ * Note that DAMOS_PAGEOUT doesn't trigger demotions.
  */
 enum damos_action {
        DAMOS_WILLNEED,

> 
> However, I want to talk about a slightly different topic. How about
> adding support demotion to DAMOS operation action?
> Maybe we can add another action type or change implementation of DAMOS_PAGEOUT.

We actually tried to implement DAMOS_DEMOTE, but eventually decided[1] to have
a more general action called DAMOS_MIGRATE_COLD.

Do you think there are use cases where DAMOS_MIGRATE_COLD cannot cover?

> 
> IMHO, I think we should first check whether it's possible to set
> no_demotion in the `madvise` -> `foilo` flow we're using.
> Since I'm still quite new to these things, I'd like to check whether
> my idea and direction are correct.
> 
> I can't thank you all enough for your kindness :)

The pleasure is mine :)

> 
> Best Regards.
> Sang-Heon Jeon
> 

[1] https://lore.kernel.org/all/20240614030010.751-1-honggyu.kim@sk.com/


Thanks,
SJ

