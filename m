Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8460AC5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD436B009D; Thu,  6 Aug 2026 13:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A50B6B009F; Thu,  6 Aug 2026 13:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB086B00A0; Thu,  6 Aug 2026 13:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DCEA6B009D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:19:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B9EF1A018A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:19:40 +0000 (UTC)
X-FDA: 85071506520.08.E31E3C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E316020006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:19:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JFfHnB2t;
	spf=pass (imf13.hostedemail.com: domain of "SRS0=Ks7D=F7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=Ks7D=F7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036778;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCTIh4+337Arhw2MOQd3w4D4wyAlZYb/X46IM4i9uCA=;
	b=0/GaZ7NnOgI3KcwIeInckOad6JgEivz3CNmGYVrb1S5PZMInjnJt93tTFUsdiwsuoe0r4o
	QPsf2d5hshhY6yxhpk69ozfuArmf8QYecxVochfG72kdkThGFDVHKwL6ZK8IftTZ8ppquP
	Ancr1zC6Ee9ED4+/sY0InvES0OtOc5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786036778;
	b=qFivtUV+B33mCAN5S33rQwvBOj8Ja9AR26QIT5228WHVbUxw/pUVFKVBkrDo+OfqtriJK7
	5qxEqTtvaYVWJ6ysBGeCs75PrL+G7Gct+dilvROJYoF+dn7V08uA3lN0DPild/3utj1c4g
	V7dlSlGDG6p+6KqJe+Ch42VSlXmz/7Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JFfHnB2t;
	spf=pass (imf13.hostedemail.com: domain of "SRS0=Ks7D=F7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=Ks7D=F7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8683C60AB0;
	Thu,  6 Aug 2026 17:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DA61F00A3A;
	Thu,  6 Aug 2026 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786036778;
	bh=VCTIh4+337Arhw2MOQd3w4D4wyAlZYb/X46IM4i9uCA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=JFfHnB2tgAQqDn7zRhCbErWmOgYEc2yQmC1rUNAY3AqunXMg74G0taQTpeUgkL8hR
	 CHLTcNv3qbuDM8tTn8U2o2zEXLnFK/lWBaM+OTisGURQAZa5GySWJkpZu8gKdzM2v4
	 5boaNMJHbCPJVZ+/DCzLzyx5cH53bIV/ISqL9ZH9Istr28b4v1M4c3itaFdtcq+Y2o
	 uKvNoyRe4fTUeB6lEgub7ZJP0WA/Vk84j2cUR4AJdTDjJRx2P097Z0vMb2EMYet80E
	 F4aUWV9ldL+QB0deNKmG0dp+PmT09bntNu18IVjyarlDOgSo9EIZisjBjNG6Z+jhRe
	 6GFrjhyUAWMyw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 7A4D6CE19F3; Thu,  6 Aug 2026 10:19:37 -0700 (PDT)
Date: Thu, 6 Aug 2026 10:19:37 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com>,
	hannes@cmpxchg.org, jackmanb@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
	surenb@google.com, syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in khugepaged (3)
Message-ID: <23c8020c-3d2c-4c89-9a55-83d64a7133d9@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <6a727d6c.9511d2ce.1fc5b9.035e.GAE@google.com>
 <20260805122952.6ae38af69a0457779cb44359@linux-foundation.org>
 <d5771d33-d8f8-4fcf-911b-089e862042e5@paulmck-laptop>
 <f8fc47c2-02a5-44b0-8860-ff8369144b78@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8fc47c2-02a5-44b0-8860-ff8369144b78@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E316020006
X-Stat-Signature: ctfekmqhu4sau57wt3exsmp1538rtxwk
X-HE-Tag: 1786036778-318088
X-HE-Meta: U2FsdGVkX19MikRZvPiMZMDmeW/BCzoO0eUYgv34YiL8k3eRv2G2KW2W7Ag2v3IsCmVKQjbEesrwGlpYtNxwpk/w0zH2CjgL1N28kG6n6bzWZzcODFCpyEoJlAlHeefus80k+rMZI8V92KzbfPWfWb+Nw4LB1ivpQqG6i3ErKu6fkpg2WOSuXZML4rxd+8IH10Dw8zt/ZpHG4zYXWc6GSGdCBep5r/G4VPFkfoZzHmjJ6tDoIgW6buu13gNoqhjxfkBRQ2ELbL92KhsnnAdgfov2Zt+Q3+uveOXfC52XQZwsTSu3o80Jlc14waHqCkCIZLbYGRzcL20DoyHKWdCa8ForoFMm/F/qqErNk+LmhgtGpwLeiYOh6RPAO6PYYWA7h1JlRsFAwAeQOyJjws/MSSOmrxaxPyVnbJmviv9ExoTxfb9NQzLRanfLRqwb6g/2NXRHGUZ3Ua27Ma2Lhx9vUTPzgE4yIO0NVLmFBlxbbKqf+sKlZ/Z7b81j7zJPWUJKkaWh09su6USnS9Tb2R+i1Dplz+Bdp3V4JCMnT62JULOBM2h5i4JjnvDIw9RRt7Fe4FIPMMs48WgthlwswOZZ4shi6xAspygmonzu2GEEgBx9+wYz2VcJOKkqBflr7h0wJBjuAggI0Q7CwQXGSUH8OoTy1fdsFr83Za5MXbsuyb8YYxmA8f09Sy/OaITSqp2yT547RgHEwHyuz5NUkapVeDuqOtUY9TWW/A8XUWU4Xo2m8JjG2A3Q9CeojqYiuDaFyBfHkRCuMP0iqwWFkpkyA/nOZ+CXv7toik/nzPZJfYXuTOmTQBvxKJnZmWDaSLaIHgPfBg3jouwO4/ea5sEeE+SC9Mfx9RmtQyelzpGlZeyWEWSfQLW6eMT+/FrxuoCq9Dz+vGvPUmYRJjsARMMR7DAUdeb14Mo/tDjB9HgofL/t8VP+PZlI8qQr75F+0V3Bj9qpUHK2TvpJ6chY1Ko
 YHPTfzGq
 53+jZFJtzEABEVDuz5zJIry+9knFqDt6F5muDXwBeo0/n/ERwuHvJNt93Lel5qJwlqDRUS8NE5rzHw1QqIGk32GdF8NSxLJgIrO1rbsUuyJTab2GR2xH6HQ2nXrJQuIw+Ok6CnysJ5hQkUXqPBR5u+naHkNu1+IBv4O5B8zdA34qC0d0+1eLHt9Jv1Xsruj+DsmTyCgOHAUAAHm1fU8p5yyiTXgzx366piah2S6FDg31rl8SzL7Zf+zepverjBQKCJvoVyrIm2QsgMwbpu/XjeLAJg6mhHi+e82WxeSoNVavndW8W/UNOqF4Z3hwrD5qIymkdD4GWs0Zl6l//n037dMKue4R51Q67z9YMFfM29tSGb/zcJpHKwHVmWUF0OsDzQbtl7HjtJtCIeymtSQI24I/CGbWnrDXWDTbFmyhiEI7sUnJ/qWcVnlwHFbgUbhUWGBV4w9HOwYZSWU2SADIgo4gt2mS6XRJdZLOlCyAhPATRoM+xT2staknfrh+zHA5bDHP7jbnGbH2WfCaQgLoDHQbcN6gkyfVjgmoqSNIOo9cWsOtGZQDW0oGwWf7mHReXVJGsAv41kDU081BB1BYy8ZoekxKUd4d/3o7qAc6GUtIElFiDK5GqvFAYE3GP+3TmVn6EIClxXh6oecYw+XAocQ35TqvIfzE6Ik+MjQDlM6GKwnITx2YOCFMx7KODZc/aORHHrWkBFefpy7YQPmfSTp6ONrwAp3UsOWczcWUIVKjOMZMb73ZeiCPlakTlvEG/57/dcITYIDu1SgASfd62o1kaj44j3bR1XOJz4id58DnRcIE+mtZIdmRe2owNBxtObuQQ1ZgNUyucxO6MY98OyeWAUXTniByfV4Dl8N4UxKQPzQgGms8b0OudzW2sYd/NJYXhL3v8ZCbGdvVR//jr0u1GQk4vG1iqjqMrp5cL8a7YdF5P5N2DcStfiU0n251hUEnNeJcdm2F5jnKX9Fz+AncYGk8Q
 N6230vNr
 9GbqPozoifMpPxAQWmJyv0SxU703bUj++D7SGkCslec9xswRl6EMGv6p50CBE8BumQDANISTbM751xPIUM4OszoeG6Vi5LQs1ATWYoKGoHmGzZ5A4MloKMrq5ntqeeR76Ku5sessqRY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 10:18:57AM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/5/26 22:28, Paul E. McKenney wrote:
> > On Wed, Aug 05, 2026 at 12:29:52PM -0700, Andrew Morton wrote:
> >> On Tue, 04 Aug 2026 17:01:48 -0700 syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com> wrote:
> >> 
> >> > Hello,
> >> > 
> >> > syzbot found the following issue on:
> >> > 
> >> > HEAD commit:    3708dd948844 Merge tag 'pm-7.2-rc6' of git://git.kernel.or..
> >> > git tree:       upstream
> >> > console output: https://syzkaller.appspot.com/x/log.txt?x=11ac703e580000
> >> > kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
> >> > dashboard link: https://syzkaller.appspot.com/bug?extid=d2401aeb74cc84adba04
> >> > compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> >> > 
> >> > Unfortunately, I don't have any reproducer for this issue yet.
> >> 
> >> Thanks.
> >> 
> >> Lazy optimists (ahem) paste this gunk into Gemini and ask "what the
> >> heck just happened".  The results are often useful, but should be
> >> treated with skepticism.  In this case I think it came usably close.
> >> 
> >> 	https://share.gemini.google/vq4TLhTiLBih
> >> 
> >> 
> >> tl;dr: khugepaged's collapse_scan_file() is taking too long and RCU got
> >> starved.  I don't think khugepaged is doing anything wrong here,
> >> per-se.  There's a lot of work to do and we're doing it.
> >> 
> >> An appropriate fix would be to take a break, let RCU do its thing then
> >> get back to work.  But I don't think RCU offers interfaces for that?
> >> 
> >> collapse_scan_file()'s main loop has
> >> 
> >> 		if (need_resched()) {
> >> 			xas_pause(&xas);
> >> 			cond_resched_rcu();
> >> 		}
> >> 
> >> but that won't help with the RCU stall detector(?).
> >> 
> >> I suggest that a suitable fix here would be to add the analogous
> >> 
> >> 	if (rcu_i_need_to_take_a_break()) {
> >> 		rcu_read_unlock();
> >> 		rcu_take_a_break())	
> >> 		rcu_read_lock();
> >> 	}
> >> 
> >> (iirc rcu_read_unlock() does an rcu run, so rcu_take_a_break() isn't
> >> needed here)
> >> 
> >> Paul, wdyt?
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
> > What we need is RCU priority boosting.  Except that the .config file
> > does not enable this.  Not only is there no CONFIG_RCU_BOOST=y, there
> > is also no CONFIG_RCU_EXPERT=y and no CONFIG_PREEMPT_RT=y.  But there
> > is CONFIG_RT_MUTEX=y and CONFIG_RCU_EXPERT=y.
> 
> It comes from syzbot so might be likely a randconfig and there's no point in
> trying to find any sense in that combination :)

