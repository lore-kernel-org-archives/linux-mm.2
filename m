Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735D1C5AD46
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 17:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E9A6B0088; Fri, 20 Feb 2026 12:58:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC076B0089; Fri, 20 Feb 2026 12:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8695A6B008A; Fri, 20 Feb 2026 12:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8A36B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:58:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CF721B4DB8
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:58:16 +0000 (UTC)
X-FDA: 84465594192.17.BCC57BE
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id C67794000B
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:58:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Uxtq7NOK;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771610294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjc7Lf5ark/1hfgAzfJZnbueKXyvbrGroEnzxtDEvpw=;
	b=h+jm1fSGpOT90lxYmJVW541lcomJ/MDW+4YCKd8xtcGmCAgOYtGdn5jI++0S7ddEdudgDr
	UEdwkMCAeuvNu9YHKISaFknrkk2WbTiuYL776UqQOrfVNopZ9aF2xTlr27iJjO92jjaoLH
	Mq+Y7aQ7gxSc70gTQDotn1WLoGQqwV0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Uxtq7NOK;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771610294; a=rsa-sha256;
	cv=none;
	b=5yh1D4hTtROeT13wFiJWY3ovT99eY55/6V5nnXSLVKRmG66qAoSfH7k9IiT4h+2pf/ZbfV
	9tKvHIWrUfmvzizdG9bn5w0Ba5THVMKJgg7VePkhGAcXK2fVXWhfJ6+Rbynpy/9MwudYw6
	ySLdavXrQNnnjYVAf+mrVQjYZwwoUnA=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4836d541968so2204055e9.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771610292; x=1772215092; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qjc7Lf5ark/1hfgAzfJZnbueKXyvbrGroEnzxtDEvpw=;
        b=Uxtq7NOKUlowyIFEVTd0ISkJhmsdOSNPjMjHjyXatYHSWV8h+gY+VJKiieB9FuchMs
         ZvsjjN49VflcdxIxJ/en8Fd12s4Yew5KbPT2XRpUD25lEzu+xDytov2jHaK6zbZzRrbe
         gYg8KKjl5OkAwvauPSJl920q7pHqwfOxT0msU0L6toC3sQTQka5RcNM4tNLJm56crp1n
         A70uS3yPGcBOiLKWDG+cT1dhz8ZYoh7IrF5qR+6j8+poRnybD+nVRjEgO2ivPI3B+0OV
         POqHvxO120IRZtu1uC+mN1Lk/yPOyxjxc+57wGcpPzDbtnIOfOo+CnCzEcLNvoJN4LyJ
         IquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771610292; x=1772215092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjc7Lf5ark/1hfgAzfJZnbueKXyvbrGroEnzxtDEvpw=;
        b=PfGNN+CD/boPm+qgAh+floCJBNFWdKHNIWnjW+2XQbOIA6qHDH8KN26HSba3nzwwS7
         f6CL1h8cj9vNjFjzXIHGnCOGjHe0gdzpB6vk3iVAMWz1J1o2ZDDyQa3IxxhJLOHCQuTT
         izcTTpbRy+s38xbqUdPDYRTC5MyvAHJkBZP8f1qCfduCmwa1d5ceCZpT73Ngn9D+WNjm
         g2f24EUkj19lT3EZ5I3c7GHEPzwRsB8io00f9mQwqP7pc70f+71slB29CsYaGXd8/+3W
         lr1yzOixAal8FDCXk28FXN/yh0zeDRXyMXrD3RzW2LHXmj1xJOrcoyJJRwB7F7fb+nlT
         h7jA==
X-Forwarded-Encrypted: i=1; AJvYcCV6YVeD9JVgBxn8gSUZoakwBYYGYGRPKufNUx2FOnKSiIRDibIbeB19ujcA4QQ2+hlw465w9Znpgg==@kvack.org
X-Gm-Message-State: AOJu0YyEXL6P3JH7fvSDV6+gn2CMDE74I9spYj2fsBJqkWbFlvZwRZcZ
	dyN41dIsvCVIIlrZ7hOxXgvEzAZXJ3ySens1gzBXqYAJGQUWahW8tCZGx0N8IScilRI=
