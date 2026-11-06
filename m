Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B2A606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KfIZaFeC
Received: by kanga.kvack.org (Postfix)
	id 2856E6B05B1; Fri,  6 Nov 2026 15:51:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235C36B05B2; Fri,  6 Nov 2026 15:51:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B336B05BA; Fri,  6 Nov 2026 15:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8E406B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:51:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69ED61C233D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:51:06 +0000 (UTC)
X-FDA: 85405888932.23.C1035E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA35420008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:51:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KfIZaFeC;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793998264;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Z43IGhuspYCfpzuAAw8swVktLNXQHUFUy1aOvlU79o=;
	b=1K+cpTS+KYkL59tgnfP6LcZR0feTVKYgpmxIs+f2JrDNqTuCDpLX1om3O3HbmRp7LSLd+R
	qHqPHPGFbDZZ5fOGswRkRECbpMq5wYx9yz+0VJ0xbEjJen+y1H085MEx1b1s2Fa83WdAyM
	keV/LfPDYdTnhLIfN8YH99lBEYH9yYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793998264;
	b=tqDkMVJ01+dUHGbYLCljGfPC977eb1IEX0mr+s+PA4L4i2h/20uyfn0kLSy8R0gjIDBScp
	FsVxM2Pc/YfUgEbCcJocUtCY8XAPFvsrkFiZ44H/sqYMVY6l66tKGqNGNnA9QHofs/KYKm
	R25N4cvh2UIhf0nOkkruhZXz19GLXAY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KfIZaFeC;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23AFD601BF;
	Fri,  6 Nov 2026 20:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A3A1F0089F;
	Fri,  6 Nov 2026 20:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793998263;
	bh=/Z43IGhuspYCfpzuAAw8swVktLNXQHUFUy1aOvlU79o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KfIZaFeCkJp7t3ZgcF9I8MLKGYc9Yyh9Dr3hYZ+f9zxxY2rTDnuTu6/ce2JXKui/Z
	 f+6UxSMb8x8sf/0rDn+SWJLAOwP1qCvdTSNg0A/2LdPviCpV0A3hR5p6WTXLqJjV8z
	 btx2wnG7sD5YTiZ3Myi94TdbXcpzSnFWMbefaGu66KRBr1GeRcerNCQIr5Y0G66Lg3
	 F3WR76yAQGGQd3Fj0gcaw8fqwnP9IjoPnmz3y+BYc+/ju2ohYpgamMlNGFdiWsQFWd
	 x/cfXTI95AJFogD+/N5yTO1wjdZBz9AVAcLxYMHCrZTN75bsdZtrb+LrLaQtiZYH/A
	 aJs3uqM7zXPCQ==
