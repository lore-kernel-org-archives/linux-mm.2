Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCBFCD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 05:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917AC6B0005; Wed,  6 May 2026 01:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8B66B0088; Wed,  6 May 2026 01:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE4A6B008A; Wed,  6 May 2026 01:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC286B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:11:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0019EC25E9
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:11:58 +0000 (UTC)
X-FDA: 84735823116.25.6E315B0
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0230D1A0004
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:11:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vRPeqtKi;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778044317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yjv1YwoUlV3YcbGhSBZo4j1p+egaq8G4dSfMBztXKz4=;
	b=JTMu/EE/s6uOgFBQ/ZZJ109W264am5FZ4N4t3TiU6p7hZ4RFqw5JaKO+lWTxJZr9QNsjvW
	IdahDmhL+/9qJ3eTQvjPU8zHmrxl5ZU925fRfiBBumALYUOiLMS8Z7wqi1WpbpFHg239oJ
	XWHNP0Pk0D6aA7iiQ3nFL+S683oHYGw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vRPeqtKi;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778044317; a=rsa-sha256;
	cv=none;
	b=4V6UX7Pyu/ONOa62z58DG/Ry4PW2T/v0KVdN9jEtROblLe81ChFMufJIn36mHb1qHC+8iR
	BVD8up6vllQnC90xnY+z9IHK98uDvFK18lgB75lN68h+Sq6pqSX/5V1v6WnVDriLcMzgh8
	KUBLmINLDFrtdk1TWJgl3pIATUwQza4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778044309; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Yjv1YwoUlV3YcbGhSBZo4j1p+egaq8G4dSfMBztXKz4=;
	b=vRPeqtKi40CfXuQctLCccjheYhEbuCq7JvDrWSlgynnQ+uwVBE8ljukxKWrP1i5izmzcyyWuDJVIdF8URWvPW3+Wulo2DpCbSsEJS69mpTHYsobtR/JHkmPeCym3suJDWZmTRcVY2Pgg8+DFCHF/0xNAQc+xzdo6dzj+DK7fPoY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X2L9Eve_1778044305;
Received: from 30.221.149.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2L9Eve_1778044305 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 06 May 2026 13:11:46 +0800
Message-ID: <1a5c8084-c244-455b-b999-f110fc9e4749@linux.alibaba.com>
Date: Wed, 6 May 2026 13:11:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix __vm_normal_page() to handle missing support for
 pmd_special()/pud_special()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvador@suse.de>,
 Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Bibo Mao <maobibo@loongson.cn>, stable@vger.kernel.org
References: <20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0230D1A0004
X-Stat-Signature: muac6go8sqo4ttht1urpxem1x488aek1
X-HE-Tag: 1778044315-287933
X-HE-Meta: U2FsdGVkX1+ZPVts/oQig5kAtZPOtYk91RRX2akr5XMr6QwV+iHjLdZlXxSzO9Gla2GJ+fG0aeQtQuerSkFVsKpa0OJbpoZUpByDJYzJIOcVwL35CYEQ9RWjgYXUGS9g5N6+Sdgw9HiQY6fIX9lnp/G6wIfbQ3F56wKkMJuiT5B9dw3Jl4lK4MO30mznMvoQJu0ckFamnEieD1iEh7sENnjVmeeLuLWmIibL9F3nzT5Imtn2+IRstcv6ZqzTlzstWAssakV9s6xgppfRepFy/RsDJmedBSDB7JVXksih2TUTPGJbj8yWe0sYoyQgMHuwMRyCe2169eaFDFo9mGvPIq1HgRXWZd7bhGrB4i4pD28yGfG4khp5Xwr2j7eY6TPIRQE1yRUSh7mwoEl0aHTZDgxqLeVPwDKvlI0QJKvhyboBW/3pLrznpVS638WX1Pgj7pPpJqACthl7SrrXGyO2OMg3lLWQ2FfPIRNjmi+CSZIYJbIqeIZI5SAItem7QKG2iZhUOqQ9n09WDapKnsYSRm39cs2Can67LoeFbaAPRglwoyCb10e3jW7hJCARQNX4UMmkg51NEMI/E54TMhtzCg9YBtL/f3skVKSFeqclPz2Y5iX0Bgsr/1R2IuLqrRrvWpj8QEBpNZAclgPkS8Hn8uR3aCGnZ3ErcHlV6r6VgDgxxb7dsS4wnKve9UC4BBaLmDGTjXoMOfgscY/cepR4qg/LEp0r7LTbO6aCWcp7liKcmIcATO43etj55u8+62AWEV8PDg/rnkNEhjvE1dVw8Z23Yr4U2P5ewFgSbCMiqHI6n+v7P5bG75t9NwHT8KppzkWSfvjTwnvy5SzV6JjKBGN2NeqsQGmi0xwmYp4KGD0iMoKYfdhjCyZq4h6jTAJzNsbh3GyMdjpwFG5NgrdxFuf4S+KtDyEAJn4BdMUOpiAjd/scmpzOsm03xu/rU6PCYYOkNYoo6BDmJtHJS8w
 5NzauEFk
 dDUlkeNFaB2b7DHdln55nkLydeTa0c5u4x103nuBw/uN7Hutg0duztySeDseVy+j3MazBimY/L6pBddCNLFLXRViOHnWadgufArxwxZWSOQwiHxowTH1LxGVMKU6E4x0tjzR5Yf/tSG1AY8j6bxZB+IWmKyq6q9wq8TmkTSJxbXkQoUQyl8rM5QWHCI9G8BP9AN51jDgJdMlutXClspew3PFvdSzaohXgTBwNRF7pOkmyfvBK3DXTK0PImqd1tiM9HbWJRwBLBAQ9RrrLMjpZ3KEube3HlXnrEuLQt2S4+kpGDDv/mqtIy4Q7fAukC/XrgRXECECzeVBYAAMu7iRKtOSz3xep4tgPL9+lcRI3llNx2pW18NV8sk2Bg7ULj7NYE3yIklPwcYTLRvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/30/26 7:31 PM, David Hildenbrand (Arm) wrote:
> On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
> "WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
> VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
> by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
> when reclaim gets to call shrink_huge_zero_folio_scan().
> 
> It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
> and indeed, whereas pte_special() and pte_mkspecial() are subject to a
> dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
> are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
> on any 32-bit architecture.
> 
> While the problem was exposed through commit d80a9cb1a64a ("mm/huge_memory:
> add and use normal_or_softleaf_folio_pmd()"), it was an oversight in commit
> af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> and would result in other problems:
> * huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
>    numamaps as file-backed THP
> * folio_walk_start() returning the folio even without FW_ZEROPAGE set.
>    Callers seem to tolerate that, though.
> 
> ... and triggering the VM_WARN_ON_ONE(), although never reported so far.
> 
> To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() to consider
> whether pmd_special/pud_special is actually implemented.
> 
> Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> Reported-by: Hugh Dickins <hughd@google.com>
> Closes: https://lore.kernel.org/r/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com
> Reported-by: Bibo Mao <maobibo@loongson.cn>
> Closes: https://lore.kernel.org/r/20260430041121.2839350-1-maobibo@loongson.cn
> Debugged-by: Hugh Dickins <hughd@google.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Bibo Mao <maobibo@loongson.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


