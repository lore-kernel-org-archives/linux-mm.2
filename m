Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E793CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 00:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6937A6B000D; Wed, 27 Aug 2025 20:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643196B000E; Wed, 27 Aug 2025 20:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531B26B0010; Wed, 27 Aug 2025 20:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8456B000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:29:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B020C1A08DD
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:29:07 +0000 (UTC)
X-FDA: 83824281534.13.9F9B77A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23313180007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:29:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=offt3uIB;
	spf=pass (imf06.hostedemail.com: domain of jpoimboe@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jpoimboe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756340946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIGYa1IoLvzoz6LBFkkAzKJUvMXHJZXOKeuSf2AY+z0=;
	b=EcbktwwGikiKMoXe5ktJaTWVa0NyulAZhBxuWY2J2aFqfweUaeVhOibTGcKHh7EpyhwJZ7
	YI8BMVOkxg6iqp6h8GHPz7dDP6h83cCGT9jh+mYk4dM2U1FBf0/AloIZH4Hi0q68P7jTLU
	ad0tY1JNcv8UHH+Zm8Gw3Qi4+Tqol+w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=offt3uIB;
	spf=pass (imf06.hostedemail.com: domain of jpoimboe@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jpoimboe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756340946; a=rsa-sha256;
	cv=none;
	b=ltx8F9d/0xOnoioQmh1QPhUhhoAWYc91ycUAhvYz2mAIO91Xi5OlmEgAvVmOF5g2nDPjNb
	AgrvMOKdHJQAH9+bPf4DTtgjz+C3iU+ETY8RZ+fagvSQQxYKiOYeUqQ7eik1UAPeMWm9iZ
	rKigpKrCQ7nohIs9sRtnzlMziOoR4bg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DE3160204;
	Thu, 28 Aug 2025 00:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B13C4CEEB;
	Thu, 28 Aug 2025 00:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756340945;
	bh=dxd8QSAVzwmbR+1mbcfn8utb4yYnDh1tvifJBiMUI5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=offt3uIBmutis+Mh5PpSxuw/lPMS2QQhM7fru9wFzq/WpNzVEokV7W1k4VMc87LRh
	 C8KMGbJQfErrMNWwOxLqLigoRY1cEUbKn/SHNz+c91OH/qPVv/6hR8AWyk1HrL6qY/
	 xuN6bAtyBJexMiKq7Q/ZZo3Ma8QFR2Gwva9GSb9NddFX2GRzVfaglLDcgQbP0VnGS7
	 Cz2q52gPykgswUZQQOOZ/JwO+W8cIvglf/Y68QFOK8KqeNot3rviPnsyYb7iaDbyTT
	 kDqTlZpu5rDnPEpLSokJ5mLImBcmyQbXerfATuLiIjoxR5sK6dcb/TcADcTO6a5yzI
	 shtJiodRalGvA==
Date: Wed, 27 Aug 2025 17:29:02 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, peterz@infradead.org
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
Message-ID: <ourgzm4wai237cpcef3ypdn67hspjgw4u7fee4hyouj2hn3gwx@c322noqn4kzq>
References: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
 <2d1297ef-5df3-4679-8e38-05be188f18d8@lucifer.local>
 <aKh2vr9HtFRKcnR6@harry>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKh2vr9HtFRKcnR6@harry>
X-Stat-Signature: hhxxjzcp3wedb9wi87ury8c3ntxci5j4
X-Rspam-User: 
X-Rspamd-Queue-Id: 23313180007
X-Rspamd-Server: rspam05
X-HE-Tag: 1756340945-853141
X-HE-Meta: U2FsdGVkX1/h8behpj+4NqQZcUToI2d+92XHIpud9bkkNvYqkU9orYaVe6wdA5vx2Zu6ga+rxr2hoC4NqbWm9AguPZbzxLrbqpEao1cFNbLsLkCpI45hd+Ap/aqt8tx7VLKLoJxyYrXJiluk+8dNu+3srGIeAIOLIbXMHYjZKuFSGVEID4B4Qg+JObHH70c3NBj1lHFI/tzyF1IWYimlbadREBz0OcQwJ/kC/PU9KKs1gDmwnwCxftp9hKDdjSAVW+r0tTzWY0LIStyTzh35rHaYX30PV4aI04Q50VqoWkxCyDKvWC5zccNgs9DtIvR2iPtg/HxcRKankjeMPbDiXvGTEUNkMwBH9nr6oBys94fQxJdspBlApcsFPj0u6kXkIbtl5GTxOhYcF1pShxOEyMoRdVr91+339fj0Tp9j25j80NMI6/w1SAZfFIplEQ8eC2JfyjednVAtDQekoIxAc4pxlMj4nMRt5VQ4E0EHHH3e1HM/lPemmcu22LQKWT7LGM2E8yZmhI2CU7XSIXb0/LaRLURFO3Kw6YkuNxdxtLnJrjW41IqrM/Qxlro76ZAG4K4IhRQ+KnC7YFAR1v4iRQF08seNm1Bj77RIZGCxk+Z5A/7+X4aD3JHmPOsPM3tjRoH6V97p2VBfYDfnlTUnJRDRdn+fYzzBBZYv3yxvOj95G6piT9jJcQb9i/RqMaDHOZTVOLwF85R2W6+Wx+G5bJIZNYm8Mb2akvMvjo7H0wM7soRl5m/LkV+RAEIQBOhXdkH3z7T+4U1ReWfVTsbB4fRNetEixovGNQ6KTcz7bDCVj3UJvgnccZgBVniAEnLmX/l0By8zNmfAfv7HXrdju338iVrfH7tUwXyHVgiZD72oTXgiv6gbGeq5WKJJSBGrhGKK+KY2wePBUwx+ftM5YOg0gywW9K1dkNcqRQJ9cQ6efzX31dRQ/H6tSg3R/+e+A1f4qyWrt5IW+VvGCug
 +WzEU52S
 EtyhS25H8+kGptUZhrI6yndK++uWl0PbeICpY/6uNCYMKgTuNuwbqzJdrw66amE3pYuoa77t4u2AxAqYRWmm3ZtP1PaBBywd08d3MtRlYg7wWJ901DhH6Nv7825UwVM8zefB0D6Q3LTWSo8iWZ+y8CsZBm3laJOKhrINlx6GdiEVGA6iEfCD9hERbxEVr1sGzzz2PjQ6bsvSPjtZWBTaVFREQhzBha1gpbcYEz5jAg5PkwFMCrKv/4SKnvxQWF6aYCfTdRilUgCtw1ZagFSYLCgeYX7IQmZHyMHVKGL/dVKfqhyy3+TueYDQwZ4r04UjQkyaa56UCFdrU0Qf3AWnOPDakc8Wya81b1kOVjSH5eaKo0cfYqeFk89DbUqL3uHc/CkYR5CV9PCdx7xJNfKLOYUOfWv/+PEP2o0wDk4rmIoCwAcv843vNESYz6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 10:55:10PM +0900, Harry Yoo wrote:
> On Fri, Aug 22, 2025 at 01:08:02PM +0100, Lorenzo Stoakes wrote:
> > +cc Sebastian for RCU ORC change...
> > 
> > +cc Harry for slab side.
> 
> +cc Josh and Peter for stack unwinding stuff.
> 
> > Pinging Jann for the CONFIG_SLUB_RCU_DEBUG element.
> > 
> > Jann - could this possibly be related to CONFIG_SLUB_RCU_DEBUG? As it seems to
> > the stack is within KASAN, but no KASAN report so maybe it's KASAN itself that's
> > having an issue?
> > 
> > Though I'm thinking maybe it's the orc unwinder itself that could be problematic
> > here (yet invoked by CONFIG_SLUB_RCU_DEBUG though)... and yeah kinda suspcious
> > because:
> > 
> > - We have two threads freeing VMAs using SLAB_TYPESAFE_BY_RCU
> > - CONFIG_SLUB_RCU_DEBUG means that we use KASAN to save an aux stack, which
> >   makes us do an unwind via ORC, which then takes an RCU read lock on
> >   unwind_next_frame(), and both are doing this unwinding at the time of report.
> > - ???
> > - Somehow things get locked up?
> > 
> > I'm not an RCU expert (clearly :) so I'm not sure exactly how this could result
> > in a stall, but it's suspicious.
> 
> Can this be because of misleading ORC data or logical error in ORC unwinder
> that makes it fall into an infinite loop (unwind_done() never returning
> true in arch_stack_walk())?
> 
> ...because the reported line number reported doesn't really make sense
> as a cause of stalls.

There shouldn't be any way for ORC to hit an infinite loop.  Worst case
it would stop after the caller's buffer fills up.  ORC has always been
solid, and the RCU usage looks fine to me.  I tend to doubt ORC is at
fault here.

Maybe some interaction higher up the stack is causing things to run in a
tight loop.

All those debugging options (e.g., DEBUG_VM_MAPLE_TREE, LOCKDEP, KASAN,
SLUB_RCU_DEBUG...) could be a factor in slowing things down to a crawl.

-- 
Josh

