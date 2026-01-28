Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B76D46BEE
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 18:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0916B0089; Wed, 28 Jan 2026 13:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DFC6B008A; Wed, 28 Jan 2026 13:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176396B008C; Wed, 28 Jan 2026 13:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09E616B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:54:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BF07BA44E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:54:05 +0000 (UTC)
X-FDA: 84382272450.04.CD8A9D6
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C3234000E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:54:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kqI1ZbTL;
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769626443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDXvP5WKDhQN8oAnNb90witoZNuPCkybcm+/Z1oKNmM=;
	b=Sv9LND9kVpwgRmJANt6hPvWjPZy646s7AmgMFiaSsW0/SthPqeKk8wxSgBYaXX2W5OZreh
	S1h+r90N5mZa0SPwA6zdtcByzv+ovYGzuHQ54CSpN63UDj6pTP+9mYmCnG24q74mS43+up
	k0KadE+XowYObUqJwMVDIeFRtEL40VU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kqI1ZbTL;
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769626443; a=rsa-sha256;
	cv=pass;
	b=hc9K1L2CrRR/X1LcoL7eQjxXjaLVd0hnsWjZmdWKv3v5kBnVOuHQ2/aGCL9luCfg6xMcjC
	HUcF89OHcdpWF1RNk8wrm0DjAnYJtvEFVz9ZC/qxwB3WDis4sMyeF+ls58uBWDuh5JXyEX
	8o09mLK23VgT4jQtt8urizWqzlH79ZQ=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42fbc305882so161460f8f.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 10:54:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769626442; cv=none;
        d=google.com; s=arc-20240605;
        b=RtihbGoX5rhczZWRojN9nUgkrHFKL2319lUbja575VZMVsESUJPgjzQ+VdF73hRtbg
         SK/tHIp0Ghi6j2Jkj8ewfBwZFlaTRqqG38QZmcbJLp97LI2onTaM0dilE1mtQRrvYr2z
         QDKeakw6Ak+rtLWWu9NrTYK/vjb+n7pghy2k/uHIQq8uvV2DwBbAUzlaz9J1G0iAHAgu
         Vezr0m0q6zUepMfRDIahAXn38IgEjJ3s0lVnj34IxqWVaULC5nUubgJgsG33GDYmBFU8
         e418vIyrtLisFbdJR1YsROJ/ggMPbydqCpr5mmfxYlLBUmAm309pc9s/YDX1rWqV+G3Z
         9RoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LDXvP5WKDhQN8oAnNb90witoZNuPCkybcm+/Z1oKNmM=;
        fh=e4t4RUCrrJWbJWOouqPLegAhxbiOc0kThvAvQVKSyDI=;
        b=YaPBg8nsULute2N1yRaOwzig7H1JuKx/Cvq3CbokH/skrRQmrsMH3a74f4kLVw5e/P
         UUT777YWuh40eVgbXnQ5GyQtvTsGJYASn0Emaelq+t6hMLo+MEkiQiSYWupN+/mM7GRS
         kxYFzoDHBUwUHiJWFRmLoIasJ+oAoaISZl/hGQ6Mz6D2D7VKzp2LDaUt+Lqo652B0474
         SsEONppjp1ae32dH8xODghT1uggT9xHIG4Mm31wx83OA/DXioLU7VhMu/2LE5YD9RBOd
         Ekfq632l6T2YyY78q+VY4+9qOxV8K0ASamUcRFqbX2kdwQPn1uF3mmJxXZ8GqpXoSxOc
         8xnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769626442; x=1770231242; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LDXvP5WKDhQN8oAnNb90witoZNuPCkybcm+/Z1oKNmM=;
        b=kqI1ZbTLm0rAH4VaJ+TuC379SuSXOj4JLx80+A4QvaBYJTtaoqDDrcBT2gXKarJ18m
         xPeeTfMqKCQXFpoTDrRba9Ozmtnmwfn3oeVHj3hVeCJ9scu7yuLOvtqSHWFMOW7Ibv4J
         S1BsF1DBl+mry0l0SwmRnXGyZXvRYFGwhrCV8QMHdlemqqhYiUIvz1uimDivhb5b04ht
         zfOpURyGfC5V2aoWQFr6Z4ZZ72fBEfLeJrv15S/kSxNsrNGEC/HWEIX6aETAaE0FyFXu
         v/eFWWZbf5p5+bkBet2Fp1BWi03vIcukMSZFIA+vf88pZp9RqJ43rgAacAi/Nozhd8fq
         eoGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769626442; x=1770231242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LDXvP5WKDhQN8oAnNb90witoZNuPCkybcm+/Z1oKNmM=;
        b=QQRi4rdQNOE/onukScCNPZnG79nYODJXz7gIHS7RcnU/dxEreH7pWG4Og/S1CaKiW4
         rrK9lXhS4F+M5FajkzytLN+drEtpSeqxkccOq3wLqIsM1S75HR4hxddqLewDPsdvMQsN
         PJUJFGyC+7VN5hbiQwc9M3fy+jvQV8vXIc7MgA9sqOlUkufc2noJ5njN180V8pzlI9IT
         D107BJlNMsh7tUCXljUw+7gPQi8Ge9S2nppLDQ/l4dcEQEvGRGrC3hd5ldhTV6lxV8RI
         nNdUBRb2nH3Cykujx7uRLBY4QWznmeFIC3tER6BFKJW+LJ8q6LomPhuEgtL5T3JmH9Av
         PDeg==
