Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 427C1E63F3D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 09:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D706B0005; Mon, 16 Feb 2026 04:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B4F6B0088; Mon, 16 Feb 2026 04:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31CD76B0089; Mon, 16 Feb 2026 04:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1086B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 04:25:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB0E3C3B26
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:24:59 +0000 (UTC)
X-FDA: 84449785518.20.CF025A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CF2E2C000C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:24:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cbRO1+70;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771233898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3rewJUrjVjiv6IqbudwtJLVi5IYtcklBiEI7JpnC0s=;
	b=YRM+TGeX4bcCpNf/CzGm11icLaUpgoGXlBXb+o6Gq0gdXXA+zz85qcQB1wybeUNVvSt+4V
	jzba/fw4S4KdYgScM2SJgJRppi/xkm/fH8g0TNSlgqlubTgqy93SZSefNm69SVbk2RKmzX
	hPzbS+MT9RcAP/8I9iWW6mXcg1Xi2bQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cbRO1+70;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771233898; a=rsa-sha256;
	cv=none;
	b=q3hKfSS6b0jRsg99tULzeFHlotK93UdWr3PCT0X8ySWDajMxUIlIVhk891/BZ4G5dHXJ6o
	+DGqi1vmEDepetEHsxmPv8PaQiU7KPP42YCIEwrOXMmGRQ1F+VTZnDuvl0H/LB84fLqd1K
	FQru3OZhn5HuM+OGB5uOBt4bXAcjkuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDDB743E1A;
	Mon, 16 Feb 2026 09:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A990C116C6;
	Mon, 16 Feb 2026 09:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771233896;
	bh=OR2VlSMVusMINq3vcBxMFK8Q/cZKx7EE1BOEdHfWSVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cbRO1+70oWXH/C99sJCpa45wqu0YDJge1ODTJGcfhNN37WUNRjQAkwfNJms/pxt4a
	 4SYqV6HR6durRaV0LwCV7oXw8xOdkOihG2qUVmUUGhqQ4wZEIiMSjk91T/hGafljB9
	 vUnd56CmpXxNZC0B+PJpC+w+bC7Vp43N1tlJm9/kIC/jU8VYpp082cnntQoF1Wc6qU
	 1DcLjupiBrvqgY4FPLdZ/EuHjtGjwVEg1y6aRB8ImJxTVMQVgm9cIZvsTgHq+I33MX
	 Nk2vYnMFbzOeMutD2wA6arpIpIfirD15dJyOUdf4r+13nFCB/KQorFDhhUz7BTJbKn
	 jg0O/tTuAqXYw==
Message-ID: <5dc7d3a2-a358-481d-9352-d8356d3343c2@kernel.org>
Date: Mon, 16 Feb 2026 10:24:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
To: Lance Yang <lance.yang@linux.dev>,
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
 <56345542-544a-48e4-b127-49a850deee9b@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <56345542-544a-48e4-b127-49a850deee9b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF2E2C000C
