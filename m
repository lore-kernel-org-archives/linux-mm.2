Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D5EC9830C
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B756B0093; Wed, 23 Sep 2026 09:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195EC6B0095; Wed, 23 Sep 2026 09:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E336B0096; Wed, 23 Sep 2026 09:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C64A86B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:32:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 636821A07C4
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:32:20 +0000 (UTC)
X-FDA: 85245116040.13.E4705A9
Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C1EEA000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:32:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jKuUPloH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.227.12 as permitted sender) smtp.mailfrom=yizhang089@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790170338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NG4JXegZ//HjY70YRieR3wxtkpzy8rT/C0WH6S4BaKE=;
	b=BHAOJLwhHR27t9RdAa62hpuLKD2Pp1C/jM5hd2ZL7slCe1s8G4fRqJpPzNpctISNQOKvWU
	Hk/pS7zfrOGmDmQTSqDD42DxKfBXPYmwsxiylTVESo9t2qAiOouoMdOiF1ujoq3FObXx/I
	X0Gm6/LBqdrYsJKdIViYlNCflrr+hV0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jKuUPloH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.227.12 as permitted sender) smtp.mailfrom=yizhang089@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790170338;
	b=phwCnPXU7YDTiHcu7E/3qnnxf49XGbLqiX2f8XcqwPCe5AkCBs9tTXvJ7UT8VDm+HM9hnl
	uoJjUmDBA/j4LDsx8iHGEqv3MD0phZ2MwqILQcT3mAHCUIs5R/uFvnbtzIhSqIjGrMT551
	OMzpQWIKzKjJZu/r3AGQADZqNBEoYzQ=
Received: by mail-vs2-f12.google.com with SMTP id ada2fe7eead31-785686d2112so299738137.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790170337; x=1790775137; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NG4JXegZ//HjY70YRieR3wxtkpzy8rT/C0WH6S4BaKE=;
        b=jKuUPloHD5HFsX+1NWVe5ZFpkxVpiW7809qUTA9psKIIALIISEIO4bAVzP3jMjDzG9
         EwV1NCzbOuV/jgOfBeTHbv1chAH2uRprpcVFQF97psCYz9Q1bN2SkQvYa2TqkJmUuXj2
         sMlPQ//ixKLVru+ovmnTli2Mqi47bOx8nJ3LVKmz9pDeuwjE6J+TeBqwgAdyaOe5ldYz
         jh4z/Ap4NNwNFcKtyHw/t9QTFL2KEr3QQ6i/yiiXwhBghTaQCFP93sUulo1YfPXQ0Dec
         XSQaBI+oMSs+uCR9mPoWbBfdxGpDW0u8lKCyP6qvw6JLavsqysRm7+oHydsZfLGhMvuk
         CvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790170337; x=1790775137;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NG4JXegZ//HjY70YRieR3wxtkpzy8rT/C0WH6S4BaKE=;
        b=EmY4ukg1PLnNMZExPpvj3QfEAx/fLtrTyG8IrJ6deG7sHY8FMnfhEEfbRZdgJgPKDu
         /fEpAbm6HBjmFSRu5Qpvkv/+3jauvszwMzIZAr3tAyr1acVpd6kutnLjhv4XjioPQ9K5
         vGcR/HH5VZqp2gBo1OQJ+C9akvAvZHhM76ehrXkgZOucibrTBjh4iusad08hDirCyCcF
         ra7+GOc2PALY+nn9qedjFH3xQowuhN1tf9QamaC3zD7LNTr4Fh9J8d/Bldw2ubnzoZcA
         7y01vQoSvR/lPwwUd1r3ORfR10w6ykTYSaxgx6xbzk19CcB49cafc/TR3F7HOiCpaxZu
         Sd1g==
X-Gm-Message-State: AFuF++nF6uJ6XnrpvrPPSZLMbFmi4tMdLRF7H4noA2sZFKRPnj/87MA3
	T2H+ENIYfWao51y6Hq73TedHLJcjGj3+sqTpbOjhoJ95DaT0PEI0ayHW
X-Gm-Gg: AYBFou3+aoizYuMf/dCHj20iHpsGaX0mgpLS2JnHHMqzM3Gu8mfF+CZN7t2RqXq6A6K
	J//koa5cnkOTQcQdnd3IFXOzucbqwxXn3xTv0gMVawCUx+Hj4RAx/WuPGRMz7rR9XWJNWx+cJMM
	BZWCktcce0gSyosUfRtac2TzIQtwBHAJwT9TdQKey1Ixq4RHEUOeuh8/H8SfzS0uGcUUQfuwbds
	dKl51ZaH3ndoJBO4FD2PCCF4yp40YLLE2YKOKmd/m7a2oy9cFbjMSkEihKaFb/U77eEUOcfs6W4
	r1GxQ0/t7AKqIP8kxeoBXh+AVyRXZUX+yI/XtjLSLu/zbRUqTduHxdrFEHYv9pW3v4mFm5czBQD
	CqGG6Eq8CjeNmHJ17vmyC2GbrQgyCGnmmUV7ERh2iUs6IVQuPP8NAuL8mqERbPBBTsQy/dgK/It
	7rM4pkEll3BFnHNnmFhweHEqvlD1qTtsKGYbP7QB7tERdyagv5yxaJhhzg9UewZbp+j50/Q96xZ
	fLCOmZTJbJqRRSH8Ec=
