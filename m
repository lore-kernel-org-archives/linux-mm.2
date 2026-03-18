Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911291077604
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5C76B02E3; Wed, 18 Mar 2026 15:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96B46B02E4; Wed, 18 Mar 2026 15:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85486B02E5; Wed, 18 Mar 2026 15:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7C296B02E3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:02:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AA501B6C01
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:02:37 +0000 (UTC)
X-FDA: 84560105154.29.CE933F7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 38A85120017
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:02:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y6FoBjCm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773860555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g357sMeT7BRwzLdbf5CPPDzwji1TblDvyv5xWwQUqo4=;
	b=pSohqL2WyE8wh4B95k+3ukjRtS5rnYnq0yGQXY8jEVNrv4SaBln7YOz3bE6v4YQMsvdhyQ
	I9KGhdL7aKQq8Yqj89llIRolpRpvhEbj7fH2VmukRFAGcBg3cYz8Yjd4vP2WVACc5C0lIJ
	CXpYZam3HvY/mzqGHDad1EoVKbc4thQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773860555; a=rsa-sha256;
	cv=none;
	b=0O6t+Euuxve5EOICYZWi3HoZap/LcPapqfwWGcTMNUvVVLGrCULGKDQWM1JWiMNJCIQJZZ
	v7Ju1xcndW0NrC0AQwaSoGD+BvQY0INYGo826XAZtVYyKXAmZwKLF7hL15EGoCbpngzHr/
	drKP1QxUeerftTqUUDtvimb/kKRIi7A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y6FoBjCm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773860554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g357sMeT7BRwzLdbf5CPPDzwji1TblDvyv5xWwQUqo4=;
	b=Y6FoBjCmMud04efLGk1k+8ccAJqt77wj6gHtdxVsXh3Shlvnj3DhfH1Ou7+p+0/ho4Rjh9
	obll5YmRsm7F7Nc5nzGODJWEZZwVZ5YQYYoCBmM6JSuzPIPI+xUW6RhjZuSoMAOQk0r0q/
	PDnZOHawPNtmX32wjW8VsrRGpMsgeOk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-0yBjBTu8Nymbvcock4N17w-1; Wed, 18 Mar 2026 15:02:33 -0400
X-MC-Unique: 0yBjBTu8Nymbvcock4N17w-1
X-Mimecast-MFC-AGG-ID: 0yBjBTu8Nymbvcock4N17w_1773860552
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cdb995a1bfso214331085a.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773860552; x=1774465352;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g357sMeT7BRwzLdbf5CPPDzwji1TblDvyv5xWwQUqo4=;
        b=U2O2iI4i3xt/ugHrSNo7yMGGX2V0HBTTXJ43e5jt/kwBJ73YOFZQaK/T4gH07p1esL
         vT0rh8tBNC/ZTG286G0VG00tSIZ3KXssWQBUmBixITivRt+b2cKlCJnwsNLkIjy3PIB5
         uf/T5XM9LxFvACo9WIoixtbpyfbQ432j2L7SBwXoUEI+sy5ZC015RwffbfQ9kP/OqI0t
         QBHLMB/Mwa4NxEejGQ6yKLX/vH0EwJoo2z4BRfCzmqYHFJNpU4UJ5IybPyA9eHXG0ZvG
         8HgmJxnOihIEL0o3ixkCf8gqUwl8ex/QSLGj73aWd72xbemlnAt7v2OYDVcFRdsn0MO9
         QTkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJRh1LYbCkcrh4qhtz1o5DB2gqGFCCUtKbBuQrMIRJUAvxGJhQX5IWdTl3Uo6jRelYozjXTeOzHw==@kvack.org
X-Gm-Message-State: AOJu0YxO45fUL7394u+xsfJTcpI2FWizByWX5emMWK7wV0zBMxzOh0Z1
	K/spVLfAQq0kDVWh6IuPLKxuWb/IRmMohZ2DjUpOh/c1BPCc9RINz1ZzGb9xqFk/VWT/jTYO7aw
	eKQjucPQOeFweT8uLDgWvza/9IQX9Bsau62WBKYYY8paVXmdchtjx
X-Gm-Gg: ATEYQzycTAESjrB4DIRMFSc7aaW5Q4RhIRzOJFPv25uFofPJNc0rFf510wqawJ0SyPe
	QCiMKM1Jqn+ndd3hnLvqfZA6ugOn5jNsOG4vxvZUJKYmHy1dvrz5vJfaA8sSTNjGspXNZhUbt5a
	sywou7nQyY6Pt/kDxC7v13X+/qK6L4iNP0L7Poe/F0v0xVpziupMqdWVyiOhwZbbioSGp2T4jvn
	lg5zLMhMMHrNcgjuYRxhMtxLTs/qj2pWn7guDqwhwQ0NRA0TScvkJcYivIoR2iS6P9JuBx/34UL
	pLNQewKg4Dzm3j2y7hAgT27wfaR4a+beO4GsyBa2Z+djIcgltbet1YHdJGVXJs94zgO3qi89W8J
	XEFsXaB9hxYeszeRvGxKkNLkaAHJHHrW91ddcpYgDMOPBycoR+loGcBAaYql7
