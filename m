Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACCED6ACF1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A966B0088; Thu, 18 Dec 2025 07:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DA66B0089; Thu, 18 Dec 2025 07:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F496B008A; Thu, 18 Dec 2025 07:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 827866B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:17:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0A6E60FB4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:17:29 +0000 (UTC)
X-FDA: 84232492218.05.33FC76C
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id DE614180017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:17:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ilox7QdL;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766060248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82ryBTb0OYajbtmHnpP2vY6hULmAqRanYTWCsyHvjaM=;
	b=ur/3V8IPBblsakJ2HCxaJ0l2xwjUBPPVX+Orf+xa8IaamhVKBcQ7ee3wsmyl6tY6NAVSUc
	Ph9VAbya0nf8liH2wYZJA250TySLlKaEKB740H59bPETwC32q2Mc9HPkKDVtmYrg8x7nim
	UCVDVkpsNgsqbgZUqNSad5GMWTf7kq8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ilox7QdL;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766060248; a=rsa-sha256;
	cv=none;
	b=fViISpSgSXor301zrs25XTsOzo5SaOwQ4DYvn8VCSY9OH6xU51vkw61xhh/czGSjqAssxr
	ML0Gw0DDUlpy4eXZ1JcCGmGJllLqBTOZ7hneesi3KnXEHxIsCRfO9act9q7hxzGVojXJCX
	8DM4PENVzUss4BgFZrOsEBPBxM+JeZo=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-477aa218f20so3698715e9.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766060246; x=1766665046; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=82ryBTb0OYajbtmHnpP2vY6hULmAqRanYTWCsyHvjaM=;
        b=Ilox7QdLLgNECTVJ2z7YC0XjyWEnlVsszd9wpjXe3m8NM6YVtDjKxT9rj52jzOU6bB
         FZ7Rw/mDbhLERMEXc+Q01I5d6c26HQhFqVw/AvC/MmblzFFDe32qpAp1U7upncD2+ihI
         DksEeLOpsdpDIlHjBCuIdd9EU3iBLiFcdZH/T2MsoQePf7dAN7z8PFgLsfljkU5UBYde
         aeAicm48+/ZEYw8ZPFffads0XLZ2OjT9ca1KlDe5YLFncAxk9VBnvCedJlP2qw7lQkhN
         UJak84yuUUbMWdMHYIbqKqI1QPGzR13p7JClevGUZfCumzhIC9fc5UIX5+R6PjUgR46K
         lFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766060246; x=1766665046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82ryBTb0OYajbtmHnpP2vY6hULmAqRanYTWCsyHvjaM=;
        b=vdZfFzUjO7KIJVzRazNY0T2AKjzc2R4dxdC1mffSBy9ZLZhySqh6FPcScMp9nnjgc4
         EVEw9AVyrsa1ET7KXj6E6FOqc8uoy1e1LxKT2mR7zQWjUjXngEWxQAbhpF6YvqQJxi9F
         i4rz3HHgs7Kanf3+d0yefr9KFklZbnvjA8RpL/JvU7NwdshT7pZAHRU6i3jwFx3v0gm+
         t+aWM5s4T1khOq7YdoILPMVYHdyDHDhqVyxJIhpTUURFxIdIeIBJ7Og64bwAJ8Wqz2lt
         RlWtXjQQJrUE+10Z5hb0hLIEgotez/PqMKvoj9fpXDMZrpVVvFbKhXWjzFmd/fYQU1nT
         sb0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmocw/U+2TB61ffPPhq3fBiCiuV9bR58rtH6fVvT35Oq2mC1/DNG+HBQLdpc0ByqkpI5XHY+rsEw==@kvack.org
X-Gm-Message-State: AOJu0YyE8pwQPSXeMgIkAXxOA4HYfS1fIUXhgD8rvJ2Cr3swR9nnBIe0
	LDHW+SPuufv3/LO9PzEJB8kdpudpHgpqfs0f+PIZbUirPt104TcSHHZ1s8PVsuG6/cc=
