Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7997D10ED65C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 11:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D336B0092; Fri, 27 Mar 2026 07:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E126B0095; Fri, 27 Mar 2026 07:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643706B0096; Fri, 27 Mar 2026 07:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 550D06B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:21:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA35DBE658
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:21:32 +0000 (UTC)
X-FDA: 84591602424.29.9CE1784
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E9E1E40010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:21:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IS0dUb2l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774610490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgJxLx+Wc7WUvIujWetvfOTZIsmR+JzqVdzurESLhFA=;
	b=0hWlCELiCd/auMQmMN2OXPBuE7aFKajzJJVji/wDve0ImZkZkrbapJjq/g0rsxl2qPTDJR
	DYLnc8YEbAYo7+t1/PMW8cjTO7FKw4Hfka8kr15tWIumEWwTYOccyT9Pq622sEQqdBXdmP
	J1L1nKFm39WIgsmzl/dTMxIRxp3Ikho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774610490; a=rsa-sha256;
	cv=none;
	b=1yF0IJsxiJRasTB/e2dBQoNILozMO87vQ9hl+CjtlikS2ryrPumHP/5FNiO39OQig7Zi+N
	PpFzOALXRNuYym03CntNBnxPTkMZ1oH/7Y8uIDQW9hvPqwh89SuT1BlNPoojRbOB0BErT5
	8LeCqyHGJ1ecRkOG/3rvp8W0PdwXuG4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IS0dUb2l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6703D6186F;
	Fri, 27 Mar 2026 11:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD33C19423;
	Fri, 27 Mar 2026 11:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774610490;
	bh=swcohrFbsQ9OatkiOSOTSr2Oxhk0CH56KvYFD2WN+Ys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IS0dUb2l6dq/UKuQvOxjZqoanLCXjZM37R1bc4wCScoCJe4XW8j2TvJ+wLupL5zn4
	 /5+ULZLFGH97Bb84dwDA6SaV6wum4iCZYiVl7bAMK5c9/zGxj1Pcpqx6qj4m1ELKw7
	 tTo5wVnT//ihfdMz19PopHmuv+Wtie7OyKTk8UCqowLlxFHq6C7dH/6DgA+NI4XW0s
	 MqGDbpHnUvkRsy9SlPdgGLyxftYSB5tdhn7ou2al0Bu7ezYiGcyMWJ5AtgSEarW4Q+
	 1z2fKkkmgqsYj1iQ0dDmcE/+ChBUdBwUSGZeTlyt4g/w0pBwbutvb8OsV1/oWSEZQk
	 uQ4PspkZSd0hg==
Message-ID: <d120d8d3-f785-47ec-9c6b-b28d42ebb1f7@kernel.org>
Date: Fri, 27 Mar 2026 12:21:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
 Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
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
 <f100305b-6c56-4499-98a4-6a22f8c49443@arm.com> <acZVS-ehXCtvcA9s@hyeyoo>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <acZVS-ehXCtvcA9s@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9E1E40010
X-Stat-Signature: 7auk3aaxtsdxibmjyqbhrsbcjgjs393o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774610490-113909
X-HE-Meta: U2FsdGVkX18PyAy0VukQgwCyV7UgJVPMInrSPCHhtqstzfn7hFYiPaz2ORD6cBjmSZOcMpQmKe/9MxWSpB4Z6qJoEJnakKRIhLnCbXG37JC/PG2c8Q3VLGvKr6GqXU+gZY9NSQzmdBeLaD4C4dA/EvJrx8pwbVdrETI2ZU3rCxcuKDmkAj3MEkZx6XPwi1PSYaV0e1fUODmhZj04aY28fEUdCyASa52zNkjm0RfJuQy6YEp/xzmcxTGmOwfvo72SHGBoTEvFv1UapSI5ti2hRDmOXzxoE34eSSbDjqyrAfrgwzgqX6pl5Hb8z5fJZ/WouNn6ot75JxGIfumpkjXCVI+LKjfo1m/cyRdCXA2dWTBpyqhj8p3E/2lgLbB4lu1lSsisQXvAEtr6WrFQHP05bOceVP7Gm9E09Xa0cX+l6Q9+QVytTPXC0avYnJ5pkDW7uMldTnr7gMqvXz6Yxxnbv5zNt5pxLUD2zs3VO+b2bUwgDWFx41uehA+NtYLM6JdaJ+F26PhrxHYVIgrDg5DjOMj5XCmhbisfFzwZJRVwrOH854kB/A1jE5/fBy/KRgjvNbRTvej4FDeaHnCTaYuGAGA2zn3vkQpKHh1cnfmfcEOxxgrjn6Sry9JY9dcuRb3fI7GLdOkWd43N9CLXayGCSzzKX5YZo0CrXZzNmhDJoLmEsEa5hKZPE4funghDU605v/qKnFrjJ2DYLpjDKq4ki7Rw7m6BYcoNPEVbtcGb0Wn1uaJfHQ34YSbiSrYzGh7S1Jc/VuxVUAjB1bdqquBSAwMYVUszK3n6S7+60bNU1xzqySDBAnX2waqtv7HmQZRrr+Xriu0FtjDhVt/UttLFiXb3ynROZvjAyWHBW+mpbXfAjJonBAAb1ydxUGGp+Zngzo+gCoARJTaz83vesCEe7O5MBVMNaPgaU27ZvIYZSsCJ50eZtUfTjQLQT848tKrVFfBEGGbaI+CFM1jiSNW
 H5N1Ie1I
 pHOIvLOWCIksq0U+Q1O4INxw5F3WuFwPijKzhWx8r+wwUIWjY3eZb09nQwkx0yJsfvIOs3xlwHy5P1YyhTKa7+jrt5Kia0bXdXxyLyN2NSlkHR4x5UUy56AJO/4F8lXwpde7MMfCJPItJvm++vQnbKuoIMZQOO0w8eD+ShlhUHK1uiFO6/b3OVwawOMa7YxWRXZWTv6uTw/TX4VWY8LyLWClOzKFXbS4DWfEZapbbkJbVuyy6pRXR2fvBmqLrO17bKAWV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 11:00, Harry Yoo (Oracle) wrote:
> On Fri, Mar 27, 2026 at 08:58:36AM +0000, Ryan Roberts wrote:
>> >>>>> On 3/26/26 13:43, Aishwarya Rambhadran wrote:
>> >>> Right so there should be just the overhead of the extra is_vmalloc_addr()
>> >>> test. Possibly also the call of kfree_rcu_sheaf() if it's not inlined.
>> >>> I'd say it's something we can just accept? It seems this is a unit test
>> >>> being used as a microbenchmark, so it can be very sensitive even to such
>> >>> details, but it should be negligible in practice.
>> >>
>> >> The perf/syscall cases might be a bit more concerning though? (those tests are
>> >> from "perf bench syscall fork|execve"). Yes they are microbenchmarks, but a 7%
>> >> increased cost for fork seems like something we'd want to avoid if we can.
>> > 
>> > Sure, I tried to explain those in my first reply. Harry then linked to how
>> > that explanation can be verified. Hopefully it's really the same reason.
>> 
>> Ahh sorry I missed your first email. We only added that benchmark from 6.19 so
>> don't have results for earlier kernels, but I'll ask Aishu to run it for 6.17
>> and 6.18 to see if the results correlate with your expectation.
>> 
>> But from a high level perspective, a 7% regression on fork is not ideal even if
>> there was a 7% improvement in 6.18.

In retrospect it was an oversight not to disable the pre-existing cpu
caching layer immediately for sheaf-enabled caches in 6.18. Can't undo that
mistake now, unfortunately.

> If that improvement comes from the number of objects cached per CPU,
> I'm not sure if determining the default value (# of cached objs) based on
> "a point when microbenchmarks stop improving" is a reasonable measure
> because the default value affects all slab caches and will inevitably
> increase overall memory usage.

Yeah that's the thing, some workloads might just keep improving as you throw
more caching at them, but there's a memory usage cost to that.
A case of stress test doing nothing but forks might also not be
representative of performance of forks under normal workload where other
operations also happen, returning the related slab objects, so in the end it
doesn't expose the batch size that much.

> Hopefully we could discuss what a reasonable heuristic that
> "works for most situations" looks like, and allow users to tune it further
> based on their needs.
> 
> As a side note, changing sheaf capacity at runtime is not supported yet
> (I'm working on it) and targeting at least before the next LTS.
> 


