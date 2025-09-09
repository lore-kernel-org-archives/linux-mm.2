Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF8BBCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C3B8E0010; Tue,  9 Sep 2025 02:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433B98E0007; Tue,  9 Sep 2025 02:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3225E8E0010; Tue,  9 Sep 2025 02:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21CAD8E0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:20:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA4BC14038B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:20:55 +0000 (UTC)
X-FDA: 83868713670.23.F5802CB
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 99444120007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:20:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M+dKXegE;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757398853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/59r4nKFKoXQCTnkJhQgP9ynEgR8S9O7tupwQt0EUM=;
	b=ZX3uA8hnlNrB2UJPyrAoE7Q2RptmqfUBI74Uc/391ZkpsfRqInOf1CykG4u+W+312BGkGt
	8M7YocMpt+foCNqUzA6PgGPPYHTnyggoCufsMDGRt2IDg6cXha3lkOg6dW4BpDlr67ycTv
	qkuWsnfEdaZ6rWSyMgx3GP+iCbv3Y2Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M+dKXegE;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757398853; a=rsa-sha256;
	cv=none;
	b=uqbMvHNsOqXRYV2XKxMV0Y5gR4yn/JRf4Ntt4681UO5WEJB51C+6z0gw2NxVL4Rv63gkik
	diH6QTLRQHIKdMC35cgP1YChTQeWqd31LwxuGTeV7oSPBbXUqc5ehVibnpEEhsguE7Fsej
	M+k9wlhDCl8capfzLQrNq22jTwe+/94=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b0428b537e5so833859066b.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 23:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757398852; x=1758003652; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w/59r4nKFKoXQCTnkJhQgP9ynEgR8S9O7tupwQt0EUM=;
        b=M+dKXegEsMeKV0dc0tNU8Sb1eEkgVcXt8uz40/KsJ7V5s0gCW5K2Ep/8S7jCLdIRU9
         RSxyDXkRJySDaSMF/Utc6mUtpQe7kJ2PghgWlvKA8aKcQAt7WF2yBwsRoFwsdb+uYG8I
         3IA7Xzxq2vfUMrCf8u5wDPhFRq0ErWzTWmSiKu70MgFpE1n6kJrKhKnlvgh1wHl6FZad
         I2y5GO6oNXhtL3z5t9VhYGSOsrG1r9+O1ZjZfSbP0PPzkOQlMI0u/2R8yBPI7+h1O6ur
         RsFT3vChMNfaJJY9cp7k7R+FtKTl+qJX8oTqOmwTsIWvyXoNtRwyf9Z1UAZTHySTXugq
         w0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757398852; x=1758003652;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w/59r4nKFKoXQCTnkJhQgP9ynEgR8S9O7tupwQt0EUM=;
        b=sdT8rI4wBP16GppuLHtlFRJMPiaKDa2yqjx52JlKSmd5zKxCrghMeAGhnTvCtrAp7u
         gtuEgHLo8VoEpk+TULOG9cjZSx8wsv+xQevfI8gtVcmmoQlw/pZJfuZgZXO9Co9/Db2r
         mIhdsW6g7FUIwaC4K8dxyXyiucgl509lx8QZFZUzOn2NbsO683UFmxdYNaPRxwCx11Xi
         PyxjduPBZ2fOJhE5kbz8TE1Bwk8dATu49wsuuSYZRLBmUQO/t55Omtmfnlc/FEL1yHsE
         yjT1nSMJgAzk1n5uJeviypj26W/Rydl78jl7gpXr3OyMF5zdYbxRSiv+wY1EUjTvclUQ
         ifJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXk5bgsupH5Bx2OASfws7WsGmb2LcFqjiU+qZQHlhR3x3x3DLO1EbynjXU2YUe6qx7a1MA95ol24Q==@kvack.org
X-Gm-Message-State: AOJu0YxLzWzaR5OXZmWy75GHzen7Yq5EblrNGY239b20mlxa/CNZQK+L
	DpTl5eLBTw8dGFpv0iYL/1tTEP4BHXoaZinisIOBgXv6CYw1fYvlOC2kypW/GokzzdM=
X-Gm-Gg: ASbGncvNo4fmLElGUWiTDzvRwzacIphjNMDJ6851E9jnAvcW8RK4pM1lPFYQovdb3qZ
	iqURl4aezTQCjdt5zv6cx6++am/UOCgXvozaDPi0VL6DWVEMYkpu9pQ3lB1v6BKSKdr7kYY7iIR
	aBPi1c83ZxIWyOzQoEMOL2IJoJ+xaAGd14/pgpuAiJBPinY1b+adQEmq5TU8O0mwySL+tQ7cJDZ
	IWcV0zjF2hVM81AFLJSCWcu61OuraoSlDS4viKPK/UCL6M+xaNG/wphtYl652amNMX13OCBRdQL
	q92dlBqljZm7mnW2gsMGh1id1y66oQ9P/12pmlIeqr1btrTrzAGbzWuiFRbn+y4/rf7STSAklPX
	scDmeWDztebqou0AdArHlY7UBG+23xiW0Jg==
X-Google-Smtp-Source: AGHT+IEy7r+3IQg6FyahElzQLsyWsCN+nac3o89gK9QMZ1U0RxA6rWKjSJAXvBlojXrZGYl7wLf9pA==
X-Received: by 2002:a17:907:1c10:b0:b04:1a80:35b9 with SMTP id a640c23a62f3a-b04b13cd575mr1019442566b.12.1757398852041;
        Mon, 08 Sep 2025 23:20:52 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b0761c9314esm150029966b.33.2025.09.08.23.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 23:20:51 -0700 (PDT)
Date: Tue, 9 Sep 2025 08:20:50 +0200
From: Michal Hocko <mhocko@suse.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Peilin Ye <yepeilin@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <aL_HQn9gZjbt4zLl@tiehlicka>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <aLtMrlSDP7M5GZ27@google.com>
 <aL6dBivokIeBApj8@tiehlicka>
 <CAADnVQLtc+OOQ67AS_1+u-sRmO+bDLWJrrihASXMrDNnvrmNSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQLtc+OOQ67AS_1+u-sRmO+bDLWJrrihASXMrDNnvrmNSw@mail.gmail.com>
