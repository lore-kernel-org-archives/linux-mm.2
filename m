Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3C560A5BC6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zgDVyhh8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=369eyxEs;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zgDVyhh8;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=369eyxEs
Received: by kanga.kvack.org (Postfix)
	id DA3496B05B1; Tue, 10 Nov 2026 09:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AC96B05B6; Tue, 10 Nov 2026 09:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A196B05BB; Tue, 10 Nov 2026 09:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2CCB6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:41:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 329521608C8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:41:22 +0000 (UTC)
X-FDA: 85419472404.13.ECA0AD4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id B56F8180006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:41:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgDVyhh8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=369eyxEs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgDVyhh8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=369eyxEs;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321680;
	b=bg3hkUuWkzNdiuNhzHWdybVuEqRSvT3hy0YFUlzWmBJoEQpp734APDhO14OgmfAtZfdj9g
	0Bdc3y4ILbL9Nyf2wtyzSitmqBDB9UuutHZxOrjXsoXLKfczToF6oC9LCshNBPV31nU0OM
	rn4xh2wBD9qQewzNZiqBg3lzs87oAYI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9Z1w4YYO/lfKbwO0/Zyyv0ODPBk2vg1/mG8PGnweiw=;
	b=eRg0VkdhceVCwAYFeUn1gcxzGRHKrpw/A1IvelqCH+Bdd/eafjE08QXi4t39RJx01cJWJh
	KCiTiiTRFHBRqbJoggQF2Q2pIfoXL9032sIHc53J8NKuy2WE6JE7eW3OcJwowKahe+GH3p
	UBM3FTSNX6saUeZOmNmFz5I1GrD96Q0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgDVyhh8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=369eyxEs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgDVyhh8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=369eyxEs;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5C15521EA9;
	Tue, 10 Nov 2026 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794321678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n9Z1w4YYO/lfKbwO0/Zyyv0ODPBk2vg1/mG8PGnweiw=;
	b=zgDVyhh8pCYegE1kzm5xIANNPglMEgeuZuIQhodg3Iqv/wmt77lmYCRPxvkovOojFne6ow
	xYY18x6DlFzq3ln+FuD7YcKaRbr9DnDPAC2XyRl48GG8goA6gsBhUKpVrrgGwTQE9D6lAy
	YLWLP+bL+HAY3ZU8JGWkN/YRjQArPjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794321678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n9Z1w4YYO/lfKbwO0/Zyyv0ODPBk2vg1/mG8PGnweiw=;
	b=369eyxEsAFmpmDiuBidhIEN7pEn7fzlKO8/ywBH2pvsXDNxLEXvezP0hQQ7rW/b6nD06GK
	hdXtKW5t/c3G3NDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794321678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n9Z1w4YYO/lfKbwO0/Zyyv0ODPBk2vg1/mG8PGnweiw=;
	b=zgDVyhh8pCYegE1kzm5xIANNPglMEgeuZuIQhodg3Iqv/wmt77lmYCRPxvkovOojFne6ow
	xYY18x6DlFzq3ln+FuD7YcKaRbr9DnDPAC2XyRl48GG8goA6gsBhUKpVrrgGwTQE9D6lAy
	YLWLP+bL+HAY3ZU8JGWkN/YRjQArPjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794321678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n9Z1w4YYO/lfKbwO0/Zyyv0ODPBk2vg1/mG8PGnweiw=;
	b=369eyxEsAFmpmDiuBidhIEN7pEn7fzlKO8/ywBH2pvsXDNxLEXvezP0hQQ7rW/b6nD06GK
	hdXtKW5t/c3G3NDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C9731339F;
	Tue, 10 Nov 2026 14:41:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HT40MQ0t82qpMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:41:18 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id EF45D2254C; Tue, 10 Nov 2026 15:41:12 +0100 (CET)
Date: Tue, 10 Nov 2026 15:41:12 +0100
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
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH v2 35/51] proc: warn about entries left in /proc/net of a
 dying namespace
