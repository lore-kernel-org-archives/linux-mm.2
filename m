Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D883606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/+49HQh
Received: by kanga.kvack.org (Postfix)
	id AD49E6B05BC; Thu,  5 Nov 2026 08:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAABE6B05BD; Thu,  5 Nov 2026 08:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973556B05BE; Thu,  5 Nov 2026 08:03:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7896B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:03:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03C9040A11
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:48 +0000 (UTC)
X-FDA: 85401082578.25.331C510
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A7942000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/+49HQh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883827;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eb9d0UAv6LQkzqh7ct3Vy8tC6z7pXzvmsDcpnqz8G48=;
	b=ZvSVttYgKwt2CNzmeGdUprp2dXLZxnMMo0UllQduM/M9jqwt0Qb7UpghKgl0MV+ZQ6xW/Q
	Sc55Ygrrya5ACeAqc/BnmpinnKwaTB+uIBjwZyuQlPDNUyEs8edcmUV1wnZwtSKHNswdwJ
	dM+4r3SpQQlXbvfVJyX3UAvoGMseFAs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/+49HQh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883827;
	b=k3egn8BGtETv/CGsDHxz11cdBv0xKqkwTu4BYkv2mKWTRqCrGZ99B574h/tYIa4Ag0yEWH
	ZugoH9eAu8X45caTuzGAJg6+sT+xf6IgX5PWG1xQ0gLsSdGun7tizQRMLY+lfJAauY9LiW
	A0lrCl9ib/L0TQQGnS5x4XXt7NHRGCk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F29FF602C3;
	Thu,  5 Nov 2026 13:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8EE1F00A16;
	Thu,  5 Nov 2026 13:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883826;
	bh=Eb9d0UAv6LQkzqh7ct3Vy8tC6z7pXzvmsDcpnqz8G48=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i/+49HQhYEkZrLNYYHvOpHHFczTYGHz7lxT794rkkFerqQOwAtJfYn8NH3oStqFJx
	 FqV5ABZ5tch1GHTY3QZNAqU3PfJvzYXzqz8zzzoUc6Z4RQ68iBYBwEUIE2pGTG3P2x
	 SZ1j9OBL2TvlTsMnvvlhfvUV2de3Ii/tIIQGIc0JdQXKxAHK2Fd4TcP46momNeax7f
	 wisTsQOuFpOXsNky9QceJCGrmBgwoHA7j4aKYqbFjj9gVUtDbJOXUJJ/DWZ/BIWek+
	 ogG3HQa/wOsC1MicjvCb3E2L3oJQgxQtBayNP4/Qe+aIuXQqyrWGRNQbC4NmroND72
	 KF/SwHJ5OLuUQ==
