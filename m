Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9094606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghJ0xYbO
Received: by kanga.kvack.org (Postfix)
	id 4581A6B05B6; Wed, 28 Oct 2026 12:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4305F6B05B7; Wed, 28 Oct 2026 12:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346FA6B05B8; Wed, 28 Oct 2026 12:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8A76B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:15:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08679C0148
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:01 +0000 (UTC)
X-FDA: 85372534002.12.BC79AA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3FE664000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ghJ0xYbO;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793204099;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmNf2SWJWRRs2iHRdBuYWeevNK+xtNXBxXDIOPuNtjc=;
	b=X8ERyIERNz8A/nxpWJkuTWA3luDCRJn89QkQBzHJhCNE+3FhssIXII7ci42Dhd4rFOLeEY
	613KVs5Df74Z3XJvVDGnGV8976AWmy/Mw+MhCJX3rSXpb34HZRrQW3+3Xn0Rxy8LCpWvfY
	iuFwCcH47I6rJgF6I+DLWLc1aTKOmYY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793204099;
	b=6OEUJv+vMb/8ZovnDsv0uY7SIhgc4vYu+hrW4YgI+hg69hhYO7NPqMKUIpFGyx+bPmXngi
	r8VXgyDd26E6t68YHYrt0qa4DGAbsY/OTuhRbGYrJTrMdVQ1vKsv3Hhdwm2H60myHaIWEJ
	qcPOH9TSgR++IWxPo2en/jJ1gIrisNg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ghJ0xYbO;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 842A043841;
	Wed, 28 Oct 2026 16:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D4A1F01825;
	Wed, 28 Oct 2026 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793204098;
	bh=fmNf2SWJWRRs2iHRdBuYWeevNK+xtNXBxXDIOPuNtjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghJ0xYbO+kw/OHeOx/hL8o/61Zbo4XF+1w2XSSWriuN8BlgxWNd2aN9QF2WL7uSKa
	 kDVx9UliDl8ktToaDEsel/b78E/ZEQ7vKyhgz8Qs6cfpUCM+yoFbZfLRVbtA4PUBG1
	 lptr2iouiBc9QFJCc4C7F/jf+Yq5YgpM9+CjAvyqAzjJZdPpOU7nB82kPglB9UFUGh
	 kZZJCn6O3TbnFjGbbjtk/e3XkFnEYqGrLTvQYlvwsqkzxGz7GNEErPTuhV5cV3jPtX
	 IqI8jMBvGIcl21vLa3JJNBK/6+X6E44FEITw/tG0ii/bUM9MBfn+wL6zbsvX3AKH/n
	 AmTtDAbpNMOsA==
Message-ID: <sashiko-outbox-188139@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 10/18] mm/swap: add priority queue for swap
 device allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, shikemeng@huaweicloud.com, kasong@tencent.com, linjh22s@gmail.com, kunwu.chan@linux.dev, kees@kernel.org, gustavoars@kernel.org, tglx@kernel.org
In-Reply-To: <b1580bf6460962c02d3c7ebf786583f200db491b.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
 <b1580bf6460962c02d3c7ebf786583f200db491b.1793106426.git.lianux.mm@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 16:14:57 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FE664000C
