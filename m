Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1AE606A321
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ynM21o8A
Received: by kanga.kvack.org (Postfix)
	id AC2DB6B05B5; Fri, 30 Oct 2026 18:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72C46B05B6; Fri, 30 Oct 2026 18:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9889E6B05B7; Fri, 30 Oct 2026 18:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28E3F6B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:34:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 937951A08B9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:34:41 +0000 (UTC)
X-FDA: 85380748362.16.FF56F09
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE1E3A000A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:34:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ynM21o8A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793399679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2f8T8U81pT6wJiYZ20wPG7me1u2dTv4P3a8KjTdXm9I=;
	b=2TfeUBrLbYucPIVmZnOGvaPv4taHPv63FGL1bCG0MGCQNNMDyDm+dJJ0mFbmmMz9nNFhyR
	2xKJ32DEIR6wdMxp8LbYsFesegl4XZvN0PWj9S1lBC4tSL1xoL0yf2EZgaEHxUiqFdvkEZ
	v++8niLvOjnVb/4tRtlYsFf8+vf5EdY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ynM21o8A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793399679;
	b=1cox1Q4tYl6cPGzCfdugxQsKDV3drPSx1D9bwW/KqQRucoQ82Iqhhh/6I22no3X8eyhG4W
	gxUjmkmrXNv+A/AY368LUW4pYCJwAnaNxKcClByFqFtX83saSJt3drM1m9xJaj1TEChNjb
	i++Q4vxwz1QF6e/8Dk+SoPVtl4zmqNo=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so8156755e9.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793399678; x=1794004478; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2f8T8U81pT6wJiYZ20wPG7me1u2dTv4P3a8KjTdXm9I=;
        b=ynM21o8AJwJ09G8B50X0UGi385hrljO/iNRuSPhDZQp7rAu9yJba/xcC5dJyiCCsSj
         YhiknNqiSUHuNDVUecsYVHP3FegZNnTsbVZeFt7dvYE7NvfykdPGJfYhwn4brh3cyqMH
         GCYO1C6iZzW2p/tydtRnlnl3KV1tkgLTnROJ2iWi4mBbGPWw0IVxQ6K1bLaPSrDJsq5k
         HIDDbx8CEucwAnbJo2e3ByjAM09KH5BpMven7OAN0YR03oWAqhh1N/SJbppv8Q42DfK9
         0x3he/b1tmARzvYzlIocaK3wXWgjxIfhFCfO97l2FPg8T+DMLcHgu7sicxJKQnam+uTC
         JhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793399678; x=1794004478;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2f8T8U81pT6wJiYZ20wPG7me1u2dTv4P3a8KjTdXm9I=;
        b=W5AtgHtxrLf/wedVvepZaHFQH0itJeJNE9b7CkcrMKkhiyc6z35UGv8LCSE2vaM9sq
         co/dYfVb6wZFWvikDgO4OF1aJTS+XM9r4Hiv5/I6IsUjG5VOSP69pfXcpF+IGNDDx/U+
         2EJKqTfdPhvvZeGibalNJxx4Ntq0QAXNjCFbOgzgqlmQBnY16x5ufAdopoNZfWRFSojo
         x9mNz7QprnBbcP39EEZtZXkbcipWbLXmYpo2vGCawB7ZgVsd0ZGuHQ5e7pOVhUv0MVN0
         LNhKJEvrgSMZhwPWC588enTUdYTe6wdr1Mk/NLjjuhZhVeY5xCiG63xA0ddokuuthSs1
         BONg==
X-Forwarded-Encrypted: i=1; AKwUvBy9hpg/c5ql/0sAXQYThZuvdNI9Em/e7oA4SHjdP8XerP2TC6KBqoAaVLp+uQASAY4Z33Bn2A1leQ==@kvack.org
X-Gm-Message-State: AFq9FYIHm5ihbXMtO0vfJmT3JF2JHuGtzyYR75fbb502g/2/O3UQoF+9
	Y53/NMWobM8p4m16n+pp3D0tRlXYK0vGzMUYG6i+8QAkij8Pjasgfd77
