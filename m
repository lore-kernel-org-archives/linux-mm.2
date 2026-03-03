Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B743EDA694
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2826B008C; Tue,  3 Mar 2026 11:22:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78DA6B0092; Tue,  3 Mar 2026 11:22:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF916B0098; Tue,  3 Mar 2026 11:22:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97B726B008C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:22:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41B38B785C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:22:07 +0000 (UTC)
X-FDA: 84505268694.26.91A3A21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9104B1C000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:22:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WIeGUN4H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772554925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeMOJmZfsS4oYhG4pPlpHryCNO9W/sY9EEjCt8HWpck=;
	b=pIag2PloQSbk62aHfppbU1jE+ext5HLLw/sQ54Ybqd6w11NdCZCgqCOHyX7u4n1ChIQjcJ
	SP0MV66BfReG4l0pRZjPqFTFDcBHpxV6jC6Rp054SxPvypgCBXH7JvFdpwT/U0vR90kPpm
	f5AsEb3x+K6F/VabJ9nqfGQpkeeZNgs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WIeGUN4H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772554925; a=rsa-sha256;
	cv=none;
	b=JEOchbiiYQGODEmnPzjLkAZRi9jOKUpeoOMJAcfznMdrL/JU9Bt7Xl0HXmwJZ6Bf5CAJNn
	wYTNnLJ6Zue6/DaV0F1VExJztsOKI8wrW0eE+YENbal1qoufWO5uiU+XrgUr7UQgrS7f1i
	p8aKdC/F8t5CMDR4zfw8xS0gkqLK5NU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0500060053;
	Tue,  3 Mar 2026 16:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B07C19425;
	Tue,  3 Mar 2026 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772554924;
	bh=JfR8Uml82cdGIBCvJ1lqgmUooPoskruQwZ6YnHcU87M=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=WIeGUN4HONeaJmSPGM2LuRQ+0//BCDXzs2Y127qtKqgM5qaSMyYKkFeIoIeQM65Ug
	 JGXAPSblZCTKl6KJNjh2JV8XAajwcXUbsxRYT7eehhp7F+9BLFdBahtus9AjGzg+gn
	 PYmPgkSYkTcatEZ2cC7QsF0rqhj4yCxGA8fOeLhYKa5cyoQ2+BrUuEqVOzZ7dnYvBn
	 bo4DrwNFBW1Iz2VzH3Qm+2EdZyxUXBuiH4pPXDNAzkLUvCHoEj40asOIvdjvvixPAF
	 w/EHLlmWuP3lkb7HJ+mkyHl/JnLdS5djL6NESCumPiDRGLDSxU7ENWpT3RDtELEeNb
	 39xL/z/4nSoLw==
Message-ID: <5b379992-ad9c-4f04-b710-b0e2c338c524@kernel.org>
Date: Tue, 3 Mar 2026 17:21:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 1/3] mm/page_alloc: effectively disable pcp with
 CONFIG_SMP=n
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>,
 Matthew Wilcox <willy@infradead.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
 <20260227-b4-pcp-locking-cleanup-v1-1-f7e22e603447@kernel.org>
 <5d5c8927-95ad-47c4-ae8c-9b56f5534e27@kernel.org>
