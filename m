Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9C7CD4F52
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996996B0005; Tue, 19 May 2026 04:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947976B0088; Tue, 19 May 2026 04:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836756B008C; Tue, 19 May 2026 04:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 747066B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:25:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E66CA0254
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:25:24 +0000 (UTC)
X-FDA: 84783484968.11.7E23A52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id BAB68140011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:25:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KK+efXO4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779179121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zmlcsxs7JMP5bdHZ5kThghYTTdo51TjoA70ut3zJssU=;
	b=ZzlGGXzRdIS+9zaBobkHt5Tn2ko0So2vydXtU9kjxj56fzNU8zdUPXX0fA41C2xB4vMZfd
	FIfgugumIwvDvTzuokyL1jiTjfrhoj8dB6/Ce/CEqMXPuC3q6XGrsOkvhEBFV/NAYoLP8O
	K9zGRit3YQSlvYewmIvgaBXA1VIVLfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779179121; a=rsa-sha256;
	cv=none;
	b=QcdyKBPfJ6m05pjHNrn78eO83qcD9CICHdI+/AYV1tgVuFFycHWng66AHcrS31avSLYYL+
	yX1KVkbwZ8ub60MlDVIBZo6rAoQKjQFRSnbwbbXDm64jdfIVdg/h23QNcUQUnR2gsW3dOJ
	CW5kcqXHJ/YtRfLATRhmfMNPs127nfA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KK+efXO4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779179121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zmlcsxs7JMP5bdHZ5kThghYTTdo51TjoA70ut3zJssU=;
	b=KK+efXO4ylYctwcp8LVfDh7CXaZpMeiSf7hoe5yOC3Cv26P7X3ftYv2irWzJ01Dv9/1b58
	/AkcC/zUV1PomlQM/wgknTrbwXhCQYNhGwCvosULkEj2VIf0q6TpyH1cfqZcJrzy2KdA4i
	txlagmXGKw0OU7pXySF3EaXHgUqwu9g=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-6e1gfauMM8G31ItQdPDD0w-1; Tue, 19 May 2026 04:25:20 -0400
X-MC-Unique: 6e1gfauMM8G31ItQdPDD0w-1
X-Mimecast-MFC-AGG-ID: 6e1gfauMM8G31ItQdPDD0w_1779179119
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7bd5c267082so6354807b3.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 01:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779179119; x=1779783919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zmlcsxs7JMP5bdHZ5kThghYTTdo51TjoA70ut3zJssU=;
        b=iNeqXincqjntrjpp9nHZaN0tgMU3JgrdNd1JLEkK6MNoOh/paFVb8eanQvzT1bKGmf
         KOa7POWK0B0jo35iPqIfmhfbsO0n7+KsV8ZJSJayeZ0idzxdzUXuQl9tmcA1UjddgIsx
         ZnzYbPxAN7L3bkx8PtiERAApV7U4vZ/p6TKEEl7oWSPnV4irDMdldEI/lHBcU+kR+3jS
         zW0/OEBfB2xHdFuWZ86Kwm/qaZYuFlBbqsLL6IdnqQrM755aTFWBgSyERMSli1pwrkHi
         EjwhAUdUsRcOhVAoH7Rz/ZEkU7IM+uicqQx5ixgtFchUMPYu/7lURFjJ5uk3G5XpScpI
         1Rgw==
X-Forwarded-Encrypted: i=1; AFNElJ/ZrcxH0Ze/gH5q+rkXBDWuvuVlU6zHff6ZfOyYGw70kOP0VcDE9fomaGGPvzjLHiu8wqqK4vvEwg==@kvack.org
X-Gm-Message-State: AOJu0YwN1qUoeaCfnTn0NozcMs/neRNXsVl285T24duDcc6FM4ayj5F6
	leHKq/2wgKDC0qcWvruey0Sjj8flsxXNCJiGQUBxs+pFxq+us85iYBuK/4dpt1WRffmx4hyno2Q
	L2H9YCpeNTbaHluzb4A9IEfvSt43pBktIWVXrOz61/mVmCOnaz3EcFHAQIe64cJ1uqM/VKWPphK
	6vjc7o+Qnf8Z3beYbuezJ9oSO8mBI=
