Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69584CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 22:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A68C6B0005; Fri, 29 May 2026 18:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E446B0088; Fri, 29 May 2026 18:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645736B008A; Fri, 29 May 2026 18:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55E296B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:50:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB6811C0428
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:50:05 +0000 (UTC)
X-FDA: 84821951970.28.A5EA6AA
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA0B1140010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:50:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l3zPa9QK;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780095004; a=rsa-sha256;
	cv=pass;
	b=SYNb7DT5mGTwTouk692YUzidVEstuwonWYtCZ+wXwMsxMYnLR//IgXPMTfpSnKvVdWL+1B
	N2m9nbMqGUaRSSMCpFDSRbXzUQ0IumAzyLaJUMrY+aRHeV/vOWc9CiRYgTnSMBL3sPHLZt
	0POu5BZOSEn2lU5p8C7pmChVttQ0n9w=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l3zPa9QK;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780095004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvEio31Zi6ONGWKOwZdzq6U/5CmPfd2xjkBbuFVZMSE=;
	b=49zfp+iwswY0Ssq7sLw2xc8SOUaHFsR8G/ouZa9gWB1jN81e8mAm2wkvxwuogmFjjuS8K7
	XdBA6xvtUFU8LO+66l0ifpPAXiyWK0hPzE2qp1kL48XLWBgTJeMHMy3OrVTcVYr7/thuyM
	nQa8BSd1vh80NjeIyTD+N2MDjBoqcrc=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso68820935e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 15:50:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780095002; cv=none;
        d=google.com; s=arc-20240605;
        b=fkVcsYGpUKEe8WStuvwZYpRowe1EQ7evunoep/K4MvLB6c3Iu0u4lwFV/2OjvRgQbY
         3NWsiut8UE6bgbqC7rMgkKrDtjXC24/tyWG+vTJA4FzB8DgkLOW7V90IGKYCuFcEvqDa
         wQdoc1G+qpwc5nCw2chgpZ+8WVdXMK3gsnvS3lLRQowoJVi51hhSq6j2F0Wu+cTV0ZF9
         CfEVwHPbpL8dr+xNIPP7YaDlS4pkWg6zP65bCqeBWbAql6FJ3ZvIORyXqd2qWqyX3iVQ
         OicGvcgS6r5vhJ5m1mk8xuO7PUQLyNUSPZKUUa7gVWx8r8RuFxDmcOpMl3KqkqpEZD7H
         4j+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HvEio31Zi6ONGWKOwZdzq6U/5CmPfd2xjkBbuFVZMSE=;
        fh=Q4CenMv9+zzcuvf49PaA2jfoV+vjdJ80upj35JM3/pg=;
        b=P4ABPWdfhfQ/uQ8BbFrgXdjnxj12ru+nq5GEe1VB1Qy+rD5WIuIOoAYFbj05VTI3AW
         OFkfcRWiW3Nyeng+qlrGAohbAwJLiesoiJaVtbrUerTJnyF7ccxFuI9Tu8ni4NRm5Fov
         U/8sHxI4NkYCS9/tiAm4CI+PgCbtF98ha/GZ67I39PsxRofA6Mq+JdpTSf1rm0IzYTxx
         HNJSwJTbO2ST+7yJOAxQEh4/X2QYs1S0cqh3uDN0SumqOcRKqgy2jxYRdVrZqChL5EOC
         uBWJjXcvVeoQ+obgcpK1Wx0tJFjfg7EFstaeShFF7pUbOnzLcuoSkgv9e2wuEqLRxA5K
         CpgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780095002; x=1780699802; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HvEio31Zi6ONGWKOwZdzq6U/5CmPfd2xjkBbuFVZMSE=;
        b=l3zPa9QK/Aj06n0XtLEqnAw/NQUzVbwk29QrUda/Af9lZEk0nNbN/8rlUzEw3WqZBv
         cKNbgYuS+mH7YBmm+hOsgMMPzX0h4UIPNXFEMiTdkEZlOkyeAmWJSqheL33T+2ecd3NS
         km60m4mUEPP76r5jgdmIb0qlQHd8UEDFaiG2VsvCc2dn86P50uMC/hbccHaovUW9H9TJ
         jl8Lo/n5MIEt0INrEUx+e+oZapCNwiJXSBWCGGYFGy4Jbgjfx9zffoGl/vQ33SvyE7Qx
         DtJ4YJnSciY09xIu8kn1H5Npui9CYUIg2efslQ7yYS8CoB57XQ9pmnf2IZ7cnV1KFrt+
         6X5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780095002; x=1780699802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HvEio31Zi6ONGWKOwZdzq6U/5CmPfd2xjkBbuFVZMSE=;
        b=mo4LAG/RsrHhtIcbN4CXVLV/r9HpOWcj2pGYxG9tmhRdqkBZufSWaBj13S5+9q7QOH
         MIq0rCng2BJciMPt1qbUN1b9wmMxD3hEHSnxbLCkfEqF4fjeZiDicQ95K3iBs241cV1d
         iCXvhA0CYLOfoC5Xv32+x70FEugw/QT9CuaOvY/h6EhCwCuK8858jiU9uHVv8TgnY8WL
         6l/zgV7EvePKrcpRmwG5rLLzr9hrkWVZRvNhZcRihWrmWATz5gMwkglVC2df2KdZEMlz
         vVMbCLEd4VDK0PBorejmH7T4MykxKRnEw84L+aFz+vusKUTMUtHfVw+dF2JlTQJnUzZx
         HSlg==
