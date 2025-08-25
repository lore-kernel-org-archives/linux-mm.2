Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C302CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 11:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091E28E0014; Mon, 25 Aug 2025 07:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042C08E0001; Mon, 25 Aug 2025 07:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AC08E0014; Mon, 25 Aug 2025 07:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D51818E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:53:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE2E883FCB
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:53:02 +0000 (UTC)
X-FDA: 83815118604.28.43CF0AD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91467140003
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:53:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BLdfv054;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O7drp4zQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hxlNOytD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2reUtbC+;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756122781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nTexNPNCcUbIAPjVulE+NnEcHNOirgIMW9iyl6DGTw=;
	b=QvqJgN22N5R5EqvESYvaRroLkox+W/LZq4NH7XD0tHip89GP5ZVSYE/IW7Q4H1CGbX/r4t
	1pqm4+6Dk5TgG5nWibXzx0KBIgUAr3pPJK9wc3p1PE+srjsSftYR2wCrKyxL9Lx+6bQhLV
	UxL1ufa9C2oy0UmAFR6GWtSe5jIFIcs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BLdfv054;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O7drp4zQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hxlNOytD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2reUtbC+;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756122781; a=rsa-sha256;
	cv=none;
	b=hK8RNCP49lO48e9+pgNC82zH7oG3nOGhuDm+mx6b5Ei+sTCYLDWFLXIyqKzrG2wIYaZomu
	Y3g2o4UE+FHvEwBya2w5EyPGrUDlVsPAeTaLvUozCiaG8/g+ZlzXMlQ68hKRTD8HrcPeeU
	YHdBXn4jEIGL2VRltPPAcBuPvtv9jzQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D67D91F79A;
	Mon, 25 Aug 2025 11:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756122779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2nTexNPNCcUbIAPjVulE+NnEcHNOirgIMW9iyl6DGTw=;
	b=BLdfv054/p/malDxY9teiJzF9lSukSG4D6BpJmBipN0NdWdSW+xQ78Zp+mX96AOFCJ4or6
	zbtqKq1WT7TjodcVLV0bt7J1MZOfzgwccf3JUIl6s8+kVZikdeS2skIvtGyG2OhlZoKg6Q
	JUss4nIpYcq8CgiicsCS81+f175aL1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756122779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2nTexNPNCcUbIAPjVulE+NnEcHNOirgIMW9iyl6DGTw=;
	b=O7drp4zQKKa11N3xPKWzBS/Q0YDI7TmPrZK8qGmy4XbGkcAVUk/3ZlwnODZ9si0dCo8+P7
	5I/V+iy8CB2E8QBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756122778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2nTexNPNCcUbIAPjVulE+NnEcHNOirgIMW9iyl6DGTw=;
	b=hxlNOytD4XOs/AoLjAcVDIzjRMdvyScfjPWrBeLqnx0djwZ/JXkk86x1sLkDhnlw/4E/ni
	uYxxucfiTI9vedgKCrWJcx7BY+QluNhfdm4l2MpQlzHhl1brp6XTlNTSvpowKMI6Sw5rkX
	USEgKImf2GD1KiVkKNFJec81wPqbFec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756122778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2nTexNPNCcUbIAPjVulE+NnEcHNOirgIMW9iyl6DGTw=;
	b=2reUtbC+KuaceUTmG97zLnb9fIt9VqqRYRCJqi9iT5L3d2xW2yZVplRnOVQlakwqC3C18m
	1Nr4U8+V7VDSZaAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CAD161368F;
	Mon, 25 Aug 2025 11:52:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Scl9MZpOrGivCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 Aug 2025 11:52:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0FDFAA0A6B; Mon, 25 Aug 2025 10:16:40 +0200 (CEST)
Date: Mon, 25 Aug 2025 10:16:40 +0200
From: Jan Kara <jack@suse.cz>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: readahead: improve mmap_miss heuristic for
 concurrent faults
