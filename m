Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BFF606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 19:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TW8KkMVV
Received: by kanga.kvack.org (Postfix)
	id 3DE996B05B3; Sun, 15 Nov 2026 14:15:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F376B05B4; Sun, 15 Nov 2026 14:15:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5B66B05B5; Sun, 15 Nov 2026 14:15:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED4926B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:15:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7376EA07E3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:15:46 +0000 (UTC)
X-FDA: 85438307892.06.E0D41C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C162BA0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:15:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TW8KkMVV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794770144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imsZLV1/j0+7+KQo/YR+v0zfeVAOnZjjS01+bde7pqM=;
	b=Blmrcs2NRPw06YdFQeGAxbyETvnfCAqU3vGnVJSyyPwgHr6My1xAOud6k8/RKP37jJKgJ9
	ywVwIcMEzsc4E0a68IsacnuFlZmQV8WQfX9qjOVM4Q1mT8czLu4i1+GIzNpWVHb/Vv+G5D
	QUXjXNDDJZkX58hIEtnpi+gRlWXLNL4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TW8KkMVV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794770144;
	b=BqwERuDkjyoV/VUurOx4DMUFvjwDyP0itbJGbh9n0Fx4qyn3FZEJuoVpxAmhNKC8tiUsmY
	StN3YO5jVNsGttPl7GLx1PbS0KmgexACyr7LdAP9C1YIE53lOiJIpHeyBVtFwM1XeMcorW
	h6p9isQgcmwN0S5z7apWUi4jZmQXoxs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68F5161259;
	Sun, 15 Nov 2026 19:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAF31F000C4;
	Sun, 15 Nov 2026 19:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794770143;
	bh=imsZLV1/j0+7+KQo/YR+v0zfeVAOnZjjS01+bde7pqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TW8KkMVVMt9rUebi+zjgSZeFR8dzjW+WW8lkEDR9+0OyBBjcLrxgfV1QiP6Ga9xN1
	 Mv2ZIus5IzsKI5EV6bDzJsyYouyrB9kWEnWor2Qa/iOR6bzYSEgfmpA76UCjizmSXM
	 yk5kkX9u+biqZxjvSVR/Q1Csbdcf4Wpi2KB90Np48Yuk1nTBCzqem+AMYq7eT8FpTN
	 1OlUKB3wbkBSzQKcJg+9YTd6mfDVyZOKyCgAVxefrcHegL8yZMhrCAUrrCjXGia4+O
	 kC/q0TdFfjlcZBrpcXPGorhvztkXW6AARCi/vZgAisoAfDUP5lFYWL0CJGOhMVsw3f
	 jxT9+WKeaN9Ng==
Date: Sun, 15 Nov 2026 19:15:39 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: shao.mingyin@zte.com.cn, akpm@linux-foundation.org, linux-mm@kvack.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/util: fix off-by-one when checking folio index in
 snapshot_page()
Message-ID: <avn08-MVyt7wDfF1@lucifer>
References: <20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn>
 <avibe0HG4ssUUuBX@gremlin>
 <72dc7b45-ad20-450b-8ec7-3e86be8a41f8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72dc7b45-ad20-450b-8ec7-3e86be8a41f8@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C162BA0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rotjekz7wb76o99dxhdau4zgmpm5wfoe
X-HE-Tag: 1794770144-450497
X-HE-Meta: U2FsdGVkX18CryOoNFoy/gaatMx/6qUlNfkS4zdwbCp1Tuu+0sTvpRgGszB0HZlMxWWrxITFRjq8xGIm5lZIiJvavndQs/cAa30akmX4vjNG3g5hjjSLJbFBuknfElI46jD2rS/cctAz9AJTJz5Mx/BP4tR/EhMJvlwDqexnVlGqsrDh/wR4wAyxxh6tzONgBQf+/TqUryrbrzpHEZEdVzerPS4CgWZ9xOMjQoG8kHqH0nvDSuX4zWdsVJhzI/rk3JGzIeG01MtYy+xeOgZ9UXlJZlWONffHi+staTy8i2P8X1H7TJ6LQnsh0T2C4hce2h58gmQoNH8+V0MiD79dScDNdz4DWk1U+FDC9WsdE+mAEMlvatEwtgPFVZM7z/2b6kz8FJvlVkElg96RJTsz4wOpZKKD3su8GPFrrQ09za7nKj7gAgJlzk95NXsGVTBKF2xUwgm5GvsMa0QAtrIqQU73lZF1ycDJdNPomrdElpnxoCGkD7jg7gRmJOPWvGok7x3hy8jOFvusDavrFIotWFXZ41rgi6qXjTcy1nucyYRBcNIVchVtxEtlP02VAcdQ/hU/sfXEfPI5u29ZxsKrQpKh+bP8OBYToDId0/B1DqqD7lfQYDSJBIS1xytaQcXgf225mi4gIs6PiU1aMN1kYNW4I+GzpMwu3wpxWuiMCvaehCWsMGbUZa9xDOwt/GxHXDSYThQmkzfBU2RhvaGaGwG0xvc57PqNLONS1+ahcLnwliLosBM9qJMpSi7pPdKryo+XQOYruNChRiYBjR9s4J5LIiTS9dbV7zcu/4hJV8PW0lqXnaLWWY4Ul2agTOJCeX3yV2rqN3uKtiYJ4NSDen5W8640qmKpK9Ii8Hxbi+Uwiqt64Xh3aRwrb7EAnFY9uK86aWPR44qyePQe7Pe0+ETbYfhB+maXN0Z1ICuxtJobvsAtcN1Dh04OMFzqSSMPNNpI6mR2uEAs+Qk3fDR
 20yLO8Sa
 uQApue94pQofvcEhqV9muauiYIq54TQooNHxGtKMLQFyk1iIPKJbVYwJoETsR8a+APUhMG8j20eBRmPeJYWas2X0Qu8vh8WBsZXypo3BU+QPjZ8lE0LHaJ8g5bj/ZZrXnYUaK3DI6229cG7cr5ufSsFpKL68kjhdzwZrdxY+5DzLYSfkZONygqGimbTx4KpRxXJwNnac2/uhE64lXsttyKZje0llRtqvLVEW7+MU9XQ9WMpP5RS9qGQ6MegmzbknHHVFEZu3bUH+sAVRZyXsEjIKavLhXAgrghoauJXkToNwGGM1VMNJOKEKba8EA9f1v2GqoJ8NE71KwvAJa+48uigM5P3+qhyzLFCLLYMvEh/GZPDxE6rqbiT2P9oq5b/9rNFGv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 06:32:12PM +0100, David Hildenbrand (Arm) wrote:
> On 11/14/26 18:33, Lorenzo Stoakes (ARM) wrote:
> > On Sun, Nov 15, 2026 at 12:46:57AM +0800, shao.mingyin@zte.com.cn wrote:
> >> From: Shao Mingyin <shao.mingyin@zte.com.cn>
> >>
> >> mm/util: fix off-by-one when checking folio index in snapshot_page()
> >>
> >> snapshot_page() computes the page index before copying the folio state.
> >> If the folio changes between those reads, the index can equal the copied
> >> folio's page count. Valid indices are strictly less than that count,
> >> but the current check accepts equality and marks the snapshot faithful.
> >>
> >> Use >= so that this inconsistent snapshot is retried, or falls back to
> >> the unfaithful single-page representation. This also avoids reporting an
> >> out-of-range folio index without the corresponding dump_page() warning.
> >>
> >> Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
> >> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> >
> > NAK.
>
> Let's do the following:. Thoughts?
>
> From c7d1a79926e3b3448bb5e84f901c185234f43b52 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Sun, 15 Nov 2026 18:11:08 +0100
> Subject: [PATCH] mm/util: fix retry detection and handling in snapshot_page()
>
> snapshot_page() detects races with concurrent folio split+construction by
> checking whether the given page still falls into the folio. Unfortunately,
> we have an off-by-one error in there, and we should be checking for
> "ps->idx >= nr_pages", because idx 0 is valid.
>
> For example, we might currently report a tail page at idx 1 as faithful,
> although the snapshotted folio is now a small folio.
>
> However, there is one complication: As we don't hold a folio reference,
> folio_nr_pages() can return 0 on races (or when called from page freeing
> code). Handle that by just setting it to 1 in that case, so we don't
> wrongly report a head page as "page does not match folio".
>
> In addition, we should reset ps->flags when retrying, by just resetting
> it to PAGE_SNAPSHOT_FAITHFUL. Otherwise, PAGE_SNAPSHOT_PG_BUDDY and
> PAGE_SNAPSHOT_PG_IDLE from a failed attempt could stick around.
>
> These races are fairly rare, so this is not really critical, we simply
> report something slightly wrong. No need to CC stable.
>
> Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
> Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Yeah this is reminisecent of other patches from the same batch I saw in
that the original didn't quite fix the problem correctly :)

Thanks for this! One small nit below but otherwise:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/util.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/util.c b/mm/util.c
> index 80f6c714844f2..3b10d4c2a4fd9 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1406,9 +1406,9 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>  	int loops = 5;
>
>  	ps->pfn = page_to_pfn(page);
> -	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
>
>  again:
> +	ps->flags = PAGE_SNAPSHOT_FAITHFUL;

set_ps_flgs() or's stuff in so it does need this it seems.

>  	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
>  	memcpy(&ps->page_snapshot, page, sizeof(*page));
>  	info = ps->page_snapshot.compound_info;
> @@ -1438,13 +1438,16 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>  	if (ps->idx < MAX_FOLIO_NR_PAGES) {
>  		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
>  		nr_pages = folio_nr_pages(&ps->folio_snapshot);
> +		/* On races, or when freeing pages, we can read 0. */
> +		if (nr_pages == 0)
> +			nr_pages = 1;

Nit but could be:

		/* On races, or when freeing pages, we can read 0. */
  		nr_pages = folio_nr_pages(&ps->folio_snapshot) ?: 1;

>  		if (nr_pages > 2)
>  			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
>  			       sizeof(struct page));
>  		set_ps_flags(ps, foliop, page);
>  	}
>
> -	if (ps->idx > nr_pages) {
> +	if (ps->idx >= nr_pages) {
>  		if (loops-- > 0)
>  			goto again;
>  		clear_compound_head(&ps->page_snapshot);
> --
> 2.56.1
>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

