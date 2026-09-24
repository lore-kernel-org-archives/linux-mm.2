Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2188C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939E76B0093; Thu, 24 Sep 2026 06:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA676B0095; Thu, 24 Sep 2026 06:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8009A6B0096; Thu, 24 Sep 2026 06:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5676B6B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:02:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5F08A5DC9
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:02:07 +0000 (UTC)
X-FDA: 85248215094.05.24CECA1
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id D82C58000D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:02:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f93niofD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yf2eXBIzfUAyDI8YQcFwCnYg3j6ep9DZNkN0GsU9MPc=;
	b=KzK6YneKI2rA2KnyRQ2mpb38RPWvHdkeJD1HnYi0DEYZkXGn9Wrwi2QeKlqrTvKuioXqjc
	igfavjl9oUMrnxgNUXPGAY2GCd5FeRvBzNfI8kUSFXHh52/MQZIR0pLfVy2P7riyg7GgWA
	HzTRyg37DBeiulbIiLHHy5D60QqItCk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f93niofD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790244125;
	b=B2p0JXEtMk44eEnyND/K33raAjp8vOS9iry9Qe0vntmiXDnFWK+KUHWF0P+udbPvB+Qkm2
	w7mlX6Tx4h5QvwwZAyfm25XQqXUBes7ErT0r2UwkurAP9JA0EFf6y2z7aKSsUf2IdQ5B1q
	UQoO5b5S8ZFAHORkKEqzyxMRxyvBv7c=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d43f9b119so28944437b3.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:02:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790244125; cv=none;
        d=google.com; s=arc-20260327;
        b=jFWPtKBrIE8Lr0QrkUquEtK0Y1TqI3o0237r8q9uD9f+jR7F5+ZQCwMupZD34OH4TM
         /wCtxcdnNWROfzVZcLdpeCBbpEfRB+3yl5+6IL2uNhzRRQ7jZbYWdywYaaVuVFmL75Ah
         d9mkhoZzsSQ7m/XSCD1pCcqMvnYnu7GpbPyxq7Bj/vYTEgSVf0iZVvA1jODMevQxbaNq
         VVl0xim/AGbrMMuuzJZ/A3i69FfK5AYdrM9OPk9ltA3GEb/rkzGUspbCFUbBWXo4FGgZ
         saktlAnpiDXgoi8bB5z0l5T5DmHFznmzSpNi615Jp1D73/whX9kOo3VNvvXcbJkuG4fD
         MjEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yf2eXBIzfUAyDI8YQcFwCnYg3j6ep9DZNkN0GsU9MPc=;
        fh=6YlBTZkSTjV2piKqXFKK8s9MLiknamMCPdrhcxkyEl4=;
        b=ekyYfV9EQ5gm8wOIqlebrQAT7/rczb6QJDtrfQAma416AC+7IIg9DrI5iQOG1/n3fL
         81ULkBYgGCvt3+tKselXjOTnQzTOVhJczSSCicH1tm606E7/pXLugw1MYjjQLH++ZoeU
         OlWNt+H5R+97tBNZgmut7xvdFuVijxGU0q+iTRtoamugEl33cgDTP5ZgU2R28mYfH+HE
         P3xCUPv8Y+yH7DgqqMChz5t0kWCwy6pt1gGKolpbEFlX+lnwBBeoN7BnQYfgaPejtisT
         9cAwjBHkc+jhXxHh4MQOc2VqmwHyauFOeauB9luDO4Gwu/pdVK2D6qli5ydV2/8++95U
         3ADg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790244125; x=1790848925; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yf2eXBIzfUAyDI8YQcFwCnYg3j6ep9DZNkN0GsU9MPc=;
        b=f93niofDvusDbAFGts/uCTMSu85l0gjBWRUUdRvRMFdpTJu23SnYt2CmGk8CYjK3NW
         u+cLd9uytNGlw9zcYXKKytsOewARpwF5z3tNxzjFMA6b5BoDwu0CRERHjFs72mpkaw/5
         90o8u6LakMbVQhCJm/mO0VheaZeSDXqCss0b+bfNh6rqcmaMFk9mkwvD+vkAoA8jg017
         DwCNWmgB9iqkWHehr1hsbV+qPR15Cmz6oWsx6RnCNLGGhNemABQdV75TiSUS6KUtT1Cs
         OmRt5/rXmscGa/h6B3Oot7at78+DMDY/8ov/YggnIKlbpb7Pp7fAZEwLHE/zGubivyeT
         yAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790244125; x=1790848925;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yf2eXBIzfUAyDI8YQcFwCnYg3j6ep9DZNkN0GsU9MPc=;
        b=Ix6En1JVG6Do0mH6e/rNqh3A3M1opQT3rccvCTWNiwtOrfKY05vi8hU8HEpbcFLFLr
         MSzuQDDXUd2bd1OZ9LUtXQ7RcZ7YFFsDf6b13tqCdQZgH2XAePjaD2Z6E6dqa1IO+91q
         pr5pDgL9/oebGua9WMlQwSjiUsp5SjWtrfeZd+wwfYQZ/WratUUCDg/vdojvsFo594im
         m9HJeC7JjFeetPQiaNPbnGQVUBexOoBkTSUDOFzx2Cbp6WGV8RxNusdzgUmh0kiWX/Gp
         zdoBbcq4LPKe2qajAb582F6MCijhl0bBynhsQZOHWoh1XoeqodWD5tHwRxsn9K3E9+tq
         GTNA==
