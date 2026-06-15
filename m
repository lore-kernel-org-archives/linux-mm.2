Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF81ECD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3323E6B008A; Sun, 14 Jun 2026 22:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2BC6B008C; Sun, 14 Jun 2026 22:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D17C6B0092; Sun, 14 Jun 2026 22:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BAC26B008A
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:01:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4516875EB
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:01:43 +0000 (UTC)
X-FDA: 84880495686.08.F3765D3
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBAD240004
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:01:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="n/WAOWfz";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781488901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2Ow1sAoBe980wlQzlYNnDrqp2nFrA+gdxhrOQuTe0I=;
	b=L/JLG6RUmCH2LaRDau6fqY9L4S7RlJm/eGcoTWCXmMkKC+3YIqTIqgAptm1T5ltqV3chzY
	4OnDr76ukvlsZkEN93z+2nirv2sAPbuvIpq4qJZUxZTc9AxL7g7gOQFvZSLPul5CihSJCJ
	keeCi+mSotJPx841+BDckS2oKEszhYw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="n/WAOWfz";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781488901;
	b=KOfn6dn7p6RjskyXlEsN82l3UEfArWX25FvtWQDTFfJmbrx1wgKWfqJVpdh/dD9VzSSurJ
	5CZC2ZaTpwgTDtzUDjkCTL+cCqylnzU5YoQH6cIgqMJdh8Q7Aax7RCW1y/6LJOB6WrHct9
	pNYbNfKW6/NcOggJSo6YPHGYAujH3F4=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51765331535so705621cf.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:01:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781488901; cv=none;
        d=google.com; s=arc-20240605;
        b=iAzcPm9jjdbMgX//tVM2SI3tj3ckn5XNHeyvlhGkd9KFNbjxuvtRz3U2Q7Bg/Ywfbt
         usJQzr5UrA6jb9GqAk1MhyXDnHONl8cK0vBV7q/hzvqDYRHPnJqFgkl1nP/AtWUcLkVg
         /VXS52qLsGxxA3Q4m4fi0SLRyvRx/MIf70JAcdt8gwelvco7i6EtMWEdC13tYqpo8mMU
         W4obiDiDNmsmufAIFRGkadqdtm/dzA029bz31wj5nndPFrlkaSjw74356F2TwTaR5tCI
         SFKkai/1Qah1PNQbWtt90h+IDYTDT2zLcT7N8/uXPLpdZid247uUEfao9IRZwzzzdQGD
         /o+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N2Ow1sAoBe980wlQzlYNnDrqp2nFrA+gdxhrOQuTe0I=;
        fh=jyRLPepEOR+ipVmWYoAjc898P4vcCjq1DiEHxNj2gzQ=;
        b=eNRL6lUZpP4B0Jck5MFp0vDDMS17Bf4+P0A6LlWPN6ld9xVvToo/ck58zALDRjTPmU
         5S6WcDsRQg9bgHXi32gjiJjmVslpvnoEKn/nw6z6iuWKD/z0TwkByZAvyOrPpWcqF3HB
         l8QCQ/cGXOdp89tk8XK5I/i6igbIm029HAKSzclaxeCtQapcsaaw75HqP9CCgeP3CPBb
         7PvvDtznNN/vTKeNv8CH1YZHP5xmca1bQmWqo6O+OzuTtXO+sO6QQkg42VkvzxQzkt9x
         CQJN7wVVoM+lnaMmRuH+bG/yIBbcKJcCWGoLYCrFkvygGZOIluPzTujK1Y/8n9RJZJzl
         dyow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781488901; x=1782093701; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2Ow1sAoBe980wlQzlYNnDrqp2nFrA+gdxhrOQuTe0I=;
        b=n/WAOWfz6o1IpPcwdj2LLN4gIyWcHrI5i52RvjVPU5jiVURtgSj80FFYa+fQlV4r2T
         L7Albyu4OrmRwo9TYpO5xuiRygKaglLOor1YETz3xUe//xts+TR97+3IZJQZ8BQl6j2D
         ymKBZSfp1S4EZBfPPQvGsGtLzWb8jEKHfkOhECUn+xQJKHrPzDNNs916bdMl6azOJxSV
         yD//Gc5ApwonpkywQZ0UZp5F4CQDH0f0rJWlAmGtvFLHto9cIH/FUNB7YXeCdy8MQ/w+
         eTGxyBXb+o/Q0ltjruz1K5BeZlqgpY2qbJaFFjlihJ+WfZwJ+4sLBLrsPr9bxPB3GVoU
         X2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781488901; x=1782093701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N2Ow1sAoBe980wlQzlYNnDrqp2nFrA+gdxhrOQuTe0I=;
        b=dlSriwmlDMdqmoAiU5liewTyhoqwJvxnem6kyD8/k0leOe0MqBoY7V0bjRTAx5umh4
         K0ZVa9g/se8+f1BRR12RavWJGOKHkLHxSJEVEKZ83ed4QjqUB/SVcQzkEsW+0fFJgBFO
         yYb1zankbVEvhS6uKlLPbpN1R4+ztezCrcfyubhLYsN1TdFqNoTCzHfGPlQJxbT6LyVE
         DnocssbB29UPZeAqx3AnNhmQTDKBWTNKorlLbXVKLqKjH4K1MnnIEf/1Ho4VHSMXdP2+
         FHycxb6ngP4/4ZnVldwmZmn7WbBIOU9Tic+V/QRRJadlUtz0JB0I9WZaY6w6j45+u1Tg
         leHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/YPRRKL6RtLGM/PPAkGsQl4uDTd9PHeDGMVi2KdVaYmgJY9U9EwnOZsJLM1mOiwX8Nsiqyvs82GA==@kvack.org
