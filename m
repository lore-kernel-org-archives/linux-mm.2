Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7CC606AAED
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fmwQKII2
Received: by kanga.kvack.org (Postfix)
	id ABFF46B00EF; Wed,  4 Nov 2026 11:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A233B6B05B1; Wed,  4 Nov 2026 11:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912396B05B4; Wed,  4 Nov 2026 11:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5806B6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:24:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBE0E16078C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:24:54 +0000 (UTC)
X-FDA: 85397960508.08.2E911EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FB8C2000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:24:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fmwQKII2;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793809493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jAbavI8ymZD98DRzmcyyK930fQyxtvawv4WSCcoeMY=;
	b=4wpajvoDKgIlbeIy1sOhB2H90yl2NH1mhfzSJazXdoIQKqZwI8D9gDUyudQzDUoxMS24CD
	JJMLWHrh5mWnkQxJDZWl90CGU9qbrQTaKoPI3KtCwrweW+se3xlENOxZfrkt9rFVZu5M1V
	yekEgMHzlNN9q9aXkrX+DQdz4c61/zo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793809493;
	b=PsDl/tb5oB8Cu1KNfovD7FcznRZJWpgBC+6QqXwAYdy/FJMWR/K9xVOcOGskRepWriqkWH
	rOXXhK/foUJcRMq2i2PcexSBENKI8DdJcFN3DNXDECS0iGwT//ef16UayfIpgNt08f/wuD
	WdjakH9GE4Vzk5BfmAL8x6CrlWoleAI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fmwQKII2;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A010B6022B;
	Wed,  4 Nov 2026 16:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E171F000C1;
	Wed,  4 Nov 2026 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793809492;
	bh=0jAbavI8ymZD98DRzmcyyK930fQyxtvawv4WSCcoeMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fmwQKII2OcOxpajVA5m6X2WFvwAjWfOocU2T+k3T70EY6soxn1uhskGNqKdz6OvIN
	 VmsTpfWcJ5T2hMgM8ew3aaX5VkIgFgcNknEmUwKqhluTKM15Til1zGkd8qPNGzVRU4
	 9wtox6Lb4jWK0+GXsbHnqkx9ufit513GlaHrZx6yxW/3391rhDCQhMjsB7LHFTu/N1
	 Ea/N8tDlz9xWQxJc+6fVZrdyQ8SJqe2cpNdAzkBk+sSdys3aYDfbv9/nlAp3txGad0
	 grJf84a6ksmA9E335KvNDmCzIwyY7OWS2Hh52xgdE6jCnDQ4k4IX59FYf2NMjVZj3J
	 aGcO6EHA1+JYA==
