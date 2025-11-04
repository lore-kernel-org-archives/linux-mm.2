Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65118CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 19:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A762F8E0005; Tue,  4 Nov 2025 14:22:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF4E8E0002; Tue,  4 Nov 2025 14:22:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6EB8E0005; Tue,  4 Nov 2025 14:22:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76D758E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:22:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F58B88D24
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 19:22:17 +0000 (UTC)
X-FDA: 84073895514.21.681017F
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5C66100019
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 19:22:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FzMpqT9N;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762284135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Ekbw2JAUHQcxMukPAtOc9LSVhS6WclBdtt7KL4LfcQ=;
	b=0Jkj6z0Vq6+lwAERru1sxnEZVPejwB6C5ayxYmuax2RmgnUp+Y8MsTN7hUvrVDRhlt97uR
	x3m+X6iDBfh+EV/CzVK/hmim+AF9o7IQQC3WbxkgseJ29MB1LyHtMlZFScQquPXe6PyDhc
	btQObiTVq3jSjSOvyBmQA49C0i0QlZg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FzMpqT9N;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762284135; a=rsa-sha256;
	cv=none;
	b=hbNQdOkE70LW5jurdyf/WxZ8PRzqdlPFeQ00nMOvE7xLx/IqJoN7hyx27lpR/Kr2EbHASo
	lPEl1IEQhaqKm70IBcX1msCs2BTfyQ+c1sg/1O7lbHSFCIfkHZDoF9JY/HesgTdAbsoSZa
	DShe6vy8HU1TUfI8Z0XsFIYYIfnLgHw=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b403bb7843eso283570266b.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 11:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762284133; x=1762888933; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ekbw2JAUHQcxMukPAtOc9LSVhS6WclBdtt7KL4LfcQ=;
        b=FzMpqT9NWrIYW3Qh7MB5YwgyKb0fgBOj2fVVAnraGCgzj49bdfZvwwV4BRV4jGwZQ5
         l/7pYBmR71aiPiau4e70ZSpYTvPBMH4FFiW5hMq47Ym+T1ctKW6IJWajp7Zg+HBy/tnI
         eDrTacwBBtGb3IA09Lm3fzVdNXnL+D1sZ8I14J+bs76wtAyJzhIrr4dJGtuIsbkr2hDp
         W8df3h3eUChdZ/dau1ey0aR/HPedlVinWRU+sd/PItypg4kqXCKEHoCBT/VohzyMil3y
         xqmRtzqjdnF3Q4nSgxXPbWsBDOJk2klVDntPCRaOyDcpCMR/GjA4qZelaCJPDor/ZplW
         XvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762284133; x=1762888933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ekbw2JAUHQcxMukPAtOc9LSVhS6WclBdtt7KL4LfcQ=;
        b=QQal/ScBscfIvCiY0Qa3/2QqA3J3ZUaXByDSiF2i4fW1iBpl9ULKg28XarA2SEz+yX
         0+CNh1WJJNLl4SKTCEnjYf2hE3omfiaUzJEhIMMuiSdDBQb1iwNJ5G/i1CPzFQvECKsR
         4RH2r+FEBmeT59IuAo2nKshFRJe2eKz9xYPQn+3sUbNqIRyRMQ7veYq9Kv7n3XZboA4R
         ilz7A/7YWJKa2XANL9IvKM+gdGY/olcOxhqXKQJAsiuPHhYJFpvlcLyc40lwTcRamoPa
         4OieES29KF/HQTe7+LN9RbxbKDUmRASnV4cxf8bL8Eik+JLXUbhpqBHnTOiOfucdp63a
         QMgw==
X-Forwarded-Encrypted: i=1; AJvYcCWNbX1y6P1AxJI4a8BHtIgkXHXTGVYBQy3eZcx8yqqMXQXH6nTh0S7pVKNTNnS1cdjGvzdh6Imd2A==@kvack.org
X-Gm-Message-State: AOJu0Yw++MwGal8gB1UFtvmRh83+CRXR3pgRdd7+yD0kveHg2D54fV0j
	wrx+V3GV/Tl0de4cXsXZjW8PRWFmOF2P1gjN1XNlMMIqxd0vyZIUcCe8dFtj1o1I51w=
