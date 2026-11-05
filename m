Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782F4606B551
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vvDSWJYG;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vvDSWJYG
Received: by kanga.kvack.org (Postfix)
	id 8A8EC6B05B7; Thu,  5 Nov 2026 06:52:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880886B05B8; Thu,  5 Nov 2026 06:52:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770136B05B9; Thu,  5 Nov 2026 06:52:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47D026B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:52:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAAE91A09FF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:52:53 +0000 (UTC)
X-FDA: 85400903826.14.9298BDF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 963A040008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:52:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vvDSWJYG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vvDSWJYG;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793879571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=wOxb1sXtyXKyFBDrtGBxVbN43jondLEYtCYe71+PxfMtuwu2cEe1DsvYQuyDuJp+Sj6kXk
	0rVdOOzqg3w+j0r2vpWVQ0HeT7eF1IM0LihG28ZZq0XkBl+R3I5ycyWgvld2OWRjk9eDj0
	cm0Z0lHMTRjMJLaZ/HDGJRAlBuUkA2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793879571;
	b=Outue1FtaNlnni6h6Sd3+2pL6hk/CNpAZkW1jDCUkrNvfCcAxfTjORxDLXwfyOllNp16qM
	4f5U8s5klaVwnKJLRPweqt2TaWZUv4EpZluaGEl4RAMZq0AZKrYxAnm1X0iwZW4UKmERzi
	u+62LAIsmWFRh25FYNyhPX8HZBAB79I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vvDSWJYG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vvDSWJYG;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 090681F785;
	Thu,  5 Nov 2026 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793879570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=IlDc2FvhESlDd8QXX4z/a9lq2dVMhaxW+HuiTJo6x+4vVVqrVz8k3f/Wr+Mze0vHlceBFP
	JaL/+k/+YFdhkL/6vCq7Bg2Jyl3kffnaUQoNLw7CYQNpyydj2pmW97ukL1Mouho+skqqWs
	9mNCq/qpRDGAphiHFTSprMwCLm6e0Vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793879570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=vvDSWJYGu2lVXhJVWrbpDbn5nEUGh3VUqLxrYRbdmdLlIIqOha94poMzPs0o88aMpXXTQC
	GveF9mKsY1fCOgBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793879570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=IlDc2FvhESlDd8QXX4z/a9lq2dVMhaxW+HuiTJo6x+4vVVqrVz8k3f/Wr+Mze0vHlceBFP
	JaL/+k/+YFdhkL/6vCq7Bg2Jyl3kffnaUQoNLw7CYQNpyydj2pmW97ukL1Mouho+skqqWs
	9mNCq/qpRDGAphiHFTSprMwCLm6e0Vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793879570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=vvDSWJYGu2lVXhJVWrbpDbn5nEUGh3VUqLxrYRbdmdLlIIqOha94poMzPs0o88aMpXXTQC
	GveF9mKsY1fCOgBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB5FC134F4;
	Thu,  5 Nov 2026 11:52:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FWlQIxFu7GoAAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 11:52:49 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 45F61B6C1; Thu, 05 Nov 2026 12:52:41 +0100 (CET)
Date: Thu, 5 Nov 2026 12:52:41 +0100
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
Subject: Re: [PATCH RFC 18/38] proc: don't WARN about a name that is already
 registered
