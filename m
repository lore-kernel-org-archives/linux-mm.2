Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC21FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4E96B0005; Fri, 24 Apr 2026 14:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E796B008A; Fri, 24 Apr 2026 14:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30FD26B0092; Fri, 24 Apr 2026 14:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19D0D6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:41:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB20F1402C3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:41:22 +0000 (UTC)
X-FDA: 84694317204.01.9D81AE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0F5F820017
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:41:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H1GL4LOv;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777056081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1v4+tz/MURrcFFLvUMLQJyDpXKjzXUmuKZTRdsjfgo=;
	b=u/HMIxsYmuX6x3ok8pv4CGVHRU+OogHYtvhKsjjgqpYequOkI5mOt4h/6ngft7QnlaVYFY
	e4MqxgZG4mA3eTFtIWRIPffGp1D6W1KnifXggbUxJQvRWveTMX59kjcJgRRHWwL8LO/Dun
	mCjJZVG4RK+QKUg2kEQHzj3kZyPKD+I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H1GL4LOv;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777056081; a=rsa-sha256;
	cv=none;
	b=DOYqHkGOi2eAtODVRYlNrQD47MCS0T9rXvit0a3um43/LJtaQxqpi2foao9FXSe4qndz0P
	O5LCqC6NFX50ib+Sb4Jk5eQd3cl7Ulrd69lHMrUzcQ6m4hp9PsjxgjHDKvtrVrSJPI6PW0
	At//xxxFR5vX2S2sCwDtGKShKj1p6Zg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D884E417C3;
	Fri, 24 Apr 2026 18:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64FAC19425;
	Fri, 24 Apr 2026 18:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777056079;
	bh=9jgbGCX0l+tXGMYoVmmEhiQ7PQwAhpR9IpbImTMmYOs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H1GL4LOv0emm/Qo6Jesr/Kn2+YFm43Q8HoR7nNTAjDkG03z4fkFcQ26VTmL5v6upR
	 zzQ6h+/YO5TI4K8O6iwq38s4mA8zC7Hi+N1cO1c6XJjwqjqEGG2Zu2VjJyMtfMDfJV
	 tXrGHnW06/Yj8/LK8vSed5PDjJTiUIC0LeD01SfauY+FwPmrZBU9B74gEoaP6274ws
	 RVaxsAGL1h0I/RgS82JpkJ3rU7R5j1fhl7VTNpHnoBSNfw94JAh3j6jW5Ie+GbE3fQ
	 psTMdwQL67PF7IAnbkmSFQmqA52EG8Mp8e97tiGxq8XxD8BvZbwi+WYbvHcQG+iFuZ
	 haxyIMbJhJAjQ==
Message-ID: <461fdb0d-4e00-4134-9130-120400b07b39@kernel.org>
Date: Fri, 24 Apr 2026 20:41:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
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
References: <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
 <20260423104120-mutt-send-email-mst@kernel.org>
 <1ab6e58f-d984-4bae-a343-1b0d3c973ad0@kernel.org>
 <20260423121222-mutt-send-email-mst@kernel.org>
 <4e12d67b-60e3-4bf5-a229-43c0d2c62cfb@kernel.org>
 <20260424143541-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424143541-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F5F820017
X-Stat-Signature: cgjf9fz4hd3b3ry9pnrweoofi3uhkpcb
X-HE-Tag: 1777056080-294932
X-HE-Meta: U2FsdGVkX1+q28iC8e+qsnSvHa1NINyC11V0an9RPrk8L3ru//Kv3D4zfYi5QN6yKO1shicjDrAsM9whl9fu/TCih3KTFI7G7QRUD/PM29T5MbGOSV1Cy7Pk8H7nM9kcS91KMrpcwBFM9JNuZUiqXdDJGuuXnhrnX/picNutytfjHA9drJ2WTUFjjJSU3Qj9Aow11dpeev7kfR54xvFB2iyRSiyd1h/XqcR+LhF/UhmhIRU3lzOijoqd0cuVPbGH4AyZ/9o4K8NNJcjgys/Se9EJ6WBT9zlZDhxymkUPUZ7IpmTuwsQV8ucUD8zsMclV7gRuaqK3cMzCZe0pZ7pLBaexUjZC1Q2st/AI9xa7Mek7yzeXht/lzcC+s43G4IQDHSLLdJNszdiHbTC9FLt22DhzLO19qF+s2JoYWs3jaq5tRxgMGZmDSKG2hLnuMFyn9ty48TYYUT0Wd587yUbhSugexKbNrSEGk9gWBLgAr1WvBWcjLEqR6Eo3wsRHbTWON8JjdFbQ5ChrX/v53/HLznQbmrFDu8SSyeivjV3iP6FBxwC/kHlLe/mFk/RmCw9D7Utl2f0cw/OBtSpBfo4oPfMvZW3/Qzd4CrmsNYBP6CAu3VvcQPFVbgac3RzjsOCdkYDHS8XDLouqy87K0T2mSbvnHWbJu3p5huCCb1gBCYSB/O8Gy+oHpuy4ZAKXzwutvTATkG+2o+ywO/ngS8AFY+F/NrO2gOj8Wb6bLucNRTp7mhzwAEIc1Is+JBiHlQb1OgDXoMVwbVswp8LnGfdhXKOcnEIkOVxkD8yYxtUaceRaF29NScBOfChDxkIKmBbPFTSETI6fsuB65dnzfmq7nrkHZzWMikeq20+Qe3rZgNGmXWD8KxLfxEoSVtbv8jQv6ZX8mTC1YrySLbx1yY/wrUQxBgnFqSMc3FNkOjNPHgSz654AvhCB7hSrgoF6fdCDYJi6NXrvabe7A3rSLvS
 roa6pRGp
 b1Z1TtpP80WrR9A87enzWzTdsQMN3ohzb0VI0rbkcaM7e5fqQ2kN+kSZJ3f/Quk3hEa0lL2G0ssDGVSVu5IEoeCg10uimTqPQP5JUwhgGcsWHQ6MDnHKub1QF9iMqzCyekxY+TQK3uM+UxZd9MFDyqbvRJfWox5alQycUUBgYD2zkjlMVPduv6FDSKybtNkrkhnB9Ewa6zSMRVY02Zsig0zdS1fyqaBl/XdUb/hExg195ER75Q74kWY2dIH4UBjJY/pt8LqugsNzGsOZgV9jCc5nnZKSEAopqh/eAkdFijqbmFT3OpyaDmBMBGJfykyZYWVjrpORUGLQO8mp0PTcJRjQW7sWLuNHAktfl7aWdfCr7i4i7w1WGbhEyMT0ExZLqYAeo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 20:36, Michael S. Tsirkin wrote:
> On Fri, Apr 24, 2026 at 08:33:45PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/23/26 18:13, Michael S. Tsirkin wrote:
>>>
>>>
>>> You mean, that it stays because of the reserved pool?
>>
>> I meant, that if we are running with init_on_free or init_on_alloc, that we end
>> up double-zeroing right now upstream. So nobody cared to optimize that part so far.
> 
> on the aliasing arches you mean? that double zeroing?

Essentially where user_alloc_needs_zeroing() would have told you that there is
no need to call folio_zero_user().

-- 
Cheers,

David

