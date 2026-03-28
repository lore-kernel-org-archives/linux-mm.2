Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664DB10F3DC8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 02:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F566B008C; Fri, 27 Mar 2026 22:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FF36B0095; Fri, 27 Mar 2026 22:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926626B0096; Fri, 27 Mar 2026 22:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 817506B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:29:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 188C08F355
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:29:38 +0000 (UTC)
X-FDA: 84593890836.19.330D402
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf13.hostedemail.com (Postfix) with ESMTP id 27CFA20007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:29:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="BXJ/uXLw";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774664976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R12a3AlVnNxuV2juWEwgnbD/uqtxdGfbzuo7rBEpZ8o=;
	b=wR3d3fhKiyqo4HrSgOgMCQNM0rUBhxDzhubqKr6Pre6fy8Dh/txpBni2sXtP/HhLLE5QbT
	wC6eFPzYpxhVYw3xYjShdpGeup7fmWt77pG+hf6n2KtSW61XS8ImwU4PMaEy2WXzvuxhyg
	KNjKHylL6OJavcQvpNRbqMdOjnLzv/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774664976; a=rsa-sha256;
	cv=none;
	b=sOE2r5JNRmkzdcfWkKK9CHy0uR66+JrEuRPpBcPGw1qTbJg5GXtNz3wApdmrsZDHDKEJc/
	Bhu/uOyYODY9X1KfH7LYcjYb08w3L7SKxhDLxJvx+7QcR36N6ctuw2C6tB3i2uLkm97mdm
	goflXOAcXPrX81skgiDR274iJghVEr4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="BXJ/uXLw";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774664972; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=R12a3AlVnNxuV2juWEwgnbD/uqtxdGfbzuo7rBEpZ8o=;
	b=BXJ/uXLwgzLjc2vAL82v76QsMuRELwKQm5p7SmFANdsh8Sg/ONJ3dexk+HoUlP6QzmSjj9y4IrE83q2i8kPlR0iqqKR7m44gt+ab1Sd190a19+Y9P3I7bF/fjVpnu6pmA++fUdGgbu/Y6RgQ+7ExQz3jsCMmqRthdzhWLVqr+DE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X.phNqC_1774664969;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.phNqC_1774664969 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Mar 2026 10:29:30 +0800
Message-ID: <b7cd4127-d178-43aa-901e-039d937a8ad8@linux.alibaba.com>
Date: Sat, 28 Mar 2026 10:29:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
To: Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>
Cc: ljs@kernel.org, willy@infradead.org, songliubraving@fb.com, clm@fb.com,
 dsterba@suse.com, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <6FCC0430-C98D-4D7C-8C53-F7722F1BDC4A@nvidia.com>
 <20260327162252.57553-1-lance.yang@linux.dev>
 <79053B0F-8A40-41D0-8539-0CC30C903B48@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <79053B0F-8A40-41D0-8539-0CC30C903B48@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27CFA20007
X-Stat-Signature: kje3sy4hwrw31drkjnmfojq9sywxxtaq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774664974-690302
X-HE-Meta: U2FsdGVkX19DgDbBYkVQfDdu9k/MmQCeA1aE5sZjYxgVgiUThK5pL8fRzY951eBxgcGzLHC74ZeOFyUvzIF96hopv6+l5RVHYeazalwwGyVnyzvLgrpOiXFMM94sltIrJY+RjZLHAO3QATGwRpLAxZmlSwcy2KJvQ2Z/xAfOmgvjFzlnz5bDoIek/aekp2Cy1jVgLlns0t/37b0HqOdUxY0nYDRZZ6vOD+FBaBeXCqwKAPTXBD4BUX/7vnbwQYEHx0xt0roh8tsGJ1SqDzorj0fnvpkXlIhLBlPDEseniSlm3/zv039t4lWfvQlywdQWUqY7SMreSxcnyJhlN8W3upTxwcsJiv+93Nq5NpRK6Z1ids/C4jNWORvpEgEWL8kmzlaIlJR9NuiVMI92eozY+ALsK7FsVm5M68h1ashDniEW86qDo8SHeXyvVyoBD/T8xXTCqzf2Z7S8YHasZ1UcOQ3sPGoBnH7/yV0Q8GHLHbZo7FwJzNDju7L0EU62xB141eB9Gn/EG9SMGkWfPZ5JkVfKHZ/dxvOpA34ukOZNAqt/4M0IyfYqRFZMyWf8vxdRe5sSt5l8m8jh6c3yCexB0AnB0EgUlRCzGxv54YDqKYmjDRHxb7NaXGGVDcUW0cYn7kA9bUvKn0za3kszSVqldH9JrutufqNQd8vRME8svtPJI9wPrjUWw/vIzRA4CvIgqaog2Hq2Ov42dLmTTVNet2voNGBlMfexUudOSLzInpXasQAUa0sRpve+iLnATbFQetoGefpMrLks07DsNp9g9xGc3fZ51iW6dXDaPmPeNd9CzoUMQMC/48FOuBY/mSMeLtyp0Q9/kpHTLylCDA79oHtAMQjEvU/yhH6Yw/4JH1cAyEnHvTMW+bVRA8UdMA/ypz+JvOu0vBcapS4W2HZQpDdK+8Y9mW4BYC+iG2HofRB5nO9Mdn1xD4Gr1bT+8972/F+eN1S/BmBKL6azUO8
 Cq8NnWQX
 om7pIPn+eZrl0SpNvGPenr/eYKIx5LDOWyc6CPja3LVUGHM+EFa62+WiSlBCFHOEbUSDyXcRaJBe8YzhubFFYAq/QPFOkFaiOqGKXsisoT+ZmMT/e08uyztsNpg+ByAUisKQbVRYPWU/sVtW1pkbFOr5KBtFzPi9xVDC7XKH2ciL1nYKLzmVnU8yT/dqV2NWiMTxpUW66AWrok+Wnq8G9feY09rhLETIgqzl80MdJbICMN9ondGwnM3hiC5x7+0Yf5tdYr7e+7cVoQXxNXwJdHrS99Uk981uvDmyybunWRMRXqYu5Giir4W2YFpu78ndtqzqsHsFlIrVnOQzU2XpVE98V+M3AvpgzqZIkfwoIJwRvAsKqLyNyRahH7cVPibVOa0OV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/28/26 12:30 AM, Zi Yan wrote:
> On 27 Mar 2026, at 12:22, Lance Yang wrote:
> 
>> On Fri, Mar 27, 2026 at 11:00:26AM -0400, Zi Yan wrote:
>>> On 27 Mar 2026, at 10:31, Lorenzo Stoakes (Oracle) wrote:
>>>
>>>> On Fri, Mar 27, 2026 at 10:26:53PM +0800, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 3/27/26 10:12 PM, Lorenzo Stoakes (Oracle) wrote:
>>>>>> On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
>>>>>>>> On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 3/27/26 9:42 AM, Zi Yan wrote:
>>>>>>>>>> collapse_file() requires FSes supporting large folio with at least
>>>>>>>>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>>>>>>>>>> huge option turned on also sets large folio order on mapping, so the check
>>>>>>>>>> also applies to shmem.
>>>>>>>>>>
>>>>>>>>>> While at it, replace VM_BUG_ON with returning failure values.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>>>>> ---
>>>>>>>>>>      mm/khugepaged.c | 7 +++++--
>>>>>>>>>>      1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>>>>>> index d06d84219e1b..45b12ffb1550 100644
>>>>>>>>>> --- a/mm/khugepaged.c
>>>>>>>>>> +++ b/mm/khugepaged.c
>>>>>>>>>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>>>>>>>      	int nr_none = 0;
>>>>>>>>>>      	bool is_shmem = shmem_file(file);
>>>>>>>>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>>>>>>>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>>>>>>>>> +	/* "huge" shmem sets mapping folio order and passes the check below */
>>>>>>>>>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>>>>> +		return SCAN_FAIL;
>>>>>>>>>
>>>>>>>>> This is not true for anonymous shmem, since its large order allocation logic
>>>>>>>>> is similar to anonymous memory. That means it will not call
>>>>>>>>> mapping_set_large_folios() for anonymous shmem.
>>>>>>>>>
>>>>>>>>> So I think the check should be:
>>>>>>>>>
>>>>>>>>> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>>>>         return SCAN_FAIL;
>>>>>>>>
>>>>>>>> Hmm but in shmem_init() we have:
>>>>>>>>
>>>>>>>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>>>>> 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>>>>>>> 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>>>>>>>> 	else
>>>>>>>> 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
>>>>>>>>
>>>>>>>> 	/*
>>>>>>>> 	 * Default to setting PMD-sized THP to inherit the global setting and
>>>>>>>> 	 * disable all other multi-size THPs.
>>>>>>>> 	 */
>>>>>>>> 	if (!shmem_orders_configured)
>>>>>>>> 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>>>>>>>> #endif
>>>>>>>>
>>>>>>>> And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
>>>>>>>> shmem_enabled_store() updates that if necessary.
>>>>>>>>
>>>>>>>> So we're still fine right?
>>>>>>>>
>>>>>>>> __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
>>>>>>>> __shmem_get_inode() which has:
>>>>>>>>
>>>>>>>> 	if (sbinfo->huge)
>>>>>>>> 		mapping_set_large_folios(inode->i_mapping);
>>>>>>>>
>>>>>>>> Shared for both anon shmem and tmpfs-style shmem.
>>>>>>>>
>>>>>>>> So I think it's fine as-is.
>>>>>>>
>>>>>>> I'm afraid not. Sorry, I should have been clearer.
>>>>>>>
>>>>>>> First, anonymous shmem large order allocation is dynamically controlled via
>>>>>>> the global interface (/sys/kernel/mm/transparent_hugepage/shmem_enabled) and
>>>>>>> the mTHP interfaces
>>>>>>> (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).
>>>>>>>
>>>>>>> This means that during anonymous shmem initialization, these interfaces
>>>>>>> might be set to 'never'. so it will not call mapping_set_large_folios()
>>>>>>> because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
>>>>>>>
>>>>>>> Even if shmem large order allocation is subsequently enabled via the
>>>>>>> interfaces, __shmem_file_setup -> mapping_set_large_folios() is not called
>>>>>>> again.
>>>>>>
>>>>>> I see your point, oh this is all a bit of a mess...
>>>>>>
>>>>>> It feels like entirely the wrong abstraction anyway, since at best you're
>>>>>> getting a global 'is enabled'.
>>>>>>
>>>>>> I guess what happened before was we'd never call into this with ! r/o thp for fs
>>>>>> && ! is_shmem.
>>>>>
>>>>> Right.
>>>>>
>>>>>> But now we are allowing it, but should STILL be gating on !is_shmem so yeah your
>>>>>> suggestion is correct I think actualyl.
>>>>>>
>>>>>> I do hate:
>>>>>>
>>>>>> 	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>
>>>>>> As a bit of code though. It's horrible.
>>>>>
>>>>> Indeed.
>>>>>
>>>>>> Let's abstract that...
>>>>>>
>>>>>> It'd be nice if we could find a way to clean things up in the lead up to changes
>>>>>> in series like this instead of sticking with the mess, but I guess since it
>>>>>> mostly removes stuff that's ok for now.
>>>>>
>>>>> I think this check can be removed from this patch.
>>>>>
>>>>> During the khugepaged's scan, it will call thp_vma_allowable_order() to
>>>>> check if the VMA is allowed to collapse into a PMD.
>>>>>
>>>>> Specifically, within the call chain thp_vma_allowable_order() ->
>>>>> __thp_vma_allowable_orders(), shmem is checked via
>>>>> shmem_allowable_huge_orders(), while other FSes are checked via
>>>>> file_thp_enabled().
>>>
>>> But for madvise(MADV_COLLAPSE) case, IIRC, it ignores shmem huge config
>>> and can perform collapse anyway. This means without !is_shmem the check
>>> will break madvise(MADV_COLLAPSE). Let me know if I get it wrong, since
>>
>> Right. That will break MADV_COLLAPSE, IIUC.
>>
>> For MADV_COLLAPSE on anonymous shmem, eligibility is determined by the
>> TVA_FORCED_COLLAPSE path via shmem_allowable_huge_orders(), not by
>> whether the inode mapping got mapping_set_large_folios() at creation
>> time.
>>
>> Using mmap(MAP_SHARED | MAP_ANONYMOUS):
>> - create time: shmem_enabled=never, hugepages-2048kB/shmem_enabled=never
>> - collapse time: shmem_enabled=never, hugepages-2048kB/shmem_enabled=always
>>
>> With the !is_shmem guard, collapse succeeds. Without it, the same setup
>> fails with -EINVAL.

