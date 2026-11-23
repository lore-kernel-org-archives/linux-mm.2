Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA41606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pppGh7+A
Received: by kanga.kvack.org (Postfix)
	id 1AAC66B05B0; Mon, 23 Nov 2026 02:25:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C116B05B1; Mon, 23 Nov 2026 02:25:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A796B05B2; Mon, 23 Nov 2026 02:25:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA7046B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:25:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E96EE1207E5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:25:43 +0000 (UTC)
X-FDA: 85465548966.29.6B35286
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf27.hostedemail.com (Postfix) with ESMTP id 09BDA40006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:25:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pppGh7+A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795418742;
	b=uIj274QH9p29AJp76trWPBiVjVn5wwwMOl3xycR4DDKXJQITeZaHPbuAaQmYLJalSf9m/4
	9d3MxIHLOEJC2zENb9zQrIR3DGkAREjrZWePq4I/hOD8//RT6lr+eM5Fm8jUXGPvEHlLFG
	ITOrULUBsnUx+sMyADmdWxIyEfWlXww=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795418742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAiUeAKaDme4Hx48xxb6Qw9mh2vqwyP0H2nnKCqn8CE=;
	b=5oY3G2B+CxK25A+Pdi2ZZMgbNQt8Q/Mpe/LYE0chWq+Zd0gT+hzJX8Aq2rfLVB93l7OAhR
	TVFSshOL6D1WwPEjPQ6dV1XFpuccVt1TJDh1LUsCFSM6Gz3+8vrXv4su+vF4lg+sxnswVq
	33EmqmPe/YRd1aRjJONyIvHkeZkSKZs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pppGh7+A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-3b497279c25so301694a91.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795418741; x=1796023541; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xAiUeAKaDme4Hx48xxb6Qw9mh2vqwyP0H2nnKCqn8CE=;
        b=pppGh7+A14xq9irttz3XvcY9OkAOv8p2AwsK5UXPG4MnP1YxP1elbGRTETO9bL14Yr
         Bfku5DfMWiQ2Q9TeiTtgBRo8NcgRXj7pRlJMkfznmRgOFZSmvcw6XJHt8avYoOPHEabf
         jDYHpJiXN+jGJy/X9C6HbiO86uk6Jma1OINdJAgYFAVHe1rwiyO7ovtj4UuWlX1OjjmS
         12oQZPZr7/pw2q5ZCw3pDfh5WGV2UrhCX+E+xic3WfrXhYyP69SfGe4mDtUISjWuq3JV
         YxixfEx4WL/fKAY86agwx57R3mbNl/ETm00k9WykxZM/wuovwumQQrxXgZu6MiSiL8QW
         GxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795418741; x=1796023541;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xAiUeAKaDme4Hx48xxb6Qw9mh2vqwyP0H2nnKCqn8CE=;
        b=0wji0AOQMlLVx1jbSIe7e8MgosxArbibXnq+L/CqP1sMbM6e/OAh4KHVQ7R2k4EFun
         MLquLnzgCAcY+tAsyqrFkpBAjUva3jN4h7RE70riuXFek++Pt0B/rpChym5aCy8ozz6C
         xhl5jSRGkNMzu6GXFy/gNS4L5/VDrgQSCT3x4IIudZLqtpkOqqX3Dak1L/xVjpJWR9un
         xJ+w1GKeuvEcwMj6BmeSGGstMj14+yj6HA5Edf7bDgPRsyyTID3nsd2KQprERbohSA0F
         5KmLHa8tD1yHrNFynmomuk0kUdvqpLKbXyT0I+tgUAsEg4+YOp8OIAv4Z5unfYDVSd2a
         xohQ==
X-Forwarded-Encrypted: i=1; AL+hErG0eSgQPBl79znVuM3byCucIXwj2LZchf1sqeUApvgd4okUqpuD8pGQwNw+Cs6D0AmDLsktvUy00w==@kvack.org
X-Gm-Message-State: APuU4Z+nXqrbz7Kp2dT+aVLTu8/kqJa8/u4yBffUM8308TSflLj4aa5e
	3JYxd2XcLwkWWPEryJtgfG1w6Wyy754KwE5UGeJzWNUUrHGRf7SSDyl38svLqJBjHMJI/cTzeuQ
	=
