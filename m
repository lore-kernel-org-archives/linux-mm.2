Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6339D606AA00
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VlCxN4KA
Received: by kanga.kvack.org (Postfix)
	id 706B36B00EF; Fri, 20 Nov 2026 20:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7056B05B0; Fri, 20 Nov 2026 20:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6336B05B3; Fri, 20 Nov 2026 20:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A70D6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:17:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A90F16028E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:17:26 +0000 (UTC)
X-FDA: 85457363292.10.9045CC1
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id A402FA0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:17:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VlCxN4KA;
	spf=pass (imf15.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795223844;
	b=jFBf0GoFMltewRFSqVchttsh7iYZqsn6hnwu79Ea+wIubEvYtLfdRJiBTbKUOPrU6j/KbH
	fSgtu5tg3I7XyojxTYU3eAsCfPHCEroSc5Jv3iCKjIGcVvM0muP/yqQE3KAwNh8C4DnQjt
	PCqsfqZdldzDohAIf1KznRX0z1WkKdY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGnZnNMNCIiU9GWu4BB4l5Z8uGC7kV9EeATLQ3n2YC0=;
	b=UOtxeonSnHFc0BI0S9sSH+6EHEmRnz73bokD6OjKBW3doBW/j0mgMfqbC1s8YAkiivQe4F
	DKqUQykpYQYXiuaN5pHUHm8uK/4YoQf7M4PU3UeHdwju95c58FPeqtgfa/JzAZAd9eqM1x
	55klJtOQN0Rl45gGm5sMj34xuCUjkR4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VlCxN4KA;
	spf=pass (imf15.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3acd523a802so13639361fa.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:17:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795223843; cv=none;
        d=google.com; s=arc-20260327;
        b=nIVrW/bNylvDyenGU2RMDW9gviIHp5X4MjzTpCOfXLEznxCXSqZNW4b+WH48LqtOdP
         gzZWTkwlmS1Wsbup6Vg4SMnimHw+GS6Nz0enSKk/zfbCcDwY7ZorDP3DehrVOBRB9fei
         xCySR1wjJSspNN+UpEVEpAEnRq0R1MXAEWU2OdKL7iO9tUlSz+KicGFSawZ0xPgslygK
         L8mAEV5RGqLGoqFr6YYLXiEV+d6+4+CuC1HUiEWzPoC/+p2ilTy5zxCFntADcj73Nn7v
         v6jxfgnnULxmDpR6heO2HzUYPd2PEChaXaNZOfj0Q+kYQU+71lcRkycgXEV1Kbmdxfyt
         XuEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mGnZnNMNCIiU9GWu4BB4l5Z8uGC7kV9EeATLQ3n2YC0=;
        fh=rIEE+SKzw4rM6J+wjxnNilxBKaO71fCwDB0dYwQzsMs=;
        b=e5V8cbsUydLPOgrk8CIrxw2mnkWjTZ6Tj81rID1nX0efmXMZyXPLcm8xyw58HMWNgk
         nuSkNG8BgvjjOFseA4gkloTM4hp/miTZiQVtRkudyanlZYuueLJP634ri9ljLQSMRmvc
         PMiQUsTmPJHJ2UNuFb61kcupqmIOvuUBgg6UsgT1XBJ+5Pl9b+b/HaK4VWerMyiOE6Ge
         jCR2D/3tk593cr8Q3U5aQ2+p/Etjd++JjfIwEzTuWGJ1ick5wm3FOKQtJ70jeGtMmJwj
         6Oa8xNEHOGafk7DidtD5Cj75chDS/Fyczj5mNWQXPBA8oTkwP6OdBz/Ylmg0bffcOavD
         gCRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795223843; x=1795828643; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mGnZnNMNCIiU9GWu4BB4l5Z8uGC7kV9EeATLQ3n2YC0=;
        b=VlCxN4KA9QnZMnYcXcLIG+R5Gm513CL/+KK3UUJjd97gaVO6VXVcfdCeAMQewOm2sD
         xvbwqRJ/eIMp/Xf/xo+OJiTdGkwi5LGtDGjJi5brWsKT/I6wvVFLKMxuVmxX3E6MWpoC
         1M53CJZ/jCNd4dQS5EdIkgy5KnmLJoqjScGos0MO8rzkj3zKTq5CJQZitplrJcs47VTN
         u1g2WJZJHhZc8wZXWOGDVzkmjLZTmWA7vpmb8odUOuN0LkHrVPXuZLmCYjBpqhO5i44p
         NQa58HhTCdl4+MC4JJwVoTv8KDgV/qL0gEo0RrfaRWu+qw7un9IJHHoFXHBMWznenECY
         tj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795223843; x=1795828643;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mGnZnNMNCIiU9GWu4BB4l5Z8uGC7kV9EeATLQ3n2YC0=;
        b=WnmWBSsqLM5yj1/VGuNWVXtKmx5Mmc7ze58B4Rh+XFr0fnvlv44/d0VkqGkicpR15P
         lbeqfPAzhJLtrZDpTvo8UO2LwEMIr21kPV6JBJ0lsvaiZ/m+RhaewxtXRHspBZ3PfaEJ
         qIfA/8MxK4pkZI0DGUmGA0voZcpn9b7BKrezLnu2QLFT/B6pz+EGPG+GtVMQxwrDtYog
         ngzwhRtzWw75IoAtciqA5zMh5iWawhTAFeao4ZGYhCh/grm+3WMCY04/nF2CQOmx6KBF
         d8xjAQwwzCMH3SrjXAq4l9+jSj74vGnc1Vv7LWSkvokarGqWU0r9r+zOLPu61Hk1zSuF
         h1Mw==
X-Forwarded-Encrypted: i=1; AL+hErF046rczRU8mD/uernxH4/kWcdQUOJAeJ4KAr4/PLv3JqYT+ME66zcoaK99ahHQVYLAqv8yBdmtEg==@kvack.org
X-Gm-Message-State: APuU4Z8EGSDm7mI+pnZcmO0rOn92oPpHs6T8tH6WWxa6MgUKz3K5mfl6
	ulzn9z42WbnZZrbJD51Ch5y52fbGeQ9Ns3RTYLM8jWcfxddne3ugT7Kv986Aupq3KeHvxiQYGoI
	Ybvdyq8QD0bViJ9s1Avv9vNdVCDcm340=
X-Gm-Gg: AZFdTZdiU4/icZ8+bN5zZ5Gc1fTal4CS+lAxa1NGODIJ7AKws/LEUBy8YMKJI8rjkbz
	fDwZzIaxb/lV7tqpEA/UsZMGmDk+ht9W8wlb9VEGpD9eeGp63rByvdX8OMUqNwAR7LfNxlbEk+t
	DskL8UAeNjLu9vrcCFxfioNAe2UhWXGQ0bEQtcyzruh2lxsu3zKEpTzlVYOOxSZ5DHTCbKOrMUh
	968uPxZH3Lt/ftGX2jnSNXS23rjKNI5Ko3J+fOcImW0abb8wIsKFXE+qQwUterveBjZ0mDpXcXI
	8d4ZFPmyGJsVWs2uL8KX0PNMZUK75BEZSmdmAbTUy1ZSja7MCs8M4zluaJuAIEvwQMHD+/K1I+N
	ocTVfIWKfCuAvm3AiU+ks/BLOKBku03zIu3vy
X-Received: by 2002:a05:6512:6c5:b0:5b8:f8f9:e080 with SMTP id
 2adb3069b0e04-5c1bc81a0f2mr1379733e87.26.1795223842532; Fri, 20 Nov 2026
 17:17:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-9-kanchanapsridhar2026@gmail.com> <CAKEwX=NtUEd7+Q2rW79LtObnjHT5uNFAUKfkRJJN1Wppe4Yc6g@mail.gmail.com>
In-Reply-To: <CAKEwX=NtUEd7+Q2rW79LtObnjHT5uNFAUKfkRJJN1Wppe4Yc6g@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 17:17:10 -0800
X-Gm-Features: Aa3M54qTioA-uvYuqL3pwqS8hRRk8H_IfZ4BDPWiMg2Jv1Vi1ZkTfN49GVC8gps
Message-ID: <CACpmpoe1SHgWQJaef-Je6x26FKYFAyV5xNs=krbWJQAYbG4rzA@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A402FA0005
X-Stat-Signature: 3dog4syrsq1qo5nu6ws5bjo8ciau7oji
X-Rspam-User:
X-HE-Tag: 1795223844-617331
X-HE-Meta: U2FsdGVkX1+xhL7jOv+iN+EMHKA636d9tLnLRQhQogUGjCL7hPnhLvagVjUEzmedcraSlbq9vmaJcBhoyoOQ4do4g8PUZz5KUQJtan+hRbDTmCUSSXdXKRaWqXZBgpF9J28L4U7nlI5Vk8swFemvVB+3lGxfRFQfAc14hAOEq4lzhbGalmIp4GDOUEkKpzvSdIbvIWpQsRWT7uqmA9yl2CTrrj7mQpnx/PTfUIR/j6pYYpnidkA4QJ+uIvrPK01+NBEpHroRNWj5vyd1L60O1lCBlb/OzLhm89HeusRX1kHGDBxDprqRYIsszohaOSr3zqR9mbgXqHwe2z2zdGDB2R9pzVNuDT7O2cy7ALj+SdWhGe2lYnAQY80AF0oAuqDisxX0BvlHOQ71xOLT4g2MMEJo9LgWZ5p2Mc20pcYKAbNjVEfk4yquF1AqzgRCI5SMb1A6NH/Vgp036wjr8G6SRztKQO0KrHOsYLHP/7TeveTjZiOql5ZgX+9gcQL/fbBELjd4qJgpPGj9DVMx01m2PAsuSaYLKKe1lgF5OFDsLGfx8S+fR3HI96dBeREcki0BkUiHgvJAMzR9hf7tKb+YaRqOUFys0eER4QqEP/NnbB1NwgoiSDtpKCUlC6AMAA/p236enF17HIfbXHyteRwn6MZHj437AL2HHlKzxSyxQaZBnPM9Y6bQntCD5UkHKZoeEOlnEvfKq8osU71YSw2xRhcEmb8qOw5JRmxxYT2950yVGXbkrb7rnd8k1G0Z+D620oV9o3uoKS1lB4uRy56cISNd89LxE49v3HON5yveMa9yK5TizSG9/PibQCMLLQ9+ja4bHmje5LARUSh01xRwLWUY55zlNeBdzX2N+P0s38Os7tHYpqsJ+qxKvt2/Lwv1y9rVRfwDbGYdZq+OgNxxO8FvS30lmvHk3b4OxysxpybQtJpOCR9ylA9c2KAb0en6Xc9Vio1vTaiZBATWEJO
 ygvnWTT2
 4aeBuucu26RDNrhis1V5Dk0EeOrpNFBXCnKDZwutrnI12Nitnmcmri/Ws4Q5GSn2nCEq2pK7qNeJChcz6jDJbXOaoXPbDrisVK5tAfxg8Av27RQOW0kT5HStJxa+EqmMKR+FRks+/gixG57M5avYs0ISIy93OJOp5n0ll+2IDbTZ3pkYLXIkmYOl5K58Q/H5K7laxoGuYxt1QF2EO/KdNA2OxpdPpf3a293+AInaHiyRHD8EmOSGz+hajdwZPKkF51Spb78ehhiknGqlz91hwFRzoAGPwq/Sx4HOolZ+25f00dXFrPIUTkbw2hrAJVvB86Exz8J42uAIRdQ2kkGy+BaPcQiNl0kIgmDEuYL3NklbaXJuCbu2l5xQ5PbaGiV36fusEez+GH3CI6RecrKUHrsrbmMlpSAgyIjcCZN434xuseXUhOXup36ErMhFvscdI2Hvah2ajKfXQ+2NcVH8NkxtAOIupO9lBBawagvARp6kTvEX5Z18PLGOOQm8PouTgrDA61cPRluj10ecBLC3XkwrTZgDYTMYoc97bkmZaFE7E56EhtOl9WPVd2ZQkmgIZUDEWlrcS9Q8hD736Ofv/D09YE1RGDaXwTGE9rbcQcJe3alM0Mi70LvnD/CjxZMseO++NlIdw/fxVBlGRI8ZYSsZe7eHMKKrBtypK3tuCaKnVei25puxxnqqLLZGuBf6qhDr0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 3:55=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > A new batching implementation of zswap_compress() is provided for
> > compressors that do and do not support batching. This eliminates code
> > duplication and facilitates code maintainability with the introduction
> > of compress batching.
> >
> > The vectorized implementation of calling the earlier zswap_compress()
> > sequentially, one page at a time in zswap_store_pages(), is replaced
> > with this new version of zswap_compress() that accepts multiple pages t=
o
> > compress as a batch.
> >
> > When the crypto_acomp is used to set up the per-CPU acomp_ctx
> > during CPU onlining, the compressor's batch_size is obtained by calling=
:
> >
> >   crypto_acomp_batch_size(acomp_ctx->acomp)
> >
> > This is bounded by ZSWAP_MAX_BATCH_SIZE to limit the memory
> > overhead and to reflect the store batch constraint of max # of pages in
> > a batch. The clamped batch_size is stored in the per-CPU
> > acomp_ctx->comp.compr_batch_size.
> >
> > As noted in previous commits in this series, ZSWAP_MAX_BATCH_SIZE
> > per-CPU compression buffers are available for sequential and batching
> > compression algorithms.
> >
> > Regardless of compression batching, we always process large folios in
> > batches of ZSWAP_MAX_BATCH_SIZE.
> >
> > If the compressor does not support batching, each page in the batch is
> > compressed sequentially. For batching compressors, up to
> > acomp_ctx->comp.compr_batch_size pages in the batch are compressed per
> > call to crypto_acomp_compress(). The first phase of zswap_compress()
> > thus only calls crypto_acomp_compress() until all pages in the batch
> > have been compressed. When this finishes, the compressed buffers and
> > compressed lengths for the batch are available in the
> > acomp_ctx->comp.sg_table->sgl scatterlists.
> >
> > A new zswap_update_entries() then iterates through the (up to)
> > ZSWAP_MAX_BATCH_SIZE SG lists in acomp_ctx->comp.sg_table->sgl,
> > allocates zsmalloc memory and copies all compressed buffers to
> > the compressed pool. All existing functionality on zswap
> > writeback_enabled (or not) fallbacks under various error conditions
> > denoted by the crypto_acomp_compress() return value [and with this
> > commit, also stored in the individual acomp_ctx->comp.sg_table->sgl
> > sg->lengths in the crypto_acomp_compress() fast path], is essentially
> > preserved.
> >
> > A significant zswap architectural change is that the batched
> > zswap_compress() incorporates Herbert's suggestion for SG lists to
> > represent the batch's inputs/outputs to interface with the crypto API
> > [1].
> >
> > The introduction of zswap_update_entries() presents an opportunity to
> > optimize the task of storing a batch of compressed buffers. Subsequent
> > patch series will be submitted to optimize this phase by replacing
> > zsmalloc with the SLUB allocator to improve zswap_store()/zswap_load()
> > latencies.
> >
> > The batching framework introduced in this series improves zswap_store()
> > latency by a lot.
> >
> > Performance testing: usemem30 with 100% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > Validation was done with mm-unstable as of 11-17-2026 (Baseline: commit
> > 866f761fd414) and with this patch series.
> >
> > v4 was validated on an Intel Xeon Sapphire Rapids bare-metal instance w=
ith
> > 48 cores.
> >
> >  Bare-metal instance specs:
> >  --------------------------
> >  - 48 physical cores
> >  - 190G RAM
> >  - 200G SWAP disk partition
> >
> >  Workload: 30 concurrent usemem processes, each allocates 10G:
> >  -------------------------------------------------------------
> >  The vm-scalability "usemem" test (unmodified version) was run in a
> >  cgroup with memory.high fixed at 150G. There is no swap limit set for =
the
> >  cgroup.
> >
> >  To quantify the performance benefit of zswap compress batching at scal=
e,
> >  30 usemem processes were run ("usemem30"), each allocating and writing=
 10G of
> >  memory, and sleeping for 10 sec before exiting.
> >
> >   usemem -w -O -b 5 -s 10 -n 30 10g
> >   echo 0 > /sys/module/zswap/parameters/shrinker_enabled
> >
> >  Performance validation methodology:
> >  -----------------------------------
> >  These settings were used to minimize variation:
> >
> >  - All cores were fixed to run at 2.4GHz with "performance" scaling gov=
ernor.
> >  - Turbo boost was disabled.
> >  - CPU power-saving C-states restricted with:
> >
> >      GRUB_CMDLINE_LINUX_DEFAULT=3D"intel_idle.max_cstate=3D1 processor.=
max_cstate=3D1"
> >
> >  The usemem30 experiments were run with the baseline mm-unstable as of
> >  11-17-2026 (commit 866f761fd414) and with this patch-series.
> >
> >  After booting into each kernel:
> >
> >   1) Constrain the cgroup's memory.high to 150G.
> >
> >   2) Run 2 warm-up iterations of usemem30. Don't use this data for benc=
hmarking
> >      since sys time typically skews higher for initial runs.
> >
> >   3) Next, run 10 benchmarking iterations of usemem30:
> >      - Log these high-level metrics: Sys time and individual usemem thr=
oughput.
> >
> >   4) Sys time and Throughput metrics were gathered for three mTHP setti=
ngs:
> >
> >      - 2048kB
> >      - 1024kB
> >      - 64kB
> >
> >   5) Benchmark summary data includes Sys time and Throughput components=
 from the
