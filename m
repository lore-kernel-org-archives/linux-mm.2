Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C743CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9868E6B011A; Mon, 19 Oct 2026 00:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937A36B011B; Mon, 19 Oct 2026 00:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D9F6B011C; Mon, 19 Oct 2026 00:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56FF36B011A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:49:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD20E120421
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:49:08 +0000 (UTC)
X-FDA: 85338146376.25.D886DE6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9CB36180002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:49:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Mod5dmx4;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792385347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzSOmacPqNQprQe2LTkZuDJfdNlgHZO8T/fGbyLS930=;
	b=b6HNg+XLXWveFAMcN6G00GN0dxiiOwmIwjDeMSCSpbWUAIgw+K8b1Vg/feo1F5/HMMuq79
	Q1GxSmk6yFFaRpnsSILgOO4lUNtS8PpCUirPdYM6YfLG00kRyV5AoTPeSdKdyz/mh9j+YS
	jDLiVQ61IbZivbYcemKNJjRE+XjcO4s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Mod5dmx4;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792385347;
	b=wb5TwPurNsaS1zYdC+XEyAbahXdYv1zicA1mCMcZcSSLDcuB591bvFqzMTlH7gLLBdB/fP
	dzQ1hOBQYpx0MfGFZDKn2EhtkwbhAippTX6WjB7OPjygwzsq6k/oeQCLrUTnldZwVF0J22
	dMP1FDmFJY6y5+HeRd41iLlUQVc1aMo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 480CA1476;
	Sun, 18 Oct 2026 21:49:02 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E4513F673;
	Sun, 18 Oct 2026 21:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792385345; bh=si7QsQnsH09mNJsPLKAXHcWxuGvdCBwgZF+8vn9kW/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mod5dmx4zAhvQZJluv51WnM0iAhgYxZE3XO6/39Mp14IHn9gbJTDXu5FzUzpKMBPp
	 ShmIFc7VCfiJd5rhnBIp8bKandPFZpCAC+ULCS9WHgaNJsXcH7PHKahVPy3FcqHSvd
	 r0uvqM4bLS6LAz386V0ecFiIfMEJipEyq5fH7Zzw=
Message-ID: <f74f6e87-1a6e-4b45-934b-d13fdb0c6ddc@arm.com>
Date: Mon, 19 Oct 2026 10:18:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] selftests/mm: check MADV_COLD and MADV_PAGEOUT range
 handling
To: Gregory Price <gourry@gourry.net>
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-4-gourry@gourry.net>
 <73c55ce6-67a5-471d-811c-facf712b2fe9@arm.com>
 <atIkDw9r6CVDJaG7@gourry-fedora-PF4VCD3F>
 <atIvbzEGUcyCqdC7@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <atIvbzEGUcyCqdC7@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hetryy8pm4h4pry1m1cixezsgfijytpp
