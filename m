Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD1560A2600
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fCYWv8Zc
Received: by kanga.kvack.org (Postfix)
	id 3BEB46B070C; Thu, 19 Nov 2026 23:30:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F026B0740; Thu, 19 Nov 2026 23:30:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283DF6B075D; Thu, 19 Nov 2026 23:30:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCBFA6B070C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:30:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 526991C4820
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:30:21 +0000 (UTC)
X-FDA: 85454220642.24.A07D9C4
Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	by imf30.hostedemail.com (Postfix) with ESMTP id 24F4580008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:30:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fCYWv8Zc;
	spf=pass (imf30.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149019;
	b=hZJW5UhTFmccIxFqruZXRde/XuuKQVD0h0xYWBOwadTf0mwu2IYTU7DS8BG6rmIxYwWhWr
	byJ1fkoANTZzaRN/1mJBrHqWjn6nJ2YCpiSc+Zgu0vltGHJ6f0SsCsQvK0dr30T0UWwGg2
	ZO+y9N4Ab6OHiIJoFq7JsJp5fRpeSjc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roL0FQDRW/fqTvKyUOnLi52ZhKE+0i4/LlevVoVyflc=;
	b=xadV8aH+vucK3DVom2wKSwh1BQLIo+TWgSdmCyyy4BpU5PzqbzuJ8rrSBemQtGkm9DKAzI
	aKbtk9SMfWBLV4uVjlOF+Ivd5AuHRMKbBfFYEuh33OsWjvkdlzAiXNaAf20G+Oo3RS/3yt
	G5REHBGY8NQ0VmxSmILn5KQtRtBd0Uc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fCYWv8Zc;
	spf=pass (imf30.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YW3SrjZDBSs+f8ut+cA/sj4nFs4B9HPB8O+mdX/NYzA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149017; v=1; x=1795753817;
 b=fCYWv8Zc5HAcmbnJoo9+/FUO1cYouGdwqqa9D7Td6F4gQLCuDYssjXco7Tlh9YiFafKsZ3Wq
 dQpSKrUwoPfJH4E5YM9TwBlwXIPy7Fzx1xGTeiyPQNRksKbkzUzLyiBiIcKcynK5Eo3u5NBaG7b
 d20c2nMlylTyk1HQYtibuGE0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id def76d0e62afee0d;
	Fri, 20 Nov 2026 04:30:17 +0000
X-Mizu-Trace-ID: def76d0e62afee0d
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:30:16 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <f9cbc65ebeda9ebbc71c0488bb7df016f5c34961@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 06/18] mm/swap: serialize swap publication before
 removing swapon mutex
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org,
 kunwu.chan@gmail.com
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <ed10255256780c856689549e65654f8b01d40c2e.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <ed10255256780c856689549e65654f8b01d40c2e.1794666741.git.lianux.mm@gmail.com>
X-Stat-Signature: oegchhuwwoww96tx36wmorqdej1azjf7
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24F4580008
X-HE-Tag: 1795149018-898904
X-HE-Meta: U2FsdGVkX18z7bdAvpTj2sr2L6NuVCdqWquGZzj4T8QqhvJk4SGoU/SoUpm0Vd4j2nHHkiSD9rcHuyGJr7kqdV3Ls8zLFNukUP8LU9+wI+5Gv70ssI1WEIEiD2GKLhI0ffkxydpIaIvWWTFHC6bNdoo8yViiBcxqJKkVoQz0n/xLAoKHjGkauWeG/Pu3fR7PB5RiCv7GVCjuPvNIoaeWUe5THWow9lDJIyf31rqM2xiNgApJv7TJ6WLFLKXjdMhLJvyJgdLW6kaetbxW9i9oiI3wCrLr1RpGJMFq95CKwJWdxgxbMwJ5D0AetE2UnYjUyXcWdBLXToBlk7x6gTyJaEnvyFaZwVqtww84ZfrwljjiWdsmzCDS79GlKEqIc3VTrf+Ma+eW0DMYlFeCtUIMfzB46H6QQim+Q7YXkXo2R7satgq6DcIIkZuEhnwZvooBxdxWmgEL4C5VuTp9DcWezziTtjToeR6Cl7vPqgUJ4bXPQhRG9vhFnKB4fUZ987LuBwwUI+/UThsoizX7/SDy7N4L1Cm1PqpQIL0DCYzGhPYYVv96R+z52bb6ebga0ibvtg0a01WjDK0TlovNi7BqHiR7Xpn1WnQjG+GQp5OzEMhWxGfHV/Ecw+1bxGC8Ox+WHl3qrwMQrEhXeBEkYGNaKGFS5rJ2i6tx3rz7l4hg+JRJUmj40xUjGJyDh0SBKtjpesP6qKn10XICP9e2FdJcXTcH8RcQ13M8UWG0Sr/xK7Q/W7mCaFnmXnSeIpNzAtNM/Qh+cYJmpgk1Fv3XFa+d775m0UxUOG1ZVOt60krp2vfbfD/uJp/p1e7WWfmbJSPHsTHo3ZZ99kFPVrAvrrbF3a7zsixPWMhpRdOPJY6vM6hy7IDUkbiT4kSebJHCjPf2gjFoDCsPGeNu1B+MfOkJdHCoobTVxQQ/sMAMiwgWDPkhZnvfcqLkc1WvMexUcdaKlj63B8sE/HcpVcOgTEO
 Plma0gfz
 +Wz9Kc+dMKUHqfsou/vcKzfUiz+4zaFktdcDv7xCWKQdHHxWW5dCY7IrpvOvEUFa1ZlPF3wvB/D9pF9Lv0WJlXJZVsvmU1OlfbSbJma9xJGNixlSHoPMIMpNsVMolNKzQTeEC07jbLVN+2B4ClLqPuIsFDa0T2sJ0QD8AJRZLeqqVDEW7FwWQPhdxqegbhNaXunE5A6E7cxEKOKGOjqAlC07apvRazbBEIUWhU+za1zlYnnMCWONHG6IHgLEUIoZBzqHI6v+MB4csaGewUuFTCpRpVrhPM+bqW6yByEmTSIzdGTaWK73X7zVZJpGtejub1aVR1Ssos2LWtY+nXQH23j/A6r3KDRL1WR4vpMU9Pcs0nTkyrxO5p/XdJr/sZugUygUfWyQEwGRLJIXWGIfP3HbXON7Feu5KQyKpdAeYXEKdyY/WoYKfqILIZ7kEubYW0UGoUjabfFfNNb0m0MdloNoWSFJbVEVNjYlb7ZCEnYMhftOWZwzuJEDQ2hV2mSKpKeD655iMFbdEPBVMC/LQV4i4Qp06TJ64JnPK95UZjPOh7qkCSHiqzUqM5O3LB5drfbMpzuNXELrcvEK5kdXfpoUhMQmhoSZLgMpE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>=20
>=20From: Kairui Song <kasong@tencent.com>
>=20
>=20Move publication of swap_file, resurrection of the device reference a=
nd
> the writable transition into one swapon_rwsem writer section. Split out
> a writer-held enable helper so initial publication can share this
> section, while failed swapoff can use the locking wrapper.
>=20
>=20With file publication and teardown serialized by the writer, remove
> swapon_mutex and use a topology reader across /proc/swaps iteration.
> Keep the SWP_USED filter when advancing the swap_info array.
>=20
>=20The publication boundary excludes proc readers from partially publish=
ed
> state and gives the lockless live-reference users initialized device
> metadata before the device becomes an allocation candidate.
>=20
>=20Signed-off-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index ae8421e18448..277a5c749987 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -139,9 +139,6 @@ static inline struct swap_info_struct *__swap_iter(=
int *i, unsigned long flag)
>=20=20
>=20 static struct kmem_cache *swap_table_cachep;
>=20=20
>=20-/* Protects si->swap_file for /proc/swaps usage */
> -static DEFINE_MUTEX(swapon_mutex);
> -
>  static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
>  /* Activity counter to indicate that a swapon or swapoff has occurred =
*/
>  static atomic_t proc_poll_event =3D ATOMIC_INIT(0);
> @@ -3161,9 +3158,9 @@ static int setup_swap_extents(struct swap_info_st=
ruct *sis,
>  * Mark a fully initialized swap device writable and expose it to the
>  * allocator. The caller must have resurrected its percpu ref first.
>  */
> -static void swap_device_enable(struct swap_info_struct *si)
> +static void __swap_device_enable(struct swap_info_struct *si)
>  {
> - percpu_down_write(&swapon_rwsem);
> + lockdep_assert_held_write(&swapon_rwsem);
>  spin_lock(&si->lock);
>  spin_lock(&swap_avail_lock);
>  si->flags |=3D SWP_WRITEOK;
> @@ -3173,11 +3170,16 @@ static void swap_device_enable(struct swap_info=
_struct *si)
>  atomic_long_add(si->pages, &nr_swap_pages);
>  total_swap_pages +=3D si->pages;
>  plist_add(&si->list, &swap_active_head);
> - percpu_up_write(&swapon_rwsem);
> -
>  add_to_avail_list(si);
>  }
>=20=20
>=20+static void swap_device_enable(struct swap_info_struct *si)
> +{
> + percpu_down_write(&swapon_rwsem);
> + __swap_device_enable(si);
> + percpu_up_write(&swapon_rwsem);
> +}
> +
>  static int swap_device_disable(struct address_space *mapping,
>  struct swap_info_struct **swap_info)
>  {
> @@ -3340,7 +3342,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
>  if (!(p->flags & SWP_SOLIDSTATE))
>  atomic_dec(&nr_rotate_swap);
>=20=20
>=20- mutex_lock(&swapon_mutex);
>  percpu_down_write(&swapon_rwsem);
>  spin_lock(&p->lock);
>  drain_mmlist();
> @@ -3355,7 +3356,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
>  percpu_up_write(&swapon_rwsem);
>  arch_swap_invalidate_area(p->type);
>  zswap_swapoff(p->type);
> - mutex_unlock(&swapon_mutex);
>  kfree(p->global_cluster);
>  p->global_cluster =3D NULL;
>  free_swap_cluster_info(cluster_info, maxpages);
> @@ -3401,20 +3401,18 @@ static __poll_t swaps_poll(struct file *file, p=
oll_table *wait)
>  return EPOLLIN | EPOLLRDNORM;
>  }
>=20=20
>=20-/* iterator */
>  static void *swap_start(struct seq_file *swap, loff_t *pos)
>  {
>  struct swap_info_struct *si;
> - int type;
>  loff_t l =3D *pos;
>=20=20
>=20- mutex_lock(&swapon_mutex);
> + percpu_down_read(&swapon_rwsem);
>=20=20
>=20 if (!l)
>  return SEQ_START_TOKEN;
>=20=20
>=20- for (type =3D 0; (si =3D swap_type_to_info(type)); type++) {
> - if (!(si->swap_file))
> + for_each_swap(si) {
> + if (!si->swap_file)
>  continue;
>  if (!--l)
>  return si;
> @@ -3435,7 +3433,7 @@ static void *swap_next(struct seq_file *swap, voi=
d *v, loff_t *pos)
>=20=20
>=20 ++(*pos);
>  for (; (si =3D swap_type_to_info(type)); type++) {
> - if (!(si->swap_file))
> + if (!(si->flags & SWP_USED) || !(si->swap_file))



Could we keep checking just si->swap_file here and in swap_start()?
swapon() can set SWP_SOLIDSTATE before taking swapon_rwsem to
publish the file.

Thanks,
Kunwu

>  continue;
>  return si;
>  }
> @@ -3445,7 +3443,7 @@ static void *swap_next(struct seq_file *swap, voi=
d *v, loff_t *pos)
>=20=20
>=20 static void swap_stop(struct seq_file *swap, void *v)
>  {
> - mutex_unlock(&swapon_mutex);
> + percpu_up_read(&swapon_rwsem);
>  }
>=20=20
>=20 static int swap_show(struct seq_file *swap, void *v)
> @@ -3958,7 +3956,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>  goto free_swap_zswap;
>  }
>=20=20
>=20- mutex_lock(&swapon_mutex);
>  prio =3D DEF_SWAP_PRIO;
>  if (swap_flags & SWAP_FLAG_PREFER)
>  prio =3D swap_flags & SWAP_FLAG_PRIO_MASK;
> @@ -3970,11 +3967,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, sp=
ecialfile, int, swap_flags)
>  si->prio =3D prio;
>  si->list.prio =3D -si->prio;
>  si->avail_list.prio =3D -si->prio;
> + /* Publish the file, live reference and writable state together. */
> + percpu_down_write(&swapon_rwsem);
>  si->swap_file =3D swap_file;
>=20=20
>=20- /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap devi=
ce */
> + /* Make the reference live before exposing the writable device. */
>  percpu_ref_resurrect(&si->users);
> - swap_device_enable(si);
> + __swap_device_enable(si);
> + percpu_up_write(&swapon_rwsem);
>=20=20
>=20 pr_info("Adding %uk swap on %s. Priority:%d extents:%d across:%lluk =
%s%s%s%s\n",
>  K(si->pages), name->name, si->prio, nr_extents,
> @@ -3984,7 +3984,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>  (si->flags & SWP_AREA_DISCARD) ? "s" : "",
>  (si->flags & SWP_PAGE_DISCARD) ? "c" : "");
>=20=20
>=20- mutex_unlock(&swapon_mutex);
>  atomic_inc(&proc_poll_event);
>  wake_up_interruptible(&proc_poll_wait);
>


Using the same rwsem for publication and /proc/swaps looks good.

