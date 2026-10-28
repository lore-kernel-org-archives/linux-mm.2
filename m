Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028A3606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jR3l6z5y
Received: by kanga.kvack.org (Postfix)
	id 20E0B6B05B0; Wed, 28 Oct 2026 12:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF2D6B05B1; Wed, 28 Oct 2026 12:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4BC6B05B6; Wed, 28 Oct 2026 12:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFABB6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 377CF12015D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:59 +0000 (UTC)
X-FDA: 85372533918.07.E816899
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9D01D1A0011
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jR3l6z5y;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793204097;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9HwO/VrvaChUSsMN0EH4v5Q8UOGL9bq3ePkWiON8jc=;
	b=aROj8dQqx138OK+UPnGty5EcIYtpq4lJOzorVrPlfTnhUDvWMCSatlejbgWhsjrDIA3TGb
	qYNf1d813x5gf/wv4D+Mk5i106Bv+y62IxsNu7ijfRKBzrVwxaRObk/ZThkkG1cuXpDD4B
	iQtDX6iSm32zzf/LD2R3NbXlGNPtSyc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793204097;
	b=KKM+aob4TtWfmSpl2xZaaNbKdnPpkk/kKVmVSMyDVahX1uBLSgb7kTFLNJPEjswTSTKehj
	Af2y+nDUq2VGxAfiIIIikmxV5XCZ2qhsrXEELKilST9GnB+QEzWWOLO+c2VmDDLU1tJvvL
	2xW4ZTJAWRzyTqY3bsdwy0CKYQOPGJU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jR3l6z5y;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5918260120;
	Wed, 28 Oct 2026 16:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6132C1F01825;
	Wed, 28 Oct 2026 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793204096;
	bh=N9HwO/VrvaChUSsMN0EH4v5Q8UOGL9bq3ePkWiON8jc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jR3l6z5yoEWu8LcxouBGOgRIq2vOxJBog29VwP+szmtz4uxB162G8/+vq/MB4VK+z
	 JNzCEsbXox7JwFaKdgR/7Lp8nD9xXlCfqKxyH73ZHu0WhlSVKMpKXnaExB/mSe1MOW
	 LbAdgME704l6ksvgwHOMBkAVwhlB5tVYpC535bE9I20O7KorJLXPxUsJBjoaCy0tDs
	 sps0EJ1dPviZ7fN82tmxfPq7KjmeTG3Q1xewHApKG9d9GCg0wgv2hjco4W9SKxCLoU
	 BWrWUfVcJSXdYVLlXF/7ZVCJMTyLoHmpIU8TIc7Vo866tRoBq7SpnzYwFdlI6BkMMK
	 aK+9qSrGxfvHQ==
Message-ID: <sashiko-outbox-188132@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 03/18] mm/swap: cleanup and document swap device
 availability flag usage
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, shikemeng@huaweicloud.com, kasong@tencent.com, linjh22s@gmail.com, kunwu.chan@linux.dev, kees@kernel.org, gustavoars@kernel.org, tglx@kernel.org
In-Reply-To: <c3a660c13ec9a98af8a496b5f9139e73eab5aa3a.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
 <c3a660c13ec9a98af8a496b5f9139e73eab5aa3a.1793106426.git.lianux.mm@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 16:14:54 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D01D1A0011
