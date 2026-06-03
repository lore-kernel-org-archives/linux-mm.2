Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61241CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889E06B008A; Wed,  3 Jun 2026 08:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861406B008C; Wed,  3 Jun 2026 08:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E2B6B0092; Wed,  3 Jun 2026 08:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 681C26B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:35:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E5208D445
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:35:46 +0000 (UTC)
X-FDA: 84838547892.13.1C8BD07
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 139662000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:35:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mfH39SgR;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780490144;
	b=PblfU/QyXKoxFyASUAAWgFwWRcCV2NZK+UIglO+4S+TGs04PhFZPgl6IGD8wGyIOomV5Lk
	od8bW/tIH3st5tOftG+NvfCSYqpUjI8dx1S+OXlTRmmF6MxU+HzWDc1ttLrcLuL/lRpB9i
	nDIxsaz1TuTsLYuiMGEg1PYXugu6DeA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mfH39SgR;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780490144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9sR5yqOCGgeVlEaAS9Soc3bRmMTmesBZYBPLglueNQ=;
	b=Y3Y4NUnl17hdCUGAp9kyQ+xtk9I6Ic6xATXTayhRuzPX3T9m/Gq/7nJBkMnnl2dIkMFRbY
	Vs9mpe+9Cb9iU/391/HKmW0nMLR4wIuyg6Mh+jk/pvrDFg6GC7HSGSGXnenEQ8+Zw4hPAL
	Tz5213quiNmBbDVAoRVvuFCyANWJY8U=
Message-ID: <79118b43-78d2-42da-b552-ba8b5859fdc7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780490141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/9sR5yqOCGgeVlEaAS9Soc3bRmMTmesBZYBPLglueNQ=;
	b=mfH39SgRWtk3Q6TdmUau9qBKNIw1TnDmHXu8H0o13+pe/fgdf3g2HcIbMceCONX/LZGySx
	40rPnip78y3PfLSthqGi43RLqdSXW3D6qZOH8HFlJyqFeoL6mJwQne1WmYwMCiA+v20plk
	xiNVsRdSxIC8nWQpJX+NECvDOZAR7wk=
Date: Wed, 3 Jun 2026 13:35:28 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 15/19] mm/hugetlb_vmemmap: Move bootmem HVO setup to
 early init
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, Muchun Song <songmuchun@bytedance.com>
References: <20260603120246.1572177-1-usama.arif@linux.dev>
 <f9dd874a-b637-4740-9a63-8da66de323ca@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <f9dd874a-b637-4740-9a63-8da66de323ca@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 139662000C
X-Stat-Signature: cnzdk54nf5h1fjuigbbomseq66oc1p1k
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780490143-961954
X-HE-Meta: U2FsdGVkX19SMZMhgNTN+qfJ319yuHBPRf1UAyC2YWtMAR4vNmJ8/SVHuyi8o3WtGWSlSaeZjox4jsiR9T//no4PK2kFWaG5rDvRzrzDwYPGqOdV+Jp6RdefNkljxV1nmThCbskiLylYdVxNNGmlCtVzFhycdHuyItSigKSV65d+O5ppadlbsxYta9VGfE22CFyEfOuWb45B1v0rnChD/XJOZGVsj18hKPNS0xYDoJ15iPJQvDsC5LpGXGr+rq/iTqP6EDOQDXlnbuy7Uc5PLFdqhsSsClN39yYBgQdMp3rHcCGbmUCZt6hPcsDR4Mg2jp9RtSxjg48heoRfuvxoimcyRf21RRwFmuMxJeb/YkIJbMvvnAaP96pF7i36fT9Yjs1bJjwLht9FUFZGRqk8ljaHLaElKpqVQQEUZ6+oVk2B7M0D8s1JQNA19+C8XI+ibTnu5jJ2JpJf4tiUHCzAiF1j+eh5VAYh2FnednrK+ZhFAuSGzBaCne8XX+nPFrlY5w7APAMZ3MgR5dOzuI6RL0II8jBnQxM+OdTkT0EeywRGCpkUJwW10UWTKrmidOB1gl8OZRFRnuDcIGe88TYxiAXZVdx/85/OCEn5v+1WTpOgJtSybigX6AFN25OYvxULioXIuc+Jv56MydkzLK7I6iUfwBbJkJCLbREZ61UtFKdbIq7Fc0kBwWt6PjMJXoaVAMwd1BFsUamAZ9lyigafYYXomipFuv/EwZpjBXhutD+M5O8jtT31T1hklvimGlvOuWw3yM+CA4Nwe9xo8adxoBlyh4vAVqbt4B8rcZkYwSGYI9hHH0QRaNZ/gKKdWcyhsIRLQCK2+2q2hcGKHa1l20M2A2mGtmu8AYO9jMEjTeEKPV7VkRSvb9V6xBTxdMfZJxHVgv7zABsVU23tSJ6f1mYxzKEA67Es6rCutjk+c5MwyL1seIj8VDnSG7C8GsJKwth9wM+aK8wQA5FVqn+
 LT2Sb9Zv
 MGni5skq0CKAg6jj7Dra1s82dkfioCsx3iYCflaDIsVIoUvLMaM2VX0eoEKUE22+xQviZDhLNbn/g92XijB0ZvlI8O7QSplMAFsFd6eOl4UUogXcCiZnDz1dt0fvbOkQG2SVKA4KaeOTG4+kAAUrH+86JhVxz52NmtV9t9nahqrRqjcrm9niAKdwgEKynhpWBKn0J7Yw1SMffJ+CC6vTbOsWIN6Ti/WaqqTd3xsGkyP6yXzW0XlWyDZJs776GGZ+m7MaAzA+wOXY3CkRP+PKWgvGS4sWSlkmuSC5e3lGBiEVbgCgSYH7+/N5RDZJ9p7DbmrJ1CJxPh/57e+03b8ZwUXIfmky3H869PAFg1VhG9rQuncVwpBQCw97su8SpaThoRNie+4s8CGzNhJKLeMMTjFk71Ojr6fMTJs/5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/06/2026 13:24, Muchun Song wrote:
> 
> 
> On 2026/6/3 20:02, Usama Arif wrote:
>> On Tue,  2 Jun 2026 18:10:35 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
>>
>>> Bootmem HugeTLB pages currently defer HVO setup to
>>> hugetlb_vmemmap_init_late(), because the optimization needs zone
>>> information.
>>>
>>> Now that zone initialization is available earlier, the bootmem HVO setup
>>> can be done directly from hugetlb_vmemmap_init_early(). This lets
>>> gigantic HugeTLB pages apply HVO as soon as they are allocated.
>>>
>>> Bootmem gigantic pages that span multiple zones are now filtered out
>>> when they are allocated, so the remaining bootmem gigantic pages seen by
>>> later hugetlb initialization are already zone-valid. As a result,
>>> hugetlb_vmemmap_init_late() no longer needs to handle bootmem HVO setup.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---

Acked-by: Usama Arif <usama.arif@linux.dev>


