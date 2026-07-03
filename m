Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15971C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E7C6B00B6; Fri,  3 Jul 2026 09:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02DF46B00C1; Fri,  3 Jul 2026 09:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B3C6B00E5; Fri,  3 Jul 2026 09:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4946B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:39:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F2D914013A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:09 +0000 (UTC)
X-FDA: 84947571618.06.2D5613E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AD17EA0004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ho+IIuyK;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085947;
	b=A7SRybtIEU67XkgGHVnDJqVNl3qBhmAPBojhJ56ga7ciKIb5gcfstelKuw0+4Fxr2eJSRd
	S4qE7X194SQ8kjGM8HCcpZrcBWKe/lwnQGlMnvpgsxykRmgRlNobjLW2XJQaSv2wl0j0Nf
	9zgOP/ZDRv6A73k77PuYsUjEO6zcfu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdkHQ8OiwFstJ9BIoCs53RYJrmMvVk+gNJy1X7Ike7k=;
	b=ev+GP234+tbiTZZdnasyR3+rLYWDirrPyNYVc281N3st0R6S7qdiaDZrUugVIloWNzbXWe
	RiAsgplKcmKwsmQWLQplgYoIwcBIMg+1eBrsCtpywW93UDrl3ogeGMa4gp/pahCqVS2gO8
	lXkbKPpDoaSouTw30H4MhgvS19Eth5E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ho+IIuyK;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B61060121;
	Fri,  3 Jul 2026 13:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D010C1F00A3A;
	Fri,  3 Jul 2026 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783085946;
	bh=jdkHQ8OiwFstJ9BIoCs53RYJrmMvVk+gNJy1X7Ike7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ho+IIuyKp++PHAd93qe2Qh5adf3DEktrUTRnMNB1chctnEdXqn558DpvM+sk4AJy1
	 mA8sxwiU2YMsoEEkzeuUsZyc4e0f0qn0tiKfk/4C1ZY0rwioNrLx7kBKg/VVYy++FY
	 OHLyXTgyNPCqT4dRlKKFFi8MCosU1HawJ3m53WOYx5l+whGo/KLbhibYXTogL7aAuK
	 7EzGGoqGmCz9pYTvP47Z9PInEHNIqry/43q/5S8SZRE7WD9WwiM6mhAZdd1RwRBRSJ
	 ecaba0edW3Zk+iO2uVPkLe8y5sQQinVinWu//hSYfccADVOzyBLxv1zHSduOX2wy0/
	 nMT0AvNlver0A==
Date: Fri, 3 Jul 2026 14:38:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linuxfoundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>, 
	vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-ID: <ake7PLwdHUHu4idi@lucifer>
References: <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org>
 <ajOvwGs5xhnfBu-k@kernel.org>
 <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
 <ajO4sLq2UBciSgOn@kernel.org>
 <dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
 <ajO7yI541hphWRb8@kernel.org>
 <11bae87d-73e6-4946-a41f-c5542fb40b75@kernel.org>
 <akeJdxdZXAFb8XCr@lucifer>
 <ake3JZJPYHP-0N7n@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ake3JZJPYHP-0N7n@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD17EA0004
X-Stat-Signature: 13ce679137centspox7wa5yji8ji6gxh
X-HE-Tag: 1783085947-737589
X-HE-Meta: U2FsdGVkX1+TrUlDUST4o8nLf9g9/se5HceCIx0j/LWyctPmzJ8oKAZ1u4BZq0KrYF2Z1K8PDymkCs+sKdMyECRO4T1A3RDd9S9w1hpwimjiAGqaUrtyhsUcDW/z6Ztij71yw2GRZxAgn35MvGhRBI2W4iHUpD/y0GoogCwQcz853Ny15pkDgIzpANFIhdc6O1NuyMnWKOwXy3gaIRdop5oyameIpN+zDdEltOCFsbC8fcGOHrwBN+Lg19/yRI85or6RTbpv48jwJKkoXzwhF6nlRZbxr62KQO0s4Obe+iQS4IoKuzhgKEPO+8txbiUsvuK2OPjee/ZFA7Ar69QDrP3TD6Y0yXkMfBVqQmsbzCJmRI7KSkGHTw7vTCos4R3YAmTE5YXvJfP1SdL38azPj4nJwRKJILV8eOyol/KqLUvxjXnyqpy4HM4GHHHah5IZ4i98PQWSC9n/rVgJMrJur71hFSJHY4xEoeybf+c/uj7n+umzHxAxkYH+6RK6a7Z9gyOEwzwFVRernpapOnX0bfUvQ4JWEe83/40OvyUi+AvIktU91F/kq7SWAsEWYJypTD7Hi4OIEfmvdOV68YWqR3A5yHQxVyMAiPxVDOxAJvCoDwAYHnqFBaNwxEFTeI6pP2NV1919VeaQgV19mGgp4d5azWx1LoRUQX6X6PCJ+UTk/2PIbD1ABAjDX1xWcYTPzoBRsYpZ0HFz/tXfe4b0q4QpgYTFaKM1NFW1r3zCzdlpnZ7SQ/93rtPEr9oPPWNwM7PS0Hg9OhRf3PGFzaPCni01nX+KCHlc7ZDZZOPlcoVmZxbHX5zRkutWHPN9ZvOa1ABy/r1hK0fUeFnZztJ+c2bsgWdHL1ZeHsMBms0DufpL7tWXP1awoFNWrPA/xFd8aMWmyO+YDoKH+xG4K3GDQW5GLcz2041Mu3n3QpcHTpdX8UI48mZ51/w3aOtFiAarqipOxx6UGfD2tosC9h+
 sQ+0p2P8
 8Rz+kdpsWiZG8r8n6bLicy0MFollqXIGtqaDyrJGNTrpeoHYique4hu4ozbx2uGCm7aTM2gAOGTtsMUrdYwkePuudZM315TPGOQ995HPLRwLIpdmM/p3HQth/8PGeWf+S20XREbMRskSBBr6lEnQYUaVbTuJTzZmuQgVMnW7JcRrQO+j7dkHTiZ6ImUJJsVAE/B/PUG1iR5Ov5B/7eXX4n6BT/28E050t+sgL5U8PHNgSm9IpdeCtip6V/FX0vfYewLwd/8mTYbUtL1qygoUgLpIn6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 04:20:37PM +0300, Mike Rapoport wrote:
> On Fri, Jul 03, 2026 at 11:11:14AM +0100, Lorenzo Stoakes wrote:
> > On Thu, Jun 18, 2026 at 11:37:10AM +0200, David Hildenbrand (Arm) wrote:
> > > > In a way that's an extra check for hugetlb, but it will work.
> > >
> > > My point would be that we exclude all special VMAs, except hugetlb (which is
> > > special but supported ... in its special way).
> >
> > Mike - you said you were respinning, it'd help my series if you respan the above
> > quickly so I could base my change on that :).
>
> I sent it already:
>
> https://lore.kernel.org/all/20260618095017.2553004-1-rppt@kernel.org
>
> and Andrew apparently ook it:
>
> https://lore.kernel.org/all/20260618183442.BBCD71F000E9@smtp.kernel.org

It's not anywhere :)

Andrew - did you take that thread as signal this should not go in?

It should definitely go in. I will clean up the mess discussed there separately.


>
> > I can send a quick patch if you're tied up also!
> >
> > Thanks, Lorenzo
>
> --
> Sincerely yours,
> Mike.

Thanks, Lorenzo

