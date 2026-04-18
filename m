Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB878F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125CA6B02A3; Sat, 18 Apr 2026 07:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDFB6B02A4; Sat, 18 Apr 2026 07:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013A66B02A5; Sat, 18 Apr 2026 07:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E499E6B02A3
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:20:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C4EB58F14
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:20:53 +0000 (UTC)
X-FDA: 84671434386.03.B4CA833
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E45321C000E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:20:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rQ5bxRKG;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776511251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VtuKZf/eggN2/MWAEQDQyWYTLMau4Z1GjW95A1bjIo=;
	b=TeDvv7uESFqktSP/VKkp7RNmmtwrus+QbK3POG7QuByl6xqcglIhf8zSRMNMB8Zaar7EEu
	TrbQxxYlBDaQF+Bhzi+4EgNc2o8kg1BCs4cGtj/l4sQeiqVXoRR3vubX/U2p1CtDpH7fWH
	wk2qQmaJxOfGbvtYsPFqwy48ahV4kLI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rQ5bxRKG;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776511251; a=rsa-sha256;
	cv=none;
	b=KcA6zWEtHat09XFUo8kMbLRA6Y7T3LuDl8EJ3HUCl17qPsu5uMLrILDnAlCmE/+Kz52vq9
	T3T+Uw1LF2h5f6RlbIsla+TuqxzGjU53Q/xbVFEjhSEO5NZStUN85gYP6AzY9H9pp+Hv9T
	GhthkQfRWuGtwGIR+3lKrWw4C00SNcc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D53A160138;
	Sat, 18 Apr 2026 11:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03C4C19424;
	Sat, 18 Apr 2026 11:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776511250;
	bh=OHIb1c9BBc70WI75peUduOfKkf3hZtDZ+y1C4MSgIn8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rQ5bxRKGs1G5VtMPzCsJkd8rySYpt+Z9a6kF0T9TCytsuks+aLJleV5C2visLQuk/
	 148GF6lLvzu08n33pqnlteLO6u961kDUdLjAtwgerJqh+UEBzqav/JqRBzz81npYs/
	 EdgSZRpMfAjzy2TvL1lbj/HVH7bYERuAiI+jF3v8BdBe1W4vlnJS5oYtawBxFbYipf
	 lnlQPKcLspYfESm13qRMcUGzxo4yImY4tSVMBVbOIIDKMPzw6Ry9Nvsm5eEBLQ6YMP
	 yYCG2ENmvZTJ1q2uUjBbI2jmgsRJhG0q1DnpGVMDXiumAq3Pe1kYUZa5t3CmA0aGWJ
	 nI/rtS1PyuztA==
Message-ID: <75b2b254-2e02-43ca-9109-9812cf3f85b2@kernel.org>
Date: Sat, 18 Apr 2026 13:20:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
To: Nick Huang <sef1548@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260418000635.17499-1-sef1548@gmail.com>
 <aeMQ36jFnCKmCSyA@casper.infradead.org>
 <CABZAGREDHwsXMm65_WxEn=v-zTv7_eVqQzQeCRqU2Gyc0aTETQ@mail.gmail.com>
 <CABZAGRGFpiiEr7Odd5an1+9Z+sX1C6QT2iadv-0hNhxGj8eEyg@mail.gmail.com>
 <aeNKDh8S6pXHqRFh@lucifer>
 <CABZAGRGCwM1PiSxennV-Uy9y1gGKjpcHeq+eOAbqSZcy3Qb55g@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <CABZAGRGCwM1PiSxennV-Uy9y1gGKjpcHeq+eOAbqSZcy3Qb55g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E45321C000E
