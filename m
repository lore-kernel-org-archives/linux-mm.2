Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B99E60A2618
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmMB1JqZ
Received: by kanga.kvack.org (Postfix)
	id 83DA16B05B3; Wed, 18 Nov 2026 09:52:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE9A6B05B7; Wed, 18 Nov 2026 09:52:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD036B05BB; Wed, 18 Nov 2026 09:52:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46FAF6B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:52:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC9E7A07B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:52:28 +0000 (UTC)
X-FDA: 85448530776.08.C2F782E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4298C2000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:52:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmMB1JqZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4fw6wH7cRG89Xgv9DmNPTYzRhO7v7keamB5liM55x0=;
	b=OYrdIOvX5/R3D7qMENsle5XrpU4IbBATjK50PJn/zmrhUAkjufdcN5fzKMEqlpWxWluie5
	nMGFCJaeEEOxfkFdKtuG6RgKHXtoAkKrtq2dH2PYpQcHYYbb+dvWF/CNBC7alijA2sKSYP
	fxDItraKKGnwElYIn2a1Xccj8pkXR0c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmMB1JqZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013547;
	b=8dB9HsE4rhDD8A6U8xXUXkScftZx2yooMaZhI0dT8jf7hITVyoEMjsDnWJ4urqfbPvVuJS
	v9xYzPJM64I1IhVNWkt+SAhxigrCxl1Ot0uaUBKrrQMX8JD7IukEJeLZj8hmQVe2sj/V7/
	tzuz3Jpl2t0VAJkFzaLLmTE+Nd6KtuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 968F662290;
	Wed, 18 Nov 2026 14:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35461F000C4;
	Wed, 18 Nov 2026 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013546;
	bh=u4fw6wH7cRG89Xgv9DmNPTYzRhO7v7keamB5liM55x0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dmMB1JqZH1zCDAONsrZJ5AXpbtBhioXa5f2XoqUI4Tl4ece9yzguQMNNy7LcKcbU/
	 SFXKxhz60iY7aZB/cKWhVkx2kI3mvr9wpdq5vhKxwcGSYKWzyPIkU95mFq6dr4X2C5
	 8tVA+8eO+zY1sJU/8a3biSSof6aItdm5RnJ++Q3LbsjRB+MXCn4VBH0ycBgldRitLK
	 TGKrEbeTSrAOAqVWJtDMKtfqbC7gQt794hyCBK6KLy4pjGdTSqKxfTn6assRS7ijQh
	 IeipmuUfsmYzdar26x9qGw0mPzJfuqLKDdQ7mu2oIcFU5WCAbmwqAccEBhhK5qzqky
	 CIG+yJLR4jpPQ==
Date: Wed, 18 Nov 2026 16:52:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
	nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH v3 8/9] mm/migrate_device: do not migrate a
 uffd-protected zero page
