Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479A9CF64A1
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 01:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A326F6B000A; Wed, 19 Nov 2025 20:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3176B002C; Wed, 19 Nov 2025 20:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8D16B0032; Wed, 19 Nov 2025 20:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AFF96B000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:57:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AD5D12FC33
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:57:48 +0000 (UTC)
X-FDA: 84129324216.12.70B1864
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf04.hostedemail.com (Postfix) with ESMTP id EAC3B40011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:57:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=B+JWHjDy;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763603866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AXnTDZsh0ZpA3wl1C2Ly62rGjVDj9miUa69NEuNmgQ=;
	b=HRq2ni9MRboXF/oKPMBY6Dhlelc1URxpa0hA2t9P4g6B3Xh8gWdFmDng+soDxN67k6YAe/
	MW4XCsQ7TndiHBSMQdSgmXY+rtw80X2l/XaayfHYKvWsVmnfwUu/5LwtaZPp3G67Da43Az
	0Ua8wH6ciBbhr8UBlxclDQGEm0EQXdI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=B+JWHjDy;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763603866; a=rsa-sha256;
	cv=none;
	b=Si7gS8ToYLwLl7z66UXdXA3WDmxfkmw8ubJVbY4gXvKqdiwimPQ/ORwkSjWjI8PgcRz30Z
	ws8pVqmMi0suFAMqAHLs5BqTJL7l1a2ZpLCIhZK2oZA1tAsf+6peSOFn/VLtqIozo2A8OR
	TugRWm4vfP8vVPNCUvsUH+2zRH3tnUY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763603862; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9AXnTDZsh0ZpA3wl1C2Ly62rGjVDj9miUa69NEuNmgQ=;
	b=B+JWHjDyITN2DMHyw7t/XL+6Q61Ou8Ji1tXN9JAxK/LiylQa4TpiZui/atv2oF72G2nzHwTcly8Qty5rKcKtk/WVY+jrmtHM3/sfF2DTKf3JwBYxGYRQ53lQZ3lmcyKe3d5t6pQLs8QWAyk8DKSbkUDOBH5iUXcJG421kB4OEzI=
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WsrG6cQ_1763603860 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Nov 2025 09:57:41 +0800
Message-ID: <8e766a2b-0d54-4905-9f67-53ef1397b8dc@linux.alibaba.com>
Date: Thu, 20 Nov 2025 09:57:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] tmpfs: zero post-eof uptodate folios on swapout
To: Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-2-bfoster@redhat.com>
 <c1978ef3-251b-4a57-8244-b047e66b6ab3@linux.alibaba.com>
 <aRyFOsUk--AtbEGM@bfoster>
 <9e696091-9c40-46cf-91b9-c95e1d38a1a8@linux.alibaba.com>
 <aR3PWnNFhOckoHvc@bfoster>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aR3PWnNFhOckoHvc@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAC3B40011
