Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 084FA106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A75A6B008C; Thu, 26 Mar 2026 05:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E866B0092; Thu, 26 Mar 2026 05:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB996B0130; Thu, 26 Mar 2026 05:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B68C6B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:58:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D35B5C432
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:58:39 +0000 (UTC)
X-FDA: 84587764758.03.86156F2
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B4A6C000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:58:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=XVGLFt7A;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guDjPoCVnwYxXsCuno8FxlAqWDyeX+17V89RQydjDBU=;
	b=rnbuUtqGf7Db8PmaT3crSrD2BTrifXGDmEgRNEleYy37LLWs1OBnL5LbfK7lcmwwfyTHT5
	Lb8kLK5p9lvb/NPMYpeX1A49vb7A558C7a7/6k2eYkOWaN5AKpSnqdBr/lTaY8K/7jBMEJ
	qfstlzDgpKQvdSVmbTXCLgC3fwRt8kc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519116; a=rsa-sha256;
	cv=none;
	b=BxT+tRbqQsnUnjQ5R9fTbCfCj6CYatGOl3dvj+gVManju1sEJZOuKAk/mrVNB3mm2jEjyU
	7URvK8vBXcnRJ0muocEmvJVfkjAgP4gkZ8Ic7NEcPb6xXWlJ/rJzjoZQ+qx46xJpiD/NUG
	JrZjy6/CrvrQDuiLXwUewudmhYZuH0Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=XVGLFt7A;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260326095833euoutp02d97fb3c0c8c51e38822995d3ff738c1e~gW7tvEtyN0124501245euoutp02V
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:58:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260326095833euoutp02d97fb3c0c8c51e38822995d3ff738c1e~gW7tvEtyN0124501245euoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774519113;
	bh=guDjPoCVnwYxXsCuno8FxlAqWDyeX+17V89RQydjDBU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=XVGLFt7Apqn21yhPWeW1UNuhKNqTboOtZ+UhS0CgObFVgMXWsowDWbu+tsM39Lyws
	 WYbg+km/a8z317lu3iAH0Q8461T4DF+/r6W6OVS6Kv5p6Qa60MMn0mGJBdimobDgV3
	 0Sm0SC4jjh7ucYpJIlfauJFgIvcrvltVOJDm2l8M=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260326095833eucas1p1f993eda67f6c9a6b3e67a439f023871d~gW7tMghLC0527405274eucas1p1x;
	Thu, 26 Mar 2026 09:58:33 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260326095832eusmtip2da486e52f07287d36be8ef809ccac84b~gW7sXJRUn1854318543eusmtip2P;
	Thu, 26 Mar 2026 09:58:32 +0000 (GMT)
Message-ID: <fe9359e0-1c9a-4113-82c3-0275c932a58a@samsung.com>
Date: Thu, 26 Mar 2026 10:58:31 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/7] Refactor reserved memory regions handling code
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev, Krzysztof Kozlowski
	<krzk@kernel.org>, Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	Saravana Kannan <saravanak@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260325141648.GA2685599-robh@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260326095833eucas1p1f993eda67f6c9a6b3e67a439f023871d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090029eucas1p1932917cc4839c3349932aeda37a7125d
X-EPHeader: CA
X-CMS-RootMailID: 20260325090029eucas1p1932917cc4839c3349932aeda37a7125d
References: <CGME20260325090029eucas1p1932917cc4839c3349932aeda37a7125d@eucas1p1.samsung.com>
	<20260325090023.3175348-1-m.szyprowski@samsung.com>
	<20260325141648.GA2685599-robh@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: sx7t4uprg15rpjsdm4bdfkmdzemx888h
