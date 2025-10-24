Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E11CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D877A8E00F6; Fri, 24 Oct 2025 15:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D377C8E00C9; Fri, 24 Oct 2025 15:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26158E00F6; Fri, 24 Oct 2025 15:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A83CD8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:43:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40A6EC0F5F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:43:34 +0000 (UTC)
X-FDA: 84034032348.02.44CB2C7
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3C91840006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:43:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UCV8a5IV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761335012; a=rsa-sha256;
	cv=none;
	b=mqRCK2puRIht0MCX91SPHEpEPjBD+foXjycZQuT+hYj0j4AQCwjP5CB6jhENcOuQaTOnC+
	7sa2Po1YX77c8QR7conw8tcRcxEojolASzfpNehfZUKffaIon2IGtkxSIu/u0xikzh0hoG
	WMhxro0uIizN56aKtMCmgzJ965eIKNg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UCV8a5IV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761335012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90XaxFEyCpkV47QCzVcKxG5N1KKEds9BtveeKPxtNeE=;
	b=pux/9J4mHEoxdZecqm2pMq93C3ksh6rE2nn6RTxAL4aL3QcOZYGx4oQEv04ZxF3Wp5Q7Ec
	bf2qAWCHqZl1aMZBqS05wB0oziGAlBsrxXOGDO+XOScwl9uRd6OfhfEI1EHp/8g7o341q3
	KIKXz1D0bKUh+zSuNIoE1d+el+nlkq0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e6a689bd0so23440385e9.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761335010; x=1761939810; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90XaxFEyCpkV47QCzVcKxG5N1KKEds9BtveeKPxtNeE=;
        b=UCV8a5IVsi2NT+2Re30REUX/cYarE7VoURFX0kI4OwIgJC8PRH35P+mFsVSluLilJs
         UfJogHEw7KcEAqndeTBnQXNwOBlgveUvgq03/fQa2bALP6pfp2fMK3H7zpYaqmKEXlPI
         d9UwJdYgHaL7ammHPZ2tkG05z/tU1AIoJ/tpxAxffpeFSSsqsZCgxcmcn/1QI4rFu9qh
         BHN5wm9OGymBrDqe0S5jFMlb0ebNYnSvyHUboxRSm8eJyRhsOt7nGoVstWvn2z4jrSDw
         RIS2Dz8yfbNTRZ8e6mjUbPn+L/9F1YNHEWhDzmppFSmcsrW2OdJ9EHeMjlV7wGpba/kY
         wH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761335010; x=1761939810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=90XaxFEyCpkV47QCzVcKxG5N1KKEds9BtveeKPxtNeE=;
        b=Uj1gdJ1RK+aJrFlvNUjlmW6LThCCa3jT0IA86+K+FXTXwSfm/0tPhfnYeZl7gctdAH
         3B92jZYEDM3z3HRRdYmmDOhGltwiq6wJboJEukINvy/IeORHFq4P+Wh005f7r6zYR457
         VwWy++Dk8xAwtoDq/FwyRaCbN+3BGBsE19ytnOte2cZZ1FKJ6zkt1fG5A8YDfhk7SoNH
         OC0GLNQjM31q01CGUa5Ui9Ps0SMSFh5QFEbTevr3B7Qh3+vUoKBRUbokCxu+CMH0krBP
         tlLeQrPfgO/AhMaf/SzYNlIfr1zJz/TkaUiSnPPSJI2LUAHPM+qhm/FAcjOCI9ghPsCg
         gMjw==
X-Forwarded-Encrypted: i=1; AJvYcCU0IdJvkM/hLdzZF4W2/sVipvjsXsdJn281rCD9Tm6dd4iaAB2FyoaswZbPEdCdDFKwoUL41++LxQ==@kvack.org
X-Gm-Message-State: AOJu0YwgdCiKsJ2VreZ+mMGMnkJhSfWhZIUXfofcdnD02DSKb+2XlhQu
	JT2tyHKivQe3i2ysFwQIc5B8xDuJbA2Wyhf1szRoTbogBAy2kcThqZfVVVCtA9BQZMw8ckRheje
	CFqs1owqXFhW/HTaZMQQ95ptQH62vInU=