;-) ;-) ;-)

> > Because we don't have RCU priority boosting, if the load on the system
> > is heavy enough to prevent our poor preempted RCU reader (PID 37) from
> > running, the grace period cannot end.
> > 
> > I am not sure why this task is saving its stack, but maybe that is normal
> > for this code path?
> 
> That's because page_owner is also enabled so it's saving the freeing stack
> for the page it's freeing. That's not a normal production config, only when
> debugging.

Ah, OK, I feel much better now.

> > My bemusement aside, I recommend running this test either with
> > non-preemptible RCU (CONFIG_PREEMPT_LAZY=y these days) or enabling RCU
> > priority boosting (CONFIG_RCU_EXPERT=y and CONFIG_RCU_BOOST=y).
> > 
> > Maybe RCU_BOOST should no longer depend on RCU_EXPERT?  I would of
> > course need ot remove the prompt ("Enable RCU priority boosting") to
> > avoid annoying Linus.  Maybe as shown below.
> 
> The "no longer depend" part alone would make no difference with randconfigs.
> Removing the prompt too should help indeed.

Agreed!

> Maybe a possible strategy in general would be indeed to unconditionally
> select what's the expected config, like you did below, and only make it
> possible to override that with RCU_EXPERT. So here with RCU_EXPERT you could
> disable RCU_BOOST even if it was automatically enabled - assuming this is
> useful for development or internal rcu testing by people who know what they
> are doing (not syzbot randconfig) or whatnot.
> 
> But then RCU_EXPERT should be excluded from (impossible to be enabled by)
> randconfig to indicate it's not valid for this kind of testing.
> I don't know if there's any precedent for such a strategy.

