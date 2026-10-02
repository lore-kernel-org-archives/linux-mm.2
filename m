Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB87CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10786B008A; Fri,  2 Oct 2026 10:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFDDD6B008C; Fri,  2 Oct 2026 10:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50866B0092; Fri,  2 Oct 2026 10:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB6B6B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:15:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDCA9140725
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:15:49 +0000 (UTC)
X-FDA: 85277884818.25.75A59AA
Received: from mta1.migadu.com (out-97.mta1.migadu.com [95.215.58.97])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62A92140008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:15:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GFGvfIfy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790950547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmK6NEcF9WciGWjR9HjodE0tkUNqQCf+82tMTSKPOzA=;
	b=gpanY4jYwiJNWRHdAzHUSw7top3/oa4LSZ75zWsFy1w0OCnJex5Z4Dk6tYxTwGXQzsdPiu
	EgXo+VLPM2l7J02SUVuQfy2PvXqOURzJ1wCf/Jiq5n9MamR/x756pn0uADGxBtr3I3r1gZ
	DiJGHtQfEunPagUXDQkTeiP3nyKnt4o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GFGvfIfy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790950547;
	b=TEzddwuvwNSp84+y0RcTRql1/pnhTyA+YWVO7UujfeIaTAKn+3env4tSuCatJAJjrjlZD3
	evYAjx8BAbg7JEf34yYkx0WfZlOGNPVAQOElGxvJFWyAx/ARBH7FLKH10+jJhKVFL9DzRx
	cPGmvZBrEC2QKN0HIGkBAuHMvt7cv6E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GoZ23+ZT4mQGNUcJbwzUPAqDWvOWW3sI/LyHl8Zbpp0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790950545; v=1; x=1791555345;
 b=GFGvfIfyoaTkFjVdl6USK3ZVVJqBL5o4IndYLuD0fTs8E7CoekuLUV2ieqUZ07w5j+coE3xJ
 NKG0drsro4+JvkRxivXw3L061IU7BhFypDNVQ4HeHzDy7BYc5EC9AyAZ1vEIPo8GyYS/NO1unUR
 14fQYHHyHY644WxMUhXR5BVM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ae4e3d5f1d27fd0b;
	Fri, 02 Oct 2026 14:15:45 +0000
X-Mizu-Trace-ID: ae4e3d5f1d27fd0b
X-Migadu-Flow: FLOW_OUT
Message-ID: <28f2c85c-d45c-46af-bd2f-e97696f42f7c@linux.dev>
Date: Fri, 2 Oct 2026 22:15:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vma: don't remove VMA from rmap if pgoff unchanged
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry@kernel.org, jannh@google.com, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, pan.deng@intel.com
References: <20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org>
 <20261001154511.23931-1-lance.yang@linux.dev> <ar-53boTrPQijDUt@gremlin>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ar-53boTrPQijDUt@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62A92140008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: zw3shj3n9x3q37463pms74bnr41gxu38
X-HE-Tag: 1790950547-176480
X-HE-Meta: U2FsdGVkX19hgM7ehk6YfkrKaPpALomEWTrpVXCpQ551MrOSo/Y8hOygClQyesxyGS6JrkP8xqIw6cgIvJDq7TFngbYNtfhgTsncTdXho2IP4FS1vDvCvYdgkcAVUNX20MK6Kc5WmUvA5fZ6C0JEtWKcsgU9GVttbgzAcmFxzr6f20HqHdfbXFghqidVRk2zrBDFCPCrWX0G1U6jCI5AbfVTDgLL7NMtSS+lPpBp26BvJ0OmYqwlE7s2zu2cJ0suc49QlN97MX32eGQMuHMky8lPeNcs9dgsvoz9Ee9NotekrSRRnL7id1HNvjqQn0YN3StHc866c7qZoWpUcSbT5sGNcNHB/GgcsElfzdue9SpbHKLnxwQ47c6P5NcMB8W7j5RqkpMMEZlQdqerOOPopSCHkpezOokLUuHgioN5nzUtIJvGIOnr/FgaUagUoYGCKyzuSHog8QGS1VC4NIxMhQHMbCReBG/KnAL4I85wF3z/XKJKVmO9u8GPXlHfW6waklj+yPzYBUXOvqX1fkfMet2fyyVwroVoQEIoklmrMZD0eHHNFG7+WTXVaHCRDB0BOMnp1CWBRlF8OOvhzvR3tA0QTJycJrQ1rbdkQACCvObEa/xidu3gYmUuEMe9QgpUyzjScsb9Z7x3p1QAia50zcw1/SKmUBqpoSGhh8M2AnWl7mYWqpfTWJBJyfptwsUk+7WnSCnfFOTmHMivkDF4IiZ19BFtUA1G+M2t+3B5E0lZDhtFMYzgCFwhaoNn9JBMBSQiRK7XFFskEBP775wCyUinDnXvkN2eVh2h9lVaFPfbSh5jV5njSfL+8doiIBEtrnSEfUqMOVL0GB1mQxlstTmmWI3AECy9sFOS5Fezvl1aRrLgoQBReLQwMlhD6OFTwolYw6zEjAi+02/jWr65RVaOdLR1Eqcc7KxKjWnkMAZXR3zNYxYx4FbQFDZpKFzKwKy8MrjbJrWvDkZ6lxi
 9IsJ26dM
 O8y1q191WwAYbZbg2CNASbA5v9x2R5JffNRCEodH8jDppje5c3GEuTlwoih1F9Ouq1jC6sGiO0j8uNCcDgqXOFTzKRQaJ9U08v+Us5ryB69gcNpVdW4ncVzBaRFdXh0UdaF8jJn/G2ce6FB/uzkyA1N5h6Z2jLICJw8hdgqPjLusvkagB6XY7vvTWehFYMPRuxzMPgmWeHyQ26Vd7TovIIVYHqbkD1sEDJqvCSFZJ8MszHTzkdEzw6+Q6D1rnIxr2xeipR8moeP6i1CskQl3fWVl94I41pJ23qyFj6/CTGxnizug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/2 22:05, Lorenzo Stoakes (ARM) wrote:
> On Thu, Oct 01, 2026 at 11:45:11PM +0800, Lance Yang wrote:
[...]
>>> +static void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
>>> +{
>>> +#ifdef CONFIG_DEBUG_VM_RB
>>> +	avc->cached_vma_last = avc_last_pgoff(avc);
>>> +#endif
>>> +	/* Propagate all the way up the tree. */
>>
>> Nit: propagate() can stop early when rb_subtree_last is unchanged ...
>>
>> Maybe:
>>
>> /* Update the subtree maximum and propagate any changes up the tree. */
> 
> I think in this case it's ok to be a bit blurry about it :P it deciding not to
> unnecessary work is fine but I don't want to put too much in there.
> 
> The point is as a simple sign or pointer to help somebody wondering wtf that's
> for even if it's not quite the full story!
> 
> Hopefully that's ok? :)

Fair enough. Let’s leave it as-is ;)

> 
>>
>>> +	__anon_rmap_tree_augment.propagate(&avc->rb, NULL);
>>> +}
>>> +
>> [...]
>>
>> Acked-by: Lance Yang <lance.yang@linux.dev>
> 
> Thanks :)
> 
>>
>> Hammered it with VMA churn (split/merge/mremap/madvise/fork) + concurrent
>> rmap walks + hwpoison injection. Nothing complained :D
>>
>> Tested-by: Lance Yang <lance.yang@linux.dev>
> 
> Thanks, very much appreciated! :)

Cheers!

