Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D14606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 06:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QiQiikxw
Received: by kanga.kvack.org (Postfix)
	id 32A316B05B0; Thu, 26 Nov 2026 01:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB2C6B05B1; Thu, 26 Nov 2026 01:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA066B05B2; Thu, 26 Nov 2026 01:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1A976B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:51:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F64D1602E1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:51:43 +0000 (UTC)
X-FDA: 85476349686.05.0D46F34
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6EBCD2000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:51:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QiQiikxw;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795675901;
	b=m1mrP6JjB5cHdgXZEPR3xS/Tc9QFg1PAIyXNdmiDNqFsDlEYj0x1hJwS6DU9xl8lqzJpsb
	ph+vv4plYmauobww+cicsD91dLUWVwUV6wn7btrnUe8oMzzfnfbyb2IkfEVaS5SNtXIAe3
	GA+Jn8/LJM9RfKR9ml/hcZQo1TskPHo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795675901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgZPY9XxUKQr2+5N7yniU8q2qGiJR/Q11OQDMcZeiiE=;
	b=A+gJgONwiVVIoIugodcj6KZhZKVdd5roEPolNa8/u2Hi+7OxEWrgpKI598XKr6FzohrEHi
	FWa1dXmWDaXUSyjZ3gj9d6GQug0oBQl1GdByli7x9TUEKUm6ObIhJjjxoeSnho8zF+ty+h
	9yuEo7fV0FhSHbICwps6AQJnZKRUo8Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QiQiikxw;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-3b40283c001so1507357a91.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795675900; x=1796280700; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qgZPY9XxUKQr2+5N7yniU8q2qGiJR/Q11OQDMcZeiiE=;
        b=QiQiikxwuyDOkLi6cPpd+5mgHKSXeCHvF6UNOqzZUBG80FHOjJHJju+j2x3HHaYiLn
         kYUJk0aa8Ovs0NJbR2//Q3Ku05Sx/5M0h26o6HpqKW1e8pWB4KAnAUjs0YAfmSLWNKJp
         TI6SSlAWx3e3EvX0IA3IrwXGiJZCsIt2QKa/Bjy9Jz1Lp3k4Fle0urCKQ87kwZQdQMaZ
         vAsH5BjZLGix+CAfHiTJhYn3yqFDCYyRtwxsbtkqCPlER/Tk/a7GNLEebNp39/nshas9
         kCYF4Fbir6D2+FEMjiBd6u/ockBKM3Ox3/9CEyllVdEGEGUSUJ9VjwJywXR+u3hDvvlx
         YS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795675900; x=1796280700;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qgZPY9XxUKQr2+5N7yniU8q2qGiJR/Q11OQDMcZeiiE=;
        b=DEG8Dy4fhPq9Xxm3FM11yt0KD6lvURlF+cFjdnXbKpR/Zo6u7lX/29yG8u9Rx9wzxi
         R4qHE08WnYgPo6pGhGHU3lNUX4lWstW2DE8mDYutr8+kARM1yKxcuOR0wnO7UsCDK3ab
         JAxCj1hGJO/fQsMhBVQVjk3ay3LqKMFDTHBr2zGLablZ9hnnVIcM+69yBXknnmwAApXB
         uV591wzGQ6gsvbpGCag4EvfUWf8326W0uFdrrGqdSJxZcfoFlVaexFMTh/lmrkj07X9B
         5v8WDH7KKoUx97iIaexOvcDRoH9YP6IzSA6VrXiRT/O2SXTTbWvZyNYlIJyqELY80q2r
         Xcrg==
X-Forwarded-Encrypted: i=1; AL+hErGcLyXUBa5To8K4N0297cg3egVcNbUJQm/S2wLkeseUOTr2ZDiKJ6EHK+2fVzDf+onDGEGTlKVRLg==@kvack.org
X-Gm-Message-State: APuU4Z9QJruzM+ngnnS0RNtyaU1rthHBIr51mcv87LgIBCVrZQ+DVrMy
	IeaoTJIogzUAlT4i46/dZcJU3UlliZVJNrpUlAUig/ms0Xq2MKXEJn9G
