Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C02EB48EC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F146B0005; Thu, 12 Feb 2026 04:08:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCE46B0089; Thu, 12 Feb 2026 04:08:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1EC6B008A; Thu, 12 Feb 2026 04:08:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2A586B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:08:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 656071B401C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:08:00 +0000 (UTC)
X-FDA: 84435227520.09.5B737CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8CE28140006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:07:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RDZVe3co;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770887278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lliPlvBmkPm7hBPB7uwZC2ZXX5cr/bNRV/MZIHAtQ/Y=;
	b=fZcU8Fd/pQMRYZxaDFEAYwpkQOCh47cHTH2bFta3mNWRd5QbX+Ytm4Vw16ixlMqv4VUYRa
	IgGbjef4qrbrMelEwva/npxz0byS2FJ3/y5xdFcXN32Mx4xm727YWSfykruupkjDmRMuW3
	nmlSQ6Lj1kbncH2ctg/65wawz1RfyVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770887278; a=rsa-sha256;
	cv=none;
	b=SItewlSjugjiVDeWHqNt4SNjW+HcDxMm1zNUj+H+XZmIzTa8OCxqkjvT9oNv68Xr8Cyv6z
	dHW+gzpOwDtxEp7wtzLJgUuGqbfvMNXCEkSkz4aPPg+Ldtc/CMFOsuN/KAdlc6xstGyVmn
	fca0MIaC/WH64RMnqr3WY3DvZBCieJY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RDZVe3co;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E3E3760128
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5090C2BCAF
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770887277;
	bh=qoy6XKpHO1TlhngPIx3e+3Nzw7jaed9Ksf5M5kg7HvU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RDZVe3con05BhRn6V7gsKnbyHcHimqqFLCnEu9RnCuOsS31LJhDM2WS4M1yiS7+MT
	 k8AisdCjguWZPrTsfzbuOcJ2e4NibgWMGNlydx4z+YI9q6z4+XFvjRDbsr1CpLpOLa
	 45e22Lj8UDTZx1DnqVDy5xqIm5VSJZzha3HQcVKA5Q5oMqIE3Nb6Ell35VqtaGB0yX
	 IqWE69Br3+ebUjy/pIWngz297G7WV+2QgFvP+D1s87lIv2USP3xTQcZKVYGztMrKKe
	 /4ALEqD7yASj8l2CmGwWG7vpMC9nFQPI/SBN2Vd4FHI5w6l9U31cSEE0vTiUFHC7N/
	 7StQcodFg28Gg==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-79430ef54c3so60183697b3.2
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:07:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXp85CkdqjyNI24yHNwTzQGLVkz8u6HWW/XVIuMEd3xh3hpLjkuz8QigK/02/hnHew4LMiu0kIIeA==@kvack.org
X-Gm-Message-State: AOJu0YzE4yJdeteK/k7GzAUytDsRNReBMxHOwnIPhuWwoS71+sQMGvXL
	zduKbfh5jb9Ne4gxmslk7O33ZG0X1ljnaNaIyAD+oJDkVYGfKE2Edug4XfndbcfTywbWKar3bqQ
	WSuX/jl1Eh4VtGJkd+ZRXX+IqycOXCjVS305i40m1bA==
X-Received: by 2002:a05:690c:c52b:b0:796:5b5e:f4e9 with SMTP id
 00721157ae682-797376918b0mr22651867b3.4.1770887276880; Thu, 12 Feb 2026
 01:07:56 -0800 (PST)
