Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69FFECA5FAC
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 20:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5E96B0088; Tue, 29 Sep 2026 16:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5566D6B008A; Tue, 29 Sep 2026 16:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BE66B008C; Tue, 29 Sep 2026 16:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5D86B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:32:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19B721605AC
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:32:19 +0000 (UTC)
X-FDA: 85267947198.07.3427CCD
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf19.hostedemail.com (Postfix) with ESMTP id 380C51A0003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:32:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=krisman.be header.s=MBO0001 header.b=yWMFwYSs;
	spf=pass (imf19.hostedemail.com: domain of gabriel@krisman.be designates 80.241.56.161 as permitted sender) smtp.mailfrom=gabriel@krisman.be;
	dmarc=pass (policy=none) header.from=krisman.be
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790713937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMO1TFFilty1lMotj3PlOLCIGv6KB3kYrfoPUAD1Z/c=;
	b=s5sRsJ2OMHfk5m9fSqbDrXhykMQhWVfI2x18/pwVSgRo47xrLmDdDXg7ObQ3N5VYIz757p
	UYHW291apIv3tgDGxMnVxXkgHaHKob0jDLYnfehbCxxjt+SvW5mPNdduHJTl9iDQeNT9zZ
	J4wwTd4rJDVEcWpGDFB9zorUJr9O5ic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790713937;
	b=iwoAnzl4tNi1KHLxPsjDkPsPmi2wrAzS3hbHkQ7PnuTqJOhRfdVjrnub0lHsWYF5PEcudq
	G13g7yy9qO9IYk9pva9tNoITiEQhoSHPI8V3t+bSR4XzsLesBmRe6FASwIfj9n0XLAOvRZ
	1bLAvZ9ACvRbG0+HZVTRcsa5Fk2BHZQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=krisman.be header.s=MBO0001 header.b=yWMFwYSs;
	spf=pass (imf19.hostedemail.com: domain of gabriel@krisman.be designates 80.241.56.161 as permitted sender) smtp.mailfrom=gabriel@krisman.be;
	dmarc=pass (policy=none) header.from=krisman.be
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hvVGP72jzzKp1b;
	Tue, 29 Sep 2026 22:32:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=krisman.be; s=MBO0001;
	t=1790713934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aMO1TFFilty1lMotj3PlOLCIGv6KB3kYrfoPUAD1Z/c=;
	b=yWMFwYSsvctbfxkt7eVRBy+y+3biYN91XB5dSY0SloUoKQlZO8CDVN9xzIlQj6p2L3Dl/z
	bBc4kwbeJ7ae2K32oenVkhiBhdVpZIMqK0pkfPzo7+tOcXVvPAPXZ2ohk4pgQ0ln3344qL
	OEA0eXMPu33AEt/EoiP0d+XoVZNsXfNpQLqn2wM8ZrPN4+TfX4tWMrmjfHsrUD/I29eoeW
	DsgvEmUm93vJoij0jfVSpUPN5efHlV4+9RszhD1Tx2YSu81CMQqe6/N5VgF4RD+6/qjcH7
	35/MTHeaStrsEYMSZ+W19ydqgGH0u87DLIhN5QP8cHTt+LEeZhM+BBgOtMYa8Q==
