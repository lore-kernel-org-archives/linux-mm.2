Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91826F3382D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037046B009B; Tue, 17 Mar 2026 05:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A356B009E; Tue, 17 Mar 2026 05:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40556B00A0; Tue, 17 Mar 2026 05:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D249E6B009B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:47:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 819868BFF4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:47:46 +0000 (UTC)
X-FDA: 84555078132.13.82CC64E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D3F3940014
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:47:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=akeut+2Z;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwNcTqSMZyYO5YWFpeyw8YqahQ9RuhR84f0MBBCw3i8=;
	b=w9/RjF8HAOah93FDOyH1pTCz6+8DfSTLAW4RucsCuogORrG6GBuOfvzkEB4gZE2iweI3H4
	iHWfdPe9T9BkFkg7axQlB7scna9rJRWPZirzO1dSgiq/xrd6unelRBCcanc0kBePsTChil
	FPFhJd5Xr5BdF2AXj6SrkHGFeFW7PoY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=akeut+2Z;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740864; a=rsa-sha256;
	cv=none;
	b=WcKZecTtSB9u7xpHaNBw7awHIrAl9Y/WyxSHhNxinEPm0xbDIn6HRdDOI/Yv69kWFUQTC5
	qaqqJlpqGrGIBYZwSz1CC2YaH/3N2/V/KCE4YHLMyqtdSSFtYlc8h65I6nG+zoh0IKaxyg
	QuyNMPKLH7dTFx88r3dL4yfjViI/SHI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23CB960008;
	Tue, 17 Mar 2026 09:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CAEC4CEF7;
	Tue, 17 Mar 2026 09:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773740863;
	bh=Emd7xlwJxo3R6o8Vgyx1wp/fiG/eyHLFzATYVuVUR54=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=akeut+2ZsSZB7C7wBE1X2mfrZuO+h9t514sguBf64vB5Ti5Rit4C4YLg1CzLoQ0U6
	 NI2NGEJPYYlMC0sVgUlIrsiA2CY5IdoVIIiGMcoq6t/9EuD72doBnACjwqi30oCdzP
	 2Nhuw6X+4Eh1WAlpq4f3Uqgd8FgXxzI2xDHZ3l8R+devTI5d1D+A/4kTIiksvaJtEX
	 GsEqceJ8PG7paS3u3WP6FRnVDBz3ve3FElftKOE/myLXmRgWXKl5ZvSGYND0I0slkk
	 5fAp6mjrfyTGOkCoxgEpt1U1y2rgdl8yOKeOxO0mijnFGyAFNmnguepOVNHqfCRCPQ
	 ab5jSKTq3Gq5w==
Message-ID: <ca392f68-9df2-4280-900e-0bc74b1476aa@kernel.org>
Date: Tue, 17 Mar 2026 10:47:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] mm: list_lru: move list dead check to
 lock_list_lru_of_memcg()
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-4-hannes@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312205321.638053-4-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D3F3940014
X-Stat-Signature: 76ztnkeb4iyosrbgca7d9si6ytn4fzo1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773740864-40628
X-HE-Meta: U2FsdGVkX1/4cXmuXtqHjslGps2HGHyojlwivtMtMIIrmxtk/6I4foUbNVQbKVXmQ0MQvSiiefwaVSToYeu3m7y/GyGiBWpwyqcG3K5I3JAk28ey0A0latmy17u57dPKgoQIHkBilbQoAUoAFSF0eOg7T6TFAH39v5eMHESB2+3JNSu5EqlL+PfZK0iYGMf3pjgRx6wkX8j6EhDjMLooXJqBslRalXkpnuDtEAYuaDrsHVTcD47XHWWlEYw/ccYcw7Cd6Rd1OIog9BMkwQMEhbnXXl47C/jULx2YF/NupYe6ZSeKahwXCfc8+Rdoehq5q2t54mfzzgB3sEZZ5Fmc4kNALf7QULr30YALv0HbEb1nPVMOeYfAdt4RTG9skmRqWKiXkqB/oiJSb5JE3iR0SBhyWrcET2tb3gj1d4lS2vvV00UqjO5FUyxn+9dF5PwY2Bg+rlmAi/GUiNC8OL28EmEd519fCXhuRztZXR9HBAk0GYrU6e/g6CovCw2ejWhPuaJbAI/tEpLhWQgog8mQox+3mZJBvxjyWD10u3tfN7yxcFZIBi9T0mM8rwIbMgTLw4TbpaC2bPiqam6oEPQZm/Vqh83BfpTyfkVMh4ZVStlMWyW/Sd6TDYBz6QIxNNvF5Irw6YAA349F/AeA7TwUMW0VTyhbsQFsYmGVPa8TEiIdEwDJi1nwG2uXJhhtRoj6QnxvMzxewybR3QkNhkqzpXzxVexCIbBihgiNKnzRUiTPMysx2DCWDsNPhVYkmyYPOdU/atVc0gI8MfoasqJJFHpxIqv5Uq3mrOqAoKUfDAgQd+ibr0b4+PIq/384tt9hehMl2CX5EVKkm0TBhfETw6Vph8biVC8u96YD7Hd/NMLKI0PwwynQ7cUVSST+qchjmVk9AJ1iJa2cIR2ytr9BKpaXuSwChcfvYTsZiF7w4D6LLGO9jpKZMm5QBS41dFzWVzoC2IUmxcKWRRMLGvT
 rKhHowdD
 W6SiodwHevylNGuz3XrD4a93UwY6tLIDl8fxnOAVP3YymGv98Anb9z76syxW0jm+YKIoRCX/mOZi1W9wPWpVBG9pysXAE51ZS8W+RvwLlRM7sYE9NPgfjb2kRXix5FcBqFnNkFwJMO2H2u17kw2K8Lu5TLhy/Lc5xSOAmU0y40PeLQINTtBRZaGV6XKAdll7W7/PvHXtFuuv5IdbifJBzO4Czceval5SXdJLVgoAqOnpAcAdATlKHZIySdcagT9TRKlLHOzz+CWbiG3kdd6ebM9xTBZ7K5BG/TLVDbjurHoj0ZJp+ajQIVwvjYGbtSQLdVEo/m1CU4PT4O3OPLQNFbGRzi+EzeHH6MlHT2zRH7MYKJgDikhzkeGytiLQxA+n2rHsH7OexWuym2H8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 21:51, Johannes Weiner wrote:
> Only the MEMCG variant of lock_list_lru() needs to check if there is a
> race with cgroup deletion and list reparenting. Move the check to the
> caller, so that the next patch can unify the lock_list_lru() variants.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/list_lru.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index e873bc26a7ef..1a39ff490643 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -68,17 +68,12 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>  	return &lru->node[nid].lru;
>  }
>  
> -static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
> +static inline void lock_list_lru(struct list_lru_one *l, bool irq)
>  {
>  	if (irq)
>  		spin_lock_irq(&l->lock);
>  	else
>  		spin_lock(&l->lock);
> -	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
> -		unlock_list_lru(l, irq);
> -		return false;
> -	}
> -	return true;
>  }
>  
>  static inline struct list_lru_one *
> @@ -90,9 +85,13 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  	rcu_read_lock();
>  again:
>  	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
> -	if (likely(l) && lock_list_lru(l, irq)) {
> -		rcu_read_unlock();
> -		return l;
> +	if (likely(l)) {
> +		lock_list_lru(l, irq);

Was about to suggest adding a comment regarding reparenting, but the
comment further below already spells that out now.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

