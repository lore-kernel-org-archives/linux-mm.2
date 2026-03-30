Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A161061B20
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F37E6B008C; Mon, 30 Mar 2026 15:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB066B0095; Mon, 30 Mar 2026 15:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0C76B0096; Mon, 30 Mar 2026 15:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 690046B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:56:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2890C1408AD
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:56:10 +0000 (UTC)
X-FDA: 84603785700.18.2B28EC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id CEEBB40010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:56:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FY5cD7JU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of luyang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luyang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774900568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12ccQsmGElhf26rhTcqNi+T5PgU8apQ7aXMoNwewgDY=;
	b=RafpTGy7UDnzjaLMdn21DHoAXwPgQwk1tT/9EG/pJii8FT0L0OFQ4wL9IZbhp7Pt48llNw
	c3ww3eNSHpdwODbDX6QS2QQIkT5BAR4zL/mAxgwVROoSTH1PBoXuBqdgEOKwyTcoUn2N6f
	3yFEF73AWuptFvyKT/AgWagVNVksonE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774900568; a=rsa-sha256;
	cv=none;
	b=yS3t5htIbhWiXzgtMdwxxvxydXCs0NsXwijYFt/kGE/rkW9PCgPYPL57XBJvfeh+Arf9aL
	A1wdON2VuV/fs1rdUF2YNkNTm6RD87/TaH8BBMl1rxDZVfa1s0lFlUrCV++U8NcAalHKIZ
	hN7AJA/yvXEy2lScA6ehv7qiQ+0GzgY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FY5cD7JU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of luyang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luyang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774900567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=12ccQsmGElhf26rhTcqNi+T5PgU8apQ7aXMoNwewgDY=;
	b=FY5cD7JU0+drHd3G7bMWsTTGlFCk17WIjSN/1HeHIMAhdvZrOY1PM1LzTAjXAN8knb3IqD
	OhmUnDL1LqMSSZWmhwbdhCHQKE2yZSSvaOuHrdS5gB0Fqm1cKrXXhXBaMu8d6s3ODNumCI
	L0D6a1PBtan57CxDctCP4CWgSOK1KXA=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-cT0tHJRvPEqEryLMeW0Qsg-1; Mon, 30 Mar 2026 15:56:03 -0400
X-MC-Unique: cT0tHJRvPEqEryLMeW0Qsg-1
X-Mimecast-MFC-AGG-ID: cT0tHJRvPEqEryLMeW0Qsg_1774900563
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6501c35bb62so2416165d50.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774900563; x=1775505363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=12ccQsmGElhf26rhTcqNi+T5PgU8apQ7aXMoNwewgDY=;
        b=INmG0wT8KVIH28k47xBY3oJKF87YUJsV5jI8reiCzJI90Ks7ov4zwe5Yk4JWqe3hlp
         bno8dtCYXUDbXSqM1dQsKs4Z4DQp+sm6mfEGuThP9dTw1iy5bRnZVmFBrcYHg1Zuu8WO
         8eIWGU+GKyIPu7PgMdhAOp5nk+A4UMRBfNhJ7RQCK7tWBBpOfLwPvV+AwQjMZNm9EFB5
         A2Bj2Li1jhYVcBARCIDxkMftaR8N794/4YDge+FATtAmDDqgJF1D21AoJ85+bAzqteC2
         gkoZDIJh9pJlOPiLjVvnTJ3VzUUQIZSPJfJ9p2pw9kVjhzhAYQQW2jgfKbDi2H3vMOWF
         HcWA==
X-Forwarded-Encrypted: i=1; AJvYcCUiLFNdRAHc0Dy8hwdJ+MtRFs2ZuEutvggDR9W5teEhEevitxWj7PH/L9xIc8IRhV26qIB8qU/sdg==@kvack.org
X-Gm-Message-State: AOJu0Yxu5S+ypGbTRZBCyu5jXcc5phTcm8EQuBpKkVvxAabSOu5vp0Yp
	HxjCeZQLGtVeg6o+tF6EWTL5H8HOU1UfqddoImRkD/D6oaaV47V0VSTZKfah4TeAfTsD9lITA/W
	Ca/0jIJSr/HndEqzpmbpsDcVx0dH8FXccUQ5lJJwPwmHavztLEE4A/77zTig72Jgujd+SRu9aLp
	JGeaBTyV0dPFOYQfR/kbMPRKJP4cM=
