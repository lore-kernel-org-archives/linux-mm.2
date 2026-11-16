Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8543606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aIT7S67W
Received: by kanga.kvack.org (Postfix)
	id 038516B05B4; Mon, 16 Nov 2026 02:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FF66B05B6; Mon, 16 Nov 2026 02:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8EC76B05B8; Mon, 16 Nov 2026 02:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAD046B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:33:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3863160790
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:33:00 +0000 (UTC)
X-FDA: 85440165720.08.AE29064
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf11.hostedemail.com (Postfix) with ESMTP id E05DF40006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:32:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aIT7S67W;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794814379;
	b=b1hSo4TuEl/pAJe5ORlnjqzEAPtxQpiWnN6UJtU/y5egmCMxj16IUTJKdj8ffYPRQroVHy
	oYyYBya++cXw8qhgwkgMYED7yYM6Ighqeje+PVUymvfzD0SF9sfUPOtO9np6e7P0KhnF2s
	qTT+TFrTsx0E1vRRlNXKjx7uSPUzvTg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aIT7S67W;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794814379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Lb0d+nlQPwj2uxwrjLTKUVhOeG90QM798BTau5rOQU=;
	b=AU580XT+e2vDezrDVXxTfaIeYnTXBZ8zrHtx8zraOFZSnn47flLgJM29NFipbAjRseUTzJ
	eV3NcHsY3Y3R3/P/+hot7OtdAMl2XexTZYR4YqoYEOmuEMjWRh0Q25MIgUvO8WqprRgxIB
	f8QHv2rGrzkJs+7kMvniXo+ULMREhcc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794814375; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1Lb0d+nlQPwj2uxwrjLTKUVhOeG90QM798BTau5rOQU=;
	b=aIT7S67WovzDeADTdzTC5uHCMJUj0JPN/oWtXIZK+F2DGHkeokGy0A1tCbRGCXVip6FSkXuyL7tGPpDFAM/OpNEI6c7KsUUTMVkuvsGTy52eAXJCB1mNk2DzQ8SyeA25WUazsJdUZooFFc9SecZ2HMfengSzapzfLImwMeKFP3s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XEnXkf5_1794814373;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEnXkf5_1794814373 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Nov 2026 15:32:53 +0800
