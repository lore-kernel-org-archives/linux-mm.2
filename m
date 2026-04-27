Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C39FF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C826B0092; Mon, 27 Apr 2026 17:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44686B0095; Mon, 27 Apr 2026 17:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33516B0096; Mon, 27 Apr 2026 17:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C46366B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:58:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47E2A1602AA
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:58:34 +0000 (UTC)
X-FDA: 84705700548.14.9F2DAF3
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20603C000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:58:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=CNutsi5l;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777327112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eodThUBj1SnOvacXe/3ftYxEWQMFbYqc4B0FCa9Alx4=;
	b=oz5J9cslqEtGEE8/7/klLxoIgcuZTQy5ZwYQ+wr+JUYNhR+A+yPXTsJwrH6WveDjWRHFjb
	buhlnJHn/9rii0/CCGBQ9LOpwuXBlPuHIsVsxvevxT1BRNmXHFU0amFh/NpbA9pvdeKTB3
	t4j9CMsgFsT74nvzJCqkQVbidpH4GJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777327112; a=rsa-sha256;
	cv=none;
	b=7Uyvm/IZXGBmyBmXMSO+FlL3FRwIHKGwt4dLrbFYrez9uDc5+9iffs62BN0pd99RMzsN51
	776RBzzpKzdu3+BQHNjp0Eb2r5YZtW0m7KXnxzImwhxofL/OgtIqDPmu1O0ibG2FvyyKVq
	BZXgXuiAAZYmhNDoZlpcv3Ka/1WfsZc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=CNutsi5l;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9c3a9fe80fso1581939566b.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777327110; x=1777931910; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eodThUBj1SnOvacXe/3ftYxEWQMFbYqc4B0FCa9Alx4=;
        b=CNutsi5leJyRH4ts2ijT/2A6mj8jeOQsK7MHkkqKN295MMCTBlTP3dAdv5GPSXo3Af
         ss34aFSMWM87FAu8DCe5LbLiGKF2VaTolIPzNfthzUAX1RLicX1KjxY/WlwYDn5tAOaB
         5Hqfgu1UekanBc8c+FsTB7Je0VoXaT7hAfpgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777327110; x=1777931910;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eodThUBj1SnOvacXe/3ftYxEWQMFbYqc4B0FCa9Alx4=;
        b=VxAAEfo9S4g8gpxMlt7U2NqCZe8Fap1sMD68YUhxbLb4Rse7WvizutcVI7XP1bsggO
         4ro6ffRW0hQLh6A/I3owT7R3beBjah/R9wskt8O1oLLsLj9jDovtDFdz4BimC/5Ww9ES
         N+nZYzJEV3ODdfkKqLPUUVKo83TRq/3Xehzed3hWCLfLmkKVgXAmo0yHWj2px4+sqT/K
         itCvGvbakIIIw3ELe0AeGQ6HRD9WFyeUPIUHnJCfXYtv5LaR+vdcqUiSDcZTrtMRWSDo
         iT8IZgG+CJPgfQ9gXsgQelCUpABzLMWVe2gM822NMSoZ2aehzRkKCpn4n4ENcAdXJoE8
         8XMg==
X-Forwarded-Encrypted: i=1; AFNElJ+fJZN+VlC1aGO6n7aAHJapPOng/oXEMJsTpCwXpDIypV9eXmKoTxCB6iICojAGVXLDEHyn9bzcxQ==@kvack.org
X-Gm-Message-State: AOJu0Yy30Mpdff36YpTPRvk/ncozUEt//3IBm3Dr/mtmPVUhyyaD5Yca
	MiyK5hEGnCm4NVPldWnJ5vxclwl9lon+u2Y8bV0bYfDxMhF3vPNi03nUkKDlLBR7ekyBdumrIJx
	FeJErrQNZXw==
