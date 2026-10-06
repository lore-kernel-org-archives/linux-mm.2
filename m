Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD8CCA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F696B0093; Tue,  6 Oct 2026 02:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA0D6B009B; Tue,  6 Oct 2026 02:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49D56B009D; Tue,  6 Oct 2026 02:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 737E26B0093
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:23:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CB928059E
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:23:35 +0000 (UTC)
X-FDA: 85291209990.13.46F17EB
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6903E1C0005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:23:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mIo7EZRr;
	spf=pass (imf20.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791267813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6+kRSXQFgdihasqR6LMoeFY3+MY7JRLIu/SoS6ybio=;
	b=zaZSewSoBwH/pWkSd3oxiqf/VoVbCNwCNucPvr0QiSthkRa4MnyUiIYeJuEK+ZN4ad159A
	eSENRxx0eJ8zK0rvh0M6vgw/Efqnhz+GK80xHMrIY40egQV739f3uavp83yXAItFjRaMAT
	nBl19rd3L3qt5sR17EobQllU2t4n/yM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791267813;
	b=2eM9p7ILJPYfPRNIzZ6RvnYqdjC39i9IHtP7Ai+eD07Bk6qf9cVbFh+oCN6njHiV5aj5HT
	OqpdaBVITETGCgcfvOVSnevbaZssIovplKTeSw4MEXTAGn+YE6enAGFYnjG9KpaLmTdhLK
	8GXjfoKVGw4NLpO0B/N4v/G6de8mXHU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mIo7EZRr;
	spf=pass (imf20.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-533202fe429so160101cf.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 23:23:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791267812; cv=none;
        d=google.com; s=arc-20260327;
        b=VuMLaW+We5KiZhcNrStE+a2oFXbbpTVi3knW7GycKmEJ+DN1RpRYvlYxPG06ANEgj2
         QysA9+mYfDMktAaaDCanYRdtotNMsD5kpPNENz33irZU5qJxSQdljhby2QpiZ0pDEOtq
         4ra7DzqeB/g6slTZXmF2fmVi9Zx1OCRvBeu3qNkI9kDgCygWbxeDFYSAhh+JYdlXTs3R
         /L7kQrSWBzrxYBYwW2I4lLSne5zy1756S3PMv09t07zzOEWP16S5t9duVo0ChFaUJxrj
         tN76epZ3EKrFDfAFJpQk8wUuBLisYqZropgO62e9tiNw2AgsNDUrEXPuHBAwQwqzIzPy
         E0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d6+kRSXQFgdihasqR6LMoeFY3+MY7JRLIu/SoS6ybio=;
        fh=txCFK8E++vF66JiSqNDe5rdT6NIbBEomXvo4pUIZ9XU=;
        b=BqlQ2mKc84SaR5XUvXeD9j0qMcY7t86G447pJm40QxyC89WWivKxCX/CNzQBDW1kUJ
         PPBj23y9aNXUiGGCtUB9iPOXj16lpOVwgd2GY4cfp95Vl26cwTYjURj6tHMVaCj//fMZ
         wfAitnBHHJ6wlXo+ewdwe3VTKtNRj17KE5lcKQAXpb2LtpSMg7swsBmoBvdW8IEb1Qso
         NplzU4484+8t+drPy4lrlSnCUVLmCloHcJn/j0XnmWP3A6Cf0wJtQnopclbKdzZgIpNu
         wpcHnd1bZg0TDJ6AIgVUCqWj86gNBjO8digX/hziuklSYa2A2+VDJA7+P/GbkDLaT0sa
         FZsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791267812; x=1791872612; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d6+kRSXQFgdihasqR6LMoeFY3+MY7JRLIu/SoS6ybio=;
        b=mIo7EZRrTOhlHoUU5YlC+s0kIgjqUYWHI+to2SRAT+5ylwlav+iIyiZmg8/IelZ/tC
         BSVkpGa6gNNJv0uZqxv+pQRguG1BbDCewf6bmsIfPYaXbuaDiq5TRxTtufR3PKi11AS4
         ddRI90RkRTbpIEkM0ogykF1BOCCgAcUoIX5/gkHbQbsY+mjXn7JQpDCnWJL4uJGa1QKM
         MzWcVoQhOuyBE9erXSWiZNNtSOFA0WRzylc1D/HqQDrP1EOH9XiIjhSe03wIySl7v7z1
         NHLj1N13CPGOVBcsnPLWH9/u8l8Do1AYNm9wp4By7CUH5t9wlPite9xPY/CfTfX7DAiS
         qE3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791267812; x=1791872612;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d6+kRSXQFgdihasqR6LMoeFY3+MY7JRLIu/SoS6ybio=;
        b=kVMxAMJxrkb5jDL/XsX+LXUQLyZSRGpcGyc8EV2P55qTL+0T1veXycN5BnYerQJl4I
         mQcstHxdUkl/6erlaV3kucS6/hnON4z3IyPpOvT4WkEnqC9dbyohgIDY5vCY7xjEtq1J
         R5rpkY2twVwDSe85MHdRg7FmTVLNV02ETkXg2wSkljLH1Tq7wT17NU8B2sugUtHMZ/2X
         +y205+0CJW5NYSGllrFMGem55yFI7qYcoRqO+Ae03Uyq0US8EBVBAJFVCZiUGAQiIJ/7
         7/4cdErS4Jyu5guLOMB0hMRiHjOEVFTSHmLsvbk7hA5AzThF3+JJuT3bX9bi0h7FwbnV
         1lUQ==
X-Forwarded-Encrypted: i=1; AKwUvBxeWNaJb7lqf5lSvC18nokWxhv0g558MBx3wPU3vEIjhhZU+vPyctLWnEkXVBHkXKtRSzEKOCex9Q==@kvack.org
X-Gm-Message-State: AFuF++kHxnCa7bd6OU48UBZPrYhbvefTHRRf55Pr1yvZuAuabLNsHVlQ
	0zxCda4JWYO7ZcYcl2G3mqAlTVUiVWiBYLb7r4vcogKfhFK0h2Yhv3JkaCpRDrHTX/MxkNXYigl
	eULWEn2+Mf4BHeZ1YjSsS2WllXEljzUKUNIykrcmj
X-Gm-Gg: AYBFou0IoCVWaNp2FJlzq4AupZfyG2og9ZnBZZWKjB7GNRD9o+SF10IENqC0lamkFL4
	G/7NsmsBVHy7P1/fEjN2w/MTJd1KcJbYQxYsSc3d0nJJwOIEJeaECj1nhBvE4+wMMHqHxSX8KLV
	8eCjqf+L4K4gAQtLDqrRk5SGU2hnccn5p4OwE7A+9kk8zF6FwnaEHTpW76bTSJDAmhaO9I7feo9
	SeAZMvTFz/DYwbYQ85a6WQ0q81t+ZtxmJWL5l2tDFuIf5KIFlBUUGvuYihA5oCarTRbGMmtFsfI
	r98r2rIssEXRrljsYLH7jq2TEI8q5gHi+KlFWr8c1gka24yIuDUVXae4n0YhuHDyuK+cX6wyyib
	4D5hAuQ9Vujlg4cxGLs/uXbCdMgTXC7SILq/hqeLk2VJ8wF7Vv0D9s6UE330oMjIFIzHBxxBGoN
	eicqKUSMCcKkG9Qoy6/880Pq3zv/o=
X-Received: by 2002:a05:622a:244c:b0:533:9746:9a86 with SMTP id
 d75a77b69052e-535406abef8mr12178981cf.5.1791267811940; Mon, 05 Oct 2026
 23:23:31 -0700 (PDT)
MIME-Version: 1.0
References: <20261005122036.718976-1-senozhatsky@chromium.org> <20261005122036.718976-7-senozhatsky@chromium.org>
In-Reply-To: <20261005122036.718976-7-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 6 Oct 2026 15:22:54 +0900
X-Gm-Features: AclHuK8LYHoepKR1DX5jKzVYXr3tve8RqbZuZnlBMtj7jR1SkDVBcQxir3QS8S0
Message-ID: <CADyq12wEtNYBi=gDaWxMGOaaxTPYj2DKg25YE4owBOxFuSbCpQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] zram: lz4hc: use LZ4_decompress_safe_usingDict()
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6903E1C0005
X-Rspam-User: 
X-Stat-Signature: cjumuj1rywrekh3b16gy8uqz9kn5bozj
X-HE-Tag: 1791267813-658211
X-HE-Meta: U2FsdGVkX1/xN0O4aXNpB6KI2uDt69nFEljfGW2A5X3Pa7Pg3btCpIcCiWOnKmrpFFapf5GKT8P5VXjIsgK96BPrN/UqoFfFEH4y4AQURvJ5sQjXzvnITSnNpVXrrRBIClQ4RxuMl7GiqmVvq2YwNmtJdZMpThbNYFU9mPHO0456qBpHsMG0ESFAYY/D/k2nSOU3KCYZyZgLMwO0G+TRBmiuHwGFhmjcROnMbizxGPiCc3bL3l2xrdXgo0mvg4nrvR4QpISy/Rcj3iOyd1lTH74J6/wbgWTQ+X8PttCmK/AVr+ssb8pPTy+lBKG/xAF/R7CHXYZmmK7BGUNRdLIARPLNvr5GsdrFkJp0sZNOEmry3hu/6S2evnPHnQ0fMphU+rufG1aycLRkMxS5f6gcwPEIEDobV/pa/6LWZMwo0Gw5GBhhD4bFE+zJ3Ftqq7VFg1TQ7jZNCU+MltuYnB8FJN7h1yWoVcro+oNvrwBzrlSFqkLzNuN+Yj5AubD93frV2i+bXLt8VMH/Zw6ZEVxGRhBctWW3F77+SvFGkd+n7NUozhy4G54FwQvgSmKUUDrDdeM3fiB6EuCKj6jqYWZbM95AjmHD4LxoXpw4/9/Ef1f8dTR1VLdnayrYMe4EV6AN2kRiw3XjhvGTGS2TwdhbFUH18qSo61AmLAHiVPnAvLUrc66kcAHxuPDoKMo0ENWjSZXWRHL9Fw1RNICF65RK0EU1iHuCuFP738+9rajZ6KNY/737wbtE51tt7P2FOs5BNeLQsq5YotV/nY/f8uyJEmFK7ZCtA3f3OIYfWYw0mNVS30y3AdU6C9A2JgFwFmOkeZByKOcjtjTtmwMu8I7k6L6p3SpfhEc/vNrbn7vMMLFWmHh2FprorDXml6ZNfnP9zwxPJaxf4xbfm4ieJcsQF8dGGZct880PXK8zfXLCA83JmeTlRBDhFBZo6iVgv7EDCgL2KdoDeev3O7ppto5
 T0umpvyz
 VzQ8XsyotTF0NYv9huajUqU/sCPBtq6JFyBt5Na7+ZmCR3zxhuawTPJ3VwxBWjpgYfbQmKXWWEz6Mr9nv8zuHYyzp8VlpdvXGSVrG7NZ+ebPpmD8OW7MCURV6PR50JNOIBzYMwsV1B3ZAxf1duN6GwnTE51Xyr2ij1AmEOOZcYXLtQobGadRwiP070G+IdOqTgFAYEyy6xSJuQTc5MDVxWtH2kPfERW+O86BUbcRpzSUnxWYq90mdI9/fQizPtG1iVVSwoWeW1JwH7T69ZNk14vJ+Jzs/WuLQEmE/J2dHDco+pekO4NYA5olQ/3kBRkiYlzhHh7oLEnM1K0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 9:21=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Use LZ4_decompress_safe_usingDict() in lz4hc_decompress() to avoid
> needing a per-CPU LZ4_streamDecode_t structure.  Drop struct lz4hc_ctx
> as well and store the compression workspace directly in ctx->context,
> matching backend_lz4.
>
> Using vmalloc(LZ4HC_MEM_COMPRESS) instead of kzalloc() for cstrm when a
> dictionary is configured also avoids power-of-2 page rounding (~256 KB
> rounded up to 512 KB), saving ~252 KB per CPU.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/backend_lz4hc.c | 70 +++++-------------------------
>  1 file changed, 11 insertions(+), 59 deletions(-)
>
> diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/back=
end_lz4hc.c
> index f3656c27af21..b62736b26622 100644
> --- a/drivers/block/zram/backend_lz4hc.c
> +++ b/drivers/block/zram/backend_lz4hc.c
> @@ -4,18 +4,10 @@
>
>  #include <linux/kernel.h>
>  #include <linux/lz4.h>
> -#include <linux/slab.h>
>  #include <linux/vmalloc.h>
>
>  #include "backend_lz4hc.h"
>
> -struct lz4hc_ctx {
> -       void *mem;
> -
> -       LZ4_streamDecode_t *dstrm;
> -       LZ4_streamHC_t *cstrm;
> -};
> -
>  static void lz4hc_release_params(struct zcomp_params *params)
>  {
>         LZ4_streamHC_t *dict_stream =3D params->drv_data;
> @@ -65,61 +57,32 @@ static int lz4hc_setup_params(struct zcomp_params *pa=
rams)
>
>  static void lz4hc_destroy(struct zcomp_ctx *ctx)
>  {
> -       struct lz4hc_ctx *zctx =3D ctx->context;
> -
> -       if (!zctx)
> -               return;
> -
> -       kfree(zctx->dstrm);
> -       kfree(zctx->cstrm);
> -       vfree(zctx->mem);
> -       kfree(zctx);
> +       vfree(ctx->context);
>  }
>
>  static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *c=
tx)
>  {
> -       struct lz4hc_ctx *zctx;
> +       BUILD_BUG_ON(sizeof(LZ4_streamHC_t) !=3D LZ4HC_MEM_COMPRESS);
>
> -       zctx =3D kzalloc_obj(*zctx);
> -       if (!zctx)
> +       ctx->context =3D vmalloc(LZ4HC_MEM_COMPRESS);
> +       if (!ctx->context)
>                 return -ENOMEM;
> -
> -       ctx->context =3D zctx;
> -       if (params->dict_sz =3D=3D 0) {
> -               zctx->mem =3D vmalloc(LZ4HC_MEM_COMPRESS);
> -               if (!zctx->mem)
> -                       goto error;
> -       } else {
> -               zctx->dstrm =3D kzalloc_obj(*zctx->dstrm);
> -               if (!zctx->dstrm)
> -                       goto error;
> -
> -               zctx->cstrm =3D kzalloc_obj(*zctx->cstrm);
> -               if (!zctx->cstrm)
> -                       goto error;
> -       }
> -
>         return 0;
> -
> -error:
> -       lz4hc_destroy(ctx);
> -       return -EINVAL;
>  }
>
>  static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx =
*ctx,
>                           struct zcomp_req *req)
>  {
> -       struct lz4hc_ctx *zctx =3D ctx->context;
>         int ret;
>
> -       if (!zctx->cstrm) {
> +       if (!params->drv_data) {
>                 ret =3D LZ4_compress_HC(req->src, req->dst, req->src_len,
>                                       req->dst_len, params->level,
> -                                     zctx->mem);
> +                                     ctx->context);
>         } else {
>                 /* Cstrm needs to be reset */
> -               memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm=
));
> -               ret =3D LZ4_compress_HC_continue(zctx->cstrm, req->src, r=
eq->dst,
> +               memcpy(ctx->context, params->drv_data, sizeof(LZ4_streamH=
C_t));
> +               ret =3D LZ4_compress_HC_continue(ctx->context, req->src, =
req->dst,
>                                                req->src_len, req->dst_len=
);
>         }
>         if (!ret)
> @@ -131,22 +94,11 @@ static int lz4hc_compress(struct zcomp_params *param=
s, struct zcomp_ctx *ctx,
>  static int lz4hc_decompress(struct zcomp_params *params, struct zcomp_ct=
x *ctx,
>                             struct zcomp_req *req)
>  {
> -       struct lz4hc_ctx *zctx =3D ctx->context;
>         int ret;
>
> -       if (!zctx->dstrm) {
> -               ret =3D LZ4_decompress_safe(req->src, req->dst, req->src_=
len,
> -                                         req->dst_len);
> -       } else {
> -               /* Dstrm needs to be reset */
> -               ret =3D LZ4_setStreamDecode(zctx->dstrm, params->dict,
> -                                         params->dict_sz);
> -               if (!ret)
> -                       return -EINVAL;
> -               ret =3D LZ4_decompress_safe_continue(zctx->dstrm, req->sr=
c,
> -                                                  req->dst, req->src_len=
,
> -                                                  req->dst_len);
> -       }
> +       ret =3D LZ4_decompress_safe_usingDict(req->src, req->dst, req->sr=
c_len,
> +                                           req->dst_len, params->dict,
> +                                           params->dict_sz);
>         if (ret < 0)
>                 return -EINVAL;
>         return 0;
> --
> 2.56.0.rc1.315.gc6ed9934b7-goog
>

