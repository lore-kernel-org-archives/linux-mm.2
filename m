Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B982D10ED661
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1504A6B0095; Fri, 27 Mar 2026 09:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127A36B0098; Fri, 27 Mar 2026 09:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064DE6B0099; Fri, 27 Mar 2026 09:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECD3B6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:45:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75BF68DB2C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:45:14 +0000 (UTC)
X-FDA: 84591964548.11.6FF4633
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B55C120004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:45:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=R1VVK0Og;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774619112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbLmVGzsI4+uNyjVzgEOD2NfpFFBuqWmyl7ZIzmxZec=;
	b=pT2B0gJB9u1qKXdN2xH0lxjalHfuoyzM+HqRLVWG+/dB23VRXUnsfhwxv47DXBhpqLv/AD
	jrpLVbtggN9NdDT502w0CA7Wjh04yqqz6l61GOUB1TqnrcdV35sSlk2Z3NGPa/c68AoYTx
	Nbx5khLTv7U3soZy324mex92d6YljRA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774619112; a=rsa-sha256;
	cv=none;
	b=bietIMfFThd3yh4qMN1qrl0gvsrOnv3kL4zU6wSCzne9nr2uk0wJicBzKZ7nNWQC7hHRv3
	M71YDUfL5gBqv2Y7j/VY6vwXGyVlw68s2NgaofIjRMv2sqHuZu/xM6U1zZhS3hxFaOFsZy
	zGDy9QFFb0jdFCtlsdjl0Naym6AZtwk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=R1VVK0Og;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774619106; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DbLmVGzsI4+uNyjVzgEOD2NfpFFBuqWmyl7ZIzmxZec=;
	b=R1VVK0Og6Aga5K/4z682Re7Zwz8CLs8wR26E0l/v3vjxTH8hCADUEPzEWcCPEc77fty+Ja+2ouCqkOq+ybYlMtx36qU6+RuEjCuyUaZaGWSAJZ+jNamS78qOUr8Zjd3cCm/a0ZHcwy0rvkBD59cKcKHfaC5QyOpgxSaSqfTFjeY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X.oRvWO_1774619103;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.oRvWO_1774619103 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 21:45:04 +0800
Message-ID: <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>
Date: Fri, 27 Mar 2026 21:45:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
 <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5B55C120004
X-Stat-Signature: fybc8s8sbgyitunndwr9ht8gofa3u7wx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774619109-355250
X-HE-Meta: U2FsdGVkX18VDC9KbkqDcLP20Gg2HN3BDI8lMmnGr6FmMYbCnb6gAmWboyqYmENOpbroQVBFgZjGdhopE8KUwX57KrMqrH2QeFy1d0V+QovZATeyk/RKEacRnSB58V+IwuzxeHuDasargF8uUSMSFjhhPpg7yDXODftLHtxit8RIqpHpMVpBUouoo5ETOeEczEQ7iYfRWdchsFqJrVCC3Pto3k7XQm8LwxN6JdXpd7ijkEAWAZWxeOrGqq644Agvl3F6uuguY8hiIJJQUfmrQrgZHoY2AnBLDlDTkoWVVMdi8fXo+rWNf974eHonaE5i5p37naC7jKK9XO0zu1izQCYoO7XQOp4DI59VY+aFqrLriKNP9gWpVUUP89gvguJ+5I07+sbUhFiJoqnUzdfLsvVesQrkC6Vfac5TKPNocPD89mUW1Zf0Z+CBKwptc9dah2xOikEO7EzY3H+JBmoCkwyJttbV+t4X3d2m1LgtRvxS23G7Rr56hYc16O3He2yXEc5yusVSwpLoDEraFNUX1A9UGA0w79+MLE7QYxxsYq2mdPsX59zd+kANE6xPF2XaS6jKGApE6YXOJztnv++GctIjFfD1Gk179/BtBiIeVHBLbymi2EXqQyvtX69JQlDoz6GMpJV0YzzHcp4wb+U5j5EyHoZ57F41kN0MdQCXSWP0SgzL4AV4Aka3+b9Olre6hNzUYav1vam3UkJXkVgHWZnr+ktYcSZRnCZWCneiHYuZVtIXwMIc8MXgrdVyT9+ge7FvPn9tAm4OLnoYfMNYhx/EnFzB3ERostoVUuqg5xEaOZPJd8chcOICfD3ozu0v8KWD6KA75N1clxrSkqfBHLT9db0L0/Uw/c6NNW7aF65C4WKp84ziY67J1ZjW+37r8NvB6tgU3JywsrDT3XCX5qggrtCBPdrXhLL/OstwSBVnyAdFo5OD+h1ICuEtBHBde37lrGMpDxSa+Vp1gvA
 qg+CDqHR
 z9v72MMlDBV0tXtCmuipRWAae/YQXT6h+RlBTWxFGfA5UiI9JQS0k6yUFYRjaYyuAhMHrBhsegrbfHjJYaVts5DmSpZVVlkUDrfjyyndaArzY/1ANZu1BFt9oTr9w4GYDEThK8h0I48cOq4nN7yYusw2m/p62Drt6yXKzm+AqSo8xcGGgGRclVMg8+HpfXtLsA5OhVDRfVKFq17W4qRRyMkScEvzhNRBSeW0b8o89sXQCZHm33tC5eEHz6IceMnQh1EGSgFNcou+09x+J0yZAu3jBV20FylFzUNBgPiqBtNUVlHKt3uN0QV+NSMutRwGbAJluMX5VI7HhDnAWALK2xaePrk0q6qIK9pw8M9pYjVxJDH+n25ZnPRJzP81gM8puwbeT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/27/26 9:42 AM, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>>> huge option turned on also sets large folio order on mapping, so the check
