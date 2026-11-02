Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C20606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E4AAeII1
Received: by kanga.kvack.org (Postfix)
	id 40D0E6B05B4; Mon,  2 Nov 2026 14:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE1D6B05B5; Mon,  2 Nov 2026 14:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3E66B05B9; Mon,  2 Nov 2026 14:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08C266B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:41:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88136160270
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:41:16 +0000 (UTC)
X-FDA: 85391197752.12.5B1A26F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D8E3F20003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:41:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4AAeII1;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793648475;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkPWmaCky5W9ZtvBeQ8qvs6llvQ7sqyJvIYBj283GTg=;
	b=5tcRBd3mjshpo13wozl+PpMsLY/mbwD5hUcTKJh6/QJluM+tNbdRe7nkFUO5fknA7CH7dV
	mUXySqh/YJnu5k+qpU/1y3I8SAwevjwlVvjbaqCxLgnDPM3fJwkZcGC0LEoTZzxOMTj35Z
	4tiDzrjVd2OKXrl3tC7lER7N7+f7HGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793648475;
	b=NFy3T6H6+DW9rBV1yFzJZpE35HGsS6sBrui48pGwkTGXDYlsp+DvXW2t8J8+sapE0WfuU/
	j9qQFLuw1Xz46Hweus7OYGVbcR+9peGOMu6FUSazzC7R03kxdfVR9nUr+Lq/izUUX7WHjR
	Cr2/PsoRYI9IKKJ6dwhH+lmm2K5S318=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4AAeII1;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A341143754;
	Mon,  2 Nov 2026 19:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BDB1F00A17;
	Mon,  2 Nov 2026 19:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793648473;
	bh=hkPWmaCky5W9ZtvBeQ8qvs6llvQ7sqyJvIYBj283GTg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E4AAeII1KS1riiB887L0qFvZPCQ8+b2dATicts/b3r3eax4TmYosUy7OVfRCt0osL
	 8iOymyMEPiYkT+CDFGd7pAuhRaa22heDtzJ+ellS/40LuBkBIwJi5oZzSj0rF0oGi1
	 L/X0YF4x540L/3pY6fmIV1X2l5ZHjjWoT5A///eHbHrmAYDDIt4Wf9VYeuUDf4ojD1
	 NnOA1/9ayRzJamq5+qEzq65+co0czMYwZbpIYuxSGJIh4g+KSyQ2aD9GcNFUDcn2KH
	 KgDhK9aEQ4fUthkdLZOFk9l3uPEoQjHi2dio2b5Jb1SzuiSi/vAlFjYRN/kTXtU0oS
	 294Fo0Rdfbhag==
