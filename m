Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA27C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464736B009D; Tue, 22 Sep 2026 07:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43BE36B009E; Tue, 22 Sep 2026 07:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351C16B00A4; Tue, 22 Sep 2026 07:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F05F6B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:35:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 989AA40435
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:35:13 +0000 (UTC)
X-FDA: 85241192106.18.5E611D5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 92558100003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:35:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dnuYEvhV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FQSJM2lW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kB/aZ+Ol";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZO0zUPM/";
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790076911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=wZGHxkZXGin779d3N85rLLKg5gkTd1haMtArSrKw7pkVDsl3kIWu7GnSPdQRSNFyD70LdJ
	tJ2KcbSct7NofPMiie7cmSY3QCviQp+nX3OiPQ2Ddo3PuJyZinNdwgCSKpoowtlY+i/LuB
	9H8v59HOU0TH/eqDMVlAYfOls/pJwxs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dnuYEvhV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FQSJM2lW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kB/aZ+Ol";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZO0zUPM/";
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790076911;
	b=C0DI7kmEh+oL2bk0g79hbUCq9IeSqW+aJg8hRw8/OTfkYYJUPQ6G8qu2euyDoSHQbk2hTT
	3lE9qA5Dp0IksNosmeQqh7EKC9Dv2TLoivHwsJ/x8Vi9O8648LjxLW+RTucO79pI9f1L5H
	cHEd8ALUbWkylRDrJZbbLrpYaOjWo0U=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 094B01F769;
	Tue, 22 Sep 2026 11:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790076906; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=dnuYEvhVPbmvayuEgEWwWquR8F4sHLQrOxLAH5VyRQcEfSz3ylC/KUrgdxt1Qt/t+T6V/4
	nmgs3pIZ6j7L0DlDKuibxWj2Xf5/iJhAlxa6BvhGlQ8c7qYK16/E6vkbWipEmDZgGhiopx
	Vhyn1x1mpppG2XUoR5gZ85qqKoUsQ8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790076906;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=FQSJM2lWhQZcnLYpgfaUvhbTkaeEfVokk4QPLgydhiUlnsjHhjiufEU+WhL4vls9tN9XVq
	TQXu9Oz30jPoj0DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790076902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=kB/aZ+OlFZ9UZ7yqapZcNkHIcapcK43UIxyW6fSQSvMdpl3Uu93M6X5hvw7ytzbJFZ2Cv+
	72UZTKdlBWZbylykbR7MmBC+OVmB2Wo5RJYJEp/tjGeN5BH0Jr87cVgXRXtIiHJVQj232w
	5FACwHrmNQlob8dVjL5Ul/9kFr4w8+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790076902;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=ZO0zUPM/DyUZAl8qbb8OeQThGVkzh4U+O4Y8VpZ6aUuMXNzR1XA/Lp/N5gRZgri+vQ0qfG
	Eu7Gc3ZeKg3ItUAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2C37132D3;
	Tue, 22 Sep 2026 11:35:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ksqgK+VnsmqmdAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 11:35:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 63538A13D4; Tue, 22 Sep 2026 13:35:01 +0200 (CEST)
Date: Tue, 22 Sep 2026 13:35:01 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz, ziy@nvidia.com, 
	bfoster@redhat.com, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 2/4] mm/truncate: look up the end-edge straddler by
 index