X-Forwarded-Encrypted: i=1; AKwUvBzYYttmhbwFDsDkNtdE2qMtTUBI/kOhjcJ3UaY8WHR7zoJHlNOgV37yZz1che3W6bK06hKroiydkg==@kvack.org
X-Gm-Message-State: AFuF++nvnG3N0HMLZYwy7QpQiabbt8qNPCmomjD8JYZtANzYtfs0rpTj
	+XAidCzzrMliFoQGY51tOvaXT+CzcTgVSp8XPN5Ros27m1mHcaFzSSvJfaZXfxbm+9/grdFsDxO
	t9QIKT2dr0sOyNHgpkFmZd2spyh65vVw=
X-Gm-Gg: AYBFou3OJtuBvBAUwKvRsOE4kuwP1szKuXUFFwjydJSULyx/cVHreZN+eE1OyZ+oQct
	vwFfwayInOBVslyqe0jS0FmysbYwTPn/M8QXgjVRwdO/P2dHfe8jg2grmyKBPMIT4yvnwIPMXrw
	efRiEEqFIn9z1uEG1k2bUghWDpjzIrUjou0tOlZsy0d9HLb6i4yzlhDFwpXhvqKm+t5x3naXq0R
	YLm3+DcXOdRuG+6Wh37HP8SC1EsPMTVGScfdgeBvsmRu0Leprh5Hd0auqjY8e7yKZHAPgZmemvd
	uLypGPOP2NmojrGRf36aGoykacLBq7b4xb2gv8LoU0xFFu9ynmrMQJ/QcXyk0uC00Q9iFbKv9+V
	oDA7bU1Yb/bNXB6wXR3tjryA=
X-Received: by 2002:a05:690c:e3c3:b0:869:1ab2:33aa with SMTP id
 00721157ae682-8a645aae281mr9464687b3.20.1790244124691; Thu, 24 Sep 2026
 03:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com> <arPyspcEFNkqfNyr@linux.dev>
