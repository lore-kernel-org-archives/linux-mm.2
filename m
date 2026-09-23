Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6708DC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561806B008C; Wed, 23 Sep 2026 09:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539846B0092; Wed, 23 Sep 2026 09:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44FA46B0093; Wed, 23 Sep 2026 09:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8966B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:08:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FD30A0836
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:08:19 +0000 (UTC)
X-FDA: 85245055518.25.DD73383
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F9BD140012
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:08:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YkJXWKu+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790168897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHUbabRXBqdvbV25eXrArHoQuD9SOTIdcQ2oJXMH2as=;
	b=g81gIMV6EaCOhMf19FVub6SYnwJ/Ipqqqw+NYyuJ1+aB+2G6gWT2HVLqtIM8fag6c6uTyX
	ZoCSxpGqGr06TMh1ASHLiaICuYnmdUvduaYSkDVtp3EkPbPQLRhR7FHIpr+CMAKGgVg6Lf
	xbZkUVZ5/1sWgx5p/FeZ4fmjP+k8f+4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YkJXWKu+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790168897;
	b=P1+8KGYOE03ixFL/8KuUSrYsUvlMPhd6/0LBsZKxKRDxeij09qvhX69cJtpMB8ROMi/Y80
	yLpWlNFBSIZGMpshXW+EbZZKVrR/pgpNlmzfe8UwGBrbJ4FnS+zH9p2Gy5Lec9A1j7QUGQ
	4RV4gYt3LEO0pQJIIl5GuhhAu/qWFjs=
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43f9b120so11952797b3.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:08:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790168897; cv=none;
        d=google.com; s=arc-20260327;
        b=jkkbatgbjFDxSxeWWW8aNnb2ne9ZXEnGYg4HUBp9hAim2eMUdftnJdwxErBVu3Zwyi
         mqTBcZp8KxBwU4m9b/jMg/EJ+PR2rOq/FEuJ5D2SKjr0hC00oVej08aLp+AV3ZnaUhJX
         DKCBAGqEQvei8AnnUmnEmaYzcSBOD63APTcF4D5sX17RSaTU8iAcTKQfyhVHXsdDc/Jp
         N7k5HmRMmCnu+JQ6M7cUye/RmK4T5sGWTscjUb8jIm4zkIsLWYo7vtawR2Oz52xg+2Z5
         V5MiL7IaffC54xhZkyWn5x02m1yDskoynI92/XPjKKEed/hD9kQBVdwe0uktfDLkH3Sq
         c9DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IHUbabRXBqdvbV25eXrArHoQuD9SOTIdcQ2oJXMH2as=;
        fh=qvEEfoGGZ/CqL0yagPbXw35P/5/KB2oZewpiQzbAMdI=;
        b=ji0xNXAxb0OU4bgT8UlkY0YccT1xVJPRSaNWuL7KH/MPRGVNMzAvvq+z8zAi83nKMs
         bwNc4Z31ngbwKAsbebQrXUuIlzW3LhzNrdZ4Et9eHxNWFvTI70Xlr5NRYTeoX/kLhiiO
         06Mbx74FKsjaGMBgjCaL9IiuqMcU5DtCVKJU2BFeX63hdNy3+y7YwVk3GUCdXeSPogWv
         9DfykCX+0KWYwwsQygZdPjIe5FjTg7Y/Y5PuCwPqlHHd68ncwC2OVjRzRQ+vMsqVow9w
         UV8O5cmd5AYvtSGqBCqBK3me6FWhXXwyJKEMgvrRkpm5lsNOteed4+5DBSYSBLKhIuQA
         WzMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790168897; x=1790773697; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IHUbabRXBqdvbV25eXrArHoQuD9SOTIdcQ2oJXMH2as=;
        b=YkJXWKu+nnOTO3aosKmuj/QoKYC/PTAeLodvSg5rlGUjEzq4goNI7OeLzts7FPtIMW
         ajH95e6YSQkTuNQY+CMArb0xIzSajoE+m+TlOVizzuQqTTWaU/Z1UY4+hEKb88z3Vsgt
         L/ojXRjGr9ZR24wNa3+EldU1E/ggVSvM3HUtcV2txoxK7ttSqaAxXzmW0Y7XY2mxzUpo
         zbd8oemFh+/Phj3xlij6WQPXPyg7RlV1Snr5BI4WJfu6C1YSnXkzcwpkqugWaZNvhbZZ
         DQeFFiq2xziQQD3qBBZ3kkTFLMDA2Sn7tcItvsN3tJQ3XLfJciAKXt3oiAWUNRvzepkA
         nIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790168897; x=1790773697;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IHUbabRXBqdvbV25eXrArHoQuD9SOTIdcQ2oJXMH2as=;
        b=u3LCN4I7ncFGp5w2Bb1HTQL61upQxEH7Zn8OzD5VBXbeZ0IIP9Lta/5VTW3jAza7+n
         AAXUmY7MgJv53Viy/1uhL9eB4AQ9fUhjFqTeZO8yW7twGtPzh+zuFPR5KAUtytSOin4P
         iATA9dj7X3C4BF9lKIllYwX5ud+4kMnADnNxRDj6RBV8d4A0jGNG/OgYI7zNh7I0T80a
         mUp9vjYNcUrBXks2D0v7aNtd5MiPTSQ65YDOtNbzP2sXRTwVzCAAvViW1HqKhQBI0kfZ
         DC2brDSACifJ7GcHlMfQ+uX+BvlSPUQ8KwUyWl3p3rQnUvSoy7cuAMkGiz0ueHu5e2aN
         9LkA==
