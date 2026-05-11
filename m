Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90294CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54486B009D; Mon, 11 May 2026 04:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05956B009E; Mon, 11 May 2026 04:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42BE6B009F; Mon, 11 May 2026 04:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5C5D6B009D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:18:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F3A08BBE3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:18:56 +0000 (UTC)
X-FDA: 84754438272.24.213AC54
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3148820007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:18:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=epGTUN05;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATxO2jelJ68gM42Lr3OjufPkMN9bf3PxwQANIA1RR4g=;
	b=jREZwENrHBDGPVg7842/sDA3ZXAje7MJM4uG4o+eo6FqfvCLzFkrMRyXFevsqBdoEWKdgm
	G1ICc4Yc8TxDUxvhV3EgUahQrW1G5UTNHlkAPQBMsLGsJfSXvXKjGmdah8CbQEXMVtiG2Z
	Y5MvuK4WNpTR1BZA2C1kHRS2HyeQIws=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=epGTUN05;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487534; a=rsa-sha256;
	cv=none;
	b=BYQWN/E6jZKUEEng6XaI3LenZc6A+t1efB+ArpbbtNhUsM4SRJuX9VRUTaWHWhLhFM8Cu3
	EeOlJx41n0/0F2vZ2Gw6pLX20MNV+Sbt5zk3ujmDfPrrn3O2xDR0UEmZlQo2ZyKkTU3KwD
	x3LMBhGOX/c+pVm1LT6jzZu7IGuX9z0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FA9E1713;
	Mon, 11 May 2026 01:18:47 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 64D163F7B4;
	Mon, 11 May 2026 01:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778487532; bh=3Qk0rhC0x0MmkiwJFCNV/yWVxTDnzu2XXnAciL+iVZA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=epGTUN05kehIbYfaoSskXQTPl16giKeapCElsPK+msLNWWa83OCWnMf5P2VSFnDLB
	 oTGvj8cVFncOae/jEbjCnJpkuVnO7ELjYAh1ibBVy54OlKFJC/DXnIa0PGS6ELUihA
	 oVcub2cB++Nrclu4uAYeqHJ/NdI3M3MtuZw5cqJs=
Message-ID: <06029485-9e85-4d2d-a324-abba918eecf3@arm.com>
Date: Mon, 11 May 2026 13:48:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-2-dev.jain@arm.com>
 <de2f992c-dc93-4b79-b841-11f47511dcfe@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <de2f992c-dc93-4b79-b841-11f47511dcfe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3148820007
X-Stat-Signature: n5ceqdqu5w3on6iq75nuk9tnhbzm3ssz
X-HE-Tag: 1778487534-111708
X-HE-Meta: U2FsdGVkX1+Bz/GJ8ks3/oy9LIGXhA1SSVIwe+8Qs+m85OfsfioKAHvEibS70vwQsM5Axy0tjBLMszndPjrWouCnrUbSrGt4ZI2gwaSnxspI0Lnnogo9yWxOik1TSMdT0jDr1eNryo374K817wCAtVDjOXesMKwdcKgXTf8iHsZGCpMatZpOyEaQT03urSfahJRrlvW3/WlydymVFP/BlBgPO0I31u9cX2ltx2KUzoPBGj4JEK+GT9FaMb9Y4OH21lVmQSLzWEJz8BZi9jy0shRynqUgkQX+iEFQCZytBQUbIYsyQOfl7ALiyjjCK8fRIOmpCb5+Rs/W53hPMJbuXbUlZR2LvMu3dg8Bn4JmRqvEPbDQd74VTlmyNKWSbpGiCeD+jBSRFP0j3jwrN8uk6rtLvX1S3/Dl7K6pf+0mhVJaZTj8Sm73NpBEix3u1kE72jGbqO3yDNeLQVcCVRu4ys7G81sjA823P3CYtApth2KlrZXxTF3ooqAnGPnCPNEoNAb1dXbttpJ050vGkRsTHbxBBebqbi3CbCm49x9Hxe2sczJCtvdPlvrgrW82KeLc0Ylr1/pOnbvRgXrUe+zLlDvoV4OiJZ962O3ofmsM1y74exjFb/wBEudQhURiBAao70QWD8I2xVwm4eKJKzWTTJZ6G2o9O26T/uRxfoff6OFH3cM5Ti1mWlPCN7JvV5Z8vkoT8xsgL7c7uOCuxckMdOiphzM/Vn7Ll0Fo4j4wl16gru/dxiisG47KlfIg0H+iV3Nmd+Wj867HPetJ1zgLeVTYYG6oDn/xBI9aAYLn9X+5L7ttFF70y2Hv1LSCc/uH6FtQN0Z+7yORwu5XPFDklXwKclbW0se75Oq8rupoKK6TPEODuKel4c3HW4MhA/aTKx7fvCYUjQ/HS/8DFZJMw9tNcptIurL6tXyDFBBRILG6tGnB6XdVJrS2XG7HCr0QtJcDB7OkdnxSVHUGNTo
 Ih1GNB1G
 w4eJoTFFo/u86QmU5DRwmgdONRfkGf5mp8kKZUlwS+Sa2ziqht/zeK2JXH4xWjoe6Gh0OsSbwvz1dEqGZMJZR81cNpLSH1L7kh7R6nctPtJ2YjMJnD534Vp8vGXzFxvh4UcqQ0bXFSmog/P8zDVibZPpwtPkPlq3ei2cet/kTeqqsI7qWdZpiYuMwIPZiqFweAsOcAMmfKMgXNX6pXrwDVpzl+FWDOyMAPSncXC5/5Ca7m84V80akmuA23IXnC2UsaYoYg4STW12GNkkDEMT/J36BT9U2QKNXQG044h849TI++uek5XV4x+z4Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 12:18 pm, David Hildenbrand (Arm) wrote:
> On 5/6/26 11:44, Dev Jain wrote:
>> Initialize nr_pages to 1 at the start of each loop iteration, like
>> folio_referenced_one() does.
>>
>> Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
>> can be reused on a later iteration that does not run
>> folio_unmap_pte_batch() again.
>>
>> I don’t think this is causing a bug today, but it is fragile.
>>
>> A real bug would require this sequence within the same try_to_unmap_one()
>> call:
>>
>> 1. Hit the pte_present(pteval) branch and set nr_pages > 1.
>> 2. Later hit the else branch and do pte_clear() for device-exclusive PTE,
>>    and execute rest of the code with nr_pages > 1.
> 
> Right, for hugetlb folios it should always stay at 1.
> 
>>
>> Executing the above would imply a lazyfree folio is mapped by a mix of
>> present PTEs and device-exclusive PTEs.
> 
> Why lazyfree? We use nr_pages also for
> 
> 	folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
> 
> and
> 
> 	folio_put_refs(folio, nr_pages);
> 
> Given that make_device_exclusive() operates on individual PTEs, wouldn't it be
> possible to trigger that?

At the point of this patch, batching is supported for lazyfree and file folios.
make_device_exclusive does not operate on file folios.

> 
> 


