Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35EC3CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 11:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C166B008A; Thu, 18 Jun 2026 07:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1235C6B008C; Thu, 18 Jun 2026 07:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A8D6B0093; Thu, 18 Jun 2026 07:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4C976B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:54:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 866D4A0646
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:47:55 +0000 (UTC)
X-FDA: 84892859310.28.9030FE0
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	by imf15.hostedemail.com (Postfix) with ESMTP id 93CDFA0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:47:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OsNl+GUA;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781783273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgJSxfkbpRL1li2RmiPzgr2AwPNLZXo7UF6R1jDsgxA=;
	b=cIyJ7NXFKlGgnyizu04hc43DtXI1a3htl/OBPCtGR2iblU8yE3b6bFLGereuz7mc9GOhqH
	2j4QtoHIGMMQBqK2qITeJ+LHoEXxKXrq2Tn9s5kj6vVg3CcwZ4EnEnO/e0kFex5lZU3QZF
	gT4uE9cFDpsQPAZJja89NP3iJRtvTxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781783273;
	b=FjAXMCXsFy9ohv9VNm2cg/4Jq7ucWuSkmHOUpvbXyl/mbaAlLHLHKH3ri62F6paI4XwNHf
	J0yvNR99Kc4ildwI2bmrWlgMb98IHFSuwvd5ouH8eajdmoMVL1nS3HLyNvpDozzJP4lN9c
	TeA5aleW2j5sXFNocLm6bYSQMOTzB6A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OsNl+GUA;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-36da151a152so490918a91.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781783272; x=1782388072; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hgJSxfkbpRL1li2RmiPzgr2AwPNLZXo7UF6R1jDsgxA=;
        b=OsNl+GUAV4gM4/OfsHENCqe/kdxeidft3Vu2gRn1Z/M1MvNj7IlC6EokM2zqHyKqLg
         VKBnYnVs739yKtBBu/HxqeaEGXmFN76e67wUrkPBJz9OWYL9/5ejaabznmK5pVeDVJSb
         1K421OdC3GrbdOe5qFredL3gJfqmpX5PkA5FqyMUS6uuBW5hx87iV0kHFq2HlhYrI1Tu
         vbeQf5me+OxXu0Zcc3xqWmLTMTeKnGArLhoHaj6t5nUosBv2lpM/g2RUrPS5Z1+mfRLh
         JSKP5wMKtyW8iWtBNBdDwczqfEXZO8mkX70nmgQgGDmKpIGHeEXVkLpCURSl++7eWrn/
         Vrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781783272; x=1782388072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hgJSxfkbpRL1li2RmiPzgr2AwPNLZXo7UF6R1jDsgxA=;
        b=V2+v41VjlSD/h9th8Dvf3ayObPd4Ebw//6SK+Wvztj6zgzWFg5BsIdQTAgv+WAEzps
         NWvS+7hIG0WIw/+zJaNzIeR4Cm9XhjdsQy3gNhFbW3GTkOGXhiI/S3drobmfeI0tKmDh
         c4AckS97ZP8zaY6Jq+EY9Vd7rbgGpF8FHYS+9oJtIyPTUvPgMznzdN70OTZgpePvRvHl
         HpbpSsAKquF8tY52txHuuWn0lAAxWsUpHVSJaBtQAGIu0n1RPADixTLDsZ8X3bmn9yBd
         fLA6KaiiLFHXAcGvKWL7wo/1zhg4wPSLZC5bA2eLyP2QcJTEc3cFK3/LBunLHEEuifOW
         Ogcg==
X-Forwarded-Encrypted: i=1; AFNElJ+grs9qCcRBQxaJa63atuq9ee00FKLa8M4c28nV13QZEfFJbk833bt17g3Nm+/AG3l2kyevBAtiCA==@kvack.org
X-Gm-Message-State: AOJu0YwDvdLviaqLZbbSPH5EC3GtC0rS6JqsoqzIqLEarCef+rQtuvpv
	Xoq1DOdTXDWM1JHCFfBZGiZ4//KApCqXByGtpjMxJwM7+qSrPMnIpt8j
X-Gm-Gg: AfdE7clooLpZ9DU6RdSVVHoorg2orQIMCSW1aKS8EGQFAY5ZXqVGz6uLfpDq89dVaGn
	/RbUZreDnvW48q7t8m8c2EluExGtrSVJd5aWvt/8921cCSzZ047nnFUL8krgeo4wZ+QOOp8eDb3
	Qx+I/4NnJZGURmUpvBpRMIbLOgoH1V0J/7/zvpbUGCGsPHtk3rKDHiaXoNKpLsZh1FnAfbaVhYi
	tovyzoaA4mj7/6vzFQpoJf/7B3KbT78TrKQbwUgL2wJethgIjl1eNKXpWdSLXsA7aWPbWFH/75+
	rM4g6jI/HhsKxtw+Wc1DQfGkBdott9K4iPQjuvPH7o7kEBnYNCrV+55NqkMP/N+luXcHFonpKOW
	4nmfDzB9nmz1DADa/kx2RbVjHIsqQmEjB4HnxTvHzBkL87nPlaIJSifJz7OiDgM4+mI3W4gTBQt
	ntuJfXf1yR0P80rrzmbtU2tfn1HFgiqkM=
