Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1681C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5896B0095; Thu, 20 Aug 2026 21:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55D86B009B; Thu, 20 Aug 2026 21:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C468E6B009D; Thu, 20 Aug 2026 21:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9833F6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:19:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 197F6A2DAA
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:19:43 +0000 (UTC)
X-FDA: 85123519446.14.65CCDEE
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id D214B20002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:19:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZvX+LbPZ;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787275181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGdDOkU52715zf2/WD7HSWNIZJ/R5i+/51DA79YiOoE=;
	b=HotTtkgYuOatwbMPpwFWBnxVrLllOlosHvX1Vp13b96/esDEsrfEaL/g87u6NuK/dHnWDy
	/p9joJ2q4EDzTlJk+PlGEjK9YjWrIdwo16CxANoM05l7VoDwVkM+LTkcYf5d8D9eTbQBDD
	P2PXUqOAGD78W0QCeEym+Nbr2ijwwfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787275181;
	b=bdZj9t+LPj2lLjLNyflk8BthbLG5UXy2dlWCe8W0nXnivtIPi5i7nrxzbu2CKvRrt7dGwz
	bwsI2v/8kc3WW19hHYEOyk+lRD/j/vOfnxXgvbEQnk89Jf2qrsQjCevYkyPHrt+6PT9t1M
	AWsiPI0z7Zkg4vxYHQCtHm953xZXSnU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZvX+LbPZ;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787275177; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WGdDOkU52715zf2/WD7HSWNIZJ/R5i+/51DA79YiOoE=;
	b=ZvX+LbPZIVu9O7jZ+Mz1uX1AVq8GkuX6jz5SSvV3dPWbSeYk8rnXP3lgdkMch+K4D64YBTcbxk/WkHlwBiZxBhxjAt0nNgocnnj9PvETF/QLvFnZzC6K732AKlCv100ONsbFe/YMTXaljfw0a0G7/ZFB6jXIckePelLG0fhnZ3Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X9Kfngf_1787275174;
