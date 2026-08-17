Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE933C5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B7A6B0117; Mon, 17 Aug 2026 18:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4046B0118; Mon, 17 Aug 2026 18:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09516B0119; Mon, 17 Aug 2026 18:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37D0E6B0117
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:11:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA1641C1D22
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:11:50 +0000 (UTC)
X-FDA: 85112159580.30.D1042F8
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id B89FBC000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:11:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FNTTvHtD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787004708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuUlcuNt+uC+rzkXIVye+jGcsTwTkO/x89Y77r9f6y4=;
	b=LMSFG2J9u8thlw8Sw+CoxcV2jHXQXrnY5ZCGt1JhxdbTIfs2bbbTiVX2RDM9fmUVq/5w7k
	KPzVhNYRZ056bdx4gMfIbUbaX0zCgrWnEAfLkGnngw4Lj/8VxjoFB4Pl29JKBD9nJpYFbQ
	+nVYNFAqIHaRUXsxoTNsNKPlJ21etkw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FNTTvHtD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787004708;
	b=vRseYEvauozeV331mvSrDQpdQX2XupKdlC9Fx/uE4psCQ0De+qcdZkmA5Ef8qGFdbmKjRd
	ntj3cmt9UqExMnESpsKADg2/5tZ7fsYXjSMKelyjU1dB1VuAO250kExElAm6ot8mzlwazZ
	N3rnQfS9SPuiGBN1hdcYN7fAN3XkBzQ=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-476a130c138so4056864f8f.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:11:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787004707; cv=none;
        d=google.com; s=arc-20260327;
        b=bW7ioyz4yDZicXLGKb2vErfxeV5bs16Dq/XPdfdkNPEl3XpLeGWeMkrPHUB9PpOZdE
         M/m26n1YlLEuRqmL9ufCiLaaIPDz+9zk0qnOg8Ow5+CnW03YomFKqJFq5Gre6ZFnhuNq
         dCJJK7+Cxuzk9Ip5KudmVSNvwuv3lX7yj1SI7W6t9kcntev2KC3pohcj/ustI4T0XOom
         FLihcs0mmm6xNnKHjZy2aqup1rwSzIAr6O2K3qx56AdbuhXx2UTxI4mB6iCDFDnG/Pid
         wsN4u5ohLIJxL6CNloVQaGwRwB0l/wANn7GhyGMkvRJBl9eFPaoF5gCVjYMgphozcz7k
         p0TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MuUlcuNt+uC+rzkXIVye+jGcsTwTkO/x89Y77r9f6y4=;
        fh=2m0pbscsq2dw6CnP3N9EjLID+UEczLFGyvfrlGVBAZ0=;
        b=NqogzQ5TeP4rmpzjFdF2E4+T1wd0TYsVSGo9Vn1CT6/qpfsG426NzIOzNw4X6zCV9B
         06BfpAVvJXEZWH/z4W5ICRMQsxZWUUtWNjsg/sDahTTwTrSAEBCy+9YJZCD0icCY1w/I
         nEjNG/Bk5YobWINoIMJfm+pUGwMBXdJf3DdwKRtu4+Pmu9x5bEooIjzaZl3FhxNO8i00
         gt7ZTUXn7zd/UXp9smhZlSeraUmGwrUodPdpy26hFZfyeH8xQJa5IVzCvi/X8+Ett9TO
         h92LR/w7fSBm1tX83jc0XudqA6QszJtBi1YxjZUNaKbE01aTWh9TQy+GjioUYFMvhl2/
         h5+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787004707; x=1787609507; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MuUlcuNt+uC+rzkXIVye+jGcsTwTkO/x89Y77r9f6y4=;
        b=FNTTvHtDLZJLYuI8A4aIjlWAS8MDVwbUU7WBtBtoq4yzhyFDXpOX/OY/ce+8Vc5YKK
         8V0ID6MMKGaBVWU5Irh2KiY5nzYwuhTc0dc4dBYkn/99urAEqOySKJUWxyK5L+ynzqPM
         cCaPkAyK1ZEan4K+IXDGj2VsPIjMNTvO/iQaenEdxOAD1R73Ahv47QxFZLy1TQSMaWGr
         rQN72vF/rTbb+UwWIKoWpulADy5gvSQN+p2g/danXGhsn+6tpEDEpBWjEuwjHUKs5meZ
         5RlFdQNHawoc8eyUY1BaaqiNYXPTaJxy+48BIEbweg7IAR/+f0M8eRj6IQrPWq75EPIG
         dx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787004707; x=1787609507;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MuUlcuNt+uC+rzkXIVye+jGcsTwTkO/x89Y77r9f6y4=;
        b=qwj0Qtk7801M1KTQhKUWhqhWP7cVc3w1fBUxNibWcvZiwDoGfbZtVhDOs02MKeaelO
         1OpEucKKRJBpVUnBa6HJK/bmO/ehbX/COTYXjxoINg23R/9t4nXuuyvKCnXjGfYgV0B3
         ZXadInLqiAjlGrAmaM7Ddfz9LPT/BYTvENxAKNVuxmNUHTl2BhbHYjNIDoLmsiAeSnHj
         xDaXhxwVnTGSWpEwFAr9l5HSkXG79yA2cZ59wBDiYkQePx02kd+V6hdaUAVHlU3mSY0b
         FVa8oj8Oyz+lMIl3GJgqp7EmVWwSWEis2SeBsNQ9VRuc/+KkcvsGfMi27X1Bvbr4qf2s
         5whw==
