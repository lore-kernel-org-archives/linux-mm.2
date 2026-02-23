Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90EA3EC1107
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F261E6B0005; Mon, 23 Feb 2026 11:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3566B0089; Mon, 23 Feb 2026 11:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AD36B008A; Mon, 23 Feb 2026 11:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC0956B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:30:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7431B139F1C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:30:30 +0000 (UTC)
X-FDA: 84476259420.30.78F1957
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3E5211C0012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:30:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LyOU3zaz;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771864228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARqOYR9ga5SHWqbWk98YZPj49IHJaMAkP4feff8FaFI=;
	b=5FC8VGq/T2FkMybJV4aX7sxZi//QcD+esY2oyjh5XcpSchFTQqZWrO4uxZxKWBz5hS/9z3
	/QPRWEshMhwWnrwnT0J9tSQ+YELCg907LdQqqxHwhh+/n+kPgUb4qwIQEVRAyDx07Qms/O
	SOSCZybRhbnX2tyqHqxcFsT3wFbIxoY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771864228; a=rsa-sha256;
	cv=none;
	b=SV0MER6mWHq7+Z08T1NH/kQvb0/ghlkodLPVFGlTQke6bX9R0MSp5Jou2KxprMf7ZjzBfE
	H9SElsOyI4bfCeq3HWKVCQW/g9gC6LuwHVe/BgLzzOiMARHH5T7qPzXlX3NjBi0KL6QPkK
	DnS52Me0OqCCpJis0xNbGlEkctKAmUk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LyOU3zaz;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1373db93-3977-425f-ad59-5970e7e50b48@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771864226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ARqOYR9ga5SHWqbWk98YZPj49IHJaMAkP4feff8FaFI=;
	b=LyOU3zazNaudEi4Z5JNNsUHEUe1xivKzD5sznztk3Sd2AXdXKzTXp3uS54+r+pYexQEYNZ
	Mpiv8YDQm0nICVFPgZtHj/ozvxeDFIkzs/FuBiu36EdcaluQG+q8cTLVsMMFg0RxomVQ/2
	2kWQhdLcAzKl3aM+QOwTK0nDBUcG1yw=
Date: Tue, 24 Feb 2026 00:29:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, npiggin@gmail.com, peterz@infradead.org,
 will@kernel.org, david@kernel.org
References: <2a6c4e62-1663-4a98-9adc-406a6a1ebfd3@kernel.org>
 <20260223125826.28207-1-lance.yang@linux.dev>
 <a0c434c4-ec65-4a37-9422-5614249124bc@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a0c434c4-ec65-4a37-9422-5614249124bc@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: omk6tehfqi6arb688aqzpee8b6qjqtj7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E5211C0012
X-HE-Tag: 1771864227-594865
X-HE-Meta: U2FsdGVkX1+1hDiqGGsh6zVNWCx75rYCy9N9OcyQSHdhNRDNO/U0pXpoPwXO3YBm4IeJ07BdXjtTgDJiyiH7LjKjW8fvmHR2yuS92DFs7yuvJbD1wHykwkvQqJoGMZgHK7uOCdl50KKo03lJ03XteLzcnxuGXaexjaYdEPvJAIYWrGvQVT1nyAiaxn/4AATgvXIQioQjx2ZjcQqyg9TzNrsgxBDpsd8Faa5r4v8r+Etr3ROEGITooZbgdy6T3xUlUdUHkBrkikL0Ej2dwgYtac4V8uxTs/wonFXGIbp3n/VSxZz+puSt8RAviVQpHG1VUKdOkGFzaEEjZMIy3Anm5G/FId0J3/Z5CoWuJBeszOkNbczgE1EwtsNy/f5z4xqgrvdGJxLZcAlACB0jlik3OUd2OQDIOKCECLIlsJK2P/yKr5scYtTpeBy/9/ayUm1IFllIk6ezVhdD3LJzmpmGvggMPl/ly/UlCX+pR8UXOjpBw+mzeqDntawflg+iPAjA+ApqaiJ+VwvcafofmPArKqo5oGlU2YLOSLMjdxir9yW/Dgf3mvqSsLGmbPgUVS4MSzWJFQK8FznHgSfsfoMN1rsfiUHDn3NfTwJHBT/qb5co5g6bhUIWgz6rL6+8+c09CCwtdY6NAIyB+UIbAReewx3mZp9RTD8SKwH8Z1/JOM+o+OyViPBNXh+u0a4x456U/7B0aWRX/64VqfLqFPc//N29Uvur+Ebx9JRpgV3X9bJQEc4HXeCpGdqOHAMPeGbvWifEfGVPZsE7VkVt3Apf3bMjs4C+jOsEJPJVV+64AVhhPXipk2oBUuDKWW9nx6yXOM4mAtVUwQ7BFwKnmuQ+Qy7az8shNREkhD9V4V9f8OLD9saY0t4puN0ZkBzMIk7mkzCzaSn8azexGza1wdTx5uakhXi0gRlay4Lw6M1jHMjFqiIHMkZMvJTXwIR3bJH6cff9pKLe7xOj/fMzW4y
 hx48fStQ
 rKC6x27NTKXHQfLR2UctA7REy/sh0rte0SKuGXn0s9DnH2Eu92J1zqVG1hiEGOPaXnh9OmnXUglU/oUKzEhhyej1hiG70e3dsGyhXAM1qmagDHO/zn+raC7Now2qFY2i+l7Y136GEJCaBmgZ0WFc7+raogDp1mQOvU+cvz9f6Syx/A5GN02yjn4q7QjXRnX538SwnDjPY7ZcQkgAyaDROtOceTejnFi4LjDPd6q/r/GMELMBnbMmT6hYDtBemmOSyNscJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/23 23:31, Dave Hansen wrote:
