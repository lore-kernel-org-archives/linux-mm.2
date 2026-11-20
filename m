Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF2D606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 20:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dnbcJeQh
Received: by kanga.kvack.org (Postfix)
	id 6C3CB6B05B0; Fri, 20 Nov 2026 15:11:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627146B05B3; Fri, 20 Nov 2026 15:11:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562DD6B05B4; Fri, 20 Nov 2026 15:11:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 364F96B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:11:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FB9714012F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:11:51 +0000 (UTC)
X-FDA: 85456593222.21.30F87AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A4F1110000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:11:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnbcJeQh;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795205509;
	b=PoNBh5EhMP4kAP/edC9rFxYYzot7NurwC49W5GFeb6HVzgczYEJ3M6BJGStW2ppZ1+PZUT
	fhIEFnIdZm9SC/eKSfhNJUWj2csfwSXD3oKqOBoVAc+fYTEK3bxh0gJlE7jkyxOSBSSs4C
	OCkliMNNWRGM3Ew9ivfXn4aRda0EbW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795205509;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfsBEMGhx4Fh2PmnLWTGaQElHwcxVx4X18qdlNbyQXc=;
	b=U05zzGkLtFqNa1csIZ4WrgHUKAdMgSlUElvzV0i66e0bJzCgHWKd617zeMCWbnjHd/6/FL
	TRdHvYkhaMR6pI3k+9etXoKLrmkN7JxDOfv4x0FaChuzjRRxO1WlBUyNMLy7Prr7gwD+T0
	Si/VqCxTvJLKXqDcRmMdckbEDGrxkfw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnbcJeQh;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5084E623C7;
	Fri, 20 Nov 2026 20:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2941F000D0;
	Fri, 20 Nov 2026 20:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795205508;
	bh=nfsBEMGhx4Fh2PmnLWTGaQElHwcxVx4X18qdlNbyQXc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dnbcJeQhjxfEbyzCwV9BmpAElVPrFgze7maEBJWLQ4B/thu5K41q9ozrp6++J2hp7
	 D8AFv3iYurqXyzBRoDaBmFSMWRGepykcPPRhwtr7M7utJym/S3tz677Qwa7T+ICljp
	 cCjHa3y1EBtHQRfOOPTKnuNqGb9d5LcAfvHFEFohJjCCbQkhPgHYqaMdqRDKk/BIRK
	 nMePNg0hCfX4OyUZXVLg/JqGz84Jj7mwOE6SzQxOXAHCYIWl86J5WQMe4ZONsZ+0mI
	 3uMcjyYI/5GK7NejjMPVEkff+qf6WjWsFhIoqwUF5w+fX/5ilbfiwhbQExQNqYlrM6
	 xDOnHn9OeXBUg==
