Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 505461098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720CE6B0088; Fri, 20 Mar 2026 10:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8856B008C; Fri, 20 Mar 2026 10:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E1E6B00C1; Fri, 20 Mar 2026 10:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8EA6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:18:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F34008A51F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:18:49 +0000 (UTC)
X-FDA: 84566647578.29.EEF0D18
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 964C640013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:18:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qlm/XzM8";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sJ2pv+05;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qlm/XzM8";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sJ2pv+05;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774016328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgY6jfJC4I6lO/ZNgUgQPgQbvfgbEiK5mwVmPbXvrBQ=;
	b=Ad3ExsmHCu+/RSFwJRvS5GKJHMmbIH6SZ0AFiDncKmTSvhpRe/kxXJueXgp2y5Xb1QgaLX
	zMQy2suaOdxTyEloh0+Ieiw+SA92mAxkxujI1SeSASmMsVBhX597F2lYLGMbkBejHPtRva
	XLSN80/ytBFaEKTXWf4/EKrfRmPKNGU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qlm/XzM8";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sJ2pv+05;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qlm/XzM8";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sJ2pv+05;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774016328; a=rsa-sha256;
	cv=none;
	b=QcIveSc0K15a3+O8+sr9JndUYaV+KOwYomfhGU4CGGb7llj5eTBZ626iGfZnpSgwkpxOg3
	FE3w/zft8JRUvzC7ikTZ27fFfqAtROX3KjZyr7tUtDE9mnAi1yBiwT480Qg+yUsqVB2c4y
	sOCLFRw0oyFJecVRi4STeFBb9r5bdV8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F04414D277;
	Fri, 20 Mar 2026 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774016326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgY6jfJC4I6lO/ZNgUgQPgQbvfgbEiK5mwVmPbXvrBQ=;
	b=qlm/XzM8k7qpds2rq9lDHrqs/Z/wFeov19N9OPFrQBDs2mREGY40jdCVHyR4gD01EXn4uV
	2I4PcIGDRnDJx0A98NMeV8DmjjBs/edU2vsVF9BpGT5v7O+4KFjtKXpR/+gsaLyBW7AhR3
	8oA5M+wtYz1Xf/Xr9CD/H86P1jEs7IM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774016326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgY6jfJC4I6lO/ZNgUgQPgQbvfgbEiK5mwVmPbXvrBQ=;
	b=sJ2pv+05ecVbycZvzjP2XbL3oTqMmNo2hFgO7Iqq68GwzKxJKh2Oi4vMMozaeb557KPToW
	C0iXBJzrR9cyE/Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774016326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgY6jfJC4I6lO/ZNgUgQPgQbvfgbEiK5mwVmPbXvrBQ=;
	b=qlm/XzM8k7qpds2rq9lDHrqs/Z/wFeov19N9OPFrQBDs2mREGY40jdCVHyR4gD01EXn4uV
	2I4PcIGDRnDJx0A98NMeV8DmjjBs/edU2vsVF9BpGT5v7O+4KFjtKXpR/+gsaLyBW7AhR3
	8oA5M+wtYz1Xf/Xr9CD/H86P1jEs7IM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774016326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgY6jfJC4I6lO/ZNgUgQPgQbvfgbEiK5mwVmPbXvrBQ=;
	b=sJ2pv+05ecVbycZvzjP2XbL3oTqMmNo2hFgO7Iqq68GwzKxJKh2Oi4vMMozaeb557KPToW
	C0iXBJzrR9cyE/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E116D4283D;
	Fri, 20 Mar 2026 14:18:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2O/uNkVXvWmRMAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 14:18:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 99B39A0A81; Fri, 20 Mar 2026 15:18:45 +0100 (CET)
Date: Fri, 20 Mar 2026 15:18:45 +0100
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org,
	r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@quack3.kvack.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/4] mm: bypass mmap_miss heuristic for VM_EXEC
 readahead
