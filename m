Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A57ACD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A93A6B00B3; Tue, 26 May 2026 08:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433476B00BB; Tue, 26 May 2026 08:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321B26B00BC; Tue, 26 May 2026 08:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D09F6B00B3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:59:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D83FE161621
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:59:47 +0000 (UTC)
X-FDA: 84809578014.08.181C0E0
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1AE43C000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:59:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7FFtse2;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800386; a=rsa-sha256;
	cv=none;
	b=aU0H/tdsVf/LqDjoDJUZ096lm2o4yhl0gAcBmSfO1vBJBzXQRuzE3kZrRpb6WONy34QLVH
	jf+UeUutt4d+24jGkzYJnEmVKX7ZISK/K3fLpcn/RHi9wDpzTbrz/juWMyEtf1SqAZl9BQ
	9c9bj1fGTeh0bWnG9S5C2zIvJswgOlg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7FFtse2;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHTwPvQeI3NSDvgqwGcFB5R2OzdXWrLDStlSCxXrhzw=;
	b=MxjKCaulLVotqTNw4GB6Qqkj2278ckXED7w4sP/Srk6MzFELcmiBVInfe7pEF0IYV/XMJO
	/pjFiuQRgmLyjsTBUIhRRa3WeQe++eqdTo7ke6f8j+lM8PnlpyfQ3QSZ5/CSqhOrr2yxyG
	SXEfH8MHXsmtb7FuT/OGIA3NJcQ7sE8=
Message-ID: <206dc5f5-0278-4100-a595-4923da30b900@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779800384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zHTwPvQeI3NSDvgqwGcFB5R2OzdXWrLDStlSCxXrhzw=;
	b=U7FFtse2S1tSBDZwOBMwS45HA/T/U66Sxth5rABgqKjubFtl2vU6dpsX0Qmlc/bJREFOAz
	gC1FAbtntfPKPXwn64hsVo/1QECyy5ExehlKkQCbkKC1jrGg9ycUOLOxrbNuvQ1zMGs0uZ
	uCjD7KoU1MaCgiSAp57zhZZFcHAOB9E=
Date: Tue, 26 May 2026 13:59:40 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mm/cma: fix reserved page leak on activation failure
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Frank van der Linden <fvdl@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <ahWJMwG8xoQli_Q0@localhost.localdomain>
 <9A340644-CD8D-44B0-BBC5-43D29E9D046E@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <9A340644-CD8D-44B0-BBC5-43D29E9D046E@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AE43C000D
X-Rspamd-Server: rspam03
X-Stat-Signature: e8km8pzctjfga6kiaugukefig7ghpbau
X-HE-Tag: 1779800385-710032
X-HE-Meta: U2FsdGVkX1/CQyq7P4yadVx3KbpaDm4WSNW5p2EnqvaLK1ueY0Pztvsh0guVN6UVe9kDW1MdF8uGCZbDS6THTXxSTuRN+cUMf1ttDDPzmEoTF8qP8xp4Qk/SsGogYMQrOqkcqyauQL9Wysu4OPqBRjrsspm/i011bqQA4Mgdhp9S8a/ftVhsTNloR42BmtzRv+Bs3ctfer2fgez/2eKLRs9cWhtQrSnFqKwJtwjQbbUJ3UvG5prqWPi2zdgrY9lxt6rBXoxcA8lZNs+3QkUgHe0pRu232V1nmXI2yxdXHDOneCn8FOn6rX3fYtpBjJ++4It/QpS0XqSsWFcJSanwTYzSSwwWuEgddazGrsaJ5SWoyUKp4F3kUWNDXuad2+lCjEUhHEAK2lp5q9z04K0Rq1gRnazhC4Rz6/t3CMgdIMX7yp3mOG+7FctAumo6HdRniKULlocpcgTE1u46lnKQuiKoo0SqLMJYijukeFycO7vEGjrSyGPfeXSVI/nNs9eEEyVgOEcP4j6iQgruke1eYyYchignO/zczQpcwboyb/cv+y8laeZHJttmdvDtPZprTHZS28FVWzUBrA9BSlzOYZKQ903G0cvS4GUXe06brfoeZJKAR3KDwlCkMeAXMC3hF9h+hNHXHJPK/hXMF7FsaUV7lcBPrbVPOEE5GyPLkW6XtAtfbbHluLFfe63DuSb88jYhxViZ0BgggCm0wm9zsEd6br4CZ2k8VseshqvIJKUnlEnVNHwczN9AMOSExOTJ7MdRGuaaNBzaIWB8boUoZSf/SHUT8nGhSYmk4SBzjxEjVF0iE5B9N3jwybv52iS73pSDo09UtbYmMzWwvnbe5ppwXkpCTN5tbjiBSIZQSOqqvkqRmJsfeI4cm45vaViBL6GbOn6ppOiKUoXtwnzkrNMy6H4KD5KiLaJfZ3hpU12wXBg9dDxf+864rgrW6TD2Ma3rV2G9EYVb4h81h5Y
 dnDojHfi
 A9hUCvSBLUqIfnyr4/ZKV28D5lecRnnowbgHJGab9HoTumpbxB8csgTQ9YKHvSkwJocm+VleccaebRSWaIOhqApCCQ2j7X9LjjRi3im0upQHM1w7Ocue+uRyXxmvhwKLXodl1a9cOsjeYL/4VKzAvz5eX6JNHcxNj+YE5xt4Iu9A8FhNJu1rnT7phfzvBLl4zvPbT44aapQ8HSSAJcc0f5lnbx29AwmDBIvncM+3QXkyB21eJnAR9SjEHRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/05/2026 13:44, Muchun Song wrote:
> 
> 
>> On May 26, 2026, at 19:51, Oscar Salvador (SUSE) <osalvador@kernel.org> wrote:
>>
>> ﻿On Tue, May 26, 2026 at 04:30:03AM -0700, Usama Arif wrote:
>>> On Fri, 22 May 2026 14:26:58 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
>> ...
>>>> diff --git a/mm/cma.c b/mm/cma.c
>>>> index c7ca567f4c5c..a30075507d41 100644
>>>> --- a/mm/cma.c
>>>> +++ b/mm/cma.c
>>>> @@ -188,10 +188,13 @@ static void __init cma_activate_area(struct cma *cma)
>>>>
>>>>    /* Expose all pages to the buddy, they are useless for CMA. */
>>>>    if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
>>>> -        for (r = 0; r < allocrange; r++) {
>>>> +        for (r = 0; r < cma->nranges; r++) {
>>>> +            unsigned long start_pfn;
>>>> +
>>>>            cmr = &cma->ranges[r];
>>>> +            start_pfn = r < allocrange ? early_pfn[r] : cmr->early_pfn;
>>>
>>> Should this be r <= allocrange?
> 
> Yes. So I sent a v2 to fix it last Saturday.
> 
> https://lore.kernel.org/linux-mm/20260523060123.2207992-1-songmuchun@bytedance.com/
> 
> Thanks.

Ah still catching up on the mailing list. Thanks!

> 
>>
>> Yes, I think you are right. I missed that.
>>
>> early_pfn[alloc_range] holds the last assignment, so we should start
>> from the next one reading cmr->early_pfn.
>>
>>
>>
>> --
>> Oscar Salvador
>> SUSE Labs


