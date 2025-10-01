Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D67CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 22:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8707C8E0008; Wed,  1 Oct 2025 18:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8481B8E0002; Wed,  1 Oct 2025 18:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D848E0008; Wed,  1 Oct 2025 18:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 618F28E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 18:25:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 003081402B9
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 22:25:38 +0000 (UTC)
X-FDA: 83950978356.06.4778349
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1531EC0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 22:25:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FX8RDkQT;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759357537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzvrs1VV2WDiIUvA5i+R/HiHvohIXfIQ0AqUBNp0VuQ=;
	b=diRCERL5SEwpWR2RMKztDguSrdoW6LoH0YZkqq7QB4TRCXIKt80F5GMwgZsPnbiP4WHg0r
	NCUib5mVvmzyJkYayoRaVscJ9V+7ZnmUyVe02/mzgz2aJXoNDl5g+lqM9JNE2vbIU7dFFc
	7upjTmgigcMs+ALN4NHpdkPI8sBpiA8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FX8RDkQT;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759357537; a=rsa-sha256;
	cv=none;
	b=zVg2m4ngll2ltV5yHQ9fqQkXpKE4Q2iAFwDv1Y3bCU03nV0ft849eXglKwcnlzVlKovShZ
	53FTQOMAfc1yTdS4yaZhkEobaamB4RBg1nOJlJ8GyodSLUg+PpvrWU6FNR0q2UoWVPiIB5
	pzc4WiouVe/zyybBnP4BunR3LpNDDYY=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so172732f8f.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 15:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759357535; x=1759962335; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzvrs1VV2WDiIUvA5i+R/HiHvohIXfIQ0AqUBNp0VuQ=;
        b=FX8RDkQTXPJNaXeOFfkEu+Ava2zVpSZvDZUMpghS0HfSKbQS1IhGOMDianMw0qpeBZ
         MHNnu6nESGBMXfMc+jN4FaZzssWBsgjRCrGneIbvUzXqJ9s/9WqPr7ySQJgZm3zsbyw0
         4uDxxs6IUa+n7mrTKSonlSrvTJ35tyxFvyOe2w7Bhp/PUb+t++PDq9w+Uu/Zhf7kwf9v
         Qei18X2Qrefo7KVKJ+hY7my3s7ID+dHSBvrdQVXVw9GHPHTpHDNIqtnUtav1Gj9Kndyb
         oBHiqPp0h16amilpo8E/P0BJjh4sFWyHvflVtjEg3XV3MBGK73fcrw8uErz7RADWqLrq
         Y93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759357535; x=1759962335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzvrs1VV2WDiIUvA5i+R/HiHvohIXfIQ0AqUBNp0VuQ=;
        b=ht1ALWXMumJdZA6fXD2ve9erZbmftHmKtUkDwqalkUaZc0ePkYTtGTVT6VZOHErxjA
         /RV8HuIaa7XE+qFeZ3qDKMewa/2pDHp0BdQb0MyypxcRsMa0j6acSaOm2Zesmb7o2VfE
         nyjc4oxtvY0qnuqXCqjCV/ko7/BT2tpscyJge+2lnuxobgyNboWFVtSKaV+bWgJA3iFX
         /Cn+EJRUxswKMaYevcCnBoYTtJngVgjiA2Jgs6+o/WJCXRQust9fIOOdd36GRTL0Cs8h
         2XQzmv7uuhWLW2OBmTnpvc4j+vzPeTDrXjyXl5sPf5Zk7uia7dkudBRvn7NtONr5owFE
         SvOA==
X-Forwarded-Encrypted: i=1; AJvYcCXy8yGbDfB1yC4kzZoq6Jdb9WxEsZxJfzrH00s0MgVQXeELRuU+pcvW+5dyF1WE4vT8j/DqnfvYYA==@kvack.org
X-Gm-Message-State: AOJu0YzaE5ZV7vkT+j1IDDz53MLfY1OGUeLmcmzAVSoDVhzEcGnn4kD6
	B9fkFVsX+N8FzsUfucA4Pqlpa+J3H2Yr2QZoQtcsI5PWN4cgG9xx5XDTpkNYNqPkudppVDh3e17
	l9iTIFNZ7RH/DNtNsqxjPvaoe91CuiX0=
