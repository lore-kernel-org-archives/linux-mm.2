Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EAE1CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 10:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1836B6B0005; Wed,  6 May 2026 06:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DE16B0088; Wed,  6 May 2026 06:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18256B008A; Wed,  6 May 2026 06:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB9DF6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:32:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A7ED1C004F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:32:53 +0000 (UTC)
X-FDA: 84736631826.23.03F9653
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3DED71C0008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:32:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=klKNtHvk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=U1BhRSrv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=klKNtHvk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=U1BhRSrv;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778063571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dw3eLXGex+5o8NBWnWLhM6PbgiAEuMnx+2DUwT80UP4=;
	b=a6aoTW/GBgX9GYspzz4763J0N9u90b0kc4/KpnuJu+l6UqLlUWsW7nVmLbg/vCZNefVPct
	ox9DL3ZuxpZOnXWYhEnFC+XuR9jV0g9uxbHjzJiXnIl8CsqXGn63OlkGoeoW4rTAcvzHYs
	WaPRLHWQ+aS96Wd0OCPpU93Czlwye1M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=klKNtHvk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=U1BhRSrv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=klKNtHvk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=U1BhRSrv;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778063571; a=rsa-sha256;
	cv=none;
	b=h2eC7NhZ4qU4nTNH4HAylvLEVpslUhIFk9Fr6LecGsIoOKWlNGsgrIfHRmD+g+2QQfG2/o
	9RFj355oaOFAeoY/SrTuJPfGFLnKdIFzcdTlquLhLtlXg+WdSVp/dkgAMVTe4HQOF3cG4Z
	0IlTF9FdyO6mk/sdXKgGhyfBL6mj3b4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F6696B76A;
	Wed,  6 May 2026 10:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778063569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dw3eLXGex+5o8NBWnWLhM6PbgiAEuMnx+2DUwT80UP4=;
	b=klKNtHvkoQwllFeb4OyEMdzQYB4K2bviAb0peUy0IQf5hlTahBTVrZvPt9qeXGA9r3Dwvp
	59CzZRFJOnB8+MdAEfbMLOMys/euI3+hWsZtmHHAduv9EpAmzAX2LKIqUs3qVllD0d9ZHb
	LcV0V/6kdVbzGb7bLP32YHjtSL0pbvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778063569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dw3eLXGex+5o8NBWnWLhM6PbgiAEuMnx+2DUwT80UP4=;
	b=U1BhRSrvq252+rK80ZxleqvaebLnAA240N9G9oGajsc3OVrohCkoGHQ5rnHkK8STne9J2Y
	0iysZxfwH5VMsQBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778063569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dw3eLXGex+5o8NBWnWLhM6PbgiAEuMnx+2DUwT80UP4=;
	b=klKNtHvkoQwllFeb4OyEMdzQYB4K2bviAb0peUy0IQf5hlTahBTVrZvPt9qeXGA9r3Dwvp
	59CzZRFJOnB8+MdAEfbMLOMys/euI3+hWsZtmHHAduv9EpAmzAX2LKIqUs3qVllD0d9ZHb
	LcV0V/6kdVbzGb7bLP32YHjtSL0pbvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778063569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dw3eLXGex+5o8NBWnWLhM6PbgiAEuMnx+2DUwT80UP4=;
	b=U1BhRSrvq252+rK80ZxleqvaebLnAA240N9G9oGajsc3OVrohCkoGHQ5rnHkK8STne9J2Y
	0iysZxfwH5VMsQBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39104593A3;
	Wed,  6 May 2026 10:32:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rqHrDdEY+2m6PQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 06 May 2026 10:32:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A23CA0790; Wed, 06 May 2026 12:32:48 +0200 (CEST)
Date: Wed, 6 May 2026 12:32:48 +0200
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Chuck Lever <chuck.lever@oracle.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v6 1/2] mm: track DONTCACHE dirty pages per bdi_writeback
Message-ID: <zj7w24dm7qk64sp37ai7jvt54vyfftzmbvxwladwkoqhggi3d7@ivb4gkk5t6rj>
References: <20260505-dontcache-v6-0-66463805dd6a@kernel.org>
 <20260505-dontcache-v6-1-66463805dd6a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505-dontcache-v6-1-66463805dd6a@kernel.org>
