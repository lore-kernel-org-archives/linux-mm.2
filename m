Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4F9606D81A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zKdaPvru;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+uc+qZw3;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zKdaPvru;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+uc+qZw3
Received: by kanga.kvack.org (Postfix)
	id B76046B05BA; Thu,  5 Nov 2026 07:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B277C6B05BB; Thu,  5 Nov 2026 07:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D9B6B05BC; Thu,  5 Nov 2026 07:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76C536B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:01:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 023741409CB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:28 +0000 (UTC)
X-FDA: 85400925498.27.344190E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id C3C1AC0019
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zKdaPvru;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uc+qZw3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zKdaPvru;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uc+qZw3;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydEBthkRs6BZObliZ1gT2wAgcRxzGDvP2U6ol5rQ5PQ=;
	b=yZmzE1rtBuSaUtrkJGDVviKvbiTV6Xb3BO116mqMbPYd66c/lKy0RaF91shGCHhqAwTon0
	C7tH+JI9FnzFNKn6cGU8/Vz5KSb96XjuUUsGPKc265IhJZJvGGGTiQIXZQGCu00MC57ZeK
	dR6cwgc2xX5l4Hw3inbMa/n9HNmJeno=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zKdaPvru;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uc+qZw3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zKdaPvru;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uc+qZw3;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880086;
	b=Y3QfSYFwttOHBE77HcnrPtSWtjRVD3nZGyid2gPN8S+ziJeGrs2ohna1H9wqRJpwWy5IHQ
	+EoecwNTbau7bkRrHcJMeWwuEhEIs+V4h5LN1x8f68rtLkzJkblyklZs/w7ux0qQJTlT3+
	bMUy1O6cMsBCcNg6kqtEs8I066lOUII=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BEBF1F458;
	Thu,  5 Nov 2026 12:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793880085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ydEBthkRs6BZObliZ1gT2wAgcRxzGDvP2U6ol5rQ5PQ=;
	b=zKdaPvrudlEHgyITmejXQi3+WEthu23zAhtaC4wlV1I+hXSgPiexsjmLFu1qh71WxuTvlT
	ARkMP8UQiajwFiw0ySWzxzHwRkZEWMAKyzObyadFrA67Wur7o+Z+UVM154e3cOB7CjiawI
	imrU8hYglnU+jCMNSZsIpEWx2uVUTS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793880085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ydEBthkRs6BZObliZ1gT2wAgcRxzGDvP2U6ol5rQ5PQ=;
	b=+uc+qZw3PRgs4loXkF5BQEEjgjHYTq/Pxk3lICcuGM1eGhyr0Lyzls8vFsrIzuyzyWfGJs
	aH9F2Y5/1DsdM5Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793880085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ydEBthkRs6BZObliZ1gT2wAgcRxzGDvP2U6ol5rQ5PQ=;
	b=zKdaPvrudlEHgyITmejXQi3+WEthu23zAhtaC4wlV1I+hXSgPiexsjmLFu1qh71WxuTvlT
	ARkMP8UQiajwFiw0ySWzxzHwRkZEWMAKyzObyadFrA67Wur7o+Z+UVM154e3cOB7CjiawI
	imrU8hYglnU+jCMNSZsIpEWx2uVUTS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793880085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ydEBthkRs6BZObliZ1gT2wAgcRxzGDvP2U6ol5rQ5PQ=;
	b=+uc+qZw3PRgs4loXkF5BQEEjgjHYTq/Pxk3lICcuGM1eGhyr0Lyzls8vFsrIzuyzyWfGJs
	aH9F2Y5/1DsdM5Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A3B5134F6;
	Thu,  5 Nov 2026 12:01:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mtf0BxVw7GrtCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:01:25 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id DAC97B6CA; Thu, 05 Nov 2026 13:01:20 +0100 (CET)
Date: Thu, 5 Nov 2026 13:01:20 +0100
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
Subject: Re: [PATCH RFC 22/38] proc: warn about entries left in /proc/net of
 a dying namespace
