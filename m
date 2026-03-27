Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B94F10BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EEF46B0096; Fri, 27 Mar 2026 03:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6BB6B009B; Fri, 27 Mar 2026 03:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002DD6B00B3; Fri, 27 Mar 2026 03:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5AB86B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:54:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D7F7161003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:54:21 +0000 (UTC)
X-FDA: 84591080322.19.799E413
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 83DC6A000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:54:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZVPrWOIS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774598059; a=rsa-sha256;
	cv=none;
	b=gduMMU/4KmGcWqENnyfNBISgLQ4gu8pXbb2OE8uqyI8pJFAXw8KsLudqh95fqJZ5T9SjiW
	h4br3nGlk0YcwWrTeXKnmOX0SAGFSJ0Lj4Af+quB/1S9prinjpJYYRJoFXAaoNybG4qQ60
	lPDYSJb0ZvzzxDpqj7zGIpLeBezbMlk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZVPrWOIS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774598059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXfhtUgdgpOcNjH4H9gVjkNAFIHUEbFzke9WU8mHkdE=;
	b=cFw3DjFzvt6b+ZovWpEQD7kTnB2q60Tb9UTptAi+14cOSh6pmcOQE1VqyceylcQQ8UvKsJ
	CYALUFlubHZHR+ytd4u4F80cLVF2ebSjedjCIGAyWAYRFRO3glTej4C4AKhlNjQrd2V2Iu
	ZQLwAQO0X+ufafMTPXr5SZpCV2fLLnk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70EE74417B;
	Fri, 27 Mar 2026 07:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DA0C19423;
	Fri, 27 Mar 2026 07:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774598058;
	bh=fVfnbrCFPbx56fN5k/LPGrEtqO3hIsGVAx/y6wA1wg4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZVPrWOISjGykaGNzIuPtynp7+S7nBx1sHQrIkRq0Ii27psJLu9c27zdY01msai7yk
	 CasYCrJaSnnQZhJLWTdEdFoBZ+kqCk+5JoisOZcZ9nr+duf+gdbONshdbiiQ/JCZU4
	 iWHJcsIJdAfJY30N67YOibmQus+oUA1jknUZLH4QJdfFhxV/N/axs8bRQtFIgY0wEv
	 kenlEZo/d2owb7l+oNs+vmGM3lzJ56F3gh6o3m/s1jH3HVBEFwxvJs7mXCqittnYNX
	 6ks1u+duSS5PGp9aBywxJONjmeVwtvV33w53j0JWZJ55a361bo0Y/ZL6l4jYySTUqh
	 vtGSTFjdYnZsg==
Message-ID: <0f441d8f-d84c-470a-a4cb-0249b15220a2@kernel.org>
Date: Fri, 27 Mar 2026 08:54:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
To: Ryan Roberts <ryan.roberts@arm.com>, Uladzislau Rezki <urezki@gmail.com>,
 Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <afe9ba0a-1924-42a8-a9c5-34eec709f883@arm.com>
 <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org> <acV36oPNFMgL4puz@milan>
 <ea1cb2a1-b674-4d69-bbf6-00051a0e11df@kernel.org>
 <eafefe7a-a33b-4102-93cf-fecc33ddf49e@arm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <eafefe7a-a33b-4102-93cf-fecc33ddf49e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 83DC6A000E
