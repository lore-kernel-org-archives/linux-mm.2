Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99098606A327
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YsyyzjeN
Received: by kanga.kvack.org (Postfix)
	id 9D6BC6B05B8; Fri, 30 Oct 2026 09:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987966B05B9; Fri, 30 Oct 2026 09:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F876B05BA; Fri, 30 Oct 2026 09:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F50F6B05B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:10:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E621A1406AB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:10:31 +0000 (UTC)
X-FDA: 85379326662.04.A90A51D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A2B8D14000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:10:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YsyyzjeN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of mason@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mason@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793365829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIsmxaqlcIiqqe+DfpItRAhgOJbkWsY0ZSYuASH2dgo=;
	b=SyPN9D1GGzLmQGjjKxpxfrR3XEw0peK8f5RH1wXbp3iy9Sn4I5gzPES9Y4MJVwQKZHEjQ0
	9beG9q5dnjbZC/M14jWPwCzx9XBEGjuRCf8D6LJfGQQXaCOq8cusSPkSUTy6YqAKrvXPxO
	ZW9e85nOW3D/hGjfBSe6AXeUz/TwPSY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YsyyzjeN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of mason@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mason@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793365829;
	b=NJn4yQXxU32ZxTVKlYLhmVRQ6ftBKC1L19PkHDFLtSkWdD2eq/z4JJMC7RPOk5CzE99i+E
	/uLk6wPfsaoUyDWzqFP977/W4RUWYPyBR/9T93pOAY8lsfuyn5TuZ2xzIbBValmhmYibCL
	mbnEEIWj++B3qIuKIQbZxIfiDWGWlmE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6274E43D99;
	Fri, 30 Oct 2026 13:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555F11F00A17;
	Fri, 30 Oct 2026 13:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793365828;
	bh=BIsmxaqlcIiqqe+DfpItRAhgOJbkWsY0ZSYuASH2dgo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=YsyyzjeNSnn4NdzV/HZ1aXH97z2sULKyBNgRpsULjLOkSAQDdeytR2rt6JKIWbX8J
	 NJKISnwg3GlSJV3alLWBM4FViTUd9AZ9ts7gDpSfUHt9u6eAOTkf7G+2Bx99txUbNF
	 bnOei7ODniDRJ2cFOVbuIBOH2v/BFY983Pe8eoid3RccWmS+FTBnhaMBd53tIKGmkP
	 4nxfbqnF2+s3l94S1LoBzcbGHawvowUeYUiswzeN+26Z9oHUTIiFCMa0KFS6713jYG
	 oweCHkLxnh8kCE8Y6mCO0HSMaa+n1A6aEPEzMMMH8UJ3vAgvqzm2v2Yx8PoRS7c04j
	 0JeJa72utHtag==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id CE537780068;
	Fri, 30 Oct 2026 09:10:26 -0400 (EDT)
Received: from stl-imap-13 ([10.204.2.104])
  by stl-compute-04.internal (MEProxy); Fri, 30 Oct 2026 09:10:26 -0400
X-ME-Sender: <xms:QpfkapuEEiWvnYkAbvGo9ysv-v7TBwkorMqKQptpbuZvqzGbgFpqaw>
    <xme:QpfkatSLePC3ZqpvsICMdaVZjgd2nhgN4ac6cf3pKUOffOW26FNBeCG8_fYEgYJks
    1oDFRvVjNMpLJe4U41lyostVUROS_e4ktzdeJ42JhubFzZVSSlQ>
X-ME-Proxy-Cause: dmFkZTG32OlWsLwdAtEeDvbuX+kS2E5ZrJYjCVos+iJYpUWXUV6VRMoUTSQI/F3gDFUlRY
    KlT8DJ1rPfzYkRdcG8OMi2tRmlDRQduhPo40avHI8Knf3VizQC7DRrLMNWopHbifd9Q5yw
    Dfyt4tg4BeyURi2mWO8CklDoMyO4B5PvTL/7aeaUn2VjiCNmJAZOiXHAVOQFnXzJC7stSy
    W3WIWdyjaIM+fWF84Mb5rjOroqXFiYJKoECTBlQrhYOUL5+mZw5DpUDGIBIiN4lguaLkyt
    oD7NTjmN2T9ahci9vRKn3bmV0FYLgkDHndh8CJE5uh3AcBuG9Qfg+/PrXIPS+nhvc0mBKn
    Us3Of1fWwQvi2VOdBEiFV2znZy9clT1YYWRLCh2nzSzqMEZqQWClKk/ADQIDzOEW/zOfrH
    9aa2S5JZSjmFO+Sn5dtx6Uz0ETZ51ia3mVU+79WvFSDWZp3onwYSGSqUMLeRBIACC3irLb
    u3ZAjQZOkZnMl8uauMeXF+ERqqILy6gSIbDifjRYLE4At9wbm3jgeIgMw0milmp05ICC8I
    3h6iBm04QeHqE/6h0irKtOVnTkCdS1rHGA4yw6CQAp/EFDNNNAfbo12eSejrLAg/pAM48W
    Yxgehf1goIUqMKABNyfPFy4Xqy/kOgIsFbfgl1056pYO+75O0d0RiObwsfTg
