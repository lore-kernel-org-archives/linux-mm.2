Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28CF606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HJQfLE1G
Received: by kanga.kvack.org (Postfix)
	id 9608C6B08A4; Tue, 24 Nov 2026 18:16:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910FF6B08A5; Tue, 24 Nov 2026 18:16:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826FE6B08A6; Tue, 24 Nov 2026 18:16:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58B806B08A4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:16:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5AFCB140D66
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:16:51 +0000 (UTC)
X-FDA: 85471574622.11.1E9D53A
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 35640140006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:16:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HJQfLE1G;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795562208;
	b=vSQtSC/T5PRRYICWRS6lqAIlrqO2g4wYINHxF3FqhbhRIn/dbSX3IniGHQ3AhzD70vC5WH
	CGoOt8rjWS+tF01uKj9XZu5SM2OXBaME/8xYyBjHwG4c+BMShTKpyjZYHuQzfTYsMj9EYz
	hTzJzcNyRmO2edpDl3EKOahqBOhZyTI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795562208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoFyEnud89IUcB6sarqMzo8JRRy8dWijZef5NdeWRGU=;
	b=Wp7rhol8agx2zh0s4Ya2SG1Gw+dHHRyLJno9iG52hing01mG+LbbnRP4cclGqD6U4W1ZeF
	mIyET/en5KoYBU4t6e6vWzh7sQmAJgv0kFrsdPNo5DlUOMx7cr8K2c/DJG1kzAhIGLVWav
	6gYDpv0KEsTl08kPwctUfO0ZH9iQ1f4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HJQfLE1G;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-492f0a1b685so3510942f8f.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:16:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795562207; cv=none;
        d=google.com; s=arc-20260327;
        b=SUHsWpSSox9XDyaeeHkFElnw7sleh2fshAHN6JOKsWY4MZ/UyT5SrjG/n7rMjpnrD/
         7W2GqUfSiNnSmhg1hk1XKyrINasp5vJYPmjpg3qn9i/GbG5/+/eocXbJCT4LO/wjhm8i
         v3pvHBjY7rPQ96s+Et+dJXzCtnj1hcKdieFVjE+lNx+VMQfkPw4MmXVF74bFwAhXffbc
         RC19U31r/XDM+cMoNRdNPoP2XQLA1G+4Zn793Mdcev+GEqt6ccAO15bqWNwyp+ek6QSO
         wWMr7hULGF5OAcu2ThQmHjf1g+CK+8VdaNSNKVYfWvnDTBSxU2iCJApXZ66VdWn7C5Pr
         e+hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZoFyEnud89IUcB6sarqMzo8JRRy8dWijZef5NdeWRGU=;
        fh=BXz04T8IcjnKx3//hW2r9uq39LKxa50HihAbhAAAd4s=;
        b=krKkoL6XhcOqarTZ1Z+/7EOFCzj5cxLkVvNGTNrnCXvynOJKoFuvUOPEPbqVTre98+
         Q9gni1A8xCFgQzWncEM3c+TxHsAEZIzK3OISNKaNPGkBwby3TtpNgSduBNjo4MfTxIVD
         0eA3lZuwY0tV3HRl3LuB5mqjnuwdrkf6bwwR7DyH4VCvcb91hHHHGKQUNc+mDlOl6d1Z
         Usgplm48fwDXs1X6FPbBRXTc40fUGipdsJZ6p8fsDxr+AMHJvmk5NU6NvaqC4+YOnVnp
         vr5AQdhc8BiZDq+OIt4KhAjUXjM894jXy7byXFj+uHhiWIG4xGTzSdoVSqbkzQy1GaLi
         V6GA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795562207; x=1796167007; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZoFyEnud89IUcB6sarqMzo8JRRy8dWijZef5NdeWRGU=;
        b=HJQfLE1GisU8gM8htsywIpj865LTsCMYM7/AfnsxV0qQpFjYiYW6uNyr8Aq2C90ysV
         Fu/wYsLjOtxpJgn/bXGQJaklT/UQ3SXnJKpffPzy0xuUTm1E60C/v244jid0NOd98626
         wW0HU/OyjfT6t+YuJd3oNjKyBiU8FfSdVnnaEeA8B1mnMHllGyflaDHNoWKy3IZ+iZqq
         kkSFk9wY5KUZGw2QQkzHW0KHKghZ9snV16C+vK6OHAvisw00N2xC8bmrIX93YYU+3ttI
         kKeHSr9XFV34q+43tsAV16yDd81aRh1yuQ7CIquzOEseoWXZF0VimL9ZpGngIh1R6nIv
         oFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795562207; x=1796167007;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZoFyEnud89IUcB6sarqMzo8JRRy8dWijZef5NdeWRGU=;
        b=hQcFh5yS13HFPA+B/mTXmgYAa11uPvGjoI4k5JOGN1eCbM6gCZ9f5YUEcNO7eiU7H0
         l2YOSbH5eWx/avAfARZbnsXLUUwryOlukpT5bS1P6jWTegzUsi1g5TMFaUrgawx/ae72
         xAptTBbEiePj7O+0G7sSoxzBm6KFGBEKX+TJRACDb3h7Kqq+O+/MO62lPTpNUK2M39yW
         sF3lFr4D9HjuFm2jEWzac4B2DgtEGpaWhMNi82TaNmmr2thwjyxKos1g8L93/if/NsWc
         GBiv8PfVNQVNHujsghI3wArlj9gVAS+dBO9e1qBAMuDaEKm0i7QPN2boH7eCVTbfGNP7
         qHWA==
