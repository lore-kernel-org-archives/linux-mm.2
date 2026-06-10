Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE38CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268DB6B0093; Wed, 10 Jun 2026 12:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218C46B0095; Wed, 10 Jun 2026 12:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108466B0096; Wed, 10 Jun 2026 12:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0F6A6B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:47:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F74A1C0E50
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:47:43 +0000 (UTC)
X-FDA: 84864584406.26.91F3527
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 75A3A20006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:47:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pOpl6iFc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781110061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESwUSaSMN8gaVV18KOTc1a43xJoRWKiKKFNyBgNOt8Q=;
	b=OKedNSmuO/Qrmy/hv+xpRluJ5/J/JDy3o3WsjFQkYdV87H4d5dM3H3n0KaaucRUWcYku0o
	Pz2cxnedxnp4mXiF3L4Ro8r4anZc6JjQ91I04/BX5pm6M/CSj55d9yZgpvGO0ZoDDMp3/3
	KgvabNxTuwXbgdv5tgRcW4fV8b2qWi8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pOpl6iFc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781110061;
	b=8WdMhJbOZZvw/li38jWKFFTl0POq32+aWYhigvk33+/ceJLGvfqqpMjC4C0Bg8Tgs+mmWv
	0633wSL4P6hoWeYyH5ZBIIQuWgymxx/BgvZvhObGpjLGE57dxJaKSyXE0diQ+PSgupFXoW
	sm7pWGjSEXynmMUTNhRb/wQSTnxFv9U=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so5237755f8f.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:47:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781110060; cv=none;
        d=google.com; s=arc-20240605;
        b=FeA0a/PXLvhTunHpLHNyUpsV2nC93vuGYjjmBLI/17ih0+HGg5gZk4lTlk77zRWu2x
         f3olwDZas+kF+DiwAkw7X0cTa/f5Em+vBOWEuZREF6GVLSmUq5X9jIl46QQTXeSjZUvU
         wyOoT4qqklcWnBdGHIaQgMEx/uq/hUiU5kDd5bIqmOGrIGzEE2vZtETXI3BSz9sTCgcJ
         Yx16QSRTbGfekkMrWMbuyqK0IQuYfU2EIhJJQD19ismV82FfQVOk6DIthjVu8dOPEAp8
         /2nejBAsaKBK2PxTJarRht3Dqi7auzGHigI8h1CoNkILLI6GYUK5n4jzSUUu45Q81ZzH
         k5hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ESwUSaSMN8gaVV18KOTc1a43xJoRWKiKKFNyBgNOt8Q=;
        fh=ttuOrSWfzZHjgM3vruJNtKxktSsw8qqW02SQhXCq8OU=;
        b=B/c1J2Qinx1q90+fPoDkpUEo21aEWTec2kzbfUyIGY3yTv3ekvKcLXHo4V8xS4Y68M
         e2Yp663Rrp29+XOqlvmqwhVauAcNVvw0dQzVg/e+5DkviEFUPsNjZdJcxb4RD7e0C5lR
         rEVIaiHkrDq1CH4ZRtEGjsnurA33q6JTFJpytBNVDzVTpP27xwIPGuYBmrTSj3NGGvWa
         tPJrQaT8rZAgYYQze4l5FxEz5RQzfylP3I4WcypxmRBuE1qTq8lJ5Rl0BFcEwiJrxF+N
         BcNzPtd6O7rzFeLK6NTo1aN3peKzg/WrLJh6LgEV38MsAeFbzjXc4TevdYSHNSSnB0AQ
         932w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781110060; x=1781714860; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESwUSaSMN8gaVV18KOTc1a43xJoRWKiKKFNyBgNOt8Q=;
        b=pOpl6iFcJ897Ia5YHJ75+/6XD586IsoZFuXkscfuiIqWFFfidvCWSDQwkCt+rbg2Mj
         laP1xsf6lPdr3Ko0bi+43SpUkwrBuO41JEEJNHRwN8DPX+DlSj2Xg4pImty0WkYpvVJW
         WxFJM8oM5EThrWgGogTfiCOrL86xwhRBX9Lf8toUAv/6RcX8y156OcZAWhKFbRZwKGD6
         wnAXEiuHJ974HW/2G9rnhIjiGBkshDRYvoQCozIKwGc1dMIKP0v7SQZgZAeSs6qBtimO
         uR/mgytUw5Qf/6TbTJKRHXYim291ATvx3Vhb3yB+e38ek/ugXxm72s5WmyaE6GwMlsTA
         x3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781110060; x=1781714860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ESwUSaSMN8gaVV18KOTc1a43xJoRWKiKKFNyBgNOt8Q=;
        b=bQj9511DTUZi0VSzH5aLkJFF0tqDr0ja1kIsev8VIMlOuBxG4OZqeCsgqWToHZNWYU
         dobVROAY74SujN8kCi4AGjcDLg2aJJPPVAqMCljrd1LVBbpK4mPkC5qlYy5wC5LqKF/g
         szs5rv8XG7qUR/B1sCF++x9iAdPlBPt7Y52uNCtBt9whSljYd/xkSSBnQhJkPjCbRSis
         EMQp/uzSAMBBcym2dVqrw6c/8nbIsppD5rtz6c+JLrZzd+a21WzRfez6MHlp9ZPyhJ7Y
         d03fcDviqKlq4nHT7zhrr/lpTORVyHMBPVxRVw2wq1ry5SFkvWEyd2Pfuz76nJWRCN89
         DBNQ==
