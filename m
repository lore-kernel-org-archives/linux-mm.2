Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E39EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B97D6B0005; Mon,  2 Mar 2026 14:29:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6874C6B0088; Mon,  2 Mar 2026 14:29:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565FC6B0089; Mon,  2 Mar 2026 14:29:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44A9E6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:29:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB8BBB8005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:29:18 +0000 (UTC)
X-FDA: 84502111596.05.BA4AA39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 420D31C000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:29:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oaZ5QEaB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772479757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cxuhQJxR8bYVXikhEK1+RTW0BExnVOuVgn5QxmSX2A=;
	b=swRB+PzT8f8B9t3PzyOLDjWkOCObDLiQkIaiUjEHzdMz8X+6oBbh9gnOkDbjWy7/dR4e0M
	p3RcMsGV9Y81vPHcrRAslK0BCBljvFjVggCVM2eGSLogSC90rbJ/uAf4xJwT2w1YKeA/aq
	KyZbHo5YuKU5pUoU7XRI7SL4KBDLuCU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oaZ5QEaB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772479757; a=rsa-sha256;
	cv=none;
	b=6qMpzUZCmnKzqvy94g3ZdhYAChINWtmBXLrX1Tumy0CT2o/ujy98YWs+SJdbDZO22oauRV
	CvcUzPZOWkhRRnuvElVQMuSAWW9N+PxJarTYX6ZBFEcI7Ks+iIbqDBNF6YwJUWgu9Fr3+q
	PKdBDtvPk/kyrQGxkz31KDGorefx22c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B611A600AD;
	Mon,  2 Mar 2026 19:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B20EC19423;
	Mon,  2 Mar 2026 19:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772479756;
	bh=NZg6IkrqSilyaJKuQdOWhODgCve4bASGsjIfaQYvfuk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oaZ5QEaBeXszAhY8as/4/nEwg6W4/NLlaQ0syRBf/yHZc8vYWv1yYhJ+yhMey/9cF
	 9JZfUd+8p9tVAfqK1HZOVcmb/IznBo8fXjLSGvOTSOYUQkZqz936EqM4JUBKyxgYvL
	 NdlNmeNkhsR0JXT98H/mAc4BVxl8PUPJSDJk5PANM68rbepTBeBBLYkA9iV6drinOh
	 HonvKIvnxxs8QROfHO20bBVQy9OkifSRdXSmnoszrsqG2KFUUCz+H1w/B/Xyl9kofn
	 aeG34+owIXETQupQjnpk3H5DTRpBiA8IQZprBdbF853UNzS1J1/RnqN6wdEGsAw5/3
	 L48GGKNK/qxwA==
Message-ID: <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org>
Date: Mon, 2 Mar 2026 20:29:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org> <aaR4y-lCl7YPEcnX@tassilo>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaR4y-lCl7YPEcnX@tassilo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 420D31C000F
X-Stat-Signature: 1eign77k8rfz8w6t14zmnfncoj118bci
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772479757-683606
X-HE-Meta: U2FsdGVkX1+nWjGFACrKe/iOrAbi6ZejjcJGwp1tldyuKSbdpHEzMCeUBY9lYDzfGyrhrLWUfXjHsRdUg2JnNFj4fVvaxRJSZuVT7U+rI5vGkrCUQ/NAefUSBLm9lA9ckFfLNffoorZedRAnQ5hLPX2NK3E182ZcZXUitNEBGfRiOFZacLdIXVMzW8+uqc8Hbrzv31FPW8kUnYqhdzGKWmJ2aGrXrIjyLlZpp69aJV+RiI7paAH2ew9cQ3MEEnJVG6ARRF0hYumIE3qhQ95QK+imSwo2TNXE9bNw72J/kIKNa4hMtXEwhO0URki5dLQvdyCCt2EmyEbHLS2mkmWNjCUcDni/FmDKWdEQaHbyov9U6PsPIEkfxPH+nFIGZAyodbMYEDZ07d+jcMgELH2Hi9e03stJKEOGQvYucQXkH/GPIRi6LcNTbR1pQeh0sssBLUcnKRYzSI1PHjnBKNPdIjxUMthENNbx4uxDiEHeeb7uy24mj984iCdaPp7fuSmIZowGzJehQX6kQCLHQ4yKNnLZX6QX5/qZVoKEgRg+Fj7UtTsnq6va5jSSAz8uzdf5V2SzD3qCftH4cSLvUNmnrdAtzbZw6G+nR21PBtDquuSvgjNeT0To4IxWMpGfwqm8KkWUyG+MAJuWkj6lgxJK5gpMohsBZxAG6AMLgw248AcgP31eeXPmrlatH2C/nJ7Ceji3LVpUcc/c/Ly2eews32XMiziaYuH3+Jy3irT7suNlASWFfGWcg919vzSVmidNe1jReXIAa1ICmIEFEZc00w8P9wyIhrRKuK7S7b7ADhbccV5JM1h0VqFwcalEAeqK6Ux1n4Xin3PI9qo0MmIqdH/4Kq08yWWksr6ZO3be84SkU8RAnpN5XtQsOaxW/62ysYhUKmjg8UV5uVktbwOHDXoHj/JbmWxmDaBEIL0iYtNefkMiVQOYvR2gAG8YdzILsCSLw5YNCjvunuITLAC
 m2cJXgQC
 g8x/sJH1gIfgLa57G9LxTJyhDt9EeT+TQ4e+jhBfI0ncuhICjWwra/D3AoSBlBnAByVf2z7KHhznDKwB6SRug/Y2WzjfMPIx7IC4XaE2W9Ome1c+h/ieMx/uYn00TxeFULGK61vH6H8mStEHm5Ha0hpyYxvCabr+7FeDPFC0yRDUMk4J9zGLOxRw2wAAr/3ZKajL8Trbu13x7OSYs5E355P6dvKFxJnOe41yfm860DmAbVMvtNLi5Ky4BCcSe455fswtUHx+q+0IpA4ekRVvbw6vZkZ1zyx5TbT/pjbQHUW53lFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> But more importantly
