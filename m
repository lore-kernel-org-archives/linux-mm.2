Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02455C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF106B0098; Tue, 22 Sep 2026 09:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D593C6B009F; Tue, 22 Sep 2026 09:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48B06B00A1; Tue, 22 Sep 2026 09:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B12D6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:15:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1843FA033D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:15:28 +0000 (UTC)
X-FDA: 85241444736.14.36027A2
Received: from mta1.migadu.com (out-247.mta1.migadu.com [95.215.58.247])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8394880006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:15:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cgHcJQMG;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790082924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvvW/8z657vxZ3+JPxbiZpr7EOqCAd86pevTN7qJgH0=;
	b=qUYIWhGaJmInx7AP/q4nr1qkqWjxMncOvwfgqWP4QGtA3iBLUpP5FG330urdIMvNwZEwRK
	TSq59dc9LmDChPVxbkvL+rh8wRDr6iUZsjhl2/22d71rpWN+n1gplVt23P8fArOc4jP5cr
	3A8DypbeaeADXNYag2SpzvHB1I78zvo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cgHcJQMG;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790082924;
	b=O66ndd9Y6r6GOW1IQL19c/9qD+B2+FIB/ynr8RBPi4QdzTnL4whE3sjXM+3/Zu0vX4lkK6
	h9KV5YqOgdcIZEHBxcyqKG4IMQN1WY0HUoV0nTCcdJWRn8YkodKCk3XjR+j3zo+1X1wrTf
	+E7hyWz4jriBKII/ouI/DueYM268Uts=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pOBqVVuIHVvqeyU6wrQ4dgNXmfPDjIBGUxzWzaeok4Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790082921; v=1; x=1790687721;
 b=cgHcJQMG2Yii1JBRXOHyKTaRHPnr561X5sQWfKG7QTarfZEqMSltVpTknBjNqsId+Q9DOBOS
 wo3oaCVuMjkdIAz8Ih4Ca/vPRI3YIOq5Gt7DhPMmJC8BMBJU7xMXNR3jRyvh8ZIE+J+Pca2zmmp
 qFBkwnBi1HWhXGJElbi8ZInk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 957524858cb9f755;
	Tue, 22 Sep 2026 13:15:16 +0000
X-Mizu-Trace-ID: 957524858cb9f755
X-Migadu-Flow: FLOW_OUT
Message-ID: <a1cc2eaa-5a36-491d-8ec7-0bcf4132a535@linux.dev>
Date: Tue, 22 Sep 2026 14:15:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 10/29] mm: make PMD migration-entry splitting explicit
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-11-usama.arif@linux.dev>
 <35f36d8b-d215-439c-8e77-3a70deed7609@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <35f36d8b-d215-439c-8e77-3a70deed7609@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8394880006
X-Rspam-User: 
X-Stat-Signature: uyj7s75ko65hgy61gtqjnd1dkf6g3ksj
X-HE-Tag: 1790082924-647553
X-HE-Meta: U2FsdGVkX19NWmLbP3f7Siix2u3+huRpz1rUdkBQGhnrWOVe9QUduE6GAxYQgNFRWXPqMGACwcRb6gLHANuJGnZX9KKOcZAUDt2zCOe5bOxggzakQCGMifKYHbDPxSuNE6hBADglcP1IBHJQr/nnO4tDK/CvJ2CEMyW40Q6XvQ6DAdPIqIg2SAx3QZZeQje0PwMFTwnkNDGqy+KLGP68n2bWG/poFLb+eaElA7REvGYszPnMnSuDTk1JSWMar01y7YNdEeFs21TM9iZ9PSa4RlQR6kTjVwCrPsm2IbQnGBbjerQg+7LMMfFyJYkOg/eT/ceS80bHhYxrWX7XdGGrBa5nte60qG18t0J4XXepeoeLTXMcxKlY0pBtW2jTF3m9u9TSI1kxZOgxIbi4KKoS8/TzKe56sqzxt8I2AlNY1D0qAU5r6cIBnb1iOD5I7alMVSiBGJx0BJ93Z/1J0gYwypzz/ZxkRgwXDlnrfvM0WO/RDVn5T2zXa4+LaDy5w21u09XqfbFgd1f4tzI7kearfOd1NW15lqlvNl4d8WF0xVufvi+1XFZMroFrQouR3Vhi48rpel+t9ELWBGUR0Ce5ksWipHcE0JRe4z6Tq6DZiw61q76PpA8yhbMMw3yPUWQZs70mZTy+MPT+LkOzUUCfE8oL/l3uYk8fEi/VXRHALCf7kubuQcNMhsuLzPP4Y08cGpB+CPE8Dr9fgQZxnvMaPMi6zBKMdw5rXyFfNKWkjT26KS9CsMD14HOvqos1L4oY3X7591PTpaqw+UzjXaSCLCotv0Sfz1CLosuCLlPR0my8CJe2o46Jxo4Wvh8rm2kllFVbc5Eg297GQI24hqxYNDO0Ffa68c6HUcV7rp2K50qBHxnvQA/jxyVeULqMI0C6L5EHUadeviiaiHvgn3rDFnzr726r0TqxbIt2ljMODam/7XzNHaBgCsua9WI1iWEhOgtLTMY85HFiwoXfkVP
 TuRj7cVd
 pxO9dMT9UoBdc18NNV8w0e6+HGiwIpOKchJ6cHm6PTwOvS/+4+m3vtGhlnhcAqEFSDf+doJ6koHH+iy3H5kmD52Shzzsc8v7+71pbOqfUgsIDU84RAz/QL/hgfdF2mHNiKnDOsOlQ68l5R42OeuSfc2LXyGrh0IEldl+Vzv0HPjCT7CNLYEQFrKK+XIgerpFH9BuC1R9ZBxCgJ/4g2GAUFQSAn6qMKAeFHzTO2MX4z/Hx8JVoAylACfwa01bfuhLA/hQZmhayMHUJB5Z4t59XFFtyiGwNWyck5T+0ffK20EGIKdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/2026 23:10, David Hildenbrand (Arm) wrote:
> On 9/14/26 14:28, Usama Arif wrote:
>> __split_huge_pmd() and friends take a "freeze" boolean that every caller
>> has to pass and almost every caller passes as false. The name says nothing
>> about what it selects, and the one thing it does select - PTE migration
>> entries instead of PTE mappings - is only ever wanted by the rmap migration
>> path.
>>
>> Rename it to use_migration_entries, keep it private to mm/huge_memory.c,
>> and add split_pmd_to_migration_entries() for try_to_migrate_one(), the only
>> caller that wants it.
>>
>> migrate_vma_split_unmapped_folio() also passed freeze=true, but only ever
>> runs on a PMD that is already a migration entry, which the generic helper
>> expands into PTE migration entries either way. Its folio_get() only existed
>> to balance the put_page() that freeze=true performs, so both go.
>>
>> No functional change intended.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> [...]
> 
>> +void split_pmd_to_migration_entries(struct vm_area_struct *vma,
>> +				    unsigned long address, pmd_t *pmd);
> 
> Two tele tabbies please.


Ack, in next revision.

> 
>>  bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>  			   pmd_t *pmdp, struct folio *folio);
>>  void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
>> @@ -690,12 +690,14 @@ static inline void deferred_split_folio(struct folio *folio, bool partially_mapp
>>  	do { } while (0)
>>  
>>  static inline void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>> -		unsigned long address, bool freeze) {}
>> +		unsigned long address) {}
>>  static inline void split_huge_pmd_address(struct vm_area_struct *vma,
>> -		unsigned long address, bool freeze) {}
>> +		unsigned long address) {}
>>  static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
>> -					 unsigned long address, pmd_t *pmd,
>> -					 bool freeze) {}
>> +					 unsigned long address, pmd_t *pmd) {}
>> +static inline void
>> +split_pmd_to_migration_entries(struct vm_area_struct *vma,
>> +			       unsigned long address, pmd_t *pmd) {}
> 
> Dito.
> 

Ack, in next revision.

>>  
>>  static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>>  					 unsigned long addr, pmd_t *pmdp,
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ee8d46827ffdc..873887aed0bc2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2033,7 +2033,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>  		pte_free(dst_mm, pgtable);
>>  		spin_unlock(src_ptl);
>>  		spin_unlock(dst_ptl);
>> -		__split_huge_pmd(src_vma, src_pmd, addr, false);
>> +		__split_huge_pmd(src_vma, src_pmd, addr);
>>  		return -EAGAIN;
>>  	}
>>  	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>> @@ -2257,7 +2257,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
>>  	folio_unlock(folio);
>>  	spin_unlock(vmf->ptl);
>>  fallback:
>> -	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
>> +	__split_huge_pmd(vma, vmf->pmd, vmf->address);
>>  	return VM_FAULT_FALLBACK;
>>  }
>>  
>> @@ -3190,7 +3190,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>  }
>>  
>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>> -		unsigned long haddr, bool freeze)
>> +		unsigned long haddr, bool use_migration_entries)
> 
> 
> Just curious: s/use_migration_entries/to_migration_entries/
> 

