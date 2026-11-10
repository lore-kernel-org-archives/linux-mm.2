Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8BF60A380A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EDKISuqn
Received: by kanga.kvack.org (Postfix)
	id 603B36B00EF; Tue, 10 Nov 2026 10:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBF96B05B0; Tue, 10 Nov 2026 10:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2EC6B05B1; Tue, 10 Nov 2026 10:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E66E6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:03:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6767C08D4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:03:22 +0000 (UTC)
X-FDA: 85419527844.11.70A0E13
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9832A180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:03:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EDKISuqn;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcxrNtNwR+ubuo+QT1C+HX+mC2Hh24BYfD+aCKJIoPI=;
	b=aBNE8v4RB1LSZ0SVBaV5wMpC97i9Y2hEcKqmUIKOtaBy30C3B2Pt1xTVB8wRvpgL+fjKyL
	pG5GVULLQ2Ia1hfu7l1aodzwJGO6mCTKxbbVdp/n93xyPk/204knr6I9i2lmk4LkdUOAgp
	7hCD2ZH2Jka7KjW4wIX0FjIupKD46dA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794323000;
	b=0cVelpq2oB24GZZHfmQ5H1C5CGRL6rp+CZLLqd5Nd6/AR1JNGfOH7Fh8Qa+r6yUmqR6oBR
	Jip//ef5T0maA39t/x2CsTsDT1QPdDNhEni6KLBTZ/PJl2AbVJxPe+zlwv22irU6j3XO5r
	pQUkIvyHMLYmV5zuHa8CU9kVJKWBVTo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EDKISuqn;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3ab30b3212aso16276131fa.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:03:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794322999; cv=none;
        d=google.com; s=arc-20260327;
        b=kbAj3l0zoLvDYzwnJNeIdcR3fkT5aWRZgtWEZdbK3Vc2fsON2w6z5okBLThpIUXOIM
         9fZ87N1rUsdnHneKrKmE8r0KB+j2XClp6cEqiKLX6qaf2yYIz7rZP/hN0B6xTuOhli0i
         oxwH+qm/EOo3M8Izw42A+q/DRBeh4MjKFRYpE7x9ezOISvGRrTZa2WkeaxFtvqawRuYd
         w+L4dhVbaOVyqdlu+85eHyOLppthhuUZT4ZpFVmWHuRjg3AeQhHKwWjkY0OnPvJTAvhd
         XiFKDhNf3Fo6aICGvr9HbS6nWYrvXnGpOBUE7QhSj1QNFtpxdpWjxQbmkTmrTTuzjTXV
         Trpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lcxrNtNwR+ubuo+QT1C+HX+mC2Hh24BYfD+aCKJIoPI=;
        fh=j5hVqtceOEz/JanpgCLDVbUkEyaE9oXYpj/+CDieRfU=;
        b=iJcR3/LLoKOk0gG/D99+5LZ5AufHBkwpTc555W4raANq0cYnIoCynwAmgHN36rs+qZ
         wjJbsG4y00vefWz7n+9BEHxQKbaiCnw80aTZn7UEdTyTnFEB0lml9AhrIeKpag9RbaXn
         EQ9ICVVQnMBph3Guwvce6rGp+rJTo00npvrEe19aTCmEKlQFzDCA3fShYgLwVJU5n8hr
         iemgQc3EuQxPGDeAN7OjGVgnFoVMsTHatuLIGv3Lah6xPjKFcY3x5OfMfAnddP8wfniT
         jBGlkQjX3XYBjddjj6orFi8vfqB3UTqg9r09fOlyVi6Ft/0p2EhYYMSfRHv4dpCK19sN
         Y3zw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794322999; x=1794927799; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lcxrNtNwR+ubuo+QT1C+HX+mC2Hh24BYfD+aCKJIoPI=;
        b=EDKISuqnRTbpkZ/pwzu7ErHVT1qY/EKmkkC2DXMd2klNUQ9tknqWMWYSPWpDExfXU9
         hxhTVVxJdltev4R1AiHk6yrGdbQEBZHIAHY4a6qCT79K2T1VfqzM6s0V6JjAY2RbSDrr
         HwwktoCsmBS23Kq8y6pTdjVnOgYn69u4AI6Ay5ff8vEvWsdScz7pp/7anywE5h5SO/NK
         T3sHclaPehyQg9RnDvUjsHoc2UaKUH1UarsrSxK9vIEY2PcNqm7EqFxtIHKLMoHnD2iq
         /DbTMX3HaHXLc2j2/kjjYS38/BxTaot04sYYXh4Ekmfw9C2qXSVui7l1ErDsoBQ388iI
         wDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794322999; x=1794927799;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lcxrNtNwR+ubuo+QT1C+HX+mC2Hh24BYfD+aCKJIoPI=;
        b=C3TwBF7CiFxaLRMbgxCt7dSrcdtLTfA4UNhT5DuoM6sXUncQ4yWu1PIO6ke+qrB8NX
         /8QVhb6LlKyFbnWpZgrjxBqZ2LwN+wjUViz4WtWjIXVmJM5ubwysrM8TJCqnP7K+cF0B
         16q39ql43Jqpw3+G9MnsPJBJRnonYcd5HhLDZr802Ng8vvFt2uf3QR9qK3j69FkZD7ms
         EYVJWBDPoCxXpYw0hZx0/viZNaL0tmNv39NTZdeQorZM8DYZqsBBgIq0JXOTIYzFr9rt
         s22qwX2/7kEJGhCZZQ03xa6PFPmBu2tv48ZGXWeXK8X03Jy91K+I84y1QOtx+sNuw4Sk
         jYfg==
