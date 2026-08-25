Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D80CC61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290B86B008C; Tue, 25 Aug 2026 13:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268B36B0092; Tue, 25 Aug 2026 13:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1595F6B0095; Tue, 25 Aug 2026 13:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAC3D6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:17:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 506421C006A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:17:15 +0000 (UTC)
X-FDA: 85140447630.22.D02BE46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5C5C31C0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:17:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hIDAUm2O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787678233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvYVAR2elLfvYX3fL3fGVZGHm4u80QysQy4Ra805mlg=;
	b=R/ptGeRx0KrmZ65hembCfpQ2ya4Qejomv/WSg8h2LbbRHS6jWxgWYgs9BK6F2Vxj6+9Hik
	tidWZj0E50EsLj47T9hkL3bTXOqQDcGB1q45L58Ki3F6VkLOJqOWPzxRRrwTihfB/h9fMq
	+Iuoi2NxBsln1NrqWvZiktvD8L/m9uo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hIDAUm2O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787678233;
	b=i9JX2v9llTiliw54Gx/Xc9lhjnoF+WeztFJlrEdxXI/GCWvuYkBAkAKx1BB5yDCO+yHmOr
	yEDQEtNnVBh5l799N5QigqU6ybWeughZeZrSk3lOXI1kNiZLsB+XzT+uskSNfzIYn8Wv3T
	Qu8NdeVLd70g/j+Unq45cXw/iRFqK8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AD4B601E9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435311F00A3E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787678232;
	bh=nvYVAR2elLfvYX3fL3fGVZGHm4u80QysQy4Ra805mlg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hIDAUm2ObEH/6i3dZQHZMraoNxeFjra9ztGR7Jov6mu57EQ36wp7YSXZk+VaqH0Ep
	 rlNZ3oFIZfnokLtGvfsAvAXojGs+uJzPVqP2prKMEuXMTKkxwgPAWw6IrJWEh6dIhQ
	 AVjx1SWtxxQfyZ9PgEsC3vz+sj8zdvIK9NBv2RxnYoEsFHuROno3v7JdwDWWD0msL0
	 jQtbk5tMOE9/AMiEsIw65CjpsI6CgmC76PD+kXJWSkBD4oi96cM+aATNr0IriMkTEN
	 6ADJ1MW3cv7bDLR+cX1XtUxmhaD1WU476HrVJq65YeffWnc2ze8TSGRRDQKYfdH8B+
	 2QovChaDseAQQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2055573c8cso784092766b.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:17:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr5xD/28JC9fLEtia3IXnrK6pZa1Adc+q+whABUlYko8AYdAuiSPl3/cSYQUnvEcTrvZpZ/Dhb0Iw==@kvack.org
X-Gm-Message-State: AFuF++nSDhf4UzTVnrHkB3998NaCmMXkS6LyOWtuLkK3lzvbDHunoq3H
	8iWvZRWBmNrf7PtTmyCDcZGO/bcYy5HizdLIFaDk+ZKvhhpMyYvaGEqhf09LIhZCy5dJ+nVKQJi
	TZ+P/JsbNTHelrXpsPmLJGAaOiN5jdsE=
X-Received: by 2002:a17:907:97c8:b0:c24:e1e9:69a with SMTP id
 a640c23a62f3a-c250bb5072bmr24937466b.5.1787678231228; Tue, 25 Aug 2026
 10:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com> <20260815-shrink_zswap_entry_0815_v2-v3-3-0171bd86a667@gmail.com>
