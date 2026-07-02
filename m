Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B35C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49CA6B00E4; Thu,  2 Jul 2026 20:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAF66B00E5; Thu,  2 Jul 2026 20:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910A36B00E7; Thu,  2 Jul 2026 20:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 626FA6B00E4
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:35:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D80A11C56CA
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:09:15 +0000 (UTC)
X-FDA: 84944169870.12.2A3E361
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0BCC21C0005
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:09:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dkh9RWL9;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783004954;
	b=hreo/oveWmiLtv7g90RLTseFLa1APD2CHBwArRPHP2GB//T7ppzaOU4IT515wm2o94/xrS
	tkP6fFHlnbay1hlsQmvKEjWjY6fos0nGVCDfNnuJmE1PvboSTYodztc9Fm/MZmtLtXyTP7
	d4ExWHhDL1vYlTryLTG+j+78mXPI6uI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783004954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVgi/IDW6MB0ICHH5yTujujreeH5t5fHN661xjkq/74=;
	b=Q8A4MKmnCRWknh2f5imSPJwSp/CElwub2cE2h+igdtc4iLDtNz2rIfUgyjRK9Qt5HsDw/v
	+CRj1ITaFWn3E4dqPWhgwAkswRIvdZ6qzimm1B2kEtqIW5bPCGhkNw5rHJlKrQGvBhzkf7
	oo1tgpC0u/O1DALVtBsk+2XEQS/05pw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dkh9RWL9;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <cf5a92d3-2c7e-41e6-afed-f2a4c9d1a774@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783004941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVgi/IDW6MB0ICHH5yTujujreeH5t5fHN661xjkq/74=;
	b=Dkh9RWL9rMIQE6Ur1L+lFP9fWBIPUF1EBlETBXiV1FwoU/+0F4n7u3+DtwQotZKTkFazHu
	oHVZr/Vs+FAfYKVbUxY57cWOfPctKhbPm5r74IEfkBs57Xoqgu/OIspBSvCnXq9uEYouaN
	h+ygMrTbcJpYGV90L9aTDp+5SWenOgM=
Date: Thu, 2 Jul 2026 23:08:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 02/13] mm/vma: update do_mmap() to use vma_flags_t
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, tsbogend@alpha.franken.de,
 maddy@linux.ibm.com, mpe@ellerman.id.au, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
 l.stach@pengutronix.de, inki.dae@samsung.com, sw0312.kim@samsung.com,
 kyungmin.park@samsung.com, krzk@kernel.org, peter.griffin@linaro.org,
 jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
 rodrigo.vivi@intel.com, tursulin@ursulin.net, robin.clark@oss.qualcomm.com,
 lumag@kernel.org, lyude@redhat.com, dakr@kernel.org,
 tomi.valkeinen@ideasonboard.com, hjc@rock-chips.com, heiko@sntech.de,
 andy.yan@rock-chips.com, thierry.reding@kernel.org, mperttunen@nvidia.com,
 jonathanh@nvidia.com, kraxel@redhat.com, dmitry.osipenko@collabora.com,
 zack.rusin@broadcom.com, matthew.brost@intel.com,
 thomas.hellstrom@linux.intel.com, oleksandr_andrushchenko@epam.com,
 deller@gmx.de, bcrl@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, hughd@google.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, kees@kernel.org, perex@perex.cz,
 tiwai@suse.com, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org,
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev,
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org,
 linux-fbdev@vger.kernel.org, linux-aio@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-sound@vger.kernel.org
References: <e0ac58ad2b88ff7e2f0024e3286b2e786f79ca32.1782760670.git.ljs@kernel.org>
 <20260702111531.64883-1-lance.yang@linux.dev> <akZwsS-_cywsXSjL@lucifer>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <akZwsS-_cywsXSjL@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0BCC21C0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6jfnmojdwt48o87yxeithyxmmok3u7yh
