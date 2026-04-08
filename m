Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB35FD5F8F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95D86B0088; Wed,  8 Apr 2026 03:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6CE66B008C; Wed,  8 Apr 2026 03:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C829C6B0092; Wed,  8 Apr 2026 03:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8D706B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:11:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 516C313BF34
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:11:08 +0000 (UTC)
X-FDA: 84634517016.05.7F40E97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8E191A0008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:11:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I+90rJ7J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775632266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWtz+2NglrLGfrKFJ0fQ4Q8nzfqms/GUAZppxZmCnR4=;
	b=gaIaaIaylDnIVwNSGLLhR5Himp4wQquH4feP7+bX29l6oIbUuXMuIcWqs6k9+7Vk6KLNsg
	xTDspILSwHvj6KzOYvt/pf8tKT87rcVViz1Zy4Kk9Kp1UBZVxVHRAGmVQ0BYR2hdGsD3om
	ZO7BjiCeQdBYfXo/nfHSjO9Yq6NMZLU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775632266; a=rsa-sha256;
	cv=none;
	b=xhsATp8GGXk3N/MG1Gek5BfvnTgjOkdIdbD/HQndqwRki4eTe6oXua6yBuNESD2kuoRSRX
	AI8l45bgp0U0aZT8e5aCNFlwLZ4ciKrCMyWHdTF2qJqxEkg8s7AbLTC24d/vkKA7fhY+m6
	tYjakbJ2udhzqCug4RF3HN8+dnm4gWQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I+90rJ7J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E6CA560123;
	Wed,  8 Apr 2026 07:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0959EC19424;
	Wed,  8 Apr 2026 07:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775632265;
	bh=d9W3i/Y5J+XoPKpC1HCGuPI+iPeRIhXTy8V5ghioNZ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I+90rJ7JiNyGDHmpESb2muBx4f0icgsKo4YOj3+vqmnnqX0wx2tvnwsbBzyQnF/Jv
	 AdGYGGhLUIEtxOdwe0c4cWeU7+jH4CmT5w2B6xl4YRL5ZCxKcNODp+eE+Yl4tKYZlT
	 TfOajiI8OUldT9FU/5QDfzpt53TBc9dhiRQTMvtbOiCU97GsgMuWGCG9V71tnMz3j1
	 KRqc8eY5D87flUUHMAYzFQ1C4pSY4O3oKCNIO25MjkwGIW62AyRV4HiHgcFopI6+EV
	 sCI4M9DpSvpJHvgT4ANS7XzlTXj441gK+GPg5phi7mxi7rLYBDBaL3iMcTWgrYEZAY
	 0rwobFkScUFgg==
Message-ID: <4a07d02a-6f0d-4748-976b-503dd3db1e5d@kernel.org>
Date: Wed, 8 Apr 2026 09:11:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksm: add mremap selftests for ksm_rmap_walk
To: Hugh Dickins <hughd@google.com>
Cc: xu.xin16@zte.com.cn, akpm@linux-foundation.org, michel@lespinasse.org,
 ljs@kernel.org, chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn>
 <a14a89ba-e870-47d2-a903-564332da9877@kernel.org>
 <2513cca9-0f5f-3b5b-e758-b9cc304c8699@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2513cca9-0f5f-3b5b-e758-b9cc304c8699@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8E191A0008
