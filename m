Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C03C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0131D6B00A4; Wed, 15 Jul 2026 09:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D576B00A6; Wed, 15 Jul 2026 09:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42D46B00A7; Wed, 15 Jul 2026 09:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1B856B00A6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:25:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC7A61201A1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:25:11 +0000 (UTC)
X-FDA: 84991082022.13.908D8DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00E69C0003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:25:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=di8FdZIo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yA5n4ZBJNYOM5XAvuYkUcIhS6+K7BY17vmNXNz94VaI=;
	b=QyddVjY+i2LKRzHe33Wu2WPa4u42RFV1lH9rXar8tS2+0KUB8xtenWftzHdH6o6eb2dUpf
	40IK0SMP1rXgBVln32yP6jzux11zltQ2YKJ0px9gK6u1D6cSbQoaH/EyqjFVzno2TwOdiZ
	pjoPI7KiX39bz1EZFEHumnxzDFlvvLM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=di8FdZIo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784121910;
	b=HGe+43bzQ9O9Pa2q/nlPDZl6CE5Gv4+wJqP29S4uzsIbwy/+QdYEfC9wZm5O3LO9+8o1fj
	HCMnKMERxuJFecTEr6RHk5mvf0UWxLkrip6eyr3My9zXLb8rM73nau+enlOyeGDQm+JCvu
	gvLPrGGef4H7XL53+vLyO1yG0v5BRIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 878E661383;
	Wed, 15 Jul 2026 13:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC271F00A3A;
	Wed, 15 Jul 2026 13:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784121909;
	bh=yA5n4ZBJNYOM5XAvuYkUcIhS6+K7BY17vmNXNz94VaI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=di8FdZIoTJt6u2WAfplVl+2S4T6ZFBhfdOjDO+HO0cbkAoER3Ja3UU+btPj0EQnNR
	 RsKFE7HTaP1azWs+SSqsoHhvp/cGnEWfcXNPe2XkAnpEWPp1y30LcQ1Jmu7kZKDvar
	 kCTgepdeBxkuukbQobU6z7pQGEy95Ib9PciiYA3l3Gylxd5XcTb6uzZAXTUGZbhSBJ
	 BNv/ZJQ24kwq9/fSDGbJRFgwNNIp6kT+qW4PrjSmdCqAI5/1eb+E0u7/Fy1vbpts1M
	 hnrsm8V3zozIRLOcim7MkFxQHswW5HTHRwHO2wZW2IFkrbGPHfGT+9HTnJpteX79df
	 iIZb4HKXi+7AA==
Message-ID: <ed4572f4-0074-45c5-993d-7b6533eddc31@kernel.org>
Date: Wed, 15 Jul 2026 15:25:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm/page_alloc: remove a couple of VM_BUG_ON()st
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-4-fc4d246f705d@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260715-spin-trylock-followup-v3-4-fc4d246f705d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00E69C0003
X-Stat-Signature: sasy4pc48ze7rn6mghz8gn4fa393dija
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784121909-237267
X-HE-Meta: U2FsdGVkX18Brb6k+DPYu2Pm+LutV+jo1i3UaCq1zcfzAnNthDNNT743n7jT9KoGCVxIfNRKF4EjqcqWtijhLIj7TR3m7WZk8idjTwdQnNb/8Guah2WhPY4kMZP4ThG6zYBzNTzQe180q8R3025yFoDFbBLarWeS3VWsi5QMVAQK5qNhBG31pXjnDX1C+anwujZsb1wMF+weWZHJx+PTVB0dUZq1MVj9dHAi2qCj5qezMC3bMhumiKVRkHmmm+QfiZp55E2P+zM6WGIk30KaRkhhHIRlPcGHnp/Jg68jH9HtWsHgJ8WJ8AadcpIayU/iP7fwmqGSLcV/hlv5YI91kK9zx1HlJ/nJOpfvdyG/GbskLJY91GAFrC1VMACadZdKU4UpFXRWzk8ts3GFdo9Ce+ipHgODp2qb+Sdz/XbKXkilj7+XHlZBAey8WTNRhZSkEiTl5iMshDyweoTbSsSlZrJhJUsrygVgZUcr9MgvqFSBT3zmf1oEKUICDjJ+mkTU4GDfRr38vthTDeyaFcP7+h+RmcRcfZn3Av/8G6VT533CafxPBfPQJ8FzGSf/1xEOi0hGcL/cpTBNbRA0MjY/tfS8CFRZX8AgnhRZaUWENiYAJGrx9TbAEZvFfmo83LWwRz6cpb89pQ6SNjhinmPysWp/h/+/1YOz5RPcvgEK3z6uhWUCeLJZXvjRdmc51FlFxd5/MJFnf6Nf+N4tRgzsNNdFSZSYyYN3zqRJTcsWoYtq+CkDYdyVHJPw+uWj3tXQ3U1n3N5okx18jW3dqd9rtotjMTpvO8UFsrLTqBae8455JOVyaHUj35McE9D7GlwM9NplOF20Sk4xHjCuM13/gS1CKaB6gL1hb1XRt8Z9kGnlNNcFT4qbZtQGCSq1me27Pa9qXd4TFad/p+VhLAA2cyTcKtpA/Pj5mPDX5Gu77TcI5tjIfK+ONGSuSTdg7EC7oMY2KD5Yr6o5+BZy5HF
 n5gATKti
 pvSr44iiL+jX4B8yOoyn5HC5TJzSJzEI7mSV9c6auAxx8WM97j8k6CzyGoCPqj3TS2XpE2tQBRmUW33mlaa8tSCyX4AnRC6Ijgc5ombyv6T1W5vQ8eFB/7SBlFUKTsVFCuZX/1WI74n43gny9563KvBmY+ZCt5oqeM3tJBMPegx2X7Rzxxzfay8d+QTEDVmk18rdgGlkaj7Pn7nvV34XrLSQF3GCy0H+GagKYq0Cvo7cp98Dq65wPrqKJyOJ4rOVrrY9ObbdtTaqXxUo3EfrW4aJN240myTuYn/OgG7LwCn8yXjxnfjnuLqTGkU9+ZO5hJ82Qrqsd+oP2r4kdW8vwTtvfQmD434BqBF34//SS2z2/KCBfEe+02l3/2zMSRoCIKr/z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subject has stray 't' at the end?

On 7/15/26 13:03, Brendan Jackman wrote:
> VM_BUG_ON() is out of favour and on the way to removal, since I recently
> touched alloc_pages_node_noprof() I am removing that invocation, and
> also removing the __folio_alloc_node_noprof() one for consistency. If
> this precondition is violated, the system will soon crash anyway.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com/
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/gfp.h | 1 -
>  mm/page_alloc.c     | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 4d57e9c0bf204..872bc53f32ec8 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -255,7 +255,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
>  static inline
>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
>  {
> -	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>  	warn_if_node_offline(nid, gfp);
>  
>  	return __folio_alloc_noprof(gfp, order, nid, NULL);

Well if you want more cleanups, I can see in iommu_alloc_pages_node_sz():


        /*
         * __folio_alloc_node() does not handle NUMA_NO_NODE like
         * alloc_pages_node() did.
         */
        if (nid == NUMA_NO_NODE)
                nid = numa_mem_id();

        folio = __folio_alloc_node(gfp | __GFP_ZERO, order, nid);

Should we introduce folio_alloc_node() and make __folio_alloc_node()
mm-internal, for consistency?

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 25a83a57aab66..4c6815f84adc6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5427,7 +5427,6 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
>  	if (nid == NUMA_NO_NODE)
>  		nid = numa_mem_id();
>  
> -	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>  	warn_if_node_offline(nid, gfp_mask);
>  
>  	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
> 


