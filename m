Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E3AFCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF5C8E0005; Wed, 24 Sep 2025 13:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796898E0001; Wed, 24 Sep 2025 13:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACD28E0005; Wed, 24 Sep 2025 13:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56B148E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:38:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23B8F140907
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:38:27 +0000 (UTC)
X-FDA: 83924853054.22.95AC996
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3AFF41C0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:38:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CbXqdQez;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758735505; a=rsa-sha256;
	cv=none;
	b=jJTjgYwCtij4I82dsinlrbpfex6rR6U+wGvzuAv4+be8DfCjOz01qosBxDrcQocHbGTbfz
	F1lys+xUGyBMx7R2m70ponwI5l4BiuCkOQRnp4qlXB8LgWx3fx5M18zzvK9l5cDTWPvJnS
	hUL1RJqINQE5u675sAPyl2NEbHGcDyY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CbXqdQez;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758735505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30S3XZGJU9mWOJVs113Jcz1pN9m3tlO1m1w4FB2QQH0=;
	b=gw0bZR7YM97d70t9/M3CRDMeyZyKbcApkUp3SEp6QFg2lkTNPom8JHquQ1dZjFpOCrMQKT
	8U2wLu7y7oGakkn5P1YgqwDFF8OxuUnOSrDUMruHTPIqkyMuesLkj+HpMqmN7cj9cnK+sB
	VM4RFGolbFeDWqh07RGGEGwqJWknapY=
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-4256f0fac67so306565ab.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758735504; x=1759340304; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30S3XZGJU9mWOJVs113Jcz1pN9m3tlO1m1w4FB2QQH0=;
        b=CbXqdQezcIJExGu7uzt+XJEJ8rWSVi1V3XqckgGBKOL5d7O7RPceneJTT9yhofZjFO
         Lw5F+yaOETkyheXPZuuSEImVCGGFeX33tLdcgIcvT8zyYKUoZqaLEMKcuGqwjQfW9gmi
         B/KYNlPjxwrAHqaSh12EAezQItJFljqu1se04hlbypSTabBj6btb15rpCFCWsfaElWJQ
         MiZk0uJbhhpwXImB+nueIuwksZLsUhxHip/Bp0+isbd5VTAkc/E2juuMc72pRGU+V2UY
         5i5b/+3PDjwo+SpBvV/oHYgkI+uDKTHCira6apyUl9jVAuIWcKgt9gm7/EKwuGdenfOV
         rsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758735504; x=1759340304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30S3XZGJU9mWOJVs113Jcz1pN9m3tlO1m1w4FB2QQH0=;
        b=iI7rQL+jQ9lbcO0iugkyv02mcltGYr0SWyuVdOrOGxbJktta786qctjzyZcf1atl4V
         PyrsvqOCt0y1I6SqPDEjKAi452l7aAHvwdgTSIAg/TeXMzAqtESOCi+nKim6ly/rL4HW
         HmgY2oiLul1vMtsLdRJXdKafdgNSryi6s+QlVL/XHTsNxQlJxTYTsWXXoIpijrdAKmvz
         F1TBhDO+Gd1Jc2sXUQmQI4218TCKodKpMZGSMGhTNXsZ7yhdlCfri4fkjRdQgFbpC0Gd
         3ipyzKgVO3/QBiaUtx5/R1SxInTa+fZWmO6smWbACV5OYpGbPBwaxv6u7rTHUbbTVBQf
         IX2A==
X-Forwarded-Encrypted: i=1; AJvYcCVRQP93o8AbWthQyUCw0J5yF7El/YIKZZV7Izu7vMVDPLcjWEHIu/Jhe4avBCTDQRLxPLCeyIL5YQ==@kvack.org
X-Gm-Message-State: AOJu0YwvWMouHjXnzOo6725InxYslNbO/h8Vl4ZWF529sUzk+UGN6rZo
	3NO+djjF2Sg4NtDXWV1mXEM3M+XCXbKrQn8TuTJUavBqpPUdXB8wWxqkA0AhgMLR16ZydDeW/sa
	s7zIjOqGM52YEbJU4cgBmmmJvBJ3HZD4=
