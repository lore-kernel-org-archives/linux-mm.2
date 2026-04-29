Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06CCFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE9A6B0088; Wed, 29 Apr 2026 09:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EA96B008A; Wed, 29 Apr 2026 09:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D316B0092; Wed, 29 Apr 2026 09:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B35566B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:20:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 534EE40214
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:20:15 +0000 (UTC)
X-FDA: 84711651990.13.B77A72D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C2B4D80002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:20:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OqL/UlYT";
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777468813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiOY3ViJ/93eAEXSmta7qliTvJfCwzcjgAyKoP7d23U=;
	b=R8FCTTh1JXH5kRfn0PoQSaJYN1GoUU7qSSsIxAdoZMee8rf0P55cW07vU5h/woA+PyjMXq
	qTfRrixiRdRIzjFnLAJxt9pivDw1CKXilnMZBCWO/B0Ca+DSKxajfAU/njGLzOKiBxU30n
	FKMk0pp7SI7nOMyFFNJRE6L1dJ392pA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OqL/UlYT";
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777468813; a=rsa-sha256;
	cv=none;
	b=AZQw4JK7gqQ7G87E9uTT7DavXWn9t/pIuOLPMVXLIma7pgPRC7DUJaa3Uq3X+6tvG8RNSU
	5fiw2AaW8QxOeO3BO6+wKgAl7ZD4ZfmRs2Uc2hi2G79Q5BnDkZ8XrL8dIqcOqSFyfuIRjj
	SPdOQ7P3IovfytjlbEvcPh2qcFCySXs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F39760138;
	Wed, 29 Apr 2026 13:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4242AC19425;
	Wed, 29 Apr 2026 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777468812;
	bh=WBIKlOKETVqEtql1+Yzk/jj+FrWANtHnrA8WI+d7PWk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OqL/UlYT8/yL8caVmjjltYa+hdLsEbO5IOitUCF+kl0IJnzAj6GolLqnmIfypQW9Q
	 KCs+F+Q5xuGEMgJpE1zr5S+QJQQPQuZXj8ccA8vRfWVbmlBZ/ZgRaKMCeUDlJkOECv
	 71cYfgXodQED7Z7WV+ngHFUSAKkJx4CyI+CdS7Ks9SsFEE4ZbpU8ZMLS7CGYoFvkqM
	 rUzNVQYz5MEo/Q0x+6aR/QzST1yqEL8IMTwjUur00zR9fWoPMH52ECRpXrDD/BKfTS
	 1NP1a3rfyjl4F6etV3UBIyFK+NHjsaT3lHIvLEJGi2j2w9HlvrQGdK8Dj+NVZQSjTG
	 tAU23rb1hrrUg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Shuah Khan <shuah@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Usama Arif <usama.arif@linux.dev>,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v3 0/6] selftests/liveupdate: add memfd tests
