Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7835AC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231456B00D5; Wed, 15 Jul 2026 09:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208CA6B00D7; Wed, 15 Jul 2026 09:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8CC6B00D8; Wed, 15 Jul 2026 09:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF1056B00D5
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:56:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65B3D1401B4
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:56:49 +0000 (UTC)
X-FDA: 84991161738.10.DB32442
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 94D248000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:56:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cw4boTms;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784123807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbKgz7rXvprr13EIVZgf2t4q5XUn8QXsE1MwfnSlNlg=;
	b=3TvQPwSkKMN36R/t4pHNDvAYBmq/izm5I2KlOxCJcyU1GWkb5d2MTY52iaJC7HWFk3viu/
	wtIhjLtAiUZBRc+nwxnNZMS7AzuvefHUJ1ndt0ZOJUd7xBWdhD2DuZGqox4ZQdsQxHzZ4f
	gf7LL0wDOc9JTrQR4MW8/Y3QRamxi5o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cw4boTms;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784123807;
	b=Uo/UURuDi/BF/sXznmjhV0lJKoTaDhvUV0O1xxq98f5gHvHoru1xrF+v5sQ888fElnta4x
	Jmuq6Dm5OzEE+FeJehKYYpy0EbsgeiAC8rkVgD1K/ncTYl/SYEeoLsaZRbHeeh/mmXpmL6
	elybUsQV5zyGf1CindMxpHQp5OrDlWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87DCF40B48;
	Wed, 15 Jul 2026 13:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BE71F000E9;
	Wed, 15 Jul 2026 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784123806;
	bh=cbKgz7rXvprr13EIVZgf2t4q5XUn8QXsE1MwfnSlNlg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cw4boTmsvRJ5HsdR3DL8TP4eNURF9azj/01YdTbCQ00SSClYjC0ktaTG32yicWS8i
	 rEu9JU2Sv1NQg32x3uG+1oDLYIkJDcLZK0LN8ChV02saljmpG4kvvVTdWZuE2MLTc5
	 NJzMCUYg2OSTzA/Fvxe9UGIFdrcJeS4majmQ5zu5rw5MW679fIGZXWL5lcUSXKwRa/
	 oM9wOaGYdKYK0+p6CJfaqB1AHcjU4DRyK8wwqd61pfOeYaZJ9vrhjU2F2+wGWhsT26
	 Os7yzQ1+ihsCKMlNuxOVXEtdLFs+U4bf9EVaa4MWk7+7j8Bawt2CJYQwxDrCJnSV3f
	 3DPRqIRjtR0KA==
Message-ID: <fa67d62e-41bb-4d78-83d1-18461542aff1@kernel.org>
Date: Wed, 15 Jul 2026 15:56:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm/page_alloc: remove a couple of VM_BUG_ON()st
Content-Language: en-US
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>,
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
 <ed4572f4-0074-45c5-993d-7b6533eddc31@kernel.org>
 <DJZ6XH7C3377.1D6EIFUEK2656@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DJZ6XH7C3377.1D6EIFUEK2656@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 94D248000A
