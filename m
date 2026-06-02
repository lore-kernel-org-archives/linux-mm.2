Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 917AECD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24EA6B00A3; Tue,  2 Jun 2026 08:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5666B00AC; Tue,  2 Jun 2026 08:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB1E6B00B7; Tue,  2 Jun 2026 08:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0AC66B00A3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:47:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 635BB1A080E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:47:25 +0000 (UTC)
X-FDA: 84834948450.20.FE13BD6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7346C1C0007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:47:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjEO2iIk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780404443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUbKnFIvNRovA5Pj5Ujg3tyo5/9ilOMKehCU9gPd0Ao=;
	b=YePWs6CIkmHxJnMRyvFMWVmA40haefLineofJZyF2T9qO2cEoxLyJ5S7TJNBkBPsRb+3E4
	4uBTF/2YwkOQXtuWaYY/aUp64yFNUoGPu0LqzzRvjSXVJvnFMzlJc/EqzavMeqNb2a5/vZ
	Xz2VMEZNXZWGNERDsL/ml/wauqGkgc8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjEO2iIk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780404443;
	b=7nKxZp3aMBxnH3zao+pCrD7/Bd1XxFBLJC7r87IFXt8I5Xv+AzDCV6SB7rOqQqjnF4gEAS
	TuXAQxr6YDPJUFZz4ig4hRFiZHpQwUHyVzEFfv4lqrPoA2cTNohkiKoToEq+bviohdU7vA
	JScjFI8T5DjRlg6XZg5zMzyb1knwWXs=
Message-ID: <63797977-1c18-4885-8099-f5c21c80da39@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780404441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SUbKnFIvNRovA5Pj5Ujg3tyo5/9ilOMKehCU9gPd0Ao=;
	b=UjEO2iIkbjlGz3tnv2gwQ5b2SXnDpMqU+u3ltyp3GFfD9l2CEzudVlMAKbuSaMn8jDeYtI
	RIfEL93NgSsHKz44zWlMvUyenMydW6VrPmwfEVzW7DcUX+RTxDWPjrPcJMv28IBRd344F6
	nZXBO62tlcISx1VF65qSFfFQLsG5wrg=
Date: Tue, 2 Jun 2026 20:47:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: ljs@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev,
 qi.zheng@linux.dev, yosry.ahmed@linux.dev, ziy@nvidia.com,
 liam@infradead.org, usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org,
 ryncsn@gmail.com, zaslonko@linux.ibm.com, gor@linux.ibm.com,
 wangkefeng.wang@huawei.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260602043453.67597-1-lance.yang@linux.dev>
 <1dce1561-b42a-4322-a99f-89eba1e7c227@linux.dev>
 <716c7351-2641-4317-8675-e07a16a1efe2@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <716c7351-2641-4317-8675-e07a16a1efe2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7346C1C0007
