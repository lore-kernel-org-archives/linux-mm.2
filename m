Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE5F4C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4023E6B0088; Wed,  8 Jul 2026 23:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B01A6B008A; Wed,  8 Jul 2026 23:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29F896B008C; Wed,  8 Jul 2026 23:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC1D26B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:32:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 544C1403BA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:32:18 +0000 (UTC)
X-FDA: 84967815156.24.8C86F58
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69F554000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:32:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FbDtmCeq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783567936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jDoZLHWbYIdhVmxG+MA9e6bYh0sILt2qEN09TqIC+I=;
	b=Im5U+TF8Az6UolZGbAvoxlvom4tZVk85feRJ7+2Xpb1fSTQsDVemi16JcW8DId806kqFmb
	0Q51CAk8j8XlpmPrilYErVWdtGSUWGpgZcJblrdODA++CwHlORM5PoDl8gIs5EFxinHcBG
	CaoZWrdhM9RI8rJQvw0kMzPV8O2PHfc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FbDtmCeq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783567936;
	b=8FV46P+gYULvnxF7Sgm0ZT0OwZy25z8j/YpIQs+8aiHLs51Vk6UVZzfhicX9svrs/Vp6CA
	z4vezN1TLdAT9BLQ5FJWNK1o/3WPmnHJXd+B1hKTcPUdMfOiGADYZ3t7QhLVlS+HKePpJW
	gXMHkUQB9CC1HCWA2FvDWwGbeBeJp0I=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-ca24d39d8a4so744224a12.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 20:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783567935; x=1784172735; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+jDoZLHWbYIdhVmxG+MA9e6bYh0sILt2qEN09TqIC+I=;
        b=FbDtmCeqH29uBd33+TRtgXSNI26XliNjkmbzILOMc6a0UWb26ftZC/1sLaT5kYTRZD
         u65yr/9L7YeSM5y7X3Lwd5Hy0Cl7pXbge2iHrcVVmQM6YwNk25ofWmgfLy25GHOeEnsO
         vfRnngQcW6C8Zikki0W6McdnDYM33Lv0htbn+O1L9xdnsblvL4pssaGyax6tbILI8O/p
         o45TcfkLpzUox35UvaDEdxV2FPDXm0tRZN5fnmXPTZGnHaUZti6Bz0iFkHdnCQ6v5N6Z
         4sxmtnwjvKtobCF+W5Hij0aLMPVpp8sp/e1W/LnIvkLSsQaijFyfejEqLi/6viSAsWlR
         vLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783567935; x=1784172735;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+jDoZLHWbYIdhVmxG+MA9e6bYh0sILt2qEN09TqIC+I=;
        b=CJoFpbWqpdDCK1S8nYeufwvNzBQb0tYYeaMtlXWbJbJs26vhBZsyghoLyHzM575aaG
         MV+89bfX0dq3dAWXCF5RFMpO0b9ijFzfHuUt9Bk/UuPZD+ctt190V2PROd3syM/bRF2g
         2FY7c53OWAlAWMPycllp5K/krvaCIVT/25NmQ2dxQCJmMYuP7oUpTuUZvSOuRbP2aGBF
         i9SAKsV/YZTKxdwcfnjHSgyFVr5W0kbP6oQnSEKwSFRZNJn6Nm4zEJgIn4arGb1VcMng
         cOMeR2a2fSlyfjPwG9YwyJWsspjWLegEPA6cxPqX9gHFvdlTUeMiip8oa3PB687DquKq
         SepA==
X-Forwarded-Encrypted: i=1; AHgh+Rq3w26ADOBIbyZSx9PTlhO2ohXZxkQejQRsNeB2YftNNN8qyktxJRkn0EI/VhS+otQEKc2T5ByS2Q==@kvack.org
X-Gm-Message-State: AOJu0Yx+h9+L5Ep4AjEFLPXuDS6e6DHopSis+iuboT2GboFOE+itxWT1
	ZA3/ECgZvxeJJm3m+vmsixr+wTK1v+slYizooUn8g5WysFmS6gb8FnJs
