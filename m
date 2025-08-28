Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52406CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8588E000C; Thu, 28 Aug 2025 06:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988C98E0001; Thu, 28 Aug 2025 06:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F028E000C; Thu, 28 Aug 2025 06:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 77FC48E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:43:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2201BCE94
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:43:49 +0000 (UTC)
X-FDA: 83825830578.30.34140FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3745E1C000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:43:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756377828; a=rsa-sha256;
	cv=none;
	b=0CL3laLqcIvHqYF5A76el1IeTPhkWHDV1Id6asp+WMD6VpWOXpQAAFVx85CtUCVY3ZxbD4
	DIzkJACPR+jl4aXqgec4lIGH+KkGbFCFP6sCl4Msmr5IW42tokHq7avpVSVvPFlCrGzxsP
	lGQXONmdW6IQi3l9KaxthJskqNMDRMk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756377828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OsWKyS8lqER0Tz1n2hSl101cY0gnWMD3HdL+I/Wazi8=;
	b=pA3aA3mp26b77MCkY2GuNe9SFyqUneJeSqHmCwDnvfTTtzZKQy/woH6IYKqZ+7GTSVrCqL
	tPFXCsORAPo9y46qjumhHAhhJZhezlRhyIcuq1GsKmTb1xUPGAKZqSI6AYlU6+E6UOhrDk
	CYh062cXlaWoOaCjNiahkZd9cyptlDU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B18064361B;
	Thu, 28 Aug 2025 10:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7A7C4CEEB;
	Thu, 28 Aug 2025 10:43:39 +0000 (UTC)
Date: Thu, 28 Aug 2025 11:43:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 02/36] arm64: Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <aLAy2GJ9YuNgvxCd@arm.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-3-david@redhat.com>
X-Rspamd-Queue-Id: 3745E1C000B
X-Stat-Signature: udyjaenmcny5ea1777ron1n9mrzrwrcn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756377827-177146
X-HE-Meta: U2FsdGVkX1+k8nOt4O0WyEMCsBteB8q5CFvNpigA8qBYdCPSJvYGn6kOjtA7ncXpCxbe4cQEDPaVJr329Mot7FhkWh4FxzR7GFg/I35SSevF0m//jXmOA7BfCgsjhO7XQHogZ9ixftmWzloGn0PRuSoi2sV7f+aVCTtf1tSltGAs20WdfviN5vFNteYyATsWPViO7tNhoSCC0slT2IXe8K6ypdOK3L7Qx/IurAfuUlbTZcWrejZGDfnj99jIxY4lqxIttVHzAR7lFwvkD8qYNF3uvBmDEK01QhTUxxNR8esfUWCdTeZPrH+kaIL4InStjc3nwAKcR9RlL6aYzxtT77XCjfxlX2oZB4W4DYm/AyyKpVQ9qAMt7iEg6gynpeYA7+oOnrKCjJOZqTmTaD979FQ3TlQXCd+2sRrva9Ymr1w6/wQyLSLE4B5W07ec/9Kmw1GEYnp6qoO2bU0RUeWVE2zu+lOK0XWGqnzXNfXFhBMSMXgF3Crp5YMngZ1tqqbUcyEh9bFex2tkcUnrokjg8YQglRlkEGsmCpesdxVQbevTua5XeJE4BBKcboxHkrhUVxDNCZJDT3vmf5eZUKNnNJtqxaoBlIOw8/HXg+q2/i6hqRREN5dPUj/gVEtdPDf0Ey94tnttelHQhatkeSGlZRd/P5ZlIsGm0ZXRkLcmA71YYSQA1idC4U2cVb7NXQgPH26wLHbKS+m+I/cAGzZdWJeKVUmbCmeRysmJHthdNn+QAgdGq5TElRuTazaOmh1YAky6QzSzr3+uxvWp7qjOLF98eDD1/9S7TcehG1/0qvStCFCBFe0h5nAZAUESoYVcEwnjwCFSUyYbCv7FKBMpIIKRLd7SX80Shw+slSfgyEm0E7nRxS2XyPikBJnQL4xtqYKQlfiqODApIokb1n3XndwnJYKApMGHjjOlnmbf/b2gysgwMUkhZM7zt0upO6LS29HI70isRag3ZExrxey
 L4AKRHmz
 SQ5FyqvO5VkEJUipN2efFhrpntW7e6R2w4JEkQzSX+8PVm95i60I9f2iYics2l07iYI4LI5TyM99+L9RfBCerxr+bPjZUAzlh4upT5aRwNzPib6hUiC/vpPWdIWhqEvgRGnH6ldS5hYW1M5TdBoCYHrKAgOT3HDudYgyYAZBb/ee5ZemEggslWqr1EB1/N0SntwTAYGGObAQoyPxguseBfh5PehNZakehZPCey3VD2YdMTzeYCsa0LuIKzIgrG2pGOCZQELkTfanNbry1hosHxnWsCD+xgqD70ALxkZirm/fCKxBGqI1gZzYO5CTA1fJdN6fuJjmNzUlo2G4MWOayEieGWN41Y5PSOJr34UpZfXC96Y+QsKY3NxHI+2K4IGSrE7glrnNt7wZI79QDROiOBoJkoFwhafhaN9FKqC9qWp6YIwZ7zaBJju+m9F92jOK/qvtor/OeHNyHQaPjUuyQM2BrZzOEKLvLp089kSvqJu369OaQoiCNz+OXtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:06AM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