Message-ID: <beaedzhoq4frb4nyeecva4plxxpalojnqomxuyfaphflskttqq@vecce4gwtr45>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-3-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110703.468389-3-yi.zhang@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92558100003
X-Stat-Signature: iw3crzcqei4icpemhbzsof1tbtawge6q
X-HE-Tag: 1790076911-142460
X-HE-Meta: U2FsdGVkX18Tbxt+zwQrXC3xPiLOPdkdW2uYX+V8xG6JReh0sLAkFLkm+Eh2lUTJwNPhQ3dXFUZr9ryC799mEwuJsxrZ3CLxmxQhRwo8g0CZWTLGbGw8T+mnBfiqeIJCXSK1f7CLmJjYrXUszqvUrkL88IAhBqPwDZq+5sgGZBfGDXOlREUU/tmeHI7vm5icQDYVY7f7SSbxr/Gh8LqwcSe64BaVZ7yMnBoytcqrFPzD2PMf5uDM9iYNPAFPu9dPxCJX0/TOJOpSxl5lExS3sjQGq5XgWoShtFjyZ8NW9TZLTk0KndV9PrI0Xo9OaB4zGTnYDvFg3nwDnzCNKaEAvL+XkZG0zRF5mm79Hf10aqDgG/C4p2X16bLF6dbdcgSa8X9b9W1w4W9fVTWQZgU8YfuEfwEPKYIf85tx0qDoaqDMpSesWlDQ1sQIiF86+Ag0RYdsm3aDj37qs2zKHL2BEcmnv5PLZ9ihOCxYySbo9MhOBB78ulN1NPh9KLZ/pz0/8jMlvD0gai923fEA2J7Wm5wINOiXzLXsmvpkIdfrfpalm59Y7AZBKJaALx6yTreESucUdtZ2JdbVRYL27X4iMMSxYn3vKdUGIB01eXVyIxDchYwEbuhtxGO1c7P8OrxiEX5kw0o9A6xFfWk8vqbiUivfCPAQOyOGwxxCy32YfYIdvCorrt3IVXZ33Obo++OhyzkplqWNAxX0SHrPhqI9PaQ9MFnbbKnVkwBxph8cd8RDKKj12QYM41z3lkmcVnfLBjNUcf3E3L3hVopmmlWYqDS2QWsYxRlzr9uOSIQrA1dOr6odxPahNSzlEpMzTUHPg2nSFSAt5YZ7FjVp4gXRZrBO6wWPxfXRQ7dKZ3pnHgZXu1I3k88ZDVRYhKY3/Ps2k8cWY+h6N8cLwgBb38wGpe92l3Kkm+yQtIjrSR3Nbw3Zmc28jcgJjZKgXqIa5NChgSTs4EhBM1xfjfUt1I+
 sVxTzacZ
 4nZv61YhiKahvsLiHcIva2Sowcc0351moF9D+x4JffTHYbk+Dx5egXiOLXSKP/2v9bYp8btHcvjsT8d1yUrmVrqLpEIJsaHxFL12OA/T9VTaeNxMpibT+h1TjwWUisFfjgvp4qlJAM/xvu0exDrdd1vaHYWE6n1Po53v30XGi+oo1SiC99UXvYn7U7wtezxYnYzeDkL5xvRZCKlPGLDSFIPf8/pxYRkpV7DM4LVIGlwpIA4ME76nFJXeqs5jqqev7yiztS+sNEDGQi0BUSQqnbPwNLDlY/EcfM2R9OTtGZ4LyNSaueZM2ntLWJ91JTQnmtBBGup2SVFrnNAEMzsVi4dTl0R4Eoyl2eHbT74fYsONAKh4UvdSLlgMUmm4/zBWATr7piXTabDjX3rkNAmkvAR9PrxbxeHREUvOBmzP9MYcUVkMiYv+wfTLsFAaEIRylyWupsOXdE1bQBC2nMs0fLqJshQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 22-09-26 19:07:01, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In truncate_inode_partial_folio(), after the first split at the start
> edge, folio_split() unlocks and drops the refcount of the after-split
> sub-folios. The sub-folio straddling the end of the truncation range is
> therefore unlocked and only transiently ref'd in the page cache while
> the code still derives it from a page pointer inside the original folio.
> 
> Between the first split finishing and page_folio() resolving split_at2,
> that tail page can be reclaimed, freed and reallocated as a new large
> folio in the same mapping at a different file offset. folio2 then points
> at a folio that does not cover the end boundary, yet
> folio2->mapping == folio->mapping still holds, so the stale pointer
> passes the mapping check and folio_split_or_unmap() splits a folio at a
> wrong position (or, with a transient refcount, a use-after-free window
> opens between try_get and the split). __folio_split()'s own
> folio != page_folio(split_at) check cannot catch this either since
> split_at2 has been reallocated as part of the new folio, so
> page_folio(split_at2) resolves back to folio2.
> 
> Look the straddler up by its page index instead. __filemap_get_folio()
> returns the folio currently covering the boundary, ref'd and locked,
> with the mapping validated under the lock, so the split target is always
> the real folio at the end edge.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/message/20260916094500.C30061F00893%40smtp.kernel.org
> Link: https://lore.kernel.org/linux-mm/DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
> Cc: stable@vger.kernel.org
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/truncate.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index f9625bb4916f..a8a179b38252 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -259,30 +259,32 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		pgoff_t end_idx;
>  
>  		if (offset + length == size)
>  			goto no_split;
>  
> -		split_at2 = folio_page(folio,
> -				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
> -		folio2 = page_folio(split_at2);
> -
> -		if (!folio_try_get(folio2))
> +		/*
> +		 * After the first split at the start edge, the folio at the
> +		 * end edge may be freed and reused concurrently.
> +		 * __filemap_get_folio() looks up the straddler at end_idx
> +		 * and returns it locked and ref'd with the mapping
> +		 * validated.
> +		 */
> +		end_idx = (pos + offset + length) >> PAGE_SHIFT;
> +		folio2 = __filemap_get_folio(folio->mapping, end_idx,
> +					     FGP_LOCK | FGP_NOWAIT, 0);
> +		if (IS_ERR(folio2))
>  			goto no_split;
>  
> +		/* make sure folio2 is large */
>  		if (!folio_test_large(folio2))
>  			goto out;
>  
> -		if (!folio_trylock(folio2))
> -			goto out;
> -
> -		/* make sure folio2 is large and does not change its mapping */
> -		if (folio_test_large(folio2) &&
> -		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> -
> -		folio_unlock(folio2);
> +		split_at2 = folio_page(folio2, (end_idx - folio2->index));
> +		folio_split_or_unmap(folio2, split_at2, min_order);
>  out:
> +		folio_unlock(folio2);
>  		folio_put(folio2);
>  no_split:
>  		return true;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