X-Gm-Gg: AfdE7clkA58zf47IT0iuOVuGdapE6nFGEMV2THLsPJfnEh4LbD9XKSyaCA/LYkQMrH8
	IU25HNQwBzkIO9lDnDrv3/KQGYFmIKawFqXJVVLksdrnT2osdHmmwto3lnIHAfDu+NPwL8jpM97
	I0/czXRFNGuI5GkR2b8G6luWEeAEw6CfeMo6ATm4Q7szJELvHO80DPeFmtaSkVQI9438UqvJxOg
	GW3Vb4vr7y8qBMEXpdeH/i/Raocj54xjGZyVYpBPoECC4MdGoHuLGa8jlxLaglq3bkadaKshfV+
	eJM4PJByl7w/XeRBdh+ior/iZzF5iukKqDe97mVJtAQoX5g+OUoRCTO8gmHwdR7Kgnh8iS1IaoP
	WsxnR/HLWWlJfdm4P6tlpgmA9PMFIBHaCeRrGsn7TubmKn6C+Spx6uJ9Q6Gb3U2y3HFc3CtlfUE
	z7CvPSLoScVhT1efh44X7HDZ/giQonLNg=
X-Received: by 2002:a05:6a00:66d7:b0:848:56ff:6ce4 with SMTP id d2e1a72fcca58-84856ff6faamr1476773b3a.5.1783567934924;
        Wed, 08 Jul 2026 20:32:14 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8485a44876csm308022b3a.27.2026.07.08.20.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 20:32:14 -0700 (PDT)
Message-ID: <c372e68f-2bfc-45b6-a431-01bf55717247@gmail.com>
Date: Thu, 9 Jul 2026 11:31:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Wandun <chenwandun1@gmail.com>
Subject: Re: [PATCH v2 1/4] mm/migrate: do not migrate folios mapped into
 VM_LOCKED VMAs under compaction
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org,
 mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com,
 fvdl@google.com, bigeasy@linutronix.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-2-chenwandun1@gmail.com> <akz7ythMxfIZeT0d@lucifer>
Content-Language: en-US
In-Reply-To: <akz7ythMxfIZeT0d@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 69F554000A
X-Stat-Signature: fqpdzdqbgzgz43k7ei9f4gpdkggg5uwk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783567936-303027
X-HE-Meta: U2FsdGVkX19lBbinHLupQLuJWaSMevZNlwd2t5E6K0OEPHNG/GUvpqwsphsXND3QMg9/hFPqyiyxBO3cb0RyQYulO2mTB/pQW1VzJcegFRHGxm1HEtzIuVEu/Go5u5UxjffVYIMh6pGXY3CAzDWVsNl8d8uQhYK01k3m4P2F3Noq2uCJqbhOfCs6uizhFGReOK8XNlOVKwtu42/j/9decL9dFIvon7NlcgYGzM6duHOXZ+62ooiJpQeuuFl116WSFmoSOF9nRPo91vmCoM38EqYWeiCmuXBQ3n351xQr7R05YorDYXYiBhJYXLdXcx8wORnRsTRGLvSm1mOFcz9aXst8D6tZhNCqpTvpdCRHdqeYL951rpGqCs0RJuagSrDM8xdtGw02wfJNlINbuzLgYpHNX8sBE2GxJmyZzahUQKXL6RfNE7o43XpW+glmf1nxXahzx+7pF4EKhYqTcnteWRfgerd/ESnz8AR4N44UBU2b4WMy0JBJ4MB0/aRu/FYpBipnYDNJ51hGjYq3sOa/0gtJuoClmJn+ThjUXx0HxVmJhg2A459vlhJyC46/vZaWdTDHpQi66Ffvbll/zkvcz9P7vkmEaJzs0z0YrAjehPoYuyXVETlFJwxNAJUAnMXYiajztVc9EgEoGzY7ohmJ8tYXm6NvwxtwYm8E2NY2dglCqHX+x+O8gA14ntEY7EpVkcl8c2mdA0ntkF1kslVM0BunkDEw+yORkos3dnzhZoXIWDP9z2mWt5fNACy56nrLW2SUuAzP6BKhjyoZ4z1X0pc3Hr9U/OM0Ti2XmWoxclotxWCldAnz1SVkdsdui56IV4ttxYkbyicYn0T6B4+IdRy20J1Us0b6D8jMYnxqrwLcEvSvs8ebsiNeCTs+TnXbgnWqV0rM3wbzfxX1c8Qp9m+6cEAB8701nIQOAQFRG6KadYw5i55Fri6ilcWUKfUorLEoTx/ITi2bDu2kjZQ
 r1jk3wn+
 tmealXfoA0U6QG7HuG53WxXhUhuho7lTcusK+7CZD03TvqvAu7P37eeIy9ILdH+pJDCWYHAWvO2BPfZe3fyau5x39jC93fzFm/tWaWurbDnJO0O193eAAvRg8vfNX7qX64/BJGvhfNQt3Y7oK6ByIRSYTbxVW7sMRgkuMdXJUEdx3A6p3d2qDN7R4UNRXcBtybiLIhIF8sPFFt5Cqq7WYtcAgmE7Mt5tKKAbeZiVuItQr8wvnAoXSXm8AnKQ1De2NLzpZ3B/d8lnCrZiBMtxw+IJBx4pACB6/nBUzEhHY+pKf2Xixeb2wucZE2kg34mqYKpGMpGxDLmCnU90otdrUyPbW613keg2Iu6RK/s4khoeF0q9sBvwXV2TU/T1Z+jJtLWLBYy0ZvYCJwE7hi20IYC7bZ8XWYe89/ofhAcc4feOLpwy1RScspogepqepZD5arhh9QRlDI/MY0MY5hgOBbgzMuNpbTZp4NgpUdocopB6cGQ7++5ZNuDVTX5rfOy5zOiN7MICVLeblZAgt9hG8eE0tOBJJlmHBBXrVAneIKTwaPZg8q88OZy/npg2ZVhzn7i+pdLB7AZOAmuvGz/u1ONia67qHtr2+GCm38dU0rMRZ3UzMg6lLthbv/3Qag/5uJsIcB2ls7E7AA9kFUL3CCD1csgXqbf8Z6TKwkVJPtJJnjCoL/NKUl5PUtw3kSmUfCXRg7mb33v7kfmrtkoyici/44xoYif3tKJ1N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/26 21:44, Lorenzo Stoakes wrote:
