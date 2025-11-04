Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA85CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BBD28E00F8; Tue,  4 Nov 2025 03:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F1F8E00E7; Tue,  4 Nov 2025 03:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C7F8E00F8; Tue,  4 Nov 2025 03:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBFB8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:18:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7E5B889BB
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:18:27 +0000 (UTC)
X-FDA: 84072222654.17.4D7B314
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B6424000E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:18:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fonu4kEf;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762244305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDGrwGIAe+HNiwkyvFhP/kp5qQx4Bemq/CCgC2+MOGE=;
	b=Z8/ncSz4WzDztWR0ADOitxL1ePfMPI3DthCZ6P5aXlQNAp63ULbiVd8XNn8tO4aE+4aLsm
	ixyHVVTzt+RbmwroUINXvhyE+Up1vterQ5ToKGIvqxeh39FEFs1vxi6I+0hO85D8w5lOiK
	k3vJchePPyliGt+JonKhFIUYiMAWbcg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762244305; a=rsa-sha256;
	cv=none;
	b=RpLjeBdC1KU8rOwN+jQU0V15V20tyAn8JShIwwgfw9aT3ZMSj1Dw0PpHSCHkOd28QKQ6fa
	oAlxG2Is5reopVf9GgNW9c8Ob2sPK6jUlp6AqiE8Vudffv8fbAZDp7PYIyhz5mzotleNW3
	xN4PUsMh1oaGcmFu7p49kuP0dIXKGiU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fonu4kEf;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-429c7e438a8so208300f8f.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 00:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762244304; x=1762849104; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HDGrwGIAe+HNiwkyvFhP/kp5qQx4Bemq/CCgC2+MOGE=;
        b=fonu4kEfo64quVnYr5YD410/iHy0S4WLJ03yswxPmfXPiPYsvssS3pgNzCxnbvdXPJ
         bcQpruZf8H5B7ugvfjN8uK3eq3nTNSVWdL7c2+iviHcVhIlx7umn2tsnS7To49FsAAHl
         PZYV2LYw5Z/Fev6Dneb5yOPWP+tx9iHpj6snz/g8hjbN1t/7GJCT0dhWkQJk+TeGwAV/
         wQQKw5rPsk5U37nQLuihzNSh0sM6VMhjI1Cof5OSsDnRlqyDY5jPmxpHVV1C285Ik0Ey
         P/WbbfjWHKyWVDSK5dgwbuT31x8NniyWiS83kljUhzRPNAaHx04EkO0Gg4EvS0tYGPfS
         BPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762244304; x=1762849104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HDGrwGIAe+HNiwkyvFhP/kp5qQx4Bemq/CCgC2+MOGE=;
        b=lFkhfVfWoy1YmfFHbOKHUMWXFXBO0vaxxryEqEWmaFAzCUWTPJL8B4UjS31jWCzLIj
         ZNlpBtrzSw2UTj3AGB5mDGd6d6JcH7ALCV1reGZOjiv44eVpAjVP9Iu7oSRAhdvsJ42+
         u5Pu2dUy3CZPjvSKKgY2vcrqx4a74U4783YP2R3vWzoRV+jS4QY98rWwlh3Cl46+fS7B
         kxugY+Rce4hToUmIekliGiCfPWpNEz/SOTvEyaR0jrDAKuVWhgaSMcelpwWtmXV9X79n
         uLDrGADw//XSrnav617/PDiJ81VQxUVWrEfM8/tSSUbo5+Sg7VcgdvocZJSqf5xTkjCI
         29Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXp/QcPgy07puwNq4RKxqHl+n9rH3iiuNUaBKTo6p7RbbgaM3nI5znUnFUjWk8Ctahvp7tBKSPmSQ==@kvack.org
X-Gm-Message-State: AOJu0Yzse/j7Q5zOHZDgxSqf0HhUwD25Lykby/CM2cUrVRjDjDhadjF6
	4JE7q8O3dRCndQ387hGSmQjcmfmiC0LWp7Ufvjjs9rcV7VEPKN8sJCcY1Rffu6kJJTE=