X-Gm-Gg: AZFdTZci7O0+BAy+F+rQAz9l+XD7qpBXzMrjfdDtAzMr6kcAUjOjj90yGod1ouxIoUu
	X/UuCKhgx0Uk9sPnGnG4d4punMYIl5YJJe6Cxa+kXJP2JDmoggNSQQ68iidPIIiF21d3HAUwm9E
	2HPoCR+CRa1jxVtQg6TborinxkDmHSypCiX+7M/wXlUCqdFYX4nF2Cjc2pDpehQBMkNpiV1lOn4
	Ls1vTMEV8xl5f2F/0xDAjsu5WRDPZj8oc6CHbJswXNBlLBX4WlZZPIz3alM4/hYWm4Axb5TErsO
	ZMYAOAXoQjQ0egiyxPb1YCwVzgQE78GixTu2/HzNMBydYUL6+kj+Ee9fJk+5ucNLvBUJvs+WioZ
	0unWmCrzjwETRDO1Ktq7xSfGbk0ANx7wHnGOU5bf5k7Y+rSxpY1A6SFTE+ArCLsIWLGXW3ciBuo
	poA7zsPQS76zNpfWPj7D+zIsy0VvPwpqYjb+MFxN+vtE/XOIoGeUKHS5GHW3/3uMAB6FJoxbjgn
	kCe0kKh60qpHDQOIsHowPn6fFQ8YUlTNvuY8RElFN/89UoDYd5v0aop8M+92zHOMiz85+c5b8PQ
	M365vMBakdlVWoTOER71XJJuH//eA60tDlaINQ==
X-Received: by 2002:a17:90b:3e48:b0:3ac:a521:95e with SMTP id 98e67ed59e1d1-3b41c94ce48mr19675123a91.47.1795675899855;
        Wed, 25 Nov 2026 22:51:39 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0b52dsm33651753a91.5.2026.11.25.22.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 22:51:38 -0800 (PST)
Message-ID: <b50cd305-3528-445d-bfa6-e4d7ada43b13@gmail.com>
Date: Thu, 26 Nov 2026 14:51:28 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/migrate: batch PTE restoration in
 remove_migration_pte()
From: Wandun <chenwandun1@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, shivankg@amd.com
Cc: david@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
 <20261120032949.2036731-3-chenwandun1@gmail.com> <awBjoC-YFf6KPYT1@gremlin>
 <fa05e353-0786-42de-96fd-8a9b1ee725ac@gmail.com>