> (Being really nitty, your subject line is too long)
> 
> Please don't reference legacy VMA flags for newer patches 'do not migrate
> folios mapped into mlocked VMAs...' works just as well.
Got it.
> 
> On Tue, Jul 07, 2026 at 08:59:22PM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> When compact_unevictable_allowed=0, unevictable pages should not be
>> migrated. However, mlock_folio_batch in the mlock[all] syscall introduces
>> a race, mlock_folio() sets PG_mlocked immediately but defers PG_unevictable
>> to mlock_folio_batch(), causing pages that are about to become unevictable
>> to be migrated, which violates the intent of compact_unevictable_allowed,
>> and causes spike latency in RT kernels [1].
>>
>> In order to fix this, migration is forbidden for pages mapped into VMAs
>> marked with VM_LOCKED. In addition, two early-return paths are introduced,
> 
> Please don't reference legacy VMA flags. -> VMA_LOCKED_BIT.
Got it.
> 
>> filter out mlocked pages, return early to avoid unnecessary operations.
>>
>> Fixes: 90d07210ab55 ("mm: mlock: use folios and a folio batch internally")
> 
> Hmmmm why do you think my patch caused this? That was just a folio conversion?

Oh, I made a mistake, your patch was just a folio conversion.

Batching mlocked page was introduced in v5.18 by:
	commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")

Setting sysctl_compact_unevictable_allowed to zero was introduced in v5.7 by:
	commit 6923aa0d8c62 ("mm/compaction: Disable compact_unevictable_allowed on RT")

So this issue exist after v5.18.

