Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB19160A261B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KXGDllpg;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=02akHxQo;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KXGDllpg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=02akHxQo
Received: by kanga.kvack.org (Postfix)
	id CB6766B05BD; Tue, 10 Nov 2026 07:53:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68226B05BE; Tue, 10 Nov 2026 07:53:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57366B05BF; Tue, 10 Nov 2026 07:53:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE0C6B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:53:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19C1C407DD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:53:35 +0000 (UTC)
X-FDA: 85419200790.21.DD15F37
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id AC10940007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:53:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KXGDllpg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=02akHxQo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KXGDllpg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=02akHxQo;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gAW8eIWGI8HOfwWvZQs68yC+wpRbirnAYyZ2bTJ9+E=;
	b=xGfJ/vfwJ49cqUiO81mpvIjyEN4/PRY3IdvgorzGIeq/iSyXyeXEqERDAmBVKc5N9Qz0I9
	nFvNJSeTTI0LSTG1tyJEc3fG9efMdU2wwKl0Nlrv1m4FejWgcd0JlClvuDICdmiGAxyYUc
	nHlnX4nufKkzJYX9qrhQoAq62Q4AwXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315213;
	b=FmTnL+oBSnxc3Gc4I9LIdJFG8RAKNjyKXgmmNDbvblRwzduziyX4DK2Mgc65azcTz2obWI
	PBnjqDdmotA0NotpNtDr+Mw8QwkfYUkZnjGlDy5R8rRvsUyvLqAuTPZKQ0zsqRG/X5T6iI
	ndXlbMG/JAPOiKLs6uS35IcuOvrLpsk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KXGDllpg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=02akHxQo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KXGDllpg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=02akHxQo;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 470B421F57;
	Tue, 10 Nov 2026 12:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5gAW8eIWGI8HOfwWvZQs68yC+wpRbirnAYyZ2bTJ9+E=;
	b=KXGDllpgGiBBAdkJ+94+hx57x3NvF+B6wVf1VJPhzu/vdFL2qD1xN8ea3AfxZRuIEQrDNG
	h6ARgN9r6E1Tp0L3/IOetfpivMPJgdCx8gDCmnuEUwvvykOGvRJ3e4L8lAmSVM7Bzl5Sdl
	8yjrsZoBB4KbKRgxMsQEsJpHPQKPfVY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5gAW8eIWGI8HOfwWvZQs68yC+wpRbirnAYyZ2bTJ9+E=;
	b=02akHxQolbaeDkTqzMuoQ9qEenO8KZzqbD3pshHw2P9mLxjD414sxUGp3r+0OsfEjYG8bh
	6lagVVxrNyrhB8AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5gAW8eIWGI8HOfwWvZQs68yC+wpRbirnAYyZ2bTJ9+E=;
	b=KXGDllpgGiBBAdkJ+94+hx57x3NvF+B6wVf1VJPhzu/vdFL2qD1xN8ea3AfxZRuIEQrDNG
	h6ARgN9r6E1Tp0L3/IOetfpivMPJgdCx8gDCmnuEUwvvykOGvRJ3e4L8lAmSVM7Bzl5Sdl
	8yjrsZoBB4KbKRgxMsQEsJpHPQKPfVY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5gAW8eIWGI8HOfwWvZQs68yC+wpRbirnAYyZ2bTJ9+E=;
	b=02akHxQolbaeDkTqzMuoQ9qEenO8KZzqbD3pshHw2P9mLxjD414sxUGp3r+0OsfEjYG8bh
	6lagVVxrNyrhB8AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 197071339F;
	Tue, 10 Nov 2026 12:53:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HDDqOMoT82qhQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:53:31 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 94F1F224D8; Tue, 10 Nov 2026 13:53:26 +0100 (CET)