X-Forwarded-Encrypted: i=1; AKwUvBzxJKx7qEaBYest+mfEw5eg7PQIicNQngfuMPWT3fdneS8BRS++D3n21RNWpQX6oOa3LBhz7LWYDg==@kvack.org
X-Gm-Message-State: AFuF++lXwVWz9ze/GSSV0YixKT0nNw0Krm19HVgpxKG5toH3Tkr9uMLX
	ATDCIh3ZeyAUS8NRIt37MvB0XWBu81sNXYLK0XA6YAmJOjJv28Rlf1DHcOdwNcA6ArBZm6HNInw
	cMwuAodDZKFReYFqtvhiuD0MrSDqnA6Q=
X-Gm-Gg: AYBFou1dt/Q/NWbPGTM06TorjuOt5qs7YFO/xWWf3XT9qjcGqPlQSeJIf4pY1I2XObQ
	1drUraIbZo8EQoooykFH2b2s45heDuHaYl8I1V3QrAwwU8azZTaeafSfvoJ3U7TrtlzRsjqC24x
	otPTMzr2epCo5kr7IIoB6Gy4Z/ZvcMt82i5LGTg6AWzSonC4sq5Y7pUjGYT8xvKH3e+qOGxSEp3
	i9/D6SLkrrBYjKZCAmXWA3IcCZGl4GyduYTW+VR2IjmGHCalBOaKmd2MDUdPH9HYkoPc8UgybE0
	lb1sWrq6nw9YJVsZKmltDiXLkWhbInborIbvrhnv0Tq7NxzedYzLAfpW0phyVasPxfvKIk8MzEb
	0jjIr3HUa1/jjdZKbJskjrE+dPOteYGifxQ==
X-Received: by 2002:a05:690c:7483:b0:8a5:1570:a2b2 with SMTP id
 00721157ae682-8a51570a635mr6866957b3.89.1790168896597; Wed, 23 Sep 2026
 06:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 23 Sep 2026 21:07:40 +0800