X-Gm-Gg: ATEYQzxqdaAmm2h/EzPEds+irz154oJuJQCyz891scAsNSQnNWMiG9nMEfUL7EBSTJe
	oGtAk+gBKk2ZXhQIjXgA8U2y3jAaZn2mDWz/PdE5gVofZp/8q8FSpWBmhSAtaQdtc3lRdf+75Qi
	XUF4FQqpySLRhF4UrYAXNCydHo9pnJ6ejr6r0Ff9ACE73t65Kiz2zKZKypIbrb92GkjXM4RMMjq
	eEoGQQ=
X-Received: by 2002:a05:690c:16:b0:79a:ca70:a20b with SMTP id 00721157ae682-79bde0de989mr140952897b3.42.1774900563163;
        Mon, 30 Mar 2026 12:56:03 -0700 (PDT)
X-Received: by 2002:a05:690c:16:b0:79a:ca70:a20b with SMTP id
 00721157ae682-79bde0de989mr140952557b3.42.1774900562609; Mon, 30 Mar 2026
 12:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260324154342.156640-1-pfalcato@suse.de>
In-Reply-To: <20260324154342.156640-1-pfalcato@suse.de>
From: Luke Yang <luyang@redhat.com>
Date: Mon, 30 Mar 2026 15:55:51 -0400
X-Gm-Features: AQROBzAByid42AP3TCQ4_zufnJX_cKTm4LDwH3SGL1r2VGvRbi7o7aoxpfGw7B4
Message-ID: <CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm/mprotect: micro-optimization work
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Nico Pache <npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: W4Z6r5UpXpV0aXGyrAzjPGyCcnodQtP-eUeA7Co66rQ_1774900563
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CEEBB40010
X-Stat-Signature: khbfcysr4iks3n4fkmkrer1r1e19gwdi
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774900567-968980
X-HE-Meta: U2FsdGVkX19NJfQ1yCXWyB3pIUV+0EMEFLu6MoEVU2S9TXVGA+EGAVUj0zegoTt1HwU4Y/Nh7+PV8BKQvw+G/xtoBiht78zv0w1lPgj/bvU51Wd5mRtvFJ6MII+Z+E5OsE+bb6hEqOF00rU36PCxgbhmZrBaQTWLXY+5lBmtAj1fs07YNUK1ewhGMtFPyExrvEHkQcfWbYJPEGjXHQeCAFsSW243kfU9fE0yET44d1IoB/cQh0Z33hgSMg0zfSSWnkDCCiTjJ5syAe9dGUfwWG4m221gvLd1yhaE58zXFblzcNm88ltIWkCYQjWjT2rUME6xWE3ja7/VkjE/MQ29o+bVRePu4RtaarzXGUBkegK+4cut4ao+IVw1sWnUlVHSKOqZ0iYn8XJ/jwtRtWuOt3VeD8t7nqLBaRMiP8df4/QFe0S6XribZ5VjCiX95lGFMFo6vsRMZsJ9uKF5GhBDpccb72e2q/w7fLQ1XL0ocw6JV6LTR4UVvfys+4QGx0cocYFrF2lQ4qTKKmu+sH98wAZTrS7RMJDnBoDlXNoupc6NGq1o45iRg07hnkgPCniOJUOW39uMOJesxoPx/B/jAsf92ig6t91YXHX1zeLOTAJpDpLTtgbZmrFyo9q2xfnK6g1CkFMD1vvZXGUexkYNBWBgTnvBJnpSAC1RdKPPljnGEutcK8PYlBAFzST2lsynZadDzlo9Ye7Fom2ag43vPWiXW6aioCFzC0Kl7V2NbzLNmY5Fky3xtW7UZSzO1EB0VX8YQRMoDstitEgNQS3c3xyhlW90SKZUiHhCjIYabeu3+sDXHgrHuJc+QQ0CRxfutMXsvuR/+e0IRQNJHjtEzr5TTwUUjcVsTdOg5hoJWqul4f2klVwUlFzJqNH0blH1a/WHdnkAdKbXwpCtw4pJxs6ovzJBIayF2vnBarDqgsGdyw85pLJUbkaIVcf6itj2U5Jd6gwGgiBNnD1rr+j
 Tz06mcuB
 rK5dQjkiHKVpFfPTOuoHeIlDSfixBG33XxeCjkb3TsNjWGYh/cTB3sWnS3fzYC0DIvtkbzpevBysAAZHXhLghs7umho/1TUTPMx5Ahw0tYB9T3WeEtK/RsvcTfhXciSO2EB3Z8VnxIFoA6ghBxBMt3G3CCPEkl5wHC4smkuo4ZFL6Bg3K5I7rHonPDm/LmfNG8mikwYREjHcIESzE/pYo5zNCQ+t9jbmR+pqikUA6STa+AixZZRp2qaGvd6ltN9Q25NNoOZ4QzvDt04PeHySrg/jTG61Qc1MlG9GIIUMrYrt+hZc1U4c2/Wfd8sRItvaSiQvb4ENU54JeQTv3xIEn8WOiH07Z+a8m3w+7y5aHBIWhcblh6Zvexa5DHNo1uTCH5HMipav97GUbLuygC339G6cyBUVw5AdC/SRhYvkrVE9y9FtBPcfkFTnNJ/fNnap9pBAERyvrmFfqsyEsCCx65t7pK2d9ZiWYsZBViMcADkljkFHsCFkrmMEPvdNGcqj9YQhuhjMep39O6lAV0LOuTadK9UQ2gVkNX6l9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pedro,

