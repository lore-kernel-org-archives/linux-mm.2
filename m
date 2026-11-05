Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7BC606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=sVeVtJRH;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vuwkzsBE;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=sVeVtJRH;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vuwkzsBE
Received: by kanga.kvack.org (Postfix)
	id 70BE66B05B3; Thu,  5 Nov 2026 06:41:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3FA6B05B4; Thu,  5 Nov 2026 06:41:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9A56B05B5; Thu,  5 Nov 2026 06:41:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30BE96B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:41:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB95AC09CB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:41:28 +0000 (UTC)
X-FDA: 85400875056.10.7F8972F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 58B0520009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:41:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sVeVtJRH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuwkzsBE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sVeVtJRH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuwkzsBE;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793878886;
	b=bNxC6tXiXGZbo1RZskEFN4Ui8XCaau0FXG1wykdy8wK2wvnNHQdPS7g4XIolIMOckDnyUW
	frNbcMQu1rRPvMVTBuvmR+Oj8jjmUWc99v0dPFFlZ9MQ/oDzH0vKH/nbptFEfRpu96ePsh
	J/7b91k1BJjktKEhnT9wkXjhby4EjRw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sVeVtJRH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuwkzsBE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sVeVtJRH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuwkzsBE;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793878886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCeU7WqtPlFL0u28tAWE4TptrCsWoJqXXac/H5Y8UUQ=;
	b=Cx+PyqN/cYSzUTD3f7Qhf4Cojh8MP5XeOrKR7KzqF3MtWSBwep41mF2Uprqj/nUb788Mjr
	j9lHSdcOt74WOd/C1/3OIZZHgbp1BT48FmzNvj94sCodNFHUM4YM2MPhtF2adI6bAfnu/l
	1g/Wo/7026WoGxuQkHMgABzZsXnaQpE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0FD6521EC6;
	Thu,  5 Nov 2026 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793878885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCeU7WqtPlFL0u28tAWE4TptrCsWoJqXXac/H5Y8UUQ=;
	b=sVeVtJRHmCez1LTgkgxlC7ymMIoqBUxHEcpbPuiTw+LbDT4oPlHADz2Nup5Y4XkVnbVoDk
	it5vmGnaVZfno1DYDqX11TE+/cZqz+5DBii4SNDMZd47SSrwV/j/qOrqaptU0Cbv8IOz2R
	SNKUKTm79wLZzIjQ8Z0k9Nr+vLNViV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793878885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCeU7WqtPlFL0u28tAWE4TptrCsWoJqXXac/H5Y8UUQ=;
	b=vuwkzsBEcCG36qlub78Ir05oWJttjLgL1QqDCsASqboi7pG0u6LKGZy4KCtzu9Qqsj7mam
	/axyOJZeWj8zunDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793878885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCeU7WqtPlFL0u28tAWE4TptrCsWoJqXXac/H5Y8UUQ=;
	b=sVeVtJRHmCez1LTgkgxlC7ymMIoqBUxHEcpbPuiTw+LbDT4oPlHADz2Nup5Y4XkVnbVoDk
	it5vmGnaVZfno1DYDqX11TE+/cZqz+5DBii4SNDMZd47SSrwV/j/qOrqaptU0Cbv8IOz2R
	SNKUKTm79wLZzIjQ8Z0k9Nr+vLNViV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793878885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCeU7WqtPlFL0u28tAWE4TptrCsWoJqXXac/H5Y8UUQ=;
	b=vuwkzsBEcCG36qlub78Ir05oWJttjLgL1QqDCsASqboi7pG0u6LKGZy4KCtzu9Qqsj7mam
	/axyOJZeWj8zunDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5448134F4;
	Thu,  5 Nov 2026 11:41:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CwQAKmRr7Go1dQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 11:41:24 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 60CBBB6BA; Thu, 05 Nov 2026 12:41:20 +0100 (CET)
Date: Thu, 5 Nov 2026 12:41:20 +0100
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
Subject: Re: [PATCH RFC 16/38] proc: don't walk through a non-directory when
 resolving a name
