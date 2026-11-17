Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1061606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8dNYQte
Received: by kanga.kvack.org (Postfix)
	id 8C1636B00EF; Mon, 16 Nov 2026 20:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898016B05B0; Mon, 16 Nov 2026 20:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE3B6B05B1; Mon, 16 Nov 2026 20:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52E336B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:37:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E21591A02B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:37:12 +0000 (UTC)
X-FDA: 85442897904.17.B612781
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 32952140005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:37:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8dNYQte;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794879431;
	b=xqpnEEB/XJpZ7aYrhPlkHUUvIWGM1B0SylUVcQBXyljXcJZqmzEclJvaYqoMkJKpoeDAZq
	PWRLrS8WZPqQhnMtN8CjJ4POzThexkdyA5RV/TV0jBHevCxNhiucKRzRwJHox1Au3IYKw4
	htcSReVvQ58MV2sA181Ku0NBVs6rwTQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8dNYQte;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794879431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIMOnFHtb/Mb13a3T/u5ttg244elHzKV/mc7yLX3gCc=;
	b=QnW2PzDmicJENOjOA/f773Zk9C5qh+OqZd4qLeD6V6F8GvdDUkv3hKI71OqgZn67HoBJe9
	M7RqzdsG6xaXYOuLyGqn+F6RrlttKQnzGM0QPj3BujNHuz/C63QXrLjDUp1HgpOdoIbYsz
	coeihhuSFk98T7gNu/MlZBDVUZ74zS8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38EA140383;
	Tue, 17 Nov 2026 01:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B5D1F000C4;
	Tue, 17 Nov 2026 01:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794879430;
	bh=BIMOnFHtb/Mb13a3T/u5ttg244elHzKV/mc7yLX3gCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8dNYQte0M53YUVdQTJ09cHEEm/GkG1g6FiQLENVmU4Tcmi9BNuZ6oyDbW3ql4gAA
	 0Bf3rOM9FBbFbrGVScLXwmi4RN28kdCu5fxWRCh3bwbZ21zUQahXy47KY9BPFeIrjt
	 doE5joDBU606+nuRIVWAKFzp+6zIFNYbe5IVRQS7XsfcSlfEKMJmCs1z9cieS/URJH
	 G1CRyLA9K6YRugwzoxlLQB/ef2wT4k5Mf0eySpDmsYyfKq3Hk0TFIo3EZky9BUhcxr
	 9/S+9I1zYLn79j9gspSdRuudOw6+UjyDsuyrppgEkgT+Vod2bKZzsEsEehkJosOCJf
	 0W8lcSOy7js2w==
From: SJ Park <sj@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/compaction: do not skip the free scanner's periodic lock drop
Date: Mon, 16 Nov 2026 17:37:02 -0800
Message-ID: <20261117013702.109081-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116125746.2897395-1-kas@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 32952140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: trj1ykf87zcxcjkot1naqxti7n4yd8b3
X-Rspam-User: 
X-HE-Tag: 1794879431-746085
X-HE-Meta: U2FsdGVkX193c+aisNsBxki4HL3WuJJBgsfk9ASCnPqtA88AKYlNKlPyonEI3FXmDaJy0nZ8h4TlhyZeNaHiQarNMaELhVUJy/UqpJsbXSQQateWavQXs8z04l7LvGQ0TFMdQp3F6J3lfVJEtUeTJDawqahTXaTuMmuBCxEQLcroBHQJC/AbohjPgfcatAOqrGtZCWrCviX+ix7c3yMDGJCMhZ2IGmYNyOlfk9L73ZNcCEzDY503w0nRYbO9kdXbQIvkKN6CfGsvk4zKPS/hjnKHB/BI7OmpjI9CGbePOQlaicuGczE5fotWYcewOxi39F7mZvv4Kv3f/qGV5ZbuvH1FyAgUDSP0g2D05tA9DUz7CuAGquDPFRIPQ0pDInzJ3xGxRg+kqtCN8connfuiDcumRbkc3E+L35lhYwYEqwilT5MaVwLTMKnBqT5i8Y1FtrwLw2805pvoVOOsSYHHM+yxZ0ZvkEs42OoVyPYYjj38xCzJ7o4cHrATCv+wd4CSZwf56SmBAB4m7i/FEjtT6pD/59MgRZgBOjS1sp7ZYyIuJqfkOA0E5sBTsCx+P8cia1tpKpByKOzU95O7WGP2z9lrTZ8jiayGDcwKXHbxJQk5olDPd6oAOLT0e5GBk6sp1XmVvmvkWv2e7+mDPEULvvxTHFlueX1kydyKFhZOfemRvrQRoJqPoG8qHAx19L5X7hsDqRMd/GwvgGs+6rRjsAdXW901vOBEgMGWA+n4P3WP4HTjPWCUh1vIskn4Bs/mwa6hzMeDKQamwcNzav9R+yzgQF4hrCFN8cBvIZtIXEU/TPm36rp8Z+SvbFI9S0uCcIkH6nMhwj2n7MKANFBmQXjI/bv/MeNu7HFvRweeluu3ZzNqD5X2cR6DcJB0NJZ/yN8T24SWHYOiXIl2lWyDp6h+ODW6wD3gZFabj3/Qgp8oNTq9+MzUJ24+nhyvPq3C0Arkt+T1P6ZbeMDVj94
 cPrDgkSS
 e28hnOZrB4zelrH9Co1qF5Tw262C7iGecWQkM1Xe20wa6ayzrvh2eFDXOKpZcmLyUEQU1FQQfT5+N4NuJlrmnbyHIIwMWahYDA9yh9kbcZ1XLuL3qqNsVhovY5f9XkoV1uS2kJF8Yqm/rcRJpG1gweSTryzOZVypGzGe1tQZ1JOzYjAQPO2u9hqSNWA7b3tpjz6Hir72UAGqs21JeF+BPi69xVofuHZCPvfFNq3ry0sMaCcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 12:57:45 +0000 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

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

Makes sense to me.

> 
> Fixes: 4fca9730c51d ("mm, compaction: sample pageblocks for free pages")

I understand you intentionally not Cc-ing stable@, buecase the user impact is
not that bad.  I think that makes sense.  I just wanted to call out this for a
case that it was not intentional.

> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
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

Why don't you let the later two lines unchanged?  No strong opinion, no
blocker.

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