X-Gm-Gg: ASbGncsgrgD7Bz4Sq0tB+CfA3JHwW0Ecq0rgWcR3IFNMDktkXW3hHC8q7A3IS2B8vdC
	budzB5g3yPhHuaZHdfWnQ6RtQActS9AujV0rLexjfKfdvwwV6GKr2G+ywXzoppdcH53o2sbiWwC
	aR0rzLjTybAJfnLHERTc2PQET8pHukwPoZy8424kWqcEhUdmCDcPRpJlL+7oRaV38TqAMJiyERY
	p/xv22t7XYawNJup9uDQwquOCWqPiyppQypWwCiagPIr2SWWbnHmca98WywpJi/AF4Z0x92NsoC
	K1RrB2Sc/HAmVyuMTJNNxMw15Wjm9Th6ON1sU39ynun7L3A7CAE+eAimAb9dWxiSJOIWf28fkf/
	Lf0mt6W/LQdPBxLhXQozA3Z4SOQY3WFx0lZ4dF0Zrf6wSubfnPuRK27QYnCoKzMQ7cM//w4JePG
	CbLnv4GGzXV3vxq1EWoSs=
X-Google-Smtp-Source: AGHT+IER82dbwOAWSEGagB9JoBAQ4DFL/N85XJT6dQwU/F6NCVBuyJKblUAv95YkwnJ9rUbOTpPUNg==
X-Received: by 2002:a05:6000:40c7:b0:425:76e3:81c5 with SMTP id ffacd0b85a97d-429bd6827fcmr12672112f8f.17.1762244303953;
        Tue, 04 Nov 2025 00:18:23 -0800 (PST)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc193e27sm3237804f8f.18.2025.11.04.00.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 00:18:23 -0800 (PST)
Date: Tue, 4 Nov 2025 09:18:22 +0100
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
Message-ID: <aQm2zqmD9mHE1psg@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-7-roman.gushchin@linux.dev>
 <aQR7HIiQ82Ye2UfA@tiehlicka>
 <875xbsglra.fsf@linux.dev>
 <aQj7uRjz668NNrm_@tiehlicka>
 <87a512muze.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a512muze.fsf@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8B6424000E
X-Stat-Signature: jtgqrx3hsjeuucw3n7395eu7h9zkqdti
X-Rspam-User: 
X-HE-Tag: 1762244305-299355
X-HE-Meta: U2FsdGVkX1/JTk9EPeVHzXW9i/0UJKg8Ejv9q8UDGUgcitEl7oy5dprVRlYS5deO/u/7PNeSHU9edFtG31Pngqx+j12gkf+H83+oM2iiN2PccgQ6NccnAFzckFtR6V6AMKPuaA2dnZ4AM0NOlSTDk+ACtiMd8WRDOiyXKaNsf4tq5yd+6yhv8ElHgafn9NeQw85zdeKDWdMCIUEiDS2ng/2jDaIKR+RuSw5WY8+C0I/9hUQBdqxuHV07CwqJSO8wVquG2WTvR8QPWiGFkirBfsDU2oHcrPy9lMcy7vY62fFhUEFfgcLlX8rfkQG9sL0v2GPaKvJ2ShsokYXLkpZg04pne8xVpc2AyauNtwHqM29qUhZ/1CxwjQCpoS65JXuzAl+9ZXpOb/IclbRpHEmF3V0aRQgB4t9ECK7vi1HxpCurmPoBJjnwbnQGMJXU6agbjzslQCJz97N2MaxrYcKsbaog0LfAWNt9cICK8M8BMvtkFBIyXvvqjPV268isYWreFLhNilLuqx8dJXVtg5XACRS2w4CMmOtqcB08/WSzozqYEHfYn5CXrWwRD/XoVufClrPXmJIu6BLjaIjqt7/t6Q2Hn/O4PNjBIjPDq/1X1UqI34btFrpJhEovut+PJKoZh4R/8v2AMhILAHHso3AHDkwFTWW8y4+GDaFC0uH1dzBMY7H1YE6OOoYqSbkBM8RCIWFG09SFzhCAMhIFKZ7miitlOHDW+3sse91gPnUsmfNOQxrTFnF5kvYvj7N/Qeetctih7bvhPLObYVeZRYqmRWFlhfBjxrwINrNBa3YQckpbhp1d+8CjYNThD1anOzFzeiZlBCf83TcS/K9oBq3EDXs8r38JgKyqeOzadJ3+VPeInyXM20GgpEQWREuglG0uug4LN7I9ZtNQUIn/00zX79Vb4e/FkAhdmMdZiiCDzYmH+iQ/xjvJ9wLHgQqcyAhmFnTOJfn0+6QdWLyKNu5
 PX2cUTvE
 Y8kFNVknbcR+bBZSu6gj3EkPriCjlOZC6X2KlNGipT3rZSLsuF8q8JMs1Cdzk7gu17lcuEzF0aO6GsimatKvIL5AQaqYjokmcH6V1rTd1HRuBlB/g1OMJzcv6BCTMH/geJHzhpTetKPk12spK2GSUTVlMpc/K1rYmoCKi+Rulu74YElaZrc/UPFEr3MthkTcFBkIsNkChUgju78ghgBURgFxwO4YMjj2m/3tlm1Yv8DW93JVdTUzH7zonahXdZ9V3oBUjF8FVDcm6virawilKbXGfMSMz58YEv8GeSFWdVVZvK9JwjeFEomKFB3fSqF5m3WvCDPpBtNM8KEbgqU6sY+C2wSzj0k3rMJNK0iEHCXpQgLQ1FH38F8BIOmoLvjSJfAaXKrJeKzTXzgZ/CzGr2BbsFncaRydbnM8e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 03-11-25 17:45:09, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Sun 02-11-25 13:36:25, Roman Gushchin wrote:
> >> Michal Hocko <mhocko@suse.com> writes:
[...]
> > No, I do not feel strongly one way or the other but I would like to
> > understand thinking behind that. My slight preference would be to have a
> > single return status that clearly describe the intention. If you want to
> > have more flexible chaining semantic then an enum { IGNORED, HANDLED,
> > PASS_TO_PARENT, ...} would be both more flexible, extensible and easier
> > to understand.
> 
> The thinking is simple:
> 1) Most users will have a single global bpf oom policy, which basically
> replaces the in-kernel oom killer.
> 2) If there are standalone containers, they might want to do the same on
> their level. And the "host" system doesn't directly control it.
> 3) If for some reason the inner oom handler fails to free up some
> memory, there are two potential fallback options: call the in-kernel oom
> killer for that memory cgroup or call an upper level bpf oom killer, if
> there is one.
> 
> I think the latter is more logical and less surprising. Imagine you're
> running multiple containers and some of them implement their own bpf oom
> logic and some don't. Why would we treat them differently if their bpf
> logic fails?

I think both approaches are valid and it should be the actual handler to
tell what to do next. If the handler would prefer the in-kernel fallback
it should be able to enforce that rather than a potentially unknown bpf
handler up the chain.

> Re a single return value: I can absolutely specify return values as an
> enum, my point is that unlike the kernel code we can't fully trust the
> value returned from a bpf program, this is why the second check is in
> place.

I do not understand this. Could you elaborate? Why we cannot trust the
return value but we can trust a combination of the return value and a
state stored in a helper structure?

> Can we just ignore the returned value and rely on the freed_memory flag?

I do not think having a single freed_memory flag is more helpful. This
is just a number that cannot say much more than a memory has been freed.
It is not really important whether and how much memory bpf handler
believes it has freed. It is much more important to note whether it
believes it is done, it needs assistance from a different handler up the
chain or just pass over to the in-kernel implementation.

> Sure, but I don't think it bus us anything.
> 
> Also, I have to admit that I don't have an immediate production use case
> for nested oom handlers (I'm fine with a global one), but it was asked
> by Alexei Starovoitov. And I agree with him that the containerized case
> will come up soon, so it's better to think of it in advance.

I agree it is good to be prepared for that.

> >> >> The bpf_handle_out_of_memory() callback program is sleepable to enable
> >> >> using iterators, e.g. cgroup iterators. The callback receives struct
> >> >> oom_control as an argument, so it can determine the scope of the OOM
> >> >> event: if this is a memcg-wide or system-wide OOM.
> >> >
> >> > This could be tricky because it might introduce a subtle and hard to
> >> > debug lock dependency chain. lock(a); allocation() -> oom -> lock(a).
> >> > Sleepable locks should be only allowed in trylock mode.
> >> 
> >> Agree, but it's achieved by controlling the context where oom can be
> >> declared (e.g. in bpf_psi case it's done from a work context).
> >
> > but out_of_memory is any sleepable context. So this is a real problem.
> 
> We need to restrict both:
> 1) where from bpf_out_of_memory() can be called (already done, as of now
> only from bpf_psi callback, which is safe).
> 2) which kfuncs are available to bpf oom handlers (only those, which are
> not trying to grab unsafe locks) - I'll double check it in thenext version.

OK. All I am trying to say is that only safe sleepable locks are
trylocks and that should be documented because I do not think it can be
enforced

-- 
Michal Hocko
SUSE Labs

