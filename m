Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E34D13C0D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA3E6B0089; Mon, 26 Jan 2026 08:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870AF6B008A; Mon, 26 Jan 2026 08:46:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773926B008C; Mon, 26 Jan 2026 08:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68DA66B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:46:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 344B38C340
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:46:51 +0000 (UTC)
X-FDA: 84374240622.13.6E97BBB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id C40924000D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:46:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=G9j7PuKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IVAo7WKy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=G9j7PuKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IVAo7WKy;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769435209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b86wKgoVZSbHaNoR6wnTHea67tcH+NoNebqRg4aWBg0=;
	b=pRGPnAOHtEVJNHgPclIUu3V4PdfPmbFkGvDv1QZzkIPuUsynAl/+dOAoZzgvhsMeEynlRv
	QelWKwtRIjg9za+mJMYayBQp9ktdATRnTdI0DgyW4l9ICzE7ulnuOGesmAQAmOyOwqRmLs
	aoCptI8M3eG8hnt4PG4iHalDf3y4MBo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=G9j7PuKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IVAo7WKy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=G9j7PuKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IVAo7WKy;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769435209; a=rsa-sha256;
	cv=none;
	b=SpszxIsCm5Q8/7WJ9jVhSp8k6ApYfYccgo+sKQiPCxCWVYvZxJ+sECGWrc49yS0ZI3B3Go
	gTY3LgPANAG+CnLo3XOVTV/Ak0fPLDvahfWMW2iofN8KZ1IhSiZwNWVR5aOpMdxQdXSB9V
	TyB131P4nbGNwTs8rP4J+3KFmaX563I=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4CADF5BCDF;
	Mon, 26 Jan 2026 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769435207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b86wKgoVZSbHaNoR6wnTHea67tcH+NoNebqRg4aWBg0=;
	b=G9j7PuKIh7NXQRMmQNLNK3hIUurSeNCwg46GGyc3nX5lY0wwrgphsCdz+/RWdrwK8M6bfp
	TtmnGAx1lASRWj0gVUOlRjXmdaA5ggawWLOMutir2vwK/YizTEOKZ12L3JOPbBzCJ2u7uw
	fpCyc5auJQXC3AS23YWQuGEjDv55v9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769435207;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b86wKgoVZSbHaNoR6wnTHea67tcH+NoNebqRg4aWBg0=;
	b=IVAo7WKywD8H/zeu5CkhipATELpVwhmr9iBvzXei8hafiDEx4WjKjd9rUVt/D/RQuHbTy3
	/YlEAnp1qoK2WGAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769435207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b86wKgoVZSbHaNoR6wnTHea67tcH+NoNebqRg4aWBg0=;
	b=G9j7PuKIh7NXQRMmQNLNK3hIUurSeNCwg46GGyc3nX5lY0wwrgphsCdz+/RWdrwK8M6bfp
	TtmnGAx1lASRWj0gVUOlRjXmdaA5ggawWLOMutir2vwK/YizTEOKZ12L3JOPbBzCJ2u7uw
	fpCyc5auJQXC3AS23YWQuGEjDv55v9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769435207;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b86wKgoVZSbHaNoR6wnTHea67tcH+NoNebqRg4aWBg0=;
	b=IVAo7WKywD8H/zeu5CkhipATELpVwhmr9iBvzXei8hafiDEx4WjKjd9rUVt/D/RQuHbTy3
	/YlEAnp1qoK2WGAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F363139E9;
	Mon, 26 Jan 2026 13:46:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f1wyC0dwd2mPagAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 13:46:47 +0000
Message-ID: <795a4294-001f-4462-8afc-7310e9059943@suse.cz>
Date: Mon, 26 Jan 2026 14:46:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/slab: avoid allocating slabobj_ext array from its
 own slab
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, cl@gentwo.org, rientjes@google.com,
 surenb@google.com, hao.li@linux.dev,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
References: <20260126125714.88008-1-harry.yoo@oracle.com>
 <aXdmN1jUR5bZ6rK8@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXdmN1jUR5bZ6rK8@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: sreqmegogibdchjpt5akx4m1mfawfg3u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C40924000D
