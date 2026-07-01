Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC8AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360D06B00A8; Wed,  1 Jul 2026 04:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338186B00AD; Wed,  1 Jul 2026 04:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250006B00B1; Wed,  1 Jul 2026 04:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F17216B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:58:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81C0E8CD32
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:58:30 +0000 (UTC)
X-FDA: 84939606780.04.7E25B52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A85FE80005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:58:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SNR4/jqH";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896308;
	b=flIYf2u/v5ySMWAL2ILpzslNM6jCaZc3o9D2e6q6cVRMiloM1SewZhpC9PQ9bF7vq+hjMZ
	gyp3ROGzxkSHwC1A6UlR7TEy9jBwChrxP25TjEWt85P/E+vrzXPgRZcuTYZx+u87eE9CPP
	qIiPhF36f5eWINSVFupXomrj9ezhF60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smJ73gE7u0WyQO8ehIDxsy6M6KLNAvhp1JZyQAMo/iE=;
	b=Xhoz997SXMP4xlt4p/CXTkVS6h+0spNrgVUskEaqJ4R5yEKahuXItBxWKWoli6tvGkLrsE
	GC2ZpWRSozxhwV7NFU1JzeIdF7Bw4k1ysfrnhV62+3TF75GRX9uKv+d2fbRYO+j09jaHKj
	iHMPCmiZA9BUX0jCw+WvHvsDUlSMtZs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SNR4/jqH";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A14CF43A3B;
	Wed,  1 Jul 2026 08:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73391F000E9;
	Wed,  1 Jul 2026 08:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782896307;
	bh=smJ73gE7u0WyQO8ehIDxsy6M6KLNAvhp1JZyQAMo/iE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SNR4/jqHyn+ZXEFOITnupWzqpexL0pstS2dYgs2AWYrL65oQEUlYiCLSxsVdEgWdE
	 nGkndF9FfXVPACTtiii9LumGOkqf6rLp+fTi92cNhefAsgL0FCRa9LhHUJOIXJ8EfY
	 bq94Cn2x3dIHB7tzNvX6iytT5RkxWGsNXUrFmEwfula8jz8UndgUMIXjjkRpp7n6/s
	 zaVP8H5r8ABf0j11NWD7tELhhFltJzwwHiQv5AxJfmLPKdaNG/bdi6uCh+NuVKX/Bz
	 eK71yBTd5ejWAPrt9GV+oKSr2qoTty+JZjaEZnvx3T+yyVWV7ntl/I/2KtegKOEF+6
	 0xBj2gWAtZ00w==
Message-ID: <53edcc9b-e89a-440b-9d12-7142a561878e@kernel.org>
Date: Wed, 1 Jul 2026 10:58:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-4-f4ce3930d10f@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-4-f4ce3930d10f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A85FE80005
X-Stat-Signature: ia47a68yswq1urq5c3pcxpu3tqj6y4hm
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782896308-171021
X-HE-Meta: U2FsdGVkX1/y6fLoTEi8xhHYzDQbCuv7+67yqycIOzCv0FVK/CaTL1NqcyTn0M000hu0euyEZufAgNWd/9Ccu9hR19/wNzvK4uf99e5G0A5OkBGBNqhrvkYLH0jAuCaSERs30I9NZZh2rjHGXU+NJAhx2CinPNoba0UOPY0aQvrjd6LYG6iKuseVIFBZemKb2t/RIOThv0k/4zm2KC33HCjR8SYZz7mE831e/9e8jFrmFyZhthwmw2RBTG6HZiV4s9GjwJYgImuaIqcZGzBAigQ9HgTy8QjugBPF4JivP/NmkFkKGb8Igr/cf1V6z7RNQlYsEp76TG3in5VOBlOfMrtXQ5t8gpZooSytkbHcOSyiH05TguQr642cheUwTwPKf3FW15HluLiiFfsNEU4Kot/VDMjAFiizSuRVpFrC0h8Pban62zl7+0VoT90qPbG8aSqDHm5cak5JP3DzvU+DBe4yHPe6FUvU0ZE+O9u+ed4u2mczbmGkF41xBkkxDw9I248aMVW0t5V1l12DLcitcV5M+uaw8tmrrIoqSX44NguJQnOslDQFGA5Znrlf+12VZCPsjX1RJ9i6HVqo0he+v+vHKvX0Ij6JsBw3ZgMq/Yfrol8eF6+e+RanZCSeT84Y59kwoP6WZrcpvwTTSur7LZOU7+i6TeXhlIbXveL7MiOLxTl+i2ER+lW/3Xeb31fIA2CDzDsosb+ZD3heqXBmzHCSEtPaA8pkh8K8wgqIyxyr8X9hNweVUDjVRxW7Dxs3NJzQRbOqCYvZNugPyi4oGmLquKL44PZ7sUGlo0hz+6KMA4gqBgdBlpRb9vrC/XL8kZ2KYejYu81MGD/CCWTavbYkBjCir8QNGWyQrrHo8L/3XwlWFrOHS0hCQ1mIPYbtk55sqedY43bT5iKQw+PFMfqK69o3Q6bKqDj4H2/f23MNTSupxbvhWnL/aeOzjNcNVjF7lmCTfBX3PPjBVP6
 6m8ASu0I
 hkBNOxBNks9CN35ETl1Uq5NAuUBRyLSLSZvlbx+u5otWynmdBFIQW35iCJa9E7fnYii1v98qIfTWo/pZJGcdJ6e5cjBz0ad1iR0BNexIL2Jt/SuCmXBHKlQW6TKY9ForVFPNNaFz207ZyQQypfiNOFSbexLztLG7mcMrzgkoZtbZjoPtEKWgciG6ckMo7ULpKCOFZy9CNPvHNgjYKePQPTU0dcpSITn8ZcXI4O7gqcB5go/h+3XLDGU6lCLU3yA2w1xccKpwMiDl6QyHXVWPsWMCXNi/oIxzDqUX/EQTYOvIiWmrROLrSLRrqGFZ0Nol7E8VKVCxevLvyAuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 04:56, Zi Yan wrote:
> With the subpage->private == 0 check added in a prior commit, any allocated
> compound page should not have nonzero subpage->private. Remove the
> unnecessary subpage->private initialization code in compound page
> preparation.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/internal.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..c96421ce9350 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -895,7 +895,6 @@ static inline void prep_compound_tail(struct page *tail,
>  {
>  	tail->mapping = TAIL_MAPPING;
>  	set_compound_head(tail, head, order);
> -	set_page_private(tail, 0);

Do we want another safety check, maybe another VM_WARN_ON_ONCE?

-- 
Cheers,

David

