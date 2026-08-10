Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761CCC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C6E6B008A; Mon, 10 Aug 2026 07:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322F96B008C; Mon, 10 Aug 2026 07:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2398B6B0092; Mon, 10 Aug 2026 07:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5CA66B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:20:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54E2680111
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:20:15 +0000 (UTC)
X-FDA: 85085115990.11.0C3A7F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B71211C0008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:20:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFrMF0iU;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786360813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=va7cXB+2hnmj2B9ftJqAbagU6hqvH8vEy5FFmZFOHcc=;
	b=xDnkb+obtZCtUIhF1mCUBIlDhw1wu+uHgit61H5OrLDb4MzPliQk1RowOPUFmxvQtWwaYQ
	JD8O5Q5fHdg0X3LVQmZjs84oICdLizwfMGwxjySbLcFvByzBJ/cSkP9eZO/jTw1KPVB+H8
	P7+1O1KbH0lEPVabWsMbco4r18tCq1w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786360813;
	b=pgVdCPqItQj4Ryox6zil/lKL5ZW0P56kGREoTStNnDxB+WlMj5F608zaeTQ4VMsmCktBWo
	Lkr6D/INTiukTfrWVSMaLzPpVtdsS7y2ashgHht3ZLf9DkgdSkFWVMMfYgCKiAYR39RejQ
	VjAt0YbYW02p+Dphiek+k83aRdBCos4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFrMF0iU;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C668E600B1;
	Mon, 10 Aug 2026 11:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6461F00A3A;
	Mon, 10 Aug 2026 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786360812;
	bh=va7cXB+2hnmj2B9ftJqAbagU6hqvH8vEy5FFmZFOHcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MFrMF0iUP8CmHQKuds+UcGzhmZjw8F8Ed27coZhqb+HKNdPNjIeSl2pbi/NbHlM4X
	 deeQ6D7fjEJoaRRReiKo8dZNs9yI1wDDv54iQQ/yIp3Q3DwYH8QetizhjAbXzFw3RD
	 XBB01Arv2+iShl7p1Ta4X5mg9+MZIMEB3NS62NzVXmD5hCnH8exL6LQ/c/4/bnTUaj
	 IeJwEth0tSy+IW5gUVs9HZVIjXWRSyEk6EZdUNXr5F1BIpzxDKt5vc7iCVEhJCapp0
	 NUawN7Kh4/G3bDBFS56mxL/tqIPraD3riN9UHsCqYycTKH6qzNjgqEAo978ttEElsO
	 oo5N6X09u6rAA==
Date: Mon, 10 Aug 2026 12:19:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
Message-ID: <anmrTaWp2etxX7Fd@lucifer>
References: <anmdrYGVqM-U4vlo@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anmdrYGVqM-U4vlo@v4bel>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B71211C0008
X-Rspam-User: 
X-Stat-Signature: ittsdtg7r9h7fficro57nm8ozddgqq87
X-HE-Tag: 1786360813-37629
X-HE-Meta: U2FsdGVkX1+G5Xw4d7CLnuVEHux87BJlCahRPQfxDhJUYPS7Vc/VXfdTaMR9IXzeXR0KYH3HiU/i5gfaL1qjlVuZLkPf0qH5hc+ynSqasSD6w1YAtyAPEEQaeDNuFEnCtoA8WMGoWFuqgx1DxQzN4yiy51bDXVI7bvEtQHvor7YCe1TStrxVTUMX6246zzPm2xM/G1HzT5SzyLiPPyw984qq4pSNwKLLwntLE7ofc+9nxpy6H2E0GsvFCcPb6Sw2WaJS9uX6zR/2K6myGQKy9j+LiN/vJMsFptLf8puOF5euriYPrW9WYdN1MWJy2zivVZPqIhiP0T/YVEl0zlA/wlE5T3y31uSKYPH5sKONhdGFLt0XVhGMWWfXDTUY6mHu6Xds+z8UmIr2ZOLPidFFUt5KkWdJ8z+plvUHxIYeMbKOIJwOYQSB01ZEDSk+aDKT2+Bf8QgF8IP1iu7Z2gBnqkxWGEM0mBqDqa/eie/LgIV4ceII6vtspE5jdeogvyxSB/HOVEZkd0oJvXKQ7JPHj7PUf1IOKhn981ePtPWMnxNR3Y3+1DcMAGRTVl/iri77hfUn2XGjbFCvhtyEAR1B3gvm2ZCPGL9wwKRnD/nJQKe4E9nBFDAHy6LG8QMorb9zOfZI590W/0s9h7PjmtacWjxDTlZa/qCtzXm0tsMUF8ChowuMf0D6Pa0J89qFzD2CA0xKb6WL4HDJiiLydLYra1opg6luD2U3jHOc9lCaoz+9yDEEa+8y6HT5DpFYdzoh9V+cZEPrxiTCATWG3yl4YEu0MDYHPX+nAf7U8XgO/g3KZTmGbGYC1idOpnYVrM+HMwsprBGTNhR2Zug3AwsAAGhqf0tHEZ/mmrbSvTZwtGZbme6BVGtd0Gcvwf6EDY0o9P+aZzkdqpnvQxnGMW9XFO7f142XWZDTiPmkZhmKcCzB4cop03Ud/aSS7l7NoGDo+RU21YKrQxY+SOrlzvC
 Mq3XdBEM
 nA5DnmzjOA4Jkdi9KyBFun039W27TvEuC39ewY9lvX3KbBfRwY+hm9eySHJ+/T01RtQwtT9veqDy74TrsPUezlwl8akXYbNTYApZpZr4rk7KLqE+TknWZPvZrrljYuJS++mRR4ZJ4jILtuft/kBcieWFLyDotRyQw1pLhSbANXFqwL8nKGM9hV4iVCPKlxHNdGbdzhDqiseBbwOSuuz6W5yCKHEolfh4AFNqOx9OjnsF0Y6fHhKb09L8/t//ixtd0i/bt4TwZmC0p4rRn3o7x1TX0NQmVqvrPYH/+XTlbC+ts9Ourg3dnmTKrFiKBftK1PaOi1swORD1ApzQoBYgtmo/6gIufB3Fp976pCoiDRVR3l6S8CdMCDcV0qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since it's 2026 + this is your first patch in mm AFAICT, and it's also a
