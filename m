Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0486310F3DCD
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364936B0095; Mon, 30 Mar 2026 10:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE2C6B0099; Mon, 30 Mar 2026 10:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119CF6B0096; Mon, 30 Mar 2026 10:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED4EC6B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:06:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 971E78C2C4
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:06:49 +0000 (UTC)
X-FDA: 84602905338.09.848A8FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1EF810001A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:06:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VjF61byP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774879607; a=rsa-sha256;
	cv=none;
	b=oVQGkluheVcy1yMUTWM3v64Q4nHOIcYYpy9NL7oIrS+08tg7gKAdrD8oDCD/+Qd7/U50/h
	QvBLKlhAY7cQDC6tLpu3enccaZ8xjjuF7jPIbqY0ojZGGMRM7qipCFFke5PYDjlDyZYxNZ
	OSWPTwbWqIuR9HznBwOHZLl6u6n9+qM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VjF61byP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774879607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLam9CqhPAxt1VA0lcL0GTfwWBkG/lHpjmnoZERjlE0=;
	b=x51XbrmZNI2SoN6IZTHJsEph8XRiQSZydbg7DKrYY+VqYbu7JPYL6vlFy2zrJH46ctqznZ
	xvL/ZG1gY71oshnZbm3EtFMbQAN7gvYJ8bN95Swi+pR3ar5n7xLeBqUSv1SnLA8ViYvNTu
	Ges6PJknQYtkn2mpI4fkDVCOlTQgrQI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3716D600AE;
	Mon, 30 Mar 2026 14:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE23EC2BCB1;
	Mon, 30 Mar 2026 14:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774879606;
	bh=Jdvssgs4SUj8FpK4EW+j0eGP5POHJYlB3JEjjf7pwKE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VjF61byPNpNACgloARyQCdxaU3bR64V0AyqlD82R4yHO1rdr7/SMbsxbtKG7Lu1kg
	 UnfTLrtU6/1UpVjaJfLtDp50xvBDSS1wR2dzLsj9Pm4EWEZ+hCWf7+Ux/DsdjRD5zt
	 azrsAe71VXV8rDfn+7fg9i7b+avTXd9MVPtG/aIIfN7Iax59QHFcg8GXPG1z9qyzi2
	 Yallxw8K9Amiqoc/YHw3RtavFx1BgBX0mEUAVjiBlKbWcN9sV+yRKw4y/+HuAvxGrE
	 lctNJR8q1xAPO/bo//1vyD7q4dHy/Ml86Gjz2xUS1kAynHfLirFNGHnQCsbPqg0RqX
	 daZe/aWslLjRg==
Message-ID: <46a4a778-1ae8-44a5-b0cb-1b2c810d2683@kernel.org>
Date: Mon, 30 Mar 2026 16:06:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch] mm, page_alloc: reintroduce page allocation stall warning
To: Andrew Morton <akpm@linux-foundation.org>,
 David Rientjes <rientjes@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
 <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
 <20260329201733.6a4647ade4751e761034b9b9@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260329201733.6a4647ade4751e761034b9b9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ougufyc1z5b3xchbk31uiphe9jajmrjx