MIME-Version: 1.0
References: <20260126065242.1221862-1-youngjun.park@lge.com> <20260126065242.1221862-2-youngjun.park@lge.com>
In-Reply-To: <20260126065242.1221862-2-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 12 Feb 2026 01:07:45 -0800
X-Gmail-Original-Message-ID: <CACePvbVML6ZNJBWU9YSUCWwrbGd2eXMcsWxs6yFssfyBoEk5Uw@mail.gmail.com>
X-Gm-Features: AZwV_Qg4Po4HRf7e4fZLyrKkHG6HIAr1ZE9a7ro0S7NhL5MWm0p5c8AlebbLdpk
Message-ID: <CACePvbVML6ZNJBWU9YSUCWwrbGd2eXMcsWxs6yFssfyBoEk5Uw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 v2 1/5] mm: swap: introduce swap tier infrastructure
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, 
	austin.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8CE28140006
X-Stat-Signature: t37xpt7snj3pdfn7if7dsjgnnmc9e99c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770887278-771223
X-HE-Meta: U2FsdGVkX188yTJwwKaLEJ8HEiHmGt8UoAFPU+EBYSnUWP6D3s8l+LI2VDR+TdUTrEXzWg4TOS9YFkJAUWUdZXbhNBr+Rahh2KeR1wGWbcA/8AI8km7QsWyqdw3wTsuxUzoPjfC3Fd7tt+OM7QsGq88qDUYxaPiX5NOazFhMKbf/hp0ikcVaaLWEI1Kr2J4n8I7nFFafWHJEbZekIxf9oxNb/6aLSd3ZqephuPlypLo9a+IOV/EWzrQiLqJ2FLS0VbvxJ9X5jkhq5yw+Ersd8eB21u7fXGkKpLDjLAkyuiP9sJg+XD+lbn9Rty9aJund9H2pedsVIWia8yWKHMVif81kTargI7ZcDJRwP6Ahk7lT6Chxq77rmDx1mgIQIHgRqStxskgriqRgmqIXe/krXhbNZzmF81iiqJNUybnKkuSPYerAgg7ZdHNw6FqfFr5wztSYF9tVZABiXynLHlPIJW4o488DmdgiCtweShaRnW7ofqrzpUAvCWU/LkssPva5Su5fJqJ/VWF2C3e3xkDM+glz9q2/e1h/f9WEQsTn33y2U5h+GEEJSEwnuI4UXsywwsuYAtEULLnmhHG+Eg+glunRcFVOb7Oi1fVxoqjgt6wWCS8uSPiQLsvHEJIMj2FdBQUYbmdYnfNqMxeXBtFqhwtEUI5Kv2K/XQ8r9yUMZAEFSVJcvSJtfu2AXg01+XsrAcoNXlmMwjfW8fpOfRCQjAGos0Cg/QwfZlxRuwx54IvdLHM519b98NIFm6a113vVQPChcjIqq0tlQZg5ex7FWj1KZ+hQe4HnZMEQ1wbYMkRvOva6tORhy6Hi1Wfb3y7kUfcWLMFINN19GUNWUEQGt0RWl3S66xG/MJEpyjthTObpFrLksI6Wdt1JAcO/nLwncojdPleKp+T/ONMzKE6DDyR9JnjFeOIQA85ItSR5R6+YTr4Decbv3W4hg+zsKk8EXaDrh+XRUUJNHqcOUry
 7RjYw5kg
 24PFgE5XU+a+hsOHPHN31ru1GA2CxQZY8zt+0Lu1bw4M70h3YafPbpdCND+1HVittQalV6RTZbq3ou11onMv2Znhi5qSCMohQxyWkTDirH98UEpeZkxYYRZzgN6wD/83MKYlmQvDFHtKWEfGWwaV3lqVzn0SuyZ51EIM5S8+lKEcuKHajdjsreejIlDZCAZk1E9+LUuNTAJExAkSfEZoOXPRBmQvjrGZUahw6tXNrbO7V6H/L+rCSglzC+PIa6SEWp7gEDnnHAV/3obUAWtuLrAnDzEG249OLtHphn3eFEBsjjDzj77dXh+nbrFtcjgQJaMzezTdNZ14Q5BQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yongjun,

