Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93DF7F99C80
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 13:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746A16B02B5; Sat, 18 Apr 2026 09:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0AF6B02B6; Sat, 18 Apr 2026 09:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572836B02B7; Sat, 18 Apr 2026 09:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41D126B02B5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:35:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 972A5140542
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 13:35:15 +0000 (UTC)
X-FDA: 84671772990.08.8C1E638
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 84D691C0005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 13:35:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HkDjou9m;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776519313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2GMCJikAytNydeTS30qIgVdQwpmLTzn01CKLn0VA/c=;
	b=AqWEXUpJ0VqgbzK/gSvQZ8Xhjwxl+jURhTQ0CFZ92S0hpNbdfQWid3BrgIu5P9yJOpUZhB
	oPDKPXnE3Koh7DoyboeUj0AdE9HuC8Syv2+fne19OR9wwW1isyHwu3eCQ9/jUcm/rBoIaX
	FO0N5Ell6pAxZhpKxvY+clY7T9Y9Jfw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776519313; a=rsa-sha256;
	cv=pass;
	b=pAeFTMbBXuEWPkJ2mSfOYpujQTuUVYvxB//tpJUDKdC5TQh7ewkCOD/DiEr7FNHGRgSR9Z
	fNfmF49LZ4g7vDDT8ROwd54fQs2a4p4mFJDehQOhiPjIWE/FqQFaL1mDssb7jPUjhGiusV
	/AvLT5j63v/3ysAqxSeWe3R+w4lY/VM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HkDjou9m;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67468ebeefbso514353a12.3
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:35:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776519312; cv=none;
        d=google.com; s=arc-20240605;
        b=FwoyD138ZDfbEY+wI9sjuTl92HPOdNKwoCDhTKmYB0/2v6u3dNQa/F3AnI1lvcHFQ1
         u7KiMvpUM9By9eNN43kpYPm8pzBbG+6u/B7CByOkQta4joqsp6cvlxWOvSF60WVn5GYJ
         0R0bM8RK2WI4pKqnvibzjPIgMeJHXGOcmey4G88Hd9K3DoUVXPEeAwhPBVDhtbSShTHa
         TRXMT1Y76Sbj1IGb917W9V2YwwprykHNP8S3T5Fxnawh/fnarGFWUtK+EZkbax7+vkDC
         JGO0UzjinyPCBGVL67wRa38Dv7lsuS5+Ct1lYK8IDiVfxznk+d74C7ecj6p7H3qkjN8x
         WEPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d2GMCJikAytNydeTS30qIgVdQwpmLTzn01CKLn0VA/c=;
        fh=KAxxboBNJJnOQ5uGr4jc/iJwjxgD1w8O5mgqjElOD2g=;
        b=gBUdQyUdXteuPS+49S2KBFVBg3Nftt+yhGsrBckFdYZ5OV5AmqNap/HYhbQLzyoQm9
         Laou+gdCEw7Ujt2+X+UnWZ4PiTEp8v9UFu4O+QM7u0L9vcIIcUgluS7iE6GSBgcRT/aC
         F6rMjVVDsD5Tub/oFXjj4Br4uEK2/FqXDP1xkA7OV0a+cEwtBhABWv2NUwsV64X8REzz
         W7+5jb6tSNUszDAHTkZCRXOoNLRgHIQUyfE7dWbflKr18lxI4y4soJzYeOTf/Y0xWVZc
         yDZG1ikNHKhiI4+PICnpphdM80co9NaK5Br7esnstbtXT/bsdrY9+yKt0nmNDZoc4zp8
         uEkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776519312; x=1777124112; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2GMCJikAytNydeTS30qIgVdQwpmLTzn01CKLn0VA/c=;
        b=HkDjou9mB+wiTmsPNg6UNLF4YK+pw9uNVco+qyiNEyOd5nvY12V90LH6UA8ddIpfI8
         BViNuWixh7RBejMAfbXgq4Iw1/Xfk96jNrkzryreQIqQrz10gxBUB9XUqb97N+e5xkXV
         JQqx0QBXqjWN0xxV9+ZsTEbyY9muVw5t4C6CymLqLpnao/WCKNO1W7xqXohJM3SGSB3o
         QVMoBWNAeGYiKNDoh7sPMA65QJvKEFD+8ZgxeLNPYmED/Q8WYduWzTPceIOdI9HWMTyc
         0r7APQ7ypszfVWFO+ETyvQhmxpTj2RHfuy1HIy5QggcI8no4oh/i8A+TcWGnwyYiW6Ue
         UKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776519312; x=1777124112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d2GMCJikAytNydeTS30qIgVdQwpmLTzn01CKLn0VA/c=;
        b=ZadhNWR/fcygDZN7n88sdFMcPw7r4CUyobCFNRlBb+2A0E4bADcvOob+PF47bL7Z1D
         CI3eHX5I4K6MqogcWzyOxssY+Y1ucAUnrBxg58NXnGggnZiMqRiD+KoHudBkIDLq9hJI
         DnhkoqZuJHxKOnQMFmZdREsMjfxX0HerBcZmr4t9Qa8NHoQ2B4svSkggdjHhXnHVOkup
         +aJDDgQCvw7H05PwrNJxyGXrxeXqMQVU6zIpafB31/tV6Xna1GcgGrGujTZ0zK3oS8n1
         CU6kXyIyPsxQvTBNhcCNhPqlp46NI4wPpqxsH/YigfK40tM0mOl/K7l6S1428kwuq9aC
         34tg==
