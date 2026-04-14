Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15031F9D0F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 21:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6236B0088; Tue, 14 Apr 2026 17:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96CE6B0089; Tue, 14 Apr 2026 17:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60B86B0092; Tue, 14 Apr 2026 17:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C19706B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:00:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 722C2E2D84
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:00:11 +0000 (UTC)
X-FDA: 84658379022.03.9659C28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6CF724001D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:00:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HS7YjAe0;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776200409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/y7pq0EJ1jaov65+vGohdk0BJsP4QYKsTDYLpDxD/Oo=;
	b=NawBnxX1rj8pVNvK44yjnuFVcscs7oIg0E2l+Y2+thqaNPuBltpnGZIKWGhC/g+8eZaeBu
	OU1Em37gjJus50Ja2KxqfZCM+hiKVeZ+cEQHNHG2HHvk4IXLkvbaV4C7N8L+kUjjozHd0P
	X+TPht0ZuIyN3e2Oy0FQQcqh3DJXSOM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HS7YjAe0;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776200409; a=rsa-sha256;
	cv=none;
	b=svrEe8oETK/ecIx1hKX4MiBQKE+wac6yiR8KzIp26La3hLDCT8vnRmipEGV5xUD+U8pWNf
	iPvbX1shhdn+29BAit4Lr6KvHGvujYUL6xkxR4/6rHhRUh6ACrvOAepFAnm8WAPgfLS//F
	n1UjRpR5J4TQsS7esGen1ER675bxlO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65A0B44288
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E740C2BCC7
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776200408;
	bh=mduecyo9txtQyzrRbR5Q2G7rVYfbP1Zo16EDOJNGpp8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HS7YjAe0WuuJf++7+e1yek2cH/BMiQtp43ZcCP+dD4Y3M5NFATlRdfpmojwnoA6cc
	 +wf7BMjYx6qoelFhPLjQoAkzbIeszS5cg/mo1mcTwFG/CxT582IXLRfMJXs3DYNseX
	 VZqdyHvBHOxZJAMgFmt8Xz3HiuL+GfhbY46twIgeyHFBVazl7/bSDQNBLLBOg6Eh9X
	 FrSbFzGiM7JA82lZY3DwhfJ91xIVaVMAEjCR6HY2GFP5gN0M0+rfuh9nytg173Lzf+
	 /mAcMlpNokgD1OzHUBHM1ekpjZPjabsnZSzOP3nd/6c4nUNB7QRqeHHWWlrpHit97l
	 qaL2saihF9SBA==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a032383008so68153496d6.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:00:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+eWX9qV48kKJL+Chk+2m1QmUiAPg98QHV6q1N1mglE+EhUP1U2Uzr8XzZ/9uoU9t7Lf9ZwmGPojQ==@kvack.org
X-Gm-Message-State: AOJu0YzLKYvfPAPMd/gM8M+Y94AouYnr8xkFZSKvUt2ubKGeXxowJWt6
	nX0oXft9drdG3rKjKMM0vyPg9vNiuTkFe0PKTQl0HUvltd77wBn7qnlO8V1Zvqv3AYv1PEWWO2x
	Oiuf0gQf6/+w05+O4n6ziJE90Bmx4BF4=
X-Received: by 2002:a05:6214:da4:b0:8ad:bccd:94cf with SMTP id
 6a1803df08f44-8adbccd95c9mr73153366d6.18.1776200407210; Tue, 14 Apr 2026
 14:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260414065206.3236176-1-arnd@kernel.org>
