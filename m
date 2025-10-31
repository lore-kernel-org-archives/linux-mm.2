Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A951CCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 10:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894DE8E00C5; Fri, 31 Oct 2025 06:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C678E0042; Fri, 31 Oct 2025 06:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75BCF8E00C5; Fri, 31 Oct 2025 06:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6125A8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:12:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1043149F02
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:12:21 +0000 (UTC)
X-FDA: 84057994482.27.2240DBF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9782440017
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:12:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e9mY7tTE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=565f6VgF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e9mY7tTE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=565f6VgF;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761905538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7ZWVCa5HdJqHfnbABB2XQ+b0al0ZNWNW2eBAd0V6OQ=;
	b=MhvKopGe7wUriozKPNPe1HhizkD0MGu8KOG9Exx6diwBSTIDRDvArGcNxG1yWWs9u1gFhx
	nCyv0sRP0f+eOAmymTaV83ok8+QUVWH0cnmcK3VNawIaTTb6ZFLUvyvy1MyuSfMY1oxrTR
	9rh9LtJNscRQSeC6vEEn73ob5pf9xBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761905539; a=rsa-sha256;
	cv=none;
	b=pKXES+EBn+GAr0q1fhqg0JkxKlr4s1ydBGn+pGbIB27ke3X/ZAzdE8+Yf2DgacvdoVdUWH
	bxEYyTom+c3enbt+VnsRRutZtfFO+W2Yx5KEUtmlLXwG39LFb3WM6N/8KP7ttRAJPIq1Ka
	lW+iyqQvluA60P2kP/TTl10j3kp2ZIE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e9mY7tTE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=565f6VgF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e9mY7tTE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=565f6VgF;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B94621F393;
	Fri, 31 Oct 2025 10:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761905536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/7ZWVCa5HdJqHfnbABB2XQ+b0al0ZNWNW2eBAd0V6OQ=;
	b=e9mY7tTEj4prcYf26NjGrYR1mZCd0XUM75jvoTL+VHX0vtUsjTSvae0A6uVyqezUyrIUqb
	t398teCasIRSjge2CpevCHnimfcMZAS9/v4+twYKc/V4HA0xlX9aN9Dg99Cmb6L4fAOYqL
	lt4rsEO3rET51dFTL9k6PBEC6CkI/b0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761905536;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/7ZWVCa5HdJqHfnbABB2XQ+b0al0ZNWNW2eBAd0V6OQ=;
	b=565f6VgFLGH7l9J8LbjeNycwCdfuoshyh/MyHk7/rDHVKObnfAgtE3bt8BN6+Xc9W/5vq8
	P97z6wYlTzAs/VCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761905536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/7ZWVCa5HdJqHfnbABB2XQ+b0al0ZNWNW2eBAd0V6OQ=;
	b=e9mY7tTEj4prcYf26NjGrYR1mZCd0XUM75jvoTL+VHX0vtUsjTSvae0A6uVyqezUyrIUqb
	t398teCasIRSjge2CpevCHnimfcMZAS9/v4+twYKc/V4HA0xlX9aN9Dg99Cmb6L4fAOYqL
	lt4rsEO3rET51dFTL9k6PBEC6CkI/b0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761905536;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/7ZWVCa5HdJqHfnbABB2XQ+b0al0ZNWNW2eBAd0V6OQ=;
	b=565f6VgFLGH7l9J8LbjeNycwCdfuoshyh/MyHk7/rDHVKObnfAgtE3bt8BN6+Xc9W/5vq8
	P97z6wYlTzAs/VCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FB7213991;
	Fri, 31 Oct 2025 10:12:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h0VoJoCLBGkdBgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 31 Oct 2025 10:12:16 +0000
