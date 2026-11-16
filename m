Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806A1606A338
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LDs9n2IN
Received: by kanga.kvack.org (Postfix)
	id 824926B05C2; Mon, 16 Nov 2026 18:08:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADB66B05C3; Mon, 16 Nov 2026 18:08:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69D046B05C4; Mon, 16 Nov 2026 18:08:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C64D6B05C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:08:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9590914026B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:08:17 +0000 (UTC)
X-FDA: 85442522634.22.9CAE9EF
Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41E47100002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:08:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LDs9n2IN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u13ZLq2lptT+a4y0lVmdnjbg2+Ze+YefmwumVGwWm0I=;
	b=EV7Tn5MPd43tQbNiaHku1mtBNwdUuxmv3AmvrHs03vUlbjuAQlMS4ctW+czwFm1fOkXCH/
	ClVbhrhikHI1vA52xLfCX7B81j3bx9FQKEbcxIm7Iw0WuuYUb1xQqRkKzkaVfLoVlvV3rX
	6WE/BODrhEDLjF5dtdJvf17a7PXzH7o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LDs9n2IN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870495;
	b=w46MdIApQNxrK8Wr9eHUzRgiNGEEsMuSGPu2KCXd0d9uPLgibz7yvFn0jDIk/isE9mO5Bj
	Ij6RO9NtvBfLLxDA9c8tDfd/5ahImmBwj/Vhpitm2bzLn7YnMebCOfyS2GpemXETZQdvd2
	isHxG37+HIFh9PxQVeTdrTOSx88VU7M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CmLrmuxMcS4XtFnlW0SxWYP82KCApdHfstv3wqouCWI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794870493; v=1; x=1795475293;
 b=LDs9n2INltpG8YRkrxfuhfo94j0MfaFoD0RKJVw5vXySmI+i++4TjKr4Y6IJaDaXDgdbkOkG
 Znz627LAaecPrHTgZobp45Ez2IIngWPeUJwfADOX+yaLsiCzD/BthKWTHSQUENJpYc/nRPZuau/
 kysWGR1gop2zTriWce+SGX7k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 52396e59a3a35763;
	Mon, 16 Nov 2026 23:08:13 +0000
X-Mizu-Trace-ID: 52396e59a3a35763
X-Migadu-Flow: FLOW_OUT
Message-ID: <22894af6-fd2f-4c26-b74b-d950f55a4e1b@linux.dev>
Date: Mon, 16 Nov 2026 16:08:08 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
 <175e7fae-2254-4e13-a4ba-0d39fb82018a@kernel.org>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <175e7fae-2254-4e13-a4ba-0d39fb82018a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 41E47100002
X-Stat-Signature: 5r8hrxabxd8ou5wrkxjzqnuwwrxztehk
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794870494-481317
X-HE-Meta: U2FsdGVkX1/ZPiXqm+/mn8imi4/qz2X+ad+7LkM5HIem/jY8gpGLp4/elcvo5x+rtgscPUZ1AMqDrE9BMG81q/0wr/U3vtlXU4FJdm/3LfEjE6uNwRI7I4364+hFpCPUxjm95YhoLEpUiD7IXf0gZD0PR6XymVijzv7gi17u9adbhLcWKV2+Pq59nfjf9HvWOA11BtJONHtdpSs2w5yJLzsm+xf7vRHRDaN9+QCEEkbdnLT3zq37JQBLBOH8tdzWNoe8hwSMc5RPK+FWXh4xANPyWuJRLlmV4DrC1Hm42Ow5YsskmKIKa7GnQq1gjihHMFwWDuf7K15D92MFylHg5ikP/USyGKd8s0YhgzeLMwg1EHxH6hAAcfePCaPv8KGThfvfkfYGNhhiH2tmIF5Wb0TWHjiWU6ZS1UuZCiJdxZpyZFYrvMa1jMWw9sqwsb5EoWrFiH/TdeVzvR5F04d8Peb+BFcbbgW/EKD5Havjgrl3bWJxGupZHNEeslHAe+2UV7Ua9ZJUxdo/Fen/nvPMi8E0Vx7u+RywL6XpYQgYnF6kq5NOXcsznpKpHgukoHZ7HB5UbHj+q5Lv4DXpLojRHXOO45pUzWQWPxLpnJIQPN2Iu/oX6nGSy3j+s5LxCxnD2LdR3fGXTyOUvdTSUBpKYoXSCxBTI6yFIUtAxT5M96ubOxQgHYagmF30xqSnMQ3WxWRE44p9UyvCHqA7VNbHSVUFXnQIYbqYApXdYZDM2pDkmOR/WNCIMMrMSMO+xWPU7qzgjodwFQCGexXzKOwoFZzdh/NFPBfteigjJbJnjF+kdtoJ+VnHJDBwvlJ2VxX8gDWmYPEIc4+AE/bNT33vghP7FV8bTjABTdgGTVv3AUyLTZyWVVKJ+Dq26gV90TiHgPr3DiqOfW2uPqt815VRAxLCER9KElwYK1MC+S5QwFLsfGsE88OsW/LtE2aGCWSVr9WxToxHi+PuR1zVpAi
 z3XrujcE
 BloEd79CfXiAZFo9X9M3wfzORDbooK1KWSB7w+jRCpFiur6Y/Wh3bQoUDdfV5ldDc7cJjOUQ/XpYAbREnCv0MsuTigFIcAdNIh+2nuyZ7iH9UO0natvgdDiaEV5pSJAm+82a0VOd5njYfZmi6d1VeW8qRv32cLd9Hsi4P6wocAKIwSl0Hr0B75sop+JFh3sT1NoyI3ae7IY3vaW1+/bbIKrebntj8oa5IIJ1AY0XJCmHdzdJn5jsH5cFSbVpk6Emk4PtD99TRBylVw6O7yrxjI4z7ZfkhVj5aLPma8lKbC71kZjOQvWeGq3J5Q2dzSqEQ2Iulbb81KP3x/oRCjXsMweo/XVIhZvF3QC4mcjWCbPV96iSoobBBJkd0Hkd+C/p9BFtKP0JTO67Tu712hYaEh0AHc3PKgsNGsC1OTS5yzPcgr7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/26 3:30 PM, David Hildenbrand (Arm) wrote:
> On 10/25/26 18:39, Nico Pache (Red Hat) wrote:
>> The zero-page remapping in __folio_split() was added to support the
>> underused THP shrinker. When the shrinker is disabled via
>> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
>> to avoid scanning subpages for zero content unnecessarily.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>> Signed-off-by: Nico Pache <nico.pache@linux.dev>
>> ---
>>   mm/huge_memory.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index bd44d58e8684..2d56d1bff0ea 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4104,7 +4104,8 @@ static int __folio_freeze_split_anon(struct folio *folio,
>>   out_no_split:
>>   	local_irq_enable();
>>   	if (anon_vma) {
>> -		if (!ret && !folio_is_device_private(folio))
>> +		if (!ret && !folio_is_device_private(folio) &&
>> +		    split_underused_thp)
>>   			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>>   		remap_anon_folio(folio, 1 << old_order, ttu_flags);
>>   	}
>>
> 
> I guess the change is not that relevant in practice, because I suspect most
> people always run with split_underused_thp=true

Yeah these two patches are only tangentially related. Technically with 
this patch (1), disabling the underutilized shrinker would indeed fix 
it, as we no longer are doing zero-page remapping. But the root cause is 
the split initiated from KSM.

Most people always run with split_underused_thp=true, but they also run 
with 511 max_pte_nones.
> 
> Th question is whether "split_underused_thp" only determines "that we trigger a
> split if underused", or also "what to do when splitting a folio".
> 
> Yes, it was added for the deferred shrinker, but the semantics of the toggle are
> not quite clear. I don't think there is any documentation for it ...

Yeah Im not really sure if the intentions were to make all the splits do 
this zero-page remapping. And im not fully aware either of the potential 
impact to the system (whether positive or negative) this could have 
system wide. You could argue it keeps better system utilization, but you 
could also argue the cmp is expensive.

> 
> Disabling the "split to zeropage" entirely with the toggle off (behavior before
> the toggle was introduced) makes sense to me.
> 
> But the behavior now already like that in the kernel for a while.
> 
> 
> I know that I suggested this, but I wonder, is this patch relevant for your use
> case and patch #2?

Technically patch #2 solves the issue im actually trying to tackle. But 
during this case we also found this functional change which we werent 
sure if it was intended or not. As you say its poorly defined.

Im ok with or without this patch. Perhaps we can take patch #2 (bar'ing 
review), and I can try to do some perf testing regarding the effect of 
this zeropage remapping system wide, and base our judgement off that.

> 
> IOW, woudl RHEL customers disable this toggle here when running with KSM on
> affected systems?

That would be a potential solution if we only took patch #1. patch #2 is 
also viable (and a better) solution to solve the KSM regression while 
keep the shrinker available.

-- Nico


> 


