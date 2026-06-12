Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72973CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 09:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3276B0005; Fri, 12 Jun 2026 05:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983F56B0088; Fri, 12 Jun 2026 05:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872AC6B008C; Fri, 12 Jun 2026 05:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7557D6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:51:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0B16140614
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:51:36 +0000 (UTC)
X-FDA: 84870793392.26.1626E33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 280B440002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:51:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PLzsp3J/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781257895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MR3Nw8sjwScRIdSTl9Z/KiQVTF3BEU9DliRE8cEHbyA=;
	b=tVibKxs+5+GQ+JtSLHpGstpoDmWODyGKFjdrhoAYpUcYQ4YoDe8EltMqyfK5EFJmmo+7P3
	xVKQYDwvmv/ZxHOsLexfcTigD4uD2kODnZykTdA0bsLfotw5yBysyat79xxie3diiThlsQ
	D3r0f2lCPWXa3zuV9R4aN8VFzG8qIhg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PLzsp3J/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781257895;
	b=l+4u8S3H/WlvlnkJzJvvZltP+HdnEEeeTU2FMc+pUQ96yVj86BYBugsS0ruZacVNbGZ0K9
	Jw6VNTtsjD+aiKF79kRFPLy+6kaa/t0DRm2BYznTeUzp3Zg1Ioww4dO3cd7SfnaeQMZzAp
	s/tG2pFoLW93FhX6V3Hylulbr2ihHdE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54FC643296;
	Fri, 12 Jun 2026 09:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E4D1F000E9;
	Fri, 12 Jun 2026 09:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781257894;
	bh=MR3Nw8sjwScRIdSTl9Z/KiQVTF3BEU9DliRE8cEHbyA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PLzsp3J/jZEh7s1xzkHzNuZh73Vi+B+RWXOOMdRE+vnrjxJzJi0PBhL76SbhSsYzV
	 kj/eyaTEJhqh6ZcV45gV/okAX5GnGhorSCFTLNKLRMQLc+4rBPydiA0Ajd02vPvfkv
	 dAbq5IJUoJ2YZDHzyooImVsVgj8RZOFIfFWuXBhyrQjrWHxDv4rnBAZ1Z/BaBgSneH
	 ff0PjhqswJ6SGyu+mzYCjhmr+bpvxvTZXO7N6zPfgXsSVrV4Xre7OLh2CsKgl0+CxS
	 LMCHHhyj1EwHxA+tF8cmR630TXZLtFzBju2KJBod9zORxcrdMSmEZgOBzTQ2Q+B0Nf
	 PpVhpgvVsruQg==
Message-ID: <3914c31f-c97e-4943-9f4f-630b05785014@kernel.org>
Date: Fri, 12 Jun 2026 11:51:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/16] mm/slab: introduce slab_alloc_context
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
 <ait21B7kqfT9XhOs@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ait21B7kqfT9XhOs@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 280B440002