Good point!  For the first cut, I will just force it, so that someone
wanting to do that sort of testing gets to edit the Kconfig file, but
it is good to have a trick like that in my back pocket, so thank you!

> Specifically for the proposal below, could the problem still happen with
> PREEMPT_RCU without RT_MUTEXES? If yes, it wouldn't be enough?

Quite true!  Maybe I should make PREEMPT_RCU select RT_MUTEXES?

But that might need a bit of discussion, so if I take that approach
it needs to be a separate patch.  ;-)

							Thanx, Paul

> > ------------------------------------------------------------------------
> > 
> > diff --git a/kernel/rcu/Kconfig b/kernel/rcu/Kconfig
> > index 1a5fb3156c062a..5141ad8d1cd029 100644
> > --- a/kernel/rcu/Kconfig
> > +++ b/kernel/rcu/Kconfig
> > @@ -237,17 +237,16 @@ config RCU_FANOUT_LEAF
> >  	  Take the default if unsure.
> >  
> >  config RCU_BOOST
> > -	bool "Enable RCU priority boosting"
> > -	depends on (RT_MUTEXES && PREEMPT_RCU && RCU_EXPERT) || PREEMPT_RT
> > +	bool
> > +	depends on (RT_MUTEXES && PREEMPT_RCU) || PREEMPT_RT
> >  	default y if PREEMPT_RT
> >  	help
> >  	  This option boosts the priority of preempted RCU readers that
> >  	  block the current preemptible RCU grace period for too long.
> >  	  This option also prevents heavy loads from blocking RCU
> > -	  callback invocation.
> > +	  callback invocation.  It is now automatically enabled in
> > +	  any kernel that can benefit from it and that can support it.
> >  
> > -	  Say Y here if you are working with real-time apps or heavy loads
> > -	  Say N here if you are unsure.
> >  
> >  config RCU_BOOST_DELAY
> >  	int "Milliseconds to delay boosting after RCU grace-period start"
> 