Message-ID: <er6pfnbasao53shfs3vwznosqy4k74tjh4lxcegzwgdaweahdu@vgkhrdrhv5oe>
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320140315.979307-2-usama.arif@linux.dev>
X-Stat-Signature: m63cbzqp5k6qns65pkjqnfar7dh8mjnh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 964C640013
X-HE-Tag: 1774016327-540611
X-HE-Meta: U2FsdGVkX184kUWsabA0WD71D0hS4aiSvysN5n/d8UdGIAj08jroHsupfzBB4ZVfzCPDC62cWJG8STys8f8AddVt96HeasdQ18YbVKau+qE3bDxz/a6KIAavsd/WPF02HTT+pImk08xWJBB/a7d+bcJdEQfxsKZTN56/WK9ZOC1xaOBoQfZ4oyvlLThNae9t3AG+sbIiGzBBsZjONypvvSOqutJQfAf+E/5K9bZ1Cfjki59A3DcvMd6feOt8nJyXkkpyKdp9dqDkBr6M0tvFqasnZDgHSLvkZ5A1RGAqMkxmvVmeajeex92n5Fkj8CmArOYoHHfsDKwBGi+32SKV058eTYoceKELBMj1WCVZoCKBod8kG6ui2ZN//S39AyMx8yBWtA5yYfUgvOp35A94WjZB3s+PRHxTET9Tg84ykqlhjBngAU8Duxo1xoCiodkvu+nyanWqfxvQvALGiiRHOxsPkwJa0GpbSQqLDmmSACcHZ5+haUJZu6+c+TL5iQsHAndNuz+w714PSrzylnAlgmDfg9RKFoXyxlmZ4hhbzgC/YT15DFspvjDHTkcIzgk7H88OaBqizRpjdHGtJ1P2wAbW2wS4fi5IQSuh0zO/GQc6kJ7L4GZfPS1R1+Uo4tek1dVugLl2ilalssuCqEhxaYUo/zx98Aif9MW7LhKcX/pwwVLIuH/yd+MudJt9CG6jDrIJi3Sn4DUGKQP8a7kEnbdhFexzb0xoJQ+hAWU3piEnUXOTVz2Tjfz9mQWnwjqJtE8mQUP8ydcw7n68b8fHzb24q9cuMel/vrv4XJTHFu7Jb0c7Ii6Ybs3oq+3bg3zqB4a3fss4B1CrMFx7CIkAXDCqEVnwL8BPtLYw+MFHzHThatB/r85IKSrSSX3odkdJB7Pwd59zeelUXGwT7wIVUofds9T4dPEBfDRNmwhPGh6CSbcDYG1EIbw5B4rIuPqttEY/qHr26iUI47bRcvY
 jsxJ6qEU
 I3nv2/J4eo366mebQErKQb9U4Q0+y2ymc3jdj1WuMFt65I2ccYSmK6T8SPkxpbamlibfSRxsOq+5rL+ljd+Vgqva+Q7NfwSQtYX1qqJOPOyFmypf8VI2JHBULGsCVkTpP2FtBac9SOWe2Id9jnfRv0mA2eLHarOyyiWCTxwuitK8wCJ275rdNWsz7SVP9E4JbijJ3pgWtR/0H2zwLxb5tRQ4SxwijSVrjhEquxFN89V6gV+k+qPTSQvnNzxcRUUIQro8mLarKil0QAQPSZLo8Xl8ZpB7wEuT7rS6wEzdrEGHOYWpM/a/iAh4x3Xygo2au/oRiv2C4BPAGaxRO0/0tpLcinPvoy36KuFaj4JqyvYLWN7iOFzr5rE5yP8dcr8aDUzT77kP1UTb0r72voK5IfnkrmQCjUQ6CTnb/TkZsJYVqCkz5rnKm8QRpwU49D++Wf3RfGV3bwcDYygUndxomtJY0Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 20-03-26 06:58:51, Usama Arif wrote:
> The mmap_miss counter in do_sync_mmap_readahead() tracks whether
> readahead is useful for mmap'd file access. It is incremented by 1 on
> every page cache miss in do_sync_mmap_readahead(), and decremented in
> two places:
> 
>   - filemap_map_pages(): decremented by N for each of N pages
>     successfully mapped via fault-around (pages found already in cache,
>     evidence readahead was useful). Only pages not in the workingset
>     count as hits.
> 
>   - do_async_mmap_readahead(): decremented by 1 when a page with
>     PG_readahead is found in cache.
> 
> When the counter exceeds MMAP_LOTSAMISS (100), all readahead is
> disabled, including the targeted VM_EXEC readahead [1] that requests
> large folio orders for contpte mapping.
> 
> On arm64 with 64K base pages, both decrement paths are inactive:
> 
>   1. filemap_map_pages() is never called because fault_around_pages
>      (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
>      requires fault_around_pages > 1. With only 1 page in the
>      fault-around window, there is nothing "around" to map.
> 
>   2. do_async_mmap_readahead() never fires for exec mappings because
>      exec readahead sets async_size = 0, so no PG_readahead markers
>      are placed.
> 
> With no decrements, mmap_miss monotonically increases past
> MMAP_LOTSAMISS after 100 page faults, disabling all subsequent
> exec readahead.
> 
> Fix this by excluding VM_EXEC VMAs from the mmap_miss logic, similar
> to how VM_SEQ_READ is already excluded. The exec readahead path is
> targeted (one folio at the fault location, async_size=0), not
> speculative prefetch, so the mmap_miss heuristic designed to throttle
> wasteful speculative readahead should not apply to it.
> 
> [1] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6cd7974d4adab..7d89c6b384cc4 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3331,7 +3331,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		}
>  	}
>  
> -	if (!(vm_flags & VM_SEQ_READ)) {
> +	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
>  		/* Avoid banging the cache line if not needed */
>  		mmap_miss = READ_ONCE(ra->mmap_miss);
>  		if (mmap_miss < MMAP_LOTSAMISS * 10)
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

