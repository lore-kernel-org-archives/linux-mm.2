Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E0ECCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FF68E0037; Mon,  3 Nov 2025 03:05:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00298E002A; Mon,  3 Nov 2025 03:05:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF948E0037; Mon,  3 Nov 2025 03:05:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB968E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:05:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45BF28904C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:05:58 +0000 (UTC)
X-FDA: 84068562396.08.8322669
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id E37C61C0005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:05:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IWvYky2k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HHHt24oT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IWvYky2k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HHHt24oT;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762157156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kCzcdMMVzQByO/M/ivTSIZeuG0QmSvpmFe9MpD4DCo=;
	b=mJ9GES9XBk4NZHEGyT1YcPDb5fyTWUOH7UJ4MFo6OxgqRE3L8VyvaFAoweWU6HRbn8vFpi
	CdSRWAlOHr1ix3rt4x6Zm4tlf+5kNhEudJ8ssrV5GfNHXoXrkWH6gwVZuzBT5DaTXTA+AJ
	lujl0yX7FLrlPfmFi+PKmMZazvmBujQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762157156; a=rsa-sha256;
	cv=none;
	b=xHA12jZ5kSt29v0vMbdpIxlAtutgKHBFuHUdJeKdNCSeDRDCWHpvRkbSQO+oGzuB4fteSv
	3FvMdS4zTGyDn+6SqmDLTJNR/xztkjvsMUCuQGAkWyoSSggmnZ0E3YTWb9LoIVqN+ugc01
	qAuFdO+Ml0Gpf+Rj/GTaFfprtIAc0Q8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IWvYky2k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HHHt24oT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IWvYky2k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HHHt24oT;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5560221DC9;
	Mon,  3 Nov 2025 08:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762157154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kCzcdMMVzQByO/M/ivTSIZeuG0QmSvpmFe9MpD4DCo=;
	b=IWvYky2kLUkMEsXXhqEKF5kEsYt1OyCo3AsbPk5xM3+rhuPs+1bb4mYbgWUYcG3N43mGZa
	F0mFRI89ho3xGrqd24PIv1xvM3Jope4EaqLzxRW7KjOev81xUkkfjZeAaKbCey4xDf/G8j
	0rh70YVcw1jC0x/qEgaF/Yk96lAvq7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762157154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kCzcdMMVzQByO/M/ivTSIZeuG0QmSvpmFe9MpD4DCo=;
	b=HHHt24oTqGd+KxfECCrzRHNwBpak63P6fATQzb6nA0+iGsJnZtHL87gBSXK/MPM4dhsZE+
	xoq6WcIz1MKBkMDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762157154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kCzcdMMVzQByO/M/ivTSIZeuG0QmSvpmFe9MpD4DCo=;
	b=IWvYky2kLUkMEsXXhqEKF5kEsYt1OyCo3AsbPk5xM3+rhuPs+1bb4mYbgWUYcG3N43mGZa
	F0mFRI89ho3xGrqd24PIv1xvM3Jope4EaqLzxRW7KjOev81xUkkfjZeAaKbCey4xDf/G8j
	0rh70YVcw1jC0x/qEgaF/Yk96lAvq7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762157154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kCzcdMMVzQByO/M/ivTSIZeuG0QmSvpmFe9MpD4DCo=;
	b=HHHt24oTqGd+KxfECCrzRHNwBpak63P6fATQzb6nA0+iGsJnZtHL87gBSXK/MPM4dhsZE+
	xoq6WcIz1MKBkMDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A16F1364F;
	Mon,  3 Nov 2025 08:05:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H9VxAmJiCGlFWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 08:05:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 22C5AA2A61; Mon,  3 Nov 2025 09:05:49 +0100 (CET)
Date: Mon, 3 Nov 2025 09:05:49 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 04/25] ext4: make ext4_punch_hole() support large block
 size
