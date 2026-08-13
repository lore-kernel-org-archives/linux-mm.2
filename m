Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4DAC5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90CD6B0194; Wed, 12 Aug 2026 23:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67DE6B0195; Wed, 12 Aug 2026 23:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EB06B0196; Wed, 12 Aug 2026 23:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98B686B0194
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:26:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19B6740579
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:26:32 +0000 (UTC)
X-FDA: 85094808624.29.86FC7C0
Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	by imf31.hostedemail.com (Postfix) with ESMTP id 41AFD20002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:26:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WmvkmJaw;
	spf=pass (imf31.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.64 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786591590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glE18fTWGFGOtieGZ/t9cUibr9Ip5396IdYy4itNJLM=;
	b=gLSGe9bcz1MIF/dPPtfq/f47MqmGW77XBKV1BtN/MgDeNPJN1D31dmZEORhjvG2L3Vg7x+
	xLEoTo2IOLDyAsCpp0FFHPBscp/dR+XTLtosBLEY+IiJaATI/+jbudEnLswMDGhyGa32fu
	luectDGWbVeHbuGNhD5XYIUqW4Rr5Mk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WmvkmJaw;
	spf=pass (imf31.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.64 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786591590;
	b=mPOAC1wcKAy6eEr7bA70UTRncqCtt52QE+MxjAWjMdskmKqVf/L1AjubeaUqF51TreWmJX
	woUnnVqhzj840CXnJfahOwW6UEQiOs4f9t9V/zAKHoyjGwYX5vkFKjiA/Wv1vN56WPWzqK
	h9I8sqMWrGnMRf44a3adJ76qVgOcNQ4=
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-481512c85ffso662227f8f.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786591589; x=1787196389; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=glE18fTWGFGOtieGZ/t9cUibr9Ip5396IdYy4itNJLM=;
        b=WmvkmJaw8YoJ6ZObXXg6Q4sgKvXiyF3cdm2mgzx9yi3woFosQytSpyHcT8xTg9Fm4g
         gPCqjWSj89QuB/svxqAma9xxWfQofPiWO4P8sNNx5KC9SfdDG5eUdnEyTvKCu4JS/pqh
         2CPStAHIELCNdvp6yREeQF69ikVmC+OwcHVsdLoa9jP0d39laN57zQwlCxAwmftAG3PJ
         WFP6fWwzjxg32dRW47ksup50JKjLSOO+g9WA10WoYd5qiBPV/ackzwDWvkbilGZ/Frxt
         QPzuga4xsnNPEVT+3lzsZ1zZUqgJa0CibVHYglJNBBnO/AIbLYYg/HLHiW/Vq6a1UeJp
         nVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786591589; x=1787196389;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=glE18fTWGFGOtieGZ/t9cUibr9Ip5396IdYy4itNJLM=;
        b=Jkg9oehTjdHVy9AbipWSmzqx7uSb8dq9PZxukXJf2t9KsNMPTTr4sJGKih5WR4O7Sy
         4C7kARSykswxVHLP/6J8K9Q2IidP9pWVRwVDM4r5IddQbyy0gS8BmzweRIOlf73LDG8J
         38WyFKmIqH9tIccE2qZwztYSnG9n5irfsn8fEwu5HaSe99heO8k/S4nz9qjm7Ny2MfQt
         +CLrVArrsHKFY/s0zmw8MxViPhGKIwDQfU9J5sn3uLvM9kemgtTaevXXn2aAZHN2TPey
         7p6pNA0Q8FdhCMeW+svBXJzqmTCeZJ03id6FKiiopvGfYCbG+jwP8KQN3Xwr+J4JMDwX
         5Myg==
X-Forwarded-Encrypted: i=1; AHgh+RovEWahUI9B3eKkSGl3/sv43AgRw+CshqDV67vS1XctA0/TAahqDrFHagDkAw0OCv7JI0uggKLLIQ==@kvack.org
X-Gm-Message-State: AOJu0YzYP8Mj2GSE3xdrJQZenVUE/UGAUjOTk3ho823F0SEXcAkUSIkR
	hMX2f16ZFShrxpOfTuesAYf04TY35el798glZcVZfe5VKg1td4lLWCEK
X-Gm-Gg: AR+sD11ar39irOt2EWJXcjNhIRHlPkobANE0p7MwS5UMc85KIHAmX5Ag6LaOyZoHjIq
	8kJFwayCXQGmoPHrHu6+CeECBGzfY1DjWUGo+BE2Td2mT/6V6HZaDIePpmnuXKGDcfa1tP/C0kX
	GSLcvN1Raluz+EFUPZck2w6Y8g5BKqqTevyXGt9Hi22LOVC5e5txtKYYqg1WpWU0wHhq8t3Hipa
	tYZZxvzXjteGc39CoMoouDq48YbUzC8u2DvXwudXQZlzn1wU042u0gTHk2rAHaJUAFSpnQFmOOZ
	Y4/zXE74PU6v0kvEnkedSdjhnfwFxPkIKFMEv4s2BuMGvk7C3POTYrxI4AYd1jXaCdaIj6UwTno
	gSB4D7fkpm+sU/823+1LgoJs5hVwhjQ0M776IDiuhoKJkDJe1YJItul3h48F0mYcD/o+uuyscNe
	vHmEwZA21LnifX1CU98pa0f5Sa8aSM9oPJGmtNSB4pq5H8rxxGYC22rIi/ObDfqYpBfJtn9zf5K
	wvDljV6DQtpHwFdcw1X7PSCupEeiCJX792qJVpnlWvimOP4JzotNBgduqw3YTP0tspTvPFXkQ6c
	/ObJDz+4OaU/vzCD9y1k1NG1u8C4YEGMkaS/8A==
X-Received: by 2002:adf:e008:0:10b0:481:5167:d526 with SMTP id ffacd0b85a97d-48159c8d9f8mr2408652f8f.6.1786591588609;
        Wed, 12 Aug 2026 20:26:28 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a569ab3sm2609540f8f.11.2026.08.12.20.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 20:26:28 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 05:26:26 +0200
Message-Id: <DKNHV09PBQZP.IRQL20BY574I@gmail.com>
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next 2/4] bpf: add bpf_thread_wq kthread-backed
 workqueue with cgroup placement
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Hui Zhu" <hui.zhu@linux.dev>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "John Fastabend"
 <john.fastabend@gmail.com>, "Andrii Nakryiko" <andrii@kernel.org>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>,
 "Song Liu" <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>,
 "Jiri Olsa" <jolsa@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "JP Kobryn"
 <inwardvessel@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Shuah Khan" <shuah@kernel.org>, <davem@davemloft.net>, "Jakub Kicinski"
 <kuba@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, "KP Singh" <kpsingh@kernel.org>, "Tao Chen"
 <chen.dylane@linux.dev>, "Mykyta Yatsenko" <yatsenko@meta.com>, "Leon
 Hwang" <leon.hwang@linux.dev>, "Anton Protopopov"
 <a.s.protopopov@gmail.com>, "Amery Hung" <ameryhung@gmail.com>, "Tobias
 Klauser" <tklauser@distanz.ch>, "Eyal Birger" <eyal.birger@gmail.com>,
 "Rong Tao" <rongtao@cestc.cn>, "Hao Luo" <haoluo@google.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Nathan Chancellor" <nathan@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Tejun Heo" <tj@kernel.org>, "Jeff Xu" <jeffxu@chromium.org>,
 <mkoutny@suse.com>, "Jan Hendrik Farr" <kernel@jfarr.cc>, "Christian
 Brauner" <brauner@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Brian Gerst" <brgerst@gmail.com>, "Masahiro Yamada"
 <masahiroy@kernel.org>, "Willem de Bruijn" <willemb@google.com>, "Jason
 Xing" <kerneljasonxing@gmail.com>, "Paul Chaignon"
 <paul.chaignon@gmail.com>, "Lance Yang" <lance.yang@linux.dev>, "Jiayuan
 Chen" <jiayuan.chen@linux.dev>, "Emil Tsalapatis" <emil@etsalapatis.com>,
 "Ihor Solodrai" <ihor.solodrai@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, <netdev@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <cover.1786086076.git.zhuhui@kylinos.cn>
 <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
In-Reply-To: <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
X-Stat-Signature: egwbqtg9ffp8t5jb5um3n5y4i3scr36i
X-Rspamd-Queue-Id: 41AFD20002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786591590-187721
X-HE-Meta: U2FsdGVkX1/eZvdHSUKUAWO0VYkQnyRJ0BIxJ0lROWcNrrKwpMU5H3lI8acBuNbJZ54Bc1tY6VD2aqFVNC6IgiLOkwhtPAFiNIl8MwbHPSergqZgjsKNTmoRKH17lNGYYBmFATsnqhYuzflfKw1hv1nSEo3KV1+BucMb5yMZAv8uPriAI5Z/y4IogITrzuGNG7fmQv1Rxh7187jtjzFlevny9phkOPRit6nsyclRnMeneMeZ23Zx7NGblpVQnsdhJvifNhlDveXbkWab7rtdekpK2sMF+ISrbdjJXtu40QVfTp1YTGVIcPu+KJJeWs9BBiRbNhT9wKUBdgDdZhn4GO9RNxNVctlZkttZs4H3XG/FvTiFhBleEIV6jHEJJ2i3u0XAj1rGUE30pHTFxR4ebqLom/jHNXVXZ0BEh4Ua2YZOFGKnDH5JxGaPCvIzR6H+7JdT2bRLSTG1ushrGS4c05IPrGddR8RWIXnXQbYeLc7abwEbkMcWGmarml0eYKKcdqalCDSgSCDA9tbuBUgGw6DsaxfxYro5qP6RBCdjQ9FEQ91Sn7WG6O7u1N7EqFq0yWXfdTOrMF2MaagUJrh3fd8qgnjtpH/6Zut/RLmWfy9OhsvVW0Ux3tho19tedkYKThP+J7eTsx1zrwN/X5ONf8c7t/5ihXsvLryfcnc7sX5DrOINWDoeQV9okQa20PU8PHWEjLCVun4GW26aF3sOfO6ZJHI8Ai0lBVeAbdcc7lkIJ8xq00vemb6ZuvlUrDp+AuIt/N5jlzKXz1yxfn157vR4bX5sO3qwCgqUVJ8SEyDRc08bjdKuGXiK3P/eYl5PDRPbJmisvatUQ7p0CRzEm2Nvs0UQpaQ38PCRm/UtwuITetcCYcLsUj1F/BywVC9Jf0LWSZt/gLzvLXqg8PSE1S8oRKywcK2tYcdsQBwPeYwryrW0M1Ts6U3W7zecGFogyArGo6wi4e8WrBKodIF
 XswbrhSp
 DASL06JVcWdK57wkalLWEQa9n3gFC/ehEIk9EAC/g8RBd3DEQXO9ZcOw0SeYUbnsL+qAdYuBN6Fm+qdvC0rn/Wk+EqTb2QLGDCmBS0MsOmcxcuglYFV6PeORzyXptGIBroCqf57QJiIJOcxvMqttTYwZAzgwpudvyBdZ42IxdulVvM7t7DnCJXxQoBzSpZpWBDYm/bbbsH4B2Lt3UtcbmK+3NZmgNngFtlowKrSMKj6nCQ7/3nlmsqZzQUGnGkEiQf68j9W55Sn3bYimKlxGkooCbPAU2VO/WpJuVxSe1lkklI4zG8iY8Bc1DqW1AxiKyYQhBeUYrIngJ01p/MI1+kx5Cch5iBJ5POJlmXsR/MCS/EWLt6SQkFF/lxCBMkVpaovo8u+/xHpf3JKWa0p5DywSVcLYREHIm22e57dCCuBAO3BkqYjWXzWXum64B8tRtw8i/pa8UoqOWkUINFq/OisxSB6UAjWf6uVQGLGo/+HkM8+E6zR9Wlta9JLBWVpS7Hcy0Uhkzy36EOWI4KvJiV7+htKu5S7+8kD0zZrEoZuiGBVf3RGhqREyVh73XiWlo1c9Mzr3ynw13iMDuoFNTdoafZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 9:01 AM CEST, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Introduce bpf_thread_wq, a new BPF embedded map field similar to
> bpf_wq but backed by a dedicated kthread_worker instead of a system
> workqueue. The worker kthread can be attached to a specific cgroup at
> init time so BPF-deferred callbacks run under the resource limits of
> the target cgroup.
>
> Three kfuncs are exposed:
>   bpf_thread_wq_init(twq, map, cgroup_id, flags)   [KF_SLEEPABLE]
>   bpf_thread_wq_set_callback(twq, cb, flags, aux)
>   bpf_thread_wq_start(twq, flags)
>
> bpf_thread_wq_init() is registered only for BPF_PROG_TYPE_SYSCALL
> programs. It creates a kthread worker and may attach it to a cgroup;
> those paths can sleep and acquire kthread and cgroup locks. Restricting
> init to syscall programs prevents it from running in BPF contexts that
> may already hold locks which could deadlock with those paths.
>
> bpf_thread_wq intentionally avoids the bpf_async infrastructure used by
> bpf_timer and bpf_wq. That infrastructure drives cleanup from irq_work
> in hardirq context, while bpf_thread_wq cancellation and final teardown
> may need to sleep through kthread_cancel_work_sync(),
> kthread_destroy_worker() and a final cgroup_put().
> bpf_thread_wq_cancel_and_free() therefore cancels work synchronously and
> drops the context reference; the last put waits for tasks-trace RCU
> readers and then schedules process-context work to run bpf_prog_put(),
> cgroup_put(), kthread_destroy_worker() and kfree().
>
> Add BTF/map support for bpf_thread_wq fields, map teardown hooks,
> verifier handling for the callback kfunc, and cgroup_kthread_attach() to
> move the worker into the requested cgroup.
>
> Supported map types are BPF_MAP_TYPE_HASH, BPF_MAP_TYPE_LRU_HASH, and
> BPF_MAP_TYPE_ARRAY, consistent with bpf_wq and bpf_task_work.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

Hi Hui,

Thanks for sharing the patches. I think Sashiko and Mykyta already pointed =
out a
couple of issues with the current implementation, but I would like to comme=
nt on
the higher-level approach.

If I understood the past discussions and current set correctly, the reason =
for
your choice to move from bpf_wq to bpf_thread_wq was primarily to enable co=
rrect
CPU accounting of the work done by threads to specific cgroups.

I think this is a step in the right direction, but looking at the bigger
picture, I feel we need a more flexible solution.

In practice, users deciding to do async reclaim through such a BPF interfac=
e
would want to scale and compact the number of threads doing reclaim-related=
 work
dynamically, based on available idle resources, but also application-specif=
ic
metrics, and I do not think the bpf_thread_wq abstraction provides enough
flexibility in managing work scheduling related aspects precisely.

What we probably should expose is the ability for programs to manage their =
own
wait queues and subscribe kthreads managed by BPF programs dynamically to t=
hem.
User-defined policies can dictate how many threads remain active, whether t=
hey
busy poll, and when they go to sleep, completely under the program's contro=
l.

Looking beyond this particular example, there are cases where work is stash=
ed in
queues, and threads draw items from the pool and process them. In such case=
s
having flexibility in deciding the mapping between threads and queues is al=
so
important. We want to thus allow management of the work item queues from th=
e
program itself, and not hide it behind the API to offer the desired level o=
f
control.  The order in which items are ranked in individual queues, and the
order in which queues are processed horizontally by threads is also a desir=
able
property.

Correctly associating the BPF-managed kthread to a cgroup should still be
possible in a manner similar to what you did in this set. But the amount of
control programs can exert over how work is scheduled and the level of
concurrency will be much higher if we disaggregate and generalize each part=
 of
the picture (wait queues, kthreads, and work item queues, which can be
implemented in BPF itself).

I am not aware of ways to back charge time spent to remote cgroups, but if
desired we could also explore that option when a single thread does work on
behalf of multiple cgroups. It is something to be explored.

I've been working on related patches, and will post RFC set for bpf_kthread=
 and
bpf_waitq management in due time.  Until then I recommend that you continue
experimenting with the existing async execution primitives for now.

> [...]