X-Received: by 2002:a05:620a:2682:b0:8cd:7811:941c with SMTP id af79cd13be357-8cfad35822cmr628902785a.54.1773860552211;
        Wed, 18 Mar 2026 12:02:32 -0700 (PDT)
X-Received: by 2002:a05:620a:2682:b0:8cd:7811:941c with SMTP id af79cd13be357-8cfad35822cmr628895485a.54.1773860551581;
        Wed, 18 Mar 2026 12:02:31 -0700 (PDT)
Received: from [192.168.10.111] (c-76-154-99-94.hsd1.co.comcast.net. [76.154.99.94])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfad162839sm260663285a.25.2026.03.18.12.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 12:02:31 -0700 (PDT)
Message-ID: <4a1e2d0a-1b8e-4850-bb8b-465841aa7779@redhat.com>
Date: Wed, 18 Mar 2026 13:02:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 12/13] mm/khugepaged: run khugepaged for
 all orders
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032650.234386-1-npache@redhat.com>
 <a74178af-54f3-44ba-a007-4eaf49e40ab3@lucifer.local>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <a74178af-54f3-44ba-a007-4eaf49e40ab3@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f6xRiSWO1UYzxOhqX801yRosrrE3RlPjXLJxnxtPZOE_1773860552
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 38A85120017
X-Stat-Signature: 3q3t7qirh5pnyjnbqh3go4a7g6ajoxkq
X-Rspam-User: 
X-HE-Tag: 1773860554-335701
X-HE-Meta: U2FsdGVkX1989VSwqNZDCmOD4Dy6hJWOTLn+tpfjw1F6RHDIGEW7J7ezRCjqYHcVhdAXPZauwySFGlzGiptWH71Jbnd0AR42fw71kDyJhCjDBBX0MbosPaEJSzhvKG2pfMqHta3+jctArcHyk46wSis1lb4Blg016+IhRwxv2Xvjlyy7eCCYghWYa4Qe3Ake4JIsYTdaRPFXFG/zbmcfDV4RUFKi3nwBfTabBjzCD+MiXD/Pnt5QM1zqqJ99rMlVTacPrI5BX/7YLQDxgc3lgOMHap/8WgEjCAuw8sdMJP4bPETRmpLpCo87R9l7KPsVYfavjuyrQFf+f6Wxb95lEY20Cs3jciSSEXts3G4BE/CPswZU6EXArkk9KLI1WEkVlDOG9H7nsy+PpM8A7KVGkDUq+1G9dyCejn9xHLWsfGNKzUlA4gDtOUXsuUmiSlFMXedezQqX5Q+QqmQoneLBZ3pIss4bmnaYccIC+ED+MjzpDA8mVnT57iz46alHtx3DvIstloTfDN0MiTLuaTVydZZrZtZ5mRRrpNyNd+wbKxyn8qS60ki6TbLNYCyh7nCmQaShumOkAt5ip9Ubw6R0ahfYsfrTf7fSxfKQdYiEFDwCD1jG4Bee7g4gdRTwIVnx2Bdbz44ExKOJ5Es+Wau0keatjqijyElAjqD70rbOhvpjY0B0Nkkt82vbHVR0mw2KPcLOoafV2ibsUo8VS0pYgtY2VsWPzZQJGkV7LSp4cRT/+lMv2ylGDwXt+6yF0LEWUwJppJhmzjQJOHSO+VXt7OqQFJ2ysvOsikVzW1JlFAUmIY5VnpxZ3rdMJD3vItJ+v06+y4f6h5gN9RN36MxXHumWpVU2aiG2F32R7CmIYJe93Sc5VgG8JwGmiZjkRsxSOV65solzMbpOzJVjSVTmLa1NkIME61amuS2sBdsV/6KGqqP+Mr8Wy+hKk+RljboLC+n+AUXVjkpMQuIiaod
 A+euCAaV
 9uXqq5Dmx6AO3gCZix+Cf+JJChEjDcuP3hOQu2PTONzqHKy7BXFo9ZV56ndXfJk6vHwxaZOxVeKINiqZhsrs6hk02rIMgJRlzR1DPA+/01K9zDt6hIPk4oRyz4Rl/l1IOqGrNK/IzLQhzIyi+i58ipfzcA6ueGF7MOfc+SrKmDJ/Um1YqIfTVlWQz03Z7Gz2N+tz23WEolz9eoMRS2IzXdZGyr97E5apH0paALCEgUrMnw6ic4S+eQ1mGQKjZdEAgysW70358KEAeq+yczEnQb/GqmDAM9XHNAn8ndQ2k+x1k9GJd+r6qozbAfPLHEuTgxiJALXM3wv+c+DwWex7/1qeLmGb3K10/fvDl35a9YO9Xsp9hLLJ1wHtt0I6sBvUKlrsPHhUfk1la6z706u3MldEVTEHCps8ahfhjognhts1d4gsHCzcQgutv/e+bjz8gMTL+MwXv0MAmnvCBwQ8vRx71AvRqv1ZRQ6Gu/FDv1jv4YdQh+hnhyTY1tVNOyW9/b4LlTK21M560n5BUGmcPGlfEBeqrBuoEF9/6CLg5WWxj2wK/YjO10wgIP6pu4dpams/J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/17/26 4:58 AM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Feb 25, 2026 at 08:26:50PM -0700, Nico Pache wrote:
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
> 
> This looks good to me, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks!

