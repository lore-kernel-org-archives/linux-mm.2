Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED639606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 06:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXHb7j+E
Received: by kanga.kvack.org (Postfix)
	id A83306B05B5; Thu, 26 Nov 2026 01:54:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33A26B05B6; Thu, 26 Nov 2026 01:54:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949B66B05B7; Thu, 26 Nov 2026 01:54:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 642DB6B05B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:54:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD772A0318
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:54:31 +0000 (UTC)
X-FDA: 85476356742.04.A1EA571
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0EB0C40002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:54:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXHb7j+E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795676070;
	b=tvZrrA5dfP7OZPUdnjwJL4tcawgQh0FV6Jq/OBJV3Q6JDbQQ/4CGs7Djv/1Icu8P0Bi9Jt
	43vAjo+ZhVrpSGE+zBxJcpHOPKjJjg7CzXq9THzgOrbslT9VtU1xaBGHHNahEXoYKVv6Je
	BWfMMnzECyfswafF4XNAd1su7+wodYU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795676070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQquwoKjGpWDi9wdZUDJE0dmSqwIItrXiSYkdrFlgck=;
	b=Pbpug6mAQh4uec/hj5bnwczZXYuEVbRrGCNjYeqDxrXUgJcMUnRCU5ggNCsZ4tO/m5g0PV
	zfStmipU/GfxwMP32c5FSu0MnZ5AIwxhSEPRI7I+6RKSWDX0ZsF8IoLZzLM5+Va+ts5nwh
	Gx2bEEZn7q1CS/A5KEgRBhgKN2x7s/g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXHb7j+E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E0D36296F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EBA1F000CA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795676069;
	bh=VQquwoKjGpWDi9wdZUDJE0dmSqwIItrXiSYkdrFlgck=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TXHb7j+EtfScm8AX4rs6waC3TxgZ9YpF+f45oI60txaB4ijt/olONPGMxo4m8L4xo
	 Dx2Ea5gxcxo4VVHjJPDwlMzsTD9UHSlbtCgtXW2ZNdG8Mo2vlbt5dY3B5+VtieekHE
	 iF+PRbmVGUQGgCrDQegDQdJFNGBY8CKs/8DOSiHyHV5cCNON9O+YK3eUCeqZxK9vTh
	 7jErl1F+ZoW/xglkPA2l87KAujXlEg7kiSEEuHWb9XxNFw0/LRo6NDaACldVcyTEF8
	 wyV9K314/Q3yeJUL1t9j/hIIclsAfjieXj1igy9us22pzc4xdxYE0qJ426WGS0KCQQ
	 kbVWxMf3va/Ig==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b87408c797so255134a12.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:54:29 -0800 (PST)
X-Gm-Message-State: APuU4Z+6AHkeMuEh3hYDjhT0QewJ4aqs8BV2jahEom842CZ2m/aAIyt/
	dDqbqWS//nmr+dvgaz+sje+P7E3MZJpbRUn13C97bWhePg+hapLDjvxmIpTeuk7C2tsbTQb7HRX
	7kplqU1UtWlEiV+bDF72soPmx726FkqYKLUtjPcZdIg==
X-Received: by 2002:a17:907:1c9c:b0:c49:df95:fd0 with SMTP id
 a640c23a62f3a-c519ac70721mr578683166b.48.1795676067959; Wed, 25 Nov 2026
 22:54:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <5a83cfe8b0992c65cf4cca1e8cd612b4de0b78c6.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <5a83cfe8b0992c65cf4cca1e8cd612b4de0b78c6.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 25 Nov 2026 22:54:16 -0800
