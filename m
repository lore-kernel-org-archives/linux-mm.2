Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E00D216B4
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 16:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062C46B008C; Thu,  4 Dec 2025 11:39:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039726B00BB; Thu,  4 Dec 2025 11:39:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43C96B00BD; Thu,  4 Dec 2025 11:39:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7B886B008C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:39:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82C4913A772
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:39:08 +0000 (UTC)
X-FDA: 84182348376.17.33AAB54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E91714000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:39:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OjxnYYA8;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764866346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neM2aFFGXkdhFk1Bgngnbt+CCpd3u3ncCxbfP639ydc=;
	b=Yvc1HDLtyjTuqOxLposCP4clPEcrVtmv8Y9IuOTFK3fVnR/wxA1943g0UMgR6xGYFro6C7
	IxWVcAfcYuOMgC6ULR/SaNlo5O6Rv8CI3ugQ5ipa3fS6ardDLDIg88eghTAn/oVdPtitwh
	+Beyem43zR3iJZ4Nn+RCvcgUP1a+XWw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OjxnYYA8;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764866346; a=rsa-sha256;
	cv=none;
	b=yc7x742fyhBw0M8Mn8BHfJzoePdF39CG3e05xNdEehpcWrusytVh16Ha3rF3UvL9mdKGux
	exhOMzow7VE5mSi7yhAeJVdcPHz1ZgcHeN/oWwZUUqn3uNaJGX+NffHqS5NFf9CKoAkrKQ
	GlXYcAh5mxX5XR7uRM0KVhemBQK9q7I=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429ce7e79f8so818273f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 08:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764866345; x=1765471145; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=neM2aFFGXkdhFk1Bgngnbt+CCpd3u3ncCxbfP639ydc=;
        b=OjxnYYA8UVjtSKf/V6a0HR8yfQ3XM88ORyaRXD9y9aqMJkNJt0EuuPqOmMyRgGrZoi
         vtLGpEwpmihboYHrUMqGtHWBBBEJVRLLI1FBcK4SKLlS2NtUHXxL0L2K8uaZmXfPHty5
         bb+vSBXgE1tNol8OxIm7bTivZIMQwb+p/fFWD49lsbxv/kr4qErXbl2jENjN/1HHsW3h
         mg/XO5MK2DKMr+GkZf8R7B8CSqvR3pS+ejsLYHkwZ4DJedrRArdeQWjjJvhzw0NnZodM
         D+XBr/XJyMCTzjcI7Ko0tapxtCJUUkMy7sxAGBLlRLmJzKJz7BdwqbVTfb5PolviQu3t
         ruMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764866345; x=1765471145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=neM2aFFGXkdhFk1Bgngnbt+CCpd3u3ncCxbfP639ydc=;
        b=BQvrL2eadb94BCJltUw3O1BN07kgTGv/yUskVSigTkqcHFYeGYxNmsQ0Y3DFrcNl5l
         KX1FbJ8tFjfCSr+rADEX3SiJBSA4S3PFeSQJ6nQIxd0WuLKrqVL5qu/YF80UUKTGdX2q
         Qs5Ih04vlOnaELaC6kp2hMoDybaT7k0W3AhDsBigO0tPVepSSRhDdNISHFveBLJbu9Qn
         ha0/ilQhj2ef+hL9IlNFu0jnmptc143BVpAmQXhJ7RC5nbdM+NNEbXBkA7fsfN+wSBTx
         4xu/0ngl3YZKqo4mtGFFumHPw5YvcMjIEPd+5KHPQhHuWFoMhTCHyECPipRjsWd9XiWE
         hOow==
X-Gm-Message-State: AOJu0YyjyAKm1API9MGkLlyqsa+TdVKo8742LrDjK0VD5HI/nbm8TcCL
	6AMSbLjZ49V/XzIegqzW3H2X5yrafydGO8XqktbKM2sQj1MDSCw+xFfRjSmQezccYi9FrICfemz
	eauCHqArIRnUeKH+FT2gocrDDXDrIMSY=
