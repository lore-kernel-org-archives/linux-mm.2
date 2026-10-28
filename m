Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C01606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PiZ+2Gl5
Received: by kanga.kvack.org (Postfix)
	id A6FB76B05B3; Wed, 28 Oct 2026 07:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20BD6B05B5; Wed, 28 Oct 2026 07:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937196B05B6; Wed, 28 Oct 2026 07:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1116B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:41:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB87280A56
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:41:01 +0000 (UTC)
X-FDA: 85371843522.09.5827E48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 44A20180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:41:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PiZ+2Gl5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jlnfz7M1ITZw2qIEVKqbY+WjiMkAWf1Tu97ZUZ93IN0=;
	b=Yrd32I6ifwTf0frrHqaw8k2WCoXKPpixpZDWNJlbgZ6ysy9t3Sr0xHT7XCD0ext3MinpGa
	u/CWK0z05nuo3hvOkReSi7U1KaHS8WwJNSkQISqcjM7hQ2dz25cPDWB+0JOLrmncVZ7XPy
	opsB41BN24ig2azIs7cTPoDtIXCwQzc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PiZ+2Gl5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187660;
	b=KPeNYPLYCLwWpl1oPiG6YL6T0UmZ4xnzU9PJDfSyNkgyJrwbtvIomx2UaReW7byXV0ZMzN
	tKwQNglvMapDu61Q08eLBWeTdyqDkzQ3+8rpNmw3SMIKwRP/pEOuMOfxv/OPIHHtkXu0bt
	IevX4DbVyqV08yhVvK+lusY7xxQES7Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6372942D52;
	Wed, 28 Oct 2026 11:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41CA1F01825;
	Wed, 28 Oct 2026 11:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793187659;
	bh=Jlnfz7M1ITZw2qIEVKqbY+WjiMkAWf1Tu97ZUZ93IN0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=PiZ+2Gl5kc0jJSeKMLoj7fOmlVIOFgswoanYFqn1DWdsQBEuhQPix9JVy9oWukGPG
	 +F4YsgXNS1WGjwV30hoP8na9F/N7Eb7122WwInn552HizyxxW3YaCESCfroMU6yjAm
	 VSLYDm5acEbC8X+0g/aR2w/YcyxdJoeMZDvuNVvBD2N8xDX/JIOe5gr86tQJIXfRoq
	 39Z0YQ1Uj9IsiFhECBTs0uTCctxqUM5+Y5krqY7Am0KOxTRvkUfV1a6g8jHytioWqL
	 s93d076CkgIdrXOUk2WhEjj/95/4ACkRiIc76P4JQh7Skxr0Cekil6YVf24aF8v9MO
	 VTNrBK9m2sErA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@kernel.org>,  Qi Zheng <qi.zheng@linux.dev>,
  Shakeel Butt <shakeel.butt@linux.dev>,  Lorenzo Stoakes <ljs@kernel.org>,
  Kairui Song <kasong@tencent.com>,  Barry Song <baohua@kernel.org>,  Axel
 Rasmussen <axelrasmussen@google.com>,  Yuanchu Xie <yuanchu@google.com>,
  Wei Xu <weixugc@google.com>,  Baoquan He <baoquan.he@linux.dev>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Kees Cook <kees@kernel.org>,  Peter Zijlstra
 <peterz@infradead.org>,  Jann Horn <jannh@google.com>,  Pedro Falcato
 <pfalcato@suse.de>,  Hugh Dickins <hughd@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  Jan Kara <jack@suse.cz>,  Zi Yan <ziy@nvidia.com>,
  Lance Yang <lance.yang@linux.dev>,  Rik van Riel <riel@surriel.com>,
  Harry Yoo <harry@kernel.org>,  Alistair Popple <apopple@nvidia.com>,
  Nico Pache <nico.pache@linux.dev>,  Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>,  Usama Arif <usama.arif@linux.dev>,  Kiryl
 Shutsemau <kas@kernel.org>,  Matthew Brost <matthew.brost@intel.com>,
  John Hubbard <jhubbard@nvidia.com>,  Peter Xu <peterx@redhat.com>,  Will
 Deacon <will@kernel.org>,  "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
  Nick Piggin <npiggin@gmail.com>,  Oscar Salvador <osalvador@suse.de>,
  Minchan Kim <minchan@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
  Xu Xin <xu.xin@linux.dev>,  Chengming Zhou <chengming.zhou@linux.dev>,
  Chris Li <chrisl@kernel.org>,  Kemeng Shi <shikemeng@huaweicloud.com>,
  Nhat Pham <nphamcs@gmail.com>,  Youngjun Park <youngjun.park@lge.com>,
  Gregory Price <gourry@gourry.net>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Ying Huang
 <ying.huang@linux.alibaba.com>,  Jason Gunthorpe <jgg@ziepe.ca>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-fsdevel@vger.kernel.org,
  linux-arch@vger.kernel.org,  linux-cxl@vger.kernel.org,  Chris Mason
 <mason@kernel.org>,  stable@vger.kernel.org
