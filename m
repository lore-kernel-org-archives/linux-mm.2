Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B258D606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eN3o3Y2m
Received: by kanga.kvack.org (Postfix)
	id 754146B05B0; Thu, 26 Nov 2026 13:27:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704956B05B1; Thu, 26 Nov 2026 13:27:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619DD6B05B2; Thu, 26 Nov 2026 13:27:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30A8E6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6BC6A050F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:27:53 +0000 (UTC)
X-FDA: 85478104026.11.8476CCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D93771C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:27:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eN3o3Y2m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795717672;
	b=kUMjzzihC8xWqKsYwrMtNwxlBwssdF24FtSgQ9I4dvqmKaJtPVC/2WUpZc2REHKOOjW/s1
	9O0VgCah5/AHjRmSHdmJV60GyuRPQGF4qitFOBeutrm6oKMPWor0Y77rf2wsZcKH/k4ERE
	uEt2gibJbqmXQbNDsY25ZAK6N5W5yTo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795717672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K4oceCXr/VXDTO4Y4qBl2iEPAqAOK0JNPL5oIiLS6M=;
	b=gQtSr9ZDfBPVnbg9gxy/jWZsMwidqAnYE3xasrCPziinlSTbpj1OM7WvBOvuZcYDAH4C97
	I4HrXJcKrOpynV39rs9S5UplIa7/XLhkx7rvUqEjbTJWwr9gS1/JSFPr8beEW3JmNk6iO0
	SD2nHjOJ2blX38lWR3nbiBn063qWtek=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eN3o3Y2m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11CBE41AE2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87441F000C0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795717670;
	bh=5K4oceCXr/VXDTO4Y4qBl2iEPAqAOK0JNPL5oIiLS6M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eN3o3Y2mfyoWLSyghzZRa5IgHCKFv8IRVBkCwkPQfvHhz6IGCV9NojqJGVkY2mh1b
	 DFJk65ejExEwno8gOFfewZuYzlHQTdFOBzVaAAMkDCKp25Z6Ho8Nqh0rmQXp+AKRAT
	 AYbV/cc/rf1fOfryiBI1XModUJ12W5MtcFwZ504kIsO3v6tBA+dxzDas39Xd4kvOeH
	 srnI/Sj3DL1EOpl++6hmpIaAyXStOuDZqjipkOS3ylYPZq2kMqHEipEudi97s6l6Il
	 S1NUWsTio67kzpjWaXdEmU693mP/91yy6MFmO0zu8DdsKQmlnFGrLUkUiqmDW/XYlu
	 643N1p+zIlUkw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so1322360266b.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:27:50 -0800 (PST)
X-Gm-Message-State: APuU4Z8/M7iJY5U5sFzcAKQZcVoTeftVpfegXgFQOLfXDjhNojHb+AYV
	t/y7zZ4e/dQfqNiLEbzI71KQHXRk7EI+Gp55jE3PZkmq0mj9GLFUnlTS8VRRu/VTsExyD96CNYK
	thW9YvyrwWDTMedhc57uZxrTIz78J6XOvGOKyMgshfw==
X-Received: by 2002:a17:907:940a:b0:c29:5d41:dfe8 with SMTP id
 a640c23a62f3a-c513acbb4a8mr1802032666b.43.1795717669825; Thu, 26 Nov 2026
 10:27:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <21e7cb1a16aed56568fa400f5385acd36513aa46.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <21e7cb1a16aed56568fa400f5385acd36513aa46.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Nov 2026 10:27:38 -0800
