Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD128606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFR/P1EF
Received: by kanga.kvack.org (Postfix)
	id C26B06B05B1; Thu, 26 Nov 2026 13:03:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE296B05B3; Thu, 26 Nov 2026 13:03:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECA36B05B4; Thu, 26 Nov 2026 13:03:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B84086B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:03:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 368EBA04B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:03:41 +0000 (UTC)
X-FDA: 85478043042.18.292ABE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C3E1100002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:03:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HFR/P1EF";
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795716219;
	b=E7KAZ14nYUgwtFj6cnwNgN/o80URWEpgVRtVWGhNDRZcRob2xtePNh3tINOwFBKpFRdxk/
	zEn6e2E+AVbx1YE0RER1mjBmbQJOC1F1QiIO1GrN3fK6gl4cMq5v0aOrM7S8fPWN+cOL4C
	4xHVEmDkmMsMa9b4IzPyWxoccBuPXeI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795716219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77C/7Yo4lAyok32ViGsIAaPDkzGEj8TuAlyvEAe5JSQ=;
	b=hNZVLsF1RmEAxMvi5aVVWZf9/8iTukBlLdHIKuuGAHwXOvJ/bborlRGR0r/cADhC31hEML
	Qm68j1tp2k0+WMDpEQflTtOmbAG4LtW43bQpwmwCd3DCJ4JGc0eno3BNhBkwvrqwq/KJ8a
	ch/ufLpv4XcWf9JfO2WCsEj89X8wVd8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HFR/P1EF";
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AAEC455C1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C37A1F01564
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795716218;
	bh=77C/7Yo4lAyok32ViGsIAaPDkzGEj8TuAlyvEAe5JSQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HFR/P1EFKZkZBYj5qjr/XTdUUjN8J207KJeADsqjt0cyRV4Zo6hdRoLc1S9s4vvsd
	 DrcPitusNVp1+PelBcD/x1IAba6FpJTN7mWm8+4u/ez73W3tBmoW0PMeq/shhLQWQU
	 LrvdOauOzzx26/o8eOkd4U0eRQRpMVEk7xhsJYjOmqskmXc/kd5QPqoj7STRAX9++l
	 odNCpkzSheoGmybrr+JizEuAnnXejSzV1VYQIZLZGDFqTGBPBXcU6gjzWlhNnKHpCt
	 BgM8VZs9yY1sB7Ojqo0uJVL2P5ug2QcTq2cYU0PCuHza9aBjEznvybSWnzrHLY/R4Y
	 JOEKbNkYhhL9w==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso1346646966b.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:03:38 -0800 (PST)
X-Gm-Message-State: APuU4Z+Dm+v3gKaubwiEX2CaPG74GY8D0L4SHDURKWb6VfwnGE8U/NvZ
	7tYT4HGag238OWB6m6M+eDkru8aKUJnNkRsppNeH4ZenEVdJ9Td3uBo0I0XSPcnPHJC1oWdbp0H
	aK/yJ5HTpzlGHiw6Kxz+xFOj9LzOUuYhQt2uL1z/w1w==
X-Received: by 2002:a17:906:9c01:b0:c51:f96:feb with SMTP id
 a640c23a62f3a-c513a5e63ddmr1251884366b.5.1795716216689; Thu, 26 Nov 2026
 10:03:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <4f355219f202e5fce9e8dac7dee75f3ea7c51d4e.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <4f355219f202e5fce9e8dac7dee75f3ea7c51d4e.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Nov 2026 10:03:25 -0800