Message-ID: <25dhmtf2n4u4d3ubwk3e3yjzpk7tb7ixo6fd37342zuscxlj2k@d3odfj43qazy>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-22-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-22-59422ed3e465@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C3C1AC0019
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: tak3kt733xatwc4ufxwbj35qhs4ucwfk
X-HE-Tag: 1793880086-538009
X-HE-Meta: U2FsdGVkX19Jp8EBPx2pZ7zhS9SCgWAYVxpp+bQH9qJaxfJG7XPsW1b0ihzrCubPD14hW76CgfONDK69jG6/yFSSngQtUOnQogURYR8jmKCBKETcc27C+qGsoI7c0wPGbCeYCbvRzme68prUYABj/+IUuDSzPgDJS9dmFKoS4dkdoS+EnuwXc0MdFmpoRdqqEKeToTa67daUUOOpH/5ZPQaRXaZpkYwMmMXWMMlJjx4h2wE/aeaqj3GK68P/9w27+HMTEyWcd0qBUCono337SI/exVg8UsO+ScLh0YMIO2ZMY06UJG7PXpIt8qdjBGYEE5sriYzftgklZjFd7sOXOG+ZXWEKv/kBP68VzsdVgb3N5+KlFPQDUTbmPKaHM6qd7ld0QLEt2StouinQA3g8KDZL+8vzErPPGGN9OAdkUIUbjNx+I8bd0v+YCV4acZEAt+M+j4w/IIl8cHIlVsqFtilFvJ79W16jtYWDzpuiBWs6JJh15Niq9PhKpO3JO1I16omZPAoEHhFEwNKYKFVuG/DffOAdYrfIxnyShUSNhltc6UvphM3vPBHPriOKnYCtZ/uI9ZYavqG2RAjKSyYNaOINYcusF2wBxKvxKadz+uhXQ2HkaJzVC5fvVC7l4+P8yTv3s/S7zo1w1OfQor6SpcpMUBLRp/ayzsjqmP2U7kBz8LEGWVtI26DgVXb4XMX+ks35e73lTPRFZI30kg8+1xCrtqHGnXnamI0dOgyA17Qw2Sb+hF8Lkp7T73JEUEvbcVDnOUo+LGSrB4dkKnobv5ZQOODCaZ48jQggK9Mr7YLNxR62w8vcPN8pLLEN58fGJInid/SQ9Erj5gYZQs4+BK19a5vKxBRPmOs8CQ9/mReCcpDcJGGnvj83rOolD/MtuQTOHuu/Z+lQXxRhNaoVHRbXaEt61bnyq96wzDTsSSa7nUzWhxlgKWgCZ2U5SX9Wm85iMP3RBkK/gbFQUBn
 jWP2y8G1
 8bCNyia6sdfCbg5Icdqr3/Q5icICeGtRhmLG3/WpFMxSaWKOZf/CbULVkyqqwdScTWCMZ39Wu+NirjguMGNFPu4lKhRIIIj31rToYwWnCIiKDj/qQl8IEQgxyDxOJKuQgWWeMCqa0vRBFOQvH8Ta0GoLxZDv7Hejcsh6ECh+uIZmSi2OnyLPRzmNwmgTt1Ll9Ehn9lT+LPyq0cEAVGPRpUuQduwWjxY3Wl7bH9Q+prFBT7g9WR8pLsrQ/jAXjelVzAaQXy9WAiBkGZRmOnYoLnorwznCKdlGIYs7q3LnMd3b3J4oVdGQzDZ9nSLb8SzqcQ7dly/XxZ5sjl/ovd3+pwurT5n4y9SSeUjgcpy9XMQtZH0iMFp4gRkUYVmkjGjOJtLunq3chdETW2vwERhmwlTtalm1FppWzhiBUDj1jbh5HGNBEShKCcyDN8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:37, Christian Brauner wrote:
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

OK, why not. Feel free to add:

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
> @@ -410,7 +410,13 @@ static __net_init int proc_net_ns_init(struct net *net)
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

