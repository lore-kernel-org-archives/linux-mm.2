Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A551CC43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 19:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7947D6B00B0; Fri, 26 Jun 2026 15:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744EE6B00B1; Fri, 26 Jun 2026 15:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6C36B00B2; Fri, 26 Jun 2026 15:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEBA6B00B0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:50:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9B0F1C3498
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:50:27 +0000 (UTC)
X-FDA: 84923105694.20.C672D1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1F8640007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:50:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NTtUQXvN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782503425;
	b=SNLMJt68PLxVuLl1IEaoDApYrSdMG1i4wmvIcLD1TT7KezIye0kau6IlXZMlA5eftFrh8s
	k3dnwNla30Mw2v0XW8Dcwy3LLBFN+6GkLv/46kQaXMxUn5jAFVOJMztsC9oOihLy3wDCWk
	e4gupjHMVFP42zEQRyMYHRFkeuVfOeA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782503425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+t6TSyTiAKLXeeEOFDCg8Jg8JM8h6Pi7hm6oO1fXx5k=;
	b=0MEWkQMqhj+ZZNkSwg2rxHnblRtykGCplSLotrNgyOEWtMau8VluPYnoC1vITf3CHAXccy
	Df4vTs55b0z6+M+LI2tZDZQccktbefYFgcsGPldsFk2LIv6CHHp9B7aWsivulo3UKDWvS3
	zdy4lrB6FUMeIie32J/Sbvs6lpbzNDg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NTtUQXvN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40A45600AA;
	Fri, 26 Jun 2026 19:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBF11F00A3A;
	Fri, 26 Jun 2026 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782503425;
	bh=+t6TSyTiAKLXeeEOFDCg8Jg8JM8h6Pi7hm6oO1fXx5k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NTtUQXvNaFQOhqaf/UXBVWk/qgdqvRJGRJ5OMmFK0PyEFVD0EjAckGe/PeB2YGYTG
	 gMLdSTptFE77czP2kttaaXC500/s9w2v5s/Tz9O5h6YfuqqvliR2Z3B9B7/H7LYsDB
	 rjknYXL073VAy+GQv1nZF7cmRWpzSaomG2OWMmrrqH13r45SFX6+yjAFKOT0GBGtvE
	 Mn8/vUXVtEDvs4OG1WwLh+QtLdH6R2eAjvBuA+SDIy7YznR7BKW3EizmqH6VN+MsxB
	 uxey41YMpJnvhKKyc8zjy45BNFj8ocAEVyyrFUWdoJ1l37rTWYq3qzubhJCLfNAH3S
	 ox6lS2KEQz/6g==
Message-ID: <f4c750fa-b665-4130-8dc2-3752a8d3f25e@kernel.org>
Date: Fri, 26 Jun 2026 21:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
 <20260611013644-mutt-send-email-mst@kernel.org>
 <1b5676ab-0dc5-ef33-9d79-a2bd6090a62d@huawei.com>
 <cbffabdc-42bf-4e67-9d2b-ace9a1e09f29@kernel.org>
 <984d9775-e17c-0231-b021-126b13a9aa42@huawei.com>
 <be1b20ed-5b75-46b8-b7be-3c9b029f016b@kernel.org>
 <d7e97bec-72bf-7d56-3811-6d9c41fefb35@huawei.com>
 <e4e123f3-ef32-417f-8369-ff944b6f358d@kernel.org>
 <438389f2-332d-2f70-cad4-784d7f54af9f@huawei.com>
 <ab84b317-fecc-4197-be2f-4b4aeba3f4e3@kernel.org>
 <20260616161353-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260616161353-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1F8640007
