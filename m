Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE66C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0DE6B0155; Thu, 22 Jan 2026 06:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488AE6B0158; Thu, 22 Jan 2026 06:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5116B0159; Thu, 22 Jan 2026 06:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE216B0155
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:34:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB8EF13A701
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:34:38 +0000 (UTC)
X-FDA: 84359392236.18.3137443
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 465354000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:34:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CDDYiCVY;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769081677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAlXGRAOWdN5cZQVeZGpzPTXjQW9FuCmk9rlk2Vtu/Q=;
	b=KHMsjojj7OtPdE0hbl79ZXzON8SVK7mxVxnfkX2tO8xC/vQmJnkFpNCPjJ9qqvkzP6q4KY
	WdmteIbv8Kc9E3oSA9PJD4QSdSo3lkpW5ydk3rStEOV15uy0+ZfC/bRzNcFKsan6fvoiT3
	fn9WF162KtlI/PFKnNNpu+THcfhShDc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CDDYiCVY;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769081677; a=rsa-sha256;
	cv=none;
	b=HshFZn7Y/9X4I/IPojSyuFuI7DpULk8jkt/o5cYffStcjUKVBL/whXBEpUUWilzHtCwZPA
	HKh9rJZn+XeUAVJyU6hI95D4TbQbrbM0LBviEBec1N3VsK1/0VLQQFvcdKSWcFtU8c+yJK
	dsO/kKKd9mlIWp0PzglgZ2/Zpu7LPdA=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769081672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pAlXGRAOWdN5cZQVeZGpzPTXjQW9FuCmk9rlk2Vtu/Q=;
	b=CDDYiCVY6QsNHYrCeNyCnlwEgO04Zp8lCp7iBZj/D0AavOSFt3s7SB3NF7gCf1jCS//Dsv
	Nvc9YYaA7xsbHWj00ejRnoNoT3OITFXVEYDHq1YObWXlsRYHghcBpcRDg2rEwgyaXNu0hb
	fh2Vbua90N+/PL0ZP/F85ubU06G0Hgw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aXIJY5irR0obgdQe@thinkstation>
Date: Thu, 22 Jan 2026 19:33:51 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <35B81EA5-D719-4FC4-93C5-674DD5BFDA4F@linux.dev>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-8-kas@kernel.org>
 <71F051F2-5F3B-40A5-9347-BA2D93F2FF3F@linux.dev>
 <aXIJY5irR0obgdQe@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 465354000E
