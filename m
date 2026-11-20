Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E129606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m/FcdppI
Received: by kanga.kvack.org (Postfix)
	id 57AAB6B0752; Thu, 19 Nov 2026 23:37:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558536B0768; Thu, 19 Nov 2026 23:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468EC6B0769; Thu, 19 Nov 2026 23:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6C16B0752
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:37:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B192B40CED
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:37:19 +0000 (UTC)
X-FDA: 85454238198.16.C201A7B
Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	by imf02.hostedemail.com (Postfix) with ESMTP id BADB680002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:37:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m/FcdppI";
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.227 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149438;
	b=OJYv+zeEgmdrQHb0HKl7iLfAxoiJF9w3Zz9A+AVMVCng+IlOllCksld2ACyYRecuJtGREE
	achWKj0GGx+UeZ5l72ZKIh3bgY1N6H/g2Z6h5B6O8cfDyPEyYVhkLnADV2N59OUgfMFkD7
	dj5nh8Zuu3L3s4HKwlPhIRfDwp3iK4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wC9eJUz4DKLJpJ6vBDEqFE43JAvCeQg51GGXML5L67M=;
	b=0aB/I07G/nXW9BhUu5mAAJ76iKeKb/IIiVgvl12WczJqve55DAifEPnDo4MC/aPA9ylm1n
	vuQquxo1427/v4l/FeWOQaWIuyAw/D7yOzC7I/9D6z8cqUzbUx1qHFUfUK6hO4IXQQJ2kx
	OcLnf0qboRacpXcnMebO0MC11+6SRAI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m/FcdppI";
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.227 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zcFjEBIqj6cBYiwCe459AugAgTcvIrqKO3mRoQbcdtQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149436; v=1; x=1795754236;
 b=m/FcdppIgHJYfuLm3Jz15SS48v1ECsydPsIwzykwvxsv7uWMy2hNOLPu29xj4bQ7ffnTZgw4
 UBEFF6PBVpWC50sOXx3+vAEXgueh73gIGzUqHz6KmFuqFB/R6826ht7kMXpbyK0v/h4WgY3rGV+
 YvflVYmruXWy+w3ZAXB+u2co=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eddd8fd8e6334fde;
	Fri, 20 Nov 2026 04:37:16 +0000
X-Mizu-Trace-ID: eddd8fd8e6334fde
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:37:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <c766c294502b5df1cf14e5941f79080a61f17bcf@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 13/18] mm/swap: drop swap active plist
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <9ccd81f6f036eb1c3e50d396b44b5e43cff77d2a.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <9ccd81f6f036eb1c3e50d396b44b5e43cff77d2a.1794666741.git.lianux.mm@gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BADB680002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 66gxar1mpsjsxymw5c9g5wc6n33du4bq
X-HE-Tag: 1795149437-512475
X-HE-Meta: U2FsdGVkX18TXNNk/OvNlO3UCrXtZ1wyB6Z6ApdeDA8pADIkpTmJfiX2qHaiMr+0ffWHNKSsqGVyO2ie1VjM6vFUu1SsBbEj6RjYr3QvkVKDcfB/XAYhRgMVhhZlhnlS79ur5TInenkKXh0LM/f1MUjFpGuR+wmx6j88U12i/D+bNXSb2FvDo3N2XDKCWxdqwrktUXq/r7hh7F+V7q2ECt32qGtNOE9J/jJAKdCL1Q1b8gIlYxwXP1uV+9EBJGWtuxT1TRGXT0hDUejsl2yje+PDLr9v5ek3+Fi7uY5qJmb9rHTAyYZDPdu0EwHXBGMzFdUcS6/EvuR13sSwymOf5EVlyl7W8LTqjGdI/ARo+ZuZVo13R9gt3WtAr0s8m0IkkL4AxzcH4HUP6BrYyHvrIZW0fRZFm9qJMwYbkILLD64aMh92pZLTeXjhX9dsSthq+aY6M8aObUmeVbDie47Nhc2z38vbn77x+tctcTiasmhjlEO3MS9ndaVvVR0blJu4L+t/HHVObtvTuXAo1TOiVP1FqvzXONFE4ydrmRKszeiSLZ/bwRZnIFZLbVXr8cG0mcKTao6ADYRq7De3E8URCCJLmb2MngqBj+kZiquRiTz+XgYia+IKiOfFaHAS/r64NMulzGTmpZpqHvNktbxm0Kl6XXiYNC7a79jamKJRHIjkA/Z4O7veH9nlPgHAUNCWQiXbxo2v0BaDrCbarmp8qLsuBd/kN5E5vOJDCDzQW2XmHiJKcuhtRF7hnZyuVgpKa6ajIQFg5YnlWnd5Ua/SayhetYelRCjv6t0JJsNA8Xzf1Z1qwOQbxNYr5dYyYMJTWH0uZxQb2VIsvoKdXD/oJIfZW/gN8C0+X8qIYfziUVp0OwBlP4cup3T7IvuQSGbQQRCK0614YkVHCnh9ZSBpopWBlTr4vQwvtbJ/9lifSwLPoPt7m2W6R5PAM1uTU5WS4+L/PqEey8KPRDGlUv+
 HcdWSTOq
 bK+Lv2YjWmlO84Bv0hls9JslatF7c0VIk4wn6XUZ2sKHVzMN/BDkeUUR/dsfWw49lgDxKETh7VhI6WNUzypdQ5+3Y8325IgO2jBWgAGL8qffX+fNBd2EXIOt8pKx6sYzKUeBcna7nFANTj3BtIObrGuRcW6AO0mmbooYQ0ppRu/nhIpi/S+N5ShAuXxumUlqtvUn3Z41z1iwWCh/DpaDnqjDrJpK57L2O90xZeaPrru0mL1PlP6z13xh6DwJ3Sa8Q33FWk2knWomQHBw9tH+7hUR2fueU67d7D1hZVO7hnXOQFs+idfZt8EqcpZiCFkO103OxGw9y8PAAzlfk2G17RZcZ7SvlGl61Xz1f5HiMf+AxSSbHrpcfJ84E8rsx6r+5GNJV5TkgYmalFtitsfCWXjyP8YJzTeTxaWaByUkSqEVRPfc9Rt0itUmUJrB8uNw+Rlb8a+dAEfY6iGPQx1p4jD0joz9G2gXucZtBJ2/nV94VcBS88yIOFCudyTQ20+P5EUq9kvknQXp1pg1/f2eA0/i5i1StQLF8HnR2PB25MgYNZE5HLk5af20h3W1PJF5Gf4cEON4LpqKu6khfhcRzImdqMH39Hft0ac98JFTRF1Alxw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>=20
