Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA7A6CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06AF36B0088; Tue,  6 Oct 2026 05:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B736B008C; Tue,  6 Oct 2026 05:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D156B0095; Tue,  6 Oct 2026 05:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9DEB6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:35:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45A61120563
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:35:55 +0000 (UTC)
X-FDA: 85291694670.13.FA124E7
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4FA971C0006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:35:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dJSLEngv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791279353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Cgetbi5PuPxsF5bfepfN9t314B9UjLEVq/ZXofyuHQ=;
	b=WTWrZG3Z/UAUpm7GSN1rT9y3VbMb+7VUpHZBt/jbrVkf1uaIK0gYfmiefqV9WGfpoBfBOQ
	asWrG1WlbBJbOHrPgQVvpgy08ATa8829KOxJQUC8fpmC+e9I6wGh3zVH5n2w7wuDYKouFi
	81f7tzIWarbYMjk3RvCP3obc056RXuM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dJSLEngv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791279353;
	b=cG6HsteRahcDBkbbfaW7glakrNUqT6HHOPk7oz0BKh7ewHp12cVHOz3PuTnuJiF8nlbrWn
	xJV9fdSNPTqOnykdwRt9pjXxT72H8MEvmpVRVzSgXwWe6FqUxlY5hzGo6QruJBHGlRcdLD
	t8Bazt2HK0D5+n3Dulh5l3Wbt4/No2c=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-486e8faff03so229699f8f.1
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 02:35:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791279352; cv=none;
        d=google.com; s=arc-20260327;
        b=Izvsc9Oh/u1lrYWgHT1mpBYm+2Ud2uQVMZOYo14Uq7qbRmKc+LYZhjTD3zuMrAu/ff
         Y7DO6W21N6Of8jwCTjiGWSyG7nfxjNV567OT8MfvOfrRt5MIp09gmeT9ArlfTS4cxKyo
         cpjj/Rs8WqWiE8c4kyXcPqXZw2LxSURMVNzp5dMykfewUjKvhWSVSlOP7xa2YpF0U1Iv
         GeNbBYnB0j6mEx8G4yIVCytKNFmCxOuvld4RpaDBHU+uf1CbotyLY/WPJ/ZphWOa0ghA
         vVVQg7Mk6Xt2Mm28VtGFSFaQ7JCvCxKGp3yiXmnYbh3M4CqEfdGbHEqM0XvGJUNJ23sr
         qEDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+Cgetbi5PuPxsF5bfepfN9t314B9UjLEVq/ZXofyuHQ=;
        fh=a8RZjUwm8Ie+hccSl+RKrSuQVifnhXhrIik3ss/q0S0=;
        b=qUaObPEVC1PzpYaAOI7n4I/gQgdjOl1ZIxk0Ejdg0heVwQV7JOltT2D7Ezu2AU7WPi
         7kBwQ8j1s3+qGPiE3Pe55HIiXgg4xmSqW/sItmDcNWXL/6SmCUEqOyi7Nyx9eDvpmI8d
         aqhudnGjOTnIDsxyIVptm7vRfJzhaR4yGnLAjzUZ4UCCz/Frku4kUIXIfVmhftD78Xa6
         t2DcrRPbF+5tSFl7hvuXBFtx5LKiN5xIfUfaQD6LPPnQ+Vd1OCQ9Uoic7J8cNGcp0vpo
         Dwxp7isuevtgNV+bcu4ce0z06dYhBM493Mj2n3GmJ7wntka9hj7YPsZZ9OTpb9M9P7w1
         herA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279352; x=1791884152; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+Cgetbi5PuPxsF5bfepfN9t314B9UjLEVq/ZXofyuHQ=;
        b=dJSLEngvgV9i9YaA+6ue3F3ToB1zeeqWVHVQ6nKeVm9MgUWxqU0DEdqUXRyznlE8YM
         yHaa7SS56a1P0/4zmzGl/HItyoKsMkndobsa3gawePfI2vaNF2O4dwKX+6I+DDrwDmv3
         YI336+Do2ASgnAli4M5a2jX7dUGF/6OUv8hHs3D2Tw4I48MR1ygR3K7wxrQIjjrVj4Pi
         DPkpRYUFUiEN3a4CSuqghsq1/fLAvV2yM0WtmJQA1YEG+J8tHlQY6sCwONjf81DJDSXk
         nn5Y2bFMduwGCEG2MPBRKXZIoNEB/UlUmpfzOcG4sLe2vmQDvqz0SbhAKwoVeTZ4aBvO
         mC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279352; x=1791884152;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Cgetbi5PuPxsF5bfepfN9t314B9UjLEVq/ZXofyuHQ=;
        b=K/FslJTl2GHlTgiQDezMlRW5K30lP9deqHqj+Yr8m2i+I+MO1VMYGMn1ik3SYJ6D25
         HMsqcKDjiHCgcbwD/R1JBe9O8kzYc7syyMNmjAtJ3STAIS+fGnI88jbTz5fkxK/PZC+M
         9l1D1+mGNE8N++n+31bDYoiWpGWwy3XdK2rg5tD1zL11ovdqKE4sn4XeGq4RyGkqO4SG
         +D1zB89RoUN/YPVnRlkl/NYtopdQ3f25uNNgXTsQCGDpn9hBk6XyTpFCpF6XgmxgOflo
         bsBCl5ZF5gH8QTYGtNGONe74133mdFn7LpYsZqC0/SRN1SzQnzPQT2R+dwlVDI2ov4dY
         BEXw==
