Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827C1606A339
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=AF0vBzVY;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7JoiF1X7;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=AF0vBzVY;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7JoiF1X7
Received: by kanga.kvack.org (Postfix)
	id 766B06B05B9; Thu,  5 Nov 2026 07:11:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716AB6B05C0; Thu,  5 Nov 2026 07:11:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8D56B05C1; Thu,  5 Nov 2026 07:11:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0606B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:11:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE6BCA8205
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:11:10 +0000 (UTC)
X-FDA: 85400949900.02.871CA6A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 562B916000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:11:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AF0vBzVY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7JoiF1X7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AF0vBzVY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7JoiF1X7;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tiu8/sTPNEplZjLK9CvT6QJBjBM6O2zkosy8TKudNwI=;
	b=3D1zSU1LIz5GYp1BxVb1EKVjew+lnSr+Dpq7ArTtSkyZkeeTrms/kFzK1SHqq6NyTgx36s
	pT8dDOc23oFfKJN6d+TCB/HpJNJdJECxaYQw3DgR0g9sRWd6xRK3DJZSb59RWprWLKuGlW
	B4HDcPNAymVWBZhFFdMuHWRdw+AWNhY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AF0vBzVY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7JoiF1X7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AF0vBzVY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7JoiF1X7;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880668;
	b=gXhF3v7MOcsN0/KD+xB/4C0FRMwy4dypyul+u+IJ2HiLHykX9XAH4HQOfTEiSQRX5Lq7Vi
	EsOJY31xu/U16oTRos0vVslVxZOMMS6/yzrrHMFG9NdwvZSZzF1Ip65Hdfe8VFd7A74GZS
	5Lh/xpQvwgldBXLMFLjfTwbrELiOauo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B33A21FA1;
	Thu,  5 Nov 2026 12:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793880667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tiu8/sTPNEplZjLK9CvT6QJBjBM6O2zkosy8TKudNwI=;
	b=AF0vBzVY3zQ6Vdtyzlnd2GX1KnIr1XJT3SFmA54tWfPHGy6ECYuTRMeTFFLnasIgVme0YZ
	PThupxuU6qmedBWykcq8T+6m0PpaGSoqpA2H5zGIK2sKtK6eDiPUzWRwILl2WLIL1NXKQk
	HTqj2KBB6e0dR9olXjD094Hc8YjLNc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793880667;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tiu8/sTPNEplZjLK9CvT6QJBjBM6O2zkosy8TKudNwI=;
	b=7JoiF1X7I2Iguu9nV9GXjnaaMmyPjs8fCUlps77JZ5omTCl+PEQZZxIADuFQG05WHYF+cK
	CBi4Cau1ROf8pYCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793880667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tiu8/sTPNEplZjLK9CvT6QJBjBM6O2zkosy8TKudNwI=;
	b=AF0vBzVY3zQ6Vdtyzlnd2GX1KnIr1XJT3SFmA54tWfPHGy6ECYuTRMeTFFLnasIgVme0YZ
	PThupxuU6qmedBWykcq8T+6m0PpaGSoqpA2H5zGIK2sKtK6eDiPUzWRwILl2WLIL1NXKQk
	HTqj2KBB6e0dR9olXjD094Hc8YjLNc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793880667;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tiu8/sTPNEplZjLK9CvT6QJBjBM6O2zkosy8TKudNwI=;
	b=7JoiF1X7I2Iguu9nV9GXjnaaMmyPjs8fCUlps77JZ5omTCl+PEQZZxIADuFQG05WHYF+cK
	CBi4Cau1ROf8pYCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F14FC133F6;
	Thu,  5 Nov 2026 12:11:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RrhmMVpy7GoeFgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:11:06 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6CB91B6CE; Thu, 05 Nov 2026 13:11:06 +0100 (CET)
Date: Thu, 5 Nov 2026 13:11:06 +0100
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
Subject: Re: [PATCH RFC 24/38] proc/vmcore: don't let vmcore_cleanup() run
 twice at once
