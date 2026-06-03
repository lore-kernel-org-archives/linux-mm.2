Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE1ECD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A6B6B0088; Tue,  2 Jun 2026 22:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01AFA6B008A; Tue,  2 Jun 2026 22:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C476B008C; Tue,  2 Jun 2026 22:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D168E6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:56:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 853071A0208
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:56:33 +0000 (UTC)
X-FDA: 84837088266.03.B89CE98
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C28D1C000B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:56:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BSeD8SxQ;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780455391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Rb5GuP7qCXvv6hVFVd3PQX3Qg81rzHoqmLNRToBEiE=;
	b=ywrsSrevCC9aInXfZyaA2iTp1NV8QT4O3YpcLPuzhOr3bpzgVVCPW7hVbgeTWluCUbgwx/
	+rN0FKA8sLb3m9cBIWYBXzyEOA+odWhsOXICZjWUUoAyPELntydIZrn+fArtta8PWrmlQ/
	TWbPUA5749V+Ju7C4+mqi2FGQYBX4LE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BSeD8SxQ;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780455391;
	b=5cTviCewmaoptdyivBTcEbaphkOji8pnBBrUDNkgnK/H8238uBD4MzkTzgBAzNz9AvaDrc
	UjczZTuDZgUdoPnPBtEqteHB3FPM97mhkrt/L91Sw7p5FJ4Jf7OVHAPyx9AiGPOKiDEnrO
	A3ed+SaJwO0OnfIXeAFesOMJynrYtyk=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6870ad8072eso461125a12.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 19:56:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780455390; cv=none;
        d=google.com; s=arc-20240605;
        b=WxibTdQWo+6DxfxZNpKwaB4CNNQIO9zKSnTtUO1MFkcVCC/0I0ruvGoG0x7l7cW88S
         3YD7PopVH/BiHaGCP9K6oE/710dvTe7yewOHCfdG9s0WEDrnb6DMtTiy8QolU3K2XIPi
         o7aH1sI2HA5VwRNCyCtuewsNdhxXQ05nUYvacKcwqtjpJmWW/PHj9raZU28k7bza69zM
         7j2ymFBCpreuRzyu8w3FbUOF9RRIcTn9DL7YQCLMaeZhJQMO4cASxgXRTQOtVGNPp4xe
         pp87Wbp+ULKHB6SFww3ol/UUYfHqujP2qgVhWOn5160FqSidTyQYgIs/TFE4Qn8pq7ce
         q84g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/Rb5GuP7qCXvv6hVFVd3PQX3Qg81rzHoqmLNRToBEiE=;
        fh=CHBn88Pv+E1zEJ6F6TFJio4FD+0v7HJrGaQook214w0=;
        b=br+R4M9yWgb9rj14zTD9oY2lty1ek0QxUqlrX6NXtYmmQBw61Arb80ZDTEyA1WjonH
         tn5tlb/mW+vkNeL0BFDx7yB5+tadYe7sG6ad1RamR0XJZ7zH98r/PtZTqkIopfk8UZVE
         6+ONkA2cI0i9rPXoUt1clxBVZDqBD765mRQYB0q8kj8KpuHQimK22TeA31vrpQEICL5a
         sCo0TT57mfbcn7Rz6yA/zswLJ/I9AmE4+CbAUJCq/hbDfdLVXUymRV+AL7ZzU8Bbshyw
         +YGY7H2KnZvIb/KUTrO3KNaLgnDvZkJ9VWuLb13B8DJUCB/ySuuSjZrSbeQGZpmAezcY
         yCMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780455390; x=1781060190; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Rb5GuP7qCXvv6hVFVd3PQX3Qg81rzHoqmLNRToBEiE=;
        b=BSeD8SxQrnKPkqegVCaaFGu6qj7VT2fdHFCzy69hv2oG4Foiw0fVoVtp1em9/Do5AO
         ifIH1y1Dppmst9djxuqO+o86bsOrVPl1Kju51kDkAfgwMtX4NI6+LG1LZxH3HGs0NMhX
         ZUzLi+y131p1pFyCLrRKsk7zZy5WtT6qei5e7s6mPcIpIWd5NHvKX3x+rE9WzqooSeY9
         FSWuCHm+78V7rgdSYfQwnGvgg/KYGOvFX4peTgQLbQAypWKHQ4Frx+OAysqV6vkJRc8h
         uutld3Y+lVhnlIV6tB4oeGTk1KMooNQDqYHDHfWrqAoFygxmIpwvTJQcektlgavCY5kg
         bOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780455390; x=1781060190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Rb5GuP7qCXvv6hVFVd3PQX3Qg81rzHoqmLNRToBEiE=;
        b=D6OgcFMtX4OXiXwNazRFMrPuvwtxVFZ7sCA9FhTyoN4XJYxa03KP5Au/FayTuRCDzK
         YhSPAzsXRCE5jXK5x/1CAjkLJ4SnW6FEBPm7NkVYOrE02nuHHm5clfJkf7sSN1Fe2nge
         gdWqKzCe09RMnBD+bHtWGO8VCZdBYE1c2yO6eczoWkI4zRreSTBXd/SWmWoxwDt8x8V9
         To5cRRmnQMk9UEVb4EwhQDJBqzpHQvyrZUp3XTdvEXPQ+/dCHd1UxiPeJbVuYIkqQHhz
         TH7XB4o05LQIyGAuhKAJbpQv22BWW7H8QU53lLg8MeMw/Lk5Jjzes1AV+D08HLXRdbK7
         PnGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9HgtN9gT2YwfpgZ/sfQH7OyBTPVNheV+F8oCUhI5w3XesDxzmWHmKzOZGyq1D/hkSJn2IZUFvnvw==@kvack.org
