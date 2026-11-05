Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8674A606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=gpLik4Np;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IRCfsY0D;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qpZ4fh0Q;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/Zr3qgE1
Received: by kanga.kvack.org (Postfix)
	id A97B76B05B0; Thu,  5 Nov 2026 13:25:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48C96B05B1; Thu,  5 Nov 2026 13:25:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E776B05B2; Thu,  5 Nov 2026 13:25:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73A106B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:25:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 080E2120B8E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:25:46 +0000 (UTC)
X-FDA: 85401893892.16.7E4E1FC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id A6C2D20002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:25:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gpLik4Np;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IRCfsY0D;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qpZ4fh0Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/Zr3qgE1";
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793903144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43uhnSsbz3kHU9pdgxC9KmtDl/67WB1TNCWfONes/yw=;
	b=nMOu1AaFkRWYpVD7L/DkHIeHaWSfvmJvYHoJDmCMClxnwhn1bHHZ2RgcPEC6PLWLFtZWD2
	37MHo2/o65XyayFgEDw5cOmKxouInlyPX/GW+S2pxjE8nnZEPf4lOUjmuQrnUEgIH+Xgmn
	1JC8h9O/XhPdf2LFRTeMb57Qm1wOLTc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793903144;
	b=2NhkenMMGjA1FiWRDrZkPSzw6aFEqARylZ9dIseWM9gWFTmQptLk9IfU7huU4oVo0es/C/
	6g/++FMO2w3j9m78Hs3UaXIef9m8j0oFXT6vBGLj/ua0YTsBNJuhMhyIe1aDhlK247m1Wr
	ziYN8HxG0pZDgOHbY9w0SQLiCNzL4K8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gpLik4Np;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IRCfsY0D;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qpZ4fh0Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/Zr3qgE1";
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 680B41F806;
	Thu,  5 Nov 2026 18:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793903142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43uhnSsbz3kHU9pdgxC9KmtDl/67WB1TNCWfONes/yw=;
	b=gpLik4NpZai2UCjBWJ/B95wrHx4MFifwTzLWTRBPuU4JR4/ciZjfkZNijMo/jVikJg/ygF
	hXxQy95vm+/D72Fq30mAwhIbXoERwC3lkAK+lm6im+qEmXKSAMyCFceZGJneyxAC1IgVze
	Jzdww+rCxUQNhEyS3mcIi9GyDQooxhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793903142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43uhnSsbz3kHU9pdgxC9KmtDl/67WB1TNCWfONes/yw=;
	b=IRCfsY0DDHNNDPM4eXi8rOYTYZ4Xoyq6uw0m4wt/msxYws1pV66lh10BLLtzBT9ELWY4ZG
	CAAL25a7JaiBzFDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793903140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43uhnSsbz3kHU9pdgxC9KmtDl/67WB1TNCWfONes/yw=;
	b=qpZ4fh0QxEdi0FT26Cr+9xiUgjtuL0capIrgzL6ruIrFpfI80vQ6Zmkpoh/99Vql2oxws5
	cD93of+Fqf+ld9B00RpMC/cOTXFB/rLYJlmvqYUYgtvJ7BMtW5S1qcVmbueCji3IDM2wff
	LRazJdXXvLpumw9+JCsWwDGVSym4yKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793903140;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43uhnSsbz3kHU9pdgxC9KmtDl/67WB1TNCWfONes/yw=;
	b=/Zr3qgE1TUmuiHY93oePEYHUzm7HO4+DFmlFo2o14oM23SU60+Tpdx+yUWXDjuHfGG8YcQ
	Jd41VfGUr+OCttBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C052133F6;
	Thu,  5 Nov 2026 18:25:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3Xl0BiTK7GqAHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 18:25:40 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B89CDB819; Thu, 05 Nov 2026 19:25:39 +0100 (CET)
Date: Thu, 5 Nov 2026 19:25:39 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	shr@devkernel.io, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sashiko-bot@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback: avoid overflow when reporting BDI
 byte limits