X-Forwarded-Encrypted: i=1; AFNElJ9ox9SjXa5WACtBvCehFBguAemGTM0yIl0ACnQu+2dC2fIKcqayOTc2tykHKacsX0E1bS+9oITjGg==@kvack.org
X-Gm-Message-State: AOJu0YxLCQwmgNB+Y/DncdTbA7CEw86pDetqHiSZNF5KTn8nl26q62SL
	IxV63iFvTJZRKndIDoTAHM3GT19Oyz17JJGD31hQSSM5OlG7hK7Awj29ux670O/sslDFUp7eZU3
	GHPXKN+mm96PhoySqPrMNX77VVD63Ndw=
X-Gm-Gg: Acq92OGeCKpOvSj30cu5POiLD1SfU3eeohiCKZ7LPQEOkMAgOop7dxFY+4JoU+PHkcA
	FIaGSnQKrfyQ/huICIFEtByjFBKd51XQk+SfKFib2cw/LmWeDd8uLUHt8VKIw2O2PhkBiEod4si
	Odd5zqX1Z/YfOSWVx0e/uahRiPBmdfg6kkuxkX360d1dOEO3u0pgRhWtRCelqC/vfly5F90W+z3
	LxKB3ZFtO+ZLu99+i94Z375KTxF3AJwMTyc5L48zUS5XZCDHc2cfeemjSGuUMbWH65QKq9DgCoX
	eqFhE4pGxgk4hjLZ2mn5WrTyX/KeEJd3MddiY4AnuFOPbENkBfM6VbMEGKTr
X-Received: by 2002:a05:600c:c3cf:20b0:490:47e0:e13f with SMTP id
 5b1f17b1804b1-490a292a3bamr18484295e9.3.1780095002022; Fri, 29 May 2026
 15:50:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260527115930.3138213-1-haowenchao@xiaomi.com> <20260527115930.3138213-2-haowenchao@xiaomi.com>
