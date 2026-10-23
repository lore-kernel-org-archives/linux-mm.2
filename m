Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D21606A32F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=wOty8+v/
Received: by kanga.kvack.org (Postfix)
	id 62BD76B03B7; Fri, 23 Oct 2026 13:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FAA16B03B8; Fri, 23 Oct 2026 13:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C30B6B03BB; Fri, 23 Oct 2026 13:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19E546B03B7
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:06:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FBC01C1F90
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:06:28 +0000 (UTC)
X-FDA: 85354519656.26.14556EE
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 771E880006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:06:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wOty8+v/";
	spf=pass (imf30.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792775186;
	b=PmK1Rh3zbDoyxG6+CbO8r3t0uyCp/TeFXW7Kbd4BV0k2WQ8An8iVjYM4/USk+uMF7HYEA4
	RDeUchksu416J7DkTzSePmBf8gmVoOhPdeJs3aO5UTNfxzkDvJzuzi0f3NcUl0FMJEtBGB
	HWoARDgoIEnl8gZH3i8fs9MncDBnQOw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wOty8+v/";
	spf=pass (imf30.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792775186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7W9Fg/Y8TWqaQYuAul5Bgmvw4O5gOdeksViXJu/tFEM=;
	b=KOSXKdFCogxonQPQBEWcG7EaCkGenxBcWwgtsdmTMtpw21frFY0w02C5pjSrm9DDSojsXD
	4GbO4bMnVCQy/oNNzKP325uClnYCVT38kMSHmr2Q6aMMV+d23FV9X3bswmIzyHzlbmhfbc
	yynrf3XwKB/NXjowN6v2xquLZkKC6Fw=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5337fa12431so481cf.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:06:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792775185; cv=none;
        d=google.com; s=arc-20260327;
        b=hf7sCC7u//iextSDSKH/X9MQUVZtw5slGngqUPrwKz/onMcxmYPIY6b7tnd0CMdhzj
         Oqv4IWcZPlvQvhwNmzZ0JsxVGQEF1hyMQOB9rpr6ZjzE5G5nFYjKE6h3U3UkXwjWjCsF
         rmLEIAWa2Er9wZ59gGpF7xeGueXlGCTGsYv40cK7iGgFq8a+HrP/LaLTWb/8eyHwBuhv
         UOir2dlaD5qaKHK5aK/9398BwAMjduVyt3UTlAIJnjX6m19QP9vW58CTKg82beMyTI9z
         HDl11wzV1+Ltvq2H+HfQl7cGul7zI+MIBMHKnh+VTV8O+ioJeXO3P80K+xoUsmGU4vwI
         Lb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7W9Fg/Y8TWqaQYuAul5Bgmvw4O5gOdeksViXJu/tFEM=;
        fh=TGaHUbvgOIUBVrok5vBwvCIUMIlsfiCTJqpEYyih4A4=;
        b=h86khTJad3du4HUaFnCvRjy1uVx3xlQiLH9wKE8AqZLJdNuo0JieZQCmjzCnhgogLN
         axS3l6DJF6OKBy92mmTT36OEWtGSpy0mN/dLui6+zpAdEdHGUkubAtFChPelPaQ9jTAU
         WvX2/iQPHz3ENOHfDE40vbiYVFDnBC6RC53noZNzCnP6B1Tjik3EwOYK/P16+OJThalo
         gqx6a4e1jPF3ix1D0Dh30FcUULmeT7ubaWdPkSy9pS6kbD2GBqZnDBkrUgwnSoWw6Kv5
         kUJapL50B+HqEI7OA2K24XYX4UJ4q1X/xnFrSGgGOECj8BoZaKI7XMetwWe0t+XrtJxW
         0o0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792775185; x=1793379985; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7W9Fg/Y8TWqaQYuAul5Bgmvw4O5gOdeksViXJu/tFEM=;
        b=wOty8+v/LZ3YkrVWZSOph7cSdlr84y4D8Pq4awtYk2qI/qAILyRh+TwkEObM2PqA5T
         Cw5jbAGvoXb6Lvsyxm7N9o99D3HKQPT5RBocAC5ndy75m7MxhRywzLCye3Yi0o5Zzd7m
         dnN+AkrCpSy9NFZc48ovBH4zQon4D4tOiheKMBgQ9G2ZQ9LUprjjuOGxPO4PwZTkiS1j
         BcEiGCcGNNkkxLAIR6eUJyLPNjaeqiDEwunT/2wu3BgimKwYw3Y5lmZxe9LbHnWOFomE
         NaMwE9b9tA8GwmLU6zn7NK0qFHk+7eKPcRk6UCDzSVffX2GNtLVeIOS6wRgpEisZX+Ur
         eq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792775185; x=1793379985;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7W9Fg/Y8TWqaQYuAul5Bgmvw4O5gOdeksViXJu/tFEM=;
        b=xf6qWMAB+2R8Yvqa6G4vNyMi4eiMYKLRtsVA7yu7GYPmbvnL0ldBgq3k4yDx2YNttW
         9RtaWn3m4/VJERj1bW3RTaZvJvmon2nB5z+ujv+eZIlqvSnnqttnH24ZCu3S3H43Qjez
         bgmMnrBiEoOX2nrk/j62EV7mIj73rJogJafrkGAmiztEa5JEFGyIDencPXkcCy0b2ail
         6SjyiT1oMnIoaA01cUNolEvbL8mCwAgjFJ0pHgXmMsuEBPXTuH2+dS/jRmYKDXtElkKD
         Yk8p5+kukiZm3VNBCZU+YHqLRzmAxxFIatX+a4/sNpaIBj0RSHfn2huGV+k+Lu9/p7Y5
         Ot5A==
X-Forwarded-Encrypted: i=1; AKwUvBzNtRqG4J4Tuc6b2JA45lAPTLsV5cKe7tlhw7fpeWtqX8koI+J7yEQskB8gWYtathkoZLLeTEXl6Q==@kvack.org
X-Gm-Message-State: AFq9FYIzQeddtlGQ7gSeK7+mSwzsiapSnzbYgJ6n2LzsqbzV9kr5LY4j
	1oBFYIo24KR5Xq0kvVTUE8y5UP2vfPpTEvFh7Q+YmFnrDUa8RvSCr9IrA8vVP3wYyPEPN7EJH1j
	AnA/hHFYyVN2g6OOW42ueyb/tjI2QLX6hrhggCpcQ
X-Gm-Gg: AYBFou3E4ZWQYGBhB9FtNqjW0a1vu7TTzJdxkp6yQQDRbAWE4I/PeKhDWpsWSJWc9D3
	x7d55gWhSl7J5/MTAipGdfxBmp+UVUKqw52Vc/CaSB3cYwuU+dy2Wm4axVK9rUpaBC9ZO5Xt+OQ
	lWErJ0V3czE50c9depU3uFsyt4wSND+YZ6Sv9LBQzI5Dk8DSglsz5iQIPGKxUKzvBdoUsuhErAG
	7bIlGTEA3u5DDNv4H58yB66ec2MVf+sWnxPhP0GAD+euveM1rgbMMMpZhQFSb2MUT/6hc75ug/s
	hJ8Qp0bGUItlEkTSVJ7ZxJdiixL0/Nb5XrXMgecp/Hw7cPiQzMDeyI/0Kuqb2HY3KChcXnLfIEy
	/phcRfLryZEGENKJRrsHWNhu0xNIDaaz2WF5k4eQFhUu0v+RNsPkTbrHG1MnmoCNfVTaPxivRUD
	6Bf4HWkFclFNCFX9EUc55S1Qa3bLxKqwPES3/VShl8DWaKl7X8Aw+R
X-Received: by 2002:a05:622a:2303:b0:532:9220:a9ae with SMTP id
 d75a77b69052e-536c281537amr19657921cf.6.1792775184544; Fri, 23 Oct 2026
 10:06:24 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021024236.1787884-1-senozhatsky@chromium.org> <20261021024236.1787884-10-senozhatsky@chromium.org>
In-Reply-To: <20261021024236.1787884-10-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Fri, 23 Oct 2026 13:05:47 -0400
X-Gm-Features: AclHuK9aMIpm2VNtMp0HeDAF-ArORfHFJxKzdJsO6LgPxAnViYSqmcSilR02eGY
Message-ID: <CADyq12xeONu-+YRP79KaH4XCsSrNK5DdoKw6T5YSEyW7Acxh7w@mail.gmail.com>
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Bo Zhang <zhangbo0325@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 771E880006
X-Stat-Signature: fipfsobyzf13rc4n8jkkigi3owsxku4z
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792775186-705845
X-HE-Meta: U2FsdGVkX1/Yugl/MbYgYk9/H/6KkwBpWKZ3zbMzsXLsFcV1GVfhJtT1dJkXpKGNZtKqqWs5V/P4sdW7aMy539zBKw51+WYOcrjbP1s6NKlphx9YTKgz8aLfmiWLZSYxONbxdqZlUK900WPtGaEmEjhuWSgUTzvrnhLrdGpEFRDNvRijWi2zRlKr83yq+vMmU6gWKtqcFNf/CMg3MhCVDXVYRUTlMq58G1dOjIMO9GzHkfFGpUalGNlTLQq4s3Ja2q8vsWPqUzH8+qlAK0U5VLzvci6V9MvjehcGZ5pwnrlaKkPEyMmsfHjhegFz0elfJt4iXO4zBai2yhPL2ck3u4NNndrEAKSAMEJ+ld51dxJ6/BP07zvzNo6xwu76szuolRje+h4xOTuKwqBXWvuf8T57qH667wWwzGYVuaoIzKda4pwv+qzv73C2Tyjm2rqu1C3gEzrZKqj1Y1TCCP4zZw83FS5MhltZfA/iMYNHj9aovXMLfz/dCmsVBnWKL2SPO5acwTdOYgfqdGuLeEhHDQTeh6IVWxfRZ/zEGevI73DJhj/wcspfmwhinBwxrNhQt5PqReHFpjlTPvrjkncUnSpDu/0dQAaf6ZiS4jK6XpxNRgVmAumk6gz3GR/XrKl+tCzqpe6WRcg/g6XYOKuhtSqibWYPNsjqP100C544Scsh6tNPQ0bpuXz1MRjMAeKfSowdUqoO8FXyz33jX6/Wb7gRlSSpVRB2QVmNcPN7cipL6jWPsZ1dOOL1tUpR5AEEQ/LprAwc3QnqF10Z5tM4yCJl3MipTmX9Yl3y07RideUNAe3gXeq6cLUXFC4xLvNM3qEIVnnreGL9bS6GEMujkjLGxY+xOK239RtrDShETsrlkhgw67rZWXv2ddlXr8d8ak3P7le1DHEaBA99pcj73/aPX8TmVUjSu/m0J9GJkNMpUVKJ40EVNMr33RgTenqh576JzVCgrEjAhj9c+g0
 8w2EK5wM
 eJ6mvrOLwEf18gTyDmqwxDQWr8sNJGdoRTia4bIdlHPc3W7YIDRbs0TAkozesSUNASYQMe0tssPk28330gxuiyck7mPAseZhupj2pl+i65g5kyuy8p+2VogZ7EefjMI52hanSOOkK184xQTaEmfNWhzt0zE2qlBOQl10RS6Uf/STvu0RTyjXb3mavx8LUwVAI+9taNSuEDGQFne+VWyHlQ3YwwnJ1LIc/dfZyy1nZ3g4zTVKis2A5rEPNXeD6ezB4RIMURI9M1+iAlwcft9MeV79B9ePtHGBFqZJLM2+ML4miylau04O0y0wRaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 10:43=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Split struct zcomp_strm into separate compression (Write zcomp_cstrm)
> and decompression (Read zcomp_dstrm) streams, and split zcomp_ops
> context creation/destruction into create_cctx/destroy_cctx and
> optional create_dctx/destroy_dctx callbacks.
>
> This decouples Read (decompression) and Write (compression) paths so
> they no longer contend on the same per-CPU stream mutex (Writer vs
> Reader priority inversion).  Currently, a (low priority) Writer that
> holds the stream mutex can be preempted by a (higher priority) Reader
> on the same CPU, which then blocks on that mutex until the Writer gets
> to run again and releases it, which can take a long time when there
> are other runnable tasks on that CPU.  The good news is that Read and
> Write contexts are completely independent - compression uses its own
> scratch buffer that decompression never touches, and decompression
> uses its own local buffer (for spanning zsmalloc objects) that
> compression never touches, so the Read/Write context split doesn't
> noticeably increase memory usage.  In addition many S/W backends have
> stateless decompression contexts.
>
> A quick synthetic fio test for Writer vs Reader inversion on 24 CPUs
> (preempt=3Dfull, zstd, 48 low priority (nice 19) writers, 24 normal
> priority (nice 0) CPU hogs and 24 high priority (nice -19) readers):
>
>   Metric           Base               Patched
>   ----------------------------------------------------------
>   Read IOPS        207k               1,150k        (+5.6x)
>   Read clat avg    101.50 us          7.76 us       (-13.1x)
>   Read clat stdev  5,615.90 us        30.78 us      (-182x)
>   Read clat p99.99 258,998 us         111.10 us     (-2331x)
>   Read clat max    1,342,600 us       11,217 us     (-120x)

These results are awesome and thanks for exploring other options. I
agree this sounds like a great path forward.

>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/backend_842.c     |   4 +-
>  drivers/block/zram/backend_deflate.c |  96 ++++++++++-------
>  drivers/block/zram/backend_lz4.c     |   7 +-
>  drivers/block/zram/backend_lz4hc.c   |   4 +-
>  drivers/block/zram/backend_lzo.c     |   4 +-
>  drivers/block/zram/backend_lzorle.c  |   4 +-
>  drivers/block/zram/backend_zstd.c    | 119 +++++++++++++---------
>  drivers/block/zram/zcomp.c           | 147 +++++++++++++++++++++------
>  drivers/block/zram/zcomp.h           |  28 +++--
>  drivers/block/zram/zram_drv.c        |  38 +++----
>  10 files changed, 298 insertions(+), 153 deletions(-)
>
> diff --git a/drivers/block/zram/backend_842.c b/drivers/block/zram/backen=
d_842.c
> index 56ffda201727..f911cd1ca72e 100644
> --- a/drivers/block/zram/backend_842.c
> +++ b/drivers/block/zram/backend_842.c
> @@ -63,8 +63,8 @@ static int decompress_842(struct zcomp_params *params, =
struct zcomp_ctx *ctx,
>  const struct zcomp_ops backend_842 =3D {
>         .compress       =3D compress_842,
>         .decompress     =3D decompress_842,
> -       .create_ctx     =3D create_842,
> -       .destroy_ctx    =3D destroy_842,
> +       .create_cctx    =3D create_842,
> +       .destroy_cctx   =3D destroy_842,
>         .setup_params   =3D setup_params_842,
>         .release_params =3D release_params_842,
>         .name           =3D "842",
> diff --git a/drivers/block/zram/backend_deflate.c b/drivers/block/zram/ba=
ckend_deflate.c
> index 20685aca9bdc..5ffdaf80d8cf 100644
> --- a/drivers/block/zram/backend_deflate.c
> +++ b/drivers/block/zram/backend_deflate.c
> @@ -13,11 +13,6 @@
>  #define DEFLATE_DEF_WINBITS            (-11)
>  #define DEFLATE_DEF_MEMLEVEL           MAX_MEM_LEVEL
>
> -struct deflate_ctx {
> -       struct z_stream_s cctx;
> -       struct z_stream_s dctx;
> -};
> -
>  static void deflate_release_params(struct zcomp_params *params)
>  {
>  }
> @@ -51,70 +46,98 @@ static int deflate_setup_params(struct zcomp_params *=
params)
>         return 0;
>  }
>
> -static void deflate_destroy(struct zcomp_ctx *ctx)
> +static void deflate_destroy_cctx(struct zcomp_ctx *ctx)
>  {
> -       struct deflate_ctx *zctx =3D ctx->context;
> +       struct z_stream_s *cctx =3D ctx->context;
>
> -       if (!zctx)
> +       if (!cctx)
>                 return;
>
> -       if (zctx->cctx.workspace) {
> -               zlib_deflateEnd(&zctx->cctx);
> -               vfree(zctx->cctx.workspace);
> -       }
> -       if (zctx->dctx.workspace) {
> -               zlib_inflateEnd(&zctx->dctx);
> -               vfree(zctx->dctx.workspace);
> +       if (cctx->workspace) {
> +               zlib_deflateEnd(cctx);
> +               vfree(cctx->workspace);
>         }
> -       kfree(zctx);
> +       kfree(cctx);
>  }
>
> -static int deflate_create(struct zcomp_params *params, struct zcomp_ctx =
*ctx)
> +static int deflate_create_cctx(struct zcomp_params *params,
> +                              struct zcomp_ctx *ctx)
>  {
> -       struct deflate_ctx *zctx;
> +       struct z_stream_s *cctx;
>         size_t sz;
>         int ret;
>
> -       zctx =3D kzalloc_obj(*zctx);
> -       if (!zctx)
> +       cctx =3D kzalloc_obj(*cctx);
> +       if (!cctx)
>                 return -ENOMEM;
>
> -       ctx->context =3D zctx;
> +       ctx->context =3D cctx;
>         sz =3D zlib_deflate_workspacesize(params->deflate.winbits, MAX_ME=
M_LEVEL);
> -       zctx->cctx.workspace =3D vzalloc(sz);
> -       if (!zctx->cctx.workspace)
> +       cctx->workspace =3D vzalloc(sz);
> +       if (!cctx->workspace)
>                 goto error;
>
> -       ret =3D zlib_deflateInit2(&zctx->cctx, params->level, Z_DEFLATED,
> +       ret =3D zlib_deflateInit2(cctx, params->level, Z_DEFLATED,
>                                 params->deflate.winbits, DEFLATE_DEF_MEML=
EVEL,
>                                 Z_DEFAULT_STRATEGY);
>         if (ret !=3D Z_OK)
>                 goto error;
>
> +       return 0;
> +
> +error:
> +       deflate_destroy_cctx(ctx);
> +       return -EINVAL;
> +}
> +
> +static void deflate_destroy_dctx(struct zcomp_ctx *ctx)
> +{
> +       struct z_stream_s *dctx =3D ctx->context;
> +
> +       if (!dctx)
> +               return;
> +
> +       if (dctx->workspace) {
> +               zlib_inflateEnd(dctx);
> +               vfree(dctx->workspace);
> +       }
> +       kfree(dctx);
> +}
> +
> +static int deflate_create_dctx(struct zcomp_params *params,
> +                              struct zcomp_ctx *ctx)
> +{
> +       struct z_stream_s *dctx;
> +       size_t sz;
> +       int ret;
> +
> +       dctx =3D kzalloc_obj(*dctx);
> +       if (!dctx)
> +               return -ENOMEM;
> +
> +       ctx->context =3D dctx;
>         sz =3D zlib_inflate_workspacesize();
> -       zctx->dctx.workspace =3D vzalloc(sz);
> -       if (!zctx->dctx.workspace)
> +       dctx->workspace =3D vzalloc(sz);
> +       if (!dctx->workspace)
>                 goto error;
>
> -       ret =3D zlib_inflateInit2(&zctx->dctx, params->deflate.winbits);
> +       ret =3D zlib_inflateInit2(dctx, params->deflate.winbits);
>         if (ret !=3D Z_OK)
>                 goto error;
>
>         return 0;
>
>  error:
> -       deflate_destroy(ctx);
> +       deflate_destroy_dctx(ctx);
>         return -EINVAL;
>  }
>
>  static int deflate_compress(struct zcomp_params *params, struct zcomp_ct=
x *ctx,
>                             struct zcomp_req *req)
>  {
> -       struct deflate_ctx *zctx =3D ctx->context;
> -       struct z_stream_s *deflate;
> +       struct z_stream_s *deflate =3D ctx->context;
>         int ret;
>
> -       deflate =3D &zctx->cctx;
>         ret =3D zlib_deflateReset(deflate);
>         if (ret !=3D Z_OK)
>                 return -EINVAL;
> @@ -136,12 +159,9 @@ static int deflate_decompress(struct zcomp_params *p=
arams,
>                               struct zcomp_ctx *ctx,
>                               struct zcomp_req *req)
>  {
> -       struct deflate_ctx *zctx =3D ctx->context;
> -       struct z_stream_s *inflate;
> +       struct z_stream_s *inflate =3D ctx->context;
>         int ret;
>
> -       inflate =3D &zctx->dctx;
> -
>         ret =3D zlib_inflateReset(inflate);
>         if (ret !=3D Z_OK)
>                 return -EINVAL;
> @@ -161,8 +181,10 @@ static int deflate_decompress(struct zcomp_params *p=
arams,
>  const struct zcomp_ops backend_deflate =3D {
>         .compress       =3D deflate_compress,
>         .decompress     =3D deflate_decompress,
> -       .create_ctx     =3D deflate_create,
> -       .destroy_ctx    =3D deflate_destroy,
> +       .create_cctx    =3D deflate_create_cctx,
> +       .destroy_cctx   =3D deflate_destroy_cctx,
> +       .create_dctx    =3D deflate_create_dctx,
> +       .destroy_dctx   =3D deflate_destroy_dctx,
>         .setup_params   =3D deflate_setup_params,
>         .release_params =3D deflate_release_params,
>         .name           =3D "deflate",
> diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backen=
d_lz4.c
> index 5f2e27805d75..9767482a2fea 100644
> --- a/drivers/block/zram/backend_lz4.c
> +++ b/drivers/block/zram/backend_lz4.c
> @@ -38,8 +38,7 @@ static int lz4_setup_params(struct zcomp_params *params=
)
>         if (!dict_stream)
>                 return -ENOMEM;
>
> -       ret =3D LZ4_loadDict(dict_stream,
> -                          params->dict, params->dict_sz);
> +       ret =3D LZ4_loadDict(dict_stream, params->dict, params->dict_sz);
>         if (ret !=3D params->dict_sz) {
>                 vfree(dict_stream);
>                 return -EINVAL;
> @@ -102,8 +101,8 @@ static int lz4_decompress(struct zcomp_params *params=
, struct zcomp_ctx *ctx,
>  const struct zcomp_ops backend_lz4 =3D {
>         .compress       =3D lz4_compress,
>         .decompress     =3D lz4_decompress,
> -       .create_ctx     =3D lz4_create,
> -       .destroy_ctx    =3D lz4_destroy,
> +       .create_cctx    =3D lz4_create,
> +       .destroy_cctx   =3D lz4_destroy,
>         .setup_params   =3D lz4_setup_params,
>         .release_params =3D lz4_release_params,
>         .name           =3D "lz4",
> diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/back=
end_lz4hc.c
> index b62736b26622..2d1364a29b27 100644
> --- a/drivers/block/zram/backend_lz4hc.c
> +++ b/drivers/block/zram/backend_lz4hc.c
> @@ -107,8 +107,8 @@ static int lz4hc_decompress(struct zcomp_params *para=
ms, struct zcomp_ctx *ctx,
>  const struct zcomp_ops backend_lz4hc =3D {
>         .compress       =3D lz4hc_compress,
>         .decompress     =3D lz4hc_decompress,
> -       .create_ctx     =3D lz4hc_create,
> -       .destroy_ctx    =3D lz4hc_destroy,
> +       .create_cctx    =3D lz4hc_create,
> +       .destroy_cctx   =3D lz4hc_destroy,
>         .setup_params   =3D lz4hc_setup_params,
>         .release_params =3D lz4hc_release_params,
>         .name           =3D "lz4hc",
> diff --git a/drivers/block/zram/backend_lzo.c b/drivers/block/zram/backen=
d_lzo.c
> index 78538479c511..e703560d9ecd 100644
> --- a/drivers/block/zram/backend_lzo.c
> +++ b/drivers/block/zram/backend_lzo.c
> @@ -61,8 +61,8 @@ static int lzo_decompress(struct zcomp_params *params, =
struct zcomp_ctx *ctx,
>  const struct zcomp_ops backend_lzo =3D {
>         .compress       =3D lzo_compress,
>         .decompress     =3D lzo_decompress,
> -       .create_ctx     =3D lzo_create,
> -       .destroy_ctx    =3D lzo_destroy,
> +       .create_cctx    =3D lzo_create,
> +       .destroy_cctx   =3D lzo_destroy,
>         .setup_params   =3D lzo_setup_params,
>         .release_params =3D lzo_release_params,
>         .name           =3D "lzo",
> diff --git a/drivers/block/zram/backend_lzorle.c b/drivers/block/zram/bac=
kend_lzorle.c
> index 011787f1430b..e95026e99202 100644
> --- a/drivers/block/zram/backend_lzorle.c
> +++ b/drivers/block/zram/backend_lzorle.c
> @@ -61,8 +61,8 @@ static int lzorle_decompress(struct zcomp_params *param=
s, struct zcomp_ctx *ctx,
>  const struct zcomp_ops backend_lzorle =3D {
>         .compress       =3D lzorle_compress,
>         .decompress     =3D lzorle_decompress,
> -       .create_ctx     =3D lzorle_create,
> -       .destroy_ctx    =3D lzorle_destroy,
> +       .create_cctx    =3D lzorle_create,
> +       .destroy_cctx   =3D lzorle_destroy,
>         .setup_params   =3D lzorle_setup_params,
>         .release_params =3D lzorle_release_params,
>         .name           =3D "lzo-rle",
> diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backe=
nd_zstd.c
> index 7a8b5ff186f2..d55615f34300 100644
> --- a/drivers/block/zram/backend_zstd.c
> +++ b/drivers/block/zram/backend_zstd.c
> @@ -10,10 +10,8 @@
>  #include "backend_zstd.h"
>
>  struct zstd_ctx {
> -       zstd_cctx *cctx;
> -       zstd_dctx *dctx;
> -       void *cctx_mem;
> -       void *dctx_mem;
> +       void *ctx;
> +       void *mem;
>  };
>
>  struct zstd_params {
> @@ -105,7 +103,7 @@ static int zstd_setup_params(struct zcomp_params *par=
ams)
>         return -EINVAL;
>  }
>
> -static void zstd_destroy(struct zcomp_ctx *ctx)
> +static void zstd_destroy_cctx(struct zcomp_ctx *ctx)
>  {
>         struct zstd_ctx *zctx =3D ctx->context;
>
> @@ -113,30 +111,23 @@ static void zstd_destroy(struct zcomp_ctx *ctx)
>                 return;
>
>         /*
> -        * If ->cctx_mem and ->dctx_mem were allocated then we didn't use
> -        * C/D dictionary and ->cctx / ->dctx were "embedded" into these
> -        * buffers.
> +        * If ->mem was allocated then we didn't use C/D dictionary and
> +        * ->ctx was "embedded" into this buffer.
>          *
> -        * If otherwise then we need to explicitly release ->cctx / ->dct=
x.
> +        * If otherwise then we need to explicitly release ->ctx.
>          */
> -       if (zctx->cctx_mem)
> -               vfree(zctx->cctx_mem);
> +       if (zctx->mem)
> +               vfree(zctx->mem);
>         else
> -               zstd_free_cctx(zctx->cctx);
> -
> -       if (zctx->dctx_mem)
> -               vfree(zctx->dctx_mem);
> -       else
> -               zstd_free_dctx(zctx->dctx);
> +               zstd_free_cctx(zctx->ctx);
>
>         kfree(zctx);
>  }
>
> -static int zstd_create(struct zcomp_params *params, struct zcomp_ctx *ct=
x)
> +static int zstd_create_cctx(struct zcomp_params *params, struct zcomp_ct=
x *ctx)
>  {
> +       struct zstd_params *zp =3D params->drv_data;
>         struct zstd_ctx *zctx;
> -       zstd_parameters prm;
> -       size_t sz;
>
>         zctx =3D kzalloc_obj(*zctx);
>         if (!zctx)
> @@ -144,40 +135,74 @@ static int zstd_create(struct zcomp_params *params,=
 struct zcomp_ctx *ctx)
>
>         ctx->context =3D zctx;
>         if (params->dict_sz =3D=3D 0) {
> -               prm =3D zstd_get_params(params->level, PAGE_SIZE);
> -               sz =3D zstd_cctx_workspace_bound(&prm.cParams);
> -               zctx->cctx_mem =3D vzalloc(sz);
> -               if (!zctx->cctx_mem)
> -                       goto error;
> -
> -               zctx->cctx =3D zstd_init_cctx(zctx->cctx_mem, sz);
> -               if (!zctx->cctx)
> -                       goto error;
> +               zstd_parameters prm =3D zp->cprm;
> +               size_t sz =3D zstd_cctx_workspace_bound(&prm.cParams);
>
> -               sz =3D zstd_dctx_workspace_bound();
> -               zctx->dctx_mem =3D vzalloc(sz);
> -               if (!zctx->dctx_mem)
> +               zctx->mem =3D vzalloc(sz);
> +               if (!zctx->mem)
>                         goto error;
>
> -               zctx->dctx =3D zstd_init_dctx(zctx->dctx_mem, sz);
> -               if (!zctx->dctx)
> +               zctx->ctx =3D zstd_init_cctx(zctx->mem, sz);
> +               if (!zctx->ctx)
>                         goto error;
>         } else {
> -               struct zstd_params *zp =3D params->drv_data;
> +               zctx->ctx =3D zstd_create_cctx_advanced(zp->custom_mem);
> +               if (!zctx->ctx)
> +                       goto error;
> +       }
> +
> +       return 0;
> +
> +error:
> +       zstd_destroy_cctx(ctx);
> +       return -EINVAL;
> +}
> +
> +static void zstd_destroy_dctx(struct zcomp_ctx *ctx)
> +{
> +       struct zstd_ctx *zctx =3D ctx->context;
> +
> +       if (!zctx)
> +               return;
> +
> +       if (zctx->mem)
> +               vfree(zctx->mem);
> +       else
> +               zstd_free_dctx(zctx->ctx);
> +
> +       kfree(zctx);
> +}
> +
> +static int zstd_create_dctx(struct zcomp_params *params, struct zcomp_ct=
x *ctx)
> +{
> +       struct zstd_params *zp =3D params->drv_data;
> +       struct zstd_ctx *zctx;
>
> -               zctx->cctx =3D zstd_create_cctx_advanced(zp->custom_mem);
> -               if (!zctx->cctx)
> +       zctx =3D kzalloc_obj(*zctx);
> +       if (!zctx)
> +               return -ENOMEM;
> +
> +       ctx->context =3D zctx;
> +       if (params->dict_sz =3D=3D 0) {
> +               size_t sz =3D zstd_dctx_workspace_bound();
> +
> +               zctx->mem =3D vzalloc(sz);
> +               if (!zctx->mem)
>                         goto error;
>
> -               zctx->dctx =3D zstd_create_dctx_advanced(zp->custom_mem);
> -               if (!zctx->dctx)
> +               zctx->ctx =3D zstd_init_dctx(zctx->mem, sz);
> +               if (!zctx->ctx)
> +                       goto error;
> +       } else {
> +               zctx->ctx =3D zstd_create_dctx_advanced(zp->custom_mem);
> +               if (!zctx->ctx)
>                         goto error;
>         }
>
>         return 0;
>
>  error:
> -       zstd_destroy(ctx);
> +       zstd_destroy_dctx(ctx);
>         return -EINVAL;
>  }
>
> @@ -189,10 +214,10 @@ static int zstd_compress(struct zcomp_params *param=
s, struct zcomp_ctx *ctx,
>         size_t ret;
>
>         if (params->dict_sz =3D=3D 0)
> -               ret =3D zstd_compress_cctx(zctx->cctx, req->dst, req->dst=
_len,
> +               ret =3D zstd_compress_cctx(zctx->ctx, req->dst, req->dst_=
len,
>                                          req->src, req->src_len, &zp->cpr=
m);
>         else
> -               ret =3D zstd_compress_using_cdict(zctx->cctx, req->dst,
> +               ret =3D zstd_compress_using_cdict(zctx->ctx, req->dst,
>                                                 req->dst_len, req->src,
>                                                 req->src_len,
>                                                 zp->cdict);
> @@ -210,10 +235,10 @@ static int zstd_decompress(struct zcomp_params *par=
ams, struct zcomp_ctx *ctx,
>         size_t ret;
>
>         if (params->dict_sz =3D=3D 0)
> -               ret =3D zstd_decompress_dctx(zctx->dctx, req->dst, req->d=
st_len,
> +               ret =3D zstd_decompress_dctx(zctx->ctx, req->dst, req->ds=
t_len,
>                                            req->src, req->src_len);
>         else
> -               ret =3D zstd_decompress_using_ddict(zctx->dctx, req->dst,
> +               ret =3D zstd_decompress_using_ddict(zctx->ctx, req->dst,
>                                                   req->dst_len, req->src,
>                                                   req->src_len, zp->ddict=
);
>         if (zstd_is_error(ret))
> @@ -224,8 +249,10 @@ static int zstd_decompress(struct zcomp_params *para=
ms, struct zcomp_ctx *ctx,
>  const struct zcomp_ops backend_zstd =3D {
>         .compress       =3D zstd_compress,
>         .decompress     =3D zstd_decompress,
> -       .create_ctx     =3D zstd_create,
> -       .destroy_ctx    =3D zstd_destroy,
> +       .create_cctx    =3D zstd_create_cctx,
> +       .destroy_cctx   =3D zstd_destroy_cctx,
> +       .create_dctx    =3D zstd_create_dctx,
> +       .destroy_dctx   =3D zstd_destroy_dctx,
>         .setup_params   =3D zstd_setup_params,
>         .release_params =3D zstd_release_params,
>         .name           =3D "zstd",
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 028e2f0f587e..1c9f6d5c8cd1 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -45,30 +45,65 @@ static const struct zcomp_ops *backends[] =3D {
>         NULL
>  };
>
> -static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm=
)
> +static void zcomp_cstrm_free(struct zcomp *comp, struct zcomp_cstrm *zst=
rm)
>  {
> -       comp->ops->destroy_ctx(&zstrm->ctx);
> -       vfree(zstrm->local_copy);
> +       if (comp->ops->destroy_cctx)
> +               comp->ops->destroy_cctx(&zstrm->ctx);
>         vfree(zstrm->buffer);
>         zstrm->buffer =3D NULL;
> +       zstrm->ctx.context =3D NULL;
>  }
>
> -static int zcomp_strm_init(struct zcomp *comp, struct zcomp_strm *zstrm)
> +static int zcomp_cstrm_init(struct zcomp *comp, struct zcomp_cstrm *zstr=
m)
>  {
>         int ret;
>
> -       ret =3D comp->ops->create_ctx(comp->params, &zstrm->ctx);
> -       if (ret)
> -               return ret;
> +       if (comp->ops->create_cctx) {
> +               ret =3D comp->ops->create_cctx(comp->params, &zstrm->ctx)=
;
> +               if (ret) {
> +                       /* backend has released partially created context=
 */
> +                       zstrm->ctx.context =3D NULL;
> +                       return ret;
> +               }
> +       }
>
> -       zstrm->local_copy =3D vzalloc(PAGE_SIZE);
>         /*
>          * allocate 2 pages. 1 for compressed data, plus 1 extra for the
>          * case when compressed size is larger than the original one
>          */
>         zstrm->buffer =3D vzalloc(2 * PAGE_SIZE);
> -       if (!zstrm->buffer || !zstrm->local_copy) {
> -               zcomp_strm_free(comp, zstrm);
> +       if (!zstrm->buffer) {
> +               zcomp_cstrm_free(comp, zstrm);
> +               return -ENOMEM;
> +       }
> +       return 0;
> +}
> +
> +static void zcomp_dstrm_free(struct zcomp *comp, struct zcomp_dstrm *zst=
rm)
> +{
> +       if (comp->ops->destroy_dctx)
> +               comp->ops->destroy_dctx(&zstrm->ctx);
> +       vfree(zstrm->local_copy);
> +       zstrm->local_copy =3D NULL;
> +       zstrm->ctx.context =3D NULL;
> +}
> +
> +static int zcomp_dstrm_init(struct zcomp *comp, struct zcomp_dstrm *zstr=
m)
> +{
> +       int ret;
> +
> +       if (comp->ops->create_dctx) {
> +               ret =3D comp->ops->create_dctx(comp->params, &zstrm->ctx)=
;
> +               if (ret) {
> +                       /* backend has released partially created context=
 */
> +                       zstrm->ctx.context =3D NULL;
> +                       return ret;
> +               }
> +       }
> +
> +       zstrm->local_copy =3D vzalloc(PAGE_SIZE);
> +       if (!zstrm->local_copy) {
> +               zcomp_dstrm_free(comp, zstrm);
>                 return -ENOMEM;
>         }
>         return 0;
> @@ -114,10 +149,10 @@ ssize_t zcomp_available_show(const char *comp, char=
 *buf, ssize_t at)
>         return at;
>  }
>
> -struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
> +struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp)
>  {
>         for (;;) {
> -               struct zcomp_strm *zstrm =3D raw_cpu_ptr(comp->stream);
> +               struct zcomp_cstrm *zstrm =3D raw_cpu_ptr(comp->cstream);
>
>                 /*
>                  * Inspired by zswap
> @@ -136,12 +171,29 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp *c=
omp)
>         }
>  }
>
> -void zcomp_stream_put(struct zcomp_strm *zstrm)
> +void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
> +{
> +       mutex_unlock(&zstrm->lock);
> +}
> +
> +struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp)
> +{
> +       for (;;) {
> +               struct zcomp_dstrm *zstrm =3D raw_cpu_ptr(comp->dstream);
> +
> +               mutex_lock(&zstrm->lock);
> +               if (likely(zstrm->local_copy))
> +                       return zstrm;
> +               mutex_unlock(&zstrm->lock);
> +       }
> +}
> +
> +void zcomp_dstrm_put(struct zcomp_dstrm *zstrm)
>  {
>         mutex_unlock(&zstrm->lock);
>  }
>
> -int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
>                    const void *src, unsigned int *dst_len)
>  {
>         struct zcomp_req req =3D {
> @@ -159,7 +211,7 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_s=
trm *zstrm,
>         return ret;
>  }
>
> -int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
>                      struct scatterlist *sg, unsigned int src_len, void *=
dst)
>  {
>         struct zcomp_req req =3D {
> @@ -191,23 +243,44 @@ int zcomp_decompress(struct zcomp *comp, struct zco=
mp_strm *zstrm,
>  int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
>  {
>         struct zcomp *comp =3D hlist_entry(node, struct zcomp, node);
> -       struct zcomp_strm *zstrm =3D per_cpu_ptr(comp->stream, cpu);
> +       struct zcomp_cstrm *cstrm;
> +       struct zcomp_dstrm *dstrm;
>         int ret;
>
> -       ret =3D zcomp_strm_init(comp, zstrm);
> -       if (ret)
> +       cstrm =3D per_cpu_ptr(comp->cstream, cpu);
> +       ret =3D zcomp_cstrm_init(comp, cstrm);
> +       if (ret) {
>                 pr_err("Can't allocate a compression stream\n");
> -       return ret;
> +               return ret;
> +       }
> +
> +       dstrm =3D per_cpu_ptr(comp->dstream, cpu);
> +       ret =3D zcomp_dstrm_init(comp, dstrm);
> +       if (ret) {
> +               pr_err("Can't allocate a decompression stream\n");
> +               zcomp_cstrm_free(comp, cstrm);
> +               return ret;
> +       }
> +
> +       return 0;
>  }
>
>  int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
>  {
>         struct zcomp *comp =3D hlist_entry(node, struct zcomp, node);
> -       struct zcomp_strm *zstrm =3D per_cpu_ptr(comp->stream, cpu);
> +       struct zcomp_cstrm *cstrm;
> +       struct zcomp_dstrm *dstrm;
> +
> +       cstrm =3D per_cpu_ptr(comp->cstream, cpu);
> +       mutex_lock(&cstrm->lock);
> +       zcomp_cstrm_free(comp, cstrm);
> +       mutex_unlock(&cstrm->lock);
> +
> +       dstrm =3D per_cpu_ptr(comp->dstream, cpu);
> +       mutex_lock(&dstrm->lock);
> +       zcomp_dstrm_free(comp, dstrm);
> +       mutex_unlock(&dstrm->lock);
>
> -       mutex_lock(&zstrm->lock);
> -       zcomp_strm_free(comp, zstrm);
> -       mutex_unlock(&zstrm->lock);
>         return 0;
>  }
>
> @@ -215,17 +288,27 @@ static int zcomp_init(struct zcomp *comp, struct zc=
omp_params *params)
>  {
>         int ret, cpu;
>
> -       comp->stream =3D alloc_percpu(struct zcomp_strm);
> -       if (!comp->stream)
> -               return -ENOMEM;
> -
>         comp->params =3D params;
>         ret =3D comp->ops->setup_params(comp->params);
>         if (ret)
>                 goto cleanup;
>
> -       for_each_possible_cpu(cpu)
> -               mutex_init(&per_cpu_ptr(comp->stream, cpu)->lock);
> +       comp->cstream =3D alloc_percpu(struct zcomp_cstrm);
> +       if (!comp->cstream) {
> +               ret =3D -ENOMEM;
> +               goto cleanup;
> +       }
> +
> +       comp->dstream =3D alloc_percpu(struct zcomp_dstrm);
> +       if (!comp->dstream) {
> +               ret =3D -ENOMEM;
> +               goto cleanup;
> +       }
> +
> +       for_each_possible_cpu(cpu) {
> +               mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
> +               mutex_init(&per_cpu_ptr(comp->dstream, cpu)->lock);
> +       }
>
>         ret =3D cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node=
);
>         if (ret < 0)
> @@ -235,7 +318,8 @@ static int zcomp_init(struct zcomp *comp, struct zcom=
p_params *params)
>
>  cleanup:
>         comp->ops->release_params(comp->params);
> -       free_percpu(comp->stream);
> +       free_percpu(comp->dstream);
> +       free_percpu(comp->cstream);
>         return ret;
>  }
>
> @@ -243,7 +327,8 @@ void zcomp_destroy(struct zcomp *comp)
>  {
>         cpuhp_state_remove_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
>         comp->ops->release_params(comp->params);
> -       free_percpu(comp->stream);
> +       free_percpu(comp->dstream);
> +       free_percpu(comp->cstream);
>         kfree(comp);
>  }
>
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index f38fd31f9e4e..22be50dc51ba 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -39,10 +39,15 @@ struct zcomp_ctx {
>         void *context;
>  };
>
> -struct zcomp_strm {
> +struct zcomp_cstrm {
>         struct mutex lock;
>         /* compression buffer */
>         void *buffer;
> +       struct zcomp_ctx ctx;
> +};
> +
> +struct zcomp_dstrm {
> +       struct mutex lock;
>         /* local copy of handle memory */
>         void *local_copy;
>         struct zcomp_ctx ctx;
> @@ -62,8 +67,11 @@ struct zcomp_ops {
>         int (*decompress)(struct zcomp_params *params, struct zcomp_ctx *=
ctx,
>                           struct zcomp_req *req);
>
> -       int (*create_ctx)(struct zcomp_params *params, struct zcomp_ctx *=
ctx);
> -       void (*destroy_ctx)(struct zcomp_ctx *ctx);
> +       int (*create_cctx)(struct zcomp_params *params, struct zcomp_ctx =
*ctx);
> +       void (*destroy_cctx)(struct zcomp_ctx *ctx);
> +
> +       int (*create_dctx)(struct zcomp_params *params, struct zcomp_ctx =
*ctx);
> +       void (*destroy_dctx)(struct zcomp_ctx *ctx);
>
>         int (*setup_params)(struct zcomp_params *params);
>         void (*release_params)(struct zcomp_params *params);
> @@ -73,7 +81,8 @@ struct zcomp_ops {
>
>  /* dynamic per-device compression frontend */
>  struct zcomp {
> -       struct zcomp_strm __percpu *stream;
> +       struct zcomp_cstrm __percpu *cstream;
> +       struct zcomp_dstrm __percpu *dstream;
>         const struct zcomp_ops *ops;
>         struct zcomp_params *params;
>         struct hlist_node node;
> @@ -87,12 +96,15 @@ const char *zcomp_lookup_backend_name(const char *com=
p);
>  struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)=
;
>  void zcomp_destroy(struct zcomp *comp);
>
> -struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
> -void zcomp_stream_put(struct zcomp_strm *zstrm);
> +struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
> +void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
> +
> +struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp);
> +void zcomp_dstrm_put(struct zcomp_dstrm *zstrm);
>
> -int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
>                    const void *src, unsigned int *dst_len);
> -int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
>                      struct scatterlist *sg, unsigned int src_len, void *=
dst);
>
>  #endif /* _ZCOMP_H_ */
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 0e1aa0da11aa..def5266679b0 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1348,7 +1348,7 @@ static ssize_t writeback_store(struct device *dev,
>  static int decompress_bdev_page(struct zram *zram, struct page *page,
>                                 unsigned long index)
>  {
> -       struct zcomp_strm *zstrm;
> +       struct zcomp_dstrm *zstrm;
>         struct scatterlist sg[1];
>         unsigned int size;
>         int ret, prio;
> @@ -1373,7 +1373,7 @@ static int decompress_bdev_page(struct zram *zram, =
struct page *page,
>         sg_init_table(sg, 1);
>         sg_set_page(sg, page, size, 0);
>
> -       zstrm =3D zcomp_stream_get(zram->comps[prio]);
> +       zstrm =3D zcomp_dstrm_get(zram->comps[prio]);
>         ret =3D zcomp_decompress(zram->comps[prio], zstrm, sg, size,
>                                zstrm->local_copy);
>         if (!ret) {
> @@ -1382,7 +1382,7 @@ static int decompress_bdev_page(struct zram *zram, =
struct page *page,
>                 copy_page(dst, zstrm->local_copy);
>                 kunmap_local(dst);
>         }
> -       zcomp_stream_put(zstrm);
> +       zcomp_dstrm_put(zstrm);
>         slot_unlock(zram, index);
>
>         return ret;
> @@ -2115,7 +2115,7 @@ static int read_incompressible_page(struct zram *zr=
am, struct page *page,
>  static int read_compressed_page(struct zram *zram, struct page *page,
>                                 unsigned long index)
>  {
> -       struct zcomp_strm *zstrm;
> +       struct zcomp_dstrm *zstrm;
>         struct scatterlist sg[2];
>         unsigned long handle;
>         unsigned int size;
> @@ -2126,13 +2126,13 @@ static int read_compressed_page(struct zram *zram=
, struct page *page,
>         size =3D get_slot_size(zram, index);
>         prio =3D get_slot_comp_priority(zram, index);
>
> -       zstrm =3D zcomp_stream_get(zram->comps[prio]);
> +       zstrm =3D zcomp_dstrm_get(zram->comps[prio]);
>         zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
>         dst =3D kmap_local_page(page);
>         ret =3D zcomp_decompress(zram->comps[prio], zstrm, sg, size, dst)=
;
>         kunmap_local(dst);
>         zs_obj_read_sg_end(zram->mem_pool, handle);
> -       zcomp_stream_put(zstrm);
> +       zcomp_dstrm_put(zstrm);
>
>         return ret;
>  }
> @@ -2300,7 +2300,7 @@ static int zram_write_page(struct zram *zram, struc=
t page *page,
>         unsigned long handle;
>         unsigned int comp_len;
>         void *mem;
> -       struct zcomp_strm *zstrm;
> +       struct zcomp_cstrm *zstrm;
>         unsigned long element;
>         bool same_filled;
>
> @@ -2310,20 +2310,20 @@ static int zram_write_page(struct zram *zram, str=
uct page *page,
>         if (same_filled)
>                 return write_same_filled_page(zram, element, index);
>
> -       zstrm =3D zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
> +       zstrm =3D zcomp_cstrm_get(zram->comps[ZRAM_PRIMARY_COMP]);
>         mem =3D kmap_local_page(page);
>         ret =3D zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
>                              mem, &comp_len);
>         kunmap_local(mem);
>
>         if (unlikely(ret)) {
> -               zcomp_stream_put(zstrm);
> +               zcomp_cstrm_put(zstrm);
>                 pr_err("Compression failed! err=3D%d\n", ret);
>                 return ret;
>         }
>
>         if (comp_len >=3D huge_class_size) {
> -               zcomp_stream_put(zstrm);
> +               zcomp_cstrm_put(zstrm);
>                 return write_incompressible_page(zram, page, index);
>         }
>
> @@ -2331,18 +2331,18 @@ static int zram_write_page(struct zram *zram, str=
uct page *page,
>                            GFP_NOIO | __GFP_NOWARN |
>                            __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(pag=
e));
>         if (IS_ERR_VALUE(handle)) {
> -               zcomp_stream_put(zstrm);
> +               zcomp_cstrm_put(zstrm);
>                 return PTR_ERR((void *)handle);
>         }
>
>         if (!zram_can_store_page(zram)) {
> -               zcomp_stream_put(zstrm);
> +               zcomp_cstrm_put(zstrm);
>                 zs_free(zram->mem_pool, handle);
>                 return -ENOMEM;
>         }
>
>         zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
> -       zcomp_stream_put(zstrm);
> +       zcomp_cstrm_put(zstrm);
>
>         slot_lock(zram, index);
>         slot_free(zram, index);
> @@ -2451,7 +2451,7 @@ static int recompress_slot(struct zram *zram, unsig=
ned long index,
>                            struct page *page, u64 *num_recomp_pages,
>                            u32 threshold, u32 prio)
>  {
> -       struct zcomp_strm *zstrm =3D NULL;
> +       struct zcomp_cstrm *zstrm =3D NULL;
>         unsigned long handle_old;
>         unsigned long handle_new;
>         unsigned int comp_len_old;
> @@ -2483,7 +2483,7 @@ static int recompress_slot(struct zram *zram, unsig=
ned long index,
>          */
>         clear_slot_flag(zram, index, ZRAM_IDLE);
>
> -       zstrm =3D zcomp_stream_get(zram->comps[prio]);
> +       zstrm =3D zcomp_cstrm_get(zram->comps[prio]);
>         src =3D kmap_local_page(page);
>         ret =3D zcomp_compress(zram->comps[prio], zstrm, src, &comp_len_n=
ew);
>         kunmap_local(src);
> @@ -2498,7 +2498,7 @@ static int recompress_slot(struct zram *zram, unsig=
ned long index,
>                 *num_recomp_pages -=3D 1;
>
>         if (ret) {
> -               zcomp_stream_put(zstrm);
> +               zcomp_cstrm_put(zstrm);
>                 return ret;
>         }
>
> @@ -2507,7 +2507,7 @@ static int recompress_slot(struct zram *zram, unsig=
ned long index,
>
>         if (class_index_new >=3D class_index_old ||
>             (threshold && comp_len_new >=3D threshold)) {
> -               zcomp_stream_put(zstrm);
> +               zcomp_cstrm_put(zstrm);
>
>                 /*
>                  * Secondary algorithms failed to re-compress the page
> @@ -2536,12 +2536,12 @@ static int recompress_slot(struct zram *zram, uns=
igned long index,
>                                __GFP_HIGHMEM | __GFP_MOVABLE,
>                                page_to_nid(page));
>         if (IS_ERR_VALUE(handle_new)) {
> -               zcomp_stream_put(zstrm);
> +               zcomp_cstrm_put(zstrm);
>                 return PTR_ERR((void *)handle_new);
>         }
>
>         zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_=
new);
> -       zcomp_stream_put(zstrm);
> +       zcomp_cstrm_put(zstrm);
>
>         slot_free(zram, index);
>         set_slot_handle(zram, index, handle_new);
> --
> 2.56.0.212.g129ede20d9-goog
>