very fiddly and specific issue, I do have to ask - was there was any AI
involved in making this?

If so you should add an Assisted-by: tag as per
https://docs.kernel.org/process/coding-assistants.html please :)

On Mon, Aug 10, 2026 at 06:45:17PM +0900, Hyunwoo Kim wrote:
> walk_pmd_range() resets walk->action in only one place in its loop body,
> and that place is after the pmd_none() branch. For a walker with no

Newline after full stop please, this is too many words in one big block.

What is a 'reset'? This doesn't really mean anything. You mean sets
walk->action = ACTION_SUBTREE, which is the default action.

Your commit message doesn't mention ACTION_SUBTREE anywhere, it should.

Also what you're saying here is just untrue if you consider reset to be
assignment to walk->action (which is a reasonable interpretation) -
walk_pmd_range() changes walk->action in _two_ places.

Just be clear that you by reset you mean assigning walk->action =
ACTION_SUBTREE.

> ->install_pte, that branch continues to the next entry without passing the
> reset. So if ->pmd_entry() sets ACTION_AGAIN and returns 0, and the PMD has

Not passing what reset? This is so unclear.

> become none by the time the loop restarts at the again label, the reset is
> skipped. If the remaining entries are all none too, the loop returns 0 with
> ACTION_AGAIN still set. The ACTION_AGAIN that walk_pte_range() sets when
> pte_offset_map_lock() fails escapes the same way.

OK so what you mean to say is:

	if (ops->pmd_entry)
		err = ops->pmd_entry(pmd, addr, next, walk); <- 1. sets walk->action =
								   ACTION_AGAIN
		if (err)
			break;

		if (walk->action == ACTION_AGAIN)
			goto again;

Then above that code:

again:
		next = pmd_addr_end(addr, end);
		if (pmd_none(*pmd)) {   <- 2. This triggers because PMD became empty
			if (has_install)
				err = __pte_alloc(walk->mm, pmd);
			else if (ops->pte_hole)
				err = ops->pte_hole(addr, next, depth, walk);
			if (err)
				break;
			if (!has_install)
				continue; <- 3. Loop around to the next entry, with
						walk->action erroneously set to
						ACTION_AGAIN still.
		}

		walk->action = ACTION_SUBTREE; <- 4. This would reset it EXCEPT if
		                                     you are at the end of the range.

Then in walk_pud_range():

		err = walk_pmd_range(pud, addr, next, walk);
		if (err)
			break;

		if (walk->action == ACTION_AGAIN) <- 5. Uh oh doing a retry for no
		                                        reason.
			goto again;

So it's only if you're at the end of the PMD range that it's a problem
right? You should say that.

