Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6640CC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7208F6B00D1; Mon, 21 Sep 2026 05:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7236B00E3; Mon, 21 Sep 2026 05:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6110C6B00E5; Mon, 21 Sep 2026 05:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2696B00D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:34:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F9C4405EF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:34:21 +0000 (UTC)
X-FDA: 85237258722.29.779ED05
Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C1291C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:34:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c6Os8atR;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5/uR8d5RaXBk4YUvPnR8zRbWXhMm8lDgQeegLp3s0I=;
	b=bcJAfuw0a538ooaclOa5Btq5nfopyVllRjiyuGtBPCLbV5yBMdyCYr8XSrgBT2gudkrZBS
	78ZhsiqNwh3Y0tDnU7JivIKzR295I1Njy7soTJBcMGIGYRFKyyv8cLc4V0Pdnk3VwbwtLF
	S97M86Szoou+w6+riHRNb6mMHXhWbvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789983259;
	b=lkMKF8N2bptkNJuMWb2uYthOLFZAzVHOS/57nJ6Rr9sTI3gFCaYgpYYt8cCyzvzOVdmB2O
	Om6uWjODINblUJ/DlX5rke5oQrh+QRtdAmXiT6OBnQ09L89OHbB8BkrRzcvUSN+uEVHYPq
	LEMw0GiXn4QTMGVC5CEaQ27x75hyNVw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c6Os8atR;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=W/5SMKE/9tmAzOhRzQxPsUoau/+8Db+SQdb2yaLqIhM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789983258; v=1; x=1790588058;
 b=c6Os8atRqZ5IOtBMgSskrLlStpXT8MVK8CqJ7Yv63HAJX/WHryA+40KMliTNtWsf6xWdQGvj
 wmjWIOE1G63vgzDq/RUknmhoHWmNqew2W3aTnFWP+95SotIa2H3tfPmfYMRp9zI0c5zl/k1LgwU
 Mjus/yuzkYpOcv/lJtVhAIsA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a40a32e2570dfc55;
	Mon, 21 Sep 2026 09:34:18 +0000
X-Mizu-Trace-ID: a40a32e2570dfc55
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <4bc1f4de-40ad-46f0-8d37-4c4e0cad0ad6@amd.com>
Date: Mon, 21 Sep 2026 17:33:56 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Ira Weiny <iweiny@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8EA6782C-7A3D-411F-91CD-031AB97CD024@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <4bc1f4de-40ad-46f0-8d37-4c4e0cad0ad6@amd.com>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hnm95tz68qmcd1yhso5adg4qjqrbb461
X-Rspamd-Queue-Id: 6C1291C0002
X-HE-Tag: 1789983259-723179
X-HE-Meta: U2FsdGVkX18nv1vE2IkFfOtGUuIHmDeKRqlhpX0g1dWVLZ2+O0N+vwztwJfItR/avBMbjuhSz8Y3/GAoDsOMj5y4zwhjFHyX7lx/DNRQoM/6006EPFiXr4WY+SFsm0dQz5Pe2KZoL7BrivG/qIQzG0XnRR9tRU1rvzLnkpMgAxox1HK744bMe/RHJ1yIGXnau+r0aVIy76nP7RLAb6K4DTfCrjmZPS06hm2JTMBxgCTRsbAMboRWaFTyRGRe78XIgvIoNE1rSkIKSnrqR0iXxeuwxiJz8tN6IJ+7fb0jx57sYru+9hsOaLZaN8cJiMYzfPEGwnwUQSKx7wvfrPq5Po0gmaI8ekYUXSzsn274QhNkcHBL0p2+G2L3wBetQWJ5kn5m3SeTlQ30yilmsM6aBk7ViKRVVhvBnzbbTDpGGkdOWcZSg4272DglXaj9qeo03yjou5UTJ+gXqvBfj6rX3HxVTq3MEp5ORnBb/xQjCcO0tbLLOu+Q8n+FaIVOsEqRLPcJ8rlwE3jlYzjP6WPfBhxejCDLyCd34ZyyACW08R+vBcTXuTBzuSSOQffQAeloKgbGy+SDmCajBpcbcqK4rMv7X+jicPuW7ENAbuBtiPr98L87Uhu8L1h6nPZEoQzEw6FNqy/IdwerUfbR0Ag7vO2EmrmGuEqu4MUlKd1r2uAk3UE4b0IXpqf8hg6Eb4RP3l/zlVGUEp27NVxjdWCJgQT4xavH9cNoEoEdXR67h0/8mzUgUAsX6NGIh5EPHTp9P0DPTaCUU38wlnW5g9IQ/ePslb3BGfZCXncy2Sefm34uvi/4b5WTxfMurFqq+5Q1AXMsDSa4H2ka8DB5Sbv1uVmGdiRxuhdb7iJFWhK4808JA+zkxg+gIuCG3jckshwKiyyqUn5mZR81oI0kvluGUiOJecn/aGpBYN+DYW57mEuukPrV/6LjzvYf3YohV6uAjJE1ULs8n791C5wqz2x
 GW6ZHI4e
 U7e5SxQN9JOrNvxJxeaNlqfENLCMaNGhebst1vlH6gZZsA48sdv5m3sE9ovCDU+nBh0tXer043/6SLYR6t5vRjvG9xfanGL+eDwmrgznqVUNrJmYZHlTFkRK9CD0qqEHdSBUwq2d/FiE+3xQHRb/dxNFmgs6iwMpyhssYWsLULCYuivzjVOAhTV+qL9DtW9OZ+eGRSRpPpisq33o4CLK6xfyBCjdHpoB1Piim6lxX2n3MS9nLpRD9x8L9NSLk6IExHbYYWuw+lln4BJCrmqk/hWzAmS79H6/eNmeZ7pXmBS0da1MrhNhEnpiGKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 21, 2026, at 14:42, Gupta, Pankaj <pankaj.gupta@amd.com> wrote:
>=20
>>=20
>> FS-DAX registers persistent-memory ranges as ZONE_DEVICE memory, and =
the
>> kernel normally allocates and initializes vmemmap storage for every
>> advertised PFN up front. Sparse pmem images and workloads that only =
use the
>> DAX direct-access path may never need writable per-PFN state for most =
of
>> that range, but still pay the memory and initialization cost.
>>=20
>> Add an opt-in dev_pagemap mode that populates FS-DAX vmemmap PTEs =
from a
>> shared read-only metadata page. The shared page is initialized with =
the
>> common ZONE_DEVICE and dev_pagemap state, so every PFN still has a =
valid
>> struct page representation while private metadata allocation is =
deferred.
>>=20
>> This relies on sizeof(struct page) being a power of two, so each =
vmemmap
>> page contains a naturally aligned and repeatable set of struct page =
slots.
>> It also requires architecture support for runtime vmemmap remapping,
>> because shared mappings must be replaced with private writable pages =
before
>> a PFN can enter userspace mappings.
>>=20
>> The initial implementation is deliberately limited to a single
>> memory-block-aligned range. That is not a fundamental requirement, =
but keeps
>> the registration and teardown paths simple; support for multiple =
ranges or
>> less strict alignment can be added later.
>>=20
>> Provide vmemmap_materialize_page() to replace shared mappings in the
>> requested metadata range with private writable copies. A later patch =
will
>> call it from the FS-DAX fault path.
>>=20
>> No caller enables the mode yet.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  include/linux/memremap.h | 11 ++++++-
>>  mm/memremap.c            | 38 ++++++++++++++++++++++--
>>  mm/mm_init.c             | 11 +++++++
>>  mm/sparse-vmemmap.c      | 64 =
+++++++++++++++++++++++++++++++++++++---
>>  4 files changed, 116 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>> index e3c2ccf872a8..21c9b6aeef67 100644
>> --- a/include/linux/memremap.h
>> +++ b/include/linux/memremap.h
>> @@ -9,6 +9,7 @@
>>    struct resource;
>>  struct device;
>> +struct page;
>>    /**
>>   * struct vmem_altmap - pre-allocated storage for vmemmap_populate
>> @@ -108,7 +109,8 @@ struct dev_pagemap_ops {
>>   	void (*folio_split)(struct folio *head, struct folio *tail);
>>  };
>>  -#define PGMAP_ALTMAP_VALID (1 << 0)
>> +#define PGMAP_ALTMAP_VALID BIT(0)
>> +#define PGMAP_VMEMMAP_OPTIMIZATION BIT(1)
>=20
> I liked the overall idea.
>=20
> Minor naming suggestion I have:
>=20
> 'PGMAP_VMEMMAP_OPTIMIZATION' feel too generic to me.
>=20
> Maybe something on the lines to reflect the actual optimization:
>=20
> |PGMAP_SHARED_VMEMMAP or PGMAP_VMEMMAP_ON_DEMAND or some_other_name?|

Maybe PGMAP_VMEMMAP_SHARED? It describes the shared vmemmap backing
more precisely. I prefer SHARED over ON_DEMAND.

If you are OK with this, I will keep it for the next version.

Thanks,
Muchun


