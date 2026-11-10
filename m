Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1CA606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jal3kjoU
Received: by kanga.kvack.org (Postfix)
	id 4E2CC6B05B0; Tue, 10 Nov 2026 12:41:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470356B05B5; Tue, 10 Nov 2026 12:41:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334C56B05B8; Tue, 10 Nov 2026 12:41:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 070606B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:41:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8332C140A27
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:41:01 +0000 (UTC)
X-FDA: 85419925122.07.1229DFF
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 861DD180003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:40:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Jal3kjoU;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794332459;
	b=vjExyZS3smbUFA2qsjHi1R3iRHBIYMMuvx3Tbnptv38uLQk8ghGFOFTbnIj3vucVxjOgxi
	PH1FFLSNenD9fnQRw3pHhKFzBtx4MENXvQt28RhfyWavovQMTDiIsmaevK95esMqGa7oPF
	Sm/vAfGq1GtDl+ijDt7lELnIknxo7EE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Jal3kjoU;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794332459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgcKWslE/fvIIVroU82DW+IQYjBmplAQL93Fdoq2p50=;
	b=6JTi8CPKUQi4TZIbK6019MoAD5krXhziJbXYbtMeBb7nekKQM1Ub4LEtWAdD0rs3K6M8QQ
	uAn3ktbWarUpoB4CCBMuHLl3REu/JKd9EVZH3se9X/LFYxsrs8qMK+QXV3KfjLKbxF9+e0
	68oOl6T57TZVqE2BATHppfhpIBCxXDs=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5c14f3dab0cso1756343e87.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:40:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794332458; cv=none;
        d=google.com; s=arc-20260327;
        b=c0gQV+JXVN1168Rv05J8qB10ZDLC5O17pOQ9uQ4kx7GSmHguWjnEZa/ISCTwxzzq42
         35mAaaTMxE5ui2e15+DB+ofZrCq7Lq1PTbJDigzeedDVqpjw3xxIiMcoGxLkMnLxTyNb
         QghRLVAcStVku0M2kjP9nrgVz3xQDZKLnelW12klOGXETp9KfSAkCDio2QLbapgx5Mu9
         dvEPQTJGufFXR0b8vVH1UKvRF9jfLv3rp+rVS8mCe+mP5cync+5PnVUHvQhsLeEiY2fL
         Wxn4Q0oGAYVVWvaszcquiGSJ9oxfYZ5LdOMyiMl85BKDorxuGJmjHu4ulcLu1NxkWn1O
         P/VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QgcKWslE/fvIIVroU82DW+IQYjBmplAQL93Fdoq2p50=;
        fh=7P4XXX61oKeZjXEYBPA+jLTElUkt+VTSy/ZDSeLnGvs=;
        b=jn7uiw48stQ7itLKyFbylFTTr6BcFe4AGKbiIRScCdxyozcXhy+P4UN5XkqW4TyHnN
         k63FUhdubNLaK308Y3SMP2gdFUYYNn8tzRkw51E7w1mgpKwntbBrPNYHgjE6q3ECdaL8
         xP1llw7+5Budwv0V01/90g3tTIG3omS1Hg8XNmoHCX5OkHlrpI13Bemn3AUfJO2HLh6D
         Ol5wtKKYTleYEmi5aWdKQjHh9yVHhB01lNSrYOo+QQfhzTFxu//IxWWG4o682fIvvn7i
         GhxVJYVcDVPsOgYPKO43aFmYhgoTuZmjrSkYeQ+EeENyI0zSCibECso09n/lCIcc+Du3
         fyxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794332458; x=1794937258; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QgcKWslE/fvIIVroU82DW+IQYjBmplAQL93Fdoq2p50=;
        b=Jal3kjoUcn8hfVl+VL8oVzFpCAjfZxyujsMo5sFiNMyObmhqotAGrHVgfZj0Q3NKn3
         WXagh30Ay7ak9UHqcQRihFJhtgm+cpCAUJlg5ilw+tK3Ewwdpts5QGaRzhSGjD2h6Rr/
         is7e4Uhx5JlX6mdiahj4EqHpHeW18jhRIb6eLEn4/+VyTuqp0vdvnNPz0fvANw8zqB5s
         7pZT4yHlNeHS4dvcGXpeEcebMSqd7U/X+iuEFDwUcRi2DIo6AzJabq1UsND5i2mzCz71
         IpSm3v85ZEgsObYTCoCaSlPEze+/U4KXA45+guXiw9gFpQGKOBvYrwruVj/rY6MOXqtZ
         parQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794332458; x=1794937258;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QgcKWslE/fvIIVroU82DW+IQYjBmplAQL93Fdoq2p50=;
        b=lEVcg8gQgack2vZrckdl40ZIcAWcqEY6cuATF6O+bFmBX+6PfCclEdG83ggDUbNlq9
         7KH1xnwQASsQ8xBcMqKw0cX0GaI6IrQ9nzwkf1a945tpZFYJJIUfwDGTj/AzIEs5dOHN
         Lzaz66Ofn7Ada8b5FyoMyqHrv9GcvCag32qqjpkvM+hfONmKxHEWrtFpIuoRIOeFrJ8u
         /LPKvN3YSSHhwwE/HSDX7R+brwlTbxfIGZJG2tvpE64ynqsSCmnhJ1cwD+s+Lp0oAzo+
         /HWsEUIXbT1YBNBJuqB97Y6jbnQsGfCPWnwCrTqvhpAKwb+sycXrIV0MAJqXB5mM9Q2I
         WrvA==
X-Forwarded-Encrypted: i=1; AL+hErHY14BdT6HlRIXO1BhDprqmFAf2ZcJA2CKLXWvTxvdESzdB8nNFAaUbiowU0AAyHm7zCXBXT6GIfw==@kvack.org
X-Gm-Message-State: APuU4Z+w7KgxNz/xlRWJ1EytBLDcfKs1ZoYDMPtBZxgMJVB/OhPYmxfa
	p8mm31LW/9qHdDu7yzknf3kn8B60bv3t+GyutrzeAuoHwEkruZ3bvqRA9GjHTrkZRgLxK9oV9Zv
	NhK/OQoOrH/G5ZMDKi2NFAnQxwguoc2Q=
X-Gm-Gg: AYBFou0YVZWEN3MOjSBb2mV8CUrQPmFdh4p3RAsbDgk9p7LekY9aYb18W7Z9G/+XLGT
	KXrXx3Lkvzs05K1/8ghjAoDD5o9Q9riPmtWICT9ZXrU0LKhitwfuYnonjaEZXjAiAW7NvFhFcoY
	7ppaO/GUe0BF2KUZ4N+zV7Y5Jo4+JIa88Fy+LsS21qPgefjo1iXHZiGKCS4V+hmCO5xvPpUASMk
	+SSIAPXhkw3ctF7tlnBCi1pThQR+fnOQIBgKcN3gdUtQh6ziUiJ/dkNnbcNE9GuUXU0xpXp0ttt
	69r4nhmuQSptncrern0b7G1do9cVwUnOX7OB59Kang1AuxzUqLBQry43yBvXJ4HSvET/nO3Qou/
	qMULmSU26T0Yqx4JdzDfcMCXDXHq7xyj7wa5aHB9c56h0yzmfNpmLEQjaT/flcUytac2m4OmO4B
	x3hqcDoTWBlzWE3Ww11rxM4EZT9ZNaKBuNo9HSRCfDOOiQ8oM5Rw3q
X-Received: by 2002:a05:6512:1256:b0:5c1:4bbc:45cf with SMTP id
 2adb3069b0e04-5c156ed1806mr917830e87.48.1794332457809; Tue, 10 Nov 2026
 09:40:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110054836.1515030-1-senozhatsky@chromium.org> <20261110054836.1515030-5-senozhatsky@chromium.org>
In-Reply-To: <20261110054836.1515030-5-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 10:40:45 -0700
X-Gm-Features: AclHuK9g-rt6zF29XhO_FN13akwxVP6MwcYrtYAv2oyltJQHd3ALM1tNti6L_YM
Message-ID: <CAKEwX=MWLim2q7RaSchFRZ215avMfW161hKAKhxs888NgRRMOw@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] zsmalloc: switch handle type to struct zs_handle
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i913g8kdsr4kjsnugd469n8p1k4pftzu
X-Rspamd-Queue-Id: 861DD180003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794332459-589266
X-HE-Meta: U2FsdGVkX189QAaW+oTOunqvvoOkpopUBm7INgERy3Q2oKAzYEX411FmO/cR41kWdp11zRfTph3doP3/G0IA3ospAl/YB83t+KCYTDLTpoGWmTX8TXmsEb/2G/grjFDcQsIVsc4iT973FyMpHCUmM2DDXldSobP6WhxkBkzHv5r5CM7SllqZzsHUw71gjs4X0Jd02PHRvkcd7l7TV11R2wwz5HdqtiOEFpsfsRafmvxZY/JxZZnoK+7sc6y6WBVaLN5OqPumnJbOx+qiS9ouOExsrwMEgC5gPM6HPcgwB+Boat5k5F/GXdKMnCsmcX+vvYd9gvjdNVzBrjKOvBOFpvRtlW8FGucXwVubruwSeOWzj7/YEfS36ziZpJFM4bzNpAaK1d7Nl0CFcW7MESdqE0575flE4hsySDxWINFeqeVxgaqd8KNVuuzTamkxjpCuu6kSvT+C7u8zeSO7CJtyzLDpmZN8296OeZJTOaeYmb/DAoJvv45plJwEMonqnCoiD+yedvyVC769SjzZN1n9rvhN3Ojmn96vjXRXJo2WC96sRAqvuXwg8v+WVBKLUDT62Sv6ttzIqxUTtR+a4XgcSc381HU9wMVcPEOL/dC9j3cL+/tTa/bsapOpLvYKhGz49JQ9m1KcC1/AyC2jEVx4xUhAJfe9XBaPEmqjwDVPSfj11pz39w/sVbE22+saAzn0K32RtWLALDyfdaHpUBmQUkdkp5vb9wHW15ijLzNSVkqXUwykMVcDvFHvakB68HoyArMYBBCmV8877eJXYrMNWH+saFKK7dEuFGYu8WNsioWnsSzs4w7LxG9OlRMf5lMXe22i7cIAhSCY7OqwYUspj6AvBg0I1yBTxviVdUueBjap0seE8/IaS9G26tjAAVNsMwvw6sGsUO+jOtpMpHYqOEpbif380fP+cP9lIMzlfW6WC4hAfHnSVUaW6LNDaP/6vijCYo4xfOe5LU7jUbd
 XghVOI7X
 XSnRf6/WwGOJD/UQl4EnatDUxUV4vq12tjsT+8CUf/v1StJpL84xkFoYjZzJ26wQzjrEJCZXCsU47XjmV4b5hRwkjNbMRkGXNSsAl85BUYdxW0hc11GQJQ9/+fEswqOhXj5+k+4aD6Dqo/5YvGMplMYJwlTOM+5aSmzcGHkTfKAronLdRt6mG2dirC2ZwQNboJxaJ5JwdfgbXJrjhBDYpaWxXDA+hFVIn9HvaxLdxPZxbF/4eda7pPC6j8G+0fEJYhT4cZDWMS3cUATN41nVQ+R1HJziYtW1URo2IK21/lLbXw3HniT5CeFwJctfkKIQgwrShQXaYarWQNNr9f1+bYIwuISc/WkCVh0KXwNnFjpykXD5XlCPgC8jsnyn70uM2LPYScrgNrLo+OjzEfyeGTBrYZO39nG+UbzcCyd/hCgFA0g6klfTRAZsGVct2xNSgtlrJKbd9MtTcxmQp2Zf1qGIYHH92dFDqaI3CmZrnKGurmPXDT+ksGac6lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 10:48=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> zsmalloc handle is an unsigned long that holds an address of a
> handle_cachep object, so zsmalloc and its users have to cast it
> back and forth.  Introduce struct zs_handle and switch zsmalloc,
> zram and zswap to struct zs_handle pointers.  Functions that only
> read the handle take a const pointer.
>
> This is a preparation for embedding struct zs_handle into zram and
> zswap entries.  No functional change.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

