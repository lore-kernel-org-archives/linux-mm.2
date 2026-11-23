Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6115A606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 02:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O2VB9rZs
Received: by kanga.kvack.org (Postfix)
	id 6A7476B05B1; Sun, 22 Nov 2026 21:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657D96B05B2; Sun, 22 Nov 2026 21:01:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51FDC6B05B3; Sun, 22 Nov 2026 21:01:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 337296B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:01:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A07BA8077C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:01:47 +0000 (UTC)
X-FDA: 85464732654.29.F518EA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AABE840003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:01:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O2VB9rZs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795399305;
	b=Ig0a6lAhHxu1wx/VIUZoParNrG73KHZQ0rxEJM/Z7cYlGbtT+y+dyttMqMks2tWLZUAv3q
	Y4AHUjVx6uHi4DkpQzdsp7MaHuCZ7N5zrC0x2Lw9dhEsiy4ULHFqOjs3QuLoeqoocUVi+e
	V7E918X0e5gEHenXwOQVaYAffEfsz+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795399305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XCN8MNx9DQWn83H6jTo1oY8Z1rb7ww+YHjpWxJXSWU=;
	b=BqKC0zWrNRkca4ccBcrY68s7UvEfK5mKpCc5jGxGhm8VS4/812B6exzUQlObqivWQZQ8mw
	z00ax3rwyH4WnoKGinHcVozl9D+z8e4e+pKrUgdgXc6Zu9rWf630z6AC0Vr87asrn7bO+3
	2zecwKfAGbm9ClrNSRih2HW5RkVSK14=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O2VB9rZs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32FA061B16
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54EF1F000D0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795399304;
	bh=3XCN8MNx9DQWn83H6jTo1oY8Z1rb7ww+YHjpWxJXSWU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O2VB9rZsOmJSEq7AbJ3AasTzaOZd/nYi80NZEfGhMqTmKa0Qlqlcm34U24FExyVTv
	 CAYKWOxQIALQ0tKud/jaxRfvdbytji8bzpRqXkkgoM8EWixaJtjIQDyfq0j5n/87na
	 ysFGtO/DQLI6E/NYbrwT1HXg9NsMxEq8gWgsOh4fagsGh66LgeSqfBdXCWkeufzJGR
	 u3U3c9Nyg+Lahr2QzfM316FUeDUsKfZDavAwj4j4SM3XxG8Ys2se/UlhuOnM0c8uzu
	 mPSJiHqsCdurDI2r86lh/fIasi3FRIFkjp/WfEzEDFiKBm9WPD0z00d/JCX40I3nMP
	 AsMEr9J8avz2w==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-94961d90b79so323760885a.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:01:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEhzr9b1+P1Q19/QBT1r8dgEiLb1h9KRSAWZAxhITWd615zl/nuW6coJdyOiJaMVkJnzXY9ywhLXg==@kvack.org
X-Gm-Message-State: APuU4Z/ZE21oT/w5wljs9r8ByAuUKg3HHhGUGCBVbCz82PyXJnbrJeZ9
	ab+yNnApGK8NH5Li/fuvXFm7tsGE5bPHgkIcUbdLUDJ0THcRP/ezozrphSjTkqo7Kmk80Yh2+JV
	Zmug8eETze5/AH/BQ6OjvBi+X0WJU4wY=
X-Received: by 2002:a05:620a:8388:b0:93e:e425:229f with SMTP id
 af79cd13be357-949bab2ab74mr1674615185a.77.1795399303983; Sun, 22 Nov 2026
 18:01:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com> <20261116081403.216452-5-max.kellermann@ionos.com>
