Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31038606A337
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jbt9Kafj
Received: by kanga.kvack.org (Postfix)
	id 4C8C76B05B2; Mon,  2 Nov 2026 04:07:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A08D6B05B3; Mon,  2 Nov 2026 04:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390FF6B05B4; Mon,  2 Nov 2026 04:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11FE66B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:07:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C9EF140BE8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:07:53 +0000 (UTC)
X-FDA: 85389601626.19.8973F7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BBA27A0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:07:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jbt9Kafj;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793610471;
	b=JlACGvcGFItm3f5yvE/5LupaDme88NskUFUlPn9XKQQkCN6QftxPIzxkUCRoBInirMatyB
	5sNJ5mm6fbgzjzzDsAUdsQo97xuT1NaXGz8q/pa4bA+AvUyJsBVqGw609RJAf6YigcR4QP
	TMl0apKq8CAovTHonpkKi2P4L3bH0bQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jbt9Kafj;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793610471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5S5t7qJTf2rCr/p9zCfI7+knHjLhu44+KFJNlFtVB/M=;
	b=7BSbVsQ8yiVPzLn+xRb0TwWnT6PT6ziS3DmZDezTA/KUcnbrNCna1PiORsQY18RK/bjFXe
	4unZwByRAE81CsK8EGxFzK7e7Ba21vOJ3sJEHqbuK/nYRhF+08IThrFpbJZAzAZivJmGpT
	vAmuIDVzRRFIJn1do5wQlaATWG+i+sc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C7D840F8E;
	Mon,  2 Nov 2026 09:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1431F000C1;
	Mon,  2 Nov 2026 09:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610470;
	bh=5S5t7qJTf2rCr/p9zCfI7+knHjLhu44+KFJNlFtVB/M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jbt9KafjnzhlsJBoEzqWcGNhLY15fXOKREOH+XxGfPFAXJV5Nl3LP/yorfF1n3eSo
	 jOfN7yFcCZxKrIch/i1kHP834YdiLfoRoF3wnj7wJ09ecNRBCBuhVPoG+sSodqh/w/
	 JCuqvoIJ7jCOkh5kgl/A9M0E7lyhcUqHdyryaQIjkS0cfLUU/bNyeJ9ac2pX4fB0sm
	 YZAHm8NFmWWSJDUU8xXvuot8o6xDcCO4VoM08fOhqcg5/YeT8gnvZBjlLEYVKr4Shm
	 pSYtA/2EC/pJl1ezomF/o0w0vD2am+4wmDP7HtOb8ef5Y8t7FQnEWMXQ+BPvo5wf36
	 vhVJgeOUg3x/g==
Message-ID: <4806f76f-1fd3-4554-8656-86f4802785fc@kernel.org>
Date: Mon, 2 Nov 2026 10:07:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix softlockup in do_pages_stat() with huge
 page arrays
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qi Xi <xiqi5703@163.com>, linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Qiliang Yuan <odys.yuan@gmail.com>, linux-kernel@vger.kernel.org,
 wangkefeng.wang@huawei.com, sunnanyong@huawei.com, xiqi2@huawei.com
References: <20261031033330.3416326-1-xiqi5703@163.com>
 <76579248-64db-47bf-b8d0-4eb3ca556f5a@kernel.org>
 <20261031094253.d28f484e7e27de469cfa76d2@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261031094253.d28f484e7e27de469cfa76d2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BBA27A0004
