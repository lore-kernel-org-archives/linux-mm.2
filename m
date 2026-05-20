Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83463CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6F96B0005; Wed, 20 May 2026 03:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57C26B0088; Wed, 20 May 2026 03:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9467A6B008C; Wed, 20 May 2026 03:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 825706B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:22:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D4911A012D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:22:24 +0000 (UTC)
X-FDA: 84786955008.23.181C82C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FC8B20007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:22:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dh3LcHyt;
	spf=pass (imf03.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779261741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xx2spnpzWhoLag/qhNvFLWpyojrRWUzv888prY2ah/g=;
	b=os5ox8PNb/+obfck8kmbiTwHo1MRu5HM5BJFCtKxQ0dlb5zqGVzszJ/r5glCdxG2qh5VpB
	2pzNug3OkaHCpv2IOWFgFHmgV228aTa4A5RJfyyppnp8tnLfvREE2WQ3sAGVhaRFRAHzLu
	6iHhuEwy4Q6iTmbia8DQJGZnppt76/o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dh3LcHyt;
	spf=pass (imf03.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779261741; a=rsa-sha256;
	cv=none;
	b=c+4UwphHgdZ3jRL4P4osXXH17160zKn8h2dOSxXFxE5poh+Xje4q1XIwgFNgUKD7OdhsLJ
	BhVb6JeaL6/7UOMZ7XD8zrRLpnHouBpd6wAK5GrBzf9kekd4BPTve+eSYOwwXKfriNUMqz
	xpeRXZAZMw81Z2E+eRpj7BR6/pR2UzQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779261740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xx2spnpzWhoLag/qhNvFLWpyojrRWUzv888prY2ah/g=;
	b=Dh3LcHytxAY/Y1EENKRSb2i75wgzFySZf/+HM6MTqZEiWJlm+KXPAD1r+3czugMLuHw0q4
	8+GJ2ja9C4LwPHg+6p0XSKaQKPRkrFQP/5kDJJ6YmZnl4V4rqernexnM4HItSbAmKQ9d/X
	CWRuGMxMNlSbnod3H31NFv/zcCJsabs=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-4W0P-ua7P8isfmgfGBisTA-1; Wed, 20 May 2026 03:22:17 -0400
X-MC-Unique: 4W0P-ua7P8isfmgfGBisTA-1
X-Mimecast-MFC-AGG-ID: 4W0P-ua7P8isfmgfGBisTA_1779261737
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7bd6fc10a42so85567767b3.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 00:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779261737; x=1779866537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xx2spnpzWhoLag/qhNvFLWpyojrRWUzv888prY2ah/g=;
        b=fiDEE+usBOby486/i1tEZu7ti/bhPOaXfIliov+w5xlBgqevb1nXXq3v7XoUIYI1XN
         RWZZEpuq5jY+thlWZmhNE77T3YvD8UMHhgAG+sLG0iYv6EqOswOQAyclv4IiQyP80PzX
         dlUZbG0bE6jTN+4uHhyOni8CDXBK12cKx2WuwYOz4q61HT2V93CB4/MoUKjWA5ueY9ew
         k8OsNQwNrbcbsekH4JQYyQp/PtPoAczDOM81NfMk+Fi8jSgLrNBzTWgMiC/j2QTnxA4+
         MnQQbThuB8C6M+/umuhOnqamju0XMWnDhl/J9rPpUE1gyrDZpQo7vmC4SMbjeL+ZecAB
         2flg==
X-Forwarded-Encrypted: i=1; AFNElJ8Y5uy1zPtSzktl18zHmeRxDGoIgd+DrXayuMndHm6pbXikXjG7wr7zEHoxCfE/bV82pmen2NGIiw==@kvack.org
X-Gm-Message-State: AOJu0Yx55M2Px2hGfCuVrgA3++UfTi2kwbCw0VkIslksAcoIpDF4kx/l
	cWN/HmhUKPLuqKY3wSi4t+Qdc7GSc/4w51COKgkrBICzBrXwtVBdYbKoSD6eu4LA12FuyaV7HhH
	LWXo+cRt2SQydXqqkC5eUq0kV/nxCiQqD6PFrEi6cZnbtFbj8qa0lnliew3Hdf2y5Yoh+vcNcxv
	UXHcEjuz7QB5Gdy3HipkzaS86isGY=
X-Gm-Gg: Acq92OHDXOJvq+n4PELOq8wAytqbqH20dr+chYdvYQZzeXRPBVZ7CsDb5Ezp5wsFWbe
	OmO7qk0bVCPZKW77KsjOm8pjr4ncMVp0CZhre5AIVeoBiDk5vhkN29C+QrWbhj3AIwPa4XNuSFU
	8muhn+QgE8zKiocfZC/1ucnfkOfDFBUn1BYEQ70HnryduA7/DEprEhr8ykTYEy/itat8vomijcF
	Kox4A==
X-Received: by 2002:a05:690c:84:b0:7b5:88ec:91b0 with SMTP id 00721157ae682-7c95d1d9e08mr253826537b3.48.1779261736914;
        Wed, 20 May 2026 00:22:16 -0700 (PDT)
X-Received: by 2002:a05:690c:84:b0:7b5:88ec:91b0 with SMTP id
 00721157ae682-7c95d1d9e08mr253826267b3.48.1779261736472; Wed, 20 May 2026
 00:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
In-Reply-To: <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 20 May 2026 09:22:02 +0200
X-Gm-Features: AVHnY4KBhaLJ6-NKlQm0NilZQ57LVIjKu_pC_jcyJuZg3rPObvW4KXxjSx93n3c
Message-ID: <CADSE00L4R6PGtP6yGTZ6Ym=tvOZEYHRbuEtEu0BKX294HN6qXQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
To: Eric Chanudet <echanude@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, "T.J. Mercier" <tjmercier@google.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kgAMvWd-LjJYtqubNF7c66L5VbumiD7yzQZ6QqwUKt4_1779261737
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jptnmozogq199ntkmwb3w5qy7b8th75p
X-Rspamd-Queue-Id: 5FC8B20007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779261741-172947
X-HE-Meta: U2FsdGVkX19YrYAxi7Ux4NXjY3mp8s8DwrCXBqZ/k0Bny3/KHP4OKCBrZWLGs0WlVTE5u5hITL8fxoZnpmOTy24NV234Kzm9UGVAyi1fzQSB4jdTHqDyTPEOHSG0Fv582EL7v53xfENQvWhzcEbymNnVK65gY7yPGw4+o0Hei4LD1Xr2E8Ro5xSa/PdQwWqwz4CEjzIoW9M8E/9rLHWTi4FfLOemvryv+bykMvx74vz2eE3c7JzEDV8xgbJwunLKECBUTyMV+jFP9OZpQYNNFaTZQKztZYMnVPs3uLxvt7K+MzjN/TPzBp925FxbdFNoWl3fDdWVexawQ7fXhB6hJcavABrUkF2cSGuUJPi6AVhgAfwlkqkzerUAOlDsNAGHr/YgN+oKE4TruTJa2sFLi08fY/aNOmAd1V3QukoqBWX1RI8wOR4Q2sXE9uvTOe0umDoHodXMDwgLoZ/tNE4Kzb8/Ui1UfiA1r68oMtcSFOvpeRsas6f9/15AaIWN+59K9mBR5kFqQTXGv/IUP/zK78HICG1xz79zQU1QmwXuL6uN2nXqpbZOfq6MRk8HFoQV8LsuYSeHoO9QipgInfmgqWHH1x8s2UoRE+VSGgBlmiaQ9gMdbLHeFDl/vuFBiHijgKrCDyIfBo/xi5gjWaZeUpzNdLmQbvshjV9EVByppmbDMYEdYnrxJBzGpWF+rmyk7aCq+B2ounmrEh5aukU/Q58awvFeR9Ebcc/Q1c8AK0TxUSdyp5W5bx516Y/CdG2pSv5n4AiBJ7bZQRidqfj5CCfwbY0wq3eH6bCrPMPWSJyM2k6HqttjvnFO1V+FSeARta9WY3W1zLVX7qU6wE1g7BP/ftZPeMFJkLLIXpt9eT0u7sIqs1/8RHRi3bfZlKpiBsNYo4O8SjKv4+Hb2UEztNW3X160DpobKZpqXXunH6Adf2sQdwX2utGn/Jv9QwFxcXWqVh4oJKSbhMjdjkL
 lr3kE3u4
 cPiLh+Cbl+lf0m2Umopq+Shd69EE8MaGWi9yYtaAGTBxNF2dj5c2tPny0AKmDwalbGSP7KwW6C8DS+3CEc801UF5VWlg8lCqM28mCAwPbnN4qkWuTODoGBbocMBBf/UJlTdgzUKgU9m0wr7ZAVC4eRH0NoP/UziALuT0PlBOeM1ZC1Zds4xN4iAEKZPmSyQVNuEZSfUcq4iwHFPQTLWBV5ZRIgnB/MiZlIKvS6Z0cvs2VgI0mZuyFjdSuS7CZ+ISxZhAVU8/HwnCc9eh7kfck+j5ilDxhPSoR/7VpqaGaQic3a6fPpk2ek228A0b0Cygz1MrQAYKZMCyj7B0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 6:01=E2=80=AFPM Eric Chanudet <echanude@redhat.com>=
 wrote:
>
> Add mem_cgroup_dmem_charge() and mem_cgroup_dmem_uncharge() to allow
> dmem pool allocations to optionally be double-charged against the memory
> controller. Take the struct cgroup from the dmem pool's css as there is
> no convenient object exported to represent these allocations. These will
> resolve the effective memory css from that cgroup and perform the
> charge.
>
> Introduce a MEMCG_DMEM stat counter to memory.stat to make the cgroup's
> dmem charge visible.
>
> Signed-off-by: Eric Chanudet <echanude@redhat.com>

Reviewed-by: Albert Esteve <aesteve@redhat.com>

> ---
>  include/linux/memcontrol.h | 16 ++++++++++++
>  mm/memcontrol.c            | 65 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 81 insertions(+)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index dc3fa687759b45748b2acee6d7f43da325eb50c1..8e1d49b87fb64e6114f3eb920=
293e14920290fe7 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -39,6 +39,7 @@ enum memcg_stat_item {
>         MEMCG_ZSWAP_B,
>         MEMCG_ZSWAPPED,
>         MEMCG_ZSWAP_INCOMP,
> +       MEMCG_DMEM,
>         MEMCG_NR_STAT,
>  };
>
> @@ -1872,6 +1873,21 @@ static inline bool mem_cgroup_zswap_writeback_enab=
led(struct mem_cgroup *memcg)
>  }
>  #endif
>
> +#if defined(CONFIG_MEMCG) && defined(CONFIG_CGROUP_DMEM)
> +bool mem_cgroup_dmem_charge(struct cgroup *cgrp, unsigned int nr_pages,
> +                           gfp_t gfp_mask);
> +void mem_cgroup_dmem_uncharge(struct cgroup *cgrp, unsigned int nr_pages=
);
> +#else
> +static inline bool mem_cgroup_dmem_charge(struct cgroup *cgrp,
> +                                         unsigned int nr_pages, gfp_t gf=
p_mask)
> +{
> +       return true;
> +}
> +static inline void mem_cgroup_dmem_uncharge(struct cgroup *cgrp,
> +                                           unsigned int nr_pages)
> +{
> +}
> +#endif
>
>  /* Cgroup v1-related declarations */
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c03d4787d466803db49cdaa90e6d6ba426b7afe2..91a7ac16b6eac2d6c3700b688=
5a068bf8b640706 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -433,6 +433,7 @@ static const unsigned int memcg_stat_items[] =3D {
>         MEMCG_ZSWAP_B,
>         MEMCG_ZSWAPPED,
>         MEMCG_ZSWAP_INCOMP,
> +       MEMCG_DMEM,
>  };
>
>  #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> @@ -1606,6 +1607,9 @@ static const struct memory_stat memory_stats[] =3D =
{
>  #ifdef CONFIG_NUMA_BALANCING
>         { "pgpromote_success",          PGPROMOTE_SUCCESS       },
>  #endif
> +#ifdef CONFIG_CGROUP_DMEM
> +       { "dmem",                       MEMCG_DMEM              },
> +#endif
>  };
>
>  /* The actual unit of the state item, not the same as the output unit */
> @@ -5909,6 +5913,67 @@ static struct cftype zswap_files[] =3D {
>  };
>  #endif /* CONFIG_ZSWAP */
>
> +#ifdef CONFIG_CGROUP_DMEM
> +/**
> + * mem_cgroup_dmem_charge - charge memcg for a dmem pool allocation
> + * @cgrp: cgroup of the dmem pool
> + * @nr_pages: number of pages to charge
> + * @gfp_mask: reclaim mode
> + *
> + * Charges @nr_pages to @memcg. Returns %true if the charge fit within
> + * @memcg's configured limit, %false if it doesn't.
> + */
> +bool mem_cgroup_dmem_charge(struct cgroup *cgrp, unsigned int nr_pages,
> +                           gfp_t gfp_mask)
> +{
> +       struct cgroup_subsys_state *mem_css;
> +       struct mem_cgroup *memcg;
> +
> +       /* CGROUP_DMEM and MEMCG guarantees this cannot be NULL. */
> +       mem_css =3D cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
> +
> +       /* Use the memcg, if any, of the dmem cgroup. */
> +       memcg =3D mem_cgroup_from_css(mem_css);
> +       if (!memcg || mem_cgroup_is_root(memcg)) {
> +               css_put(mem_css);
> +               return false;
> +       }
> +
> +       if (try_charge_memcg(memcg, gfp_mask, nr_pages)) {
> +               css_put(mem_css);
> +               return false;
> +       }
> +
> +       mod_memcg_state(memcg, MEMCG_DMEM, nr_pages);
> +       css_put(mem_css);
> +       return true;
> +}
> +
> +/**
> + * mem_cgroup_dmem_uncharge - uncharge memcg from a dmem pool allocation
> + * @cgrp: cgroup of the dmem pool
> + * @nr_pages: number of pages to uncharge
> + */
> +void mem_cgroup_dmem_uncharge(struct cgroup *cgrp, unsigned int nr_pages=
)
> +{
> +       struct cgroup_subsys_state *mem_css;
> +       struct mem_cgroup *memcg;
> +
> +       /* CGROUP_DMEM and MEMCG guarantees this cannot be NULL. */
> +       mem_css =3D cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
> +
> +       memcg =3D mem_cgroup_from_css(mem_css);
> +       if (!memcg || mem_cgroup_is_root(memcg)) {
> +               css_put(mem_css);
> +               return;
> +       }
> +
> +       mod_memcg_state(memcg, MEMCG_DMEM, -nr_pages);
> +       refill_stock(memcg, nr_pages);
> +       css_put(mem_css);
> +}
> +#endif /* CONFIG_CGROUP_DMEM */
> +
>  static int __init mem_cgroup_swap_init(void)
>  {
>         if (mem_cgroup_disabled())
>
> --
> 2.52.0
>