X-Gm-Features: AclHuK_8Jda0panK7HLuZ7wwf7U44o1nunsdozOcDRu1nw23Gwnh2GufMO41nA0
Message-ID: <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached struct_ops
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4n96pedpni7oow698uu8xqrkh3gbob9o
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F9BD140012
X-HE-Tag: 1790168897-150800
X-HE-Meta: U2FsdGVkX1/T0qmUzyj3oWlOIOL33Y0oYzjgGNXTB1+6Xv0JetgBkO+34vgrTL6tV0A6ylGqbUzkIAVcFLBKy9fj7lbV1klbSTfr15MSbKQy452x3TJNalts/ZsWVEhYXmBzbqLyid9S3z/63dycfen8ty79NOc+wTHC0sba71LclD4Md2UdJMCTDLkre8RhrQy9DnOO9YJL6ikAzSh/HBBn47IUrhopGUyZTMNxqIYcHPR7nS98HTWIxr9uvdIpq57Kr1lYCIuATi31P96QwCBSLJoKObnm37fXEbSM9GvdMNP2NiiwzRiwoUtNdzhixYmboiJaq3jT4aV2MJajUTY2Xlmz70ih0IwtRFxPf5ZpI5hPIYym5++H36sM5LIPOKfKQ1tbrvBi/TZq6Uo2f6o6mS3h6QuHmjwkgGGjo9gIb5EODzfZ2mQkUijVZRCI8aDA8J+BjsFNOPTmqSB8s9QTlCC0N1xd1ezaizHgJkxW1ImZcanFgOcBgx9DbnuQk8OTDMJGROFShNigQ7iKPmGn/Itocz4qvrwjtCsOqrXfxEll1PMYcGqvvWSMeHLS/DYDUa9YV6oeRiiQj5GGco0rmwmru6Bji8paqyXGpP9asGseaL4lcMsZChet+rFVvfav64voav3VSuDlTNGI6NXFMbQY6T8JwXL3ANS4c66b306LM2V46Wg9ZiJzMYy0zonWxKkTG22Tzpq/S0U28WsmfZ+WiZxi5U85nm1p8zy6jtTWvX42NtjNUBwREO3E8lqk91utatiaatdGL8ASWO17nFnRqLf2T+TArgzY2Mv/iTBl96r4SkFcJ9p0w5hxiN0rRvsfhyRldfLsD0UUr0ozTtI85dvR97q+ts7mWy1doQUnjUsb6HBns86seGEGzRzwKAZb+lDLv0bpkeYhIXecw/3NMhVrPmQNkvxrKz0CZxdja09FhDRNyZaS06COAmiM35YflvQ9G9Nle8Z
 np2woV8H
 vP7WWkq7iF7yNlLQbDsBo4OzspkmIUQtjJa23GjlCgIKSnH5enbBRnFZkfbNxgIb51HSYwduliNf8S+ayB2ciD000SNQvxlPucMjS53uckY8iJNIVyfoO8gCra4gTETfKsNh2Ca421InBB+tSNo+MwHtjmVmNs9S7D5X3u6xU2cLdZG8kkhHXyzjbL53yHIs5GJxGqOiQRiTvVNPggWMJ3OD/Fp8G9j2fnxxvR6w2Qfr8XQZHpUEBmgx57EATe0y0nMsEBlU5bDv48/AVw1j5OolK/v+asLXkGO/YQg02KH/OlzgeVNuIVajfYRsp45yjrzJY7J+AJJN1ycq6SjRg8kByLS2d4u0t5CU+Qb7nq/EHTc5hwFA2zxTVvGHHjvAZaD7k3L/MADrdAh8sdQ4+/2NcjDDr9oNsO0LHaCmxSaNl2lnKJU54dv3FqJQUGEPwlMTEkx8Rh6zp3nF3jeqwGHEgbLoaDnJdYt0ipeqrA2yEKCF/lLepdkiOd4KaMbHktshk8BVVrRj5ha0ftlttXN1OpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 3:30=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> This is the first series of memcg_ext, proposed at [1].  It adds
> bpf_memcg_ops, a struct_ops type through which memory controller policy i=
s
> attached to a cgroup.  A charge runs the policies of its cgroup and of
> every ancestor, and the kernel combines what they return.  BPF picks
> between things the kernel already does; it never does the work itself and
> never touches a page counter.
>
> The plan is to grow this one member at a time, and to add a member only
> when there is a concrete problem it solves and a measurement showing it
> does.  Nothing is added because it might be useful later.  So this first
> series adds one member, for one problem.
>
> The problem
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> try_charge_memcg() calls __mem_cgroup_handle_over_high() before it return=
s,
> which reclaims and can throttle the task.  That happens wherever the char=
ge
> happens, so a task holding a kernel lock can be stuck there, and everythi=
ng
> waiting on that lock is stuck behind it.
>
> One concrete scenario which can be resolved by this new feature is the
> kernfs notify worker. It delivers notifications with the cgroup2
> kernfs_rwsem held for read, and the charge for the delivery allocation go=
es
> to the cgroup that set the watch, usually one already under pressure. So
> the worker reclaims while holding the lock, a waiting writer blocks every
> later reader, and anything touching cgroupfs stalls for seconds. The patc=
h
> proposed in [2] fixes that one path in the kernel only for kernfs_rwsem.
> The same path still takes kernfs_supers_rwsem.
>
> One can make an argument that if we know the source of the issue in the
> kernel, why not fix it similarly to [2] instead of having a generic
> solution? The reason is that it will be an uphill and continuous battle a=
s
> the kernel keeps evolving and new sources of lock holders doing allocatio=
ns
> keep coming up. In addition, there will be cases where it might not be
> possible to move the allocations out of locks, or where doing so would
> make the code really ugly [3].
>
> high_policy() lets a policy say where memory.high should be enforced
> instead.  Its one request, BPF_MEMCG_HIGH_DEFER_INLINE, skips the inline
> call, leaving the debt to be paid at the return to userspace.
>
> Results
> =3D=3D=3D=3D=3D=3D=3D
>
> Measured on a kernel without [2], with a policy that marks cgroupfs kernf=
s
> lock holders.  Reproducer at [4].
>
>                                       baseline    policy    upstream fix
>   max kernfs_rwsem hold, worker        2.049 s     199 us   not taken
>   max kernfs_supers_rwsem hold         2.049 s     4.8 ms   2.056 s
>   max kernfs_rwsem write wait          4.096 s     6.2 ms   8.7 ms
>   walker passes over /sys/fs/cgroup        352       5711   6700
>   churn mkdir+rmdir ops                 13 059    364 832   415 488
>   churn max latency                     30.7 s    15.1 ms   12.7 ms
>
> The policy matches the fix on the bystander numbers, and does better on
> kernfs_supers_rwsem, which the fix does not help: it drops kernfs_rwsem
> from the delivery loop, while the policy stops the worker stalling at all=
,
> so every lock it holds benefits.
>
> The patches
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Patch 1 is a build fix.  __cgroup_bpf_query() only works because
> CGROUP_TCP_SOCK_OPS is the one struct_ops attach type; a second one break=
s
> the build and makes a query for type 0 return the wrong thing.
>
> Patch 2 adds the type and its registration, with no members, so nothing i=
s
> dispatched and behaviour does not change.  It also moves the attach type
> enum out of CONFIG_CGROUP_BPF and fixes the register_bpf_struct_ops() no-=
op
> stub, which never compiled because no caller reached it.
>
> Patch 3 adds high_policy() and wires it into try_charge_memcg().
>
> Patch 4 is the sample.  It tracks the two cgroupfs kernfs locks by hookin=
g
> the rwsem primitives rather than the forty-odd functions that take them.
>
> Known open questions
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The semantics of memory.high for remote chargers or kernel threads is a
> grey area and this series does not aim to resolve that.
>
> Another open question is whether a bound on debt deferral is needed. At
> the moment, we think that rather than putting a limit on deferral for
> memory.high, it will be better to handle that through an async worker lik=
e
> memcg->high_work.  We aim to introduce that later, along with the right C=
PU
> accounting for that async work.