X-Gm-Gg: AY/fxX63Khqk5/zGyAX01X+8XOpRtzPumoIffo1sV1v0On1kYNDg9wFjlx+pEiWNIhi
	IDnOnYXOu6KBpgHCz3P8yEECzhWcIUrrCbq9a/pMZYx9+H6CKmFdR6oE3VeVjaYu+qphtj7+Q1m
	m0+H2Lpu+7GuTiRyZoCnH7B3me0gz0aDzxs9zC4lQNgH7NdwxY8od4GxuLIVA+NI7y++2YsD+yz
	PQoy+dkek8FjeGRR+RgckZAZHu4D5jiPAsD7O6kRirQHwq4dz8vRDmMbm+iRlavppg2gjZC94jG
	C3ijlY9itsOS2AAw0dP6R7qrTeWyuMv0qo9UQ6Nf3CIc/X4l6p5oKImSsdzLnqtxTXYISP1HfVH
	PTvWJSV0ISSGbz4CwTwQk5Fgo+JYjCZWvem6gC2Ybh6b1yFWgfZKDrwaJRFcABFts4szilvPOlb
	Ug9p2bL9bZf/7uzgEcdC6dVh9zrTJXmzXMo1k=
X-Google-Smtp-Source: AGHT+IGTUeEzz8tNPQ2pmX/MnRbtFTT5HvfYasuVnspclS+oD1dD2L49trQ2Os59ODIZ3jVEB6x5aw==
X-Received: by 2002:a05:600d:6405:20b0:47a:935f:618e with SMTP id 5b1f17b1804b1-47a935f64d7mr172794535e9.15.1766060246405;
        Thu, 18 Dec 2025 04:17:26 -0800 (PST)
Received: from localhost (109-81-80-251.rct.o2.cz. [109.81.80.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432449ae0ffsm4488541f8f.39.2025.12.18.04.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 04:17:26 -0800 (PST)
Date: Thu, 18 Dec 2025 13:17:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
	rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org,
	kevin.brodsky@arm.com, dev.jain@arm.com,
	yang@os.amperecomputing.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while
 stop_machine()
Message-ID: <aUPw1YFNLf7ONqe9@tiehlicka>
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <20251212161832.2067134-3-yeoreum.yun@arm.com>
 <aUPJuZINNuNxddRX@tiehlicka>
 <aUPLCPAyxkPeBaoD@e129823.arm.com>
 <0d08b4bf-35c5-4c63-964b-ef886b8262d9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d08b4bf-35c5-4c63-964b-ef886b8262d9@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE614180017
X-Stat-Signature: qityqutfsqsxcryae3zcadj73gzyichf
X-HE-Tag: 1766060247-320525
X-HE-Meta: U2FsdGVkX19wimAr3gZJUEnCeIIQn6ArkGucgYGE4fqEwv2myfgx5dmunPrtS9mHuuq+B9DvM0TLX+ndXR1khro24Y/h5vEqQq9puYFPSIFHzORGlkgm6T1YPCCpA4CMcj9qKNkx+t2jhN+HYXVTAF5wqnGLkLrbSLBlOUQUcS0VLiNHSgz7tpN66L7HRNKhEbKoKq7ZQGaCndhGdoKFsGGlp0LqzZvCL7O1vr51ojg9VziYsGD+DIiqeIW9SaSU/VmnFVwBa4d2ejnRz8lw4+Hd4xskwMBVOOU/68rO8L8q/8JwPEANWjCcIW7utkKngHi59hJ8tOUtGgCSlD3xCPaFbi9sOwVd5hqb6QyPG+zOznKV5fs9/YroE5wsWuAxNOPV+nO8NSaxVh4G7uuIG7SqjM739GjpVyusrb60DmsuyR3AyoLX7Xr6QdI118TlxSw3Nz+175k0IXNbVcRrGbtDRxd+CetpfO7NOXhTrAc5PszrDY6VxGp0x5nK8uGFTsY6Fj1dB+GG0qcMM3oM52EMx7wSuGyBjc0OsvU/JJ3712itOpzavQ+xzj/XL/ncu/btZ8Bnq8lXl6eyurLADj7s9VexdVtNS5dqFQVzwiWvg4OjfLwKS74DGBjbcnMlVKOo8DB9SBDbu9jaDS2DNN9QAT5cScamt+dOlF1SLUjHaRo7iSe2zFEYNL59TwHOjsIyfPYMkOeAa/HRUUowTajlJMaST/OMbDcn0HejppHOndJIBN48TZHW8eAP7tDnGTtEwcuTSv66ywNVFCBrs8I1FhrogGch1ejFj/g4MxQgHQiELgXIktiZqWvzba4VDQYmUilPUsgJdvtYp6UbZjREXPiVdplyS36g/3cJvSbY2gE1nSmAuWyi49mA0TwCtpvujfYfJLexPz0+0W6sPqWBKpSEYR2I8oZiQcTbegGzt1kJIE+jufyF9Cm2m5Yj9SjhCHIZwayXsMzBjlw
 bh9aYjer
 wqmDfQQ+9XL9BiuiuO001RnYAxc2ypBBWYcYktsOllnywXGGyafetpAHLxAYtWEYhf1OfQ7Pq4ZYn54M7gcS4nCL38DSjzMTxEoZpzBxJrjy85VxoyrdD1LMiVWyuyE9oqe7exHWS1Eig9eHsMfjAWWP9G1afcNpIZrjfbKh4k7qOPyfBtxGa0lZlJp6/jVRFnB1glNgYHxu8GbSqh7M8YUD5W65RAYuYzPINfhM89CHzE3NLM0hDOicBpZz7iCHC0gpDtsIBNGUGnzypnem8AtkopKrFrZ0WYC6u7MAp6uXBAelr1brgrvnkDmWNJ+5dzjsHs4gVE06/cKP/Kd7XR2Ny2cRl9CCAxBFZHiHOeEVVmqqTgGQ09R9p5exEvFoASEO8ASjREg25pZPsno8o/btifPQ1kqH1uxZmIu/sa8RuumqCc4a6Hl2uaCsJ+VfByx5zVQwy++37G+wJIGU+6VFZNsT3OsyhH2dA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 18-12-25 12:02:14, Ryan Roberts wrote:
> On 18/12/2025 09:36, Yeoreum Yun wrote:
> > Hi,
> >> On Fri 12-12-25 16:18:32, Yeoreum Yun wrote:
> >>> linear_map_split_to_ptes() and __kpti_install_ng_mappings()
> >>> are called as callback of stop_machine().
> >>> That means these functions context are preemption disabled.
> >>>
> >>> Unfortunately, under PREEMPT_RT, the pagetable_alloc() or
> >>> __get_free_pages() couldn't be called in this context
> >>> since spin lock that becomes sleepable on RT,
> >>> potentially causing a sleep during page allocation.
> >>>
> >>> To address this, pagetable_alloc_nolock().
> >>
> >> As you cannot tolerate allocation failure and this is pretty much
> >> permanent allocation (AFAIU) why don't you use a static allocation?
> > 
> > Because of when bbl2_noabort is supported, that pages doesn't need to.
> > If static alloc, that would be a waste in the system where bbl2_noabort
> > is supported.
> > 
> > When I tested, these extra pages are more than 40 in my FVP.
> > So, it would be better dynamic allocation and I think since it's quite a
> > early time, it's probably not failed that's why former code runs as it
> > is.
> 
> The required allocation size is also a function of the size of the installed RAM
> so a static worst case allocation would consume all the RAM on small systems.

Understood. But is it possible to pre-allocate early on so that the
allocation itself doesn't have to happen from a constrained context.
-- 
Michal Hocko
SUSE Labs