X-Gmail-Original-Message-ID: <CACePvbWriHftZbyJMNfZ-09KuK0ZgSMwxEC2P5Rs_zGAknndwA@mail.gmail.com>
X-Gm-Features: Aa3M54oisEBQjpyI1o5kaV0I7ZSS3kxLpo6aRUo3ayjWBrmCOULLh1nuWrdE8Xk
Message-ID: <CACePvbWriHftZbyJMNfZ-09KuK0ZgSMwxEC2P5Rs_zGAknndwA@mail.gmail.com>
Subject: Re: [PATCH v5 05/19] mm/swap: change the swapon lock into a percpu rwsem
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
X-Rspamd-Queue-Id: 2C3E1100002
X-Stat-Signature: tptwjqoamqdgih5kiq7mnukokbgpo6zj
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795716219-631884
X-HE-Meta: U2FsdGVkX18FlOFDEnuHpW8U67Jt5keQR/DynidXmuSuKcGHLSbryjAtDHVbxG2N0kKW/pDZv1ehvyIknOX7RsnxOIzeUZCedPxvhdENn7Oc6PtjINz4ZM+w9LYv/aA6OX9DnA8vZJpJ1UUFczhSbRSQ+sXcOwqAvzzshrTn0uDr0J5jiueKG4A4DQYcRpH2NDZgB+9d7jBlRkFu7P2TgwSbPh/PA5/OcWI9Er3fDKP3Nh7mCHlCIYAhrL8SeqY3ycs0QsmpFzsieGZrQ41MzUAh6KC6pkXmzP59lqTZ3FNHmOjel9OTTwEaka2sehHYNgCwP4aGhADP5SX2xNJO9IlDeEHg5fT3L7wjfn9TcwHqv5LAvX9UGy582GsU/sgISirIsc62syJtGFh5oH67ltocHtf3k81Ryvw1G0dOfuImpn+27oPnV7dlZD58XDxfKeZib1gs6d9wFbohbryN+K5jfYboSw0tpY8/Zqz5nRS87fJS96p4GXwfTwrsKMMspB0ymEMPErLwjh7+MASrTK2G03tsYpUd8U0iCjTwW45vZsmZa89YHhhwPkjTEC9BnKEEWFiUpss5TggM08sEpkBBTx+xRirpuFdUbe1P1M0L1xWXv6PoJSa0ozt2RveKFehczEVhPcl8M/Dij+0qzBFuDb98dMDeHlmWOyMfivC7iHmWtRisVVyaRZt0atjqv0YAZaaf8MeL0rKp6QDITlqCOrddAguFYhnLhuDyl5aJYO+ZHUUhJ+T3NoXYK7wtrBhVrIUtJqtuvMDODYd5YiVhx62iCKEGha/Du7h0x6M7maCbyid+1wjm30pbcxCJDnuwbKUz7/LuUxOnmyX8FdRRfurXzy6565ONq4ODsqtWnx0yrwMuLyC/PqzkL2hkn0KakK31KzrRj/7wg+ZSRcF2t+Q0B8Toch5C9ROCAVBqUDq0TOMtZhN0gQh74/Pjq8G9yojZsw3RhzTdujQ
 roXL9u8H
 ObslVl6UE5KzOP2K86WVfwTmWjrg90+ap7YRRgzYqsM9+WEwu4DM4M2A6X0kX1xiLtZosjCy4ByvQJIT+auDyqjIjc5o5exKCzpfSSA12KC1ISNJkqcB20KgjL4cwRzC1hF0fIuAeTkoLX+n5EipT13Qt2WzIB+yjWCQoIgXtogDc81Tf47zbM3yDEZdHH18mYd5kUmNkUr21CelJ2CUQaWl1aD5lsvFZjA9venK32e6vNqt9kCy+0R1EkGrM532FKCfH3G77ehKxhEs6qQomRAu3uRiR3bqefEO02exwBens86fyNWFBRWu3rWOdVapOj4xjjVxrIdzc/LdWbwIQL6RbNYletE8TYkbOc815xYWbwHHdYzYLWD4I4cRaGT33cudCrho4RiMlFNaJjLjQq+MdzdcfHguR8gESj38qnO/vC6JGtatDY/l3rylUeUycoIVGT+UW/4gXUexdUDDLX+im7Hj6VmJjvUKd6Ec9M/iM4oWpP5U8GqgL23eugBTuPO4oPrtEy0Kd3gwZNJ36cRduENnJEJ3TRmi1LUFu9ESC3Jx+TbNi7UHwrHSdSKthBsAP0Y5ANvmBENEcwUwW7KYDcSosVVmklUi7OJqpTDoUQPEf6OXiHm9zTEi8CqZfIHx7Kr0WxCH3OW6WYoqdlYrrwJrOBvWOW9zFZOW0kmvyAtwtPIz+Fa+sTA==
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
> Reading swap metadata is a common hot path, while swapon and swapoff
> are costly and rare. Convert swap_lock from a spinlock to the
> swapon_rwsem percpu rwsem so metadata readers can run concurrently.
> Writers still serialize topology changes and exclude readers.

