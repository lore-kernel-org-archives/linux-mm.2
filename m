Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF83CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA49F6B00D7; Fri, 29 May 2026 14:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55726B00D9; Fri, 29 May 2026 14:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43FF6B00DD; Fri, 29 May 2026 14:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94DB96B00D7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:07:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D9691A0236
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:07:11 +0000 (UTC)
X-FDA: 84821239062.03.62603A0
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30A6D2000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:07:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PsFNyGWp;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780078029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZoHrQ02OOCar3J/zEZO4IwdNcb2UEkvFMGplj3lU9g=;
	b=MMMFtf5VpljxRagx797FYjTWipEOXsLztC+7HaY6wdvi+lPBfotU/FGD0zu5UwCy1Fu0Ma
	hafejAA/3yqyPoFaiNvrwBfal7CDdn8w5O+Wl4Izd/FizcxA5jEC7asGGaEPQUCOh6HuBc
	wQDPwUYM4dMiDdbOd6irjN/bLUZ/5LM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PsFNyGWp;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780078029; a=rsa-sha256;
	cv=pass;
	b=AbFk8f9w/6iHQo98c3IcktaK6Y4YuX0xK3g8AVQodEoMmBV9HZk0HhRuRdeuVLJUQK6w4y
	nLkub06IyVWtexrKdftKriW81s2tJL1XmpPnry04qdZdPGZquGvWylx+OIXJHjUfE6IX+h
	ENUMf4+ZrmgR211Ksqfx2pZptgVuS4Q=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45ef1198766so611274f8f.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 11:07:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780078027; cv=none;
        d=google.com; s=arc-20240605;
        b=S23O2V2AAFswCPKqE+zdFYBDug6fxIDnPoZ7lviUNosnX9cA78j+LSSmWXTrhsNdim
         NGv4ErI4uYN0hPYqG7VXlZD67ZHAvdgl4ANaRTY6c8dc5z8Xw4YZu3LRZuO5lC8wCLSq
         wXJ1yq2YHg1ZeaWzYsgQHJJIemAy80awCDca8tQB3BkMNUk0KhCEYbBnI94Uby7Go0pq
         7qFpo/7o0NXJPCidRU6y8fQ1FZEjSMpOU8f5O7Gb+92yfIbpExF95gfwaW9dqA1JX2qt
         8xHagXRMHceuvQ5WxTv2vjGMRf1SxcAP/ect+H1eDrRu7ApLuRTLYn6ZOT/wLnDOY/6z
         Z1Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MZoHrQ02OOCar3J/zEZO4IwdNcb2UEkvFMGplj3lU9g=;
        fh=4cjbSOsUVS2DQ4ZvnpIux/FhQUyJ+NQYuzXTFSJvMuI=;
        b=ZfAZ4p9TThTiXNKd3QczpdMQD3bTRIxlZJYPbsJJtErPOgzKiIuronp1XJ1/Sre6nr
         V1tJzXnKGKTafbIO0jYipUvsoj8x8lhQ1GlNZGPGeiKwEMLwIf57WJvc2GHuMez2AKQ1
         xead5pRg8BrLHWzVHTphUGMmNHtVoe2yME0mmDnmvDjWSOsTZPxzAoqI8Tbv7MA1tWV6
         SWIX/3DayyNO5kwDX3hFG+yS7dR2jlvsPRyhkavmGL/FALOTiN3UgYZTb5A/9b2Z8JtM
         hXX7aueTShwbgMRqOVFcvJ9P/aYjWRPaKk8bkt9sY1CiAJ6HUPza2lMc7Wv9N0wJNbhy
         xqkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780078027; x=1780682827; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MZoHrQ02OOCar3J/zEZO4IwdNcb2UEkvFMGplj3lU9g=;
        b=PsFNyGWprvc3eJMnSW19DEmxrgkjMCCmW8JHuLQqOsvDz+NTXow8JdaRnTfPFLJlR6
         68km/Gh3HWNgNgG67EtzRo6mFLCZYJnZiedqpBXggsUzw2Ax2KYFlB2Wp/YPL6OY63OQ
         M3ui0RPom6VsCK5tV5nHADCQw6pAl4ilUE44vh1r8g7KY7DHXuvpT67VRFll+W/XmrG1
         cVus4RPhV13L4jVZurrBbh3uNWgbx1xweGgRzJNapuKDjkF3TZm37rYS4dtkKTWxoiPU
         oYuxC7kFg4OLc/+FTAbT23k9YTOOFYBZOul2Dv1VxSO5g1EwD9LTOKmW1UdU1bZL/5fh
         /GUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780078027; x=1780682827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MZoHrQ02OOCar3J/zEZO4IwdNcb2UEkvFMGplj3lU9g=;
        b=CobuHQ0r8CI4um5bnWChL6frWX3/J6CujcHjRAPYS7YEVTphRdKUigG6lXCbsktoDm
         /eCsF1cjuYETcQzOvTTQi7n7TZshpam67/KGwA9+ZwYM030auijKthw049NPpejQEf1A
         VU7mGtO9wTj2ZgbNrNXncEKIj2XrFug5d4RMlWHjSpafWqFsfg9++yS+YOmi7HbLnAmG
         hgOtTzpJeAMMcSzMPJ5I10XdRGP3wihD0w+J8QFbqtth7OlK9bwzEHWUCaL/4uRUP5W6
         MokUX5u7aL65g+rRR2/9/uScA3o4Yl/rL7oyc9ptkU/XwJwfLDIdTjsuEoRZW+FugTIk
         +hCQ==
