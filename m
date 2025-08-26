Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C646FCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F756B00A3; Tue, 26 Aug 2025 09:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2166D6B00B2; Tue, 26 Aug 2025 09:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153136B00B9; Tue, 26 Aug 2025 09:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 051936B00A3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:03:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D874C07EF
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:03:29 +0000 (UTC)
X-FDA: 83818924938.19.A83D99A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6ADC714000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:03:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756213407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1O/zM1zKzZOQIR19miejrCk4D8ib53PTjy+21WtrmDk=;
	b=n/VJ7VDOwOt7bZcY/FYhZgZh5YEsIRwtzEmh0Dq6T6BrE+zM8l//02mf5J4Tpgbny/C7DE
	BKQs6dGeqeXDyWh81RQRqWnKo2WxY844d8RbotjwCmsuPC0ZgqXaSubtdWc+19blbfaB+y
	eHXydPqDPFjHmiXGzFFi9BHyOypSAZQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756213408; a=rsa-sha256;
	cv=none;
	b=GI/zvCM9LPrGp/cbYp1wc5ejEdg9Qet1LzzGKDEW6BmlmGYgk3OmsA5JJ0OTmr/0okr05W
	5FAKcaHWF9cP9sQaVliDTOYbbIyGX6kGVd1cVnLl9oa2jNY/ZgJFnZSb1NHbRxy+WVq5AC
	8D9PRJ9EMOkptE/J0ggKYVRkNlbAhZk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 025E02C23;
	Tue, 26 Aug 2025 06:03:18 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5B423F63F;
	Tue, 26 Aug 2025 06:03:19 -0700 (PDT)
Date: Tue, 26 Aug 2025 14:03:16 +0100
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
Message-ID: <aK2wlGYvCaFQXzBm@raptor>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-22-david@redhat.com>
 <aK2QZnzS1ErHK5tP@raptor>
 <ad521f4f-47aa-4728-916f-3704bf01f770@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad521f4f-47aa-4728-916f-3704bf01f770@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6ADC714000D
X-Stat-Signature: 5y1j3fzqu6rrmauz37o1cnuthuunu7hz
X-HE-Tag: 1756213407-326840
X-HE-Meta: U2FsdGVkX1/ScHcAUQ9IygCPjmkEL92U/4q6s7PRVFLrjMBhV/T7mo2whx4opDxvvPVFPENxJIZNgv/MHw3fW9h40XyJRpEfzU/ZWM6GxBDIqUSYCtAMfOFkIH+8EgDhyFwSinMxzlGPrbb3dtNkLvdaXkZJ7BkHLDfTsZ8rWiXWui9Ifpksd79c2DuzdzwkihDQ4eOSdqvwY+aKsbqL8ehs+Vps08nQF9jOH/JoOlUdN7Nr+BY9iaQhsaN3H5y81ODY+FHp8ec9T+waJK/+qnEM7vMHbilAX5s30KcgV0+UECMofEmBIE6k82bvIXVWUYzenKlQLPYjSC/DPkuaouGGUt5VRjdvr+j1rKLcvUp+M8tPSQDrdmWBq0JQ+ZqS7XrtNO7IWIsOVlQJaa/+Y3FK6wTzdSUEg82Odtk89ECxNODcnoc7Nt5e/ItnRrF0So0njR+cVgTMjVBgeMOOZ0mIQozrcWfafpXiJ5HdAQMnxNrtt13tSQhXpFjzQrsmbjpperZtQqwXd6zTTZZlXfsaFkaZ/7mALWV0gywa/0F8+imA9VnF1T1fyMNt/NWpiSu3ZpivM6lh5LCEvIZ+VlFZUA2gKtykdTBa+A12JFGjHwVXqx7F4WcduqPGjmZw6YJz8mkW06fEiNP6SvBI6ONlUKdj5/Bb49OT6dJKh4suFdcsi9MBEVRd1KX6GA1oaFlj8J00JHjwYY1TmNIo6AJdRQcNOTRDrUjsxnJg4vCx/odFAUU1chQtBgMeb0atEnmG+naVFSloJeEbdPxJ2kbjjBWLm+gKK9ycKYuIqh/B02jjCSFaLorQbBtnKSyiMAO+qbcG18r6ShdQ2bhF22mZU90fwoGTVLYSllfnPwH+PNkgxICrCCDCKBYtuA/OjnHcR13Ms2ET9LJpdZ8AJ6M6jsoPK6+ZbmD0A3C/cH7d1c5UU09qvBzRO6z+s02qUc9ZYkzbcWFlbZZvlCR
 LC4kY1Q8
 ehZG6/CzJKY8TqZH7JUNjN9EtYfQyhgwebvz1JwBeRsqmquiGpEpBLmcJSUdeQjaVreqNVEZMTC/+58koz33J2b8zQKTBlOuLhGb9baB2OqoeK033GeLzFPf7cnhElatLYZ1SgqCIYkmxVOA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Tue, Aug 26, 2025 at 01:04:33PM +0200, David Hildenbrand wrote:
..
> > Just so I can better understand the problem being fixed, I guess you can have
> > two consecutive pfns with non-consecutive associated struct page if you have two
> > adjacent memory sections spanning the same physical memory region, is that
> > correct?
> 
> Exactly. Essentially on SPARSEMEM without SPARSEMEM_VMEMMAP it is not
> guaranteed that
> 
> 	pfn_to_page(pfn + 1) == pfn_to_page(pfn) + 1
> 
> when we cross memory section boundaries.
> 
> It can be the case for early boot memory if we allocated consecutive areas
> from memblock when allocating the memmap (struct pages) per memory section,
> but it's not guaranteed.

Thank you for the explanation, but I'm a bit confused by the last paragraph. I
think what you're saying is that we can also have the reverse problem, where
consecutive struct page * represent non-consecutive pfns, because memmap
allocations happened to return consecutive virtual addresses, is that right?

If that's correct, I don't think that's the case for CMA, which deals out
contiguous physical memory. Or were you just trying to explain the other side of
the problem, and I'm just overthinking it?

Thanks,
Alex

