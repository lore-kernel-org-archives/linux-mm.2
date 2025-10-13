Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FCDCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026968E002B; Mon, 13 Oct 2025 07:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F198B8E0007; Mon, 13 Oct 2025 07:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FB98E002B; Mon, 13 Oct 2025 07:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF4208E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:02:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 811F8119CE3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:02:01 +0000 (UTC)
X-FDA: 83992801242.07.42FA982
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 27705120004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:01:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ylakt6nJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uhVD3dfx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ylakt6nJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uhVD3dfx;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760353319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zy8pfvyXl3VuUijiH4RETqJtOQUlXSkDaMZCmtJF83E=;
	b=KRueEiQPSF2nj/iTlmNvsCBscbFsXl9pQ6bKUSuHq8m5IhCcRv2Rhvlp+XjW/76bxoZdsF
	6+HN6NJMlb1Fnh4ZfIB9j+cqJoGJfxnYawl3GkUg3gKl9q9l2lBTYPIxnl3vlcsbcBMPe2
	xDJeJcHrOiLRUHGXBbelUhWluGYW0Xc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ylakt6nJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uhVD3dfx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ylakt6nJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uhVD3dfx;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760353319; a=rsa-sha256;
	cv=none;
	b=vDYeT+niUjRg/goEY1L2A3cCt5WHW+OCX22aZsjJa4sa9V1RmKg5NhpFL+jl8WZ8sxWF/u
	XY2xXHlQCBahZr3BD0MTWlavUkMt6nGFhSKMa07w91C5BSAAgYGC9IiIuThLfRwhh0TKOZ
	B3tHFFv2X/JRP4sKfY/7TZhrzfab1Vg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 876A61F7B9;
	Mon, 13 Oct 2025 11:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760353317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zy8pfvyXl3VuUijiH4RETqJtOQUlXSkDaMZCmtJF83E=;
	b=Ylakt6nJHMdkPdOymXjxqcwZC7UAQuNtqe93yQJTPNglXfMAK2bfbJHxbx3SgtlJDDfDGY
	Y/HCdETEBOuaD9mcFXTmb1IMJGMK5v9RCTR4GS1dbk8JcrIKWBXVi9qjyz814UwWeVgtxb
	H6va4D97R6KKTo1tZRDCSuYEnh/z2qQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760353317;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zy8pfvyXl3VuUijiH4RETqJtOQUlXSkDaMZCmtJF83E=;
	b=uhVD3dfxWidyK+nP+PZLffwzR7zS+ju6MNd0rTD0b/jvg/2MiL/V4Kthnf/xWoeDA0BQOS
	eAjaoc0Hp9lcW4AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760353317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zy8pfvyXl3VuUijiH4RETqJtOQUlXSkDaMZCmtJF83E=;
	b=Ylakt6nJHMdkPdOymXjxqcwZC7UAQuNtqe93yQJTPNglXfMAK2bfbJHxbx3SgtlJDDfDGY
	Y/HCdETEBOuaD9mcFXTmb1IMJGMK5v9RCTR4GS1dbk8JcrIKWBXVi9qjyz814UwWeVgtxb
	H6va4D97R6KKTo1tZRDCSuYEnh/z2qQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760353317;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zy8pfvyXl3VuUijiH4RETqJtOQUlXSkDaMZCmtJF83E=;
	b=uhVD3dfxWidyK+nP+PZLffwzR7zS+ju6MNd0rTD0b/jvg/2MiL/V4Kthnf/xWoeDA0BQOS
	eAjaoc0Hp9lcW4AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 792F0139D8;
	Mon, 13 Oct 2025 11:01:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qMGRHSXc7GgLSQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Oct 2025 11:01:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 238E7A0A58; Mon, 13 Oct 2025 13:01:49 +0200 (CEST)
Date: Mon, 13 Oct 2025 13:01:49 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: jack@suse.cz, willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, dlemoal@kernel.org, 
	linux-xfs@vger.kernel.org, hans.holmberg@wdc.com