X-Forwarded-Encrypted: i=1; AFNElJ86pBNdp82JqDHmoUoX+V8cm1EOcVyIvw1KTPELtMd5vXdBxO07BmwXhu19Scb99p73u+9mOuApJQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8BxFzSUQUMFWiFs5q/CxK41w9EJfISp9eX7tmsjQ6CS2uHkni
	FnL1/lIt3RS+/Vh1rYAO1e6eFoYJq+P1cFHV66CuhGhP8reKo6g3KdokGZ6LqrOgMcIIp6jx9ub
	lP1pWh/8/114Zy33F2vFoM9ptLwtlRn48QNtn
X-Gm-Gg: Acq92OFcYyjDeXPo8c5KYmqJ0mXsi/7mp3SdAEE+MXj23c/oK1Ba1SCT/toiBaHGcf3
	WYdqs8EdNKmyZRXMxXPyfKrsUK6jo8eUOYohhV7sPkAZC3GJKS+uNaq5e/7vhLeaGcA1nAhvnj2
	ozqkADRjm+/1Zsxw2q7Ee0+bXquaHGDbdZ104EBilK5Qj8ZU7vpGo8AqWiYrvgwQut0eSbdvzS3
	RCeib2RuQ7/ndW3n9fjslerHuVwzpW52HI4GZvkCnW/HkNTYdKgEH85UWAoH//9KwjdNYARu0OT
	OY/wgh3e4qs0IUbjiiBJUqTCQfP9HMcqjTWaGP6DD+LAtP5MeQ==
X-Received: by 2002:a05:6000:1869:b0:45e:8e69:955a with SMTP id
 ffacd0b85a97d-45ef13397c2mr6590756f8f.9.1780078027311; Fri, 29 May 2026
 11:07:07 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 11:06:56 -0700
X-Gm-Features: AVHnY4LiKS9AOV875xFexbH0858oyjx1YBqN9AQEaDywp-8XC4Ly2QmE4FmtL2E
Message-ID: <CAKEwX=PdQb2nDbFaZYuRa9_mYrMCnMEJHpxxABebKkVz+OgDHg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/9] mm: support zswap-backed large folio swapin
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>, 
	Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8gu4s5w5h1ixrfqcqci59khbrtxuy6k3