Message-ID: <4bbe4321-ab91-40e4-bd15-6428660d8ea9@linux.alibaba.com>
Date: Mon, 16 Nov 2026 15:32:52 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: flush dirty file PMDs before removing
 rmap
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jan Kara <jack@suse.cz>, Ross Zwisler <zwisler@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261113-dirty_file_pmd-v1-1-8c11f2a2e65f@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261113-dirty_file_pmd-v1-1-8c11f2a2e65f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hfje1w18pt9ncyfbcde17ezrm865rde8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E05DF40006
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794814377-594192
X-HE-Meta: U2FsdGVkX19HY4vq1VO7W2K0AsdudhNccGPrINLvW5Y+U56MbiEZyiNSBKUFdjcSV1R8ZXVMqgnqvbHRVZLOrYDSgVX4II/BoM2qx3QDMXQJXJmKsGEt78XyNxPPwZq8RGoXB8HNsufCJMuEwmqcJFGOXT0EbDsM5kyJany9GQUtfhyzfpqvQIZsTqHmRJq0z7GcXyGsnsOMW/FAEVV9RD3STNk6hcocPx52LCDojKXsFLP7zbq5XlSZGe9qfoqy/HJQGa19MjT/lM3lvOnj1y8ZTZTMyyH++wllYZqV2cimWO7WIK0Vt5F//mlhKnvKx2RD0pp1KJr78m13/i6dc/UT1PlFfKQQlTxRY1ahAjWKBaXfpYiUjb73/c+foamepevPRJSKXvCO3vqbP00Jod0NTLgO5OrOYN1EWYZm/gAwosbq7lSecKg5EJQ1yLepbq9AlewR3364hpANNbN+SNx+q6rSF/XyjSJEWLN/AP5teo/0SDEdF1fAlUF6syB0saRSM69i4ijfHhUVElYBsqg+bPRttIAZZbefdQZvdLOTTNhsDTrL7Ab285gBDZAIZXnCCZKNwweRhffLw7Vs1bEaE+N6FykxwGnokM5Frcvx3syVdNGpIf8U8jr8lzMG97K2DdRgh2/wIDYjATtKKjVgtxKegFIp5rh5IGLyVRBuLCf4ve34Ropu0um3X2+0D8jffHzPfLuUb21VPiYYXbpT784XXdNvQOfzbUUpuRj9P44Am80RWu2PdoNQD32R3VK2sJL0vBxyuYX+SU6BWPl57/oecYSZkAnUmgIgkxO6uxGT9pOpfUpZpTA/PUN1079JHjtQXnvuZhDcRyoBT169SlkG/ZF/fQbQl5Yn8iXeZoF3t8JTWsN73tYKlb5Z5kajDoi1wdqEz8MUW56GhC91DZU92m6mUMARY93JAjLW+Ro7yE1UbCOpCetdbKTpiuKbZBTPyg7kr3Cisy/
 yk2QDvLr
 9BCcPP6SppmrNYkLUT33x1uRKyYqiFSK0rsiYCrw3p/EdRnjWtp+Qtjm3vkGSf1yvgRcFhTn3nt6zEgtxi9v/xIJe/AJoW6tiAjqx6138VhrKIh/2smB8jIhLJElNmbfkYEWYgIhj8oKOh9OPar0D1YCVoyxPG4eh/+qCnMoJpdKb89WckQ9J8J+kvYBv75Nh9HSKYzrjPam8TxdZlk+jQVmX2kbgiE2tm0fPdrjlzyi2c8aIKS0AAETKpeHkKsdr9/+tZWn6MjaOWILLHAQFIffOxYHJznBHXY3FLd68YaeEP/d3wM/UI19noTGrlmw75OXzd0yeH7XdMNPBon6SEaF4/X96VrECKSQh/AHieLfQ+YjFL6oV2wuRmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/14/26 1:15 AM, David Hildenbrand (Arm) wrote:
> Unmapping a file PMD can lose concurrent stores when it races with
> writeback. zap_huge_pmd() removes rmap and drops the PMD lock before the
> gather flushes the TLB. Writeback can then clean the folio while another
> CPU can still write through a stale writable TLB entry. Those stores do
> not fault and dirty the folio again. Filesystem DAX has the same problem
> with its dirty tags.
> 
> Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
> has been flushed") fixed the same race for PTEs by adding delayed rmap
> removal to the mmu_gather infrastructure. The PMD path still removes
> rmap before flushing.
> 
> Flush the TLB under the PMD lock before removing rmap for dirty file
> PMDs. Skip the early flush at address-space teardown, when no users
> remain, and for mappings without writeback, including shmem and device
> DAX.
> 
> Use tlb_can_delay_rmap() to share the PTE path's architecture checks.
> On s390, clearing the entry already handles TLB synchronization, and
> __tlb_remove_page_size() immediately drops the mapping reference, so
> rmap must be removed first. UP cannot have concurrent stores from
> another CPU while holding the page table lock. Make the predicate
> side-effect-free and set the gather's delayed_rmap flag when an entry
> is actually queued for delayed rmap removal.
> 
> Queue the folio before the early flush, while the gather still has a
> valid range. Keep batching references and drain a full batch only after
> dropping the PMD lock. The early flush resets the gather's TLB state,
> so draining the batch does not flush that range again.
> 
> Although writing to files through mmap is generally discouraged,
> unmapping such mappings may become slower: each dirty file PMD now
> requires a TLB flush under the PMD lock. Future work should properly
> extend the delayed-rmap machinery to PMDs and hold the PMD spinlock
> across multiple entries, so their TLB invalidations and rmap removals
> can be batched.
> 
> Fixes: 4b4bb46d00b3 ("dax: clear dirty entry tags on cache flush")
> Cc: stable@vger.kernel.org
> Reported-by: Kiryl Shutsemau <kas@kernel.org>
> Link: https://lore.kernel.org/linux-mm/aoWw_iKEDLjKL2jr@thinkstation/
> Reported-by: Chris Mason <mason@kernel.org>
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

