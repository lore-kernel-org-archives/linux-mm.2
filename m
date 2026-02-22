Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CB9FC636B3
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 19:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F2F6B0088; Sun, 22 Feb 2026 14:19:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCF96B0089; Sun, 22 Feb 2026 14:19:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE89A6B008A; Sun, 22 Feb 2026 14:19:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8ECC6B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 14:19:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5771CBA9E9
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 19:19:19 +0000 (UTC)
X-FDA: 84473056038.03.49DC0EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E94AA40002
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 19:19:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TNuLlp54;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771787957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRP7K5NP8ROtOLY78wewCtZWCKWi4KCXd84DyV2XsS8=;
	b=XzdtuZbEimccINvToqQH8+WqDU3vlIln/OrkRqvJpp6HCTHbMthhIrWso44XVMO03xPN2w
	bApTtOVIyIYY2eU/zE2D1PAXgL840w0Hqg5zsmD/jRKYTsEZg4PkiHQEiW9AiHjYkZDtbY
	Fo9Cmw2VMitLxEi/QzpyNCKH1YQpNRE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771787957; a=rsa-sha256;
	cv=none;
	b=UKxPpCqnUSQrMe0HypOmMNdqBqCZZJjuO8qBiniC1gsJ0qiNM0QCPSYwNyc7B4hYp2Fk9x
	OHwMn6iib/jFP74wT4oFTN5Yip9bX0ItttPz2eG43LBdmVJu0sRE4FzzZisyh1DdMoikfw
	Tpo6CqPqP4dzkEOcL3EKQCVlsnsiD/0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TNuLlp54;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A8896001D;
	Sun, 22 Feb 2026 19:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B8AC116D0;
	Sun, 22 Feb 2026 19:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771787957;
	bh=n/zIiLwTtWDrsA7tXCS8QVerjI0mo0TWT+TuUdTwBBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TNuLlp54ilYBBuwL0IgwinZ4vtTmJlwVmu0YGa3OrBJZbKmxfocxSAkVrYm9fSQVu
	 5TbImw6qCGGNujQJlFPygCedUJwn9E1OGGNQcyXMGT7weSttMmz4gZfMD9fl1cLseK
	 yrpS2Y4JRQrkxw2xuFfbRRkhm2kWqDpkSbaLXP4R5+kJWYKhws2CRuOtqPaI0O3VAu
	 vTfxfu+Yo6SEuHBJqii873lIhyBThO5nFH94hX09HbqD1sEAR3A2NZtBtUrNQ/IVqY
	 NKR23yRaWQSflwHyHjI51s+18yoDH0dad1UWHLQ1zHN0xIwlDN9kL4pkmIfnS/2WUh
	 B8lf7Z2TMm0Qg==
Date: Sun, 22 Feb 2026 21:19:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
	kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
Message-ID: <aZtWrjlAaljQ1F48@kernel.org>
References: <20260217195816.861684-1-gpiccoli@igalia.com>
 <20260217195816.861684-3-gpiccoli@igalia.com>
 <aZlyVHwUdxg5WZBe@kernel.org>
 <20e28221-f9c7-47c0-43fa-72bb2e868386@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20e28221-f9c7-47c0-43fa-72bb2e868386@igalia.com>
