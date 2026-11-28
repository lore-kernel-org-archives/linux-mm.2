Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFE6606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 11:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GMSUys6A
Received: by kanga.kvack.org (Postfix)
	id 8AD536B05B0; Sat, 28 Nov 2026 06:13:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837326B05B1; Sat, 28 Nov 2026 06:13:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7D16B05B2; Sat, 28 Nov 2026 06:13:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E88816B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:13:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6559D80642
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 11:13:48 +0000 (UTC)
X-FDA: 85484267736.16.4BE4E3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8153DA0005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 11:13:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMSUys6A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795864426;
	b=HBHTSwtuSF0SpBKLIDhUIdDqfkJpA9wYup53FMiusrVbiGssmZtj370N4z7W8FQYl3dYSj
	CYQnyxQxm2JVP7mwleeUSzgCswwUj3YjkwU+cVH01Wq1LqdCCCPpzU+wiOLNzeqoFsUplt
	kFn4nysjLw39BSjkEqJw6YGs+Wdi2Oc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795864426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1b24PV0DzABfWj91TpxxWK1oMIau5CHtR8Nrpem+KuQ=;
	b=8VBV+TlwEW9TbsrozBuL7cOFdESe+DhIe3S5YtCCseHGjUGHVn6ryhZBsAoy+KD8qg7dNk
	Lx7IgmNxwuacIyFCLThPpq8XrDnfZQbocZmfjGep5YI6ebdyEGPe/wiWgzg2np5IBoSTVL
	D5s1A2zeXn5Dei5Xq5Ig6FA9hqXtAqg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMSUys6A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FCE9611EC
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 11:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE841F00929
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 11:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795864425;
	bh=1b24PV0DzABfWj91TpxxWK1oMIau5CHtR8Nrpem+KuQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GMSUys6AXmlNtNbKKnemT089WTGpnhnkWDv3QSul4D+owOq5q8OQZ8r7x6bD7xmOx
	 AXnAQQmvRsK81V91Ra1ccSE3uk5YOtFqY1cSpAUHEedZQJLP1lmYafnPez+09i17DG
	 i7K8V7gDBelqlxO4Pjg20QfWaPmX3UcOmDcp1ShM18wwMd7T3AK8TBU+435y3hf0r4
	 5y3Nz3zZPyFJlYF6lnXhaHNEimTaCnVJ0h/BeKg4NVObpuM+Q+qRv4GG4Vo75RZFYE
	 ND+/VdnJvDYl/UqWisNLJQgEXHoJyWAsZp8z6ueUrkEeq7EfXQlKAKvUETAHo0jgDa
	 731OaovH3pcyg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so1473974466b.3
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:13:44 -0800 (PST)
X-Gm-Message-State: APuU4Z/3Ji9/HwWGFPyWxbeC1il6rZ4086oOW6VIBwU7YSfFnkgM1Nx8
	GklFQDUSVuUtfIrEVyNMIwmQmLDTk2kKUctzwhlM5jjw992BIL30lsGLzZ+pQocUTfv06COqhZv
	qa829t7Dx0d9g++AEWHprEbLu9eA5bE9cvJjTeR9FyQ==
X-Received: by 2002:a17:906:c413:b0:c4c:b4fe:c9f1 with SMTP id
 a640c23a62f3a-c513a9ac859mr1704196866b.35.1795864423227; Sat, 28 Nov 2026
 03:13:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <3c945c85ab8f57080afc7878ff5c6c783856fa07.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <3c945c85ab8f57080afc7878ff5c6c783856fa07.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 28 Nov 2026 03:13:31 -0800
