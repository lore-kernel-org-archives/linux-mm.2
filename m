Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D87EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658096B00A5; Wed,  8 Jul 2026 04:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609116B00A7; Wed,  8 Jul 2026 04:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E186B00AA; Wed,  8 Jul 2026 04:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4216B00A5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:35:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B72D81C3D11
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:35:20 +0000 (UTC)
X-FDA: 84964950000.07.D1A30FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E9BBFA0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:35:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fYUxsPmo;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783499719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uiif8fNbVlBmdL2ASdJilfD3DbcrZEYwaykfaYTV9g=;
	b=YOhjZ5bP4lZs42NHal6Xsfvy2O4o52+5pjva/X/9AjGzdZmd96LhHLrJ5AvmI1XL7BsYNi
	dNhnGHtO6tRWUis3l7KcEtpD3iQHM+cJUHYcyjTbp7R94SwONm7AYRi9gKMgUi2p3fXLzY
	moDGWjR3njHzXrisyQbRfrg/O/c9YvA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fYUxsPmo;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783499719;
	b=B4vxdL5YNg4iYces8A3AZu0/oKDMVL50/w4Kd64Vu4qD0fcI4UJhz1bb7SqKyA0NUsDFve
	vTtndh/RFQGMP1og9msNkxAns4YmOWDMGBszAIJxgyc4MXRoO03Xw4+Py5tQ/T2EYfVZdB
	H6ErWwdD8E+pysONglsxst9BGZLiEoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27A9841217;
	Wed,  8 Jul 2026 08:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C78A1F00A3D;
	Wed,  8 Jul 2026 08:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783499718;
	bh=4uiif8fNbVlBmdL2ASdJilfD3DbcrZEYwaykfaYTV9g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fYUxsPmoKxL7tkvFv1U2Rkq6xMVJg/1EtoDALVfrTVYR/oX0m2IAHLgV46rXUnrIX
	 V0uuh6jKOZ3GzzNGIVlszOO5ORRcKo4qeopV99ra0pNDOZ56DxkBqfs0GYkKgomk01
	 emCNhpZT6zSqHMONM52Nxl1OF15mwts5If8BmwNxUTIylI2LzB9KO1ptrr1XE9B3Y/
	 SgwC8lBufAijCmw80odkWve+lpOybqcYgYD/CmfTYVvvkrzg29LXaLdQBqO845Ggxg
	 MR1bowcwqGF9mb2dXmeLK18OufZbp0oEbyarsZ+b6NAc4JpccziSxm2ug6GATnAxM2
	 vnYmHf6CHahBw==
Message-ID: <e212caac-6c30-448a-9e10-32fff8b842f6@kernel.org>
Date: Wed, 8 Jul 2026 10:35:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Thierry Reding <thierry.reding@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>,
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Russell King <linux@armlinux.org.uk>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Robin Murphy <robin.murphy@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
 linaro-mm-sig@lists.linaro.org, linux-trace-kernel@vger.kernel.org
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <CGME20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c@eucas1p1.samsung.com>
 <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
 <3f47aeab-33b1-4966-a5ce-5d6d5261e0e2@samsung.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3f47aeab-33b1-4966-a5ce-5d6d5261e0e2@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i8bqok5ucckcokzj78jm53grxcdm46ux
X-Rspamd-Queue-Id: E9BBFA0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783499718-17449
X-HE-Meta: U2FsdGVkX1+cwMYQMZxhfj5xSSSYKGE7mQcBkqHl69B4wND0HpsRL/4HXv8h34CPNFGTpeCZZ9Wum5HtmvUCJqFOZakRVvJorXWGn5cLWskJqWJ8NMg3pqy04MynTysDVbaVp5iZRvmTFkhy8T/YEhFya83C923e+XFcm+lSGmlPemmOC3HRrkV4ZfJgeHZeM1fHPK17gQxZ3TPCYSTyPcKdjdRxXym1jFLGLNMzUyEEl2Rr2fy5Pqnty4zDwGdHHelNksbOIui6zRTrCqmAEt1bF7Q4WjOUV3o0koN2PgnBhzlPg9HqkB8Hb/iFQti65GZwE7MdkmfYetuGyzei95cPYvyS3EKVqwPU8UstMzzQpk+vP08jtxiuoMiomR7B4mFlSqBM4oFk+Uuag8GJ7As56cAPWcrlUGw4H1TSJDRwX6i1QJmH/QlxN5sahA5S3aJVSK/+HxAgMEH3Qm6x5nxDcSwHNdK6SGXd6aFlsVfX5sS4pPF+iHc22v6paW9R2cwyYYAHC7bUf7s5eGhGBqTmaAtTFPGVWxYQmlfDU4xx9ZkdPQoaL+7e7sv7JW3T/YhFMVAC2r8odoit7einXV+aybaNPcpN1zUIPel1QCy2+wldoG4Vg11Y1SgulY9aRdPPCSHpRsT9RBllNqlqYfNXmAmUTXubBNaG2l55wW4TOPiAUAec7wshnBcoMfZycIxZ9ihnVLfZ90JqDjeIETIeQffYlW+NI/hs4XgAJH5PN3z/E8rd6EcNU+t7AY2VcZClGQJo5Oq/nbpIT4i3iReOqOf4gWfCeQaF0JZQjfrUP2tOkcbV0bYc9FugyNB16WZnflcjqnBYPeLxZME4y2pE3zsPjX5bgBVDzwFZ5wLo5VIpM0ECJF7N7jiKwmTAdqdPOo8T+cr3xCO9JMTnRKm8kUeowIJnggBfduP9kphr4lZJm3UQZc4b3wbtD0A17bR6vZ5haJD2tz8DknR
 +tmjdhi8
 oXZzqwYKLXXaV6mWtPp4mIwuOnr7PYV5RrzDdRUiHUHPUCgoYS0vZuFAguZWbTb1Vm+fPUzBwHtOReFbCZCZ8uPofOFgbsRGmm3EJMkO6SeAjn+W0k3oXy9YlxZZKQ70ajESR+CYJ5vtb4dvr3aye3NanpJTKj1ND6m0L0w6KjEJfqV7/EBz7fqjQc43iXhV0nvnmWZM1SVtgWNByva8yzMS44vY7vkPtvRFyapGShfNiQbdAMBVMZeb/Q4XI33ceaRWQkhCYhPR3SLpYAuERqNAy6+QnsxIiob54K4T6iJWA//oGvRNcLliP8wW/mYCRMlUx/yjrSb5qgiVPjNNqZ2oUiEibuai8QdZWGtcxMg/0YzYqy/27WLi8d2NOI/7Xjtiii/XiM/+0T04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 12:02, Marek Szyprowski wrote:
> On 01.07.2026 18:08, Thierry Reding wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> There is no technical reason why there should be a limited number of CMA
>> regions, so extract some code into helpers and use them to create extra
>> functions (cma_create() and cma_free()) that allow creating and freeing,
>> respectively, CMA regions dynamically at runtime.
> 
> 
> Well, the technical reason for not creating cma regions dynamically at
> runtime is that on some architectures (like 32bit ARM) the early fixup
> for the region is needed to make it functional for DMA.

Can you point me at the code that does that? Thanks!

-- 
Cheers,

David