In-Reply-To: <arPyspcEFNkqfNyr@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 24 Sep 2026 18:01:27 +0800
X-Gm-Features: AclHuK-I9uw-yPD5uF_5nJaKC0fsPFwXnig4t8YGhNpVyr0Q5duPYTUrOw96ia4
Message-ID: <CALOAHbDKRw9cPN_GxOYbp9u50cvr7PzPyoGPsSwoPDPAwBCGbA@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D82C58000D
X-Stat-Signature: bcba4tk8i4xy9ype6ihaedaxbi9tbj49
X-Rspam-User: 
X-HE-Tag: 1790244125-841134
X-HE-Meta: U2FsdGVkX1+7oPqO+2XqCNyZqfOMS04gHgApWO5JVA27VTrsFDh1LmdKQtHKbRQJ9bdHafC60e5vvbd4eeurCHZcR3phLqoEPaXuwvPpwmjJQGB9JQzmYknDBp38hm2e0CaLfhDrek78CC9gZWKQVMZPwtdsp5xTz8RbC/ND7uka/VWm+7Ir2QVjTBR1DWeFABDz8GMy4i3heOtC/WbxTEpmoeDhpyU9VOqrPU7ckkg03XnmAI/6GDDNsZaDZtDHWeir8R14YaWIFjvmC/0PLRJw3Vyya+bcPbSPmAo2CK2dLNKyTi2AiolHQBpRTm5LSti+YA72UxamwZFpuxJQTzhSjWon8tYfnpP5GUVvlpBirprjhJH3ocrLWhlBkQRGBCHJBbPUMiWL0moEIJsxVOWCAm+28frUokPcHMxQZ/6aIMSWM04tcmwBalS4RAa73iLiDahVtlmjVOqaQErgXRsYP3r4FHWZkVFgFQlctHB7ZBBqievK9PKUTTAvhznfluLgHggQI75lJzMp8G2o1M9VZHYA/C8fCdPDmicKtMv+u7L3jgER4yc/d4P5SSA75QjOw9giIWJSVFOJ6h+aCa5Z8xkD6dKEvAjsAq68uI5AUZhs4v+kj1+aRhVMbmS1wrPCCZ11RvGgaITBLpVSwI5/RFIviKRJxbJG+NSzWzAt1qOJpcpcGFxr5faOTVq7VuUfdQbxswjfjXZ4L/bTtCNz2/gFr/AN8HopV8h93leTIyJ2tkwtf0W3/hQ3X5Nys1ddwoKmwhU3ZdgpPg+GNB9ClVcjdBaQzvb5rqWLSN1N57ey8ZNI1xVUs4t4i5weimwAAGmm+56NLpIoUbKaRTIJgh9xq3GNkudP1bFXJd1CVI8yWlV+XbeZdzpde0nhQ/5163gQL+1mo958kzpR/QF2ht/3FjuffOMLktIIfe3SiHf4qaAfpIT5jfUG9nqiK5vOUEjSpsbcABjSn4J
 tbKr82el
 wN0zs01u88fgalBV6BS/P5yBVfzKq/hR6ZzpRg2Fgs6Jprcvaz5i/jGXx0AJuAvFtB0HtkuIKEFoX9dQB3lJgXP2g4QMv6bruFLCTwUVzCxRAq+N9V2Kg4Un+r01kNbL+DtmgyTXR953thvgLG4fwd6eioDtX2x3d3lZEWFrnxRA7YPZTkOXfmKwpNgkSiusyUHKCpItmcS52PB9InC3Q7c0qpuBVvShdNGmxfSJSrp1oVsvKAPFJkOeRT3+R0jPNK/Kv7/fN6RSn7zlFymHGCK5k8V/1XeLgWomu6WtmphYej5FODPey9cStRgNiLh/7EYlzQ20L4AZWrQU7TOKdIfgYkb6zZHkd0D9u3XEVAQoGB2pueOUeaJRHehhsZR4AX/k6++XfiuJ1njyUpO2TcxSN5v+zaE75/M+o76RIz8wI4bnYBrABZDsXXRR5ZJdJANCNLtICJCGen3KcYnx8BBbOhMZqOtSWuOBdyBfP2nQ1K9jrnNZ2zAokwYFNLYJSa8ZLybbO0fngKo8brrDFc8pECpCmoIo4Azoa3igoizblQ3vzp714wCALIF+KWTv5ZGqua2Jm534Ttt5rQUBjmYjq08cDJN/TuQZHYBJ4qRE3R9Z8vSjzxe/fhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:47=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> Hi Yafang,
