Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 715AFC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC766B0096; Thu, 17 Sep 2026 12:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F306B0098; Thu, 17 Sep 2026 12:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D016B0099; Thu, 17 Sep 2026 12:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 020806B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:16:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 342F1A5879
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:16:31 +0000 (UTC)
X-FDA: 85223756982.01.ADCB29C
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3F23D18000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:16:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A6guVt4I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A6guVt4I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789661789;
	b=chh6kZt+LZdmmRTNaSD38u14frCeNeg6vnAYjpHZxGY5kf7Qu17DmCunUVqwdxPFI5Zv22
	Esw3qu/gxt2G5r6+Zt3GCwR4VbxN4QFNtpQaRGLOOgVZbRrjLsIMVfHDDtAA3MKOJyMa2J
	KJefoiyMw4un8WAFTUk2trC/0uqYXE8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789661789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Utnj2BUg2wgBn65CQTDS0GpKi8jE06RpdxKfTfpq1t4=;
	b=zLzY6ognXjX3Rses+gVkt3n6xSTX3S7SNuM2EKq8Kik0MpxmpO2oxJA1aZKnh2xSPb7h9q
	T8gMFJ7vPpWTmUrpFkGI1NUjc376MIWMKHmNy9cmCFrOca7Dy7z4dwrlB1pm8cH1cG2exR
	qE5hrp7wNrIhifSw0zNvxU5AL1Gdtmk=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-91219376dd6so10640296d6.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:16:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789661788; cv=none;
        d=google.com; s=arc-20260327;
        b=ME/OUG6V/btnptN5aKPmRxgBXk4LcGYkXMNNv4ISb1vs33VF1kMUARNLljcMHK/+C1
         ExShvDnw/DzRSpL8CzfxUE7qeDDdNNcM5zlu4pPmc1r83nh10RtVh7g64Qjo/5KDYz4m
         xMaCeULORYei8J9r9xzpNBjuWj8YxbPOOV6MUE+3r0Jx7kj+D+IlFrKMJqcHqgMN+2/u
         0L27DYkF8B4htoO53Lzmrv8Sv2in/s11wHFliABl7hHLzB59+AnUjQjvGfr952jBtRTe
         IJNyf0apLqcfiwLoKo1+8n2fGYPLhSG/GJXGQUEAwaDiSCjthope2KaLdERo5wHabWVN
         WXjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Utnj2BUg2wgBn65CQTDS0GpKi8jE06RpdxKfTfpq1t4=;
        fh=MieX8wCahpVxZZjXpElWr8jrzpuj327fRc3tOoo1GGU=;
        b=hDy8pA163N/YaNGJE79lSG5iQyjPIiIo9T9k79tyx64JNYNcllH6z19L8q7MwCbxNr
         2npPQ64Xo+L16hB4P9c0FOELjep0C90e9TP7V3UCajOXwHDtQ2H+AOUUemINM+UwV4qk
         d3p/yM1UbDarEacOddSXj3dmnE9aW7oH0r0kYLwMG/5GHgRcBWs5ZnYA1dQcW/JFyego
         VYidEdbZG/inXBqW7ez1J0wNLlWdGVtlybsFPnIPyIZJQN6T/JVYc3kHHqSuqqqRErrj
         g4kQwygreiQX/u1ZyoZeX0JlL0vFabkcrWDZidkDcTQIwCFB3YGr3TA6Wx2vonscINua
         tkQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789661788; x=1790266588; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Utnj2BUg2wgBn65CQTDS0GpKi8jE06RpdxKfTfpq1t4=;
        b=A6guVt4IbWtePEjU4UlQJ0VbqEaGpNmgAAT9K2EguzPo8Pb2i//MaMlndne5wAKIC8
         6KGO/cyR6SOFQqmEulkpjIOwYmrL+8P/fquvkBr3lhuW/gLDhrwCSPQyZgL756SO+VIE
         q0MyNk1bmpAG+imUV2yxe/KuIB6dxCpRkbj2mLf6xx9db+rvjbq96zsOhSUc2BDKjKXx
         /3w9KLnkCEuAGSSQcCDcNVCQgYjXLLVDoEg0kG9qIx2AIjB9SMB+Dtgua90SJlOvNJcd
         c7x7vb7S2i9iGbek5btIpP3rYncsgZnVUFOlpKQhd10Hm109aQZmhBdTgjeO/pCM5XSY
         cRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789661788; x=1790266588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Utnj2BUg2wgBn65CQTDS0GpKi8jE06RpdxKfTfpq1t4=;
        b=n6UEYVO+WctOmQAiA23AyPNZ3QwaspDO4kiCPq4Qf4UCyiZLEn2he1bf3ywITaQW0V
         k6s29JU3FarPjQCq9mowtRS8UeDA0mRYWxUCBUfp7jdHK1za8iGXac3li7X06RW/2xCd
         g77S3H21s+OpKCt2PyDmLnO4egkCUdvHbDLcjxjwY4yJHuFoNgfyRjLU79TmIbCVIo+l
         b3DavgQdOSV2Hai+gyf0fm6ZzQ+wHMzJMoXoHPBcrGiwl8T28tnvtMknCxkGsc6slukz
         StmT8UvpUbpYBSpIgs1sYESdHWz4DLmD4odtJbFosnkskF+a2N3l/0fi9H/1//RV/Wz0
         ypzA==
