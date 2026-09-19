Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2360C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 18:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE266B0092; Sat, 19 Sep 2026 14:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95FA6B0093; Sat, 19 Sep 2026 14:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABD66B0095; Sat, 19 Sep 2026 14:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8116B0092
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:18:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC02A1A02EC
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:18:31 +0000 (UTC)
X-FDA: 85231322022.08.ED4400C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2771580003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:18:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C/8IJ+cP";
	spf=pass (imf30.hostedemail.com: domain of "SRS0=+MjM=HL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=+MjM=HL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789841910;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyIemgWwjEQt3L+L8axqzmGHSvJ7AdeLk598yESsBGI=;
	b=ogKMKo74REgAZ10ockSJ7ybQM+k8qjWg5bT1JTaNBdYwA0y4mVPbXY2VuScXE8QoJasJJy
	Ug4HMYPEEMKfq1Nr1Stuhex5BVNqxNDkE94fh0YU8PsUYCcVqJKtdqyjSvVNNcsLfOmm0o
	T7lR3I9Q7K3yWfg57VUp+vfHEYiwThI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789841910;
	b=iZtQCLvrkzytpAi+Z4bAX+j930+ZEhpbk+gCtuTj3Y/hgE9xDkaqNeP3BKsDs9XyUhLhVn
	Y88sfgOVTk4qK2CAIVM/O4hIeh5rVPGQYAkOMWDmUuTd26N4AC6K0t4jbCj6+MA86+ujW7
	M2cNhoomEGdudeUQuXKhWE/asWL5w2c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C/8IJ+cP";
	spf=pass (imf30.hostedemail.com: domain of "SRS0=+MjM=HL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=+MjM=HL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81341601FB;
	Sat, 19 Sep 2026 18:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3508B1F000FF;
	Sat, 19 Sep 2026 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789841909;
	bh=pyIemgWwjEQt3L+L8axqzmGHSvJ7AdeLk598yESsBGI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=C/8IJ+cPchuSvWh2/MxbtZPVyL1SjYKc4WXhx6R5cZ8sO849empy9OJwygnCknBX9
	 LS0Iqqfn6V5Z1h0JG1qUVKf9ea2HYVT30qIGRHdnP1XZ8UWHJ4YpkgHmC2HkV5s0gX
	 mx0/oSOBh7QA3iOZ0E/hOerVDWNOt+SOJUGUJsSea826IzlwZFx6EKFYhiXVOWrygb
	 dFgoRw90kA2b19NGTt6Z1+i6jE++aYpKXWkfZJmT3MCxltSlIRdRsx4YKWYg7FmUUl
	 v57bGYi8C3acUYW1teyDCheNQDUiXJTOBLdtqRjHN/XWQW65fUQ6bmgFxOj15iYWL/
	 ai9pfvIYdXxCw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id E6C70CE1579; Sat, 19 Sep 2026 11:18:28 -0700 (PDT)
Date: Sat, 19 Sep 2026 11:18:28 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bradley Morgan <brads@mainlining.org>, rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Boqun Feng <boqun@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	lkmm@lists.linux.dev, Zqiang <qiang.zhang@linux.dev>,
	Wang Lian <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH 01/28] hazptr: Implement Hazard Pointers
Message-ID: <c67ddf7a-6f79-4145-858a-291df86e5274@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <e9669b34-12c2-4cf2-a887-315f581f0789@paulmck-laptop>
 <20260919000056.3132131-1-paulmck@kernel.org>
 <CAHk-=wj9knmxXD01=top1DQ9_aqrN2a3kpWRS5DQv6QLwLOztg@mail.gmail.com>
 <6B1FC39D-6EB0-433A-8E49-E5EFC9379AD7@mainlining.org>
 <CAHk-=wjyniJy-CX1muCrsZp-i-sLGRYeRYEPN7sw9orRZUCwag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjyniJy-CX1muCrsZp-i-sLGRYeRYEPN7sw9orRZUCwag@mail.gmail.com>
X-Stat-Signature: m6kpshi9mzpr8scz9iu8uj4hohjgebh8
X-Rspam-User: 
X-Rspamd-Queue-Id: 2771580003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789841910-433885
X-HE-Meta: U2FsdGVkX19iYT/yB54c5cg+HYiBE1jmVTGHDUk2qpAW4NhelBDQIcb1yl5aQ9x41nudJoe7WIfTyzzn4wBBi5wwc+PIoQHPyPyiWNZr9FYUNa3mYxcEMv4vnL8DKH6cQ0uD+PGR72/P29oFITV5E0UUXpWYlhE+yaYjFQyReQ3kjbJkn+iyjItFq09IW+s47VRmpHqFcFQpU9YHzlJo2WzHHrWp/Qc4mq4L5qTDjjeKKHnqjZZVt1XVPtZpYh2eO+7tUk52h/OK9Qnaisb3aHikqCj8Xco67zrDMnV12HhyGxGW1dbbOFgsxAKS5EYZmzZxjEXImeS0yXN5Gy2NruqIO8tcMYPEElktu3HJnAcFsNLuCzssYLUDFtXsmMKFR0mmHtK0hzJlGyTu3TMvUtp60ahWZVcRglEBfwBPIvwqQV2ehy3NxYhq5aANgRGaE5f/GQvOTfQIcwHBNJyTrhlldGaSlzfHFlQRKTWpjba2CtC4k0tX6n4Ml+12VGaTG3CVuheDeBfahW6w0vhrpaKisAidAxETyOxdyNvzB4KgRHILrXq5D7k1SZ3oXYl2N081Ytmz3GtVAgzJBZglWxni4YwXwh17gCw9RQc2i8qRBCJnQu9sHiSo8dJ+NquWwypmCh08pULX0s64HAHesiY/AZPYIPVu7/F+vY6lJE5DCGMrQPw4ewz/OrXWzvYzn8trbwRXrYC5Mkm6uENmX/XAFceW6zc9dQYFo3HFeAgTZAKyStPgos4+BHZ691wenu5h3HSlWMqBE9yDkcjTY+qS6uaFw5W32VyPEhuCac+J1GGQ3aMvOmBr0Uw/8HKt4S7UJuJU9KEjESl8EwoUthZRRbqAjeLiAmIBbEiviVIR+n56r6lYzf4jKfA2o2+Z+H8NUPwLjf7QHuCyWEO3EyetCiJAa/8uIJvH+VmHcgdb5/FaGTBjfZtv9EHXuqo9tvDuwgilaa5ora+yNbw
 MK6/B5D2
 8xP0uIZFap92lRcundUzFlzzoJ58T3pvSOU/PIEABXQc40osxmWgKJw04O+oCDaCnnl/0neOzXt+WslA6x+anIGpxs5tsldqJyBsJrPPz+VCoibZo/y6nBD4pKsOIIokD4ejFoejn+dpFhbyyIwARXDgKYMrXhDstpgznv0EzPPBQrTTRZcoGNQTwWUyzIqdafIl0Cg1CMrpTwi5mIps/QhCnlRLMyU3YW/UCTAbPdyasCwHSo7HCtgSNxaIal24wYU85zvMf5nfG0cWRmaRo5vRkCM4dhUtiNoSh5p4W+SwjvY6eE1qwO3uj3pJgQ/kBcL3B8ONRDitrL3A801Ti6CWAlbtNXte74giiypW/VYrFNlvGSpU5lvy8Jmk+Ojd2BpBoroBejN5B92Tl7Z04J3VHWb8fOwkK4C1QzaeOD2TFmK+zPkWtx48p7ABTc43vhD4byNtUxAiKyGIDBjtF+kHWD1vlq84n/+YZ14CwR0jXsIuZDqtpP1xYNAwH/YfPR4XeQ9CYIMaH6Bz5xNkoOFpb7Oh4geytf0rLXgwoAlEc3afybWzto6bLHqfk4zqe/MRzq7NSqwBXjp2j4Mxl4MrjxNiYFLmOuOM16gpI1Cx1o55H7dpXqqRw4G4pofap+tgErF0aHjRXrtfZji0ZWEM20kvIcwfJNroQlKtBZK/5//KXGU2/JrKl2OpOY7Epu3XJhsSz+2ORtjrY/1UzCTJ68XDHWneSPF3fXXjHHgA9f/Um3/RA16xmsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 10:00:06AM -0700, Linus Torvalds wrote:
> On Sat, 19 Sept 2026 at 09:35, Bradley Morgan <brads@mainlining.org> wrote:
> >
> > I think hazard pointers are good, what test do YOU suggest we do here?
> 
> I want to see a single real-world example of "look, this speeds this
> real load up by 10%, and the kernel code was actually cleaned up in
> the process because hazard pointers are great".
> 
> Not a microbenchmark that tests just the hazard pointers themselves,
> but a real kernel feature that has been converted to hazard pointers,
> and in the process actually shows improvement.
> 
> The ONLY reason for hazard pointers to ever be merged is if they
> actually buy us something real.
> 
> So I want to see that 'real" thing.
> 
> I want to see how easy/hard it is to actually convert a real current
> user, and I want to see how it actually results in measurable
> improvements in performance.
> 
> Something *core*. Something that everybody uses. Because I'm not in
> the least interested in a new subtle feature that interacts with the
> scheduler and is only used for some random driver or (to pick the only
> example I have ever seen) AppArmor.

Just a historical note for those who were not around at the time.

Linus had a similar healthy skepticism of RCU back in the day, and
we (well, mostly Dipankar Sarma) did deliver the required use cases
and performance results.  It took about two years, with the earliest
discussions at OLS 2000.

And I won't be sending a hazard-pointer pull request to Linus unless and
until we have something convincing.  And if I turn out to be easier to
convince than Linus is, I am sure that he will let me know.  ;-)

