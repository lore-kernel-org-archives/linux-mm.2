Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A74ACCF45BB
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923A56B0005; Mon, 12 Jan 2026 13:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905E96B0088; Mon, 12 Jan 2026 13:20:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831D36B0089; Mon, 12 Jan 2026 13:20:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 708DD6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:20:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D179C3264
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:20:54 +0000 (UTC)
X-FDA: 84324128028.09.7FF688A
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 53B0A40010
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:20:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v7YF24F1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mattbobrowski@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768242052; a=rsa-sha256;
	cv=none;
	b=KPB65M2/OIcWhG9kBv+YFDHCxIdpauC+8xUk0eL+U+fk3kZUiew1lsBXskHNcXgsOnGU4Z
	/ZZfJ9TzLo+JaNkMQcUs//sUXT+Ibuqvm99yZNpm68IUiMUI09SZr1MGBNSAzD/qLPPeDR
	lRqo46afZmTGGPgYS7wiQqoCOD63K0s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v7YF24F1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mattbobrowski@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768242052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XHGqVtaW8x0Sh1FjZrgxZJsIoNRNYfvhtGoAiQ9Qrc=;
	b=f/EVaYQPRLmwwqE1bF00oSrv1zX58WlRqxCLg2Z8dgpATAln8iTeBL37XoUMdlS7wgaiYG
	IHFUpFEv+P44599QWNwf/OTAyOZsV43i1YNzChLZpW5DzwZX4iPALkP8+dz5MOsY8XLPmE
	J3CaVrZpAVHFrEpRE15TTYWbKplFs20=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b86f81d8051so336455566b.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768242051; x=1768846851; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8XHGqVtaW8x0Sh1FjZrgxZJsIoNRNYfvhtGoAiQ9Qrc=;
        b=v7YF24F1ri1P4vsFL35QXkWoaKNjupAPwD5dyynfHZloc+n+PeDLrOeGzfq76xeOFP
         aIYgnedNRzvWFZDe32gZWyobUg1QqTRZBb2QG7Gab1g6rgvz2fzB8dsdgLwLLPmRQIkm
         qLbxVNhwlCYjPHI5mYeJCUyMVKKw4E0K2ZuBj0un7pely10EH1bMuPYKWyrb4iBDX+Hy
         G9/+iQb712FzmjZA7WBbiwGWJ64owne0rG2OIYQPu48zZHEf3oMRLK/RYDIRYwLLPKNa
         6sQGrUpOrQTiP5wCo+dLspm0+kzF+A8v2Qe4bbG/affqYjojK258hHCeCXxfX7va9Wky
         uVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242051; x=1768846851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8XHGqVtaW8x0Sh1FjZrgxZJsIoNRNYfvhtGoAiQ9Qrc=;
        b=PC4NgQ3ns8ZgTTtAAflmq9UPmtbYxSRb4xEzl+hj0ZoZ4i4ppQ7TXaJl+5SyDmaY8W
         mBWeVJhsLxUXX4O6PGW0MmABB2xHXp2FokwNRFA8+VOOjsGxStl5Q4VxEsxHNUHcMSru
         fZKiAeSNXke37GwLlXvDb4X9K4EYNHXIegUIGQ63ml7kpVHa3yYFdN85M66TintjGtJm
         3Ln8hqix0mkLXBIJULfLx9PT7ChEXXekiTgXzNP2dkzZfbKLZCWAIOs1RHP0DL3Hke4O
         /fNSkvFGoDV8JPUmoXs8X46qxwpw27LSmwnhgfD7ufpi9VTRlLFILoO5NMAekFunVUrO
         7QVg==
X-Forwarded-Encrypted: i=1; AJvYcCXcWEqwxgxdzJBwQqj9LQe3NwBtvglFFFMnA42mvjXDhsYr11ZzHzZ9wlEvso68ScjOfCDpHs8qGA==@kvack.org
X-Gm-Message-State: AOJu0YyKkeXw9SX6NpKN3ppGwccbljidQmKMWEObK2f/PvpTLNdwzccQ
	pXsvny46hzuf3w/L81NgzUyT4zHImgm/+3396Bw6M+WEXk72FGEG9G42WP5UX3/24g==
