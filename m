Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F9E606A324
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97B36B050A; Tue, 20 Oct 2026 11:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48876B050C; Tue, 20 Oct 2026 11:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E8F6B050D; Tue, 20 Oct 2026 11:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76B676B050A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:53:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03ECE120217
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:53:45 +0000 (UTC)
X-FDA: 85343450052.26.FE43EE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6FE11C0009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:53:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792511624;
	b=jrJmgMq5psiR7ZIpO2QWf1/1V6gP1WA1T7KaggwlR+T7lg+9orGTTMpR6tPjl4SildpHT+
	vH25Sxw1ul0+yyiyxt8nH/z1suGe7dQfmc+wjxZek01M74NjQmkag9SWKYztJcPsjtqAbZ
	mPNSMD0+bhyE04rG7xvg0Rl8aQJpTDQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792511624;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GDwJ5+XeS0IKI3sLxDfB+LzB1CQq7WwtJYlCpOTkE+g=;
	b=2+51hpMKXD7PlFc1DZz13pF+4+NNBFVnBw906ntVwiPPsDTgfNVbbN/WIQgfoBNrGmZeL5
	hdza9/mJN6c/B2k1FhHMWAuHrtaKVMMAjkgSwGbY+lxT7ucAkDwTRfs+WRuxCsVdhP4ccp
	P1E7Sg7hrA5X0UGyDR0OmgDTP4Dz0lU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06E94605ED;
	Tue, 20 Oct 2026 15:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661E11F000C8;
	Tue, 20 Oct 2026 15:53:41 +0000 (UTC)
Message-ID: <sashiko-outbox-179310@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 12/18] mm/filemap: don't defer the free of folios of
 an inode being evicted
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
In-Reply-To: <20261019154913.1765974-13-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
 <20261019154913.1765974-13-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 15:53:11 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FE11C0009
X-Stat-Signature: m1fff5pibfni17uzdamrxrhcm1pjyj7r
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792511624-292263
X-HE-Meta: U2FsdGVkX1+lLFJC4eYsgV4kbYOYjWNwX3nSnHa6mlsG6DJJQkLyARjYkRGQInpNCr7rG+Y/sK/4MX0GurD/Dp7BAlscHrjGy0SAhLr9KypaaVDcwj3diMVgJBQOuyBecTXz5lqHbT6TAcIn8tX6p2b6+bbbVxuYZXh0xlGkqX8hU7JOrZQprISctt7dJ/cvIwpemMmgV8ogcp8F6GRgB3fp/9A6tvZfO+zSSDlA508gjihGC0xt1Er/AmD28DimWwPJ56ZpeYyUKBjQ8CYNgadcD+If26ozmf4w4E6atrGVeB5MkHnLKfVH9LRppPOv5mNPft//plnaTBxj+NQvvY0RbouZ0FINRgb+Dzm8H3OzJ5wsTDJtBR9oSA1Hovn46abkysoaYTdbx2kfUUNf/ce4GiutZGDXQ5AlIJ+E/yjzZTdaZamxlg3QvhJICznCpk4i4puVRUPsKnblN7v8I7TR8OmMWvLI8K/nWjWetj3c2H7/ouP4lEx5RYsBmEj3IeJQsvGHP5yFhnh4rjZJr7BzlVNSmJngIkY8XPUdtY/Elx7c+tADgG1cViWxrjWw6WkIuaSznha7gosjhLHG4V081pqEdQo03UmUwfYlZdrBgf/ImA+22tERuUX4ROyOTDZB4/WqX63JDJd0jkozMfuxPcJ0CEKyUqxtlfQuKAsHIj8/Y9WV/FhWBOTQSkhRfPL8R0wUyKKUXrFodarwqcslPFP4GRy/wOQPRFO1QaYNo0Qzesc8/Yjg1zWN8LA1LXlF07GvlCHvjom3aiDmag2qwEh7BVeAYobyUBxPptjrQEkx2ArleRMAFIe886DT+Gy2Y34Ev5wvV+4RNu4Q7wltdgOnyg1Q31E44iAgMPNUMalwTmxtO3EWGflA6/t1cHDrjmm4Or5ue5MWk4cikLo/F6USB0QBe/ZsHaJCeTpzp+4PGpp4AnxcHiOkTrG34bDJlx52PHRQp4FsMuL
 4TtpySZY
 GyiN2Vh7gDBBUhAs+bAogFph7uzGy57OcWpj3OT6QyIMcp7mXxiANAowYsWflF9k1sjN60GtkT7kbrhOojM+ex75lGFCED7HqAJlowXlumBinKidHs9Fd8UTBVe2QbcfMpSmMftWPm/AWqc03fEBuaUDcz7B3z81jGJS1ULFALz9rr7ajfijnI9NZhJt7Xt26PnVCxznV5eccQAuYHSQFMBtWVuUmAkB50zJ41Hdofu58OeIEYcwZYryu08XD3kyUci6eli2Y0UcA3IalSqnxMnKj7tRT5ifxTzF9MKWRxsOz2c3zNs26nt+E1LoHwd+67hCdJHmbgNazVam4m2lLH/M+4GhF2oJvJde8EDoJMYnZtRU+7BMd/cFcknEfw4qxAUr8OgtndAEBALN1WzRd44YB018GoJbjPP/my4DzgoGwnKcfHMyLD8JZztezm3mPGN2kbw7bqBxUZ/L3odCrTEPCNEkftWFzTulJEXyGuaWw3xPZlIZbzLkjw4azvJWnC0uappxPoW+VbCmWxBI3Gi7PCujdYWPZlYiTxkIAXyo/v7YdWElUWyTcmnzo7FwPLi3z28OZTQhc1dfWXR/ImRxQSA==
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
- [Critical] mm/filemap: premature PG_rcu_free clear on live inodes with AS=
_EXITING
--

