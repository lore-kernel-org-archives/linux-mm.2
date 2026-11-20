Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53ED606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Yav2Kdfq
Received: by kanga.kvack.org (Postfix)
	id AD1156B06D8; Thu, 19 Nov 2026 23:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81526B074D; Thu, 19 Nov 2026 23:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970B16B074F; Thu, 19 Nov 2026 23:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7066A6B06D8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:37:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 066A940A9A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:37:04 +0000 (UTC)
X-FDA: 85454237568.03.2F6D7B1
Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	by imf08.hostedemail.com (Postfix) with ESMTP id 01548160005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:37:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yav2Kdfq;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149422;
	b=WY5WzR798vwFIHwVNeoq3JhI1dVp7El+4EiKDc2WaVzm+igOWhL0Mg/zO7P0TFiw7CAw14
	NLgkk1LMz+B0H4OrGJQdr/JFdyXc4UYevVHCR1I6d4rB0Q8AMb2iPkcOtnVDGKEo9bY8IE
	fX5mPtZHI/45dRyNGL2bpXll1t/a4JI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfDSktGXNX0ExFvAd5yZdX3whk4tn/u9y+EZTgvGoCQ=;
	b=IxTy0/WQfc4odKHYjymaB6BBB5NMVBeAvGmElWP4jfr/IHnqjbwXT9yTaBKur+VqOqftOP
	BRu3TcsVfpdArKt2NuBqoUYfKCxxr3L4+o0M0y51Vu11V9OCyYs1HurpvG3lu7TQV91Pjx
	qIkP1gOZslr2Pq/lfMhUzhm3F6489+4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yav2Kdfq;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fl9Tf/YHT7hNcJzVDUQi+oYQfBidaYiMuvo42+SZZSQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149420; v=1; x=1795754220;
 b=Yav2KdfqdpdaA/+3lRbz+p6+twizwnnh+BG0t1Il72vIHOMs4AEwETrEWY3vNqdHjH6d5xsr
 eIpASGdAMnqL85J6IdKPFhIm4sjp9thmsF2hvjU2K+jGHrdIWB6W2tkROpRQi/WMYp/ceMDYTdn
 jWurZQgCJyoJrLRhB/jefz/I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e2912f04c13bb6c8;
	Fri, 20 Nov 2026 04:37:00 +0000
