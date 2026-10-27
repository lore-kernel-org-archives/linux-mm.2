Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A67B606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OyHe/4xA
Received: by kanga.kvack.org (Postfix)
	id 36DCB6B0711; Tue, 27 Oct 2026 08:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EF66B0712; Tue, 27 Oct 2026 08:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F0E6B0713; Tue, 27 Oct 2026 08:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 083B36B0711
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:53:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B093409F8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:53:42 +0000 (UTC)
X-FDA: 85368397884.18.EE5809C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 88EA62000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:53:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OyHe/4xA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793105620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3A3b2z5R5PgLMJaCVunBQCGAvsKmINFfocdONRkdX1E=;
	b=rvAzeNhY+d21X3PzOrriRNncveOf8wbM0z6oN/aRhBycDARWjm05Sxed4RECwsA5iO7+Nq
	iYx5ZASHpaKDZY+rCjClF+O5NRfkiNNVGlcalB91owQrQahF/PDVYkhIkoE5cmuQEruSnU
	Rc6SpY5/KX2W05tRH4GraV8ZOHnsagU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OyHe/4xA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793105620;
	b=5dWr2fFev57TDNJzRWLsXnlZq5ECCNTRK3LzQPH8PpIoyNve2Nru6Y1n9rn1BuVWHpGYrT
	BEsfCCdH5+KM10nhqfDMyAZv3+SPJ37gAEgAcmHzk4nYoAhqisOmvt99bhP2qFHKxybs6N
	OmU48mQbCxKAvJfauGn/2uU50iPtyUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5797F60267;
	Tue, 27 Oct 2026 12:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F281F031E1;
	Tue, 27 Oct 2026 12:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793105620;
	bh=3A3b2z5R5PgLMJaCVunBQCGAvsKmINFfocdONRkdX1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OyHe/4xAP6WCorugyhRh2YGYy1BO8A93QVK/QxBl2JzDgugFa9HrveviyxJbzlrWf
	 N33EqbM2ND75BtjehLURhzxhyjHyl6NniMAEsJfnDZYeTbAg3hK+IvI3x0YjG4vo4E
	 n+yqhpr8ii7uWk60fU5cm/53Qe9WInE/L2P/WP2PE5NuZdk1NKioHg/186/EFHaLJQ
	 QJA1prI/67wzJVaDtoSH4dTgG+vmi/JAJ+74NvRX8dmeMW6VdBZA/QHDC4jYJnMqfU
	 FvOAocq2S8xNemSBNQtWykHxyrmVAymLc2QykuIICKnMqKWn3A073a8l7gcEpSJiVL
	 J/Kct1lCTTz1g==
Message-ID: <3c73fe54-68d8-41f3-8f9f-06c4a1891e01@kernel.org>
Date: Tue, 27 Oct 2026 13:53:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: memory: fix truncation removing mapped folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <d7f009c90b11ded86654885b5ebcb8c9308fa31a.1793067441.git.baolin.wang@linux.alibaba.com>
 <2ba579e8-06fb-41f5-9eb2-f02b2aabe29b@kernel.org>
 <87e32afd-75de-4407-8f0c-fb70b40d5eca@linux.alibaba.com>
 <81ee2c92-f342-4f7f-aacd-d9558e67a980@kernel.org>
 <de0b41fb-4ae2-46a5-afe0-c021134ebba0@linux.alibaba.com>
 <4880d4ff-8486-4e22-9923-bd4f2407b1cb@kernel.org>
 <f41d0720-ca14-4aa3-a2e4-3ba2de3280d0@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f41d0720-ca14-4aa3-a2e4-3ba2de3280d0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 88EA62000A
