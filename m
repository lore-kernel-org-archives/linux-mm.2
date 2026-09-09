Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91431C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 20:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8506B0095; Wed,  9 Sep 2026 16:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A895A6B0096; Wed,  9 Sep 2026 16:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E5A6B0098; Wed,  9 Sep 2026 16:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77ED76B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:13:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D90934030B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:13:02 +0000 (UTC)
X-FDA: 85195322604.07.D12F89D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 35A5F40004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:13:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ysd/kTgA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788984781;
	b=HKz57QrbgzQAfX86zu8jaVpDvVL9vLGl51Iz6V1kuhIcKyUrtYeXastt4L/wX807PyfHui
	TPC8aNnQ9w+dkCRVPThi16ZeQBWPBNoGhm5c+qThxG9eKpVZGVnBhhJYttBJMQ7JXaWLGu
	/FHxM7o9+qsRk6nOiwpIIpeYPhcIFRY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ysd/kTgA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788984781;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkCROJGmCSID5J3EY7M78lHWx0S0ZOsvo3WsTjTa2PE=;
	b=gf7I4KpKA0VCx4Iwi4ycnD6LDsWXad4gCqggkvZH6HoVSOlONqKZmjTibmSHqdJhiaBwMg
	hsAhLwW235Re7f6S0n0bVFuA3NDjWQMYkRZHpivF2ueEoOKT/+u0OcjeXDpxHa2bKas/wl
	pqXg9xef+fYxhZRyQvyjksD5BiuFT+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAC45600CB;
	Wed,  9 Sep 2026 20:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE741F000FF;
	Wed,  9 Sep 2026 20:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788984779;
	bh=nkCROJGmCSID5J3EY7M78lHWx0S0ZOsvo3WsTjTa2PE=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=Ysd/kTgAgLyUrOsMKu6uj6c92r8HOe4mmu5KgvdKGgbuUHS8sjrYbrGofEYKTiPVx
	 xUtHICG9VeB11il5KfTzApgWiMDhYNTCQR/p1tfAzXsQxwKn38pDWcLCmFXphnHCst
	 atPLvH/Y2hQFwhHzDJCBHNUWO8obouQ5v/bSiJC4rLphPzLQTeUr93cUaxZDT2YSRR
	 4OudDUbPP3S+Jk9WF7Ei0lU2inuVYtYS7KplVE93iQ9McLs3/4uFBRopyan2SdTUSj
	 YlKGcGFieO1QmAn/ktA4ObWl7Q5vLMS995+JKQnPl7G9Uj34wBP/7afR5QjSC847we
	 EAubBzM3qBKCg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 04BCFCE086B; Wed,  9 Sep 2026 13:12:59 -0700 (PDT)
Date: Wed, 9 Sep 2026 13:12:58 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
Message-ID: <d49bd6cd-0670-47ba-b8ef-e3e8c0d49830@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
 <aqGilhgcEd0qaHjI@slm.duckdns.org>
 <16d13239-8911-4597-bfd6-18aa02135137@paulmck-laptop>
 <aqGv7R4LTmlrW6QI@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqGv7R4LTmlrW6QI@slm.duckdns.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35A5F40004
