Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85948C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 05:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55F966B0092; Fri, 31 Jul 2026 01:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FBB6B00A0; Fri, 31 Jul 2026 01:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEC26B00A1; Fri, 31 Jul 2026 01:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16C646B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 01:49:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9276314034B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:49:38 +0000 (UTC)
X-FDA: 85047994836.07.EBC41A3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id A29661C0009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:49:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lm4Y9AxI;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785476977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bOUJ+uhVBsqydwHV6IRHhDnJbF80Ama6mD8Add7qN8=;
	b=CDiPi/CdQBI9v0UNSx/DNcZgElc2l+IDGMrx3ksj8uxDf557TOES8wE8epSwJhsorgITkO
	1lfKUHeyNFso1Q4yVsGUenB/LnPe+tpyYDF2suLCVVDEBsIRY7+wzeJg8rjCd52vF0T5Oh
	ZQuF5YIBuz08If4qe0VqGlMXE3OlgFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785476977;
	b=poF6IAOOlXw8Sur2WlGCo579Lhp+xK+HVSdbYEvUbL8LY3Z6dVmw0/ZAPi56DxlOikIb8M
	JFpDRAWEc+1ssI3/1W/ZNJ79hvV/zniuhjXxgVLhq8YTbjBeNb4Z6sWa/mOAOP2WqBO8nN
	Qp7kIp1dgCDSOirZAU17GtXJsH8wjzY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lm4Y9AxI;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4315A204C;
	Thu, 30 Jul 2026 22:49:31 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A18D93F7B4;
	Thu, 30 Jul 2026 22:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785476975; bh=cp77iJVRWq97XcYYpGanGjI9nrMi/T9XyEKlGtEm3F4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lm4Y9AxItuwNS2mYWEbr3jeJY8GANTkzrsF3Zc1UhcaT3R88O+XiEF6xuLUzbJgMf
	 FuLzKLdX/kUlFIkefo4NK3Qi11BbQwnmzc6Nw1Vo8+JrLjJC2+mL2OLu9EqmXtZRR3
	 PZUd6bbH8SNkQ4gsNj8M2Hcw3mNZqsBDiFwuMLbY=
Date: Fri, 31 Jul 2026 11:19:32 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, 
	pfalcato@suse.de, agordeev@linux.ibm.com, ryan.roberts@arm.com, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	damon@lists.linux.dev
