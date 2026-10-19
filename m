Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A66CCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7926B014F; Mon, 19 Oct 2026 02:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167D16B0150; Mon, 19 Oct 2026 02:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E5A6B0151; Mon, 19 Oct 2026 02:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDB266B014F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:50:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73B8B120640
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:50:24 +0000 (UTC)
X-FDA: 85338451968.22.1D5D8E8
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C0E71C0005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:50:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ge8c+ySl;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792392622;
	b=MPAy99uwmkQaQ/i21Sazsdl1B2OoOI6F/bdQhItPwpj3CRXytJFnJy3P+acdTW/iBIjhHB
	v8D3Cw2+YYf76x22WbaWesacK+FncbFq6WPLYVSSP/JpbIYuhw6nlQFNNMsQiFrGsubLq6
	hWkHeT4YelIBdv8LBz66e3QQVHphVSg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ge8c+ySl;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792392622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXxZX9qAYvAB0RkdPkm6MthSehAVG+uWV00/KzloPlI=;
	b=oYRp1vvPo8N74jexm6FSkFEr3NL3FwsP2UbQhRznDTKFo3Cidf2bXhqzLC42Pto4hsbgPV
	W4TUem+ZoVNspsFgssUwGsenFDklX3wc8GgL6QYHAKOBtGaoY3DUwuH1/Liqni+2x9xGqU
	Bvs2i5N1eZSE5QztCbNDiJZDIzUn9YM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5gBGyOmGG2XT0r7pd95Im9pzr7GBNEl4HR2v/rxZFt8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792392619; v=1; x=1792997419;
 b=ge8c+ySl/QZdIM8YLPoSa6N7sPXLc72uzbQ5n6xzPL7yourDoGb7mW/NyIsUdCBc2PrFQpQ/
 VrMnT2XmQ1JD+V6t+TngNTjkKoOCumrX5sXjEtXCjAq7ciQTCE47tGlyjJnPToc3NWhdj2qjXa6
 P5HfioMhnwBb8Xz2xeMyrI7w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 99e215486e67a95b;
	Mon, 19 Oct 2026 06:50:17 +0000
X-Mizu-Trace-ID: 99e215486e67a95b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <cover.1792136742.git.zhengqi.arch@bytedance.com>
Date: Mon, 19 Oct 2026 14:50:00 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C0E71C0005
X-Stat-Signature: hf834zj76x4n93difa9h7543cuowpdjp
X-HE-Tag: 1792392621-449331
X-HE-Meta: U2FsdGVkX198uREfSEDwn1ujqTTiaWDzEdXZ0GtPbTF2HKVmAowSTPsUXiOeI2bZcqQUzjIIAs1UeLvnIeW1FQffhxdemOGfZssEbd8vKbkUxk0PDyBuu8F8+RblRD6x/9PK4/nXZplgm1ZNF0+q1wuglh/zXZYijXxFqYb2mIF/IwTef8jxRsyNDkQh+/3pQBr2mMAx/TLsYfXe489x+lOARM92Ql01B9l7wIuocM04qpQ/8ZUg8USLNFLgZ3XOgu8pz8MSmH3OKPNT5mBAlJoM/X/d0NsnyFZ8fggzh8q6KZUG8x3cI02UxsjyJnFgSCvStC8Lt8b2MKsa8UJed3a6yDpG22ckdFqObW3MJW6FBNeOn8vMKp8VIoN9cNxQhUAI7B7KQS2pHtL3kMmmBvfqokvan1Cs2wD7yU9pXhLNpEabJUWQoZQZJOobHWggQZ73sW2MJrdeCfZ6kld3p7Iq6GqtAARIVdM4cBVhYxt/PDykPf1WGl4pogCV9ga7LFhnoLd3olR1caz2jnGy903l6yDlC//T3Pp3dn+Sif1Dy7adZuEFG+DTrnFFk6nOoyY5hAi24I3W/QaRg+dqg0BI5lFJPg6dYRUbxlO0cLSLG+5MkJ1QdDwnpgfm2O87DHmsSw4A2ykoGUea+QBUcTfHGbto37ME7hesmDyqgZX6BxGeOYUSfbL72RtSd4MUQhxqGn9+ApkiaqrtmC1TR8OpasNBX0FWsxskl0BmAr3eLO6qiKyXLWTVksZQDeOqtx5IZelQoz7D4ZohPAYxjB8OZXH5HILOTQMDqWmDAUYti8pcih90UKcRev/BARUHkHf0od0iKVDIg/ucVrXhB2oeBKX10YZBn3SlOVy2djwmRN5veHmXSL+M5FpED8Hxr3h8cwy401UlzlKnaMpeQCQ8tAmXQ1vRB/LI7rwmhBMQEcRSjZuu1h8KdR2tS4/8tX5jA0MD9C9s3Ei3bd0
 pgYTPuLn
 lebNJwQ9L6vHRYgXmWpZ4KS7J4/wosHEtMTEOdtFs06fdhrkiPC2MG3XkWu2RI4SLZVwF038Ya8LOU8chxnBa0pCJ2lnYNdVXsPhDipZpOTOZ+vI4SX+MVp0EAQHPVbIHRGjOl2sNFkPgy82Z9w9+87SeYrdFrRCRKJ6ROlJfgvaXxNOrvATmFG1DZCb0PPgbTdRvI9oKY24JF9WRHLROrgRzYeFNSU4L/o7MfG4uMA+L+zuXtUJz1UB97gnwnrN+Dm2JFqJTDERHS+BY7hj/5t1mNV+PVM4DLnjk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 18:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> Hi all,
