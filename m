Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A6DCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54BAC8018A; Tue, 28 Oct 2025 13:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523718013F; Tue, 28 Oct 2025 13:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439248018A; Tue, 28 Oct 2025 13:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 303CE8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:13:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C88604976B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:13:16 +0000 (UTC)
X-FDA: 84048168792.27.A11DBB2
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id CAF19C0003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:13:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CCILvNYI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761671594; a=rsa-sha256;
	cv=none;
	b=2vQjz2Gv0Dl1WNz9kEXEbptf+ktdSknMP1h+0AaX7fQl+7j3E1ej+/hzsgDb17Dep5zOJU
	/Dp6BsjBUMym6UIq6vWLsDOYP5Vvldv5+7legAgKWz0nIpFABAnamQNRyZ5WFqjKeemjSl
	R1S94lB/jwj8j7y2N05M3g6SLyW6fsc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CCILvNYI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761671594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIJa6yW1wPduR4RBE7Uk88NTTDYku8mns/k2aKumBjg=;
	b=gGInxvF9ICrENBlKBXoyRP0g/8w71Da8N+eVYxXG2WXsU6mrckDjGdvQEIZ0ymJgaVSXbb
	s++T4ovzM/qxpzaDgGSSFqV364slWtMn8Zhmft70rAjj1m7ccvvA+NqUvKrAjaOcjJAy1t
	Q01H4J+zrQn5G7XDwQtnbccNN1g0i8w=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so40384425e9.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761671593; x=1762276393; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DIJa6yW1wPduR4RBE7Uk88NTTDYku8mns/k2aKumBjg=;
        b=CCILvNYIJzCDVWVzOBBS2vRBcZuU2hb56ZOpy0r1SgF4dNW5lvrB41lAkRQt4jBtI9
         0PcC20YBzcVxAHTQlCH4kEDeZ4pvF51jgpSviKuikdF2GyLJockPt6GX4av71xB8ZkJ7
         kYrLzJSA6KwvmMbsmLGJxIIbV2XMZRtVQjipUEtMDjf9eEK4qbz3/ZOgEV80zIhzRz/V
         mlgXf1MYanCyjyFeTnLI6m/ZneN8yWWHLj2EpFWiB8QFvgtCR800WKBBi2vuNullLQhw
         02qDdh20sJacp9o2nNoESu9opnlYdd0c3OevgTMdJmoAXD6b9W0TvqS7BtVLrParr725
         ykuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761671593; x=1762276393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DIJa6yW1wPduR4RBE7Uk88NTTDYku8mns/k2aKumBjg=;
        b=OSdTeUwbMW0PrDm/kX3l7dvkM8xwJh1ym+3l6Atw/GD3NlS2gcwsgQUDwZgoN/aC+Z
         D0ppl51FLdIn84DURHrqC3P2XnM7kMhtmbjNDDX+IzxWsQLSNrYdN2zztNu9FhDwa9xg
         mKjhSSzcb6ykFfc4OVGV7VRGw165CT5XltizomoD0gjGnpu84LVOvFZhyqY+U099ymxZ
         1huBFAnvJO8HsUBUHY81LjLZz8iImV6rtYRHY8K+g8NoP56FhM+Fu7G52l4jftBxbrqN
         Ow4lpJ19tdfO8p44jOWgiMoB9YUSR0A7eDowFKYVscWNsrSChmkD6EIAMPlq1jk+TgIC
         /B1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwQ2chxKl8sRryRGie13QSEv1Lq7p5Uon+Fn4lELW9VCXJGfirSmqTqXULeG+O2GBRq0stMBVIWA==@kvack.org
X-Gm-Message-State: AOJu0Yyj8gTkibnzEK+sih2b7a0sar2WrYTgiKaGJ+6gcfZEQRYHkKlT
	vTzZFdLU8hm5Xln7NmXC/OKUf07Cwvq7h0vv53YCnrufSpC02NBRS5ThgGLbiLBTgPolpLjX8uu
	hFnLlLGCe1ifCkhSrmUsOP9xZt5zHIIg=
X-Gm-Gg: ASbGncvaXd8fQvnsMRu5AINxq1bs8ZAJu8gBrwa7OAvxjV0Vfy9SOeZT2IFEmZFXI1N
	d3WGyCFpYpE9v56qUtkMgE2Ps7psYFoJUe3kuD4A5rz76VldHdR30TYBcvBHWVvJhPZu/gz6P/A
	21yB2dcfoztDAahhFvF32xIR9TF1/WXIdX986XwURaAG/xUmPhulO4U/TUrA2bP/TLmrZ/DVffR
	2jzy3zXmJGi8kTvtCrQe8zLih3ASVp3wdh+83JWIv1WxKUnde2n8PEo9oRDiZQyYO/yuyxLsWu/