X-Forwarded-Encrypted: i=1; AHgh+RovpTVuvNnKc88Uo/9tBZjRAlNSAaRkdjX//OFWROP2whXKDM+5lh3annQsmXyxDXLyx+I+d3pJug==@kvack.org
X-Gm-Message-State: AOJu0YxhogcIn2WDBZb7ElNmQK0SHhpUSoyN/tXjGEUKTfm/QzeTEJGE
	HC832D2bvHTGeHpGCpexJN1Fl+s0Y6YXJBIVmczOGJB4IoPBIytaEY/1wNPC//el8kRmeYAc9os
	yGMWtm7eIleIkhhq2ZWfYgRAhMJJ2JeE=
X-Gm-Gg: AR+sD116cEvFjlx26ALFOjyvT5QfAMJdtmT1BAtJLHNR4XwzAOy3r+wsUaAUj2qFn5m
	1ffIJtzCHT3ucwG5+FVOUVvzLCkmpiZaImmpUp0lWdCM0vauSQbMNHv+5MMd6K0i1BCKCi7o5j8
	UmwL+ulwVTOLtk53rnbg1kzEkU+AtUvnlQ6ASUME7LqYsOrZxfOOXFmXDJDFqMtliLV3upfTyoE
	2FA+E9UFcpgMB+DIjaCJJaGltlyKlviihnFCDf9NRtFv6nGm6grb37BELtQV6xUaWXqH9NnqstV
	6lFwBb6lSCla5cEBv9ZjLutP+iWaU2t7v9soR1iBQUNtOZZnJEd1aFATn3nORseGwi2WnFFZHwP
	Q+XU=
X-Received: by 2002:a05:6000:230f:b0:47f:f1ab:9075 with SMTP id
 ffacd0b85a97d-4816074ccd8mr39569778f8f.20.1787004706313; Mon, 17 Aug 2026
 15:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1786956464.git.agordeev@linux.ibm.com> <52c9be0cf71a8896a5d76c148c38fb24a2005dd9.1786956464.git.agordeev@linux.ibm.com>