>=20
> Allocating PMD-sized HugeTLB pages at runtime can become slow or fail
> as physical memory becomes fragmented. Reserving HugeTLB pages at boot
> avoids this problem, but keeps unused pages unavailable to ordinary
> allocations.
>=20
> Live upgrades are one example: they need additional HugeTLB pages only
> during the upgrade. HugeTLB already supports CMA for gigantic pages,
> but reserving a CMA pool for 1 GiB pages can fail when physical KASLR
> and other early reservations leave too few suitable 1 GiB-aligned
> ranges. At runtime, 1 GiB allocations can also fail when pages cannot
> be migrated out of a suitable contiguous range.

Yes, that's our use case at ByteDance. Allocating a 1GB HugeTLB page =
from
the CMA pool is more prone to failure than allocating a 2MB one. To =
improve
the probability of successful allocation, we typically configure the CMA
size to be larger than our actual requirement, keeping a certain margin =
to
handle cases where temporary kernel operations (such as DMA) prevent =
successful
migration. For 1G HugeTLB pages, since the margin must be an integer =
multiple
of 1G, the extra memory configured as headroom is also relatively large,
making it less flexible than 2M pages.

>=20
> Extend CMA support to PMD-sized pages so their backing memory can be
> reserved at boot while remaining usable for movable allocations until
> needed. This relaxes the reservation alignment requirement and reduces
> the contiguous range required per allocation.
>=20
> The series adds an optional @<page-size> suffix to hugetlb_cma and a
> separate PMD-sized pool. For example, on x86-64:
>=20
> hugetlb_cma=3D4G hugetlb_cma=3D1G@2M

Different sizes of gigantic pages already share a single HugeTLB CMA =
pool.
Given that, why not let 2M pages also reuse this same pool? Would that =
make
the overall code implementation simpler? And if it does make things =
simpler,
should we go ahead and do it first?

Thanks,
Muchun

>=20
> This reserves 4G for the existing gigantic-page pool and 1G for the
> PMD-sized pool. Existing unsuffixed parameters and gigantic-page pool
> sharing are preserved. The new size follows the architecture's PMD
> size rather than being fixed at 2M.
>=20
> The preparatory patches introduce per-pool state and prevent recursive
> CMA allocation during migration before enabling PMD-sized allocation.
>=20
> Thanks,
> Qi
>=20
> Qi Zheng (5):
>  mm: hugetlb: add explicit page size to hugetlb_cma
>  mm: hugetlb: group CMA pool and reservation state
>  mm: hugetlb: track CMA reservations by page order
>  mm: hugetlb: avoid recursive CMA allocation during migration
>  mm: hugetlb: enable CMA allocation for PMD-sized pages
>=20
> .../admin-guide/kernel-parameters.txt         |  39 ++-
> include/linux/hugetlb.h                       |   4 +-
> mm/hugetlb.c                                  |  80 +++--
> mm/hugetlb_cma.c                              | 328 ++++++++++++------
> mm/hugetlb_cma.h                              |  11 +-
> mm/mempolicy.c                                |   2 +-
> mm/migrate.c                                  |   3 +-
> 7 files changed, 306 insertions(+), 161 deletions(-)
>=20
>=20
> base-commit: b810335a0699d1810683796b0e3ffe8827ddfe6c
> --=20
> 2.54.0
>=20