X-Gm-Message-State: AOJu0Yx0rODzfp0wg1zHWhV1wKzQPNUjriHLDlLP91J0V792A2zxqwu1
	FswVZFggqxquidLLxocCDJZdv9zPWOkS0kKfBt7Np1w71yyK8zFuQWgEurW6sw2lUYBI9XxzP7i
	/9vglPJD9W1Dn6YJEOPbUDR6zzsCpFQs=
X-Gm-Gg: Acq92OGUZsi/lgtK/hfbYiT9jcmGFnVF7UvJ3S1InTjNWGQfL0Shdlq2K/+ybOsgTN3
	9hxsK2L36WU2rkRjLQupOFj25sH44LTwbTNpzNytXoSFgU/I2553OqA9bI79RKiTfcF/5NNZRHD
	m1RUnYiF1/LgtAomspWW7OC6bbeS4zguvvQ0+A9yH5WWdcIgdAoD13upjB1Vl17Whu7OnYHdpbp
	JbT+hcm5DE9FnvXOd6bd2hh4hCEr888dAN4aLGxdQR4lfSc33pCB33EUQsrnMuaYU0SRN9HXM7a
	tm20NCxmKOp2UiU/tx0UHm5BpTOyao+6BLhZN7c+PCeC5EznsQ==
X-Received: by 2002:a05:6402:e98:b0:66f:76c8:f747 with SMTP id
 4fb4d7f45d1cf-68e6de77840mr515951a12.6.1780455389723; Tue, 02 Jun 2026
 19:56:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260602172247.279421-1-usama.arif@linux.dev>