Message-ID: <6deqqw2vjfaot34sgogukcsbdh2vngvu2ewmsjzb2h53zo7mwn@zofl4rxl2nnb>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-24-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-24-59422ed3e465@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.30
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 562B916000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ayd5kgcn8gjdpw4r963hi5pfpaapotft
X-HE-Tag: 1793880668-484828
X-HE-Meta: U2FsdGVkX18h8qvEsizkQSJPbe7wNbJCbaByR9AS+Ma1D/R5JdPtkkBNxboLW8Piy0g22Bq5BW45E/jwRVI0vQGa2hTXicmCYkZHWfgq8cjZncEy1k/PA36JYTsPm6XpxGILOMC90QW7cCj1RmhM1S4V77AqTB9gATVNHmMwSUBAR6en2Ax2GhxX+1ywaSFOF50woz5ReOA0SujYGO6ksuAKufOd+oTmW6VSOjUNytzyAXfKDoZztkP11lk94MpFoIR6FWQSoQErMmyE1RkG64woHtsFGrtcwQYhY4z65N8Xqsh9FYUzrzjmhQ+coQEe/Q2F6qsGu3KSRoNQIcA3cHI8TJeG6mLV6De2gM+Xa8DqNFpRWuhqvmgW7gUd1e5XNMObUSjNUqdPIrFxmrVVjVLeUk4lilFrLX2B/HVUImqAVsx5HgIuhlxNKCTJzYAh9FQvIhKnOrkAYRipb3kPiQGSL1qt7jx4iz29ZrBhe4uym636vR5UVfrP3onD1InqG6/12r1sC3RWM1cpsgAnUVxfTAm8xS8AbB3aqQmbL0ZRnc8OCuAmJ1ehyroUU9YB1YgU+imZmT+u6e0e1WFrE9OpcZDmvVKRH5CTD0RHj8K2/qfJbMwQcxyKwdVV4PQ6QVl4KVMer0fByhMr1A+lkFU5mMMukErf8GTfPgvwjKSkRJ9rDKAPkr12UkNIypr1+USTrus2ZAkmJe8g4Fjn4ravgIpVOyIapwfaLY+uMWvev9JQt7I9vtNhbpxFexstgRPAiQafPpI9DMy1yxR1gkJLrcT1EpQiEUDpOaHmK07H8tDLDBIiR/OLrJZLU/RLE7F/hUaKun4pQpQbWqwYlPEPBoudKkPXHazXNSE7Miub7Axze8+oXgdQcQdORMDg9hE44wfeGhQC6QiwakhKTEpm0Yxow5opfTEJsqTu3mawfYgj7Tj6VbNBYa57CbciyrZpK8hZEjTdPThI8oI
 7dNjeSiT
 6f0pIYWyClP5mbjV2CEEltVJVET+dg/1bgpYTD74Y1wGV+E/dZRveGHE4vl3wL9iTNAOzcWaPAki1lF6o2xmwEgHYERmzEcPXJqExcMNiswHRkXPTPfA4gMEsIQYJ6ZQv5HXOAmZgqrlVMLPut9q2dAkANZ0OLOiA6kas2kR9EQAxFgp8GHVmA1IpdHLU9ZKdAHTsxMe2DxiwbFfLqeoMFu0rz5+COrd/dWxBW9MEH/tdjrmcNl2J5GszBi0S2KkKijWyPbx2o50F17Lx6pKpDoV4/ROlW+rh68ao1f1JSNAEI4u1sZ7RVhS8fEGUU2L9QbaC/aZZAQTNhNWpfnIY9A1ot3f3oHYUhL9rm9JNhn3upAk6SrF22Bs87y44fRwFsUuhWkOFp5yo/WDV3IsLnUF5CRWqZEqVCJ4Xgfefzrd0kJwqVc+q5zOcpbf0e+akVRsm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:39, Christian Brauner wrote:
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

Looks good. Feel free to add:

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