X-Gm-Gg: ASbGncvJm5FlztmlS0csdVqS0qWKl2n7l265/r75iXnegS8ZiIjnFEyLAm3hyn72x3E
	BKFFiZzFIzafY+doCNzfNjKx4QwwqAI2eoSzVLxtNaNRUZPxXYkiyZ33E+qjmypbZT1qrNwFFkh
	uXeXEi6QpclATSYGbTVj+UpdNQs4aHO4xRYf4zHvMdpwUL2+rGn0sA9FFwsxwnNDhhogD0+hElb
	btuuIPGwUBDyyEWw6XO5YpvoQiN+mYVPrt57MZXIcmT9dizyJFWL/+kMPSPX2Wqxjz75fUKrDs1
	jbMLySRceYI0/3QNWRoboLSgnCDM
X-Google-Smtp-Source: AGHT+IGlhgaHR7jFg9+tMxl+vQhbMYL40wY/+fohU6NDJjpXaCt4CPnZUsK/fNBWdwfFYQyXTJ3GI3NvxqyaKNwKNEI=
X-Received: by 2002:a05:600c:3149:b0:46f:b43a:aef0 with SMTP id
 5b1f17b1804b1-47117925e63mr211257905e9.41.1761335010286; Fri, 24 Oct 2025
 12:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz> <20251023-sheaves-for-all-v1-7-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-7-6ffa2c9941c0@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 Oct 2025 12:43:18 -0700
X-Gm-Features: AWmQ_bk-kyewHYgpxUqtmCiyFoLA8j75cYs74Mz6Re-SJFA0srIhl0qtPOmknRs
Message-ID: <CAADnVQLAFkYLLJbMjEyzEu=Q7aJSs19Ddb1qXqEWNnxm6=CDFg@mail.gmail.com>
Subject: Re: [PATCH RFC 07/19] slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
To: Vlastimil Babka <vbabka@suse.cz>, Chris Mason <clm@meta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rippqwcdgj69rjb59te4z8sip7ihtj88
X-Rspamd-Queue-Id: 3C91840006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761335012-622934
X-HE-Meta: U2FsdGVkX18OcJV7xoBqYSFRIczJ1YoadJjyVJguheSwRQ3UfIdWRjNcowjmJ2Nv7SY6ruDnQ3rdjpIi6G8xS5j65vWf4a3UB72jkip/K+LrzyaoaCNIUkgkWX+nTuEq1aUTXrr50YeqGtjWkugqPTx7fZVCd66HW5kyLQpsXRCQDBO4naM4HAGdJpkN+cgzMZVq2jY7CMsjqAAQbQphSB2/y2m54vJtaUHua1SRlXfzfLQMW1f+y1dmqvECvkvhtpg+/p0/d1NZmDgE5N8NKf5p48OVcdjsyfsA+OwdMNtGEwfzeCkqy+e8skxKPS5niXlpwN3KyciP1RGRqb7cwE8NppYXY2BEtM0tfWqlxr1a5urgyMy40XMMoEyyZmK2Q3/wlFSHfQfdujD7RsUF7kAgeCQYTF6eCUKLrS25QDys21BEWKdPnBYyDeY3TVD7/w66aYcIEqGMWbBMcS80MmVbbKSqx84M5uQ+ZmwOwC/OnzwuaqONFyw5osp12xinRDCs44wVPejMrirQ5b54PUGUJf2qraHf8yRQajOjlg7RFLYvi/KJf7rArWk3PrsbbuPQfTPO5WLLK3S+UL9eeHy4fPH/ahnoH/7bDEw4dJCxyNQs0k3RUMCCUjnWCfr2TdMb6aZQy0Pgh3w1lYoBFkzsOZ+hsRrMPOJxu21o8rKn8Y9ETkSv9hYvQ2s4sY/bsLb280fbQ3qU9q6nr0HQA9ZzpKyRET3WXAleznB/uQLjINknQ3mpx1O5DmcU/iZuhqEHEOvKIQTEAdcxH28F/zwpO48GDEIKqwMn9hFSwjfWcdXMIHa+tKWt4iADJRW6WlGL51poWZhy170iJQJmv3Faep/MqbGd2n3EdT/Q1Yae9O0stw8EuKEY0ipxM1oIQqg/kzQtfDllai3jIaDI0xyiLs4SZL8fSxykhPDD+WwkuxRi4epfhRa8sGFNIrfyFSRS7sWWdeyj+jyc0AO
 fCdb72YM
 g7Wn3C/AgW9YRAXSUimR+O5uDSc2+6xgOtjVcSQZxXByANuiM73YLg42zBIUMyAhOE0zzhtY/bZtNYa8X6/byxFAWRoNvZEFbo3gMmZSFbQzXTuaJ8n5ByTqEz7L1hix3KKjWaMaJHer4Qo9tEAFyfdFFMC1oeqY8Bwgo5sj3x1wONfmtjsUglu+cXANoPT9xnUk1+iG9K1Kok5oCMel6CfbpraN0eF0mhziAQa6o3jMRlQ7TRwRNEPtpeQuBjqWtscLoxzNfDORLsSFgtvlhkfPQKzD5Unn2z9KNTXeJqPAigui50/S14BnrNTt6ipLb38dqn3aj6i0ySgxVcYpTRKuOJzloZEBH4ajpfTPIUHupK4F/aWWxjxdC77D5a52HBJYSpwrL+9YtmYCIqVQaUYm6f+3hwM16B+TSWfKPmQe2ebdhLZ/x7tW9JQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 6:53=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Before we enable percpu sheaves for kmalloc caches, we need to make sure