X-Stat-Signature: nsnwzpbz1ejub51o7yxgogjr66fmbzx4
X-Rspam-User: 
X-Rspamd-Queue-Id: 99444120007
X-Rspamd-Server: rspam04
X-HE-Tag: 1757398853-131228
X-HE-Meta: U2FsdGVkX1+1wWSrao7rNjqXTEB7ec+s1ZM8m6aW/3kmR4DLz+8hONB0fTQn+R2ZCqYPbf5GN+RyV+RmVkPkc82lVtZ6KOsH+wkv5UvCdu2BZ4vqz5LMmLpiBLPQgCxMYNK7k7gcpwxHWEfylTT56REpTxcpptq5HAlsgQVaayx0kyZP3vrsxwyE7pR7XDbBoV9Qkc+lzbzslq05zWlWxeJ7Cut7Amh1CkoRzULr1WFrnfv4YWIa3tM7+nwW7PjL9bHA9VRutMsS/8i6B2CVeo0rc9Vue/a/3P9+EC/jlQClGSvzizyO6BKNiiaIHEWZsBucrulVgiiEK8QHZ/NdNWKiiC0i7+cw2bOqJxxnNGhZyuceI1q9S2Ezmnrbp+30DyJHl4z+hT24n+NtIdC0IBaMmLfJpUkBo6269kVeRjbtvPKw3ssjkj1JivQrb+Li4LA6SRUqLEq+Y4DqPdakE6x1OIgB8809cdmtMxOt810+Un6BoOz7/kmyyGkIetPFdkN8N3Tx57F0XVXBRKgVLFKV7AsFEQOwRel7FVnrFe90YK4OTsZvgqS/cL/tSJOQWoZsDcPlfPbc8fFiW/O0KApV8rF/OqRrPyUz+j+m25aMdCW1wi0/XO0jRDp0KrQWm6GYg8aOU19X6xogmL1OtdaUe9s9Etm/y4ztVy+MA3q7QdzMdhylgHr0ZAM7Ao0sLDBjjq+TcVaU03YOJ9Oq5KAYeS26KVZISFV7T7Ap3Yr00LaqEJ9/Zp4s8wK1/adAEnJd83dsOEBvarpGE57wbyFTA5hYCjCgo25bjCjdfgRp7B9fNY8qRBQ04bK9lz0EEryQHoSrEkh0PuhmAtV3GY1sFMtGgr2EBzEa+YEVJtvmFQPAcCysRO2O9t58wFphRWB/F2HzQWYixKuxUtNfaeMHq4NTtEoJUZwUwjiD8DRdJxWbrz9YQ6vMyewOr4zap6MBNL/Qy/PSa+/OWhb
 KzOkOjte
 gY34qtjD62SvW5EHTO8ZSb0nqfV7Y6QUvH7C1NG2/SAeGkr/RaafW8KthDcUYqJDosn1kHs2gLNg//Dpy48BSqsgNjxE8NPU3qgUexO8Y5spghh4hqttJlvy6nyhewTCEPuxrC2zgRy6CtE8i2j95nMhzGDGfuGyLOgbAKffnj8NBRLspBp+HWDt7rCjAn4hzjk9VMHdtBFyedoBxOoyIymDS4O5Qf+TPaj46Dr1iQhSZyqMMF7Fepd8875oHJ990G4XEf2gLg0CrwiMxX5ly13pgrtnP8U8l+VSfxXe7N40LjoQVKaiwP5ouTOaXtUyPz6q1wasKV6y5sYQT3Gtnc+u6z0zSZxwVIqUH5qHclzyz5uM5cgtgmnQG3iXMkf+MWe/F7OVBff7XWbXPh98UMlBGZN3tEWbfF7BXNTl2kAlu72U2bRcyx/oVTtkbUQLiCPGKOHpHo5gDeofIswQykJGvsGHDDYVSuoz8op9x9bOM6MvKhxkt28gx5dkD6PbvUNUW+JUAG+rEW59IHQumSzes7qez9ZAkRPg1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-09-25 10:11:29, Alexei Starovoitov wrote:
> On Mon, Sep 8, 2025 at 2:08 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Fri 05-09-25 20:48:46, Peilin Ye wrote:
> > > On Fri, Sep 05, 2025 at 01:16:06PM -0700, Shakeel Butt wrote:
> > > > Generally memcg charging is allowed from all the contexts including NMI
> > > > where even spinning on spinlock can cause locking issues. However one
> > > > call chain was missed during the addition of memcg charging from any
> > > > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > > > cgroup_file_notify().
> > > >
> > > > The possible function call tree under cgroup_file_notify() can acquire
> > > > many different spin locks in spinning mode. Some of them are
> > > > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > > > just skip cgroup_file_notify() from memcg charging if the context does
> > > > not allow spinning.
> > > >
> > > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >
> > > Tested-by: Peilin Ye <yepeilin@google.com>
> > >
> > > The repro described in [1] no longer triggers locking issues after
> > > applying this patch and making __bpf_async_init() use __GFP_HIGH
> > > instead of GFP_ATOMIC:
> > >
> > > --- a/kernel/bpf/helpers.c
> > > +++ b/kernel/bpf/helpers.c
> > > @@ -1275,7 +1275,7 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
> > >         }
> > >
> > >         /* allocate hrtimer via map_kmalloc to use memcg accounting */
> > > -       cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
> > > +       cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);
> >
> > Why do you need to consume memory reserves? Shouldn't kmalloc_nolock be
> > used instead here?
> 
> Yes. That's a plan. We'll convert most of bpf allocations to kmalloc_nolock()
> when it lands.

OK, I thought this was merged already. I suspect __GFP_HIGH is used here
as a result of manual GFP_ATOMIC & ~GFP_RECLAIM. A TODO/FIXME referring
to kmalloc_nolock would clarify the situation.

-- 
Michal Hocko
SUSE Labs

