Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1AA606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXW9C6+2
Received: by kanga.kvack.org (Postfix)
	id BAF8B6B05B2; Thu, 26 Nov 2026 12:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60C56B05B3; Thu, 26 Nov 2026 12:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F006B05B4; Thu, 26 Nov 2026 12:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76FC66B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:26:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17CEAA04E2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:26:45 +0000 (UTC)
X-FDA: 85477949970.09.C5E7C36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3ECFBA000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:26:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXW9C6+2;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795714003;
	b=ESPWabGKiYsYekmEuhRitCrYD06/aIjP1UdIydVxu0ms+R9K7yTrjwONzHuzUCz20JniDy
	LZGH9GG2F2/qWUadE9iNGttSwLtWnWCnR+FPkQ73eg+wKYZCDbBwW4BOKsPMXqUB2Vmu9C
	Z714bOceAIMyYoa+weRusBxu3ISsvNU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795714003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TsAdFflCae5+igj5qVBS4hOwgiKQAIIPXHogQ5HlvU=;
	b=O4HWYZDkvzh8sI9jiA8TDNSUSLtimIP/djdobXPSo/Jd+ImhEkOnCUvCLJvbrSlueYR70o
	D6DcRi5uVseCtN8QhfA+sWddO187eKfW38sCho8Fzi+7tFXoUrD0zRh5wiXLUVx1CHLAuS
	whf2FDAlacHziQ166enat8zE/UzP18A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXW9C6+2;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9CC860CF5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEFD1F000D8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795714002;
	bh=3TsAdFflCae5+igj5qVBS4hOwgiKQAIIPXHogQ5HlvU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nXW9C6+2gF1Q3zHNBPh8fBgfcJl1KF5jCuJOoyL8o79r4Jo4Qi8RYCE+y3y4gVhgg
	 nc0b1UM4KedhJ77WRrrMSxTvgEbywdv1OgVa9r0kq3ZJ3XScT//RfFOmrX2BOiVeBi
	 hdZiOKM3USpja0gYDwehlfItA/pcQkbB79zrz4+otu/2TxbHHZIs3uRTsihpvOIgdX
	 aNP0NmKyp/EvuGg+wAtzZgJvFcratHTWORY+eT96S0iegXqA0+5VQVnkSsKLgGOz78
	 bxi3hI5Ea+s3u6VibI5gvHyAO6QM854aMb9ECLC1130omghVqMrOtr9fPNXW3bMvT8
	 fRYG6YNFRth8g==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b87a1a2babso14452747a12.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:26:42 -0800 (PST)
X-Gm-Message-State: APuU4Z93HKgaTy9kehfRDTTEkI0zxXLGCxeQVC1b9Vw+YjaCNjfxlcst
	VAEuZe+G28BvAcS4Mrj+BXHb4YnNXgeQzA/Wgaa+wt8PZa/2vu+hdd6nazW96tBZVm1Vg/dJXx2
	X9K7V/G17zr7orSqPc56py944R5i+uD8y/Zz7NwzmNQ==
X-Received: by 2002:aa7:d8c6:0:b0:6b7:8b02:726e with SMTP id
 4fb4d7f45d1cf-6ba1fc20931mr13487563a12.18.1795714001262; Thu, 26 Nov 2026
 09:26:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <be6ef058f4a6babd3562270daa5b61c4ff9a6a50.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <be6ef058f4a6babd3562270daa5b61c4ff9a6a50.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Nov 2026 09:26:29 -0800
