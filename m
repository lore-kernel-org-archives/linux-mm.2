Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58263606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G6Ihx2Fp
Received: by kanga.kvack.org (Postfix)
	id 7F5B76B06E8; Thu, 19 Nov 2026 17:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCF06B06FD; Thu, 19 Nov 2026 17:19:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBED6B06FE; Thu, 19 Nov 2026 17:19:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC046B06E8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:19:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB371C0C33
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:19:50 +0000 (UTC)
X-FDA: 85453286940.30.E0A7225
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E48D5180007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:19:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6Ihx2Fp;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795126789;
	b=XLwmz1Jel3H22qeTkJGGlDsN5FNnjEN8kM2gftXPXQ/LIzVei5J2hOcEBaDaszFygRW+Ey
	+GMgtht0kBCNyIwYvChVv6t8Ax6iGRbh+BFa6V5PrkfJmjWbqptwmVPOeQOeglPaXNJbhX
	NH7Fz0RSYEK2RrKu3TDuNSTD3wOhOeU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795126789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiPQ4wl6tF2e90uhD0HmkSpXHz6ccxWLOtHHkF4KxNg=;
	b=3LrzYkpvkcKrJJmdXcvLNkTnUvRWyf25BVZHfIW65vQfAT89GmZj2l4qe/SuHTP3UU2Hqb
	0nbbK71J+AISeFgNrI8OIVNcZw2YqKki6UfDbVby/735oCkIZRNp3HV6gxd6RiZlHFs8NJ
	Y8wob0J4XEX7G71HXGk+F4CC5YZTAi0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6Ihx2Fp;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5717602CA;
	Thu, 19 Nov 2026 22:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74DA1F000C6;
	Thu, 19 Nov 2026 22:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795126787;
	bh=AiPQ4wl6tF2e90uhD0HmkSpXHz6ccxWLOtHHkF4KxNg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G6Ihx2Fpp/Dy57CCYAyiaqVtXntjB8VAYpH4cw8ydBW5EOTje8iTEujXpMSO/JcqO
	 oEg06AcBjBNeRcUg1pBPJhTGDsJsWaR0MnDSzOoJtORkODc15tx1kfIg9Fd1ocaE1v
	 A7e/EIS3osWR/oylCwh8Lwf1iwaQDv7lNmhN8XD6ZFW4bqsdi+YbX4Gagm7UUpRvsT
	 wWN16VGpxmQw2+0jLej738gnehufQqV/tYQ7JEz5nTmvZ5RBn2oE9A7bYQQjOYtuHs
	 RcLa92YrubfjxIB6banH0SIBL1dj8Ms/SiFK8Asi+PsLtyiI51mmztQnQwwdpqpKPs
	 L37pGn5IuqoKQ==
