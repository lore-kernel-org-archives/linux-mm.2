Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4778CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 01:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280AB6B0088; Mon, 11 May 2026 21:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231656B008A; Mon, 11 May 2026 21:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16EEE6B008C; Mon, 11 May 2026 21:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0956B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:15:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D07A8C524
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:15:42 +0000 (UTC)
X-FDA: 84757000524.13.AA07BE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A2E52000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:15:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QsH3G1A0;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778548540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQxkHhFe0PYqdasamJBrc/HXioEMWxVv2gM6HajbelY=;
	b=VGRvLzLHYgBeDJ9/PEqcYzAUOqfQGG4HCRt8SpW6ka64t27D9lo4VZzj4bOuhPrmqTUHHn
	YrCNhwGeVNlrjB5FH+Y0CGTUfxVmNzvlnasxWyoIjQqq/sNiCjkFcBFv6QO8uy5l9SMaPl
	+fCzra/hUx3Ei9IbL32vNmq2aIfQn9Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QsH3G1A0;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778548540; a=rsa-sha256;
	cv=none;
	b=SIHT+8sTvYUp2alz/g73u/amDrarrkkpnuZpWCND258wtMBagBJhi2A+39t0lvm83BAX0j
	7IlvfRZd2mWlnCnhODT6AP9tMF5XLmILsOiMxVKaYTilOtrC+/XXemgSOtI45/uSeKedeR
	aqtl2WtvZ79C08JTBrpR6C+XnMgmpww=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EC63444AE
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A1DC2BCFB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778548539;
	bh=idgOzLS1rCs7X37X7hhfN7wzOggCQdLx7Y9oI0t5SgM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QsH3G1A0SXcjlW6mES+86Ow3OVus4Nbz6QVAAyjcZsaIQskZawTFzMFxHkmftEjlF
	 FmOz2orZzBvQXM+fXl1cFXcZw8F5T+TIv7X6QgcuzAWk7R8Y3EvDBDAvX32dJkvXyf
	 dQo1ExgMW6feSmb11pFSfSI6BtxU/bgpbwrsZc2Luznav9CsUF01w067EmNO14h1l7
	 i5/DfUySLFiZ/IunWVylMxXfJu2+c6gqAppUxgTd5Ix1xUN1yjDwccupoYOtU2aNv8
	 Hc0TWVBIwd04M2aLas63OaM6ne+TSTotlEYwDFIpGkyvj5uTobF5YPpjBWBfNrDo2R
	 5jcE9mryJ3Ldw==
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50e5ad864a6so50401011cf.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 18:15:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9MgkoCk6ybR1rRN+fGeKe7Zlm9X/R4dWf5mkcdI3OS+9XxgMOjW/XdXMHpBuvSG1NVCsepGyzyog==@kvack.org
X-Gm-Message-State: AOJu0YxriS5KyzJ1va9caKdxLM9zC/UU9rz9VXfAaq2OKFR8biLgKA5q
	4mYYGtk+6+S0V/JODEJYSu8GPeiNp+tw3bpOydbZlWlkoARX61plqMXK8KG+daLnUpS1n7nhHJK
	NctPTwkdhKPr6tgb2S8eFIXKoPgOHsZ8=
X-Received: by 2002:a05:622a:11d6:b0:50e:635b:5579 with SMTP id
 d75a77b69052e-514d1c767admr16011201cf.19.1778548538757; Mon, 11 May 2026
 18:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260508061910.3882831-1-haowenchao@xiaomi.com> <20260508061910.3882831-3-haowenchao@xiaomi.com>
