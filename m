Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0C9606A9D1
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KX3USKj/;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/2pLOUfc;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KX3USKj/;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/2pLOUfc
Received: by kanga.kvack.org (Postfix)
	id DA62B6B05BB; Tue, 10 Nov 2026 09:42:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DCF6B05BC; Tue, 10 Nov 2026 09:42:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C934C6B05BD; Tue, 10 Nov 2026 09:42:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2A766B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:42:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9470C120906
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:42:56 +0000 (UTC)
X-FDA: 85419476352.01.442946A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7ED04A0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:42:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="KX3USKj/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/2pLOUfc";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="KX3USKj/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/2pLOUfc";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0B4qA1TkglN4OMx2OOtGC+4WxOgjbuwo6ZjpoXcLiI0=;
	b=qJu+XtLXqv+TJ3ZHoHJAJOBKL30U3nXRF96YIqzgrHjqX+XFsrhRbOmanfCn9VymGmPjU1
	E9uTkHDd6x79SThjka5TT2/CQxRbZPDv1GST3AS1YM+PEp34fM69ujEEIOhuq64zOuQI5u
	AVrhe2jbxqWqEKlWC3R7oysNnjyzXsU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="KX3USKj/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/2pLOUfc";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="KX3USKj/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/2pLOUfc";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321774;
	b=b/lYrQyTdcG4dlYHshhY+FbUxUf9oDIhNhfvQdtHz0qjBi8rrSZkPYJsLbe5w7nzxPek+l
	rbMQL8HA8aUJ/7Unr0mBWfC9YFMzE6jvNT/f7Q5OvCE8ZOR7kxkpTYa3ExFNLTXcyO4J/+
	7IVdBEwGMsdlhm/0CU5HiThgr+zq9MA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 598A91F769;
	Tue, 10 Nov 2026 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794321773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0B4qA1TkglN4OMx2OOtGC+4WxOgjbuwo6ZjpoXcLiI0=;
	b=KX3USKj/BuUCPazH8t3noRkhKvNyS5Vl2sfPRRfBrVBNp1j8KEsgjtdwoDEfs+Fi37nQ68
	vnsR7ycg2OeYqigI5LNHLalsHJ9KCDX9IcBSdyT+NAc3WsyWV3FKF78iAL2OBmuxWV0Xwz
	g2i8xSSiqPdjbp3ohRC0gvCg0kyAyjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794321773;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0B4qA1TkglN4OMx2OOtGC+4WxOgjbuwo6ZjpoXcLiI0=;
	b=/2pLOUfcw4Ranr2A4Pwh/sC+sB848L9X9w962zn/48Fcdt+Sh4cEXY+LMMlgvMsVazsfNO
	Ql9bUyzc9/d9uBDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794321773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0B4qA1TkglN4OMx2OOtGC+4WxOgjbuwo6ZjpoXcLiI0=;
	b=KX3USKj/BuUCPazH8t3noRkhKvNyS5Vl2sfPRRfBrVBNp1j8KEsgjtdwoDEfs+Fi37nQ68
	vnsR7ycg2OeYqigI5LNHLalsHJ9KCDX9IcBSdyT+NAc3WsyWV3FKF78iAL2OBmuxWV0Xwz
	g2i8xSSiqPdjbp3ohRC0gvCg0kyAyjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794321773;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0B4qA1TkglN4OMx2OOtGC+4WxOgjbuwo6ZjpoXcLiI0=;
	b=/2pLOUfcw4Ranr2A4Pwh/sC+sB848L9X9w962zn/48Fcdt+Sh4cEXY+LMMlgvMsVazsfNO
	Ql9bUyzc9/d9uBDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 137DD1339F;
	Tue, 10 Nov 2026 14:42:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pC/yM2wt82q8MwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:42:53 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7821722550; Tue, 10 Nov 2026 15:42:48 +0100 (CET)
Date: Tue, 10 Nov 2026 15:42:48 +0100
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
Subject: Re: [PATCH v2 37/51] proc/vmcore: don't let vmcore_cleanup() run
 twice at once
