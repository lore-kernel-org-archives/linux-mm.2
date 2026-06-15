Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DDFCD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0936B00A8; Mon, 15 Jun 2026 07:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99FE26B00AA; Mon, 15 Jun 2026 07:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B63E6B00AB; Mon, 15 Jun 2026 07:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78B2A6B00A8
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:08:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C2C01A09EE
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:08:24 +0000 (UTC)
X-FDA: 84881873328.11.079F878
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 99EAC140004
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:08:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KukOqma5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIUp5vWqdwmbl/9QaibPZwFu1ibRd3NRISMKrd1mQUs=;
	b=lFp0aJ7PaOoV+glmcN5mBcnU0dc0eEKwyu7GNGd73IxlyyRs7fkAAqxVqSUBV38q+xHMVq
	sEXyCpA5Trqva8w4FvaIkiOfDEQpKzV56rVtJXHKt7mvzN7la8d/NlCCjjqrOlXbkB8Z5G
	Iaf54wxyrON87U6WwUubz06pG3AjX1g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KukOqma5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521702;
	b=jVOPXijjC3kIOMe6v1fA2LCesmv1EgAFUnIzkWXQKY4j2Q1LAWhKaiYGVoZVEYlZ/4B9N2
	WrLNZPKIMZHNeV3/Ngolgb5eNlKEHs/Ca8WMfw8+GzCzM1+xcVa43fBoPFhddkjKbFo3dD
	hzAbXM3gF/c3aTTOWBz+7nRS6MyhR8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31CE96008A;
	Mon, 15 Jun 2026 11:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D1D1F000E9;
	Mon, 15 Jun 2026 11:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521701;
	bh=RIUp5vWqdwmbl/9QaibPZwFu1ibRd3NRISMKrd1mQUs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KukOqma5oU78wHocXEMOB2C3meoqCN9qVUAmBuHpOYbPa1W5lJXyz4jBph1wca+/+
	 EIi4evOjLPYjh+lzE9XwByrE3EEuQYdjrCBxiRoSY+T6uDQbAfYXE3Fff634b8EFa3
	 4eeqW3IQY3lw+9RJw99pGheVqXPAMgMIqIjsOliOsQboqN7rUYlOsvDEfau7zyfesJ
	 ZzFoJitqUB7U1p27fsq+YPN8vxiwf9cckV+OeS2ikYQkSbQc2AJU1CQlHdA9OwC01k
	 BQnGTBy+FWLnkyWa+d42BccbE8sv8EgUhKdxEE5eTEg2G3ERQ0E37m1kZGigTVbPCN
	 2aXtF5sVsE87w==
Message-ID: <ec4b4b70-dc01-41fc-ad58-e1c877f6a7eb@kernel.org>
Date: Mon, 15 Jun 2026 13:08:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
To: Gregory Price <gourry@gourry.net>
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Waiman Long <longman@redhat.com>,
 Farhad Alemi <falemi@asu.edu>, Yury Norov <ynorov@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
 <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
 <ai_IHvyptWPcTD0y@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ai_IHvyptWPcTD0y@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jpsrzfrptu3pj556chjesu4s51xgumpm
