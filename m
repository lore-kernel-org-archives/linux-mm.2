Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42592C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A690B6B008A; Wed, 22 Jul 2026 03:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A606B008C; Wed, 22 Jul 2026 03:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CCA6B0092; Wed, 22 Jul 2026 03:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8296B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:37:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6B1F1403AB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:37:54 +0000 (UTC)
X-FDA: 85015608468.03.5D3A548
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id EEF90160003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:37:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NQPR/Ee9";
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784705873;
	b=pMMlE3EzWXHicvejOiOHMD7swqzksf3SJ7Ha8ykAgW8A/rk3RtMVv2AT3WJqh9n8sa4yb2
	UxeN9CiXWO54g63g86O8qrfYgZyWpnrDR/tH0KqT1QqiZ8PGs9S9ndQLxz7ZAUZXJlARGQ
	HyBbMMHMSneyfTLmAnPdH8S1ODxGbvo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NQPR/Ee9";
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784705873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U24GCfx2sgqLq5bIDDPFPYQnyCbGgMLuGoPpBXhl0dk=;
	b=UM3Xb/o17tOxt/MFDtuYehx895KK0UHslDroRWuqNR70goYzeRa1by3E9F9n7D5r2jO8mo
	zV4Ex0qQ36YHmQk9OIywyFT6a1PvC/YH0vNqMmu3BdzLTtVewmTveZFpBJOzvP4VKoMoEI
	ynZO/TzEIktLo7ug/xlIvitrrkB958E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2FD143EA1;
	Wed, 22 Jul 2026 07:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C8E1F000E9;
	Wed, 22 Jul 2026 07:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784705871;
	bh=U24GCfx2sgqLq5bIDDPFPYQnyCbGgMLuGoPpBXhl0dk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NQPR/Ee9a/6x9OQoqQYgsY4+nFDaOU/m18i16EdM4lqTrXI7F7ir8OFmMjrqH4DaL
	 ZLjByXVxvsQRyR6FbQVUSqsGL4Y2yUXe61fW3snJuAzJEd87C+zNiqNxaVKz9YwBFR
	 NGpz7tf5rYELlzxNg9+D7vO2IZ2asvbZFt34xKoX+hFJg2od3mf98ZNYWXCVDV2vOZ
	 Hrf24Yp4D9DIsizRzUVYgV20CXxcAcubvKE3q7ku622J/ypqFAYRvzsa7G4lA7ZdeW
	 7BNF+KPCPy3rpVlCe+Qx1Yx1bKLEFblduv9O09NeWGV9mMIHa72uzGuu3O5SGLkJt7
	 D5RnxLCiI2aOQ==
Message-ID: <c66cf308-943d-4fc3-ae84-e81bdbb384ec@kernel.org>
Date: Wed, 22 Jul 2026 09:37:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 2/8] mm/slab: handle the !allow_spin case
 in kfree_rcu_sheaf()
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
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-2-964e03c41a4e@kernel.org>
 <1d0d8021-62d2-4c42-a2a6-a7e8ce2f5d37@kernel.org>
 <0ce88f37-f231-4a00-b06b-95b0910c2db0@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <0ce88f37-f231-4a00-b06b-95b0910c2db0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EEF90160003
