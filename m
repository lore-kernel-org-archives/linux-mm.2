Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99373FCB61E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40126B0096; Fri,  6 Mar 2026 11:04:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA8C6B009B; Fri,  6 Mar 2026 11:04:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC926B009D; Fri,  6 Mar 2026 11:04:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD1246B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:04:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7AA9114063F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:04:11 +0000 (UTC)
X-FDA: 84516109902.09.54F7EF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A02C24000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:04:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NyRMpeAc;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Sf674e62OrP6q7VHgZGXjlWjApvXfTWUBTCBNqcAPE=;
	b=nda1M/RCxc4V5AGtzux4v1VGGhbkqupSJj3iueYDCrB6L6PZyI84D9wCNj3r6zLFBSl6Ia
	A3K1AEAiy0p8bTWwQf7EJWxI4BLzXxZJbmTh6JUkGxPHXx51oXSSEQs9iRv5MkxzRGsrYG
	AzebUFZE2Usf1kDRJOGErZOe/iyDDwQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NyRMpeAc;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813049; a=rsa-sha256;
	cv=none;
	b=0QbBuZfuSKDygHKVvCs5XnVD155Ty1ahSuYHw8uy9Q51HdEuidyULohPfBjiTiwZJkZ0kj
	vrIzYje8uMXr75Dxt/cxVEgG2yRFNPVL8T14qLmfkxYLtXtK5qujxZE+zfdLkRZ46h3FjK
	PeOZShesN+swEqsCfvtCyOlQPoELFiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B30B341A7A;
	Fri,  6 Mar 2026 16:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7B4C4CEF7;
	Fri,  6 Mar 2026 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772813048;
	bh=rDwyViAwJBrWqHHIJBFX6WS4Aph53FS/v3jxwcha0Dg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=NyRMpeAc4u6y1bOweC+oL1pis1n9yLFuTtLwnaUrYwqVmS04JztDPODWebMOjtgHG
	 8Fbr6g27cgQp5m17yZbh7JI8fGZ10S9y0Cr+pcX4HVLSzfam0/RHeiP22aiFXmTcSO
	 m0JAkjjIdvcoeV0GjSXsbjx1PSem9FDJLdlR9l9XuQ7+JD77UCoo/+4blAoFrFHjtL
	 4lmP/E5Rc6HT7h8C6PmXHl7OCQQzJE8sLKpJ3BhxpLtIzac0pBDjbI8v8Sn+lsg4pM
	 tBbGfrIkl+EK0Z5f0OcPdpEvn/ccg8GzXxJT1Z9Fkm2SnytuuVu3o7hx2RjZi50Rbj
	 AaMG4PpMzZF8w==
Message-ID: <b4830560-4459-42eb-918f-23b35bb5cc2a@kernel.org>
Date: Fri, 6 Mar 2026 17:03:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/13] mm/util: Add flag to track device private pages
 in page snapshots
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-12-jniethe@nvidia.com>
 <e5374250-6fa6-4d39-8a0f-4b1804c35dbe@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e5374250-6fa6-4d39-8a0f-4b1804c35dbe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xjbisb199nbx7c7tjswxk1ds5xbbfic3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A02C24000D
