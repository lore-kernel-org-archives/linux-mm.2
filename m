Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DCAC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7586B0092; Thu, 10 Sep 2026 07:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F286B0093; Thu, 10 Sep 2026 07:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A176B0096; Thu, 10 Sep 2026 07:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9E556B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:12:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E3A9404B0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:12:23 +0000 (UTC)
X-FDA: 85197588966.13.60E7149
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8B58718000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:12:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4SCKy70;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySAxteZYitEdS191q+Jhr+aLQ0O+gtEaE0u4BcO+1bU=;
	b=IR1iTTzFdzE/fjSSmlp41JvdaBSz8xEdIG6tu3XMXijx+09/okal8q+MVVxVJtkYujiLbZ
	rWNDj/8MlWjkBiQrkFD7b9Q5c+DGWCVEdzZLTsjmAxwOQjTR7qSttDAqFcI4g4qhV/Pkq5
	MYljadiLNK8xjf6johQUMPkNcLvXGaE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4SCKy70;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038741;
	b=2q53xp2dYUgiMfOZOnp63Qwrj2oQVKiCYWlcc4p/CuYBwPMRk7K3uZP7SViVCBMQOTyqT7
	M5/HezOB9VW3060No6fZH8r4TDTHVh6zo0zY6hgX4M2bJ2pXqDM4SE66G/qvW5VFeR65hW
	xV0P+EhU6Wyl9f5W2KlnmXUpI24dNUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FA48600CB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB50F1F00893
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038740;
	bh=ySAxteZYitEdS191q+Jhr+aLQ0O+gtEaE0u4BcO+1bU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e4SCKy70oF0334GIdpRouz7/q7kX1GWskMAAt3ntj/01FZg1iCVGFVhi1mte15ean
	 8wXe2Ruu8XmREwEx2kHuwjgYwUr/hd3W4644cT5kPgVC6x5E6g7dNaDIvqlB9Txnh5
	 JQ90RTtqZh5RYeaeWsPiRDN0GQ93NmHJmE7C99tH6WkjMefAbyJ0Dwhb/zTdoAsnmL
	 iOi2XXcFq9zaMPLegUPcTAyjTztACF2QuT5v5JOXFl/CTLCy5CnzEawrOOuZQnGunl
	 zrkn9MY4Cn2NSOOFFiiJWud1LWbn7aB3/OaMEBSdAexkIlXOu935tId8OknXtHc4DX
	 maGXJ9RHSJbsg==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b1eso390267566b.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:12:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByNVHvCgSRQ761zG+snWgAfWgJK1BrW4AcAV92FZSNHuRG9PkOqTRghUU72u8u4B7ugMhpUSrj9Vg==@kvack.org
X-Gm-Message-State: AFuF++lhzyEWrQZyWh5Kzl+dItK4e/VaejgvoakOuearFUmQa7LPELsd
	2NOz/PpmEJiJoFjx+8yE1G3IvUufZqWHZWmyD5y/5oBBZsYqq4pxWRjKRM+kWMz5OjYqB/5NEiK
	7pcF9w5MGPAOoQIzROZKW8JATCKeVeGE=
X-Received: by 2002:a17:907:c653:20b0:c29:4147:f4e2 with SMTP id
 a640c23a62f3a-c29414802c6mr448054966b.15.1789038739686; Thu, 10 Sep 2026
 04:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
 <20260910095449.715183-5-wangkefeng.wang@huawei.com> <CAO9r8zP-bGU8Hr+0ah9vpxWJBdbw+wTGMuC8+pTOHa+9XaeU+w@mail.gmail.com>
 <ea608517-49ce-4a9e-83bb-8687a139c4f2@huawei.com>
