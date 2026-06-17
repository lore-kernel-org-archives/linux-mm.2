Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C78CCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5654B6B0005; Wed, 17 Jun 2026 01:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FA66B0088; Wed, 17 Jun 2026 01:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FDD86B008A; Wed, 17 Jun 2026 01:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7C86B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:58:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84A2EC19F7
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:58:22 +0000 (UTC)
X-FDA: 84888349644.03.1C2CB5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CF6631C000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:58:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNB97Kz1;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781675900;
	b=A7d90sKnFYTtJn7VXnQiqe0XlEhv4AJs8vHAgf/Wxr9Mm7Jamwuatu/7hVK+1076YiHg++
	7cfRCY6Gc+WwqmLws5H8Vh1C0Sfnesif0zatyaBP2ITVVhPw15Dsgg2B2rSHyCgF4jHUYC
	HskmK0fNhec/0O8ymyU5HHidG4ec5PU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNB97Kz1;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781675900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0WnoCTe/WZyehgOrexh6SFggV7BqrfLheqjX/wcWBQ=;
	b=BdyK9haH2zMdMb5Mha6rKlGAetF3Yo8aIX7NipHhHRoP5BlkKFrs8ykPPvFyTloC1/FlSm
	uHDDG/yCvdFphCuRtFfgJR+ZNqFmaPWFs69a5QUCdSnH8vsOmlT+m2uLB9j0jrm/lQ8NNj
	ipKWb7fdEKkOnYFrDLdGQJ+T8yzl4Js=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CDF6600B0;
	Wed, 17 Jun 2026 05:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFC01F000E9;
	Wed, 17 Jun 2026 05:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781675899;
	bh=z0WnoCTe/WZyehgOrexh6SFggV7BqrfLheqjX/wcWBQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RNB97Kz10Ao2R5CDg1QEMage+MHmk+FqZV1XZM+AotUPoZ7KQ0Z5T+pzTAbTnxBw5
	 Akfag50v5nhbjm1byNozw58F4ZlGMykbL+FJ/uhH0h4DMspxgDIlxOYxE3JLkSpc/h
	 OCP+LwIwBY+uKtRjaZJTOxm/z8Iwe+7J2ylF2sIUs5MHx176pLyLiqq26IU8y11/db
	 PO5luUTpvTYJ4KwMD7OwhbSyZDFDTVGH+XZalYYyH0zD0z+iXWrvKWqMifdoSP6UTm
	 LtYwV5u6eqmFQXcGTCLD11o+wFeHPn4nIe/syIXpjCIOXx5om/rGxZpv14tdjXMhsl
	 i7aerDDOvFFEg==
Message-ID: <cda21b5a-b61b-430f-bb82-c6a4d1e7548a@kernel.org>
Date: Wed, 17 Jun 2026 07:58:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 3/9] mm/slab: handle the !allow_spin case in
 kfree_rcu_sheaf()
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-3-70a54f3775bb@kernel.org>
 <4d7ebcd5-f3b7-4c73-94f1-b7d3ac12a521@kernel.org>
 <e8940857-4f71-4a34-ad80-81584f7378c8@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <e8940857-4f71-4a34-ad80-81584f7378c8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CF6631C000A