X-Gm-Gg: ASbGnctw+US+bgpssKZexy2IP1ndc3t60o2xn7MPrw2gql2IynTv9JoQIVTKTYtz/Ja
	hKdqNA+0Apq5QBgnrS41Sz/w5xWPQJKnvVM+xUH3vQLcxq2lndsIHvJ70ezJgQDiT98x6bsN4td
	6//RaxdPqDLTK7dAt1JcBfgy9kz+H8Qg3eZQGGr7PAAqme8u5qLOYwuO6uYlL4wDZyGF2QWVAhE
	/O/Ruwt/sjvD72uFwB0SPNVNw6rI8aucvltlFEcDRAmQTxzviU56p8trPBz
X-Google-Smtp-Source: AGHT+IHUnBKdFqH+zdDC55FLmxcJJANqI9YCx7pP1qHkYZGc1Je9nusm+GcGOviIHqQ5EYWixbHaoj2wSMOND3KK2p4=
X-Received: by 2002:a5d:64c8:0:b0:40f:5eb7:f23e with SMTP id
 ffacd0b85a97d-425577ecbedmr3263574f8f.1.1759357535110; Wed, 01 Oct 2025
 15:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <20251001045456.313750-1-inwardvessel@gmail.com>
In-Reply-To: <20251001045456.313750-1-inwardvessel@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 1 Oct 2025 15:25:22 -0700
X-Gm-Features: AS18NWDFsjjNNsPBytmySk7rKJfVZ4JmUJORMaJDq5DI1Bp20yXRuNwLH5i4BL4
Message-ID: <CAADnVQKQpEsgoR5xw0_32deMqT4Pc7ZOo8jwJWkarcOrZijPzw@mail.gmail.com>
Subject: Re: [PATCH] memcg: introduce kfuncs for fetching memcg stats
To: JP Kobryn <inwardvessel@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Kernel Team <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1531EC0002
X-Stat-Signature: x6h47ziupihhjyjneptkynmzty66gy7s
X-HE-Tag: 1759357536-95368
X-HE-Meta: U2FsdGVkX199+v3g8ahlO1h1uB0jreUvI9vYsirC8a6ZOqtP/qj2xJxI2d5YSfwtNFmzl2fmtxG4U2Q9Twe6gXz1uotDx+VcTqolj+9BWm8b7/dRG8mVT/3X5USsNrXTqhr+GFzQRHJRshMvSjsg5TVzPH9RD40CRe8LDertHdGgjQJ5NrrstByhyjFV5Pq3Lv5m6S2+Y7u/E/vQoPUoUcSYMRFb/u2wlJXMty2lW7OxemHkG5sXVePW68fBMg3ZZE6tGzaY4TPJhqc9rt0wAVs6w+TjEhq8spNqvETV5eNKtRCrp7WolT0HTNRe5avcV5+cxa0O9jkyTuTrjz6Ekeh1+1ufQmhRWibb59hVM2ZAaDntnh9ZSVtwU+O8VYYNyouJuhU3ERMxHhnPNepGv2fmXIr/hTc4stkGekXg8w7lnDL2iUBuneiGEcSG204JTQjKrrsWTJCGW686kxISYYRjVBfdpPaXHgCJTglFa9gAdxsZa0IusYiGDm6S+S20ap2NSj+VbWL/egqYvQwsr3tws6IaFQuv4B8znFdYZogudsHdsF2iDeqJ5WfhUMwFriynIqrfNFYL/R8gRd/UzD0djfz2hZ9bRIJTTkYEod1XlEVP0ffakpJ5Ecl54lvle8B+xn9lew0meusw7UeId9VvT4bqXXzacxL751v//u3sbFnAOGk/dEqZMTRpF6RE+jabanrtET5immnlwww/h1bMRJTqbLk0OsX5iUi5M3qEUpZQGjJ0q22vbvxkpqp5Uq7WpiyVt5OPP13whlQnYBFuTlpho/MTv0Exv3ooNKLfru4CmwrwQOXkRw5M4piQC4pSddDdcSOusahEqKbzirfVgBxPC4IxTO8AuHD0yEKOj7kGp8K2xSJJyyYAqwREZj+f2YyZ5CIUtTuRfwGzRlwK7iBLkYVzIPyJ53rHaAladovkwygMB61MJXP5kt0x6Fh7mCI1hKLEeTWtQfr
 OkHTQtg/
 5Fps80azx7MC0Cy3sZ9N7Aeo55acOI+T9tdO1qjWTcG/dKpnuwUqb1rMwG0IqelKTC5VA6uk3ykfjpfVlHmkwzuJtpND/dvNrUllgfbTt5aHfwU0F1dkz3zxH9hKi+5e/uxrBVrTS7WWKn3HyPqb40MQQ4okYBauIawItDUV9ubbXLYmnlkma8WgQVFlmc5BAZmQggh5VkI6WxEQkgu8BpQ6iRepFa6A3K0rbNGyWWhkupb/mAqv/nBUtG9dIbeQAwI7ZLn6SK5qfZk6xyo1b1+vKsXQ3TgPKiZRq6EieEhJFg3ufog6LHlpG+jSJT9P9vIQOnN1GqwEyoILy6YcrJg8uPrCVt5q1bloegaDdqK89F6tqBRBjQS5fOQuY3zte1uqSX3v1NTcpKOOzmQ6A/k/11pnTAFu5RW6Jmp/B8EtJf6yy5SBzYEqgQX6qIkg+KyNB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 9:57=E2=80=AFPM JP Kobryn <inwardvessel@gmail.com> =
