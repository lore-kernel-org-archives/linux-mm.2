Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F231F606A6BE
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eD3UxuoS
Received: by kanga.kvack.org (Postfix)
	id 7B5EF6B00EF; Fri, 20 Nov 2026 18:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 766A66B05B0; Fri, 20 Nov 2026 18:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655926B05B1; Fri, 20 Nov 2026 18:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 380536B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:46:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6176160258
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:46:06 +0000 (UTC)
X-FDA: 85457133132.24.4CF6F57
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 884B7180004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:46:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eD3UxuoS;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795218364;
	b=5W1FjvzMQuhsCEPe4ykQoYE/3Knj7NXgYpSlWCQh2Jjb7MzEiLGHQDPW38Y3DgxOIdFKrZ
	luHLuNUW+ysv9IPik5Gu4wfA/vn5A05/WLQ/NqCU0SNO7XwURxCySJyVFvL+Pl+lBqO5yH
	QKMrqVSO+KcA3GmsVmW1RiOiNULM/WI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795218364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TF/OrXQqNDrjszpeflyaDCo7TdpIhYTZUC07gi7hq5U=;
	b=RaTj1FtKu+YEUulUCkH/99Zoeqh/1N1Ptzjsc/gl39J0pSJNWdO2/aXkWyP/+cH4NVJR9r
	jszTQJe10BICwudi60210UXI5lqyAiUPmYBgxtMVnP1sUPHj9EV7RiPVmHH6GKypX9YZhz
	EblpcnTkKSzxjgdLoWN3WQI6fVLY9C0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eD3UxuoS;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4a7b8abe209so1120241f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:46:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795218363; cv=none;
        d=google.com; s=arc-20260327;
        b=ohtMkEvP+MCAiZaYoY6fcNeb2nx35rnRuDVKEBmxRmkZZiEY72aW07SA7C6VmsX5TK
         BkL0p0aFBQEtS6VmklveWnlFZWl1w+/Xdp22aNDWBoQWndYOXeddGv6eyqALZjb7KHKf
         KXMuQXduqJjvz5yTjd31kdXRiwX+v3r1PlN+poMZVVOBmDB/91zymwbxVpt8XQu0ZRvK
         rp045n05+e6oEhOAlLGCo6vxMNnVN+UkjsZomDWWZcgl2/sMSFrwKZ2Pp6A/7Hodx2Gz
         rxn2sj3KZPxf+sv46fouU1MnzeKV7xofql0/UXm20/ETrmuDjNvnoXo0ITbuAfNnclCJ
         Dung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TF/OrXQqNDrjszpeflyaDCo7TdpIhYTZUC07gi7hq5U=;
        fh=eIXFhu6Rer9teu2QPcaTUzKb/qX5szqvV66qIIIJIcA=;
        b=LKiSchbwgd9i6bW1y6uTl/4FQw5igMWWO6iIrLST2dIsjRykWhAFmLY7Oc1An5JzjO
         Zq1WYUm61l6boZDYRGwqsBuS6m5OFddJ4nKmWMcDE61gJMT9x8bekvqMDuNnCpWK/6Yi
         /1Ft2bIL+0rgIIACI9rk0YDqJxVnKudUmlXs4LKrUT7yg0u7nuUHkXY0JTjJJdDuhk74
         uZSR8oP65q+gtx/lPEa+Ux+lj2daDqGWMxBDo6ghxzU4jz1oc5ZP+Q8oEkWEce79UcmY
         aKwwp0r0aeGQ3l2mxlitrGvctd2bHF09OG9XSuihdYCZtogP8ghai4XBQq1eg35/psrl
         62jg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795218363; x=1795823163; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TF/OrXQqNDrjszpeflyaDCo7TdpIhYTZUC07gi7hq5U=;
        b=eD3UxuoSVXcOGVT3Z897HXZMewUXRWke69R3nljVcNGnfinRZDs3sE4fNak2t73mqT
         RO+2GzoI4Yc7/JwE+2dUu2q5M2juv5GWhFJamvhOQnQtjPGJ4/cUwMG+4DiXi2zA4yfI
         c0tAUBLCbPPXow9onPprLIOqQxlYjmWlwqvw7XBmGqP6BN42ExUYhS3DWpYE8SJaDGUP
         ZuKAb3FAfnFJvxgKZkGZxH5SxUvxsJVdtWdCrC3yyvyjh33yfrRVsPd1qu1BJAqqwZ1c
         NS4uBZlgoNPqmKMUUDjw8aNa8rGD7dJEqdOzGH2uY9NexTIwq7HI/VgZH58lpU9SM3rQ
         dN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795218363; x=1795823163;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TF/OrXQqNDrjszpeflyaDCo7TdpIhYTZUC07gi7hq5U=;
        b=joV7fx6KyVlgj2WULUN6M+8D17b8ju8xsRaMba1GkGpB4TMJVYGeA72WllVpeN9ub+
         jCjZfH7Mn3wYwwstpzwMz346/S9KyIIPBVxlN0y1Y5d0W8hU5N34Tge4Ty4fUYjm+Bo+
         vC0FMdrqVR+WMMjrIOy/827FTsOBpc8PJhc0XqR5lYF+Pgb55V3ObN7VTmyk2k6bFEoD
         mYludiAWiecuSuAxg+6nzP/kjyPmooNDVmK3GX0YjWJGxuL0sONDewRw4pL5WfHmv9SB
         xXamKMAbfpTDZBxYKd9h8QhTIcDkeGeDhev8AXbnW75m/yQkyJIaMHcJ6Jt5C721k9XW
         e3VQ==