X-Forwarded-Encrypted: i=1; AKwUvBwbHeLdgTILFVlHo3WBH8zyRPfRiRjPmr8vxLqR/XMPKgKSA8mAdwskw6xZS6HmxEcpIoRDdZNcjQ==@kvack.org
X-Gm-Message-State: AFq9FYIYFuJ8Xw/ziBUpvc2jBSD11xnSpm0P/Py2gbdKAOG5s1HVB/p9
	LNXaMDXg9dv5k0QngxOGR3ri2aGIxSvCKbpnSNRGECDeT2xFWirrnEiFb+YUbuXpnT0rM+3tVSN
	NZp9r5Bf00wDGyXkqsOrAoW1vlVJ5n44=
X-Gm-Gg: AYBFou09bMcUoidulw/FkImuI17xOManAeqNDwVsA3RVAdf/FGy+WblD6ybrUZGpBem
	jnC9jAfVwk2xZu+57D5acteoeJ2Q21eiwOkz1Xcm0OrC+COazodIm+zsj+3L/8vDD2o4YQ3MplS
	8G8VYCC3MnGO8YiuWzSZMSnIYLa9QJxPGfdFRnCztD6eZNAnkxUnFQ9wJrPOG6aQsU8m8Xhg7B6
	il317nZUJs6Dw3aESKemJwqXggi5maP/77XWf1UIvNx9MXBI9hIseiSQck0JI+ouksDF5lCVBu7
	bCmbZUyyh4Pcxn4Ar2K3Rod43mn+8VzsyXtpnnQMofUysjxHQinMx1ZKbDNKENl7FqNk+A1XoCQ
	f/nfr0UYjZw==
X-Received: by 2002:adf:e006:0:10b0:487:81c:6de with SMTP id
 ffacd0b85a97d-48c6d1ed705mr1065716f8f.34.1791279351554; Tue, 06 Oct 2026
 02:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20261006002307.2669023-1-usama.arif@linux.dev>
