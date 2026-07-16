Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E897C44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 00:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71576B0088; Wed, 15 Jul 2026 20:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48D86B008A; Wed, 15 Jul 2026 20:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5F636B008C; Wed, 15 Jul 2026 20:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 915E36B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 20:56:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD31A1A037A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 00:56:58 +0000 (UTC)
X-FDA: 84992825316.14.66BE2EE
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id EE65B180005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 00:56:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ubkgjy7N;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784163416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqON3OrUt0fOomb2BLaFL3MREMgEqqs5y6so9+j5zoo=;
	b=wLYmjkxoWKfXSqO9emk2gsC/QelIlZxjk6oYX6fZKWjlVRi1DowLuSLGSvkQ8hY3KhyBwP
	f107zGWrrZGaDjzMigPehW23Vy2hXayyxbi/LFqAdtX4t7/oNxCx/0Nb3V4H4qimXJNq5d
	fRkqG0XRGhKme2u5pRmOyH7z6McxLCU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784163417;
	b=q95O2E4P7srzEw/g8vUGARdz6S+2Pm1fHw2/WyHl+FS3u744RH4XMP5iquq/GPwFwmPc9+
	Tor1ytkN7e5ebo863osFrzX0YQ2sa7cPd5WcMFhfwS+UzPtupWtd2DtNcyrslvfCgES2jp
	AJ2CnUyyhZI/4lRvVxNzoJe9h1Lib9o=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ubkgjy7N;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c10ed63c0so76381cf.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:56:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784163416; cv=none;
        d=google.com; s=arc-20260327;
        b=MzCXtgYc7sRPNMsAyWvzrjrcRxC+PzVmXSQ87HcCFwNbl/UIiaFkAZEh8SRTIMB90v
         WY5WTnxn7HJh3vkqdSC6TPyh/vxGooUUEl/Tx5tIbrMKCOZHOqU9U3LQYwGeBkNw0JUf
         /2kY1mjLN4Bt01+r/Xs2BtABeFEUZxpOv6MyWm/U9xugEY8LICG18Tg3HB2n2Ep2Rby/
         JDLZTkLc8Xgfrc2xbJx6+96ladgsbyf6Cf2qzi8RaEs/IkMpsmSDWDMGT4rIdYfjLkzK
         vVeXy7zcBH11tNOwj3co8ZcPqbdZM8kojTqgo/Jv5bQXkgvKtBhqLG8cT1TRuTXwaXdi
         sbQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PqON3OrUt0fOomb2BLaFL3MREMgEqqs5y6so9+j5zoo=;
        fh=8a56pIQLN8j4h9ZaQ6iZVrUkXzr65XJrQnaJQQextrc=;
        b=mq9mgxqmF8nN3kvVFEsTNfZD/eB+GIGiLmyKCDr4wAbxegvFuikAp6aNLjzMD4Xscy
         ef6B0jdO62x/sHQwwB+99cI03DzvJKPd0b6W0ynPKGn4kcAvwNcHfpaPrtTal89AkER1
         qWXIlkwBroMeGsGXd0BmLhigsLIYyeQN9r5dnnaUh5iCEFBKKlG9sVOWlLwg2pS0H/83
         aXavog4IqfvUlH7gkTD0nG3Zh6b0wQWxI/Ll/sJSL3vHplXbFV7g6XRHKuRWgmkyrON3
         0i+l1Byh2KOp+IcjSMoT37KbYeViviCc8AvWkdGRq628Gq4qilQUTxHvsCgRXzxNaYVa
         leDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784163416; x=1784768216; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PqON3OrUt0fOomb2BLaFL3MREMgEqqs5y6so9+j5zoo=;
        b=ubkgjy7NMs/tSVaplopuBiQsGXkqR3fW66+ZDWInS/Bp0s789xZJnmgu+svqQJD/P0
         TIdFs+DYrIpqP/QOkrt9Ba+6QWeowsZ9+qH/2BvnHVq6Y+gzL9kr4TLPoGYwUrM+0vxp
         7jTqKmuFmTgZmwaDJqfOziNM0eqNTQDGnRnTIFgsa5hnErSgTmSdEpRd3pIdSyeq2mNs
         q7lixdaNWgBuEziPIluxXW9G3SPyf9R6LC+0XzTBi6DcbXPBpG6h63CEzuwbdWUk8Sab
         1ce2vm0bXSJo8k2SDGwvPltC2vrnajH9ME/uLC6yLxS8nQ+HhbScZ9RWYB+IwBT15Sai
         gFjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784163416; x=1784768216;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PqON3OrUt0fOomb2BLaFL3MREMgEqqs5y6so9+j5zoo=;
        b=pwP7SyuSvUvp7ZQfyKbaQmvschboCfBHDSNvW9S1xFD8TXC0gwYLnVUtrdenYKDVVP
         eDuvg7ecN94jrXYaZujWB3tjK9RdWZsQNDN7BvNDR4UcFCuX04nLjTXeaRpXB1icezcS
         PNl5ZVqvr0QNFoUuhuNGGgcgrEliVGB0lZUGDS3moXeQgdxcmmBZ1IFGIYdsW08ZPhG9
         4Vq00FXlnJ8R8hs81ITn3gSxbBc/pQLmOnSbhWGhPU7qY5YizuUvuzU5gxLHjE/WdMSx
         uXflexKDv2sV/Yj82ShB/gZsEcnJ1D94RqD5un1K3lLsOkvBbBpg4M2Lt9LnGL8YvVqP
         G4IQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpaiu+QzC5BmHYEfa24k935oMY1As+mEhVa3gcblVg/gkdpPsep2nS8Y1sKoBjCXeuM4EdcNHD4Vw==@kvack.org
