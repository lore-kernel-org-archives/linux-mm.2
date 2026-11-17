Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BD7606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Cljy+74T
Received: by kanga.kvack.org (Postfix)
	id A5B686B00EF; Tue, 17 Nov 2026 00:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C306B05B0; Tue, 17 Nov 2026 00:34:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923036B05B1; Tue, 17 Nov 2026 00:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1456B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:34:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E49E940318
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:34:36 +0000 (UTC)
X-FDA: 85443496152.09.55AD60E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id E1867140004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:34:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cljy+74T;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794893675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4qUuinC9l0nXsJ9wo2WhPeiho5YCLulx+dy9SOsQmU=;
	b=qGQCoOZtPErMWYPKUiRIkL9s6vr/yJaJF7dePwIFYT5xtrxosRN/N+Hl2ChqEtcVscnK8m
	LWRtxY3Y+3Dt/Ds76LTERj4gjsBhq6jw+TLfbL/s/Rzdl8rOPVQK5bD68egiroF2LONjz+
	akE3dX3JheE0bfcmSeLKwD51T/+/s38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794893675;
	b=O8QPB3Cz+C1Z1UmXt5YCyY9CobxnQVOyOraZQGDwd+Ka+PDsOW7dLoQD3kiXvvZRgH0l2D
	FC9lVFaSNnQsd4FrxL0CEUiRsFy6q5/egESmPaL51M+G+Mf8bc7J5ZiK+s2QcdCjD9WPV3
	crRtZOt2GWV6aFNYxxeF9v1JYVNk4PY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cljy+74T;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE83C1682;
	Mon, 16 Nov 2026 21:34:30 -0800 (PST)
