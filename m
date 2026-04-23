Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4A7F99344
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 09:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4AF6B0005; Thu, 23 Apr 2026 05:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4747A6B008A; Thu, 23 Apr 2026 05:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362EA6B008C; Thu, 23 Apr 2026 05:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 235076B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:47:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A12EC120444
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:47:11 +0000 (UTC)
X-FDA: 84689342262.11.DEF8F2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E0507140012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:47:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sJWniS2o;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776937629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/64bTmffhLkNH7e5ixjjgfwdJdA09EUqCn5HtycnE0=;
	b=2XEfi+Lq5oGLPrLw5biURfUzaGjyGRDXh0AHV7HKwXyYi/FU3TFxmPqEWl0xC5Pq9Be3R3
	9HIf02k3FLVlAV8rRClAvosUpDelP7/wGZJor1KkiYGnW/DI7ns5TSdoFSUO1aMPqSC/M6
	xbriS4w2agK38s+6A1G8g9gDKFz1ja4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776937629; a=rsa-sha256;
	cv=none;
	b=8FA6gozrhfVnHPHAb8lsyQHCG8zLRH7PLgKgwdnPbVvhMy8nL6KNiLfeInDkQRqFyk7JlQ
	/0/d6WRJcCb/6TrsfJavbPIZuBV/ENmampiKDaiQdkk/ddypqtQXH9cuztkSvFh7n40FZe
	1gylInZkdZjOyzH8gatGTLrKG4kpb7I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sJWniS2o;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA60E60120;
	Thu, 23 Apr 2026 09:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECE1C2BCAF;
	Thu, 23 Apr 2026 09:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776937628;
	bh=1gG/tD8icbEhz/C6XUjdNu8513CmXACduy/IMdkfvDI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sJWniS2oH9fBwJkaEQXpdcQmmkCc1gSaRxtOj6utECaamX2LadShXpIrLmRIejpov
	 3WGWNpzmdIQJnSEyrs9LyOzRV9Oj4VXGrrZ1FK69U/k0WFdtKJP7+yigYmB0VTHRVV
	 qqHi9b3YkTALtu9gntOUDI5Hqx/+HMfmfUDRsT7RZlMkiRoIjcGfVRsrP2kmIpWOHy
	 8yb/f4WkRIqA9D0mNIv0Rlf0chdIFBqd1grADEIz2cVlDhPkKkVIGILf5b5H/zpqI7
	 KHppFUYdfPMuS2o7es2+wiqvKKdzelgQMOU8Oeh8sA5O5DhEGd+HBdEjiLoJSZOuRY
	 y7LX7v2oJuSJw==