X-Gm-Gg: AYBFou34bj+6kU6LIxW8L3rgq64oSyY49fiIdAXGOk7Ms/ByUdFfiiMbkRNuBS471Hc
	drd0StSQXXiIs0DDcbt52i/C9LEacwC8hGxh8ND8e85Y8pWvP04GXGXbNLZBsgOmCjWLZrDsHeZ
	Zc5X60g4f89FejFhSMUs5o4pl4ryb1LnZESLIXMW8C+sqyPku81uoqvSf+2CDNb76zkGqWEF59D
	7aqg3AhC4jskTbjFQdkwF98Pm7hr9uHHZ1ps6LJWgoId51yozEqEKHoMILi1KAb/zVQ2S1HpLpe
	EYdaZaWbyS9612kOK3YwJufoRkWzfAUjsgzQYcpjcRGKDBtEvxbVK7e77yjZra1zpNkIaT1UdsE
	M/yHujqJVpAf/kxLwclP9Cuw2OMb+0Z/04i2LEVAe71LWP0QfLK4avwqTmycS4/FZufglRMLWgK
	wY1ajThriqPDNGrNFpfv8ia/xZ4dOyZ2PHkcRidC3ZSMLSa2mT7gHLxRV4u/IqmfTQHVvvr8fLw
	oUoBznd/BufuCqB8fV6MH/oPJaCMx5+l1H9xj3G7iiCWHI1/68iPi3nO4nYa1yAIlB6gP+Ms0Q2
	A/uOEWB9TG+Ffal/0NRxQVuodEDY9mWq250X/U3+mmfiPCP2wcdt+FrdNbfbIEGlHpALI7KZ3f3
	tNyL+xK2LqZg=
X-Received: by 2002:a05:600c:4e41:b0:4a6:42cc:bf6c with SMTP id 5b1f17b1804b1-4ac16acfbd0mr76349985e9.7.1793399677342;
        Fri, 30 Oct 2026 15:34:37 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81a896fesm183306595e9.10.2026.10.30.15.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:34:36 -0700 (PDT)
Date: Fri, 30 Oct 2026 22:34:35 +0000
From: David Laight <david.laight.linux@gmail.com>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah Khan
 <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/6] treewide: Replace memcpy(..., current->comm)
 with copy_task_comm()
Message-ID: <20261030223435.0e802eb7@pumpkin>
In-Reply-To: <20261030-tonyk-long_name-v8-2-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
	<20261030-tonyk-long_name-v8-2-c9b030332254@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BE1E3A000A
