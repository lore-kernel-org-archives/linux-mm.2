Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F68760A6F54
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DcZW88hG;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DcZW88hG
Received: by kanga.kvack.org (Postfix)
	id 28AC76B05B5; Tue, 10 Nov 2026 09:25:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260FE6B05B6; Tue, 10 Nov 2026 09:25:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177486B05B7; Tue, 10 Nov 2026 09:25:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 884706B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:25:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBEC71208E5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:25:07 +0000 (UTC)
X-FDA: 85419431454.21.41E61B6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD7C71C0007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:25:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DcZW88hG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DcZW88hG;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=M+bGNBvrAUvpozOXQJW8ssbgYx7991PI6QoSaJqGv+ikg3TOqyalWM1RN1BzBwIsLmcTJo
	tQmTfk7TSeOvX82MZOr0M3x5uZ3ZeyI71gHgUn3kgc5suqE2OFg6qrnrxsv3JoYPDJ34pn
	X4xTdhu/Lte6CoHXJVLB0umjHHzzHP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320706;
	b=TsrA8qk5iapJB7JwCJdbH9s+UNfvTG0GV8+ysQ10sHplxkv52rCNsXm4mSl87KV7XUhHtu
	rZqSNz0DwzBFZXFWLR+nFqyRvq/V49eEyQzXMX2FZz7BNOSsVHH4NyiWKXdV1AGGvlybGd
	SYSknsgL/sdY9zu/WwkYgHesYsTwVtQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DcZW88hG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DcZW88hG;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A263621E96;
	Tue, 10 Nov 2026 14:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=bjk4WUGsRYs0sP8E0ONkDW8hyxwCcqK6F/Z+No2aVyfis1MlyWmiOhtWAdfYs7F/8CipUe
	M6ChAxycGmD+5TO2yaDPV3YEJYRhQ7n9jG4KZpA9RGENMEDcySYwTh7Zpl9Q1XnchbyaQz
	9csObL3BU5hnSJHNTzbwr+PQnEnCSJ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=DcZW88hGUmkolX453pml7rhjUnXP/geJBXTnLO3CcrhsdfC+rAH/ij69WBdSoxJA/XOD03
	2vl1fFNAf7DiXYCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=bjk4WUGsRYs0sP8E0ONkDW8hyxwCcqK6F/Z+No2aVyfis1MlyWmiOhtWAdfYs7F/8CipUe
	M6ChAxycGmD+5TO2yaDPV3YEJYRhQ7n9jG4KZpA9RGENMEDcySYwTh7Zpl9Q1XnchbyaQz
	9csObL3BU5hnSJHNTzbwr+PQnEnCSJ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=DcZW88hGUmkolX453pml7rhjUnXP/geJBXTnLO3CcrhsdfC+rAH/ij69WBdSoxJA/XOD03
	2vl1fFNAf7DiXYCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 737AB13479;
	Tue, 10 Nov 2026 14:25:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yxLEE0Ap82qXIAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:25:04 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A39EC2253A; Tue, 10 Nov 2026 15:24:59 +0100 (CET)
Date: Tue, 10 Nov 2026 15:24:59 +0100
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
Subject: Re: [PATCH v2 14/51] proc: sysctl: don't stop readdir at an entry
 that is being unregistered