X-Rspamd-Queue-Id: 99EAC140004
X-HE-Tag: 1781521702-430833
X-HE-Meta: U2FsdGVkX19GmcsjkaMgUZRmMCqT75noNJWUgcivulr8U4hS1vxYpr6LINx01OmvRf6y7CMT7j9ykyVIoEtBimnQF6XFUbTzKxz56mJybvbqkdcETprxa1AzlvfMxqiDAfZaWU3fJY57rg2r/Ec/VqNTvo3/ubz14623lUbq1EgOHgCj1Y/UDyTZTuKly8YbAAn9DJHSqqoRyg06dWmkE7A2WONj9/OGc7sZ7jtQxZioohSyTo2mFwUzhHa8pRCPqFmSUx28Qvi6wATGGzBPxUaQsQgbbN4atATw+vNsl4JAXVQZBq6nxcLTuXAPngyZuONKsAXpvLNZCjb95/0EsCAs7apAcf/rDPzGk1KupYGY07wzNlPEH3cVx4bKKRTLC2UN6zw1BRcpvx+7yLbUaCizXmhj55l2zEjd3+uomRMPLv2bhVp41tYKOQfVUZi50LFv83Sp0NDvR0cetVecaLAobYF0723EOg1mke5bM3glf+EvvKngMgfYcAjb/mAU+YtEQNSXoa9sGTfWkYl6tGJkohSBMwrvNlp9Ivvi2aCIENsUQoCZZ9FZaXrbo73om1R2DCJl0H54R4NZFdsEGPixjTXmpGQ/S3iUUT0uFKpNxelEEtYceZuTeYEIsJuU9Ol3mexsdDLqsLs0UquZW581pRxY8PSOGcJPNpaC41rESjoynF4lBmr+DFcsehZnw10+oObaF/wB1RPtD+auoqYTVPYwm7PpDN0cxuq3G6DNEK/pl/vW1zx7rSGkchFsSAT9hs9gP1MQGvRs3Df6HxDnpOlk4txtVudVtaSv4m4ZN5v1wCsNEzG+CVN1Gvv3F6ev7I1Ne8ZaehvLshoSxXlSFYxG6i9HCNerSgAIevMP2MWtYdyMQG2mCD9qvQR1IDEklokXWjOT3VvbhKmgvytMGidGoic0yoak0QWjUbEitxeT3vs5bclAxilAybW86EiW2+KJ038HAmaYe5B
 nJj963vy
 e7xYbDfmC6BRQ57SXhgIRFS886naXNPPE392r0iYKmSTG/y9nPFMiDgtIGJh1G9eNuJn18W67XVcGn+HNv7CV5O2bqrzPLfajPEg4+BnYFdwrn+6nsaLAHX5GhBbObB9oCEjSdwGHyb83usaSpg98MtKFmgMztGN9/GWkIaZKbQGS0ZoME7uyL1uMAbhV9CTLBD9CDg8crM78caVQcSUWlI+5NzjZOtlk8J+pH4xanKZNmUGgplYoO+hr2SSZfJnBA8yaXyjQsYYZjQSuZoPtGQljUvCb+3HMw9E063UJVxuUBZki/3+0qe3L5WHR6oTnLPEV2KR3y7Nks/ldNHBM4gCD6xQc3Gfk3Cq47+c3yw1nmBrTH+bhBK9Ze+aF9v4HZk3z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 11:38, Gregory Price wrote:
> On Mon, Jun 15, 2026 at 10:08:51AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/14/26 15:25, Farhad Alemi wrote:
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
>>>
>>>  		migrate = is_memory_migrate(cs);
>>>
>>> -		mpol_rebind_mm(mm, &cs->mems_allowed);
>>> +		mpol_rebind_mm(mm, &cs->effective_mems);
>>
>> God this is confusing.
>>
> 
> All interactions between mempolicy and cpuset are horrible and
> confusing.  Much like Lorenzo's anon_vma work, I have to keep
> notes on how this whole thing doesn't just spew SIGBUS constantly.
> 
> The short answer is: mempolicy is advisory and cpuset is strictly
> followed - in a dispute cpuset wins... except for file backed memory,
> then everyon loses and nothing is consistent.
> 
>> Naturally I wonder: Why are we not using "task->mems_allowed" (maybe cs vs. tsk
>> was the original bug?), which is effectively just newmems?
>>
> 
> Short answer: task->mems_allowed is protected by the task lock and we
> don't hold the task lock for a foreign task (not-current) over mm
> operations.

Well, we can just use newmems, which cannot change? Again, that is based on
cs->effective_mems but is guaranteed to return something non-empty.

AI was not able to convince me (neither was I able to convince AI) that there is
not some obscure cgroup v1 scenario where the current fix would also be wrong.

With newmems it's clear that it is guaranteed to not be empty.

-- 
Cheers,

David

