Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09CDCEF99FF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 06:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7D26B0005; Sat, 14 Feb 2026 01:35:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472C26B0088; Sat, 14 Feb 2026 01:35:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3751B6B008A; Sat, 14 Feb 2026 01:35:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 235546B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 01:35:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92530BB23B
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:35:20 +0000 (UTC)
X-FDA: 84442100400.23.631E971
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 999A38000D
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:35:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wCHWPAAe;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771050919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKcvyZ0wxQfKnUpcoKe3Juz1omn/zpds7qlJdAAqUDE=;
	b=h+wmpopoT2SeCJ9F60QkfgKHpcOTw4MoGIRZc3xAfskfsZ4oYcm6t85IqpPyHjV9xLH+xl
	PDzVw+59ztew8t3N9rzrJ3koiZylSLsLt28wkMm5woxgMlb9gc8hDTX84fp20E8piq+Tav
	tq2qgpmWXH/D9VIpcE6xmmlomNNM65s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wCHWPAAe;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771050919; a=rsa-sha256;
	cv=none;
	b=V9j9jdhUE7ty1ZMTgeIHH3CixfPxr7BhRPhvjadFWs0/lDMgbKlY743WfV1KYaeziI//XL
	c0zP/Q3TLIvizwMdocjxaliP4vpOw3EyqR/waCtXJzehj1oq1BF2olYDebQXfTIQSXu3Bm
	qEK2A8u3+lfvYiqmi9YEmWNz16CZQhM=
Message-ID: <56345542-544a-48e4-b127-49a850deee9b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771050914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SKcvyZ0wxQfKnUpcoKe3Juz1omn/zpds7qlJdAAqUDE=;
	b=wCHWPAAeJLueKrJJjj1gupo7JxSpq0H/0b7y0jlFgVM1uyCl+v4jKzXBQtxlCJASfutFMh
	Tx25hGPe4JWBmOzzhow0aXhGtv50gW+rZPbj2jTIB8ZXo26jUTM3LdrYWkAVDu8I+9uJBu
	3ZmeGB2MxxwqTpyQ6W5nlneL4DGqy5c=
Date: Sat, 14 Feb 2026 14:35:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
 <3571cf8b-9fb3-41b2-a402-a8537ee2c399@kernel.org>
 <r6m6vdhbqada6i3gugtnj3lytjrkyiretihwebwci423vwslcr@ysrgdqvvno6b>
 <16ce9ce2-8081-482c-a6ea-0932ebd081f1@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <16ce9ce2-8081-482c-a6ea-0932ebd081f1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ucyrodysxyhnf6idui51g8jg59fzi61a
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 999A38000D
X-HE-Tag: 1771050918-11129
X-HE-Meta: U2FsdGVkX19g8Wzpje2JxJZIeDvdc5BKg5CkUvvttK+7QzfdrtDJd96cnVo4oFb6EE06z0YncrdoKgLQHvoh+ZC6CtXcHorRyHvpxgzc3eb1188FhAyO3/cWSB0/+pJt2J6SaRAPVz6gP+aYUBBaLIxDB5XyuPrBxSyJ5tTZXVDF7yjGi6KoqKHWQaoNu0lXpfNGpyRwbz4vGQ/DJYjVq5TXz2PvFrFfYSubudzPCZn1Fj7V9bqLIbz27dXdbRfqWnMELK15WrsSdQBHxulamHAi4WWrkapE4SmaNNJgf2+PWaBLyfpiy3IJvL8gV6bwU1cro3gF1jQSOc0KfPIXDOtxl8DNRZUpd6rgYDE5de4a/43CUniPCtSV35oIHzTDQo8kXdWjNNVtI/YG+CrZjwIySDff1odeqi+mWMjZkFe607nr/JPltdIIhkwThjz+Upvfm9AIUHHCKkoFfX1XtQML/E0ZCWvxPwEhvEgorfLFKbj2j2tvX+pantjPGbM5xz4M80ZpZcesW4C/8bCPnf4V/VXyHTMxeAe8PKYaSrrwbxGSW6NE+azljN7kEf/mzeVvzh8VRwl7vNt+MC2EtMSVDFV8x/kt7wMUfLTGfa/+XrWNynQT3Rod1A0z9v1BPXSgtDa8/MFPzlQwkSxw6lKMSZNFBLCU9Xtq8ldn0BHj/DVJlqUjUsYux2ubhyaTaBTXYOQyGIcsYc2oUtkrfYiulcHWc3v7qdHUg94LBwxB9g2aHx824U1ZNCAWsffwe+uLpPndALMoPCX1uESqUq3mn4AWbEJ/o82GSfGTW3WRyZEWq8V7cahkSaXeQW0xW+ME2XfAmAwEjEvasN9YX/Mvenyc8EqhJY4dXxltdsdh6apuouRGXcrdZ5/6PRTXHPwGaq1bV4KHa+iiXjldEIrLioPjXhna2FVm8zUb0k261xysmgLXcM/3DJXbiIdUO1OfWhMZJBA+pfSmZIe
 mqSgIuMw
 E1SPtHs7PCro/QmfJYPodk7jHb7dVaebpUDLzFKhNh/32LREbzYJrA2bEqGZKfs1FxFBo292FEnlSffCbjRStBAF2sq9vqOBB3ldht9O9kPO+yTScggPTYI0iFKx3CgjvchNgQzy2/u12YCuRWx2aMd9Kv88SUEOOwZPXn9zYnBSzWaSLx98spQ4KiQUbxwObgn0HjjxjpIE12wu1CoR9aVoixVpm9T/n4JiaoYybnqXnOFIbmZEn8lo76cifooLRv4GdU4bjOog/OxaPuRK5FJGLg42EITAANyqB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/12 17:10, David Hildenbrand (Arm) wrote:
> On 2/12/26 10:05, Sergey Senozhatsky wrote:
>> On (26/02/12 09:44), David Hildenbrand (Arm) wrote:
>> [..]
>>> If we're fixing an issue, we usually try to identify which commit 
>>> introduced the
>>> issue.
>>>
>>> For example, support for freezing was introduced in
>>>
>>> commit 878aee7d6b5504e01b9caffce080e792b6b8d090
>>> Author: Andrea Arcangeli <aarcange@redhat.com>
>>> Date:   Thu Jan 13 15:47:10 2011 -0800
>>>
>>>      thp: freeze khugepaged and ksmd
>>>      It's unclear why schedule friendly kernel threads can't be taken 
>>> away by
>>>      the CPU through the scheduler itself.  It's safer to stop them 
>>> as they can
>>>      trigger memory allocation, if kswapd also freezes itself to avoid
>>>      generating I/O they have too.
>>>
>>>
>>>
>>> Now that I am looking through the history, I find:
>>>
>>> commit b39ca208403c8f2c17dab1fbfef1f5ecaff25e53
>>> Author: Kevin Hao <haokexin@gmail.com>
>>> Date:   Wed Dec 20 07:17:53 2023 +0800
>>>
>>>      mm/khugepaged: remove redundant try_to_freeze()
>>>      A freezable kernel thread can enter frozen state during freezing 
>>> by either
>>>      calling try_to_freeze() or using wait_event_freezable() and its 
>>> variants.
>>>      However, there is no need to use both methods simultaneously.  The
>>>      freezable wait variants have been used in khugepaged_wait_work() 
>>> and
>>>      khugepaged_alloc_sleep(), so remove this redundant try_to_freeze().
>>>      I used the following stress-ng command to generate some memory 
>>> load on my
>>>      Intel Alder Lake board (24 CPUs, 32G memory).
>>>
>>>
>>> I wonder if that made the issue more likely to appear?
>>>
>>>
>>> Interestingly, we also had in the past:
>>>
>>> commit 1dfb059b9438633b0546c5431538a47f6ed99028
>>> Author: Andrea Arcangeli <aarcange@redhat.com>
>>> Date:   Thu Dec 8 14:33:57 2011 -0800
>>>
>>>      thp: reduce khugepaged freezing latency
>>>      khugepaged can sometimes cause suspend to fail, requiring that 
>>> the user
>>>      retry the suspend operation.
>>>
>>>
>>> So it's a recurring theme.
>>
>> Interesting, so 1dfb059b9438633 and 878aee7d6b5504e fixed real
>> problems "khugepaged can sometimes cause suspend to fail", but
>> I don't see what exactly b39ca208403c8f2 fixed.  Sounds more
>> like an "optimization"?
> 
> Yes, a cleanup. I wonder if it caused harm.
> 
>>
>>> Given that we only scan "khugepaged_pages_to_scan" pages/ptes/etc. 
>>> before going back to sleep,
>>> I wonder how that can take in your setup that long.
>>>
>>> Why does it end up taking something around 20 seconds in your setup?
>>
>> I only have bug reports at hands, I don't have a repro.  Can the fact
>> that swap reads require S/W decompression (zram) add enough latency?
> 
> I guess so. 20 seconds is still a lot.
> 
>>
>>> How is khugepaged_pages_to_scan set in your environment?
>>
>> Let me check.
>>
>> cat /sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan
>> 4096
>>
>> Hmm, doesn't sound too high.  Let me look more.
> 
> Yeah, that's not a lot of pages to scan. It's the default (8 * 
> HPAGE_PMD_NR)

Right. 4096 pages is not much to scan :)

This patch lets khugepaged be frozen between VMAs.

But if khugepaged is already collapsing when freeze starts, there
are two places without freeze checks that could take a bit long:

- __collapse_huge_page_swapin() loops 512 pages, calls do_swap_page()
   for each swap entry.

- collapse_file() loops 512 pages, calls shmem_get_folio(). If pages
   are swapped out, shmem_swapin_folio() is called.

Each swap-in can block for I/O. With multiple pages swapped out, the
cumulative time adds up.

Maybe we also need check points inside these loops to bail out early?

Cheers,
Lance

