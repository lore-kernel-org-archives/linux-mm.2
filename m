Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10810F531CA
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5251D6B00C0; Mon, 13 Apr 2026 15:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6476B00C3; Mon, 13 Apr 2026 15:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5286B00C6; Mon, 13 Apr 2026 15:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7486B00C0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:46:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7C4AC1607
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:46:39 +0000 (UTC)
X-FDA: 84654564918.08.B665EB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 09C251C000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:46:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TSsCATRD;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776109598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4R5P84f35HKj4NysTJNdEqprfrc3frCNVCgj4g2IO0=;
	b=xUNa4iQ1vAcbX8XrWaxZGDszSPVmf82baxoUrBwPu3QnXJ38JGHv1FAqf6KBbUm+Zy3Fh8
	XopQ7T7tSK6zZz28Qpnn+c+ZKf3/a3THcbUvTynQUdOlO/vh5su02cVrnSzsqC6TTlaku/
	4aYLB4eCEgvS7ya5hJ2yPK4XybsJEqE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TSsCATRD;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776109598; a=rsa-sha256;
	cv=none;
	b=STPlnXByQQZTtH4ITXzFvhWGmYhGHx6keny0/kd3ED3OSKEXH4qEmABt/HP5EEsIkXqTRw
	FKwGezu+UmQMHlAdmrVUGThzwHRw63j5w7FfYLwaoQkMWIbpHsD3dPtBuqwJYdHZKYiGbx
	JThp9l1WTz0xOFcwj6NeK5qgvD4+HWA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D10061852;
	Mon, 13 Apr 2026 19:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1308BC2BCAF;
	Mon, 13 Apr 2026 19:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776109597;
	bh=T2uPJHzrQR0XgDHKdb4OzO4u+zGT9oN3ag93/9ogWoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TSsCATRDJ4fridOuRNVrWUpxBPPwilKYA/kq/0FCV85hBzkaH1THZRbhucv0Oe/wP
	 Yz9y7vLVGO96U78OTNei4kswboHAjs+1yADc3y0jmwpDOngbycOkXSAVPtAYc4Y6K8
	 /EysUG12vgoPjUFKQqd6m80x0SRz7My2B8zeeLQ02p8vdT37G7heqE5G0LqxS3aFb2
	 K29/z9I+3qASD0wNk//hFAj1ZuzMSvPv4HR8E2xv/oO+Q1rgq2isj2eZX0J8I5V1Zx
	 WEifqt7YBC9PYbJL4e9apcC5P7dfbBl6mBQPiwjIi7qHQjnBil7wxRhYw4WPwvmKPh
	 D1Q5zeTuhv3wA==
Message-ID: <b579517c-e739-4db5-ab0b-4db3d579807c@kernel.org>
Date: Mon, 13 Apr 2026 21:46:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] selftests/mm: verify droppable mappings cannot be
 locked
To: anthony.yznaga@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260409234915.11723-1-anthony.yznaga@oracle.com>
 <20260409234915.11723-3-anthony.yznaga@oracle.com>
 <7a318c3c-7ccb-4f95-a416-19d09f42c97f@kernel.org>
 <38fd3d86-f080-4b3a-a931-8ddae1a420ae@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <38fd3d86-f080-4b3a-a931-8ddae1a420ae@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 09C251C000A
