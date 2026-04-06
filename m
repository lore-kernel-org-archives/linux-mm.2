Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CE2EF4EC9
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0C06B00AB; Mon,  6 Apr 2026 05:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A988E6B00AD; Mon,  6 Apr 2026 05:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE456B00AE; Mon,  6 Apr 2026 05:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89B4B6B00AB
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:21:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43BD0C18BC
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:21:49 +0000 (UTC)
X-FDA: 84627588738.30.A9A33F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 640991C0003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:21:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OPDC+7uX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7brLVBbt/2vJX86SniNxOC4s3K+St3pyFUU7bpORVDA=;
	b=YIj3Zq5JsfzTVMHTQnx2tq57+mF7gKtgwJgsvumsmZrGisfD0H9xR84EkpnRnm26gzejj0
	wtFJQC8o+5L3BzOZTuwXo69lUgKHek7759THk4RFYC6nucgM6lNJOKK9wExe4VqdTc3I0Q
	2A7UGwy849kmVotTfK32K+4fv5JeEDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467307; a=rsa-sha256;
	cv=none;
	b=GyD2p0694I1WfvoVjdhd78D7RJm1tB4aUPlgE/xCpY4KnphGWNXclVmSdrqAcl3gDR5SO9
	EVIQuPSi8h9yRrTH3DbpftT377+FhppWC4YVE+yEVWG73KGMlOSeBWYVpH7zjxD3VMCs6A
	2mcm+nABY/h2ZeKDjVcOj1lnY+kJuIY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OPDC+7uX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69CCF402DE;
	Mon,  6 Apr 2026 09:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E64C19425;
	Mon,  6 Apr 2026 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775467306;
	bh=fhg6BtIGhbmFMSd9SUmDv0Uh+zl0kmiOHGSsPw4uSYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OPDC+7uXvv8RPigLxb7P6WGuldZMzaT4gpMCKFxsI8rE3B7f83451+wSMcqtJNQiS
	 peQxUdtPT2HvktkNW6MuHynWTTS8+T7YXITEIJUJxpHEUcYAqQCRSUOQLcX24CvbJ0
	 nppaXd7F2oe1Su8tWkycHZh0lM6XtaAa8VXuhvl/tDlYbQk7Hqu8vb+S0rkSQaZ3R5
	 kji8V/YeKtwjCQu7HSlBn228dzmLdZbw8UWdJLcBovl1AjhzEcnY6LdPuhGajpiN1F
	 UCAByJSqNKIZbSDX/eGyHm8LT3UXqbu8ZcSJE0sBsptpvV1g8a6z5uTTCDYI5Vr6d1
	 sNRzYHvp34W6A==
Message-ID: <8481d0dd-2471-4acc-a429-cbc02451a812@kernel.org>
Date: Mon, 6 Apr 2026 11:21:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: Hugh Dickins <hughd@google.com>, xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn,
 Michel Lespinasse <michel@lespinasse.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
 <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 53qo9xaahiyn59cus1ctuskxh8rk7t9i
