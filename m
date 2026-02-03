Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7ACDE83070
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 09:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C890F6B0089; Tue,  3 Feb 2026 04:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AAD6B008A; Tue,  3 Feb 2026 04:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6CCC6B008C; Tue,  3 Feb 2026 04:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A425A6B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:31:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1945FB8FA2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:31:27 +0000 (UTC)
X-FDA: 84402627414.11.14474B2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id 41C51C000A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:31:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dkruFm8L;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770111085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPhLci5Bi72Afj2eBzLvBWVrNijZ9BfZyb+vPdg9cKo=;
	b=nmR5/ndx6bQ+abNW2yRSWFNbweAUtXJtwibzfyItLII7Y7HZk9f8DNJbHa6NCP78c1J7sy
	GtYe9+FXW09OeM2O1jk8gsqYU40EhbDwZstJ1McoxreXMwu6qSb0kXFZs8fMYg3a50fayc
	QvxARH26Uu+WhYqBqLrQ6iz4h8rWyQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770111085; a=rsa-sha256;
	cv=none;
	b=TJImC7lPLxNqY5lTQ+/Xq3/ijuenQ62MaX+A5bZoMRUTEmW7TI4Lmq0KpTJ0TtrRG99Hqv
	zC+toOaViquOQZwIsM65bKKl1jnAkhDPBe+9+bKtFe0vmCyZfQYgoDbX75isqoTUbNuU4Z
	/USv2ktkC/y4A7n9aiXs74GhvuE0J0Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dkruFm8L;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770111084; x=1801647084;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9ZCbCekETf/Hc7H9g6zabuW31iHCCcdMboCzlVHoOOY=;
  b=dkruFm8LB1uWUa5bOHOo3MeXo3fyiKK70ai+X2MEfxhjVloYoww2DqEt
   bTvTQnWKmkoeE5/P3ml9Sr6PdznKujPR7vk1CkLlIsDQUzUykzfRav1fK
   iF4pr3e9S6Le/EzBiWxO2DMZoPhdsBEFzdjxjS3BKMIXWOUTBvMBnRQ6a
   v6HaBtNKxK9hbAcnfBfkwXR3danRlLE5S6NpIUkYl47sVlzmwT1gfchoe
   HU2dIeeNKvg/pPfbmqv3vDZ7zbYOcLYzCYYbyRKEnj3XDva6Hlt2Asqq9
   z1l36LB2KFQCiCTwctNtpbJC7q1n+ISH2BtgZYKREl/wsvWRuAJ4oXN5N
   g==;
X-CSE-ConnectionGUID: qcA/iZ3nRNi0359okAV2jg==
X-CSE-MsgGUID: 1b/lGGdOQXqfQ6TJxEbPig==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="82385806"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="82385806"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 01:31:23 -0800
X-CSE-ConnectionGUID: lG5quSw+RHGTOlWRbhDFtw==
X-CSE-MsgGUID: lZ/yXG0gRkCAAQSG3/jopw==
X-ExtLoop1: 1
Received: from rvuia-mobl.ger.corp.intel.com (HELO [10.245.245.55]) ([10.245.245.55])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 01:31:20 -0800
Message-ID: <9a9853a320a30802ff35803a574aab037aa2fd92.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: John Hubbard <jhubbard@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 intel-xe@lists.freedesktop.org,  Ralph Campbell <rcampbell@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>,  Jason
 Gunthorpe	 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-mm@kvack.org, 	stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Tue, 03 Feb 2026 10:31:04 +0100
In-Reply-To: <a5b71dbc-9e3a-4098-8821-21a9a02ec235@nvidia.com>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
	 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
	 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
	 <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
	 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
	 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
	 <a459f147b461c6e6e806282956b7931f74a0aa93.camel@linux.intel.com>
	 <a5b71dbc-9e3a-4098-8821-21a9a02ec235@nvidia.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 41C51C000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nq3emyszktrq84xzht93kq5ihwscmyqx