X-Gm-Gg: Acq92OEm+Az6D8ARAUMNzYri5Zbubop7+bqTgVI/l5obJupGpY7uhtCjcPCNFsp06KP
	clQ94BoDwai7Gkchbfwm+rw/+0tBP28QMeDjtk+K9iQB0vnQ/vD0PmK2f1nZmfHbkSam/Xflf4Y
	BYPwgWk01k9wAi+9a6H/D43iBz4V+FfTnHyA7vbjOgcmbLM6hqSJ9Zt0oubjZ68Oyz5mEffbyHM
	DySZA==
X-Received: by 2002:a05:690c:e041:b0:7b3:edc7:9bb8 with SMTP id 00721157ae682-7c955b970femr172556937b3.0.1779179119384;
        Tue, 19 May 2026 01:25:19 -0700 (PDT)
X-Received: by 2002:a05:690c:e041:b0:7b3:edc7:9bb8 with SMTP id
 00721157ae682-7c955b970femr172556607b3.0.1779179118837; Tue, 19 May 2026
 01:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <20260515-hinschauen-effizient-9e3a05a94f2e@brauner> <CABdmKX0d6Zsg+_TxXjB80UZR23ZvXzxYoWzORgwmx=ZiuE+Nzw@mail.gmail.com>
 <208fb820-d8eb-4832-a343-ef8b360e8120@amd.com> <CADSE00Lh95ygoXGKJGsYvQGEsFV8sVmwEC3uvh8M6r3ERzaJwg@mail.gmail.com>
 <88efe10a-8b93-4a81-8279-4a5559d0f17c@amd.com> <CABdmKX3yZubjDKbVqwrjHAiKyj_ioHzOoxd0wzFbJK=PAGOqcQ@mail.gmail.com>
 <01b6eefc-c107-4f8c-9d7c-3b86f54cabaa@amd.com>