X-Rspamd-Queue-Id: 640991C0003
X-Rspam-User: 
X-HE-Tag: 1775467307-726738
X-HE-Meta: U2FsdGVkX1+0WCIf3gfNxhTuoVWhXXPiKj3bA4DpwFOrRb59vyMo4FgiiWHYjRuLKV8DrJ4yFgwGfqPYiOWxexCeCEMKmxyrZiYjhHEcj7YTWeGZNLCi9sXJ3NJ1UEb8Y7p8B7MxPQpGkH1RvdKb7KCUACEr/hJ6LIBWFiRRn+qXe6scwAo9qyMG+NZHxgLXGsWIBr3LONNpe9j3hOXD2kIDlkUh713yHBLu7RF88GnIUPZtyYZgJUe6qkFU4yicqBEsgok+11Q2z4pu0P5TM/ruBvD4eUMw5NuO524oxbG5QaEcMF4fTHhoyPfMYhN/rHzcHu0g+OxR5h/bcfmMumgJ+OizRngYkF0ixGz6qMBSuxQAq8OdPp/aoeCPep9wnVnnjlbWtDG2ZCbP52VPhYLlNCJzd8or5pE+xdotFd2CbLCaMl9nBB5FKny+pDENwI7TkDaoiAwAOwsZxpC0s1HoZklPmarOh46r99Zo46R1L73a69XEEncShqdq8rYU6hhk7U2SvnxIj42UCcoyfj4pb3L0K72OSnn5HJ1FpgjikeuqLgwJINrEiyDNLKUXJ2XG/BYKm0dxckvWJnX90T+aEDfs+9oQ95opeBFuNkxhov09UFjrQ1RlSx14Iqk+AUNH3ugPGpsGYsNBMz67HcBGg+4m6U56UuOGLGGuHY5bbGDiTz+pvUsf85ZmAQye8MCQ+8weI4NMKDUtHWThs14k62OQ3deGGHTmUKZyF0iTsQUq4atm29ehKC/ppLNwkhlX5xYWvXZ0DtT8bEPLB25EiKZCsCqKweYqpYEnjdEHfLs+4Wdpbbqon+/ALg5ZLCr95Bapgm+5Yo3+o3rbuUB50FYcJ2ukvDeBZ9lPE6N1mRDiQi7VUBNzx6fz1zzAHrTku9DPyBs6GdiELE9ua3lpIAU0GqqGPBZ3G6b2npTzoQa1e5VSuUYLSxgYwwirTYDTTl1KkXup/uyNF3F
 47k4V9Z5
 Lg2J4HGa6RtNOHPrvhORxktOYNpyWQGPmlKOYFEkh/QXaZU1QR0birnjwt3+MtfJjBCooR2PP5kaZZTmceq4nyzqMZCBsgkTgS4rjqzerpii5Jz5tu4SfGUXJsmyKs3leuL4+eJZE9KYn/W+9oHdkzMVR8sO9nuSthzx5b75I0zCT7klz+piHDLGuvSl1+0bH3Hm2CK1CqOOmf07CN9dqN1X8qjps3fGS71wv2VQfNsuD+IxTFoIKDy1l+ZE0jxheB/TjQUZjzCYd0pKeagRa68DfGqvltf3R2bTMxDE9ovRKY9Of+joPOwVOPvQb44tX+ydIn4I+dDlWsa7qbZtJmPBOgCQVmLKsbKNefCsXtmmW72/yjr/QbTVRx90hcXGayCUvOq1D+NtiePA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/5/26 06:44, Hugh Dickins wrote:
> On Thu, 12 Feb 2026, xu.xin16@zte.com.cn wrote:
> 
>> From: xu xin <xu.xin16@zte.com.cn>
>>
>> Problem
>> =======
>> When available memory is extremely tight, causing KSM pages to be swapped
>> out, or when there is significant memory fragmentation and THP triggers
>> memory compaction, the system will invoke the rmap_walk_ksm function to
>> perform reverse mapping. However, we observed that this function becomes
>> particularly time-consuming when a large number of VMAs (e.g., 20,000)
>> share the same anon_vma. Through debug trace analysis, we found that most
>> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
>> excessively long hold time on the anon_vma lock (even reaching 500ms or
>> more), which in turn causes upper-layer applications (waiting for the
>> anon_vma lock) to be blocked for extended periods.
>>
>> Root Cause
>> ==========
>> Further investigation revealed that 99.9% of iterations inside the
>> anon_vma_interval_tree_foreach loop are skipped due to the first check
>> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
>> number of loop iterations are ineffective. This inefficiency arises because
>> the pgoff_start and pgoff_end parameters passed to
>> anon_vma_interval_tree_foreach span the entire address space from 0 to
>> ULONG_MAX, resulting in very poor loop efficiency.
>>
>> Solution
>> ========
>> In fact, we can significantly improve performance by passing a more precise
>> range based on the given addr. Since the original pages merged by KSM
>> correspond to anonymous VMAs, the page offset can be calculated as
>> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
>> defining:
>>
>> 	pgoff = rmap_item->address >> PAGE_SHIFT;
>>
>> Performance
>> ===========
>> In our real embedded Linux environment, the measured metrcis were as
>> follows:
>>
>> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
>> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
>> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>>              and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
>> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>>              in a loop of anon_vma_interval_tree_foreach.
>>
>> The result is as follows:
>>
>>           Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
>> Before:  228.65       22169                 22168                    0
>> After :   0.396        3                     0                       2
>>
>> The referenced reproducer of rmap_walk_ksm can be found at:
>> https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/
>>
>> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
>> Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> 
> This is a very attractive speedup, but I believe it's flawed: in the
> special case when a range has been mremap-moved, when its anon folio
> indexes and anon_vma pgoff correspond to the original user address,
> not to the current user address.

[as discussed in earlier versions of this patch set]

mremap() breaks KSM in the range to be moved.

See prep_move_vma()->ksm_madvise(MADV_UNMERGEABLE)

So I am not sure what you say can trigger.

But I'm just scrolling by, as I'm still busy celebrating Easter :)

-- 
Cheers,

David

