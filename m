Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC20CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4786B008A; Wed, 13 May 2026 03:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355476B008C; Wed, 13 May 2026 03:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A856B0092; Wed, 13 May 2026 03:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 160436B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:50:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B14CC8DBFC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:50:44 +0000 (UTC)
X-FDA: 84761624808.24.8E43009
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F323140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:50:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QjY17WuU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3/2LlsYC";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QjY17WuU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3/2LlsYC";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vo3gnd9tOVkdydRyuHDb1N7zfRJ+dGjn+dOeC9LZ6yc=;
	b=8ftKIyBJw2Vknj7pJRfYd9vpQksQpXTdBY1b4MV7bpQt9lTcb9GwffDrzz7gTyl93+dRUL
	PhvETGmI07Nuii8Fdc8czhtf8K+oe1X47GcuTBIwnyPbbjlMaxpKFaVXcLl3bygsjJTkmw
	uG/4Ipmz1pOBsnZ1ZIcWCP2UP9DwOdM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658642; a=rsa-sha256;
	cv=none;
	b=qaXg55mez7ERqsEjOC5LNUZ81L+ckmeGFgNMfMU43A7lZDsdrba4IAUrJSpREP/xvzvvYd
	7/stWu6M2iGLBIeq6QpA42eSJFtHplvhkQnSJmWrjR/xYTpwduhVdi1pxUOLEMGDqYBK5/
	hqGxU95cClHpU1JLoJsbzKjYSl45H4Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QjY17WuU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3/2LlsYC";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QjY17WuU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3/2LlsYC";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4FDC57605B;
	Wed, 13 May 2026 07:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778658639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vo3gnd9tOVkdydRyuHDb1N7zfRJ+dGjn+dOeC9LZ6yc=;
	b=QjY17WuUC58PIFYigADFQvCE3rF/h7uW9OOywqyAXjx1vG5Y3NoffCPLhgtyvp0mxW79sx
	EFDmthKekNV7h28r00oDwLnKbz4VB3BZegvbl6Mcw1I80wHbzw3KcRi5T3Ay3bUnPQ8/B+
	hGPPr+/zMAxyJoGhHXvs0DhL7l9+d5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778658639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vo3gnd9tOVkdydRyuHDb1N7zfRJ+dGjn+dOeC9LZ6yc=;
	b=3/2LlsYC0ifFYRzcbHROh0SpDFLMt/DozcOgc/KqGnVAc/UXKLU38yCpof4c1RGNgxqzWC
	U8XzILNX/iIVfWDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778658639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vo3gnd9tOVkdydRyuHDb1N7zfRJ+dGjn+dOeC9LZ6yc=;
	b=QjY17WuUC58PIFYigADFQvCE3rF/h7uW9OOywqyAXjx1vG5Y3NoffCPLhgtyvp0mxW79sx
	EFDmthKekNV7h28r00oDwLnKbz4VB3BZegvbl6Mcw1I80wHbzw3KcRi5T3Ay3bUnPQ8/B+
	hGPPr+/zMAxyJoGhHXvs0DhL7l9+d5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778658639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vo3gnd9tOVkdydRyuHDb1N7zfRJ+dGjn+dOeC9LZ6yc=;
	b=3/2LlsYC0ifFYRzcbHROh0SpDFLMt/DozcOgc/KqGnVAc/UXKLU38yCpof4c1RGNgxqzWC
	U8XzILNX/iIVfWDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46981593A9;
	Wed, 13 May 2026 07:50:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wwE3EU8tBGrwBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 13 May 2026 07:50:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C94FAA0800; Wed, 13 May 2026 09:50:34 +0200 (CEST)
Date: Wed, 13 May 2026 09:50:34 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Vishal Moola <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: fix page_cache_prev_miss() when no hole
 is found
