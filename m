Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53A5CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CED66B0005; Mon, 22 Jun 2026 10:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1801C6B00C1; Mon, 22 Jun 2026 10:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0475E6B00C2; Mon, 22 Jun 2026 10:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C43B6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:26:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEE431C3A92
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:26:11 +0000 (UTC)
X-FDA: 84907773342.05.1E69A0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BBD68180018
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:26:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z/9V9qZG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDAYJ+1Hj3rbE0Ol2Kisc3T9HkVrRB/qMnf4xfL3duM=;
	b=noz604+LTP7F9oW30zU/FHa1rslBEMMHW4xed9vo13QXE0K2gWMkiMeiWGZMAOlgsk+qh0
	6vwBvbfJPOXTDRWhFnl4VeTCPt1yVhrES+6S1VtrbkFUPqF0S2vbCkzLtqzIw1OB5skkLa
	YDOjUnLR8E5/3Rf3X0WF7ymKzEiN2iE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z/9V9qZG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138369;
	b=HHduS5bwx1t9GkRRzyUzPG0Ilho6UU4LcmcqkyrmvvmpbosRl11wdoJig7uSje4MNcwL8o
	i5QxkchdoqRUGGtzVT7LeqsJN0RAPfg93nMxItzsLT0AIplVBTs5wPAYxynolbHhkN5d+T
	w5LZmv5hkkS/l1LARJrf/biB7TUt2o0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5694441E5;
	Mon, 22 Jun 2026 14:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E41F1F00A3E;
	Mon, 22 Jun 2026 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138368;
	bh=TDAYJ+1Hj3rbE0Ol2Kisc3T9HkVrRB/qMnf4xfL3duM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z/9V9qZGS8MYYP6phtVfhfUZn5Mlky7EbgTe/Z1vGj6sBamOcbjeBadSZOEBaq7gO
	 J1NVdvUYpXFweVkh2FIA7mqhr65YO7wR+gL/igIt7tJ8D8Nj0tyFw2cL8R1i4Tt96D
	 5E1Ze/xYQSqXixsRMd46bjR724YpI+yfbAyPqe4ommDPhKoPjzHlmxT7eiJBHwOOYS
	 nl+fappsCvMw2odXEJwcNTcUHXIiLj/iRIfS00A0duYW3q87N0dZKZNKKdyIjzwL6m
	 1hELeuMrfbHYI2s9jAvgJvS2SVWBDB4KQFLEuewtOuAbz/7CXloIyVRbYeQ6sp7s4Z
	 9S4ftJWS8b+sA==
Message-ID: <ef5dd3a3-10c1-4a9c-8c84-cadc75528e5a@kernel.org>
Date: Mon, 22 Jun 2026 16:25:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
To: Gregory Price <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <aiaUDTeHDA45ZXFS@lucifer> <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
 <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
 <20260608163257-mutt-send-email-mst@kernel.org>
 <BD0C8760-BC10-4BF0-9EE3-9B0DAF0D977A@nvidia.com>
 <20260608170348-mutt-send-email-mst@kernel.org>
 <DD2E08E8-1FD7-43E3-A2C8-B4435D3773D1@nvidia.com>
 <afb14c99-162c-4c36-b1ef-fe971678f6b9@kernel.org>
 <aidCGkafm9yUDTuf@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aidCGkafm9yUDTuf@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBD68180018
