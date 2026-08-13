Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C56C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 21:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1557C6B02C1; Thu, 13 Aug 2026 17:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135AA6B02CC; Thu, 13 Aug 2026 17:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043BC6B02CD; Thu, 13 Aug 2026 17:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D43F56B02C1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:49:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FA821C0F95
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:49:36 +0000 (UTC)
X-FDA: 85097588352.21.FB7ACE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 656BE40007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:49:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DluAYf20;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786657774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrKJj0h69ZnqpSlfSWaniPIrhJ5jpOXeOgW2OjrlaoE=;
	b=XeSa/q0Wgm8u1MuwIrsmidzi3rqxciHsQD8szy5rbBCTZw3c+ClTHqrfMJEmIhsbGQDgIC
	C988ncblWiRAXoWRgc4IclxdHahZJdoMM+iAd8IIXmjYTl3xlAh+CXKTj0xzVYtMfrovAF
	mibAR1/TkVrUlQ9SLkFKL6tbhBw363o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DluAYf20;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786657774;
	b=jMHt8dRTxTrtObgvZlSy9LAtXeiAkfdnj4NuvMYntFfTrMAefaXNuGKFBBk5tDnNkriNmg
	1V7PS05fsWELDWMysic1Z/lQOa8jkj78RBWZcGFPbMhP7SHINHPRr0v97M0TtQq9N4u14a
	m5mjMiCMu92BzZG/xMboi2zu2k6Ti58=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A82443A75
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F551F0155A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786657773;
	bh=nrKJj0h69ZnqpSlfSWaniPIrhJ5jpOXeOgW2OjrlaoE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DluAYf20JKxs0BAHyTYt0u6fUGy4d/7Adr1XWfQgzb006IfWNcoKhwt1QKaxl71HV
	 AwwWhKYvTsB3RpL8GvI8pBadcQsfGHZBwPptLRm2iwpJdLNNfedej5llOITeW5Kj2R
	 bolx+VphoZ1UgNdZOjxXjCVchP/1VierEti3aH6jQMetbW4RE/Zz6eZTTLaG82mtpL
	 1FBCtY+Z8mRvlGiTGcnya1VrM/KB4BESlMdbOt/o4g6jgkr4jfF3Gos0E4tAd5mIOZ
	 l34PHJX2RQG4RQ3g5jQbEXj08sXKxL5IP/i4gLL+uGjijGUsF7/Rnl8/bl5iyT/MnC
	 Id9vVNyn/l6sw==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-90a80860d35so2803276d6.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:49:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoJiH6nrC/00PsuEBWutOLWjGm7a9fTs4iPkMveEq1TEjy7M+LyhGx4swuZwRoRMws2ewn6G8V47g==@kvack.org
X-Gm-Message-State: AOJu0Yw1BtGHix6x5sjhxFXX90Gq0fY6NZqeBSICZHmP99g2aDp/cutq
	sX0KB9rVn2mFFXeXm+vhuWHlZvyBMAf/3CNBeSzNVGZ1anLpUGLnv9mG7xoUoGsju2u9QApaCPw
	feQ5RsJjf/a2vNfZQlZGkyGz85Yk5vUc=
X-Received: by 2002:a05:6214:458f:b0:905:6e01:b9a3 with SMTP id
 6a1803df08f44-90a91e0b9cbmr10879026d6.31.1786657772593; Thu, 13 Aug 2026
 14:49:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com> <20260720-batch-tlb-flush-v5-3-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-3-db943a0d0d6b@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 05:49:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zOfR3Rn5tk_RcOWUDmREO1JyRwXA15Vr3aeUs=+ybMMA@mail.gmail.com>
