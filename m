Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47C8C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6CB6B0111; Mon,  6 Jul 2026 04:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDCD6B0113; Mon,  6 Jul 2026 04:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585EA6B0114; Mon,  6 Jul 2026 04:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36DFF6B0111
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB09E120357
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:34 +0000 (UTC)
X-FDA: 84957725748.06.E51DD66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D6748A0003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGj65VGS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327712;
	b=IgfbNgAdqO+oz7653VILUGwGJHnWUMil+OpaJiDbHd7XmcHzw/0Ff/UOE0knCXIbvOBNks
	RFz+Zy/hA4xQAQY6BTpsayEzHlT/OfIWeFyVX7Hjt57qPTEY2oxszBg6vdmRIqMp0qtDhl
	rakXl616/NKijhFuuZ/GlbTvKvYJqoc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGj65VGS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lN3qfnGv2mWPUFitS8eH6rc3luHq/Jj38kDJNXJBKwg=;
	b=bjwyFJHQcgNpAvJjj5DeIBrZftAewesH1QXHWreMUHKo4cv4xvlPj6lDThy1HruTk8LApr
	AEDzaExcutgQg+Dyn2CXmY97X0nN1Yzcz8p8zJcvlToPmyE+otjEPpsoXzcnrCfq+A4tOq
	0PyXiPjDdeYuVQQOZM2Ckp4gDXBkd4M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED61143450;
	Mon,  6 Jul 2026 08:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6F31F000E9;
	Mon,  6 Jul 2026 08:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327711;
	bh=lN3qfnGv2mWPUFitS8eH6rc3luHq/Jj38kDJNXJBKwg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FGj65VGSdMdhxSSuTQdDhOaSiWA/zKrbfoat2AmTWZkxL6IwSsaDTuy0v5M+bMAmp
	 8OqoFSD3iopUyYQvnnGd4NF+YsDW9uVpHdaVltjQjlFM+JmDTyjnqawe/tAZDaCQsU
	 ej+lNJlviXjNtDjJ216p0X5rozammss/TTWrTml4Lq60XYrAqG7tWdIiim9nmRnsyQ
	 hK7X8SB9sCkcQPYjSlK5E4WhEdN7iGlUoWcdcTYKBHe/b+Ui+rr4CeHMdU9fhsAEpK
	 UlLEWBDkhSy149BWGidGDV2UMm0m57ByTSgDYqoo6DZbqTQhsoBOQER13AkPFDKr1K
	 2cdp4uQbIefAQ==
Message-ID: <41f08ccd-39dd-4b69-8ddf-60da848fef6a@kernel.org>
Date: Mon, 6 Jul 2026 10:48:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] mm/mprotect: use huge_ptep_get() for hugetlb
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apopple@nvidia.com, rcampbell@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, ak@linux.intel.com, nao.horiguchi@gmail.com,
 mel@csn.ul.ie, j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
 dave.hansen@intel.com, jpoimboe@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-7-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703114202.365553-7-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D6748A0003
X-Stat-Signature: mu9864orhecjt63stkf6r9w74q7bcyto
X-HE-Tag: 1783327712-893531
X-HE-Meta: U2FsdGVkX19uoYCMhIDVndLH53jS0/RKG3/53gcIN1HGzLYAQ0Q2ZodCVqRjVvg4ahSaAPVsWv5SxteACIpuiIb0gU2xFCVb4ymGmuDc5sQQZ9p96IILWl9QDVyD+obb/lJv05+vbfkpaM/JBP3HcE1QR00wSI8TqdiVgvGP3/lT5RAYYZLTvDglGR9cJWcPWhxFt4C4tUl0hnNLzUE0WqCdfeUi9lSMANnJhcIjPEMSFl3jT4L3mkPkkBojGA++w/38IFgDnrmX6KuPQ7H9HmAxgEFktspHxD/wXu2GIJfTURHtISwhhhHHllPyxv9G5tTqwjfkfmn87f3leIWmEnkFhmzRgHvRVj5VSt2SlHuUiJ/TWuISab/KhE4dVVybs8FDSmE1MjIGDOSWe7XeVS/abhEEoIUWZXsKnUS6FYb4F1+XutmyuxJKARP48yX15c0uGY1Oz2Cyq9G95rhT7+WsL+vcd5QMvWfTVCWEH+eGE/faEzqWH6WzBu1kioA2THHrSyKDuqwwHGgOX6k2qihBKZErSIjx8hqDadBQRN8bMzaqoQzqBFHE3sH/OjflRDqe8E7A6n80XjvgviqCl48+BJuSebpSGHFbZsU5zfMH8+BgH1md7i3Pb1vqZgm3C6LqtJ7h8/Ly7fKW9S9+Rnryw+ypNIG0cH5sjgzbe3gwNih9vIji7wJSwydNqekDHnYv3nZeJsZTdITautSJCSUjZez1nHTDowzJnzc5iJA1/obhSiAVkIk8mkbfZKmmErIgdFdVN5kXUgp0m+w8mqsp2Wd1u14xz5Fk+wfzGTE+qff8bsKHLAtjfHNUQYfOfrHxdGhQ341KjLAw2fuTle1WA4GV5qmAmDsywV8/rpIi3mDEIA1Hrif00qOnpS+WlD64mzkuxrZa5lsU+Cy2uYtNRWECH0YpTS6wyAlOnjkv9QJGNKwixVYB5te0qsI2eq4QPtJYObO+sAR1kXf
 QbXhIi0P
 2jo2HPpP5DCVNf4LExfdzOmaauN4ZvFAREBbSm7WoqCpjQdwXpmxphv3lOGkdt95JfBXe0fBt3DjzVOfOtozReei71Lpc53DMr+1p6QnlYOLlbf9wyypaYV9anwpWy1+KgP/kwyRN6ctgNer3YwDivUDZgb6JL4LkxGMAxa32L+2DMc1+9Y952dgWmjaf88Oov8P77CmFWy+2PoGlNjl72m2C/0rmmhSegkaSh88zvBvyl1XIiled+Y7tRuU235P7jrpPEaKDjvdMhwiRzimYtZen3O31S4YGadU7QW+dr5kO3JgCYnc4gW+nJiWXBWXJDc1zygBNlfZzfwqxKOiteLLEfv5X+3EkN/pw2mqkh4MPC1GoZjY+g/JQiOVuwrQlbVYGfK0+5lZcuVblfk3qjvreIN7GCQEWqvRuO6Fjm23OPhoaw5ihbfyu93tr+E2kQ6Q9CXAufs32jFo6HLCac0FCQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 13:41, Dev Jain wrote:
> prot_none_hugetlb_entry() is the hugetlb callback for the early
> mprotect(PROT_NONE) PFN permission walk on x86.
> 
> The callback passes the decoded PFN to pfn_modify_allowed(). For a
> hugetlb callback, the pte pointer refers to a hugetlb entry. On
> architectures where hugetlb entries need huge_ptep_get(), reading that
> entry with ptep_get() can make the permission check use the wrong PFN.
> 
> Use huge_ptep_get() before decoding the hugetlb PFN.
> 
> Currently there is no path which can trigger a bug: huge_ptep_get() is a
> simple ptep_get() for x86, and the prot_none walk occurs only for x86.
> 
> So no need to backport - use the correct helper anyways.
> 
> Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