X-Forwarded-Encrypted: i=1; AL+hErEOq8HCg6geVvTkfj7q6t0Tdk3v+q3oPiF2aQwj1kxEeo7mdj3s/ciW9fpx2dgqo+1HAmPFsJjdwg==@kvack.org
X-Gm-Message-State: APuU4Z8Yfk/C93KbLEaiBqXrgnerF04NGxi/1yepVT5hlSg1NsKdFFQA
	kJ9IFWHCHN/VBhQ90a1kgtcEgfkZxUqYNzU/SCpM0w7KxBCNjvaZ2979POKxuWnFlc35PQ/FwWt
	ikUSrxYpPEgv/GJDdFuunIpILHAd4h90=
X-Gm-Gg: AZFdTZdnMgq5oTarWh9Ymsgpv+x1lefjZSU3gBQiaXXQbH+mM3+Xc6yJA04JGRhX1GG
	1xCdqtR1PN6gjdD/bux4SN9lWoDSq7y1drASp7iG+e0bhMzSHL/ji3s6yVfVy27A5dS49iSSToB
	mgMODLIoLti4AhYfPZ7hWCLEd/qdt33MeDFbcsYw790W4BoBtTCeiTf1h7K0cebmb4p1RJ5QyTA
	oIwpj8AZMdsediu6wz2y/FaFt84pLEVdqc6DSy0emnGIP6PFC0hU0/ogD3Gxejgu9a2Qq8X2aaY
	1rlMx/NJ1+95AjItfklTXtHoIuwThqX3HnF2RiA1SEFcpnotnbEOOaYOLsEUx4+7gKMqIrVx7P3
	GD4Mca9Rzt/wdXL3oJ/sjIhDGtsPdLTvKlD1TqdxPKR9Zrj64FLxVfk+yEDojZleCYcaK7viqZr
	MvP3bTnI54Trrcr4KhQCukqUVZsERDw52EnBFwAu6GVmY2sAhChICnpxOHEGJuF/2hY299EsAz8
	T3t
X-Received: by 2002:a05:6000:29ce:b0:4aa:6e52:23a9 with SMTP id
 ffacd0b85a97d-4abb0e46a60mr7207679f8f.15.1795218362987; Fri, 20 Nov 2026
 15:46:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <20261120041906.5785-8-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-8-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 15:45:51 -0800