In-Reply-To: <20260527115930.3138213-2-haowenchao@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 15:49:50 -0700
X-Gm-Features: AVHnY4J4_pQZ4zwdFunD4VdILVpBuiLx-ARqHurC5ZE5Q-JxwKIKWBgElCt5IGo
Message-ID: <CAKEwX=O4j08WWDRwovPK0Nk55xiiYheGdtYKvuK9dh3ouhrpag@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] mm/zsmalloc: encode class index in obj value
 for lockless class lookup
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA0B1140010
X-Stat-Signature: g6q4f5cfp4f4ienchm6p54d9zwpofc9w
X-HE-Tag: 1780095003-954022
X-HE-Meta: U2FsdGVkX18QHW22IkHktUE0MPzl4hz/vUvAObJYieti6FfA4kEYcwLV2QBewNYQN2JTCj2X0JFcud5nUzrfCPD83jtHXtclOekHe0lCExMqTljneF+0FIUWpMpqAYA5u9X9mSgnEonZzsVfNK/cuhzDlM+sZpnAfC5cfQEG5eKi+3/TNXJZQN7sNKPWzlW0QqzbQosgoiasFqgiV4W7S9dAN8EojwxEFIVEDWjgUUz2oIX2+6h1cfnC+h8H+5DE45QL5x3ZHJ2Rv7/5j+3AfNRebWLu06jTx8Dn8oDG3BqgEZlwe+7NQv3Y/WUxBHedqjJ/hU9JK8z3J9r1h7tuQeHZTOX5xBnZhwtJppAI9dVnHZmM6T/66J499qqobShr2FWgInCLDwzHtlwEeIrYSo9EQiu7YfUf/OGxqN+aNQIExOBuicfgDn4vGdcDWtJtWXuqWCGIYzuLg4VB60FmwzscIlMsWDq+kGKI9OYa8H36ggnQ/qeaVHzXgxw8Q/RmGOru1agK1ykMFB9mvd7Ca6ZC3xy54vgd4Bb6u6iZ9lDvRZygme2QNdWz8pzZ4cut5r2YS1qjwzAZ/z2P10HzMA4I/AIuWhecmhGLUxfCARSF5veBsJ5OZX8y4Ce34DbteI+v8DmF/wItpIR0tBbL2OMX/bm2Lyjumo0y80VYcjKKODN78PB3U+fn5rDWWUWsg8MHTeZ66OGcKS16sZjglt6H8KkjzH+UDHs9n4BWyRVbLNUaCkW3yfqcux3RxnmluBsWs5T9oixm+P8aMBterjIXccqYB29I8E/e1nJ1Q7luwum/6M17CD8sOPYgEZqLOBZ5QR7OENQ8Kfm3IkIX9iUEoioQxMe0v560A2ypiwV+/NURE7s8E8XU5PdlbyiXcpkWX7IhWpEblQ4X8ZNt1PYnwI8K6EqZHIG1sHIio18ePDzfWPOjAY2+r5jZZ0sYWon80m8H0QB//0vFCwD
 KTnnm3YN
 Xytw1ijLz//Ir5L7FVRML9McOJARV5+xabyIIX9qO4ybUt5xXFW2A9wEvOwxQakMmuEWe44rhNzvs3kmIrcNf4aVSXuxogtNr8JcVvS3p7tUtznnkU6KxlFInovkITrzwfEJ+IUSW/I9b9qlkniFRoMG8ACRf9l+VxWONvg8AQdB0/dNq0j4vHfmT74hT4OxMmYWFeVdzRVbRHrEEOKrN6nyHXAlAWUAcH12wLn7qWEArSHiOGUaRSnONTYfeANWqmAnO68WWA7Z6ZC8QokwuqCyM7ofOLdUuR+Mx3XsoNBbHUtKIUrN0tVjGwdwjzkaEjqBXPOHW5C96NAidorkNa0hVaz63FPZb2GXxbdLSOm6DoQXllqyYpKULdOnGslpmuqSsaowLpg9/Kwy+1SFWz/oT8Mj8OHx5cf81bIeoQmVWcrHk/jIKVXVwZT1R+9TfAxXn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 5:01=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> Encode the size_class index (class_idx) into the obj value so that
