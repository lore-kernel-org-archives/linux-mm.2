Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C758C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D1D6B0096; Wed, 26 Aug 2026 12:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34C06B0098; Wed, 26 Aug 2026 12:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9248F6B0099; Wed, 26 Aug 2026 12:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4216B0096
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:10:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB7B5120175
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:10:36 +0000 (UTC)
X-FDA: 85143908472.03.0DE8263
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id DA187A0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:10:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XGIrZlg3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787760634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQznmoeBK5/cc88kxGjP5MQTdq2cCbT43FGZpl36kHU=;
	b=qlhecnIgE+iewgh+UBoTcPa81Q4KTHj+fUr1wblsSVvFEYoz7X64mv/AO8i0pkvIvgx6ND
	FLkGoLVf60R+izuAXvmRreBDxU9vwWFOIzkiGWPl+1a2tT7Kljd3Fuo6tEuxehbwbGZpaQ
	aU59XBRUK99b6zvWKS6lPJQaFyrCAxg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XGIrZlg3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787760634;
	b=Cyv7r0ySxFejwPnKyL8xHFvdyfmB0yUrL/mTCFqMCku8YHgm0PIBBtgk9gUdBBA0wwQ9TD
	jiX91FCb9Lra8CMDBhSALRUM/4Ri00pvm0CcV5hUqvnyTeOoSrISF9Ncg5GUP3aXKO8LpC
	qxmupk6F8RhUTOBfPwnAp3VU4HWPbm8=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3a1eb6fa0f4so9517951fa.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:10:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787760633; cv=none;
        d=google.com; s=arc-20260327;
        b=sUsrm2sNZX+Rk0M6F0T2+bVDIKbatFZ1LY+ZU34897zyuCkj8kwaYoQ+x/7kYncSwl
         3iaukLpBGoPOwUvzIucAFmgsQCUPw0oN4PwI60J0zyMwAWivGq/7wb2hOXroCLxIZvez
         V8K87WIIPPda362S7ENbbEMC/CrphJ23yIFUHL1uD/VFcE1HIPQsraZyqRrUiALClzYU
         j/S6PbMVPty8N/AZvaGXXSZU1WhzI1nnaNqAhmhHcQLLzUiHXHXbLX7jeRvQbR47YrYH
         +S0vjfxomRWlmkjc/o/zpkxM0LER76mWnp8JiDNpNyJTlaBuF9P75WLQrR0dJMhqjo2n
         djIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lQznmoeBK5/cc88kxGjP5MQTdq2cCbT43FGZpl36kHU=;
        fh=gQ+rGaFUJXCzf/i2REA3aZ3F4Xt4HCmCiUKloPFcE8g=;
        b=CisxkYbeZRAVJbmrkRy7JwTR6U5VzmSHb76yBLuzhkdGOSEoVBg94MXf6GIj3DG3Zs
         g0THt2TuBswqAWg8LOopXsKOUZh2hB76LgL1ZgA2bRkP6IbJt6bJ0YOSnyGOPsoZ5kt+
         Awv5wQEFpYGnl9LGzo5LSloI68dWbw2Zn7D/bokSjrHVD6bYlL2tixSvrNYVrToMbuZC
         XNXztYv9Fv6riotFmdiMCH9r5hkmvFf6GRhjqQVTG6nH7H6qtNqrw9+wtcKJpaV1aYCx
         cG3sRDeOW90BUdYCAAASp1oUK5QxDMckf7DRSdOYos2+QMy4S2uw9OVC3rstz3dcvDrS
         zjxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787760633; x=1788365433; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lQznmoeBK5/cc88kxGjP5MQTdq2cCbT43FGZpl36kHU=;
        b=XGIrZlg3sSVaW+/QEeMDghsvZUxkVO/7dPDL1tbivkOwraek3DvC3LY1sVXOpHYr/E
         RmgJ0dPB7QyWZDZs2uUEKlMKHvKArT66xr5SnLKOCmimLNzQLRhNkSbl2/ssI+LVWc1G
         j+As6NBhshsraOHy8SvPNxS+x9CpoQJ5/YjHo34JmPOuehmhH/U1gVKh23xkM3vPd0Q0
         HxvT3vOGb5Ib2fDSKKzA+uQVg0RJKHcVn8+De9UBcyWPvo2qelsO9eZ4QX9tPf6iJTHN
         JwIqFuQ5pzdccc3sDwdjHT1Tr8Gt/4J3/oFv5yb54t7akDDMmMzLG2hg8h8zejvqjpc1
         AxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787760633; x=1788365433;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lQznmoeBK5/cc88kxGjP5MQTdq2cCbT43FGZpl36kHU=;
        b=rYGkc22W3HOVOX7ziU80EN6D3ZU4wq9FdADtb2z+oNk/+0nAU/1VipPHb299PEPvpg
         tRBai6G7fCF9oHgBtQJlOQ/CQHpN3Ca7CvQTaCGIi+pGF/SBAmisWo2XMw9zWH7szf5b
         /8eHLGZcm9C3n8q4VJ+VslQyEbEtAARPv/mOFonM0SttThSTWOAHedG3VayqV+y8R3ZW
         iRoK9IDkiTjB2NK6kWyHGc+aKtVGmdhGX8wNfwUHloZ9SIT9oYwr0JNH/wKNoH+Dhvne
         +LfVOfgfhzu5kpfX6lgKPd17BRabmlsoXgqTNhlvm1oSN2VPVjsb9WEJ8OA7IV0poY8Z
         hIow==
