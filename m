Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CAF606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2vg+II4
Received: by kanga.kvack.org (Postfix)
	id 198196B05B5; Thu, 26 Nov 2026 13:18:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1702D6B05B6; Thu, 26 Nov 2026 13:18:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037F26B05B8; Thu, 26 Nov 2026 13:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C609A6B05B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:18:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F808C0280
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:18:03 +0000 (UTC)
X-FDA: 85478079246.16.83A26CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 92B9780011
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:17:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2vg+II4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795717079;
	b=552vheR2kYsGQTO6qApzcH3/n7SKuvT8rpbrxwNe3pKBF/Hvo10doG0KkV4XFbHG9XsJDZ
	fJgty/2vIQZ7852m/MPBC4iKoiU7zb6jsuAGO2AmS7OnAG6L1oI3XRsqqu//jZuKeBRiiF
	3Dqj+XZQWsc9zbcFtDCBOa9EFUa5WyI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795717079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LyHnWvI1U1dvvPzbvZuUKBs+ym49gt0CX1mtWx4Tu8=;
	b=ZSolOz3/8TbBVBEiK8McZjWq6V99x8tkqCEF/lo+EBcZHLmYZvk9Bu9M9VJWVD/qK3MIqo
	sx5vh/O1fywdqJ1haspIaphH7igdw9BJkRDKSfnEG/E0WiXg8M2Llw3R35N3naM67LhTe1
	wec1rMRatX/SmJc/qQjnQFQYfn7U77g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2vg+II4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2A41457B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9EB1F000E0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795717078;
	bh=1LyHnWvI1U1dvvPzbvZuUKBs+ym49gt0CX1mtWx4Tu8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=E2vg+II4Iws96C4RRS1HLB+uyZxXg1QiKkPdqH/eQrO/elF6O03rxw0VQk87DjrVH
	 eSWoKhp8VSKe1WAxGd0K6IFJXWnmAJWZ7WUtNDkkCIRcRmP96hP4i+bIHz49ra9a6L
	 n9eD3wvzTN4/6YHXkjpcV6B0O8OTVmUumnnfJAXnMcr67/kQZEqzbBmPRT1/ikF/51
	 0EkG4dbUfN5unJh/Ud3zZ6UC1Tw0fGNhw/sQfnc4vdzUVrLM+5Qfd7+Y/+DY8RzTJU
	 6smhiWzLS6C6KnD7GAgEAyNrP5Y7A6pE5vt4MrB8bTV/pvXr3kgU7fXecLQ+3L4bAi
	 6X9F1tY2Ul0bg==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b894d9a075so8103026a12.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:17:58 -0800 (PST)
X-Gm-Message-State: APuU4Z8gfjdJpZjTirIDgoMC2rqPrjN92rj1hywImZmPAnPc/jq7z87Q
	Zrsod+le9V2iiKpsyIfbCJ/UKn5ngudUJh7H46/8uDkC8oxVpbC6jLWZ8UPdhbQ7SbkaEn30h1a
	6QrDEJva5lHrKhndBClAQNrqN8D2xK0GjVVg9fCI2vQ==
X-Received: by 2002:a05:6402:280e:b0:6b7:d55:87d3 with SMTP id
 4fb4d7f45d1cf-6ba37ea7696mr14339449a12.36.1795717076996; Thu, 26 Nov 2026
 10:17:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <030796dcb2086484f87e2250d9cf9a04fccf54ab.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <030796dcb2086484f87e2250d9cf9a04fccf54ab.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Nov 2026 10:17:44 -0800