Message-ID: <37ed51ad-5160-46b5-a951-a0da2ff1824d@kernel.org>
Date: Wed, 4 Nov 2026 17:24:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next-fixes v2 5/5] mm/slab: serialize
 deferred_work_barrier()
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Sashiko <sashiko-bot@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-5-19167cfe4779@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-5-19167cfe4779@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 4a6yheyzutsxczomqz3chdo4wbdxxuk3
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 2FB8C2000C
X-Rspam-User: 
X-HE-Tag: 1793809493-449513
X-HE-Meta: U2FsdGVkX19EuZayum3Us8UciaOqLbNkL65PHVqOxDqcnQ0bGt7dXZbX4GCQYkEUz7sq3nYoUGbrqPpQpYlRPb4UVY3K0NXW5y1HwP6hbuofL6a6LW8B3wVdY0+yz2bSXnPns5p+st6tRL+9CoNrZDt21CQpgwYjBNIb90rDy1FyFjsUenkhanNsayp1enAxgz2vE86Fh3MVuT7z9mIF3XBM/nPmh6PejRq+idwTEjPtI00Kn+l73Blz3hAjs9UFdXT2BM2mmIZUfuc4dPN0cjS52CqzNC5jDQ/SKQ/gCvABnFdI4vaeSbbuu9nKyGWb1pTG3mTvQbVqsC1rU2Bp++Mo8TacWz3puiOU49hNLm4aIActhwdVqRmPvBK5H8khofoC8lXiEz8Qfw6Yv1M+qpHeu3Mhgxo2DIa67EDu08AdWpSk8xjV1ECirMP0TYyaGbnOSMxira4qew8Pc4yEPBTDZX6AIr0b9qZUE4AcPx0vJw4/il1eD0fUWYHDBVU7/G68mHCOMyEP484bx82PLAYGZukzf61kVGqbg6h9On8rX2VpMfQhoMSMucrlkXOKR6V76zyQ6UR3gS1ja9DM01+PPEbwVbfNS8kyHwHoteYKcrlnyS7cMtuD6Nkqwedrev8rgyjJVcBAGq6HyLDen5/CXUHcUgR/GLtg3V0b0Vd3OyA5lcwSnlWBvlKA4sCHXbcp/y2wmsRYmuLB1bZWz8DiB4l9Mu5R4qpHvSso/efiWoGsNjSo5HtCvP8t+Yo2Ig/QdRUf2f5qulTapOjOMzH0TMhAioV8BUuiMFY+kVxC//1K5AbWK2dlpHSKFFtDYsa0uBF2GrZl2L7x/M+vlkyqgoKDKw5FYV02eHDQizV1AUrDa8jygIlN6iegovg8tQNPWuMBXpvEdPx6tsiSleE+cCatArj80z8Kg0DXwr+lX8Bd5FthABUxnt8pSapdG/D8fC5u2ZAgBaIdlAM
 gjRr07AH
 1HvrRpjMh+LeDkJ0HXtIHCXfZ2vZuyV3fF9LFZ/Pv5OM+Qk/BwGnig1uDq6ujnD4gSRT7u1w6V8WfGYaeUMVObgwT3H169jCOmdjY5iiZxmmIZED8rC2fHbHzPUo6XOHMqTTonpXxgY03jaAvDUjUwuW1MXhpDGUMQHGJ1br7pZXgv9XLMQqEeCcYMkTESbC8iDZrYXXbR0/h99qFJ5sEfX89QtmVjB6/rnZtf3tamOtF0OSj2o9lpWoBGwB94v1bZww5SCmMk4fI96DRQtrA6Dg5gYpzHw3JOd/+ZO8DfXqwgNzMaQeixP8EoPppfU0bOo2gi0qOkMTsfBK7PomlI5r2IJLjGW3Sjle+DXn4DRuuk5p26hBXCgOp7Trgn5N7+0fd7y4zd/A/k0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> irq_work_sync() uses rcuwait instead of busy waiting in two cases:
> 
>   1. The kernel is using PREEMPT_RT and the irq work does not run in a
>      hardirq context.
> 
>   2. The architecture cannot send inter-processor interrupts to make
>      busy waiting reasonably short.
> 
> However, rcuwait.h says:
>> The caller is responsible for locking around rcuwait_wait_event(),
>> and [prepare_to/finish]_rcuwait() such that writes to @task are
>> properly serialized.
> 
> Since deferred_work_barrier() calls irq_work_sync() without any locks,
> it can potentially cause a hang as writes to @task are not serialized.
> 
> Fix this by serializing deferred_work_barrier() with a dedicated mutex.
> We cannot reuse slab_mutex because e.g.) some users of
> kvfree_rcu_barrier() are outside mm/.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  mm/slub.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 6dfa8ca3c937..50e88edcef3a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6636,8 +6636,12 @@ void defer_kfree_rcu(struct kvfree_rcu_head *head)
>  /* Must be called before flush_rcu_sheaves_on_cache() */
>  void deferred_work_barrier(void)
>  {
> +	static DEFINE_MUTEX(barrier_mutex);
>  	int cpu;
>  
> +	/* irq_work_sync() may use rcuwait that requires serialization */
> +	guard(mutex)(&barrier_mutex);
> +
>  	for_each_possible_cpu(cpu)
>  		irq_work_sync(&per_cpu_ptr(&deferred_percpu_work, cpu)->work);
>  }
> 


