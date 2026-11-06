Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3159C606D82F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=T99h4t2e;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=A2iRrZUk;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=TrP7zV8B;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=pwChqOUr
Received: by kanga.kvack.org (Postfix)
	id 3FAAC6B05B0; Fri,  6 Nov 2026 10:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2616B05B1; Fri,  6 Nov 2026 10:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2B76B05B2; Fri,  6 Nov 2026 10:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00FE16B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:03:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E662D1A0CD5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:03:30 +0000 (UTC)
X-FDA: 85405012980.10.B402DC2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8D3E78000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:03:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T99h4t2e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A2iRrZUk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TrP7zV8B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pwChqOUr;
	spf=pass (imf02.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793977408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FoXJI83hjTO3ej0IaD9RjGbYyhgQtVCqkHhpUVyi4c=;
	b=2b0WKPGD3VqO1IUOfZcjZ9CflZ8RxUvZtJCxI4mCKTX7PpKaWU/IOuDF1zoaaW4orEwZJy
	MYF17CVjsXhqiahESHREFtMH6QCa6bZKcn95UTFI9g3JCq/sQv+biRooozMhtqSbJrdVbT
	9PHlkgt1wAy3DE3u+Yrsd6tILE604Mo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793977408;
	b=A1Gm/5ZZdSV3MV8BSp5JwfXxZOoj2XbUpF87kNXe/mGfjxf2Iv0gbUKg6uPB7GmN3X9Lsm
	yq3xHbleY8U0MDtYmpy7u5KJj+Z3/T0H3F9ea0C92Si9jJV3zJLx4oWhUeGVvAIK5RsxaY
	oaZL3VQavh7qUNeSLORxhlw4dyGj/30=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T99h4t2e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A2iRrZUk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TrP7zV8B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pwChqOUr;
	spf=pass (imf02.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C528B1F452;
	Fri,  6 Nov 2026 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793977407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FoXJI83hjTO3ej0IaD9RjGbYyhgQtVCqkHhpUVyi4c=;
	b=T99h4t2eVaDmcmrjVcu27YVtUhLbvUNfnyHjcqGwmJAK8EY3JM5NW5F64yAYp/wwy8z4CL
	OQ3ZR7qiT0H/FjFFL5nmUgbhfEZgFD9A5EtEfwwQfjsDhOuOnsVFcTehzefBuemiKXfZT6
	E8gfqHNX/vfuRnQ1iXGfrwne/66b0go=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793977407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FoXJI83hjTO3ej0IaD9RjGbYyhgQtVCqkHhpUVyi4c=;
	b=A2iRrZUkUprSGaX3DSBXtYraW62Mf+y73dvDiOil3BLXplUYqTBbKk5eyLZK8lPx4MkHqO
	AdHMM067QoKSB0DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793977405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FoXJI83hjTO3ej0IaD9RjGbYyhgQtVCqkHhpUVyi4c=;
	b=TrP7zV8B8N1md/3I8OjCcYITIt4ESSWHs0Yz8xJhnNoMmua2OoyrnWj4n7PNXBtu2z1R9G
	90BoSMUNQDUeYsD97x9WMj89IbtxNHO6Bl24ZQQIgRG5rYGqdWpolgLjdvqds6BCDhpws1
	YspriT66b/zBgFq/O7crDSGBMle7v+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793977405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FoXJI83hjTO3ej0IaD9RjGbYyhgQtVCqkHhpUVyi4c=;
	b=pwChqOUrbMtB61kYeSJynpZeIOHohxyjdHnde7E83dlZHSYA2ThLpp3JiZ/YStXID2sheR
	ThpKDcjnpwj+lDBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33B42132C9;
	Fri,  6 Nov 2026 15:03:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mWThNTvs7Wo+GAAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 06 Nov 2026 15:03:24 +0000
Message-ID: <8e5f0caa-6292-4a65-ba8b-7ae647dd3b1f@suse.de>
Date: Fri, 6 Nov 2026 16:03:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] mm/mprotect: keep writable entries writable on
 permission upgrades
To: "David Hildenbrand (Arm)" <david@kernel.org>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
 <20261105165004.2663799-9-clopez@suse.de>
 <60c4f0a0-e3c9-42dc-b2e0-0860ab6e30f0@kernel.org>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <60c4f0a0-e3c9-42dc-b2e0-0860ab6e30f0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -14.50
X-Spam-Level: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D3E78000E
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: fq1dx4ti7wssqbuna71sx9wphk9ytxc5
X-Rspam-User: 
X-HE-Tag: 1793977408-804974
X-HE-Meta: U2FsdGVkX1/84Y+4CO6X0qaVSjcgbr7xqSRqS0NUebAv9zr+jStaKalP/UToV8R8GvFJRWz9x7D54BIhKp7seZ4ipfv1ew3NG8nXlkCcs0/ggDBQSsDUzyfbFOceuQIPb+JwciIoPYd+0uM1KHVVNUmZ+b4WbfiqMNROH6Z6XIy281qeUPziuFHR5FhPUogTa0+SS0Qu96Xuy08trk25mlNbJYg2NB8XkSIO3opjuOe7s+AMJd8hNf2+XgrzJQZkews8FRO2twrC/walzHlwttZ80qvJ9aDnpZidZWtsA4IMx9FzW7bfCngKTVQG8vJ3UjnMBWRHMosNigZSbu5tMqNOcf0bw0bOQnx9kG70XDr8dDYX3nsEjiRukwndJZBqwHJWHHopHVJwU5vW2HtgI3U5T8ZfKsBpr1dGEXAOfu9m0ypkmlDxTUHOTXm9Wfcj/Pe4R3fT/b8zPS0crVHSM72CaiPV+CjC2yN5T8Mk+bnIH9mXkr/iLBVaD08X3UAPmklEKyxkwftth48GilIeOBy/7NZpUbh52OdfiQ1jrWzLGo2wuAjKHHc9aF/qFyBRNH05+vhZ7Iod/A9Ysr4g/5XViFF4VLpDgRqL1HhXmKFUD3qLGW7wOypFFdY7PYLMmKRO8zfg7IkFk+39+Ej/mv5xpEpHLDQsfp1eKVdLb0NFqkM9bVlItBLcQTaZLYHPnV06zNlUGojvHRynRU7n6YqYpUZ80HBokVjH2mdCl9RLkWRjquqlqWzRguHJBqLfxtMEAIMufybYYJMHZgQKlgZnRnEKR9G448KxhnZ5MaopX2SQncYBeNL0XTpBAaqgsDivpVd4ZOoa0j6gE1NjEin6EfaSOuhssZv6avMRhr6SIkgtWOl4KOAW9DL3qUHYkwhj5hfjvOmRiImi32ybuab3m/bFPnH5oC/o4pSGPGZUafuUeL3zn7RCZ9vX95xwnfYWsQbPmF1u6ck23O5
 hYs61w6M
 YxfhmXG3fr/6NOriB68Z0++Idq7BHooqjDD5OnlJJZPV0E21FQ3guFRni+oVXGcqzUSnn521KRzXCdi2zclFcw0U652q/wZkFb/og9yA1Mc4l373QYNcSLG0zUzH2EMgl9jvpayAOBpo5NWj96kkyI82XJCU9NDjnWmuD3xxl6y8vayMUzSZ5uDrVCKJF3VMjliMRkw8794eU3HNBJJKizH6cBPQz29Mc2L5FFM3VSxX+6ncEchLEczARZ2Dfehy0P+dqMec4XtUIjBm24HA1yZBUoivn11pHLovgdcPiVzTUjf5M+2RiAzDytBsKJx3ktCbiI5Bohu9pQjc8RmARhlgps9W8xHDvjBNhiVexNtpX2yY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 6:06 PM, David Hildenbrand (Arm) wrote:
> On 11/5/26 17:50, Carlos López wrote:
>> change_protection() applies vma->vm_page_prot, which lacks the write bit
>> for CoW and write-notified mappings, so it write-protects every entry
>> in them. When an entry would simply be made writable on fault without
>> further checks (e.g. dirty PTEs in shared mappings, exclusive anonymous
>> pages), MM_CP_TRY_CHANGE_WRITABLE makes the entry writable again to
>> avoid the future fault.
>>
>> However, writable entries in shared mappings that are not dirty still
>> become read-only. For example, a uffd-wp unprotect makes clean shmem
>> PTEs read-only even if they were never write-protected, e.g. when they
>> were mapped by a read fault before uffd-wp was registered. The next
>> write to each of them causes a fault that only restores the write bit.
>>
>> Now that MM_CP_PERM_UPGRADE indicates whether mprotect() only adds
>> permissions, change_protection() can tell, together with the
>> userfaultfd unprotect flags, when a change revokes no access. Keep
>> writable entries writable in these cases, at the PTE, PMD and PUD
>> levels. This is consistent with the write fault handler, as an entry
>> that is already writable needs no write fault.
>>
>> Signed-off-by: Carlos López <clopez@suse.de>
>> ---
>>  mm/huge_memory.c | 7 +++++++
>>  mm/internal.h    | 7 +++++++
>>  mm/mprotect.c    | 4 ++++
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 506e1e61c0fd..6e23d0e4ae66 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2809,6 +2809,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>  	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
>>  		entry = pmd_modify(entry, PAGE_NONE);
>>  
>> +	/* See change_present_ptes(). */
>> +	if (mm_cp_is_perm_upgrade(cp_flags) && pmd_write(oldpmd))
>> +		entry = pmd_mkwrite(entry, vma);
>> +
>>  	/* See change_pte_range(). */
>>  	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
>>  	    can_change_pmd_writable(vma, addr, entry))
>> @@ -2885,6 +2889,9 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>  	 */
>>  	oldpud = pudp_invalidate(vma, addr, pudp);
>>  	entry = pud_modify(oldpud, newprot);
>> +	/* See change_present_ptes(). */
>> +	if (mm_cp_is_perm_upgrade(cp_flags) && pud_write(oldpud))
>> +		entry = pud_mkwrite(entry);
> 
> That looks completely hacked on. We do have can_change_pud_writable() below to
> make such decisions.

Okay, for v3 I can pass the old entry to can_change_{pmd,pud}_writable()
and return true if it was writable, after the existing write-tracking
checks (uffd-wp/soft-dirty). For PTEs, can_change_pte_writable() is not
used on the change_protection() path, so the same check would go in
set_write_prot_commit_flush_ptes().

Does that sound more reasonable?

> Whaatever you propose here is either wrong or way too shaky, sorry.

The idea is that MM_CP_TRY_CHANGE_WRITABLE relies on the dirty bit to
make entries in shared mappings writable, which misses clean entries
that were already writable (e.g. shmem read-faulted before uffd-wp
registration). Such entries can stay writable, as anything that relies
on write faults write-protects the entry first.