X-Gm-Gg: ASbGncsjbVSH1g3N7IbTms8n9UisAVa68OPMtRFZd68icrMq91rjeuqirtxyj8JQkCy
	9usFgml6GT9a45RMEweH2xSWKMgSncNfq6XdQMlYHdkrr3uloKlQjS9ncqpwg5E5JQrfB8wzFhT
	w7vH4W7UwvAXEhIV0fkKkZ768B2eZqvWiyzuGBai0as3McNAnOV2zr4LBNXZeM7xO+YVWpZW4Bh
	svAxXxgW8811ILMMAO94at+o2RcXFABbnNyiJuI79ECYhG5wgMDPcbolM0pFEq8q2hcYtr6yjR9
	hSR7UuyTpFECYgz13EkbUqkyfro6LDkLiurzNcg=
X-Google-Smtp-Source: AGHT+IHoodyyNldCFLAHSL99GtNDC0mgxYwiy2LhCAjNxaLnR0UmBgujNCAg0JZR/0N90Dq070py5kyBptf8+EpoBYw=
X-Received: by 2002:a5d:5f84:0:b0:42c:a449:d6ab with SMTP id
 ffacd0b85a97d-42f7984151bmr3587206f8f.30.1764866344934; Thu, 04 Dec 2025
 08:39:04 -0800 (PST)
MIME-Version: 1.0
References: <20251128033320.1349620-1-bhe@redhat.com> <20251128033320.1349620-2-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-2-bhe@redhat.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 17:38:54 +0100
X-Gm-Features: AWmQ_bkK3QIZDgXBUmjiM3wqIjjTq9eL1_nc5mEHts5eDeieA_K5fYtO6D27Mp0
Message-ID: <CA+fCnZfDYHUVKX-hdX3SgmuvJEU-U+MuUJGjs-wJJnfRDHz2sw@mail.gmail.com>
Subject: Re: [PATCH v4 01/12] mm/kasan: add conditional checks in functions to
 return directly if kasan is disabled
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8E91714000A
X-Rspamd-Server: rspam02
X-Stat-Signature: ixadm5x871h3x45ji5wkzsfbjczdmc44
X-Rspam-User: 
X-HE-Tag: 1764866346-432692
X-HE-Meta: U2FsdGVkX1/ahLFjOyyVfjtMuSwgyGZxv0mnQkUY13ZyoNXRwB5KzRlk31E7z5snfj3rsq2IaZEr0pT4TD75MaRHvGo032fvJA4Gy/wGe086cePz5cr88F9Qp+QgHxJ1kZbg37+8xsaiDTu0y3+Ptcs4og6VDJNQ3bFjJNhHdGPq7eymaKHPCH1ZegBttIVQaN41K/a5SpatfJDM//wlZYaalv96Gvrz882C6D/PjF6aHUCYZKzT0JxS3HPgaJsv8CNqKjoeDJBDwJDv6BMK3qgHOTqnttEaiRQcZcubFdRPDAnLmnMguOorA/3oXwzHQLBgUs3kkTkCdowARQd4TMfYEaDxvNw9RvVSsVczKDu7prU7MVKuvHqXcIu9U+ek5zQ+62CFwaITzyQETe94EuSVnx6f5/AoW6RGp3lc5UKYxW/g/6n4xEt48lDe3K8Y3GSDt5rKScyfSdruV3umionJLtpD0MeHcGY9PdnxFOLTMxzil3edAZJEH+tWHfNnlaoqfyx5Ekc5slCeo6RIjFCLxaJ8reLtfubtSDvJtAxHSN6GdHQy6m1s9FxT+6ApA6yEaBS4S5a05E1q+xo28zqO54xbBpCYirX6CcHkSWV3cSt2+sAKwhyXtyjv6IznJsTwhbreC8QRgBsX21smUPWaHUHAeShVyEz+Uq774/1S0XUrYIwGI1hgR7Lg8KQsITST858xDPyYX6lvXj71IE01+j3m+9/We1KAoEfmpdFwWKNQimKBCs68MM/00H5HswqCCTmtYD5QVOHM7W5su3IetjAAgT4fvqTkQxlulgIbYclS3d7FVpK6JIa88jlusnlK/YdElA7JZSiP2Z6Rr3E+e7GrCqfgjzAWBR9GaueAcujajFcISNpxoh61ftaVQAzWInJm4S0+zN2IOXp9zTa/jxey5yn1R1xPUB5dRKHSAjoqLi8oO+BQdIldsE0aSN3G64zz8E409KdfVxi
 x7ZW6Nj3
 niQJIbRX0WHeNRE70UZfeJ1aVRpgPtJoxqK5wpOIpJqWHaL1aSeUOSTaAnnFeM541BITjnqP92wgkelIKkAAEru3yFRJFv8kc5QZyMU1Yjs41tAV4FPjxf/J7LnZHUYXyF56m9AZizzVjeBoSJ7T76fWx15iOie4/7fv6080Ss23BoWwd1rbNM04TLsxNin2ExcntBgQkiMIcIJk8PkBXUmK6Rcm7kj0VkaN8OcJe8ssJ3tUFNhm34hLHF0fW+ItB8FAm9XADUU5mudMOu24yHkT6EmfMx3trl4FZ4z5znyrrrpMTnt26axFA+yXvRGAB28uPFnqUsCDm/J2h51DhSIufW4a9VHA+/zp1Dp+sKWOsWWtchgce7AjXVhKFwZQx56savmOnpWI7LLzlJooyy5XMiSCPYltPwFtbEaGq+x5gB4/Qu2h8nFa687I1756lQYSo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 4:33=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> The current codes only check if kasan is disabled for hw_tags
