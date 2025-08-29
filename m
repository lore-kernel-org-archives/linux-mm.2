Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F967CA0FF6
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 00:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE918E0003; Thu, 28 Aug 2025 20:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6398E0001; Thu, 28 Aug 2025 20:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3C48E0003; Thu, 28 Aug 2025 20:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E09E8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:17:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1A9B140466
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:17:04 +0000 (UTC)
X-FDA: 83827879968.29.03CE4C1
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04020140003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:17:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LQcsXpsk;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756426623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wb1jMUXGb6/ItBoZsFy9z50zNJdJkY6b2JpW/rUsSoo=;
	b=RU9UD7iATZEBsAgAu+szmlqWiqYGgFyLmL4x1+dPzApwti0rOig8P5UKrQnsx8WzhvMsuF
	JtKSgGhi50Y6zf+p/TvXZ4p3K7V/zYkbcwTwrDQee/2DHuBETWFtmZNCY/zbVDFsOwYpB/
	kOP3ZFx74M+fSPRIwB2wmElWJhR8O0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756426623; a=rsa-sha256;
	cv=none;
	b=JWugJT51ctEDuvX+ULG6E2g4Zar4iZSBdgW43OmK936I/omrlCY+zvwLnmx7zMr98sJUkV
	yy5WyO4Td6ERy+BXahjMEGeq4oZNqc/yRq81WDxfaXMHa6qHRYDZmtYqGfj33zoh73wCFo
	J802XcwAv5ZBaw8rtmmOLtW/q97dmaI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LQcsXpsk;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e872c3a0d5so165256185a.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756426622; x=1757031422; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wb1jMUXGb6/ItBoZsFy9z50zNJdJkY6b2JpW/rUsSoo=;
        b=LQcsXpskC1E2fzZCJW51VeLpYcU7lJODGApyr994JXd/o+zcqZC5IVyYWlDJBtqKL2
         vsp8pPDGzbBv36GPnkpWUf4BRQApzNPW52X1tG+KQBn3SaQ563uvHazj4BNrzFHwIamA
         4ySMChbLdt1CQwk0F2m/5C7TTSzL/lZjFapmN+0f14wDG4SBdfNTdV14ka2s0haL85h4
         f+BrUI7k4LvoZtJ0B2lWgLJLPpEhq1YSa3F1nrn4ZqM/6mztWSrficHoVx8xZ2RNcrf4
         wOOs0qzBl3e2AGPl9UBKBaY02/mfzBoMCznh+tT9F8h7dR4mYGerRzal9p6/5thCNmFR
         JLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756426622; x=1757031422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wb1jMUXGb6/ItBoZsFy9z50zNJdJkY6b2JpW/rUsSoo=;
        b=o+bx8qQmTgafkWSfLqKGPwc77CsImpsYcZLOKUiwicNilCerYsWtZgJJkCk1/dGTaW
         GMMiaeQh+ljWSbtvHIisANsaU7Lo4ClOUI7q9xVUK1OlVf0a6ciPrQoF/QP/Cw5di5y3
         4irqiRhrcCIpKJr9CPeFu4HufomcogQpTbq0Vm6HnbT/kqewOJKkYltyXbcIA9B+Ooc1
         MoOHd5Zq/HzuqGKqScFqSj1LHYslqrv1HF1jGqLsHs1ngWMeAizjhi4ixgC4xDC3iDWG
         9xNXBR9rdLjfhXm7W6tcyC5BUPQjSqZRUy6YCt3XUPb3XtU5fIUDysrYAYvxqKmVO5kS
         MMCg==
X-Forwarded-Encrypted: i=1; AJvYcCVg2gREPEv0aX6orQ4oNGbj+gESyCDeN+i2xkT+tjac07Kd6m1s6/5C2v+shry/c5Qd8hoHkPSbsA==@kvack.org
X-Gm-Message-State: AOJu0Ywoo4bBbA3nSMnz5i7zOKiwimFaVInFv8w2bfLzVycYx1vUtaQd
	pJN35iCvL87ko6PE1UURO5RooDMoNuiSTWJNlZuQO1WMoeso2WMQ01rYvsnmzkUEnZJdYbsi2UW
	jrgL8nIWdBxmEGIPM1zPo8bouB+4W7aE=
X-Gm-Gg: ASbGncutXzXBSwdMgk1mPtKvWYPCL+SNd19fp+kxHeN71edm2GeFO1Kph1KtQERVie1
	fVSy4IZ/AupZ/E8ZyR8mLgwJj4/+92ZG97djRzqa6jHw9VgXVKwEaF2C/sO49EjGZP03nrBuoW6
	kg1Pu0uVEzfE+U2g3JJ38MqFVleIV7u6M4n+HJ2vdQ7El+m0/Gzu2oH0WIjCfngXBlvyxvQ8Lwc
	0QDLqM=
X-Google-Smtp-Source: AGHT+IGQKl+/zd12XCaC1+Qms5ixirA4oJqGGhDKEW/cxCJbRtH8rakdEL2CHuZDPUKYY+4Tla1xYBAgtFyzgH1jJxo=
X-Received: by 2002:a05:620a:4410:b0:7f1:7f01:9a3e with SMTP id
 af79cd13be357-7f17f019ca5mr1925740985a.72.1756426622000; Thu, 28 Aug 2025
 17:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-20-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-20-kanchana.p.sridhar@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 12:16:51 +1200