X-Forwarded-Encrypted: i=1; AJvYcCWTZ0DtqRjh0bPGFhZhWLlMc94+9eLhTozM+P2i2FlwGJTMnyrVrRneIaCTNInd5usY0nIQwG0NoA==@kvack.org
X-Gm-Message-State: AOJu0Yy+nkmxa00nUjtxQYpwmdqvjyCbniRpkp9TGM/r/A2VciIgLP0Y
	bbImwTHZ/LEtjVQVswxv1i3pqXzGFirV9EoLm9Y8rYpHmqYTdML76Ji9NV86wzBTemT3Q1VRKsg
	dE3eeCnRBgYGiuvtxGH9Xzox9I+IwX4I=
X-Gm-Gg: AZuq6aK6n0xVWRLpgfNg0T2/RwFL9ZflQ9vf0CxVjwYM+t902OFv7Dwq3xJW4ghjSli
	dK3OEz0kE+E9mrtTSGwpd9r27B8vw8+aGATRb9CH+WKCK93OfJicNMxQdINJuIfnhHwG6jNnMQu
	A9R6UpGeM6IcxjixRg1qVcHTKa//JVuRH7/K3z5P5QUorOjff4KqozHrzULc+I9xLq+I8F2F0cD
	jTyAik26M9KMR3lQH/8LDyn174+MzCt6GTqK0lNjsfpIUKIFrbyijTBxaWVhPAGECHFEGSNZ4Dn
	oboGhbi6I+7RQL/jSyaJB3R1SJF3sti6EoL8VcVGmqNqxHSt13480ilhG6upchhGe5+q4fFQF7K
	mmtzbwYekUny2Xg==
X-Received: by 2002:a05:6000:4023:b0:431:a33:d87c with SMTP id
 ffacd0b85a97d-435dd02da7dmr9821021f8f.11.1769626441887; Wed, 28 Jan 2026
 10:54:01 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <aXh_LpTzDhvv20uB@tiehlicka> <7ia44io6kbwj.fsf@castle.c.googlers.com>
 <aXnDdkYmtipGwSjK@tiehlicka> <CAADnVQ+ghTc5FtJCjm4ya3y3xVpSuJe-7ctdT-thowqWguc1pA@mail.gmail.com>
 <87zf5x1tqx.fsf@linux.dev>
