Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB37C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888E06B008A; Tue, 21 Jul 2026 14:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839B06B008C; Tue, 21 Jul 2026 14:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701D96B0092; Tue, 21 Jul 2026 14:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33B056B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:37:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A52491602A4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:37:40 +0000 (UTC)
X-FDA: 85013642280.02.FBBA64F
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id B2B8E40002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:37:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b+PE13BR;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784659058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxkkqfmXQyCpwoMV6r+4DltedCph4T0UUkKLvJsSOis=;
	b=iUZKw5SqP8mvR1GYGw6xNilS+d+Hx77Cq5qbF1CeXiXNEhKbNorrWo4vCEjANhYE9D8W4b
	3J2Q8t3gCvOK8DigHmgBVC5Jqb1DkBFqZokyque9cp8Ki9GWJ3ei8M017HhzJDi6XTfS4y
	CU4TvWfBeU4HA8a15u84o2cB3vYv+4g=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b+PE13BR;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784659058;
	b=cMNgCP9xZMsOkHEh1gA9PDMKhXMFNlDkr7AHXLPLKiIPcRrIp/pKiQmB2Cbz5NFj4cbcuz
	9fFkwVma9zEdKR+ALZMBQCacjTCfIDD2quRgJrfZ4qGokQFXvwNmu+bXuQPsSbqEKeZABf
	A+HRiZR/N0wRK5LXijbZd+WrI2IjQmI=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47f785467faso1717276f8f.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:37:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784659057; cv=none;
        d=google.com; s=arc-20260327;
        b=ARrrn/uiAD0U66t+JPe3WIg3jpr2gMugTnuTeiOticq3pvoM/NScBZSgA0dF60PQ/f
         m9mKmg0Ynz6P85BSmL6DYpWZUUsdPgwmJJgZi2UbR50Do1WciiCbnzFR0+Au8hy28EwV
         iu2OWX372GP+07dv0Uskse4//0SlFqwjnYaiE6R5RINdYtCLXy64bCRI+UXfjytB3EKY
         zMQTHD+kYojxt+5KfypF3MX6nUkk5aW44lf1HSlS+z7Oeg5B/ww2xUDHSR5quSPuBFTo
         npA677PBFTNFHyFWg8dDILb2u/ucy99bY//zvaIUWv0zUt88tjdDCWgQX85qnN9nz0Xq
         AbaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UxkkqfmXQyCpwoMV6r+4DltedCph4T0UUkKLvJsSOis=;
        fh=E82fLuhrp0tB6eeRnISEWO9RyjyAoygk8Nn3HEYaraA=;
        b=buUQFKJf9rNfc6KwbSfJRYYNnSlVhel8JngX5HDMCcTd0iJpRHylVfc858KpTBLh8i
         F+WfHPCIFphmWyxHO+853nX0RKY0sNep+GXsYcqxs7CfvSkOvB+XXUi99fykAHmJ439X
         RQsNQCjsmWjnvq9yucYZg7kw6gPFtkxwgt/skRAVnjpd311DRE50uOBW4MyISa26fOxZ
         mQNXbIJ4NWxC0MFlwIg2halfd8XR7WaOxpraBBtoZFfYxqaamh7om6C+XrhJtA5NXnBw
         zH6h3YH1RC7vMfa5VR8JE2m3HG55oHsgDaYcaetpJ3J+NOnI/AkR29PLWFipclanOTl3
         GHtw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784659057; x=1785263857; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UxkkqfmXQyCpwoMV6r+4DltedCph4T0UUkKLvJsSOis=;
        b=b+PE13BRbAnbVUYnjKyjm7Oi5uKU/Qsf6F8r6wH9lQ0+wnx1CCPVBvY4OCWGq+Hwqq
         +He0NRe+28YPYGBNDO8uqOnG2r6JBwLRHCaeXva9JWVrpECB/nSl94uPLeQ3H0GRxSeG
         torvUAbYck1LJPrB2cRq2PoMk5cE/ktyeNzRx0TaeXohNlF3Ujc19WaXgmrusNjPCavn
         zghl3uVIe7ZOaAe8QVWbs7jbEeVwtiu6YQXh8VOjyfyOoIkXNH3u3MDoWtjE9J4LJ0oU
         UYOjVQxnetbYtO1vutPoVZcrpu9JLSqP0YUH0aVJ7adhVze6MU+KIsB//RNnF4VWqQUb
         I2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784659057; x=1785263857;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UxkkqfmXQyCpwoMV6r+4DltedCph4T0UUkKLvJsSOis=;
        b=DJHFtvYp9D1eiX1F92upNYd8B+ijBAoby/5sQd2IxszZdz0ZKVqevmUv/5Llb0Cug8
         61Wd1lc1QtSpeAyYwWhm0L0NrNoIqdub3ChV2eVSRANAKX+GEjAb4VocI+hZLlQOAdVr
         FXDfHKnPwD/qkJ9krjQOIT4hMRm5lRiaoX1ORcKbRuah2a/RKdcw64WeE0NfQtb7JYH5
         vv4z6+AY4DFW6BlmHeVHehGzVCD3xcgpQCckiPyWhOnB61QCV5COj4/m/+SxJdfcxyLH
         6sZ1ZKdtNXiuhW5LrjtHCVN29xuJH4YcwQXRdlsn5RcgjCgczXwDravi8HMm4/gnerq7
         LVPw==
X-Forwarded-Encrypted: i=1; AHgh+RoF/r5TqCDfc3uMKi8pnpgeiUjztimFTjpG1GldYeH7gIU+JlXBqWKwIMH3Fe7iHqxszBPnmxvhDA==@kvack.org
X-Gm-Message-State: AOJu0Yyj30vEgRtNuEoH/IZhcUp7ssAPWe4O6WUCz+nh2xDOQMiK6hrD
	K1MZcodTZIP2ma856VWnnGUW2/mLnSw6iQBhTU8skRTgWuQMT66oRSCaQYfwk87YK9UT3Y42dam
	aRaJo1QacUkaf9Vd2iiPJmOkgeSytqnE=
X-Gm-Gg: AR+sD10AD2VkLZb2DF436DMuJRwS1XW4twnirt4yTpOUn/Fns9Gc7MHqOt1S9L97XQu
	DWbrMGi4OImBfC6s9H/rSU0dTF2JXOsEpLl6a1FfEw7VVVkdl/STNs6+TIlwPtUjFbjA5bVjo6C
	BMi34PSjFoV6AbofjmFehYEgq7J06Afn1PLXtX7hJbg51eOWhxKdqMf//EDgWgvqSF4ZLC+zht4
	IZihoSunZJ3TXnPax1z/ZSWatt5PnejEjGNrClv2K/1PBCJ76S+/D36oh1pMaG8QmOPsBuZa9+Q
	81M6lv0uH5AKwZHCoA==
X-Received: by 2002:a05:6000:619:b0:464:8d68:618a with SMTP id
 ffacd0b85a97d-47f62328339mr22603672f8f.32.1784659057115; Tue, 21 Jul 2026
 11:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com> <CACePvbXAqutPvawTcBXLa47=WVKdLBDHL8unKOSvV+KbrEmmwA@mail.gmail.com>