X-Gm-Gg: ASbGncsWstaor8ajhuaEqCxRl6/YT0QKvfwKFmgGVfqSOsU8S8308tVDQ5dmdYFOUep
	aHGusMMv4nHi3/6n9cXwUoqC1x9PGbMbq+/FCv9FNQgNBqsYROGfT6+7j6+peS18lLoHDMvAw1Z
	804F9NYkS5jNr9yhbCqBDXT2gEq89R0DWD0xEJvX+9STIMFehAH9hbl3+KagXnOWaLg1/A3Lm3X
	YN7
X-Google-Smtp-Source: AGHT+IF6MTXy6w1DyXC7/o/nI0lSM4Q/Gz/7/Id81c+he4tFC30Z8cRyZeTvBBdURAh4Zo5aTq0YpXpMF9IG5v6/6so=
X-Received: by 2002:a05:6e02:218f:b0:424:1c9a:cadf with SMTP id
 e9e14a558f8ab-425955ed4d8mr6926285ab.3.1758735503219; Wed, 24 Sep 2025
 10:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
 <68d2cfc2.a70a0220.4f78.000a.GAE@google.com> <20250923215929.GA1122379@cmpxchg.org>
 <aabca3ff-3cbe-468a-9b65-290d5239d987@konsulko.se>
In-Reply-To: <aabca3ff-3cbe-468a-9b65-290d5239d987@konsulko.se>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Sep 2025 10:38:11 -0700
X-Gm-Features: AS18NWAPSCyNKHQcdiRVEaduc42g7VmVYowOBIJ4ozJua0iyYaZ3jlavJyn10Pg
Message-ID: <CAKEwX=P18Krj-+rXvTSCocRt+Q3o07Ghisv4nJLRCJ8tLus54Q@mail.gmail.com>
Subject: Re: [syzbot ci] Re: rust: zpool: add API for C and Rust
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	syzbot ci <syzbot+cica6a1c285444b25f@syzkaller.appspotmail.com>, a.hindborg@kernel.org, 
	akpm@linux-foundation.org, alex.gaynor@gmail.com, aliceryhl@google.com, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, chengming.zhou@linux.dev, 
	dakr@kernel.org, david@redhat.com, gary@garyguo.net, 
	gregkh@linuxfoundation.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	lossin@kernel.org, mhocko@suse.com, minchan@kernel.org, ojeda@kernel.org, 
	rppt@kernel.org, rust-for-linux@vger.kernel.org, senozhatsky@chromium.org, 
	surenb@google.com, tmgross@umich.edu, vbabka@suse.cz, yosry.ahmed@linux.dev, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3AFF41C0012
