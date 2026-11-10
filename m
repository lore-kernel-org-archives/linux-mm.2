Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C7860A260A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=iI7ym2rR;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=d7Rq00c+;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=iI7ym2rR;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=d7Rq00c+
Received: by kanga.kvack.org (Postfix)
	id 93A436B05C8; Tue, 10 Nov 2026 07:56:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAAE6B05C9; Tue, 10 Nov 2026 07:56:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801F16B05CA; Tue, 10 Nov 2026 07:56:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 556426B05C8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:56:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF2FC1405D5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:56:35 +0000 (UTC)
X-FDA: 85419208350.23.3901CDA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF4BE40003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:56:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iI7ym2rR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d7Rq00c+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iI7ym2rR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d7Rq00c+;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315394;
	b=JnRbO0uu5PlS7V6C9+7riBOTlaFyZBTyeF9/HOJeOOcrKi+iOKs9f0vVQaiJrD56WFnk+A
	LULW53OBHtmEP+sYPexC2W66Au27WCNuWv8drM/j5k0TTY8Iru99fsVX4vBWbwWINXdRG2
	bzb84gqqAGirXzT8KnxwmfkY5MybqIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPonFqTWiUmtrNs+Qb0D36Y6ciEfhMadviiHreNFwYc=;
	b=1eVCxYcxtwE+vRVXFkqbHHO+XUI39cs8s5KmUYzMnX3+NRcj96ysnNwktZT7uVMxY7qhex
	u9d6bzj8unztsQeIvFw2MFc7R6/UxdQnbOTYdrXqc2JpHJvVitdYipIHvf4NlrtSStPton
	ZDiUadnUaMRw5GEJKpAOX66aT8J5BAk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iI7ym2rR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d7Rq00c+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iI7ym2rR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d7Rq00c+;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 76D2521F51;
	Tue, 10 Nov 2026 12:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HPonFqTWiUmtrNs+Qb0D36Y6ciEfhMadviiHreNFwYc=;
	b=iI7ym2rRMMc3VrhaaAlN5WNcqZznLEHDbtpYqtRkG5n1tfi+3M5v/n/1WuSOFedMo1sqbz
	Sc32CgTVFd7/opphYDcFWOT80BR/RRxVs/vkTtWjRDJpkb4OidIs7+B5BXeAuF4BOYbj/J
	KLIaaDFlgWnKom1lHgtRS/Kk0HCzFnQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HPonFqTWiUmtrNs+Qb0D36Y6ciEfhMadviiHreNFwYc=;
	b=d7Rq00c+LDwkQJ8CY66ztb5ybwTC8KjmYM3gSgR5ZqtZLmPfIVg22YnOIpbxkR6cuLihJP
	WLfQ9WIdsrYIm9Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HPonFqTWiUmtrNs+Qb0D36Y6ciEfhMadviiHreNFwYc=;
	b=iI7ym2rRMMc3VrhaaAlN5WNcqZznLEHDbtpYqtRkG5n1tfi+3M5v/n/1WuSOFedMo1sqbz
	Sc32CgTVFd7/opphYDcFWOT80BR/RRxVs/vkTtWjRDJpkb4OidIs7+B5BXeAuF4BOYbj/J
	KLIaaDFlgWnKom1lHgtRS/Kk0HCzFnQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HPonFqTWiUmtrNs+Qb0D36Y6ciEfhMadviiHreNFwYc=;
	b=d7Rq00c+LDwkQJ8CY66ztb5ybwTC8KjmYM3gSgR5ZqtZLmPfIVg22YnOIpbxkR6cuLihJP
	WLfQ9WIdsrYIm9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B4391339F;
	Tue, 10 Nov 2026 12:56:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7R2CCoAU82qzQwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:56:32 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E835D224E7; Tue, 10 Nov 2026 13:56:27 +0100 (CET)
