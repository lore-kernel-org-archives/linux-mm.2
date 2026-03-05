Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5836F3D32A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA566B0005; Thu,  5 Mar 2026 11:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8D46B0088; Thu,  5 Mar 2026 11:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A046B0089; Thu,  5 Mar 2026 11:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1A5D6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:36:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4CCFB13953E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:36:53 +0000 (UTC)
X-FDA: 84512563506.06.8F592F4
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5D67DC000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:36:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tBkBZOZH;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772728611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZEACY0w6p1F/1mA7+wiGulJIc6EJcvMbxkcXFSWO7M=;
	b=kyZmRNFXnD4q3itmqL6Qjvbch1EBqVi8bvsTN/u9aFCujH+zpE8CvY99OMhW4ajq23suoz
	j0zfRO8QaEyX4J5bQtDALfh+dGf8Ebrg5l9kLobeSeVs3poxSMWKdqIKpuYHM+u87jo/fd
	xhi7vqIuWpeFkjeTirHfB5xKw/sWvyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772728611; a=rsa-sha256;
	cv=none;
	b=FNk25sUl/sAgp93uk05fN9GX/AwOA+O9wtrxtACAvYxRKaYBKAOZ+iYS3bt2vAxEMA3N3a
	/CoJaYTIpdQsG5h3UpT/R2007aqNraFpnxM/3u7z1S6YIT+XjM0vSc9Y2eQ4DgHSAJm4x9
	YoU340EoiW5+WiRZohn+okOMsDzfaf8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tBkBZOZH;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772728606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ZEACY0w6p1F/1mA7+wiGulJIc6EJcvMbxkcXFSWO7M=;
	b=tBkBZOZHgbDMXrNl2uIWmY8tpkXH+/+UyFZwuEi1tJSc2t0G1oh6K2EgK1LhfOcbfVMmjM
	6DHd18gWEOsGKGCE/In5gcI/Zu8ZsT6PNyNi+ta7Z/MNMnKW4r8oXlZuW8Bjle97K/oLgF
	gdMmuhAMZovOodFSuUtwdqVyMGRL150=
Date: Thu, 5 Mar 2026 19:36:28 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Content-Language: en-GB
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Kiryl Shutsemau <kas@kernel.org>, matthew.brost@intel.com,
 npache@redhat.com, david@kernel.org
Cc: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
 <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
 <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
 <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
 <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
 <80683d6d-ea38-4326-af5e-e4c173bb1930@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <80683d6d-ea38-4326-af5e-e4c173bb1930@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4kiscw8o5oi4y7wccdrhothq3t47e1kb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D67DC000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1772728609-896403
