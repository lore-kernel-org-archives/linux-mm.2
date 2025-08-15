Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B346FCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 22:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9C46B027C; Fri, 15 Aug 2025 18:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1266B027D; Fri, 15 Aug 2025 18:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5AD8E020B; Fri, 15 Aug 2025 18:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 117206B0643
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:42:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B446D1602D3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:42:44 +0000 (UTC)
X-FDA: 83780467848.02.A8975FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DD15AC0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:42:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkz3Zbdf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755297762; a=rsa-sha256;
	cv=none;
	b=Azb7icsg+BXb/gQNLWB7ZqXW7y4w7PeC/SYgXzf2reIfbNFb36AxbhfaApbf6og5qAuRst
	uflAFixFs0rFcy8Nw8vtwy7Dgmt1XQ9DOQrpeus289YM/HBjUFYbaWAh6YdvSonLZIZofz
	LsinfUUOAscLKYUu5VpwQwNTHUSDTEg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkz3Zbdf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755297762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmNKpXV6F1ufPkWgoTk31tNHiYahxKYmUsoHxcoDQcw=;
	b=uaG0I80725XGjFV7/Ogd/vQ9Xe3zCD5HYnet1b2qCprUe8xI+fY96pkebHnnbFwAP9Br66
	CDhQhet/j2UJRzKd04LIW4V9fKVVMnBNzlmKofoiGkK5fgoi5wW0671pLCfLzlk42JZnJ3
	4nZVQYYenoaqbW7ZchC6Jc4h3bEsV9E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40DD46141C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92EEC4AF09
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755297761;
	bh=YmNKpXV6F1ufPkWgoTk31tNHiYahxKYmUsoHxcoDQcw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fkz3ZbdfZwILOWaqwjlgpJPSux7Kmz0kBb+mhc6VeDFOlwbmPfS+QgkFe4sCpqUaK
	 LM2JToXVS0AoQ9RAggYIIYI5v+LobXoktEYyYacsJx+LiUY9BcvHsXPboWcHenromQ
	 7VxKQN+BcfHH2XrNbYgAcHMrlrzEGzQ7dJGyb2b+kXN9460KIbXxla3vRMF48yG4vr
	 s+Xjvj82yHTAF6h9O2kRxBs+XJOIJ9KFakaKghOo9SWvWb3lr0Lsh06nnjG9Hh8PIM
	 B8gGsQfMfPqiwoLe4LY95UN0IxDAI51AKsbVRWL9ifJE7wz/patVD1LgYEVQSoAnO6
	 ZoeDjIEI1p6bQ==
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-459fc675d11so9725e9.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:42:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVRDGuQ2AaZSon6YZe1b3S1/6avz8mlrqVmkPjwMDFpKE2vZSS1DBg7ySzqflz5wo7LdZ9dZKOrlw==@kvack.org
X-Gm-Message-State: AOJu0Yz0CJHrJa6YpDN91vsoU2j6P0v5nvfBItMcark8+IouFB6io3ND
	LRTjnhXgmmDqGtf7HuyBoowT8yLWD1D3oWU8L4/5c+D7V6yOYqWjfsPzWKznW8xnQgWWhB11bfj
	GzwytSe0+btvkhpgS1iOrK2rd6MpWvtwvv0Zfv3iz
X-Google-Smtp-Source: AGHT+IFNk5da7XaAM+/ANdl0I0NOeA18DEJrxF0sOna4KC5smln9g8k/0ZOuHnYlCfXg0UdOUq3LmP4nrSW3Y2IvPG4=
X-Received: by 2002:a05:600c:870c:b0:459:d7da:3179 with SMTP id
 5b1f17b1804b1-45a26f07dcbmr155955e9.5.1755297760615; Fri, 15 Aug 2025
 15:42:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250812170046.56468-1-sj@kernel.org> <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
 <uo6vtumoy4txklyqy4njitf5ex4eanudncicbbzknmuowopd7v@jm4ao4qapiza>