X-Stat-Signature: hudh141xa6wyab9wu3nihwpr5drtao58
X-Rspam-User: 
X-HE-Tag: 1758735505-874880
X-HE-Meta: U2FsdGVkX19MS55eKGtzcEENUtUUVOyoFp1icpyZU+gZhaefnnS/Ma9B2Gt2fq0tfNr9/puNpNYEd0DhFHley60eP1fibiYxxcOjaYYrOXAPO6mMYQorbOX+BVXqBv7FdMYkPiNaGqhf5JICvWY6++jIoOsuI/v3P7jut2N+dZdQYZkOfujGCrTVe4l+8xJsvXwqB/R7AheBGLDu1bIaIDhMzRRR0BXIE+ZaUy5mfe41CZuQ0WWbbQkYkJJBZszHbgsDgQDPdloz4Y7TWf28NO3O9JQkx+PAtL/ALTdvRuLioQoFwm1HJ9qIXd90d/Kp+l8BJ/nIICUeSYL2V4hY4wn6ZfC97Rja7hPY9VH2/xWZFOD/xqICS93SDGdBPv6Su8ifCACNDar/Gl6QNHEocDi1ZohEbffCHZ4yXSktIRZAbnnqxTh0OOaXmBZyZd/BTPfyACUG8osq14jBPVEgwVzMMFYSr3Ez5teEGtzRe+NgW1xmxeptHwruqvJ+csgYO47qoQNlzV4gDF2LzZoUXihQL11+M1aXpXVPkPw9nIA/CYUxsFSrj3qKD3CquIb3yB0qwbSgZoPvpjZaonh5PfCJFNGmFnVP8Qil2DeY+PXdG1ldK2fLLhl76LozaxC+pmNvFPAYg++ZNc0Y75G9/ovGTxBP9xUbg9+wWrfO5liBDlzm4ufDOpAN18XIoZJepVXr7HnqmqiHJIWDmDpLmhF8Lfj6ca4zGZm0AdHBIdNEPXhGyE4H0vOO2WVJRiCsZMgoFN9chnLkOBy2YodPgPke7sD59c8KX9wsEFSTBXKs1SEu2O7gf1x3zeA+z8EkSuKXhmLezMF9a695jaKhMKv0qtnpa1Qt+tAW58YYJzgvEaYztI7gtnoV1rITmrc159qGdYIDkCzRuCtsBQqk3bPGyveuXTxKbrbc3ePFjvkw7Cor+F8EisYcANAVirSMQUk1JzpoBze54N96b53
 tfO5I2wQ
 BsdcSabQK3Zm1qIUuiCLLFNInKrqwazqNRCIPxst1U4cy+FKMyn63PyfbQYESoKWAbRvWb7DB9V/9jm0iSZR+Z8b/vBn574gzJX8zZo0wuRfzV1+yx0mwrrSmkIa7dd4qrS+tRwbIgLgzEDnvmY6mC2h64+8mY5QpGIXpcxk6QIUpGjDFb+8pI+jYP6x95O8/BGcY/6NZCV1nv7syjP1E8Z7JEYhgf8IsULfbKgRzDNkZnZlMhnQszP2ouDgVbzvIPdfv0NP0DLFCHIldxL0aQj06oWNL0Cu8nA62heJeIy8jsJb7wFS9KFxLkfHecXERCUe37gtz01Z0A9QNhwUlrZVwq3MvLTqMdPjLpSzp1ZszsLgurNxKsIYzeWyj9qsaPvcuqMGVgFSsCAkOLQR9dh3nT+6b4//5qTEsn7SyV0jOevCk6des9PFCp4gSSzuhyo34HSXABqx08/y6ANwr7am6t3C4lVt+wvEEa8LxfbcmD8PcCQPVO3qRrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 10:46=E2=80=AFPM Vitaly Wool <vitaly.wool@konsulko.=
se> wrote:
>
>
>
> On 9/23/25 23:59, Johannes Weiner wrote:
> > On Tue, Sep 23, 2025 at 09:50:10AM -0700, syzbot ci wrote:
> >> syzbot ci has tested the following series
> >>
> >> [v6] rust: zpool: add API for C and Rust
> >> https://lore.kernel.org/all/20250923102547.2545992-1-vitaly.wool@konsu=
lko.se
> >> * [PATCH v6 1/2] mm: reinstate zpool as a thin API
> >> * [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers
> >>
> >> and found the following issues:
> >> * BUG: unable to handle kernel NULL pointer dereference in zswap_store
> >> * KASAN: slab-out-of-bounds Read in zpool_get_total_pages
> >> * KASAN: slab-out-of-bounds Read in zswap_store
> >> * KASAN: slab-use-after-free Read in zpool_get_total_pages
> >> * KASAN: use-after-free Read in zpool_get_total_pages
> >>
> >> Full report is available here:
> >> https://ci.syzbot.org/series/e8b22352-ae56-4d7c-9113-75573acf2b64
> >>
> >> ***
> >>
> >> BUG: unable to handle kernel NULL pointer dereference in zswap_store
> >
> > struct zpool {
> >       void *pool;
> > };
> >
> > struct zpool *zpool_create_pool(const char *name) \
> > { \
> >       return (struct zpool *) prefix ## _create_pool(name); \
> > } \
> >
> > u64 zpool_get_total_pages(struct zpool *zpool) \
> > { \
> >       return prefix ## _get_total_pages(zpool->pool); \
> > }
> >
> > You create the zpool by simply casting the backend pool, but then you
> > deref it twice as if it were an actual container for the backend pool.
> >
> > I'm guessing you didn't test this even superficially?
>
> LOL, no, forgot to run git commit --amend so came up with a wrong version=
.
>
> The Rust version is correct though.
>
> > This also still proposes an API with no in-kernel user.
>
> That's not correct, zsmalloc is the user.

A single user does not an API make.