X-Stat-Signature: hk7pa8q4b7cburmnu5tn4hmrn18a6jqj
X-Rspam-User: 
X-HE-Tag: 1763603864-389361
X-HE-Meta: U2FsdGVkX1+Evj4O8kbuge5nR7IHfi0lzqrLECy62vauZpTh46d9gOArkPwdqRclHXTQgi0naYg51fxagRjb3uTxW0aAudc5NyP2R7OlJZb5F5RuSKNXZVw4MWoBpWOblV8hX855v6Co/VJ3fXc83qkVE3xnAwM+M10kJt+q29ga4n41EcApfvtFbBPM5hlTK0crynyRRh7sT0gih3odabNT6HrFI5tMiKZ7O3sXeb56DMIEzz9I6vM2IEpvhdgrCp5erxdkL2n5v9k0fk7nZuhGcQ6S1sLdakmpdwPGiAsJdVCrCuoJFRrHaxkMBZqCNkAdgVWTgFWOQ6DAH8cAQw9UDdHT1SXRhg/+Z4dzyVk5piQgPozuGz0kMxiaotXMIl2vNmYm4foy1K/HhfOddIeU4AtdmLfEgbAMxaWZaUqX+bj2bUzO61nbThnXz4un73jIbiIwrgzslI1ZrpvmUxZYoYFQj1hWsf9GQc0ckDUbeMIYjhwNKQVUFAj7vh8LQPupacMYh8ceZs95EJjkDUyd4NoPbR/SL8hAm6F+Y7NLnFvyVNCZYM1FDkrdHoKRjCDdQHbhD2qs4vlsw2J3mSRpTa/BLxr2LoUGPn9uqpXMo0BSzMcEaIVvLEYZnCBrNFtPfpG2yduCQEhGUBFezHrMRbgAZAow+m8PGxLbf5jby6bHVFp2YfPZUcYI5hOTUVwfZpx7XLZFonJqJHQm1ThHcVCi0KLJT0Qm169jQofGzgfxr+Zo3a2bTYX0CALhiZSt/IMJlTrprUBeShdVuxCOlpWkvOKWjnhDISScnlb+UMzzgLvmzWOlxAj9/2zOyNBDXomhWS6IErQrXaiHwVCh7os23BILhFO/eiBltxAcr8ZpHqezlUwtsbRX4nMISmad61BroS+m3dU2azt1de1Z7fDSVvQBxM1EW2C0CtdePRnzMJtYSJqu9QHVg6ERRonKhOKpQmMmN6/KbhD
 ldDV+/do
 tnoLMUQDjpUowhXlrr1W19zRTOpJqystVcDOPg4pUEw6E9IPQOlGDLQMS4bX2lJ8yPOYKx+uR4gCMKzcMgRKEmne8sW7aecd5EL0P0f/QCq4HvxB5pnyapvbcUaFRxPHeiQuJU22lhuS15E3u9UYtVkg3aYDbpACTFzH5JKney04AAcIub1Jtw9q6DdjgHQz1hmNH8gqCsg9+Pj/sK1oTAFUc3P/dFTVtrggbKVYRYvIT0kxZegz/BOsRQETBtDabw7WVI+KpD9CVEAJnwlSnk+CY9aEadX3UPEf5JClnL3nEyGUmLZJVU9M1TMsXeOffS8XvIINXE03PxeXBGCoCx1gj2z8rxU0py9xZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/19 22:08, Brian Foster wrote:
> On Wed, Nov 19, 2025 at 11:53:41AM +0800, Baolin Wang wrote:
>>
>>
>> On 2025/11/18 22:39, Brian Foster wrote:
>>> On Tue, Nov 18, 2025 at 10:33:44AM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 2025/11/13 00:25, Brian Foster wrote:
>>>>> As a first step to facilitate efficient post-eof zeroing in tmpfs,
>>>>> zero post-eof uptodate folios at swap out time. This ensures that
>>>>> post-eof ranges are zeroed "on disk" (i.e. analogous to traditional
>>>>> pagecache writeback) and facilitates zeroing on file size changes by
>>>>> allowing it to not have to swap in.
>>>>>
>>>>> Note that shmem_writeout() already zeroes !uptodate folios so this
>>>>> introduces some duplicate logic. We'll clean this up in the next
>>>>> patch.
>>>>>
>>>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>>>> ---
>>>>>     mm/shmem.c | 19 +++++++++++++++++--
>>>>>     1 file changed, 17 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>>> index 0a25ee095b86..5fb3c911894f 100644
>>>>> --- a/mm/shmem.c
>>>>> +++ b/mm/shmem.c
>>>>> @@ -1577,6 +1577,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>>>     	struct inode *inode = mapping->host;
>>>>>     	struct shmem_inode_info *info = SHMEM_I(inode);
>>>>>     	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>>>>> +	loff_t i_size = i_size_read(inode);
>>>>> +	pgoff_t end_index = DIV_ROUND_UP(i_size, PAGE_SIZE);
>>>>>     	pgoff_t index;
>>>>>     	int nr_pages;
>>>>>     	bool split = false;
>>>>> @@ -1596,8 +1598,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>>>     	 * (unless fallocate has been used to preallocate beyond EOF).
>>>>>     	 */
>>>>>     	if (folio_test_large(folio)) {
>>>>> -		index = shmem_fallocend(inode,
>>>>> -			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
>>>>> +		index = shmem_fallocend(inode, end_index);
>>>>>     		if ((index > folio->index && index < folio_next_index(folio)) ||
>>>>>     		    !IS_ENABLED(CONFIG_THP_SWAP))
>>>>>     			split = true;
>>>>> @@ -1647,6 +1648,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>>>     		folio_mark_uptodate(folio);
>>>>>     	}
>>>>> +	/*
>>>>> +	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
>>>>> +	 * traditional writeback behavior and facilitates zeroing on file size
>>>>> +	 * changes without having to swap back in.
>>>>> +	 */
>>>>> +	if (folio_next_index(folio) >= end_index) {
>>>>> +		size_t from = offset_in_folio(folio, i_size);
>>>>> +
>>>>> +		if (index >= end_index) {
>>>>> +			folio_zero_segment(folio, 0, folio_size(folio));
>>>>> +		} else if (from)
>>>>> +			folio_zero_segment(folio, from, folio_size(folio));
>>>>> +	}
>>>>
>>>> As I mentioned before[1], if a large folio is beyond EOF, it will be split
>>>> in shmem_writeout(), and those small folios beyond EOF will be dropped and
>>>> freed in __folio_split(). Of course, there's another special case as Hugh
>>>> mentioned: when there's a 'fallocend' beyond i_size (e.g., fallocate()), it
>>>> will keep the pages allocated beyond EOF after the split. However, your
>>>> 'end_index' here does not consider 'fallocend,' so it seems to me that this
>>>> portion of the code doesn't actually take effect.
>>>>
>>>
>>> Hi Boalin,
>>
>> s/Boalin/Baolin :)
>>
> 
> Sorry, Baolin! ;)
> 
>>>
>>> So I get that split post-eof folios can fall off depending on fallocate
>>> status. I'm not sure what you mean by considering fallocend, however.
>>> ISTM that fallocend contributes to the boundary where we decide to split
>>> and/or preserve, but i_size is what is relevant for zeroing. It's not
>>> clear to me if you're suggesting the logic is potentially spurious, or
>>> this might not actually be zeroing correctly due to falloc interactions.
>>> Can you clarify the concern please? Thanks.
>>
>> Sorry for not being clear enough (for my quick response yesterday). After
>> thinking more, I want to divide this into 3 cases to clearly explain the
>> logic here:
>>
> 
> No worries. Thanks for breaking it down. Much easier to discuss this
> way.
> 
>> 1. Without fallocate(), if a large folio is beyond EOF (i.e. i_size), it
>> will be split in shmem_writeout(), and those small folios beyond EOF will be
>> dropped and freed in __folio_split(). So, your changes should also have no
>> impact, because after the split, ‘folio_next_index(folio)’ is definitely <=
>> ‘end_index’. So the logic is correct.
>>
> 
> Ack, but we still want to zero any post-eof portion of a small folio
> straddling i_size...

Yes.

>> 2. With fallocate(), If a large folio is beyond EOF (i.e. i_size) but
>> smaller than 'fallocend', the folio will not be split. So, we should zero
>> the post-EOF part. Because 'index' (now representing 'fallocend') is greater
>> than 'end_index', you are zeroing the entire large folio, which does not
>> seem correct to me.
>>
> 
> Unless CONFIG_THP_SWAP is disabled (no idea how likely that is, seems
> like an arch thing), in which case it seems we always split (and then
> the split path will still use fallocend to determine whether to toss or
> preserve).
> 
> But otherwise yes, partial zeroing should be the same for the large
> folio across EOF case, it just happens to be a larger folio size...
> 
>> if (index >= end_index) {
>> 	folio_zero_segment(folio, 0, folio_size(folio));
>> } else if ...
>>
>> I think you should only zero the range from 'from' to 'folio_size(folio)' of
>> this large folio in this case. Right?
>>
> 
> However index is folio->index here, not fallocend. index is reassigned a
> bit further down the function just after the block try_split: lands in:
> 
>          index = folio->index;
>          nr_pages = folio_nr_pages(folio);
> 
> This wasn't introduced by this patch, FWIW, but I suppose we could make
> the fallocend block use a local for clarity.

