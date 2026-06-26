Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A401C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDA56B00B9; Fri, 26 Jun 2026 11:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ACA76B00BA; Fri, 26 Jun 2026 11:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E6A6B00BB; Fri, 26 Jun 2026 11:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF7976B00B9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:00:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6744A1678C1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:00:58 +0000 (UTC)
X-FDA: 84922376196.15.FB187D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9AB83A000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:00:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nHoo2Yi/";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782486056;
	b=tikStsq+F9gI1YWWPGEO9MO4/tA9lx0HHpaHxNpS8+2OLyDwEOStBBtfJ/469Y8Z+4p02v
	/ZUCIjxmyyfEspJKvM135GzIXrZbvLikXt+G0o/UOpYV5E8MIkFHo/KzdgsJOW8P4Im19k
	pwX/6E7opJ6dxtzOTCkgbrfjjlB0k9k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782486056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juC1Y5v1j3sP5fMQDkrZYHNSUJQ+4S5mJUHcpe7Ac+Y=;
	b=xpUZ04/GtO6dc1Ui4Q7I03BNPbeqfuIkE8C5CMPdPuQGWekIPZ+fCfOJa60RJDUe5PG8YL
	klifmRzCTdx/s0sUDd6ok+RBFph/dHH7Zg//jUhTkfZ2Y1rfJ1AWK5nZxbBm+biPmetmns
	oFQY8IiHqwCfNlMQnrsh3bnZG3oKwVg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nHoo2Yi/";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A343600C8;
	Fri, 26 Jun 2026 15:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48E01F000E9;
	Fri, 26 Jun 2026 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782486055;
	bh=juC1Y5v1j3sP5fMQDkrZYHNSUJQ+4S5mJUHcpe7Ac+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nHoo2Yi/y4ujBsFKNm/8GmcKx89Mae5+bQ7ujza84jDtcjvSs+ZUoVL69Boo7vGdk
	 8dMxUVeLpgwafnaKeZRD3TZp8e4ZtSG8lqn9Mp+jHxIjdPPx/R3ae/ZQMksOG/WTyg
	 TE/mjtDb49CRf9bqw8oF9uoIPWqLpBwjtFyqazn6lpuFeiC1lpSDP0NUJoLeyUp/QK
	 JHltctkNxct0riLSdhcwbrXAuyeFdoShcHwNnYhPyxw4qLzBGTBUTk7iUNgG3lXfAa
	 CGPb1XNqC+Gj4LdIHL20+qPCy8Ef9+yq58//FqaxFz9FE1+B6ukmVUM3Bx1VffBvup
	 g5G31jRhoyqug==
