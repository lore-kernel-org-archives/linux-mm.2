Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31C1606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HHre2nLX
Received: by kanga.kvack.org (Postfix)
	id 11D386B05B4; Mon, 23 Nov 2026 14:29:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CEDF6B05B5; Mon, 23 Nov 2026 14:29:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28076B05B6; Mon, 23 Nov 2026 14:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAB466B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:29:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 061DC1C4379
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:29:30 +0000 (UTC)
X-FDA: 85467372900.11.2B83C7C
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B33F80007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:29:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HHre2nLX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795462168;
	b=6VASqXp1tVHfxjugsDwnDNRf+D2DKV5NO95zecHQDZGcKPadDIdkFNrvtYWzEcbb0kU2mE
	I3DxN9SMmx0TRLnt1OR6NpHVttFGTF6bzgW2JTR2+6YXDF1Sjy+3ywIThYQ+Jup0uN6LbW
	MCu2boFOCf4oSoBh+sv7xJrsxMvMhEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795462168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dK6izBnVztalFUd9ZDZGnPYRw3kapxyvZkhsazeP+5g=;
	b=aQc9jrxjuU51v6ZzquOWntvCyXr9xUhR7wy9n6eWdSNbMkURESC2bWgBFUA9jXH/Hc9Ejn
	15JOb8TxhYFwgndfWmgxoFqE+kHPQC4g6iCEzon1AzTSEdKX151q9z8J9gxRaiREujPmfW
	OazatRZWrR+PtQGgkpFXiiDj1fnitA4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HHre2nLX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4ad881b6517so2621141fac.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795462167; x=1796066967; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dK6izBnVztalFUd9ZDZGnPYRw3kapxyvZkhsazeP+5g=;
        b=HHre2nLXOCldeFCfGnXYYieg0NVTzzm772vQkifvMX/Au2o0Z9pPI9jLA8FRdZ1gak
         njXt9kd6ap6zpJj/8E7ur6H9KXCileAvmEhFKEM5Ld4XWjldCT3K3eZVIEHiugoH8wPA
         Fztx4KHnFwrxYZqRiQ5XKA+wgcgNXlokWGVLvjSgrRavDIAr446kIaWvyRFvtCFW1kXI
         iQ0Ef2EW4+z6V4uz0XC6me7mD8TNjabwLUjw8utP+uZTVyChJaL7m89sUenbeRxRAY8V
         Jh5r+RjqlFq9kMkwHI0kw9zpdKetrYVgzGPswsyFdus9aEAVcDUv7ZAYa6oHlZ0gG1wc
         Mvig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795462167; x=1796066967;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dK6izBnVztalFUd9ZDZGnPYRw3kapxyvZkhsazeP+5g=;
        b=Wb7FL3r0OnMtfopPLCUluYMVz6gFPHBN2qOfKUj3A8HJb+f3unfeshX5+Pn6IEKJVo
         P0/EwCA7hiu5UnjbszCV6t3UyXFbQppAQ3/oxvGl7CERew2FWsK77DrEGEKU5Y6jcXPD
         Ad+MOPkCE7ioIy9aYLh8UR5LTN2Xqua+VhwhhSijRgGwo2gsrn2+nM166Gu4JDfSePZt
         f+78+b/A0FF5v7bzKzG00IuH3tfLUQPPV8MbyjxixdAYWysFgqqSuNuQn2VanLy9LVP/
         NqLx8fAK7saau9EyU+v+dL1atNn9TmMbBDzsT1viJAi0VwXWTv19liJSXeehfnZ0AgnD
         0Wkw==
X-Forwarded-Encrypted: i=1; AL+hErHYvzp2QGYj+sysAEEZASy4JhKiiKoTrUkDLuCGLMjbYlSGcnz6ogZNe+04+j/L0a5+7aukIZBJ5A==@kvack.org
X-Gm-Message-State: APuU4Z8K0D5TtXSD1lBTyXjD9immbO0lM+wVEtniCNqWT04+frDxnaRn
	wfPrwmEDOgDpWbZ1t2mulu7gYxD4tlW4djm/rPJdM8t3uaY/tnlerkz4+JJBzw==
