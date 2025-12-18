Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CB2D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ADCB6B0088; Thu, 18 Dec 2025 07:52:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B116B0089; Thu, 18 Dec 2025 07:52:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DD16B008A; Thu, 18 Dec 2025 07:52:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 656126B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:52:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB3655546E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:52:55 +0000 (UTC)
X-FDA: 84232581510.22.FED70C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C92E1C0005
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:52:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jvIZGS7s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766062374; a=rsa-sha256;
	cv=none;
	b=2jBJrfPzY6KSDSx121HKn5ApbN08GSijGVYzteBgjO+3FSssqQomnnU4t8Abnr/Fl1a6Hu
	fpJzUyJyE7s2A0vLMidgoe3TESsQTVHiWFHRrFPRDWgL5Wb4Ww95MyPhLyN0VpmFn8mTeA
	UbH6I07GPe7vd57sBfBw3iZYaU1SoYw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jvIZGS7s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwuCcAbyOJ7qnpq5z4Eo0OHX/cjx0MWwc54BwLt4sIE=;
	b=C3Wn7a0hhPb7pCselB5KZ11lzbTiqMrWCvZl5cI2TH3uYczFDXH9/Fva5l583Fu+G3SdCp
	E+PkTXgzHGZV6/Xb9ZB52NWgvJALTwjIENL8LbPKFB3A7NjRU8N9E2llZv2cx4G9KOFl+q
	I8KGQx99dSb3vB+b9PzPYGGx89YVwKI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE8FB42BBA;
	Thu, 18 Dec 2025 12:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38B5C4CEFB;
	Thu, 18 Dec 2025 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766062372;
	bh=4PcjO3AAv5DkTbbnZnTkTeokRBEqI4f7EfDmqqxEmUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jvIZGS7s+QzMFSaoNVysN2TYamdUXJ6Jl2Hq+DlBuaQ9w0DqxheKIKHVn+qEvL9CF
	 MXJDMfIJBmMDBzJJpSSiuu09BHn41tV9pd5zPSsNpTja8mk2kIpPLDz8e4l3M8N840
	 EPq6EDrm+IhG7D6GU/Vve8TalEjb0lT0M/XQ+LbSAJvC0SPXXs5cvIdoORRCayMpE7
	 acTa7HIVMGHHyDbSKEbYR/MmJXmAGB6eIjQ/cFcSuibOY2j2GTqsQn3IoGwubJuxFa
	 aKjPd+GnmBgBfCGQ3piUSHEfdmomASe8Y68QKAD6P74ib5NrZXSE7Bu0rw94XhWYRP
	 BUePV3JMHVoIQ==
Message-ID: <e10cf4de-6c00-4ed0-a1d4-d8e719f86a3e@kernel.org>
Date: Thu, 18 Dec 2025 13:52:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] mm/hugetlb: fix excessive IPI broadcasts when
 unsharing PMD tables using mmu_gather
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>, stable@vger.kernel.org
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-5-david@kernel.org>
 <c641335e-39aa-490a-b587-4a2586917bc9@lucifer.local>
 <9ac7c53e-04ae-49f3-976d-44d1e29587d1@kernel.org>
 <07e8b94e-b4a1-4541-84ed-a5d57058d5a1@lucifer.local>
 <937a4525-910d-4596-a9c4-29e47ca53667@kernel.org>
 <4037214b-d1c6-4e0b-ad9d-6722aea7aba9@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4037214b-d1c6-4e0b-ad9d-6722aea7aba9@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1C92E1C0005