>>
>> d) MMUPageSize is independent of the actual page mappings, and I don't
>>    think we should change these semantics.
> 
> That makes no sense. What is it good for then? Just a random number
> that looks good?

Especially after reading 3340289ddf29ca75c3acfb3a6b72f234b2f74d5c I
ended up with he following conclusion:

"KernelPageSize" tells you in which granularity we can mmap()/munmap()
etc. Simple.

"MMUPageSize" tells us how this granularity is implemented (or emulated)
under the hood.

The case we care about is when MMUPageSize < KernelPageSize. A process
might have to know that detail even when nothing is currently/yet
faulted in.

Assume a process would perform an atomic that would cross MMUPageSize,
but not KernelPageSize. Depending on the architecture, atomics would not
work as expected in that case.

I'd expect other cases where an architecture might have to care about
the actual, smallest possible MMUPageSize it might be executed on while
running the program.

It's a shame we had to add MMUPageSize, but maybe it might resurface if
we ever support emulating 64K/16K user pagesizes on 4K MMUs.

> 
>>
>>
>> Let's see why MMUPageSize was added in the first place:
>>
>> commit 3340289ddf29ca75c3acfb3a6b72f234b2f74d5c
>> Author: Mel Gorman <mel@csn.ul.ie>
>> Date:   Tue Jan 6 14:38:54 2009 -0800
>>
>>     mm: report the MMU pagesize in /proc/pid/smaps
>>     
>>     The KernelPageSize entry in /proc/pid/smaps is the pagesize used by the
>>     kernel to back a VMA.  This matches the size used by the MMU in the
>>     majority of cases.  However, one counter-example occurs on PPC64 kernels
>>     whereby a kernel using 64K as a base pagesize may still use 4K pages for
>>     the MMU on older processor.  To distinguish, this patch reports
>>     MMUPageSize as the pagesize used by the MMU in /proc/pid/smaps.
>>
>>
>> So instead of 64K (PAGE_SIZE), they reported 4K. Always. Even if nothing is mapped.
> 
> It doesn't seem like a good design. I don't know what that is good for.
> 
> What is reasonable to report something at least approximating what is
> really mapped.

I disagree. It is not of a lot of use to know "In this 1 TiB region,
there is something mapped with 2 MiB", and then exposing it under the
MMUPageSize umbrella with different (mapped) semantics.

AnonHugePages/ShmemPmdMapped/FilePmdMapped are better in that regard,
although historically suboptimal.

Ideally we'd have better statistics out of the box (similar to what
thpmaps does), but as we recently discussed in the context of "AnonZero"
we should much rather look into a better interface to expose something
like that (e.g., a new syscall where on can enable selected statistics),
including new tooling that can obtain exactly the statistics we want.

> 
>>
>> We once discussed exporting more stats here (similar to AnonHugePages/ShmemPmdMapped, ...)
>> but we were concerned about creating a mess with mTHP stats.
>>
>> For this reason, Ryan developed a tool (tools/mm/thpmaps) to introspect the
>> actual mappings.
> 
> 
> Some magic other tool doesn't help with the current output confusing
> people.
Adding more confusion with this MMUPageSize extension is not an option.
We should likely clarify what MMUPageSize really means.

So my NAK stands.

CCing Lorenzo:
https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/


-- 
Cheers,

David