X-ME-Proxy: <xmx:QpfkauzU3e0Iazb18MDpVj0fZLYl2dQ0gY7_TiE8LkBBqeq1lOZHXg>
    <xmx:QpfkakevNXYtxmHt6UBCUoFoVZQZhjRRt0-H5a0Et2i62eZMFvnTGQ>
    <xmx:Qpfkak-Jq0AcmJBn79OdZVfkM1GrOWoRJZ8l-K4Jo49WxZ63wlsMCg>
    <xmx:QpfkalH5l8KlnQnc64yNFR5h5-AQGEc2IdNz8x4ZquC_2G-el7oiHg>
    <xmx:QpfkakQzlxrhr7RCrmHVYQkPkq4zpY5MHsFRDcycffuj8EJXrDhqm9Sm>
Feedback-ID: iccae4b50:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 59AA0F6007F; Fri, 30 Oct 2026 09:10:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: Aey4jMk1dEgs
Date: Fri, 30 Oct 2026 09:10:05 -0400
From: "Chris Mason" <mason@kernel.org>
To: "Muhammad Usama Anjum" <usama.anjum@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>,
 "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Kairui Song" <kasong@tencent.com>,
 "Barry Song" <baohua@kernel.org>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Baoquan He" <baoquan.he@linux.dev>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Kees Cook" <kees@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
 "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>,
 "Hugh Dickins" <hughd@google.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Pratyush Yadav" <pratyush@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Zi Yan" <ziy@nvidia.com>, "Lance Yang" <lance.yang@linux.dev>,
 "Rik van Riel" <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>,
 "Alistair Popple" <apopple@nvidia.com>, "Nico Pache" <nico.pache@linux.dev>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Usama Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>,
 "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>,
 "Will Deacon" <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "Nick Piggin" <npiggin@gmail.com>, "Oscar Salvador" <osalvador@suse.de>,
 "Minchan Kim" <minchan@kernel.org>, "Muchun Song" <muchun.song@linux.dev>,
 "Xu Xin" <xu.xin@linux.dev>, "Chengming Zhou" <chengming.zhou@linux.dev>,
 "Chris Li" <chrisl@kernel.org>, "Kemeng Shi" <shikemeng@huaweicloud.com>,
 "Nhat Pham" <nphamcs@gmail.com>, "Youngjun Park" <youngjun.park@lge.com>,
 "Gregory Price" <gourry@gourry.net>, "Joshua Hahn" <joshua.hahnjy@gmail.com>,
 "Rakie Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 "Josef Bacik" <josef@toxicpanda.com>, stable@vger.kernel.org,
 "Thadeu Lima de Souza Cascardo" <cascardo@igalia.com>,
 "Mani Tofigh" <mt4022@columbia.edu>,
 "Samiullah Khawaja" <skhawaja@google.com>
Message-Id: <ad0d82f5-c2ad-46d0-986d-94626faac1f9@app.fastmail.com>
In-Reply-To: <bc8c1fc5-4620-4515-8520-22ebcd0d592a@arm.com>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <2f23dafc-43a5-47c9-a819-e696cda6fd44@arm.com>
 <baeda061-e0d0-4be1-9aa5-8886182ca83f@kernel.org>
 <bc8c1fc5-4620-4515-8520-22ebcd0d592a@arm.com>
