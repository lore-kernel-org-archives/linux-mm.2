Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B0EC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5615B6B0096; Mon, 31 Aug 2026 12:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537666B0098; Mon, 31 Aug 2026 12:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429656B0099; Mon, 31 Aug 2026 12:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05CBA6B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:04:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74B87A01C9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:04:28 +0000 (UTC)
X-FDA: 85162037016.18.D97643E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A28444000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:04:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ppunhs5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788192266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uq7YyNnWah9USSxVq9LR8zCXv+SqDnnoFlu6Hbu1WXQ=;
	b=pejJ3KP4lCqIx/+DBUEvcqdP1m9FbWZKAYahQuTkQAaD8T5RZ3JWrGKY+cCjMu4kI6j1Wp
	ZNMlvrDcmKF+B+2IweEhDKjaQWbjA1EXuVJsZ25sgbP+tR/KGu/7hGhJkdy/Y8+SKYcavd
	RPCgv6vCZX2Gpy/lzw4C6KGcdFDQfio=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ppunhs5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788192266;
	b=ih6WypnoIBSyON4NM2gF5BqM79ZrEj8V5aO2m+QQ+WXuwVxOuBqGTv2vI68BkXJtMN7EmK
	mxzTe0ezjuMWfvqT5QzkJGHIk8H38gOX+QdCvPFDO5Hqnh8ZValnp9DM92md9+0+U9nV05
	rOK28D9jjZ3vTrb+GNJXfBUtfJdFRgo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC65240C32;
	Mon, 31 Aug 2026 16:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E641F000E9;
	Mon, 31 Aug 2026 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788192265;
	bh=Uq7YyNnWah9USSxVq9LR8zCXv+SqDnnoFlu6Hbu1WXQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ppunhs5PKu5CdT+XvNVUL7Rb5Z2CPCQLTrH/hyEU6ZLrfpnaoIxBlFJ8zdDIqRVZo
	 SvxYhhrw9qHo6yB0Fw0wo98g5QjKkN3tbOqS88Obb4g8lWANkTd77KODHvL1gJAlIb
	 pRPCjJaLUNt57zOR5HdQo3g9ZH6POfvt1ihde/LOIyCPAwe6VABEbvnHGNlwFeJ/j/
	 VdvyAQIYifTdJBPgeVSC52vQqQ0MbX22IyhMLKEXyUwsB09o/+12jvj1Wtry+GKxzX
	 9xQvTOWg/VrGEOEYHAQr/mgb41JarJb33o+FN9vIfLTxgPfWIG0leWcatULj0ORPjk
	 fKk6KXw7nqMsA==
Message-ID: <faac65a7-5c83-4a00-8334-ed26c45a8201@kernel.org>
Date: Mon, 31 Aug 2026 18:04:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in
 kvfree_call_rcu()
Content-Language: en-US
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 ThangNN99 <ngocthang2710.1999@gmail.com>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
References: <20260831130057.HLukQ-zm@linutronix.de>
 <20260831133222.8637-1-ngocthang2710.1999@gmail.com>
 <20260831143500.x-saxdAs@linutronix.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260831143500.x-saxdAs@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A28444000E
