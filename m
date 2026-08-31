Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDB2C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B264A6B0095; Mon, 31 Aug 2026 06:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6C36B0098; Mon, 31 Aug 2026 06:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5126B0099; Mon, 31 Aug 2026 06:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F60F6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:04:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF567803D2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:04:13 +0000 (UTC)
X-FDA: 85161129186.19.639EE7E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id D7A2FC0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:04:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cAtqCcip;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6/9fk+PB";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YgbfcsDp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yumPuaO2;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyFzMlxgate4gjFGu5K3no73l6hUgvfdm1xyDOSnRmk=;
	b=u2tfkoiDx3sd+ljhp6NMC2JL0KtsHITaylYgMx2Aj85uJ2CAwFz7TE3UGAI33I7R0PEIii
	Lg/COi7oOP5FvHLppVA6qUEi0EZbSJMVSAaElVjHD27ASKtgnzntJnwhpN9Rqc9coiM3jL
	P1Bw0Yutndu09YWLimJrbo5sAADDonc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170652;
	b=t1uQmKDQertXwlQ59Lt39SSvOvoimEUMpluLPlF6+ys/KrW08j7+Up0A5ClPtQtzjsjQwJ
	xWMThk02IBdeJ2d2xKw6HoSup++4MGXqQ4clzPCQKID+FWiGuQSO9fYdchvKTOmvZpLiv0
	k4hWB8EaHAetbjW+cPlkzRRuDBB5isY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cAtqCcip;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6/9fk+PB";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YgbfcsDp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yumPuaO2;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 792D821C14;
	Mon, 31 Aug 2026 10:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oyFzMlxgate4gjFGu5K3no73l6hUgvfdm1xyDOSnRmk=;
	b=cAtqCcip6HDenN5TRFnC/XPhcQv5gdoaz8Ok2U50IAQj3SX1CuS9sFqJmqSRpb+FIyn2fN
	gajMWVYj1XtHejho+hg3Th3u5G5gnwSUplrtIzgIxN/eCr2YbJvaaYjlj1KYM+04mGg2Bv
	3dRUEswlM7b9RhycLaR3jPF5QbvXVS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170646;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oyFzMlxgate4gjFGu5K3no73l6hUgvfdm1xyDOSnRmk=;
	b=6/9fk+PBGsOFnCAEU1mzxFXa8bZulZX9hJ4MRCNmLZ4tT2kN/Zy0zEalwTYdlxOrAUAzqB
	oeMe8PXX+Wj2GECQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170642; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oyFzMlxgate4gjFGu5K3no73l6hUgvfdm1xyDOSnRmk=;
	b=YgbfcsDpuiXPiRIJdk3sH/1wYb0GIddDnfKVTwGD3EL77DPlCjg+FWTfIaeMp12lSUdcwf
	nsqyL4qPWnI9F5hq74OI9whxfEq1Jm/g29+Agylh05ek03C2l3C1TQHSuoOASOe0lxiz4e
	dtAQ/DmdSHTv04EzbgLd6SlFA/ZHlrk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170642;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oyFzMlxgate4gjFGu5K3no73l6hUgvfdm1xyDOSnRmk=;
	b=yumPuaO28o0zyWL7v7hocRihppgP5ARlKe7lPmvvV0N7jRCyaOfDO7JjUmzKqCCnO2tQj4
	H3+cxdBhjGLPN1CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B15C13515;
	Mon, 31 Aug 2026 10:04:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eEZGFpJRlWpudQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 10:04:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E49C7A13B5; Mon, 31 Aug 2026 12:03:53 +0200 (CEST)