X-Gm-Message-State: AOJu0YxIRvdE1ZhX8sZ4cCFCldS2U+HbA+VDHPUGRmnzGkUhoiUHpkWy
	flHIc//z0VzlSAbHV9af2lFvUPE3TL1iqUJyVW/QKnkLtPILfqZVQywqbZpUE+hfZrkc3y4Kys3
	2g9zph0TmsHZuzuR4TkavZaEQ6HpEDKiZVfqhSuKW
X-Gm-Gg: Acq92OGnIC1BaicNrJRD3BBa17foA7nFvgcwNI4TFM4SbDwKDTCe/YiYMn2Xe4gLURp
	TOCwgmPob3xtWF57J60tB2QtQir6djbslz61WGTj+CdmPd6t0DYJiBb3LkTIV24bpX/vPIqR3A/
	yUJ3LhFKlZWsBX8Cvz/nIG1YkZh89VTjMTdSyEhUVZEXkfM02EvQjI3OvAD80hwzeKAL2FhxNyx
	pHaUKiqitVtzHl7zdA7SBh9Y9e3ic6+aBts0K3pEf3NjPLfMnfxGE+NyA+Nt8uSJqzrzxRxRptm
	h/0Dig==
X-Received: by 2002:a05:622a:1195:b0:517:99ea:ab7d with SMTP id
 d75a77b69052e-51955ec344bmr11553371cf.23.1781488899532; Sun, 14 Jun 2026
 19:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org> <aiuBoDbQc0N-l7e-@fedora>
 <CAJuCfpGSHfNUvL9AzbftSg=uGRW4cJLbO6iB15keyN6A_eSWEw@mail.gmail.com>