In-Reply-To: <ea608517-49ce-4a9e-83bb-8687a139c4f2@huawei.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 04:12:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMsx=JkdXnWT6aj0vEXwk33a_dUwR47ikdsFm+ER6dOSw@mail.gmail.com>
X-Gm-Features: AcwNN1UhVCdf5PHGeb2X_v9vKXqe4Lz0D4VOkUWxzGYhsSnrNxYMPw4VWhOyDRg
Message-ID: <CAO9r8zMsx=JkdXnWT6aj0vEXwk33a_dUwR47ikdsFm+ER6dOSw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: zswap: skip zswap_invalidate() in
 swap_range_free() when zswap is unused
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: nbt74id4wodjarrs9kajndsufieumthm
X-Rspamd-Queue-Id: 8B58718000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789038741-893109
X-HE-Meta: U2FsdGVkX1+BnG9TuR8h1Er/GuyIjpYVmXL0sHLayRHneLS4EP44qmQoSpzuFia/xZ4tqebR/QLMIzih08kf5gc5Z6c4PCymh36TMgb1HiZW+MZnghJJjejTMFhKKsI4o1c1sL0uHObbgrtHcQ9t+5T8TJQUyXfKY5ksBbtn6UqzCzUOyt4c7KCvsYjkPTgdQa0CU7qdU5md75BGwBXouha/JmsLK0YqL29yCvS7UnHHRjqKrAGEfat8FcnCwWtcvW0wdL0H26TOfEzHe2gtlvVpeO9hL9r90M92nfamC1MYnU00mgeFLCeNt23E2LKF2CPvhNAiLThiNXCdnDQ7HOjChFCVN4Blp7pL9GrM+vl591X/ztyf0QacdFUtXmvyae6hy35dQH5VrVC7OnPdlKFMtUNzUbdwX0/VZJJRnwfv9+ocnfAchFF6N6+UvGBabjnEK87zaw02O24qSALe0Ns9VcxYpHit/pwjJzcaqNkFk2LOIifw+sZS9Fj9Y+XI+oF7lr7naH/AEMzAb+6aLAwfdqi/1FOmz7xlkjWRkxXGn6ChC9FS1hGrLUMmsQ5Sc/m4l4EKbw0jJTFDs26vCpGVdFb2UANmxF7q/GKth9ebFzkiB/dnthM3cu1G6Rh+lt4V6uEuzyQsgjyIyfJmacGT+tJh6TyHAWhSwh4lN56A6qIq8sZ0tNsp3kY79bhtEebY842hdMglQS0MErm2qwoWHXFzXo0phkAO+eJPd5ZYwdkGBE+lOS7v+GjxfuCNrthupgNdigs6Tr2Kg/PnH8LTZucyByz7CfhRyqvqSqZKnLtOyoCa7uZ5w+cadnwbVDupoMDOF8VOK4IVV8/JDGIzgpG5SEAMH4zavxpxBF1pagiGAzTWp/bGHxKnIpRMjMPJHVFdbMYOXKwoKFYy8wZ+jzZtxCz8g2wfDUR2TU0EdTBsrXpaxZu51/Oq4eiPtqgtmKyR7eVZQPRCJpA
 FlSjKHfa
 gCflrwwYHgdW8TxWNXHVFnQybE2jgstSwWzZX85ckuqbW7LLJen83qt43SMwKnjob9KIPN85sFO1IqNRius+7Rxae8wjN9n0ZKBEjPSsKEvVGygYfzp7GDKiS7KlGUUCaiQ8wHOFxmZk0RSd71T5N5EDB7NRqsJ7BOUYRgBGpE22ikj97SW0dVsdXUF/teMiiRU9zPfTHvNNN8wsJTp4HpZRzEvYhbpyxErQcet/Ucf+95turRsWSuZuMUNfWU7nJxuAPbkYb181WQvkXf/McQwhq0UlmCGHafsN8FcnONlLT8eGffC8ZcZNFWjef1vooA6SIeVm992r0nWlQB9I15EKWVgS9odlCH8cCbI2IoIGOmg12NWmcc+C44yth3azfnCKj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 4:10=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
