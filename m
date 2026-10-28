Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F42D606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fpr1wBVc
Received: by kanga.kvack.org (Postfix)
	id 1990B6B05B7; Wed, 28 Oct 2026 12:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171916B05B8; Wed, 28 Oct 2026 12:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FD26B05B9; Wed, 28 Oct 2026 12:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4A836B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:15:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16EA440131
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:02 +0000 (UTC)
X-FDA: 85372534044.17.D091A80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65FD2180009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fpr1wBVc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793204100;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0zK0vCH+pOgGQ721Qu+JYG+f9gUltqHkioDEgjneVw=;
	b=hl2cOuWkO9Pg1yxb1MHBXfLOU25It//n/J00IkXRBEV5/+GYq3P+rOxMojVZgY9ZXteG0I
	phqhD/qTp1XYyuDP0/+lNHOQRULB4PNqyJp/zSxd0FTV7EILmBhw9E6/vsB8WDREKZc5O1
	aupCa11bSo2M0PyV0hKkpUfIdy9blUg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fpr1wBVc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793204100;
	b=n0CBJB6xfJgqERiYQ9VvZFW0XxTFIDD8Og2qq6mUeyuB0Fd4NsnEwpsIBuZAdqcZmlgObN
	VLNyI9ZYFJi6F+Qoon3K7CiDzuG8V28+U1xdheBOrAQYDVUmuQ0oqeMBFHlUOw3kQpy9aB
	CrwrwpWjbsRt21pFWA3uPbY1z0ctGVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B645843926;
	Wed, 28 Oct 2026 16:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5E81F01825;
	Wed, 28 Oct 2026 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793204099;
	bh=c0zK0vCH+pOgGQ721Qu+JYG+f9gUltqHkioDEgjneVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fpr1wBVc1cbpoUb4ulbVvRWdgR29SyJ+pkz9LGmBrUubo4cBWZ9f7UF3aobIQ3ubO
	 RkiyXNlNVtAahMOQVQL55SdH+wZt9kR9yvlRr43YFyGvx7xrueQXK8lKfgtUBCoPpD
	 u03aTAahoqRrGVewhbWWHcys/tckHMVIpqAubl04l3yCuu0VGnBQYx64P2BSPPww1Y
	 dEmq8WhiaOBT2mxfN/Ays9b7DbDj4Efdai5C/NfrxV22hHt/lHT3317uTFeYVcOttT
	 QM0einVAcREYfmdIEftTxaf5NII6q/The+a6R4X9JWQyRteeRJlymQrl8l3f7ztFw2
	 TSso2Z7dxY2lw==
Message-ID: <sashiko-outbox-188141@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 12/18] mm/swap: bound synchronous discard during
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, shikemeng@huaweicloud.com, kasong@tencent.com, linjh22s@gmail.com, kunwu.chan@linux.dev, kees@kernel.org, gustavoars@kernel.org, tglx@kernel.org
In-Reply-To: <1de96c68db9d3ac83ae485a1eddabcea1a2524a1.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
 <1de96c68db9d3ac83ae485a1eddabcea1a2524a1.1793106426.git.lianux.mm@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 16:14:58 +0000