Message-ID: <nbhyazac6tig3u753upst4brgmlo6qlwdntxdgwtfslpmmvp6h@gakfswzn3p75>
References: <20250815183224.62007-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815183224.62007-1-roman.gushchin@linux.dev>
X-Rspamd-Action: no action
X-Stat-Signature: 4iwg75tkeej6os8cfgy68kbmjqit9q5r
X-Rspam-User: 
X-Rspamd-Queue-Id: 91467140003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756122780-668982
X-HE-Meta: U2FsdGVkX1+M2KY41er+uqqXuD8bG/t45C8f3MYjokMaWOSfe0vYsvxvcbn13kO2czHAdgsk93HPBHUr5midGxalluvJFLQUiZXhVipOIjO72rXewvuTju6pnDccX0wNIgWlhrOW9dfO+7odg5iYKHYHgL/2h3BtPYdi51aJ8fpWeWU4PaU37gSi4zirqwAsmcTagl6ccfzBvfr2Tn+L3BdUy4B/ZHuhYtGWT1ikoDjI+b4OlDP2yvnHLMuyO79ZgmPOq45cRuulqaKsqTXzwW87YD3Fsp3BgooMrRbXj1aC0ijR4wcM2DZ7G5gtKLmzV4nz0EqFAlIspXlqaSblyn7kq74Z2dp1kLs6znYba28i4aHwEf83tVapMNwG4PsoN0tCSOr/EIRQKFFNBSW/eZMN50nYy5WI/ANZvpl307ENw1QDeYu+0IuWEvx+RHdMqwblMt0OxkX2fIttXzmAFWzHPtdOfSw2cEkngK+XrSg4z8QangUxUpAyz6rRXW75mmXa1MfBY4hyIH/B3WppRuI5d1TF6DJCEgrojaTCeY8WfdDJ+la1OYyOIzT8jPhrKVwWAM5ZHxSR+9Zyy8VEm1gntmVQg0Tvv3AfkCSFNAP0gMKvJHBXMKGu7jvj89us7EkcuwjOulhxi4bA2+HGljgWalvGwxCLchzH5iGwhjsqsXZlzn7Ax+A1gM4z5iZfqIX2wRDjbfkEoJKQd74mN15aBCHogKVMmR9QQdgxOgbLRi4JoX8QTFa0hxavYyWn6ef22gPjvnhnEL/QCyHi827GYV+LeLpfsGlQo/Jt1uKZSpwM2et2WjMCDpwcvED/3GtIQNXAp7U5bt9mHeYMGl3GzO+kzfQo8qLHCU2GvgTn4FpjuVoiZfcc4Ai/dng3fHlSVuTWQMQQp9IO33Wd3lS/B0VRtoEmvvxfVuaIB6GtkrM9JxGGz6BqRc2JsAv/DAG15+LTuOZd0a+BGBB
 OAIE6rrS
 ptXvQWHf2wE8JwTm5aZtFXHzLpxaQx96jvoLnBU/69R8e4MXJrzahxCIZtpz4YSDleCel+gdCANBtvbp6kbLvU7MhaxkpKZJ6MdNJBI2pJCLopUUzEeVEzzp2pLjLyQJvHYl/lD+Vvoy9P/UqyPNk6lgYRa1GP5Dgx2JNbmTz4hL2YCrr5kI8ELCT42cazlFEJ8uujRf+2IuauJwOMr2Zrtx8J9372YoDLxSMp+le6uiuKk7rc3hSaLQ3r4SFzHV17mEZvmvhgYVE0k7kgI1CeHZM1ztIGcxHQMNARlZ7QL3tYFnBvgJdo/gJR4HkekEanfpIvpo81S6JV4+LJAC3AmCoEmzj96XT2AjXN30OZJ+8bAuWqIhYI9K1HLq1o+nvw7j7n7ykCaLM8tfxVmU3AVsDlPOdhVLeRVuh7YAi+/Yonc8LV9N5aY2LKnAbpd2EJj3bBRiThVZR5d8HhXmxtiYdhNpb3mA2iQ5eRrMzI8ajAreGQQ1C1GtaDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 15-08-25 11:32:24, Roman Gushchin wrote:
> If two or more threads of an application faulting on the same folio,
> the mmap_miss counter can be decreased multiple times. It breaks the
> mmap_miss heuristic and keeps the readahead enabled even under extreme
> levels of memory pressure.
> 
> It happens often if file folios backing a multi-threaded application
> are getting evicted and re-faulted.
> 
> Fix it by skipping decreasing mmap_miss if the folio is locked.
> 
> This change was evaluated on several hundred thousands hosts in Google's
> production over a couple of weeks. The number of containers being
> stuck in a vicious reclaim cycle for a long time was reduced several
> fold (~10-20x), as well as the overall fleet-wide cpu time spent in
> direct memory reclaim was meaningfully reduced. No regressions were
> observed.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-mm@kvack.org

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c21e98657e0b..983ba1019674 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3324,9 +3324,17 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
>  		return fpin;
>  
> -	mmap_miss = READ_ONCE(ra->mmap_miss);
> -	if (mmap_miss)
> -		WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> +	/*
> +	 * If the folio is locked, we're likely racing against another fault.
> +	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
> +	 * times for a single folio and break the balance with mmap_miss
> +	 * increase in do_sync_mmap_readahead().
> +	 */
> +	if (likely(!folio_test_locked(folio))) {
> +		mmap_miss = READ_ONCE(ra->mmap_miss);
> +		if (mmap_miss)
> +			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> +	}
>  
>  	if (folio_test_readahead(folio)) {
>  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> -- 
> 2.50.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

