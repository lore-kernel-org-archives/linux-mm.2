Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44298F30946
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 12:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C59F6B0088; Thu,  5 Mar 2026 07:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D6E6B008A; Thu,  5 Mar 2026 07:09:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A91F6B008C; Thu,  5 Mar 2026 07:09:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 692FD6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:09:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2105E1A097B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:09:50 +0000 (UTC)
X-FDA: 84511890540.30.2028451
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 928E0C0006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:09:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B1vAMKI+;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772712587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5cwVERvcN024z3zP/cYTnGpIfAQ3OHPG7ozXhuqUS4=;
	b=aganVQQLvLUnV+ars/5AMSB1gfF3VuRzfWMQM/rk1ERMrMA80T0GpfL7Bm3uA6n5iETbFE
	/OBhglkoDPRC/Hif1ZnSjg6LOaeF2WL369hqwEvSFdDz4e1o867JV76nBN58SPjzk5/Arl
	0MGu9zamH0xoZsqm3PuhExNVtu8i3Sc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B1vAMKI+;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772712587; a=rsa-sha256;
	cv=none;
	b=wIwQDadr9SuK4zgutFFmLD5HRjUTmcs46I93yOe1Z4dYHhjgEpdsEM8vrORz6Tj59UTFJp
	ideJELjxDVvCI7od8ycImdWjdoTOKSTKxQOUswRtsYzMDKSufRuJlW5srwYX9PYwfv1R/7
	fykxtGhA5kORZUwath1C+k6LUC50cI4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772712586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5cwVERvcN024z3zP/cYTnGpIfAQ3OHPG7ozXhuqUS4=;
	b=B1vAMKI+DsO+K46zql60owcqIsVLWGeb33BGUK9w4vf3wSZXEzdCgXWHuTrilwR4SYgs1A
	87bbRL+QS3Mkzk4vLd3simp45MGYp7Qyhh+HdQ4DsNdIVARfQqfSF4g1XHNHR0ftwpEoOQ
	b8UCcnfd48RDmw+dHOogIiZYqmV4Uw4=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-LAaKE_rvO2uFo1cesAg7KQ-1; Thu, 05 Mar 2026 07:09:43 -0500
X-MC-Unique: LAaKE_rvO2uFo1cesAg7KQ-1
X-Mimecast-MFC-AGG-ID: LAaKE_rvO2uFo1cesAg7KQ_1772712582
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-38a27d3b22cso23982691fa.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 04:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772712582; x=1773317382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T5cwVERvcN024z3zP/cYTnGpIfAQ3OHPG7ozXhuqUS4=;
        b=JL4d60S6m7gYVeqxn0GWkW84LaA1watXGDODrRiQ7nY8RdA74O3OFQ/CGwTF0tOnrF
         //vV1bc3pjKbGy0xJsfpdlZ9OGBsXis1RlvGgAHCOlJwRwFmzgkbf3LCLEz1TsjvBK5/
         drjvQlLkt/h/6XVbOWv1/tPF0lEywZHODV2kcNVgPbDjlmA8netFJ3HdTnPCbOxWslpd
         g0bQ37LfKjsY/5F346J8RjBUTe+PZ3yZY6ILa2Jd6duWA9pBTuuxevCyle3rp7bXrEmw
         OAo82+SMSewA5ikT6njqM7YOm14ZWfjUfN51nx9DBADIXZ/fie4u6Ji11IN/TsialIY4
         fpxg==
X-Forwarded-Encrypted: i=1; AJvYcCXoaxPFT4nqqtg/OMX5ktTq+UkJeMyBb7SWFt8lK2nPJIjS7zZDGYpZKHUYK6d5y2qEFQq9pzEhxw==@kvack.org
X-Gm-Message-State: AOJu0YwruW+Mjb0rxk+9FAei6AoywPs2OxvHv6Iu+teleTseIh5xf7c3
	q19B7rVrn213lyB77HZ0LEIJ3Re1XCS0aViodUlUcSkVpk5NL/CDgyqDXR+y69etXlxmN5EjUok
	j+ky9BOy7PdinBv5LBrE+Mb8/QaCZc3hcqhWaLlDrKRyFsrhyNWc=