Subject: Re: [PATCH 20/46] mm/gup: fix clearing folios in memfd_pin_folios()
In-Reply-To: <ec55c760-f099-48e1-900b-9f8e2e5315da@kernel.org> (David
	Hildenbrand's message of "Tue, 27 Oct 2026 20:20:43 +0100")
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	<20261027-fixes_core-v1-20-6f74bec9a5bb@kernel.org>
	<2vxzbj8fp4sn.fsf@kernel.org>
	<ec55c760-f099-48e1-900b-9f8e2e5315da@kernel.org>
Date: Wed, 28 Oct 2026 12:40:48 +0100
Message-ID: <2vxzld7injcv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44A20180003
X-Stat-Signature: mpyo3aetsw8nd4t53ti1i1b38m4t1jp6
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793187660-351953
X-HE-Meta: U2FsdGVkX187PhsBTg4qUl81bIsST2j3v3BIhod2RFLKOdMgTYkI0ahLa0QKnAjIz/yRUV8tVDMjRC3JmhGFy9TxXiOMiIkrJSN07oJshbFsHhgxn821iPf+6Ty4PW+Y2I0waDsiar74Or5dyVDNrEAmgHEFx+waBdDl/vO/ZKLdaNklN8tzZPgtBrLE4NZicl19yD1M1We2kdU7VOL5/gbCMSz17F1njDsz9AsQ7u3iCAv1Z95FogF9Ttzqz6UsapVFiry7bwtnfGLdXCxp5uC1w1BCq0ZGHcX5mn/k4j2U9BxR3F1mKKj8QkWEatvjGXsSP19LdTmDtdQldfdwdLzbKv76IyQuZtgn1EanNPDKXMZhqG8kmt6FQ+Vk3bkk9HW9AHGV4XbEv55RYDa/wGvqcq2c3H8uhXcKk1ItzA0x/xZC7f7zxfeFYL1LFB5ZIoKvlx2vcMtfAZc4zCr3dYKKh/PUwdJbFlt5P3gd5B/8bCORVPFacqlv6TQxC/5egdpG73n2ggCeDqmO1BiUu1s15nhes0GAdarRkCYdZTMnGAC8e5STUyMYxEX+2MOKlYxY6X79+7MS2eB3XAy7Z5kNXDFF4nIh7kNM8pQifEvyewnJ7DOSQ+Hm9ly7g2SKNdrVdrvSoO7mTPL2PmHA4eK4UASGz7Nhoob+NRco97h5BN9wHVfgWbcifBPhPIjKpyc3K3BIlkF1Lwpnde+0+30t+Z8ft2NWJ6Fhv2wmlTtY4dZ7lCOEuGH5i9+cDMzJ3khV1O0it+Y0ISHta+wdB63StO9JBDpuQOZyrnQgCdgYw+ajKPpGW2lCyql3N3ke2vu3Qfc/PYo8CbLEJXgD7G9VE2ZXyoqrHr6AryW8cB63F4SnrB1JwgQ8/e/ztuO8nthdxUTBVuZXIC1kLQCxn2KvcbCjgkwzgCTHILUu78jNQy/iRgtU5owS3qjDL3b6pg7AckpCt8MsDGm82ug
 Ui8LbMuS
 e4wGvJV5d2g1C2PwUAqEFUvdKCbz8amg9LGpuUQPpiIJbt6MsIXt8XCsqIfEU2M+8maCq3Eehi8QZlDx1vo463FmA+gZrOhvkfcXHpKo0UH6QNe9cnOHyAmaNtq0WOqrQ8CQMlmTLiEaLo+biaaqFVQe4BRk7rNeDFTzLSbQiTnxD8K2ND0Q4leYkOqwY3V2MNu5WsAboMI6kI0hCQhOG+HSyGJ1K1YyQ8NnUggmda6ApaSbT8rWQq7ye/CGv/pbBddY3tBaNlI1SVUBdc2kn2iDVcZ/PxoUMgBDFlQFCi4JMX3iFatgQ9iorr57sft+Lekmzq0UW6pM8oROojcBghmEncK9jLaUj973q6+wnSG1BNSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:

> On 10/27/26 16:00, Pratyush Yadav wrote:
>> On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:
>> 
>>> From: Chris Mason <mason@kernel.org>
>>>
>>> memfd_pin_folios() pins folios obtained directly from the page cache
>>> without checking whether they are uptodate. However, shmem fallocate()
>>> can leave newly allocated folios uncleared and not uptodate. Callers
>>> such as udmabuf can then expose uninitialized memory to userspace.
>>>
>>> Clear non-uptodate folios and mark them uptodate under the folio lock
>>> before returning them to the caller.
>>>
>>> Fix generated by an LLM and sent by Chris Mason in private.
>>>
>>> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Chris Mason <mason@kernel.org>
>>> [ david: simplify description and comment ]
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>  mm/gup.c | 14 ++++++++++++++
>>>  1 file changed, 14 insertions(+)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index efc9aa2654625..47e7ae152cdf1 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -3516,6 +3516,20 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
>>>  					goto err;
>>>  				}
>>>  
>>> +				/*
>>> +				 * fallocate() can leave folios in the
>>> +				 * page cache that were never cleared.
>>> +				 */
>>> +				if (!folio_test_uptodate(folio)) {
>>> +					folio_lock(folio);
>>> +					if (!folio_test_uptodate(folio)) {
>>> +						folio_zero_range(folio, 0, folio_size(folio));
>>> +						flush_dcache_folio(folio);
>>> +						folio_mark_uptodate(folio);
>>> +					}
>>> +					folio_unlock(folio);
>>> +				}
>>> +
>> 
>> Nit: this logic is repeated in a couple places in shmem.c and in
>> memfd_luo.c. Perhaps it deserves a helper?
>> 
>> Anyway, sounds like an important fix so don't make my nitpick stop you
>> from landing this if you don't want to bother.
>
> Thanks! yeah, I had the same thought when trying to improve this. We should have
> an easier way to just not hand out unzeroed folios outside of shmem core
> functions in the first place ...

Normally this should use shmem_read_folio() to get all the folios, which
does zero the folios before handing them out. I guess memfd_pin_folios()
uses filemap_get_folios_contig() for performance reasons. It does the
lookup under RCU and doesn't need to take the folio lock. Perhaps we
need a shmem_get_folios_contig()?

-- 
Regards,
Pratyush Yadav