Message-ID: <ijzndqxlfmivwaujc7nhtsa4p3hyd43g3aqud3vovajnd7jh7f@wcarf4xjxm5b>
References: <20261103193627.71959-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103193627.71959-1-dennylin0707@gmail.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Stat-Signature: fbsthoba6i7rkf19i7dxczzceisubjtf
X-Rspamd-Queue-Id: A6C2D20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793903143-675199
X-HE-Meta: U2FsdGVkX1/KlNRC/640VTR6JBq6aYndUwcaKebSEatQB+jtMI5LF6n8lBDCE9MD2S0gijUak/LNnWOFxaaN9N9VJ4e+sHVAGIiPrAUB7kj7p6rZhk1C3zQdsnF3Nn6RbfiZ7KL0IQwI2jKJwxMmn5SEVT7U3sHPTMV8kfDaV9RCuGqXKZHd3oEXcLRqVoLij3whbC/FtrReddk9H3e6PkSbirJsIa/PiGe4ho/oHRHhdbzNa+5i+n45l/U8QLj2XJ6IPVjA8IXGrt199kPe4tS7p+Q+p3ntNc0GyDs2dzJ60Au//cxCYKJHSCmYaVOx6Fe0VxfBxT6wkbGqSneunLYsK6jasaTboZM66zxCbxCZODQs/MopXzpet82Beq+vBrxkUqOhTSurB/IriZFGai+HBu4P908mW/8UlChzBvMaNDNCcxwhum7ij6vvvM9TToYJ4mMMV55OTxBvn5NPUOWJXF0BYiMZf7nWfhr6FoDYn0BOF6gT4er3aj9NlHAH/r1mAjGCdrcQ2AEVGv3n/7VTcOwiogUFj0UTjle0FVdzEzHVN3c1Yp+E5KohyFe12xfreK6iVX3CcJYFEAKWnoBp6MhMhaAoyH0nGT2pB0WG8n2ZyVRb8yqrJ+/6agAN+4eg9Bkn2C6wW9hcQyfmuazZtRDcIjDAS0Sn+sFMIguPt76whB+3qaqO6MZeWwsyf/kn2BgZhjZjwWR+TQvggans1emIxe/allLT1LLDgjTCbxsnlaPgeCtkNL+nTge43dLfV+0KgBAmmeQb3BYEjxtsqVtbAhUBhqvQoYvd28M9qpTDVS/r+wzLdUYkhwfdmAbLg3AcS5HEKCaa6m8lw1cKZ7DsTU2vZyIsXeMLSHCHEY4CYhHUUBIwfUu/QycsOngv4Z6Wmh1d+wrfc9SjyTdx25wiXZgJeEa1lErD37pMfTjxxlAc+X/VVPI8ysjmy/K2U+JLWCS2sC0EryE
 +uFpMbSS
 qVTTXQF1/4f9dPZBlf5ke6D8047/wUgkR11iuxO/5V+jbUT50Pxq52hPfhN9lqidM0URmNEOOxJAieLF+BlT4TPwCQIY17wYlMwotyGaa8Urn7PjnZCZ4CMyUtAJQa+dfebu3EcbiRMSu6ZhgA9vJUfPwaUv37ji2QwbAi7YHG6Ed58BdVfoJZiMN5neAdxWSQ3QI20QC7EMxiAj9epZ6Ei4EsbfGu09trYvWmTRfOl0hPoYHhB9wf0Nj05HVujI9zvq8KvfZF83NKqDQgR43meEa+jMuVCtLf+5fIc2dRKoKi5LE0T64AYI2PmLOry2T/sSZ7CsDqxSs5rRxVOHuImkn8AOZnPUe0fxOr41NzB5LVXl9Gaj9MG368m/Cn1bJbNzW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 03-11-26 19:36:26, Hungyu Lin wrote:
> bdi_get_bytes() multiplies unsigned long operands before assigning the
> result to u64. On 32-bit kernels, the intermediate product wraps and
> min_bytes and max_bytes report incorrect limits. For example, with
> vm.dirty_bytes set to 104857600 and max_ratio set to 100, max_bytes
> reports 268 instead of 104857600.
> 
> Convert the page count to bytes in u64 and use mul_u64_u32_div() to avoid
> overflow in the subsequent multiplication. This also handles large dirty
> limits on systems with larger pages. Combining the two divisions keeps
> the existing rounding behavior.
> 
> Fixes: 00df7d51263b ("mm: add bdi_get_max_bytes() function")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/page-writeback.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 499a35473e4f..ddebec79d8d9 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -665,7 +665,8 @@ static u64 bdi_get_bytes(unsigned int ratio)
>  	u64 bytes;
>  
>  	global_dirty_limits(&background_thresh, &dirty_thresh);
> -	bytes = (dirty_thresh * PAGE_SIZE * ratio) / BDI_RATIO_SCALE / 100;
> +	bytes = mul_u64_u32_div((u64)dirty_thresh << PAGE_SHIFT, ratio,
> +				100 * BDI_RATIO_SCALE);
>  
>  	return bytes;
>  }
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

