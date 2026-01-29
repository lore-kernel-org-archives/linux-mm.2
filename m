Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACE9D6101A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09E86B0005; Thu, 29 Jan 2026 09:49:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB81E6B0089; Thu, 29 Jan 2026 09:49:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3256B008A; Thu, 29 Jan 2026 09:49:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7C9A6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:49:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49766D2E08
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:49:54 +0000 (UTC)
X-FDA: 84385285908.19.A1A1407
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8C4B9140009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:49:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rvBBIJ1e;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769698192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pZauEyJNKWoqPnWbSN9zNexw19b7pnJQnRLbQOGj5g=;
	b=FUY0RuTXElBPk3QO4Lv+QdDIGKlorR1JG6IT27DnolkM4DeXwnlZgvOgl84gcozkkBJ5Mz
	LdGnuzyQAChJnczs7RcwkcymICaC9WcxOpwkhe7lJs0yvkvKHnlbwVa5+st3NFvBcAm4Wq
	e29pdZyneSxNfXuIclLEtuYS/31wAhA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rvBBIJ1e;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769698192; a=rsa-sha256;
	cv=none;
	b=Nfuw9WgYxh/rPlhuARdVTxEonflkHKKgjqqM+ESlwRC4GTc1thdcHr9I8LWfE9pwUsvW3U
	Vm42VCrrtVSABoSzEmig5PfEGuqZC+/H+324riNR+LRoFClPEmED6SJgiAFcRsYdnkUze3
	BD7tb0rZGifws2pAjXhHoiNkLhfLr6g=
Date: Thu, 29 Jan 2026 22:49:41 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769698190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7pZauEyJNKWoqPnWbSN9zNexw19b7pnJQnRLbQOGj5g=;
	b=rvBBIJ1eg2aFO5nlAjIpyMhFPxvkEnyT1gJmMUU76X3YpF/CWQ/Qr9ifuAG6hR9nFSLzaS
	We88DXSfeROVgGPK/NeDNhYRNiWsfhs0Ri04tM9uW4GB0/aB3soOzQebhar+dCpQnOGI/0
	4CLC/AbmkQxco9iuhZg8pFPnUdnEtrs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [vbabka:b4/sheaves-for-all-rebased] [slab] aa8fdb9e25:
 will-it-scale.per_process_ops 46.5% regression
Message-ID: <eefkvperwakt6zgjs7gp5s6u5tnuqsqfcl7zlgneft7gr542zt@dkaia5zpbmsc>
References: <202601132136.77efd6d7-lkp@intel.com>
 <3dfb6857-3705-4042-9a30-da488434d9e3@suse.cz>
 <rsfdl2u4zjec5s4f46ubsr3phjkdhq4jajgwimbml7mq6yy2lg@krjc6oobmkwz>
 <3317345a-47c9-4cbb-9785-f05d19e09303@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3317345a-47c9-4cbb-9785-f05d19e09303@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C4B9140009
X-Stat-Signature: bfqn8z5bsrw7idqa4xwnonpzjor7bpit
X-Rspam-User: 
X-HE-Tag: 1769698192-288931
X-HE-Meta: U2FsdGVkX192XTBKnQg1EErOqVdUfoRQLaQliUzDay6K5/1JnyxmcdR5CO6sgA7S5XJQwqiyLuI6XZmalqBPGqjr9tiAZM/ZH7WtBpsm+4883cUniKVpN1L0v/e3WbHP/wkDm5IXX443Ui4zetNKQjqaRrWjNL52gVgVcYWbhJ6r7PcTRaBfv7/w3jXmGZWMxY3M1y1weIq53Yx5UXrcPWNoVFOLSwSGNgcYnd4O8Io4cpMjJ42o0d4QujHHcsoJyRH2MDqXvFnn8Uj2AkIr/xNWPE2fPQnju0LCxJ0LDQIjGHZnEVgBetor4F8VGHTSxvTlYyojwQ/2e32S5PfQt9GhdJM5sa9yWTWSsthrjwxuhtNmlJmPGWwhfrTCanzq8fJrYZbnVCm+V2c+ZF7rM95AnKoZ/KskfP5O+wUsdUnU0zjALAruWtGY3hWOI5AvZseW6DXgApTypfHOWAqhSncCMMKRHWlSrkqVjnF7dZhxjT/G5cS9tYOedmXAHTHAT1w3GMWkW9Wy20Mnx4gMNshQ+1hzBre+tly8xMIF8ApIJaYArirqJIqA0kEzYc1UjOyAS2Wqy8z85HMunST+A+8CIOx0gE1fTxCSeOCGf2tuj6Sm1lqySn+5+LwAPpQxLW8FpzxKw3y4ad7jGWWmkoM/NWBqxQ2uZ7XaBiG7t94uDyIP8rfsPfpTt9OI7aaHs2+e9O/BPl4QZSVPcbmlFi1qtVXj+xOy3VL/NVYpULP4+36eNA+CxyyAXiu/5tlImL6Dyb3Ubf2N7CHtSo64Z/uc7UfMYyazx8t3QGArWzAnm5bZsnStcNYZPzCpVGlstzj2jtDd7pfkNU5lKjWxbPfMfo01FhykivoFF3/ENDY7HNOcmWsroul+/OmRl9AGLam0ds8VNnKmKP/IuMBOj5C7NeI1NL2Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:47:02AM +0100, Vlastimil Babka wrote:
> On 1/29/26 08:05, Hao Li wrote:
> > On Wed, Jan 28, 2026 at 11:31:59AM +0100, Vlastimil Babka wrote:
> > Hi Vlastimil,
> > 
> > I conducted a few performance tests on my machine, and I'd like to share my
> > findings. While I'm not an expert in LKP-style performance testing, I hope these
> > results can still serve as a useful reference.
> > 
> > Machine Configuration:
> > - CPU: AMD, 2 sockets, 2 nodes per socket, total 192 CPUs
> > - SMT: Disabled
> > 
> > Kernel Version:
> > All tests were based on modifications to the 6.19-rc5 kernel.
> > 
> > Test Scenarios:
> > 0. 6.19-rc5 + Completely disabled the sheaf mechanism
> >     - This was done by set s->cpu_sheaves to NULL
> > 1. Unmodified 6.19-rc5
> > 2. 6.19-rc5 + sheaves-for-all patchset
> > 3. 6.19-rc5 + sheaves-for-all patchset + list_lock contention patch
> > 4. 6.19-rc5 + sheaves-for-all patchset + list_lock contention patch + increased
> >    the maple node sheaf capacity to 128.
> > 
> > Results:
> > 
> > - Performance change of 1 relative to 0:
> > 
> > ```
> > will-it-scale.64.processes  -25.3%
> > will-it-scale.128.processes -22.7%
> > will-it-scale.192.processes -24.4%
> > will-it-scale.per_process_ops -24.2%
> > ```
> > 
> > - Performance change of 2 relative to 1:
> > 
> > ```
> > will-it-scale.64.processes  -34.2%
> > will-it-scale.128.processes -32.9%
> > will-it-scale.192.processes -36.1%
> > will-it-scale.per_process_ops -34.4%
> > ```
> > 
> > - Performance change of 3 relative to 1:
> > 
> > ```
> > will-it-scale.64.processes  -24.8%
> > will-it-scale.128.processes -26.5%
> > will-it-scale.192.processes -29.24%
> > will-it-scale.per_process_ops -26.7%
> > ```
> 
> Oh cool, that shows the patch helps, so I'll proceed with it.
> IIUC with that the sheaves-for-all doesn't regress this benchmark anymore,
> the regression is from 6.18 initial sheaves introduction and related to
> maple tree sheaf size.

Yes, one of the factors contributing to the regression does seem to be the capacity
of the sheaf.  

And I feel that this regression may be difficult to completely resolve with this
lock optimization patch. I'll share my latest test results in response to the v4
patchset a bit later, where we can continue the discussion in more detail.

However, I believe this regression doesn't need to block the progress of the v4
patchset.

> 
> > - Performance change of 4 relative to 1:
> > 
> > ```
> > will-it-scale.64.processes  +18.0%
> > will-it-scale.128.processes +22.4%
> > will-it-scale.192.processes +26.9%
> > will-it-scale.per_process_ops +22.2%
> > ```
> > 
> > - Performance change of 4 relative to 0:
> > 
> > ```
> > will-it-scale.64.processes  -11.9%
> > will-it-scale.128.processes -5.3%
> > will-it-scale.192.processes -4.1%
> > will-it-scale.per_process_ops -7.3%
> > ```
> > 
> > From these results, enabling sheaves and increasing the sheaf capacity to 128
> > seems to bring the behavior closer to the old percpu partial list mechanism.
> 
> Yeah but it's a tradeoff so not something to do based on one microbenchmark.

Sure, exactly.

> 
> > However, I previously noticed differences[1] between my results on the AMD
> > platform and Zhao Liu's results on the Intel platform. This leads me to consider
> > the possibility of other influencing factors, such as CPU architecture
> > differences or platform-specific behaviors, that might be impacting the
> > performance results.
> 
> Yeah, these will-it-scale benchmarks are quite sensitive to that.
> 
> > I hope these results are helpful. I'd be happy to hear any feedback or
> 
> Very helpful, thanks!
> 
> > suggestions for further testing.
> 
> I've had Petr Tesarik running various mmtests, but those results are now
> invalidated due to the memory leak, and resuming them is pending some infra
> move to finish. But it might be rather non-obvious how to configure them or
> even what subset to take. I was interested in netperf and then a bit of
> everything just to see there are no unpleasant surprises.

Thanks for the update. Looking forward to the test results whenever they're
ready.

-- 
Thanks,
Hao

> 