Message-ID: <v55t7ujgvjf2wfrlbyiva4zuu6xv5pjl7lac5ykgzvgrgluipc@moyoiqdnyinl>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-5-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-5-libaokun@huaweicloud.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: bqpb9wtchrsz47mh5iq3ccoobdds6968
X-Rspam-User: 
X-Rspamd-Queue-Id: E37C61C0005
X-HE-Tag: 1762157155-104610
X-HE-Meta: U2FsdGVkX19Ch1vXctn0WtRjjpusLrW5E6iZRRZk9NfsQN47c7Zx/ND2xhCbcfJRZT+C/lYnddT0yJ1dirapvaj9Q2mKjH/uqrQn1efR12MGDvpaM25YYIWaysITFpf9J/E8x7N2G+h3jqckBeJ8Xv27RHSCx7sHVM6j6CDxs6gRb/HubMgeOtWADKFJ9aqn3sgkQL16c54P6l9RuunddIgiy705HI+jD2XU1Dp4/7QF2Dr7ek9OcsCAYCy5BLkIJN+4hQVCds5tiSr6lWnbIRQnVdgaFB3Q1LoytjytgUH7g+mKUYaueE37ewUwb7wDNaRNU3KrbQbEjnTTOMvLnTqlagMsrk+BKM48lOycEXPeO5qoBTrCu945j2FsF6+3+7dmxple7yenHUiHOV2INbIcRjWhyMsAInx8CbLWeQnvMgZcuXsW+q9rWwbJejKreXMrTiZT3UV0Ju7dbWvIgbvq8cTKdoOIBThP7c86GVx/79vCaMRuqOnDgmc6ny/L711uJQ03RjkkyR4AvhvPgf0IofpgxglO3F7BnXqtR38LsLzwm8hyzwNltU8ERNleCsQLj55CV5mN+VuFAz6UwBlO2IHpGiZOBZpKZBKqD7jou1V9323548MbKi3ywohuivQE2l7ESHb/mQprHWMwpsquMgEyL6jY2L8YYUW8uq8ZQoZM06fdRahMu2EgyiCLlmMOKj2HKI5cPDZ/QRU4IJ6lZGdPHI6HdL2OYU63Il8W4aRMGFJm7Pzf8mokB231nNQuzan7+qg02YxqjbJG4qme0x/5n+ytTC8izEnJCxezNWwLTdLkFJ5w2mWiiRaCCmzo7M2By47bae7Z+sKI6FoCAHFvq+wX4e74Bac0hrtNXa/aqyn4Vf+VgiaH9ph7jio6uVdc7AymzIktctWXMSFxk/GhOgk0xml2nr4I3ldyKE6l7Dw8wW+ggfWgEueGj8YzGR0o+cJvu/FM/uX
 0vY1mK2M
 y1y9B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:00, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Since the block size may be greater than the page size, when a hole
> extends beyond i_size, we need to align the hole's end upwards to the
> larger of PAGE_SIZE and blocksize.
> 
> This is to prevent the issues seen in commit 2be4751b21ae ("ext4: fix
> 2nd xfstests 127 punch hole failure") from reappearing after BS > PS
> is supported.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

When going for bs > ps support, I'm very suspicious of any code that keeps
using PAGE_SIZE because it doesn't make too much sense anymore. Usually that
should be either appropriate folio size or something like that. For example
in this case if we indeed rely on freeing some buffers then with 4k block
size in an order-2 folio things would be already broken.

As far as I'm checking truncate_inode_pages_range() already handles partial
folio invalidation fine so I think we should just use blocksize in the
rounding (to save pointless tail block zeroing) and be done with it.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4c04af7e51c9..a63513a3db53 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4401,7 +4401,8 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	 * the page that contains i_size.
>  	 */
>  	if (end > inode->i_size)

BTW I think here we should have >= (not your fault but we can fix it when
changing the code).

> -		end = round_up(inode->i_size, PAGE_SIZE);
> +		end = round_up(inode->i_size,
> +			       umax(PAGE_SIZE, sb->s_blocksize));
>  	if (end > max_end)
>  		end = max_end;
>  	length = end - offset;

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

