Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BA3CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4116B0092; Fri, 29 May 2026 10:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674126B0095; Fri, 29 May 2026 10:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562EA6B0096; Fri, 29 May 2026 10:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 458AF6B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:12:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDE581C055D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:12:20 +0000 (UTC)
X-FDA: 84820647240.19.8595161
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id 04EC31C0008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:12:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JLPCvJK7;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780063939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4X9vwkCHSddENx5Gglm/hOpAgU7U6Z+T82AMSjAjBE=;
	b=8diX3cqXGJwPVmJlN8YyLU/q3Eq0CRSGtRFNxgxoHoDN3c+rJDRL60rurQgsCGKUl/KFLL
	jluaeGQGtZzC8hUn5FWK5JfQXPMXMP9hEdq3X0x6/GdTUzcBoeV/iwAvr0dl/aAG1I+fYa
	LDNYnnl+strL70klVgXZrxdbBJp2oXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780063939; a=rsa-sha256;
	cv=none;
	b=LxOD/6csb7dWeDT/BAeH+TlDRXwpApXRW3NH2RTSAFxeP1+HlPZkYmb3u3LUw17y1ehUIx
	0dX2FmQ19MBZ4Ar7AhxBMy3/8LzJmwyQoZ1xC7d1NPpmWxMeEnrMJ357147f4CuwCWxzLk
	y66pf4irhcCg3Nc4PwgzzmY08vlDako=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JLPCvJK7;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780063936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d4X9vwkCHSddENx5Gglm/hOpAgU7U6Z+T82AMSjAjBE=;
	b=JLPCvJK79SCpodHOC8Zl7IddRjrtvqukUPFRrtPCcLMxUdCF4RZ8uQartrpJUibd2h/66X
	OJmBi26/H0srMKbN/NTfSuaPmdtYQJqsTVgTE3BqugvznrnDzBw13w0Sr97417lH5mhsow
	m1e8Tfw0EnsU1yOvo438g2t//YFHiRs=
Date: Fri, 29 May 2026 15:11:54 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
To: Pedro Falcato <pfalcato@suse.de>, willy@infradead.org, jack@suse.cz
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev,
 "Liam R. Howlett" <liam@infradead.org>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
 <ahlh2vdHEGo6ZSot@pedro-suse.lan>
 <cc9a1cf7-7b96-439a-b0be-ecdcf27b5da5@linux.dev>
 <ahmSolHvUChl-3vM@pedro-suse.lan>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ahmSolHvUChl-3vM@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 04EC31C0008
X-Stat-Signature: upzji6s9ow4ijyoby76jjd6cohenpcka
X-Rspamd-Server: rspam06
X-HE-Tag: 1780063938-249307
X-HE-Meta: U2FsdGVkX18UruBxrWR57eUynyp1ElDTYrq1XrTNFLW8aPd4CMVtwSFrFhrF2vWJih2MVtsCfbk0NsaTZB7pSt/9keqzqwx/IKI2XuDa/9vy9g+2LhvBfJrkKngmgbUBWgfWHsFPGTyVU/zztCfyzVvLSfFHLCYLvA+KpexbvFxNIb2SHpIo4Ev/H/R3PHiASnRaBKu91VkMH4c5xvE0WqYdn6zIzkyzFBOuP2IFBZJDZ5OwRRJ7XZr+SYMC4eBg8opt0TABR/gYp3ySJcR0tlYkNwuLmUBbFBT6NYyX89504GLEAtrS7Ch81Xehnf3HXRmh6R3RgiECgX6BzyFZRd64Z4BNV8Uf8sZuxeSu7+3MpXlX9jUfZ1HggK8QF/BB+6ruiIgpETw7UKPTL9TL6XcvVEhZbDvX57wFysulLHTaQ607v1m9DjTNj99wJQMa0kwzWCUytXWjqi3/eWv3ELRvovOgooBgIVtIoVChhDJnUN3RQv74k6GdDMadoWT23Fmm57/LkkyMCPEFD9hEmbSkEWvPkApos+lApOky8HRfvvzStmCmYkJ0Yq5WKaizPVWsjAvtrm9mMwcEs3hiviM6r3HXfHN37JQ621YIGR6ROEhAAdM1hfkg4ti+6nDNj+EF629OZwtljijaIOHoEbmLMqeVbzR4OLkfWcUi4YAqN6rsxIKAe3iNe1kf3Y30IgRDj+bKXd1EAKcz4/MPPYfsYftkzR4H+zOxhKCJcOMA4yBNLkK1zexGPaz8xAal2XGtPLDt4s3YHwDSqdQzifBTEmqi8YdQhNmIwfE9hTLf9rpfK9JrvgoOQPvqHuIbrFNPB/Hv29gMdKert3UKLBIkDyN+GyDmFAJ0YPT0WWnQp99J+p9IUJsrFiKc8CVbn8r/+9SinXmQsIDFsz+JeeoWaLUqyc1uG9I0i9lXNe4dWR1AE3iaBR+5eRPdGh/zh/mVHigw4+4dAK9+DeV
 yG8Lz4Qm
 qmY/Iys0Cd6+p5pSfo8W/AjMGFpsbfpOeAVSPxNoFO1Myxtpow0Egm3kpbmIUsrv9Gnbvzj7r/x/DpEWd2rqQXoCjWAj3VF3HnOVwwcj4Y8XY7SMqciAtuLQnUTFpmIJe/93qFwfmCvKyMizM5/EaPxN0eqea0SHuJqEYIZ++/B88SF8zaPu6yBKnhU7Thr6du3HVfqUZgCw9pxVX4RRI8MhhzeTkk0lw00bpEQAJnsY11RhZt74rURSRYpGN/MYo4M9lNJ04uHSrEh5bE/r5Bp8oUC2MuLRmoqvm0VecUeimOOykM3zFPVtFyXnNuEbGyZqg9KfIj7xp6D9QjffRsgl1XwUBS8eycwxl9sIb2lwVaew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/2026 14:40, Pedro Falcato wrote:
> On Fri, May 29, 2026 at 01:19:03PM +0100, Usama Arif wrote:
>>
>>
>> On 29/05/2026 11:01, Pedro Falcato wrote:
>>> On Thu, May 28, 2026 at 09:55:20AM -0700, Usama Arif wrote:
>>>> The force_thp_readahead path in do_sync_mmap_readahead() is gated on
>>>> HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
>>>> HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
>>>> exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
>>>> VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
>>>> mmap readahead path even when the mapping supports useful large folios.
>>>>
>>>> Keep the existing PMD-sized behavior when HPAGE_PMD_ORDER fits in the
>>>> page cache. When it does not, enable forced readahead for mappings that
>>>> support large folios and request an order capped by both
>>>> mapping_max_folio_order(mapping) and 2MB.
>>>>
>>>> 2MB is chosen as the cap because it matches the PMD size on x86_64
>>>> and on arm64 with 4K or 16K base pages, so the size/memory-pressure
>>>
>>> 16K base page size's PMDs should be 32M, no? Am I misunderstanding what
>>> you mean here?
>>>
>>
>> Yes, should have just said 4K. Messed up when rewriting the commit
>> message. Andrew Thanks for merging in mm-new, would it be possible
>> to remove "or 16K" from the commit message. I can send a new revision
>> as well if that is easier and preferred.
>>
>>>> tradeoff for folios of that size is already well understood. On arm64
>>>> with a 64K base page size, 2MB is also the contiguous-PTE (contpte)
>>>> block size, so the resulting folios coalesce into a single TLB entry
>>>> and reduce TLB pressure on the readahead path.
>>>>
>>>> The final allocation order may still be clamped by page_cache_ra_order()
>>>> to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
>>>> on such configurations a large-folio readahead request instead of
>>>> dropping back to base-page readahead.
>>>>
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>>  mm/filemap.c | 27 +++++++++++++++++++--------
>>>>  1 file changed, 19 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>>> index a16b33e0fc71..bfb891d9da1f 100644
>>>> --- a/mm/filemap.c
>>>> +++ b/mm/filemap.c
>>>> @@ -3312,14 +3312,23 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>>>>  	struct file *fpin = NULL;
>>>>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
>>>>  	bool force_thp_readahead = false;
>>>> +	unsigned int thp_order = 0;
>>>>  	unsigned short mmap_miss;
>>>>  
>>>>  	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
>>>>  
>>>>  	/* Use the readahead code, even if readahead is disabled */
>>>> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>> -	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
>>>> -		force_thp_readahead = true;
>>>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
>>>> +		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
>>>> +			force_thp_readahead = true;
>>>> +			thp_order = HPAGE_PMD_ORDER;
>>>> +		} else if (mapping_large_folio_support(mapping)) {
>>>> +			force_thp_readahead = true;
>>>> +			thp_order = min_t(unsigned int,
>>>> +					  mapping_max_folio_order(mapping),
>>>> +					  get_order(SZ_2M));
>>>
>>> This looks somewhat arbitrary to me (as does the old logic). It seems more
>>> natural (correct?) to do this:
>>>
>>> 	if (THP_ENABLED && (vm_flags & VM_HUGEPAGE)) {
>>> 		if (mapping_large_folio_support(mapping)) {
>>> 			force_thp_readahead = true;
>>> 			/*
>>> 			 * Cap THP readahead to either the max folio order the
>>> 			 * mapping supports, or the max order the page cache
>>> 			 * supports (useless to try more), or the hugepage PMD
>>> 			 * order (CPU can't benefit from larger).
>>> 			 */
>>> 			thp_order = min3(mapping_max_folio_order(mapping),
>>> 					MAX_PAGECACHE_ORDER, HPAGE_PMD_ORDER);
>>> 		}
>>> 	}
>>>
>>
>> So this can result in extreme memory pressure. For example, on 64K base page size,
>> with HPAGE_PMD_ORDER = 13 (512M) and MAX_PAGECACHE_ORDER = 11 (128M), this will evaluate
>> THP order to 128M. I think Jan mentioned in previous versions that there are already
>> reports of high memory pressure due to large file folios, and we are seeing this
>> in our fleet as well with xfs.
>>
>> I chose 2M cap as that is what most (not all) architectures which currently support this
>> hugepage code flow are currently used to, and on archs + base page size combination which
>> just evaluate this code to base page, for example 64K base page size, it will provide a
>> performance uplift without causing excessive memory pressure.
> 
> For what it's worth, memory pressure is still a problem even on 2MB folios. But
> yes, I understand.
> 
> For what it's worth, I don't think it's such a big issue in this case - you're
> asking for THPs, and you're getting them - though maybe not efficiently because
> these aren't at the PMD level. But this is also true for e.g x86 where an
> an order-3 folio or order-7 folio are completely useless for the hardware, since
> there is no mTHP to speak of (and, with that, you also lose PG_active and
> PG_reference precision as you only keep one of each for each folio, amongst
> other tradeoffs).
> 

So there is hardware TLB coalescing on almost every new AMD CPU, I believe it is
at 32kB, and we would benefit from that. On top of that, we would reduce pagefaults.

>>
>> In pagemap.h, we have
>>
>> #define PREFERRED_MAX_PAGECACHE_ORDER	HPAGE_PMD_ORDER
>> #define MAX_PAGECACHE_ORDER	min(MAX_XAS_ORDER, PREFERRED_MAX_PAGECACHE_ORDER)
>>
>> So MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always true.
>>
>> At filesystem/inode setup: mapping_set_folio_order_range() 
>>
>> 	if (max > MAX_PAGECACHE_ORDER)
>> 		max = MAX_PAGECACHE_ORDER;
>>
>> so mapping_max_folio_order() <= MAX_PAGECACHE_ORDER is also always true.
> 
> Right, good point. (well, I suppose it will not be true in the future as
> someone tries to harness PMD-level cont bits)
> 
>>
>> which means mapping_max_folio_order(mapping) <= MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always
>> true, and you dont need the min3(..) in your diff.
>>
>> Now the question is if then why not just do:
>>
>> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
>> 		if (mapping_large_folio_support(mapping)) {
>> 			force_thp_readahead = true;
>> 			thp_order = min_t(unsigned int,
>> 					  mapping_max_folio_order(mapping),
>> 					  get_order(SZ_2M));
>> 		}
>> 	}
>>
>>
>> This is because this will regress the 16K ARM case where we already got 32M
>> folios. Someone might upgrade the kernel and start getting 2M folios now.
> 
> So maybe limit to 32MB? It's still arbitrary but at least you get simpler
> logic. If the architecture does not support 32MiB folios, it will clamp
> the maximum folio order to HPAGE_PMD_ORDER, and you get the same result.
> 
> Does this sound correct?
> 