> zs_free() can determine the correct size_class without dereferencing
> the handle->obj->PFN->zpdesc->zspage->class chain under pool->lock.
> class_idx is invariant across page migration (only PFN is rewritten),
> so a lockless read of obj always yields a valid class_idx.
>
> The space below the PFN field in obj is over-provisioned on 64-bit
> systems, with more bits than obj_idx needs. Split that space into
> class_idx and obj_idx subfields:
>
>  |<-- _PFN_BITS -->|<-- ZS_OBJ_CLASS_BITS -->|<-- ZS_OBJ_IDX_BITS -->|
>  +-----------------+-------------------------+-----------------------+
>  |       PFN       |        class_idx        |        obj_idx        |
>  +-----------------+-------------------------+-----------------------+
> MSB                ^                                                LSB
>                    |
>                    +-- ZS_OBJ_PFN_SHIFT
>
> The macro layout changes as follows:
>
>     Before            After               Meaning
>     ----------------  ------------------  ----------------------------
>     OBJ_INDEX_BITS    ZS_OBJ_IDX_BITS     width of obj_idx subfield
>     OBJ_INDEX_MASK    ZS_OBJ_IDX_MASK     mask  of obj_idx subfield
>     (n/a)             ZS_OBJ_CLASS_BITS   width of class_idx subfield
>     (n/a)             ZS_OBJ_CLASS_MASK   mask  of class_idx subfield
>     (n/a)             ZS_OBJ_PFN_SHIFT    bit offset of PFN in obj
>
> On 32-bit systems there is no spare room for class_idx, so the
> encoding is disabled (ZS_OBJ_CLASS_BITS =3D 0) and the obj layout
> remains [PFN | obj_idx].
>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>

LGTM.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

> ---
>  mm/zsmalloc.c | 80 ++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 66 insertions(+), 14 deletions(-)
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 63128ddb7959..6b0014b43408 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -67,8 +67,8 @@
>  #define MAX_POSSIBLE_PHYSMEM_BITS MAX_PHYSMEM_BITS
>  #else
>  /*
> - * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will j=
ust
> - * be PAGE_SHIFT
> + * If this definition of MAX_PHYSMEM_BITS is used, ZS_OBJ_PFN_SHIFT will
> + * just be PAGE_SHIFT
>   */
>  #define MAX_POSSIBLE_PHYSMEM_BITS BITS_PER_LONG
>  #endif
> @@ -88,8 +88,27 @@
>  #define OBJ_TAG_BITS   1
>  #define OBJ_TAG_MASK   OBJ_ALLOCATED_TAG
>
> -#define OBJ_INDEX_BITS (BITS_PER_LONG - _PFN_BITS)
> -#define OBJ_INDEX_MASK ((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
> +/*
> + * obj is encoded as [PFN | class_idx | obj_idx] within an unsigned long=
:
> + *
> + *   |<-- _PFN_BITS -->|<-- ZS_OBJ_CLASS_BITS -->|<-- ZS_OBJ_IDX_BITS --=
>|
> + *   +-----------------+-------------------------+----------------------=
-+
> + *   |       PFN       |        class_idx        |        obj_idx       =
 |
> + *   +-----------------+-------------------------+----------------------=
-+
> + *  MSB                ^                                                =
LSB
> + *                     |
> + *                     +-- ZS_OBJ_PFN_SHIFT
> + *
> + * Encoding class_idx into obj lets zs_free() locate the size_class
> + * without holding pool->lock; class_idx is invariant across page
> + * migration (only PFN changes), so a lockless read of the obj value
> + * always yields a valid class_idx.
> + *
> + * On 32-bit systems there is no spare room for class_idx, so
> + * ZS_OBJ_CLASS_BITS is 0 and the layout collapses to the original
> + * [PFN | obj_idx] without any ifdef in callers.
> + */
> +#define ZS_OBJ_PFN_SHIFT       (BITS_PER_LONG - _PFN_BITS)
>
>  #define HUGE_BITS      1
>  #define FULLNESS_BITS  4
> @@ -98,9 +117,29 @@
>
>  #define ZS_MAX_PAGES_PER_ZSPAGE        (_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, =
UL))
>
> +/*
> + * Reuse the width that struct zspage already reserves for its
> + * class field (zspage->class:CLASS_BITS + 1) for the class_idx
> + * field encoded in obj.  On 32-bit there is no spare room, so set
> + * it to 0; the encoded class_idx then folds to a constant 0 and
> + * the layout collapses back to [PFN | obj_idx].
> + */
> +#if BITS_PER_LONG >=3D 64
> +#define ZS_OBJ_CLASS_BITS      (CLASS_BITS + 1)
> +#else
> +#define ZS_OBJ_CLASS_BITS      0
> +#endif
> +#define ZS_OBJ_CLASS_MASK      ((_AC(1, UL) << ZS_OBJ_CLASS_BITS) - 1)
> +
> +#define ZS_OBJ_IDX_BITS                (ZS_OBJ_PFN_SHIFT - ZS_OBJ_CLASS_=
BITS)
> +#define ZS_OBJ_IDX_MASK                ((_AC(1, UL) << ZS_OBJ_IDX_BITS) =
- 1)
> +
> +static_assert(ZS_OBJ_IDX_BITS > 0,
> +             "zsmalloc: PFN + class_idx leave no room for obj_idx");
> +
>  /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
>  #define ZS_MIN_ALLOC_SIZE \
> -       MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS)=
)
> +       MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS=
))
>  /* each chunk includes extra space to keep handle */
>  #define ZS_MAX_ALLOC_SIZE      PAGE_SIZE
>
> @@ -721,26 +760,38 @@ static struct zpdesc *get_next_zpdesc(struct zpdesc=
 *zpdesc)
