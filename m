Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA0BC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78756B0088; Mon,  3 Aug 2026 15:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28C56B008A; Mon,  3 Aug 2026 15:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D175C6B0092; Mon,  3 Aug 2026 15:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0A996B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:34:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B8ADA07FB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:34:34 +0000 (UTC)
X-FDA: 85060960068.07.6AED71D
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1E7A540009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:34:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="l9/MpRQt";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of jannh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785785672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDIfmTxPvwkhihMCj9mYB45L1wPJrTw9byPix9Ugmuk=;
	b=flYPm7suilMXghMUYFkT6KOBDoLyE/SItvjBZ7A/44deqo9ivy5oWX3QBDlA0nAuFdBXwD
	77tb0bFXuqXC8h+xvmTsTN2KOnLfSP88tOjTZHsI0Nrz3M/jisZg8dgfiHs2j/5e/Vdzak
	yGYmcV317HbIaO/PZvAuJA0TCLJ+r+M=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="l9/MpRQt";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of jannh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785785672;
	b=onh3GM7+7Cl1IZI6rI6S/eMEqSFdJdhw1EYalCd0rlLRopPX8v7ktCfc0ZXnNH7vYpqsfi
	HpFHmAt09bAX8+3OXNKCTsksZXxEl0qdlmDGpInNsWEXOTzBbe+gHkeCZbp/45P6y2OaCv
	RNSckG7P7aiymNRxfnZDLe04p0aCMmo=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cab97c86bdso1085ad.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785785671; cv=none;
        d=google.com; s=arc-20260327;
        b=M5I52XN89FOFAeQPqq0OkWNDfGHgUo3cpQ917BFs8REZM4xC0XBZdRcQzE40+42poD
         mlvVyFsx6aAlhFoQCXHXDqZqAssriQACm6MZm0dH2Gdbz8bq3+fDz9Z4K22tnO/THZFQ
         7K2SXFpCVxVXyzSlfwd4m5F9Z2zCTZgxGQDzaOpKSveKliyO8Dsx53px5UyGddOv/d3o
         rd6oAFSWhDgsz8u+ff5t5dNdZZvsiOujpJtEsZTsHc2i08/QoLn8mKjV0GiG1xMCa/lq
         oyrdgARuhcmDcrUW+mrDX1AO1YZnIhzKuiUUh5DTCsM2itU8w31Js7jCEjoiwLw5LXXs
         HFTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kDIfmTxPvwkhihMCj9mYB45L1wPJrTw9byPix9Ugmuk=;
        fh=cmEsWEEHlqgZVRT4/MvH6Xi3nC1dCm90GSvVIm+rdVQ=;
        b=F8/HgUvb9ZVQy+JtHKNRNT7kQL9ns5b4sjTdUsCG5pCuPSd2um/kIZ4bdO1aXQUTAr
         vnz2mAHhdGxfASNQB+4Wscsdpmo/YZL5dD+jlQxJ5J/r1bSiH0sgTxre15qCl8NPSMzV
         /yY/bg57y0lAYReLN3Q6Huqa6vyVgfzHV4pdOLUXd/ynMepmcbx7ND3p3MwMp+P3MV/m
         JAOWQxRgsXvB/V7ZpJhBeOx3nXWg2wLivtckNa5UDuzo0oCw69amQQnfcGkoS0Py/SFr
         5XGtOtSh6T3cUsfaRW8YZxg7RuvSm2qJjQLYqcLYjR5CwIQIvYAlsmZGfrQxxQJaA2Vk
         5tRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785785671; x=1786390471; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kDIfmTxPvwkhihMCj9mYB45L1wPJrTw9byPix9Ugmuk=;
        b=l9/MpRQtRIzQ3RUQvNJ50V980SEk+wHXdZ+RvbYVP44zMeKXCu5TxhTntnpLH97KbB
         LfJZmgksWEb8KFrHoZe6pXs58RRgQsockYVGShdaQh/O/YeSV6Jp9EnvdymUbSmBZvNh
         RFL1GI+pNOcV9HsLcCJtCo7QR6hmcmJxhktOZtPtlunp/3a2CqIwFtYL6SEfL/pbZloq
         70knn9CSwVaCS5KoT9ElLYNFL5WWS8xAqc1Bow1hsJpDPfuZ+QRs8Cr+BU3L4BbDwGlC
         aOfxIkgHoKu7YVLKxAL3UNN2s+0EtBe4svuzODxeN2qOjxU1XmLTN/edOo1042jrTX8t
         FcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785785671; x=1786390471;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kDIfmTxPvwkhihMCj9mYB45L1wPJrTw9byPix9Ugmuk=;
        b=kVAoE0eSUlitr6tPFclXF8V0lpwcUJcMi03e4RJ3H3SgbbDhFMx9OPys9jg/OyuhgV
         aOb7yKmt4Z52NvKpaQabTnrcVFs+D5yfR//7IVpnfeDvvo38Fvx3Wnrpe4BnaXDupH6P
         /sjYNCNP886NBx7cevbqpoLM7WatcvDy8ozr8cmLUBAIRC6pr6ewbMyYAvkuAkPKLAV+
         kDXknO/dB/DiCyHlKgteeGzcUPsVl0ZHzeycKCR0XxBqCCL1BQlziSDrkGGEtupsXRAs
         tWL01NhZE1JO/fAE+yWLxVBXG8Nvp+zc0OpUIUPkK6s7GfPrV+KvqvMvowRnn8n57ppG
         QQ2g==