In-Reply-To: <5d5c8927-95ad-47c4-ae8c-9b56f5534e27@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9104B1C000A
X-Stat-Signature: kwwhqk3sfnbwhptiuqhc6mjjaurymtka
X-Rspam-User: 
X-HE-Tag: 1772554925-547659
X-HE-Meta: U2FsdGVkX1+zFWv7kvYFwNoFzEctn9LT4dV/R8uyv6zBm/0hqq9zzk1kOLvuIqvJTE88i/A+/zsTPEgupgvO8+q9JT9/b/GEXiYhjxLWoTQQ7B28iDILXDL6o0PxKeGf9pmmeQ3EL3ZLp1SWkG2KWXSa7nwZsWsZv2PInRUy13Wot44IVWfI5VbwNahcTuu3gIrwXf3D0Cn2JwLCJ0lS/vG7YE7c/qat9U7XA8R5br91GI+HaBRzaqeSMUCq5DFbgJ16KT9gKUHztrWKeMCr2cZXKmRPf1pN0Z2K0ExOhf0CndBWe01w0FQkNHEcqHAMoo6TaUJj+gSLfshKwHuYZljjJwlkSlKZG3POnAqMpNqm/EZi5jOnrXy7V8FklCg0uQf1SIglor0vJQJkcewOPZKSbqILMEPiExnjhLWKITtCYj5JXnyPjTUefnxARISv3jVXvdT8h7ysgDR+aeXX8sXar4Bosxt9btWoZF40HqIpYF3sPr6V8ax7LqQbK+5kkspwRnjG+qKjmDFArK/IIJe+wCHoY92BqxzTgKrzbuUpHliZ5aaVC7UwKopoCOvKd65ODnEpyXrhTklfWcS8n6XXgmIvzAa/GmgZGnearIN4IDOQQBVGSKAF7SK4izJ/UlAlekWqsCE9aCWx3zLQlOeIyq2Qy/uHdFyUlxqMdJBDkC/hhf4DJ3K8RrpK7ixhI742/S1ntT3EP9gSz9U/yke9vNZUxHHriMvSNXvrxyM9qREY60boQJMhgxd1L7WwbG6vQi8lsZmV+yxI51C1wqo+nH4c4ukOp9xcxbzUGSyV0eN05iA19rTKafPfS85OkceXHRUnpkqsfPQBuCqfwvmQ7hCoLZ8x8BYpvRp0k/GkcVImDalCslE+yhbXxNjLlj1HzEJExSxpIuQwKoUu3vRluyPdQbQpl/+HP2V0CMnY31dUlpzHpx6Rg8D/FlMp1n/hCoj4MaFeaJapBLf
 AUmS5iO3
 0YpFjr1fAD08vedRL1bOLRMelBIqV6AtEfafCsm6IoHZSLbBbNsV835DWcJlIGWUkVw7Fqav7Q89/dZbJD03HCmQYjtiFkNOjN01eUTdZ5bZbO3hh+5v5Bg4d8AVzsvHW0vNZbTjUsQxoJKxC/lr+3w+x+M4GOCF3fsvmscPuCJKN+1lXKdJQIBQ4GrBF1mSYhyqkCyBYpknfo8luu8mwdvWI4EG+CW8a3poXoi659H9ilUDuNi91QjekqYOcsX6VpdfxG1XXQiORgYN+2YHZW+ZhRQRO5HYvr8bfKMr6pt7kI+iArfQEJ+yzqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 17:09, David Hildenbrand (Arm) wrote:
>> - * With the UP spinlock implementation, when we spin_lock(&pcp->lock) (for i.e.
>> - * a potentially remote cpu drain) and get interrupted by an operation that
>> - * attempts pcp_spin_trylock(), we can't rely on the trylock failure due to UP
>> - * spinlock assumptions making the trylock a no-op. So we have to turn that
>> - * spin_lock() to a spin_lock_irqsave(). This works because on UP there are no
>> - * remote cpu's so we can only be locking the only existing local one.
>> + * On CONFIG_SMP=n the UP implementation of spin_trylock() never fails and thus
>> + * is not compatible with our locking scheme. However we do not need pcp for
>> + * scalability in the first place, so just make all the trylocks fail and take
>> + * the slow path unconditionally.
>>   */
>> +#else
>> +#define pcp_spin_trylock(ptr)		\
>> +		NULL
>> +
>> +#define pcp_spin_unlock(ptr)		\
>> +		BUG_ON(1)
> 
> Did you try turning this into a BUILD_BUG() ?

I considered it, but was afraid it would work, until with some weird
compiler and arch/config it wouldn't.

> I'd assume that the compiler would optimize-out all dead code and
> consequently not trigger the BUILD_BUG.
> 
> if (pcp_spin_trylock()) {
> 	/* dead code */
> 	pcp_spin_unlock()
> }
> 
> IIUC, the trylock+unlock is not really split over multiple functions.

Some of the code is a bit more complex like in free_unref_folios() there's a
loop where early on is a check meant as a result from the previous iteration

                        if (pcp) {
                                pcp_spin_unlock(pcp);

and only later

                        pcp = pcp_spin_trylock(zone->per_cpu_pageset);


Also in free_frozen_page_commit() we enter locked but might unlock. Yes the
function should be eliminated as a whole, but again in free_unref_folios()
this is a bit complex...


