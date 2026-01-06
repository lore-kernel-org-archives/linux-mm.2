Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54856CE9D47
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94AA66B009B; Tue,  6 Jan 2026 10:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F1E6B009D; Tue,  6 Jan 2026 10:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84AE66B009E; Tue,  6 Jan 2026 10:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70F706B009B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:14:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48FDB1AE47
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:14:04 +0000 (UTC)
X-FDA: 84301884408.07.35EB8BB
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	by imf29.hostedemail.com (Postfix) with ESMTP id 47CEA120012
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:14:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ry/DxSja";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of memxor@gmail.com designates 209.85.221.66 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767712442; a=rsa-sha256;
	cv=none;
	b=tEHyDfeMMp4Y6lkVhKAjcX5Y2qpotD+TUdGIdJcxnHNvCdGb5nm12yryETqY+4Z6MN/sL9
	S+oLAv6fijRDCYVb8pyKxmulOlckDOCUf7Ev1rVA1xTpVogr6mbgtXvrZaZGLaEGLF9gyo
	tU3/teH/zXZIw8Bd/4e9MhF+DJiiIX0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ry/DxSja";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of memxor@gmail.com designates 209.85.221.66 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767712442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCh39lELCZD3ykKYeblQxs0BjY8Mv990pLsUcyMALY0=;
	b=GL6RbIkJjgs7F3yz4SqKzgw8SvV7FcGVXgOVxhKX3LmMRZqCS4fobk8+DQe+wd7POyaXXy
	eBAu47PS5AWIeipXO4FR3twMKvtLfH5F+SPw7+tXhuH+3SuvK1ZO10o6e6t95LkYaaaxZM
	Z2Q/CkM2FVLpfiIy0hX6+1Ta7v4kw80=
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so630493f8f.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 07:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767712441; x=1768317241; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCh39lELCZD3ykKYeblQxs0BjY8Mv990pLsUcyMALY0=;
        b=Ry/DxSjaG/YJukr24Ipd+o4Hm0++MsYAIysVNPqDbdHCAcgySmGEhzBVo45hEbypmC
         YDJDBhTaUkqdrutmXMvgIYy5AMWE8lKfS/iFDsc6aGYKt+ZEtsvWFZuKNRUELUteHSTw
         PmFMeG6VkuJzMcQKX5Kr2O74rcVff/DbQgNfuJkaKnFJMHYe5RSxKDMjDBPxcAEuSxmj
         XnC1+HXUhK3O2m/GsAC4mfEExCQiFW0LECnZWa8h3kDaURJI70wP6wlO+mrdRX+Cutz/
         m0g0CqIu09jPFoyPLW0QwtX82U/+K8HpdDLPDNc+s5iawaoDmZlba5CxrWzNeXZhrmwA
         LvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767712441; x=1768317241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uCh39lELCZD3ykKYeblQxs0BjY8Mv990pLsUcyMALY0=;
        b=LadG3HkM6fwcEgXhtCvL88ujU/LJ8sbBAeBABXDEXvcmVlc5LCH2W+mD0BM1DG118n
         5RNpBfXz6lhrC4DbB2EqQzVtJrlDyHeSdPUhnhWMysZvIOfENdE+REy+J2uwQdxIjYB6
         LZhzO+LgFlqn8AuDpqaT+KMTJzLvQqcwSbsVnciJ9YeMAb+8oiASdsvpYTYvo6c2tVED
         Sik4Kswc47nhmr6FM87lOq6obpONgmY3SI6PAroG1dCQNd5rg8UPDacgRHVT6lKei1Ri
         MWiUzU1mhyUBSsPUhnHH3Ms3aYXWmUEzFrPfzsFCDppnMrLusK85uwZ8Eg6VzYa3k9WI
         kpOw==
X-Forwarded-Encrypted: i=1; AJvYcCUZq6ttpstdJRPVE0Wk+RXifSOBWNE/RbYt+l2++mylM+qCevR5oSkve17x9k5fdKnK8ade5URZSw==@kvack.org
X-Gm-Message-State: AOJu0YxkwKqR/7GgQwW9PV0pvtjvkzslz6TfZoCEnB4L8Rvq2jnGramm
	BW7JE4PDeqPs6cjhoPf86cRfXz95atck8FRZxsLYOgiLHiVyDfRgYn4TpWpJFCl81oGqTER3LCA
	5IyYxUN1T1/Mq/FApMzAthlQcMZmoHKU=