X-Gm-Gg: AZFdTZdiDCZFlshUESKbJEbC1uU8zLjprS82GZ5wVmY8LwO2DzPtKYIXNBUYgZw/tuY
	yGcGR+Q2n0/3wY4v1GXrvEgJTrbE61+JJHZr3J5e6XG1IF0CX4OtNhHbVNFYJEa+QMBOmTzTTfM
	UqDhO5LNml/pT4Bbuo+6PirIgnCtJvFjx/7ynGu5zt7MqoJSqxvhsoC0wu4T7alp40KSTbpDiQd
	Pxl1i4MQcRRB7PLiuTBTyYp7ngPN0QYlUQF1v0MrgU6RKRUjgmp62bIgJORbWMFk69HEkSJsx0s
	UnJ2wE/k07E9e7hSz6/HEROp+G4KNNuqvRsMTdLN2mHCUBPp8DCmldmHbxFOouamw/hNpdkjddL
	FJnhamdKduFII/ZO1lXdhLkrnIoE4gxc24e2lvPcTZJnmdEMYhEinUoM2p9JfBhyExKZysUYjmK
	MAYek/n5ZxS72wZa1g8gf4rS851EUt8AsyGwbxL/vFgY1eQFBYJ1VfSAULBq8tXIHSHhfLGO6JT
	B4gx7MsTyH/hJy69rcO+ZcJQ7fX99lmV5yrYgtACOOiz6IA1klHVTthctDMGno101A8SJHcwnsB
	vWX3zOB8/lxhQPlbXZEON7aZ6YnU/uRqreZYrNhTaaDy0Log2bqecHmeBMww
X-Received: by 2002:a05:6871:89f:b0:494:a2cf:8dce with SMTP id 586e51a60fabf-4bc7beaef71mr11196329fac.4.1795462166843;
        Mon, 23 Nov 2026 11:29:26 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:44::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4bc60491337sm11539135fac.12.2026.11.23.11.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 11:29:26 -0800 (PST)
Date: Mon, 23 Nov 2026 11:29:24 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
	hannes@cmpxchg.org, ljs@kernel.org, mhocko@suse.com, muchun.song@linux.dev, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: add source selector to memory.reclaim
Message-ID: <awSSDehzWsJ68V5y@devbig011.atn3.facebook.com>
Mail-Followup-To: Li Zhe <lizhe.67@bytedance.com>, 
	akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, 
	ljs@kernel.org, mhocko@suse.com, muchun.song@linux.dev, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261116110459.11048-1-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116110459.11048-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 1B33F80007
