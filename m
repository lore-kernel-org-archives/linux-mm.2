Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1992ACD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4C96B0377; Mon,  1 Jun 2026 08:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C8E6B0379; Mon,  1 Jun 2026 08:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B96F6B037A; Mon,  1 Jun 2026 08:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4A36B0377
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:23:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 256C51C0AE6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:23:36 +0000 (UTC)
X-FDA: 84831259632.01.C39F26D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58B87180014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:23:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+eMkbxi;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jL9F3lhDa+fKvFgKIGzLd1nrDxZ1QfJTb/ldHq2VUY=;
	b=yTH5FO64oD9aCGKRoA6W1FhgDW/ehxeZ21dOY+kJK7650p/AL0IORzjnLYgCo+e7lnh6xs
	l5clYK0Mi96kSaoqQkHf1o+O+UCVGVkVDjiQ4m7ShMwxD3deNsSti4Q2vNLnBW8PKa1akC
	3zGmmqpAocZruqJorvBn+ujbFGIChXM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+eMkbxi;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316614; a=rsa-sha256;
	cv=none;
	b=OHrfnA888+nD8CHTn6o6iOahS6ZJpqBjk2bRBbdp0btLzO95NdCr/ZWbeSmIyizIbyVW2N
	048jsIS/mFahpE5eD6Twz/LgFiLlV7t00ZvvOVxzfJdCIAA+I2RRpDndocsscu06VtUv18
	mTwRF+Y+XnjA555WlczWvctai8PicPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7EE840732;
	Mon,  1 Jun 2026 12:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36061F00898;
	Mon,  1 Jun 2026 12:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316613;
	bh=2jL9F3lhDa+fKvFgKIGzLd1nrDxZ1QfJTb/ldHq2VUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d+eMkbxiEzNQVN3beMSGIxtTo/UBQjNwIb0lTvrLMpXxhwlmOdQP+/MUDVWLqaZ7b
	 jZHZeBlkXMSGV+Y0K+J9yo0l0nLfknUtjh7yDEt+OCTHeIWOTb8Q83PG2hyAPwjZN0
	 Qu0818JbsOuhfgLEpwAmPevpFkSFqsZ1uPrvkWgertlNVlh38Ine7hDv/3m+OVV7M7
	 Ov4iEl6zMTBGlddA5gMxDK/kA4Kol1XeirMPSCP0V/F4ajKZpMSgM6WWU1Try/0ViS
	 Svdtf2/4gYRCFE+oFNXU/ofIDkG/z4bw+VQqaRuBsvfoxOJopm2UsDtI7k0Xzy+liO
	 fGXvRG/MqfyBQ==
Message-ID: <87985f48-2668-4fd0-aae9-3754d2f6bd93@kernel.org>
Date: Mon, 1 Jun 2026 14:23:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] riscv/mm: drop vmemmap_pmd helpers and use generic
 code
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Andreas Larsson <andreas@gaisler.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
 Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260601084845.3792171-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: urstzgtuaie6zaoygcqgaq8xqn58dyuw
X-Rspam-User: 
X-Rspamd-Queue-Id: 58B87180014
X-HE-Tag: 1780316614-881184
X-HE-Meta: U2FsdGVkX1/xYpUhFfuNseoFIKU7cY8vZ2JWphE5EqAsxRqE227d05G+MBfryATtkvw5fDozLki1ovP9seeF89XG7Fvdou0ANY1pjqXh6bBKvLEl3xFcWYfEQzD3VAXFbthNXlp2lBR5gbHJbOVa6G3L7x9nplkMDdVS9cMKcT9hG2c5AmvaVQF30hz6YXi8FbbYEYOkm+4H09XZD5UE69Ax/VDj3MLZJpckw++erjOM6BgxvqVC2HBxysAGjfJZaN+0F4ykFjhWCq5HCUgtbkTNKEYWfwUxq2eTekSTZEsLwlGx1RBm2wUg7dmxNo8IrUksjYr/OxYfLwpC6L1ftbAiM31RxmvfvlsHEGy96luOeQOlqdDC4cLXm/KF6HTgFv/oqoHfM1INQxic87tAe4i3OxOHnJ7qsz+X88mptxfpZl+GUu1+TVDSSZwXAqVPpDwanAantt9qmK/A4hVacSIKijlDK1p8p8dSeKX8Did+MmnqgdZN6nC0WvZtmFC9CNKusTALT/D23lB5yVwK2cM/jpIwfxw66vGRvNIA4/gIdz4dLY4XFj5UCdHTVC5gOWGjmH5rGrYXEyyf3nPxCppH0CIvBU0FCyhDOAnqUQkFOb9c/80lq/9092HhazA6yzXF2QLo0AVdPf1BIVnrZTc0OYFePVpZ9NrhxUBfwRKvRuKHJi56nm57O/D5ZXnBrgSgMZbQChxCpVfkCGw0JUxyaN1XYXCuHhR+MHcfVm2N9OlhbejywhwW2uc6N9s/9lpn8aIpDJlGCwEntQx/VQc8IQIw57/w8/EBiqf7dBT+pMK7yNAr09ovhKqxbNmRHbR/0x5CitLusnHdXf75rRM2MkcxnQbNlSnZid1y+ACJwjH2g/YUjmK0kDw7H3CcuyGwD7l6OYaXJls7L06bA4sAz5FAXpq89/8Jb0s4YNNEaex0ofrQ68bsgyGIFCK2PthktHIcaWX/cmq9jjn
 oUqhKKtT
 VvgfhVP6am7wQP6oOCXUWqdhIhFtkT8TC+6ZwOr7figt4ogNXA1kWGBi3bVHTSnMdjSScqvSOuxtu+SxTdqxIroldOMofo9lVlsrFnxGPjgRQIKEHpErOwK4tZ9m9rpTsDuVGpq9Sy4SO3ViF0VVQ1+kRL4Ll/JLZTL0owlzKsqvuYz5qkfPEG/oKR3T1Ukic8nCQs7/TityhqeOSLpU7FG2UwJfKEazvgVKS8igZewmcd9eMC97NhY+MG9F32jMcGdTl6BuZxejrVC/G7uouPtra7p7n424ykQmxEg/ptZ+qLgk1IwlLrm3Vs8HEdbyavL3BZbDQbxSebgCyei7nht7od2JmCMxzPUzNMUxD4Xm5w3pVf8bKe6iFixsOuWVfeqlVFWEPbqkDGwwk69f9fU1TX5ZscO6OCfIsq0eAaWGo3L02LWg3wFRzRBuHou/5mCaoIV3cL8WLJLX8gJvbKwT4STUYfLJlo0N6Za6l4TS1YtGSh/v7/vBsew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 10:48, Muchun Song wrote:
> The generic implementations now suffice; remove the riscv copies.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