X-Stat-Signature: 358f1fw7nae1opfxzuuwuopgyh8m6kr3
X-Rspam-User: 
X-HE-Tag: 1769081675-280061
X-HE-Meta: U2FsdGVkX1+0d2Etd/Xux/usxizBm87F3xgSldXJQzdMkWBzPOoRM41eAGYXwWNp8LIUmGBpM7orUnoUt/azPb/dLE98Sl0JgC4SUrG4sl8/kmDLLGa7FAhDNyxeqTtfWhIGA4GKfXC7JLna4sT7ykxQGooWUV8uFcpWIf8/HB6e8XdsXTP4ee3CdK+2b2uh69bWsABxtcYCKg72EtcaHu1MUeLCR/HvQcKq44hCTKqGuZglM0PsnBFSuP1CxgJxEQlFGI216wy9HjGSOh1dUGaiebxCCatA5LjLvXrzFLu3BXYA8koYOcKDUddUfgSYDUEsLbUfmfsl9I6Tf4xwY5xvaQyp+lfzVZpqFOlETc221iqETHKHmPCphE6ADRYOAk+CzcJav6XZisX32BqixzbOBEBESZM79R2qUL4k7cjvN197kFQSu1e4XQrYYZb7HOAD4dGOgnTs0GRLEtRGnpvXULr34uLAFmZKokgITaGlD63RtAciZURI4mvNh2tnPgdS0V59afd2ajFLfkUStP6dDUYtpQptskF/n4pHWr2A5nL5jDLwNllg56JnXklniMKCImo8dRAaHsPycpIey7czhoUNfRNItuGaKJexPOTZnTCWEcdaZ0X6VkrcdUlQjqQjnQMQh7hssfd09s+MVIpfNjFIew0GYfeh2Rd37Kt8b6VUY2gAGGPZv36DWCyY0f+nHx6xRMmPlrf3HWfvZ5b10oMXpxPA+n3cpArfAiT8WXJJEGVOQAqGkwzEHQeg1gU8UIKle4Lxbzj6GFlMZWrOyJ4mD73egbQa8Ndm4URA6mP4LNhV9wItQ3inWNsqghUKVWttJGi4yjgwDRjrpCrD/nUD71EGYn/pTpEkZG3gdEcXz3rLOOiHw4PNk0YlblYqxfB8mv5ReG3bMeQWi34bmgeoZvdAPDBxQu7ZX67eiDrBhEX2KY3o8OWTHNHqzlnSte/Ci3nYHOrHHVo
 w8adXYUp
 7NNz51T46apIfaDSYbIF8Ngo3QOOp/e1L84S+s47JNpYuXJYOksodhwNvtpGPh+ZLO3iiebFwHQnBfO0HIue+wBHWckk+X2MotqfmoUfb8qu/XuJhuCqceBiFT8PaVRcE0guaTK4d6/uS9hmtgGF1GuKDFTAaR/6pk14j5dsS7m93nSbVK+qgv1ZNIQ+0/kX58hdjedsicVPuTxIp+lNkOTmREPsrPhnF+rW1VnrdGDaxqWdLRyidVd64gH6dApobkc8uV9Bak/b/vd6pYIwfMrstIx4tFg7DuvicjjDtYoEVDwKvwYwhPnD9+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 22, 2026, at 19:28, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Thu, Jan 22, 2026 at 11:10:26AM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>=20
>>> If page->compound_info encodes a mask, it is expected that memmap to =
be
>>> naturally aligned to the maximum folio size.
>>>=20
>>> Add a warning if it is not.
>>>=20
>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so =
the
>>> kernel is still likely to be functional if this strict check fails.
>>>=20
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> ---
>>> include/linux/mmzone.h | 1 +
>>> mm/sparse.c            | 5 +++++
>>> 2 files changed, 6 insertions(+)
>>>=20
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 390ce11b3765..7e4f69b9d760 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -91,6 +91,7 @@
>>> #endif
>>>=20
>>> #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
>>> +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
>>>=20
>>> enum migratetype {
>>> MIGRATE_UNMOVABLE,
>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>> index 17c50a6415c2..5f41a3edcc24 100644
>>> --- a/mm/sparse.c
>>> +++ b/mm/sparse.c
>>> @@ -600,6 +600,11 @@ void __init sparse_init(void)
>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>>> memblocks_present();
>>>=20
>>> +  if (compound_info_has_mask()) {
>>> +  WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
>>> +     MAX_FOLIO_SIZE / sizeof(struct page)));
>>=20
>> I still have concerns about this. If certain architectures or =
configurations,
>> especially when KASLR is enabled, do not meet the requirements during =
the
>> boot stage, only specific folios larger than a certain size might end =
up with
>> incorrect struct page entries as the system runs. How can we detect =
issues
>> arising from either updating the struct page or making incorrect =
logical
>> judgments based on information retrieved from the struct page?
>>=20
>> After all, when we see this warning, we don't know when or if a =
problem will
>> occur in the future. It's like a time bomb in the system, isn't it? =
Therefore,
>> I would like to add a warning check to the memory allocation place, =
for
>> example:=20
>>=20
>>  WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / =
sizeof(struct page)));
>=20
> I don't think it is needed. Any compound page usage would trigger the
> problem. It should happen pretty early.

Why would you think it would be discovered early? If the alignment of =
struct page
can only meet the needs of 4M pages (i.e., the largest pages that buddy =
can
allocate), how can you be sure that there will be a similar path using =
CMA
early on if the system allocates through CMA in the future (after all, =
CMA
is used much less than buddy)?

>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov



