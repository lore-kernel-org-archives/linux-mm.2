Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8289FCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 23:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2E76B0005; Wed, 13 May 2026 19:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584156B0088; Wed, 13 May 2026 19:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472136B008A; Wed, 13 May 2026 19:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 383EC6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:10:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0F591C03F2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 23:10:45 +0000 (UTC)
X-FDA: 84763943250.20.8BEC40D
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6E167180009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 23:10:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NVHBL2JT;
	spf=pass (imf24.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778713843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWmj7O1/4wld3D387Jz2Aj3uxUINmZx2w1RQME/BuHI=;
	b=h5rX4cqykIrGLvPI0/2lyKxYlHqFFBg2yWriyV3u32uTjShEJUmauMJMGa4KoT+d8Wj0sY
	OOUhBofqFp9k8we0i+XPWXzsvlZu5shcXx0S0wwz/ArFi/EWr4USWnL+fr31XNV3s4rbic
	acyuLc7U6d7fPhJosEySSLsr9Cmvv0Y=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NVHBL2JT;
	spf=pass (imf24.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778713843; a=rsa-sha256;
	cv=pass;
	b=IPos2NP/JNi2bHbN6yKa72WP9/nLDgba/UhkZeg+6YhR+l1wfo998DbdnKoYZVvlP2OVBl
	mbK2M/baTvm8EEVYlO4fgorUcSb4oKJMsAZ/rrDanmSFJ3HiURab5N0kPHxN+MQXwMxeB8
	o8sTbs6wLSduqPdBTuwNEIuLwdPTitw=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bd124546379so542648566b.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 16:10:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778713842; cv=none;
        d=google.com; s=arc-20240605;
        b=BxnP3IK0NO5LGOzBw8Q1Rhmvk6e2SCig8b8vKpnh9jtZKMuQKWkFCinIu9H9L+e1cH
         DK1MEGnFIBbmOQY6XdkINWReNm2+E1jpZE496zKEqPrj+s1Xj23biZKUFRcICDxiuZcR
         GSqA5Yb9/M21S1M7FcaRK0wn7SWwajVFcJENoSYHY4ZOO64/ebZaYsyVFy6TtGtzZm18
         izDA8/7jaAisE2t3MfZwh8wVMGbAeVEDgJXmYRjAYu3B1q9UsSLR3KkRdgC3uwKGHQlV
         36fZ5mxPDH/ueNhaNti4Y8XjqNc/KZ9dPHIt21X4vu/o82M1gxbd6Pu5VxGbVMHOz8ps
         Qq9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fWmj7O1/4wld3D387Jz2Aj3uxUINmZx2w1RQME/BuHI=;
        fh=vcbU7WqImvOD/ApOt20DHf0IBpOlDnyJKOnTij7hfgQ=;
        b=RngLOr+xsQuiFpm3mOEHSySDVlOIV8e4OsK3vVJfEMCqkDpKbnBHpwOPic548BbyfN
         r2S5IkjzAMFG5SfzBKuPUKY3CT9lDCc/32TR2vHZ5wE9WhweoHE9+V45Hkuv5wRQOo3d
         ytZ8ll7rGqL8F/JcsGC2TH6rKFDJhJTibOeJA5VfG3sMVh47dM/Xt1+r8puSgWCFlrga
         B6zlFW2kZfe0HgRJwzoAsOaraCeAIZhh/98nEUe/Jsq22jV0NzsZNR9c6DMvcz8MZAGu
         D2PMQ6F81ETtfniKOSxKP2iTfqWjD1h2uo8+KKcpUn3JwhIu1Qoci5UfraRpUC5hOCOU
         Zq4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778713842; x=1779318642; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWmj7O1/4wld3D387Jz2Aj3uxUINmZx2w1RQME/BuHI=;
        b=NVHBL2JT9hyhLFG17giE2qhXYVvq0eiqdZqgJlbWIDhoaBuDzmpw2aozUe24pV/zpJ
         aWvpWYavFwRVgFTwU3sTYr5rMvBqk1Pkl1P46BjirmHPAKbr2IwyeD2t2tL/DXskpRod
         QtmFVX0iOrXKQfgpVNGD8c2Xm95BFRfuU2i8EyGkEcGfgSoteVXVht0odaAM/uVGvfc5
         mZtMGxCTr+PVCLKuCv9kq2AB6qRIvJzC8nqXJKJ42b9MPTiv2upqWWxBRcUOFUS09n+v
         upCGRPAOdWaK0QrtdGhmDalw5o5yYYWBskW4U/IZlQutULDZrU2o3E8PCwicZ1sTSKAM
         RNig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778713842; x=1779318642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fWmj7O1/4wld3D387Jz2Aj3uxUINmZx2w1RQME/BuHI=;
        b=WnwSdnoFhP8hvGOOZ6NDjOmVWR1jGwoTni0aQVpR82IC4nPBt7sx3/lLDGOd1bGXva
         M0caD+5OKM1qC1m4qvfRmwq061jBMY4k04GZbF0zS3iDvi+ClloB+pZpGl/oySy7485g
         ewJ/gChmb8k5suHZZpI6KybkZzul9Zxdf/rbNr5Ay8MwswRnATJx/9rN2qbY113/Wn3/
         Yb3Qlzk3MJoGH2lG9A+6XOZNgUZXkuuGwZ+x/GLGAWMam4nbaLwZJ6muL313VvDOx3/h
         UUY9qu0Wj62DTntzjmDSaui+oP8oDk/9G6F3RSG6rxKKRbtJKWXenIq/saNx8UiqnetM
         7r9w==
X-Forwarded-Encrypted: i=1; AFNElJ8W1h/nbYI+s5dxYCfEFo+bfVeDJWD/bTNC1SXn5gW9zRutqvkORDuCJBxXOHwXj4OLmAvdiLiCpw==@kvack.org
X-Gm-Message-State: AOJu0YyLASwK5kKGOEujvFb61WK9O5SOrPxcpEXxBY3LUv1IAvqmQkKd
	XzhzIUIOv3TsD6Pmp/0lC+bUDs8M+3IiQFJM4re1Np0NpLCGlBUpa5s3TCeCK54FZDRdCIXE23N
	k7UJyJPxDgNMmzq0Kmw2rpv1EAjZhSdg=
X-Gm-Gg: Acq92OFt1vlPgZfyT7N7Ou5+mVfzCB0Dzdp0NdFDfPNoTCz+TGLfwLKcIf4wgFk97so
	yGCF8yf2zH7Vwy591zGhOFQRN+XQeU31FGQ/ySnK6oEfwFHjWhS8vYL0h7mVRxi8vi4esJXb8gm
	9L+K/U72/DQp0JE0d5k5uiuWDU5MVyH1ANohMfFQJ83syPOcPsLsqX3FW9qsFZoHmtWaC8bt6Zr
	SlMNckoJaBI2LmlYe+NqRs3BEEMGOSbQnc/3xCPeKBnZFkNJUwuqQrvbAAojXrNN004K42D+sup
	tYn8ALBJiqsETUnTB/gNyJCj19BDNy0=
X-Received: by 2002:a17:907:9704:b0:bce:267f:19cf with SMTP id
 a640c23a62f3a-bd3dfd64271mr315423266b.12.1778713841538; Wed, 13 May 2026
 16:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com>
 <20260513021148.17588-1-lance.yang@linux.dev>
In-Reply-To: <20260513021148.17588-1-lance.yang@linux.dev>
From: Yang Shi <shy828301@gmail.com>
Date: Wed, 13 May 2026 16:10:30 -0700
X-Gm-Features: AVHnY4IN0dYyc8FrioEWxy6x33mBpShrHTtaMmtJuX5Tb81bKkEuJTZaPlb8x7g
Message-ID: <CAHbLzkpBB2ia4pUG1khZy1w5G_sq6DD+9OnqjrJ6Yu0KxPAe=A@mail.gmail.com>
Subject: Re: [PATCH] mm: make zeropage read-only
To: Lance Yang <lance.yang@linux.dev>
Cc: jannh@google.com, rppt@kernel.org, akpm@linux-foundation.org, 
	arnd@arndb.de, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	ardb@kernel.org, sethjenkins@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ntiumgb5bh1m167gqaxbdqmizx74q731
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6E167180009
X-Rspam-User: 
X-HE-Tag: 1778713843-975171
X-HE-Meta: U2FsdGVkX1+aCIO/Tcj9kbVkxcVABr/SBbFfy5cQKub3X55iT6ceeX9YKCSs3qbK1EatR2oRXeaHDG7kJyhJgHeNAwEu/BERdsI6mJyVDEgoXAJA4LkqPEKpEYHej1zTNAfOXK7d9ot+wU+Vz9ie8vfwTEZv11IKVVFtmB8ebD+iZVRDZUqoVKQaajcbMUoiVaQybEVlc877wMt64nuqgUw5S5HSGfjjwAMNiJni45/SVi31syxfbhOxMclJtnEhgVGVwvYoYDOaNNwUEpH9Lz0jnVXXdk4JXGMEDbtWRzq4JWS+fSEMqrZ680/G9VuuZj7wtFzWqLH4tXTEyCKT5EHLfNRKqLNucPxgCijHxYtXD6HPGPudWXUXoeZMDOUfhM1buryvx8WNPoS7/9FCOaVJrkR30l+TU/6qsJCcpnPzDzlN9cxskSEXLrC8n7byGfhObz2o7ig033hr3F78l5XUAI5bT68NL93Ws+zRGtnZNZVfkvmE8X73U8LW4l/Us28Bya5ShLf6XZ0qkBhmwIu8Ytdh8PMWd9gdCgteJ5uiwmaIjDFO/E+ImEtJHxEw3npK1Px7iyDuJJCYD6ttkHienajfmU8UP6PQTEY1Ffps5jD9PHLN+Fn1Ntn/hNQA6oFEpf0WUvnwE4lxgbOJr4/LH0jHJ8N3rRhga6SV3seZVXXW3vkviLcBHixlAVwdcfcy32WjTUPZQcCuyHJ+eoU/lW28tIRq3b4WxTBEFCnKYxixUnctx/ioHoyLJZsBtQP9RfWGJXeEcSKIzn+21d3QU9NbrDmFRw/8WijVeGxIi0nSDu5ir+JAqfYYP4UeRNXHrqIYWV+Ih/X4CqOFSsA4WC+MRk6aBk5qnZI+yfdku0yOgL8QXxITdE0J0Wt8QOm0AcE+ctz/UuMZyDcPA7oFSMyePM6GtaMGFvN40xY8koL/7gahl7z8KpW+rYCRo6RwFwFdI+/bC1t/p/T
 zbjIvnhN
 lAaQoWiIKWXTaSBRmEyxCkT+eF3GQveF9LPZlc6JT95hdAEyhiSg4kGK1Qcc4cCcIIFPAvRLiwp4+Wox5+dH01bN3JpRmUaHHWOteYwZZ/4BOEmA090lXO25/5QG7kaMGasfSY6cYMtGwfdMLjoV3koFWKB3K1i1Wm40+4H/y63hpwu4MA9PNi0GEKg9yKZpOogaSFygNXdVd1yL4BbzuK5DvU9jDbsPF/qnTAXXecJfrYZOqv/b/dYJNBx64imXA2riBLUC2yAKtedaaMnNim6qNBMvg7ekg7Pixqt3UArCU0ykB/lm0miSqz/NOmhlqNtSNIjxar95t454zturneXk9aaPAyYdehzSpw6FdMvcvXPJoYYZ27gCcpMxzDcaLEChUVLlZyAssymgR4VAIMFHuerUOvYPwiUTxm4d9o4lJ1Pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 7:12=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
>
> On Tue, May 12, 2026 at 10:14:01AM -0700, Yang Shi wrote:
> >On Tue, May 12, 2026 at 6:48=E2=80=AFAM Jann Horn <jannh@google.com> wro=
te:
> >>
> >> On Tue, May 12, 2026 at 4:31=E2=80=AFAM Lance Yang <lance.yang@linux.d=
ev> wrote:
> >> > Would it makes sense to apply a similar treatment to huge_zero_folio
> >> > as well?
> >> >
> >> > with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=3Dy, it is allocated at boot =
and
> >> > never freed, so it should never be written after initialization eith=
er :)
> >>
> >> Oh, neat, I didn't realize that that feature exists.
> >>
> >> I guess there are two aspects of making the huge zero folio RO that
> >> could be problematic:
> >>
> >> 1. If the huge zero folio comes from the page allocator, making it
> >> read-only might require splitting a huge PUD, which could have
> >> performance implications.
> >> 2. I vaguely remember arm64 has rules about how PUD/PMD entries in the
> >> linear mapping can't be split at runtime at all depending on hardware
> >> capabilities, meaning the entire linear mapping may need to be mapped
> >> without any huge PUD/PMD entries - IDK if thp_shrinker_init() runs
> >> early enough to be excepted from that. See can_set_direct_map() and
> >> force_pte_mapping() in arch/arm64/.
> >
> >Yes. First of all, this relies rodata mode. If rodata=3Don (used to be
> >called full), the linear mapping may be mapped by PUD/PMD if the
> >hardware can support BBML2_NOABORT, otherwise it is mapped at PTE
> >level all the time. But how huge zero folio is mapped in linear
> >mapping should not matter, you just need to change the linear mapping
> >permission to RO anyway.
> >
> >If the rodata mode is off or noalias (used to be called on), the
> >linear mapping may be mapped by PUD/PMD, but basically changing linear
> >mapping permission is not expected by kernel.
>
> Ah, right. So for huge_zero_folio the hard part is not just making the
> backing memory read-only, but also whether we can change the linear
> mapping permission for that range. That depends on the arm64 rodata mode
> / direct-map setup.

An alternative is you can allocate huge zero folio in the early stage
of boot before linear mapping is set up. Then when setting up linear
mapping, you can just make that PMD RO. It should work regardless of
rodata mode.

Thanks,
Yang

>
> Thanks Jann and Yang for the explanations!
> Lance
>
> >Thanks,
> >Yang
> >
> >>
> >> So making the huge zero folio RO in the linear map would probably
> >> require adding a new config flag, connecting that to
> >> ARCH_HAS_SET_DIRECT_MAP, and changing one or two places in arm64
> >> memory management.
> >>
> >