Done for next revision.>>  {
>>  	struct mm_struct *mm = vma->vm_mm;
>>  	struct folio *folio;
>> @@ -3291,10 +3291,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  		 * folios w.r.t anon exclusive handling. See the comments for
>>  		 * folio handling and anon_exclusive below.
>>  		 */
>> -		if (freeze && anon_exclusive &&
>> +		if (use_migration_entries && anon_exclusive &&
>>  		    folio_try_share_anon_rmap_pmd(folio, page))
>> -			freeze = false;
>> -		if (!freeze) {
>> +			use_migration_entries = false;
>> +		if (!use_migration_entries) {
>>  			rmap_t rmap_flags = RMAP_NONE;
>>  
>>  			folio_ref_add(folio, HPAGE_PMD_NR - 1);
>> @@ -3344,11 +3344,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
>>  
>>  		/*
>> -		 * Without "freeze", we'll simply split the PMD, propagating the
>> -		 * PageAnonExclusive() flag for each PTE by setting it for
>> +		 * Without migration entries, we'll simply split the PMD and
> 
> "When not splitting to migration entries .."
> 

Ack, in next revision.

>> +		 * propagate the PageAnonExclusive() flag for each PTE by setting it for
>>  		 * each subpage -- no need to (temporarily) clear.
> 
> While at it: s/subpage/page/


Ack, in next revision.

> 
>>  		 *
>> -		 * With "freeze" we want to replace mapped pages by
>> +		 * With migration entries we want to replace mapped pages by
> 
> "When splitting to migration entries ..."

Ack, in next revision.

> 
>>  		 * migration entries right away. This is only possible if we
>>  		 * managed to clear PageAnonExclusive() -- see
>>  		 * set_pmd_migration_entry().
>> @@ -3359,10 +3359,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  		 * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
>>  		 */
>>  		anon_exclusive = PageAnonExclusive(page);
>> -		if (freeze && anon_exclusive &&
>> +		if (use_migration_entries && anon_exclusive &&
>>  		    folio_try_share_anon_rmap_pmd(folio, page))
>> -			freeze = false;
>> -		if (!freeze) {
>> +			use_migration_entries = false;
>> +		if (!use_migration_entries) {
>>  			rmap_t rmap_flags = RMAP_NONE;
>>  
> 
> [...]
> 
>>  
>>  	smp_wmb(); /* make pte visible before pmd */
>> @@ -3477,15 +3477,28 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  }
>>  
>>  void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>> -			   pmd_t *pmd, bool freeze)
>> +			   pmd_t *pmd)
> 
> While at it ...
> 
>>  {
>>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>>  	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
>> -		__split_huge_pmd_locked(vma, pmd, address, freeze);
>> +		__split_huge_pmd_locked(vma, pmd, address, false);
>> +}
>> +
>> +/*
>> + * Split a present PMD into PTE migration entries, for the rmap migration
>> + * walker.  Like split_huge_pmd_locked(), the caller must hold the PMD lock and
>> + * must already be inside an mmu_notifier invalidate range.
>> + */
> 
> I'd prefer kerneldoc but I'll let you decide.

Switched to kerneldoc.

> 
>> +void split_pmd_to_migration_entries(struct vm_area_struct *vma,
>> +				    unsigned long address, pmd_t *pmd)
> 
> two tabs ...
> 
> [...]
> 
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -918,12 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>  	unsigned long flags;
>>  	int ret = 0;
>>  
>> -	/*
>> -	 * take a reference, since split_huge_pmd_address() with freeze = true
>> -	 * drops a reference at the end.
>> -	 */
>> -	folio_get(folio);
>> -	split_huge_pmd_address(migrate->vma, addr, true);
>> +	split_huge_pmd_address(migrate->vma, addr);
> 
> 
> Everything up to this point was trivial :)
> 
> You say that it already is unmapped (which makes sense looking at the
> function name).
> 
> In VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio) we verify.
> 
> Did you run the hmm selftests with DEBUG_VM enabled, just to be sure? I remember
> they exercise at least some of the THP logic in here.
> 

I have now, with CONFIG_DEBUG_VM=y, CONFIG_DEBUG_VM_PGTABLE=y and
panic_on_warn=1, on this series and on the base commit. The result is
identical either way:

  # Totals: pass:35 fail:3 xfail:0 xpass:0 skip:40 error:0

The three failures are file_read, file_write and migrate_file_private,
all of which fail at

  hmm-tests.c:828:file_read:Expected fd (-1) >= 0 (0)

i.e. hmm_create_file()'s open("/tmp", O_TMPFILE), which the VM I am using
with 9p /tmp does not support. they fail the same way on the unpatched
kernel.  The 40 skips are the DEVICE_COHERENT half.

The 40 skips are the DEVICE_COHERENT half.


> 
>>  	ret = folio_split_unmapped(folio, 0);
>>  	if (ret)
>>  		return ret;
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 2888ee638d872..ee33bbb421008 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -530,7 +530,7 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>>  		if (pmd_is_huge(_pmd)) {
>>  			if ((next - addr != HPAGE_PMD_SIZE) ||
>>  			    pgtable_split_needed(vma, cp_flags)) {
>> -				__split_huge_pmd(vma, pmd, addr, false);
>> +				__split_huge_pmd(vma, pmd, addr);
>>  				/*
>>  				 * For file-backed, the pmd could have been
>>  				 * cleared; make sure pmd populated if
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 5332c52909be1..feb751e29b992 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2290,7 +2290,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  				 * restart so we can process the PTE-mapped THP.
>>  				 */
>>  				split_huge_pmd_locked(vma, pvmw.address,
>> -						      pvmw.pmd, false);
>> +						      pvmw.pmd);
> 
> You can feel brave and squeeze it into a single line now :)
> 

Ack lol> 
> Overall LGTM.
> 


Thanks for the reviews!!

