Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6768D262A7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 22:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B746B0005; Tue, 20 Jan 2026 17:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20EFF6B0088; Tue, 20 Jan 2026 17:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6266B0089; Tue, 20 Jan 2026 17:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECB7F6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:25:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80FEC58B04
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:25:42 +0000 (UTC)
X-FDA: 84353775324.25.9B690DE
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80DA4C0003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:25:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Qs1w+bBU;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768947940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44dOOwNB1nzUj6Js371cPSz9QaCzmdjxiuuzpRwtXwc=;
	b=BG3l4kcGDmhnU0UQ3uvxevmpteRanqVWXJqYxjTpjuWR54orAUPfirK8OVM3+7Q0T8ioBJ
	tIBx2nuxfGg4GLXpfm97qGlCzE0v5WIHTikseBKxYoQnxBY2wXam1bkyFq4VcGTGeb6wXO
	wJaF8pfWnMusUU3wA3Gf88yxFEzRPZA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Qs1w+bBU;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768947940; a=rsa-sha256;
	cv=pass;
	b=OSbXq7tJdF1iwsSvPM0h13tlIPXa1rulbrUiU9fIHYBcFOBQLCyskG0VXlNPlqd7IbTHiL
	HqaDW1P9VV1FIeqF+MEPTzwz3JYH+PnDAXd1msdv6TZMVNrtEzpN1/Slm9QnF26oMR+dcT
	uwY+bSCW6oA23jcZ4xWqUAfFXZTxOgs=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50299648ae9so62961cf.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:25:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768947939; cv=none;
        d=google.com; s=arc-20240605;
        b=QRF0I3HySFI7PB/lgwClkh25xw2INyEYhzgWHlPFuQTZ9wUEnrUmwOAfGQOTstfjDe
         CytsF7PS9Adzmnwoxk4Az1Gym/pp4Qdll0HEAM/IXnLZBVQaf1BvgXLwZKCVeCRBiPYx
         sbOikjuZnAfoKLXMwI9W5x9FXSkqAmzGaN7bKx1IQW3IweJpV8Upft2ybDT+7JLMgsBG
         IkJdZi2la8Lbx63whNaS+rLKA0n0GG/lkqkeoqdJ4XaxetMikNo8bdpIgvK9NeTrTj+N
         sy11tmBg1pcLY/OBdVJsA4ftj3JAoT92FSCuxr+aRuKJli+XB4SOBuYfAPrrNeiNyW1B
         QUxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=44dOOwNB1nzUj6Js371cPSz9QaCzmdjxiuuzpRwtXwc=;
        fh=at2tEoKGCfEBEkIyYRZq8XCJ58Fz4lGkErauvO4hiSI=;
        b=RTIFlG1dOR1jRw+LpRIuA7d2ObxklNSLAXJiIovieGQGr9Dj+PzeoST7Hp3aIy1xG7
         OnPNqhBiuZ0zbI9am0KSpfTBkxAYRgPAiyRPfuqtYmU6g6fgzcvVScT9EECzbs2JSBqI
         iRGsnsFiCPhru0eE5oo3wKxye5LlgF9vw9xxMldK5aLJumt6wn6IwDmgdZ41Pn6KJSFt
         zitF4jSLOVqWOGF0TVoUgdjdM/6tfvRhg4r5nShUj6pvjFHKqOV96ANJ+k3J6tYI3R5t
         Tb10rHa5aSgeMsYsN3+1AWh5lDh97DQBM67UsngcpVk8tP9JO6FMh0BzW6WUFz0hJSkC
         KImA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768947939; x=1769552739; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44dOOwNB1nzUj6Js371cPSz9QaCzmdjxiuuzpRwtXwc=;
        b=Qs1w+bBUvR7imu+33AKIDgWMjed+xEbwSj3mOuiPyfDJPz0QvPg1aozUFr9ezBfKAA
         ypY0X3CRJXm/8f1RY/Q3CoMr6EIp45JLERD8/ozcxApNV1jH9c2titw4Yb50EjvFoc/7
         /A6gzpcCVQWV2COfhJcUrgzqJW3SZxdT7EPFZpVEbBPEtKWhpL9B+bq+SyNbV0fYFXRY
         hxS8EEyOpxELosAvYinzjrdHXDOI0M8hzyczDZbdRAQ5YUu1p0W/QTVAzYvWfHVBwyl2
         KOG+NEHHDPfleQj8JSQ78MPHrqzRvd5aNCEh6Qmydy6hNjK239S2f234NLtMBYBchLQY
         x+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768947939; x=1769552739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=44dOOwNB1nzUj6Js371cPSz9QaCzmdjxiuuzpRwtXwc=;
        b=ifqNByQoqvIqnMvn7syHaclY1+orpdXl1kpQoMt2DjbItVAihvVjbRcVI3oOWIuUfs
         RmV7HFaRUi4MoFiNNflodZmMNpCijguBWV/ZHCBq7eLxx202tHniAtwwqWGooHL8nxUa
         etaZ/6UebJgYFnSqQnJhciH77jcZgw3zS7KTNLPRl0sz1D8VePbUZs97E6xxcPi8RFoa
         du27p0U6D/8M2BbSZwxlWx8JpUaOcj2cMHLZEO/rduEf2wkqm/QpvPlcZ4WN4Lb+qS3K
         yTc1voM27+ZXLdHzBilj59lUtI7XLiipMl5aNvL7W12B+JGCmaM9uqNF5ZoBFavGsWcF
         HRzg==