So change spinlock to precpu_rwsem lock is straight forward. This
makes lock acquisition very cheap for readers, requiring only a
per-CPU counter change.

>
> Preserve the atomic writable/off-list/available-list transition under
> swap_avail_lock. The device-selection and cluster-allocation paths do
> not yet hold swapon_rwsem; the priority queue patch adds that allocation
> reader protocol.

This seems to describe a lock protocol change. Very naive question:
Where is the matching code for that? I can only see the spinlock to
precpu_rwsem change. Does this description belong to some later
patches or state facts already existing in the current patches where
there is no additional code change for it?

>
> Also update the comments in swap_info_struct to reflect the lock
> name change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  include/linux/swap.h |  10 ++--
>  mm/swapfile.c        | 126 ++++++++++++++++++++++---------------------
>  2 files changed, 69 insertions(+), 67 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0fa77f5679a2..717387e16a2d 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -192,18 +192,18 @@ struct swap_extent {
>   * Swap device flags, except the ones documented below, all are immutabl=
e
>   * after exposed by swap_device_enable, and until the device is freed ag=
ain
>   * (SWP_USED unset), except that teardown clears SWP_ACTIVATED after dra=
ining
> - * allocators and live references. The other exceptions:
> - * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. On=
ce
> + * allocators and live references. The other exceptions use swapon_rwsem=
:
> + * - SWP_USED: Protected by swapon_rwsem. Indicates the device is inuse.=
 Once
>   *   set, won't be cleared unless all reference to this device is freed =
and
>   *   swapoff finished.
> - * - SWP_WRITEOK: Protected by swap_lock, si->lock and swap_avail_lock.
> + * - SWP_WRITEOK: Protected by swapon_rwsem, si->lock and swap_avail_loc=
k.
>   *   Clearing this flag is followed by waiting for all current cluster l=
ock
>   *   users to exit, so
>   *   checking this flag while holding any of these locks ensures the dev=
ice
>   *   is safe to use at the moment. Note: clearing this flag doesn't affe=
ct
>   *   pending IO or async requests, it only prevents further entry alloca=
tion
>   *   or new async request (e.g. discard) from initiating.
> - * - SWP_HIBERNATION: Protected by swap_lock. Indicates if the device
> + * - SWP_HIBERNATION: Protected by swapon_rwsem. Indicates if the device
>   *   is pinned for hibernation.
>   */
>  enum {
> @@ -276,7 +276,7 @@ struct swap_info_struct {
>         spinlock_t lock;                /*
>                                          * Protect cluster lists. Other f=
ields
>                                          * are only changed at swapon/swa=
poff,
> -                                        * so are protected by swap_lock.
> +                                        * so are protected by swapon_rws=
em.
>                                          */
>         struct work_struct discard_work; /* discard worker */
>         struct work_struct reclaim_work; /* reclaim worker */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 56b75770d320..7a97cfd8d009 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -57,23 +57,28 @@ static void move_cluster(struct swap_info_struct *si,
>                          enum swap_cluster_flags new_flags);
>
>  /*
> - * Protects the swap_info array, and the SWP_USED flag. swap_info contai=
ns
> - * lazily allocated & freed swap device info struts, and SWP_USED indica=
tes
> - * which device is used, ~SWP_USED devices and can be reused.
> - *
> - * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK =
flag.
> + * Serializes swapon/swapoff (writers) and protects the swap_info
> + * array, nr_swapfiles, total_swap_pages, and part of swap device
> + * info content (see comment of swap_info_struct). Read-side users
> + * take percpu_down_read() while inspecting this protected state.
> + */
> +DEFINE_STATIC_PERCPU_RWSEM(swapon_rwsem);
> +/*
> + * swap_info contains lazily allocated swap device info structs, and
> + * SWP_USED indicates which device is used, ~SWP_USED devices can be
> + * reused. Protected by swapon_rwsem, but reading could be lockless.
>   */
> -static DEFINE_SPINLOCK(swap_lock);
> +struct swap_info_struct *swap_info[MAX_SWAPFILES];

Ideally we don't move the swap_info[MAX_SWAPFILES]; in the diff, there
is no content change however the diff show the line delete below and
add here.
I wonder if there is a way to forward declare it so we don't need to
move the definition.

>  static unsigned int nr_swapfiles;
> -atomic_long_t nr_swap_pages;
> +long total_swap_pages;
> +
>  /*
>   * Some modules use swappable objects and may try to swap them out under
>   * memory pressure (via the shrinker). Before doing so, they may wish to
>   * check to see if any swap space is available.
>   */
> +atomic_long_t nr_swap_pages;
>  EXPORT_SYMBOL_GPL(nr_swap_pages);
> -/* protected with swap_lock. reading in vm_swap_full() doesn't need lock=
 */
> -long total_swap_pages;

Same here. I am wondering if there is a way to avoid diff move the
total_swap_pages and nr_swap_pages. There is no change to the code,
maybe the definition was just moved.

Chris

>  #define DEF_SWAP_PRIO  -1
>  unsigned long swapfile_maximum_size;
>  #ifdef CONFIG_MIGRATION
> @@ -85,7 +90,7 @@ static const char Bad_offset[] =3D "Bad swap offset ent=
ry ";
>
>  /*
>   * all active swap_info_structs
> - * protected with swap_lock, and ordered by priority.
> + * protected with swapon_rwsem, and ordered by priority.
>   */
>  static PLIST_HEAD(swap_active_head);
>
> @@ -95,20 +100,18 @@ static PLIST_HEAD(swap_active_head);
>   * This is used by folio_alloc_swap() instead of swap_active_head
>   * because swap_active_head includes all swap_info_structs,
>   * but folio_alloc_swap() doesn't need to look at full ones.
> - * This uses its own lock instead of swap_lock because when a
> + * This uses its own lock instead of swapon_rwsem because when a
>   * swap_info_struct changes between not-full/full, it needs to
>   * add/remove itself to/from this list, but the swap_info_struct->lock
> - * is held and the locking order requires swap_lock to be taken
> + * is held and the locking order requires swapon_rwsem to be taken
>   * before any swap_info_struct->lock.
>   */
>  static PLIST_HEAD(swap_avail_head);
>  static DEFINE_SPINLOCK(swap_avail_lock);
>
> -struct swap_info_struct *swap_info[MAX_SWAPFILES];
> -
>  static inline struct swap_info_struct *__swap_iter(int *i, unsigned long=
 flag)
>  {
> -       lockdep_assert_held(&swap_lock);
> +       lockdep_assert_held(&swapon_rwsem);
>         while (*i < nr_swapfiles) {
>                 struct swap_info_struct *si =3D __swap_type_to_info(*i);
>
> @@ -128,7 +131,7 @@ static inline struct swap_info_struct *__swap_iter(in=
t *i, unsigned long flag)
>   * for_each_swap_info - iterate over all allocated swap descriptors
>   * @si: the iterator
>   *
> - * Context: The caller must hold swap_lock. The lock may be dropped duri=
ng
> + * Context: The caller must hold swapon_rwsem. The lock may be dropped d=
uring
>   * the loop body but must be re-acquired before the next iteration.
>   */
>  #define for_each_swap_info(si) __for_each_swap(si, 0)
> @@ -1309,7 +1312,7 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>                                              pages | SWAP_USAGE_OFFLIST_B=
IT))
>                         goto skip;
>         } else {
> -               lockdep_assert_held(&swap_lock);
> +               lockdep_assert_held_write(&swapon_rwsem);
>                 lockdep_assert_held(&si->lock);
>                 si->flags &=3D ~SWP_WRITEOK;
>                 atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
> @@ -1441,10 +1444,10 @@ static bool get_swap_device_info(struct swap_info=
_struct *si)
>         /*
>          * Guarantee the si->users are checked before accessing other
>          * fields of swap_info_struct, and si->flags (SWP_WRITEOK) is
> -        * up to dated.
> +        * up to date.
>          *
> -        * Paired with the spin_unlock() after setup_swap_info() in
> -        * swap_device_enable(), and smp_wmb() in swapoff.
> +        * Paired with percpu_up_write() in swap_device_enable(), and
> +        * smp_wmb() after clearing SWP_WRITEOK in swapoff.
>          */
>         smp_rmb();
>         return true;
> @@ -1529,10 +1532,10 @@ static bool swap_sync_discard(void)
>         bool ret =3D false;
>         struct swap_info_struct *si, *next;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_read(&swapon_rwsem);
>  start_over:
>         plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> -               spin_unlock(&swap_lock);
> +               percpu_up_read(&swapon_rwsem);
>                 if (get_swap_device_info(si)) {
>                         if (si->flags & SWP_PAGE_DISCARD)
>                                 ret =3D swap_do_scheduled_discard(si);
> @@ -1541,11 +1544,11 @@ static bool swap_sync_discard(void)
>                 if (ret)
>                         return true;
>
> -               spin_lock(&swap_lock);
> +               percpu_down_read(&swapon_rwsem);
>                 if (plist_node_empty(&next->list))
>                         goto start_over;
>         }
> -       spin_unlock(&swap_lock);
> +       percpu_up_read(&swapon_rwsem);
>
>         return false;
>  }
> @@ -2349,7 +2352,7 @@ int pin_hibernation_swap_type(dev_t device, sector_=
t offset)
>         int ret;
>         struct swap_info_struct *si;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_write(&swapon_rwsem);
>         ret =3D __find_hibernation_swap_type(device, offset);
>         if (ret < 0)
>                 goto out;
> @@ -2373,7 +2376,7 @@ int pin_hibernation_swap_type(dev_t device, sector_=
t offset)
>         si->flags |=3D SWP_HIBERNATION;
>
>  out:
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>         return ret;
>  }
>
> @@ -2385,7 +2388,7 @@ int pin_hibernation_swap_type(dev_t device, sector_=
t offset)
>   *
>   * Look up the swap device for @device/@offset and atomically transfer
>   * the SWP_HIBERNATION pin from @old_type (if valid) to the new device,
> - * all under a single swap_lock critical section. This closes the
> + * all under a single swapon_rwsem writer section. This closes the
>   * swapoff() window that exists when callers unpin and re-pin in two
>   * separate operations.
>   *
> @@ -2405,28 +2408,28 @@ int repin_hibernation_swap_type(int old_type, dev=
_t device, sector_t offset)
>         struct swap_info_struct *old_si, *new_si;
>         int new_type;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_write(&swapon_rwsem);
>
>         new_type =3D __find_hibernation_swap_type(device, offset);
>         if (new_type < 0) {
> -               spin_unlock(&swap_lock);
> +               percpu_up_write(&swapon_rwsem);
>                 return new_type;
>         }
>
>         new_si =3D swap_type_to_info(new_type);
>         if (WARN_ON_ONCE(!new_si)) {
> -               spin_unlock(&swap_lock);
> +               percpu_up_write(&swapon_rwsem);
>                 return -ENODEV;
>         }
>
>         old_si =3D swap_type_to_info(old_type);
>         if (new_si =3D=3D old_si) {
> -               spin_unlock(&swap_lock);
> +               percpu_up_write(&swapon_rwsem);
>                 return new_type;
>         }
>
>         if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
> -               spin_unlock(&swap_lock);
> +               percpu_up_write(&swapon_rwsem);
>                 return -EBUSY;
>         }
>
> @@ -2434,7 +2437,7 @@ int repin_hibernation_swap_type(int old_type, dev_t=
 device, sector_t offset)
