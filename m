Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4A9606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b1QwyCTc
Received: by kanga.kvack.org (Postfix)
	id 33BC86B05C6; Wed, 28 Oct 2026 11:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313206B05C7; Wed, 28 Oct 2026 11:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250F46B05C8; Wed, 28 Oct 2026 11:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2A0C6B05C6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:47:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4931A6A0B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:47:49 +0000 (UTC)
X-FDA: 85372465458.15.C399481
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 10981C0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:47:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1QwyCTc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202468;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgJmt+XTR++7X+fLOMxmFo5T8WySk5Y4JyFm46a/xec=;
	b=oZWs5DZFo0mkWChRflDBA0ok7TCEZmFKWJjT8Cva0aIB0QW8SpHewElHcLj7ZVpXM5OcL1
	SGESF2TTOxpRxMjnPaYh+hISZIcdNIa5O6CQ4IMR9TdWdX+ImqUj8O0xP7MJIVpGc1OLzv
	/Y7+3VzZmbT/5ICZ6ogk2DbGuAYTnks=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1QwyCTc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202468;
	b=TtBeWHy/xfx9mg4/6rV5cuPrLJezDOOEUVyu0BgwacqjGM95KxYINBp1+wL6bTATPWjdKH
	MgBvkJ7/hqNGn9ao+FusY1n8WvPrdop8anv6A64oTeMhBxn6A7tWKm5FjmDtwoDyKITEVO
	oOmLeQGHKFmAhFMrtuBNK7+PR4nGT7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87A7E600DA;
	Wed, 28 Oct 2026 15:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32E11F01825;
	Wed, 28 Oct 2026 15:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202467;
	bh=PgJmt+XTR++7X+fLOMxmFo5T8WySk5Y4JyFm46a/xec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b1QwyCTc1fvCLtgzXVjkF/StdtRg+3r8H3zGMg/gjJTP1hTkFzaRddVwEbh44XjQ3
	 mV7UYEH435qRwKfX7sT/LtuXPPewd/hCAX7noj8fDzTa5zjMeJabT02nG5m36TWHc5
	 4O/HlZd6JMmD378zQOR4rxRlUUzEFWolIpa+2cyU6HHfQzyt33Kqh4akmpPEcM3TqB
	 3Eu0ywxS0jRj/41HciZdl3R5LXCF0TKRKe9bFjfFODqhP350ZNzCacmVNWHQi05DS2
	 Xb2oF5okKF4SLOcWfim/wkND5znYNm6Pg2kRVfBZdOSImdN4gAJrxvcY3YPG2j8hds
	 6XmQctEjwdQnA==
Message-ID: <sashiko-outbox-188078@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/9] mm/compaction: trust zone->contiguous only in the
 span
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Zi Yan" <ziy@nvidia.com>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Mike Rapoport" <rppt@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, linux-mm@kvack.org, "Josef
 Bacik" <josef@toxicpanda.com>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-6-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
 <20261027-pgalloc-ai-hotfixes-v1-6-9c7d1aca801e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:47:46 +0000