X-Stat-Signature: poj7jtgabbqj4gmdfndg5hadm78mdfyg
X-Rspam-User: 
X-HE-Tag: 1788192266-787089
X-HE-Meta: U2FsdGVkX19ChHiBRccvmQ9nhmlh07zgVsFkiNQj7Kdo0PW+JMXaT3Arz87DiK10wrr2zeVvrCnEy0inmG6iuP5c82REl++oQkFfPO9zD+rwCmFr3QEhggLjzxfDMG0qsgpMdb0BIkacmN6Pg0pLaUaq/J4zlHWzABiT5Do49XQoZfjI+t8uIgicoQ1zAWkVUWuvH9bZX1321lE11OfjzTVjzZSt6pFpvvq/XBDFd1bP4XlC5mnLnK8n+k3ZULiNYx14Wd9tIwEikoKDsIrOyjSIMXoOCnFSsNSIpfZ6Lbvdtg0407oQ0zX76kNQUzjsLoyL8eeV8ACXze20u6ZFKKN1Mb40uqLGkGbP0cXS+G1NwST66eiblX2sMQpvBO/xLyAhEsssrcxgS4qNK8Bo9nqiT3JFfvPKOeBuUuH+yJjJ8DxLyhst7EnRo/gQ6fjJgzn9luByNuxmFGx5xUngkizN0YWEdfPnG2EZb7xeE/TFiOfuvmC/93F/COoxas3G045g+Py3GRjXvGMteRgaJW8lD5vKqvbBFM5UsPTFIOTFKF/szow52qjvPtwpmAYzD3rqZ5afq4oq6WYM4/IsjgYB0HacBTI+dCPGKDMnVOok/eru0V9ebd5QN9RS7WMO/pAlJYfSNz1USp4tUSgzsgwKFEeeRhmk5FUWAfpCMTT/HWGTLcENlykwBDVjIz0gi9iMJIZXVnI6Z3YS55w80l1e9yI6tD4gtTbI+qXwv4PWbgQUA+JSkUMzA8O1KM18A5q+GL5pBpd3bQm7kVnSwOLfTqxl2YFAvXNN0mTA5hI3/4XSaBINiPitRxGamPV9ZguwOBvMM8sIMFfqcDnLefqqWyensvrDH1ScJxrzPSZfTwG184IdhcF54C9p0LxERL+dUybREB/o3Ejh9YmSwQRGg5T55x7+BE7u/7nS+AqsVcjWSzrgIDhuPpgT6u1dsU+ysWeydg31xrVh4xO
 wNO0FFTi
 cgtUdvcFbRq0tHWg6vSB8ZNgPnrYxJxIcGLm9tKi5moliiXekOnNC0Dep88kHPN7T5hk2ve3pf4FVRZnxFZTns7I7EAkilb6tv7P5x4FSwJx1S43FGwtqxwnAoKyCi7Bmh1sZc2aJYaQZ4Q2CYla22AFHI3UtbTmLj1BEOe51oe+dnBegKve9T43F/R9heIviVobAu9tfhSqzf8nyAqNby3x3Uyc4+y3Spyjq1CQcBmcJiFaq1HAokdp0JOTN1fqV35bQZ6Tnl17Gwmni1wX6Jq677CseWRHQXJgNRyAqyaBU8D4qgcBoInBu+p4maGUkoTQoCCb80CZTMQ1CiidLoVqVDiiPYNDmotDK0+m3WC2Caul7bsXSQhW6QPW8kPcbA+g0kCoun65JgSso7oSIHUhYlKhJsSqFp/hG5ujabgTHqDJTKzt6mbtFFLg+h59j6CQ2dYMS0VLMU7f62fLnbkp/VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 16:35, Sebastian Andrzej Siewior wrote:
> On 2026-08-31 20:32:22 [+0700], ThangNN99 wrote:
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -2034,7 +2027,14 @@ void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
>>  	if (!head)
>>  		might_sleep();
>>  
>> -	if (kfree_rcu_sheaf(ptr))
>> +	/*
>> +	 * Callers may hold a raw_spinlock_t here on PREEMPT_RT (e.g.
>> +	 * set_cpus_allowed_force(), whose callers all hold
>> +	 * task_struct::pi_lock), and the sheaf/barn locks are also taken
>> +	 * as blocking locks elsewhere, so trying them here creates a
>> +	 * lockdep-visible ordering conflict. Skip sheaves on PREEMPT_RT.
>> +	 */
> 
> You mix up things. A raw_spinlock_t should work in general and should
> not cause a problem. The task_struct::pi_lock is special: It used during
> wakes and the inner waitlock of the rtmutex acquires it even during a
> trylock. For PREEMPT_RT we don't want to acquire any locks while the
> pi_lock is held.
> 
> What about
>   
>     kvfree_rcu() is called by set_cpus_allowed_force() with
>     task_struct::pi_lock acquired. On PREEMPT_RT the local_trylock()
>     usage below will acquire the waitlock which must be avoided.
>     Therefore avoid it on PREEMPT_RT.

Thanks.

> Vlastimil?

IMHO it's not useful to iterate a fix through emails with apparently a LLM
agent, so let's continue here:

https://lore.kernel.org/all/20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org/

> 
>> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
>>  		return;
>>  
>>  	// Queue the object but don't yet schedule the batch.
> 
> Sebastian


