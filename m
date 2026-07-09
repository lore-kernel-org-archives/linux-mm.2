Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D363CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 05:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486696B008C; Thu,  9 Jul 2026 01:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FD76B0092; Thu,  9 Jul 2026 01:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE566B0093; Thu,  9 Jul 2026 01:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 040826B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:56:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B9561203DD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:56:55 +0000 (UTC)
X-FDA: 84968179590.14.9428C50
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id B346680003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:56:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=YG6NrUKP;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf30.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783576613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zn1dtIX1zk4qdGW1lihLluLd2XJtl/1EEzMzw8sXVc=;
	b=mKFU21A17I64zFUZW1f3b1lAeM/ROHrhMar2hAYQkdxDGsHMxVjfwWLWW1BmmzCgfMAtnv
	3CI5uYR+Av+pb81Dj+FHsdUR956bsrbs/GY4YYJBg5xZCQHuyV90wPRoW6IRxbfL3/qreV
	NLimsRDilstp5l3Vw3vZ4tbLCcSUqTI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=YG6NrUKP;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf30.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783576613;
	b=n4vXhbqRcqSb1AYKcdxW9fH5NTykTMP83TEechxM69hq4A4k8B8+wxFVxwA6z3ndbkSV9/
	jBPcW3bEHjt0afGTXqm+pSh0VtbjO9mJSSgBDL8xmkQMNqABuyvn4Jc3VPEwQ9IKoKRd49
	2Y5/D//8hcxDjw7hOzaKQQ9N+tiJIC0=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260709055650euoutp025a12a0c6f53f1597c081fde8840d680e~AiXozFXMg0222702227euoutp02U;
	Thu,  9 Jul 2026 05:56:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260709055650euoutp025a12a0c6f53f1597c081fde8840d680e~AiXozFXMg0222702227euoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1783576610;
	bh=0zn1dtIX1zk4qdGW1lihLluLd2XJtl/1EEzMzw8sXVc=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=YG6NrUKPsBwqBvMGbjU5xWHF+nu3KR5nOX3x74qWn9o7ulsLODQrO0+6rPDBK/gpN
	 1aWd1EwavrpW47dURG/rZPG1Z8lkEaDbZyuKetZ8FW+4NfqXLobtjcACnZ9jgKwdIK
	 6ZKTeq786aUMJpm83Q1TIX+j/ImTlbLRjVWgi5yM=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260709055650eucas1p215ba97832f0fed53c1c322ecf192ff45~AiXoi0Jv90198801988eucas1p2U;
	Thu,  9 Jul 2026 05:56:50 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260709055646eusmtip2b9b69a8f7af4b283ece88d085252d254~AiXlAfqwT0885208852eusmtip2U;
	Thu,  9 Jul 2026 05:56:46 +0000 (GMT)
Message-ID: <83e5e74d-7106-4e14-9d10-56438372f6a3@samsung.com>
Date: Thu, 9 Jul 2026 07:56:45 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
To: "David Hildenbrand (Arm)" <david@kernel.org>, Thierry Reding
	<thierry.reding@kernel.org>, Rob Herring <robh@kernel.org>, Krzysztof
	Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Jonathan
	Hunter <jonathanh@nvidia.com>, Mikko Perttunen <mperttunen@nvidia.com>, Yury
	Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>, Alexander Gordeev
	<agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
	<svens@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo
	Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
	Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
	Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Robin
	Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey
	<Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, "T.J. Mercier"
	<tjmercier@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
	Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org, linux-trace-kernel@vger.kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <e212caac-6c30-448a-9e10-32fff8b842f6@kernel.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260709055650eucas1p215ba97832f0fed53c1c322ecf192ff45
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c
X-EPHeader: CA
X-CMS-RootMailID: 20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
	<CGME20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c@eucas1p1.samsung.com>
	<20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
	<3f47aeab-33b1-4966-a5ce-5d6d5261e0e2@samsung.com>
	<e212caac-6c30-448a-9e10-32fff8b842f6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B346680003