X-Gmail-Original-Message-ID: <CACePvbWLkZtdX-kedNHeFDRV+e3Hcyzixsc=9eENTrZVhiSjjQ@mail.gmail.com>
X-Gm-Features: Aa3M54qlKK0--aC_Z759v7Gd5wm7XNF21qBC83OTOadT1xD_SPdEJARQDOKqOLs
Message-ID: <CACePvbWLkZtdX-kedNHeFDRV+e3Hcyzixsc=9eENTrZVhiSjjQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/19] mm/swap: cleanup and document swap device
 availability flag usage
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
X-Stat-Signature: a4798147grxfbpoaj6wi985zzps3fpbe
X-Rspamd-Queue-Id: 0EB0C40002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795676069-556409
X-HE-Meta: U2FsdGVkX1+YAOlvpy7bqJ4Inw3gwl/fLTENJu+1lXttkyTjOPOSFlr4Z29/8JzGGnfsEaBYJ7s9OVsH7lfG8dE00oF7NXl3B0pnuV1NJbEHuytTcb1Nzb8LLAs/ZKQdtXrIng1f+CmKJ0a8A1pmMIz0PqOlRszHPUHccLvonAVfMWmu/Wn1V3/eQShTyoTX4fV7RPqwIakTfgr9N2Jg11EJlm4yWs29BJkLSRpYQTupOsyScpAqqusgChzXypWV6crSuwEVA26/47xEINv+SW8GpHq2oqKdZZMJKHVtqAmZ/o3gs3KrknXi/wjkfxZVsTN3Anlg6bHrJXkuCqQzLwICL6ppVtaYHsMqRaHY3/yEzStJIuUL1AHKMaEvHXw79ZpC2HaIDSNBEwX74GfEh8YhAd6iC4Gd29duTFFmvUG68C4JVVR4Kwtxsq9WQg2Fg8j6/b1NL87tWX5NMN34CA2upEHMIodw25KZLRxOIDm0/Pbsa3zDfQ9m9Z4fd2/2lg2hUeWi5OlOs9/04OcV+AFz2/lB0CSecWkKaUYuEJX9QVJ5n/0LxoMoYiOzaYzJH4KtejBXUi4KH6nLL91SBHgRHi5216JLJEXBVuQJED2QirdVEa0z5sJUGJLCL21R8I81liiFzmKcD7+n98huV4HZjSwBzDuKJFq+2DHR3UfPtnTulpfEtn7WgrCYe32ch8F1IoyN6S3/9dZkSioYeRQQ1X2EVfvLvcHLx14uD8w76t3S0ypPGE1tUaJr4st+tf3k8ErQhGUCXQSa7ICWJn8oLpZVQzaZcIkxfAYPf+ByvriDF6DHEhstclSn0Wtjlt6aeuoliwv1kuukGFGPYehZtDhoAhU0jSStSsZyxLIOyU/fZ1SYGSXbgSt8QzNSxA1irDLm67gkBeOyPIGB8NMLgF49hQ0uOFuuuL8EV4kGHWnuATg07uG60roF3Uu5JJMo/mc4b4qvQNjwJog
 mbpNiBAG
 jsogPviNWAc3RkURe3m5kgc9eabDGwi8FJu8lj6WziULG74Imto4JN3umcIQ0lFI7zhO7LC6WLtt7ELCqYzRgut05TvdywfmOFW2SaHhvUgsgFii7dCWl2ntr7kKbVMBFA8gmBfYzNOFCKFFMBhMJ5PMJG61DrYth2FO0+lJEzy4PMjTf8KfCiALHzE+7Cf3bEEFCalBBH4BPSM+ll+MMzftsP+ad2Abd1+Mtu6qzCd9G5U7i17ky3M/AUg3z4G04OssWTXqGzk0GKC9/3VYzCAtVu5ui+fNBOY0RtKX/y2ZXgSyGqi1kGYBwVXA6C4XuHuK7FdtgAHoEQDUyvTnlDFEA6PwBi4xNcm6l8pShcQe1m+P7A0huh5zNg0+S6XyAle8jpaRpBFCX5NK6M9KQCJYzH4S42hQreFKdTCo85O9bCi8hmFP20GuZsvCSBa6Gdz6fSscLyKLMeNjswVTTZWjR4D9IvoGuW+CnAOexqUAls5eq5wW9d0quu5A7KuZR2s6Vlap2b6oJoBwRAIbAFlTK+V44KrZN0snm4jLuy+g4s2teW5xyvsaHkRAXUXApKnj0cAntNQcTrK4t2M48CWxjuP17GNQwkOQhpj2jAlbgyQEU+UPTIiY+YrzMkR5ntTBDqNtKVYZ0e0EL2O9ueXsCnCV9PQKR/fSO9k/gqnFSRI9odgwYHF/GOQ==
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
> Rework swap device flag and metadata handling to make the writable
> publication and disable boundaries explicit.

