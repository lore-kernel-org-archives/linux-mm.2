Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58CF606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=opLyUe7j
Received: by kanga.kvack.org (Postfix)
	id 9E27A6B05B5; Mon,  2 Nov 2026 01:06:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992886B05B7; Mon,  2 Nov 2026 01:06:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881D36B05B8; Mon,  2 Nov 2026 01:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53DC36B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:06:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2E2B160BB3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:06:01 +0000 (UTC)
X-FDA: 85389143322.05.967DEB1
Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7ADEA0003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:05:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=opLyUe7j;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793599559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1VSrMby2SX5eM2E4NxQctXhVt0Tc6AaUP5veYJ4paM=;
	b=RFBblyxwLuwZk7fM4lERD90Fh2CxWb28VumgRR2Ae7fSlE/IV2k1PmBOCimQNaeg6zKJvr
	/BmKC3hJ731dlfE9tHyxCkd5zdq6j3iKYco+KAkhl+fqniBSaDJR++CylP+QbfIq0QSv95
	/Nu3kfGKwfmc5QoojouMB87liPfyN48=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=opLyUe7j;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793599560;
	b=Kfuob0mZoVRFwLh/XYOtu11XN55nr7DOIcstc1HkOJFM39rmlNb0K1ZYi+IcZhR+5/za/n
	JFjQag2rLhttQWLvMfQPHJkhU1ETHUy8svGrHihs6UXCD/7DLEqN0cQL1EH0kkhNytWqTa
	d72SxYqY75Ui+nMD9dxoDwW6RRW4K8E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m9NFSN0c8k/rqWtXM6UCsQER/s2DqAk40a8du6haVV4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793599558; v=1; x=1794204358;
 b=opLyUe7jGCNX/Ks2Wfw0GvCvGymVCVFY2l4AjF+DjnJkuDGtnq5w8qUxEBVGRbjNMihUgh2p
 N2WbiyMNueHHPSHUSGE/VxojS8kqzm1uSC+IpGtAVRaUN87GTq88H0oOGL1Su97yAdfj0UCXL5R
 lWXN8dhDPTy0Vq7auiEh+2BU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b978153f13cb2e16;
	Mon, 02 Nov 2026 06:05:58 +0000
X-Mizu-Trace-ID: b978153f13cb2e16
X-Migadu-Flow: FLOW_OUT
Message-ID: <72d1b1d7-2fb6-402f-a557-0eaa767d6f86@linux.dev>
Date: Mon, 2 Nov 2026 14:07:18 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] mm/vmalloc: clamp an unaligned range in
 vunmap_pte_range()
To: Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
References: <20261026080329.140244-1-hao.ge@linux.dev>
 <20261026080329.140244-4-hao.ge@linux.dev>
 <99f529e8-06f7-4a20-a60b-0330c5d3d91c@arm.com>
 <5452d555-82f9-45a6-b443-ee732b1874ba@linux.dev>
 <e8a2a42d-e424-4366-8a68-e39167f62276@arm.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <e8a2a42d-e424-4366-8a68-e39167f62276@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A7ADEA0003
X-Stat-Signature: zocitrt9aeahdedy3jsxzzdynsxdx1wa
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793599559-647061
X-HE-Meta: U2FsdGVkX1+8tEWM4rfd/OdZgtzNWvumQJa/fKhBBoRgPXgz9ZOVJdvPoQPiZk8Izo/eki58h7d115VcE/iysylUazxqCAjwiuh+y2o+/qUpQ+AMvj3ARv70KaNF0kffQtU11G1Wjh/2pS2IxA2t92KVPoIxT0le3fp0iv6ucOqFL2YRrWhBxxe5rc06mNyLm7vaGjdsEOmJbfikQl1YfxI9dT8y+zsn+rk9STjlTGEa871kK70xSEAhGNjVF1h1CmrqyE5Z4THG67YLU6BYrTTP9cQCd03mrGS/y/v3emopUv7JEZKdhvJ/sP00GdwiiHE+ypzF8L69TszQVVIXjL7R7VNDhh5LIqg104ApkS8204MfrxSLPz80uDHcALYLKUNbG+SMMAGc4u4G6TZDRydk/g7XUvpIOye/qfwQ2xZx7LQNfSwzea4SBfKgceoPt8QChoqdpGnf5AumdqAfVrZ9wSWODfq7PksoYJSwfuO1MdSWDcIKNA/a6L7nMcarIe5hV+0tJEb6z1K8z7MTvDiu2+XUhEGu41QCicTY4fm+JpDCLf9TvXvxiJAaULUJDs8+MnwGtP4JSjsR18mQmibYAJkZzwstPnYL0RoLp2/hW5lEnPZUhnqbipgDFK/ywfYm3Erktr9fr4U6fufmS33haIAHN1agFWH1ggtwi1E5wzvNbfUH4YzjHKs/GNlEcsJC6uaw0iokQCCX3D/ylQ7kVZBuKZs/o+hvqmBlzTxoxiOPGiRLe/V/x64BsB09VrD8jy6wFDJeoponwCucyT/1AvOM1lqMqREkc8rpgEXLXQNrseo+ltA4zODUYshpnS3tVRV4F7c11YzZJ+AvF4J5x4Q2vCYAMJj6JNDGmcoa9LmJSllBOdi2Z9Dt2oEbiTCGCSWelC2q80vIA4aDf1giCFFhOWz6wVg8APt/Hjoa9Rc4eRoHHbXfhRCYnxrWoP0nuHiM/DR5WL+Y2Ln
 AFsz1x04
 o3mW8Q8KGrb5OBCQ4p1Trtb98F4tThkQ67p60XD4JzcGOrSDRIvAwlAxwAHm/RZY6lqaQAhj1e/h4zjVthHYljFVfE78zbft0UyJbM1BgagBopwfjoA7xT7bLGtnpSiW1m1pMlbaTq9ElPvsLxgkZkvJHwiZ+H6t91Mi8E+1wYNKlOXcKBTQDfow4kwKBryg71taZ/BChkRoQKKknG6hg+WiPw3ipBSp+hDBdcKJAbhfj373se6OvciLBjtUUPQD0/bAMKuucegJIq3XJ/f6f+zNdbJ3IBlnTCHVEjfSFpewshvHX2sRYTgY/c/IOlZzsTajz50CY9gfAkvpA+fT9IEmzydX5wAb1Dxr1MWLYikDmNpE9Uyyum2lPSwTUKsia0c/SAVZCpYVXlk6Q1RwyiQslBBMiK5El2FaeKe9glEjCZZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/30 22:20, Dev Jain wrote:
> 
> 
> On 30/10/26 2:00 pm, Hao Ge wrote:
>> Hi Dev
>>
>> Thanks for your review.
>>
>> On 2026/10/30 15:14, Dev Jain wrote:
>>>
>>>
>>> On 26/10/26 1:33 pm, Hao Ge wrote:
>>>> commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
>>>> PAGE_SIZE aligned") made vmap_pte_range() warn and bail out when the
>>>> size is not a multiple of PAGE_SIZE. That loop steps in page
>>>
>>> Why are we checking the alignment so late into vmap_pte_range? Why not
>>> simply do
>>>
>>> if (!IS_ALIGNED(addr, PAGE_SIZE) || !IS_ALIGNED(end, PAGE_SIZE))
>>> 	return; (or return -EINVAL);
>>>
>>> at the start of vmap_range_noflush and vunmap_range_noflush?
>>
>> I think adding that check at the entry of vunmap_range_noflush()
>> goes against its design intent. Its job is to tear down the mappings
>> of the given VA range, so even when the caller passes a size that is
>> not page-aligned, we still have to unmap whatever is mapped within
>> that range.
>>
>> So the patch clamps end down to the last full page and keeps
>> clearing. A buggy caller still gets its mapping torn down as far as
>> it goes, and nothing is left behind. The check here is just for
>> protection. 
>>
>> This is just my preliminary understanding; I may be mistaken.
> 
> Hmm I get you, but this is very ugly. We are trying to tolerate
> a blatant bug in the caller with not-so-nice code. But see below.
>>
>> Thanks
>> Best Regards
>> Hao
>>
>>
>> But that's just my understanding, happy to be corrected.
>>
>>
>>>
>>>
>>>> multiples and stops only at addr == end; with an unaligned size addr
>>>> never lands on end, so the loop cannot terminate and walks off the
>>>> end of the page table.
>>>>
>>>> vunmap_pte_range() has the same loop without any guard, so an
>>>> unaligned range would clear PTEs past end without ever stopping,
>>>> walking off the end of the page table.
>>>>
>>>> Add the check there too. The range is clamped down to the last full
>>>> page rather than dropped, and the loop is skipped when nothing is
>>>> left, so a buggy caller still gets its PTEs cleared as far as they
>>>> go.
>>>>
>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>>> ---
>>>>  mm/vmalloc.c | 5 +++++
>>>>  1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>> index 44e0eb32708f..7131f60d1a8e 100644
>>>> --- a/mm/vmalloc.c
>>>> +++ b/mm/vmalloc.c
>>>> @@ -393,6 +393,11 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>>>  	pte_t ptent;
>>>>  	unsigned long size = PAGE_SIZE;
>>>>  
>>>> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>>>> +		end = addr + PAGE_ALIGN_DOWN(end - addr);
> 
> For simplicity assume PAGE_SIZE is 4, start is 3, end is 10.
> With your code we will get
> 
> addr = 3, end = 3 + ALIGN_DOWN(10 - 3) = 3 + 4 = 7.
> So the range becomes [3, 7) clearing only two ptes, the one covering
> [0, 3], the second covering [4, 7]. I feel we should rather make
> the range from [3, 10] to [0, 11], clearing three ptes.
>

Thanks for the example. Looks like I nearly introduced a new bug while
guarding against the old one, good thing you caught it.

> So, at the start of vunmap_range_noflush we could basically
> WARN_ON on non-alignment, and then clamp the start down, and clamp
> the end up to PAGE_SIZE.

I'm wondering whether we should simply BUG_ON for non-aligned ranges here.
Because the unmap could silently clear mappings at adjacent addresses, which
may not even belong to the caller, and this kind of problem is really hard to
track down afterwards. Say [0, 3) is in use by someone else, with PAGE_SIZE=4
an unmap starting at 3 still begins with the pte covering [0, 4), since the loop
clears page by page, so that owner loses his mapping without doing anything wrong,
and only sees the damage much later when he touches it again.

WDYT?

> 
> And with this also throw in a patch to bring the -EINVAL bailout
> in vmap_pte_range to the top, in vmap_range_noflush and check
> both start and end alignment.

For the vmap_range_noflush() check, fully agreed.  The current check
is indeed too late, the range is only found to be bad after part of
it has already been mapped. 

Looking forward to your valuable comments.

Thanks
Best Regards
Hao
> 
>>>> +	if (end == addr)
>>>> +		return;
>>>> +
>>>>  	pte = pte_offset_kernel(pmd, addr);
>>>>  	lazy_mmu_mode_enable();
>>>>  
>>>
> 