X-Gm-Message-State: AOJu0YxSuyY2Eip2Rg55ZBRtHT7GWI4uVVxTZiEDiPWlHGZz368a/qn+
	eKERPAHJ6ZDPaWer/V8wbOG0rOsfFKRjydSRUm2OQVK1MkD9Wq+QE9SOYiY10eRJHVX2QjBJJ7A
	J7YxiRH7Eo+mA25Y+gHNkOUWkQLEnizNyhwRxEU9/
X-Gm-Gg: AfdE7ckhpAIA2bJdZfB8elMNLuxFOHgK8rRMnf4UES/mcwWQGFqyjgZDWfUbaUJOt+7
	HuCWZOibclXj2ySrWfA2oaZVBwKn9pvq4ykA+NdeXvCt378Yn0q7O2q0jZ0VxOvCCxwxUKoeqli
	7Ub3f4BF4tVUDDVhxdXQ0t7UaPbJfofqMh8aOZ4+cO2q42/MobYZFgVnvDlDyZbXwYswx6/Aoi5
	EiGI1lFUuYbHZ3J9aa495lA9S331RVeFkhWQXUAMFkzJ4RJcXqyk6uRW4n0
X-Received: by 2002:a05:622a:4d95:b0:51b:fd21:c077 with SMTP id
 d75a77b69052e-51fa50ac9f9mr2206021cf.21.1784163415394; Wed, 15 Jul 2026
 17:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-3-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-3-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 17:56:44 -0700