X-Google-Smtp-Source: AGHT+IFP3tNBApkgdl3FcTzbs5OTt0/UxHdByUlbNMa7M18QIw/9VxiLJBuO5yL98zcmhZv7CtkpzCaqV05ZKsJfr2g=
X-Received: by 2002:a05:600c:198f:b0:46e:32dd:1b1a with SMTP id
 5b1f17b1804b1-4771e165903mr2438615e9.7.1761671592922; Tue, 28 Oct 2025
 10:13:12 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-9-roman.gushchin@linux.dev>
 <2c91977fcab04be6305bf4be57e825f7e84005d16667adcdfad0585be506537c@mail.kernel.org>
 <87ldkv57nc.fsf@linux.dev>
In-Reply-To: <87ldkv57nc.fsf@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 28 Oct 2025 10:12:59 -0700
X-Gm-Features: AWmQ_bkyeYs1B4vFl1Z_bGgU5JQLQ4pVv-Ayp-pwPQhhznGsEdhTH5wiCYvJjLE
Message-ID: <CAADnVQLkza5_95qc0vGYBLUu-4FN_cZEcVywTs5XemTE9O-ZtQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/23] mm: introduce BPF kfuncs to deal with memcg pointers
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bot+bpf-ci@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, inwardvessel <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Eduard <eddyz87@gmail.com>, Yonghong Song <yonghong.song@linux.dev>, Chris Mason <clm@meta.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gk3peyp8qucmmyyaw6xqbe61bbjsc453
X-Rspamd-Queue-Id: CAF19C0003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761671594-182403
X-HE-Meta: U2FsdGVkX19czlIhfAEKu+Mtu83RMCAETNmFpWIxY9vxzClz89E1AXFJGb8vjhRrTeUWBG5Tjr9sezLt2pH6pBTAiE2/YByYV7ITEBlWcNRIljMNYmPrG08tU2V92MdXKMid+YRZVMIdlsR0hgM+UWwUvKEUMMXHI6e2Enja2zpqBVpzV3rc0xPxB08n6H9+3HrgUvKgQTStISvwSHPJ2EhuRKv47X20fKV/XoVvND7vfzKTF/bRt3n5x7RqU3+uQTJjCFjhaJ0gYIdOpqw3ilgxUBsAI/jCOmawguUScTL90opShERLc0+PTdN2EiOPH1JQfLo3eUSC6uXzBzljGI2CpluIfpJV9tk/VfSl7z+dbayQPBxbIdb4MEUYP12rvW3eaAPhWTtuVeLyeEGqEeQ4g9uNF/yYMyBSy8ZHGun3Oa111pFATjAz3Z3csrYtpefeBcnjEvjS5q0oU7p9TuWaQEpG3xxqF+N2tXizR9PqUGKZpm9X7yWkvYdZDJ/ijLARIPIosB9yxhurIgE8bU9lPUnCeUFpzQLWZOEydtJuHgJ6dO7UZnKmT4OeoTRbozRQdf8q0flxWzKsYCvCCW0CgdN0xVlPy1FVvR2BKj21UZ1t9L44zLcpDu0aUaUvRVq454LpQ6cuqR8SX2Gdj9R+lBAjKRP7/q4auoO67SrCw5ZuwZlhFXZFVPaIaqDekN39UjhnuZ7F0WdxqILXJglBYPfwOP79oYbold1L8VkEQmTwtX7Iu4MqqI2sKfFaIXRYP3pL6dA6GwIgMw0OzNbfEfQ65hDi96cGidzPR2zn68atBiIZdetHLv3EeffgEiLxBPsh2kbPMTYufPXVCDDJ73ZJblE74dYYvDR20tt5XSsh2sCkoYNl4tWe7zREGgbFnmcHQ64xyWEF4XD/w4ArFmktUfTwg1YVsjp0KL3Gvo95niW7aUzzCrEY6y863EYHEUHlyvKRfRTwE+4
 vtXsByGc
 q4iOkAamRCsj/1MJJjulumDb+RWEUh3AIu47/0G1PGJeEqNWKIdrlG4sFdNm2LmUOdcSOZbi5zOINRL/ohaUJxAG3OxLsCxqhgbeR/IfC5uDq2F7Zy2lZrwDUpuFnNG3Mx/w3Xe/CsocfGmmbX2m0CtYvC0GK9JGcjjxZlqhvTQunZCvCvsgbSnkuy01rRlEzMfONlG9ZmBT9Azm/GbZ/H4ITTK7dwZBZF2mRtPn8SUej1R1Zy7VG7VsCSsAt66rQFQTNW3oPKXF7H3Tb+WWPKQvqWa7KCx6yaNyjH8bEAA8Gx/5SLTlEpGEiLsLWf+d8xckNXn2dPaku0ZbDOh5TZpEkUoy0dCQAVeKoQ0UIicQCZmR1kQr6B8nPz9XhgOyqZKapOffubS1ItYBRuvDrMo6pm4H7P8Wrs8VSBSMSIDDCc+Vpuci8HKiuCqOaOxibdKL/A8ZPsyBabXR5NbiLtxMqZ+jTxsLQeq4lfRsjnqTncfDOtOBkfjRaCvRRqBl5POQfdpv1PquIniIiF26BzjzzaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 9:11=E2=80=AFAM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> bot+bpf-ci@kernel.org writes:
>
> > ```
> > commit ec8e2e1769704b4f69261f36e6aaf035d47c5f0f
> > Author: Roman Gushchin <roman.gushchin@linux.dev>
> >
> > mm: introduce BPF kfuncs to deal with memcg pointers
> >
> > This commit introduces two new BPF kfuncs for converting css pointers
> > to memcg pointers with proper reference counting: bpf_get_mem_cgroup()
> > and bpf_put_mem_cgroup().
> >
> >> diff --git a/mm/Makefile b/mm/Makefile
> >> index 051e88c69..2d8f9beb3 100644
> >> --- a/mm/Makefile
> >> +++ b/mm/Makefile
> >> @@ -107,6 +107,7 @@ obj-$(CONFIG_MEMCG) +=3D swap_cgroup.o
> >>  endif
> >>  ifdef CONFIG_BPF_SYSCALL
> >>  obj-y +=3D bpf_oom.o
> >> +obj-$(CONFIG_MEMCG) +=3D bpf_memcontrol.o
> >>  endif
> >>  obj-$(CONFIG_CGROUP_HUGETLB) +=3D hugetlb_cgroup.o
> >>  obj-$(CONFIG_GUP_TEST) +=3D gup_test.o
> >> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> >> new file mode 100644
> >> index 000000000..1e4609774
> >> --- /dev/null
> >> +++ b/mm/bpf_memcontrol.c
> >> @@ -0,0 +1,88 @@
> >> +// SPDX-License-Identifier: GPL-2.0-or-later
> >> +/*
> >> + * Memory Controller-related BPF kfuncs and auxiliary code
> >> + *
> >> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> >> + */
> >> +
> >> +#include <linux/memcontrol.h>
> >> +#include <linux/bpf.h>
> >> +
> >> +__bpf_kfunc_start_defs();
> >> +
> >> +/**
> >> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> >> + * @css: pointer to the css structure
> >> + *
> >> + * Returns a pointer to a mem_cgroup structure after bumping
> >> + * the corresponding css's reference counter.
> >> + *
> >> + * It's fine to pass a css which belongs to any cgroup controller,
> >> + * e.g. unified hierarchy's main css.
> >> + *
> >> + * Implements KF_ACQUIRE semantics.
> >> + */
> >> +__bpf_kfunc struct mem_cgroup *
> >> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
> >> +{
> >> +    struct mem_cgroup *memcg =3D NULL;
> >> +    bool rcu_unlock =3D false;
> >> +
> >> +    if (!root_mem_cgroup)
> >> +            return NULL;
> >> +
> >> +    if (root_mem_cgroup->css.ss !=3D css->ss) {
> >                                             ^^^^^^^
> >
> > Can this dereference a NULL css pointer?  The function checks css for
> > NULL at line 42 with "if (css && css_tryget(css))", which suggests css
> > can be NULL.  If a BPF program calls this function with a NULL css,
> > wouldn't it crash here before reaching that check?
>
> Here css passed as an argument to bpf_get_mem_cgroup() can't be NULL,
> because the BPF verifier guarantees that it's a valid css pointer.
>
> However the result of rcu_dereference_raw(cgroup->subsys[ssid]) can be
> NULL, this is why the "if (css && css_tryget(css))" check is required
> down below.

Yeah. Not sure how feasible it is to teach AI about KF_RCU semantics.

