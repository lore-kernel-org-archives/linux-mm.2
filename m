Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED48ECF256C
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 03:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26956B0008; Tue, 18 Nov 2025 22:53:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFE866B0027; Tue, 18 Nov 2025 22:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13E46B0093; Tue, 18 Nov 2025 22:53:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD8656B0008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:53:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 796C0B7E73
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:53:49 +0000 (UTC)
X-FDA: 84125987778.09.EFCD489
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf08.hostedemail.com (Postfix) with ESMTP id C5148160009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:53:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w5pac0wj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763524427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1mmWG1ZcUB3wWEWRnLd6XgEEMmpb42FW2wuQAB9+SA=;
	b=oNVMGldKpbjYRFFHdj5Dw1TlCW94Gn2Xk+s30i0pkMMvtXM8LoD9XWBV5o6sbDQdngh0dq
	6VAhNZ2eVrF0bzQc6wjny3oilUQa7Ft0jH7958MFVWLrZ01DEKGZDS5gAYKRNT4lfRuZrd
	7FsOqOrLreGujU7sVa754Pp0tkG/7pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763524427; a=rsa-sha256;
	cv=none;
	b=ZmRB/KLdyO2Apk/jkK6FDAX9ZY88yqgzvoNsNyolKRyHy1D5NYTsVznMPENwQkfsARwkXo
	ASENoTqtPt2l7+G2ksgPwpMC85wX/NAmsmrloTP7Fr3+tFkwRE3s+eW6vOkadLmftufLEK
	0F/7tPmQ5/NqUj/X5tD7N1k1GSR6vq0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w5pac0wj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763524423; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r1mmWG1ZcUB3wWEWRnLd6XgEEMmpb42FW2wuQAB9+SA=;
	b=w5pac0wjkqjQLTS74uLtLjvyGqXT6xerbbfTkc9d14ac4ymv+ikJok3gSKG9/JjlwE6ANjfQ69ps0CR1IWXpiDY4c69sHRG2jrJlItkI/GrP0I6DnLaedQZMos0H3jPABUqCDmFEwsfrGuhEmi+q3x5gp2U/4e2ft83Ucb1Maak=
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wsmou1A_1763524421 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Nov 2025 11:53:42 +0800
Message-ID: <9e696091-9c40-46cf-91b9-c95e1d38a1a8@linux.alibaba.com>
Date: Wed, 19 Nov 2025 11:53:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] tmpfs: zero post-eof uptodate folios on swapout
To: Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-2-bfoster@redhat.com>
 <c1978ef3-251b-4a57-8244-b047e66b6ab3@linux.alibaba.com>
 <aRyFOsUk--AtbEGM@bfoster>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aRyFOsUk--AtbEGM@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nddzgth6zp9njgope3eitzne8mhcjtio
X-Rspam-User: 
X-Rspamd-Queue-Id: C5148160009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763524426-44853
X-HE-Meta: U2FsdGVkX1/4arkNu2IwYX80uSxBj+46uI03qolEbvmAFtW0senH8XUiwTSs2rRsR39d/AaD58joRlVn+rBTMfhtXke6UMQMHNwLGiC38XfFQwSxG0skaqUhUW/hUKTV+0Kdv2IGbVvLSkI1oW8QGTnW+jfTg4978qdvrWNEnD+7/1rHKML/rl4FTqoWkxjCAZg7wuf9o5zx3MesMetQ/0B+W+vuGorHDkn2B+/OH0UZLofQaQeAViLum4GX8/jYHlCfFAaqj2wXFGHiOk27ikq0VbqEAKC4mjTymcL4CQdVIXF/fz/EGCsLBbZw7NFCb7153tWCCWB1zFIT1I1wsAZ9tZUgEUPcsy6FSBiM0mXOk+gKb5hOs3aARukjaCDLJLgmYN4kNDE6JHjlbcUFTia+/XsOAMTSVNMob2M+DUQdesYs0OU5POVj1iOXnQ+1b7HaRaGYwP4iCLvW9m5Y+fDISs4xFSWt8Q+uX27TZ/AfbQ9fXfrCNqyP14x0Ak0XQA53hkOb1yYBk7pLMleqOA3RgbRgb09/qqD9SaMwVHLWBbq+Z1k9lZDabRZzsT8l60g5V/9nOVtQmsGD5r8eQUM0zfwmExVA41fBIk954qVH4ynPyV/8NHJFCBew9xsimGe+J6qA3KnmYwIXFmmF8SzrZGIiclYH7PUNyrabXe4FJCnOTr5YqvA+HLHFlM/+R4q0mHUa9xIMMTALPhYKhqU2DNC974CztJisfdAlzx0lCuJzLPJKBiAdw6+Uib1NVbhFxBa0/oyEsD7Mic+pGqiGuQUHGex98Xn81PbL1kQc+rPvYE+1v0XdMEQipYgXWQBhnDK1Zje2oOt7LomQ5byRvARIxiF5phQM+IanIWfC4rdAwatw8SIvQaEab1C+3znSr26utxViKgeJA8SrseQ1PUAw3LxtWjQLqR16ppYxM8E+QAeX+HrUn4yM62mPQNvt5JwpXDVLgBX6o8X
 hrmwF+OG
 D5yLwHTlnj5veBP675vwgW9CUkcD4MWN3nnO3CHn6hLcCmU/IDN4JRkZGQyAn2M06CU6z/4p8jFHkvMD/ny3RoT+KTO56S8fGnn9ZbeXM654bGkLknoXLSc8KrcwIekpHPOmNt+xeit26Fr4znswkmsTo6aO5Az6gpgyfApGoYrGznYvT0Cq8QRnMUojGDKgUZQ2SdgZeyxnvQ45wKD21tv9vd8aMEcyaQ8uuCG65cVdayTmWlx/xCRY+ayPW0sY4iolos5EHJAQh9Lwy2DW6xbSpbqd/vfXUeLbWQZNdeEcEmWVLQCil7zDDS51SzfPd0HinRO5xXTs1jksbPnLd9xE46KAjzv4w0ahAXMknaxPfW+g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/18 22:39, Brian Foster wrote:
> On Tue, Nov 18, 2025 at 10:33:44AM +0800, Baolin Wang wrote:
>>
>>
>> On 2025/11/13 00:25, Brian Foster wrote:
>>> As a first step to facilitate efficient post-eof zeroing in tmpfs,
>>> zero post-eof uptodate folios at swap out time. This ensures that
>>> post-eof ranges are zeroed "on disk" (i.e. analogous to traditional
>>> pagecache writeback) and facilitates zeroing on file size changes by
>>> allowing it to not have to swap in.
>>>
>>> Note that shmem_writeout() already zeroes !uptodate folios so this
>>> introduces some duplicate logic. We'll clean this up in the next
>>> patch.
>>>
>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>> ---
>>>    mm/shmem.c | 19 +++++++++++++++++--
>>>    1 file changed, 17 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 0a25ee095b86..5fb3c911894f 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -1577,6 +1577,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>    	struct inode *inode = mapping->host;
>>>    	struct shmem_inode_info *info = SHMEM_I(inode);
>>>    	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>>> +	loff_t i_size = i_size_read(inode);
>>> +	pgoff_t end_index = DIV_ROUND_UP(i_size, PAGE_SIZE);
>>>    	pgoff_t index;
>>>    	int nr_pages;
>>>    	bool split = false;
>>> @@ -1596,8 +1598,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>    	 * (unless fallocate has been used to preallocate beyond EOF).
>>>    	 */
>>>    	if (folio_test_large(folio)) {
>>> -		index = shmem_fallocend(inode,
>>> -			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
>>> +		index = shmem_fallocend(inode, end_index);
>>>    		if ((index > folio->index && index < folio_next_index(folio)) ||
>>>    		    !IS_ENABLED(CONFIG_THP_SWAP))
>>>    			split = true;
>>> @@ -1647,6 +1648,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>    		folio_mark_uptodate(folio);
>>>    	}
>>> +	/*
>>> +	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
>>> +	 * traditional writeback behavior and facilitates zeroing on file size
>>> +	 * changes without having to swap back in.
>>> +	 */
>>> +	if (folio_next_index(folio) >= end_index) {
>>> +		size_t from = offset_in_folio(folio, i_size);
>>> +
>>> +		if (index >= end_index) {
>>> +			folio_zero_segment(folio, 0, folio_size(folio));
>>> +		} else if (from)
>>> +			folio_zero_segment(folio, from, folio_size(folio));
>>> +	}
>>
>> As I mentioned before[1], if a large folio is beyond EOF, it will be split
>> in shmem_writeout(), and those small folios beyond EOF will be dropped and
>> freed in __folio_split(). Of course, there's another special case as Hugh
>> mentioned: when there's a 'fallocend' beyond i_size (e.g., fallocate()), it
>> will keep the pages allocated beyond EOF after the split. However, your
>> 'end_index' here does not consider 'fallocend,' so it seems to me that this
>> portion of the code doesn't actually take effect.
>>
> 
> Hi Boalin,

s/Boalin/Baolin :)

> 
> So I get that split post-eof folios can fall off depending on fallocate
> status. I'm not sure what you mean by considering fallocend, however.
> ISTM that fallocend contributes to the boundary where we decide to split
> and/or preserve, but i_size is what is relevant for zeroing. It's not
> clear to me if you're suggesting the logic is potentially spurious, or
> this might not actually be zeroing correctly due to falloc interactions.
> Can you clarify the concern please? Thanks.

Sorry for not being clear enough (for my quick response yesterday). 
After thinking more, I want to divide this into 3 cases to clearly 
explain the logic here:

1. Without fallocate(), if a large folio is beyond EOF (i.e. i_size), it 
will be split in shmem_writeout(), and those small folios beyond EOF 
will be dropped and freed in __folio_split(). So, your changes should 
also have no impact, because after the split, ‘folio_next_index(folio)’ 
is definitely <= ‘end_index’. So the logic is correct.

2. With fallocate(), If a large folio is beyond EOF (i.e. i_size) but 
smaller than 'fallocend', the folio will not be split. So, we should 
zero the post-EOF part. Because 'index' (now representing 'fallocend') 
is greater than 'end_index', you are zeroing the entire large folio, 
which does not seem correct to me.

if (index >= end_index) {
	folio_zero_segment(folio, 0, folio_size(folio));
} else if ...

I think you should only zero the range from 'from' to 
'folio_size(folio)' of this large folio in this case. Right?

3. With fallocate(), If a large folio is beyond EOF (i.e. i_size) and 
also beyond 'fallocend', the large folio will be split to small folios. 
If we continue attempting to write out these small folios beyond EOF, we 
need to zero the entire mall folios at this point. So, the logic looks 
correct (because 'index' > 'end_index').

Based on the above analysis, I believe the logic should be:

if (folio_next_index(folio) >= end_index) {
	size_t from = offset_in_folio(folio, i_size);

	if (!folio_test_large(folio) && index >= end_index)
		folio_zero_segment(folio, 0, folio_size(folio));
	else if (from)
		folio_zero_segment(folio, from, folio_size(folio));
}

The logic here is a bit complex, please correct me if I misunderstood you.

