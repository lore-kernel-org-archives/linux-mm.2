Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9E9EB48EC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C50B6B008A; Thu, 12 Feb 2026 04:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072A96B008C; Thu, 12 Feb 2026 04:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C126B0092; Thu, 12 Feb 2026 04:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D07566B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:10:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FC42BB123
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:10:59 +0000 (UTC)
X-FDA: 84435235038.29.5537253
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A7C591C0008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:10:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c2Fwrg2W;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770887457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjQDGtFNN2J1VmXqWgnD5xSGrgTNMhKvNE6JI7bwQ+w=;
	b=ugRbyfx/KhQxXgn7Fr4U4i9Vl9e6ZxkWntcSVjCP/kjiQVxzm7CZj9zcuyIeRZi8KBQEGu
	9Y94xFkRmQ/93Q7QIANZjnO6RRj0SGPyrJhFd4JAiEg43TKCr7YbpBGsAmNRN0KXTIOEFc
	qeVF1zWKyMg6uS6kHXtb5g8UMZZ1w04=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c2Fwrg2W;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770887457; a=rsa-sha256;
	cv=none;
	b=OEqdbmsDYp55Qn7B57MhSkHxOQ0O4PZkbQ9E4D66uPIbwI68dFAl7y/ZNE4dF8fq0ZikPy
	8eBpF1CtMO6ZYASojIwmjOvBLty4EGWba5CTA3O4DvHA6B9Rdc+SgbeP1jYVXXzx8KNBcI
	ivoROZcfPnnnbjxdkiSlb2bU0L7YYi0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B771C43B4E;
	Thu, 12 Feb 2026 09:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FF4C4CEF7;
	Thu, 12 Feb 2026 09:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770887456;
	bh=xQs/VONCVmMMX9dMzZmQ6NsgfiBgg83y6eg69h6scJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c2Fwrg2WKfAxdMW+LEhD9IDgnuJaxmVW+GRnftndIOq/z25H5YsYQ/ET0XPjWFFJ8
	 ksa/UeIe8J6b7ZyFcaXRwTZqKylxPbJqfUUFhGY4o/jJmuFTf6uOpUdsr4Zm71L2qA
	 9GcXlXAlDtcB2Fyanz0vomXDT1yfIRNo4p/g8wmcbC0TJ8QM2Aze/HhIDT1BexBOEq
	 Lrvaub2W/HJI+C/kK7Q7lTzbLyULnNR4hUZgJy5JUJiZquljYX1jrbX6CtHvMOZdMI
	 tcj841/bCxn3SBb3F5ks5XoFSWVNhqWLAzlToKw8aLxXAgVecmQmRg8lDbp9nObfjc
	 qCe33v38obcuA==
Message-ID: <16ce9ce2-8081-482c-a6ea-0932ebd081f1@kernel.org>
Date: Thu, 12 Feb 2026 10:10:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
 <3571cf8b-9fb3-41b2-a402-a8537ee2c399@kernel.org>
 <r6m6vdhbqada6i3gugtnj3lytjrkyiretihwebwci423vwslcr@ysrgdqvvno6b>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <r6m6vdhbqada6i3gugtnj3lytjrkyiretihwebwci423vwslcr@ysrgdqvvno6b>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A7C591C0008