X-Stat-Signature: g6iq1gu9paop9hhykhgdtwmj6yoxtqhb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774598059-378092
X-HE-Meta: U2FsdGVkX1/wnXl0mtM+anpukzSNgfyQ4bFvlEq1jd/09mO/4HLqMjEpsJlF6ngANfRbQ6dzHNTjr3bjtehLRA1gIvpSOfqM7t4S5e0kunbCPOqXw/roBSwkm2NX0eSKhHO/cZvTug2Bpy90ebkSjzely1rdokidPQmxhnwN2sAWYDxey6EE6M17kZozqfaXzma+CFT5n517DM6krog12IUYLocIOcYnM3VG7kCAIz0WCd5w9d4VpVBjv2M8zjyukPd59fgdwYAWPxEtf6W1qUgKqzlTHGjUHkdv+5LqyRa1QZfHNGHFbFX+JKW0cFUO8gulYHKfux4dyeP1mnn7wOmEb2w03ImDS85YdzfuTuQFmE3zx7OAXyxeuPERYBEr+UzwnycivOhGnjROfS6qbOePLqgPQkRf2BPfsLjbGgRBuGzp1XDA3x0lRnn6Zsc6V9vcxBRcwDbgPZG5PDHc4KEhfA03W3vRNktLlA9XTLuRKvLFfKiGwImsja6PWclAyyEVnPWrPFHNLL/sc9kUx3dECdcKPiGPyNbwNmP0WBK8bzDcWU6OplJd2z/yXTE49In36hrgxRodwb0CzK2yIhuLSQY0tReQEPP5gqPj4FDq6HZREHx8/NLnBotQsxlTmwL9Va75yM1dcMfeoJhoxQpOmco2xYHRS2eAXWtIM9V/21IGJIgsrB60nwPlKhEMvVnVltB9j7e9sAroCIpnG8oBBg16WllR+Kx8h6UC1VKow6b2zfYiQt/Hfz+qcIBXSiFbclF5rITR80/Iv5P7x/icL6B0SgiLOOOmKfTBsbVOUpFd9r3OLCebhAWf2acwj8tUnub3Ma4buHDNpTE5NdoCDcUQ+NxsFMwMzOL/kWcraxbQmgbfATKf3v6aBP/uF5uFoJ6k3qHiCUx3diSC51UA+vHW4NQUDae7yV5DIUgI2E36xJXZZheX9tiTeB3UGqdtjsyheiGjFlbxFIt
 lLhAXlPs
 9SwRje8v3k1Y6sinCZax7knbvtqcdZG5tuDoq8NRy4yh5xoqNdDVXnWdD+tVn5plhvrxWtIiPwknRxoG8p/g7BPsUhyWteVV7vpbJDhqdey+V+aKfNSkT/BdwHlaFqkOyFRKM0O3CIsBsFNtXEBsVogxOb03+d+ART4otpdhQZ2RWiCQzOEAnxJRSyQiEFGYfaS1waDU6dU9hSIfOUzsbg2B+qLZephraGRqdS2XHRY7cW2mtho/HQY4flrGnrPgdp1lj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 19:50, Ryan Roberts wrote:
> On 26/03/2026 18:24, Vlastimil Babka (SUSE) wrote:
>> On 3/26/26 19:16, Uladzislau Rezki wrote:
>>> On Thu, Mar 26, 2026 at 03:42:02PM +0100, Vlastimil Babka (SUSE) wrote:
>>>> On 3/26/26 13:43, Aishwarya Rambhadran wrote:
>>>>> Hi Vlastimil, Harry,
>>>>
>>>
>>> static bool kfree_rcu_sheaf(void *obj)
>>> {
>>> 	struct kmem_cache *s;
>>> 	struct slab *slab;
>>>
>>> 	if (is_vmalloc_addr(obj))
>>> 		return false;
>>>
>>> 	slab = virt_to_slab(obj);
>>> 	if (unlikely(!slab))
>>> 		return false;
>>>
>>> 	s = slab->slab_cache;
>>> 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
>>> 		return __kfree_rcu_sheaf(s, obj);
>>>
>>> 	return false;
>>> }
>>>
>>> it does not go via sheaf since it is a vmalloc address.
> 
> Isn't vmalloc doing slab allocations for vmap_area, vm_struct, etc, which will
> occasionally go via sheaves though? I had assumed that was the reason of the
> observed regression.

You're right. And in the table Harry fixed up (thanks!) I can see the
regressions are also in tests that don't do kvfree_rcu() but a plain vfree()
so that rules out the overhead of kfree_rcu_sheaf() returning false.

It might be due to sheaf_capacity not matching the capacity of cpu (partial)
slabs. We are working to improve that.

>> 
>> Right so there should be just the overhead of the extra is_vmalloc_addr()
>> test. Possibly also the call of kfree_rcu_sheaf() if it's not inlined.
>> I'd say it's something we can just accept? It seems this is a unit test
>> being used as a microbenchmark, so it can be very sensitive even to such
>> details, but it should be negligible in practice.
> 
> The perf/syscall cases might be a bit more concerning though? (those tests are
> from "perf bench syscall fork|execve"). Yes they are microbenchmarks, but a 7%
> increased cost for fork seems like something we'd want to avoid if we can.

Sure, I tried to explain those in my first reply. Harry then linked to how
that explanation can be verified. Hopefully it's really the same reason.

Thanks!
Vlastimil

> Thanks,
> Ryan
> 
> 
>> 
>>>
>>> --
>>> Uladzislau Rezki
>> 
> 


