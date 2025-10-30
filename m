Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DCDCCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 01:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518B38E01AC; Wed, 29 Oct 2025 21:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0608E0106; Wed, 29 Oct 2025 21:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DB08E01AC; Wed, 29 Oct 2025 21:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 321AC8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:16:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4AC04A23C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:16:05 +0000 (UTC)
X-FDA: 84053014290.08.35F317E
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE95F180011
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:16:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="D9vUK/5L";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761786964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfAAEiDXRtzE+NZ05S48S2bdZE0MaHUuFgXbP1Eu81w=;
	b=Pze5ncjYAOeg/NzhYuZ2HK5q7ckQzbGqOEV0K6p8+V38d6CpiLX6WW1VIwVlHEKD1DBGa8
	Ij3Frj4bP56SkiuWJWgw/nwV4uxZ63cdldu1odA0htiwcxd1j1Q2DNJeoLZX7fVYcmhw0n
	0lPvjc31vmn5ndv6AbWWyPWVgn1CTkc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761786964; a=rsa-sha256;
	cv=none;
	b=pgxkp30U2mJdhd5OfBGKRVbTqvH8M3IYA6n6IM3Mo4zPSbPu/dqcZPoCudAiaA5s0VodoT
	OWfs+WgN5568YqdvW3sX0JM4bgeLClQd/94HArT0zB7affyrNW1Sry9DucaxI3TTtZrkEA
	C5HaiP70hz5piq3gA9Wy2EXhlExnwJI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="D9vUK/5L";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761786959; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hfAAEiDXRtzE+NZ05S48S2bdZE0MaHUuFgXbP1Eu81w=;
	b=D9vUK/5LNPelkU1KcXNJIVf58YUdmyNr5T4imW5D4ZAuCzSJZMoQJb514gO+A1sW+EzgxHf0ioAxJ4iQRuPpFlFBQ1d2DlSbkrBgA0ohPq6ht70EqkNmFSlG4wZ3tcqgKsWG/EoQIB38FY4LD56Kh/xBWaIbzXQHUSpiCUyAmvk=