X-Gmail-Original-Message-ID: <CACePvbVnATHp=qNwfPjJfVQtW3WZo1_W_A5wr5vwc-EoS4kGGg@mail.gmail.com>
X-Gm-Features: Aa3M54p4OpK5ZZ8j1B_LMzuyss_fi2i3Qeii1oFdvXz4l97c0tVND7bY8AL6u8w
Message-ID: <CACePvbVnATHp=qNwfPjJfVQtW3WZo1_W_A5wr5vwc-EoS4kGGg@mail.gmail.com>
Subject: Re: [PATCH v5 11/19] mm/swap: add priority queue for swap device allocation
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
X-Rspamd-Queue-Id: 8153DA0005
X-Stat-Signature: eya5otnm919k834enem91jbsqt96ggj7
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795864426-791162
X-HE-Meta: U2FsdGVkX187oRmapUk2uKm/iX3jcbd/ZjhG1Xv6XIsqMBFMEiZ02YVgiu76ifNHGRIdzgO5RmWV2rxozyQtIsYpopKMIifJchU4byQ0zGDzkvradcvec5Ua67prvA0tE75NcVKFDErIYsXfwUzofGVkSkvPyfBP9Kyv/lFtNfqJWvcFu4b9FZ2L1pYuKqjt71QQ8mLFohyJhT4Q14cpE1eh/Sp8cD2Y2L3tNSa3QnNbGdn4zyL5KTzdPkmmyeY7+PUqUXQTf3N5ukL68iMTnGCNsGqhAPiyinf+HteQN0E7KuA+mkD9EkeLJsOZMUxFE4mBWFUuJWA/LVMFuFPKYPefZTbPNwh6RvFX11tdzB5vb6/w6VCcwZYEYhCoE/RMh91z5kmyvh0Ou3XUjv+08bKFeha23UZH+xJmVKiNiHOOS+UbtKThZCcWQYJ1BT1KCrijYiUZ54K0omvwbP11siBeU0jW83Fs/rJvqTSYNacEu1AY9EKYZnq2AbGfEIllHdtWbl68UMQYAd9lIp2aK51BxhvB18s5y1WsASo3h/ZscFeFmc+lyqxA3RB7BepLvOTco3WlkBoroLbWE+Te+ErwuA7IXNprJO5yYmg8TTPcq+rLEzcCnUp+CdGew2qrEFSpK0EOJv5DJNj/UUDBYqe/0ij3JlHYHPF6gvTQtSzUSauFF6pHiX2S/6FQ3NNCpsIgVhREqJgnVR5/3MTySVlnkyWKKMAcZGRqF8XjwTkjivIT/3YTdUAAYI0T1LNYtb+3sE/+RXgpdXzE5/3WsLdRGDocTcCytvS8QAlIQbTDMOBWSOrKvDZQnbcL/dqKUqv6OmWL32nuZhL/HU6rPMwXMTeP0+CaYyhJQRBnp2aQFaE6aNAPsVKsyvMGMhKV1VysCfP4gtMHdQPxZKfSFgVPOwBlXc6BnEiEoerQEpY1ItrgZcaTVEcneEAdwzfxQl8hQ5ZdBQNOq37mX8a
 8Rn9bgk+
 M+8KWUGShkJP/O216I2IxkSlgAjJsoZG6jFvQdduf+9nZX1poZw+kaLrlNDMSFJywvkYhJBe/HsJUmhzudvjE5tSMBBTuT0kMQlPMiixnZZzPdgCqccYIbMsijJAsysafEBs7AVyB4PFC6L8abpGpNrbxiKIq/v7S6/uplHfs6CUqDTe12QjTP6uzESVMdAvZTFvV2APBQ+wSlR897BcjAK23O1LBabvWP+SDy+cbi9I2tvAvdymH/JqL5UM2Ozv9qvnKLDB40Iq3K9v9uVG8TrBxDXHZUYcKMi2RbX5VZaC9QjdKh2PdVKTII/rEOmRfWvNLMb4PfOOh83oV7V+rc//rOGApR19LBg9Ycqp2zOHVe9IO7yr0Av6H/kfb928njjLgSy/oAT+BLkhahCENiHCxainTsSteT6zJCbTvHZO1NkdyiCPyec21MJiQ/RfChYe2CqFeKlh/LnjLUSfO9yaGtRyLDBsP9SkZHE/mZTLK0Dhgt8kUci4WCOJwRKEC05p6xPoxredRNxP1Dsja5Rqw0N6474XUXJ262UPvry5ck4cA/1NqzqSd8Hby4QN7Ni1cNEDXDFZ2LIVwUyXPvMqFBrCsposURQ0JI09rzkrn5RTYAG41ewK+9wrt3ctpFK2ZGnxv6G3pG8KSJqOuJSKV+6tSK+Ve1oxYY6cbxUciJHjxl0ZduDaHRdMUGvAO5SXuCeyjC1Hve48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 6:18=E2=80=AFAM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap device selection rotates swap_avail_head with plist_requeue(),
> serializing cluster transitions on swap_avail_lock. Separate selection
> from device-local cluster allocation with same-priority device rings
> ordered from highest priority to lowest.
>
> Keep membership and sizes stable under swapon_rwsem during each
> allocation walk. Full or disabled devices remain as masked pointers.
> Serialize tag writers with swap_queue_update_lock and use READ_ONCE()
> and WRITE_ONCE() for complete tagged-pointer accesses.
>
> Each per-CPU reader holds one head per ring: a starting offset and a
> base-page quota. A task-local cursor snapshots that offset so retries
> visit every peer once even if another task advances the shared head.
> Disable migration across the sleepable walk. Large folios retry same-prio=
rity peers before asking
> the caller to split instead of falling through after one fragmented
> device.
>
> Prepare reader storage with GFP_NOIO outside the topology writer, then
> recheck priority and required length before publication. Transfer the
> prepared storage only on successful installation; otherwise free it
> after unlocking. Keep per-CPU backing allocation outside the writer's
> noreclaim scope because it filters caller GFP flags. Constrain small
> queue/ring allocations with a scoped noreclaim context and
> __GFP_NOMEMALLOC, restoring context before cleanup. Deletion keeps reader
> storage until replacement or an empty queue, avoiding shrinking backing
> allocations beneath the writer.
>
> These boundaries prevent queue updates from reclaiming into a swap
> allocation that would acquire a reader behind the same writer. The
> cluster metadata fallback also avoids direct reclaim while the walk
> retains its outer reader. These recursive paths were identified by
> source inspection rather than reproduced hangs.
>
> Publish swap_file, the live reference, queue membership and SWP_WRITEOK
> under the same writer. Complete the disable flag and queue mask
> transition before releasing that writer, so a new allocation reader
> cannot select a device that is no longer writable.
>
> Keep the old available plist in parallel while migrating its remaining
> consumers.

This patch is very complex and tricky.  It will take more time to review.