X-Received: by 2002:a17:90b:4c84:b0:36b:9798:4f67 with SMTP id 98e67ed59e1d1-37ce44caf41mr3737106a91.8.1781783272420;
        Thu, 18 Jun 2026 04:47:52 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521ca980sm9530544a91.6.2026.06.18.04.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 04:47:51 -0700 (PDT)
Message-ID: <b5605aef-c3a3-4a35-aceb-d1df3c9a7f4a@gmail.com>
Date: Thu, 18 Jun 2026 19:47:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] mm/compaction: respect
 compact_unevictable_allowed in alloc_contig path
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, Alexander.Krabler@kuka.com
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <20260604023812.3700316-4-chenwandun1@gmail.com>
 <9890b8f5-69b9-49bc-8ed6-ea47723b644e@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <9890b8f5-69b9-49bc-8ed6-ea47723b644e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93CDFA0005
X-Stat-Signature: 93sor9d3hmubiaak4ww4zboxxdhpesqe
X-HE-Tag: 1781783273-174216
X-HE-Meta: U2FsdGVkX1/D2psLlOuctjVw5ndeXtIKgeNRXCFPe2mSAOi44sMDSJhXBnzzCs1zIhpID9xJZYSsxmA+3TIZzxy2+Ad/+Pu5JsIFZVlhnrQl8V1aXWaNcvvLVXzHbEWcXq5vpHQh7444FN3dh6ShaThjsMm/JOejeIlgyZSND8r/mlwpX7XPRJAxEIyNsjy9BJ1FsJLYFX2ABhKdzLo2U16x6TIr3k+O10G/T74Rz4/vJCphPq7RfsFScbp9mZ3dPp0EEEc9/H08to4Knj8xMTZ5mgrJJIxFPQfgreViDBKBdyDEfrVEcpRiko/E/1dfhTGJWWyx1N5jTkteTQHmhVUDyrN6sgANA0boE2XF8ph7//gyeyAg5EIpi6+A9czyYE93p+utd7WaZrRljAnge+Gq0TxE2vj2KaoIKQNBFvfkE8LdqDJmj2+f8rcxrWEeU8cDk7XT5viJKxOuXP3Eb8UKQSXjCcNkDc++s8BwzLS3t72dbJqzRoOXKRaI6vgZmW9xs0wnRLBiOMeGFFr1B7Sl4Hb67/MLG4f2sQXnc64xcq93/WDOGB7yKg8JyThJ6HeaAZk+G2e/TTQ1PvQTG+rtpPeB25QDzaDrrEHv0pQsAwT0CDUTJr4dSUPtYJ6x+GMtkR8FocvcNdC0XtpG3oKEoZnwacN8qVWYWACY4fVhB04WhOQlWCIY/ZTYB7bEGTHxXY4Zo/oFxGZBsVK/FWnggLiNtqiF51dW6hPyLbNFCfnf1nb+s7PcYioFWFZgEQIt9wB/9fzbpJaUrYzst+HkfcwW1sBy7HgHmwkinfeuBQg5dCL3G5bis3LwmzxaN8jARMn2DrYhtXw86BQn71tfLwhoq5u1Ig6Um/wUN1n8u/bBcLMFLBPkJqOxZIN9K4/cjsK7LEnLDckiRXzHeL+SdmMZ8FpwckXjP/+U7x3t49yIwOZo2rhHBXnvwht6xVo4beqUk+XkMkv1EfT
 krOfpiOo
 RrGM8jcY1BbNHzNxMf5ZaLZKJn3Npp8CxyGSOZ4cmy+8XwE/26Hb4x9SNyZUfpUa87W+B40CVF8snFdtaWsu7HePmRzNX8sDoZt3ZL2phcSIvL2OjgN9pPPr8HJwG0FtK3Z7v2pyfsw9zhYaXFyf4/30horkoJnsud/liLWHMlk/Vm9PlYNH1TIsZBAGzkemuU7qsfj1uXSrRDCj/S45GGLikoRo5i3g0UQ5XSH2Jbfy1r20fiso6d0b0/3HUKeyAbk9e629t2bVLoITp6zxNPl/RDA2vpSHXyGr8t7ga3KhVXf7sV234YhUx1U79XbK/SKbbPM+JKG4eCqZA6pE2WXdWJqb0Oo9G0Id2KjRPqjFFveOea4G8fGknp2rDu/hpgvvs2O+SPMVI7TWw/c5iAv2Y6hRbdgJP5fjAN3dQgeLB3gPL/6z6U4z7Fan7b8d962DguR/sWnYLmduTmGoRwALjZhtB/jjxvY5P7KpA8E/egMgZq2OH6wpMEkWbIvWi8bsk8r0dvAfMmSTpoZ2I4QKCpK5ed2UZIN1vndyc80ZLh5mpUJVZ5whghk3jjiUAb35t4y8A5YP3esPUOlIM5X+mtwhls2c+jLrSkG0DLB0kgkOExR5Uh7P+rKC9mdk4TC+I73GSzSjVLVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/26 02:57, Vlastimil Babka (SUSE) wrote:
> On 6/4/26 04:38, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> vm.compact_unevictable_allowed=0 is used to prevent compacting
>> unevictable pages. However, isolate_migratepages_range() passes
>> ISOLATE_UNEVICTABLE regardless of this sysctl, so the setting
>> has no effect in the alloc_contig path.
>>
>> Fix it by:
>>   - Keep ISOLATE_UNEVICTABLE for CMA allocation, discussed in [1].
>>   - Honour sysctl_compact_unevictable_allowed for non-CMA allocation.
>>
>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Link: https://lore.kernel.org/all/25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz/ [1]
> 
> There was also the "Ideally by not having mlock'd pages in CMA areas at
> all." part. Is it the case? It was more elaborated here:

Yes, It is the case.

> https://lore.kernel.org/all/CAPTztWZpnX1j8-7yeppVUsxE=O9hbVeqricDjZt8_pnN7a-kBQ@mail.gmail.com/

I missed this important information. Thanks for pointing it out, Vlastimil.

Best regards,
Wandun

> 
>> ---
>>  include/linux/compaction.h | 6 ++++++
>>  mm/compaction.c            | 9 +++++++--
>>  mm/internal.h              | 1 +
>>  mm/page_alloc.c            | 2 ++
>>  4 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>> index f29ef0653546..04e60f65b976 100644
>> --- a/include/linux/compaction.h
>> +++ b/include/linux/compaction.h
>> @@ -106,6 +106,7 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
>>  extern void __meminit kcompactd_run(int nid);
>>  extern void __meminit kcompactd_stop(int nid);
>>  extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highest_zoneidx);
>> +extern bool compaction_allow_unevictable(void);
>>  
>>  #else
>>  static inline void reset_isolation_suitable(pg_data_t *pgdat)
>> @@ -131,6 +132,11 @@ static inline void wakeup_kcompactd(pg_data_t *pgdat,
>>  {
>>  }
>>  
>> +static inline bool compaction_allow_unevictable(void)
>> +{
>> +	return true;
>> +}
>> +
>>  #endif /* CONFIG_COMPACTION */
>>  
>>  struct node;
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 007d5e00a8ae..a10acb273454 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1341,6 +1341,7 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
>>  							unsigned long end_pfn)
>>  {
>>  	unsigned long pfn, block_start_pfn, block_end_pfn;
>> +	isolate_mode_t mode = cc->allow_unevictable ? ISOLATE_UNEVICTABLE : 0;
>>  	int ret = 0;
>>  
>>  	/* Scan block by block. First and last block may be incomplete */
>> @@ -1360,8 +1361,7 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
>>  					block_end_pfn, cc->zone))
>>  			continue;
>>  
>> -		ret = isolate_migratepages_block(cc, pfn, block_end_pfn,
>> -						 ISOLATE_UNEVICTABLE);
>> +		ret = isolate_migratepages_block(cc, pfn, block_end_pfn, mode);
>>  
>>  		if (ret)
>>  			break;
>> @@ -1902,6 +1902,11 @@ typedef enum {
>>   * compactable pages.
>>   */
>>  static int sysctl_compact_unevictable_allowed __read_mostly = CONFIG_COMPACT_UNEVICTABLE_DEFAULT;
>> +
>> +bool compaction_allow_unevictable(void)
>> +{
>> +	return sysctl_compact_unevictable_allowed;
>> +}
>>  /*
>>   * Tunable for proactive compaction. It determines how
>>   * aggressively the kernel should compact memory in the
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 181e79f1d6a2..163f9d6b37f3 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1052,6 +1052,7 @@ struct compact_control {
>>  					 * ensure forward progress.
>>  					 */
>>  	bool alloc_contig;		/* alloc_contig_range allocation */
>> +	bool allow_unevictable;		/* Allow isolation of unevictable folios */
>>  };
>>  
>>  /*
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 81a9d4d1e6c0..1cf9d4a3b14c 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7118,6 +7118,8 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>>  		.ignore_skip_hint = true,
>>  		.no_set_skip_hint = true,
>>  		.alloc_contig = true,
>> +		.allow_unevictable = !!(alloc_flags & ACR_FLAGS_CMA) ||
>> +					     compaction_allow_unevictable(),
>>  	};
>>  	INIT_LIST_HEAD(&cc.migratepages);
>>  	enum pb_isolate_mode mode = (alloc_flags & ACR_FLAGS_CMA) ?
> 


