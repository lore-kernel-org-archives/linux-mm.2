Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4443AFED9F6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99CE86B00A8; Tue, 17 Mar 2026 13:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974A46B00A9; Tue, 17 Mar 2026 13:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B12A6B00AA; Tue, 17 Mar 2026 13:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A42A6B00A8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:24:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33C15C167E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:24:32 +0000 (UTC)
X-FDA: 84556229184.03.E65A57B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78AF9180013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:24:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KguY9pQQ;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773768270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7OhlRGCFrpDp2nPgWBDg3IuTR//rV9BoLAQOIahHdo=;
	b=QVqMF2+c/W2QTewgtteqCwpbPlZuLvW8qzxsP5z4DWHWNcpHoBsIcb+XIehBov7tUHgSOT
	MOKFW3BycBDjmS46/+a/ojKb8OvXK3o4unvf3A1+O4AG04vUKGwCiSME+fNHVkXtKVmLhe
	5uS1xRCWcMqIShUgq743cvQ9zjjqlfs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KguY9pQQ;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773768270; a=rsa-sha256;
	cv=none;
	b=ZVD+StpF75e+iE8xcNmXWsaApls07u2Kci+oVZoE7dhRvGzWDZQZR1Ot0UPSV4NmlnQjVe
	iEcGmjZvG6dshbPOwniRf1pZMN6M26YWJ9n2YF2OjaXZ7ULRLeF877ZfjhQ6HFOwISwG5x
	aOulOVNDa6fbwQnI7Rd6tKLZ22FbYc8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D99243A9E;
	Tue, 17 Mar 2026 17:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D1DC4CEF7;
	Tue, 17 Mar 2026 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773768269;
	bh=7h4fdWHPisrK7hpCv9173Ird3vPPfJMliYRCEuqwTi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KguY9pQQ+/Dcad5ECFToTJEfKGgZPCKsWP07r9JfQttL/4O6e7dESxx/zbmbXRYPF
	 caRLA6N989yTl2M5KWUN6xTnQgUjDKA6l7C8I/cog2s0iDP3UNXyMJNWGlX/qqAZH7
	 XzNrFmBGegjnk1ME4oq7ttSBrlhYsK3eEdB1xK4SyD7319/TRRLPBqjCwwUYhgWPGv
	 ZJ2codPYjQPrcxe05joUDN4MipwCrJFTydKwg5AOEBjGqe+WIViMJMkG1yKm7QR6Cy
	 +irNlZAheB3I/KdW5osUcrYqyuCqjyVnsxZP3TyEF4mFDgD9R64qVA17uSfnBriLki
	 8K7xAPejbDSsQ==
Date: Tue, 17 Mar 2026 17:24:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 04/14] mm/memory_hotplug: simplify check_pfn_span()
Message-ID: <c7bd7372-ab23-4f48-af39-ea33a59dfd53@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-5-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-5-david@kernel.org>
X-Rspamd-Queue-Id: 78AF9180013
X-Stat-Signature: 7zztzwo45jtj67dsmptxmj4uyicjzenq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773768270-659688
X-HE-Meta: U2FsdGVkX19WDg1nAuzmLd4GqU8Swi8+aeNKgKGb7+BryYOA1/XVUHKdTWbc5MP6X9oVr7pK1a8GSf16/fUdMbqSxczSxDrMUCXwS+Q8LFDAcqJ3cWW2q8QWxETCDcxMnA3ztH2JvYy05BzKydq4XHrWka79hms4gmkPGTkASB1nLpgiW522FISQMqIcBWNqNCyNc0TALAxB92/NBHB1qWCqd0cWYTPi7uz9yEOcufNMK7tNIDdlaeY20ir4PQ2x2edNXexr0KJ6grK3JZY8l4B0dyavPmpp6vqcQTYGDwxvKlDtqWrunCWiBK5FcDTNmcHLldO3oBxON/cq370EuvoPmaD9lFOMdL+XVAKIznuXUtui855iL/OzJlXwFAu+AmbnGYvPmapr+FCD/9sFwFKIlKeoc4sLY5HE0Hgt7cRaGnDIze07RSDlMNHszCQ8wPofJc6UKg49Co4W6jOvV6PX8+Z2bVFPKZhLxmjLe/NU6Qd2BkM1/Xh3/V8xxpzgX63ohFq3VpJ+pEMaVnm/71RTy5tC6QSzN5zaH06DQsM9vX+iQ9QLimPpbFhKfixMHv7fWk3iBZrAf45nHWopDp6qO6NgXDE+YcAKH7qXlr2wzDIY9BBdLtPV7lRfiw3eRgxHc8gTpid22uOcC2vaIVjHJ9UYh/9RITXUu0571F3MBxVtYZUcdgFLmy03LV2nKSS97Bld8rSPk5FQd9nO8kVMBQEWhkqAfNbqgdoYfCe3dbgNXJeOkvhuBx9KssRKYLsv/wssOLPn5pEP6E31CW/PqNoXml1/leOhloq3yuiqxKS4xcYwIl6uw0XTQqj4aJv4uqvy5dY3/EdREqfHDtHtzCzhnTwwK9mZBHABdNmfbJ/INCncvX5YIwOdL3/XHUehB9bEy67UQpYBcDYoC0znCtcBLi2mDfImzuuyq64vk3xG0TwMmEqa2+mWmrAid8C/XJuYbcSrHjtYESt
 3ePp2i+8
 ngYM9LRlWZ25HEpynbIgpZTKp1T9XgAcHbvkKzhEVstrZMSjokkDXF1hDoD/4Des8zFNNfVSCjKjcU4aFc7PVu/aolLDAE16YnX+qOXYjMXvZjEwILib8n6e1ZwVXSBsnLPN39mm3fs1XZZDaur96CiZIBC4R3UCr8Dwf5o3Kagkd6Tq7IMFFkejyIFHFFs9WatC6UfklUlGlB8JCnBx0KC4or74ZaTFRwaNYy2705vbd7XcvU8vN7jytWN19NTT6xIoKGm3RelSDxeBLJC3gJZIyPQFIt/ej5lN4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:42PM +0100, David Hildenbrand (Arm) wrote:
> We now always have CONFIG_SPARSEMEM_VMEMMAP, so remove the dead code.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

It's a sparse patch but that's ok, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memory_hotplug.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 3495d94587e7..70e620496cec 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -320,21 +320,13 @@ static void release_memory_resource(struct resource *res)
>  static int check_pfn_span(unsigned long pfn, unsigned long nr_pages)
>  {
>  	/*
> -	 * Disallow all operations smaller than a sub-section and only
> -	 * allow operations smaller than a section for
> -	 * SPARSEMEM_VMEMMAP. Note that check_hotplug_memory_range()
> -	 * enforces a larger memory_block_size_bytes() granularity for
> -	 * memory that will be marked online, so this check should only
> -	 * fire for direct arch_{add,remove}_memory() users outside of
> -	 * add_memory_resource().
> +	 * Disallow all operations smaller than a sub-section.
> +	 * Note that check_hotplug_memory_range() enforces a larger
> +	 * memory_block_size_bytes() granularity for memory that will be marked
> +	 * online, so this check should only fire for direct
> +	 * arch_{add,remove}_memory() users outside of add_memory_resource().
>  	 */
> -	unsigned long min_align;
> -
> -	if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
> -		min_align = PAGES_PER_SUBSECTION;
> -	else
> -		min_align = PAGES_PER_SECTION;
> -	if (!IS_ALIGNED(pfn | nr_pages, min_align))
> +	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION))
>  		return -EINVAL;
>  	return 0;
>  }
> --
> 2.43.0
>

