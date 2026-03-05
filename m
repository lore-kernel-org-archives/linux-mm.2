Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E87EFCE5A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 03:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54D26B0005; Wed,  4 Mar 2026 22:22:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7AE6B0088; Wed,  4 Mar 2026 22:22:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3626B0089; Wed,  4 Mar 2026 22:22:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB176B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:22:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48DD51C30D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:22:11 +0000 (UTC)
X-FDA: 84510560862.28.0F3589F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8C5631C0013
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:22:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQqMSLj1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772680929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gus2TbXg7gV4yotO25GDeDjmZGlpM2f+fKw3//D+yIA=;
	b=r0WED2FSMncdJAamQTMCnEagYFB42LChLpJTCZRgOAFiCfcAmazDUoFvwaaOiUYUUcVUdz
	kiFwlp07rrMpp1YhlIM/A3EOHvSB3ZU/hJ586ez7TcKDTWLthGgZvLmrxP/20dH5oqV8aL
	J98SRgkzU2sv3DP5UdVlTBBPKTZ/VLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772680929; a=rsa-sha256;
	cv=none;
	b=R+X0wlU7DB24OMZ5PxzVAGSDFQXM7QvziSKH+kQkNJz4OTwkEDD2DD67JeDiTWD47QQxET
	nz3QS7yxlxhW0CQliegwytRH8qgfO4PTwfoBd0kwrt7ewOvDplmtjp6jU/79ncHqmrdlMW
	YmYxFyu/JGOhl+uIxU/3uEwyPkni64I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQqMSLj1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <7ef528c1-b09c-48ba-bd59-bcf13880e105@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772680923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gus2TbXg7gV4yotO25GDeDjmZGlpM2f+fKw3//D+yIA=;
	b=nQqMSLj1tjlyJYZMSeOMcrUjLwkiQXIkpZMDbTxUeW4EXdyaALv/totjOTniIeC6JO9Tb+
	nN4dIP7ddh+mLx7p2xWqLpogvBGLmHMhocAyCiCv1LL/5YNEFVmKuNVnJMPakmyrjRGUCl
	GUGWZtENkEFZJXNvmDPtIT8tN+UUHNk=
Date: Thu, 5 Mar 2026 11:21:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Andi Kleen <ak@linux.intel.com>
References: <20260304155636.77433-1-david@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260304155636.77433-1-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C5631C0013
X-Stat-Signature: 9996nmfet6hmwiwooy1x4tb87s69nomo
X-Rspam-User: 
X-HE-Tag: 1772680927-829833
X-HE-Meta: U2FsdGVkX1+pRvodpAWCwGigH39JfVlF/tgsMsuv+yBWL5xzVNcz2eNPsFkx00S6lxdSwLJQa/EoqLumNE8PJALEvfAl74exuaboQfMM4s60LrgfVXyVbqYOQBdWI1WHPByLuHErKXdcgTl9ektw2tq+DW03VHsudei4fIRGUm7/aFf+9xF7Jat8p8dsxdmdfXbfp2Vf0R/sOGeRGQxvPe2EEaAXQxSaiaP9SMhAQLD0Zmps4xJ/Mm4gy68COO3u8ya1xzlYomx90KNit/miOHe2g784Y0c1sKa4l5l8BYWPr4uOBHgmBVDFD5RUjyooA08uUqHxxmlYb7E/9piDwRbFaTEi5SVgtJiO/tq6HhE8xT6HXDPLSDaHb3GxhHZpt8S90pH0c4yYFniI4jXdUOp795fhYZo5C99DW1MS3Ge8HypoMsG/OvibwuzqEzYhsjfQLlZhoV01sh+P2HQxtiZ7katQ5GI1L3H+EfFZeHAWpSoon2dtGK1bo6z0Lil2dic06f6HrBCYeQw2BIGP/0TPxVapxBMS4Ji1wiE0vtRJqc5m1g7WalRBIocCqDf2JMl3l61uuZAsANSw8L0xma1pA4KS/6GFisUVSNoVxsSFS3MNoO0i+MSz8HyncIj8jczwOhr1cy8eOPfRwQ6IBMIN4gIqK5E6lR2D6zV76rgXkjrqGa5v98/kHaIufecbf/GUYYhCjo2jwvNX36VtEfozXCCw1+6N0zw91XF3RX8YPy2PrP83WxUi4SoiY0odqt08t6Z5gx/lmb6GhpkKL6RH6lpFrZvhgoSXz0nO7sSKWKLTPFZf57hkzF3iXpZr529JuJevJJggj0mF5x0zjDFridUsjPDGAQ6s3G7gZN/BpwBgDXBHusMrZ8E3kE7/F53WdhN07dA+3UtRBhVklWtwUMjEwpE/LAMW6H6OxdAXVqAmaPPA+h00GLZCcYc5GIvGpNpgHaU7czMH1xf
 uV6fs0Yz
 awzWUh3Ektz/j9emNiLeSSUnkDedHV8Kfi3k+sfacw+qTTiE23PNW0KuE9DiAxJYz6l9sJ6NzbkbmhaxxiA2OwSY+F56T7i5YbxWd+6w2Oba2SO66uoIMJ2X6nC29OaThrDb8WiTZF6BHLGeykvU5N1shpR9jixdq9xVXho5mv9zF1xKdlgmOjUt5cJR2fxL3VW2bRegepSGq9Fr4VLteRW22ODxH7td8xUgYC73tanZzqIy9x9RrkcUcp/ZCUM2QAYLjJgSBU9qOJDw7JSaQ1n+675SzkkMor6cPShDZiXb/XuYhMjQXgfnqZqDJGNTC6N1Tyh0I1yKnlmZMJpUhz2dH+LRuynGvOv3dFawtbrLLYcv4i5/GbgNC6DSIHjp4E2CudiJcMBp+CjrF4P6KE6xVqBq36LCsT941heU6nViB3gOTptImnspPzL/wKghBbyu11WoZp7Ly69wvWmHVejg3D8FA8z5HEt24mfD9Tb6sePef+eJVSCp8q3ECeh3Of2egvqisuKput234+vMWjF6zl3Klggywrn/R8+1FbUDNv7Ykt/xE7J5sSgiNh0KHKwYQgRtxYOtl2JpgmUlD/Dy5Rjy4gDrfm1mX05pyBKFcH6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/4 23:56, David Hildenbrand (Arm) wrote:
> There was recently some confusion around THPs and the interaction with
> KernelPageSize / MMUPageSize. Historically, these entries always
> correspond to the smallest size we could encounter, not any current
> usage of transparent huge pages or larger sizes used by the MMU.
> 
> Ever since we added THP support many, many years ago, these entries
> would keep reporting the smallest (fallback) granularity in a VMA.
> 
> For this reason, they default to PAGE_SIZE for all VMAs except for
> VMAs where we have the guarantee that the system and the MMU will
> always use larger page sizes. hugetlb, for example, exposes a custom
> vm_ops->pagesize callback to handle that. Similarly, dax/device
> exposes a custom vm_ops->pagesize callback and provides similar
> guarantees.
> 
> Let's clarify the historical meaning of KernelPageSize / MMUPageSize,
> and point at "AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped"
> regarding PMD entries.
> 
> While at it, document "FilePmdMapped", clarify what the "AnonHugePages"
> and "ShmemPmdMapped" entries really mean, and make it clear that there
> are no other entries for other THP/folio sizes or mappings.
> 
> Link: https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Makes sense to me. Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