In-Reply-To: <20260508061910.3882831-3-haowenchao@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 12 May 2026 09:15:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x+hzoHnX3ntbJh2KU5=DJt2+3d56aFT_C_GEmjB0KhMQ@mail.gmail.com>
X-Gm-Features: AVHnY4J1rXwG0D75CTqBkyPj6xJWL4HMt2mJ8dZie81UvtLNMlWzCv-e6vsUTRo
Message-ID: <CAGsJ_4x+hzoHnX3ntbJh2KU5=DJt2+3d56aFT_C_GEmjB0KhMQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] mm/zsmalloc: remove pool->lock from zs_free on
 64-bit systems
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	Minchan Kim <minchan@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A2E52000A
X-Stat-Signature: 8qejizjj1mwwfuus3946a3spde1tojjm
X-HE-Tag: 1778548540-654110
X-HE-Meta: U2FsdGVkX184pVLr7blLr7DqsYQnanJP1ozUTCkDccl62ymJjfpenEpuXEM3neU+GMMtnuBYA5+DTOOd+Iq48opQDbJRXYknFAbEFcKJq3V6Gim5n7yI+rj888tnusOm9mNhs9zYJ6RQD1qfni/7XZeGnwDF3GXc1WbEmNIaPRqJXBTRaCRm7F3a+B99AOB07mrlOFLSARq5Bo4Mz6Z3d/c9GaNG36OO1G2Q7mwKTN1dGvw6S4Bqs5eTWYPTlP03D0GPE58q7lIkqXq2HxRlBFJkxb/mBNZuPdVZOKXGxL6sTVsHzXZP8zVaYTvR9elgEGyp7Uubp/P5NYXot6hPXO89+PPelQ5NZln1Fk5X0DLhwRSj50KGgTSCwchKZWIqMVwAnO5qCTAx86xbNTRx3X10xdTHNYY+WO5h7BTjCubi6sb5CYbutGaUI04h+IaRj1usA3SdL6ctNyl2oKh5ikDQD+NaIGEYEaPWtfXo0Jmv8/geHE0ktw/9HRnnVJDP9Z2ID4GvOfvUnyDy9/ev+q/1meLwLqMTzCY8RggIviPoFQ88LxBMGkJRZ0GgIGj+qeXLR6FAV6tvaeVHiDSWfhE+BswlHD//8CU8sqQXgJJ9cAmfeqlb2Dihq6RUW5QG5Zep4xzbd0P/q42sZQjMncC2nRbzkWyAuv7TN15atFq21H6znxurD3eZ6QAUIAKoSXzj+ZIGmkO5G+8QTLnndUoiMx+MeereXJmPEbH9qwHEFX/WLzaqrnPXnKxkhML8u9s6fjDTdPNp3MbS5YqOyj4waRHWtTVDEagXFd+Id9qlN4LRWd4DoMNBNbzWvqN13tNJ+WBFP1NrOzIKs3ek1G7n1JJpgIIazR/R2W/W6fNCtsTPS9KcuTxXh7TdgPrCPeuuTW3LkTCuZNC3Ley8elj3EUSzdoYrSL0IXNQXqQ52DwtAbJUlb6Esg+UcHrNOJBg4WP3HQFoshuaU5Ph
 nOi1wNLw
 XbFUJZ/g+v+HeaxbojGLifrRTukqRnagCaskLUxSvmrfOyBuYFunQZ++mBa1O8mjRQ15tmZErT41BCeDbxDn8Qk1XJUQWpws65M+pPvmQJT5jAUgABX+8gv304RduM5cIFlutCa+jvx+x+l+51kjUicdNu+qVNxgqx4JJEBZCc5zRgDkm1StEduD7BfAuF/s6HryubcDgFqiB6T2RdvrEfJRlJ3Jxc5qgSDUk60iGr397kdVx/IWhNOYIecwkCJcYd1aVRZizqkOdfKCU6pPYUmlagNYIsDRYbv2vwQRDaaxTyknuMiaOEVLADOCTTykpDBRAj20KIwpylFq6M4ggeaag4i32FS+xGCVrKphCy9vFAkCJ9+JouLtA8fITTJJh//cY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 2:19=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com>=
 wrote:
>
> With class_idx now encoded in the obj value (ZS_OBJ_CLASS_IDX),
> zs_free() no longer needs pool->lock to locate the size class on
> 64-bit systems.
>
> The class_idx is invariant across page migration (only PFN changes),
> and 64-bit aligned reads are atomic, so a lockless read of the handle
> always yields a valid class_idx.  After acquiring class->lock (which
> blocks concurrent migration), the handle is re-read to obtain a stable
> PFN for the actual free operation.
>
> This eliminates rwlock read-side contention between zs_free() and page
> migration/compaction, improving zs_free() scalability on multi-core
> systems.
>
> On 32-bit systems (ZS_OBJ_CLASS_IDX not defined), the original
> pool->lock path is preserved.
>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> ---
>  mm/zsmalloc.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index bccadf0a27f2..47ec0414ce9e 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -21,6 +21,10 @@
>   *     pool->lock
>   *     class->lock
>   *     zspage->lock
> + *
> + * On 64-bit systems with ZS_OBJ_CLASS_IDX enabled, zs_free() does not
> + * take pool->lock; it extracts class_idx from the obj encoding with a
> + * lockless read, then re-reads obj under class->lock.
>   */
>
>  #include <linux/module.h>
> @@ -1467,10 +1471,24 @@ void zs_free(struct zs_pool *pool, unsigned long =
handle)
>         if (IS_ERR_OR_NULL((void *)handle))
>                 return;
>
> +#ifdef ZS_OBJ_CLASS_IDX
> +       /*
> +        * The class_idx encoded in obj is invariant across migration
> +        * (only PFN changes), and the read of *(unsigned long *)handle
> +        * is atomic on 64-bit, so we can determine the correct class
> +        * without holding pool->lock.
> +        */
> +       obj =3D handle_to_obj(handle);
> +       class =3D pool->size_class[obj_to_class_idx(obj)];
> +       spin_lock(&class->lock);
>         /*
> -        * The pool->lock protects the race with zpage's migration
> -        * so it's safe to get the page from handle.
> +        * Re-read under class->lock: migration also acquires class->lock=
,
> +        * so the obj value is now stable and the PFN is valid.
>          */
> +       obj =3D handle_to_obj(handle);
> +       obj_to_zpdesc(obj, &f_zpdesc);
> +       zspage =3D get_zspage(f_zpdesc);
> +#else
>         read_lock(&pool->lock);
>         obj =3D handle_to_obj(handle);
>         obj_to_zpdesc(obj, &f_zpdesc);
> @@ -1478,6 +1496,7 @@ void zs_free(struct zs_pool *pool, unsigned long ha=
ndle)
>         class =3D zspage_class(pool, zspage);
>         spin_lock(&class->lock);
>         read_unlock(&pool->lock);
> +#endif

This looks a bit inelegant. Can we extract a helper like
obj_handle_class_lock(), or something similar? It could have
different implementations for 32-bit and 64-bit builds.

>
>         class_stat_sub(class, ZS_OBJS_INUSE, 1);
>         obj_free(class->size, obj);
> --
> 2.34.1
>