X-Gmail-Original-Message-ID: <CACePvbU2cg1EVBjONWjYcsanDM0JS4eLXgX9aGYeEaXu4zZ2-w@mail.gmail.com>
X-Gm-Features: Aa3M54rq-_aDaC2IZzYFQcaEVIrU54eEGaMwFyEv8kqdmSEUInVdyb4y-llAiSs
Message-ID: <CACePvbU2cg1EVBjONWjYcsanDM0JS4eLXgX9aGYeEaXu4zZ2-w@mail.gmail.com>
Subject: Re: [PATCH v5 04/19] mm/swap: introduce swap device iteration helper
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
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3ECFBA000B
X-Stat-Signature: 8bnzpe6jbm7361rpctn6bj6usqdsti8k
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795714003-476790
X-HE-Meta: U2FsdGVkX1/akC92AO52rhKQodARa4ecQVpMM8V+32THcaNZ1n+L+eFgKmythO19ZF6MpwSp7L725O4wUzLCSoQ3VPyiiCcZWSTCOvmc3DTgjeDJENKXYm7COS++SLiHWvuJGcpEIpkAsJQJOtbPILo3q8u3H8vJNE+lIVtiXDUPAaUpPmiPdJHn+gAKBHIQQEtSVQ48+1L4wyOkLIeDvLnXgAioSRIVkfbuEEDjU49wlStTbaz/ym7y3S+pY4RexvRQT8XKVlN6kgkkmB6l6hsgqtg8msSHVIHXefROsO5xr/viwapykLnDnU3j7cV7LBXvf3UJoah5S7die9OngJy6UMHzLU8PivdE+CcKPJ5eVi334Ps4AzjKxGINfdG0zpUybzGZL/6jgwG8oWmmDyfxqy2qUdYdwk6pVoNuymQGkKxNA8FhpsuWYFwcrMQMp4PzMQTCO21re6E3avw2htMLUaEpkvwy0OpLkn8Sb/kYZN2e5A+zmQhPvbsHtkA6pHDKPLTvTlpw1dQ1TR2j3iJ9tEngqgJjtEEwUb1Yfa4m6oEzqiX7oRyJRmVm4JrzMrVAlp5oIWWKEpomNVsj0HOr3QqBFlxHVQbfWpss5TLGLn6Gvyz/KUuoaDQG1EMYvSjFNZ3gZhTwXeIiFQINeHipaNNzk9uOPBu2LYc1gq42k2T+xc2ZbYBqIjWTkYkdnsHhn+kbbjusXFcphWOwBsPguVtkLhB7a7rSueMluyaYUOp758/bWZ3/fK0NpTjdQcVSAraalvoXOigcanwQgP+L30zLpIMuwM5rwyFuEnDiGrY8saS0J1nJ2TyWNnF1kjJFXU1DjLfU8TtsIP+ZJFSC9olAqF9fGEIhlYf42Lo1+nzD2iQ82oopLbVuSTf8Qvgj123rSD55+S/gF29ciCro5OsmuQxRRNiPUs0UsKpMq3K5zghx6tPQlmuXZq7iojJOoGBBI84t7PeVFCo
 t8JVoaD/
 4M6XcZYxQ64ln8xhOjk9ieSwg7PJbV0qOv3Zug541aX8QO4H44cI270p4Nk7wUiwTdviaGlB/Z5qYzvUGv/rUnMwyTOplCQXr7Cnr5n1vcGW8oHb6X1m462wylPK2UXg5soY4LWSCMxQ/nnEX+EAvCkEbrQOyef7IW8ahh4LIqEKMPqod8AvyxsknDRjzNMb0inAwexWRXX/E5r4G1OOaj/EbKyYQ1yHRWmyK8PzNm+6LD4eF/wmMVjvhj04ftn27yNMhkAp4iVoK+H7XZUFx7EEmkf09rZsXMwxg2d+ShlZjEbxt0Bc4V9GYtJ4CGosdb/PGUzCt9IZQH9b0u7+33rckGsT7Fjgb+UFxvY4qhBDKD0Ot4kfebtRhFa0ZvmIP4tQejZS/eyyH1ULJxMKz6Gd8Bh+aW3p6YMGrqVmPQj/U3DqouugLqG4JwixvymiQdcrEWsVOkXOitBa9EGlznH3USjQR7MAsk1ernCamW0N80A0ZBTVHsvUVvc3UpRL0i6cvI5lpk0eckB6li02BWgRqGBX2G5DpIaiC/Y2uJX/oBNZ92XOAX75D1u4WIosKuJh0nr4g5aEswzNsGpH2c3lnGU4ZETptcKDddaruptgdyWab7TqdAwveEyRvWVhAz3bRGMJRNz1q3Y6wW0pezunZJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 6:16=E2=80=AFAM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Separate iteration over allocated swap_info descriptors from iteration
