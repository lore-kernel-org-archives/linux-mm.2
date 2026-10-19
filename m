Received: from smtp.lore.kernel.org (ip-10-30-226-214.us-west-2.compute.internal [10.30.226.214])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC5E606EFED
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dquZ0zsb
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6AECCF2E6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406B56B0294; Mon, 19 Oct 2026 10:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DEC46B0296; Mon, 19 Oct 2026 10:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C656B0297; Mon, 19 Oct 2026 10:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1056A6B0294
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:55:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9823780718
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:55:09 +0000 (UTC)
X-FDA: 85339673538.30.218CE94
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id C794A20010
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:55:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dquZ0zsb;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792421707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4hxhJmvPn7AcnQ/ZWKG7QsPda8INusHl4ZJ/PDgaQU=;
	b=uN0fxnVe7aU3Q11kSI2dlVyCLpEzc1tomtopRPJFq98vrbEFBq9kw17J9CtqCsa/9XwzKW
	lNGGVPKcb0JZ0zzB1EF0S4vnWGbKlP+OOL5+tQK0tTDdsUUX3kahIFcGjX72IQCkKwEuDX
	XHQ+kCh5KXpgLw4fxmGtZbJYsiEpfaI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792421707;
	b=qTVIJbrN3rEG2DWHwk1Jqj46ZDaY4WEIULsMO3SqT5DHlgMk0Eh66ETPTBT3ASYUxxGRRI
	CX6yf64jvniy239FESmnA9cXtnZl3ftD6na3+eOCTbV9bKIPdwOdYXBjSOroV2Yf1b1jrP
	w0pXVDfptaNwrVMH4OjFKBdVmDSNHBY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dquZ0zsb;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 268E01D34;
	Mon, 19 Oct 2026 07:55:03 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 637A23F673;
	Mon, 19 Oct 2026 07:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792421706; bh=JePCMnx8/su8AAS/ZVIThUJhxAH7QCVSw2VlUvAcrQc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dquZ0zsb8TUxQqrVKFHzKecjJPxmFn9BPWmSPeUt4pp2uBPq8APeVyzMisLgssh1v
	 TZU/WEC3H5pP58oL4cP/OjMccLrvXkUY+5HU52USqCNbPlN+hEGwvXf1yR7AkaGpR7
	 gskM7Oy6PccGDnhdnyilm74wYQa3HEvySaszSEwE=
Message-ID: <45c5ebc9-a4d2-44e6-a08f-79676ecb0579@arm.com>
Date: Mon, 19 Oct 2026 20:24:57 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/kmsan: undo the shadow mapping when the origin
 mapping fails
To: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, stable@vger.kernel.org
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-2-hao.ge@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261019054531.87652-2-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C794A20010
X-Stat-Signature: gc8br1fmb4h74qfrxr4opbkbfbjz6db5
X-Rspam-User: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792421707-963820
X-HE-Meta: U2FsdGVkX194kcpuG6DDwDVHPv1sj3TW37kPS7HAZNI6VRZRM5pGZ9S+pOoDaK6k6zsv/R5OUBkto8nog4mF3DyMjVlw4Iy4E6chwU+hkq6aHKdr8LOeT8gMr3gZlTkXDZVWlE4/65gZyGxdSbb3cwSWO2CQHhJ7kIYmHqbR0Ca3JcRMY0QiBz6/WP4ewavbYrSS5QBcgPUoRMNexFrPIqFZtUDJ5qeQW21QEnV5mwtmaoMyEI7bMwX1ScNDflM8ZBdTBt4bYF+gC3jGxP4vTnrQy6kWCOYwBF25sp6NAr29OGYi84wFIF3koz9mqnBbQR0KVTTlxTO95aPHAmwTMZx1d/1fxCCiztXyWB7bFxOHjEc8cPbbFhTCzAz/T49QCHqz1jVdG7gwnFyk7cguDP4sgOcIQY3ZGbL8TFkPbNLvhAjn7CabsE43oMzJwWt+W2ugTJRGZ7EQfT6HexgjA24k8yQYxoYBnbIGS6rKFcLvUcvmvPTSEwFkukLxhpce1SkIbnf/Hg/zKHJczeBBnVah91TAV2bSeie8yCQFNd6MK8lodzeySZ1xkMKqPD1ybsvSk88IF8ajDavEudBIaywugTQqGQn/Q1A4ZzVgDrnwZTRLkE1/AdtStJFYMnre0WQ9YucB0A/vfRk2cq8xmG0r4/XDAFJoj39FtrFqbLqDPEiqyQx9488gpLTo85A9V48N4lCpGOfIfsmg2ic+n0HdyokdDfdfqB8wqYaM0fa84Za96wiIu2p2AN5adedQ70ixtnmY0WZnFl+UzIdz6fIbTOKNur6v91gUT1gMnAWwimzcI2IAmoM9pqr3HbUYyu53REakHsel774BvM9Lt4kZOQukvKL/R1XnqnUr8lgJ+fuA4H6/1vGU1ecXd56stiV/h2ucwDzlmpjruZuqSJ1jC22iBlnVcRx3SBqUhe0y9yrY7vlmc7J3WR2Lq/flOhNJOsXdCM37AawDLXe
 QhrHUzDD
 Tjkrcy88RzcEPd/QOZ1d7Y4ys7w75sQVxx6gh7CQUVeqhchqKhI3u4dIoekOt/UlGyUHiZg7rTg+XPME7pTc9qJ+x/oicKe3yEVQ8vmjuI8jnxJzpGOobPQ9/QL3IFdbdhWGo1phS4O+P9FNC85InKQm+LwtbNvmJMKPGuczTkt1tT+iIsOaiGht9HiDBHoz6Tb1ri79oz7ETuzOmSZvXBR4BQWKfYO4NNyWgNOsgr7H88cW1f7VR3+ohO4U9yF6m+6TvfqtmPecnvHY6CbAwSiCk+rJk7rsHU7Zbmf4HLHqpyjMgxXYa6nz8ViWgVpK30v5TgrHOcH4SUsX2eEa+j6XOxD2MYIf/JaCtTdnTPimfmBkqZECq4i6i35AjtaDcT7JbCl8foGLHBIbmKxdgHOk25wRUSVbOkODm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 19/10/26 11:15 am, Hao Ge wrote:
> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
> the origin pages. If the second mapping fails, the first one is left
> mapped, and the callers do not roll it back. The next vmap of the
> same metadata range hits the stale PTEs again and BUG()s on the huge
> mapping path, or gets -EBUSY with a WARN_ON() on the small page one.
> 
> Undo the shadow mapping on that error path, the same way
> kmsan_ioremap_page_range() cleans up after a partial failure.
> __vunmap_range_noflush() only clears the PTEs; nothing has touched
> the shadow mapping, so no TLB flush is needed.
> 
> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/kmsan/shadow.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> index 0c88d89bf0d6..2166086d3dc3 100644
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>  					    o_pages, page_shift);
>  	kmsan_leave_runtime();
>  	if (mapped) {
> +		/* Undo the shadow mapping set up above. */
> +		kmsan_enter_runtime();
> +		__vunmap_range_noflush(shadow_start, shadow_end);
> +		kmsan_leave_runtime();
>  		err = mapped;
>  		goto ret;
>  	}


