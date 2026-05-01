Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A72CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B5C6B0005; Fri,  1 May 2026 15:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BB66B008A; Fri,  1 May 2026 15:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D32B6B008C; Fri,  1 May 2026 15:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4807E6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:08:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB9761401F9
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:08:32 +0000 (UTC)
X-FDA: 84719787264.07.D31D742
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id CC67B120005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:08:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HaouH8e8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777662510; a=rsa-sha256;
	cv=none;
	b=Q0M7oCGUGN3OEJgUah+Nj/YCcijKnQckCaYS7cClP+nd3lF/M1rrQQmvA2b99lk6QAL3HQ
	TkDEhi0OhGf719fN3+3KWFCB3wsAPZRI9XDEIGjKcmEor2JQaaF1WryAJInqLmITrfiCnY
	33pr3rj1RrMYnQJDvokBaJBj2DmHmNI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HaouH8e8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777662510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hw/dnUiNx0MfDmN48zYPSTLx5QFCgo4F6clziTzz9Vc=;
	b=Yd279vDInnn1tFyLSESJcVHWFEcOp/5Ed+rdXdkv4g64HJicFL5vFrXjaVOFi4Fov9qYpi
	xkCC8ONpYXncsEzN5HKZJ6OII+go/H+KCtYOTLZvxRhB9xiJym3q5MZhaB13mdm/ajP0E6
	XWKxjdmlOfTqPYKZgowWzaXuMJHZ7EU=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8ee62a19730so242533385a.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 12:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777662510; x=1778267310; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hw/dnUiNx0MfDmN48zYPSTLx5QFCgo4F6clziTzz9Vc=;
        b=HaouH8e8o/WKFAgJ53rRMj6Oj3vMNvwxqSX/fTKtPudaB0OrIZ5cH1QMLCZtlgDAtk
         2bxhqq6B8gPaL/PZShUDjepcVZyqtSc7s8XA9Z/yO8vxXU3K0lkff9BeieXFxg9hYaAX
         J78IiNAr33ITOk4+3NZgtIcbodNT0+zZMfjYC4OhiaScAoRsVG+RNf5oM8mTW3ovv6D1
         dS8PqsD3S2Q16J7XKgAb9U/Y4XDYheHHaLY6gLcEMADekZItazqep5Xh9hPZ0hqjT9iN
         LAAUSwp/D9s+Zp3maU2JX2+AR8ClDCrFhsljeuX5chxbPBGgE3c43AE3Zks5FkKakMyP
         BjRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777662510; x=1778267310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hw/dnUiNx0MfDmN48zYPSTLx5QFCgo4F6clziTzz9Vc=;
        b=ASwbnN2lEDtfMJpuv6GXv+Sr12UXjEc5InFIQku8bGH8G5D4TNq9lMyjdzFt/znUaX
         jn1SDoh9RTXIGuLlv0OkRTmlW4UQeEpK3L3uDs6jEzGk2ezPhQqmRvKkIzPaEWzCqehD
         9XCB3L5PrZbGkpSZ6T7aTiGCpCaJazvVFkVLx2RxemAlrAGmZYJ9Omr7duq+A7KRcmLt
         HJ1MZuw5oqEOWmGjaWOdpq6gcb3e5w4u1YFf9NgM6nA1oH+JQDDwh61wTxySCyXFAq3B
         +eBAoPg2IVpbQhO6/cq5P5l1oabUByuWU4uBdjtpBzBP1qWvduhIuEPaQVAlRrwSHD0s
         hHeg==
X-Forwarded-Encrypted: i=1; AFNElJ9RGkj/YVL0Lczc4nvxelYhNp7zAIW9D3SR38RP+0Egzm1TvOhvnYDWEPVdcXDSiScCfd3+2bTIUA==@kvack.org
X-Gm-Message-State: AOJu0YzBeuyXHvCv9XqqlUd0Y40SU/pcDrkKQ3lfyA6Zf95FEwBa+ING
	ns71D5pCPDbcdFE1AIWmixjQU/Z1jb3sG7EknjTpfrVhdCdA9Rd5IrS2Pg74LQLpDS/veGHHJ3n
	xQqy2bWU=