X-Gm-Features: AUfX_mz6azLOlVXfbVD-t1IDS1r91veMOOF5VyiUSpL7t9Z77OmdvGy3eUFl1w4
Message-ID: <CAJuCfpEoPjFttCsZPo158pH95ChoBV6N9SMD6Qs5vi4w-G8y5w@mail.gmail.com>
Subject: Re: [PATCH RFC 03/12] mm: move struct slabobj_ext to mm/slab.h
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE65B180005
X-Stat-Signature: gtkbhou4fufc15fgkgzo5ps4swjbj5qj
X-HE-Tag: 1784163416-193660
X-HE-Meta: U2FsdGVkX1/gt/Q8HH+b9C0IHpolp6vSVgr97MORbOYRieahJsc6xKh+nE0yuCRhjrfLuhsbs0GRMhVOMG8beWfwihQ+mvzfmTWP3NBgcvgC+CbSdhoJLJ2c7iL93YIsGCZHNxVcBVIsrUc36LTYCb/gGfBqJZnbpxp2tITP3jgBVoK10e5e2D98DrqEjt4a0o65lMhZZWkFC5IQUNZrB1/vK3BAOJH/gp6scD3ZvV8eYZTfyW5H/d/aAFxlK8GBJjBHy16cnyZPhQxQXBvmALcVfwjr4nLNw2sXebEbmjapv3ajXnLhqsIFmMOfDQ0v37rt50CeoRbMylh2TyKmNd+cJh5KIP15xrlSOYTRRgPgWKFZZ/j5Dv1KVIv+kyFzOQjgrGHAkGpxSP2l/8SgWWzduWi7t3UYFBR0vA8Ou/sLisaTNjjz/P9SUzlpl25/ORLx2tk2xtjdr2dfaNWzkfOaI6na33mO4q1VmrtXbLbNPtJ3ZbEH947NoYnbFo8JTi6buP+tiRjVc8Z+9eSpCXJf9NE9q2b+/Z5RO/64AMGro1sgpyyCHfpb1v0adDE8BdqQML67jb8c7/p7lES52qbVUIFfcCIf/xw755ynjlazpSwlKwghy/Uen+CJojhh/ERQ7QdY5zp42XsbKSBxwquDCG5R6ud3C6l6OPRKuZ8quMS5komrfBFhjV2BFR4v9GyXohIFJBclpOr762WlA7pt0DVZFVznuKGRengpd3Mz2CFxhjh2RIA0aZJ3xxDeZvwkJR0XZnc8N05Hw55W2XNU8S68k6HluGxTPMAGB21t6MkfuhtBjH0guP0mU9Ic1YEPslP+y+CYrfOZa7ps2MFk7i1yX2h9IL8bItd6WvpIbmn8qV0tTc1yF3MwGnjp9s/eonJwP97KykZNow0J4U4qicVYSaOLZlb3NIUp/zU9x36mTwSJTSJNKc+6std5VuT7fe+qxYujrPbgXaS
 L4bztoAO
 2Q5E1C90OkAzRgTPhrgX4yiBw+iEM99OLemAMhbVDoMYbufSaFyP6DuuEHJ32ZAWGJUrIBsFUfUap6qccRK5kRakkDgZxuB4M/N/pP4G4uJEdqKIinqcmT2ZpqYvwf//Dozd4Kp/D9dEFKz9lIu3cgRZ3U/OaLldx9lfnBQ9V1RqZtm3Yomdbrk6kiBRehuN81QQ9w2G9mChO8jog5r8MD7p8tsBktBPO1HwigBZasXFdCe0z8zZW42WzZO+LymV9RA40ZNUhhCz1IZmLsRK/b5WjehinSSE3lMkQwRyUTu1UzhHNkLpr94jSwuOWMwUa5R2aPj6fgj32ty4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> Users of include/linux/memcontrol.h don't need to see this internal
> structure. Further changes to the struct will reduce recompiling.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/memcontrol.h | 13 -------------
>  mm/slab.h                  | 13 +++++++++++++
>  2 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1f46a0016fc..93869cc35c25 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1440,19 +1440,6 @@ static inline void mem_cgroup_flush_workqueue(void=
) { }
>  static inline int mem_cgroup_init(void) { return 0; }
>  #endif /* CONFIG_MEMCG */
>
> -/*
> - * Extended information for slab objects stored as an array in page->mem=
cg_data
> - * if MEMCG_DATA_OBJEXTS is set.
> - */
> -struct slabobj_ext {
> -#ifdef CONFIG_MEMCG
> -       struct obj_cgroup *objcg;
> -#endif
> -#ifdef CONFIG_MEM_ALLOC_PROFILING
> -       union codetag_ref ref;
> -#endif
> -} __aligned(8);
> -
>  static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
>  {
>         struct mem_cgroup *memcg;
> diff --git a/mm/slab.h b/mm/slab.h
> index 01535e1e2d3c..7bd361447c54 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -549,6 +549,19 @@ static inline bool need_kmalloc_no_objext(void)
>         return false;
>  }
>
> +/*
> + * Extended information for slab objects stored as an array in page->mem=
cg_data
> + * if MEMCG_DATA_OBJEXTS is set.
> + */
> +struct slabobj_ext {
> +#ifdef CONFIG_MEMCG
> +       struct obj_cgroup *objcg;
> +#endif
> +#ifdef CONFIG_MEM_ALLOC_PROFILING
> +       union codetag_ref ref;
> +#endif
> +} __aligned(8);
> +
>  #ifdef CONFIG_SLAB_OBJ_EXT
>
>  /*
>
> --
> 2.55.0
>