X-Stat-Signature: s7xfu5qp89cw4pes3twg9wji38sbmkcf
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795462167-701426
X-HE-Meta: U2FsdGVkX19WH824M3rOuCZPiW83nEcSGAdpuakVZoLNnbOaf2QzICKgf7IbLP8MNBLrYPr2B4VoewazdHnb5nGICLFKPz+JE91XQRsyBoJNW3wGm1TJ1OYHCHPytzG04+6vQtfaHwA5s7rHjV11qvhQg83tTe4ex60Lg2itZR/zbhKGWk8q5MOlRmv4lUZ5UTBpSEXYRqC+dRXN3l1IiRRqliwDvK/CKOm8tHJ0MW8MNM87AfMPVLL+VNmvY2QYkXxrwFbtgtRYjhbFKLSlVyeU6r2fp0yT4CdOAw5Y9TIKojQUo0Ty4+rNjJoY0sfg+5r4ZpLPEjYH1rauPAvbkHcemoMweRn/awpBwzmvILQMqvwE0fWTSVw7gmq2l3Uv/sfKJdfFydkkK8+OPfsYU8F5QVk4zZo8l9vnr2ztg6qE0zN14AqeZlORuvSixi2+2YcuA53TqyECkmAbeMNQHROGR7vejwM27uoS1Q7mo8xjIghZG9HqYLxPvDyYtbdTVGU0l+N/fag6WiNiAmjKQlQg9W3sCLnSqCvqOpwMCR5jn+QY7mioAHCHlMgd3xcu9iUM0FZ0gSYGcwabpYTpd4/A8apeeRugMKses9nFcLZxYoYDUhD82x55ImXMpi8RwjFkBrbEr5mgbPIdLITbUnn4Urw/pwnvX+/N8jxtGYHwFEfEK2+tfnJ/GNkiTR6iGmvmjSlj1NY8YWb0IM3Ftw9yPNMqDPF/TB36xIjCe0XTbE6vxQt+N4dwBL5+8L787mAaAi5mwu0cs/QP/dMvYd0aJ5YDcdTiLerJEQriyl0Vi/olf9rzBo19Qq1N8Lnosw/ZbueDYCyVAgpypPNQ2nhPmnx/gXAL7W7INOZwFm3dKUEOv6Y9TRJs4zUN6Tg41d5/9nyfMIWJcJzetzdYaDg+x5KF6obd8c18BiQ4SJAQcaJ8TlbNxyWPN36/otbiNRAclZ5xf78v+CdXz3x
 T7X1RA4p
 tkM6Wm9QNzpY6JoCJavh+8dD1cYG8VlWWoWPOmjPXqwZ/9TJqAOFGYi26hAtdBbALT6YsB65R4K6HWVqxsHfXWUN+DJPqhBVV8yFS6vaqaEmg0U2yeIBaNNpgeIcHEBjwod7lBpNNs2ff7FGxqDv7IJjXieUbKWDMn/ZsqqzMNPvdHslOVWTQOxrObFmch9pivyt4i2urBzbz6kZdKJ1qquavmLgjSgsxxgeB5nazcSKqXsf1u/BgO7tQloj5phlDDO4WrC9VgRouKcQJctThtDIiQ8LDXNNAisTvfFTuV9im9KVQ/raXQ5QKVoZJ1g8pPijlEMJUq9zKXfzOtR85/TW4VX6ZwMkxIMfeHQvwPVSeM0uhui7sHbABZ6vtWyVZR53tJx48RtkfB5Y/mKt1NpywndMjd4+gssEzrg1vx8FV6VGJKHX3M/Mpiwt4lMbvpMC2RvMkaLLv2A/q6clXKjv+Rw4UQ7vIGX0MnmEsNHDDYpYVvHmv33cZqi9O69w9QrTJrfwauTolJXvB0LmmitAZmpYC4ahzn+oDBxw47nkXc0k5ojyA31zZpuKCQXk59wP0bH/mxluliuVIkHQmvkqBnX7porR0fBkmYkX9AOZKUXEQ+ro5gAp/kSMwmPSLCw6+woEttBFPFpCPlIG9+ZhXff/IgOcyXPGQk0RJ9acWVP60JD4rdhRoBzPe7goznrG0zISvgnI/X30olKOo1tpcU1ZErndB/l4YpH734a3DDMWQUy9NvA7VWme939mib/t2sGG4ek5fEGvfk86Pv/KPeJ7/4pZHcaitKQt6JwXiilZj72dKcG28c/xuIdOdQkoYXeQKDCeGJhWuTg4rhRnsMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:04:59PM +0800, Li Zhe wrote:
> memory.reclaim can apply proactive reclaim to a memcg, but it cannot
> target source nodes the way global node reclaim can. Proactive memcg
> reclaim follows a fast-to-slow fallback order, which attempts demotion
> before reclaiming from slower tiers.
> 
> As a result, a memcg controller cannot decide whether reclaim should
> start from DRAM or from a slower tier. For a cgroup that is close to OOM
> and needs charge reduction, or for a controller trying to shape a
> workload's DRAM/CXL resident distribution, the default policy may spend
> reclaim effort on the wrong source tier.
> 
> Add source=nodes:<nodelist> to memory.reclaim. The selector only chooses
> the resident source nodes where the existing memcg reclaim path applies
> pressure. It does not select demotion targets, force demotion, force
> eviction, promote pages, or change completion accounting. Leaving source
> unspecified preserves existing behavior.

Hi Zhe,

Thanks for the patch and sorry that it took so long to reply.
I've actually spent a lot of time thinking about this commit to see if
it can be used to establish per-memcg-tier residency limits on machines
running multiple workloads via memcgs.

So you could have a daemon running, checking the per-tier usage for a
cgroup, and creating pressure to evict pages downward from that cgroup
specifically.

So if a cgroup is using 10G more node0 (DRAM) than it should be, you can
write "echo 10G source=nodes:0" > memory.reclaim to try and free up that
space. I'm running some experiments locally and really thinking through
this to see what that would lead to.

Anyways, to me the only concern that I have is what happens when that
reclaim fails. Let's say that you have a situation where CXL is
completely full, preventing future demtions. At the same time, we have
a memcg that is using too much DRAM, so we try to reclaim from the
DRAM node and pressure downwards.

The thing is, I think proactive reclaim doesn't allow swapouts on tiered
systems. 

So what would happen is, you would (1) fail demotions, and then (2) fail
to swap out, which means the pages have nowhere to go. And repeatedly
running the same command over and over again will not lead to any
progress at all.

> With this, userspace can build the policy it needs on top of existing
> kernel reclaim behavior:
> 
> 1. start reclaim from lower-tier nodes to reduce the cgroup's memory
>    usage more directly;
> 2. steer reclaim toward over-represented nodes to shape a workload's
>    DRAM/CXL resident distribution; and
> 3. reclaim from lower-tier nodes first so later top-tier reclaim has
>    room for demotion.
> 
> Example: nodes 0-2=DRAM, node3=CXL
> 
>   echo 1G > memory.reclaim # progress from nodes 0-3
>   echo "1G source=nodes:3" > memory.reclaim # reclaim from CXL
>   echo "1G source=nodes:0-2" > memory.reclaim # usually demote to CXL

And so I can see why you would have to run something like this in order
to actually make room, moving from the bottom going up. Make space for
the memory that's about to come in from the top.

To me this makes a lot of sense, and it's something that we (Meta) has
thought about quite extensively internally as well (from Johannes and
Gregory, who are also CC-ed in this mail).

But at the same time, this is not really an atomic operation. So memory
usage between the two operations can change very rapidly. I wanted to
start a conversation about this point and whether this is something that
the commit should address. I would like to hone in on a use case and
think about how the users should be expected to use these things first.

Thanks a lot Zhe, and sorry again for the delayed response.
I hope you have a great day!
Joshua

