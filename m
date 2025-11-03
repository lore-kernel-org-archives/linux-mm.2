Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4F3CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 19:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E933D8E0090; Mon,  3 Nov 2025 14:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A1B8E0063; Mon,  3 Nov 2025 14:00:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6628E0090; Mon,  3 Nov 2025 14:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5ECD8E0063
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:00:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6982A12B228
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:00:14 +0000 (UTC)
X-FDA: 84070211148.11.004169C
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 583051C0016
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:00:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CLaYvhvb;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762196412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJ3N2WUq/UZ5e0T22UvDFgeGGC9bQkna+j2RgD0j4rQ=;
	b=YmDNRXNf5TE+t/qWiYhDOn0qlOkS0Ih3Rvtv0WlUoiMQj7Mpcb+iOrtGEVrbilEymPtiv3
	oyEleq5AQOlS81nOC920A1UtWB7FbNuE39kF2pHEgd/yfhv8hoj9vrhQCotN8iKfs6WFcf
	0Le4sr+8NjUgmEnQGOd/iYP9ZDsc4aQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CLaYvhvb;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762196412; a=rsa-sha256;
	cv=none;
	b=rMji5DukuggfOqmMDmYjlOaa8M6G35YGJuiZvA4DTcaFpR87x2fQfj1Tux3txoEEAUGGvk
	pFJYvmID5vw2JTFyxF+FcjBv5EIKrJZQbn4p0kEzU3ZibWMPtibE1U9OfZugIKyJJkGBww
	kmQEW52jL99ePzBQSzVyeTSaIJIsZoc=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b626a4cd9d6so698345966b.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 11:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762196411; x=1762801211; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QJ3N2WUq/UZ5e0T22UvDFgeGGC9bQkna+j2RgD0j4rQ=;
        b=CLaYvhvbEyIjK5kbWHfvQI4Pfaywkvl3rHjAxA2BhSDsTyAl48m1CxJpMCWK3mse0g
         VckiUosm5lOU90RiF8gIBO2Ql7U/qTIylTY93fueyjPUUAfuVbnDCOeD+6RPB0KyEAP1
         0EeSRfJCXnd/vuKCfZAlzZ+RcRh+LAHZ4AWR8FoWi7wvTmgaT0pIgrn8BFsjE5Sguh0Q
         e1LYhUfv5Z23wS1vwicTs9LEKCowPynYrrEcwTNEhSNtBS8S1eOkAM97xxG1Vsu1vGPC
         ishzUeqVIYs+2jBzzlu4LpSXSw1qd9fzJNnUtXMjLR4hpyrAFPkqzmVq+NRJWQ0qqW0I
         PtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762196411; x=1762801211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJ3N2WUq/UZ5e0T22UvDFgeGGC9bQkna+j2RgD0j4rQ=;
        b=FLZW42gQF2DqPLej/owJ1V2f2uONX23T01Am4CHMc8KNPWPqi72OiYjhlWeBRdYCZT
         eX85XjI3dht05YGwA9DmzIlTcsgV6FDbTYpD9HhUCvECFY8WetLtUp/ps3ACJ83SQqa9
         JwRmDOXFWyCsNnJXj8ulddS8aHzwq3vyw8wCjRgckxP7qgBvh9JPtCv9elmNiHHOTMII
         oGdRExuHG3gsd7V6dr2uGJiQkd2yiQKpIDSMOdPke1J2EOTJAvJFXQ0WXbQ9sdNJtRy8
         uKJ6Ou6jDW+X3T/loURLA+TK6bRPkXKbzmleNDb7hqBcYoeFJvFZQvrE/UDoGFap19U2
         RVDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBCB2cl9s/74iHnnWAjiww40QEb9AQ6VpvemMT/VRSWaR9zYEUohEivn/EdCy9i2Nay6/o5bCgZw==@kvack.org
X-Gm-Message-State: AOJu0YyewEcW8K0UmCeKiqUB7uAcSESL4Fg90FiFqTpjkhgZIcZFJHMf
	nRgo5/butjxUQ8zh9KqAh+wpnlgy6yJbIttmZjg4T+1hxv1GLJpt4zy9aLZGSsyvUKY=