X-Rspamd-Queue-Id: 30A6D2000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780078028-800266
X-HE-Meta: U2FsdGVkX1/wsCdwkDcJC4MBZtBajL8h91ZzZe4Omrm7REzg1QpXmX/RaReDVzw+oCQaffgYv4qoZUKmIb7yD2QcqN/mJRPYms4rViZ6uZVUTvRaa9474flDyFGVKgy4Co/FAjVS7RUgFXsEie6OHMJEwtrqk9uKMY5JkrJGOoZmIZ9BosZToPF3k1vxy5zQ4SYV64zbQpxWAod6ASR3RkYcYIJ803uMThvQDJ3m06eAlANqY+v11RVzcLPbNFO3ZSXuzMdRUwlM46/bH5lVXMez3Ut023XbYOilYuZD3XzfmY5SEJdVE580+Ft24nCVkeS8b6hDtRHG1HDZzyKqrT2HJFO6EMOoJE4zMHmiiVUUyVtiQ3MROX0+N5dHXizNVAZDgosyQzoO1fh6I+tmZGtaAoelcrJRv/b5MqitBgW5Gz0iMxPXZcjFO2GS2I4Ffq8a8QDsRaOCLu1k2QFEv66iu34E5A9UuqJqlgLcxhdHlHsuHzKBWgfql4r+XhY8seRH29WtiisYEfusXhFLQweBePTpDeAVCAXyAP/pjeSy3H5FPyyKwCwZCQU2q0NawkWAdbZMAGYgFj5LzTsENU11RuPoRPF5LzeAi4GoAbi7cd68JqA1AIwyFfOaAgrNxh4A+vy1bOoD2NdLVBfIOsEXpV5aKZw4Yb0pyybxcdWMjCmyXtTOYy611ptN8LZ40IpkduAA2X34VogBoYK/oQbke1IZEWeh+/BmrReAKZK0E6ViRKrLYFYomIqt7Z8RJXpIIsKfv79uFbtFP8HevDhW9ePZO3YtSEOKsvPYGw3YpYvcB2Z2+REZxttUMreoDhZDoKUAKwwZ5jxd2UP2GhAT5fTHe1/oReT5SkKVbp3JeWs8x50VXrNwTi5vy62fgPJ9F+iG44MVLCjh+m3z/ImBN2pxm3VmzznvXR310vtao7tufAiwuJGpALfmnfSzrfFWGHPdubR2TH3tNv9
 kJNfkd/H
 OjBB4xkznY2gR+aG0u+qZh+K0mcF+42/2CbG3FNUlyRLEufw9f++rKgRJ4v+R4oTQqa/bKrihwRoIOxHf7MwPU0pj3vbsSIcKEiPQ+4lNhYXte7OkIx5PQ9Lr1bgHxk5pDAw+rizGI3xExN9/4ci1ZgKM+WhrTPkGUejwUfIcqJsoJWrU71lH45ems6QY5Qud9rTfATf9jyzQfXvFj8INbpmtiBqrPyuJZueCcKOjvazYuzdb3zuIqjjxCVSwzJ6AvVlTh/4rhYKrlx8LNodnouvrPTg5tHOMrnyvazTtwdz7BsQdaT/fFqzgW/ZjkSH7IRsSzNWBU0UGzi4EUXZ2DElbji0rsx4qwdYAsYvSFaRARI33NcIH1wUo2+cczzpcgbHAgnYXQJwc6l4ZWmeSHlaGCR8qO+TL+B65eXGtQGf4Az65UgNJLRXBxeg2TU3SWkfWPX/uIsuqktsCAFSSm8M3Qd5FAx9lW/Zh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 5:17=E2=80=AFAM fujunjie <fujunjie1@qq.com> wrote:
>
> Hi,
>
> This RFC explores large-folio swapin for ranges that are still fully back=
ed
> by zswap.
>
> Large swapin is currently disabled once zswap is in the picture. Anonymou=
s
> faults stop considering large orders after zswap has ever been enabled,
> shmem does the same, and zswap_load() refuses large swapcache folios. Tha=
t
> keeps mixed zswap/disk cases safe, but it also loses the dense case where
> every slot in an aligned 64K range is still resident in zswap.
>
> The series keeps the policy in common swapin code:
>
>   - zswap reports backend facts and provides the large-folio load helper.
>   - swapin_sync() filters candidate orders by backend range.
>   - all-disk and zeromap ranges keep the existing Kairui large-swapin pat=
h.
>   - mixed zswap/disk ranges stay order-0.
>   - all-zswap ranges may use a 64K folio after locality admission.
>   - anon provides locality evidence from VMA hints and PTE young density.
>   - shmem starts with explicit VMA-hint evidence only.
>   - swap readahead uses its existing VMA/cluster window as locality
>     evidence; it does not also run the anon PTE-young rule.
>
> The backend range probe is only a snapshot. If the backend changes after =
a
> fresh large swapcache folio is allocated, the common path drops that foli=
o
> and falls back to order-0. zswap_load() can also return -EAGAIN for the
> same retry path. If a late fault retry keeps the large folio in swapcache
> instead of deleting it, the cgroup v1 memsw swap owner is committed befor=
e
> returning.
>
> This is mTHP/large-folio swapin. The mappings installed by do_swap_page()
> are still PTE mappings, not PMD mappings. The expected win is fewer fault=
s,
> batched PTE/rmap work, and preserving the large folio across zswapin
> instead of rebuilding the working set as order-0 pages.
>
> Prior art: Usama Arif posted a related RFC on 2024-10-18:
>
>   mm: zswap: add support for zswapin of large folios
>   https://lore.kernel.org/linux-mm/20241018105026.2521366-1-usamaarif642@=
gmail.com/
>
> This RFC keeps the same broad goal, but moves admission into common swapi=
n
> code. zswap does not decide the policy. Mixed zswap/disk ranges are
> rejected before large IO, and the first cap is 64K.
>
> This is a rewrite of the RFC posted on 2026-05-08:
>
>   [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio swapin
>   https://lore.kernel.org/linux-mm/tencent_8B437BE4F586C162950BF71954316C=
1EDB05@qq.com/
>
> The v1 series was anonymous-only and kept too much of the policy near the
> anon fault and zswap paths. This version is rebuilt on top of Kairui Song=
's
> common swapin infrastructure. It keeps admission in common swapin code,
> rejects mixed zswap/disk large ranges, and adds separate locality produce=
rs
> for anon, shmem and swap readahead.
>
> Performance and behavior
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The A/B tables are 10-run measurements. Elapsed values are seconds,
> shown as mean +/- sample standard deviation. "phase" or "refault" is the
> measured refault subphase. "zswpin" counts zswap loads. "pswpin" counts
> swap-ins from the real swap device; pswpin=3D0 means the refaults were se=
rved
> by zswap even when a disk swap device was configured. "RFC 64K" is the me=
an
> number of successful 64K swapins.
>
> The numbers below show where the large path is used and where it is
> rejected.
>
> zram-backed zswap microbench, 64K mTHP, 8G guest:
>
> +-----------------+----------------+----------------+--------+--------+--=
------+----------+
> | workload        | base elapsed   | RFC elapsed    | delta  | phase  | z=
swpin | RFC 64K  |
> +-----------------+----------------+----------------+--------+--------+--=
------+----------+
> | usama_1g        | 11.260+/-0.235 | 10.301+/-0.140 | -8.5%  | -22.2% | 1=
.000x | 16381.1  |
> | nohint_seq64    |  4.398+/-0.085 |  4.025+/-0.022 | -8.5%  | -21.1% | 1=
.000x |  6221.1  |
> | seqhint_seq64   |  4.283+/-0.060 |  3.948+/-0.062 | -7.8%  | -20.6% | 1=
.000x |  6223.5  |
> | stride64_sparse |  3.095+/-0.051 |  3.086+/-0.025 | -0.3%  |  +5.8% | 1=
.002x |     1.0  |
> | random64_sparse |  3.095+/-0.046 |  3.076+/-0.016 | -0.6%  |  +0.7% | 1=
.001x |     0.0  |
> | random64_full   |  4.423+/-0.067 |  4.405+/-0.018 | -0.4%  |  +0.1% | 1=
.000x |     0.0  |
> +-----------------+----------------+----------------+--------+--------+--=
------+----------+
>
> The usama_1g row follows the shape of the 2024 RFC benchmark: allocate 1G=
,
> fill it with compressible per-page data, reclaim it through memory.reclai=
m,
> then time the full integrity-check refault. The seq64 rows use a 512M
> target and 768M of pressure. "sparse" touches one 4K page per 64K region,=
 while
> "full" touches every 4K page. "seqhint" uses MADV_SEQUENTIAL; "nohint" do=
es
> not.
>
> Virtio-block swap device present, zswap enabled:
>
> +-----------------+---------------+---------------+--------+---------+---=
-----+--------+---------+
> | workload        | base elapsed  | RFC elapsed   | delta  | refault | ps=
wpin | zswpin | RFC 64K |
> +-----------------+---------------+---------------+--------+---------+---=
-----+--------+---------+
> | seq64           | 4.399+/-0.100 | 4.279+/-0.216 | -2.7%  | -10.5%  | 0 =
     | 1.000x | 3110.7  |
> | stride64_sparse | 3.103+/-0.047 | 3.119+/-0.086 | +0.5%  |  +6.2%  | 0 =
     | 0.999x |    0.0  |
> | random64_sparse | 3.142+/-0.112 | 3.097+/-0.030 | -1.4%  |  -2.2%  | 0 =
     | 0.999x |    0.1  |
> | random64_full   | 4.473+/-0.147 | 4.445+/-0.088 | -0.6%  |  +0.9%  | 0 =
     | 1.000x |    0.4  |
> +-----------------+---------------+---------------+--------+---------+---=
-----+--------+---------+
>
> This run uses a real block swap device, but the refaulted data stayed in
> zswap. It covers the all-zswap hit path with disk swap configured, not di=
sk
> read IO.
>
> Virtio-block pressure/mixed run, zswap max_pool_percent=3D1,
> low-compressibility full fill:
>
> +-------------------------------+---------------+---------------+--------=
+---------+----------------+------------+---------+----------+
> | workload                      | base elapsed  | RFC elapsed   | delta  =
| refault | pswpin base/RFC | RFC zswpin | RFC 64K | fallback |
> +-------------------------------+---------------+---------------+--------=
+---------+----------------+------------+---------+----------+
> | seq64_full_pressure           | 5.908+/-0.195 | 5.790+/-0.235 | -2.0%  =
|  +3.0%  | 90258/99038    | 20327      |   0.0   | 3730     |
> | random64_sparse_full_pressure | 5.104+/-0.069 | 5.068+/-0.090 | -0.7%  =
|  -9.1%  |  6201/6196     |  1297      |   0.0   |    0     |
> +-------------------------------+---------------+---------------+--------=
+---------+----------------+------------+---------+----------+
>
> This run reaches the disk-backed path: pswpin is non-zero in both base an=
d
> RFC. It is mainly fallback coverage. The RFC does not install 64K folios
> for these disk/mixed-heavy ranges.

Ok this results above look good. Basically, if we don't have spatial
locality in access patterns, we don't do THP zswapin. Nice.

>
> Policy matrix, virtio-block swap device present:
>
> +------------------------------+----+------+--------+--------+-------+---=
-------+
> | case                         | pc | hint | pswpin | zswpin | zswpwb| 64=
K in   |
> +------------------------------+----+------+--------+--------+-------+---=
-------+
> | pc0_seq                      | 0  | none | 0      | 99559  | 0     | 0 =
       |
> | pc3_seq                      | 3  | none | 0      | 99498  | 0     | 0 =
       |
> | pc4_seq                      | 4  | none | 0      | 99512  | 0     | 31=
09     |
> | pc5_seq                      | 5  | none | 0      | 99657  | 0     | 31=
13     |
> | hint_none_random_sparse      | 5  | none | 0      |  6265  | 0     | 0 =
       |
> | hint_random_seq              | 5  | rand | 0      | 99488  | 0     | 0 =
       |
> | mixed_seq_full               | 5  | none | 97725  | 20147  | 84    | 56=
9      |
> | mixed_random_sparse_full     | 5  | none |  6230  |  1302  | 0     | 0 =
       |
> +------------------------------+----+------+--------+--------+-------+---=
-------+
>
> The pc rows show the readahead-window gate. The hint_random_seq row shows
> the explicit random hint veto. The mixed rows use a small zswap pool to
> force disk/zswap split backing; most mixed ranges are rejected, while any
> remaining 64K successes were all-zswap at the time of the fault.
>
> Kbuild pressure, zram swap, 384M memcg:
>
> +----------------------+----------+----------+--------+--------+---------=
-+
> | setup                | base     | RFC      | delta  | zswpin | RFC 64K =
 |
> +----------------------+----------+----------+--------+--------+---------=
-+
> | zram swap, 384M memcg| 2060.323 | 2047.516 | -0.6%  | 0.991x | 2797    =
 |
> +----------------------+----------+----------+--------+--------+---------=
-+
>
> This is a single-run zram pressure smoke. It did not show Kbuild
> regression, and the RFC run installed 64K zswap-backed folios. The result
> should not be read as a tuned-performance claim.
>
> Kbuild pressure, virtio-block swap device, 512M memcg:
>
> +-------------------------+----------+----------+--------+--------+------=
----+
> | setup                   | base     | RFC      | delta  | pswpin | RFC 6=
4K  |
> +-------------------------+----------+----------+--------+--------+------=
----+
> | disk swap, 512M memcg   | 1420.671 | 1409.263 | -0.8%  | 0      | 7497 =
    |
> +-------------------------+----------+----------+--------+--------+------=
----+
>
> This is a single-run pressure smoke. The disk-swap Kbuild run also stayed
> on the all-zswap hit path, so it is pressure coverage with a disk swap de=
vice
> present rather than proof of disk-read large swapin.

Why a single-run?

>
> Shmem smoke, tmpfs huge=3Dalways, 64K shmem mTHP:
>
> +----------------------------+---------------+---------+-------------+---=
-------+
> | case                       | refault hint  | touched | 64K shmem   | 64=
K in   |
> +----------------------------+---------------+---------+-------------+---=
-------+
> | nohint_seq                 | none          | 65536   | 4096        | 0 =
       |
> | seq_refault_hint           | sequential    | 65536   | 4096        | 40=
96     |
> | random_refault_hint_sparse | random        |  4096   | 4096        | 0 =
       |
> +----------------------------+---------------+---------+-------------+---=
-------+
>
> That matches the current shmem producer: explicit sequential refault hint=
s
> allow large zswap swapin; no hint and random hints do not.
>
> What this RFC does not establish
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
> The 64K cap is deliberate, but it is not tuned. The anon PTE-young rule i=
s
> only anon evidence. Shmem has the framework and explicit VMA hints in thi=
s
> RFC, not a page-cache locality producer. For larger orders, the anon
> producer should probably use bounded sampling instead of walking every PT=
E
> in a 1M or larger candidate range. The mixed-backend tests cover fallback
> behavior, but this series does not add mixed zswap/disk large IO.

The mixed IO can be deferred, but I think we should figure out a rule
to extend this hint to arbitrarily sized ranges, and preferrably shmem
too.

