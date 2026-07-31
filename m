Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17356C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2EC6B0093; Fri, 31 Jul 2026 17:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72CE6B0095; Fri, 31 Jul 2026 17:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C616B6B0096; Fri, 31 Jul 2026 17:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 902FE6B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:04:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DB2C16016D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:04:54 +0000 (UTC)
X-FDA: 85050301308.30.E661E07
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 823A910000D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:04:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BCf/rl6l";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785531892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qt9ysx8SfVcueZxcnttWU4wU64aDvSDiI5Kf02EpkLY=;
	b=qTTK4O1XhlPz3suN1ompj4XMKONZrdyjuDdAMk1FRewOp1RTyheO2HTGtXTWcH7M1L3Ziz
	inD672tN/UvzJqIAjEFxcu/9yB9SlKrs1G5RgD7zJ792sV2gqEcwzo3IqmIPhSw9b4gfTP
	2oc+sebF5fNlsVrEk6bmawT+V3BmWsw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BCf/rl6l";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785531892;
	b=ljG4SU/2CaE/DaLjaP2hoB5PWy3AmLsxU+mzMu7xUTkuNQp9X+B/nrPQlWBKhYSPiQOV4s
	bnPtkju99uKUFbZg9VZqZpSYojLyGDjr270xLLLY6s/i0ID8ArnbZwNtxWXRCHsFbFB/SA
	RS2+AcmTwlc1IDwUq//Xm7zUq8syQQ4=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c10ed63c0so15701cf.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:04:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785531892; cv=none;
        d=google.com; s=arc-20260327;
        b=Tm4zQXoA3GjNIJFQrdOjkP90NipRhS1KgKpgHKMXMj+bDOxAJzscrUgcuZUYHPjNgN
         vo8/o1rFY8E2G1S1JEobNYU9DIAAChR75Lu72wg/YCSRNRFeYtBIR4AgXB+139t/fl6T
         8MM5cmwdyPRz3YFn8LL+9u5C2mn8FpO+uxHt4NnEZUMgRTKtD8Ow7OUCEbTxyZ51p52p
         cuR8m8WO77l28/YWqShi/3eaNmchAIoFIiEDBHepYUrjXdvu0v3zwnM55myrkpGlWgYV
         /OhZ5Tj12mH5/LPTL8P9wv1ll9DZ8z58hqSuIc4aFfEZhh1c9bpnlULBL51L5yu/ZX8C
         3WVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qt9ysx8SfVcueZxcnttWU4wU64aDvSDiI5Kf02EpkLY=;
        fh=ayPyq4q9YDXyP/9NzacVjaBv6SfAJ0gw14QcR2MDRSU=;
        b=Wx+pxDK2ZHkvPG6n1YbVefHnmOMYQFIf/miaOjx9vWDIvGjPZE4ocpwRMLrBum2kta
         07uOmSq+F0ryA2mPA+tvQ2zZHYwBMMj3tAhLKtEE9fqQubSJgJptisTcq7NUiFR2jxJV
         UHfHQLnad0OZIVEIA9Ge4isY0WkzooRxk9LkFgkYO1kkg2Uf+cOsk3XdMoIa0XGsO9Og
         LtFoa3n4wLKbdO/ae3il5CXQTwsk7SJl4mXqlnUiOtu2QP0KuTWyZFSEvxRFRGQzPh2n
         WyXTQdcdrQXS8nE2OGauYaT+ci5iP3peRu3EETrdxsiFOfdVGB6/yQmLQnXc/jysYMEQ
         3u3A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785531892; x=1786136692; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qt9ysx8SfVcueZxcnttWU4wU64aDvSDiI5Kf02EpkLY=;
        b=BCf/rl6lIMcHkj1RdecQhNlC78jnCqM914xXGPiMzSJmzHSQ1mcMEOdBmNG7HrKwqn
         zRzbnNmBSmRU4Sf1GbnXjl99UgrC9GlzILjQSHqH6IRSL2/KxhssKg71bVByQUlxAwq/
         GvJRawuhhO55FKHFiFzfTI+FM8K2ahKarukt1iARYaVslSYn9ZmLUdVZgOMygEgbJGXi
         lMuwXj+IrXLO7vuaoZsxZKhvHfQxe4vdM2k4S2XPkm6HLmUa2/CaIEDG7JHtc8qyU3AC
         8Tcg94l6Us3gXwNv0BGRjYWJt0HDDG5I/ot6PIGOXq0RKtzjgEKbnqJGOIg8OzCOGJel
         LIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785531892; x=1786136692;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qt9ysx8SfVcueZxcnttWU4wU64aDvSDiI5Kf02EpkLY=;
        b=M3d3TR2+QSq2s8x6y6yfsRi2t6B0yMGXDiyijnGEdhl2sX70GhsUiz5xURc569UEUt
         9NgxOzCFS+JI3D/WWdO1eYfQv9hisDXam9mtATSJ7xn8jBeJaW4vej+W0gLEklG3KZZU
         CPz14aO53aAW8IgsZq5mbDxKkYICPGleCTeERSHngrVLki0cp6j+Su82eq5lNio4miOO
         89FM2jLFusvCBC4StgzpkoN1Wj2YbNmi43MUxxRXWzpJVDFXrn7ID8Q54KWeZP283ipr
         eKPKtQ8bylAK56UptEIzpB/76g9usmtypKG+bQgClyY+LK61kxIBohcYYK3EYiKGM0FT
         KxSg==
