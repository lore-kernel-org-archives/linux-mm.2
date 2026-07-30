Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9709C5516E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A456B0098; Thu, 30 Jul 2026 14:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B236B0099; Thu, 30 Jul 2026 14:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615066B009B; Thu, 30 Jul 2026 14:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2831B6B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:21:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AAAB5C0243
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:21:08 +0000 (UTC)
X-FDA: 85046259816.26.356D614
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id D25D5100006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:21:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JwIzkS7U;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of greatdanerrrr@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=greatdanerrrr@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785435666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OYKbwERx20dbeiIyUIlnTCgasqUg2SfAVLY7xvX8KUM=;
	b=ZajRZO+sguqY6dgOKJ3SF9iTehxs+QWZM2hkSiR+k5poEs3BQvRoMTVAVs/QuhXOIAPoZq
	DF21ezrt7iJ5o4zBuUCeUqsYSZDITykCMO3x3RZOFmj+U4XhT4QtFoE38XcmUc1XSjWd2V
	TYzC5jv6xKo7jcmh29vXbNjPbXOhTTc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JwIzkS7U;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of greatdanerrrr@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=greatdanerrrr@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785435666;
	b=i47+PH2EP926Guj93Kxu8C+OmFyM/WcKBH9ySjxH2kflPS77pjbm4+6+xUHJ/smFvReWrT
	9zMYSAW/N1JtSHCDqUxiipL0x6gR4ttiPtHAPqYoaMpjy8uHAQCD72zIhJ/zsL2M2MKlv8
	clgC2otbkuZIsuEweMu5C2n28b5GquQ=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-697bd21fdc2so247898a12.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:21:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435665; cv=none;
        d=google.com; s=arc-20260327;
        b=YK2tq28qKLc0wzdTCgso5c2btm9e1w+HEcj6QG7CWCaIW4uxgpFmSiuxFCgbE93Ocf
         2uhoZUcaAuJETCcwjafYASehKbLJ6IY+tdhWNqFVVM/T3naLmv8PdPVO7T4iXtYcCjGz
         OOOMuORi7a71OoUmXYphtU/ycxb8FrwBQNwGl3wk04Tf6crWQV88VVif/XHexXEuoxFz
         nubgld4TvHrTo58tQp4UnNMfqHAhdEbUeHSYNDt3sVhHS2GV/R115JN7tONCjHOcPWEq
         jrcngSsF69X8h6aR/H4UPhQyYfac6bfVB3HYOp+p+jQ4vVfRqx6jnrZLwFdMZ2YeouLP
         K4/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=OYKbwERx20dbeiIyUIlnTCgasqUg2SfAVLY7xvX8KUM=;
        fh=2DwymKcedapKDuxnu6/5mci0/Hqp1HDy4JWZA6sOW+8=;
        b=ay+2O6rxq+NzYJ76y5VSWxR/rkyGehvYEiL7leSlTA0retuAGBHRs0jYp5YFIPfZth
         6UzPeZO29FMOhn6p+ArUVEDabdzcjPhUe9Hh2CuAw8PlxFmoxG2GZL5ttZihBf+TpH4h
         W1paLYUqqQs1Wv3d8X2m0HxtTRzkT1TQ0q1nDiitskE6QesdSThu44/fEW9TgMEn5SYW
         mOitFALSfYN+F65vNCNk59uA46CHY0A0TvbTFu30olLs/B0sQ27oE5W27CGnEG6ItQ0r
         PVKsgMOO4RLujUusbmJFHTjfMeb/h0YciAtTYQmoAVDtlrtHmsUnMFIYE5h2Ph9vBU//
         iaAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785435665; x=1786040465; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OYKbwERx20dbeiIyUIlnTCgasqUg2SfAVLY7xvX8KUM=;
        b=JwIzkS7UDhAXuGnIMXib9Q96/2s3y1Wrowka8fZFxwfeBmTrrNSUfodxuWY2KBkr1E
         6gClL2HtsYEu3F/wtqwdfuwBrKA/LjE5HzWSoT0hXJK6VKOgZX6YkJz1k2gDyvGJ3tWd
         Z67yZrq9fBD+M+rgrB1m9nJTHel6673oiAkbXcRcqJcxGsJrUUvHalmJ1FXllZE5q4Dw
         1esi53zlq0+gk3ItW4ZWz9hFehQJ/Rd9ZpUDkeV3WN8eS0CbdVw0uZMT/quWc0NLh/wD
         BHimurQ6yRV/+udk7mJad40iZIcPBezA28/hYRfsjGpsgYuum/K2yyL4M7XZBJXUQyDh
         hkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435665; x=1786040465;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OYKbwERx20dbeiIyUIlnTCgasqUg2SfAVLY7xvX8KUM=;
        b=qWbat8C1gh9McPMVH7DVDG5DCOcwLEUQrl5bjIfO/kK0kmgARHlkQIl1DbRBKzZdPf
         JXdcd5Z05ivy1+69foty/CutUIh8AJDggSKrPUm7wk68/7VlHfU6322NOUEvD/9ad702
         b555VpA2DfqbE3WZp04mRB1W2UY8HmJFmUQzrjnRkn4biCFpPohCLrwwu+5GGXEdKEum
         bgBMlVgFG9KNeKSaAXsy+8vdujGi6iP2aMOMgamdS4oGo+4az2DuGgIwvNl0EFXrbsGb
         Db/Uiefgx0wTKYpatYSjal9E4sj2EJ34FMbXF5bZD8vDH0F0matQl83jZmoDSuMfQ0Eo
         FB+A==