X-Forwarded-Encrypted: i=1; AKwUvBzoiBXA3DSDyEIilzj8Yjz/9tjV2jjoHOvWK1N0k8DQI59jt+gflTocuZebq+CY5EdLvi+v1D8uiw==@kvack.org
X-Gm-Message-State: AFuF++kQ+v2XDJNesZkBE87M1CX1HSSv8AFacrDdBrU9zjUPKodzZcK9
	m8cJ/zRas04UR5YiE68Eo4yT3Qrr+tUU/eKj3Nf+DGqSKlspTPP/uyZf3TMnzSrnagQFgHsu3uK
	uEyhOx5SSeK0bTAlrO3wKCPDQhKAJUjXL6VBVUlk=
X-Gm-Gg: AYBFou2q2ZxZWduY+K029HeFKX1Be8thRV9AdJ0kSVWe23HuJNHlLqlRCrEwmTbeYKN
	umxY1bMVbNd19LVTGb7bTR/zQZswPww8+F7royCh90fWB/NJwumu5WOxKD7dUkTK7k+BzeZ6Ikt
	+N4zRNmL6AM6Qg0NVRnbY37kgixczmaBvKBiAa6d7HdJ9CMDGBTZ0Ri3Vc9oZsamI9BpuahLfjX
	5zykbuPRu5N8Dm7S0P+NW+ZUmakXUwRxqP+hajHYqf1+ys9SFxvjprtSsoZghdGLyjoCjITaWsc
	zZnL+uYqxpWhpKn36SYmo9RMzvakRBlOEK6PPAf5X+g+7TvFjMam
X-Received: by 2002:a05:690e:454e:10b0:671:4099:2195 with SMTP id
 956f58d0204a3-6716321104dmr1607824d50.26.1789661375920; Thu, 17 Sep 2026
 09:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260917150631.1138698-1-karthiproffesional@gmail.com>
In-Reply-To: <20260917150631.1138698-1-karthiproffesional@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 18 Sep 2026 01:09:24 +0900
X-Gm-Features: AcwNN1Uk9UpyoJUob1Iy_YX5RVhaLvh8gpmUhgIMopwOfP5aLXWiHdFhc1xctuM
Message-ID: <CABFDxMHjbQhzvrQmRjo_F9Tf0_zQ20FxaSHFEQN8nfN+VgsF2Q@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: reject zero sampling interval
To: Karthikeyan KS <karthiproffesional@gmail.com>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F23D18000C
X-Stat-Signature: bewrbgc6h8x5qxm6kucjnpcd7of1xo7e
X-Rspamd-Server: rspam01
X-HE-Tag: 1789661789-994963
X-HE-Meta: U2FsdGVkX19pS+N3fNvVdWEfbsyfjbIPczDZjDjo61dFonGTSPteqh8tq246nzWwg3/xF1Fq5OrJPmG0q2+uWiW4VWj7P9jstKkS2Zzx9Jp6OzQuAE0t2CGR3IqjUYeNUi2PPQcKDFrSc1uzZMc3GIVqj6W7vPK4Ra7oM5UwWHnIcwfKFL9Ytq3aN21jlCk6rDwCfrUGUdvTCg4ezWD4Nby0pYMvEUbHJ9hTURXtl9tXYHygNo1K4HcAmqnpEkgj1ePMgtFmBtOlwfWoIkRl1gq/zZsXeuCv0eZRzuSMo6K6PSuMi1qkAc6dnB9RARPdJPPPRqJn742QI5nnf5C1JjGFLGFn6gShrIp5BSRT5Kn89ZatxTqk/VW7zT0dCS2KxjHKRzsVrdJd3jo14AspVkCWtvGBjyTwb1oKdflI91J67pGG6z3CnolAxD6wLge9+CO/7SiUoV+KPvqO7ODlHtw3Vd9mbddwDm2/MMpvu5EknU8jRVM1gPLHwc26TDN4fBMGycassY1nUwEul68mgM2ge4Iv7R5c6BQepGQ3OWr8gSaH9T2c3Xj0qTDbSaIRBG439lfqK/w8TZJda8Wic9vlRY0PAqegNgZu1W+nVFOd+tRggW3MRC3Or955HVesDqZoAPc5pmLlPgN3Y577muPFRoOTmLJFKZfdg8ui7imIRYiyX3sRgIVwxB7hNY775KMMlYbP2fdVIMqLzOyLOMKtcSU2C8DC1VFIQqnxzrp2tHw+zsuzLGMhS6/WlvcJdSEJEU53QWeX/8EPiGeTRI/tFY+JG6B4HtrL/Ex145+iUXxk4XSxYTCwio6A9V/uKT5TAHSrJ5amV6EF5WvQ16mzIzwSdcP+w8o/HUM1WvvLg68uTx+yj1amPFRUuOLtwwTiuDQ4vx129HQa29UNgg3SOxK2cFgIp8PcEHtuB+HNFMpt7nl3Ok4+zHckwI7JKZgYM7FuFtTD/GAst5J
 +AAvUSCq
 X5S3843hgiKmNA4JaXi+NFKURZoReGIamO93nFgGDsL2dKCIpNwHLTzY7xyZ2WXsT+7gs8cDIRCiK1AbPJdaLm617i4i4ybhoCYJ1BDkf83nnyv3jKZJD3a2elXz0KBo6wxHnIZnlBcc+/VGOhUveVbKixzTBo2LtJZ4VPx+fDODHED1Vo9MqhpD5Lr/BmUoXCtT5R6ZtQlxUoKc0f1WbRLy7RMN91OG310MiPwbdJxgA2ixmxO9lXOHnyPaHqkXWoFzI1aecO19o/tI5Ewg7eLpPR3EVq6Ou4JjKNxUYlAfeYfEvMWnjyKbeMqWs2cNbocBa9M1ehaW6N2+svaAgyR8kBrs/VHaUkHACXspLaqPX0T7zy5HJ5Ftf/U1PRFp64Nd0bmfnkEhXc4jgF6O/6ivlsvcgyaJpzK86gFjf8fKMN/1LJf5TlxiA8mmjtcQCZiLswIhZ0jFwr5yeyqBdwlQq7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Sep 18, 2026 at 12:14=E2=80=AFAM Karthikeyan KS