X-Gm-Gg: AY/fxX4ILCroMwYV64qEYf5NOrqTREFN0ILAmFVf8n5A/oRbEgW4NbXmVT34eMShNwS
	U8MOuSQN0El9BddjBnzyWiR+CBqFLLv7/8b2LERhv8x9p54cTShtWEVYXA7/ewVODV33ZE/SEyX
	zH/qEviCNI6HR2a3wa5+V8Xml47HDv1PXAH0jdKZAXa2D3anA5vfzc1KnMEv6Oh6MfTvw28abdE
	Iuud7MiO5jik+cOiOFwJZcYsLY3b6BmnkEZuGYDqmqe3BC24qYoHTrNz4dWFyU7XWi25M+msJvl
	OErqXdWu6qgJlMyq1KnExLcRKZzxT8Hf582ThkR5KZXL2bErA0ibJp2f8BRB+C8dbahziz+/FYZ
	GHcMZk1BRpYG4lpRP2dyqvt2Db+MtppiCO75W/mdlCqPpMUbtKsZlULXm4Mpg3xNB7+o2C/gx+c
	Hu0SJjxv1TIg3WPne27jBpSjZXw4NzlwR25w4CC8ihnYORug5Vzzj3KTxOPcRC3rh3
X-Received: by 2002:a17:906:d553:b0:b87:29ae:2b96 with SMTP id a640c23a62f3a-b87357dbad6mr34509066b.12.1768242050430;
        Mon, 12 Jan 2026 10:20:50 -0800 (PST)
Received: from google.com (14.59.147.34.bc.googleusercontent.com. [34.147.59.14])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86f1e95273sm752858966b.62.2026.01.12.10.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 10:20:50 -0800 (PST)
Date: Mon, 12 Jan 2026 18:20:46 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
Message-ID: <aWU7fnkQ5TLbAUmk@google.com>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-7-roman.gushchin@linux.dev>
 <aWULOvXrN0acG97Y@google.com>
 <87ecnusq7m.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecnusq7m.fsf@linux.dev>
