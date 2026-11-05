Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AAAF606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JZx76L+g;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8/5XD6W9;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=T3Jse+8w;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BYgAZw+U
Received: by kanga.kvack.org (Postfix)
	id 23B696B05B4; Thu,  5 Nov 2026 07:36:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213AD6B05B5; Thu,  5 Nov 2026 07:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1298E6B05BA; Thu,  5 Nov 2026 07:36:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6AC46B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:36:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C12C12097A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:36:38 +0000 (UTC)
X-FDA: 85401014076.22.DA0004A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C5B814000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:36:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JZx76L+g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/5XD6W9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T3Jse+8w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BYgAZw+U;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793882196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=21SFWtNT4uvNGj8MDBy3SBfzYmAso/ONwhrp4QVpzSv1NoCk7y9Mu9RYMFZogbUDBVLOOn
	iwGJ9SJhygStjP6Mchljm7BaORktgzxSGUMWLPbL21SWwjOldWvpGGaYQ+k+XgI5XlUHpf
	AiKu/00JnHFBs7U1k409yAqtztH65hA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JZx76L+g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/5XD6W9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T3Jse+8w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BYgAZw+U;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793882196;
	b=0N/+v6VVUXz3YlvnNrjCyBgbzaxNVyrHmfhW47yV3fVbAlNURP2yzQJcRRon4e+2J7F7uw
	GThGqBAmxq8qm2ffuQHmQdN/BnnLbcNq9IC1/VCAWqWh3cXx+u8lgDxfx9sDIGt4NARPhz
	85lTUgnQ0BSSEqhtQJrW9d+d2nXPPcw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2C5F621E5A;
	Thu,  5 Nov 2026 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793882193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=JZx76L+ggOq++v50JrM+txlftOOqxJaKF/tK8uhPwld5Q9GnNQfLXM1whyLb1DsMeHXH/C
	/uTr5WEx4MoDADem0Lt2IRl8UnJCEvNjej74YyT5VZBSM782Vk2aNTEZTgyxnuBLnPZ/fS
	Mhf/U17g3frl5lC6gN/6C/6ftmbFF2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793882193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=8/5XD6W9JBZBD7IT0Gng8T7errG+mfSR55zIjyH58gQPHLQ3a+6mBXLPeQK6OumZ9O/ASJ
	a0+wPfZoC8vZgnDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793882192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=T3Jse+8wWvU2m0agalLdcO3u4gc4aSPygpqteqhLhNd/aBjFrhyiDCC1i0Lv+iYh3z1s6e
	fnA2+Jf6Yg0jKvkbvYGo3ERh6eFq09U2ijwb8SlUT+DSbyddzL3tu06qm3Tz++uFh8zr+9
	+TrYzUca/b6bladItMQ0Kk0+pK0H3fw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793882192;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=BYgAZw+Ujm4L/dnuxqWK1yrVNISlV/1cL+J702exe7XcXF17FVJLhwkbWz39x0ZpRyHhhI
	iDaH9TFqNTx9SSCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05AD3133F6;
	Thu,  5 Nov 2026 12:36:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKP0Nk947Go1MAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:36:32 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 9532FB6E6; Thu, 05 Nov 2026 13:36:31 +0100 (CET)
Date: Thu, 5 Nov 2026 13:36:31 +0100
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
Subject: Re: [PATCH RFC 37/38] proc: don't pin a symlink's entry while
 readlink() copies it out