X-Stat-Signature: 55z8zja84dyk6ci8q3prwizt68ze6k7d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781675900-297532
X-HE-Meta: U2FsdGVkX19Mr8kHlABc/Yp/uRJ5+NwKrfckbpnXO8s1wIFoqQ+XAn5U7lBzS1qZdFQGmlRZOCjXPyyiCZfjFqY5pFh/UXPBLXZTopv1rIIbfqC1NQw0IWmbXaVUAK/iahFO+Cm8GQG6UcQRH2jJXayxuaQiT+Bb8D2EEpEhVm2AaHRzSoyddHQOWVV6YHss6DyXf23wyHIbe4Uto55Rt0afRyucAurZlLHIJKnV42CYKn2lOS0jz+C25bw6oljUDzQrI4x8b7JtHqWjjkEmQ8jSmh+WDwbNChSfrH8P6vG0+f2ZvP0/JyWvDa6rCi80A8Tp29F9XLTg5KyeuJ4vVLiKP2xo+XLIsnL9lqzouiTWMnQbzXxNRby+hczR5r87sJ4rrERctU83UjRd0yVz8XM7fRmQlXRbI08qg1D0iOiAedurGcBsK85ESWQMYA1GaU/giCQCIEdZltERKm500pdsrghT8BBIBuOB9njVgt23CCfkRN6oiN3UUE0gQmxxbxyT+kT+IZ19FPhGwlrJw4eAVjS4pdo5lwKt1bcGFgqK6B493cIyzYKcbeF8vCroRZ+Fon5cPkPapusMJXmfw8nsxBP4hTUUF1GybQOGEZiTPybQzVUlACHeExi3MPratGifMGqLxX07cpU8fZ+7yneBvslIvL3SqroOoXMlGtVi3VvxalooGdiDqlBC1c5cb6hhnuOCvJ34s9BXkLkLuOQZ6hx8pbdyYiGTgc1oAmV463mFsL92yonaWfZyeMftxlJD9FwIOGzYMohn4u4GEcCJAbpKYcRPnTy/IFlo0Vl9MgA4TcEhMmTP2Cx4Z9CPrVJmfPdNgnMotXqlpfr4qL5CZQjBZ7i/O5tPauy2BBV1vcgnSqHTD46a4ePf47QJZfz9QzFUPE/+eCHNdpzsuN+kX7OA+yOcCnDppN2QcSPaWUa+Hfej/lnj9kjXkqMz8qSjMn90D4fZXXUTeTH
 y6EFDHBt
 3mvc/7DTbm9S9Tbaj7yyK3lag3RPrhedrLrtMU7g2ory7T0Ey+LVOrqDsqnJO/l4WCfOu/pACWdrFo8Bcx6wei6z0sJTxNxSisD81JXMmWPl6kamgtm5YK3C6K9AHd9m4oW0w9IkHww+hxeerS/4prmX7VCnXfx5aXy6E5K7VCggib9RUzHZG1espg0Pstq5o3popXR8WW4q776miWIvQjHUZaTgK5OkV3eDVAgGK1gEUpA82rYiR6sCgpl+iRM/I32dkuKPB+MxQ/8Y0+VZkJxtx3LYvqmDBzXhLQnMUTijHzIQriRP/d7GEKot6l3fjqZXUvAnEXHY29A2x2znb8ey9S0+s/jTkZog8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 07:32, Harry Yoo wrote:
>> Here we would get a sheaf with kmalloc_nolock() so that's ok even if it's
>> later freed by someone else by kfree(), right.
>> 
>>> +		}
>>> +
>>> +		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
>>>  
>>>  		if (!empty)
>>>  			goto fail;
>>>  
>>>  		if (!local_trylock(&s->cpu_sheaves->lock)) {
>>> -			barn_put_empty_sheaf(barn, empty);
>>> +			__free_empty_sheaf(s, empty, allow_spin);
>> 
>> Well we could still use the barn with allow_spin == true.
> 
> Initially I did
> 
> if (!__barn_put_empty_sheaf(barn, empty, allow_spin))
> 	__free_empty_sheaf(s, empty, allow_spin);
> 
> but I ended up just calling __free_empty_sheaf() because it's
> pretty rare to hit... no strong opinion though.

Yeah we can leave it simpler as it's rare.

>> But more crucially, here we might be freeing with kfree_nolock() a sheaf
>> from the barn previously allocated with kmalloc()?
> 
> Well, we don't release and reacquire the local lock when we got an empty
> sheaf from the barn, so it doesn't free the sheaf from the barn?
> 
> That was indeed very subtle and I got confused :D.
> 
> When we free a sheaf in this function, it's always allocated in current
> context?

Indeed! It's fine then.

>> Maybe we need to track if it's the case and defer-free it or something.
>> 
>> Also maybe there could be a wrapper kfree_maybe_nolock() (~better name?)
>> That means "I want to kfree safely in kfree_nolock() context something that
>> MIGHT have been kmalloc()"
>> And maybe depending on the debugging options that make kmalloc() ->
>> kfree_nolock() incompatible, if those are not enabled, it wouldn't have to
>> defer, but proceed normally?
> 
> But I really like the idea of supporting kmalloc() -> kfree_nolock(),
> and I think it's worth exploring that.

At least my confusion potentially lead to something good then :)

> Thanks!
> 


