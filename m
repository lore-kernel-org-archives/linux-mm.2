Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4385C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC54B6B009E; Thu, 10 Sep 2026 06:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F2F6B009F; Thu, 10 Sep 2026 06:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19466B00A0; Thu, 10 Sep 2026 06:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED576B009E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:29:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 608B5C046B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:29:57 +0000 (UTC)
X-FDA: 85197482034.26.38306BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8411340003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:29:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9GC3kog;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789036195;
	b=VfN2A3AzK9vYClPdPLQk/dsZ5XhE6ipdrTEaac7KoGHkKrUM3y3cT4dLJQkkgc/otNtxMv
	L50SWwHM39ohjOS29vqP1EBXrWmF3nxzkQFjTrvvbA1vvbErT4MI4BcRJTtRTK2HOXco7S
	52W1TmXKS2BxHoJG/Y/48zd3/45HPTI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9GC3kog;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789036195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oveMNeUrmJZ29ZNviuMiJJWANA2s4nEX43fa3S+xa0I=;
	b=BNL1GGWGJhIqyiyqhw3yb1T1UeD+xE+SKvZl3r8st+uN85LgcwGpT3qHhGntlbErruOdBH
	NpmPBW0IY9r25xteKCBmY5ZlK7zeabeRjYpuSJF6+vhomoUFKD3vWmibGrwnu3l7m9l4Rn
	v1VgCTopUlKYng0XIGOETxbTInH7+lg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9723A43F97
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDC91F0089F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036194;
	bh=oveMNeUrmJZ29ZNviuMiJJWANA2s4nEX43fa3S+xa0I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S9GC3kogX19s8Kr3tqkKvpQaO2ZvCvHo7fhjkBzsKbMvCGogcIvuAMuQFSisOVhtp
	 yDcz4G96eKdeERXpuTk+A1q4LQM43cUaF6Cwv02g65kbc8MuuYbgOlbGW+fHAREjKf
	 ehKfualGGWVneGql7agFMrfL8ZaVudJ4vRCbv6xIbm8T4nJbQOx4woy8UbO74wDVd0
	 CAQ4InlYtp9NH37BO9xio8s0Ithk1N3Ci06ToK/w87VmAdRwqpg1qWWu3ntIH8ndRr
	 CusaRPQg5GJMh5+NAsQv8Hf2xcF3Xyd0GkY1P4VAPCScGNENK3WvlTvGTUZfrSri9I
	 liobeqWxHyo1Q==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2949ed8cc3so38295966b.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:29:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByI6vZ1AW+/T2efiRbyFiSFSDPLa+a9QyCXJe690Rr2pQ5qro9O9aZfVpDzgo1zU9dNcQVc318y/w==@kvack.org
X-Gm-Message-State: AFuF++nL1HK6MvjnOxO7mVPX8OO6D0IeC8Et2dyF6JeVuvrfnDOu+dty
	yav+a7Sz2cosUVMx1L0llcIcrV0hMLZ950E+eGiImRhf3TPhPAN58sen5MpFaFO5CY1fkbpoSrC
	SjI522ODhwGAKHpRT4bfaQqcYoouxTis=
X-Received: by 2002:a17:907:7294:b0:c26:19de:9139 with SMTP id
 a640c23a62f3a-c2619dea0f1mr1667945066b.44.1789036193376; Thu, 10 Sep 2026
 03:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com> <20260910095449.715183-5-wangkefeng.wang@huawei.com>