X-Stat-Signature: 38pw6bzk31qcjykmmz55jnbzszm41g7e
X-Rspamd-Queue-Id: 3DED71C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778063571-205697
X-HE-Meta: U2FsdGVkX1/PU8oMkidbb6c89CuTqr9N8v8lDlBkG4kvKdc0b/x1l+wJDKxwpF8TImB94n/8I/kPyvEb3qKwpaeJ+xxnjJ6xKr6xCxTu5NKDnX2gZGhsz0LA0AEbDuOZswhhJWXO2kBIMSBrq5HCio5xinZpR/LqoWopeRSgBXokdejNUktnXIz2Naiqwi8iYUFFlXIvqN4rnIHZW00wH2ZOLzoyPzbYBbHrlR2QUH4E2CsopHv29fESN54/yIU6um4OrQqBWOfIK1L/64W2h9E2ooHqtlmFZWgnPPlOsrGS8ece7c0S2ekkwA/z6NrOoZd7mWuGUxDjVRXQTFEq43wZxI1tbJplpO9XrZlqLDUjq/i7jSfaiDYRfwzNLN0Ha+IxBzQ+1fAI2StWAGmGjwJyhGg/D+FtcF7+HucUtlgQeMq09J/tQXDVXwhwV01xZl/0MDG2L97vgnlEtm68cJh2hPWQrZmmkEgS6bzkSIv1u2pt/Hghhoj8+JojNkBm5qrF01QeNXNcQftl8ACErMI5zmk3/dQ1rI95waYQCtY7+4fnFGsxgI9l6YvYYUxNAcZOOel/jK9AGmkqJYQt6FWT36xM+RJSvk9eVQKw4kJc5YrJnPPfc6mYhZOTOlqAybLyuHbz3ZyiifXyxNOT/6lSdlTBSjqsP319YU6NAGez9UYtBk+740URxOMpmpEOi1VXvJqxrUEFzJVmmUSiAxOqioXdqBBT8xb8Ox31IzRCgAO0IpUB4qu1a9l/e2ev3PNENo180Jv70g4/okwen+4yBnhjUDPk28O1N3WsTx0siPU7Vg9oIGVeN1KsYtPKT/7uFbxz1jylICyXhnGxXN+HN4cmel3H97MzIp8uD/LBtqzVlDpY85yQLwQwz61oAkTklp3wyINgJt+Gts5B0i3oF/WJQK2mCad27iKX8nRjdtJltu/Sn0WUpfdgnRrop/Usan3bXEh/AUrHuP5
 2UkVoNWp
 yH7IifbpAoO8Lrb5d8r58pePDFXJ0AFVx7r6WlPXoZPz2+pUwzbVSoecCkRY5x9sU3eXS1RwCrTF1Xg6xuz6KNxdb8A4UKwWF6d2nNPmQ2tuE0KswluOVTMjk3uwcLu78gQvum/GJ2wmHWd+xa06j8iwzGQ0ixQXouCl0MMuI813UZxwrp5BES0i7/+6U71nrc+SarxxTHspHY6/huDZEqoKJRYiHpbvXcZzx+96+6YmKpVr4EM5GwZqjFA9TPRz0CRks2AJ+D8j2/2Tfrj52LPWQ4QWECwHX3naHuMWAMg+fEUanPjSR67BPN8PPmKosdAL8M3O9t51HRzEKjr3NH/V7S8BJ0cIrT0y/jsch12x+MmUgSC9Lbb/ZOZFlFNpejUDnPlrzwxlALUhYgIxiIko01h1GkPj5ZiZtiO/CaJDBYuBb58ROcaO8+a4Da5PTERGPkiuyK27iK4EGAzhDb00Va6xKss6zTxxx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 05-05-26 20:59:48, Jeff Layton wrote:
> Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
> pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
> writes).
> 
> Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
> when the folio has the dropbehind flag set, and decrement it in
> folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
> when a non-DONTCACHE lookup atomically clears the dropbehind flag on a
> dirty folio in __filemap_get_folio_mpol(), using folio_test_clear_dropbehind()
> to prevent concurrent lookups from double-decrementing the counter, and
> guarding the decrement with mapping_can_writeback() to match the increment
> path.
> 
> The counter will be used by the writeback flusher to determine how many
> pages to write back when expediting writeback for IOCB_DONTCACHE writes,
> without flushing the entire BDI's dirty pages.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Yeah, good catch with the folio_test_clear_dropbehind(). Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/backing-dev-defs.h |  1 +
>  mm/filemap.c                     | 15 +++++++++++++--
>  mm/page-writeback.c              |  6 ++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index a06b93446d10..cb660dd37286 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -33,6 +33,7 @@ enum wb_stat_item {
>  	WB_WRITEBACK,
>  	WB_DIRTIED,
>  	WB_WRITTEN,
> +	WB_DONTCACHE_DIRTY,
>  	NR_WB_STAT_ITEMS
>  };
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c..e706f5c4ece4 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2052,8 +2052,19 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  	if (!folio)
>  		return ERR_PTR(-ENOENT);
>  	/* not an uncached lookup, clear uncached if set */
> -	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
> -		folio_clear_dropbehind(folio);
> +	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
> +		if (folio_test_dirty(folio) &&
> +		    mapping_can_writeback(mapping)) {
> +			struct inode *inode = mapping->host;
> +			struct bdi_writeback *wb;
> +			struct wb_lock_cookie cookie = {};
> +
> +			wb = unlocked_inode_to_wb_begin(inode, &cookie);
> +			wb_stat_mod(wb, WB_DONTCACHE_DIRTY,
> +				    -folio_nr_pages(folio));
> +			unlocked_inode_to_wb_end(inode, &cookie);
> +		}
> +	}
>  	return folio;
>  }
>  EXPORT_SYMBOL(__filemap_get_folio_mpol);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 88cd53d4ba09..8e520717d1f6 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2630,6 +2630,8 @@ static void folio_account_dirtied(struct folio *folio,
>  		wb = inode_to_wb(inode);
>  
>  		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
> +		if (folio_test_dropbehind(folio))
> +			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
>  		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
>  		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
>  		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
> @@ -2651,6 +2653,8 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
>  	long nr = folio_nr_pages(folio);
>  
>  	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
> +	if (folio_test_dropbehind(folio))
> +		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
>  	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
>  	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
>  	task_io_account_cancelled_write(nr * PAGE_SIZE);
> @@ -2920,6 +2924,8 @@ bool folio_clear_dirty_for_io(struct folio *folio)
>  		if (folio_test_clear_dirty(folio)) {
>  			long nr = folio_nr_pages(folio);
>  			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
> +			if (folio_test_dropbehind(folio))
> +				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
>  			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
>  			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
>  			ret = true;
> 
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