Subject: Re: [PATCH, RFC] limit per-inode writeback size considered harmful
Message-ID: <j55u2ol6bconzpeaxdldqjimyrmnuafx5jarzhvic3r2ljbdus@tkmjzu4ka7eh>
References: <20251013072738.4125498-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013072738.4125498-1-hch@lst.de>
X-Stat-Signature: 68e3fc1mkiftunzgm7mwbs88k1exhi1q
X-Rspamd-Queue-Id: 27705120004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760353318-702640
X-HE-Meta: U2FsdGVkX19oUmC9Gf32TW++Byg7o5rhArcWG83Y5NvueP/HMaLr9cdg0GglEdtqcFGOrTlA6UfXKMFf3V/xHkcQf6kU+o6E4fV/A0rMrZ//FTy3R66xQ8XV2ZHYu/XXEdBf0U3DNQdp7nx0lDEGc/tQ2iHSUl+6TJPmYrh4BIiczPDTUWCqTuCJxtp4xYJSavUbeu6oklnynxsdiiVTk43KwrZlNGBWAp2uIVcucluhW20EM/6vybPx0gYhXf49JESZfgMe9h3KvT3/ojXXBblE2zok0DSxKx0qqqowoLOfT0Bw9Ltfh5hpEFTL1AwuxfQRcgnGkEP80ywdgXhrUqWWQTr1H+cAYzJg2w7QZ/LsnU/1CM6bRg2lHLqX621qa7TBtAy6VatDKHvQPPPRQshjxDNYjhbmsrTb8DJivVQO0RuiDJkOo2wqISHL8/w2tzJnaJ9+tPiSgPrkCCEG0ayECPcqgxMgK7XSJ6sEc+iS7hYcyHULGbhHjmrLy4TXBzH1NPjTJpbJdxhwewcUaOG5+7/dHIo+GmQV7flWExBe/2QFvLSRjd2eyeiFT+PliLDqp3YoBLRoZGJPmWCGhcjjyQI3mzimHCk1RzCkq7yASSFxKqBgmT3OAtw4vgKi+dKMhWZKK1A2TL3PzEK9ApwN7eXStcRHMjLGOEga7QvKcpbvzI/6j1vwrQx31uFSVbkg0sqK8TS3xiP/HoV+22YhOUEwfO4DKNlh1SgZFrSgcvlqR35RiAbRiCsnqIwtiYN8NksVgc7n0jGkOs3+Qmt3Nfjlt9NGLOydYe2MQlf4prWlrd9h8T2i5PvjRo04bGXFxTjz4JGybTBbimYhCs6gVHMe/6WcEHfiRod18MnBEbzMghW/GTZdmMaNlijjE/dFcpnNuwhAqzW1nNrfEoy/I/cdZvm0fJ2yTH+xBYnFAC9pOXmnXCjcArcOEl2qQwtgxZxOEL06oPoKN1M
 kurOEHtQ
 xTonLLPXw1v1O7TdSzsKOBaCC6OUyW3k0lJE/YxKHtEautUbrFJq6FVmBnmDWKYLIn20eEehHS8CW0vtCPR6obajCGmD3/uc+by1K4UFbUKEYf3sdZKOr51hY5IfKol/znF9r6yI3IMi6lJoRA7d0IO3PvJoPGiME9wha91sRLTBDMYmsaffI1snYOkQ8Bw11k0T1sg7eNFO1/LdvBUBBkdny/UqYm4d7WmxKIt9SnweUQrCiCSNWk9U0JrxZd3cBU5UMuNmLBPv/6o8ijS7TqBCz/QkNxyx5FJ5Kx0vdl+ZI39buuZoczp74HeewsXCV2ey8fq1jMbZrzbfhqRDy9C1a2KLTNqL55xUzCsceYOdxIAA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On Mon 13-10-25 16:21:42, Christoph Hellwig wrote:
> we have a customer workload where the current core writeback behavior
> causes severe fragmentation on zoned XFS despite a friendly write pattern
> from the application.  We tracked this down to writeback_chunk_size only
> giving about 30-40MBs to each inode before switching to a new inode,
> which will cause files that are aligned to the zone size (256MB on HDD)
> to be fragmented into usually 5-7 extents spread over different zones.
> Using the hack below makes this problem go away entirely by always
> writing an inode fully up to the zone size.  Damien came up with a
> heuristic here:
> 
>   https://lore.kernel.org/linux-xfs/20251013070945.GA2446@lst.de/T/#t
> 
> that also papers over this, but it falls apart on larger memory
> systems where we can cache more of these files in the page cache
> than we open zones.
> 
> Does anyone remember the reason for this limit writeback size?  I
> looked at git history and the code touched comes from a refactoring in
> 2011, and before that it's really hard to figure out where the original
> even worse behavior came from.   At least for zoned devices based
> on a flag or something similar we'd love to avoid switching between
> inodes during writeback, as that would drastically reduce the
> potential for self-induced fragmentation.

That has been a long time ago but as far as I remember the idea of the
logic in writeback_chunk_size() is that for background writeback we want
to:

a) Reasonably often bail out to the main writeback loop to recheck whether
more writeback is still needed (we are still over background threshold,
there isn't other higher priority writeback work such as sync etc.).

b) Alternate between inodes needing writeback so that continuously dirtying
one inode doesn't starve writeback on other inodes.

c) Write enough so that writeback can be efficient.

Currently we have MIN_WRITEBACK_PAGES which is hardwired to 4MB and which
defines granularity of write chunk. Now your problem sounds like you'd like
to configure MIN_WRITEBACK_PAGES on per BDI basis and I think that makes
sense. Do I understand you right?

								Honza

> 
> ---
>  fs/fs-writeback.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..9dd9c5f4d86b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1892,9 +1892,11 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	 *                   (quickly) tag currently dirty pages
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
> -	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
> +	if (1) { /* XXX: check flag */
> +		pages = SZ_256M; /* Don't hard code? */
> +	} else if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages) {
>  		pages = LONG_MAX;
> -	else {
> +	} else {
>  		pages = min(wb->avg_write_bandwidth / 2,
>  			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
>  		pages = min(pages, work->nr_pages);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

