Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5091CC55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 20:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029256B009B; Wed,  5 Aug 2026 16:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5196B009D; Wed,  5 Aug 2026 16:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96DF6B009E; Wed,  5 Aug 2026 16:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 910A26B009B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:28:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04282805A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:28:19 +0000 (UTC)
X-FDA: 85068353160.09.5863104
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5739CA0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:28:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dr44f45G;
	spf=pass (imf25.hostedemail.com: domain of "SRS0=eFs+=F6=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=eFs+=F6=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785961698;
	b=n7r/DJPDfXjfVX77kdAUuXMxJoPT63446bz58tiXTlKV31PQsp61AoGHmVHgBm195Bqky+
	KQLMWYmK7VyrY68yLeOjnQp5Y6V7EoRCweDtRa2SNFATd78jv//+vPCXxYv4jwTyfsb71Z
	kVnrFrFXdt0ko/EihUGEfq4pd4JrsKI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dr44f45G;
	spf=pass (imf25.hostedemail.com: domain of "SRS0=eFs+=F6=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=eFs+=F6=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785961698;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x//7cg82AxdHhRxcfxHQ0yr45Yja15SXXIZkpTkrczU=;
	b=Y97rHKkmz/kVRWAQ8bjfb34oNa+Pvfgbc5yG78dAQ0O3IdBNk0WvF1gKsOWEpFf9IU/l2w
	zSjocnu0RC90QZm/dC3TPPA+3Vk1saWBvAcFiVqht4e9aQjSSGu8GmzfLAGkmMOimTTB4O
	bhguxKLbyGRaVClXRCsNJAYT1ZYyYxQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA6E16001D;
	Wed,  5 Aug 2026 20:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7891F000E9;
	Wed,  5 Aug 2026 20:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785961697;
	bh=x//7cg82AxdHhRxcfxHQ0yr45Yja15SXXIZkpTkrczU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=Dr44f45GQ26ueV0EcaR1biLn/J5lNPQjp247RB/1FWDD6rE7iUGg2heNP/ySpHcvQ
	 jKIumJG1QfmdH2bRFGn1zaY6AtQSIEcK6Bbvf41VtN5sEiBNd6uY0ctBLGicOXYKVa
	 cphGCoBZ732D+g2kpQ9a8T/zdxNeB9LjzhqMHvexvnA/rFRiZm77ZmTLljZ5lZeNVn
	 MtEA37P/Jisbo/lfNi2SA7aFhh3ud23JKW+YzGXPdbv2yzLFckqhCVROvveKfUrWJ3
	 mOC7MOvWSv6tsaZOFj8lXt6z+lROQisbVeKMltqLvib9qVJmAQ3Ns0N3PGq5bbm4Rd
	 wNjw6ubDChz1A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id EDDE8CE1402; Wed,  5 Aug 2026 13:28:16 -0700 (PDT)
Date: Wed, 5 Aug 2026 13:28:16 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com>,
	hannes@cmpxchg.org, jackmanb@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
	surenb@google.com, syzkaller-bugs@googlegroups.com,
	vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in khugepaged (3)
Message-ID: <d5771d33-d8f8-4fcf-911b-089e862042e5@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <6a727d6c.9511d2ce.1fc5b9.035e.GAE@google.com>
 <20260805122952.6ae38af69a0457779cb44359@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805122952.6ae38af69a0457779cb44359@linux-foundation.org>
X-Rspamd-Queue-Id: 5739CA0006
X-Stat-Signature: 8opwetibnzzkgeugmunjnpgbsseg3q3p
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785961698-902515
X-HE-Meta: U2FsdGVkX1/bJ0m/bCC93EsEp5ZB22MinqWONGieJnFDJxoowiKQTiR8BeiZWGGgNGStd0e5Z3hfPQLICTGTyq/pBXeFQjp0QhRvv2Du3rKWksIIBfvzMjI6smlpcOct7ptMJGBEZ2zvx+g/IPLoehunLNSmump/PivNive1XtrtQDIZi6PKIZ6HbuMk70l8raTSwngf2uZSJ5NDASso8rVYZFdOrQWf5UOPbWuSUCNQcTRVkwrBaFVFxaRUjCZdTL2ZNuyeczvtdDFPiiMmhTB+W/xQN0xmRYuXFP1NlERFOO8wkPZ/rmU0kUJM5FmYRA8gK6ayJOQgjEWZlT245a/LOKKvJLAM+vJrQC1GJFRq+lzvw8NUsG8gkGumPec8UqcMYUTWGnlJr4frgm5moAO+U3bYlsPxagC47D7EMncaOWRo4cdKhH3leHxd1EGsHqpp40sTe7Ulyh0Ff9EBF070U8NKJLJDpHQui3aqirNpUt6YKWwmrjEphKO/nbAc+BFNoMBrW62FSmnbYTSfEBAm7ZAX9w3bB2SV8VG/D5KkKRHu5612nXucp8D78GIdwOkq7wbCwpiWxXiAEoXuI5e5U4YG/RAt61z7yWY2qgXDliEbooF+S4mm3gvy7HYsWJ10HuDLhxbrwNvTC2PSv/QKhMk9CU7Tf9M8kaXOZzSAftCyJdGWCZmI6PFASakLjpmug5cz6Xc13jdIWP0Go0VV8NyQnISTukMQAxkML2XBXjzz1vwXANUAl7KorxQNEoOA/3ihXX+Uk9IbJ+E8TjppXpQmc6hZCdcwhhpKtBcVRVf2/H72DqEFlieWn4MTqWeKDCqRpixXehUkrveGRXSKSbOKMSKUCYhHw/wrLC7/izA/3H11Kb0fJDdbZIScS8iH66o/eRHVyQxZUI5OVRgKJMqETpmup25xwyhILmI+JTWtaH43Rzzcx4ockazLucf/K4QVOHxu0kmVstD
 JYESVjv6
 tAJEFz9ErwvCWzHqU5MzP9qLFwnceUENoqlahmAb/giUBl43KHlUGJ/1xiMpXWC187ZCqxEnOte5cpGJdJos5yWVQ+HRTjb0pizTeA0Ka+dlyjDkV7ibNmLuhAK73cK0t3Ltnf3oe91UeGF9pk8ZQrhzOsKvw4nxEP0s0V7cxyPXTSfIzoqWo/GL5mk0prOzxu7x9SvGQ/aGnHSdMO3HTweaPPwP6dhKrJjVEi6pHkTyDoqiMMMktwfP57oeVIbhhzGg9Lfq/EDaqRFaq+UMTOkMNj8wjxb9bLVcILmqO81ZXCfCFDkghDF01emsUGtoDvrNpOmpRc5/FOV6zr0xIBbqQbzSQ16gnyoDrIgSHM1cJxqRTmJ+kl+/E+Hm4O+YJ3PjeSmEnHNja4b9v6yUcyP2K5AbjvKQ+HEQxMk9RjCpNFpGU2RSgSnnYz8srn23PXhGSejHtdp+ygmWMICG6UswsujvwoIyVF4IGSPuhgX0dEbOq0p9IQuzEVuXv50SadTug4OmXY6pDKAmoDHXzJdTgsZhd0osNL1l1b/h4Fz58nlf1iFEAZEq+OB5TICiLBhHO6uhFk4qZ2SPTT/7dWbDjMYF3hBogpJqUZbk0h59V8lC2hybRjW2vzsmLrLjNP/A06GDoRL7jpRJG8y97pbXckiEmSh5MzOmt0Ms1FRwV5InSk89noj/Qer1YhewfXO1PevLNMSoGwMeZgMJrE2ruX2taX3LZWkMSedcP6yVhTehhyzobc1iPeLfjbXMc+XEe9mtaM14sPa2RhCWN+xs9r+I1va4kMUywdFcg1QVrWnaalHYiKd8z9iCDX2PyUp4yiIyUxuYkw3aNigdC7VGb823HEmRydb9Mtiq7QbnWIt7mDioTzzk85mU7iNgrODxd7GDjwNJGnpmGji/lQ0ABetL4FXxcc/2FCjPNjsgLYujIKTt4JuyUT7zTvG4m7Z+NF7m08MHvg9DoeeC7OUJmmylP
 FV9fBccA
 zYQCWt4vwtYQm9fYaxVbNjWEcmQ0AEgLO7TJcJ2i0OEz0mOJNRbG+FOHPrultFuZXxA5uOS1Tzonnn9h6k09cog2mewsJ2f8jfV/9Oqluyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 12:29:52PM -0700, Andrew Morton wrote:
> On Tue, 04 Aug 2026 17:01:48 -0700 syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    3708dd948844 Merge tag 'pm-7.2-rc6' of git://git.kernel.or..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11ac703e580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
> > dashboard link: https://syzkaller.appspot.com/bug?extid=d2401aeb74cc84adba04
> > compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> 
> Thanks.
> 
> Lazy optimists (ahem) paste this gunk into Gemini and ask "what the
> heck just happened".  The results are often useful, but should be
> treated with skepticism.  In this case I think it came usably close.
> 
> 	https://share.gemini.google/vq4TLhTiLBih
> 
> 
> tl;dr: khugepaged's collapse_scan_file() is taking too long and RCU got
> starved.  I don't think khugepaged is doing anything wrong here,
> per-se.  There's a lot of work to do and we're doing it.
> 
> An appropriate fix would be to take a break, let RCU do its thing then
> get back to work.  But I don't think RCU offers interfaces for that?
> 
> collapse_scan_file()'s main loop has
> 
> 		if (need_resched()) {
> 			xas_pause(&xas);
> 			cond_resched_rcu();
> 		}
> 
> but that won't help with the RCU stall detector(?).
> 
> I suggest that a suitable fix here would be to add the analogous
> 
> 	if (rcu_i_need_to_take_a_break()) {
> 		rcu_read_unlock();
> 		rcu_take_a_break())	
> 		rcu_read_lock();
> 	}
> 
> (iirc rcu_read_unlock() does an rcu run, so rcu_take_a_break() isn't
> needed here)
> 
> Paul, wdyt?

Let's see...

The console log says "rcu_preempt detected stalls on CPUs/tasks",
which means that cond_resched() is a no-op, but it also means that
the rcu_read_unlock() in cond_resched_rcu() will directly take care of
informing RCU of the pause.

But that is clearly not happening.  Why?

Well, we have this:

rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P37/1:b..l

This means that the task whose RCU read-side critical section is blocking
the current RCU grace period isn't even running, and thus cannot invoke
cond_resched_rcu(), let alone the rcu_read_unlock() within that function.
So an RCU CPU stall warning is expected behavior.  Or at least it is not
in any way ruled out.

What we need is RCU priority boosting.  Except that the .config file
does not enable this.  Not only is there no CONFIG_RCU_BOOST=y, there
is also no CONFIG_RCU_EXPERT=y and no CONFIG_PREEMPT_RT=y.  But there
is CONFIG_RT_MUTEX=y and CONFIG_RCU_EXPERT=y.

Because we don't have RCU priority boosting, if the load on the system
is heavy enough to prevent our poor preempted RCU reader (PID 37) from
running, the grace period cannot end.

I am not sure why this task is saving its stack, but maybe that is normal
for this code path?

My bemusement aside, I recommend running this test either with
non-preemptible RCU (CONFIG_PREEMPT_LAZY=y these days) or enabling RCU
priority boosting (CONFIG_RCU_EXPERT=y and CONFIG_RCU_BOOST=y).

Maybe RCU_BOOST should no longer depend on RCU_EXPERT?  I would of
course need ot remove the prompt ("Enable RCU priority boosting") to
avoid annoying Linus.  Maybe as shown below.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/Kconfig b/kernel/rcu/Kconfig
index 1a5fb3156c062a..5141ad8d1cd029 100644
--- a/kernel/rcu/Kconfig
+++ b/kernel/rcu/Kconfig
@@ -237,17 +237,16 @@ config RCU_FANOUT_LEAF
 	  Take the default if unsure.
 
 config RCU_BOOST
-	bool "Enable RCU priority boosting"
-	depends on (RT_MUTEXES && PREEMPT_RCU && RCU_EXPERT) || PREEMPT_RT
+	bool
+	depends on (RT_MUTEXES && PREEMPT_RCU) || PREEMPT_RT
 	default y if PREEMPT_RT
 	help
 	  This option boosts the priority of preempted RCU readers that
 	  block the current preemptible RCU grace period for too long.
 	  This option also prevents heavy loads from blocking RCU
-	  callback invocation.
+	  callback invocation.  It is now automatically enabled in
+	  any kernel that can benefit from it and that can support it.
 
-	  Say Y here if you are working with real-time apps or heavy loads
-	  Say N here if you are unsure.
 
 config RCU_BOOST_DELAY
 	int "Milliseconds to delay boosting after RCU grace-period start"

