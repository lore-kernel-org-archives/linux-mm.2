Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCBC8C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9CC46B0109; Thu, 22 Jan 2026 03:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A706B010B; Thu, 22 Jan 2026 03:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C774E6B010C; Thu, 22 Jan 2026 03:04:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B63496B0109
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:04:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76E7A568AA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:04:02 +0000 (UTC)
X-FDA: 84358861524.17.BE08EF1
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2376C140002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:03:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769069040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V8/eAamVR0ttrJqlJr3vIJA0wQ/ex3KjAWKTcDCL7Ro=;
	b=LxIGejno7DodkjvIayQ4PlvCuNkklbVm+H0Y897JSG797nxdcCHEWhrb2aixbK0Sj7q9aD
	owG/MLEcA/pO4+A9N1oMqdb+OyAG3D8AkrkUFTF9KrF0JUSK9lcQmeFT/cHKi11Hnr2/9x
	ncu+MHQenKWtqQ592d6JS711UlDPBQ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769069040; a=rsa-sha256;
	cv=none;
	b=usZNUQuQjqo6aWieDmFP+/UefenfaznDHLcYm7muKc1wKzJ1addIkVtmZqe7fwtcDOMYg+
	Wy6mdJNUk6zAvDrs1HVWlvwJGVM2rzGbpOfdBc3sJmW/pJCs07RwxrwQlRdOQMGFkE43t7
	9L+Rbfvb6yAB2baGQSdxhs00lc3+I3g=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-6 (Coremail) with SMTP id AQAAfwBXXSXn2XFpBkdMAw--.12812S2;
	Thu, 22 Jan 2026 16:03:52 +0800 (CST)
Received: from [10.22.77.56] (unknown [123.150.8.50])
	by mail (Coremail) with SMTP id AQAAfwDnQO7m2XFpT6cVAA--.38292S2;
	Thu, 22 Jan 2026 16:03:51 +0800 (CST)
Message-ID: <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
Date: Thu, 22 Jan 2026 16:03:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID of
 CFMW
To: dan.j.williams@intel.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Mike Rapoport <rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
 <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
 <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
 <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
 <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
 <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
From: Cui Chao <cuichao1753@phytium.com.cn>
In-Reply-To: <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:AQAAfwDnQO7m2XFpT6cVAA--.38292S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQADAGlxMvwDCgAAsd
X-Coremail-Antispam: 1Uk129KBjvJXoWxCr4kWr1fAFyDtw4kWrWUCFg_yoWrCF13pa
	y8JFWvyr4DGryIkr1kXw4kXr1F9ws7Gay3Gry5Cr95CrnxZF1F9r4SqayYvFZ3Gr1fWw1j
	qF4jqrWjv3Z8ZaDanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Stat-Signature: ocmwqmjitrk9oyknih99rndx4cmkmcid
X-Rspamd-Queue-Id: 2376C140002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769069037-397642
X-HE-Meta: U2FsdGVkX1/+mWsEEZgZTwaNAT7yRLhn+kSrzeXAbfC4BDs6hhUn+C0Et7slBAwlxkQuJByFowY+y7TEVMkth3rhDe8ShCbffpwedQ6m6l7J1JmAx+PlgHQQqYzJD171UCZUvA16SPSX+d+i7qC0HunHvyokOxgNeWNGNW6k4zxsDv/iMeJTqaxm6WTb2uocVWmQfyYxi8oCY1ODihauSkAA/LU5cDLgSnvGB7Z8zU21PI+5/HpVlHSZnMqhwXahqsCBHWEA15+geZcJ99lzbAjAkw4S3hSQG7ywSHzfR4cPqcOSimDTWHOpKuWuhfwyc4GftriIliTgP+uZNOATGDhgq76snM0QsJ4vvUY1Zb7KVi/Q3FjAoMmmOlpipKrhOdSKut/np+AyKDiQdxNiEGH7Y3902vs5I8F43nba5MmqORf0up10CPyoKmsM9yeWdVCsaaZoJPQFdqln6zmha+iDQzj3ulO4D6XEXtmkzKk2NQRaT0F+lcotyctEyCgTLwDCR4TUazD7PlBaYiwM4Fa8S3t5iLUhXCJ2Kj6iFe4/DUEUgdgYIg95myEdGTwjCpSeNZpZ9vh6vDGMsM2YnBgfAgzCM90hHGoGQaTnk/quotwhy8ONlMivub633KiBe58vMsNhidERVVQ6LlOygW+lCYLBRy76SNPzLpC1G4vfiBZ40l/Dl6GVtD4ZhaC/Dlwm2y2UIRaz3gWLnmYEA+ptMtbRFWzJMZ7J9G/7Uwj8J9Gv75bVeXwsS4twAwqW/vrxyCkRuvv+cKEIZ8yeL3+hejnFHPdk+vCuxT64buCI+jsgGP+erc5kN1VAExHt3edfwJ1GSZMfJKSS+PQxG+gL2jakE9L4VoOuBMA1hzub0KRB6qx4Q77V8sQESIuxNkzs+z3Mn4wPyu1vVk247ciWv4+lMcg1DKpB/pOCldxVGAxnQ074fb6xeKdWnTpVrhqXjfel+BvFkH4zRcH
 jyfd1Zhi
 9inRXr9k59wCpW+X+Te3j+bISxwjo4IZhZOV6qT4+rM3a+NsgQeiFPMrMLsTno+UivRiEtQwYAuACdIvrETtkI44ZNNaXIQWgTgHn6WntbgmTskzeJ6OM+d8CH2ve4sJ53vx6Wl4+akqp3IIM53MLRi4Zgw810Y1hDP2y0A+Iqj23a4Njcpkffy8RwGBiC5lKjkIm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/16/2026 3:50 AM, dan.j.williams@intel.com wrote:
> Andrew Morton wrote:
>> On Thu, 15 Jan 2026 17:43:02 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:
>>
>>> When a CXL RAM region is created in userspace, the memory capacity of
>>> the newly created region is not added to the CFMW-dedicated NUMA node.
>>> Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
>>> containing RAM). This makes it impossible to clearly distinguish between
>>> the two types of memory, which may affect memory-tiering applications.
>>>
>> OK, thanks, I added this to the changelog.  Please retain it when
>> sending v3.
>>
>> What I'm actually looking for here are answers to the questions
>>
>>    Should we backport this into -stable kernels and if so, why?
>>    And if not, why not?
>>
>> So a very complete description of the runtime effects really helps
>> myself and others to decide which kernels to patch.  And it helps
>> people to understand *why* we made that decision.
>>
>> And sorry, but "may affect memory-tiering applications" isn't very
>> complete!
>>
>> So please, tell us how much our users are hurting from this and please
>> make a recommendation on the backporting decision.
>>
> To add on here, Cui, please describe which shipping hardware platforms
> in the wild create physical address maps like this. For example, if this
> is something that only occurs in QEMU configurations or similar, then
> the urgency is low and it is debatable if Linux should even worry about
> fixing it.
>
> I know that x86 platforms typically do not do this. It is also
> within the realm of possibility for platform firmware to fix. So in
> addition to platform impact please also clarify why folks can not just
> ask for a firmware update to get this fixed without updating their
> kernel.

Andrew, Dan, thank you for your review.

1.Issue Impact and Backport Recommendation:

This patch fixes an issue on hardware platforms (not QEMU emulation) 
where, during the dynamic creation of a CXL RAM region, the memory 
capacity is not assigned to the correct CFMW-dedicated NUMA node. This 
issue leads to:

  *

    Failure of the memory tiering mechanism: The system is designed to
    treat System RAM as fast memory and CXL memory as slow memory. For
    performance optimization, hot pages may be migrated to fast memory
    while cold pages are migrated to slow memory. The system uses NUMA
    IDs as an index to identify different tiers of memory. If the NUMA
    ID for CXL memory is calculated incorrectly and its capacity is
    aggregated into the NUMA node containing System RAM (i.e., the node
    for fast memory), the CXL memory cannot be correctly identified. It
    may be misjudged as fast memory, thereby affecting performance
    optimization strategies.

  *

    Inability to distinguish between System RAM and CXL memory even for
    simple manual binding: Tools like |numactl|and other NUMA policy
    utilities cannot differentiate between System RAM and CXL memory,
    making it impossible to perform reasonable memory binding.

  *

    Inaccurate system reporting: Tools like |numactl -H|would display
    memory capacities that do not match the actual physical hardware
    layout, impacting operations and monitoring.

This issue affects all users utilizing the CXL RAM functionality who 
rely on memory tiering or NUMA-aware scheduling. Such configurations are 
becoming increasingly common in data centers, cloud computing, and 
high-performance computing scenarios.

Therefore, I recommend backporting this patch to all stable kernel 
series that support dynamic CXL region creation.

2.Why a Kernel Update is Recommended Over a Firmware Update:

In the scenario of dynamic CXL region creation, the association between 
the memory's HPA range and its corresponding NUMA node is established 
when the kernel driver performs the commit operation. This is a runtime, 
OS-managed operation where the platform firmware cannot intervene to 
provide a fix.

Considering factors like hardware platform architecture, memory 
resources, and others, such a physical address layout can indeed occur. 
This patch does not introduce risk; it simply correctly handles the NUMA 
node assignment for CXL RAM regions within such a physical address layout.

Thus, I believe a kernel fix is necessary.

-- 
Best regards,
Cui Chao.


