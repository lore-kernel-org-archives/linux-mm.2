Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C654DC624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 09:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BD46B008C; Sat,  5 Sep 2026 05:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C186B0092; Sat,  5 Sep 2026 05:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92AB96B0095; Sat,  5 Sep 2026 05:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BCC66B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 05:15:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8814802D6
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:15:54 +0000 (UTC)
X-FDA: 85179151428.25.6575653
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id E2D63C0008
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:15:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sp4bMZBr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=yizhang089@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788599752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkNrlvb6cnD9CuTqAczKwPY041LfREd/gnUIybiJ3Io=;
	b=JyNroyS2ICOG1JZhAHhIHYRBt04F/L4OHJYwNKkobWmw9oOAhByEz5yfjki9Q8j4W23YtS
	bjynSG8GPU9Hi9c4WD6zx7DsHMZjbxmYD3rlN77KBXedaR3XxYRGhTgR5Ya7MzcuRWrfMI
	j684vlo4+nvjDD61SfE4ucYlz2tYM4Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sp4bMZBr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=yizhang089@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788599752;
	b=V1nGxoUyGtzUWZbZu+CGTjs/M8JyUGg9JE4vGeEhvKDXRtLMEms0e3iVZWYZ7suSQW4PWW
	/+otgf7twxkb7um6gbq7OJAjnN9a59Rm+mFBTpEgO4Ap8zbKMBpf2cDSLFfFgT9A7v3tzi
	i+hRpvFRc+w2iEmm0BKk/Cy9iJlrS4o=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-ca80d708489so1406069a12.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 02:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788599752; x=1789204552; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkNrlvb6cnD9CuTqAczKwPY041LfREd/gnUIybiJ3Io=;
        b=Sp4bMZBrTtbzcDG9U6PZ58YtjqJ8VgY+9RpJ4zqu3TeJcJz5DfmlSGemJPf8l+dcW/
         3Hcc1V8Dx00ItO0QSeV5zBUTQVRJ0WygKbmIsikcaDfuSvWMtr01Xp4BoWvp6IeYUvlu
         GedJtiH7EtNqdDWWx2Vg437JWPifLJ8K9Jar9q8C/9Usszu7oBLEPWEH7WHNRC8cby1x
         YYw/DPf1G8opKJcTe0Qrp6/d1G+mt/ZxUeaCOGy9dKVxOsBSdFEu6FdlDaTJ9NtuXgVK
         vy39V45dFtaz095h752MJuu2C1cE/+5HZ8jABT7WKAjTvApimj22yticRQ+MOyuy0QMr
         385Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788599752; x=1789204552;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OkNrlvb6cnD9CuTqAczKwPY041LfREd/gnUIybiJ3Io=;
        b=OTjhw32McFLHPsJMLSWkaXe7fPAlk1BJCAh4yQsfjL0eQ7h1nFZljWT80lqJLvQLsE
         DyHD7yCZ1ueS/6wZNzu48Kno0GHoQ3itzoAA2DY6pPM7ytwJiha0MTzaRwhVQd1ZZO14
         s9S+CmC6yyIfjYjAN9VzHerXc/OhS2uG9IL5hJbC556cEaabQ6xz2kZ488GMZZy49+Rw
         WqLepcyGUSCNN+Wd1qS4kwiniYfy4rsDVgduFZhsdazvGtAhnTSA5fJq8DUY/Piqd2r6
         2oO1HOvF5O1mtNdMlOKpLhPkbKqCCBSaoMSRwVpibvr7P/l2MPKvbafQeh42oA/SowSc
         2SUQ==
X-Forwarded-Encrypted: i=1; AKwUvBybapxnXiDOYOth4A9EI+OHcYF9YXczL5Luc7zKej0qCAClW3iOEmi6vyoeUNw4HVgSEmBWEr93zQ==@kvack.org
X-Gm-Message-State: AFuF++mE9r+p7XntvHYOM1Y3t4z11ZYrWY31s2XbnzQSVNk1Dbqk+sva
	bk5oSpxJqHYm0MtfAnOR9ylCF/K56wCo0uRajX1t0eflcsDOX3L5RoPB
X-Gm-Gg: AYBFou0Q/bDWxddEYbkdC2UKXszrtaXt5J6vt30xdOcJa9+IWeR6mdpIeT1kA1ZKrBE
	PWwSfBqOgLwvmE3yWDQySG41R/ZW3AjYGVajlmJ2xdT8pnh2AQ5kkXPBsGhepvmsyioLJaBvVoO
	0Vquzzcs716UgbBnK0b+A8n7dCCF9dm+tZG09bxBFee+aRon1IuJsrORW2lId/O8PiwLDNOUxPt
	cRKLsn07SryQqU1gAzMX2aKAvyj3rqfygIWxSL29y9+LqLZvegGzgIRWTe+Ct9n3WUDxwJ+NtBa
	xzAD4tLi8xXcTGT25SRUJfphMQ0G+AFvESB6FWP6sat7tWYbfCktsz/lpVycu/hItYsPMNLyRGA
	eS0oQgVd4QZZyYRulaMzbqaehsBYJkBlASQkB+9g6FXwQucNNthNB5O1pz7FYeWIydeUdW02X8l
	Uu8SxeVtm1QMEa7G0NUgCEjMYjAqrdVRmYdv3uefGq77eoBG8NhFnDmzuyfMmvmCfD9i42DDH0D
	0OK3/Wk
X-Received: by 2002:a17:90b:3a0f:b0:395:8124:ac53 with SMTP id 98e67ed59e1d1-39b27c49335mr8504502a91.6.1788599751607;
        Sat, 05 Sep 2026 02:15:51 -0700 (PDT)