X-Rspamd-Queue-Id: 10981C0002
X-Stat-Signature: 83ybu6ekrc8e3idt69pqptrcknpbrup6
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793202467-395019
X-HE-Meta: U2FsdGVkX18rjY7BrRH3SAOqmPpG8vpVkJtfU2wWVYtEj9CjyepmnUw24wzNB9tZWm5Un1KmC1Jj+jCtvxJcRyWORxJGHDS3ti1xHs1r3PH7CkeMQNt1nAvhZ20HOj8wHsTmKJcJgHQhCOmy74S3UODe1O9I8+DGMYavJ2WXDsa7y2xmvGgTVnAEw0B9Q8gZbgtSZnHNU5ArduFEM0vgWwcuBofPuAra0jK52rsVOGpcjmaZPgQZRw0iEO7lyd9AcI8NA5Vs7vDyepnN1H50JjtgXdgUr/ODN7uuAsLIl35N8x7QNwvpWIwVk7yxLTPPYJvEyU0RiQP2bST2B44Nd0P1hlP+ZM/Gy78aXyes6d6vDvswRuc77lnIixHk3t949sFmHl4SK3/xKlIVLNVOHdAmEd3XTDGzkzVXo2ogWW+t/CLiSqgSIiwfAoGRO2mOU5dxSCj+E3Rc3lKmkuymDwdnvGKZPXVE+GBEUJrDM7cy15K/oMRkwXGHQD6F3o+dfOCGre3khuEDUYTyVOhWrOjklH6ouBH57awI5blS98uLtKm1mIL8zjwayArFG3k/qKi8OcGyzejbuLQ9RQQofTgiMNKNJFydlEo12Qt05Mi+i5xv0lowBiBYnDH7FdQbvz201mEXA7ig14I0X0VsnN+LcNV7mW+gB1+/vRGzpXBjzZe+Rf3ZtmUYAfIsg3y6AQ7NkVmfWqteR3RtCrHW9B4Wkkmmw1apdB86Gcqi3tRRj9pj2swGkCcCnYLrcGpcfBHK11CE8j+sVq3tlyFntU5ibZgZ5brnXgiQbiZ7vTt7graTbA5ClS4i1stmJeC/cLZH1JCfnhytrUFhZCE05HBw8VZtT2HbEBh69JwfMYwgtE0Mg/DfEvV3k/WNGySr3eIe7IWAS3p7sDexyEQIPgjptDv7UhaumHuAEvi/moMlKHpQI68JQFwwp+liQFPbwttvjGQw74zTFJbt2XS
 Rt3RttmT
 t7jbuNjQgxo/fuQ+n4YgdbXdyQlg9szrNpzWP8qd9LMFz7snTuKKtNVwEM0SVzfGchCZRTW8i4FxKOamjFCITj8tKfnU82aNii/BZhniCHEFf+LOd3MYt0kfW9vd3FT61dPKZ95iE6/CYaXFIUehMdl26VELKKEmSF5BXOL4vGaQ83zxeSl2g2RbGztKsLZYxXgIf0jJhWEHnpSvtI7DCYIWvUaOQGGkdfww3cnyOgmpaSxX7MoeQrufDqToWbC+hzWmkh6lJ0/XclOmYeNI+MoX250nBj2SPBxXGOHZjB6rk7tW32lDlfchtAi0ILzMVLe/Wh8tolyTdNGvM/+Aq/7j2bzrgMFhUv2ucBU/b6DD0qM1mGNc5wOcqfkC/w6wQHPYzRM0mGgy5v+FUJEQdqKq5BNntCxh7ZUzis2M8P4TeF5kR5cE5pMGJq9RK8pVm2L4yY+qr1Gk5NG3corEzjggB6K46giSztimHm7c0IxAv6uhM88ykydnp05xV+F1oLCvyHezwqX1zxs+b0ATBnspXSwN+T5OQ50j9SWqmHhxWMnjjz1+3OVsCMJlXXabBHmWyuDCODHnydeI8niIbQjdUwstlpI7CJF2DBXifpzIFE4QRyYdR8fX+JnzmC/fuQUo1S3KA2gB3Bif/Sede3l5Q6pfXr16u/e2TK190bNey2X9DLFS+MLvQow==
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
- [High] mm/compaction: pageblock_pfn_to_page() ignores end_pfn in span che=
ck
- [High] mm/compaction: racy zone_spans_pfn() check in pageblock_pfn_to_pag=
e()
--

commit fc93d5609d6ae896a622cb4ad47040ba39704072
Author: Josef Bacik <josef@toxicpanda.com>

mm/compaction: trust zone->contiguous only in the span

This commit restricts the fast path in pageblock_pfn_to_page() so that
zone->contiguous is only trusted when start_pfn falls within the zone span,
and pairs smp_store_release() in set_zone_contiguous() with
smp_load_acquire() in pageblock_pfn_to_page().

> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index 2b1017a91928c..e24d1203c5148 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -216,7 +216,12 @@ extern struct page *__pageblock_pfn_to_page(unsigned=
 long start_pfn,
>  static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>  				unsigned long end_pfn, struct zone *zone)
>  {
> -	if (zone->contiguous)
> +	/*
> +	 * A scanner may still be at a pfn that has left the zone: the zone is
> +	 * shrunk before set_zone_contiguous() says that it has no holes.
> +	 */
> +	if (smp_load_acquire(&zone->contiguous) &&
> +	    zone_spans_pfn(zone, start_pfn))
>  		return pfn_to_page(start_pfn);

[Severity: High]
Can pageblock_pfn_to_page() still return a non-NULL page for a range that h=
as
left the zone because it only checks start_pfn and ignores end_pfn?

When the lowest memory block at the start of a multi-block zone is offlined
and removed while compact_zone() is running with cc->migrate_pfn in that
removed lower block, remove_pfn_range_from_zone() advances
zone->zone_start_pfn via shrink_zone_span() and sets zone->contiguous =3D t=
rue
via set_zone_contiguous() when the remaining zone has no holes.

On the next call to compact_zone() -> isolate_migratepages() in
mm/compaction.c, block_start_pfn is clamped up to cc->zone->zone_start_pfn
while low_pfn and block_end_pfn remain in the removed range below
cc->zone->zone_start_pfn:

mm/compaction.c:isolate_migratepages() {
	low_pfn =3D fast_find_migrateblock(cc);
	block_start_pfn =3D pageblock_start_pfn(low_pfn);
	if (block_start_pfn < cc->zone->zone_start_pfn)
		block_start_pfn =3D cc->zone->zone_start_pfn;
	...
	block_end_pfn =3D pageblock_end_pfn(low_pfn);
	...
		page =3D pageblock_pfn_to_page(block_start_pfn,
						block_end_pfn, cc->zone);
	...
		if (isolate_migratepages_block(cc, low_pfn, block_end_pfn,
						isolate_mode))
			return ISOLATE_ABORT;
}

Because block_start_pfn was clamped to cc->zone->zone_start_pfn,
zone_spans_pfn(zone, start_pfn) evaluates to true even though
start_pfn >=3D end_pfn and end_pfn is in the removed range.
pageblock_pfn_to_page() then returns pfn_to_page(start_pfn), and
isolate_migratepages() passes low_pfn and block_end_pfn to
isolate_migratepages_block(), which dereferences the unmapped or poisoned
memmap for low_pfn.

The same start_pfn clamping occurs in isolate_migratepages_range(),
isolate_freepages_range(), and fast_isolate_around():

mm/compaction.c:fast_isolate_around() {
	start_pfn =3D max(pageblock_start_pfn(pfn), cc->zone->zone_start_pfn);
	end_pfn =3D min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone));

	page =3D pageblock_pfn_to_page(start_pfn, end_pfn, cc->zone);
}

