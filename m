Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF91606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BDC6B050E; Tue, 20 Oct 2026 11:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33826B050F; Tue, 20 Oct 2026 11:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71386B0510; Tue, 20 Oct 2026 11:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4316B050E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:54:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1827FA0206
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:54:19 +0000 (UTC)
X-FDA: 85343451438.08.E173F44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 702851C0009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:54:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792511657;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxB0sJoqT2ygQ6sp4LzbXJKiFPeHWvevNR0ynXayBAw=;
	b=dzkZOixDie6oBCbsC8HfNK4EQpgmedL1sgaVguP/UaVj+95Nexw1t+wwrcxtE38YXysCXC
	Dn9rW90BdZ3H6mmDe41AT8BG8sRowLUOzgIjbQ/mVEZVYKChJWzxLCN8XpdDcGD56ust7N
	hIMFP1h6eemIyAPPtaSDRe4cK5Z8vhY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792511657;
	b=CfwD01gzFIZOa+9L4y7HxyfeB7pwz7wOmYmy/y8mtZvNCyXk8lRT94KF3KwS947wUqKhXz
	mzXBbiBKbJpEwhzobj5ToQ6PDyFsGO+vBd04B/yE//OhHYAGYU6DWexUX3FDdoK6uMXEnG
	mYaEOJ2sP2hsx+T+tHjeNtuySKSXDJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4E8940E29;
	Tue, 20 Oct 2026 15:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C9E1F000C4;
	Tue, 20 Oct 2026 15:54:14 +0000 (UTC)
Message-ID: <sashiko-outbox-179312@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 14/18] mm/filemap: read from the page cache without
 folio references
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R . Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E . McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Harry
 Yoo" <harry@kernel.org>, "Luis Chamberlain" <mcgrof@kernel.org>, "Ilya
 Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261019154913.1765974-15-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
 <20261019154913.1765974-15-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 15:53:43 +0000
X-Rspamd-Queue-Id: 702851C0009
X-Stat-Signature: sy596c66c1fmbq6ykfw55c8f937n5obu
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792511657-90422
X-HE-Meta: U2FsdGVkX182m2+n3zTeoHVBzoLv1LSLGAaR5hbLO0o8HypnTsWEqKaTLejSPg9gstRvGWJ6RWJFHANOMoUZiISVqPDn4I33ihu8AV1RF7Tjcu1IJgpmoIvRtCAcboiACh+XpcpXr+ooKMf/Ow1MEKrd93Jn4Dc554GaHdH+LOzkY/QUNRoqEbQaQ05UZx89LQjv9UNHuq25PbvEdDgXrg0+pbPrVWqeqVghDQYVu5pxH28PB4Nazgh60IBf7uRwe16icgl9JMHXeChlV5UwDeb1eCSvKIsb4vDrfMNbixII+ODfpJOqRg3+N6imRQtMaN8NCip732TwzfMMfgUwADBk5V9+ZW2YK9W/KVKnBvstZZzvNjKy79k+D12zrXExQQPisjrlJxJVtvVT7PAfnAkHZtlbTeuYKfPP+euTxSM7CbGK/pVFh/qmo4Y6JXs9nKZAB06+7lvkrSx8MJKm6L1/AfJiPwnDmfTOcf7JVOBJmHE3FabaSrrs8smWJxhqYc136Y65FURiXp16TOJ41LxukwEq1jU7FHYIy/P+19SE8CfnghecX9HpLBxLJLc+eQrBAgtwu5W5uFM6xceyugIGKKpuRDTgo8b2g0AANbhrUO5gxS2irn7yhDZyZSTUusbk/yAGfEtUTDOeXffd5kPbjsgFnNUejQ76VEnzF1rPUB+HhqqiO39K5wVrb8xcCZC2GE4UbKmRWJa2Wygzy7UxckvyR+LjP5NBzvbNn0RvpWyyLGB+rWcXsiapgVoTK2CURuFTbixkB646bz9R+oI3MjgeEdYCR14XEMNJJXJmKKDckjovv0+b+zKalmC7tYYa7qoin7TYHSzxA57+/YmDSNK44SZU9JZKt4EojdzF6BHcx0SJrTtpD6wLZdkTf829GNoAN77IU56+OVrH2SwabMgMiUxxmgpA3LxpeMqGL343U8KtifiAhNRVXicCPTD8hHWaMtXtZ+/5VWS
 4vnCH5VM
 9GVgWla5uc/jNkX7EMK11AYDKCfu9Ejuu+8J9K2KNNzuzlmRaoFTlMMJAeMV1xA6rwxWJuG5ukV/SSowECqLdqo1qY9u9F3miI5/OfNpPDS/skGSSBrTRCZDTMhilU/+sOxAolcfuAkYI4ZAwKcRQ0xCg+exR0g2ARCxR6RUifrSD0jnVotfMeb1fuxHmM54eCTF8tkKxO+agr3TB7daUvGiHymcF4NyUTCjchW+rKaLpouRg6qjBV6dYGaNUbRwN4VYYvuqTrXQ2ytqS3q3G55sO4zTnxk4MLX9gT27t2ixO/PQH3GFfiw+zetAhSZlUUr+d6oUevInvw8ks6T0gw3rCtztwkgcppGbhq0pD5jqCs5xcE6InANfjajgF3F9/fh+nGJp03eanja/YytITUrL2EqFCiUTnx4tijv1FJCOID5E9LT9u/cfUrp/pVxK5+Fvb5ANctehqkjLeiwXkoAr549o/HsZwF5XkWEB/+8G6ttUxF/GXUlv9brKVttU1LtWqvji8Ux/vUu6qHKMlKHB8sQeQKEUx4LcCNpsU7M0XqIShIovWiP2wxlr4RohVXJDGTmxdGPPpTLw24dY/LrWQMF6pKY9/C1MEy9Yu8KB4mDkz8H7wqVVYyuRBhzSy3uJthNzVQPO8J+8iWjDxBuJyCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] mm/filemap: race with folio split in filemap_read_rcu_can_copy=