X-Gm-Message-State: AOJu0Yx1BFhFBxHGoaltI4Se9tTwOYpt1m3ZIiVoFZaNEo2ZHIYqLnKO
	Pjp1fusuYXrvJC4WMRYoswgJ/kXw1W474W+h6oz/vTIyUQAxm4O3jgxeOVWDrhO+TQsXWbvLNEn
	hCtJKbxyVYjzvw9GjRD1mdtmeh4ptcq+yR4EmqA0=
X-Gm-Gg: Acq92OFSmmQBiqFppWK6pgOXMycOSp1FfLK7E3y8v+D9h36v4U8tV9fbwe1I8CiE6I7
	8imIh+gVWNBr+hdWO1YWY3ILOy3f59aPcM2BH6eKA8yCazLBrtyb/+kpubPJvxFbqohJVfvfIjZ
	G9yGfFsJ1kSrDdxkDyEHddGAQ4eUiaqlM+2ZtGPwFbf9fbDdcUtQrTkftz9QtOwLVNCSoZI0fAf
	luw6LSJ0CBdP/5h9Ze8lLsimkOXu4dn/swX5YTLC84aD4VHFAVc3FqiR8zFJxavxLZfbRoMf8oE
	aJpWs4A6Epgm3iDX1FQKZ4ipxNlqFkAqkg2SYvpNni5raHfGAZg6h6dqVQZpzHp2/Q==
X-Received: by 2002:a05:6000:c90:b0:43c:f66e:f24 with SMTP id
 ffacd0b85a97d-4603063b3b2mr28648109f8f.35.1781110059782; Wed, 10 Jun 2026
 09:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev> <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
In-Reply-To: <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 10 Jun 2026 09:47:28 -0700
X-Gm-Features: AVVi8CdibRwha3d1CfpGB8ubIFe97a8Qmo_1hlKcwbO82ukPA1P5NQ3oansSh6A
Message-ID: <CAKEwX=MFt=Z5x5meSgf6H6B2a4J9Uf9RgHtBLEqJgyCiJbtyyw@mail.gmail.com>
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75A3A20006
X-Stat-Signature: yucfj95r3n3h8d1iejnw7e4fki949bpw
X-Rspam-User: 
X-HE-Tag: 1781110061-578468
X-HE-Meta: U2FsdGVkX18U0/rwtKRypUaf7++s9U7EMiZpaC6ykHWXhH0cN52njczyHnQEwQhF8RKoZQPKf5Eo0RqO0LxG8VSyDU8iW3R6V/mavcBUGpuQvECvWIigoJHYj3B3NA2cPkxjuRpe2GjJqWOsXZ68AyzCEJoGdumXDSA5zd3Mw0b+nUf0YrBqy0O7mygSmDNNdLNYirnwcyBmCXHMfNcJj0QOQtfdp7ctROcUxaKOXkG5mA5cDar3HHErhfeytdLSe4rmTLGzjUAYQZ7uUz9gScw6YaVGC8N9mHUmJWqx1L3upqKLt35fy6xnr589R150jjMXdPbodxhXbjIztT3KWwYRXtnRGy4HR3RN5t8cKh1SMi7X9gHJowJDQ4SbwVXGz5h+SJCFlwpwker4HONOnnoleIXR0LIqyCKlsPWUuvBqvPaG7y81DCD58dCcXp9e5GR3H8O5Odc6fNGtSvlH61zlrYClhmsGIwxZEBWo7KdqIAtiCqBN9BvZFAP1YDsbiDOgFRspRSWAja01T4J8iiz/MZmeX3F6aNp8GhfgFjnE1uV7hdUZ0rzK8nkGWp3lVOVX4ulOKfPmJue11kSNRwrx3Z8wF1jU5Kch2D5fYZHktJD7gFvzNMOqyCOaHxUSxOyz0DgTQQTon/H6hLoqEXq/2kJXHpJ8Fr/9DkiU7rEn93ZN46NclgeF7EHTVEOOYg5kt9+6mY4A9hWuQamh248iK3s/jE6dWTbQKnPyfBFB1CXacY8KPu9J9UMfIqgu6MDWCp1/KE3yU5aJr/8yJ71tRbwdQN7y0/6W50NGyDZUqdIkaFM/ggPIzZdAdG9/8ljBPV0PR7/+v1MgWESCHznojnVkwk7Pftoz6vFyJpqI9SZZiGEjf1kn2fEsCq0X11fhi6Ba6pGfze4ef6UvsWwsLjrFVH4/EpYsnuin0l0A1Jr32b6kCzS2PJ/MaOVDL6E7GPjsG/6m3JezCS1
 vJrDyBDT
 E1s7ZL4BrYFvEioNhKSBwx6N3msblfhcZtK82C54YfK4KiKyV4b2O5JKEYvABjxzqPoNSdmRF7VhyVG1MHF0C74pc8MsTL7OmWnPcmjLPbjF0/I4mjHUFRDw475NcNJcXHOpihTC0ttI+wL3t2pwgAO9oDcJuFq8WBvjjY8inY4uy49TWPrN94bXorHXtR96f67+5Tzgkp4xhcrqNvCCuG/f2sFXjEvGlXczhUk0xrFBe9LlLqKd5Upb9ZeUG8o2jNuu7qh0327oqqwGgm8AnyUWgbwREjWtftnPaOhnFBLwgT8rZlY8lvWxbpZc08LjwGHtHRXi+Tgjmqog1rk8FM7V64JPp6+nDotoiuORFx0BK9f1Ff59Lkdx2L4eqVumBSfSKcboUCFtm0oANf/f2sSMBchhU6lV7VixN1f4/dpI5uquqLzcF8vr1X9kyu0gpWyRRy7HCzHgjg4KWeM23HUqQyYk1WfMoxuHVrh8QXethjxXN9LWZFJet5pPFUuKq4v2r85W2qffPafI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 9:38=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Jun 10, 2026 at 9:05=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.dev>=
 wrote:
>
> Thanks for reporting, Zenghui.
>
>
> >
> > Hi all,
> >
> > The following splat was triggered on the mainline kernel:
> >
> >  BUG: sleeping function called from invalid context at kernel/cgroup/rs=
tat.c:421
> >  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name: cat
> >  preempt_count: 0, expected: 0
> >  RCU nest depth: 1, expected: 0
> >  CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0-rc7-=
00056-gacb7500801e9-dirty #304 PREEMPT
> >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebu=
ilt.qemu.org 08/13/2024
> >  Call trace:
> >   show_stack+0x18/0x24 (C)
> >   dump_stack_lvl+0x78/0x90
> >   dump_stack+0x18/0x24
> >   __might_resched+0x114/0x170
> >   __might_sleep+0x48/0x98
> >   css_rstat_flush+0x54/0x564
> >   mem_cgroup_flush_stats+0x9c/0xb0
> >   zswap_shrinker_count+0xe4/0x1e4
> >   shrinker_debugfs_count_show+0xd8/0x268
>
> Ah, this seems a bit tricky.
>
> Seems like shrinker_debugfs_count_show() is invoking
> zswap_shrinker_count() in rcu_read_section(). zswap_shrinker_count()
> triggers a stats flushing, which might sleep. Not ideal.
>
> Is the rcu_read_section() here to protect memcg or shrinker? For
> memcg, i dont think it's necessary, no? mem_cgroup_iter() pins the
> memcg before returning.
>
> (memcg maintainers please fact check me).
>
> If this is for the shrinker think this needs to follow shrink_slab()'s pa=
ttern.:
>
> rcu_read_lock();
> list_for_each_entry_rcu(shrinker, &shrinker_list, list)
> {
>     if (!shrinker_try_get(shrinker))
>         continue;
>     rcu_read_unlock();
> }
>
> But OTOH, doesn't seem like rcu_read_section() is what keeping it safe:
>
> rcu_read_lock();
> memcg_aware =3D shrinker->flags & SHRINKER_MEMCG_AWARE;
>
> We get the shrinker reference outside of the rcu_read_section(), and
> just dereference it without any checking inside of the section.
>
> I think we can just remove the rcu_read_(un)lock() here?
>

Also, looking at the code a bit closer - if (!shrinker->flags &
SHRINKER_MEMCG_AWARE), we shouldn't be getting into this loop at all
and inducing all the memcg-related overhead at all...

The code really should be structure as:

if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
    total =3D shrinker_count_objects(shrinker, NULL, count_per_node);
    if (total)
      ...
} else {
   memcg =3D mem_cgroup_iter(NULL, NULL, NULL);
   do {
   } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)) !=3D NULL);
}
...

