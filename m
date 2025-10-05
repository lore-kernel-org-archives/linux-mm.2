Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E930ACAC5BB
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 02:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D968E0005; Sat,  4 Oct 2025 22:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE5D8E0002; Sat,  4 Oct 2025 22:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3A88E0005; Sat,  4 Oct 2025 22:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA638E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:44:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9884B86244
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:44:47 +0000 (UTC)
X-FDA: 83962517814.13.B927ECB
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id D22BF100006
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:44:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kraA/Zlq";
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759632286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yzti7L513fCnAHWE2nv71dafGe6w59qWQQTJz5a8Ckk=;
	b=UFqwACxvohJw3YZwNlhKLIPFCt5T/zD2es0sIswW1CAxJMUOBky3YQMTFFPB/+MBiTDNJV
	Yqume8Hmr6UWdLdDZAaMKjresWsYF1wqzmQ6wSwTFimF4+GznWpBIyR/+NnnC/WFLpzp55
	PZzi+C/RuxEE6kRnzed+Rw0PWoN3+cs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759632286; a=rsa-sha256;
	cv=none;
	b=PrFWG3XRh3CwZG/7LSvhRr+NdRVChJMOf/hKPROzppCR7P4Ay2cIX9+c9vS3rRHWWmwCHj
	/OrgFqg1tspObunNduWsyTWbT/eoKLLf56DCUJ289uBKxTa/Z3lyqrvoC4G1Sz/cDAuOHD
	UQGKgMhSn+Sv0kSCgj5kI29a+IVLagQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kraA/Zlq";
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <8c7c241a-f9fc-47ca-b02f-7adada140d79@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759632283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yzti7L513fCnAHWE2nv71dafGe6w59qWQQTJz5a8Ckk=;
	b=kraA/Zlq3ghO49fHdyoaMGEiqZYiXVL9lbL9P424H/NWyQACv4WUthYco0r6fyLkQJlj3J
	RiSdoc36z9tQKRst27isvRQmhJB3ixDzjIIvqjftDzbOeIHNqnxQ+Y0kNeEXhVkLVY2BxL
	FDTzcTJhB6juFGVr7/kpHJy+2lnz5v0=
Date: Sun, 5 Oct 2025 10:44:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
 <20251004094217.bah5q2zxczrqontm@master>
 <f235a557-d031-4fcd-8c68-81d9ab7b54e0@arm.com>
 <054ca3f1-b219-49dc-9c4a-6f648b9df7f1@linux.dev>
 <8FF0358E-1ECE-42DA-AE4B-8D5A578450EC@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <8FF0358E-1ECE-42DA-AE4B-8D5A578450EC@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xy3tmw4im7hi3us7b98pn4aqmsb3d4b4