X-HE-Meta: U2FsdGVkX19f3pHWleY5PuS5szVz6HRpk8bmRY/nraE5xWYmzKkz0U9YXwzNz0zNWRZCeL2XhnJZXYhuZIRf9OQZV9cZUNLXn1H0AoThCfaR2zGrjLdq+pKgJLvwQ2T1hJDNX5kMo0AW0DlsOr2JyBJN/tQ5FO+vZ9FUa1kmS98TxUtQGNO7iGdQgwGKCxrT6jzPxXmWlqsQtJF0Sv0E1rSWEACeT/wnKT4/lsV7JQkMSHpkvQYek5kbe0c96TSqbhjKKSN8FBt4bOahrWn3ukcDjwupawTDJceXE8pziJL8b4RQvCegNkiTodKUGaX6hMP0KDumZb3JUXB4KA7mpuql4iGkrZ2kCotvE7+MWQu9u5SuFnB6X5/sK42GzZmoZlqIsTCkGbi4xEzcHMFP/oc44b/9rbK339wpiXvhrSEtsqCpFcbONV2BZEnUZgifAI9Ge6dYEGy7JnQyzlVLsZWULTST+OSTGlBLS+p0hjI1ULlO9NEYvy3L14l/U2/qiLYe+XfHmU1BX979rK2/KwTSwG94lxvtpJhKWKIhd4EuUB8Z8xaq9AVMuwQjt//Gxe0lKzw/3aEL6O61eIU2OFCMj5AdC4IhthmWVP9xTiVMnUCn1L9KHG75lu7lZ6En5VLFw715n/DmrGXvxDnRYqm4nrUa4L7gDuyfQFWCsMWC7FBEFvaLga38di0NLTJYBI/jY7goPnjIgTEaZX0ZFN0Iq8GZfS24//JuwHS5Rmbd8D5ItZ9T0+M7IZx+nthmcTtwgXaG5AC2E0mmR0ZGCPnG5Z5Z51yEVQdyXRKIrfwen/TUBWJR/Pzw/hWgwmSu6fk6260iuAzk2RkWuJ73ezwp8D0eo+q2uuPyCAoCNzsMiKO23rv4C0cBfk8L5nukF8vJDeuKbznHxWCQFokxiKl2uqu2kioPq8BnIGnuJsLntC0gkxdndTx/9Al26hZGGNbqpacekhC6SGaSwi7
 jpWCIOTr
 D52niXYyudzhACipAvigLwtrHZNELEptVmYdHCwwX01SFeYQmpSwT3fy2FqIYwSTTpH2WcWiKaOHJ/cZNLV/i7STC8c6JQup3egLDVej2ftMFLovC9h5zAnLmRN75ygBpzEiS74Ha5uf9vZHl1TyFrAosT0dwSb6viMbTQv1Kmr1ldW5IDO4qal1FAgy34zG3HgQqSWlOWmWoLizqZSpPcOzH3HnZif6Dg28fNm+ERVHhVghpYNKGqdR3S7Aoxcezq6QEwuI4E/gYkJxh0GVdsyGlwbUW7g0QACQsN+8FNFMyW5lxWTSDtovY0Mu91N8FzBUPJ+rQoPzHIrViBWS1PNnmdEiNg7N+Bs+UVPog6Ixs3w08q856jkbUxlgGp1LgBwmlQVMSBVULwTwoBOAy81NyIGLIeewh5Try0o+k7HlFu+IGuUSnXiPJgKogqBr4ngFiKL5Zk0gpR2trJxPqKyQan86OF349194xIPnCQfKp1a85UlRgQ1O8HmFZHFFfqi1YBbteUtu57CfiAyfaZVQmuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/03/2026 12:09, Mika Penttilä wrote:
> On 3/5/26 13:44, Usama Arif wrote:
> 
>>
>> On 05/03/2026 06:09, Mika Penttilä wrote:
>>> Hi!
>>>
>>> On 3/5/26 01:28, Usama Arif wrote:
>>>
>>>> On 04/03/2026 22:09, Balbir Singh wrote:
>>>>> On 3/5/26 08:54, Zi Yan wrote:
>>>>>> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
>>>>>>
>>>>>>> On 3/5/26 02:17, Zi Yan wrote:
>>>>>>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>>>>>>
>>>>>>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>>>>>>
>>>>>>>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>>>>>>>> folio_get() before calling folio_split_unmapped().  On success, the
>>>>>>>>> split consumes this reference: __folio_freeze_and_split_unmapped()
>>>>>>>>> expects the +1 in its folio_ref_freeze() check, and distributes it
>>>>>>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>>>>>>>>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>>>>>>>>
>>>>>>>>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>>>>>>>>> -EAGAIN), the function returns without calling folio_put().  The extra
>>>>>>>>> reference is never released.
>>>>>>>>>
>>>>>>>>> Add the missing folio_put() on the error path.
>>>>>>>>>
>>>>>>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
>>>>>>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>>>>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>>>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>>>>>> ---
>>>>>>>>>  mm/migrate_device.c | 4 +++-
>>>>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>>>
>>>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>>>>>>> --- a/mm/migrate_device.c
>>>>>>>>> +++ b/mm/migrate_device.c
>>>>>>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>>>>>>>  	folio_get(folio);
>>>>>>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>>>>>>  	ret = folio_split_unmapped(folio, 0);
>>>>>>>>> -	if (ret)
>>>>>>>>> +	if (ret) {
>>>>>>>>> +		folio_put(folio);
>>>>>>>>>  		return ret;
>>>>>>>>> +	}
>>>>>>>>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>>>>>>>>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>>>>>>>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>>>>>>> -- 
>>>>>>>>> 2.47.3
>>>>>>>> Add Balbir, who wrote the code, to comment on this.
>>>>>>>>
>>>>>>> Thanks Zi!
>>>>>>>
>>>>>>> Just wondering if there is a reproducer for the issue and how the fix was tested?
>>>>>>> I expect migrate_vma_finalize() to be called for folios, even when split failed and
>>>>>>> drop the lock.
>>>>>> Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
>>>>>> If so, how does it distinguish between split folios and failed-to-split folios?
>>>>>> By comparing source and destination folio orders?
>>>>>>
>>>>> We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.  We do a folio_put
>>>>> on the src in finalize, if it is split then on all the split folios as well.
>>>>>
>>>>>> What we see from migrate_vma_split_unmapped_folio() is that
>>>>>> it adds a refcount for all input folios, but only drops a refcount
>>>>>> for the split folio. Isn’t it cause failed-to-split folios to have
>>>>>> additional refcount?
>>>>>>
>>>> Hello!
>>>>
>>>> Thanks for reviewing everyone. So its very difficult to create a reproducer I think
>>>> the extra reference would need to appear after migrate_device_unmap() but before
>>>> folio_split_unmapped() in migrate_vma_pages()? That's hard to trigger reliably from
>>>> userspace.
>>>>
>>>> The fix came about when Nico indicated there might be an issue if split_huge_pmd_address
>>>> fails in my patch [1].
>>>>
>>>> Below is my understanding of how refcounting is working over here step by step. I
>>>> might very well be wrong on this, and the refcounting is a bit all over the place
>>>> and I might miss a reference change somewhere so would really appreciate if someone
>>>> can confirm this!
>>>>
>>>>
>>>> 1. migrate_vma_collect_huge_pmd():
>>>>   a) folio_get(folio) -> +1 (collect reference)
>>>> 2. migrate_device_unmap():
>>>>   a) folio_isolate_lru() -> +1 (isolation reference)
>>>>   b) folio_put() -> -1 (drops the collect reference)
>>>>
>>>>
>>>> Without this patch fix:
>>>>
>>>> 3. migrate_vma_split_unmapped_folio():
>>>>   a) folio_get(folio) -> +1 (split reference)
>>>>   b) folio_split_unmapped() -> fails
>>>>   c) Returns error — without folio_put() which is the fix
>>>> 4. Caller in migrate_vma_pages(): clears MIGRATE_PFN_MIGRATE | MIGRATE_PFN_COMPOUND
>>>> 5. __migrate_device_finalize(): sees !(src_pfns[i] & MIGRATE_PFN_MIGRATE), restores the folio:
>>>>   a) remove_migration_ptes(src, src) — re-establishes user PTEs
>>>>   b) folio_unlock(src)
>>>>   c) folio_put(src) -> -1 (drops the isolation reference)
>>>>
>>>> The split reference in 3.a is never released and the folio has a permanently elevated refcount.
>>>> Unless I missed a folio_put somewhere for the refcount increase in folio_isolate_lru() (2.b)?
>>>>
>>>> Please let me know if this makes sense!
>>>>
>>>> [1] https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>>
>>>>> Thanks! Yes, the patch makes sense
>>>>>
>>>>> Acked-by: Balbir Singh <balbirs@nvidia.com>
>>>>>
>>>>> Balbir
>>> I remember stumbling on this while ago also. The folio_get() in migrate_vma_split_unmapped_folio()
>>> is balanced with put_page() in __split_huge_pmd_locked() (freeze = true), can't fail for device pages.
>>> Folios at this point are unmapped but have 1 refcount from "collecting". 
>>> After folio_split_unmapped() the refcount(s) is still 1.
>>>
>>> So it seems the code is good as is? A comment though would be good for the extra folio_get..
>>>
>> hmm I dont think the put_page() in __split_huge_pmd_locked() is there to balance the folio_get() in
>> migrate_vma_split_unmapped_folio(). There are other points where split_huge_pmd_locked() is called
>> with freeze = true [1] and they don't get a reference before calling split_huge_pmd.
>>
>> I think the folio_put() in __split_huge_pmd_locked() freeze = true case is there as migration
>> entries are being installed?
>>
>> [1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/rmap.c#L2334 
>>
>>
> Yes normally you want to drop the reference when installing migration entries but in this context
> you have already done the collecting for the THP folio and you want to balance with the folio_get()
> the put_page() to keep the refs unchanged. Is that right Balbir?
> 
> --Mika
> 

Hi Mika,

You are right, This patch is wrong. I tried the below diff to force folio_split_unmapped to return
-EAGAIN. I ran tools/testing/selftests/mm/hmm-tests -r hmm.hmm_device_private.migrate_anon_huge_err
to trigger the path for folio_split_unmapped.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74adf..6df33b4990a13 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4140,6 +4140,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
        if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
                return -EAGAIN;
 
+       return -EAGAIN;
+
        local_irq_disable();
        ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
                                                NULL, false, NULL, SPLIT_TYPE_UNIFORM,



I inserted a lot of traces to keep track of refcounts [1]. Without this patch, I get
....
       hmm-tests-129     [000] .....     1.476233: __migrate_device_pages: SPLIT_UNMAPPED: folio=ffc536e2c4100000 refcount=0 AFTER error NO folio_put
       hmm-tests-129     [000] .....     1.476234: __migrate_device_pages: PAGES: split FAILED folio=ffc536e2c4100000 refcount=0
       hmm-tests-129     [000] .....     1.476236: __migrate_device_finalize: FINALIZE[0]: src=ffc536e2c4100000 dst=ffc536e2c4100000 src==dst=1 refcount_src=1 mapcount_src=0 order_src=0 migrate=0 BEFORE remove_migration_ptes
       hmm-tests-129     [000] .....     1.476237: __migrate_device_finalize: FINALIZE[0]: src=ffc536e2c4100000 refcount=1 mapcount=0 AFTER remove_migration_ptes
       hmm-tests-129     [000] .....     1.476237: __migrate_device_finalize: FINALIZE[0]: src=ffc536e2c4100000 refcount=0 AFTER folio_put(src)

i.e. refcount = 512, which is correct as split_huge_pmd_address was successful. Full output is
at [2].

With this patch, I get:

BUG: Bad rss-counter state mm:00000000cfe88d5e type:MM_FILEPAGES val:-511 Comm:bash Pid:63                                                                                                                                                                                                                  
BUG: Bad rss-counter state mm:00000000cfe88d5e type:MM_ANONPAGES val:511 Comm:bash Pid:63  
...
       hmm-tests-129     [000] .....     1.468315: __migrate_device_pages: SPLIT_UNMAPPED: folio=ffed210c840f0000 refcount=1 AFTER error folio_put FIX PRESENT
       hmm-tests-129     [000] .....     1.468315: __migrate_device_pages: PAGES: split FAILED folio=ffed210c840f0000 refcount=1
       hmm-tests-129     [000] .....     1.468318: __migrate_device_finalize: FINALIZE[0]: src=ffed210c840f0000 dst=ffed210c840f0000 src==dst=1 refcount_src=1 mapcount_src=0 order_src=9 migrate=0 BEFORE remove_migration_ptes
       hmm-tests-129     [000] .....     1.468357: __migrate_device_finalize: FINALIZE[0]: src=ffed210c840f0000 refcount=513 mapcount=512 AFTER remove_migration_ptes
       hmm-tests-129     [000] .....     1.468357: __migrate_device_finalize: FINALIZE[0]: src=ffed210c840f0000 refcount=512 AFTER folio_put(src)

refcount=0 means the folio would be freed which is not correct. The full output is at [3].

Thank you for clearing this up!


[1] https://gist.github.com/uarif1/65e1e816af7aa0ae38dd6ec64d62a993
[2] https://gist.github.com/uarif1/79ea9500667daa4e2ef09cb5d308f041
[3] https://gist.github.com/uarif1/8a35a6c65ba8b3a1c1dfe72dc30e821d