Message-ID: <sashiko-outbox-194015@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: don't offline a hwpoisoned page
 still in the page cache
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>, "David Hildenbrand" <david@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Gregory Price" <gourry@gourry.net>, linux-mm@kvack.org, linux-cxl@vger.kernel.org, tz2294@columbia.edu
In-Reply-To: <20261101-memhp-hwpoison-pagecache-v1-1-ed8785ca44eb@columbia.edu>
References: <20261101-memhp-hwpoison-pagecache-v1-1-ed8785ca44eb@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 19:41:12 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8E3F20003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: d3tjj39sm884gzoa999e6od6kcooexd1
X-Rspam-User: 
X-HE-Tag: 1793648474-568249
X-HE-Meta: U2FsdGVkX18ngPj00btsgHKc1jVJA4JYqmao5xqPz7sewPEc6+RCnkad2P61YIKM/5FonCT+VfLTK67Sa5Px+bP1Inop0YWf960ws/NcE9lTRggh4tmyqqT2o6/6kzZSdzFPbl/K62NB4CUDWb+t7UCTFar8YhTSIXyUVtTWlOqjsbKmuny+TKw5A8JpEzxfXcdyBIeY4wAjrPA8zR21OpNj4q5U7sy/Tnhbd4TnlGSQ+hF2yt5BRBF8X43jYJUvC2LcBi12GuyvzY57V+2CkBKg9fbtlekav06d5IHICVhgKV5PCNeR5ooCUlUp2MtebUlIuvUO0lhb432Y0rpg8LyBWsiNoOi+ywkkk0MzARHRms30LpX/QnN2W2xCcJ9I8w1lSG34HIF/JxZqETRlDCXH9DN1VYLUsU4L0AgO7NzFQfZUOD4zkzER6jwNRRxuSfw7RhBFta6FgZqExXbA6S/Gk1TrMAJpL3AapcHs2+oavrhadEhOmYmHIWH0YD1eaPyIb7VL06gzk6yzTulr8+jx+uP+PITFAxXgbgXdBJwEJLgwsJXOk9CP4mRVT6Adwt+6i8tM/cAKXyBHqGGIKlWBI8IC3aWfxBNAboLrwRab+OpvF9Myt8uUvY2LrR55eUa2FqT9/oXmCS1fQB+fVEeNcOnHDzgd4PGDJPxbBXQI0qqyypy/BXnEDaSsFqVczDdvT1L4TOdgIFXA2fhB8VP6uln3a5fnnzUfxEh6k54ifDRfbhLH2FJpwlUMs8I41MQ1SKB6QJH/9nagOoNNoWQH6siMdcvwi76GfhWbkFOkKfOABA7jmuZHeDgBAsJ4bFlpDd8e9v4CPswgDYMJkpAHdz8ICjBGCMQ9Qux3MRGT82H84Yjk8ig8VRv9XchcYeamZyP+pRGfF4uRgN7Ix0re+0+Z5/gMmwjFG23qjMCmjpmhcW4rI2v/FvwmElmI9WpqWeKuZkGTIP3IOEd
 yITvI/m+
 mqGCOpU72noWA4IQMN4+woc+Lbfnh6FrhnwDPNLpLWCCKJk4DsX5za8721youEpSxHjWreoM4oVerVztdeKTZfTOR6ElpLG8BCz1VQYECARN7c5AuG6zm8gLbYiDsX6NwuSpOhczccPIidZPEbVlZ/UUv6cQuD2vgi3SWjWYy/JJOgSthw+C6rlAtqG6qkuyrSorPQZk7e0MUoUsIhax59/jPM9xe6eKerHUVorlA/DZkXhDon7XC++G8IO1m7iPh80q8n93LFNTncL23H3suIeXyYQ53ru2e2zjVUoEKY7bdh5NQ9HCTPj7QIQxKwLt3UEHmvz/JnAsmNEohbhV6OpUvQKpVmkrHx/JCvSTQXn0UKuRdgSzfI+mEtxxZyJC2VbzPHmi2wZkq2scGYeaAbLqwAVk2WukevHwuW9Y62UeyGQZJZYWwNnQvTa97s94HL88vWNr93UCWjxj16VTiHwvbpb3CHK5NoJnqcwAHjD8jjah+OvfRi4NPANu3EtHakbKu+ub9iVszKLUI13dDTAj7O18UgirZs+efbXuUUnAhvwEgq4jOUuk5aEnj648CcExlFa2QJF4KZXuFaGetjrOecV2coJkOHsskjRtoRaq5wNLRnPRnBcNaq/eyYm0IrWf4N6SnKPKnt+7iBHNTjBPzji9YIrorTxH24RtwpqoXYeNWlUkSisIoYw==
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
- [High] mm/memory_hotplug: do_migrate_range() isolates busy hwpoisoned fol=
ios from LRU
- [High] mm/memory_hotplug: scan_movable_pages() misses poisoned tail pages=
 of folios
--

commit 90624953bdb2c5ae02a7473ca37edfda72128f6d
Author: Mani Tofigh <mt4022@columbia.edu>

mm/memory_hotplug: don't offline a hwpoisoned page still in the page cache

This commit prevents memory offlining from skipping hwpoisoned pages whose
folios still have a page-cache or swap-cache mapping in scan_movable_pages()
and __test_page_isolated_in_pageblock(). This avoids offlining memory while
files or swap caches still reference poisoned pages.

