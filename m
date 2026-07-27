Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 773BBC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D3D6B007B; Mon, 27 Jul 2026 12:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644676B008A; Mon, 27 Jul 2026 12:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5370E6B008C; Mon, 27 Jul 2026 12:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 326876B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:46:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B12CAC0135
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:46:54 +0000 (UTC)
X-FDA: 85035135948.16.CEF140D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E0EF940007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:46:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd2nSSnz;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaBs7hQvOzOqrkj/XwDWN0Xx1LAJy1ogX+wmmsCKVtE=;
	b=2sVOBnzYRQNuNYWaeVOrQO4Pvwo4/gzTx5tEr5uBLQFJnqyAM5PVCJDixpXV7CvOjTQO+W
	kNE7TwhYBWkT4lHiEX5yRLbfBlfNHqk1k0LWm5J2WmV7RT3oyUeMJRa5C0fAQoOdNXw7Ls
	4LmexqR7gE/dIikM3iX/zdkGWdGUxQU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170812;
	b=8qaXsV5J4pAYQSnH8PzqOHiMw4VGz6+OQD07JuxNy3F1kz6r/n18wvObjoE8cKkC/pRsXD
	OnwAZ2Ph6JgqIuWa+q6mAEoZ/kGEjG1dcHRYWCsGFQT8GEJjeEegg7v2ksyA6XD9Qpu/KJ
	qfQB0NtQZqxkHMVpYxME+Xvjr3ecXk4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd2nSSnz;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77C2F60A61
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFBA1F00A3F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785170812;
	bh=YaBs7hQvOzOqrkj/XwDWN0Xx1LAJy1ogX+wmmsCKVtE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fd2nSSnzwwttsg9FWIQMq61Opu8EhPEPMxFRf7IoXgrEHQatoM8zzmIR3J4gbtPTK
	 wDD6KSwRUwUwVIDyqNwpbaDtQn+tibjv0ytXkfAUdhcDGQtfwviGpsxHvV+kUnbhX3
	 GOTx2LD2NL3HnvMESO3k7TQ+noL1W9aarAP2xg+/v7BE4b0llRC7Lr+HSnhUyx+HzZ
	 JMXpvzsYqpsLc4YuaIQTPQbFc73Y5yYTpM0Zs1P4N+dnJZzT6BbKJgGMTPSTtE2bjc
	 4aFd7OwUS5cDLHZ+vD4Gb3tAuQKaY/XgRFr/DIDrP3hbFHM9W2FjWk0zINiCbPj3lR
	 3uC3JWm19BgEQ==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1712a04ddaso470895266b.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:46:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoUZmdrlrNBI+tn/t6w40DjUxTwba7lKV3OR9u0AX1RL6BKCu+H2aaMkFZERjOTvY6Viu3l31e3qw==@kvack.org
X-Gm-Message-State: AOJu0YxPQNezwwb3HzYxLPGhU3Ap0oB7exWTt9z9o4GuBS3lmG6IGI26
	OR7UFQeUS24PyCATUF59qon8syWRZtU3A/Sh/3oKvWPTbPRiSqfODVBadaAPj/0/MPnTwrMicGE
	WfYAe9eGkOvwU06HbEXoOj6dwlTV6170=
X-Received: by 2002:a17:907:3c8e:b0:c16:6301:c47c with SMTP id
 a640c23a62f3a-c1f1ea8f5ebmr397124766b.6.1785170811035; Mon, 27 Jul 2026
 09:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com> <CAKEwX=NLEmRKbgf7e4mQ8ynwGLhe8d3orc_2U8n-K_W6VjOAoA@mail.gmail.com>
