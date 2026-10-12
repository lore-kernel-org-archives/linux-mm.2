Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24819CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076766B009B; Mon, 12 Oct 2026 11:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E0D6B009D; Mon, 12 Oct 2026 11:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6476B009E; Mon, 12 Oct 2026 11:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF1D76B009B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:04:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45D811A0F10
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:04:52 +0000 (UTC)
X-FDA: 85314296424.30.0363462
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 47674180012
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:04:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GvrPM1BX;
	spf=pass (imf24.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weLDaF45D5gfbSr+gWQVb1K25MVNkySML0rAhgC7w2M=;
	b=T4LUVpl621oqiXmoLBg6aaJAdI/yRZyA1Rm3qrrEqDafC0nN74yN+g/iWwJKIx8ZU3a/Zu
	jOH94m7u0LROq+Vr0RLzxGN8FZhj7ku+afK1uwvNOHZ7XSFOuhsAo0yS3qyjcGjARu5omK
	eyHMw6nmgcFMCQnWS+yW7J/0fu+Yefc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791817490;
	b=c4GriqSJv5G4WLucV92DNqtBaSUNpJutNOS6NfmrYLNHibRSSu3xOtHDG1hpkXH/5GHTW3
	oqOYDG5l6amynOwcrwL6R/th6yRuUB8l3T9P6K9UEY7LcEToW/O0MA5P/We1dkw0+TYfmB
	LNh3Jo/JQgqqWvFAN+jD59GWh8gJbHo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GvrPM1BX;
	spf=pass (imf24.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35a0ae8d711so94360eec.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:04:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791817489; cv=none;
        d=google.com; s=arc-20260327;
        b=KXCbaBL4eq5vZMTnWnnaK4dsu69kJo90pncZpZM6pzk+id/s8RKrohZsjLXyXShE6s
         sMr73G+Opd8/Vs9s70q6FvmTCJifOMrFxqlgU86q2sy9uM7A8LdfT7FaVYCZmGKxweAG
         zeCvoPeIIoQqvqxuQPelgNJ9i0XIu5r8hFh8eo/x0ge0RADjAoCGL2E6MHTlcR9SfF97
         Z1zG/mfU4Gqjanj0LqqibTlzToxCRSXAO5wFmpyxoKffPoXIyFPiECiHyx9H90HZh6u/
         uhmFhNcE04kAsY+rB3lGfKdidpLEvjAJLOwIirCNMdlhgD91WMDUlxTLjmhHaqI83Cls
         eiiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=weLDaF45D5gfbSr+gWQVb1K25MVNkySML0rAhgC7w2M=;
        fh=oQ7qjsepSeRWNzi6UrcRM71nBDqIfZPB6aydLLjcW8k=;
        b=MK5MrE/OWgte8nv5vfbA5XI3LxPyfbawnUmJISNYTtWiKvnZvkl7h/AaY6J8JIgMZY
         IK6bL9hh7tEYZ2vC1TZy9v9QZ/oJh8qehYjJ3MLgL36doASGQU9RjnPQMuNqqeL86mYC
         lWlO2sglPYnNhbYDkuz9M5mmqUBr7dgBSdc9/6rU3UpEFix0fRJfSdhq1iJlEJg5GiI9
         RU5iV4QlkrXAJv3k29AGCx0m+y7e6MOuO42EZFee8khqHL+ArJx851a4xr+D8TYfl9CP
         WIivmQc5P8LESoYxyY98WW2nGXTuXD1VEXvZR3ni5BhUvsnMjyE9llhSLUSgNDMGG7Fg
         3yPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791817489; x=1792422289; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=weLDaF45D5gfbSr+gWQVb1K25MVNkySML0rAhgC7w2M=;
        b=GvrPM1BXiloc4wUx6V9eUdkPAHGpQtzHPLe4Jy49YphqmWD1+vMkJWVivW/p5ZZMqR
         C5AWSRNIpTnHm7wW2MsFU4BQGW15s//UbMVRyPTkj4wwXBxsSBrhP8FxUcc4fOqaaSGL
         ugNm7PZrkh3umdhArevMqB6va/ZjazimztAOGXrukLqvDXkYtiYuM0yCkiadgbQqED9d
         ZY46p+xefmNNeVrciV2FCK3spTqoHtrIfOYrSSQAbYfaRw0fQTdwHiSyMJoUPo7qJxc6
         51Q6aNkVjL4iSegjVZTyDde554D/Rv/KSkqw1BrDIqEw9qym8KzJ5QNJVxf1aZNYEKpQ
         5wLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791817489; x=1792422289;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=weLDaF45D5gfbSr+gWQVb1K25MVNkySML0rAhgC7w2M=;
        b=Lb5F1CyKUkz55jq+10qozmS+2awtDtMKknWvM8C2m9zAKrOtG0lkCctWsBBiwxWI4p
         p10ngcyzBjnVXaCVaix02b6eS9HyPByIWTr2uRfvgggDDQzcw0paIP5q85X18/S8hPtm
         sftGlKWPRg6mA2CvQzyeSH32E2Cqso36rPIsUTx2BTsJG4Qbsai93WkXBdXvGTl0GrPl
         BYCDO4MDL8qcGEA5hfhMx31kj9Kw1pfiPB7AAFWi7iczh2uZ8BJUm51/JHjxt7HYEkqK
         X8SSCNtsnJHRpQ2r6q4F++p2lKgj7XOMUXTXTedZbeqJRSlwLNeC5bPvBVT4bxNwpH9P
         gtdg==
X-Forwarded-Encrypted: i=1; AKwUvBwYdQffquENjTB1ZHa+QPvSxiVpv8XAHJ6QjBgHc9sLFuNPY8XO+fg/cYD3uJMZbbGYHrBWcoW3nw==@kvack.org
X-Gm-Message-State: AFq9FYKXtNHD6vxN01ZP95wei/ell8c+q4RgK4sKgOJ29ey3UHaBh+DK
	Nf7WGaWfVQTK51L1vTPc5off59KO1wQdaicXQinlczGBZFMmt2e5lsw3h5dkCzcF0UWeIl2IDZ5
	N+SJ2gR5KlEMo4q7L9Y2CT3WYkTOl/II=
X-Gm-Gg: AYBFou3BIuHSaZnsThDabXwTSIOijlZqavxCdGbRG0rO4BfAcH4xDRh0YjiVWrLGos+
	KusHqoHq6peqqKBqGYUZHEbLTaz+0lz+Y1ojFlSWLjfpiYOlip5jNgsaK2M2UFMFc1CQgTQEthY
	lBlo501JBJzjgJrk/v6CtD2fLkhXUcOwzClsiyOpZklO4WH2e0YIiEQqOFL+SdT+6QJT+HLzxKh
	/fGz0xUophzS83rcFc2R1Gf9he7y+O/6XhTwSDqFsFIZqrHCgDRXSpo1LS9sMOgwzij+FH44FIW
	WOWQHIYu63qB3Fmxhg1RCVpP1H0fzWUKAnk0PYuNzV2AlLD9CfX+kQsy0LfNH28TonE6C03oU4X
	l9eMMfka9OAu8tWm3vjD6uYK4kq3H+tzZJbmKi0/nhFsnQvwWjHKWHtIVoAmh00WBkOGU5KR+zi
	IkKpb98Q2bdS87d9mAUnBKfxV62TYwJJiBpfkx+1jTlwQ/3jKWhaU=
X-Received: by 2002:a05:693c:8810:20b0:35b:cb5b:c71e with SMTP id
 5a478bee46e88-35bcb6b1c6cmr1408019eec.1.1791817488630; Mon, 12 Oct 2026
 08:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260929-cpu-helpers-v3-0-e968ce5ee613@kernel.org> <20260929-cpu-helpers-v3-2-e968ce5ee613@kernel.org>
In-Reply-To: <20260929-cpu-helpers-v3-2-e968ce5ee613@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 Oct 2026 17:04:35 +0200
X-Gm-Features: AclHuK9wzT4BzJuJCArQ1hZV1Y7wL2rurxN8icBv3GPL7rh5gvUSjCGJZPgPXPU
Message-ID: <CANiq72moeX-F-XkOWewwSEJHX6F5j+7NxNis7qhPU4aDOFRRpA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] rust: add a wrapper for the `nr_online_nodes` C function
To: Andreas Hindborg <a.hindborg@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47674180012
X-Rspam-User: 
X-Stat-Signature: 6grezg3peitbjz9cib6x7mub8oyfjmmu
X-HE-Tag: 1791817490-788282
X-HE-Meta: U2FsdGVkX1+xTU/tqLxugMWyodJ/a2Ir5QUM0UtVq6PQuNUF71kzuSZMAN8Ms/04+DMSxh0JfgevMJWe9y+2rv4FlCIpMJzHjbJSjXwzSjrhdoUDDWHo4dIbyx0rx3XgZT2QfJZ2IAijqS8CeUP/O9jE3USRKga7MBf6+PWcEwZ69ehJZlafZtXGGltZ3NN6hjrnBFPEhmk/7jMJBduhjNyecp/ki1zamrVT9CZGl+RcIK9ss/QogqczWXQuvOSeKBpprRSS6Y5E3bcP5/mFLQ2wUO0isjfjqTts7787MaEZxI9AIvPSSigrAvPFTJZDCKUu4ykLK59Vu7CxbDoyZdcrYt8pJxrRwYvCeERLP5qwnGupVRQhPKcJoKzG+L6UP1W0XRaiNRk4WDQnLPH3GroMKasdsiv311sTD7EJO0UnKx+1BbcexEkI2OOcRCeNn1mKsUuOpO72N0bbD62CvKd3g3p/1P6jkVdrV0m+oc3GAOA5Rnlw4hV0pj14KBUNnDvFrpNtahPf28dfZ73G76X/xAWu6t5oE/HvGkTdTniEJY5CxU/mgP+hfFPKHKFn9DPkLDboMXEAUOIyuikT/iqLvr1iK5J1uks4Q5/eIQ46QmFqe1uS0uJ0QrHvZkAq7xkvtR73QkQjJQm5f2rUlYV1Z+K6hjMgpPX21P/PuTl48deP1b0Bm+5fw39FeK26Qhb35DEtfWeiOZDITU/mI9j3pGkqh55T8HmH07+I7+deEnddxK1khN/lQB/XyyMoZ/M4BsumrImzgwcJ9q12wDzeZoeBh6C6+AZw+8JfZ0cRrfFiRvR79xHvhshgCRcZpbGTDgjtJ5/I9wzYwgVeAQWZGKB1Iuv5QnbTCqEgV566TGelux8ZBLaB2oc/+rCVW25G/DVLUarGM34v1XWvhY5VHMjYTycYkGDofMbb0hT9DgqZmFGpvBW4K7/8TlLuJqVKtdrw3u5bK9kugZS
 P18XS/mv
 E8bypDb3m8W+tIbRigCrKqEJaxz0oN8/hakWSx1kPQMguNmFfJORXTIKrcjMvHGnfGR+Fs4Kvy/WN75JCVauGfZMZytD3xuePSfKz0C2JwvKHdkbmD4qhwUy566Eosi/mHvGbD8imdl6v/001zd714n2d8qYpXgDXOuJpws0lvGwlgbgrT62sypgAWNGtcI6RtnPXoENLdEgf3g1FzJTlYZ60/ZBpW1YZd/MYr3lvmgGPky3p8mXErBZvP+lTs7Lie71IZ3c7jQqMLghF9o1Lhwq1FMbqgjQvtGQJjqm7XMrXZr1Km61D3CydoxZTfT1Etj4y1bQP6Xrcmg0r+n9UTN6cJNt+DJ8VrRdww+M2xJSTziz9NRayykDAAHkROhioXwrRtEJaurUx8vIZGO28InqY0MTwhLzX+3jTXa/lOH2FYYgkiXZJej9yCZAMvA24/wvOchCGZRcWCRgmW/byquQ6fzMyTrsx/PQlDevx+KhnDE11hs93EmmfQTzdfg+YKYEvoP+AtHzJSgthwJQVe4ly3QpKe5XmyS24
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 7:58=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> +//! NUMA topology utilities.
> +//!
> +//! C header: [`include/linux/nodemask.h`](srctree/include/linux/nodemas=
k.h)

Cc'ing Yury and Rasmus since it refers to this file.

`page_alloc.c` also has the definition of the variable in the
`MAX_NUMNODES > 1` case, so I guess the MM page alloc folks should
also be Cc'd -- doing it too here.

In any case, I am happy to pick this one up if they are OK with it.

Thanks!

Cheers,
Miguel