> kmalloc_nolock() and kfree_nolock() will continue working properly and
> not spin when not allowed to.
>
> Percpu sheaves themselves use local_trylock() so they are already
> compatible. We just need to be careful with the barn->lock spin_lock.
> Pass a new allow_spin parameter where necessary to use
> spin_trylock_irqsave().
>
> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
> for now it will always fail until we enable sheaves for kmalloc caches
> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 74 ++++++++++++++++++++++++++++++++++++++++++++-------------=
------
>  1 file changed, 52 insertions(+), 22 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index ecb10ed5acfe..5d0b2cf66520 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2876,7 +2876,8 @@ static void pcs_destroy(struct kmem_cache *s)
>         s->cpu_sheaves =3D NULL;
>  }
>
> -static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
> +static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
> +                                              bool allow_spin)
>  {
>         struct slab_sheaf *empty =3D NULL;
>         unsigned long flags;
> @@ -2884,7 +2885,10 @@ static struct slab_sheaf *barn_get_empty_sheaf(str=
uct node_barn *barn)
>         if (!data_race(barn->nr_empty))
>                 return NULL;
>
> -       spin_lock_irqsave(&barn->lock, flags);
> +       if (likely(allow_spin))
> +               spin_lock_irqsave(&barn->lock, flags);
> +       else if (!spin_trylock_irqsave(&barn->lock, flags))
> +               return NULL;
>
>         if (likely(barn->nr_empty)) {
>                 empty =3D list_first_entry(&barn->sheaves_empty,
> @@ -2961,7 +2965,8 @@ static struct slab_sheaf *barn_get_full_or_empty_sh=
eaf(struct node_barn *barn)
>   * change.
>   */
>  static struct slab_sheaf *
> -barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empt=
y)
> +barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empt=
y,
> +                        bool allow_spin)
>  {
>         struct slab_sheaf *full =3D NULL;
>         unsigned long flags;
> @@ -2969,7 +2974,10 @@ barn_replace_empty_sheaf(struct node_barn *barn, s=
truct slab_sheaf *empty)
>         if (!data_race(barn->nr_full))
>                 return NULL;
>
> -       spin_lock_irqsave(&barn->lock, flags);
> +       if (likely(allow_spin))
> +               spin_lock_irqsave(&barn->lock, flags);
> +       else if (!spin_trylock_irqsave(&barn->lock, flags))
> +               return NULL;
>
>         if (likely(barn->nr_full)) {
>                 full =3D list_first_entry(&barn->sheaves_full, struct sla=
b_sheaf,
> @@ -2990,7 +2998,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, st=
ruct slab_sheaf *empty)
>   * barn. But if there are too many full sheaves, reject this with -E2BIG=
.
>   */
>  static struct slab_sheaf *
> -barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
> +barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
> +                       bool allow_spin)
>  {
>         struct slab_sheaf *empty;
>         unsigned long flags;
> @@ -3001,7 +3010,10 @@ barn_replace_full_sheaf(struct node_barn *barn, st=
ruct slab_sheaf *full)
>         if (!data_race(barn->nr_empty))
>                 return ERR_PTR(-ENOMEM);
>
> -       spin_lock_irqsave(&barn->lock, flags);
> +       if (likely(allow_spin))
> +               spin_lock_irqsave(&barn->lock, flags);
> +       else if (!spin_trylock_irqsave(&barn->lock, flags))
> +               return NULL;

AI did a good job here. I spent an hour staring at the patch
for other reasons. Noticed this bug too and then went
"ohh, wait, AI mentioned it already". Time to retire.

>         if (likely(barn->nr_empty)) {
>                 empty =3D list_first_entry(&barn->sheaves_empty, struct s=
lab_sheaf,
> @@ -5000,7 +5012,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, stru=
ct slub_percpu_sheaves *pcs,
>                 return NULL;
>         }
>
> -       full =3D barn_replace_empty_sheaf(barn, pcs->main);
> +       full =3D barn_replace_empty_sheaf(barn, pcs->main,
> +                                       gfpflags_allow_spinning(gfp));
>
>         if (full) {
>                 stat(s, BARN_GET);
> @@ -5017,7 +5030,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, stru=
ct slub_percpu_sheaves *pcs,
>                         empty =3D pcs->spare;
>                         pcs->spare =3D NULL;
>                 } else {
> -                       empty =3D barn_get_empty_sheaf(barn);
> +                       empty =3D barn_get_empty_sheaf(barn, true);
>                 }
>         }
>
> @@ -5154,7 +5167,8 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gf=
p, int node)
>  }
>
>  static __fastpath_inline
> -unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void=
 **p)
