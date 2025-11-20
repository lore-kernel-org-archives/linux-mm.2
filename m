Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C25CF64BB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01776B0027; Thu, 20 Nov 2025 01:38:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2356B0029; Thu, 20 Nov 2025 01:38:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0BE6B002A; Thu, 20 Nov 2025 01:38:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 764E86B0027
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:38:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 078C1BB2A5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:38:08 +0000 (UTC)
X-FDA: 84130030656.15.D329E9B
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B97916000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:38:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="X/8DHOAJ";
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763620686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BX9rFfaKdKny49Aru+ZL28mbNKoUR069Ni3qjLSN1/M=;
	b=WzgSkUtXo+XDNXYQOVlW2i/Cm9U2QAH0nieX7uvD8LjuMzFbwT8P9PTeHyRNH0pK20K6vT
	UIB+D5KjaJ9vuX5o3jvKQqidg3Xwibmej13+F/Q9xD3Kpv3tnkWkHVo2hI60EEhmLytS2W
	uXKWGUIWSu0W8TD2+wJRkUvOP0B9Fqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763620686; a=rsa-sha256;
	cv=none;
	b=syk9PquoObAbNyMRKMuEyUgN0nxsxajgqJXt4wTIO//e/tnu4GuAwfEfMJCJhEGJThmQfs
	LYNoV9R95OoJbUx1fRSiDpNxinYVyc3Y/U2Y7lojJDIAMmedFpSgyMDJdDPvhVcgzyeIFI
	39eYzb2wB3bs52aFtvmcJ5hRy4PuZmM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="X/8DHOAJ";
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763620681; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BX9rFfaKdKny49Aru+ZL28mbNKoUR069Ni3qjLSN1/M=;
	b=X/8DHOAJDiI6kV8kDDEAq2SKkOudWDkRiD7ZO+QQvQNuejjqepDtUPqy4hsVGsF23x3GZk7EjudiMC5pITKpY4FG1gf6oJqZFtHGHz8RKDuSiHfBp2IP3J10bq2csr3jP4ONTbCUrrbqVvi2nrMIOUo0ooT7CMu969aXRjca22c=
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WssTONS_1763620638 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Nov 2025 14:37:59 +0800
Message-ID: <cb2f5978-5fdf-4e4d-a662-14c5858b0fe6@linux.alibaba.com>
Date: Thu, 20 Nov 2025 14:37:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 14/15] khugepaged: run khugepaged for all
 orders
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
 ziy@nvidia.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-15-npache@redhat.com>
 <2f1cdad3-6ac4-4502-a599-5bef9dbe0847@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <2f1cdad3-6ac4-4502-a599-5bef9dbe0847@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: erfhiwy9pufa4fb6k61r1otj7gmnktb5
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B97916000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1763620684-864388
X-HE-Meta: U2FsdGVkX1/ox/0E+Wn49HWy0io7nbhHtLvdVKUIanufKvtGK3iKS4sGBoOMkoWNCqFRubNrgQvjhxokvvf7rPfEpAc4nbij9Of1c/9T3axRokz7BrxJV+6yWUvop6CJ0+9rz7ROHCj+NyjZSGzXB0judJOX6Xv/aK6BCmJmn0XVJCFvpz0bgI1ktvZTQGi2ZhLIRndfDIPJSohtMiQ+yUIu/k9vvTjysrq30wRWLUZg2xUMQXB9gXrUKuz5sLycnlh07+wB1jW2LdNeT6W/toRS0ZlVTFDcnNMrsR78/xAZiFRO9rRfD9ZbSTxxEli7wRF+sNrnVXaixPY5nWht513arC+b+PcdAMrA8y7ZjJorC8A2HAsL4ZOsvJLw2eZIOl1RTzBs1nZTO9W0/BQWztowgE2Adltbb/bnUMknU4EyEXEjSRG6AAl7tWZZtvPNNEnesomzc7NCPML2JMnDMh+dUVDHFRsaZoRFscYQWinykaefiOGHJIFnKIlhfkLraiAOXkpRIW/O5eQHpkd8iYrMgPJhOhksZUjo83PQNdKcdRmUIv4mg06pPd9LHvMsPpLH8ldaZDghMwKMBGhTkugz2iSlLg+IIcUKCG0OIoZYtQp9vNhpgj4TrtqlwGIuMGC0PdvU+bUdll6KYWU4xneEZNdGC9gIdjLEQODbPXCPJFs7oosxHmK8dD/R+F8L6i719gVUS+ft6mpzI9qKyOeh7U/vRUwNoBJVNSrWOL3NTBEoc+Xxl6lvqz0FESRA8YKIoHUSrA+IbZERsnErV8KOZbt1gsPZ+ViEnXeCDHEiK5Wn4y+izSY60OBoAmvUMSfVDtEFAF5acgyZ07nj1UjAhi6nZgiqhGePBik/WBAS1Q+TxqZEDplhVs4M+rJrUiAuMua9P3cuFBq1P+mXECaA2rSt16Caw1VnaUq27AfPx2aiLqlc+MhBO1Zopm9U3mbi/Gmlrz8PTnEDGJd
 LVHzuX84
 p/FfAbGV2DVVw0Mlcxj+LW5bKt+1sfQl4L/IZZFNlM8NU6s61mWAkBZxYZOp5p78NW30FT75AuUWRLtkyFwQmBgySqb0osBjrrhm1OotlmR5mznc4Z+LWa1ofJK6IR7LaU0WDvl9ua6FevNErbRuQCCsSnt7cCT7OklsQ7u6A8xAED2xGK4SAzUWHL97HDm0DsGbf5jcaTB4WGhh2WR4GUc1fcqrLPMhlrJjv6e0DOp8DQ6bgXEBz6hhJooaO6J5hJwYtxg6QNcApn+lx2/2Ck7Vd3EsUl/JgfT/+I+S7xfU6eqfAGRlHmZ3gT6fMGSm997LsrezViKaCjWbfgi8Bt3wKq7IiNVNI3swtK2fBFZZCHKKm3+jGOQ47cGXXqTwCmapc3bPND0vEbdMXctn/+WjJKS7ICkD6Vk/KKn1NhUnrR7LB7MRLzDcmfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/19 20:13, Lorenzo Stoakes wrote:
> On Wed, Oct 22, 2025 at 12:37:16PM -0600, Nico Pache wrote:
>> From: Baolin Wang <baolin.wang@linux.alibaba.com>
>>
>> If any order (m)THP is enabled we should allow running khugepaged to
>> attempt scanning and collapsing mTHPs. In order for khugepaged to operate
>> when only mTHP sizes are specified in sysfs, we must modify the predicate
>> function that determines whether it ought to run to do so.
>>
>> This function is currently called hugepage_pmd_enabled(), this patch
>> renames it to hugepage_enabled() and updates the logic to check to
>> determine whether any valid orders may exist which would justify
>> khugepaged running.
>>
>> We must also update collapse_allowable_orders() to check all orders if
>> the vma is anonymous and the collapse is khugepaged.
>>
>> After this patch khugepaged mTHP collapse is fully enabled.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 25 +++++++++++++------------
>>   1 file changed, 13 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 54f5c7888e46..8ed9f8e2d376 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -418,23 +418,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>   }
>>
>> -static bool hugepage_pmd_enabled(void)
>> +static bool hugepage_enabled(void)
>>   {
>>   	/*
>>   	 * We cover the anon, shmem and the file-backed case here; file-backed
>>   	 * hugepages, when configured in, are determined by the global control.
>> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
>> +	 * Anon hugepages are determined by its per-size mTHP control.
>>   	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>>   	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>>   	 */
>>   	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>   	    hugepage_global_enabled())
>>   		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>> +	if (READ_ONCE(huge_anon_orders_always))
>>   		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>> +	if (READ_ONCE(huge_anon_orders_madvise))
>>   		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>> +	if (READ_ONCE(huge_anon_orders_inherit) &&
>>   	    hugepage_global_enabled())
>>   		return true;
>>   	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>> @@ -508,7 +508,8 @@ static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
>>   			vm_flags_t vm_flags, bool is_khugepaged)
>>   {
>>   	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>> -	unsigned long orders = BIT(HPAGE_PMD_ORDER);
>> +	unsigned long orders = is_khugepaged && vma_is_anonymous(vma) ?
>> +				THP_ORDERS_ALL_ANON : BIT(HPAGE_PMD_ORDER);
> 
> Why are we doing this? If this is explicitly enabling mTHP for anon, which it
> seems to be, can we please make this a little more explicit :)
> 
> I'd prefer this not to be a horribly squashed ternary, rather:
> 
> 	unsigned long orders;
> 
> 	/* We explicitly allow mTHP collapse for anonymous khugepaged ONLY. */
> 	if (is_khugepaged && vma_is_anonymous(vma))
> 		orders = THP_ORDERS_ALL_ANON;
> 	else
> 		orders = BIT(HPAGE_PMD_ORDER);

Yes, LGTM.

> Also, does THP_ORDERS_ALL_ANON account for KHUGEPAGED_MIN_MTHP_ORDER? It's weird
> to say that an order is allowed that isn't permitted by mTHP (e.g. order-0).

The THP_ORDERS_ALL_ANON has already filtered out order 0 and order 1, so 
it matches the definition of KHUGEPAGED_MIN_MTHP_ORDER.

/*
  * Mask of all large folio orders supported for anonymous THP; all 
orders up to
  * and including PMD_ORDER, except order-0 (which is not "huge") and 
order-1
  * (which is a limitation of the THP implementation).
  */
#define THP_ORDERS_ALL_ANON	((BIT(PMD_ORDER + 1) - 1) & ~(BIT(0) | BIT(1)))

