Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA3EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5866B0093; Wed,  8 Jul 2026 08:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5516B0095; Wed,  8 Jul 2026 08:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97056B0096; Wed,  8 Jul 2026 08:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A036B6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:03:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2362DA063C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:03:33 +0000 (UTC)
X-FDA: 84965474706.10.A37B218
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3DB881C0011
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:03:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+xP0xuQ;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783512211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcjnZnO1yUgRcKjT2mCR1Sfcx9FUUThhvESYNkvL8+s=;
	b=mIkPfvl8Hqo1m3HMxD1+tVqtUsRLW05+Z3RFEfvI4ypkfSRBtzwlNyFnx4hnxiRSEXpIAq
	3mEMSH1jmICR62LnVmsVV5qBUdLgpp05rXiA+iUFIyeBfgJkhZIZzy4uHYxzOlbYgz8Tbu
	82j4rwTnteGjfEnxgJ1HlxGEsHlNWCA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+xP0xuQ;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783512211;
	b=2EROXMKstsI0LEyK2lqMHfJAGHfdsaiRM2AmwOWmcw5BFOGVOEUsRz0QU5UH+uFbxOZjQm
	/nd7FAR6sFIdCvR9EMxyF5yUynws94f1Jzw3sr65FmQv9HMZSSrSs8dQZ5r/DgwiB0OMwK
	yDTFK5+BSdnIjTdAsPAkLRBQ1/+o674=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AB7743E18;
	Wed,  8 Jul 2026 12:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8C01F000E9;
	Wed,  8 Jul 2026 12:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783512210;
	bh=dcjnZnO1yUgRcKjT2mCR1Sfcx9FUUThhvESYNkvL8+s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L+xP0xuQCud450vpjh5B2WdcKx3Cecpl8d8ZbgqjmRWBrQ1aoZmYy76TiWy31hJUa
	 kFXpuIDjlMA/wzrMeglRDHbWkEoA9FI4mxOALVZqWuEt5MBGlJLadOokkye6S0kpTL
	 A5e6IEiIDggcL79cbuDQgewG/aI9yULB+oVXSTMn8XSBWc+Bfgz0NoWpPtNcuipM80
	 XJbD1ZhBkszdqu+W8eYZprEs4/5BZIhnGys6/l0baHFLW+E8r0Te818d/lVFgSkJib
	 P/hXkl9xpVPU8r8e7C7tAv6IwLhz9OVtX5ZOFdkTl2anYvtBIMzOtGIyi+CAcD83mU
	 HSmFFlz7IBLdw==
Message-ID: <6ec8f683-77c7-4ddd-830c-030a3d984715@kernel.org>
Date: Wed, 8 Jul 2026 14:03:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
 <20260701043024-mutt-send-email-mst@kernel.org>
 <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
 <20260707155658-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707155658-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DB881C0011
X-Stat-Signature: uz8kh731umiupiaimbsiaxi8bnrwo9qk
X-HE-Tag: 1783512211-427137
X-HE-Meta: U2FsdGVkX19zlLWFITKJt+ShMkidxYbrn+Ud76Jq4dmzmfJm8FKArNNCAFhb7s+c888mTwbMrEvspiKQHSGaWkPbKU5bkAghT+ZRvqnipixchRSpXHQvgtbDBdkaXNDQyxrtRo4cPpCSOpBnpAZ0e0bYrx6RArHI6vKSJtjYAR7YJQqXcjEy88HQb5WrZU8Zi7sT9W4tgKLHAHGoRlxTjQVg/+BzOPX/tyYp0+zO+bpTRRwFGB06mCAYgLzXlJoXGvC+YvdJUsAgUN24G7VXNH+OtqRrV3X/8TPiOHx2mUAizVO0RbSbrIRpc0hFNAPeBbmG71R4tA/qqexjmxtT8udV1mqd869Ev0+65PCW7lUKIz45TRN3BB1xNLhNSg6vxevrKzy3zg32NDRVrUaLgQt+4dI/n6CEGd/u5GaJ0ZPoiSpw7XPkQH2TJXp93HpdnKpzknJtuHqwZ98r+Ee0hlEWLwDcw3TVJYJSsmUUT0aLu22oikbykMECeIJTodT1091A60I/+v5g2pBzl3fYgzLvqWjFuZ2TvCMe+eR8sJQYwh9+RHOogznTyLwYwc9LI+IwXtKlVdWByjdeZr/vHVhr1hsVievgdS7HjSeY2fuGS9yI9j5k3PgSFrBlxAA+reNB9d18qY6dnla9AXArJZHv+rar+HW2IJ2uW9mjfGbzGckmIn8ML8o6+4y0bg4ryb0IhCRMgINanX9Gwua2Nk9MYhm/1Fx2yTDw4u8HQVu570PWRv0nBYHYXi8bwtHgM8mEPZJkQ9TLbVcmKQ/RyouT2r2TF54L/uV5EcLqp41g82E7v9UT/I1yXEaaLhJ+6fcJdlNapZSSMefwuWi9G9Ja/Do0EGJzV6No6XanQjtuKSvM3w9HearggmOM+o9XJ10XIgQ91drExtw7PjoTGc/2H4EJmAdMIjBlG4OHB09flpuI80bXqp1loR3p18J+/CAaClxqEmS5bXLjmDm
 Mx8B+DWK
 EMzMkmOQvhy96ThgbozuuM1rGLteV4x3AjIlZMRu6V8U+YxWUBG+LrBp9PdKT4DUa1IAWkrqANAiUmSgPDoYTjywDPPlQWsH/iM7ec6lkRTDKmoTzZmpjuR9Vlg447FYKtNyjs2/k3YECAhbO35zSj0MZ5mahX/XfB0Zm5isZrkrdWReuOoBkIopn24/yJFRPncTEKcHWCseafSG2dOufR17gN7oY6PajIeL+35Ymif0Hq5zPgikhrtWN2ArntgPoEUfG7WzzBo0p5NJY+UfmmxuLrp8EL8UclFvKskea4K50xHDZ2m2MDyI4WEjl2vCrlJ1zYtoWw1hMJvTowIOdVxk6/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 22:27, Michael S. Tsirkin wrote:
> On Wed, Jul 01, 2026 at 10:36:31AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/1/26 10:33, Michael S. Tsirkin wrote:
>>>
>>> what do you think ;) post it?
>>
>> As RFC please :) [and if it's AI generated, obviously properly reviewed and
>> reworked by you]
> 
> I spent a bit poking at it, and it's hairy.

What I thought ...

> The issue is that we have calls to both set and clear bits.
> When we record them in a side side structure so they can be retried,
> we have to carefully record both sets and clears and their order and make sure
> they do not bypass each other. So if there's set already in the
> structure, we need to take it out of structure and only then add a clear.
> 
> It gets very hairy because we want to set from NMI.  So now we can have
> clear in the data structure and set from NMI bypasses that. Now what?
> And set from NMI can't be 100% safe anyway as we discussed ...  Kinda
> reduced my motivation to try and make this reliable at all.

Maybe we should just really keep it as broken as it currently is. It's not
really worth our time fixing basic design flaws ... given that we didn't have
any report about these races so far :/

I mean, sure, if it's easy, ... but it sounds like getting more and more complex.

-- 
Cheers,

David