> The typed source= form also leaves room for future source selectors
> without changing the ABI introduced here.
> 
> Tested in a CXL setup with nodes 0-2 as DRAM and node 3 as CXL. A
> userspace controller steered eight cgroups toward a 50:50 DRAM:CXL
> resident ratio while a background workload created reclaim and demotion
> pressure. With source=nodes, all eight cgroups ended with 45%-55% of
> their memory on DRAM. Under the same pressure, the plain memory.reclaim
> baseline left the worst cgroup far away from the target range.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
> v2: https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedance.com/#t
> v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedance.com/
> 
> Changes since v2:
> - Dropped the separate cover letter and shortened/refocused the commit
>   message, as suggested by Joshua Hahn and Gregory Price.
> - Added an eight-cgroup CXL test summary under background
>   reclaim/demotion pressure, as suggested by Joshua Hahn.
> 
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 11 ++++++
>  mm/bpf_memcontrol.c                     |  3 +-
>  mm/internal.h                           |  3 +-
>  mm/memcontrol-v1.c                      |  6 ++-
>  mm/memcontrol.c                         | 11 ++++--
>  mm/vmscan.c                             | 49 +++++++++++++++++++++++--
>  6 files changed, 72 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 9e3c67b02ae2..992f9bdc46a1 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1458,6 +1458,7 @@ The following nested keys are defined.
>  
>  	  ==========            ================================
>  	  swappiness            Swappiness value to reclaim with
> +	  source                Source to apply reclaim pressure to
>  	  ==========            ================================
>  
>  	Specifying a swappiness value instructs the kernel to perform
> @@ -1468,6 +1469,16 @@ The following nested keys are defined.
>  	The valid range for swappiness is [0-200, max], setting
>  	swappiness=max exclusively reclaims anonymous memory.
>  
> +	Specifying a source value constrains where proactive reclaim applies
> +	pressure. Currently only source=nodes:<nodelist> is supported. For
> +	example::
> +
> +	  echo "1G source=nodes:0-1" > memory.reclaim
> +
> +	This applies proactive reclaim pressure to memory of the target cgroup
> +	resident on nodes 0-1. It does not constrain demotion targets and does
> +	not change memory.reclaim completion accounting.
> +
>    memory.peak
>  	A read-write single value file which exists on non-root cgroups.
>  
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index d8f579c28560..7d98f55a044f 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -201,7 +201,8 @@ __bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
>  						    MEMCG_RECLAIM_MAY_SWAP |
>  						    MEMCG_RECLAIM_PROACTIVE,
> -						    swappiness == -1 ? NULL : &swappiness);
> +						    swappiness == -1 ? NULL : &swappiness,
> +						    NULL);
>  
>  	return nr_reclaimed * PAGE_SIZE;
>  }
> diff --git a/mm/internal.h b/mm/internal.h
> index e3f92883bf23..ff24a58d47e8 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -83,7 +83,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
>  					   unsigned int reclaim_options,
> -					   int *swappiness);
> +					   int *swappiness,
> +					   const nodemask_t *source_nodes);
>  
>  #ifdef CONFIG_NUMA
>  extern int sysctl_min_unmapped_ratio;
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index b7f286888507..74aa06fee76a 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -1464,7 +1464,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
>  		}
>  
>  		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> -				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
> +				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
> +				NULL, NULL)) {
>  			ret = -EBUSY;
>  			break;
>  		}
> @@ -1500,7 +1501,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
>  			break;
>  
>  		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> -						  MEMCG_RECLAIM_MAY_SWAP, NULL))
> +						  MEMCG_RECLAIM_MAY_SWAP,
> +						  NULL, NULL))
>  			nr_retries--;
>  	}
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d16..116c6853c9ba 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2444,7 +2444,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
>  		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
>  							gfp_mask,
>  							MEMCG_RECLAIM_MAY_SWAP,
> -							NULL);
> +							NULL, NULL);
>  		psi_memstall_leave(&pflags);
>  	} while ((memcg = parent_mem_cgroup(memcg)) &&
>  		 !mem_cgroup_is_root(memcg));
> @@ -2774,7 +2774,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  
>  	psi_memstall_enter(&pflags);
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> -						    gfp_mask, reclaim_options, NULL);
> +						    gfp_mask, reclaim_options,
> +						    NULL, NULL);
>  	psi_memstall_leave(&pflags);
>  
>  	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> @@ -5001,7 +5002,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>  		}
>  
>  		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
> +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> +					NULL, NULL);
>  
>  		if (!reclaimed && !nr_retries--)
>  			break;
> @@ -5060,7 +5062,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>  
>  		if (nr_reclaims) {
>  			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
> -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
> +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> +					NULL, NULL))
>  				nr_reclaims--;
>  			continue;
>  		}
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a1af9b92349..15e2e5710468 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7013,12 +7013,14 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
>  					   unsigned int reclaim_options,
> -					   int *swappiness)
> +					   int *swappiness,
> +					   const nodemask_t *source_nodes)
>  {
>  	unsigned long nr_reclaimed;
>  	unsigned int noreclaim_flag;
>  	struct scan_control sc = {
>  		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
> +		.nodemask = source_nodes,
>  		.proactive_swappiness = swappiness,
>  		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
>  				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
> @@ -7054,7 +7056,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
>  					   unsigned int reclaim_options,
> -					   int *swappiness)
> +					   int *swappiness,
> +					   const nodemask_t *source_nodes)
>  {
>  	return 0;
>  }
> @@ -8098,20 +8101,51 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
>  enum {
>  	MEMORY_RECLAIM_SWAPPINESS = 0,
>  	MEMORY_RECLAIM_SWAPPINESS_MAX,
> +	MEMORY_RECLAIM_SOURCE,
>  	MEMORY_RECLAIM_NULL,
>  };
>  static const match_table_t tokens = {
>  	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
>  	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
> +	{ MEMORY_RECLAIM_SOURCE, "source=%s"},
>  	{ MEMORY_RECLAIM_NULL, NULL },
>  };
>  
> +#define MEMORY_RECLAIM_SOURCE_NODES	"nodes:"
> +#define MEMORY_RECLAIM_SOURCE_NODES_LEN	(sizeof(MEMORY_RECLAIM_SOURCE_NODES) - 1)
> +
> +static int parse_memory_reclaim_source(const char *source,
> +				       nodemask_t *source_nodes)
> +{
> +	const char *nodes;
> +
> +	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
> +		    MEMORY_RECLAIM_SOURCE_NODES_LEN))
> +		return -EINVAL;
> +
> +	nodes = source + MEMORY_RECLAIM_SOURCE_NODES_LEN;
> +	if (!*nodes)
> +		return -EINVAL;
> +
> +	nodes_clear(*source_nodes);
> +	if (nodelist_parse(nodes, *source_nodes))
> +		return -EINVAL;
> +
> +	nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
> +	if (nodes_empty(*source_nodes))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  int user_proactive_reclaim(char *buf,
>  			   struct mem_cgroup *memcg, pg_data_t *pgdat)
>  {
>  	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
>  	unsigned long nr_to_reclaim, nr_reclaimed = 0;
>  	int swappiness = -1;
> +	nodemask_t source_nodes;
> +	const nodemask_t *source_nodemask = NULL;
>  	char *old_buf, *start;
>  	substring_t args[MAX_OPT_ARGS];
>  	gfp_t gfp_mask = GFP_KERNEL;
> @@ -8142,6 +8176,14 @@ int user_proactive_reclaim(char *buf,
>  		case MEMORY_RECLAIM_SWAPPINESS_MAX:
>  			swappiness = SWAPPINESS_ANON_ONLY;
>  			break;
> +		case MEMORY_RECLAIM_SOURCE:
> +			if (!memcg || source_nodemask)
> +				return -EINVAL;
> +			if (parse_memory_reclaim_source(args[0].from,
> +							&source_nodes))
> +				return -EINVAL;
> +			source_nodemask = &source_nodes;
> +			break;
>  		default:
>  			return -EINVAL;
>  		}
> @@ -8181,7 +8223,8 @@ int user_proactive_reclaim(char *buf,
>  			reclaimed = try_to_free_mem_cgroup_pages(memcg,
>  						 batch_size, gfp_mask,
>  						 reclaim_options,
> -						 swappiness == -1 ? NULL : &swappiness);
> +						 swappiness == -1 ? NULL : &swappiness,
> +						 source_nodemask);
>  		} else {
>  			struct scan_control sc = {
>  				.gfp_mask = current_gfp_context(gfp_mask),
> -- 
> 2.20.1

