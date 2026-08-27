Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 029AFC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2498B6B0096; Thu, 27 Aug 2026 04:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2206E6B0098; Thu, 27 Aug 2026 04:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15CF86B0099; Thu, 27 Aug 2026 04:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA9386B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:50:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 703B7C0349
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:50:08 +0000 (UTC)
X-FDA: 85146427296.20.E4A6DF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9BCE12000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:50:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKtNWnjM;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787820606;
	b=mPla0JF9kEEKdQ6GkjMD5T6e5Z5Z0JF3vxGDUqWDXyu+BCtUWcK+fT9TR5otqjoTVezyWu
	pZ6l7T9dV/ckuaDlR9lrItuKhS/GFv6ZpMPx7LhSmPJRom0A1HEv+V7SKmZmqbzwW6TWKq
	zj/GAJWnvHdJWr0GIMAjMB8DyT/Ke+g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKtNWnjM;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787820606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrNcTOCCiYKmHCu5vszKJ67Q05+7G2pCd9Pxl+8sES0=;
	b=7L9YUOS37tQB8cOx7FOT8TFA4y3JwIVJzV/gyv0ro/eIEd9e+IYemlFTafhxJ7d1TFoUWA
	XHMPraQrKeB9WWPK1MT9CgIiQ3HKZlTBBNj1NUWM26Bn4ofJBpmdy7YwMfu1e4/Y9ew4Hi
	OFGu2i3ED3TjRAamNcLq0WU6yOTUS4c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C738600D3;
	Thu, 27 Aug 2026 08:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1BC1F000E9;
	Thu, 27 Aug 2026 08:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787820605;
	bh=DrNcTOCCiYKmHCu5vszKJ67Q05+7G2pCd9Pxl+8sES0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKtNWnjMvxuD16zamcUiwK9Dputudhp60QlGNIqqUuGxBttnhtNa8lyNFpx7LKCye
	 dl/MegZdvvdlLOlw/le8AGDDL+3jpdkUxZwRQgG8CPIEU7QhgsMC2AkllN0a2N7LLd
	 +P5mB7s7QnNNQlrr8OxHdY+3a8bEDE1GyM2jt3cXQPRvnzKGzmcrX1myTAKE4MeKAj
	 Rt3/IHGwFKrx/64SRJC4Wb3V697Jha2DH34QvM0KSzEsgYnjbIqQQfv6yfUyKeKRK3
	 Sce7GPLRCcgHy90U4BUT6XvWVw/fb35SRHhLPr1zBXtywvQOqSvFEwgLAev7nCd+2Y
	 FNzoKVdlMTBSQ==
Date: Thu, 27 Aug 2026 09:49:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: david@kernel.org, linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v2 0/2] support kselftest on nommu platform
Message-ID: <ao_541nBaa3SJS9F@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
 <f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
 <ao2Tl9CLL7WjHYun@gremlin>
 <bb9a3add-4849-4928-8b6a-0afc0c73b112@kernel.org>
 <ao2l9Ao7BQI6uRKC@gremlin>
 <m2y0dsuf1d.wl-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2y0dsuf1d.wl-thehajime@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 3bsr97dwxaoy3nnqjncaxkhezjhnw4kw