X-Forwarded-Encrypted: i=1; AHgh+RplUU33ZSsAmas2mNBT496qRqLiB10AUKLmdHrxqXJhwKiRm9dLfkVjq8iip/+gbABYrVCmCFk/Hw==@kvack.org
X-Gm-Message-State: AOJu0YyUWlGKvl9aQajlStrYBdiscNIjt3GWSCpPlJa+SCDkfyqdCYjn
	7QwUSFEN4d9YAnyKnu7mdl2b7Z27uabW4JAy/xuzP4h7KNJFrP3/41v+bXgf3vFhezqaT00hOB0
	kObhsQIy6VS+6hDZPYm0dihdybS2coBk=
X-Gm-Gg: AR+sD11duDu5nHGH0LDviRp/3xrQhowZjNgxHYWH09aTHiLCgTdMA/moxJIDSON221Q
	pObSikURq7BSbAjn7HykeEz4f3TAt8nlkEi/tZw6niFUJBohc+mvOL2MwEweCRlpK9FD/HfMOIz
	a7h/V08U7SXjPCkeEx3Uu/puD9xJ3TU1OYlS9ziecaqSPbV/NpAHbJey9QAp12kHapHPXY7UKwb
	KyLq8GolPgv2INWQNf9ufJ6u/dFfsJY1JyLFSg82hpy9oHfRpW6Jk/tyGG8zc/C03krIcuK0TBs
	oDp7EooSu5wFe+1kD7hyIzrliu2fxFOW60mNEJZuQxXnaWDELrsNiQP1YKFU1lSpEiUEfVEPAwC
	beESpn7q5zii/MiSaKkriLRtkCmuPIiw2Jl7yBQ8h3rth
X-Received: by 2002:a05:6402:4314:b0:69e:98a8:4f05 with SMTP id
 4fb4d7f45d1cf-6a07b843800mr1910619a12.34.1785435665064; Thu, 30 Jul 2026
 11:21:05 -0700 (PDT)
