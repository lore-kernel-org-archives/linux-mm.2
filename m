Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0246DCFD658
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330F36B008A; Wed,  7 Jan 2026 11:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B44E6B0093; Wed,  7 Jan 2026 11:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196136B0095; Wed,  7 Jan 2026 11:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 052886B008A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:06:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AB4CB8729
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:06:02 +0000 (UTC)
X-FDA: 84305644164.02.BD0ACA1
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id AB7BBC0014
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:06:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YzIb02LY;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767801960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+lP54RhnuNvs5BPU2CeELlZ9FEsuYM7DOu2bpSXsYs=;
	b=VKirLSNgqFvQ+o3evsrR2wNq7bD2/CiddKNKEd24LYwv1FNzAUacaWOtoyPfup+diUwci0
	1TuOJCHU/YR+bm1aBXOFVokvASetOJcJEP2xjNgITaZC07BJjnk4DwrQVRaGAoSU8GwfnJ
	HhRHCCXg/y1dIaCsdvXsCe9QUfXgYJQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YzIb02LY;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767801960; a=rsa-sha256;
	cv=none;
	b=uJhMJsmu/GEp0vPOJLRK5S/84R1lvoPDsGzaFCuvKT4gtH8yo3j2bgYKcK+/eBA/lrw6ey
	dShDG3qKlWSFVlYnXuc8PNZRdzxg0Omlcr48px3hOvbgev1BSSrk1lOA1T9FuiOjnC0sAN
	xJu1Er2LGC6Kh7H4CB969WsCWcMU35w=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65063a95558so3158440a12.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 08:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767801959; x=1768406759; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+lP54RhnuNvs5BPU2CeELlZ9FEsuYM7DOu2bpSXsYs=;
        b=YzIb02LYDYFvF6FqPzmbQL2EWimkKMSRFM087dhgnH92yvPeD+frdnER6N/CosZY3G
         s3/2NhRNh9YDHOsBz+gy/kzZRXF9r+ZYZkt3zGq1JxMhKJPGqPCS8RfaqtZzfHgDEUdp
         s1dY+1DQM2p9eFCBMQRS2Tc71HC+az/aaU61vzD0lHd9a67XeBhetlUg4NauNmEtFgAH
         BONTaLTZ38UQDMms6iVrcSEK8KBvtTX9RjQtthg/ZXB9SyqBtxVkFUsTf3eD9Dqbu1h+
         QczOSB/xk13La85w5pQjYl/wy/SRRTvqkN7RvM+QCTrSQrNzh5tLwErnexDLHOMErKjz
         OYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767801959; x=1768406759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4+lP54RhnuNvs5BPU2CeELlZ9FEsuYM7DOu2bpSXsYs=;
        b=es2jRCq4UhMAV3sUDg6/ylmuTZCS2JES8ooFjUK267WLUHbyykGm2mR40i8dTaB3rx
         X7Xf5FI87ic4MiR4gZjsx7haf1Wo4L6ayAPaQmIeu0jPpw00POErFeOIsEISukIOD7HF
         gkM8hOBQPWCxgXz2RBRz8v7J5KwZdPQu5E2ieG857UtpGrhcnwJODkzDYSa1e53qmLaJ
         k1UgPZ7e3FFpr8jQF6AW1o+vQki2KXc+AzlK4MRlOK75eu5+EZI53dWI0ZeJiNuLXl71
         qz1tlGQPxOWRvbA/NsE0+FmID1KZLP8GF72aRH/IXil3lOcScfU2MJqcrQBuef+gRswE
         3Raw==
X-Gm-Message-State: AOJu0YwE7IccHWaVw4bUA7FBXQY6Iqjqz9nwCbHDd8RrOhOh6Wi+xICU
	zmAc/QkrJOZBJ1OfIgnlLhuWQMKa5QhcZYSu+OVqqKMGmq3qu1cDyHqViq+pVvA/rWyQAugrIL7
	iGzcn6x7ILNlNB0PdBIY8keo2IpwfYr0=