X-Gm-Features: Aa3M54qBweF4AdtgZgj0DVvcadIsjWZqHEyP6IMH8n9Wq-G2vfGRxjefsq91gJw
Message-ID: <CAKEwX=PuyT7WhrA3nEQQTyw1H_5D_ZxEcSZYQSF0MyUTii36MQ@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 884B7180004
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9rec1r5tigwne6yrhj5ku4m1j73dinjt
X-HE-Tag: 1795218364-783882
X-HE-Meta: U2FsdGVkX1/38IfC3Ji3V5vMgTBy0ig5enaEpUTG5Oej+4foy/lFygB12or6Q4wrYxojuLj47IaqD0lTIAdh86hDJOVQdTupyLElswpprgNiQt3rMR2T9NxtQOWhNbDiiHApmlhBwRcrgfns4cvxXsQ8dqSyNJOb2FVEmOgcx9V1PPqFyiv+KQtNnueqqJsRrfj67h2A7P5DR5IVkEqwHaZiqBjSAgoopI5fNxEb6GxkbRkQ7pd++xShlH0MHfoopV/3VuREw3lKAwDmg7nJzUt5yp8hHvhfC3vnYOX4KnTK77lr6s+yWjr3RZ7+tdA7dyxngi0leXsuvHSdeiX6jUNiVqTbU5yHxXb20NoNQ+YJG09WXN8MRVpIaizfhZFzi2oS83OAViTKt8NB+Bg4YbcndU+NoCFMqYaAk/iswUE8s74pMERtCqj6ApAcHv7e4wJwLwmJpoESJ3Mb3O/YiZgRxIwuLr6gAGwALGt0E58G4xO3noxEffQQarezYiceIH1SWzUyXQ+QHrGxU2EXpGJxW76nQPzM6EvwbShrhx4G+ej3fWdqCAq3Vx/FkZiiMSG2m+gfPBX+Vpr+SImlJVHkX4Ium35Ml5l3tgX4tQbGEMDJLR6zZSyuUgxiH8gL65ZMLr7WSksS7+W68WhVvUDj4A54y6dtFLc6Um8mPoh5kcfIyj3x/svxRJtzpuR+PGTdg5zAx2X66E0BK63GPA5KNgZF5ISMIMYc3lV/PJfAucLaVbItS1nV+J9CeeHdD6trhU2m7KF8NIixTMUK9AxW81Xsz7s/fewguTbuqd6uK/wVCey0yEMtBydt6LAa+lrZxmDNTFHSdfO92WK78s6ucsIHDrHtDHAHxCyQBUnLY/2gYo/Vwt58/RilpvpT+XIaVNDSRIqWuVbmDdnt+pxeQqw3FEgTDvNe6utVFFtwxD7nSkEd52r0MnujypWHTo25zVodI3j7YM7YMwa
 SJ3AK6Gi
 d3QUm66XGEc39UV3CNgH9ThzvQEhUtV2HsJGocK91sivByCHb9XC1SMCu7GwthmXEfyenwnKoSg3j3NF5jI2EdDp/ZKqMYhj6A+bERuA4snDHPjPmKY5IrahqkX5mZkN2Hifggltei6yfuF+jKwijNxMvTZGSrs954iEuyDdUTD1bM92Fdi3RwtBECCUIrnqan4Ka30pnHlMeVXxRChyuw5fLnGYccy+sJByA94vDNVcqhoR0Vwu971bCeWmnMgIU/wcgyVG65uphNhowm8sK5Z86Mn01X3Rne7DZSskZ82ExJkk+noacNAOfia/qRyaON18Ll8A5QfqU0+yIlUrKkcpOm/w2MR7XaMwCgMXVYvCVScHU550r0EMPNSgZOFwqwk9YnW2UoINFnFm2oa8kx+IzFp+LmEKBtrB/I2CO2KmQUa1lKh+0LbGGTi9s+KqGA0GQ22km4XOqs26UjJRh02q7V2fj4JInDU0RDT5JcylQ1sISSt97mLG3OPsf90jv7UQ7fJ+s3kWxGfLPnGyOLuJaK6jvTKiEq58MsQlRtt93NFn+Q+DGUn+NEQPqNYNAZ51WehEyQhNvmik8FDYdvub8W3/bYwtpHmpZChfNZEPby+8OPRdvT8ssMj/kQETlrjyJbjJAc0OaQIlGeZMwRvLwkD3LjJ717bwlTCxEUI6ZeN0g2jL2fX9sYl3m4PQZ/vPT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> Subsequent patch series will be submitted, that implement ideas building