X-Stat-Signature: rx8tx3zo89a8p6immc81kjssacraagut
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793105621-431720
X-HE-Meta: U2FsdGVkX192du6R1fGnfdOwa2y6lcPmy3QmFVytZISurXtqU4xNVxy1pali2wTrwP8Gybx1d4jr1SPKWssSlFIbjAo/EyGCt7nJbS8awEndlephEdWgsy4QzJAk28z8pS6uoEMl4ko8iOrji8g7QA1KsCt+rl6FmVhO35wwlfphkTCa0cPyqbwWNsORZzEscMfXVNpxk442a9HCFJgk8ukB4Xzj/aQ7TgKB/rHhJ8o+9/Hj/bR/Hn9dldwu99bKhTfVjt96HhHGEDoeTShM0JUYWLq7IGrynks5Wl5lRYXwcaxR8Ad5PMYNHWNd4MA/0DdKI/EmEJ21Ix0pFaLymNjXadcvJmtfI7l3+8vdxqOLPdMYelmEu4tPSbe7EaPWAd1XR8r4dz7PY0Ut8qeP3pNH0cNPWypyehWCgvvuS2AXKtpofGQzhNITELvRoFmkkCDwsIDZFNkIGYUyVcjc9hnex2/Fl/lKIFQHKHPOBk9ftc2m18iLjRUk0P6416wUD+PlU0fK9I0Wsr/Z0p0T9fNhsZ19A6e3fHou+o1PTxHy3nvG0z9aR793PdT0a5i64rUHNRMl0NCquG3YO7xnznRGt4Jqs6ZKq5VX0eetT9j3bXFiWEseWZpORvFoZAPCyI0qDuvqvWxEvyQjky3yDobU/QnOJmlr2qUm859+Pao0xCPkbQo77O1sNmbC4nSvACG1h92UdgI9/moHPcC7QhdCeTc1+RkYJv+b31dc5VzQKqcGMCC8foM/qRrlz1T7ERUSTtOTFATDIiuGthRyRXYLj/OeNQEI+pAKrjfJcQpoaKNzKxGZ7lUubVtMmBXqoDVOkbopSbq6RRStkDzz9AzuVyZsH5sOZNo5n0tlM6a8qECsbdyPETZeDLcnMC8mzsaBzvJ0GIsUsZptQ5SmnPEuep/6EvaJQ9NtddpAhIA2RE19YwhLN1DUiK0P7841P7DTh7nIFuY85YU6LBq
 +YZuIsIL
 Zq4L2IiFyAaZAzNJC9t+ZVnpt2i/6YjgfachNLwUz5+Kf1JU5gIGyR7u+7yjz4HmrQKA40DaPa9M/7L9oGoS0bC33vLjkb3yREqnI8bVualruSL7bHCKNgwdMZC35YPfXHwkurHP9YNakyrr5BVffVEEVQ1h9+XKIMKXOfy1J9LMUTMJsxgXAQ9/c+GCvoxDU050RZcM5d/QPtNBy/3nGZFTwQwL+sgOipFGw4j9yJB2r7iaq435rzLzDjS/yd20EI/Gf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 13:50, Baolin Wang wrote:
> 
> 
> On 10/27/26 6:55 PM, David Hildenbrand (Arm) wrote:
>> On 10/27/26 11:35, Baolin Wang wrote:
>>>
>>>
>>>
>>> Sure.
>>>
>>>
>>> IMHO, I'm not a big fan of adding two pmd_none() checks just to avoid an
>>> uncommon concurrent sync.
>>
>> It's what we already had. We had to: one for handling pmd_none() directly and
>> one for handling zapping while splitting (file THPs).
>>
>> We just managed to let the second also handle the final piece of the former.
>>
>> Anyhow, let's get this fixed.
>>
>> If you think the code is clearer your way (where I disagree)
> 
> Fair enough. Though I have a different taste, I'd still like to make the
> maintainer happy. 

Don't worry, it's hard to make me unhappy :)

(just a bit overloaded right now)

> I'll send out v6 tomorrow following your suggestion.
> 

That looks good. Are you planning on following up with the memory barrier
optimization for smaller folios?

I hope below doesn't end up in some performance degradation.


-- 
Cheers,

David