X-Gm-Gg: AZFdTZfetH+Nk4admva5LsrR9B4mFlmrzqGdrxVlZ7EkW/JkXKKfNWIDtWv6Np9xT35
	Ncc5yP8ehXD5NZK+ZRm1tq8sUxkVQxx/J/yHjEqt1dRuDIbUR6ggvxxMjWv+ZQ9L5MMxFa7L3ax
	8mTOUjRESlYnsc34nb4Ysnt15ecNQG5qCGV1Pl8ZJLT/0NJxSfeoUeTV4gngFJP5Zdlkdki+KVc
	sPRZ6D2nCZeT1DgCLd1GXYjUT7P3VkB6paXA2hyMTOLVv1q4pgSSX3kTLHhQg9CD62v+3GtfaYY
	YSZPuKbGQGoaE7QiuBWYG6l5vyashgV+2NURkPW3hPYEXTqUuKRdMHSbc+Dkg7RuZSNhZzgNFf5
	GKE3kA6QI6INfw8yaKQ0eN78meAWk7D6+1azYPxcTyr+gWAppnrTEQQbPC7q2CIwNyCYE75eXaz
	kNtnmSiln/Llgrf8DCMZDRpnNX51qo14DJPybx+rGS+3UxEATRdtfa2WfoB0xD//pE/KGsf9+Vf
	dSYt7TOVpeEqWkRlmCThJ5fMuX7mHr3LqmzKZc0FPyo7YRaqWeL44Lah7q2QDolGrttJzXf1ALs
	97GKljZwKRayrLzBrvll+VPWNgyj/cdGglbt
X-Received: by 2002:a05:6a20:9183:b0:3e2:2021:89c with SMTP id adf61e73a8af0-40148dca737mr12101063637.5.1795418740652;
        Sun, 22 Nov 2026 23:25:40 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c263sm4987776b3a.11.2026.11.22.23.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 23:25:40 -0800 (PST)