X-Gm-Gg: AY/fxX6qnBI/afdaiplZIlaIghbuVGO72wpc+cdwS8bcjaiYRopA00Ig3S40VnJx8yR
	Eb8jxPlG0gvm/Er4vdsBwbaNF3m5kY6OuuzwNpMRmthL9v3FS823FysphFGdzyyPg4tT0fWX43/
	S3+dAUhTMZARc6TXgeO4iEN3hSNp4BU0O8FHV/vMqxVi5PyZAvKNBoYjdLnqTFM/KRcFndU0OS/
	q002k6DjYJbw2Gj2YIjMvvOnM1ejxoXDy9jMuK4Dn0+gxwL7fAVrq6U4lxTyDgD60llGqJXqUSe
	HLK7Osm13oh8X9mPUVytsi/ERBLR
X-Google-Smtp-Source: AGHT+IF268lKmMRB6hFIs3UMiBKC9a1cNQIxcrYUHlDrac/ngSjkrUEtTtA+Vx+f8gcKm7grqZoOiKa2zHZvFEFYn6I=
X-Received: by 2002:a05:6402:3487:b0:637:dfb1:33a8 with SMTP id
 4fb4d7f45d1cf-65097dcc598mr3052666a12.3.1767801958827; Wed, 07 Jan 2026
 08:05:58 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com> <aUYfxQtmWO3STLa8@MiWiFi-R3L-srv>
 <CAMgjq7A=n=5cOgOYm8i-DmgjxQgYU9om2oq02nBk5vkn7dambA@mail.gmail.com>
In-Reply-To: <CAMgjq7A=n=5cOgOYm8i-DmgjxQgYU9om2oq02nBk5vkn7dambA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 8 Jan 2026 00:05:21 +0800
X-Gm-Features: AQt7F2qNptlDKTRGB2DfXhz86TIy1LkURo4mHL3lSwPeQd22gsMeYbaRnnPhgnI
Message-ID: <CAMgjq7C+2snKqZm1BKK8jNjkeot9dO1tPx=f7Jt1gBvDvWggAg@mail.gmail.com>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB7BBC0014
X-Stat-Signature: h8nmd8xdmssmdhzza5c44f14upjdpkub
X-HE-Tag: 1767801960-230566
X-HE-Meta: U2FsdGVkX1+RqTCTDSJWwSdiGVAISCG8VJGmAOS9dTczVJrmcIIf6HNjL3kVvw6TZySGZnH03eGdrKc+157CLujgYEf62Lip71Lfvu0/G7omipSfflyoJNi/kR6jZEjl11jJ+1l7e6P0qYc+j95u+lt8ByB6BsTNAtLBbkdvOaBMfvwhgH/4ORRzZ83aUXIYnw0id6vhJbLvduOh2+7zXl49LPprVzLSajszolbmykWhyRthd1ZYR1BIWTztYtyE0mcnx5+TJtXOuME3dxtJKwgtnuHMl5mHFp05PVNLY9IOfRc2HU7lgIz2/69Auu28AWW0IdE2UyiNx08wppbxBRtrtJb1N3zsqbyMCkCpwFTWg+jDkiW4Lx/EO5FZeyok2c0EShjsP9D9QOEVahGnOW+WpM7n16AF8v6lhTLi8axPBbKjBKYiCyyUsU2nvr3pYpaU+pNHKJKzXQjMjJg99gw3F3JXFZ62XkMBdLhMemFFmTf6PDYgLKMkqRmk789DqDSwQrAKeurLZux6JZ/4j442QES+d1I88F4eksHzwX7Sm4CCIXcHttmMdObz8hDH5zS3VdPx9amZrhPCYxPPhz2/wDiyY961U3fU3HRX0staZmdZzw3xcA4G955lUAvV7Tb5+7pcSCXHX5CETQ52RIdN2Fa64POuCZVeyvZdre2JcVmD7svPdPw8wUaT+lWx8+8gHFYuEKJnu7BCMDU1VVLEWDDpryZqaF3oYMM0QExsfectW2UFvmkPHgXFeg/71xwDADTap6Ht/0BzESjBpXvwVVnU35DYTJCrmXYl/o29RsgriMcv+w7LDPM3oiTENyOmJxauBswQ4IsmPD1MGv3Jjfr9O5NPt5vpYwFAPzvhXIdQ4ChjMMHITbj0YogbE8Zv3ZD2FXMYWYkty7oMK0LowmXRdemcph8VpKVaAdXkexe/w+8s3J4Sa5PJQ5otTsUXqG7PsD7xWIeP6/A
 7budEsea
 HnOOtAVU4B8kUITOtxboo6nLpTQx647DYUTEpoolKnOI9HY3uLGVSpVKL895GFbUaxYJnPL4HAukZ22Vkw1PtIgNJL/faBTmocul0P7K2WQQRFXhsq5Cc168YMMfmCf8P2Rpr0ZOW4aB3lo+/d+rZ8Ied794ddLJL9xz99Ekd9TG5xth74qPzyMZlloUyw+WxidKicMqXlefmnbXnuQYiqxOXcs90+UaMsdZbE4b1UTw2WG6EStHr9Vgf85C01R4FioM483u+aA+2HLq47J/lkjqUKfqGMiC5VsCtkbyOJs/X/vnySN+LKKj8Y94N4nuaYmD2TpUk+VmuuKl7rlN+UR40E1EtASRJQ8Pn6kZQvxvJUFJUvh91V3BqXlReF/WrhVtM+vEe+WsIOGZogEweRo4ZoQfu4BaACLHJRifgzxjd9G26FBY1ACKL/lX4eUPskR95Op3KQA4XKgU1KBmYiABWApCHBcUjRGEktXoKiqmazi9nw6R4jzi4fzHS6Jg2Nn9ZBAXOhH982IQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 10:43=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Sat, Dec 20, 2025 at 12:02=E2=80=AFPM Baoquan He <bhe@redhat.com> wrot=