> over writable devices. Hibernation lookups require SWP_USED and
> SWP_WRITEOK under swap_lock. Take a single snapshot for each flag
> test, since unrelated bits in the same word can change during setup.
>
> drain_mmlist() only needs the atomic usage count; walk every
> descriptor without loading flags there. In si_swapinfo(), count
> usage only for descriptors that are in use but no longer writable.
>
> Move the live-reference warning from __swap_type_to_info() into
> __swap_entry_to_info(). The iterator must inspect descriptors before
> applying its flag filter, including descriptors whose device reference
> is dead; entry-based lookup retains the warning.

The patches looks good. Some minor nitpick follows.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swap.h     | 12 ++++----
>  mm/swapfile.c | 77 ++++++++++++++++++++++++++++++++-------------------
>  2 files changed, 54 insertions(+), 35 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index d488a69c2809..70fd3ab655ff 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -108,16 +108,16 @@ static inline unsigned int swp_cluster_offset(swp_e=
ntry_t entry)
>   */
>  static inline struct swap_info_struct *__swap_type_to_info(int type)
>  {
> -       struct swap_info_struct *si;
> -
> -       si =3D READ_ONCE(swap_info[type]); /* rcu_dereference() */
> -       VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
> -       return si;
> +       return READ_ONCE(swap_info[type]); /* rcu_dereference() */
>  }
>
>  static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t =
entry)
>  {
> -       return __swap_type_to_info(swp_type(entry));
> +       struct swap_info_struct *si;
> +
> +       si =3D __swap_type_to_info(swp_type(entry)); /* rcu_dereference()=
 */
> +       VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
> +       return si;
>  }
>
>  static inline struct swap_cluster_info *__swap_offset_to_cluster(
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index f22197a6286c..56b75770d320 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -106,6 +106,34 @@ static DEFINE_SPINLOCK(swap_avail_lock);
>
>  struct swap_info_struct *swap_info[MAX_SWAPFILES];
>
> +static inline struct swap_info_struct *__swap_iter(int *i, unsigned long=
 flag)
> +{
> +       lockdep_assert_held(&swap_lock);
Nitpick: Suggest have a internal version of "int _i", then sync to
"int *i" at function exit.

> +       while (*i < nr_swapfiles) {

The trick part of this is that, if the caller change *i between you
test *i < nr_swapfile and you use *i for __swap_type_to_info(*i), you
can visit out of bound array.  So having an internal version of  *i as
scalor will remove that abuse. It is likely the compiler can generate
better code as well because it avoids needing to know about pointer
aliasing with pointer. I think your later verison might need to use
more complicate inter state that "int i", so you might as well make it
a inter struct which contains "int index" now.

> +               struct swap_info_struct *si =3D __swap_type_to_info(*i);
> +
> +               VM_WARN_ON(!si);

You don't need this WARN ON. When i < nr_swapfile, the swap_info[i]
array can never the NULL. If you are paranoid you can continue if "si"
is NULL.

> +               (*i)++;
> +               if (flag && (READ_ONCE(si->flags) & flag) !=3D flag)
> +                       continue;
> +               return si;
> +       }
> +       return NULL;
> +}
> +
> +#define __for_each_swap(si, flag)                      \
> +       for (int __i =3D 0; ((si) =3D __swap_iter(&__i, flag));)

This is a bit too cose to for_each_swap_info. May be __for_each_swap_dev_fl=
ag()

> +
> +/*
> + * for_each_swap_info - iterate over all allocated swap descriptors
> + * @si: the iterator
> + *
> + * Context: The caller must hold swap_lock. The lock may be dropped duri=
ng
> + * the loop body but must be re-acquired before the next iteration.
> + */
> +#define for_each_swap_info(si) __for_each_swap(si, 0)

NITPICK: for_each_swap_dev()?

> +#define for_each_avail_swap(si) __for_each_swap(si, SWP_USED | SWP_WRITE=
OK)

