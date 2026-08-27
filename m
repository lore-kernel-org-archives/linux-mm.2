Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C46C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F0C6B0088; Thu, 27 Aug 2026 04:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26ED6B008A; Thu, 27 Aug 2026 04:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C646B008C; Thu, 27 Aug 2026 04:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AABD36B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:46:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9333E1A036D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:46:30 +0000 (UTC)
X-FDA: 85146418140.12.714BB24
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE8321C0005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:46:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WhvtpAi7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787820388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MKQBXQ2qiIPcch87en2gxSQXnqBJNIJwYDdb9qgoaA=;
	b=en9kUOxhDIQphgy/MpMlVTFe1FY5OfW6phcPsnOZafpNywwNucwcGBA/5apgQrMO2Xd9nu
	jHV1BKESNndrwQsD+jDObFpCwiPcAU4gs7J3k5eBro8Jct+l6ClVDvclwanI9uXYu23Ux5
	3HkC/5MSIcZe7pZYaUdSlvORQ4KgwyM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WhvtpAi7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787820388;
	b=7yv8FlOF5p3ge98GUP2X3vSitM6sxL7N07ZNJeHacZ0DFk5RyZrSFKeCs6+WfVF+/fDW1b
	uNOZ1hJkhqLPrmwtQO7wQMNEQhiw33bwS+16UBdNnq8W9q6G4qRh4iaHwfMvV2Myu4/WJ8
	tASM/IsljbjxQ4BGnNAHd63lA3HYhoI=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-39686abd426so1715286a91.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787820387; x=1788425187; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9MKQBXQ2qiIPcch87en2gxSQXnqBJNIJwYDdb9qgoaA=;
        b=WhvtpAi7JHegDv6vGoLMQayHyd4sgFL/pmZwjGEu3lIB8zps4fCc8sKsDlfChjvSRK
         Y08LUBZZJ3HQVcesiNHLLBdPba5RxSfpjeArHfps9bvIXql5XKknvSXUvfc3BnWnVRte
         QLkGRoi/NnWWXs+RW2feouMcg5GLL+Se+uhnhB1aNLgsW5lRYIWXimjZAyc7s0+85Xzw
         GascgIhOH89O3nu1nN7MWxLAHhiN6wMMTjJaLlcfHF9v8yiBrpe3Dmaqm0s89ztvLQ4e
         SujaImJrljhZ+LcXUxgCpM2m6qCTTc36iSE2TQWd3MrbMSTPLe5k/TPdknZONA1P9lwg
         tzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787820387; x=1788425187;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9MKQBXQ2qiIPcch87en2gxSQXnqBJNIJwYDdb9qgoaA=;
        b=ojcAhcGR0IqrwsUfy4i7a9f0GCneS9kUVkPUm14+mXKsZe/e+vkwW1fN2LUI5nOlg6
         Vkxw7gL7jb0cn/wGK9S1gusWmeaq/zdWQL7vkeN9aC12Q7o+c2dEVWAcgApZYv+tURk9
         TW0RwPpsWlmKF8lziCQQXPb4eEA4J+wFmDPejUHwMGmEORbQ2R0KFYyeGnscfCnx/7yw
         gn723dSDPZtIxdID3q9ohwG1P5GZ5YRvqGA78m0QJvdS+d40LoqfjSFval+V8MRflN6w
         5rjdjb8F1mGUJIHbd9gGGJ184CVCGSEUkrmPlbp4MekgcxZhqAh9gsYr69aGPvcDw1Z9
         n8YQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLVxP9tgr6brUZotA9RfffUpI1/dkqCY3e+hd644Hx07m9lyr4FrGXD0K7XVasNqp3DbMkfxIhuw==@kvack.org
X-Gm-Message-State: AFuF++mkU1w8py3DiMO5kq7p9+BD1ANQzieWyJv72sRsqRXWKbrOmy9c
	6Y8RM8OeS7Uf9VB3PiG1/AxYXkFLXeZk2I7ww1T/pOjtLiC7SLXdyJyk
