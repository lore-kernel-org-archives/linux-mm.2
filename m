Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989FDCA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 05:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EE7900032; Wed, 13 Aug 2025 01:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF018E01BA; Wed, 13 Aug 2025 01:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32108E01B9; Wed, 13 Aug 2025 01:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AFEA18E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:05:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 715521DB83A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:05:53 +0000 (UTC)
X-FDA: 83770546986.07.9C471B6
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6556EC0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:05:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OTqa5Sus;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755061551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87bLiKw1h579sXw+ErVi2X85NzXrARI80WO5rF5C6xU=;
	b=UoO+EsfkpynjxjinrCauDyePpwKZJSxSmgL1BxkVKHRTConsvuJV5Lu4vpsyioFM3Gwpfd
	I8PedhVMQygPTXblx/L09KP+OA+8vfsnSKJr2POsI9LigphQPfBIM+dWmcYWZB9EUWLW/3
	LD53RZVf7DeyE2LpiiYbhSXiYrq3Thg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OTqa5Sus;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755061551; a=rsa-sha256;
	cv=none;
	b=AOVw9bNcNG5UDQxzU3Q6kmRhU5mE+1MDlmwyVlhGJ2QSJumHQMhbVwOGByJY5rr5kl/rfW
	RsITR4t4PZMcSb9chEyitpIR76Wf+x62CqpkLptt1NcnXuiXGqPt1NEdlOJo7wP7LxBm7Q
	LeY5P8uR/kPwPmrHX4KCRmnGA27F81Y=
X-Forwarded-Encrypted: i=1; AJvYcCUtEqqadv9GJh30Lx1Lv1tcvsng/70Q93CyzI2RkJ61iVlAwW1XDxcpTry0BRu1109/ytXjeQpGWfo=@kvack.org, AJvYcCVDtCPYbb4FLDy2lBAexEJrXRbieoVWoosZvQsbJchIvTuU/vfvFK0OhHohphmCxDefVDtlxYvjOaKv@kvack.org, AJvYcCXU7Hsj1wsaH53LHtx4gE546FhBfZsD8p+ryocrgE0WvL5ey31MOnpBTzAQlyan8stHWldX@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755061539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=87bLiKw1h579sXw+ErVi2X85NzXrARI80WO5rF5C6xU=;
	b=OTqa5SusVm1D8RGOLUglr4tRkBjPnEZ+oXk8/JWIFizdKga9dSgnLmH/gVLM8CyQzwzH3V
	Mr0zDp4SE0h8OkqXEg7N1/tIp0Aqdmt9UKvBSpQy5JRSgDrMN56/5WNs3VIDHedILHTX6j
	ZsSZAZUsE3e6U+IO4LLQT13ac8oWIuI=
X-Gm-Message-State: AOJu0Yy/s1dj2b3Jug3/vJEXueL8LPFZFPI6hHU4aYCxVHuiciHJbS1m
	Emxhu9hSqJEvVnsBMfRRaAXZkC6k1jfwzdvJo1hIXRgE5jSkp52uYbaIsVZR3rLiKAAzPt4ZpX/
	OIfd7tmUltWJErugriD0JC4UhaNBP9Js=
X-Google-Smtp-Source: AGHT+IGZEPRXKg3wTS4iOnxLeW0VcVJpSHw/Siwyoa1WzS8WxyYOyRd8JzJTNVHXWXH3rQ3YpjAcT1JHiZ4LgeKLzSs=
X-Received: by 2002:a05:6214:246e:b0:709:31f8:fd96 with SMTP id
 6a1803df08f44-709e8865a26mr19274996d6.20.1755061536500; Tue, 12 Aug 2025
 22:05:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250811143949.1117439-1-david@redhat.com> <20250811143949.1117439-2-david@redhat.com>