X-Stat-Signature: 8u9ahisoc63ec3a74cs64agzm74oue5s
X-Rspam-User: 
X-HE-Tag: 1771233897-303934
X-HE-Meta: U2FsdGVkX19jdOUDmnN7TMdo7XK6YPAdIEFj100HFp3myFwHwAdGnJvF03259CPdJprSLoaw1mTf3RnmGzRYQEuAiaedkkSMFoU9cGThZY9c71IaDFx2EzhNdIjl9PhbLfto/2A4Ogx+zqZmLKeag4fMVcA+/quqO7dREXaSlikXN2eIJTDsATX5dm52ml5r7iEZQHHrzv5UmeRT2Xy30ABYdjI0cTbTS4yMIjkITbc0swWrb+0u2uIFQ5wfk8jJuyRMKlqEJSVjL0MTtFpWxEjsrm/yMbEUWx28YSwOTRZpeosj6lmX+oWZFc7Yv1AlIOYdBHt+2+RPhKI8jM+1SB+k5OH/vrZofKt9PlvSyXxPmpLU4S58JmItKTSXuo865uZ3+zyRKdAjV/aCYH2X+HoUzxpnfOpa7njd8t6tpTulLYNhogGCZX7z+TdgbE9dig1dOXV2GZWlS1zymwFWxryF23IoTzQ5fQAz1tzXNe4LQ40L5t/eBYQKGY8icsAjJmUGY6A4KOQXThWj+m2w3NTnmmVhi6KcsLs22e7v0sPX3D1YdxW/sfjgAz75m7Pwy/cMozT7gey/BIjKTWrX0ut3X07Ed5rVnnzVXV+/CRrWDKXXffhhmm6tm8HziizrAfAo2TVNRBuoyO2sT4ar0vDX21LlHfQXkSjxC4zg7xSF3A+V8eJNKjmEV61ZqvwbYaDuZVcAn6BS6ftS44TVdBcMrdVrEL3K8ye1FExrO/kmvH98TPA6yWp/7+K1L+oOwQgsPDKEcaSpoSCqOlUuBgu1BUyP/kR4knUoDc1opgAdzfQUDQCBkidDUPmDBpgzSfKArFXGNjjD8nRD9WeN+50oLioTDjFg3bZTrEZ4AG85HbxHhXoqUX75hUT9mhI1ARnux16wOhmELQ56zohb6BJWhN2I+Rz9X2FgfxJWAnuEnW8NVB07y8BBWRnsmOwS9iNDqHlPa/Ofog39MTY
 lxTtlrVp
 Jka3NZNGO34U/uYxhZVw+0u5zht+ysVvaraaqAOw+kcKjo/+NMcZ1yrtRxfl2W0qoei/xfCemG0DoP9/WiVQNqYt3TEfFmSIZ+KdQLIbXssEu2pAT9qhEwqwVtrbyRJQkUw/ShEInAPgshrNwk8oEcAzRXfFiaB5XZwwg8LvXb4ltyT/+iWXV4/qLjEgDUdtrMyxg+0767cCdF1HXrWiSBCIUsnNWfKmW9DRYnt1rrwdh7p89ZRavel8+5bK3im0RUDtOY27nhZQ4SQgAkWlx2wIZ///io40n0lSl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/14/26 07:35, Lance Yang wrote:
> 
> 
> On 2026/2/12 17:10, David Hildenbrand (Arm) wrote:
>> On 2/12/26 10:05, Sergey Senozhatsky wrote:
>>> [..]
>>>
>>> Interesting, so 1dfb059b9438633 and 878aee7d6b5504e fixed real
>>> problems "khugepaged can sometimes cause suspend to fail", but
>>> I don't see what exactly b39ca208403c8f2 fixed.  Sounds more
>>> like an "optimization"?
>>
>> Yes, a cleanup. I wonder if it caused harm.
>>
>>>
>>>
>>> I only have bug reports at hands, I don't have a repro.  Can the fact
>>> that swap reads require S/W decompression (zram) add enough latency?
>>
>> I guess so. 20 seconds is still a lot.
>>
>>>
>>>
>>> Let me check.
>>>
>>> cat /sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan
>>> 4096
>>>
>>> Hmm, doesn't sound too high.  Let me look more.
>>
>> Yeah, that's not a lot of pages to scan. It's the default (8 * 
>> HPAGE_PMD_NR)
> 
> Right. 4096 pages is not much to scan :)
> 
> This patch lets khugepaged be frozen between VMAs.
> 
> But if khugepaged is already collapsing when freeze starts, there
> are two places without freeze checks that could take a bit long:
> 
> - __collapse_huge_page_swapin() loops 512 pages, calls do_swap_page()
>    for each swap entry.
> 
> - collapse_file() loops 512 pages, calls shmem_get_folio(). If pages
>    are swapped out, shmem_swapin_folio() is called.
> 
> Each swap-in can block for I/O. With multiple pages swapped out, the
> cumulative time adds up.

But 20 seconds to swap in 4096 pages (16 MiB)?

Okay, on arm64 with 64k it would be a lot more (8 * 512 MiB == 4 GiB).
With With 16k we're at 8 * 32MiB = 256 MiB.

> 
> Maybe we also need check points inside these loops to bail out early?

I'd only do that if we have evidence that it's actually helpful.

@Sergey, with which base page size are you running (4k vs. 16k vs 64k)? 
I assume your report is on aarch64, correct?

-- 
Cheers,

David