Message-ID: <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
Date: Thu, 23 Apr 2026 11:46:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
To: Gregory Price <gourry@gourry.net>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, linux-fsdevel@vger.kernel.org
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f38kiw3cye8p8yyfmygrehmkepqq8rbk
X-Rspam-User: 
X-Rspamd-Queue-Id: E0507140012
X-Rspamd-Server: rspam05
X-HE-Tag: 1776937629-717741
X-HE-Meta: U2FsdGVkX1+xEoDCwnF1u9W5xFDV6VYcZwdFwIfUi4YMuDqYxocFfcGOCo/jz66O4TM1an5sp2bKlGCqBL2L8qKK7a2N+wSNDrvXWl3i71bjK56VUEhtMyLRhBWjnXu/iwmwUcdkAIrhdFmlV/tFI+2MFzg7wYII4U0OnvrKmTkPVYmGqTyp9bT3FId+SGQVm6GzXPi+xz3nFL6vRErWRS4xlim0zR1SL14v8CSnriAeiJgYhkypXLZeB9+CquqQS/j/bBFE1i4bO8AQP0s+eXZ/+uZp1OqsxeVI/dfd4q4oUkgApJhOQLIPbGbAJ5zFWstoxOAGIX6dare85IB1lA8r0vkxpqpW63/AisBpOHMwwfO+pnNOJlwWG5h3335xnCh2uRWxx30TjYiXiLbYTsLVEsAyDlQR1lrEOFV6Clsaem8vDa1353eXS3QvRFxs24FYwW9Idodu9UfRFEjRkuVP8/23kwv4lsGBuSVg0kqeyV2kw55s5VziROWGxhR9lGFp1ye346TMgiwLWOKYNNvhWMjpJoasZ1vL7Bb2sHAs4dJgDhXoq/45XaFo4/tatG3lJNCTRA30ivM61eE4Xj0Wmwtf+g9wyydMfjOcQJeDagTYihRHDpZkScsyfQHt7wbC8ssrQAoiPavFWC2fr7OPkA69ZJX42wYrbwGtKIo5XE2Fix++HqHLTJl+X/Uk+b4q6URBoH53ixvwaqwFE7fnAkGW20FUEaztoB1rWucApHgrcsHnByYlhqWZqG003tPTTv7lfPexNEapK+VF/d3xbvQtk11iWf4Osgl/PmFbYLP2BREUz3xqXgMhLTQklVCz9z+DgFAy0uEeI8n3S/CMToYOZDer8XlocCGI9uW2KZLnpPA/ahU7+r/KLXbmgI6Su9Hk/jtw3Ydz1x0f5tIp/U6U94BehRSSRUsC1kEGJ71c7NLPMH+77XaKmoCVTjWR3DznTw14BduyCNr
 T06w2Bi6
 1KpkscY+xD5fkjCBxgEUuw7Pauh9Xsz84tgjMZ9xiEsrroMeuG09XH+sfoNvycLnrHFtqvShDwd2xnLl5ul8haHmgLD74W60mVKBuIAIlj1BAHSX/dFAp+u4ATeA49bPXkMESu9q/g920OyIfsuzp2QfVvumKpbk9kPDag7n7igwf9q/sCR7yZ9kdLaNNbhofpnW2+aEV0oiyKqp4naEqFh0KT1UdoPJWJdJ0VM/4JWEm1bmzY24pPc+icnYuRlo6flOV84psmXTqFHvbqBF//4WPlPCbW+BL7q628svlM6cBaT5jaLvUh+BUIWfVRemXJs/4MmcRkgxtvfJHLMhBvmuJY8az/EBAXwBSVA6rEzX7/L70PYjrTDshaHET+oenObOt+3Z8n1ZCkfw3krW1w8XgBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 06:31, Gregory Price wrote:
> On Wed, Apr 22, 2026 at 05:20:27PM -0400, Michael S. Tsirkin wrote:
>> On Wed, Apr 22, 2026 at 03:47:07PM -0400, Gregory Price wrote:
>>>
>>> __alloc_user_pages(..., gfp_t gfp, user_addr)
>>
>> With a wrapper approach, looks like we'd need something like
>> __GFP_SKIP_ZERO so post_alloc_hook doesn't zero sequentially, then the
>> wrapper re-zeros with folio_zero_user().  But then the wrapper needs to
>> know whether the page was pre-zeroed (PG_zeroed), which is cleared by
>> post_alloc_hook before return.  So the information doesn't survive to
>> the wrapper.
>>
> 
> I was thinking more that internally you already have that information
> you need to know to skip the zeroing - and so the wrapper can just pass
> __GFP_ZERO and post_alloc_hook() would do the right thing regardless
> 
> Then on the way out, the new wrapper would take care of cacheline piece.
> 
> However, i explored this a bit - and while it saves some churn on the
> interface, it adds two paths into the buddy - and that increase in
> surface might not be worth it.
> 
> So I see the tradeoff here.  The churn is probably worth it.

In v2 I commented [1]

"
For example, instead of changing all callers of post_alloc_hook() to
pass USER_ADDR_NONE, can we make post_alloc_hook() a simple wrapper
around a variant that consumes an address.

So isn't there a way we can just keep the changes mostly to mm/page_alloc.c?
"

That should avoid most of the churn outside of page_alloc, no?

[1] https://lore.kernel.org/r/4bdc66f2-1469-4b91-9935-74c3d3ca0ed9@kernel.org

-- 
Cheers,

David