Right. So my suggestion is that the check should be:

if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)

or just keep a single VM_WARN_ONCE() here, becuase I hope the 
thp_vma_allowable_order() will filter out  those FSes that do not 
support large folios.

>>> I was in that TVA_FORCED_COLLAPSE email thread but does not remember
>>> everything there.
>>>
>>>
>>>>
>>>> It sucks not to have an assert. Maybe in that case make it a
>>>> VM_WARN_ON_ONCE().
>>>
>>> Will do that as I replied to David already.
>>>
>>>>
>>>> I hate that you're left tracing things back like that...
>>>>
>>>>>
>>>>> For those other filesystems, Patch 5 has already added the following check,
>>>>> which I think is sufficient to filter out those FSes that do not support
>>>>> large folios:
>>>>>
>>>>> if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>>>>> 	return false;
>>>>
>>>> 2 < 5, we won't tolerate bisection hazards.
>>>>
>>>>>
>>>>>
>>>>>>> Anonymous shmem behaves similarly to anonymous pages: it is controlled by
>>>>>>> the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() to
>>>>>>> check for allowed large orders, rather than relying on
>>>>>>> mapping_max_folio_order().
>>>>>>>
>>>>>>> The mapping_max_folio_order() is intended to control large page allocation
>>>>>>> only for tmpfs mounts. Therefore, I find the current code confusing and
>>>>>>> think it needs to be fixed:
>>>>>>>
>>>>>>> /* Don't consider 'deny' for emergencies and 'force' for testing */
>>>>>>> if (sb != shm_mnt->mnt_sb && sbinfo->huge)
>>>>>>>          mapping_set_large_folios(inode->i_mapping);
>>>>>>
>>>
>>> Hi Baolin,
>>>
>>> Do you want to send a fix for this?
>>>
>>> Also I wonder how I can distinguish between anonymous shmem code and tmpfs code.
>>> I thought they are the same thing except that they have different user interface,
>>> but it seems that I was wrong.

Sure. I can send a patch to make the code clear.