In-Reply-To: <52c9be0cf71a8896a5d76c148c38fb24a2005dd9.1786956464.git.agordeev@linux.ibm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 18 Aug 2026 00:11:34 +0200
X-Gm-Features: AcwNN1UPAiqWXSnHKbEWgYvXv-PgfhXyzAJo9d_a04N2AaWGsS3uQiqqfo9-6Eo
Message-ID: <CA+fCnZfMkPDVyy0t9W-3d55M2ba9wXoRyzj2EWWYLEW=QO3zWg@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] mm/kasan: Introduce helpers for lazy MMU mode sanitizer
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B89FBC000C
X-Stat-Signature: o3ypyn4npuw6pajamhm9to1i4kytuytm
X-Rspam-User: 
X-HE-Tag: 1787004708-744727
X-HE-Meta: U2FsdGVkX1+idCv55v2ZTinG35lSAcx7ft3wJGrzd+DFUtKJUsMzoboCue3LC4eNrrdJpeD/XkbIcypgKkmhVm0YVr6NEkrTqDfMgp/gJla0dOqWaKi6rR/T7zI8HrFJj/bVkXAfJylfM8BTkFKOk43pNeWL/Rqo0ZRInS8AkPPVvldyH5my+Vyq/Wb7i4bDsU5H144Jly1plywDdvJ0w33rynFgN2l7ArajZUnBERm/wwzIxfS1yVvAUtYKtIyWcPTtczdXbOxvFnfKBpbPhN9GNBHxDgF9vRZ28qb9tZ/l/PUbDFkV7VkBBVjVdKib5JxNVBGlF93jHjOS6iiTzUUbwvkYjEFz0UUP5UmhRYHKPv752N310n50B6FMWo1GBJsfwdNIfN5KQUHtIaAyZXsPIko34s3ooK97U8ljMcGORqKHB5wiWO3t8C553Q9zBaYK8OE4yIlryXM2aj0bzPNNqOr/SsZGtHKvsBoczmUBK2IynbUE9HACt18vznunjdjer5as3SFHGYco/GjECw017HZeG5gsCeCmKmYWJZUed/mTsgL0eRK/izYKMbMqDLkui8TeaiBJzBG9XUT7tBYDjKFVfB77f5HbKRc14GCDMqoWkcY6iLgrleQSwtQlRAUDAdo9smAYJkQpaTFbw4X/Elib4PLs2u/BtWz1Q6LHb31JsvT+g0mFJSW8ugi+giJkay8GQriZHHBWb3kONLQUCi3L+6o/Y78+q/D+6hlVj4p6HT1leBd3Pufqsrmwq/oiciLBk/z0paGe6P9nVFD2w8TfByP4mRY+4A3HMBGIBjNRLc5aEdSN/54eOppR4wWmLbGbZDIJP4FrmK2lbKJN5lbVLQePEI5B4n3SuQGBuG6rSwYHNy/KrXOG1CZCTBZmnmNQTbP/6AuVXifejw7wA7rHLRhEfYnVMxMBRB4GPOywAWcMyyvJkn8ZG3+PpRLsAlzryym7lYsfUj9
 5nSMroj6
 0kP9QjclTcalAHzFjV/EsOlY2RwSupho9aGsVcCMkQdfaukGPW5ZNMXUz7GORTwsAvqDjiO8OXgZaC5AD4h3KrZyoJ90Cz71KY3/R/+kCH+IPGObMQjjCf2zl52YxyLJY5RrWqFHBYEBrs/eMbT2iEuA7SJtEXHN1+TwRdV24+gtw1wivaGtRTaMcSCy/IW8VWjrIoVKLosRISS9Ne3jo5Uq4XDlqaSITiaLIZA/GH9d6QslSmurT/xZI5LkRio/Zx1qkWArN8JXI565DkpvjN9q5N+WQ35j3J4R7/ZiW6IXkjr95VaUU/mRn8xGrzK8SrjrtR913dODomojem6ZrXE2ikTi7AJ2k9vLi6/OOfGIFnoLfoc/KQ/ikIrpNhvliGygYqJivUC/bRarHVZlkSigrltfAARWgkd0MDRWEJJw3t7Hy7Y02rsSZWGko9puTDKz3UX7y6F/swmcIjL6oK9gjFTKQTYvbcGP2KJ6NUbCJZxekqoXe/HdRr0zw8yzkJ3a+qluX9RTWpH6iRqs6QEYzzUD7uqoZSf0TB4CXtcNxiLU0V97ghyxkCKBoQ3w7iFKIM6Xcn30R76U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 1:33=E2=80=AFPM Alexander Gordeev
<agordeev@linux.ibm.com> wrote:
>
> Provide helpers that allow architectures implement
> illegitimate PTE direct accesses while the lazy MMU
> mode is enabled, such as:
>
>         pte_t pte =3D *ptep;
>         *ptep =3D pte;
>
> By contrast, these would have to be:
>
>         pte_t pte =3D ptep_get(ptep);
>         set_pte(ptep, pte);
>
> The direct PTE accesses pose a real issue on s390.
>
> Suggested-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  include/linux/kasan.h     | 19 +++++++++++++++++--
>  mm/kasan/common.c         | 14 ++++++++++++++
>  mm/kasan/kasan.h          |  2 ++
>  mm/kasan/report_generic.c |  3 +++
>  4 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index bf233bde68c7..1aa4d9dd2485 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -6,6 +6,7 @@
>  #include <linux/kasan-enabled.h>
>  #include <linux/kasan-tags.h>
>  #include <linux/kernel.h>
> +#include <linux/pgtable.h>
>  #include <linux/static_key.h>
>  #include <linux/types.h>
>
> @@ -35,8 +36,6 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
>
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>
> -#include <linux/pgtable.h>
> -
>  /* Software KASAN implementations use shadow memory. */
>
>  #ifdef CONFIG_KASAN_SW_TAGS
> @@ -134,6 +133,20 @@ static __always_inline void kasan_poison_slab(struct=
 slab *slab)