In-Reply-To: <20260414065206.3236176-1-arnd@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 15 Apr 2026 04:59:53 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xWNzjpMZTNThijdix6nKAsZPkPBazT7JJpsVyNFTJkSw@mail.gmail.com>
X-Gm-Features: AQROBzD5UaAc4n9tOLGFa-kWgR7p4d77lr5y8E1TxejXmChGVIRzd3Ozk2hXIN8
Message-ID: <CAGsJ_4xWNzjpMZTNThijdix6nKAsZPkPBazT7JJpsVyNFTJkSw@mail.gmail.com>
Subject: Re: [PATCH] [v2] mm/vmscan: avoid false-positive -Wuninitialized warning
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Arnd Bergmann <arnd@arndb.de>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Koichiro Den <koichiro.den@canonical.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6CF724001D
X-Stat-Signature: 4uq8t64gm8e78fsxi6gm7bw3byz5h3yj
X-Rspam-User: 
X-HE-Tag: 1776200409-464209
X-HE-Meta: U2FsdGVkX1+UzaDSwWhBMgl7NYogzher0f+0rF8xZ6GXeTaO/A2lVDc4t6+7B5/q35vr5NBWP6G2EpvKHKWNvaijiyX5E1aRQz4P1sULq39DSBVBYinjgsEaPUmkLD4MawjDY/1KC+0AWG37OVlJYxNk6xFUFw4+Q0nPHo7nadpnUYDF0Gv04PUXJWgXKcXFk8Dymmek909n/AxOCqFCZqK9a5u3ImxaCqaohKp30dHvFRHsPWyc8i9o7C5ARAUXR+xzVMf6WzzVB89CP68lWj517jFNU9Nzy8JGjnAjSdG6rlzuTzBE3bhuyWhekQtHk/rcULy83SD4fE5A4PIyxnstods4IT3JqWcMDa6pfzOagNTbeSDGDrqgirdPWshEJvAhsWyuabzP3tG0G6bVKaqaL+k5pK70Eta32uK5wXKQ8mW3sBKDo0LiJ15wPqlsA0Y7rWcA6/1rtuVWM/AjmoXS+XCkwi247NLluxHySp5gZIw6faBQUi5f/ZYGDcWgn+DeGkKfGvW+/YthXDE/xfhN96gybXZKA2WnYhAVuXqxQ/A5wsdLFJwCvpHHxjk6GL+xLyElg3jrqoXTUM9VRSqNSR24flInYujaKm8glAYMGceOWAShD35NiiozsLxkFfE3kTCZVigye4mIbRx2BOGaLwV4uUzPWc4ahg+Pb30b0Iw+r26lo1C5VBGLvdU0ZjRsXi7H4tAtZg9wK0hoYKh7jjo1eRZivqN+u3wygXqgQ2APUlvav1p9Ue7IrPN6wdUZQhLy0/nwT90bDJ6Ie0J3FCew4MF+5ZCC1At2SR78+7HH4A1k/fFl79nZEvG5eulB4y6oJHQB2DPkiBpWzq1LHTqRFyv0KP+Sz+qDmdlXiryMSDIZLPiJmEkBr1MhUG5otxSKUV61CP24N1sr0YNdkpdiM83kTlmuwNXby3WiRaQ6JRzli16MJe+ZHPOBkGuXg70RXjnrhyX5g2K
 QeCyQcwx
 8BRkJHrwGGDlObe4QxxtKKhdGe42THw1wVTurUVBdMxIJyyd3ccwvgzTKrYkqbpvg4xr4g7T6stFML+s1tnh+fellaKwco6paIrvaZm0q98QruFSuy3R9Fxas6l3iryMImx7JVBB3hAsq06OWuhnfg5WC74X6mHdzKoNCrgoLTV6uV+vjeAxfyo74cQk5zZykpcCQLwOfhLBcKqTRJiiGqB6picN5P61O1rs6bLtqw+GVb2kIRS2A4rhDRWGCKexkWkkvsvaUVpNcKf4NP6wjRw8dTTveY838we2ElJJ1fbUsF9+BRKPBE7B1vH6vfexPwqHAJBtPskCd5kM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 2:52=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> When the -fsanitize=3Dbounds sanitizer is enabled, gcc-16 sometimes runs
> into a corner case in the read_ctrl_pos() pos function, where it sees
> possible undefined behavior from the 'tier' index overflowing, presumably
> in the case that this was called with a negative tier:
>
> In function 'get_tier_idx',
>     inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
> mm/vmscan.c: In function 'isolate_folios':
> mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=
=3Duninitialized]
>
> Part of the problem seems to be that read_ctrl_pos() has unusual calling
> conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
> where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
> smaller positive number makes it read a single tier instead.
>
> Shut up the warning by adding a fake initialization to the two instances
> of this variable that can run into that corner case.
>
> Link: https://lore.kernel.org/all/CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5=
EmiCHP+1fBpg@mail.gmail.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: replace the earlier more invasive cleanup with a trivial
>     workaround

Reviewed-by: Barry Song <baohua@kernel.org>

