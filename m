Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7D7C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B898B6B0092; Thu, 10 Sep 2026 13:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60D56B0093; Thu, 10 Sep 2026 13:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A506E6B0095; Thu, 10 Sep 2026 13:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE9E6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:57:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 172B18052D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:57:31 +0000 (UTC)
X-FDA: 85198609902.28.B812812
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DAB9120006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:57:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0B0rOvQ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789063049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ff58e1r4MAeSOAGMoh1t3fDEZWa+M93NvaAU2f8cPU=;
	b=l7XwrVFuk2AtIbPtNjWzXUD0YAnZWi+z+zo9yDi0aA3mtpjnHolry05g++xgRVVr2FaCVF
	8JPn6OGtgiiZow7h3IJr713EIDm3BYrfipoeFZ8/kK2GdHYNdKoIZ1+X2xMnby7b6vJPbu
	xiT4OqDorNMHxZkWdVJrXUARUH5O9pg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789063049;
	b=xFejwJF3AqcLQhpCqw92Erc5DgMzrq0ppeTw/VyweWYRVKjmV+ycNDRoxaHn/gR0aux/GS
	ZbwYQHBZrZV3aUgtMZY9HRNfVqvzhY6Zi1s5mqNbyLGrb1vdSkq6kyYaXX9koRz2R1sqkW
	bP71JH+wWbEs7BPh8/GYp6cWwZ3Qh30=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0B0rOvQ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09F0B40A44;
	Thu, 10 Sep 2026 17:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3793A1F000FF;
	Thu, 10 Sep 2026 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789063047;
	bh=6ff58e1r4MAeSOAGMoh1t3fDEZWa+M93NvaAU2f8cPU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H0B0rOvQX8VpVHxmekklMUtfgBJjxIdYtekM/kNqL9xVctxs/FDGawqOjRLvAi5U2
	 3jqkXDa1K6CYPa9q/y3fs/h+GSkuJuWOKwNB1VHTHDzI8G65oaogoJQSMe1j41DeYy
	 z9KS5Mig06RQREdF3WcIf49yGsMmwVTkYrVQEWUD2mqCucrdeHKYmYKWVad2KD9beu
	 D/SxfPZm/huPD3rluTJY2DWQuzEAcdzK1UbBDgexCuT68UoMUzRGpwOR7WMf7rzKG2
	 X1861ACcpCmmA0U+ROYG1sjpmk0+jhti4TYK1/zj41Xm6DWNhRAgSArjFqJtXtF0Km
	 KBwjqnhzCVfzg==
Message-ID: <c4f13252-f4bf-4006-b908-5094601e5169@kernel.org>
Date: Thu, 10 Sep 2026 19:57:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 YoungJun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, =?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?=
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-doc@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e3bpmo19byk5ji6h9g7t1gcbf3uo9ssp
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DAB9120006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789063049-868266
X-HE-Meta: U2FsdGVkX19pgjqWELcGTCjk9+FDur772Ji6V1n9Kug9A/IJHGO9Onyo6zhnNGoJ1QVYhhXMehkU9KQBl1re+99znkYkUulSRbrHSYzatXC+HMBhDiBbueLPd/emdK17X6fgWlR6Ua2E99fbs3X5YYlRu+FNn2Ps4AkfC1PvoHsyVqlaTEHlaS6nt4mfRia1z5jP2wZlElMywlxH0pjsIZEdI2si8K1deN03GUYE3McR6l+c22OElecUyLdYoROO6BKMW8ecyfTMzM88r4jU7GVeW7RkIYFdyjrlstAZLe5dbWZsLeasv0RH3R//IZFuj7E5fla/gFQdawep14F6+BF+dncaTdGlHYnvbump/l4LJM0odP2IVJF+flXEzUMMN/VCw8u3Xd+zg+M6AA2RwfT/y7anAFNpqVk1JoSgaAe1uGa1beXwIlKAwuRYqa6s6qlL2f1DBCoOPOYynZf94T2r44jEe0pshydKFrQ1vbrXzNQV3Dw4IUvhX18KkM0THnw7iCAPSq78OM+JZF2cpQ/NNtxAogGVKVp5xWd4RfWX7+0LDCY94JVpSTgMu8LpDBU6iCCO4IFUOsHkO2iDzgcsdaGR2O9PjXUqZha3Yg52OcJUri1kCd/APME8cGPq89iTeXD8xLyluBhnoJbkMTYpypA+ljDLovLhQzPs1k0Kjy/BtqvPAorx/EpS81RFI2IooJXpBIJ+FJcKBUqbxQp4Ye9wj8PTdSBhfrjWnkjLPtTc6pj8CkQFXqemSqJQkFOkJV0FJ42X1kqS+uWNTshsBLUTlGSIGyA+Ozg7GGe3ZU94B0QEuu42N6W1cU/DQLLN9aZDY1VcvMAcgUF8s2gl6hcDuhx+0o5Oe/qWs/M07D/njZUh6ch17z+QtpPoGl+yeUqkHGGnXJeTc/M7RSIPYHubcCPunZaodwJrg9+Nq6eT90usBp/Ge+5oPE67kdzQyOMwagI4u1K10EE
 98TF8t/H
 wfi+nsolb8kNUWSVHYyu3oNNZe+NrVFPGdAXsRchR5HtcuB/hAUi667M4f4Pu7WdN36ebuF/9D9pnAWBXrO+uxdfYVKZ+p8xrpwg5ZS9D6RE1oPm0lvrDy/IsCRvFJTz2uaUdg0qHoPhOyh4loP7Ddcr3ivcBI2KGp5wobOImQv/QZeDbsoNte/AHwzRhAuy4IiogopaHOoTKAM8qiPXDaFaoNoM/wRr+jVC9FTkkC81fGSCWja/sdEejKci4fhPMxx0EqacHeM42PtK83Z/2BYtIK62RJwafjo7GZkfuHFMeqtRVbI+iz/HdIGZbdnsnyOM+oOhU/Qf2Dcy60VB4aHZPHf0lrTic9r8+TVkwJkii6jeOyBq41A87yDf+Xjf4eLnYpO0/XPv599Qaz6OmcLHbyCEi9DKhBtJ0agnHiPqSRto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 18:22, Nhat Pham wrote:
> On Thu, Sep 10, 2026 at 3:57 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/8/26 18:45, Nhat Pham wrote:
>>>
>>> Hi David!
>>
>> Hi!
>>
>>>
>>> Thank you for your suggestions :) More collaboration and communication
>>> is definitely needed here. Conference is a good place for this, but
>>> it's not something we can do very frequently, and many folks could not
>>> attend (visa issues, etc.).
>>
>> Right, and conferences usually don't have the capacity to squeeze too many
>> swap-related topics in, so it would have to be side discussions or BOFs.
>>
>>>
>>> A bi-weekly/monthly series of meetings sound very appealing. Swap
>>> contributors are very spread out (China, NorAm, Europe, etc.), so
>>> coordination will be tricky, but let us figure out something.
>>
>> Yes, that's an issue. I'd suggest swap maintainers take care of that if they
>> agree. I could try as well, but it's rather tricky right now on my end ...
>>
>> As an alternative, we could also use on/two/ ... slots in the bi-weekly MM
>> alignment session to talk about swap. (I'd be happy to learn more about all this
>> as well)
> 
> That's awesome! Thanks for the offer David - I think MM alignment is at 9AM
> PDT Wednesday, usually right? 

Yes, exactly. David R. hosts it!

-- 
Cheers,

David