X-Gm-Features: Ac12FXwfAjOO-4JtlTJ0PGYlVUAWZtUILQp063i-tfGCeSFeBU9jVKtn_v69wSg
Message-ID: <CAGsJ_4xuMEDzX0z-oEyPQyb+jhnytfrfyASKxwR+5XRzxayJPQ@mail.gmail.com>
Subject: Re: [PATCH v11 19/24] crypto: iaa - IAA acomp_algs register the
 get_batch_size() interface.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04020140003
X-Stat-Signature: jx7oceuo18fqi9o4ztm3znuy1uejxmyu
X-Rspam-User: 
X-HE-Tag: 1756426622-27849
X-HE-Meta: U2FsdGVkX1/dND08kOBm3PkT7BLkNcQhuR1Rq/f3RyGbGNwgRonvbesEETkH55GyEYwf4Un7+hutmejchjbczj7XynIyEhLVmNt6nAhMMB50S1lCKhgK7HgB4iQ0N3CnCwDJ+KjGrpcfhsXaJNMJunGyYr8+Aw7YsyNkley191bYr7x5ORIrnkvJLfxqazvqLfmhkp20sgHkvgcnfUmtG+2knGptNHNhLpLZ3Mjyv/umdJGsksROZLizNGq0ZD9+lRfJNhI87aDXm50ZaUWQZjQBkUH2/XkE88JGheqO+cphdLsEMOlu98lrRX+l1EItb7dmwrcYxR+hR3sNT2t942IBWRbu8PS0cKWqhvfEkYsgdNFUL2XEfHLI8pOjrCRuw4DsOd13bvEVRy09dTHnOfYcXdmaFmRZA6leAHriKSs8bzB/lMIZC0T9ZSEsa1vY0x9Fi3j+NahFF1ZE19KYBZkWe+hxlJqzoJO9P40GOhE5xoKhwzx1EUtc4j8iQc6FqAKFcE+AOYOYXcGs2bmUXyy2fP/fzQI3mddU/b0d3eEiVjvjup5f+Xm1oCAsN2GcNjbfsAqXZFu+7ZE2kLgsIFxbbqsG1LIGmiVDeDgsjgQ4CU3qLfEZ88VwpG8D6o0XscOtmflIBggWJLU2r3CsRg4Kbyte4bRM81cJNpbiF5q0EVVxGysPxvUy0xKKSYHKu1s+IVk5C3iZ2c5U3F6Lz75FdrWOCjot4E1gkxzEfNE/p9HXIuyp6vrsBsxY3T3FNYgJSdglUDYxEpnocYLaz5IxcTaRtbxihVcLfGRMeFbXwqEhwjVJaWDtYYjXSkuMZvJRKNgg7hFHyxbblEgGq1PupN1YsQ7aQpBVr+E2wu6rgJ3J2R3PxYMedGcw8o0g5Zj0+7NqcLr3Z1NQitMEQj/+UncV1db9dJ85G31hboInJJXkp/443S86VBzilQIoG9eWTG9KqR4lP/y8Fht
 e34KLLJY
 NyxFYdoOC1V7kTribi703DtjY3iTCp3XpQEEIspkbx54nyvfg1vTzcrhiBds3YXzcjbpP2vMTm1rU4Wt/O0EB5bgYcm8I4guKBh1cy89APHIMETlJhZafKgIKWdkOMPBTuJI5qXzys4/2jBUon3t2y03tfFoQpxJOfW2FyiMSQlnSdki94XG1Bg2QQCMWbzICNnPTicX3BP+Sp7MLLMOZBIKV8W9AYowmoqbz3pfqZcWvAfFxqOqJ4RifG2uHY3sJGGF0oB3L5hvSrmLB27k6TTSNVr1MYqQsbo2BGGO+nqYRD1STzwaWNEgnwyvrjH5gBVj9mcxUnh5PjXnzOaNVnghKp3dcIkO2o0zmVurnTCZXeQpQnNx7fZiGJic++HVdUyK3cPBuEwlGvAzvm+3WAYg2MJ0E3S4jftfrZA1wjmAknZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 4:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> The Fixed ("deflate-iaa") and Dynamic ("deflate-iaa-dynamic") IAA
> acomp_algs register an implementation for get_batch_size(). zswap can
> query crypto_acomp_batch_size() to get the maximum number of requests
> that can be batch [de]compressed. zswap can use the minimum of this, and
> any zswap-specific upper limits for batch-size to allocate batching
> resources.
>
> This enables zswap to compress/decompress pages in parallel in the IAA
> hardware accelerator to improve swapout/swapin performance and memory
> savings.
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/=
intel/iaa/iaa_crypto_main.c
> index 480e12c1d77a5..b7c6fc334dae7 100644
> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> @@ -2785,6 +2785,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate =3D=
 {
>         .init                   =3D iaa_comp_init_fixed,
>         .compress               =3D iaa_comp_acompress_main,
>         .decompress             =3D iaa_comp_adecompress_main,
> +       .get_batch_size         =3D iaa_comp_get_max_batch_size,
>         .base                   =3D {
>                 .cra_name               =3D "deflate",
>                 .cra_driver_name        =3D "deflate-iaa",
> @@ -2810,6 +2811,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate =
=3D {
>         .init                   =3D iaa_comp_init_dynamic,
>         .compress               =3D iaa_comp_acompress_main,
>         .decompress             =3D iaa_comp_adecompress_main,
> +       .get_batch_size         =3D iaa_comp_get_max_batch_size,

I feel the patches are being split too finely and are not fully
self-contained. You added iaa_comp_get_max_batch_size in the previous
patch, but the callback appears in this one. Why not combine them
together? Anyway, since you are moving to a static field, this patch
will be removed automatically. Could you reconsider organizing v12
to make it easier for everyone to follow? :-)

Thanks
Barry