X-Stat-Signature: i4psro7fhp59de645g6boi7omaowcbxg
X-Rspam-User: 
X-HE-Tag: 1782138369-204275
X-HE-Meta: U2FsdGVkX19uRUj+/wcy6JrMy4jY6jAVwRoin/IQlPUFypWjiOcVF1FNKeyL+79fNvTrIBPdcxQFmcuhhrrEuF6n4QOPOg/ytaAMOkd3B9qojrUssyhcmSnDS94G5D5VM0Q/QKR1PDfarAMWC3/9ZxpuzIltqJXm2ANf/TQ9dM0L/TVBhEF3hQLO0r0Qu4SnRD9uqRCUeDLw17ArWdsUqHYfDw2UojGQmzHhfNFwuKwZ8sZMggNP/26Vkkx04cLujT0YJnHxYuSaEPkb8lmv6h8pnoqvFprWX4jMa/ahE/1LMtDwRIHKP4ioZXUFxqwApV2N8t/ulUQs6tsf42kxFt7Izu1IV8BekXFqf4sHAu4Ux+7V7X7E46IXFBtQh8F3X9+6Ce2PbiLL2KDU9ORmlpLQEGvn/8lsiVLXsezJ2Z54A4prNfXF/3e5KqsjgRexDjmCFGB5ZW9ahTMImwxrRONQrTsnOwBkqiqhJU1eklQS3015VpchCTbOe0cQQAAjktQfRcbsep/w2mfKYzkxxJ4FlSOReo5s5E5ZJ9KVXHgnW9EfuTZDpx5j136H3seA9TBL7T4j3/Xs+kFxKrGKeWAovIxsLK/5kdJvT/2vqntLeMpkn/vlxtbOn5VwO/5QSzUwpu2UsSZf852kScIY7F1hpiSmxAnd9jgWMshzzZdOWv/jNPve6RiP6NkXP4Xm/WDuC8+nBYClPhLE/cT5VFDZJn9W+rXrDxT/SL0K/ckPq1WybHX4WKKEwm/zSCfhYDQ2N7vBofW/HvAECD1xkMbW8W8bnNp3H1FkbRaoxQxIowR1UfIhRso2S3ayXT8U0tJJWEyXkb/P42I06VZLAwFt3ih2F8f+FXb6j++csZBhbeVYZubM2L15UYCRiCbDyhowNkMzSydpMRoAHiqhMghz6WXmP0L/B4SOTYqdgE2K43HdD7A0PQ16eWUVaWCNUX7FE0zj8+ccrPgoV55
 cNKA8FnW
 oSVHEGH0M3indnsxvUmjaliz716d8beHR7E+dNK/SKml1cIZwBXjjSIknWbZR1cTgsEjTl+UF8pArRINstavlNDECEtUnbxi1mkSuSaQWgX6f2lctCPCahf8au/1aqBmTUAAZk8CyisDYYghj7vcnuHOKSWTFKB+8eDIS+7jvNmlaqSoltb2hyt4hEJ8hEcldn7MjHdXyu4aaNEr2OXjikI1iPO5n+Vyay0IHof79w3R5/Hut10pEhSY8BYyfLb4w4PKKqXMcoGNOd38H28A3AMgl8/XCP0NNGJfRWoJv8dGEW9jbMkAXSMHjEJ1yOZBGCibSgzT0WtujufVelD8Ookm4rW/hnR/lmpBPhU2Mvna2HrEBeaj+WxRWZSGBamnCxU9zGD1U7RqHMEgWxk1vhObxH6uCCdVg9VIlD9Lv1sg4y1mw0umT4YVgAlu+o+XxMTIBnb8avwFJYbTjWaFwhIfqTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 00:28, Gregory Price wrote:
> On Mon, Jun 08, 2026 at 11:51:47PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/8/26 23:16, Zi Yan wrote:
>>
>> There was Willy's comment in RFC v3 [1], which had 19 patches. Unfortunately, he
>> no longer followed up to my initial push back and Michael's question later [2].
>>
>> That would have probably been the right time to wait for more discussion.
>>
>> RFC v4 had 22 patches with little replies.
>> v5 had 28 patches with little replies.
>> v6 had 30 patches with no replies.
>> v7 had 31 patches with little replies.
>> v8 had 37 patches with no replies.
>>
>> [1] https://lore.kernel.org/lkml/aeu5P1bZW3yEH54t@casper.infradead.org/
>> [2] https://lore.kernel.org/lkml/20260426165330-mutt-send-email-mst@kernel.org/
>>
> 
> Hm, rewinding on this back to v3 here:

I'm late ...

> https://lore.kernel.org/lkml/016cc5e5-044c-46c6-a668-200f90a64d85@kernel.org/
> 
> You said:
> 
>   ```
>   Exactly, that's why I am saying that vma_alloc_folio() is the only
>   external interface people should be using with a user address.
>   ```
> 
> Going through the list of folio_zero_user references:
> 
> Called unconditionally if a folio is acquired:
>    fs/hugetlbfs/inode.c:   folio_zero_user(folio, addr);
>    mm/hugetlb.c:           folio_zero_user(folio, vmf->real_address);
>    mm/memfd.c:             folio_zero_user(folio, 0);
> 
> Called when user_alloc_needs_zeroing() and charging passes:
>    mm/huge_memory.c:       folio_zero_user(folio, addr);
>    mm/memory.c:            folio_zero_user(folio, vmf->address);
> 
> No one outside mm/ should know about this interface at all.

Exactly.

> Arguably none of these should know about this interface either.
> 
> The appropriate place for this logic appears to be:
>     vma_alloc_folio
>     alloc_hugetlb_folio
>     alloc_hugetlb_folio_reserve

Yes. And the hugetlb stuff should just be left alone for now. We don't encourage
new hugetlb features, and the same should apply to new optimizations that are
not straight forward.

> 
> The reason to sink it into the post_alloc_hook is to let the buddy
> decide whether the page actually needs to be zeroed (like the virtio
> situation) based on PG_zeroed or whatever.

It's a bit related to your private node work .... if we have an interface that
consumes an alloc_context, we could just forward the address easily.

Now, there are different ways of doing it, but having folio allocation sometimes
use GFP_ZERO and sometimes not is just nasty. It's all a big hack.

> 
> It seems like at a minimum moving the logic all the way into
> post_alloc_hook lets us actually delete folio_zero_user() as a published
> interface and move it entirely within page_alloc.c.
> 
> The catch is user_alloc_needs_zeroing() coming along with it.

Yes. And once there is only one user remaining, we could inline it and get rid
of this horrible helper :)

-- 
Cheers,

David