X-Gm-Gg: AR+sD10+vTWTXBF4zUGjlZMV/vmEJmKBDJzKKI+DB14SbzQ30/V1yTHjc1HXcQ8E8JK
	FjTTfMyHLl27LIxVC21Zw//p4c/0zMW3kcJUdON/PZ8stEOiWrsg5miKalrieAeZziOJKusqvwl
	vtaBVkTUjpV+E1X8cn++1oiBgOHukE87oBZ/08w2p5BOlzXX1ZkjV0jh5Xu3Fnxlx6FbgbkX09v
	0BTHR4770JLdxL1bFguaRb3lCxuyW+yt6W+evSrgS88HFM9UiRMziC6ib10M9KkX7llvyxXs0Xr
	mty0J33zkX+MJnWS9dEJQUbOF3ahwYWTFWkCEe5E/e9Ysc/BAH9JeT41iPOKQvKHfKtrMhYjgbs
	8IeGKxOGBskoG7ikRwjYOVxl3d0a5VM72g+axaArlk3sxVfaaTWMFklLatIhjNO/VDfe9dsf2Ai
	iOZbrImzSkCqiSfT1xFQgdX72WjxKky2LS0ih0p8ZmSITAY0i0XgX0wkIuv5kgibkFnvwVT3fDY
	q14alRWBl9lF9HRKyE+v87W/2LkiHrwyhmJdTZZMrVM9rNnI2v03KKSJkutCdquTH/W5a6eEtJB
	hTxKaw==
X-Received: by 2002:a17:90b:1809:b0:38f:7f60:ba35 with SMTP id 98e67ed59e1d1-3966d199247mr26527608a91.5.1787820387338;
        Thu, 27 Aug 2026 01:46:27 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39675922253sm2042307a91.4.2026.08.27.01.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 01:46:26 -0700 (PDT)
Date: Thu, 27 Aug 2026 17:46:22 +0900
Message-ID: <m2y0dsuf1d.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: david@kernel.org,
	linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org,
	geert@linux-m68k.org,
	daniel@thingy.jp