Message-ID: <sashiko-outbox-199107@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 14/18] mm/filemap: read large folios without
 folio references
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
In-Reply-To: <20261104130118.2507513-15-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-15-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:03:44 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A7942000A
X-Stat-Signature: qh3pxxt1fjzi8cbtuxwthhktoprh89e4
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793883827-275269
X-HE-Meta: U2FsdGVkX1+Yc5nNKyZvHXbqBKXXbyfkjqXM8MytELT/gwGQbqoe668o/dMXnxce72vQqCdR/nOpwr0RzVVWYZblO8aH8XUVD/HBbR1q/zNzAOP2oWD+4nAxqqqSrN6QKgfpE1oWn2i+y9tmCNI8v1S4M+EskC5u3yIubqBT+YJh13DGns/mw5M2wD7mYHXGBP3s9TDbjeXeg6ZdgbY+yE1jGmtfB/lZFxzjrZY5uOp9PdFh92hle82MfACLtEZH1qFa1n0+/lQgcvbxqM7DewZoc8pDxNTThcKqPol1OiFrFxPQXshKaYhB0XrKoOFvJ0J3qJImHUQ5WszmIaIFfrMH27XtkA5G7UY3i1uQDK478aO7RCmV4h7rAnka8gGuTXx48Hrd91ik4UuywLDBs56IdMFMDpgLJpOQFY587h0yRxeoB8zxd55mlIQs3TPGz4J9fYVCfQx0Nu+2nyUxS1bnYqBpaljkrqnSyYshVnbL1CSxfKzhk769bmJS4pX5ee7CEhKHpK5lviKQMbXZUuufJHJCWEYP3N8wxi/cz3ghN2Ym1AsnkMezrtpd/WWW1FS+z2bKTm+3hUdAO7kxes1DuypB8m8pB5/LYW2VzbukLzLo6lD4nARlKSDxztUzPNVoeC9iHqOnnGTV3QunZXziZCbhK21FD9R5XqYgsaqdMlCJ1b08V7jPoKNy6+N9+hPIPwgXAHqL0Ry4MJO5HWjw2/5DmgyWZC06OmUE/Q0q7fBRSrV3A0DRWaJfU247MTyz658wQ7KdXEt1/s6j3/E2GCDgDrYlaGTdFelgBQ/8bUC98X9A+3kDOIQzhXDFP8hYg1XmKQE7UIIFYvhGlD4tY2fQbjo5G0lq6/b4Eni7AVL9atwJufMzLBummzjCQIznyaCdYkPMrgd3f2ZK8PGdsCzL5SHz+tXYUisWD/T+dUlvmKer1s7ZFLaPEB6y0Z3vYACSvIkzgtu9tzB
 RUOtLkr2
 OEpGDlkEq9JZRlgp1zDwVTVggtyLVVbXKPce33xxCGzDdFK0yhb0C68XzB0d8Yo1LrveoGT+YRCroTzhGI+s6p7NPh0ZJYtCkBJrmWBg4+Bdv4wYhCjOhrFfR+GNy+ds482eknLybxZsQDs2IgbF5Ax68bInjzmFSXQ5mWB4dGpLODgFauqg+fiHArXHhOmFtQd6HnJ8zAj04KzyVGhysKfbdA3xxnl1aiNUHiKKbNcCJsoYw18fk4r9p4/XE9Z3E1CRlSVdymFiM4Q4IkklRZeBc7ZZnbxp2m1ujYokWePL4HdN5Ax3GJdkGi1RBuJQfWi7keF6QEjpR0WprmOERCTMzHT8KeEWOBCcUk8jAZ1cErVlSHLWlHAIvbThGdBkRGgIi6m9rn5EFvgBBGZz3sJcM5Cg0Itgv26Pbp+/envB4hs2XzZBcYSo8uqZk+8V0oaAds5sMIflXf/js3+REkOELt0mabpevCuBZmQrwxGYgXeOD4eZiTIotafTnjm8q6fTApRJKVRzdyQSaM+tmiByfKR+DcPEzqpxex21ujsN/1qDTgoAi+V9IrQQeSNhMGiOmExTpATbfVk7iIZC/SgxIgJZ2b9D1c2o3vG9Ah93Z3U27q67SFEkMWuhvP5dTFqAhywKRqi5nchm0i/WbYEAAlK6e6JdYY4USCAhH9qdfN5vb297NP8wGd1EARyFW6ZEiBbhjH3vNN3o=
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
- [High] mm/filemap: lockless large folio read can bypass hwpoison check an=
d copy poisoned subpage
--

commit 3f27d3e89354814e80ba93e8767ff8878253a593
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/filemap: read large folios without folio references

This patch extends lockless RCU pagecache reads to support large folios
without taking folio references. It checks whether the last page of the
read range still points to the same folio in the XArray and copies data
page by page via _copy_to_iter().