X-Stat-Signature: kr6ueiz6tcspdt7ymw1j6tqw1qt3ugue
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775632266-694065
X-HE-Meta: U2FsdGVkX1+8jiWy+bxy7dEEGnmfdJ+R7MP1y/kDgmknnQoXSJb1EXVWDrMDGMsysOCBJDvxIiimaSV1LthdzxJf1ztnHgr2mk0T4nmmBP1n4pyMW7pu6Ro1UAG6L2gOr6pXPDnGt+nhLAw4TYmR0L8FRNjKfoDVRqYYEXtx8pm82IJJ2+YjdGPeps3LfK+x+AWvrj8BKRvybPPiaAZn9lubpoMrOmmvzF6r1lzQ9sdMqwJnlSgjMgh+1FJTzTlHktlCzUxqTA2Z9EsBDNpIOKspd6weBFIJ5+n6Hfy1m2uj7AxqKfeYWpmQMAyXw8MUsSFyQU+zwi0+4S9RUxmmq5HDlgkuKTp81kjP1fJvGQaZBNm/RkaFkV/XN7iFvbYX30IBWuDwdl0Rr/7DRk9tDTEd9wFo4jDDZwon5JTfJSUWj9+0cYjdYvosYQZUcztD6VaDH9hJYkc20k6FJg89Ne0VmQTwtVSK/VWbqzVcqK9jUOo3xfoUwp8fh/HN8gnenUepPlhGr0vGEBi0kpq7Ebm7BkS+90i2aqHxOmO2vRMuMJUwsmvFh/OxqN/i1A8253SWqcfTYXFozkmOR13ajtb5oAQcCnGFg62gQSfuHQ8AKaIHvlJmLmCMk00LVR2Dhst9zsUfVir0yllajqfC5/lng+pSax3fAF7kOb7QKI086DKidHrqgBwCF6QVJANQ8gEZyop+rgA8baZNYkSOxZOwnI2yecKY91xRujIpha74qbZM4NXOpfbzmOt2A61nOKfjhazIK3zXkSM67Hgls5PUrof3SHXJ3U3JCpoQRN2lIughsb4MWEVXm1RdWZRKTqafRy34X2daXsFYe4Wg3Qw0XQ8mhAfptRu6CBle+ZFYobSMwb7mEyUwxQK0zYPfVS6l11VHKmngybJ115lAm7DMAPhjNvMVOLM7FJ1feOJPgqj9W+bG0vg0c1c0T1Fo6RQmUpjMlYCMNtFeENG
 reyGQgDU
 ewi1aQajQsheWAAopXMMWsBW5Hq/Vw7vOECRUOTa50TaMu1l2hcSJHpPkNp896CaEfq+2DzHIXczAR0fQGTB0xvjKQx2BjlE9FBPHODf/D8UValVg/qYES6aRN6UJYz59RbtUx1qCx7zZpYICPRrpRzmp/HM+Ex3oMYd8VgOeGh+UFh+SUzMvWn4efjpBgO/AQSTKN701kw/ERzw7vU9R0gZCT83fzal9QyX/pkU8g+aBNNXrdw1wuGazR8mYizcMbSdLfuCP8n4G1xygMlqq0r63MaJg01a9IEqXtzDV+tveZleLmm384gN9pGd2Te7HVNgB3ps1VwY//Q0h39rtPLESD3BGh3yOjH6g4ALv3C06fIhSvWsrpZQlXeVfKpSUGNmv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 02:08, Hugh Dickins wrote:
> On Tue, 7 Apr 2026, David Hildenbrand (Arm) wrote:
>> On 4/7/26 08:08, xu.xin16@zte.com.cn wrote:
>>> From: xu xin <xu.xin16@zte.com.cn>
>>>
>>> The existing tools/testing/selftests/mm/rmap.c has already one testcase
>>> for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
>>> of page from one NUMA node to another NUMA node. However, it just lacks
>>> the senario of mremapped VMAs.
>>>
>>> Before migrating, we add the calling of mremap() to address mapped with KSM
>>> pages, which is specailly to test a optimization which is introduced by this
>>> patch ("ksm: Optimize rmap_walk_ksm by passing a suitable address range")
>>> https://lore.kernel.org/all/20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn/
>>>
>>> Result:
>>> TAP version 13
>>> 1..5
>>> ok 1 migrate.anon
>>> ok 2 migrate.shm
>>> ok 3 migrate.file # SKIP Failed in worker
>>> ok 4 migrate.ksm
>>> ok 5 migrate.ksm_and_mremap
>>>
>>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
>>> ---
>>>  tools/testing/selftests/mm/rmap.c    | 69 ++++++++++++++++++++++++++++
>>>  tools/testing/selftests/mm/vm_util.c | 38 +++++++++++++++
>>>  tools/testing/selftests/mm/vm_util.h |  2 +
>>>  3 files changed, 109 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
>>> index 53f2058b0ef2..65470def2bf1 100644
>>> --- a/tools/testing/selftests/mm/rmap.c
>>> +++ b/tools/testing/selftests/mm/rmap.c
>>> @@ -430,4 +430,73 @@ TEST_F(migrate, ksm)
>>>  	propagate_children(_metadata, data);
>>>  }
>>>
>>> +/* To test if ksm page can be migrated when it's mremapped */
>>> +int merge_mremap_and_migrate(struct global_data *data)
>>> +{
>>> +	int ret = 0;
>>> +	/* Allocate range and set the same data */
>>> +	data->mapsize = 3*getpagesize();
>>> +	data->region = mmap(NULL, data->mapsize, PROT_READ|PROT_WRITE,
>>> +			   MAP_PRIVATE|MAP_ANON, -1, 0);
>>> +	if (data->region == MAP_FAILED)
>>> +		ksft_exit_fail_perror("mmap failed");
>>> +
>>> +	memset(data->region, 0x77, data->mapsize);
> 
> (Not crucial at all, but to avoid confusion between our results, I'll
> point out that my testcase only memset 2*getpagesize() there, leaving
> the last page unpopulated - just one less complication.)
> 
>>
>> What happens if you mremap() after faulting, but before merging?
>>
>> rmap_item->address always holds the user space address of the entry in
>> the parent process. It must match the one in the child process, because
>> mremap() will unmerge/unshare in the child.
>>
>> And it must match the one in the parent, as mremap() would similarly
>> unmerge/unshare.
>>
>> Maybe doing the mremap() before merging (but after faulting) would
>> trigger what Hugh described.
>>
>> break_cow() and friends don't care about the rmap, as they simply jump
>> directly to the user space address in the process.
>>
>> In rmap_walk_ksm(), I think the concern Hugh raised is that we are using
>>
>> 	const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
>>
>> but we'd actually need a pgoff into the anon_vma. Without mremap, it
>> does not matter, they are the same (tests keep passing). But with mremap
>> it's not longer the same.
>>
>> I think one could store it in the ksm_rmap_item, but that would increase
>> it's size. It's essentially the folio->index of the original page we are
>> replacing.
>>
>> Or we could just remember "pgoff is not that simple because mremap was
>> involved, so walk the whole damn thing".
>>
>> We could also just try walking all involved processes, looking only at
>> that user space address (but that gets more tricky with rmap locking etc
>> ...).
>>
>> Anyhow, I think that's the concern Hugh raised, IIUC.
> 
> Yes, you and Lorenzo are seeing the same seed for doubt as I saw:
> as you say, "pgoff is not that simple because mremap involved";
> but it is confusing, so hard for us to be sure about it.
> 
>>
>>> +
>>> +	if (ksm_start() < 0)
>>> +		return FAIL_ON_CHECK;
>>> +
>>> +	/* 1  2 expected */
>>> +	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (2 expected)\n",
>>> +		ksm_get_pages_shared(), ksm_get_pages_sharing());
>>> +
>>> +	/*
>>> +	 * Mremap the second pagesize address range into the third pagesize
>>> +	 * address.
>>> +	 */
>>> +	data->region = mremap(data->region + getpagesize(), getpagesize(), getpagesize(),
>>> +			 MREMAP_MAYMOVE|MREMAP_FIXED, data->region + 2*getpagesize());
>>
>> There would not be a KSM page after this mremap(), no?
> 
> Oh, good thinking: yes, a side-effect of mremap's non-persistent
> MADV_UNMERGEABLE would be that there's no KSM page in the mremapped
> "subregion" at this instant, so the try_to_move_page() which follows
> is likely to have no trouble succeeding; so, as it stands, this test
> is not testing what's required.
> 
> Sorry, I won't be able to give this more attention for a week: I
> wanted to advertise my doubt before 7.1 merge window, while awkwardly
> knowing I'd have to back out of ensuing discussion and testing for a
> few days.  It seems agreed that we won't endanger 7.1 until this is
> resolved: I just hope I'm not guilty of raising a false alarm.

Not at all. During my review I primarily focused on the "do we handle
fork'ed child processes in all cases correctly".

Given that our tests keep passing, I was assuming that non-fork should
be fine. But seems like we might be missing some test coverage even
there, with respect to mremap().

-- 
Cheers,

David

