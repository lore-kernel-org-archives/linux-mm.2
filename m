Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BF12606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=SNU828+O
Received: by kanga.kvack.org (Postfix)
	id BE53B6B05B2; Thu, 29 Oct 2026 07:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B971E6B05B3; Thu, 29 Oct 2026 07:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4056B05B4; Thu, 29 Oct 2026 07:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87B746B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:33:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 148641C37EE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:33:59 +0000 (UTC)
X-FDA: 85375454598.16.F59F286
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id B517F18000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:33:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SNU828+O;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793273637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFBCu+YdzwIUEcYKGRG11Fp0ZZOhUTu2QED4Ky6DRFk=;
	b=vFMnXkELdcUcRYE3H+NKgqrfu9KmpaMSlFgWM222pYZKHRWV5k8PSyek2yZLch8mYfpRqs
	VlB2IsMtalrYfSkng0DuxO2r1Z6knVMa7ScXWtaHcEb6QLm9f6lUpugi6ll7mw/vrMtqrI
	dc/2PlaImzvzInZVrUAJaQJ7WmQnspI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SNU828+O;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793273637;
	b=f7J7qgMFaQWROaKsoQhuHuCJKOsEpgkvudljb3eOrOZJdQh0N2ZmGpT8+bxtxT8RXNArQK
	dE1lDTHKMxSTsHR/QwLoeRGUha5kpgQ0N1aeA0oEQUWOLdO2yuykMxbXg0NEPoEZo0EC7B
	HBlaDU36LTNM+B0TSj7ZYXz8YUExMYE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793273626; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wFBCu+YdzwIUEcYKGRG11Fp0ZZOhUTu2QED4Ky6DRFk=;
 b=SNU828+ONqWhAEgsW3dWYHT8vSOIYdYk0B/sxMZtRG/I66U5pIznJieA51RKbVa0OfKXOi
 6EmWB4lSolufwNm8Y/ZCoQA2/+z7jOilK7tRsZdPHLuS5av+7kVuwYWFbWFeUWsyitdgFR
 EGpRVC4IDwrxB+TOuRZLA/niaur9H0UD7wm1zM6sQV0LFNUUyAj5+mbTli2Q1TMC6fRTBV
 JAMFbRgDozNu4ZEnZsWAskHAIIfgWaREmIXB4Aph6VIZHEhxC/Toc1Y7mxdxL9bd4vuqwF
 l5B5h1W57DfRKram+RGdtP4UXAxjeDCkd34KgjbxHKNAHq2UqbIsh4D/CDR53g==
To: "Bharata B Rao" <bharata@amd.com>, <akpm@linux-foundation.org>, 
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <rostedt@goodmis.org>, 
	<vincent.guittot@linaro.org>, <vschneid@redhat.com>, <ziy@nvidia.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion bypass configurable
Message-Id: <1bab234e-8914-4694-b0aa-f265fa49c6d3@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-2-lizhe.67@bytedance.com> <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com> <010b2b6c-8f1b-4c3b-913f-cc2e8b957759@bytedance.com> <a6bcd771-fcf7-4fe4-8c21-5e65bd579de7@amd.com>
X-Lms-Return-Path: <lba+26ae32f19+feec12+kvack.org+lizhe.67@bytedance.com>
Date: Thu, 29 Oct 2026 19:33:22 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <a6bcd771-fcf7-4fe4-8c21-5e65bd579de7@amd.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B517F18000C
X-Stat-Signature: ccyh4gbu73m3ps3479fei6trnaoiabt7
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793273635-367139
X-HE-Meta: U2FsdGVkX1/aKFcnEyczqgOVHyS9/h+TN6UkEgRlXDcbdD9Fo4P9hLSsRUEBw19imslYPJdZih5lN3xHi0g00e8OXI8v06UhcwCuuQHg4q40Fh+utD1Ru9feo4CmKqzG8jh40wSy9iL14eRo2zcXWDvpCeleLBrJSyiwvwEwDmx23pHQ/3iYlO+bPG/wX3jKG7ZJDU+VJR23Xf/CVVYIyg5IdWZp+sFsSeU/T+NyI/xDHy8pifDoA1nHhkG0Dcg1wUv+DW/87xGv2i1Un+eR/9pZiAshd3hwNTMQMAXALx1mrCxNyxp1E3bm28ep6iEeKit/KV41ULWW01/vOvZXneYeQUPB6N+NZsFpFyG88cuOSSgaIIEivW74ohx/fKwY8eBdeIHGIvD/j2RpHsFBfUFG1Yw5QmdDyNsB/kQRn9y+20d5v0G9N6+xLqobuuWhSGNi9yOxCWubY4BGvvWgh4K+8AvO4FNvL1juBTmif4vDJj8yRHNHy9uDUOi5/vkVa3sEGV5nPLdem9vRGA9cVR7x4gGvnAInGiVX9eBZU9HIqziqCWWXu5PRPLrprwiSEVEdP3QGXs/krQDhU5h8VxFT+EgOTmxW5L1KR3Nik+Mzhx8zVSS7W+gt1oIS1w/XfZokDbmhoxp3WtPSl+97Zj1lmTvuht4HtAp9zgpKhiFBwbMqC//9vUVKCfzWDGo+wamvjGp1MfIdAfhVS3KNIa6tBdpLTv+LAs2ss9P27Vb9gB9WPY4g/unHHs3Bt5sDoUZvRYD1PEx+4jNw5MBU1nMJfYf1EXp1vyMXXJJSjAneEtWUgGcU2Er1Mc0kRKLP5J/uHHauBAT91PglATCy/Irx1xKeCe+FYK9dMbAil5QyztoNbSLoIUX4rx54vpizy8556BZJdcAyP3kJcO8ZAUfs+zHR7egqbJlihdYaGwFFLRi0tod0CLC8zkCoz77OONhcJOYf/aS1WU/lJnQ
 jVx58++7
 WiGaeE7ZJkjm19jmbPBfEUS3zueCiSn/a8MZ0nLZ6gBzOGIdoqFN3z+sqHgcrwo+gKOToJ/hwrrBxAOQv7EQIlrRb5p3MA/Y0IKwzMWDRGWqOlnSRfU2z0yuXepNkzk8XvI2QuXZnn9Ur3CJTVXZWkwtTfNa5E6QdFxzs9fWJuXaUjXD3CYc98mgw62gWrqO8qkM6a2djLMT2G0xaP4pbIFCmCZHa9hnfCrdlgNn9cibQmMmT1+4fFXdvOuYbV6/FVHlO4xPsmmLaaWAtVeEHjBSOSNkzKO57XLyMqDGKEqE6yIDbpQVPMoCBqDifdsPFFIq7TYizHqoDqQPeJQ5MOFUWjxqf5WwvkIvOyVDqUQ8yeP6oot6BY8NsWGQUjzh4TWpyKF/CvRcEf1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 6:22 PM, Bharata B Rao wrote:
> On 29-Oct-26 3:16 PM, Li Zhe wrote:
>> [You don't often get email from lizhe.67@bytedance.com. Learn why this i=
s important at https://aka.ms/LearnAboutSenderIdentification ]
>>
>> On 10/29/26 5:34 PM, Bharata B Rao wrote:
>>> On 28-Oct-26 9:42 AM, Li Zhe wrote:
>>>> Memory tiering normally promotes any recently accessed slow-tier page =
if
>>>> the target fast-tier node has enough free space. This preserves the
>>>> existing policy of filling available fast memory before relying on
>>>> hotness and rate-limit control.
>>>>
>>>> That is not always the desired policy. Some deployments may intentiona=
lly
>>>> keep part of a workload's memory on CXL-attached memory, for example t=
o
>>>> preserve a desired DRAM/CXL capacity split or bandwidth distribution. =
With
>>>> the free-space bypass, short cold accesses and bursts of hot accesses =
can
>>>> refill the fast tier and pull the workload away from that distribution
>>>> whenever DRAM has free space.
>>>>
>>>> Redis testing exercises this policy issue. On a CXL system with node0 =
as
>>>> DRAM and node3 as slow-tier memory, a Redis test was run with
>>>> memory-tiering-only mode enabled. The test used a Redis dataset with 1=
2
>>>> million 4KB values. It reclaimed memory until about 85% of Redis
>>>> anonymous memory was on node3, used a Redis benchmark configuration wi=
th
>>>> a 10% hot-key working set, and then issued a short 256MB access burst =
to
>>>> cold keys outside that working set. The cold-key burst mainly touches
>>>> memory outside the hot working set, which is expected to remain mostly=
 on
>>>> the slow tier.
>>> Can you please clarify if 85% of redis memory ended up on lower tier na=
turally
>>> due to overflow from toptier? I ask this question because, if it is a n=
atural
>>> overflow/demotion, then it will be hard to find head room in the toptie=
r to
>>> allow promotions that bypass hotness or rate limit checks."
>>
>> It was not a natural overflow from a full top tier.
> Thanks for confirming this.
>
>> The test intentionally reclaimed/demoted Redis memory to the lower tier
>> to model a deployment that keeps only a limited fraction of the workload
>> in DRAM and leaves the rest on CXL memory.  In that setup the top tier c=
an
>> still have enough free space, so the current free-space bypass can promo=
te
>> short cold accesses back to DRAM.
> With pghot, I have been providing benchmark numbers from two scenarios:
>
> 1. Non-overcommitted case: The workload memory is pushed to lower tier be=
fore
> the measurement phase begins, the toptier has enough memory to accept the
> the incoming promotions.
>
> 2. Overcommitted case: The workload memory naturally overflows/demotes in=
to
> the lower tier and every promotion undergoes the hotness + ratelimiting c=
heck.
>
> I gather that your measurement technique is similar to case 1 above.
>
> The feedback I have received for pghot is this: Non-overcommitted case is=
 not
> the right methodology to use but the natural spillover is. Hence I am not=
 sure
> if optimizing the free-space bypass case would benefit any naturally run
> cases.


Thanks for sharing this feedback.

Yes, the case I am trying to cover is closer to the non-overcommitted
case.=C2=A0 We do have deployments where memory is intentionally placed acr=
oss
DRAM and CXL memory, instead of relying only on natural spillover from a
full top tier.

For example, the orchestration layer may want a cgroup to use a planned
DRAM/CXL ratio, so that DRAM capacity remains available for later
placement decisions or other workloads.

In such setups, the top tier can still have free space, but we may not
want short cold accesses to refill it simply because the free-space
bypass is available.=C2=A0 The intent of this patch is to let those
deployments keep using the existing hotness and rate-limit checks even
when there is top-tier headroom.

Thanks,
Zhe

>
> Regards,
> Bharata.

