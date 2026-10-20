Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C5C606A327
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851176B0511; Tue, 20 Oct 2026 11:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828176B0512; Tue, 20 Oct 2026 11:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765FE6B0513; Tue, 20 Oct 2026 11:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42FED6B0511
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:54:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB4D14020F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:54:51 +0000 (UTC)
X-FDA: 85343452782.02.7230BD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 484C1120009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:54:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792511690;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDTYtkirtkae8HUKpkTRrxZ2akKCw7vHpOwPBPYRBm0=;
	b=lX824nCg+Qm9kEVL4faWxAV/KWLptb/sESAIGRuZqM0mjhKhvcPefU/F7cO3a7rv9zSucy
	3PeN6++UmZQOwc9F3VYKjdCl4eh6t/BRa/552gtLWv2+s27xafG5iGaiSb6bgrEhIAwP6W
	eXXO/D+nRReRI+kSTIKIeKfmxynlchQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792511690;
	b=vPmeHDNXK9m6ZmLGlXojj5f2BXHqdn0ETncfc4S2S4XVd8shyB2sytJy2G97/YAYzhoT4T
	YvGQqwlT8RnSimrGCCXjbMbjpOog/ZTNPrOHfHL8aEAfpuooyfRqPdi3o1JayZ03KNOyIS
	aKhXA7LbpQa2KhmRmN0+gJ7SrNwiyWI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D822860D94;
	Tue, 20 Oct 2026 15:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5E41F000C5;
	Tue, 20 Oct 2026 15:54:47 +0000 (UTC)
Message-ID: <sashiko-outbox-179313@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 15/18] mm/filemap: read large folios without folio
 references
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
In-Reply-To: <20261019154913.1765974-16-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
 <20261019154913.1765974-16-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 15:54:16 +0000
X-Rspamd-Queue-Id: 484C1120009
X-Stat-Signature: z1cb9kgr347spuc89ummgk1pq58puxdw
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792511690-730588
X-HE-Meta: U2FsdGVkX1/5t8mkZ7+YZoTRuPQTsfZB+/WjQBB/vLEHnUX4kOnQsHie5EFOdvzVI7mGOzLyOm+n/M2WoPl+/ALw23+drfIb7G7wwMXW5C8Ij7V536D/iR6kWeQiLD9kGu7h7D04qTw2ve9tSDY/EvlgxayoXRZvnxG1I4pVD70KGJwA5SXn+GKwC5Qx0rWCqH2QjDwKRW3HRycbL6ygixYXECyF/aW4OcBA4PxcMVkXCtBVzCsEmePFsIDLOESmhPIKQxmpOPqriRXRjWaypzp+C64hUxAQlNj0pn8CZazmiJ0V6kP/7snnRxNahB0yCYZPAdO2IY8yC5/4sNd85aylBbfijLM3qPut2867dqaeoHkUmu4P83Q6ulXfjqF0byPd4pdViXQE2scgJxrw3pMHj7iQAwqcdU4ePnTpHVDykRD/k/ntO6bYvcBR/lnnLsFGvKwoQ0LedhDfYNbaUeqEBfEy851k+fDVeuWjUkB+oU8BWnG9O1JvykwzioU9u8r7PL16SWe1qgPXsVCt3AhWPqBk/2JdH3IhTYfOMchkVC0NwMuUN7VeCFT4+PeqkMm+Y5XJOiy/bgXzF5+NQt6OF580E00YtK3yY9V6sdSsObCxr5KDE/Lt+zgV1ln54YJZsyg8aUAvJiIpbxUTdEPAkgfVORmheUt5mflq/Ky1JD7L2Ez4CfZtoue49Xa5IVsBDibnoKwCFhX5NbHENiXbbo14bCVLV5j3wmkC6EwA/h91BJvC12MIEu6W3Kzus9UdZcVjUZjpEI7yQnMBpahjb89dkhD0xCc0/RxXm35ctuiFnBEw5P99pZ5NYuV2OAtgbfw2v5vzU2tSVB+c1FHMuzd8wyQ6j9sl8EQhG7L5oYkTirfvNrZX9FgdY9Qc2QG/LJbnXmkU8Iwys2RyxBD1pTlWfdjcB98hDhQKBzkxgYMEU1bPHD4V0eWAzVMDM3gY0ExyGbr+icv+4AZ
 MiF2nvsN
 b+D52XcnAI4maPB2R2teql9ET3qFu6rI0vrXMDgkvpnbvcVZSGcDq9FEBzWmWgxLk33Gn1LvsER6eRzBwg2CTXi1Md9gjT1b+HTRUZd7AYRiZIyQO58CArAaDNWs7fyzSQ2ttSiFhraZc6LpaC9yz87XxlDE/62cJb0Wfni7in9zaSzvJ9rhDgH8sH+9l4NQqlp9UUh6CFDrTy9e09LOiq4+XNI0PzzoIGQ18MVzmWtjpRu5E8DAFc2p0hOIrK7chgBhrnVLaVkqAeKSdEmDlcqP1wR0/z76HaIQnGmN38dO9st6Q+wVrS+IMbtw+9wn9OXU0VOH82NOyoohrPtH1cYe4f4PbY7TRX6u7n5KU45wXTP6utbcNLaYcSdms3NyuGHUdHETfu8FpktJUi+XTmecpGeeizIGbOAstFCovVzbyPnfTnV0Klwdp04YEGB/RmuzzZ+KfDInaBp6ZxAZdv3FRQQZsoaMSqI6I608+awn5Pt25SJIVWr86ZHmsb+g5a4PMwns/32l2eEaz8TPh9bPQXDaaHQZsIrOjd+F1l+la30dBwHt+19rlOmNlIk54Pt1JUSeVnqNYnwcD4McNjrBcrA==
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
- [High] mm: race with folio split in filemap_read_rcu_can_copy() and copy
- [High] mm: lockless folio_next_index() in filemap_read_rcu_size() races w=
ith split
--