X-Forwarded-Encrypted: i=1; AHgh+RrWWx3Mfe8FGPruLghccIPrWhcpbvfZN7cDbJFtr97x4iNrduez6FhHiGTuj+c9uQqsUDylETLiwQ==@kvack.org
X-Gm-Message-State: AFuF++kdBv3hswR/VpgRMQzWRzv72WqkNz+qdCuO0oKBWnDyBSm67rfL
	LznGfakAhziEj9ANDr4YD03TVybnwHSXSMmGsbM5S+EN6d3S9dv472tgzq+z4GerjtvU1600YXj
	CWEzwgp34DxlrT74WTA+se28AWF8RM10=
X-Gm-Gg: AR+sD11ntA10+9FNgsnyK5xBXvDyVFbRqvpJRpVc1bPb4+uKauUKl4Y4tfrnw6Tmy7d
	FTAOF8+1JS02p+kml/LZdI/RJxNT+f91gniA9Yh0m7H3Aa0vnFmQaVjhCqdIZhhc7ZYHo482dNb
	D0RxLzqbZB1dOPaKZwBj/wBXr6F8nVxm+cVfFh9LQumYfk0/HoqoEwGaKJh+7LIX/6K+4Zu9QjK
	uKxCnAj11oKaZhvrV2kIDbZ/q+AVJcevfrDAq+RS+sm2XnsqXw3gRVz/qmu+gQ7wZ6u6Ec1A01l
	+7RPl1BF48NHbQEoTNp1UythoULCqvFrTICUGtYFlkr14GU4xJRZWGPxIfVVA0pQmTnORMEDH0g
	=
X-Received: by 2002:a2e:bc05:0:b0:3a1:1d3b:67f1 with SMTP id
 38308e7fff4ca-3a1fd6188bfmr19672011fa.7.1787760633032; Wed, 26 Aug 2026
 09:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
 <20260815-shrink_zswap_entry_0815_v2-v3-3-0171bd86a667@gmail.com> <CAO9r8zNznEiz8nUTpGkdbwiVL_Axe3Sosu1L31is_8b3k_ma_Q@mail.gmail.com>