X-Stat-Signature: bggwwisu9a4m7ciyq5mghpr1thf59pxq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793204099-681515
X-HE-Meta: U2FsdGVkX18TqRPn7cBgElOHLlYB3mqHn7jJ490jvue1/OGcGf14kYMXeng01kvU9he2PmVaGL6PZM4SSfMN1vMEoFOwGTBempADG+OzTQqeGBXuzYK6sY/ZtowkAkQ7RzZgb23faVLGhTGYBjPt2+yuKdN5Z1eqGenHQO7KHeXT6uk0mh+HWqs11jB7Vre3zr3AKvkHSNJ0I87kOTcuYFurB4jKvcuGNrJhripmSOpiu/5dqExQTxuL3SujMeCTwXdUellaH6n41oSsEMDKac+V2NehMGhOa9vgTnfjubalK3J4YFVxFhzEObMLWQI3vUsrveTx5wj4SX1w6DZZ1ka3JKIXQRpryoZadSPLTnDgDcKpGQu6i73F9MWr38WOpGR18cPF8hHqivrqzzdfJwQwku944wCAKR8G8ra0gwlMn7E8hmp63S1DAGjqbzrDgTNjXjNiwkLnDp++23PStXi+kUAXWOAo/ajDS0dUGNjEVLfOCj+YtE9FL/bIGXUrDiL/Vbhi/+Zdam3fycqf+l6j1ZWGXsPAENUNtXb8znhH+3QBzxoj3gfoEX86rLmWySZOViy/djvBo79T/qcqn1BsY4BCH3CUBURhNLRxm+FHtVSW9O4Oa8AZwVgtOM0FsdTNwVwO6PtFp8nQrEYJiF9tmzwHMtVRqELK48H82Ur6KMpf+wtygBxygdRKjoVF7Zxj+0vvg312QFKhYNl70w1f8JC9Iv6+n2ftVxy8ycFmXbPwHXWY9fYC4KozeKomYsoQPtHJeQ7akFgEB9jBuYkQlBktNLEkLWI/pvpIREqK59blbKGmf01GePUklOsNoJVsVd339Ufr9xH44jTyNX5+LcmJqPdndwSWwddsezecZhG7kXDbyW0GP5hrdAJbBkpjhbjgDsrpuryepzzPvlSFs/qHZUmamtgH05FQy9pAcGEu4w9lGtnaDTTgl2/b9EDuMcLiXLNEC8UXrIB
 1jn2Ou+3
 ocLU52UnMt/I8puwLkqXlIRYw/zt+CmOnSRM8qmmj3h5nepGWC6Iu0DzDSkiaxkW3h+WdnmjkRTqEVSR0z/UOy6929SKvx+z8KPCCyQdZnutj4SdDRWyzxhVxnE4++cxLe0a/s65MZpgmWUJZ3cVEnOYwdFhFhlN2u6CWrWxZV3ZDUkq7rpRjf9g1gmAseFpY5lnWdfciHJZSzUCV55vZYAQNiUoafJ327HYiBLu5fIDeHtfaDyDhSB4XBbop+I3pM1vnhlS5bpTFrVaA5taYblQxZClm8P14tXyYs65NA6g/mRaYdn7MX/OrAKhhQIgvvgDrFeymFRCDlZ5T9q2dI9ToXNWmSElZokw9RGauWq61KE/ZBuvJA3Z0FMBDTa03ZAWIYyKkeMDm8E+o9uMM6iwyUH9ZN65j5PBo2oyxwfS41anV2Fq4LDRW858VRGt2kj38qdJ+j0DS0L6f43RJFuBhQPTxqNm2yBVSjjY56/lzQvEy/xjnvFsOsI2hSMxiFQgaHRhBddnQM1i8duImmMmBgQVQXePyBGavlrRN4uR6W4bQ/VHXP10Tqmko6/3Ks+cCCz6IgKZ2+KKO6v9dTFzRRIM9K6W3dlJP8RR1uX3cv9l3fznPkuxyd2kczD+I3u0RHiPUHl9NQkljyx0mhoRmJEkaQNpZchBIM6wYu3BpkpHLx4T7+61MGIsOmv8Y4PBOtVwpKV5GVp0XOGmz9BLgcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm/swap: swap_device_disable() drops swapon_rwsem before masking d=
evice
--

commit 01ef0e90906c766114a8ba5bc17c9a8b4eeba142
Author: Kairui Song <kasong@tencent.com>

mm/swap: add priority queue for swap device allocation

This patch introduces a priority queue of same-priority swap device rings
for swap entry allocation, protected by swapon_rwsem and
swap_queue_update_lock, with per-CPU round-robin iterators and tagged
pointers to mask full or disabled devices.

