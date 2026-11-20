Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E352C606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hlRCOcXz
Received: by kanga.kvack.org (Postfix)
	id C036F6B0737; Thu, 19 Nov 2026 23:34:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDBD46B0756; Thu, 19 Nov 2026 23:34:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA416B0757; Thu, 19 Nov 2026 23:34:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 793566B0737
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:34:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA11940CF6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:34:32 +0000 (UTC)
X-FDA: 85454231184.16.3A9374D
Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	by imf31.hostedemail.com (Postfix) with ESMTP id B134C20007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:34:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hlRCOcXz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149271;
	b=74lDWpwfkRxDmZtTzz51uasa7IXzgKdmP5uDM3zXzvq3Xr/zCYaDDUxgX5QqBYPWZkZjpy
	lrbDBM+gcdNw5JODl0IQIuI9l0kFz+cSc1qmjR64NyICEuOyUmuEKLbpjJWsOdpvcpkBAT
	6hcrd9CdNI/mxkSIgaMvDXHk8xmR0qo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9dBqvHyHznWM3Q/5uzq2uunTkiOERUsMjlDj9BCdQw=;
	b=dv5PUmY4hrZVmAioVdRA9IfBsNDGJy6taPiHUEteB5KTLW5XDNbX5Bt+rMdw+vlTYdqR1t
	aZiqRnbU2glw/D+5CEQUIFOP6RUkSSx7Prb0QBlNuZEGO1tIXP+soVoqpjOdE4ocF6lCij
	BRnrogm3JKUX6OF1zd+CpAKdGcB6/VU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hlRCOcXz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y4U+KukH85DSY0yy6zTGpCe5wa7HDu6y6E3byD4hF98=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149269; v=1; x=1795754069;
 b=hlRCOcXz4x3fPoq317dvt2Gi8H1q+Sdg4TlT1vIySKEugEBewwqhMs63wwYE3RZ3jUD/Zevw
 0gEml7fOhfWrgiaAPIKyd+KV599omdX+WwmhTezWl1mAJDGm0m9hD2Na4ZG3bBWoJ4X0r0U1nyH
 TvvUVLqOmhCl1sEPJvojHUpw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8a8d7171f52c3934;
	Fri, 20 Nov 2026 04:34:29 +0000
