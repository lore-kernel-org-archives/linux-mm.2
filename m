Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF2BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75E76B0096; Mon, 29 Jun 2026 05:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4CC16B0098; Mon, 29 Jun 2026 05:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65CF6B0099; Mon, 29 Jun 2026 05:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDA96B0096
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:45:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BD42A0629
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:45:11 +0000 (UTC)
X-FDA: 84932466822.04.5B983DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F60C120006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:45:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gXlIChH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782726309;
	b=HtR90xjYCSAK78pXFapn3b+NPt7i8u0zLYEOtvxlMcvQNL9V38B00sBDpx9V6bgTi1uuP6
	QceT7+ztcxnPXmcRYUyeMn+ddl0xS31/JeyWI9FXm92TBcq7OgR5Z8/CVD5SMB2PYB+mcx
	m9qX+4fue7GUtfp4n+xKUe4iT+yhhPQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782726309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNKitwu74metHjmohLLyIabuuGfZTd3oLPEcVRH6PRU=;
	b=aiqW3TxwDdx3zA1f5N8xj8huSvZkpf5Q9wjKUiW071uFutgKktuUEvXM1G+908OZIueft2
	8DeTcT6Gl/O1e8Uo1o8U5/hjBpWMWT3ptbaK2UYMYKbgT0ach5BLKdxca+cfJ/mLsKZQ6s
	xeYO/A4aZYgeAhO3LPqNqwiAmYhpYiw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gXlIChH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7617443CA7;
	Mon, 29 Jun 2026 09:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DCA1F000E9;
	Mon, 29 Jun 2026 09:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782726308;
	bh=PNKitwu74metHjmohLLyIabuuGfZTd3oLPEcVRH6PRU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gXlIChH6W10efBG9/fXMWcJ27q89S58y77++tE7iaU9SBIBbytfPOm3+n5eALGWvQ
	 +PcjmjvNJ3g+pXgYvAQiJQi9enFcQrckiga8YZcgbfPXOXjnKSzydwhp7FMNij5iqk
	 ODMRcFMqcaox7LSMPjXg7lkbANSYReEu5+19A6MfeM7ba7TYTOYWHih239hwYsUD6p
	 +PN8qtUoT51jqG9jPvKoS5uyiOhT8y3JxfsEAqfs3i7lgBKRP70UptZgDGNUZGNCqn
	 Q7p0GQX0ISg+YCRge0PT3XDaZ4HpwTl4cuiblvFPRs7w20+CAeYn/0sJAzF48NLS67
	 k3mLTnMAnxAyA==
Message-ID: <4b12ba64-5e2f-492b-80dd-b9be95604026@kernel.org>
Date: Mon, 29 Jun 2026 11:45:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: s/SeongJae/SJ/
To: Lorenzo Stoakes <ljs@kernel.org>, Pratyush Yadav <pratyush@kernel.org>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260627195630.24519-1-sj@kernel.org>
 <e29d1211-8bc3-433a-b1d7-d7fb44c2f0cd@kernel.org>
 <2vxzo6gtk89r.fsf@kernel.org> <akI8lkVb5CICUcWi@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <akI8lkVb5CICUcWi@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F60C120006