Link: https://lore.kernel.org/20260714-swap-pcp-priq-v1-9-de9b164ed419@tenc=
ent.com
Link: https://lore.kernel.org/alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330
Link: https://lore.kernel.org/77d6da3d-10af-49a1-a356-72aa8b462e85@gmail.com

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 68bed5023299d..2065e566b7a35 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -1375,41 +1799,44 @@ static bool get_swap_device_info(struct swap_info=
_struct *si)
>  	return true;
>  }
> =20
> -/* Rotate the device and switch to a new cluster */
> -static void swap_alloc_entry(struct folio *folio)
> +static int swap_alloc_entry(struct folio *folio)
>  {
> -	struct swap_info_struct *si, *next;
> +	struct swap_queue_cursor cursor =3D {};
> +	long nr_pages =3D folio_nr_pages(folio);
> +	struct swap_info_struct *si;
> +	int nr_iter, ret;
> =20
> -	spin_lock(&swap_avail_lock);
> -start_over:
> -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> -		/* Rotate the device and switch to a new cluster */
> -		plist_requeue(&si->avail_list, &swap_avail_head);
> -		spin_unlock(&swap_avail_lock);
> -		if (get_swap_device_info(si)) {
> -			cluster_alloc_swap_entry(si, folio);
> -			put_swap_device(si);
> -			if (folio_test_swapcache(folio))
> -				return;
> -			if (folio_test_large(folio))
> -				return;
> +	percpu_down_read(&swapon_rwsem);
> +	migrate_disable();
> +	for (nr_iter =3D 0;; nr_iter++) {
> +		si =3D swap_queue_get_device(nr_pages, nr_iter, &cursor);
> +		if (IS_ERR(si)) {
> +			ret =3D PTR_ERR(si);
> +			if (ret =3D=3D -EBUSY)
> +				continue;
> +			break;
> +		}
> +		cluster_alloc_swap_entry(si, folio);
> +
> +		if (folio_test_swapcache(folio)) {
> +			ret =3D 0;
> +			break;
>  		}
> =20
> -		spin_lock(&swap_avail_lock);
>  		/*
> -		 * if we got here, it's likely that si was almost full before,
> -		 * multiple callers probably all tried to get a page from the
> -		 * same si and it filled up before we could get one; or, the si
> -		 * filled up between us dropping swap_avail_lock.
> -		 * Since we dropped the swap_avail_lock, the swap_avail_list
> -		 * may have been modified; so if next is still in the
> -		 * swap_avail_head list then try it, otherwise start over if we
> -		 * have not gotten any slots.
> +		 * For large allocations, try every device at the same priority,
> +		 * but ask the caller to split instead of falling back to a lower
> +		 * priority ring.
>  		 */
> -		if (plist_node_empty(&next->avail_list))
> -			goto start_over;
> +		if (folio_test_large(folio)) {
> +			cursor.ring_only =3D true;
> +			continue;
> +		}
>  	}
> -	spin_unlock(&swap_avail_lock);
> +
> +	migrate_enable();
> +	percpu_up_read(&swapon_rwsem);
> +	return ret;
>  }

[ ... ]

> @@ -3082,10 +3509,9 @@ static int swap_device_disable(struct address_spac=
e *mapping,
>  	}
>  	vm_unacct_memory(si->pages);
> =20
> -	spin_lock(&swap_avail_lock);
> +	spin_lock(&swap_queue_update_lock);
>  	si->flags &=3D ~SWP_WRITEOK;
> -	spin_unlock(&swap_avail_lock);
> -
> +	spin_unlock(&swap_queue_update_lock);
>  	plist_del(&si->list, &swap_active_head);
>  	total_swap_pages -=3D si->pages;
>  	atomic_long_sub(si->pages, &nr_swap_pages);

[Severity: High]
Should swap_device_disable() call del_from_avail_list(si, true) before
releasing swapon_rwsem?

In swap_device_disable(), SWP_WRITEOK is cleared and percpu_up_write()
releases swapon_rwsem before del_from_avail_list(si, true) masks si in
swap_queue:

mm/swapfile.c:swap_device_disable() {
	...
	spin_lock(&swap_queue_update_lock);
	si->flags &=3D ~SWP_WRITEOK;
	spin_unlock(&swap_queue_update_lock);
	plist_del(&si->list, &swap_active_head);
	total_swap_pages -=3D si->pages;
	atomic_long_sub(si->pages, &nr_swap_pages);

	end =3D ALIGN(si->max, SWAPFILE_CLUSTER);
unlock:
	percpu_up_write(&swapon_rwsem);
	if (err)
		return err;

	del_from_avail_list(si, true);
	...
}

In the window between percpu_up_write(&swapon_rwsem) and
del_from_avail_list(si, true) acquiring swap_queue_update_lock, a
concurrent reader in folio_alloc_swap() -> swap_alloc_entry() can acquire
swapon_rwsem for reading and obtain the unmasked si from
swap_queue_get_device() with SWP_WRITEOK already cleared.

When swap_alloc_entry() then calls cluster_alloc_swap_entry(si, folio) on
a device with !(si->flags & SWP_WRITEOK), __swap_cluster_alloc_entries()
unconditionally returns false, which can cause two problems:

1. For order-0 folios, cluster_alloc_swap_entry() reaches the higher-order
stealing loop:

mm/swapfile.c:cluster_alloc_swap_entry() {
	...
	/* Order 0 stealing from higher order */
	for (int o =3D 1; o < SWAP_NR_ORDERS; o++) {
		found =3D alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
		if (found)
			goto done;

		found =3D alloc_swap_scan_list(si, &si->nonfull_clusters[o], folio, true);
		if (found)
			goto done;
	}
}

If si->frag_clusters[o] (or si->nonfull_clusters[o]) has any cluster with
0 < ci->count < SWAPFILE_CLUSTER, isolate_lock_cluster() isolates ci and
sets ci->flags =3D CLUSTER_FLAG_NONE. alloc_swap_scan_cluster() finds a free
slot, fails __swap_cluster_alloc_entries() because !(si->flags &
SWP_WRITEOK), and calls relocate_cluster(si, ci), which puts ci right back
onto si->frag_clusters[o]. Because scan_all is true,
alloc_swap_scan_list() will loop forever on the same cluster while holding
the cluster lock (si->percpu_cluster->lock or si->global_cluster->lock),
migrate_disable(), and swapon_rwsem.

2. For large folios, swap_alloc_entry() treats the failed
cluster_alloc_swap_entry(si, folio) call on the disabled device as a
fragmentation failure on an active device at that priority and sets
cursor.ring_only =3D true. If no other peer in the same priority ring
satisfies the allocation, swap_queue_get_device() returns -E2BIG instead
of falling back to lower-priority rings, forcing the caller to split the
large folio even when lower-priority swap devices have free space.

Later in the series, commit "mm/swap: drop swap active plist" works around
this window in swap_queue_first_usable_bdev() by checking SWP_WRITEOK and
SWAP_USAGE_OFFLIST_BIT in addition to swap_device_masked(), but
swap_device_disable() and swap_alloc_entry() remain exposed to this window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793106426.gi=
t.lianux.mm@gmail.com?part=3D10