X-Gm-Gg: AeBDiev5gRqmwSLfXSK7EBJXpPZGCTrDjZBzkp0tBvE6OHrA73/M9lj0QuifsW0wWS7
	R+UCyD9bRQCiz5aqHqkGQULel6HO10CFGacJ1eBbt980LbY9X+R/fshEsjKGIriOhTtbh1QJjuv
	KKK7og4cQZ8uKrW60Q6uLQbWRXt4m62urXQ6/TBxcKtLTNbDR6ABv9qxOuZ0XVdihuTuyocssup
	HEXMzDIGGbxtVrA0lUOH6xRyDiY2YXUWqG0sPchewNYpXE9YAPsLd81/I41FHxmPS/QDGBEH9hx
	VcvKNMb+h7pXSBey3N/nNINobtxRi6zEMQ8tKLLknzuedM7lYo4IYXfq35m67s5pPmcB5U77a3o
	2I/St0faRHV9YTE/PX99gXGReJ9VC9ctAh7BKAp4j5reQ1uk8t1RRKTn0SRuHiKP5B8ZLIorixK
	zAPCSk/tSUXIQnGgnuApfUakiI8w/aLgfJc+WOVtee8i8iQzgxZSWHmjFayn+1EA==
X-Received: by 2002:a05:620a:4613:b0:8ed:45b8:de90 with SMTP id af79cd13be357-8fd17d497f2mr110554085a.39.1777662509842;
        Fri, 01 May 2026 12:08:29 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2938e7f8sm242450085a.7.2026.05.01.12.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 12:08:29 -0700 (PDT)
Date: Fri, 1 May 2026 19:08:28 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/6] selftests/liveupdate: add memfd tests
Message-ID: <afT5FDAXmcIfz-wI@plex>
References: <20260404102452.4091740-1-pratyush@kernel.org>
 <afEKfQ0GUNVJ76a1@plex>
 <2vxzecjx52eu.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzecjx52eu.fsf@kernel.org>
