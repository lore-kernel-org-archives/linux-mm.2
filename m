Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E52606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 19:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rA5M1AgM
Received: by kanga.kvack.org (Postfix)
	id C6CA66B09BD; Thu, 22 Oct 2026 15:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D516B09BE; Thu, 22 Oct 2026 15:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C836B09BF; Thu, 22 Oct 2026 15:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76B286B09BD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:58:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E679C801D2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:58:01 +0000 (UTC)
X-FDA: 85351323162.28.20957EC
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0261140005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:57:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rA5M1AgM;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792699080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hscKTf4XlzodRG94Ygsf46yIAyJRuA/Yo9qi+4i8HA=;
	b=EctCrwwhe1aQLwLdlni9BJu9fbuFdYJjxiNPQHeJzZrgD7phRgYTUrmf2XnpFYHeCa4zH8
	LPZ+CNEDrLK5thakmWPgp9mFPi+gN8zY/wdHeGEzKGw1kXJhxoZ74dlmNBR/wFOwORAL1i
	h5sOnvIQ7auAQ/bLaPD7rNDRU65Rlb4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792699080;
	b=NhTtMBNiRevTCZtluPH5fcfC6K8Cf2AvmECYbuJLOoW+igBRntyU+aTcCeIUpR02iiMVc7
	iF3ENcqU1ayecFlb8hZ08sRtLD2LEqygdSYOvO0y3goPa2xvWXAEbXOPKd5esrK8WDu0dD
	4IWIK7wHCf/90VKZThE8hSzJDZuJvM8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rA5M1AgM;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48c4649b35bso157692f8f.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:57:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792699078; cv=none;
        d=google.com; s=arc-20260327;
        b=qOIxFGr/qViS4EryUFK4cARrGd81jlj5zqdssOq/t69FkLSxPLhBJ8aBB9AiBjyIqC
         6RBRnh/QHSeoTR+lAREOotoarZX/P2lW6NcT7FT7+6docFrzyFMrMxSvplVXYdSKdjtQ
         Uj+v1R2zJXei8HHs3SAE6tXK94t+5D0+R54091fAAUej8ei6NF3VxO/ZZosyB+nCiumf
         iikjUhs1fCMqP7dZ12pMHqQDtpi04TMO2UQjwJqrjIQA4C0DA4M1IPzveHiepXvJrE/o
         nz6nvieijB0tnPoEJgri+CNauqSKsuIJ2bpjpKgSZcOZVOTEMp9ASeED8N9Fji7hOl56
         d6oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7hscKTf4XlzodRG94Ygsf46yIAyJRuA/Yo9qi+4i8HA=;
        fh=avMBEAQ97IBdaO/Io/SV1zdYYQ63+yuJLnvAeOoQYhs=;
        b=PZ35V8SpqPhRGHZcVLStnHV5Zf1VICWLnnCAUwG+eKfko+/fj2y2QRqB4L/0Yr8ugF
         qG0/EDBKWkTrSJVk7tc0ulY5j6I5Awbsf4UWJcqIoaES7VLhJqf0uIrYiXfLo8eM5ARc
         DH2bUWmguTveHd3IK1divIns+Utd5JxN9QtZv+V3oKCoGo0yGcBWD4S0id5rCw55P43Y
         5dtOvz21NFU1m8WkKLqIDSzhVq2g6fw5hRv06zDD31KmdGQiCjkQCRmVN33I2ZHMBG5O
         MuASRAfexAsQq+NVyNGDK2EI3KOfUI3wKAXzUPhstfhqyE1Lyq1fcCYf60e4udLmscpW
         XDVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792699078; x=1793303878; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7hscKTf4XlzodRG94Ygsf46yIAyJRuA/Yo9qi+4i8HA=;
        b=rA5M1AgMRQAQUX1vYQGKpLutjRVPpXfeKH/6xm7UF15mU3Bvh3Rzesj+3xVSdO7yqW
         hO3eErExDVOXVm7aRCgcmnrhlN1WQcesAvFJFI/kvM3OPqAY5at2mhC4muTJOKxZoL+X
         Qi+rHwFDXeceLS2pArDtWpQM5QH/ZCf9tnGsROPDgHKNjbpNTgj9sxNjruDKj97MD4br
         rz3GOarRxvrTr+K+4MShR7DCS3DwzLNU7E5/mlvoTR6EUrhACfm5qD5jq9mnZdg8vzoW
         WWd5oJMGNW+zTzm8A2znV08pH9x0h5X8RshDMQYCTms7mSsOOwWDOrQr5x8sOgsQcniW
         16hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792699078; x=1793303878;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7hscKTf4XlzodRG94Ygsf46yIAyJRuA/Yo9qi+4i8HA=;
        b=OHhSUHxuI5zOOoT/yj8amM1Ws4vDNm8zP+hsGEGSBhmeUCx1uQD3iaDA4Yns3OYrKw
         QdZ3mNmIPEEMC/zWm80jzcHL6vYg4XyZaUlEWIurgMpMODxfK4a9bWCMH4+ihhGsO5Uk
         XHHZxOYYvPAcO8bUyu+E+X/Wlsvq5VrSvtLZf+BsTiql6/uN/0fVMkPjjW9JKrtVZvtE
         eSw9sby5hhixorEknkONbrinuuGYGN3FD6DCojS7Q+3XOMivA0QPyZP8yhdYnUT6r7dX
         Uh6i+yeii5PcS36KnA75yf7YL5bEbIA9WDP/aTbyToHMBe4tnyFtYFNGBeWdUmhP4LIv
         OnyQ==