In-Reply-To: <CAO9r8zNznEiz8nUTpGkdbwiVL_Axe3Sosu1L31is_8b3k_ma_Q@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Thu, 27 Aug 2026 00:10:20 +0800
X-Gm-Features: AcwNN1V_8ciPpMDBF5u5ZIGRoKRfNwzbwc1QGtuXGNZyGNQmrfwoKifqm0e8YRM
Message-ID: <CAJxJ_jjvquHuN40Bddr1nppECOhMVO+avp9+3KM6=es7nE9Zcg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 3/3] mm/zswap: reference the pool by index to
 shrink struct zswap_entry
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s7hszj6s3ztwa1aca3986rzdwsq8hhbq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA187A0006
X-Rspam-User: 
X-HE-Tag: 1787760634-112670
X-HE-Meta: U2FsdGVkX19t4Q03Wotu2l7snPTzjIz1R707cT6pcvn/wqYEFxlJUuGmQylxd0Qs48uOlvBoi8X2xrYI5SW9DkGdybM2VEHrH9jTkhWZK7brbOt9KgKULIbEU9jEhoM6iHJvj8wMwCOnnHbgD0u9y9gTgbU3KgqnZn6VyOWyLxz3erP0AQwNk2FnWcVblgYwMBYDxMMudD8fnGnS99fP3QHFwoq17SYw+fm+vpqPBtbvy8A3xYqrQSEhQEgQIlIZ6wwZ8lPPXWI2NcxK1ul3luQKES5V0aKLE+VsbATjY93Sjuu+gt33j2C5u2n2gAYEwINyadmdfCaoqWjAtk+ZVaNEGYgOtI1RSHLKVMs7FPex4g9ArDewqhbxYGlFB3XOYPEsR3TpW2UmKFeftVQMgjfgt4lPKdBJAbkoM/NktiOWYv3nnXY2aNgQGzTO8DwXYDlzI2D0jX6naFbakXfc6auNxywQ2TJbSuOunGh1O9OO67qr27RZPvGv8T65npdOgCbZhGabiD0RXrdCknr/SUDtWbT34zAv2eaMKzyr0ppM4vkLb07rdQyHBo0MZptFm4sZGXMZUTBLvk4tSgJbm1uWzvv52+SclekHYBZnptiSsgWaYPNVHuYHlavwPi9J3he8yqBva3i5J/BPYXupm4Y+YKaNqWdz+XokwLJp2kqXJAyukPxXtnE9+tz+6uiNzdULmIr5DhnFtKdL3BcOw63UEls2HpPzqbSF0OtvJlCFFlVDri5Evh86axB3WL416G4L10vzNTB15Ywrt9XhmWCbF0YJ3fLWVJgWFV3di/BjBCS8iWyPK0hB8p/6bh63yrGh6VmDtqkD5XkJG3oGUr+u6Vwa0DBdSzUslYcukUhzCPgemM2PqjRvAkPy+aDWEjwm6QNyQ0cSDGH/7QeK+2AgTHwqCT3JXOCyC7A4m7sp8LnqX+Ju3PulLtvk32iUiuk38KXNBrmW+AlgtNg
 +mEGVxXL
 CwQSH5WfnAaFd/nwNnTJdpPSEe/8Yl7y3GrsD/AFCrRdPvzia+lIBwd+63SwGC+IajAhjTFGQmao76FPtZpH9yFEW1YwiM2U2fvHAOM6fxGAAUPEEvwM35rC2CaMTps4dnmyAr+RvDMZrLQ3Mr5jp9swcAtcHUUXKdNQ9/9JRnvZRi3jBoZ6pVqb1y1eHaSWtDMGp+6Bf3BKgk0EVeo74afg06OZcXWs8Rc7PlRTdZn5aRU6PPobCCGWXf3hsjXhN67+UwaMkzJlMDBCs2xfXUsDQyhMwP//KvnBU+EaUV9JxrLh/vp4uE5iAinq3nPcMpfKlBlsWJ/3WryO2psrJp2SrLTIXK+YgpiieRKGTYwAdX1tdZU5RNEA855zghus5LyGOW6GOeHUMo9Yp29eez9icsd9+Jn95f/0afFZ2pSnzo1HpiuXwQsmZdszm9Nd4/TSD/HHmI7anQAgEDk1h0y3c0MJL81NHl+Zx4sYGoIPOd+y31qJZnHomhD8B9yhj7gqhaSxqCaG2hgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 1:17=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Aug 14, 2026 at 11:54=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.c=
om> wrote:
> >
> > struct zswap_entry is allocated once per stored page, so any reduction =
in
> > its size is multiplied across every entry zswap holds.  It currently
> > embeds an 8-byte pool pointer, even though the live pools now sit in a
> > small fixed array indexed by a u8 slot number.
> >
> > Replace the per-entry pool pointer with that u8 slot index and resolve =
it
> > through a small helper that indexes the pools array.  The entry holds a
> > reference to its pool, which keeps the pool alive and its slot occupied=
,
> > so the lookup is safe without any lock or RCU read-side section.
> >
> > The u8 fits in the padding after the bool referenced field, shrinking t=
he
> > entry from 56 to 48 bytes on x86_64.  This raises objs_per_slab from 73
> > to 85 and saves about 2MiB of metadata per 1GiB of data held in zswap.
> >
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> > ---
> >  mm/zswap.c | 33 ++++++++++++++++++++++++++-------
> >  1 file changed, 26 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 603fdc418041..3974fca40a4a 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -213,7 +213,7 @@ static struct shrinker *zswap_shrinker;
> >   *              writeback logic. The entry is only reclaimed by the wr=
iteback
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> > - * pool - the zswap_pool the entry's data is in
> > + * pool_idx - slot of the zswap_pool that the entry's data is in.
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> > @@ -222,12 +222,24 @@ struct zswap_entry {
> >         swp_entry_t swpentry;
> >         unsigned int length;
> >         bool referenced;
> > -       struct zswap_pool *pool;
> > +       u8 pool_idx;
> >         unsigned long handle;
> >         struct obj_cgroup *objcg;
> >         struct list_head lru;
> >  };
> >
> > +static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
> > +{
> > +       /*
> > +        * The entry holds a reference to its pool, so the slot cannot =
be
> > +        * cleared or reused while the entry is alive: the read is stab=
le
> > +        * without the pools lock or an RCU read-side section.  Non-zer=
o
> > +        * pool_idx (slot 0 is unused) also marks a live entry for lock=
dep.
> > +        */
> > +       return rcu_dereference_protected(zswap_pools[entry->pool_idx],
> > +                                        entry->pool_idx !=3D 0);
>
> Please align the second parameter with the first as long as it doesn't
> exceed 100 chars.

Sure, I will fix the alignment in the next version.

Best regards,
Jianyue