X-HE-Tag: 1783004953-166670
X-HE-Meta: U2FsdGVkX1/UMmjPXG2bkiSljrIclrNLyajETI3Z+aa6UD6ySaceF+VYau0jKyqPMKEtGhoN/D+PDI9+eG1GYiqFAR/CtaVz96v3nfkJ3hKh0e1lpqNHf0fOK6r53y8HgA7NqUFfaXRaKvRf+2xibdmiqC3pUNVAcO6aUCC8ad/6TqtdbF27P9OPUzmXUS1tBpY8i8cJ29+Ym3Vta4aQ8nSj19zfhb/g3uBfUSDakYx/4HN+8zS1jh7EwN9e3yMV7L8DwF7+woixCwhLdNEVQ2S6RjGCkyxYmrwsOe3Pa3L6YsnocMwI3Xr38FGBKnLA9bZKgK1+To5frrqG+QdnqCSQt35pS09oQj3hIdbNkzd2d0k+H03zjdB1Gh9orBVL5ldk7GrYejSSpBEMz1M1RECf4tmrI4dDHjRUkM9YwA6KYj537KT8LvVWeJAeCwfkwajrKm/agJDdEB/Kviq+eUAc+0ApGLYhCG59/inBlDI1tbz0g0Sw5aSPpuQpEmsllO+MbcT5neEYdb/p+3jsLC3m94ItNzWGNqe01NMluo4KpmJngVl1DV+1XF6iu1EoqU31QNg3u1t6YbxLEhmo2ZSwo6eBY/z3zsRAhxOiNHSvqTHaKMv1lCPnKpDR4VZhXFd55T187KRuBojT7xK8MaE6iIekIia5AMSOJHXSRvQXdJxipUdBCEsub3hrgQwSPYxTCXnAwQq5HqjLk9hBq6gVCdn7qEKs9c0R0MUEGqi7fy1zjvVGOzbfnfYnAke/oLdx6L5ayLyKjTVuQG1keE7GBRNRrvdD/dEaI2lyL6w60gKOOCMSx8mWazDzxhjNEbcAJrld7qPkP4TW7aD6oDht6UoxfA830F9i8AXKfoq0TJASgQW13CXcrvQjOGZBoe72RpEqElBtTRUL6cJH5X7wLDlN2OoTPxjzO1CtxChISKwxU6k6ENUalX5JfPplwDaj3GjVoyxPgtg8s+4
 qas4xQRP
 WRWckpOap8YJG6LpZVOsfAvqF2QhdWcuotmhodnRxHdpH9a0UCXHBIoIcKYXtIbAVT+zLtYiPEqFadvE6tH/UmYwbnRs2f+MS4/kKWQ2FzGWCxFpZ9jttoSmbeybkCnZnfS4pNWDDQBEbLSJyCwCt13B6EW57+0naYzC0a2Q/GDsBrswMjFi/DUZ/D+mzpgneejDdwzt3Augmx/OWUIz+QOT2kyuXankBZJzaICukxAYlUQf1ef0jLWM7BMuPgLIj57Xv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/2 22:16, Lorenzo Stoakes wrote:
> On Thu, Jul 02, 2026 at 07:15:31PM +0800, Lance Yang wrote:
[...]
>>
>> [...]
>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>> index 46174e706bbe..547352183214 100644
>>> --- a/mm/mmap.c
>>> +++ b/mm/mmap.c
>> [...]
>>> @@ -488,23 +496,27 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>>> 		 * Check to see if we are violating any seals and update VMA
>>> 		 * flags if necessary to avoid future seal violations.
>>> 		 */
>>> -		err = memfd_check_seals_mmap(file, &vm_flags);
>>> +		err = memfd_check_seals_mmap(file, &vma_flags);
>>> 		if (err)
>>> 			return (unsigned long)err;
>>> 	} else {
>>> 		switch (flags & MAP_TYPE) {
>>> 		case MAP_SHARED:
>>> -			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
>>> +			if (vma_flags_can_grow(&vma_flags))
>>> 				return -EINVAL;
>>> 			/*
>>> 			 * Ignore pgoff.
>>> 			 */
>>> 			pgoff = 0;
>>> -			vm_flags |= VM_SHARED | VM_MAYSHARE;
>>> +			vma_flags_set(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT);
>>> 			break;
>>> -		case MAP_DROPPABLE:
>>> -			if (VM_DROPPABLE == VM_NONE)
>>> +		case MAP_DROPPABLE: {
>>> +			vma_flags_t droppable = VMA_DROPPABLE;
>>> +
>>> +			if (vma_flags_empty(&droppable))
>>> 				return -EOPNOTSUPP;
>>> +			vma_flags_set_mask(&vma_flags, droppable);
>>> +
>>> 			/*
>>> 			 * A locked or stack area makes no sense to be droppable.
>>> 			 *
>>> @@ -515,23 +527,24 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>>> 			 */
>>> 			if (flags & (MAP_LOCKED | MAP_HUGETLB))
>>> 			        return -EINVAL;
>>> -			if (vm_flags & (VM_GROWSDOWN | VM_GROWSUP))
>>> +			if (vma_flags_can_grow(&vma_flags))
>>> 			        return -EINVAL;
>>>
>>> -			vm_flags |= VM_DROPPABLE;
>>
>> Old code checked VM_GROWSDOWN|VM_GROWSUP before seting VM_DROPPABLE. New
>> code flips that around. Hmm, shouldn't master, just made me look twice ;)
>>
>> Maybe keep old order?
> 
> I guess I feared that defining droppable above then referencing it below would
> be less clear?
> 
> Can move if you feel strongly about it, and sorry for making the move at the
> same time as the general vm_flags_t -> vma_flags_t refactor as it does make that
> less clear...

No need to churn just for me. Thanks :)