e:
> >
> > On 12/20/25 at 03:43am, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > The current swap entry allocation/freeing workflow has never had a cl=
ear
> > > definition. This makes it hard to debug or add new optimizations.
> > >
> > > This commit introduces a proper definition of how swap entries would =
be
> > > allocated and freed. Now, most operations are folio based, so they wi=
ll
> > > never exceed one swap cluster, and we now have a cleaner border betwe=
en
> > > swap and the rest of mm, making it much easier to follow and debug,
> > > especially with new added sanity checks. Also making more optimizatio=
n
> > > possible.
> > >
> > > Swap entry will be mostly allocated and free with a folio bound.
> >                                           ~~~~
> >                                           freed, typo
>
> Ack, nice catch.
>
> > > The folio lock will be useful for resolving many swap ralated races.
> > >
> > > Now swap allocation (except hibernation) always starts with a folio i=
n
> > > the swap cache, and gets duped/freed protected by the folio lock:
> > >
> > > - folio_alloc_swap() - The only allocation entry point now.
> > >   Context: The folio must be locked.
> > >   This allocates one or a set of continuous swap slots for a folio an=
d
> > >   binds them to the folio by adding the folio to the swap cache. The
> > >   swap slots' swap count start with zero value.
> > >
> > > - folio_dup_swap() - Increase the swap count of one or more entries.
> > >   Context: The folio must be locked and in the swap cache. For now, t=
he
> > >   caller still has to lock the new swap entry owner (e.g., PTL).
> > >   This increases the ref count of swap entries allocated to a folio.
> > >   Newly allocated swap slots' count has to be increased by this helpe=
r
> > >   as the folio got unmapped (and swap entries got installed).
> > >
> > > - folio_put_swap() - Decrease the swap count of one or more entries.
> > >   Context: The folio must be locked and in the swap cache. For now, t=
he
> > >   caller still has to lock the new swap entry owner (e.g., PTL).
> > >   This decreases the ref count of swap entries allocated to a folio.
> > >   Typically, swapin will decrease the swap count as the folio got
> > >   installed back and the swap entry got uninstalled
> > >
> > >   This won't remove the folio from the swap cache and free the
> > >   slot. Lazy freeing of swap cache is helpful for reducing IO.
> > >   There is already a folio_free_swap() for immediate cache reclaim.
> > >   This part could be further optimized later.
> > >
> > > The above locking constraints could be further relaxed when the swap
> > > table if fully implemented. Currently dup still needs the caller
> >         ~~ s/if/is/ typo
>
> Ack, Thanks!

Hi Andrew,

There are no other problems reported with the series so far, for the
two typos here, could you help update the commit message?