Subject: Re: [PATCH v2 00/47] mm: various (urgent?) fixes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A2B8D14000D
X-Stat-Signature: q8afpxd1sxhdgepz3ookqbnwj6be7nuq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793365829-1217
X-HE-Meta: U2FsdGVkX19K1G73eUctgLgO1E/nmrftDugHqQPedwYMpDxCn5wAWAp0DX8wWCwJ6dzo988yAXvH8JCszCs76ThvB7I/XghM5oZmq/yAK4WapoDURx3NIoePUYlHT6C9pAiNirkij8snwHzxGmyOvqdW/bae6jIjBDd1rta0lWAqZmatMPpCFdEEPKtLNOI77qYfN2lsG98QAVXJTLrYxuIfpz9z8BM6izVmXOTrCpZsuBlHsN3YhqmT/oqwuaE+5HqSokZfQBhxNHZqq52WaGd4a4jTs/03jLssc8doYZaJc7IK8tLlVJmi6eILenJ3/W2JDZHJ1tC9m10xT657osA57KJ3g2CgxJaQi3faA+tqB6hX+sltz0kPpx3CyEbTtfhZ6qCN3FLe3O+jXUQFQ8+rZat+UhcO0ILkyTxevcZHyqw1z+1rR1xwzrw3sRkvmgJinJFQX0F9w/0QgcZ9e/KK4JA/b1HNrTyjJ4bIFklXooBpBPIwT+Rp0AekDOI1gs6+ZZMm3EiC9NDK6DTrU+RKDy0z3USzd2GbL79VhdGadtom6gI/EayhhKdE62KRjZIf1aeepfIQuPQt1jU8R77Du5XzNxCx6kbb7ifVWMGYinR2P2ni0Dwt/RAGKljWEsHJccJzxy9ZSye44BIxU55rTM8PgoQZ7vWQZJd+KC35vbymZO6OIZ5uaxQE2frGuqnOy/jPVpPoiee2k7FIDIqR0vsOcQhfJjekR63+e7KtkNuq9zPvNwU0L610JGwTOGGstNn7wbZbYx5Hewy+lAJT7QBJwRMWVh6qp77uJKhNdGSGmiUCArP01QEj/0pSBtrzvcX3aTsxR3i5YTWrsf7x/jcThPXhJ3187XUbaoyh+yjKZL5+fapJfRZolS/mQn3g2BVYrVOiFONT/JLrFDkP+PmV79/FJ/yufjpCeEGZFHPtmKEP1hwHMwlmNSHtad0kcAeSQH1EAfLMPbA
 DDbd4ctC
 kXJ79paNUr20s6EEAGPyfPyHNFRZSWeSQJijAelDpMwkY3vEVovtJzhYg/Vebai+77Bndy78oc12yXkOllk+ilr3CdYl4iJRRFDqYJ9MA4zh2IQyBrehs0ML3BwZ/D3VjB15qiP1iM7BS83J4J7Z5qwkVLk8V/haYDic1+ygFSr/xPIscFbY84CugTIxZwux8G6Zs9BeS/fk6Q/GXd1X9tcrIni1apqZyKz/MxRoIh8JWCBOERL6mT6IeGLY8xc4pLm7pbOZJynn0bBGT0l6V8fNunKdm8Khya42WbvdSdblaQ3ITLR5g3ytkyKv0xL3M05l5EZhGhJa4tLMdvfTSbf/ELDFlH5kdYLd3b+fr4/fjlpJ4vDyJNFbP6OeX6rezEg+7ZaieDJ6guJLObTHrp9QZ2S2n8jvLvsh2V1uqKuHLE3J7HPP8HD1wMpr+oOEC4YhecJCm3txPKunqLriHNCnIZsRbzUQE4pqc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Fri, Oct 30, 2026, at 8:12 AM, Muhammad Usama Anjum wrote:
> On 30/10/2026 11:35 am, David Hildenbrand (Arm) wrote:
>> On 10/30/26 12:19, Muhammad Usama Anjum wrote:
>>> On 29/10/2026 8:32 pm, David Hildenbrand (Arm) wrote:
>>>> See v1 on details. TL;DR various fixes :)
>>>>
>>>> Thanks to everyone for the review! Hoping I can get some more? :)
>>>>
>>>> I am planning on picking these myself, moving them to linux-next fairly
>>>> soon through mm/core.git.
>>>>
>>>> ---
>>>> Changes in v2:
>>>> - "mm/memfd: check for real shmem inodes before accessing shmem state"
>>>>  - Call it inode_is_shmem
>>>> - "mm/truncate: look again if a folio left the mapping"
>>>>  - Different fix for truncate_inode_pages_range
>>>>  - Adjust description
>>>> - "mm/huge_memory: fix zapping migration entries for device-private THPs"
>>>>  - Move handling in zap_deposited_table
>>>> - "mm/mmu_gather: fix flushing ranges with 4 GiB or larger"
>>>>  - Adjust description"
>>>> - "mm/huge_memory: split huge PUDs when adjusting VMA boundaries"
>>>>  - Drop split_pud check
>>>> - Link to v1: https://patch.msgid.link/20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org
>>> I ran Fastpath, a Linux kernel performance benchmarking framework, on
>>> this series against mm-stable on aws-m7g.metal. (I) and (R) indicate
>>> statistically significant improvements and regressions, respectively.
>>> The results show 10 improvements and 1 regression. Other, unmarked
>>> percentage changes can be ignored as statistically insignificant. Hence:
>>>
>>> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> 
>> 
>> Thanks for the results. IIUC it's schbench that shows a possible regression.
>> 
>> I would expect that no changes here really affect performance at all (neither
>> positively nor negatively).
>> 
>> "mm/huge_memory: fix list corruption when deferred_split_scan() races with
>> deferred_split_folio()" fixes locking, but I wouldn't assume that this matters
>> at all for this benchmark.
>> 
>> "fork: take mmap_lock before copying mm_struct" changes locking, but I also fail
>> to see how that would affect the benchmark.
>> 
>> Maybe some code layout changes just affect some benchmark on some machines?
>> Because already seeing 10 improvements makes me wonder how that could possibly be.
>> 
>> So I'll move forward with these fixes for now and see if we get more reports and
>> could identify actual problematic commits.
>
> Yes, these improvements/regression might be because of code movement and how it
> has affected the run time performance. Most importantly, these results show that
> there isn't any drastic affect on performance. These fixes are good to go.

This schbench configuration is going to be really sensitive to process placement, and it
should be doing all of its memory allocations up front.   I haven't done many schbench
runs on this type of hardware, but I'd agree this result shouldn't indicate a bigger lurking
regression anywhere.

-chris