In-Reply-To: <20260602172247.279421-1-usama.arif@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Jun 2026 10:55:53 +0800
X-Gm-Features: AVHnY4IxEMM5he78br7xJ7cYOqbwHi_Rp6qHpRqoT-U_qFFtGzLmEI6F0XIhOiY
Message-ID: <CAMgjq7Dz9vV+G2vHtstdgpwg_vp-6ij3WiUESBsK1YeMhSj37w@mail.gmail.com>
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP guard
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, vbabka@kernel.org, chrisl@kernel.org, baoquan.he@linux.dev, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, kas@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7C28D1C000B
X-Stat-Signature: njouyq1ue1cucow66oarcw71hcq4yx88
X-Rspam-User: 
X-HE-Tag: 1780455391-367047
X-HE-Meta: U2FsdGVkX18BNFp5IMUtxFcKuPqxRp5D2QGn2T5ZqRYtCjW/4qVYBMxVDD13d7xbIEDjsMezY5vgFWJaxEW1TDWM4aFzPaUMq6Rdt9hAog7B3n/EJ7dvAkGutTAm38ar//cKwkudGanbSJ3g9FXaMEy9g7wlynmVRDsQ0ByTqVvgulAVtaaJ/coEkWjmx4+JcrH1BpdmGWorDbYcdydHBeVin+ejZ7HksG08yB5KAgGdhlj+GkFw18sPrUSvAZ/gxV3NHFu2lrBNBMNVmXtl5S5+nk0Id7YwjFrNCP4PwPPrZYJjxvb9hIL7fETR9DsXj9HcEzoWGT2FeWIwW7ndQdHmNnfvRrZJPwMrcmfDXoQUCbfz668xF/+gOcU2LYHOUk86tZU0yghDQYGeRaLwTPj/i6aFHhQQ+dLxtz9bPJacY4bFZkMk2bxffYvMiogN6opDFaXhznrKC41ToIGv2aVlIwzGJhGvbL6PlL6sqmiWIcWfM8pUKrGQUjTeT2tOq49+N/fNDG1mClTN5nzdDsYdMdRBkLtfipro9RQI6yhK+iVKv07KaKuYtLky9YW9TxLSZ6UQO1PVTwQGlwyl0oy4/zzzAsIrfGmfMk6Nnxu8zyn2XKN7j6TFixJ8ohrLysf7cd/mCb+R6mqshBwdvBlYWI5tHsQYGNqWzbNTkjBfZHuomiY0VIKeeeCNKCXkxWsd+6xbojS+E3yfZLuTL8TF1e+kuq5UQ8z0PHPCgaUSYUjc/qHh4iHuO2dowMHwMSAMY4XfDgU7hpmldQOoLnLoBJesy0usmlBOtxsoTgPw+wEEYZp+erd7hWYTe6RA5xqnt3tIcilWVbCotjXQqB/5u7FThTYj5/yy8TpLq3avke5ZuvuBZxYBWd1TuNUJC3/WwK9YPiMeei0AcuZ+bFHGWpZwsNlviIP8k4i4/LilnGUKEQQeYrqnX6KAzk6My+R+QJo/vEqqMOtOIHr
 Dq1mNUKm
 Gy/dBtRwO3ljck+BX3ABb/K4Lg2b3UOFivqo5wERZPvSJ4d7DHy2zc6I12NvRehyx7xMy1Ad/thw3UrsLQnGAxw38/SyrbsopOgfenKIi74SLbT0iX2BYlDmCbGiWp4TINVOpOb+AiZrt9GlMAjjh02bRYoaYzsGTo9EK7qFSLWKAS8oYstKpCtkRcJZkqG1MGJfxcAB0nMxjwQTk+dy+tcsY0CbmzQcqw4o6dwbSmX1S4+2VxXo0TefTZUKGytslr2osj3stp6LOcPIIknTtSNvAM7LZFUkVsQU6ai2jIgNzr8eEbU9o0k+eVeZVG8yPhC1NaCOFxr5GU6mCW+RC182+UvarJzhBFSG4SjRlq5BwSU6g68QCOfbW7VLN4UEqRch2xta9N2aw6JZzCtT1sdgEk0ROObtQRUOFUY0nrmxRFHI932f6t8jOrQjunHtxBlp0M28GuwHaEM51BbSmfBSAOkRSVSTv/L5o+vNPoUVVxQZVOYRjD8SpszGcp2ymZyxnt0parLM4YKBE8C6nJi++jNnaw3Z79NUc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 1:23=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> mincore_swap() also fields migration/hwpoison entries (and shmem
> swapin-error entries), which can exist on !CONFIG_SWAP builds when
> CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
> !IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
> return, so mincore_pte_range() can spuriously WARN and report these
> pages nonresident on !CONFIG_SWAP kernels.
> Move the guard below the non-swap-entry check so only true swap
> entries trip the WARN, and migration/hwpoison entries take the
> existing "uptodate / non-shmem" path.
>
> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cach=
e")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> This was discovered when working on PMD swap entry series
> (https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev=
/)
> ---
>  mm/mincore.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/mm/mincore.c b/mm/mincore.c
> index e5d13eea9234..296f2e3922b5 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -64,11 +64,6 @@ static unsigned char mincore_swap(swp_entry_t entry, b=
ool shmem)
>         struct folio *folio =3D NULL;
>         unsigned char present =3D 0;
>
> -       if (!IS_ENABLED(CONFIG_SWAP)) {
> -               WARN_ON(1);
> -               return 0;
> -       }
> -
>         /*
>          * Shmem mapping may contain swapin error entries, which are
>          * absent. Page table may contain migration or hwpoison
> @@ -77,6 +72,11 @@ static unsigned char mincore_swap(swp_entry_t entry, b=
ool shmem)
>         if (!softleaf_is_swap(entry))
>                 return !shmem;
>
> +       if (!IS_ENABLED(CONFIG_SWAP)) {
> +               WARN_ON(1);
> +               return 0;
> +       }
> +
>         /*
>          * Shmem mapping lookup is lockless, so we need to grab the swap
>          * device. mincore page table walk locks the PTL, and the swap
> --
> 2.52.0

Looks good to me, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