>>> also applies to shmem.
>>>
>>> While at it, replace VM_BUG_ON with returning failure values.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    mm/khugepaged.c | 7 +++++--
>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d06d84219e1b..45b12ffb1550 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>    	int nr_none = 0;
>>>    	bool is_shmem = shmem_file(file);
>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>> +	/* "huge" shmem sets mapping folio order and passes the check below */
>>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>>> +		return SCAN_FAIL;
>>
>> This is not true for anonymous shmem, since its large order allocation logic
>> is similar to anonymous memory. That means it will not call
>> mapping_set_large_folios() for anonymous shmem.
>>
>> So I think the check should be:
>>
>> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>       return SCAN_FAIL;
> 
> Hmm but in shmem_init() we have:
> 
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
> 	else
> 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
> 
> 	/*
> 	 * Default to setting PMD-sized THP to inherit the global setting and
> 	 * disable all other multi-size THPs.
> 	 */
> 	if (!shmem_orders_configured)
> 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> #endif
> 
> And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
> shmem_enabled_store() updates that if necessary.
> 
> So we're still fine right?
> 
> __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
> __shmem_get_inode() which has:
> 
> 	if (sbinfo->huge)
> 		mapping_set_large_folios(inode->i_mapping);
> 
> Shared for both anon shmem and tmpfs-style shmem.
> 
> So I think it's fine as-is.

I'm afraid not. Sorry, I should have been clearer.

First, anonymous shmem large order allocation is dynamically controlled 
via the global interface 
(/sys/kernel/mm/transparent_hugepage/shmem_enabled) and the mTHP 
interfaces 
(/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).

This means that during anonymous shmem initialization, these interfaces 
might be set to 'never'. so it will not call mapping_set_large_folios() 
because sbinfo->huge is 'SHMEM_HUGE_NEVER'.

Even if shmem large order allocation is subsequently enabled via the 
interfaces, __shmem_file_setup -> mapping_set_large_folios() is not 
called again.

Anonymous shmem behaves similarly to anonymous pages: it is controlled 
by the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() 
to check for allowed large orders, rather than relying on 
mapping_max_folio_order().

The mapping_max_folio_order() is intended to control large page 
allocation only for tmpfs mounts. Therefore, I find the current code 
confusing and think it needs to be fixed:

/* Don't consider 'deny' for emergencies and 'force' for testing */
if (sb != shm_mnt->mnt_sb && sbinfo->huge)
        mapping_set_large_folios(inode->i_mapping);

