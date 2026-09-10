Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F6AC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552B76B008A; Thu, 10 Sep 2026 10:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5035B6B0099; Thu, 10 Sep 2026 10:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419506B009B; Thu, 10 Sep 2026 10:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23C576B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:15:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69DA7C04E9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:15:10 +0000 (UTC)
X-FDA: 85198049580.30.BA17745
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB16B1C0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:15:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OykTcqL4;
	spf=pass (imf21.hostedemail.com: domain of chao@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049708;
	b=UjbuXgUZE7ZNumuwspdphI64WwzxENycNowQvWWcKOvxNxjoDILwdpUUOilh4D5RDCo13q
	Ln1iiUSN8xHbyuCbyh97VqA741y9AqOBujn2IUNBQYPXTCfZlDzrikzwwdCE7BYY5lKN9e
	mnHBeIlz6gUTtUt6gy7cw2p9HpmDbxc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OykTcqL4;
	spf=pass (imf21.hostedemail.com: domain of chao@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TiUw/s/a5THXpKNutlCo5ceA78d7FKvTZXpt6nB2WDM=;
	b=VetU5haKxMFE4Kh+Ek8OFlBkCIVyDS/4Za7dt0OZasnO7MDdQYZGlKE0Q7Zv/XBDxR18dW
	qgZDWqixm/IIN5bQ9qJF39JwBkRck6N6R+qqX+HrbAvh3pRfqiZZlHrKXKyx1vtTN6eluV
	vrlYEASrJq2WlWRb5mKXti8N/FuG2B0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1A9741273;
	Thu, 10 Sep 2026 14:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988CA1F000FF;
	Thu, 10 Sep 2026 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049707;
	bh=TiUw/s/a5THXpKNutlCo5ceA78d7FKvTZXpt6nB2WDM=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=OykTcqL4d2iurhxpPxK93+PH89vvmNx5+3i+Q3z2sh5S25z14NIvXJG9W0cxefFjA
	 NmdwFLDikwh5MJCPIv9VI/ggKb1BrDTx4edHuAPTPyD8Pf9nhxSKUIcZEYnu2/bB9c
	 tRwlUkkyUztPw4tcAs4jFtjpsovBvrl0O+CH67EU3UOHsYKl8HDzp9kkFxMV4Ilva4
	 M9pnRXd4809xytxNbcxwjvvr1OWn2Hims1vx/XUqQeh9IPXkv0wBDLWvZjkY9KPcNC
	 dM5x5RPEv2qsdMQjViayhqn7jHRNwFkeJJPq+llZWG/ws0Ud/sfUVstxoEBZ1S7bWe
	 zVs62TqX/jFdw==
Message-ID: <894da5cc-7bc4-4b0f-9d6d-ae80a169616d@kernel.org>
Date: Thu, 10 Sep 2026 22:15:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <7e11c56d-05e6-48f0-b5b8-b4a0e18ddc1d@kernel.org>
 <520b6aca-b515-4720-977f-1adb484f2e08@kernel.org>
 <d700c4ea-b54e-4195-b124-3c89177ee49e@kernel.org>
 <18ab9827-9e10-4360-a1d0-3b25d86a71a9@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <18ab9827-9e10-4360-a1d0-3b25d86a71a9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB16B1C0006
X-Rspam-User: 
X-Stat-Signature: 3xzrbwxbt4cyqnr9x7ygkwbjerwdbyyo
X-HE-Tag: 1789049708-908431
X-HE-Meta: U2FsdGVkX1/Ad5AITDAYIOXU/eDFjFldwxhUcWZQl3PPea9cZsIPPmBdEgUijPoRPBVFTd3n5bgWSee7EzGKotrZzVbjoclxvE7wEWQB7+Vs1rEhgoP/I+FnUHGhJ+V0H7Q9W1fk6fHv5HUZusJLSECPIBHVEsyzs09+USgU98Tdml4if+WbUA6Kp4rbiBB4CvQvMIcUlLpXcceG3V7rpxZMNFoLMoehtT+xHjq9VeTlL9N+RzPRrY3VLR0eCz5U3qt+CbzR+D0b9zxm74irE1bEcKxHQ6i9vzLUEbdFlCt95thv9vu8RC/G1qV3zf/5hnoP5udrCgmvmIyCAVp+KWyOIIbASom2eQ6M0sMeUky+F4hV7tnZQ690j1fZkeDV62p1Ozd1FV3j0JkqI02AafQf2/QE8+7ImifVHQp+rkT2JwitMnvNOwvH6+4ixDyfkA0HQgk/mE18wiKT6KJpdY4eIPJlRu3vmHLYonq6w5Kj+4zBMUC1ld5Lwo6hgN/1pa+UDgI3vM9zznvEnukYYs/RDOpHBKJIQQHRbcOGJWAjNTLckIfR19GfcWRWJlzFkkMtEsTfVhR4eZCSky4da7VO0NqUzeIRhwmQG3AI4O4CjKPcgilQsiOfPXMrq+QM6NoYNQX3Nz7JoU76xNxVze+P5AnOYeDKx7yMl17Mjoht8b7M1VS8S6qCuAW/gcb86UXUxO6sZiPnYbvVZ17OS+DOoY+vP3YkoSeqBQoZMRIs2O5PcCCUns3ElBA9FFoTpENo+Blk6YFpeK2Y46BOAnLAwnjOeuh9rh1ihfAe6vbJaLx5qGiT3NV1pNPY1wlnrwRvhnODc6iF/mMVUlF3d8Btnwa8gpi8+JoiCfuEqcRZ9VwgMfpqv+qHriujACfG0OlBNQKG1WAyA0c6iwQ37nmXjZUYm5+Darb7tQ2ybpQfQoyT0rScxfbi5xfNwR+fKmOjvdNsha0ctjd4usf
 pt923nZ0
 CoEraWoLuhLj571XB49eJRpaKY4WEWosFB/EncWz1AmB2sk+T9Cf5kUFshFLu1DvRMZIMNtXHd+OrqYDK6caXj+0RAFZrl8E4OMef1r/nT2v8K3D95zs+LW70AE2nnQ5gHxTq7zNmIGJ/x2+wSzQ63OygsvFtokoNFCHBZ6qvTfrX1x9zTIEOOQfP8at7nqcqXitvqTObO34y/+YeSciHjk/1QN24FD+zUZa4Hedbw8SKdqmL7Zq/5RcFK0gBChEljxOTYae3s2yq1RNkBKWjJ+nLKH4Igjfrue+S9LoKZElwaj+cfsMoEXS7J+UlpJGKotq96BLEJ3nCZk4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 17:15, David Hildenbrand (Arm) wrote:
> On 9/10/26 10:43, Chao Yu wrote:
>> On 9/10/26 15:34, David Hildenbrand (Arm) wrote:
>>> On 9/10/26 04:41, Chao Yu wrote:
>>>>
>>>> David,
>>>>
>>>> Thanks for the patch, at a glance, it seems fine, can you please send
>>>> a formal patch? then we can apply to dev-test for test.
>>>
>>> I'm hoping Zi will drag that along as part of this patch set. Is this fine or do
>>
>> Oh, I see.
>>
>>> you want it sent as a complete standalone patch (will make merging Zi's series
>>> slightly more complicated :) ).
>>
>> I think sending as a separated patch based on Zi Yan's patch is fine, since the
>> purpose of this patch is a little different from Zi's one.
> 
> I'd prefer this patch over of Zi's patch.
> 
>>
>> Note that: ("f2fs: stop using PG_private") has been merged in
>> https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/log/?h=dev-test
> That just a testing branch, right?

Yes, if necessary we can append the new patch based on this branch. :)

Thanks,