MIME-Version: 1.0
From: dane phillips <greatdanerrrr@gmail.com>
Date: Thu, 30 Jul 2026 11:20:53 -0700
X-Gm-Features: AUfX_mxjp7OusIdtZwC51kJm4H-r48e75MMq_eLAX4lRvFFoqtXoaP0UKEaCq6g
Message-ID: <CAAzp_c6=Ka7q4pZtp_mWB2m_8MK9=z6OZgLiFoXJNTey0soGfw@mail.gmail.com>
Subject: KMSAN: use-after-free in sw842_decompress (zswap writeback)
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D25D5100006
X-Rspam-User: 
X-Stat-Signature: mmay961gnpg9wj67dysqmj9utoyg7zgp
X-HE-Tag: 1785435666-636894
X-HE-Meta: U2FsdGVkX1+vMSYV00GSd84FEmiIKh72pVpd4DhDCKWraed6d7BAG4YY4AZsyjeB4CGOAWKwrxeJbUTCIM7LHeTTpbZflAdG1a7bMq/y37HIQynUfgoHcXRusoEWTQ0o91543Tuef0LFduqncjIsIvMpbaQIsRz6S5310ZvS5OxaUeY33PTKvJ2IXFMQSJ9JXYOvUF+/ot1NE0wfc6aMspFgli6Mwm+CZd1rktw07sJLjafU2coL+BRIAZQj0Lj3ynVTvmndB9lblGy3hLG2pfbRAfgKwmF8H1du7tqNYUJyu58G4ipvLDIy+xoX/VrzCpeTUUAtR05cexVHeQmpapJIi/qck6npNEmNrBq8hHxr/AinFnbUoa1mDDGJVZmCLHhaUJqWEYUHIXZh9LEvT9UgIore3cza9j32NUhqnTHS7McglqIQ1yyAi3SJk2t5BwzsfH1isIX1hz1dB38gYFRpiEwVa1Et23NPiWDVKjnCGXkWuDAvWowvJLRopYq0NJe56VOOWktqEZVxPIgk5A9eMLpDOJ4mdurrjsbmbwmpZWrxHsur/9yj0keLrX8SdaDAc4iQ8F6MNP5gY0dbBZNWlRh+7ikiZGdxjfcZOGqHGFbtj9PXCUmOSKbu4E8nxHtga+G2YNbyfowxeC40v7JBbUaQxl96SNbcZMEcGqVDhtJR52EIi0C2D4v7VJCAhwFI0nx2mfcJ7rWt/iQan6c59rEy3CVvWJK5S1hJiR846fXJ+gzdnczgBdq2gqP7YquWhwJdiR2dVxQyiAyqPJuOZb3mGqh93ihqc4BFiyR/rcVZBud7Q+kjHVoGMRqfDO/CgzNwoopbqNFlsBklGxcHG5ZhiZcvIpz8Gob7UlnSNuXl1BgNAgk8k8ONZ+OO/8bYegujbynwNLqeols9cMLBb2eb4vUGqWO6AiLALift2udmT+ut7hF7Q2RLB5ALT9OG2fABWfj6JNQOANV
 lioJ4AhV
 WIpVFuXXmwCZ1s1mTIxdp0yV6NOq7LhQ3nYlX7YK4AFX5Danby7VhiMFgrHcGk64VMy/piyjKAVnN1OCh/YGCUKdsev2gguNnAV9zIQd09vK2TOujhYmFfsTodxv7YVOqXSXs2BCn6eZ3mMlxOmRc6yRkaJqYOHn3EIDQPsRBn0WhnnwmUVCnj1Z0APwdx4Yk220E/M7CjhcW7avg/xfWeQcvBaC6z5L18qD0FTni95LsirmXX7AHAeZBwoKRTRuJYCUy6pTrYU5VZIFcj48hjC+Xw896iCmoSFcT5FcT8g0Yi8yN9WlWrmhJMrMV1n391Aww/E9SBXql2p+kBVdh8balf89RoJ7ihNAyTPYxk/qjtsv7hY8V6hd3PrtDCcyLoZr2e22+6L2XjkdrBAR9/jaYE3lBrF+DbrFeZsvqf/KRCQtN9LAXLyy/jZOjEAG6713e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I am running syzkaller on commit 3dab139d4795 and it
reported the use-after-free below. The issue occurs when zswap
writeback decompresses a page that has already been freed by
process exit.

Kernel version: 7.2.0-rc4-00503-g3dab139d4795
Config: CONFIG_KMSAN=y, CONFIG_ZSWAP=y, CONFIG_CRYPTO_842=y

The bug manifests in sw842_decompress accessing memory that was
freed in exit_mmap, while the shrinker is still walking the zswap
pool.