X-Stat-Signature: wsrqs1tntybzrdsx6s1ga7fqct3x8jg7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793610471-846378
X-HE-Meta: U2FsdGVkX1+xKtO831qzCTaz7iZdSLEqKHZ5u3TMWEaxKwa7xPb8xG9TvnFm3bBtam/gAIg7Hs6gf496Is2QfX/MYHOQen7JFPlAMWAWeGrZ6rSo4Y8kKqMuyx+5UbGYJ8C59ePpZMcBYsTFGQOzeHCc9TFfm24NU/oorrJoI9KcYdBOcTiNdk4HPxMhXnOtcOoqTDQm8O2/Xx0DpMT5kPEpFypFX9v/zUl4cNHO+a2eYtNUhXOvft+yg9HMwc/E9yDV7BbyHKYkoODOpSczjZL38+cdIwaWSEjqZILUWiVHFyRMBqVb7PSNGLPEe09ARRl2/cFG8C7E3oTXGTKh3Ys79nTnMhw2opWEDaAxG4LVFz4sBkxMnDo5o9hkU+VHVsAt9ZNhDSHEzl6pZXRgK57C5OtskRUOCUJAwLVBRrPLPqeNj27nv61PhWhSihbnHNucxRutbxQ9JAjSWL35Mz2v9npZTvUqnmo92rykSmPhTaqN18/r4EInmhH8+XiIeUKIXhKTvwt6neI2uHBenkzhYVMD9K/txI+pX2JT0OQ/RypHBsqHvl6yN4XBjHML5hwqxLdVzVgsA+Nt8U3WvFahOoXPrtlLt6tvt09bU8A5qpW7jdoGlPT1ZcBRPCkdGaJw458zBBvNv+HRyoWSTaQE1rUxgxlntA+gsGl23jTzRw08hiPXDqkUMQxF2/UlUXn9dwtRE/gAz6TjBlLGs9pkoMufwO8mryS9sfHBuOR5Mpt/nsWTI3WS3iZwZDPKv1X2zy19sN+SQ6P0sW/hBCrzQdYpHuXr2OlABV8WeKe1W6yrz2YnGQhu9d3+0v8nKYDyb9radJzhe8pWgWDUxAYBK6aS0rQZKH8S2CmTay/Zy0LsMUB7sY0BK6BqBaX7rLXWH99dO4EoCK5xr0bMTmGxVq5C63qboA7+o/ySXJ6hr/wMazxZL3xzYU3Xu4tLAfz3AZfCary7qTZz7dv
 ErhV+P2L
 Co+PXCBHjyx4pWqqpREdtDEPz3QeBnOXnGFNiK9LYHvrryzccBygIai0SXVCL8Mg2QsUroTQr9YsxCxWh24Oy86bPHT2fLQoKMhEd8SjC9tdIMelVeYXH5WTLa+2owPRb0UofUsGTOjjo49ZEwOq7GC36KUBsg9uudesWFfeLLtskk+PbeDPd7A2r2kRcz3FYPX7GxT0+F0OUuHJtb0tWvt6x5dETHj7MYCNul+6wrft466re5K8e9mr1gzIQdBCYr3X0FyTpF8JdgDoUFvMhf2SUxWuGdjoiA0jDgos7Qs8TaYwxzezzXs3AwYzj2Iyr9ASQa491qDdVBFx6D9xon8ow3E4tf7PykRqpxB0p24jwwia5rLSwnnEh5GDxqXpyFgg631SxY50Yz+DuRZJJlhiWbE9VNG4/XsTwNJqHAmlM3A8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 17:42, Andrew Morton wrote:
> On Sat, 31 Oct 2026 11:52:30 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 10/31/26 04:33, Qi Xi wrote:
>>> From: Qi Xi <xiqi2@huawei.com>
>>>
>>> do_pages_stat() walks the user page array in 16-page chunks but never
>>> reschedules, so a huge nr_pages can hold a CPU past the watchdog
>>> threshold on non-preemptible kernels. Add cond_resched() to the loop so
>>> long move_pages() node-query calls yield periodically.
>>>
>>> With KASAN and function tracing enabled, a move_pages() node query
>>> (nodes == NULL) over 10 million page entries (~40GB) can trigger the
>>> softlockup on a PREEMPT_NONE kernel.
>>>
>>> Fixes: 80bba1290ab5 ("mm: no get_user/put_user while holding mmap_sem in do_pages_stat?")
>>> Signed-off-by: Qi Xi <xiqi2@huawei.com>
>>> ---
>>>  mm/migrate.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 7bdcdb57652f..6c2371020cc5 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -2545,6 +2545,7 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
>>>  
>>>  		chunk_offset += chunk_nr;
>>>  		nr_pages -= chunk_nr;
>>> +		cond_resched();
>>>  	}
>>>  	return nr_pages ? -EFAULT : 0;
>>>  }
>>
>> I though we wanted to stop throwing in cond_resched() at this point?
> 
> It's almost unneeded in current mainline kernels.  PREEMPT_NONE can
> still be selected by
> 
> 	All supported Alpha configurations
> 
> 	All supported Hexagon configurations
> 
> 	Non-ColdFire configurations (classic m68k)
> 
> However 99% of the world are on 5.x and 6.x kernels and many of those
> machines use PREEMPT_NONE.
> 
> 
> IOW, cond_resched() is not really needed in mainline, needed in
> -stable.

But where did the submitter reproduce this?

Why should we even care reading the above?

I'm all confused now.

-- 
Cheers,

David

