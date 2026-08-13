Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCADC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959BA6B05B5; Thu, 13 Aug 2026 15:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932996B05B6; Thu, 13 Aug 2026 15:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820476B05B7; Thu, 13 Aug 2026 15:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65E2C6B05B5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:35:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97674A022A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:35:57 +0000 (UTC)
X-FDA: 85097251554.28.6493657
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C6113120003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:35:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CwgT9Ht8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4uVpG3bdbrTSkcePR6X4sXWK4Bw3fjIfcWCb2VfiYM=;
	b=CfuHdEnm2cFwmmqZzE5/RslG7453hs6+pyOiauAmH/gPmHzh5lIzDRuuI8B9RcgmFxrfwZ
	ljEc46EDuI604wSJ24uJ6XQGVCt3y5B1CZppn7PKspb5oaQqrywWIdWDkmXXlBOqVmtsq/
	Zae17SqV5JF1cS/1x4lvT1qyrRPrg1w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CwgT9Ht8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649755;
	b=e3zlW55jWBgDKv0kJESTob6BPgicyqIiyuvwFBKSTUcUA63Wj6lyKaTLH0+/UOnDLllVlu
	Gu0x2QUUyxwhK4J4k3ePdQzija3Gb+yhDbykEH17piEVA6Nhwnt39XobQdAnMz/JVEKMex
	MzGufax2ue8xlkFFBl1z1tNos4hBDj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3048D600B0;
	Thu, 13 Aug 2026 19:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DC51F000E9;
	Thu, 13 Aug 2026 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786649754;
	bh=Y4uVpG3bdbrTSkcePR6X4sXWK4Bw3fjIfcWCb2VfiYM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CwgT9Ht8lK1bV896H5TxIIa4Uv24P73RCNDkYiVPOxMuIUFBsTCWTDBROcJyUXVtq
	 pLw/IXLDJ7ix7hRvcFtXGewgaTSOrenm/XTeKqxxoP6pydlZgdKiHz97Z7cKMcwJt2
	 ig4s3f8vvXRY8Gck3HZX1PpfCbqnEDXpCqXNA6QDT5yvWUFD606fJaKlJhrpvol7Mj
	 F9LEeMe43BhiHvvs3qoIr6pIDqMnsPN7uLErhszG6cfXKEw43cQOiprF3L7O8E2jCJ
	 hCP/+6BrtxZMziR1vRALtdz/8mwMFBE32p81ukzgEkBRwHfymvdfgT2r2vcXUYkZOd
	 AJrGxUY78Y64Q==
Message-ID: <6527de10-5140-47d8-9c05-4df3c9868ec0@kernel.org>
Date: Thu, 13 Aug 2026 21:35:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/Kconfig: make MEMORY_FAILURE select MIGRATION
To: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
 linmiaohe@huawei.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, nao.horiguchi@gmail.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, gourry@gourry.net, tony.luck@intel.com,
 bp@alien8.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <20260813134916.292733-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813134916.292733-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6113120003
X-Stat-Signature: 1hun6cuwhmn3b6anmhyt3op3w996eqts
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786649755-959039
X-HE-Meta: U2FsdGVkX1/yqBqrpNCICvD+8B5z7evxmw24ZfpGHUAvTqCMW6hRb0DLbsxSsMIJNVszMmdOD3B95kd9Cpfn/0Tn+9gPlmvc7ZIyG0yc+N89rj6M8CgjIZPAISuBPSL0zMkWY6iLFEpu/ZzqJpYZLyl7qYpc9/TLqGVdChFkDfS8BPq6Y/mqv2ihHZZw3x0J8oBfnSZ/gZY4lYYER5jDp28xAN7aCBRZrRVm5hMV86IuzKSjbg3n4Ws5wttQvDf14VPcSJsD99mhWRJny2JmzhwjGxz1X1xUUTwzJrf5MpRxEqmaMqN7H7U4DBQ/PNbRm5mY6O8R5Dpn4bBL/VYlXYqIuQlf+/Bzg44dlHKROAZHkLIJZ8Ieq4p5sayiKQMkZzXVhebTh/nemQSw9j2lDcetIZfyckXF7mfklK1IvGrXYR54VtjMTbqdrhCcOGT6G0OJaR1FvpqKaoJaJXCBCFeHiogWlYN5hXW8ZAIGgdRh3NZkpTsWlwsbgZu/9Z/fOFQeFXZD3FodvzN7kzT2QMUxHG+dXB2VVYF2oDtWuIBUE6/51K+M1dNhzgMkC+yVUeiazhi5L/9erNAfNLPM7Xeyac6f1Rh940hJhfxdJGxVldq8Tcg/5BZpUzBAwMSqqXFyxKVgxe16kDZjTphVr59HXv1XvAsszrOygQXtcWNsBWxNjr7f7BTofEAaCO6BZv8J0o7ANw1Bb+nHnM/hSsbupjzYQwG3xmvEOEIZJuMTi8dpFCaaOwBbyEb0w16R+Cc41GysWxVH1NDrjxQ0KN5o8f+4RPc6TAZNp6viza8wdQKVB25YmFIjjFIEXnOlIDH3JXBJfAcnElAIDcfLuXaj/mOBCBvtfx96paltJ55bbtTeRnB+Pa0ox0299VWT332lSBEDJ0r7TRNXsQGI7f0n7YAcmB9VkaNAz7byXBFZ1SiRYAR5L+qHVOiqivx1+bEhmHUMLLMD38CrXQl
 mDYFYD1L
 mCI1acFd2j9sSCXTJRV//GKeEEK0ny6qto3XndUPNUHZDgGlsDZF9dUeW/F3YrGC9CAGn57bGmBG8hIKGyCPAZbjPjyAt5xiB7pqJO/t+r4+as7BXkLh2YDc2Qa9/00qZko4bUqZwtKpdY3rYLoI55q/6h2ZSowKM8vxykUaRFG4oqW6jCmn3o+0dp3pVP4x7ooJ75bAFuJ5eW8o3xO37Qlyqt1hWgJN1Mn5zhOy/z8HP7i533rYyBaBc5GUAh7kFoiiGyzmYt/LbmUKmPfhDiUkOeSPa5iLGk+YmmSSgMRAXd8QdE5irf/voNVOuQ9pIWxLSR5L5cHvSzE126j4XtbvQDvV5M6OQYObWQ1uTxoXrqMR5q+f3U/WeQtqZcvkM05WD7aAirtduHJPVTyBAGaud2PpZHf4xKIQJPVr868cYyho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 15:49, Xie Yuanbin wrote:
> For embedded devices, lacking support for NUMA, memory hotplug/hotremove,
> CMA and huge pages is a quite common scenario. In this scenario, the
> demand for contiguous physical memory allocation is very low. To reduce
> the kernel image size, some devices disable the compaction. However,
> their SoCs do support DDR ECC, meaning that memory-failure may be needed.
> 
> Migration is very useful for soft_offline_page() in memory-failure, which
> may be triggered by correctable memory errors. Most anonymous and
> file-mapped faulty pages can be migrated to other healthy pages.
> 
> Currently, MEMORY_FAILURE does not explicitly select MIGRATION. When
> COMPACTION, MEMORY_HOTREMOVE, NUMA_MIGRATION and CMA are all disabled,
> MEMORY_FAILURE can be enabled, but MIGRATION cannot be selected.
> 
> Make MEMORY_FAILURE select MIGRATION to handle this situation.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

