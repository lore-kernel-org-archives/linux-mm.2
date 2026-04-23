Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C69B4FAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 04:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158576B0005; Thu, 23 Apr 2026 00:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109F46B008A; Thu, 23 Apr 2026 00:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F146B008C; Thu, 23 Apr 2026 00:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E401C6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:48:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70861140466
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:48:01 +0000 (UTC)
X-FDA: 84688588362.19.DD8D027
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id 935994000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:47:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pSwKFVPk;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776919679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2ZOLwoMzsrbZBwQV+NdexL8zdWBG0VIOfAx2UN7NiM=;
	b=IgVihb+KZ7LOeZCAAYjqkuoW1JIcxtJTTvXx2ps9CRye5Gt45FfuB4cR7oS6JkFSvA7hKb
	Pn5lAOFK/yCw9JmPy+/T6gG7yU0XeQafl4UoCFDFBsETHQGi+EGQmmAXd/6UPmNQo8T3o/
	a4fEPsa3NhVhnk+hXx3ujglZoJdpELI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pSwKFVPk;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776919679; a=rsa-sha256;
	cv=none;
	b=vwLQiACXQawkYh8YJMwe/6EEvr92jrVWkieURBSWhkIgv7+IzDPBeaRXm3VShqNH4rXDsH
	fROGtfJCg2WLmdSaZbRMXko/+Oj+695O+MC68LxwLFzq7udcX56l89GMxlrWAfBBQBPc9y
	LChcpIdIu7qRbaI+VviF0OTZy9a6Lnk=
Message-ID: <268e0f1e-8575-4ee1-8a0c-48e1b9ae05f0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776919676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2ZOLwoMzsrbZBwQV+NdexL8zdWBG0VIOfAx2UN7NiM=;
	b=pSwKFVPk3ujuY4dTQoLRLMcsH014KXuXyCtwbvn5BpAjl2tog1AzPpF6zi5PKQRYU+4s54
	DcR7ZoY7F9/0nR2yK2QwOs9aKQaduL6/xrtsJdILfC6i+J7TBDgLWAKIpxiidWUUC/kA4E
	MB+UB0RZF7aHqNLieJzBgCKgNazv8gg=
Date: Thu, 23 Apr 2026 12:47:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 7.2 v3 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: willy@infradead.org, songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-2-ziy@nvidia.com>
 <20260423024324.51588-1-lance.yang@linux.dev>
 <20BA865A-1B69-48DA-BE12-9BFC6EA5A4CE@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20BA865A-1B69-48DA-BE12-9BFC6EA5A4CE@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 935994000A
X-Stat-Signature: cjo4y5j4wm5obt3qi9ixw1q1upbenqsm
X-Rspam-User: 
X-HE-Tag: 1776919679-699170
X-HE-Meta: U2FsdGVkX190WS4E3aNEhpjVUIRt8ga62rV+ghYYSmhZ9k76TWxnFRHW1pEim8EX7GFtQdyRueFrAhzrrOKxWnUns1lHVax2mxjP4Wc375qWhMsc3yy1WrgQVEje81rOnQYaslmygDgiM43KoM2d3BhlpBKvefAk7tqvRDM4ypfQxxBMpJ7kJ4XupnFCrO6XFGim8fN2PtpRb1L2meuMsQ8T3zHZ/cIJ4eDSkiFuGBg/aGLMUdpH8f7kRxXHxW5Z5HsWSkiRxXUg9y8PPW7nFvzOtc4HtZyShFRobf/xfBWTmLRPrL1JOYoGB5XVhJH1GDiQB8HdjLoZIZY2cJTKGw1q/gsbnLLjDPZRQ7WxB78VBJmxnN3+JfcmCQ5AM5d0pwMeY9PilNlOSqABSspjr99yK/mmoVA61lJUukQn9uOSjrpQ4GkKHlW9GboDY5HVT/ht5c3VGIRvASnN60Baz9GvIHOhCCZOuL5iePRKlHdiQ4Jovh4zqAGjM22tmGz6VV4MscWjWfCCuQkqapW0FQn7s0UDXv7O1M0UN3SyT0YIy44WUmkmWhshsk5ZtPZHKOugs042KHVVYI+jtggSCUKKYnx/htvUndEKf4KV0fPZtEUkGN2JsgFPEhkGMHp9Yf9AJ7UcRJ62TIZXm+YV31vyMXrtRawk0X+pl2q5yoyAUZFvbzjcmok+9pdzU8YnuY2cZrMoUAFC7l5O94f8lgHw/sdknfoXyluz3OXagMtze3njOJp3MGLrV/U+ZRQO9tUTTC8AaYDys72JUHKnsVrqxsJQZPJ+xquLhd1DaIvuH1bQiNrwCpm/CYZ3lxABgyW0+soFag5k6Db7z8dXTYqOeBw+EV1Ol67VoyI5vtqcLVUAzP6CvZlBibrMPKiba/RDt94taeRba6GMuyij9sZqAcjwNMlbzYa5570LqhvmQYqIKrtfjXxTEVpi3wsDaqJQ/BxRKD6XYfWvX0p
 G8BadoI/
 WF91kWc6gZsbHdcgq+Y/Wc+Ix+BmtD+CgLr6DCRf2uHu85NW6X+5GlDyLL01Ovc88JOCLU8b38XI3HlnoXnTWrsDT1X3detykRJlRycLbmbPF7V6hUeZ4Lo9ab8I8CgItOJCHj9guaCR8OhzooXrmWFPMPvD6IN0eip6WzAFNrR1PkHvA2fAkDnHvB62Rfcp8gANuuT9k2r09ZNonh5tvC2D10Dcji8qq0sDs06E33sUY8Esl4CwrpWAf66BMWSWcxQgKkw/Gud4UFwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/23 10:51, Zi Yan wrote:
> On 22 Apr 2026, at 22:43, Lance Yang wrote:
> 
>> On Fri, Apr 17, 2026 at 10:44:18PM -0400, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>>
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>>
>>> Add a helper function mapping_pmd_thp_support() for FSes supporting large
>>> folio with at least PMD_ORDER.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>> include/linux/pagemap.h | 10 ++++++++++
>>> mm/khugepaged.c         |  5 +++--
>>> 2 files changed, 13 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>>> index ec442af3f886..c3cb1ec982cd 100644
>>> --- a/include/linux/pagemap.h
>>> +++ b/include/linux/pagemap.h
>>> @@ -524,6 +524,16 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>>> 	return mapping_max_folio_order(mapping) > 0;
>>> }
>>>
>>> +static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
>>> +{
>>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>>> +	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
>>> +			"Anonymous mapping always supports PMD THP");
>>
>> Nit: afraid not, at least when running on architectures without PMD leaf
>> entries ...
>>
>> Maybe better to say this helper is only meaningful for pagecache-backed
>> mappings. Anonymous mappings should not reach here.
> 
> Good suggestion. Will fix it.
> 
>>
>>> +
>>> +	return mapping_max_folio_order(mapping) >= PMD_ORDER;
>>> +}
>>> +
>>> +
>>> /* Return the maximum folio size for this pagecache mapping, in bytes. */
>>> static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>>> {
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index b8452dbdb043..3eb5d982d3d3 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>> 	int nr_none = 0;
>>> 	bool is_shmem = shmem_file(file);
>>>
>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>> +	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
>>> +	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));
>>
>> With [1], can we drop !is_shmem here as well? shmem would then always
>> call mapping_set_large_folios(inode->i_mapping):
>>
>> ---8<---
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 4ecefe02881d..dafbea53b22d 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3087,10 +3087,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>>   	cache_no_acl(inode);
>>   	if (sbinfo->noswap)
>>   		mapping_set_unevictable(inode->i_mapping);
>> -
>> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
>> -	if (sbinfo->huge)
>> -		mapping_set_large_folios(inode->i_mapping);
>> +	mapping_set_large_folios(inode->i_mapping);
>>
>>   	switch (mode & S_IFMT) {
>>   	default:
>> --
>>
>> But we can do that in a follow-up, once the revert lands :)
> 
> Right. That would make this patchset depend on Baolin’s fix. A follow-up
> patch is easier for managing these patches. I will add a TODO in the
> comment, so that we will not forget. Thank you for the suggestion.

OK. With the changes above,

Reviewed-by: Lance Yang <lance.yang@linux.dev>

