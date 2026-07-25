Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F62C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECCDD6B0088; Sat, 25 Jul 2026 13:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3EB6B008A; Sat, 25 Jul 2026 13:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1206B0092; Sat, 25 Jul 2026 13:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD4806B0088
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:31:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5564040221
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:31:32 +0000 (UTC)
X-FDA: 85027990824.29.3C52CD3
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E05240002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:31:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=Haz2gRX9;
	spf=pass (imf01.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785000690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+Jqw80vzuyfesh6AjBw0odAn7oHDqCK9i4qg+Orph4=;
	b=iB+m8DM8+mwfrX6h0pODB1jdDA43kRkYjCCkOZLDH8NTn2xqzOoG8ZqzTBVHUDdhzmGFiz
	+omBs6SkrcUdLvptqe1ClU+onfU2dcCM1BDPe26JYkRqAUlFIpPgLN7xaIRblzRUQW9CwX
	fnmwaycvXz3snUGoovWwNQxmw6ZFYa8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=Haz2gRX9;
	spf=pass (imf01.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785000690;
	b=WZxPB2o+ez++Z0Xs3WhzLtkqmEloiHYzf9QVQVuCKtvoxoz9GQtRO0ko04fUEOI1X+lJFV
	TCHyz/rpX2AYNBpm6rT4FDbiG01T4qlYMOMrckS4W1YzDDqa8GmOFGyjCwQfdLG94BDYrj
	Yqz6xTPd08bkkh+7bf6eouIYaA6ndxE=
X-KPN-MessageId: aaedd543-884e-11f1-b2a8-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.37])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id aaedd543-884e-11f1-b2a8-005056abbe64;
	Sat, 25 Jul 2026 19:31:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=t+Jqw80vzuyfesh6AjBw0odAn7oHDqCK9i4qg+Orph4=;
	b=Haz2gRX9YZlflCp3oanRaVWeWhi+06DyBaQ+YQDv+brBAka2dxqsEBzrsU7qfqLq+unTyMXelCUcG
	 IwcCwTw+WhBMfWsbaM2CZ8Dzox1vf9E8ZaggMvhtsa/iZVt8odpk584EAczlur75VhYUIP1qwMp3T4
	 WxA2Xf++shiIn6F1u8rzrA6ZnkPvurYDlfCeSht76/UkXEFxIzj24YihvyPTZTgeDoBjSASd+BJ6tn
	 aJsZjr4QDo4cAZ0JTi7Zpy9XeSPAR73lFwro0rvrgNjzNplTivG6RedLORwlJzrCUYb4IpVn0RxkLq
	 2dYuSdEbgpkBCTMimkpvHfbZrqMHvCA==
X-KPN-MID: 33|0mNcx/hy7+/MQtMHSFRtMlqEVOpdoLjZ6B0jAiGIF6KsZswNjzrF9EJLNDS5rwu
 GDQmyNS/7SmdXiwpGSGBcSQjZ/clROHvFbgA6BYmD2p8=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|D7Hc1UxZoJs1GulRgH/CjJmrF5CqN0O4VIo8OnCcY2fU6yzhWRHgKo64XBLvCJX
 qTb3mhe/7ZGmElZTKccaDEQ==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id aab91609-884e-11f1-9227-005056ab1411;
	Sat, 25 Jul 2026 19:31:28 +0200 (CEST)