Content-Language: en-US
In-Reply-To: <fa05e353-0786-42de-96fd-8a9b1ee725ac@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6EBCD2000A
X-Stat-Signature: qjgkedwpnnn7a3kgb9tkgrc66b71b4i9
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795675901-646514
X-HE-Meta: U2FsdGVkX19Mz1W0v5EPn5swX3By3KG8BMZjfO62hln8hw0LYkR8DAzcu96cVe1PswQSrE4kNWV/F8RYY2SYT/3WNSRL8njuqEyvJ0A93ZBPBQ/L7Y7JAgM2361hDIZXcu7+eJH5mGsv3NBpIYK5wHG/KTTz5wQCW7Zldb1mvJuAlhXtozt/kPbzgRtyLM9+ZzxBxUyJG96EBbns62ZcL8PqhdlxAPHpmvat6F8N2YeBn5AZKOmii4+IDNROsZJNxlb5ygu1frln+H4NYUoUNpEZIOtDs4eMyKrDFjOJQlacCjwSFKR1gR93V6nRV0fKE7GVz6ofh+qKBmKilL6R4oR5qBEkIVJ9vNQbxQ/iOVni9xhO0E/Jgnb+hHcavH8pXLPakJmBPkPchW1ys0ene6fGTd0/mWwpbkqUYbGSWvE7OAa62YiMQYfpEvFCiAN+nmZtqkxKr5+/y9w+PLmBGLO1qphGIJi3nmQs06oooshC0Gmhmop000JC1QCxK+7y/vk3cN2rkMFEvsVOZN9JfEh5MmItPca+0uXmZJcl9XcPLx4vcoLR76pOWNVOwtm2l8kVgW7exZWtvYluuXPvsFXTTGBZ9jmsyxp0BaGaCSRy5SCKMpOeqHYZzeUn5hrWg++2jkrnEzGHJLyQLjA+EeiYhlzD4B6lHblhhe+E6HbgYd5bD4fDH49ua6ih6OZFbbkTvnZK5zKSgI+0RNWAactOaze5gz5R/eHdQU9uPlzuE9UJKALOiIvE3AwCZJ3huFN5jLSnC8O5YO1XLfbW98dMlIS+hhLlWGTCXB2s9zMPtHB7j2C74NfSGlv6zsBKqyY2lNm5C6dDDQ3SEre7DoRHExbx8xYOJ0F9W/CfvAc02OkEQVe6ioU1vIUY80oDP1w93cpOy1802F92q+U3k/rU5ASp1rpXtwZCJD/5UVb2UFqDBlKGByImuLAg8POpIszAxdj+T7vboti5nVE
 kvAQhWTJ
 rRSyVlW3a6XmyiCo+5SqfHsyPSku4kV/GWrmGFjOQflHp+3tT5E/xdUAkGgivnUSs8oC/Oko2sDn3JS0fM4V5aRe4SUXHgot3wRwDsyC37ru7EbQmomRJ57OuJHEKYBdg8EG3VWvs34QfhjnN628oJXJJ35uEVB0nWP5Qz82PmFcaxsj0NBua1EN3N4jbNA2K+6z1Hos9jfM2x02uY9zmj8Zdo4dQHH/b4Xc0FoNHSsfLtxGBOUERFfP8Y7Agm5zDGnLZ0btgXju7WR2dItB2oL4KBVSwrbc9L4qxl4TlgrCl3Z2jBoQsI4vu5yI0ToQoH4TIj2/85iVr9h2Fw4COFtWoU08PSEdieTUy49skecNvOGuITi5Z+cJgqMozQzkXLgFL4vOGjvIso7H9smc+lXXAzhGa7SjHZtYcuQoVcO6B9EydQ1M8S15f+qsyFmWtwDgJbr0sx3nIbf7WWNXXFyrlw2UbfwzoRThzF2/PBbohkQC8klj1aYsCpAKCk/WkAg9FqCmI9llR55Y9L2nqDNGXbZ6X4AQlhbSq45qE3dP5CAiLcvsrNYdtFpOoDisIXP/hiZzeWMWGfcylYFdxhuflQmPiRJZpRJrIx98SxVbrGn4IQ/IX5WyNRpUspbIP3eZ7+U8EogjrSXTh/rLC7D624fqpECX2Er/fVX9yq/VVIEM1061i3wYQmb/FCXwY/ZMCuKPgUEPebQXlrReTaY8ue2PbbUwwvYazzxia+KzBJAgPxcU6ywlivA3to/J+ZwjI2+VbnA7pAgo6ZdmTUjXkLOlZYc8JzkKswATkeiuebSLXYl3eKFQ6zU+l3GwCZR3WV58CPN4V8tKFie07HdlwwttWdGpQc86C58NvmS8+kxl0xG/SN0k1Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/23/26 15:25, Wandun wrote:
> 
> 
> On 11/20/26 23:22, Lorenzo Stoakes (ARM) wrote:
>> On Fri, Nov 20, 2026 at 11:29:48AM +0800, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> remove_migration_pte() restores PTE-mapped large folios one PTE at a
>>> time, constructing each new PTE and updating the folio references and
>>> rmap separately.
>>>
>>> Add migration_pte_batch() to find adjacent migration entries with
>>> consecutive PFNs and matching type and flags.
>>>
>>> When a batch covers the whole folio, the rmap helpers already call
>>> mlock_vma_folio(). Skip the explicit call to avoid double mlock
>>> accounting.
>>>
>>> Device-private PTEs encode PFNs as swap offsets. set_ptes() does not
>>> handle this encoding when constructing subsequent PTEs, such as on
>>> arm64 with a 16KB page granule, leaving device-private destinations
>>> unbatched. The next patch enables batching for these entries by
>>> advancing their softleaf offsets.
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Link: https://lore.kernel.org/lkml/5f9c449e-43b3-4732-9c14-8199418cace0@kernel.org/
>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>> ---
>>>  mm/internal.h |  6 ++++++
>>>  mm/migrate.c  | 35 +++++++++++++++++++++++++++++------
>>>  2 files changed, 35 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index 9f78c12882cb..e6ecf307d532 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -552,6 +552,12 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>>>  	return __softleaf_pte_batch(start_ptep, max_nr, pte);
>>>  }
>>>
>>> +static inline int migration_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>>> +{
>>> +	VM_WARN_ON(!softleaf_is_migration(softleaf_from_pte(pte)));
>>> +
>>> +	return __softleaf_pte_batch(start_ptep, max_nr, pte);
>>> +}
>>>  #endif /* CONFIG_MMU */
>>>
>>>  void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 3c39d309e6bd..e000ef77ea87 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -358,6 +358,7 @@ static bool remove_migration_pte(struct folio *folio,
>>>  	while (page_vma_mapped_walk(&pvmw)) {
>>>  		rmap_t rmap_flags = RMAP_NONE;
>>>  		unsigned long idx = 0;
>>> +		int nr = 1;
>>>  		softleaf_t entry;
>>>  		struct page *new;
>>>  		pte_t old_pte;
>>> @@ -441,17 +442,34 @@ static bool remove_migration_pte(struct folio *folio,
>>>  		} else
>>>  #endif
>>>  		{
>>> +			if (folio_test_large(rmap_walk_arg->folio) &&
>>> +			    !is_device_private_page(new)) {
>>> +				unsigned long end_addr = pmd_addr_end(pvmw.address, vma->vm_end);
>>> +				unsigned long max_nr = (end_addr - pvmw.address) >> PAGE_SHIFT;
>>
>> const please
> 
> Will do in next version.
>>
>>> +
>>> +				max_nr = min_t(unsigned long, max_nr,
>>> +					       PTRS_PER_PTE - pte_index(pvmw.address));
>>> +
>>> +				max_nr = min_t(unsigned long, max_nr,
>>> +					       folio_nr_pages(rmap_walk_arg->folio) - idx);
>>> +
>>> +				nr = migration_pte_batch(pvmw.pte, max_nr, old_pte);
>>> +			}
>>> +			if (nr > 1)
>>> +				folio_ref_add(folio, nr - 1);
>>> +
>>
>> Please let's not insert a bunch more open-coded bits in an already way-too-big
>> function :)
>>
>> If you need to add functionality to a function like this, please take the time
>> to pay down technical debt and refactor it first.
> 
> Sure, I’ll do some refactoring first in the next version.

I noticed that Shivank’s migration rmap batching series [1] covers much of the
work I was planning in response to review feedback. That includes the preparatory
refactoring and the restore-side PTE batching during the mlock discussion.

Given that overlap, I’ll put my series on hold for now and see what follow-up
work I can take on once Shivank’s series is merged.

I’d also be happy to work with Shivank on restore-side PTE batching if that
would be helpful.

[1] https://lore.kernel.org/linux-mm/20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com/

Thanks,
Wandun




> 
> Thanks,
> Wandun
> 
>>
>>>  			if (folio_test_anon(folio))
>>> -				folio_add_anon_rmap_pte(folio, new, vma,
>>> -							pvmw.address, rmap_flags);
>>> +				folio_add_anon_rmap_ptes(folio, new, nr, vma,
>>> +							 pvmw.address, rmap_flags);
>>>  			else
>>> -				folio_add_file_rmap_pte(folio, new, vma);
>>> -			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
>>> +				folio_add_file_rmap_ptes(folio, new, nr, vma);
>>> +			set_ptes(vma->vm_mm, pvmw.address, pvmw.pte, pte, nr);
>>>
>>> -			ptes++;
>>> +			ptes += nr;
>>>  		}
>>>  		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
>>>  			if (folio_test_large(folio) &&
>>> +			    nr < folio_nr_pages(folio) &&
>>>  			    ptes == folio_nr_pages(folio) &&
>>>  			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
>>>  				mlock_vma_folio(folio, vma);
>>> @@ -462,7 +480,12 @@ static bool remove_migration_pte(struct folio *folio,
>>>  					   compound_order(new));
>>>
>>>  		/* No need to invalidate - it was non-present before */
>>> -		update_mmu_cache(vma, pvmw.address, pvmw.pte);
>>> +		update_mmu_cache_range(NULL, vma, pvmw.address, pvmw.pte, nr);
>>> +
>>> +		if (nr == folio_nr_pages(folio)) {
>>> +			page_vma_mapped_walk_done(&pvmw);
>>> +			break;
>>> +		}
>>>  	}
>>>
>>>  	return true;
>>> --
>>> 2.43.0
>>>
>>
>> --
>> Cheers, Lorenzo
> 


