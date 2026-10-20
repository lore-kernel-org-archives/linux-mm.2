Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25B6606A327
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gYFZnEMf
Received: by kanga.kvack.org (Postfix)
	id DD4E06B04C5; Tue, 20 Oct 2026 09:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85876B04C6; Tue, 20 Oct 2026 09:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C746B6B04C7; Tue, 20 Oct 2026 09:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C57F6B04C5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:12:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A7C9A0163
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:12:23 +0000 (UTC)
X-FDA: 85343043366.10.07317DB
Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1ACB41C0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:12:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gYFZnEMf;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.229 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792501941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COtPdQGJK7jNWqfgDfzbpfDSMkuuE3aMgNhGPl3y5n0=;
	b=4RAemQvYroW2YonHOYI+DIXwgrbIA1c3gGwSNcO3lm4YQKWFlFcUw4zK1p9hZ2mDpscIRz
	FnBEiFOtfpx1SS+bjGVtDGvcespWvFL32uU6dTfBomCf9OCghWKACe0E/vw7lmdJxG8ame
	D/K/ypc1DAmhe34/1T+fZ76bmhLiIFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792501941;
	b=CYeCiIeM90xC/PGpHLDefNW5MG4jFqSUJz4k9nNYpJKG/QHAEpu2Ehllsyj+GxdpVUMoAZ
	QAvedwshtyBBB741k8IepOJyKk0AeBmM/WF+6zoqriKU/V+Lmy4DPPcLP7ezT5A4GtkT62
	l4d1JzRRAl+yDYwumJkWqhK+EnPkpoc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gYFZnEMf;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.229 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Wc1RWHwk8Xdv1pW2d6s7sF1ggFAVdoXSgDjlgBucV+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792501937; v=1; x=1793106737;
 b=gYFZnEMfowCMjOFR93SUcUyQK/m2WGEFyHp+36K3Zf0iUSDDpUuEG32E604IF0tb+F8FHLXK
 U7Wc1b3HIMr0AD0aNsmDCuqihhlYSk6WNb0OpBsCxJBBmFDNgiZhrw2bsw0S7xaD/g1cUFqHJqE
 sjKpXCdajMdJGGTQramICtj8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 41652e7101a74390;
	Tue, 20 Oct 2026 13:12:17 +0000
X-Mizu-Trace-ID: 41652e7101a74390
X-Migadu-Flow: FLOW_OUT
Message-ID: <aabae9f2-ceed-4254-a778-aefaea4df257@linux.dev>
Date: Tue, 20 Oct 2026 21:12:08 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Dev Jain <dev.jain@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Christoph Lameter <cl@gentwo.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>,
 Alexander Potapenko <glider@google.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-4-hao.ge@linux.dev>
 <dcad793e-8814-4bbf-8b31-3ec9d0bb9ede@arm.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <dcad793e-8814-4bbf-8b31-3ec9d0bb9ede@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1ACB41C0003
X-Stat-Signature: 9pe7hiuwnuupo4opysbgg1i6phqny7u5
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792501938-694868
X-HE-Meta: U2FsdGVkX1+tLNYt1Hhoq4c8FmDyztW7NFdiIONwvI1XAVyC/UHaDhMaq+fAKudrNZNhvCSMtPg4SD/JDJD1CayVxudcVdUMIim/vb0NPPCrJDW1iPmfjAleCNKDZNuU+dFxg9VF0qfT7LKPCG2zxeaGKv16baHeIvfulPo+IYB6bxRuZ2DHQXY/hPMlkI3qCNm1GSYjdtnUZ6C3C6vIJjzUur5SdP20VQJATZQ8Ug0HJ7xaOls3+xOQoJqkxHhifdUpK36LZIFsPDrcd9eGvYQxYu5/qPbxTzwcnlNnnXCiY9GV3FuGUhPV1VBaRN16/ztSdGGlR1sshJtgk3TY0PLOjvVP7oh3ELn8ssPw6SlWd6PnheReIJ1zRIzg6O27BRyRiRhq0nUAATSKzltM0S+mbi3TgTYgiBuabQXSOveXEcyXaoJ64u4liGPUdmfi7T7gKYLsEvb7hkwp8xdpNT4Jkd9CV8/8w90SfaTQQYtBO1JMbRUXiWrhE0clcqU/Nu/fMJygw+/4qTcbiea6sgi3DbmUmWgAx6ANEhyW7vZIczCcqc6NGkyW3cohp0o3pj4FQi6zr/RCZOP1cFKdgGnCIS+h1ybBh9nhMyGm8klfzgjSMf8WqL8jU+y4uqeZtYmVLuRnFcz7YvScPEBq3qoCDf2Q9EpJP8rkJGd2mVmAbkr5eIEoyMnZ0vZyo2Yd/pQFynMsMjI+exSMgRUgN/vE7msXdgh8zx8FKjpK22Xbdr6vZWbvw6CoBL17NNCRxZeFDeUtgYajDfaD1u+86DL46hrLQ1MqE5vRUwJUXhGc8nDdYRNKKCQyN4kW/EpcwytuEd7wOAxnVj1ZVLtxzXKDfC8Mj8YxhOfWlb6SKcmRhUARHqHj2RnbxXADN4yIp3bkp312Edl/zoOFb58REOX2JZaYwKfh8M3RiL1MjGLfCdfwO+GkTWZv9asWt8WMWkRFXW6vYk9fXmPdlFP
 EVUsYZiC
 3rjzyXOQudZkJFxywEHhBRdrvTc01UENNXJvCwIQ+ETsDzHfJLaTCUgGkmTyCQAZQNZ8tn0Myu3V6l8aBJtWRI8CLNmRw7uMLGrLYSgTUgHf+2aILAuT3AxK0Hz1zTrluXo+QCBgbcscEosvYSIS0WXrfOf3velbe9aCWv1DD5NXq9GysKaVFj0TezQzhtGz8Yrpkf9Lbq7hIwehOYLR6WBDQtcL3V54bktKjMCzsAa0v05zDg6Vb3fl7G0/KxrtI7nwva08ZlpBtvYLxTjMr72FRig58JNdO/CuICzuwzkmNwJPlmfKlc/Z88pxpgsILrn6yzrPMmul7V/IkFkQiPRIkYs/JqaJrqPzrj8QsR/QcITc8qdni3QjIHAn6tIE4YomrY8f4PMkNdyUhaFq7ihdBlKfPbJj8MdiY59LddraOnFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dev


