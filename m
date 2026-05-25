Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6734CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6696B008C; Mon, 25 May 2026 12:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA75B6B0093; Mon, 25 May 2026 12:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96326B0095; Mon, 25 May 2026 12:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C87CD6B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:22:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 685D2C04E6
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:22:33 +0000 (UTC)
X-FDA: 84806460186.08.BE61E15
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2AC2C140005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:22:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Hk83kw2e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kr7oZb07;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Hk83kw2e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kr7oZb07;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779726151; a=rsa-sha256;
	cv=none;
	b=vgbfRXTtnB9EhC0PlwkEEiBMbeLO5kgRVPrbIIobi09/iC2ukHed/Lt4uubmcPyNisJSYH
	0gHDzZNX3Cy2HvXNiEturJsG476Y8VAnZ7DzhBWwivC4LwZQyVBQbHKx0QhWozDRNV8HQA
	WERwbb2ZutXaxtZUxIEJ6APwREJlIGw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Hk83kw2e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kr7oZb07;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Hk83kw2e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kr7oZb07;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779726151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yg5/0e5Hd71L3mzyiZoWVcp0/KiS6m5Nnzvnp69+OA=;
	b=YSJVg37HHEBUzS722Wr8BIVgDSPVPkIrcrXV1Db1wjpFZiIuTW5TNlfkC9vxUJVpyi0GJ4
	zijKx3PgSEWA2FgM4NiPQgHWF/69vaXBS/S2OQm26bcnl62G4KLfGFmVct6lKPHlRNvEVO
	2aidYwxgbeegOBBjPENNFicrwf/Y5ds=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C5B0B759A9;
	Mon, 25 May 2026 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779726149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yg5/0e5Hd71L3mzyiZoWVcp0/KiS6m5Nnzvnp69+OA=;
	b=Hk83kw2eQLXQmB/fIyNkVHEC6jmAc6A2TziZ0xAxKNcYZIt6RajeKE0epZDIbUbsdwKFHG
	eDJO7fxaoMgkPgJcBVTAN0sBMESBwhqScCcBtspmbLfyFAQL3AnDgzut2Rtyns6wklqJAK
	4ZQw/wdQ8GKiMoin+WYDu8BDtemOA3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779726149;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yg5/0e5Hd71L3mzyiZoWVcp0/KiS6m5Nnzvnp69+OA=;
	b=Kr7oZb07JJQUrH+Yt9lfHmhb6X8E/wL9gjZLLAuvszjj9n0ZcvEy6Y4M/1i6qEqq28bYmR
	E/0ObMr1XkOX+TDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779726149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yg5/0e5Hd71L3mzyiZoWVcp0/KiS6m5Nnzvnp69+OA=;
	b=Hk83kw2eQLXQmB/fIyNkVHEC6jmAc6A2TziZ0xAxKNcYZIt6RajeKE0epZDIbUbsdwKFHG
	eDJO7fxaoMgkPgJcBVTAN0sBMESBwhqScCcBtspmbLfyFAQL3AnDgzut2Rtyns6wklqJAK
	4ZQw/wdQ8GKiMoin+WYDu8BDtemOA3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779726149;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yg5/0e5Hd71L3mzyiZoWVcp0/KiS6m5Nnzvnp69+OA=;
	b=Kr7oZb07JJQUrH+Yt9lfHmhb6X8E/wL9gjZLLAuvszjj9n0ZcvEy6Y4M/1i6qEqq28bYmR
	E/0ObMr1XkOX+TDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A9E9259D29;
	Mon, 25 May 2026 16:22:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eft4KUV3FGrEIwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:22:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AB0BEA08D7; Mon, 25 May 2026 18:22:13 +0200 (CEST)
Date: Mon, 25 May 2026 18:22:13 +0200
From: Jan Kara <jack@suse.cz>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/17] fs/namespace: use __getname() to allocate mntpath
 buffer
