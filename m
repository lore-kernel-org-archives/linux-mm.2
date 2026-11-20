Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBB0606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sfODo8Cv
Received: by kanga.kvack.org (Postfix)
	id 3A4806B0761; Thu, 19 Nov 2026 23:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355A46B0763; Thu, 19 Nov 2026 23:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A716B0765; Thu, 19 Nov 2026 23:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E91726B0761
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:36:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F6FBC0CFF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:36:46 +0000 (UTC)
X-FDA: 85454236812.13.324F6EF
Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6E23E20007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:36:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sfODo8Cv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.50 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149404;
	b=57QJSpkOXM1F9bM3+GOozoWS2nrnH61Fs2HgY7fDTjh1/XLlfKHshoiVDMXaDn1QF9C24c
	Q8elsawSTvQa0ITWWEn0NZ5ZX8T9rf/LAkL+fscOwJbioqr2BnJ8vx0lHeIdc56rnLdbLz
	PXfqSUHs7zobgZeczzwIgcMTf98iKQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXl1nUu33uWwxOKNxp2etrsx1DfSrs/u7Ukst+7XTH8=;
	b=LLVtd/jPWg+cRxRJDtMTBaHM1OYcUntF25F2I8r/mz1dkjTQDvGnUPvEIj6AXood7D9t55
	u9gZAhEtaoISqcFj7YSRAHnlqvtOWNjhFScD0eIHRr5KY8cm6NOmSSsUIV0Kcd1Z8b1iTt
	mIc0ureEEr60KstKpDU8MIrStxBpKdI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sfODo8Cv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.50 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jUHEmy5aQrelaM46tN2mShBpZvbPpUeJMifUGNUAsDE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149402; v=1; x=1795754202;
 b=sfODo8CvSBBbBSrJldEm5C4CYxSgbttnosD2RcS4sBpbUXOvyZlsOxBHrAORj0D99oPOu+NP
 UMpra4YbB85pfpL6YDQwmzrsTTk14+m3RPAy6n4gT6eA1INoHrPBdC27cl0t67zRVM/WnKLmmaM
 gGmttq7jogVn0DCT0oOovuwc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 81e24f6d10068c4f;
	Fri, 20 Nov 2026 04:36:42 +0000
