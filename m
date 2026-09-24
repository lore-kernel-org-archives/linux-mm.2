Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FE3C98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF756B0098; Thu, 24 Sep 2026 15:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A0A6B009B; Thu, 24 Sep 2026 15:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852446B009D; Thu, 24 Sep 2026 15:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4979B6B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:25:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA435A0451
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:25:22 +0000 (UTC)
X-FDA: 85249634484.03.B16E614
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DDE58A0006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:25:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2pUprhT;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2tvt0mN+rfQIn0XcEUNtP28LzckUHtZkO5l64gDOok=;
	b=qlpW9smmRREwc/BMxoF4Sz6NQ8RJS7d5xynwzukWMpr/gA0aTky0lkZASO+LQ5vNp/CmQz
	v49wPwnCdEmrA/PBOvwITPJtRoCp8tn92psDDqqiOxjsBY2rlpMllvpPZUMy1QVSrJumKD
	Ttz/haalBOdvVK3wALGzPwsUhX2AluM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277921;
	b=TQ4X4rFo7DhU705ggHHHJSsJ2zS3Pua5JbsUa+huA4grEkndXA0xlKhNamUSZFeTjg2o0U
	lhCNm8sur7JNtalwphOBv/ZXwwgYzPRVye573DwhHYxnmdXQ0TmKX32RcvRLjfxKpaR1nc
	k6CoOI2E2apzf9nUhnUplAH87O08WQs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2pUprhT;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B63741795;
	Thu, 24 Sep 2026 19:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02C01F00893;
	Thu, 24 Sep 2026 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790277919;
	bh=t2tvt0mN+rfQIn0XcEUNtP28LzckUHtZkO5l64gDOok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E2pUprhT9/xwQ9JjC3QDHZ6WqHqRvyWkQ/fT1SA+mJGJ9Sscsom0u+SS0svWOgisH
	 sV2vxa8TOvmlrSnsAYnQJr8BEE/wmhpasXR4FfFuEhaOMO1XJrREILb1bqKgT0mjio
	 JgC1sT1fMupQp75dEFBL4vjEl0gyZ5cMv8e/VXVkTFnACzYMADFFnYEIUW7Me3vxSc
	 3e+BYAyaEqTReMGpedv1kTZjQBnMY3mjhTVUynxRiOR3pdmGBY866Mwo17cVmQDFdH
	 e0uKVSmK7/mDX9uwSrAKwea1RIZJeVTFuYc5aKQoH5RJnV4c2B/JfnurcivxoUo5VM
	 1B0UJ7z0GKODw==
Message-ID: <2c1def7b-aceb-45c7-9cf0-8518ef26dff3@kernel.org>
Date: Thu, 24 Sep 2026 21:25:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix mlock2 errno handling and false PASS on
 ENOSYS
To: Park Tae-sun <ts930@dgu.ac.kr>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260923-selftests-mm-mlock2-fix-v1-1-750b627854c6@dgu.ac.kr>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260923-selftests-mm-mlock2-fix-v1-1-750b627854c6@dgu.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDE58A0006
X-Stat-Signature: rgqzwwngpj3qzdr7cg6ye8ch1sfbw4j6
X-HE-Tag: 1790277920-172332
X-HE-Meta: U2FsdGVkX18T/9HDYi0TXkWjSFHfPSHIaw5xktJncHWK3H3sVEZMCXCdrvqtTBajuFjvg+oIJWQ2N3JmIlkHgQ993fyEJIUCzH3DQCobC9E8pRF1YaADs+GoeEtOXFPwVYBrtRi+IeO2HARkyr9OzwveAwXIxbRbAHnTHR4UuEODGSyuOPRfqt0qovYjiNyy/jEh8L54vdcQK2KYr6XcZGkqOObNnCMmDEYYZYBc7KhVDP80MoqtA8SNHIxZjV6rsVjE65ua6UcyeKpsWCbbqMZzPhifO65jRQ2MNJMYbnCrQMpraeCkDCDgqLvfYWKSYAB5ciUpNlfvDRI/UavRioMDbYL5ZHIFerDXNZP9K4WBo9O2d+tXqcyRB1y/31adWA0p5zU3Nuh5ZqXs6ljhEExxNJ9MzNLedtI9zFuxAyY1f+Y03AourSgpPJ/LV/y2j3xdCG9i149BUs8bW6lu3yionKaf412+NjPyyaegM1NSqXAqrj9NzjV5FoNBR6PzVTE5sq2SRrxFTV86k5RG0GvpXXwJwRK0k/fk6qzjM5FzYGoYL8Q4HOEejuRzRdGIJ65DsjS+O2b2Gzi1VyB+tFfWz56X2s7B3L0+7BzbkyAc8kR53Zzx+j0K8o0CFJH9SAx8dhX2AatvDLCvOxnMesGpx7FMlK2dTXtyPhkI1UK/zevr+U/z3yZFdjalgxaaI6BKy9jIup/spy7n8rNX0MhDwVVfVnrT3IWxK85sFoV6R2lMKo9V/dHyG8oX/SwwG9Vr3zGhetB4ljJjDjz5Eqg0nbNIngat6uIiG/BHPINY5FY+v8fk0uORqxPh/Hp/44oIVn4fzmHNmdHMv+3d2XKwajvy+gm8b/q5xZuTwhO9mo5FVEA+su6/8cJ/MhA2BMXQT4T1uyxyClN/u7NO+KqO1BkBjyDKrEiY+t0xG0lj/Jw3mxZba2Er7h6+alJ/rpZiSzq7Oze+6YJlsak
 CKdoMK5B
 XZmUyPMb+xDveL3a7aOdbToOB9VbydOo7qkNdL7apwpar1+aWBZ7TwgwnQDDoYICZe+eds3UAIksM4nTVeGUe5R5fe5J6yrFTRlYqwci415VV3M5kY+uYZRB+FW8QhitIsoMXMU6BuLJg7+LZUWBNZ5LtQ6OVNSI3wDIaIClVKpNCP2pWoZpxZaYzwjpcvHUyzQU1hvPuhXmxbSkeTYfGaQjYLUTmF2Rii4SYtsKEBLMolOC22EOd8P8HfuWegBhjjz0C6OUSxxIQnCZSJSF2xedt7ORnHOIRsy6G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 11:26, Park Tae-sun wrote:
> While inspecting selftests/mm syscall wrappers, I noticed that mlock2_()
> in mlock2.h handles the syscall return value differently from other
> wrappers:
> 
>     int ret = syscall(__NR_mlock2, start, len, flags);
>     if (ret) {
>         errno = ret;
>         return -1;
>     }
> 
> Commit 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
> introduced this intending to make mlock2_() behave like libc by setting
> errno and returning -1. However, glibc syscall(2) already returns -1 on
> failure and sets positive errno. Assigning "errno = ret;" overwrites
> errno with -1.
> 
> To verify this, mlock2 was disabled in the kernel (via sys_ni_syscall) to
> return -ENOSYS. Testing revealed two interrelated defects:
> 
> 1. In the unmodified test, mlock2_() clobbered errno to -1. The check
>    "if (ret && errno == ENOSYS)" in main() was bypassed, resulting in an
>    immediate crash in the first test:
> 
>        ~ # ./mlock2-tests
>        TAP version 13
>        1..15
>        Bail out! mlock2(0): Unknown error -1
>        # Planned tests != run tests (15 != 0)
>        # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>        (exit code: 1 - FAIL)
> 
> 2. After restoring mlock2_() to directly return syscall(), errno correctly
>    retained ENOSYS (38), entering the ENOSYS check in main(). However, it
>    then called ksft_finished():
> 
>        ~ # ./mlock2-tests
>        TAP version 13
>        # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>        ~ # echo $?
>        0
> 
>    Because ksft_set_plan() had not been called yet (ksft_plan == 0) and
>    zero tests ran (ksft_pass == 0), ksft_finished() evaluated 0 == 0 as
>    success and exited with KSFT_PASS (code 0) without any TAP skip header.
> 
> Fix both issues by:
> 1. Returning the syscall() result directly in mlock2_() so that errno is
>    preserved.
> 2. Calling ksft_exit_skip() on ENOSYS so unsupported kernels report a TAP
>    skip ("1..0 # SKIP ...") and exit with KSFT_SKIP (code 4).
> 
> Verification on the mlock2-disabled kernel:
> 
>     ~ # ./mlock2-tests
>     TAP version 13
>     1..0 # SKIP mlock2() syscall is not supported
>     ~ # echo $?
>     4
> 
> Re-enabling mlock2 in the kernel confirmed all 15 tests pass cleanly:
> 
>     ~ # ./mlock2-tests
>     TAP version 13
>     1..15
>     ok 1 test_mlock_lock: Locked
>     ...
>     ok 15 test_mlockall_future_droppable: droppable memory not locked
>     # Totals: pass:15 fail:0 xfail:0 xpass:0 skip:0 error:0
>     ~ # echo $?
>     0
> 
> Fixes: 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
> Fixes: 65c89684896d ("selftests/mm: mlock2-tests: conform test to TAP format output")
> Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

