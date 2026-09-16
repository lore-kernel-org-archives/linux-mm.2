Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527C7C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DACB6B0096; Wed, 16 Sep 2026 02:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564C16B0098; Wed, 16 Sep 2026 02:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BC96B0099; Wed, 16 Sep 2026 02:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC606B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:25:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88E2312062B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:25:08 +0000 (UTC)
X-FDA: 85218637896.12.9200FFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D9C0E20007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:25:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PWlWiHbo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PWlWiHbo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789539906;
	b=eSO/sh0tnqWjYZvZs/D+6EWWT+qEDW7KBXdLFigYvse+cA8wBwcLVav7qudzUuxq+dokQ/
	KOcPHbQe9LE+vrD2Sl9JR5x33hAtzlVbj6daKABJhTnz4WlIt1s6wh69Uv1cM0NNA7Ncwd
	AXHge9cgBSBLeoCtpzDNuNvRVNRPr8A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789539906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSAK4OewrbYk1s8dXTIrNF8g5vHL0nZd3Hyf6R+tOGI=;
	b=3Uemcmblm+sK6RfRF0zRSCPcipA3ezhI7sVV8nuFsz8zAt3HBqHRY96R1gZ1r8OAgnvqPF
	xxAoAdKeFQubUhuVfzjK+uNYpnUvcYCBywPiv9wxYCezvmCE1T1hblpiZnKiBuiimROYaz
	UNXb8NsHN+YCZGBHGEIqs6AORVotTf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A55B60008;
	Wed, 16 Sep 2026 06:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1279B1F000FF;
	Wed, 16 Sep 2026 06:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789539906;
	bh=WSAK4OewrbYk1s8dXTIrNF8g5vHL0nZd3Hyf6R+tOGI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PWlWiHbozNTNPVYdWeMwfblXPsRUHvZ2LxCu4OsQAnqDtZHViQh9tAFFL5FLlmvFd
	 A65abK9Fy838XvqboO6LTsjyNPDDws1PJJtUQkHbvhFxwi/oaEqBBz+0TMc5mPGQyi
	 jlTCNEhOtIZJAyU25bUL0ceA9oQCZFT7aS0PHJj+txmfMM2IOChCjT8Qx9GFnjR+FF
	 fuuyznnPmKDNkXP0SxhiwW39J7+FtF2xD3g/x9SH57za1goAA0kR9kQJ/CAIS/Mgt0
	 iDoMcXS33MJIclWt1XP6vWMN/GEF9wtzTeEgsmGOK4JIYT5y2PRxAJ6eO+22Xaof72
	 j7CHcFhNy6w+Q==
Message-ID: <2f63b25e-71ca-4af6-83d2-70be2388a55a@kernel.org>
Date: Wed, 16 Sep 2026 08:25:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] mm/madvise: use folio_trylock() in the
 cold/pageout PMD split
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, sashiko-bot <sashiko-bot@kernel.org>,
 stable@vger.kernel.org
