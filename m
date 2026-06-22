Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D61ACDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C9F6B0088; Mon, 22 Jun 2026 05:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDA36B008A; Mon, 22 Jun 2026 05:41:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBF06B008C; Mon, 22 Jun 2026 05:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4606B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:41:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 199901A05A6
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:41:44 +0000 (UTC)
X-FDA: 84907056528.29.97A83A8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id D647140003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:41:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c767PsgN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qcBENdQQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c767PsgN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qcBENdQQ;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782121302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEP5WSzP4FK9AKt8AuztyiGTL1SDReGNlzFieNHQHCU=;
	b=jnvbNxT/bDNs+YxI+hWH78Eqvuap5Khc7+RZSlJszGQ1awgQ+9bMqOaeCq9btfRVWDkCH8
	pnnwaabCUHMNvtx0SsxMfKss/I+FuJtOhLoYlaIRmUwzIOI66E6P/a4u0Wi9X18P/+oiho
	VpO69aQpaTUz0Rq/VIgPf2h4I5YGlGk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782121302;
	b=OivzxvU3G02N2vw2U3w9U9TcgAzdjLOm/WfAJF1OOkMRSYL5g57R8rWmbxfMkzy3hz8gI0
	WwgUkG+hvwMTFEikALijlixAkXKZS28bXiogOmeo39uIDNsfupkoj36TcAkMqPD9zRdD1J
	pz3oc86Ga5Y8Ws7rFeFCt9TVSm+6v60=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c767PsgN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qcBENdQQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c767PsgN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qcBENdQQ;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 52F4670701;
	Mon, 22 Jun 2026 09:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782121300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEP5WSzP4FK9AKt8AuztyiGTL1SDReGNlzFieNHQHCU=;
	b=c767PsgN50IaMO8uSq35nEr18Q/5aMlV0rlKSFVea1+k9hVpMBeDYG2MfxcFJkTqgKuH6i
	0McSNr54ZLk8YLGyxrLCyqM0rlwRb1pBY7SsK7jQoH3UA65xy5u0dZI0QFuUR7EMNA0wQ+
	+BHkVbPUjIg3LciwKdz3ALU1A44JFR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782121300;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEP5WSzP4FK9AKt8AuztyiGTL1SDReGNlzFieNHQHCU=;
	b=qcBENdQQY3940Tftz3LBmPNDp5mtyepERPWRxEx7VYMSPhT9nJ2dDsiAt1COsx0dIEHS9/
	6Icv8+70rlT/cABg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782121300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEP5WSzP4FK9AKt8AuztyiGTL1SDReGNlzFieNHQHCU=;
	b=c767PsgN50IaMO8uSq35nEr18Q/5aMlV0rlKSFVea1+k9hVpMBeDYG2MfxcFJkTqgKuH6i
	0McSNr54ZLk8YLGyxrLCyqM0rlwRb1pBY7SsK7jQoH3UA65xy5u0dZI0QFuUR7EMNA0wQ+
	+BHkVbPUjIg3LciwKdz3ALU1A44JFR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782121300;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEP5WSzP4FK9AKt8AuztyiGTL1SDReGNlzFieNHQHCU=;
	b=qcBENdQQY3940Tftz3LBmPNDp5mtyepERPWRxEx7VYMSPhT9nJ2dDsiAt1COsx0dIEHS9/
	6Icv8+70rlT/cABg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 491D5779A8;
	Mon, 22 Jun 2026 09:41:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Il3YEVQDOWpwQwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 09:41:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E89E3A12DE; Mon, 22 Jun 2026 11:41:35 +0200 (CEST)
Date: Mon, 22 Jun 2026 11:41:35 +0200
From: Jan Kara <jack@suse.cz>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/filemap: reduce unnecessary xarray lookups when
 read cached pages
Message-ID: <b4igdzwm7vim23hcloatr2gpo4wlsbqkavq6bwifm7fbcehdai@op3ekmbv6so7>
References: <20260620062446.351475-1-chizhiling@163.com>
 <20260620062446.351475-2-chizhiling@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260620062446.351475-2-chizhiling@163.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: 96uib3crii81w5tzfkxqzeadqwksc8d6