Received: from 30.74.144.140(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WrHfwfa_1761786955 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Oct 2025 09:15:56 +0800
Message-ID: <5c7aaf9b-a6c0-4670-a244-67948ca86727@linux.alibaba.com>
Date: Thu, 30 Oct 2025 09:15:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Nico Pache <npache@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
 <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
 <b1f8c5e3-0849-4c04-9ee3-5a0183d3af9b@linux.alibaba.com>
 <2ab547d2-584b-48fe-9f43-7c14caa7ab05@lucifer.local>
 <CAA1CXcA1nqt_f+zSOF66eTNWJACCE84hSQn4uNF8CjcBUZ_1oA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAA1CXcA1nqt_f+zSOF66eTNWJACCE84hSQn4uNF8CjcBUZ_1oA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: zg9rdsmc7rdrhfkcktcp3eee1koauhhq
X-Rspam-User: 
X-Rspamd-Queue-Id: DE95F180011
X-HE-Tag: 1761786962-1126
X-HE-Meta: U2FsdGVkX190RoSH0E51rva9T8O1CAlGbEegB2qruitdnS0n1tRrJmF2fvkiJwpkD+rd+kU8gPBupiMPBe7tE2Y9ZIzDknB07hPwtNr/4x5oOnMqc1JwuxrkKRJwZAojKqinv8x0kLT8VrfAaVD2kwaMbgO2GwguJvqkbuq2bk9afqWQqIxhiBn9G8oGXOXq2SX5hHkUA38zk7fmAzKbBsq+zYYLhnSRp8WZBLHwY6EHEDBlw23s4eKeTSRnRIsQUuon6w5z0PVxMgdvSX6Ytp6qELUv18Jks9ygMPaCksAzyfwDoiwEaZoPg8A4F0OwUEifM/h/Lj3I1FdCCd/ppkCBJ5dsowCszNZvKW/0vofL6bbaXFifv83SUtwDu9GesECoTorxNLrMs9ph01f83tTFjyyel0oLqGkNwMO1XbH84a7GUsCVGHROy1RI/aNQoc9entd+C5JVdHQeox+HOXEBXfblWjQG/NcL9kg8FCcnNByFc8OY0DjxnspmkWOHvFIccLRf3606roWGai3yZ8cjQUg+WUnQANQ3Q8d1UuAGuASlPrRSOrNqtuYJyiFW7MpJnk4ZqDZOUVEIaH4jybfly4vwkk0EvQASvb+XntXqj5zm0Vat/WVVDVTfdEFle29pDBY/bQNmau3CDSUC8d8gtNogRsGct5YOKBRytABzUGX0DVVJk4q+yxPt+EThMOMgjom1c7EgT5vLp3Aj1HX9RvvFl+dUVvB6ecsshsFD2jZDcJxpJ9kDBcnDxHGoN/HRpe/lFhstRB1jiOvmJxZe2E9p2PBq8FrfBTsLcpzZSuCHQVfbFF2VuknpL12NjcMJnhYTwJtNqnt48m65tRSsKjMM/i+XI3mUJS9xx90TSt5rYSLdkDVLh/8boRKxPXCeMV+pfoiUq0vHiRxSXpI1YIhQfnCotWRTDiEtPU8MQWslLx3icd7uyYJEKxT++i502K5OGie+ie1SgUJ
 l9elsC/c
 t7kTzTFNTR/rl5NoKcQMUynqM1ri0bWP/83OwzrPpxtXIFLFQ6/GfGjiQH7ciQQlRDKXEty2V3BOxadzoB+OA0Jak1pwS6hljGOXb+y/ZdT5O1mVugRtcM7/fII5wq3oGJLURiiCWUQwKx+SmWU3296+vp3ligBlseMH1lzFPxmfsyiokSxj7qYLpSf153cyxkBUcwr0PqknOeJzrAWWiCG3PT8vLnzUKlrzb5KwJPRism+ASCMqzl6ngvycclYpS789enCRU0nOH/PzBzhwApCbpDBhfFlcz05Jkjpdto889VP3d6aF4KM5g8zVHSoFJj2tXT3EIybb9RYu7Jj3vHoO73KyXqngHLCTEbTUbwwGcuN92tgHAa4KLIVIpDahZCl4tB4Q7sQafWSLeW1oTb6mPnF+hG8ebSKEUY8v4Sk5v8b0OH9MOnePKHpMLJ87gVF/gD4hAHTzrLfGcNuidPFgKkbdKvOeUj7ES
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/30 05:14, Nico Pache wrote:
> On Wed, Oct 29, 2025 at 12:56 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> On Wed, Oct 29, 2025 at 10:09:43AM +0800, Baolin Wang wrote:
>>> I finally finished reading through the discussions across multiple
>>> threads:), and it looks like we've reached a preliminary consensus (make
>>> 0/511 work). Great and thanks!
>>
>> Yes we're getting there :) it's a sincere effort to try to find a way to move
>> forwards.
>>
>>>
>>> IIUC, the strategy is, configuring it to 511 means always enabling mTHP
>>> collapse, configuring it to 0 means collapsing mTHP only if all PTEs are
>>> non-none/zero, and for other values, we issue a warning and prohibit mTHP
>>> collapse (avoid Lorenzo's concern about silently changing max_ptes_none).
>>> Then the implementation for collapse_max_ptes_none() should be as follows:
>>>
>>> static int collapse_max_ptes_none(unsigned int order, bool full_scan)
>>> {
>>>          /* ignore max_ptes_none limits */
>>>          if (full_scan)
>>>                  return HPAGE_PMD_NR - 1;
>>>
>>>          if (order == HPAGE_PMD_ORDER)
>>>                  return khugepaged_max_ptes_none;
>>>
>>>          /*
>>>           * To prevent creeping towards larger order collapses for mTHP
>>> collapse,
>>>           * we restrict khugepaged_max_ptes_none to only 511 or 0,
>>> simplifying the
>>>           * logic. This means:
>>>           * max_ptes_none == 511 -> collapse mTHP always
>>>           * max_ptes_none == 0 -> collapse mTHP only if we all PTEs are
>>> non-none/zero
>>>           */
>>>          if (!khugepaged_max_ptes_none || khugepaged_max_ptes_none ==
>>> HPAGE_PMD_NR - 1)
>>>                  return khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER -
>>> order);
>>>
>>>          pr_warn_once("mTHP collapse only supports khugepaged_max_ptes_none
>>> configured as 0 or %d\n", HPAGE_PMD_NR - 1);
>>>          return -EINVAL;
>>> }
>>>
>>> So what do you think?
>>
>> Yeah I think something like this.
>>
>> Though I'd implement it more explicitly like:
>>
>>          /* Zero/non-present collapse disabled. */
>>          if (!khugepaged_max_ptes_none)
>>             return 0;
>>
>>          /* Collapse the maximum number of zero/non-present PTEs. */
>>          if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>>                  return (1 << order) - 1;
>>
>> Then we can do away with this confusing (HPAGE_PMD_ORDER - order) stuff.
> 
> This looks cleaner/more explicit given the limits we are enforcing!
> 
> I'll go for something like that.
> 
>>
>> A quick check in google sheets suggests my maths is ok here but do correct me if
>> I'm wrong :)
> 
> LGTM!

LGTM. Thanks.

