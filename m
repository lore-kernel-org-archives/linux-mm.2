Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 645DEC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF746B00A3; Thu,  6 Aug 2026 12:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56FDB6B00A5; Thu,  6 Aug 2026 12:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477D46B00A6; Thu,  6 Aug 2026 12:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19C8A6B00A3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:27:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7580E1C0077
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:27:47 +0000 (UTC)
X-FDA: 85071375774.17.70F4F97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CBB3C10000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:27:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnMQqzx5;
	spf=pass (imf14.hostedemail.com: domain of "SRS0=Ks7D=F7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=Ks7D=F7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033665;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOGeScaSuHuM7HfCCnzcathOZlLZGsTyN9pqp0ZRFi0=;
	b=xfu//YuvDgu0TF6fkOdducSl2WXNz2SFZtB3FGwr34Q2AlqomCJkP3tWGSUKlT4q62f1A1
	opn+MDOGrTTPxgH17dr8jmmouCPzsfH18IWgOjj8CK+xihM0OusF7jrwNgFIPiNlLDRtEb
	JPJqPrTK77H/8uupSKDlnUMk7N14poI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033665;
	b=8B24JdwVEq+IiDkuTwYxNOVMwRWQr0BceIaNs4YeF0aXWnZyqSM8ITED/qcMV/DIAf99WW
	Dag4tQRJi3rDqIbdXLZ1xdO8z4dAV2UsxtZhNuf6ulmYUfvE1VT0siXJ9V1Bt54CG87qVf
	fWaIV2hx2Tf1RO1fEjYHQ/pMkMJ3+To=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnMQqzx5;
	spf=pass (imf14.hostedemail.com: domain of "SRS0=Ks7D=F7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=Ks7D=F7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BCF960AB1;
	Thu,  6 Aug 2026 16:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D272A1F00A3D;
	Thu,  6 Aug 2026 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786033664;
	bh=TOGeScaSuHuM7HfCCnzcathOZlLZGsTyN9pqp0ZRFi0=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=PnMQqzx5rsg7Ra7zFrqozPwGU8Did/cXOmsuwLwdhIB7m9yjhSYt+LAuF8eqJl/Ua
	 Bkeq+0eV61PXx7RCcHa7KpweT3yh/fckRCqMBf4cj4reHaMPJmPt1ofcQu9GQIyAJ3
	 3Q7arpxDWVhexwxryVjkPXTGN8TmvUu7g1+Wkdz9UgqZJJ8cclDtVVBH6e10QPYI+J
	 0zThl8+/N82Y2QfFwDk92k3TvxMnf2k9u33SpY80yOwQZk1iZk9amoljpg1Cu5O2M9
	 CugVlERvMAuCrqfEG9LvviMu2o7sUlrVL9G9aN049OiN8iribLMzdBeVAD6uj/LsUg
	 vfcllhNsnKu+Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 64615CE19F3; Thu,  6 Aug 2026 09:27:44 -0700 (PDT)
Date: Thu, 6 Aug 2026 09:27:44 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com>,
	hannes@cmpxchg.org, jackmanb@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
	surenb@google.com, syzkaller-bugs@googlegroups.com,
	vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in khugepaged (3)
Message-ID: <3fca260a-4544-4e65-916e-d2ef7fa1440f@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <6a727d6c.9511d2ce.1fc5b9.035e.GAE@google.com>
 <20260805122952.6ae38af69a0457779cb44359@linux-foundation.org>
 <d5771d33-d8f8-4fcf-911b-089e862042e5@paulmck-laptop>
 <20260805230311.2bbda85fb92abcf12d85194e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805230311.2bbda85fb92abcf12d85194e@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBB3C10000E
X-Stat-Signature: egqjed34u7p1zidwn11zo15wswycsuir
X-HE-Tag: 1786033665-752885
X-HE-Meta: U2FsdGVkX186VfZGe9YTaaIt/h3PKcp7/4DmFJL+lCfACqwQjUspxx1MgVT3y6E315wWySNGkY3GqTQO/6ukIZ9wUo+fUdICen1mFIRI+AFDrr001Yofu1j2DKjGxRU2h3WvD66c2W3KNat4Z5VSHKRMtg0B9zBpJvWgSHfeTrh9w4KrzEjZCqvLHU21t5/1sR+jIiKikQDsY8expI9/33R33Ch3FQ8BNLwovMTjYsgAT4mz2Wgij0QHSi+jH31zIotJsWumgYlwe7vsP+hd+wwo2tYLMoCmYiAdMUA2/N6HkY535Ltts0YmRQXyqUYiLfW7rO9PMo4MAzWQnf7pucU5ae/rJX3Es3TzaUZAKIufpEr+aD7YQCC1H24j80Z/UXjGwRYsvwLkMOMTgJfxE8D6zqrTyvYkYbMQZIWAXXYAoIWJawrt4MxxPb4HOUsxISiH0uISvhjjmSIc1LlMiirwC833TcPWSSr0n/jFuo+rqw4eo5A9v1ReFOX0rmB7bXKRACk5ZR1CXKcnGmoCcbSitUuqk3X3ve6jue43Kz2I8a//jmSaRP3hbIxIr61bk2eBTpJo7KttdGjOP1qTzosXmlu932qUzis/1KkQc+daV6LxCnDEhGtMckZSacsVWgfourfpsIJsmMgk06JDE/K6ewpGrgEkQR4ibO3mnaG3UO+vh7hx9qTc+FjZw/8tsGL7UNOyOSB1w3ycIG4HR2oVJdXq+XFvSUD8QtgNRGvLpafVHI3ue2lPyr2MS6wI39y7kisgiCUYq/3nG6wYZ8R+p4ztYn8xIKkbZnHhZulhVS3CJ+pgEX2L0tAg9ACFlEHPfTdDbjycGscUTDqD8a/GSP+B8uClAwvEmkn8kYajtONMwj8G7dTCFRiIC3kJjD3iWiZPggzTP3YR94Xr0IXBvhpB5N4zi7SccViAFqqG8uzzcKv2r2+nYOCUyemAUuHipUBjXhCNTE3/am3
 RPhCNdHJ
 MGeey85bQCpvQ0/kgRCa0VFF5gtHaBC+OV867IaofFOx+vXDpKFaRozvjWy0N6bD6gVJHqcGMf4aURontmnhlPxqZY0Ynw4ob+lSfKhDGDkdAqFTZNxlGlksqVLgzDKUrPPC+IkNAB1Ol+0uW1ejhF/05kwlJe1mC7s73s3hKiwfUPAaStXrAfH7wYT8rrwXKZvqnZUnREI+bzbVIPL/74OOtezfofr56A+qrm7iLsSem04m2gW6WkbziVEdafA6Oo8w+4d/nzsA/sJ1LTEio2jjrZ9+7JmZGagO43+4A6bqWNmLkVdJ+orzdWP4X5Aehbrn2O+A3Fd5FtkY9FORgagnpmdT8LRyZm3E9uCbd0knOV02tvomEVH7b7Dhdc6Kbf46pPEAJ6eiuDDvVHqPQ31ba0ILXaxwgAxE+yv2Uyzrac4E18/Zq9CTn3ivgPEK1+9sAUoTz7PrXu/HPCKCByMhWb5Zc31pXAaDCDqhVX/KEg4RudwKRNVmlrmnGK9e2KRw5+vDAq3mLJJj0XGo8KX+Cauvl/Oo9WYx6uRgpUlksMXP8J6u8UD2pMf5NN04Oiotsv5KNuD0ZBhV5dlfZ+M3ilrP7jUkmTFich20iFrZhkXV9PxX0z8Hqn6puQTZPytnv2lgeLdDcGHwkKHlWItEdlGfVeN76YcuoJLNlByN2sVGBRKxMzMh0PH40gqZkmLZiQJ550dQ7J5xUVwGUH7KoZDtCJf2R6Zq+DHLOQW2MwWfmp/2XotRW39rFWoKMlI2NK/4XdjG4ODp4IsFgYZ2fL78UyKLonuhSqX3HXdrFXp7iozJI86uPOngEk6K5PI+aJGUMp0ZS9AGcPWe/osUVeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 11:03:11PM -0700, Andrew Morton wrote:
> On Wed, 5 Aug 2026 13:28:16 -0700 "Paul E. McKenney" <paulmck@kernel.org> wrote:
> 
> > > collapse_scan_file()'s main loop has
> > > 
> > > 		if (need_resched()) {
> > > 			xas_pause(&xas);
> > > 			cond_resched_rcu();
> > > 		}
> > > 
> > > but that won't help with the RCU stall detector(?).
> > > 
> > > I suggest that a suitable fix here would be to add the analogous
> > > 
> > > 	if (rcu_i_need_to_take_a_break()) {
> > > 		rcu_read_unlock();
> > > 		rcu_take_a_break())	
> > > 		rcu_read_lock();
> > > 	}
> > > 
> > > (iirc rcu_read_unlock() does an rcu run, so rcu_take_a_break() isn't
> > > needed here)
> > > 
> > > Paul, wdyt?
> > 
> > Let's see...
> > 
> > The console log says "rcu_preempt detected stalls on CPUs/tasks",
> > which means that cond_resched() is a no-op, but it also means that
> > the rcu_read_unlock() in cond_resched_rcu() will directly take care of
> > informing RCU of the pause.
> > 
> > But that is clearly not happening.  Why?
> > 
> > Well, we have this:
> > 
> > rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P37/1:b..l
> > 
> > This means that the task whose RCU read-side critical section is blocking
> > the current RCU grace period isn't even running, and thus cannot invoke
> > cond_resched_rcu(), let alone the rcu_read_unlock() within that function.
> > So an RCU CPU stall warning is expected behavior.  Or at least it is not
> > in any way ruled out.
> > 
> > What we need is RCU priority boosting.
> 
> Do we?  I'm suggesting we need need_resched_rcu()!

Understood, and I initially agreed with you.  Except that I then
found that the poor preempted task isn't executing anything at all.
Which means that an added need_resched_rcu() cannot possibly help.

> > Except that the .config file
> > does not enable this.  Not only is there no CONFIG_RCU_BOOST=y, there
> > is also no CONFIG_RCU_EXPERT=y and no CONFIG_PREEMPT_RT=y.  But there
> > is CONFIG_RT_MUTEX=y and CONFIG_RCU_EXPERT=y.
> > 
> > Because we don't have RCU priority boosting, if the load on the system
> > is heavy enough to prevent our poor preempted RCU reader (PID 37) from
> > running, the grace period cannot end.
> > 
> > I am not sure why this task is saving its stack, but maybe that is normal
> > for this code path?
> > 
> > My bemusement aside, I recommend running this test either with
> > non-preemptible RCU (CONFIG_PREEMPT_LAZY=y these days) or enabling RCU
> > priority boosting (CONFIG_RCU_EXPERT=y and CONFIG_RCU_BOOST=y).
> > 
> > Maybe RCU_BOOST should no longer depend on RCU_EXPERT?  I would of
> > course need ot remove the prompt ("Enable RCU priority boosting") to
> > avoid annoying Linus.  Maybe as shown below.
> > 
> > Thoughts?
> 
> If I'm understanding correctly, this workload is busted with this
> config and the proposed fix is to alter the config?  Well, why are we
> permitting that config at all?

Agreed, and my proposal is in fact to remove that config.  This assumes
that CONFIG_RCU_BOOST is ready for prime time, and given that I have
been testing it for years and that CONFIG_PREEMPT_RT has been using it
for years, I am cautiously optimistic.

> Seems to me that a solution to permit this config to work is very
> simple.  Something like:
> 
> 	time_t start;
> 
> 	rcu_read_lock();
> 	start = current_time();
> 
> 	for (lots of work) {
> 		...
> 		if (need_resched_rcu(start)) {
> 			cond_resched_rcu();
> 			start = current_time();
> 	}
> 
> Where need_resched_rcu() tests to see if we're getting close to hitting
> the watchdog timeout.
> 
> No?

No.

Added code doesn't help a task that has been preempted for some seconds
and thus isn't executing any code at all.

The task has been preempted while within an RCU read-side critical
section.  The sequence of events is as follows:

	rcu_read_lock();
	// preempted for many tens of seconds.
	cond_resched_rcu(); // doesn't help because it is never executed.
	rcu_read_unlock();

Or am I missing your point?

							Thanx, Paul

