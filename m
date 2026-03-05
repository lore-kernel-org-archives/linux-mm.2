Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3DDEEF309
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 06:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09BBF6B0088; Thu,  5 Mar 2026 01:09:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0494A6B0089; Thu,  5 Mar 2026 01:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D0D6B008A; Thu,  5 Mar 2026 01:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D24F26B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:09:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AE491407F6
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:09:52 +0000 (UTC)
X-FDA: 84510983424.23.2F35959
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A02B24000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:09:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SkPu1FTQ;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772690989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6BMsx2GZfy+hVt/YEKaAJkyxWGIjBdZYaBNk1wKCu8=;
	b=EKKnEvpAm8v0cV0av6Ein/XWCGN+9hu4/QbgqytjKaoyXld6w1MZWho/xvSm4ZuE3FvP3Q
	hYCpaOm9lcvfeOL+tTTyoRmtReyLZpRFQXVschgnwVsQyZVWQExBUBSvZMmC9a9ZJpa3xZ
	hzcg5syz+3WEyLR+wuyzsizxzrLYDPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772690989; a=rsa-sha256;
	cv=none;
	b=ALCa97DH+TFPJiBytTnUyBbketAFhpUgTWowZQVqCPysPcipnOdpAG1ghgQbwoUVz0RU8Z
	Im2IGjnIfkd2z3broPE4J1QWkktOgHdLockLUEExZOM3oDSUIoj7gTgzehY+h7aebkWQm1
	vLJQVDwHflSWFvH9ENdBB1u3cC/vWbI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SkPu1FTQ;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772690988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s6BMsx2GZfy+hVt/YEKaAJkyxWGIjBdZYaBNk1wKCu8=;
	b=SkPu1FTQ/J9SSIAALFJ9X1lR5kQvdQcjvmfB9tSXzKOtDQ9fXUxvTIp/2uOcq6cgxctHkz
	7YUmtAFY3xN2DYsqzl9nBSw5SKg/l4VgOLJii5WNBEnDlVcbEyG2nWr4HxPM9EPN2XrHaB
	njI91O36n5SqRG9LercplzSamYEs944=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-nSXeJDpGNn6-lJNxpU293A-1; Thu, 05 Mar 2026 01:09:45 -0500
X-MC-Unique: nSXeJDpGNn6-lJNxpU293A-1
X-Mimecast-MFC-AGG-ID: nSXeJDpGNn6-lJNxpU293A_1772690984
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a13072689fso181867e87.0
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 22:09:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772690984; x=1773295784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s6BMsx2GZfy+hVt/YEKaAJkyxWGIjBdZYaBNk1wKCu8=;
        b=AWugtFR43n1XYHMX8m7iLJtSJWHiFiZpP7pZsSGXj9VZrEm0Z8d1D4dJUT+CGgDzYS
         dBH7XbsmQqodLkp0vQ22+luF8ugLp/X/7bXeb23GU4YMSfhggoKlUYvad37b1Bn6qILu
         D3gP/BZIZ+ffuLVDDgOXND95xbjau58rrBRv/sK+u6SFahQEKo6tegYkTdbDRqhYcvMV
         G0KPPHxBqtoiRcVBPAsvfpJqg5VeojGP+HJTXTiW6Qfs6krN298InNlW40SIhs4p3xK/
         Vvg9q8uXVT3Fwef3Jvh5OE0bF0tAYg+IDmtYSINDlJEmocwr403cRhnHWJV3ffGFdjS1
         EamQ==
X-Forwarded-Encrypted: i=1; AJvYcCURAesGCYy5sbm5YbIA7jvY8XNaen6+Gyt0hUUo0jld5C3Eohlqm4ocScP+QJzYehXpflZbo2S6Yg==@kvack.org
X-Gm-Message-State: AOJu0Ywfnkxg6TS4ZxUw6gY6atTQwGFuQMvw5KjEl6oTO8KhcZNWnNlD
	9FLIz5meOa1EHEOG0xM3un06+e6mgmU5WirO/je5fBRGsRVbM+PQItDdACgmfELLExgeByOcz8J
	fpr9+v8etn56S/M4+E1kYk3BZtFg2MCPEwdOrB2WGLISjn6RouEQ=
X-Gm-Gg: ATEYQzxAck5sT7ERylqLf/3Q1Hu3eNZ8FBXR5kaie1UxDfxbe3d+UGGgb16rhes4eQW
	Jm2QyXmbgqwwl8f7WRGjXOPvWu814QlbXQhMdLdyLuHnESOt2IgNLxnM/KtUo9A5ojPMo9WREkU
	pbdib8Gh7mu428cy57VT26Nk1ARVdZQlxWyHsExjkTphxTL+R0fSy/H2hBTJQgMvSx4goWriSbH
	nUjOIrJ7F8EjvfcVZ08Eg6JlnvHfZ0xd1qPysRuTwuhGJb8S739PUauLQRFDxsxhpCkw6rP7DBM
	/EuqlQCaZ5R99jr1af36jbe9NFLdYjNDN+NFDR4s8/rJgpW4jtUHalea6XZHsFQya6PMiTskN79
	Xds5V29LkKb+c9AuOjWTiyUZcId3m9eL3VDiKhGziBN1FIfk=