X-Forwarded-Encrypted: i=1; AJvYcCUhL0OOW85CMuU8jpWJS7TKhDyXfsTQhirR64duXMutSF82WlBn8DJnq+7TPDRjT5TlqRWjjmnt6g==@kvack.org
X-Gm-Message-State: AOJu0Yzm7MDmmDjNcq0Gmz18aC0P7RxoPZXCbnz/aMBfppSnbI7GWvUY
	eztGzR5DK+WU6fDAxjacHkK+ccQqPcEqA02U4MwM9Xxr8vFFhqSi7x+ORPiz1GrS752bgTVCl2a
	ms7Czca2r05Jc95LQXKZaouZXuJ6URYHnpxcXlZ7K
X-Gm-Gg: AY/fxX4muQESDneAWkMIgcWk+A/T64ngmAXFG78EPtYUPh1hWP6bc0oatjeNSYbsoAO
	teXLkDdpIFBCLCTUJh7z01L59EKxYDhF6aWv8FN+5E6U5cD8TYGOtEpWV5xf+tnxiY+18xOk5al
	0c/CDALxXmxjWQNhbUkWKRrWWpQ4qMO62jSBKlg2C9VW4okjI3y7fiW/0JJ5QdHj9AUVj8H0/2M
	9vI/0E0gjAFRyIbKudhNPLJ8vXKCPzej5bDBHwInIGxN+1jg0Q5hzg499SIslsFsr5CW1s0N1Lh
	w+a0jnpq1USLSffZiMmhnLY=
X-Received: by 2002:a05:622a:1181:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-502e1ab389cmr1281971cf.17.1768947938936; Tue, 20 Jan 2026
 14:25:38 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 20 Jan 2026 22:25:27 +0000