X-Rspamd-Queue-Id: E94AA40002
X-Stat-Signature: 8ys3t5fhht8b77pnn5dtqqw63qnffhb8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771787957-964620
X-HE-Meta: U2FsdGVkX194Rn6EsXVi5D2B1WgK5AG6MgargmioMxPjbZpE+ZaYI8rvn3PS1ATVqr6uLx7ZWeN2Zm192AXoZ5jes9p9cmRFH/4t+BQN5URPLdbtKhUE+h8MolS7aSry39a6cd4/kPGyvJjoEyQiwY/74Fs5zVlrpDL2Yz3G3V9shtj+ZhFTuzASd0kw/HTrC8XA7CEq7YWLb8bur/bYGWsufCD1p6gq6U7VVWwdnf4WRcv3NoQWRCIaJ/vLOqETckdg8rBL4CVjxYK87YdBslelLB7PP0WVeX1RsX3JeUaSLMzdsXC1HVhQpO5JskdWoIH24EOmRe5wFFx428caiV3XBfVv8h2bicBj71hpYQ7YgI4I7nfK4/XGzHhO07lhpVUmUzb5xVl/Fa0wXrSXExxXIhgkOs+6VpDsRCe1DoS2/gYzHskDBNBp6yQSmHAM0tVTeOg2n4Z6E6QtLn3jTErcQioDlZZVISZqiLgK6YgqykRUOhmGSTNLQjDLKC8JtQqW68VsIQv2CNjmlSwFSqj4F72PT0Vh2CG782YwS2r5pek54TXREzNv+Y1BpCYvIFwqh7d3yoLyEv157TcQn3IkWINO09URkc36AfMm1zXSMWagD8FEC8FJS7Ng4vR7883otwOTE7JNju5W14yKGChOkRXvDm3tvyxpCnF7kWKxVmrfQ8JmRXsjylT7H/xqkDxZC6QON9lMvZ/iF021ESXnDcVr/ttVXBHlWr+6er/gXpdg1aXX+y6sfPA1Nau2ReBQEHH2v06i4dd0U8Sp0dgb+ggPf6mjH9MsJBdMZx77RnJ3tpu4lrzzYuRhqt3WfzsRhSyIdiNbSWkcGz6RJOW3kJmWdYUpatW27mr4KaiQChy37sbhwj3B9YhELP2ilVibadTDzfxXGUEsc+kCHWxWy6pF9lBxIQqANwCdKL/4hdLqyTWLI/EwkQ28y+X9SNE+hRq/RUYLIF0zXHE
 rxrJQyfQ
 L6TTN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 10:58:27AM -0300, Guilherme G. Piccoli wrote:
> Hi Mike, thanks a bunch for your review! Good ideas, I'll change the
> implementation to follow the suggestions and improve the changelog, as
> you suggested. I have some questions though, that I will comment inline,
> below.
> 
> First of all, what should we do regarding patch 1? Should I resubmit as
> part of V2, even with no changes - or pick it now and I only submit
> patch 2 as V2, with changes?
 
Please resend both patches together. 
 
> On 21/02/2026 05:52, Mike Rapoport wrote:
> > [...]
> >> +			string_get_size((u64)(map->size), 1, STRING_UNITS_2, txtsz, 16);
> > 
> > phys_addr_t should be casted automatically to u64 IMO.
> > And please, no magic numbers.
> 
> Specifically here, by magic number you mean my choice of 16, right? What
> do you suggest me to pick? It's the length of the string carrying the
> size of reserved_mem, some number must be selected for this
> length...lemme know WDYT.
 
sizeof(txtsz) should work :) 
 
> > [...] 
> > You can define "reserve_mem" attribute separately, and leave the existing
> > memblock_debug_show() as it was.
> > 
> >> +	} else
> >> +		memblock_debugfs_files(m);
> >> +
> >>  	return 0;
> >>  }
> >>  DEFINE_SHOW_ATTRIBUTE(memblock_debug);
> >> @@ -2762,6 +2791,9 @@ static int __init memblock_init_debugfs(void)
> >>  {
> >>  	struct dentry *root = debugfs_create_dir("memblock", NULL);
> > 
> > No need to create memblock directory in debugfs if there's nothing to show.
> > Could be something like
> > 
> > 	if (i!(IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) || reserved_mem_count))
> > 		return;
> > 
> > 	root = debugfs_create_dir("memblock", NULL);
> 
> Very good suggestions here, but just let me clarify: so I could continue
> showing the "reserved_mem_param" inside the "<debugfs>/memblock" folder,
> just using a different function for that attribute?

Yes, something like

static int memblock_reserve_mem_show(struct seq_file *m, void *private)
{
	...
}
DEFINE_SHOW_ATTRIBUTE(memblock_reserve_mem);
 
> I understood that, based on your (good) suggestion to hide the memblock
> folder if ARCH_KEEP_MEMBLOCK is not defined and there is no reserved_mem
> set ... just want to confirm to follow-up the implementation.

Yes, that's what I meant.

> Cheers,
> Guilherme

-- 
Sincerely yours,
Mike.

