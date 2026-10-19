Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4CA3606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=M8bfXhwQ
Received: by kanga.kvack.org (Postfix)
	id EBDF66B0330; Mon, 19 Oct 2026 14:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95AA6B0332; Mon, 19 Oct 2026 14:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB106B0333; Mon, 19 Oct 2026 14:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B49136B0330
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:08:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 503831A0850
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:08:23 +0000 (UTC)
X-FDA: 85340160486.23.18A70D7
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D068A0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:08:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M8bfXhwQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792433301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEHqrQqIUJuEAEhLJre5IVlU0Gf59c6vRQqAHHFJVMc=;
	b=6DAjcBfhNO8WMmGh+wyN+r7A77rT5+P4k3hnMPanzAV/A1BlgX9kjjKjKcYZhyLTLjI/QB
	JJntwAxtTn0gSL2Pf/TPbLz44HHr2oFQz0CAKWQ88OG/syxpTXB6NT22vvICNrocdfMHf0
	LgMmck6DnEguTkkR/jbQIeP7Dswa+LU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M8bfXhwQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792433301;
	b=vuE1RfAmcLU0KgP17+UP1XZnY1u7nZLYWQBqiWtq+Tnp+tu9RS6MuAVyPJuwiaurulYb0G
	Yd10wzxoIE+8VyxS6D7Xm24KWNL4vdDTch3DJA0exSCcOBh0EyL8RDVvFImhScmz+GhOxH
	vXLaohf6xPG0VhLwNyKZAeksi4l9Qf0=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4956869750eso19393105e9.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:08:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792433300; cv=none;
        d=google.com; s=arc-20260327;
        b=H/w384J455lfqjzP11g9lv7uxYTaZSXur5b4gwI4rmpi/+nn08oCxY4mi4w3JeVaPy
         RlI4f/m2n2WiRY+8Ii6UWWWEBaNe8awnIkFKk6QFOvn7iLJPjExuYu6mIC5V+pcEwvxC
         r1kLcHkF4KYzI7lehVopiLFkbjFwg0B8IQiMsYj6EtQAcEbSO7deZksNzMOifWSVwxjc
         677jypf0SvKUm9s/IDzDS/239zaKgcGhgZqu72PbEC30qVe9LHMUAHakvHML8SOQiGjd
         zei1Q6w2mU7JRCqsU3XWZKXxA9rh+mYxHwaYuQysmtgQdVyGQaF1aEGgLTlUIq73oYkL
         h0KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CEHqrQqIUJuEAEhLJre5IVlU0Gf59c6vRQqAHHFJVMc=;
        fh=QTBBdStQaDSHt0XiK0FktbYGQPqz55Nm5SyJtKHJ4BA=;
        b=caVLy+gVCyit/exCpN9gsAjioPk4gSd7hctXa2hxBM3wBD4PMMEdtiSjruyJaaz0v5
         IkzMc+xcvagv1dYKrB9gIMbm3iHa/4UZtpBl6rfqqEwRIPzLLYwij2lq9akVFVF/knz5
         8aKNifS0WQL3CI5GhrdaQxzzhccS/unKKA6q3KwhqOBiPOKTJSzwxX25RGM71es4TgOV
         2ETDSX20iJUrKdA6kn6qGxo8DDKpmlOiDcGCVK69brNNUx6dLMy9VAWvpcCSohRf04iN
         aXMBl49RP1nSsTPpXfapmsI39jvS6PUcNaVLy7ihyljbS2ZUqijYJKcSnAHdx9lhwJwk
         9skA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792433300; x=1793038100; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CEHqrQqIUJuEAEhLJre5IVlU0Gf59c6vRQqAHHFJVMc=;
        b=M8bfXhwQl0BBs7nMDY0JjUw8r6OdhVuoCd10dvvGo2OX7+39xmyj4lD7k3PGJzawrR
         c9UfAw9Nnp9xnH3TEymAQ5Iedb+c9AzyZbdBA6s2cYhc1YbR9bvItB7M1i/SjwYZj72K
         0BBcGWpUOwuGsst0gtR7REyZ1sM7nrrORrx8jylV+wFUnsjf5s8KOSdtHW5briintK6K
         g/vOZoW0SUP0ZbE2dcB4hGgf74f2u/A2wq5UBsZiTPnzRUo8XuBpxDStvg5O7mjHm/V7
         UbsoFRaWjsgpDUxtN5AxbxWwKFdUOfzTF2NsndINp6MF+Cl0M97wd9WVLB9OuZUiBZdx
         tfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792433300; x=1793038100;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CEHqrQqIUJuEAEhLJre5IVlU0Gf59c6vRQqAHHFJVMc=;
        b=L7MHGXsSo12G0yNh8aBRlnzkx1QLfZ9w32ugHWYGMEStifVu/5ElHg5wrK1MbWDdbx
         gzaGAU2azx+FDnfFeBDPdGAqCyhKyUhRWehN8XgiMQCfWJkNYOSgpgGrDSEzBHD2PTQn
         803IpQr7WEXFG7qsg4XGZ1TBm3sSi6QE2jq03eibO+2CNW/R7WopoZV3hIyZmuej4ydk
         igIz6TdYXzpswi5H8sR5orhlfNKUTGCZWh/vtn1JvzpnMFwnLdCwxpGxocf7M9hPncpV
         +NL0GLgxC6dTkA/FiwaYKWt2TUU9+x+YXCv9kM+xp5TOqdO+O72YjCoS9uMxOzzyElh8
         9SHA==
