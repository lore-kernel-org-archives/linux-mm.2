Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D6D606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 04:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z8TXECTu
Received: by kanga.kvack.org (Postfix)
	id ECD026B0668; Wed, 18 Nov 2026 23:31:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57346B066A; Wed, 18 Nov 2026 23:31:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F316B067A; Wed, 18 Nov 2026 23:31:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7D806B0668
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:31:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44EBBA869C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:31:49 +0000 (UTC)
X-FDA: 85450595538.11.118343A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 52AB710000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:31:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z8TXECTu;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795062707;
	b=uJqwkoqi7foUfniJbpuz1xQPE4DNwPgDnilJgFVIR8K6oLmkdGSb7GoSo1b+ZNNfSbGndH
	WyjUh1d2xDcH8d82eux8MO6P/6NyQWi7Xk46cV/XphOvQolBBSybmwSkMU18ZAsbyPI752
	ggKsgC574QG3YRSs2zsu38MI/JK5mnw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795062707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aYYl4/sAKbtXT/bP9hKnwyymlW10siHkwx6r/MNifM=;
	b=IFGTmhamlZZlvbM74+2t8pwEXemAMP1YnI2dp2V1yM783+ER4XiBEhqCsPexO4JnZAv0+w
	EdfU6Sb7x/IqG8P/VHDDU7FNLLVXCOTTsveJ1i5JDCVnxwdOfVgFWjxAcDRVEDKNxVQqPg
	s2wMIhTy4ZXoOneSLFRod2EMNsHfiK0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z8TXECTu;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 802AE152B;
	Wed, 18 Nov 2026 20:31:43 -0800 (PST)
