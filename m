Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FE7CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A746B0088; Thu,  1 Oct 2026 21:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4A26B008A; Thu,  1 Oct 2026 21:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE606B008C; Thu,  1 Oct 2026 21:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFB396B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:50:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 373DFA74BE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:50:00 +0000 (UTC)
X-FDA: 85276005360.16.C2F16DA
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1D3DE4000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:49:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ohcTV+WL;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790905798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhZuf98Z81J4Mqd1VfwP+qbvPYzQzUUAYk4ntEuxCgA=;
	b=1kFfnMNdi9t6pYeZbqu0E6qjc4JkLERj7WmEpwARTPVCRAS3ld+aJmbEgq9V1d6s2A7gA0
	nxVgL2vsSHpnUsOcvTJsI0JzuGMsAIPaLp6RK5Ha+z2eSVZ6L2V77yYB2nis1sLjeozfFm
	n8Prw0QP2bwKfIN0h2uaNGo70PEz3/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790905798;
	b=h+LgpDoIxzACw9CN9Ch3as6MJlQAmUqSWW1xZ1FB1hGZ8UN9f8D4d7uldfUgjPjyI26oP7
	pJrE2Tyi+B/qnAY2rTj5XUCugb4p5UaAsJr0eX82kF0XHkqmhGSJ0CqdlTeSmU8ID7RI65
	rvL57Zoo4FZgS4XDClkxSzIRLn6yJuA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ohcTV+WL;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=O/F6AKy+1TPXxN7FZeSSixd6YDpdthmqRGsFYibhu3U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790905794; v=1; x=1791510594;
 b=ohcTV+WLBQIjClcA1S1hNHO1DQXU8X2joFAGsI1ThoyMAN+PVq5OqpomUoURl0QZZTMDOsg8
 rUTsUjr8j6+/QF/c69xneTs28BVt9aj99XKSrbX2cQn4X8gxKFZI157OdULq5kABQEEY5+ijQ1g
 unZwtNPkMlkqFp8pYbm9JY2o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7473f29920ffea9f;
	Fri, 02 Oct 2026 01:49:54 +0000
X-Mizu-Trace-ID: 7473f29920ffea9f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ar5xbQsUpSQZg0wO@kernel.org>
Date: Fri, 2 Oct 2026 09:48:42 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1D3DE4000B
X-Stat-Signature: yor6h7wtiexmq6j3marst81mzuwrxeyo
X-Rspam-User: 
X-HE-Tag: 1790905797-89616
X-HE-Meta: U2FsdGVkX19Vf0fdsEp3YHoksktKYhP9Q1P1j0JZnQcUwgZ2+2kkr7aMMMr9sxap1niPfRIepA6RhKW+pL/nDbcuUcRRzqkMSAaJwoFUfWh3VeQq5loW2vkC0bpHMKUFU2U2mxeGJcoTXvbogCopmKZouJ7GiGXed6U3K+o+AAy5UHjd7BTdGQe8yS4+fWTdNjoLFv9PfrhE/yIXZ2uimhaRvExkF5bC3my+gyDTIJrMk88oUvyXqXsCkaEsYq+yEyEFBT3BfHeGkEDRrBCvcXAVrLsFOyKKdQC9Gi7XRmTBLk4UMSvdpoAevWv7JXnuXvKLKUAd74rMe0UcnjZ28Ud2K+Se2V9McG+RWUCT48YhdWK7TeVX5T3VXpMJj2U+s5fagMbA3CdGre3YwcIue+j5847iWpH601zKrfOsTb3f66B+dn3KCN6xjUpYz+WFdNue/Ta4mFLaOby7aprNpQlnkgQcVoSAdC0+SKDP8LMQBwCu0M2oJZcUoIc9nhdvPOqa8HZP9ilvlQNUO3CLXbC9EDUP5mncSerZvYDT0YjSsCn8Lgse2dCjXYu0CAwGwIOGVcOd4sBsvOgoyN83KLaMlAAE7SQhJQihDiqlLZWuOATBCmjyoqYXqYEp4fRUG5pnXn3sES2Xmp3os0ze+bJKQID4ZuGVnhmrI3rSnFkEiAY/anlPXNYsRlA1v/9pPy3kwctfgZ+++4OoqdsAlBMAIcI8oQfSYW9gMXxaRUafuHZ1KpbpYjnMQ85UrQLV/JZN0EcHXp25Cce7m9aOnsBnjCqxL6PTIXzFVW7/VXmBcfHbZfBqjAIPLYfhEuzP4Kq9ByBpC/hNjcHifbiGteP3iMPO6hLLLRbzkkpWR57Oem5D3m9knWFeBHrSGkdkf85DHBSafKq9vZXjyDIGdi8viLt3HvX6pS9llSHsApSlwB1lcHgc846P9j3plU/ybrndZUUzfTL6p6UfZHY
 COwFCGTF
 c7w6/cVzhjF2QWVUoc+27v2Gftmo4hGya+TiG0apGBUsKaXXilVsdVq0xjApQCohG6OgCwgYyvtrAasW8/D7Kd41cMoFI4wyolYOX9URyTFQeec3+VDUfpnrce3e4VQHBeDTUNDRSHhrWs2nBULm6PMW0i4iItjqUZFnd57SjXn8FzzdFuv6VFDEDYUo3E82rCx3Y7flOUjylO5Rgq2sYiKLQQX6kuJ2BBemLeq6+oF9h16Vn7909q3GkGpwoQ/W1wVch40JnYrGCVsUeKsEw/bMQ31QrLyCw4nN4WQ0SN5cYMtm6DM/MFmNYfZ0uFDqsOH2hCcgOw764/cpueAz+AkJocRwK19kv3m4x4k6fk9zWrP3w7UMLmp04LTHPPZ70cT93IDVH5FbQ60GBCu+PDCpuqk2mjdF6bLQbz0jTBM0MgvUbq75nomaTKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 1, 2026, at 22:42, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,

Hi,

>=20
> On Tue, Sep 29, 2026 at 01:32:31PM +0800, Muchun Song wrote:
>> For vmemmap-optimized sections, tail struct pages may be backed by
>> shared vmemmap pages. Those shared pages must carry the same page =
zone
>> ID as the struct pages initialized for the section.
>>=20
>> Warn in __init_single_page() if the shared tail page has a different
>> page_zone_id(), which would indicate inconsistent initialization.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v3:
>> - Collect Acked-by from Qi Zheng
>>=20
>> v2:
>> - New patch.
>> ---
>> mm/mm_init.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 1650d6bc1211..bd02e8d06965 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page =
*page, unsigned long pfn,
>> if (!is_highmem_idx(zone))
>> 	set_page_address(page, __va(pfn << PAGE_SHIFT));
>> #endif
>> + 	=
VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pf=
n)) &&
>> + 			page_zone_id(page + =
VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=3D
>> + 			page_zone_id(page));
>=20
> Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a tad =
later
> than page so it'll have stale data in the page->flags, won't it?

Lance is right. The shared tail struct pages are already initialized by
vmemmap_shared_tail_page() during vmemmap population, so they're not =
stale.
The head 64 struct pages are initialized later =E2=80=94 right here, =
after vmemmap
population.

Thanks,
Muchun

>=20
>> }
>>=20
>> #ifdef CONFIG_NUMA
>> --=20
>> 2.54.0
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