Received: from [192.168.0.104] ([115.192.217.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ca63b3sm15197402a91.11.2026.09.05.02.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 02:15:50 -0700 (PDT)
Message-ID: <4e166a3d-9012-45ab-a011-0e0ad54143d5@gmail.com>
Date: Sat, 5 Sep 2026 17:15:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
To: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 bfoster@redhat.com, djwong@kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com, Joanne Koong <joannelkoong@gmail.com>,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <DL6S5JLBHSAB.1RL17ESZ1EK10@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <DL6S5JLBHSAB.1RL17ESZ1EK10@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zwopuamnkueok3fb46emx45gnxhsuxyc
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2D63C0008
X-Rspam-User: 
X-HE-Tag: 1788599752-549569
X-HE-Meta: U2FsdGVkX18Tp7bYaS1x8jQlHRLBH/S78hJ2EBsVYVN5JyxuJiENVG5XdnPRqH0efLCAkIbmgFvqZkpUEoO0raqsMLJkqLN9K35wY/m5kxDMRmidxqYXalRI2Olmz8m2D4f7JnUV/IRjEgUHnt7JhoL9GHEsC+dTpOF2G+ZC2uMYTpw7fuIkc0RLigWwJlLRPWdEg2flZ59gmEc91SQxLaC3SR0hJ3Z78+F2KSzL5idiTE95Kd2DnLsE4ZTJdlCiU2LumjE1m9qdEZKlHF9Q9oQq9O0Ew747e9wtpHc3+cLqb0RxZxyVtcFNkOf+tWcDmYLgVAtT+IMyJTLftxiOfsGzyFw8lXTeKUOg+CKYQS/hjbtuJyj1pPHcJvjENIRr9hAignXRX+tJptKW9uOkjFZVDhMHW69X7576HqBSnCINnEm8dLH90F8x7jKreX5pRkrrNHz+ZaE2UuPAkbDSzJtDliemN0gcqA2VK5NJ0laj78KLGXot650smHpascYTCW0J09951eM+BC6XboowV15wMJVKfjjef/6xnJPUh/wAW30nTyI4vAfSFxAgTVC6oblNHqXsRcW66R5JX+5c/5LZoSARkD37Sgkic8qDVSkgVzut9NTCDSfgHVPF1DJG9tNb6W908thbdih2Sf3KxLDqrPyhFrr/l+NeGQE08HiYBb+kaW4Rh52esnkWVLZWcZkg4oeKs4tt9K7KgaRBEMQhIU3ri8bU21tKUGyGuYo/KoFxvNGRvLCTxzBkPySiRelboMxeJ0PsTXKyr+ImroN3fJsSTdAMKbxliIvWxlZueY+rnBTcvsVrRCHCSNmnP1OdsID3ry1b4L2IDGOEBxtYmm5Bqcsboz8ik2EGTuH0gkPBiNiMyLyQUT4+mzpdMWq2s7nExkjuU03acbDnqI6qdy3ftPgEOYt5iTj13MnjAO6roKkUp6N5ZFS4ILNJqzJdvjGuId+Jt+7Sv5n
 VYbJFlsv
 gdW8OUgrvR1xqsmEzZwFzVoVfB2veL1CBL3qwsku7ELV05RLnzX9ewzIYAJ1kX5M8UROVxUrN1CjIkbRETsCF9nusUx9NL9d74IuEM/bZ5sXfRPIRiCnm6xx8jVEn2dtXt6Q0IJU7fGXmbdQ4sLquqyBsR80q1dJMAi4SgepMsvBHK158VgIeq0ZWyztG68FJl+XeTOVLit4J3CvQKluB5wr+l1JlXynHSR8WXXQNfnP1qnjwEwW5A4khHSXO4umpFDPlViA6LLrTcyUPavm8MOLbqTifdnEoLPg9muZdVVzYjb8J1BARNpSjYFGeE4iPMKgGnPKM8QX9LwBNY9j02FYLGzL7IzoG6jObUtn6SF1g6AbGBm+kQQIzXWHPgAsWY9ekMow6LYw2YYG65yWC6koL4YyoKaUg/gfuHKsXhI2wP6Z4VYmNv6h3AkPyKVetZlrJeVMGvNQyqx7dxVz5P6ttNysmJroCmH3rqAeVDY+v4SP0rO/C5XehRI5sGZ96EKuesn00keXSSolQ/rLNowNIOt5GuQpm4BKAa+xy+2UIwV+nL5g/NCRkXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/2026 3:31 AM, Zi Yan wrote:
> On Thu Sep 3, 2026 at 7:50 AM EDT, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> truncate_inode_partial_folio() splits a large folio so that the caller's
>> truncate loop can drop the in-range sub-folios while keeping the
>> out-of-range tail. The first split at the punch start edge is
>> non-uniform, which leaves the sub-folio at the truncation end edge as
>> large as possible, this means it may still straddle the range, holding
>> both zeroed in-range and valid out-of-range data. The function then
>> attempts a second split at offset + length to isolate that tail.
>>
>> If the second split fails the straddling sub-folio stays merged. The
>> function returned true unconditionally on all exit paths of the success
>> block, telling the caller it was fully handled. The caller kept its
>> default end and the truncate loop truncated every sub-folio below it,
>> including the merged straddler, discarding the valid out-of-range tail.
>>
>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>> of the last page:
>>
>>    truncate_inode_pages_range()
>>      truncate_inode_partial_folio()      # same_folio == true
>>        1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>        folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>        2nd split of folio2 fails / cannot lock
>>        return true                       # BUG: caller keeps default end
>>      end = 3
>>      loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>
>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>> folio_split() in truncate operation") replaced the atomic split_folio()
>> with folio_split(), whose non-uniform split can partially split a folio
>> and leave the end edge merged.
>>
>> It has gone unnoticed because a dirty large folio normally carries the
>> filesystem's private data, for example buffer_head, so
>> filemap_release_folio() -> iomap_release_folio() returns false on a
>> dirty folio and folio_split() aborts with -EBUSY before any split,
>> leaving the straddler safely unsplit. The bug is only reachable on paths
>> that produce dirty large folios without filesystem private data, and it
>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>> attached.
> 
> Thank you for the analysis.
> 
>>
>> Rework the contract so the caller is told where to stop instead of
>> silently truncating the straddler:
>>
>>    - Return true only when a split occurred, false otherwise. This
>>      clarifies the existing confusing return value semantics.
> 
> Should we do "return false" for not split case as a minmal fix first?
> 
> Something like below. A second patch can optimize on top of it. Let me
> know if I miss anything.
> 
> BTW, Claude also mentioned that if min_order > 0 and end is not aligned
> to 1UL << min_order, there could be some issue. So
> 
> ret = !folio_split_or_unmap(folio2, split_at2, min_order);
> 
> should be
> 
> unsigned long idx2 = PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE;
> 
> ret = !folio_split_or_unmap(folio2, split_at2, min_order) &&
> IS_ALIGNED(idx2, 1UL << min_order);
> 
> ?
> 

Hi Zi Yan,

Thanks for the minimal fix. I agree with the core observation — the
tail is only really isolated when the second split and the boundary
alignment both cooperate.  However, I'd like to point out a trade-off:
the "return false to make the caller skip the folio" mechanism leads
to an incorrect 'start' in truncate_inode_pages_range() and over-keeps
the in-range sub-folios.

The problem is that the false return value was designed for the case
where the folio is unsplit.  Look at the caller:

         if (!truncate_inode_partial_folio(folio, lstart, lend)) {
                 start = folio_next_index(folio);
                 if (same_folio)
                         end = folio->index;
         }

start = folio_next_index(folio); end = folio->index only makes sense
when folio is still the whole folio.  But after the first split
succeeds, the caller's folio reference has already been transferred to
the sub-folio containing split_at, so folio is no longer the whole
folio.

Concretely, take the commit's example: a 4-page order-2 folio
[p0 p1 p2 p3], punched from offset 0 into the middle of p3,
min_order == 0:

         [p0 p1 p2 p3]  --1st split @p0-->  [p0] [p1] [p2-p3]
         folio now points to [p0]
         folio2 = [p2-p3]              # p2 zeroed, p3 tail valid
         2nd split of [p2-p3] fails    # e.g. -EBUSY, or can't lock
		
With your fix, ret becomes false, so the caller runs:

         start = folio_next_index([p0]) = 1;
         end   = folio->index          = 0;

The truncate loop then does while (index < end) -> 1 < 0 -> nothing,
and [p0] and [p1] are left in the page cache, even though they are
fully inside the punched range and should have been dropped.

To be fair, this will not lead to any data-corruption problem because
p0 and p1 are already zeroed.  So as a minimal fix to stop the data
loss, it is acceptable.  But it still leaves the in-range sub-folios
behind and wastes memory, which somewhat reduces the benefit of
splitting the folio. So I don't think change the return value alone can
solve this problem.

What do you think?

Thanks,
Yi.

>  From 564fd753071be9d59d9e45e4609a812bb81f778a Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Fri, 4 Sep 2026 15:25:06 -0400
> Subject: [PATCH] fix unsuccessful folio2 split
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/truncate.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be474..2c575f5e61889 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -259,6 +259,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>   		 * for shmem truncate
>   		 */
>   		struct folio *folio2;
> +		bool ret = true;
>   
>   		if (offset + length == size)
>   			goto no_split;
> @@ -273,19 +274,23 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>   		if (!folio_test_large(folio2))
>   			goto out;
>   
> -		if (!folio_trylock(folio2))
> +		if (!folio_trylock(folio2)) {
> +			ret = false;
>   			goto out;
> +		}
>   
>   		/* make sure folio2 is large and does not change its mapping */
>   		if (folio_test_large(folio2) &&
>   		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +			ret = !folio_split_or_unmap(folio2, split_at2, min_order);
> +		else
> +			ret = false;
>   
>   		folio_unlock(folio2);
>   out:
>   		folio_put(folio2);
>   no_split:
> -		return true;
> +		return ret;
>   	}
>   	if (folio_test_dirty(folio))
>   		return false;