Date: Tue, 10 Nov 2026 13:56:27 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 06/41] proc: use fc_init_pseudo()
Message-ID: <sqdczu46saxh7e2x5d7cuzkfqnlrp2naoqau374n2chx55ylpm@tirkx2qx4uju>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: BF4BE40003
X-Rspamd-Server: rspam12
X-Stat-Signature: gik8fziwdc4i5xnkexbqiric8bfn9da6
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794315393-60938
X-HE-Meta: U2FsdGVkX1/9cDiMEGM3Om022SGzcgXBIOmmiTep4oSjs9/VC6opbopgEB/NKX5DZYsn+nNm9tVo6hbfrMR9yFUgiv7aD+kmANarF7wr18u1eSHJYah6Rdkn6z7MmG3KVvkj7F7A8YUlIKVvevwChIOVbr+HWXhOd1fYU78LchNg3Vp8gcL/scWyXWiPqZXbiYcb/Ai+BZ0l2W301FblSqY5jdoOFVbj2tR7bWy+Ph+wug0KEW4WMdx1EFAU1dJ2QVAJmN3sVOim2Ia9oPM/LC1UgrcMC2Q0qaZWJYmburYW5N/2bQIgtEk1sFqxRfkUoUoyJzbSWpT1mnTBx6yFQQoTzVF+qefXBg1PiAK5DE7fOjwx70GP6KCbNBv92SN1EUoZ7lwh8vDBWsETk+bqA9qoeWkF+j5EYTw6qCCgrFY1/yHD2f7uo6TsU3K5SlbNAhFDaPrTaFVZ/4vmbH0JO30Rv7jesf795n8zzPkNJMf45hExy7rZTaaBvX9fL50pUEV5dH1iY8XPzJG/ZIns3vfgbbdIjOProQwcNXUERBdK8vB8QFOzAcZXMLvkValsR8a3RKe1+zT7wM1IFMNW+vU0dRVTUd9dshw0UApjtwi3WBrxHjkMMQI26z9p7ZIsl/bDUpHEGdw2Q8Eau6fv6Pzv5wRdZf6xF7GI3nC9+Fh8jkSF1MtvTuC68zXQJOH080mq/dBKkudg2yYdxOZxM8wXkpxyzq/A/JabGdgQJEjYfSS2q08SwQndXuRlNOz/vsPnGFlYOmZJlVSVBz2YS2vwb0MjflGohAgRGLvqnOdgZDN8gMoOrUzu6ZU5ZkbvLVfnAfU4KmVT/U4FyT9onGKY9pKVlBKu63wEwxSL5lRPjLS54UIHvZRUJxLvywcxsWIJRa7P5T/9ROQSbqxMorBYrPOXMK5e1dvFuDB4MOLLAIeJstt7qiCHl53B1GZp3VGjaa+K7usMSvo82gx
 bS+g7P2n
 otnYoEZNSYixbl+QiUQxyoftwkEVQHNgW5QEHRe85Ok6KLTtjTbFxHPhZ2Nmzx2SLW1NL9PQzdVd0q4DLFMBTecNJ/ayMEXv+XSYRbdHF/E07RiehOsTeRk56IRDKhryZk8RJKef1EN6PrLjbR0vyxrnD+froNhc/EhKoTePLDQBrWiEQjW9DWLMlkWKEnxCOogE9Xl1QmX0VbU1Xdk9nKLRySL1s2++WMU4jnp0ud6lgBU4UekEoVPsA0+VcxK/ZhsnVnmIRcUH6RNYNhrgg21kxa2Ks4shhjw3bHoyt0XyRqQm6rlz7MvOZUBMdbqUNg0iy+XBCgZ/50zxz0vGmFVRHOslLLVGslCFy6s/2ZtxsPdQ1dpwuXetffBl+JSRirlFy5SfH3nPpsIuQut29RT0Bl91XQiywr7G8vQ3xH36JgZAP5n1efSdoGEYONv815ffLhdzx8J22/hRp1a7K4L3kSG10TFJu0pfIWYfZzlHzNP2w5SHViEVJpUoPPqE8X4XhhzdpzYh1CSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:22, Christian Brauner wrote:
> Initialize procfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/root.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 7fbbe92bf73a..ca0e75081934 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -17,6 +17,7 @@
>  #include <linux/bitops.h>
>  #include <linux/user_namespace.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/mount.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/fs_parser.h>
> @@ -265,8 +266,6 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
>  	if (ret)
>  		return ret;
>  
> -	/* User space would break if executables or devices appear on proc */
> -	s->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
>  	s->s_flags |= SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
>  	s->s_blocksize = 1024;
>  	s->s_blocksize_bits = 10;
> @@ -350,6 +349,7 @@ static int proc_init_fs_context(struct fs_context *fc)
>  	put_user_ns(fc->user_ns);
>  	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
>  	fc->fs_private = ctx;
> +	fc_init_pseudo(fc);
>  	fc->ops = &proc_fs_context_ops;
>  	return 0;
>  }
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