X-Rspamd-Queue-Id: D22BF100006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759632285-208573
X-HE-Meta: U2FsdGVkX1/vgTrwn6YUytfWfDXv3cktNcK9Co2uZiKkhQKuqtE9M+H1hTq+TQQgWm4k/sjR7jq6yuJq53D/rAk4qM9ek0Bc0/KV1GrqSG/6IyQvPppbPlZhqJiN1LVFHkBVBsSKwEvr28SC3vvj4/dI7vWHCANvciwgibTnE/K6pKKxc8SatSKQXSv8Jj/T8NiWrfgj2XQW4fVUWKd1EhUrx6Dd9NpbfxSezOuUJOFIUSWPCTG7xp3i0n0s9+54k+pUEuqeTsegF/xu9rPXGL8V3+Ljkky8vbL8ZKbWqXzMCXNC+L3WPmlWVBmKAicPfqpXDsw3PbZQhMUBEZ/dxc0YBK6w530dJRRvPuT8LNt7yHy7fwzyueMXqJ9yGIYjNz7xo0jxBy53kYZOPr86nlW+Wy37zGv6S3WPp2KVE6S34NV6M9fEG8QWJ7VxQ/hTx4Ll4p/OPEA7pK6B7YTW0je2Ucb01OTAnbRhDa/WldhXik7ezXAxSbYbFaj1ee9OrjenEagYUAHs8b4ql1seQfv/Sqy3FQbP/AiMepd1i3UT/Lzk2+og+kFY3KPc8rQLlg0txAmLcNS6GxPZKOrGjSkpByXcOevZgTrnRz02LiQHWU4qDCbW79r3xfrWUtLELFcAcqx3rr8C1+LfgKDvCFWi7rleVN3qm9L5GDEE+f9HkYquu+DVycS+ObsqD/TZS6eBlKbrUxcZnBjppGG/WLtj7Q0a5Q58AlrHIp3VaB+Bq44JRNSqB98Sw7WDgI7uITXQJe/DOpQEITOUxyZ5NjM+9Bw5fEl4qZTMsD3wfsjauUSzXKW3Uq4+3/lSSIjeh8W3OnEL98tne+0sM9fOXnIQLojBOCNco29ftZymJossjDgj5vl3W4hFreB9TmmUUy2hdQTnIzxEDndqIE5piz19Y0cwhpBlP9IHc68CU7PxN0sgY02FtCE5viyzb/sXqzl1paA+fP9fbkVJOKq
 6Tsh0CII
 R4NjCKsvBwz6GckdMEFMCdTgMOrSzIy2TP3nJAhfWwYzqmfNjDeuV9FUJk+iCYHxSpu+Ue8agal5PYs3sE3DtnXdm/zdQ2VV5DAMLPWw/4qkRplsTUK9660QNzBtA8FBdcbf3hJLyD0m8yAXP0z7l1PXhvu/qbRAkg4WUff8PocdW2/SqN84FgEj2OdDxvMFYUfn6bRXpPO+eKrXN99a32flF23Z9ZO+lQ+PU5fOVSoMjDb7s5r0zRqpuvKKdQW/OlRcl22OBtSMpOOi1ZdqhhS5UORIgp7dYIOv/oifGL1hlnumeOXCH6qB3Cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/5 10:38, Zi Yan wrote:
> On 4 Oct 2025, at 22:35, Lance Yang wrote:
> 
>> On 2025/10/4 21:11, Dev Jain wrote:
>>>
>>> On 04/10/25 3:12 pm, Wei Yang wrote:
>>>> On Fri, Oct 03, 2025 at 10:35:12PM +0530, Dev Jain wrote:
>>>>> On 02/10/25 1:02 pm, Lance Yang wrote:
>>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>>
>>>>>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>>>>>> and __collapse_huge_page_isolate() was almost duplicated.
>>>>>>
>>>>>> This patch cleans things up by moving all the common PTE checking logic
>>>>>> into a new shared helper, thp_collapse_check_pte().
>>>>>>
>>>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>>> ---
>>>>> In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for
>>>> This is true for the first loop, but we will unlock/lock mmap and revalidate
>>>> vma before isolation.
>>>>
>>>>> an anonymous vma, is it even possible to hit if (! folio_test_anon(folio))?
>>>>> In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
>>>>> till the folio_maybe_mapped_shared() block?
>>>> But it looks still valid, since hugepage_vma_revalidate() will check the vma
>>>> is still anonymous vma after grab the mmap lock again.
>>>>
>>>> My concern is would VM_BUG_ON_FOLIO() be too heavy? How about warn on and
>>>> return?
>>>
>>> Frankly I do not have much opinion on the BUG_ON/WARN_ON debate since I haven't
>>> properly understood that, but this BUG_ON is under CONFIG_DEBUG_VM anways. But
>>
>> Yeah, VM_BUG_ON_FOLIO() is under CONFIG_DEBUG_VM, so it won't affect
>> production kernels.
> 
> Many distros enable it by default. For mm, we are moving away from
> using BUG_ON or VM_BUG_ON. No need to crash the system if it is possible
> to handle it gracefully.

Ah, good to know that, thanks!

> 
>>
>>> if you want to change this to WARN then you can do it at both places.
>>
>> It should flag such an impossible condition there during development.
>> So, I'd prefer to stick with VM_BUG_ON_FOLIO().
>>
>> @Wei please let me know if you feel strongly otherwise :)
> 
> 
> --
> Best Regards,
> Yan, Zi