Message-ID: <421ee488-e2a1-4deb-9ffb-7fc712c811de@kernel.org>
Date: Thu, 19 Nov 2026 23:19:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "Hansen, Dave" <dave.hansen@intel.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "ljs@kernel.org" <ljs@kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "kernel-team@meta.com" <kernel-team@meta.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "rppt@kernel.org" <rppt@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
 "kas@kernel.org" <kas@kernel.org>, "leon@kernel.org" <leon@kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "gourry@gourry.net" <gourry@gourry.net>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
 <179460249376.482102.14669935557901467762.b4-reply@b4>
 <20261114002027.GE3706007@nvidia.com>
 <20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
 <20261115000005.GG3706007@nvidia.com>
 <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
 <55034934-8aab-4e8a-a74a-b30c977670ed@intel.com>
 <0c6fcb3daeab0ab3df0593cf389124e38e1d7f3f.camel@intel.com>
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
In-Reply-To: <0c6fcb3daeab0ab3df0593cf389124e38e1d7f3f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E48D5180007
X-Stat-Signature: xrupe1rn8ms7wft3gxhxys4wdcy1joub
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-HE-Tag: 1795126788-563446
X-HE-Meta: U2FsdGVkX1+8HZ28WBJ16mHlkwRrvxJoW544NeRDk9309WLWYoHoUFEmYKyuqdDqd7b+M5XONGyIUUujOdzcD9uACA9VZfBlR0TGXTzsTy0xkSIwsJTVAKuXqrrHGVO5nAAaliU6IvBcfXIoj4kHSSo+45FhIhEMdNS9f+Mjmvf1OpOWsUsj+rLe+8kS9kb0MmUP+JgrX6r0qhqYZx5K/qH5R8D5v2QX/mJc+iT2XUyVuiLF0iFUUgEstDXIPw/YH2xKScycpYogwoWsnH0kmspkyBKoXQnx76U1izohjSbqq2auRmtggSoVwZ7DRbm7zcu+BEBgGwOf6v1BNgXP9QSkcMLKrrzXnGIR6fJ/he+tone4IJLv9JysbX05XVOFGTIrk+j8Rc5ntFjY5uRg27aKRrzGXtAsP6W28TcOuyjfgM8xZ9JTzoyRynY0gV1t9sD/TylzrryWomvz0tY4J/MRnIH1liQvKyGdHeuulIm0OL3ogxgW9svT8b2CuRiEbcqbBtoiB+Hca1dKpS5vcOZ6b4TNFGioW6QWhoLamVcljP+hdyHUwk5uIYA81SddZr6FoXYjLUbSzmph+oTU+1nNbdIj5dwV5wEyT14TzKcg+zEFFsgdeY63sIJxs8H7v2fLqS0lRSoMcou53pvkZN8J1wisGIj1XodvhgOJzjcXISlr0BFloBVu5yHmQF3/91kyfMy2N/niii+gRw4vST4ObfgMv0JCxC00JDCfI5wQpLJxLZPpcVuZGd8pGbOft55qRVaPsKL7kkblyaWZsg6ODzXOCorDZToNcgeAws1i9O5FuNXNErySQIPqAKAnDuKcB8FiV+zGZkd5K/z7qIBLyfFqcESnZsHc2jGmiBFc+jox4UXQ8Z2xDPkuY+j4jDEdZxMfFimBBOqpDwqIa9pp9NuZIOpuDJeazwhJSEcy5qGV8tXrCU3cxXQOeErbSVz0J+YyiRfN8IiKkKR
 TBYapB0y
 jq+ukjDoNpV3QolmYhSvz5A4URNJN7zlLKt0eLJU0sv0Vgi7e3y/Ft5ZxcK7EhYL6eyjkT90nqhBTGdJmpyY23h01vnypHjn5d7S53dDSjIFIXbHtvaqiulV1KLBgT6vW7pw3rRpSENHGyUBuweGiHFWDG0SMOBkxcwPnLnKMGvhxdLNoM2QXfENmnjMEgubvhYp5xcc6YL0s781b4voeNSP5fj12UCRv/Kpcpr8mB7IEes8oaxEFz9uX0VlcxtKBKf8fnVxRr5VeNSA1EelM5ACYhdQZglyyqWKJJIfPmF1o8S7LDHepHOKeN/UFQr1IhNDYl6dAp5pCogx/7KVzE6IIEgQaKor1n7rR3M1AJfsAZ50gU1hmF3x3J7dR9t3HERDQU1nMgGY8Ho3LNF2E7xYe4srrNwhRw1bruFfYDi7WXhrwsgiw9+itN1dETiUmerNKO95iA5QZOfgcvB7buGi+ZGrhhD6b+wZh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 21:40, Edgecombe, Rick P wrote:
> On Thu, 2026-11-19 at 12:05 -0800, Dave Hansen wrote:
>> On 11/14/26 17:01, Andrew Morton wrote:
>>> On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
>>> rejects ordinary stores, but pte_write() reports it writable because
>>> shadow-stack instructions can write it.  HMM consequently sets
>>> HMM_PFN_WRITE.  Nouveau uses that flag for GPU write permission, and
>>> RDMA on-demand paging can use it to grant device write permission to a
>>> registered memory region.  A device, or an RDMA peer with write access
>>> to that region, can then overwrite the process's shadow stack,
>>> potentially corrupting return addresses or bypassing that protection.
>>>
>>> Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.
>>> A requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.
>>
>> This is a fun one.
>>
>> I almost wonder if we want to go one step further and disallow GUPs with
>> FOLL_WRITE on these PTEs. There should be precious few reasons for
>> devices to be writing to shadow stack pages.
>>
>> Isn't this a bigger issue than HMM? Should the fix be in HMM?
> 
> We do reject GUPs to shadow stack PTEs with FOLL_WRITE, unless FOLL_FORCE is
> passed. The tricky thing as mentioned my others in this thread is that shadow
> stack memory *is* writable by userspace. But also the kernel should not treat it
> as such
> 
> A false negative for pte_write() is dangerous when the kernel needs to decide
> when to revoke access. (i.e. fork) I think a mistake there is somewhat worse
> then missing an exotic way to cajole the kernel into writing to a user's shadow
> stack like this. So I think pte_write() being true for shadow stacks is the
> correct implementation.
> 
> But, maybe the problem is that pte_write() is doing the job of two separate
> concepts. What if there was a pte_userspace_could_write() and a
> pte_kernel_should_not_write()? Names would need some work...

Gah, nak,

pte_write() just says "something might be able to write to it".

If that's actually true depends on other factors. Like the access+dirty on HW
that manages that in software.

I repeat: *no code* in Linux besides core-mm should ever interpret "pte_write()"
as "cool, I can write to it". The exception is GUP and unfortunately HMM.

-- 
Cheers,

David