> mode. Here add the conditional checks for functional functions of
> generic mode and sw_tags mode.
>
> This is prepared for later adding kernel parameter kasan=3Don|off for
> all three kasan modes.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  mm/kasan/generic.c    | 17 +++++++++++++++--
>  mm/kasan/init.c       |  6 ++++++
>  mm/kasan/quarantine.c |  3 +++
>  mm/kasan/report.c     |  4 +++-
>  mm/kasan/shadow.c     | 11 ++++++++++-
>  mm/kasan/sw_tags.c    |  3 +++
>  6 files changed, 40 insertions(+), 4 deletions(-)
>
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index 2b8e73f5f6a7..aff822aa2bd6 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -214,12 +214,13 @@ bool kasan_byte_accessible(const void *addr)
>
>  void kasan_cache_shrink(struct kmem_cache *cache)
>  {
> -       kasan_quarantine_remove_cache(cache);
> +       if (kasan_enabled())

Please move these checks to include/linux/kasan.h and add __helpers to
consistent with how it's done for other KASAN annotation calls.
Otherwise eventually these checks start creeping into lower level
functions and the logic of checking when and whether KASAN is enabled
becomes a mess.



> +               kasan_quarantine_remove_cache(cache);
>  }
>
>  void kasan_cache_shutdown(struct kmem_cache *cache)
>  {
> -       if (!__kmem_cache_empty(cache))
> +       if (kasan_enabled() && !__kmem_cache_empty(cache))
>                 kasan_quarantine_remove_cache(cache);
>  }
>
> @@ -239,6 +240,9 @@ void __asan_register_globals(void *ptr, ssize_t size)
>         int i;
>         struct kasan_global *globals =3D ptr;
>
> +       if (!kasan_enabled())
> +               return;
> +
>         for (i =3D 0; i < size; i++)
>                 register_global(&globals[i]);
>  }
> @@ -369,6 +373,9 @@ void kasan_cache_create(struct kmem_cache *cache, uns=
igned int *size,
>         unsigned int rem_free_meta_size;
>         unsigned int orig_alloc_meta_offset;
>
> +       if (!kasan_enabled())
> +               return;
> +
>         if (!kasan_requires_meta())
>                 return;
>
> @@ -518,6 +525,9 @@ size_t kasan_metadata_size(struct kmem_cache *cache, =
bool in_object)
>  {
>         struct kasan_cache *info =3D &cache->kasan_info;
>
> +       if (!kasan_enabled())
> +               return 0;
> +
>         if (!kasan_requires_meta())
>                 return 0;
>
> @@ -543,6 +553,9 @@ void kasan_record_aux_stack(void *addr)
>         struct kasan_alloc_meta *alloc_meta;
>         void *object;
>
> +       if (!kasan_enabled())
> +               return;
> +
>         if (is_kfence_address(addr) || !slab)
>                 return;
>
> diff --git a/mm/kasan/init.c b/mm/kasan/init.c
> index f084e7a5df1e..c78d77ed47bc 100644
> --- a/mm/kasan/init.c
> +++ b/mm/kasan/init.c
> @@ -447,6 +447,9 @@ void kasan_remove_zero_shadow(void *start, unsigned l=
ong size)
>         unsigned long addr, end, next;
>         pgd_t *pgd;
>
> +       if (!kasan_enabled())
> +               return;
> +
>         addr =3D (unsigned long)kasan_mem_to_shadow(start);
>         end =3D addr + (size >> KASAN_SHADOW_SCALE_SHIFT);
>
> @@ -482,6 +485,9 @@ int kasan_add_zero_shadow(void *start, unsigned long =
size)
>         int ret;
>         void *shadow_start, *shadow_end;
>
> +       if (!kasan_enabled())
> +               return 0;
> +
>         shadow_start =3D kasan_mem_to_shadow(start);
>         shadow_end =3D shadow_start + (size >> KASAN_SHADOW_SCALE_SHIFT);
>
> diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
> index 6958aa713c67..a6dc2c3d8a15 100644
> --- a/mm/kasan/quarantine.c
> +++ b/mm/kasan/quarantine.c
> @@ -405,6 +405,9 @@ static int __init kasan_cpu_quarantine_init(void)
>  {
>         int ret =3D 0;
>
> +       if (!kasan_enabled())
> +               return 0;
> +
>         ret =3D cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "mm/kasan:online",
>                                 kasan_cpu_online, kasan_cpu_offline);
>         if (ret < 0)
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index 62c01b4527eb..884357fa74ed 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -576,7 +576,9 @@ bool kasan_report(const void *addr, size_t size, bool=
 is_write,
>         unsigned long irq_flags;
>         struct kasan_report_info info;
>
> -       if (unlikely(report_suppressed_sw()) || unlikely(!report_enabled(=
))) {
> +       if (unlikely(report_suppressed_sw()) ||
> +           unlikely(!report_enabled()) ||
> +           !kasan_enabled()) {
>                 ret =3D false;
>                 goto out;
>         }
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 29a751a8a08d..f73a691421de 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -164,6 +164,8 @@ void kasan_unpoison(const void *addr, size_t size, bo=
ol init)
>  {
>         u8 tag =3D get_tag(addr);
>
> +       if (!kasan_enabled())
> +               return;
>         /*
>          * Perform shadow offset calculation based on untagged address, a=
s
>          * some of the callers (e.g. kasan_unpoison_new_object) pass tagg=
ed
> @@ -277,7 +279,8 @@ static int __meminit kasan_mem_notifier(struct notifi=
er_block *nb,
>
>  static int __init kasan_memhotplug_init(void)
>  {
> -       hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI)=
;
> +       if (kasan_enabled())
> +               hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLB=
ACK_PRI);
>
>         return 0;
>  }
> @@ -658,6 +661,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size=
, gfp_t gfp_mask)
>         size_t shadow_size;
>         unsigned long shadow_start;
>
> +       if (!kasan_enabled())
> +               return 0;
> +
>         shadow_start =3D (unsigned long)kasan_mem_to_shadow(addr);
>         scaled_size =3D (size + KASAN_GRANULE_SIZE - 1) >>
>                                 KASAN_SHADOW_SCALE_SHIFT;
> @@ -694,6 +700,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size=
, gfp_t gfp_mask)
>
>  void kasan_free_module_shadow(const struct vm_struct *vm)
>  {
> +       if (!kasan_enabled())
> +               return;
> +
>         if (IS_ENABLED(CONFIG_UML))
>                 return;
>
> diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
> index c75741a74602..6c1caec4261a 100644
> --- a/mm/kasan/sw_tags.c
> +++ b/mm/kasan/sw_tags.c
> @@ -79,6 +79,9 @@ bool kasan_check_range(const void *addr, size_t size, b=
ool write,
>         u8 *shadow_first, *shadow_last, *shadow;
>         void *untagged_addr;
>
> +       if (!kasan_enabled())
> +               return true;
> +
>         if (unlikely(size =3D=3D 0))
>                 return true;
>
> --
> 2.41.0
>