> upon this batching framework:
>
>  1) Replacing zsmalloc with SLUB allocator, comprising of kmem_caches
>     for a finite # of compressed size bins. This enables bulk allocation
>     of compressed buffers in a batch that belong to the same size
>     bin. It gets rid of significant zsmalloc latency overhead (locks,
>     compressed data spanning zspages, etc.), without compromising memory
>     efficiency.

I don't think this will be a good idea, because it will make
compressed memory unmovable.

>
>  2) vmscan reclaim batching of hybrid any-order folios, that will submit
>     a batch of folios to zswap_store()'s batching framework to optimize
>     storing of batches of pages from different folios, in addition to
>     within large folios.

This one might be more complicated than its worth, but I'm not sure.

>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

Code mostly LGTM.

> ---
>  include/linux/memcontrol.h |  12 +++
>  mm/memcontrol.c            |  23 ++++-
>  mm/zswap.c                 | 181 +++++++++++++++++++++++++------------
>  3 files changed, 153 insertions(+), 63 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 980358bc6f49..93f060818c14 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1244,6 +1244,11 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgro=
up_subsys_state *css)
>         return NULL;
>  }
>
> +static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
> +                                      unsigned long nr)
> +{
> +}
> +
>  static inline void obj_cgroup_get(struct obj_cgroup *objcg)
>  {
>  }
> @@ -1921,6 +1926,8 @@ static inline void mem_cgroup_calculate_protection_=
path(struct mem_cgroup *root,
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
>  bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
>  void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
> +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
> +                                 u8 nr_pages, u8 nr_incomp_pages);
>  void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
>  bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
>  #else
> @@ -1932,6 +1939,11 @@ static inline void obj_cgroup_charge_zswap(struct =
obj_cgroup *objcg,
>                                            size_t size)
>  {
>  }

Why do we still need obj_cgroup_charge_zswap() at all?