On 10/20/26 13:46, Dev Jain wrote:
>
> On 19/10/26 11:15 am, Hao Ge wrote:
>> __vmap_pages_range_noflush() and friends can install some PTEs before
>> failing and leave them mapped, and the kernel callers do not agree on
>> who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
>> roll back what they mapped before the failure, while
>> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
>> __vmalloc_area_node() rely on the mapping functions cleaning up and
>> do not call anything like vunmap_range() themselves. When the same
>> range is mapped again, the attempt hits the leftovers and fails, with
>> a BUG() in vmap_pte_range() for huge mappings and a warning on the
>> small-page path.
>>
>> After discussing with Suren and Ulad, we decided to put the rollback
>> into the entry points of the vmap API rather than into every low-level
>> helper. __vmap_pages_range_noflush() undoes the whole range it was
>> asked to map when it fails, and vmap_page_range() undoes its range
>> for the ioremap-style mappings.
>>
>> The rollback is __vunmap_range_noflush(), it only clears the PTEs,
>> no TLB flush, nothing has touched these mappings.
>> vmap_pages_range_noflush() drops the KMSAN metadata when the data
>> mapping fails, and an empty range bails out with -EINVAL now, which
>> used to BUG_ON() on the small-page path and map nothing at all on
>> the huge-page one.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Suggested-by: Uladyslau Rezki <urezki@gmail.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>   mm/vmalloc.c | 44 ++++++++++++++++++++++++++++++++------------
>>   1 file changed, 32 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 44e0eb32708f..75aa5acf5566 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>   	if (!err)
>>   		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>   					       ioremap_max_page_shift);
>> +	if (err)
>> +		__vunmap_range_noflush(addr, end);
>> +
>>   	return err;
>>   }
>>   
>> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>   		pgprot_t prot, struct page **pages, unsigned int page_shift)
>>   {
>>   	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>> +	unsigned long start = addr;
>> +	int err = 0;
>> +
>> +	if (WARN_ON_ONCE(addr >= end))
>> +		return -EINVAL;
> IIUC this is a general change independent of this patch? Caller could pass
> addr >= end and if we take the huge mapping path, we lose the sanity check.
>
> So this could become a separate patch.


OK,  and Sashiko has flagged another case:

when 0 < end - addr < PAGE_SIZE, nr = (end - addr) >> PAGE_SHIFT 
evaluates to 0,

so the huge-page path still maps nothing and returns 0.

So this separate patch would cover this case as well.


Thanks

Best Regards

Hao


>
>
>>   
>>   	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>>   		return -EINVAL;
>>   
>>   	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> -			page_shift == PAGE_SHIFT)
>> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
>> -
>> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> -		int err;
>> -
>> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>> +			page_shift == PAGE_SHIFT) {
>> +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
>> +	} else {
>> +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>   					page_to_phys(pages[i]), prot,
>>   					page_shift);
>> -		if (err)
>> -			return err;
>> +			if (err)
>> +				break;
>>   
>> -		addr += 1UL << page_shift;
>> +			addr += 1UL << page_shift;
>> +		}
>>   	}
>>   
>> -	return 0;
>> +	/* Undo the PTEs installed before the failure. */
>> +	if (err)
>> +		__vunmap_range_noflush(start, end);
>> +
>> +	return err;
>>   }
>>   
>>   int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>   
>>   	if (ret)
>>   		return ret;
>> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>> +
>> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>> +	/*
>> +	 * The page tables undo themselves on failure. Tear down the
>> +	 * metadata that was fully set up before the mapping failed.
>> +	 */
>> +	if (ret)
>> +		kmsan_vunmap_range_noflush(addr, end);
>> +
>> +	return ret;
>>   }
>>   
>>   static int __vmap_pages_range(unsigned long addr, unsigned long end,