X-HE-Tag: 1770111084-619140
X-HE-Meta: U2FsdGVkX1/gMHte5rfil9eVC7FLiSmAW38Iqm28htqb3ZzQ6tY+JwgAfjJX+6o7dLf5rFYUj66Qr76JHANQ75akg8i2YZ/AafOfFedLweXFxNeqMeKpKpzD9eF3XXJ+R2McnSfceQgPzkC+wqVhb1N/3tzfwWLVLznJcyYBsCUtOCot3YTFrqI5LLimOMUBrPqgq6e9nl6FRpyCXKrbheXbEe4RrWBqxkKof+ww23bD29FmQnV0o9mTFhJAMgdXqC3ajDBymhnx8qcpLm/p9FA8Eom41XvY+j9UuvnpSWAi3/GR33HlTq8iMHIzh9iPrgooyUYjnfww0L6m5GRPXV3vsIR1gcDdV8DDaR/FwktIGtx8fL4d4Z/j8Ro095ytkvxGuRubBxehXRkCWYCFitwZOL89KtkVXUEu+VXzFQh5wnNo3v5kzmeYSiJ57Od7+sxWWTj4vuvJjyxTkOWfdpB5pYRIQ274K3P7kb3LV3cn3T+/bS67hXYZaqGHJnElMm5/vVqD0b8NycZX1pi7C7WbPTGASPvDUtJPHvuVIJgVka4osRcxAbMOaXtHVCa1BsCqrjVcX+bZu5sIeko2eU8W1IvIc6RCxL98gh/bT4opd+EzX4MFlP2u+1wbzGZifo0J17OlRyipkRcrJarIPgs3cw2EQb6+e6PnW/iU8Dbqiw8e2lCGs0V8E1muB0zuV2/qy10AtIIJnDdkETKkwwZ70QZlZjjm230Yd5OgyEZN4SGmqVA0kp7A92/dgjzkpxRFYjNsl3TKfaOr7H9Hl4n4jzP/bI1r3rf3pfgWmRsyXNOj6rUc1NattEoxZvZeexmxHyGj0FLplnCFs7RqK3+BQ/nkxYFrmC1NIbO67gS4Bp35ckKDvyTzVxte2Hg0SH8gKKAmj4KJOZFGDDXc6H/2szC1rhBJkBJeYLYGb618u9ENGwqKt8W0Ux2lQGEl/lDamvKuTEfwF0Bm+K0
 ojxxjaPk
 J/p6GOlOszxrpoDCvrzElyvLsRB9nWq3xPbXrxUkRsyKwN81YriSG/AiVXGiCqjnCBfBugL4McO3dYeie7xjr9sPevAwYxveX7fnCCJO++bWoMWM2N4nUTBlzi/kGSJ6bNSMNyzKwuNTtvnEF9j8rJTeSM0cBLW2QdpM6PFVQekufIOiKWRszZ/1tYteJmwicKiwySKdzX1uTADMxjdXTJ27lEDYvdlqlydSXyd0JKM0RHqWXXpZ1xvekDRg1y0znd4uOxjwF0uTrmWgAzgf48V/ogvvRhMKYtClwsOAMbgYaE6ukcFwlvYwl9JzNzqjWEQ3yHnfhr7T2EUw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 2026-02-02 at 14:28 -0800, John Hubbard wrote:
> On 2/2/26 1:13 AM, Thomas Hellstr=C3=B6m wrote:
> > On Sat, 2026-01-31 at 13:42 -0800, John Hubbard wrote:
> > > On 1/31/26 11:00 AM, Matthew Brost wrote:
> > > > On Sat, Jan 31, 2026 at 01:57:21PM +0100, Thomas Hellstr=C3=B6m
> > > > wrote:
> > > > > On Fri, 2026-01-30 at 19:01 -0800, John Hubbard wrote:
> > > > > > On 1/30/26 10:00 AM, Andrew Morton wrote:
> > > > > > > On Fri, 30 Jan 2026 15:45:29 +0100 Thomas Hellstr=C3=B6m
> > > > > > > <thomas.hellstrom@linux.intel.com> wrote:
> > > > > > ...
> > >=20
> > > >=20
> > > > > I'm also not sure a folio refcount should block migration
> > > > > after
> > > > > the
> > > > > introduction of pinned (like in pin_user_pages) pages. Rather
> > > > > perhaps a
> > > > > folio pin-count should block migration and in that case
> > > > > do_swap_page()
> > > > > can definitely do a sleeping folio lock and the problem is
> > > > > gone.
> > >=20
> > > A problem for that specific point is that pincount and refcount
> > > both
> > > mean, "the page is pinned" (which in turn literally means "not
> > > allowed
> > > to migrate/move").
> >=20
> > Yeah this is what I actually want to challenge since this is what
> > blocks us from doing a clean robust solution here. From brief
> > reading
> > of the docs around the pin-count implementation, I understand it as
> > "If
> > you want to access the struct page metadata, get a refcount, If you
> > want to access the actual memory of a page, take a pin-count"
> >=20
> > I guess that might still not be true for all old instances in the
> > kernel using get_user_pages() instead of pin_user_pages() for
> > things
> > like DMA, but perhaps we can set that in stone and document it at
> > least
> > for device-private pages for now which would be sufficient for the
> > do_swap_pages() refcount not to block migration.
> >=20
>=20
> It's an interesting direction to go...
>=20
> >=20
> > >=20
> > > (In fact, pincount is implemented in terms of refcount, in most
> > > configurations still.)
> >=20
> > Yes but that's only a space optimization never intended to
> > conflict,
> > right? Meaning a pin-count will imply a refcount but a refcount
> > will
> > never imply a pin-count?
> >=20
> Unfortunately, they are more tightly linked than that today, at least
> until
> someday when specialized folios are everywhere (at which point
> pincount
> gets its own field).
>=20
> Until then, it's not just a "space optimization", it's "overload
> refcount
> to also do pincounting". And "let core mm continue to treat refcounts
> as
> meaning that the page is pinned".

So this is what I had in mind:

I think certainly this would work regardless of whether pincount is
implemented by means of refcount with a bias or not, and AFAICT it's
also consistent with=20

https://docs.kernel.org/core-api/pin_user_pages.html

But it would not work if some part of core mm grabs a page refcount and
*expects* that to pin a page in the sense that it should not be
migrated. But you're suggesting that's actually the case?

Thanks,
Thomas

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index a101a187e6da..c07a79995128 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -534,33 +534,15 @@ static void migrate_vma_collect(struct
migrate_vma *migrate)
  * migrate_vma_check_page() - check if page is pinned or not
  * @page: struct page to check
  *
- * Pinned pages cannot be migrated. This is the same test as in
- * folio_migrate_mapping(), except that here we allow migration of a
- * ZONE_DEVICE page.
+ * Pinned pages cannot be migrated.
  */
 static bool migrate_vma_check_page(struct page *page, struct page
*fault_page)
 {
        struct folio *folio =3D page_folio(page);
=20
-       /*
-        * One extra ref because caller holds an extra reference,
either from
-        * folio_isolate_lru() for a regular folio, or
migrate_vma_collect() for
-        * a device folio.
-        */
-       int extra =3D 1 + (page =3D=3D fault_page);
-
-       /* Page from ZONE_DEVICE have one extra reference */
-       if (folio_is_zone_device(folio))
-               extra++;
-
-       /* For file back page */
-       if (folio_mapping(folio))
-               extra +=3D 1 + folio_has_private(folio);
-
-       if ((folio_ref_count(folio) - extra) > folio_mapcount(folio))
-               return false;
+       VM_WARN_ON_FOLIO(folio_test_lru(folio) || folio_mapped(folio),
folio);
=20
-       return true;
+       return !folio_maybe_dma_pinned(folio);
 }
=20



>=20
>=20
> thanks,