Message-ID: <efix7fc3j7xbogyb3zaotsi3bwl4s4p6nvwrnlpbue5khrlf43@orqtyoglh5b7>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-14-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-14-bbf7d5546809@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Stat-Signature: 6q81sa1875uwna1hzk7ufif1gpkr4zik
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD7C71C0007
X-HE-Tag: 1794320705-860073
X-HE-Meta: U2FsdGVkX1+yjYobx4NZj4iskLLyW8WyLs4Ixr9wCD1XMI1WRcY5uEAMz4exz/jws2MSG1Zq9qsS82J1xsy/HWleSaeRNaHzojwDQa9gL4UjXUvfo248KbLAbdlg5FUTT0BexoxYe2Hb9SsMX++grTVSbdfJEvuCkCQn1oD06G6jJmcirXtbGYmWZHC958x+oV023l8dvXjFolAw+i4hf7hLVsK5jB8JB15MB2QhEVdv0PK+JK67bIfPceMG4FbwWASB0cweyVkWcVc00hmtP4aON+7P8M1v36bHL6OLz2l7L5UIyV5jkwltwZRVWBqxvA8jIlq7Mt/YiCsGUdezXpVnKeBhUuXTiqn4ocBWozWc3OwH1u9cCvzWyFNNCQlBZmHA2876sSwEsYJx8d7QRqNRA8KhBAs3FIS7AqxTrit4BJ9B2/MXIIIR0JghffGq6/J7CaIuRa2yMJakZ8L+BRzji/2Zh8uAipgK+dnvhV7YnXM6Mt+qgp1160p+szjav+uPIi0wag7glBT9tvVf2+1vVvai0xFEeh36cU2hUJI5j2Rszr5oswdpw+ENzhTTsggLsVESbQ+qa/zvIlbJXC/SkeyI+OgOdnRd9NmreaD//eZXeZ+Cw/nzXxlTAfCTg4fz+gtf/T22fdclQc3Dn0cgDK5dk6PUeQT2wVuGK6AX9vfY9G7iIz995a0LN+zYErGZKF89M5HSPEUIFbQLhADVOgqCvFGWoRLaZedEzWUVKH8bzEapVTKcHX/oEY0Lf42Xkq3UFfYIM5B/CCnE94eEfELTSRZSxVU7fuc+I3YhZkAXJGQhtmqhDwM0jzK69sMwhqqLGu8RJxt8zbxycHoYrlBu8cvyRdkUrv3hZLdH1IYQGqjZAwaFqqCneYHNDiUiO1hVx1V073vU0RnHzqkKf5gE2++6o+lMzJMSyzxmXGdjTfj6z9DcjVRKoSRdHXUv37/KCLs27C5kpLj
 gM8QNFel
 7j+Ho2XDKSqnrr3HXiq4/70bnU2FYvVKhc8dBh+GEuZXk8/38ma9xC9k/Atx5MWFvANXtz3WTyZmBpLi97J043HEqQGCyEiBB2ybO8FqLZV/Ng5WuhJ+fad4kS1IryefWl7vBRaabj4FGOmCfpbsU88a5l/dK0rL8IRsb/yeD/FZGToO3LVY3x88fSME892t975GxlKawcBADlufbmVAiF+tOBkstOKiAS6lvlpPUBUiMzuXXtOHTWUX9juQCd9UGuR6zJX7Lm1nOciHcN8a4YbUdX+r2L/LgqwDRQzdzMY0LJL1Npib1j7SjCJwUCcBNC7ERrPPVaJgNLFcT8wNF9rzXlPoYoTfEoRp/DjsA0noMy+QUmGkzyU3BWagfZ2je5jmPYH7pItTWB+kCkC7O3VWh00m44i06oY4NTYQm9umo8Vm258lu0Z1/OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 18:47:00, Christian Brauner wrote:
> proc_sys_fill_cache() creates the inode of an entry that has no dentry
> yet. Since ace0c791e6c3 ("proc/sysctl: Don't grab i_lock under
> sysctl_lock.") proc_sys_make_inode() refuses to do that once the table
> is being unregistered and fails with -ENOENT. readdir takes every table
> it lists into use and unregister_sysctl_table() marks the table as
> being unregistered before it waits for readdir to let go of it. So an
> entry that is unregistered right then makes proc_sys_fill_cache() fail,
> proc_sys_readdir() stops there and returns 0. If that getdents64() call
> hadn't emitted anything before that entry userspace sees the end of the
> directory and never gets the entries behind it. A listing of
> /proc/sys/net/ipv6/conf can end early that way while a device goes
> away.
> 
> So skip an entry whose table is being unregistered, like readdir
> already skips a link it can't follow. Lookup treats such an entry as
> gone too since ea5751ccd665 ("proc/sysctl: don't return ENOMEM on
> lookup when a table is unregistering").
> 
> Fixes: ace0c791e6c3 ("proc/sysctl: Don't grab i_lock under sysctl_lock.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks sane. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/proc_sysctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 6c0859c66563..b4a309d49698 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -704,6 +704,9 @@ static bool proc_sys_fill_cache(struct file *file,
>  			if (unlikely(res)) {
>  				dput(child);
>  
> +				/* skip an entry whose table is being unregistered */
> +				if (res == ERR_PTR(-ENOENT))
> +					return true;
>  				if (IS_ERR(res))
>  					return false;
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