In-Reply-To: <20250811143949.1117439-2-david@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Wed, 13 Aug 2025 13:05:22 +0800
X-Gmail-Original-Message-ID: <CABzRoyYU2yOuGQskCAG_gzKiQwR6uM9eAYqOOCoQj+Xv=r163A@mail.gmail.com>
X-Gm-Features: Ac12FXz5RRcASyIjWC2h4OdZEnpLc7e6olfF88c8Jo2nErMh7OQ3VSRS5jfjM-I
Message-ID: <CABzRoyYU2yOuGQskCAG_gzKiQwR6uM9eAYqOOCoQj+Xv=r163A@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] mm/migrate: remove MIGRATEPAGE_UNMAP
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, 
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Benjamin LaHaise <bcrl@kvack.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	David Sterba <dsterba@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Dave Kleikamp <shaggy@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6556EC0002
X-Stat-Signature: jrsnxe3rryrbrcpbnfged93w4wawbxmg
X-Rspam-User: 
X-HE-Tag: 1755061551-584028
X-HE-Meta: U2FsdGVkX18j6eYk9rSnzrx5HafeftNDTtkICh6urOB40DVOl2wkx0Ok6Z0lzs9dy3TsbuhCjUZnYhHXKdxC9/p6OqIEVdQsbNq8WJGPCDXyWQgQP3pDGgdSOkchvCg/VsD/AF6/XSG/DC+hO6U5VfviVttcFAM7SPl6O4/GASOZ0Rt/StNPvKSIjFiHt90BFvAWntCJ2jRqBpP6gyj3HOidou8ZqtMQHtXpx4OOuhAo4zNjjx1bB/uKkPsvc/068jIJttpLqd/XTXksemIUrez5YmZ+AcYxXcAjJR9HSdAVRfe4XOpWcFxArVhDxNeutHXYQl9xyNX1sCPI43C8dRu00rghTAKnDpYlKVMjSx01nPDrMnUe7gTmALKNYAIJ6W67eGX07ohpMsyeE0qDmjyeq/haiW1XJzhDtdVqqsakrB2eTIbsD0dmgWg7d222xnaKq32b1XwC72AMGAGgxuUJnK/yLO9Nn9h7lD7QddTS2PjMa/7N/RSGd5taDL2RKTAUiHgxO+b5OW7xW1z24T/DextUxrrGdsZYYNAVfBI4PUBLvohfwdvPl4Zb71CzFRcLGiETAwAJFI+EufLb83zIr8Zgtas9MrtRmyCXFHuA29XapLcxXSEISu1Jk+aEjKj08T6ctuwPZwsAyaatobwyfmhjdH0TjsjjthnTOfWwqz5aBzAzfmTQv8xIzwH4nBUCzjnIMarWNs0w1GWBuO6M6VH6VRMjB/mrDTAEiXGlSiH90OSiysB8lnt7L2CjZuiBruwPEmXPKvde5wbl4RYcbSX05T2M5tOwTwGV7WpymWOo1JTBKEjOomPJwRorOB3GCdg91QREf0v+jrFGaJXvQiUaELRDKk0/M5FVg3SbL3TvKDEO6LTdlk3HSnql2TjmcTSLz/mQHtliQKBnlAb/vJfGsolOWzzoLDYdcW+VIRZjhqwO+ir/Y0xf25axZaBb4Q8KFHHGWTU0jCS
 pVUbosLd
 WQWsDXcvbQDYhxzbgySbkk1A0UJr7QO2znEGdzGEHU7JtZPsX6Enux+KfPPlbyOf8usKKlVCu7jAI/MnlBU7qNobyVRPgE34/dv53yBHddYgx/Sj0+Wn0ZGiJ0W+QgHlbZ7dW+0cG98OdJo4x+8wyI4qUDSsoXSly//3VCtaicjO5yl1TJwwu0xVMH3QbkJsbbcPrhDSMWpAuwNy398E1SUiJdHYPOlosPfW6dJT+eR/Cax1ljZWIBRhHuVP+EdsajN3+lSIC0jWzErMT7geX8NlNeMwwnAIjSCaNJYZToJoefQAkRqQw69HZUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 10:47=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
>
[...]
> +++ b/mm/migrate.c
> @@ -1176,16 +1176,6 @@ static int migrate_folio_unmap(new_folio_t get_new=
_folio,
>         bool locked =3D false;
>         bool dst_locked =3D false;
>
> -       if (folio_ref_count(src) =3D=3D 1) {
> -               /* Folio was freed from under us. So we are done. */
> -               folio_clear_active(src);
> -               folio_clear_unevictable(src);
> -               /* free_pages_prepare() will clear PG_isolated. */
> -               list_del(&src->lru);
> -               migrate_folio_done(src, reason);
> -               return MIGRATEPAGE_SUCCESS;
> -       }
> -
>         dst =3D get_new_folio(src, private);
>         if (!dst)
>                 return -ENOMEM;
> @@ -1275,7 +1265,7 @@ static int migrate_folio_unmap(new_folio_t get_new_=
folio,
>
>         if (unlikely(page_has_movable_ops(&src->page))) {
>                 __migrate_folio_record(dst, old_page_state, anon_vma);
> -               return MIGRATEPAGE_UNMAP;
> +               return 0;
>         }
>
>         /*
> @@ -1305,7 +1295,7 @@ static int migrate_folio_unmap(new_folio_t get_new_=
folio,
>
>         if (!folio_mapped(src)) {
>                 __migrate_folio_record(dst, old_page_state, anon_vma);
> -               return MIGRATEPAGE_UNMAP;
> +               return 0;
>         }
>
>  out:
> @@ -1848,14 +1838,28 @@ static int migrate_pages_batch(struct list_head *=
from,
>                                 continue;
>                         }
>
> +                       /*
> +                        * If we are holding the last folio reference, th=
e folio
> +                        * was freed from under us, so just drop our refe=
rence.
> +                        */
> +                       if (likely(!page_has_movable_ops(&folio->page)) &=
&
> +                           folio_ref_count(folio) =3D=3D 1) {
> +                               folio_clear_active(folio);
> +                               folio_clear_unevictable(folio);
> +                               list_del(&folio->lru);
> +                               migrate_folio_done(folio, reason);
> +                               stats->nr_succeeded +=3D nr_pages;
> +                               stats->nr_thp_succeeded +=3D is_thp;
> +                               continue;
> +                       }
> +

It seems the reason parameter is no longer used within migrate_folio_unmap(=
)
after this patch.

Perhaps it could be removed from the function's signature ;)

>                         rc =3D migrate_folio_unmap(get_new_folio, put_new=
_folio,
>                                         private, folio, &dst, mode, reaso=
n,
>                                         ret_folios);

Anyway, just a small thought. Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks,
Lance