>  static void obj_to_location(unsigned long obj, struct zpdesc **zpdesc,
>                                 unsigned int *obj_idx)
>  {
> -       *zpdesc =3D pfn_zpdesc(obj >> OBJ_INDEX_BITS);
> -       *obj_idx =3D (obj & OBJ_INDEX_MASK);
> +       *zpdesc =3D pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
> +       *obj_idx =3D (obj & ZS_OBJ_IDX_MASK);
>  }
>
>  static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
>  {
> -       *zpdesc =3D pfn_zpdesc(obj >> OBJ_INDEX_BITS);
> +       *zpdesc =3D pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
> +}
> +
> +/*
> + * On 32-bit systems ZS_OBJ_CLASS_BITS is 0 and ZS_OBJ_CLASS_MASK is 0,
> + * so this collapses to a constant 0.  No ifdef needed at the call site.

nit: I think this comment is a bit redundant - you already explain
this at the data layout section above.

> + */
> +static unsigned int obj_to_class_idx(unsigned long obj)
> +{
> +       return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
>  }
>
>  /**
> - * location_to_obj - get obj value encoded from (<zpdesc>, <obj_idx>)
> + * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj =
value
>   * @zpdesc: zpdesc object resides in zspage
>   * @obj_idx: object index
> + * @class_idx: size class index; ignored on 32-bit (ZS_OBJ_CLASS_BITS =
=3D=3D 0)
>   */
> -static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int=
 obj_idx)
> +static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int=
 obj_idx,
> +                                    unsigned int class_idx)
>  {
>         unsigned long obj;
>
> -       obj =3D zpdesc_pfn(zpdesc) << OBJ_INDEX_BITS;
> -       obj |=3D obj_idx & OBJ_INDEX_MASK;
> +       obj  =3D zpdesc_pfn(zpdesc) << ZS_OBJ_PFN_SHIFT;
> +       obj |=3D (unsigned long)(class_idx & ZS_OBJ_CLASS_MASK) << ZS_OBJ=
_IDX_BITS;
> +       obj |=3D obj_idx & ZS_OBJ_IDX_MASK;
>
>         return obj;
>  }
> @@ -1276,7 +1327,7 @@ static unsigned long obj_malloc(struct zs_pool *poo=
l,
>         kunmap_local(vaddr);
>         mod_zspage_inuse(zspage, 1);
>
> -       obj =3D location_to_obj(m_zpdesc, obj);
> +       obj =3D location_to_obj(m_zpdesc, obj, zspage->class);
>         record_obj(handle, obj);
>
>         return obj;
> @@ -1762,7 +1813,8 @@ static int zs_page_migrate(struct page *newpage, st=
ruct page *page,
>
>                         old_obj =3D handle_to_obj(handle);
>                         obj_to_location(old_obj, &dummy, &obj_idx);
> -                       new_obj =3D (unsigned long)location_to_obj(newzpd=
esc, obj_idx);
> +                       new_obj =3D location_to_obj(newzpdesc, obj_idx,
> +                                                 obj_to_class_idx(old_ob=
j));
>                         record_obj(handle, new_obj);
>                 }
>         }
> --
> 2.34.1
>