X-Stat-Signature: cfks346tq6fjbrs7xm7kuze3qefhg8sp
X-Rspam-User: 
X-HE-Tag: 1776511251-52806
X-HE-Meta: U2FsdGVkX19RMHgiG6bgJm5wcDGCRFzR44iYCtvPCbi/quUqfDPYDJgbVxsHiVTvVfIz47aDP67u0sx+bMIBmtypW6lExWSPQNfC34HMv3NwYa3UwmgXi5HcpZWSfslhs0nwUiXsI0Wymg29b6X/VRsCv48MO0UWdNV3s7rVY/OGAA9d7DS8JXfQODljMo29oBQLUYmqs1AadIs3Q9K/HCoG7bphzL25+TGu8oFCUq7Fo/aL/dXMSngMBsCv3GN/iec78unBkZkxIOszR8xyiRUe3dzpn15dOjWgVzUIZ96wh80yQ+ANqUKBn58Yc5CDVjQsihDJkf3oQbuVyiCZpkINPlZQDh5sWOCB5cGbz7NUZpnkslkjzOW3quHJES2AYROwUSRlABoRyDHlLsu9KxrMOn0yZtnVOc/5vkCJCY9xYObv/Npcd4UamWmxZHJMA1HMVyd7g78EY5UZIg/ScwYt2xJd33iqfYbQaV20oXpW8wrKbXUfFAvWAfz0cveDsfSBTRzO00WPSPafQuycqxSr809SzI8aVKAz3rF6XH7b8M4TEX60JwMnJCP6kFEAed1cv95L5Cl+1gJGttRA1Elg3UQ9rrVRE3wCdYXVXe0Y8QnwHr3q2obuWXas2jaJiyzk7je+qKvcHskOk92N8LVx9Z6F/fo5TPf0bk8iJ+mXYy1GG8HoJ8U84G4FHSf6y1TqUBAEL2XDv5bHYdiazGN/B8yw+i357pSly7Dn9tF8OLqIHs2jqbKwaVAnFza37TFD6T0Kg+Iv13uzrBVc1l/s/fltD7gHz1G15q/+Mxb2nOUAAtGl0e3p8jnMQ8shuGzNHgrUwmrK7U2AFb6hV/2unggLZddnonm1YRDVFuR9icXyyRorDOVkLxTgKm0f9iJcnWlWF6CN6NGQumZFbQs3p2gjoh9B1YjzUg5HS7JM3b0a6jYV/3/xKtv/2dztsw1/FQ8TmHU/peCS1y/
 lU6kqvc3
 m0X+b6eoG4XinZtzlKg528dI28vUHREUy89TxVDIdF4fZnlZP/G9k5oembU3KR0Zbrm43X5poKaToQEuvYL2wqQRLHMOwFtq6Ruj61Xwbyq2Px+AtZg70TQTX+y2EoMauezzyJWb/4F+jsWJHxI3wuOkiK8RQxnMEGhkZcGRkve8njnmfs4p2pUnZEh6kmcfjVPXelVabPmaPh5nK5vro1848MRY3QiJj94QbbpFCqOPYcMQdhb1mDkA83C5sqG8Rmv11dUwCcN+2ubQcfq8/0O6U/dm/BDpMbEC1zg3MDGtONjx4CrUeeQrqZpJMPjzcANaiXx/1TTpYoSEv06k23ZMo4ngeB+tinjmQHPkoZkpEnfdjCLBhtJN0ev/0kdrnAk/6hLrQO9Bbz4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/18/26 1:00 PM, Nick Huang wrote:
> Hi Lorenzo Stoakes
> Lorenzo Stoakes <ljs@kernel.org> 於 2026年4月18日週六 下午5:11寫道：
>>
>> On Sat, Apr 18, 2026 at 02:12:22PM +0800, Nick Huang wrote:
>>> Nick Huang <sef1548@gmail.com> 於 2026年4月18日週六 下午1:27寫道：
>>>>
>>>> Matthew Wilcox <willy@infradead.org> 於 2026年4月18日週六 下午1:04寫道：
>>>>>
>>>>> On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
>>>>>> - Add "Overview" section explaining the slab allocator's role and purpose
>>>>>> - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)
>>> Hi Matthew Wilcox
>>> I will remove this sentence in the next version:
>>> “Document the three main slab allocator implementations (SLAB, SLUB, SLOB).”
>>> I’m not entirely sure I fully understand your point. If I’ve missed
>>> anything, please let me know what needs to be changed. Thank you.
>>
>> No, please don't send any more revisions of this garbage, thanks.
> 
> thank you for your guidance. I will correct my work and introduce the
> more recent `barn`, `sheave`, and `kmalloc_obj`.
> Do you think this is appropriate?

No, this whole thing is inappropriate from the beginning. We are not
going to waste more time on development-by-review for something that
started as undisclosed LLM slop.


