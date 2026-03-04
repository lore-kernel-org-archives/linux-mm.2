Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC93DEFCE53
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 23:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76BD6B0005; Wed,  4 Mar 2026 18:28:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D249E6B0088; Wed,  4 Mar 2026 18:28:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06036B0089; Wed,  4 Mar 2026 18:28:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B04446B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 18:28:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F0331606E5
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 23:28:54 +0000 (UTC)
X-FDA: 84509972988.23.D7B1ECD
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32730C000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 23:28:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OBI9KBjL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772666932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAFPQJJJhNNoX80Afk7miOJW6kwTQgtVOuUbkrrWT+s=;
	b=SRidsQaYcaOCwyigFaO2vhj8u36qpGHzcYo4SKOe9U/x809Xkf9kSjH4LguA1kM8bgyjL/
	3z0lHwa39TTIinJSnvSXwIFVAH2VuLvdMcIUGieulA6PYgE2x9tAVmYhteW4Vu5pyrCRDN
	ORy5vpvQHoThlYhBP/QmuKj8Oj1SVKM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OBI9KBjL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772666932; a=rsa-sha256;
	cv=none;
	b=baRT4z7+G8+FoM9B9f0mxDqUMMvK9/AWECdeokG17ljr4TE0+KAhF1fnC810CzhBehexiI
	qyJpAC/DSPO+POX7I+yTrUbUdWwf7IDJ0m0VmBS102VM7/huhjSajoaYYj/RAXyITfZxmD
	uiRB+Y0mNNFGrZoaO9m1aFEDag1tbjM=
Message-ID: <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772666929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DAFPQJJJhNNoX80Afk7miOJW6kwTQgtVOuUbkrrWT+s=;
	b=OBI9KBjLrmi5VYZfc3gzIGcvtNnNZJlbIuq6ALvB8cxIR4AuzraUE8t+prekSZFZGMLARc
	P9oelZQAMs/gueKwMI/QQRS+n2VIZSlpnrb6/17T9L8+he0kY3pFG+AiGqTZ/+uJIzbKl9
	NiGBOgYBeSgFmkd/BpdGhDX4+pdlVW8=
Date: Thu, 5 Mar 2026 02:28:39 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Content-Language: en-GB
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Kiryl Shutsemau <kas@kernel.org>, matthew.brost@intel.com,
 npache@redhat.com, david@kernel.org
Cc: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
 <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32730C000A
X-Stat-Signature: qba8n6gcz65rnms38yhanpkx6hin6ap3
X-Rspam-User: 
X-HE-Tag: 1772666931-176779
X-HE-Meta: U2FsdGVkX1+01w0DB89rD3AWy+B9f7oU4aJqIUN4Eljw3XKIMDon9xlWovJ6fMTpnyBAZP3vanOvXPpR05PCHLH6qtdulFjAKPuFhl5NvBHwupeAzn8Noy0l6Vc52lHpD197kkkpHyeg/I6trCqMGxgsSYUdsj9gTGOTJNvFTSHqOyVj4DC1VhTMpYBxjC0YCxjwwRnOp881gTAI6qF0bdzCv2Y90ft8nw1+bMMeGeGf2oTbnkYWfqMmsZqwDyrt4zLpzpkeRXnA84cBK0sLyIxsP2ctwaZYc1CcUKKWdGxiceY2ONk8lUyM6yN7XE90ZGgRpr4vNIiBjobUdbfxZeI9/R55gdGwIUkVrXHuEgZZgmeQ6X99R3m/Bxgv9STMBlWEfMu4xdapPxQeJDV4F77uCLydDo9RGY+hP1tWw0xJuqypFpm+XqykosVgpc8vQXEX6EETwV4GL/MkzayR1vYOhO8turGWtdZtP8gV5Rxd1PehwTZoulLtg1hJsBReqriMZJNkcwbIfAlw0MTv13c24O38dKzW7mrw0rEJAXJ/8JEqlfmXgQGpLbl4i2hUC6mDoyX1OxDOeLlM1e8fFsuGnF7vS+xa3lodblqNhoxTL4dqNnEUNlP5AjzqN+hBriEUlCgXRxlOb3O08xAIlnDMZAW85gdv67BffdXuhwwvlmzrcmbWjh0YYpcOo3suA6hsaE3Bla3PVm9FkV6CDInNJdBkBYBLKbrVJibR7SGHL8Xe5qDleX+6jGp5gIotCLifSviaN6XxSUwX6BF0St5ivjXvJkqn22QGXmAku7Vabffy3A/zn/aI8wdnh12INvTtPcTveEA1wqjVrcNBC2+KPxEl/u8GjIzG7D8SgaEyflwg6GpOwvEApZcgWZIPzdbueN5Kyp4DDQkjWyqU9KZ6S17VCI1ydstA3bqTz4iYE2r/XtqVDazxh/LIUaUR1LBsGD9mE+bXk0RtlE6
 X006PlYP
 eRRzJEBbRVGDtG4UzX7LbkF/UaOzkBvGUyu2KWaB6se5etW43UZDrY9kBO4ZPF495SKkJ1cUtHhcglakefVVUfuN4u9l44+NuB6sQGqf0QfPvIXeLkwHa71q3gcBmmzQWYDMGCIACVmF3QCXMYYf1xvNchtaW2qzM30g2IToAF5n/kgDSBk5a/FKAj96kNkBCpjgVlvH21g+hsNArpZSnCrcRI5Ge6KoL4gy8b4SaCbpPtLEAwIDEsPtGHRLKq7qs/aKV4eNqS3Bb4RscccbtPYNsBrQTJ37KNu2NXn7IoYTvhFsxatJaYPOiwM9e2SGX5gl+OKtfmINM60ng+Chj23VxirHEkKkwTOyfxeFTWU0mbG9joSLhpbOpUmbUM1TXpnxO28cDeVe8odNaMzHyvMupDTbI2WScqRs/hZ9mvmJVantIlgGnxfjnO+7Bcxq9E3ZS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/03/2026 22:09, Balbir Singh wrote:
> On 3/5/26 08:54, Zi Yan wrote:
>> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
>>
>>> On 3/5/26 02:17, Zi Yan wrote:
>>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>>
>>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>>
>>>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>>>> folio_get() before calling folio_split_unmapped().  On success, the
>>>>> split consumes this reference: __folio_freeze_and_split_unmapped()
>>>>> expects the +1 in its folio_ref_freeze() check, and distributes it
>>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>>>>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>>>>
>>>>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>>>>> -EAGAIN), the function returns without calling folio_put().  The extra
>>>>> reference is never released.
>>>>>
>>>>> Add the missing folio_put() on the error path.
>>>>>
>>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
>>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>> ---
>>>>>  mm/migrate_device.c | 4 +++-
>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>>> --- a/mm/migrate_device.c
>>>>> +++ b/mm/migrate_device.c
>>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>>>  	folio_get(folio);
>>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>>  	ret = folio_split_unmapped(folio, 0);
>>>>> -	if (ret)
>>>>> +	if (ret) {
>>>>> +		folio_put(folio);
>>>>>  		return ret;
>>>>> +	}
>>>>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>>>>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>>>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>>> -- 
>>>>> 2.47.3
>>>>
>>>> Add Balbir, who wrote the code, to comment on this.
>>>>
>>>
>>> Thanks Zi!
>>>
>>> Just wondering if there is a reproducer for the issue and how the fix was tested?
>>> I expect migrate_vma_finalize() to be called for folios, even when split failed and
>>> drop the lock.
>>
>> Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
>> If so, how does it distinguish between split folios and failed-to-split folios?
>> By comparing source and destination folio orders?
>>
> 
> We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.  We do a folio_put
> on the src in finalize, if it is split then on all the split folios as well.
> 
>> What we see from migrate_vma_split_unmapped_folio() is that
>> it adds a refcount for all input folios, but only drops a refcount
>> for the split folio. Isn’t it cause failed-to-split folios to have
>> additional refcount?
>>

Hello!

Thanks for reviewing everyone. So its very difficult to create a reproducer I think
the extra reference would need to appear after migrate_device_unmap() but before
folio_split_unmapped() in migrate_vma_pages()? That's hard to trigger reliably from
userspace.

The fix came about when Nico indicated there might be an issue if split_huge_pmd_address
fails in my patch [1].

Below is my understanding of how refcounting is working over here step by step. I
might very well be wrong on this, and the refcounting is a bit all over the place
and I might miss a reference change somewhere so would really appreciate if someone
can confirm this!


1. migrate_vma_collect_huge_pmd():
  a) folio_get(folio) -> +1 (collect reference)
2. migrate_device_unmap():
  a) folio_isolate_lru() -> +1 (isolation reference)
  b) folio_put() -> -1 (drops the collect reference)


Without this patch fix:

3. migrate_vma_split_unmapped_folio():
  a) folio_get(folio) -> +1 (split reference)
  b) folio_split_unmapped() -> fails
  c) Returns error — without folio_put() which is the fix
4. Caller in migrate_vma_pages(): clears MIGRATE_PFN_MIGRATE | MIGRATE_PFN_COMPOUND
5. __migrate_device_finalize(): sees !(src_pfns[i] & MIGRATE_PFN_MIGRATE), restores the folio:
  a) remove_migration_ptes(src, src) — re-establishes user PTEs
  b) folio_unlock(src)
  c) folio_put(src) -> -1 (drops the isolation reference)

The split reference in 3.a is never released and the folio has a permanently elevated refcount.
Unless I missed a folio_put somewhere for the refcount increase in folio_isolate_lru() (2.b)?

Please let me know if this makes sense!

[1] https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/

> 
> Thanks! Yes, the patch makes sense
> 
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> 
> Balbir