>
> Link: https://lore.kernel.org/20260714-swap-pcp-priq-v1-9-de9b164ed419@te=
ncent.com
> Link: https://lore.kernel.org/alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330
> Link: https://lore.kernel.org/77d6da3d-10af-49a1-a356-72aa8b462e85@gmail.=
com
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  include/linux/swap.h |   3 +-
>  mm/swapfile.c        | 576 ++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 515 insertions(+), 64 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index c8a5684b2f4f..6f32de173fb9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -196,7 +196,8 @@ struct swap_extent {
>   * - SWP_USED: Protected by swapon_rwsem. Indicates the device is inuse.=
 Once
>   *   set, won't be cleared unless all reference to this device is freed =
and
>   *   swapoff finished.
> - * - SWP_WRITEOK: Protected by swapon_rwsem, si->lock and swap_avail_loc=
k.
> + * - SWP_WRITEOK: Protected by swapon_rwsem, si->lock and
> + *   swap_queue_update_lock.
>   *   Clearing this flag is followed by waiting for all current cluster l=
ock
>   *   users to exit, so
>   *   checking this flag while holding any of these locks ensures the dev=
ice
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 1ef5f1ead656..1e5f88f516c1 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -55,12 +55,14 @@ static bool folio_swapcache_freeable(struct folio *fo=
lio);
>  static void move_cluster(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci, struct list_head *=
list,
>                          enum swap_cluster_flags new_flags);
> +static bool get_swap_device_info(struct swap_info_struct *si);
>
>  /*
>   * Serializes swapon/swapoff (writers) and protects the swap_info
>   * array, nr_swapfiles, total_swap_pages, and part of swap device
> - * info content (see comment of swap_info_struct). Read-side users
> - * take percpu_down_read() while inspecting this protected state.
> + * info content (see comment of swap_info_struct).  Readers
> + * (allocation, /proc/swaps, etc.) take percpu_down_read() which
> + * is cheap as the hot path.
>   */
>  DEFINE_STATIC_PERCPU_RWSEM(swapon_rwsem);
>  /*
> @@ -159,18 +161,435 @@ static struct swap_info_struct *swap_entry_to_info=
(swp_entry_t entry)
>         return swap_type_to_info(swp_type(entry));
>  }
>
> +/*
> + * All available swap_info_structs are grouped by priority rings, the ri=
ngs
> + * are ordered in a queue by priority (higher prio value =3D higher prio=
rity).
> + * The allocator iterates and rotates devices within each priority ring.
> + * When all devices in a ring are iterated, it goes to the next lower
> + * priority ring.
> + */
> +struct swap_prio_ring {
> +       int prio;
> +       unsigned int size;
> +       struct swap_info_struct *dev[] __counted_by(size);
> +};
> +
> +/*
> + * The ring is protected by swapon_rwsem so updating it is costly. To ma=
ke
> + * the allocator and other users skip full devices faster, the lowest bi=
t of
> + * a device pointer is used to mark it disabled (temporarily unavailable=
).
> + * This relies on the natural alignment of struct swap_info_struct.
> + */
> +#define SWAP_DEVICE_MASKED_SHIFT       0
> +#define SWAP_DEVICE_MASKED_BIT         BIT(SWAP_DEVICE_MASKED_SHIFT)

It took me a while to realize the MASKED bit means the swap device is
full, so no swap entry from this device is available.
Maybe rename MASKED to FULL to make it more obvious?

> +static_assert(__alignof__(struct swap_info_struct) >=3D 2);

Need to assert the size of struct swap_info_struct is also even
number. Otherwise, just getting the array start is not good enough.

> +
> +/*
> + * Serializes queue content mutations and keeps SWAP_USAGE_OFFLIST_BIT
> + * consistent with the masked state of each device pointer.
> + */
> +static DEFINE_SPINLOCK(swap_queue_update_lock);
> +
> +/*
> + * Swap queue is protected by both swap_queue_update_lock and swapon_rws=
em.
> + * Only swapon/swapoff will take the write lock, and modify the queue le=
ngth
> + * or any ring's length. swap_queue_update_lock protects the content so
> + * devices can be masked easily without taking the writelock, which is h=
eavy.
> + */
> +static struct swap_prio_ring **swap_queue;
> +static unsigned int swap_queue_len;
> +
> +/*
> + * Each CPU keeps a rotation head per priority ring. Its offset and
> + * base-page quota are shared by allocations on that CPU.
> + */
> +#define SWAP_ROUND_ROBIN_QUOTA SWAPFILE_CLUSTER
> +struct swap_queue_reader_head {
> +       int offset;
> +       long rr_counter;
> +};
> +
> +struct swap_queue_reader {
> +       local_lock_t lock;
> +       struct swap_queue_reader_head heads[];
> +};
> +
> +struct swap_queue_cursor {
> +       bool valid;
> +       bool no_fallback; /* Do not descend to a lower priority ring. */
> +       unsigned int ring_idx;
> +       unsigned int offset;
> +};

A lot of new code relate to swap_queue add to swapfile.c. I was
wondering is it possible to move the new code to swap_queue.c. The
current swapfile.c is already very big. I haven't tried that, so I
don't know whether it is too hard to move. It will have impact for the
following patch as well.

> +
> +static __percpu struct swap_queue_reader *swap_queue_readers;
> +
> +static inline bool swap_device_masked(struct swap_info_struct *si)
> +{
> +       return (unsigned long)si & SWAP_DEVICE_MASKED_BIT;
> +}
> +
> +static inline struct swap_info_struct *swap_device_mask_ptr(struct swap_=
info_struct *si)
> +{
> +       return (struct swap_info_struct *)((unsigned long)si |
> +                                          SWAP_DEVICE_MASKED_BIT);
> +}
> +
> +static inline struct swap_info_struct *swap_device_unmask_ptr(struct swa=
p_info_struct *si)
> +{
> +       return (struct swap_info_struct *)((unsigned long)si & ~SWAP_DEVI=
CE_MASKED_BIT);
> +}
> +
> +static struct swap_queue_reader __percpu *swap_queue_prealloc_readers(in=
t nr_rings, gfp_t gfp)
> +{
> +       struct swap_queue_reader __percpu *readers;
> +
> +       if (!nr_rings)
> +               return NULL;
> +
> +       readers =3D __alloc_percpu_gfp(struct_size(readers, heads, nr_rin=
gs),
> +                                    __alignof__(*readers), gfp);
> +       return readers;
> +}
> +
> +static bool swap_queue_needs_readers(int prio)
> +{
> +       unsigned int i;
> +
> +       lockdep_assert_held_write(&swapon_rwsem);
> +       for (i =3D 0; i < swap_queue_len; i++) {
> +               if (swap_queue[i]->prio =3D=3D prio)
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +/*
> + * Return with swapon_rwsem held for writing, or unlocked on allocation =
failure.
> + * Per-CPU backing allocations may reclaim, so prepare them before publi=
shing
> + * the device and outside the topology lock and our noreclaim scope. Kee=
p NOIO
> + * because the swapon caller still holds the swapfile's inode lock.
> + */
> +static int swap_queue_lock_for_add(int prio,
> +                                  struct swap_queue_reader __percpu **re=
aders,
> +                                  unsigned int *nr_readers)
> +{
> +       *readers =3D NULL;
> +       *nr_readers =3D 0;
> +       for (;;) {
> +               percpu_down_write(&swapon_rwsem);
> +               if (!swap_queue_needs_readers(prio) ||
> +                   *nr_readers > swap_queue_len)
> +                       return 0;
> +
> +               *nr_readers =3D swap_queue_len + 1;
> +               percpu_up_write(&swapon_rwsem);
> +               free_percpu(*readers);
> +               *readers =3D swap_queue_prealloc_readers(*nr_readers, GFP=
_NOIO);
> +               if (!*readers)
> +                       return -ENOMEM;
> +       }
> +}
> +
> +static void swap_queue_reset_readers(void)
> +{
> +       int ring_idx, cpu;
> +       struct swap_prio_ring *ring;
> +
> +       lockdep_assert_held_write(&swapon_rwsem);
> +       /* A new topology starts a fresh, distributed rotation on every C=
PU. */
> +       for_each_possible_cpu(cpu) {
> +               for (ring_idx =3D 0; ring_idx < swap_queue_len; ring_idx+=
+) {
> +                       ring =3D swap_queue[ring_idx];
> +                       per_cpu_ptr(swap_queue_readers, cpu)->heads[ring_=
idx].offset =3D
> +                                   cpu % ring->size;
> +                       per_cpu_ptr(swap_queue_readers, cpu)->heads[ring_=
idx].rr_counter =3D
> +                                   SWAP_ROUND_ROBIN_QUOTA;
> +               }
> +       }
> +}
> +
> +static void swap_queue_install_readers(struct swap_queue_reader __percpu=
 *readers)
> +{
> +       int cpu;
> +
> +       lockdep_assert_held_write(&swapon_rwsem);
> +       free_percpu(swap_queue_readers);
> +       swap_queue_readers =3D readers;
> +       if (!readers)
> +               return;
> +
> +       for_each_possible_cpu(cpu)
> +               local_lock_init(&per_cpu_ptr(readers, cpu)->lock);
> +       swap_queue_reset_readers();
> +}
> +
> +static struct swap_info_struct *swap_queue_get_device(long nr_alloc, int=
 nr_iter,
> +                                                     struct swap_queue_c=
ursor *cursor)
> +{

The caller is using a loop to increase nr_iter one by one.

> +       bool rotate =3D false;
> +       struct swap_info_struct *si;
> +       struct swap_queue_reader_head *head;
> +       struct swap_prio_ring *ring;
> +       unsigned int dev_idx, queue_idx;
> +
> +       if (!swap_queue_len)
> +               return ERR_PTR(-ENOENT);
> +
> +       queue_idx =3D 0;
> +       while (nr_iter >=3D swap_queue[queue_idx]->size) {
> +               nr_iter -=3D swap_queue[queue_idx]->size;
> +               if (++queue_idx >=3D swap_queue_len)
> +                       return ERR_PTR(cursor->no_fallback ? -E2BIG : -EN=
OENT);
> +       }

For nr_iter + 1, the queue_idx will start from zero and skip over the
same set of swap_queu queue_idx that previous nr_iter already skipped.
This iteration loop does not feel optimal.
It seems the caller trying nr_iters for 0 -> max devices. The caller's
loop should iterate over each ring in the priority order,  and skip
that ring if all devices in it are full.

> +       if (cursor->no_fallback && cursor->ring_idx !=3D queue_idx)
> +               return ERR_PTR(-E2BIG);
> +
> +       ring =3D swap_queue[queue_idx];
> +       local_lock(&swap_queue_readers->lock);
> +       head =3D this_cpu_ptr(&swap_queue_readers->heads[queue_idx]);
> +       /*
> +        * Snapshot the starting offset for this walk. Other allocations =
on
> +        * this CPU can move the shared head between retries.
> +        */
> +       if (!cursor->valid || cursor->ring_idx !=3D queue_idx) {
> +               cursor->valid =3D true;
> +               cursor->ring_idx =3D queue_idx;
> +               if (head->rr_counter < nr_alloc)
> +                       rotate =3D true;
> +               else if (head->offset >=3D ring->size)
> +                       rotate =3D true;
> +               if (rotate) {
> +                       head->offset++;
> +                       head->offset %=3D ring->size;
> +                       head->rr_counter =3D SWAP_ROUND_ROBIN_QUOTA;
> +               }
> +               cursor->offset =3D head->offset;
> +       }
> +
> +       dev_idx =3D (cursor->offset + nr_iter) % ring->size;
> +       if (nr_iter) {
> +               head->offset =3D dev_idx;
> +               head->rr_counter =3D SWAP_ROUND_ROBIN_QUOTA;
> +       }
> +       head->rr_counter -=3D nr_alloc;
> +       si =3D READ_ONCE(ring->dev[dev_idx]);
> +       local_unlock(&swap_queue_readers->lock);
> +
> +       if (swap_device_masked(si))
> +               return ERR_PTR(-EBUSY);
> +
> +       si =3D swap_device_unmask_ptr(si);
> +       return si;
> +}
> +
> +static bool swap_queue_find(struct swap_info_struct *si,
> +                           unsigned int *ring_idx, unsigned int *dev_idx=
)
> +{

Why do we need this function? Isn't the swap_queue is static between
swap{on,off}. the ring_index and dev_idx shouldn't change between
swap{on,off}.
Can we just cache the ring_idx and dev_idx as si->ring_idx and si->dev_idx?

Swap on/off will pay the price to update them si->ring_idx and
si->dev_idx for possible all device in the same ring. However, swap
on/off operations are allowed to be slow.

> +       unsigned int i, j;
> +       struct swap_prio_ring *ring;
> +
> +       lockdep_assert(lockdep_is_held(&swapon_rwsem) ||
> +                      lockdep_is_held(&swap_queue_update_lock));
> +
> +       for (i =3D 0; i < swap_queue_len; i++) {
> +               ring =3D swap_queue[i];
> +               if (ring->prio !=3D si->prio)
> +                       continue;
> +               for (j =3D 0; j < ring->size; j++) {
> +                       if (swap_device_unmask_ptr(READ_ONCE(ring->dev[j]=
)) !=3D si)
> +                               continue;
> +                       *ring_idx =3D i;
> +                       *dev_idx =3D j;
> +                       return true;
> +               }
> +       }
> +       return false;
> +}
> +
> +static void swap_queue_mask(struct swap_info_struct *si)

It is not masking the queue. It masks the device pointer. Maybe
swap_queue_set_dev_full()

> +{
> +       unsigned int ring_idx, dev_idx;
> +
> +       lockdep_assert_held(&swap_queue_update_lock);
> +       if (swap_queue_find(si, &ring_idx, &dev_idx))
> +               WRITE_ONCE(swap_queue[ring_idx]->dev[dev_idx],
> +                          swap_device_mask_ptr(si));
> +}
> +
> +static void swap_queue_unmask(struct swap_info_struct *si)

Maybe swap_queue_clear_dev_full()

To be continued.

Chris

> +{
> +       unsigned int ring_idx, dev_idx;
> +
> +       lockdep_assert_held(&swap_queue_update_lock);
> +       if (swap_queue_find(si, &ring_idx, &dev_idx))
> +               WRITE_ONCE(swap_queue[ring_idx]->dev[dev_idx], si);
> +}
> +
> +/* Prepared readers remain caller-owned unless installed successfully. *=
/
> +static int swap_queue_add(struct swap_info_struct *si,
> +                         struct swap_queue_reader __percpu **readers,
> +                         unsigned int nr_readers)
> +{
> +       struct swap_prio_ring **new_queue =3D NULL, **old_queue =3D NULL;
> +       struct swap_prio_ring *ring, *new_ring =3D NULL, *old_ring =3D NU=
LL;
> +       int prio =3D si->prio;
> +       int i, pos, err =3D -ENOMEM;
> +       unsigned int noreclaim_flag;
> +       gfp_t gfp;
> +
> +       /* A writer must not reclaim into another swap allocation. */
> +       gfp =3D GFP_NOIO | __GFP_HIGH | __GFP_NOMEMALLOC;
> +       lockdep_assert_held_write(&swapon_rwsem);
> +       noreclaim_flag =3D memalloc_noreclaim_save();
> +
> +       for (pos =3D 0; pos < swap_queue_len; pos++) {
> +               if (swap_queue[pos]->prio =3D=3D prio)
> +                       goto add_to_ring;
> +               if (swap_queue[pos]->prio < prio)
> +                       break;
> +       }
> +
> +       /* No ring at this priority: insert a new one at pos. */
> +       if (!*readers || nr_readers <=3D swap_queue_len)
> +               goto failed;
> +       new_queue =3D kmalloc_array(swap_queue_len + 1, sizeof(*swap_queu=
e), gfp);
> +       if (!new_queue)
> +               goto failed;
> +       new_ring =3D kmalloc(struct_size(new_ring, dev, 1), gfp);
> +       if (!new_ring)
> +               goto failed;
> +       if (!get_swap_device_info(si))
> +               goto failed;
> +
> +       new_ring->prio =3D prio;
> +       new_ring->size =3D 1;
> +       new_ring->dev[0] =3D si;
> +       for (i =3D 0; i < pos; i++)
> +               new_queue[i] =3D swap_queue[i];
> +       new_queue[pos] =3D new_ring;
> +       for (i =3D pos; i < swap_queue_len; i++)
> +               new_queue[i + 1] =3D swap_queue[i];
> +
> +       spin_lock(&swap_queue_update_lock);
> +       old_queue =3D swap_queue;
> +       swap_queue =3D new_queue;
> +       swap_queue_len++;
> +       spin_unlock(&swap_queue_update_lock);
> +       memalloc_noreclaim_restore(noreclaim_flag);
> +       kfree(old_queue);
> +
> +       swap_queue_install_readers(*readers);
> +       *readers =3D NULL;
> +       return 0;
> +
> +add_to_ring:
> +       ring =3D swap_queue[pos];
> +       new_ring =3D kmalloc(struct_size(ring, dev, ring->size + 1), gfp)=
;
> +       if (!new_ring)
> +               goto failed;
> +       if (!get_swap_device_info(si))
> +               goto failed;
> +       spin_lock(&swap_queue_update_lock);
> +       memcpy(new_ring, ring, struct_size(ring, dev, ring->size));
> +       new_ring->size++;
> +       new_ring->dev[new_ring->size - 1] =3D si;
> +       old_ring =3D swap_queue[pos];
> +       swap_queue[pos] =3D new_ring;
> +       spin_unlock(&swap_queue_update_lock);
> +       memalloc_noreclaim_restore(noreclaim_flag);
> +       kfree(old_ring);
> +       return 0;
> +
> +failed:
> +       memalloc_noreclaim_restore(noreclaim_flag);
> +       kfree(new_queue);
> +       kfree(new_ring);
> +       return err;
> +}
> +
> +static void swap_queue_del(struct swap_info_struct *si)
> +{
> +       gfp_t gfp;
> +       unsigned int noreclaim_flag;
> +       unsigned int ring_idx, dev_idx;
> +       struct swap_prio_ring *ring, *new_ring =3D NULL, *old_ring =3D NU=
LL;
> +       struct swap_prio_ring **new_queue =3D NULL, **old_queue =3D NULL;
> +
> +       lockdep_assert_held_write(&swapon_rwsem);
> +       if (!swap_queue_find(si, &ring_idx, &dev_idx)) {
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       /*
> +        * Shrinking the small topology arrays is optional. Keep reader s=
torage
> +        * until a new priority is inserted or the queue is empty: per-CP=
U
> +        * allocation must not run under this writer's noreclaim scope, w=
hich
> +        * can grant backing pages reserve access.
> +        */
> +       gfp =3D GFP_NOIO | __GFP_HIGH | __GFP_NOMEMALLOC;
> +       noreclaim_flag =3D memalloc_noreclaim_save();
> +       ring =3D swap_queue[ring_idx];
> +       if (ring->size > 1)
> +               new_ring =3D kmalloc(struct_size(ring, dev, ring->size - =
1), gfp);
> +       if (ring->size =3D=3D 1 && swap_queue_len > 1) {
> +               new_queue =3D kmalloc(sizeof(*swap_queue) *
> +                                   (swap_queue_len - 1), gfp);
> +       }
> +       memalloc_noreclaim_restore(noreclaim_flag);
> +
> +       spin_lock(&swap_queue_update_lock);
> +       if (ring->size > 1) {
> +               /* Shift trailing devices left to fill the gap. */
> +               while (++dev_idx < ring->size)
> +                       ring->dev[dev_idx - 1] =3D
> +                               ring->dev[dev_idx];
> +               ring->size--;
> +               if (new_ring) {
> +                       memcpy(new_ring, ring,
> +                              struct_size(ring, dev, ring->size));
> +                       old_ring =3D ring;
> +                       swap_queue[ring_idx] =3D new_ring;
> +               }
> +       } else {
> +               /* Last device in this ring: remove the ring. */
> +               old_ring =3D ring;
> +               swap_queue_len--;
> +               while (++ring_idx <=3D swap_queue_len)
> +                       swap_queue[ring_idx - 1] =3D
> +                               swap_queue[ring_idx];
> +               if (new_queue) {
> +                       memcpy(new_queue, swap_queue,
> +                              sizeof(*swap_queue) * swap_queue_len);
> +                       old_queue =3D swap_queue;
> +                       swap_queue =3D new_queue;
> +               } else if (!swap_queue_len) {
> +                       old_queue =3D swap_queue;
> +                       swap_queue =3D NULL;
> +               }
> +               if (!swap_queue_len)
> +                       swap_queue_install_readers(NULL);
> +       }
> +       spin_unlock(&swap_queue_update_lock);
> +
> +       kfree(old_ring);
> +       kfree(old_queue);
> +       put_swap_device(si);
> +}
> +
>  /*
>   * Use the second highest bit of inuse_pages counter as the indicator
> - * if one swap device is on the available plist, so the atomic can
> + * if one swap device is unavailable for allocation, so the atomic can
>   * still be updated arithmetically while having special data embedded.
>   *
>   * inuse_pages counter is the only thing indicating if a device should
> - * be on avail_lists or not (except swapon / swapoff). By embedding the
> - * off-list bit in the atomic counter, updates no longer need any lock
> - * to check the list status.
> + * be in the available queue or not (except swapon / swapoff). By
> + * embedding the off-list bit in the atomic counter, updates no longer
> + * need any lock to check the list status.
>   *
> - * This bit will be set if the device is not on the plist and not
> - * usable, will be cleared if the device is on the plist.
> + * This bit will be set if the device is not in the available queue
> + * and not usable, will be cleared if the device is in the queue.
>   */
>  #define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_long_t) - 2=
))
>  #define SWAP_USAGE_COUNTER_MASK (~SWAP_USAGE_OFFLIST_BIT)
> @@ -611,11 +1030,11 @@ swap_cluster_populate(struct swap_info_struct *si,
>                 return ci;
>
>         /*
> -        * Drop the device and cluster locks before retrying. Metadata al=
location
> -        * must not recurse into swap allocation through direct reclaim: =
callers
> -        * can retain outer synchronization across cluster population. Re=
strict
> -        * this request instead of granting the task PF_MEMALLOC, which c=
ould
> -        * give allocator hooks and failure cleanup reserve access.
> +        * Retry with the local and cluster locks dropped. The allocator =
can
> +        * still hold swapon_rwsem for reading: direct reclaim could ente=
r
> +        * swap allocation again while a writer is waiting for this reade=
r.
> +        * Restrict this request instead of granting the task PF_MEMALLOC=
,
> +        * which could give allocator hooks and failure cleanup reserve a=
ccess.
>          */
>         spin_unlock(&ci->lock);
>         if (si->flags & SWP_SOLIDSTATE)
> @@ -1293,6 +1712,7 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>         unsigned long pages;
>
>         spin_lock(&swap_avail_lock);
> +       spin_lock(&swap_queue_update_lock);
>
>         /*
>          * Force remove it only for swapoff. Else, take it off-list only =
if
> @@ -1313,9 +1733,10 @@ static void del_from_avail_list(struct swap_info_s=
truct *si, bool swapoff)
>                 atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>         }
>
> +       swap_queue_mask(si);
>         plist_del(&si->avail_list, &swap_avail_head);
> -
>  skip:
> +       spin_unlock(&swap_queue_update_lock);
>         spin_unlock(&swap_avail_lock);
>  }
>
> @@ -1326,12 +1747,12 @@ static void add_to_avail_list(struct swap_info_st=
ruct *si)
>         unsigned long pages;
>
>         spin_lock(&swap_avail_lock);
> +       spin_lock(&swap_queue_update_lock);
>
>         /*
> -        * Add the device to the avail list if SWP_WRITEOK is set and
> -        * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
> -        * SWP_WRITEOK first, so the device won't be re-added after
> -        * swapoff starts unless swap_device_enable resurrects it.
> +        * Mark the device as avail if SWP_WRITEOK is set. Swapoff clears
> +        * SWP_WRITEOK first, so check that first so the device won't be
> +        * re-added after swapoff started.
>          */
>         if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
>                 goto skip;
> @@ -1342,9 +1763,10 @@ static void add_to_avail_list(struct swap_info_str=
uct *si)
>         val =3D atomic_long_fetch_and_relaxed(~SWAP_USAGE_OFFLIST_BIT, &s=
i->inuse_pages);
>
>         /*
> -        * When device is full and device is on the plist, only one updat=
er will
> -        * see (inuse_pages =3D=3D si->pages) and will call del_from_avai=
l_list. If
> -        * that updater happen to be here, just skip adding.
> +        * When device is full and marked as available, one reader will s=
ee
> +        * (inuse_pages =3D=3D si->pages) and should mark it as unavailab=
le and
> +        * set SWAP_USAGE_OFFLIST_BIT. If that updater happens to be here=
, just
> +        * skip the rest.
>          */
>         pages =3D si->pages;
>         if ((val & SWAP_USAGE_COUNTER_MASK) =3D=3D pages) {
> @@ -1354,9 +1776,10 @@ static void add_to_avail_list(struct swap_info_str=
uct *si)
>                         goto skip;
>         }
>
> +       swap_queue_unmask(si);
>         plist_add(&si->avail_list, &swap_avail_head);
> -
>  skip:
> +       spin_unlock(&swap_queue_update_lock);
>         spin_unlock(&swap_avail_lock);
>  }
>
> @@ -1373,7 +1796,7 @@ static void swap_device_inuse_add(struct swap_info_=
struct *si,
>
>         /*
>          * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
> -        * remove it from the plist.
> +        * mark it unavailable.
>          */
>         inuse_pages =3D atomic_long_add_return_relaxed(nr_entries, &si->i=
nuse_pages);
>         if (unlikely(inuse_pages =3D=3D si->pages)) {
> @@ -1415,7 +1838,7 @@ static void swap_device_inuse_sub(struct swap_info_=
struct *si, unsigned long off
>
>         /*
>          * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
> -        * add it back to the plist.
> +        * add it back to the available queue.
>          */
>         inuse_pages =3D atomic_long_sub_return_relaxed(nr_entries, &si->i=
nuse_pages);
>         if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
> @@ -1438,41 +1861,44 @@ static bool get_swap_device_info(struct swap_info=
_struct *si)
>         return true;
>  }
>
> -/* Rotate the device and switch to a new cluster */
> -static void swap_alloc_entry(struct folio *folio)
> +static int swap_alloc_entry(struct folio *folio)
>  {
> -       struct swap_info_struct *si, *next;
> +       struct swap_queue_cursor cursor =3D {};
> +       long nr_pages =3D folio_nr_pages(folio);
> +       struct swap_info_struct *si;
> +       int nr_iter, ret;
>
> -       spin_lock(&swap_avail_lock);
> -start_over:
> -       plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list)=
 {
> -               /* Rotate the device and switch to a new cluster */
> -               plist_requeue(&si->avail_list, &swap_avail_head);
> -               spin_unlock(&swap_avail_lock);
> -               if (get_swap_device_info(si)) {
> -                       cluster_alloc_swap_entry(si, folio);
> -                       put_swap_device(si);
> -                       if (folio_test_swapcache(folio))
> -                               return;
> -                       if (folio_test_large(folio))
> -                               return;
> +       percpu_down_read(&swapon_rwsem);
> +       migrate_disable();
> +       for (nr_iter =3D 0;; nr_iter++) {
> +               si =3D swap_queue_get_device(nr_pages, nr_iter, &cursor);
> +               if (IS_ERR(si)) {
> +                       ret =3D PTR_ERR(si);
> +                       if (ret =3D=3D -EBUSY)
> +                               continue;
> +                       break;
> +               }
> +               cluster_alloc_swap_entry(si, folio);
> +
> +               if (folio_test_swapcache(folio)) {
> +                       ret =3D 0;
> +                       break;
>                 }
>
> -               spin_lock(&swap_avail_lock);
>                 /*
> -                * if we got here, it's likely that si was almost full be=
fore,
> -                * multiple callers probably all tried to get a page from=
 the
> -                * same si and it filled up before we could get one; or, =
the si
> -                * filled up between us dropping swap_avail_lock.
> -                * Since we dropped the swap_avail_lock, the swap_avail_l=
ist
> -                * may have been modified; so if next is still in the
> -                * swap_avail_head list then try it, otherwise start over=
 if we
> -                * have not gotten any slots.
> +                * For large allocations, try every device at the same pr=
iority,
> +                * but ask the caller to split instead of falling back to=
 a lower
> +                * priority ring.
>                  */
> -               if (plist_node_empty(&next->avail_list))
> -                       goto start_over;
> +               if (folio_test_large(folio)) {
> +                       cursor.no_fallback =3D true;
> +                       continue;
> +               }
>         }
> -       spin_unlock(&swap_avail_lock);
> +
> +       migrate_enable();
> +       percpu_up_read(&swapon_rwsem);
> +       return ret;
>  }
>
>  /*
> @@ -3090,18 +3516,17 @@ static int setup_swap_extents(struct swap_info_st=
ruct *sis,
>  }
>
>  /*
> - * Mark a fully initialized swap device writable and expose it to the
> - * allocator. The caller must have resurrected its percpu ref first.
> + * Mark a fully initialized swap device writable and expose it to the al=
locator.
> + * The caller must have resurrected its percpu ref before entering this =
helper.
>   */
>  static void __swap_device_enable(struct swap_info_struct *si)
>  {
>         lockdep_assert_held_write(&swapon_rwsem);
>         spin_lock(&si->lock);
> -       spin_lock(&swap_avail_lock);
> +       spin_lock(&swap_queue_update_lock);
>         si->flags |=3D SWP_WRITEOK;
> -       spin_unlock(&swap_avail_lock);
> +       spin_unlock(&swap_queue_update_lock);
>         spin_unlock(&si->lock);
> -
>         atomic_long_add(si->pages, &nr_swap_pages);
>         total_swap_pages +=3D si->pages;
>         plist_add(&si->list, &swap_active_head);
> @@ -3234,6 +3659,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
>                 return err;
>         }
>
> +       percpu_down_write(&swapon_rwsem);
> +       swap_queue_del(p);
> +       percpu_ref_kill(&p->users);
> +       percpu_up_write(&swapon_rwsem);
> +
>         /*
>          * Wait for swap operations protected by get/put_swap_device()
>          * to complete.  Because of synchronize_rcu() here, all swap
> @@ -3242,7 +3672,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>          * prevent folio_test_swapcache() and the following swap cache
>          * operations from racing with swapoff.
>          */
> -       percpu_ref_kill(&p->users);
>         synchronize_rcu();
>         wait_for_completion(&p->comp);
>
> @@ -3704,6 +4133,8 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>  SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flag=
s)
>  {
>         struct swap_info_struct *si;
> +       struct swap_queue_reader __percpu *readers;
> +       unsigned int nr_readers;
>         struct file *swap_file =3D NULL;
>         struct address_space *mapping;
>         struct dentry *dentry;
> @@ -3890,14 +4321,33 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>         si->prio =3D prio;
>         si->list.prio =3D -si->prio;
>         si->avail_list.prio =3D -si->prio;
> -       /* Publish the file, live reference and writable state together. =
*/
> -       percpu_down_write(&swapon_rwsem);
> -       si->swap_file =3D swap_file;
>
> -       /* Make the reference live before exposing the writable device. *=
/
> +       /*
> +        * Publish swap_file before making the percpu ref live, then add =
the device
> +        * to the queue and make it writable under the same write-side lo=
ck. This
> +        * keeps lockless ref users and /proc/swaps from observing partia=
l state.
> +        */
> +       error =3D swap_queue_lock_for_add(prio, &readers, &nr_readers);
> +       if (error) {
> +               inode->i_flags &=3D ~S_SWAPFILE;
> +               goto free_swap_zswap;
> +       }
> +       si->swap_file =3D swap_file;
>         percpu_ref_resurrect(&si->users);
> -       __swap_device_enable(si);
> +       error =3D swap_queue_add(si, &readers, nr_readers);
> +       if (error) {
> +               si->swap_file =3D NULL;
> +               percpu_ref_kill(&si->users);
> +       } else {
> +               __swap_device_enable(si);
> +       }
>         percpu_up_write(&swapon_rwsem);
> +       free_percpu(readers);
> +       if (error) {
> +               wait_for_completion(&si->comp);
> +               inode->i_flags &=3D ~S_SWAPFILE;
> +               goto free_swap_zswap;
> +       }
>
>         pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%=
lluk %s%s%s%s\n",
>                 K((unsigned long)si->pages), name->name, si->prio, nr_ext=
ents,