> +static inline void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg=
,
> +                                               size_t size, u8 nr_pages,
> +                                               u8 nr_incomp_pages)
> +{
> +}
>  static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
>                                              size_t size)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..2236f5ba6304 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6345,6 +6345,23 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg=
)
>   * compression and storage in zswap for this cgroup to go ahead.
>   */
>  void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
> +{
> +       obj_cgroup_charge_zswap_many(objcg, size, 1, (u8)(size =3D=3D PAG=
E_SIZE));
> +}
> +
> +/**
> + * obj_cgroup_charge_zswap_many - bulk charge compression backend memory
> + *                                from compressing a batch of pages.
> + * @objcg: the object cgroup
> + * @size: total compressed length of a batch of compressed objects
> + * @nr_pages: # of pages that were compressed to store in zswap
> + * @nr_incomp_pages: # of incompressible pages to store in zswap
> + *
> + * This forces the charge after obj_cgroup_may_zswap() allowed
> + * compression and storage in zswap for this cgroup to go ahead.
> + */
> +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
> +                                 u8 nr_pages, u8 nr_incomp_pages)
>  {
>         struct mem_cgroup *memcg;
>
> @@ -6363,9 +6380,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *obj=
cg, size_t size)
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> -       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> -       if (size =3D=3D PAGE_SIZE)
> -               mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
> +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
> +       if (nr_incomp_pages)
> +               mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_page=
s);
>         rcu_read_unlock();
>  }
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index df59ab0c1029..5e1fb5624ffb 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -491,12 +491,12 @@ static int __must_check zswap_pool_tryget(struct zs=
wap_pool *pool)
>  }
>
>  /* The caller must already have a reference. */
> -static void zswap_pool_get(struct zswap_pool *pool)
> +static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
>  {
> -       percpu_ref_get(&pool->ref);
> +       percpu_ref_get_many(&pool->ref, nr);
>  }
>
> -static void zswap_pool_put(struct zswap_pool *pool)
> +static inline void zswap_pool_put(struct zswap_pool *pool)
>  {
>         percpu_ref_put(&pool->ref);
>  }
> @@ -1603,55 +1603,60 @@ static void shrink_worker(struct work_struct *w)
>  * main API
>  **********************************/
>
> +/* Functions called by zswap_store(), that operate on batches of pages. =
*/
> +
>  /*
> - * Store multiple pages in @zc->folio, starting from the page at index @=
start up
> - * to the page at index @end-1.
> + * zswap_init_entries() co-locates most of the zswap entry fields' setup=
 under
> + * the assumption that all phases of store processing will succeed. An i=
mportant
> + * marker to simplify catch-all cleanup in zswap_store_pages() is done b=
y
> + * initializing each entry's @handle to ERR_PTR(-EINVAL).
>   */
> -static bool zswap_store_pages(struct zswap_store_context *zc,
> -                             long start,
> -                             long end,
> -                             struct zswap_pool *pool,
> -                             struct obj_cgroup *objcg)
> +static inline void zswap_init_entries(struct zswap_store_context *zc,
> +                                     struct zswap_pool *pool,
> +                                     struct obj_cgroup *objcg)
>  {
> -       u8 i, store_fail_idx =3D 0;
> -       bool ret;
> -
> -       zc->nr_pages =3D end - start;
> -       zc->folio_start =3D start;
> -
> -       VM_WARN_ON_ONCE(zc->nr_pages <=3D 0 || zc->nr_pages > ZSWAP_MAX_B=
ATCH_SIZE);
> -
> -       ret =3D zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
> -       if (unlikely(!ret))
> -               return false;
> +       struct zswap_entry *entry;
> +       u8 i;
>
>         /*
>          * We co-locate entry initialization as much as possible here to
>          * minimize potential cache misses.
>          */
>         for (i =3D 0; i < zc->nr_pages; ++i) {
> +               entry =3D zc->entries[i];
>                 /*
> -                * Set pool_idx before the xa_store() below publishes the=
 entry, or a
> -                * concurrent reader could resolve a stale pool_idx left =
by slab reuse
> -                * to an unrelated live pool.
> +                * Set pool_idx before the xa_store() in zswap_tree_store=
s()
> +                * publishes the entry, or a concurrent reader could reso=
lve a
> +                * stale pool_idx left by slab reuse to an unrelated live=
 pool.
>                  */
> -               zc->entries[i]->pool_idx =3D pool->idx;
> -               zc->entries[i]->swpentry =3D folio_swap_entry(zc->folio,
> +               entry->pool_idx =3D pool->idx;
> +               entry->swpentry =3D folio_swap_entry(zc->folio,
>                                                         zc->folio_start +=
 i);
> -               zc->entries[i]->objcg =3D objcg;
> -               zc->entries[i]->referenced =3D true;
> -               zc->entries[i]->nid =3D zc->nid;
> -               INIT_LIST_HEAD(&zc->entries[i]->lru);
> +               entry->objcg =3D objcg;
> +               entry->referenced =3D true;
> +               entry->nid =3D zc->nid;
> +               INIT_LIST_HEAD(&entry->lru);
>         }
> +}
>
> -       for (i =3D 0; i < zc->nr_pages; ++i) {
> -               if (!zswap_compress(zc->folio, zc->folio_start + i,
> -                                   zc->entries[i], pool, zc->wb_enabled)=
)
> -                       goto store_pages_failed;
> -       }
> +/*
> + * zswap_tree_stores() stores the batch entries in xarray and adds them =
to the
> + * zswap LRU list. If an error occurs during xa_store(), localized state
> + * unwinding is done to erase prior batch entries from the xarray and de=
lete
> + * them from the zswap LRU list. Remaining batch cleanup occurs in
> + * zswap_store_pages(). As batch entries are processed, we maintain aggr=
egate
> + * statistics to do the accounting in one bulk operation.
> + */
> +static bool zswap_tree_stores(struct zswap_store_context *zc,
> +                             struct zswap_pool *pool,
> +                             struct obj_cgroup *objcg)
> +{
> +       u8 i, store_fail_idx =3D 0, nr_incomp =3D 0;
> +       size_t total_batch_comp_length =3D 0;
> +       struct zswap_entry *old, *entry;
>
>         for (i =3D 0; i < zc->nr_pages; ++i) {
> -               struct zswap_entry *old, *entry =3D zc->entries[i];
> +               entry =3D zc->entries[i];
>
>                 old =3D xa_store(swap_zswap_tree(entry->swpentry),
>                                swp_offset(entry->swpentry),
> @@ -1663,13 +1668,11 @@ static bool zswap_store_pages(struct zswap_store_=
context *zc,
>                         zswap_reject_alloc_fail++;
>                         /*
>                          * Entries up to this point have been stored in t=
he
> -                        * xarray. zswap_store() will erase them from the=
 xarray
> -                        * and call zswap_entry_free(). Local cleanup in
> -                        * 'store_pages_failed' only needs to happen for
> -                        * entries from [@i to @nr_pages).
> +                        * xarray. Local cleanup in 'tree_store_failed' n=
eeds to
> +                        * erase entries up until now.
>                          */
>                         store_fail_idx =3D i;
> -                       goto store_pages_failed;
> +                       goto tree_store_failed;
>                 }
>
>                 /*
> @@ -1680,22 +1683,10 @@ static bool zswap_store_pages(struct zswap_store_=
context *zc,
>                 if (unlikely(old))
>                         zswap_entry_free(old);
>
> -               /*
> -                * The entry is successfully compressed and stored in the=
 tree,
> -                * and further failures will be cleaned up in zswap_store=
().
> -                * Grab refs to the pool and objcg, charge zswap memory, =
and
> -                * increment zswap_stored_pages. The opposite actions wil=
l be
> -                * performed by zswap_entry_free() when the entry is remo=
ved
> -                * from the tree.
> -                */
> -               zswap_pool_get(pool);
> -               if (objcg) {
> -                       obj_cgroup_get(objcg);
> -                       obj_cgroup_charge_zswap(objcg, entry->length);
> -               }
> -               atomic_long_inc(&zswap_stored_pages);
> +               total_batch_comp_length +=3D entry->length;
> +
>                 if (unlikely(entry->length =3D=3D PAGE_SIZE))
> -                       atomic_long_inc(&zswap_stored_incompressible_page=
s);
> +                       ++nr_incomp;
>
>                 /*
>                  * We finish by adding the entry to the LRU while it's al=
ready
> @@ -1711,17 +1702,87 @@ static bool zswap_store_pages(struct zswap_store_=
context *zc,
>                         zswap_lru_add(entry);
>         }
>
> +       /*
> +        * Each batch entry is successfully compressed and stored in the =
tree,
> +        * and further failures will be cleaned up in zswap_store().
> +        * Next, we do bulk accounting for the batch: grab refs to the po=
ol and
> +        * objcg, charge zswap memory, increment zswap_stored_pages and
> +        * zswap_stored_incompressible_pages. The opposite actions will b=
e
> +        * performed by zswap_entry_free() when the entry is removed from=
 the
> +        * tree.
> +        */
> +       zswap_pool_get_many(pool, zc->nr_pages);
> +       if (objcg) {
> +               obj_cgroup_get_many(objcg, zc->nr_pages);
> +               obj_cgroup_charge_zswap_many(objcg, total_batch_comp_leng=
th,
> +                                            zc->nr_pages, nr_incomp);
> +       }
> +       atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> +       if (unlikely(nr_incomp))
> +               atomic_long_add(nr_incomp, &zswap_stored_incompressible_p=
ages);
> +
> +       return true;
> +

Can you add a comment that we only clean up the current batch here,
and the clean up of other batches in the folio are deferred to
zswap_store() (or whereever up the stack it is handled?).

> +tree_store_failed:
> +       for (i =3D 0; i < store_fail_idx; ++i) {
> +               xa_erase(swap_zswap_tree(zc->entries[i]->swpentry),
> +                        swp_offset(zc->entries[i]->swpentry));

xas API?

> +               zswap_lru_del(zc->entries[i]);
> +       }
> +
> +       return false;
> +}
> +
> +/*