References: <20260912110540.3203010-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260912110540.3203010-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D9C0E20007
X-Stat-Signature: 73t8mhjc1yfgsi4e7gzgykqs9aanomrw
X-Rspamd-Server: rspam01
X-HE-Tag: 1789539906-859798
X-HE-Meta: U2FsdGVkX19uQDzAS4WLngRtazWESdN0p0Ar3Zs72SHHQjeAfx7pfujS46fkZ0Rsmin6Gu9C7bqucqxY5Toik+U6FB8yqo6HN3ZRE/skUMGP2WvtZBAZKkPsnNPtnl//DwAWCoYCqvxlwRUZ3A0OYgYfRZ3CwbK1f68GiqKKNPfU1Mtv4WaXp0rEwxjnnxq4X+7YFo1nCZbzEd/KOL8hiQP3brLc28Kv1wCiO2ybNUG1yTiAE+lcVpqoD5tUqPP8CHqR1B27OAoOhBut0NNrDvRoBQV59qsS7oGgCTd8jbwRj+TWK1xwolDwDXkmkKu7UxKF2m9bi7sTsAHj3sC1rjRt9Bewbq1AMY0YHSXYdpDC5MFC1m1l2npQ6xrUwD6MkupzqnoiPzc7DTE05Gy8ygA34jubLtyQyHqJre035IAJdV6qZjgnxZh1c4PE4oy2pN5JjpQ6CAsNWb1dr+Vm7Q/ClN7nydPFmGLrkJ+qm97Ehx597krAP9N0rD6Ag7huIohJ8hru9dzS0z35/X9E0rBrOCQUvYHjp7xTIuQnBI6G1rwPwsAVi4SY0lJOyiIYuTq4dYpUg26sLmE0evjI/FTxGmU7v4Pfp/0R2KnDn2UrQvGkhXuM3fD8M35nWNttsphBiLkKprW15z4IbY6fbVwDKocUotj0RhIJuznFbxUrN3h7Wm0zkslqGchlJqspR+l/apQfEAYWMIJIShQgC29YVTTdXFNCeJxJAt1NBWvEdgaWnB1BuwJwkTYXA9YeGvuKU1+vH514Qe4gYZPUYC+RpQnDUhZsW5yaKCWYrcgsLegAR/I6mwTj+tDX5hfTN8hQf5c29Tcgg3LanCIiptowkdiwTSin0H7ls/qji0WyqmM9wGpjafZftt1IQOxYYwtPoWBLdHlasUi4JZggrKudimCi4uPau9u5yTi3fTjOM6QrM0gXiXPnnDZ4VTLcBNVroB0XLdbJh1X0Vjm
 tvFqJCSp
 EdxoKpIQMPSA+jUxOo7CVyV4bMN0B8lcHyGfGzuIxBUiE24GTJT4LrJ+3EEWlDJS8TXABZ9/yDh3yaZMSxUVueSPFsJNuJJWsfo5b2kJLkxA88uyBeN8CRRUWiJHZIhwoNJvsdcFrlntZO/3t5BVbcZLD1BU2PnXYoKzP/a2cwwDs8lF/Kq/kdr0hXD9TH1qAMENsfSVUDHku2pQ+3wi+MB6urfzE2LYGNyEmRbIckUt15l9KFXBNNgrAp+6BIW6UXDVR1jDP8Q/XSsHt2cjYfIRLuU7+UI7x+RcmdlK1Ec8qTziXAj3Ir/zQevfEwrXaVIniVoGdW/BAHt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/26 13:05, Gregory Price wrote:
> MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
> madvise_cold_or_pageout_pte_range().  Two threads doing that to
> the same THP create spurious failures.
> 
>   CPU0                          CPU1
>   ----                          ----
>   folio_get()
>   spin_unlock(ptl)
>   folio_lock()
>                                 folio_get()
>                                 spin_unlock(ptl)
>                                 folio_lock()  <- blocks, keeps its ref
>   split_folio()
>     folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
>     -EAGAIN
> 
> CPU1 cannot drop its reference until it gets the lock CPU0 holds, so CPU0's
> split always fails.  folio_trylock() makes CPU1 leave without ever taking a
> reference.  The PTE branch of this same function already does this, as do
> madvise_free_pte_range() and madvise_free_huge_pmd().
> 
> Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
> of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
> /proc/vmstat:
> 
>                      thp_split_page   thp_split_page_failed
>     before                     3186                     860
>     after                      3200                       0
> 
> The short before count is rounds where every thread failed and the
> advice was dropped for that THP entirely.

While the split now succeeds, one of both calls will just effectively skip
processing the page table. SO while CPU0 will succeed with the split, CPU1 would
just skip the page table.

And what happened before?

Split on CPU0 failed and it would skip the page table. Split on CPU1, however,
would likely have succeeded?

So this is all far from perfect.

... but this matches what we do further down in the PTE scenario.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