This commit message could use a rewrite to improve clarity.
"Boundaries explicit" seems to mean extracting the swap device enable
and disable as two separate functions.

> Introduce swap_device_enable() and swap_device_disable(). Move
> SWP_WRITEOK updates into these boundaries. Clear the writable flag,
> set the off-list state and remove the available entry in one
> swap_avail_lock critical section, before releasing swap_lock.

I wish to see some explanation of the locking change:
For example
Before:
      foo,bar is covered by lock X
After:
      foo is covered by lock X,
      bar is covered by lock Y.

> Preserve the existing swap_lock critical section across mapping lookup,
> hibernation checks and the disable transition. Drain cluster allocators
> after dropping swap_lock, retaining the device-identity protection
> without holding swap_lock over all cluster locks.

This description doesn't fully explain the previous locking method vs
the new one. Is the idea to avoid using swap_lock for when cluster
lock is hold? Why is this change safe?

>
> Document the flag lifetime and locking rules.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  include/linux/swap.h |  29 ++++--
>  mm/swapfile.c        | 205 ++++++++++++++++++++-----------------------
>  2 files changed, 118 insertions(+), 116 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4f686709d71f..0fa77f5679a2 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -188,6 +188,24 @@ struct swap_extent {
>         ((offsetof(union swap_header, magic.magic) - \
>           offsetof(union swap_header, info.badpages)) / sizeof(int))
>
> +/*
> + * Swap device flags, except the ones documented below, all are immutabl=
e
> + * after exposed by swap_device_enable, and until the device is freed ag=
ain
> + * (SWP_USED unset), except that teardown clears SWP_ACTIVATED after dra=
ining
> + * allocators and live references. The other exceptions:
> + * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. On=
ce
> + *   set, won't be cleared unless all reference to this device is freed =
and
> + *   swapoff finished.
> + * - SWP_WRITEOK: Protected by swap_lock, si->lock and swap_avail_lock.

It seems SWP_WRITEOK is protected by any of those locks: swap_lock OR
si->lock OR swap_avail_lock.
One interpretation of "and" is that all of those locks must be held
which contraditing the explaination follows.

> + *   Clearing this flag is followed by waiting for all current cluster l=
ock
> + *   users to exit, so
> + *   checking this flag while holding any of these locks ensures the dev=
ice
> + *   is safe to use at the moment. Note: clearing this flag doesn't affe=
ct
> + *   pending IO or async requests, it only prevents further entry alloca=
tion
> + *   or new async request (e.g. discard) from initiating.
> + * - SWP_HIBERNATION: Protected by swap_lock. Indicates if the device
> + *   is pinned for hibernation.
> + */
>  enum {
>         SWP_USED        =3D (1 << 0),     /* is slot in swap_info[] used?=
 */
>         SWP_WRITEOK     =3D (1 << 1),     /* ok to write to this swap?   =
 */
> @@ -256,14 +274,9 @@ struct swap_info_struct {
>         struct file *swap_file;         /* seldom referenced */
>         struct completion comp;         /* seldom referenced */
>         spinlock_t lock;                /*
> -                                        * protect map scan related field=
s like
> -                                        * inuse_pages and all cluster li=
sts.
> -                                        * Other fields are only changed
> -                                        * at swapon/swapoff, so are prot=
ected
> -                                        * by swap_lock. changing flags n=
eed
> -                                        * hold this lock and swap_lock. =
If
> -                                        * both locks need hold, hold swa=
p_lock
> -                                        * first.
> +                                        * Protect cluster lists. Other f=
ields
> +                                        * are only changed at swapon/swa=
poff,
> +                                        * so are protected by swap_lock.
>                                          */
>         struct work_struct discard_work; /* discard worker */
>         struct work_struct reclaim_work; /* reclaim worker */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0ae901296731..f22197a6286c 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1268,28 +1268,23 @@ static void del_from_avail_list(struct swap_info_=
struct *si, bool swapoff)
>
>         spin_lock(&swap_avail_lock);
>
> -       if (swapoff) {
> -               /*
> -                * Forcefully remove it. Clear the SWP_WRITEOK flags for
> -                * swapoff here so it's synchronized by both si->lock and
> -                * swap_avail_lock, to ensure the result can be seen by
> -                * add_to_avail_list.
> -                */
> -               lockdep_assert_held(&si->lock);
> -               si->flags &=3D ~SWP_WRITEOK;
> -               atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
> -       } else {
> -               /*
> -                * If not called by swapoff, take it off-list only if it'=
s
> -                * full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
> -                * si->inuse_pages =3D=3D pages), any concurrent slot fre=
eing,
> -                * or device already removed from plist by someone else
> -                * will make this return false.
> -                */
> +       /*
> +        * Force remove it only for swapoff. Else, take it off-list only =
if
> +        * it's full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
> +        * si->inuse_pages =3D=3D pages), so concurrent slot freeing, or
> +        * concurrent list removal will make the cmpxchg fail and skip
> +        * the removal.
> +        */
> +       if (!swapoff) {
>                 pages =3D si->pages;
>                 if (!atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
>                                              pages | SWAP_USAGE_OFFLIST_B=
IT))
>                         goto skip;
> +       } else {

I couldn't help but notice this patch inverts the swapoff test
conditions. I am wondering if retaining the original if (swapoff) can
reduce the diff size slightly.


> +               lockdep_assert_held(&swap_lock);
> +               lockdep_assert_held(&si->lock);
> +               si->flags &=3D ~SWP_WRITEOK;
> +               atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>         }
>
>         plist_del(&si->avail_list, &swap_avail_head);
> @@ -1299,21 +1294,21 @@ static void del_from_avail_list(struct swap_info_=
struct *si, bool swapoff)
>  }
>
>  /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
> -static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
> +static void add_to_avail_list(struct swap_info_struct *si)
>  {
>         long val;
>         unsigned long pages;
>
>         spin_lock(&swap_avail_lock);
>
> -       /* Corresponding to SWP_WRITEOK clearing in del_from_avail_list *=
/
> -       if (swapon) {
> -               lockdep_assert_held(&si->lock);
> -               si->flags |=3D SWP_WRITEOK;
> -       } else {
> -               if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> -                       goto skip;
> -       }
> +       /*
> +        * Add the device to the avail list if SWP_WRITEOK is set and
> +        * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
> +        * SWP_WRITEOK first, so the device won't be re-added after
> +        * swapoff starts unless swap_device_enable resurrects it.
> +        */
> +       if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> +               goto skip;
>
>         if (!(atomic_long_read(&si->inuse_pages) & SWAP_USAGE_OFFLIST_BIT=
))
>                 goto skip;
> @@ -1369,7 +1364,7 @@ static void swap_usage_sub(struct swap_info_struct =
*si, unsigned int nr_entries)
>          * add it to the plist.
>          */
>         if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
> -               add_to_avail_list(si, false);
> +               add_to_avail_list(si);
>  }
>
>  static void swap_range_alloc(struct swap_info_struct *si,
> @@ -1421,7 +1416,7 @@ static bool get_swap_device_info(struct swap_info_s=
truct *si)
>          * up to dated.
>          *
>          * Paired with the spin_unlock() after setup_swap_info() in
> -        * enable_swap_info(), and smp_wmb() in swapoff.
> +        * swap_device_enable(), and smp_wmb() in swapoff.
>          */
>         smp_rmb();
>         return true;
> @@ -3140,58 +3135,88 @@ static int setup_swap_extents(struct swap_info_st=
ruct *sis,
>         return generic_swapfile_activate(sis, swap_file, span);
>  }
>
> -static void _enable_swap_info(struct swap_info_struct *si)
> -{
> -       atomic_long_add(si->pages, &nr_swap_pages);
> -       total_swap_pages +=3D si->pages;
> -
> -       assert_spin_locked(&swap_lock);
> -
> -       plist_add(&si->list, &swap_active_head);
> -
> -       /* Add back to available list */
> -       add_to_avail_list(si, true);
> -}
> -
>  /*
> - * Called after the swap device is ready, resurrect its percpu ref, it's=
 now
> - * safe to reference it. Add it to the list to expose it to the allocato=
r.
> + * Mark a fully initialized swap device writable and expose it to the
> + * allocator. The caller must have resurrected its percpu ref first.
>   */
> -static void enable_swap_info(struct swap_info_struct *si)
> +static void swap_device_enable(struct swap_info_struct *si)
>  {
> -       percpu_ref_resurrect(&si->users);
>         spin_lock(&swap_lock);
> +
>         spin_lock(&si->lock);
> -       _enable_swap_info(si);
> +       spin_lock(&swap_avail_lock);
> +       si->flags |=3D SWP_WRITEOK;
> +       spin_unlock(&swap_avail_lock);
>         spin_unlock(&si->lock);
> +
> +       atomic_long_add(si->pages, &nr_swap_pages);
> +       total_swap_pages +=3D si->pages;
> +       plist_add(&si->list, &swap_active_head);
>         spin_unlock(&swap_lock);
> +
> +       add_to_avail_list(si);

I notice add_to_avail_list(si) now it is out side of swap_lock, what
lock protects the avail_list, is that swap_avail_lock?

>  }
>
> -static void reinsert_swap_info(struct swap_info_struct *si)
> +static int swap_device_disable(struct address_space *mapping,
> +                              struct swap_info_struct **swap_info)

Hmm, this piece of code is moved from swapoff, and it also changes
lock behavior.

May I suggest splitting this patch into two? Patch 1 should only move
code for the disable and enable functions, without functional changes.
Patch 2 should contain the rest of the changes. That will make the
behavior change easier to digest for me. Right now I need to carefully
compare the original swapoff code to find out what has changed.

>  {
> +       struct swap_info_struct *si;
> +       struct swap_cluster_info *ci;
> +       unsigned long offset, end;
> +       int err =3D -EINVAL;
> +
>         spin_lock(&swap_lock);
> +       plist_for_each_entry(si, &swap_active_head, list) {
> +               if ((si->flags & SWP_WRITEOK) &&
> +                   si->swap_file->f_mapping =3D=3D mapping) {
> +                       err =3D 0;
> +                       break;
> +               }
> +       }
> +       if (err)
> +               goto unlock;
> +
> +       /*
> +        * Refuse swapoff while the device is pinned for hibernation.
> +        */
> +       if (si->flags & SWP_HIBERNATION) {
> +               err =3D -EBUSY;
> +               goto unlock;
> +       }
> +
> +       if (security_vm_enough_memory_mm(current->mm, si->pages)) {
> +               err =3D -ENOMEM;
> +               goto unlock;
> +       }
> +       vm_unacct_memory(si->pages);
> +
> +       /* Serialize with the WRITEOK check in isolate_lock_cluster(). */
>         spin_lock(&si->lock);
> -       _enable_swap_info(si);
> +       del_from_avail_list(si, true);
>         spin_unlock(&si->lock);
> -       spin_unlock(&swap_lock);
> -}
>
> -/*
> - * Called after clearing SWP_WRITEOK, ensures cluster_alloc_range
> - * see the updated flags, so there will be no more allocations.
> - */
> -static void wait_for_allocation(struct swap_info_struct *si)
> -{
> -       unsigned long offset;
> -       unsigned long end =3D ALIGN(si->max, SWAPFILE_CLUSTER);
> -       struct swap_cluster_info *ci;
> +       plist_del(&si->list, &swap_active_head);
> +       total_swap_pages -=3D si->pages;
> +       atomic_long_sub(si->pages, &nr_swap_pages);
>
> -       BUG_ON(si->flags & SWP_WRITEOK);
> +       end =3D ALIGN(si->max, SWAPFILE_CLUSTER);
> +unlock:
> +       spin_unlock(&swap_lock);
> +       if (err)
> +               return err;
>
> +       /*
> +        * The swap allocator doesn't take swap_lock. Looping through eve=
ry
> +        * cluster lock after clearing SWP_WRITEOK ensures that allocator=
s see
> +        * the updated flag and that no allocation remains in flight.
> +        */
>         for (offset =3D 0; offset < end; offset +=3D SWAPFILE_CLUSTER) {
>                 ci =3D swap_cluster_lock(si, offset);
>                 swap_cluster_unlock(ci);
>         }
> +
> +       *swap_info =3D si;
> +       return 0;
>  }
>
>  static void free_swap_cluster_info(struct swap_cluster_info *cluster_inf=
o,
> @@ -3236,7 +3261,6 @@ static void flush_percpu_swap_cluster(struct swap_i=
nfo_struct *si)
>         }
>  }
>
> -
>  SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  {
>         struct swap_info_struct *p =3D NULL;
> @@ -3245,7 +3269,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         struct address_space *mapping;
>         struct inode *inode;
>         unsigned int maxpages;
> -       int err, found =3D 0;
> +       int err;
>
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
> @@ -3258,44 +3282,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
>                 return PTR_ERR(victim);
>
>         mapping =3D victim->f_mapping;
> -       spin_lock(&swap_lock);
> -       plist_for_each_entry(p, &swap_active_head, list) {
> -               if (p->flags & SWP_WRITEOK) {
> -                       if (p->swap_file->f_mapping =3D=3D mapping) {
> -                               found =3D 1;
> -                               break;
> -                       }
> -               }
> -       }
> -       if (!found) {
> -               err =3D -EINVAL;
> -               spin_unlock(&swap_lock);
> -               goto out_dput;
> -       }
> -
> -       /* Refuse swapoff while the device is pinned for hibernation */
> -       if (p->flags & SWP_HIBERNATION) {
> -               err =3D -EBUSY;
> -               spin_unlock(&swap_lock);
> -               goto out_dput;
> -       }
> -
> -       if (!security_vm_enough_memory_mm(current->mm, p->pages))
> -               vm_unacct_memory(p->pages);
> -       else {
> -               err =3D -ENOMEM;
> -               spin_unlock(&swap_lock);
> -               goto out_dput;
> -       }

This is the source of the code move.

Chris

> -       spin_lock(&p->lock);
> -       del_from_avail_list(p, true);
> -       plist_del(&p->list, &swap_active_head);
> -       atomic_long_sub(p->pages, &nr_swap_pages);
> -       total_swap_pages -=3D p->pages;
> -       spin_unlock(&p->lock);
> -       spin_unlock(&swap_lock);
> +       err =3D swap_device_disable(mapping, &p);
> +       filp_close(victim, NULL);
>
> -       wait_for_allocation(p);
> +       if (err)
> +               return err;
>
>         set_current_oom_origin();
>         err =3D try_to_unuse(p->type);
> @@ -3303,8 +3294,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>
>         if (err) {
>                 /* re-insert swap space back into swap_list */
> -               reinsert_swap_info(p);
> -               goto out_dput;
> +               swap_device_enable(p);
> +               return err;
>         }
>
>         /*
> @@ -3364,13 +3355,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
>         p->flags =3D 0;
>         spin_unlock(&swap_lock);
>
> -       err =3D 0;
>         atomic_inc(&proc_poll_event);
>         wake_up_interruptible(&proc_poll_wait);
>
> -out_dput:
> -       filp_close(victim, NULL);
> -       return err;
> +       return 0;
>  }
>
>  #ifdef CONFIG_PROC_FS
> @@ -3792,7 +3780,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         /*
>          * Allocate or reuse existing !SWP_USED swap_info. The returned
>          * si will stay in a dying status, so nothing will access its con=
tent
> -        * until enable_swap_info resurrects its percpu ref and expose it=
.
> +        * until swap_device_enable resurrects its percpu ref and expose =
it.
>          */
>         si =3D alloc_swap_info();
>         if (IS_ERR(si))
> @@ -3960,7 +3948,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         si->swap_file =3D swap_file;
>
>         /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap de=
vice */
> -       enable_swap_info(si);
> +       percpu_ref_resurrect(&si->users);
> +       swap_device_enable(si);
>
>         pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%=
lluk %s%s%s%s\n",
>                 K((unsigned long)si->pages), name->name, si->prio, nr_ext=
ents,