X-Gm-Gg: ATEYQzyyaWQgjfEfd5nZKzekdEmHgNzSHulgqEvLB1ibJOhHRKMHNTa0N7gXNZmIfBX
	q8QW8oRl4yfIcFP/K9+vDBwRaz0RJ2MiccM9s+IjG6DTKmUw5Nro6Gf2OoAGpaPXQDmlZuDcpYX
	bU7spf1dXCNXcHLfkyL3XUPEn0UqdIZqEZWRuzbpSI0vb5UEZyshcBkwv3S7QhIdqT2+sV/iPYL
	WxZj72WbNcFIzQcO3cTk3XncSb7DvKk8MwnQrBrDVkrQRek46sz6q/7nPgJIyG7drQo5m8rGjwB
	7aiRtrto5hxX2ROvqe9CdwKRASeXCbm3sBerCB58m/2U9rxZbOWod+HWGt1EezLGigbjvNMPmJA
	fWY35M0HZAeAIvGEMq73/+hHKjWvUPqUAjA+taa6LP0uM/a8=
X-Received: by 2002:a05:6512:ac1:b0:5a1:187d:fefb with SMTP id 2adb3069b0e04-5a12c28895cmr852555e87.19.1772712581489;
        Thu, 05 Mar 2026 04:09:41 -0800 (PST)
X-Received: by 2002:a05:6512:ac1:b0:5a1:187d:fefb with SMTP id 2adb3069b0e04-5a12c28895cmr852525e87.19.1772712580678;
        Thu, 05 Mar 2026 04:09:40 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a12356ffdasm1945705e87.76.2026.03.05.04.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 04:09:40 -0800 (PST)
Message-ID: <80683d6d-ea38-4326-af5e-e4c173bb1930@redhat.com>
Date: Thu, 5 Mar 2026 14:09:39 +0200
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
 <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
 <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VTsb6RQcK-igGRWlWCKmA1zH4SnuYFhM2OxdEj5UvaI_1772712582
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 928E0C0006
X-Stat-Signature: iphx1jc81ki7ufmono7i4p8uyse7qxrm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772712587-900195
X-HE-Meta: U2FsdGVkX1/ABLnrZih7XqJ0nZOy7DjC0IydmRfHZn4HbNaxx+vo0Jot5UkXyyRna1rzE2WPeo0WzVuba9mQjgbaE9jnxC+lvRchHwFr5DP89bJLG2Xv73ymkB4u2CLuxa2hXxayFiTpyI9rJI4j+K/YaDy419B4o3SuPmmk5oiHCvsT/MjwqH7Zm9jcvWvVg2X/I4ASmtW4ETD7HMJ2Vii5WeMO631s2BnAzp/jlTH13id+QsELQTBfM7Obc20vccSv2ik1SqvFOGe/F4ym4mPDyG8vhk5ZTy1nEAGn/a5v2PZSudEsL755g5+ritOA8EOVmtMVTsEUpFWxAz3NnTHwt54JNqnNkHON/OIG5IPl8bJlTRosaNapBzT1JXgMlX+0zFH6bW2AEnrVou2cWBAgpP0ITCtFwnyd0Wl74Dv4sL63q0ZI2ESJ7sMkBiVVdcgfkD9p4Dx7P7l0Oea+/LjCRz7Qks1mPQUlL6yOxm5LG41xYGEIGg7aSxof1d2XxFaAW8gQIpJJTH1BdIGkjrkCtPXoqogaLWecjnjr4BuVZMhFocGr8GEcwHFmOZURAK/We6NSdX7rjK2rSFUHR2Fc18BcYHk4ZRohnAgdo3yN/bnt02Jx+QBsXqgubQfaiowwv4X7WkLnHmWrTzlwxYRDTl8Rp4nRB6+mo72ZNmwN6v+kkeaWYp68hpDuCUaGhI6a7cnioFAG5V5jV0eWsTMNqf6lavHH4awLtzuzqELFwgQPZ7oWFgDx6ycRIVdCxTa0UFbL3d+FEvf0uAuQ8zwIo/GBFqUEBMZSnEuF197Fi4QC5EAPjprVFIAMtlx2WNeyeP/pYiinD4a4WSyJwddVkKuE8hJFh4kBv0GB7XNCUCIEDKrsZXLLoyd2ofOKjAxo4Z0L1oqqnt7zs40TQiy0NOdqgsGjqDKnYvlA9uwTP4eUBSTS4iuTpQwGu9GTVx78ck5MazvvFEL1vrO
 lzA5oMuF
 0D06NGWivCrUSW3VuXfd3L9ZsJktGE7jkEVDn7K1YqbXJ47RFV7g9eHf0JjabxcOak/2AAeI2uchy3BbGVNmbVBHvpAWjkSwpWmZDPFsZmWjv+Hm682hMnVYyrGHCHjoUlpRG6eGfv81XllccNXbZXc0ZIlFjsxSQsuh0Tx4yIbXPuJWDnhSOPhkLtpd446a+Q8pkLF+Q5JD6jpMaJuzyZ4X0v0z42oDr9FPslRGpzB6KtKinEavOaeaB04hceFhb7xtdPrrinfsm2tJegdvDL/hYWN6ePeegH3AVnOgzjC251p8DF3FoFwBcwAP8gME7o+R2MrPJYY5aNfrVTnzjg6hgWVfUSV+Wy0J4kUDlvi3CFeZyueMg71Ty12gTPsLVakvTtSc0QTzseGlN/UwZVnE1jZNS4R/TpBvVYekpJz1KQ2ZHQBZFjzY/Tl55IlNcPkPOTtaE9dfrcUzdhVvSqHKYNra3SBThEeUj083jEbL7UWoBBJMVCld4PhaAjLLsO1mtWZDeQD4Rh3hgmlkqRq/powTn0IHZlXFsuvT68sBWRMv0OT3aXdJB9M86x0ifF4F+GRp41qY+S7Wnq5wwD6SwvFtmlSz4+xiPk5doKLRzSxABpOpDxmH1EiXx8kQgYQazwjT37jwzF72+aE8V2rnqwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 13:44, Usama Arif wrote:

>
> On 05/03/2026 06:09, Mika Penttilä wrote:
>> Hi!
>>
>> On 3/5/26 01:28, Usama Arif wrote:
>>
>>> On 04/03/2026 22:09, Balbir Singh wrote:
>>>> On 3/5/26 08:54, Zi Yan wrote:
>>>>> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
>>>>>
>>>>>> On 3/5/26 02:17, Zi Yan wrote:
>>>>>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>>>>>
>>>>>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>>>>>
>>>>>>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>>>>>>> folio_get() before calling folio_split_unmapped().  On success, the
>>>>>>>> split consumes this reference: __folio_freeze_and_split_unmapped()
>>>>>>>> expects the +1 in its folio_ref_freeze() check, and distributes it
>>>>>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>>>>>>>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>>>>>>>
>>>>>>>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>>>>>>>> -EAGAIN), the function returns without calling folio_put().  The extra
>>>>>>>> reference is never released.
>>>>>>>>
>>>>>>>> Add the missing folio_put() on the error path.
>>>>>>>>
>>>>>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
>>>>>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>>>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>>>>> ---
>>>>>>>>  mm/migrate_device.c | 4 +++-
>>>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>>>>>> --- a/mm/migrate_device.c
>>>>>>>> +++ b/mm/migrate_device.c
>>>>>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>>>>>>  	folio_get(folio);
>>>>>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>>>>>  	ret = folio_split_unmapped(folio, 0);
>>>>>>>> -	if (ret)
>>>>>>>> +	if (ret) {
>>>>>>>> +		folio_put(folio);
>>>>>>>>  		return ret;
>>>>>>>> +	}
>>>>>>>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>>>>>>>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>>>>>>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>>>>>> -- 
>>>>>>>> 2.47.3
>>>>>>> Add Balbir, who wrote the code, to comment on this.
>>>>>>>
>>>>>> Thanks Zi!
>>>>>>
>>>>>> Just wondering if there is a reproducer for the issue and how the fix was tested?
>>>>>> I expect migrate_vma_finalize() to be called for folios, even when split failed and
>>>>>> drop the lock.
>>>>> Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
>>>>> If so, how does it distinguish between split folios and failed-to-split folios?
>>>>> By comparing source and destination folio orders?
>>>>>
>>>> We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.  We do a folio_put
>>>> on the src in finalize, if it is split then on all the split folios as well.
>>>>
>>>>> What we see from migrate_vma_split_unmapped_folio() is that
>>>>> it adds a refcount for all input folios, but only drops a refcount
>>>>> for the split folio. Isn’t it cause failed-to-split folios to have
>>>>> additional refcount?
>>>>>
>>> Hello!
>>>
>>> Thanks for reviewing everyone. So its very difficult to create a reproducer I think
>>> the extra reference would need to appear after migrate_device_unmap() but before
>>> folio_split_unmapped() in migrate_vma_pages()? That's hard to trigger reliably from
>>> userspace.
>>>
>>> The fix came about when Nico indicated there might be an issue if split_huge_pmd_address
>>> fails in my patch [1].
>>>
>>> Below is my understanding of how refcounting is working over here step by step. I
>>> might very well be wrong on this, and the refcounting is a bit all over the place
>>> and I might miss a reference change somewhere so would really appreciate if someone
>>> can confirm this!
>>>
>>>
>>> 1. migrate_vma_collect_huge_pmd():
>>>   a) folio_get(folio) -> +1 (collect reference)
>>> 2. migrate_device_unmap():
>>>   a) folio_isolate_lru() -> +1 (isolation reference)
>>>   b) folio_put() -> -1 (drops the collect reference)
>>>
>>>
>>> Without this patch fix:
>>>
>>> 3. migrate_vma_split_unmapped_folio():
>>>   a) folio_get(folio) -> +1 (split reference)
>>>   b) folio_split_unmapped() -> fails
>>>   c) Returns error — without folio_put() which is the fix
>>> 4. Caller in migrate_vma_pages(): clears MIGRATE_PFN_MIGRATE | MIGRATE_PFN_COMPOUND
>>> 5. __migrate_device_finalize(): sees !(src_pfns[i] & MIGRATE_PFN_MIGRATE), restores the folio:
>>>   a) remove_migration_ptes(src, src) — re-establishes user PTEs
>>>   b) folio_unlock(src)
>>>   c) folio_put(src) -> -1 (drops the isolation reference)
>>>
>>> The split reference in 3.a is never released and the folio has a permanently elevated refcount.
>>> Unless I missed a folio_put somewhere for the refcount increase in folio_isolate_lru() (2.b)?
>>>
>>> Please let me know if this makes sense!
>>>
>>> [1] https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>
>>>> Thanks! Yes, the patch makes sense
>>>>
>>>> Acked-by: Balbir Singh <balbirs@nvidia.com>
>>>>
>>>> Balbir
>> I remember stumbling on this while ago also. The folio_get() in migrate_vma_split_unmapped_folio()
>> is balanced with put_page() in __split_huge_pmd_locked() (freeze = true), can't fail for device pages.
>> Folios at this point are unmapped but have 1 refcount from "collecting". 
>> After folio_split_unmapped() the refcount(s) is still 1.
>>
>> So it seems the code is good as is? A comment though would be good for the extra folio_get..
>>
> hmm I dont think the put_page() in __split_huge_pmd_locked() is there to balance the folio_get() in
> migrate_vma_split_unmapped_folio(). There are other points where split_huge_pmd_locked() is called
> with freeze = true [1] and they don't get a reference before calling split_huge_pmd.
>
> I think the folio_put() in __split_huge_pmd_locked() freeze = true case is there as migration
> entries are being installed?
>
> [1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/rmap.c#L2334 
>
>
Yes normally you want to drop the reference when installing migration entries but in this context
you have already done the collecting for the THP folio and you want to balance with the folio_get()
the put_page() to keep the refs unchanged. Is that right Balbir?

--Mika