>=20From: Kairui Song <kasong@tencent.com>
>=20
>=20Remove swap_active_head and the associated plist_node. Device identit=
y
> lookups can use the writable swap_info iterator without ordering.
>=20
>=20Keep priority ordering for the block-cgroup swap throttle target by
> walking the priority queue under the topology reader. Choose the first
> unmasked, writable, non-offlist device with a backing block device.
> Check OFFLIST as well as the pointer tag because full transitions can
> temporarily leave an unmasked entry, and keep the explicit WRITEOK
> check. The disable transition already publishes its mask before
> releasing the topology writer.
>=20
>=20This read-only lookup does not consume per-CPU allocation quotas or
> change retry cursors. It avoids making the throttle disk depend on
> swapon's swap-type assignment order when devices have different
> priorities.
>=20
>=20Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  include/linux/swap.h | 1 -
>  mm/swapfile.c | 60 +++++++++++++++++++++++---------------------
>  2 files changed, 32 insertions(+), 29 deletions(-)
>=20
>=20diff --git a/include/linux/swap.h b/include/linux/swap.h
> index d31f3f023d36..ce8a800751ca 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -263,7 +263,6 @@ struct swap_info_struct {
>  struct percpu_ref users; /* indicate and keep swap device valid. */
>  unsigned long flags; /* SWP_USED etc: see above */
>  signed short prio; /* swap priority of this type */
> - struct plist_node list; /* entry in swap_active_head */
>  signed char type; /* strange name for an index */
>  unsigned int max; /* size of this swap device */
>  struct swap_cluster_info *cluster_info; /* array, one entry per cluste=
r */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6b2dbaf33cb6..bd098114ee4b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -42,7 +42,6 @@
>  #include <linux/completion.h>
>  #include <linux/suspend.h>
>  #include <linux/zswap.h>
> -#include <linux/plist.h>
>=20=20
>=20 #include <asm/tlbflush.h>
>  #include <linux/leafops.h>
> @@ -91,12 +90,6 @@ bool swap_migration_ad_supported;
>  static const char Bad_file[] =3D "Bad swap file entry ";
>  static const char Bad_offset[] =3D "Bad swap offset entry ";
>=20=20
>=20-/*
> - * all active swap_info_structs
> - * protected with swapon_rwsem, and ordered by priority.
> - */
> -static PLIST_HEAD(swap_active_head);
> -
>  static inline struct swap_info_struct *__swap_iter(int *i, unsigned lo=
ng flag)
>  {
>  lockdep_assert_held(&swapon_rwsem);
> @@ -3535,7 +3528,6 @@ static void __swap_device_enable(struct swap_info=
_struct *si)
>  spin_unlock(&si->lock);
>  atomic_long_add(si->pages, &nr_swap_pages);
>  total_swap_pages +=3D si->pages;
> - plist_add(&si->list, &swap_active_head);
>  add_to_avail_list(si);
>  }
>=20=20
>=20@@ -3555,9 +3547,8 @@ static int swap_device_disable(struct address_s=
pace *mapping,
>  int err =3D -EINVAL;
>=20=20
>=20 percpu_down_write(&swapon_rwsem);
> - plist_for_each_entry(si, &swap_active_head, list) {
> - if ((si->flags & SWP_WRITEOK) &&
> - si->swap_file->f_mapping =3D=3D mapping) {
> + for_each_avail_swap(si) {
> + if (si->swap_file->f_mapping =3D=3D mapping) {
>  err =3D 0;
>  break;
>  }
> @@ -3583,8 +3574,6 @@ static int swap_device_disable(struct address_spa=
ce *mapping,
>  spin_lock(&si->lock);
>  del_from_avail_list(si, true);
>  spin_unlock(&si->lock);
> -
> - plist_del(&si->list, &swap_active_head);
>  total_swap_pages -=3D si->pages;
>  atomic_long_sub(si->pages, &nr_swap_pages);
>=20=20
>=20@@ -3913,7 +3902,6 @@ static struct swap_info_struct *alloc_swap_info=
(void)
>  */
>  }
>  p->swap_extent_root =3D RB_ROOT;
> - plist_node_init(&p->list, 0);
>  p->flags =3D SWP_USED;
>  percpu_up_write(&swapon_rwsem);
>  if (defer) {
> @@ -4323,12 +4311,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, spe=
cialfile, int, swap_flags)
>  if (swap_flags & SWAP_FLAG_PREFER)
>  prio =3D swap_flags & SWAP_FLAG_PRIO_MASK;
>=20=20
>=20- /*
> - * The plist prio is negated because plist ordering is
> - * low-to-high, while swap ordering is high-to-low
> - */
>  si->prio =3D prio;
> - si->list.prio =3D -si->prio;
>=20=20
>=20 /*
>  * Publish swap_file before making the percpu ref live, then add the de=
vice
> @@ -4454,7 +4437,33 @@ int swap_dup_entry_direct(swp_entry_t entry)
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
>  static bool __has_usable_swap(void)
>  {
> - return !plist_head_empty(&swap_active_head);
> + return READ_ONCE(total_swap_pages) > 0;
> +}
> +
> +static struct swap_info_struct *swap_queue_first_usable_bdev(void)
> +{
> + struct swap_prio_ring *ring;
> + struct swap_info_struct *si;
> + unsigned int ring_idx, dev_idx;
> +
> + lockdep_assert_held(&swapon_rwsem);
> + for (ring_idx =3D 0; ring_idx < swap_queue_len; ring_idx++) {
> + ring =3D swap_queue[ring_idx];
> + for (dev_idx =3D 0; dev_idx < ring->size; dev_idx++) {
> + si =3D READ_ONCE(ring->dev[dev_idx]);
> + if (swap_device_masked(si))
> + continue;
> + si =3D swap_device_unmask_ptr(si);
> + if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> + continue;
> + if (atomic_long_read(&si->inuse_pages) &
> + SWAP_USAGE_OFFLIST_BIT)
> + continue;
> + if (si->bdev)
> + return si;
> + }
> + }
> + return NULL;
>  }
>=20=20
>=20 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
> @@ -4478,14 +4487,9 @@ void __folio_throttle_swaprate(struct folio *fol=
io, gfp_t gfp)
>  return;
>=20=20
>=20 percpu_down_read(&swapon_rwsem);
> - plist_for_each_entry(si, &swap_active_head, list) {
> - if ((si->flags & SWP_WRITEOK) &&
> - !(atomic_long_read(&si->inuse_pages) &
> - SWAP_USAGE_OFFLIST_BIT) && si->bdev) {
> - blkcg_schedule_throttle(si->bdev->bd_disk, true);
> - break;
> - }
> - }
> + si =3D swap_queue_first_usable_bdev();
> + if (si)
> + blkcg_schedule_throttle(si->bdev->bd_disk, true);
>  percpu_up_read(&swapon_rwsem);
>  }
>  #endif
>