Received: from [10.163.128.149] (unknown [10.163.128.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDFD93F882;
	Wed, 18 Nov 2026 20:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795062706; bh=YHrUpukgLj5ZrCztymQv02KKeX29nkv1OoVNThLO7sQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Z8TXECTuEqly1FB+zcRKWRfSdyS8ZcWCRYQ2E0o7e82wrQqHlrjV+okOuImKNzcRi
	 lY228bxmY5FCdqnY8YIFb9JZAS44q4TXvKV/TqZsTQGWl0NXzzWbCqLFYFbO6iGCR7
	 beEb/XVbqtiGnYI4R/ABbSLpAxhOp2/52x0W/bwY=
Message-ID: <2750d7ef-57b3-4a4c-bddc-840ab35ef45d@arm.com>
Date: Thu, 19 Nov 2026 10:01:36 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 1/5] mm: remove unused helpers from pagemap.h
From: Dev Jain <dev.jain@arm.com>
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
 <20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com>
 <15d75748-9baa-43d9-96e0-0e49c8e27be3@arm.com>
Content-Language: en-US
In-Reply-To: <15d75748-9baa-43d9-96e0-0e49c8e27be3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yroditd1jrhd4tmkxb3pf38y5h6i6ofz
X-Rspamd-Queue-Id: 52AB710000A
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795062707-873196
X-HE-Meta: U2FsdGVkX19kgDQ/Ms3wpYwckUV4rUp39oWU/yFjwtg4nEOQgGijXrbHz2BW1ancdV8nlYzuzKZgUrQjvnss5EHHNCapGfIcyB9FcmU3EPckjmnevgO91l64tgPwyZyVM3+epz/vjtaCC2W1PFqKSdgf1s4wH6052tUTN+YBYtrsGbEsppebFMzJLqTJ95h7QRBpvd12QQ20wB5xRI5amKSKjADbiblu/FfgdzF7wQVpexNsOySZKr8BzHJmQspGc3pV/skHleeuTEdNeNLVe4EgQJmFMH1oFRG5xkuqx474J/97UPtUKsTZpU0U/P9CMmoQosAXa8p/XLzBWRlLX54XyJtE+xQRpoex6P0ClqoI6J9EfWDt0om/lCqUh8wjkGe47gbC3DYqf7U9X4aEhwkbJFfvBMCGlGyprbdsmhX89e6vrzVauoEih/RVlV92J2m6Pk0bC0pdMy3gCuKkdGOvq/zsrpd1dFrhu4VfInHhfR7qAhmDz6UfMmju9aARE3vApUCt88AW9UXjBhnlwcTRJtqQFaUgkXFjwrvTcgQxl4mljZDp2gwguskK4ULJKnwLUBzK3esvqr9Wj87r98QaWXP1ZFxPnlvvgvdVBoazRDzRqaXI25OIw5okIgO3noyk4yYgLLj26bsSyCCwbY85X6EPs/v+yGeGK99jcIr4saPptx/WU9gXbfPnvYk6Km41eq4lKcNyr95R8icfFsMt9hmdOQSifZZWHBPTV7C0cv6yxGLMaRf5BpJgD2chBBWd+XVVcICsTQ5ndM4Z/YAfiaNAfmI3mo100BelP3W94xIGtfyOWuojymy50XV7RNYsxABn7PMYlS4hnU1S7gQyF3Z/hwvJgvhWJRMBnt4HQyJ/+hpw8wwyrjC0L4+Xbko+rMD0ZJ7Z7w335IauQwCu4TO65409DRWCep22IPudLAMTPvACYWYL/9V0mTU2hdUIhId5oscC0ZzNaC7
 uO85/tq7
 Y0jVxToKsBNr7P8RreM5cODRXMrB7/dk5XsABSwxoMKyIvqbNPm7vJ5d8qE12qld+AzpQwze+AkPqgr6QWHL+YTXalEVeyvI4GxXt7yceATi4lxXfUmptXhY+05vhbO5KxdmPgRyn/j8Z8gyIiB4CL50KCGhuZkrrGyDlXitrkuSjiTytrLroU5rZY9mGWjYepW5I7iEHi3IDrRGQLwe2VcpfPg96amIfb7nnskIk2qrA/ksYaaPp1dEdnOd9VehavuyPPW4gyNIhYKLbjwgqL7FgzDyg9pqJm/SUGgmcrEJieUo75KGsSfwSuqM1+nfDGkp5//6rJ4mwjDuItz8ubekXAZv1L/OSy25OpN9+Aafxr1B62OC5dNKJHoyhStSMd1Y7ecg9xE6j6TzDRbYW03rtp8bNaXSsuRbd76DRSKi49Hu2LppPqDW0hZVVrUXsJ0RS1Ss1cbEWXTrEQqVFZpP2Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 18/11/26 9:41 pm, Dev Jain wrote:
> 
> 
> On 17/11/26 12:46 pm, Shivank Garg wrote:
>> invalidate_remote_inode() lost its last user in commit d73065e60dcc
>> ("afs: Use alternative invalidation to using launder_folio").
>> mapping_clear_release_always() has no callers.
> 
> That was added in b4fa966f03b7401ceacd4ffd7227197afb2b8376.
> 
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>

... with the commit message improved.


> 
> 
>>  include/linux/pagemap.h | 11 -----------
>>  1 file changed, 11 deletions(-)
>>
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 73af18a37367..e681a7ba6642 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -20,12 +20,6 @@ struct folio_batch;
>>  unsigned long invalidate_mapping_pages(struct address_space *mapping,
>>  					pgoff_t start, pgoff_t end);
>>  
>> -static inline void invalidate_remote_inode(struct inode *inode)
>> -{
>> -	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
>> -	    S_ISLNK(inode->i_mode))
>> -		invalidate_mapping_pages(inode->i_mapping, 0, -1);
>> -}
>>  int invalidate_inode_pages2(struct address_space *mapping);
>>  int invalidate_inode_pages2_range(struct address_space *mapping,
>>  		pgoff_t start, pgoff_t end);
>> @@ -298,11 +292,6 @@ static inline void mapping_set_release_always(struct address_space *mapping)
>>  	set_bit(AS_RELEASE_ALWAYS, &mapping->flags);
>>  }
>>  
>> -static inline void mapping_clear_release_always(struct address_space *mapping)
>> -{
>> -	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
>> -}
>> -
>>  static inline bool mapping_stable_writes(const struct address_space *mapping)
>>  {
>>  	return test_bit(AS_STABLE_WRITES, &mapping->flags);
>>
> 