Message-ID: <sashiko-outbox-202255@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: don't offline a hwpoisoned page
 still in the page cache
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>, "David Hildenbrand" <david@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Gregory Price" <gourry@gourry.net>, linux-mm@kvack.org, linux-cxl@vger.kernel.org, tz2294@columbia.edu
In-Reply-To: <20261105-memhp-hwpoison-pagecache-v2-1-029d35634d42@columbia.edu>
References: <20261105-memhp-hwpoison-pagecache-v2-1-029d35634d42@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 20:51:02 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA35420008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: z4cftche1qqi9r9xhqiny5a63mnm86rj
X-Rspam-User: 
X-HE-Tag: 1793998264-933626
X-HE-Meta: U2FsdGVkX1+Oy8TmmbV7dNw91SYKpbMpT8bL/JlR6pVZINVL6L2JcavQqnhvnIDDO9htAXx7LHGh2BuLywaytW0oPffuAj9vltyTyVW8MRASQsEs3TYyze8TJ4jOJ71GYsq6Ud26La0zm/HcSN43VhHHu2S1ES2RiwrZjT0IrX10HutTSn7WeZaakKcorHX6jDjjylVe9szG5971zSxJShPHpKSDpgobE9utmVa6hK5NrLKqWK3uimgNF/jDnW6T6SEST9ulvLEuESVP7ZjNK1Y/4Iwhsd1bXjTtOqVnaHFnnfCUZMxOBcGXrT6uHLzbwkZirMqlkbVzSi2tm0ZIfNlL9Iwvz0no0mxmTeiwO9x3NvfcoM8ZOcVxT4x/+8vfbjXCwruLMR2rDkwfZmG6vrF1OEcAmjRoJhH9Q/WS3NXtiTZ6dDU2t2cOtE6HNZdJP7WmxdhaFMATZPfKjIGoMPkQWxT8bcUc7dfNpeIl+sDTOJrhXyjgBOnH37a6taz9T5dhNxpLw7vg9cKH39khuH8HmN85LLdGCx3Df/+w9TRI1TmqemsLVpsDUeutRtS95Fjg7+ddWyotVgWHUctxMNKbvm4LLFxmc8O79wqMPxdY8h5GWCn9MEVgNkyDtuKuOHtA7LC+tBGlVyF1NrfitE6j+U4VP8U1mtE6Dmo4OJFJ+XLZ2sV+4EviC+K3XXfiLY1hw4q7wCi0JlH7ccQ2Qjx3tD8GMmsVYz3/jptKQc2c/2PEmaLD574ozRZRksxaxCTWQL9PHBlq0nk5Dy+jMY2QLcejmNrzVHBisTfNaRlY59TDc+qcffTT/Ryg+ibmq4stgfB7/nl3zZTqu7/FFxHWbGDqLfwzVCTIKmIWp3rjW1ZFebwHmDPDeJBKD6dhXhXq001hV1rN7bXUZiJFIJmEPNwvjPfBJDR2TwKPumgUIoyv/fvvr85zcDzYZCGjogPT5OAqSZMb6UpJL6V
 yAjkcwa+
 pl0rqXnXbs+upzc1B4wA9/fKTYmX+4eskXClP6QunWFsZw/XBNSQtXW0cOzq+gK5bEzgBV6vL/HOdIfhfiH4gOn+ezKhKYAdplMADdR9RuGwIF9nJG0sTchmMF7qox1hCC6T5jMmNiPSwh3U03/6mExLZ5vmPGHRPIUw7spwKpC0Y2Xv1H6eOlNB8IC/GG0q2CJICaGR1YJc0VmiUHtKAlX/ybw1fYjd9+aTStW+DwanRqsEQdl9aeqwwPPWVaAh61kjPRE5zp+z2AG1/5cTuTwrPOYCGmbd4Dp+VxmnpIaqKwuoLF7p6lq5C6fJrtbK6KLibb1b6fKAREQsRsqQ544zC9lDyxEFr/U+Xk6y00tyUZElplCLzT63NDvRQxu3HxWjmHg4aM3NJ0hzfwqhMMr9Roy2uq+DKTGBgQj886MS3dJESOviSoPeOA7Vl3G5L/AHxmriTrMU/NosYcQB5+QLBmjg+GQNVpWXrutepSClmsCvaF3uegR/MLXTkbDQWyKytPvygGiiysEoxXQzRJZ/80r49zeNalofYVTJSYl1lb5G4dg/MX9s3ELtCvVuGb52XwolY9sdxL9hq8YzYp7yEGUIabrTBRA4Ygl39qjS1mEjAlFRIs2AyWJexbVcSNo/yVTRuLPcvkFWqVQySBMq6NEKLyyl3mntP1/W21VB0GIux8Gm1Ft/XdZf/93gcQpZDDkKD8Mie6CI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/memory_hotplug: scan_movable_pages() misses poisoned tail
  pages of folios
--

commit 3a170d5683c399929cdc4fe6d9523b3ecee4c1c1
Author: Mani Tofigh <mt4022@columbia.edu>

mm/memory_hotplug: don't offline a hwpoisoned page still in the page cache

This commit prevents memory offlining from skipping hwpoisoned pages whose
folios are still in the page cache or swap cache by introducing
hwpoison_page_offlineable(). It updates scan_movable_pages(),
do_migrate_range(), and __test_page_isolated_in_pageblock() so that
offline_pages() fails with -EBUSY instead of offlining memory still
referenced by a mapping or racing with memory_failure().