X-Forwarded-Encrypted: i=1; AL+hErGwaG/Xlh7lFMkNqZYR1sDwDdcuBK0ymzZQDRPV1BjECUDve4f4RWNADuBhySU4NCLC4tRfQVU7jw==@kvack.org
X-Gm-Message-State: APuU4Z+4rlV+zi9Flq099IS/qrdHqXsr66szS7/olkH1dNldnhx+yUni
	DqIpdw0nox8Hoz7XG2MNXVBrMK9fhtuBlAQ3vYnRuL3tFPVY0Pnyr9LGqZRhgf6opW04fdwhKCy
	0K/NFj8v2+9e57R92UG4d2MqLcq2pTog=
X-Gm-Gg: AZFdTZeOvff+kpNb1x9Fj2b/tVSkfCD8ZUZPPUylAt308y421gacnndxMtdILIDGJmW
	t29byQjejFoymuXITcxk1I9CssTrzRQr1spSwjmwjwvf6lOLSynU3tRj8PUumguImSr92bkzmu9
	POf/ebvnz1wfdGi/JzSriSPycXyxh0+flCHnnzBRUtStAU2ZE26Lf0v7vjB64bmlnXLFSoFlQIf
	iJ1ADgEVfDBqmkkPWRNGqDhvChUTKL8MUdh3FDZwux1m3Esp+/nM2hV9gGsQzAlSEzGuJpP/H7p
	/Nj8pkGKgLSC17ThUbHimrPm6+tkrsEs0F6Wz7sO3m8AoKjOqYwKlzNeW0kePXTo0muwq9VOLfs
	dlOjuuGZ72txbF1RpqcEBkjlUnARnPnLM8t3PDKOmXvfMd8Jp/WekFQVZxpufu9K6F1Ljg58pri
	4AB1FgKLGcDOz49UrsyZLjz1Vk191Y4Gy4KJFqUxRtMY8O6w7tH2mC
X-Received: by 2002:a05:6000:290b:b0:4b7:8363:682 with SMTP id
 ffacd0b85a97d-4b7836306d3mr6416284f8f.16.1795562206537; Tue, 24 Nov 2026
 15:16:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <a74aca7a3d27333972782b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org>