X-Stat-Signature: dn533b76b3sgontd3sjj84rtrdkji6hq
X-Rspam-User: 
X-Rspamd-Queue-Id: CC67B120005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777662510-820520
X-HE-Meta: U2FsdGVkX1+NsoHyG4TCK2fK4WsIiIV0uG0mhPr7NrUWF8VFC/XRzEF/jtdakEGaiuQUJY/oNh60GYbz9TUCTknzob0WgX+L96M8MMoPFgw5fdK4/Ed3PDVdTsVWPcmU42lHf5qEqvQV3/l5gMINWss3sUjKbOfCX2IZ97z9Ka9p6A5vgWDeKidqwD69nYENDmW1UE3dLWY0+x6nFSpMMH3Mh0bvRKBew267LQInIySkIzH1hKRnTOalpgJ3wMoVKwLx8E2ocVQJM4yfStuOhzzbg+KHzHH6ZuLINF5pzvTJLrqQ0ZcR/o0IB+JAAW0tJlL/9tzdplxrXSvB6rgam+PTdpkHy0bAzZTYGJbcqW4zEUqFXISmNyKVT9BzMvTW3g0Y+KSfbaagl+XQnt7SMcQ+iKkOpbb+6p7YwYbgSZEjRLQ9ZPo7ZvblcbfMFCyjS+Wx4hfz5W9xVf+MmgikX9TiVaa/aYGOg31c/k6rm/PlGcl+OpC3kDvkFem4oqPmH9KSaDiTH8tZJSHWjqcz4YGT9Tu1F8sXD51RDO+7V7fZnldVzMFxRYNpKb2usD8bapgM3dNqwkqblF7fdKjNMkaUuh4v5UmZWrDBT0L1o3f/YmfPK46+XbfCGGV3LsIq4NANKx1idhZU2WmgqMRy/tedK6OyEGTCJn4wng6Qyago3LHdNK9M1uOGRa+Cf+AYk7tqTVrOW4ZDDvkLFIf+H5KGhdCKeAJxUfmB96Sg2PhwVRbYpROXZKAmDknqstd83NAhw9wMunwejRRxPZ68UDV+4XGdwt3RY0TE7tuAWKOTHH+BYbrDTkFYdXw1/wEdZNl3uwZ0l98pUonLYqcy/B+FAQfaV1BrHjOP0RJaM3VyzOzA3fEH/EKMTZTtQ5DYkIC38YEjCXl292yIs+1JyWzWAXzVWJEOYyPaN+WZiPOrAlv89XZKK2OtZSNnSWLCj8RJZf2sk6fcHhUy6kH
 rMmn1yq5
 weJSCf2CX0QQ7Ehz4bMBGggjagivHn5vtvoI5lSezI12uJrYQJBsL1pG17B3duwg0Ckrd6bFNWtWV/+YxjZbyyLXsXCAoC+p/dyRhHsMwfxpsTXYJKkPBpq7uUCbXIwRnvSb6ZyYrSHPeBzoJKXJHd0bCpEWfZKH2mO5zyaz3gv78iFfwAbb/fbxoHp2oLkyADa31+xEdv+WIzGmGZ2xolNp0dmIPsuDQ/X/sNDCy7yX+pVO/vGdPx76fL5vjJoQdwQ9NM8zjo2kHiVNA307ctXTMV4OBGP3CpexXk8tDSdyjk+aJ/v7buHozQVSkX2gU4ti2zz7E858G8hwJUc7HbK00q9IKil0joK1PxDhA2xGQ8zbO3LIT3eQyXhRYPFsOL79Y9CReLT+AfiPLhkHbKxnJsYmVzg/T+zaHvftq2PmEnmnparPv0Xi4FmX6jBEtvCxK8XY2B2WUVTEHJX1FVWhDE5/VSxzFdbW4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-29 15:20, Pratyush Yadav wrote:
> On Tue, Apr 28 2026, Pasha Tatashin wrote:
> 
> > On 04-04 10:24, Pratyush Yadav wrote:
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> 
> >> Hi,
> >> 
> >> This series adds some tests for memfd preservation across a live update.
> >> Currently memfd is only tested indirectly via luo_kexec_simple or
> >> luo_multi_session. Add a dedicated test suite for it.
> >> 
> >> Patches 1 and 2 are preparatory, adding base framework and helpers, and
> >> the other patches each add a test. Some of the code is taken from the
> >> libluo patches [0] I sent a while ago.
> >> 
> >> [0] https://lore.kernel.org/linux-mm/20250723144649.1696299-33-pasha.tatashin@soleen.com/
> >
> > Here are few observations that I noticed when I tried to run your tests:
> >
> > 1. The '-h' tells you nothing about --stage argument:
> >
> > root@liveupdate-vm:~/liveupdate# ./luo_memfd -h
> > Usage: ./luo_memfd [-h|-l|-d] [-t|-T|-v|-V|-f|-F|-r name]
> > 	-h       print help
> > 	-l       list all tests
> > 	-d       enable debug prints
> >
> > 	-t name  include test
> > 	-T name  exclude test
> > 	-v name  include variant
> > 	-V name  exclude variant
> > 	-f name  include fixture
> > 	-F name  exclude fixture
> > 	-r name  run specified test
> > 	...
> 
> Yeah, unfortunately that is a side effect of using test_harness_run(),
> which does not know anything about the options specific to our test.
> 
> >
> > 2. '-l' does not work after you run stage1, do you keep /dev/liveupdate 
> > open? That is not needed, we only need to keep session open.
> 
> Oh yeah, I keep forgetting that is no longer needed. The main process
> closes the FD but the forked daemons hold a reference. I can clean that
> up via a fixture.
> 
> >
> > root@liveupdate-vm:~/liveupdate# ./luo_memfd -l
> > 1..0 # SKIP Failed to open /dev/liveupdate (Device or resource busy) device. Is LUO enabled?
> >
> > 3. Stage 1 has proper [STAGE 1] prefix, but no [STAGE 2] prefix for 
> 
> Because stage 2 has no prints, all the prints are coming from the
> selftest harness. Those same lines are also not prefixed in stage 1. If
> you'd like, I can add a print beforehand that shows which stage is