>                 __kasan_poison_slab(slab);
>  }
>
> +void __kasan_poison_pte(pte_t *pte, int nr);
> +static __always_inline void kasan_poison_pte(pte_t *pte, int nr)
> +{
> +       if (kasan_enabled())
> +               __kasan_poison_pte(pte, nr);
> +}
> +
> +void __kasan_unpoison_pte(pte_t *pte, int nr);
> +static __always_inline void kasan_unpoison_pte(pte_t *pte, int nr)
> +{
> +       if (kasan_enabled())
> +               __kasan_unpoison_pte(pte, nr);
> +}
> +
>  void __kasan_unpoison_new_object(struct kmem_cache *cache, void *object)=
;
>  /**
>   * kasan_unpoison_new_object - Temporarily unpoison a new slab object.
> @@ -414,6 +427,8 @@ static inline bool kasan_unpoison_pages(struct page *=
page, unsigned int order,
>         return false;
>  }
>  static inline void kasan_poison_slab(struct slab *slab) {}
> +static inline void kasan_poison_pte(pte_t *pte, int nr) {}
> +static inline void kasan_unpoison_pte(pte_t *pte, int nr) {}
>  static inline void kasan_unpoison_new_object(struct kmem_cache *cache,
>                                         void *object) {}
>  static inline void kasan_poison_new_object(struct kmem_cache *cache,
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index b7d05c2a6d93..94d106094989 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -163,6 +163,20 @@ void __kasan_poison_slab(struct slab *slab)
>                      KASAN_SLAB_REDZONE, false);
>  }
>
> +void __kasan_poison_pte(pte_t *pte, int nr)
> +{
> +       if (IS_ALIGNED(sizeof(*pte), KASAN_GRANULE_SIZE))
> +               kasan_poison(pte, sizeof(*pte) * nr, KASAN_LAZY_MMU_PTE, =
false);
> +}
> +EXPORT_SYMBOL_GPL(__kasan_poison_pte);
> +
> +void __kasan_unpoison_pte(pte_t *pte, int nr)
> +{
> +       if (IS_ALIGNED(sizeof(*pte), KASAN_GRANULE_SIZE))
> +               kasan_unpoison(pte, sizeof(*pte) * nr, false);
> +}
> +EXPORT_SYMBOL_GPL(__kasan_unpoison_pte);
> +
>  void __kasan_unpoison_new_object(struct kmem_cache *cache, void *object)
>  {
>         kasan_unpoison(object, cache->object_size, false);
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index fc9169a54766..1a2d18cdb21d 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -144,12 +144,14 @@ static inline bool kasan_requires_meta(void)
>  #define KASAN_PAGE_REDZONE     0xFE  /* redzone for kmalloc_large alloca=
tion */
>  #define KASAN_SLAB_REDZONE     0xFC  /* redzone for slab object */
>  #define KASAN_SLAB_FREE                0xFB  /* freed slab object */
> +#define KASAN_LAZY_MMU_PTE     0xFD  /* direct pte access in lazy mmu mo=
de */
>  #define KASAN_VMALLOC_INVALID  0xF8  /* inaccessible space in vmap area =
*/
>  #else
>  #define KASAN_PAGE_FREE                KASAN_TAG_INVALID
>  #define KASAN_PAGE_REDZONE     KASAN_TAG_INVALID
>  #define KASAN_SLAB_REDZONE     KASAN_TAG_INVALID
>  #define KASAN_SLAB_FREE                KASAN_TAG_INVALID
> +#define KASAN_LAZY_MMU_PTE     KASAN_TAG_INVALID
>  #define KASAN_VMALLOC_INVALID  KASAN_TAG_INVALID /* only used for SW_TAG=
S */
>  #endif
>
> diff --git a/mm/kasan/report_generic.c b/mm/kasan/report_generic.c
> index f5b8e37b3805..489d4a8d6902 100644
> --- a/mm/kasan/report_generic.c
> +++ b/mm/kasan/report_generic.c
> @@ -113,6 +113,9 @@ static const char *get_shadow_bug_type(struct kasan_r=
eport_info *info)
>         case KASAN_SLAB_FREE_META:
>                 bug_type =3D "slab-use-after-free";
>                 break;
> +       case KASAN_LAZY_MMU_PTE:
> +               bug_type =3D "lazy-mmu-pte-access";
> +               break;
>         case KASAN_ALLOCA_LEFT:
>         case KASAN_ALLOCA_RIGHT:
>                 bug_type =3D "alloca-out-of-bounds";
> --
> 2.53.0
>
> --
> You received this message because you are subscribed to the Google Groups=
 "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev=
/52c9be0cf71a8896a5d76c148c38fb24a2005dd9.1786956464.git.agordeev%40linux.i=
bm.com.

Hi Alexander,

Should all this be limited to only s390?

Thanks!