>                 old_si->flags &=3D ~SWP_HIBERNATION;
>         new_si->flags |=3D SWP_HIBERNATION;
>
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>         return new_type;
>  }
>
> @@ -2452,11 +2455,11 @@ void unpin_hibernation_swap_type(int type)
>  {
>         struct swap_info_struct *si;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_write(&swapon_rwsem);
>         si =3D swap_type_to_info(type);
>         if (si)
>                 si->flags &=3D ~SWP_HIBERNATION;
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>  }
>
>  /**
> @@ -2481,9 +2484,9 @@ int find_hibernation_swap_type(dev_t device, sector=
_t offset)
>  {
>         int type;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_read(&swapon_rwsem);
>         type =3D __find_hibernation_swap_type(device, offset);
> -       spin_unlock(&swap_lock);
> +       percpu_up_read(&swapon_rwsem);
>
>         return type;
>  }
> @@ -2493,13 +2496,13 @@ int find_first_swap(dev_t *device)
>         int ret =3D -ENODEV;
>         struct swap_info_struct *si;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_read(&swapon_rwsem);
>         for_each_avail_swap(si) {
>                 *device =3D si->bdev->bd_dev;
>                 ret =3D si->type;
>                 break;
>         }
> -       spin_unlock(&swap_lock);
> +       percpu_up_read(&swapon_rwsem);
>         return ret;
>  }
>
> @@ -2528,7 +2531,7 @@ unsigned int count_swap_pages(int type, int free)
>  {
>         unsigned int n =3D 0;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_read(&swapon_rwsem);
>         if ((unsigned int)type < nr_swapfiles) {
>                 struct swap_info_struct *sis =3D swap_info[type];
>
> @@ -2540,7 +2543,7 @@ unsigned int count_swap_pages(int type, int free)
>                 }
>                 spin_unlock(&sis->lock);
>         }
> -       spin_unlock(&swap_lock);
> +       percpu_up_read(&swapon_rwsem);
>         return n;
>  }
>  #endif /* CONFIG_HIBERNATION */
> @@ -2866,10 +2869,10 @@ static unsigned int find_next_to_unuse(struct swa=
p_info_struct *si,
>         unsigned long swp_tb;
>
>         /*
> -        * No need for swap_lock here: we're just looking
> +        * No need for swapon_rwsem here: we're just looking
>          * for whether an entry is in use, not modifying it; false
>          * hits are okay, and sys_swapoff() has already prevented new
> -        * allocations from this area (while holding swap_lock).
> +        * allocations from this area (while holding swapon_rwsem).
>          */
>         i =3D prev + 1;
>         while (i < si->max) {
> @@ -3007,8 +3010,8 @@ static int try_to_unuse(unsigned int type)
>
>  /*
>   * After a successful try_to_unuse, if no swap is now in use, we know
> - * we can empty the mmlist.  swap_lock must be held on entry and exit.
> - * Note that mmlist_lock nests inside swap_lock, and an mm must be
> + * we can empty the mmlist. swapon_rwsem must be held on entry and exit.
> + * Note that mmlist_lock nests inside swapon_rwsem, and an mm must be
>   * added to the mmlist just after page_duplicate - before would be racy.
>   */
>  static void drain_mmlist(void)
> @@ -3160,8 +3163,7 @@ static int setup_swap_extents(struct swap_info_stru=
ct *sis,
>   */
>  static void swap_device_enable(struct swap_info_struct *si)
>  {
> -       spin_lock(&swap_lock);
> -
> +       percpu_down_write(&swapon_rwsem);
>         spin_lock(&si->lock);
>         spin_lock(&swap_avail_lock);
>         si->flags |=3D SWP_WRITEOK;
> @@ -3171,7 +3173,7 @@ static void swap_device_enable(struct swap_info_str=
uct *si)
>         atomic_long_add(si->pages, &nr_swap_pages);
>         total_swap_pages +=3D si->pages;
>         plist_add(&si->list, &swap_active_head);
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>
>         add_to_avail_list(si);
>  }
> @@ -3184,7 +3186,7 @@ static int swap_device_disable(struct address_space=
 *mapping,
>         unsigned long offset, end;
>         int err =3D -EINVAL;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_write(&swapon_rwsem);
>         plist_for_each_entry(si, &swap_active_head, list) {
>                 if ((si->flags & SWP_WRITEOK) &&
>                     si->swap_file->f_mapping =3D=3D mapping) {
> @@ -3220,12 +3222,12 @@ static int swap_device_disable(struct address_spa=
ce *mapping,
>
>         end =3D ALIGN(si->max, SWAPFILE_CLUSTER);
>  unlock:
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>         if (err)
>                 return err;
>
>         /*
> -        * The swap allocator doesn't take swap_lock. Looping through eve=
ry
> +        * The swap allocator doesn't take swapon_rwsem. Looping through =
every
>          * cluster lock after clearing SWP_WRITEOK ensures that allocator=
s see
>          * the updated flag and that no allocation remains in flight.
>          */
> @@ -3339,7 +3341,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>                 atomic_dec(&nr_rotate_swap);
>
>         mutex_lock(&swapon_mutex);
> -       spin_lock(&swap_lock);
> +       percpu_down_write(&swapon_rwsem);
>         spin_lock(&p->lock);
>         drain_mmlist();
>
> @@ -3350,7 +3352,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         p->max =3D 0;
>         p->cluster_info =3D NULL;
>         spin_unlock(&p->lock);
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>         arch_swap_invalidate_area(p->type);
>         zswap_swapoff(p->type);
>         mutex_unlock(&swapon_mutex);
> @@ -3370,9 +3372,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>          * can reuse this swap_info in alloc_swap_info() safely.  It is o=
k to
>          * not hold p->lock after we cleared its SWP_WRITEOK.
>          */
> -       spin_lock(&swap_lock);
> +       percpu_down_write(&swapon_rwsem);
>         p->flags =3D 0;
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>
>         atomic_inc(&proc_poll_event);
>         wake_up_interruptible(&proc_poll_wait);
> @@ -3532,13 +3534,13 @@ static struct swap_info_struct *alloc_swap_info(v=
oid)
>                 return ERR_PTR(-ENOMEM);
>         }
>
> -       spin_lock(&swap_lock);
> +       percpu_down_write(&swapon_rwsem);
>         for (type =3D 0; type < nr_swapfiles; type++) {
>                 if (!(swap_info[type]->flags & SWP_USED))
>                         break;
>         }
>         if (type >=3D MAX_SWAPFILES) {
> -               spin_unlock(&swap_lock);
> +               percpu_up_write(&swapon_rwsem);
>                 percpu_ref_exit(&p->users);
>                 kvfree(p);
>                 return ERR_PTR(-EPERM);
> @@ -3563,7 +3565,7 @@ static struct swap_info_struct *alloc_swap_info(voi=
d)
>         plist_node_init(&p->list, 0);
>         plist_node_init(&p->avail_list, 0);
>         p->flags =3D SWP_USED;
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>         if (defer) {
>                 percpu_ref_exit(&defer->users);
>                 kvfree(defer);
> @@ -3999,9 +4001,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>          * Clear the SWP_USED flag after all resources are freed so
>          * alloc_swap_info can reuse this si safely.
>          */
> -       spin_lock(&swap_lock);
> +       percpu_down_write(&swapon_rwsem);
>         si->flags =3D 0;
> -       spin_unlock(&swap_lock);
> +       percpu_up_write(&swapon_rwsem);
>         if (inced_nr_rotate_swap)
>                 atomic_dec(&nr_rotate_swap);
>         if (swap_file)
> @@ -4019,7 +4021,7 @@ void si_swapinfo(struct sysinfo *val)
>         struct swap_info_struct *si;
>         unsigned long nr_to_be_unused =3D 0;
>
> -       spin_lock(&swap_lock);
> +       percpu_down_read(&swapon_rwsem);
>         for_each_swap_info(si) {
>                 unsigned long flags =3D READ_ONCE(si->flags);
>
> @@ -4028,7 +4030,7 @@ void si_swapinfo(struct sysinfo *val)
>         }
>         val->freeswap =3D atomic_long_read(&nr_swap_pages) + nr_to_be_unu=
sed;
>         val->totalswap =3D total_swap_pages + nr_to_be_unused;
> -       spin_unlock(&swap_lock);
> +       percpu_up_read(&swapon_rwsem);
>  }
>
>  /*