In-Reply-To: <20260815-shrink_zswap_entry_0815_v2-v3-3-0171bd86a667@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 25 Aug 2026 10:16:59 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNznEiz8nUTpGkdbwiVL_Axe3Sosu1L31is_8b3k_ma_Q@mail.gmail.com>
X-Gm-Features: AcwNN1Xe9DVtxaxvdzwwvH0IOwp1dsllShDoP3_BhuWiqeO_RJmEhDsmOLm4yLM
Message-ID: <CAO9r8zNznEiz8nUTpGkdbwiVL_Axe3Sosu1L31is_8b3k_ma_Q@mail.gmail.com>
Subject: Re: [PATCH RFC v3 3/3] mm/zswap: reference the pool by index to
 shrink struct zswap_entry
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qffu16xidrbxq8ksg7fismx9oxjx7a37
X-Rspamd-Queue-Id: 5C5C31C0007
X-HE-Tag: 1787678233-364294
X-HE-Meta: U2FsdGVkX18Jb1pUTNbQNYbUSVxK0lG6wWBy9iGZyzVJmJIRwN1kDxTsBOVYRpYmkcZoW72NgFI5SkquEnMREamWYpOS0vKj2EINRsjr/PWfN4poo6J1fJSTXBJ26IDNxnE6OqDEnpzQu6ZdMIdqJ8AqajfhSkb1K+2G54Ms2MKvCIU+QPfUovEdu9Gw1jMTDQIQiiCHdC0TSfg+t6Z0lp2wuVa/E/Po4oP+IgIbVtXuX3KIzh9FoBtRm78yXZ798HvUFEwGos77fKiGD76kUj11N7PzGAWtLBm9w7yRBUI6zf0Uv/Buy1iKTP5rVYwbKH9hFa80Yhh9JMvloe9mhcoT1BgbBF4uLxnJaYTD6r34cwhGeJLlQyLQ8TojM1wnUtGuyf9DsulF5GMZhxI/1ZE8e9ff+2o/e5lfHZO/JPMK+yoIVka7e9RTHchYHo5wU4AKwuylw3ZNQl1UavWPPuNystSVDEz8Yor96RstkAppswtKJhwE4U4izDYoyaydOt6buM3btc1DuNhB/iKoOAik7b06RxphSHSH+7sGD5taISH6WpBqWu50IyU/6GPZH0yBLWGSW8PxF+q5JK1JjWbt58YhuR2TdeEAZEJdvRFHevWGGv55no5jbb3xvl+dbSLSwpBw2KXw8nyt2O8f+bK8Dd7c9c7811U1LZhpcf4ipVCUESllOJO4cK5Kp1V2PWyQ4j4qcBvpqtOuWgeGy5QCyRjxCrG7RP/AYrRADHGDLpq7V1LhumEnZTKrziPOcBKaNPDDf8vYgzlJGeAog+711TwioMmz5XgeI1abC0+c91rup0NbSM2jAH1FpNdfC6PnFkh98vm+cbk1sVRn9mzZulyKlRGGLOgMJdrYjUO1K/xYn0I4YwHwT++xkrkjGfHDRcliyhWPBERvX2gMsgYhgZHGuIB1Q/rq0+ZOr5K68iijrt9fkg3dFsLQ46uSQmpwdsSvsXMHuEa97Cp
 3RTyp8TJ
 etW2nlGvZXsqGTNTgE52tYOo4IttBi33bz9049nQFt8xL8PSzM6PvrVn+yQQbk/olw/9aG97GEqUPAT0IqKKuzNLV0IuafJeec40h5HWFNxEoYpzbhHpVeLNRXEaQJuaRmpOG4l7IZSkEF0eSp5DUKuHvIFYezDFY1FxYzd1VW24+FbIss5TOgw/Y/FgxQLETm/jL/XyhbfUCeQKZx+qfYiP4OmWGl//CFjDSSSHTJf+ubbFhAFdvqiU5QoEd6Tp3PpiwY4l0SdtsXlv0RvePh/yikwpS6yPwm3BmyrIoucJgOM30WgZiiRAycAqxT5khA9NtBBbXyQWZ9Gmk7SgYOLiJLzcRHBjTsKWzD5sO4cmfM7K51wxL9DIsBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 11:54=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com=
> wrote:
>
> struct zswap_entry is allocated once per stored page, so any reduction in
> its size is multiplied across every entry zswap holds.  It currently
> embeds an 8-byte pool pointer, even though the live pools now sit in a
> small fixed array indexed by a u8 slot number.
>
> Replace the per-entry pool pointer with that u8 slot index and resolve it
> through a small helper that indexes the pools array.  The entry holds a
> reference to its pool, which keeps the pool alive and its slot occupied,
> so the lookup is safe without any lock or RCU read-side section.
>
> The u8 fits in the padding after the bool referenced field, shrinking the
> entry from 56 to 48 bytes on x86_64.  This raises objs_per_slab from 73
> to 85 and saves about 2MiB of metadata per 1GiB of data held in zswap.
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/zswap.c | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 603fdc418041..3974fca40a4a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -213,7 +213,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writ=
eback
>   *              logic if referenced is unset. See comments in the shrink=
er
>   *              section for context.
> - * pool - the zswap_pool the entry's data is in
> + * pool_idx - slot of the zswap_pool that the entry's data is in.
>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
> @@ -222,12 +222,24 @@ struct zswap_entry {
>         swp_entry_t swpentry;
>         unsigned int length;
>         bool referenced;
> -       struct zswap_pool *pool;
> +       u8 pool_idx;
>         unsigned long handle;
>         struct obj_cgroup *objcg;
>         struct list_head lru;
>  };
>
> +static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
> +{
> +       /*
> +        * The entry holds a reference to its pool, so the slot cannot be
> +        * cleared or reused while the entry is alive: the read is stable
> +        * without the pools lock or an RCU read-side section.  Non-zero
> +        * pool_idx (slot 0 is unused) also marks a live entry for lockde=
p.
> +        */
> +       return rcu_dereference_protected(zswap_pools[entry->pool_idx],
> +                                        entry->pool_idx !=3D 0);

Please align the second parameter with the first as long as it doesn't
exceed 100 chars.