Message-ID: <q4w6yd2pk7g6uzqva7sivfusaavqfwsgh3f4m2y7lbp74dfgvr@unclx56ulwys>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-37-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-37-bbf7d5546809@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.30
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7ED04A0003
X-Stat-Signature: 819ce5q1ky79x534g1f3qae6zh7qu5ua
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794321774-414249
X-HE-Meta: U2FsdGVkX1/tqvnicTizmfQ+/ocBCe1nZjyIYboWpFll6IT576HrGcpGM+hkjAN/TmI0gQnWdTKU/SUmBjoG6IJ3PxpAtnB0qnJkwhnG+2IznkXSKyiP00WJtO+DOzvb/COnBPOPvLGfbuR2QrdG1yjkFj/YWzj8toeL/hU5GbyNb53JOLJZPCj2pnwmGla7yezhNCwnBrHnmN6+L0RRzpLsVIaSczUFX/+y0PpkASiUYyQ/SXXj0+LnJRGvA2xXq+RJF5nzTSt26kh1eGePE5GVEP64HICmmxmVgOvdyNBEwFzBDRlYloM2x2BrzlhVSDSDvAN8h9Ahf5wwRxomlGgaSG346KoQ4uNWlXGPZHAn1VJBCFcCuKEZ+I9xjtWNQZrUPxs8rfCf5W75oiTCwaxbcjH0HXa4d6Qnhp4BizfGPMptCk+V/i22NwTguABXPj2as4V3Z49DuZ3Wp49v4+2ZU7jg73bAYzuzh7rNXzBhGqHn5TD0BaU83CDin1bUI0E9d9Gk3Q3/Poewm2mZLxnNqx+x9S9uEQK5qFbxmYGb1vyD51sAaFJlPjcUD+NwfLEqd32IdT8/Pcz0iggowOq2z9OMBmHYTlCEI20vNi93crLptUuU/ZZkyxy96h9281gWDG1PudDiy/t7+D8d9UIUN0nancKXHDih8JvByFvrB1lqu5fqUUyKDj3gNZY5/sPMJZNaemtoW6g51VyUK+2Zyrvx3jIZ3neAQ6C7bWKmLY4ptm0q3/aj9652njXRaGsLIClxM7Incjs8ogugxUkom2fArjlePlySGs0WzyUKR0VQM7Pnqd482MZdjmcHK75QJtOJVQc4AC9nD7zLZHaQwvTNuqB/AEkp9S9NLybIorqkVxZDnah4GkzO18CGGMozIoo+eu+KRjOunRcG4ZF8KCHF22cenHmVY6Qxs/LeacxPA5Hs88MrAik6LVy439WcRa3OuRZ4Ynv1ZMU
 VLmDJtva
 sXSarcQx21PRrr/Gsb2dRBE05NZKB4NrnOwmv7GZxuPf0DvrGareTbIahOIh2QUDQ+Ua3ZT4Um3YBnNkjVv/H+kcYGemAkA7ENJnsBiheR+q2ZwivO3f03zP/RwHCPtIwPmN1+Xi/gUb6nc/mr7G+WHaY00aeK48yISt6Ywyi3ICaOQeTZwnfgkDRRXrIgkjZ29f7cIG/+FktX8eqKe7BvTEon8+nCZo8NMY5d+esK5nRQXB0URcxb84esD5fVz55gQZMPlf/21bqTo7YADUnXxv3c+PW/+IhUNTUGvDNHf98xD2g6coyyB+C3M/MqRA1VBlnjQW9cUgyY/ns3nOXMvIzRCaYCpFwmUblloIbNDZiNogPA9dOYOwbGDUYY9QHiQgRNYPKgdpn/W7h+XhpNhJORh6DNqKeT1LWM6BeonZqwaqfxC2YqbFqrRciBF3miC0n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 18:47:23, Christian Brauner wrote:
> vmcore_cleanup() has a single caller, fadump's release_mem_store() on
> powerpc. That checks fw_dump.dump_active without a lock and calls
> vmcore_cleanup() without one, and kernfs only serializes the writers of
> one open file. So two tasks that write to
> /sys/kernel/fadump/release_mem through different files run
> vmcore_cleanup() at the same time.
> 
> The first one removes /proc/vmcore and waits for its readers in
> proc_remove(). The second one finds the entry already unlinked, returns
> from proc_remove() right away and frees vmcore_list, the ELF headers
> and the device dumps while those readers still walk them. Or both of
> them free the same lists at once.
> 
> Serialize vmcore_cleanup() with a mutex of its own. It can't be
> vmcore_mutex, removing /proc/vmcore calls release_vmcore() which takes
> it. The second caller then finds nothing left to free.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: b500afff11f6 ("fadump: Invalidate registration and release reserved memory for general use.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

A bit sad but OK. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/vmcore.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 1fe70c4ecc54..ccb795b85509 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -1764,6 +1764,11 @@ fs_initcall(vmcore_init);
>  /* Cleanup function for vmcore module. */
>  void vmcore_cleanup(void)
>  {
> +	/* Not vmcore_mutex, removing /proc/vmcore calls release_vmcore(). */
> +	static DEFINE_MUTEX(vmcore_cleanup_mutex);
> +
> +	/* Two writers of fadump's release_mem can get here at once. */
> +	guard(mutex)(&vmcore_cleanup_mutex);
>  	if (proc_vmcore) {
>  		proc_remove(proc_vmcore);
>  		proc_vmcore = NULL;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

