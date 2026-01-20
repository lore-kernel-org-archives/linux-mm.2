Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB33D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 11:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785BB6B03C9; Tue, 20 Jan 2026 06:38:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DD26B03CA; Tue, 20 Jan 2026 06:38:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6869F6B03CB; Tue, 20 Jan 2026 06:38:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56D716B03C9
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:38:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D04061404B0
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:38:23 +0000 (UTC)
X-FDA: 84352144086.02.8E80B3E
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf13.hostedemail.com (Postfix) with ESMTP id B0A0120006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:38:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xoQOYj1f;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768909102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLjY/4B4aU0tiyH4zKLoN88x79CrKM/2QcD82GdY0Aw=;
	b=X7a+Tq5KVYAdpkCh15bX8a6ii0OcwpU1nEtzfYEllmTwJKy32yn9MrkKRbvO1DOhFqIJhc
	B3kAyYA552xwYxkbppgjXt4tHuFNNBACdHLA0mp3vKK2GzRQfRPVhvoUzrgRm4sYz4qRi5
	0PpB1VK8lWhmUwf0ghTjPX5PBojwwnE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xoQOYj1f;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768909102; a=rsa-sha256;
	cv=none;
	b=tVe4Nk3BLBzkUcIZWRhVLf5l8b8vDyBLE/kQdYYyQJYtqxIZt7FFVKffRdZbVo+lsOKPsa
	iYR402etB0gNoiSlgwJCkjFpNp9yxeW0/F5/wJs05bJMgWXpLI0FSzHJU+RIRpJGiMKEnF
	DL7YI0fG49CZ6NV/YC0jESILWKcS9mU=
Message-ID: <bd464b0f-e396-42dc-9850-4b21e1c525ce@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768909099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HLjY/4B4aU0tiyH4zKLoN88x79CrKM/2QcD82GdY0Aw=;
	b=xoQOYj1fvHhW3ghjYtoNiZgeOBuw8F5d3DA2srvPBuKdBnAIsaL9Hx+kz35x7AvUnVMJ0G
	K4NPHfEpaq0vmZLwMYRxp7jWRLCfGFQbrcCg6Gz3kyKdrTZemgwqm4CruTlCwLN5SNUCGC
	j0srSKc66/KBL0Qvedu67IEcm55VDZE=
Date: Tue, 20 Jan 2026 19:38:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/1] mm/khugepaged: move tlb_remove_table_sync_one out
To: hughd@google.com, baolin.wang@linux.alibaba.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 david@kernel.org, dev.jain@arm.com, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, npache@redhat.com,
 rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com, vbabka@suse.cz,
 ziy@nvidia.com, qi.zheng@linux.dev
References: <62e637cf-91e6-454d-a943-e5946bdf7784@linux.dev>
 <20260118083911.21523-1-lance.yang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260118083911.21523-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: fbnixhsj593o5167tt3waisxrjp3ugwc
X-Rspamd-Queue-Id: B0A0120006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768909101-93580
X-HE-Meta: U2FsdGVkX18E4EfOkpKURtYoctS47FLCKcFwmfu+Kh4zSIQci5bYvJ19Rsy5miDdLJGBUkunq+D2H0cxEz06r4wL9nnxxndqyiAX0iO7ORZ0z3d6kfx5cZyZPr1ONr50YVSIYFGmtTcZ1CVi1/hC0g1GfbZFg7TrBeXIqsnHfhwUJ4ia7EFv55Ftuy1Fepj1Rf1jpSUj8/qQsxjjlitCn4isgPO9UI17xu9jT4/AWWSCZ7Obc+e3b+jbUQ1A1Jhq0m8dPbi3fgew3frLL/GVKtIJEuTA09i8UaZ6ic4M6Xzb2gHrGDhx8IeFA/19Q0YJWeQ/nEpRRGPcLtFB5YPAG5uG+ZWy2cNjX83v7qG6U27057aSPRj4YYJstbCjH5KhMOvEyCqmzS1LoksUhYjsLxoxK5L0YbF0Kzr52fjeFMjBlagpJ/r/YPW7l+bkWKlIGG0tkm3PzKDnuDwKlnZI9oPtH0QOyZHEb3/NNKHZCkvAirMIJ6arS6SeLs5beEhr9pTLLl5OOWJh9zruEfGjzEwRBLdbSLW1/gcZvkJUCvMzCJdwUL4GmDsQd53O2xDG+apSY+6o0JC/dNgkxw+QY1zJqY1f9JLFr7iczSbKLUh95g70KpG2VhJSrX+3n1/pVV19v1nBodmLGnaN23hdddUVRpTiYOIrvDb+EVSJfG9Su0K0S4tGhV8TfUH0DBjcMDXog5kUy3JPYRiM3DSHhkl01/rhMOQUUTgEIe4CTVpOF2cerZ94pXI5U5PcsPtdRXbCz21817dN7eXnOSc5YmJYgz/v1qYT32vHClHl17XSSrh4wgs/RXbLNsAgJkB9+p29FlWx03LZ1X7oFCO0i6vwYS9JjP3lZyY/Eb9l9ZSHDLn8/n4s6LoT+dZcQalq4ZcNSAWWydjVcraxSEEyZIP+oZGFSHopN/OCRGt3PFW7PDUHKBO2wkbIXtD+DQTAc41+Zo8t9IUCRN3vjmD
 DclqU31H
 7ubJo6Bw9ulRfIe1xD/6aRjSDmGRtY/fTqZ2wldy49pgNqAEqU9rrGV7L1isEpc+SZ+ifkfBOCMProcs5MgXCQhV6w3g/zGaZuXvHZN56jMMAdI4yGLBOxjhhbTg4OsA7Yxa04gD2hfIVibwRdl3NTrtu8wcniNBN0aexj96oHqGc5btgk9cy0BQH3n19VkcDjdNSn8iBB3yE6jxruwY14EcYw7Jwg7PCkzN88Tshyqug6UzaTtU9xIrQVWFVlDB/mT+WzUorHcv8sW2sYrnugX4Uig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/18 16:39, Lance Yang wrote:
> Hi Hugh,
> 
> Could you check if my understanding is correct?
> 
> On PAE, pmdp_get_lockless() reads pmd_low first, then pmd_high. There's a
> risk of reading mismatched values if another CPU modifies the PMD between
> the two reads.
> 
> Commit 146b42e07494[1] introduced local_irq_save() to protect the
> split-read, blocking TLB flush IPIs during the operation.
> 
> After modifying the PMD, pmdp_get_lockless_sync() sends an IPI to ensure
> all ongoing split-reads complete before proceeding with pte_free_defer().
> 
> As commit 146b42e07494[1] says:
> 
> ```
> Complement this pmdp_get_lockless_start() and pmdp_get_lockless_end(),
> used only locally in __pte_offset_map(), with a pmdp_get_lockless_sync()
> synonym for tlb_remove_table_sync_one(): to send the necessary interrupt
> at the right moment on those configs which do not already send it.
> ```
> 
> And commit 1043173eb5eb[2] says:
> 
> ```
> Follow the pattern in retract_page_tables(); and using pte_free_defer()
> removes most of the need for tlb_remove_table_sync_one() here; but call
> pmdp_get_lockless_sync() to use it in the PAE case.
> ```
> 
> Regarding moving pmdp_get_lockless_sync() out from under PTL: Since
> lockless readers (e.g., GUP-fast, __pte_offset_map()) are protected by
> local_irq_save() rather than PTL, pmdp_get_lockless_sync() can be called
> outside PTL as long as it's before pte_free_defer().


Looking at commit 146b42e07494[1] again, it says pmdp_get_lockless_sync()
should be called "at the right moment". I now realize moving it outside
PTL might not be safe.

If we release PTL before calling pmdp_get_lockless_sync(), another CPU
could set a new PMD while a lockless reader is still in local_irq_save()
reading the old PMD (split-read). I'm not sure if this race is actually
possible, but if it is, it would hit the ABA problem where the reader
gets mismatched pmd_low (old) and pmd_high (new) - the "faint risk"
mentioned in commit 146b42e07494[1].

On Native x86 PAE, pmdp_collapse_flush() sends IPI and waits, preventing
this race. But on PV, the hypercall returns immediately, so we need
pmdp_get_lockless_sync() to ensure all IRQ-off readers complete before
releasing PTL.

I should keep it under PTL to be safe.

Sorry for the churn :(

[1] 
https://github.com/torvalds/linux/commit/146b42e07494e45f7c7bcf2cbf7afd1424afd78e


Thanks,
Lance

> 
> In contrast, for non-PAE, PMD reads are atomic, so pmdp_get_lockless_sync()
> is a no-op.
> 
> [1] https://github.com/torvalds/linux/commit/146b42e07494e45f7c7bcf2cbf7afd1424afd78e
> [2] https://github.com/torvalds/linux/commit/1043173eb5eb351a1dba11cca12705075fe74a9e
> 
> 
> Thanks,
> Lance
> 
> On Fri, 16 Jan 2026 09:25:54 +0800, Lance Yang wrote:
>>
>>
>> On 2026/1/16 09:03, Baolin Wang wrote:
>>>
>>>
>>> On 1/15/26 8:28 PM, Lance Yang wrote:
>>>>
>>>>
>>>> On 2026/1/15 18:00, Baolin Wang wrote:
>>>>> Hi Lance,
>>>>>
>>>>> On 1/15/26 3:16 PM, Lance Yang wrote:
>>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>>
>>>>>> tlb_remove_table_sync_one() sends IPIs to all CPUs and waits for them,
>>>>>> which we really don't want to do while holding PTL.
>>>>>
>>>>> Could you add more comments to explain why this is safe for the PAE
>>>>> case?
>>>>
>>>> Yep, IIUC, it is safe because we've already done pmdp_collapse_flush()
>>>> which ensures the PMD change is visible.
>>>>
>>>> pmdp_get_lockless_sync() (which calls tlb_remove_table_sync_one() on PAE)
>>>> is just to ensure any ongoing lockless pmd readers (e.g., GUP-fast)
>>>> complete
>>>> before we proceed. It sends IPIs to all CPUs and waits for responses -
>>>> a CPU
>>>> can only respond when it's not between local_irq_save() and
>>>> local_irq_restore().
>>>>
>>>> Moving it out from under PTL doesn't change the synchronization
>>>> semantics,
>>>> since lockless readers don't depend on PTL anyway.
>>>
>>> Cc Hugh who introduced the pmdp_get_lockless_sync(), to double check.
>>>
>>> Sounds reasonable to me, please add these comments into the commit
>>> message. Thanks.
>>
>> Yes, will do. Thanks!
>>
>>>
>>>>> For the non-PAE case, you added a new tlb_remove_table_sync_one(),
>>>>> why we need this (to solve what problem)? Please also add more
>>>>> comments to explain.
>>>>
>>>> Oops, you're right, the original macro was a no-op for non-PAE.
>>>>
>>>> I should just move the macro call out from under PTL, rather than
>>>> replacing it with direct tlb_remove_table_sync_one() calls.
>>>
>>> OK.
>>
>> Cheers,
>> Lance
>>


