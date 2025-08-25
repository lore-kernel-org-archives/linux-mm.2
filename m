Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F99CA0FE9
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603BE8E001D; Mon, 25 Aug 2025 08:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0668E0001; Mon, 25 Aug 2025 08:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F06D8E001D; Mon, 25 Aug 2025 08:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 384E28E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:39:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E13191603C3
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:39:03 +0000 (UTC)
X-FDA: 83815234566.09.5E3923C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9B1AE4000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:39:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pF8Nbxm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="UwKMu/qY";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pF8Nbxm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="UwKMu/qY";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756125542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQKERY0gFCIR+jm7WWR7qikFq9VvvmVNurg4iIGtOY8=;
	b=VSpJq916AlZH9vO32Qm7zFFgh+pIBSqbtZh7zwXI5YkgUPaB8w62yo7zEXLs2E++q5Syw9
	GaatM3c9r+L7BJrvVPsV6q/dE4A9tf3Jl2dYRuZOn9DKq5RfSIOaam1BPd/jixFt9aZyQd
	OjQmjKRueHAvo7nyk/zzIz5N3LSt6vc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pF8Nbxm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="UwKMu/qY";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pF8Nbxm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="UwKMu/qY";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756125542; a=rsa-sha256;
	cv=none;
	b=YhpH+ROcWTDpCigwHiv+zhvpqfXHV6LlHoL1DQuZ6cHQZGhwYbWyPT6WiP0hYx/biMZ9zr
	5ZuIXiZrp4lZwBxLplWxVVKKWrOnFNl0i7hz8wGNEV7WXtkB3K9sMKki8Z3KI3wque+aES
	QijK47nKtTifCPKgruL/M5xXMfAtMiQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A04281F79B;
	Mon, 25 Aug 2025 12:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756125539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WQKERY0gFCIR+jm7WWR7qikFq9VvvmVNurg4iIGtOY8=;
	b=pF8Nbxm9gj1Z5xXl6uSSIYEOwEi52SmimrLEyhfrWIs7QEjumdSRA3EHjI39LBXYf01AiQ
	9KZpef6117k5aPn00Xg8+bap+FIIrFbUraKmj7sYeRDkZDhCb9nPmssfR2hkHiP622XEHL
	j5u/LCiH2449VsVAhJujc99MjZ+xgCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756125539;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WQKERY0gFCIR+jm7WWR7qikFq9VvvmVNurg4iIGtOY8=;
	b=UwKMu/qY/z8l23SMxk7OZpRviw8TS7SSuVySOG77bLeav4F0mFrFhvN6J6WNPT2xL63DAb
	NdtLw9qup/qATPBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756125539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WQKERY0gFCIR+jm7WWR7qikFq9VvvmVNurg4iIGtOY8=;
	b=pF8Nbxm9gj1Z5xXl6uSSIYEOwEi52SmimrLEyhfrWIs7QEjumdSRA3EHjI39LBXYf01AiQ
	9KZpef6117k5aPn00Xg8+bap+FIIrFbUraKmj7sYeRDkZDhCb9nPmssfR2hkHiP622XEHL
	j5u/LCiH2449VsVAhJujc99MjZ+xgCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756125539;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WQKERY0gFCIR+jm7WWR7qikFq9VvvmVNurg4iIGtOY8=;
	b=UwKMu/qY/z8l23SMxk7OZpRviw8TS7SSuVySOG77bLeav4F0mFrFhvN6J6WNPT2xL63DAb
	NdtLw9qup/qATPBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89F84136DB;
	Mon, 25 Aug 2025 12:38:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GeamIWNZrGjiFgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 Aug 2025 12:38:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 40D2EA0951; Mon, 25 Aug 2025 14:38:59 +0200 (CEST)
