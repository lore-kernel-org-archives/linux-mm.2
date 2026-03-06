Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5E9F01812
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 09:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3756B0005; Fri,  6 Mar 2026 04:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51136B0089; Fri,  6 Mar 2026 04:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33006B008A; Fri,  6 Mar 2026 04:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2D316B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 04:29:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5794A1A048C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:29:13 +0000 (UTC)
X-FDA: 84515114586.16.9D2021D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2391F140012
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:29:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772789351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h5wskvBRuKaeJs/emXYtwODH8GFYP+MuYeW58WpbxNs=;
	b=juQZL3+v3vItYzI7r028lDZRlmxKQLifmfLMqbj2fUh8B9+/Lenp8bpLekHDakSE2UyogO
	fyObWbaaw7ydMo0rUZlP/ADn18XvDqe7tS2beQ0NpBM3n6F6dTE15uF4ei+2L0o0PdaIRI
	NPN9QfR7OfD5CTOuVezsgDtmoKvnGG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772789351; a=rsa-sha256;
	cv=none;
	b=j/Yo5Dk05/Gm/fFZ7fhJ5thF5UEs3Mwma+gMLu/vOed2gMyCwJU12LAV5ZoFSW/w0vsH5z
	GwnbIGMnBu4bkUcJaHz8TxCd+AGGmMBpfxsg5bSY9tmB8mgRKRe3dxmpey41rICuiiqgGs
	hiH+baJDxbfDcJZneVYgVpwtOLzNUMk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fS1L42yYLzJ46cD;
	Fri,  6 Mar 2026 17:28:28 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 302324056A;
	Fri,  6 Mar 2026 17:29:06 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Mar
 2026 09:29:04 +0000
Date: Fri, 6 Mar 2026 09:29:03 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Yin Tirui <yintirui@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>, <jgross@suse.com>,
	<conor.dooley@microchip.com>, <riel@surriel.com>,
	<wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
Subject: Re: [PATCH RFC v3 1/4] x86/mm: Use proper page table helpers for
 huge page generation
Message-ID: <20260306092903.0000268f@huawei.com>
In-Reply-To: <20260228070906.1418911-2-yintirui@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
	<20260228070906.1418911-2-yintirui@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2391F140012
X-Stat-Signature: 44hpprb5t1jak1u1qoapaebpcfmpjsdx
X-HE-Tag: 1772789349-790544
X-HE-Meta: U2FsdGVkX18RPBKRCwGTDGKMY8LJ6p4J9m0I82IPbVEAksg+XHJxvAJFFS++8iL3zk7rKQ7n5vpxSIS3ssdVM5RFFkH6WRih9nTLaWpSszdFQPOrGi43oux7O7UYRuU1gGGS8ed+XL3aAhq+a1d4lqF8CdhaLDjrVKRr7O3gm3BZe6BynQW7R2Ly2KfU86xVFms/wrTKGR7oY+t7ivukGMkuu10hiu4W+++Y5hiiVc5jEUJcM2gOwh3zeJKh69PDuMhyZjAmC3DgflLZeIO1nlhhrw6ZdppGGxg5XR9CSslw+QdGCKTJ10fgmUSPxnCQZtXD75YOjGz/174nsYoxrWbegmXnPnC0P0fPIehiX+j8s9X6nkMdHsVHOJB/bsFGN90anShvAR+5+GoYgMBqBsyPAfdEtOmd2iWC3F+aDKIASM5yBOlsB1PLHNylvOkPndZDKfHxQudWzi4mQEZy+DhRqt/KLqxEYve6DMkYuINo1ryRnYP8jSquuPHfRDrbMqK8Q/9Xsx9NiSJX2AQdOeXdhg1tikB+/pGp6biniG8Dc9F6RhG0j7G9Ow//1Ak5A6BkyAAKVSynP1dGwYEr61fWWKGiw28o+lWPKH/baCJAxesW3JtTLe7FPtaJ7BsoO6ugbKaq3TaAC/htaYc7Dtk8JTl6/h3SukOm+Wz3CgrkWNJZpcJa8VAAabktpZa2u01J542ZUbXqGpXb1e8BgA6IiyRDGlWpRuuIuFZPsukv2KYAPaB9kHGAR8+6xDWUwpExGc80E5ugdF+cN5mOhLUL0ct9+vYgB2eFoeSzM3/6jID//N8y6HxTaZfMXo/VnHyuCU/qydWMIH0+33d/Uha2Xq9mnP973vgr03H1N2vRaVeALORBAYvQycwMVbzs7oAnqW1LLCeZccpmUhC0Gn6I6rbz/sXPuuClgzZGBAxUkWSgLJycxqEIlrkNKrDXSEb6FkjPBov7Tvwq5eQ
 XRbbxTPt
 BAXb5ECQJ8yP5J+AKnsfC/RekpPQy86bLCCKATjwbmvZg00bio+xNXV44mYLL780IUGqsNVT7FaqJAlDvYREZtVIykoKcYoey2Fz/Dub+dQMNt0oqRvwMAL7LIk43UtI6dZ+o/0YRCmJ3zTvn4f//h1In7VPV/LSlUMqCuPJE1NQXgkk3oE5MPiZxBvusNkYD7p8i04WTMDpBLSv3LvNMgd8+RhHsAfiKMGr8aVmIExAuznBB9yrxzobF5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Feb 2026 15:09:03 +0800
Yin Tirui <yintirui@huawei.com> wrote:

> Historically, several core x86 mm subsystems (vmemmap, vmalloc, and CPA)
> have abused `pfn_pte()` to generate PMD and PUD entries by passing
> pgprot values containing the _PAGE_PSE flag, and then casting the
> resulting pte_t to a pmd_t or pud_t.
> 
> This violates strict type safety and prevents us from enforcing the rule
> that `pfn_pte()` should strictly generate pte without huge page attributes.
> 
> Fix these abuses by explicitly using the correct level-specific helpers
> (`pfn_pmd()` and `pfn_pud()`) and their corresponding setters
> (`set_pmd()`, `set_pud()`).
> 
> For the CPA (Change Page Attribute) code, which uses `pte_t` as a generic
> container for page table entries across all levels in
> __should_split_large_page(), pack the correctly generated PMD/PUD values
> into the pte_t container.
> 
> This cleanup prepares the ground for making `pfn_pte()` strictly filter
> out huge page attributes.
> 
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
Hi. A tiny drive by review comment below.

> ---
>  arch/x86/mm/init_64.c        | 6 +++---
>  arch/x86/mm/pat/set_memory.c | 6 +++++-
>  arch/x86/mm/pgtable.c        | 4 ++--
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index df2261fa4f98..d65f3d05c66f 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1518,11 +1518,11 @@ static int __meminitdata node_start;
>  void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>  			       unsigned long addr, unsigned long next)
>  {
> -	pte_t entry;
> +	pmd_t entry;
>  
> -	entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
> +	entry = pfn_pmd(__pa(p) >> PAGE_SHIFT,
>  			PAGE_KERNEL_LARGE);

Whilst you are here, can we make that a one liner. 
	entry = pfn_pmd(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL_LARGE);

Could even do

	pmd_t entry = pfn_pmd(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL_LARGE);
but that's more of a question of taste.


> -	set_pmd(pmd, __pmd(pte_val(entry)));
> +	set_pmd(pmd, entry);
>  
>  	/* check to see if we have contiguous blocks */


