Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C94C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 05:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524C78E01BB; Wed, 13 Aug 2025 01:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459738E01B6; Wed, 13 Aug 2025 01:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350378E01BB; Wed, 13 Aug 2025 01:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5608E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:33:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9515757ABB
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:33:11 +0000 (UTC)
X-FDA: 83770615782.23.53ECF65
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE8561C0005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:33:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ixsbNBjC;
	spf=pass (imf20.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755063189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fd5Hzu0+89GoFhfPNDsRG3A11ZVeQEs8/UJ+qwaOXUU=;
	b=L+a0HNQXb7d6MUe8EKFLlGgOfc/RYEbiIpU3EjubnqDiknWTiFRiBcy0TkISbslIf09gSN
	wjVC4xn2MJ15rav6BAp2przRYDaTzyovxxG2eFU2s9hqhq7YCyNV0Dgn2LrCT6DJML808o
	W14p8S/siwRGo08lagw9Yj3EMBEiFpk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ixsbNBjC;
	spf=pass (imf20.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755063189; a=rsa-sha256;
	cv=none;
	b=M0gPYOFBzVWo1ma/Fjx/Kff0RUaBDkul0xk+H9FZd8je7beMdVVP46nEcD1uPO+WwfGaqG
	wCOIcp4EonJ8NGllntJeZmTiVla+v/j1Co5vwOJ0KFUIejW0LeeD1rDi9fJeioj1AgKHD5
	y9D5pCyE1cOLpRdLZAqv+xtmrto9r38=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32117db952aso5127275a91.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755063188; x=1755667988; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fd5Hzu0+89GoFhfPNDsRG3A11ZVeQEs8/UJ+qwaOXUU=;
        b=ixsbNBjCA/Lu/wwExbi8vqvt4dAvP0P3GTJTJE7+k7f/4JmGJ06MZTW/P7XkdU7bfB
         z9YlZXPoTA+KLez1iqLzbt6O9nVy5sfDIQ4o5Vq+rUfa+cCr4+XC+YTlNXEWVOGccwm4
         Q94ubzxGohqIecGVm5hZ2Bf8hhZS1A3wxLOO+3xWm+LwF3Cm5uo9YlU+vf/0P6Qob8YQ
         mLLKZqAt+ABSFFDDajveO+ecm5ukDP8TAVJTyAk3UJfFpEqJPDJaMu98Y4I4Ml7LzAtt
         9hI8QCQvu39YbntOqNzr59cEsE4tGc5aWTW/v7IsC8NIqakZtbdDAaR92k+jqtilycB1
         xSfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755063188; x=1755667988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fd5Hzu0+89GoFhfPNDsRG3A11ZVeQEs8/UJ+qwaOXUU=;
        b=U/+W0TR4kIqlBuFsdaxEh7Ph+RBp3LOv40dKJ8A4CignC5W85fjq3g1V/ggfYgAfPk
         Dqn9avOITTJPYMJTngEu2xipMTJUGm18WS5SFA1ChJA1wx9ivrehoaDHeNShMsT5T43+
         MIbZLhlBJFoyDT/Ar1vZHuABisyWuQ8dFP4RuXRqUTAfCt6tSy4oLwH8Anu4/x6iCbgv
         q0gOCHpgi4kIMAAMANbM2xoDHYq75C0/6767c2pZBp+rDc9DtwOLCxZBRK4XehzOFZsm
         Lqc0+M5Fhdt+xp3u8u5S7eld0k+qJgA46HHwei8Z+EIYExjd64aVI6i8ZO5blOunWYvh
         690g==
X-Forwarded-Encrypted: i=1; AJvYcCUJ32Ppk3BjHssOOi2l9TUdCZrQ4e38SMuZL/rYN47iUhirSn7/PBcceSxGsKHJrUpluQE78DftHQ==@kvack.org
X-Gm-Message-State: AOJu0YyZiplEa6eTMQg22KjrqsMFmPOxIzwaWNiKx6kMOm19UleAHNOU
	PgOSwfHH3de0zRXf8omxBvrExkPzd5Lkhdj1JmKuiDIF9zeIjnFUoAGbRa/pLQxF0Q146BpnPT4
	XaQQz4S5tl1wSzQJnxu+3v49AySyCvKtlG3dXXOp3
X-Gm-Gg: ASbGnctiy0nLloRyY/EbGvYtL11/Yn08q6cW0ym5yQPWqIq0Z7apysAS9XTX9miXhyC
	5j5ZhucTU7DRirY/HrVta5RHftFyknEsOgH9prBOH1ybpsldkCmkG7SSFxIylMh+8brcK4FjVTG
	nbUNJfrpWbC7fBKf2PgvvG9JK81EGPNFtJ/s+SSHA65WMuz3ZOaj8MK1LYjjWU3teE+p53oHRrB
	rRsAETU33YeA5iglpgbSEMgtdUETo9IE4tWC7AOIqqMC4H42sM=
X-Google-Smtp-Source: AGHT+IH3Ow5heN5Ax2cYKZiN1J5uErCtHiipF//JGUZalAKyO1nKABn3UiGzqPqVAQOS02PYRiux0Wll/uHc1/Zh/PU=
X-Received: by 2002:a17:90b:3c08:b0:321:c567:44bf with SMTP id
 98e67ed59e1d1-321d0eb0f49mr2505895a91.29.1755063188104; Tue, 12 Aug 2025
 22:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com> <20250812175848.512446-13-kuniyu@google.com>
 <87ldnooue4.fsf@linux.dev>
In-Reply-To: <87ldnooue4.fsf@linux.dev>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 12 Aug 2025 22:32:56 -0700
X-Gm-Features: Ac12FXzONwUY1or--rg6Ax98ZVLm-UmE3bBgmXpdqTrH-hTrcJWYQJLYQ9n4lIg
Message-ID: <CAAVpQUDZ_8RN_VxQWH_wipRd_Ge++YZU5SQC9535CR8W6m-JnQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AE8561C0005
X-Stat-Signature: c9nkenc18xmdf76ujc61w915tba9myo4
X-Rspam-User: 
X-HE-Tag: 1755063189-399547
X-HE-Meta: U2FsdGVkX180Z7LAJ1H5NW1WRAFIEEV6CRwuXrs+act2Nh41olHmQcdwLFLJ9lBQ3HDysee1TmnnIK8AihRLFhmIiDVnadEzweBmALronFO6TpGK4iHfEIcFLzYBRpbWSNUiZTcXlvgUtE28N7DLvbcGAPojoiHbhPtxfxr4WuudvLPfTaHSFH50qax3Ta4o2Phr0ypCixwdThg65jewcZrtU+iihnya5kkak7U8XmTXORZmKyBWZVYlwECuHDgjynqA+B46H0MD1H+S9zFhwGdnAKvOopkACbyn8SZ7I9LFCAOua7ReYLMpmVlEBQ6hGe4NWVjFhjHP+5hECfzf1Khs2DFvi5HpYmSVznGHQzqHwWogIBPD0JSKFsKIgnb/mJR587EDLgEbMb73Q5IY4k/2ho/x046XA/AD3K9Xg/Eswa7q/9be/2RjBca+vPf4rFG8evajsrGU8DgV8Wq/cQQBj54XZkDd9BLyPnMBrp3P/I3V7W3YITupu1+PBbzcLzWkOo1NBVglRs6lbui8zBWEmMwqE8imZW7PXvWErqefyxFaPZLcAkPJ6QIWza5slP2/kxCKhY4d8B0QwAOBNT44QRsxzLmvjn8qVKRiwVS25tv5OKWUYsyw9CPHlTiEy7yfVkpbmjguan5UARQDhMi3eIthgGIRU3m1uQ6qgUja+56BtpaJOE8FVeTffV8p612HmHSMqQ62e2NpK2FgMp32qb2YSpjFANGZZSTvkOqXkb2NUWOWCTIJ/LMX228INCGNx/YLC1zrwzRq/L9qhR8CXtQuxUBorge48DsRQhSpfR+y9X6T4BoR5P3O/ewiLKcIBlpdgb5+pBmS4ZpYgiEQflXQv2tGkrqqrCwmjUaKZJA/H7aQF19AdHjyEt3C1VfzeLUUCxcraVJnD0DRfn+gaAAepC1Szd89Dfw4kPtwL8h3etaQL//vGCV/X9FI0oX7nIMv8fggjyFyb0e
 OlmmqY9m
 5s2Rqi43wX6GutH3Kns2/GBw9V75bbX/Ec5ixrOl6toLz4VLu8rhAT+KhT99ibfuX7EWsoz6alcjZC7csOCkIbOOLlNSwWod7o/jDB/RlhnF7L6YFiya6dqiASDFXYtT/dL06fox+EizlNUOYm7Xun3Q11MRnk+JsIst3cFPmhJ2kzlx9SqdhSlwxwie1Yu5tQQZrfeCaeoU2+6YBY+Yo/XEMaHOCGCS55WDb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 6:58=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Kuniyuki Iwashima <kuniyu@google.com> writes:
>
> > Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> > buffers and charge memory to per-protocol global counters pointed to by
> > sk->sk_proto->memory_allocated.
> >
> > When running under a non-root cgroup, this memory is also charged to th=
e
> > memcg as "sock" in memory.stat.
> >
> > Even when a memcg controls memory usage, sockets of such protocols are
> > still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> >
> > This makes it difficult to accurately estimate and configure appropriat=
e
> > global limits, especially in multi-tenant environments.
> >
> > If all workloads were guaranteed to be controlled under memcg, the issu=
e
> > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> >
> > In reality, this assumption does not always hold, and processes that
> > belong to the root cgroup or opt out of memcg can consume memory up to
> > the global limit, becoming a noisy neighbour.
> >
> > Let's decouple memcg from the global per-protocol memory accounting if
> > it has a finite memory.max (!=3D "max").
>
> I think you can't make the new behavior as the new default, simple becaus=
e
> it might break existing setups. Basically anyone who is using memory.max
> will suddenly have their processes being opted out of the net memory
> accounting. Idk how many users are actually relying on the network
> memory accounting, but I believe way more than 0.
>
> So I guess a net sysctl/some other knob is warranted here, with the old
> behavior being the default.

I think we don't need a knob to change the behaviour because
the affected case must have a broken assumption.

There are 3 possible cases below.

1) memory.max =3D=3D "max"

2) memory.max !=3D "max" and tcp_mem does not suppress
   memory allocation

3) memory.max !=3D "max" and tcp_mem suppresses memory
   allocation

1) is not affected, and 2) is not affected too because decoupling
does not change the situation.

Then, for 3), this change will allow more memory than ever,
but it's still limited by memory.max, which is configured by
the sys admin.

If this could be a problem, then the total amount of all memcg's
memory.max should exceed the amount of system memory,
which is unlikely if configured properly.

Also, in the 3) case, TCP has quite bad performance and the
sys admin should have raised the tcp_mem limit and moved
to 2) like our unlimited tcp_mem setting.

What do you think ?

