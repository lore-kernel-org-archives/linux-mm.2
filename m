Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B558FCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF376B00A6; Tue, 26 Aug 2025 09:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0476B00A8; Tue, 26 Aug 2025 09:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5EA6B00A9; Tue, 26 Aug 2025 09:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE4C36B00A6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:11:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EF511A07F8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:11:47 +0000 (UTC)
X-FDA: 83818945854.03.1487281
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id A57074000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:11:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756213905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o0dIKLq7mMxlWwZyWFQYffTfikp/TwVGT+xrqhNBlKs=;
	b=3v9bnmabOg7o1aks6PnlZ/QHDwz0L+9DV5wWAn6f00c/kUflCo2vbXs+eDNmH5GPi/LkcI
	wFPOwvEeeDwwOli2VlzljV5lILepPUSz5yKX3+Ov5gRN3DlXDDAiVmGFNbQXsLvE5mLWCk
	wmzBwBhM/71E042uiP0oZqhgWe9yZFo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756213905; a=rsa-sha256;
	cv=none;
	b=PnspEkRpyVN1eJjgD1asrb6LyJA0Kk6RK9roCecVlxRDZ/tqq3oAhyhFpFIL86tlsX1YSN
	wJcCyQM0y9sma74oMAN2Z+szugtlxqyRBTjziVNLf+AVU0UYS0nvQyBHFTdgEWoZsEj+HL
	FhNk8UiCakXwZzQ0/kYo+jde7sexAEo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C1B82BF2;
	Tue, 26 Aug 2025 06:11:36 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B7A13F63F;
	Tue, 26 Aug 2025 06:11:36 -0700 (PDT)
Date: Tue, 26 Aug 2025 14:11:34 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 21/35] mm/cma: refuse handing out non-contiguous page
 ranges
Message-ID: <aK2yhtQ0M_0hqQHh@raptor>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-22-david@redhat.com>
 <aK2QZnzS1ErHK5tP@raptor>
 <ad521f4f-47aa-4728-916f-3704bf01f770@redhat.com>
 <aK2wlGYvCaFQXzBm@raptor>
 <ecc599ee-4175-4356-ab66-1d76a75f44f7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecc599ee-4175-4356-ab66-1d76a75f44f7@redhat.com>
X-Rspamd-Queue-Id: A57074000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qyq6prikx4ck5u3w736pjkjiafj41rsh
X-HE-Tag: 1756213905-261011
X-HE-Meta: U2FsdGVkX1+000zvnfOLp1JnHQek54Kq4cCmP2WYU6QUyzAt3H/XGIFN0f4/8wjuQYCgHJi1QApaW4ser20nQYILSakf7JhjYbjDY0rZ4tFQu91HVQQ/9QqddqQqTSt3xYT4IoTy51WIFHlvEPIbelVhLGws1Dm3/OOCerKjeY+DtEjBRBZkIDscvVxyTrPrhelelz22ducEuFuUxqkt/R28XV9Rgw4i5Xo5U+xjMzC8fw81S2slsqkmMR/weyl0gib2oY568Obc3zbZfjL2IByRlEsqt31bQDDdV1+1gNzast9F2eN+95LP57D7xrkqcivwq5PlLujVGOSi9kldSn+0Fe6fc9FIknqGSmWmqfR7vUiJNyZi+5sIvM6Zs4giSduhMU33G1YBjLv33j/mEwVoyzhhLscX34D/I30ap7a4W8REaoWh44cDRIrzkbDFltLWWpadq5C/5QCrlDr70+iRZKOIZa06qzcQznJsoNOjPNbD7UJe05mjY8OrDyXbaw1GX1+oWdMHAAO4nC/1zctwHG9CkLIAMgy2A8O1hoGwZHZGVGmZFS7QRA6Enf1ZtoB4lZ2mrgQlC43QHs/9UajyzsS+4NeZ5B9tpbARXXSm0PojR43e6chPKv4ejf0eiq39sfJTSgaV6UWLeIAgnK7Z+0NuE2qTHl9SqR0BVq7L5xaJB9hbo/WP8iwGmxGtIuJ+Ba0mybw1FqoCO+MmZS5/cXruDqjqTzBak+TzIdp7KwdMvE/Hxv5hAVSM/yZAE2iQNRVM3KvOB98ZpRBaS+CEAT+J55qC+tQzNgnV+eD9w9gALg22HAoTFAAqG9GezdNGhpi7kCCORKs9Eb4RAwHpfn8Pomp92tsCCXQuFWDDS1m2do2ay2VTsNxfKGOgOFwZiEyOs8pPO7TrJfV0gbdYPfle9Oq3LLiw/MVRSirXXhAt61cVyRtK50a/qjItRJ8Okol50ssLAr65mDH
 XFnyjEpL
 lg28Q+htK3ZdWzMfDZBqL0HoJXE22tVQijycz7iiQe/Qmt4YLgWDsmuiTiqbNsyUW4wR8lOYThSD/r4ZRDLG3beQw8U1nPcOvSpCWtQ5TkRhe6rQpSCRVWNhl+NeXStK58uFelZQJ3WfadsI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Tue, Aug 26, 2025 at 03:08:08PM +0200, David Hildenbrand wrote:
> On 26.08.25 15:03, Alexandru Elisei wrote:
> > Hi David,
> > 
> > On Tue, Aug 26, 2025 at 01:04:33PM +0200, David Hildenbrand wrote:
> > ..
> > > > Just so I can better understand the problem being fixed, I guess you can have
> > > > two consecutive pfns with non-consecutive associated struct page if you have two
> > > > adjacent memory sections spanning the same physical memory region, is that
> > > > correct?
> > > 
> > > Exactly. Essentially on SPARSEMEM without SPARSEMEM_VMEMMAP it is not
> > > guaranteed that
> > > 
> > > 	pfn_to_page(pfn + 1) == pfn_to_page(pfn) + 1
> > > 
> > > when we cross memory section boundaries.
> > > 
> > > It can be the case for early boot memory if we allocated consecutive areas
> > > from memblock when allocating the memmap (struct pages) per memory section,
> > > but it's not guaranteed.
> > 
> > Thank you for the explanation, but I'm a bit confused by the last paragraph. I
> > think what you're saying is that we can also have the reverse problem, where
> > consecutive struct page * represent non-consecutive pfns, because memmap
> > allocations happened to return consecutive virtual addresses, is that right?
> 
> Exactly, that's something we have to deal with elsewhere [1]. For this code,
> it's not a problem because we always allocate a contiguous PFN range.
> 
> > 
> > If that's correct, I don't think that's the case for CMA, which deals out
> > contiguous physical memory. Or were you just trying to explain the other side of
> > the problem, and I'm just overthinking it?
> 
> The latter :)

Ok, sorry for the noise then, and thank you for educating me.

Alex