Subject: Re: [PATCH v2 0/2] support kselftest on nommu platform
In-Reply-To: <ao2l9Ao7BQI6uRKC@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
	<f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
	<ao2Tl9CLL7WjHYun@gremlin>
	<bb9a3add-4849-4928-8b6a-0afc0c73b112@kernel.org>
	<ao2l9Ao7BQI6uRKC@gremlin>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 66cy8dugsczbgpxbusm4fh3qpw68irdi
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE8321C0005
X-Rspam-User: 
X-HE-Tag: 1787820388-125775
X-HE-Meta: U2FsdGVkX1/JYDPnxM0BekfHMqrKn4VBIWMsBbulFtdo6ZRP7sQljwGsMQ4+0/cOh9G5mMdi2zP123hudkCebWzm9PxfWqyZvuZXXvzFmNhiZ+avylFJDN6bxRBtBUy4m4l4txd3j5RqQxc48gzmX/Bewady1+kppRhEcpO2cEj+FHVyK2pGs9b/YsXh05tpCeaeYhjpyeofDKSoI9+lh+8s+tNJ1ChPAOJuROfeeHknRnKpNt0WIJWxHGVbcn5JpB5oxj/4D4LzVFbEPVAPYAdo5WUarubG9dlXxfysQ63LLNOfTQB6Irqww4KE06vqXLNYHmLOlIIXYAOkq0uK8avYLEBE26vEoQ800QFW957LmgyYfo9acwd4F5d3ADU294+4nhhUXXbD9XiC6JQqsJYtXt+z1lpq5R3f+xAamy+zPMp0SeCWBvLcdyAqEdd/C6Vi6EMdAYv+BsOhjwBhyR073GRv3tMwJLYvR22VP1QLpM8DXA4XbhQUzc5q9K95L3wAEiMgCClcJePO4LelQvTXRdR8Ei8Wp0QP4WApqY2DO90j5/u77qb5FHuJ//OzUX0DBwUA92ZgDEryM9lX0YNJlmxSTU2mvz9OjNpsbYFyvwbQdO7ANORuQkp1UkkU+rcLC8+drKaYP+QCmJpQTThQI0lIC29KBt+gkSyWlPHcCZl2KTGnvAJW9fBNB5hMKLMXJ8NHT5NyJwZnxHwKLPr3f2DeZ5LxsPD58WAtWUUepUh0UJlI7LvW7i1DIItR/CgBJ0Co211jukGXotGyFWKOMB63lv4ryKmKcmifKfIpiACXkt8X0+AZRVmmd45FPvOeYk2jSmxeimOLeegvWbfH36zdLPcPRP3EPV1kNC81rLpGUpuArHP3Rus3bAzvHm30SFgfXGIpCC/+F51l+i7eZg7bGb2EnK1gEHkpPijx7w4n3qNdHblcz4x5EkUwsqb69jTmKBty01iGaNe
 Z1txUjfd
 S3qs0fSfHc3hO+FwEcH6wgSMkcj8ixy1XHjR3FW7gLtW4K5X4ukWgsIkxIVbei7M0Ducp8/SwSj1zT62OnxGedR/EGWWf/DZRqJFHmmxCjVSFoDVaA3MY/MRzZppMEawsNrEaO3kkYrKRehnue/tYkWhkhKWYXxt8oruoQ9mIUe2Br35YSuuVsX+lsNsw+JyLnzWdrfeXMd1qnwaqu/cBrZndfiBRsrBvn8dkZoduPjcvLojuw+3PtmrjPfKaFCYlfKu0E5T0Qz73erZSOXFYRfBLQu6czL/57nq4f8DQo1SzXWXAQKhFNaALZRJeGUZUhBQxpV7+0Mep9kKICFLdqcQP4ghXtn4Q2WRhnsr9h2h99vJ2i0kYCgy4jkqJGjv0s6fRR0eeadw2Gz8lJVnn2g9vA5i/AGXkdsz8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello David, Lorenzo,