In-Reply-To: <20261116081403.216452-5-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 23 Nov 2026 10:01:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w3cP+tgCGhTFu5p27Wi-9AFCneQgwLUAUg7X-gvX=e4Q@mail.gmail.com>
X-Gm-Features: Aa3M54p-50BtAbApXAC69mU4ZCzPL9LtAqomEWm18qsEYdXBO_694xtx7kaXITk
Message-ID: <CAGsJ_4w3cP+tgCGhTFu5p27Wi-9AFCneQgwLUAUg7X-gvX=e4Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] mm/mglru: avoid redundant rotations of young memcgs
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9tkzmrroeir4wytimx8xgx8kkiwcsg3i
X-Rspamd-Queue-Id: AABE840003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795399305-567538
X-HE-Meta: U2FsdGVkX19Nbbd7be7pgclfMzqW7dbLIGArB5gz4mwFDIpJkAGtzH/8wsSZh/x0YoNbQeKsD2yqrv+xq04d5hPtvFZrVpfp7fV2sLOBOzc2cx/6rO1VU7JXcxyKyJLv4AIwaOeOzkmSmFY+xvd0/Vjf23t83uH3uGx8AuZwb/jLMNvDjmEDPdxdMdqysm86gd0F5y7y8/+IsEO7L57l2/Zx2ZWxpO5gYvdv7lOG8pex95YaDEakHwVcO2iY2kC3SI7zpVY6EFPWB1R3EqfvFe7zoK4uqQguHVpsN8kXXRZrc9w2B7fdfjnEIVhw+EkI1CPp9wzmDRHP2Ybisjo0DZm5Wys9G1TuUOHEjrtX80RpOPDgSu3diGEj83CHPuAeYyL5ZwaRp1M/kkQCHQ/PfnduTDoVX1THGAMM9fWVbCAhGBK4j5Oe88/+WwGwrdeFFbzGnkvY78iuEi7OP83cWoJyQHoX+sC9v7RZGak7b0M7UI6WLxtPhWHoxfRggEbbqVPYCrmQ2HqdaAENIdOZz2aJottn9vnfDKeyLhquqXmMSzRR2GXzkzW6TT3eg+WgGZKirUfopTnJ6l2q6g60hPSmDc3Xl2oXF7mCtKUv7tEg0rGhgP15G3CgrpwtZbS2ufYc031OqG4yD2nfjYQwS8+AMizOP1VcN4h099m122QhXZ0m6H6J6Hdx2d+zC3EDW4HpmJ+/o7dSivFNHPjRexac296F8NTzh0ttQfd9JChXRZkVgA/tCTgtEypaQfTtwjJSCb2qyFg7GhDo/e0bhepPSbskSt04PKvGXAOq9ENf7jaIfLIhEkZnV9cAk4iPxJS2vjCYeowekvfD12Q0odt6f1HuB1f4HTCBa5+KmyPlWbDC3db4xyxpQmMhS3/OOk9X7RzeJy1Pg1319X3QSDVUA4kiyhJpYctjbJOOlbzY2CpF9/h4B1RpqhqfaLhqFHMGf3xwglEsO96Ktdf
 kgSCPOj5
 wsjKu5E2ElWgmb+nSwwBymwOCGCugo98SOe63BEBykU/UkqeNUsUY6YNtsV2Ni+y7kQUtMSu0G0uy4r1ohEawawdBTomSZWlY40tfIygj9mzjFaAan6vNrtsCMAK52e+/9rh+Dy92ABPb9Lb15uzI/gxBdfl7MQSTj2LsM+26IWaYjzrBwvizVsCBN04tdUCirt9/acTPr+arseQOb0o0nk/uj9xyz9g1W0oOWSZzu08s2Ag4i3u19KqRZvj9eX9W3vIdTm2a/Fi6GKP5Tg7ryQdLLqG6Ecfcux0+JyyLkUH6S1u0adtwmZe0Byz/ioI0/6DLIb8pqAtJblqwG9BaeLzaqx9A9TV2AYSEd5uStsJ2bBEgS8zsDLddPtKlpJbSrMkq79FpaYzuZpp/38AQwEbb/C6nhQ0PMACZRyZAaBHY6s8XUxRL/kXADy/A69kg47dV7PWXyZ8rbOawg0HF4oZYHy/Tj16wZPDLgg7LFXRyZO5uxp/d60jfU5NfcsNQNR11m76jC4c4oUL5vtxyBTsB1FWU9SmVNNH63+kn02Kc5TmqZFRW2RtEvpqCaOWyLv3V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 4:14=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> Concurrent reclaimers can request promotion after another reclaimer
> has already moved a memcg into the young generation.  Requeueing it
> into a random bin again adds list mutations without advancing the
> old-generation scan.
>
> Therefore, skip `MEMCG_LRU_YOUNG` when the memcg is already in the
> default segment of the current young generation.
>
> In my micro benchmark, this increases the request rate by 36% and
> reduces the average duration of each write request by 27%.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  mm/vmscan.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7cfaeca9a605..6b7c9f118e18 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4472,7 +4472,6 @@ static void lru_gen_rotate_memcg(struct lruvec *lru=
vec, int op)
>         int seg;
>         int old, new;
>         unsigned long flags;
> -       int bin =3D get_random_u32_below(MEMCG_NR_BINS);
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
>         spin_lock_irqsave(&pgdat->memcg_lru.lock, flags);
> @@ -4490,11 +4489,19 @@ static void lru_gen_rotate_memcg(struct lruvec *l=
ruvec, int op)
>         else
>                 VM_WARN_ON_ONCE(true);
>
> +       if (op =3D=3D MEMCG_LRU_YOUNG && old =3D=3D new && lruvec->lrugen=
.seg =3D=3D seg)
> +               /*
> +                * This memcg is already in the young generation and
> +                * reshuffling it again cannot help the scan of the
> +                * old generation.
> +                */
> +               goto unlock;
> +
>         WRITE_ONCE(lruvec->lrugen.seg, seg);
>         WRITE_ONCE(lruvec->lrugen.gen, new);
>
>         lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, old);
> -       lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, bin);
> +       lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, get_ra=
ndom_u32_below(MEMCG_NR_BINS));

Hi Max,

I know it was my suggestion to avoid unnecessary calls to
get_random_u32_below() unless we actually need them.

You then pointed out that this would move get_random_u32_below()
inside the spinlock, which I had overlooked. Sorry about that.

Have you tested whether calling get_random_u32_below() under the
spinlock increases lock contention?

>
>         pgdat->memcg_lru.nr_memcgs[old]--;
>         pgdat->memcg_lru.nr_memcgs[new]++;
> @@ -4502,6 +4509,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lru=
vec, int op)
>         if (!pgdat->memcg_lru.nr_memcgs[old] && old =3D=3D get_memcg_gen(=
pgdat->memcg_lru.seq))
>                 WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1=
);
>
> +unlock:
>         spin_unlock_irqrestore(&pgdat->memcg_lru.lock, flags);
>  }


Thanks,
Barry

