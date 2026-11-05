Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A077606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5CP6fgb
Received: by kanga.kvack.org (Postfix)
	id 5CAB46B05BD; Thu,  5 Nov 2026 08:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A18C6B05BE; Thu,  5 Nov 2026 08:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF766B05BF; Thu,  5 Nov 2026 08:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 232396B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:03:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA59DA879C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:51 +0000 (UTC)
X-FDA: 85401082662.27.AFD3280
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id F0A5A180019
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A5CP6fgb;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883830;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nXomHp8g6NOTHg/QgSNHjkuqe1l9o8KbOReVmA2Zcw=;
	b=z4zFeIcY/H8uiICVOIP+3YGPjsujzEFA+qA6N/4BgEWbgbFTExP++1sxU4JrHsZ4peadWV
	wCJp5wqE75dP7mJfnnZzpaI4O8nRJXRrPyvH4C+UpKzURnwctZuscoRV4k/ld8nj7n2ZfF
	BfhcwDpZGjtVJPQnP8nvUVirs7CatC4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883830;
	b=L5Mq0DA5HTLv8gUx2mwENrYa/CAjqykUgKxMnPOQU8/k0Ox2z2H7bqoCOt+HGUAaaUkCya
	8ZGVAsBdgkYOxQxdQsXcIC+3UysvzZmDjZd6iLWyE96F8QNXFaJ48gDSdAtPeEYdpB07Hl
	7R92JKyD3O7r3DJ4hPgMv0XSAcUzFUY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A5CP6fgb;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CBAE4397B;
	Thu,  5 Nov 2026 13:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5851F00A02;
	Thu,  5 Nov 2026 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883829;
	bh=1nXomHp8g6NOTHg/QgSNHjkuqe1l9o8KbOReVmA2Zcw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A5CP6fgbzYak42H/XofVh2YaU13ZqCrDhVWyCj0P/O1WBbSS95XHrhPBGlYyl9NSy
	 vq3LHyydH2vEUMz2WD6nH5QqVGb1qxU/gTCA7w9ODlqiu6BXHDaGos7vYCRRCi2Vho
	 lk8FIjYoMO1hUZwp8jgrj0tACa8/fTR5qaXvuWOo48YPo6Xuc/XpP0O/ecO9mLnL+L
	 Vn0aHmFyp6SFAkzEkYteMsK28O4zWpMu3lUazUs0vvVo3NUuMs518k7KbyO20isXgJ
	 F7meVJCb2N5cIrI2bqzKT7DDjtFPNSPdiZBishyly4vOX6FaiReVxMShyDnT3f3JGC
	 sqXuSarbOhLww==
Message-ID: <sashiko-outbox-199110@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 17/18] mm/shmem: read without folio references
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Harry Yoo" <harry@kernel.org>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E. McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Luis
 Chamberlain" <mcgrof@kernel.org>, "Ilya Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk
 Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261104130118.2507513-18-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-18-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:03:46 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fcjdbgxwgdr7wiugycc3qqk77coutwko
