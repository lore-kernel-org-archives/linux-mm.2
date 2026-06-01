Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F2ACD6E60
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4F06B02DF; Mon,  1 Jun 2026 04:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB136B02E1; Mon,  1 Jun 2026 04:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C18A6B02E2; Mon,  1 Jun 2026 04:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49F966B02DF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:50:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F13D4140608
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:50:49 +0000 (UTC)
X-FDA: 84830723418.01.2D139A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3C7B0A0006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:50:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X5OwSdP+;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOXmX21/fHF25zTKpMhWR+5TihwK4YQ+etb6BdX+TIg=;
	b=Lc8gNQaAdLGoPd1FiCOrtNfXFNA6Iap+9lx0px7sXTmvKawVYc0zkWQieup6kRGQJJ4MeX
	8EmY2NZMRh3pRxnF+Zi7h2e1p5013MNBPJz1re/RylwE8n5U2/Q3qb1kTrfAUEQ5K7EHVJ
	Gsvye8TJPGw79x7ZwHpJS/PYaJeIJGg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X5OwSdP+;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303848; a=rsa-sha256;
	cv=none;
	b=KOeqaIzIHG5CGjy3Z7FRDyWu4dDfK/C9sWxmUk1/f/lNhxBVfd3Su+qzmV3p/p5yj+S7TV
	NLZI6mXQDCVStSALpJT6XKp+d7qpsMKhnIVun5XpAI/w/5Cn1/d+3VScX9az7g+hHVzhWs
	cJt681Ese6oEK724LSkFjcSLhj9lmyI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 996AF60018;
	Mon,  1 Jun 2026 08:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F641F00893;
	Mon,  1 Jun 2026 08:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780303847;
	bh=DOXmX21/fHF25zTKpMhWR+5TihwK4YQ+etb6BdX+TIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X5OwSdP+fi0Uaehu7DjVQsFNIdLpyaoZ93FgUIe97onX9nUceSXf23ESKmpZDFQXS
	 0rSzmAG2hEV3J8IGKQUGcjWaW2Czv6Te+9TxPQ+bIfomwP55NYIRjWwNR/6+qB3WZN
	 Oo9IA0JTCsQo0QqepLS9wgEyOy+m58czDl8FRh4hGmNuntFlrRwodsKtkjnfPAdMw0
	 ynBEwbuqOpR5V5Z1YHWSu2R+LlOTGl3ZFa/mG6+x1XgWpgBo8O2Tt+fnaC4kJiVPhL
	 B+e3stH+aDOAFmw7lvKIazYYtEf2fBHP0cjpecKz4ksLX+/cYhQeEyy7STb8L87ScG
	 DyrAh7eZF8sbw==
Message-ID: <adaca36e-5896-407b-9f46-601ed5686575@kernel.org>
Date: Mon, 1 Jun 2026 10:50:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/22] mm/page_alloc: implement __GFP_UNMAPPED
 allocations
Content-Language: en-US
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com>
 <7bfda0d8-2a7a-4337-8b55-d0c158df7839@kernel.org>
 <DIJEIELZ5DJU.26LYHOT4WR7A2@google.com>
 <DIV92L7AZOHG.1FKDUXLPZEUK4@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DIV92L7AZOHG.1FKDUXLPZEUK4@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xyy5etwj55bed9c3kpb8t1eq3srxq66o