X-Forwarded-Encrypted: i=1; AHgh+Rr58OGJrP4MXk0hoxT7glFIXetLyvu0BLBonCFpJKirUVljcsIMMTrpjqcdk/nAupGOqI1sdF9IDQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2ulGC7OTz2M3xIT++TWMwrtdA9BFemwQJTgM4u/l16o8y7l/W
	r3BX9sgmesiaAZNLvULiZKLk8kbeTrLAFVH+c7073ZvOoFiXOtrO6Wt1QXPDrOIjNJ6BkBsMqzX
	sicwITLfjmel5BORkm71zEd8TAeHZX663Gi8DREi1DiMqZIVFH5i3ALCAALw=
X-Gm-Gg: AR+sD11Wq6gRgOPEoWVXpEbwCdq/fviRCCQEivH5P3Ull2cJgMCbaF3kSpOnyHqaAZB
	PdZXMYbZJ9E89wV/6gq+C9pgJyNiS/DifzgXhZhHZVlDpGhsjVlAqvvzAvLxXGaEYo1NYytft/0
	+wGUl5WvedtJ4bfedawHzbrk7CuqgWYVD53efZRYNTv7sPRm7/azMdsKbS1Dc+aY4HU2GuXPurH
	/nQ+ZO5GlGiPtiETWMixddfSKSnQ/d71PFRx+OICinByk+DZFoTK+7DwqcDewqdI7KpnWV+fM3+
	WTzJmVarzFx5NqDIXSMIU+8js18JeT8/XDUl0FrN/RXqQ6y8ri9s9B9klMVFN0QZpkSBNpb2
X-Received: by 2002:a05:622a:306:b0:51c:104c:100c with SMTP id
 d75a77b69052e-52b598d7977mr4758791cf.2.1785531890779; Fri, 31 Jul 2026
 14:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <0d84763f140ea735d790e0b30a8e954536beb875.1785455267.git.abhishekbapat@google.com>
 <0dcd8c2c-d841-47c2-997a-640d1937a77a@linux.dev> <CAL41Mv49qeLm-MmHtQGFnyzjEsE+8kvOgtMTKpjNAzDWozum2w@mail.gmail.com>
 <CAL41Mv46p9bFhX-UYpZ-jk9g+yQcwtMbcQHGnfwp8rQJzw_FEQ@mail.gmail.com>