On Sun, Jan 25, 2026 at 10:53=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> This patch introduces the "Swap tier" concept, which serves as an
> abstraction layer for managing swap devices based on their performance
> characteristics (e.g., NVMe, HDD, Network swap).
>
> Swap tiers are user-named groups representing priority ranges.
> These tiers collectively cover the entire priority
> space from -1 (`DEF_SWAP_PRIO`) to `SHRT_MAX`.
>
> To configure tiers, a new sysfs interface is exposed at
> `/sys/kernel/mm/swap/tiers`. The input parser evaluates commands from
> left to right and supports batch input, allowing users to add, remove or
> modify multiple tiers in a single write operation.
>
> Tier management enforces continuous priority ranges anchored by start
> priorities. Operations trigger range splitting or merging, but overwritin=
g
> start priorities is forbidden. Merging expands lower tiers upwards to
> preserve configured start priorities, except when removing `DEF_SWAP_PRIO=
`,
> which merges downwards.
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  MAINTAINERS     |   2 +
>  mm/Makefile     |   2 +-
>  mm/swap.h       |   4 +
>  mm/swap_state.c |  70 +++++++++++
>  mm/swap_tier.c  | 304 ++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/swap_tier.h  |  38 ++++++
>  mm/swapfile.c   |   7 +-
>  7 files changed, 423 insertions(+), 4 deletions(-)
>  create mode 100644 mm/swap_tier.c
>  create mode 100644 mm/swap_tier.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 18d1ebf053db..501bf46adfb4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16743,6 +16743,8 @@ F:      mm/swap.c
>  F:     mm/swap.h
>  F:     mm/swap_table.h
>  F:     mm/swap_state.c
> +F:     mm/swap_tier.c
> +F:     mm/swap_tier.h
>  F:     mm/swapfile.c
>
>  MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> diff --git a/mm/Makefile b/mm/Makefile
> index 53ca5d4b1929..3b3de2de7285 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -75,7 +75,7 @@ ifdef CONFIG_MMU
>         obj-$(CONFIG_ADVISE_SYSCALLS)   +=3D madvise.o
>  endif
>
> -obj-$(CONFIG_SWAP)     +=3D page_io.o swap_state.o swapfile.o
> +obj-$(CONFIG_SWAP)     +=3D page_io.o swap_state.o swapfile.o swap_tier.=
o
>  obj-$(CONFIG_ZSWAP)    +=3D zswap.o
>  obj-$(CONFIG_HAS_DMA)  +=3D dmapool.o
>  obj-$(CONFIG_HUGETLBFS)        +=3D hugetlb.o hugetlb_sysfs.o hugetlb_sy=
sctl.o
> diff --git a/mm/swap.h b/mm/swap.h
> index bfafa637c458..55f230cbe4e7 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -16,6 +16,10 @@ extern int page_cluster;
>  #define swap_entry_order(order)        0
>  #endif
>
> +#define DEF_SWAP_PRIO  -1
> +
> +extern spinlock_t swap_lock;
> +extern struct plist_head swap_active_head;
>  extern struct swap_info_struct *swap_info[];
>
>  /*
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6d0eef7470be..f1a7d9cdc648 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -25,6 +25,7 @@
>  #include "internal.h"
>  #include "swap_table.h"
>  #include "swap.h"
> +#include "swap_tier.h"
>
>  /*
>   * swapper_space is a fiction, retained to simplify the path through
> @@ -947,8 +948,77 @@ static ssize_t vma_ra_enabled_store(struct kobject *=
kobj,
>  }
>  static struct kobj_attribute vma_ra_enabled_attr =3D __ATTR_RW(vma_ra_en=
abled);
>
> +static ssize_t tiers_show(struct kobject *kobj,
> +                                    struct kobj_attribute *attr, char *b=
uf)
> +{
> +       return swap_tiers_sysfs_show(buf);
> +}
> +
> +static ssize_t tiers_store(struct kobject *kobj,
> +                       struct kobj_attribute *attr,
> +                       const char *buf, size_t count)
> +{
> +       char *p, *token, *name, *tmp;
> +       int ret =3D 0;
> +       short prio;
> +       DEFINE_SWAP_TIER_SAVE_CTX(ctx);
> +
> +       tmp =3D kstrdup(buf, GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       spin_lock(&swap_lock);
> +       spin_lock(&swap_tier_lock);
> +
> +       p =3D tmp;
> +       swap_tiers_save(ctx);
> +
> +       while (!ret && (token =3D strsep(&p, ", \t\n")) !=3D NULL) {
> +               if (!*token)
> +                       continue;
> +
> +               if (token[0] =3D=3D '-') {
> +                       ret =3D swap_tiers_remove(token + 1);
> +               } else {
> +
> +                       name =3D strsep(&token, ":");
> +                       if (!token || kstrtos16(token, 10, &prio)) {
> +                               ret =3D -EINVAL;
> +                               goto out;
> +                       }
> +
> +                       if (name[0] =3D=3D '+')
> +                               ret =3D swap_tiers_add(name + 1, prio);
> +                       else
> +                               ret =3D swap_tiers_modify(name, prio);
> +               }
> +
> +               if (ret)
> +                       goto restore;
> +       }

This function can use some simplification to make the indentation flater.

> +
> +       if (!swap_tiers_validate()) {
> +               ret =3D -EINVAL;
> +               goto restore;
> +       }
> +
> +out:
> +       spin_unlock(&swap_tier_lock);
> +       spin_unlock(&swap_lock);
> +
> +       kfree(tmp);
> +       return ret ? ret : count;
> +
> +restore:
> +       swap_tiers_restore(ctx);
> +       goto out;
> +}
> +
> +static struct kobj_attribute tier_attr =3D __ATTR_RW(tiers);
> +
>  static struct attribute *swap_attrs[] =3D {
>         &vma_ra_enabled_attr.attr,
> +       &tier_attr.attr,
>         NULL,
>  };
>
> diff --git a/mm/swap_tier.c b/mm/swap_tier.c
> new file mode 100644
> index 000000000000..87882272eec8
> --- /dev/null
> +++ b/mm/swap_tier.c
> @@ -0,0 +1,304 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/swap.h>
> +#include <linux/memcontrol.h>
> +#include "memcontrol-v1.h"
> +#include <linux/sysfs.h>
> +#include <linux/plist.h>
> +
> +#include "swap.h"
> +#include "swap_tier.h"
> +
> +/*
> + * struct swap_tier - structure representing a swap tier.
> + *
> + * @name: name of the swap_tier.
> + * @prio: starting value of priority.
> + * @list: linked list of tiers.
> +*/
> +static struct swap_tier {
> +       char name[MAX_TIERNAME];
> +       short prio;
> +       struct list_head list;
> +} swap_tiers[MAX_SWAPTIER];