X-Gm-Gg: AY/fxX5jLWxh2iKc8PcVktTo7dNrq6goWbMIViTyVHlqAYRSSmoLWu0kGdMUv/qXYGx
	8v6GF7/60Gql/TrKaDgc5PKLS3LHPH82DZkxJbgpuevaf3AXVc0AiFvvZ0XZoW9q5pBB5mncKcZ
	VnwiTvt+wrDTNStR6TPmtS+FlHh6ZEXeh13wx6XVuXvrp/Zh8ozxu10y54dVU7Nt2LSGaP40160
	MCwuZqG2Rs9G1OgRzOc3uGh5uUpkRyFMoief3Qb7Vpg5RmbObCtuFQ0wF515vvRs0BuYoCFckkz
	JNqROKEDtNdYZL0+6+MMPD2eCCXl
X-Google-Smtp-Source: AGHT+IEuDSk+uHO37kfw+1KlRWo86Tj0U4wD3OG+qF+cUYxLCnvs8i0ykjdYVfeOvoUjITKDQXbaPZgs6cojh2n4umM=
X-Received: by 2002:a05:6000:240c:b0:431:7a0:dbc3 with SMTP id
 ffacd0b85a97d-432bc9efea0mr4747718f8f.29.1767712440581; Tue, 06 Jan 2026
 07:14:00 -0800 (PST)
MIME-Version: 1.0
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <20251223044156.208250-4-roman.gushchin@linux.dev> <aVQ1zvBE9csQYffT@google.com>
 <7ia4ms2zwuqb.fsf@castle.c.googlers.com> <aVTTxjwgNgWMF-9Q@google.com>
 <CAADnVQLNiMTG5=BCMHQZcPC-+=owFvRW+DDNdSKFdF8RPHGrqQ@mail.gmail.com>
 <aVts9hQyy-yAjlIK@google.com> <CAADnVQJr0WqmqA2fQeC0=Jn5F-ujWmUkL-GfT6Jbv8jiQwCAMw@mail.gmail.com>
 <aVwnUUXmgE1uOOj4@google.com>
In-Reply-To: <aVwnUUXmgE1uOOj4@google.com>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Tue, 6 Jan 2026 16:13:24 +0100
X-Gm-Features: AQt7F2rALTpWBryWGjQiLYrXRReZq_KM9PVniA_IEDb7aQ0ryO8-rDy8cUAcUVE
Message-ID: <CAP01T75ATFb_gjy5_fSwt6=QMxt7kGSS+12SJN9rz9SfJQ7Qyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 47CEA120012
X-Stat-Signature: 3qw1cifi8h7y6rn7en7skzyoereuonfm
X-Rspam-User: 
X-HE-Tag: 1767712442-626825
X-HE-Meta: U2FsdGVkX1/touucJO1FmReJWxpyzMfuLfQnfT5OKVVbYkb4+RtIAGn6ODDYr0cbhLU1ZvIshdfyy8uiPdnPmoKbNeuH9WFxs1IGM6MAulN9jnh1/Vckg3LDWZKiSEo9K5bNClUxm3U7xQmPFJyZzxBqS7B8R0uCSLTuOrsVtxy6pSj3y55fR9/pa43FN0jmm/RKBtfj/EAU1dL2fYBxa6uSnYcioT2RuRxtWj8ksjwyNfgdQHjgh21EwK/aAG58Ao3+oNZAm8QqaVJgeIhe10ek3tVVJ/trj2uxMGjtw0vfZKeQY6ewBNnl0LRDshMHRFXtV2H3rVitzeI+OUlLQtsQutBRs6vqPHBra8ES924PFBEKq7GjjPzJFYxFgaGOqEyq45fbFHlcwKhZzoYokgX9LtLN5PmcpbAGTOOthuspZXbGDiOt/lruWkbhkPn7Ma0WUBdAkGjtzlkkhSqFvP17sW4sagUJ3IS88DAgY7HoWqrvV/NIbBXGJl6Kt9qSWCNB9UMAUx8KATSvQoiFMbAR8bqvbcA0CQhYkIOqJgNgMEd0DBfuJJJ65cUqATV79nKz3L86BUhXKW6uvewHHhJvoIjXc4ixi6gesSKFzoWV9+8WyZHEliWD6kjKiIXEEBsoSksnx/m/x71t6kmBK2UwXHDV5hQHp1PlYZWp6ev7ExVGTQl7Ja4gtubJfW9mXl1fjhH8kS/0bj84yUD6zLUl0LsN8LCoaarOxRK+3fhJHqxPHuRAP8yV/aJqM39Sx/fqjhrbpSW0CcvX7RTm4Q0ixDLiKOkkOKyZg6NMtgEazv6bs1yGYu/VUOkId0BQ8Q3CS+vViMA7ZPoAkYEIV6t+QM3uXZpgqZihb63LSKH7TVmoppuMoQLDwBXJdbT40bF/Bpfjshvq0+n1y/eIkEPAJx0hqLLVPcMQFyArarb7CYtUthwrIYg4S05GWbrDOLEtoh9kaQEMpc/c6K8
 zjLhYQ6j
 Od7A5jSbXzOneL30Qv1LvdVuyww1B++Xn+RJ5o5QcOmvFBFleayqJE19YdX+lkxsXcXuK4M6ixRUhbSHH3+Q5/SgU6VI0MYY515rxDI0RR1mU8OKGxrLMI0g23rjDq/UBUorw4LKd2figlRv2JEWBDkJ+g+5p5Cei7fkrU1bbe/5JWNrdx1nVdwDh/1A4Q/ORh+7kxaVkWuIC7Suxd+jfI6+sL/RHB7TwMKHm0xFbCY1EdEkVmLvJ2jlx5jn8w2jxpiy6b/xJbLo+IFB/+BGSfy+AH8g+XzmHPskrJtNrxxEdQ9NuCCOpIPrFsBjv7G5Kz+2o1hQ0Nw0WhBPSgtx6UAd2GMgdwFL/fkkBv2tnL3humOnJABjETls4umWXGsMh0Z+eDmL0F8Lt+roB1hLhJQQS9kFt+uj716/AtyBMAA+VFsTb1PIMrv5vGIFpaYs/0doZueA12rn8fF7qc1m58zuuoFJd3zyxFHHuz4zBPlHkG3xtnPTQDp/hFGvCINLVCIQ1gmWj+FeI+W96DjAvkhZFmOHnMmk6L+BdyXscm4R3FQJmdzN2YUOPT0a4ppBp3PrnkceVg2Ui7vw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 5 Jan 2026 at 22:04, Matt Bobrowski <mattbobrowski@google.com> wrot=