Message-ID: <fa05e353-0786-42de-96fd-8a9b1ee725ac@gmail.com>
Date: Mon, 23 Nov 2026 15:25:31 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/migrate: batch PTE restoration in
 remove_migration_pte()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: david@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
 <20261120032949.2036731-3-chenwandun1@gmail.com> <awBjoC-YFf6KPYT1@gremlin>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <awBjoC-YFf6KPYT1@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 09BDA40006
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pzycjbdsrwc8kdd6rwjybqwn8iub4duc
X-HE-Tag: 1795418741-574256
X-HE-Meta: U2FsdGVkX1/Id5VDUWKSo9IS6JFZO4SJTNM0Eu2GK3rgUpHPstgA0lqKz5PnT2MMX49iL/o0r/OHcklB11BwC6B2jE+EJWEw7NqC4X1SzmiT5xCsgBiXYjld1PMGPaw+v1shR5D4tn1VlgF8NyNdlnKD6WNZXJ8bm/QNeQCdo1G29ZK5t60V7Xz5K3VPiNsC3wGGEP9hZOyZbMfMBbOEHbQqtqTvugh2bDh+SW+al0cus9k+RDmBZtSOcK0B0REibPDQKJUbQ9ty0XcWxvwA2OVxHuFdDlIovEpCfFvvvq3DIXwBaS+AIxyCV9KDmPfG4hd4FrUndA1owCg0T3rUAfUbn/We6L+lOQCO4cCEIVO8nwpWdnPsOkw12j//nsBZWWxSfjLnSt18ayjsLryFz/kPtUE6mjizU3is57lVzNjN8CzhmMQQWbahokudkpsh5B6lmaNPxSYs1vB8adUIIccZgYboNMYXRZtXqRJHiYX5SJbwPRd3Yykyas3zVSRCjnYPMPs/D9fHcbo3bPjBL3aujfjJs1RFW0bhofnR6iCUuT27rfIpyXzuGmmxdvZzVPArDlOyWitDOfXHPNmrL5o5eg1ZeBXrox+lDEM5DIrilUbxFpW9fZiol5SgtochhEDxfuGZiTJpF4tz9DstoTe/N7uk1xLN1VWan0LlbIER83SSncKGuRCPjBx8zqPwMNWy/YYtvdgWAbPjytQ2xFpy6jwDUR3uKjCJcB4p8zP/va1fknRAWDCWfWflZ+Yu5mBVRKsLmcS7OcQVvHElmHsLhIEFOGtvH/A/9JvbayCZxkJpDYrv2+Ab/x7I1EeivZ+lQWhCEGe7fiJynfjo93IstnVmr85RFh4dlUFejgZ/wKC8dcpHUAMM/hd5Vk4fkYyzW1FanvjCxXPQ3zz8T+a3Kva2DtcnVm2XKySzEVlyvboBpkkuIpOo+VWmVufdmMra+RmXgDhwVmEDxYO
 2Irzmq1D
 PYwdkdhPfPaUcosUE56mGiKssZjNpVfno7W2laa2eQcfiRoBgtp3lIfQZAaqayrTUTY3J51Qit2qpsZEVTMx3+xZpjg8eOugZ/3JACeb4XNlt38d+m1Tx9IjJCGwozoVzlaYvfPtgGSsyQ+DH57s6io+b072vtvK6gf5WXPOHdN+4SNWovGMJwQDdSF+xqDzehjlCIqkDI5TGJNZ3SBx1CPY5N9YVHoMe3dBDTT0tC6mskqhMYI5TUG9I+jLvQ3Y22p6wUIm1zmsfF4I+T8FI1p3GEN7azHDApqrGAVm0+X00IxJBnI7RlZJJ5+fvWC8IyY6w30V55FLpco+C3LNxx+hyeSY33Lyx7E2YCwADv9GvGCbzmG8tP/ZCgG9mXOTrW56Atrs7xZ9dgeg1AONgh7dlw0rrp8zO5ezLlEH20eJ9FX2lPDcIkoD64TAX3yJKD1PugplNgCcqbrKueU8VW5+FxexYp7Z12Egt04rqA+62kWN+5h7y/8UC5lACjGPrONVedWhHGi5vY3kLEryTRvJrFgVpzUrH6UpucJOx9Y//C/mazCsa7zwS83KyGd/2IeI06E5AcbWGYHJAluNC8Vlws3Oz9fmmEUgSMxMm8NmxU9SPMmjqUvMOFmn+v5P/7fcDmN5Y7myBIvcDP/d/vrDl37GrZhDCYdcMmg68uoCJbM0oziN+6PBlVQp4otsOzFpVw8JEQCOL0yQhMRQEkQVBISPiRjAjuRBzzEpo/nNSikN8EpIRd7g8dTHQv76TfZhitJ0s2WQZEkaqcEWKO7mvU7/Ypo67Ep2H8VWphylIB7SnOuwYTCSAR8eulLFbDzt0bsQaIPevMJQL90BrW2H/JXS0MmVMcF7FqiPbwoXZPH1+kaa8QRFbTvreEd25zbph
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 23:22, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 20, 2026 at 11:29:48AM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> remove_migration_pte() restores PTE-mapped large folios one PTE at a
>> time, constructing each new PTE and updating the folio references and
>> rmap separately.
>>
>> Add migration_pte_batch() to find adjacent migration entries with
>> consecutive PFNs and matching type and flags.
>>
>> When a batch covers the whole folio, the rmap helpers already call
>> mlock_vma_folio(). Skip the explicit call to avoid double mlock
>> accounting.
>>
>> Device-private PTEs encode PFNs as swap offsets. set_ptes() does not
>> handle this encoding when constructing subsequent PTEs, such as on
>> arm64 with a 16KB page granule, leaving device-private destinations
>> unbatched. The next patch enables batching for these entries by
>> advancing their softleaf offsets.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Link: https://lore.kernel.org/lkml/5f9c449e-43b3-4732-9c14-8199418cace0@kernel.org/
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> ---
>>  mm/internal.h |  6 ++++++
>>  mm/migrate.c  | 35 +++++++++++++++++++++++++++++------
>>  2 files changed, 35 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 9f78c12882cb..e6ecf307d532 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -552,6 +552,12 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>>  	return __softleaf_pte_batch(start_ptep, max_nr, pte);
>>  }
>>
>> +static inline int migration_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>> +{
>> +	VM_WARN_ON(!softleaf_is_migration(softleaf_from_pte(pte)));
>> +
>> +	return __softleaf_pte_batch(start_ptep, max_nr, pte);
>> +}
>>  #endif /* CONFIG_MMU */
>>
>>  void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 3c39d309e6bd..e000ef77ea87 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -358,6 +358,7 @@ static bool remove_migration_pte(struct folio *folio,
>>  	while (page_vma_mapped_walk(&pvmw)) {
>>  		rmap_t rmap_flags = RMAP_NONE;
>>  		unsigned long idx = 0;
>> +		int nr = 1;
>>  		softleaf_t entry;
>>  		struct page *new;
>>  		pte_t old_pte;
>> @@ -441,17 +442,34 @@ static bool remove_migration_pte(struct folio *folio,
>>  		} else
>>  #endif
>>  		{
>> +			if (folio_test_large(rmap_walk_arg->folio) &&
>> +			    !is_device_private_page(new)) {
>> +				unsigned long end_addr = pmd_addr_end(pvmw.address, vma->vm_end);
>> +				unsigned long max_nr = (end_addr - pvmw.address) >> PAGE_SHIFT;
> 
> const please

Will do in next version.
> 
>> +
>> +				max_nr = min_t(unsigned long, max_nr,
>> +					       PTRS_PER_PTE - pte_index(pvmw.address));
>> +
>> +				max_nr = min_t(unsigned long, max_nr,
>> +					       folio_nr_pages(rmap_walk_arg->folio) - idx);
>> +
>> +				nr = migration_pte_batch(pvmw.pte, max_nr, old_pte);
>> +			}
>> +			if (nr > 1)
>> +				folio_ref_add(folio, nr - 1);
>> +
> 
> Please let's not insert a bunch more open-coded bits in an already way-too-big
> function :)
> 
> If you need to add functionality to a function like this, please take the time
> to pay down technical debt and refactor it first.

Sure, I’ll do some refactoring first in the next version.

Thanks,
Wandun

> 
>>  			if (folio_test_anon(folio))
>> -				folio_add_anon_rmap_pte(folio, new, vma,
>> -							pvmw.address, rmap_flags);
>> +				folio_add_anon_rmap_ptes(folio, new, nr, vma,
>> +							 pvmw.address, rmap_flags);
>>  			else
>> -				folio_add_file_rmap_pte(folio, new, vma);
>> -			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
>> +				folio_add_file_rmap_ptes(folio, new, nr, vma);
>> +			set_ptes(vma->vm_mm, pvmw.address, pvmw.pte, pte, nr);
>>
>> -			ptes++;
>> +			ptes += nr;
>>  		}
>>  		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
>>  			if (folio_test_large(folio) &&
>> +			    nr < folio_nr_pages(folio) &&
>>  			    ptes == folio_nr_pages(folio) &&
>>  			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
>>  				mlock_vma_folio(folio, vma);
>> @@ -462,7 +480,12 @@ static bool remove_migration_pte(struct folio *folio,
>>  					   compound_order(new));
>>
>>  		/* No need to invalidate - it was non-present before */
>> -		update_mmu_cache(vma, pvmw.address, pvmw.pte);
>> +		update_mmu_cache_range(NULL, vma, pvmw.address, pvmw.pte, nr);
>> +
>> +		if (nr == folio_nr_pages(folio)) {
>> +			page_vma_mapped_walk_done(&pvmw);
>> +			break;
>> +		}
>>  	}
>>
>>  	return true;
>> --
>> 2.43.0
>>
> 
> --
> Cheers, Lorenzo


