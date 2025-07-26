Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A375C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 22:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092946B0088; Sat, 26 Jul 2025 18:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0434A6B0089; Sat, 26 Jul 2025 18:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75346B008A; Sat, 26 Jul 2025 18:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D44026B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 18:06:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FA9B59C87
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 22:06:10 +0000 (UTC)
X-FDA: 83707799700.08.A56D5CB
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 603831C0006
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 22:06:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="In/tb93Y";
	spf=pass (imf20.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753567568; a=rsa-sha256;
	cv=none;
	b=m0uPHWHWGeVc6AOKgV5aoovcUcMBA//KwxlxIpGza36isVxh7By6a/7uqvjBFOWjk9xRP6
	K0S96dFjjFCfZlYxRCQpChxosBoLkjBy0rW9V8Q3iiS16j9214k/HwvLNXRpF2Y5rDc1yD
	U+m4Jv7QqHMWz4pD8J0SB0YizLboXuk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="In/tb93Y";
	spf=pass (imf20.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753567568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJ0HbWh5wMU4zq+nDQgi0w5mYaeF8gFdCN3zESWgjG0=;
	b=zAIVd+6WRhkLt9s/oYEXO9c8kB13Xls7G/6pnv7zfZT38TLiu3ZPcQlJwVw8Jn8pQ3vz9Y
	w1U+edbDEQA7MW/ulvcxU7pp//xpa2F2Lpeo9x2QFVaRlUBdeO+Sg990D1NRrXTGFXOqLd
	JQCSIJIHUKVbOpO8sX9f90EFHE7WEsg=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-455fdfb5d04so17916565e9.2
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 15:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753567567; x=1754172367; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJ0HbWh5wMU4zq+nDQgi0w5mYaeF8gFdCN3zESWgjG0=;
        b=In/tb93YNeNO/6f6/8m4U2bika+klqY5oLZ4fbzSgZDRQExGtdR4SEX9stEaINUzP3
         R8t8u6cSmoA3+ayMgtBGUBeF3cgCylBLvA3aNIS39AnLp5BoIEIDJjEl+E7lItGhTOle
         TVjkCs0if5r3VWmQDIIYph72d9wCfdZcFVnp+JJcKFNHZ29G8yH4iWOSXP9bErUvAAjj
         wgQQfhwqDwTOIFjjT/O8mGdfz2y+iJcyU0YHrCgGDIoq1mz8m09/Jp9BbgRrS8L4k3HX
         MkwyH7u61xaj70vW5/cggAbzYvVSKEX+LfwEE2zHNIrFgg2w1yHo5ar/2eA0GmeiHcCw
         kzVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753567567; x=1754172367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJ0HbWh5wMU4zq+nDQgi0w5mYaeF8gFdCN3zESWgjG0=;
        b=IqlZrRNubBjYNuGSNDJnccKAo8agkxYUWf8BXqJ1NJxQPu9iINnIdfyuGeAjk5T09B
         qsjJINNTiHzEZWN1YicxS4J0zy1vch+7fYwjrK7jCmvKhanhl1WAHTmTN+62KeyZrWOd
         8aQdleLp14YyvsgWtymC5GbMeLcvrb9fyWHRGeN/jXVGc8+gdZYXIDZZQoGn8pXGnwzt
         dws/AHYio2VAiqrkS0sRG4NH4pUJrfNMOxRt9Y9/FCD+uXGzfLcwtXsAD9YcFdtx81xW
         wDAqe081qXUmRdZ616ME5hq/mOPyUl3k+2nhqHKPoMsqPYqJ0Fi/z+Yud8PXTjKMjbcH
         miHA==
X-Forwarded-Encrypted: i=1; AJvYcCVanm5igMGx/D0PgOGxKqkPw6ZJXnmiARbPQary++3KI1UsqQ5cvnvRMHNnI8+xobKrTGC/892xFA==@kvack.org
X-Gm-Message-State: AOJu0Yx+RzmqcWvEZExJfvoDDkGqEqzie10v+e9HUWnD08AX+FRrwwMV
	hXv67de3YVg0kc2y27HuCLEGfWJhr0sicp3myJxuMt+QIT4BQ+LKyIu3gup7EtsdMSeV1Q/xc36
	3IWsLy2hmB9pRdtsCwhtthyGv0YaRoTI=
X-Gm-Gg: ASbGnctfhC80JgSGyJIpl8vd0iWkfR37En/S1PE/XOLEw1dINiBW8896kFayHXv20Pb
	8r3EbkbQ762W7DG/JnLLIECc6RfUX2MR6IVj8yE4DzkcxL7+61BCtu1RYWHk2RDdnr09B+6wSD9
	qWZAFiuaEFOqOo6MWI/fDY+LMrGwgzNJTZZUn58OZm8nGAH4GrQoMpdniEpAUHKQYLUdc2/mSWk
	Q93oA57
X-Google-Smtp-Source: AGHT+IERMWRconwwlICLYKuwfsAec6Ra2IUKJw6WcwmH1A2Pr9eQONsCFb0r5f8/2r7DCKhOVYQUXrXNn0q12SWzoEs=
X-Received: by 2002:a5d:5886:0:b0:3b6:18be:3fbc with SMTP id
 ffacd0b85a97d-3b77671d232mr4837781f8f.2.1753567566495; Sat, 26 Jul 2025
 15:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com>
In-Reply-To: <20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sun, 27 Jul 2025 00:05:55 +0200
X-Gm-Features: Ac12FXxVMLsmLFrJvmkI7l9TDJQ09BGxwghdFh3bJQfvTulVExlWwMj6B4rNIpk
Message-ID: <CA+fCnZcyh52CqY+XDMMjc6f5KQoaji=7KiFM-6+2NidjfyNVGQ@mail.gmail.com>
Subject: Re: [PATCH] kasan: skip quarantine if object is still accessible
 under RCU
To: Jann Horn <jannh@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 603831C0006
X-Stat-Signature: ubmtx8oty3kzqiu84t13qd17w55fzqw5
X-HE-Tag: 1753567568-878976
X-HE-Meta: U2FsdGVkX1/yw6vdi3A4iT9JsLEhdWdK1WQ6Y0/KYnNC1TtgkUNf+ESH9Pj3zRRphMIGLQXrMeezVyLvVCoiYyVnJ/J8KOrd7X1GHyOuI09RnCj4m3PskTUO8qoXBzg9LCKZBwcs34ZqPMyDIRlgXGDjtBaF4CbudhIJkALLlw6oR/HUh2OHAH9bZ2fL6DfZCymfMk+AUlD6h7dreqDyU61z5zwHKhXPyCJ8781cIcZfdpC6dzdB+Uo15CeWmfOIeBDh2Dm08B0ZWGf9HIK3Q3+cJ2lTHiYDpqy5u4B3JBQQV5dEs5bCrzLUJsd5VvyJ9/6s3f4myuLhylSyfkQF+nWdG6mrlqrRjAYQD/ALo9GBYIb61QMg8tHrd9bx9OUSeuour2VMrePs0j5WP5fStqrO7Vr0akjIUsMuk+/SkK6Q6ZLhG1QrpxZU4ctH9a0Y/ZS+tMvysai+Ju6QJSb70NgD7XPg06LajpwQK3kJvJavSE5lc/fJicm6/44pqqTUF/qR/Y/uyESK18RbII9RyTqvcyOFiPqnZQC26wq+M4H1UmbubM2S7iTDwHLAbP/OTcYGOvyRYq4bpyYy/03s/eBgTEyOgDVLyrdIbAkmKTtqW9t6fJVVIA/4iRmbYjFiQu8Om5D0esy/J1z9lveYQisO4dsglDf8bUISnJQhG5dhxgMhOUS5BNxdNBfgukvGNjdlfB1bKUJFoehSq8wCYKUQRaB8eZz11dUMIydfyczX48cvb/4vvlGKr1knvzWabTsmaFeP9knm/U/3+bb75jv/rZPLNCtlWLQqMrBs0/NIqFKnUvDR6xkQkGCZeyTEWm0hGiyHnJxQTvBW0DZi5o9weSOZdQKkbDQmgJzvl7YO5gptxY+s/SGqGwcct4fkvIzp9aW3HRb3JeAkqZYSlsZME01hgdTLHQJDZJc1A4ktrpw62PoZt5dqvTQzOrEjR9/FQDuNvib5/YoJUox
 pD9LSBhc
 HMjVsaEBC+fGvElRx1Hq1CimozqLJeTfllPCe6/mMnkTwmTccImtmMlraWH9G1hxVEGWTNUyiCIEOKpF5oUCIzsVlLmRCWU1vL23efNf7z5l4h+S6WXv2kqlHv9PbVETWZn3/2/B2eOa7oJYgQ189aGkj9HprEn/bB/TfF2FZWc7hYPEBoEZC3RZRY3MkN9yPxXFcUREOhUdwvmU9TS0LbHbUfzg3fiNim2vh4tH+W+CagHA3rFrxglvV33QLL6Jf5iEsexkYmsSFqZj+fVqElov+a2gSa+LwdK/Yc4PsP5LzP4wL/clnwYA8kcn7YEO15K9oiRfGbrQxtKv5cjHxQ8qxVmyCxiFxuV5zITp8SjpL4r9bigadDvY4OTe0RNrLT3+edw8tRfk+2Ay8fcimIPtXFgQwFCSdUlYcSHJxkfdQeEltAu6e+oO05F4EGYR4Xw3hyQ515vNZ+wD1E2HUYwIs7cS2mJ750byu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 4:59=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> Currently, enabling KASAN masks bugs where a lockless lookup path gets a
> pointer to a SLAB_TYPESAFE_BY_RCU object that might concurrently be
> recycled and is insufficiently careful about handling recycled objects:
> KASAN puts freed objects in SLAB_TYPESAFE_BY_RCU slabs onto its quarantin=
e
> queues, even when it can't actually detect UAF in these objects, and the
> quarantine prevents fast recycling.
>
> When I introduced CONFIG_SLUB_RCU_DEBUG, my intention was that enabling
> CONFIG_SLUB_RCU_DEBUG should cause KASAN to mark such objects as freed
> after an RCU grace period and put them on the quarantine, while disabling
> CONFIG_SLUB_RCU_DEBUG should allow such objects to be reused immediately;
> but that hasn't actually been working.
>
> I discovered such a UAF bug involving SLAB_TYPESAFE_BY_RCU yesterday; I
> could only trigger this bug in a KASAN build by disabling
> CONFIG_SLUB_RCU_DEBUG and applying this patch.
>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  mm/kasan/common.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index ed4873e18c75..9142964ab9c9 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -230,16 +230,12 @@ static bool check_slab_allocation(struct kmem_cache=
 *cache, void *object,
>  }
>
>  static inline void poison_slab_object(struct kmem_cache *cache, void *ob=
ject,
> -                                     bool init, bool still_accessible)
> +                                     bool init)
>  {
>         void *tagged_object =3D object;
>
>         object =3D kasan_reset_tag(object);
>
> -       /* RCU slabs could be legally used after free within the RCU peri=
od. */
> -       if (unlikely(still_accessible))
> -               return;
> -
>         kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_S=
IZE),
>                         KASAN_SLAB_FREE, init);
>
> @@ -261,7 +257,22 @@ bool __kasan_slab_free(struct kmem_cache *cache, voi=
d *object, bool init,
>         if (!kasan_arch_is_ready() || is_kfence_address(object))
>                 return false;
>
> -       poison_slab_object(cache, object, init, still_accessible);
> +       /*
> +        * If this point is reached with an object that must still be
> +        * accessible under RCU, we can't poison it; in that case, also s=
kip the
> +        * quarantine. This should mostly only happen when CONFIG_SLUB_RC=
U_DEBUG
> +        * has been disabled manually.
> +        *
> +        * Putting the object on the quarantine wouldn't help catch UAFs =
(since
> +        * we can't poison it here), and it would mask bugs caused by
> +        * SLAB_TYPESAFE_BY_RCU users not being careful enough about obje=
ct
> +        * reuse; so overall, putting the object into the quarantine here=
 would
> +        * be counterproductive.
> +        */
> +       if (still_accessible)
> +               return false;
> +
> +       poison_slab_object(cache, object, init);
>
>         /*
>          * If the object is put into quarantine, do not let slab put the =
object
> @@ -519,7 +530,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigne=
d long ip)
>         if (check_slab_allocation(slab->slab_cache, ptr, ip))
>                 return false;
>
> -       poison_slab_object(slab->slab_cache, ptr, false, false);
> +       poison_slab_object(slab->slab_cache, ptr, false);
>         return true;
>  }
>
>
> ---
> base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
> change-id: 20250723-kasan-tsbrcu-noquarantine-e207bb990e24
>
> --
> Jann Horn <jannh@google.com>
>

Acked-by: Andrey Konovalov <andreyknvl@gmail.com>

Would it be hard to add KUnit test to check that KASAN detects such issues?