wrote:
>
> When reading cgroup memory.stat files there is significant work the kerne=
l
> has to perform in string formatting the numeric data to text. Once a user
> mode program gets this text further work has to be done, converting the
> text back to numeric data. This work can be expensive for programs that
> periodically sample this data over a large enough fleet.
>
> As an alternative to reading memory.stat, introduce new kfuncs to allow
> fetching specific memcg stats from within bpf cgroup iterator programs.
> This approach eliminates the conversion work done by both the kernel and
> user mode programs. Previously a program could open memory.stat and
> repeatedly read from the associated file descriptor (while seeking back t=
o
> zero before each subsequent read). That action can now be replaced by
> setting up a link to the bpf program once in advance and then reusing it =
to
> invoke the cgroup iterator program each time a read is desired. An exampl=
e
> program can be found here [0].
>
> There is a significant perf benefit when using this approach. In terms of
> elapsed time, the kfuncs allow a bpf cgroup iterator program to outperfor=
m
> the traditional file reading method, saving almost 80% of the time spent =
in
> kernel.
>
> control: elapsed time
> real    0m14.421s
> user    0m0.183s
> sys     0m14.184s
>
> experiment: elapsed time
> real    0m3.250s
> user    0m0.225s
> sys     0m2.916s

Nice, but github repo somewhere doesn't guarantee that
the work is equivalent.
Please add it as a selftest/bpf instead.
Like was done in commit
https://lore.kernel.org/bpf/20200509175921.2477493-1-yhs@fb.com/
to demonstrate equivalence of 'cat /proc' vs iterator approach.

