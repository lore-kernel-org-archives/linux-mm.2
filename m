Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A416FEE4D1
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 07:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9655E6B0005; Sat, 28 Feb 2026 02:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8C06B0088; Sat, 28 Feb 2026 02:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4286B0089; Sat, 28 Feb 2026 02:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9C66B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:57:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05F7EC21F2
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:57:02 +0000 (UTC)
X-FDA: 84493109484.14.EF9FD36
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D52A100003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:56:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lQlO0ig7;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772265420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4bcAGMvPk6yqnejowgBetfBiy6M1jtDvJ5m57sFLgo=;
	b=uYvfK4DjCLp2SiBc9cgazpCzXCURUj0WTEDZECS1IvDOtF9c/LYU22egeF3aQkeOrC8DpA
	xcf4PVFPH5vxfNBXDJ1ZpJKfaSEAY+Yg08/ZGfGt6sAZo5QCFdLZBx0k4lVauRHoq4tcm7
	iiOJC6H0GwV7y9w0IoNEmJ/Mzse/974=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lQlO0ig7;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772265420; a=rsa-sha256;
	cv=none;
	b=17Qv7Z0U2zzASCHiS8Z6xNFMt+wrepavtjOw/ofArq5OzCNEtkoXsPVDTZija30x5jmmrr
	mgtmVOSqU5JOT4bjAkjdl2y5azUZmKn4rECWyUelz/hvoPAUl3MCX5kzVb9ijCIzDH51gu
	gPsDREMF2EOv5kAhTOK7KeMaZUvm/rU=
Message-ID: <1a97fd34-f44e-40bb-806b-7c251d232d27@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772265417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g4bcAGMvPk6yqnejowgBetfBiy6M1jtDvJ5m57sFLgo=;
	b=lQlO0ig77PO3To4Pd+DwuX7PWhqQ049o94x7Gf5klkXZa1bvKe4deq2pXuS9OKkN0RJaKI
	NYpZdndBn0gi2q/eUMXmt0gWLGIMtzadziYyT0OMW0pDglsiQ64TL+lCivo9IxIiCwToAA
	qilj9pQMiTbCf1OFIXwIhJT9FO2q8GE=
Date: Sat, 28 Feb 2026 15:56:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v2 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
Content-Language: en-US
To: Nico Pache <npache@redhat.com>
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
 hughd@google.com, jackmanb@google.com, jack@suse.cz, jannh@google.com,
 jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, linux-mm@kvack.org, peterx@redhat.com,
 pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 linux-kernel@vger.kernel.org
References: <20260226012929.169479-1-npache@redhat.com>
 <20260226012929.169479-2-npache@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260226012929.169479-2-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0D52A100003
X-Rspamd-Server: rspam07
X-Stat-Signature: nzwgjbc87muedggajqtygeffuh58qubi
X-Rspam-User: 
X-HE-Tag: 1772265419-239565
X-HE-Meta: U2FsdGVkX1+ud6JXljMeY6DFTjQ9ZWPC/OwNNblBrCSOOYMjdXOPtlGkLifM3qWMRs7dUHcLEZtftRdwWNbVjY49mBZ94zA9pGIr7ZNSRDWaqoPCmsWHZiQJPCXkugM2JB7IqSBc24Q7u08/GPfzbKn754CfUldoM/ciKwahrrF5i/E9FhNUXv2Q3bXpmVgvKm4oWuWgiRIL7CeGpqcXrxUqQqbsKM1nAV6+E9KBdCkEVQAYsr714xRc27AOTBT8akGxcqJM/wjlTghFF7tAiPVV1QAyr2DIcwKoGcqBWpeba1hssv5fxIN6yEGiH7oaulYCbsKcidnZggoa8M/c2MPxfi77XHUugyYhiJpFNPHgFyOqlWp257TOIQrhLT7IEJq6GZ+A5KUNhW6WOGq2hqHeJ6gPalyhRRgywwq90+7Kb6UWysENIO+1tb55EGIL9jqVm+sz/S7y7obUVBIs+eaCKJldj16vKBKGPfa9Wr4wMhkiBV2KWgkcQsfRBOl10Ou9XL8EqNPBilUdBA7KOoiMy4Ksm5QqnHN5OAwpdvlR4XDscMOkmCZbEgW85Q9VXInQXFs2Cwp+OpN4pPoGg1+sudSPLA/v6XiukPzO1gGZ+VzQcjacFHxtHtht6qGhl3O7Eyzr6Iz6MqOVUdKLilAACSuWhIoINz5gMXGBEFt4/a/nXqFwK6NofAHt8PPbG/Qua77WcQmDkdgC5DYCcfdgq169T9/b9NYjYgrPOehmtrODFKSau39coQ1Uh3eGIafS+9dfi4aShZiJwVq6pp3C1eLF2eSg4jV3LDDULdhO6a4hknFh8edljRox1Mw25HAOs4FyRyCovki+akbLXe/rxabFTMn5vcDy6Ij3D2SNbqK4d0DDLMUeFrc/Re/rgj844U9tyuJq+hLcXQF0A1sXq9uLsfC8kbVkhlHz3sWLMmv5IqWmBHYjwOp9Hp3lAO1vmqiNOjNibi+hYE3
 9HdcQTpC
 onMbS6Bc4EXG0E9YSGYemlS0ed9jIyN4Xfbv5Kz1N0dtUDnsT29YPC6zkXMbvf/8X4fwy9p9qK3v0bVDX5YLGTEZ/fIPVch3Rlg+KZ4mdHBHJEOd4xvUkFfDucuSQ67EBuJrf43G2tRznkxqKNTTG+anNUuhXdj5HXR3ubBjCyW843DjVg49WQZaqC2BgODvoq5oE5WDT1a27oiGDum1fRgHoiogF/NqlO7hRySOFdq7+vZifkQqWpUPKjzRXUdgVzUhZjwg7cF+U5ALzpACNH0g8YW/+YJqkT3nKJcj7ZY7YF3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/26 09:29, Nico Pache wrote:
> The anonymous page fault handler in do_anonymous_page() open-codes the
> sequence to map a newly allocated anonymous folio at the PTE level:
> 	- construct the PTE entry
> 	- add rmap
> 	- add to LRU
> 	- set the PTEs
> 	- update the MMU cache.
> 
> Introduce a two helpers to consolidate this duplicated logic, mirroring the
> existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:
> 
> 	map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
> 	references, adds anon rmap and LRU. This function also handles the
> 	uffd_wp that can occur in the pf variant.
> 
> 	map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
> 	counter updates, and mTHP fault allocation statistics for the page fault
> 	path.
> 
> The zero-page read path in do_anonymous_page() is also untangled from the
> shared setpte label, since it does not allocate a folio and should not
> share the same mapping sequence as the write path. Make nr_pages = 1
> rather than relying on the variable. This makes it more clear that we
> are operating on the zero page only.
> 
> This refactoring will also help reduce code duplication between mm/memory.c
> and mm/khugepaged.c, and provides a clean API for PTE-level anonymous folio
> mapping that can be reused by future callers.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

The refactoring looks good to me.

With the change David suggested (removing nr_pages parameter from
map_anon_folio_pte_pf() and using folio_order() instead internally),

Reviewed-by: Lance Yang <lance.yang@linux.dev>

