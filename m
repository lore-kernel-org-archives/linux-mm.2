Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C79BCD29DF3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3B66B008A; Tue, 13 Jan 2026 04:32:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DA76B008C; Tue, 13 Jan 2026 04:32:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E746B0092; Tue, 13 Jan 2026 04:32:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14D986B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:32:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BB5D568B6
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:32:38 +0000 (UTC)
X-FDA: 84326425596.13.8285A10
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A49F1C0003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:32:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dtSqIOQ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GQDk8z3I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dtSqIOQ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GQDk8z3I;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768296756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ni5ivzvbOKwDsRa7XDDenum4lALdFzhgJFrmTN2UCmk=;
	b=npK9SR7YYQQg2mPutNSc6zqBV75v94soD4rqHftg6IokpPTCLaLDRTT06Gig5vDBvmQUsL
	o+d++Js0QcdOBxG7rPr4/hSt+tc+CWdByD8i9xjWe/951UWwbcV5ei7fKBgCFkkAzKqeyh
	Lebem3YMUtFH85FTEO96A5L7Ldh9V2A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dtSqIOQ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GQDk8z3I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dtSqIOQ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GQDk8z3I;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768296756; a=rsa-sha256;
	cv=none;
	b=NyTWM6S0Kyd7kc1GQXlpZzNTBS0R2jkhjTrdDju6AYhOTdSLUcsB2CgXcoQ811OtMowmLR
	CC+3apOC3LsT5nV6R7ueqSuSlE9l5akbJ6ugxqjfnB050S0o0Vzu1Lj+HkkHp6/nBkBStO
	sm0e0oyxKmtt3s561xrRUEvvlzrKZTY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6731E33681;
	Tue, 13 Jan 2026 09:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768296754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ni5ivzvbOKwDsRa7XDDenum4lALdFzhgJFrmTN2UCmk=;
	b=dtSqIOQ12BXFfKLtxgnjE/IaYiF4HHlDVb+m/teg9el5HNuos1q1kN2uceNn4zyG+ZM9zH
	jVfITQTPzpixoGFHmI6PsmzrJG8c8eLzLkT5qkK7dsZxILJfyaCpSxs/JVgfoyamK38VQp
	CzEiIi9YoYsf2S/mzQyR9zRqEabUzL0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768296754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ni5ivzvbOKwDsRa7XDDenum4lALdFzhgJFrmTN2UCmk=;
	b=GQDk8z3IRzKEh01tOAKI4OZ8y3unBKOZ7Nul5hsedpFDFPgTb0fro1bEnhvJjhe4nC+2At
	+/x5zsDoxHIiuMDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768296754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ni5ivzvbOKwDsRa7XDDenum4lALdFzhgJFrmTN2UCmk=;
	b=dtSqIOQ12BXFfKLtxgnjE/IaYiF4HHlDVb+m/teg9el5HNuos1q1kN2uceNn4zyG+ZM9zH
	jVfITQTPzpixoGFHmI6PsmzrJG8c8eLzLkT5qkK7dsZxILJfyaCpSxs/JVgfoyamK38VQp
	CzEiIi9YoYsf2S/mzQyR9zRqEabUzL0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768296754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ni5ivzvbOKwDsRa7XDDenum4lALdFzhgJFrmTN2UCmk=;
	b=GQDk8z3IRzKEh01tOAKI4OZ8y3unBKOZ7Nul5hsedpFDFPgTb0fro1bEnhvJjhe4nC+2At
	+/x5zsDoxHIiuMDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E3843EA63;
	Tue, 13 Jan 2026 09:32:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Eh3mEjIRZmnYNgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 09:32:34 +0000
Message-ID: <6e1f4acd-23f3-4a92-9212-65e11c9a7d1a@suse.cz>
Date: Tue, 13 Jan 2026 10:32:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 01/20] mm/slab: add rcu_barrier() to
 kvfree_rcu_barrier_on_cache()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-1-98225cfb50cf@suse.cz>
 <aWWpE-7R1eBF458i@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <aWWpE-7R1eBF458i@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gsa7ufwibxq9mc6oa4czmoyi7t7om9xd