X-Rspam-User: 
X-Stat-Signature: n1eyyq66rokciqbdumihk4mzq359huu4
X-HE-Tag: 1782503425-15024
X-HE-Meta: U2FsdGVkX18Pm/ljcaM5qK3UCQpvgbO1pN/EgdJJ7CQ3lObFNI87x9pXAbgLj+IxQ0dh+NbvKOMKFeY5HuCun0jqEWqqXfaw+LK++u836cpqRePl6fUVIvYlTgSn47nMq3goDrLOFqSWpIpkioppENIEW3PfYdRdbgxAnZ5YbyE8FLaaz5+WxTEoSHz1h4XDt+JMIsSYnwEn4ThUmiSU77kAkICjD5i2igfWm0bmHav3ASKzT9EoDTBpmUTySlFxOeIiASZMcv65yYG36XbSjWh5eLcsRo8S85KIWUB0H7EyFvh+ErJCiTVVYPyv7FdUf9Vs9tBlI/OqeJp3WxyB5FfCkIz5e/K1Nk8wmICUXx82gYCGL1njGWXZuqVLDA9bI9Khx8LIca0Mxx57FVm37g93JbkjI8mAlGacLmSkPk8sTBAdk00QdzsjGQV+JgmheslshnZRYDiqgiG5bN7UCj9sgoeDqTC8uohrmS6AReD2UoIoNtLTpAgt9v8xe/QDK9my3afVgrDJYfsLSxcXsNjhr6O1OXo76tAd4Yd9btEq/x2jnVBAP/PBXauzRiBMA3ajBF9zHwBmhp1KWY2DxzGI9Oyj0qcqVbKCmxJTU3Ma1O46MT2VTn/u3z+jkVtMIA2oQKFZDDEuEznOqle08UrPmnaeOFhPvGAQX/TeHegiLYYGeI6f24+79MP6kYwh7pAGG24dp2FvFXSP5dpqoH1c5Dc7w+VKd8o0VLLeyGYzL5pj8u7OKAODBQPLhFkAkgi9vqqwQBfyvxy5T7wCrcVCYgNEz2L6eyPcAak5FdnGMKKTXhJA7Np9h0Q3vsdsH1mkt/x6bm0eW2uF80L94+00AuKh8DA9gK0Yk/XnaLllkBIwu/BJPZ6gLHMj4cX897eYBI6dPuT0+1HZB8CHSl4rzkWmbKxJNSwYCGgNC8eOMrKXKjNsvkOoW4KJTwhkXjitFhfmBfwDPjNNOCS
 HN6acCHi
 ezF/SB1GGKhRBiqG4sMwdKPy8jBhmR3J4UyQcNV65R+QZMfpsU45BpmlR1Qy8S00fpJh5Lvt8BxotH7i8GC7EVsS886dbePw9mi6Wff5uHB53x/6NMFzWiUb0EnTHYpT4UEL/ZpdCt90zp2Yy6AgJKpjkKvckwT8oWTGh+ZGzo8oMDl1X+0ujhvBw5UkZDlUNrXldvkNpKaJFNkE6WRVhoeg2rR+XHXzJaB+nIseJ+o/UJeMFqU+XATm0qK7sNoYbEgJbqj67cl4Yx/mrv5a0rb+v5pETohzVZziRN4WRRzx5Ta3w0ep6zEpZRLIDMcw6POm1PjyRgTvqzujHv9iHeTXWUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 23:35, Michael S. Tsirkin wrote:
> On Tue, Jun 16, 2026 at 02:18:57PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/16/26 13:40, Miaohe Lin wrote:
>>>
>>> I scanned the code and found rcu_read_unlock_special might be called in some cases.
>>> Some expensive ops, e.g. irq_work_queue_on, might be called in some corner cases.
>>> So the overhead of rcu read lock might be fluctuating.
>>
>> Right. Usually rcu_read_lock+unlock is supposed to be very lightweight, but that
>> might not be completely the case with that PREEMPT_RCU thingy ...
>>
>>>
>>>
>>> Sure. We can do that if needed.
>>>
>>>
>>> Right. hypervisor could make the issue easier to trigger...
>>>
>>>
>>> I think your proposal, although there are still some issues to be resolved, is
>>> nevertheless a good solution. We could also wait and see if anyone comes up with
>>> a better one.
>>
>> I wouldn't call it "good" ... it's the only thing I was easily able to come up
>> with :)
>>
>> The only alternative would be moving the hwpoison bit out of page->flags,
>> storing it in a sparse bitmap or sth. like that. It would be a bigger rework and
>> I am sure there are issues with that as well.
>>
>> -- 
>> Cheers,
>>
>> David
> 
> 
> I had a vague feeling using static keys should be possible somehow,
> but could not come up with anything robust.

I skimmed over it, but concluded that it's worse than what I envisioned. (e.g.,
two rcu read lock+unlock over consecutive updates).

It's also doesn't address the mf_mutex implications and the x86 thingies I
mentioned.

The rcu_is_watching() optimization is interesting, wonder though if that is
really relevant in practice.

I'll either take care of that myself or find someone that can work on this with
attention to all details.

-- 
Cheers,

David