X-Forwarded-Encrypted: i=1; AL+hErEJPiUxOvGjyyXpNEmstHxTqebbItqxBerRdhSFYe78hTqcW+39LU+X+UIKbjnRBFdpKYExoLb26g==@kvack.org
X-Gm-Message-State: APuU4Z/OANE56Wp7SVxOJbcqst4jEojgnEuB6+JbP5WKdwthmKRQyLOn
	VBcWvngdyi5c1BfmWtdYyiD3BBMUA83tHNhUbMxHmkGtPlTjNlxyy6nA85/5ofP9EALsTGfVYqX
	SrZ9Gb5wM02SCClLxr0NZhIiG+Tb95jo=
X-Gm-Gg: AYBFou3JPCbLTJ1HmrHd+XiLOUvP0eiy2humhNpW+SqkZPEZPJ5GorXReYjg2qbIbFb
	IyX8+eT6BIGU9mhSVVtDn+u3r+ns4W2RK9C2BXJFRG9RA0IZYxL1YAVHBHw55zwWerVdf0XzGFF
	hjrI3rqvHpE7zircAKcozW7M+jkyZyKnveAOCF0bbiEwTZoAUgfOzPYgf0wVGJyjphn6iPozxhg
	UUHUmJJXxgJYDaV/JX3wD1Guq/ZCPgl4n2j6emcQ0qIzoZmpOrDCgOCq9LLpQR89iRrfeYI4Y/P
	v0uI7wEBl+ydP1yDF0TnLDmGHueqjdHpZyAUTKf8+WL+KDuomFX1ZsAheRcAzaUKxkmgwDFMJQK
	SXDUiK32dLjd1CEK5NRB9506cW4AAJfp2hWGefm/bz04eHKui03+V23+iaUTKVSxQjfsT9+pC/a
	B/VabucMgBJ17PALEh0mBTavs7+vTP0tOnpsw8EKRXahR6btVt1Svl3BTRPQbw5UxiGbwXdFWMc
	Q==
X-Received: by 2002:a05:651c:886:b0:3a9:db75:823b with SMTP id
 38308e7fff4ca-3ae0963461fmr6011631fa.17.1794322998586; Tue, 10 Nov 2026
 07:03:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com> <20261109-zsmalloc_stat-v2-2-caee41684aba@gmail.com>
In-Reply-To: <20261109-zsmalloc_stat-v2-2-caee41684aba@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 08:03:05 -0700
X-Gm-Features: AclHuK85VkAR2wnOqNqvQgZfQ_LlfrHbXEwJe7NhWmwf8P3bqM9yi-Y0ggTdBo4
Message-ID: <CAKEwX=PNpMr5x4gTo_OK5D5EgKPDvZx2e2=95-4_SV8zq37VnQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm: remove CONFIG_ZSMALLOC_STAT
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qexmimn7bd48hx6kr3na677w7p7t4sce
X-Rspamd-Queue-Id: 9832A180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794323000-107182
X-HE-Meta: U2FsdGVkX18OtuIA/qpDlONPUHdADZEQpypoKwNXntdw0pvhnajtYnZ071tIOolagG2blLKoCXzAcBAGEW3DyH7hpMERN0l5GJTdJauzwgqWewrUwf8A/46FqDGAtUtFZ5F8Us1PvYR8VSN64rSgHYukV3G646Y48/UWrJaU2AEkoI5Sn+/vXHR+QDJxqfNv9uSHrb9AEA2+uQRdPzjSsfp4DRRTVYu/m4m8ryY62QZLBPoF1sqfwphVeEo3G2LUf9XpkVz2cTYY6UM8/H6yAR9sLlFXSXH8uTv7FGPObFrYcRAV5iOoIllkQGpWUnu6Kc63uFJ6PuyvDbzZwmf03ptK9g8TsEebpV+PnrhSmHByelvbmrCPwnMYl1yZXpFKOdEyioyrVW2ytxqJxHt5UQs9WghiaZm++Su32XNo3bDxsF7MbyCekPlHZlsgpLz4UijvMUo7KYPp3B7k/XLju8R2+rRYHss8vaIt3CFI1X6b5iZK7+SOEJcrD5mEa3dM6EdoGa7qJwem/JdSQkMnPyBmvY1rYGrmAAkSPQfArDN423Xijsray/HfwZNDbh+b4LHBlshlygF/5kzAg/8gr7TQk+3vhNcY0cNtwcCX+wUgyH5rkAwS+GOVv+4JsLsezi4Nt3z/vqzSOBtBCFRVb2hX/BDISrwZwUz59cKcfoiZx8muQrpK8pQ5T8FbsGrdcQCbgVODW1JREzrx1+YW3+MJaHdqP2hjMyXDhL5LnpEgIPRmwNOrHgOV0AK/rAYK0wXDIJw+Zf+FvHrb/FNAKgVMlyuoS1lXhiD5DImhhCauC7aXt3qavWZ6o2TNF04IQbM4XuJfMShksByTXrCyjM4ROVxyapLeshlbTiq3hQAYmppdEhcmvp1HqlAsh8p4u3U+KTq0xFiBeFU/qu1uz/aiQTjb+UXd1xX9VpCGQ1RMlD3UpqXSilASjxpM9ESIJfKH8z8pV2/IUp8meuJ
 09U2Pem9
 FJHtldSqjVVjn27SE48aWouhMwDa+WXhACpfZs1FIpAaHK87Gii69VBlrvsOzUxKa7VWZA0gCM4rQNGJ7ytrTEQhJlEOBlo7mwcqBl256qvd21qwGhbwpPEUyQfueefce6K80vQe+U9LHrpgreit2wgQw3X4N1VGciyaVYIyXASjrwkgTnlBZfvVuT1YQeop9PAsItOjIY0EKUvJF+GiV0exCSBWAomMj4OwUoLKZvg/mQcm+IEHAi823ONwovf/ahxjekbvTzxElBigiP3mN07N0Oqad6asKsed1LUccJI0D7Y0zRVxp6Nz48X4vyCy2qE9uRpfvJRh1ngJeCWOmHa35kUgr/5sR9h+9WcV1OzD0wuwzp0k5/IacMgE+LqZnLtuI0PC0lfew9RfcHB8weW4/nq+HeZGSBwRN1owty5MpNOua4+ozqdD5suObslR1jFP3yNmUy9puN/fOVZAzW7LbefFPC+NiifyUVZeoFk+/3EWki3puSfecvzd2+9o1tJ7LUBtADKbc7azsyY2LiOmYIjdpBUyPoUuw40u5DG0LerAWdtDltotPfGT5BWahvf7h53NwMphFzWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 5:59=E2=80=AFAM Xueyuan Chen <xueyuan.chen21@gmail.c=
om> wrote:
>
> The statistics interface now uses the debugfs API stubs directly, so
> CONFIG_ZSMALLOC_STAT no longer controls any zsmalloc code.
>
> Remove the Kconfig entry. Replace the remaining CONFIG_ZSMALLOC_STAT
> settings with CONFIG_DEBUG_FS=3Dy.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

I wonder if we can just squash all 3 patches lol. Anyway, LGTM:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