Received: from 30.74.144.113(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9Kfngf_1787275174 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Aug 2026 09:19:35 +0800
Message-ID: <1bb6c1fc-ea6f-4b3f-a7dc-93012d1da598@linux.alibaba.com>
Date: Fri, 21 Aug 2026 09:19:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps for
 check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
 <DKU1AFIKNMNE.2A0JUVSTKHHLC@nvidia.com> <aodxH5Qc6_zVay-M@e129823.arm.com>
 <DKU6OCPNSECE.O9BZZWTSU1H4@nvidia.com> <aoebR7VhQH8kU-xJ@e129823.arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aoebR7VhQH8kU-xJ@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k96puojue83qiuutd8ru1z1h9miu6raa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D214B20002
X-HE-Tag: 1787275179-472267
X-HE-Meta: U2FsdGVkX18eRLOLPJ4gZEbkrN6C1ao+5E+QjIEbp5zkcAsg+Frj6qnFJWYAecJ92LIrbo3Rdw/oKryb/c2ku3W4BLQQ4vj2JyF/CVEY9VgWXHyBTjY9dgT+wtP/A/7ozQR8zTsv7mYFsKSvTZ/+FXt+D76i/SKoBMlPq3Ge/2XWMZ698C7ZfED6YeKNTG5xikaR2tszarir1/bL+AYe4+kB2leBbcGrASps5Go9e36GER8lRLpxLrSSwCI007Z4oi3Rmk/Nn1WpItGFVk8U9cN+8GSSuXzmBSEm7esc+TlQAjrij6Ulnrt7q2Mzg19+0tI2JBjD010npt5ntqR5vFScl3FVQ1nb/aQQwNTHYDu0U5d3qtfIZhPu5a9v9332oP1K8Xfhc8KYn5c9L/OrFPXqBhxpb60q7RFGC6OhPS1fS6pxfzck9eq8+7Ts2FFadwmJua2UcPWSewVhIUCwmnOYTs0mgUVfLkLnOuLEWqOlWtbdlp/7VMEFGnL7ElvYXIuVp+CBXh0GghQgD+jE/wJ0zHrmpU9u8DBy02AK5KV8QQ/F6qPF29+4bVsofeL+Jz8CZC3g8mk/zSZ41i2UqpriHZ6oR5EF6nYJZvq0y4Y01/GipuQn90UIUxWPdW0MhRC3XWwLTyCUfcyVBWeJFXU93gZ544mHD8ygCtws6HUkIP4uFrdgQH24t1rFOzfai+luBS7wEMarRoF7tDgSYj/7ohwOrgi/CDN6E+njmRr51nEMwFTQrJmhVjOiYZQksDkQA4cCqd5ZLVuRAizWI/Wlk3tUiuoBqlkX4xaxEWSDREeLkSEba5cmxhNQYxJO8QFFQCDtLzupQ8NVlUYAmR7a+9ZKCWmzCMA+AbVzwAG2+7cMp5z2pC8K1Lxfh1u4iIAV/Ud56mS8+H/513LcFjyGYZDxSNSAj155D9bz7fDwkyv1n1Hwg27glLpQOujOOGxvNy183ykeV2/lBoj
 0HEOLC05
 E2UatdZFPelkDz7ouJ8bycf/Wf6UDz+TsMPF/w2D1yIsMnWm/oKEorS81Z69Khxzf3B0S5ptP7BsRzEaioYD6R7gMUpIjRJUis8Qoj+Va0gVbeVNfaduR1SOtbq7lVl57KUoHP7i2V3x7YfOtflqhHIGMc1JGn4Gs6CeUmQQAaA8mVeE4hL4i6KK5s8fm3Zj1e2t7YQxwu5Z+8RUpGdxpwErmAxiHliMHMZPOyWOZ3pI6tzbOm650eMtlF2eOnQxeXhCqPUS5w9Z9smtbKoNPt9zWqqmpqqbjrEzEqyq0ZoceuSMJddziqve2cuhkAsm15wZvTfRGSU4w2kV7ZrmSppKQ8T9s7xkNdlQj/+LbuHF2OhRn+9lhRQsepVrz90pYm3oMM3l9l40WzIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/21/26 8:26 AM, Yeoreum Yun wrote:
> On Thu, Aug 20, 2026 at 08:09:12PM -0400, Zi Yan wrote:
>> On Thu Aug 20, 2026 at 5:26 PM EDT, Yeoreum Yun wrote:
>>>> On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
>>>>> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
>>>>> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
>>>>> made by memalign().
>>
>> I just googled the commit and find that Dev did that. ;)
>>
>>>>>
>>>>> The underlying VMA may start at a different address from the aligned
>>>>> address returned by memalign(). Furthermore, a subsequent
>>>>> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
>>>>> already set.
>>>>>
>>>>> This causes split_huge_page_test to fail because the check_huge_xxx()
>>>>> helpers incorrectly require the address returned by memalign() to
>>>>> match the VMA start address reported in /proc/self/smaps.
>>>>>
>>>>> Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
>>>>> /proc/self/smaps to detect huge pages and change the meaning of
>>>>> check_huge_xxx()'s nr_hpages argument:
>>>>
>>>> Have you checked Baolin's patches[1] in mm-new? They resue
>>>> gather_after_split_folio_orders() to reimplement check_huge_xxx(), also
>>>> based on pagemap and kpageflags. Does it fix the issue?
>>>>
>>>> [1] https://lore.kernel.org/all/cover.1785985999.git.baolin.wang@linux.alibaba.com/
>>>>
>>>
>>> Unfortunately, No. since __check_pmd_huge() in check_huge_xxx() still use
>>> /proc/self/smaps [1] for pmd THP, it still has problem though ths patch
>>> series applied.
>>>
>>> [1] https://lore.kernel.org/all/56b16691f605426b33b5cf47319233de6127a6b3.1785985999.git.baolin.wang@linux.alibaba.com/
>>
>> In that case, is it possible to use and extend check_large_folios() for
>> all check_huge_xxx()? You still need pagemap_scan_get_categories() to
>> check PAGE_IS_HUGE to identify huge mappings. Or at least
>> check_huge_xxx() in your patch can share most of the code.
> 
> Agree. but TBH, I think check_large_folios() can replace checking
> PAGE_IS_HUGE and keep the later part to check wehther PAGE_IS_FILE
> and SWAPBACKED according to check_huge_xxx().
> 
> BTW, Should I do this after [1] is merged into mm-unstable?

This series is already in mm-unstable, please rebase your patchset on 
mm-unstable branch. Moreover, we've extended check_huge_xxx() to support 
mTHP, so I don't think you need to change the meaning of 'nr_hpages' 
argument.