Message-ID: <feb3e339-f61d-4f99-9859-e1895d396561@kernel.org>
Date: Fri, 26 Jun 2026 17:00:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] mm/slab: serialize defer_free_barrier()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-4-fdf4d17351dd@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-4-fdf4d17351dd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9AB83A000A
X-Rspam-User: 
X-Stat-Signature: xj89799o6bbyr39t7kxb5pa5wz5bjjh3
X-HE-Tag: 1782486056-679102
X-HE-Meta: U2FsdGVkX18P6QntnVNj9dSTVROm7N2eNEqXRr++UrKcmc9xzVlZM9LUwkInt0eEpw1j7i2hmpEWL4vw7vlwQEJhXEZTf4yTq7RfXUutOfIrLItS6iYCZzccuiJjHHHbzuZxYz6lfiOJj5vIlaD/UPqxkL9YgrU73LaUdCF0nel3fEWWkWmnqpcz4Si6gJbeS8n/W/eXyKabgPZIrTw6ylF8RpVxaXKz3XoxZtZdittO1sZJhr4YUqaf7uPWgc7rtiKvvzcN/skOl8+jBYoounl5LsUFPccqRRWpvNLcHXRd4FdWu+CpIOCuherxNmK0EaiZiFZGJL81Ai2ysQWxyNygjRjTzJVwTOnIf6qDGmiO69yma/YuSAewuZr1aQYvXnh01T2haK2hExNY3ZJkfx0hqwUP9cO1oE/BWwIsubXQ63O9tpFi5RQuxEr4bLEKogdvlFYdQD/LGtDAQ5vzR+2ySxZHIIIwh8thwFkU7UpXoAsCM9Qv0OAaUyY9PN61OvpXs2Dqp6V0L+0NBrqiq3rO7ySY7pHy1asgl2nPZuwnR0WrArHDQ+B/6FzNPP+W7EmdUKly3Nph5i3HzL5O5ZlyeHhzOKiTVfWM9LOvu/EEhIEkZX5qUfL0q9ZXXg2wi0STonaO2mwI0Db8/sbdE7NJ9EQS86ZEv9SqskpYWLM2a7/F/5g8WL5Jm/JuFL6z99Q/1XGnCGz3HT3qlqF2WL5yW1tanfaZEZxN1qJi4dS6Z58CD8VwaAi3KfGGt65QGn9dnyaLmwcowdtDVNVrgrhkR6X7r3diDQMHJg17rj0RIUpmIUIBpzxsKSG0Ln9nbC+l2ivSphKBi5+hvk65L5F5M4I2HOFI/XQYaEMo1jYP4HFY4r1kIw3uYDWCPhwyrmg/B1qgifWmmrBQvTOllYVlYgPcghYtnL4cL1HOTxmaTaAT4rAfF2Wzy7CzLk5WS0kml3lNV6p6I34cZmV
 WOHg/otD
 IJs65oijBQBw0d73KY1EZT5XI+OqQuds2ntG1hy4eyrmB+yeH65e/AhwlWI/Q4tLMd/VnWISvn5Y1S2YygkRIdaRkK2DE2eLbQi/sKRBN88zNs+zdTu9i1aYChRm6y26o6g22ZaEHGDmICE/e4ZI+5GubZ8G+P1ciEj4OX1PJULYn8jsbfmRymBwPrZoU24A5oY34A8kbsq/pfuFoVhK0mokOfr9vkgVrys2L8FFWF81UX9hZ496W7aKfOPJxhGldfoHU/3Af6uKgeRMjE47ovYmfIfqmXP9FRrwlPX1x0jLV0CizncbDzAVTS/58VBKMgbpbbqP3syUVjBagfni+peXwNMtJ6mt+udtBR84uOmoAUEBzTou2FfWENta3jYWJx2ro5Ru2zoIUZOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
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
> Since defer_free_barrier() calls irq_work_sync() without any locks,
> it can potentially cause a hang as writes to @task are not serialized.
> 
> Fix this by calling defer_free_barrier() under slab_mutex and
> cpus_read_lock() and add lockdep asserts.
> 
> Now that defer_free_barrier() is called inside cpus_read_lock(), iterate
> over online cpus instead of possible cpus.
> 
> Reported-by: Sashiko <sashiko+bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/slab_common.c | 5 ++---
>  mm/slub.c        | 6 +++++-
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 388eb5980859..27f77273fabe 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -550,11 +550,10 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  		rcu_barrier();
>  	}
>  
> -	/* Wait for deferred work from kmalloc/kfree_nolock() */
> -	defer_free_barrier();
> -
>  	cpus_read_lock();
>  	mutex_lock(&slab_mutex);
> +	/* Wait for deferred work from kmalloc/kfree_nolock() */
> +	defer_free_barrier();
>  
>  	s->refcount--;
>  	if (s->refcount) {
> diff --git a/mm/slub.c b/mm/slub.c
> index 4a3618e3967e..52c8d3f33782 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6411,7 +6411,11 @@ void defer_free_barrier(void)
>  {
>  	int cpu;
>  
> -	for_each_possible_cpu(cpu)
> +	/* irq_work_sync() may use rcuwait that requires serialization */
> +	lockdep_assert_held(&slab_mutex);
> +	lockdep_assert_cpus_held();
> +
> +	for_each_online_cpu(cpu)
>  		irq_work_sync(&per_cpu_ptr(&defer_free_objects, cpu)->work);
>  }
>  
> 