> +unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t=
 size,
> +                                void **p)
>  {
>         struct slub_percpu_sheaves *pcs;
>         struct slab_sheaf *main;
> @@ -5188,7 +5202,8 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache =
*s, size_t size, void **p)
>                         return allocated;
>                 }
>
> -               full =3D barn_replace_empty_sheaf(barn, pcs->main);
> +               full =3D barn_replace_empty_sheaf(barn, pcs->main,
> +                                               gfpflags_allow_spinning(g=
fp));
>
>                 if (full) {
>                         stat(s, BARN_GET);
> @@ -5693,7 +5708,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_=
flags, int node)
>         gfp_t alloc_gfp =3D __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
>         struct kmem_cache *s;
>         bool can_retry =3D true;
> -       void *ret =3D ERR_PTR(-EBUSY);
> +       void *ret;
>
>         VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
>                                       __GFP_NO_OBJ_EXT));
> @@ -5720,6 +5735,13 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp=
_flags, int node)
>                  */
>                 return NULL;
>
> +       ret =3D alloc_from_pcs(s, alloc_gfp, node);
> +

I would remove the empty line here.

> +       if (ret)
> +               goto success;
> +
> +       ret =3D ERR_PTR(-EBUSY);
> +
>         /*
>          * Do not call slab_alloc_node(), since trylock mode isn't
>          * compatible with slab_pre_alloc_hook/should_failslab and
> @@ -5756,6 +5778,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_=
flags, int node)
>                 ret =3D NULL;
>         }
>
> +success:
>         maybe_wipe_obj_freeptr(s, ret);
>         slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
>                              slab_want_init_on_alloc(alloc_gfp, s), size)=
;
> @@ -6047,7 +6070,8 @@ static void __pcs_install_empty_sheaf(struct kmem_c=
ache *s,
>   * unlocked.
>   */
>  static struct slub_percpu_sheaves *
> -__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves=
 *pcs)
> +__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves=
 *pcs,