X-Rspam-User: 
X-Stat-Signature: qoy9sdof4k3t39ukzzk5q443uqgjyz8h
X-HE-Tag: 1782726309-219636
X-HE-Meta: U2FsdGVkX19Vuki22c+K/k7P3h6jtXgoL2Jv1/1daS4C2vBvTaM08dvQlK8lJP9tQSK88tQ6NiIw4iyRpKUvqmQGCneQCPqzhQwytovYQht/bY3xWlxPB1Bw/YVOX6xSGITT8C+iAYGVe019/8fHhAZ/IIyT4COQtlH79z7Ylw+jyL4onJjlwx/rKSOUq5QPdbqE5T6IG6D19ALkjjXhwd/T9n4BjQd5jgfi8z9Qn0C3DB4D0XYKT3lK37c/s4h2cD7T5umnxzJ2IEfKdooXt1qThKIU7XfwChIz0QN9ITQUtuNXBw/a2cQCvb22AVmYPaTXFW3bD2dYlzFlWnGCEThQ7s3lR2hNpg90vOBnOJQuLZR/BrQalBJUTb8Ta2XakcWL5UcVbNy88MtzOA3lHeF+gwfXLNdsynVdQIanWwyWH4oDGhAHh1LzsGj1Gx0lcU3um+jNyMeUwb15Tp5EFSecNgREikFBCoutbOqQBI0seiVPIIA0NjUeygmyADTHKeXVmQTRIDkkSSXRtNHZKdPnbV5+v+GOsuOftYgi5OxUfbOlADv8RsahOP+sXD1bF6kqjtqndrN1Tqf2s+PVlnkI+7ap5ykr/q+9gz5BZgciyyU3yCK2W6XnQN/pYOAyOapW+njqQ8nWiwJjtbYzFJyYx+wNkdCLIPoFrLZqQxIzih2q2PoEFOnRLCL+SyhObFbcPhgDUKGllI6YFqOfuQE3PugPquIgt983M8wdtKlQaG3omUBtdmCJTylLYXFtWVcB/p95c7AFRZkLgVguTFARtch0nop27eJLk+w9GEU4U0tOkF72F7WaVxMlbomoJniyZeqYV1BRO9D7xlFpaCSdKy0ocK0vrzg/8WnZL2J0JQg+tgqQ6vWNAY7k4OQdGM8v9M6cfrv9njktpuxxALCfFgIlKb2SGV286B7k8hgWoeCYll2vsccCBn0ck34cE+xcU9JYqlw1kDcFxhn
 INqG6kDk
 vJ28NIF8M0cdLt61MpooVJBsAPkoS++KRelsU5zk7BO+SIv/X1EX+fscJbxII7NoYrBD/vuri0OYm4O40KbpsHBGWtSNGZON7xidn+dQp8UWq2Dw8ZP0fbItG87qQ1RaSE4ezjj6bgMJ6tFzFXLXvNzufSE4Wr2SsDhXJcLQOJbHEnVpzJczsfBoeEYAGLoGgR0g2l35gjgL27OmBhGxqmyyl3HNNoH1XQo3OR5JKLN81y98834ZjHTJkUuaAfK7j4m5vepxstNxXtxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 11:37, Lorenzo Stoakes wrote:
> On Mon, Jun 29, 2026 at 11:25:52AM +0200, Pratyush Yadav wrote:
>> On Mon, Jun 29 2026, David Hildenbrand (Arm) wrote:
>>
>>>
>>> [...]
>>>
>>>
>>> Just curious, why do you drop the author and copyright information? (can you
>>> even drop the Amazon copyright note?)
>>
>> Off topic, but I am curious how these copyright notices are supposed to
>> work in the first place. From what I have seen, the person who creates
>> the file normally adds one for themselves/their employer. But then other
>> contributors who make small/medium changes don't add theirs, even though
>> they should hold the copyright for the code they added. Bigger refactors>> sometimes add a notice but that isn't done consistently either.

Yes, I saw it on bigger stuff as well, but not on small stuff, really.

>>
>> So do these notices even hold any value? They certainly don't list all
>> the entities who hold the copyright to the code in the file. Only git
>> log can tell you that. Is there even any point in adding them?
> 
> It strikes me as a rather loose convention.
> 
> I am not a lawyer, but I would say that individual and corporate ownership of
> code are implied by S-o-b, not by comments in files.

Guess it gets interesting once the SOB does not carry that information. Also,
some people might work at company X (and send code from company mail address)
but may hold all copyright by themselves.

So even the git log cannot tell that story.

But in any case, I would expect a comment about that in the patch description :)

-- 
Cheers,

David