X-Stat-Signature: tyxs3emnusawppaxyk9zua3bseei1cz6
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793204097-28409
X-HE-Meta: U2FsdGVkX1+USI0mx3KRk+LMZVQtQcL8os3/21RsCIVqJohpPKfOc1shySJ7E14S2dMP2GFWJjcxR0FWHRuzeollEata4L9R9Gif0tqFFjCE8CRxN9qgDjEoCxN1gzZc/fjBeQTFQ6p4+mtKKHntzEViJhih/oolOLfIi6Gb8CJ+CSp+0Bjc6tiq3pqu5OdB/M/3zcUdxLtDbeZX7izzMMP6wSVbpX2ktHQ5nkxgvtB3rEBIEWZv+9UmJRKWNfOostYhr9WWAqS0MYkPMgD+RrmeSjH+0ewEJGKo/uox3qTj54DQED2SMuOGiKsHJwHj89/uzH7xIbAQILVzmKWD02e0cW8rET/Fh8B5CJvL5eaZrvbKMjwmOYDypl9DIFB1cgfqa3vxYF4qAM9jJFL5S7eJktoXvD32PNE61d/A4yiqqybYlcT7Nr/AzeIf+RjK6sqFYN6od29XG50/yOWmdYmYWa3iy5YBCsGkZNoEQRfUcMirY9rMZUCmANY/x+V86O3CeNSrd/UsOdN8+ujMRncW+VtJdwxxhoogDZQ6lKxX0bS9AhyzIeQhl6buttAPnBFdsqOwyA7Wxs9MEO6QoQ+Xr4Xk7bKOyDmmjSTaT9B+rG5yOrgRcOgFb9uYGB/LTkbkLvLmeixC9N/Dm+BQERvKTEKcGSj1a8215dixIjA96VyOoLt3VQK52TF7JHCrbSErQTOTvzdwVX/xMNMBwy55jq2qYPTP8ZpHgIzo/rhtcuq3WsjCkJs2OntqxmQpH6AvYafvwzP2sUn260wAZftHX5sodaaJTtQ2KrXJ1rTL+OiDgh8iUimRS3eac0GI6Ex1vK0XojmIkvpl9CmRVljRucIZ96fN+GGPzw6oXEgIbIo8qX/lDJ9p+eJDyR7DWRywReVqVBaZ9aF1svR1y3h7e8LxYWsU+LTJeS+fL5A6PTtorQJlDTR4MlPDtppHKoNMBktndAlRqhZCwUw
 BUlzKdQX
 8SkimXBSpRRQj2tXqwZDb2RPzyFXF2EEAseJnolBCUUe+mxsGxclgvBPjPuYRPfsJ9DLjY9ALGkO/u8Dqu3ie4p9UgBoX6t8Frpud6f07vZjVMIcFy+YfqQ0Q+Or1lSwehZ7Jai0pNBMpDSxn2JFo+LmfBwz4yXiOa+ibakM+2zQGzXsLXvHcFbFzomdOslr6S3oiOFl9hlLCNjd0S8cj5rrBogkhwthYSW5AQTkM9AnDWnqhURzhaXFRn0UNJkD0Sv/71wf6f1F1fi8E8PdLRLQBOIH+VPY4vDbCyAbkBWVzkgP+cZJIaxt0qkwdDk3XRi9tus8EuOE5ULL1Ub26Kt+FMh8zoaH1CZWOhAIs7EWJbErt5pYc0eeQh5+1q8cKohmyzJEc/dRb6rtncU5FuIZ9MsI9serzobNIauVZ4OCAjtzUGvSUSwS+1YJ5jYRLZ6Sk9eW9zXGu7ckK/S/UZKhEt1R+g/8ZtEE9dkpc1sWgrC6oZNZVG1IjdQqLlHt6J63dlfMFg6PljvmHO+EFo8XPpg3wo+KWuZ+UQh2C8waSySj0rXawzK0JGPR52HMPjMjbxK5Eigw8U+g3lrpMWzXIH145bCqg3IWzCRnyC0tsmWwS7sJQz+z1E86asklQS2yOrskVdNYqHNd0Ois73SuK25xJG4sACHiJG6ITfQp8PZQ+8EYAkDwFKQ==
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
- [High] mm/swap: swap_device_disable() leaves !SWP_WRITEOK device on swap_=
avail_head
--

commit a6079aaef83a224a267931b8819b00f4e3063c85
Author: Kairui Song <kasong@tencent.com>

mm/swap: cleanup and document swap device availability flag usage