X-Stat-Signature: fx4mm94ot5qm917jbs7nwyonc3epnw4a
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793399679-890170
X-HE-Meta: U2FsdGVkX1+K13RRsB07uRwwTrSVgEUSwxGnrZRWblS22MByUchwWX0VwbGZ62tLff8LQcKBbSO7pgjxcQl3VRMnfdip/t+3WGeRbGnOEAc91WoaqdWMqWM+MBNYBcdAnggEUW/K2yZkmS/zb96AvZyGiU7OLE36BDgOmoZaMAR9wT6R1vx80PGSCLj2El0NwpdlEX74nv4uPhgnndCg3FhU/7GutDJyO6teL5W1mcgnGGSfITZhRRgRFjcOJV2HdwMWzV18yMknD9SW5O2hytgrkiV98qQ+ocp63Skj+AkFvuLDYSkhwOLnv9YJtqzi7pA+p/5K7YdZa59GA8Zylv5dhMkFlCr3dU163uceAj4khx1HBt8S9hGfPdlS0mr64iO77ybe07hFPo1RyxMDzVdoOh3I70oFaq1H8aCuEpIWhOEtzMJLnzOq92GjvYGhepgWRo09datWCRzKZVteQ4cBo70qphvGK3UNVYeM/D/KIgONScJX+tzq21ZMCpcYFQeAujf4MydY4UjGzX2Z00/UnWSS7I8eMcsxxYg2CWhmk4n1RCzTzlG5DEm3+xGSlFNVQaEjqugLbDL+iKwgZcK1RgV5d9WMEXhrXQFUqwEdwiz4bo6E5ASu8NSGnmjRLCXWelmDwU0rdqt4/y4+ydmyIH+uHozMd/7RoMm4B1Eryt+Ae/P02JmC3hjEdB1uJvfh8O6AlDrW36buYOSrE9z9bW32joZ0HF35pTt3ZGqWnI/KyzIsUib4tt9Btq88xTTm7+RxskXrf8wAt0XNS6zBhyxs3YdV7aqqt5o2frZfkU1DXne172V1W3i7gww0X9A02sBp3F/6Xbv/og0YlJZW30iB4D4rRbV2LbjSgwPuG5BSAt8g/uoEUlyPvnZxd1nEq0i+9e/vvf9gJmB80qjeF6IBbupiVps57DZAqKXlnT7uQ44vkmPKZQzeWjpuHglahctMWd2YtCHH6T5
 BWZKSx4c
 FLlMDLRLNba7UP4QlVcTskOZKtbpy0MatczvtrHhEp6yPdpbPWUdCtShWPPtcfaWhv3V7F3E0viPTBlyvX9KO6jIyyogAyfUuee6rmBFGi60fecv9MULGPRQnQWK3sg0wLvsSl877SzzEctNzaj5IiNNu1LRCG4MRkMTTcd9z3V72P7y/VyyK5UgSybP8Gxu1MkQNZzscdycnDbdfQ9Dkzzpb1AzBYwxwk0YJcMUzXcoeOF2xKSOGW4MrgNL4wEw4F8jvFIgFpThTrMM5ffD6b50uTtY16UP43f8bEuQFWzhC5mKpbMqkQJgcwhunKYHxluL88f2Y7Omo4eXLmhEqtFDFI1QWsgrGCVMcxqblN+A9UhxlTCBnh7tKikartOtIc/nfy7Od9PqdrclpBJUhvwhzLUS4Z4A5vmPHPHri/uGTYwgznR0bn1N6U8ERHIKgw2iBbikNbrmGKW1xD7iA8t/rCfBcVfBdRQXKQcm7B+cHFZFitxkuyWteS/P/AUu6OI0Ul7xLRvOMh2XsYk3exCowI8+dpVuTNwPzYDofGMSawPm5vZLo1fJOWQp4e4RflgI0/3XfviWTwsQ1oDTtjZ+CvnjH8y2rrqn0Prf6SyQ9UbWNU9h9D86ZC9cFRWhZPxbA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 18:38:33 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> In order to increase the size of current->comm[] and to avoid breaking any
> existing code, replace memcpy() with copy_task_comm(). This new function
> makes sure that the copy is NUL terminated. This is crucial given that the
> source buffer might be larger than the destination buffer and could
> truncate the NUL character out of it.

I suspect the trace code would be faster it is just copied the (first)
16 characters and worried about whether it was terminated later on.
It does far more 'saves' than trace reads and their performance is
much more important.

David

>=20
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> Changes from v4:
>  - Remove copy_task_comm() calls for structs other than struct task_struct
>  - Add checks for len > TASK_COMM_LEN and len < 0
>=20
> Changes from v3:
>  - Simplify copy_task_comm() to a memcpy + NUL char at the end of buffer
>=20
> Changes from v2:
>  - Bring back custom function.
>=20
> Changes from v1:
>  - New patch, dropped strtostr() from last version
> ---
>  include/linux/coredump.h                                  |  2 +-
>  include/linux/sched.h                                     | 15 +++++++++=
++++++
>  include/linux/tracepoint.h                                |  4 ++--
>  include/trace/events/block.h                              | 10 +++++-----
>  include/trace/events/coredump.h                           |  2 +-
>  include/trace/events/f2fs.h                               |  4 ++--
>  include/trace/events/oom.h                                |  2 +-
>  include/trace/events/osnoise.h                            |  2 +-
>  include/trace/events/sched.h                              | 10 +++++-----
>  include/trace/events/signal.h                             |  2 +-
>  include/trace/events/task.h                               |  4 ++--
>  .../testing/selftests/bpf/test_kmods/bpf_testmod-events.h |  2 +-
>  12 files changed, 37 insertions(+), 22 deletions(-)
>=20
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index 8e857770dd21..c3009edc2595 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -79,7 +79,7 @@ void vfs_coredump(const kernel_siginfo_t *siginfo);
>  	do {	\
>  		char comm[TASK_COMM_LEN];	\
>  		/* This will always be NUL terminated. */ \
> -		memcpy(comm, current->comm, sizeof(comm)); \
> +		copy_task_comm(comm, current, sizeof(comm)); \
>  		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
>  			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
>  	} while (0)	\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0564aabb1393..db529a93525d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2042,6 +2042,21 @@ extern void __set_task_comm(struct task_struct *ts=
k, const char *from, bool exec
>  	__set_task_comm(tsk, from, false);		\
>  })
> =20
> +/*
> + * Copy task name to a buffer. Final result is always a NUL-terminated s=
tring.
> + */
> +static __always_inline void copy_task_comm(char *dst, struct task_struct=
 *tsk, size_t len)
