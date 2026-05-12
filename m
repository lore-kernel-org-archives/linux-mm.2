Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C25CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 00:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A5A6B008A; Mon, 11 May 2026 20:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F122B6B008C; Mon, 11 May 2026 20:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F466B0092; Mon, 11 May 2026 20:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D55706B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:58:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 810928C476
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:58:38 +0000 (UTC)
X-FDA: 84756957516.17.B1332C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8617B1C0008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:58:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CX9enUis;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778547516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnM+kQOEfAwMyby04uI+Dbcysga/1z8yhZ/uphfPXu8=;
	b=7J+De1+NK/gRWxg0vvwyCen7l0r70kyOWxuWQyYxZAHpG2q8jBIwTWP+g+HLUecZ4ftdWm
	PjIhEaqNWl01D+Dc+JP9KY6UwqHH+lrKON6oMEOgg8DBLhqohuca2rheGeg2NKdQwLSyts
	TGKDd/Ey6R/At+5bu8y0i2TV8nyynic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778547516; a=rsa-sha256;
	cv=none;
	b=h9t8eis72SeC0zNKJPLPQ7qrPZ6v2D7CBKDX9r8eo0KGLIqBOY709PdJGqFwH72sSbBIoI
	DqEwgHcj6d7qoPN299fzuKDLNI9k8OCULhMrdwkUzs0BBqlxjPYMbLM/sE4jSvajFsbj+O
	Aw6YCpNumFu6hPycULWJvEcbDjfH4fs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CX9enUis;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BCCC44466
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48576C2BD05
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778547515;
	bh=1Z5KFOC0tk0cJMOXdxoTDon4ptApvzj8Exzs5tjqJ0M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CX9enUis7q68YR1TTBdAyuXYKHCb6OCG2/iBeDLQa429MwtqW3vnwD4VuxZjMV61u
	 FMQ9AS7mXmnFR9ZR5emwBZZz0EcgDPiOqX+O+xIN9q7oqmGiNMRj28dL5BQOQ6xuFN
	 2t2rB7GirfZzUwjhAQ9587TpTYaKvTRnHsIEuyx57WcJZu5TcXgf7F2+UErO4jKUjx
	 k0bNGCNg19tp+MfOC4Dt/YArt0kSP1y3J65Rycs4iTRKGc4lHpO2zdpyiyhkWiHfyF
	 S/QEifg9LKgAsZzgdG4/f0xWVnRuZRYnU4kuZ5n5Gy2pSpkFhgeWPI8tvR4RK26skh
	 waWEySPv61heA==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8acb3dab8dfso32857436d6.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 17:58:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9eVyWf4cighKDB6/kyJOV69D7m6WU7lfHc3BBJDek7pV/qySLM24+Blim4beoIC4cjRdRLiOK5LQ==@kvack.org
X-Gm-Message-State: AOJu0YxhgbaFVq/moq3eVXEF7XQ+ri6Ui5AcqvCdVLBFYLZjccYhPv9M
	s5Rm3g/1WSl6R1tMNcEP+Wjza6VGqY/eNVWkmsWF9GUG4cEaaKPNah9irlFfyI+qjIDFxozLzyZ
	tr5EXM0pndiDlwViyZH1+0alcy0Eaozw=
X-Received: by 2002:a05:6214:434a:b0:89a:1536:251f with SMTP id
 6a1803df08f44-8bc449affcbmr413451976d6.28.1778547514415; Mon, 11 May 2026
 17:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260508061910.3882831-1-haowenchao@xiaomi.com> <20260508061910.3882831-2-haowenchao@xiaomi.com>