Date: Sat, 25 Jul 2026 19:31:27 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 22/24] binfmt_misc: assorted small cleanups
Message-ID: <amTy3udkENRN4dL2@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-22-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-22-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E05240002
X-Stat-Signature: iupnxhofg34sjn9mmsnoqrc1s74zpqjz
X-HE-Tag: 1785000690-343722
X-HE-Meta: U2FsdGVkX18NA8iRFhrsFzUsNRN7wlWPo3BruSFId5uHNftMxAYLZpk2YGpPfV9xQyg5izhmxG5WVE5435kSJTyJ7U5hpFg/lZqIlRjA3eagNMda0EvKOPTe5Ti9IWeFO/PTBEsHtKglsognmMwye/zT6yLHrUjR4P/nz9NvsdMbOyzR0Y0UObzwbU5PTNexm+FyiPeK1AyZbafI3S4wBaR2cZfDDU7EYrAFITvJFxr+gi65tMAn5dKkN6sYD+cDgyQLWGORRf73RkSMwVrOkb96XBRBsGgjUPEOyblAu/MGUzP8+Ohtvpd1LYbEY9w7ZI9re+7C8gqHcMUAlgQPeigaACjY1dyEmB7c+sLEXqnZUCbajBcAxUSTnLWNOKLOuch4+iGuYMWq+OrslxESJJhnoGs5FqiRtFSMAo5SyjZK6tGq/6JxTxhx4bPz81b9Gpjew/+aTf/J6/6APXjTyAbyT0oSToLhgWGU4+Rh4i6WHoKeDQGLz+7/jBK6eH9hCIz1LuHr53U7zN+tq7CG2R9LGr3VMx0KDiuVxQ8fCh2jrcjOTWAC1q9RG+Uqmgq2DHaOi8dBxsia6818oFJhqjY2KprdAstFzBqFXzPivSpYPa0ot7zSwkzFzqD/oQSyUdqls4fYHrjDkE+RLsrCKs+d0hvkASDt+kRzoNCRD9u8piDTj4SF5bFo/YkEOyMsrVxtq1ShzFamAdADQNHN2ka1lUeGBBA0cfIO4LlTylluhmLHE9FALZ/NKbwqpduRT/kWOU0h9cfBxYBhqF3MGT4sOwiJy5jzS+sUAmUVf9xLTPNsFW78yGiAZkFJIEjJ6YrxYlvByw/HEqFYVaJ/JoB402lxnHEX+FVLTEAjCEZFZgRIzgKzAtUTPnvGHlf9JQ1hZynDcuJXRx5K2y7/jroAmVY6XwyLenxArefjKYtVNnkQl0SS5rKt/qO7y5zcA/3Eh7i0Nl2/kWGYN65
 dtbw4oy7
 W02HhbXyf/XADZ8aYmvlVZOmsiNT3G/m51nULKQuvBUa4t/5JGrJmiwOmrmH6CvoADXfF+AV64xeN3wBSVQHXfejOHwfrqxbnFH0hFXq0bn9Qd1AhKFmJkZOdwth/+qS2YAaW4yzul6LE58sbGz3DwdLiJJ+QiwwOuMyNUJL67dArt0DFWRrTCFVpgbdcsZdqqJiOF6C1U3MIRX4a4ZZpsoXUgpzNXU1zKFf8VrBy50EsO8/6vjoL8TITO/7kjK/pWA+9L6WUkop/IEpE29hVw12oCIestUXuT7SHN6EmYbeTRM1Ktr01QTMkz6zLUFX2y/J3GM4UbAEBoYrBZGHtAL8jMAsINjMBO9AUba3SpBplQQ3SLzg55e90aIww8MD7YP/6bT2G1aNvOH4ov3QnXyxrN27eVYxDZ3dSMs51Rq+DWE0crx8Mx9jKOb5tOCNP0oY3IvpXtMfaouHB3Vb3iM5ahnBsOOJ7wlBQGl6Zfzwv1oTDelD3o6BsWvV340p7dWQn8WwV0obtl1YgaY39GMyoRSJ18PLq3VrMzsez9G0aPQ7g4Vmmg0endQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:23AM +0200, Christian Brauner wrote:
> Use umode_t for the mode argument of bm_get_inode(), constify the
> fixed status strings in bm_status_read(), give the super_operations
> the bm_ prefix everything else in this file uses, replace the stale
> scanarg() comment which still described parameters and an err
> variable it lost decades ago and fix the delimiter typo plus a
> missing space nearby.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index eb56aa6a3ca2..189b9218e5a6 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -291,10 +291,9 @@ static int load_misc_binary(struct linux_binprm *bprm)
>  /* Command parsers */
>  
>  /*
> - * parses and copies one argument enclosed in del from *sp to *dp,
> - * recognising the \x special.
> - * returns pointer to the copied argument or NULL in case of an
> - * error (and sets err) or null argument length.
> + * Scan the argument starting at @s up to the delimiter @del, recognising
> + * the \x escape. Terminates the argument with a NUL and returns a pointer
> + * past it or NULL on a malformed escape.
>   */
>  static char *scanarg(char *s, char del)
>  {
> @@ -309,7 +308,7 @@ static char *scanarg(char *s, char del)
>  				return NULL;
>  		}
>  	}
> -	s[-1] ='\0';
> +	s[-1] = '\0';
>  	return s;
>  }
>  
> @@ -458,7 +457,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
>  	if (copy_from_user(buf, buffer, count))
>  		return ERR_PTR(-EFAULT);
>  
> -	del = *p++;	/* delimeter */
> +	del = *p++;	/* delimiter */
>  
>  	pr_debug("register: delim: %#x {%c}\n", del, del);
>  
> @@ -604,7 +603,7 @@ static int bm_entry_show(struct seq_file *m, void *unused)
>  	return 0;
>  }
>  
> -static struct inode *bm_get_inode(struct super_block *sb, int mode)
> +static struct inode *bm_get_inode(struct super_block *sb, umode_t mode)
>  {
>  	struct inode *inode = new_inode(sb);
>  
> @@ -852,7 +851,7 @@ static ssize_t
>  bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
>  {
>  	struct binfmt_misc *misc;
> -	char *s;
> +	const char *s;
>  
>  	misc = i_binfmt_misc(file_inode(file));
>  	s = READ_ONCE(misc->enabled) ? "enabled\n" : "disabled\n";
> @@ -899,7 +898,7 @@ static void bm_put_super(struct super_block *sb)
>  	put_user_ns(user_ns);
>  }
>  
> -static const struct super_operations s_ops = {
> +static const struct super_operations bm_super_ops = {
>  	.statfs		= simple_statfs,
>  	.evict_inode	= bm_evict_inode,
>  	.put_super	= bm_put_super,
> @@ -968,7 +967,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  
>  	err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
>  	if (!err)
> -		sb->s_op = &s_ops;
> +		sb->s_op = &bm_super_ops;
>  	return err;
>  }
>  
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

