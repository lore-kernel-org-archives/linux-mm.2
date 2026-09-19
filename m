Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174D6C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 18:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E976B0088; Sat, 19 Sep 2026 14:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F9C6B008A; Sat, 19 Sep 2026 14:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DCA6B008C; Sat, 19 Sep 2026 14:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 386BF6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:09:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CE18802EB
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:09:44 +0000 (UTC)
X-FDA: 85231299888.29.5843D7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 29B5840003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:09:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZQknuCp;
	spf=pass (imf07.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789841382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRkKN54/lEpILJ2Lc3rIPCovoIruayWHBPFvaiFZSfg=;
	b=RWWKbWR2tq2AG3Mfn1Vwy23zgfzexVqEeZmEw4zBmZm4DGgK/hqAYsZoYPJTq87lc4zipX
	A/kuog1lGvuizMqKFzf9Ssj9CZmX8jn6fuC73BeY7BYagLGMvPN+PADhgALfVs9sOlTGRD
	Bcv8zuqhx9acfkeXdHsHZnQY0kDEKeQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789841382;
	b=A+oADhgchThgB6b61114Pdtu7RIIAbd8N6KDoWWXoOKrfI+/cpHRmSApaP3WCGntW0Fq0G
	M/IdJEwvlux1jZ5Wb4R33ziW+hrqNsa5Rads+so0UMiSIlBYb7MEkCBirc2f56Ru1dcZc3
	cO84eZF1B8OBslfzODwoqhqHY2WYKfc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZQknuCp;
	spf=pass (imf07.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5152843F3C;
	Sat, 19 Sep 2026 18:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20A31F000FF;
	Sat, 19 Sep 2026 18:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789841381;
	bh=pRkKN54/lEpILJ2Lc3rIPCovoIruayWHBPFvaiFZSfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EZQknuCpAn6VhFkE11h8jenhrI4HVTY2xd86t8bn8u2hDTJoIbcri7TdMgMyiG7o4
	 gi3B1uaAlUbAAMawl7VGy2i/ZPVfFxrrW2fJOu2h3r37bnHViO006b6ANVJVNRGfh9
	 Xcv+CrPGJ/hABAO/tJf3P9gHgoGMHvhmneQSO5QgIMC83+clnuxzTY9ZkQ3TM1grjN
	 R8g89Ta3fdG8wqGMv5ZB2GBFaj7ZeOFv0oND6dHY7+iQhZz5GjpjAmaRXM5GmKgxfR
	 yS3Pp0FQqQii90SmnkXB0bN9qeFbRMEDVM+ExfEWjVEE58fYVwnqczlxqe5co57ZbS
	 ZuDKmHiJxA3qw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1AF8AF40067;
	Sat, 19 Sep 2026 14:09:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 19 Sep 2026 14:09:39 -0400
X-ME-Sender: <xms:48-uaj03fZEj7cHpDWORJbyQPbpM96eqi3yckBVPvXmAMTh0iUKvcg>
    <xme:48-uahX0KaNHfxdjAFUI-eGl79_eHiYORDtpmExPDJWpoVoC8-qCe5z9Pcw9kGm7K
    _O7CBQg_VzzakRHxjlV8hIBvV4dwGMCfkIhutAaXc97LdyKSxpLmw>
X-ME-Received: <xmr:48-uagFg5KGN_N0j3RUZMEwwK2VEDFa0gAcoMD7jqA1fkex0018SNFkmDrcX>
X-ME-Proxy-Cause: dmFkZTGOMHCFM13kMXhSuxN+36n1aHNShRaReTqrePSRKG4sq5ma7+YBTXTUakJSy0zQLM
    e7xl+opaW4Eklevv6jRqJbW6Ywolp4n2PLcr7z/kaFXF/JfmFMj42KNPrSbAy7BXxgXzKi
    K4Sf05jy08LVD0d/b1J3hn9fSSOeAwDxxhF1N6NgIYS5pxn06yIyU1et2HdSGwkwcXGE4i
    MkaDamDvlYs8CbIfaCWEJZfxMLEbM4jNoxyPEVb/dusx2FueAsQu218naoj+uCejFkf0gZ
    0vYG0lXFuDvS4tBfEB5M9pQQx6pvb0gUCQVXBb+ThkiDYPQir7M3OLR/P59q2sABs//mH8
    j9hsOWIHebLFbWTuuJePNyDqBriGyy6d/HcNofBWa9p99Z+Sml24G4SHR3qrMwDVhvKlaE
    wvYpp/p3L/t1CwR12MkQWvyCTcZtnvb5M9AojI42S3EkUafdT5Gkm9/OrC3ZgJAUGgfCaJ
    rl0qLVJo/mjhZ65KxURcNR42IhwuCvrN2mQHcR3BA0e4YRCNpCvwHEPmp0/K7JhOAPXNbm
    FZvDwo6b7d5c2sle6FZSI042g5+Uud+HZasRlgd5pM+QWrZD6qduHhCKKGCX9Mxb5RleqH
    WfuLDhk2yZTzIS6HMJ4PMorpBl+Z8liW7G58uEKydyqW98XrqeN00SygaH5A
X-ME-Proxy: <xmx:48-uajn_Whc5-eia00WIRXUd6GjcVIpOpqC-uG_gWU6S1ZclEt5JHw>
    <xmx:48-uapGN3GadguAI3fAx8RCw2-ssIQFR9PoWpQ9eKAKXwRJYUTg9Qw>
    <xmx:48-uapurA1ETP5KWKlcHPoEvrIWmA-a4K0tVn5Av0WYKlLtgIEG6pA>
    <xmx:48-uakhZUpTK8dS_zOmc5xiaZvK-f4pbjQvNRIuUA_1VKyA4_dAKbw>
    <xmx:48-uam37EVW_RTtA8S3tGycD3SLOkHcLTEGYnsOYXnBjlrb1OV8kfmdO>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 19 Sep 2026 14:09:38 -0400 (EDT)
Date: Sat, 19 Sep 2026 19:09:36 +0100
From: Boqun Feng <boqun@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	"Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Steven Rostedt <rostedt@goodmis.org>, lkmm@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>, Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,	John Stultz <jstultz@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,	Vlastimil Babka <vbabka@suse.cz>,
 maged.michael@gmail.com,	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,	linux-mm@kvack.org
Subject: Re: [PATCH 01/28] hazptr: Implement Hazard Pointers
Message-ID: <aq7P4LUkXsJmB2h4@MacBook-0RXW5>
References: <e9669b34-12c2-4cf2-a887-315f581f0789@paulmck-laptop>
 <20260919000056.3132131-1-paulmck@kernel.org>
 <CAHk-=wj9knmxXD01=top1DQ9_aqrN2a3kpWRS5DQv6QLwLOztg@mail.gmail.com>
 <6B1FC39D-6EB0-433A-8E49-E5EFC9379AD7@mainlining.org>
 <CAHk-=wjyniJy-CX1muCrsZp-i-sLGRYeRYEPN7sw9orRZUCwag@mail.gmail.com>
 <e6177659-ee74-4dad-8fb8-ac2a755c5c1f@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6177659-ee74-4dad-8fb8-ac2a755c5c1f@efficios.com>
X-Stat-Signature: bj4xsqazwoy8u4edyobpw83knesdz64y
X-Rspam-User: 
X-Rspamd-Queue-Id: 29B5840003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789841382-204996
X-HE-Meta: U2FsdGVkX1/hlwpZJLBKOTytfvqKGEJB7nFVgdW4whDWldhBsuhxHtKSjGOLc/J4MobZgxQg+hmWSgM38J0BADy9lHGY8ETS/d9B0bQLw2qtUpWMCBqwkde/MZvflX1U/e+k7gwugf0KOwX1Z/KJAZHTFczwY0NwtbVtLTzgtXsCavlwKEotJagJvO2HzMbN7QPR92wSFeSpYOMk6eHL6MC1Q3y0qQtqvbHCW5oi5J65X1B+Op5HW6F1HId4J71tl6y+VN+oAZhq71t5ZBT8DDKCwR9EBJNKXXp1xOZcjMq6R34o3Exvxlxqeh16ORxJL5tx4PnIA0jDsAzTQNbOP8QwhseHF/Y2AsHLyEPpO2iw6w3HX5FSLzZV7/yHUpyUX7v9tejYzjKAWSnNwmTGLFOi7k6aKOqZbRLX7iAmzwh03TGoOQC07Bei0YFHh6gFHhplMYTaTlRgGIwdh7YmJ69VaMCLGvK3h/T10wt720Imft5+XVELHiC2/FSbRfrWKFrxuWh/OlFwpisNxsGNWu7jr6CDaqZNCi6LfhVebzr1Hvr8xsEC2SEah8VxOpWW15Mks2WU+pIRRnxPiGQt3sPXp7vg+dckA/hesonn3mRSbVjuorpnY3nMj9GiEzB8djkNNkKsETkH9Nk9ukwHP3Xe/I7lAppzKI2gZEi4naJcr0q1h0MKLQJI7t3b+mh/Vicag27i5hSBst2iGbURyU6rER0k8Skt4Zic+SMvflSUmPfEcsCnWGeUfy7sM+ZvSgHc4EeiPtF3pCWr+f2xOXVXvpSY/m9rQP1CAtm/q/D3UJc2wTz63E/KkKtBBUmTAPGnZjjsY6jGZ82qs+wlrH8KZYOYX/khA+ZhFr2uKUIe5UWTz5dmWg5pxLLXzXDnh3yqBSvxINAqJfb/RoRgszjNxM9ftbFzN56iFA1bC4o230dXRERaa3S73nTZq5EeHREBLRnWsbcgDBv9mEn
 TGsVgonF
 XnLIEtOjzbrjXzZP6KVzQ1VLoZFlfDJFzGhu40+vl9QBTnW/Sq+WoCizf2VZo0NCsrqw4nYgeWWbfx7MDaZaNmPCNp01ydjUCr5YkcVXQqCj3SwGz3wosBnIkpkXdE4Z5tKsrONAZPpItVstwHWFYcTm2ry94lAvFyTfGdgXdosDVbigsEQbbDf/UKpEzM1QCXa8E1jQoQBymoG4immSHNq45DQ2oFHTc63yDbFAVJJ7hUTNbGpZO6HNvU4TB1WEItuhVpCxT7SAcx+c/y4nd9cO+Q1rax5mK6zhNcWfry/vvbv9GTLUJibtuxFJbbXd6AL+u/J1yyA6wQaioW6vkvEq8boP5Jf5GeszP8yh481hGpn1tzanvVSks9quvMCPUZNmUy26H6EFTZxBZ4DZEZCWyCv7BERBVVteHHaRjABd8sjkFZNcf3HyDtNXGNJ56tW/u5j6qwljS7lRS4vQ5JqODhfOEK3/8r83fa7Ky0wmg37tbd4c47BG4Cfq9T7xY/XjACrgpfTwqV8O105VoJ0Q0rQTL/RbAuX7rCS0Guig/PtHy9VlTlAuAYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 01:09:15PM -0400, Mathieu Desnoyers wrote:
> On 2026-09-19 13:00, Linus Torvalds wrote:
> > On Sat, 19 Sept 2026 at 09:35, Bradley Morgan <brads@mainlining.org> wrote:
> > > 
> > > I think hazard pointers are good, what test do YOU suggest we do here?
> > 
> > I want to see a single real-world example of "look, this speeds this
> > real load up by 10%, and the kernel code was actually cleaned up in
> > the process because hazard pointers are great".
> > 
> > Not a microbenchmark that tests just the hazard pointers themselves,
> > but a real kernel feature that has been converted to hazard pointers,
> > and in the process actually shows improvement.
> > 
> > The ONLY reason for hazard pointers to ever be merged is if they
> > actually buy us something real.
> > 
> > So I want to see that 'real" thing.
> AFAIR, Boqun wanted to use hazard pointers to cleanup/speed up an

Right, that's why I send this series:

	https://lore.kernel.org/lkml/20250625031101.12555-1-boqun.feng@gmail.com/

The gist of that work is basically:

	On my system (a 96-cpu VMs), the results of:

		time /usr/sbin/tc qdisc replace dev eth0 root handle 0x1: mq

	are (with lockdep enabled):

		(without the patchset, i.e. using RCU)
		real    0m1.039s
		user    0m0.001s
		sys     0m0.069s

		(with the patchset, i.e. using hazptr)
		real    0m0.053s
		user    0m0.000s
		sys     0m0.051s

i.e. almost 20x speed-up.

One important thing that I want to point out is in that series, I
avoided the busy-waiting in hazptr_synchronize() and made multiple
hazptr_synchronize()s share the same scan. And I do want to see this in
the new code. But unfortunately with the new implementation, we don't
have that part yet. And that's what holds me from trying lockdep
integration for this new implementation.

I could have improved my skill of time management, because I know at
certain point I said "I will finish the scan thread work for your
implementation", but it'll be helpful if you or someone can help get
that done.

> hot lockdep reclaim path. Boqun, Paul, how is this effort going ?
> 
> I suspect we should wait until that lockdep user of hazptr is ready for
> upstreaming and propose both at the same time, because a synchronization
> infrastructure without any significant in tree user is not really
> relevant, right ?
> 

The other thing we could also do is what I did in shazptr, getting the
numbers with rcuscale, that can tell use the actual waiting time for a
hazptr_synchronize().

Regards,
Boqun

> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com