X-Mizu-Trace-ID: 8a8d7171f52c3934
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:34:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <f53b388e1bcf6840457fe5041e989a3c0d0cc4df@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 10/18] mm/swap: add priority queue for swap device
 allocation
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <62dce3641b589e9cd42edccf0d4e9b31e7d91e36.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <62dce3641b589e9cd42edccf0d4e9b31e7d91e36.1794666741.git.lianux.mm@gmail.com>
X-Rspamd-Queue-Id: B134C20007
X-Stat-Signature: wnbemucz1u98r55y3fjbm5zsb5cny837
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795149270-541129
X-HE-Meta: U2FsdGVkX1+YMspoi7U6O/VoJad8nSVCEjMt0adMdmsKfaFUCmOjohfArtiLlCbVHzplLri1ju2c9ehaNHuEU12vVJ9gHk+Dbtdi40mHusHfLV0Hxp2TlNifw7OGJBMvjeoIABP6tojdid+Ka7M2NFdVc0zjwgCVY4dfXDI0dQHxZlncT4C/eLKUfiejugEsMBP1J3JxNFf300NIa+GGN7PuGEqG5s21wzxLry4qkFaq/bR1+VsCktyTy7iIKfJw5VozZuF1bWL57IHJ4rSsnhnvo7ogYDUsdjGAkzI62QxUQ/JMgI9h4WLbDQwKhE/NAdaO9A9ud5OQ+gP12AfoKRsm2DOk0noL9XSQUXKmX5uFQ2UCQ3q22R58Y3pQFR6EuLedZ2lSM0fagLe6Gdwn1WD7AwcGn6gg9f4R/y5s4qLobFH6hKxGa3/O8ayCJy+IzYi54cZPcSvs8ZEVjVZVJENK2fVNn3h/lepwZb85V4xgIp/J8xq8Q4Sp87TWMefCLYCsmbRjywglyY8uZr9QRFe+8tTedbspkoQpv2v1d+qwzL/h4ufpqN3/jZ1r1DT5hV9LIngy2BYGwoHi1yUpRr9oDb8a17XitUTlDur6baNmvyXLAdEEk0yIob7Yn2Am7BEC3F4v0aFz8U4wDfjBaddZY0zrlTodU+Anf60zsjVxgz/YjiQdZqPM4nu8Tq3z866JebCSb2AV44aox8PwD1tv4xBNKkgf5QGPEtGlNRBsVNsBIQH2CmafGSA70W8CoRaV5MlNv6a47/L5K1Mw/SKz+fYGydn5sbYVXq8PIGmlWYDx5ZTlFYLuxO1H22Fiup/F+fxl9d96Qh8oDqRb6gceRRZV7GN20J3cmlhnV0UDehQGjW9WVkEZyRjHpnwuMTMSHSHu393MvsDuWUTmS6dbKMdzTevP5Q4/ZKToFgsKd0hz7d0ur2L3IPaEdCouNok/0inBoXPqZWe2ECi
 8MQuA/9s
 AnLi/A02WvORpdan0wh+kVVp6QoGdqlrdUwd1HdQ6vkOrciqbsdiJu6xbCt4cfEtf8JYDdsrSnpiI2gtFD4IMjSckK0EDJcZZpsI0oNTTzW9DBXvcZQPbMoDCAWI5H2SOkXlxnGDggbQC2EuHnF7PaazVB0PoHFH2BD1Tv2QKXfiROjEw0xUD2rKhFmh3Qutlck80theGu4K6C9CL1MJ96H3N0yVWpqaxomnNyINXsvibOawiXDAu2fBFIeiXo1bTTisNJJLVlLJDSft6JHGgYwa/x3Qjpx4s9KxrcT2ylvV2Jj7DBbcN0zhMoeWlQGDgWI5uOoEfjnOgZqcPub7PiLi3FxANpp+Neo4UaDyA+G1+Z9pzY6TefXlpDldV3uJhjeolVQMM5IXFfBi8PETD5iSHbo8y2nYzzQtQfk3Trta4a5sFv5LCRpLFU1x3VWSbkVJQNfS6/E7KmJD4XvUOZgJyInV/CsrEjCAKHqq9LhAKaJ9Bpz0LgShz7UKsw1NrJsM54qrlnTG1FR1Bjko3yjA2SLYDcaTrrsOVI/wX4kDWU5W5k7XNYGy+3vzp2W8W3einLw+yFMFl5jNqo40LAGHmw/+YfCj15Nhaq9s+r4IAT85RxSDXtMUojtU9p0jn8iaz2rLWVTgk0gWC1ZVCDn6rIJb1K2/HcYwMgIzkt9c8oqejrJxNRS5W6A==
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
>=20Swap device selection rotates swap_avail_head with plist_requeue(),
> serializing cluster transitions on swap_avail_lock. Separate selection
> from device-local cluster allocation with same-priority device rings
> ordered from highest priority to lowest.
>=20
>=20Keep membership and sizes stable under swapon_rwsem during each
> allocation walk. Full or disabled devices remain as masked pointers.
> Serialize tag writers with swap_queue_update_lock and use READ_ONCE()
> and WRITE_ONCE() for complete tagged-pointer accesses.
>=20
>=20Each CPU has a starting offset and base-page quota per ring. A task-l=
ocal
> cursor snapshots its starting device so retries visit every peer once,
> even if another task changes the shared reader. Disable migration acros=
s
> the sleepable walk. Large folios retry same-priority peers before askin=
g
> the caller to split instead of falling through after one fragmented
> device.
>=20
>=20Prepare reader storage with GFP_NOIO outside the topology writer, the=
n
> recheck priority and required length before publication. Transfer the
> prepared storage only on successful installation; otherwise free it
> after unlocking. Keep per-CPU backing allocation outside the writer's
> noreclaim scope because it filters caller GFP flags. Constrain small
> queue/ring allocations with a scoped noreclaim context and
> __GFP_NOMEMALLOC, restoring context before cleanup. Deletion keeps read=
er
> storage until replacement or an empty queue, avoiding shrinking backing
> allocations beneath the writer.
>=20
>=20These boundaries prevent queue updates from reclaiming into a swap
> allocation that would acquire a reader behind the same writer. The
> cluster metadata fallback also avoids direct reclaim while the walk
> retains its outer reader. These recursive paths were identified by
> source inspection rather than reproduced hangs.
>=20
>=20Publish swap_file, the live reference, queue membership and SWP_WRITE=
OK
> under the same writer. Complete the disable flag and queue mask
> transition before releasing that writer, so a new allocation reader
> cannot select a device that is no longer writable.
>=20
>=20Mask the off-list flag from the old in-use counter before its full-de=
vice
> comparison so concurrent freeing/refilling keeps availability state
> consistent.
>=20
>=20Keep the old available plist in parallel while migrating its remainin=
g
> consumers.
>=20
>=20Link: https://lore.kernel.org/20260714-swap-pcp-priq-v1-9-de9b164ed41=
9@tencent.com
> Link: https://lore.kernel.org/alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330
> Link: https://lore.kernel.org/77d6da3d-10af-49a1-a356-72aa8b462e85@gmai=
l.com
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  include/linux/swap.h | 3 +-
>  mm/swapfile.c | 580 ++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 518 insertions(+), 65 deletions(-)
>=20
>=20diff --git a/include/linux/swap.h b/include/linux/swap.h
> index c8a5684b2f4f..6f32de173fb9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -196,7 +196,8 @@ struct swap_extent {
>  * - SWP_USED: Protected by swapon_rwsem. Indicates the device is inuse=
. Once
>  * set, won't be cleared unless all reference to this device is freed a=
nd
>  * swapoff finished.
> - * - SWP_WRITEOK: Protected by swapon_rwsem, si->lock and swap_avail_l=
ock.
> + * - SWP_WRITEOK: Protected by swapon_rwsem, si->lock and
> + * swap_queue_update_lock.
>  * Clearing this flag is followed by waiting for all current cluster lo=
ck
>  * users to exit, so
>  * checking this flag while holding any of these locks ensures the devi=
ce
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index fae862fc873c..21d27da95898 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -55,12 +55,14 @@ static bool folio_swapcache_freeable(struct folio *=
folio);
>  static void move_cluster(struct swap_info_struct *si,
>  struct swap_cluster_info *ci, struct list_head *list,
>  enum swap_cluster_flags new_flags);
> +static bool get_swap_device_info(struct swap_info_struct *si);
>=20=20
>=20 /*
>  * Serializes swapon/swapoff (writers) and protects the swap_info
>  * array, nr_swapfiles, total_swap_pages, and part of swap device
> - * info content (see comment of swap_info_struct). Read-side users
> - * take percpu_down_read() while inspecting this protected state.
> + * info content (see comment of swap_info_struct). Readers
> + * (allocation, /proc/swaps, etc.) take percpu_down_read() which
> + * is cheap as the hot path.
>  */
>  DEFINE_STATIC_PERCPU_RWSEM(swapon_rwsem);
>  /*
> @@ -159,18 +161,437 @@ static struct swap_info_struct *swap_entry_to_in=
fo(swp_entry_t entry)
>  return swap_type_to_info(swp_type(entry));
>  }
>=20=20
>=20+/*
> + * All available swap_info_structs are grouped by priority rings, the =
rings
> + * are ordered in a queue by priority (higher prio value =3D higher pr=
iority).
> + * The allocator iterates and rotates devices within each priority rin=
g.
> + * When all devices in a ring are iterated, it goes to the next lower
> + * priority ring.
> + */
> +struct swap_prio_ring {
> + int prio;
> + unsigned int size;
> + struct swap_info_struct *dev[] __counted_by(size);
> +};
> +
> +/*
> + * The ring is protected by swapon_rwsem so updating it is costly. To =
make
> + * the allocator and other users skip full devices faster, the lowest =
bit of
> + * a device pointer is used to mark it disabled (temporarily unavailab=
le).
> + * This relies on the natural alignment of struct swap_info_struct.
> + */
> +#define SWAP_DEVICE_MASKED_SHIFT 0
> +#define SWAP_DEVICE_MASKED_BIT BIT(SWAP_DEVICE_MASKED_SHIFT)
> +static_assert(__alignof__(struct swap_info_struct) >=3D 2);
> +
> +/*
> + * Serializes queue content mutations and keeps SWAP_USAGE_OFFLIST_BIT
> + * consistent with the masked state of each device pointer.
> + */
> +static DEFINE_SPINLOCK(swap_queue_update_lock);
> +
> +/*
> + * Swap queue is protected by both swap_queue_update_lock and swapon_r=
wsem.
> + * Only swapon/swapoff will take the write lock, and modify the queue =
length
> + * or any ring's length. swap_queue_update_lock protects the content s=
o
> + * devices can be masked easily without taking the writelock, which is=
 heavy.
> + */
> +static struct swap_prio_ring **swap_queue;
> +static unsigned int swap_queue_len;
> +
> +/*
> + * Each CPU has its read iterator, so the queue itself will remain rea=
d
> + * only and the CPU side reader rotates by iterating the devices
> + * periodically using the counter.
> + */
> +#define SWAP_ROUND_ROBIN_QUOTA SWAPFILE_CLUSTER
> +struct swap_ring_iterator {
> + int offset;
> + long rr_counter;
> +};
> +
> +struct swap_queue_reader {
> + local_lock_t lock;
> + struct swap_ring_iterator ri[];
> +};
> +
> +struct swap_queue_cursor {
> + bool valid;
> + bool ring_only;
> + unsigned int ring_idx;
> + unsigned int offset;
> +};
> +
> +static __percpu struct swap_queue_reader *swap_queue_readers;
> +
> +static inline bool swap_device_masked(struct swap_info_struct *si)
> +{
> + return (unsigned long)si & SWAP_DEVICE_MASKED_BIT;
> +}
> +
> +static inline struct swap_info_struct *swap_device_mask_ptr(struct swa=
p_info_struct *si)
> +{
> + return (struct swap_info_struct *)((unsigned long)si |
> + SWAP_DEVICE_MASKED_BIT);
> +}
> +
> +static inline struct swap_info_struct *swap_device_unmask_ptr(struct s=
wap_info_struct *si)
> +{
> + return (struct swap_info_struct *)((unsigned long)si & ~SWAP_DEVICE_M=
ASKED_BIT);
> +}
> +
> +static struct swap_queue_reader __percpu *swap_queue_prealloc_readers(=
int nr_rings, gfp_t gfp)
> +{
> + struct swap_queue_reader __percpu *readers;
> +
> + if (!nr_rings)
> + return NULL;
> +
> + readers =3D __alloc_percpu_gfp(struct_size(readers, ri, nr_rings),
> + __alignof__(*readers), gfp);
> + return readers;
> +}
> +
> +static bool swap_queue_needs_readers(int prio)
> +{
> + unsigned int i;
> +
> + lockdep_assert_held_write(&swapon_rwsem);
> + for (i =3D 0; i < swap_queue_len; i++) {
> + if=20(swap_queue[i]->prio =3D=3D prio)
> + return false;
> + }
> +
> + return true;
> +}
> +
> +/*
> + * Return with swapon_rwsem held for writing, or unlocked on allocatio=
n failure.
> + * Per-CPU backing allocations may reclaim, so prepare them before pub=
lishing
> + * the device and outside the topology lock and our noreclaim scope. K=
eep NOIO
> + * because the swapon caller still holds the swapfile's inode lock.
> + */
> +static int swap_queue_lock_for_add(int prio,
> + struct swap_queue_reader __percpu **readers,
> + unsigned int *nr_readers)
> +{
> + *readers =3D NULL;
> + *nr_readers =3D 0;
> + for (;;) {
> + percpu_down_write(&swapon_rwsem);
> + if (!swap_queue_needs_readers(prio) ||
> + *nr_readers > swap_queue_len)
> + return 0;
> +
> + *nr_readers =3D swap_queue_len + 1;
> + percpu_up_write(&swapon_rwsem);
> + free_percpu(*readers);
> + *readers =3D swap_queue_prealloc_readers(*nr_readers, GFP_NOIO);
> + if (!*readers)
> + return -ENOMEM;
> + }
> +}
> +
> +static void swap_queue_reset_readers(void)
> +{
> + int ring_idx, cpu;
> + struct swap_prio_ring *ring;
> +
> + lockdep_assert_held_write(&swapon_rwsem);
> + /* A new topology starts a fresh, distributed rotation on every CPU. =
*/
> + for_each_possible_cpu(cpu) {
> + for (ring_idx =3D 0; ring_idx < swap_queue_len; ring_idx++) {
> + ring =3D swap_queue[ring_idx];
> + per_cpu_ptr(swap_queue_readers, cpu)->ri[ring_idx].offset =3D
> + cpu % ring->size;
> + per_cpu_ptr(swap_queue_readers, cpu)->ri[ring_idx].rr_counter =3D
> + SWAP_ROUND_ROBIN_QUOTA;
> + }
> + }
> +}
> +
> +static void swap_queue_install_readers(struct swap_queue_reader __perc=
pu *readers)
> +{
> + int cpu;
> +
> + lockdep_assert_held_write(&swapon_rwsem);
> + free_percpu(swap_queue_readers);
> + swap_queue_readers =3D readers;
> + if (!readers)
> + return;
> +
> + for_each_possible_cpu(cpu)
> + local_lock_init(&per_cpu_ptr(readers, cpu)->lock);
> + swap_queue_reset_readers();
> +}
> +
> +static struct swap_info_struct *swap_queue_get_device(long nr_alloc, i=
nt nr_iter,
> + struct swap_queue_cursor *cursor)
> +{
> + bool rotate =3D false;
> + struct swap_info_struct *si;
> + struct swap_ring_iterator *ri;
> + struct swap_prio_ring *ring;
> + unsigned int dev_idx, queue_idx;
> +
> + if (!swap_queue_len)
> + return ERR_PTR(-ENOENT);
> +
> + queue_idx =3D 0;
> + while (nr_iter >=3D swap_queue[queue_idx]->size) {
> + nr_iter -=3D swap_queue[queue_idx]->size;
> + if (++queue_idx >=3D swap_queue_len)
> + return ERR_PTR(cursor->ring_only ? -E2BIG : -ENOENT);
> + }
> + if (cursor->ring_only && cursor->ring_idx !=3D queue_idx)
> + return ERR_PTR(-E2BIG);
> +
> + ring =3D swap_queue[queue_idx];
> + local_lock(&swap_queue_readers->lock);
> + ri =3D this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
> + /*
> + * Snapshot the starting offset for this allocation's walk. The shared
> + * iterator can move between retries, but the cursor must visit every
> + * device in the ring exactly once before falling through.
> + */
> + if (!cursor->valid || cursor->ring_idx !=3D queue_idx) {
> + cursor->valid =3D true;
> + cursor->ring_idx =3D queue_idx;
> + if (ri->rr_counter < nr_alloc)
> + rotate =3D true;
> + else if (ri->offset >=3D ring->size)
> + rotate =3D true;
> + if (rotate) {
> + ri->offset++;
> + ri->offset %=3D ring->size;
> + ri->rr_counter =3D SWAP_ROUND_ROBIN_QUOTA;
> + }
> + cursor->offset =3D ri->offset;
> + }
> +
> + dev_idx =3D (cursor->offset + nr_iter) % ring->size;
> + if (nr_iter) {
> + ri->offset =3D dev_idx;
> + ri->rr_counter =3D SWAP_ROUND_ROBIN_QUOTA;
> + }
> + ri->rr_counter -=3D nr_alloc;
> + si =3D READ_ONCE(ring->dev[dev_idx]);
> + local_unlock(&swap_queue_readers->lock);
> +
> + if (swap_device_masked(si))
> + return ERR_PTR(-EBUSY);
> +
> + si =3D swap_device_unmask_ptr(si);
> + return si;
> +}
> +
> +static bool swap_queue_find(struct swap_info_struct *si,
> + unsigned int *ring_idx, unsigned int *dev_idx)
> +{
> + unsigned int i, j;
> + struct swap_prio_ring *ring;
> +
> + lockdep_assert(lockdep_is_held(&swapon_rwsem) ||
> + lockdep_is_held(&swap_queue_update_lock));
> +
> + for (i =3D 0; i < swap_queue_len; i++) {
> + ring =3D swap_queue[i];
> + if (ring->prio !=3D si->prio)
> + continue;
> + for (j =3D 0; j < ring->size; j++) {
> + if (swap_device_unmask_ptr(READ_ONCE(ring->dev[j])) !=3D si)
> + continue;
> + *ring_idx =3D i;
> + *dev_idx =3D j;
> + return true;
> + }
> + }
> + return false;
> +}
> +
> +static void swap_queue_mask(struct swap_info_struct *si)
> +{
> + unsigned int ring_idx, dev_idx;
> +
> + lockdep_assert_held(&swap_queue_update_lock);
> + if (swap_queue_find(si, &ring_idx, &dev_idx))
> + WRITE_ONCE(swap_queue[ring_idx]->dev[dev_idx],
> + swap_device_mask_ptr(si));
> +}
> +
> +static void swap_queue_unmask(struct swap_info_struct *si)
> +{
> + unsigned int ring_idx, dev_idx;
> +
> + lockdep_assert_held(&swap_queue_update_lock);
> + if (swap_queue_find(si, &ring_idx, &dev_idx))
> + WRITE_ONCE(swap_queue[ring_idx]->dev[dev_idx], si);
> +}
> +
> +/* Prepared readers remain caller-owned unless installed successfully.=
 */
> +static int swap_queue_add(struct swap_info_struct *si,
> + struct swap_queue_reader __percpu **readers,
> + unsigned int nr_readers)
> +{
> + struct swap_prio_ring **new_queue =3D NULL, **old_queue =3D NULL;
> + struct swap_prio_ring *ring, *new_ring =3D NULL, *old_ring =3D NULL;
> + int prio =3D si->prio;
> + int i, pos, err =3D -ENOMEM;
> + unsigned int noreclaim_flag;
> + gfp_t gfp;
> +
> + /* A writer must not reclaim into another swap allocation. */
> + gfp =3D GFP_NOIO | __GFP_HIGH | __GFP_NOMEMALLOC;
> + lockdep_assert_held_write(&swapon_rwsem);
> + noreclaim_flag =3D memalloc_noreclaim_save();
> +
> + for (pos =3D 0; pos < swap_queue_len; pos++) {
> + if (swap_queue[pos]->prio =3D=3D prio)
> + goto add_to_ring;
> + if (swap_queue[pos]->prio < prio)
> + break;
> + }
> +
> + /* No ring at this priority: insert a new one at pos. */
> + if (!*readers || nr_readers <=3D swap_queue_len)
> + goto failed;
> + new_queue =3D kmalloc_array(swap_queue_len + 1, sizeof(*swap_queue), =
gfp);
> + if (!new_queue)
> + goto failed;
> + new_ring =3D kmalloc(struct_size(new_ring, dev, 1), gfp);
> + if (!new_ring)
> + goto failed;
> + if (!get_swap_device_info(si))
> + goto failed;
> +
> + new_ring->prio =3D prio;
> + new_ring->size =3D 1;
> + new_ring->dev[0] =3D si;
> + for (i =3D 0; i < pos; i++)
> + new_queue[i] =3D swap_queue[i];
> + new_queue[pos] =3D new_ring;
> + for (i =3D pos; i < swap_queue_len; i++)
> + new_queue[i + 1] =3D swap_queue[i];
> +
> + spin_lock(&swap_queue_update_lock);
> + old_queue =3D swap_queue;
> + swap_queue =3D new_queue;
> + swap_queue_len++;
> + spin_unlock(&swap_queue_update_lock);
> + memalloc_noreclaim_restore(noreclaim_flag);
> + kfree(old_queue);
> +
> + swap_queue_install_readers(*readers);
> + *readers =3D NULL;
> + return 0;
> +
> +add_to_ring:
> + ring =3D swap_queue[pos];
> + new_ring =3D kmalloc(struct_size(ring, dev, ring->size + 1), gfp);
> + if (!new_ring)
> + goto failed;
> + if (!get_swap_device_info(si))
> + goto failed;
> + spin_lock(&swap_queue_update_lock);
> + memcpy(new_ring, ring, struct_size(ring, dev, ring->size));
> + new_ring->size++;
> + new_ring->dev[new_ring->size - 1] =3D si;
> + old_ring =3D swap_queue[pos];
> + swap_queue[pos] =3D new_ring;
> + spin_unlock(&swap_queue_update_lock);
> + memalloc_noreclaim_restore(noreclaim_flag);
> + kfree(old_ring);
> + return 0;
> +
> +failed:
> + memalloc_noreclaim_restore(noreclaim_flag);
> + kfree(new_queue);
> + kfree(new_ring);
> + return err;
> +}
> +
> +static void swap_queue_del(struct swap_info_struct *si)
> +{
> + gfp_t gfp;
> + unsigned int noreclaim_flag;
> + unsigned int ring_idx, dev_idx;
> + struct swap_prio_ring *ring, *new_ring =3D NULL, *old_ring =3D NULL;
> + struct swap_prio_ring **new_queue =3D NULL, **old_queue =3D NULL;
> +
> + lockdep_assert_held_write(&swapon_rwsem);
> + if (!swap_queue_find(si, &ring_idx, &dev_idx)) {
> + WARN_ON(1);
> + return;
> + }
> +
> + /*
> + * Shrinking the small topology arrays is optional. Keep reader storag=
e
> + * until a new priority is inserted or the queue is empty: per-CPU
> + * allocation must not run under this writer's noreclaim scope, which
> + * can grant backing pages reserve access.
> + */
> + gfp =3D GFP_NOIO | __GFP_HIGH | __GFP_NOMEMALLOC;
> + noreclaim_flag =3D memalloc_noreclaim_save();
> + ring =3D swap_queue[ring_idx];
> + if (ring->size > 1)
> + new_ring =3D kmalloc(struct_size(ring, dev, ring->size - 1), gfp);
> + if (ring->size =3D=3D 1 && swap_queue_len > 1) {
> + new_queue =3D kmalloc(sizeof(*swap_queue) *
> + (swap_queue_len - 1), gfp);
> + }
> + memalloc_noreclaim_restore(noreclaim_flag);
> +
> + spin_lock(&swap_queue_update_lock);
> + if (ring->size > 1) {
> + /* Shift trailing devices left to fill the gap. */
> + while (++dev_idx < ring->size)
> + ring->dev[dev_idx - 1] =3D
> + ring->dev[dev_idx];
> + ring->size--;
> + if (new_ring) {
> + memcpy(new_ring, ring,
> + struct_size(ring, dev, ring->size));
> + old_ring =3D ring;
> + swap_queue[ring_idx] =3D new_ring;
> + }
> + } else {
> + /* Last device in this ring: remove the ring. */
> + old_ring =3D ring;
> + swap_queue_len--;
> + while (++ring_idx <=3D swap_queue_len)
> + swap_queue[ring_idx - 1] =3D
> + swap_queue[ring_idx];
> + if (new_queue) {
> + memcpy(new_queue, swap_queue,
> + sizeof(*swap_queue) * swap_queue_len);
> + old_queue =3D swap_queue;
> + swap_queue =3D new_queue;
> + } else if (!swap_queue_len) {
> + old_queue =3D swap_queue;
> + swap_queue =3D NULL;
> + }
> + if (!swap_queue_len)
> + swap_queue_install_readers(NULL);
> + }
> + spin_unlock(&swap_queue_update_lock);
> +
> + kfree(old_ring);
> + kfree(old_queue);
> + put_swap_device(si);
> +}
> +
>  /*
>  * Use the second highest bit of inuse_pages counter as the indicator
> - * if one swap device is on the available plist, so the atomic can
> + * if one swap device is unavailable for allocation, so the atomic can
>  * still be updated arithmetically while having special data embedded.
>  *
>  * inuse_pages counter is the only thing indicating if a device should
> - * be on avail_lists or not (except swapon / swapoff). By embedding th=
e
> - * off-list bit in the atomic counter, updates no longer need any lock
> - * to check the list status.
> + * be in the available queue or not (except swapon / swapoff). By
> + * embedding the off-list bit in the atomic counter, updates no longer
> + * need any lock to check the list status.
>  *
> - * This bit will be set if the device is not on the plist and not
> - * usable, will be cleared if the device is on the plist.
> + * This bit will be set if the device is not in the available queue
> + * and not usable, will be cleared if the device is in the queue.
>  */
>  #define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_long_t) -=
 2))