> Now, obviously, the thing that would impress me is something like the
> dcache. If *that* can be converted, and it shows real improvements on
> some real benchmark, then I'm sold.

And yes, the reason that I am pushing this is that some corner cases are
stressing RCU a bit, and perhaps hazard pointers can do a better job of
addressing these situations.  And maybe dcache is one of those corner
cases, but it would not be first on my list, in part because hazard
pointers tends to have a bit higher read-side overhead than does RCU.
And I don't see a way that hazard pointers could eliminate dcache's use
of seqlock.

The most obvious potential hazard-pointers use case is where someone
wanted to use per-CPU reference counts, but couldn't due to the high
memory footprint of all those per-CPU counters.  With a key word being
"potential" because I don't know of such a use case.

But if one shows up on an emergency basis, I want at least a prototype
of a ready solution.  After all, the Linux kernel is a *lot* less
bug-tolerant than it was in the early RCU days.

> Now, I don't really expect that kind of major test-case, but I do
> expect *something* meaningful. Not a driver. Not a test module. Real
> code.
> 
> IOW: "Show me the money".
> 
> Because the kernel is *not* some kind of acadmic project. Never has been.
> 
> I simply don't want to merge something that is touted as an
> alterantive to RCU - which we obviously depend on very very heavily -
> without something *major* that actually uses it and shows the
> real-world advantages.
> 
> The discussion about hazard pointers in the kernel has been around for
> a few years by now. If there isn't some real core feature that was
> converted to show that, then I think that's already a failure
> indication.

That is of course completely fair.

And there are a couple of potential hazard-pointers use cases that have a
reasonable chance of working out.  If something compelling does show up,
you will of course see a pull request.  If not, maybe I maintain hazard
pointers out of tree for a few more years and then drop it.  (At which
point, Murphy being who he is, a use case would promptly appear.)

> I'm hoping that those patches and numbers already exist, and I just
> haven't seen them.

There are some, but not yet compelling.  This is still a work in progress.

So why bother you with premature hazard-pointer patches?

Because if a hazard-pointers-shaped problem does show up in the kernel
somewhere outside of my admittedly narrow field of view, it would be
good if you were aware.

							Thanx, Paul