In-Reply-To: <20261006002307.2669023-1-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 6 Oct 2026 11:35:40 +0200
X-Gm-Features: AclHuK-I-EC0QMEEhgjEh4SjGXEPR_qp-oBVhjIP65Qw2qNeTHjeK_O2GUMd75o
Message-ID: <CAKEwX=N3ks2O-dCYPRif3NnHQckdVqLiPGRn03GkCuEE+FVgtQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm: zswap: reduce request contention on loads
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	terrelln@fb.com, yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4FA971C0006
X-Rspam-User: 
X-Stat-Signature: f5eq56niwsy8p91s7rhutk8j59fsfbdw
X-HE-Tag: 1791279353-35377
X-HE-Meta: U2FsdGVkX1+yhBNLnbDk1qPzOY8p9GUqJ8Hl1cGXoMI05Q05usVpTFPTvexQDpVtc3vZ+SZn18tQc74X+6Y+WIgb2GQ076YGtmGJxN1DuEhdqXLvnrK1hlD8VZUssNKkCi+vQpeFdLHPpSVgfjVGRo2bA3VsjY79KLprNaQp1V/7BDXWdPZetFH9SBJVgz6rEw4AYjz8Fl+i80PSPqRHp7qNo0mhdSrLNcn+BBQB2/ZErgysMBOYnC+iq1bOzV6bVnczyiggSeDLeQYFZCifJ2wV9yIH7rcQI9uIJ+5cpocGJZJjuH0bfAIpiqh8bGz2hYq6iWuwAuAU08F2owNXUZKDxnvtgxz98UJuUpisxGjLGdQycp08RbhUDIUoVjSMzl8IUu9tfBunBZnPx1n2GKBH8/uXrYKIu+LGsv/rSVeZt2DgwJPahjn0wzaCzcDzi/87LqWB1rN1/s2I+ooowJ1wbsmP6x2CPcI/vvbLL0caGwO9tVS0pEUtVj8vzGPcM3hIwYjkwhcrW8l5/zP5xxPWkPSoxCjhBnu3rnDSpG01w7BSEEI79b0II6S/6HZfLICvdo1OWov3XGDAiB/nBv4tx6jV+Tjh0kQQbPumxAZuRyptkCS3r6zjJdbJwy0nYF/uXreNch5Vh/raE/dhoJq35FTWiTBk/mRpSCU0c3gn18WOzjQb1UGDOhu9nt7P+JPvMBsdUum8TOM4Kjmep1V93Qksn8HqPDWCuL6FOnUFEdH6yVOXbZFmlSYql+VoRJnv2nlGr6zLT77Mp4fW8ax0Y37PDs9IzbJVnOGSdwqNNoeB8Y1hvSnRY3crkFSAT4TDwTcZaYKkgZcavpT3l//iz3wk2oC92OtO4GhrNvv+7hht8ga0AA8KiF6NecWrCUpJ4a9UIKJ2JbunyIdXqRRqHCKfWnp/GL4aUnSL/DsY+ZgWmtWS3+cllSrBBTz+ROvHsP/wWnf4UjU3pKU
 gR6rPvVP
 r4w1VlrArnUQ1HO+EamtCVEbrIiVmVt5h1Li5lxbjJOKgLv3zBQPdOUi8/rZRrrF7Eq1CjpaV/eVTasxuk/eD4KY6gHexoqwrEZHGsTlYx+Hbj/fC7sN0HCunEEnjNGuBhZnOBnG0MHmpO1mI+JeA7b2yieZZqwOFY4ojt0vVW93o/KZcQ7iu+M1kEKNadPNQV9s+TBPkIs/Hehoifc8Zl2CRtPtLrTy1vTkk7Kcj1I76fU6OhzfUxKDWMM8OPcer+L1ODODmRV9lR7MjwsMBfUHS47wFosLjMgzSSO/smN7X7CZlMZ/QbWI6PdBXi38K0FuPaxWyxX5i/IyTRQQEMlV1K3m5Wy88E9a0Sy29ysXrPUQRjJA0YHFLOTEVVf4n3BZkWhm+1jP8GlC7RdvtAVzTYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 6, 2026 at 2:23=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> Stores and loads share a per-CPU acomp request and mutex. A low-priority
> store can be preempted right after the compressor drops its stream
> lock, while it still holds the zswap mutex, and a higher-priority load
> on that CPU then waits for the store to run again. This follows the work
> from Sergey Senozhatsky's zram series which splits it for the same
> reason [1].
>
> Patch 1 gives compression and decompression separate requests, waits
> and mutexes, so loads no longer wait for stores, though they can still
> wait for each other. Patch 2 decompresses with an on-stack request when
> the algorithm is synchronous and needs no request context, which covers
> all in-tree software compressors, so those loads take no zswap lock.
> Asynchronous algorithms keep the per-CPU request and mutex. For software
> compressors the series allocates the same number of requests as before;
> each per-CPU context grows by 72 bytes, and the load path is about 270
> bytes deeper on x86-64.
>
> The series does not fix two related cases:
> - Stores still serialize on the compression mutex, so a high-priority
>   task that reclaims (direct reclaim, MADV_PAGEOUT) can still wait for
>   a preempted store.

Any reasons why we cannot tackle this too? Or just one at a time?

> - On PREEMPT_RT the codec stream locks are preemptible, so a load can
>   still wait for a preempted store inside the codec.

Acked.

>
> The numbers below are the slowest read per run, as a median (min-max)
> of 5 runs. Each run is 12 seconds in a zstd VM with lazy preemption,
> vm.page-cluster=3D0 and swap on /dev/ram0. With 1 vCPU, four nice +10
> workers page memory out and read it back while a nice 0 task spins. A
> nice -19 reader pages out its own buffer and measures how long each
> read of it takes. With 8 vCPUs there are 16 workers, 8 spinning tasks
> and 8 readers.
>
>               Before series (ms)      With series (ms)
>   1 vCPU      22.3 (21.6-22.6)        0.97 (0.72-1.4)
>   8 vCPUs     314 (97-2542)           7.0 (5.0-98)
>
> Reads over 10 ms fell from 26-35 per run to none with 1 vCPU, and from
> 3-18 per run to at most one with 8 vCPUs. The benchmark and test programs
> were written with the help of an LLM.

Great find, Usama!

