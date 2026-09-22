Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A47C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 03:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3E46B00A1; Mon, 21 Sep 2026 23:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154B56B00A2; Mon, 21 Sep 2026 23:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C1A6B00A4; Mon, 21 Sep 2026 23:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D63006B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:17:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4E1B140354
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:17:53 +0000 (UTC)
X-FDA: 85239938826.18.CD9CAF3
Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9232A120004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:17:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OXZdkHQ5;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790047072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Bs+txa/+hD6I53HFnpYZQstiCBD5GmgZrclMSH+9R0=;
	b=oD44txIDbfCZWR4xFMzVZIUyI/EyK7rVYh5m9jsyAYuiFZphWYb5pxv2oIg+yN2TDd1jLh
	BSJE+gZpfzElQpNwmnKGWRxi9wMMaGepQ3Fjl/O4zMopDeoEZUAFKMzOM6MF/qXzpaOqFN
	Q6/H0hSUtkIQ+86Fduy3FTUhYITTuZ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790047072;
	b=vvBXodq+ykyopTuSG065zko5PCvN3Xy90KqiYlPWZmWME3YzfLXL1X1oIa9l08XtG2YWNb
	N51q8u/0ltLFo34+BY902/m4duH6KYfN3ZHkiftXsFmwGbnnstyFmg+8R3C9NJKeq2F1Iy
	Sl4IC62lBfJ2xHhDtVW1WtRHf6v/KAs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OXZdkHQ5;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n5rx4IX4GsBUDhc4Iyun+qiv1PJKF2Xxv28G7taH6Vk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790047070; v=1; x=1790651870;
 b=OXZdkHQ5qaXAc8/OoEikBWoNlnVFMkAHE8uQc0aWfSKRzsW5dR7OSoOIsyTDF1S9ghN2J3W4
 wOpnAEU2hdKDZCN6XJvy26vEwrP0suDl0ycExkXUeqAMApj3rHmAyPSBiS0wVvMPv/EjqjRIuII
 hUQVD8AR5oxKbvTfTiuVTL/w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 007cbe3f9b98d031;
	Tue, 22 Sep 2026 03:17:50 +0000
X-Mizu-Trace-ID: 007cbe3f9b98d031
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <arEsjy0QwLekLVbf@localhost.localdomain>
Date: Tue, 22 Sep 2026 11:17:27 +0800
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
Message-Id: <B7DD4587-81DD-4B82-934B-67B80A3A2D92@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <arEsjy0QwLekLVbf@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9232A120004
X-Stat-Signature: 8cewpbsp6siyuwtyh4cqmkxzqotkt5or
X-Rspam-User: 
X-HE-Tag: 1790047071-470646
X-HE-Meta: U2FsdGVkX18Ta8dLZO2H5l2nWzsFbw/+m2loM0nDtSzd0Iz+z4meTW3HDgX1EX/wxydLVANQerQYEmKG0K6lHDbDXxMjP80exB3DFai4tVeHv5AcfKjGip548AFlmmfK1rHo7hFwXWZ3ttN7JhlV7OqfZIAgg5qLL3pPoZRaWwQBQNAuY2tKAug2kMrbEuH5Qc79HaHjw720yuH1E5ejWLK1bctwGdiZYh5soutzCuMY7V/+jvzkPKouierR234oSy3Vi6bss2EbV21SNuMzJaS40GBiprf3Nfd+LhsySIIUM7I1dnD5iY7dJCWuI0RkJeMnfdegRQJ0VPt4TAGgqDZfeTgGWrkSOge5hXjg6gn9jaM7jbFjW1xnNfzCUjF43/r8PbnWC81GFtFRuCE8Rm4aEAXxWhsei6UHf0qOv/PfHpFQidnTEq+GmXB/UPNJVtuer/+L6PUweaXy8FfjMrKn+2AqbDOUXYFOf2p2AJf6VZaf7quIXfuyUrv7Nli2leFIgcXNoKNoJaGOODGbP7n8UIpeLmCQBVRLS8YIncOQ41KPprESnvBXrKgqK6ya0vTWKDAw84CtbHG5bN0zYrwzWqx9FgpnD7H7uzs8DbaRdK663qjZxCRBRWses9obUo+4AC6ok8JkKPDtJRvo1wlA00Fcg+9ysf2v467E5Tz7csHa7XNQ84DGnybP9+8D+50HiE+KN7qci9ySIYLHpNZ6QgYYbg7wq6wFHkdzE2g4CT+MOga0Rxk0k3M4amko1n1TQoP76wo9jajTpVXqWipqPUhPeIhsPmbJzkzE9PugBk28L9MdK8nwK+rYG4RhAQUQaJctgOWW+AM5UyHwDc75IMzGF3qK6/MKSlOHS01iS4lmH6KlVFV6U0uUZMbXGZ6DO2fmL5akntQ9HM3XmUc4Zgjgstx44gcqBvqNy7R3lPGPLcGdEmZ74wRaDarojfsWlUawaXZ6E6KFuXB
 d8uRcxKv
 LTUdk6lfQKYSMimI7Pmkn9ymlp203+tSV41r1k8LzHuT/xHYqOECrhanIJKqsnKDDSS83gRW/e8zS/O8XVEXUkrq28yiRFAdPz1eW1IVHhxH7tZyrCfsO5qag2rkUlGV1j5cxQP/38vTL7rjsG/agJ7rpq6XBSWKMpe2UCrAqmm5spze1hOKCJ8yV0x5tdil6olG4nIdr3gSljLWil7t8mXlwPsH+494MX2UgALTIBNYFIxpWhVUKafwerxzuQBbm/HfWec9J1QFI4fNwp8/3ne3KBkEzN31mS1Ip
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 21, 2026, at 21:09, Oscar Salvador (SUSE) =
<osalvador@kernel.org> wrote:
>=20
> On Thu, Sep 03, 2026 at 08:21:26PM +0800, Muchun Song wrote:
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
> ... =20
>> +static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap =
*pgmap, int nid)
>> +{
>> + 	const struct range *range =3D &pgmap->range;
>> +
>> + 	if (!is_power_of_2(sizeof(struct page)) ||
>> + 	    !IS_ENABLED(CONFIG_ARCH_SUPPORTS_VMEMMAP_REMAP) ||
>> + 	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
>> + 		return 0;
>> +
>> + 	if (pgmap->nr_range !=3D 1 ||
>> + 	    !IS_ALIGNED(range->start | range_len(range), =
MIN_MEMORY_BLOCK_SIZE))
>> + 		return 0;
>> +
>> + 	pgmap->vmemmap_shared_page =3D alloc_pages_node(nid, GFP_KERNEL, =
0);
>> +
>> + 	return pgmap->vmemmap_shared_page ? 0 : -ENOMEM;
>=20
> I yet have to look into this with more detail, but this caught my eye.
> Should not this be a best-efford mode optimization? So, if we were
> unable to allocate the page, could not we treat this as a normal =
"cannot
> be optimized, follow by-default procedure" ?
>=20
>=20

My thinking is that if we fail to allocate memory here, the subsequent
vmemmap allocation will need way more memory than just this one page.
So it's very likely to fail anyway.

Thanks,
Muchun

>=20
> --=20
> Oscar Salvador
> SUSE Labs