commit 47ca48a16967ca2b270af7537211abb87d17221b
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/filemap: don't defer the free of folios of an inode being evicted

This commit clears PG_rcu_free on folios in page_cache_delete() and
page_cache_delete_batch() when mapping_exiting() is set, avoiding
RCU-deferred freeing during inode eviction.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index b732ecaa78a90..53ec922799771 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -138,6 +138,9 @@ static void page_cache_delete(struct address_space *m=
apping,
>  	nr =3D folio_nr_pages(folio);
> =20
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> +	/* No lockless reader can be in an evicted inode */
> +	if (folio_test_rcu_free(folio) && mapping_exiting(mapping))
> +		folio_clear_rcu_free(folio);
> =20
>  	xas_store(&xas, shadow);
>  	xas_init_marks(&xas);
> @@ -306,6 +309,9 @@ static void page_cache_delete_batch(struct address_sp=
ace *mapping,
>  		}
> =20
>  		WARN_ON_ONCE(!folio_test_locked(folio));
> +		/* No lockless reader can be in an evicted inode */
> +		if (folio_test_rcu_free(folio) && mapping_exiting(mapping))
> +			folio_clear_rcu_free(folio);

[Severity: Critical]
Can clearing PG_rcu_free when mapping_exiting(mapping) is set cause a
use-after-free if truncate_inode_pages_final() is called on a live, open
file?

In mm/truncate.c, truncate_inode_pages_final() unconditionally sets
AS_EXITING via mapping_set_exiting():

mm/truncate.c:truncate_inode_pages_final() {
	mapping_set_exiting(mapping);

	if (!mapping_empty(mapping)) {
		xa_lock_irq(&mapping->i_pages);
		xa_unlock_irq(&mapping->i_pages);
	}

	truncate_inode_pages(mapping, 0);
	...
}

However, f2fs calls truncate_inode_pages_final() on live, open regular
files during atomic write operations, such as when starting an atomic
replace via ioctl(F2FS_IOC_START_ATOMIC_REPLACE):

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

and when aborting an atomic write:

fs/f2fs/segment.c:f2fs_abort_atomic_write() {
	...
	if (clean)
		truncate_inode_pages_final(inode->i_mapping);
	...
}

Buffered reads in f2fs call f2fs_file_read_iter() -> filemap_read()
without holding inode_lock() or fi->i_gc_rwsem, which marks folios with
PG_rcu_free via filemap_mark_hot() and copies from them locklessly under
rcu_read_lock().

Furthermore, because AS_EXITING is never cleared once set,
mapping_exiting(inode->i_mapping) remains true for the rest of the live
inode's lifetime in cache. During both the atomic-write
truncate_inode_pages_final() calls and any subsequent truncate(), hole
punch, fadvise(POSIX_FADV_DONTNEED) invalidation, or page reclaim on that
open file, page_cache_delete() and page_cache_delete_batch() will clear
PG_rcu_free on hot folios.

When the last reference to those folios is dropped, wouldn't
__free_pages_prepare() skip rcu_free_defer() and return the pages
immediately to the buddy allocator while concurrent lockless readers in
filemap_read() are still copying from them under rcu_read_lock()?

> =20
>  		folio->mapping =3D NULL;
>  		/* Leave folio->index set: truncation lookup relies on it */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019154913.1765=
974-1-kas@kernel.org?part=3D12

