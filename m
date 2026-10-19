Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53944CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656C46B01F3; Mon, 19 Oct 2026 08:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6077F6B01F5; Mon, 19 Oct 2026 08:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51CD26B01F6; Mon, 19 Oct 2026 08:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 338CE6B01F3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:11:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B312A140641
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:11:56 +0000 (UTC)
X-FDA: 85339262232.25.7E47EAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id DF2444000F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:11:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxSjQ2QO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792411914;
	b=imBEaZyHkhVPhYybZtdaUYi4SndGPMwo52zia08LH4MOL06MdzWEVLsRrkX5aD3tcguQDP
	G5hkBT+uhKJEh5Gy6uLUuPkGm/GlftITWdToQ5R9kgLhzKQk9ywdrvDQoo2PY/xKh5mUVc
	bNVVxFnUbqPkFGsXFCjh3j09L262JwI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxSjQ2QO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792411914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4v9LYOxvac1QwzfDmx2WucWGZrVDPX5QtjdV2w6GE0=;
	b=hF//Qg4sg1yalPhcQifnNrZ5cML01She66+pfydrsrkF7VfYnvwh5PcJhg8S/5SF7dJpq8
	udbV/f8vKv31gRZqeTkx8epOmdC0nSERoOoaTyZNDvKMYgacTWW3gi4SkgpR/X7ZOcYMeW
	2j3rrLBJzbkTjdXGppu0r6XryrTz5GY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1638C60136;
	Mon, 19 Oct 2026 12:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906DC1F000C4;
	Mon, 19 Oct 2026 12:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792411913;
	bh=c4v9LYOxvac1QwzfDmx2WucWGZrVDPX5QtjdV2w6GE0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IxSjQ2QO63SyAZWHX4cfR09rvJa2rd2t6yEss3br/Nj0ffZJMmbzrlI27AnhBfBKK
	 +X7qfVbMsLDJ1OFqv8Lc6dw+l7nQOXF8p/GWpFzzhQYT7lMHl1cAifCPuPMJiASoeW
	 C0TPxqHB/7o+voXy+2nKB2cGv7iJoSE0C2uiPl7Co51U908q2bwaDt7jGR2MfDe5S0
	 8DcXhOD6VQOkD0xGN7zbGeLE2Zf/kZDxZMO7M1T3J5WmGKFx92RryLt2p3qR1xy2/Y
	 du5SvNLNsskNffVO7pBWh5OrD+bhZJpcpqEqJYRV8pY7s1DuKAbthUvMGsqx4x8e1X
	 ZLEfaxO83/FoQ==
Message-ID: <7f92a5c9-d072-4a3a-bc19-1fcab64061fb@kernel.org>
Date: Mon, 19 Oct 2026 14:11:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY
 MAP
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20261019-memmap-maint-v1-1-80850871d0cc@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261019-memmap-maint-v1-1-80850871d0cc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: DF2444000F
X-Stat-Signature: 8aabnojmyee15qyxkgztydaj66gai56s
X-HE-Tag: 1792411914-376479
X-HE-Meta: U2FsdGVkX1/q/UKva+hgKTsUQBe4MqaD/eKDTbKqPDfg3xgbBFlXzeqiHvkLUn2DSsoOetvNMW7cMyammBgdu6WAo6CVmnOJXj+sLWY4UySoYDKdH0xMLLIjKH/QscnyRwvvKB1QS0kBqLET73DOtxo/RpLeu7FpcsARhwPH5XEZED95aj8aEmPJqAQZcD9FHYwjEoNBAszFEG02hHS0d4HfAtSEmEIDO06JT/vABIMDKslhgZwvPohQlO8r87GM/0pC3/YTuOWivWtcAYplyBxyzVc3Pk3kWnCEeZTJjR7LYCd8xLehx+yyBPKPwgP8eDJQLLXAuqyuxXtxJg0J81E1eF+waQK2T18fiwRdUQy4xwsk16ellMjlN/jfcvOh8G7c/Mrq4m9eDLWa6cOqzYTYEjuPMqaqn9gsl6x48dZ8VtSfgAtsl4eT0XJuYurqKD7GUmE/zVCQEJucKh9+/ddYFKaSNTAzGkHMTJQFIN2jlxYQzi17S9iB2QBobI3Xaon6Y5YiGZNJ6ZQn3YwG4UtQdCsxWeoUw2LKiHkSpwFrK78pORM/8uY4CgSK7Y/FYc6tp+TzevXtPllHHjwNoLDUQwo7oqlqAgPuRhlm+uZRZlumKJH8ZO00hAKQt/rdsfUf18MuyF7VKafWTxNLye+HqMdZySohafqqhNE9gbkJE/hJYp7uIEel59Aig/bxF7ClhA/tZq1XnEmVrLLsc0RElu/7RAA07ZpPuKgiSYFSNF3nmRTRA9WgOcpZDKwMNXAwczFQFpCGGurot3Zff/hWr/KCuJiWcxibb9Nty/YKzG1FiSks7UGuQpTyjbUjKbDedQr3+4ojOBtupzSyChP3tHeqsgHmd3prN6fBjS5OsFciy4iCdYAkANAlhWnqH5P8Hakl6coG63syeyFyv0KZYwIgYiqRfgjvbMkjD7PyDxImZOTPhPUmzrbUykVHUv2/hH8vlTT1ALHCZFs
 pIic9mxw
 mnNlN4sUAbdfnu0ID0JH/2Oozb6T/DUfBlAAqSqwFyQCTLshsq00wA4vYB9GPJyvw7P0MYMxxeaZiehzOMjsuzJF3gUZzz5PBoU4P8FXX8GRPtGgOv8NYAOEr30CAkbhWmt5YF0Wwu90B2OTvjh3G2iWEmEJdo1fHsfFf+Ek+sslVZmv6AzADvf0vsTYnsJlUofkU9Xb5+WhOnKEWkYkbFaVzpccUg5Ie7s6m+CMUh00ZLqlCw25AmjbkEczK6aUTOTX9+4pRR9nmMuKdD+QucNXrgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/19/26 13:34, Mike Rapoport (Microsoft) wrote:
> Split out files related to SPARSE and SPARSE_VMEMMAP management from
> MEMORY MANAGEMENT - CORE into a dedicated entry.
> 
> Also include architecture specific sparsemem.h headers, pfn_to_page() and
> page_to_pfn() conversions and Documentation/mm/memory-model.rst.
> 
> Muchun, who did a lot of work cleaning up SPARSE_VMEMMAP and extending
> vmemmap optimization, volunteered to help with the maintenance.
> 
> David and I will continue to look after that part of the mm subsystem.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