X-Gm-Message-State: AOJu0Yx3a3y0ZScj+JaVG9+L9LPpqPdIew5Z5NXAoNlFoWFrpDbOYP5z
	cKSIBduMif/d8uI8qrEThkEtB1xbgTl+CPWVh8pj4fTHjlVnr+rP/GcYbu7ZFVSBLlAOWg3usQm
	9fJND+PPIEDdYqGvG02LTa4Oq7vw6JQ4=
X-Gm-Gg: AeBDietOn/5FVlWSGGTbiA5Tyh3tPdV8rTHrnaGArsfUNdnFivVLwp0dcG4ws2yAYuv
	GNy321a6mSe2s6wj5w+twdOvkyTm65vRLhMGXoPNePIrHNsY1cV1/W872pDFg3GzL02DhlnzT9m
	grXgaQOaL+axzibfdM8ccSqmKxEymCkixRu/7a4K25nQAvK53y+KtljSVl8bSY5iH1smMzn5Ws8
	95qvobzJpxVsgM1vR02OuAZUgReR00oXD33uHl0JpCOSqlEXSmknbl9ksxkm+aujxqarBagMVC4
	NjJDQdC4Hrov0l57Y3KtyYCgFvqcojY8ypWuT+KYmMzaYdK+iSo=
X-Received: by 2002:a17:907:da7:b0:ba6:4e0f:e396 with SMTP id
 a640c23a62f3a-ba64e0fe8fdmr25209766b.12.1776519311494; Sat, 18 Apr 2026
 06:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
 <20260417-swap-table-p4-v2-11-17f5d1015428@tencent.com> <aeN4qzqfyFpWJXYZ@yjaykim-PowerEdge-T330>
In-Reply-To: <aeN4qzqfyFpWJXYZ@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 18 Apr 2026 21:34:35 +0800
X-Gm-Features: AQROBzBd8__QB5UpYNjFkpdRdW1dt7xUjPlCpJkWJoR2NS3IE_II9VBSPRxgaVQ
Message-ID: <CAMgjq7CwaKWP_2yxorK88ZLZ-hRRpaLVm76jJE5mLNcX5eCg=w@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] mm, swap: merge zeromap into swap table
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rjxrnaz3ea78rge7uxsuouqfm5ar1x4g
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84D691C0005
X-Rspam-User: 
X-HE-Tag: 1776519313-771056
X-HE-Meta: U2FsdGVkX19g0YH+/ErSujbr+MctFqXE76KJ9dlFmWJAyv4IxsBzezad5R2iKUUKUoO1yLgDdXa5IXorx+aQjCr3dLcyZ1eQuBbnrRNCwwp3+ydREY9gp8UpNxYK8s3imqr4vQMXO4muF/94gu7+j5WUs4wbHZc+EMzpmk/HDnBXDrecoz+RT0g7lq3j9xwdxIv8L3YfbMvHRq2xnCtMlDL4h63jBvCZy97Y76k8pcInIyYqR0TWhHtXbwHSeyujD/UddLQzchv9KfqoS8sQQSSJ+5sVIVl6+dim/+S08fT/GWHidv0NmgyHF+FQ96y9Wqj3EemyRPLMeJe6z21bSIOaqxJgZoyuOncso4Tqpr954d5LSSRR/+bkq1E7zVGqQEI5sedXxSgrnILmqcfW6TBmaWavR+gQ8nzEjzWZSmkbfdYGqX3tPo68Us0c/YIJTAmUKfrEh3J9R96pCqvKdPIpdqbdghw+fZco8jqYslBMJtBzSyMdg3YW26qfQFXGUS3CX2Jeo0kuvWEIPYSBcqY+kaDxi7xcqlbY6+qG7V5fvfV87fOQtpf8BRj6dYCEFQeQumHkVMGbUTVE3cKbi/EEJatn1EpIqE3HIPWPkwOa2YDaTMtvsZTRRvmDoMn2cKsEuLnBwYuH0wlxbLvkNJkBTTLdXHVgnFcNFQwVD+4D5My+oruKL2kX5YQbQFZfo1ryWeTe0mwpA1zChymtlYJEUKC9bv/dD1PhnI8eUX1f8vJqzIvcbxakF0H1v/+IfgXfbHtRW/R8fE5nRBGHq4Fyyy1CdOxX8AfYsvFbCzpMnuaXzvPhC8r2rDAGyNfqjSHzaGoAYp0CfQjBGKGd+GgsFdKJ/XjDCg3F7Ue/V1FeaL03nxIjiknl0KjAV7qC8gkBHbRnXRWDTAmDc6doaUTHWvRj6GWVdRZ63zUk86fP+N4KF0RyzTfWm7szEPU5bNX8vi94L7RApB5L6VJ
 QbTkjQwk
 6tDwUsLo5DtQ1yhuO/y2inD7xypC4r+qkd4LlQsTc3lQNZpNOmsmpTcn36vqXJl12kHwfDIJvdzI3QBDuJcJCBM0jC17ELdYwjLUISFHs/H2SnYpxIM2I/QHUAYeCXJ/zL7s+yLljd4NAs4k0ne53aleNnrmq5t4J84bCBmxeCyzKRktJKRFkdzJ+Bq+z2eVxTbtqHHG76iMsmDanPF9iBfVhssKoQN9gm1izhxHL550u58RWSDuMggs4aKe2mYk/KzCuM4hMfo9o6Yorpo6U1lbD5EpKOhlbyd/5t/pUcJpEoJhI4NLqUaw8h4eFvgBC/yqBMbrwX2+InlqWY2qsBUkxRaOb9nNccgJ0zKEFUtKmiQOEZDL3wEN3j+ELjvpuAYlsA01vzTxq4U7PgdjVG+cybSaIqikzkaBBKrEpXHGc8Bg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 8:28=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Fri, Apr 17, 2026 at 02:34:41AM +0800, Kairui Song via B4 Relay wrote:
>
> >   *
> >   * Usages:
> >   *
> > @@ -74,17 +76,22 @@ struct swap_memcg_table {
> >  #define SWP_TB_PFN_MARK_BITS 2
> >  #define SWP_TB_PFN_MARK_MASK (BIT(SWP_TB_PFN_MARK_BITS) - 1)
> >
> > -/* SWAP_COUNT part for PFN or shadow, the width can be shrunk or exten=
ded */
> > -#define SWP_TB_COUNT_BITS      min(4, BITS_PER_LONG - SWP_TB_PFN_BITS)
> > +/* SWAP_COUNT and flags for PFN or shadow, width can be shrunk or exte=
nded */
> > +#define SWP_TB_FLAGS_BITS    min(5, BITS_PER_LONG - SWP_TB_PFN_BITS)
> > +#define SWP_TB_COUNT_BITS    (SWP_TB_FLAGS_BITS - 1)
>
> Hi Kairui :)
>
> Would this break the build on 32-bit arches with 40-bit phys
> addrs (MAX_POSSIBLE_PHYSMEM_BITS =3D 40)?
>
> Architectures I checked.
>   - ARM LPAE   (CONFIG_ARM_LPAE=3Dy)
>   - ARC PAE40  (CONFIG_ARC_HAS_PAE40=3Dy)
>   - MIPS XPA   (CONFIG_XPA=3Dy)
>
> Calculations.
>
>   SWP_TB_PFN_BITS   =3D 28 + 2 =3D 30
>   SWP_TB_FLAGS_BITS =3D min(5, 32 - 30) =3D 2
>   SWP_TB_COUNT_BITS =3D 2 - 1 =3D 1
>
> The BUILD_BUG_ON looks like the real problem. it needs at
> least 3 count values (free/used/overflow).
>
>   BUILD_BUG_ON(SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS < 2);
>
> Confirmed with a cross build (multi_v7_defconfig + lpae.config).
>
>   error: BUILD_BUG_ON failed: SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS <=
 2
>     at __count_to_swp_tb (mm/swap_table.h:227)

Hi YoungJun

Nice catch! Thanks a lot :)

> I think the right fix is widening swap_tb to 64 bits
> unconditionally (atomic64_t).

I'm a bit concerned that memory usage on 32 bits will bloat up...

>
> (Or, uglier, these arches could always route counts through the
> extend table.)
>

Seems not ugly with a ci->zero_bitmap, looks clean to me, the
definition will be:

SWP_TABLE_USE_INLINE_ZEROMAP is true when BITS_PER_LONG is not enough
for SWP_TB_FLAGS_BITS, then:

struct swap_cluster_info {
...
#ifndef SWP_TABLE_USE_INLINE_ZEROMAP
        unsigned long *zero_bitmap;
#endif
        ...
};

And helpers will be:
static inline void __swap_table_set_zero(struct swap_cluster_info *ci,
          unsigned int ci_off)
{
        unsigned long swp_tb;

#ifdef SWP_TABLE_USE_INLINE_ZEROMAP
        return bitmap_set(&ci->zeromap);
#else

        swp_tb =3D __swap_table_get(ci, ci_off);
        VM_WARN_ON(!swp_tb_is_countable(swp_tb));
        swp_tb |=3D SWP_TB_ZERO_MARK;
        __swap_table_set(ci, ci_off, swp_tb);
}

There are only three helpers in total, looks fine. Allocation part is
just like the memcg_table. Compared to this version only it seems
onlys needs a few dozen lines change (A few #ifdef
SWP_TABLE_USE_INLINE_ZEROMAP) and not hard to understand. How do you
think?