X-Gm-Gg: AeBDietfPNXOtif0r2gQdBN9LfDTxYlJ3Sro7GZbI3WKZVKSp+gZqM9avnR08ni/atO
	I94OLYU47PH7c90Hn9U+5j0ev40PcEr//olWNjqBB2hiMqHWEPTheDg47mNujS1vWwFrhtYz2wO
	9iWFEY/wkiIznyHn9EJD/1Kq2wNEdZb6iUpQQWp0BgY5k5Vl86zg4gC4oMK5MH1sPqZisNAZ20m
	zgbhgIMOTilFQXHTyikRa/7ecTbJqpPqTKLalFHcUb+vDBpQ2TEphCAkP7vMMIjk647mu9XosBJ
	EwfRZtRLtNvrIJpDSZthhdDw/dqAWDTZNQQeVP1cHnJRh2maSjwxbOo4DoJsxAF2gbURzLUQMvg
	yJx3lz5D0ZmQbSe45QV+7W9NsLg1Mp+VhrvUNStSjqlQl901he4YICSgQnnOzTnjBU3IokcwrN/
	NKitYgkjh4xQ3Tg/Qv7mexLU3E/pcx4MlnGEj7YdC96XP6HCvkqGEUlbIqIR+3FBN6nXHbr8I85
	FlgzibF5B4=
X-Received: by 2002:a17:907:3e1e:b0:ba0:d58b:6045 with SMTP id a640c23a62f3a-bb803778202mr30902766b.27.1777327110392;
        Mon, 27 Apr 2026 14:58:30 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb80b2add0fsm10106266b.34.2026.04.27.14.58.30
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 14:58:30 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-676e62faf2bso10759750a12.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:58:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/vMrtkkPIZx8l6R8lt/FgOYH2CJA8sHwBZIAqSpo067nOVgYft6y4Q7Qx25loWkKqQXUdjujgmYA==@kvack.org
X-Received: by 2002:a05:6402:35c2:b0:677:270f:6f4b with SMTP id
 4fb4d7f45d1cf-679bb04a8a7mr185115a12.1.1777326742385; Mon, 27 Apr 2026
 14:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
 <ae-j2_QirCySZD02@yury> <63a4d0f6-0eb3-48cd-9f98-bf7b223b2606@kernel.org> <ae-2yLWSGnfeTvh1@yury>