In-Reply-To: <01b6eefc-c107-4f8c-9d7c-3b86f54cabaa@amd.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 19 May 2026 10:25:07 +0200
X-Gm-Features: AVHnY4K5LncaNoVhZCnb-g1Oej_4CFtS9sUy70LBQyTJDD76MUlJZifB3Hgf-cg
Message-ID: <CADSE00KCpCHOu2GMJ++ozXXbwF13fd2ZfmC3CnZBdLM_0p+ZMg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Christian Brauner <brauner@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, mripard@kernel.org, 
	echanude@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qr5X5QcVvyeVb5tk2UhLA-Y5K-5XqWsZuZvKNXRBBuw_1779179119
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAB68140011
X-Stat-Signature: ryye7gpj9mohgdxmfbi5ufrc5w8ptsau
X-Rspam-User: 
X-HE-Tag: 1779179121-375790
X-HE-Meta: U2FsdGVkX1/lugphs6Vp96fgmYHFlCg7PYQqRye3V+nw/PgOWNYLwQKJ61FNP4v9bXZmFv3UMmUoGjHC4xKEPstZkxeDdC4AhvXsmOWFnNFq9ZddSDafnKsFBEsOYdWIwmGCCgHocnBYqvnBHB6K5PUI1BCAi+LNd2ni1RLoTYoa03xqXCa+7B5BLHcQZbr8MouSq6d2zVZMtN434dPgr6q8IWs5VhCFcuDPfIA7/sszuz/Buxi3tcFFVtVU1M+HnOpiam5iudBicAKhgKdJN+vNrkGUXXJLN5lMWvjthF4Bd2HomgqwNwoGCwRobTabzVe9NpJFIUH/K0Qr90RtL8ae7+TfgCEQWEmwA3m5I2FwW3SJE3oF5ZIcozvTKqT+sYN/0gn764Bmw+4Bz5fWUBIzlfPW20FmDXafIaPGUAYB2INQzJzn3v2GVCrLx+wbW1341sXu51mLV0HDdeVkWcRwpGl7JazPAu5VEU0DpX0XXzIcGVkmKb1Zfv1ob3qRL4RoOQ6m1JDwnscVNJxhgYYoaeomI12y/oL1jf1uPBwxGHKg/baLLvTBO8UCE9y7KY6o2mPtqkdj3gHVAfUFWHHYKck3B2t4pEsCPeFGfGxj6WDG6dViGr25AP5MkS4t1Amt3wIUA8OaLIwtcAhW2k2ApnSUOZ18EeROeGxidD6ufD46yvbBHdOOJNhrCPdal8Nr+AOqyL0OHWoqkm+RI/HIw/m/slBhAwnZjWzNDVko2v79RW5xH2+yt8FXxzt2suFQ5+kpkG7/swXSZBSLwZMZPIY/son0GGzif5RFMI3c76u7TIEyUlgRF6o7bXj1kC38BHGrcag+05zgjcHp0XXVkGmlokfb/q63+w9eA3e9ahWFpkashxmh+zyboZpbjYd6BnatNeNAoToRzoWQKGPI2tQAht/FJz4FAQAPKdbe5nS18hIydPpyOFaZbbkEocYPhT+FD6EbIrK+AFt
 12jFCeh+
 ryPbQA6JZcCrB1LrCRAtMQfMevwJRRewOjzMizxS1qBTHf17MK7WT+nmZ2k8bNTEOVjb4fwG6EuREWG7+LGesAEHm+yTISEPmUugKjuhtxi/svKp6CMCjc/qv4YZ7I93iddghbpshirATqJSHK4WgONY4CWoYJ/jWG6sZeyFYXOfdYFJ8f9U7wDMi3OVqqe405b5pY+/lT28fva6gUK7h50Ba76/BGoJ0NT/lAN8D9P4iK1JdX8gbGbA9+Mf+IkPYwb3g9XgwvW6baHUuVs44LnRfpePuPEDTUhOPwkFIwn8c4g9bPTi8st6Vh1fAHhAilBL1S4+Jt81tUAJjWWE9c+nXG/VokS7uzACjlKVQ0JaM+YZNQfgEzBWcOfyDeqB+SDgib5OuLoNuGARXP1kH0J8yC7/94jqaYv/X74AneG5YSJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 9:20=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 5/19/26 01:39, T.J. Mercier wrote:
> > On Mon, May 18, 2026 at 7:07=E2=80=AFAM Christian K=C3=B6nig
> > <christian.koenig@amd.com> wrote:
> >>
> >> On 5/18/26 14:50, Albert Esteve wrote:
> >>> On Mon, May 18, 2026 at 9:20=E2=80=AFAM Christian K=C3=B6nig
> >>> <christian.koenig@amd.com> wrote:
> >>>>
> >>>> On 5/15/26 19:06, T.J. Mercier wrote:
> >>>>> On Fri, May 15, 2026 at 6:53=E2=80=AFAM Christian Brauner <brauner@=
kernel.org> wrote:
> >>>>>>
> >>>>>> On Tue, May 12, 2026 at 11:10:44AM +0200, Albert Esteve wrote:
> >>>>>>> On embedded platforms a central process often allocates dma-buf
> >>>>>>> memory on behalf of client applications. Without a way to
> >>>>>>> attribute the charge to the requesting client's cgroup, the
> >>>>>>> cost lands on the allocator, making per-cgroup memory limits
> >>>>>>> ineffective for the actual consumers.
> >>>>>>>
> >>>>>>> Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> >>>>>>
> >>>>>> Please be aware that pidfds come in two flavors:
> >>>>>>
> >>>>>> thread-group pidfds and thread-specific pidfds. Make sure that you=
r API
> >>>>>> doesn't implicitly depend on this distinction not existing.
> >>>>>
> >>>>> Hi Christian,
> >>>>>
> >>>>> Memcg is not a controller that supports "thread mode" so all thread=
s
> >>>>> in a group should belong to the same memcg.
> >>>>
> >>>> BTW: Exactly that is the requirement automotive has with their nativ=
e context use case.
> >>>>
> >>>> The use case is that you have a deamon which has multiple threads we=
re each one is acting on behalve of some other process.
> >>>>
> >>>> At the moment we basically say they are simply not using cgroups for=
 that use case, but it would be really nice if we could handle that as well=