On Tue, 25 Aug 2026 23:28:24 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> On Tue, Aug 25, 2026 at 04:17:54PM +0200, David Hildenbrand (Arm) wrote:
> > On 8/25/26 15:12, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Aug 25, 2026 at 10:37:41AM +0200, David Hildenbrand (Arm) wrote:
> > >> On 8/25/26 03:59, Hajime Tazaki wrote:
> > >>> We add an ability to execute kselftest on nommu platforms.
> > >>>
> > >>> Currently there are several issues if we wish to run kselftests on nommu
> > >>> targets:
> > >>>
> > >>> - it cannot compile/build test binaries because the current files mainly
> > >>>   assume to build with glibc,
> > >>> - some of the tests are not able to run on nommu targets as there are no
> > >>>   fork(2) syscall.
> > >>>
> > >>> The first issue can be avoided if we can build static PIE binaries (if
> > >>> targets support it), but in our case (build on ubuntu/glibc and run on
> > >>> alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
> > >>> mechanism.  Thus, we need to cross-compile with musl toolchain, which
> > >>> needs to be solved the first issue.
> > >>>
> > >>> The second issue is the lack of fork(2) syscall on those platforms.
> > >>> Especially the test harness helper (kselftest_harness.h) uses the
> > >>> syscall, which cannot be simply with vfork(2).  `timeout` command used
> > >>> in `runner.sh` never works for nommu platform as it uses fork(2).
> > >>>
> > >>> nommu component in the mm subsystem has several known issues and having
> > >>> test cases should help this situation, thus this patchset is very first
> > >>> step toward enriching test environment which has not been well tested
> > >>> for a while.  The test cases is implemented based on the document
> > >>> (Documentation/admin-guide/mm/nommu-mmap.rst).
> > >>>
> > >>> So, for the first step, nommu targets only support low-level API of
> > >>> kselftests (kselftest.h), and implement tests in a new target,
> > >>> TARGETS=mm/nommu.  Other targets are currently not even able to build
> > >>> due to toolchain issues but will be addressed once the initial
> > >>> introduction which mainly focuses on nommu test will be settled.
> > >>>
> > >>> The patch was initially combined with other patches but is decoupled to
> > >>> only focus on test framework and testcases.
> > >>>
> > >>> - rfc:
> > >>> https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
> > >>>
> > >>> Hajime Tazaki (2):
> > >>>   selftests: run tests on nommu architecture
> > >>>   selftests/mm: add nommu mmap and mremap behavior tests
> > >>>
> > >>>  Documentation/dev-tools/kselftest.rst         |  14 +
> > >>>  tools/testing/selftests/Makefile              |   1 +
> > >>>  tools/testing/selftests/kselftest/runner.sh   |   9 +-
> > >>>  tools/testing/selftests/kselftest_harness.h   |   4 +
> > >>>  tools/testing/selftests/lib.mk                |   8 +
> > >>>  tools/testing/selftests/mm/nommu/Makefile     |   7 +
> > >>>  .../selftests/mm/nommu/nommu_mmap_test.c      | 265 +++++++++++++
> > >>>  .../selftests/mm/nommu/nommu_mremap_test.c    | 353 ++++++++++++++++++
> > >>
> > >> That's odd.
> > >>
> > >> 	tools/testing/selftests/mm
> > >>
> > >> itself should know which tests can be built and ran on nommu. nommu-only tests
> > >> can be placed in mm/nommu, but I would expect tools/testing/selftests/mm's
> > >> Makefile and run script to compile and run only selftests that are supported on
> > >> the given platform.
> > >
> > > I mean I think at this point with mm/nommu/nommu_xxx.c it'd make more sense to
> > > simply have selftests/nommu/ + update the mm makefile to not build stuff that's
> > > broken on nommu there.
> > >
> > > That way positively nommu-stuff is put in its own place and what's broken on mm
> > > specific to nommu can be fixed there.
> > >
> > > I'd rather isolate them clearly rather than having them live in a subdirectory
> > > of mm.
> >
> > My understanding is that some MM tests could be enabled/changed in the future
> > that support both MMU and NOMMU. Not sure how to best handle that.
> 
> Well by default won't everything run? And it becomes a list of what doesn't
> work with nommu?
> 
> I really don't want to see any maintainership burden or extra work added
> for nommu as it's afaic deprecated.
> 
> >
> > So wiring up mm/nommu as a separate thing did sound wrong to me. So it should
> > either be integrated or the tests in fact completely moved out of mm/
> 
> Not integrated, because then it starts adding work for people. I'd rather
> have separate nommu tests, any mm tests that aren't compatible with nommu
> can just be somehow excluded.
> 
> Having a 'don't run on nommu' or even just some means of setting which
> tests to skip (I think Mark Brown suggested as much in reply to an earlier
> version of the series) seems a good idea.
> 
> But yeah, tools/testing/selftests/nommu seems the best place for the
> nommu-specific stuff.
> 
> Can maybe do some ../mm/ horror show thing for reducing duplication as
> needed...

As David mentioned my goal is to run all selftests/mm tests on nommu,
but as I explained situation to Lorenzo, it currently doesn't any
tests of mm/ on nommu platform (plus cannot build).

so I'd like to start as minimum as possible for this patchset, thus
creating different TARGET at mm/nommu, which I thought it should no
harm to the parent directory.

But I can move from selftests/mm/nommu to selftests/nommu for now, and
will propose to move into mm/nommu once it will be more meaningful to
do so.

# btw, I started to looking at code toward virtual mmu; I cannot tell
  how it'll be tho now.

-- Hajime


