Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDD2CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82D56B008A; Mon, 22 Jun 2026 05:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33776B008C; Mon, 22 Jun 2026 05:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22936B0092; Mon, 22 Jun 2026 05:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92F206B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:45:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A7AA405B2
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:45:08 +0000 (UTC)
X-FDA: 84907065096.27.AB1E1D8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id B61424000F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:45:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=07fja9HP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9XY7ja74;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MOop4gpu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7oEoYWGq;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782121506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awkGMLcNQTXeoZYS3WSSrFuhu9UYarp2Pp+iMwFqadQ=;
	b=kqLUA7gnTDE6efdaflKmk6v80Y8pY70+B9PeUEFtpK0FGEplbeQO75z8dcx54rgQTcEKto
	XBSukbTmt3m+7ShW31e/fOzb5iqCi6/yVLqIkqc/QCwyKNwyNTXETWfINx8U0QIOvmNFP1
	iEj5+Xf1YXBJu3sBuPOlXPJLuXtZtGs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=07fja9HP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9XY7ja74;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MOop4gpu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7oEoYWGq;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782121506;
	b=2uihwuLEP/qsbvTEEsytVDSMyKy8u0FhGXkPmo/xnOgbtLntpMRcVKm4JVE3XBFw4XeN8C
	Bpmp+nF88jDl73sgcHVLp4dAhsWD/nij3cN3VQKjJBmMUBW7gXk8KEpKYiOz3Sp6M/SJrr
	5dGQE3QmK2fLlSTkNoZLwiXIj/AwRkA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 411AD75C77;
	Mon, 22 Jun 2026 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782121504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awkGMLcNQTXeoZYS3WSSrFuhu9UYarp2Pp+iMwFqadQ=;
	b=07fja9HPTM9mrOeQ9kTjjZDpnykpKOVj2QGbffa2CkoCM2ZB1HokGz9okyUKeZzadJiW4o
	Mkxbm+HrsFadSfZu4HHP5CXExQW28qGD9lNwcnlQFtMIY8YBIVXcwSJ+1y3bcs+Wxv+sLy
	S3FO8An8KzUrF/fTxvPNa0VjahDJrDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782121504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awkGMLcNQTXeoZYS3WSSrFuhu9UYarp2Pp+iMwFqadQ=;
	b=9XY7ja74QqMm2l2oUaeWaUOIVYpUhMefDP2PUO5nXRYPxfjpGvK2p7rvcJ23v2HdNa+EuL
	ePxOhdM31pwzbIDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782121503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awkGMLcNQTXeoZYS3WSSrFuhu9UYarp2Pp+iMwFqadQ=;
	b=MOop4gpuAEmAdUk2XT1F0kBCviZXTkmFbodDR+hzYA1agCt2L0oqcVUtsm0UDhYNR4d/+W
	kmMyAZzX8jX4uIe2RXGyRBQLlwFqG6qunCXyprlAg7/pcwRN0uWdLZQWyj7JJReWeLa9vu
	GHwqP8gnrzlBrR+ZhvqHNVXNqcdXQmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782121503;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awkGMLcNQTXeoZYS3WSSrFuhu9UYarp2Pp+iMwFqadQ=;
	b=7oEoYWGqzLPNkxotKFWQtvkIrjJTNMjiCPrPQzrvJRa1eFXeja11YfC6CUPAXMb/gdBgI4
	FmhUFOKSvBSmVyAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 390B3779A8;
	Mon, 22 Jun 2026 09:45:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GRTsDR8EOWrfRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 09:45:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D5086A12DE; Mon, 22 Jun 2026 11:45:02 +0200 (CEST)
Date: Mon, 22 Jun 2026 11:45:02 +0200
From: Jan Kara <jack@suse.cz>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH 2/2] mm/filemap: reduce unnecessary xarray lookups in
 filemap_get_folios_contig()
Message-ID: <wznnhy6lnmwiwb6yay3rnuq23ougftzkxlckdne2ujrfi57g24@ylpkr7snc6ho>
References: <20260620062446.351475-1-chizhiling@163.com>
 <20260620062446.351475-3-chizhiling@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260620062446.351475-3-chizhiling@163.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B61424000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: et5wa1xqbz1dj4nfw6n9jpxr4pwks8in