When pfn < cc->zone->zone_start_pfn, start_pfn > end_pfn, so
pageblock_pfn_to_page() returns pfn_to_page(cc->zone->zone_start_pfn) and
fast_isolate_around() -> isolate_freepages_block() falsely sets the pageblo=
ck
skip hint at the new start of the zone. Additionally, if zone_end_pfn(zone)=
 is
not pageblock-aligned or shrinks from the top while remaining contiguous,
start_pfn < zone_end_pfn(zone) < end_pfn allows isolate_migratepages() to s=
can
past zone_end_pfn(zone).

Note that __pageblock_pfn_to_page() in mm/page_alloc.c also does not check
that start_pfn < end_pfn or that end_pfn - 1 is online when start_pfn has b=
een
clamped into the online zone:

mm/page_alloc.c:__pageblock_pfn_to_page() {
	end_pfn--;

	if (!pfn_valid(end_pfn))
		return NULL;

	start_page =3D pfn_to_online_page(start_pfn);
}

Should pageblock_pfn_to_page() and __pageblock_pfn_to_page() verify that
start_pfn < end_pfn and that both start_pfn and end_pfn - 1 are spanned and
online?

[Severity: High]
Is reading zone->contiguous before zone_spans_pfn(zone, start_pfn) without
zone->span_seqlock safe against concurrent zone span changes?

Reading zone->contiguous first and the zone span second only pairs with the
false to true transition in set_zone_contiguous(). On the true to false
transition in move_pfn_range_to_zone() and remove_pfn_range_from_zone() in
mm/memory_hotplug.c, clear_zone_contiguous() clears zone->contiguous with a
plain store before the zone span is modified:

mm/mm_init.h:clear_zone_contiguous() {
	zone->contiguous =3D false;
}

mm/memory_hotplug.c:move_pfn_range_to_zone() {
	clear_zone_contiguous(zone);

	if (zone_is_empty(zone))
		init_currently_empty_zone(zone, start_pfn, nr_pages);
	resize_zone_range(zone, start_pfn, nr_pages);
	resize_pgdat_range(pgdat, start_pfn, nr_pages);
	...
	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
			 MEMINIT_HOTPLUG, altmap, migratetype,
			 isolate_pageblock);
}

Because the writer clears zone->contiguous first and updates the span secon=
d,
a reader in pageblock_pfn_to_page() executing in the same order can load
zone->contiguous =3D=3D true just before clear_zone_contiguous(zone) and th=
en
observe the expanded span from resize_zone_range() in
zone_spans_pfn(zone, start_pfn). When a contiguous zone is expanded across a
PFN hole or before memmap_init_range() initializes the new range and its
sections are marked online, a compaction scanner with a PFN in that hole or
new range can bypass __pageblock_pfn_to_page() and access an unmapped hole =
or
uninitialized memmap.

Furthermore, zone_spans_pfn() in pageblock_pfn_to_page() reads
zone->zone_start_pfn and zone->spanned_pages without zone->span_seqlock
(which remains unguarded even after later commits in the series resize zones
under span_seqlock and check pageblock pfns under span_seqlock in
__pageblock_pfn_to_page()):

mm/memory_hotplug.c:shrink_zone_span() {
		if (pfn) {
			zone->spanned_pages =3D zone_end_pfn(zone) - pfn;
			zone->zone_start_pfn =3D pfn;
		} else {
			zone->zone_start_pfn =3D 0;
			zone->spanned_pages =3D 0;
		}
}

When shrink_zone_span() raises zone->zone_start_pfn and reduces
zone->spanned_pages, a reader in pageblock_pfn_to_page() can observe the new
zone->zone_start_pfn together with the old zone->spanned_pages, causing
zone_end_pfn(zone) to transiently extend past the actual upper end of the
zone into a previously removed PFN range.

Should pageblock_pfn_to_page() read the zone span and zone->contiguous under
zone->span_seqlock, and ensure clear_zone_contiguous() is properly ordered
against span updates?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-pgalloc-ai=
-hotfixes-v1-0-9c7d1aca801e@kernel.org?part=3D6