Message-ID: <krgvwwpug6brspfpubssohr6cknwd2wtkrxo6uqaoalfi2ay4v@3dtbsctwca3n>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-37-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-37-59422ed3e465@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8C5B814000B
X-Stat-Signature: x8jpjxy7ftxexryi6b3hzs61m6pst87n
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793882194-526840
X-HE-Meta: U2FsdGVkX18f9uY31KrfFaQroE3HHcHydvOZkAy1z8kbRx0v6gh0U4Do3KuOFLw4nloyvfV3+t8hP8u0jsmdxyFKAnz435YhzRNExUMPbMIMG/a9KK6S51GMCsV59qBLVHA+GYOG94U0ugaFp/olh7yrF1Z+4sGDU26JCdQ6AtfNspa4VJhG7z81GY5W4qy6AruXcqzvcKfyt6errY7kB/BoMJQfH9tR15RvSmWqpgNt205Pe50628VZqygCmZtSkD8aPapaz48IjFvDW1TGym2wixHacjLjYzCiStYpaHi6Zej6pIzhSd/6pBbVDjgfMiGfCrt5ME95RtqBSmYtYZh2N3+Pb57AcnzbD3Pd2FJhK2w68AdNWFfaitBMYXpzuOz2mEPPh7pY5c3nKWDs3UvT1S4qg2/HKybAF/BM36DCQTrV7blyshpSMbJ2fy+9hBF3TIEMUQ442fIyP9lCiT8qaTIjIx8dWixV246fHxQHfR3EnJgmPQWiIgR3Wkj+JdpI3PUvXIDgU7fjs/cn/YXp/zA8CLC7gVowaVehqDElo4pvhbJmLcqnYmfOzZzanbQdUi3Sh4oPV5Hc7D01qkw/dccuXk+HJJDQfOLaMx58XHqjzabpvNc8WZx9HFi5wNupTunv+ctTlLqG8DYrMz3JPICJ3F7BD11mQ/vdZDXYofhLs8DqPD8LwJqjHF646Qh+Q9czbelpzoXrmv7v+kGSuTRIzXjL1xlmLbH3ZaHJNQM9gxTA06zjt7T/6OFMO7SDtKfrKbKbYYnJz1Qj3rY4KW3CCC5XQm5yZ4pVLVyO9LP1lK3/ortFNmkNphuUKdMys7MpKX7REyUgUwnGoZzCv1AIs65l8hKSMTTXBWnkvVb92NE+4HRdEW5X/kwcVLDoTfsAr1dSf9DVB69oQKowtl6fuPslnGxi8Edqt8PyUP2VmX1Px68yAqGPLz0+0EO6iIhrHQLTAfp+F01
 FkVIQmTw
 zKNStCC/yt5vzXJLK3Fog4nr7mKcVg9qFMAcwg8Iq7wEBQO86i18IiBHyuKoCZ4KkrnRHIJqbcnsGciJAV4BdJVgJ83wMwkZ+/V6uVoTHXT5nFD2mRDmFQpvZdjnW8wAasmE6ocrDu4X0pXS3X2xIdQwRLSKgKEedmhnYHyOsjhC5zjDRqwsIegZKIqBh8eDvSQvSKbhLCkh/XJyeILSXX37iUl1ziF92BdSBaqP6vgUubXrFAdkoCzmMjUYRznRgQkyXEBOIrW8l0lM9y9q5O7K4tyUUgXIhbRkRWw8NFPMsMro47JOb+qubLw7HOKI9/Z8qxarRBlwn5MMv3JzY9QOhDfDaJkIoXY406xUN5c0fNdZRC95pFXZqh8wwdt+cuLMY3p1C8s8/XjClyyaJfYiquA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:43:28, Christian Brauner wrote:
> proc_get_link() pins the entry with use_pde() and the delayed call
> unpins it. vfs_readlink() copies the link to userspace in between. So a
> page fault in that copy holds up remove_proc_entry() just like the
> copies of reads and writes do, and the callers hold locks while they
> wait. /proc/asound/<id> is removed with snd_card_mutex and info_mutex
> held when a card changes its id.
> 
> The pin doesn't keep anything alive. proc_symlink() copies the target
> and pde_free() frees it with the entry, and the inode holds a reference
> to the entry. What the pin does is keep a removed symlink from being
> followed. So check ->in_use instead and drop the delayed call. That
> also takes an atomic pair off every traversal of /proc/net and
> /proc/mounts.
> 
> Fixes: 7e0e953bb0cf ("procfs: fix race between symlink removals and traversals")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/inode.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 9933f03ab9fb..2d65f3c8ec03 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -629,19 +629,19 @@ static const struct file_operations proc_iter_file_ops_compat = {
>  };
>  #endif
>  
> -static void proc_put_link(void *p)
> -{
> -	unuse_pde(p);
> -}
> -
>  static const char *proc_get_link(struct dentry *dentry,
>  				 struct inode *inode,
>  				 struct delayed_call *done)
>  {
>  	struct proc_dir_entry *pde = PDE(inode);
> -	if (!use_pde(pde))
> +
> +	/*
> +	 * No pin. The link lives with the entry, which the inode holds, and a
> +	 * reader could fault while vfs_readlink() copies it out. Just don't
> +	 * follow a removed one.
> +	 */
> +	if (unlikely(atomic_read(&pde->in_use) < 0))
>  		return ERR_PTR(-EINVAL);
> -	set_delayed_call(done, proc_put_link, pde);
>  	return pde->data;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

