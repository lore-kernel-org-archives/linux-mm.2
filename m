Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 978C6CCF9EA
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 23:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8A18E019D; Tue, 28 Oct 2025 19:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F438E0015; Tue, 28 Oct 2025 19:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DCD58E019D; Tue, 28 Oct 2025 19:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFAC8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:24:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29CFD1405E7
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:24:15 +0000 (UTC)
X-FDA: 84049103670.18.CC86002
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3AE48180007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:24:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bHOGkYGl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761693853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlB9WJAF3YhOSJlj9moFGTAHILvUEPk36z3X23Y7y8Y=;
	b=ULwc4KpaSOvmRcn6Ip7xXkrW+KcZbYxTLHFNaDDMuaEojZUtmgfvL+AZ8TRLfVsLsVMA4l
	r4jK4FgIeu9GS/kJS+nHioZOOX0CxINXesoBsX1R2N9t28PpMjeQqG0AYKrLqmjjoFaJoK
	Neku4YvNykLJcJCnEYTJM7Ft3D8tJyU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761693853; a=rsa-sha256;
	cv=none;
	b=NhoSm0lTDchkXlkK8ggzUbG0fiG2QYfMMopCf7Np72KCA1Yy7uMNFxaFroY+JtmBk45CCf
	NcNrxKPtvxhwspEW2rL9TQmxMbJZ6fRH/szm8bSUNSwcbQImvdJp4UHuPJdIYDnglQwLPv
	kBinJOalxNw8X8OljDb8Pa98kX5xhvY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bHOGkYGl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761693850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nlB9WJAF3YhOSJlj9moFGTAHILvUEPk36z3X23Y7y8Y=;
	b=bHOGkYGlqdYJuvtiAR/iv2AxNepGg0f5rNp8FrpwUHBrwiPDOVfZTtBT7gAhQftp/LaWRK
	tkTBQeL5oFLzo4UE11YBLEIi9jliZWh71t8hN9r23n5Bn+fHdTYokChGvi/23PJv6usiFX
	ESFA0MReO2ShiGO48zjD5eGfewGK3Fk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Song Liu <song@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
In-Reply-To: <CAHzjS_vrNZpEbBuHLhHwHaGzLaF3QEeKWz-VikCm0bYrFBq4UA@mail.gmail.com>
	(Song Liu's message of "Tue, 28 Oct 2025 14:33:43 -0700")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-7-roman.gushchin@linux.dev>
	<CAHzjS_vrNZpEbBuHLhHwHaGzLaF3QEeKWz-VikCm0bYrFBq4UA@mail.gmail.com>
Date: Tue, 28 Oct 2025 16:24:04 -0700
Message-ID: <878qguobjf.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: z4g8z7jh8brbbihomqezp14qnbhbxgqo
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AE48180007
X-HE-Tag: 1761693852-188258
X-HE-Meta: U2FsdGVkX1+0HG8LU5KGcwdxzahXK0SIQOa+/xWUgYYBqWP/Sba8kvNAeTfic0uo8Pv4dq1AEQbIRU8uFM58f0XHK1UXx2ZTNJnwIhdKOY+tsIMDKiaLKZ3BPNMSau2xjk4FoqLk3DiXRsL8NCvqJ9XhMjQoSh2ZfDIkUhWhsrsZRt246b19J3um4n22Eq3M6yJDbJyOUyhROvw9MPj6uaDLQLD4QE6BVfr/JdqchOBm11AxJ0S3cBa3DrEKvoMb+Y5bFn50YOxWMKKOxYGbpzU5kk5/JHAfy51b/F+LT8DT56ujSrfbLbWx0ELSXUR93avuBbefXFKLrAe0cKzDQmU7wkaRdoZa6lxBmqrfKuPupN9U25oLgYm1BCVWV/yVjOX9IQVSxtZz09Yxm93MnJd73n0zcnIZNQEXGAk0ry4Pr3brpLZItd/gFmS1q8NlQi8qfziTvLLvgISL3/RA8Y+mcQILJ7umoVAler8T9OtZm/7/KrAu+krUDBwzsYw+wJ2o+pYCJIrqM8q9FMurN7pqeIhwVpUi8E5UPu3/SoTyxO7YBTuxbLSjzDGMMKbt2V5XIUcC6TfzwOYfQCSfmKQFIpChBJBnIS6QeTopJDPeuy76WTTh6H37wSAlUS1e3mcSE4pJCIZ3DePHjGDDAQuAl/ePYCKmHAINfwz+X8EAcRYph9sZyMg4ZUHpPWp3zo5e10Ta6VBGwgXuY5QfDgzVT8LReJgTGIbUCpHQ6swsZhbY5eHsSpPvqYDNSxIK5qfHPRtgq6FLG1eRJpToLBaZmd2VZ7Ug8esyFaPTznoTgXbKcznCTL5QOecGHP52VEwSAMzQAwlv/CF4PCrDx0ecuHnbFHGN8nKdkNvVD7/sLdeLfbHVp5ZS046rosBeP7qJ4xGHMj5ONpMG+tQ3mHAbeIeyDVjGQS0vtfqNsa78E9nY9pvYtN7XM1TBjBhzgD9aQ3xiuHnrTGSt4Uq
 pHvCKiWo
 46SVNkUVtN+cfkKnNIhKLYXbJdP1cWyilVhGFt63aRaL4kbrIyPAfkMyRPzyqdk2WZZT9a9dSznLSHSgWBLdesthhWfgCrrgTKfRWAI+Uw5VBap4uSQNUCGiWbl1RkiNyZFIvkeHzKr7gksilQyshz4flPoceB7igspYh1zo3+fBAgJwwQtzqGqSIVeoAbfAQcyYYd/FNEaSJpUcJpAOvvh1wCb3/N4vDpUeuOvMdKGSqHrQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Song Liu <song@kernel.org> writes:

> On Mon, Oct 27, 2025 at 4:18=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
> [...]
>> +
>> +struct bpf_oom_ops {
>> +       /**
>> +        * @handle_out_of_memory: Out of memory bpf handler, called befo=
re
>> +        * the in-kernel OOM killer.
>> +        * @ctx: Execution context
>> +        * @oc: OOM control structure
>> +        *
>> +        * Should return 1 if some memory was freed up, otherwise
>> +        * the in-kernel OOM killer is invoked.
>> +        */
>> +       int (*handle_out_of_memory)(struct bpf_oom_ctx *ctx, struct oom_=
control *oc);
>> +
>> +       /**
>> +        * @handle_cgroup_offline: Cgroup offline callback
>> +        * @ctx: Execution context
>> +        * @cgroup_id: Id of deleted cgroup
>> +        *
>> +        * Called if the cgroup with the attached bpf_oom_ops is deleted.
>> +        */
>> +       void (*handle_cgroup_offline)(struct bpf_oom_ctx *ctx, u64 cgrou=
p_id);
>
> handle_out_of_memory() and handle_cgroup_offline() takes bpf_oom_ctx,
> which is just cgroup_id for now. Shall we pass in struct mem_cgroup, which
> should be easier to use?

I want it to be easier to extend, this is why the structure. But I can
pass a memcg pointer instead of cgroup_id, not a problem.

Thanks!

>
> Thanks,
> Song
>
>> +
>> +       /**
>> +        * @name: BPF OOM policy name
>> +        */
>> +       char name[BPF_OOM_NAME_MAX_LEN];
>> +};
>> +
>> +#ifdef CONFIG_BPF_SYSCALL
>> +/**
>> + * @bpf_handle_oom: handle out of memory condition using bpf
>> + * @oc: OOM control structure
>> + *
>> + * Returns true if some memory was freed.
>> + */
>> +bool bpf_handle_oom(struct oom_control *oc);
>> +