Hello Shakeel,

On the open question of how deferred debt eventually gets paid: would
it make sense for the policy to also notify userspace (e.g. via
ringbuf) when it defers, and have a userspace reclaimer do the reclaim
through memory.reclaim?

I understand one of the concerns for the async worker is CPU
accounting. If the concern is that the kworker's CPU usage is not
charged to the target cgroup, the userspace reclaimer could instead be
spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
cgroup, and both its CPU and memory usage get charged there.

One caveat: intermediate cgroups with the no-internal-process
constraint cannot take processes, so this would only work for leaf
cgroups.

What do you think?

>
> There is no prog_tests harness, so the numbers above come from the
> reproducer and not from the test suite.
>
> The sample's lock tracking costs about 8% throughput, because it
> instruments every rwsem operation on the system.  That is fine for a samp=
le
> that has to cover every path, but it argues for a cheaper way to track
> locks that cause isolation problems between unrelated workloads.
>
> Future work
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Asking the kernel to reclaim on the policy's behalf, so a task that canno=
t
> be throttled still pays. More members, each with a use case: hard-limit
> policy, reclaim shaping, dynamic protection.
>
> This builds on "bpf: A common way to attach struct_ops to a cgroup", whic=
h
> supplies attach, detach, ordering, update, query and the RCU rules.
> bpf_memcg_ops is its second user.
>
> [1] https://lore.kernel.org/20260307182424.2889780-1-shakeel.butt@linux.d=
ev/
> [2] https://lore.kernel.org/20260910045406.485295-1-shakeel.butt@linux.de=
v/
> [3] https://lore.kernel.org/20260917-wehten-achtfach-getarnt-c85a4812337d=
@brauner/
> [4] https://github.com/shakeelb/mempressure-repros/tree/main/kernfs-notif=
y-memcg
>
> Shakeel Butt (4):
>   bpf, cgroup: fix cgroup struct_ops query for a second attach type
>   memcg_ext: add cgroup-attached bpf_memcg_ops
>   memcg_ext: allow BPF to defer memory.high enforcement
>   selftests/bpf: add a cgroupfs lock-holder bpf_memcg_ops sample
>
>  MAINTAINERS                                   |   1 +
>  include/linux/bpf-cgroup-defs.h               |  22 +-
>  include/linux/bpf-cgroup.h                    |  14 +-
>  include/linux/bpf.h                           |   2 +-
>  include/linux/bpf_memcontrol.h                |  66 ++++++
>  include/linux/cgroup.h                        |   7 +
>  include/linux/sched.h                         |   4 +
>  kernel/bpf/cgroup.c                           |   3 +-
>  mm/bpf_memcontrol.c                           | 188 ++++++++++++++-
>  mm/memcontrol.c                               |  31 ++-
>  .../bpf/progs/memcg_ops_lockholder.c          | 222 ++++++++++++++++++
>  11 files changed, 546 insertions(+), 14 deletions(-)
>  create mode 100644 include/linux/bpf_memcontrol.h
>  create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_lockholde=
r.c
>
>
> base-commit: 6e36e099b15bed1e8e5b3e3136c5e3eb56a15aa7
> --
> 2.53.0-Meta
>
>

--=20
Regards
Yafang

