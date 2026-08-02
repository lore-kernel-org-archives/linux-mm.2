Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD4C0C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 06:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D256B007B; Sun,  2 Aug 2026 02:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62DF16B0088; Sun,  2 Aug 2026 02:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543766B008A; Sun,  2 Aug 2026 02:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8A66B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 02:23:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9709AA0316
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 06:23:01 +0000 (UTC)
X-FDA: 85055336562.07.804CCB7
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id B364C180004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 06:22:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OulPRYny;
	spf=pass (imf24.hostedemail.com: domain of greatdanerrrr@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=greatdanerrrr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785651779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omCTIM7JwQ+xpF/19ksMUGGtqddvj62Yg4nt02jHUKQ=;
	b=Yh9OndtkpPaB1XBWu9DAZ+XbUqWrkPWAZpsKOsoTcMBYnHsSVPeffprZsmCIIZ2+Jcoe9K
	3sgzwHeXSBYYpSr1VwB4l0xP8GgRv8O0qxGquKDW7s4T1xZcMrtMT8+xepKo1QBmD4pYag
	a6B5ClFqkUHJa4YlvaGKnYF5JoaW27Y=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785651779;
	b=ANyYy3ADcCPp44hBaN5L6skQl2HNIHkEGEIxrAyt2DHXvQXa5ZYOB9IxBSq5MoPslxF0hC
	6cQ9/MsKwU0c5/1tLgyFvt3OxGv+JVNCvAin2ND0aKAX/+ZZ5MyGuUS+hpISlbKV2eCE9t
	2ei6/UhDyke+0rW8omsoTW5drz79eXg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OulPRYny;
	spf=pass (imf24.hostedemail.com: domain of greatdanerrrr@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=greatdanerrrr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c16794450aeso342738366b.2
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 23:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785651778; cv=none;
        d=google.com; s=arc-20260327;
        b=XfQTNbHITuzenVodl9I4B1K0+iGYOn+fWa/C0DaFTsr0oSTaGV0DRs8ULxBove4/q4
         u7gObNb0iBpdJFQqgJeHgMbTJSLYBOiD4i8ktJv1bRnIUjVb9MY/svEpqSvKZViPgxQg
         JEuntuHu2wKVkzl9X70E6pLJJZKm5Z/tzg35FkTWJY6yzyzO7meH4Te4xF9FpL4RAnhX
         b4kh1Rnh+x37t0BhqDz7Z0Af0PViir8YgwR7Fq8J4f/0iICLAqREZM3wHM7OeyINvMVR
         K6vQZaFjLd3fVOYgFM0k/KdCqpMAoGNTlJyiT2d4tE8I6RzFIeVXEkqZm7ESAw0YgeqZ
         MKOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=omCTIM7JwQ+xpF/19ksMUGGtqddvj62Yg4nt02jHUKQ=;
        fh=Qu5c5c0huqLqtNlE7+OAu1Y3pVxeFDyd8QDgi3juAfo=;
        b=njimIg3UnEpcuISltF+7E93Jt6QND4GVJholfjGWJ58TiyaQT5KInxAjqSBs0uQ+dm
         Mi4Mp5s6QI1Tgj6s4354cFgB87g2XcvR1cDBKw3drRmeE4YoDl/cqH1bXaYV2tyduHyB
         kdqw+ldaGmFpz9inHMfftepVaekiMv9QgIR/+Rp7PqZuzz7uF3pRiTsQ9oGCvkno/f9m
         Pz2+Ctzq3DCANYlPckqw8MWMi786S9gUNUf1uVcKAVmZ4f183yn2NVFp78Wf+qskncnq
         w5APVZlQ/t9MgWdMlnTlHbQLj+W+FkdOAQBVMh1gqx06s4/EhuX6Y22Ursv9iftQ2q/2
         7Eww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785651778; x=1786256578; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=omCTIM7JwQ+xpF/19ksMUGGtqddvj62Yg4nt02jHUKQ=;
        b=OulPRYnyBOqv0FplrHqILEZMsy8g4TDE6tSdEz2WXDqh8PbHNfeXfeS2909SCPlOgP
         eF7o9PPMoUDxJGcrbVMaMOmXKJj4Bc43qFC63WkrG0YxJpqMtnSMiBlA3hqK4N9Es/Xi
         TDwxWtQmeZqaDWKM02nRpO48ckwdL4I6DtHV7FwI/m0fOa7aRXvR3Oo+8QP2KIpthKcx
         dCSRL/Iof3YSYrwCqC0dieYY3Vnu/T9vkXmhR91BLeJVeGjiGizIyhHkrUOhDPnkcW1h
         wu/VjCWz2R6HOgmnIQvu7upXYOSfQ9kVd7v0/N/VQpotpe8MlWAu6WsrEfRe5QHR+RnU
         E72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785651778; x=1786256578;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=omCTIM7JwQ+xpF/19ksMUGGtqddvj62Yg4nt02jHUKQ=;
        b=Yff2NXic51rYxFAfbQC3oi7+YnEf/Er42NHCdMUN0QXrIeVthQ4Zp3OGguftU18gcq
         xTQ5qGbVT7BkxlM8GjqJkzitNQgy7zkgIX71kqKBv8Z2HVY3jmMF/zLz7ZqojlSqOP07
         d0ZhE7J/kw+BzqeNIQ/AFZmQg7L1sv/M9ApNN0V+aJgcl5yJ0rPx8s32EuxFU5HXqxkt
         siyzmx0PVCQTsmd8EMSbVKNZh/K8S/7zENpXjmcRcD3TDi6vHhRaG8jMFK8xiB7PPmXq
         wFSxr6f8NrJa6AyNJANycDqLUoRvO7SF1VOJ5/gVluT8HtpJQ4TTsKr5d/jPsau/jl9U
         L9hA==
X-Forwarded-Encrypted: i=1; AHgh+Roxd6NsedtKE1hqF0dXsDR/kNJO6dSGUYJ0M/lGMZGUP5GibWmc/AWcfP/2qBiyJMy/nNg1CP3RAA==@kvack.org
X-Gm-Message-State: AOJu0Yz2/LJyPA9HL9w4JWXl+nHRJPVfMxa6mVQfoTAT3fHlGjalXpXh
	6qqBHtEjw//BkJPf6o03I26NNUS/ILZblwjzYjTc3huYJp0WJpFSYHEWnKtP4VXpS33Q96aaWXA
	vHrq1oVf29m7PcQenxAdQjgWwPwYgAZU=
X-Gm-Gg: AR+sD10W5iSsuyC0zoj6RLYT6+pFdpXGz1bUUc8WeHm8ppzzn5ipgE3PzBiQvRvwebd
	3IDvmTCkRp01lPM+eeeEyhpDnN2uPPwJJeua2MXYM0NYdM+w7XNz3qZm+c3R64FwT4chUPU6qFN
	dsOq4jpTpQPB8syZ42yQ+5+j+t2YBXPSlKg2/KnnGi2D7Ospa5SCGUiC1CbGFd7tNF9KoN6oKru
	wEftG50qOFkNr5Td4+/yfXv/ULYM+RTpiH0gNyURYorKlMT2ZVAnmMBvadvarUvYJHrGJER30ib
	okWiUUOwTAW/EjV2Hll8O0uYj8ZzCg1M8H7sopwXIJuzHmbPxNHbafhHwOIvCKhQW94mOGtmiUK
	Y0eZ3Uf4uVOUTBn/xmEFo1+fp0ike11tOag==
X-Received: by 2002:a17:906:aed1:b0:c16:5f28:4575 with SMTP id
 a640c23a62f3a-c1fe816f6ccmr372902566b.31.1785651777970; Sat, 01 Aug 2026
 23:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAAzp_c6=Ka7q4pZtp_mWB2m_8MK9=z6OZgLiFoXJNTey0soGfw@mail.gmail.com>
 <CAAzp_c7vP1om1eHrwhXLZdqURo6vhu9S0J0b3HM8z7hFzmaRpQ@mail.gmail.com>
In-Reply-To: <CAAzp_c7vP1om1eHrwhXLZdqURo6vhu9S0J0b3HM8z7hFzmaRpQ@mail.gmail.com>
From: dane phillips <greatdanerrrr@gmail.com>
Date: Sat, 1 Aug 2026 23:22:46 -0700
X-Gm-Features: AUfX_mxM6Wb7qcetiLeINzpP6NZsY50K1cIPOOjcgKPFG_xSf0ijrNSb4Qvk8cI
Message-ID: <CAAzp_c4_4tVB68P_2EoXP4nLVa7npiHobmTHnjP-aCh0RRKHRA@mail.gmail.com>
Subject: Re: KMSAN: use-after-free in sw842_decompress (zswap writeback)
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B364C180004
X-Stat-Signature: 3eanrbjxqio7tbk9fr8bhnxisj6nfca3
X-Rspam-User: 
X-HE-Tag: 1785651779-172517
X-HE-Meta: U2FsdGVkX1+O3wVq0PWbphcEh11PGsd33D7s6YnRmafKlddFAlpFxyhek8dHz9/VAiFeC8hab3kgjDBAteRoCaJU670d/Fe9WqMH/7AoArtqMCoYs4a3gk9TG1KlBP1Zv49GI88bG7e4Yfz1P1SPFFy5XwVOBxKYTUVu4CLShjC645e5pY9ZsLGjHSCWHR4z6aip60BIobeLIb2ZN/+ej0R9zWp5qtNuJbPaQBPizhwcd9yC/hXxh6m/+xPvu6nFwQOue/b9oBXoJOQxnYBGPvP/tM9EDvWyjBr7YU9sFPNe800154+G5n1REyh6ynWPEV40HoTzpiO26afOdIuLwX62lj3TfT+KvIYtZ+qOCeKi+HnqeR7yDoelmEJryVY6XzcMeFvcILPy21bAEnPtYWsEms1MEmNBU2YtK0ySA+scb+PSmUKjFtH+Z6vqbwHF4kI7UrbXS9SlUF7fB4JHj7uchHdPqpxNKiUxCbT0Z00zek7L/9n+mPLWR6TOXP6Ov2Uj85VHDZ5sBF6xUmk6nTgZ/HH//Zv/VAb5/B6K0RUsF9oK2+/npF17frVt9QQFFxRrQr9o8JLaS0GmObb5RYEDksTZkjM3TBWZxhO+/X9ujUN3Ialbv7hP1345AQcU6cmXiJPnE1gjCnqMkD3j5wDmSUTWiDtMbfp5dnetH/WanQbyO7PYyZJojgyYa9meMwQozPfv9Z0/TE/Jy/5lUjGMOX2dNtWHvTtoDjKtDqGMTPNAEz1LR10hHL0Xv35+Xs8OUmVDR1a2YyIge2+UfxLjOze/S1KEeNqxyNySw1EK7jLgQdaa3L80TWO/1v8MrQ/91LxVbj9/DuIgt8MQnJUk5hprvjb4/VeI26Y3g2ctuUV9hqic7+qLDw+jNrzTOCNVEY7IWOhwc1CsigYNhz5kYOUmNJsyY5to9sUprTNl6BzhsUhw+F0qqCrb/OKGTrPn3UASVbc4V4bRI+r
 ngV8QqYq
 cV8tTBOhhOAONdsXgI8mKPO1iYK2IF1CcEA7b0tZ3hdo00r46hz7K/QLkJq7sVDXPUyQPrP332TjdrJoJc0fcW+tuyqZ4UjgmcbNpkVlfaN4CL/dFQD70o8VWMi8QyZW9XqaaoyhMKirtGrHumO7afkwS6vHtuYt8GQR5EetqsMy3cNOAWPRU0aQor0Vthc0AP4KxBMju481CccV9dCTnIAVEKnn+bisucz0uT+/OsguyUEBK+jM2W/2MnpY6ZlruN0uAqMFZCTKWijZ1lBNqjBAj1Sg4Y9XlFMSnQawAmBhi0Fx6w+Thkw/1iJzCFKV4z+97PmgMAbB3KbNXZlOnRvo1aZkBEB6jlBM7WnEYHjGS4+Emax8w7qNIahGLCCjGp68UpovFA9MhsSPq+lSEiEpsTsKD1gIlzHTmv/fhnj/y/Qagji5Qnbg4fpbYVFiSSWOGaDf3k7+arsM4aVUhzLljsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 Retracting both of my earlier mails in this thread. There is no bug
here,
 in zswap or in lib/842's input handling, and nobody should spend time
on it.

I could not reproduce the report; that trace should not have gone out
and
I'm sorry for the noise.

On Fri, Jul 31, 2026 at 8:50=E2=80=AFAM dane phillips <greatdanerrrr@gmail.=
com> wrote:
>
> I got the mechanism wrong in my first mail, correcting before anyone
> wastes time on it.
>
> I read the "Uninit was created at" chain as causal. It isn't. That
> chain just says where the page had been before the allocator handed
> it back out. exit_mmap has nothing to do with it and there's no race
> with process exit.
>
> The poison is in the compressed input, not in a swapped-out page:
>
>   next_bits+0xac2         lib/842/842_decompress.c:118
>   sw842_decompress+0x1a6  lib/842/842_decompress.c:297
>   sw842_decompress+0x11c8 lib/842/842_decompress.c:303
>
> 297 is the opcode fetch, 303 uses it.
>
> What I think is happening: zpool_obj_read_begin() copies exactly
> entry->length bytes into acomp_ctx->buffer, which is kmalloc'd and
> never zeroed, and sw842_decompress reads past entry->length into
> whatever was there before. next_bits() does full 8-byte loads while
> p->ilen >=3D 8, so entry->length not being a multiple of 8 looks like
> the trigger.
>
> So the subject should be something like "KMSAN: uninit-value in
> sw842_decompress, over-read of compressed input past entry->length"
> rather than use-after-free.
>
> Testing that now with kzalloc_node() for the buffer, plus a sweep of
> compressed lengths across residues mod 8. Also rerunning with lzo,
> zstd and deflate to see whether this is lib/842 or zswap's bounce
> buffer.
>
> Two things I should have mentioned the first time: the kernel was
> already tainted W from an unrelated get_xsave_addr warning earlier in
> that boot, and the tree was 503 commits past 7.2.0-rc4. I'll redo it
> clean on mainline.
>
> More once I have something.
>
> Dane
>
> On Thu, Jul 30, 2026 at 11:20=E2=80=AFAM dane phillips <greatdanerrrr@gma=
il.com> wrote:
> >
> > Hi,
> >
> > I am running syzkaller on commit 3dab139d4795 and it
> > reported the use-after-free below. The issue occurs when zswap
> > writeback decompresses a page that has already been freed by
> > process exit.
> >
> > Kernel version: 7.2.0-rc4-00503-g3dab139d4795
> > Config: CONFIG_KMSAN=3Dy, CONFIG_ZSWAP=3Dy, CONFIG_CRYPTO_842=3Dy
> >
> > The bug manifests in sw842_decompress accessing memory that was
> > freed in exit_mmap, while the shrinker is still walking the zswap
> > pool.
> >
> > BUG: KMSAN: use-after-free in sw842_decompress+0x11c8/0x1750
> > lib/842/842_decompress.c:303
> >  sw842_decompress+0x11c8/0x1750 lib/842/842_decompress.c:303
> >  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
> >  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress=
.h:-1
> >  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
> >  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
> >  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
> >  zswap_writeback_entry mm/zswap.c:1032 [inline]
> >  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
> >  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
> >  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
> >  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
> >  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
> >  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
> >  shrink_slab_memcg mm/shrinker.c:560 [inline]
> >  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
> >  shrink_one+0x560/0xc10 mm/vmscan.c:5026
> >  shrink_many mm/vmscan.c:5087 [inline]
> >  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
> >  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
> >  kswapd_shrink_node mm/vmscan.c:7008 [inline]
> >  balance_pgdat mm/vmscan.c:7186 [inline]
> >  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
> >  kthread+0x53f/0x600 kernel/kthread.c:436
> >  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >
> > Uninit was stored to memory at:
> >  sw842_decompress+0x11c1/0x1750 lib/842/842_decompress.c:303
> >  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
> >  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress=
.h:-1
> >  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
> >  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
> >  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
> >  zswap_writeback_entry mm/zswap.c:1032 [inline]
> >  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
> >  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
> >  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
> >  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
> >  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
> >  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
> >  shrink_slab_memcg mm/shrinker.c:560 [inline]
> >  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
> >  shrink_one+0x560/0xc10 mm/vmscan.c:5026
> >  shrink_many mm/vmscan.c:5087 [inline]
> >  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
> >  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
> >  kswapd_shrink_node mm/vmscan.c:7008 [inline]
> >  balance_pgdat mm/vmscan.c:7186 [inline]
> >  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
> >  kthread+0x53f/0x600 kernel/kthread.c:436
> >  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >
> > Uninit was stored to memory at:
> >  next_bits+0xac2/0xda0 lib/842/842_decompress.c:118
> >  sw842_decompress+0x1a6/0x1750 lib/842/842_decompress.c:297
> >  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
> >  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress=
.h:-1
> >  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
> >  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
> >  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
> >  zswap_writeback_entry mm/zswap.c:1032 [inline]
> >  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
> >  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
> >  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
> >  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
> >  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
> >  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
> >  shrink_slab_memcg mm/shrinker.c:560 [inline]
> >  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
> >  shrink_one+0x560/0xc10 mm/vmscan.c:5026
> >  shrink_many mm/vmscan.c:5087 [inline]
> >  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
> >  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
> >  kswapd_shrink_node mm/vmscan.c:7008 [inline]
> >  balance_pgdat mm/vmscan.c:7186 [inline]
> >  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
> >  kthread+0x53f/0x600 kernel/kthread.c:436
> >  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >
> > Uninit was created at:
> >  __free_pages_prepare mm/page_alloc.c:1327 [inline]
> >  free_unref_folios+0x280/0x2880 mm/page_alloc.c:3011
> >  folios_put_refs+0xb2e/0xba0 mm/swap.c:1057
> >  free_pages_and_swap_cache+0x804/0x840 mm/swap_state.c:589
> >  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
> >  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
> >  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
> >  tlb_flush_mmu+0x92b/0xe90 mm/mmu_gather.c:424
> >  zap_pte_range mm/memory.c:1973 [inline]
> >  zap_pmd_range mm/memory.c:2020 [inline]
> >  zap_pud_range mm/memory.c:2048 [inline]
> >  zap_p4d_range mm/memory.c:2069 [inline]
> >  __zap_vma_range+0x763f/0x9340 mm/memory.c:2109
> >  unmap_vmas+0x440/0x800 mm/memory.c:2178
> >  exit_mmap+0x27c/0xac0 mm/mmap.c:1300
> >  __mmput+0x134/0x650 kernel/fork.c:1187
> >  mmput+0x74/0x90 kernel/fork.c:1210
> >  exit_mm+0x2b1/0x4b0 kernel/exit.c:615
> >  do_exit+0x9a9/0x3c30 kernel/exit.c:997
> >  do_group_exit+0x258/0x390 kernel/exit.c:1152
> >  __do_sys_exit_group kernel/exit.c:1163 [inline]
> >  __se_sys_exit_group kernel/exit.c:1161 [inline]
> >  __x64_sys_exit_group+0x35/0x40 kernel/exit.c:1161
> >  x64_sys_call+0x3e6d/0x3ea0 arch/x86/include/generated/asm/syscalls_64.=
h:232
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0x15d/0x3c0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > CPU: 0 UID: 0 PID: 81 Comm: kswapd0 Tainted: G        W
> > 7.2.0-rc4-00503-g3dab139d4795 #9 PREEMPT(lazy)
> > Tainted: [W]=3DWARN
> > Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS
> > 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> >
> >
> > The full syzkaller log is available if needed.  I do not yet have a
> > reliable reproducer.
> >
> > Thanks,
> >
> > Dane Phillips

