Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0CFCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193536B009F; Wed,  3 Jun 2026 09:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143D46B00A0; Wed,  3 Jun 2026 09:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059536B00A1; Wed,  3 Jun 2026 09:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5DAA6B009F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:09:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E3BA1201F5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:09:12 +0000 (UTC)
X-FDA: 84838632144.05.F96C6AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 977B3100016
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:09:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D8MaenF6;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780492150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iCrnVesN90WLEg/F7QmTL80caigGa4JNAxhwpSDrHg=;
	b=1Ac3roT5LyYiiHkkOKkLsAunv8hVua6oSjh6l28DTEUZCuAhi4jK8xRy5RFtpprwHWtcHw
	cjY+lCzoa9REwC4EwBXoP7cr5TjqmnqdZfXPapbhEQUL3PIHW6OzVyVC4ypSuYxkjNILC7
	nOUstmTqx+9f/qIWD1Cq9+4a8rQRgTA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D8MaenF6;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780492150;
	b=Is1Md9MmQoNv+Emvv6SD+V/teykuC4G/H0YOM9khz48np2kvg3aI+ZnPUR6acaEY9GmNf0
	4+F/v+SZWMrixWNotmE/c5781GIYLkPdtabcemza1gRACyedc5JHPBGfVAd6sjFwQ4tUD+
	Qu7JnI0tkFgxn+/8bCWslJbO7fctgw0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFDFB40681;
	Wed,  3 Jun 2026 13:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DC31F00893;
	Wed,  3 Jun 2026 13:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780492149;
	bh=1iCrnVesN90WLEg/F7QmTL80caigGa4JNAxhwpSDrHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D8MaenF6jTRpvWgR1BIHwbjMyumZJD4IBjMjp5MkI/92JV3hT+hKiYtSgDsvV1q9N
	 hXiM1XVArrDY7yF57C9dA3LiWKvmLVTow9RCfNvpH5bIVTA/+6WkQxDu5fWSbcpRSf
	 BJ/PRK2SZ8TXx+kiO6aGoUKamOhBkTtOuaG7Xt4YTBCwEZ3SglxwO3+prtnADkL7Zf
	 Wc12Ml5766LObLu4FD8gsYzJMRt1frHvsO2iSwOvgG3bGDJMsbq+vRoBVgyNABp30k
	 MYq4csbxm5nEOM78h9nFB+yvHuWTUJenl1Zmf+nImhjL/dgBRSb67zTUPKh7WjszhU
	 YoFKnlRyVLK9Q==
Message-ID: <fc0cf75c-5740-4e2e-8b21-ab59c8517ba4@kernel.org>
Date: Wed, 3 Jun 2026 15:09:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] mm: rename swap.c to folio_lru.c
To: Jianyue Wu <wujianyue000@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
 <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-2-ce0219e100d9@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-2-ce0219e100d9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 977B3100016
X-Stat-Signature: 6t3xoysdo4656dea1ux64u1kwbjc7zao
X-Rspam-User: 
X-HE-Tag: 1780492150-240779
X-HE-Meta: U2FsdGVkX1+EStCiOPpWtNb1oOW4WixapzUOxbkHbrlzRgJz5Extqr0XTxWKmEHJoIiMN48Xu1teBtjyNxWT9+J4HLNEUyiC8iuisNteABgizpK5p+LadMEdcQnLZo2wlyX+foXF4/pcgu9xZTGXk7CCvGX1uVewm2hEPmPfBExNLJ//UkHK7L4bJEaLS5/K88Hg5XP9lBkHcVR8lwhLzGn+mJoJW0LBwfjpLl2XTYXqWbHBuLJjS8taU4r95LT5ywJdvz3mflMi0H//+Znmv9CCGmxV9O8OBUVE/kma42FUScUHV68nPSp9qfDuOKc9Zi8L20UUA+tDglXtwrsFPxaGDLgk9cFE3mbpomv4byA6Ue9VuNaK3hN3udoA2b+8Je/QA61luVBLJ9SYNS2zTB+K9pWsBdPvuQTJYt/9ooycfbWAj2sNIc1KLn/SUebRjNJm4CL3pcePsQoSV6sy6aedUq/f0mywvA3Qr9t5YeoxRuWHoe25C+/632hV8YGGya0VUnfmG9Z65AWyAZqo5Dms9oVJxHEodh+zWtIWNiSSCysVqcs92miNSeRvpZaHO1N7+AsTSzuZjOZoLzpHDVdbkMmxUYyAdFUW+fSQzMGiydwnZc3ntT7QEYNcaMdHNTLWxXsEtK8AbQLtyIqa+sQMGOYA6Lc3AMPfkkqqwkCBwHg5qNSuaS41Av2EaL7nduMk1xXnAIn6ASl0Ydux7qWh9NcsVjnvfBIcRjrIBYpEbTamlX8OT6ceFyWye5dmR7FwBu83paaDbsnhbbT9MJyM5X1OOKs7eR9+0xPrqSQcgnYA0AWTTRa8IZvkln66W6TVeB5Z9irKEd4p4Qqcxotx5TNhveAowvlIQwJ0N88oazOd9aa/VOu5IFk9H4ZMpXJMktteRba8iKRxahfg7y6/anPDl+GApcuUvh619avPNnkVdQuBIhDEEFxHPntvdbL/TlCv3J3B9RGk+N5
 vnQg/3Yn
 FxdLmbEW52FEjVoBJhF2z3PXr0o0OC3Fb8QJ0DKRh6QvnZdbc+75LFIp5Y7eFPeaC9ZSJlhbbaGEKC2yGmrF8fliiYCHgDcrxEAHm+Lz1ndZSJ32jUS07YV7qKG9pfR9XsnRf3sbrrB1fknOgZvStRH8WZcGmatUmty3GL10GkbQmPezjG/fTDt5o0CSHJDRXPYiapv/OdMESeHrg7GOVYQxZf8RCKN7y8nZN7f/kU5wu6x5VQSzzqS81XDRKND26qXZPB3Ca/qEGtykOhUSnCT9Fsd4PurVdPavZ2I8c2Nt0oGbAU9O7PTXLbo+0mNyrxzXEpfeha3VqFwEnoj+mFoL7aiB4+dR7bTKQs3aWkl2obaxsg9zeXgL8VyESPkDXG6E4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 15:05, Jianyue Wu wrote:
> Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> the code's main responsibility.
> 
> This keeps the implementation split from swap-specific code without
> changing the published LRU helper interfaces.
> 
> Update MAINTAINERS and the remaining mm/swap.c documentation references
> after the rename.
> 
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---

We can later decide to rename it to folio.c But maybe it makes sense to keep
this LRU batching magic in its own file.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