X-Gmail-Original-Message-ID: <CACePvbXsmTWf6GNXi6W7HabdskuGRO8gfUtVgzmr03+oi20itQ@mail.gmail.com>
X-Gm-Features: Aa3M54rUfkNKGj0MHFID9_rOhmYrB4UNx4i-cNC5HQDaUNLT2BJCrclHNYAVT2w
Message-ID: <CACePvbXsmTWf6GNXi6W7HabdskuGRO8gfUtVgzmr03+oi20itQ@mail.gmail.com>
Subject: Re: [PATCH v5 07/19] mm/swap: consolidate swap inuse accounting helpers
To: Lian Wang <lianux.mm@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Jihan LIN <linjh22s@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6id4qkxf7msrqjkc67r7mbjizndixzdt
X-Rspamd-Queue-Id: D93771C0004
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795717671-838974
X-HE-Meta: U2FsdGVkX18bK3I8HwXpRmGrKc3U7bCm4ChuIgniCGhBpF27msvqrrk+JH+UtJNc97nR5MFW5Nq21Wt9lcn04iwgSieYET1VyE3IO/McRPfrL5iCyrmihVX9GcJNDMe2xLdsBvadoUPAUteZdnzvPPqif0OQqUUGH8dH11PXaqhX4i3O8Nh4TqnxCNlgKUcb+J5uGd35Ia/Fty9dGgkakvTPBevYeNt151XYUChOT6tCS2bwV4dif71QXYmsyeuGsEEfjM3NOSZ8uZEwp8VPlltejLYHSfwtYaR++fBCqXIRTu4E/XLQD//EaYkDibIOIi99uNnLbev/UV+O6CvKkVyHXM2QocqqP7IOtGkjnxkYhM2XvqSfFwRv8FowY47t4LFFm2z4hR7891KVNTbCy1inK/tQURZUFqbxqvAP8ZHHgZ4PWJ3XynH9QI1jTMAoxh711Xmv8nKCIg84HdzZ+yym21MAXcaVz3cx++H3C4UTtsOgx9Ssj+qScFFUgZxCublslwUeSNJp/OB4vYsosWYYlzcygUFoRkYL/+I9//tUdupknT/8OSxabWr0LGKdIjSRhqz9QVKQRSS68hSb93bYesh9wBmrsJc13G7U9SkKDuQDv2MnpThaVF618FVRnWndYQvQqWtYfLik9aKfprNw2iVca+VrutL24eYWTNWbG59fIrFy/78U0Z4RIRgyrtQNa08GhtQIEf/jne8rFSyueJA3Jv1yRTqlyCciQzWQ7qezZwD0rC153TmKQDjHiHT6TGLy/jPym0sgxfdB3CV9sz8XEgUuhkQS8XkakhAH0i3komvtFWjHn6wzWLKsX2veXBLtMv0rELqaoWrI5CY9HNyy6O75p6Pzrvru2l/GuV4BcEdYVHHxK9T9kJCMZHJNMGV7YYNbiw9NslcC08jbmTNJFKZZ2hjvcg9DIn5XuGnQKB9WnZ8PJlUc/HYzwplv7S9lAmvLQQ68GF4
 D6Bc2GM3
 IA29qk/bsc0gGCV9A38Skk4V+RUX8RsHdju43t8oU0zc4bmCgW5IV6qiM19kINn5gwBTH8f4M6t/YvG/RpCKihff8Z1h6H/Hro5NVsrWV8CoCnVrpTJnDsKBGZmGeaRMGSFTJZQPgJ/7lnhNy+LnlbnhQNkOJZRa/rzr5sllDuFNSX6lCp1sG1TVoHYBwxof73eticE7pVJ9acW5WLOAqlYke00XJ1qou4ZBko8/6p31lfaprIACu3JnNaUvJozsn7X2AIZrJkL99sbPoTMVdybaCv0a8FJBE11hlJ8qy+xqPKGhrxstzorEm8Zr7I0Qh2lMyoSc+o66VDNmI73jke0J6k1He7ylxG6eKku3RkPoWFvTotxAr8m4EIwTn7AmJi5U9dOcmmVqwoKZgSUzLD4TPbO7XFcbrmYkO6/ivQrMH22/3kWUFcgkHSZSpXetsRZ5UJtZw197ti9qLr/+cqni1BOpd31NGscI/sdNyiAm+Ykuhnxp0JD2MpGMS7fzeGH8HPJfCGf4NKSd0oGtXBblSm3g9RsLojCe4qVY5IEeQevv+AzXWmvfBZCrwMbdHpAdofTX/lFaWGlbvR3qzFY5l2BK+4iORsggk5AuIKnfaBzRJUho5k4Lk/0KDGF2mNRma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 6:17=E2=80=AFAM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Inline the swap_usage_add/sub helpers into their only callers and
> rename the callers to better reflect what they actually do: track
> per-device inuse page counts.
>
> Keep the existing accounting and allocation policy. In the inlined
> full-device path, reclaim work is scheduled before availability removal
> rather than afterwards. Slot-free notifications and zswap invalidation
> retain their existing order.

Can you confirm this patch has no behavioral change? It is only about
manual inline and rename functions. If so, add that to the commit
message. It can help the reviewer.

Any way, that is my read of the patch so far.