X-Forwarded-Encrypted: i=1; AKwUvBz6HOZUTvJwON87TTWYUJGs4nYHZFOe8CK4/9CH4LrvCbkOwFlS/eXN7W0FYgatOaeyMH+Wn+fz1A==@kvack.org
X-Gm-Message-State: AFq9FYJ5hyFOC9z2io4KxOACWylsL1XttOBGX/NqzCWacCIWIgZDFc6A
	qIMHCzlX0DXyncTnIC3Vp5culxAkrGbsDZZwGbGEt9KCyRUareJqHJDOb8rUMyX5+Ww/1ZqELvr
	DaPGcc0oNw2q66AAJJ7RJTFUDhDzk+C4=
X-Gm-Gg: AYBFou0PCZAuiLFgB/pDl8sAz8kBoDmBjeL4yqtT+knfkYniZxB1fNXsHBf1Jp+gUji
	yoCymxHOOZIv/Dh6XAesECr3B7ZoppeNdjq3Iram856xlb5LotAH8kXLoGx7fj8/a0RYGNHAWjL
	AjTm73mBct3JZIxF0qFrbkCdEUJT6ZvjtuucUNdJVjaGQsco7JiI83CnsR7EmcleUARJ63icsSs
	yfXjMpt+0cAxWUKfRYVWT8pPv9ZZ/AJ6VNRvJ52LVpzrISvA3tuScAh0icfsIqk7OgUriyTz3Lw
	VyqG9D7YjjmJPLP+g9jjFc79m2W83FR5CrZ3/D6LzexnF1zRblnQ2rCa85L4RK8zt3PEk+FgRjE
	ja3+1DtIr5Zsck7nPUf+FXweg3Lgm1n5HTwyDF9YFOuNAhml2poraDlL7r11FgBcCZ2vm4o+ntN
	hqBgJSaLSgsCrSIFzCGaKlGuWFefg5GGp1Z/3f9VPvXkMyzf5utd2D
X-Received: by 2002:a05:6000:22c4:b0:48e:3697:708d with SMTP id
 ffacd0b85a97d-48e369770e0mr1492084f8f.12.1792699078144; Thu, 22 Oct 2026
 12:57:58 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
In-Reply-To: <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 22 Oct 2026 12:57:46 -0700
X-Gm-Features: AclHuK_UzTcMr7msR_WYzh_P63N6RSYUJfSh6wr5YsFhVd3E4AmVHYZmGVyiC2g
Message-ID: <CAKEwX=OgEhyVHdGaRbVADGS2E74nFdpZeT9CLup7kZ2JG-QJtA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/swap: keep reclaim batches contiguous on swap
To: Kairui Song <ryncsn@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0261140005
X-Stat-Signature: bgecia1r5kbahe5bhdy5s8nrs84bgntu
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792699079-678874
X-HE-Meta: U2FsdGVkX1+o1B3L/Ev+pI82TWIPQEeTjniEnJz0M6gFuAsIOLjnea273dbt2MOQX3CDKP6Q78kvKDMQuV3+Y9vqllyVO7HE4hD85CNS9J8i1fJVGut3g+U8PvDDE4s4hjXBurYdG17ZwI9bs5fXpZ3xXzT8ig3OeqyOhh7Cu9G8ky49mrJx1tM0r1Qu1EixOrFt+XhjgWq+VrW+z3ujqRFbWPS1GDEbgMTiP9lsTZjlMED53MCK5BJLjjalBc/HB5aL9z5lMR5C2z36aGZTDIy2yz7DhpXM+NZ+m9/kqAZxMfQNm0lsx3+OWhRa1tagUDnJawmeJEH5dw6unGcoTmuwrfEq9dTE7f/eLj0lkmrpHG/6aXrU4/9Pr576hXb7sCk8Pda8+1QNHmXQGsOBrf9LiNJp5FFv0whzqD8kOXfJlhCHD4erf24XAvPqwPyXT/DyYcNgDzGUG06jCT82PGCF02HlwG27+IKJPeyG9HJPn7mNH6PYYUD/AwHtpyU/z2d3/d1791CgQSNTTsP811d1eV4opKhgsQrtI6eiumRvaHf2En0wFPop7wtwPtkwhOQFl6KDrpHmTebX7gLlTkwVO8Povr/SUnWkzWLEkaBRgInX2OiPdNOJ2azfxF3CiqHZdCc2pQLFiIem6LcvzV5im3Rliwq0u4hUrG4fr0OgATinVH9oYZmufuXAckCSWM7Ic/dAQml9Ae/dP1fO69TdbcgCvvEdMjXuFmhjxL730u2cdJrSZ/1BsYn1xVCDse4GtzqWR1duHz2F+01E4F3eMnpN/JGasf8QmS9F5kfm536sCewzrCkP5GIWGqv/Rl+2wAn7WZVHtg7KQQuBzq0u5Rydh4pSo0oFYbFvMuqZ05t34pNQRuMPK+0J2ztoKw1bGrapHgtLtqIZk+KXgg2Tj/75C4/PgkbjPYEYIg4zNdrGfR2e5KxwoYLImPqKGVH64mOlGQcBCzIaFAk
 7AJyTXTI
 7sp0N2/8Dhu5rNzk6T2U/fF66U8NPi0LnqsaA0yRz8qcAKX3lujUsAA4FJEucj2znLmGIhEn1FyFEOviY6P7WuKnPCv2krixA2h8DNyLF4v45pWcBjhjhFmKGzFPSezKKMYIugrFCBnWetx708FrG4A7kafLquaxM6JIceAdLP/dXxHcOBMHF2kZNgd4YC+6yH/NuXx1sgVkg8UIolEEW3Ry0G7GSFry4m1cnEJGTzGFfcw6Q1LE1tv4u6llAXecptggXQR+J9xzHnbsZMdg0Pcr6q/eW9O0xzpUaXOsBb5doHUllhkH4dM1ykRCz/z4ms0JHK2lQst0KnC2BQhYZeZIJ0e0yxkCXbJzQr1poCfbEcTKWzcvN7JrCYqWCvAxILv0CRf9Br7rHMU8D2BKnCERkdL0g12t7Uk3Yys/vaQQUtwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 8:27=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Oct 22, 2026 at 11:00=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> =
