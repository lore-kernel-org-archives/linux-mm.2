Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886A4CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A576B009D; Thu, 15 Oct 2026 07:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B876B009E; Thu, 15 Oct 2026 07:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949DD6B009F; Thu, 15 Oct 2026 07:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD6E6B009D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:27:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE7F814096D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:27:57 +0000 (UTC)
X-FDA: 85324636194.15.BF8E0B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 328D08000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:27:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqJ9kcHS;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792063676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXsSRizV4vzG3KaET6Hc8xgwXefBTYQuN2Tim8MOvBI=;
	b=UVYPYQOr/+W2bLzxHpDa1hQuk5SPYtZwrj7eXvF7/lJ8nTgdB1aLc1V5mYvSDq4w2HPSs9
	4ulmvIpgI1xwpKoSO1xwlSmwFMG9SFYcDm7Pac9foAF5eIW0x+woMpQS+X70N16KWkiO1A
	dRwAUV/1KIp6424ansxKvKqpFOuqd9Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqJ9kcHS;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792063676;
	b=2uzz3a4uELG7vj5kj4Tdi9Jq5Xx+AKBtuhHOHyA0YPEPX4gML9Jpo4C15TP4ZCX/tNm6dZ
	EGjrG+Y1rE/G2A1cywDLMV9lWyVAjbdH7dDCV/chwy+D6kwz8Tb3n3gaO6IThrt08jz4Zx
	FUF1fw7wG9f+c/OUyeI9NGvWuOD3qcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B242760052;
	Thu, 15 Oct 2026 11:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2E41F000C4;
	Thu, 15 Oct 2026 11:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792063675;
	bh=IXsSRizV4vzG3KaET6Hc8xgwXefBTYQuN2Tim8MOvBI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KqJ9kcHS6Pz2rQRUakmlAiz5+evcvoGkAQZ+fHTjQgF7QsvrjNt6qc9GudWVXKS79
	 qk2RH4vGyLHFOeYl1kePKtkLYm6QeuZ/vQBX87z/N1Ip63nDG5Edx4QZI8OVHidaFS
	 jfWLBFsJaztuQk2gOlOv/3YtD4gAAGkW0jb/rBoWytbBjbYZh+aT8hbgGgx558nuYC
	 kKaFMpWT8eR9rpx9DNKFnHS3jvB44sY+ZkKRcffQEBejW5xAP5o7T3AP9udBRmrKKQ
	 KDfqf95hhbEH5xkzYZk9UmZ1sX+EW3Jn3ztrV2g3JWw60jR78BpFI5s5z884mGmG7l
	 ooeHV5bZHOuPg==
Message-ID: <60fb38c4-b9f3-4146-ab5c-ed16c95a2c7e@kernel.org>
Date: Thu, 15 Oct 2026 13:27:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sashiko change proposal
To: Pratyush Yadav <pratyush@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, ackerleytng@google.com,
 akpm@linux-foundation.org, chriscli@google.com, hannes@cmpxchg.org,
 harry@kernel.org, jack@suse.cz, liam@infradead.org, muchun.song@linux.dev,
 shakeelb@meta.com, sj@kernel.org, ziy@nvidia.com,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
 <2vxz4ieni4w2.fsf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2vxz4ieni4w2.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 328D08000B
X-Rspam-User: 
X-Stat-Signature: qh9ya8ytdnmyg7i1os61i7m3btjy1hc5
X-HE-Tag: 1792063676-119925
X-HE-Meta: U2FsdGVkX1/bxQrEcCEhpdwq0N00ly3QD13hgR4mBEB2wJhYkNBkbw/vnNL9Ul05oTBXfmKcbnHHv3362mg6ZOGla8WgIZ/UxHT5T38yBUTjths/amA6ndO5pHqel0p7qfOzaTYpRIH3So/Jv29qmq9bM76pZLZOphUmZBs/KwxXhvLvzXEq7KWZLKGBxvW46wvhYGq7FZcnh9+Hfbfp8y/1u4MwjH0DgT79WM1FtulorVOw8VN004FGDwE2pOJX0ELsD5PP3msNFH0u8mkmU5i4GTC3JpHN7FQZqa50wkKS6G77lmjRDfUgqG7kGz0RGg6vuVJNaQMqtokJLgxtJAZxEPPtNuII9f1oyhE1VL6qK47bi8j77vdx37rsCyV8hsoLQERsYvHK9534OBI99sPq52B5bB6hHv1i5OrrMnIcljNBVy8a4m96othmo4MVzTfAffgEmelsM3/Bv18Abq8fItnhNjS1PQE/zGDSicsSM3bbbMqgnQaJA60/TOyx/m4xe3Y7vYwZ+v3pdvmDGLIY0XpI2MjzUoM34LT/zGdOCaI/GRhuJlUEzOjfRRtbWYM/GTx0wHEbECgTe5wHVc7I8d7yFFRgFkGPwbzfVb0pvrUl3n66EhSJKDpjTpadKxnlJszVs9vxlEp+I56DIk4mL5vKyXAYy3NTrCSJmo1hw5QrQZAqtMsoge1GvNxx64uGfI1pulnUTVQIMLM+HPJNtx17skupu+0GoU/z8+ID3EQ3mJbpz6Ti6LaWib8r5JcBpeluIBcGbBdzjob4rzaMhcjoWZE0IYfWCWmpw91Oa3Hnf6ZmGuDASIKWWXY9JAarClYMZlKaeGLi0qQpDrw9dHKJbK/k03fchetVUiN1hFrtIXqLCryZ6tRND58lUVCJhLuriZ7eSu6Xo+JcdBL2P9bJlD3pz0p4kHVXuMFT/L++9nLzc7cm8A8LRR9zPiTk3pHYC3Om2Bz89nr
 S7ejJXdk
 gl8Lzz07s4Biczjwfh1oBv06rPWiOlBa4HZM7DNsLXlzBT0qkc7WjikM5Ieog90BGb7wDM4O8yU4nxNeR8eNYj7b9PXKYRllYPBL3NpXx4/l8xDyGX8X4fsqCFk4135nytjLTFYIejzZu/pFpmfvtyGKYD5MzIKK3kx5td6W1MoiqaW5ZyxCyUjDk1GVyUnaOrFeh68JkPEfoGr0t9IOa43bqewQp+fG8vJoy7dQFbDJ/vqidk6k/b1X/64wMPpoIBD610wOnJeM02AU1RMf+PXVJftSr2b45zsdJkqxjr+O+0I0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 13:23, Pratyush Yadav wrote:
> On Thu, Oct 15 2026, David Hildenbrand (Arm) wrote:
> 
>> (CCing all people attending the mm-next call)
>>
>> Hi,
>>
>> After talking to Roman at MS, he just informed me that sashiko now has a new
>> feature combination:
>> - "embargo_hours": hours before review is public + emails sent
>> - Mechanism for signed-in maintainers to lift embargo immediately
>>
>> That solves the key issue I had with sashiko: people/agents re-spinning stuff
>> too fast before a human at least had the chance to jump in first.
> 
> If a sender re-spins stuff too fast after a Sashiko review, that's a
> pretty clear signal that it is an agent. 

And I know for sure that that's not always the case.

-- 
Cheers,

David