In-Reply-To: <CACePvbXAqutPvawTcBXLa47=WVKdLBDHL8unKOSvV+KbrEmmwA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 21 Jul 2026 11:37:25 -0700
X-Gm-Features: AUfX_mzPdOOKmpgA3wHyk9NpxC6ytdEZlwgbnSWw1ay56iZ7TuHkZMfVKCtL5qc
Message-ID: <CAKEwX=MjvpNwLVg6FZRgYw=31D4XwJnn_ty4EQr+KqzQX+Rz6g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B2B8E40002
X-Rspamd-Server: rspam01
X-Stat-Signature: y7trq9aj91asod7dsys5dt4m3ezweaph
X-HE-Tag: 1784659058-348338
X-HE-Meta: U2FsdGVkX1/kizsnWzNe4TJ3FKcCkuouMbTJy/ilakDaS3owzud7qV4m7MQEl7NWAEOazZNxSr9I7OebAwzUyAR0nhirxEm7NpIqjR07qOJL1FmW6LiWX/YLT2nrnvObVG3s9pxMaogEFHuZ/XdyOgt2VZ1V65Ag6PPq7rUAxPsXxpmvEGkG5Gj36snhMEY4fl7WYuyASWbErcdxm3uDiWWn5mTuaKtfxkYMIQnQiPDLpoZ0kGeesjRbX+BRdnoOxDUZ4FWzR8zWXzj67xGlLEddFtKWm8pzIJocUXJ8UFFcOAz77wMQ1X29tdI1bAL2pSWKpnOZHkRNazQCZfRR5alcaC5WUB+plR+IKhdgiRJzizNdv56P3EBuN2Vtrk/ed7bmDdrJBpZw/pGl3QG1OeH4GLuYUdBJ+8zlAPjaa9FmKfmLwZKH+SqPyQ1Ie+jYpbsQMKYfTIlohn/WwFd46pXU2OokqRSG+56OooGEmn8p1ykzYc7MT8bWClXlidTMZ0XbNE6JbuCeNstRoNGzDKqTsUa+TyL3EzsN3Fu0XuxYZKddlxkZ2dHjPWtRkCfYUUcQO1e5Md0fWyawMYB2a3vVmrMARgvXw/mBN24w1JSYL5uzfCwvzhdUgTs9+5vbuyAGljuvETG5pdb+ZYtOZAWUH7EtcXDg4VBb3z4GY51+5hWDC5DZy2KOUnEvvHUnWaaVvaLyhqX50a/8skp1Zpp3sOrGK5mlItXsjosSJVHcc0kQ7olI975+t5lRUgADTDCLVn2fdopjnyE22XldKmQVMz8zh/LTidm7ZF7nCaoNB9J6WbYQ6E/1bN0qevWehTu0a+87bVUyZSisNu8t2NigYFXqxilULsduciwt13IcpxR4yH7UAe1L3uOdoZ82pgiUbfLbaKnCZ2H1YPuAb4ZxhyxnpLODxxFaf+ZzjPvmzpygOxxJ55LiN6PTcnhiLY9lJvUG3PNXDme6wns
 6og5GKip
 BV9S/+4UIeb75xtminW69gsNes/brjKry/F2LhS9nBV/id+7ip10JnEYihtzVXaS+RIzyGQWG3WQxLoX1Wg/ZzfNhxt3hV3j/YSj1jmCSk7Sis7NKoem/WwyFEC4cUMxNc2YRlfuEkvx0QtUYJXqGbSQimy/FAN0ayPc65AZ7zbRP26d5rMnB/+9olK2p4t6KgwqyfQBed41wcIO/j6fAoVv4plD7JRpkzSVIYIZoAsGcJAthhl40ua11RcuqZw9yUfsb0mYP+XmPbxVql/s76iJ3mpLRsAiJ01RMKE5W1lr0igNIdDmALBAsdHo5jQoQmANzJ11z/dJ3mk38YSTGlbUb4tefFJt2jLyeba82d1pOlj9gS3a6yiLE2diVZP0LAM5M2hvxa4KnEJJK/2WNIHmQxJZ5Pn7UAQp3pWIqBJoGtVqClYgLQjG7w6fB0JsikcaGDje7u1krOUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 11:24=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Thu, Jul 16, 2026 at 9:49=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> > > > [1]: https://lore.kernel.org/all/CAKEwX=3DOvR7GbU_9f2h_MtU4m0g6s-es=
