Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BBFD29FF7
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE596B00C2; Wed, 14 Jan 2026 06:55:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC276B00C5; Wed, 14 Jan 2026 06:55:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80C06B00C6; Wed, 14 Jan 2026 06:55:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98CF66B00C2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:55:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AE8F5904A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:55:20 +0000 (UTC)
X-FDA: 84330414000.30.BE5C442
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 692C5C0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:55:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9UG6VOW;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768391718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sK8iZ8mING7+O9bDlAge3/C0+QMf1lhgGwbsCb26KGU=;
	b=s8hutSEm7JxlUug99xKJXasulUE8n4sTvbdPwJTmJYGnptkuf4eRln3c8i1MXpDEwP4dWL
	24RGdhuDFY3URnYa61K/LCclqhRGkbnA+/ebBAGsYbLu5qxZq5yMD69P7mW9mYwUWnj+D/
	Rlgq5tZ6xTESJQAkFg5kMY/Ld7ytWmo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9UG6VOW;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768391718; a=rsa-sha256;
	cv=none;
	b=RFgSRmvf0GFdG9gWi3DbJzmsM0GJC6n4sIXSLmB6w5cnzVYngelSOeRjTTentXH65fN6lp
	jrV6Y+ghY26Ax2qZncbt2BWzWeSzJG4lE4ydVywryDtHtvu4IQ4m8b253q04VE3cvg7juf
	9e/dV3hUz9SSH/Lew0lQx2aHCR7ERKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 618FF406CF;
	Wed, 14 Jan 2026 11:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0FBC4CEF7;
	Wed, 14 Jan 2026 11:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768391717;
	bh=TGLnAOZEnluJL7qVfeusuM/e5JiEfUlkxwku89gsD1I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p9UG6VOW3ganQU6RMIS1RtGAMfEa3dZfN228V/Yuxko1x39f7bWpdV7IwRu8hi3cx
	 h5Ca0y/VhAHHbsWiF+Vb93qKAy/rpcp5DAbGuWgPTbqROtIYOBRbFL0hTYNUTfXK8R
	 15LPWrGCppUzmw4u3VtCGjMPwmQTA03SEsurFG9zDbyZwZCXEUYX8ItCBUw6LFWBHY
	 GohlUayuu9PQeRlwG9JtOUTDMKhIB7YzNqotdy4mawHOrYZyV0piLB105CGTdsBeS0
	 5IfjvwJkGDmRaBmOw9MOMFSbYjmp3IEOzBBb3skQh7Q/Zdc8gvu5KbP4UPb+rFyEEh
	 OICNoNBTydgcw==
Message-ID: <97413239-2bdc-456f-8511-65fb9f1e301c@kernel.org>
Date: Wed, 14 Jan 2026 12:55:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, ankur.a.arora@oracle.com, fvdl@google.com,
 joao.m.martins@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@suse.com, mjguzik@gmail.com, muchun.song@linux.dev,
 osalvador@suse.de, raghavendra.kt@amd.com
References: <3d8398f1-0130-4d3b-ac54-d23877811747@kernel.org>
 <20260114113635.97621-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114113635.97621-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 692C5C0005
X-Stat-Signature: yun5xxf9jg1prfzq5iukyzptoigbmme1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768391718-773680
X-HE-Meta: U2FsdGVkX1/3yaq3CBQLHxb0TzySUn263cwWjDVgjg1P2v9Uh5ZpDm5RizJu5ow/gMZf+Sntsqui6ZQJTvUI6zGKXfjNrlO5O3WUxLhr8gPbxIr6CuYuiLlt/0oI7ktiSkD0ZpH04sIjk+Jze1k+WoQKlbKBMoYy8IoZ1c/Xut1IIBeQDpcS3m7m6dQUlH2qmb9yFLDS9I/JvPLnrHaBr88vyTY9PMxnIo7vwCiK314MzTxTAuLoccEHXzAWsW6oWZpk3c4H6Rl+hU/EplMQYjZjikbKbEr606CiVfqHZ+tg8h3aZwrGXB3CBYLKx7gAb3bwM48vyFbvVDTzX8L8vxC+19XuAbW1/1i2q21KC6r0lT4VfJ6vNe35gF5McfU9LuUoXfV0Y3UK+scK7ZoN1lDQtWwcNbKp20Io2j+rSiuHFd1kDFHVP/vx8zsIMsyJCz5PCVGS6KbQvkSWKvbEb4qKuY0Qq7KypPK1didydOHOiNcD/C51fKjooEZPPToFqvqTIe26zRfPzJk4JIcJBk9d3WRPfffclMznBAVD0nNPvc8A80CBgv2qTosSHopCEc7XsEGtwfx0BuLhanEuQkQuQbDRBnaZ/8VrvbssUjVd6bbSVFjyigdKjyu0/VZJU5q8sm5F14sms5nwNnwjBU/24MU8O0fetjAFWTOsr4jgcoH9dRcy8zDS9TIrQwcZ+l1Z8lsuLl4nNhEinCw1Dvtt0Mkb1uZ13Jga1IFzlmacUHh5ZJLYL0o7poQcjEijETffiYVSV0zb8zdZdSw9mQO5u+6T/RPA9DMmUQTmAdzwBslGjw2LeOhGpVTPtEX6b1FtsgPURFfsG7Jhu22EC148C38Lx+lSult1rd2iMTZKbohzCO1DAn3KwT8MsjEWBaoALReimwdO/7Lr6Sk/iH7FrdanZiz0vooWCsvjt+yQQHot5Dpc8zikAmw0KORBgOLZ0I/UReKc4eJ9Ahb
 Ra5Mib8Q
 8M1fZzs9z8nBGOILZHRvF2Rkn63waYOfYek42RndsV/8hQgdaiadHl/Q5WVpkIF4JsbnhZrLetqU9lJ30p/5bs4ZklpDjmIPZHbRuxAKNTcXjUN0XPeGwsDP4gZ9fmsfAfTAquAZpdKqhZBM5iCjb6KBVRSpaQRn6XEW85ObTIaYeU8to2VlMUmcapO8W9trlEgTId2euAbpEMxGn4NL3Hj1QCepXL9Z9lMg9rfacYLpArTlF3KRgP7bJQcptEuyGlM9eWqsLLGA+wAfljwZ48YFoBSFR8vS/h6zZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 12:36, Li Zhe wrote:
> On Wed, 14 Jan 2026 11:41:48 +0100, david@kernel.org wrote:
>   
>> On 1/13/26 13:41, Li Zhe wrote:
>>> On Tue, 13 Jan 2026 11:15:29 +0100, david@kernel.org wrote:
>>>
>>>> On 1/13/26 07:37, Li Zhe wrote:
>>>>> On Mon, 12 Jan 2026 20:52:12 +0100, david@kernel.org wrote:
>>>>>
>>>>>>> As for concern (4), I believe it is orthogonal to this patchset, and
>>>>>>> the cover letter already contains a performance comparison that
>>>>>>> demonstrates the additional benefit.
>>>>>>>
>>>>>>>> I did see some comments in [1] about QEMU supporting user-mode
>>>>>>>> parallel zero-page operations; I'm just not sure what the current
>>>>>>>> state of that support looks like, or what the corresponding benchmark
>>>>>>>> numbers are.
>>>>>>>
>>>>>>> As noted above, QEMU already employs a parallel page-touch mechanism,
>>>>>>> yet the elapsed time remains noticeable. I am not deeply familiar with
>>>>>>> QEMU; please correct me if I am mistaken.
>>>>>>
>>>>>> I implemented some part of the parallel preallocation support in QEMU.
>>>>>>
>>>>>> With QEMU, you can specify the number of threads and even specify the
>>>>>> NUMA-placement of these threads. So you can pretty much fine-tune that
>>>>>> for an environment.
>>>>>>
>>>>>> You still pre-zero all hugetlb pages at VM startup time, just in
>>>>>> parallel though. So you pay some price at APP startup time.
>>>>>
>>>>> Hi David,
>>>>>
>>>>> Thank you for the comprehensive explanation.
>>>>>
>>>>> You are absolutely correct: QEMU's parallel preallocation is performed
>>>>> only during VM start-up. We submitted this patch series mainly
>>>>> because we observed that, even with the existing parallel mechanism,
>>>>> launching large-size VMs still incurs prohibitive delays. (Bringing up
>>>>> a 2 TB VM still requires more than 40 seconds for zeroing)
>>>>>
>>>>>> If you know that you will run such a VM (or something else) later, you
>>>>>> could pre-zero the memory from user space by using a hugetlb-backed file
>>>>>> and supplying that to QEMU as memory backend for the VM. Then, you can
>>>>>> start your VM without any pre-zeroing.
>>>>>>
>>>>>> I guess that approach should work universally. Of course, there are
>>>>>> limitations, as you would have to know how much memory an app needs, and
>>>>>> have a way to supply that memory in form of a file to that app.
>>>>>
>>>>> Regarding user-space pre-zeroing, I agree that it is feasible once the
>>>>> VM's memory footprint is known. We evaluated this approach internally;
>>>>> however, in production environments, it is almost impossible to predict
>>>>> the exact amount of memory a VM will require.
>>>>
>>>> Of course, you could preallocate to the expected maximum and then
>>>> truncate the file to the size you need :)
>>>
>>> The solution you described seems similar to delegating hugepage
>>> management to a userspace daemon. I haven't explored this approach
>>> before, but it appears quite complex. Beyond ensuring secure memory
>>> isolation between VMs, we would also need to handle scenarios where
>>> the management daemon or the QEMU process crashes, which implies
>>> implementing robust recovery and memory reclamation mechanisms.
>>
>> Yes, but I don't think that's particularly complicated. You have to
>> remove the backing file, yes.
>>
>>> Do
>>> you happen to have any documentation or references regarding
>>> userspace hugepage management that I could look into?
>>
>> Not really any documentation. I pretty much only know how QEMU+libvirt
>> ends up using it :)
>>
>>> Compared to
>>> the userspace approach, I wonder if implementing hugepage
>>> pre-zeroing directly within the kernel would be a simpler and more
>>> direct way to accelerate VM creation.
>>
>> I mean, yes. I don't particularly enjoy user-space having to poll for
>> pre-zeroing of pages ... it feels like an odd interface for something
>> that is supposed to be simple.
>>
>> I do understand the reasoning that "zeroing must be charged to
>> somebody", and that using a kthread is a bit suboptimal as well.
> 
> My previous explanation may have caused misunderstanding. This
> patchset merely exports an interface that allows users to initiate
> and halt page zeroing on demand; the CPU cost is borne by the user,
> and no kernel thread is introduced.

You said "I wonder if implementing hugepage pre-zeroing directly within 
the kernel would be a simpler and more direct way to accelerate VM 
creation".

And I agree. But to make that fly (no user space polling interface), I 
was wondering whether we could do it like "init_on_free" and let whoever 
frees a hugetlb folio just reinitialize it with 0.

No kernel thread, no user space thread involved.

-- 
Cheers

David