>
> control: perf data
> 22.24% a.out [kernel.kallsyms] [k] vsnprintf
> 17.35% a.out [kernel.kallsyms] [k] format_decode
> 12.60% a.out [kernel.kallsyms] [k] string
> 12.12% a.out [kernel.kallsyms] [k] number
>  8.06% a.out [kernel.kallsyms] [k] strlen
>  5.21% a.out [kernel.kallsyms] [k] memcpy_orig
>  4.26% a.out [kernel.kallsyms] [k] seq_buf_printf
>  4.19% a.out [kernel.kallsyms] [k] memory_stat_format
>  2.53% a.out [kernel.kallsyms] [k] widen_string
>  1.62% a.out [kernel.kallsyms] [k] put_dec_trunc8
>  0.99% a.out [kernel.kallsyms] [k] put_dec_full8
>  0.72% a.out [kernel.kallsyms] [k] put_dec
>  0.70% a.out [kernel.kallsyms] [k] memcpy
>  0.60% a.out [kernel.kallsyms] [k] mutex_lock
>  0.59% a.out [kernel.kallsyms] [k] entry_SYSCALL_64
>
> experiment: perf data
> 8.17% memcgstat bpf_prog_c6d320d8e5cfb560_query [k] bpf_prog_c6d320d8e5cf=
b560_query
> 8.03% memcgstat [kernel.kallsyms] [k] memcg_node_stat_fetch
> 5.21% memcgstat [kernel.kallsyms] [k] __memcg_slab_post_alloc_hook
> 3.87% memcgstat [kernel.kallsyms] [k] _raw_spin_lock
> 3.01% memcgstat [kernel.kallsyms] [k] entry_SYSRETQ_unsafe_stack
> 2.49% memcgstat [kernel.kallsyms] [k] memcg_vm_event_fetch
> 2.47% memcgstat [kernel.kallsyms] [k] __memcg_slab_free_hook
> 2.34% memcgstat [kernel.kallsyms] [k] kmem_cache_free
> 2.32% memcgstat [kernel.kallsyms] [k] entry_SYSCALL_64
> 1.92% memcgstat [kernel.kallsyms] [k] mutex_lock
>
> The overhead of string formatting and text conversion on the control side
> is eliminated on the experimental side since the values are read directly
> through shared memory with the bpf program. The kfunc/bpf approach also
> provides flexibility in how this numeric data could be delivered to a use=
r
> mode program. It is possible to use a struct for example, with select
> memory stat fields instead of an array. This opens up opportunities for
> custom serialization as well since it is totally up to the bpf programmer
> on how to lay out the data.
>
> The patch also includes a kfunc for flushing stats. This is not required
> for fetching stats, since the kernel periodically flushes memcg stats eve=
ry
> 2s. It is up to the programmer if they want the very latest stats or not.
>
> [0] https://gist.github.com/inwardvessel/416d629d6930e22954edb094b4e23347
>     https://gist.github.com/inwardvessel/28e0a9c8bf51ba07fa8516bceeb25669
>     https://gist.github.com/inwardvessel/b05e1b9ea0f766f4ad78dad178c49703
>
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> ---
>  mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8dd7fbed5a94..aa8cbf883d71 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -870,6 +870,73 @@ unsigned long memcg_events_local(struct mem_cgroup *=
memcg, int event)
>  }
>  #endif
>
> +static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
> +{
> +       return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) :=
 NULL;
> +}
> +
> +__bpf_kfunc static void memcg_flush_stats(struct cgroup *cgrp)
> +{
> +       struct mem_cgroup *memcg =3D memcg_from_cgroup(cgrp);
> +
> +       if (!memcg)
> +               return;
> +
> +       mem_cgroup_flush_stats(memcg);
> +}

css_rstat_flush() is sleepable, so this kfunc must be sleepable too.
Not sure about the rest.

> +
> +__bpf_kfunc static unsigned long memcg_node_stat_fetch(struct cgroup *cg=
rp,
> +               enum node_stat_item item)
> +{
> +       struct mem_cgroup *memcg =3D memcg_from_cgroup(cgrp);
> +
> +       if (!memcg)
> +               return 0;
> +
> +       return memcg_page_state_output(memcg, item);
> +}
> +
> +__bpf_kfunc static unsigned long memcg_stat_fetch(struct cgroup *cgrp,
> +               enum memcg_stat_item item)
> +{
> +       struct mem_cgroup *memcg =3D memcg_from_cgroup(cgrp);
> +
> +       if (!memcg)
> +               return 0;
> +
> +       return memcg_page_state_output(memcg, item);
> +}
> +
> +__bpf_kfunc static unsigned long memcg_vm_event_fetch(struct cgroup *cgr=
p,
> +               enum vm_event_item item)
> +{
> +       struct mem_cgroup *memcg =3D memcg_from_cgroup(cgrp);
> +
> +       if (!memcg)
> +               return 0;
> +
> +       return memcg_events(memcg, item);
> +}
> +
> +BTF_KFUNCS_START(bpf_memcontrol_kfunc_ids)
> +BTF_ID_FLAGS(func, memcg_flush_stats)
> +BTF_ID_FLAGS(func, memcg_node_stat_fetch)
> +BTF_ID_FLAGS(func, memcg_stat_fetch)
> +BTF_ID_FLAGS(func, memcg_vm_event_fetch)
> +BTF_KFUNCS_END(bpf_memcontrol_kfunc_ids)

At least one of them must be sleepable and the rest probably too?
All of them must be KF_TRUSTED_ARGS too.

> +
> +static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set =3D {
> +       .owner          =3D THIS_MODULE,
> +       .set            =3D &bpf_memcontrol_kfunc_ids,
> +};
> +
> +static int __init bpf_memcontrol_kfunc_init(void)
> +{
> +       return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
> +                                        &bpf_memcontrol_kfunc_set);
> +}

Why tracing only?