In-Reply-To: <uo6vtumoy4txklyqy4njitf5ex4eanudncicbbzknmuowopd7v@jm4ao4qapiza>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 Aug 2025 15:42:28 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNRTTaFxa7fOJi-4QcQfb2ydvfnQVz1_3fKmo-v__qGsg@mail.gmail.com>
X-Gm-Features: Ac12FXwdNeuamxbqZnoUCF7dzA-ckXSYAzpoX9giTHu9V_MAXpUzgnrqkH0RsDU
Message-ID: <CAF8kJuNRTTaFxa7fOJi-4QcQfb2ydvfnQVz1_3fKmo-v__qGsg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DD15AC0007
X-Stat-Signature: 9agajnrzeixq5n3f648e4pippqje1f9z
X-HE-Tag: 1755297762-192560
X-HE-Meta: U2FsdGVkX185K/khhiJnPw9c5gd4ZceMFkeT7LnBrODpw0U/g/R5J+XP/PXTfY0EFjEc8nrTZENs5RO8yHJMIDWuueve9BcmbIz8om2fHEsDb82h4eM8ZtC6q5VOqVsEo7ctUCeOf2YODYbz366krALfYh+FqWjk3u/71cCG8kjIOjiNlpXm8PIjw0DEt7l0OLNQGBrTk1f7eFYRsWDRwAKC6DfcbK5eCWrxdfZkcgBkSD9UGSmrZcHu9G3imc932wvi0pmFfp2p+roffzcPqu7Gh88Cqyie/wcRFK9NXTJxr/XUR+MpD99pYT8xd4WcqVYGFdT6QHpTDOh2hZHERbhD1BwPIPAlCjunDeKm6Qxmc0uzRpz0boUFTRZziICAgB8/7RQVaD+lTtWW9zGa9kev+sir9Omc4OL/oe2RJPBscBv0uuuC8v+fb4zcdfd5pPePhW96lf4nJH9jLZyEIg/HQRuWDlmjdCXxHCuqQvGrAa3YZY0gBViMtuKwoxayp9YPvu0rCkUD3mkOmGaE7FF0UYzVwrUXgPqNT79ckSVrVPZRIzhSM5NeImQU8bkcBD+nQxhChbrzj9miPFtDt3HxJA7w24XXLDCbovLIOIvksyb4K8ndR5Z2qr0AplqVUiCb7eF7lWY5ah5ACohRe125ywBYHjrm4+WbDHkxn/YswBlWuuoZ4NRcHk7+Eg5FGT+uQXtcjqMknnHgcQJomdFwD7VFv7+3QthceW0sDRadf8UOCe4h6J2Uyy7ePvRGYykYrBwNn8j6t4CZthxjztm1VcRAeq5k2qLKIO5dYhPPAlTnIoRG9VdoGGgpwMQ6NoXGHWUUyVvkHvjSRSWh/ZiSCYDZPm5ZbN6T/B7KIGR2Ngaz4t1HtlwRxq4OwRJhVq/Y4Tlm8H50EQRpJNrW6w+kz3qxA/4PSYWwWUZbEvNhFqO9B8qPNv0Pw25Havwm/5x8KXwC0eVgbroKdQJ
 rkiC/Q+B
 I0KvVrEvcgAuTXzw68iSWCkI4+NCEsR4bE79s7SSt6ofCLdQvygY10tz0Ivg0ZmJXnhEkefldADdcw47OIhPqPNJD42wYRD55WNH5oFR/kehiHDtrQdF6ra4mrdvGLQ7Gjt6t7My+lENtYEv0O71ATeaChRf2A34Qz+7bxIhNrG/KlJDZybhhzvvQ4UvkNPfPvPkPWW5Bat7uymr/jLHeL0u36uFlnA34KqZUB1mea7Tb7FQLKpR5L2IlzsRGcfejL7AS2Ajxj/UWsnw9HPQxtvuXov+YAjPHfCDCk+QHRXZRcrmEuAucdUfIFuCZG1aboxGq3QQvDEpQr8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 12:42=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Wed, Aug 13, 2025 at 10:07:18AM -0700, Chris Li wrote:
> >
> > If you store uncompressed data in the zpool, zpool has metadata
> > overhead, e.g. allocating the entry->handle for uncompressed pages.
> > If the page is not compressed, another idea is just skip the zpool,
> > store it as a page in the zswap entry as page. We can make a union of
> > entry->handle and entry->incompressble_page. If entry->length =3D=3D
> > PAGE_SIZE, use entry->incompressable_page as a page.
>
> The main problem being solved here is to avoid the scenario where the
> incompressible pages are being rotated in LRUs and zswapped multiple
> times and wasting CPU on compressing incompressible pages. SJ's approach
> solves the issue but with some memory overhead (zswap entry). With your
> suggestion and to solve the mentioned issue, we will need to change some
> core parts of reclaim (__remove_mapping()), LRU handling (swap cache
> pages not in LRUs) and refault (putting such pages back in LRU and

No, that is not what I have in mind. I mean store a separate page and
memcpy into it, keep the swap cache folio still reclaimed as normal.
Not much different from a store in the zpool.

The cons really are migration etc. We might have to get it in zsmalloc late=
r.

> should it handle read and write faults differently). So, the cons of
> that approach is more complex code.
>
> Personally I would prefer a simple solution with some overhead over a
> more complicated and error prone solution without overhead. Or maybe you
> have a more simplied approach instead?

Ack, there is more complexity to get the last bit of performance gain.
Maybe in zsmalloc later.

Chris