X-Gm-Gg: ASbGnctGAb5sltjprlJ25fKqvsRzUmGpWQxdhyr42y5JUt1x/Vk73NzdPgfLRFtJC7r
	UeZibWMrXJJ/34GsI7N0t7jImOkcIR9ybnd8NavhGd6ygR+ioM6d1dac4DP2BMcs/5UdfSE6n7l
	j4Txh7TrmSbBhBaPoZXpR7y9o4iQCgyh/LYwj7riAaoRQtOwUr33WKl/zt5Dnd3F82Hzswf7pNl
	vhagt8XSebaq3Q3AogtmNvOoCWcBse/3mYpH9dkOwwiwi6nU2WZNuc9jPlSNS5gV+H0w8vZSYc4
	0QnUSLQRVQoAhOWUMu+sD9XmJ9nhwVCJgDryn/RCbSrUOpi+ODkt2X4o7SMNXkuyFvVAQ4YHtwh
	Dgxz1yPC8DhCTUItSUBVGOZnk3XUNK4IvaeG8QUEBCMsSt31cRyC4S8EtcQm+za45dkV5i9zwK0
	uqqGXSdeF73yCAoI3WGAXQM5S6
X-Google-Smtp-Source: AGHT+IFhQXFPVDqHyarWQQ7R2subtRafoxgNsFUzIvYeodwBNh8qSwx6VEdKXz8J8S7jSfx/fTTE1Q==
X-Received: by 2002:a17:906:ad0:b0:b70:a982:ad71 with SMTP id a640c23a62f3a-b70a982f501mr457990366b.33.1762196410649;
        Mon, 03 Nov 2025 11:00:10 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077ce927csm1117305366b.63.2025.11.03.11.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 11:00:10 -0800 (PST)
Date: Mon, 3 Nov 2025 20:00:09 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
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
Message-ID: <aQj7uRjz668NNrm_@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-7-roman.gushchin@linux.dev>
 <aQR7HIiQ82Ye2UfA@tiehlicka>
 <875xbsglra.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xbsglra.fsf@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 583051C0016
X-Stat-Signature: e53oai6t791e5dejinfxmgtukrhe8kh5
X-Rspam-User: 
X-HE-Tag: 1762196412-25977
X-HE-Meta: U2FsdGVkX1/ktwclAktLthzHDzWqasj8gcy8/KB1FbinRz9SOJD7zDy6TmR5fGNqyS6H1XJNGlANqBBoEdJLRl1RfPWxD/3LjTc1mKqLZfm0bTDHeoAuSZFkMb+07KPnv9c+YdRVlUgh/AJgsHASqwelyCpY5Six/c829l3UfkfUM3dYCttdd2KNeNYPT/MOqsde6ZoTERUkAHq4sGhoqU2nYP2PW4RyGXCKHTT3WmGKfkLAS8bskCq3S+VuMRk8+wx7S0mVaOsth211tu9OCp72mPihcauiCjHqY7EBqSM+09am7zmbaMft17C4m+VO2e56F0/c3PpbjZMGnB3c8uLHXJL3hpCjk5dWs6vqs2HOYQKANPoDzEXI0yfIU5NXzN6Nz8FWNQAkb//Np1RrQCF8xn9PdA1bXovF/NsxAsnEO0xvlEtSZT2BGMFuDzVmxTGcoCpqNdfF0roOY38uywoYc34n4UFNK/t79MtQiSV2ChePYA2KuN5EtvZ4iGMOJjOktCJHe467pRiqW1F1GrDTgrlhbENpnps2eaU3XgsawM+DdOAJyAnCYqV8pQMLCU1GgDQsBg1tRnzHoyxhiWe7xoWID0WBYWvDn8mtfdSWjPE6c6NpYT2UFnxXHODerkmnCTImvZqslNs8pLmmXh6bN0d9s0uZUGTOwe5NCzXIhmuRSIEy7VkPTtbA8ZUNEOfIVmDG31VZizbQAXMWKZeFnEs+6Z3U0Oen2joCoxwmlGLocF1O/vncIBmdTRrVJ/JwRCIzSTBZt1J8ZsCR3kwYkirySSVKond2tyiy12TsfBz/Eii1EiH2n83Iz/F+UDpklCCEO/7DcqNECvCCCbMdIKOzxuL7SgS/DVCwciM+PB4lfLecHVZA61xeLNCHl6B0cMMFRpQ5NOOjd8ypH0FuT6VHfow68KuA6JbYX8LXkEf4RVQuUO/U8TBtZ/3QGdRt1OXmS5/YH0JrVTN
 Sz8R99wa
 2ek79cDbNqZBW+QcuhyQ1KdaAnj+MOsxnhg+N5RmlfOPBXuM3+B424CR/cd+KSk6seehCMfRY5B7WJWBgMlHltZEyhsk2jWUDbmXo+pnDCgNsfDgqTUufE5Z7UndUEYQybYTnySMSWJlURIi9b8x27K0elJqZA8ZaDo8Rc7gaXF9hviICMLtw+DoXHJc81RPq2655Xrp6ZEvWN6ZUcSoPiV4rv2IjCT4yLFL2bHR9OaWeKh1H4ritxeZTF1mS+HlaK2AxjmU6iR7D12u0Ghz6XVs128qw73RbYXSBvGvMj/U3bbxrVeYzgHdkwyBl7lvL19hsMxCiecyW537TeizDBG7U0Eyjdw/4vRxixRmXgLbsvODgwh0lVE7ZD80SVGoNjI7dVdy/6ViJcpg2Kb4zcZFXUz/TNZfjTRJ8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 02-11-25 13:36:25, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Mon 27-10-25 16:17:09, Roman Gushchin wrote:
> >> Introduce a bpf struct ops for implementing custom OOM handling
> >> policies.
> >> 
> >> It's possible to load one bpf_oom_ops for the system and one
> >> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
> >> cgroup tree is traversed from the OOM'ing memcg up to the root and
> >> corresponding BPF OOM handlers are executed until some memory is
> >> freed. If no memory is freed, the kernel OOM killer is invoked.
> >
> > Do you have any usecase in mind where parent memcg oom handler decides
> > to not kill or cannot kill anything and hand over upwards in the
> > hierarchy?
> 
> I believe that in most cases bpf handlers will handle ooms themselves,
> but because strictly speaking I don't have control over what bpf
> programs do or do not, the kernel should provide the fallback mechanism.
> This is a common practice with bpf, e.g. sched_ext falls back to
> CFS/EEVDF in case something is wrong.

We do have fallback mechanism - the kernel oom handling. For that we do
not need to pass to parent handler. Please not that I am not opposing
this but I would like to understand thinking behind and hopefully start
with a simpler model and then extend it later than go with a more
complex one initially and then corner ourselves with weird side
effects.
 
> Specifically to OOM case, I believe someone might want to use bpf
> programs just for monitoring/collecting some information, without
> trying to actually free some memory.
> 
> >> The struct ops provides the bpf_handle_out_of_memory() callback,
> >> which expected to return 1 if it was able to free some memory and 0
> >> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
> >> field of the oom_control structure, which is expected to be set by
> >> kfuncs suitable for releasing memory. If both are set, OOM is
> >> considered handled, otherwise the next OOM handler in the chain
> >> (e.g. BPF OOM attached to the parent cgroup or the in-kernel OOM
> >> killer) is executed.
> >
> > Could you explain why do we need both? Why is not bpf_memory_freed
> > return value sufficient?
> 
> Strictly speaking, bpf_memory_freed should be enough, but because
> bpf programs have to return an int and there is no additional cost
> to add this option (pass to next or in-kernel oom handler), I thought
> it's not a bad idea. If you feel strongly otherwise, I can ignore
> the return value on rely on bpf_memory_freed only.

No, I do not feel strongly one way or the other but I would like to
understand thinking behind that. My slight preference would be to have a
single return status that clearly describe the intention. If you want to
have more flexible chaining semantic then an enum { IGNORED, HANDLED,
PASS_TO_PARENT, ...} would be both more flexible, extensible and easier
to understand.

> >> The bpf_handle_out_of_memory() callback program is sleepable to enable
> >> using iterators, e.g. cgroup iterators. The callback receives struct
> >> oom_control as an argument, so it can determine the scope of the OOM
> >> event: if this is a memcg-wide or system-wide OOM.
> >
> > This could be tricky because it might introduce a subtle and hard to
> > debug lock dependency chain. lock(a); allocation() -> oom -> lock(a).
> > Sleepable locks should be only allowed in trylock mode.
> 
> Agree, but it's achieved by controlling the context where oom can be
> declared (e.g. in bpf_psi case it's done from a work context).

but out_of_memory is any sleepable context. So this is a real problem.
 
> >> The callback is executed just before the kernel victim task selection
> >> algorithm, so all heuristics and sysctls like panic on oom,
> >> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
> >> are respected.
> >
> > I guess you meant to say and sysctl_panic_on_oom.
> 
> Yep, fixed.
> >
> >> BPF OOM struct ops provides the handle_cgroup_offline() callback
> >> which is good for releasing struct ops if the corresponding cgroup
> >> is gone.
> >
> > What kind of synchronization is expected between handle_cgroup_offline
> > and bpf_handle_out_of_memory?
> 
> You mean from a user's perspective?

I mean from bpf handler writer POV

> E.g. can these two callbacks run in
> parallel? Currently yes, but it's a good question, I haven't thought
> about it, maybe it's better to synchronize them.
> Internally both rely on srcu to pin bpf_oom_ops in memory.

This should be really documented.
-- 
Michal Hocko
SUSE Labs