X-HE-Tag: 1769435208-513535
X-HE-Meta: U2FsdGVkX19hyGbPFBFp+YuRjRT2USxOts7c02zkkpwEZvLGxRRVlY3vhf2lDyDoroNEU/t3qzipYdbLNYpG9knCoThy/fCL9PM1h9Y6Pev9LVWZGZejjVSzHW+XyCY7AV5pXeIE0uXysPzwSY35CGfqGgkP+56IsAMmyrSwU94t0AedXOt9w1NR+P/KBxC+BzLrsvrGvlLrwDw8sScxg63G4sq+FpfrXzarjtChVxR0DWbp0eV1nHuYDyAmOx2CjhivwO/hi5BparOc3VwUUyIr+aUWLnjxsNIZUue0pKBtTthkf8Q1z0U5mSVQBSyteZG3kcEfqAcA1vAXeJcLFGfIlnpVVKzSAFnktjeYKnxHrsEzxicFEIMqj0x8/MgZtKOo54WIm1LzKFzDEXeGQpC8ugddZ7rIuVGR2o53Yhiiu2tnmSgmeNQAWClYxifKw2uC1ZKmRMUQQkMUr/VKYMOPlFxXIT7la4wO9pTcHnzmMSUkf2M8AtzmCKqgVS1HNjIdM8gWCJOsI3wn0Wbi4/Rf5g0aUNsRhix80Onz6GnJkFYpAYlCJemVzlSCRpuffbAFSPSc/jkKxutOhBOwgY0jf9hzRUATJe9J7d8ZQJRLjWSCNuVPHvF0P/TA2zZcc3PKzGG7vEb8yAhc0K2ibJl0zJaNjqVMCWmSutPjoUSF5eCZauvr7mCE4SFGCnUSUnmVBWlYd4cs9p0OEX7lzvRQThf3UmRgO82c+xXaMkFihgdSMFFbc7ftlmPSZkI75/pxWpEOs70NBOu4hPeRRRsU2naxeIEJh7XTMHjEKYyWNoFVrXcugoinKSNxNZCoJv6zIKPRAvlyVYGJB7bB7l9CcHogPUV0aajd9fG8C3mhDcJESVSH551cpHXbuy7Wnb5GfW/0cJzcAR9v1/mBnU8FOSULh8qshLI04hTEFr8CFhn5F3YnIzylvmsiCxLcFuA8nT2lfWcoLlijSZr
 wnfW8Q2Y
 Ddj9Wc+kb82zRCsOF0fZUrD9qEvvs1/6lBDhAleMw3Nvn8zJsSKBzTzTKIdH1g7iqTMkafjVQtDtJDnA30dNOCLnzRsFr1y/qJ3Zt8Vo3uZtkaF5ua+qovGepEsUBqNM54dS3SMC3+aaugIgvspqLEtAICddLYaY80XCdKBUON8IOQiaMDG8pEEDqnqX3r2bN+ElLIgFUAqmA+FK5mZnPyF65t8O0xev/Wxth2xWf7iNpv9IM0uO6RKXDDOGYf0CNQBpKBugbOaX5Me/2rpWWhpFCsLmViUlG0zKwLbh2Zl/yGwkMe23/cMaxMam/1Q8aqkSPe0+3PVXzcUBFWh5zh5Cto677E7e55s8sbFuZppIZb6BARIrNthkiVgLA4G0RpmmsN/v3n2hqsstLUgYiL/ZFyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 14:03, Harry Yoo wrote:
> On Mon, Jan 26, 2026 at 09:57:14PM +0900, Harry Yoo wrote:
>> When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
>> can be allocated from the same slab we're allocating the array for.
>> This led to obj_exts_in_slab() incorrectly returning true [1],
>> although the array is not allocated from wasted space of the slab.
>> 
>> Vlastimil Babka observed that this problem should be fixed even when
>> ignoring its incompatibility with obj_exts_in_slab(), because it creates
>> slabs that are never freed as there is always at least one allocated
>> object.
>> 
>> To avoid this, use the next kmalloc size or large kmalloc when
>> the array can be allocated from the same cache we're allocating
>> the array for.
>> 
>> In case of random kmalloc caches, there are multiple kmalloc caches
>> for the same size and the cache is selected based on the caller address.
>> Because it is fragile to ensure the same caller address is passed to
>> kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), bump the
>> size to (s->object_size + 1) when the sizes are equal, instead of
>> directly comparing the kmem_cache pointers.
>> 
>> Note that this doesn't happen when memory allocation profiling is
>> disabled, as when the allocation of the array is triggered by memory
>> cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.
>> 
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com [1]
>> Cc: stable@vger.kernel.org
>> Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
>> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>> 
>> V1 -> V2:
>> - Simplified implementation based on Vlastimil's comment
>> - added virt_to_slab() != NULL check before dereferencing it - because
>>   (in theory) it may be allocated via large kmalloc.
>> 
>>  mm/slub.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 53 insertions(+), 7 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index f21b2f0c6f5a..5b4a3b9b7826 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2095,6 +2095,49 @@ static inline void init_slab_obj_exts(struct slab *slab)
>>  	slab->obj_exts = 0;
>>  }
>>  
>> +/*
>> + * Calculate the allocation size for slabobj_ext array.
>> + *
>> + * When memory allocation profiling is enabled, the obj_exts array
>> + * could be allocated from the same slab cache it's being allocated for.
>> + * This would prevent the slab from ever being freed because it would
>> + * always contain at least one allocated object (its own obj_exts array).
>> + *
>> + * To avoid this, increase the allocation size when we detect the array
>> + * may come from the same cache, forcing it to use a different cache.
>> + */
>> +static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
>> +					 struct slab *slab, gfp_t gfp)
>> +{
>> +	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
>> +	struct kmem_cache *obj_exts_cache;
>> +
>> +	/*
>> +	 * slabobj_ext array for KMALLOC_CGROUP allocations
>> +	 * are served from KMALLOC_NORMAL caches.
>> +	 */
>> +	if (!mem_alloc_profiling_enabled())
>> +		return sz;
> 
> Hmm maybe we don't need this as there's !is_kmalloc_normal(s) check,
> but this allows optimizing out the checks below when
> CONFIG_MEM_ALLOC_PROFILING is not enabled.
> 
> So probably worth keeping it.

Right.

Thanks, added to slab/for-next as the first commit of the obj_metadata branch.