In-Reply-To: <20260508061910.3882831-2-haowenchao@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 12 May 2026 08:58:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yJ1QCQxdc10wNUkiHW0JfG++oNXXqkzWmuKViz9BjksQ@mail.gmail.com>
X-Gm-Features: AVHnY4KGmEDzQRJu3BEa761d4e2MbpNIXDKl6snrcUCN2QHAntE5tDqWLirNUxU
Message-ID: <CAGsJ_4yJ1QCQxdc10wNUkiHW0JfG++oNXXqkzWmuKViz9BjksQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm/zsmalloc: encode class index in obj value for
 lockless class lookup
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	Minchan Kim <minchan@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8617B1C0008
X-Stat-Signature: 7xhwjyaky3i6p67qtc9jyqh4t9jpnt5c
X-Rspam-User: 
X-HE-Tag: 1778547516-655993
X-HE-Meta: U2FsdGVkX189QrfFsDzmFn5w8kLIJyHc1dy01cpUKRlXB/kkh9s3VDQcXWq/L+gzb4nuZjvwJnIfRiwOGOlz9kQvEtNmElv2QNvgvEVRWcN+Su5EfFzB1I/YhAG2O2dYDWgboJoa50Eo3v1EvFrGIcptikQ2vBjynOT7JAGMXSavdHVIx9boS4/SvxIcfTsairHYW5XayGtPw1FziJ5di8diVjr5b9ubma6G17o9vaO7LEPfkIa82enrRkmREqzQDsxP5w6EelPmyr9LjyPzxjQB/+tP9MW9sK+3cJUFWX/93eBqGSWY4aZciTZlLXVe3tEXKYKXUlHBjP/kQ7MXQlTC/0LjqDloNQTyHBDnS8oyURxPrKsQGXDIaQsgRSk4sI5IopCPuyMWbKc+RfCZTEcSXBWsGuGINkPpStTokpzNgv5QhLvbyTAeDJux43ygHAX4G/WsE2ptJ7yX3eemxFgevyJBlaWbpMcfMQpIBSRO6xzomeU3/Z7AIrue5JR9UObuULxbqzXChL9DGZXRTMNvoe+xIveN785Ub4iaNdNPJFJL8GZ2xTuZFVceMmblmEsssxdYb7X19qit1dx1aSE3CI0O6H3XrM0DeKZAivvzkllvy9fdvBnyDGivV5SqZH5qitlptfcoTawPnxuOk0CigxFIN+TM4zxIkIXJgwekW7X5nHb51BSZaYfHSdy4qQ1SZKqwJSeCV079O59njH1rhiuxGUGWx11t6d5UpDkxQ1kRr6IVD53AvVp8Cp0eYZQXjb4QdyJDpAb2XtGLFZWfi3+JZZNkA9JCHOb29FCJuOBpjcp7+zSdMZSGpUkA7VINDNik8J84h1hUaqMOFvmwI5tkXtwRtlMFTUQUjHnEkCBz89jWZoCM9oCAqZi/t9+gmr5MbdiBKHzexpghWf5nC8U8uV///gLtXJ53uTxFw18jh6VjuMD3wEKpOeWymiEM6dw4eEF18vwB/rl
 GPGHB9N4
 EhjGPLoYnoXZgJSoQeiSdiJKOZ4b6jE15fVEkx+QcElcWyYogsIQibpqQ2en7wCBzMpCUqVIEd1Y2zQRBequUYc17u4hMMYoanH1ABmaYIqV/M3iJ27qY1Ob/Ffy5uFl3TWcS/yFZegjCSweWzyWgHZa8Q4gvqwhyrsiVjEYblXkeEnOlZKhMc2eXKa5+RbsQVmughU6RTCjcgGDRn3Mq5wdbVqUYBfofMNJSohRrby7PucLuTFhAAg9CYnDQMI/rGtWarQfd9cFBJ5t+69Dqrvcx2vR7Rb0TT4S3F3WncO+fSJfTx4Y4vkFpxQEBmiK7DA2nKttc7hFgvdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 2:19=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com>=
 wrote:
>
> Encode the size class index (class_idx) into the obj value so that
> zs_free() can determine the correct size_class without dereferencing
> the handle->obj->PFN->zpdesc->zspage->class chain under pool->lock.
>
> OBJ_INDEX_BITS is over-provisioned on 64-bit systems.  For example on
> arm64 with default chain_size=3D8: OBJ_INDEX_BITS=3D24 but only 10 bits
> are actually needed for obj_idx.  We dynamically compute OBJ_CLASS_BITS
> as ilog2(ZS_SIZE_CLASSES - 1) + 1 (8 bits for 4K pages, 9 for 64K)
> and verify at compile time via static_assert that the three fields
> (PFN + class_idx + obj_idx) fit within BITS_PER_LONG.
>
> This encoding is gated by ZS_OBJ_CLASS_IDX, defined only when
> BITS_PER_LONG >=3D 64.  On 32-bit systems the bits do not fit, so
> the feature is disabled and the original OBJ_INDEX layout is preserved.
>
> Split OBJ_INDEX into class_idx and obj_idx:
>
>   obj: [PFN | class_idx | obj_idx]
>        [_PFN_BITS | OBJ_CLASS_BITS | OBJ_IDX_BITS]
>
> class_idx is invariant across page migration (only PFN changes), so a
> lockless read always yields a valid class_idx.
>
> Update obj_to_location(), location_to_obj() and callers accordingly.
> Add obj_to_class_idx() helper.  Adjust ZS_MIN_ALLOC_SIZE to use
> OBJ_IDX_BITS.
>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> ---
>  mm/zsmalloc.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 88 insertions(+), 7 deletions(-)
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 63128ddb7959..bccadf0a27f2 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -96,11 +96,74 @@
>  #define CLASS_BITS     8
>  #define MAGIC_VAL_BITS 8
>
> +/*
> + * Optionally encode the size class index in the obj value so that
> + * zs_free() can look up the correct class without holding pool->lock.
> + *
> + * Rather than fixing a hard CLASS_BITS constant for the class_idx field=
,
> + * we compute the minimum bits needed from the actual number of size cla=
sses
> + * and the actual maximum obj_idx, then check whether they all fit:
> + *
> + *   _PFN_BITS + OBJ_CLASS_BITS_NEEDED + OBJ_IDX_BITS_NEEDED <=3D BITS_P=
ER_LONG
> + *
> + * This naturally handles all architectures and PAGE_SIZE configurations=
:
> + *
> + *  - 32-bit: BITS_PER_LONG=3D32, sum easily exceeds 32 --> disabled.
> + *  - powerpc64 64K pages: ZS_SIZE_CLASSES=3D257 --> OBJ_CLASS_BITS_NEED=
ED=3D9,
> + *    but the sum still fits in 64 bits --> enabled.
> + *  - riscv64 Sv57: _PFN_BITS=3D44, tight but still fits --> enabled.
> + *
> + * When enabled, obj layout is:
> + *
> + *  63                                              0
> + *  +-----------+--------------+-------------+
> + *  |    PFN    |  class_idx   |   obj_idx   |
> + *  | _PFN_BITS |OBJ_CLASS_BITS| OBJ_IDX_BITS|
> + *  +-----------+--------------+-------------+
> + *
> + * Migration only rewrites PFN; class_idx and obj_idx are invariant,
> + * so a lockless read of obj always yields a valid class_idx.
> + */
> +
> +#if BITS_PER_LONG >=3D 64
> +#define ZS_OBJ_CLASS_IDX
> +#endif
> +
> +#ifdef ZS_OBJ_CLASS_IDX
> +
> +/* ZS_SIZE_CLASSES computed conservatively with original OBJ_INDEX_BITS =
*/
> +#define ZS_MIN_ALLOC_SIZE_FULL \
> +       MAX(32, (CONFIG_ZSMALLOC_CHAIN_SIZE << PAGE_SHIFT >> OBJ_INDEX_BI=
TS))
> +#define ZS_SIZE_CLASSES_FULL \
> +       (DIV_ROUND_UP(PAGE_SIZE - ZS_MIN_ALLOC_SIZE_FULL, \
> +                     PAGE_SIZE >> CLASS_BITS) + 1)
> +
> +#define ZS_MAX_OBJ_COUNT_FULL \
> +       (CONFIG_ZSMALLOC_CHAIN_SIZE * PAGE_SIZE / 32)
> +#define OBJ_CLASS_BITS_NEEDED  (ilog2(ZS_SIZE_CLASSES_FULL - 1) + 1)
> +#define OBJ_IDX_BITS_NEEDED    (ilog2(ZS_MAX_OBJ_COUNT_FULL - 1) + 1)
> +
> +static_assert(_PFN_BITS + OBJ_CLASS_BITS_NEEDED + OBJ_IDX_BITS_NEEDED
> +             <=3D BITS_PER_LONG,
> +       "zsmalloc: class_idx + obj_idx + PFN do not fit in obj on this co=
nfig");
> +
> +#define OBJ_CLASS_BITS         OBJ_CLASS_BITS_NEEDED
> +#define OBJ_IDX_BITS           (OBJ_INDEX_BITS - OBJ_CLASS_BITS)
> +#define OBJ_IDX_MASK           ((_AC(1, UL) << OBJ_IDX_BITS) - 1)
> +#define OBJ_CLASS_MASK         ((_AC(1, UL) << OBJ_CLASS_BITS) - 1)
> +
> +#else /* !ZS_OBJ_CLASS_IDX */
> +
> +#define OBJ_IDX_BITS           OBJ_INDEX_BITS
> +#define OBJ_IDX_MASK           OBJ_INDEX_MASK
> +
> +#endif /* ZS_OBJ_CLASS_IDX */

This is quite confusing. Can we rename OBJ_INDEX_BITS,
OBJ_IDX_BITS, etc., to something more meaningful?

I guess OBJ_CLASS_BITS could be defined as 0 for 32-bit
builds, which would let us remove many of the ifdefs?

> +
>  #define ZS_MAX_PAGES_PER_ZSPAGE        (_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, =
UL))
>
>  /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
>  #define ZS_MIN_ALLOC_SIZE \
> -       MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS)=
)
> +       MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_IDX_BITS))
>  /* each chunk includes extra space to keep handle */
>  #define ZS_MAX_ALLOC_SIZE      PAGE_SIZE
>
> @@ -722,7 +785,7 @@ static void obj_to_location(unsigned long obj, struct=
 zpdesc **zpdesc,
>                                 unsigned int *obj_idx)
>  {
>         *zpdesc =3D pfn_zpdesc(obj >> OBJ_INDEX_BITS);
> -       *obj_idx =3D (obj & OBJ_INDEX_MASK);
> +       *obj_idx =3D (obj & OBJ_IDX_MASK);
>  }
>
>  static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
> @@ -730,17 +793,29 @@ static void obj_to_zpdesc(unsigned long obj, struct=
 zpdesc **zpdesc)