Message-ID: <qaqawx4ajooiiqzu3ngxc46khpnq74u6sl5tz6az4uyssxzly4@346lsx342het>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-18-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-18-59422ed3e465@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Server: rspam06
X-Stat-Signature: 9zgisfdzpj74nauhjfehmr4meoz68nzt
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 963A040008
X-Rspam-User: 
X-HE-Tag: 1793879571-778827
X-HE-Meta: U2FsdGVkX1986i1aa/4j5eJW09TwCJrD9Cv1kE8p9fdby7DhEUbsAkLbperyfrUQybkIfDm3aVG5JwcwSCuGO+vF4UKmgS3jvb4Pdfe5J3+Fko3XkzQEi+QG7Tup4JRfWUmfwj67VUZr2beJDFFA2t3/mFLgaCLslnK/xAIZgKYt3Mmyw58FlfS0m0LBur/h1+0L+W9m+2T0A0MDl8CghfulYooAjGSvGbAkqVAZEl/JLTiW/G3gvg388h/uGGXKc/cYdCg+a1Lwdorors+U56+HgxPuoLEZr/F4HaENgdrRWhKYw/EQ8DsnNZzHWrqlFLG8DB+6ZoGeFeoV4gnYMrBwgBLzpok5pOL0X4SHAgXdlyGNPdCCkUEUCRPPCbHjUJELx6U79ARAthh+P64lGmITelyhYXVBF5pSrr+tB7SgItF81hHHQToM3PYPpjIbhT7mBNYLqIkI3eDUH9wITakw83NMNHjKelSOcrTsVfcPAfQURM6xzfrKImzETiDtXIxpw9rPOP6cqMRkW7JN52wYGnp4y31SsQwpL0lDDwzKHU2cLiIkpm9QK36L98nFH5nUu2kk/LOpvzMLgMZ92SzAcogK+XBMGaMU7+3oV/h1HddJGdrH7eCfhvqduibrAaZ/R+lUMcU10qEiBlMm/dwgELg4cG0je5li3NMkTaRPbk4mboDR5Td1rkzHDVkg1UZNDbQpUGLfs2PR1B2rH4/6gfJElJ4HLnbb93QMWgPkBS8o/6S7/DGo9FLPbNjLUZj8R8VnEui+LU9F1y5NIekpI8P94aKS2JYMVJCd1funXfsXg9ijU9EWxwX+aO0hFBzrjZcRT1tk3USFXhrsNJgO1MX+hSAjdp4A5ifyAI0IOt2fumDPtizl1M3XnUAmoofA1QHPia0n57W+SoftsF+DnswNLQDNJxdLKLPisf5W7SlGBhhJZ7MDy4aP0MS6k2clg+3ABr4aZLh5Lj0
 zw50wN0y
 6HR4nBSm2gFYz1o1HajVgAe97AUctX+SI9D8HlELO1WbXgflF4ABlK+qDKw3lsRbSLT1J2Di6+ljDurH8y56Ss0H5pFDSSaJG+vsLqOsuw1yxcCwhVV/WkrwGdK2Uc0s9MECIq59H/TihHgqezwkBsH2Xbq1dSMn970ChO1HN7fIt95K+S6tLTV5rKsGQ+vgNWgO48GL0CtsVy9aN9ik7x9n+BixxWkUZ4nMZu/EWfHoqLYPeSq9jDQ8BIuD8Bm635YDanJIDvtcO5P+BCx+E9Ge91ZYHLi+Z7vFGUhdmwrz4H2jPeTY4LKUsBQrA9hXmkx1fraSkyNn+/HpM6MGAaPF73gun639KFNHQwXwjWF7qasu8wLUMmr1Cks56WUmBNBt6zhi5nTNJh8DOKfm67u78SF6KDWFy1j0SJA8tBGGpsE5mUf2X8fZYYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:33, Christian Brauner wrote:
> proc_register() WARNs when the directory already has an entry of the
> same name and fails the registration. Callers that pick their names
> themselves should never get there but some take names from userspace.
> pktgen creates a file for each device a writer of "add_device" adds,
> named after the device. A device can have any name, including "pgctrl"
> or "kpktgend_0", the names of pktgen's own files:
> 
>   ip link set lo name pgctrl
>   ip link set pgctrl up
>   echo "add_device pgctrl" > /proc/net/pktgen/kpktgend_0
> 
>   proc_dir_entry 'pktgen/pgctrl' already registered
>   WARNING: fs/proc/generic.c:404 at proc_register+0x555/0x8b0, CPU#0: bash/241
>   Call Trace:
>    proc_create_data+0x9f/0xf0
>    pktgen_thread_write+0xd9b/0x1780
>    proc_reg_write+0x1c2/0x3c0
>    vfs_write+0x1cd/0xfa0
> 
> The files of a network namespace belong to the root of its user
> namespace and none of this requires a capability. So once pktgen is
> loaded an unprivileged user can taint the kernel, or crash it with
> panic_on_warn, from namespaces of its own. pktgen itself copes with
> the failed registration just fine.
> 
> So go back to what proc_register() did before commit 6c2f91e077f1
> ("proc: use WARN() rather than printk+backtrace") and what
> sysfs_warn_dup() does for sysfs: report the name with pr_warn() and
> dump the stack. While at it, do that after dropping proc_subdir_lock
> instead of printing a backtrace while holding the lock that every
> lookup and readdir in procfs needs.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 6c2f91e077f1 ("proc: use WARN() rather than printk+backtrace")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/generic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index c560c96a64eb..ef804cd3ec45 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -401,9 +401,10 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
>  	write_lock(&proc_subdir_lock);
>  	dp->parent = dir;
>  	if (pde_subdir_insert(dir, dp) == false) {
> -		WARN(1, "proc_dir_entry '%s/%s' already registered\n",
> -		     dir->name, dp->name);
>  		write_unlock(&proc_subdir_lock);
> +		pr_warn("proc_dir_entry '%s/%s' already registered\n",
> +			dir->name, dp->name);
> +		dump_stack();
>  		goto out_free_inum;
>  	}
>  	write_unlock(&proc_subdir_lock);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