X-Rspam-User: 
X-Stat-Signature: k4zcaz4nfkidcxce47ue6c18hco5eh5n
X-Rspamd-Server: rspam09
X-HE-Tag: 1780404443-818234
X-HE-Meta: U2FsdGVkX1/Eqp60N6ptoo83XOkdMxPzZ1xTvy+KlwUV4p7+1JM41IvpcisrWuvbj0vgm3qjxo7mNqEyZjWmkUv3CuslvSddOpJlawdFFuTbDl1R0+YuVIWmVwnHWNH1y0GDhsFR3J34R6Fie+AUA4IUCgHrtwSJz6/3W/MdkCe0fw0/jcomtOX5s1/DkWXbRF5kHZXOavguXB4vY3LGubVsESOGbpInTc18ykEwTzrmjdznf72OTtJFaMA153jz5J9ikVz5O+ieZjsEFJm+S8X2EnvHn73bR3GqFckFLxbcFQPmF2iCP+qH7ULwjr7PwcsxcX1YyGSgNTF5DlszHx5PWoQgusQZacq+79F+Pq9K4Y4J0LEaJO6K40ClFbS7G/b/bLa9k3v0lo9IZfVmLA9FghGLtlWfHpPh6ENXLw63vzWkXRBJnecHcvFfjHJIkMN2xruIO2An0Q2CqexHM74ftsZkp64OUYVSKegrxblT2AYbbZjdCVqi57R4qX8wCMnyPLPvN1NirVWAz+/8drYJQxtPFk23+Y/mjdXEW9wyehPw4f7hjcGqPb+OfVzxFXmU6DskEIsOg/0+VbVp2r8rXKJ6eKbRXHaIvnlI3TTnTQNfyt7Kyg4gj5YvtFl6F7624i6qV8iK0H6mPUTMaYPW6zsxpZR+dUXXgLHNTD6S01+R+VlRHIC0UAhffAKIZ9pXKSMe3lzKF70zMTFdmBXODbMK/jTW7Z8v2NIuDlhOCCu9ldru8+xqt68eSPchpV9ItwgXqu4ft5MCLGchMZP2TrOWT48b2Xci4/S2Gh/EFWm/HbRWEzr9XLuomwvs3RmcwNOuIqHPILHWEioATW92tCDgozY9caIxvc9K9hjOmDnJIyDUreCXs2G/hzhnwN7IJSalpJpn+4KSEWztKCoViI6OyivBN/y/pcfSl05WZo58KPtFTu68GRmPxSHs/eBlzigRhMzLnB9frt7
 bbKQEQyW
 Hp26tIh+SVipbf8JCoAl6I4oBO3cEcrsc/ixWqr2mPmxsBDXzPW9bsCE+VbX58QGPR3xHS3Olcf5GPvd0/Pn7dDd1TSAAEASmookki/pGFvu97DnYT6TAafVJquOi/g720DayBecoAiMzn+nHLnweb5pI5P/WgV2ZfXk6MyxOvTBzpI6pRD/mTvdomtgCta9PWi6ZwlOACoTKDtM7pTPenSD7VNBusUVcP5sY2UAkAm9Cy/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/2 20:11, David Hildenbrand (Arm) wrote:
> On 6/2/26 06:38, Lance Yang wrote:
>> Sorry, I missed Johannes in Cc ...
>>
>> On 2026/6/2 12:34, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> deferred_split_count() returns the raw list_lru count. When the per-memcg,
>>> per-node list is empty, that count is 0.
>>>
>>> That skips scanning, but it does not tell memcg reclaim that the shrinker
>>> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
>>> count callback reports SHRINK_EMPTY.
> 
> What's the effect of that? Would we consider it a fix that we'd want to backport?

Just a stale memcg shrinker bit :) I'd treat this patch as a small
cleanup.

Once the queue is empty, count_objects() returns 0. That skips the scan,
but shrink_slab_memcg() only clears the bit on SHRINK_EMPTY, not 0.

So memcg reclaim can keep calling the shrinker even though there is
nothing on that queue.

>>>
>>> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
>>> cleared once the queue has drained.
>>>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>    mm/huge_memory.c | 5 ++++-
>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 72f6caf0fec6..62d598290c3b 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool
>>> partially_mapped)
>>>    static unsigned long deferred_split_count(struct shrinker *shrink,
>>>            struct shrink_control *sc)
>>>    {
>>> -    return list_lru_shrink_count(&deferred_split_lru, sc);
>>> +    unsigned long count;
>>> +
>>> +    count = list_lru_shrink_count(&deferred_split_lru, sc);
>>> +    return count ?: SHRINK_EMPTY;
>>>    }
>>>      static bool thp_underused(struct folio *folio)
>>
> 
> This is against Johannes' work, right?

Yep, I noticed it there, but the behavior is older.

> If this is a fix, likely it would be fixing 87eaceb3faa5 ("mm: thp: make
> deferred split shrinker memcg aware"), right?

No missed reclaim, just some extra reclaim work :)

Cheers, Lance