Yes, please, add a least one [STAGE 2] print.

> running. Other than that, I don't see what else we can do. I don't want
> to modify the selftest harness.
> 
> > stage 2:
> > # Starting 4 tests from 1 test cases.
> > #  RUN           global.memfd_data ...
> > # [STAGE 1] Forking persistent child to hold sessions...
> > # [STAGE 1] Child PID: 245. Resources are pinned.
> > # [STAGE 1] You may now perform kexec reboot.
> > #            OK  global.memfd_data
> > ok 1 global.memfd_data
> > #  RUN           global.zero_memfd ...
> > # [STAGE 1] Forking persistent child to hold sessions...
> > # [STAGE 1] Child PID: 247. Resources are pinned.
> > # [STAGE 1] You may now perform kexec reboot.
> > #            OK  global.zero_memfd
> > ok 2 global.zero_memfd
> > #  RUN           global.preserved_ops ...
> > #            OK  global.preserved_ops
> > ok 3 global.preserved_ops
> > #  RUN           global.fallocate_memfd ...
> > # [STAGE 1] Forking persistent child to hold sessions...
> > # [STAGE 1] Child PID: 250. Resources are pinned.
> > # [STAGE 1] You may now perform kexec reboot.
> > #            OK  global.fallocate_memfd
> > ok 4 global.fallocate_memfd
> > # PASSED: 4 / 4 tests passed.
> > # Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > ./do_kexec
> >
> > root@liveupdate-vm:~/liveupdate# ./luo_memfd
> > TAP version 13
> > 1..4
> > # Starting 4 tests from 1 test cases.
> > #  RUN           global.memfd_data ...
> > #            OK  global.memfd_data
> > ok 1 global.memfd_data
> > #  RUN           global.zero_memfd ...
> > #            OK  global.zero_memfd
> > ok 2 global.zero_memfd
> > #  RUN           global.preserved_ops ...
> > #      SKIP      test only expected to run on stage 1
> > #            OK  global.preserved_ops
> > ok 3 global.preserved_ops # SKIP test only expected to run on stage 1
> > #  RUN           global.fallocate_memfd ...
> > #            OK  global.fallocate_memfd
> > ok 4 global.fallocate_memfd
> > # PASSED: 4 / 4 tests passed.
> > # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> > # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:1 error:0
> >
> > 4. I also do not like that we now have duplicated stage parsing code in  
> > luo_test(), perhaps we should add our own  test_harness_run() variant 
> > that depends on stage, and use it in both current tests, and the new 
> > memfd tests.
> 
> Sounds good in principle, but unfortunately ends up duplicating a lot of
> logic in test_harness_run() that is not a good idea IMO. We should work
> with the harness not fork off into our own.
> 
> I suppose we can refactor some of the logic there to split into
> functions that we can then use in our luo_test_harness_run(), but
> keeping the option parsing logic in sync is going to be difficult.
> 
> And for the duplicated logic, I agree. I thought about cleaning it up
> but was feeling lazy... Well now that you have called it out let me see
> what I can do.

The main point is that the luo_sessions and luo_memfds tests should use 
a common framework, whether that's luo_test_harness_run() or the generic 
test_harness_run(). I don't have a definitive answer for this, so I 
recommend tinkering with it to see what works best.

Pasha

> 
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

