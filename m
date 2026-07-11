Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0BEFC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 21:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86FEE6B009E; Sat, 11 Jul 2026 17:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847546B00A0; Sat, 11 Jul 2026 17:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786CA6B00A1; Sat, 11 Jul 2026 17:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 554FD6B009E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 17:42:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF30714079E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:42:48 +0000 (UTC)
X-FDA: 84977820816.15.77171F7
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id E36DB1C0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:42:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=p1avmPrl;
	spf=pass (imf18.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.169 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783806167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtN4lv+1kngkopVJIoncS5mZyRX96lwCtHji1G/RN2c=;
	b=g7x4+CAoD/f3yEKhLsACyENYiQ7UXdqA9TmKhCYPLhRw0UX00IFbHiRumw6oiIHhTlo71l
	+fqFK8r1dPv285vCIJBVvFpBaRNiQNGCgBvb1VNGop8jvk2CmBImdE75yYU4l2/MPAH87R
	ZvfOtaHTu/8JgB4ftebT5pnevoVhA58=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=p1avmPrl;
	spf=pass (imf18.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.169 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783806167;
	b=iavuezg1qHuzmLu/A1YV+IsHV3o0gKYslrPeULW4LqB2ySZFthruUBSz9CK1esv91mRi7E
	neIHbl834FZQHRyEQ3Bm2R8v432Uy5rM5CjTQ2K86zJyMpzpGKG3cjFPgBB6syrPJE397S
	9MSgzZA2a0s1p3qHV1o7hVy99KDA6Mg=
X-KPN-MessageId: 73b96498-7d71-11f1-a055-005056abad63
Received: from smtp.kpnmail.nl (unknown [10.31.155.38])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 73b96498-7d71-11f1-a055-005056abad63;
	Sat, 11 Jul 2026 23:42:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=rtN4lv+1kngkopVJIoncS5mZyRX96lwCtHji1G/RN2c=;
	b=p1avmPrlNtS0HMXKp4j8Xv2lkdGoFosSruSEqODb3MHJsaExdYYUQwUjEEBY1v5lT0bbn9bXU3261
	 4AbeCdyzGFQzs/E592hi3mr1maKFc4uOr2abGzckwv2S1tI4QaSjRHTDJFFW/XpEUPqRk/ZqtYzZS1
	 7NngUHnysjX8WjQqnjnGEkwvkMsust4bSUvd8w19lsRKPulzGwY2xquQROLsb3KnmEvGapj+gcWuJF
	 A1mMGA2Br2FnisBRq/LRuvt+nCJ/8kJmcV96iO1PdHFGHG+y9A8bGMANGF7ELnw2FPkLMBztCoOfCA
	 BTDjFRMTQ+FVnfBlV0fQzkF4ylGfgRQ==
X-KPN-MID: 33|S77Nnj0yvyNWGG/8+Yeki2HcpREekr9q/ExwtnK0GBIaaudvvN3KxJTiGlXLevx
 7z+Pv73wYo6Yy+74NYOlUPGDUQCkgGwmRVRHCkkykH0E=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|JfWW5ThqMZgwxO+egTXdO/i1sO3iibo5cWX55NlFCVkzFaDphgzBf1kbsHLMyko
 ww4JM0SdJ5g983QhdMkTfxw==
X-Originating-IP: 178.226.150.234
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 72916858-7d71-11f1-a998-005056abf0db;
	Sat, 11 Jul 2026 23:42:45 +0200 (CEST)
Date: Sat, 11 Jul 2026 23:42:45 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 06/24] binfmt_misc: annotate racy accesses to ->enabled
Message-ID: <alK3zIab-_Hq9JGZ@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-6-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-6-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E36DB1C0004
X-Stat-Signature: 6x19ha5a843ngsoarqawhan3i7snkuhh
X-HE-Tag: 1783806166-151500
X-HE-Meta: U2FsdGVkX19IUA7XqLFtcCtC2cxCYCyMJKbpyTJGTxNHUqETFFU4GFYfVwJM7+xAkAAbe0soyPvCO/UwIVD3C01b9tVa/DEQ4dru6TNNJYB76xsCsRzGLOsHFcY4SrdpFyoAgQIovEQp/GHHRyGu0O5E+6kmMk1AsFjQPmsQE23XUYeuA9eOkZlE7x0H0EWW61wRGFahaRqNEKSixRoamSgVgmUXsWBDPM13ClcK96Wtg7+FmZT6uSISTHURhbqwHilOvwwa0w4qhdIfiysHAXAVNmMBiRywcg7p5z9qSRlOCEYf1NcwGMZfuDfIhk2BcaB4VnSARG6EEnbMki+5jOwvxh46pvWaAwnQQgN/EbGwxgIfhQ0b66PONa1tughw/r2aFQRNNrlGL4mibSyMAhu/XmxRaqCxET9ShJYbncWeOcEdmQ14AOJIfbFusfYJ5FI9R0lEShLPlR9BstNsGCIhCz8S/XhpLOAhcweH0nASnEa5TWS7H+l7qB7l7wZ5ppcmO9pnRk67knvongx5kBWk7c2m7j49wFpvhkLKhUVtthAm/WoBNdruGVTmJiscf+KEQCNgVjwueS2CzyPYp+czS/aStmT3HHTfJPPF9kM81KpepUpfDiDN5eJza7nrKZbA/vs6QUVrp0bMkTmX1vH5riXcrZdwEOFbs+rFIaSygsw2ErAAYsmJKSBgJS9HWMXF1HWggdJ9JhoyL72w6DOCTP172Jam8OzNduhfKdwV6zD7h0QRsjnIYEDB5D1v3uvfxBuNK1MqZ938EzU95sIzollsZc2uh0pz4E4k5AXpk7JWFdU9TL9VL95ZAr0z+pa97EuHRZX4DAJrrezAg3r6EfmZDpUkGONKfJ4515JhschA32OU78xe4aF2d4Gvi18Un5VdBTs6aLNVXs6wudDEeoWNfWqIL4XkbwLFDEdyVc1+Dewa+r9GxRMo1Txd9jaUaZmz+FaaVc5RyXx
 NDvaGrdT
 Qk9trfxFxZ2QndEt/PKAu4AYnvZD8kWYevPTxbUplyXfVgpKjUIIn7gZBL6EqbrmGJn0QPiUyQ5Fb6GeJqbqBBqD4YrtMMkeEqvqWU/gsTkSPSCxtat0LeUS02XBsXx32Rz8GTtnpCbS+d16OmK70cyWpS+mkcWDRSP9zGSZA+Hva47639GNt9ZE1ncfLKAAkTVYExN4hw1s4V01U7scN9WYB5LnXVq4DCvAcrnqmJWzbRrIW2tva5S/tG3jSDKKsyQ3aJoZxKtjg96rQFlTM7hH4ek4IMURu7Q7LU7uQF64OkRPkh/N9hEDA6lMiiO03iX52Vzejovo8dXPjUJ5fgvh5VezoAOLT4cOopDvB1otKvVPs9dlsZS+JSmCWvA8jFjPKN9Z1rfcwnEAi8j0vYiQdHVGeQDAFG8SX8xXqG7tD99qEFc1Xp9p0IDRvanUg70+FJYvoMpdXrPJlnNgBsNl0I8FHusaUY4s4RWfpOHqq2nJAAXXMZGAjvtsmhXog8pkAIiIsOiIl2wB0b+W93c16+u0cjKY/izDOUF7JOV8mCm2aGYA/Cax5Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:07AM +0200, Christian Brauner wrote:
> ->enabled has always been read and written locklessly: every exec
> reads it in load_misc_binary() while bm_status_write() or a concurrent
> remount via bm_fill_super() may flip it. That is fine as it is an
> independent boolean toggle but the accesses should be marked

Right, remounting counts as reenabling.

> accordingly for KCSAN. Annotate them with READ_ONCE()/WRITE_ONCE().
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index bd7790a1317b..0b9758da1f88 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -217,7 +217,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
>  	struct binfmt_misc *misc;
>  
>  	misc = load_binfmt_misc();
> -	if (!misc->enabled)
> +	if (!READ_ONCE(misc->enabled))
>  		return retval;
>  
>  	fmt = get_binfmt_handler(misc, bprm);
> @@ -875,7 +875,7 @@ bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
>  	char *s;
>  
>  	misc = i_binfmt_misc(file_inode(file));
> -	s = misc->enabled ? "enabled\n" : "disabled\n";
> +	s = READ_ONCE(misc->enabled) ? "enabled\n" : "disabled\n";
>  	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
>  }
>  
> @@ -892,11 +892,11 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  	switch (res) {
>  	case 1:
>  		/* Disable all handlers. */
> -		misc->enabled = false;
> +		WRITE_ONCE(misc->enabled, false);
>  		break;
>  	case 2:
>  		/* Enable all handlers. */
> -		misc->enabled = true;
> +		WRITE_ONCE(misc->enabled, true);
>  		break;
>  	case 3:
>  		/* Delete all handlers. */
> @@ -1007,7 +1007,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  	 * someone mounts binfmt_misc for the first time or again we simply
>  	 * reset ->enabled to true.
>  	 */
> -	misc->enabled = true;
> +	WRITE_ONCE(misc->enabled, true);
>  
>  	err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
>  	if (!err)
> 
> -- 
> 2.53.0
> 


Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