>
> On Wed, Sep 23, 2026 at 09:07:40PM +0800, Yafang Shao wrote:
> > On Tue, Sep 22, 2026 at 3:30=E2=80=AFAM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> [...]
> > >
> > > Known open questions
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > The semantics of memory.high for remote chargers or kernel threads is=
 a
> > > grey area and this series does not aim to resolve that.
> > >
> > > Another open question is whether a bound on debt deferral is needed. =
At
> > > the moment, we think that rather than putting a limit on deferral for
> > > memory.high, it will be better to handle that through an async worker=
 like
> > > memcg->high_work.  We aim to introduce that later, along with the rig=
ht CPU
> > > accounting for that async work.
> >
> > Hello Shakeel,
> >
> > On the open question of how deferred debt eventually gets paid: would
> > it make sense for the policy to also notify userspace (e.g. via
> > ringbuf) when it defers,
>
> I think the notification through bpf programs is already possible and a b=
pf
> program deciding to bypass memory.high can already do notification via ri=
ngbuf.
>
> > and have a userspace reclaimer do the reclaim
> > through memory.reclaim?
> >
> > I understand one of the concerns for the async worker is CPU
> > accounting. If the concern is that the kworker's CPU usage is not
> > charged to the target cgroup, the userspace reclaimer could instead be
> > spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
> > cgroup, and both its CPU and memory usage get charged there.
> >
> > One caveat: intermediate cgroups with the no-internal-process
> > constraint cannot take processes, so this would only work for leaf
> > cgroups.
> >
> > What do you think?
>
> I think all of this is possible without additional code and with this ser=
ies.
> With AI, should be very easy to prototype it. Please take a stab and I wi=
ll look
> into it as well (time permitting).

An LLM helped me quickly implement a userspace async memcg reclaimer
based on your series, and it seems to work quite well.

>
> Thanks for taking a look and also please let me know what other ways you =
think
> memcg can be customized through BPF in a beneficial way.

Sure. On our production servers we have been running a set of BPF
programs to tailor kernel behavior for different workloads =E2=80=94 all of
them global programs so far =E2=80=94 and I believe they are all good
candidates for per-cgroup BPF policies now that cgroup-attached
struct_ops is available. They have been really helpful in our
Kubernetes production environment. I have sent some of them upstream,
such as:

  - BPF-THP
    https://lwn.net/Articles/1039689/
  - BPF-auto-NUMA
    https://lwn.net/Articles/1054030/

Perhaps we can revisit both of them and turn them into per-cgroup
policies =E2=80=94 what do you think?

We are also running some custom BPF programs that have not been sent
upstream yet, such as:

  - BPF-async-reclaimer
    We don't care about the CPU accounting of the kworker, so we just
wake up a kworker to do the async reclaiming.
  - BPF-fault-around

Both are really beneficial to our workloads, and both are global programs t=
oday.

We are planning a few more customizations to resolve painful
production issues, such as:

  - The long-standing inode::lock contention caused by dentries [0].
    We have not started implementing it yet, but we might introduce a
memcg->dentry_limit or a memcg->vfs_cache_pressure as BPF policies..
  - cgroup-level readahead.

So, to answer your question directly: for memcg itself, the beneficial
customizations for us are the reclaim policy (the async reclaimer
above), the dentry/vfs cache pressure knobs, and fault-around; the
rest are per-cgroup MM policies that would need the
struct_ops-to-cgroup mechanism generalized beyond memcg =E2=80=94 which is =
why
I hope these use cases can help make the design more generic.

[0] https://lore.kernel.org/linux-fsdevel/20240511200240.6354-2-torvalds@li=
nux-foundation.org/

--=20
Regards
Yafang