()
- [Critical] mm/filemap: use-after-free in filemap_read_rcu() when AS_EXITI=
NG is set on live inode
- [High] mm/filemap: ABA race in filemap_read_rcu_lookup() via folio_clear_=
rcu_free()
--

commit 9b6ffbf436977a22ceda82d50abf0d37c589cc75
Author: Linus Torvalds <torvalds@linux-foundation.org>

mm/filemap: read from the page cache without folio references

This commit adds a fast path to filemap_read() that copies from hot page
cache folios marked with PG_rcu_free under rcu_read_lock() without taking
folio references. Folios that are not uptodate, need readahead or
dropbehind, are not hot, have a poisoned page, or are large are left to
the slow path.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 960d53b61d4b1..55fc471c04892 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2827,6 +2827,165 @@ static void filemap_end_dropbehind_read(struct fo=
lio *folio)
>  	}
>  }
> =20
> +/*
> + * Whether filemap_read_rcu_batch() can copy from @folio, or has to leav=
e it
> + * to the slow path, which holds a reference for readahead, dropbehind a=
nd
> + * folio_mark_accessed(), and deals with poisoned pages.  @last_index is=
 the
> + * page the previous copy ended in.
> + */
> +static bool filemap_read_rcu_can_copy(struct folio *folio, pgoff_t index,
> +				      pgoff_t last_index)
> +{
> +	if (!folio_test_uptodate(folio))
> +		return false;
> +	if (folio_test_readahead(folio) || folio_test_dropbehind(folio))
> +		return false;
> +	/* memory_failure() waits only for readers that got past this */
> +	if (folio_contain_hwpoisoned_page(folio))
> +		return false;
> +	/* One reference covers all of a large folio's pages */
> +	if (folio_test_large(folio))
> +		return false;

[Severity: Critical]
Can filemap_read_rcu_can_copy() race with a concurrent split of a large
folio to order-0?

filemap_mark_hot() sets PG_rcu_free on hot page-cache folios without
excluding large folios, and __split_folio_to_order() preserves
__PG_RCU_FREE. Because filemap_read_rcu_lookup() does not take a folio
reference or check for a frozen refcount, __folio_freeze_and_split_unmapped=
()
can freeze and split a large folio while filemap_read_rcu_batch() operates
on it under rcu_read_lock().

In __split_unmapped_folio(), xas_split() populates all split XArray slots
with the original head folio until the post-split loop in
__folio_freeze_and_split_unmapped() overwrites each tail slot via
__xa_store(), so xas_load() and xas_reload() at index > folio->index
continue to return the original head folio across __split_folio_to_order():

mm/huge_memory.c:__split_folio_to_order() {
    ...
    folio_clear_has_hwpoisoned(folio);
    ...
    if (new_order)
        folio_set_order(folio, new_order);
    else
        ClearPageCompound(&folio->page);
}

This appears to cause two issues:

1. folio_contain_hwpoisoned_page(folio) evaluates:

    folio_test_large(folio) && folio_test_has_hwpoisoned(folio)

where folio_test_has_hwpoisoned() calls const_folio_flags(folio, 1):

include/linux/page-flags.h:const_folio_flags() {
    ...
    VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
    VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
    return &page[n].flags.f;
}

If ClearPageCompound() clears PG_head between folio_test_large(folio) and
const_folio_flags(folio, 1), won't VM_BUG_ON_PGFLAGS fire (or, when
CONFIG_DEBUG_VM_PGFLAGS is disabled, read page[1].flags.f where
PG_has_hwpoisoned aliases PG_active on the newly split order-0 folio)?