In-Reply-To: <ae-2yLWSGnfeTvh1@yury>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Apr 2026 14:52:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPrLy0FR3sEWBYQuNAac1axDASYMnTuPuxEU0WytzL7w@mail.gmail.com>
X-Gm-Features: AVHnY4LQUFWo9ODz4M3q2vZC9Gn8nsdYr95Nd4ky5ERVHHxIyN_9ZXY5zjebfdc
Message-ID: <CAHk-=wgPrLy0FR3sEWBYQuNAac1axDASYMnTuPuxEU0WytzL7w@mail.gmail.com>
Subject: Re: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
To: Yury Norov <ynorov@nvidia.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Laight <david.laight.linux@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-alpha@vger.kernel.org, Yury Norov <yury.norov@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	dmaengine@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-staging@lists.linux.dev, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 20603C000D
X-Stat-Signature: pypnsm4f3hgjkgdy6m7bn6uyn8ear887
X-Rspam-User: 
X-HE-Tag: 1777327111-278241
X-HE-Meta: U2FsdGVkX18sIlXRLUMdHXQqFtIFCQ10XjY/iDzhKHLKKWaPBEKscxp8QsjbouhCB9ix5rZvXfDR3puVou1qwqQhfJU4y4lDZubyAQpJ/6Bwa+QpxfLBj25kOB9qzcu+lQKnwpTBZ3RhVVD0qksGo2X8zK8apY0dFv+dRuIrP1aZNkPKo5CmnWWN7xE4mFDhxFvbQTEQOpPtyF4L+KyAtmK4ydg5X9C26n5QN1f6fjmXmppK//NjwHycDPCFi0SZ25NF0m8izk9HiKdH44L3MBTvCHrkamBa+Ra9XWuGbt2eO8/LVuiyTwVhlp3oWiCzyvP5G/hhP5ILpz9v3Dh5MIi7AaiPWNGRo14kM2vwBuWuMmRPhTTyToO9o41BEjPoRZA7gw6vD6j5GpaGtmCH20Jz2PUb9aqPV05yr2nMvT/kZVRReS5KOLdo8Ku+Au5xw6gefkQNb/HmuQ3pSdevHheejmL/0+s16eNisBHYsW59mXifx6ehfQjXmS5ppirM+5J2WZY40EtbkM6WV83W1sVGZ+ZYhbbF1cls3uMdk2OHX6luSmnBT6lLLWtEIgrFb7isX8DNN3/vKoyOL/tEkgvkNg62oA5WZVlWuI9ik9omTv0gEmzOB9aIjM/VBhvkiob7GJ4L4IFrFxjJDROayQiI/II327Gz3pne+Kl2jVFJtZSPFxysJB9mZvkm2L0un+X3lvSJ78Y/gGErWUqgF20lH0/1fCk83GSLlScPqsbFNz0YH0EmKmIE+UEIvYlc+Md5DAQTegjjlJojB/vxkPt1+NeVW89AcjMYqsvB9c7Gw1dgzh6UtpZ0z0lELf/NkyCNHoMn9ElnRvUsfax5GWCVHFv3nhqrnNZWvAk1xTLrSEIpteAWDorADEdS7jky+hxRVuccOgyFrkDavIfwN1o2kanSUAp6/8BmfIMbXMwS0hrdRWYB/zD+UTPKlIK/99wRTSB68hyd1UHu9Fc
 cGMnVBnD
 wHNSvAR0ujI7mGB53c80lFRbPwjFQ3rUpfL+vbifxn+wkgKx0wq+s0kLtjZgxasl1+lnNMjcoFRwem5kBcRgLuGkmN/a2t87Ic/aM2dwhOqxqx8Gu9t9Sm7efYPxsbV+q6E52MWcfJEq7ikG1aRK9Fo3a86veHRbn6mWlY5xuJxgu9kvlSMSjzD64eYviF1+e9ydm+f6Sry7AHghsim9mNqDjDd9rcIP9pVTDy7l/2goDBv2MklGuhIDHR5LQRERJGEUTgtKPF7V7fmneN+9Aw8tbvUyXdvFDzQ2MXoCSHvt0oHiZfPZrLjmYWRajnFwO8eD9GcDHXxQBaqOe3NzOsE1vWaTnooCO23yhilL2WP/gaaJPsFStJVgECjQdDcpLTRItkZkuXhdsGdT9MY+49ZEFQFi0fs3ZGNp+CmzWBdq/D4wGruCJ/OG82J1Eym3mjxiLaXs6VnCfzJGHNurDFaGnY/3hQ75h9muZ7qPux2kHMK1X+/BKXPOSwS9t7RfzBiIL3VL10Hklj8fEUHA8rCu6HcIMa8PXuBR2pFb8K6UlZ3VMO//PdJlX7u1FG5ZoC3ieKZlFsm5XlOddxjTmfOgbXuM4ZW0vew/Oa+gAYoxEwFze1q+R1fRZtNZOyDwctYYNpzdQo2f6JhVg6tMnUrVLt3qA4iHwRXnMLfIe7iJzJquJjkLKH+ckMQy5mXMwi6p1ZO37sPWoYf3ltHRNQTk3qMV991P+e4xxf5FW7vaeytxSP1wGAodxcsj/bAmuRimQToRtELewT20vYBF+fhAfQJI0UBX5AE1HssoQBZiaxQ6Elfv8v7HcgGaH+qnjWSjtkl5AAZRz8LIzuPGG9UYSsFsZ2FuQ+unMRO6KpKXCX9o23034rI5Ydhjyps6o/QqCoSq3J0jOmWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 at 12:19, Yury Norov <ynorov@nvidia.com> wrote:
>
> This is what Linus said when added x86 implementation for copy_from_user()
> in c512c69187197:

Note that some things have happily changed in the six+ years since...

>   That's partly because we have no current users of it, but also partly
>   because the copy_from_user() case is slightly different and cannot
>   efficiently be implemented in terms of a unsafe_get_user() loop (because
>   gcc can't do asm goto with outputs).

now everybody can do asm goto with outputs.

Yes, it's disabled on older versions, so it's not *always* available,
but all modern versions do it. And if you care about performance, you
won't be using an old compiler.

             Linus

