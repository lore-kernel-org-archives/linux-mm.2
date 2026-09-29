Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF29BCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13246B0098; Tue, 29 Sep 2026 04:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE99B6B009D; Tue, 29 Sep 2026 04:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7EA6B0098; Tue, 29 Sep 2026 04:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEF56B0098
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:07:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CDF1A6AF0
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:07:46 +0000 (UTC)
X-FDA: 85266070932.22.FCBFFAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 60A9BC0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:07:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WtB8pQgi;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHBVyhDkbm1V3a1aezMPO9gQX7TpGk0Co4n2cZsE6YE=;
	b=WVzk7JeFUO67PtU/NXvycdNGxjYnCqgYf5i7ocNYoLQZhPSwKzjPRxsYid0NB4FATWlLkP
	4kgexhNZDhJNSppB4mT4g9EihEcuffU/wruNEjfQkw4dqudPJ5MvGp+gB0e0gCbFcDYyiU
	WRbWxrVB+3XiA+nugaJow+Z8tvXnzbc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669264;
	b=vYEGw2NvZg0ePTcEdQbnzyANrBuzVLeKmfVeOGQdCoR/g9D/0KsUO2kOFMXRDGptnTw8sk
	MCV2SB8VGb0uuZWIo/hK9KhORAawa/89II9ZTIiwlqLPe33DWypoydOmFBI52EXI7Nunj6
	GOhPcd5cTiW/1D3sPS8EDnVJufJCrcA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WtB8pQgi;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E079560210;
	Tue, 29 Sep 2026 08:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED541F000FF;
	Tue, 29 Sep 2026 08:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790669263;
	bh=yHBVyhDkbm1V3a1aezMPO9gQX7TpGk0Co4n2cZsE6YE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WtB8pQgilJS4MJtWGdpWyodyJimUNZTgnGOKWYFR2F7pfekvMj0nvNQHvrnaq1gs9
	 yTNh5yDCOMUv1o7t4hOeOMRZYrUh0pWW/2YvvRx8qvODV0A6lEWb6eceWqdsCqd15i
	 buptOyk5a+r0m7V7gf/GPpkOoNX1URh+dTIZiaqeivR8R3Lwwe850rBz7u08bFoM1X
	 HoR4Jegtmy/9Oizz2emVCBuRQ8W1KpE8HBPgjmGUZUxB08gKuqqrz/V1GQxdzaSJdm
	 JYss6EQ4zbXub9toIP1pu3Nvi7KmOmmHM25+bP2gEJio1dq1RJYhs0NOb2NKGMHzjI
	 hYP5JnL4rQrhQ==
Message-ID: <16f16e77-05ab-418e-ad06-8f48fb29375a@kernel.org>
Date: Tue, 29 Sep 2026 10:07:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/4] kselftest: mm: integrate huge page checks
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-3-cba7359d882a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924-fix_split-v8-3-cba7359d882a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60A9BC0002
X-Stat-Signature: q1g5opr54h93b9qjbwqaq4z56m854yer
X-HE-Tag: 1790669264-796934
X-HE-Meta: U2FsdGVkX1//2cAofwnQxL7WTouGT68HAzYPQ5hsAmbGR36vz1CAVmml4KhRqvPaxllFPesXNJ2wXR89PP8/w+KT0IRnA/rmDbqSB75PDtNsHYxoEvIrz7w9J6XL7yWb3zdKpB2+qrOyWJ3zDdF5kpBMV0CxskIKsy09x3eFYmB7bf3RW4ITy0RKXmefvJNTycRp2MuHueGXQK/mn+YTERkog8vYK2A2dphFdDwkPHywCx5FB8wgePfdE4W1qJWBqD97hDvBm2yYy1WJmtcyKHqD1L0C7YcZPEH1cxIi4i93ELnabVWAt1Uue0HuOOOsF3oGlklM5Mf/hAIaiM5LiwsvfUicoEaA3/XJzGZJw4NTmJa+PlAl1IjIsm91nd0SIwfbe1k8/X8QxKKh1/xmfRhRqe1WPGJNQyA3aflnKY6x+X3GugGCZpW4mSUXRdS82vTIg0GtjeC6TLV+rF8olvNuadKqkhvnLXaLIUHNBVtiXYkuPw+yBgnS1n3uSg98/xBGI0W4pnLA2Sl9c6chf1sp/qb4wrVp1AxEvfZGVKK5fNNa2ECZzBsTapdeRUO01G6PruxMV0ZEPl0hQNxAboL+bd8UWGjkjF0VakFgg9VU7000eV6NCQvzHgnlCmFyRXhmg0FjkTHNf51fXA0zm0UkGKdxCFHCpr7iBzGUyF8rIWO2kefdwKsMrVehJ/oBs0k8Y0xN+bPPs3+rfboydfsLTZbdXO9Sz/F0LTinCV1qi0/Pj9aYOuFyQprgbTV9BWOknoSp89TgKsxFbkQm9wyOIB/J0HQ0+WYf94TzH4iua7trgZLmUNXN/FsqayQjeN91Fe+BDXU0SMkG5Zn4ymzPe0mZKYQ6DqxduZXT3rvu4DiHbR5DQKYwigIDttMyOj0doDreYTGA28bzPEZumi+SkQC7PBsEapaoMiqZoP/sTcBDnwDHst4gatpwdy+DVNVCtA2X3WhOII1d81e
 fs5mfqiO
 2O12yJKZsQS+tzmA537/gZ17T0v3kYbTEmgcUleAX5hrhzNTzPhwKq1mukUX7svjuqRHD24SbK9w2L2NEaROJCx9mK6kQJQQRrJDPyH3cPfpcMrTsszO1WZgbRuv+evGtOIgp9qLEIMwJpB/pD1LnqgEBubmraNW/vjn7PMoLp0TbTRf0Jy091vPbldiXiXkTUCnl12q7n/y1yUwXKyDsELHvVugDETB96RSDOAbRIdlgasrqo8nGuIkC9i4kHDj9RnJYtLxwDYdRfCcejrt8vIWwV5n2Q4/49/eOAe0aLy0bxz1TlkQvZHekkblDWeNOf3F1Z6javsBFCCcuFXuInHBhoYt+0oLgA78rPQr7AitPOhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 21:11, Yeoreum Yun wrote:
> check_large_folios() only checks for large folios without distinguishing
> between anonymous and file-backed huge pages.
> 
> To add huge page type checking, integrate the huge page checks into
> __check_huge():
> 
>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
>      check_large_folios(), since only the mapping type matters. This
>      identifies PMD-mapped huge pages.
> 
>   2. Otherwise, use check_large_folios() to detect large folios. This
>      covers mTHP cases.
> 
>   3. Check the folio flags according to the huge page type.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Instead of merging both things (detecting mapping vs. detecting anon vs. file),
could we simply perform the anon vs. file change separately?

Doing another pagemap walk that focuses on that should end up with something
that is easier to read.

-- 
Cheers,

David