> diff --git a/mm/filemap.c b/mm/filemap.c
> index e99705a66c1d4..182ae7d5db56a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2834,15 +2834,16 @@ static bool filemap_read_rcu_can_copy(struct foli=
o *folio, pgoff_t index,
>  		return false;
>  	if (folio_test_readahead(folio) || folio_test_dropbehind(folio))
>  		return false;
> -	/* One reference covers all of a large folio's pages */
> -	if (folio_test_large(folio))
> -		return false;
>  	/* A split clears PG_head before it puts the new folios in their slots =
*/
> -	if (folio->index !=3D index)
> +	if (!folio_test_large(folio) && folio->index !=3D index)
>  		return false;
>  	/* memory_failure() waits only for readers that got past this */
>  	if (folio_test_hwpoison(folio))
>  		return false;
> +	/* Not folio_test_has_hwpoisoned(): it asserts PG_head, a split clears =
it */
> +	if (folio_test_large(folio) &&
> +	    test_bit(PG_has_hwpoisoned, &folio->_flags_1))
> +		return false;
> =20
>  	/*
>  	 * The slow path does not call folio_mark_accessed() on the folio that
> @@ -2896,6 +2897,62 @@ static struct folio *filemap_read_rcu_lookup(struc=
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
> +	unsigned int order;
> +	pgoff_t next;
> +
> +	if (end - index > 1 && folio_test_large(folio)) {
> +		/* A split can change it under us: it only picks the page to check */
> +		order =3D min(folio_large_order(folio), MAX_PAGECACHE_ORDER);
> +		next =3D folio->index + (1UL << order);
> +		if (next > index && next < end)
> +			end =3D next;
> +		xas_set(xas, end - 1);
> +		/* A split after this copies PG_rcu_free to the new folios */
> +		if (xas_load(xas) =3D=3D folio)
> +			return min(bytes, (end - index) * PAGE_SIZE - offset);
> +	}
> +	return min(bytes, PAGE_SIZE - offset);
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
> +
> +	while (n < bytes) {
> +		size_t len =3D min(bytes - n, PAGE_SIZE - offset);
> +		size_t done;
> +		void *kaddr;
> +
> +		kaddr =3D kmap_local_page(page);
> +		done =3D _copy_to_iter(kaddr + offset, len, iter);

[Severity: High]
As reported by Sashiko on RFC [1], can a lockless reader in
filemap_read_rcu_batch() bypass the hwpoison checks in
filemap_read_rcu_can_copy() and copy from a hardware-poisoned tail subpage =
in
filemap_read_rcu_copy()?

When a hardware memory error hits a tail page p of a large folio,
memory_failure() sets PG_hwpoison on the tail struct page p rather than on
&folio->page, so folio_test_hwpoison(folio) in filemap_read_rcu_can_copy()
only checks subpage 0. Meanwhile, filemap_read_rcu_copy() copies each subpa=
ge
via _copy_to_iter() without checking PageHWPoison(page), relying on
filemap_read_rcu_can_copy() to reject the folio beforehand.

However, there appear to be three ways a poisoned tail subpage can get past
filemap_read_rcu_can_copy():

1. During a split, __split_folio_to_order() in mm/huge_memory.c clears
PG_has_hwpoisoned on the original folio at the start of the split, before t=
he
new sub-folios are initialized, before ClearPageCompound() clears PG_head,
and before __folio_freeze_and_split_unmapped() updates the XArray slots in
mapping->i_pages:

mm/huge_memory.c:__split_folio_to_order() {
	...
	folio_clear_has_hwpoisoned(folio);

	/* Check first new_nr_pages since the loop below skips them */
	if (handle_hwpoison &&
	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
		folio_set_has_hwpoisoned(folio);
	...
}

While the XArray slots still point to folio, folio_test_large(folio) remains
true (including across splits to new_order > 0 when the poisoned subpage is
at index >=3D folio->index + (1UL << new_order)) while PG_has_hwpoisoned is=
 0.
A reader looking up the poisoned tail index or sizing a multi-page read
across the folio in filemap_read_rcu_size() will see the folio still in its
slots with PG_has_hwpoisoned cleared and proceed to copy the poisoned subpa=
ge.

2. filemap_read_rcu_can_copy() evaluates folio_test_large(folio) twice
without caching the result:

	if (!folio_test_large(folio) && folio->index !=3D index)
		return false;
	if (folio_test_hwpoison(folio))
		return false;
	if (folio_test_large(folio) &&
	    test_bit(PG_has_hwpoisoned, &folio->_flags_1))
		return false;

If a concurrent split to order 0 clears PG_has_hwpoisoned and PG_head betwe=
en
the two folio_test_large(folio) calls while reading at index !=3D folio->in=
dex,
the first check sees folio_test_large(folio) as true (skipping the
folio->index !=3D index check) and the second check sees it as false (skipp=
ing
the PG_has_hwpoisoned check). filemap_read_rcu_size() then returns a single
page and filemap_read_rcu_copy() copies from folio_page(folio, index -
folio->index).

3. In mm/memory-failure.c, memory_failure() sets PG_hwpoison on the tail pa=
ge
p via TestSetPageHWPoison(p) before calling get_hwpoison_page() and before
setting PG_has_hwpoisoned on the folio. If get_hwpoison_page() fails (for
example, while the folio refcount is transiently frozen), PG_hwpoison remai=
ns
set on tail page p while PG_has_hwpoisoned is never set on the folio. If a
subsequent memory_failure() call hits TestSetPageHWPoison(p), it calls
synchronize_rcu() and returns 0 so the caller can unmap p from the kernel
direct map, after which a lockless reader copying from p in
filemap_read_rcu_copy() can trigger an unhandled kernel page fault.

Would checking PageHWPoison(page) on each subpage in filemap_read_rcu_copy()
(or before copying) avoid reading from a poisoned tail page across these
races?

[1] https://lore.kernel.org/r/20261019154913.1765974-16-kas@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104130118.2507=
513-1-kas@kernel.org?part=3D14