e:
>
> On Mon, Jan 05, 2026 at 08:05:54AM -0800, Alexei Starovoitov wrote:
> > On Sun, Jan 4, 2026 at 11:49=E2=80=AFPM Matt Bobrowski <mattbobrowski@g=
oogle.com> wrote:
> > >
> > > >
> > > > No need for a new KF flag. Any struct returned by kfunc should be
> > > > trusted or trusted_or_null if KF_RET_NULL was specified.
> > > > I don't remember off the top of my head, but this behavior
> > > > is already implemented or we discussed making it this way.
> > >
> > > Hm, I do not see any evidence of this kind of semantic currently
> > > implemented, so perhaps it was only discussed at some point. Would yo=
u
> > > like me to put forward a patch that introduces this kind of implicit
> > > trust semantic for BPF kfuncs returning pointer to struct types?
> >
> > Hmm. What about these:
> > BTF_ID_FLAGS(func, scx_bpf_cpu_rq)
> > BTF_ID_FLAGS(func, scx_bpf_locked_rq, KF_RET_NULL)
> > BTF_ID_FLAGS(func, scx_bpf_cpu_curr, KF_RET_NULL | KF_RCU_PROTECTED)
> >
> > I thought they're returning a trusted pointer without acquiring it.
> > iirc the last one returns trusted in RCU CS,
> > but the first two return just a legacy ptr_to_btf_id ?
> > This is something to fix asap then.
>
> No, AFAIU they do not. These simply return a regular pointer to BTF ID
> (PTR_TO_BTF_ID), rather than a formally "trusted" pointer (which would
> carry the PTR_TRUSTED flag or a ref_obj_id). scx_bpf_cpu_curr returns
> a MEM_RCU pointer (via KF_RCU_PROTECTED), which is somewhat considered
> to be trusted within a RCU read-side critical section *ONLY*.
>
> Kumar/Tejun,

Yeah, they don't return a trusted pointer. I think it would make sense
to change the behavior here by default.
A non-trusted pointer cannot be passed to kfuncs taking trusted
arguments, so hopefully it will only make things more permissive and
doesn't break anything.

>
> Please keep me honest here.