.
> >>>>
> >>>> Summarizing the requirement of that use case: You need a different c=
group for each thread of a process.
> >>>
> >>> Hi Christian,
> >>>
> >>> Thanks for sharing this atuomotive usecase. If I understand correctly=
,
> >>> the actual requirement is attributing dma-buf charges to the right
> >>> client, not putting each daemon thread in a different cgroup?
> >>
> >> Nope, exactly that's the difference.
> >>
> >> The thread acts as a filtering agent for both memory allocation and co=
mmand submission for somebody else, the process on which behalve the daemon=
 does things can even be in a client VM, completely remote over some networ=
k or even something like a microcontroller.
> >>
> >> Everything the thread does regarding CPU time, GPU driver memory alloc=
ation as well as resources like GPU processing and I/O time etc.. needs to =
be accounted to one client which can be different for each thread of the pr=
ocess.
> >>
> >> The only thing which is shared with the main process thread is CPU mem=
ory resources, e.g. malloc() because that is basically just needed for hous=
ekeeping and pretty much irrelevant for this kind of use case.
> >>
> >> The problem is now you can't do that with cgroups at the moment but un=
fortunately only the kernel has the information you need to know to do this=
.
> >>
> >> So what you end up with is to define tons of interfaces just to get th=
e necessary information from the kernel into userspace and then essentially=
 duplicate the same infrastructure cgroup provides in the kernel in userspa=
ce again.
> >>
> >>> If so,
> >>> the `charge_pid_fd` approach achieves this directly by passing the
> >>> client's `pid_fd`, without needing to add per-thread cgroup
> >>> infrastructure.
> >>
> >> Well it's already a massive improvemt, we could basically stop doing t=
he whole duplication part for the GPU driver stack and just use cgroups for=
 this part.
> >>
> >> Doing that automatically for CPU and I/O time would just be nice to ha=
ve additionally.
> >>
> >> Regards,
> >> Christian.
> >
> > Hopefully I'm following correctly here.... So you are duplicating the
> > GPU driver stack to achieve remote accounting on a per-thread basis?
>
> Not quite, we are duplicating the handling cgroup provides in the kernel =
in userspace.
>
> For this memory usage information as well as execution times of the GPU k=
ernel driver is exposed in fdinfo for example.
>
> > Does this mean for GPU allocations you currently have some GFP_ACCOUNT
> > magic in your driver to attribute GPU memory to the correct remote
> > client?
>
> No, we just expose what the kernel driver has allocated for itself. E.g. =
page tables, buffers etc...
>
> When userspace allocates something using memfd_create() for example we ju=
st ignore that.


>
> > So this series would close the gap for dma-buf allocations,
> > but what about private GPU driver memory allocated on behalf of a
> > client?
>
> Well we would need a cgroup which isn't associated with any process were =
we could charge the GPU driver allocations against.

I think I better understand your framing for this now. Thanks again
for taking the time to explain.

I was looking for a way to pass cgroup around to do the charge. I
found that `struct cgroup *cgroup_get_from_fd(int fd)` already exists
in cgroups available symbols to handle cgroup directories.

So here's an idea...

Rename the charge_pid_fd to charge_fd:
- If it is a pidfd (`!IS_ERR(pidfd_pid(fget(charge_fd)))`) then we do
what we're already doing here.
- If it is a cgroup_fd (`!IS_ERR(cgroup_get_from_fd(charge_fd))`) then
we charge to that cgroup.

Also we could add add an ioctl for the generic fd path similar to what
we have for dma-buf heaps. Or have a new flavour for memfd_create:
```
memfd_create2(name, flags, charge_fd);
```

The transfer ioctl could also be made generic to accept both pidfds
and cgroup_fds.

For this series we could move forward as is, and make the generic
solution a follow-up series, knowing that the field can be reused for
cgroup fds.

>
> But good point, charging against a pid wouldn't work in this use case.
>
> Regards,
> Christian.
>