X-Gmail-Original-Message-ID: <CACePvbUYHBD+To2CGe9b5_zWbYVrYU6Mv-pxzhXEgB7r1DJrdg@mail.gmail.com>
X-Gm-Features: Aa3M54oD-0dMzQJxnqWDxuLcGd-2CJBzn2u3HBeQDpt3cEKIGogR7eta0L74Lhk
Message-ID: <CACePvbUYHBD+To2CGe9b5_zWbYVrYU6Mv-pxzhXEgB7r1DJrdg@mail.gmail.com>
Subject: Re: [PATCH v5 06/19] mm/swap: serialize swap publication before
 removing swapon mutex
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
X-Stat-Signature: cazpymupndb765pdjc7xrecdgzm4h1xq
X-Rspamd-Queue-Id: 92B9780011
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795717079-301784
X-HE-Meta: U2FsdGVkX1+yoGo6XBSPgLeXjVJSqKKXonhnZ4D0s8qMsZlrJQPFJqGH4ArBEWDLasiGWwBnzKSo8vcLQo91zu/DJA7BETT7MNh0zNbN3s5Rfk0MoN3jx868MM1IN8yLHovHUVeblRCiUF8Z5oD1YXSDAR99hBDdzvpICGrnGW4MLDJn8dD6M/Q5zfErCp9x+3t0wbkk17NWb0cgvBwZNNAT8Uk6wkmtQMtYaaYcNkrJ8bALkwmB+S53Qt4j2VjDDZNAbW89oAFqfuLpnjLi6ni9wpUQieg34y3UsJjvmIXXE+F9goXZP+1blvy300PZunlpSRBel8vZzlrQ+eTeQI44oeqE87xRpQSrUI+8KLC2zgol82ITjJs9NVq2X6ylFdxPlIMqaDlEpvcZ9Y79CYwF/ZYBhO3OibJJgLml1zLS4GAZGCh5hbUg5ctBecfAESVT3UKED0UKj5xT6s6/1eQCw8FF9BuRCT+XSSDKFcMiFSVuvcEkB1/EqRJ3p9ip124O35FcEoLQRXkRLEK56CVRkZxPn/gmZKPhk4vaOapEclcHcxDaeSC8dJal9fwKZbW6z82CEgLvQVp7LuyKb72b8A/JzKPZ4y/TbM3mCh4ZQVReCt7QQKDQ9rA8ziYUA5AUMb/ZVIBK0u0SW0YAa3I7H59NtMMyVfUBXD7pp3ymwe1yqCfFB7RYsvVcY1a4h3iKKhG/KRaauY3nxztu1t7Zy7iBx8e+4+1woTcF69wpHM4TsP6+pPwxIFVoNKM4pFALG5L5qTHUCeM4kzIVv1fB5ccqAoLyI6HUtoh1DXdwyOYAClk0UNc6eu9WXx6OL5asnABVG58irRWw29ffnLnCVa5Y/C2UMeK05SArhHnc6y521rvi/MSdqFp/EEQaJgITP/N0jjzZJFhdFEm50S6MB77D8R6DnHGUu+9OxhPsVH356n5RwKLsCDnG6l1cUtYdqbtwKJbmt9VnVx1
 iat7r3Rv
 gIqpEKwVUptanigxqIXebIRre6VCOHGCm1C70n/ZMsGCSxoULUAer8tTbzc0R8WZI2maVa3EOvj4KaoWWHMbp0rLRehwL6qeKzhHuCkrE1PmjTsnHfQWrqTXcITgQZLz5jCAh7xrlqnOm19wDE3UgPqeC1ZreO4IXOIJiRlwJgiaUjbTShR2twgAj4iOnVQftL8ha6WAL8y/+j0KNJ+bKe+ovBstua8ll4YWobaAcoLNwFg5d5feHWrr/gpiNtChKmoge6DS0U2vFrpqS4rzdQXLk6fi8J2rpWv1wkV/ElfP2QEx5klc968YdMCZZhLuQ+JerBaLth0Qg6b2wyPvsOoc4NrRtkPzmP2Ym3qf2ZR+Kst6Q5XERp5M6xEorqSW3VF+KQjh9QN57s4onoGVllbE4qPYtl02tYxgZZdqo4YbngyA3nRJXJHUwxhfraPuu/yM3jHj/jjIRXIlK0e8V4Yj2ag/SncMoIXXaERt1qw/Q0MN7UJV94gPNz2lZNjV8J5uYwXYegviFte8B5pCSiQbegdgYuoJLsjuLE/JnUSnx5aegpIfBvb9GiQ==
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
> Move publication of swap_file, resurrection of the device reference and
> the writable transition into one swapon_rwsem writer section. Split out

For helping the reader, we can add what are the previous lock
protecting those data structure and what is the new locking protocol
required. That helps paint the full picture of what lock protocol
changed. Currently, this only describes the new lock behavior.

> a writer-held enable helper so initial publication can share this
> section, while failed swapoff can use the locking wrapper.
>
> With file publication and teardown serialized by the writer, remove
> swapon_mutex and use a topology reader across /proc/swaps iteration.
> Only expose entries with a published swap_file. Other bits in flags
> can already change during device setup, before publication.

The current commit message describes what changed. This is the most
critical part of the locking change in this series; it deserves a
better description of why this new locking protocol is safe to use.
This can help me reason about the new locking protocol.