In-Reply-To: <20260910095449.715183-5-wangkefeng.wang@huawei.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 03:29:42 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP-bGU8Hr+0ah9vpxWJBdbw+wTGMuC8+pTOHa+9XaeU+w@mail.gmail.com>
X-Gm-Features: AcwNN1UWjAkh3tl1VL5ir2FgKyn0HvzGcn9Dfy9effq8RWWzvvTCiQzZb9ctKcw
Message-ID: <CAO9r8zP-bGU8Hr+0ah9vpxWJBdbw+wTGMuC8+pTOHa+9XaeU+w@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: zswap: skip zswap_invalidate() in
 swap_range_free() when zswap is unused
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8411340003
X-Stat-Signature: 1qt633ipkteo39gk943dz6q7wrzo85y3
X-Rspam-User: 
X-HE-Tag: 1789036195-624313
X-HE-Meta: U2FsdGVkX1/02Zv8NXTN23lMNpXHsNoAg9rZavpbCb1GmkJiqncZN33g1wvmbmlwRYlwy54DUCaDHPf3A5bSVCb3yMzjp75AfgEWL8HdbXLHBo67F4XfCOyIV6nrYyF0a/PnlPHFFpsh6DX/K6jhaqEouJqxG9T29uPPVuQL0hGlrMHNtRxT6ZJn37c4WpwBaiaLV0FMvwCeEHQAFnb0ItPo/uwQvTe/ScnTYfPEU9U8BFwd9zVljTZE0g5qelPPJSBpK7eC815Gl31t5AuwAhaKXxwHZdWc4jRzaLaEn4YVYeZjQrleJPynpUgN338rxZNV0oyLNRUkEjuubrN7o1jobiKX9/ib9CLl0MghopenmySmBkCVlUz8+CmrQWymFroxS1B5CIRYZcNPCXa9z5vPDwdmhggvzj8gzf1Ki9IqaVZEH195rJ9uOuTMw/UZ1rRvh5RBg6Zb/45BabxMP/cL8u7EqeQAsl6qWsK7NxqTzGCipfv79BGNhNvs1UowjK34TK6siJebhgw8nZfY2g0rPZMV+DoZQxe/V81SuuWhfLzrKa2Wqtb/Gn6+LDEDntr+MOjRPhssB/pbHTxF8ya2g2M9Nts2tvpG/R8pUTLbtZ4IUIC5ncwtA7E7OGulbE2GG77qv4ExW3ZgydX3tKa24Mj/dHcJtyQvsRHw83IyA3iu/cmYiCuCKs1O4djcH7k+XMCkN+ZFDx4t/wczvFwuk2NuVRe8dhglpRRkzdiL+3P/W0n039ojFmZCE18BguyUO8TIF9OPB1cB8fJkLy5m+4DFGIL4vnh2e1ld1vc1pH/FK4jYIC/QiuJJPNXmlczzxTIIk2OK5N0GuChLqQ9DmBZN7tz5lyrQNpxfptEbbdX0mI5dmkI85hryo9NMC2g9WKYIui/FB3cvIyIFrrDGVbqHC4bzFPBoSenF4iMq01VQEKFrCGQR8vwABz6whuF43/aoRLNU2Ybbq4G
 m7x/oMtN
 I0NtktHmMUiTkA9Gr/tduHv2vDdUX89FnkMQPsUrThNE3y94NDWi787QMjwtPsSLCdsr32NpxJcqLQmKRe1DC0BK+2/FU3YG7+HYIfPdwjbozix1Z8wjS/k/NEcCOnCDoppB+k6HO9U91x+HxN2gGR6Nd7elVYh0VSQdRqxJto1W6DDUcI/QdnYAHuWMxafaNhB3g7QvT/BJ5Ijj9rlVK9gyykS5cq8Yfj7WzM9uFbR1Mko6XNlpIPDY6Szvq0uAcaphh/UoX8/TtfJF2kb4kin5KbESOpGMTjHvxJhE2w8ED5auji2SRcYoXMLzSaWCtwU4sDHZmET/EBE5YPTp1/wMm/WChSKsh15VMdiN/TpdnU1q93I24jTKDzMbkXjz+Xa06
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 2:55=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> swap_range_free() calls zswap_invalidate() for every slot being
> freed, even when zswap has never been enabled. Guard the loop with
> zswap_never_enabled() to skip it.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/swapfile.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index ba71905e4d46..505592051924 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1318,8 +1318,10 @@ static void swap_range_free(struct swap_info_struc=
t *si, unsigned long offset,
>         void (*swap_slot_free_notify)(struct block_device *, unsigned lon=
g);
>         unsigned int i;
>
> -       for (i =3D 0; i < nr_entries; i++)
> -               zswap_invalidate(si->type, offset + i);
> +       if (!zswap_never_enabled()) {
> +               for (i =3D 0; i < nr_entries; i++)
> +                       zswap_invalidate(si->type, offset + i);
> +       }

What if we add the check in zswap_invalidate()? I understand we'd
avoid the loop here, which is nice, but I wonder if it's actually a
measurable difference.

If we keep it in zswap_invalidate(), we can probably also skip patch 3?


>
>         if (si->flags & SWP_BLKDEV)
>                 swap_slot_free_notify =3D
> --
> 2.55.0
>
>