X-Received: by 2002:a05:6102:38c7:b0:7a8:1ff8:5741 with SMTP id ada2fe7eead31-7ac1b610a6fmr2117008137.10.1790170337260;
        Wed, 23 Sep 2026 06:32:17 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9851e8c4f2csm922107241.10.2026.09.23.06.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 06:32:16 -0700 (PDT)
Message-ID: <4277af28-222b-49de-9372-4087f1a7e942@gmail.com>
Date: Wed, 23 Sep 2026 21:31:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] mm/truncate: fix data loss when truncating
 straddling large folios
To: Brian Foster <bfoster@redhat.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <arKHDqdDkQajvAk6@bfoster>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <arKHDqdDkQajvAk6@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5f6qqrfaordwsghp5tjgbz1pzozmzzig
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C1EEA000C
X-HE-Tag: 1790170338-696176
X-HE-Meta: U2FsdGVkX19+8cncdWSvdly2or+/BbKEYexBSYTfrPnZJ5oRd4FNmbvTKCUmv+P3tlZM8ZTe+dotFlAGPydM1XxyFR8zxuvmXEmH5GRptSjy5SwxTAq3eN+/LbKv47700g59LqLlxMsdFQMSX5l/ZOd//jHoBHwsXC9RUKyBITZrI43LqKZSB81h7/PyHc3d1p+Ft9cTLsBDgUl8R20iBZupS/AXrb1k3cs1K6v+aUpvNfxRLpweUMQqLmCV9xrpVb4Fzd+qcfdBzF38/u4fTiSP6U2l5N5OLSWxBxtQU5kPblvNqdzoQxwlrWk4+1OJ1hVWE9KRF89hoXUwXqXSa4RB6sQQWISUVAKUCIt2ewHWb85ru0lnVp0MG4q8o6tb5b/HQvHnBsuKBso03Vynh7385Kilhp23i6jIPF0pYQxBoV+pxWhfjrDt62CHbUOEycxlD6abPbrCq47024Qj1mqYQ3DMI76wzesyFSApBxco+lfIwLtorsVX3RnchCq8k39hn27AMD1uOewmZKnoaEWw4DxRWrolkYhRRYlqAIFcKUecHrNQYVlPVfCdxBnyydU/EZQJ/9tImY8Kun0TSdS3rJ9vr7oWBsOL4ZScFXRx10ZwSDbt18YfzotjllQI5Q/5O/I46RQDGMFr/gTWF/4kI9weB7hTC0HLij4lKq9aHLIBeYvbLD97ytga3mTANdsgC2TP4XsVfsdQzTJ720arZdUaE7CuFvd8WZazwgdGVQHF187kKRwZ+i0QdaLKjBzEc7X4HasMeOLplOI61gfBCAr4p7k3RMB9QQDgJ/BuAYcGtBsXxgLay5QP3w3KbkWOPkZRVnhMFrOrzqrwMGAdsbZ+48SVFZOscKWjGngUZfsgPmt5yydnVRVC0dyZskLhkGIvcruVY4m1XkhYeBLEezUeoU3+njKJDnUtyRBj3L6ja17JwQfHlrMC8c+igXfY1Ch7PfTY7mDjT+Z
 sa7OrSat
 nbozit026ioqXdBRmqVWoOaOI6eGgminDdKh04rASOtI7KY8gYFXGgUolhUjZ3EOabwtBOtF/31BXditVcUYGlcCzwicE8ZbaFNL34UmVLF+3p+psRoYvXFIMDh+tx+N4sDmCuuvHF7/ofOnPiSOtXFLNR6JhIkQNpEIR6VoHlWfYlvCEKZEpZiymgWCptzpxffqAo8S7RimLHQOfAzrY6sw/jQSmxFAEDDFUdEWOP9Lta+p8BOWXHf8f8XJ6gGmTAeQfZEgdAOGmgWXwbDHYCu2twhC1x5UZRaVhsZ2jkrmp6xiGso4yAIJCdBbv+SNnQ7qSQ14+Qec0+UvbeOrqRS5fkPe6jDAcsDbh9a+3xeZdKUy3N/fXRZixA8NC0nOJGEq4NWq1omGkbl88RUJIrllYeDQ0kUvuYoakhNER85G29pvIkE+r8ZIf1etVXcpfobgWGM11EZ4lE/MBmKJ8oNIX5kRmdsO1Bs1lkCDA7GRJohtjCfDunKOuJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/2026 9:47 PM, Brian Foster wrote:
> On Tue, Sep 22, 2026 at 07:06:59PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Hello,
>>
>> This is the fourth version fixing data loss when truncating straddling
>> large folios caught on the upcomming ext4 + iomap buffered I/O
>> conversion.
>>
>> When truncate_inode_pages_range() punches a hole or truncates a file,
>> truncate_inode_partial_folio() splits a large folio so that the caller
>> can drop the in-range sub-folios while keeping the out-of-range tail
>> intact.  This series fixes three distinct problems in that path that
>> can each lose the valid out-of-range tail of a straddling folio, plus a
>> follow-up that clarifies the return value semantics.
>>
>> Patch 01 aligns the truncation boundaries inwards to the mapping minimum
>> folio order in truncate_inode_pages_range().  With a non-zero min_order,
>> folio_split() stops at min_order instead of order 0, so a boundary
>> computed at page granularity can land inside a min-order-aligned
>> sub-folio and the truncate loop drops that whole chunk, valid tail
>> included, causing data loss.
>>
>> Patch 02 looks the end-edge straddler up by its page index through
>> __filemap_get_folio() in truncate_inode_partial_folio().  After the
>> first split the straddler is unlocked and only transiently ref'd in the
>> page cache, so the page pointer derived from the original folio can be
>> freed and reallocated as a different folio in the same mapping, and the
>> mapping check cannot catch it, which may cause incorrect splitting and
>> potential data loss.
>>
>> Patch 03 reworks the contract between truncate_inode_partial_folio() and
>> its callers.  If the second split of the straddler fails, the function
>> reported success unconditionally, and the leftover incorrect end
>> position could cause the truncate loop to drop that valid tail.  After
>> rework, it tells the caller the exact page range safe to discard via new
>> pstart/pend out-parameters, so the truncate loop never touches a
>> straddling folio that still holds valid out-of-range data.
>>
>> Patch 04 clarifies the return value semantics to "at least one split
>> succeeded", which is all the shmem caller needs to decide whether to
>> reset its scan loop.
>>
>>
>> The second patch fixes a pre-existing race issue that is reachable
>> today, so it is Cc'd to stable.  Patches 01 and 03 require a dirty large
>> folio that carries no filesystem private data, so they are not reachable
>> on current filesystems.  They were found while developing the upcoming
>> ext4 iomap buffered I/O path[1].
>>
>> Thanks,
>> Yi.
>>
> 
> Hi Yi,
> 
> Modulo Jan's comment on patch 4, this series looks good to me. FWIW:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Brian

Thank you for the review!

Yi.

> 
>> [1] https://lore.kernel.org/linux-fsdevel/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/
>>
>>
>> v3->v4:
>>   - Move the patch that fixes data loss when min_order is non-zero to the
>>     first patch position, aligning start and end in
>>     truncate_inode_pages_range(). (Zi Yan)
>>   - Add patch 2, fixing the invalid folio2 issue under concurrency when
>>     truncate_inode_partial_folio() splits at the end position. Use
>>     __filemap_get_folio() to obtain a reliable folio2. (Jan Kara)
>>
>> v2->v3:
>>   - Rework the folio2 validity check logic to fix the invalid
>>     folio->index issue. (sashiko)
>>   - Clarify the pstart and pend setting logic and the corresponding
>>     comments to make it more readable. (Brian, Joanne)
>>   - Split the patch into 3 small patches. (Zi Yan)
>>
>> v1->v2:
>>   - Export pstart as a new parameter so that the generic and shmem
>>     truncate paths don't need to recompute the start value from the
>>     return value. (Brian)
>>   - When min_order is non-zero, align [pstart, pend] to the inner
>>     boundaries of the folio to ensure they do not point into the middle
>>     of a large folio, which could otherwise cause valid data within the
>>     folio to be incorrectly cleared. (Joanne)
>>
>> v3: https://lore.kernel.org/linux-mm/20260916092450.654408-1-yi.zhang@huaweicloud.com/
>> v2: https://lore.kernel.org/linux-mm/20260909062339.473816-1-yi.zhang@huaweicloud.com/
>> v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/
>>
>>
>> Zhang Yi (4):
>>    mm/truncate: align truncation boundaries to mapping minimum folio
>>      order
>>    mm/truncate: look up the end-edge straddler by index
>>    mm/truncate: fix data loss when splitting straddling large folios
>>      fails
>>    mm/truncate: clarify return value of truncate_inode_partial_folio()
>>
>>   mm/internal.h |   4 +-
>>   mm/shmem.c    |  13 ++---
>>   mm/truncate.c | 128 +++++++++++++++++++++++++++++++++-----------------
>>   3 files changed, 91 insertions(+), 54 deletions(-)
>>
>> --
>> 2.54.0
>>
> 