Date: Tue, 10 Nov 2026 13:53:26 +0100
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
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
Message-ID: <yiiin5howot4r3fgcqkqfnreblloazpfatuuqzpjpqshpvphit@zirpwlmklj3d>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: ehgq157wh54i7nbabnnq8u1a9hiexj4f
X-Rspamd-Queue-Id: AC10940007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794315212-949151
X-HE-Meta: U2FsdGVkX1/ZcFNMmVmyEslDEWk3H+41hLlekCU7/ee1vqOSK29jdi2qhhN38NTSi3d6+LtgVisNPF99a+1DmlBva/oSGfYse/sCUCuldyO9gKyAnM1Qz8BEinzCtMdQ03T+KDmNGmy3ER+BV/77gl530VI0QLAW0pwWWU4DLYeyz9zPOXsP2J4YMET9BKaOh1iBGByWZSYEBlMUmSeqXZQghRkjv7CjOpZj4I1SyABPDTutC1UZUwqlXRrRs1vitF4HG3umsJUsKD/05sYZZ8FhOEoMyX+RFAR/DoZrRf5e8wh1yoclHAOdwHuoClv/cUHuUMwa7Zg64tdRNDc71+glrXEJyZZYXhIg6m0oGC2fD1cpMC4VDmmhUoI0PQVG8JvjjQwvqXTu5S+c37JeojmpLw84wtjhvQmWN0kLEdC7pp4pp4QrHv4vrjH1hAxLaODhPFxZg8kBOKVfdV6hiNP+UVX4V0/J98qbY/xmOxvW55KAEk7nDHVtLQEcQVdgVoPYSU357B7bPNnzNKIcUFjIayrn1qRn/IpWd12C0IPg11OAQpY6Hg6e9APUd1VNzsFjWfaIH/ocfDRM4KrqRwWRbDuV5anKnXOI5mgB8/1Uf+RRT6awWmNCCb0zghgiJqRr1hpBgWGZLEERvCUM6z/lQhSMg1y82F45QVM87KkH2syhEpWhI0uR+Hb0rZ3JNqWSLuRUuLtX+5BK+jy/ElzIW9dwv+T6w7WzPjHQjI0OwRghurDCQza3IwaJsAQu+vFeC4/x82qhcKgxQxbqEYjzHkur+BuQbPmJPoeQrCQR4CpcNw55sLdIIItl+KN2u86Nry0htU2/GvCGhZNf7TUXLfujxbr9+ZKObT6kfEByhN4inAmE9I9sjm3AZzYDtugzsPJyJSYKujCcZDxTHrT/sqfvoQ6u0Nw3WwQT8rDyW5/DSOKHXgtZXw1vQBYZLz2lKDEGICSGTe0/oXB
 m3oqxUJw
 XNNmHpSzJLA6IW8o6RAaXvRGAQCqs2KbRNjYy633Q4lLjEbYtDAr/kiGBaffjeGBnr5m88zAssL4rNm+em25CQg3ZBFn1xow2YDmrNite83XMLekvfcOaSW25RLbuxqwRz3rlLF+3KbL6pL2nUXunQx+B9bsaUop1FgUhaSfpDcJofpk369IyflvFme+CjfWk7+MrKnCf6gkJrYsTVyvCpNBMa1A5pui1KqZYJmTvXy01TFYbCTDlj8UnSQUOT9ERbDle3jeFSnvvFOT3pGjWEApcNWhhiqws03Aq/bklJoy9uV3MPiZk2gXqX8uwebjyhAbpyF4172QcVX+8Uv9RoX3jW65b4Yyk+wlvkvKlLwDC/J4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:17, Christian Brauner wrote:
> loop_configure() takes any file as long as it implements ->read_iter().
> Loop itself never checked whether the file was actually opened for
> reading. Buffered I/O went through vfs_iter_read() which refuses files
> without FMODE_READ. Direct I/O has called ->read_iter() of the backing
> file directly ever since loop grew support for it.
> 
> Since commit f2fed441c69b ("loop: stop using vfs_iter_{read,write} for
> buffered I/O") buffered I/O calls ->read_iter() directly as well. That
> commit was about O_DIRECT handling and the FMODE_READ check went away
> as a side effect.
> 
> So whoever can set up a loop device can read a file it was only allowed
> to open for writing. Open the file O_WRONLY, configure a loop device
> with it and read the contents through the loop device.
> 
> Refuse backing files that aren't open for reading. Loop always reads
> from its backing file so a write-only backing file never made sense in
> the first place.
> 
> Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
> Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for buffered I/O")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/block/loop.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index a3325ceab484..c96e35c3ef42 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -528,6 +528,9 @@ static void loop_assign_backing_file(struct loop_device *lo, struct file *file)
>  
>  static int loop_check_backing_file(struct file *file)
>  {
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
>  	if (!file->f_op->read_iter)
>  		return -EINVAL;
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

