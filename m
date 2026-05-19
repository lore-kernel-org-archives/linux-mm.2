Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22425CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 04:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EEE6B0005; Tue, 19 May 2026 00:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE466B0098; Tue, 19 May 2026 00:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B236B0099; Tue, 19 May 2026 00:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 634E06B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:08:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5FF28B8B1
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:08:32 +0000 (UTC)
X-FDA: 84782837664.04.46651EF
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7A2B180002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:08:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sd8/w6jF";
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779163711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8eV7g1JtKUSReNhPrH4xoPwSK6jpCut0GMVwPfzuFc=;
	b=QGKLDs0o1SekGlyvXGwHp1wXVoaEkBxUHPf9FkFpPb+eh8gISNvJGUcWkKLOhVputt7/Pg
	B9E1zXHdeYEA2yMzE0p4+CdLp5h31AgEHpVczFEzhy52hkexe7eC96tQgW4nE4E8eSyi3I
	Awqp6MjxtIHhcDkCLnES7tkDeiUhPF4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sd8/w6jF";
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779163711; a=rsa-sha256;
	cv=none;
	b=gTnnk1k/sCQ8oGHfYVES9Ib43jB4YTHpPOD+rUjntTZ/mqxvNeRNglq3kc/HZeUaHPeYrP
	lqnfLtYguKUHzwHE0n4/k05TB0BfBco7jMTbuMGKYMYC7pNM/bZN/maXPG/wLOnxGRmvLQ
	aNvWPhoru61F9yrvxQl0Q9GdEhwhnq0=
Date: Tue, 19 May 2026 12:08:19 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779163707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G8eV7g1JtKUSReNhPrH4xoPwSK6jpCut0GMVwPfzuFc=;
	b=sd8/w6jFHHxfVX6cIU9JlkugH2JBd1nBFJUtyrJDz9g+jyFMimyjHpuGoD0TK/0YSchd7T
	ZzFm0AOzMU2qlfHJYlSbUv7igihjWkm9RERvKbO/ng9Z6BCWdv33+3mO99rsUWVaTqVac2
	K4cpoZdoKuFoUV77tMOzM3RKMkaRodY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH RFC 1/8] mm/slab: do not store cache pointer in struct
 slab_sheaf
Message-ID: <agvfq5CgipemBLPl@fedora>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
 <20260516-sheaves-tuning-v1-1-221aa3e1d829@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516-sheaves-tuning-v1-1-221aa3e1d829@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7A2B180002
X-Stat-Signature: rswrew7rnrazdfjgphbjscwna9grbz51
X-HE-Tag: 1779163709-316133
X-HE-Meta: U2FsdGVkX18+Mustnbbj1J5LvbrldDf/eTOTd5fFmWwZRa5Obu1Pw6i6H1Ig1BO6rAWg6+eaLU1dikwztQ7f2K33wmQXToeAUrCYmccizlQsTSfvgzzUQpxNuFmxxMUW1Ggr0wITwEpk19/ZUvw6MALA9jQ3rKMtTklEGq31R9mPSsH9cqxO0B4RQgBR3agR8sDalZEy3mKA1uLW3v4rqBipJtQqWckQmDu8AmyHDiRfYyDpVUKOLD6NYeIL3SkWTD9GdyM0Pncm+nLJKV67bJw1OMaVdJWt3DLW3SKHG+fiDspSt5Ky25ElhejlhnoR3Y5Hbinlnan6gAuG//MXbUzgfeujRXpjOw3M5i8SwMb+N8CcETaPI+JbPbWr/9jQqcI/eKEQj4BjQ2zD3CBhvD7R323mWsjPyToOfdRaBes2Z5HEikKKxN+Sz/utmPtVQAYND/Cyo/kFMZXwMG15Hhgl0d+LnhevrrUqbho7iFhMCikobLI1fK9+e9hNarqH/Bt6/VPJ6fq2ZTnw8X23+S7dZ113WDnzb5zLFocxmsVRsE0kWa1RfWvY9wPOnuWJM8YCrWfUHrI9GmHp+ziQ/6ySpqlSOGXlRCgOtQP24MS+KTzBe5bREZSLPr8wVg5U9xkw6fSytrqRYV7qdkjrq6Qxt01qPDoj84XTH9iJ052AnHCrdpZSZCtqtWAzKbj94ty5yzU9WY1EOTzpFofyPdxIRMSW3mQNxgirI71uGxziz689OFj9KB2pGXS7IdVTCcp5vYRwB5Ed+7FL3T+qrmwBqMCeyWgB12keJesjBd6NfP76yhPjYTzspILl7NmPMgORF8pBoqemm2Kmxzem62Oy8TuabpB0Suk/ll5UFedQaEaHR86WFQQ9HknvsWoC8pTcRqKb4UN6Ug6gRm7vnPKAsgvXtCGfdnp8Hl8ne/fhmAueOcF02IXzmRKiyvzMoteq8w7Kvb3s6bap+2R
 U6QRL09w
 Fmbge1eblwWUhAvS6NzMQ9fGXb4TocK1BA4cv4ydSwogu/nhw2Eh4tmpKwNQXhpcZF9vpQGuxju9aSZvrF7AgEERQFsojwvP9FYjk56JwrCYlNURDElRFN2Cid+U97Ri6iM8Z3Fz3xDrqu9CZ0IxE0PCvl3eSt1C/l57cRmRRZJCYJdgtReESqCkAbGFSxjL4PNq1+r52PrL3SO9kXW9eLQhsxlVIGWoGiddsmXyU0yOo76yGUnYhPxfejF9HM1cM+njACj2ukHnDV5KGEnwLueXbKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 16, 2026 at 01:24:25AM +0900, Harry Yoo (Oracle) wrote:
> The `cache` field of struct slab_sheaf is only read on the slow path
> when freeing an RCU sheaf. Storing it in every sheaf is an overkill.
> 
> Drop the field. In rcu_free_sheaf() and rcu_free_sheaf_nobarn(),
> fetch the kmem_cache pointer via
> virt_to_slab(sheaf->objects[0])->slab_cache instead.
> 
> As sheaf is only attached to pcs->rcu_free once it holds at least one
> object, the lookup is safe. Add a WARN_ON_ONCE() in case an empty
> sheaf ever reaches the RCU free path. In that case, the cache is
> unknown, so free_empty_sheaf() now tolerates a NULL cache argument.
> However, the case is never expected to trigger.
> 
> While at it, remove the stale comment in init_percpu_sheaves().
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slub.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)

Looks good to me.
This cleanup can save 8 bytes and give us one more objects[] pointer.

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

