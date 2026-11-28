Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7AB606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 08:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dr3h00Od
Received: by kanga.kvack.org (Postfix)
	id EB52D6B05B0; Sat, 28 Nov 2026 03:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BE86B05B1; Sat, 28 Nov 2026 03:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2E96B05B2; Sat, 28 Nov 2026 03:30:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E07D6B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:30:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9E3B1405EB
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:30:55 +0000 (UTC)
X-FDA: 85483857270.17.D25F7EF
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id D31F380012
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:30:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dr3h00Od;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795854653;
	b=IPV6gjbaGXGJZdLx2J5zUMegfOn8QvKq/Y6rSg8mp77mPYHKdWdDuw2bDRyEJBW42/aco2
	+N6EXQtb3Jm5hDFTq4gOH9Om49EgU2yPWAO7lLmoYt6uI9L3rvJeugbVSPt3RoEtkZcwc5
	CaTG3oC1PXzPeZkK0/nXsGv72yuC1ro=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795854653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2Q52GxCMEZl4HDs4hZyfmdzDvybpMl+g3ldC5msgCc=;
	b=czg9Yy5g5vpdcfcsIpe4oxNh2CMfGMQwfHpxYrPqP/4VsbxkIKvOG2767KSD36mP14qCgq
	g4iarxwUQR0HeOHAt/u86CBhAfD9ZeMJXCvtGjrkvpLPO37UuOAL7+51JbgSjr9KA9Zse2
	83svjM0uuf6Qcp5XearTId/1BvRpw4o=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dr3h00Od;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4d427836e9so1156743766b.1
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:30:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795854652; cv=none;
        d=google.com; s=arc-20260327;
        b=gA1vc0SoiosPYeJf+rC29J9Toclo1bGk37cWPIR6lp62o8R5MMzIiEEkPxjPnkHNoJ
         62WZFbPmGZlb+WObgbi4xkPQCdKElNs6yspouTSr0L6lfLXoXS5Xb+LEw4QIGA3IEDPD
         gUThk+fw5ym+ru71m1zFWE7XUaizJkHgL3UzYIBju3u/jPGpzDY5IlsGwobZBMD0MFuN
         hqN30IkN6i3hh74vdctIzZh+eSR5QwDzPv3g9DlVCM8wF7vr95fz54NZB3s01LIRzzuC
         1VmCKYKfNOXtVEljRRVgX3fjkmoLPimhSZfNKFt38xy4erRQq0NbP6bTR+KE8yYixPKR
         l20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P2Q52GxCMEZl4HDs4hZyfmdzDvybpMl+g3ldC5msgCc=;
        fh=hqEk52lKjeOJCv9q0dNydaCGItVLynFdKWUhDfZCMzw=;
        b=QwMsz7aYqH3OzedKKSyHaEvJuo0q3dsHlFP6fzSxFgvtjL4Le6MR8feNuSsIxET276
         CHVHuhCFTCTmpJfvgG9vUMkHqX7UNFA1y9wCbUn+itac3ZLpVrMnLki+4JwBVztyGvXj
         q0/1iUuIDK/Q+L2ej5ZdQJQyHIldDCf1bG1XlsRgrHnCjTGsffQnZF6D28sF60w7Dp3z
         Y7Tw4HPn5eq18pNYcvbLfyXb7i4eMDCh/ALYx5RoAbhKzNdQ4KLsn2XNvFgUjlgnw27W
         oFZ9eJL1mwYxPml2j1Vh74bEXpwKbgJlUqfIurbFtGzVLhJl2BvTfiH0HD27OHKkxUud
         ZABg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795854652; x=1796459452; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P2Q52GxCMEZl4HDs4hZyfmdzDvybpMl+g3ldC5msgCc=;
        b=dr3h00OdugKgyA10aq6cmydieDHBO+ZF5q6T2GQLDgQ32FQMTbZhJDwicsLC4ek928
         evcAtJWAQFXVXa4YAJodFbzY/KaMCuGXuNuRk8IOdeiMdrOYcKklpiFVE1jzapaWLDJ7
         RbYvmsQ+pzAbVJjFQb642Zrgnf2NN1gMvYKTotvjRq3zT5sOUAssBdngSCE97JDcNtXm
         NY7JFT/1e7xqEIr2zqWPsI7ivj2yBm1lcaBy61emoxbwXm28wtG1drq1cRhJGG5UzkYD
         6ryXU4X7DcvHy5dmKW/Nots3OgSoVmwGcMaICfh6EhEBrsaLNZb9i1ixDlZHPKESSNU/
         eWMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795854652; x=1796459452;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P2Q52GxCMEZl4HDs4hZyfmdzDvybpMl+g3ldC5msgCc=;
        b=U5tCkmt/zIdcz5dlRr8jyxGTOkbKC7HIoDlyBcXXOBYim5rZfOOEmVmGJZJxYHqg6H
         LN/GrxyXXevG2jMabbblug5qdzKbqHlRSJA3vuIAP3DzTTvsjpJy7cMx7j8MvXCKjbCs
         etX9zgvyfzPzdlhevdnrJuFH5LBrzbgYxEC5ihvYNPQhNiT6kvTJZtUePemQ8eQsCheQ
         2eACBAjUMJJBV8luo+F093mpHZVionOzWgpOCX4KsAz2XwtCAG64wTPxXLSJAQUpiW4M
         jnUZqJWkZARWVEZVqLQ198Zc5+0PyYO7XrwuWcjQbAc72/8Q8LFHpebxP15SqLuXj9FI
         DPag==