>
>
> On 9/10/2026 6:29 PM, Yosry Ahmed wrote:
> > On Thu, Sep 10, 2026 at 2:55=E2=80=AFAM Kefeng Wang <wangkefeng.wang@hu=
awei.com> wrote:
> >>
> >> swap_range_free() calls zswap_invalidate() for every slot being
> >> freed, even when zswap has never been enabled. Guard the loop with
> >> zswap_never_enabled() to skip it.
> >>
> >> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> >> ---
> >>   mm/swapfile.c | 6 ++++--
> >>   1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/mm/swapfile.c b/mm/swapfile.c
> >> index ba71905e4d46..505592051924 100644
> >> --- a/mm/swapfile.c
> >> +++ b/mm/swapfile.c
> >> @@ -1318,8 +1318,10 @@ static void swap_range_free(struct swap_info_st=
ruct *si, unsigned long offset,
> >>          void (*swap_slot_free_notify)(struct block_device *, unsigned=
 long);
> >>          unsigned int i;
> >>
> >> -       for (i =3D 0; i < nr_entries; i++)
> >> -               zswap_invalidate(si->type, offset + i);
> >> +       if (!zswap_never_enabled()) {
> >> +               for (i =3D 0; i < nr_entries; i++)
> >> +                       zswap_invalidate(si->type, offset + i);
> >> +       }
> >
> > What if we add the check in zswap_invalidate()? I understand we'd
> > avoid the loop here, which is nice, but I wonder if it's actually a
> > measurable difference.
> >
>
> Skipping useless instructions is always a good thing.
>
> > If we keep it in zswap_invalidate(), we can probably also skip patch 3?
>
> Maybe add nr_entries to zswap_invalidate() and check
> zswap_never_enabled() in it.
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 463bdee5c1e1..313c2f1b6c2e 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -27,7 +27,7 @@ struct zswap_lruvec_state {
>   unsigned long zswap_total_pages(void);
>   bool zswap_store(struct folio *folio);
>   int zswap_load(struct folio *folio);
> -void zswap_invalidate(int type, pgoff_t offset);
> +void zswap_invalidate(int type, pgoff_t offset, unsigned int nr_entries)=
;
>   int zswap_swapon(int type, unsigned long nr_pages);
>   void zswap_swapoff(int type);
>   void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
> @@ -49,7 +49,7 @@ static inline int zswap_load(struct folio *folio)
>          return -ENOENT;
>   }
>
> -static inline void zswap_invalidate(int type, pgoff_t offset) {}
> +static inline void zswap_invalidate(int type, pgoff_t offset, unsigned
> int nr_entries) {}
>   static inline int zswap_swapon(int type, unsigned long nr_pages)
>   {
>          return 0;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 505592051924..891379c95a01 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1316,12 +1316,8 @@ static void swap_range_free(struct
> swap_info_struct *si, unsigned long offset,
>   {
>          unsigned long end =3D offset + nr_entries - 1;
>          void (*swap_slot_free_notify)(struct block_device *, unsigned
> long);
> -       unsigned int i;
>
> -       if (!zswap_never_enabled()) {
> -               for (i =3D 0; i < nr_entries; i++)
> -                       zswap_invalidate(si->type, offset + i);
> -       }
> +       zswap_invalidate(si->type, offset, nr_entries);
>
>          if (si->flags & SWP_BLKDEV)
>                  swap_slot_free_notify =3D
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 6197aa71e33c..0e72cc9a5415 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1549,13 +1549,8 @@ bool zswap_store(struct folio *folio)
>           * offsets corresponding to each page of the folio. Otherwise,
>           * writeback could overwrite the new data in the swapfile.
>           */
> -       if (!ret) {
> -               unsigned type =3D swp_type(swp);
> -               pgoff_t offset =3D swp_offset(swp);
> -
> -               for (index =3D 0; index < nr_pages; ++index)
> -                       zswap_invalidate(type, offset + index);
> -       }
> +       if (!ret)
> +               zswap_invalidate(swp_type(swp), swp_offset(swp), nr_pages=
);
>
>          return ret;
>   }
> @@ -1661,17 +1656,25 @@ int zswap_load(struct folio *folio)
>          return 0;
>   }
>
> -void zswap_invalidate(int type, pgoff_t offset)
> +void zswap_invalidate(int type, pgoff_t offset, int nr_entries)
>   {
> -       struct xarray *tree =3D zswap_tree(type, offset);
>          struct zswap_entry *entry;
> +       struct xarray *tree;
> +       int i;
>
> -       if (xa_empty(tree))
> +       if (!zswap_never_enabled())
>                  return;
>
> -       entry =3D xa_erase(tree, offset);
> -       if (entry)
> -               zswap_entry_free(entry);
> +       for (i =3D 0; i < nr_entries; ++i) {
> +               tree =3D zswap_tree(type, offset + i);
> +
> +               if (xa_empty(tree))
> +                       return;
> +
> +               entry =3D xa_erase(tree, offset + i);
> +               if (entry)
> +                       zswap_entry_free(entry);
> +       }
>   }
>
> If no objections, I will refresh all the patches.

Yeah I think that's a good idea, even for the zswap_store() path.

