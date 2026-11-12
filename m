Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D343606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IyGDU41B
Received: by kanga.kvack.org (Postfix)
	id 795886B05B3; Thu, 12 Nov 2026 02:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7467D6B05B4; Thu, 12 Nov 2026 02:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634EC6B05B5; Thu, 12 Nov 2026 02:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 362CB6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:45:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAEE51204B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:45:21 +0000 (UTC)
X-FDA: 85425681642.11.81989A4
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf12.hostedemail.com (Postfix) with ESMTP id CCDCC40003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:45:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IyGDU41B;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794469519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XonEwXskiTjcZGriLRKPr8S1lDz0l/ASP2xVg5gbydQ=;
	b=ayGRQ4jxRGnO5NFvje/RNza3Mfe7AAINMTcIv098Oxnn31zEl7a4xJx6nl1PJWh67Ld79d
	o64LMrFVGDE2X97XXm9gIzKr13DZwCfOz61QLa+zMXgcAO6/0m92GWMFxyyDr2+NcLhRPF
	SswKK/dzHaUev/RhJ46GwDdai/hE+dY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794469519;
	b=JX0Ii+jJ0QMByGuR8ZP4Ol9HpNJnGxFgrwgMr00ybaF5dGeUA1ECq22FiZuRXybHFFgqo8
	hgtBj+UDwZULqWut0SzSKJreN3cd32typBid+wJPJ6pLVvMfse+s9OCmhpcrhdk59LcAPB
	Au0S3zDvMLnpWVeSjOh2tzAs2Biu1II=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IyGDU41B;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f9.google.com with SMTP id d9443c01a7336-2edeb82a918so1256205ad.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794469518; x=1795074318; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XonEwXskiTjcZGriLRKPr8S1lDz0l/ASP2xVg5gbydQ=;
        b=IyGDU41BNkZGymaP/A+diV29nbSnilNw0NLM2V53zVo7BgBxr3ycwZM7ATh5Wbey0G
         jkdAyZd6WO2k8PBFXuEiGWq9iy1NGvsjw0w1Bnq5Q8vSiyDCR5yeSE5X2KeE7SKkmEWu
         jAd383Rc5JFbAI1Mgme4XWFtaVAL5vRO6M2AeGJEGC0Ixc4B0/2OsuIBnJtJ3L8nZh8+
         I7PVxsFvdurpHckG8CgkM/WoQWHY28zqTZpgxZjnreoqlEY0cPdOZiydFhsA8Zc3geM9
         TlW+sXdmQ/iO2eEyN4jLKXTBSyIHacdrU9taqtdP8JSjTMoYE4v90iOWSXm8yc4KsWy/
         ii4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794469518; x=1795074318;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XonEwXskiTjcZGriLRKPr8S1lDz0l/ASP2xVg5gbydQ=;
        b=i8ppAXeEUfW3E9GyAwkJMCVPmOH0M0T3Wx0yyMqeTvuoVXWXhwGqt7WXy5DYj+yinm
         YYXYez0ssVBwnUl307AZOf6kNFyYbhelanPhZ+zZaQohITdJ4kFI6fRWFaEllvldfBKl
         +Tw91+rvo+mq8gzetSBhoGtXy66+cwLJ0AAB8rMWpP3b9oIR5nU8OsROTxAx51Fb8gOw
         Y8XjXHSek4dRivyGkGULYD7N0iUgm0WBPFcfy+9+XS26+ql+xGfeWqd6mVzT5mfoiaM3
         ZdT4r9uZwF2aawA+cxppx4PgO+lkLJK8BtLAVC+ngcOnjZIKg2fx9SFrHxkWMHUu6tSV
         ndHA==
X-Forwarded-Encrypted: i=1; AL+hErETP1pwx6zI5kJwncQseXuaNYZEbqLpYOIkqaqLFFuwyC4HYUzgZdQ98r7H6m0Gt+anWS9R7MpI+A==@kvack.org
X-Gm-Message-State: APuU4Z8OiRqvmI5aEwS8XuTW5R3hLETSbSFhoDZvI0wTHvI2ntiGXU6m
	0PbxPstaQo3X6nlAQGwdpAxtbBjfLceaG10trLoTjWuBPsbro0mJZSYb
X-Gm-Gg: AYBFou2ER2wMTfbvb4Yev4z+b3s0cZAe72im6dFOA0Ymsp4Dc5gzKN4LMSCqo55MtJy
	vtR4uy5AmmrX9kN3xEcCX0gdPTNd+BlVcrVw4RL3I7hI9LH4Kf3TCLKOnsNVGPIEsd+o8Te49Yb
	p47jq0tLQpGRDED442Nt8U8jk3aMMji/DGvwU0adqRxxkRyI4hx6FLX84VVGTtelryasFJtm6Za
	H8F3ZkITLI+8MoOMt1cu+ntx14oY34JyQLZ/VhrAzqRnPXtEbmSc/4pvNFR6b3A1vZbCH+ynytg
	0G/UH1aSL60xUBrQfTP4l9UV3CMXodcQyP34dyIG/unC6jCViGao4Y3HD/g5qund1r6tA9SMBXe
	2VKpvy3Uy63stiOFrW5yK6cILcN9JpjbPFOw8VYtCs9v866Cq5Ea2Qm/sTggnWX4iyWnSzRnWNi
	awapxzMl0Hub303TATm9N/jOFhpUj3pTMvbz3EmogXx9xIs0mDsGWmkfCgjh7KTjEnS83LNZPtY
	7PUs+NW7dNIL3UGnQO7ijCJUezmcJA8oiVA65zi8xPZrBVOuydv7EMPgwfm/GX6lVn2LI86gdIx
	wI5DQ8uX0Cws9SEm0hZ2iq1wcEojCQYnlkuy
X-Received: by 2002:a17:902:fc4b:b0:2ed:dddf:8489 with SMTP id d9443c01a7336-2edf166fbbamr12780695ad.12.1794469518391;
        Wed, 11 Nov 2026 23:45:18 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm30454285ad.56.2026.11.11.23.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 23:45:17 -0800 (PST)
Message-ID: <eef4c5ee-2487-4668-bf24-742af6d71484@gmail.com>
Date: Thu, 12 Nov 2026 15:45:09 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: improve mlock tracking for PTE-mapped
 large folios
To: Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261110123218.1579490-1-chenwandun1@gmail.com>
 <5f9c449e-43b3-4732-9c14-8199418cace0@kernel.org>
 <avS7FfzvjieHufUE@thinkstation>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <avS7FfzvjieHufUE@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c16p3mu3njudm1ctep4kwpcrg1rnhz5f
X-Rspamd-Queue-Id: CCDCC40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794469519-542776
X-HE-Meta: U2FsdGVkX1/SEPf0oqejawwQIRjPLc7yBY8mpqClG1whl4zeEqKx3wnD1rZUkxSSHCpdfH5ix/B8VkmnQt2uphCuHrYe87tUP5Twrfg607cBdcwbJjqEinj4u53QKoNaXvIFsoARtiXSCmgnfWLTRSjwSTaQkWSHEMcC6kpkqEE9W/ShjjUnwWK8pZTisHoqn/Mq2zPHcQfIrRijyrR9AMtZfEkpPaaqiJYhVJ1nVUahnoeqWpGYzxKWeyw4zXDeDgnD8vbJvTY/vjowJoYJWw1E5pNhcLnnmUmciFBSM3iqvw0MQfilcOgQjGcYfu+3mH09qTIgHP9c8utEdvU0oOLuRNboPGy5zWb+pW//PsjuObxla77UV4MLTmGbnO4qymtfWeFckZd3NiLOXx/Fh3m9aY+43RI66P4G4bJ63nSPWahGKivUhzdGwx5U0Ovr7WYXbLRGZmfF1G9ocdcpcfbBo3eJkXgPwyvilJAXZrFANocvlbmenrU/flxyJ7JW0y78FG7057ntcU5CxbASkKh8D927JrWts/bpnehyPxSaPNGAgedFJepa2VkwCnO90htEqSeXx0FMyxUF3xGUYD0fWLTv7kTQsEWBIiZkHeo3bidslL9dZovjsvFf1LrFcGjB0fx4FcDRAID99btTv5wUxS1ndSjnEEfG3ThPP6JdQHJyYiJorDhf3vO7ErxJ/qZejlIHybYBFOpg41wdVdfeVkyKZKGzYsWkyDa3DpiQ4Om7UG2tOjRZSmk2YJzuqMIGxIpmj5GYaPwNr4pC9fp06N9A4HK5WFA9Kt+W1FasMlKcMCzbx7IFnujkAD8l+1vuUYiTqnAwP076GWojQSk0eXlmV3NcpW2HzZmR+jr6vqMpt5JWVDLpu523qgoFNB6dKlfpxD7G19cxZk7Bxa7UVDPvqlaWZVEWKZQyANxRFP+53mN3QHwGhFsAzpFtgdNaezcKgJbOwzVM/dZ
 dQJ4u79I
 HYpHgakfi1M8VUDmr5PQb0Ql1I83CVOUHzWHio5vg8CXKOBinOhThLn0hGzIuu0fZ2kfVDAdvJmOwa2QQqGp73XysNOIcqOdBPPTtxBOPBkjlhZ8QB8AM15mMaxgWC63YIrc4W6hwofn6SF405nxfErfhUW7MBgb2CfKgo6H61PVOQUAiaE+SaNHTmGwhi3erSPyuVV5WR1WU/ZG5bkm/xaFIRtWW6kTzJThF3tIke61tt1Ha/6Hk3bfPQ9X3MkPCUZ3GJmoeizGFCrBmyKsroOawVgoTaovCKI2+eqnm6Cu30D2QOEQ0x/5LJiefnq1ml8DPytwvqjsg0P+vOvMyd2c6Q/yj63opLxi79TIXpQfZzfJWwRcCsyMY9hLp6LYiQ0rTBjDeNThx9rZb9pWvinya6uGpNEoQCiBB0mGyyX+0y4lp46oA3yPaBvKXEfZvYd8QNp8/3GnQBNCsAa7alSmDckU7Y1d5oQmUKRO19hat8ePiGerMhi3rpoyLvK2VUh8d/Kru8s355M2odmWT15udl5+9x5vWtTKwovdVCfXdl0/+Q2AywSBvPR7EJemf46fGKDlR9Qvc4fTkcI1P/2fW2xSO/WFvuCwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 03:01, Kiryl Shutsemau wrote:
> On Wed, Nov 11, 2026 at 09:00:10AM +0100, David Hildenbrand (Arm) wrote:
>> On 11/10/26 13:32, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> Commit ab521b4142aa ("mm/rmap: improve mlock tracking for large folios")
>>> mlocks a large folio when all its pages are added in one rmap operation.
>>> However, when a PTE-mapped large folio is migrated, remove_migration_pte()
>>> restores PTEs individually, passing nr_pages = 1 to the rmap helpers. As a
>>> result, PG_mlocked is not set on the destination folio.
>>>
>>> Reclaim can restore mlock in try_to_unmap(), but Mlocked in /proc/meminfo
>>> remains undercounted until that scan occurs.
>>>
>>> Restore mlock once the full mapping has been restored in a locked VMA
>>> under one page table lock, rather than waiting for try_to_unmap() to
>>> restore the mlock state.
>>>
>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>> ---
>>>  mm/migrate.c | 10 +++++++++-
>>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 94033c222e04..140e291d4587 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
>>>  {
>>>  	struct rmap_walk_arg *rmap_walk_arg = arg;
>>>  	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
>>> +	unsigned long nr_ptes = 0;
>>>  
>>>  	while (page_vma_mapped_walk(&pvmw)) {
>>>  		rmap_t rmap_flags = RMAP_NONE;
>>> @@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
>>>  			else
>>>  				folio_add_file_rmap_pte(folio, new, vma);
>>>  			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
>>> +
>>> +			nr_ptes++;
>>>  		}
>>> -		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
>>> +		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
>>> +			if (folio_test_large(folio) &&
>>> +			    nr_ptes == folio_nr_pages(folio) &&
>>> +			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
>>> +				mlock_vma_folio(folio, vma);
>>>  			mlock_drain_local();
>>> +		}
>>>  
>>>  		trace_remove_migration_pte(pvmw.address, pte_val(pte),
>>>  					   compound_order(new));
>>
>> I guess pte batching would be one way of handling it, but that requires more churn.
>>
>> The spirit is similar as in try_to_unmap_one(), where we count the number of
>> ptes in one VMA. For consistency, I would call it "ptes".
>>
>> @Kiryl, can you take a look?
> 
> Looks right to me. Agreed on "ptes".
> 
> With that adjusted:
> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

I'll rename it to ptes and send a v3 with Reviewed-by tag.

On pte batching: following the swap_pte_batch()/do_swap_page()
precedent, restore could scan consecutive migration entries with
matching flags and do one set_ptes() plus one folio_add_*_rmap_ptes();
a full-folio batch would even set PG_mlocked for free via the rmap
helpers.

However, try_to_migrate_one() creates migration entries per-PTE with
per-PTE flags, so restore batches will often be truncated by flag
changes. For such folios the ptes counting in this patch remains the
only way to restore mlock (it survives batching with a one-line
change: ptes += nr). So I'd like to land this first and do the pte
batching as a separate follow-up series.

Thanks,
Wandun


> 
>>
>> BTW, why don't we care about that in try_to_migrate?
> 
> try_to_migrate_one() unmaps the folio whether the VMA is VM_LOCKED or
> not, so there is no mapping left to keep mlocked; removing the rmap
> munlocks the source.
> 
> The mlock is rebuilt on the destination in remove_migration_ptes(),
> which is the path this patch fixes.
> 