X-Rspamd-Queue-Id: F0A5A180019
X-Rspam-User: 
X-HE-Tag: 1793883829-88860
X-HE-Meta: U2FsdGVkX1+3GFd57vLho2a96SqIANiLHHHrOnGIM0lVnTXMreHbQvebgWRZInSJEMyBtUPsjF9TLUnmXGHkAIPzvcVvQfVtiH0zMXQ/Fh64A+xP3bKxqMOxaO/GvFxoAAZsHQ5scr9QIrvmL8Da0fEw+4ea5BNHRaQ+kJVaElS3PViQM6hiXKJCRLlqfjSS1qV0lCanGoiJlHM3vhA+5tvMVqWjKOwyHWxTfRo/F/goffpcjnYoKB9WpSBbjYedb7JUPc0U+ZZ30LAlO+lW6ZtujvNW7srOjDTnXAcfp9AYA8NZmxd1NONnsVO1byweuNxB0kq+haT+fzOgfJohon8FVKbAWGjb4q3TcrXNs1cr2LjS9fHnHAnshmFyvantPSdT3ABMLUJY0M+t8iaEXUg096q/GZrgqXeXrzukpo2Wyl6n/1iaXUxyVwIDTHNwSH685TvAkmodIobF/CAGAW8cvLNT1dt2i1Bb6rGEI6HNZyrmHZoNmWmZ3vFafBHluSmagIq/NIZfO1aRGvB6YM+aEbhBbB7oCEk7x7jEq58uaka5YcPsL3befT52/t1ySsTAFXWAau/tWB2KMF85fmle5nBJeFNVoavTndOBhs5d3kbyy+FD3ofWc8YKMCWxMnEh21D7UbLvezYEC8bs4VXp00apNw8wLzKZWy5wD3ovaB3MFDLR8Ipn8cjAKnwGr4YDX4pV2qc6Sj9vtg1d8MQPYEICOpbVgoJ7PNI+wInttu+GD2xkgJXm533lRwf2fTWmKZdMlm8Taq/JBPhbljdXNLMG6CS3KRaVff30YtNq4jKPGxuDCohDCYU3rja4amssuuHbB7GDO6XESu+nV7CvwHFHZQ3oQn3oP8XNJLLbFoyJlI+7EDdOC7gjZJ5SZF3gMMeMkNSlFM5KLUVwglcjh4zpC1t8iZk/JXXCFQc4a3R5MZ7ee1b/SNVweCVqInMrUCfVmg61gs/WDAL
 ywe4tcCr
 gTrVdhpA8fbeIFoogUPuUAZUYOu4cGRWpHZ0IxJCno2gMqq9ikiW/S7+O7doomlORvfELhaVQITYMya8egyUG7NkJs7puFCtog7Ac6rAOU2JCfgS56iXcugtHv00shG9h2jE/uVfBHamRJeEfWOi4i2TbC/famP521+axS8I9yTMGkTyaRZSBBjZQXvup7HiDiMq+ERtARE78bOHv08M5bf1p+5MdVyjD7hz7tkaFEeBob8xx4y7dNQc4rxDE9APQb+vsHoCv3hEFaSsH5G4cb7rNP8MFgxZ24N6hA1oDciekqIB4Axi3Jm1Wy35YiN68Bi2KvgF6pkR/NRCnElhg9LRlgziCc1N0SolcNZqT6PPHzEz+BjF6/uuUAdG1sJzD7ia94o2k52HzzZ0/1ZW2vyKzgos0WjJc9sJ0NGHXHIC90LqfAfCCtzPZyfX8VZL7irxC+aaNQSYzR2m3X2cCipVfsBJ61gfOffpyr7T+hBgIic6KZovo6rSgXKI1myytJfXomH3A6gA3ro4XU0CVu+/KGBbRA1nxK4kbCmRfxIWe4OMf4EeoSWGJYzy4QeMChGMQCGB+/YSQ2rWjL7/+I4Bwa+kXEmqcbuAyAXaUjeFRHji1DgrIhF6OJGf/ywkygHLGqPaNDaor3CFJ1Y1SirFdHgLl25MQAKIJJprpzGQDTrKLmJXapmqFFwpa/wbz0VIaeNvuAVQX8wU=
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
- [High] mm: race in filemap_read_rcu_can_copy() copies hwpoisoned tail pag=
es on split
--

commit 6b69ad4da5a3278d80ff53e3999062ede8b8a468
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/shmem: read without folio references

This commit updates shmem_file_read_iter() to copy from the page cache
without taking folio references or locks via filemap_read_rcu() before
falling back to the slow path. It also updates filemap_read_rcu_can_copy()
to ignore PG_readahead on swapbacked folios where that bit is PG_reclaim.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 1c700fa9666d0..8700b03a8a5ee 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3313,7 +3313,14 @@ static ssize_t shmem_file_read_iter(struct kiocb *=
iocb, struct iov_iter *to)
>  	pgoff_t index;
>  	unsigned long offset;
>  	int error =3D 0;
> -	ssize_t retval =3D 0;
> +	ssize_t retval;
> +
> +	retval =3D filemap_read_rcu(iocb, to, last_pos);
> +	if (retval) {
> +		last_pos =3D iocb->ki_pos;
> +		if (!iov_iter_count(to))
> +			goto out;
> +	}