X-Gm-Features: AZwV_QgM-BqnduoA5RFORFxa5mM3qHJ9TZZetAs0zM1kLzOUnwUT9c3G3wjCAp8
Message-ID: <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
Subject: Re: [PATCH v3 11/21] slab: remove SLUB_CPU_PARTIAL
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 80DA4C0003
X-Stat-Signature: rk613gr5zgwxnwu58jbgywhp4a8mgoz6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768947940-849166
X-HE-Meta: U2FsdGVkX1+4rtpHhR/+OTj3QbDlxFjaKU2mluX6akQihu8np9cCtSa5QW3uKFh3oXKBe27T4NjO9L/WcNGG7b99txwIiAQflRYNY2MWpAUWc9YaKqFgsxuPzKlBT8Bbyg22t67zkPnaRyTsznpdL+CdSCMu7YAYFrC/nRaj/rwg9COZhsf7CCePPHF7YZ+jkELk9hioCF788IrzHTw9aQvP9fpge7e4OjPiHVixL1/RfRtwYlNA1/b3Z6uORqFG69m5AHMpZWLuo4nnpYziylgpJh1OufQTBF6WgOaggOop02Dao2hmhcgEE8QaigS6Wrs6Y6tjPK3SlDNSKT7I37U5V2XT+GaVFP4iXHuUjE/FBoU9d88vUr6RyaUuQyVPIhZPZhFU1PH61yIpoSn6cye6JM7eOTGWzMkeURBTVeQhTY21SkEMC0NOdrH08AdcYUNBbZAoovPwwL56RHUgxH/yjJo0aCOLQzPU9dutfNoR5jWtLwW82Y9vP7j0Iovf2aGSmTYByDLRCHdcx0EzHDSr6HEIaJmoi1abq0hVPyXFFaMJs9V2H7vZ4GKJPk2AXV1LUDvv6MWBX84sk8cHyaQ2+Tv6R41xx3FJGfTgj+lZyk+bCOn7uarCQJRf2oIm3yuJxZAp8N6y5xkprNkbmooAE5o9hRxTVxJ/vuQgsR0ifJ3z6uRzJicAF7md5b7jxdyD06LMb2foM2ILIHexKv+Gfefc7HBMa3VgkkVekEAuX53dsj28oFpK0Ri+VC32Nl9SV6gCWZCuZgfJq+PByBLbHQgDmJZY3Hhp09/zAC0gdeVK5JIcmzBIvnh2eoGvGfcN+QgJEfFSfxsHyotPcMkxnGyxfHcQAGOfCEFaawa5vwibjN4Pg6hfB4lUzb5EXW/B5+uVCjISofkkzwRCkzo2gJEk8oQnDUYuvwQl2Yuwu+O7ah/vt9adNiyJV+xMPoLAMyj8oPAOZaOdal2
 Nnhdhxuk
 y+3qPHFY+8n8Q5zbYcA+8IMx9u6OuEOg5hw/1biVIxfEFVm3xvv7d7FDb57J0c6w7dHuHQQuo3fQDpFZBaTDfhKvxRn6jGb6M2FMo5YtTqT64jD932+61EKU3PZENF2U95dZ5JcwLfrtvGwgtMa6x5qpO8/Vb97zJ9p7q8j7CBBa6xnB5yXNJQBEfTW0LiqPbctEURMfbUo2Kt8iKPll/xBG2fQxxD1aZ8zNkvt8oqUGSlCIrbN3WeWPctCEvspN323DHWEWVHfC2jqGwfI8rk01Lm+vqNkR3sqZ/kah80L81M/5x+w0G4nWjJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:40=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> We have removed the partial slab usage from allocation paths. Now remove
> the whole config option and associated code.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

I did? Well, if so, I missed some remaining mentions about cpu partial cach=
es:
- slub.c has several hits on "cpu partial" in the comments.
- there is one hit on "put_cpu_partial" in slub.c in the comments.

Should we also update Documentation/ABI/testing/sysfs-kernel-slab to
say that from now on cpu_partial control always reads 0?

Once addressed, please feel free to keep my Reviewed-by.

> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/Kconfig |  11 ---
>  mm/slab.h  |  29 ------
>  mm/slub.c  | 321 ++++---------------------------------------------------=
------
>  3 files changed, 19 insertions(+), 342 deletions(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd0ea5454af8..08593674cd20 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -247,17 +247,6 @@ config SLUB_STATS
>           out which slabs are relevant to a particular load.
>           Try running: slabinfo -DA
>
> -config SLUB_CPU_PARTIAL
> -       default y
> -       depends on SMP && !SLUB_TINY
> -       bool "Enable per cpu partial caches"
> -       help
> -         Per cpu partial caches accelerate objects allocation and freein=
g
> -         that is local to a processor at the price of more indeterminism
> -         in the latency of the free. On overflow these caches will be cl=
eared
> -         which requires the taking of locks that may cause latency spike=
s.
> -         Typically one would choose no for a realtime system.
> -
>  config RANDOM_KMALLOC_CACHES
>         default n
>         depends on !SLUB_TINY
> diff --git a/mm/slab.h b/mm/slab.h
> index cb48ce5014ba..e77260720994 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -77,12 +77,6 @@ struct slab {
>                                         struct llist_node llnode;
>                                         void *flush_freelist;
>                                 };
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -                               struct {
> -                                       struct slab *next;
> -                                       int slabs;      /* Nr of slabs le=
ft */
> -                               };
> -#endif
>                         };
>                         /* Double-word boundary */
>                         struct freelist_counters;
> @@ -188,23 +182,6 @@ static inline size_t slab_size(const struct slab *sl=
ab)
>         return PAGE_SIZE << slab_order(slab);
>  }
>
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -#define slub_percpu_partial(c)                 ((c)->partial)
> -
> -#define slub_set_percpu_partial(c, p)          \
> -({                                             \
> -       slub_percpu_partial(c) =3D (p)->next;     \
> -})
> -
> -#define slub_percpu_partial_read_once(c)       READ_ONCE(slub_percpu_par=
tial(c))
> -#else
> -#define slub_percpu_partial(c)                 NULL
> -
> -#define slub_set_percpu_partial(c, p)
> -
> -#define slub_percpu_partial_read_once(c)       NULL
> -#endif // CONFIG_SLUB_CPU_PARTIAL
> -
>  /*
>   * Word size structure that can be atomically updated or read and that
>   * contains both the order and the number of objects that a slab of the
> @@ -228,12 +205,6 @@ struct kmem_cache {
>         unsigned int object_size;       /* Object size without metadata *=
/
>         struct reciprocal_value reciprocal_size;
>         unsigned int offset;            /* Free pointer offset */
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -       /* Number of per cpu partial objects to keep around */
> -       unsigned int cpu_partial;
> -       /* Number of per cpu partial slabs to keep around */
> -       unsigned int cpu_partial_slabs;
> -#endif
>         unsigned int sheaf_capacity;
>         struct kmem_cache_order_objects oo;
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 698c0d940f06..6b1280f7900a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -263,15 +263,6 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
>         return p;
>  }
>
> -static inline bool kmem_cache_has_cpu_partial(struct kmem_cache *s)
> -{
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -       return !kmem_cache_debug(s);
> -#else
> -       return false;
> -#endif
> -}
> -
>  /*
>   * Issues still to be resolved:
>   *
> @@ -426,9 +417,6 @@ struct freelist_tid {
>  struct kmem_cache_cpu {
>         struct freelist_tid;
>         struct slab *slab;      /* The slab from which we are allocating =
*/
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -       struct slab *partial;   /* Partially allocated slabs */
> -#endif
>         local_trylock_t lock;   /* Protects the fields above */
>  #ifdef CONFIG_SLUB_STATS
>         unsigned int stat[NR_SLUB_STAT_ITEMS];
> @@ -673,29 +661,6 @@ static inline unsigned int oo_objects(struct kmem_ca=
che_order_objects x)
>         return x.x & OO_MASK;
>  }
>
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -static void slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_o=
bjects)
> -{
> -       unsigned int nr_slabs;
> -
> -       s->cpu_partial =3D nr_objects;
> -
> -       /*
> -        * We take the number of objects but actually limit the number of
> -        * slabs on the per cpu partial list, in order to limit excessive
> -        * growth of the list. For simplicity we assume that the slabs wi=
ll
> -        * be half-full.
> -        */
> -       nr_slabs =3D DIV_ROUND_UP(nr_objects * 2, oo_objects(s->oo));
> -       s->cpu_partial_slabs =3D nr_slabs;
> -}
> -#elif defined(SLAB_SUPPORTS_SYSFS)
> -static inline void
> -slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
> -{
> -}
> -#endif /* CONFIG_SLUB_CPU_PARTIAL */
> -
>  /*
>   * If network-based swap is enabled, slub must keep track of whether mem=
ory
>   * were allocated from pfmemalloc reserves.
> @@ -3474,12 +3439,6 @@ static void *alloc_single_from_new_slab(struct kme=
m_cache *s, struct slab *slab,
>         return object;
>  }
>
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -static void put_cpu_partial(struct kmem_cache *s, struct slab *slab, int=
 drain);
> -#else
> -static inline void put_cpu_partial(struct kmem_cache *s, struct slab *sl=
ab,
> -                                  int drain) { }
> -#endif
>  static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
>
>  static bool get_partial_node_bulk(struct kmem_cache *s,
> @@ -3898,131 +3857,6 @@ static void deactivate_slab(struct kmem_cache *s,=
 struct slab *slab,
>  #define local_unlock_cpu_slab(s, flags)        \
>         local_unlock_irqrestore(&(s)->cpu_slab->lock, flags)
>
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -static void __put_partials(struct kmem_cache *s, struct slab *partial_sl=
ab)
> -{
> -       struct kmem_cache_node *n =3D NULL, *n2 =3D NULL;
> -       struct slab *slab, *slab_to_discard =3D NULL;
> -       unsigned long flags =3D 0;
> -
> -       while (partial_slab) {
> -               slab =3D partial_slab;
> -               partial_slab =3D slab->next;
> -
> -               n2 =3D get_node(s, slab_nid(slab));
> -               if (n !=3D n2) {
> -                       if (n)
> -                               spin_unlock_irqrestore(&n->list_lock, fla=
gs);
> -
> -                       n =3D n2;
> -                       spin_lock_irqsave(&n->list_lock, flags);
> -               }
> -
> -               if (unlikely(!slab->inuse && n->nr_partial >=3D s->min_pa=
rtial)) {
> -                       slab->next =3D slab_to_discard;
> -                       slab_to_discard =3D slab;
> -               } else {
> -                       add_partial(n, slab, DEACTIVATE_TO_TAIL);
> -                       stat(s, FREE_ADD_PARTIAL);
> -               }
> -       }
> -
> -       if (n)
> -               spin_unlock_irqrestore(&n->list_lock, flags);
> -
> -       while (slab_to_discard) {
> -               slab =3D slab_to_discard;
> -               slab_to_discard =3D slab_to_discard->next;
> -
> -               stat(s, DEACTIVATE_EMPTY);
> -               discard_slab(s, slab);
> -               stat(s, FREE_SLAB);
> -       }
> -}
> -
> -/*
> - * Put all the cpu partial slabs to the node partial list.
> - */
> -static void put_partials(struct kmem_cache *s)
> -{
> -       struct slab *partial_slab;
> -       unsigned long flags;
> -
> -       local_lock_irqsave(&s->cpu_slab->lock, flags);
> -       partial_slab =3D this_cpu_read(s->cpu_slab->partial);
> -       this_cpu_write(s->cpu_slab->partial, NULL);
> -       local_unlock_irqrestore(&s->cpu_slab->lock, flags);
> -
> -       if (partial_slab)
> -               __put_partials(s, partial_slab);
> -}
> -
> -static void put_partials_cpu(struct kmem_cache *s,
> -                            struct kmem_cache_cpu *c)
> -{
> -       struct slab *partial_slab;
> -
> -       partial_slab =3D slub_percpu_partial(c);
> -       c->partial =3D NULL;
> -
> -       if (partial_slab)
> -               __put_partials(s, partial_slab);
> -}
> -
> -/*
> - * Put a slab into a partial slab slot if available.
> - *
> - * If we did not find a slot then simply move all the partials to the
> - * per node partial list.
> - */
> -static void put_cpu_partial(struct kmem_cache *s, struct slab *slab, int=
 drain)