In-Reply-To: <a74aca7a3d27333972782b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 24 Nov 2026 16:16:34 -0700
X-Gm-Features: Aa3M54rNAfJPEtIYBNS8z0FncYPJyb1XKCgONajpLzKwfERL2NRMGTo5_-rczOI
Message-ID: <CAKEwX=MJJVBfdE+LL-j+jwfkNP=OHaV21XLJxEOBv4XwsBLiiw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] zsmalloc: free a zspage's pages in one batch
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
	Hongfeng Chen <hongfengchen@xiaomi.com>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b8cfuwf3taoznhhzqarragjrnpi8835g
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35640140006
X-HE-Tag: 1795562208-437234
X-HE-Meta: U2FsdGVkX19j5Yl5+yjGO5Be3FvpLTx6z7M0oA2nxyKiSBHBY1oGnkNnQQnCSJgET1sVM9xv3lijMkJVR/OMNeFZAN11IuA75V93NORwr2sgbAIhBntiAimn8MGNADoRP/oKrVIohuDHazr/NfgdwLhMBj68JA6I+CoFVITUP7hxfYxHs1NiJhnxkxY5xFOGvzudcv6bieC57Xmbovak8hzO6Sok4r3ettYk9mSFX6sepYGeoFcej+/cN48/AJfUOxtq5iZwQ1YW0UaLLk1HNpH77GMYA2d7ROM3uDWGpLtUpmAn9Nw0b/g7JUs68psR3L7e6PJOhaoQ1YlBFB2Y/KtrW212iU0PWVLIGwss1vP1i+HeDu+p8eIlyAhG9tfPDQSed2WxSAW01h/H0c0tir9jhDtzeUEoYCp9yA2iXElpDTIs9xoPaoB443J8H2zuHivXQxTnnEiWi+SUmPNCymXu78t0YUkH9p0kkRzk9FUjPJk406L1vZ1BDjcH6l9IctchzUDPPzftlB3zAVfQFo4l7bNRuPwHrQBGPYEVK6l3EzSD+3xGxYzVXpbABOrPygqVYNxuS3nFLPF9xA5RjpNOPbCoDuwWjczqjmgq1ajC5hxztjFwlFFsYJ5fWLsPFMjYBfQLu6XTnvPnRD9wxOOhEDWbDQQge3ZxC6Ua1gtAKFxxM9B/lL6KbqAnqHChkSDGtJUwidCz31lpP6ronTYjdI1dHI81c/HeJ3o484LpkZQvQL7iyMzjZmrt2NGY+9TNk1k2elqCiNa7/BnYfV7lFTvuZIeBw3M6QfKbPdAUU4T2UVmMLg5gt01xiJVjCrcJizCR/bjXwwBFR2Uz9qR2kFFKUAIpTrvOz85UMYmPPjw5ctJNtcxvntpdewcwkygd6RZPO9axavhunQcfUJZpj1s9mWQSklcmXia2+y5LDZdStj5kTlEw73RlPsb1CgUlFzzD9EtAHDvk7Yh
 m/TbrmkB
 UBS5gO3P8Q0XPfWMXB6Qq4iL81lobF+xK1W4hyZY71kHwDtOAiQPlGgM0ZEUkzjDsC93DtXgl3rX+yMGst7/1FCiRg4doAwk/AxylxVOw32olRIIpszHroz+V2dKFOyvObYrBFJ9TebnqyLKr6ZZTuBdrtrZDum74/srZdl9cFttk3dI+WXXhmSCFtgeuW+Z15JA/4kRGRlvSxQ0LAoz/wY2QVCeIZ2WIRiHVCLFq0LeNfq3AF6qrHrYrXjfkZ1gwZQg3WH06CmY8gxfXdm0uq1OI/rYloNhQV1fZYnTppp4ZPjiib5gKI0WaMCipTpJeV3pJQg9UNt73W32NZc6PR+gCs44S3ZDLqgDmGLQ7CYIRClWVCJSSroV92sWLjqEWt9S3Ivs4P4JSk5IYtTRHZomlRpKm8xtpjrmTRW0J5b8UrRBlT1qnz5WWZ+DdXZaquGdQtiWhlegTGznFcSEv4c8kCDkS4F+VqY6iWoeMszwmtu4yBUvKP85rhLGtFVp1W24sG/WR8kw/ZblaNEdqkNf9+0bzpePfLYfKVrty51Afl9Wi4yoTsBLk2YKen2T4Eq7Qq0Juv/7BLaoNhZj5J1cPmqKo3LtDQvZTXERlrlOIITTH9KWFrDDQfaRu6oZfYK59quF3YAYUz9w+AhcLlSsizkWC0EsqICbdlV8CTZV/jpDLGM5v39sBx8ip33l+2Uc0uVDWq8u4TDAmrZYSqS7NqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 10:36=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> __free_frozen_pages() and dec_zone_page_state() take about 22% of the
> profile [1].
>
> Collect the pages of a multi-page zspage in a folio_batch and free
> them with folios_put(), which takes the pcp lock once per run of
> same-zone pages, and update NR_ZSPAGES once per such run as well
> A zspage never has more pages than a folio_batch holds.
>
> Single-page zspages, incompressible or power of 2 size classes, use
> the current inline path.  There is nothing to batch there, and
> folio_batch is not free, hence the batch path lives in its own
> noinline function.
>
> munmap() test:
>                     next-20261119      v7.4-rc3
>   256 MiB           -2.0% .. -4.1%     -4.4%
>   1 GiB             -2.8% .. -4.4%     -3.8%
>
> [1] https://lore.kernel.org/20261109105957.2577351-1-chenhongfeng0212@gma=
il.com
>
> Reported-by: Hongfeng Chen <hongfengchen@xiaomi.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

That's nice!

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

[...]

> ---
> +       zpdesc =3D get_first_zpdesc(zspage);
> +       if (get_next_zpdesc(zpdesc)) {
> +               free_page_chain(zpdesc);
> +       } else {
> +               /* Single-page zspage, e.g. a huge object: nothing to bat=
ch */

I wonder if it's worth keeping the old logic for incompressible case.

>                 VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpd=
esc));
> -               next =3D get_next_zpdesc(zpdesc);
>                 reset_zpdesc(zpdesc);
>                 zpdesc_unlock(zpdesc);
>                 zpdesc_dec_zone_page_state(zpdesc);
>                 zpdesc_put(zpdesc);
> -               zpdesc =3D next;
> -       } while (zpdesc !=3D NULL);
> +       }