X-Rspamd-Queue-Id: 9CB36180002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792385346-315560
X-HE-Meta: U2FsdGVkX1/eF/2EfYgh1ExiD8sx3EXhA3vxjeFE8+xZMOnJ/wRl+GHLI1uyCuGZb9xvG9rIZN4SR7TwvJDROGoGTQWQokdWywMONthLEm0ZoT+mxnQkQF9J+Rafp9V2prfaq24zK0fBpTVrpdMoGt0mk9uoA9+sBERX+AqxnTNhOHbJRLxgALasH+sDmDzcwWQnz/gDjtEXPUsGCrQGpJSHrSXppaYFXb3tI67IIPFj3P6aWmoWlTaLwk4cllWW5PnwAl8TRk/t0ZicNWsysz/Wl5I+fl9BIsVV0Asz/knyHouSFQh1gjOPbRHJ+pYe16zs/xlpJJhnKyRRdLGy2d4JU50GxKuiHyDjpt7t+WSux8zvpIbfPF+7NZcQ3iXRYlVtAx65fvMCmBgpjG0sDbMnF4zQlQOHQk3A5oY0ZgcevGh94jZichBOQdfYzQ4KqLs+zqEJaRG9w+Nd8s3Nv1GzIRZ9wMFGJNytu+XvqeSSbPXnioX7BqZT+idiPfyV4SPTo/ynM1fCIXp56YSJK9ip4DZnGcElgp9jX3k6Ypj2r1YIpTx29wP2GIl00Hedp2ouRoQuyRrzDtHWa+KOnuoORdoVztewtKZboM8E32TxlC9SH6/BYbL2swnDFA79UiRaiH/rOhAh87VYNy72SQa1nBo8i4qHLxs+iHe/d6hjpn405oeSrQgDfBpEeCvrnaUsQLRDZvQIdx+GHq2NNs3a8NyV8FO60CC9oP+x3nG/4hA/uQuPwqfPGstHiJg+i+9/YBoEzV9GSzZrWh3tsIuVcIdRhFbFOCHktqvFYHUYa4Tzr7TQinP7zBha4sVxUNERwZrFUhai9d19FUNVEGGGwMQqx0nNO4VWaUu4Qjm1cXFAmVPScnuTVfbMrt/oCaOiYDXLrYh44+Asog0GH39y3Rse98M2NX4PjVlFbyoCly1wUx+cbHpGwZokuyBKhGsDFTl2Y0HF7HiBut3
 dWA23y+Z
 +4PtLD9tpOKTPBKvgexR0pzNZPMpXYj+Ij6b00gHOSX2S2qt/k59aieAtJ7wcTxFbZLvd3Fk2XDkD2ETAiD7AK3IcYS/bhPCvod91nG4qxPShN8u+H2e9oDSiQcf1YtJs1HKvUd6k/n2tDUYkP02ZQ0Ug27XA3oJJqt8LSxJd8+9lnP15sE9iUtss+ZQjZJsowqSs6Hpw8jonRPWmxM1TPUDj00Wca2nhYwF3tiqyut1AjYjqK8I3ihIQ1Xa3qcHb3cVfupYdHZaxERmMy5PWJQFTe2ezxMYXeeJI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/16/26 7:37 PM, Gregory Price wrote:
> On Fri, Oct 16, 2026 at 09:22:54AM -0400, Gregory Price wrote:
>> On Fri, Oct 16, 2026 at 05:47:57PM +0530, Sarthak Sharma wrote:
>>>> +/*
>>>> + * An unmapped gap in the range makes either hint fail with ENOMEM, after
>>>> + * advising the mapped pages on both sides of the gap. Only MADV_PAGEOUT has
>>>> + * an effect on those pages that the test can observe.
>>>> + */
>>>> +TEST_F(madvise, unmapped_gap_fails_after_advising)
>>>> +{
>>>> +	char *mapping, *control;
>>>> +	bool swapped = false;
>>>> +	int retry;
>>>> +
>>>> +	pin_to_current_cpu(_metadata);
>>>> +
>>>> +	/* Make sure MADV_PAGEOUT can swap at all before relying on it. */
>>>> +	control = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
>>>> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>>> +	ASSERT_NE(control, MAP_FAILED);
>>>> +	control[0] = 1;
>>>> +	if (!pageout_until_swapped(_metadata, control, page_size,
>>>> +				   self->pagemap_fd))
>>>> +		SKIP(return, "MADV_PAGEOUT did not swap the page");
>>>
>>> This test is checking for both MADV_COLD and MADV_PAGEOUT. So if we skip
>>> here because we couldn't pageout, then we don't test for MADV_COLD
>>> behaviour at all. Do we want it this way, or should the tests for both
>>> of these be separate?
>>>
>>
>> If swap is off, the behavior of COLD and PAGEOUT look pretty much the
>> same, and we can't actually test them meaningfully.
>>
>> We check that madvise(COLD) returns -1, but that's also largely
>> meaningless if this initial pageout_until_swapped() call fails.
>>
>> At least that's my thought.  If you think I should split it, I can.
>>
> 
> on second look, i will just move the cold checks above the rest, since
> they're mostly checking failure paths.  those are mostly unchanging
> regardless of swap status.
> 
> so basically no need to split, just a mild reorder.

Yes that would cover MADV_COLD testing even when we can't swap.

Just thinking out here. Say if MADV_COLD fails, do we lose out on
MADV_PAGEOUT coverage in that case? Or is it meaningless to test for
pageout if MADV_COLD fails?

Also, say MADV_COLD passes, but we can't swap, then the test will report
a SKIP. We know that if it reaches a skip, then MADV_COLD must have
passed, but the ksft counters won't report that. So I would still prefer
separate tests from a test reporting POV, but I don't insist strongly,
it's upto you :)

> 
> ~Gregory