X-Stat-Signature: bbsmgb11i65cmrmxp5bayiq4o4efaoab
X-HE-Tag: 1788984781-579422
X-HE-Meta: U2FsdGVkX1+dUKIDMZ7MZmV+Dxn61RqN5lK4AsdHLBRcjMQPbXMQx1IJBLKbkdtmmRavB71DXgP+UxMtjl2bwavODQezREujRfNYf+C/HvvH+jNgUswbC+LZN+sc6ygfeYSVoXEgScJZpj62hQIxUZH2/HSWtGtgsE42KwI3a75dnhnAohppB1YKCMpFP9wjY+SYxwqC6fboNaIoV4x0mI/WHRaE3FfUz18K096Zlwjgvw8vFyv/HdwgOtsHxlbHSZSy1Z0T3fm2IGqBXyYijYzkAP9jhogEudW9kEORhCkvwmtsDKH7AD50cv6ChzIjTeaznXGi/tLgLSr+DczJ/D86Dc6vh/aK6b4Jku9tMq70+0/9H//05sUxZhnHiYrAZpEqobaSgTEidox32oIWFgfjrABSGow8V7dmUZC6BI/G2yFywvQAY4tMfgrjWo7Keq+tI+7sceB1cr9UviRqsQMDztw+WGcyArIxWEWpqK8A9n2ObpWDdKxh8xdtoM8KEUQFGmQEpBIFH4w2UyainAE/oYrezc+B5hhWl7IUzkb66WLuMvjSOJ5Luj+J6IqE41sJkMnfx4YhsoXtIkfkA0SGXkzWJPb3CLxzXKtLFyc7LbozllQHoYEZ16YTcIGuB6o/2Z/XGlSF3vH77+mEOK5n2WIPHOkDs4t4QBd/a+qg+e0UCm3+W22I464+y5KwEt/xZY4l0Vk0EUNiElx+XJJ9PhDpCrI1HAZUEGaUmzwKC1Y7VDXWjhjNsTB37uaXim69jijPY39PlXvqF2YKib58WkjE8KDzdtu5etpiGfLq7xPLziDa2vhCtIQRPlG6A/nfJRQbKv+F/izlJ+/G9FMCOvaVjW3VWO67nI/TWmAmN2oY53BAHHXpEz95jZfGQMSlz0jmArLOG/QKfSzgXvQtoMDCJARAL2/pLMSbhp3+EoQEMBCWiNsbIIS2RdBg0Q7jvoRcK9Xpfn1yIc6
 BWrWF0RY
 1eJ3L16txzMTsRRR2pZjvcsjAYNoZbYLKRZAazVhVMrJ4z3QDMHPutHlVoyheqLxSRHK7GVKaAiG0a0e5cWaPVuhOe9DUeUr+m8SmtQ4YKX3ydHGVuJQGl0egJYwkaV3dvpFaIxgAuxuKVMEFf9DiK9H/Veq5hmKtT07PoH9/JE/dTQk2mjtKecvVgsQvr2RFhwitT7I2FARuMOgxK6fAMa4EpzgNtSdeDmNKiLc555XW3fU3O2AeVrx4oebCxm4WxCLUqY6dW0wpxkEJ8uPf/FuqcdPQCHant4MmXCP7tgslO0cBdeB+wN12zseXrksJjQimLE40WBbk+l1kIEF6xBqyck160vfOiwwLDidukU0h08a9l+W6DhDDnjK1xly5R6GHLs7V5Z/lWXmSW7T4igyYlmkfoYK2zZ6wrto0oaHYRJPEtgwoNLka/mEUBSflTPfsN+Mwmeg9MndyCIXmVbvUVZYchA988+fhgOosmhgMyrnb8cnBwtxApx0CidRtZ513OP/C/l+yMuQxIudLSBMijtY5YZITY/JjQguQKKX3lCachxety86FAwDxBaTC3pt16LL55EoiBVpdyztk56K8EoSEg3eorv0PAEPNsPWIQoS5RwZK5T2aM6LtPxpGDah/qP4puqH3Q/K0s/GDnqOnGgkaDnJ827q+OqP0BIAj/d+xv4mYQf/o1by7wGDm5yxTcxGSIi6P2sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 09:13:49AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 09, 2026 at 12:03:20PM -0700, Paul E. McKenney wrote:
> > > The patch looks fine but this overall seems fragile. cond_resched() was
> > > already marking "stuff that can take too long" but we need to use
> > > cond_resched_tasks_rcu_qs() if it can take *really* long. There gotta be a
> > > way to make this more maintainable. If always doing tasks_rcu_qs from
> > > cond_resched() is too expensive, can it be be gated behind something cheaper
> > > e.g. some tick based test?
> > 
> > This is the business end of cond_resched_tasks_rcu_qs() in preemptible
> > kernels (in which cond_resched() is nothingness):
> > 
> > # define rcu_tasks_classic_qs(t, preempt)				\
> > 	do {								\
> > 		if (!(preempt) && READ_ONCE((t)->rcu_tasks_holdout))	\
> > 			WRITE_ONCE((t)->rcu_tasks_holdout, false);	\
> > 	} while (0)
> > 
> > This is pretty lightweight.  Adding a jiffies check would likely make
> > it more expensive.
> > 
> > Or am I missing your point?
> 
> I found the following thread for why there is a separate variant for
> cond_resched_tasks_rcu_qs():
> 
>   https://lkml.kernel.org/r/20180224151240.0d63a059@vmware.local.home

Well, that was nine years ago.  ;-)

> The rationale was that it'd make cond_resched() expensive, so I assumed it
> was relatively heavy. If it already comes down to a single test, I'm not
> sure having a separate interface makes a lot of sense. There isn't some
> semantical difference between the two, right? Anything which takes long
> enough needs to do the tasks rcu qs, and that is what we mark with
> cond_resched().

And nine years later, I am still good with cond_resched() implying
cond_resched_tasks_rcu_qs().

The people wanting to get rid of cond_resched() might have a different
opinion, though.

							Thanx, Paul

