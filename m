Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD1610BA43D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAC36B0095; Fri, 27 Mar 2026 04:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4829B6B0096; Fri, 27 Mar 2026 04:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFD06B009B; Fri, 27 Mar 2026 04:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7206B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:58:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2BFD16103C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:58:43 +0000 (UTC)
X-FDA: 84591242526.13.4C57473
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id B18E640003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:58:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XJrQMXyI;
	spf=pass (imf17.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774601922; a=rsa-sha256;
	cv=none;
	b=p71+kIFyyXjYx7V1SqtI1TGYQg8Kg3iAk2a3jtKt7gMFO3zMf2r8Q2h0pY3Kk2FyQ7nBth
	jK2cRuHXyGtna5SULbBNUj5+kgmoo60I7Y3RgXJIs3jKlniwK6d6gxfC41kORCy7k74tTL
	yq75S5FqgIJT3qwU5Gg1FWWT14hZWw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774601922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXpoTsaoWiZ9eUOxQL2FKB8XOGBQ2twBZHvrbTfWNYo=;
	b=TlvRAcUOvwlTcvshZ9CIP8OLrq3YEKdq63DnDhJ/udUbinggossMA/vP1ny6MMoyL7XvaS
	N+Rnkan7lhwCmUAeH98tTKSdhWPQYIX/qsXZNycjl75j+5RFDrWePBn72MFE5hElBKVCBn
	l4EiLEt7VvtKfkV0gyuy8Lo/zQEFEoQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XJrQMXyI;
	spf=pass (imf17.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 762A235A1;
	Fri, 27 Mar 2026 01:58:34 -0700 (PDT)
Received: from [10.57.84.204] (unknown [10.57.84.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72F013F641;
	Fri, 27 Mar 2026 01:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774601920; bh=w9IZpSJOAS4xupVv5ms1cnqFWHsSUbKDN08TbS6wjpw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XJrQMXyI71BNRHhsdQda+oNE2PiV7eEwFLFSK7RpzZZHUphr417U6uqxwzvrYcozq
	 iPX6TB3ViUlE4Fl9RMN1MyjYzjpltbYMotvNelSjcjPnxHFuylaBSSHEAY45HUJdIv
	 rM5LHzPPUiyWj/kFVVhFCnUCEKBKREsor2i8z+qU=
Message-ID: <f100305b-6c56-4499-98a4-6a22f8c49443@arm.com>
Date: Fri, 27 Mar 2026 08:58:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-GB
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
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
 <0f441d8f-d84c-470a-a4cb-0249b15220a2@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <0f441d8f-d84c-470a-a4cb-0249b15220a2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B18E640003
X-Stat-Signature: 5cgw7xhofheubhnjqmmx15t7a8bbtmrk
X-HE-Tag: 1774601921-780317
X-HE-Meta: U2FsdGVkX1/0K6pKAtAPexbi6a1v0/YgBoIOJ27gyN8vcJy9OSpn142Dh1QNAJBNsdPjCf7O3Nt5jUz66J2Nq0/agOq5uvTka3Er7QP2fOOk+/esFNHalv+WjfnQ8tj1iaFp1+kMyRPH6Hu/VVJUEFbTTai8pKM0/8dZdLhNdpUHfks9vQ9z5n+oRpRhYPBmjdreaY6bUKqhghZVTNBnySB1yYkQFz6c6DuO2xaa0fEobdBsZInEjBfVYwe7NCvi/22OPyLH29L2nmpjVUhNU2dC/sajnKshlKT3F+mESINNdRMqvvfI5SxFrCdKqVsPYHzon3atuCl/n5ow9vrOXDH40FCuwP7lE6GSQMMlhQq5+gt8QKxKEREm+3kXWNEoXYwfQF2HWGP78HbvVX3DFrlTX4KnrHGlWIQM/1rvuMO0QtsNzE//evBMq+nKRftFdoK21hQc6UprYjHQY2Jonoyy8vyrCZGq41nUENnCcRf+1kxsfB+Y7vDUFd2JMc7BBuwfj2m1r4AwbBct64BmgQ58RVh0DbVuBtBNq5yMCGfo/Kf0lUMlwDQIGeoLjQi+V8B59BP403DzN/oEkefSjJWSi3qnCoEuytrOivl7ZdbmKDXuRbij38ILVpctrdry7op4SEde7Sbc5Gv90k7dx4jpvQFuebq5BAHqoN39FmNsmTEpxNrBKPRwzG+gMerct3G/51VV0LW/E7ooaQMzAD3/hVJrhYetWrPm0inyiLLoXsJLEDPK+PXXSilV1euRx62syPI1KS1QLaEvXaXcMUil9XzwnCcKEgCH2eJZmy+IxkVx2BZs3VExmvgQT37CZhBHumZM1RDKM891dFYY5H+fi6iMC9OepAwgJ60pCY0l56vykfk0SeRPgGOoa3qD8weLL1Fo1qh2Lf2HcBOodtnqb8ujlwko
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/03/2026 07:54, Vlastimil Babka (SUSE) wrote:
> On 3/26/26 19:50, Ryan Roberts wrote:
>> On 26/03/2026 18:24, Vlastimil Babka (SUSE) wrote:
>>> On 3/26/26 19:16, Uladzislau Rezki wrote:
>>>> On Thu, Mar 26, 2026 at 03:42:02PM +0100, Vlastimil Babka (SUSE) wrote:
>>>>> On 3/26/26 13:43, Aishwarya Rambhadran wrote:
>>>>>> Hi Vlastimil, Harry,
>>>>>
>>>>
>>>> static bool kfree_rcu_sheaf(void *obj)
>>>> {
>>>> 	struct kmem_cache *s;
>>>> 	struct slab *slab;
>>>>
>>>> 	if (is_vmalloc_addr(obj))
>>>> 		return false;
>>>>
>>>> 	slab = virt_to_slab(obj);
>>>> 	if (unlikely(!slab))
>>>> 		return false;
>>>>
>>>> 	s = slab->slab_cache;
>>>> 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
>>>> 		return __kfree_rcu_sheaf(s, obj);
>>>>
>>>> 	return false;
>>>> }
>>>>
>>>> it does not go via sheaf since it is a vmalloc address.
>>
>> Isn't vmalloc doing slab allocations for vmap_area, vm_struct, etc, which will
>> occasionally go via sheaves though? I had assumed that was the reason of the
>> observed regression.
> 
> You're right. And in the table Harry fixed up (thanks!) I can see the
> regressions are also in tests that don't do kvfree_rcu() but a plain vfree()
> so that rules out the overhead of kfree_rcu_sheaf() returning false.
> 
> It might be due to sheaf_capacity not matching the capacity of cpu (partial)
> slabs. We are working to improve that.

ACK

> 
>>>
>>> Right so there should be just the overhead of the extra is_vmalloc_addr()
>>> test. Possibly also the call of kfree_rcu_sheaf() if it's not inlined.
>>> I'd say it's something we can just accept? It seems this is a unit test
>>> being used as a microbenchmark, so it can be very sensitive even to such
>>> details, but it should be negligible in practice.
>>
>> The perf/syscall cases might be a bit more concerning though? (those tests are
>> from "perf bench syscall fork|execve"). Yes they are microbenchmarks, but a 7%
>> increased cost for fork seems like something we'd want to avoid if we can.
> 
> Sure, I tried to explain those in my first reply. Harry then linked to how
> that explanation can be verified. Hopefully it's really the same reason.

Ahh sorry I missed your first email. We only added that benchmark from 6.19 so
don't have results for earlier kernels, but I'll ask Aishu to run it for 6.17
and 6.18 to see if the results correlate with your expectation.

But from a high level perspective, a 7% regression on fork is not ideal even if
there was a 7% improvement in 6.18.

Thanks,
Ryan

> 
> Thanks!
> Vlastimil
> 
>> Thanks,
>> Ryan
>>
>>
>>>
>>>>
>>>> --
>>>> Uladzislau Rezki
>>>
>>
> 


