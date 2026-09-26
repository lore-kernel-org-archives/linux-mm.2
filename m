Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6D6C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 07:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626206B008C; Sat, 26 Sep 2026 03:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD076B0092; Sat, 26 Sep 2026 03:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5B76B0093; Sat, 26 Sep 2026 03:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4D06B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:06:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A70B9120811
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:06:46 +0000 (UTC)
X-FDA: 85255030812.03.F4893CB
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6A15940008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:06:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aJd7J7E6;
	spf=pass (imf11.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790406404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/DRviET7bsz1Paw85LCVD+NpOCX60siWsty7pUxL+A0=;
	b=j0e0i+djJSSPdG0NJ+gvLZKV/la3em8MObeKvm3xnZhM+hEjDPYjDuh3wx3eObMn0Caa9I
	YszF/maufRr8Czx4GG9DkCCbvK+Aj+WXqLpP5Mmd6WN3n8+Bnl60mCYHFiG0a6/IiiU3VJ
	tSU9slHbK7rAgxfNGEh661r/sHH3QJs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790406404;
	b=2vI7VPY6FjX4M0sQ6CVhv9SidegLpl0b6vYwi/24yYhUfsnO0bYqBefY03DMsesuPbbSxq
	2JfM7WRIrRJsoqalro8kwDR/sdqgo+KCuVdd0xaTqB51X+p+yawQISAn1wE5h/RTkM5dnl
	2N4GT09ntm3vYJaNYEBo7o3CkFXFosw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aJd7J7E6;
	spf=pass (imf11.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T2p2H25v2pZGOR2O6w90y62GhLcCItp+jxccTxyxKa4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790406402; v=1; x=1791011202;
 b=aJd7J7E6yqryLaw4nLpbgu/FKtofXZ5qfATpxUBwnSANmuAG7DHMaU2WY18yGnU3VAji3026
 AD4S90AWgrmF+zXG/uS8rsO3S3+zSvQM5YppNtV32D52scEMz39KfN9IcM6zMixUw9i6CqRptfm
 7/olAmvU2ZqF6olU1FErgUDk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id b8b31df069231cb1;
	Sat, 26 Sep 2026 07:06:42 +0000
X-Mizu-Trace-ID: b8b31df069231cb1
X-Migadu-Flow: FLOW_OUT
Message-ID: <3e2690a2-06f9-4819-8e55-2129ab6566ab@linux.dev>
Date: Sat, 26 Sep 2026 15:06:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page-flags: Define HWPoison test-and-change
 helpers unconditionally
To: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-2-kaitao.cheng@linux.dev>
 <6eb272c0-0cfa-4354-a92b-4fc270e3b1fc@kernel.org>
 <20260925231908.25febf6c085f52be3a65d59b@linux-foundation.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260925231908.25febf6c085f52be3a65d59b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ri6b3gx9njst34t8bpdfds1u3paki534
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A15940008
X-HE-Tag: 1790406404-544397
X-HE-Meta: U2FsdGVkX1+ki4rH2OuG1EsQ7IbI/4Lv/MdwG1XJxSodGaHFGgC6Y1p2OTj2QOOVnLCsFBXjK85IEHsOdmNSYlzJJc3iaUnCRA6qs4M7ZcY2T+/s0opsKLimLY69pivhXQxQyW4PKOK3Ab/Q01NhL5PTED+yU8GEXwnpeXfCSph8BcWSmsKrlmW/O+C9j+t0x0oNKfYwQ4SlTty1TgSXTcidSHNVJEMrXFYru+d2hW+0BzbzMWhEHCNk2ldzUDre6h/J84IgwhWubSAAbzxd3BS4qwokJqzHmJ8gDoc2hWJrZvaTVlUmltqDeaZrcfBI6CWKz1l4Vmw9mZb3egCLTZeoJc9MHmwdGBQT4/kJb30wCa41tdLRLtEfVUIw0XEUuoWyhXOJkpRv1IilIhOany0NzrdHeqgwrvMqYyd0TwGs6Zd2a0OBD5OMqfjNh0PoAn03TXkyqIcUcjSSteE94nEv6PVmXcYWWQOPxQtiP0B3rdhV/0cEJ8LPRNZ/5+4Xegec6mVnqlT04dokxS29mgwWhvVPIHv772jfxyE9V3RzkfTstcnIlhHx2Dsk+jTnT0HpZNGCY7SDluz2SjQNnOhsnqwyYbe7e8TPEHLbXJtHUo1pxc3rEq6IakD7oIYMCb7IqOF4q2okIu1LUR0FHD1e7r+x5THE8dVvyUSf63U3RqPr0xJyDQhrwue8Z8DfCSDqVF1oYaIH48dMjZ4Nx/qnXig8l+07kcRIQ4vohXUy3B5glSp/CUEm5DQEoDNDuMuup1yYlO1Uh/ADEzUzOa8Eh6LartlX8MchGB5oiR6lucczVitLKRu63QngkoFxQX+lqC16o5ZJONfx8JZz4n7OuqGWbtKTcPBauj1iDdrv0JjoejtlQrM36De2SHhT6R5wscWkcMhLFtFgDo+5A6PF11Lk43dQtv9Ul2/Nt3dQ2t11+8lxFGv6ZSlD1TYL/Qrdx1HU+xb2iCmaPqd
 RpFPfw3n
 UftigSvKdfDdRazaB0qceUj/Nfe8xHhzS05/gvEQ+mHV8nP6JLX0An7sxiaq9mf8tlgZHYzMGceA8C+1zYBR/CTGE2Of79sD0kIb/hAVGmY+thjhZKyMjfJ9l4X1BDIcTwqN+y22yBpR2x58VFH6Rkr7vrwVj0eGsMGEWNzmzvIjd0XQ0HjVjVqXZ6dUfYTlXji/V0118b6b8186T2UMv15Bdf1vMD9k5/LUW5octLd9+koWnaSykpaz2oGl2+XEIzjP7HrOeGgSWjkg6Njj/A6VdODxE1ZISnjFjJFp45jiXmDCWuE90StHaVFDoIAo/tmyFGXMZ+oZw4yaqClaP8cAyz+RIq1q01b9tGPAIT1U8Sho4SqmOjk7JhLoy6ThDXnO57vQlxTZfy05ekcu96oG9vAtW5Tvvuq2ZsS+ijsYwFlX5zz7NtyIrwWhogRe6Yxj3tGK/Ihlbi6//wS0pt/Ngs0xBjEhaHxF5C5iKmy4XlfNn+v4v5W9QuQiy0RahXreI86ajMeYqWa/pQrCjuUeDBaP7+3xODZOUJws3iICq3EA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/9/26 14:19, Andrew Morton 写道:
> On Mon, 7 Sep 2026 17:42:11 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 9/3/26 07:35, Kaitao Cheng wrote:
>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>
>>> Page flag helpers for configuration-dependent flags provide false or no-op
>>> variants so that their users can be independent of the configuration.
>>>
>>> The HWPoison helpers do not fully follow this pattern. When
>>> CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
>>> regular, test-and-set, and test-and-clear operations. When it is disabled,
>>> only PAGEFLAG_FALSE() is instantiated, leaving TestSetPageHWPoison() and
>>> TestClearPageHWPoison() undefined.
>>>
>>> Use TESTSCFLAG_FALSE() to provide the missing accessors when memory failure
>>> handling is disabled. Both accessors return false, which is consistent with
>>> HWPoison state being unavailable, and makes the accessor interface
>>> consistent across configurations.
>>>
>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>> ---
>>>  include/linux/page-flags.h | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>>> index 7a863572adce..a2315ab1dd3a 100644
>>> --- a/include/linux/page-flags.h
>>> +++ b/include/linux/page-flags.h
>>> @@ -656,6 +656,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>>>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>>>  #else
>>>  PAGEFLAG_FALSE(HWPoison, hwpoison)
>>> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>>>  #define __PG_HWPOISON 0
>>>  #endif
>>>  
>>
>> Can we just squash this patch into #2 please?
> 
> I did that.

I’ve also posted a v2 version.
https://lore.kernel.org/all/20260923055318.57485-1-kaitao.cheng@linux.dev/

> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> Subject: mm/page-flags: define HWPoison test-and-change helpers unconditionally
> Date: Thu, 3 Sep 2026 13:35:34 +0800
> 
> Page flag helpers for configuration-dependent flags provide false or no-op
> variants so that their users can be independent of the configuration.
> 
> The HWPoison helpers do not fully follow this pattern.  When
> CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
> regular, test-and-set, and test-and-clear operations.  When it is
> disabled, only PAGEFLAG_FALSE() is instantiated, leaving
> TestSetPageHWPoison() and TestClearPageHWPoison() undefined.
> 
> Use TESTSCFLAG_FALSE() to provide the missing accessors when memory
> failure handling is disabled.  Both accessors return false, which is
> consistent with HWPoison state being unavailable, and makes the accessor
> interface consistent across configurations.
> 
> Also remove now-unneeded test_and_clear_pmem_poison() from nvdimm/pmem.
> 
> Link: https://lore.kernel.org/20260903053535.17611-1-kaitao.cheng@linux.dev
> Link: https://lore.kernel.org/20260903053535.17611-2-kaitao.cheng@linux.dev
> Link: https://lore.kernel.org/20260903053535.17611-3-kaitao.cheng@linux.dev
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Ira Weiny <iweiny@kernel.org>
> ---
> 
>  drivers/nvdimm/pmem.c      |    2 +-
>  drivers/nvdimm/pmem.h      |   12 ------------
>  include/linux/page-flags.h |    1 +
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> --- a/include/linux/page-flags.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
> +++ a/include/linux/page-flags.h
> @@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>  #else
>  PAGEFLAG_FALSE(HWPoison, hwpoison)
> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>  #define __PG_HWPOISON 0
>  #endif
>  
> --- a/drivers/nvdimm/pmem.c~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
> +++ a/drivers/nvdimm/pmem.c
> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct p
>  		 * here since we're in the driver I/O path and
>  		 * outstanding I/O requests pin the dev_pagemap.
>  		 */
> -		if (test_and_clear_pmem_poison(page))
> +		if (TestClearPageHWPoison(page))
>  			clear_mce_nospec(pfn);
>  	}
>  }
> --- a/drivers/nvdimm/pmem.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
> +++ a/drivers/nvdimm/pmem.h
> @@ -1,7 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef __NVDIMM_PMEM_H__
>  #define __NVDIMM_PMEM_H__
> -#include <linux/page-flags.h>
>  #include <linux/badblocks.h>
>  #include <linux/memremap.h>
>  #include <linux/types.h>
> @@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_de
>  		long nr_pages, enum dax_access_mode mode, void **kaddr,
>  		unsigned long *pfn);
>  
> -#ifdef CONFIG_MEMORY_FAILURE
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return TestClearPageHWPoison(page);
> -}
> -#else
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return false;
> -}
> -#endif
>  #endif /* __NVDIMM_PMEM_H__ */
> _

-- 
Thanks
Kaitao Cheng