X-Forwarded-Encrypted: i=1; AKwUvBxPJrh+Z2CrjiWz+f9CTgnEr7e/3wh8zYzkkVmcM9DikGa/MZWH4H7BXFCKuvMO42K3GQx7gWZl3w==@kvack.org
X-Gm-Message-State: AFq9FYJAHjJuNFd6GfYIUdmm9ZSY69DHVm9gRETfzPj0W0uyo6WR+Pq1
	6EAoq5exYcIj/wmQyQz3OF0yNIm3QburXk9VHOddfMeF+9AvA0B9OyeEBryLRSdlqIv47HZ6aSm
	f3a/femKgMGfdakeoW/L6hsX8t8hBNXM=
X-Gm-Gg: AYBFou2RBKDMseGwTg/AQsruhsmumgD0vEUzwVq8b7ZDylB7E8DsD8h0LnHFK0VAu4N
	7AwCj+e0Fsxl/p+HAnW40boTl9Vsd/lUzOWzjk9drg5MYF3+mD/kbfc9U9VgH3aOPTDOUOiLQw2
	6NK0jmSOEVLoSS15F5hQaGPiy/oF5/ohPHtmGQl7VeCisK9TeOUYIE2DZRIJAqFH5TH+apT7ATH
	Zb9MMt2hhZEkEsW/KC2+PQmlt5amjYYlDcxW5tisbVdyrkr6Orh6muENlEV4Y2xODEiYOxaLrZX
	YAG2eCpz+aFH5WjIVNFUACuRrKNrSwjAgEQiiRcFe9UnwNUm8cCktqGkbBK7pB1op50+qbY+FN0
	hv5LDSax1aYetNx+ORY1eupQSdxLV2iLM5PpI831eYFyUvOl8UOXfMH4TKvnd0wM2ud9YZB0=
X-Received: by 2002:a05:600c:8709:b0:4a1:ac85:9696 with SMTP id
 5b1f17b1804b1-4a1d75f926cmr156323695e9.17.1792433299484; Mon, 19 Oct 2026
 11:08:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <CAMgjq7D50X47JFsTnF2-jYGv7i-Nd3WhQLK-TJGy4XkhMQU4OQ@mail.gmail.com>
 <62d17959-d695-4fec-a87b-8eadaaf995a8@linux.dev> <CAMgjq7CJ+bwKgwUmCzO9Hr7TrL68bDjgAsLx-4AGuXo6zowh9g@mail.gmail.com>
 <CAKEwX=O4sPx5MtGL4-JwLzD4TWm7fNycFMiuOqLk4ADFUUipNg@mail.gmail.com> <4f361479-1dbc-4f09-aa26-e1ad6c06cbee@linux.dev>
In-Reply-To: <4f361479-1dbc-4f09-aa26-e1ad6c06cbee@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Oct 2026 11:08:08 -0700
X-Gm-Features: AclHuK9vaeh-jgxGcgdG4be4jSZZYP2tmKHzOooeZ7UEDXMX4rlJN14DJbM88jE
Message-ID: <CAKEwX=N4jj3PGXFx6wwh=PG4Vt6hRJ=-kqX24B55zoXyhAa1WQ@mail.gmail.com>
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D068A0007
X-Stat-Signature: srimhttry49tnkgcqddk51bobsracdge
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792433301-310687
X-HE-Meta: U2FsdGVkX1/TWfO2CqIDWmYrSIg4DJ6b7gUNoTpDZEjBe/87IztKG+xXxg6zxMzSRaNX9rGi7apAtlfNOTz8Vp2oKspQpcOg23n9MeqtK9/zTsQ+dl3bkbcol42ntHjg5hXtnHwLm/geiD6sWmNCfcib4GOExg+DKAzRz0G+/szEyUAmTfItM70kdDZsCxDsHfRy7i0XTd6960HG4fj8jMinoTpQEdKFEJsGTrkoFw0DCVpccUwnqxU5WNvrp5oG5IvhuaWEMQvWzi/6mSZFKwMhTNhHG38PTt2Eael5dO2j2D82ekIHU7MGpA7ingPwZVQHi0omWph67RDCQ+xOxHA7Km9Fs+KRS1niJAdJS0FL/5j7uB2RC/zZMv4f9O8+wEy0owucNzycRg3ryoyWNGWdMiU6GiQIysXFaPGobloR0Ck5yAckLPefY7QvoJ08hPVV+U+mJxheSt6uONm4PeHon4mg5fY9RINEBrQ21FrjBxUH97DMGkpQuMTudqhOs6iCjP07TbTz9ntELL72qCG84hYjoFCI52vZgu9zJhqOhwrZ1EQ+dOW5+MFF69idu2woHR1a3oiRZe67uyee8Go92dhmRYl9J+4IKgp5VQ74bcqdGZaTFv5hSV2eXE4ZbPUgi4LiyicZWYNiKYibcU4PAcH3dPUI98ZGzjiWuOnbE1mQQ2WeRms/GlNSBI58k8uhff8wb4o8Dly1/gNofasZKMECcD2a4ZxaU/lYqgYavZzRHkYjeoc6XJyNOSMXkTg1hkFyMnPNvZSixQNYB42BxRtgSkMwQDIzM71Kcx5MjK5+SIE56aZn3Z7opSFTyEFXxz9ltp7TMOagwT5wawKMZqmqOMwsYzAdbp4fD1boGw1lsrLlepivVB4eTR8VZl1kTODlY/Zh/L9RnPWbaWEnsNY12zdU2zXJsHoHAcTCdvOXLCk8VdzS52wFazMlASdijY8wxl7uVIrkoB3
 IGd3Znum
 mFbWKW2OPSeG9AISp50QwQdsBj4Hi1TLaK6+vWv5rH8BmviCLB0yY9t+5C8WuCQWIe3tY+CQug8unE8Qq+jd3qFzIxZOSoSHkww6FwH2IUVMJDlfDwbDvhFFDyVehWAhRR9SKVEcXv/AdT2j8M4GYkOcwToL0+4SHQMV58C41m5gZfXo9Qh+5lRwEiG8MepHmI4gFnKuKQSrQFnnjoogCu7ulu6tkVij9lTYlXcdoMzoJdwEtWkTjwHkj84z1VdrKIEee+EjOGQQV+tRpxAV1K0tnajM6TxpLU9o090iGBJsZAMJ3db9weqO1FkfcMICDX/5itUxQh+ATO3Y5Jp2X05noJFkSdDd22Dsi8+q+g6MqOIsxObi0ZziEJfxUI8vfiBvGPo12J/kJJCvsPw06k8qUOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 7:37=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
