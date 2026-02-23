Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BF2EC110C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062076B0089; Mon, 23 Feb 2026 11:54:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022716B008A; Mon, 23 Feb 2026 11:54:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71406B008C; Mon, 23 Feb 2026 11:54:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4D176B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:54:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8663CB61BA
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:54:17 +0000 (UTC)
X-FDA: 84476319354.09.9F0AE7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D67C140005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:54:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDElEk2t;
	spf=pass (imf23.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771865655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtLhSSxvhi++dL0VgIH0FuZDa5E5v5PoHVrBVy5/dm0=;
	b=n95Q8dWXoCKi4PGpdE2TFWsIWUVR1+6TtN5gdfDNZSyg1v1njiEn9Mr/YCcJk+Z0It1gbH
	gZkjSdxuvx8iKLTKNNC3533vITEa0KjB0ng91B45/2bOpiWlAWGNY78Xv+gRRfdJtFcMf8
	f109MV5HniJjp9Qz92w1DaJ84GYo8tI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771865655; a=rsa-sha256;
	cv=none;
	b=w0yi2OL2Yh+BA8Ra85AwoXuNNSM1NKEkEKBdEPLQ8fymheDiEJA0N3c635MatXiNE+0uG9
	3Yi1xm20v+gl0nApLhN0vq+wpO5GsLN05nOaPAtCE+JyycO5p+8eec3cdtlA+THVUsPt/s
	QFZvOcBOh/19ixVc1Zp+Q1+n1CpmHUo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDElEk2t;
	spf=pass (imf23.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29BDD40B02;
	Mon, 23 Feb 2026 16:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43055C116C6;
	Mon, 23 Feb 2026 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771865654;
	bh=YodYJnZuKSlNBlkEnj7GRn/UmmZhwjmLQMUg4OcMz2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KDElEk2tgBble4V5qOG+eLKPjopDoG4X+CBVoR8V9XhR8/HLyxKZQty0THX36Ut42
	 jzmhdIxEFGFx6DzpFQyt0fyAeL5U7MkYTL1aeMS5s74jb/e3WuByeANvvRyditqAoj
	 FfdPY1t10cRvRLIiRO/1LaJqJUd0tByErLU4z38zg96JCBGLIG26bXLnKVwtaZdbsP
	 E+pvk00UzTthSf4/iHoupYKd3mGg8X4FRm8u2OsLn3ABGWNc3Pw1+GfNpFkGh9uKH+
	 6D1twEY9OOTfE/7NBlQAmQqh42KmloYHrPBcmHL9c88XuLBJLt7Zv3nA8aeJDDuGhg
	 q5G/gCjcK8ySw==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4A523F4006C;
	Mon, 23 Feb 2026 11:54:12 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 23 Feb 2026 11:54:12 -0500
X-ME-Sender: <xms:NIacaW-0c_GL8CxtGfoiTvMtllLSmxRvaBl_uhNP7cKRzYaVaM8q2A>
    <xme:NIacaa9Z2yyIPRd8b5rQk3mKa673utXlRCxEg_QuEt44CkhcF8fRohy5wu56GaumI
    RxBCTfpE6O0uniO40fX10eqQAaYlUrTmjnY94s2jtdBY1Fw6mTNfg>
X-ME-Received: <xmr:NIacaY8hNKUE-pozWwlhzpGzMy9J_Mzwn-YRtmkhKwWiA184p1Rl-6Vf_Ogsvt83-bPVIQ-5BrK4ooeu1kDFGQIcHwfqsJkr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeejjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    etvdevfeffgfffhfeuvdehveffudeivdehgfehhedvvdefhfefkeehjedukeeuhfenucff
    ohhmrghinhepkhgvrhhnvghlrdhorhhgpdgvfhhfihgtihhoshdrtghomhenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghs
    mhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeejkeehhe
    ehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpdhnsggp
    rhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhgrthhhih
    gvuhdruggvshhnohihvghrshesvghffhhitghiohhsrdgtohhmpdhrtghpthhtohepsgho
    qhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepjhhovghlsehjohgvlh
    hfvghrnhgrnhguvghsrdhorhhgpdhrtghpthhtohepphgruhhlmhgtkheskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepnhhpihhgghhinhesghhmrghilhdrtghomhdprhgtphht
    thhopehmphgvsegvlhhlvghrmhgrnhdrihgurdgruhdprhgtphhtthhopehgrhgvghhkhh
    eslhhinhhugihfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegsihhgvggrshih
    sehlihhnuhhtrhhonhhigidruggv
X-ME-Proxy: <xmx:NIacadJEvAILUhzzKaws0NcoCWso-5Uwot8IHehp5Ikkj4MSide9sQ>
    <xmx:NIacaVREdOgjBP5kDk-jxqHqdrwceEoLMijswym8B09p55OUCxg4lA>
    <xmx:NIacae-rqQHO55EVn2jo-qXbrk0AsKq_ROVRRQ6uS2xSkb8bjW0CqQ>
    <xmx:NIacaddT7jvmL1F32UIWqjcnsgi8KuT5KzHq1UiAfOzH4qQztKuGaw>
    <xmx:NIacaYnTgLbvGZhudsjL7qN9ONhXPFqntFdQH9MKK09qiWxJcmfXG91S>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Feb 2026 11:54:11 -0500 (EST)
Date: Mon, 23 Feb 2026 08:54:10 -0800
From: Boqun Feng <boqun@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,	linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,	Vlastimil Babka <vbabka@suse.cz>,
 maged.michael@gmail.com,	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,	rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
Subject: Re: [RFC PATCH v4 4/4] hazptr: Migrate per-CPU slots to backup slot
 on context switch
Message-ID: <aZyGMp7JbXPfp8Kd@tardis.local>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-5-mathieu.desnoyers@efficios.com>
 <aUR9RfVChdcDncwX@tardis-2.local>
 <bd86f598-97f9-4fc7-b426-01f08974b945@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd86f598-97f9-4fc7-b426-01f08974b945@efficios.com>
X-Rspamd-Server: rspam09
X-Stat-Signature: amgak7p47e6tc5zjeag8sx54x977x1ng
X-Rspamd-Queue-Id: 6D67C140005
X-Rspam-User: 
X-HE-Tag: 1771865655-274986
X-HE-Meta: U2FsdGVkX19q9u8qexDLwvi+m72BVwSlIg50SLG7oqTS/eMKxI2IPHAlsS5z4o7dhjLhphN9bhJB54CLvzLNwGN5G8CaMjD01SNYJxmlmDbmutQiqfzafhkmgUCETbSghDkIhaWVqQBqSPnzFyAV/FrIUvsxs3aIMuL6tKYQIJhDwi5TZURpegxx7+V1ebemOgPV0sKTDd514USTq/3BNMlEqe8k/4gHQH2QI0BOOi5qqX+xHB3c+57VQ1c8Kd2Tu/t3RN5nnanhXLpAhaiQUFtZFXzew+/IcjUgALbpB0CNqwyJJAa+jMjUxgs0oyOztropjyj4zLfaXVRdxAEgsb7ggs8RQMWOFjXaZWZ2GEkfK3jUjiRrfWGXBHXCEsy1U7PfLhsTMP7iBiKtOge/J57LSoIBPjZroLb/AIvL1xGU5sbDeHuQlBZDVEMisOoEIIjmcGrYPNtzAemgMQdHWWEbUB8J4kxadhKJ2mSohZBKZmhgi79l3LLWa9ytxa4vA+IBSL4ll3Z0rY/NpX5otbWhsSauNGQstaUKRVFYvu/auRg0/6m9Ae7AOC2ttyLgQDi2cvDjKlFpMy695pOZiMxXz73cTNkPhBYk0Zwwum/PJb6BUg2IpB4kuxDq4ZTKsnczadQioe3WBQtynekiUFDmaFyPDRS7vtpyB/pHj4I+kM90POzXWsC8D1PD56kCVlGPxCsCsVt9E09PNFyVN5ZVwqambUBioDPrY0gmElfvjGth/BwZ/DMZASbI7fl5FMYa+SMJRwqEbW82DFFN2MCDYRU5Ucc2Pspr7wLFxyfMIvu4nxShdufdb703vN3gERsL9jKDKF9JIAyzEv+Aa2OPv65XpvqyvApyVZKq/GnKJV4tctRvNdSsEy55IUss1SH+Prtj3kTJcgG3ENDHhKppwUWkcA49Qp1M3mnXn21VjEGTZr2Peqy6s72T+M6Iu/52NTYV+BpnWfOVCo2
 yisDZ7cT
 TGUZMx9xV6vS3QS0uNtqS/GihCQmghS31M7/6B9fs1AmVg+1uT5O34X99XT7JUIOCnXL46eQp7yKzDOVpUfRMiTruyd4LLs/6ayIVbrb8ZaX1HCaEUXHl6EoDqmLm87SVIOCnG77HsJEQdoq5KYuIx3KCyW+MH5CUaBRJDTBtOMHV0TnWu70mNPMPksX2k5X+g8plLBF5Qi5/8YC8xBLOfXzuG4XhUQWGcEAzZ72v9zb9OUfGiq2OXg1enK5jCJ4t68QlyegwZ0sDdM36EJ6UnTBYelpq52Lo3AOFzCkeJNgsw32pgQs+d99+k9yuvjU3Cup8ph1oh9lm7mPtWf+OA1E8lbFpC/48GLF4XcHMrqFPCfO3FN2BlMvZ+Ach97WqT6n4ldwKJ+b/cg2TfkTNekEFdlrvHHGo7NSH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,

On Thu, Dec 18, 2025 at 07:21:28PM -0500, Mathieu Desnoyers wrote:
> On 2025-12-18 17:16, Boqun Feng wrote:
> [...]
> > 
> > I would suggest we make CONFIG_PREEMPT_HAZPTR always enabled hence no
> > need for a config, do we have the measurement of the additional cost?
> 
> Removing the PREEMPT_HAZPTR brings read-side performance
> from 13.1 down to 5.1 ns. So there is a surprising amount
> of work that goes into list_add/list_del.
> 
> I just noticed that I was running a kernel with CONFIG_LIST_HARDENED=y.
> Reruning refscale for PREEMPT_HAZPTR=y with list hardening disabled
> goes from 13.1 ns to 12.4ns, so not a huge win.
> 
> I did not notice much difference in terms of scheduler
> performance with a quick hackbench run, but I cannot
> claim it is an extensive benchmark in any way.
> 
> > 
> > I think you need to add interrupt disabling for chain/unchain because of
> > the potential readers in interrupt and then you can avoid the preempt
> > disabling in hazptr_release() I think. Let's aim for supporting readers
> > in interrupt handler, because at least lockdep needs that.
> 
> OK, I'll look into it!
> 

Gentle ping on this. I want to make some forward progress on this ;-)

I suggest we make PREEMPT_HAZPTR enabled by default and support readers
in interrupt handler. The rest missing part is an async thread, we could
utilize some code in my previous patchset [1]. Let me know whether you
think you have the cycle for this, otherwise I could add this into your
series ;-) Thanks!

[1]: https://lore.kernel.org/lkml/20250414060055.341516-1-boqun.feng@gmail.com/

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