X-Stat-Signature: n33fpy75zkbuz5ituhtrdgoxgacwtbdh
X-Rspam-User: 
X-HE-Tag: 1770887457-919118
X-HE-Meta: U2FsdGVkX18LJk5GIYrD0SLDOPCMzk/sTAwbVkkB3q/hZ4MJqPZA0OsV4oUroIlbm94xlB2+cxTKvxp2sio7fsIni+bebpw+BcsbskFsuSEH24vPEi53a/beZ8eDyVqj1OpBga5HuZqoWIIwIWtISrEJ0jl/HcNSbmDVce9gyEqogmy23MRrCiNhH3m2ZQd8pQthc8dQZQY5afSDou4rEiJvvobHG3tiY3AuyUsxyIQEzJZkNh34nW3/heTaiU8mQXgenjiaDCrIeoIHq9SdWU0Qw1/Jary6sMJkpSdO/M7hhknbu9po8Altt296LZDqM8ZjITE+hvYirXezhiTk6o1/iunw5aOwo9sENKI6chl2udykprYmYNseCHBtIWU2cDsm4vEbCJGiWe0m5XEXte+3+/6TwEWi7p1cKRC7v5vDzvKXKFAtVddSC/uI/p3CA1sXAi8wLc1UrCnJc+2uDPfdRuwwHhEcJ8RT79yUxm0q2fSvtTbsBrwa/0aavGs7YI25MVmmkEW0Sel08Ie+yA1oGDWHOzVd4AyQLpWS28cJvfv4fRpF7eEI1nGrUg2E+niB2zcKGVZ7nrEYRULO9YxsY/rKtf94urHfxhqoyB8IU2Dda2KiOA+U0pMjGkRDERJT8NE6nkqWTGT4LBAKzFICm2eiZ/ajM+uT78pQRkMXH+pxtLMLP4/180O32BOYPWZdjPbhUjXKxcT10V1btSyXE3swe7hT7pczQ6cZUkLJRbF5oGV+dHRSQe8uweLu6EKqwSjvMd9KRGYngdO1QiI+yKKyVJRabmWN+Tk2th/P+jnubTQ8aRsJX/Dl9R7QCNky3B+c4U8ou+LCU/7gBbL5YMGh3VqP0sXUwsxDkhImQz11UvXBwRmjjfAYSkVXQnXuDgzXmuo2OTVl/MKAuDzOL62bWN3nCA8PsthVN4Z9z8C+AStC4gLaTIGIKfXqXHa1twiRTnkgT/qOlFM
 oe0PzWJ9
 GMUpuJf89I2Lc/VIF0j4lKe6jjU8s3Yuc5WoP90gEMyGQl+eo3l/tUf6QZZ1eflmkmMhQy1Hyndk78ZQe46MyZpgNsIq+uiO6/R4fL/JwXgW8aLXjgm9pTPlK7oNyW11XBi+VE9wYoH/KO1cRalq2HguNsZdqYiE2/vF3S92TnTnBILmIOfN86rqOCaOYKIWovHkkPoRy3Pr5Utbqsy1k4wLqO3w20URzO1ZVMsIaO9Tf39pSqerdC2FItlGn+0vzzAlcAJDYeHwG9ulEtoNHSBHTHcXV/o3tlkCoGXQ8fBZSDHfsh4pcvszhGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 10:05, Sergey Senozhatsky wrote:
> On (26/02/12 09:44), David Hildenbrand (Arm) wrote:
> [..]
>> If we're fixing an issue, we usually try to identify which commit introduced the
>> issue.
>>
>> For example, support for freezing was introduced in
>>
>> commit 878aee7d6b5504e01b9caffce080e792b6b8d090
>> Author: Andrea Arcangeli <aarcange@redhat.com>
>> Date:   Thu Jan 13 15:47:10 2011 -0800
>>
>>      thp: freeze khugepaged and ksmd
>>      It's unclear why schedule friendly kernel threads can't be taken away by
>>      the CPU through the scheduler itself.  It's safer to stop them as they can
>>      trigger memory allocation, if kswapd also freezes itself to avoid
>>      generating I/O they have too.
>>
>>
>>
>> Now that I am looking through the history, I find:
>>
>> commit b39ca208403c8f2c17dab1fbfef1f5ecaff25e53
>> Author: Kevin Hao <haokexin@gmail.com>
>> Date:   Wed Dec 20 07:17:53 2023 +0800
>>
>>      mm/khugepaged: remove redundant try_to_freeze()
>>      A freezable kernel thread can enter frozen state during freezing by either
>>      calling try_to_freeze() or using wait_event_freezable() and its variants.
>>      However, there is no need to use both methods simultaneously.  The
>>      freezable wait variants have been used in khugepaged_wait_work() and
>>      khugepaged_alloc_sleep(), so remove this redundant try_to_freeze().
>>      I used the following stress-ng command to generate some memory load on my
>>      Intel Alder Lake board (24 CPUs, 32G memory).
>>
>>
>> I wonder if that made the issue more likely to appear?
>>
>>
>> Interestingly, we also had in the past:
>>
>> commit 1dfb059b9438633b0546c5431538a47f6ed99028
>> Author: Andrea Arcangeli <aarcange@redhat.com>
>> Date:   Thu Dec 8 14:33:57 2011 -0800
>>
>>      thp: reduce khugepaged freezing latency
>>      khugepaged can sometimes cause suspend to fail, requiring that the user
>>      retry the suspend operation.
>>
>>
>> So it's a recurring theme.
> 
> Interesting, so 1dfb059b9438633 and 878aee7d6b5504e fixed real
> problems "khugepaged can sometimes cause suspend to fail", but
> I don't see what exactly b39ca208403c8f2 fixed.  Sounds more
> like an "optimization"?

Yes, a cleanup. I wonder if it caused harm.

> 
>> Given that we only scan "khugepaged_pages_to_scan" pages/ptes/etc. before going back to sleep,
>> I wonder how that can take in your setup that long.
>>
>> Why does it end up taking something around 20 seconds in your setup?
> 
> I only have bug reports at hands, I don't have a repro.  Can the fact
> that swap reads require S/W decompression (zram) add enough latency?

I guess so. 20 seconds is still a lot.

> 
>> How is khugepaged_pages_to_scan set in your environment?
> 
> Let me check.
> 
> cat /sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan
> 4096
> 
> Hmm, doesn't sound too high.  Let me look more.

Yeah, that's not a lot of pages to scan. It's the default (8 * HPAGE_PMD_NR)

-- 
Cheers,

David