Message-ID: <sashiko-outbox-226011@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 5/5] mm/filemap: refuse releasing maybe_dma_pinned
 folios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pedro Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Zi Yan" <ziy@nvidia.com>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Lorenzo Stoakes" <ljs@kernel.org>, "John Hubbard" <jhubbard@nvidia.com>, "Peter
 Xu" <peterx@redhat.com>, "Johannes Weiner" <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, linux-mm@kvack.org, "Kairui Song" <kasong@tencent.com>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Michal
 Hocko" <mhocko@kernel.org>, tytso@mit.edu, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261119-gup-dirty-what-v1-5-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-5-236d69f25c24@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 20:11:46 +0000
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A4F1110000A
X-Stat-Signature: kucgkk6fa8ufyr8a9w8w93dwywz63fwu
X-Rspam-User:
X-HE-Tag: 1795205509-117357
X-HE-Meta: U2FsdGVkX1/WplrVM8OlSEQZf1Go8zhMJ+7r1jxXruEq0SmuV7b8Ut68EFCmv0u/QgrdtbMrEb68i9vfjXRMjrtuzRiL3MFlUwNbz3AyN/X0MEz9lydNB8OFR0QzVGcTxsWCfwczLAvCYWYLE5AJBEAKmF4PY2xcVoVj6VfhlTP0lR0F1VnOEGiv0+zkd573nUXZiD61F++v6ult51IIR6gcqX7TyNGST1OQbULFxNoq8MfwHUCZ+/OuqM439bN7I9+J9lGxHPyo+h9uoQ3qvd+FS5gDYyQA60CuHICz8CNhD2UrUOhdWxwuGtq15U3Qu4aogMV7/6qOQ+AJqlG51D2YG78ayoPtgq5cit1H9F6KdoqEVqJfIf98to+UECk82irO57sJAvBatw5DJA5WBlYcgK0Ob0D6dHsSfBPNQUC417Vf/rLImjhs3SoQf1I/yy6olRqUCfL/ZoOfZWeCqUqlg7Hb5D5bgylf2z+WpOuGopUgo0ceJcX1ktJkOxVmYvJHbU8WvWqhMfvj68A9Nyp/m36lCn+9TjiC1B231DJi0JDtIiycSxXwLX5Ejejt4eaOBvCVEWIZYrcAV0SLh2v3X41IA4yVeJBI8pzw8V8mo3wKoJmWHqSCUzEDyKo6y0B9qlnR8yQqpszuUuCEuSraD6u2eq9HaoF0zcuJ2RIKjPAzWWsAwfu9ZDcPldi+4pwkgZBPZty0OIVj/ae9vdABPcO/JbjCjghCfhbFbi82so97lO/8aWxi+glCyUrzO3sFHExBlVPKQ7iWk0Y0XXSFkbinw/1LM7vOhdNQS3BqKW/hwuUoHUEt71nsJW1KdBUTfHSavl71+hLZGVwexV3ND+slr7WcPsqDIbfw6Bg+m7HKnGFWWk51gjUiGecRc34s6ChPFkPucao+cCfW5+fFi/GtFZtMmJduEvsMGROfNzQHTEDUjVU1LnbimGRsUjAw44youC9jkOybqYo
 DR+BCMsi
 vVeFYLRdsoc5IOrW7vEtUybRmq7RWtv48mxIyQq+UJURVsAJ8d99WYxvo56/z+a611s3/JRYqbZHjsxoXfbDMLSzXT+JnZkTz162HqQRVvn05DUBJTHI1RH40qCoxBaCN2K25BTpG/CHu/L6ScVQYDnkNDvAoMcXwhpedZf68tfh4+Sp49J/UqMTdDHoO7Ho3GFmlRUsEHppljE+4dQHvWJW8l2QSsRGQ56NcQ3PjijVLezPl700yyb+fa6mfZGtdTh7Is2o9soEpvwPXiUKnV7Y3/Pfxqpl1KuwiodrLiBsJlJ/HetATA0RUBHGGMw4gTRcoMcyEX6RxqeXg1qSFr72p6xs2/+vLDXF7qb8R5EVBuubNzXHen9LtEim9q1QON8GrLRiwH/AuBCdbjsiD348URg+FyzgY/lA9DKNuFfeTGXmEYJshvR6q1CO864HAHI9oqJxkyrBZ+RSQk4Ndby38GI09fK2nk2CsCJKRLHXcCIDmbBK5AkebQ6feEj3cqsGC0cJ5ca/4Qd+T4QTpRTulIspKOQ2P0XnTBpGMxG+IXowuyBFET/h1JJPrX+jhK5NtL8C2nzVud2kMTz06QXIwVOc+lRXqpQGGYI7YIWZon5yutF84bmt9xOTtcDOE1YsQc1wluUSDscSRSPe82x0qi1v5ONnKZPziBvzEYPWNJCkbPweCw9W7s7Z3DkEmuwndj+zEBOXliO+ms4Zo4d0JKzB5yQlnQlBvYJ+on6WS8Hint89nnLsNnZ+k09ysvNSAMRQGk6yX/PB4ltHzG51HROOy8MmUw2igYzGJ2kSSmGujMz63USdyG3bcLajOf/bZUnx1i5MzLc9zMx6yr+6RyAE1mcc0+hK2rnuRHqNUcfzHTs6RnGa4JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm/filemap: filemap_release_folio() dma-pin check breaks
  folio_invalidate()
- [Medium] mm/filemap: VM_WARN_ON_FOLIO on mapped folio hit via
  mext_move_extent()
- [Medium] mm/filemap: VM_WARN_ON_FOLIO in filemap_release_folio()
  precedes needs_release
--

commit 38a290b76cc80ed81b7d5a26e8b50ef48dfba24c
Author: Pedro Falcato <pfalcato@suse.de>

mm/filemap: refuse releasing maybe_dma_pinned folios

