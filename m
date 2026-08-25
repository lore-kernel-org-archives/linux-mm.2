Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D9CC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8074B6B009B; Tue, 25 Aug 2026 10:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE516B00A9; Tue, 25 Aug 2026 10:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6FC6B00AA; Tue, 25 Aug 2026 10:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9916B009B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:28:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D77FF1A0420
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:28:35 +0000 (UTC)
X-FDA: 85140022590.14.5232C1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3C46B20005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:28:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HMNJ8UgG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787668114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z12uxGrbsG5ycXsxT+NNx4PFXhBYN+3qRQ7WmF+ATxk=;
	b=wyYdvR15qEK/yL4b8Oz7dg0HOu8JeGFBhAC5ekrQT4eiW0rncxO1W7OxbbxFBNaSImcLw5
	/u+GlmeZqnAB2jTUEvbhw/JojoxZRJevT63HrlgJdPtcdMpm9iX9b1Dfm6HCu7zkrGrA9T
	8p6ZeGrFV3x6OOpo/G0059u6EWPkwjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787668114;
	b=iRe9vezbC/T21v+rGmVmAZIIQ7KWUeD5mFVJJK0pVaqpR+6PVaoaJasxmdGe+s+ZrhkYJC
	ZFsMpU7NnBtQLEZdD88ZSPnat7K97ICc82hq0xAUzweQpHUPtRssWg2baAtKa4zz9d91+D
	XKiFtzSj7KmydJ4LAaYJVVWXSPfmm4Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HMNJ8UgG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D9F6406B8;
	Tue, 25 Aug 2026 14:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779791F000E9;
	Tue, 25 Aug 2026 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787668112;
	bh=Z12uxGrbsG5ycXsxT+NNx4PFXhBYN+3qRQ7WmF+ATxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HMNJ8UgGmzljeesIDsBPDrDy2/WpRCkDYIvVGSRSEtQjmJ6jQSlfeSO0otHWXQlP5
	 Rny3tvsqwo+DWFz5VSguGK+SiCFMLx9CfGhXbNqTL0oKe847zFpTCC2LX7b74J7Snk
	 AzkPS0ko6FzBkT+xTm1y8Y7ZYYeF4paAB74AcSCY/+nJFk9iT0CQzYIJpJRVqlsH/J
	 6dyTnV0lR5qfRtOvZW0AoX4jvsFiY385MDoSLBTG9zn5yjrVeZPQj4REelusb0VTAf
	 tEsONApkMcuyyEwIXPPJibZAPowgMKGYHc57P1YA61hxnHrRji3Ub3dI5GL6B25gKl
	 tvUvR7yZT0WEA==
Date: Tue, 25 Aug 2026 15:28:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, 
	liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org, luto@amacapital.net, 
	brendan.jackman@linux.dev, liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, 
	broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v2 0/2] support kselftest on nommu platform
Message-ID: <ao2l9Ao7BQI6uRKC@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
 <f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
 <ao2Tl9CLL7WjHYun@gremlin>
 <bb9a3add-4849-4928-8b6a-0afc0c73b112@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb9a3add-4849-4928-8b6a-0afc0c73b112@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C46B20005
X-Stat-Signature: tg8uz8cd7kjcw3ebfqkd1af46mc6cpdw
X-Rspam-User: 
X-HE-Tag: 1787668114-439894
X-HE-Meta: U2FsdGVkX18G7GgsNGnPjH6AWDOiMTDZXPQycnFI6icMs2/sfEH07G5Z+qQRMOG3k+jCuIprLlZoouXlEzd05fMOZIiKIjfiE0kbKrHWBsmDHm6Y270gSYz82rlb0/5BtRcEgPab73tViqDmsx2QN2qf0FHgx3WD0Q2pkVBuQMQ7ALVSa4CH7rgXC/MVPlWznngCJgUYmSNE3163zZt186sGOB09v5pAAmwhne24YVlRXGSVgFOq0WitnrLf7wvaQJ+wr4BrODQwnB8P9KKWY2QytMWKnZECheTsVrq45qc8j4e6944LiFSKyjgEsIfrQDz9C9ItQnzZZJSRKfda4ON9EvRViqI6WzVITeFRdHJqw6DsImraGkfysS4uC7kgz/+fAc9afSYLkW8GHwWyOyFmkOkd3u+qIck97wTtOUcsm8JNvgh2JBkxlUzIcEFxP/eSWkNTFA5OppFoUKPSVmPUsDfM9nme+JOJw8fRkeg9sppYKlEde7MVlz8AFmG5t0Zkb/zVpyscZNryIYT/KRAaO+lgPHIgLdhdIJEgMP8wItfdpHlxeCzlnaKZGiEFB04E+HbKVt5wPeTSwZu7PK38YG7hhRq7cBWvd4s/hQkh4bS0inXxwjfnq86/DVqrdypWwtncHgdpmm6LafnC/1B7XeSuDEO8Hde5qSQJ3FruUmVG/NFpyNFIxLSoVpdr8vNdVkn08+r6wEYoJ4mQOBLYxe70hfYcJEwl28oF046lgRPrk63bqAVYKIYva1089mpjqxTheHIYrGcaL+wSKRZGPvin162WESP/HiZPOhsaJDP+x3YZQsAlbJ2c6sar2K2c41vulPv1yNiIOTNkQe88MPkvRKw84xBNdXELLiGPwXOgHXKe4/M5pFp2KXLSMPmSpk5N48aidqk1lxAtfqj8GKuRjaqXBE0pwK8KvOmCEMJoYzILr24+gcrY1DrDBl7LEVSbGghkQOVl0EI
 oL9/Mgjo
 2oL4SAGzPrMZJ6pwHYpKvPTLw63EdvUBTQMNbjjWIzo9/dD/wRSZ5UriYZVkgjNPkXCzrGlI/p2EdV07CAtA45R53/T0tWerrgK9ypCWXAgPkaqfCCBCNyOMoVTGJc9bnicsZGmk2M11S7MV8UIX6KIZhV4EGrIFTupvDI9pvk4qMQePrmfLWfFKfMYcUHOuXJWzGtAZh4EGOL4PQtTTzOzDFeYq7VWHP20NMM2t5o4ttRKgL+Iu+1LtJT8HMl55fFMLXcU1geJa09UsJYaSMWVtqH8HuwAfi4brwFNzSQrjouJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 04:17:54PM +0200, David Hildenbrand (Arm) wrote:
> On 8/25/26 15:12, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Aug 25, 2026 at 10:37:41AM +0200, David Hildenbrand (Arm) wrote:
> >> On 8/25/26 03:59, Hajime Tazaki wrote:
> >>> We add an ability to execute kselftest on nommu platforms.
> >>>
> >>> Currently there are several issues if we wish to run kselftests on nommu
> >>> targets:
> >>>
> >>> - it cannot compile/build test binaries because the current files mainly
> >>>   assume to build with glibc,
> >>> - some of the tests are not able to run on nommu targets as there are no
> >>>   fork(2) syscall.
> >>>
> >>> The first issue can be avoided if we can build static PIE binaries (if
> >>> targets support it), but in our case (build on ubuntu/glibc and run on
> >>> alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
> >>> mechanism.  Thus, we need to cross-compile with musl toolchain, which
> >>> needs to be solved the first issue.
> >>>
> >>> The second issue is the lack of fork(2) syscall on those platforms.
> >>> Especially the test harness helper (kselftest_harness.h) uses the
> >>> syscall, which cannot be simply with vfork(2).  `timeout` command used
> >>> in `runner.sh` never works for nommu platform as it uses fork(2).
> >>>
> >>> nommu component in the mm subsystem has several known issues and having
> >>> test cases should help this situation, thus this patchset is very first
> >>> step toward enriching test environment which has not been well tested
> >>> for a while.  The test cases is implemented based on the document
> >>> (Documentation/admin-guide/mm/nommu-mmap.rst).
> >>>
> >>> So, for the first step, nommu targets only support low-level API of
> >>> kselftests (kselftest.h), and implement tests in a new target,
> >>> TARGETS=mm/nommu.  Other targets are currently not even able to build
> >>> due to toolchain issues but will be addressed once the initial
> >>> introduction which mainly focuses on nommu test will be settled.
> >>>
> >>> The patch was initially combined with other patches but is decoupled to
> >>> only focus on test framework and testcases.
> >>>
> >>> - rfc:
> >>> https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
> >>>
> >>> Hajime Tazaki (2):
> >>>   selftests: run tests on nommu architecture
> >>>   selftests/mm: add nommu mmap and mremap behavior tests
> >>>
> >>>  Documentation/dev-tools/kselftest.rst         |  14 +
> >>>  tools/testing/selftests/Makefile              |   1 +
> >>>  tools/testing/selftests/kselftest/runner.sh   |   9 +-
> >>>  tools/testing/selftests/kselftest_harness.h   |   4 +
> >>>  tools/testing/selftests/lib.mk                |   8 +
> >>>  tools/testing/selftests/mm/nommu/Makefile     |   7 +
> >>>  .../selftests/mm/nommu/nommu_mmap_test.c      | 265 +++++++++++++
> >>>  .../selftests/mm/nommu/nommu_mremap_test.c    | 353 ++++++++++++++++++
> >>
> >> That's odd.
> >>
> >> 	tools/testing/selftests/mm
> >>
> >> itself should know which tests can be built and ran on nommu. nommu-only tests
> >> can be placed in mm/nommu, but I would expect tools/testing/selftests/mm's
> >> Makefile and run script to compile and run only selftests that are supported on
> >> the given platform.
> >
> > I mean I think at this point with mm/nommu/nommu_xxx.c it'd make more sense to
> > simply have selftests/nommu/ + update the mm makefile to not build stuff that's
> > broken on nommu there.
> >
> > That way positively nommu-stuff is put in its own place and what's broken on mm
> > specific to nommu can be fixed there.
> >
> > I'd rather isolate them clearly rather than having them live in a subdirectory
> > of mm.
>
> My understanding is that some MM tests could be enabled/changed in the future
> that support both MMU and NOMMU. Not sure how to best handle that.

Well by default won't everything run? And it becomes a list of what doesn't
work with nommu?

I really don't want to see any maintainership burden or extra work added
for nommu as it's afaic deprecated.

>
> So wiring up mm/nommu as a separate thing did sound wrong to me. So it should
> either be integrated or the tests in fact completely moved out of mm/

Not integrated, because then it starts adding work for people. I'd rather
have separate nommu tests, any mm tests that aren't compatible with nommu
can just be somehow excluded.

Having a 'don't run on nommu' or even just some means of setting which
tests to skip (I think Mark Brown suggested as much in reply to an earlier
version of the series) seems a good idea.

But yeah, tools/testing/selftests/nommu seems the best place for the
nommu-specific stuff.

Can maybe do some ../mm/ horror show thing for reducing duplication as
needed...

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