wrote:
> >
> > 7.3 regressed swap I/O: for the same swap volume, a workload that
> > rewrites swapped out memory sends many more requests to the device.
> > mysql/sysbench in a 256M memcg swapping to an NVMe partition, 7.3
> > compared to the previous version:
> >
> >   device read requests per transaction        +59%
> >   device write requests per transaction       +27%
> >   throughput, iocost off                      no change
> >   throughput, iocost on                       -19%
> >
> > Two commits interact:
> >
> > - Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters"),
> >   in 6.18, makes order-0 allocations fill nonfull clusters before
> >   taking a free one.
> >
> > - Commit 3cedb745d354 ("mm: clarify the folio_free_swap() for
> >   do_swap_page()"), in 7.3, frees the swap slot on an exclusive write
> >   fault. 7.0 to 7.2 kept the slot, but only as a side effect of commit
> >   4b34f1d82c65 ("mm, swap: free the swap cache after folio is
> >   mapped").
> >
> > The freed slots leave holes in full clusters, which then go back on
> > the nonfull list. Reclaim allocates slots one folio at a time and
> > merges the writes afterwards, so a batch of LRU-adjacent folios gets
> > scattered over those holes and is written with many small requests.
> > Readahead later finds those pages scattered as well, and needs more
> > read requests to bring them back.
> >
> > I tried three fixes, which perform similarly:
> >
> > A. Revert 3cedb745d354. This keeps the slot on write fault, but undoes
> >    the intent of that commit and keeps swap space pinned under dirty
> >    pages.
> >
> > B. Below 50% swap usage, make order-0 allocations take a free cluster
> >    before a nonfull one. This is what the allocator already does, at
> >    any usage, on swap devices with discard enabled (swapon
> >    --discard=3Dpages). It is about five lines, but the threshold is
> >    arbitrary, it stops working as swap fills up, and it applies to
> >    every order-0 allocation, using up the free clusters that
> >    nonfull-first keeps for mTHP.
>
> Hi Alexandre,
>
> That's a interesting problem. I think the real problem is with commit
> 9a42aed48421 ("mm, swap: prefer nonfull over free clusters"), right?
>
> It's more like a balance between fragmentation and contiguity of small
> order allocation issue.
>
> Perhaps we should instead always scan the full clusters and revert

You mean scanning the free clusters?

> that one commit? That commit was only following the idea of keeping
> the allocation more compacted for that series, it looked good at that
> time. Since fragmentation issues can be solved in other ways,
> contiguity seems to matter more for large physical swap devices.

Hmm what other way are you thinking of? Physical swap space compaction
requires vswap, which has not landed. And we'd just be kicking the
problem to virtual swap space. Sure, we won't be failing allocation,
but that would still increase the memory overhead, scanning overhead,
etc.

I encountered this myself. Remember when I wrote my own swap allocator
for vswap? In one of the version, I went for free clusters first
instead of partial clusters. It fragmented the swap space, so I had to
copy your homework and went for partially used clusters first...

Anyway, maybe I'm wrong - some numbers would be nice here.