Received: from [10.163.156.60] (unknown [10.163.156.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 630D43F673;
	Mon, 16 Nov 2026 21:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794893673; bh=9wpAqerGs8CtCKiOTYUfXIO7LwZz3rDBgRhX5IB37qw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cljy+74TxavYmZ5OMGowaSyr+FZ/kIWYBKPcRvIjWhXsDrTPZYub684MDMkXe3M1t
	 6RWuxz2Onyh+yLPj3rxC4RXTA6BYsP7ypBNJBH58Q/mchtzAD1mNSykN/+Pmy3LGJM
	 1qRvsG2CvQ1rTYVgrZYiSZpIRHuKPWmE7DBDBpqE=
Message-ID: <ad8a7751-c9c1-4b0c-969b-27efd0945dc1@arm.com>
Date: Tue, 17 Nov 2026 11:04:25 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: do not skip the free scanner's periodic
 lock drop
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116125746.2897395-1-kas@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261116125746.2897395-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5p6nc34iwh8ycuogn71b4dmpgob6bnb5
X-Rspam-User: 
X-Rspamd-Queue-Id: E1867140004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794893674-202084
X-HE-Meta: U2FsdGVkX18IpvSbrZCN5d51CKL7slPjMPKMMpNr9DnXG53gCfoV2+lWgnkHoUyabUOgAP8BdZdTDlePrrHTosUarCeTUEPODYqQ6sPSFDkwQnENjnhPIep+FVCcLhwE1IUCEh1MOlX6O7O93lByxXMtml/2O/6MXC4KqGaQMxduPHk2wDuSklMsOZohElloMXMxZVfEvO5KDeQkyEcKchwbqVotLy3ZMzJ5o9RxOoAHvR2EDPJCqbortJAMBWdi83CVhE3Tnf7wNsE7g5C0zJl+AnvdpNTJnZamTWVAdkQxwqXSzltEeyJeQPsTJBUunvOu7teiFL4ZN6TG1XjghREN2FvJ/j52h+1m08eDlZVV9YosIpP/6Qg1++rfn7U1I3q+WEplX5QAux4IcU5uzXGv2aHR+XBf4XM2S5e/y2ck3jutwYc9Edez41Aga1CadTVTgTeN7uWwuDsQsaLrXufVr9HO1flFHhoP7x/o3wbYdlne8NttGjZEFYcOvUhmbeYqms3rkQbbL3ffznHZt3sgOYXnilZImwS/LIY5L8d4AWPxMNvltSx5yeY5ECzNAFeupzA1Ypvu54WFXmZUsrsynmz8bzMNHoM8sReR1oT0o+WVVPHwx2X3w3vn78ipRW830NeY1MF5YrA4qD1KFUj/UWXcZ8opLjawknrpiSEoJ5N0wlrPlF1qAQ7z3EaqIucPvRMyW/hX9pdyPobKc/kCZ+h0e2wJo6x4TRkIR2JAc6qJ6CWbzZytwvpvWECWJk7fakPZQoLLeKn4s3/jUuNTID8LDR0awNF2S60V2lbtXByjw12alTy2t7uTTCNy5vwsq0ss6MXNJYKN/qzzT2CLxtMaHILOeIEgD6fvZ+MhqU73N9Yg+7LhMNiie0zp/7Ms5rLONlgoE89qQp3giCpG77SjOXYhV/FT6xMD0me5UZjhewa9uHgdnWAbdtooQcEu6iOoNMgOgUhIVEU
 oBvo3j5l
 bG3RYg21X4vvi3W52m129GiWWTslPo1xL86EHQ6AQm0K7gNQCoriwPyIByJAoluDSpNYPZoChrIHeULGtvdxo/1TB6Pg90kenkvB2hj+qCqiC4Nw4RNTcN/lV8EtmBH1PnpvufRhv/fL9F8xujHCaNbU24KIMQjGfoFhm1UqjKJusZ6W/HOXyC2lShIJ02lDrDEAmuMZVIqft6tCTZgXKj+F1C5OzJqrgaXFPk6Wn7EdOVde8pfFrhGcjk8aXpFl33tLWSdCcdb2P6eYVCvRoX/6/t4Dcd3rDDa/7zRiNebf4TNokSoxPyjIhvFBo8SA7j9wx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 16/11/26 6:27 pm, Kiryl Shutsemau (Meta) wrote:
> isolate_freepages_block() drops zone->lock, checks for a fatal signal
> and calls cond_resched() at every pfn that is a multiple of
> COMPACT_CLUSTER_MAX.
> 
> With a stride above one, the scan steps over a compound page, or over a
> high-order free page it has just isolated, to a pfn that is not a
> multiple of the stride.  From there it never reaches a multiple of
> COMPACT_CLUSTER_MAX, so the rest of the pageblock is scanned without the
> check, possibly with zone->lock held and interrupts off.
> 
> Count probes instead, and check every COMPACT_CLUSTER_MAX of them.
> 
> Fixes: 4fca9730c51d ("mm, compaction: sample pageblocks for free pages")
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Cc stable?

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/compaction.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f1b2060eb201..4465c1551406 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -579,7 +579,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  				unsigned int stride,
>  				bool strict)
>  {
> -	int nr_scanned = 0, total_isolated = 0;
> +	int nr_scanned = 0, nr_probes = 0, total_isolated = 0;
>  	struct page *page;
>  	unsigned long flags = 0;
>  	bool locked = false;
> @@ -599,13 +599,15 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		/*
>  		 * Periodically drop the lock (if held) regardless of its
>  		 * contention, to give chance to IRQs. Abort if fatal signal
> -		 * pending.
> +		 * pending. Count probes rather than pfns, as the scan does not
> +		 * always land on a multiple of COMPACT_CLUSTER_MAX.
>  		 */
> -		if (!(blockpfn % COMPACT_CLUSTER_MAX)
> -		    && compact_unlock_should_abort(&cc->zone->lock, flags,
> -								&locked, cc))
> +		if (!(nr_probes % COMPACT_CLUSTER_MAX) &&
> +		    compact_unlock_should_abort(&cc->zone->lock, flags,
> +						&locked, cc))

I see this is an unrelated change but I don't mind.


>  			break;
>  
> +		nr_probes++;
>  		nr_scanned++;
>  
>  		/*
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4