Message-ID: <redzyadnsedot7ckkbzf5wi3zqlwtujbbupudri6riwxxt3hka@w32wugbs5mdf>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-35-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-35-bbf7d5546809@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Rspamd-Queue-Id: B56F8180006
X-Rspamd-Server: rspam12
X-Stat-Signature: ztk1o9wobgd9ttnr8zdxknhj7zq3mey4
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794321679-557120
X-HE-Meta: U2FsdGVkX1/jNr6WYzFdEDJ7slaPmO+0u6s4cZP+8Gq3VPiwfjIehRxZS2n1nekHv1dVP08fff1MIL+d7R4FXilDhDQVInuGayHupk0zsHnfnPB8dJsvXkNFx3ajIjo4JROgYAVidiprNnRxJKG74OagJfmLfvxJOzW91z57WhkRUVkS/rdNCufW/LoZn4lj6MNULZEgiiFqBAl72XFRJkJNkzBmQm/x06AhBQdBqo22tFYngdVzVEBa617qDivc96MspSmhuLAgUJ9D5jYFQGGZJVSjXuUR9pr+/dFQwef53eQO4iiyaghRBhF29EejoQuTukiku1b9vM+rIVljwdJ3jjlaKlXQnsbMuN9LgmPg3zreGPKbyVj4DYuULU9B92WuhtlEGtWH0IVlYGUoRaE7QbEC+blVqufe1oh9briJePy/mrxraGrMp9AZiJqYVGMT2Xy3uiWly6Um/piJ+d1bmo80Bw3Zt39Qm9bbzQ59XmkE1Bkai5D2g+k/O6wjzZ73DL61nzY/xIfWUaW4M3WgTfozwEO5LzJiMFLLf7R8dgn1vlWZTxR4AKFwfYqt9igDjV7DVRUuR3d5oNO4THCbPLOzZZ/YeIuVD0HFK1GpEBzKpW7F2/yyR4EBpB7mfn+lzqITr5vDc3Jq2sga09JJ2nS4PKKE8OHGwDD2MjwEWU1w4Jpan6dvxziOBrb2zRZAErufWB1DTp/K4ibwzC6LIncGKI//f+AFsBZNICG6ky+zwMXMM9ols9ucTzd2nvmvMqnebAJkZBFh4fazHxDeRDu9roqcyigrVhTijw/6/iI9bIGCR0FvwgIBCQIfcrKVNvegW9tlk7NVYjGywPZksNIOyCFZbhEowJmv04l4qXbJ8XjIj713mPxJ4yagF53FjaAF7sNUPvniISoeiBTc4RCKEYGQ42aNXNLMLQr8KRbAr6D8MxHkeoIGrq8DL+5sVaEDbMMvfhKDgzv
 WrUNvH8f
 FxL+5liTFX9sjWOvoEBXF3poFlD5OW3dLjwmsdYJemBxhPJ5Q+QPkZaOErDlcgclWaigqZLBKdLlUp9tXrYv5AfwAfrTrwGDT/2RKmwqFk6Dw5CORbz+VZ4Oqy2qp2zRYsoQISvUzoZnNDd3ppi0zbSlxwaNVg30m3L3R1EAr64iWfw++gsVZGNvSZiEiyZpyCFkK3dIKo/uMJ9WWGQBMef2iXoyn/oWQYCMuJoRDgNT9khrjOQAcVRkYcEV4WOUqKDofvELusi6miQORGyyXLi1CYBUtJWesyVHQ+13/+BlYU/OXGS5zS01CSB2FQIHiqmm10RAObjd0U2VmDpfN9cdPtQYvX4BNpvOtCNUVKr/Z11E0PC7bUkc4XmrQ89rpUtDQ5CUlheds8MkBVDLa5BMb6sMcMnqxOP5kjaJLapgRt3LRmTrTggPs8hIprunWVfLhP9A5aRhjVS++CODfBw1pb2DLlaXwiq8KHw08aaFDtDHyy6uqy+0An5R7x6uN6lss9KujbnZ2RPsqvCyOpO8ggbiMvxwu2dw0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 18:47:21, Christian Brauner wrote:
> proc_net_ns_exit() runs after all the other pernet exits and frees
> net->proc_net right after removing "stat" from it. An entry that some
> pernet exit forgot to remove is left with a freed ->parent, and so
> PDE_NET() hands seq_open_net() and single_open_net() a freed struct net
> when the entry is opened through a file descriptor that someone kept.
> 
> There is no such entry in the tree that we know of, but nothing would
> tell us about one either. So warn about it like remove_proc_entry()
> does for a directory that isn't empty.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: e9720acd728a ("[NET]: Make /proc/net a symlink on /proc/self/net (v3)")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/proc_net.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index dbcf87a257e1..df5484813d5d 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -410,7 +410,13 @@ out:
>  
>  static __net_exit void proc_net_ns_exit(struct net *net)
>  {
> +	struct proc_dir_entry *left;
> +
>  	remove_proc_entry("stat", net->proc_net);
> +	/* Whatever is left still points at net->proc_net and so at net. */
> +	left = rb_entry_safe(rb_first(&net->proc_net->subdir),
> +			     struct proc_dir_entry, subdir_node);
> +	WARN(left, "/proc/net: leaking at least '%s'\n", left->name);
>  	pde_free(net->proc_net);
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