X-Rspamd-Queue-Id: 3A49F1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768296756-961189
X-HE-Meta: U2FsdGVkX1//fpkHsoljAPH2Pji42F2qljwqOJSzm0+D7tL0z/341Lq+zWf7uGoJaj0mo7Uog8ay2C4FL6Ms1KrAEtIZGkdSQZIVkymZCi0mTvRFfvtuq3JUjNr4t5P2LKixGeKygFXTeqZbZChfABNN5pZVz1KQ31aiquV2jEwE/y0AEdWph1eMgLyezcq5h8H1tRcX0puuBOq4bGz22rqoKn2/raL3l8m5M0Gi9sqUUtsggQe4M1ILybyM3y4JX2oH4SNzGZGoD7HmvBEJm/zYvsiIQUaX7JkJ9+cAIjXOu8dOkGLakT1Re1uyJLzgVIIikzvXxqs5TUn6R04iEEgYZ9ExIgxmGBwViavE1VOtqUtFaSADXtA9knGWSVqZZOoUZ/+hF0gOl3S9DpuXWEln9cIIgrX7cRMUdDVZuNC2kb9RrQkxI/Cj3CC57tyfyV6vAu7sSlFIB9PttwnK71kzq7GBOLb0aQE9Tvp4jjPjL1tXnucjcPHfAAaybtxnievkW+jM73MXd2JyhdW6eHNGRod/c/EYLYupgWRHeFsVtXYqRhzp8a/agclvg9pS6z/I8BuhHqT82n6S6RXUcmODE/NEobxUFcA9WKuP4hoWB+i1olV4lymhF9IuUMzpMrjxmrJXfD93t63bJ+jkuincb8gRO3DXyjacwPP54vGUc8pRLjVSkhVWWc/ESgaCjCroGczurT7b75mPGAsdwVaBvpSSk+CPRTnQK5BjANlilBl2nPYUAU7AtyTk8F0+OlilwX/hMzfo7grq7Kc5MICnJWPmBvSAtCdciL+iDrn9GIDvQzcRkriVcs33voMMOVTjznTy9uTUhRP/T8Vfmbu0qilRp6LsY9ez9XD5gsTfSSxRZHtl8sku+MqxPJAtesi0fhzn8+qYhzZBWBpGghsa9wZngKzG+kbn9BhAZV+wZPbYlVh1gu/4EEtJMEMPBPaG+YkgUlqNdBNsiiI
 v9lYF8cO
 8Fk0bibpT6E32x4cAnwkRjz3M/uUCE/UixKW74joUHq+JQJyYNnSdokHlvqeFGv/j4At7EvfCf/+9bj5vPkONxv2fLqsKsi+zPjNf/NTq/o2mDljBVNDymYP+azDqg18L5b/TmNfYPLrgayuNgfdmo5NEFkYN4TPuetknFfnONz/g+EqUQeDgAXW7PR5eB80wQIiBQWE+AkE3+oPnp7SL8xUGiJ846j3A1kILKkq0t+okapzwS+JSQ3IWoXlkvtuc3DQ6LLlI/uGSPargK00713G0X5h4RnLdIzp/erpmgahgYvBiNpIRg3NhHwuuxUamS/1KeoyKi1nZLKtzbUcAj/hdIPOQaSzCKnwKUjZv+G9++4DIszUZn5l5JK3TV7/m1oYw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 3:08 AM, Harry Yoo wrote:
> On Mon, Jan 12, 2026 at 04:16:55PM +0100, Vlastimil Babka wrote:
>> After we submit the rcu_free sheaves to call_rcu() we need to make sure
>> the rcu callbacks complete. kvfree_rcu_barrier() does that via
>> flush_all_rcu_sheaves() but kvfree_rcu_barrier_on_cache() doesn't. Fix
>> that.
> 
> Oops, my bad.
> 
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Closes: https://lore.kernel.org/oe-lkp/202601121442.c530bed3-lkp@intel.com
>> Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> The fix looks good to me, but I wonder why
> `if (s->sheaf_capacity) rcu_barrier();` in __kmem_cache_shutdown()
> didn't prevent the bug from happening?

Hmm good point, didn't notice it's there.

I think it doesn't help because it happens only after
flush_all_cpus_locked(). And the callback from rcu_free_sheaf_nobarn()
will do sheaf_flush_unused() and end up installing the cpu slab again.

Because the bot flagged commit "slab: add sheaves to most caches" where
cpu slabs still exist. It's thus possible that with the full series, the
bug is gone. But we should prevent it upfront anyway. The rcu_barrier()
in __kmem_cache_shutdown() however is probably unnecessary then and we
can remove it, right?

>>  mm/slab_common.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index eed7ea556cb1..ee994ec7f251 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -2133,8 +2133,11 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>>   */
>>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>>  {
>> -	if (s->cpu_sheaves)
>> +	if (s->cpu_sheaves) {
>>  		flush_rcu_sheaves_on_cache(s);
>> +		rcu_barrier();
>> +	}
>> +
>>  	/*
>>  	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
>>  	 * on a specific slab cache.
>>
>> -- 
>> 2.52.0
>>
> 


