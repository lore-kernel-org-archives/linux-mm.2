Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83A1606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PL9O65uR
Received: by kanga.kvack.org (Postfix)
	id D48436B05B8; Sat, 31 Oct 2026 05:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8356B05B9; Sat, 31 Oct 2026 05:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1486B05BA; Sat, 31 Oct 2026 05:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 866F76B05B8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:26:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C2AFA06CD
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:26:50 +0000 (UTC)
X-FDA: 85382391780.19.EE93D4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4422E20002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:26:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PL9O65uR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793438808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZHGBSOTjfIv5psqYCswThHtlgHtRKk5pmgDRNFcrfM=;
	b=hfodGk096a2Dzt6C2bBUFqWjxRBSH0qeVnUFIC8lIJxzsQwWWrSPwc6DTg6TmZ8tSwKq2C
	0eaIPjh7iDzNNrBVBiGjNMteE3ccOEkXPUSQZ9i3pakTnxTjQlYWRmiJKScqDyqNWbL+gP
	vjzK6JSOIcy4PprP+bRPYQRBZfkm29Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PL9O65uR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793438808;
	b=DtUYpb0xsSELj8BgEr1nhyO9o94k/XETTA+stzLxf89Uv/S8+OEwYFqIxIjLap49fRS32r
	QGAsWCT0v7G1Dc3Lh2lvKU1mM9wobZgPIdAfsS9sHwL/eMDukcRpAlu2xZrOkg4Dj0mUFp
	zHvOUDz9g09dunR+qExpNgqaUX7p+2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73E2F43EA9;
	Sat, 31 Oct 2026 09:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C321F000C1;
	Sat, 31 Oct 2026 09:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793438807;
	bh=hZHGBSOTjfIv5psqYCswThHtlgHtRKk5pmgDRNFcrfM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PL9O65uRUsVqqbO5z6Qc9D3FBxeq+LSLgFia1VPxxAssQjeEyF/VF4zk6XsaqHS6W
	 +Mmb54Mrhh61NP1Ci/M0kDXoxznptOCmEhukvScWb553QC1KstG3qLCZ9a9mrxr3rb
	 jLCOhc8ibmw5mpm6LMuggjEVITVUVXSCDu3ovO4Qrw5CCRIweTB3BjLUhjv0dpJU8e
	 KpokjJwBJxOuWQV9sg7rOHEDQfc8gSIDKlyaaM/iu1iLl+fjvS+QoNGm7kHJsZiC/g
	 HyWQB2zbKJIfsth4IIRi/ZTjbfA83759x5FRmyfy58xZ1PTmcYg4W7Ql6Q8jhe3m53
	 uFGc2Yws5griw==
Message-ID: <a0c32d43-c948-44e5-8802-b64d6fbab8de@kernel.org>
Date: Sat, 31 Oct 2026 10:26:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] MAINTAINERS: add missing files to MM component
 sections
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Matthew Brost <matthew.brost@intel.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-5-97278f8a5f54@kernel.org>
 <auWwWRcoNhuuDOY5@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auWwWRcoNhuuDOY5@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4422E20002
X-Stat-Signature: gj3nbeygp3w9p1ubk4zw9mw3qaua36gc
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793438808-798877
X-HE-Meta: U2FsdGVkX19EpKi8IOjteJoLDJ9hYTt6ZaqyCf32n4SZHhyJ07/YhyejsB79VXIc6EDp1FxseQJ8opEgVe23/wOKvVkFSqC2/2WZU731hpuplLvEVrN3DCEfyzmhfn0zyK9l8rNNcb2093wk+4xJx7E6+48DPF3ZUZXrTB7WYk0XnOHs4djyfzuXjT5wg6FaYp0KzZUdpQRq5nHIT5/FNHBzH5pON0WFxyYK84SzIsgUL9i0AHWxwlvJShDc3VHYk0XT3KZcINSnQmGlDBNBnL6m0zgkt1mI4MdxmhUbm9xPJFAgrWpKsVK+AK9u/M2UBgKWZjJgn9NDocULb2aFhXQo2rwZsCi2nSvxPt8rDwDMzlOGezQhUUEAPRkJtQeNfaU33XkPDMRagbQHUmg/iSAq+Nfh3bp5V0l6XweRLcy8BQ86wbnab9z+DPXgypsBQQ4jatSiuhLFdv54k4PJOhOW4J3NLKn6bmtFF10nFUBHLLKBR81moJ8VH8jlO5sNciJrV03FPYbIFrhRpjv+Gk10UHEiVcfzK1qaOlIfGSx2o4kbBmNbz/UOQ4Qg9Z7FZ9hLuBXMBfuX7R8CUcE6Xeoreefem3r6NK/ZK4b3qiEgpJ2Ab1RllYMBNuyt60/zNbGTqhOSuJP7wNLVgvgFcVJJiX4Ca6gYG2WMPJfctoPCxRpb3h8XNf93QkkzB5F/uTrx3bBBLGbjcF/lTrUwQkupLWchogmyc4r5RyQHLjCCCgM59bkscBUEV7vPdYiRIQm5of8xugciCudU0XUkI/1RL8CQmDg7dl+XqS/JBXTxsHCZizGnOz2FIzr5gXCJVatYXj9Pl/zurWKToloFCGEijCYgClMp05QwtKWo26kShrzTOnk70sr8q7Tzw/dP5kZ+GRE3NrWJ5AhswOJxx0qVDClgJSG0U7WKSQd6wdjlQ/5iZ/G5Lcv9/DQ7+76+UmRgQmFMCr0R+2DAMki
 OhRgGo18
 T4AgYk/Psu1EU73OgNc7N1Hd/dMgPCkuU67Peelb7tk8DytOst98EVXxb62fs72nTD+ND/jsG5TehTdHomxXEVudKJOchB4N1usPN10zGjnPPDKw8WOHn+7ZKvpXMfoYExo+n6/gpnMwQkjtFEtplAd8fiuh+CgGakEVm4+eVujzM8+A6+hN6vXXQ6yEhDKs/sO4+5+TqW3hEMJImQIMniQzwVgK6uEpdpSW9awvopqQwduLuJKhf91vvXogny5R8ORxq8jVF6yRq6zdOb3ZkvHBcLFfaQFn56fvWBC8rwxivdTnnsOcdK4/dfjd7Fsg0F3t/sfwpqfY9FsW7dVdtVb0F7K3onO/S/Sc6iuLeprgp0GM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 10:23, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 30, 2026 at 10:34:29PM +0100, David Hildenbrand (Arm) wrote:
>> We want to make sure that MM components cover all relevant MM files. The
>> generic "MEMORY MANAGEMENT" sections will probably go away at some
>> point.
> 
> You mean MISC or the MEMORY MANAGEMENT - prefixes?

MEMORY MANAGEMENT, the context of this change :)

> 
> Latter are useful just for tracking what's mm in general I think but I guess
> debatable.
> 
> 'MEMORY MAPPING' of course breaks this rule :P
> 
>>
>> We have a bunch of files that are not explicitly tracked under MM
>> components. Let's add these missing files.
>>
>> Split up tools/mm to the appropriate components, but still add it also
>> under MISC, similar to what we did with selftests.
>>
>> Don't split up selftests for now. They are covered by MISC and some
>> sections name them separately.
>>
>> Some files like
>>
>>  - include/linux/numa.h
>>  - include/trace/events/kmem.h
>>  - Documentation/admin-guide/numastat.rst
>>
>> are a bit fuzzy. Add them to the best fit for now.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Nice, finishing my work for me, I like it ;)
Thanks for getting the ball rolling :)

-- 
Cheers,

David