> >      10 iterations of usemem30:
> >
> >      - Total Samples
> >      - Mean Value
> >      - Std Deviation
> >      - CoV (Variance): Coefficient of variation (relative standard
> >        deviation) measures spread relative to the mean rather than
> >        statistical variance.
> >
> >  An LLM was used to help generate the benchmarking and data processing =
scripts.
> >
> > usemem30 Benchmarking Summary:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >
> >  ---------------------------------------------------
> >     Improvement with v4 zswap compress batching
> >  ---------------------------------------------------
> >   mTHP enabled:       2048kB     1024kB       64kB
> >  ---------------------------------------------------
> >       Sys time:      -13.87%     -2.64%     -1.72%
> >     Throughput:       +3.85%     +0.42%     +1.31%
> >  ---------------------------------------------------
> >
> > Detailed usemem30 benchmarking data:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  1) 2048kB mTHP:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  ------------------------------------------------------------------
> >  2048kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)        (sec)
> >  ------------------------------------------------------------------
> >  [Run 1/10]  Sys Time:    1581.414s    1356.252s
> >  [Run 2/10]  Sys Time:    1642.874s    1478.929s
> >  [Run 3/10]  Sys Time:    1594.458s    1411.252s
> >  [Run 4/10]  Sys Time:    1580.988s    1380.959s
> >  [Run 5/10]  Sys Time:    1579.654s    1380.609s
> >  [Run 6/10]  Sys Time:    1627.765s    1345.582s
> >  [Run 7/10]  Sys Time:    1593.872s    1334.485s
> >  [Run 8/10]  Sys Time:    1623.189s    1405.471s
> >  [Run 9/10]  Sys Time:    1661.954s    1433.365s
> >  [Run 10/10] Sys Time:    1602.098s    1329.813s
> >  ------------------------------------------------------------------
> >
> >  ------------------------------------------------------------------
> >  METRIC: System CPU Time (Sys Time) : 2048kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)            (sec)
> >  ------------------------------------------------------------------
> >  Total Samples    :              10               10
> >  Mean Value       :        1,608.83         1,385.67
> >  Std Deviation    :           28.67            47.47
> >  CoV (Variance)   :           1.78%            3.43%
> >  ------------------------------------------------------------------
> >  METRIC: Per-Process Throughput : 2048kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                              (KB/s)           (KB/s)
> >  ------------------------------------------------------------------
> >  Total Samples    :             300              300
> >  Mean Value       :         292,261          303,508
> >  Std Deviation    :          12,946           20,806
> >  CoV (Variance)   :           4.42%            6.86%
> >  ------------------------------------------------------------------
> >
> >  2) 1024kB mTHP:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  ------------------------------------------------------------------
> >  1024kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)        (sec)
> >  ------------------------------------------------------------------
> >  [Run 1/10]  Sys Time:    1567.639s    1594.696s
> >  [Run 2/10]  Sys Time:    1537.577s    1456.113s
> >  [Run 3/10]  Sys Time:    1538.562s    1521.887s
> >  [Run 4/10]  Sys Time:    1626.176s    1531.962s
> >  [Run 5/10]  Sys Time:    1593.955s    1528.733s
> >  [Run 6/10]  Sys Time:    1643.519s    1558.482s
> >  [Run 7/10]  Sys Time:    1510.613s    1480.177s
> >  [Run 8/10]  Sys Time:    1632.018s    1584.093s
> >  [Run 9/10]  Sys Time:    1569.424s    1528.915s
> >  [Run 10/10] Sys Time:    1552.747s    1570.451s
> >  ------------------------------------------------------------------
> >
> >  ------------------------------------------------------------------
> >  METRIC: System CPU Time (Sys Time) : 1024kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)            (sec)
> >  ------------------------------------------------------------------
> >  Total Samples    :             10                10
> >  Mean Value       :       1,577.22          1,535.55
> >  Std Deviation    :          45.13             43.79
> >  CoV (Variance)   :          2.86%             2.85%
> >  ------------------------------------------------------------------
> >  METRIC: Per-Process Throughput : 1024kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                              (KB/s)           (KB/s)
> >  ------------------------------------------------------------------
> >  Total Samples    :            300               300
> >  Mean Value       :        289,904           291,114
> >  Std Deviation    :         15,385            14,553
> >  CoV (Variance)   :          5.31%             5.00%
> >  ------------------------------------------------------------------
> >
> >  3) 64kB mTHP:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  ------------------------------------------------------------------
> >  64kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)        (sec)
> >  ------------------------------------------------------------------
> >  [Run 1/10]  Sys Time:    1914.525s    1878.483s
> >  [Run 2/10]  Sys Time:    1869.412s    1863.177s
> >  [Run 3/10]  Sys Time:    1944.049s    1863.502s
> >  [Run 4/10]  Sys Time:    1942.757s    1900.144s
> >  [Run 5/10]  Sys Time:    1866.505s    1887.285s
> >  [Run 6/10]  Sys Time:    1877.716s    1861.668s
> >  [Run 7/10]  Sys Time:    1861.741s    1868.788s
> >  [Run 8/10]  Sys Time:    1904.735s    1816.372s
> >  [Run 9/10]  Sys Time:    1891.074s    1850.435s
> >  [Run 10/10] Sys Time:    1893.366s    1849.747s
> >  ------------------------------------------------------------------
> >
> >  ------------------------------------------------------------------
> >  METRIC: System CPU Time (Sys Time) : 64kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                               (sec)            (sec)
> >  ------------------------------------------------------------------
> >  Total Samples    :              10               10
> >  Mean Value       :        1,896.59         1,863.96
> >  Std Deviation    :           29.86            22.96
> >  CoV (Variance)   :           1.57%            1.23%
> >  ------------------------------------------------------------------
> >  METRIC: Per-Process Throughput : 64kB mTHP
> >  ------------------------------------------------------------------
> >                Baseline mm-unstable   v4 zswap compress batching
> >                              (KB/s)           (KB/s)
> >  ------------------------------------------------------------------
> >  Total Samples    :            300               300
> >  Mean Value       :        239,114           242,254
> >  Std Deviation    :          9,090             6,419
> >  CoV (Variance)   :          3.80%             2.65%
> >  ------------------------------------------------------------------
>
> The numbers look nice, but what's the zswap setup here? What's the
> compressor? And how much of the win comes from this patch v.s the last
> patch?
>
> This patch series, and this patch in particular, seem like a lot of
> complexity. I'd like to understand better the win before adding all
> this complexity to the codebase.

Hi Nhat,

ZSTD is the zswap compressor. My apologies for forgetting to mention
this in the performance testing section.

All reclaim and zswap parameters are the defaults in the kernel build
(I also configure ZSTD as my default zswap compressor when I build the
kernel):

vm.swappiness =3D 60
/sys/module/zswap/parameters/max_pool_percent: 20
/sys/module/zswap/parameters/shrinker_enabled: N

/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled: [always]
inherit madvise never
/sys/kernel/mm/transparent_hugepage/enabled: [always] madvise never
/sys/kernel/mm/transparent_hugepage/defrag: always defer defer+madvise
[madvise] never

I just shared my analysis based on bpftrace data in response to your
cover letter comments, to try and explain the wins with zswap store
batching alone (patches 6-7) and then with zswap compress batching
(patch 8). Please do let me know if you have follow-up
questions/comments.

I will also gather and post usemem30 numbers before/after patch 8.

Thanks,
Kanchana