NITPICK: for_each_avail_swap_dev()?

> +
>  static struct kmem_cache *swap_table_cachep;
>
>  /* Protects si->swap_file for /proc/swaps usage */
> @@ -2284,26 +2312,18 @@ void swap_free_hibernation_slot(swp_entry_t entry=
)
>
>  static int __find_hibernation_swap_type(dev_t device, sector_t offset)
>  {
> -       int type;
> -
> -       lockdep_assert_held(&swap_lock);
> +       struct swap_info_struct *si;
>
>         if (!device)
>                 return -EINVAL;
>
> -       for (type =3D 0; type < nr_swapfiles; type++) {
> -               struct swap_info_struct *sis =3D swap_info[type];
> -
> -               if (!(sis->flags & SWP_WRITEOK))
> -                       continue;
> -
> -               if (device =3D=3D sis->bdev->bd_dev) {
> -                       struct swap_extent *se =3D first_se(sis);
> -
> -                       if (se->start_block =3D=3D offset)
> -                               return type;
> +       for_each_avail_swap(si) {
> +               if (device =3D=3D si->bdev->bd_dev) {
> +                       if (first_se(si)->start_block =3D=3D offset)
> +                               return si->type;
>                 }
>         }
> +
>         return -ENODEV;
>  }
>
> @@ -2470,16 +2490,13 @@ int find_hibernation_swap_type(dev_t device, sect=
or_t offset)
>
>  int find_first_swap(dev_t *device)
>  {
> -       int type, ret =3D -ENODEV;
> +       int ret =3D -ENODEV;
> +       struct swap_info_struct *si;
>
>         spin_lock(&swap_lock);
> -       for (type =3D 0; type < nr_swapfiles; type++) {
> -               struct swap_info_struct *sis =3D swap_info[type];
> -
> -               if (!(sis->flags & SWP_WRITEOK))
> -                       continue;
> -               *device =3D sis->bdev->bd_dev;
> -               ret =3D type;
> +       for_each_avail_swap(si) {
> +               *device =3D si->bdev->bd_dev;
> +               ret =3D si->type;
>                 break;
>         }
>         spin_unlock(&swap_lock);
> @@ -2996,12 +3013,14 @@ static int try_to_unuse(unsigned int type)
>   */
>  static void drain_mmlist(void)
>  {
> +       struct swap_info_struct *si;
>         struct list_head *p, *next;
> -       unsigned int type;
>
> -       for (type =3D 0; type < nr_swapfiles; type++)
> -               if (swap_usage_in_pages(swap_info[type]))
> +       for_each_swap_info(si) {
> +               if (swap_usage_in_pages(si))
>                         return;
> +       }
> +
>         spin_lock(&mmlist_lock);
>         list_for_each_safe(p, next, &init_mm.mmlist)
>                 list_del_init(p);
> @@ -3997,14 +4016,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>
>  void si_swapinfo(struct sysinfo *val)
>  {
> -       unsigned int type;
> +       struct swap_info_struct *si;
>         unsigned long nr_to_be_unused =3D 0;
>
>         spin_lock(&swap_lock);
> -       for (type =3D 0; type < nr_swapfiles; type++) {
> -               struct swap_info_struct *si =3D swap_info[type];
> +       for_each_swap_info(si) {
> +               unsigned long flags =3D READ_ONCE(si->flags);

Hmm. There is a READ_ONCE(si->flags) inside for_each_swap_info() as
well. Now you have two READ_ONCE(si->flags). How do you ensure that
flag between two READ_ONCE is always synced?

>
> -               if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
> +               if ((flags & (SWP_USED | SWP_WRITEOK)) =3D=3D SWP_USED)

I think for_each_swap_info() requested flags as SWP_USED |
SWP_WRITEOK. Is this intent here to catch the race that SWP_WRITEOK
get dropped after the for_each_swap_info()?

Chris

>                         nr_to_be_unused +=3D swap_usage_in_pages(si);
>         }
>         val->freeswap =3D atomic_long_read(&nr_swap_pages) + nr_to_be_unu=
sed;

