Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC7CCA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 10:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65AB6B008C; Thu,  8 Oct 2026 06:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEEE86B0092; Thu,  8 Oct 2026 06:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04F16B0093; Thu,  8 Oct 2026 06:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85B156B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:04:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE60F1604E3
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:04:33 +0000 (UTC)
X-FDA: 85299024426.24.0C0BE03
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D33C1A0005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:04:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791453872;
	b=j8LEKrAJ9eLtxE3jTfQkWbBZE+xmedJbAyvn5RDDNJHaETEkn0a89aySwAIZnvMBS/CHez
	CcYCifGV0mcLWunyE4EvQ3qXnQUkiPeEnVJyfK9vm4WqxCAIob2Fs54S6IuNdQGhFAP3Wl
	1RGVRqSGyFdJekbGU6tnJjt+0iKQgWk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791453872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SPYzrbasOBn6GBXNXbxi/l1WIooFib07Dz6Lvtf/L78=;
	b=36cif/99wtaB0PVjE3giR4IIQqBR8JP/+oeFvu19bLZVYqnjd7gpZ7rJLRhR6pQA8W2H6B
	R13VK4qtWc7dwPJP3RxHSTokh8rdVs7oG2vk1cO8T9qboSqHUT3Vx3i7eoscOxH4aP5oA+
	4Wus+WPMC94ykgykieSNsHR7h/qJspc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 346F668AFE; Thu,  8 Oct 2026 12:04:26 +0200 (CEST)
Date: Thu, 8 Oct 2026 12:04:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 0/2] mm/zswap: batch the writeback IO
Message-ID: <20261008100425.GA11357@lst.de>
References: <20261007153507.50715-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007153507.50715-1-alex@ghiti.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: 68ip1cwypej6hkwgiy1rjgqw6mtyer3j
X-Rspamd-Queue-Id: 0D33C1A0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791453871-815845
X-HE-Meta: U2FsdGVkX190OftJaWO7hpBHqxStdcQrp8hjJVOT/iWsfBKldGlEinJBZcEAVKK6zvRN66f/0R6kG8HqOGmUsU1HYaJprOo65rR67a6Z7bkqihgMRhLrF6xhHkVgdYKtdzZHyHrSs9ESEgRs293QG7rHTzuY5plHL9zM6lvGaPCkROMoh8dKU7C82ONAxBp0r/wNvH5AT00/OerrdpEdHOsVdr1wlrWbWM3AyLnsCU1Hfjwhh/YI5+hlJRhDFNpGrQ2UnExKiPc3DPmwgnLiQGOIFSGokBOCpdh9Bq9lY91j2np9wSZRly/jQISECGRmki0eC6TW3ZJ74xRVgU+THnLiXbbP/RFoXEwZBIgiAebuG9W3qEeh1gkjNojhr3X/Ioy9FeeR4eo0D9xvjVEiUQTShy0n6eDQWMTwHxkbB3ddPzK1r2u6dpg8nk8AyUNbgz+H3hQF7mGNDiPOugksSPCusFnsbk6nannXdMNdJaaF/JXvXPXMtCJfbgIZJ3FfaC5SJqkDvLBYpdQkRQrdXZyUtNI00nJkXhXmZ5yF1cu8Nf5mE6Ot3ZwxsZWJDS1HkGGeAaN7+JSaIOK5Wa78jPqXGa+Io+FJ6X1GpJFcNtZRMv7vl6NpuijgIC7B7UrjyyiVxKReayM5Ugv6qfZA77VaW4tXkQrQmDhKr/WTLukA7Dd9QRp8ZCCg4K64gykA5VIjda4nTpNbV+v1rWx2gr4G5u7opOndGWZPXLlgoDL8/FXHi4Jai3b4E2PMe9fzmLtloUA3+jY/CkTakFxxzIbeCeqmP/UkTjHIxVZMi59DINugQn5Fofu6g5lblZr8M9hifJUlwws/mq1/JEC37Kha2arXv6ETQ1BaQU/iINb9CfI6XRyXKpZYWPg6mmxTXYa7M+jkAZccYqZXLTWorx3dSUKEo5kw75MGucM+06HVGPAw5nTyhHH6mQh+sVmMQ4JuT3OcsxI491GU4Mc
 LSscx4PJ
 P3rwiyC1nfLfJQhcNXAQWjKWZXKN/91gQWRR7HJ/DIbI5h1BlqI8ZP4YvDD/8oPq7/zJT0k02NXr2iT2bfL+mlvfUGsORuySP7TG5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 07, 2026 at 05:34:42PM +0200, Alexandre Ghiti wrote:
> Since commit 8f29aa226f82 ("mm/swap: introduce struct swap_io_ctx"),
> reclaim merges the swap writes of folios with consecutive slots into a
> single bio, but zswap writeback still issues one IO per entry. Patch 1
> makes each zswap LRU walk batch its writeback IO. Patch 2 plugs the
> walk, so that the block layer can merge what the batch cannot.

No a zswap expert, but from the high-level perspective this looks
great.