This commit updates filemap_release_folio() to warn if the folio is mapped
and refuse to release filesystem metadata when folio_maybe_dma_pinned() is
true.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index f9e34144c53c7..4fa75663b7f3e 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4571,8 +4571,11 @@ bool filemap_release_folio(struct folio *folio, gf=
p_t gfp)
>  	struct address_space * const mapping =3D folio->mapping;
> =20
>  	BUG_ON(!folio_test_locked(folio));
> +	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);

[Severity: Medium]
Can EXT4_IOC_MOVE_EXT hit this VM_WARN_ON_FOLIO() on a memory-mapped file?

In fs/ext4/move_extent.c, mext_move_extent() locks the origin and donor
folios and calls filemap_release_folio() on them without unmapping them
from user page tables or checking folio_mapped() first:

fs/ext4/move_extent.c:mext_move_extent() {
	...
	if (!filemap_release_folio(folio[0], 0) ||
	    !filemap_release_folio(folio[1], 0)) {
		ret =3D -EBUSY;
		goto unlock;
	}
	...
}

If either file is memory-mapped with resident PTEs in the moved range, an
unprivileged EXT4_IOC_MOVE_EXT ioctl triggers this warning when
CONFIG_DEBUG_VM is enabled.

>  	if (!folio_needs_release(folio))
>  		return true;

[Severity: Medium]
Should VM_WARN_ON_FOLIO(folio_mapped(folio), folio) come after the
!folio_needs_release(folio) check to match filemap_may_release_folio()?

filemap_may_release_folio() returns true when !folio_needs_release(folio)
before checking folio_mapped(folio):

mm/internal.h:filemap_may_release_folio() {
	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
	if (!folio_needs_release(folio))
		return true;

	/* There's no way to know whether these are write-mapped, so give up. */
	if (folio_mapped(folio))
		return false;
	...
}

Callers such as collapse_file() (which calls try_to_unmap() without
TTU_SYNC) and __folio_freeze_split_file() (which calls unmap_folio())
can leave a folio mapped if unmapping races with zap_pte_range(), then
rely on filemap_may_release_folio() to gate filemap_release_folio().
For a folio that does not need release, filemap_may_release_folio()
returns true and filemap_release_folio() then triggers
VM_WARN_ON_FOLIO(folio_mapped(folio), folio).

> +	if (folio_maybe_dma_pinned(folio))
> +		return false;
>  	if (folio_test_writeback(folio))
>  		return false;

[Severity: High]
Does refusing to release a DMA-pinned folio here break truncation via
folio_invalidate() and leak the folio and its buffer_heads?

During full-folio truncation, truncate_cleanup_folio() calls
folio_invalidate() before removing the folio from the page cache.
block_invalidate_folio() and gfs2_invalidate_folio() first discard all
buffers on the folio and then call filemap_release_folio(folio, 0) to
free the buffer_heads and clear PG_private.

If filemap_release_folio() returns false because the folio is DMA-pinned,
truncation still removes the folio from the page cache and sets
folio->mapping =3D NULL, leaving PG_private and the discarded buffer_heads
attached.  When the DMA pin holder later unpins the folio as dirty (for
example via unpin_user_pages_dirty_lock()), folio_mark_dirty() sees
folio_mapping(folio) =3D=3D NULL and calls noop_dirty_folio(), setting
PG_dirty on the orphaned folio while PG_private holds a reference.  When
shrink_folio_list() later scans this folio on the file LRU, it sees
folio_test_dirty(folio) and jumps to activate_locked before reaching the
orphaned buffer release path, and because folio->mapping is NULL nothing
can ever write it back or clear PG_dirty, permanently leaking the folio
and its buffer_heads on the file LRU.

On GFS2, gfs2_invalidate_folio() -> gfs2_discard() also leaves struct
gfs2_bufdata attached at bh->b_private to be freed by gfs2_release_folio();
once truncation clears folio->mapping, any later filemap_release_folio()
call sees mapping =3D=3D NULL and falls back to try_to_free_buffers() inste=
ad
of mapping->a_ops->release_folio, permanently leaking struct gfs2_bufdata
even if the folio was not dirtied.  In ext4's mpage_release_unused_pages(),
a failed delayed allocation calls block_invalidate_folio() and then
folio_clear_uptodate(folio), relying on filemap_release_folio() ->
try_to_free_buffers() -> folio_cancel_dirty() to clear PG_dirty, so
returning false leaves a pinned folio in the page cache with PG_dirty set
and PG_uptodate clear.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-gup-dirty-=
what-v1-0-236d69f25c24@suse.de?part=3D5