Chris

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 64 ++++++++++++++++++++++-----------------------------
>  1 file changed, 27 insertions(+), 37 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 24f301ef4e3a..4fac894f8c2a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -49,8 +49,8 @@
>  #include "internal.h"
>  #include "swap.h"
>
> -static void swap_range_alloc(struct swap_info_struct *si,
> -                            unsigned int nr_entries);
> +static void swap_device_inuse_add(struct swap_info_struct *si,
> +                                 unsigned int nr_entries);
>  static bool folio_swapcache_freeable(struct folio *folio);
>  static void move_cluster(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci, struct list_head *=
list,
> @@ -1045,7 +1045,7 @@ static bool __swap_cluster_alloc_entries(struct swa=
p_info_struct *si,
>         if (cluster_is_empty(ci))
>                 ci->order =3D order;
>         ci->count +=3D nr_pages;
> -       swap_range_alloc(si, nr_pages);
> +       swap_device_inuse_add(si, nr_pages);
>
>         return true;
>  }
> @@ -1363,53 +1363,36 @@ static void add_to_avail_list(struct swap_info_st=
ruct *si)
>  }
>
>  /*
> - * swap_usage_add / swap_usage_sub of each slot are serialized by ci->lo=
ck
> - * within each cluster, so the total contribution to the global counter =
should
> - * always be positive and cannot exceed the total number of usable slots=
.
> + * swap_device_inuse_add / swap_device_inuse_sub are called within clust=
er
> + * update critical sections and serialized by ci->lock within each clust=
er,
> + * so the total contribution to the global counter should always be posi=
tive
> + * and cannot exceed the total number of usable slots.
>   */
> -static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_=
entries)
> +static void swap_device_inuse_add(struct swap_info_struct *si,
> +                                 unsigned int nr_entries)
>  {
> -       long val =3D atomic_long_add_return_relaxed(nr_entries, &si->inus=
e_pages);
> +       long inuse_pages;
>
>         /*
>          * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
>          * remove it from the plist.
>          */
> -       if (unlikely(val =3D=3D si->pages)) {
> -               del_from_avail_list(si, false);
> -               return true;
> -       }
> -
> -       return false;
> -}
> -
> -static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_=
entries)
> -{
> -       long val =3D atomic_long_sub_return_relaxed(nr_entries, &si->inus=
e_pages);
> -
> -       /*
> -        * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
> -        * add it to the plist.
> -        */
> -       if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
> -               add_to_avail_list(si);
> -}
> -
> -static void swap_range_alloc(struct swap_info_struct *si,
> -                            unsigned int nr_entries)
> -{
> -       if (swap_usage_add(si, nr_entries)) {
> +       inuse_pages =3D atomic_long_add_return_relaxed(nr_entries, &si->i=
nuse_pages);
> +       if (unlikely(inuse_pages =3D=3D si->pages)) {
>                 if (vm_swap_full())
>                         schedule_work(&si->reclaim_work);
> +               del_from_avail_list(si, false);
>         }
> +
>         atomic_long_sub(nr_entries, &nr_swap_pages);
>  }
>
> -static void swap_range_free(struct swap_info_struct *si, unsigned long o=
ffset,
> -                           unsigned int nr_entries)
> +static void swap_device_inuse_sub(struct swap_info_struct *si, unsigned =
long offset,
> +                                 unsigned int nr_entries)
>  {
>         unsigned long end =3D offset + nr_entries - 1;
>         void (*swap_slot_free_notify)(struct block_device *, unsigned lon=
g);
> +       long inuse_pages;
>
>         zswap_invalidate(si->type, offset, nr_entries);
>
> @@ -1431,7 +1414,14 @@ static void swap_range_free(struct swap_info_struc=
t *si, unsigned long offset,
>          */
>         smp_wmb();
>         atomic_long_add(nr_entries, &nr_swap_pages);
> -       swap_usage_sub(si, nr_entries);
> +
> +       /*
> +        * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
> +        * add it back to the plist.
> +        */
> +       inuse_pages =3D atomic_long_sub_return_relaxed(nr_entries, &si->i=
nuse_pages);
> +       if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
> +               add_to_avail_list(si);
>  }
>
>  static bool get_swap_device_info(struct swap_info_struct *si)
> @@ -2059,7 +2049,7 @@ void __swap_cluster_free_entries(struct swap_info_s=
truct *si,
>         if (batch_id)
>                 mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
>
> -       swap_range_free(si, ci_head + ci_start, nr_pages);
> +       swap_device_inuse_sub(si, ci_head + ci_start, nr_pages);
>         swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
>
>         if (!ci->count)
> @@ -2999,7 +2989,7 @@ static int try_to_unuse(unsigned int type)
>  success:
>         /*
>          * Make sure that further cleanups after try_to_unuse() returns h=
appen
> -        * after swap_range_free() reduces si->inuse_pages to 0.
> +        * after swap_device_inuse_sub() reduces si->inuse_pages to 0.
>          */
>         smp_mb();
>         return 0;