X-Stat-Signature: mtjjz57dbbf64wwao8bd9c1i5kq6dfz9
X-HE-Tag: 1781257894-14734
X-HE-Meta: U2FsdGVkX1+7P2Yzor1/2+p4N9JSNKPeMV7ytBH0+k8ncky85OE11K5/s423EO+NPHz0XNCGRDCAQtnaVbRh02F3dBVr+0W9V1f9UhYeFPHcjFD2Ii+m60FJyREXLEZmxosYQJLWvqn9SoOpqEN+5ZTWxH9yl0TC//Mu1WWUkR78NmrgasUUh3dLHN6QCT0QCh7UA6x8snAobaOF4P0ux4PWS7+YYS/pbIr0yBd87PiYMscWK/+bBcLxu2eUWewIFwEV1PkC+PNZNI0JRLp0Jh4zvXJ/z47QE6CKdLtCUCSmIlT46fVbQM1QKglBdTAIs+hVvEDqOexP8lzENo5Nxt86vLUP4qNkOh4/mPqs9gOIy/ZygsZboD0Gtp92Hv4fRgVLs1Cx/RduXFk/Ycu4bPoBaM1O4yAu6a0mQ/mCpKEwPxZlynLH/0DoZtFuJiqRPpZMJ1Jeda/QlzIHc/0zljUrQIQ0cK/v//kbzdvwu69cWJMQuiJZGyiyNs7n35umnDczueDiYlmzZ31+aWROPmY6CNFS+xH30tVhnArXm4vrwFj/KG36EoazIFHfEsnq+A5JvV5i/dwF4Ke/PkFGXDwpw4hcb4/mDb+8qpv9YqJ3VyByF39nG0CBxAhB4CtGxo94KH6BJV3zGPIMdfWWq3j2+mP6Nzp6ob3k/2tvV4FHnxyybAuK/IaGTteUjxvdo6oW5YN5DF2V4VtiUOgp5KeB9erz8bfwB8ojAfFgmIykYKoSvZAiuxCB0tXkqmeBJo9zxH+Plqn2fSNn1ednNQpXuOQdwoyipB9pHIW1/0rALoEZ6xTQOH2c/m4/Es2+zahgfw1xY9fao8ISI8W1z4lMTy49pU5TqpuyLNLWeShz4+Yb2QLqNmhYZZ0OqP+bywkVvuShd4N9Izwkn/guyRiyuND2vQXRmX3/CoEWO+NwvP/VdwQ4eNXNVjV7dwUpM146xH1VHY75Qyts5CC
 /59BV4HL
 cwM2AvQPy6sEsmCC7EDR8dWAAQx2ChfdYtQEN/2wuncuCnED1X3jx6l4UmMN5qB06t4Qns9q+/2Bio2w3l35NwjHAdbaMwhyLl8of3EK0crWnsyfZFcPcApeLneT6CWYze3aZT2jFKBHGzcyMbPTcO0wlg+H/rQqxp3rWdCfEaJ66qkZFDa1IX4t+PRLqO7z69PXOexwU9TGPC3lhMoePlxqWDYYl7vJT8gFjbWaqsSHXB3cvSjfbllF7evXVMjnrW0F8CtlWuc6iFyqtAfkZVA/hnAEFR3KwQvSl7Qm730lg0n1PtY87h7hGZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 05:10, Hao Li wrote:
> On Wed, Jun 10, 2026 at 05:40:06PM +0200, Vlastimil Babka (SUSE) wrote:
>> @@ -5389,13 +5401,18 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>>  	if (ret)
>>  		goto success;
>>  
>> +	struct slab_alloc_context ac = {
>> +		.caller_addr = _RET_IP_,
>> +		.orig_size = orig_size,
>> +	};
> 
> It might be better to move this to the beginning of the function, to avoid
> patch09 jump to `success` before ac is initialized.

Hm right, didn't compilers actually complain about goto skipping over
declarations? But neither gcc nor clang do for me, hm. Will move, thanks.

>> +
>>  	/*
>>  	 * Do not call slab_alloc_node(), since trylock mode isn't
>>  	 * compatible with slab_pre_alloc_hook/should_failslab and
>>  	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
>>  	 * and slab_post_alloc_hook() directly.
>>  	 */
>> -	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, orig_size);
>> +	ret = __slab_alloc_node(s, alloc_gfp, node, &ac);
>>  
>>  	/*
>>  	 * It's possible we failed due to trylock as we preempted someone with
>> @@ -7237,10 +7254,13 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
>>  	int i;
>>  
>>  	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
>> +		struct slab_alloc_context ac = {
>> +			.caller_addr = _RET_IP_,
>> +			.orig_size = s->object_size,
>> +		};
>>  		for (i = 0; i < size; i++) {
>>  
>> -			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
>> -					     s->object_size);
>> +			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, &ac);
>>  			if (unlikely(!p[i]))
>>  				goto error;
>>  
>> 
>> -- 
>> 2.54.0
>> 


