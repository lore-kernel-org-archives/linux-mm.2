Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60066CDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6BD56B00C1; Thu, 25 Jun 2026 07:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C906B00C5; Thu, 25 Jun 2026 07:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BA46B00C7; Thu, 25 Jun 2026 07:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88E436B00C1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:43:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0191A406A8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:43:18 +0000 (UTC)
X-FDA: 84918249318.04.F79B07E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2CEBA18000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:43:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kf+52144;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387796;
	b=z511hbpJEBjKMsIiqercJ5WG5VV5j2ECEsdhN2vn9B5emZB+oZoq7t1kfGmJ0WXxrdSuRD
	QTDGvVBkr131GvWjvL1Wrn6Sw+WlsUqw3vRyqSolqFuSZOJwB6ytnKcInCIpOiYyfK5amE
	q0kzmw2D70rOwAAwc6BaIniDjXyycu8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCW0ny848an4JhbGV5M+vBhMddaxYL0zCBxrntPtqhM=;
	b=sYLVvy6aVcnARyDJfdTmArsSucjpaAt+zxpgoyS+2wnR6/OXmDPst5J2gNBY/bKmeVvMEQ
	Sr6IFw5ehZWlOtF6wcRP5RbB1iJejonBWpSZ2vNzdYjpLeP7V/ew7E6sprmA+tXfDOJ4lT
	4mOlK2ambbklCv2uN9bP0ubXNab7N2w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kf+52144;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53DD440712;
	Thu, 25 Jun 2026 11:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BBD1F000E9;
	Thu, 25 Jun 2026 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782387795;
	bh=mCW0ny848an4JhbGV5M+vBhMddaxYL0zCBxrntPtqhM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Kf+52144YXxmSkV3VJTo5FiPwLKlB61+gSnUu2Z7QE6c/l8/fQCzrmDuKVV9i5Fgq
	 s5OGA87ZUjhjDC7bEcH5gE/I3eeNatuhLtCGgFWKXKUceu/f/yi8ETT0K7NsE4SXMW
	 J2ArM6yTtHwrx5MrneOrmNqebpb165FfAZz4gjQY8IXLVW0/X8ArNbn2hQGAgixTbX
	 lMFyGbND3NpQZQBZ3MFSPEXxL51e6UEEoJX/oz6fmm4JxN0gI0Evec3ZCp9xM5s+uG
	 SPF6O9RheHzIwSH9VG/sWNzwK32w8FUSNTpJb4TivTSb0yt/ixr+drLbVd6xJ40NT0
	 CJsG2xyWTwMDw==
Message-ID: <9a8e189a-39b4-4571-bdd5-400cf6443204@kernel.org>
Date: Thu, 25 Jun 2026 13:43:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for
 pre-exit before dumping
To: Pedro Falcato <pfalcato@suse.de>
Cc: Christian Brauner <brauner@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, mjguzik@gmail.com, ebiederm@xmission.com,
 viro@zeniv.linux.org.uk, jack@suse.cz, jlayton@kernel.org,
 chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de,
 keescook@chromium.org, mcgrof@kernel.org, j.granados@samsung.com,
 allen.lkml@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 Xin Zhao <jackzxcui1989@163.com>, linux-mm@kvack.org