From: Gabriel Krisman Bertazi <gabriel@krisman.be>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
Cc: brauner@kernel.org, andrealmeid@igalia.com, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] shmem: fix unicode_map leak with repeated casefold= option
In-Reply-To: <3a57ec70731165b4b1244fa89bba95c82a666df8.1790712330.git.med08elkadiri@gmail.com>
References: <3a57ec70731165b4b1244fa89bba95c82a666df8.1790712330.git.med08elkadiri@gmail.com>
Date: Tue, 29 Sep 2026 16:32:08 -0400
Message-ID: <878q4jyf1z.fsf@mailhost.krisman.be>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 380C51A0003
X-Stat-Signature: nud5zf5na1cshwfap3i6xw6bfnrn9p89
X-HE-Tag: 1790713937-580853
X-HE-Meta: U2FsdGVkX1+iy7t718Fkm0YH0W4+Iuvs34VsOI2wih7doPSRrR8LUYSs2X8rzS2X6SP4oLAYWgk5AMeNaqnBjgb0KMqcFWOc72nmKJnoaN8/fdBreGJdZ1UUQZjRYsE0F6MUJVWtfJFB1KvS4saJ+MK5JVjj4BxcQuJjnxND9HLE81e7mftrCPuKIg7v4r7IrDM7n3kvc5AhTk1bsP0fRPHTdpMIKr1Gd+yTuo2zdOj3alOQ9RSD3UFqpzpdsA6uyDEqh2xrJ48FHYEdeAhjc9TM69zTRR2PbwZG9oQVsmsZn/N8fxY1tOPKB1iO9MqlI2eenEAZpCKsmC2a6wO2SpY8+3P/6LMcU9TMY2r0I47LH0hUYlhVyGfeWAqv1biyfpBMRnRMX9XPoDLm4pSBxhHhuNjHzLwbu5kCpmE0T9o12oDp84hK56kCmNbJ/64mzO8A7PSk9VFyqsXX4v9c6hDyrpWFeI62a8M+GQe9Tsv3Lit26Nj/PybrneoRhRweTP59Us49Fd+FAGeC2O2Fmaw6MtKliO8VHyRyg6e9CCWRMauHDtq0qVgpSVnh5QFuBmnrd8ddw571ma5/aQJMhme6Yc9aSM5rya6rD4bJlY0JA900p8exzoyOLSDcTbMwjGGwBylc25lUYcpeExsfxYUJgA3CmZWhILnp1BAN2OoOwj44Cw+ImWlNEkW6opxEjez+rRC2ApG3JbJ/l/dCQ/OyeZzDKNtKroU/jqo1y/FIHpZxqTAqJi7oWfWByyS/l6wg9Rt02jxnPQR9pBaD0EayKuGT/l6n3wAKggZaCJO/SZmTKMTKL5gtLw43JY4z280zFzbwxAhTAJdtPEm9dwakb8swQXwLez7K9wwc8u6aOH+QgW1L7FLLG1AcdGxv+FujPohyIciy1Bpd2oZsgk2HLUJFE9c8vZJ7uf535papZ11QMNJkbQ3U/xdHvmNGdsc1SVx5a70OIQqcR9G
 THaHHYIh
 Ll1XyKifbABxx9muNZ9srLh6Iv9DMQa8d21ItlSzvB1TqsE2HkXmqeS4saoVRSp79qRiY2aih7PWeG51juebIr9oBHtq/OzHWrxkGdA/cMAgdOmD8AqH5ITeNeeOK80oP9Do/M2itbCQjZPOAJLB1tTXJjBN5xNwblTZzus6okDqTk8HWDiz2PCNHbhdIGKKmzlNd3KHOYevnpsjoYg9C2vr/vfYuEZxcyKK0epo+Rg0Ot+eWiOjFIcHOGmJKdOTB5zdgl9tmHNZt3DjHgYePWWwH/EQBIY9niV7lUWO6/LUn3bpsBioJ98G3pWn12Mzud8yt+HfJrgDtXg5QyNK5kaI11uwUcvf92h3pHM7SCHNjrtlPMujoF14TleJ71/mBOVGo9fBFQLiavK2uo/WwbxnlBrEtGMVIKMBrETO5XHeAWYpmlARL1Eyle/v92g92z86HzaRvaAC4xt1/RMsKHt3nEhF11etVjF7D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mohammed EL Kadiri <med08elkadiri@gmail.com> writes:

> Each casefold= option makes shmem_parse_opt_casefold() allocate a
> unicode_map with utf8_load() and store it in ctx->encoding.  When the
> option is given more than once in the same mount, the later call
> overwrites ctx->encoding and the earlier map is never freed.
>
> Reproducer:
>
>   mount -t tmpfs -o casefold,casefold tmpfs /t; umount /t
>
> Repeating this 50000 times grows kmalloc-32 by about 50000 objects,
> and kmemleak reports them as allocated from:
>
>   utf8_load+0x21/0x110
>   shmem_parse_opt_casefold.isra.0+0x65/0x100
>   shmem_parse_one+0x368/0x510
>
> Free the old map before storing the new one, so only the last
> casefold= is kept.  On a normal mount with a single casefold=,
> ctx->encoding is still NULL at that point and utf8_unload(NULL)
> does nothing, so nothing changes there.
>
> With this patch the same loop leaves kmalloc-32 flat and kmemleak
> reports nothing.
>
> Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
> ---
> This is a separate leak from the remount one fixed in
> https://lore.kernel.org/all/ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com/
> which Gabriel has reviewed; I found it while testing that patch.
> The two apply in either order.  Tested on mm-unstable, alone and
> together: kmalloc-32 stays flat for duplicate casefold=, single
> casefold= and remount, and kmemleak is clean.
>
>  mm/shmem.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 07b2855dfb7b..262f1bcb6144 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4731,6 +4731,7 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
>  	pr_info("tmpfs: Using encoding : utf8-%u.%u.%u\n",
>  		unicode_major(version), unicode_minor(version), unicode_rev(version));
>  
> +	utf8_unload(ctx->encoding);
>  	ctx->encoding = encoding;

IMO, nack, this is not the right fix.  There is no point in accepting
multiple casefold parameters and we shouldn't allow it.  If
ctx->encoding is already set, we should -EINVAL and fail the mount.


>  
>  	return 0;
>
> base-commit: 90ddfbd1963659ca4a5d3d7f20717a4222682a8e
> -- 
> 2.53.0
>

-- 
Gabriel Krisman Bertazi