BUG: KMSAN: use-after-free in sw842_decompress+0x11c8/0x1750
lib/842/842_decompress.c:303
 sw842_decompress+0x11c8/0x1750 lib/842/842_decompress.c:303
 crypto842_sdecompress+0x46/0x60 crypto/842.c:53
 scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h:-1
 scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
 crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
 zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
 zswap_writeback_entry mm/zswap.c:1032 [inline]
 shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
 __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
 list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
 list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
 zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
 do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
 shrink_slab_memcg mm/shrinker.c:560 [inline]
 shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
 shrink_one+0x560/0xc10 mm/vmscan.c:5026
 shrink_many mm/vmscan.c:5087 [inline]
 lru_gen_shrink_node mm/vmscan.c:5165 [inline]
 shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
 kswapd_shrink_node mm/vmscan.c:7008 [inline]
 balance_pgdat mm/vmscan.c:7186 [inline]
 kswapd+0x3029/0x5a50 mm/vmscan.c:7462
 kthread+0x53f/0x600 kernel/kthread.c:436
 ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 sw842_decompress+0x11c1/0x1750 lib/842/842_decompress.c:303
 crypto842_sdecompress+0x46/0x60 crypto/842.c:53
 scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h:-1
 scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
 crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
 zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
 zswap_writeback_entry mm/zswap.c:1032 [inline]
 shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
 __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
 list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
 list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
 zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
 do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
 shrink_slab_memcg mm/shrinker.c:560 [inline]
 shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
 shrink_one+0x560/0xc10 mm/vmscan.c:5026
 shrink_many mm/vmscan.c:5087 [inline]
 lru_gen_shrink_node mm/vmscan.c:5165 [inline]
 shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
 kswapd_shrink_node mm/vmscan.c:7008 [inline]
 balance_pgdat mm/vmscan.c:7186 [inline]
 kswapd+0x3029/0x5a50 mm/vmscan.c:7462
 kthread+0x53f/0x600 kernel/kthread.c:436
 ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 next_bits+0xac2/0xda0 lib/842/842_decompress.c:118
 sw842_decompress+0x1a6/0x1750 lib/842/842_decompress.c:297
 crypto842_sdecompress+0x46/0x60 crypto/842.c:53
 scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h:-1
 scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
 crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
 zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
 zswap_writeback_entry mm/zswap.c:1032 [inline]
 shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
 __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
 list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
 list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
 zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
 do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
 shrink_slab_memcg mm/shrinker.c:560 [inline]
 shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
 shrink_one+0x560/0xc10 mm/vmscan.c:5026
 shrink_many mm/vmscan.c:5087 [inline]
 lru_gen_shrink_node mm/vmscan.c:5165 [inline]
 shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
 kswapd_shrink_node mm/vmscan.c:7008 [inline]
 balance_pgdat mm/vmscan.c:7186 [inline]
 kswapd+0x3029/0x5a50 mm/vmscan.c:7462
 kthread+0x53f/0x600 kernel/kthread.c:436
 ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was created at:
 __free_pages_prepare mm/page_alloc.c:1327 [inline]
 free_unref_folios+0x280/0x2880 mm/page_alloc.c:3011
 folios_put_refs+0xb2e/0xba0 mm/swap.c:1057
 free_pages_and_swap_cache+0x804/0x840 mm/swap_state.c:589
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x92b/0xe90 mm/mmu_gather.c:424
 zap_pte_range mm/memory.c:1973 [inline]
 zap_pmd_range mm/memory.c:2020 [inline]
 zap_pud_range mm/memory.c:2048 [inline]
 zap_p4d_range mm/memory.c:2069 [inline]
 __zap_vma_range+0x763f/0x9340 mm/memory.c:2109
 unmap_vmas+0x440/0x800 mm/memory.c:2178
 exit_mmap+0x27c/0xac0 mm/mmap.c:1300
 __mmput+0x134/0x650 kernel/fork.c:1187
 mmput+0x74/0x90 kernel/fork.c:1210
 exit_mm+0x2b1/0x4b0 kernel/exit.c:615
 do_exit+0x9a9/0x3c30 kernel/exit.c:997
 do_group_exit+0x258/0x390 kernel/exit.c:1152
 __do_sys_exit_group kernel/exit.c:1163 [inline]
 __se_sys_exit_group kernel/exit.c:1161 [inline]
 __x64_sys_exit_group+0x35/0x40 kernel/exit.c:1161
 x64_sys_call+0x3e6d/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15d/0x3c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 81 Comm: kswapd0 Tainted: G        W
7.2.0-rc4-00503-g3dab139d4795 #9 PREEMPT(lazy)
Tainted: [W]=WARN
Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS
1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
=====================================================



The full syzkaller log is available if needed.  I do not yet have a
reliable reproducer.

Thanks,

Dane Phillips