X-Rspamd-Queue-Id: C1EF810001A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774879607-478874
X-HE-Meta: U2FsdGVkX1/3auFi+HIMDmGYa3pDNfB/44IMGSobwgatkIseHPMzdG4Sdin2MC3hStOo6WeulrfXAFisbpvc5ALYx9D/gPt5cdw2SwA/zgq0ZfaHuIZH4T+pKnnMBCqYXqWA4RDWa/oG8U9AMefYVwlq6xzfDiOLwqDYHjD0v5oaQzxhbZw+a4lbYmmmohWKxkiiDQd2Pl65pvL4diTxYfSGoxbvN/hAhYwqirwvkP4uwjuS73tkOD7KhW2+I4NUEmz74w+Gxp5btHyv2c9/vXwVatMBDHEJax/qwE5F2WIgZV7f/51OJyIoBi6lhXa8Rn2J88LXG8TspfeTcrQxk8cxN9S0XqBKtvd3TYGEuX60Ik0g3dpTZdfZ16B/MNVZCLk+1SXlwkliXBxNgapH8dK9G02BmKWeiPN/fcTZDquRgWhYzyZaVfcoIdBX852XXb3YRnp/aQ38B/qJnGHwjQ7fPSprz0M26gwshkpo64MN0XaHInmLOP4IxMw4K9ZGilLIdAHV0V2Wo5tA2oYw5HQ+Y7qa91kL2KSt3G+/5+C4Mv7M/MuptVDN63G9D4ujAC96Ziqekfgjzv30dYxGzBJfeM87rfzuLYYqvfTV0msOMBorG3BT/NgFS0e0d435ee2RKD4vxut3eNwPFzi/1n/NyZ72rbcHlrz8Sj9zHOf7mRq5HF7ZF8S9upw17+hfcrB9g28Deup5bK66LS/FmUghItEb5RNO9kPL4Sla3rIfi9q6iB92wycYRBYR+5HKKgs6Y/xx7eFg0sh3mwQCRbD48Zb4w6sjVDWcsalfAnLmMrQRvHCRfSyJCrycVWPfvBvbW2yXbRoQ5EKw9ti+3zEmUWVannHOiZKqF6bgmK2DUH6AzFHI7PJpv9kGSD2dlizB2TB9hc/tffPAHa+N5MpMSNPdvy83LJPkrXhNrBV2rfURR+ukJ0QYQC/IEYxq/AY8FPnZhKE59O/1FhP
 6FOB19Db
 qTJhRxd431FZdegRaGtqEblR6C0oEYbNQb7AZzIeRPfuZWjv8Z4ruoTMAkWr4HxMrGrDq/TAzUnBUv+UTpMPMWiC+6iAmEtFtjnO7JrFJeySzGot+8GG9zhLg4Xgri7VXNL5cFBeNdqSvAWWg4B6P8U/y3rhyE4c+MUfh77nNCn3ut8bI9mMM1K89Y7FQKc3Dqmr0S9/4F+qv0jWkhv1FvBlL7XrhGrprtLccA1hOAIAL/FzGrlUfTMdcrAQFQgOfL6LaKSf88gus6zxwsjkl/wyzTQ1vQgvaO8fiWySOeMoVTDseeC3Fq8+VeTtZFAOBkOjIAquH79Hcb8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 05:17, Andrew Morton wrote:
> On Sun, 29 Mar 2026 18:08:52 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
>> Previously, we had warnings when a single page allocation took longer
>> than reasonably expected.  This was introduced in commit 63f53dea0c98
>> ("mm: warn about allocations which stall for too long").
>> 
>> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
>> warn about allocations which stall for too long") but for reasons
>> unrelated to the warning itself.
>> 
>> Page allocation stalls in excess of 10 seconds are always useful to debug
>> because they can result in severe userspace unresponsiveness.  Adding
>> this artifact can be used to correlate with userspace going out to lunch
>> and to understand the state of memory at the time.
>> 
>> There should be a reasonable expectation that this warning will never
>> trigger given it is very passive, it will only be emitted when a page
>> allocation takes longer than 10 seconds.  If it does trigger, this
>> reveals an issue that should be fixed: a single page allocation should
>> never loop for more than 10 seconds without oom killing to make memory
>> available.
>> 
>> Unlike the original implementation, this implementation only reports
>> stalls once for the system every 10 seconds.  Otherwise, many concurrent
>> reclaimers could spam the kernel log unnecessarily.  Stalls are only
>> reported when calling into direct reclaim.
>> 
>> ...
>>
>> +static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
>> +				unsigned int order, unsigned long alloc_start_time)
>> +{
>> +	static DEFINE_SPINLOCK(alloc_stall_lock);
>> +	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
>> +
>> +	if (likely(stall_msecs < ALLOC_STALL_WARN_MSECS))
>> +		return;
>> +	if (time_before(jiffies, READ_ONCE(alloc_stall_warn_jiffies)))
>> +		return;
>> +	if (gfp_mask & __GFP_NOWARN)
>> +		return;
>> +
>> +	if (!spin_trylock(&alloc_stall_lock))
>> +		return;
>> +
>> +	if (time_after_eq(jiffies, alloc_stall_warn_jiffies)) {
>> +		WRITE_ONCE(alloc_stall_warn_jiffies,
>> +			   jiffies + msecs_to_jiffies(ALLOC_STALL_WARN_MSECS));
>> +		spin_unlock(&alloc_stall_lock);
>> +
>> +		pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
>> +			current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
>> +			nodemask_pr_args(nodemask));
> 
> Snould we use dump_page() in here?  It prints more info, does the
> snapshotting thing.

But we have no page to dump, or did you mean something else? Maybe some part
of warn_alloc() (without its own ratelimit etc) could be extracted end reused.

>> +		cpuset_print_current_mems_allowed();
>> +		pr_cont("\n");
>> +		dump_stack();
>> +		warn_alloc_show_mem(gfp_mask, nodemask);
>> +		return;
>> +	}
>> +
>> +	spin_unlock(&alloc_stall_lock);
>> +}
>> +
> 


