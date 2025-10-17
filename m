Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B497CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 10:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605EC8E007B; Fri, 17 Oct 2025 06:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6578E0016; Fri, 17 Oct 2025 06:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5198E007B; Fri, 17 Oct 2025 06:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 328838E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:25:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B71C61D8BE6
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:25:57 +0000 (UTC)
X-FDA: 84007225554.02.5C059EF
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id ADBFA20016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:25:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kkG5700c;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760696756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGhwijPMwyEwfmctPnZ8jN0o9Q6RvMEbft3ZkUnGkAE=;
	b=LG0DE884kxf1Ryu2uVfKiqWZ9FOUnQGyWVAfwrX/0+vPWQXLRy6LNUBbCTvbKIYKZ+wk0X
	bTk3tKoVK8rBa47OK7MJ8gykv3lz9WasqFjXMZ+V722qn9t2rw362F+3AZj/9TaZvtD78w
	aH6q8XqS3W8yGETWkjci4+T4au+RSMw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kkG5700c;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760696756; a=rsa-sha256;
	cv=none;
	b=2RT9t3uUuzZWQL0FI+ONB5p8ZHI5r4Y1kzyXvVRXYc/XfnV/pP31ysRinpMw9gbD/krBAX
	FCv7BdmkpO0bXShm9+7ow9tBw2rkqoySJQsXyXv8/awWEH6jJ4SLpIkrBgzBmO3Ew0uXSO
	u/VvuQKtxPQO2ks5urNXbUIw3LRs7rQ=
Message-ID: <3390d129-e540-42f0-aada-0c8b6fe96f26@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760696752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGhwijPMwyEwfmctPnZ8jN0o9Q6RvMEbft3ZkUnGkAE=;
	b=kkG5700cy0SYvdodYajjQExF+3CwG7ntqL1YH5oF1g3z3DTkrbMoJ2W4s3ftqCD5/IIxrs
	RPutPb0PloNzNxXk65HIHq+k/XH7eO/N+9m1iABDw4dZ7OWolx6Ca8ZPR+yju1fiAOT1N9
	aBkw0IApPDuYPaYjwtqvUn7tavkBxAc=
Date: Fri, 17 Oct 2025 18:25:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 6.12.y 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss
 when remapping zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
 David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Mariano Pache <npache@redhat.com>,
 Mathew Brost <matthew.brost@intel.com>, Peter Xu <peterx@redhat.com>,
 Rakie Kim <rakie.kim@sk.com>, Rik van Riel <riel@surriel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usamaarif642@gmail.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <2025101627-shortage-author-7f5b@gregkh>
 <20251017085106.16330-1-lance.yang@linux.dev>
 <121d5933-16d9-4eb5-b2b5-2edff9b36c16@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <121d5933-16d9-4eb5-b2b5-2edff9b36c16@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: orgo7haa5ndwgu66tp97w6wqyfek7ndz
X-Rspamd-Queue-Id: ADBFA20016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760696755-283326
X-HE-Meta: U2FsdGVkX194huhjfFstGjEYnlGHk7zu/xiKKlMmR4TKnKASWs+jEppXM8Ri6ZPqewmx2+hDfYNP70GU1+iGZTNstZok2vmu0LBI4aP4RH66ck2wyf0kf720kRH1b3rNH/avPF83wzsUSOw7E8b7ovLoUOSuXt8cD93goT0b68vGT3B/HzoI2VozEYsWVe0L4ZQuv+5+LW+074mIbafpLg5tiqj8OBEyGhugw/OEoVnBTG9Jo9J672W9koKSGQy50iaJwd8+hPOPz0bOmDLV6L9PZDm/yrJu/W54bd2QWtsaxqvgIti9jlVIoSxmFpYo1ww7FDFefcc+BLXqwmfHw9Pc4rvqx/IstWNHlTXfsItRw3IgAUKjuMqa+4zJ3TtqRjUUqeHDwb3cBEDbsOWzXgjOZYQcPIXovcj3ssj8VHk4bgRmux1jxXfMSqzKwR3+X1ONwvQGgmvlbNEGrFKLz8c7nBvA0TjJsv5mC0Ko0Lu7ipnVAp7hFP7D3us9iFVNFwHd9/+v8UiBMrCB8aHuzsvFLTtdKjzjc/dI+YAHigh86tMdBEgTQ3eSQwT+zCb5OOrlECH7JJcxksLxhRXoDVf+EaeW+Fg+/Ad77fVWJ5zqp5GL+10TWYWOYGoLHWfkmJF84XbIo152IWNQbXEGtpghbJtANDcBtShXLP5IHykGJjfDLokhcRItQ2PmHi2LBCrT9kYgbvHOtCvIbL8h3nluWm2yDxX8yEN6gWQl5VD6JX7YeYfaKikK4ULlKLwwoy0a+x4pyV6RcghXwR53/dpwvq0+8suNDPgKYb4+gJtqGzzLXrjoGy5Pua1QFjuZzKRFaFxyfmfHSF9tA5YcOMh7ubwgcwOeilZWrVRwM1tjnzL77cD27uia9EKlENJms1tVgOj0QYyfXlbTugLRSB/oRzVTatTX/GoIN1rWbqUA9lPvMAzND+ew6BhXnZ6+er9ZJzfD5KjSGiTVJAD
 VnqPuDxS
 k7TCYTMdPNMhyPxR2912kZvCvV4YKvpR08QTXJ+Ka0lzTJoE7geah9kZ8X3bKw2D7vXtXX4+0/63zBZSZMVXRUc9Ga1kIn7dJ1RvXPAyZjaQ507ADtuOJpK3CVgWsjiY9ypb9l0lTKxU+Q6EwpONILTFstCovkds2RcJElONn/u3kBN+oZUbh//Wl26t4/JwoHr0nWhSrPh//xoqN9+fwDthIW2TxsU8L8+r3M0HIwRybvtyxVKo7/k9sLub1sYiw8tL/QuatOn5FFUVTCkkv/MNMjSq90zSgn1s/wUqB+5OhYf7Sy8lqxeGCA5sAqf+7rkpoXFeNUD26Yyw0eNdL3myYy+uEu4vHOTKVtybNEpd/RwkWqGc78dxt3TCapFl2W3r2st5InRyUmmpRDR9SOPj+nxGPV2O1BnJzvbvu4KFu9gXTM8RGfmUd+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 17:52, Lorenzo Stoakes wrote:
> On Fri, Oct 17, 2025 at 04:51:06PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When splitting an mTHP and replacing a zero-filled subpage with the shared
>> zeropage, try_to_map_unused_to_zeropage() currently drops several
>> important PTE bits.
>>
>> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
>> incremental snapshots, losing the soft-dirty bit means modified pages are
>> missed, leading to inconsistent memory state after restore.
>>
>> As pointed out by David, the more critical uffd-wp bit is also dropped.
>> This breaks the userfaultfd write-protection mechanism, causing writes to
>> be silently missed by monitoring applications, which can lead to data
>> corruption.
>>
>> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
>> creating the new zeropage mapping to ensure they are correctly tracked.
>>
>> Link: https://lkml.kernel.org/r/20250930081040.80926-1-lance.yang@linux.dev
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Dev Jain <dev.jain@arm.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> You're missing my R-b...

Sorry, I missed it! I just cherry-picked the commit from
upstream and didn't notice ...

Hopefully Greg can add your Reviewed-by when applying.