[ ... ]

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index c9cc42e54f05d..3d36f7f2e04b6 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1820,6 +1820,8 @@ static int scan_movable_pages(unsigned long start, =
unsigned long end,
>  		struct folio *folio;
> =20
>  		page =3D pfn_to_page(pfn);
> +		if (PageHWPoison(page) && !hwpoison_page_offlineable(page))
> +			return -EBUSY;
>  		if (PageLRU(page) || page_has_movable_ops(page))
>  			goto found;

[Severity: High]
Does do_migrate_range() still isolate a non-offlineable hwpoisoned folio fr=
om
the LRU and leak its reference when another movable page precedes it in the
range?

In offline_pages(), scan_movable_pages() returns 0 as soon as it finds the
first movable page, and offline_pages() then passes the entire remaining
range [pfn, end_pfn) to do_migrate_range():

mm/memory_hotplug.c:offline_pages() {
    ...
			ret =3D scan_movable_pages(pfn, end_pfn, &pfn);
			if (!ret) {
				/*
				 * TODO: fatal migration failures should bail
				 * out
				 */
				do_migrate_range(pfn, end_pfn);
			}
    ...
}

In addition, because memory_failure() does not hold mem_hotplug_lock,
TestSetPageHWPoison() can run after scan_movable_pages() has already scanned
past that PFN.

When do_migrate_range() reaches the hwpoisoned page-cache or swap-cache fol=
io
while memory_failure() is waiting in get_hwpoison_page() on
pcp_batch_high_lock, it isolates the folio from the LRU without checking
hwpoison_page_offlineable():

mm/memory_hotplug.c:do_migrate_range() {
    ...
		if (folio_contain_hwpoisoned_page(folio)) {
			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
				goto put_folio;
			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
				goto put_folio;
			if (folio_mapped(folio)) {
				folio_lock(folio);
				unmap_poisoned_folio(folio, pfn, false);
				folio_unlock(folio);
			}

			goto put_folio;
		}
    ...
}

On the next pass of the loop in offline_pages(), scan_movable_pages() reach=
es
the poisoned page and returns -EBUSY. However, folio_isolate_lru() has
already cleared PG_lru and taken an extra reference on the folio that
put_folio does not drop.

When the waiting memory_failure() resumes in get_hwpoison_page() ->
get_any_page() -> __get_hwpoison_page(), HWPoisonHandlable() sees
!PageLRU(page) and fails with -EIO instead of truncating the folio, and the
leaked reference from folio_isolate_lru() keeps the poisoned folio pinned in
the page cache so subsequent offline_pages() attempts also fail with -EBUSY.

Should do_migrate_range() also skip isolating the folio when
!hwpoison_page_offlineable() is true?

[Severity: High]
What happens in scan_movable_pages() when a tail page of a large page-cache
or swap-cache folio is hwpoisoned?

PG_hwpoison is set per subpage whereas PG_lru is on the head page. Because
scan_movable_pages() scans sequentially from start, it visits the head page
of a large folio before any tail page. At the head page, PageHWPoison(page)
is false and PageLRU(page) is true, so scan_movable_pages() takes the
goto found branch at the head PFN without scanning the poisoned tail PFN.

In do_migrate_range(), if PG_has_hwpoisoned is already set on the large
folio (for instance, when memory_failure() could not split the large folio):

mm/memory_hotplug.c:do_migrate_range() {
    ...
		if (folio_test_large(folio))
			pfn =3D folio_pfn(folio) + folio_nr_pages(folio) - 1;

		if (folio_contain_hwpoisoned_page(folio)) {
			/*
			 * unmap_poisoned_folio() cannot handle large folios
			 * in all cases yet.
			 */
			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
				goto put_folio;
    ...
}

do_migrate_range() skips the large folio without clearing PG_lru, and the
do-while (!ret) loop in offline_pages() calls scan_movable_pages() again at
the same head PFN, looping indefinitely while holding mem_hotplug_lock and
pcp_batch_high_lock.

Conversely, if memory_failure() on a tail page is blocked in
get_hwpoison_page() before setting PG_has_hwpoisoned, do_migrate_range()
advances pfn to the end of the large folio, sees
folio_contain_hwpoisoned_page(folio) as false, and migrates the folio
despite the poisoned tail page.

Can scan_movable_pages() and do_migrate_range() check for poisoned subpages
across the folio so that large folios with poisoned tail pages are handled
consistently?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101-memhp-hwpo=
ison-pagecache-v1-1-ed8785ca44eb@columbia.edu?part=3D1