>         *zpdesc =3D pfn_zpdesc(obj >> OBJ_INDEX_BITS);
>  }
>
> +#ifdef ZS_OBJ_CLASS_IDX
> +static unsigned int obj_to_class_idx(unsigned long obj)
> +{
> +       return (obj >> OBJ_IDX_BITS) & OBJ_CLASS_MASK;
> +}
> +#endif
> +
>  /**
> - * location_to_obj - get obj value encoded from (<zpdesc>, <obj_idx>)
> + * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj =
value
>   * @zpdesc: zpdesc object resides in zspage
>   * @obj_idx: object index
> + * @class_idx: size class index (used only when ZS_OBJ_CLASS_IDX is defi=
ned)
>   */
> -static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int=
 obj_idx)
> +static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int=
 obj_idx,
> +                                    unsigned int class_idx)
>  {
>         unsigned long obj;
>
>         obj =3D zpdesc_pfn(zpdesc) << OBJ_INDEX_BITS;
> -       obj |=3D obj_idx & OBJ_INDEX_MASK;
> +#ifdef ZS_OBJ_CLASS_IDX
> +       obj |=3D (unsigned long)(class_idx & OBJ_CLASS_MASK) << OBJ_IDX_B=
ITS;
> +#endif
> +       obj |=3D obj_idx & OBJ_IDX_MASK;

Can we avoid using these "ifdef ZS_OBJ_CLASS_IDX" blocks entirely?

>
>         return obj;
>  }
> @@ -1276,7 +1351,7 @@ static unsigned long obj_malloc(struct zs_pool *poo=
l,
>         kunmap_local(vaddr);
>         mod_zspage_inuse(zspage, 1);
>
> -       obj =3D location_to_obj(m_zpdesc, obj);
> +       obj =3D location_to_obj(m_zpdesc, obj, zspage->class);
>         record_obj(handle, obj);
>
>         return obj;
> @@ -1762,7 +1837,13 @@ static int zs_page_migrate(struct page *newpage, s=
truct page *page,
>
>                         old_obj =3D handle_to_obj(handle);
>                         obj_to_location(old_obj, &dummy, &obj_idx);
> -                       new_obj =3D (unsigned long)location_to_obj(newzpd=
esc, obj_idx);
> +#ifdef ZS_OBJ_CLASS_IDX
> +                       new_obj =3D (unsigned long)location_to_obj(newzpd=
esc,
> +                                       obj_idx, obj_to_class_idx(old_obj=
));
> +#else
> +                       new_obj =3D (unsigned long)location_to_obj(newzpd=
esc,
> +                                       obj_idx, 0);
> +#endif

Maybe we can define __obj_to_class_idx() as a static inline
returning 0 for 32-bit builds.

>                         record_obj(handle, new_obj);
>                 }
>         }
> --
> 2.34.1
>

