Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D08606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KhcIIhhy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6n5z2yLa;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=TFuQlAZ+;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IYRGa8XW
Received: by kanga.kvack.org (Postfix)
	id F3F736B05BF; Thu,  5 Nov 2026 07:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17126B05C0; Thu,  5 Nov 2026 07:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CC66B05C1; Thu,  5 Nov 2026 07:21:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B89A76B05BF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:21:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 461CB12034B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:21:13 +0000 (UTC)
X-FDA: 85400975226.21.8AC8DA6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D48818000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:21:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KhcIIhhy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6n5z2yLa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TFuQlAZ+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IYRGa8XW;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793881271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLuvYgtpasAKkOVBQjswAHWXysKN7cRsF9p74hK2S2g=;
	b=1FpcFEwH8r2GF9F2H69BEjuraIakZcdR1EsFJVXyzGwtx+OTsjmFQFHqVjzVO9i4qgcOMW
	b7zfSZ8LJhfUFhJ2YxQZZ+l7wXd6VJm8iFrMMLNaDA2NMez09e9gsJlkjuWN6G3i1Se87D
	Ebv1rJjyln0TfPkQNDKHSQeIBekZ6UU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793881271;
	b=Q2/BHpwEbW9I07HKwMkWPw/ctuU2u4dpf7xIXXt/jYc1evbYhP+ZM7AVp5tsauklB513ze
	es6KMpSLXypZVRClki1zPOH98Akv2bjaapWhJno3ZN6mDjCetdy6AD4mGl9v4aHGQ94CFl
	GctMN4r2vnNe7qevGpB/Xl1x9hGNT6k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KhcIIhhy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6n5z2yLa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TFuQlAZ+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IYRGa8XW;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D5C3D1F458;
	Thu,  5 Nov 2026 12:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793881270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qLuvYgtpasAKkOVBQjswAHWXysKN7cRsF9p74hK2S2g=;
	b=KhcIIhhyXURXrxsFKNrS5/KQBWOxVAoWljoB38cQtiYrDrFV8sed3xw/zXNPMim53TtxIA
	7ZbhM5diXv9jAcO7L3DVJNrAZi+K4lsRTnJWaMYMlYugOK16bRU+y/fGzxnSLhmlcVsvyG
	csbL8slrND45GD1FIeOECoj0f7hJMwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793881270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qLuvYgtpasAKkOVBQjswAHWXysKN7cRsF9p74hK2S2g=;
	b=6n5z2yLaHgAEN7/Tcd0WzA7lHAxJSKkismyyu/ILXPkdtd7h0WOyyJxNx+8962qMQ9rlAn
	/2Drg5p7a9P7WmBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793881269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qLuvYgtpasAKkOVBQjswAHWXysKN7cRsF9p74hK2S2g=;
	b=TFuQlAZ+5WF2YAdSPtrseTWbdG8rKLEqW19DJvUMZa96SoqlsHphdrzQTVaeQPeOfbKMve
	vRvg45whLPGgBVqZinymhyPdhVasORALEjL7ZX6GmXX/o3Zhkt8KhhIcC5N1tdRheYHdXR
	b1H4KWKbL93llPPXVmqHJ4S/SUjD100=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793881269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qLuvYgtpasAKkOVBQjswAHWXysKN7cRsF9p74hK2S2g=;
	b=IYRGa8XWDYOBq7+hiG0V0rUlmwe1TyUTdwZG614Lw3QLxr1E6xwKO0uuM9xtMm5Wn4Th8n
	Jk1SsJkUbIlOijDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9880B133F6;
	Thu,  5 Nov 2026 12:21:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 38udGrV07Gp0IAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:21:09 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 1B713B6D8; Thu, 05 Nov 2026 13:21:05 +0100 (CET)
Date: Thu, 5 Nov 2026 13:21:05 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	netdev@vger.kernel.org, ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 33/38] proc: sysctl: copy to and from userspace
 without holding the table