> +                       bool allow_spin)
>  {
>         struct slab_sheaf *empty;
>         struct node_barn *barn;
> @@ -6071,7 +6095,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struc=
t slub_percpu_sheaves *pcs)
>         put_fail =3D false;
>
>         if (!pcs->spare) {
> -               empty =3D barn_get_empty_sheaf(barn);
> +               empty =3D barn_get_empty_sheaf(barn, allow_spin);
>                 if (empty) {
>                         pcs->spare =3D pcs->main;
>                         pcs->main =3D empty;
> @@ -6085,7 +6109,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struc=
t slub_percpu_sheaves *pcs)
>                 return pcs;
>         }
>
> -       empty =3D barn_replace_full_sheaf(barn, pcs->main);
> +       empty =3D barn_replace_full_sheaf(barn, pcs->main, allow_spin);
>
>         if (!IS_ERR(empty)) {
>                 stat(s, BARN_PUT);
> @@ -6093,6 +6117,11 @@ __pcs_replace_full_main(struct kmem_cache *s, stru=
ct slub_percpu_sheaves *pcs)
>                 return pcs;
>         }
>
> +       if (!allow_spin) {
> +               local_unlock(&s->cpu_sheaves->lock);
> +               return NULL;
> +       }

and would add a comment here to elaborate that the next
steps like sheaf_flush_unused() and alloc_empty_sheaf()
cannot handle !allow_spin.


> +
>         if (PTR_ERR(empty) =3D=3D -E2BIG) {
>                 /* Since we got here, spare exists and is full */
>                 struct slab_sheaf *to_flush =3D pcs->spare;
> @@ -6160,7 +6189,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struc=
t slub_percpu_sheaves *pcs)
>   * The object is expected to have passed slab_free_hook() already.
>   */
>  static __fastpath_inline
> -bool free_to_pcs(struct kmem_cache *s, void *object)
> +bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
>  {
>         struct slub_percpu_sheaves *pcs;
>
> @@ -6171,7 +6200,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object=
)
>
>         if (unlikely(pcs->main->size =3D=3D s->sheaf_capacity)) {
>
> -               pcs =3D __pcs_replace_full_main(s, pcs);
> +               pcs =3D __pcs_replace_full_main(s, pcs, allow_spin);
>                 if (unlikely(!pcs))
>                         return false;
>         }
> @@ -6278,7 +6307,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *=
obj)
>                         goto fail;
>                 }
>
> -               empty =3D barn_get_empty_sheaf(barn);
> +               empty =3D barn_get_empty_sheaf(barn, true);
>
>                 if (empty) {
>                         pcs->rcu_free =3D empty;
> @@ -6398,7 +6427,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, =
size_t size, void **p)
>                 goto no_empty;
>
>         if (!pcs->spare) {
> -               empty =3D barn_get_empty_sheaf(barn);
> +               empty =3D barn_get_empty_sheaf(barn, true);

I'm allergic to booleans in arguments. They make callsites
hard to read. Especially if there are multiple bools.
We have horrendous lines in the verifier that we still need
to clean up due to bools:
check_load_mem(env, insn, true, false, false, "atomic_load");

barn_get_empty_sheaf(barn, true); looks benign,
but I would still use enum { DONT_SPIN, ALLOW_SPIN }
and use that in all functions instead of 'bool allow_spin'.

Aside from that I got worried that sheaves fast path
may be not optimized well by the compiler:
if (unlikely(pcs->main->size =3D=3D 0)) ...
object =3D pcs->main->objects[pcs->main->size - 1];
// object is accessed here
pcs->main->size--;

since object may alias into pcs->main and the compiler
may be tempted to reload 'main'.
Looks like it's fine, since object point is not actually read or written.
gcc15 asm looks good:
        movq    8(%rbx), %rdx   # _68->main, _69
        movl    24(%rdx), %eax  # _69->size, _70
# ../mm/slub.c:5129:    if (unlikely(pcs->main->size =3D=3D 0)) {
        testl   %eax, %eax      # _70
        je      .L2076  #,
.L1953:
# ../mm/slub.c:5135:    object =3D pcs->main->objects[pcs->main->size - 1];
        leal    -1(%rax), %esi  #,
# ../mm/slub.c:5135:    object =3D pcs->main->objects[pcs->main->size - 1];
        movq    32(%rdx,%rsi,8), %rdi   # prephitmp_309->objects[_81], obje=
ct
# ../mm/slub.c:5135:    object =3D pcs->main->objects[pcs->main->size - 1];
        movq    %rsi, %rax      #,
# ../mm/slub.c:5137:    if (unlikely(node_requested)) {
        testb   %r15b, %r15b    # node_requested
        jne     .L2077  #,
.L1954:
# ../mm/slub.c:5149:    pcs->main->size--;
        movl    %eax, 24(%rdx)  # _81, prephitmp_30->size

