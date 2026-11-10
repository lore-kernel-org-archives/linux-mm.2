Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E087606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GOhQAEFc
Received: by kanga.kvack.org (Postfix)
	id 82CC56B05DC; Tue, 10 Nov 2026 06:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD676B05DE; Tue, 10 Nov 2026 06:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9256B05DC; Tue, 10 Nov 2026 06:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC406B05DC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:57:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFDB71C41D5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:57:24 +0000 (UTC)
X-FDA: 85419059208.04.9E9866D
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 03B8540002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:57:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GOhQAEFc;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311843;
	b=3mnGIEZ6s5IFUFbn69wAMzWrFyPlBtwpzTT5MexXKtL2IKdqu8jZIiigMff3xkJuYxsoUJ
	Iye930NT2Xmk4OKubhsH3VVjQfX9guALjQLp8JcCXV3GZfD3EJXD8LEXZZlqrulAI0fixG
	S2ZPgDZV3RCUYxg+FwMMQ7wYBAw2y+g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GOhQAEFc;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=by6Ti3o1wDAVApAYIKWV2YwwlW1fQPE6wPwXZus2Kyg=;
	b=t2o1Seml98ghRbKd1Tzc4FkXew0/oGVD5HOEZw10sTzFW+3U1Hfy+9Nb8mus4vKy4CpGwZ
	dGlgKRTX/WvUexJwQW4e8XHu1QIzHBGND4Nb2g9AUwdzSzdPSwxx7g6PinC293vPtFQ9EB
	1NuRn0Hg8x6S8IGKld2Ml2D7q/mAKR0=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3ada6c66964so583913a91.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794311842; x=1794916642; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=by6Ti3o1wDAVApAYIKWV2YwwlW1fQPE6wPwXZus2Kyg=;
        b=GOhQAEFcrWVcoj3icdUxs0dScc1P/+FU/+wnXtkQIYSnVr9F1kN8fVhgqxrn7c8Kgb
         gx1rRKI66LdpoG18c9IkWg9d6Hh66UM85o58g21QpjwH0VE5kKSqyRUS6ecZG01jeEmS
         OVwyP3iSxuwqxVyKy4VTQ8hCfUosYJNbxqc1wg1nLH+yLXrnv5telC3IEf9sHxZ+jwzN
         fDvJvwURgqFzAAgm/+se0mTf+AXrmCrfEoVO6dDHPe9yJX1r6ivRsbYHY9+fndyx6mV9
         PhoRtxhsSI13eVUJOOa9ZBJrEIPGUwSe3Y2iu7bUYpLh1vGSTOy1MrV0NLt3y4yiboNA
         NcWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794311842; x=1794916642;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=by6Ti3o1wDAVApAYIKWV2YwwlW1fQPE6wPwXZus2Kyg=;
        b=T25Cqe3ipUW5OGX1T5PABFgIpi2VP7x/pagIfT0qsMkg6if9TFPOhFSCu+VdzbNneM
         EDgfxSH1UsMTCUbhaDHh01zxScnhmOPoQJL2cKG5J5XHGFyxzbr3A9Xw96DPKyn0CX13
         04iH6NionD6QHDdQPT1+HvPlPqb1k7GYlgQqGfL56vd9d0boD09S64uBRXKUjn3UGW6d
         LBDNCbi/Kk+DV+DwEhwOUq82EEUy0FOaUZtISp2oqHLjiakuuqThwh88cgffMqlpkcCB
         lUVaE8DRlF9Z3TtJQOyd333E5xxBg6Zx91tRC8W/GB0kPGqKo1oxN5ZCxkIXITpW5ch5
         WoHg==
X-Forwarded-Encrypted: i=1; AL+hErGzzrqIHKScGTtnLQlcx6iWwjNICe1RwOutaJ2a3fqcVDYsnpwwOHD6L2MPaQK0p/bFSVf87M5pNg==@kvack.org
X-Gm-Message-State: APuU4Z/NH5IBPfsXCav61nxhxNrlgzNISQdgYWwnXtcj68WS1klD9PMo
	2xlqR8wADK91O/tR2LihqEJHhnZr0grAxeTXknnX1I3s7JvgiQluoDbK