Date: Mon, 25 Aug 2025 14:38:59 +0200
From: Jan Kara <jack@suse.cz>
To: Xichao Zhao <zhao.xichao@vivo.com>
Cc: kees@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: Fix incorrect type for ret
Message-ID: <5vuf4s75su54l7rximdssebspytj64yivk6adlrydyu7lyduux@am2vv2rs2hac>
References: <20250825073609.219855-1-zhao.xichao@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825073609.219855-1-zhao.xichao@vivo.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B1AE4000B
X-Stat-Signature: xtw1x3to1685xjyaszsp8taqf7jo4xy4
X-Rspam-User: 
X-HE-Tag: 1756125541-547437
X-HE-Meta: U2FsdGVkX182E2XJOb8okTae7TK1yCjnogBXQqzOuufhlrFB+scCD9Qpqbpxyn7QrdGuXmDPwEtqAKPqqOGjecqsioYrtttK1Vsq7eFwTtGRauNt1j+pYPxXDw6OPzECZuRlDBYn//AfRKBN9EymaGNsOIYq8pXVjBxW8GoHLxDWbdCWfCH3JgLwkY5mK3X0K88nZEKQ0JK0o5YMbDFGjXVloy5C5iJVeSOf4aah8picxDAYLOFoslyOmUxM9ReyHIhYya9WmkAt4iXUW67PWwcAI9h1TMlXd0KAqjmPvfvvx8PD1mFRYOrkPI2r3cJkI3Wg4rnY2y5mRaZCgPjTx4RuAsmebbrHHLuDWAnYwjqQAuJot3ouTHh9tzycJTBIrS/0jzv/7SlP5XJU3Qvn8cdmhgyQOthSx5+VLhe16swVqm2sZM7czRJvv0vwZJpekXaQLcAavvSbOv8sLRZ+zKFKFMl1RB5lvNHA9+HEg50Tep6s7+jk9lvx78XUu6A1/XW1BqzsEzl4OMA5bLjuYAo4U+Joz5R4o1QtFWoR+hqKfM1GP9p4WSAtDVdID+ju5JtGXBC6dAqLveVFgz3u42tTHlQuYfK8KjKhujTRvMpIZQkWEVTfmljfUTQImwtmvrkHG6HB2YnLVU0zg93AIqhkXlLGwCpScL6rv7BSATndXYc3vFoP0Tj8iey5cCklH9kXHrkMGOEY48LIe7MX1tuSyeFF4tb3IG0QaOgn6pPlgQf59AFO61RN+vK0H/4/D9GXq040lbhheNLCYjCYMPI7pXmMamkWm93gsNNt3teP3nk8NEoUCJFB924h3uGIgK2Dj3Bo0ohkoDqItZsaFB8RHu8wytSX4+8+Rvo/kz5N/YxrPmkMBYHT9VmJjIK8cjMn1khwobG4N3n7ck+dkX/8ySs1661eWrid3go8lJztZ/AGcp6s/fhoCNH6//DrG9TAnoQb++eu6e1Kk6j
 P9sQ49E+
 V7QFkY1dbOw+qNPKFBYMM7AaUXjQth8o5PmSalZAOFG3SVixSL48lb66Wa6WxcoRNCSVVrqFId7fFdAH4v07uJiCI46pQW7ogs96h+rwUH7FxbPDcaAH26/iFkATQ8vlMt5kMFKWljniKIUajbEwieVnR0geTxiI+FsUTsT0MPGh7ubFmelknLMyabTqmclngteM+aNCY1vwBYUcHrtTtX/AhtCw48mf5Jx/iXzL5reo/XFu9rG24ADb1s+pxHCWWg6ieXnkd58aEQogaPWT7a1jw37+MSLmNLABW5eeJCBW4GX4FYu38oM9ywsQJ8eTUINjSaZ0q9yPkFdyN8WWtVbjXrLwkDin/WM8fTOgmDeuOibemXrUn4tIykJmxbv/eMi94H/QS7YO/TgA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 25-08-25 15:36:09, Xichao Zhao wrote:
> In the setup_arg_pages(), ret is declared as an unsigned long.
> The ret might take a negative value. Therefore, its type should
> be changed to int.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>

Indeed, all three functions for which it is used are returning int. Feel
free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/exec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 2a1e5e4042a1..5d236bb87df5 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -599,7 +599,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
>  		    unsigned long stack_top,
>  		    int executable_stack)
>  {
> -	unsigned long ret;
> +	int ret;
>  	unsigned long stack_shift;
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma = bprm->vma;
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