commit 8d224bff99d361b93bdbc49e7fbdbc8d57975349
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/filemap: read large folios without folio references

This commit extends lockless RCU page cache reads to support large folios
without taking a folio reference. It checks whether the last page to be
copied still belongs to the same folio in the XArray and copies the pages
one by one with _copy_to_iter().

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 55fc471c04892..ace6b1fd6b9ec 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2843,9 +2843,6 @@ static bool filemap_read_rcu_can_copy(struct folio =
*folio, pgoff_t index,
>  	/* memory_failure() waits only for readers that got past this */
>  	if (folio_contain_hwpoisoned_page(folio))
>  		return false;
> -	/* One reference covers all of a large folio's pages */
> -	if (folio_test_large(folio))
> -		return false;

[Severity: High]
Can removing the folio_test_large() bailout here race with a concurrent
folio split to order 0 in both folio_contain_hwpoisoned_page() and the
subsequent copy?

In filemap_read_rcu_can_copy(), folio_contain_hwpoisoned_page() checks
folio_test_large() and then calls folio_test_has_hwpoisoned():

include/linux/page-flags.h:folio_contain_hwpoisoned_page()
	return folio_test_hwpoison(folio) ||
	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));

Because has_hwpoisoned is a FOLIO_SECOND_PAGE flag,
folio_test_has_hwpoisoned() calls const_folio_flags(folio, 1):

include/linux/page-flags.h:const_folio_flags()
	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
	return &page[n].flags.f;

If __split_folio_to_order() splits the folio to order 0 and executes
ClearPageCompound(&folio->page) between folio_test_large() and
const_folio_flags(folio, 1), won't that trigger the VM_BUG_ON_PGFLAGS()
assertion?

Even with CONFIG_DEBUG_VM_PGFLAGS disabled, __split_folio_to_order()
initializes page[1].flags.f for the new order-0 folio (including copying
PG_active) before clearing PG_head on page[0]. Since PG_has_hwpoisoned
aliases PG_active, reading page[1].flags.f on an active folio being split
to order 0 will see PG_active and misinterpret it as PG_has_hwpoisoned.

Additionally, if a tail subpage is poisoned by memory_failure(),
PG_hwpoison is set on that tail struct page, and splitting the folio in
__folio_freeze_and_split_unmapped() -> __split_unmapped_folio() ->
__split_folio_to_order() calls xas_split() (leaving old_folio in all the
split XArray slots while its refcount is frozen at 0) and then executes:

mm/huge_memory.c:__split_folio_to_order()
	folio_clear_has_hwpoisoned(folio);
	...
	ClearPageCompound(&folio->page);

before __folio_freeze_and_split_unmapped() replaces old_folio in slots 1 ..
nr_pages - 1 with __xa_store(). During that window, a lockless reader in
filemap_read_rcu_batch() does not check refcount and can look up old_folio
at a tail index (or across a range in filemap_read_rcu_size()), observe
folio_contain_hwpoisoned_page(old_folio) =3D=3D false because both
PG_has_hwpoisoned and PG_head have been cleared on old_folio while
PG_hwpoison is only on the tail page, and then copy directly from the
hwpoisoned tail page in filemap_read_rcu_copy() without checking
PageHWPoison(page).

