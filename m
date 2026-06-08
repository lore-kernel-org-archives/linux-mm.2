Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16AE0CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C786B0088; Mon,  8 Jun 2026 10:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415D16B008A; Mon,  8 Jun 2026 10:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6546B0092; Mon,  8 Jun 2026 10:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16B806B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:26:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2295A0165
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:26:33 +0000 (UTC)
X-FDA: 84856971066.20.A0ED797
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF248180006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:26:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/aPMn/0";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780928791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UgzbqLVSPQ1GsLg3LFXj2rh6qXfiCRcbALPchsZH4U=;
	b=RxPFoFCSGsdTKcopYK0agkxnsCf8uFSMEHIMXQ3O0AnU+g0ej7wm9hyyIpZaKMaE60wW1d
	E9HPalghgBco3rrn+13/m3mdrk9IFXSoF8s4fMoTB/bIet/6aMrP+G6Ea4O4GTm4IlF91M
	80+oK4Jsc3tyiN1iDVNvDtCZxJtzw78=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/aPMn/0";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780928791;
	b=mkzsUvYGEzHBCwD/GZMJu76p17Wf7gW/65MqjXLsktuModlDwjPITiUcrCSpyZA3S3RXFP
	6V61YnU7y5rUbpUlMIs4P56wCJ4L9aBr7Op1sqsxoht2NwrUhTnrBYA4VdieN64od/kA4X
	DFgOl9jY25AolDraRQPRjXm5NAgYAFc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFBDB417E3;
	Mon,  8 Jun 2026 14:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7DA1F00898;
	Mon,  8 Jun 2026 14:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780928790;
	bh=2UgzbqLVSPQ1GsLg3LFXj2rh6qXfiCRcbALPchsZH4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O/aPMn/0szpDnRUZ6htKUmFqMuwyz+qJOFRAgBJeatVt98DFhMfTFX9NzYi5Z3iUJ
	 6uYYNXnEsnABrmiS4mKXnaRRskoR+vD6FkbElAaiGT8tk33MLqFWokbHD8c6jwSgg5
	 TJJGC3UiCr9qVekDuB0O7FDp549p2Eiu/yxgeQJVDTHPHQ3ANuqatJLOIgWuYeHY6K
	 ykz3on2WUOgo8/WRMHfl64rBALwtmzdWKsTO1Qdgacexh6M3XE8gIvDDhQKQcfyObj
	 68Hx7hPcashCaT6tVPYXOhdyh1FccWgG2rU5xor9uhGmctl48BRIM59EMOpe6SAoPf
	 T3JG86u7OVLNA==
Message-ID: <d0ff6269-8b8a-4983-8569-d9a8495829f3@kernel.org>
Date: Mon, 8 Jun 2026 16:26:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
To: Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
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
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org> <aia-q026facbptoT@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aia-q026facbptoT@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BF248180006
X-Stat-Signature: jqwa5kjwzj93qe5qcy3gof5rkwpd1ji7
X-Rspam-User: 
X-HE-Tag: 1780928791-359196
X-HE-Meta: U2FsdGVkX1+uqiN2FAEEkjOR6L6o13NyavBEplJsJCD2x6cuBEuo3Jj1jHLROx7nHMq13KxgwOVeyKmJcGtxjOe236FZ75+bkDSfZD0wCH7heh8TNH8NZmgeVgDN4kFFbeGBPqGP0ZoO+qIJzyOjMpWCOeEFnV8e1fX25Z8/vhr+Uq1I8ledeFT9QmjdRR7xQi5wLENLaOEE7i7GONQ/K7Jfcq8R/XP2mVuHCw33qC0IVLNGv1yUw+r+vkjYE9GHE2kYq1SwKeD0xNYBwLpyD1/Dc+Sap9c2gVdnegy8B/8zenRhA9/Z2m+eB+/HnzM26sU8mv8uQz374ZD3rhbmhBPQjL+/MhfzBSDCGJxgZ/SGv3g58B8/DHjTgah7kFjvB9Nu5v9tbn84n5jMpcMS3r8Rrc9ZkvWRgXXFFYiaTiwqsSriFtsSb5qLcF8XyN2Wr980KcO73RmBW6cPs+92JN5onWCq6WXkLjHKo7K1NcMI3NAZ6kXu4wwchfrfIl40OO8a9FwWraKv2KAPD0H8ayccsHNhqnOY5QBEVG2Sqxu3uDixBS63tEchZksWB5Hw8yKSCg2D1975SJpW4CfFUk0hMzTrDUHnIOSpq/G0jkylbONpPjVAS5OIjQew7l1XRmA4vyeqzSQQp7YUtSiY+8iUlxLdD3+pvKz910xGxuor9IA0xen4DhSTspyQFczSDwlcS8cjs3K8TieNZphIBJ4FRSI10dlXUsVXYHzK2b1Dm2JybbrMlw16CRLpO7BrT+CXnk3RfjrSjb7mBDFRzQlqD164xMrrdtrgUREKqvoU0HaWeRwDnibMV44MFySe1JCk/w4HyIdZpTZlUDQsKuRS+b+7SD+fK8XoAB0A/0C/jHPG71y2ck2ip7T+qNXRkDYDKaYy4an58mI00dsc+aCsnpb0TiKqdiQMHY8kcvP4kPNf1EIF2+pUArh8KL/UIGPC6rGE4l/Ycd+57/C
 UfB1w1wv
 Iv2CyFNl0SZLYKp2tnnARfEdkH0cMY5hyemj7YP6pOqmq8O7alY3IUJqVMH6cgL0eLRuGtVDG2oHHlghVUM0CNc4cj1IakoyV2i+lefB3Qk5a3i3gaNa0atU/63InpkPuZgPTMOi5NQ9Kisszf9ONRTrVZUZ9DAcv07jdWzeBkpMxjbBWkPTP+0GmX+TZLqsIf31XLMQPilB28hirvVwo3ipxiGJ5HJmL3YYUrqZuiiDS1y6D/hZYzAc1tHkzmSFZ9C4OuHEZjR4gLByqj+INFEx8HXEED0vdiMRHk+1v4u6LIZYK+Oc32irFvcB/xppVB/2RwVE9Alunre/AOb54aprlZpUQb7NgWrqxXrkdaJxmbxenBOgeUw/PElOeC8mUErKQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 15:09, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 02:04:28PM +0100, Matthew Wilcox wrote:
>> On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
>>> But instead of overloading user_addr to indicate all kinds of things, instead
>>> make life easier by actually breaking things out.
>>>
>>> Like:
>>>
>>> enum alloc_context_type {
>>> 	KERNEL_ALLOCATION,
>>> 	USER_MAPPED_ALLOCATION,
>>> 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
>>> 	/* Perhaps some other states we want to encode? */
>>> };
>>>
>>> struct alloc_context {
>>> 	...
>>>
>>> 	enum alloc_context_type type;
>>> 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
>>>
>>> 	// Maybe something suggesting context or whether we init before in some
>>> 	// cases?
>>> };
>>
>> Ugh, please, no.  As I suggested last time I commented on this
>> trainwreck of a series, lift the zeroing functionality from
>> alloc_frozen_pages() into its callers.
> 
> I've not looked at the callers closely enough to see the delta on that, but if
> it avoids this mess then also worth looking at yes...

If that means that we would handle __GFP_ZERO consistently in the callers of
alloc_frozen_pages(), that would also do I guess. We'd still have to pass the
user address down to some degree, through folio interfaces only at least.

-- 
Cheers,

David