Message-ID: <lwnrjpmzbv6swapmnmb5jki3xxxzqsxuks5vykniwhakvhqh7i@rhff3qrwfnoj>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-14-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-14-275e36a83f0e@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AC2C140005
X-Rspamd-Server: rspam03
X-Stat-Signature: wetqgnnxzeaqw13s6ukt111j5stgp4nc
X-HE-Tag: 1779726151-722019
X-HE-Meta: U2FsdGVkX1/dqO0w5r8MF/Y9cb3tGj0quXeAneZfEOef69ki+q8m9/N4RELj9EpwyYTErmyrIyVO1oBsH6aEm9HR69hLAQ6gwHykH4bE7dioSMF61brb8uge8IFr8kJn92fFJqR9UjE1KzcgYnr64LnlgRYj6zHmQL5O92so4jdHlYQxWG4cD96iWZWr7955Ynl30ksZJRxoZoWVB+lY0Qs2c9yGPAUBF/3JS1SJ61Cy/SJ/zDI3WfmqFdEGLg9lqRIvIDoBF/7zDMtA45tYK+VPlvT0LhrbSyqBQerbD8sAa3cg9xJrMtSclNaG3/tl21VL4V6DMG2TUGdVQJVBWL5TSGmPhuVorJy8eaSX9Rb7q1Yy9ngaWNHVwlslMc+SwgTeHik/3EHu08bAtqfODrMJL0/OIzs9+0q1LR4onL8eKNvSYCAhoR3dNsqn+ARjzjZx+Pk7m1ACPjTDCxhh/NndV1FCI7LM0e9w5Ap7r/Oz6O04VgYetz8HRo7cnLjkRLIpJymWhFxjNrpX+kcjfCxitjUIKxLljyNpo1Erq6kUWiZk990sZ44FM/w35tpGWnb3HyuG0JCTxaOQM4Hgy6gDQkma/dQlcDT23XChNOpTiw8HpfC/bRWPj3Y6sjSm3PiFezVpdDe/JCzcX4hmoN2/uks/+qSMdpFSWvHJysqtDUAkwmjmDznXv4u/bG//sbDXCI4whQzMBJWtBeiaYqToxQ9K+TX0Hmrsd3KQOX1YvBzXhyf4e75+2yoA/Uxa/TXzdxR8j7/tQPz2Px8aPx1WJ2DluFa4m9z/hjWfxJcD+XZO6qHHDIjt6ULiPgXGM2ajdmenrs6GmXmzShmHoFMyD8Socu791oomtgv2hHnmsI/XvPhgUKDyTPpF0/8Kcsn5QFPC9YTUJ5+LfHKHTlvWto2p2MOs022qkRzJzSFp225G+LMCCaHtgC+k0FEc6ZYLUaTdZoi9l4e9/LI
 Yha6uH4/
 vpPVfitp7X+mN4fImC1Px8sVMewMk/zLgYnbmJve5YTTMKN6aH/slu9c3agZ/ilIuXRqHO/2QK1yrhvhg+DdQwrTdyQhNGXUTSa5utLzODBI53vRrvIYI54jLh1n7p8J/DMu5G0XSmxsYUBMB7rFQYjvMhqQCZupsOgLyyDDOq4iyRtBVAt1il9k254PvLtDOKbg1OJyxtrQtyiL67WLfNTTfnAmUOLXOSLLO0IsYZrLdFRg0Pi3NlqTSgyRj8965mvGFbpwAbrsVd00kviZdI1Pr3jFGrv0fPyzpGvcSwwhDQMj6pQnlTWnSOjZjC0RF7s6pP4Fl0p9du6jKmxVquKR8UpOGquR92LbVggDWsIToCAPP7Q2ayHPffWIzJSALhuYqWAS/s17IO4/J63dLcfSKKhKEHOPguwCXWTCskMTfCEK6XXlEj9leHS1oT8AONkDxHNkjd7S6PryqE6KWnC+Tdrwd6TXMXr7e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 23-05-26 20:54:26, Mike Rapoport (Microsoft) wrote:
> mnt_warn_timestamp_expiry() allocates memory for a path with
> __get_free_page() although there is a dedicated helper for allocation of
> file paths: __getname().
> 
> Replace __get_free_page() for allocation of a path buffer with __getname().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  fs/namespace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index fe919abd2f01..2ed9cd846a81 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -3303,7 +3303,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
>  	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
>  		char *buf, *mntpath;
>  
> -		buf = (char *)__get_free_page(GFP_KERNEL);
> +		buf = __getname();

Fair but d_path() below should then get PATH_MAX and not PAGE_SIZE.

>  		if (buf)
>  			mntpath = d_path(mountpoint, buf, PAGE_SIZE);
>  		else
> @@ -3319,7 +3319,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
>  
>  		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
>  		if (buf)
> -			free_page((unsigned long)buf);
> +			__putname(buf);

And __putname() is fine with NULL so no need for the if (buf) check here.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