X-Gm-Gg: AYBFou0ovhFfK9tAc15Jfx/6K+pBInolh7vKu3A23V2c8PPw46Ibpy3KRGGiFIx2JZx
	71MqDOKwWtwLAlzEFAkIAhaQEHHK30HuJjAZFzan38q44h9hobthM6lVAm6pc5+3aTmMRSaLbO+
	uqcTUxZmali2Yk9Ql2JvJGidY32Eij5743d3GKb+VWAa2QZAXWpAB7CWJVLDIELHHfYuuVwpk7v
	P9iZslqjegitlHOBBwoPvJxUrC+XaVbuEwnYu242LKUOAYIDJcBoHKWhHolQ25vLew9BhwmRtSb
	jTTgitlkzmKsgeGo0DbhUHLD5lNRdlrvYrA93gZdmiM03+eTACvuo0oD9VC41/lkiH2oOXwYpP0
	B/a3Z5ncKaTej3ufYEDL8UxRaVBXc8d5AODj+3E6ZlYDyGyo8frrirBueTarOGG0VTqNmo6tEA1
	lPz+MDb9nYdd83u3zfmrCorX6NuadCoq2ewwdrgMU6UUHjhEfrCxmPzGtFHxaw8QfN1RpzeD2Wv
	1mOW6lNjoV7CuYMn4y13VZC6Pl7oc4gLT91/WcZt/qJtXatlZaNiGBNW2Xqx/DdtIjespGlvptL
	pkoxxg7SF9YuNpYddwWukZWnTx7b9UkFvGzaEQ==
X-Received: by 2002:a17:90a:c107:b0:3ad:47ce:3876 with SMTP id 98e67ed59e1d1-3b166d3f6b4mr2455090a91.61.1794311841562;
        Tue, 10 Nov 2026 03:57:21 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b16fea4243sm1639325a91.14.2026.11.10.03.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 03:57:20 -0800 (PST)
Message-ID: <8a7c7bff-2be9-438d-b8bb-e75361be56cf@gmail.com>
Date: Tue, 10 Nov 2026 19:57:13 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix mlock state loss when migrating
 PTE-mapped large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, hughd@google.com,
 akpm@linux-foundation.org
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109090846.1068409-1-chenwandun1@gmail.com>
 <fc3c1e68-9321-46bd-9f1f-4209bf5c6a7d@kernel.org>
 <dff3e90b-f03a-4dfe-8c53-fd65db20de1b@gmail.com>
 <c94d09e5-78df-454a-be27-f2208a39779a@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <c94d09e5-78df-454a-be27-f2208a39779a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m3woby9p93fz55zyph4d7jz1yy8aozhc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03B8540002
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794311842-806057
X-HE-Meta: U2FsdGVkX18GrHSPn2fLGDEaSYsM0OAvB6bNim893VwMiuNVohh1hVl/9cwB9fbC0J59MMlUwYvbZUrgKvnqJwoOThkSyx0dpuDoP92JJ7t31yI6EtY56AXXIcXeyluaU0aBDr3sZ7OBlf5NIDGAdHpc9ThFsnp5jVz9HI53FWLpWVeHc+fP6XiDh4s9CUogE4Gt8OHHpPiyTaFDHObnWc4Z5NOU+HYlozYyPkEjtxdlsrPyi43UqGL1Z4U6/zB4qNXY3IKjVxipJ+Ptpktp4dnfHVHhHqvNc/MJ3fVEecA+h07b+jn7qQKmU7lSpN/LmjY5BzdbQYDMzLJvM6xh/B5/3gOjDPiOVONqQb80piefc6plodzSdMZ1s6PlxAawU21j5Pl2e9YNbdrBcJywbzzashZGqtwDLiulFhPuaslfP2cotpSSv3Cjvspq45nmA4iKPoOUzQJ2LBg7f5n2/lXSSz9tdKPUimzl4D61mI9KiaEru2XK3FUd0tM0LQP5z8lRHT0i/WFzz7KHZvMBwmxfyzm+8cuxZx9nuv9iu0Xez14J7eZTTb4Qj7nUUWvAKvpqGK20hWKFjrucFB/crdDc6L66ayJ/+BAHrTme1g4MOsgJ2o7llIJ+0GE7yI7SIAPN/prmUN0sH/9X4JlUVFplqinANZXavM+zHjr6t5aZ4aZpbN493m9ca5kcVKGOf5T4AGdmHzY+sndkRc6R/ijfJ89wDQXdt9IOx3h99P+ylvBPPppuobLfR4ZStleOqozLgPY53FORA+gIvRHdRsIQDHDfxSkofP+dkd/ijSteWi7DEDX8Vnk255KzRbBiHHQZmswPvrMzryyVLp4RdtirSGZHbFOX4XEqXMGDpjq7n+BdUUb/x2GYgRe3vAkT8/cCGej0o9uFu8ihxz+fsNphB+zZxZYZSYPuyGJx0FqeWp7KFOYltqlHt/YtAdJjsjbFILX/0335h0zcWFE
 7KfNcpqt
 kryUf0Fz+8EbZj3Ao9zXQV1rP2FqAolyfSUQA/FgtTd+I4U9asTTEUi/N3sHSiIm9jOEzbX2ml1VS8gbLR9ojbVGHKsgT5FFMtWq8goVgWORG/BHGOAHtFMAKU+M9tES7+ZVjJ/A21+IJfXD4X0juZP/iILm1Ox3PnH9exDXZvFIeREbs/j5w1cjp9ZWyiS9pigjE6PPi2w8DbfzQIujS2kD+xTwRdtNJjO4OjCT/K+HV5SBEMeh68q2duYsx5CoYJc6wbFzWfyzC+x61emRTjW6ela3MQxWXWDPrBSU58RhPy+3eUSoHs/DU1ZouaMycviOdj660g+v6CeWKUe84pEnV3dWak3Z7d9iOF1Kz7waX57LbAjS8kJ6EnOU9GDXYy4IO+d26qx6M/WAeeWItK+pM3e6sX8bqTzLmjzZvlEwA4RKEWLw1WrOZ+XOGEcH+lhuRmsTPnrORUpHna5mLcf/QXCMFPlQzCLGKXPiCGYJ8qATjycqeZZhSYk7sjWnwieHfzxTvCmGmtYsU7k2x3YHuWb91D7K5sLuQhCltYvW1JOkbG0FRJ9n17jZHqHpUSv5Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/26 19:16, David Hildenbrand (Arm) wrote:
> On 11/10/26 07:27, Wandun wrote:
>>
>>
>> On 11/9/26 21:51, David Hildenbrand (Arm) wrote:
>>> On 11/9/26 10:08, Wandun Chen wrote:
>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>
>>>> try_to_migrate() clears PG_mlocked when unmapping the source folio.
>>>> For PTE-mapped large folios, remove_migration_pte() restores one PTE at
>>>> a time, but the rmap helpers only restore mlock for full-folio mappings.
>>>> This leaves the destination PTE-mapped large folio without PG_mlocked.
>>>>
>>>> Restore mlock once all PTEs of the destination folio are restored under
>>>> a single page table lock.
>>>>
>>>> Fixes: dc68badcede4 ("mm: mlock: update mlock_pte_range to handle large folio")
>>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>>> ---
>>>>  mm/migrate.c | 10 +++++++++-
>>>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index 94033c222e04..140e291d4587 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
>>>>  {
>>>>  	struct rmap_walk_arg *rmap_walk_arg = arg;
>>>>  	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
>>>> +	unsigned long nr_ptes = 0;
>>>>  
>>>>  	while (page_vma_mapped_walk(&pvmw)) {
>>>>  		rmap_t rmap_flags = RMAP_NONE;
>>>> @@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
>>>>  			else
>>>>  				folio_add_file_rmap_pte(folio, new, vma);
>>>>  			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
>>>> +
>>>> +			nr_ptes++;
>>>>  		}
>>>> -		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
>>>> +		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
>>>> +			if (folio_test_large(folio) &&
>>>> +			    nr_ptes == folio_nr_pages(folio) &&
>>>> +			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
>>>> +				mlock_vma_folio(folio, vma);
>>>>  			mlock_drain_local();
>>>> +		}
>>>
>>> I have the recollection that the next try_to_unmap() would fix that up? Or is
>>> that not the case?
>>
>> It is the case, try_to_unmap() can restore it. However, until reclaim scans
>> the folio, Mlocked in /proc/meminfo can remain undercounted, giving users
>> a misleading impression that less memory is locked.
>>
>> A similar fix was made in commit
>> 	ab521b4142aa ("mm/rmap: improve mlock tracking for large folios").
>>
>> and handles cases where an entire folio is added in one rmap operation.
>>
>> However, when a PTE-mapped large folio is migrated, remove_migration_pte()
>> restores PTEs individually, passing nr_pages = 1 to the rmap helpers,
>> as a result, PG_mlocked is not set on the destination folio.
>>
>> This patch handles that case once the full mapping has been restored,
>> rather than waiting for try_to_unmap() to restore the mlock state.
> 
> Please revise the patch description pointing all that out :)

Sure, I'll update the patch description in next version.

> 
> Note that ab521b4142aa wasn't a fix (no Fixes:) why should this one here be one?
> 
I also agree that the Fixes tag should be dropped.

I was hesitant about including Fixes tag in v1, as there was no single obvious
commit to reference. I eventually added it because I considered the Mlocked
undercount in /proc/meminfo an accounting bug.

Best regards,
Wandun