In-Reply-To: <87zf5x1tqx.fsf@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 28 Jan 2026 10:53:50 -0800
X-Gm-Features: AZwV_Qht682-qa0CwwhMy_omOTG7GEYdXbcd_NxkHoacsbR6UpkvnSNThpQfUGk
Message-ID: <CAADnVQ+vQFndDdgDBwLSRcdqrsyE_gU1Wx7STy0Qa=6MFnHSHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, bpf <bpf@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C3234000E
X-Stat-Signature: b9ze3murj1s9na7mh4xttewuobrdbq4u
X-Rspam-User: 
X-HE-Tag: 1769626443-355817
X-HE-Meta: U2FsdGVkX1+P5hXwNmgiDg+IZI281G7+ATRoI1YYbP7Xue7wKYjuxJ8mcCcLmkiTVvqdB7OUDnCecZxW0IUJDaRJS4pCPozHGOdcMvrI/bjBysO9xE8S5dWchh2j3tvtVzXtIRgH7JHdMBytLd8518jBKnI/sAU2oH5o2DXUhtUz3Ioz0/fUes079WD5ttWhwac56nY1n9hpmNhZGsXuUhGelZKFlKVWBvoDLX1zO4xFWJ+0Fs7p5sDHLsj6IalYKC3kQW4HB+L3zNqONxbj6Twc8ALRMqbjivhycaheJkYFI/U5V6Gpu4K0L/l/os1aaUQhQTEG+WhkRk+cpFyGhAHwuFUs/QjOl852wDN2CS6VCurGVeQIhGyewT6rn/dcbkLgkCmw0L1YoR8uLTdr4CXZPoQQd0Ur1SQttPV4KsbA+PeW3HDrjNqElUy4AEjhla0bBF9bHMq/K3mS3qr2dsDwGDZDnTXEHoQQFJ0IUN1OpAq+jORYHZYoFS6wYCI4u8Z2TqjgB03Cjzcmi4EnxCvGXOXOhXqRmn+tJ2AzTQR5Fde3BLWFIos84dG8fVp1CVBzLnrf1OT/AW+wlBq/z9BdlTr0Gnq5fZN9yjJmN/eG+h4A9Iv/+DLR05bKZA7+1SlM5/S/KSwj8A0yylxu3HIrcjB7KFpaZVqJAf3NpOaAqUGGkYJRy+19LGmIfiz2NJp4NRE2RWtCZEnctUlh32H1t7ktAGqyQa82l6Ox83m+mxs0+AAGzBdUdl/TrIv2Qk0zr1oU9X8RzBXTnPzYbkmH5BEowQwBWHAf11ck6KO0rYW3bVNTCqXLwbfWgBdZMjCZsOQ9SbMlAhi4RyJ3KfyOXiTeVuRBMvjm8/YXKRWV822xGMzDzRbTqs1VikfZ4djRrGwJRdnoLGiN98NO59NcERH7dpL2v+S/qHUDresnK+hfAEhN39otFEBuJ8EZnEMkNzF9R4gmoOJHOcj
 egQM+Ti8
 NN1gv+w92s7JTPG/3K8IGq10XVPhPWKM54xU2vjtYn2P1stYHfqUACdzr3wblCZjn2Qq0i/WPL77QQUCwpisEE7QUpdcEO3RMXm+5cAg+cywmWBUzw72oeLvTVfKLLnGsC6/91YDNL7YYuBY2vFKubEbR+3oHt4kOgapkTd7rid0A1CpxL9umLrogs1MgZb9DbIiGiJYLDrBheXWjuZxsOGWPOV+QWABaPUrUN8ooAjupLiSxgtijrQGht2WvrciJgUTjzYCmKqaAUL2gppvyBvQs1+Emf0OxPMwbvKr51X5LOTkkRIMIUsBZiWrBFCjMJVFwar8JIF7ORsYhwzonoFeKC795jRaDxcArSsTgCHJq52Zww2LFfi7ehmg3X+Zy7/lUVxeApRCvyWrD2qJB3W1kvBrWgbu1y67e0l+NAT4/pirjYMi/9R+yF+xI/TC3z2fA8eHs66tv4maKIuD4jgiSbGiW4MyyY792NPMXM6CtAELaFcE6NgfZGOxLFV5P7ARRgwCSNif9TMWsmlpS5ek3bxE1b12SPWRTij90NVYkZGMSFQw75qpIjuSJwvegf54qFq8jAUOGDluPBLS/+9XUj8Gyl0otK+cW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 10:23=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Wed, Jan 28, 2026 at 12:06=E2=80=AFAM Michal Hocko <mhocko@suse.com>=
 wrote:
> >>
> >>
> >> > Another viable idea (also suggested by Andrew Morton) is to develop
> >> > a production ready memcg-aware OOM killer in BPF, put the source cod=
e
> >> > into the kernel tree and make it loadable by default (obviously unde=
r a
> >> > config option). Myself or one of my colleagues will try to explore i=
t a
> >> > bit later: the tricky part is this by-default loading because there =
are
> >> > no existing precedents.
> >>
> >> It certainly makes sense to have trusted implementation of a commonly
> >> requested oom policy that we couldn't implement due to specific nature
> >> that doesn't really apply to many users. And have that in the tree. I =
am
> >> not thrilled about auto-loading because this could be easily done by a
> >> simple tooling.
> >
> > Production ready bpf-oom program(s) must be part of this set.
> > We've seen enough attempts to add bpf st_ops in various parts of
> > the kernel without providing realistic bpf progs that will drive
> > those hooks. It's great to have flexibility and people need
> > to have a freedom to develop their own bpf-oom policy, but
> > the author of the patch set who's advocating for the new
> > bpf hooks must provide their real production progs and
> > share their real use case with the community.
> > It's not cool to hide it.
>
> In my case it's not about hiding, it's a chicken and egg problem:
> the upstream first model contradicts with the idea to include the
> production results into the patchset. In other words, I want to settle
> down the interface before shipping something to prod.
>
> I guess the compromise here is to initially include a bpf oom policy
> inspired by what systemd-oomd does and what is proven to work for a
> broad range of users.

Works for me.

> Policies suited for large datacenters can be
> added later, but also their generic usefulness might be limited by the
> need of proprietary userspace orchestration engines.

Agree. That's the flexibility part that makes the whole thing worth
while and the reason to do such oom policy as bpf progs.
But something tangible and useful needs to be there from day one.
systmed-oomd-like sounds very reasonable.