> 
> Also I didn't think we liked having fixes spotted about a series with non-fixes
> tags?
Got it, will split this series in next version.
> 
>> Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
>> Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/ [1]
>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Link: https://lore.kernel.org/linux-rt-users/33275585-f2db-4779-89f0-3ae24b455a67@suse.cz/#t
>> ---
>>  include/linux/compaction.h |  6 ++++++
>>  include/linux/rmap.h       |  3 +++
>>  mm/compaction.c            |  8 +++++++-
>>  mm/migrate.c               | 23 +++++++++++++++++++----
>>  mm/rmap.c                  | 12 +++++++++---
>>  5 files changed, 44 insertions(+), 8 deletions(-)
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
> 
> Don't use extern. We remove extern as we go it's not needed.
Got it.
> 
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
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 8dc0871e5f00..359c7426b6b9 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -102,6 +102,9 @@ enum ttu_flags {
>>  					 * do a final flush if necessary */
>>  	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
>>  					 * caller holds it */
>> +	TTU_RESPECT_MLOCK	= 0x100,/* leave VM_LOCKED vmas mapped instead
> 
> -> VMA_LOCKED_BIT please. Also maybe just say mlock'd?
Got it.
> 
>> +					 * of installing a migration entry
>> +					 */
>>  };
>>
>>  #ifdef CONFIG_MMU
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index f08765ade014..5d256930e389 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1116,7 +1116,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>  		is_unevictable = folio_test_unevictable(folio);
>>
>>  		/* Compaction might skip unevictable pages but CMA takes them */
>> -		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
>> +		if (!(mode & ISOLATE_UNEVICTABLE) &&
>> +		    (is_unevictable || folio_test_mlocked(folio)))
> 
> Maybe just change is_unevictable to include this check?
> 
> Like:
> 
> 	is_unevictable = folio_test_unevictable(folio) ||
> 		folio_test_mlocked(folio);
> 
> ?
Sounds good, I'll fold mlock into is_unevictable so both checks
stay consistent.
> 
> Also later you have:
> 
> 		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
> 		    (mapping && is_unevictable)) {
> 		    	...
> 
> Which doesn't account for mlock as-is? Is that correct?
IIUC, The is_unevictable check here mainly serves as a cheap pre-filter
for inaccessible mappings (which are always unevictable folio).
It's unrelated to the mlock.

> 
> 
> 
>>  			goto isolate_fail_put;
>>
>>  		/*
>> @@ -1898,6 +1899,11 @@ typedef enum {
>>   * compactable pages.
>>   */
>>  static int sysctl_compact_unevictable_allowed __read_mostly = CONFIG_COMPACT_UNEVICTABLE_DEFAULT;
>> +
>> +bool compaction_allow_unevictable(void)
>> +{
>> +	return sysctl_compact_unevictable_allowed;
>> +}
> 
> You add this helper but isolate_migratepages() still references
> sysctl_compact_unevictable_allowed directly?
I'll route that reference through compaction_allow_unevictable()
in next version.
> 
>>  /*
>>   * Tunable for proactive compaction. It determines how
>>   * aggressively the kernel should compact memory in the
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index a786549551e3..3a15eb13e82b 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1202,7 +1202,7 @@ static void migrate_folio_done(struct folio *src,
>>  static int migrate_folio_unmap(new_folio_t get_new_folio,
>>  		free_folio_t put_new_folio, unsigned long private,
>>  		struct folio *src, struct folio **dstp, enum migrate_mode mode,
>> -		struct list_head *ret)
>> +		struct list_head *ret, enum migrate_reason reason)
>>  {
>>  	struct folio *dst;
>>  	int rc = -EAGAIN;
>> @@ -1210,6 +1210,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>>  	struct anon_vma *anon_vma = NULL;
>>  	bool locked = false;
>>  	bool dst_locked = false;
>> +	enum ttu_flags ttu = 0;
> 
> You reference ttu only in an if-block below no? So why are you declaring
> this here? Move it to the if-block.
Got it. I'll move it to the if-block in next version.
> 
>>
>>  	dst = get_new_folio(src, private);
>>  	if (!dst)
>> @@ -1249,9 +1250,15 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>>  		folio_lock(src);
>>  	}
>>  	locked = true;
>> -	if (folio_test_mlocked(src))
>> +	if (folio_test_mlocked(src)) {
>>  		old_folio_state |= FOLIO_WAS_MLOCKED;
>>
>> +		if (reason == MR_COMPACTION && !compaction_allow_unevictable()) {
> 
> This should really be a helper since you repeat yourself and it's not
> obvious what this is checking.
> 
> Like:
> 
> 	static migrate_mlock_allowed(enum migrate_reason reason)
> 	{
> 		/* Only compaction is disallowed. */
> 		if (reason != MR_COMPACTION)
> 			return true;
> 
> 		/* If we can compact unevictable folios, we are ok. */
> 		if (compaction_allow_unevictable())
> 			return true;
> 
> 		/* Conservative: if any folio could be mlock()'d, disallow. */
> 		return false;
> 	}
> 
> Then you could self-document what you're checking and avoid code duplication below.
Got it, it is more clear, thanks.
> 
>> +			rc = -EBUSY;
>> +			goto out;
>> +		}
>> +	}
>> +
>>  	if (folio_test_writeback(src)) {
>>  		/*
>>  		 * Only in the case of a full synchronous migration is it
>> @@ -1324,7 +1331,14 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>>  		/* Establish migration ptes */
>>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
>>  			       !folio_test_ksm(src) && !anon_vma, src);
> 
> Useful to convert VM_BUG_*() -> VM_WARN_*() (possibly _ONCE() here also) as we go!
Got it.
> 
>> -		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
>> +
>> +		if (mode == MIGRATE_ASYNC)
>> +			ttu |= TTU_BATCH_FLUSH;
>> +
>> +		if (reason == MR_COMPACTION && !compaction_allow_unevictable())
> 
> See above about deduplicating.
> 
>> +			ttu |= TTU_RESPECT_MLOCK;
> 
> Hmm. I don't love 'respect mlock'. I guess we only know about the reason
> being compaction here.
Right, we only know about the reason.
> 
> But I'm confused anyway. We have the folio, why aren't we just checking for
> PG_mlocked() here instead of getting the rmap to see if it's mapped
> anywhere with VMA_LOCKED_BIT?