X-Stat-Signature: 48q5u8pgpmr1n66hnmcczrwqpwkoyyea
X-Rspam-User: 
X-HE-Tag: 1784705872-413292
X-HE-Meta: U2FsdGVkX1/GMTNCd7MkJIYNBhqIoS7LGzXBdiNROaygHuarJvEGhi6vzS4vuK+VcWOph+k+Zui5u8Gw22dYohfRAFWoMT8C/04UfCTh5nkff3aksll9A5WXUaliwAV0pmHXV5lSuoY8LoR1/Zc8G0DIUThdERmyCyoIHEKsmVfbPBrqfZraSylKvfhrzAUfzLIhUC/vBvxlPoYv7Hz7nKY1LfTLwQlJmqAZ2msSwucDYcZuGKcNHBE8h0ioNqXQGgsKZkFw3aTnkeUHl4lGmJfgdJdsIJQvegRDC9LpPDR9xbbfja79wZD1UYkdpVZG7ASa+E46nCVn+lSBMq0U5aQAs2Nrad5eOGruGQkI2yvEk5ZPVZyLjTSlskBk5ChMtDff71QHU39q4b4C+Lg4FeSwFI690gxGgxg2KMECmfd5LZTotNIgYJTxlG1VdLHET5qjSmeqYzOHzXjnC0KNVp67V3TYWm4/puWz3Y5Vz+tIKv7dcPh7iAdE/vQIkFxyk2jbv6sD49T66HH/1cjdOrVP4gzCRbXSf/FvPnCWeEA+Tvvx8IsKvuNBV3rO2zKqww2Gdk1iqFBB0aq8ryDiVuGsyJHbZL7n2xoRWK3rCF+cVnB+x9VE3m5tBenhAClSixfgJ0RBSF9wj85uXeNLS0ClrJ+6Gj7+FxchN2bCy2yx3hwaz8f8q8FSLrD083XykCQm0flu6HTvAAQU85cIitnAoU5plZI1iZQpP5T59op45QAAepdBoXgvSVf3618euaI/TSG3tMjA6sLKbWrRqrGDvdq0LqTVpHfaw/55oEIfG4tIetSGTtMP92oQCpx1Mf0GAAtkEMguWwcmwBCChLafpf2kKzCau+CN10WeQ8CJiBU84q1UkWKDRJT151FvBus+RHeVpztOTN5hZK8lz1idMEHKy/q4FaOqV6kjFjViz0FYdpROqdJ4pbGJNreR5WJszuk/fTGEiPApBmV
 h4c45CHz
 6TEyD0aBebZtVc9T0Zn0QB3ajfH7oJHzzAlqrRoiVPheEQDBcJ85ehevqkl2ZrSoSyP4j6gLwcrBHa/j6XmIPzkFSpy05Rpd76VeUseHtLJNM4OZk2viWF/5QIg+G00u6U/dTuDR/WeMCerUne146J9imn3oaRXYsWlorwsypzEOWLxHYkZktqSLW9cFirPEeW6uEqHVsZ2uHoCOOKKWBaPWfYpzXGFDZEcsdvVi8JXzDOVSkNRPus/oTGLIDG9iNjjgAimMNJRug2h3Akj4znL8zU3QZYBapDIYdAi6PXndX+UJJ/iSC9thpP1LX7/hsEn++JFD6xx95NltwdjqN1TX94hl/5PioQArQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 09:28, Harry Yoo wrote:
>> Nits below:
>> 
>>> ---
>>>  mm/slab.h        | 18 +++++++++++++++++-
>>>  mm/slab_common.c |  2 +-
>>>  mm/slub.c        | 36 ++++++++++++++++++++++++++++--------
>>>  3 files changed, 46 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/mm/slab.h b/mm/slab.h
>>> index 281a65233795..85ef2ebc9812 100644
>>> --- a/mm/slab.h
>>> +++ b/mm/slab.h
>>> @@ -429,7 +445,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
>>>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
>>>  }
>>>  
>>> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
>>> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags);
>>>  void flush_all_rcu_sheaves(void);
>>>  void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
>>>  
>>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>>> index b6426d7ceec9..e07b4e6d6679 100644
>>> --- a/mm/slab_common.c
>>> +++ b/mm/slab_common.c
>>> @@ -1605,7 +1605,7 @@ static bool kfree_rcu_sheaf(void *obj)
>>>  
>>>  	s = slab->slab_cache;
>>>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
>>> -		return __kfree_rcu_sheaf(s, obj);
>>> +		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
>>>  
>>>  	return false;
>>>  }
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index e32a68677537..0c350274fbff 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -2814,10 +2814,14 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
>>>  
>>>  	gfp &= ~OBJCGS_CLEAR_MASK;
>>>  
>>> +	if (alloc_flags & SLAB_ALLOC_NOLOCK)
>>> +		gfp &= ~__GFP_RECLAIM;
>> 
>> So in general we expect gfp and alloc flags to be compatible and warn if
>> they are not. This now performs an auto-adjustment, which makes it unusual.
> 
> That's fair.
> 
>> But AFAICS only one caller relies on it - __kfree_rcu_sheaf(). So maybe we
>> could just do it there?
> 
> Will do. I don't have strong preference on this.

Thanks!

>>>  	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
>>>  }
>>>  
>>> -static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>>> +static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>>> +			       bool allow_spin)
>> 
>> Why not free_flags instead of allow_spin? Since you already introduced them.
> 
> Indeed I tried that but gave up on doing that as part of series
> after realizing free_empty_sheaf() alone has 12 callers :)

Yeah but I meant __free_empty_sheaf() only. It's fine to leave the wrapper
without the new parameter for the most common case, like you did.

> But I think it's worth teaching those functions (including
> free_empty_sheaf()) to handle SLAB_ALLOC_* and SLAB_FREE_* flags
> rather than propagating allow_spin.

It doesn't have to be now :)