Thanks for working on this. I just wanted to share that we've created a
test kernel with your patches and tested on the following CPUs:

--- aarch64 ---
Ampere Altra
Ampere Altra Max

--- x86_64 ---
AMD EPYC 7713
AMD EPYC 7351
AMD EPYC 7542
AMD EPYC 7573X
AMD EPYC 7702
AMD EPYC 9754
Intel Xeon Gold 6126
Into Xeon Gold 6330
Intel Xeon Gold 6530
Intel Xeon Platinum 8351N
Intel Core i7-6820HQ

--- ppc64le ---
IBM Power 10

On average, we see improvements ranging from a minimum of 5% to a
maximum of 55%, with most improvements showing around a 25% speed up in
the libmicro/mprot_tw4m micro benchmark.

Thanks,
Luke

On Tue, Mar 24, 2026 at 11:44=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> w=
rote:
>
> Micro-optimize the change_protection functionality and the
> change_pte_range() routine. This set of functions works in an incredibly
> tight loop, and even small inefficiencies are incredibly evident when spu=
n
> hundreds, thousands or hundreds of thousands of times.
>
> There was an attempt to keep the batching functionality as much as possib=
le,
> which introduced some part of the slowness, but not all of it. Removing i=
t
> for !arm64 architectures would speed mprotect() up even further, but coul=
d
> easily pessimize cases where large folios are mapped (which is not as rar=
e
> as it seems, particularly when it comes to the page cache these days).
>
> The micro-benchmark used for the tests was [0] (usable using google/bench=
mark
> and g++ -O2 -lbenchmark repro.cpp)
>
> This resulted in the following (first entry is baseline):
>
> ---------------------------------------------------------
> Benchmark               Time             CPU   Iterations
> ---------------------------------------------------------
> mprotect_bench      85967 ns        85967 ns         6935
> mprotect_bench      73374 ns        73373 ns         9602
>
>
> After the patchset we can observe a 14% speedup in mprotect. Wonderful
> for the elusive mprotect-based workloads!
>
> Testing & more ideas welcome. I suspect there is plenty of improvement po=
ssible
> but it would require more time than what I have on my hands right now. Th=
e
> entire inlined function (which inlines into change_protection()) is gigan=
tic
> - I'm not surprised this is so finnicky.
>
> Note: per my profiling, the next _big_ bottleneck here is modify_prot_sta=
rt_ptes,
> exactly on the xchg() done by x86. ptep_get_and_clear() is _expensive_. I=
 don't think
> there's a properly safe way to go about it since we do depend on the D bi=
t
> quite a lot. This might not be such an issue on other architectures.
>
>
> [0]: https://gist.github.com/heatd/1450d273005aba91fa5744f44dfcd933
> Link: https://lore.kernel.org/all/aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.=
toromso.csb/
>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Luke Yang <luyang@redhat.com>
> Cc: jhladky@redhat.com
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
>
> v2:
>  - Addressed Sashiko's concerns
>  - Picked up Lorenzo's R-b's (thank you!)
>  - Squashed patch 1 and 4 into a single one (David)
>  - Renamed the softleaf leaf function (David)
>  - Dropped controversial noinlines & patch 3 (Lorenzo & David)
>
> v1:
> https://lore.kernel.org/linux-mm/20260319183108.1105090-1-pfalcato@suse.d=
e/
>
> Pedro Falcato (2):
>   mm/mprotect: move softleaf code out of the main function
>   mm/mprotect: special-case small folios when applying write permissions
>
>  mm/mprotect.c | 146 ++++++++++++++++++++++++++++----------------------
>  1 file changed, 81 insertions(+), 65 deletions(-)
>
> --
> 2.53.0
>