There was a race scenario without patch 02, vma may already marked with
VMA_LOCKED_BIT but folio has't marked with mlocked, such as below:


CPUA: mlock()                                  		CPUB: compaction / migration

mmap_write_lock()
    mlock_fixup set VM_CLOKED
    mlock_pte_range
    	mlock_folio(page N)

                                             		isolate page N+50 (mlock hasn't reached it)
                                            		migrate_folio_unmap
                                       			folio_test_mlocked() --> false, but VMA:VM_LOCKED
                                       			try_to_migrate()
                                         			rmap_walk(P) [anon_vma rwsem / i_mmap_rwsem, read]
                                           			try_to_migrate_one -->install migration entry
        ...reaches page N+50
        skip migration entry (without patch 02)
mmap_write_unlock()


access page N + 50 --> wait for migration complete
							
							migrate_folios_move
							....
                                             		migrate complete



If apply patch 02, mlock itself will wait migration complete, so checking
VMA_LOCKED_BIT in the rmap path is no longer necessary, but this logic is
retained to avoid unnecessary migration operations.


> 
>> +
>> +		try_to_migrate(src, ttu);
>>  		old_folio_state |= FOLIO_WAS_MAPPED;
>>  	}
>>
>> @@ -1905,7 +1919,8 @@ static int migrate_pages_batch(struct list_head *from,
>>  			}
>>
>>  			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
>> -					private, folio, &dst, mode, ret_folios);
>> +					private, folio, &dst, mode, ret_folios,
>> +					reason);
>>  			/*
>>  			 * The rules are:
>>  			 *	0: folio will be put on unmap_folios list,
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 0fb7a1b82cf3..3cb7f6337d38 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2420,6 +2420,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>  	unsigned long pfn;
>>  	unsigned long hsz = 0;
>>
>> +	if ((flags & TTU_RESPECT_MLOCK) && (vma->vm_flags & VM_LOCKED))
> 
> Please use the modern API for VMA flags. So:
> 
> 	if ((flags & TTU_RESPECT_MLOCK) && vma_test(VMA_LOCKED_BIT))
Got it.
> 
>> +		return false;
>> +
>>  	/*
>>  	 * When racing against e.g. zap_pte_range() on another cpu,
>>  	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
>> @@ -2741,11 +2744,14 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
>>  	};
>>
>>  	/*
>> -	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
>> -	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
>> +	 * Migration normally ignores mlock, but TTU_RESPECT_MLOCK asks it to
>> +	 * leave folios mapped into VM_LOCKED vmas alone.  Only TTU_RMAP_LOCKED,
> 
> Again -> VMA_LOCKED_BIT.
> 
>> +	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, TTU_BATCH_FLUSH and TTU_RESPECT_MLOCK
>> +	 * are supported.
>>  	 */
>>  	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
>> -					TTU_SYNC | TTU_BATCH_FLUSH)))
>> +					TTU_SYNC | TTU_BATCH_FLUSH |
>> +					TTU_RESPECT_MLOCK)))
>>  		return;
>>
>>  	if (folio_is_zone_device(folio) &&
>> --
>> 2.43.0
>>
> 
> Thanks, Lorenzo

Thank you for the detailed review, Lorenzo.
many of the comments are very meaningful :)


Best regards
Wandun