>
> On 10/17/26 3:28 AM, Nhat Pham wrote:
> > On
>
>
> [...]
>
> > /proc/meminfo | grep Swap
> > SwapCached:     489006260 kB
> > SwapTotal:      976561148 kB
> > SwapFree:       487554888 kB
> >
> > cluster_alloc_swap_entry() picks clusters from nonfull_clusters first,
> > then free_clusters; it looks at frag_clusters only when both are empty,
> > and at full_clusters only when vm_swap_full(). A cluster gets onto
> > nonfull_clusters in partial_free_cluster(), that is when
> > __swap_cluster_free_entries() frees a slot in it; after
> > alloc_swap_scan_cluster() has used it, relocate_cluster() moves it to
> > frag or full.
> >
> > A leftover slot has count 0 and a folio, so __swap_cluster_free_entries=
()
> > never runs for it. Once the live slots of a cluster are gone, nothing
> > calls partial_free_cluster() on it again, it stays on frag or full, and
> > cluster_alloc_swap_entry() doesn't pick it until the device is half
> > full. That is what the swap table looked like after the run:
> >
> > list      clusters   leftover slots
> > FULL        106415       54484480   (all 512 slots leftover)
> > FRAG         44822       18471614
> > NONFULL          1              0
> >
> > Making cluster_alloc_swap_entry() revisit those clusters means changing
> > the list policy.
> >
> >
> >
> >>>> Or, from the LRU's side, put swap readahead folios at the tail. I'm
> >>>> actually trying to do that and it's not very easily doable at the
> >>>> moment but will soon be easy to do.
> >>>
> >>> That helps the RAM side under pressure but doesn't give the slots
> >>> back.
> >>>
> >>>
> >>>>> Options considered:
> >>>>>
> >>>>> 1. Fix it on the readahead side: after the read, check the swap cou=
nt
> >>>>>      and free the slot. Covers the lock, not writeback, and the
> >>>>>      asynchronous read path unlocks in the bio completion where the=
 slot
> >>>>>      cannot be freed. Two places to patch, neither clean.
> >>>> In fact, readahead checks the count before starts the read. It shoul=
d
> >>>> prevent some of the problems but seems not enough.
> >>>
> >>> Right, the count is still 1 at that point. The zap drops it to 0 whil=
e
> >>> the read is in flight, after the folio is already in the swap cache.
> >>>
> >>>
> >>>> And another idea, what if we just add dropbehind flag or rotate the
> >>>> folio, if folio_try_lock failed in __try_to_reclaim_swap?
> >>>
> >>> dropbehind would work for readahead and writeback if the read
> >>> completion honoured it too; today only folio_end_writeback() does, fo=
r
> >>> zswap writeback folios, and swap_writeback_dropbehind_folio() expects
> >>> the folio off the LRU. It still misses other lock holders (migration,
> >>> split, ...). Rotating only helps under memory pressure.
> > Yeah might be worth trying. You'd have to modify readahead and zswap
> > load logic to check folio_mapped() etc. I suppose...
> >
> > I'm not sure how reliable it will be FWIW. There is still a race
> > window right? Albeit a bit smaller - the readahead thread might check
> > the dropbehind flag before __try_to_reclaim_swap() sets it.
> >
> >> Right.. But I think it will be much better to avoid such folios from
> >> hunging in the swap cache in the first place instead of having a
> >> worker to reclaim them. I'm not strongly against adding a reclaimer if
> >> other approaches are too difficult at this point though.
> > Also, IIRC, dropbehind can only be handled in task context, right?
> > We'd need to make readahead bios to complete in task context
> > (BIO_COMPLETE_IN_TASK). I wonder if this has any perf implications.
> >
> > Another idea: how about, in swap_read_folio(), where we are guaranteed
> > to have the folio's lock, we check if folio is mapped. If it's not,
> > invoke folio_free_swap(), unlock, put, then drop that folio from the
> > submit batch?
>
> At that point the swap count is still 1; the zap comes while the read
> is in flight. Checking after the read works for the synchronous zswap
> path, which I tried first, but the bdev read is unlocked in
> swap_bio_read_end_io(), in interrupt context, where the slot cannot be
> freed.

Zap drops swap count first, then try to free swap cache. You're saying
the read check the swap count before zap dropping it, but still holds
the lock by the time zap try to free swap cache? :(

I was kinda hoping this kind of interleaving would be rare :(

And yeah, I think if we want to free the slot after read, readahead
swap IOs have to be submitted with BIO_COMPLETE_IN_TASK. zswap
writeback's dropbehind relied on that...

>
>
> > That takes care of the readahead race. Seems safe to me
> > (I assume if a folio is not mapped and swap count =3D=3D 0, then it's a
> > pure readahead artifact, but maybe I'm missing a case).
> >
> > The write direction already tries folio_free_swap() before submitting
> > the writeback, FWIW.
>
> Same shape: the zap arrives after that check, while the folio is under
> writeback. On our box with a swap partition that is where most of the
> leftover came from.
>
> Every check on the holder's side runs while the count is still 1. Only
> the zap sees it go to 0, and it cannot wait. That is why the patch has
> the zap hand it over instead (very nasty i know it :( ).

Yeah I got no smarter ideas :( sweep_work it is...