>  #define SWAP_USAGE_COUNTER_MASK (~SWAP_USAGE_OFFLIST_BIT)
> @@ -611,11 +1032,11 @@ swap_cluster_populate(struct swap_info_struct *s=
i,
>  return ci;
>=20=20
>=20 /*
> - * Drop the device and cluster locks before retrying. Metadata allocat=
ion
> - * must not recurse into swap allocation through direct reclaim: calle=
rs
> - * can retain outer synchronization across cluster population. Restric=
t
> - * this request instead of granting the task PF_MEMALLOC, which could
> - * give allocator hooks and failure cleanup reserve access.
> + * Retry with the local and cluster locks dropped. The allocator can
> + * still hold swapon_rwsem for reading: direct reclaim could enter
> + * swap allocation again while a writer is waiting for this reader.
> + * Restrict this request instead of granting the task PF_MEMALLOC,
> + * which could give allocator hooks and failure cleanup reserve access=
.
>  */
>  spin_unlock(&ci->lock);
>  if (si->flags & SWP_SOLIDSTATE)
> @@ -1293,6 +1714,7 @@ static void del_from_avail_list(struct swap_info_=
struct *si, bool swapoff)
>  unsigned long pages;
>=20=20
>=20 spin_lock(&swap_avail_lock);
> + spin_lock(&swap_queue_update_lock);
>=20=20
>=20 /*
>  * Force remove it only for swapoff. Else, take it off-list only if
> @@ -1313,9 +1735,10 @@ static void del_from_avail_list(struct swap_info=
_struct *si, bool swapoff)
>  atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>  }
>=20=20
>=20+ swap_queue_mask(si);
>  plist_del(&si->avail_list, &swap_avail_head);
> -
>  skip:
> + spin_unlock(&swap_queue_update_lock);
>  spin_unlock(&swap_avail_lock);
>  }
>=20=20
>=20@@ -1326,12 +1749,12 @@ static void add_to_avail_list(struct swap_inf=
o_struct *si)
>  unsigned long pages;
>=20=20
>=20 spin_lock(&swap_avail_lock);
> + spin_lock(&swap_queue_update_lock);
>=20=20
>=20 /*
> - * Add the device to the avail list if SWP_WRITEOK is set and
> - * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
> - * SWP_WRITEOK first, so the device won't be re-added after
> - * swapoff starts unless swap_device_enable resurrects it.
> + * Mark the device as avail if SWP_WRITEOK is set. Swapoff clears
> + * SWP_WRITEOK first, so check that first so the device won't be
> + * re-added after swapoff started.
>  */
>  if (!(si->flags & SWP_WRITEOK))
>  goto skip;
> @@ -1342,21 +1765,23 @@ static void add_to_avail_list(struct swap_info_=
struct *si)
>  val =3D atomic_long_fetch_and_relaxed(~SWAP_USAGE_OFFLIST_BIT, &si->in=
use_pages);
>=20=20
>=20 /*
> - * When device is full and device is on the plist, only one updater wi=
ll
> - * see (inuse_pages =3D=3D si->pages) and will call del_from_avail_lis=
t. If
> - * that updater happen to be here, just skip adding.
> + * When device is full and marked as available, one reader will see
> + * (inuse_pages =3D=3D si->pages) and should mark it as unavailable an=
d
> + * set SWAP_USAGE_OFFLIST_BIT. If that updater happens to be here, jus=
t
> + * skip the rest.
>  */
>  pages =3D si->pages;
> - if (val =3D=3D pages) {
> + if ((val & SWAP_USAGE_COUNTER_MASK) =3D=3D pages) {

Could you split this fix out ahead of the queue conversion? The old
plist code needs it too, since val still has SWAP_USAGE_OFFLIST_BIT set.

Thanks,
Kunwu


>  /* Just like the cmpxchg in del_from_avail_list */
>  if (atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
>  pages | SWAP_USAGE_OFFLIST_BIT))
>  goto skip;
>  }
>=20=20
>=20+ swap_queue_unmask(si);
>  plist_add(&si->avail_list, &swap_avail_head);
> -
>  skip:
> + spin_unlock(&swap_queue_update_lock);
>  spin_unlock(&swap_avail_lock);
>  }
>=20=20
>=20@@ -1373,7 +1798,7 @@ static void swap_device_inuse_add(struct swap_i=
nfo_struct *si,
>=20=20
>=20 /*
>  * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
> - * remove it from the plist.
> + * mark it unavailable.
>  */
>  inuse_pages =3D atomic_long_add_return_relaxed(nr_entries, &si->inuse_=
pages);
>  if (unlikely(inuse_pages =3D=3D si->pages)) {
> @@ -1415,7 +1840,7 @@ static void swap_device_inuse_sub(struct swap_inf=
o_struct *si, unsigned long off
>=20=20
>=20 /*
>  * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
> - * add it back to the plist.
> + * add it back to the available queue.
>  */
>  inuse_pages =3D atomic_long_sub_return_relaxed(nr_entries, &si->inuse_=
pages);
>  if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
> @@ -1438,41 +1863,44 @@ static bool get_swap_device_info(struct swap_in=
fo_struct *si)
>  return true;
>  }
>=20=20
>=20-/* Rotate the device and switch to a new cluster */
> -static void swap_alloc_entry(struct folio *folio)
> +static int swap_alloc_entry(struct folio *folio)
>  {
> - struct swap_info_struct *si, *next;
> + struct swap_queue_cursor cursor =3D {};
> + long nr_pages =3D folio_nr_pages(folio);
> + struct swap_info_struct *si;
> + int nr_iter, ret;
>=20=20
>=20- spin_lock(&swap_avail_lock);
> -start_over:
> - plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> - /* Rotate the device and switch to a new cluster */
> - plist_requeue(&si->avail_list, &swap_avail_head);
> - spin_unlock(&swap_avail_lock);
> - if (get_swap_device_info(si)) {
> - cluster_alloc_swap_entry(si, folio);
> - put_swap_device(si);
> - if (folio_test_swapcache(folio))
> - return;
> - if (folio_test_large(folio))
> - return;
> + percpu_down_read(&swapon_rwsem);
> + migrate_disable();
> + for (nr_iter =3D 0;; nr_iter++) {
> + si =3D swap_queue_get_device(nr_pages, nr_iter, &cursor);
> + if (IS_ERR(si)) {
> + ret =3D PTR_ERR(si);
> + if (ret =3D=3D -EBUSY)
> + continue;
> + break;
> + }
> + cluster_alloc_swap_entry(si, folio);
> +
> + if (folio_test_swapcache(folio)) {
> + ret =3D 0;
> + break;
>  }
>=20=20
>=20- spin_lock(&swap_avail_lock);
>  /*
> - * if we got here, it's likely that si was almost full before,
> - * multiple callers probably all tried to get a page from the
> - * same si and it filled up before we could get one; or, the si
> - * filled up between us dropping swap_avail_lock.
> - * Since we dropped the swap_avail_lock, the swap_avail_list
> - * may have been modified; so if next is still in the
> - * swap_avail_head list then try it, otherwise start over if we
> - * have not gotten any slots.
> + * For large allocations, try every device at the same priority,
> + * but ask the caller to split instead of falling back to a lower
> + * priority ring.
>  */
> - if (plist_node_empty(&next->avail_list))
> - goto start_over;
> + if (folio_test_large(folio)) {
> + cursor.ring_only =3D true;
> + continue;
> + }
>  }
> - spin_unlock(&swap_avail_lock);
> +
> + migrate_enable();
> + percpu_up_read(&swapon_rwsem);
> + return ret;
>  }
>=20=20
>=20 /*
> @@ -3090,18 +3518,17 @@ static int setup_swap_extents(struct swap_info_=
struct *sis,
>  }
>=20=20
>=20 /*
> - * Mark a fully initialized swap device writable and expose it to the
> - * allocator. The caller must have resurrected its percpu ref first.
> + * Mark a fully initialized swap device writable and expose it to the =
allocator.
> + * The caller must have resurrected its percpu ref before entering thi=
s helper.
>  */
>  static void __swap_device_enable(struct swap_info_struct *si)
>  {
>  lockdep_assert_held_write(&swapon_rwsem);
>  spin_lock(&si->lock);
> - spin_lock(&swap_avail_lock);
> + spin_lock(&swap_queue_update_lock);
>  si->flags |=3D SWP_WRITEOK;
> - spin_unlock(&swap_avail_lock);
> + spin_unlock(&swap_queue_update_lock);
>  spin_unlock(&si->lock);
> -
>  atomic_long_add(si->pages, &nr_swap_pages);
>  total_swap_pages +=3D si->pages;
>  plist_add(&si->list, &swap_active_head);
> @@ -3234,6 +3661,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, sp=
ecialfile)
>  return err;
>  }
>=20=20
>=20+ percpu_down_write(&swapon_rwsem);
> + swap_queue_del(p);
> + percpu_ref_kill(&p->users);
> + percpu_up_write(&swapon_rwsem);
> +
>  /*
>  * Wait for swap operations protected by get/put_swap_device()
>  * to complete. Because of synchronize_rcu() here, all swap
> @@ -3242,7 +3674,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
>  * prevent folio_test_swapcache() and the following swap cache
>  * operations from racing with swapoff.
>  */
> - percpu_ref_kill(&p->users);
>  synchronize_rcu();
>  wait_for_completion(&p->comp);
>=20=20
>=20@@ -3708,6 +4139,8 @@ static int setup_swap_clusters_info(struct swap=
_info_struct *si,
>  SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_fl=
ags)
>  {
>  struct swap_info_struct *si;
> + struct swap_queue_reader __percpu *readers;
> + unsigned int nr_readers;
>  struct file *swap_file =3D NULL;
>  struct address_space *mapping;
>  struct dentry *dentry;
> @@ -3894,14 +4327,33 @@ SYSCALL_DEFINE2(swapon, const char __user *, sp=
ecialfile, int, swap_flags)
>  si->prio =3D prio;
>  si->list.prio =3D -si->prio;
>  si->avail_list.prio =3D -si->prio;
> - /* Publish the file, live reference and writable state together. */
> - percpu_down_write(&swapon_rwsem);
> - si->swap_file =3D swap_file;
>=20=20
>=20- /* Make the reference live before exposing the writable device. */
> + /*
> + * Publish swap_file before making the percpu ref live, then add the d=
evice
> + * to the queue and make it writable under the same write-side lock. T=
his
> + * keeps lockless ref users and /proc/swaps from observing partial sta=
te.
> + */
> + error =3D swap_queue_lock_for_add(prio, &readers, &nr_readers);
> + if (error) {
> + inode->i_flags &=3D ~S_SWAPFILE;
> + goto free_swap_zswap;
> + }
> + si->swap_file =3D swap_file;
>  percpu_ref_resurrect(&si->users);
> - __swap_device_enable(si);
> + error =3D swap_queue_add(si, &readers, nr_readers);
> + if (error) {
> + si->swap_file =3D NULL;
> + percpu_ref_kill(&si->users);
> + } else {
> + __swap_device_enable(si);
> + }
>  percpu_up_write(&swapon_rwsem);
> + free_percpu(readers);
> + if (error) {
> + wait_for_completion(&si->comp);
> + inode->i_flags &=3D ~S_SWAPFILE;
> + goto free_swap_zswap;
> + }
>=20=20
>=20 pr_info("Adding %uk swap on %s. Priority:%d extents:%d across:%lluk =
%s%s%s%s\n",
>  K(si->pages), name->name, si->prio, nr_extents,
>