> @@ -2899,6 +2896,60 @@ static struct folio *filemap_read_rcu_lookup(struc=
t xa_state *xas,
>  	return folio;
>  }
> =20
> +/*
> + * How much of @bytes, starting @offset into page @index, can be copied =
from
> + * @folio.  A folio is in all the slots of its range or in none: when th=
e slot
> + * of the last page holds it too, so do the slots in between, and the pa=
ges
> + * are this folio's.
> + */
> +static size_t filemap_read_rcu_size(struct xa_state *xas, struct folio *=
folio,
> +		pgoff_t index, size_t offset, size_t bytes)
> +{
> +	pgoff_t end =3D index + DIV_ROUND_UP(offset + bytes, PAGE_SIZE);
> +	pgoff_t next;
> +
> +	if (end - index > 1 && folio_test_large(folio)) {
> +		/* Read without a reference: it only picks the page to check */
> +		next =3D folio_next_index(folio);

[Severity: High]
What happens if the folio is concurrently split to order 0 while
folio_next_index() reads its size here without a reference?

folio_next_index() calls folio_nr_pages() -> folio_large_nr_pages(), which
reads from the first tail page (folio->__page_1):

include/linux/mm.h:folio_large_nr_pages()
#ifdef NR_PAGES_IN_LARGE_FOLIO
static inline unsigned long folio_large_nr_pages(const struct folio *folio)
{
	return folio->_nr_pages;
}
#else
static inline unsigned long folio_large_nr_pages(const struct folio *folio)
{
	return 1L << folio_large_order(folio);
}
#endif

where folio_large_order() reads folio->_flags_1 & 0xff.

In __split_folio_to_order(), when splitting to order 0, the loop at i =3D 1
initializes new_folio =3D (struct folio *)(&folio->page + 1) and writes
order-0 page flags into new_folio->flags.f (aliasing folio->_flags_1) and
copies folio->memcg_data into new_folio->memcg_data (aliasing
folio->_nr_pages) before ClearPageCompound(&folio->page) clears PG_head.

When NR_PAGES_IN_LARGE_FOLIO is not enabled, folio->_flags_1 & 0xff can
contain order-0 page flags such as PG_waiters (bit 7 =3D 128) or PG_head
(bit 6 =3D 64), causing 1L << folio_large_order(folio) to perform a signed
64-bit shift out of bounds. When NR_PAGES_IN_LARGE_FOLIO is enabled, reading
folio->_nr_pages races with new_folio->memcg_data being written.

[ ... ]

> +}
> +
> +/*
> + * Copy @bytes from @folio, starting @offset into its page at @index.  P=
age
> + * by page, as copy_page_to_iter() does, without its checks for each cal=
l.
> + * Not copy_to_iter(): its usercopy check reads the folio's order, which=
 a
> + * split can change.
> + */
> +static size_t filemap_read_rcu_copy(struct folio *folio, pgoff_t index,
> +		size_t offset, size_t bytes, struct iov_iter *iter)
> +{
> +	struct page *page =3D folio_page(folio, index - folio->index);
> +	size_t n =3D 0;

[ ... ]

> +}
> +
>  /* Bytes one RCU read section copies at most: it holds up grace periods =
*/
>  #define FILEMAP_RCU_READ_MAX	SZ_512K
> =20
> @@ -2944,10 +2995,9 @@ static bool filemap_read_rcu_batch(struct kiocb *i=
ocb, struct iov_iter *iter,
>  			break;
> =20
>  		bytes =3D min_t(loff_t, isize - pos, iov_iter_count(iter));
> -		bytes =3D min3(bytes, budget, PAGE_SIZE - offset);
> -		/* Not _nofault(): its usercopy check reads the folio's order */
> -		n =3D copy_page_to_iter(folio_page(folio, index - folio->index),
> -				      offset, bytes, iter);
> +		bytes =3D filemap_read_rcu_size(&xas, folio, index, offset,
> +					      min(bytes, budget));
> +		n =3D filemap_read_rcu_copy(folio, index, offset, bytes, iter);
>  		*copied +=3D n;
>  		iocb->ki_pos +=3D n;
>  		budget -=3D n;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019154913.1765=
974-1-kas@kernel.org?part=3D15