X-Forwarded-Encrypted: i=1; AHgh+RrwsoYBElCfavFQXrziCFEsxjCHNXBGFLIuyHLR57I9VBB//uG5tRRWs61wgMrd/qe18nIAiekh/w==@kvack.org
X-Gm-Message-State: AOJu0Yxk5lVTvdipt+NsLB7ZU0pkHiVPq1MUflpXRL8tH8g7R1xt5CVn
	dyTRnlIDV4mTgsc/xJdS8AEhus2MCi1J2T0FgvTcvgB6m3rU7MhX2HEV2L7EOu/qn9EQnEQzc+W
	6hdwIUINFr6ViMwOFogkWZLQCkSjOfgNb/aFK0ytc
X-Gm-Gg: AR+sD12fdr1LLNaRhk/RBMQvGPhLhnkw/k3PIyAtqjgLJUnrZnG6FOBsYpA2rQ3RbJB
	hq0jHk946wTlBwSgPRJYemQb71is3SVDsKbQwk48m4dXuXTRqeclInVp8oI6PFBUFXWV3UMk6Ju
	ImnLHNiwfcR6EW0s506/+uod1aEzDOaG4OrKgT+uv62+vPCHYKrjxGB/LhlNxfx7XxHw7p7CLWP
	mRuq4qSqRK6K4vMi0CGWCo0CWSqWcfOjO6Tke4erSn/vw6FBKLbw6dwIesSnCvQMfiXir1WxT7v
	GceuiWTjB0iDndKVUK/DpG4vLOgH86n867d58xEEYyRakLnJm7J7sAczOpf2wN0ok31DMo7zDeM
	upnhfXb3LK1OhpRL/kKh2RlQQx9b9BFHKrSjWY1Mf0SA=
X-Received: by 2002:a17:902:f80a:b0:2d0:8b22:22ea with SMTP id
 d9443c01a7336-2d08dae97abmr1315915ad.19.1785785670348; Mon, 03 Aug 2026
 12:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-2-surenb@google.com>