X-Stat-Signature: id6175j9kazoxsicerp84im6wnt7cd7w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766062373-810167
X-HE-Meta: U2FsdGVkX19t/MdOrMYqfxldFDankcTyS3OxXXp9vzCfx0HkZmbbjNfaKGqV7zovV+uEg83oq3J/sRxjMI+HMxoKD5dmLDuikaTJdP6Y/7XvVgC7tL9N+DjVsINuOhqngBeMkck7hB6/1yENkXzN2iI5fJDnsT3tOsX1y5pTx+zpJZgKT0CaHRjEv4T3jNfmR1kexuAxU8W8yiRmCFshgMiDUXV9wLIS26grdN6n/Gd8Ba11UKoMcAnvwrNM7GYg2dGnBikvOGLRhxulEZhxK3s11nfbnQTkrJMgSurmkEnIZod+/LyFLNStdmXyEqt7/p9WjNQ9MbTluKQhOA+nhUNtIC/cVZu2e7hdnPJYMaOhlHQGaob06nOosMqGbcGxnbbLr7Tg+pA1i3bE2ll+PtasmWFrGfIWqBHn3NAUfixN+/CUAzFLSlOEuSsvxWTjD/SpyU7y2GxbXZYyjyAfVLvf+B7HBqIAlqZuYseBpapaBgiSIW0CVcLzL9NBlyhW1StPg6oRkxxZk7Mmp/UMZDh8dOlp3bvVBA2JLwLHq9w8jqgRrHaBBdgf2C1sTahJApkDtD6DuRS7OgS2dgQMQhIDb84u6o9Vn1GIKvWQOnoTpI0qwEcHh1B1W4BjJxi76a8AwVTVNCYV4DIyCrRGxf4avtEs5B2oU5KNF+TQQRfdZzlBpb/Vg7tukv8Dy4pwk80GQimqy/ENnn8KDpuadechLRAT4996PrxD1yccf6GFyJzktgCdW2DLhso/7N5zKMeEDTODp/bKgiDK+kj+YhLh4XeeCNX5EzXONULzCYDspLRq7P9PbsYWkhkx9qVI4D9ojZwJazccZW2zHu71SrwvLjZYqTCT8U7KTdZ2aBs44DF1FUeFpLGsufE8bpKhFFxCzygwnU5WkxBAeOKwYASTzOJ3BYqJ1IFwdC5kMcTt2PMLCaajbPiKFHQCH8i/LmNlzg1M0qUsZzy99SS
 PAvHi+ac
 4xe/UXdmpyWAMELidzDQ/2UWJ8C5e1f+t7x1lUIvxe3lLtHAYWZSq7DlHkm9xIgJ4I1hj6xalUTvtsN4epsIRopSDwbwrZMqL51lbwXF5fEHpzNEenKCGzyXidlqnYfi7BIGwYzWCsPniiIiof2sm9Cs9q5TnyWlXEaQSFBcghxzFPicE6qSKlr/7J2heMbfeVgdOgtum66/uuZKF9bHyUjnXm/72MP0GGvbEDw2BOxOQzcJ+ZGJ3YEAb6ihL1RxK6tADaAriWBpqFJqTE2QtKrtbZbG18uGHUHo0bXlPgrOlW1TChJKrjfjUDynYzSie5Yb8Dlu6V5plvTQJ+Z5xoR9GjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>> Isn't really the correct comment here that ranges that previously mapped the
>>> shared pages might no longer, so we must clear the TLB? I may be missing
>>> something :)
>>
>> There are cases where we defer flushing the TLB until we dropped all (exclusive) locks.
>> In particular, MADV_DONTNEED does that in some cases, essentially deferring the flush
>> to the tlb_finish_mmu().
>>
>> free_pgtables() will also defer the flush, performing the TLB flush during tlb_finish_mmu(),
>> before
>>
>> The point is (as I tried to make clear in the comment), for unsharing we have no control
>> whenn the page table gets freed after we drop the lock.
>>
>> So we must flush the TLB now and cannot defer it like we do in the other cases.
> 
> Yeah I guess because of the above - that is - other users may unshare for their
> CPUs but not unshare for ours?
Yes :)

It's all very complicated, therefore I decided to rather add more 
comments describing what we depend on.

-- 
Cheers

David