In-Reply-To: <CAJuCfpGSHfNUvL9AzbftSg=uGRW4cJLbO6iB15keyN6A_eSWEw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 19:01:27 -0700
X-Gm-Features: AVVi8CcPpLFopscn0IxYxXYrQ4AGFOmrCZ1O8V-xF1QOAQJ5QpAuLPZGu2tne4U
Message-ID: <CAJuCfpH-zz3dnN+j2o3LQjYLpFZZkyA1x176nsPQ5_r3NbY27A@mail.gmail.com>
Subject: Re: [PATCH v2 05/16] mm/slab: introduce alloc_flags and SLAB_ALLOC_TRYLOCK
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CBAD240004
X-Stat-Signature: punpfkw4rksxzxwzdt999bsbtreyz4q6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781488901-517295
X-HE-Meta: U2FsdGVkX1+qDG/ftKnm0PfcdHIslVzqlp+NcVtExuuhhiVaJaxd/lWcE5yst1FkNCbpT4v+XNJ4ef8npaDFnogkG6qyAqmqUPwrtciJQnJm9F1qy/+e0lKDfi9aD/bFFfly+pDh24c01SNocpBjb5ABng1iXuOq1y8NgkVuDk4AuHYRrz9HD9vHOsbXTLRe1b7BqVLeOzQllAzYAjMUzVvb9H0KGFjBQCb/iM+sC8bgCa86fgaFi8Y+LIV5Ev7Y0nRbe4Js9RrRrfv9n8xVdVRfR3QagfbTlpSEDsZmV9Oyh0FSqxbOyXUd88m1Jly5EcWn2+M1AZeaO3Pd373pXl0zRu0S1zblubd+I9QRyeGQPkif5rt/qzzgQI0gINsQ3SKygZjGvm8uh2Ve9fG9pqzFfORxYY4KsnQa4rM5gBg6I9roRNSd8/UVWRbm16duE0sltOB7+Pk7ggL8voJNETuspWWm89V+wGCHuUKF5oVhw/BPbMBVe0TU37Uf3M8WPCGMEW2pQ/hWSs/0vBwya5HIjwsmTLsvFQV8BCooTif5gcTb3StiOOOL3GFn6T0e5IxgRNZ6jyEWn9kNBGpg2QlMGFiEm2oOhIENGl9OXTIe/PxrBFzWpOsCMPo3yTbFzFOEBW+U0m/5i4yuWVxBhyeHxAWj4q8VEiATXWQ7uNR9OvnZXqxT/zWqX6zxUdHmU8g5IDlJqOG8lVYLoWMQV/ZvZHIL/L5kmCTd0CVMers7qo0iYHtcjrdD+TWTMmqILAsBTNJWzZFnf1sGyOMHdg4pm3GzzgP6ujsfi10hF0zNtokaR4efxC896MH1Uk3RLFWbBh52x0f1LWxlm6Ex+2WJOSLr6UGgdR/kOvp74PQsUHCBhZmGfC9TgmWdQzJsNCpRL6cSC8wBa6GarcTExSQdjC5uT9whkW+cBF97tVVhdH8/v8LOrBrIlq6FMMPcouaeRz/SHjGwRrMVWJE
 nJMXkJaf
 Z9FeNqPLT84s5Hd1uTuvbdoGL040Dr+HYOd8fQAVIZVOyGllA2wZFw9hpRfM5+FaRJT4wQ1q+BwEEKAuq0vHByjYuPZnKYQAMt0WvEB8tbsrbn+6xApkXK0OjjvyDWhPOpdXx6ie10U1iLmlE2PmVuvzdRy6Zbz3K+vXwzO5JonqInkcmfqpo5v4xmaW5hElYsW9Jz6GKpuIkx/I4Qdk9V2uwatqvyUx3xxJxL8LblUwTEDgU2Yb2fdiB7ggd7qSFxLuNjLPpNbpNlXaocEB8mymPhMKDSiUEkmVVwJvul9s+m+Ia0vQWHHBlhQ9DfJEbIcnENspDJjUnvzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 7:00=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Jun 11, 2026 at 8:50=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
> >
> > On Wed, Jun 10, 2026 at 05:40:07PM +0200, Vlastimil Babka (SUSE) wrote:
> > > Similarly to the page allocators, introduce slab-allocator specific
> > > alloc flags that internally control allocation behavior in addition t=
o
> > > gfp_flags, without occupying the limited gfp flags space.
> > >
> > > Introduce the first flag SLAB_ALLOC_TRYLOCK that behaves similarly to
> > > page allocator's ALLOC_TRYLOCK and will be used to reimplement
> > > kmalloc_nolock()'s "!allow_spin" behavior. That currently relies on
> > > gfpflags_allow_spinning() and thus the lack of both __GFP_RECLAIM fla=
gs,
> > > importantly __GFP_KSWAPD_RECLAIM. This can give false-positive result=
s
> > > e.g. in early boot with a restricted gfp_allowed_mask.
> > >
> > > Also introduce alloc_flags_allow_spinning() to replace the usage of
> > > gfpflags_allow_spinning().
> > >
> > > Start using alloc_flags and the new check first in alloc_from_pcs() a=
nd
> > > __pcs_replace_empty_main(). This means some slab allocations that wer=
e
> > > falsely treated as kmalloc_nolock() due to their gfp flags will now h=
ave
> > > higher chances of succeed, and this will further increase with follow=
up
>
> nit: I think it should be either "higher chances of succeess" or
> "higher chances to succeed".

And of course I misspelled "success" :)

>
> > > changes.
> > >
> > > Remove a WARN_ON_ONCE() from refill_objects() as it's now legitimate =
to
> > > reach it from a slab allocation that's not _nolock() and yet lacks
> > > __GFP_KSWAPD_RECLAIM for other reasons.
> > >
> > > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > > ---
> >
> > Reviewed-by: Hao Li <hao.li@linux.dev>
>
> I would call SLAB_ALLOC_TRYLOCK something like SLAB_ALLOC_NOSPIN or
> SLAB_ALLOC_NOLOCK but naming is hard and I don't claim myself to be
> good at it. So, feel free to adopt my suggestion if you like it or
> ignore it otherwise.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> >
> > --
> > Thanks,
> > Hao