Message-ID: <cbocsd4qe254dc7mgzk3jkieahrp5kfxpnfh5owopkulg5oo6l@jd5sw3l4nw5c>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-33-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-33-59422ed3e465@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D48818000D
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: ze6hd7u3nuyoaz4whoz6sezf1fcpp1sm
X-Rspam-User: 
X-HE-Tag: 1793881271-475156
X-HE-Meta: U2FsdGVkX1/M/ApidMdD2C1BFLQcr0PbIclbk3Do60o/R5PaA2SUNDQ3tEVjUujfd0RG/ZA9nhR74DDlSMASIfJQw88w5NTAfBRemGBk1Ci8FlhTF6Q3Zvg6UqTunJHO+XyeO2Ypdw0yK/tYTfy9a3BHORPaTg/89ybEJe4w4+OFJCnX6PlAXCHDdkWPkejd6u1yfaDCOlU4+7dnqOgv5EbIF3OSSTZKaBm7OXynnbLst3pO7wA2odzQaeBOAzWF3n1tYyuglZK3YqOzsUzTH6JuTGvguc0t8X4+WwjhJl8VbaO85Nj+yRJLRgyRsHjCe01gJQ+77HuTwQcyNYpuk0k5QGAu07t1o5409skz5EWxe0wMLaM8TUQ0rDLSIjwzv3pZyEdUakd4yxfrqWFibUcJ/fqFVf33i2ODcG4Abdz5N98/x4eioWfxW2vl/+8zopeOLm23q0+NNAgRjoouUrvmrmJLnwGHVfnuDawCyrY4w/5RBcsSu36VibI8nrTIPo8u2DTNPvFT4u+V6hVohx/7w0ral3+us9Sf9cbarxXIp06q3FqJ+dRC/heKpxYS23vbHvYowc69iXtAf68peLHUYekEkP6A1bzyLhbgb1hIKG69d5Ey7Kpu+sALwLxezD2NPlChQqFG+8rpmorKqlEKk/+KKc+iAVTxkQyO+bim/57z6B67Htq03oFC78oMK95dsgQ0n8JFtS6ej2Bwf4AX3iODcSr1/TXRSGwlrCJo4MPWovBJ8qGGm8sEjIduR8+VeY8U4oPBLwxV71q5u7MzDmK2AxxxpDk7+R8oqZCZxNLpKuAy4jUvvdzABaMtFIloVxcSzB333bnR4AgkdE/OQrsjKw/ZFhBx4oZx+rBpL0hqJF+aUehTBmF7s2lXmSRhB4rixy++o8jqoPIe9G3S4DdzX6aeEcjGUcl3VVEvi4w5DH8YauSCYzFd6pjPLpZZo4qbfL7QnMiNcM8
 2/6O7hgj
 bmq+vWVpe+nv9mkymt/CEp8+Avuryfut6MrYzAoY3Mmz4dGMTU2kU3Fjwz+6hqSMGqCeNaCwWmPOm2ONy1tKqtqjwrPNZsH35B+Ba4/UTWtZs2hUlrH5RWFBSjuy1dy/0OKG/l+b6oVnDeK51hFfxZ5acTDq+GM8vmtH60CWdjQLFqy/hZYBnUiaGSTeVIuWSl+SM81BhlFid18drytbVaSp7sdCiKa0BClpabe4sbbsQjPnwmaEZeXYDU6EawuRWIqLMVVU0Lw8NdqHdsTh+B/zK7oOjf1+bswBqGnFXRlygslOgXkdnM2rTZxaAs2qlOuQa8mbN+Ihx7wQ+ESciDN1WPkxbQrfkUKVcG7aKEvo/MCWAuVOKOnRP6R6uSbRyoU6IHhHwGtmNE9mJJJm7kvDkdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:48, Christian Brauner wrote:
> proc_sys_call_handler() grabs the table, copies in what is written,
> calls the handler and copies what it produced out to userspace before
> it lets go of the table again. Unregistering a table waits until nobody
> uses it anymore. So a reader or writer whose copy faults for as long as
> it wants, with userfaultfd or a stalled FUSE mapping, keeps
> unregister_sysctl_table() waiting, and its callers like to hold locks
> while they do that. addrconf unregisters the ipv6 sysctls of a device
> with RTNL held, so a stalled read of /proc/sys/net/ipv6/conf/<dev>/mtu
> holds up every RTNL user until the reader gives up.
> 
> Copy in before grabbing the table and copy out after letting go of it,
> like procfs and kernfs do for their files. The buffer is ours, nothing
> needs the table for the copies.
> 
> That moves the allocation and the copy in before the permission check.
> A write that can't be copied in, or a request that is too large, now
> fails with -EFAULT or -ENOMEM where it used to fail with -EPERM.
> 
> Fixes: 330d57fb98a9 ("[PATCH] Fix sysctl unregistration oops (CVE-2005-2709)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/proc_sysctl.c | 50 ++++++++++++++++++++++++++++----------------------
>  1 file changed, 28 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 38b61887b59c..2150cf842919 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -602,14 +602,36 @@ static ssize_t proc_sys_call_handler(struct kiocb *iocb, struct iov_iter *iter,
>  		int write)
>  {
>  	struct inode *inode = file_inode(iocb->ki_filp);
> -	struct ctl_table_header *head = grab_header(inode);
>  	const struct ctl_table *table = PROC_I(inode)->sysctl_entry;
> +	struct ctl_table_header *head;
>  	size_t count = iov_iter_count(iter);
>  	char *kbuf;
>  	ssize_t error;
>  
> -	if (IS_ERR(head))
> -		return PTR_ERR(head);
> +	/* don't even try if the size is too large */
> +	if (count >= KMALLOC_MAX_SIZE)
> +		return -ENOMEM;
> +	kbuf = kvzalloc(count + 1, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Copy in before grabbing the table and copy out after letting go of
> +	 * it. Unregistering the table waits for us and a copy that faults can
> +	 * take as long as userspace wants.
> +	 */
> +	if (write) {
> +		error = -EFAULT;
> +		if (!copy_from_iter_full(kbuf, count, iter))
> +			goto out_free_buf;
> +		kbuf[count] = '\0';
> +	}
> +
> +	head = grab_header(inode);
> +	if (IS_ERR(head)) {
> +		error = PTR_ERR(head);
> +		goto out_free_buf;
> +	}
>  
>  	/*
>  	 * At this point we know that the sysctl was not unregistered
> @@ -624,28 +646,15 @@ static ssize_t proc_sys_call_handler(struct kiocb *iocb, struct iov_iter *iter,
>  	if (!table->proc_handler)
>  		goto out;
>  
> -	/* don't even try if the size is too large */
> -	error = -ENOMEM;
> -	if (count >= KMALLOC_MAX_SIZE)
> -		goto out;
> -	kbuf = kvzalloc(count + 1, GFP_KERNEL);
> -	if (!kbuf)
> -		goto out;
> -
> -	if (write) {
> -		error = -EFAULT;
> -		if (!copy_from_iter_full(kbuf, count, iter))
> -			goto out_free_buf;
> -		kbuf[count] = '\0';
> -	}
> -
>  	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, &kbuf, &count,
>  					   &iocb->ki_pos);
>  	if (error)
> -		goto out_free_buf;
> +		goto out;
>  
>  	/* careful: calling conventions are nasty here */
>  	error = table->proc_handler(table, write, kbuf, &count, &iocb->ki_pos);
> +out:
> +	sysctl_head_finish(head);
>  	if (error)
>  		goto out_free_buf;
>  
> @@ -658,9 +667,6 @@ static ssize_t proc_sys_call_handler(struct kiocb *iocb, struct iov_iter *iter,
>  	error = count;
>  out_free_buf:
>  	kvfree(kbuf);
> -out:
> -	sysctl_head_finish(head);
> -
>  	return error;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