X-Rspamd-Queue-Id: 65FD2180009
X-Rspam-User: 
X-Stat-Signature: jhubhsq4zt33rd88yo8j6otgi4rtsr5z
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793204100-606415
X-HE-Meta: U2FsdGVkX18tiNXPXbctCBiZ26J1vUJTRx7d2JRf5LFyT4rUdHfc+g/LS0A1T5XI6mqlo74WHMMzd4OFUT86HejClahBwPybdPKwJxFJaQAUuNdVs30l2t2SJMMCLjW/nOl3KljuOADzntHVFRmN3uyG0RL9GAAXBQQsxTMVzlmw5qVgVx9tiIIo5DpSNS9UKKwGIP1IDk6X6fa0y6VU71N+06TcvTW6xx1hKm9vGlpKFtzLyq5UJLosfIqiy0jc/lNa00CSl3+e8xZf7QY9FQkVN7BIEr03meKAVOAE6qVPq6LCxJxNcP5BfFTtHLrR3FKviMioOWWYfaHz0AYCfuGDfuulOPRQd72UI/CMhX2AvLCrra3ZFevvz7Wa1iQE6PkGUruI/clwCDvrDfezwJGyxUsSGua12qtWP7oVhzQi7JSgURrSz6PGf+3rI2+tWRR/fH7JSqpe3UVqFQ6Ogyi8jiQDqeF6Lzy+ZbhjUg1+3We4Xv6iSSDfyeLhElokrSof9SusgMrn8O6iWk41LJaYS3IGT8IWDE+9n4n7srsQ6UKPh2ljtgB/SUQPRFcGzW53F615LmpO+K6CbVFwv0slmAFnD6mPIK67tPCDtF3JLaSL4tXueUhr2FVY3f9NyUnbC/ylFCHgZ4PckNhvHS6YTEp5ae3pE2eENk6UJhe4m1EJPpvzKBVrTLADAmDRQG9B6Uo5xbsPmgHLGMudejKjH/dLklhvqI13GkTlOKwJ2wW4ixHLdzHH0qP/qxsJsSQNOBvEpAk/hQ3fAqh2wVZjmuUG4u+0stE9hUmqzZxkCuyLUwU00SFWd0P7i4TAUqoPGeo4tub3OrLVlHvrx7Oe9NRW3a/6XPFG45bEvCHcTFJ5Jk/iFP/rd0HfUYk3WfsOvQIXwdumE/AwsoQ75PC3TYbeFcUWFzA/gKg0rSvKtCtDGJr5rscT33Ew8sHE9TfPCbIY1GRDREB3LKe
 l2X3665H
 DiIsb36Pzp8BPQC1HeB0HFXt3VZE65keHr1VYHyDHvcXa8TjTv7LyGbiC/J0E27/0FNiZF37AAHpwls2CaPzWLQBThh6EwLZe4KD7fnTO5PgLm9FuxyXzCaVXH7g5Rtze7k4yXxKL1NAZMENBbXtsAWZgwYCThEstPLCp00gvTPFcLzHy63v85zv7FFgkILzeSNVxJtdn2p/c5I4CjDErngRUB1eE+zowVL/2HxcV2MDQLTYXUpBvDykcaWHIfS+GRGWD78Aj3RQf82T6Ieo5dYFWDtamA9gv3x7h4Plbd5hwbN568qNV7rYe2uzratFviN43h/t2vd4PUk7f+LaFpTWGbDw1cDiDRaGqZOODhfHsdsmiYPJ1kVBZ7ki7Wg9MoDlrohSuKealr0O1afD87AFGCF40ZHxepQeVNP68F0QTH2G9Hoj2DCIEa9Bv2cfkJRLurwky4McIRf9wXG7FvuC1gt64+t8JCTDHgZ9Ac8TB/HldTTm74lAl6uE9MvKAZIZhMEhC7Lp/drqVbG/3QNhXt6iKphKFBXpiq1tdqVQeNDUwFLlbd3YtcSw9p/q9KE0jwBbdneGHuFh9VBS2m1KFZGtdbRT69GESJ7OjB0FpdIOZK1fDFNn6ac7o4o3QciduieDlWpLihabTKIjpwhzsnl7yqEm6J1PVBwzcjZL0W8ttTblghbnjSK4mQiD7gOwNvcmAhlq7kzkr61K1pw3rDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm/swap: synchronous discard under swapon_rwsem in cluster_alloc_s=
wap_entry()
- [Medium] mm: premature swap allocation failure in cluster_alloc_swap_entr=
y()
--

commit 148b9ddc65b48866a2eb76b6131e127b4a148727
Author: Kairui Song <kasong@tencent.com>

mm/swap: bound synchronous discard during allocation

This commit replaces the global synchronous discard fallback with a
per-device single-cluster discard in cluster_alloc_swap_entry() when a
swap device's free cluster list is empty.

Link: https://lore.kernel.org/all/CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOG=
V-oax++kWA@mail.gmail.com/

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0a16343a5b03c..5c26682c0bab2 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -1576,6 +1585,15 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>  		found =3D alloc_swap_scan_list(si, &si->free_clusters, folio, false);
>  		if (found)
>  			goto done;
> +
> +		if (!discarded) {
> +			swap_alloc_unlock_device(si);
> +			if (swap_discard_one_cluster(si)) {
> +				discarded =3D true;
> +				goto restart;
> +			}
> +			swap_alloc_lock_device(si);
> +		}
>  	}

[Severity: High]
Is it safe to call swap_discard_one_cluster() here while holding
swapon_rwsem for reading?

Previously, swap_sync_discard() dropped swapon_rwsem after pinning the
swap device before issuing synchronous discard I/O:

mm/swapfile.c:swap_sync_discard() {
	...
	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
		percpu_up_read(&swapon_rwsem);
		if (get_swap_device_info(si)) {
			if (si->flags & SWP_PAGE_DISCARD)
				ret =3D swap_do_scheduled_discard(si);
			put_swap_device(si);
		}
	...
}

With this change, swap_alloc_entry() holds percpu_down_read(&swapon_rwsem)
and migrate_disable() across cluster_alloc_swap_entry(), which only drops
the device cluster lock via swap_alloc_unlock_device(si) before calling
swap_discard_one_cluster() -> discard_swap_cluster() ->
blkdev_issue_discard(..., GFP_NOIO) -> submit_bio_wait().

If a writer such as swapon(), swapoff(), or pin_hibernation_swap_type()
calls percpu_down_write(&swapon_rwsem) while submit_bio_wait() is waiting
for the REQ_OP_DISCARD bio to complete, new readers calling
percpu_down_read(&swapon_rwsem) in swap_alloc_entry() will block behind
the writer. Could this stall system-wide swap allocation, or deadlock if
a block backend worker (such as ublk or nbd) needs memory reclaim and swap
allocation to complete the in-flight discard request?

Also, on loop-backed swap devices, processing REQ_OP_DISCARD in the loop
worker calls lo_fallocate() -> file->f_op->fallocate(), which acquires
inode_lock() on the backing file. Since swapon() holds inode_lock() while
calling swap_queue_lock_for_add() -> percpu_down_write(&swapon_rwsem),
doesn't waiting for discard completion under percpu_down_read(&swapon_rwsem)
invert the lock ordering between inode_lock() and swapon_rwsem?

[ ... ]

> @@ -2149,14 +2134,8 @@ int folio_alloc_swap(struct folio *folio)
>  		}
>  	}
> =20
> -again:
>  	swap_alloc_entry(folio);
> =20
> -	if (!order && unlikely(!folio_test_swapcache(folio))) {
> -		if (swap_sync_discard())
> -			goto again;
> -	}

[Severity: Medium]
Can removing the post-reclaim discard retry cause folio_alloc_swap() to
fail prematurely when si->discard_clusters is populated during cluster
reclaim?

In mm/swapfile.c, when cluster_alloc_swap_entry() is entered on a
SWP_PAGE_DISCARD device with both si->free_clusters and
si->discard_clusters initially empty, alloc_swap_scan_list() on
si->free_clusters and swap_discard_one_cluster() both return false,
leaving discarded set to false.

cluster_alloc_swap_entry() then scans si->nonfull_clusters, calls
swap_reclaim_full_clusters(), and scans si->frag_clusters. During these
steps, cluster_reclaim_range() and swap_reclaim_full_clusters() call
__try_to_reclaim_swap() -> swap_cache_del_folio() ->
__swap_cluster_free_entries(). When reclaiming unmapped swapcache folios
drops a cluster's count to zero, free_cluster() schedules it for discard:

mm/swapfile.c:free_cluster() {
	if ((si->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) =3D=3D
	    (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
		swap_cluster_schedule_discard(si, ci);
		return;
	}
	...
}

Because swap_cluster_schedule_discard() sets ci->flags to
CLUSTER_FLAG_DISCARD and moves the cluster to si->discard_clusters,
cluster_reclaim_range() sees !cluster_is_usable(ci, order) and cannot
allocate from the cluster it just emptied:

mm/swapfile.c:cluster_reclaim_range() {
	...
	spin_lock(&ci->lock);
	/* Recheck after lock drop, another user might have used it. */
	if (!cluster_is_usable(ci, order)) {
		*usable =3D false;
		return false;
	}
	...
}

Previously, folio_alloc_swap() called swap_sync_discard() after
swap_alloc_entry() failed and retried the allocation, which discarded the
clusters newly queued to si->discard_clusters during reclaim. Now,
cluster_alloc_swap_entry() never checks si->discard_clusters again after
the nonfull, full, and fragment cluster scans, returning
SWAP_ENTRY_INVALID even though discarded is still false and reclaim just
queued discardable clusters.

In addition, when swap_discard_one_cluster() does discard a cluster, it
places the cluster onto the shared si->free_clusters list via
__free_cluster() and releases ci->lock while the caller does not hold
swap_alloc_lock_device(si). If another CPU isolates that cluster from
si->free_clusters before the discarding task re-acquires
swap_alloc_lock_device(si) at the restart label, won't the discarding task
see an empty si->free_clusters list and fail the allocation even when more
clusters remain on si->discard_clusters?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793106426.gi=
t.lianux.mm@gmail.com?part=3D12