X-Rspamd-Queue-Id: D9BCE12000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1787820606-602187
X-HE-Meta: U2FsdGVkX1+/zW729LbGeUQhvShFZwj920PLTroU6y2Bh67OuVdN+Wzo8RYPvD299a1IqeCH3tXIUg2R4c9hZTSFbSTbhbSucEqcwieiz2isS05jOEBJVmPsRjXoribwZ/7g9RyB58dQLZ+xPUxoWer90o5bbexqQEd+MOnf96UlDhicPuIJ/cOfoTPIRh6qzursUEIek2DsaHpTtcQcnoi/sBN5AIWS1V2Sk+xzDUW65fTSBer/wQTelk01eNpJfu3Pqk9C5tcvEZT5P0K1P+4qToZ7hIfBl7o5T2ugZ6upreQct6Asgn6WW6qdYZM3zhT9p6rhPWjjqqKK6WDkDZpfRoZK4o2ZUOTDJo4/DsAPi2B/NPybUXFNjkWV3QsqSHmbKSpdOxGZFxDgq+MMlRe4MwnTBsbmSVOdMj8fleOkq4iztpDU2ZFas408I6pJ+lKWSGR+sBOl4xCZti2kp6lDuXA01j2vAn2ycIIwa4XhC1dDdnFCSVWJeUsN8p2sRTUy8A13tMi2MJEEPHdDrp+DR4ZZI4VHe6gk+PKinJqFblWBGGvIIF7usCBGLjLchDOcf24WTmNtCAzRA9vEPrShNxDPygF2KGeZjdc/Rqyxu9+pbs4+aJPX+v2NBnkx7qvOYHPGS9o1MsYsrAPqH240xpYd+jdFRIRoxF+GvP3arHCmEsASR8M/tPRYx8bNx7kVXzNC+Ea0SFIWxTTvslMbtFR6RaaxidEBShM1dd/9DVX8Q24q9TgMQKFNvmhSV8QuEdRZi0oxgHiwtMmwtqAzd7AZGe6wztAKoTypahksJyJMZpzVEfyFqlnB6ME1ilzSV6nCoxOcxc2iZq6hjoPkagMZfOcIGi84T0uEe2gGUVjt/eYam9W5+HvXDHrBCKxf9V5G/HlB0NffuFPSQ9IGAh7HjPl7Lxh0iDDT9+aE35BtS0QE9bOQ8/zzwDdPBeA/HCExYII9LpJd3Xu
 0bPKJyIc
 P9Ik6QPCaPPBfNm4Qc5ScV0kANtNFtgoY7q++yEQN9txdEHY9D2ou9IF6ONGlC3AOkmBBMNAa4tcjpBx6GEvfKemyjNc1qPLmVvNc3E8qi+fl34N+448EuqwHELxuQJpSFNjEUSVS5uuRK/+0Uy0NeTCbhqoMQrysHJu56aXK5auVgHHs0WSYT6f26AoGO4uYiG5fwKfpbvE8Pxu/Slnk8XkMEZHs4zzIXqxzYylmT9HwVjn+jgmIj4cyB+lCLz7YfuHUW90T8yowaPPyHiJZH9gVEfSnqe77EjCRe/JSeaBc59Ds9CqftwAl5u5uJZFO9BQmha8cH5hMBbQtBbNki4P1QR4ybalAN57UFlogXehHN9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:46:22PM +0900, Hajime Tazaki wrote:
>
> Hello David, Lorenzo,
>
> On Tue, 25 Aug 2026 23:28:24 +0900,
> Lorenzo Stoakes (ARM) wrote:
> >
> > On Tue, Aug 25, 2026 at 04:17:54PM +0200, David Hildenbrand (Arm) wrote:
> > > On 8/25/26 15:12, Lorenzo Stoakes (ARM) wrote:
> > > > On Tue, Aug 25, 2026 at 10:37:41AM +0200, David Hildenbrand (Arm) wrote:
> > > >> On 8/25/26 03:59, Hajime Tazaki wrote:
> > > >>> We add an ability to execute kselftest on nommu platforms.
> > > >>>
> > > >>> Currently there are several issues if we wish to run kselftests on nommu
> > > >>> targets:
> > > >>>
> > > >>> - it cannot compile/build test binaries because the current files mainly
> > > >>>   assume to build with glibc,
> > > >>> - some of the tests are not able to run on nommu targets as there are no
> > > >>>   fork(2) syscall.
> > > >>>
> > > >>> The first issue can be avoided if we can build static PIE binaries (if
> > > >>> targets support it), but in our case (build on ubuntu/glibc and run on
> > > >>> alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
> > > >>> mechanism.  Thus, we need to cross-compile with musl toolchain, which
> > > >>> needs to be solved the first issue.
> > > >>>
> > > >>> The second issue is the lack of fork(2) syscall on those platforms.
> > > >>> Especially the test harness helper (kselftest_harness.h) uses the
> > > >>> syscall, which cannot be simply with vfork(2).  `timeout` command used
> > > >>> in `runner.sh` never works for nommu platform as it uses fork(2).
> > > >>>
> > > >>> nommu component in the mm subsystem has several known issues and having
> > > >>> test cases should help this situation, thus this patchset is very first
> > > >>> step toward enriching test environment which has not been well tested
> > > >>> for a while.  The test cases is implemented based on the document
> > > >>> (Documentation/admin-guide/mm/nommu-mmap.rst).
> > > >>>
> > > >>> So, for the first step, nommu targets only support low-level API of
> > > >>> kselftests (kselftest.h), and implement tests in a new target,
> > > >>> TARGETS=mm/nommu.  Other targets are currently not even able to build
> > > >>> due to toolchain issues but will be addressed once the initial
> > > >>> introduction which mainly focuses on nommu test will be settled.
> > > >>>
> > > >>> The patch was initially combined with other patches but is decoupled to
> > > >>> only focus on test framework and testcases.
> > > >>>
> > > >>> - rfc:
> > > >>> https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
> > > >>>
> > > >>> Hajime Tazaki (2):
> > > >>>   selftests: run tests on nommu architecture
> > > >>>   selftests/mm: add nommu mmap and mremap behavior tests
> > > >>>
> > > >>>  Documentation/dev-tools/kselftest.rst         |  14 +
> > > >>>  tools/testing/selftests/Makefile              |   1 +
> > > >>>  tools/testing/selftests/kselftest/runner.sh   |   9 +-
> > > >>>  tools/testing/selftests/kselftest_harness.h   |   4 +
> > > >>>  tools/testing/selftests/lib.mk                |   8 +
> > > >>>  tools/testing/selftests/mm/nommu/Makefile     |   7 +
> > > >>>  .../selftests/mm/nommu/nommu_mmap_test.c      | 265 +++++++++++++
> > > >>>  .../selftests/mm/nommu/nommu_mremap_test.c    | 353 ++++++++++++++++++
> > > >>
> > > >> That's odd.
> > > >>
> > > >> 	tools/testing/selftests/mm
> > > >>
> > > >> itself should know which tests can be built and ran on nommu. nommu-only tests
> > > >> can be placed in mm/nommu, but I would expect tools/testing/selftests/mm's
> > > >> Makefile and run script to compile and run only selftests that are supported on
> > > >> the given platform.
> > > >
> > > > I mean I think at this point with mm/nommu/nommu_xxx.c it'd make more sense to
> > > > simply have selftests/nommu/ + update the mm makefile to not build stuff that's
> > > > broken on nommu there.
> > > >
> > > > That way positively nommu-stuff is put in its own place and what's broken on mm
> > > > specific to nommu can be fixed there.
> > > >
> > > > I'd rather isolate them clearly rather than having them live in a subdirectory
> > > > of mm.
> > >
> > > My understanding is that some MM tests could be enabled/changed in the future
> > > that support both MMU and NOMMU. Not sure how to best handle that.
> >
> > Well by default won't everything run? And it becomes a list of what doesn't
> > work with nommu?
> >
> > I really don't want to see any maintainership burden or extra work added
> > for nommu as it's afaic deprecated.
> >
> > >
> > > So wiring up mm/nommu as a separate thing did sound wrong to me. So it should
> > > either be integrated or the tests in fact completely moved out of mm/
> >
> > Not integrated, because then it starts adding work for people. I'd rather
> > have separate nommu tests, any mm tests that aren't compatible with nommu
> > can just be somehow excluded.
> >
> > Having a 'don't run on nommu' or even just some means of setting which
> > tests to skip (I think Mark Brown suggested as much in reply to an earlier
> > version of the series) seems a good idea.
> >
> > But yeah, tools/testing/selftests/nommu seems the best place for the
> > nommu-specific stuff.
> >
> > Can maybe do some ../mm/ horror show thing for reducing duplication as
> > needed...
>
> As David mentioned my goal is to run all selftests/mm tests on nommu,
> but as I explained situation to Lorenzo, it currently doesn't any
> tests of mm/ on nommu platform (plus cannot build).
>
> so I'd like to start as minimum as possible for this patchset, thus
> creating different TARGET at mm/nommu, which I thought it should no
> harm to the parent directory.
>
> But I can move from selftests/mm/nommu to selftests/nommu for now, and
> will propose to move into mm/nommu once it will be more meaningful to
> do so.

OK ack I will look for the respin! Thanks for the work on this!

Hopefully the push back is clear in that it's motivated by technical and
architectural concerns, your contributions are all appreciated and thank
you for doing the actual work rather than just talking about nommu, this is
great :)

>
> # btw, I started to looking at code toward virtual mmu; I cannot tell
>   how it'll be tho now.

Oh nice thanks :)

BTW did
https://lore.kernel.org/all/20260723093633.140989-12-johannes@sipsolutions.net/
go upstream? Or another UML nommu mode? I've not been keeping track of all
that.

>
> -- Hajime
>

--
Cheers, Lorenzo

