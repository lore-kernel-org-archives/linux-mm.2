Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E142CC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A686B008A; Thu, 30 Jul 2026 05:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E206A6B008C; Thu, 30 Jul 2026 05:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39366B0092; Thu, 30 Jul 2026 05:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7BE76B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:31:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42664A1ECF
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:31:57 +0000 (UTC)
X-FDA: 85044926274.29.452596B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2F7BF14000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:31:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tqarncfb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9kUfo/2L";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="X5/Su/p2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rU9fRx/k";
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785403915;
	b=Ff/QdzS3/Ug2643ssnU07LFzAgz3JEutwFiRLU3q9xgT1JY6b0G7mC1aONEDJJLvGghbc9
	islwZyrpKX922HrXS3NHwVskW9mRYTRm/0QaMRZT2gQW4nNEW72YSqmEyB+xCifslqpTOp
	xvFry9LaIr8zFAkiB/4UYno6/Ir0o2c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tqarncfb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9kUfo/2L";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="X5/Su/p2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rU9fRx/k";
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785403915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=x5g6P0Nxnl8MRIP4ruDWMFSSx+ik/I6SErWcYBYD0c0hnspVPp7EZMGY4ZH4NsRu9/Doht
	L15mqapqtHcljg/DJ3JzReJLPwyGZjPrXiSAg+uNI4JQV9jmIWaSFAJ0F2RfV3ma8EjH6X
	Bw0N1xrtXQNUWX0kUgGUgZBE+MkCzT8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 061617D4D4;
	Thu, 30 Jul 2026 09:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785403909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=TqarncfbgPxXXWBlixuAFNLDHy/2Tq9XaSSU74CxQPidY9A1MMnADQBQFYtDqlBqpiQV3w
	/7yc5/wh+3hu/qhjEqTyN539W3um1k1rzBEac6qfG5nkFO/r6+BrHdRZ4ibevWNhJHuIEz
	lDImgUWm7SZdXyj+cH08TGK5wsZ56kw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785403909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=9kUfo/2LzDHmEMVFfuthPN7OaCbT4qxiNH6ZAheRXnT7Zyjqk4vIXLFNZRWIIg9VghpNgt
	/jiWQLSq9nmcIvAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785403905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=X5/Su/p2jFL+Luy94478xOaWkPh2/4b3Y2ht638r051OM3+wojyx1YWlELDFHSuT1Gp/2y
	dywTkzFi9npuXU9JRleSE/DoUwztm4MtnYGjaOPna9yUlAHnF08B7iWbpFlci1rmNYg6Fm
	JQGyGsmIZok3Xjra7WXFbLNauNGPOzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785403905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=rU9fRx/ka+uy5uYh7zAjOzmzMobNvPEEw5TC9LzEtV3DKibEiiu3myFi65E4YFq4bozBs3
	jgftj8ZqjUfHcVAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF3AA779CC;
	Thu, 30 Jul 2026 09:31:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2mhiOgAaa2rndwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Jul 2026 09:31:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9C819A0AAA; Thu, 30 Jul 2026 11:31:44 +0200 (CEST)
Date: Thu, 30 Jul 2026 11:31:44 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 4/5] buffer: set BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <p2a3kz5oyjzsrbjivphnxv3dcf3gkjgtibd36fgfajajrfn4jr@m43y3mfpv4kb>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-4-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-4-3e8e6850068d@columbia.edu>
X-Stat-Signature: 63k7yj7owws3p59btgpw3x3q43athkeo
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2F7BF14000E
X-Rspam-User: 
X-HE-Tag: 1785403915-59287
X-HE-Meta: U2FsdGVkX1+z3hqVamY7XqXVUWliRrTDWi3bPnxc42PE7sedugTz197a0IPYFPMhuq6Q6JjpfET+Lt2kgeqAveAWFNvPRDsqEhXVIPZG18feJ3pyGnwmL1VPtBTdB9+Hq1VUwgliDrLM3Cvg/f6FbO7wMNfNazHoI+fXN5rLvP1sbD6Qe2m69HhV66MjxxGbRnKhKEz8FwkMhrEE4oAUXt3IeHu8pMZMyWslExdG/IJuPAk3EIqQDBA3WR/0C+uR4UIW20Cn2BxgGalh8uq5YmVgkHrTgl5Ck/m2POK1UBMJsKvB4XaiwZviBJRwtEeWa01iyEcwPnFWFhABMwHA0dojyjpBcZEy8fP4OUS9XJ5GMvj2RQpSc2KMlG3V45p0wHmXing5vbrkuo0gLglSNofGz4BhrYJPZ4ojvJwlMoJYwx3RDr2wO1Stlw3082IbQHph9DfYqsdbJObsy6yhpu7DAyTchkF4RAMv9VSUUr3+qKvMowUcF0wR4vnP3uKpgaBaIPlnJ6HvZY0mJychhK8Q2nxRruLeGrGbvlvSOTf41VNESBdJA6gb0/FyJQ4pRFd38tRCspJWIHJg7z64i4ThzfDVKWTve9LKQLBWenQ6p5PPT+YeeFlQJgxPyMGBrnmPXG8weOZcTrxdr8oN2m44wzDfRVv+E7RPWPuujKVQUWc4l8Nl3ek0/wDdKNtJZqQpmyYfDpmp2c5xWKvptFdCB2T47zOzsWMy2ZqC85T2QgR5RSZGBt9OKZYmKsehT12t6F5eLppqiC1MtmvqN1jc4QqLy0ycEqT8ioP/i3JuJZ0973jHftYtb7pHhJ0ePbHN0UnKdT6LfK+ZhHzDPExKQAzjoo8o9vWFIxB7WvYPyWMNr3sT1HO5AfJWflYEEMzz0OyH4qvqvIb0XEIRS3ZHC291yFFyvDjaoaetCTPdJvIOQVtDNeUDx1iv1ipLGRpJCAbe7AtD+wni+HY
 1ANoKUQ6
 Fr/UWhBAB1ISCuv150XA2jzXctm0pp/jbx6bPUgmTKT8J0gYHCKMWzXifW2TYAh1TaE3WbmEWkby29eq8a/6Z1o5WDqHlhA7Nj4gBzLD2/REw7SXJNodSTKyW/I/UkaIp+927EJVuc98/L6etTmx+tJpEbUL3UX5BTrSLbqXcuOw2R6byXOR+m3FLAP7TN7tzQpceCLFQXyul1LU9JlvdNPU9CYp3ww7g+9MFNOISdPuCWLbgMsQaYp2KWRFBWzmdWJHj2ksL22G1vCw7MN7OU8bKc23cZtp1OsVpPtVLzGx39HBCDRrHJBEyu1FaBPYqZp0Adm9ZvXwAY3yuE7vK13gYazTkaQCGui/sZVXk+O16RHNfo0SGx7cim0MTg94qxOsSDRZp3K0opxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 30-07-26 02:57:54, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK in __bh_submit() for write bios when the folio
> has dropbehind set, so that buffer_head writeback completions get
> deferred to task context where folio_end_dropbehind() can safely
> invalidate folios.
> 
> Read completions are not deferred since dropbehind invalidation for
> reads is handled synchronously by the reader.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 9af5f061a1f8..6f099847240e 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1203,6 +1203,9 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> +	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> +
>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
>  		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
>  
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