X-Gm-Gg: ASbGncvwXgxU82EHB3BpxWS3gE7RdF1ghswNBRU7o+nA94E7KjnkyFUyAt6bAGSnuNh
	Nd7n98mAg4ydE+57f2+vQ7HJNfHuBaxGxx3/V+tov5ENkiJud6+80Ct/4iJeu0GDkefAy9KFheu
	PqTWEP5ScTM8siSDWQ6THuVrwVQMxVp+PX4JyT+S3oYoXUNDTi9mGGIx7ZVCSRH6X9F97xvZWLl
	GTj61cRShIFJm1UGqBse/cYg5A7Ycg19JJGwJCDCh6RNWC/yCHDpCJkzTrTSWR2EQL797dBX4WV
	Cm+gi8E/N5nHh+Ym/4m/POspCkQi0Xba19R1EBd7Ded/VQ1QhDClN7aRcMuYQ/jBRy62FDyDKx4
	R3/9wqFHYRKej+Yr6td/a8ANNDxy13D+dhKm2QQRUYbquI0/Wz0tTxpu138fTZ4Tj87rYIp1HjM
	YIL0cQ4NSxLdyEdw==
X-Google-Smtp-Source: AGHT+IFik8SalFdLc/bnmoU3LnAmqT4cTwgJ3PvSTxEZQ+CS4V8zLsokvxKnUaET/LmVBxkwZrJpyw==
X-Received: by 2002:a17:907:9721:b0:b6d:5bc1:4859 with SMTP id a640c23a62f3a-b72653cb70amr25182666b.29.1762284133077;
        Tue, 04 Nov 2025 11:22:13 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723fe3902bsm285399366b.63.2025.11.04.11.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 11:22:12 -0800 (PST)
Date: Tue, 4 Nov 2025 20:22:06 +0100
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
Message-ID: <aQpSXgUL1fUzRgyL@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-7-roman.gushchin@linux.dev>
 <aQR7HIiQ82Ye2UfA@tiehlicka>
 <875xbsglra.fsf@linux.dev>
 <aQj7uRjz668NNrm_@tiehlicka>
 <87a512muze.fsf@linux.dev>
 <aQm2zqmD9mHE1psg@tiehlicka>
 <87h5v93bte.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h5v93bte.fsf@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5C66100019
X-Stat-Signature: oi7w1ij1dac5uxypyckm7o1xqe5ao3oq
X-Rspam-User: 
X-HE-Tag: 1762284134-235827
X-HE-Meta: U2FsdGVkX1/ovhuRAubFHHRjOQ6WzrhTnrHhRxf/q9Mh0EOlK+wuXoMGQOMgXfQu/GCCedcpK4441xRS4hRSM9D0XFwtx1g5SmYvks25ILN0c/IV2DDr/4F/2LcZDqellgpzzWti7RabVzycZkBdXJMipfHDxIloQt8JS8nZwVqzGt5c/gGXKV+eW/ixgJWUQkAZwn1m7AnObOcRlXuBcMMzTma0naenZmLzk4lxWURI4eddjLUEsVLXDp/OfacLYjNTO5l4i3lU7g57EfwzdsUTzMiJAvSy9uu2cBCHXwz3exVPDt2X4x4DP44oMFGeJ8szgVtHdXHDopWfndtMN9P8AYNPOgHL/Pgy61i9aiFeBpTrGVFAKov8hIzlbKZFvzd5z5wMul2m65ef6E8eoh8x0BzHi7+/7M+5vWLj6KBSz3afSVDXupL99n+IwFJR3O8IwSXvIMg5JeKdTDDKlDjzjDEEpqkKBPdC37qRHbOaG+lC2iXWhN+R9VoG/SscDG/YB+uAs80nzZUt8CESK6/h5/LEeoCt9b/R5VvlsPLh45vSsd83iqq8COmfjzZmQHz1MBKyopQghOcG3K9A7NTEO+dZoaj+o32wGfJh3lHksfQRIhEBb7ZNVnLWNrERsEtCNft3k+XzVYCyk4xh8SQ8jGNb+JbipsPZKA9FUbTdyj0TFW8pgLi8dXmtL5LCLh0ZWUI2G0XjZTNqi9K4c83QfpdEklAlrJR/p0u4C1PBNEh51mk905qVpAK7STCco4JW+absgaBxWkKl1SxlOygBFWyjUiRVMPd90W3+TAWX8oyF69ROAGfJnTYW/9OrMbPKGqZzd4boI7Ph66VaRgakIheQRncwjd70EboOIhyZWpi7m1bLLcTMclm7X0Wr8+gTjRdFq+QNYlVpDsGZUZniusnFtcdmLUcHqDW6caCjcU9Io8N7HuDdr3hnKmFAKNf/8HUiJJ2OXwYXibt
 nYGO8JPy
 0DA+L0r7/RuQciOyhYssPF304xeqOtCZQZHNIksZDqT1V54lsJpZSLMBlTTmxXJ156hRhoODSnSl5IzCXIS4g+BKww+B0vfpfYMiD80mG/jNSS5gVmCz7Uu0ho6xeQb7N3gbM7Rj73CrPnzZ/3uyJ3p0JrFYtrMuxhiNBEji7WAdCfw/KABPGKAh+NXcQ6xMgE9iciu44RnUi4xAjKT0LqS0viX5vXTdMjeJeP3uXEyaXjVLJstHPUrETtt0nsZsByRhjZU9PhytEI7umhE7SNkJViXTHWSw2vfC4jp1MaQVREu6mzekuB4uPUrERZdNTKKpcQtG0zM/mj/PnqgQZo94fCN5JXXqN6dH93yoWdtYh9qthYZIAsB3zaJkOCbHxtuda+eWL8283YyEm4hArsIYEqvEQQaIBwif7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 04-11-25 10:14:05, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Mon 03-11-25 17:45:09, Roman Gushchin wrote:
> >> Michal Hocko <mhocko@suse.com> writes:
> >> 
> >> > On Sun 02-11-25 13:36:25, Roman Gushchin wrote:
> >> >> Michal Hocko <mhocko@suse.com> writes:
> > [...]
> >> > No, I do not feel strongly one way or the other but I would like to
> >> > understand thinking behind that. My slight preference would be to have a
> >> > single return status that clearly describe the intention. If you want to
> >> > have more flexible chaining semantic then an enum { IGNORED, HANDLED,
> >> > PASS_TO_PARENT, ...} would be both more flexible, extensible and easier
> >> > to understand.
> >> 
> >> The thinking is simple:
> >> 1) Most users will have a single global bpf oom policy, which basically
> >> replaces the in-kernel oom killer.
> >> 2) If there are standalone containers, they might want to do the same on
> >> their level. And the "host" system doesn't directly control it.
> >> 3) If for some reason the inner oom handler fails to free up some
> >> memory, there are two potential fallback options: call the in-kernel oom
> >> killer for that memory cgroup or call an upper level bpf oom killer, if
> >> there is one.
> >> 
> >> I think the latter is more logical and less surprising. Imagine you're
> >> running multiple containers and some of them implement their own bpf oom
> >> logic and some don't. Why would we treat them differently if their bpf
> >> logic fails?
> >
> > I think both approaches are valid and it should be the actual handler to
> > tell what to do next. If the handler would prefer the in-kernel fallback
> > it should be able to enforce that rather than a potentially unknown bpf
> > handler up the chain.
> 
> The counter-argument is that cgroups are hierarchical and higher level
> cgroups should be able to enforce the desired behavior for their
> sub-trees. I'm not sure what's more important here and have to think
> more about it.

Right and they can enforce that through their limits - hence oom.

> Do you have an example when it might be important for container to not
> pass to a higher level bpf handler?

Nothing really specific. I still trying to wrap my head around what
level of flexibility is necessary here. My initial thoughts would be
just deal with it in the scope of the bpf handler and fallback to the
kernel implementation if it cannot deal with the situation. Since you
brought that up you made me think.

I know that we do not provide userspace like no-regression policy to BPF
programs but it would be still good to have a way to add new potential
fallback policies without breaking existing handlers.

> >> Re a single return value: I can absolutely specify return values as an
> >> enum, my point is that unlike the kernel code we can't fully trust the
> >> value returned from a bpf program, this is why the second check is in
> >> place.
> >
> > I do not understand this. Could you elaborate? Why we cannot trust the
> > return value but we can trust a combination of the return value and a
> > state stored in a helper structure?
> 
> Imagine bpf program which does nothing and simple returns 1. Imagine
> it's loaded as a system-wide oom handler. This will effectively disable
> the oom killer and lead to a potential deadlock on memory.
> But it's a perfectly valid bpf program.
> This is something I want to avoid (and it's a common practice with other
> bpf programs).
> 
> What I do I also rely on the value of the oom control's field, which is
> not accessible to the bpf program for write directly, but can be changed
> by calling certain helper functions, e.g. bpf_oom_kill_process.

OK, now I can see your point. You want to have a line of defense from
trusted BPF facing interface. This makes sense to me. Maybe it would be
good to call that out more explicitly. Something like 
The BPF OOM infrastructure only trusts BPF handlers which are using pre
selected functions to free up memory e.g. bpf_oom_kill_process. Those
will set an internal state not available to those handlers directly.
BPF handler return value is ignored if that state is not set.

I would rather call this differently to freed_memory as the actual
memory might be freed asynchronously (e.g. oom_reaper) and this is more
about conformity/trust than actual physical memory being freed. I do not
care much about naming as long as this is clearly document though.
Including set of functions that are forming that prescribed API.

[...]
> > OK. All I am trying to say is that only safe sleepable locks are
> > trylocks and that should be documented because I do not think it can be
> > enforced
> 
> It can! Not directly, but by controlling which kfuncs/helpers are
> available to bpf programs.

OK, I see. This is better than relying only on having this documented.

-- 
Michal Hocko
SUSE Labs