X-Rspamd-Queue-Id: D647140003
X-Rspam-User: 
X-HE-Tag: 1782121301-395237
X-HE-Meta: U2FsdGVkX1+QCji9tWRsqBVRGNrY9v/aeJk8J+cegCuGL55gzh+vSZ0gaAGE1F+AgMSu2V7K8swsJs10CQHSYen4v+PlCqRDNUw51BEZ5toW5nN4V43gXH7PkMqq/fS2dne+JcWPE9zKTmJ5UcRhQ1kN3Q47TNbjg/ah2HQAJ+Bje1NeUvFmlE+osNJl35fEM4V0gUIugvBgGeuyI2EbKPfSuTrAbkQxKOXhCpS9Qs20MrZZeEsbNz13GNa+jlnSKpB5bh7+/z8zil2obrQ+jN3f2lA8Z/FxL358z1AplK8TNLsh6iLaPiedWxYBrKI86u4uRpcpeJ6Vv2TGM9STBxgEf64gX4gSryd2wFtrldvNOxunwG7qwE3ZO1yXEDHWxTmfTGFXXr6ONdmNb3dyOTG7+qvDa7lXqpuhxlEZMkO4juwyfWKutbfJnznTDp/3utcRCiz4HiClF9XafrIP3tS1y4xvCot/hkM5vmn26aMdT/C2isBECDyQCh7bg9rB2hSS5T8aa84Ph/A9ddbEFzg3qDHKJC9b7Y5cDt/LLdmblX7BZelxRNeXOfW1fBTF2mMD6m9CX0GEGhybocBxSv7Y3VQU7zC9HR2EDdr6MqOkO7e0BWTQy1foVZ2drxbW6YGUrPUKzEgqtIF5vyU40Irc4NmyJTkC1rYrDHtq748w2fUdsF81jmcUPCbi1v9h5g3Njvqg3HYVlwgEIG0lIRNUHDU57U1C/GrLPG8tIQ81do9oeDTg5aa1Qh5RqRjhLtFU8V+0rIVAhbeLuoE2sLyivmRwCYZ2JaeTEfaMBoRnRYfsUSPnZjUkgZnWS5E8xC28S3UiQ9HduiV4E+RV4o5JjvrJWbF/PR1zJrerncYhUmgwWOn4WoZWkHgSrwp3HHtlrMNdcs0In5ha3CtRRTJ0dHaw7k5FDqZhyXMmxVNZphEuuuQtlklSFDam10X+scpcEFHjKyzw82YRh//
 T/rUxg9x
 ObjXeM/7hi0ouuA1fFa+PW/zuV7enQnfWNYTO3kXrlGZXWqxgIFCf/476qn2lsYXx89Peh4sZLt1DGX7OIamshnoq2bE2dOUAf1T1m94PU59xVFqoAGbilKr8ERsAhC1Fx1fKNup9vM+dVZPMntBNrKHAyIzp0fbt1BaL2A1g+Ku6TZ4VKSH9VBP7yoKjRPJidqX5XtWcPr0hh1ziXpGEbv5H9K8rM/42eI31N5SZYeIA8fGfqvc6e38yRoUEg8PqSuYWlMlEflZCT07ghJ3sndoijktPakXpm/+zk+j6FnQWhlDctL4pAuhFTezDDgrZYHcJehy/kJ95F9fhLfXj96Iou/6f6EiO8PAXkMdCA09FqqzIxmHu20chF23umEPn92P4KrZXO7lxhcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 20-06-26 14:24:45, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> When reading small amounts of data from the page cache, only a single
> folio is typically returned from filemap_read_get_batch(). In this case,
> calling xas_advance() or xas_next() after adding the folio to the batch
> is unnecessary and only introduces extra branches.
> 
> The same issue exists for large reads, where one additional xarray walk
> is always performed before termination.
> 
> Quit the loop once we get the last folio in the range, so the final
> redundant xarray advancement can be avoided.
> 
> The xas_next() does not update xa_index when xas->xa_node is set to
> XAS_RESTART, so the put and retry path would not update xa_index,
> hence the warning should therefore never trigger.
> 
> During the 4k reads test, the overhead of this function dropped from
> 2.91% to 2.53%.
> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 09cf51fd43b2..199c835c68bf 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2467,11 +2467,14 @@ static void filemap_get_read_batch(struct address_space *mapping,
>  	XA_STATE(xas, &mapping->i_pages, index);
>  	struct folio *folio;
>  
> +	if (index > max)
> +		return;
> +
>  	rcu_read_lock();
>  	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
>  		if (xas_retry(&xas, folio))
>  			continue;
> -		if (xas.xa_index > max || xa_is_value(folio))
> +		if (xa_is_value(folio))
>  			break;
>  		if (xa_is_sibling(folio))
>  			break;
> @@ -2488,6 +2491,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
>  		if (folio_test_readahead(folio))
>  			break;
>  		xas_advance(&xas, folio_next_index(folio) - 1);
> +		if (xas.xa_index >= max)
> +			break;
>  		continue;
>  put_folio:
>  		folio_put(folio);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