X-Received: by 2002:a05:6512:2286:b0:59f:7318:c5e8 with SMTP id 2adb3069b0e04-5a12c2b21b4mr395508e87.39.1772690983873;
        Wed, 04 Mar 2026 22:09:43 -0800 (PST)
X-Received: by 2002:a05:6512:2286:b0:59f:7318:c5e8 with SMTP id 2adb3069b0e04-5a12c2b21b4mr395493e87.39.1772690983425;
        Wed, 04 Mar 2026 22:09:43 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a1235822d0sm1762719e87.23.2026.03.04.22.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 22:09:42 -0800 (PST)
Message-ID: <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
Date: Thu, 5 Mar 2026 08:09:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
To: Usama Arif <usama.arif@linux.dev>, Balbir Singh <balbirs@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 matthew.brost@intel.com, npache@redhat.com, david@kernel.org
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
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pxCqFqdOHzXx_QPAZPMRPko1F-dfkmB_9654kBJIK4s_1772690984
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: goxkkpibz3qq3cui6mtmp41m33zny9ru
X-Rspamd-Queue-Id: A02B24000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772690989-884902
X-HE-Meta: U2FsdGVkX19YJjFrIirY/9NwxbWS1rMq5jnbTL4GSriMxN6rVSIU+yHaFSQEUPZ2A4TUWnzb1GfSCQWTmxif5o9FSSk9ISCU73X2epy3D/EWNy/jXCS2zfC68nla1gjziGT6rFYtwT6w24ikaI0ZO1zuFsWGLm34QSyBTmUOmkrlE3FGIcFvkyek8EQ6OebsWub2XkTzcaAn0bCrumOVFISEauT8yr544+wne54FAdZ2rcnEUZrgGbZU+NiRryGGPYh7a231fRZXr8OKQAUisIa/kIL16tbaepCXirI+zOJWuDakptIjdEiWWMHs5T3cGb26F24/Qd8hee1OZGjpZJfxNDVd72p8DyL8K9x6rx0QK//jLA9VajN/LIfEa+wu1vrvUgSwXOVwiHCIFDq0mMucRkMgVeWzwFxfYYSsqlc6Vjc/4uk6j223//LNmBfIcXOm+7FOxMMKMg60y3nQK1KcNny3UEOuzqVRVwZJssX+LKhWDx11DIqgP77lKx4PgBrMXdVZiZC4Ex7Poi5SX+F81zJ31aPuJKx+BB9Glkfed1wMe7IrzKTI+kt2AGcnli8NOF5hkqSkXj3NYKh/8wueF27Gj2Nd331Q4GOFHXuTtdUx44cten8rG5ksefwWd6GnFOHT7uFBwxQh2VQ3c/iDL0J625aAlZIGK5+nXxvgMAAYT9c3jbOMDt0kxGCcU76kLf/IIZRkjP+cDveXg2ziEnz1LUuaw+zfgoL6pWd9P8Ceyv9VP+eambneFkJw8ic7G+mNQ71kkNEY83X5a4rAO5Ww8mi/tlhgmWN22YOqjc3VewieKozV99WKn97gPtLqBaVK0ygxrXz6E6ScR4ZsiVOH203K/dUMSDW46ayODiFVG77ewc/g7mgHycSgEIn9DIkA8XCG1zUaJabqoGGvnnY1Q+4gTqpaPaEjYpZ6QLV7xBF2TfHz4L64WRgTSvYqth/dk7il/1LT+Gv
 WI3A/+rl
 4ZDarFrOKJ8AeN9SOlWpzAKEkVj9epcSiU10lDu5cI7WKz0CN4OiB3EjAPIcQ1cNDAnbA2m1S5ibC6UxokG6hBZWt1ayZce2ezgH4GOeaWutlRtm/Vj3TqPsNGuxsLP5DviaLpM9OkNFD1oOGCXXULeux6t/i8DK4yTjvmRQl1hhMFM4eOwNIdUn8UJOX9QzmeLVYsn2dz3SUSOPDXZ//B3kww6uvUPbbNHhjrECJo7EExvVNLozBsos9ktxlo6MuoHQQR9itHyUeChyZL5lxni1NOjM+rfoYYfUuNpL23+fIWt2oLv/fZD0CpIlTLimzTRwUi+iWGLtFS6iPd/5xygyysikoRaldiid2MG4qna+U3Vnoy6Emxhmvu3mPI/uqUZR8yMcnTrl2y2AYr7lUOOLaJLUYJrocBxSo0Y/QMPd1TXZp8TRLw2/dSHwflUcryBI5YKQjIScbThDAFnQ1n/PpoBgYXFbMuWnrwoa0I8nK4GEFvNbu6hvd70eeE2BDksMvHl7oyVtxLkyRdYLwQOrm0AmYz/KMTlMwdG0s6itGJNmsIhOaHtQuA5r1o4q2fW8Da6GxLWtgcnvFoOhgQdNT0+GPpCga6muv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On 3/5/26 01:28, Usama Arif wrote:

>
> On 04/03/2026 22:09, Balbir Singh wrote:
>> On 3/5/26 08:54, Zi Yan wrote:
>>> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
>>>
>>>> On 3/5/26 02:17, Zi Yan wrote:
>>>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>>>
>>>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>>>
>>>>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>>>>> folio_get() before calling folio_split_unmapped().  On success, the
>>>>>> split consumes this reference: __folio_freeze_and_split_unmapped()
>>>>>> expects the +1 in its folio_ref_freeze() check, and distributes it
>>>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>>>>>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>>>>>
>>>>>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>>>>>> -EAGAIN), the function returns without calling folio_put().  The extra
>>>>>> reference is never released.
>>>>>>
>>>>>> Add the missing folio_put() on the error path.
>>>>>>
>>>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
>>>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>>> ---
>>>>>>  mm/migrate_device.c | 4 +++-
>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>>>> --- a/mm/migrate_device.c
>>>>>> +++ b/mm/migrate_device.c
>>>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>>>>  	folio_get(folio);
>>>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>>>  	ret = folio_split_unmapped(folio, 0);
>>>>>> -	if (ret)
>>>>>> +	if (ret) {
>>>>>> +		folio_put(folio);
>>>>>>  		return ret;
>>>>>> +	}
>>>>>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>>>>>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>>>>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>>>> -- 
>>>>>> 2.47.3
>>>>> Add Balbir, who wrote the code, to comment on this.
>>>>>
>>>> Thanks Zi!
>>>>
>>>> Just wondering if there is a reproducer for the issue and how the fix was tested?
>>>> I expect migrate_vma_finalize() to be called for folios, even when split failed and
>>>> drop the lock.
>>> Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
>>> If so, how does it distinguish between split folios and failed-to-split folios?
>>> By comparing source and destination folio orders?
>>>
>> We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.  We do a folio_put
>> on the src in finalize, if it is split then on all the split folios as well.
>>
>>> What we see from migrate_vma_split_unmapped_folio() is that
>>> it adds a refcount for all input folios, but only drops a refcount
>>> for the split folio. Isn’t it cause failed-to-split folios to have
>>> additional refcount?
>>>
> Hello!
>
> Thanks for reviewing everyone. So its very difficult to create a reproducer I think
> the extra reference would need to appear after migrate_device_unmap() but before
> folio_split_unmapped() in migrate_vma_pages()? That's hard to trigger reliably from
> userspace.
>
> The fix came about when Nico indicated there might be an issue if split_huge_pmd_address
> fails in my patch [1].
>
> Below is my understanding of how refcounting is working over here step by step. I
> might very well be wrong on this, and the refcounting is a bit all over the place
> and I might miss a reference change somewhere so would really appreciate if someone
> can confirm this!
>
>
> 1. migrate_vma_collect_huge_pmd():
>   a) folio_get(folio) -> +1 (collect reference)
> 2. migrate_device_unmap():
>   a) folio_isolate_lru() -> +1 (isolation reference)
>   b) folio_put() -> -1 (drops the collect reference)
>
>
> Without this patch fix:
>
> 3. migrate_vma_split_unmapped_folio():
>   a) folio_get(folio) -> +1 (split reference)
>   b) folio_split_unmapped() -> fails
>   c) Returns error — without folio_put() which is the fix
> 4. Caller in migrate_vma_pages(): clears MIGRATE_PFN_MIGRATE | MIGRATE_PFN_COMPOUND
> 5. __migrate_device_finalize(): sees !(src_pfns[i] & MIGRATE_PFN_MIGRATE), restores the folio:
>   a) remove_migration_ptes(src, src) — re-establishes user PTEs
>   b) folio_unlock(src)
>   c) folio_put(src) -> -1 (drops the isolation reference)
>
> The split reference in 3.a is never released and the folio has a permanently elevated refcount.
> Unless I missed a folio_put somewhere for the refcount increase in folio_isolate_lru() (2.b)?
>
> Please let me know if this makes sense!
>
> [1] https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>
>> Thanks! Yes, the patch makes sense
>>
>> Acked-by: Balbir Singh <balbirs@nvidia.com>
>>
>> Balbir

I remember stumbling on this while ago also. The folio_get() in migrate_vma_split_unmapped_folio()
is balanced with put_page() in __split_huge_pmd_locked() (freeze = true), can't fail for device pages.
Folios at this point are unmapped but have 1 refcount from "collecting". 
After folio_split_unmapped() the refcount(s) is still 1.

So it seems the code is good as is? A comment though would be good for the extra folio_get..

Thanks,
--Mika