X-Stat-Signature: 7roc9x9836bwdyiib9i9cm5nq6ccdumb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784123807-166313
X-HE-Meta: U2FsdGVkX186zmQUyuODtO2Nw5EDcwDgpmFSmLiXzfIlfeMk1nY1HCfTTaWQ1TzuD+WvBJOWjxEbHxYIt9r8gRFs6GvABfShNaZjcArOR7R0ww2TEwzATyO0doOARmHJHwLhoysRBaukua2KBlsUDgVBFQLRiTRA7jI+VLs8WoRTWMBdx4ck5/iGBVYQAUe/DOR5V+Cd8FxWdP6LwPvQh679IgPp24yb5VcLkoUiMHod/3MZ5fLqc2x0wmMithFIXBdGxB3WDuQmNZIC2crNCvr0l6nY8de5KhzXvhF2mJjsCWG2nF+JBA2EIWYyvJ0i+BNdwAdjkGY2+j6ebc7GZ7rk+OQJWimSE8eyHhkMthoISSeDRuWiidvmM8tL1P78Vwfvk1fhTN7FiY3zkz7/V0j018SGTCDEPVJcPaWogt0CxaT0ClFQK+vepYAWeUMyyQ5bkrJAG9fi0TCiQ+gfzyXHadDWuI77eBQJEn005FmsI+VWy77HYf/uMY68mePbOsZu0d8fPPpRS3U/1GesA2wk1n0upDrcJ1vjZER7LPIqSP9t5pBQubsIdzYAleAVYwtWwwbnIKeSAfzAlHGWstWRpVOspxHHqE/wlonizfZpAj+RnM7mgyAZ+2clI+m3v36nxWTQx1bLVJ4w26hg44sSduDnJymzoMpy5mrIM0sIPoFZNPWY6EkfNCh5J9qPpW04i9DLi8lkZUGMwtSW+AvHa3aXzGcpj6gpksl5S5wTTZDXj9e9IVPGauVyvRSU4uQBCQIQ6/nLsADROnKTcduRsw7qTVWKmCJik+zlmibabUBhH6HbAGNChWju4BvMHBVt0Ec/HH+G+fUc4IBBU51i/CRSSa+hZV3K00C7hyUiqCy9ghH9Hsbw0IM51+1P2GrN3ddZZVFkPeLEywESsQ0L3JG1b2t+XiOE914CGcYwfBznNq6dIFhT74s4vZeDeyMxl945VFXTvkby9do
 bs+P30D/
 GmXHbAYuGrrCyvsyVmWE8kREBbqsTL5YAQ1hhL2BbBx68tIh+OSD6tnMOWsNNhc8YdvE1kSG7yhZ8v8JzXh3gD98Kwzn4RDKtSl6zBCt/vywRlt+pJ9WBPbNiPXxZ/lx3/YIF4hhqhxXd64AsIaqLn5JRRbaUYc9TaQdxFU8yTBm/oERZ5cpmk6c+tJRYUkxx6fOuWtNi/cXAX+spyQJbk+eaE2t1YzwYVGYutAdZ3ywCVb+PKxzd3I1bleQ0WHsQaUxP1Ei4zU9Rhh0ATJzKQB1VDOLnPk9tKCmrJwpjmbq3SD0xSVgFY3A7jn2F0ciJS3I929E3etLuixkK9lKxq14GRIx28SxDajrhEqalkGQqGzoYTaG5b1b2Ny2S2FAQT75i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 15:48, Brendan Jackman wrote:
> On Wed Jul 15, 2026 at 1:25 PM UTC, Vlastimil Babka (SUSE) wrote:
>> Subject has stray 't' at the end?
> 
> Thanks - will fix if we do a v3 (otherwise Andrew, please can you amend
> when you apply it?)
> 
>> On 7/15/26 13:03, Brendan Jackman wrote:
>>> VM_BUG_ON() is out of favour and on the way to removal, since I recently
>>> touched alloc_pages_node_noprof() I am removing that invocation, and
>>> also removing the __folio_alloc_node_noprof() one for consistency. If
>>> this precondition is violated, the system will soon crash anyway.
>>> 
>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>> Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com/
>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>
>>> ---
>>>  include/linux/gfp.h | 1 -
>>>  mm/page_alloc.c     | 1 -
>>>  2 files changed, 2 deletions(-)
>>> 
>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>> index 4d57e9c0bf204..872bc53f32ec8 100644
>>> --- a/include/linux/gfp.h
>>> +++ b/include/linux/gfp.h
>>> @@ -255,7 +255,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
>>>  static inline
>>>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
>>>  {
>>> -	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>>>  	warn_if_node_offline(nid, gfp);
>>>  
>>>  	return __folio_alloc_noprof(gfp, order, nid, NULL);
>>
>> Well if you want more cleanups, I can see in iommu_alloc_pages_node_sz():
>>
>>
>>         /*
>>          * __folio_alloc_node() does not handle NUMA_NO_NODE like
>>          * alloc_pages_node() did.
>>          */
>>         if (nid == NUMA_NO_NODE)
>>                 nid = numa_mem_id();
>>
>>         folio = __folio_alloc_node(gfp | __GFP_ZERO, order, nid);
>>
>> Should we introduce folio_alloc_node() and make __folio_alloc_node()
>> mm-internal, for consistency?
> 
> Ha, I literally just wrote that patch. I'm planning to do it as yet
> another series as there's a little dance needed to get it all into

Cool!

> shape. But, also happy to just expand this one if you prefer.

Not necessary, another series is fine.

> Then I'm gonna add alloc_flags to the __ variant so filemap.c can set
> ALLOC_UNMAPPED for AS_NO_DIRECT_MAP.

Great!