X-Mizu-Trace-ID: e2912f04c13bb6c8
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:36:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <0eb4c100d6c422b2cfd3dae074a487560d8ea28c@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 12/18] mm/swap: bound synchronous discard outside
 the allocation reader
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <19155551d5c520add74b25f8d50d22fb890e3fbb.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <19155551d5c520add74b25f8d50d22fb890e3fbb.1794666741.git.lianux.mm@gmail.com>
X-Stat-Signature: 1qu5poxhufma9fmnb4idubmo5saiwp7e
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 01548160005
X-HE-Tag: 1795149421-170053
X-HE-Meta: U2FsdGVkX1+EzEd2fA0Jk/dhyAM/BjsuQ22Z68crRUEHWSZeW4Zxeee4vnnzquHckLt3HP0jVqZMzPQRA33X6ONc/5mPU2Hhp1jqkojqgoXose7zeCl/QPY1yJukwr5WliJIveDwcB6DJ5XWdmW280wwTGHRHJ3+NuCwNW9wF0s5G8tlvb53Mmvk4uDgq3vIg1DPQFISRgqIdmvKNpV4lG6TTq1X4mn+k9nLtM7LziipaEMBvH8CqNnm4YrWrcXOkOqmCaxWrEGcLXvxMG27HZBWbDnA33qbq+o7Pbsim3kQic/ju6pfHCjJ2L+rxVZG9NeOyB0jWXIZLsiARV8MtmWqvSgVlFMBFwELBfesCVN4et89NdXCUqvxmqfVQqm76gJ3D9y6eCfT7NvLN5ASm+AC/FXRgQbjSKy4nrWfE0RlgBjkEWEXChi6bj6Eqbz7+nLUMICa+1rajuI5Qoa1h6iqod7RhikP51jWW6ijNOD1ua6oM1RyYdT0qw65G0ghc+mO3Ok8MGq/INzaR7wRWcsrE4f+S5i5V309X7cHQWSuRHvtY99tjGiXAbAm4aif36+S8lhCy+0zfjgBRXkbdUqGVqXFLbRI3KC8+5pXNrRGKSsute8e6Mg/9qrb09OlSY8VozPofqAqsYHySgOyHqsVG/Nex14dd8tZ5ZGGjD7FMHm6t95TkpTFdCFuHIZKFDIuWYL/nhhmGK7WzNk1OwSHGCOMAkT4Uv0uIZGcb0E8DVEBbfi2N77CQKHbOgGE+U6c8ajTzU0wDVSDDsKCF6tUN96Tr/kZ8+g71FuubopX1ocAiawJtCu4sn9PBRaSBnpM8LG8ZRHTCpVXt2rDIdc8lwdDtzzjBEmCyFtP+2cYJVNG+WNoVtePK3O7iXgdnjUN/Dr3EcQui+BpZ0xuKHWd4yuj0eZ31p7WN/dRx8XCIl1BhJUzLXiAXkFBV3Dq3bKdPb94yCFz8XI11jv
 LZzbRUjW
 igpT33Uk+WrEIgBPC+v3wsnizBiHWazW0Y5/QrAxK3GfNu/1WAv67lxcySRBW/mEclgk0GLJpotShuHUwEhRfv8yevZT41/LcBMb3zIfujH4fqcCU/i13Hoic5C5ptEqZ23pMK0RPMVpEwU5WNyB5XRoPBIaDP3oALnNRbQ+Qx4WbhH+QI/9PrYIni/2Brkvr+Z4iB78HSdJZdpj/0r0sBO9o5ZhhGkEQSY9t9cFX0kYK6QEi5huwHjBKmMyUIP5+mIcMXhMTSpM9u5fyCNyvJYdN0+KZCm/XbtBoKWt+r32DX18FMf1MYg/iLza6ScdzAwW4uwTSfHgXot6Ohy6/kthTIgUvxKXu0/ycdxWvD7k7IBm4qnCLQLEzBzMfAJgjlmAvXGyDdv91dalhy6LvxT2rIG+DW6rSa3+Sr2QXkaWDwVNfHc+hFaWrKKbQJbLgooLPzKdV0Boe/WGvmE2iJvXg6bFXgZAwMYrS+I9AedeyQbA4LX46VplVjEmzCNZK0RK64ZCg9JYdPCqlWSt7p3icTbvxMq+wKMxSEzHYIAikud3j64cFnCdWFtaWE7bFPO0KAzn8FMaF/d0tUZ99uIlOwHvlxCzQ0onlEQm3xj+iErWcI5fh5vQp67aa+SZqo2kV
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
>=20The synchronous discard fallback drains a list that freeing paths can
> keep replenishing. Limit each foreground step to one cluster, retaining
> CLUSTER_FLAG_DISCARD while I/O is in flight and returning the cluster t=
o
> the free list only after completion. The background worker continues to
> process the remaining list.
>=20
>=20Keep synchronous discard outside the topology reader. Enter this fall=
back
> only after a complete normal order-0 allocation walk fails. A higher-
> priority device with only pending discard work does not force synchrono=
us
> I/O if a lower-priority device satisfies that walk.
>=20
>=20Find a writable discard-capable device under the reader and take its =
live
> reference, then release the reader before issuing I/O. Drop the referen=
ce
> after completion and restart allocation with a fresh cursor, so a
> concurrent topology change cannot leave stale ring state. This also see=
s
> discard work produced by the preceding reclaim scans.
>=20
>=20Track the swap types already processed during this folio allocation a=
nd
> check each candidate at most once per fallback search. An empty check
> does not consume the I/O budget. Each swap type can complete at most on=
e
> synchronous cluster discard, bounding successful retries by MAX_SWAPFIL=
ES
> even if membership changes. Do not keep discarding until this task wins
> a free cluster from a peer.
>=20
>=20Large folios retain the existing same-priority retry and split bounda=
ry;
> their reader-held cluster walk does not issue synchronous discard. The
> budget bounds work count, not device I/O completion latency.
>=20
>=20Link: https://lore.kernel.org/all/CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG59=
3TFeOGV-oax++kWA@mail.gmail.com/
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 175 ++++++++++++++++++++++++++++----------------------
>  1 file changed, 100 insertions(+), 75 deletions(-)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5c5e449e9da3..6b2dbaf33cb6 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -6,6 +6,7 @@
>  * Swap reorganised 29.12.95, Stephen Tweedie
>  */
>=20=20
>=20+#include <linux/bitmap.h>
>  #include <linux/blkdev.h>
>  #include <linux/mm.h>
>  #include <linux/sched/mm.h>
> @@ -585,6 +586,26 @@ static long swap_usage_in_pages(struct swap_info_s=
truct *si)
>  return atomic_long_read(&si->inuse_pages) & SWAP_USAGE_COUNTER_MASK;
>  }
>=20=20
>=20+/*
> + * Serialize the allocation on single CPU or globally to avoid
> + * fragmentation and make the workflow easier to follow.
> + */
> +static void swap_alloc_lock_device(struct swap_info_struct *si)
> +{
> + if (si->flags & SWP_SOLIDSTATE)
> + local_lock(&si->percpu_cluster->lock);
> + else
> + spin_lock(&si->global_cluster->lock);
> +}
> +
> +static void swap_alloc_unlock_device(struct swap_info_struct *si)
> +{
> + if (si->flags & SWP_SOLIDSTATE)
> + local_unlock(&si->percpu_cluster->lock);
> + else
> + spin_unlock(&si->global_cluster->lock);
> +}
> +
>  /* Reclaim the swap entry anyway if possible */
>  #define TTRS_ANYWAY 0x1
>  /*
> @@ -916,12 +937,8 @@ static int swap_cluster_alloc_table(struct swap_in=
fo_struct *si,
>=20=20
>=20 lock:
>  if (!locked) {
> - if (si) {
> - if (si->flags & SWP_SOLIDSTATE)
> - local_lock(&si->percpu_cluster->lock);
> - else
> - spin_lock(&si->global_cluster->lock);
> - }
> + if (si)
> + swap_alloc_lock_device(si);
>  spin_lock(&ci->lock);
>  }
>  lockdep_assert_held(&ci->lock);
> @@ -1024,10 +1041,7 @@ swap_cluster_populate(struct swap_info_struct *s=
i,
>  * which could give allocator hooks and failure cleanup reserve access.
>  */
>  spin_unlock(&ci->lock);
> - if (si->flags & SWP_SOLIDSTATE)
> - local_unlock(&si->percpu_cluster->lock);
> - else
> - spin_unlock(&si->global_cluster->lock);
> + swap_alloc_unlock_device(si);
>=20=20
>=20 gfp =3D (GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC) &
>  ~__GFP_DIRECT_RECLAIM;
> @@ -1134,44 +1148,40 @@ static struct swap_cluster_info *isolate_lock_c=
luster(
>  }
>=20=20
>=20 /*
> - * Doing discard actually. After a cluster discard is finished, the cl=
uster
> - * will be added to free cluster list. Discard cluster is a bit specia=
l as
> - * they don't participate in allocation or reclaim, so clusters marked=
 as
> - * CLUSTER_FLAG_DISCARD must remain off-list or on discard list.
> + * Discard one cluster. After the discard is finished, the cluster wil=
l be
> + * added to the free cluster list. Discard clusters are special becaus=
e they
> + * don't participate in allocation or reclaim, so CLUSTER_FLAG_DISCARD=
 must
> + * remain set while a cluster is either queued or being discarded.
>  */
> -static bool swap_do_scheduled_discard(struct swap_info_struct *si)
> +static bool swap_discard_one_cluster(struct swap_info_struct *si)
>  {
>  struct swap_cluster_info *ci;
> - bool ret =3D false;
>  unsigned int idx;
>=20=20
>=20 spin_lock(&si->lock);
> - while (!list_empty(&si->discard_clusters)) {
> - ci =3D list_first_entry(&si->discard_clusters, struct swap_cluster_in=
fo, list);
> - /*
> - * Delete the cluster from list to prepare for discard, but keep
> - * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
> - * pointing to it, or ran into by relocate_cluster.
> - */
> - list_del(&ci->list);
> - idx =3D cluster_index(si, ci);
> + if (list_empty(&si->discard_clusters)) {
>  spin_unlock(&si->lock);
> - discard_swap_cluster(si, idx * SWAPFILE_CLUSTER,
> - SWAPFILE_CLUSTER);
> -
> - spin_lock(&ci->lock);
> - /*
> - * Discard is done, clear its flags as it's off-list, then
> - * return the cluster to allocation list.
> - */
> - ci->flags =3D CLUSTER_FLAG_NONE;
> - __free_cluster(si, ci);
> - spin_unlock(&ci->lock);
> - ret =3D true;
> - spin_lock(&si->lock);
> + return false;
>  }
> +
> + ci =3D list_first_entry(&si->discard_clusters,
> + struct swap_cluster_info, list);
> + /*
> + * Delete the cluster from the list, but keep CLUSTER_FLAG_DISCARD
> + * set while the discard is in flight. A percpu cluster may still
> + * point to it, or relocate_cluster() may encounter it.
> + */
> + list_del(&ci->list);
> + idx =3D cluster_index(si, ci);
>  spin_unlock(&si->lock);
> - return ret;
> +
> + discard_swap_cluster(si, idx * SWAPFILE_CLUSTER, SWAPFILE_CLUSTER);
> +
> + spin_lock(&ci->lock);
> + ci->flags =3D CLUSTER_FLAG_NONE;
> + __free_cluster(si, ci);
> + spin_unlock(&ci->lock);
> + return true;
>  }
>=20=20
>=20 static void swap_discard_work(struct work_struct *work)
> @@ -1180,7 +1190,8 @@ static void swap_discard_work(struct work_struct =
*work)
>=20=20
>=20 si =3D container_of(work, struct swap_info_struct, discard_work);
>=20=20
>=20- swap_do_scheduled_discard(si);
> + while (swap_discard_one_cluster(si))
> + cond_resched();
>  }
>=20=20
>=20 static void swap_users_ref_free(struct percpu_ref *ref)
> @@ -1609,15 +1620,11 @@ static unsigned long cluster_alloc_swap_entry(s=
truct swap_info_struct *si,
>  if (order && !(si->flags & SWP_BLKDEV))
>  return 0;
>=20=20
>=20- if (si->flags & SWP_SOLIDSTATE) {
> - /* Fast path using per CPU cluster */
> - local_lock(&si->percpu_cluster->lock);
> + swap_alloc_lock_device(si);
> + if (si->flags & SWP_SOLIDSTATE)
>  offset =3D __this_cpu_read(si->percpu_cluster->next[order]);
> - } else {
> - /* Serialize HDD SWAP allocation for each device. */
> - spin_lock(&si->global_cluster->lock);
> + else
>  offset =3D si->global_cluster->next[order];
> - }
>=20=20
>=20 if (offset !=3D SWAP_ENTRY_INVALID) {
>  ci =3D swap_cluster_lock(si, offset);
> @@ -1685,10 +1692,7 @@ static unsigned long cluster_alloc_swap_entry(st=
ruct swap_info_struct *si,
>  goto done;
>  }
>  done:
> - if (si->flags & SWP_SOLIDSTATE)
> - local_unlock(&si->percpu_cluster->lock);
> - else
> - spin_unlock(&si->global_cluster->lock);
> + swap_alloc_unlock_device(si);
>=20=20
>=20 return found;
>  }
> @@ -1883,33 +1887,50 @@ static int swap_alloc_entry(struct folio *folio=
)
>  }
>=20=20
>=20 /*
> - * Discard pending clusters in a synchronized way when under high pres=
sure.
> - * Return: true if any cluster is discarded.
> + * Discard outside the topology reader, holding only the selected devi=
ce's
> + * live reference across I/O. Each successful retry starts a fresh que=
ue walk.
>  */
> -static bool swap_sync_discard(void)
> +static bool swap_discard_for_alloc(unsigned long *discarded)
>  {
> - bool ret =3D false;
> - struct swap_info_struct *si, *next;
> + DECLARE_BITMAP(checked, MAX_SWAPFILES) =3D {};
> + struct swap_info_struct *si, *candidate;
> + unsigned int i, j;
> + bool done;
> + int type;
>=20=20
>=20- percpu_down_read(&swapon_rwsem);
> -start_over:
> - plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> - percpu_up_read(&swapon_rwsem);
> - if (get_swap_device_info(si)) {
> - if (si->flags & SWP_PAGE_DISCARD)
> - ret =3D swap_do_scheduled_discard(si);
> - put_swap_device(si);
> + for (;;) {
> + candidate =3D NULL;
> + percpu_down_read(&swapon_rwsem);
> + for (i =3D 0; i < swap_queue_len && !candidate; i++) {
> + struct swap_prio_ring *ring =3D swap_queue[i];
> +
> + for (j =3D 0; j < ring->size; j++) {
> + si =3D swap_device_unmask_ptr(READ_ONCE(ring->dev[j]));
> + type =3D si->type;
> + if (test_bit(type, discarded) || test_bit(type, checked))
> + continue;
> + __set_bit(type, checked);
> + if ((READ_ONCE(si->flags) & (SWP_WRITEOK | SWP_PAGE_DISCARD)) !=3D
> + (SWP_WRITEOK | SWP_PAGE_DISCARD))
> + continue;
> + if (get_swap_device_info(si)) {
> + candidate =3D si;
> + break;
> + }
> + }
>  }
> - if (ret)
> - return true;
> + percpu_up_read(&swapon_rwsem);
> + if (!candidate)
> + return false;
>=20=20
>=20- percpu_down_read(&swapon_rwsem);
> - if (plist_node_empty(&next->list))
> - goto start_over;
> + type =3D candidate->type;
> + done =3D swap_discard_one_cluster(candidate);
> + if (done)
> + __set_bit(type, discarded);
> + put_swap_device(candidate);
> + if (done)
> + return true;
>  }
> - percpu_up_read(&swapon_rwsem);
> -
> - return false;
>  }
>=20=20
>=20 static int swap_extend_table_alloc(struct swap_info_struct *si,
> @@ -2213,12 +2234,16 @@ int folio_alloc_swap(struct folio *folio)
>  }
>  }
>=20=20
>=20-again:
>  swap_alloc_entry(folio);
>=20=20
>=20 if (!order && unlikely(!folio_test_swapcache(folio))) {
> - if (swap_sync_discard())
> - goto again;
> + DECLARE_BITMAP(discarded, MAX_SWAPFILES) =3D {};
> +
> + while (swap_discard_for_alloc(discarded)) {
> + swap_alloc_entry(folio);
> + if (folio_test_swapcache(folio))
> + break;
> + }
>  }
>=20=20
>=20 /* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL.=
 */
>

