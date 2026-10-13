Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19AA9CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343AA6B008A; Tue, 13 Oct 2026 06:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3D36B008C; Tue, 13 Oct 2026 06:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3DF6B009B; Tue, 13 Oct 2026 06:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED51E6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:42:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 897CFA0906
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:42:19 +0000 (UTC)
X-FDA: 85317263598.04.5CBF2AE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id AF7421C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:42:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p4vMjRtm;
	spf=pass (imf21.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791888137;
	b=uHU/2Uy0/RB+GLNprTrACiUI5ExTnv0y5PtnHZNMt4v3PaQ0OL3LP6aiIgpVG/XVQTXypB
	tk4JVjRKs9DHZTooaMh7P4xWrvIlSQBVfIslLvyxYY+Q45VbZaHtFxJaI7CZxJ5Cv6/Wvl
	Z60fmvhm0cW3NMj6KPv26hsBbnMcLZg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p4vMjRtm;
	spf=pass (imf21.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791888137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oD+XjwWNpVZKnPMgWXiYNmFqb79UfbIuRAu6qcSERgs=;
	b=jJq6rQuo2ZEFStl7Wtm8rA2PCYJIXFES7jbb+SDzmZmZXKUNKnl/sa2uUMAMFgVGnTiyRQ
	aaHvKjagCJ57We0+YMa8CdxYuyasb/lo0WKusbFqTYjmR4p+IRr0F1YTt5UFFzw2n3fBoH
	mFyxIlLNjH+LrGZxJVj9McLPie2+0JM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53FBA169C;
	Tue, 13 Oct 2026 03:42:13 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C226D3F7B4;
	Tue, 13 Oct 2026 03:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791888136; bh=W9IOmZd6NCBQxQe8yp/0nFe31/tEy/JGEmdFhfz3Zx0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p4vMjRtm+hGJY8UPjqMDOtxJKflXmrP2vqY/17xouBvpxZsfR430vOeHQp+g4HZHp
	 i7cTDvCFclitDTgkIqF0/Rs5AUZgo0y+FddOHuWp92YB0Xjt5EVyzFCvtHFSv8ObTr
	 iK08tMyzkAMpaUd65pUDChJk7GDyTxVjCmLAWF0c=
Message-ID: <4fda41ed-741b-4c5f-ae83-e3ea5a447441@arm.com>
Date: Tue, 13 Oct 2026 11:42:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Luigi Rizzo <lrizzo@google.com>
Cc: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261003212241.3432303-1-lrizzo@google.com>
 <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF7421C0004
X-Rspam-User: 
X-Stat-Signature: roah7baw33i3ra9n167943bo96b1m7if
X-HE-Tag: 1791888137-411572
X-HE-Meta: U2FsdGVkX18A8Own4/RsSWWJ9MeOdsOnAmaR3AurDaSbzfitak8PhyMOmmIU3/lCLXBllAj5clAIIIU1lYl9sF/kDy6m03JEaz5Avm8Ei1iFEDNRJ/sdkMMDx06gG1hVOrs7T3V79x3lU3kor7PiyYB1BjYkY+Br5ZtGsIwBTfCvRgbk71t/vqrX0h007oZGZ/fk0Bv1C52tMpWxX74WgB6uiG8mDq6ob9+yt/IiS/igGQaDw83tRvd9xugaYAJpM8bp14u26RBDIf2RqLH5wW7iNhhdrPo1N2T13zpZZ2P8tiasf/JUKU3snHZbj+C/MNGLAqLWUh6dYJGDTip436NQJ7hW3F44TKtWLC2v7Sy3GZ74MU7bl+bcAtsvW8OFqv31zalh3gX3F8VZJpnSlAdIKMCIWs4HYQmRe4Nqgc0xLcatGPbAfAAigXNIbIEXdbHAi6vvQrjTmFLnszqQN7F6dSINf/gcDFFGvfypq0UYNL04ipIzvMYYBkkkBHbqRmFse1vtXL5VUs/UFW4+lCxR+pYmAorDzQFNXI2w8ehzw0uXnrL73o2oM4Wb/nxslW4GBGTXgMkT6Un9Xdhp6XhTIu7qPrjOfgaaLeuL/HpxIE6ZoV7qHKD8MGErf9yJXuRg6MrRMKxm83RLVSQcDi85nHgw5/dE7Xu+Z+gyQzWsXBN/jsvkvO++DDjRVYBgWvx3gquulwVsdelVp9d6M8WAdK4aG9eggfp3LvfENDLeMYpf8WETHKvqec23lMZ71qPumBM9pIQpPiwboBENptEbCFzFZ3H1i1nvQhcp/e6n3TroMOLaVkMjwIBIQuyllt0tNaf/d/vubhz4aYDdHI/eOR/eMZ9vhlMBvfDVOlbaw8uoWygh+xfxhIMWekdM7mBAv8GKEKzKCaHVDkNgdKhpS+ct6r/ym//j0CiQG1Zts9Xecbl+nU1xG0UL4eWIDNhxJev8+4Tltd4gYAL
 WK8tLdeE
 ROT93awjpNtnGad/k9KsamNY2uIdm9FWRrDdcGgXzeo/Lx8x4FajobNHuJLkdYrHSBYA8Qeuot0Q/k1oM/HywFCSa+NxUJ3KyibW7hXc7Ghbi5dxrcFGigVKTccbTqhljaqN9Y9BCI1XsRRWuy8isEXnv0YOLBIoA/zrlMNnMgklffW0Pftq5l4z5zLQvwXUfvrc1avSsuVAcn9omL16t96N+O9PJyFecY/auzo+8n6EprxqOkLrCm7WDR6HQKU9Fhgf3PH994kif0d75IaIokuN+ANbBnPWroqX0yNrHIt6x74ho/620y7vWmqBlbEYC4zTH0TL8q92kRu7zluvAQGq8fPMWmjYdfEYOsf516mIt+6RdS3YKBlihTvB6F6PMNoHp0c6M/878dHWgHotwFuMmAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/10/2026 8:43 pm, David Hildenbrand (Arm) wrote:
> On 10/12/26 16:45, Luigi Rizzo wrote:
>> On Mon, Oct 12, 2026 at 3:51 PM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>> On 10/3/26 23:22, Luigi Rizzo wrote:
>>>> Here is a subsystem called DMA_PMD on which I would like feedback on
>>>> architecture, possible enhancements, or kernel components that could be
>>>> reused to avoid duplication.
>>>
>>> Here is a feedback to a subsystem called DMA_PMD ;)
>>>
>>> Why is basing this on PMDs (and embedding it in the name) the right approach?
>>>
>>> On architctures with large PMDs (512 MiB on arm64 with 64k), would we really
>>> want to use 512 MiB pages, or rather something smaller (e.g., 2 MiB) that might
>>> possibly also have TLB benefits (cont-pte)?
>>
>> I had to call it something... an earlier prototype used the name IOMMU_2M,
>> but I didn't want to suggest that the design was limited to 2M (it is not).
>>
>> Aside from the name, the _current_ prototype restricts to 2M allocations,
>> exactly because too large units are expensive and wasteful.
>>
>> In the code, decoupling the allocation size from the PMD size is trivial.
> 
> Yeah, we should do that.
> 
> We should probably just find a way to describe that this is a POOL that focuses
> on physical contiguity in some configured granularity.
And since it's intended for DMA we could call it dma_pool and oh look it 
already exists...

Sure the current implementation is capped at PAGE_SIZE for allocation 
(and thus mapping too), but I don't see why that couldn't just be made 
more flexible.

Thanks,
Robin.