X-Gm-Features: AUfX_mzaPnudjgTOkosyfjvDyy6egYkc8n3_Yoj5ziOiuw8_Z5htjHMfAfzoxAo
Message-ID: <CAGsJ_4zOfR3Rn5tk_RcOWUDmREO1JyRwXA15Vr3aeUs=+ybMMA@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] mm/vmscan: extract pageout_one() from shrink_folio_list()
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 656BE40007
X-Stat-Signature: nkm3z9qco9z9zprrtbha3fxkz6bpjyb9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786657774-301943
X-HE-Meta: U2FsdGVkX1/mAM1GbI4zc7nF5r8vhl/3ml8tNzP1EDiK0+1rPPkMxKxfbYXbeioVkbP9OdymPeDv/gYnEMtItjeSpQdM9+UCNLMHvMZw8GK0xxn4z8L0PoxKQP1u+9Ieq2f48FmY/MJRg1cUdeQmSA7gxZ5yQ2ebII68gsVxq3fHnD7XsJbyhUYrluwfk2Y5SyzWK7RmWX6Hk5c6oPbqpSCcrQNXqV6LQ9Imgqif14meLBA0IOq15EllWGxVdwWv786sccen9NtyH9ZijskoH51Xehb1HJfUOq8udya8xT7BNl0QZWsp/ij9KWTAG4aclPYrBzMAG//dtKMbjOsjcmdLyjWk8hQ8zKA/ug3/YWpoL59CN9J4GHTeTSDvwp8n96TaVBDnDV1DgbulbmvOP2gi0CBIHqkog9NkE4h7ss2U+BOx0Z6WoYCCayDHqOHqiumwJv7V8UyzwGdjWkt70rmZKZUZ6+wXBKpR09jKueZNh16quC/bwDzINaqyLpDhSMuRTaliEkKXac4iKXrCoUid8ue9PijaO/0VWcC1M0Ngk4p6cecZF/iNvuNsgvj0ryPd+O677Z92yw+JLvCzAtn9p7ji2UQUKmhM9DJPFeTfiuT7QUE2OqQQUWTweuBh1wthZfqYWg8j4lvo9BMs1jgYSNeJqyOhgBwpMv7igqPqsWfvQMKZ9AZppBsnZSkVw6Df1ZZF2Q84dqrFPD3R/z9+54qDQesphR/Oa0XtwLn+nvu/Q1QA1DgMX0Q5VkYePStJOm2a/zvCzn7L2A7po1Ed5+A4cR29jp31+wjrBH4UXXs16HOKau8LMGc3PklXSIenmGShlNe8ac3AgxVUnu7D2xgyVi5U2oZu5rW94WCDTG/us5R6OGudJZNepXO9JkjWKQPRok0yFRiZvzTw5bbk3N2kQbSMg7ovz5Mqum79jKFr2BMJ3w9za9C+5GIhcQwnddh6tTaJWBit1EB
 3r9q5NC4
 63uG+iWUO+mIjXJXc7iNDlkQtv5PizfxKEoeBfJbmlMD9cnnP1kMQt7CFHa9kpr0XJOGN8SK2m4w8+GlxowH2dIvaPQIle+cY41n5Po//AkEVQc9ZZ0CFp9/XvCSN9ScuoiCkFwEpmI6QQgv3OXE+6HWBQ13LDrp3etgH8hDNQF3hjVVSz91PNxUpaatUNXUQLMXHwHBkGiebuVSiM/Sy0TllDxqZUfn2NyXVYoYHQ7mm8+OIUHnkhQxWFjbp5WjlQljypAbI5zSR6YXFjH8LeD922nbcWawD/iGshhCpBnOi7LB/S/mWn17I7GuGcRXR4bXJON4SX95ybLTM0Rcgkk8y9VOU1S4HHLaLJmhOgnJNtygLMeoFCs+h6rtLDa7v7yEz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 1:08=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> shrink_folio_list() contains a self-contained pageout() dispatch state
> machine. Extract it into pageout_one() to reduce the size of
> shrink_folio_list() and make the pageout step independently readable.
>
> No functional change.
>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
[...]
> +                       if (!folio_try_pageout(folio, &free_folios, sc, s=
tat,
> +                                             &plug, folio_list, &nr_recl=
aimed))
> +                               goto keep;

Also, this patch looks basically good, just like the previous one.
Could we also avoid hiding the activation semantics in the inner
function? It would be clearer to make the activation semantics
explicit at the outer level, so readers don't have to dig into a
deep internal function to realize that a folio may take the
activation path.

In LRU, we have two distinct possibilities: activate a folio or just
keep it. This is an important semantic distinction in the LRU logic.
Hiding the activation decision so deep in an inner function makes
that semantic much less obvious.

> +                       continue;
>                 }
>
>                 if (!folio_try_reclaim_free(folio, &free_folios, sc, stat=
,
>

Best Regards
Barry