We can have a CONFIG option for the MAX_SWAPTIER. I think the default
should be a small number like 4.

> +
> +DEFINE_SPINLOCK(swap_tier_lock);
> +/* active swap priority list, sorted in descending order */
> +static LIST_HEAD(swap_tier_active_list);
> +/* unused swap_tier object */
> +static LIST_HEAD(swap_tier_inactive_list);
> +
> +#define TIER_IDX(tier) ((tier) - swap_tiers)
> +#define TIER_MASK(tier)        (1 << TIER_IDX(tier))
> +#define TIER_INVALID_PRIO (DEF_SWAP_PRIO - 1)
> +#define TIER_END_PRIO(tier) \
> +       (!list_is_first(&(tier)->list, &swap_tier_active_list) ? \
> +       list_prev_entry((tier), list)->prio - 1 : SHRT_MAX)
> +
> +#define for_each_tier(tier, idx) \
> +       for (idx =3D 0, tier =3D &swap_tiers[0]; idx < MAX_SWAPTIER; \
> +               idx++, tier =3D &swap_tiers[idx])
> +
> +#define for_each_active_tier(tier) \
> +       list_for_each_entry(tier, &swap_tier_active_list, list)
> +
> +#define for_each_inactive_tier(tier) \
> +       list_for_each_entry(tier, &swap_tier_inactive_list, list)
> +
> +/*
> + * Naming Convention:
> + *   swap_tiers_*() - Public/exported functions
> + *   swap_tier_*()  - Private/internal functions
> + */
> +
> +static bool swap_tier_is_active(void)
> +{
> +       return !list_empty(&swap_tier_active_list) ? true : false;
> +}
> +
> +static struct swap_tier *swap_tier_lookup(const char *name)
> +{
> +       struct swap_tier *tier;
> +
> +       for_each_active_tier(tier) {
> +               if (!strcmp(tier->name, name))
> +                       return tier;
> +       }
> +
> +       return NULL;
> +}
> +
> +void swap_tiers_init(void)
> +{
> +       struct swap_tier *tier;
> +       int idx;
> +
> +       BUILD_BUG_ON(BITS_PER_TYPE(int) < MAX_SWAPTIER);
> +
> +       for_each_tier(tier, idx) {
> +               INIT_LIST_HEAD(&tier->list);
> +               list_add_tail(&tier->list, &swap_tier_inactive_list);
> +       }
> +}
> +
> +ssize_t swap_tiers_sysfs_show(char *buf)
> +{
> +       struct swap_tier *tier;
> +       ssize_t len =3D 0;
> +
> +       len +=3D sysfs_emit_at(buf, len, "%-16s %-5s %-11s %-11s\n",
> +                        "Name", "Idx", "PrioStart", "PrioEnd");
> +
> +       spin_lock(&swap_tier_lock);
> +       for_each_active_tier(tier) {
> +               len +=3D sysfs_emit_at(buf, len, "%-16s %-5ld %-11d %-11d=
\n",
> +                                    tier->name,
> +                                    TIER_IDX(tier),
> +                                    tier->prio,
> +                                    TIER_END_PRIO(tier));
> +               if (len >=3D PAGE_SIZE)
> +                       break;
> +       }
> +       spin_unlock(&swap_tier_lock);
> +
> +       return len;
> +}
> +
> +static void swap_tier_insert_by_prio(struct swap_tier *new)
> +{
> +       struct swap_tier *tier;
> +
> +       for_each_active_tier(tier) {
> +               if (tier->prio > new->prio)
> +                       continue;
> +
> +               list_add_tail(&new->list, &tier->list);
> +               return;
> +       }
> +       /* First addition, or becomes the first tier */
> +       list_add_tail(&new->list, &swap_tier_active_list);
> +}
> +
> +static void __swap_tier_prepare(struct swap_tier *tier, const char *name=
,
> +       short prio)
> +{
> +       list_del_init(&tier->list);
> +       strscpy(tier->name, name, MAX_TIERNAME);
> +       tier->prio =3D prio;
> +}
> +
> +static struct swap_tier *swap_tier_prepare(const char *name, short prio)
> +{
> +       struct swap_tier *tier;
> +
> +       lockdep_assert_held(&swap_tier_lock);
> +
> +       if (prio < DEF_SWAP_PRIO)
> +               return NULL;
> +
> +       if (list_empty(&swap_tier_inactive_list))
> +               return ERR_PTR(-EPERM);
> +
> +       tier =3D list_first_entry(&swap_tier_inactive_list,
> +               struct swap_tier, list);
> +
> +       __swap_tier_prepare(tier, name, prio);
> +       return tier;
> +}
> +
> +static int swap_tier_check_range(short prio)
> +{
> +       struct swap_tier *tier;
> +
> +       lockdep_assert_held(&swap_lock);
> +       lockdep_assert_held(&swap_tier_lock);
> +
> +       for_each_active_tier(tier) {
> +               /* No overwrite */
> +               if (tier->prio =3D=3D prio)
> +                       return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +int swap_tiers_add(const char *name, int prio)

When we add, modify, remove a tier. The simple case is there is no
swap file under any tiers.
But if the modification causes some swap files to jump to different
tiers. That might be problematic.

> +{
> +       int ret;
> +       struct swap_tier *tier;
> +
> +       lockdep_assert_held(&swap_lock);
> +       lockdep_assert_held(&swap_tier_lock);
> +
> +       /* Duplicate check */
> +       if (swap_tier_lookup(name))
> +               return -EPERM;
> +
> +       ret =3D swap_tier_check_range(prio);
> +       if (ret)
> +               return ret;
> +
> +       tier =3D swap_tier_prepare(name, prio);
> +       if (IS_ERR(tier)) {
> +               ret =3D PTR_ERR(tier);
> +               return ret;
> +       }
> +
> +
> +       swap_tier_insert_by_prio(tier);
> +       return ret;
> +}
> +
> +int swap_tiers_remove(const char *name)
> +{
> +       int ret =3D 0;
> +       struct swap_tier *tier;
> +
> +       lockdep_assert_held(&swap_lock);
> +       lockdep_assert_held(&swap_tier_lock);
> +
> +       tier =3D swap_tier_lookup(name);
> +       if (!tier)
> +               return -EINVAL;
> +
> +       list_move(&tier->list, &swap_tier_inactive_list);
> +
> +       /* Removing DEF_SWAP_PRIO merges into the higher tier. */
> +       if (swap_tier_is_active() && tier->prio =3D=3D DEF_SWAP_PRIO)
> +               list_prev_entry(tier, list)->prio =3D DEF_SWAP_PRIO;
> +
> +       return ret;
> +}
> +
> +int swap_tiers_modify(const char *name, int prio)
> +{
> +       int ret;
> +       struct swap_tier *tier;
> +
> +       lockdep_assert_held(&swap_lock);
> +       lockdep_assert_held(&swap_tier_lock);
> +
> +       tier =3D swap_tier_lookup(name);
> +       if (!tier)
> +               return -EINVAL;
> +
> +       /* No need to modify */
> +       if (tier->prio =3D=3D prio)
> +               return 0;
> +
> +       ret =3D swap_tier_check_range(prio);
> +       if (ret)
> +               return ret;
> +
> +       list_del_init(&tier->list);
> +       tier->prio =3D prio;
> +       swap_tier_insert_by_prio(tier);
> +
> +       return ret;
> +}
> +
> +/*
> + * XXX: Reverting individual operations becomes complex as the number of
> + * operations grows. Instead, we save the original state beforehand and
> + * fully restore it if any operation fails.
> + */
> +void swap_tiers_save(struct swap_tier_save_ctx ctx[])

I really hope we don't have to do the save and restore thing. Is there
another design we can simplify this?

> +{
> +       struct swap_tier *tier;
> +       int idx;
> +
> +       lockdep_assert_held(&swap_lock);
> +       lockdep_assert_held(&swap_tier_lock);
> +
> +       for_each_active_tier(tier) {
> +               idx =3D TIER_IDX(tier);
> +               strcpy(ctx[idx].name, tier->name);
> +               ctx[idx].prio =3D tier->prio;
> +       }
> +
> +       for_each_inactive_tier(tier) {
> +               idx =3D TIER_IDX(tier);
> +               /* Indicator of inactive */
> +               ctx[idx].prio =3D TIER_INVALID_PRIO;
> +       }
> +}
> +
> +void swap_tiers_restore(struct swap_tier_save_ctx ctx[])
> +{
> +       struct swap_tier *tier;
> +       int idx;
> +
> +       lockdep_assert_held(&swap_lock);
> +       lockdep_assert_held(&swap_tier_lock);
> +
> +       /* Invalidate active list */
> +       list_splice_tail_init(&swap_tier_active_list,
> +                       &swap_tier_inactive_list);
> +
> +       for_each_tier(tier, idx) {
> +               if (ctx[idx].prio !=3D TIER_INVALID_PRIO) {
> +                       /* Preserve idx(mask) */
> +                       __swap_tier_prepare(tier, ctx[idx].name, ctx[idx]=
.prio);
> +                       swap_tier_insert_by_prio(tier);
> +               }
> +       }
> +}
> +
> +bool swap_tiers_validate(void)
> +{
> +       struct swap_tier *tier;
> +
> +       /*
> +        * Initial setting might not cover DEF_SWAP_PRIO.
> +        * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX=
).
> +        * Also, modify operation can change only one remaining priority.
> +        */
> +       if (swap_tier_is_active()) {
> +               tier =3D list_last_entry(&swap_tier_active_list,
> +                       struct swap_tier, list);
> +
> +               if (tier->prio !=3D DEF_SWAP_PRIO)
> +                       return false;
> +       }
> +
> +       return true;
> +}
> diff --git a/mm/swap_tier.h b/mm/swap_tier.h
> new file mode 100644
> index 000000000000..4b1b0602d691
> --- /dev/null
> +++ b/mm/swap_tier.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _SWAP_TIER_H
> +#define _SWAP_TIER_H
> +
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +
> +#define MAX_TIERNAME           16
> +
> +/* Ensure MAX_SWAPTIER does not exceed MAX_SWAPFILES */
> +#if 8 > MAX_SWAPFILES
> +#define MAX_SWAPTIER           MAX_SWAPFILES
> +#else
> +#define MAX_SWAPTIER           8
> +#endif
> +
> +extern spinlock_t swap_tier_lock;
> +
> +struct swap_tier_save_ctx {
> +       char name[MAX_TIERNAME];
> +       short prio;
> +};
> +
> +#define DEFINE_SWAP_TIER_SAVE_CTX(_name) \
> +       struct swap_tier_save_ctx _name[MAX_SWAPTIER] =3D {0}
> +
> +/* Initialization and application */
> +void swap_tiers_init(void);
> +ssize_t swap_tiers_sysfs_show(char *buf);
> +
> +int swap_tiers_add(const char *name, int prio);
> +int swap_tiers_remove(const char *name);
> +int swap_tiers_modify(const char *name, int prio);
> +
> +void swap_tiers_save(struct swap_tier_save_ctx ctx[]);
> +void swap_tiers_restore(struct swap_tier_save_ctx ctx[]);
> +bool swap_tiers_validate(void);
> +#endif /* _SWAP_TIER_H */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 7b055f15d705..c27952b41d4f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -50,6 +50,7 @@
>  #include "internal.h"
>  #include "swap_table.h"
>  #include "swap.h"
> +#include "swap_tier.h"
>
>  static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
>                                  unsigned char);
> @@ -65,7 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci, struct list_head *=
list,
>                          enum swap_cluster_flags new_flags);
>
> -static DEFINE_SPINLOCK(swap_lock);
> +DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
>  atomic_long_t nr_swap_pages;
>  /*
> @@ -76,7 +77,6 @@ atomic_long_t nr_swap_pages;
>  EXPORT_SYMBOL_GPL(nr_swap_pages);
>  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock=
 */
>  long total_swap_pages;
> -#define DEF_SWAP_PRIO  -1
>  unsigned long swapfile_maximum_size;
>  #ifdef CONFIG_MIGRATION
>  bool swap_migration_ad_supported;
> @@ -89,7 +89,7 @@ static const char Bad_offset[] =3D "Bad swap offset ent=
ry ";
>   * all active swap_info_structs
>   * protected with swap_lock, and ordered by priority.
>   */
> -static PLIST_HEAD(swap_active_head);
> +PLIST_HEAD(swap_active_head);

One idea is to make each tier have swap_active_head. So different swap
entry releases on different tiers don't need to be competing on the
same swap_active_head.

That will require the swapfile don't jump to another tiers.

Chris