HmNQKYNhJz610M0P3Sw@mail.gmail.com/
> > >
> > > Hi Nhat,
> > >
> > > Sorry for the late reply. I've been busy and just saw this.  First
> > > impression looks promising, it is better than any previous version of
> > > VS. Thanks for incorporating Kairui's feedback. Please give me some
> > > time to sleep on it. I will get back to you on that.
> >
> > Please take a look. I was waiting for your response as well :)
> >
> > The patch series is large, yes, but it's an RFC meant to show case the
> > final end design.
>
> Understand.
>
>
> > > May I add one wishlist item related to ghost swapfile here? I will
> > > reply to your VS thread for other feedback.
> > >
> > > For the ghost swapfile usage case (no writeback). Can VS support this
> > > usage case while maintaining per-swap-slot metadata usage comparable
> > > to the ghost swapfile implementation? If we have to put a number to
> > > it, let's say the increase in metadata is less than 1 byte per swap
> > > slot compared to the ghost swapfile implementation.
> > >
> > > We have large deployments of ghost swapfile in the fleet. I want an
> > > upstream aligned solution that does not increase the existing memory
> > > overhead compared to the current ghost swapfile deployment, for that
> > > usage. As you know, memory pricing and optimization pressure are high=
.
> > > The ghost swapfile patch itself is relatively simple. If VS can
> > > address this usage case, it will remove a lot of incentive to explore
> > > ghost swapfile-like solutions.
> >
> > Hi Chris. I have some thoughts on this - let me know what you think.
> >
> > I understand the memory overhead discussion here. In the case where
> > vswap slot is backed by a real swapfile, I have not figured out a way
> > to make the overhead disappear yet. The damn rmap is very annoying - I
> > have some strategies to get around it for certain operations, but none
> > of it can be done without a full fledged patch series of its own.
> >
> > However, with the ghost zswap swapfile backend specifically, I think
> > the overhead is going to be negligible compared to the status quo
>
> We might need a clearer definition of negligible. e.g. in my mind less
> than 1 byte per 4K size swap slot.

I laid out the overhead below already :)

>
> > upstream (things might be different internally at Google - please let
> > me know!). This is because the main remaining per-slot overhead comes
> > in the form of one per-cluster array to store the "backend", here it's
> > going to store struct zswap_entry pointers. This is not extra overhead
> > though, because it basically replaces the xarray (that you added all
> > those years ago)!
>
> I hope you are not clinging to that xarray because I want to get rid
> of that as well.

That's what I meant though. The virtual table replaces it for vswap users.

>
> > The rest is small stuff here and there that is not O(slot) but rather
> > O(cluster). For example one struct rcu_head per cluster, xarray
> > overhead for the dynamicization - note that this xarray manages
> > cluster, not slot. I think that's all, unless I miss something.
>
> I also mean the normal path that accesses the swap table will take an
> xarray lookup with different locking requirements.
> I prefer to keep the swap table and cluster info where they are now to
> avoid that extra complexity in the mental model.
>
> It seems allowing the cluster array's virtual entry to grow should
> mostly answer your VS need?

I don't get it. What do you mean here?

>
> > So if you don't writeback, i.e no physical swapfile, then I think
> > there is negligible overhead (no rmap and all that jazz).
> >
> > Does this sound acceptable to you?
>
> Regarding the memory size, yes, if the overhead is less than 1 byte
> per swap slot compared to the ghost swapfile. The location and lookup

If you see where I miss, point out. Otherwise I'll take that as a yes? ;)

> path for the swap table and cluster info are not ideal because VS will
> force a different location and lookup code path. I prefer growing the
> cluster info array to gain more swap entries and keep the current swap
> cluster and swap table data structures where they are.

The current swap cluster and swap table data structure are *exactly*
where they are. In fact my proposal keep it closer to the status quo -
once you lock the cluster, swap cache and swap count operations are
*exactly* the same, whereas Baoquan's approach requires taking swap
table information and shove it into the struct zswap entry.

Can you clarify what you meant here? :)