> +{
> +	const char *_src =3D tsk->comm;
> +	size_t _len =3D min(len, TASK_COMM_LEN);
> +
> +	if (!_len)
> +		return;
> +
> +	memcpy(dst, _src, _len);
> +	dst[_len - 1] =3D '\0';
> +}
> +
>  static __always_inline void scheduler_ipi(void)
>  {
>  	/*
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index e0d838c9ce93..9b0094fa44c6 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -637,10 +637,10 @@ static inline struct tracepoint *tracepoint_ptr_der=
ef(tracepoint_ptr_t *p)
>   *	*
>   *
>   *	TP_fast_assign(
> - *		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> + *		copy_task_comm(__entry->next_comm, next, TASK_COMM_LEN);
>   *		__entry->prev_pid	=3D prev->pid;
>   *		__entry->prev_prio	=3D prev->prio;
> - *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> + *		copy_task_comm(__entry->prev_comm, prev, TASK_COMM_LEN);
>   *		__entry->next_pid	=3D next->pid;
>   *		__entry->next_prio	=3D next->prio;
>   *	),
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index 9c97a16850b9..1e3a9ded03bd 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -213,7 +213,7 @@ DECLARE_EVENT_CLASS(block_rq,
> =20
>  		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
>  		__get_str(cmd)[0] =3D '\0';
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("%d,%d %s %u (%s) %llu + %u %s,%u,%u [%s]",
> @@ -410,7 +410,7 @@ DECLARE_EVENT_CLASS(block_bio,
>  		__entry->sector		=3D bio->bi_iter.bi_sector;
>  		__entry->nr_sector	=3D bio_sectors(bio);
>  		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("%d,%d %s %llu + %u [%s]",
> @@ -493,7 +493,7 @@ TRACE_EVENT(block_plug,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("[%s]", __entry->comm)
> @@ -512,7 +512,7 @@ DECLARE_EVENT_CLASS(block_unplug,
> =20
>  	TP_fast_assign(
>  		__entry->nr_rq =3D depth;
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
> @@ -563,7 +563,7 @@ TRACE_EVENT(block_split,
>  		__entry->sector		=3D bio->bi_iter.bi_sector;
>  		__entry->new_sector	=3D new_sector;
>  		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("%d,%d %s %llu / %llu [%s]",
> diff --git a/include/trace/events/coredump.h b/include/trace/events/cored=
ump.h
> index c7b9c53fc498..fdd20bc46bb0 100644
> --- a/include/trace/events/coredump.h
> +++ b/include/trace/events/coredump.h
> @@ -32,7 +32,7 @@ TRACE_EVENT(coredump,
> =20
>  	TP_fast_assign(
>  		__entry->sig =3D sig;
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("sig=3D%d comm=3D%s",
> diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> index df4cd346ae72..e3f2047f9de8 100644
> --- a/include/trace/events/f2fs.h
> +++ b/include/trace/events/f2fs.h
> @@ -2589,7 +2589,7 @@ TRACE_EVENT(f2fs_lock_elapsed_time,
> =20
>  	TP_fast_assign(
>  		__entry->dev		=3D sbi->sb->s_dev;
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
>  		__entry->pid		=3D p->pid;
>  		__entry->prio		=3D p->prio;
>  		__entry->ioprio_class	=3D IOPRIO_PRIO_CLASS(ioprio);
> @@ -2642,7 +2642,7 @@ DECLARE_EVENT_CLASS(f2fs_priority_update,
> =20
>  	TP_fast_assign(
>  		__entry->dev		=3D sbi->sb->s_dev;
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
>  		__entry->pid		=3D p->pid;
>  		__entry->lock_name	=3D lock_name;
>  		__entry->is_write	=3D is_write;
> diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
> index 9f0a5d1482c4..8bcdc4ffc8d3 100644
> --- a/include/trace/events/oom.h
> +++ b/include/trace/events/oom.h
> @@ -23,7 +23,7 @@ TRACE_EVENT(oom_score_adj_update,
> =20
>  	TP_fast_assign(
>  		__entry->pid =3D task->pid;
> -		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
>  		__entry->oom_score_adj =3D task->signal->oom_score_adj;
>  	),
> =20
> diff --git a/include/trace/events/osnoise.h b/include/trace/events/osnois=
e.h
> index 3f4273623801..2cf047bb9fb7 100644
> --- a/include/trace/events/osnoise.h
> +++ b/include/trace/events/osnoise.h
> @@ -116,7 +116,7 @@ TRACE_EVENT(thread_noise,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, t, TASK_COMM_LEN);
>  		__entry->pid =3D t->pid;
>  		__entry->start =3D start;
>  		__entry->duration =3D duration;
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 535860581f15..afb24e9dac91 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -152,7 +152,7 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
>  		__entry->pid		=3D p->pid;
>  		__entry->prio		=3D p->prio; /* XXX SCHED_DEADLINE */
>  		__entry->target_cpu	=3D task_cpu(p);
> @@ -237,11 +237,11 @@ TRACE_EVENT(sched_switch,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->prev_comm, prev, TASK_COMM_LEN);
>  		__entry->prev_pid	=3D prev->pid;
>  		__entry->prev_prio	=3D prev->prio;
>  		__entry->prev_state	=3D __trace_sched_switch_state(preempt, prev_state=
, prev);
> -		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->next_comm, next, TASK_COMM_LEN);
>  		__entry->next_pid	=3D next->pid;
>  		__entry->next_prio	=3D next->prio;
>  		/* XXX SCHED_DEADLINE */
> @@ -346,7 +346,7 @@ TRACE_EVENT(sched_process_exit,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
>  		__entry->pid		=3D p->pid;
>  		__entry->prio		=3D p->prio; /* XXX SCHED_DEADLINE */
>  		__entry->group_dead	=3D group_dead;
> @@ -787,7 +787,7 @@ TRACE_EVENT(sched_skip_cpuset_numa,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, tsk, TASK_COMM_LEN);
>  		__entry->pid		 =3D task_pid_nr(tsk);
>  		__entry->tgid		 =3D task_tgid_nr(tsk);
>  		__entry->ngid		 =3D task_numa_group_id(tsk);
> diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
> index 1db7e4b07c01..8fffe6d9bdcc 100644
> --- a/include/trace/events/signal.h
> +++ b/include/trace/events/signal.h
> @@ -67,7 +67,7 @@ TRACE_EVENT(signal_generate,
>  	TP_fast_assign(
>  		__entry->sig	=3D sig;
>  		TP_STORE_SIGINFO(__entry, info);
> -		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
>  		__entry->pid	=3D task->pid;
>  		__entry->group	=3D group;
>  		__entry->result	=3D result;
> diff --git a/include/trace/events/task.h b/include/trace/events/task.h
> index b9a129eb54d9..e3faaeb997ef 100644
> --- a/include/trace/events/task.h
> +++ b/include/trace/events/task.h
> @@ -21,7 +21,7 @@ TRACE_EVENT(task_newtask,
> =20
>  	TP_fast_assign(
>  		__entry->pid =3D task->pid;
> -		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
>  		__entry->clone_flags =3D clone_flags;
>  		__entry->oom_score_adj =3D task->signal->oom_score_adj;
>  	),
> @@ -46,7 +46,7 @@ TRACE_EVENT(task_rename,
> =20
>  	TP_fast_assign(
>  		__entry->pid =3D task->pid;
> -		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(entry->oldcomm, task, TASK_COMM_LEN);
>  		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
>  		__entry->oom_score_adj =3D task->signal->oom_score_adj;
>  	),
> diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h =
b/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
> index 45a5e41f3a92..a197622e113c 100644
> --- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
> +++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
> @@ -20,7 +20,7 @@ TRACE_EVENT(bpf_testmod_test_read,
>  	),
>  	TP_fast_assign(
>  		__entry->pid =3D task->pid;
> -		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
>  		__entry->off =3D ctx->off;
>  		__entry->len =3D ctx->len;
>  	),
>=20