The user-visible problem here is that you can end up calling the callbacks
too many times which explicitly breaks mincore.

Given I had to decode this it does make me wonder if you fully understand
this or if it's just unclear language. This sort of word salad is very
LLM-ish :)

Anyway overall maybe rewrite the commit message to something like:

	If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none()
	check is retried. The PMD entry may be cleared at the point of retry.

	In this case, if walk->ops->install_pte is not specified, the code
	continues to the next PMD entry in the range without resetting
	walk->action to ACTION_SUBTREE.

	This leaves walk->action erroneously set to ACTION_AGAIN, which is
	incorrect.

	This was incorrect but not problematic up until commit 3b89863c3fa4
	("mm/pagewalk: fix race between concurrent split and refault")
	which updated walk_pud_range() to check for walk->action ==
	ACTION_AGAIN upon walk_pmd_range()'s return, causing the PUD walk
	to be retried.

	In this case this results in duplicate walk callbacks being
	invoked, which is erroneous and will break any caller that is not
	idempotent with respect to this (and waste time for those which
	are).

	A specific example of this breaking things is mincore which walks
	an internal cursor data structure a byte at a time on assumption
	that page table entry callbacks are called only once for each
	entry.

	Fix the problem by resetting walk->action to ACTION_SUBTREE prior
	to the none check.

	The pattern also exists in walk_pud_entry() so fix it there too.


>
> Nothing looked at that value after walk_pmd_range() returned until commit
> 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
> turned that into a problem. It added both the PUD check that sets
> ACTION_AGAIN before the loop is entered and the test in walk_pud_range()
> that picks the value up right after walk_pmd_range() returns and walks
> [addr, pud_addr_end(addr, end)) again. That is fine for the PUD check,
> since none of walk_pmd_range()'s own callbacks have run at that point, but
> a value that escaped as described above arrives after those callbacks have
> already covered the range.
>
> For mincore(2) this becomes an out-of-bounds write. ->pmd_entry() and
> ->pte_hole() advance the walk->private cursor by one byte per page, the
> buffer is a single page from __get_free_page(), and mincore(2) asks for at
> most PAGE_SIZE entries at a time, so there is no room to spare. Walking
> the range a second time pushes the cursor past the end of the buffer, and
> it does so again every time the race is hit. Reproducing this needs no
> privileges: run mincore(2) over a 16 MiB anonymous mapping marked
> MADV_NOHUGEPAGE while another thread repeatedly faults in a PMD-aligned
> 2 MiB range inside it and then drops it with madvise(MADV_DONTNEED).

Obviouisly see above on commit message.

Is it possible to add a self test that does something like this or is it too
racey to be practical?

>
> Move the reset to the first statement of the loop body. walk_pud_range()
> has the same shape and gets the same change; walk_p4d_range() never looks
> at walk->action, so that hunk keeps the two functions in sync rather than
> fixing a second bug.

Your commit message doesn't mention how you discovered this. If it was AI
suggesting it (whether locally or sashiko in reply to some review) you
should reference it.

If it was simply hardcore code inspection then you should say so too :)

>
> Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
> Cc: stable@vger.kernel.org

This all seems right.

> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>

The fix itself looks right, but you need to address the other feedback and
respin (also please send a respin with at least 1 day's delay).

> ---
>  mm/pagewalk.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 5d87c632a25507..d3bfece3193366 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -126,6 +126,7 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  	pmd = pmd_offset(pud, addr);
>  	do {
>  again:
> +		walk->action = ACTION_SUBTREE;
>  		next = pmd_addr_end(addr, end);
>  		if (pmd_none(*pmd)) {
>  			if (has_install)
> @@ -138,8 +139,6 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  				continue;
>  		}
>
> -		walk->action = ACTION_SUBTREE;
> -
>  		/*
>  		 * This implies that each ->pmd_entry() handler
>  		 * needs to know about pmd_trans_huge() pmds
> @@ -196,6 +195,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>  	pud = pud_offset(p4d, addr);
>  	do {
>   again:
> +		walk->action = ACTION_SUBTREE;
>  		next = pud_addr_end(addr, end);
>  		if (pud_none(*pud)) {
>  			if (has_install)
> @@ -208,8 +208,6 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>  				continue;
>  		}
>
> -		walk->action = ACTION_SUBTREE;
> -
>  		if (ops->pud_entry)
>  			err = ops->pud_entry(pud, addr, next, walk);
>  		if (err)
> --
> 2.43.0
>

--
Cheers, Lorenzo

