Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B993EE642F
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 12:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983216B0088; Wed, 31 Dec 2025 07:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931056B0089; Wed, 31 Dec 2025 07:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812006B008A; Wed, 31 Dec 2025 07:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF386B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:33:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16F7EC3B6D
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:33:42 +0000 (UTC)
X-FDA: 84279707484.12.50A7705
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 68302C0003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:33:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oE4r/UCf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767184420; a=rsa-sha256;
	cv=none;
	b=Q22eI5Bid3gaArRy0gfzZkM52ImPuQPyHKLiqk4625yddLcw6DKLVWZO3BXtygQ8JPTUOt
	weTxBIJropkMVQH7yfyRZ1i01/k/WBoOdI5E0FCs0kmDKX16m0XUt0A3t+sv4My5dSMfrz
	bVtTiAlmjfqPdOi18nLb/xtcTQakIHA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oE4r/UCf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767184420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/Ef/KyaWkE9RNyW+S3M0FmuRK4Y96AU6QKNl70SvQM=;
	b=ngzIxXX4Dd2jttiF7e90qtP6tiVzI/7oMR0rwa/aaEKNlPD1l8n27ZlcFnb5ahF8XwQzoF
	hxwM4I2bW61eleVUA+51iPokqHYImFLaAza1dzkrhoyxL4Jmzu4G0Wkl2+VyoIOSqVY4WA
	JkZQGfSOeTpmqx2Wo/kPy7bM0vlofSY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 890AC60017;
	Wed, 31 Dec 2025 12:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105F8C113D0;
	Wed, 31 Dec 2025 12:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767184419;
	bh=88co770AdIIceGvPwMVRk+/DHD76pSN9yIlkzwg/7uM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oE4r/UCfpuC1PaAb9MdsdBU8sXRc2ePgeEuIj2rQ9eP5m1TU5zx587hBGLFLuo9xJ
	 V7g5LTrqyXvIRLQfqgbp2rXq3sEKWQ1HzoGh9Ey43xw0G5Pl9sACb+IRdk+GKEl32D
	 KEdMisFv9H9UmI0Bhbhmm07yLfYehoNYdLQy+tkyYHwGwF2r3lPx8/2Xp++Ws1aSmK
	 bOCTDRyrwF0Rg+NieWnXQCDeZK5Nrix7UnVkrveR+OUyU+3JVbFYMpu9OIxv3GQoDF
	 /llElF2C7gkZ0d07keo6NKLapRuK/yrG1QrFbSmZ2x87lJ+6oDPlbtH7eyIEAgcmC2
	 To5UZafOHYpqg==
Message-ID: <1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org>
Date: Wed, 31 Dec 2025 13:33:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] skip redundant TLB sync IPIs
To: Dave Hansen <dave.hansen@intel.com>, Lance Yang <lance.yang@linux.dev>,
 akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <f81b98e5-87c0-4c21-9a75-ad5f9b6af6aa@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <f81b98e5-87c0-4c21-9a75-ad5f9b6af6aa@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 68302C0003
X-Stat-Signature: 1yoed5rzokytkcztibydp9enfi6iaure
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767184420-988611
X-HE-Meta: U2FsdGVkX1/z5+y8KoJLvGZyJ+QHwClQWvOI9xDEmcrFjv3pZ+y98m+nFRwsjjpKkVhe9CNRIQVb0n4sbSKsNxkdDzNYPi6IpRPRQAFdOQBurbLVBN/k8i9L5J4Yt8ArZimvDHug0YFBx3q70X9R1dFUfrjEDPvYc7iMimKZ+mjrtQXaXW8x+hSWJFoH4RFbBnVOY1vFuJmIbz+elPUXwuO8vhYHiQ9BYVsKp47PhXQQ/yXHkS4Z3gycT76H4igBL6aXoHXUJ6J/LTyCzGkYt0rlmtlfX0x2AWxNkdZflHUxc33Aj7Cqc7zN+W8V7X/ueGGXp/+rOgu1VJ1yeLqqC6x88LLgSjxvdk8/wnmT5bkp0RW4+hLv0Hie0NRQLnm+B0piUmOS+cxUIMtR6lgACIMdMAJ4LWgWhSay0Li4mL0Pn95Y4iW/0cXSN+oVaaLHGVIjZrYijvM0wRCAPpDoM3nwm/T12r/gAK99iZWF07KOUFLe6YkoBfWBFQC32DTMK43Jg2xchSdppXueCpscosJU4OECQZNc/FXxNp8EhjBow/gJnXL9/5N9BnbleBmvP8WNHsuP0JEOS4/XWDl6JR6uhhTc1fvi3TraPF8cOSyyBy3pS5OX60G4mfIgAzLlGZ1Jhyc8jLGSq/9CeGbW2uSm8sUs+Iizlu4yyFqTIDLJgfrR0LvVCjHIXxTtrJQhe20Jjy9T4t+4OVtEGmbk9EgvWOzS48pQQI8ShKFkvnwsIsC8qh1VaU7aYotxmqGuMr/b9meS3CR/7Y/++SSjoPhOStzSxFCIUoIeNXl3qr2F/mXNlKdoYjHKdetkyil0m7cxyiWKZFMESqLcnkma7mxdNFIS2U25sycWP5+qSrxArihctiwQ6QuiWM4jpcV5F8W13beO/8vXolhHNOMbpLrlZj8pgfadu/3NWU/c52MLkbfgKCRCnb1LnBHbrWPaW0RohyvyXmlAxlfF82e
 /t3iXV/H
 64OZ/mVR3MWcDD9VDS7eQDpxm3fGhRVd37gdmF1fXEb8vtuR6yaFEfxdoyWzO3snFdypc3O30JjOe+CiMwyFAPGT8G2FoonQqSQ5OJXFETV46HJMqeWtSK5BDJjo2zOObMqKc8XYkyU9K0emBzm2dh3dzc/PiErcyUtfNXfNWaMo0Jy0YbIucq556ZRA8HDxNPVOke0hTJu9ezzU9TIVpXfieAwxJp4yisCqQbHA37eaawAZ6K/iBHIevMOMnzw38sRxCtl69DpVE+Pub5WBoTdI1Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/31/25 05:26, Dave Hansen wrote:
> On 12/29/25 06:52, Lance Yang wrote:
> ...
>> This series introduces a way for architectures to indicate their TLB flush
>> already provides full synchronization, allowing the redundant IPI to be
>> skipped. For now, the optimization is implemented for x86 first and applied
>> to all page table operations that free or unshare tables.
> 
> I really don't like all the complexity here. Even on x86, there are
> three or more ways of deriving this. Having the pv_ops check the value
> of another pv op is also a bit unsettling.

Right. What I actually meant is that we simply have a property "bool 
flush_tlb_multi_implies_ipi_broadcast" that we set only to true from the 
initialization code.

Without comparing the pv_ops.

That should reduce the complexity quite a bit IMHO.

But maybe you have an even better way on how to indicate support, in a 
very simple way.

> 
> That said, complexity can be worth it with sufficient demonstrated
> gains. But:
> 
>> When unsharing hugetlb PMD page tables or collapsing pages in khugepaged,
>> we send two IPIs: one for TLB invalidation, and another to synchronize
>> with concurrent GUP-fast walkers.
> 
> Those aren't exactly hot paths. khugepaged is fundamentally rate
> limited. I don't think unsharing hugetlb PMD page tables just is all
> that common either.

Given that the added IPIs during unsharing broke Oracle DBs rather badly 
[1], I think this is actually a case worth optimizing.

I'd assume that the impact can be measured on a many-core/many-socket 
system with an adjusted reproducer of [1]. The impact will not be as big 
as what [1] fixed (we reduced the tlb_remove_table_sync_one() 
invocations quite drastically).

After all, tlb_remove_table_sync_one() sends an IPI to *all* CPUs in the 
system, not just the ones in the MM CPU mask, which is rather bad on 
systems with a lot of CPUs. Of course, this way we can only optimize on 
systems that actually send IPIs during TLB flushes.

For other systems, it will be more tricky to avoid these broadcast IPIs.

(I have the faint recollection that the IPI broadcast through 
tlb_remove_table_sync_one() is a problem when called from 
__tlb_remove_table_one() on RT systems ...)

[1] https://lkml.kernel.org/r/20251223214037.580860-1-david@kernel.org

-- 
Cheers

David