[Severity: High]
Can calling filemap_read_rcu() from shmem_file_read_iter() copy from a
hwpoisoned tail page instead of returning -EIO when a large shmem folio is
concurrently split?

Unlike regular filesystems, shmem_error_remove_folio() keeps hwpoisoned
folios in the page cache. When a large folio has a hwpoisoned tail page
(index > folio->index), PG_hwpoison is set on that tail subpage and
PG_has_hwpoisoned is set on the folio. If the folio is later split (for
example via truncate_inode_partial_folio(), shmem_unused_huge_shrink(), or
shmem_writeout(), or during memory_failure()), a concurrent reader in
shmem_file_read_iter() -> filemap_read_rcu() -> filemap_read_rcu_batch() can
bypass the hwpoison checks in three ways:

1. In mm/huge_memory.c:__split_folio_to_order(), PG_has_hwpoisoned is clear=
ed
on the folio at the beginning of the split, before the loop over the subpag=
es,
before ClearPageCompound() clears PG_head, and before
__folio_freeze_and_split_unmapped() updates the XArray slots:

mm/huge_memory.c:__split_folio_to_order() {
	...
	folio_clear_has_hwpoisoned(folio);

	/* Check first new_nr_pages since the loop below skips them */
	if (handle_hwpoison &&
	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
		folio_set_has_hwpoisoned(folio);
	...
	if (new_order)
		folio_set_order(folio, new_order);
	else
		ClearPageCompound(&folio->page);
}

During this window (or after a non-uniform split where new_order > 0 leaves
PG_head set on the first half while the poisoned subpage is in the second
half, before the XArray slots are updated), xas_load() still returns the
original folio with PG_head set and PG_has_hwpoisoned clear. In
filemap_read_rcu_can_copy(), folio_test_hwpoison(folio) only checks the head
page, so it returns true for the poisoned tail page, and
filemap_read_rcu_size() also sees xas_load(xas) =3D=3D folio at end - 1, al=
lowing
filemap_read_rcu_copy() to copy across the poisoned subpage.

2. In mm/filemap.c:filemap_read_rcu_can_copy(), folio_test_large(folio) is
tested twice without synchronization:

mm/filemap.c:filemap_read_rcu_can_copy() {
	...
	/* A split clears PG_head before it puts the new folios in their slots */
	if (!folio_test_large(folio) && folio->index !=3D index)
		return false;
	/* memory_failure() waits only for readers that got past this */
	if (folio_test_hwpoison(folio))
		return false;
	/* Not folio_test_has_hwpoisoned(): it asserts PG_head, a split clears it =
*/
	if (folio_test_large(folio) &&
	    test_bit(PG_has_hwpoisoned, &folio->_flags_1))
		return false;
	...
}

If ClearPageCompound(&folio->page) runs between those two checks, the first
folio_test_large(folio) sees true (allowing folio->index !=3D index) and the
second sees false (skipping the PG_has_hwpoisoned check).

3. Neither filemap_read_rcu_can_copy() nor filemap_read_rcu_copy() checks
PageHWPoison(page) on the individual subpages being copied:

mm/filemap.c:filemap_read_rcu_copy() {
	struct page *page =3D folio_page(folio, index - folio->index);
	size_t n =3D 0;

	while (n < bytes) {
		size_t len =3D min(bytes - n, PAGE_SIZE - offset);
		size_t done;
		void *kaddr;

		kaddr =3D kmap_local_page(page);
		done =3D _copy_to_iter(kaddr + offset, len, iter);
		...
}

Could this copy corrupted data to userspace or trigger an unhandled kernel
machine check or page fault if the poisoned page was unmapped from the dire=
ct
map?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104130118.2507=
513-1-kas@kernel.org?part=3D17