X-Stat-Signature: 5rtgrgk1pspucbpct7y3qhh1733rwxfm
X-Rspamd-Server: rspam06
X-HE-Tag: 1776109597-822766
X-HE-Meta: U2FsdGVkX1/LSUogbbOiAPx0eEpc6fzkHo05cdV5tCqyLIytC3FIRFF+nViVv1Gj3+2elHI7+69ER69oZl1n1+bi6NAC0yC/bawFFBrhyljLXwtfP1XGbTNKTdpomxQO2i3SS5tHnEh1vLaDUUmh95f27xuoAJprNmaS/zhAJAfiqsMEgbS84ccqJCTYEXvxRLdNqHaBO7d3QxjWHQyFDpjbVO7zkbHUqjcRu9LpK6KSbhNlcvdDDM6aQFWEMIOLyC1dvjn16rHEm7+IcG0zgYqqrwnNX/L4XYbepA3W9SVcwEDMNjV0xF7gU8HHxsv2kTggt+ecTJZr/Mu0eSX/nAlPu3vEXgzOWCN7p4Bt7vs7uOSniyUtTmhotPe0HLVJUk9Sx+4sq3OIbTNYdms4RcH8w20i1Hp5UVBgDIdZFAKwKPQMZGtBQmg5J9lP8RkpwFSz6WFCYx12PNP3EsvhSGhp34UhtKXxWt4BSGO36wY7WsBPfZWIC3s4Q3NdAWT8Zb4WWrvV0TJkaWqBHcgvo+EikxOYsJMTHRh1aS5DLcifOk9lf7EY/zJAvv/bHY6WG0rRgR76g505IzQzcHh5bYkLvE+7fjSeTWv8rN74iyTi7ZPUZG0EvzaS0huXK8r4AF8nrA/AsLIEK8gbL8GfhVBMAVmtKVzRzpz5VDEfRuMRo3kGCcn3dz85iH9gFEAyhyf4CtdsiDXzZKXRvP8a1v7Ka0jLi7bpoQ3faXd4NOZunV3uAeszXAzF6Yq64LPKx4dKlT1t0nldpu/r/6NX0DVPRrrQ11njXi0E7QlkWW2MvocGPVPN65RViWKi/AAq6BwtR2SeSijQvse2slh2SYnEuGR1Br786l5G+IG4DBX3/na08NzJlBnYr+vPEuCU7+0lGd1PJILI3G9FgSaVp3Gb4h+egmVHNalqbllMYamikc8QwrDTI8vxitPPo0PaPRkZnjZ/IMf1TJiZRg/
 6UP4CO3l
 0KSqpVwPK6Wuq6UbsgZsiZJgKWXACn50pdLzYuHCOZYDKHDV0MfvxiPkmN4LeuwnHVkBzY97KPdyM5mHCMIl53gMwR+ZXSWXI2utPVzCMiroGWJxYQgTobA3NleouE3mZOMnjilvuu7wFuiZsnlHQM0nN3+DpFkL7Bkz+GDj1r4AeUtwIQrgsxteTNXmtaZr0PsT91J+3sV4ehzJIH9hLB7cg1M7VwRogK3GG3yUsVeGtkRpNkQSQk9N2/cEEc3rjvJcylGNm1mDqyJSZFLre1yv9G06yJaOc3NSkIUNZ16+2aTe+s64vQN1+aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>>> +    if (munlockall()) {
>>> +        ksft_test_result_fail("munlockall() %s\n", strerror(errno));
>>> +        return;
>>> +    }
>>> +
>>> +    map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
>>> +           MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
>>> +    if (map == MAP_FAILED) {
>>> +        if (errno == EOPNOTSUPP)
>>> +            ksft_test_result_skip("%s: MAP_DROPPABLE not
>>> supported\n", __func__);
>>> +        else
>>> +            ksft_test_result_fail("mmap error: %s\n", strerror(errno));
>>> +        return;
>>> +    }
>>> +
>>> +    if (mlock2_(map, 2 * page_size, 0))
>> Weird, is "mlock2_" actually correct? (not "mlock2") ?
> 
> It's correct though mlock2 would also work since it's been in glibc for
> several years now. I just matched the existing tests. mlock2_ is a
> simple wrapper around syscall in tools/testing/selftests/mm/mlock2.h,
> and it was introduced when the mlock2 syscall was introduced. A trailing
> rather than a preceding underscore is...unfortunate.

Interesting ... and confusing :)

> 
> 
>>
>>> +        ksft_test_result_fail("mlock2(0): %s\n", strerror(errno));
>>> +    else
>>> +        ksft_test_result(!unlock_lock_check(map, false),
>>> +                "%s: droppable memory not locked\n", __func__);
>>> +
>>> +    munmap(map, 2 * page_size);
>>> +}
>>> +
>>> +static void test_mlockall_future_droppable(void)
>>> +{
>>> +    char *map;
>>> +    unsigned long page_size = getpagesize();
>>> +
>>> +    if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
>>> +        ksft_test_result_fail("mlockall(MCL_CURRENT | MCL_FUTURE):
>>> %s\n", strerror(errno));
>>> +        return;
>>> +    }
>>> +
>>> +    map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
>>> +           MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
>>> +
>>> +    if (map == MAP_FAILED) {
>>> +        if (errno == EOPNOTSUPP)
>>> +            ksft_test_result_skip("%s: MAP_DROPPABLE not
>>> supported\n", __func__);
>>> +        else
>>> +            ksft_test_result_fail("mmap error: %s\n", strerror(errno));
>>> +        munlockall();
>>> +        return;
>>> +    }
>>> +
>>> +    ksft_test_result(!unlock_lock_check(map, false), "%s: droppable
>>> memory not locked\n",
>>> +            __func__);
>>> +
>>> +    munlockall();
>>>       munmap(map, 2 * page_size);
>>>   }
>>> +#else
>>> +static void test_mlock_droppable(void)
>>> +{
>>> +    ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n",
>>> __func__);
>>> +}
>>> +
>>> +static void test_mlockall_future_droppable(void)
>>> +{
>>> +    ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n",
>>> __func__);
>>> +}
>>> +#endif /* MAP_DROPPABLE */
>>>   
>> Why not a above a
>>
>> #ifndef MAP_DROPPABLE
>> #define MAP_DROPPABLE    0x08
>> #endif
>>
>> instead?
> 
> The intent was to skip the tests if compiled with headers where
> MAP_DROPPABLE isn't defined rather than force the value and get EINVAL
> because the kernel doesn't know about it. This way EINVAL can be flagged
> as a test failure and not skipped since it would likely indicate a test
> or kernel bug.

Note that the kernel headers you are compiling against don't imply
anything about the kernel that is actually running! So the argument
regarding EINVAL doesn't really hold.

But note that we, in general, try to compile against the in-tree headers.

See

commit 75d60eb30daafb966db0e45f38e4cdeb5e5ed79c
Author: Lorenzo Stoakes <ljs@kernel.org>
Date:   Mon Oct 28 14:13:30 2024 +0000

    tools: testing: update tools UAPI header for mman-common.h

    Import the new MADV_GUARD_INSTALL/REMOVE madvise flags.

And looking into it, I already see MAP_DROPPABLE there as well, so is
any special handling here even needed?

-- 
Cheers,

David