X-Stat-Signature: 8qb4y3y559sfyh393yh6cz491i7ddw6n
X-HE-Tag: 1783576612-171860
X-HE-Meta: U2FsdGVkX18gzy+wn00CTXDtSThtbYPanJE01njf+0+HJVLPrBL8zuuLOAjwrwLH1bkZ27dMNSSMZTC/Du9Cedz0P0c7LVME4yS8x83PV3mvisWaDrV8J2if9faiNBRcovFNvc7cSwXdSaCeiVE574Q0vXVMx58Tf9s1grCgNRaMuOofgW1fwwL8S4jfiNz1yl1scO/mQXDe89DxulwjvPWvfWIL6Jef0yRlRmzDwHgzaYOeTK1/KY1YXdble8qm/+pQoGUxnGqUHNHmjxXcx20+SxnFGLGS6KfImqyJRaF64uL+2fsyWXA46DXHRR6C9Do0FH5y86AdF49LoPxrWYa5Rmgq7yeUSZnirfmv6pv7VfR9LzaT7nDEg9hIWTZYqTrfV9NBMTWtxcCLx9joWD6lSgrvAiqclRGhdSjC2PmmuWe6n8y4pKeaMnXI2wQemWTm4ZvwEqTokL2+i0Wb+D0ayXi83JM47x7AwgXf3pbYZ7CKN8qiP1pBgH/UwcaF3ZRmqGLiNCnRVjI/7PRkZ89ZNFQjOq6MKHnO5syJM4K8/Ny7IksIMAKHHRfgsrFtgjWTj+GOpU2IsXxKtqxXduYX3233cWehgXsy7O6QSnLguKKNWmoFTuZG62gvTIbJrgk3ZPWJU9mgXA2aWJ905lqbWVOydVE9XwjJOGQIHOwLBoV6FBTgQi237tGYKvdMWC+9MtF1FiUfNpLkxeVQNaJy5KuLpHtRdbJlwnYdisuGR0wzv0wfDSan1gbe3+tCk8Jm1a1Uo77EnXZu6g0b2Z3Tavcef4fVZ5blWbdbdQnBnG5AonuIXFJ4Olh1O1S2YHD/GMZykW2M8ZwgIzjpEZKMIvfnJYqzjmY5eT17rujRDlxBeV7+ssiX587d484i76ot7BY7HONVOmbyfKKn5DeZo0lhvMNVxs+ZIbXPfmS1gpnjgpbOnUO/MG8HcciPHSj1v0oAx531zjEBlNY
 97JHxxfp
 87SUE2i+yVaekX1BgAzvlKo9Ou/+bvqk9Ls/kUPlo4SVSAFVcCBZ2Yk9IeWtF5dv1ENqX60l4gXD0eRKZkxoNfU5V+rZTjtReKZmZocmsax/Rjp8Nq/xDS1tqiaSF8XyiW3wQLqk9eyybG4GdFx4eVuLFG7+2DVHqOKHqiJBa5FrRJeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.07.2026 10:35, David Hildenbrand (Arm) wrote:
> On 7/7/26 12:02, Marek Szyprowski wrote:
>> On 01.07.2026 18:08, Thierry Reding wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> There is no technical reason why there should be a limited number of CMA
>>> regions, so extract some code into helpers and use them to create extra
>>> functions (cma_create() and cma_free()) that allow creating and freeing,
>>> respectively, CMA regions dynamically at runtime.
>>
>> Well, the technical reason for not creating cma regions dynamically at
>> runtime is that on some architectures (like 32bit ARM) the early fixup
>> for the region is needed to make it functional for DMA.
> Can you point me at the code that does that? Thanks!
Check dma_contiguous_early_fixup() and dma_contiguous_remap() in 
arch/arm/mm/dma-mapping.c. Those functions ensures that the CPU mappings for
the CMA reserved region in linear map are remapped with 4k pages instead
of the 1M sections, so later, it will be possible to alter the mappings and
change them to coherent when needed (altering 1M sections is not possible,
because each process has it's own level-1 array even for the kernel linear
mapping).



However, in the use case in this patchset the reserved region is only shared
with buddy allocator by using the CMA infrastructure, not registered to the
regular DMA-mapping API, so it would work fine. I'm not convinced that this
is the right API to use for this though.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