X-Rspam-User: 
X-Stat-Signature: fbtof5zjx3fkidizhffhscuwue81jtzj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 53B0A40010
X-HE-Tag: 1768242052-210848
X-HE-Meta: U2FsdGVkX1/MiQOOKQlpaE0kxW+COxCd/il3iElD5gwbZVqQBD8JCMsX6Otg9AR2v81el+Rm/lGvq3ZMworrLNve93L3VCfVMfRbC6JMCqSMXBIXe/mjkNTcqClawa5j6MP8ieRdZeFHxcTQlUZ5F0kFQjOunnuWdCFf0kb1w1LMd3Fk37k87ZGhfZcSFFXbziJxwkzX3G4DCh8Tp7Uz38wigAX1xX9DluY/jNK/rz1i6XV8EHXEubzc7vEEpiYPes6QuRFMA0nbjcEadyda84XJyXuMeVrvsPHmf8h184NSQBGwzsq0wgG3mTif4fam03JvS4uM8WDAle9Fgkvu8WtDWAqa/mdUtnNuUulW785Rd3yjgZ5DngzISaqO2rZ2YhhVfW4LcUGuHdm6ZAZznc8iFzgcqCFpz+k9Jm2wAc6dRiuAT7mo7/djMgP1NwKYDOXIZNhIlf2j1l86G40UqSAt0dI7iSOl+WF9p9kppgtQs2bzKSpyKaB0ogC9jkBTtVEPCziGv72O+dwpwovdFplgr/GN2+wYuqyBzmnyr/vj5aQ+nUJcml09NmA65fVGzRaPR8fGC89any/5t1ILx2Kob7nB+VumKYxd1TVLKlf1lHejwMONF9BguwmW8ozkE2RnTk+1rgsmJnTy1oR1cbebjj13+A9kklE8WZIOBYOJ0K+ous7ZlWDKiHLdEZdC5s6OxPfU7k7AvJLrBhNnFbNE1d/YKAKj/UKjmXzgM1F2YE16vz2DcqSxHgXNVGCd+UWWl8Og74/JljUSQM0YaUbMniJJpMFr6Pompu08/8QgnJb+5IKOzKwxLA6acl/wstbpBCqzd2e7Ya2rboMYKK6VB5jHHBR11XJElsgKDo4TG6cjlf86jXeBHkjMtOuT6AbuJ2Yf9MlfNUz2/544ap5dMWj4tggMqwkouNgJGKkPPhLUod7Srbp4/f+Jc39BnADoBl4KpfbJ8H17NEM
 zz0exyr8
 aF8n7y8T2fl6VcgIIIsyxDNo34eV0eUWPIahr9mxVD5RTHq27xG3fKRg+v870DkGbOWYWuFU2wrWFzNrKa9v66OGkTjVTO+1iHDuBBQjsK3p8mzK8x9eBy0+OCt1om4RsFiG+fxHv56ZCksZK5VIvx5KJbb2MYsJmGZq/mlfqaarAOcHPSu9TI/nE5zzl+EbSfnda3y/pVLTQnMqxvzz2Gzv9/p44BlrkpjTo3Ol5yIyhiINf2Pq498NlGgoe1q7k0tTx8oM3+zTVpbYiDCWeYi3+mJw/aJHAJdSOIViKFGVuhoO4UaGwCut38EFg6Uv8aO6uWOYjvrKkBUlEA/d/Mb28D/wQ+RCZ/xnkF5+SMhPzW0kTUY1YYG5ab8lvXFe5jkPWxiEC/AMrQbirEy460VgZx/s58IwoqDTiltP5sWyLZyEV9F9XTkgt/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 09:20:13AM -0800, Roman Gushchin wrote:
> Matt Bobrowski <mattbobrowski@google.com> writes:
> 
> > On Mon, Oct 27, 2025 at 04:17:09PM -0700, Roman Gushchin wrote:
> >> Introduce a bpf struct ops for implementing custom OOM handling
> >> policies.
> >>
> >> ...
> >>
> >> +#ifdef CONFIG_MEMCG
> >> +	/* Find the nearest bpf_oom_ops traversing the cgroup tree upwards */
> >> +	for (memcg = oc->memcg; memcg; memcg = parent_mem_cgroup(memcg)) {
> >> +		bpf_oom_ops = READ_ONCE(memcg->bpf_oom);
> >> +		if (!bpf_oom_ops)
> >> +			continue;
> >> +
> >> +		/* Call BPF OOM handler */
> >> +		ret = bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
> >> +		if (ret && oc->bpf_memory_freed)
> >> +			goto exit;
> >
> > I have a question about the semantics of oc->bpf_memory_freed.
> >
> > Currently, it seems this flag is used to indicate that a BPF OOM
> > program has made forward progress by freeing some memory (i.e.,
> > bpf_oom_kill_process()), but if it's not set, it falls back to the
> > default in-kernel OOM killer.
> >
> > However, what if forward progress in some contexts means not freeing
> > memory? For example, in some bespoke container environments, the
> > policy might be to catch the OOM event and handle it gracefully by
> > raising the memory.limit_in_bytes on the affected memcg. In this kind
> > of resizing scenario, no memory would be freed, but the OOM event
> > would effectively be resolved.
> 
> I'd say we need to introduce a special kfunc which increases the limit
> and sets bpf_memory_freed. I think it's important to maintain safety
> guarantee, so that a faulty bpf program is not leading to the system
> being deadlocked on memory.

Yeah, I was thinking something along the same lines. We can always add
this kind of new BPF kfunc in at a later point, so need to directly
address this use case right now.