>
> The publication boundary excludes proc readers from partially published
> state and gives the lockless live-reference users initialized device
> metadata before the device becomes an allocation candidate.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 7a97cfd8d009..24f301ef4e3a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -139,9 +139,6 @@ static inline struct swap_info_struct *__swap_iter(in=
t *i, unsigned long flag)
>
>  static struct kmem_cache *swap_table_cachep;
>
> -/* Protects si->swap_file for /proc/swaps usage */
> -static DEFINE_MUTEX(swapon_mutex);
> -
>  static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
>  /* Activity counter to indicate that a swapon or swapoff has occurred */
>  static atomic_t proc_poll_event =3D ATOMIC_INIT(0);
> @@ -3161,9 +3158,9 @@ static int setup_swap_extents(struct swap_info_stru=
ct *sis,
>   * Mark a fully initialized swap device writable and expose it to the
>   * allocator. The caller must have resurrected its percpu ref first.
>   */
> -static void swap_device_enable(struct swap_info_struct *si)
> +static void __swap_device_enable(struct swap_info_struct *si)

The function name can reflect that it is locked. Maybe
__swap_device_enable_locked()

Over all the patch is straight forward combine the swapon_mutex into
swapon_rwsem. I need some time to process that why it is safe.

Chris

>  {
> -       percpu_down_write(&swapon_rwsem);
> +       lockdep_assert_held_write(&swapon_rwsem);
>         spin_lock(&si->lock);
>         spin_lock(&swap_avail_lock);
>         si->flags |=3D SWP_WRITEOK;
> @@ -3173,11 +3170,16 @@ static void swap_device_enable(struct swap_info_s=
truct *si)
>         atomic_long_add(si->pages, &nr_swap_pages);
>         total_swap_pages +=3D si->pages;
>         plist_add(&si->list, &swap_active_head);
> -       percpu_up_write(&swapon_rwsem);
> -
>         add_to_avail_list(si);
>  }
>
> +static void swap_device_enable(struct swap_info_struct *si)
> +{
> +       percpu_down_write(&swapon_rwsem);
> +       __swap_device_enable(si);
> +       percpu_up_write(&swapon_rwsem);
> +}
> +
>  static int swap_device_disable(struct address_space *mapping,
>                                struct swap_info_struct **swap_info)
>  {
> @@ -3340,7 +3342,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         if (!(p->flags & SWP_SOLIDSTATE))
>                 atomic_dec(&nr_rotate_swap);
>
> -       mutex_lock(&swapon_mutex);
>         percpu_down_write(&swapon_rwsem);
>         spin_lock(&p->lock);
>         drain_mmlist();
> @@ -3355,7 +3356,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         percpu_up_write(&swapon_rwsem);
>         arch_swap_invalidate_area(p->type);
>         zswap_swapoff(p->type);
> -       mutex_unlock(&swapon_mutex);
>         kfree(p->global_cluster);
>         p->global_cluster =3D NULL;
>         free_swap_cluster_info(cluster_info, maxpages);
> @@ -3397,20 +3397,18 @@ static __poll_t swaps_poll(struct file *file, pol=
l_table *wait)
>         return EPOLLIN | EPOLLRDNORM;
>  }
>
> -/* iterator */
>  static void *swap_start(struct seq_file *swap, loff_t *pos)
>  {
>         struct swap_info_struct *si;
> -       int type;
>         loff_t l =3D *pos;
>
> -       mutex_lock(&swapon_mutex);
> +       percpu_down_read(&swapon_rwsem);
>
>         if (!l)
>                 return SEQ_START_TOKEN;
>
> -       for (type =3D 0; (si =3D swap_type_to_info(type)); type++) {
> -               if (!(si->swap_file))
> +       for_each_swap_info(si) {
> +               if (!si->swap_file)
>                         continue;
>                 if (!--l)
>                         return si;
> @@ -3431,7 +3429,7 @@ static void *swap_next(struct seq_file *swap, void =
*v, loff_t *pos)
>
>         ++(*pos);
>         for (; (si =3D swap_type_to_info(type)); type++) {
> -               if (!(si->swap_file))
> +               if (!si->swap_file)
>                         continue;
>                 return si;
>         }
> @@ -3441,7 +3439,7 @@ static void *swap_next(struct seq_file *swap, void =
*v, loff_t *pos)
>
>  static void swap_stop(struct seq_file *swap, void *v)
>  {
> -       mutex_unlock(&swapon_mutex);
> +       percpu_up_read(&swapon_rwsem);
>  }
>
>  static int swap_show(struct seq_file *swap, void *v)
> @@ -3954,7 +3952,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>                 goto free_swap_zswap;
>         }
>
> -       mutex_lock(&swapon_mutex);
>         prio =3D DEF_SWAP_PRIO;
>         if (swap_flags & SWAP_FLAG_PREFER)
>                 prio =3D swap_flags & SWAP_FLAG_PRIO_MASK;
> @@ -3966,11 +3963,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>         si->prio =3D prio;
>         si->list.prio =3D -si->prio;
>         si->avail_list.prio =3D -si->prio;
> +       /* Publish the file, live reference and writable state together. =
*/
> +       percpu_down_write(&swapon_rwsem);
>         si->swap_file =3D swap_file;
>
> -       /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap de=
vice */
> +       /* Make the reference live before exposing the writable device. *=
/
>         percpu_ref_resurrect(&si->users);
> -       swap_device_enable(si);
> +       __swap_device_enable(si);
> +       percpu_up_write(&swapon_rwsem);
>
>         pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%=
lluk %s%s%s%s\n",
>                 K((unsigned long)si->pages), name->name, si->prio, nr_ext=
ents,
> @@ -3980,7 +3980,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>                 (si->flags & SWP_AREA_DISCARD) ? "s" : "",
>                 (si->flags & SWP_PAGE_DISCARD) ? "c" : "");
>
> -       mutex_unlock(&swapon_mutex);
>         atomic_inc(&proc_poll_event);
>         wake_up_interruptible(&proc_poll_wait);
>