Message-ID: <av27miMZrEyB5egZ@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-8-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261117-uffd-state-fixes-v3-8-b617009d1a4a@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4298C2000E
X-Stat-Signature: eckxs3yakeezwq3cfg9q4tgatydw7u3d
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795013547-670977
X-HE-Meta: U2FsdGVkX1/tjK+P6W0vjFjEz6+qdqAAEG3MyKNNHoxYUO920UdrWVSY6KqVoGOdAcjr5MfDbg7MsqzfF9X4rRAFkRAt6Vd+ba7DrwffOb4Oda/zVnWTvfGM4dU49/60wG+RujJmZB0GD8vEP3OITPHhYSNWdt8oocs5erf4aIf2DVz5CqI4dU5q9WKWoiEMuCtESXDqtgI4zYywZez4MISFJPjnDSVnCFnNKpGJTWXJK2TqEaA0VGYpdAjStLdbdrxA9Bwqu8yTpKpRD1R2KnEuMEOTDIgy1Lfu++9dE/nmoNqfljEBljpxjYWwrLA1/kaJc/wuo5/rR+ZC8F6/3Pu9XIeytSf/jSuAKgL/4wwy4so4omGMI7TiZKYyjeoz+DFem5COM3d2Jd3axn7L8NSCCE+1x9asqW1le+5LvrkudhnmBO7ByduzbXEbjM8FlfGwNX+8pZ2zBx57LVJbZzyEs+kzNs5e5yYAv9tdmcRn7pmN3N9GBMJcPxCnZ2pt/fX60FqgtbdbcPX+oiM/J+nlIr/wWboZvDV2jWWvoZYOu7RhWrg3pAht/6CAK8eWnnldSnBGFoeN+d14jpdWHVAGKJFD9fj+/fo4zN1m5crxkjDF5L2tWTGyIYVZ1OSeg6IXaRiM5SG+zWbZJ+cGg+bfO/BPxhiJaHdiCrr9tOjJyMSxFFfOuP8NOAoUhNxTllHFEUd+bqYUlkaWthWwlBTmA6mxay9fyMemO/I2udFHhMakktIr9at19HvfWsYvNtqJotb0n04FCxLcAJKvilosNNJIBZnr/2BjphBrw1OP9T5B+YhY0dI/DFN22Yid1m81NpRUXPfGBQ61HLYiBvc73yWqcuURiu8WPXI93WmdhmAFJWmXkkbyTxOZOnknM2DZDP9JeaWPUZAeqIzAlWCF2yUSNwQnEqHQUw6RF7z2Nl1X6yTHZiBBIOtn0vkgdtA4Wx7TEDZYlEfDMrn
 +yjx6bzm
 XnlTOAaLYi+Vmhwtb/Oz5JIZdx30f3EcOwIIW74XCuTBc3+z/+yRn69R8Y8X2lwzz7bVFJvypzSm2hOeIv4/yU4edtbdBDesFEpgaX1ieoCtR3Y0L7Lql1ygSXomIeApXXkE0VvnXONPjM9s0iGvUP37x81PScl0MhVFr1hlDNIg2F1+Q5uNE35L/eF2mnBxThbxs3DgOwxpquPXvxDp4XTKrfSsrrBlTrqh4Li5nhZTvpM5R4qV4HIvWYVpmghHYTtfl+VIkqFs6QQA1QjpR1jac0ZJ9G5jp0MpWI3MgzXZ2Mf8JGdkgPbZhEG9Vqd9NnMVOP+bHEmj/6vWQyFwUzNDbdds+eNBYC4hwHprgrwl9/n87xY8K2P50X29tCwPmohBScBPiRN0hIqqNIgzSsEUedIUvdSvdfhvqD6VjVC/5zaOQhM6ZaSI/teqITTOd/t/7l46twJ+5cLDa4yaedoqoEboW+YSwfiY9np2yqpmsrbrBgthKU/li2Cc+Mj6hff1MpP+tBF6vri2OLGgFg1RxLJz4hYVWEctH1qVuq3nwqKWkZHOSToIVetLAXCazVaulbj+toKIZrcuyY14BmO4yuU4ScWq/DTK+4zqfrngw0hbYR/QDk90NW3ieNiSnx/iG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:48PM -0500, Tal Zussman wrote:
> Device migration replaces a PTE that maps the zero page with a new PTE
> that is built only from the VMA flags, so its userfaultfd WP or RWP
> protection is lost. The same applies to the huge zero PMD. Writes and
> accesses to the page are then no longer reported to userfaultfd.
> 
> To fix it, do not migrate a uffd-protected zero page. Skip it during
> collection, and check again under the page table lock before inserting,
> as another thread can protect the page after it was collected.
> 
> The alternative would be to carry the uffd state over to the new entry,
> but a uffd-protected zero page in a range that a driver migrates should
> be rare.
> 
> While at it, read the PMD once with pmdp_get() in
> migrate_vma_collect_huge_pmd().
> 
> Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: dri-devel@lists.freedesktop.org
> Cc: intel-xe@lists.freedesktop.org
> Cc: nouveau@lists.freedesktop.org
> Cc: amd-gfx@lists.freedesktop.org
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/userfaultfd_k.h | 24 ++++++++++++++++++++++++
>  mm/migrate_device.c           | 34 ++++++++++++++++++++++++++--------
>  2 files changed, 50 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.