<karthiproffesional@gmail.com> wrote:
>
> damon_set_attrs() already rejects inverted intervals (sample_interval >
> aggr_interval) and invalid region counts, but it accepts
> sample_interval =3D=3D 0.
>
> A zero sampling interval is not a valid monitoring period.  Sysfs "on"
> and "commit" both install attrs via damon_set_attrs(), so kdamond then
> calls kdamond_usleep(0) and busy-spins.
>
> Return -EINVAL if sample_interval is zero.

I think SJ already commented on a similar patch. please refer to [1]
If this happens a lot, maybe should we document or add a comment about this=
?

[1] https://lore.kernel.org/all/20260722094304.3132750-1-dayou5941@163.com/

> Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>
> ---
>
> Hello,
>
> I recently started reading DAMON and just found this one.  This
> change only tightens damon_set_attrs() validation, in the same place
> as the existing sample > aggr and min_nr_regions checks.  It is not a
> crash, UAF, or race.
>
> sample_us=3D0 is accepted today, so kdamond_usleep(0) busy-spins (about
> one core).  Sysfs "on" and "commit" both go through damon_set_attrs();
> one check covers both.
>
> Checked on v7.3-rc3 (238650ef6c7c):
>
>   unpatched: echo on with sample_us=3D0 succeeds; kdamond uses ~97% of
>              one core.  echo commit of 0 onto a running kdamond also
>              succeeds and it starts spinning.
>
>   patched:   both on and commit return -EINVAL.  Valid sample_us=3D5000
>              still starts.  After a rejected commit the same pid stays
>              on and does not spin.
>
> aggr_us=3D0 with a positive sample_us is already -EINVAL from the
> ordering check.
>
> Thanks,
>
>  mm/damon/core.c             |  2 ++
>  mm/damon/tests/core-kunit.h | 13 +++++++++++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 644daf5a1656..376c3e2cbe00 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1060,6 +1060,8 @@ int damon_set_attrs(struct damon_ctx *ctx, struct d=
amon_attrs *attrs)
>                 return -EINVAL;
>         if (attrs->min_nr_regions > attrs->max_nr_regions)
>                 return -EINVAL;
> +       if (!attrs->sample_interval)
> +               return -EINVAL;
>         if (attrs->sample_interval > attrs->aggr_interval)
>                 return -EINVAL;
>
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 4a536d41cdb2..ec8ef71956c8 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -658,6 +658,19 @@ static void damon_test_set_attrs(struct kunit *test)
>         invalid_attrs.aggr_interval =3D 4999;
>         KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL=
);
>
> +       invalid_attrs =3D valid_attrs;
> +       invalid_attrs.sample_interval =3D 0;
> +       KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL=
);
> +
> +       invalid_attrs =3D valid_attrs;
> +       invalid_attrs.aggr_interval =3D 0;
> +       KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL=
);
> +
> +       invalid_attrs =3D valid_attrs;
> +       invalid_attrs.sample_interval =3D 0;
> +       invalid_attrs.aggr_interval =3D 0;
> +       KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL=
);
> +
>         damon_destroy_ctx(c);
>  }
>
> --
> 2.34.1
>

Best regards,
Sang-Heon Jeon