Subject: Re: [PATCH RFC 01/11] mm: introduce hw_pte_t for PTE table storage
Message-ID: <6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-2-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727164715.2866609-2-usama.anjum@arm.com>
X-Stat-Signature: 7smmzyyyszgtsemdjszc4dy8uaxzprhf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A29661C0009
X-HE-Tag: 1785476976-660859
X-HE-Meta: U2FsdGVkX18//0/HiaarG/EmtTSlbOE8s8pbSlkfnMth1Ku/GjlT6VhZhvAlJ1WWLMxp2+8MIelnxO0M13pMFzxHoHqi4JI5ie2u069afCbr4BAI1Zg9UUr1d4OeB8L/kLVnqdLYwwJO06+QK/q6y9XEWKnpujd5txZ8j59JZBaY3CZRNnj67AaTWoEHZzlmH6aKyiEOCRm3EGGhwLqj/TjZ79wj6dz0nAuenuVCh7srbY/d0MTHcxwgD+slnWmiw4ejQ6JylOyTAtyOl4gDZyYUXhGVnbKcWT1guDn2+v0/TZPklq4KPXQF2pFYKQDOTTLo2eGtptqjTOohpW2MLygEsf1sIP93hBUxYfKOjiWikV8kRwA9TYry+tme/Xd1V2HJ7IFrCO15EeXb6XN7a+HOqMZxZF3BUlwbqwI2aIAUP7UjnyKOrNmyN2EFlZg5ESUiCUJge5JvgFns1GxYV4X+sQ59eb18cSo5HyJXgdzFcNbiCXlJLMhMOm7vePH79hprCPT541uaeVWWeiHEAv6qWFGsMD1wupBFXDVkowehoocvWj+09GyHIqada3QGw3ypbcIVBCJV6PRRbIQsrZVUPZ37LYlXN6whxCGNGKC/ZZXnch5gDx+S9ncRilG4KkRTd4p3fwbN7W+NTuO8aGocfcU+CCgJ0zurrqoEjhQYC2fjTqmD45ZDK+emEYu5UnEOawJmVwNfSDHYp53GrAQAavMqXR+XU1Y1+cOZHMgECsxu0F7zETv78YnTET1AKhMouE2tqhTCyMOmpSYhWjq9KjFoIeoQJm49y9AbiAIuvWJIEmFBEdWS2KOrXTMWmRSc6VW3aIfR/ATpHDl/Jov2gALDs0jXrAlJn8GVj61b48v9nMuDEpxHtftYPIkP4xSy4M2g/1ErAzjcNmz1jvS0zQX66ntIjjtm9MVqPHw2uyUJpFwrVYtIddS9pnzgI9iuDIchHy1sY3pKRdi
 XzbCm8ic
 /CVfSMglFynEHY7c/OJ8WFufB72nZLCM4ccXjdkLcdoBrc0mqtZ3y9Mu35qtqz7TVNouCTUp91gFC7yefSuzE56ztb+g9LkF5Xb2gBBXZ+Y8NheeemhAs5FR9HttsDv7FJo1lOWrk+wCprM9KZspKX0D30vl9lcfAhN/g082bCOB132wYrfv+FqDhwHVizuO28btBK1MQXvikWLai5g7fd1Tqx253FYFXtWdbj/yAtpYxDJicF0dgEX4bHArpnieEJ8N0Qjy5pl/73QPnvlDxu2lqx3UxraJT7SqeC5CK4Ur2kxtX8Mw2d6q1aHaRXx/oTbeXL3AHEqL89ilrU0mi8GusfXOb8qfnsoLldy3rjUHvVRl4SYSFsWRJYcDVmC6vYloM+7v76ttrANMBzR85PcgQ/wN7dfBZAtxfkurrv5XfQMKilC2FVn0nT/5AEVPjO85TQTtk5Jdu0fs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 05:46:52PM +0100, Muhammad Usama Anjum wrote:
> pte_t is used both for logical PTE values and for entries stored in a PTE
> table, so pte_t * does not distinguish a pointer to a copied value from a
> pointer to table storage.

Should we rather call them as "Linux PTE" and "HW PTE" instead ?

Some like "Logical PTE" does not really sound very clear on what it represents.

> 
> Introduce hw_pte_t as the generic name for a PTE table element. Define it
> as an alias of pte_t by default so architectures retain their existing
> representation and behavior until they opt in to a distinct storage type.

Makes sense.

> 
> Include asm/page.h so pte_t is defined before the generic alias.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  MAINTAINERS                   |  1 +
>  include/linux/pgtable_types.h | 11 +++++++++++
>  2 files changed, 12 insertions(+)
>  create mode 100644 include/linux/pgtable_types.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 15dd00c7ffec5..78aac05949829 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16981,6 +16981,7 @@ F:	include/linux/mmu_notifier.h
>  F:	include/linux/pagewalk.h
>  F:	include/linux/pgalloc.h
>  F:	include/linux/pgtable.h
> +F:	include/linux/pgtable_types.h

s/pgtable_types.h/pgtable_hw_types.h ?

>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> new file mode 100644
> index 0000000000000..ed5dba42a4f8c
> --- /dev/null
> +++ b/include/linux/pgtable_types.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PGTABLE_TYPES_H
> +#define _LINUX_PGTABLE_TYPES_H
> +
> +#include <asm/page.h>
> +
> +#ifndef __HAVE_ARCH_HW_PTE_T

__HAVE_ARCH_HW_PTE_T macro is a better approach here or a config ARCH_HAS_HW_PTE_T
based selective platform subscription should be introduced instead ?

> +#define hw_pte_t pte_t
> +#endif
> +
> +#endif /* _LINUX_PGTABLE_TYPES_H */
> -- 
> 2.47.3
> 