X-Rspamd-Queue-Id: 4B4A6C000F
X-Rspam-User: 
X-HE-Tag: 1774519115-798637
X-HE-Meta: U2FsdGVkX1/Nm5vCRvBipCh/UH1XQtfvR409hEADIbhVk+Y9lUjXBGTQSUMswNvhSpMPVPxqrZqWviohzCNWel7j4+TA/GX+6/YQkq+pFBeo5WH0GWHgVuCmmHi+07l1nklu8uPxVb591bWjAGlpfyfwX/W1fN2tNeWojwm65Yb4CwRP6ikou2s52olt34VIM4sYv9G6OvLscwTsoqN6yjlFkgkEVsTZP9VOCEs5rxmAqFxg6FZhIetHzDKhq0RLb2FovTIo/ZpInpWrJwqrt6ZbXm3hGro4VT6vAz+S/ysNi83Bko/EjFraQvR0Q0UWjBghrJ8rx510FJQsgcOg2XYSnCoi/cMYApPJG8zqZDnE41do4DhevmiGj8wNNO73ibsk1EFtFmJJHTk/jSVTlBU7BW4/gNmvT/SBmIs2/2MPN3uCGJQc+CKg3Coyu/06mWnH8n7MDNE3XK7UDSYCWLXImak2vHZ+BNMwvDtfRtNdUk1JbiylCDPc8xTS+qcGRImj2QoOemZbZWp971EfOqtUlyTMrfHC/iNoiqFXKekuHJsYkdidXcr+wJWB8bwehzs9ij6gbja5CBF0lpOXgTA1S2hkf8tGvelWZtOpEW/YhOeoPm8bWCfyHNoUh3OBGum5iaLSNBq6d7CYMRnyROsJXas4Om8vw6Fw14ZRcKehZ2iHmnnTFt9AoGQ5bjJ7dB9WnxUK+LCw91p4lbEZNsYhB5BYJ4Wp0HcV1v88m9yHShlXHzvWJWcaq+xjnLyLpqTMX1xynIPL5P1B8sdGK1jq/EEPRX7LthKPEDZ73l+e0XOwE3c/i3yd+6U5PxkoUsf6mGuatPaphWO3pkcwaklNhMlvWEPv539LJJ6puUIoo4WfSPDDaLEKkEFXgfyNrEyEGynTmSKMp/Hrsc2t8POjpVW+mhd2jUh5awDDP96uiKbC+HDgZe6t9pfpAPVxQorCef9zIl0Hf4BjM8r
 C4Nx0wDe
 +/fvApAZwwrgJuznAcv19gVH+qSkc5TJRcM06sFioZfL/BIid+spGkSvFaPVvKjV/mSLH9aMA8jZgeLpDV3BGfF4dwFO1XRm0i/5Sx1L7aOAWcdyZR1HaCg7ke7901MVNWa9v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rob

On 25.03.2026 15:16, Rob Herring wrote:
> On Wed, Mar 25, 2026 at 10:00:16AM +0100, Marek Szyprowski wrote:
>> The reserved memory regions handling code was reworked to handle
>> unlimited so called "static" memory nodes in commit 00c9a452a235 ("of:
>> reserved_mem: Add code to dynamically allocate reserved_mem array").
>>
>> The side effect of this rework was a set of bugs fixed later by commits
>> 0fd17e598333 ("of: reserved_mem: Allow reserved_mem framework detect
>> "cma=" kernel param") and 2c223f7239f3 ("of: reserved_mem: Restructure
>> call site for dma_contiguous_early_fixup()"). As a result, the code in
>> drivers/of/of_reserved_mem.c became a mix of generic code and CMA
>> specific fixups.
>>
>> In this patchset I try to untangle this spaghetti and perform some code
>> cleanup. I hope nothing breaks this time.
>>
>> Best regards
>> Marek Szyprowski, PhD
>> Samsung R&D Institute Poland
>>
>>
>> Changelog:
>>
>> v3:
>> - fixed more issues pointed by Sashiko in
>>    https://protect2.fireeye.com/v1/url?k=c0975fdb-a11c4aed-c096d494-74fe485cbff1-5d0a8d4ece172e7b&q=1&e=abd3a151-11c5-430e-a6ac-b04cc3b34ab7&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fpatchset%2F20260323100901.4079171-1-m.szyprowski%40samsung.com
>>    (restored use of _OF_DECLARE macro, extended some comments and commit
>>    descriptions, the remaining items I consider not relevant)
>>
>> v2: https://lore.kernel.org/all/20260323100901.4079171-1-m.szyprowski@samsung.com/
>> - added missing ops assignment removal in tegra210-emc-table and swiotlb
>>    drivers
>> - fixed issues pointed by kernel test robot and Sashiko: removed typos,
>>    improved comments
>> - fixed incorrect node passed to fdt_validate_reserved_mem_node() in
>>    fdt_scan_reserved_mem_reg_nodes()
>>
>> v1: https://lore.kernel.org/all/20260313150802.1121442-1-m.szyprowski@samsung.com/
>> - initial version
>>
>>
>> Patch summary:
>>
>> Marek Szyprowski (7):
>>    of: reserved_mem: remove fdt node from the structure
>>    of: reserved_mem: use -ENODEV instead of -ENOENT
>>    of: reserved_mem: switch to ops based OF_DECLARE()
>>    of: reserved_mem: replace CMA quirks by generic methods
>>    of: reserved_mem: rearrange code a bit
>>    of: reserved_mem: clarify fdt_scan_reserved_mem*() functions
>>    of: reserved_mem: rework fdt_init_reserved_mem_node()
> I've applied the series, thanks!

I forgot to mention this earlier. There are other pending changes 
tokernel/dma/contiguous.c like 
https://lore.kernel.org/all/20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org/ 
which I would like to merge to -next. This conflicts with this patchset. 
Could You provide a stable branch with those changes to let me resolve 
conflicts in kernel/dma/contiguous.c on top of it?

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