References: <20260624145552.70143-1-jackzxcui1989@163.com>
 <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
 <9105c433-44a7-4e8f-bacb-def93d11a7f2@kernel.org>
 <aj0Mr3e9yt0kU-Qj@pedro-suse>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <aj0Mr3e9yt0kU-Qj@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kufsfazbc535irakwgon9uktpf37fz7s
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CEBA18000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782387796-772826
X-HE-Meta: U2FsdGVkX18NCpbekJ7Q4dgSrWNGH8/KjcaSLldqPioWe3emHkcJ7EIUrlc82sQvUupPQAOMGGZDr8AL2Yq1wtbwBYpl3eNMAgDyjcpcKcfL+0i2K8bRXVv4ofKZuD+reuTskh2CR3+8wYBYxubJVnQG2CrioMoeVZecZ83x0R/VJ8LaTgvsvTRqIMIgxs2lemENHvxwCghclHlzJcwC008R/s3lZ3Zl5Qcpkci6kT81p3ZtIJEcfjWvrY81v03eBjfXEUngIOnK3msE0FiOVgl9HBA0Le4PpkCa03v3Q7K3KdiOlZsskOOUYizVFVmf5eU+Me53Cy7k+nPWszZwNiqIqXVlUxWpcEZOZoE77CsetFd3cDNx94pb+XpxyD6rbutwXRWptmaf7Obp3n1Q/1kHnnZ0TxEEfBHE+MUJaxXh9BN2q/k58ib+FCZQdYUeUIKJjKIyL1j3FsXXwQgHLMuQ9dFiAfscnpaeaU4h7uuch/en0BnXo+s0unYnpgdWSb5ATdDy9zWJ/LTsltJb8fy8i+EIF5sb2UJCfhy4KEX7eQZouTHGsQbFICAmcxgUZEa6cOpawclPJYHM3WQDzuqfZY9Kbp0lxmz9oAZH3KHoSyPvyeCMjTHF5A7u/nc6Rm5gFc9HhylvSPKBUWDfxPu0BXL0/b4I+DUVSrwHzK3L8miQexUmNvhATxxlkB/HMKWeFKNEIXxIq33BifvKW9yVmS3M7svYW83R5Q/xYPkFfU1JjmxS/g9PK3PqOHcmiotkhyLbI/IwbBY2LhFKSew1UOCOzNuU29muXjMSv0oVbdgKFeSmA0oVp3j8DVzEqBYNCa38YWfu4mVuIuovuK4yEXsFjEb58gSK6pxHxc8aWXGDKsrc9+HsP0Zc7P6d/U34+C8//zicX2CD30BxKEvopjq82RhA7yb1zkHtOuDIy8gyYUEEE2e7nvH3BcCPdVeqgP1ywERLaLkhAzj
 8G1yQcYg
 MkJv4UuvimiyqYr3MsF0/r3PxpWeENaSMw3L9P11qGUBS4soGKcSms9aunwcwoKZ5gtspjvhNwY/7+feDg4Gf7gjlzHKydwJKvUWXxOrx5j0737SMKMGPA4Iugtli4O3JUKjXfLkU8wh3oPFoBp+kdmd0+qm0Gn9p3ZYqRtvqOVWzaAtOmFMycgTkZha0bvT17RD4of+gHW9GmoWeRaUOMPB8sUl3ngx4f0KWOaM6QKeYAO0+XXoB2qMldm/mSMsMbpiUoVrmNREJYrKWmOHRwCsktu+EClV5yOjICsCu9wnNZUv6YpUWCCl7Z6tTxIZU+OQ9VoapkzrNrAKcDkC6QHEA86So1ZjNzLEihOy3F5nJY5itySWy2ez//cgCIm/ufh6P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 13:18, Pedro Falcato wrote:
> On Thu, Jun 25, 2026 at 12:57:02PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> This makes no sense. I think you really need to sit down and think about
>>> a design for this that doesn't introduce state machinery for boot, mm,
>>> and the VFS in one shot to solve a fringe problem...
>>
>> Staring at exit_mmap_mapped_shared(), ... this looks rather hacky ("let's fake
>> munmap and set some magical flags").
>>
>> We're essentially saying "we don't want (pretty much) anything that's MAP_SHARED
>> in the coredump". And for some reason someone should configure that, that's a
>> rather weird toggle tbh.
>>
>> And the granularity ("file-backed shared memory") is completely odd.
>>
>>
>> Aren't there other ways we could optimize this internally?
>>
>> Like, if we know that a process is dead and cannot run anymore, downgrade writes
>> to reads (and make sure we block GUP write attempts accordingly), or would that
>> also not be sufficient?
>>
>>
>> Another thought:
>>
>> fs/coredump.c calls get_dump_page().
>>
>> get_dump_page() will not fault in any memory. So if a page is not in the page
>> tables at the time of the dump, it will not get included in the coredump. Which
>> means, that whether most non-anonymous memory will be included in a coredump is
>> already like playing the lottery.
>>
>> This is true for MAP_SHARED file mappings and MAP_PRIVATE file mappings without
>> private modifications.
>>
>> Which makes me wonder: How much is tooling relying on file-backed pages to end
>> up in a coredump?
> 
> FWIW this mechanism already exists, see /proc/self/coredump_filter. The
> default is bits 0, 1, 4 and 5 (see core(5)), which maps back to no file pages
> being dumped to a core dump, apart from ELF headers (these help the debugger
> trace back the mapped binary to the debug info using the buildid).
> 
> So the answer to this question is "approximately none" :)
> 

Ah, thanks! vma_dump_size() honors this, and I am sure through some magical
routing the information stored in m->dump_size will end up not dumping these pages.

Staring at elf_core_dump(), this "unmap some stuff" part is really, really
nasty, as it effectively removes the VMAs->segments from the dump. (unless I am
missing something important)

-- 
Cheers,

David