> On 2/23/26 04:58, Lance Yang wrote:
> ...
>> +/**
>> + * tlb_remove_table_sync_rcu() - synchronize with software page-table walkers
>> + *
>> + * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
>> + * broadcast. Should be used in slow paths where sleeping is acceptable.
> 
> Just a nit on comments: Use imperative voice:
> 
> 	... Use in slow paths where sleeping is acceptable.

Okay, thanks.

>> + * Software/Lockless page-table walkers use local_irq_disable(), which is also
>> + * an RCU read-side critical section. synchronize_rcu() waits for all such
>> + * sections, providing the same guarantee as tlb_remove_table_sync_one() but
>> + * without disrupting all CPUs with IPIs.
> 
> Yep, synchronize_rcu() is likely slower (longer wall clock time) but
> less disruptive to other CPUs.
> 
> Is it worth explaining here that this should be used when code really
> needs to _wait_ and *not* for freeing memory? Freeing memory should use
> RCU callbacks that don't cause latency spikes in this thread, not this.

Good point! Worth clarifying. Something like:

Note: Use this when code really needs to wait for synchronization,
*not* for freeing memory. Memory freeing should use RCU callbacks
that don't cause latency spikes in this thread.

>> + * Context: Can sleep/block. Cannot be called from any atomic context.
> 
> As a general rule, expressing constraints like this is best done in
> code, not comments, so:
> 
> 	might_sleep();
> or
> 	WARN_ON_ONCE(!in_atomic());
> 
> seem appropriate.
> 
> I didn't see any obvious warning like that in the top levels of
> synchronize_rcu().

Yep, synchronize_rcu() does call might_sleep() internally:

synchronize_rcu()
   -> synchronize_rcu_normal()
     -> wait_rcu_gp()      -> __wait_rcu_gp()
         -> might_sleep()
But adding an explicit might_sleep() here makes the constraint
more obvious. I'll add it :)

>> +static void tlb_remove_table_sync_rcu(void)
>> +{
>> +	synchronize_rcu();
>> +}
>> +
>>   #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>>
>>   static void tlb_remove_table_free(struct mmu_table_batch *batch)
>> @@ -303,6 +321,10 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>>   	__tlb_remove_table_free(batch);
>>   }
>>
>> +static void tlb_remove_table_sync_rcu(void)
>> +{
>> +}
>> +
>>   #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
> This seems a _little_ dangerous to even define. We don't want this
> sneaking into use when it doesn't do anything.

This follows the same pattern as tlb_remove_table_sync_one(), which
also has an empty stub in the !CONFIG_MMU_GATHER_RCU_TABLE_FREE path.

It should be in tlb.h like tlb_remove_table_sync_one(). Will put
it there.


Thanks,
Lance

