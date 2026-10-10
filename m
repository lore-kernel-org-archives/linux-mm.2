Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5E9CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945B46B008A; Fri,  9 Oct 2026 23:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E706B008C; Fri,  9 Oct 2026 23:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7EF6B0095; Fri,  9 Oct 2026 23:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 500556B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:57:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2E79A0762
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:57:36 +0000 (UTC)
X-FDA: 85305357312.26.9E8BB67
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9974040005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:57:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wplZ5Pq9;
	spf=pass (imf01.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791604655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUEcubuPRyO1JnxFZHpKo/1sANkvV6yTkFHDJaSoGiU=;
	b=x278Fp+v7+bWhSasXSqqMcCsvNmI8erRWJlnt7RLyHb8lRzNCFxsCWB/a6i3nvVkVgiWsB
	lqsng7t4AY+1MNs2aM9sXG+oJAHEHPkRqZqJqYWDgjBR0r5p0KMAYuEt2B/ABpA8Sdp+6Z
	U0A67sFkV0g8wcvJlyD/uR7sxkNteVU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791604655;
	b=4ILL997yLu34OWNGdjddft1M0GXbLhPxsVfpJgF4oaX6qNbH7vgRMZaN4qzTBgFCMjjpCU
	ea2eoMytscGvnG7c+J6B8QP7QSKgjy9taWmdwY0L4pqFP//bVlX9iEbDT036Gjth8LZPed
	VgAI0VCELIU3fGShz5fSDRdyTWjj8u0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wplZ5Pq9;
	spf=pass (imf01.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pqSalTwZbRx4UVyHrQemVyuzGIN85uoeQ6V8gwJ3UrI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791604651; v=1; x=1792209451;
 b=wplZ5Pq9NBhO8d9llWdPZKTekxP+GKvvsOBShwkt/olYQlv1rcBeYvurPqWBsd/Xpi/QcwiR
 Csqmtx9Vdo9xXZ+46D91V98ySmkubluCYcMxMg1ZfmTA3QfNgPGXd+QBfx/lbyJJ8wHz90sGf2y
 iUKLKFCCF50loRk8y4rr3BcU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b05c5c691b9353ef;
	Sat, 10 Oct 2026 03:57:31 +0000
X-Mizu-Trace-ID: b05c5c691b9353ef
X-Migadu-Flow: FLOW_OUT
Message-ID: <ca58edc0-3132-4c16-9c45-f23ce51cdd5f@linux.dev>
Date: Sat, 10 Oct 2026 11:57:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] nvdimm/pmem: remove test_and_clear_pmem_poison()
To: Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>, Oscar Salvador <osalvador@suse.de>
References: <20260923055318.57485-1-kaitao.cheng@linux.dev>
 <asmffUJ1gPDfaAvV@aschofie-mobl2.lan>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <asmffUJ1gPDfaAvV@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9974040005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: izbt8nq6u1wrarter6tpt3aoxnhsgpt3
X-HE-Tag: 1791604654-556355
X-HE-Meta: U2FsdGVkX1+mLbstnCVcJ4d+WHrSSpCCL1Bp869VliKt9WUTFa5/ULFRmEqXzXLQaHb1/qKGhHFhgPcpGc4tPP3E1NmfzBgv7i0KoaQ8TuarHsCsTeSwXNQt5BFdU/AFFL4kU6V5wf3xdlIyunIl2rWU1eOyl+YsX8z4hoZ5uSB3kj1/huIZFZXNtkvff0Xyux7ApNpiW8gtwY3HknQlPKAqpwwNKLYWGxeLb+2G+vJOxJ/ang1AwyHMC2JPi4CqSLQBrrJborHxKcwszobBWdgBK8hMmaLzAQqjWCsKNeugh6MDgHKfiv2YlJVdbmX8Ra/6u/NPOkAwQDG0g+orm7yjpJqlawCqIhtGQo3qX7s1z3LwJdZpb5g8ZZyu6ro5V3IEvPiQELkxz8ZxtzUIGg04gm/l156iSW7fNNgD6LL56wIJt6Q6oVcRBD/emewHJfQvSKYWdBxjUmCj569QfeE2V0kUGczuZ2QxDrR1g9qonSp33fwyQg6EyjqHPlPbB3NKUJ1NdsvdYJj0BULaEs1AuCCkBHJyu8oZbMQMi2r00M4KzCk6tk9GyftP3fzVz/+BrvK+79/XmBwm37kPtD/h9m2TzBmb00htHeFQ7YfO3AtL8K1xsRNd80Jh9JQVvfvtnNofNgdG21gplqMZLry89Xy+gjBZ/8OywevAra83PyEY6e18sF8QB+Hvo72S5e3OHcV8nmTiI55fz6yEZUHvqQ3HUvdTP0WOO8y30LXcLYNfQmqvPA7UAMYmHANFD1avT7Rw5sDhSdJDhiQISvyF9poVfiZoA2E/AsXJCiV5/Wsg5xr5ILYcT0VMaZuJGDiILy0fSbq/cizf0GS+kasnSOJ/xxQz9qTr675UKH+PBloyPwy+6LO0iPPchMCg9rDDJiHJAFqmHtSnZmb171z1MkRKI8W7oiEHlu8FbaeJC4upv3kb9IfL4AeSaKvc7ZJE9lHjmKT6qo1J2bP
 4c4dRK/g
 thcb2TSDsAiUWHPw3E0tiLF286dIbUKHORY3JFiwIxNrPfElYBr7SOTqQIEeZoK60RmIb1XEhYv11i81OJbBaUOTiXqYCSXDfYtn5Ir0+6gqI1IaXin+nPkQ/LzT/2cWq1rZIFynpcMJDYMAvVTShlWneKZnFWXhCVmIqsSqWN+lXpGiBciqgaGY1CiaMekDggHCfSzABAMv8NJOjfaaCLSAbUKuWgmc3sIRpcG2Um86wjw6S6RpEtKnbBOhxl70y55Tcj0zb2V7hCla6bqJJd9SlaKJq0kQv1wdxSRs6B0C+BgGBlaXEPseSwRFkK3mW7W76xepYcSS1RYlLspSekFeSBh+ZEMJj/+4vReG7YRwNDXMgIGaS1aTTuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/10/10 10:14, Alison Schofield 写道:
> On Wed, Sep 23, 2026 at 01:53:18PM +0800, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> The pmem driver provides test_and_clear_pmem_poison() only to handle
>> the CONFIG_MEMORY_FAILURE dependency of TestClearPageHWPoison().
>> The wrapper has no other pmem-specific behavior.
>>
>> Define the HWPoison test-and-change helpers to return false when
>> CONFIG_MEMORY_FAILURE is disabled.  This allows pmem to call
>> TestClearPageHWPoison() directly in all configurations.
> 
> I see this merged here:
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-stable&id=2492d9c0afc02cebe8318155829e7d03bea617b8
> 
> Still not sure how all that works, but I got an email saying merged, yet
> this list was not on the email thread.  

Andrew Morton probably thought the change was straightforward, so he made the
adjustment himself and merged it. There’s nothing wrong with the code itself.

>>
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>> ---
>> Changes in v2 (David Hildenbrand, Oscar Salvador):
>> - squash patch#1 into patch#2.
>>
>> Link to v1:
>> https://lore.kernel.org/all/20260903053535.17611-1-kaitao.cheng@linux.dev/
>> ---
>>  drivers/nvdimm/pmem.c      |  2 +-
>>  drivers/nvdimm/pmem.h      | 12 ------------
>>  include/linux/page-flags.h |  1 +
>>  3 files changed, 2 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 30a51c365ce8..5fb86595e8bd 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
>>  		 * here since we're in the driver I/O path and
>>  		 * outstanding I/O requests pin the dev_pagemap.
>>  		 */
>> -		if (test_and_clear_pmem_poison(page))
>> +		if (TestClearPageHWPoison(page))
>>  			clear_mce_nospec(pfn);
>>  	}
>>  }
>> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
>> index a48509f90196..76870505dd79 100644
>> --- a/drivers/nvdimm/pmem.h
>> +++ b/drivers/nvdimm/pmem.h
>> @@ -1,7 +1,6 @@
>>  /* SPDX-License-Identifier: GPL-2.0 */
>>  #ifndef __NVDIMM_PMEM_H__
>>  #define __NVDIMM_PMEM_H__
>> -#include <linux/page-flags.h>
>>  #include <linux/badblocks.h>
>>  #include <linux/memremap.h>
>>  #include <linux/types.h>
>> @@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>>  		long nr_pages, enum dax_access_mode mode, void **kaddr,
>>  		unsigned long *pfn);
>>  
>> -#ifdef CONFIG_MEMORY_FAILURE
>> -static inline bool test_and_clear_pmem_poison(struct page *page)
>> -{
>> -	return TestClearPageHWPoison(page);
>> -}
>> -#else
>> -static inline bool test_and_clear_pmem_poison(struct page *page)
>> -{
>> -	return false;
>> -}
>> -#endif
>>  #endif /* __NVDIMM_PMEM_H__ */
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index ae2ebaed6d4d..3dc79c0c5adf 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>>  #else
>>  PAGEFLAG_FALSE(HWPoison, hwpoison)
>> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>>  #define __PG_HWPOISON 0
>>  #endif
>>  
>> -- 
>> 2.54.0 (Apple Git-157)
>>

-- 
Thanks
Kaitao Cheng