> -{
> -       struct slab *oldslab;
> -       struct slab *slab_to_put =3D NULL;
> -       unsigned long flags;
> -       int slabs =3D 0;
> -
> -       local_lock_cpu_slab(s, flags);
> -
> -       oldslab =3D this_cpu_read(s->cpu_slab->partial);
> -
> -       if (oldslab) {
> -               if (drain && oldslab->slabs >=3D s->cpu_partial_slabs) {
> -                       /*
> -                        * Partial array is full. Move the existing set t=
o the
> -                        * per node partial list. Postpone the actual unf=
reezing
> -                        * outside of the critical section.
> -                        */
> -                       slab_to_put =3D oldslab;
> -                       oldslab =3D NULL;
> -               } else {
> -                       slabs =3D oldslab->slabs;
> -               }
> -       }
> -
> -       slabs++;
> -
> -       slab->slabs =3D slabs;
> -       slab->next =3D oldslab;
> -
> -       this_cpu_write(s->cpu_slab->partial, slab);
> -
> -       local_unlock_cpu_slab(s, flags);
> -
> -       if (slab_to_put) {
> -               __put_partials(s, slab_to_put);
> -               stat(s, CPU_PARTIAL_DRAIN);
> -       }
> -}
> -
> -#else  /* CONFIG_SLUB_CPU_PARTIAL */
> -
> -static inline void put_partials(struct kmem_cache *s) { }
> -static inline void put_partials_cpu(struct kmem_cache *s,
> -                                   struct kmem_cache_cpu *c) { }
> -
> -#endif /* CONFIG_SLUB_CPU_PARTIAL */
> -
>  static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cp=
u *c)
>  {
>         unsigned long flags;
> @@ -4060,8 +3894,6 @@ static inline void __flush_cpu_slab(struct kmem_cac=
he *s, int cpu)
>                 deactivate_slab(s, slab, freelist);
>                 stat(s, CPUSLAB_FLUSH);
>         }
> -
> -       put_partials_cpu(s, c);
>  }
>
>  static inline void flush_this_cpu_slab(struct kmem_cache *s)
> @@ -4070,15 +3902,13 @@ static inline void flush_this_cpu_slab(struct kme=
m_cache *s)
>
>         if (c->slab)
>                 flush_slab(s, c);
> -
> -       put_partials(s);
>  }
>
>  static bool has_cpu_slab(int cpu, struct kmem_cache *s)
>  {
>         struct kmem_cache_cpu *c =3D per_cpu_ptr(s->cpu_slab, cpu);
>
> -       return c->slab || slub_percpu_partial(c);
> +       return c->slab;
>  }
>
>  static bool has_pcs_used(int cpu, struct kmem_cache *s)
> @@ -5646,13 +5476,6 @@ static void __slab_free(struct kmem_cache *s, stru=
ct slab *slab,
>                 return;
>         }
>
> -       /*
> -        * It is enough to test IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) below
> -        * instead of kmem_cache_has_cpu_partial(s), because kmem_cache_d=
ebug(s)
> -        * is the only other reason it can be false, and it is already ha=
ndled
> -        * above.
> -        */
> -
>         do {
>                 if (unlikely(n)) {
>                         spin_unlock_irqrestore(&n->list_lock, flags);
> @@ -5677,26 +5500,19 @@ static void __slab_free(struct kmem_cache *s, str=
uct slab *slab,
>                  * Unless it's frozen.
>                  */
>                 if ((!new.inuse || was_full) && !was_frozen) {
> +
> +                       n =3D get_node(s, slab_nid(slab));
>                         /*
> -                        * If slab becomes non-full and we have cpu parti=
al
> -                        * lists, we put it there unconditionally to avoi=
d
> -                        * taking the list_lock. Otherwise we need it.
> +                        * Speculatively acquire the list_lock.
> +                        * If the cmpxchg does not succeed then we may
> +                        * drop the list_lock without any processing.
> +                        *
> +                        * Otherwise the list_lock will synchronize with
> +                        * other processors updating the list of slabs.
>                          */
> -                       if (!(IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && was_=
full)) {
> -
> -                               n =3D get_node(s, slab_nid(slab));
> -                               /*
> -                                * Speculatively acquire the list_lock.
> -                                * If the cmpxchg does not succeed then w=
e may
> -                                * drop the list_lock without any process=
ing.
> -                                *
> -                                * Otherwise the list_lock will synchroni=
ze with
> -                                * other processors updating the list of =
slabs.
> -                                */
> -                               spin_lock_irqsave(&n->list_lock, flags);
> -
> -                               on_node_partial =3D slab_test_node_partia=
l(slab);
> -                       }
> +                       spin_lock_irqsave(&n->list_lock, flags);
> +
> +                       on_node_partial =3D slab_test_node_partial(slab);
>                 }
>
>         } while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"=
));
> @@ -5709,13 +5525,6 @@ static void __slab_free(struct kmem_cache *s, stru=
ct slab *slab,
>                          * activity can be necessary.
>                          */
>                         stat(s, FREE_FROZEN);
> -               } else if (IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && was_ful=
l) {
> -                       /*
> -                        * If we started with a full slab then put it ont=
o the
> -                        * per cpu partial list.
> -                        */
> -                       put_cpu_partial(s, slab, 1);
> -                       stat(s, CPU_PARTIAL_FREE);
>                 }
>
>                 /*
> @@ -5744,10 +5553,9 @@ static void __slab_free(struct kmem_cache *s, stru=
ct slab *slab,
>
>         /*
>          * Objects left in the slab. If it was not on the partial list be=
fore
> -        * then add it. This can only happen when cache has no per cpu pa=
rtial
> -        * list otherwise we would have put it there.
> +        * then add it.
>          */
> -       if (!IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && unlikely(was_full)) {
> +       if (unlikely(was_full)) {

This is not really related to your change but I wonder why we check
for was_full to detect that the slab was not on partial list instead
of checking !on_node_partial... They might be equivalent at this point
but it's still a bit confusing.

>                 add_partial(n, slab, DEACTIVATE_TO_TAIL);
>                 stat(s, FREE_ADD_PARTIAL);
>         }
> @@ -6396,8 +6204,8 @@ static __always_inline void do_slab_free(struct kme=
m_cache *s,
>                 if (unlikely(!allow_spin)) {
>                         /*
>                          * __slab_free() can locklessly cmpxchg16 into a =
slab,
> -                        * but then it might need to take spin_lock or lo=
cal_lock
> -                        * in put_cpu_partial() for further processing.
> +                        * but then it might need to take spin_lock
> +                        * for further processing.
>                          * Avoid the complexity and simply add to a defer=
red list.
>                          */
>                         defer_free(s, head);
> @@ -7707,39 +7515,6 @@ static int init_kmem_cache_nodes(struct kmem_cache=
 *s)
>         return 1;
>  }
>
> -static void set_cpu_partial(struct kmem_cache *s)
> -{
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -       unsigned int nr_objects;
> -
> -       /*
> -        * cpu_partial determined the maximum number of objects kept in t=
he
> -        * per cpu partial lists of a processor.
> -        *
> -        * Per cpu partial lists mainly contain slabs that just have one
> -        * object freed. If they are used for allocation then they can be
> -        * filled up again with minimal effort. The slab will never hit t=
he
> -        * per node partial lists and therefore no locking will be requir=
ed.
> -        *
> -        * For backwards compatibility reasons, this is determined as num=
ber
> -        * of objects, even though we now limit maximum number of pages, =
see
> -        * slub_set_cpu_partial()
> -        */
> -       if (!kmem_cache_has_cpu_partial(s))
> -               nr_objects =3D 0;
> -       else if (s->size >=3D PAGE_SIZE)
> -               nr_objects =3D 6;
> -       else if (s->size >=3D 1024)
> -               nr_objects =3D 24;
> -       else if (s->size >=3D 256)
> -               nr_objects =3D 52;
> -       else
> -               nr_objects =3D 120;
> -
> -       slub_set_cpu_partial(s, nr_objects);
> -#endif
> -}
> -
>  static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
>                                              struct kmem_cache_args *args=
)
>
> @@ -8595,8 +8370,6 @@ int do_kmem_cache_create(struct kmem_cache *s, cons=
t char *name,
>         s->min_partial =3D min_t(unsigned long, MAX_PARTIAL, ilog2(s->siz=
e) / 2);
>         s->min_partial =3D max_t(unsigned long, MIN_PARTIAL, s->min_parti=
al);
>
> -       set_cpu_partial(s);
> -
>         s->cpu_sheaves =3D alloc_percpu(struct slub_percpu_sheaves);
>         if (!s->cpu_sheaves) {
>                 err =3D -ENOMEM;
> @@ -8960,20 +8733,6 @@ static ssize_t show_slab_objects(struct kmem_cache=
 *s,
>                         total +=3D x;
>                         nodes[node] +=3D x;
>
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -                       slab =3D slub_percpu_partial_read_once(c);
> -                       if (slab) {
> -                               node =3D slab_nid(slab);
> -                               if (flags & SO_TOTAL)
> -                                       WARN_ON_ONCE(1);
> -                               else if (flags & SO_OBJECTS)
> -                                       WARN_ON_ONCE(1);
> -                               else
> -                                       x =3D data_race(slab->slabs);
> -                               total +=3D x;
> -                               nodes[node] +=3D x;
> -                       }
> -#endif
>                 }
>         }
>
> @@ -9108,12 +8867,7 @@ SLAB_ATTR(min_partial);
>
>  static ssize_t cpu_partial_show(struct kmem_cache *s, char *buf)
>  {
> -       unsigned int nr_partial =3D 0;
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -       nr_partial =3D s->cpu_partial;
> -#endif
> -
> -       return sysfs_emit(buf, "%u\n", nr_partial);
> +       return sysfs_emit(buf, "0\n");
>  }
>
>  static ssize_t cpu_partial_store(struct kmem_cache *s, const char *buf,
> @@ -9125,11 +8879,9 @@ static ssize_t cpu_partial_store(struct kmem_cache=
 *s, const char *buf,
>         err =3D kstrtouint(buf, 10, &objects);
>         if (err)
>                 return err;
> -       if (objects && !kmem_cache_has_cpu_partial(s))
> +       if (objects)
>                 return -EINVAL;
>
> -       slub_set_cpu_partial(s, objects);
> -       flush_all(s);
>         return length;
>  }
>  SLAB_ATTR(cpu_partial);
> @@ -9168,42 +8920,7 @@ SLAB_ATTR_RO(objects_partial);
>
>  static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
>  {
> -       int objects =3D 0;
> -       int slabs =3D 0;
> -       int cpu __maybe_unused;
> -       int len =3D 0;
> -
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -       for_each_online_cpu(cpu) {
> -               struct slab *slab;
> -
> -               slab =3D slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu=
));
> -
> -               if (slab)
> -                       slabs +=3D data_race(slab->slabs);
> -       }
> -#endif
> -
> -       /* Approximate half-full slabs, see slub_set_cpu_partial() */
> -       objects =3D (slabs * oo_objects(s->oo)) / 2;
> -       len +=3D sysfs_emit_at(buf, len, "%d(%d)", objects, slabs);
> -
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -       for_each_online_cpu(cpu) {
> -               struct slab *slab;
> -
> -               slab =3D slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu=
));
> -               if (slab) {
> -                       slabs =3D data_race(slab->slabs);
> -                       objects =3D (slabs * oo_objects(s->oo)) / 2;
> -                       len +=3D sysfs_emit_at(buf, len, " C%d=3D%d(%d)",
> -                                            cpu, objects, slabs);
> -               }
> -       }
> -#endif
> -       len +=3D sysfs_emit_at(buf, len, "\n");
> -
> -       return len;
> +       return sysfs_emit(buf, "0(0)\n");
>  }
>  SLAB_ATTR_RO(slabs_cpu_partial);
>
>
> --
> 2.52.0
>