In-Reply-To: <afEKfQ0GUNVJ76a1@plex> (Pasha Tatashin's message of "Tue, 28 Apr
	2026 19:31:04 +0000")
References: <20260404102452.4091740-1-pratyush@kernel.org>
	<afEKfQ0GUNVJ76a1@plex>
Date: Wed, 29 Apr 2026 15:20:09 +0200
Message-ID: <2vxzecjx52eu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ghcgf653a6zch61mh6ndz8xrxsp4wzeo
X-Rspamd-Queue-Id: C2B4D80002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777468813-797368
X-HE-Meta: U2FsdGVkX1/r03YWocUHUVPB3mJIMbnJKSivnyosNaP0cxHsojeIu6D87l4zVvXZQgv1lDQqG+V8qYAqEprdz/K2KOJDt1UU9uFaTgnjB/E8G/dDBhHhA0ug6h125WoeeSR3RD8O53GTAuAI+uiSK7otLE38Xbyw5WzhiMLHcyt2A//IXghFIMtGnhvrLUbj5kTFt3FyVQ4EFHQ0kZbWu9MLUqmmaWJXIFwoej1IP3Q3v+8K3neqAheggjn9fY3xaog1eFltBWC2WzakPnTBIxDPSLvRtxXYEGgTZc+J8bD9U4uGdEzKt3qtwccRcirAHPJQJZIyoTgUfm1wov35dWEMK4Utf2yYGknfG9Wv7I/7l5EWy6vhSTXn8MvxAuvHpBUUeiFDVU2fpghv4FNlCsl0dbCxIngS22yKAvD7hmDgyDSCJps+cbnvmkn00iFiiH61MMwPLWk2Ji0Goi6a+aBPnOcLoZokqXT43XwBqyQOHUr1Ad06f8k+f0TO4+qDTsXFSVLLz+Oa60Hkl57NbAEk+U/DzmIUqeYJ8flpt7m+KM5G7iurQT+cH9w6A+kjGSY9aTU+6Rly/xi4zFkq45vHo2Kz4b112/xsJbuuZO5sKjKHLGHeQjZkvFr8qD59evCPDQ4YIO+bz0C15+OXIu9BRb4FpEsPY/uw8XBJ+9onr8W620fHpJwC5p4J+iR9HVZzCOVAODiufjCyGh4e7EWEBIw57cRJHYiMAm0Tjv1+O4cYuOYATiCGjmrSK0uRRVVvK/yrM5apQ4huY5M8QHa4TK3c1FG1EpmkfyGFufWpJv0w8+kWRUaeewXvH9t6ayS97CUtzIGvYh5uFqFpqgeBZJCZQY+j7FPzxFY/SWStYqZzMD9fxnqiSf8vRV8kzxJuHp3wWnNaiafO1yXTKKtcBsaSKucDkVkmRE8HzPquy7s64X2qhwM7yNyNVgGhQwolM/gEMtHoeXBod5+
 PFYkKsIP
 V4cTbXRNd6GDqNHJSxB+Z0C2KTJOro/uiLG/33grbmk8XJXilOuSk0Ax+rTZMzMyAt7atNXYICws/sOdpeO9UPrWofkK7sGyIugfSzVoUgk1tNefEm7MTkvgaMf4SS/hgZd2VHfBvO+hcnGDQHBUF197ugj3DE5eJLZ9vALKwhutlbyAJSoO8otSwXSDZ72MiA1JP/rTJF3AA/AptGVpltLrYNqwDJyNHl3jIp06R9qacWKQ/PoFGfvbj2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28 2026, Pasha Tatashin wrote:

> On 04-04 10:24, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Hi,
>> 
>> This series adds some tests for memfd preservation across a live update.
>> Currently memfd is only tested indirectly via luo_kexec_simple or
>> luo_multi_session. Add a dedicated test suite for it.
>> 
>> Patches 1 and 2 are preparatory, adding base framework and helpers, and
>> the other patches each add a test. Some of the code is taken from the
>> libluo patches [0] I sent a while ago.
>> 
>> [0] https://lore.kernel.org/linux-mm/20250723144649.1696299-33-pasha.tatashin@soleen.com/
>
> Here are few observations that I noticed when I tried to run your tests:
>
> 1. The '-h' tells you nothing about --stage argument:
>
> root@liveupdate-vm:~/liveupdate# ./luo_memfd -h
> Usage: ./luo_memfd [-h|-l|-d] [-t|-T|-v|-V|-f|-F|-r name]
> 	-h       print help
> 	-l       list all tests
> 	-d       enable debug prints
>
> 	-t name  include test
> 	-T name  exclude test
> 	-v name  include variant
> 	-V name  exclude variant
> 	-f name  include fixture
> 	-F name  exclude fixture
> 	-r name  run specified test
> 	...

Yeah, unfortunately that is a side effect of using test_harness_run(),
which does not know anything about the options specific to our test.

>
> 2. '-l' does not work after you run stage1, do you keep /dev/liveupdate 
> open? That is not needed, we only need to keep session open.

Oh yeah, I keep forgetting that is no longer needed. The main process
closes the FD but the forked daemons hold a reference. I can clean that
up via a fixture.

>
> root@liveupdate-vm:~/liveupdate# ./luo_memfd -l
> 1..0 # SKIP Failed to open /dev/liveupdate (Device or resource busy) device. Is LUO enabled?
>
> 3. Stage 1 has proper [STAGE 1] prefix, but no [STAGE 2] prefix for 

Because stage 2 has no prints, all the prints are coming from the
selftest harness. Those same lines are also not prefixed in stage 1. If
you'd like, I can add a print beforehand that shows which stage is
running. Other than that, I don't see what else we can do. I don't want
to modify the selftest harness.

> stage 2:
> # Starting 4 tests from 1 test cases.
> #  RUN           global.memfd_data ...
> # [STAGE 1] Forking persistent child to hold sessions...
> # [STAGE 1] Child PID: 245. Resources are pinned.
> # [STAGE 1] You may now perform kexec reboot.
> #            OK  global.memfd_data
> ok 1 global.memfd_data
> #  RUN           global.zero_memfd ...
> # [STAGE 1] Forking persistent child to hold sessions...
> # [STAGE 1] Child PID: 247. Resources are pinned.
> # [STAGE 1] You may now perform kexec reboot.
> #            OK  global.zero_memfd
> ok 2 global.zero_memfd
> #  RUN           global.preserved_ops ...
> #            OK  global.preserved_ops
> ok 3 global.preserved_ops
> #  RUN           global.fallocate_memfd ...
> # [STAGE 1] Forking persistent child to hold sessions...
> # [STAGE 1] Child PID: 250. Resources are pinned.
> # [STAGE 1] You may now perform kexec reboot.
> #            OK  global.fallocate_memfd
> ok 4 global.fallocate_memfd
> # PASSED: 4 / 4 tests passed.
> # Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> ./do_kexec
>
> root@liveupdate-vm:~/liveupdate# ./luo_memfd
> TAP version 13
> 1..4
> # Starting 4 tests from 1 test cases.
> #  RUN           global.memfd_data ...
> #            OK  global.memfd_data
> ok 1 global.memfd_data
> #  RUN           global.zero_memfd ...
> #            OK  global.zero_memfd
> ok 2 global.zero_memfd
> #  RUN           global.preserved_ops ...
> #      SKIP      test only expected to run on stage 1
> #            OK  global.preserved_ops
> ok 3 global.preserved_ops # SKIP test only expected to run on stage 1
> #  RUN           global.fallocate_memfd ...
> #            OK  global.fallocate_memfd
> ok 4 global.fallocate_memfd
> # PASSED: 4 / 4 tests passed.
> # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:1 error:0
>
> 4. I also do not like that we now have duplicated stage parsing code in  
> luo_test(), perhaps we should add our own  test_harness_run() variant 
> that depends on stage, and use it in both current tests, and the new 
> memfd tests.

Sounds good in principle, but unfortunately ends up duplicating a lot of
logic in test_harness_run() that is not a good idea IMO. We should work
with the harness not fork off into our own.

I suppose we can refactor some of the logic there to split into
functions that we can then use in our luo_test_harness_run(), but
keeping the option parsing logic in sync is going to be difficult.

And for the duplicated logic, I agree. I thought about cleaning it up
but was feeling lazy... Well now that you have called it out let me see
what I can do.

[...]

-- 
Regards,
Pratyush Yadav