X-Forwarded-Encrypted: i=1; AL+hErHN5di89GpMYBcBme1gWxXS6c6T2uVzyPb5UtZ3NtVgBS7nP1igcdY1ZodMiEFBUSQIJgA+Ua6pVA==@kvack.org
X-Gm-Message-State: APuU4Z+vZ0UCpiWrkTYNGF60PHmWaTfLRTRVnd4fBbEUPIc4HlxnKdPq
	TTepxwix4KQapiLufu5GH++lJlpguVz0UTXS9xAedkoZuBZzQBa5jZpaHUvjC8/DfthvIF2A9IH
	FT5CV1NaLib60iXp1m0dgmWsJLwxxg5Y=
X-Gm-Gg: AZFdTZfGO4T4lWXTOAXXXv9bkhPsqv/HzFn/cLOZDc3vLyIrKHcy7VYYZ/6ZX5gjmxB
	+rCiD0YYqHVS/Dw4mQA2R6AamDWeQV/KIXnL++PQX3ybvVl70/49U7WLdDKzFa0ZwcCpSWuPSMN
	U95AwSlRu1cJKpmDp9KtoiK5vX4YOXqWj0IVUznwyqJs5JjvefmtWwGmQUPF6rQW33cP61MjcA4
	RqYOQ30eOXKXPzysqWLj6tFBOL83AXG/grvlNYZLTNaOuln25URs1KrJ8bUxu3Wb2XIJjwfVbk/
	zKX+0PDiFgwHsDwMirw7g8qlyN3Yp1591y8eBPPNSG0BkDNJMidw2xUUoO9AFc1hpjAbOefRuCm
	14gW6+2HWsqMbU2Z4Cg6g6e8duxWkbX3WKgyUraBGia1zvORvz/My2uNCcrkt7tchN4dTxg==
X-Received: by 2002:a17:907:3e92:b0:c51:f490:cafe with SMTP id
 a640c23a62f3a-c51f490cc10mr37481766b.11.1795854652104; Sat, 28 Nov 2026
 00:30:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261127060315.1119672-1-ridong.chen@linux.dev>
 <awnYv_mxag0b6Dny@KASONG-MC4> <42195463-c50b-4f80-ad2c-ecc106e4c2ae@linux.dev>