X-HE-Tag: 1782121505-329618
X-HE-Meta: U2FsdGVkX1+z4scpIKW/C1iQpk4CLYhA33Jd6tPyT0Y8UQqEjQShG8jlSmS/QLYaxlOhlkV474Fqwa/vGGYMV6gUVxGe9wiMRqM12GWjNgjT8xmcgFfh1qkwqBOONVu5DF8oNM5oNfVg12gKRqffcWIrQky50f8pnTLDZYKL+MYy0mu1Y147ldZBXgJCSzJKpFWrr8/DPjXm5p1LDo722IWrXN4PbqBfe0wWiX8FKy6NBSoI/jKfRlW7lfBuF4L/WvcYzLCQ3ggJQNSzlKvfbU76/jnBXmPlkxtHQgm2DfZYDP9cq4Tap5Uw5G7BEXzMV6HK/nWKirSlxceS/rI9lW34g5N/wwgr304Gn/KpOsxgN1mhcNeZGpxgcH3G4ry4Sla4pkjIqMDB/7F4djgVkJ2lJ5HR+WqBrcDUrRXfpGV9pekrklYiK+P3wWy0kJni47ImvWh3BgqlUOUOUf3gId2iBAdmf3oMA4Z37/4Q9ETcF6LZ24FpeT+4ahkXFZKA45TQF1gwFQJliGeDQlVad5KFe8uamh5qIHG+EU+A99qtFk97pYlOdYuQWfRYRFsiKlpQrdy4JlKF6FS7LKZIFuXGatq5SDF8DxtcnGiJaNV5h+IxNSeMFArrNv/5d3xg9GqDHX272/Vqa+Gj3Qx62WC96lVRkWvNUl4mWIAWNtEZXqFCJSDJXt9L7wQyYUzL7i4IdQtqulaP8aaAD18/JvaTqtUvLmstLEqhpxK8fyhh+w9SRD5TJNVfzFY3bWQBV3+/wp9eMFic5GIic7ls11RYJgPD5tri0eZojSq0vidGyGiNWjkTAPQZy6R3ddp+FaPvtAdKp8lJVHt/rJWWHJsolSbZvXcisYngR4g7GZDFaelQBfEh8cpvkLOp6797pZXJa0PonOP3wxB3DFL7x1nJVc1HJKGKxslwNR3H5M9NTvHoAc32qVMykyUJJLmyUcps1px2XjHuCUvJLu2
 H/irmsyI
 GkNKHMeFTSnr8PUt7cgBz+s6a6NMNIFWM8hnKTsoy6UPBdvgaXKPwFtV3NVEHmSbzp718uC5h1DOQZF+4/i047C3SCqY1EtDuqblN2ik8Og0GPiH3o8ryqPFt/xBgQNVAYSOyohi5fZG7sWjcWDVN80ORC7w40VzMVaeow9GhiyZV3Hx3FSOzQ1+OucTDuByBzD3aE8iCs0hE0x7FnOUlP57R+x4+noT03X8r0Gz3zu1Cn5S6+DePQF2QprhUGygIC7m5pc10KGKGoiFyeYJvSBsJNfdPxDgKFWM2wIq6g9akKP3ADmg9LQMZwbHRqbsvkn3+KOE5pP/P6XrJuIGW7WO9ub6vEScUr0h8gRwBardf4M5kP5DdDn2AQWxbbDbxoznBRASD2G7uaCcXHnX0HlVA3C5HLQMSmgcc/4UF0gFdrivWwa8Ec4b+xINd7JN6C+uHcwrsYsvKHVER9tdpgNciyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 20-06-26 14:24:46, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Apply the same optimization used in filemap_get_read_batch() by moving
> the boundary check from the loop condition to before xas_next(),
> avoiding an unnecessary xarray lookup and reducing branches in the fast
> path.
> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>

Nice. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 199c835c68bf..4ee591bc7e71 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2270,10 +2270,11 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
>  	unsigned long nr;
>  	struct folio *folio;
>  
> -	rcu_read_lock();
> +	if (*start > end)
> +		return 0;
>  
> -	for (folio = xas_load(&xas); folio && xas.xa_index <= end;
> -			folio = xas_next(&xas)) {
> +	rcu_read_lock();
> +	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
>  		if (xas_retry(&xas, folio))
>  			continue;
>  		/*
> @@ -2281,11 +2282,11 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
>  		 * No current caller is looking for DAX entries.
>  		 */
>  		if (xa_is_value(folio))
> -			goto update_start;
> +			break;
>  
>  		/* If we landed in the middle of a THP, continue at its end. */
>  		if (xa_is_sibling(folio))
> -			goto update_start;
> +			break;
>  
>  		if (!folio_try_get(folio))
>  			goto retry;
> @@ -2293,29 +2294,27 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
>  		if (unlikely(folio != xas_reload(&xas)))
>  			goto put_folio;
>  
> -		if (!folio_batch_add(fbatch, folio)) {
> -			*start = folio_next_index(folio);
> -			goto out;
> -		}
> +		if (!folio_batch_add(fbatch, folio))
> +			break;
> +
>  		xas_advance(&xas, folio_next_index(folio) - 1);
> +		if (xas.xa_index >= end)
> +			break;
>  		continue;
> +
>  put_folio:
>  		folio_put(folio);
> -
>  retry:
>  		xas_reset(&xas);
>  	}
> +	rcu_read_unlock();
>  
> -update_start:
>  	nr = folio_batch_count(fbatch);
> -
>  	if (nr) {
>  		folio = fbatch->folios[nr - 1];
>  		*start = folio_next_index(folio);
>  	}
> -out:
> -	rcu_read_unlock();
> -	return folio_batch_count(fbatch);
> +	return nr;
>  }
>  EXPORT_SYMBOL(filemap_get_folios_contig);
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