In-Reply-To: <20260802215459.2769283-2-surenb@google.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 3 Aug 2026 21:33:53 +0200
X-Gm-Features: AUfX_mxv_noTyqo8QCRPWsUmWKn0d3REtIV89ykTA0nxB-q-Uskzd_b5sOgBh6U
Message-ID: <CAG48ez1w6oPobKZPzoRRN+Nf66PrVYRJwKQx=qwTLTR3n0EFRw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E7A540009
X-Rspamd-Server: rspam01
X-Stat-Signature: jegtyawowbpsyfef1exfg8panfetzrck
X-HE-Tag: 1785785671-486777
X-HE-Meta: U2FsdGVkX18WPa11nr/Mk4Tqhi37IcCXdR1k85EeaMx6tGS7TGUWPPc4g94Oj2eg15jD6DCFH3D4tfyL6OzyQL6TfItDIJSvZUj2d2GrlEq1HNBWp2QP3maMXxbRBZlnLRLjDajhXUtfeHB3s4KwqqVrwGlfIszRCleHXn2mBKKHhtL86b9WH7JPJ4b+YVn/Y93qjkgFyEqXcFFX4dAbMONWpPFZAGPpwi82jKM6EPppX0hSbmNGOqXntgVaxHsSqlRe7/PyLqv6z+DaMCrdrq1tIhDnSgg9YxZPak4UajGdknxwXHVOwHHCYr0hFk//LgISqF73iOQoKwRGpiubUM2BRehPqOl9qJOJtAAXj5kxZSvzv+wH0kA5Ynkv/tpbmQGtdYAMrlZFztyPHxVUXTPS/fc1YeLpwZbEmjtYz1057v2C6RxcICHeiCgeQkP3rfPOwCUCz6IKleMvYq7esFoFa+8IPLc9iro81LgklmQ6Yo9/Wd2U/FtzJOMuW9eekhtf+SeUyspbZwC1a1aOL8C0NM81rTiKYFzr/VioiOou2gyI5A/naMqA9vvnYjx45nMXURGdERv0n+JzgVi3GcrLOnqAcavyNFM8USnbsfkmLi/H5aeVFfLKNOai3HDDGgVaPyaVEznitHp1SU+qvruI5eztE7uZpp+hpjv1bX0E/sRQMp7esMRsdLzVNCHKTKL1bNSjMupx4iPfwVih5mGydh27MAZBGKOiVrq0CQ+0jS2ZpFwD0A4YyEqPTmf32VK+JCFO7ci3PG1gOlVhMSe9VOy3PQ5SM5+f12KdfyT9BxYnSf0FSWLJiB575ZZ7Rk8kFiED2/WPgWg0Eaib0mnTs3XxONk3nXGCo0mHxUX+Yw0BMoH33416dH7xzbBrOZ6io6BCuozgAl4Wisq4dl/drUr25gVPvXD8p3ZZDeHJeAKWgyPHOWnri/WoVAIMYy2q8gmL4WvjgsnX1Wx
 36oT/KeZ
 m8kA5nIQHeYIn55ntyTS6oEvARV1f7ipow0ElAQ4cEGL3cyf3TxlQTTBnsbxkJEYaKrVSooCfGoEeAnXlYrBtrZEs5LDJerf+yCWYYEPQPOcr9Q7G4+DmTPL3NQiEW+98XepvsMjxWwUyuPj8tZXt1Jun24Q0wjFTt+gRwDHUqwwR639qHl2N4uPdcAqlYEIX8JXjVabzF+g6ChD/mHftxiJA9+JYbvl0Y27dmcRBFF+2WazeztXOZANn6X5H02Ucj683enteQAO2UxFLt+gchVnuvXF+SFebwehvb5E0VCiy164Fpma1HxzJrou56mmzdzGaWy2bJ2s2uOVm9WaiBGxxsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 2, 2026 at 11:55=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.

Reviewed-by: Jann Horn <jannh@google.com>

I've grepped around in arch-specific code in the architectures that
weren't already opted in to look for stuff that takes the mmap lock in
write mode and manually mutates VMAs, and couldn't find anything, so I
think this is correct.