[ ... ]

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 1bfd1f4daeb20..c5cfaa24b41b7 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1821,6 +1821,8 @@ static int scan_movable_pages(unsigned long start, =
unsigned long end,
>  		struct folio *folio;
> =20
>  		page =3D pfn_to_page(pfn);
> +		if (PageHWPoison(page) && !hwpoison_page_offlineable(page))
> +			return -EBUSY;
>  		if (PageLRU(page) || page_has_movable_ops(page))
>  			goto found;
> =20
> @@ -1887,6 +1889,9 @@ static void do_migrate_range(unsigned long start_pf=
n, unsigned long end_pfn)
>  			 */
>  			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
>  				goto put_folio;
> +			/* The offline fails on it anyway, leave it to memory_failure() */
> +			if (!hwpoison_page_offlineable(page))
> +				goto put_folio;
>  			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
>  				goto put_folio;
>  			if (folio_mapped(folio)) {

[Severity: High]
As reported by Sashiko on v1 [1], what happens here when a tail page of a
large page-cache or swap-cache folio is hwpoisoned?

Because PG_hwpoison uses PF_ANY while PageLRU() uses PF_HEAD, a large LRU
folio with a poisoned tail page has PageHWPoison(page) false and
PageLRU(page) true on its head page. Since scan_movable_pages() scans PFNs =
in
ascending order, it encounters the head page first and takes the PageLRU(pa=
ge)
branch:

    page =3D pfn_to_page(pfn);
    if (PageHWPoison(page) && !hwpoison_page_offlineable(page))
        return -EBUSY;
    if (PageLRU(page) || page_has_movable_ops(page))
        goto found;

returning 0 with *movable_pfn set to the head PFN without ever scanning the
poisoned tail PFN.

In offline_pages(), the inner loop then passes that head PFN by value to
do_migrate_range():

    do {
        ...
        ret =3D scan_movable_pages(pfn, end_pfn, &pfn);
        if (!ret) {
            do_migrate_range(pfn, end_pfn);
        }
    } while (!ret);

Inside do_migrate_range(), pfn is advanced past all tail pages of the large
folio:

    if (folio_test_large(folio))
        pfn =3D folio_pfn(folio) + folio_nr_pages(folio) - 1;

    if (folio_contain_hwpoisoned_page(folio)) {
        if (folio_test_large(folio) && !folio_test_hugetlb(folio))
            goto put_folio;
        if (!hwpoison_page_offlineable(page))
            goto put_folio;

This appears to leave two regressions for large folios:

First, if PG_has_hwpoisoned is already set on the large folio (and it was n=
ot
split, for instance because min_order_for_split() > 0 or split failed),
do_migrate_range() takes goto put_folio without isolating the folio from the
LRU. On the next iteration in offline_pages(), pfn is still the head PFN, so
scan_movable_pages() stops at the head page again and offline_pages() spins
in an infinite loop while holding mem_hotplug_lock and pcp_batch_high_lock.

Second, if memory_failure() on a tail page has called TestSetPageHWPoison(p)
and is blocked in get_hwpoison_page() waiting on zone_pcp_disable() before
reaching folio_set_has_hwpoisoned(folio), folio_contain_hwpoisoned_page(fol=
io)
is still false. In that window, do_migrate_range() skips the tail PFNs and
isolates and migrates the folio instead of leaving it to memory_failure().

Should scan_movable_pages() and do_migrate_range() check for poisoned
subpages across the folio (or check folio_contain_hwpoisoned_page() in
scan_movable_pages()) so large folios with poisoned tail pages also return
-EBUSY?

[1] https://lore.kernel.org/r/20261101-memhp-hwpoison-pagecache-v1-1-ed8785=
ca44eb@columbia.edu

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-memhp-hwpo=
ison-pagecache-v2-1-029d35634d42@columbia.edu?part=3D1

