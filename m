Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5EDE9904A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A93C6B0005; Fri, 10 Apr 2026 03:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433716B0089; Fri, 10 Apr 2026 03:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322296B008A; Fri, 10 Apr 2026 03:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3C16B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:36:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C38A713ABC9
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:36:32 +0000 (UTC)
X-FDA: 84641838624.25.803FE3B
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id E219610000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:36:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O61gXLMN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775806591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTLYMwh8+2dL09yw+nIB+tqwR8xI7oLsaoxXJ0V1RBE=;
	b=AO38YiI3f1+zpu1T7ZzUZcgJ+ajVgP/LaecF/Ot2HeMntomfevk6nwXdX0QQTjYy68owp1
	temhAyT99fyt+a9hVrsvrFLcx+5r/ItCGPONFB8F4NC+1eSzF8wtk79ShWEwFeW9MGq3ll
	mVJsThuqWaMgXf8XMXyr4SvmhfiOkNg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775806591; a=rsa-sha256;
	cv=none;
	b=gpHm6zD9XWcm9ijs4sDZLBwNWqgnQ0BSl+P8PaswUIka536W+D/RwUHZ3U8RBI4Iib4F7x
	jnIlqzOdcwS8KVO0hVf0ybttCMEZ4LRXCx9boj7zD/UUdZNLtnEFxdvyULCT5vwqXtr2l6
	DmVVdyeL9yHi9okNoCzzd8NVKlIZL7M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O61gXLMN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
Message-ID: <fab28990-2b80-4112-962d-f9369bbae045@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775806588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VTLYMwh8+2dL09yw+nIB+tqwR8xI7oLsaoxXJ0V1RBE=;
	b=O61gXLMNMSEv+T1eGeGemtxKZe+hAaGnN7ZZ8JADfRq/tuWvEfDMrbOOifOEc2bCQKRYDn
	oxKPgbruDqCZSGRZq5smu2fSXIssEadBcmDHnwu1bfUDtAk0H103o1F/APMoMO/m0M5mlY
	XDEnP3XB3ZL8PuxqK1oFd/XRb5QRM9w=
Date: Fri, 10 Apr 2026 15:36:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260410001834.77924-1-sj@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260410001834.77924-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E219610000B
X-Stat-Signature: kcze44g4tf186xhb5kt4hcna3ewxkpdm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775806590-323585
X-HE-Meta: U2FsdGVkX18EzKk6x03ynkVU2+SiVA4twyJMxKj6snEbyFOT3VXrhsU1vHfB4QgkhLOjLiaKPJPGXgdBpD1acX0Ni4llkNrJy3V5wNHs8nr3bblYBPEM8AgZBLHdr9qb329OcR0xOic/HIJ7SdPUKVofbBbMtK2WrQrpBk5IJeIq20RrbbfPb43wdXpPxu3jTny1Pch0l9Q6zqW7k9HihEZBCCPI0lGo7A/wFkke2FbpYp3oYcjroqu7PPbtWbo0I459Qyvfy/GFea7u9dRWN8JaDJFx1ptsXvYUV0RK3xjzPn2DOOB5jhgQ7VpVHAW58ZIthjUNN9aFsw4CTARDghmbhps+UihX7KbwBYWoMF/G78naPq61SQC/YJnZp0/BsSRxi7Yqrlufjwn3Qj9yVFq0Z1YJSLw1GCs/a3ECVGLGg3q7Nq3ZYShF0RwaSxx5dUGyhPDyHN0ObddncwDk38vhXTmsayrli47J/F79EdGfmdHxjyS8cNHweGmHmy0tVhzT1JcESuVyf7VIwLy0hYMIafaWKUT65iy0cJFUUbT+Mgp6jtZI9DNwCNIlVu39DdZJxwvBKGTSQShPZYDvQjuZMkPYvYbT8g7X29ffuoOblkaas/u5Psuj7T7PB00aoQxX8V42/tup5jn+Sv+OUrFzbSOXXiSAL2xrcdIEZG/CMy9jb57NYHE9J6Jou2zLw0TrE/JInFCZDu1Wvhb2ewANQ+wXBBMItZfu5zYWvRIr2aohv+vSIFA/gfumFABDHD6QwLhnwED/iD7lmXlmk/HH5wko2RBSWMgtQYn7Hh4kECI7ST10A+MF6t3XXr/dIfN0mNRlVhzUhPCHBsNnpu47CXI0A9PWWLltNQI53Uwijhc7JjaEyd1oDZYoP9djbK1DOfOVKEQOICaChQZVMxeluOyVyR1XKwKy7+y0LJdsJ1XiZhOhVb1xJYTfvlWMHF6TLA5V/FvagJ5uxCu
 VnB5v+kO
 iPPTMCvbEGJnxOHIaZrohney5oYXsoNchxRE2yKUV2polKg7GERZvFfEukv6avrIdianDasu8GcrUkw+A6kaSgd3TDxJ9nICkQGPXZwptVWhqlCKy0nHQjNaePS3cFyeJltISM8CIHfVXb9Yc/4BXuBMoA1QzX9dxL60UUiNpcTmhj/Z/teMP8hqlnhqiyQpYn9RxzVN0GZnfQUOlvIg1qQForNqOKQG5BQ2VHee0mpZspmKoI64JlU9OGcDCe0cK2yRgLBRm4LJAMj+HbC/i2q1eWUq8xdubrhcy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/10 08:18, SeongJae Park 写道:
> On Thu,  9 Apr 2026 09:43:22 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> PMD alignment in khugepaged is currently implemented using a mix of
>> rounding helpers and open-coded bitmask operations.
>>
>> Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
>> alignment, matching the preferred style for address and size handling.
>>
>> No functional change intended.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
>>
>> Changes in v2:
>> - Switch to ALIGN()/ALIGN_DOWN() per David's suggestion.
>> - Also convert collapse_scan_mm_slot() to keep PMD alignment helpers
>>   consistent within khugepaged.
>> - Update the changelog accordingly.
>> - Link to v1:https://lore.kernel.org/all/20260408093534.2373007-1-ye.liu@linux.dev/
> 
> Nit.  Changelog should go to the commentary area [1].
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> 
> 

Hi SJ,                                                                      
                                                                            
Thanks for the review, the Reviewed-by, and the helpful note.               
                                                                            
Got it. I'll keep the changelog in the commentary area for future revisions.


> Thanks,
> SJ
> 
> [...]

-- 
Thanks,
Ye Liu