2. When reading at index > folio->index, if __split_folio_to_order() clears
PG_has_hwpoisoned and PG_head before filemap_read_rcu_can_copy() runs, both
folio_contain_hwpoisoned_page(folio) and folio_test_large(folio) inspect
subpage 0 and return false. filemap_read_rcu_batch() then calls:

    copy_page_to_iter(folio_page(folio, index - folio->index),
                      offset, bytes, iter);

which copies from the newly split order-0 folio at index without checking
its flags. In particular, if memory_failure() poisoned that tail page via
SetPageHWPoison() and split the large folio via try_to_split_thp_page(),
PG_hwpoison is only set on that subpage while PG_has_hwpoisoned and PG_head
are cleared on folio, allowing copy_page_to_iter() to read from the
poisoned page.

Note that the later commit in this series ("mm/filemap: read large folios
without folio references") removes the folio_test_large(folio) check from
filemap_read_rcu_can_copy() and does not avoid these races.

[ ... ]

> +static struct folio *filemap_read_rcu_lookup(struct xa_state *xas,
> +		struct inode *inode, loff_t pos, loff_t *isize)
> +{
> +	struct folio *folio;
> +
> +	xas_set(xas, pos >> PAGE_SHIFT);
> +	folio =3D xas_load(xas);
> +	if (xas_retry(xas, folio) || !folio || xa_is_value(folio))
> +		return NULL;
> +
> +	/* Not folio_test_rcu_free(): it may not be a folio any more */
> +	if (!(READ_ONCE(folio->flags.f) & __PG_RCU_FREE))
> +		return NULL;
> +	/* Read i_size and slot after the flag: it implies uptodate */
> +	smp_rmb();
> +	*isize =3D i_size_read(inode);
> +	if (pos >=3D *isize)
> +		return NULL;
> +	/* i_size_read() is an acquire; a write fills the slot first */
> +	if (xas_reload(xas) !=3D folio)
> +		return NULL;

[Severity: High]
Can folio_clear_rcu_free() during inode eviction allow an ABA race on
folio in filemap_read_rcu_lookup()?

In page_cache_delete() and page_cache_delete_batch(), PG_rcu_free is
cleared when mapping_exiting(mapping) is true:

mm/filemap.c:page_cache_delete() {
    ...
    /* No lockless reader can be in an evicted inode */
    if (folio_test_rcu_free(folio) && mapping_exiting(mapping))
        folio_clear_rcu_free(folio);
}

Consider a lockless reader in filemap_read_rcu_lookup() on an open file
(inode A):

1. xas_load(xas) returns folio F from inode A, where F does not have
   PG_rcu_free set.
2. F is removed from inode A and freed immediately (since PG_rcu_free is
   not set).
3. F is reallocated for another file (inode B), added to inode B's page
   cache, and marked with PG_rcu_free by filemap_mark_hot().
4. The reader on inode A checks READ_ONCE(folio->flags.f) & __PG_RCU_FREE
   and sees __PG_RCU_FREE set.
5. Inode B is evicted; truncate_inode_pages_final() sets AS_EXITING and
   page_cache_delete() / page_cache_delete_batch() calls
   folio_clear_rcu_free(F), freeing F immediately without an RCU grace
   period.
6. F is allocated again and inserted back into inode A at the same XArray
   slot without PG_rcu_free set.
7. The reader on inode A sees xas_reload(xas) =3D=3D F and returns F.

At that point, filemap_read_rcu_batch() accesses F in
filemap_read_rcu_can_copy() and copy_page_to_iter() without a reference and
without PG_rcu_free set on F, so a subsequent removal from inode A can free
and reuse F while the reader is still copying from it.

> +	/* Read the rest of the folio only once the slot holds it */
> +	smp_rmb();
> +	return folio;
> +}
> +
> +/* Bytes one RCU read section copies at most: it holds up grace periods =
*/
> +#define FILEMAP_RCU_READ_MAX	SZ_512K
> +
> +/*
> + * Copy from folios with PG_rcu_free without taking references, at most
> + * FILEMAP_RCU_READ_MAX bytes under one rcu_read_lock().  Return true if=
 that
> + * much was copied and the read is not done.  *last_index is the page the
> + * previous copy ended in, set as the slow path sets last_pos.
> + */
> +static bool filemap_read_rcu_batch(struct kiocb *iocb, struct iov_iter *=
iter,
> +		pgoff_t *last_index, size_t *copied)
> +{
> +	struct address_space *mapping =3D iocb->ki_filp->f_mapping;
> +	struct inode *inode =3D mapping->host;
> +	XA_STATE(xas, &mapping->i_pages, 0);
> +	size_t budget =3D FILEMAP_RCU_READ_MAX;
> +	bool more =3D false;
> +
> +	/* flush_dcache_folio() is not known to be safe without a reference */
> +	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE &&
> +	    mapping_writably_mapped(mapping))
> +		return false;
> +
> +	/* A user fault cannot sleep in the RCU read section: it ends the copy =
*/
> +	rcu_read_lock();
> +	pagefault_disable();
> +	while (iov_iter_count(iter)) {
> +		loff_t pos =3D iocb->ki_pos;
> +		pgoff_t index =3D pos >> PAGE_SHIFT;
> +		size_t offset =3D offset_in_page(pos);
> +		struct folio *folio;
> +		size_t bytes, n;
> +		loff_t isize;
> +
> +		if (!budget) {
> +			more =3D true;
> +			break;
> +		}
> +		folio =3D filemap_read_rcu_lookup(&xas, inode, pos, &isize);
> +		if (!folio)
> +			break;
> +		if (!filemap_read_rcu_can_copy(folio, index, *last_index))
> +			break;
> +
> +		bytes =3D min_t(loff_t, isize - pos, iov_iter_count(iter));
> +		bytes =3D min3(bytes, budget, PAGE_SIZE - offset);
> +		/* Not _nofault(): its usercopy check reads the folio's order */
> +		n =3D copy_page_to_iter(folio_page(folio, index - folio->index),
> +				      offset, bytes, iter);

[Severity: Critical]
What prevents a use-after-free here when truncate_inode_pages_final() is
called on a live inode?

page_cache_delete() and page_cache_delete_batch() assume that
mapping_exiting(mapping) is only set during final inode eviction when no
readers can be active, and clear PG_rcu_free so the folio is freed
immediately without waiting for an RCU grace period.

However, f2fs calls truncate_inode_pages_final() on live open files during
atomic write operations:

fs/f2fs/file.c:f2fs_ioc_start_atomic_write() {
    ...
    if (truncate) {
        set_inode_flag(inode, FI_ATOMIC_REPLACE);
        truncate_inode_pages_final(inode->i_mapping);
        f2fs_i_size_write(inode, 0);
        isize =3D 0;
    }
    ...
}

and in f2fs_abort_atomic_write():

fs/f2fs/segment.c:f2fs_abort_atomic_write() {
    ...
    if (clean)
        truncate_inode_pages_final(inode->i_mapping);
    ...
}

When f2fs_file_read_iter() -> filemap_read() -> filemap_read_rcu() ->
filemap_read_rcu_batch() runs concurrently with
f2fs_ioc_start_atomic_write() or f2fs_abort_atomic_write(),
truncate_inode_pages_final() sets AS_EXITING (before i_size is zeroed in
the start_atomic_write case) and truncates the mapping's folios.
page_cache_delete() / page_cache_delete_batch() sees mapping_exiting() and
clears PG_rcu_free, freeing the folios immediately while
filemap_read_rcu_batch() is copying from them under rcu_read_lock().

Additionally, because AS_EXITING is never cleared on the live inode's
mapping, any folios subsequently added and marked with PG_rcu_free by
filemap_mark_hot() will also have PG_rcu_free cleared on any later
truncate, hole punch, or reclaim while lockless readers are copying from
them.

[ ... ]

>
>
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019154913.1765=
974-1-kas@kernel.org?part=3D14