Message-ID: <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
Date: Fri, 31 Oct 2025 11:12:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
To: Michal Hocko <mhocko@suse.com>, libaokun@huaweicloud.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 willy@infradead.org, jack@suse.cz, yi.zhang@huawei.com,
 yangerkun@huawei.com, libaokun1@huawei.com
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aQRkTKTm08lSJZZi@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 67qd7uojdjeft3us38z4q8t7mzzicsk6
X-Rspam-User: 
X-Rspamd-Queue-Id: 9782440017
X-HE-Tag: 1761905538-109758
X-HE-Meta: U2FsdGVkX1/D0BDfn9k82OwDGYLh4jQEx8KB/ly1kMDYwCVtTf8FfPSbasps0I35CNUdIHHySJ7ZY5nU2xPuX+XjhgTzEaDxw2kcIEUW0JkifWaYROM6TyJx0QiB32dQHHc0ARK6TUJg6dAXX5Fh2FIvP7Vsrib3bVrctYRC0siJvl+GF+pBI4EM5lT1WbhzQRcNTRsNwfYFPsQqlr1/Fkzjesyj9A2Q1a3/eBMWjcxxiHGczDh9/HSE9mNk94n7lfZbRD2WUcOVBNKS8qLzRSraLj91bcfJ42GQk5zl4tSSuluyHjYqid8w1F2VH3jWp0r67hTqUmHYW8vTCWerOsiJxK1ykkSUnT9WHLL+ieUHSjbp1q1PapIaLQb2Ui6ILz0DKR2NlUYEgbMkA+d6e/MtCw2PF0tFgu3+5P6p+OE7RuuRM+yHq4JNAhXca1RpAFYudFkDfTa4t72xN4GHlhHdpajAaH6btfPPJX45YZpBiAycpyUvT6T7k57Sroq8xeFHfUb6vZxOtnfwP2BmL67eD2SM6a6I94XPu1OZAUvj/5FqGlJMJxsctoDALpnam8AVFiZsfUZ7lqNfIX2OfdnudWP6WZaZ63+02EXyLrzFanWGrPLpETw6a9nLvvRQ+5mizqptwx5o1mMEN6VpuMdhgfmnZ2UJ7MLoZAu/Knms0GDcPcy1wlaZfZcyPdsN8Sfpm8X08q6tZ+1uHee3QFEgsT3gaRSEUjYywYYuBim5ec6jYK4ia40PrY0znVKBcTM7U++SNBioRFAq66lqnRiNSQzTcImiT4+Hjms1RP3U7MJvGNlI4471GVAoB4iRU17mRgXGITK4VEEabWvXC4se+xLKb2bQ2yt/vLLaCDXMJbnKvcE2NIM/h+CCOO1Y/I135uJLhGPkl4xAezlzWLjZy41iA8bzGUHwgft6+gjblAro07Qz71IzfUGB+vi8QMN8zGXLglqd4gTU9bG
 g5OiDilU
 QctwvWycqR/9HVo+o7awVI+oS/iOQRYmhKt4fLRdu4lbuFYZeDy6JrJrQCnRWaLL3abBv/+UbcdVQDMVBEXU80piVfpXAXgrr936XXzramjMAKeTgBB8D9DoLosTYhpIuq632j66ggH1RVtFHvl/d8iD8XWf6jfIefGtUpdwI0T2fD4zMGA7excwAz7OzQHo8LXrvFPccVKJqBbWSd2CWZt6petUcgLFG33TndVZMlc8DkUZR9ASgI0tYOiwHtCSO0qjKvmG7gAfcHaaifB1BBrGDm5RR/MJ7WYXhYr2KI494HsWjyEfFFS8sYlBiIVxT/l3uYQqHdosDg+R/6ifi8mJGXWQSviMMIJc5nsXNQ05OOJZ11qze6/C5ACfHHeUvvi3mj/lxMBra0FTJPp6S9LMJehTeWDSU9H3miHesX3H+KZWR48WJzI4N9v3FlQu9nTOzhAkCE27m+6o5g0HlqZVd7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 08:25, Michal Hocko wrote:
> On Fri 31-10-25 14:13:50, libaokun@huaweicloud.com wrote:
>> From: Baokun Li <libaokun1@huawei.com>
>> 
>> Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
>> reads at critical points, since they cannot afford to go read-only,
>> shut down, or enter an inconsistent state due to memory pressure.
>> 
>> Currently, attempting to allocate page units greater than order-1 with
>> the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
>> However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
>> can easily require allocations larger than order-1.
>> 
>> As Matthew noted, if we have a filesystem with 64KiB sectors, there will
>> be many clean folios in the page cache that are 64KiB or larger.
>> 
>> Therefore, to avoid the warning when LBS is enabled, we relax this
>> restriction to allow allocations up to BLK_MAX_BLOCK_SIZE. The current
>> maximum supported logical block size is 64KiB, meaning the maximum order
>> handled here is 4.
> 
> Would be using kvmalloc an option instead of this?

The thread under Link: suggests xfs has its own vmalloc callback. But it's
not one of the 5 options listed, so it's good question how difficult would
be to implement that for ext4 or in general.

> This change doesn't really make much sense to me TBH. While the order=1
> is rather arbitrary it is an internal allocator constrain - i.e. order which
> the allocator can sustain for NOFAIL requests is directly related to
> memory reclaim and internal allocator operation rather than something as
> external as block size. If the allocator needs to support 64kB NOFAIL
> requests because there is a strong demand for that then fine and we can
> see whether this is feasible.
> 
> Please keep in mind that 64kb > PAGE_ALLOC_COSTLY_ORDER and that is
> where page allocator behavior changes considerably (e.g. oom killer is
> not invoked so the allocation could stall for ever). So it is not as
> simple as say this just going to work fine.

True.

>> Suggested-by: Matthew Wilcox <willy@infradead.org>
>> Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> ---
>>  mm/page_alloc.c | 25 ++++++++++++++++++++-----
>>  1 file changed, 20 insertions(+), 5 deletions(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index fb91c566327c..913b9baa24b4 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4663,6 +4663,25 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>>  	return false;
>>  }
>>  
>> +/*
>> + * We most definitely don't want callers attempting to
>> + * allocate greater than order-1 page units with __GFP_NOFAIL.
>> + *
>> + * However, folio allocations up to BLK_MAX_BLOCK_SIZE with
>> + * __GFP_NOFAIL should always be supported.
>> + */
>> +static inline void check_nofail_max_order(unsigned int order)
>> +{
>> +	unsigned int max_order = 1;
>> +
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE

This is a bit confusing to me since we are talking about block size. Are
filesystems with these large block sizes only possible to mount with a
kernel with THPs?

>> +	if (PAGE_SIZE << 1 < SZ_64K)
>> +		max_order = get_order(SZ_64K);
>> +#endif
>> +
>> +	WARN_ON_ONCE(order > max_order);
>> +}
>> +
>>  static inline struct page *
>>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  						struct alloc_context *ac)
>> @@ -4683,11 +4702,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  	int reserve_flags;
>>  
>>  	if (unlikely(nofail)) {
>> -		/*
>> -		 * We most definitely don't want callers attempting to
>> -		 * allocate greater than order-1 page units with __GFP_NOFAIL.
>> -		 */
>> -		WARN_ON_ONCE(order > 1);
>> +		check_nofail_max_order(order);
>>  		/*
>>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>>  		 * otherwise, we may result in lockup.
>> -- 
>> 2.46.1
> 