X-HE-Tag: 1772813049-628474
X-HE-Meta: U2FsdGVkX19yvLXmOMl8LCzG2ZZ7io0jvivVjyVbzw1hIRKcr/tcG5HlGqhE057RquM3yAtx04wVo7V7xgfoBhF1eOrQ/K2RBLujnns04ABwtyFqBj5g2VLp4Cuxpig/JM8KarWzNlyWkNkcUakpEFOBnD+IDfaCQzRdtgiC69Yam3+xFMp9qTama4WuX/West2jl9GAMQn/7bteO51b2yR/TQSd6yM3gQ8z8pLyanf7HYjAmKn7yh4Q4N9sCyg0j1yp3RhWLjrZiH3Euxv5/YlAkbRZ6ccru4Jy93XCzAmGH4M+3jth95c2aE+1XQRYNpDe6ADn6uTXSYAex34xsryXJRR29PotCiqawrJYTmYM8/zQ03Xl6KHWgbY3cTq/9NK8CQjX3KEMHBAKcCRWQpES/eXAF7hkzvcrfz5xf6NxyUqlnAV5x5eCJc8bH4x0eWOeNGrQuW2XS/Ka94oetM8P54gMKb5qt3ZZ8DD5wmouAEQ3ZeBwkvIYLno4+7qGLCQz5P5CpRLLfI7aq4T8slCkyB4F88fihMCOOnRDAPJlaZy9TyQccm6t94XhLHDJhEdxoipcDjUlEhDg/nFOqgqUnnfcjRxLFNzPRRX1yjjYa4qp3VG9kSRXK/OEDKeP9+Bb/A8pAJOAh5w6kfIZUUL3NgFtmjUadxYaQNDcMPtPnhBJSJBNaz3glWNKHWZPwrER2zVINAdYXnH7zr5q5O1hnOkKjvdvEbEzEy3lN+MW+dvx4o70Ecd3RDrq4vbo+FK4D+IjCLv4vrFVUyzWyigS5fr4k3H4W0EFdjdAP4HzXPi7Gq+ccRIjjSMTEa1ihKzLDvnC0U2ORLQ2t0y2RMrPrHkqYMik6I9XvXHDZ6C8LkyNymXH6E4zg1kXqG/Ekw9/BKK3DMQOERZk06aWL9EIwTKjWOfc91Ce6rmuQ7AewMtC26Y3UPsL0EAAeOLz3VzMqzH63D3uvo8BPKa
 bk1SfAsY
 F+BeAwVbqbaIL4hRX15QYp60RQD/S8ko0bvE4/RzCkBWF/JFtra7GN/aDdWaiGyUcO4mej834I7RjLSqC4K2vEFt/7ibU+Vwj5V9F38b/ZhQd3ILbu0xI2KBnljcvDpqWLAOrzdIDCXmt/Pzyzs+4V4ElARyByMkelCkvFOjUdi4gnkKT0P+8yGlg4SwDYq5EkaULZUcpR89swhdBK009tn4D5X8MGAXqiOoMJumYRQDM6Wy0d//0Bu/4uZAP8gx9f3WIiOpv5PLodUnKHeuz3inYMePm94UQcbrViaFGsZQJYvxA65i7voEXhEv6KXdVnGPc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 17:02, David Hildenbrand (Arm) wrote:
> On 2/2/26 12:36, Jordan Niethe wrote:
>> A future change will remove device private pages from the physical
>> address space. This will mean that device private pages no longer have
>> normal pfns and must be handled separately.
>>
>> Add a new flag PAGE_SNAPSHOT_DEVICE_PRIVATE to track when the pfn of a
>> page snapshot is a device private page.
>>
>> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> ---
>> v1:
>>   - No change
>> v2:
>>   - No change
>> v3:
>>   - No change
>> v4:
>>   - Move logical continuation to previous line
>> ---
>>  fs/proc/page.c     | 6 ++++--
>>  include/linux/mm.h | 7 ++++---
>>  mm/util.c          | 3 +++
>>  3 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index f9b2c2c906cd..bc14f7ebc369 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -191,10 +191,12 @@ u64 stable_page_flags(const struct page *page)
>>  	         folio_test_large_rmappable(folio)) {
>>  		/* Note: we indicate any THPs here, not just PMD-sized ones */
>>  		u |= 1 << KPF_THP;
>> -	} else if (is_huge_zero_pfn(ps.pfn)) {
>> +	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
>> +		   is_huge_zero_pfn(ps.pfn)) {
>>  		u |= 1 << KPF_ZERO_PAGE;
>>  		u |= 1 << KPF_THP;
>> -	} else if (is_zero_pfn(ps.pfn)) {
>> +	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
>> +		   is_zero_pfn(ps.pfn)) {
>>  		u |= 1 << KPF_ZERO_PAGE;
>>  	}
>>  
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index f0d5be9dc736..a52979536a5e 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4627,9 +4627,10 @@ static inline bool page_pool_page_is_pp(const struct page *page)
>>  }
>>  #endif
>>  
>> -#define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
>> -#define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
>> -#define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
>> +#define PAGE_SNAPSHOT_FAITHFUL		(1 << 0)
>> +#define PAGE_SNAPSHOT_PG_BUDDY		(1 << 1)
>> +#define PAGE_SNAPSHOT_PG_IDLE		(1 << 2)
>> +#define PAGE_SNAPSHOT_DEVICE_PRIVATE	(1 << 3)
>>  
>>  struct page_snapshot {
>>  	struct folio folio_snapshot;
>> diff --git a/mm/util.c b/mm/util.c
>> index 97cae40c0209..65e3f1a97d76 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -1218,6 +1218,9 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
>>  
>>  	if (folio_test_idle(folio))
>>  		ps->flags |= PAGE_SNAPSHOT_PG_IDLE;
>> +
>> +	if (is_device_private_page(page))
>> +		ps->flags |= PAGE_SNAPSHOT_DEVICE_PRIVATE;
> 
> stable_page_flags() has access to the page and can simply test that instead?
> 

Or maybe even better, if the pfn has no meaning, set it to 0 or -1, or
anything that will make the other code just ignore it.

-- 
Cheers,

David