Message-ID: <tjfvsxenoioeoxacuj3yy55zygz5acvgwha34lr5uxxm4563xy@hy4a5wfu2ksx>
References: <20260512-prev_miss_fix-v2-1-4af8e5c1ae62@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512-prev_miss_fix-v2-1-4af8e5c1ae62@columbia.edu>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F323140002
X-Stat-Signature: s5mhd6xqsf896szuttqm761ht8e9dwme
X-Rspam-User: 
X-HE-Tag: 1778658641-585155
X-HE-Meta: U2FsdGVkX18XrE+34n2iDVQScvZvHAdRIwUunaaTTNBNGKTYlqhJwtmfBwJlm/5HpgPHcc+DbFrT8Rqbm81bKYHcTZ87AJXyoN4FdkPSZPVTirES+su/MJBX69r2b/Y4Qx6SL8ssgjx6bs+zUL9U4TioVjoqCe8+hqoAuFbPiS6tSZ2RDYdJpz/dvQDRVRLkzNAS29C3T1mlaekPKvKWoOZiwjija7IT+FszlSg3Jo9Jqia8s5F0VCwaPaK2kwIPprnwSZWA1aFVsC1zYlSeBA09Pi3PvtTD8mdajjUBpoJj3gDoBPJrOGV9E0XxtFToGZeI0qyWA7bwACPrlDFMQakOxhqIkbbWlEJfXk4+ar5lUx6eyCkseoqqP+XsgXyllWyVxxgISsbqUe6aYEQl4QvRwy3pZQ0O+9VrVOMC6MmEjsESrXTogXKV0RFeM+tL+LDxF6HhSRfsFjfbJuiN6SKI0ZtmlUUQ5EETHUqoluz4YwXn7bBS57VyL94lRs1rzmq2mGRXK1vIPUdrGk7E0yiepgM6RQtzM5yGtpbFTx8C9dgg7NmBclwSPf53WNHeQGc9+hsuwMUBjkhIcq1WlNDlDyrf6559RiEqpNJJT1UwKDHdxG/jVDetZ5mYQCkQqf/3ETBlxMErmeommeC717x3tJ+NzqLkWdHLL+5OFBQxmfTZeys7QSO6pRaydZYcYx4e0YmP8ne9oyrykJ1xa46p6Iue+T7IkdSdo6cYQzStIztzIa8HTy05Nl1obxulcFJJyu9ZbqfEKv09r1fnjYtWj5knWMKhnx3CVuObxs4BLTvbWP2CEre+YmOsXfTbpjGcsKw3jpIhPKcVrjZGr6a6ciSlSntjPKrzrfYB3yLD+ZyXbF3fMRq5X8O/+2Av1wirQrXygSHYmJjemuK8igQ3eUwvZ0WU/Hykqcxj0l62/qfppOnFq6o1nTE+aNb3dYjGp4lOpVQY9f+aZ3P
 f6WSL1JL
 cGh0ObdNOIYWej2jqIiipNiKQL7o64C9921L+bwdVxADYSV6NVubGC52eFun2grk+/WbmagH96Bfg6XpqdgCWKBOQJ46FO8F+vVhY6h/HKyJbAdfG8mMo8DCK9U7eCxWo/0cTjM5EWsENGFcLCS/YUZPZMeQ+B4MdHZpkJlTSCu8OmmT6wnf0Md4Uc73i1bhPz3ZlFzJZQHeQHXkM/h+eYigMadXTQHtmGeE78360G/o5522euUncs1n1RMhmPCyxfQ3XhzerGO+Q5m5phOt9nRdWdDUzDAlXxst9lf7usjeoJ1J7yaqN47Bl1kbdrs25kPDoWphdm1AxU/BqSXnuoL4e2jwMKW6id2J9Qo0ZS9Hy2BIoNTiVd8no4VZZFsmYPNSEIAd6c3W2mdhsUh6T/mrsMMUQJVWjAjm3pJ/Ko8hem0+DwBjYzrF5bYN2x5luyUFgO5NOMAsibOTRxCeO7ldXExNKewZIquKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 12-05-26 16:45:59, Tal Zussman wrote:
> page_cache_prev_miss() is documented to return a value outside the
> searched range when no gap is found. However, the no-gap-found path
> returns xas.xa_index, which after a successful loop is the first index
> in the range. As such, that index is misreported as a gap.
> 
> The sole caller, page_cache_sync_ra(), uses the return value to estimate
> the cached run preceding a sequential read. In some cases, the buggy
> return value can undercount the contiguous range by one, shrinking the
> readahead window or pushing borderline requests into the
> small-random-read branch.
> 
> Fix this by returning the start of the range - 1 when no hole is found.
> Update page_cache_next_miss() for clarity as well.
> 
> Both helpers were previously fixed together in commit 9425c591e06a
> ("page cache: fix page_cache_next/prev_miss off by one"), but the fix
> was reverted because it caused a hugetlb performance regression. hugetlb
> no longer uses these functions and next_miss was subsequently refixed
> in commit 901a269ff3d5 ("filemap: fix page_cache_next_miss() when no
> hole found") and commit bbcaee20e03e ("readahead: fix return value of
> page_cache_next_miss() when no hole is found"), but prev_miss was not
> addressed.
> 
> This was found by pointing Claude Opus 4.7 at mm/filemap.c.
> 
> Fixes: 0d3f92966629 ("page cache: Convert hole search to XArray")
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - Change return value for clarity, per Vishal and Jan.
> - Update page_cache_next_miss() for consistency and get rid of nr variable.
> - Link to v1: https://lore.kernel.org/r/20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu
> ---
>  mm/filemap.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ab34cab2416a..4263d9775998 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1808,9 +1808,8 @@ pgoff_t page_cache_next_miss(struct address_space *mapping,
>  			     pgoff_t index, unsigned long max_scan)
>  {
>  	XA_STATE(xas, &mapping->i_pages, index);
> -	unsigned long nr = max_scan;
>  
> -	while (nr--) {
> +	while (max_scan--) {
>  		void *entry = xas_next(&xas);
>  		if (!entry || xa_is_value(entry))
>  			return xas.xa_index;
> @@ -1818,7 +1817,8 @@ pgoff_t page_cache_next_miss(struct address_space *mapping,
>  			return 0;
>  	}
>  
> -	return index + max_scan;
> +	/* Return end of the range + 1 when no hole is found */
> +	return xas.xa_index + 1;
>  }
>  EXPORT_SYMBOL(page_cache_next_miss);
>  
> @@ -1849,12 +1849,13 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
>  	while (max_scan--) {
>  		void *entry = xas_prev(&xas);
>  		if (!entry || xa_is_value(entry))
> -			break;
> +			return xas.xa_index;
>  		if (xas.xa_index == ULONG_MAX)
> -			break;
> +			return ULONG_MAX;
>  	}
>  
> -	return xas.xa_index;
> +	/* Return start of the range - 1 when no hole is found */
> +	return xas.xa_index - 1;
>  }
>  EXPORT_SYMBOL(page_cache_prev_miss);
>  
> 
> ---
> base-commit: e9dd96806dbc2d50a66770b6a86962bd5d601153
> change-id: 20260510-prev_miss_fix-fcb308472131
> 
> Best regards,
> -- 
> Tal Zussman <tz2294@columbia.edu>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