Yes, so if we replace it with SZ_32M, it sounds correct. I just think
the 32M size is too large. But as you pointed out, even 2M can be too large...


>>
>> So IMHO the current code is correct, both in maintaining what the
>> existing behaviour has been, but also trying to provide large folios to
>> architectures that currently dont get them but in a controlled way.
>>
>> Later on, when we think or evaluate that 2M was too small a cap, it can
>> be raised. I think its very easy to raise a cap, but much more difficult
>> to make the cap smaller, as we might get reports on kernel upgrades that
>> someone was getting a certain size of folio but now its much smaller.
> 
> I don't think this is a valid argument. You can also have reports that now
> folios are too large and they're regressing workloads because of thrashing/
> compaction/possibly TLB thrashing. And indeed we have several reports of that
> (https://lore.kernel.org/linux-fsdevel/20260403193535.9970-1-dipiets@amazon.it/
> comes to mind, plus all of the anon THP regressions over the years, including
> in $current_year).

Ack, and yes we have seen both thrashing and compaction issues due to xfs
large folios in the fleet with x86..

> 
> Bottom line is that changing things will always affect someone :) Particularly
> since the logic we have is not too careful at deciding what should or should
> not be a THP (both in anon and file cases). And if (once?) we make it smarter,
> it will surely also regress someone!
> 

Yes completely agree on this as well.

So personally I do have a preference of keeping the cap at 2M atleast initially
while we currently try and solve the issues we see with 2M alone. As we are already
seeing reports of thrashing and compaction with just 2M, I dont think the logic
in this patch with just an if else is that complicated.

Matthew, Jan, do you have any thoughts or strong preferences on cap size?

Thanks!


