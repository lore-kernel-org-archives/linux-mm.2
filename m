Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B43606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=h+MqjvDX
Received: by kanga.kvack.org (Postfix)
	id C561E6B05B2; Tue, 17 Nov 2026 20:48:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0AD6B05B3; Tue, 17 Nov 2026 20:48:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82EB6B05B4; Tue, 17 Nov 2026 20:48:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 766696B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:48:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB4C5C060E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:48:38 +0000 (UTC)
X-FDA: 85446555516.06.F51033A
Received: from mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2AC83180006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:48:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h+MqjvDX;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.76 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794966517;
	b=woJLJdCLCgZ+soiM7+BoHkelR9/2XWOTeoG3UpUL/8E14FeUvd/wO3kwKxGdsGwe29ekv+
	TsrIIs9seG7PnRtYTyitAF1Fcwm7J3RWTMlzC0S31DUXIulmDcrYrmebGt59w5GbZvM8yo
	k5ZaWxlpkIaDiY5zQ+/JKTcgqLH3fvg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h+MqjvDX;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.76 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794966517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEsuSwHhmeJEGKRuu1fKD0DbR/1Nao9WbEuVQxgyWZM=;
	b=t7pp4MVB7JTQ/N79Hj7nUu0zf1pL4MMcCt4LHoIPYoTKIhmXEyZgGjsO1eg110A8b1pn9w
	r324jb253HCtakVuiwc6A8qJN9G1ba2DvXerVegfGveu8pitYibNw4n01h4hnQu2pAADBr
	Zdcvi4HgQkCzK7q6i27lXFLgKGLOc+A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cipxz3ByaOhwFVVoVY3xs7T+pGiwDTQ+f9P0r9E9li0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794966513; v=1; x=1795571313;
 b=h+MqjvDXMGHHko2yXc8o3a82rh7e7cB9QabP1QfEKZwW1JgYjf/UhxxB6L+87FKipWkOnFAQ
 M52ymobFUSr99U4ta+B9XmNK0PxaRopuRDCZ8VXfNxohCtZ5SrWNVTs7L/gEOA6k9he1ZPmBGWF
 7UhBDGOWYXBux9nmbbZ/4ffg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b13cb621ae958f09;
	Wed, 18 Nov 2026 01:48:33 +0000
X-Mizu-Trace-ID: b13cb621ae958f09
X-Migadu-Flow: FLOW_OUT
Message-ID: <54e548ad-9641-4348-819a-11f29cc35ff4@linux.dev>
Date: Wed, 18 Nov 2026 09:48:14 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH 2/2] mm/hugetlb: remove the gfp_mask argument from
 alloc_hugetlb_folio_reserve()
To: Muchun Song <muchun.song@linux.dev>
References: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
 <20261117-for-memfd-v1-2-fa68f433171e@kylinos.cn>
 <DF9FCBFB-C1E3-497F-B7AB-567F44873B05@linux.dev>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <DF9FCBFB-C1E3-497F-B7AB-567F44873B05@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2AC83180006
X-Stat-Signature: nfq1d5jh7c5e6zmubb5pubk8xmjy1is7
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794966514-368479
X-HE-Meta: U2FsdGVkX189lLpRwOd/z5MlP0ffFlHAShcxy5LsO+/14ns91K1t+RA7hIKGSGLmqYDK19UKT3ZbymryPbWaBvnQU4Qkfe8+q+56AT2OsqulwGVU6zHNHKj8XnGLjKPo0usnysR0/gHs+7tBZwSrvVPD6dujwbPrCWXeaWR8tvnGh0KSCPHcaQsAoAspeGj3tP8s34tbfl4aoiitbTIcQNjuJMDmBSrgnEDAPb8TlruBJ7b0kKmvfoBkxjTRPaJAqyrQoYaymbOEmkdJaqpFgWUmFBfEt/r2ncOZ+N/s5eO4EFqZLrpApN9DCIU36UnPdI+GXG6EGZYyG6yAvojFlJTG3QU764tHNV7M9M03he9n8oBoyvS6A6jK/EVS4svkhI/oVgGHcshqc+RcNztTr0vAPpfCjOskXpD84DJJGoYnBoO6i80XcvT8l1rQMUz+t5wSFJqpJhCdWa6Cu4DhpXKbXKSnQqyjnwbqjJm3o5c1WwkJ97LuMWZ1It0tCXUu4ia8Dl6kLtAXTBHP8huvPOsEHW/NdfLXPIBQu/6IwT1g+/SdxnvBLzw9j64s06ffQ2ZqS1FgHwVnV22suwyeAvQTKXXFOqTr1+Rp/+gRUnXt+Sdq2xcJsYcCP2sYbpF4Kar0d8BbHeF3xYbEZnCq5xd1FXAW5pJii5tTbrwHmtY/5GJb27DfwSpEBIfhzn8oEEIiEYX5c18DNV1op8GOX2KNRhApjBI4EfoORUjQhchZQ1/rCvgASDJ/T6QwVzUvIb3CahZFY9Bydf5Ye4Y6UFpZ4HrzL+Qjs9Lj9H0Xs0APEUvwcuhb9GnkC0wX0SRTIdoHeJt5afwh+1OMf1WasyM/DY3g0EfX8l2yO32rRp9elxo6hEK9UoOfdjYeN2AMuT6p/64dDf4vAcnIfWX6HS/uGAzgK1ysb7yuKOM/VzJ39bKY0BVZmms9ZALTIhEr0gOxjTnvAOUyACOkHqf
 DriUzO+z
 zEg+GnaFfxtRR7g4ACb9gnfGdV2cTqdNlIFP3m7lgDrGjT17buztH507nBNXYzwNcRLdRhOgup0Po5mOLvmln11pYWAKjoEVxsjfLbJUq3oHc3PCxvK1Lih32FKq41iJPaOQEozmMNkiEtEqymvDHbxcR04n2ACODEPvYtoQC5RpQvaZJUsnEgr0rvpysRxQnkMC9DI2qPUVOv43SiqE0z2z07TBFmsb2N7NC/wTO+qRUC1tlakYMJlGXsDXTQHiZ1Hnakuxr5xCUylT3YbMBOHH9BNZU21fXMhSRYs21tdcrH91zxwVSvJUSknNQuJt+dOlmfHvREOgY1v8ZX1k4XVTMHrKVA1eb/8nG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 11/17/26 19:15, Muchun Song 写道:
>
>> On Nov 17, 2026, at 18:53, Hongfu Li <hongfu.li@linux.dev> wrote:
>>
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> alloc_hugetlb_folio_reserve() takes a gfp_mask argument that
>> memfd_alloc_folio() always sets to exactly htlb_alloc_mask(h), which the
>> helper can derive by itself.
>>
>> Derive the mask inside alloc_hugetlb_folio_reserve() as
>> alloc_hugetlb_folio() does, and drop the argument.
>>
>> No functional change intended.
>>
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> ---
>> include/linux/hugetlb.h |  4 ++--
>> mm/hugetlb.c            |  3 ++-
>> mm/memfd.c              | 13 +------------
>> 3 files changed, 5 insertions(+), 15 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 69732e4cc03e..a88c59476e79 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -735,7 +735,7 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
>> 				nodemask_t *nmask, gfp_t gfp_mask,
>> 				bool allow_alloc_fallback);
>> struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>> -					  nodemask_t *nmask, gfp_t gfp_mask);
>> +					  nodemask_t *nmask);
> To be honest, I'm not a fan of this change. This is a memory allocation
> interface, and we shouldn't couple it with a fixed GFP mask. Sorry, I
> can't ack.

Hi Muchun,

Thanks for the review. Understood, I'll drop the interface change and keep
the gfp_mask argument in alloc_hugetlb_folio_reserve().

Also, patch 1 is the part I'm least confident about. Your comments on
it would be much appreciated when you have time.

>> int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
>> 			pgoff_t idx);
>> @@ -1161,7 +1161,7 @@ static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>>
>> static inline struct folio *
>> alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>> -			    nodemask_t *nmask, gfp_t gfp_mask)
>> +			    nodemask_t *nmask)
>> {
>> 	return NULL;
>> }
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 88c9aa700533..e84203406da3 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -2221,8 +2221,9 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
>> }
>>
>> struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>> -		nodemask_t *nmask, gfp_t gfp_mask)
>> +		nodemask_t *nmask)
>> {
>> +	gfp_t gfp_mask = htlb_alloc_mask(h);
>> 	struct hugetlb_cgroup *h_cg = NULL;
>> 	size_t nr_pages = pages_per_huge_page(h);
>> 	struct folio *folio;
>> diff --git a/mm/memfd.c b/mm/memfd.c
>> index 8905e3e9efc8..08b9d54b0d8a 100644
>> --- a/mm/memfd.c
>> +++ b/mm/memfd.c
>> @@ -69,22 +69,14 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>> {
>> #ifdef CONFIG_HUGETLB_PAGE
>> 	struct folio *folio;
>> -	gfp_t gfp_mask;
>>
>> 	if (is_file_hugepages(memfd)) {
>> -		/*
>> -		 * The folio would most likely be accessed by a DMA driver,
>> -		 * therefore, we have zone memory constraints where we can
>> -		 * alloc from. Also, the folio will be pinned for an indefinite
>> -		 * amount of time, so it is not expected to be migrated away.
>> -		 */
>> 		struct inode *inode = file_inode(memfd);
>> 		struct hstate *h = hstate_file(memfd);
>> 		int err = -ENOMEM;
>> 		long nr_resv;
>> 		u32 hash;
>>
>> -		gfp_mask = htlb_alloc_mask(h);
>> 		idx >>= huge_page_order(h);
>>
>> 		/*
>> @@ -101,10 +93,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>> 			goto out_unlock;
>> 		}
>>
>> -		folio = alloc_hugetlb_folio_reserve(h,
>> -						    numa_node_id(),
>> -						    NULL,
>> -						    gfp_mask);
>> +		folio = alloc_hugetlb_folio_reserve(h, numa_node_id(), NULL);
>> 		if (folio) {
>> 			/*
>> 			 * Zero the folio to prevent information leaks to userspace.
>>
>> -- 
>> 2.54.0
>>
-- 
Best regards,
Hongfu