Thanks for correcting me. I mistakenly assumed that the 'index' 
represents 'fallocend' from your patch:

+		index = shmem_fallocend(inode, end_index);

> So given that, the logic is effectively if the folio starts at or beyond
> the first page size index beyond EOF, zero the whole thing. That seems
> pretty straightforward to me, so I'm not clear on why we'd need to
> consider whether the folio is large or not at this point.

Yes, you are right. After you corrected me, I understand that index 
refers to folio->index.

>> 3. With fallocate(), If a large folio is beyond EOF (i.e. i_size) and also
>> beyond 'fallocend', the large folio will be split to small folios. If we
>> continue attempting to write out these small folios beyond EOF, we need to
>> zero the entire mall folios at this point. So, the logic looks correct
>> (because 'index' > 'end_index').
>>
> 
> Ack..
> 
>> Based on the above analysis, I believe the logic should be:
>>
>> if (folio_next_index(folio) >= end_index) {
>> 	size_t from = offset_in_folio(folio, i_size);
>>
>> 	if (!folio_test_large(folio) && index >= end_index)
>> 		folio_zero_segment(folio, 0, folio_size(folio));
>> 	else if (from)
>> 		folio_zero_segment(folio, from, folio_size(folio));
>> }
>>
>> The logic here is a bit complex, please correct me if I misunderstood you.
>>
> 
> Hmm.. so I'm not really sure about the large folio check. Have you
> reviewed the next patch, by chance? It occurs to me that I probably
> split these two up wrongly. I probably should have split off the
> existing !uptodate zeroing into a separate hunk in patch 1 (i.e. as a
> non functional change, refactoring patch) and then introduce the
> functional change in patch 2. I'll try that for v3.
> 
> But in the meantime, this is the logic after patch 2:
> 
> 	/*
> 	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
> 	 * traditional writeback behavior and facilitates zeroing on file size
> 	 * changes without having to swap back in.
> 	 */
> 	if (!folio_test_uptodate(folio) ||
> 	    folio_next_index(folio) >= end_index) {
> 		size_t from = offset_in_folio(folio, i_size);
> 
> 		if (!folio_test_uptodate(folio) || index >= end_index) {
> 			folio_zero_segment(folio, 0, folio_size(folio));
> 			flush_dcache_folio(folio);
> 			folio_mark_uptodate(folio);
> 		} else if (from)
> 			folio_zero_segment(folio, from, folio_size(folio));
> 	}
> 
> So factoring out the preexisting uptodate logic, this looks mostly
> equivalent to what you posted above with the exception of the large
> folio check. I could be wrong, but it kind of sounds like that is maybe
> due to confusion over the index value.. hm?

Right. My example is wrong due to confusion over the index value. I 
think you are right.

> 
> In any event, I'm trying to make this logic as simple and clear as
> possible. The idea here is basically that any folio being written out
> that is either !uptodate or at least partially beyond EOF needs zeroing.
> 
> The split logic earlier in the function simply dictates what folios make
> it to this point (to be written out vs. tossed) or not, and otherwise we
> don't really have to care about state wrt zeroing post-eof folio ranges
> (particularly if any of that splitting logic happens to change in the
> future). Let me know if I'm missing something. Thanks again.

Thanks for your work and explanation. Now I think your patch is correct, 
and I will continue to review the following patches. Feel free to add:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

One nit: using 'fallocend' instead of 'index' can avoid confusion:)

diff --git a/mm/shmem.c b/mm/shmem.c
index 371af9e322d5..7f7bdb7944cc 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1586,8 +1586,8 @@ int shmem_writeout(struct folio *folio, struct 
swap_iocb **plug,
          * (unless fallocate has been used to preallocate beyond EOF).
          */
         if (folio_test_large(folio)) {
-               index = shmem_fallocend(inode, end_index);
-               if ((index > folio->index && index < 
folio_next_index(folio)) ||
+               pgoff_t fallocend = shmem_fallocend(inode, end_index);
+               if ((fallocend > folio->index && fallocend < 
folio_next_index(folio)) ||
                     !IS_ENABLED(CONFIG_THP_SWAP))
                         split = true;
         }