X-Mizu-Trace-ID: 81e24f6d10068c4f
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:36:42 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <13f1e8fe71c2de81b9d87b824561414f48b41c00@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 11/18] mm/swap: remove available list
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <3bb9571ebf783db7a86a0ee2e7b00883c1de850b.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <3bb9571ebf783db7a86a0ee2e7b00883c1de850b.1794666741.git.lianux.mm@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E23E20007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3ugs5k1sp1kd5ofbtjy69wngi8s9kqeq
X-Rspam-User:
X-HE-Tag: 1795149404-999925
X-HE-Meta: U2FsdGVkX1+EPzCbDAjzoz3cAw7szAWBkF/oWwR97iGcf8v8DO13BL7rtRZX99lB3k6wCM46uZR6SG5IUjA+9ChYLc0jNGv2uaa/qDnyvjd1tzeXH5If6FQdYWs4s7zjoCOrcUGO7irV5y/A888ajqGTM3cmu3sKF+Vwof8iVoe5yTOhLw4+Tp73FdXHhOcLogqnw/ybQpLBqdM1RrNPoPFyczqR1Nye4xvwcxYVJOcM/Ip4xqkQeHouNv+kyOvCajWPOB/3dgMy3EyrH43XffrW1gTihilwEq38Uw/6XJ7mpV3h8ea6RzNMQ8BotSaaAltpc9I4YbSTgKrKQF0w7cPnTlOGakyJfzCn2KoDL9UIJG3aK1ZzJjwFHy1uDZIC4kk2ebtBDZhr1SGfPwnUA36OT3uCokbpTCgaWqMLnSCLA6+yFTiC9O+kxv56+JDP1NXcHNhAm43nLP/0sx2doQx0pC8GehAHArQgn5lUB8QC39w9MJp0SksQRsq8Of64SLB+YD7NJFLvyJ0wpEa1+JX1zi9Ytpl7RmWgtVsazznzpo36rc98MPTs182v/qSKF5mMtDKEjFfBKRz5dwEgEbGlqZwHZL01ryk+MpGBCwSwV7h3p9sIFlUhu/oSzWuAeZrY3yNSA3fYfi6nFW3QaBsWyc6O1f4uiG0M4UEpBfibNkSHB3eR0i7s0cJtrve1elCT4smccNgccEo56lGQuLGxP3/G759kAe60ttgPyn/uZPo7tbcMYYqlh6FdIxyewC0eOpBLAC/mTRYlyyZlOb/BEN/B9GwFtD0cNKnNmD6Z2eqB29uQBpZHSIe4gsw5qALiuXNSzNA4BhslGuwlhab6rynDOd4vWbrDa/loMvFB1++bW6DIPhmg5tXFIM0u551QGG2oDPaVqXRt1I6pNugKHNoo6dOED10DRHJrhLaD2eVzJC52oKTLJXpH4yxqYP4EPufxxQSQSfcQ4Sy
 tl47seev
 KZ/9W6+/rSJPBJI155hTqnVNWO4gN7z4yVp/3h7+6QkYgAvybEhw+stP+z1vob2hJi3AmIVVwBWmeh+LoYVBAvyIEXAIoKtSDmv9foLboe8MNjpHdHOJbbI3mumwBgs+gm2giCebKcgc7YuGhPyXCorQDxFcrQ1XLqHpvhQqvCq2WuErD+XCvFyxWbo8BptzkprGcaiOhMKz0LHMU+XycwrpMiTrsrKAaG0PXW/UK0iBJZQuphhCpTPcGXKiujq+oAhLxWLctTY2feWIYdlSQBx/ropweAjVhW7rFKLda2h3kyCv2SpSXZxHuNKVYHdqCO1UY4nT4TRjRowlA64yVmNSxQ7bww6g3GDzu2tg4+nnqilyKEwS1pyBafo55nV/TCA55yq2EwOSwjBV5Pb05D/++KxlWq+19UaEVuE9easdA44IN1zWtsLw44D7pIF8J7u/bmxOW6vh1wPa7dGhb9d2ADBnh/gy+6xmJrSR2FSLCu4x73RHWiWtX180+8BeK/xxQF1W44je2OJ/yyBJIxvv42mRIREmobXweM3VtnirxzJj8jaJIyasG94b+8HbYZW2wersszG0m8Ez/h/mdO8Tqmfi3TIRILdDE
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
>=20The allocator now selects devices from the priority queue. Move the
> remaining block-cgroup throttle traversal from swap_avail_head to
> swap_active_head under swapon_rwsem. Check SWP_WRITEOK, the off-list
> state and the backing block device to retain priority-ordered target
> selection.
>=20
>=20Remove swap_avail_head, swap_avail_lock, the per-device avail_list fi=
eld
> and their maintenance now that no consumer needs the available plist.
> Queue masking and the embedded availability state remain serialized by
> swap_queue_update_lock.
>=20
>=20Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  include/linux/swap.h | 1 -
>  mm/swapfile.c | 33 ++++++---------------------------
>  2 files changed, 6 insertions(+), 28 deletions(-)
>=20
>=20diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 6f32de173fb9..d31f3f023d36 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -289,7 +289,6 @@ struct swap_info_struct {
>  struct work_struct discard_work; /* discard worker */
>  struct work_struct reclaim_work; /* reclaim worker */
>  struct list_head discard_clusters; /* discard clusters list */
> - struct plist_node avail_list; /* entry in swap_avail_head */
>  const struct swap_ops *ops;
>  };
>=20=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 21d27da95898..5c5e449e9da3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -96,21 +96,6 @@ static const char Bad_offset[] =3D "Bad swap offset =
entry ";
>  */
>  static PLIST_HEAD(swap_active_head);
>=20=20
>=20-/*
> - * all available (active, not full) swap_info_structs
> - * protected with swap_avail_lock, ordered by priority.
> - * This is used by folio_alloc_swap() instead of swap_active_head
> - * because swap_active_head includes all swap_info_structs,
> - * but folio_alloc_swap() doesn't need to look at full ones.
> - * This uses its own lock instead of swapon_rwsem because when a
> - * swap_info_struct changes between not-full/full, it needs to
> - * add/remove itself to/from this list, but the swap_info_struct->lock
> - * is held and the locking order requires swapon_rwsem to be taken
> - * before any swap_info_struct->lock.
> - */
> -static PLIST_HEAD(swap_avail_head);
> -static DEFINE_SPINLOCK(swap_avail_lock);
> -
>  static inline struct swap_info_struct *__swap_iter(int *i, unsigned lo=
ng flag)
>  {
>  lockdep_assert_held(&swapon_rwsem);
> @@ -1713,7 +1698,6 @@ static void del_from_avail_list(struct swap_info_=
struct *si, bool swapoff)
>  {
>  unsigned long pages;
>=20=20
>=20- spin_lock(&swap_avail_lock);
>  spin_lock(&swap_queue_update_lock);
>=20=20
>=20 /*
> @@ -1736,10 +1720,8 @@ static void del_from_avail_list(struct swap_info=
_struct *si, bool swapoff)
>  }
>=20=20
>=20 swap_queue_mask(si);
> - plist_del(&si->avail_list, &swap_avail_head);
>  skip:
>  spin_unlock(&swap_queue_update_lock);
> - spin_unlock(&swap_avail_lock);
>  }
>=20=20
>=20 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
> @@ -1748,7 +1730,6 @@ static void add_to_avail_list(struct swap_info_st=
ruct *si)
>  long val;
>  unsigned long pages;
>=20=20
>=20- spin_lock(&swap_avail_lock);
>  spin_lock(&swap_queue_update_lock);
>=20=20
>=20 /*
> @@ -1779,10 +1760,8 @@ static void add_to_avail_list(struct swap_info_s=
truct *si)
>  }
>=20=20
>=20 swap_queue_unmask(si);
> - plist_add(&si->avail_list, &swap_avail_head);
>  skip:
>  spin_unlock(&swap_queue_update_lock);
> - spin_unlock(&swap_avail_lock);
>  }
>=20=20
>=20 /*
> @@ -3910,7 +3889,6 @@ static struct swap_info_struct *alloc_swap_info(v=
oid)
>  }
>  p->swap_extent_root =3D RB_ROOT;
>  plist_node_init(&p->list, 0);
> - plist_node_init(&p->avail_list, 0);
>  p->flags =3D SWP_USED;
>  percpu_up_write(&swapon_rwsem);
>  if (defer) {
> @@ -4326,7 +4304,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>  */
>  si->prio =3D prio;
>  si->list.prio =3D -si->prio;
> - si->avail_list.prio =3D -si->prio;
>=20=20
>=20 /*
>  * Publish swap_file before making the percpu ref live, then add the de=
vice
> @@ -4475,14 +4452,16 @@ void __folio_throttle_swaprate(struct folio *fo=
lio, gfp_t gfp)
>  if (current->throttle_disk)
>  return;
>=20=20
>=20- spin_lock(&swap_avail_lock);
> - plist_for_each_entry(si, &swap_avail_head, avail_list) {
> - if (si->bdev) {
> + percpu_down_read(&swapon_rwsem);
> + plist_for_each_entry(si, &swap_active_head, list) {
> + if ((si->flags & SWP_WRITEOK) &&
> + !(atomic_long_read(&si->inuse_pages) &
> + SWAP_USAGE_OFFLIST_BIT) && si->bdev) {
>  blkcg_schedule_throttle(si->bdev->bd_disk, true);
>  break;
>  }
>  }
> - spin_unlock(&swap_avail_lock);
> + percpu_up_read(&swapon_rwsem);
>  }
>  #endif
>

