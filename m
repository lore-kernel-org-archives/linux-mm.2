Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA1ED6409F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DB46B0005; Wed, 17 Dec 2025 04:26:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F17A6B0089; Wed, 17 Dec 2025 04:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFE26B008A; Wed, 17 Dec 2025 04:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BED46B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:26:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C98FF13BD83
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:26:24 +0000 (UTC)
X-FDA: 84228432288.22.3D90202
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C51B180004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:26:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765963583; a=rsa-sha256;
	cv=none;
	b=hZUwCqax25Q4AClF4KqgcpxbuczQKyUU2bgmS9kZcgZDHN29JIlAyQ3JsGG51ruS1yFrDk
	iSIJGS1U0xx2ly9K/BRH4m89Qado+hc7g9iSydPobmPFuBQeD7E/URvjWeSUnfMaF0hkdt
	1wVnFmiMxepoK3NOcKJLXPqDJgefdWQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765963583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZwihpIkffId1o87zl/G9jlo/Pzu9AzPacFtF7GHeHUE=;
	b=2mOfmE5HEsHysaIhXJ55pkeNNk7gwn0DmnxbnuXkTznSDGn4jECwSgyG4IsCbokkPj0RMa
	SEGPRead8OQTiPH5WiudhDsdVcTZH6eNqDc6v3JZ53jqyeCZ+zEsllFfill04egNcVkBAy
	cqRVizwc5+NwLGUyvZYVs7kV5JSEc2Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B975914BF;
	Wed, 17 Dec 2025 01:26:14 -0800 (PST)
Received: from [10.57.47.3] (unknown [10.57.47.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA6A93F762;
	Wed, 17 Dec 2025 01:26:14 -0800 (PST)
Message-ID: <f9550d22-8810-4145-aaa8-48961f6ea35e@arm.com>
Date: Wed, 17 Dec 2025 10:26:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-15-kevin.brodsky@arm.com>
 <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C51B180004
X-Rspamd-Server: rspam10
X-Stat-Signature: csmrkihu7ptk1fy96h5t9qzfgr6tif6u
X-HE-Tag: 1765963582-834299
X-HE-Meta: U2FsdGVkX19wUvSZ7NBLl8XjF44m/f5b7vacAlZoeMhfN6X/viS5kqINk3tlejU/0r1QHMjq6vvvH/G2ehmG+I0oH1d9AtAnVlDCeW8qfWwARrTJ2J5eo6HXn+XRI2NmUeShb4Xt5rwoysciTrfp5Tg42TUFnf0ix0gtDfTjYkGaS2tHfTnTMIW501Mu/vX9VKASg77dTynFYliNTGifxE781MyEhXw021cBqs/WaKZBthXsKIa9VYR12nmQlMvKeI+aDOh+ecb69ip9p8/czEb9RSY1o+IdD7wgwlVTvamdFSYn5a1miPolaFNFyZH6pjD1E1RNqGvP4/Qt4DbOJcXmVSU+EbgZ49EOG1/Xw0V6YEJcHjlJ4xNmzeHPfK84EgfaYf0gBu3m0O+BQgjhzXVodo5q8H3boAC+8IiwpPIqLe37xSg/vSLaga11zICihAZg1MM0jfOXf8Jn9xEMprItjNH651G+nB8pVgwVoFXkf+K9B5D8QCkDV9YlZgFmtH2KPkyRnQc2czjCMIF+Xn4SgzaysXd2g74Zdov507//fyYevEgc708bEblY0vHM70ZmcUPQVRY/XzeFt/tLRu9GaOVPHodPd43DHaOG8PBGxtyB64cgxqmVUiqzzoHkQydhQDD2HZd+DfGFUyjx6dpnxLufli4iHjf86YOtLLjBxFQksO/C8xwcgvBMBC9ith8eKOWKqTyMKRBZQLOtDxSGBogtkE1yNfPVxqjjKCPz0jZyDwHV+m+ChiwJ5AS9VrsBJm9Hjh+GQO6iihm5u/EdqinOzjX36csCE5kN8QQH3cC0cqDVp44dXwEQhBGsYTHSNqL4OFKeDW81N4IH4QCzOKLjKi/OeCJiA5oVvtjptLIwRMQVAufapRmm6NsEPbN6laFBGRV6GDfUipBL30RNWADisJ41OLDHT8g1339ppeCdH8xgvUd166P0n1rb+nKA+zq9EBJTGiuAFH3
 s4CJDbqB
 NFzAT+vJ9gXTOt8G2e00wAf4xMsPhuLaUe/JapOxCR8x2/pOCWIkl9K9+RcL7QmnUIPrke5AKvQnFWDW9K6jrKgWbReSM5KWZyj4KTk+vfVOjWaFOSXlKlWoej7KrCXDZkE9c2YTyeCP1qIjB4eR6/257DlPDg/qhGYAeU+e4GGRQlwH80sq8sjkmATSovH7JixOaaEItMWoBeIE0PPQT7aqnQx7MIuIsZprUhIuh4zgTNPTfxmDV8HqwO1KM9U845YL9TcYD/N1YGDIWIhFV/WT1y2rZdVSTWJDSakCtYgxvQJbdtyfD7fu19Nqm+42Q/fX0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 05:14, Andrew Morton wrote:
> On Mon, 15 Dec 2025 15:03:23 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
>
>> Add basic KUnit tests for the generic aspects of the lazy MMU mode:
>> ensure that it appears active when it should, depending on how
>> enable/disable and pause/resume pairs are nested.
> I needed this for powerpc allmodconfig;
>
> --- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu-fix
> +++ a/arch/powerpc/mm/book3s64/hash_tlb.c
> @@ -30,6 +30,7 @@
>  #include <trace/events/thp.h>
>  
>  DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
> +EXPORT_SYMBOL_GPL(ppc64_tlb_batch);
>  
>  /*
>   * A linux PTE was changed and the corresponding hash table entry
> @@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
>  		flush_hash_range(i, local);
>  	batch->index = 0;
>  }
> +EXPORT_SYMBOL_GPL(__flush_tlb_pending);
>  
>  void hash__tlb_flush(struct mmu_gather *tlb)
>  {
> _

Oh indeed I hadn't considered that arch_{enter,leave}_lazy_mmu_mode()
refer to those symbols on powerpc... Maybe a bit overkill to export
those just for a test module, but I'm not sure there's a good
alternative. Forcing LAZY_MMU_MODE_KUNIT_TEST=y is ugly as it would also
force KUNIT=y. Alternatively we could depend on !PPC, not pretty either.

- Kevin