In-Reply-To: <42195463-c50b-4f80-ad2c-ecc106e4c2ae@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 28 Nov 2026 16:30:15 +0800
X-Gm-Features: Aa3M54rMbjNwJ7oImu3LSpCZcOG_5p-yKxnwvdc0FGrAzCDAy6QTTWaaKQXRVDY
Message-ID: <CAMgjq7BPMcW=F6KtMZe05Nq4kBqQp2Pv991YOt2qv_OLhkbsCw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm/mglru: shorten the lru_lock hold time in scan_folios()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: D31F380012
X-Stat-Signature: t3sx9aze374j6h3uiukrkjpzzmn3cpys
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795854653-981026
X-HE-Meta: U2FsdGVkX1/gI8Qx0w3fS+Y9M2pLUrUe53MduejGeW4fY6inoYEWMWZb21Yacvge7cjriP6ZFLSHkG6moxzHMKhZydgvLB+AbNt0KBSUQsulBPA7MjW3/i9m1SnVzrIBdO2TFnT93XGuFsNT9Vr/PiJ8wlU9CbY7Yr0tpdp4FdwDLVBg6ca+h97kpUms4ol24EBkl7rsxJovaw5vtFBGnKRujY58i66XIzifcRZSdgoAl19evJJ5bg/aCEIGc6bq3Q8C4hvGI4YDUKPJ/RFTF/mMUn4ngybNG4imus7mEDN8+6/voe7z4W2REXznW4omunHW4oSyzRlNs9Js7iP2bJXo16qK2tsiXgGGm23dR69v1H/pSFX/ECgeBN/r511oPNVoB6tMkJx4bXpmBCs8QEU2gWirEnXQ2J4V/qOLkjy38+3NeGzs6nF6fiHaEGTwONyun6TNEY5M/jgWxLB8GoWFX4hglQuGGzLeQrJusSEpvmMAuHNmBzJz3XGwsAFcsRFHFuKypVx8KMA9z2UqqPJ6Qbopp98iJ/JlIgCcmSvSu37qD0WHLW9iuNQGvh6gDTgfAVW8qiqKBjYgf4aApN4pHMSgUdRmGaQoMD1YYCi9e8r8BCHVCqBfPuERLyHjuS0GJjkDoxmap8065SjmJq91mJBTudo3hULeyZp9Q8BWdeFbAQT8y7tlZdHKpyUXK9aI7qumPTNMnpVLLzMDFUS+RmP28KJ5LwAgWSIKehJuHbn57t+tWt1j5IPR78KZPAPxc+bXCYA49o0kgh0VO4qxNWeqC5B6jCxylbAwS+/VRLCEcj1t7lDzV8WTp5FO5J6hHdtQKA4688D1+DGGdv4DVFIfxlygw48S3InnLsTySP5PCQiTtHis0J3t4MSiFjk4igJUwfu0wDaPkW5PfNIXTfn9eEmK4FGhmLaw8GDdw8OIbzQ7+j/NIGRA+BLczvvtsi8QgUtYYRhGsvC
 bTuSJ9Qz
 /eSX0arcRhcpB7jlxG0O2geMt2eftNRZNLBZ742lKYUeK4Yk44/H17hqNrcRzNY7CsEFfik2FWwYM9oxS+ziTqVTdj+i0ErkFU+eIB4tDcqIFErCEPEIZUbtbEcoVEnfphEopOSuxkIJ1q7Z2cjJL76BP8DMG71HbneUpCqmkeBxx82n8X0qvRWQ8pMGcjHmrrEV6Slb6RoCBYwKSybAbQN8JlRUVCqVQbZx5IvAYUIDTagP0NgcO0Hi4bs1spycFwystLW53iQlFMoiorzWam3AgEiOCet2xClwd9PXAAJxoneTA8KY0fT/tYqaWuK+oR9ZL/0YSCbPjE6qR6v911XwFqJ/YaxHmOfgCm+32t7Ov3c7ia3v3EMMAMoJNXSIFR2Ml1ZH5nmMpvz7hMkEFJyuf8kMf0XPPuKB7ZJU/nA3YZvZBxangzL8NUdqOUi6z9pDRUpUuO/RdMEV6p21r88ehw6GXysuBpxf6C1A40zF6dFN3yui6XQ9339sxcxUA2hkg5hfTbTlLVruF7E9+JwXM8dTbJgsKA0InBcmwTb9TYvTUqhevkHR3s710TaRI/E19/BX/HfapE4X4MYUMojsevVgENaaNrNzS0F4idHJrytSBUbT4+hDixRJ33au5rA5Z2Sn/emgEx3B+6kVqJodZF8AXQi+5ig9/v04pKl/5S/IjnaKSd77xHtG9GulwDqpbLCFVuh9ewsiffQIiC7UZ5PFq0tGu2Ob7mInm4ShVYdx4MLc+bRmfHuz/g6aS5Ks5d0pFnPOzH4YeBkFJhalFBtph7YWyf79onH4DbnqKqj3Vzw4SFUiWlaVPA277eTWR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 9:00=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 11/28/2026 3:34 AM, Kairui Song wrote:
> > On Fri, Nov 27, 2026 at 02:03:13PM +0800, Ridong Chen wrote:
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> When many CPUs reclaim from the same lruvec, they spend most of their
> >> time spinning on lru_lock, and the time scan_folios() holds the lock
> >> limits reclaim throughput. With 24 threads refaulting file pages in on=
e
> >> memcg, about 40% of all cycles went to waiting for lru_lock here.
> >>
> >> This series takes per-folio work out of that critical section, along
> >> the lines of what isolate_lru_folios() already does for the classical
> >> LRU:
> >>
> >> 1. Update the node, memcg and zone LRU sizes once per zone instead of
> >>     once per isolated folio.
> >>
> >> 2. Prefetch the previous folio, so the cache miss on its flags and lis=
t
> >>     pointers is not taken while holding the lock.
> >>
> >> Tested on an i7-13700HX (8P+8E, 24 threads), turbo off and the
> >> performance governor. 24 files of 128MiB on ext4 on brd, all threads
> >> in one memcg with memory.max=3D1G, random 4K pread(), so nearly every
> >> read refaults and every thread ends up in direct reclaim. Reads per
> >> second per CPU, mean of 2 runs, with and without each patch in one
> >> kernel and the runs interleaved:
> >>
> >>    CPUs      base    patch 1   patch 2   both
> >>       1    426681     -0.4%     -0.2%    +0.3%
> >>       2    387442     +0.7%     +1.2%    +1.4%
> >>       4    360312     +1.0%     +1.5%    +2.1%
> >>       8    314549     +2.5%     +2.5%    +3.3%
> >>      12    235058     +3.2%     +4.3%    +5.6%
> >>      16    184086     +9.4%     +9.2%   +11.2%
> >>      24    124478    +15.5%    +16.5%   +21.6%
> >>
> >> The gain grows with the number of CPUs reclaiming from one lruvec;
> >> with a few CPUs there is little contention and no measurable change.
> >>
> >> Ridong Chen (2):
> >>    mm/mglru: update LRU sizes once per zone when isolating folios
> >>    mm/mglru: prefetch the previous folio in scan_folios()
> >>
> >>   include/linux/mm_inline.h | 26 ++++++++++++++++++++++++--
> >>   mm/vmscan.c               | 18 +++++++++++++++---
> >>   2 files changed, 39 insertions(+), 5 deletions(-)
> >
> > Hi Ridong
> >
> > I have a different approach proposed about two years ago:
> >
> > https://lore.kernel.org/all/20240123184552.59758-1-ryncsn@gmail.com/
> >
> > I hesitated to push that as the end to end gain was not
> > that large (5-10%) fio and it makes the code too complex.
> > But I think that one may work very well for microbench.
> >
> > I tried to resurrect that 2 weeks ago, but realized it's not
> > the best time at the moment, there are too many things in flight
> > for MGLRU:
> >
> > https://github.com/ryncsn/linux/commits/b4/mglru-isolation/
> >
> > Perhaps we can discuss and see if using a "batch struct" could
> > fit better later? It should also unify the aging batch too.
>
> Hi Kairui,
>
> Thanks for the pointers.
>
> I'm fine with handling the batching together with your batch struct
> work later, and happy to fold the nr_taken[] part of patch 1 into it
> when the time comes.
>
> Patch 2 (prefetch) is independent of that, though. It is the
> one-liner Chris suggested for your v3 1/3, which he said he would ack
> if resent on its own [1]; the inc_min_seq() half of it has since been
> done by commit 5d3664f070f0 ("mm/mglru: move folios from oldest gen to
> second-oldest gen from head to tail"). It is a no-op on archs without
> prefetch, the same thing isolate_lru_folios() already does for the
> classical LRU, and it gave +16.5% alone with 24 CPUs in my test.

I'm actually a bit skeptical about the real effect of this, and the
previous work for inc_min_seq... for example if you read:
https://lwn.net/Articles/444336/

In my previous attempt 2 years ago, I did more than just synthetic
microbenchmarks, on three different CPUs, 5900HX, i7-9700, 8255C and
7K62. The results changed dramatically; it's not a x86 vs ARM thing,
but is strongly affected by the actual microarchitecture design (which
is not surprising). So my conclusion was that it isn't worth the
complexity, especially considering that modern hardware branch
prediction is much smarter and memory pressure is mostly random. In
the longterm we should work on getting rid of the LRU "as a double
linked list". The branch check may even bring negative effects, IMO.

>
> Would you be OK with taking the prefetch patch now, with batching left
> for later? I can resend it as a standalone patch.

But that sounds ok to me, it wasn't too ugly now considering we
already have all the wheels. If that solves the problem for you, let's
have it.

For the batching part my concern is that how should we balance the
stack usage and batching size, vmscan have a bad history of causing
too many stack using, with a batch on stack it will get worse, perhaps
we should put it somewhere else, but I think this can be done later
too, after FG maybe.