In-Reply-To: <CAL41Mv46p9bFhX-UYpZ-jk9g+yQcwtMbcQHGnfwp8rQJzw_FEQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 31 Jul 2026 21:04:39 +0000
X-Gm-Features: AUfX_mxLRJChZ3ADKqExHn6g6N5GpoCqUhVC8wbXSMNAISDZ-q-SlAEYTxhf9FM
Message-ID: <CAJuCfpFCs_t4DZA=rdA_a4rL+kJ_tckjQM+9kHUZuLTK6w0WTA@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 823A910000D
X-Rspamd-Server: rspam01
X-Stat-Signature: sh6h8qhnaks9wmtfeniy7xc8zm7z6s43
X-HE-Tag: 1785531892-564712
X-HE-Meta: U2FsdGVkX19/Xh/JSMTofCO0NwIYaJtGyFveJp6gF5kGUq1U+rwlv6OAEYiTEYjEQnnOkrTLcU7Ry9MG/bYV46fXZLUuIwaBSh2OYt07QAZy4tRO0PSc6F8QaFm0z3WjUZ7yIEYM0xeZqDrbX6BZhybWzuX807cWgGwR/DkzNcax7Iz2eI5XQJq9ZPvLAgguR3K/Pxu8zfZvmO75fdKcUCiTZ3s0WyS5X5tZW6Hd/Anu5vRq7pJlgXJ2dRNWNi0MX4K0a+RDCpaKhpvEYLi5I0nenUpK7+n+RmuE9TUEyjAHhdpFqqLr0KeJBwzmPwy31jYXecCyipP6wmoVTMxnYIyySafrS57SrMVHzi1tEzLahdln3L0ED/H+GlCHU3JpL4Ad1dDx+viUt9MdNWR5xxbKeO6pSu8C7BbAMqgeOK8XFYaVo4k6fbM938HTt5wJN4QHbifzaxLnDsseqOgrM+vh5TiOrmmv8nMMzmYKXIwbtt1MVjxi5x/Tu7ZZrah3nQmpiHcNEKx93gU/SEMbKUrlmA6/U8D3Xl25SbvzYslIWAfF2R/yqOqMsdV0ZtvkMc5nxYhN9VYwNWzsxZjtppE1oogkTuzAZGXw8i6aGPpTtItIYgesdrhazD1KZBFUng8I4/8AAKSWpvZzhbTDyF4iAM6XERGl6rdOO8Jxl2Ri1/M6U5n0kjD/80eAGqA37zCKE0KfY9E56m3V697Fq3IjdcnFgV2X4QnhOueq2ecqnc/cWxOUV02WXKc431yNTWIW6Wt/G7S4xsJxj6/ONE4lxjUj6sB2e2VQfyOLsN7grtKIZH9teO4GjHnRwwKFa+6cMeSSFenNaBtpPEFABkh5xxatgsiBvD7SabpSkm9602R5oWRMcwo4o7hQVEER+g8RdlkLfeqejDoVovNu6bfP2JWCasv79N751yJ/uL0xBl0vVAG0mZU97SM7R3jEbtAI7qzhhWSBdPHbymX
 brjRZPSy
 EHk5G1Ol47L/dwF5e2zTHxB8goTjXPwWDqqYt1H0QAVintFKIH+KtwpsuLLIS3KSD5N94xT9pKZyu4vfc0bJDgHZ9Kp8JzsMngDo2Rseifc/j0S2of/0W7vN3TSO2N49ruJ0XT9/7MaDfvSsxIiCYoKHK0pOqtCiDp8MeMRIbVe9/K7VDrEj1sRtcc7muDIpfJd8z/TcG6iU2/xk6Be7fNnPY+tPDNQPCaax9e7HuZKeFYRHEB/aM2O86NuWICQ1skMehD/E7rBIw1i3UdC8c689NNyKQ+YE4i+Oo3LP8av2ThzsQ8q1QXnkN4wR7NNbrlOAMyxUrSEMI5+yHvEhxRDgT1K9qPneLGo/kQkWbfr6+48g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 6:37=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Fri, Jul 31, 2026 at 10:25=E2=80=AFAM Abhishek Bapat