In-Reply-To: <CAKEwX=NLEmRKbgf7e4mQ8ynwGLhe8d3orc_2U8n-K_W6VjOAoA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 27 Jul 2026 09:46:38 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNbw4T4O-TtFsd9NMJh2RKRDuXTqfSKgMbe6o05MZxebg@mail.gmail.com>
X-Gm-Features: AUfX_myk6qjyuyE059sUoNLzyIKScf_vNR5Fs8UiTVDzjllMgIALaNHhMXM4_Zw
Message-ID: <CAO9r8zNbw4T4O-TtFsd9NMJh2RKRDuXTqfSKgMbe6o05MZxebg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
To: Nhat Pham <nphamcs@gmail.com>
Cc: Jianyue Wu <wujianyue000@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0EF940007
X-Stat-Signature: z6wnqnohxrctdrjftznrhsp4aopp8tby
X-Rspam-User: 
X-HE-Tag: 1785170812-359327
X-HE-Meta: U2FsdGVkX19Wjc4k0A8mJvSsl/3GHrh3UH00hEqRQfEr7QVWMzIqbQMgQmKFpMtB9zueoCfPbFurNUt2Y0INToR9kbH2WZsz7D9E4AGaXwE0yamp1Hbyt25w3fFJBJ+NElk1yejDg3BOOJHp3kUuqWXoW8jLMKPPJYQJIavzkWgzSwnltk3o4sEMEO4Gar/Z5+moPsQpq4eV2vvxO7usRwKRbrlQYaelweoPZ7SI5427baY3v+NO2MsaF9AADlukmGj7Gf3FBPMwNje/c52k6NREW8TGf1OGdVffB6xzl/AsGSnhnA492gSWPubm0nx2OO8u0pevv4Xb6FbqlyS8xW9nURMA2DCer2PgvJbIyunTCVcVWBbC6KKXVBO7Z+ah9lRbN3GtlEu7oEY4LrXFT1pmYQ+6BKBza/yXZJy+uEuRbsyFMwboeOfv7FSCshvtUjY0uU4vW5qXEIxiV3xAlz7WIzzdWbYL/7Z4+jJeRdiR9qRaaRpmBaMviM9CtHcrVmGIJwQ+iBpmCxNNP82wxy/LDTWbrgkApyLuPe9lw1f8K4bk+9yWPUlvyZRPusf/1YjXx8UNTc6MalMWRyx9DGWnMw2f7yQBIGpAGON+ViRO/RYepmafTQRkDwo9u8hdlwTVvml5v6VJfERN15nnOlq+rLbFGQlIZwWvBpo992dCqnAZQvvt8yq3t2YUUOjgtvwubm5R5IL7+uZxyRzLHBax9Xpf/BEafecPDAxAC4cHzaL9TGOKxmD68nuLRGUlC0QeLS/pLUz146ft955od6zQgqSrM89EJo5DQwgUV1rrlhuuxUzkyN6i/vdJW0d9mv3bCk8BRP6eyKHoKjtnA6qjWa0O2nf7YBDoKF2EAG4TrSrEfMWEbjXjYSsp/EMfPfhRzAFlRPvXQ05IwEBIrXDmrPOBFk8rIs+milvW9ny0j4VAFCf1DHzAAdnBc6mZfBOkOd/WxjNtRDJmXN6
 rTyG5Es5
 rREz7tZj8DND83dYU20cCjGn3IVRvplZ6fwWjpc0KLvo82ifqBo/pfvtnwqpnD3ViiqvrNKlrVFmFPv6HVv+qb92rHJ4yxH5UtL+meXeLZzCUmW+3mCxMQZLpStUF9QOxL5RKAi7kQB7oAYgzbm1ZShtRpZoTRvOAoF0bohn49NjjrXQ/mh+lqkc2ZDqgIx1Y/+zbx6PnlfYTnNj+cKs1XTiDnFM7nNEzrZpDkiqtvHZeMU69QlUMTwDwJCE54xVXualGqXq8o1PqSLofhrvp+RBkuY9VA6Jn1AdnSPyBiT4OLS/ZTtsYygMwoK4kUovoP7hdz7I36Zc4oFjRpPE+42KEwT9RpjxfGDxo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 9:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Sun, Jul 26, 2026 at 8:18=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.co=
m> wrote:
> >
> > Every stored page has a struct zswap_entry, so its size is a per-page c=
ost
> > that scales with how many pages zswap holds.  It currently embeds an
> > 8-byte pool pointer.
> >
> > Replace the pointer with a u16 index into an allocating xarray of pools=
.
> > The index is allocated with the pool and remains valid while entries ho=
ld
> > references to that pool.
> >
> > On x86_64, the zswap_entry slab shrinks from 56 to 48 bytes per object,
> > raising objs_per_slab from 73 to 85.  This saves about 2MiB of metadata
> > per 1GiB of data held in zswap.
>
> TBH, that doesn't seem that major... It's like one huge page man.
>
> But Yosry might disagree?

Well, it's free memory :)

>
> On the design aspect:
>
> 1. How many pools can there be? My understanding is it's bounded by
> the number of compression algos, and most of the time the system just
> use one, no? Maybe just add a fixed array and call it a day? :) Seems
> like we can probably get away with, say a fixed array 16 elements.
> That seems plenty. You can reduce the number of bits it takes to
> describe the index to 4 (saving the spare bits for future usage), and
> you can avoid the xarray overhead...? Just fail and warn when you have
> reached capacity, maybe? :)

Hmm yeah good point, we do reuse the pools for the same compressors. I
don't know if crypto defines an upper limit on the number of
compression algorithms. If we want to be really conservative we can
use an array of 256 elements indexed by a u8. That's 1KB of memory,
probably mostly wasted. We can also just define an artificial limit on
the number of compressors based on what we currently have implemented
and increase it when needed?

Not sure what's an easy way to determine all crypto compression
algorithms we have tho.

>
> 2. Note that the zswap pools are also organized into a list. If you're
> adding a new data structure, maybe remove that. Or maybe the other way
> around - can use it that linked list for your purpose?

Also a good point, I think we may be able to drop the list, and I
think that's ultimately more valuable than the memory savings. It's
unneeded complexity.

