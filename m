Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E817CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193896B009B; Fri, 26 Jun 2026 00:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BF06B00D2; Fri, 26 Jun 2026 00:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083E76B00D4; Fri, 26 Jun 2026 00:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D84176B009B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:10:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C54F1673CC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:10:05 +0000 (UTC)
X-FDA: 84920735970.28.7C5551D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8560420003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:10:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sfpK7nGw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782447003;
	b=HSWflk0zQWWeE/ga/d1i3du5iGeBhUYefXnnjMGVkgYaEvUmuoYeVIkPtu09QYLI9lAF5P
	LSxnRD5RDseYthlNTr0Ai5d24Vfs0ohxxNOTMFRZfF8reRmt0pEJHyRHhBI7inl3xgzcUo
	MrgSPiZkWAGNUGjBaq3ZB9fMEfGLI2Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782447003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBZVyWvoQfCRJGJOx1qxPwKatGc6T3VqU/ROcK37Dqs=;
	b=mwsWrHhSjvN4q88eFqEYGhPRHvipi+W2aOf9ufOcpuIe7yhxgnzflv1sB/83MQdonx6lfF
	uubVWUeB3UEQzu76CfoSQN2FOm4rAmB8ESWCiyJKR38kWGseQqURFbT9yWZYl5Rw24sgWk
	1BzrYJLhBOTf8esb5F5o1DCBma6aI8Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sfpK7nGw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9BF228C7;
	Thu, 25 Jun 2026 21:09:57 -0700 (PDT)
Received: from [10.164.148.34] (MacBook-Pro.blr.arm.com [10.164.148.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E7E163FAF5;
	Thu, 25 Jun 2026 21:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782447002; bh=SpHSZj0Ie9PxHEQt8oq6IEyx1BGJwCxxpYw55kH+XHo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sfpK7nGwqkPkcur6fGaPSDbMmnwqt421AW/1JpY5wKA9mVVaay6yqy2BHH6fBrJUU
	 0zE3vzqv5nOm3H5wn7UVnDZTY2oCF8gpb1NhhOkBDhDES35oT7GKocOTIYih2WVNeA
	 lxNdKs+UzECOSWnJsqAI2pfHdgw9HGvT4qI4L6GU=
Message-ID: <24c8b1af-73e2-4c32-8e68-fc230dbcb25c@arm.com>
Date: Fri, 26 Jun 2026 09:39:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Fix incorrect access of hugetlb pte entries
To: Zi Yan <ziy@nvidia.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, david@kernel.org,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 mel@csn.ul.ie, nao.horiguchi@gmail.com, ak@linux.intel.com,
 j-nomura@ce.jp.nec.com, pfalcato@suse.de, dave.hansen@intel.com,
 tglx@kernel.org, jpoimboe@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <DJI6MYYF7NOS.2JRWBWFWEO4AO@nvidia.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <DJI6MYYF7NOS.2JRWBWFWEO4AO@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8560420003
X-Rspam-User: 
X-Stat-Signature: e8mgb76fida33cp5x476gpk8e3obndwm
X-HE-Tag: 1782447003-872561
X-HE-Meta: U2FsdGVkX1/0bU/yjJQzsYmklKEm3bqxpTrNdD29O+kz9y6Myowafknr319f1r95ctiV4X9hVtrMrkLzhvlJMZyi3/sUfF9bfcDNFNGWRueGVBWUlikEVynsWhnpbzk36hD+TZ7+K1Tm3yhSZACIBECGtit4AuYoWQ325A7CYVfSzs9+2QBPBR1JdQYLe87uyMBSDkfO2hLhuOQOPEIT714NYLc09Q54NCXP61VgSpJVHD7JTkIaH2TQKIZSyUVxoHkYG1B2KeFRxICuQBcKV+PozbIqP6tRR5ghhAmg3HXsXvRAswlDlbRk5INw8wGESh9ZaWc4GkaRdqvU6JoGiASVjPCVJMF4+1SZyijfWbFQywzk6Z/TX6jgGrgL6ouQY5NGxHCZG+0i4qrrejzy01WaIK+IxePY+TXbbEH5b6Kx9WM4GdhJOeQ7bufCjFhQ/JO3uw3/XJwcxrKNiNlkKmxML3DuCUyVRoLzVkoTbVDVmkxyON5JYj6ZxEFz5HirVDvT5qsb2Vssbz9s3DHWYpm9bPopuizx09e6YKQ8e3mRlwFbzHZm+t37HILe9qSiKkxoMe4DJmtg5JJQope2nuvxH8KdimP94wsNgFaWbLjdc07URbNuNB9GVeO7F4FIzYmoMLgM/VWXlAhZeK9Tf7GbIRtnmxeYXwwuijyOYXY1rSSqLU3qpfik3iYQEN7kpGsWFK5YAXLAvcSp/sZPxesoo4i9EYb7TtAzulzq4gR4SpEUfrnq7ITkkNSR5Wqdpyz9T8OntWO/mkqyCoyt4B2iF60ZZnUHhe3qr2WCEHklAc5ei8Eyy063rpdJ0ykFzdqxaY1Tfm+GhKyc888sha+/7P8IHzbZShlaGaNpHBSV2aMh3t6umuBjF843UtGRw31599Ha75tZKlx+03yJhVX33CFokjZSl5mtbRlsC5Hy60ZQe7TUDGXe5CFcJT2iNT38egAKMZLagUb5l55
 xmRHXRHQ
 Q1jYGWa0cWGWJgiVTEPZatkEwjmy/+T3bJx4zE6+irfEShwE6BCfv/Gu4oAYgUL4RW96W+fIaeCHRjqsKkS67ZgY6R6JunBZuXrVlS9Hz4p+VG9S7WVZNC9YTxzvFGnDkQxDTdmdWKZ8UDdA8EpLotA8N/BuUjeqoYzWVOh0wlSQ8V78tpBwbvxZzNGjRwlVN0NnVrDACHQD4VVVgiFkVAWivy9DcfLBFjit9vNSpNPnDzU7/d6NepcSFArTTYumNip/HAyDYSzr1Hu+Z878MOm36wNDfUKT8pf1cLLFERdDjnec3KGwquyJuMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/06/26 7:29 pm, Zi Yan wrote:
> On Thu Jun 25, 2026 at 7:29 AM EDT, Dev Jain wrote:
>> There are various places which use ptep_get() to get the pte entry
>> corresponding to a hugetlb folio. Some arches have special handling
> 
> I think it is better to mention s390 as a concrete example.

Sure. In case there is no v2, requesting Andrew to change
"Some arches have special handling" to "Some arches like s390 have
special handling".

> 
>> to compute the pteval, so they provide huge_ptep_get(). Use this
>> helper consistently.
>>
>> Dev Jain (5):
>>   mm/rmap: use huge_ptep_get() in try_to_unmap_one()
>>   mm/rmap: use huge_ptep_get() in try_to_migrate_one()
>>   mm/migrate: use huge_ptep_get() in remove_migration_pte()
>>   mm/page_vma_mapped: use huge_ptep_get() for hugetlb
>>   mm/mprotect: use huge_ptep_get() for hugetlb
>>
>>  include/linux/hugetlb.h |  3 +++
>>  mm/migrate.c            |  6 +++++-
>>  mm/mprotect.c           |  8 +++++++-
>>  mm/page_vma_mapped.c    |  8 +++++++-
>>  mm/rmap.c               | 32 ++++++++++++++++++++------------
>>  5 files changed, 42 insertions(+), 15 deletions(-)
> 
> 
> 
> 