X-Gm-Gg: AZuq6aIkrsPCHE+GTk+qAJ3obevbmiEi6eWzj9CoGApn7PjOZmhuhpLTbYJMdNJMG30
	Uuf9ofFXJcZ+dn//dIBEj5JgXiSDRn7qXJrFI4yIZKnzUF9sjjGr4EZyska0tYo0a0AnPJTmarJ
	rLg21lQW0BowcgGZS6kMuiOdO3J+9L5Q5juEKGogEOCzv0v67SOZU2n3QbfO5hW8KpJoHm9cFQK
	ecbcj9I/WwtWph06VopD/NwZ0pgbXn5HeVVn6aK6UgPVeaG0jV2L53rPYCd9zevVg0gPz25wDi3
	yb53GMQW7ag1Y2uDEnzmfOpzDBt+5BKrTPppEQs3gqfcdIh09r7DSfkVa9Iqsm877cYuoD+sUbK
	6v/8e3Ki9rRRrP7gogAbTdswTrx4tgoR6lSwr7S9ZLsOYx3PdlRxxrwHtX+FVIu651FO43Pb2lg
	N7K85Njk8xput1G1bxOQ==
X-Received: by 2002:a05:600c:6218:b0:47d:3ffa:9838 with SMTP id 5b1f17b1804b1-483a95eb914mr3579945e9.1.1771610292057;
        Fri, 20 Feb 2026 09:58:12 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31c56d8sm134807145e9.8.2026.02.20.09.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 09:58:11 -0800 (PST)
Message-ID: <a1c11a09-da88-4edd-9571-0f792b59e9c3@suse.com>
Date: Fri, 20 Feb 2026 18:58:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Content-Language: en-US
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Leonardo Bras <leobras@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Waiman Long <longman@redhat.com>,
 Boqun Feng <boqun.feng@gmail.com>, Frederic Weisbecker <fweisbecker@suse.de>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad> <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
 <aZibbYH7yrDZlnJh@tpad>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <aZibbYH7yrDZlnJh@tpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C67794000B
X-Rspamd-Server: rspam02
X-Stat-Signature: hrhrizhigr7oqkxnaabwjscim7it8cqh
X-HE-Tag: 1771610293-654219
X-HE-Meta: U2FsdGVkX19U07Q8MVrNfUWDaNPSy1iQbB7lLcRncFhZ44BE3N3PLk7mxlD1ESQb6hllBtJqI8+S3fzjL6yrMs6pdk0nryL/y5LhsAdYTIELP6zVnYwYjrN4EuQbCTJf/wF2zT+hrm5YHIEhxOiFEG1hP9sqOR3dJv+VzB9JmVB1JISei7qF/4CtBxw0uB/iPIJQeBAXcGdQHGGConQ/fOl+xqQF2Uk+IffcsX4WyaoCuyrGBVQMwzj1Lfiw9Q+YxZkLe3mFN+1m6v6SoPtnNTkYk95P6y+pjGeqvefy68IGTknt1laCs0k1vn2BhAirA53NW2triUCCdJ1d19jpJb7r1UR4SgKAhC5WqlKjuFLLFtUSN2aFlVRfotQ4OhHqzw2ANi+hHmTr2BACz8/0EZOhumy/E5JlF0dcY5H6aJfsArsXfBw3TlGMWj5XR4zqlFoVT5l2rzZp2E541gyiGvpBn792cZyO0dKc+MYk0KHpLa9Q83v52u0UzlpOTB6cpwr2I01q40lEwueeMcGc75K4e815v3RU7Y96NWX72xJ+f8CgSvid3YgwNixd/zlAzNwv3B8yhcWMBCZCWkAoAfH4Nbck1Fc1Rt9zu0EAe2WFt0bTIX0LxUNUxXxgMIJyCOXqBG6LAFQaQ22brMNWBe8jOiAi0x25vbXfVLJ5A4zRyG/ANg+rb+Ur3QEG8AJ4SO9cwH54nzWfaH+l1kyEqlijelMJ5wW7V0mK1KWYnmIhtY1EdYW3eRE2wJQTm5xyunD041g0H4hVifYHkn9DlhOUSw4364SVYLBqDmKiorcKJU/I0y6E4m0CWWwIdamBg7F/EmGcdZFYfepqwipkwgKsbjDN20A/RTY1Ig0ustyt2IwtIh0+c1aJIFP2vGe6Nj/fEs5LTBxOEEHq7+9tp72Yc5PKX/blwkTqFtaiHs5n7XSKlnAGfrnvqsjMXx7rTJEodBlyDqTt10bIt/Y
 R8qYc2In
 iLf73u34cfWEOIxT9JJ6bGjmrZeOVcQBI7Js/FLl7UlqtWcxLa6pKw/Z8MiMi2L6awWEKFx1ef46o2JRgHkih/3i+R2RLqxWLU9Kes8GvQKflXqDw9SlN34LU6w1jE4dyB8QU0k8z0dEFAarv6Wk5l7r61ns5AOZj69MXNNRWR+Lnu2rTUoMn3NbGO/J5iqR1WiIIN/XVjHaQZpiBNDk6ML4TcvDgCNltgd0pq+bqN09xVBnPDtL9oORqDbfALPrt7PlfOW2z/u4cp5XR/0SoSsGl1Bkh8hv3ZALXqlsccAn/xTHKEQ/f5izIhhtnQHTiIbOY1hlAxZG/8iaiJV6qRkbEjK7NL8bIqdslg8VCOgjEgOE5RO3IPCJp33Fsa987YJ1aUuKtBMwTzqiSMUJVDoOkrkyoYea0CyJv5PdbJ0CTk8yyFurjhWRf+4XkbJslfCj1h42PtWbGTX8NpNeeUvPDJKXq7t70pdo2WsCl+aF0Wcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/20/26 18:35, Marcelo Tosatti wrote:
> 
> Only call rcu_free_sheaf_nobarn if pcs->rcu_free is not NULL.
> 
> So it seems safe?

I guess it is.

>> How would this work with houskeeping on return to userspace approach?
>> 
>> - Would we just walk the list of all caches to flush them? could be
>> expensive. Would we somehow note only those that need it? That would make
>> the fast paths do something extra?
>> 
>> - If some other CPU executed kmem_cache_destroy(), it would have to wait for
>> the isolated cpu returning to userspace. Do we have the means for
>> synchronizing on that? Would that risk a deadlock? We used to have a
>> deferred finishing of the destroy for other reasons but were glad to get rid
>> of it when it was possible, now it might be necessary to revive it?
> 
> I don't think you can expect system calls to return to userspace in 
> a given amount of time. Could be in kernel mode for long periods of
> time.
> 
>> How would this work with QPW?
>> 
>> - probably fast paths more expensive due to spin lock vs local_trylock_t
>> 
>> - flush_rcu_sheaves_on_cache() needs to be solved safely (see above)
>> 
>> What if we avoid percpu sheaves completely on isolated cpus and instead
>> allocate/free using the slowpaths?
>> 
>> - It could probably be achieved without affecting fastpaths, as we already
>> handle bootstrap without sheaves, so it's implemented in a way to not affect
>> fastpaths.
>> 
>> - Would it slow the isolcpu workloads down too much when they do a syscall?
>>   - compared to "houskeeping on return to userspace" flushing, maybe not?
>> Because in that case the syscall starts with sheaves flushed from previous
>> return, it has to do something expensive to get the initial sheaf, then
>> maybe will use only on or few objects, then on return has to flush
>> everything. Likely the slowpath might be faster, unless it allocates/frees
>> many objects from the same cache.
>>   - compared to QPW - it would be slower as QPW would mostly retain sheaves
>> populated, the need for flushes should be very rare
>> 
>> So if we can assume that workloads on isolated cpus make syscalls only
>> rarely, and when they do they can tolerate them being slower, I think the
>> "avoid sheaves on isolated cpus" would be the best way here.
> 
> I am not sure its safe to assume that. Ask Gemini about isolcpus use
> cases and:

I don't think it's answering the question about syscalls. But didn't read
too closely given the nature of it.

> 
> For example, AF_XDP bypass uses system calls (and wants isolcpus):
> 
> https://www.quantvps.com/blog/kernel-bypass-in-hft?srsltid=AfmBOoryeSxuuZjzTJIC9O-Ag8x4gSwjs-V4Xukm2wQpGmwDJ6t4szuE

Didn't spot system calls mentioned TBH.