> 
>> ---
>>  mm/khugepaged.c | 30 ++++++++++++++++++------------
>>  1 file changed, 18 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 388d3f2537e2..e8bfcc1d0c9a 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -434,23 +434,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>  }
>>
>> -static bool hugepage_pmd_enabled(void)
>> +static bool hugepage_enabled(void)
>>  {
>>  	/*
>>  	 * We cover the anon, shmem and the file-backed case here; file-backed
>>  	 * hugepages, when configured in, are determined by the global control.
>> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
>> +	 * Anon hugepages are determined by its per-size mTHP control.
> 
> Well also PMD right? I mean this terminology sucks because in a sense mTHP
> includes PMD... :)

yeah kinda hard with our verbiage being so broad and overlapping some times.

> 
>>  	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>>  	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>>  	 */
>>  	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>  	    hugepage_global_enabled())
>>  		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>> +	if (READ_ONCE(huge_anon_orders_always))
>>  		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>> +	if (READ_ONCE(huge_anon_orders_madvise))
>>  		return true;
>> -	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>> +	if (READ_ONCE(huge_anon_orders_inherit) &&
>>  	    hugepage_global_enabled())
>>  		return true;
>>  	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>> @@ -521,8 +521,14 @@ static unsigned int collapse_max_ptes_none(unsigned int order)
>>  static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
>>  			vm_flags_t vm_flags, bool is_khugepaged)
>>  {
>> +	unsigned long orders;
>>  	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>> -	unsigned long orders = BIT(HPAGE_PMD_ORDER);
>> +
>> +	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
>> +	if (is_khugepaged && vma_is_anonymous(vma))
>> +		orders = THP_ORDERS_ALL_ANON;
>> +	else
>> +		orders = BIT(HPAGE_PMD_ORDER);
>>
>>  	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
>>  }
>> @@ -531,7 +537,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>>  			  vm_flags_t vm_flags)
>>  {
>>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>> -	    hugepage_pmd_enabled()) {
>> +	    hugepage_enabled()) {
>>  		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
>>  			__khugepaged_enter(vma->vm_mm);
>>  	}
>> @@ -2929,7 +2935,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
>>
>>  static int khugepaged_has_work(void)
>>  {
>> -	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
>> +	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
>>  }
>>
>>  static int khugepaged_wait_event(void)
>> @@ -3002,7 +3008,7 @@ static void khugepaged_wait_work(void)
>>  		return;
>>  	}
>>
>> -	if (hugepage_pmd_enabled())
>> +	if (hugepage_enabled())
>>  		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
>>  }
>>
>> @@ -3033,7 +3039,7 @@ static void set_recommended_min_free_kbytes(void)
>>  	int nr_zones = 0;
>>  	unsigned long recommended_min;
>>
>> -	if (!hugepage_pmd_enabled()) {
>> +	if (!hugepage_enabled()) {
>>  		calculate_min_free_kbytes();
>>  		goto update_wmarks;
>>  	}
>> @@ -3083,7 +3089,7 @@ int start_stop_khugepaged(void)
>>  	int err = 0;
>>
>>  	mutex_lock(&khugepaged_mutex);
>> -	if (hugepage_pmd_enabled()) {
>> +	if (hugepage_enabled()) {
>>  		if (!khugepaged_thread)
>>  			khugepaged_thread = kthread_run(khugepaged, NULL,
>>  							"khugepaged");
>> @@ -3109,7 +3115,7 @@ int start_stop_khugepaged(void)
>>  void khugepaged_min_free_kbytes_update(void)
>>  {
>>  	mutex_lock(&khugepaged_mutex);
>> -	if (hugepage_pmd_enabled() && khugepaged_thread)
>> +	if (hugepage_enabled() && khugepaged_thread)
>>  		set_recommended_min_free_kbytes();
>>  	mutex_unlock(&khugepaged_mutex);
>>  }
>> --
>> 2.53.0
>>
> 