Message-ID: <xhnd2xzehnh35nmgphm2euuyulbwoz2fbxf7zmfn3hvdbcualr@ltehycoskzll>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-16-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-16-59422ed3e465@kernel.org>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Stat-Signature: 1niw9ho4f1bzw3tx48abjwtj4pzptr5p
X-Rspamd-Queue-Id: 58B0520009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793878886-8466
X-HE-Meta: U2FsdGVkX1/eBIjVEYeodCzEHyxX+7HRRFZ7bcCOUZSS5hQrDCZ0y6xG3ufAWweDks5KUoi7IotYZlykbAKbRVRCNiLogx/FGU9rVBuSusRoy2R3210Qazgw3y5x2aSSQUyzJ17yDq7RjyceeyjON2OOB++X+wMoS5HMN/DkC4ennB+qcGUP3KSTtpmNDCwNhOORCwRjoCBIc2HadjUw/eonZCIlnk9meo6FE8LA/5tO5ImaKyV16xScSHSPpDLmXxWgexA9LHue+o5j297N7WHAyEMijkdkGIRQWuODrpSxdxfAo/UKWezJhz4uCXl7tNHHVkPBWzt57k6ZlIXk9IM5s+QNQYXLZV3pcIoTKPW+il/L00Px1sgDVz2ZPo1N/Qjt+LuI1UWC17s3iQs0oRGdfD4LGYB6h4DC6qcbG/OmkBD5nlfKqeybhyQpBAVSGS5yHHYhFO6RvhDkF+D4heRH+wKBodSOnMvnTP6wJLZJEQ5OuFPevo+5XpFeEWwcVcvaYwg1Wg/KZnSsvolOVnv2sTevPP+m0HAo5XX/UClrydPVbGj5rozufPGnfc4M4lkx04tsHxUzm6YGOqunnKtpPxKcavWr/rU+1miTQZBNg8zj05i7lTZaqoLeScNzwcIcOYDn5OzuLRTsWLyHQsS6v+DBv9g3j/8/RR7WpS89XlZAu1hBoeGJK5l7FcrohEulLhSiLCVjAGelSX2z6yZgBivkesG2TVJwdDBriIFlw6oscuWIbnrXGJrnV9tcM0ntEZm4Pfu8M0zU19jYdqrsH7Hg2RoQzBX7xP7hxXyxGohoBivD+uATUfaiGS7onTviYoNmRgjMTXpkqtxTxqGtQX2NRQj9vH/Ku+JaaGC5U1gPPO2Y9ulu3Nf+mpFA/i2HXoLIHIrAf1f4UDnfjnd02JxZw/JsoU+f7e33cojqNSJ+crIXZkJaFuY9X+Q5qbTk4WpXR3C2M9nvkU/
 R/Wt1gZg
 25UnLgThBZAOAU26zGOVZdS14fnNje1I4LesjzOFNAYX0o9VP5kpfRc0oiwi7wuvy7CXcedFGP6ZIbFNZjwWYWFTt1qXTrOHEV08ma4T5W2dkrxT3K7hc98Eme9fw9helOtEpvrK1Pw7zlr+YY9YBMDvWaA3wGKt7obcuNucRFea+5taoC5iJQRmJsjaItf5F4wgTlMOp1mM33iV61sEEBQuhSH7dSv+NqA67I1e9qOvpk7jzTCZeLPtBAxLxQlmbXlSG3wiM9O1Uk1GuYLzjYGCShtKA7u5C/1+n6Dz4RJXkYtgi/2Tt+eI98nRyn8EDCBqKYE43jzT5mUqSCaIaBrysDK5nUtBV/UpC4qPO3VwHAHn4AxXHZVRlfTE1IQ5PNtpAuB+6d24X4/PQo5+RPIOf9k8rn7PwNsZYLv7boAVwJcCajQzVCphQ0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:31, Christian Brauner wrote:
> __xlate_proc_name() walks the components of a name like "a/b/c" and
> takes whatever it finds for "a" and "b" as the directory to go on in.
> It never checks that they actually are directories. So
> proc_create("file/x") hangs x into the subdir tree of the regular file
> "file". Nobody can look x up there, but remove_proc_subtree() on the
> file removes and frees x along with it, behind the back of whoever
> registered x.
> 
> pktgen passes the name the writer of "add_device" picks to
> proc_create_data(), and only the part in front of the '@' has to name
> a network device:
> 
>   echo "add_device lo@"   > /proc/net/pktgen/kpktgend_0
>   echo "add_device lo@/x" > /proc/net/pktgen/kpktgend_1
>   echo "rem_device_all"   > /proc/net/pktgen/kpktgend_0
>   echo "rem_device_all"   > /proc/net/pktgen/kpktgend_1
> 
> The third write frees both entries and the fourth one makes kpktgend_1
> call proc_remove() on the freed second one:
> 
>   BUG: KASAN: slab-use-after-free in proc_remove+0x8f/0xa0
>   Read of size 8 at addr ff110001134c8e70 by task kpktgend_1/243
>   Call Trace:
>    proc_remove+0x8f/0xa0
>    pktgen_remove_device.isra.0+0x118/0x500
>    pktgen_rem_all_ifs+0xeb/0x1a0
>    pktgen_thread_worker+0x1b42/0x7280
> 
> The files of a network namespace belong to the root of its user
> namespace and these writes don't require a capability. So once pktgen
> is loaded an unprivileged user can do this in namespaces of its own.
> 
> Treat a component that isn't a directory like one that doesn't exist.
> All names with a '/' that the tree passes in as literals only walk
> through directories. pktgen is fixed separately to not pass such names
> in the first place.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 2b1971da4a85..c560c96a64eb 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -170,7 +170,7 @@ static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
>  	de = *ret ?: &proc_root;
>  	while ((next = strchr(cp, '/')) != NULL) {
>  		de = pde_subdir_find(de, cp, next - cp);
> -		if (!de) {
> +		if (!de || !S_ISDIR(de->mode)) {
>  			WARN(1, "name '%s'\n", name);
>  			return -ENOENT;
>  		}
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