> <abhishekbapat@google.com> wrote:
> >
> > Hi Hao,
> >
> > Thanks for reviewing the v2 patch.
> >
> > >
> > > Hi Abhishek
> > >
> > >
> > > Thanks for the v2 patch.
> > >
> > >
> > > On 2026/7/31 07:48, Abhishek Bapat wrote:
> > > > Currently, userspace has limited visibility into the exact active
> > > > runtime state of memory allocation profiling and its page extension
> > > > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
> > > >
> > > > While reading the sysctl provides basic on/off status, it is curren=
tly
> > > > impossible for userspace to natively determine whether page-tag
> > > > compression was successfully enabled without scraping dmesg boot lo=
gs.
> > > >
> > > > Resolve this ambiguity by exposing the active compression state by
> > > > adding a new read-only sysctl `vm.memprofiling_compressed` to outpu=
t the
> > > > state.
> > >
> > >
> > > I think this should be vm.mem_profiling_compressed.
> > >
> > > Otherwise, you will need to adjust the procname for this new sysctl
> > > accordingly.
> > >
> > > Also, kindly add docs at the linked path.
> > >
> > > https://elixir.bootlin.com/linux/v7.2-rc4/source/Documentation/mm/all=
ocation-profiling.rst#L33
> > >
> > >
> > Thanks for bringing this up, I didn't realize that I forgot the
> > underscore in the commit msg. I'll fix this in v3 and also add some
> > documentation about this.
> >
> > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > ---
> > > >   mm/alloc_tag.c | 6 ++++++
> > > >   1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > > index 52aece27b00e..877068241f06 100644
> > > > --- a/mm/alloc_tag.c
> > > > +++ b/mm/alloc_tag.c
> > > > @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocat=
ion_profiling_sysctls[] =3D {
> > > >               .mode           =3D 0644,
> > > >               .proc_handler   =3D proc_mem_profiling_handler,
> > > >       },
> > > > +     {
> > > > +             .procname       =3D "mem_profiling_compressed",
> > > > +             .data           =3D &mem_profiling_compressed,
> > > > +             .mode           =3D 0444,
> > > > +             .proc_handler   =3D proc_do_static_key,
> > > > +     },
> > > >   };
> > > >
> > >
> > >
> > > I think adding this sysctl alone won't be enough.
> > >
> > > If we set boot arg sysctl.vm.mem_profiling=3D1,compressed but profili=
ng
> > > gets disabled due to insufficient page flags,
> > >
> > > this sysctl will still report 1 (compression enabled) even though
> > > profiling was shut down.
> > >
> > > To verify this behavior, I have set up a test environment locally as
> > > shown below:
> > >
> > >
> > > [    0.265503] 4046 allocation tags cannot be references using 5
> > > available page flag bits. Memory allocation profiling is disabled!
> > >
> > > [root@localhost ~]# cat /proc/sys/vm/mem_profiling_compressed
> > > 1
> > > [root@localhost ~]#
> > >
> > >
> > > I'm unsure whether we should initialize this sysctl when profiling ge=
ts
> > > disabled at boot.
> > > If we do, we should set mem_profiling_compressed to false in
> > > shutdown_mem_profiling.
> >
> > I think the way it currently works is, compression can only be toggled
> > at boot time. The new sysctl my patch introduces is read-only. Based
> > on the current behaviour, if compression is enabled, and profiling is
> > toggled off and then on again, it will be toggled on with compression
> > enabled as long as we're in the same boot session. I don't want to
> > include changing this behaviour in the scope of this patch. I want to
> > limit the scope of this patch only to expose the current state to the
> > userspace, hope that makes sense.
> >
>
> I reread what you'd mentioned and believe I originally misunderstood
> your point. You rightly pointed out the subtle bug where the
> compression state is left desynchronized if compression was unable to
> be turned on due to lack of page_flag bits. I acknowledge your comment
> and will change this behaviour in the v3 patch to toggle the
> compression state to "false" if this happens. Thanks for bringing this
> up and I apologize for my previous misunderstanding.

Well, if profiling got disabled then it doesn't matter whether
compression was requested or not. The profiling is not active anyway,
right?
IMO if would be less confusing if we let mem_profiling_compressed
reflect what the system was configured to do. If that configuration
was impossible and profiling got disabled, the userspace can detect
that by reading mem_profiling sysctrl. As Hao mentioned, this should
be clearly documented in the docs.

>
> > >
> > >
> > > Thanks
> > >
> > > Best Regards
> > >
> > > Hao
> > >
> > >
> > > >   static void __init sysctl_init(void)
> > > >
> > > > base-commit: 2ed26e8a624f41887d64e2e37a2f6ab36a118d1f
> >
> > I'll also wait for Suren's comments before sending out a v3 patch.
> >
> > Thanks,
> > Abhishek.