This commit introduces swap_device_enable() and swap_device_disable() to
make swap device writable publication and disable boundaries explicit, while
moving cluster lock draining outside of swap_lock.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index cf8c0999655ca..4adcfbbb37302 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
[ ... ]
> @@ -3078,58 +3070,87 @@ static int setup_swap_extents(struct swap_info_st=
ruct *sis,
[ ... ]
> +static int swap_device_disable(struct address_space *mapping,
> +			       struct swap_info_struct **swap_info)
> +{
> +	struct swap_info_struct *si;
> +	struct swap_cluster_info *ci;
> +	unsigned long offset, end;
> +	int err =3D -EINVAL;
> =20
>  	spin_lock(&swap_lock);
> +	plist_for_each_entry(si, &swap_active_head, list) {
> +		if ((si->flags & SWP_WRITEOK) &&
> +		    si->swap_file->f_mapping =3D=3D mapping) {
> +			err =3D 0;
> +			break;
> +		}
> +	}
> +	if (err)
> +		goto unlock;
> =20
> +	/*
> +	 * Refuse swapoff while the device is pinned for hibernation.
> +	 */
> +	if (si->flags & SWP_HIBERNATION) {
> +		err =3D -EBUSY;
> +		goto unlock;
> +	}
> =20
> +	if (security_vm_enough_memory_mm(current->mm, si->pages)) {
> +		err =3D -ENOMEM;
> +		goto unlock;
> +	}
> +	vm_unacct_memory(si->pages);
> =20
> +	spin_lock(&swap_avail_lock);
> +	si->flags &=3D ~SWP_WRITEOK;
> +	spin_unlock(&swap_avail_lock);
> +
> +	plist_del(&si->list, &swap_active_head);
> +	total_swap_pages -=3D si->pages;
> +	atomic_long_sub(si->pages, &nr_swap_pages);
> +
> +	end =3D ALIGN(si->max, SWAPFILE_CLUSTER);
> +unlock:
> +	spin_unlock(&swap_lock);
> +	if (err)
> +		return err;
> +
> +	del_from_avail_list(si, true);

[Severity: High]
Can splitting the clearing of SWP_WRITEOK from del_from_avail_list(si, true)
cause an infinite loop in alloc_swap_scan_list() and corrupt the cluster
lists?

Previously, del_from_avail_list(p, true) cleared SWP_WRITEOK, set
SWAP_USAGE_OFFLIST_BIT, and removed the device from swap_avail_head within a
single swap_avail_lock critical section.

With this change (which also persists when swap_lock is later converted to
swapon_rwsem and swap_avail_head to swap_queue), swap_device_disable() clea=
rs
SWP_WRITEOK and drops both swap_avail_lock and swap_lock before calling
del_from_avail_list(si, true). During that window, the device remains visib=
le
to swap_alloc_slow() with SWP_WRITEOK cleared.

When a concurrent folio_alloc_swap() -> swap_alloc_slow() ->
cluster_alloc_swap_entry() picks up this device while holding
percpu_swap_cluster.lock, __swap_cluster_alloc_entries() rejects every
cluster because SWP_WRITEOK is cleared:

mm/swapfile.c:alloc_swap_scan_cluster() {
	for (end -=3D nr_pages; offset <=3D end; offset +=3D nr_pages) {
		...
		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTE=
R))
			break;
		...
	}
out:
	relocate_cluster(si, ci);
}

Because ci->count is unchanged (0 < ci->count < SWAPFILE_CLUSTER),
relocate_cluster() places each isolated cluster onto
si->frag_clusters[ci->order].

First, alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, true)
drains all clusters from nonfull_clusters[order] into frag_clusters[order],
leaving the cluster lists disorganized if try_to_unuse() later fails and
swap_device_enable() re-enables the device.

Second, for an order-0 allocation reaching the higher-order stealing loop in
cluster_alloc_swap_entry():

	/* Order 0 stealing from higher order */
	for (int o =3D 1; o < SWAP_NR_ORDERS; o++) {
		found =3D alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
		if (found)
			goto done;

		found =3D alloc_swap_scan_list(si, &si->nonfull_clusters[o], folio, true);
		if (found)
			goto done;
	}

if si->frag_clusters[o] is non-empty, alloc_swap_scan_list() with
scan_all =3D=3D true isolates a cluster from frag_clusters[o], fails
__swap_cluster_alloc_entries() due to !SWP_WRITEOK, and relocate_cluster()
immediately appends the same cluster back to the tail of frag_clusters[o],
spinning forever in the do { ... } while (scan_all) loop with preemption
disabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793106426.gi=
t.lianux.mm@gmail.com?part=3D3