X-Rspamd-Queue-Id: 3C7B0A0006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780303848-289826
X-HE-Meta: U2FsdGVkX1+DHMam8ta2IN2QaPcIzyaNqTO6GMC2pdaeqEycnrpbVgrek620MqO5vbXswzp7RJJSR/ISaQFbcveJVWUOtoNZV9LSx10qjxxa/JLiMHeHA+YPTRP5pRf59jSaXYH3YSGRjH+ImMDRipybm56ukeH2/eopEQTfTy+XtpbwGZ5itDBOQKMwlBYvljHZp7+2ALy7coCl8Wnnlxq1pyF8It7gEAMWPk7HEub6EE1yuZRykNwuPwYoB22qxKGOJABfnRgcjk0fGG51xRFDRj8s0SrXYgcmKwVYm2EmxR+/T5ZNOifZwUfFZxfzwtzPjxuXey2Cmm2OnzpjOVzbB/1ZJhRhITo/aQPpT2s5Zx378SoHtl1KIUTSXeHKQx8MBO2dY2KIIezriqclL3rre4IVS9btVUtoYIUFaz7YG/NwSBDIvXxIM8LSyZ6f+97sOkQzuTWVu2Yf4zhW26GQPBYUzHGqDQ0BqYBUi1Rl0EQHFZPN0JtUTrrRZexiBY521W2VNcDXAxS6MYQ0BuHbs0R93qzqSwcrZOQfjfZLNjUb2ksSEyqg9214wBpA0wyEQGHoA/fmrI62O1KQmvcgWfcOmN+YhjagDpOpEc9CRmXZcQDfQ90GmG3240hbHDRzpaUGOaWrK+2Ihvd2eFk/JYHDLHh0PtAdREjKOO97DA+XRaZEd5mAP5ug/RmCcetsFGtVbYNuXRVFUD0FzXu+/J4zHmiufeLEnCufTw3Ri5QrNvM9zZeT/VdQReagdKpq8fuVLuXUdLTqqY5bc1E+fjRMhP/1cIybPAe9byg8waxdgZfCszKAw58Ad+6qJUmg2HwROG0d01MOi1VHQ0vhasqtKHNQShGGFVCGg1dpyeWh9wxUttI0o/1DCq2HQbaZMxG8sRRLblKRu1yrfHYC9x+Wlktxeurb7AZWQdcc2IeTg/hJr3UB+/R/gi2R+rVI/QjRmzPLaJJBG9W
 9RkLk9Y0
 kHC/eM97BcG/spd3YfJuPmHLVYRsYdIprcpHBOGAmIyXzpA5vF1t4jYGPIj9uVax87vmKaJ9M0p5vo++Cy2vvCLXJfCL5Ehdp+VjuwYNQ0QpqF+9Ko+ffESj/i6zvq22srUBwfTmSl0OBk8YiYqoPanhvibzyH7Ajvd/OT9WI8DQNN4LX/WxB+klgbaZfw2ZY+qcDdW0c6zMB8u3BdP6wSon2x1xzQfPrN/IT1TpHfWSE9pOkuQJJteHolLiVJD4OpQdfh+3+HCyFi341sQjYCxS8WeGS5Zxvc96bteO+H4aqxG2MaxBWq9yzvowpbkSzrfH4elKi0pcV9+JlCJMvVNp/r825NU37mcPq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/29/26 17:02, Brendan Jackman wrote:
> On Fri May 15, 2026 at 4:46 PM UTC, Brendan Jackman wrote:
>> On Wed May 13, 2026 at 3:43 PM UTC, Vlastimil Babka (SUSE) wrote:
> [...]
>>> Uhh, speaking of compaction and reclaim... we rely on finding a whole free
>>> pageblock in order to flip it. If that doesn't exist, the whole
>>> get_page_from_freelist() will fail, and we might enter the
>>> reclaim/compaction cycle in __allow_pages_slowpath(). But since we might
>>> ultimately want an order-0 allocation, there won't be any compaction
>>> attempted, because that code won't know we failed to flip a pageblock. And
>>> the watermarks might look good and prevent reclaim as well I think? We
>>> should somehow indicate this, and handle accordingly. Might not be trivial.
>>> Or maybe reuse pageblock isolation code to do the migrations directly in
>>> __rmqueue_direct_map?
>>
>> Ah, thanks, I suspect you are right.
>>
>> I did fear there would be some sort of case where this "not-quite
>> reclaim" interacted badly with the actual reclaim, and I tried to test
>> it by running some stuff in parallel with stress-ng (allocating
>> __GFP_UNMAPPED via secretmem), and I didn't see a difference in the
>> effective availability of memory. However, I suspect testing this is
>> quite a deep art my "run these two commands that I copy pasted from an
>> LLM suggestion" test was just crap.
>>
>> Do you have any workloads you can suggest for evaluating this kinda
>> thing? We would definitely see it in Google prod (I think we see this
>> kind of issue with our shrinker-based internal version of ASI distorting
>> reclaim behaviour in ways even more subtle than this) but that is not a
>> very practical experimental cycle...
> 
> I slop-coded a benchmark:
> 
> https://github.com/bjackman/kernel-benchmarks-nix/tree/master/packages/benchmarks/secretmem-vs-frag
> 
> It does some mmap/munmap patterns to try and generate fragmentation,
> then spams secretmem allocations until it gets OOM-killed.
> 
> With this series, I see the OOM-kills happening noticeably sooner on a
> 1GiB VM:
> 
> metric: secretmem_allocated_bytes (B)   |  test: secretmem-vs-frag
> +---------------------------------------------+---------+-------------+-------------+-----------------+-------------+-------+
> | kernel_release                              | samples |        mean |         min | histogram       |         max | Δμ    |
> +---------------------------------------------+---------+-------------+-------------+-----------------+-------------+-------+
> | 7.0.0-rc4-next-20260319                     |       4 | 683,147,264 | 643,825,664 |               █ | 715,128,832 |       |
> | 7.0.0-rc4-next-20260319-00028-gf00246eb72cd |       3 | 623,553,195 | 551,550,976 |            ███  | 692,060,160 | -8.7% |
> +---------------------------------------------+---------+-------------+-------------+-----------------+-------------+-------+
> 
> So... I think maybe I've reproduced the issue you pointed out? I will
> try and fix it and see if this degradation goes away.

Since I assume the fragmentating allocations are movable allocations, it
might be the case, yeah.