Date: Mon, 31 Aug 2026 12:03:53 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
Message-ID: <pfgtqekyfsprme6htklelwrvuiazrm45oimome6a3h3fhuvalo@p4mridqzxu42>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-3-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7A2FC0003
X-Stat-Signature: 8qd9u78ksgekx55fbtqhhg4g9895bowx
X-Rspam-User: 
X-HE-Tag: 1788170651-575278
X-HE-Meta: U2FsdGVkX1+D01/YO1EL0zLk4nY13DR51/V1yRrBIoUxjuNEkfSp8T7Vp7MReQRCAi5Ul7ECIFFbKnvtQ9gBEGd/Hh0LkKDa8COVYtW9Wdl2QjO55OGBlTEmYMmLoBiH9hHICDpoy1KjCXSI1jsT1YH92sKQ+tMOK/rlWxaWW/3u9JIx21ElxvUtz9WXLCI3MYF4brWxQLqJAeO/VFfnNSxNjYRre/dTtLRf/ERwPmQjjKwcwZbx4ZwEnOB/AYYHe/0SFRRisB5i84Ws7Dd3SeBvvnJMRTN4ocWBk8BhVQeIqKiT7zifhJKaoFDewX2hHBZilgtl67dqyeJb7/GmD0oZJsarPHcwhVuX/46gABkvVCbd6h8zxSTlTJeqYsF4rG7NwA8gxIrzrF9I+9YJGODx79lqQtoaw6344GGjZ3qWZhMmUulqI5L6ndgQ8Vhj6V8JAvKHC/VX4z/cFs4QdKqASsnPt6PSe1MNa54uul21jgzsHIxWqcxvYJD6nmYobmMz7HPbquBv9pAEJX9J5eto6o1d1P1zeGSvMLeadRh5DonJ02OQsRJMLgW3TeIk4s2M+CtNf/zqU+Y9Q+i34NCVeSlWchwrOi+bwRXS6hNZDLNV9iczEOwjBAnirS/k74+4NssTpAVNg4MQ86czoO5VsmAGYXkdxBt9rY0hAsGjsJkbDLQVnTRGPFuIGp4fGs7Jz/a4slnMsmRcdgzVHxmNBmyvtOpQ4ng9g85kpGtI9sYx+F2jrUbj2J46qeRtbO0zzPrsFpvOHmB+e/DQjplplZ34+JzllM6KyhHgHKouw3Vqj26ARFy8E6HGXmTQxpDxmMQQnfCATgP358lfaISmQcA6NRbsqZoE+IMvMeCsFQfwbAWZuaEQUjBIg2a0vdGpENT4dz7+U2TGOaToHmZg6Wr5dP5ciJUv9HX1SbH+ISR6wit6cxxYtwSr3svLzVNVm/Lu30Mel9zsfir
 +lNh+7uB
 4qcQJ+RUYKF8MmQ4NyEPxYENQBB0D4HbB5dvO2m5WywRDZBaJzy8NK0C70YAykmil7DO4byYPhWiJwRJPMzEwIiXwJbO0L8yHCQeAOARmIO9ifmOvSxQuI7yv5cLCJAJgmoHODF7SVbQdvDvK9dBStEOdxg41ukT0soTSf/CuxqmLJD12GKSvPR0JnlW9VGGwZ+EGPVCMLu8hL5CNZayA9STvmCXGJ/z9uGqL4YcCj6OsA4sa5aaFma4SaEkVkkbApZ2H9Vbk9wyTOXeGRv/6opgJF9Kgl7ui7OZ1juOCHdZN4fVPdDCilubXwGE6PcWkPkXfoRiKQLDkJZxNLV+Dmo7pCfGC9BLUttJ/YOe9SUQTnqtltqPZjGxfOsJMSWRFUnxa7WPWg/cqCzLNCFHalpUiLOogS6OXyfip+dB4kGVliqcCx4Wt0sC3TlwgDFbJB8JGn2bDeB0UucHXYMwmuJAY2d702RT2wwObtMIqC9/66cO9HtZSoB+gZsHUCtiSkppWbmOox1R+cbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 30-08-26 05:18:49, Matthew Wilcox (Oracle) wrote:
> Both of these locations are called while a transaction is in progress.
> Starting a transaction uses memalloc_nofs_save(), so we are already
> prevented from recursing into the filesystem and using GFP_NOFS was
> unnecessary.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inline.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..1884abb09614 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -601,9 +601,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
>  		goto out;
>  	}
>  
> -	/* We cannot recurse into the filesystem as the transaction is already
> -	 * started */
> -	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		ret = PTR_ERR(folio);
> @@ -734,7 +732,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
>  		goto out_release_bh;
>  	}
>  
> -	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
>  					mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		ret = PTR_ERR(folio);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

