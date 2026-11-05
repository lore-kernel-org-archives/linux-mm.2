Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABBE606D83F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=cYe8TYsk;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QIbMvVJs;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qcWXmYyb;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YQFOqDtq
Received: by kanga.kvack.org (Postfix)
	id 3C6CD6B05B9; Thu,  5 Nov 2026 07:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D4C6B05C0; Thu,  5 Nov 2026 07:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B35C6B05C2; Thu,  5 Nov 2026 07:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01BAA6B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:16:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D0F2A8706
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:16:58 +0000 (UTC)
X-FDA: 85400964516.25.BED408E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C490180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:16:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cYe8TYsk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QIbMvVJs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qcWXmYyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YQFOqDtq;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793881016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADzlvyamTQU4UnQoclm/eaQzV+qRhdj3W0LtVIZccYw=;
	b=n5wf1kcvuYkPlz675z69ZVqoX2ou+mSGbeY7R43a+RxagpIFBlmvwpT+Ki8D/qy1JB5GyL
	QygqgZnkwM3mFwrdB1o3MFqkgnM3uvxStHpzbaTkDowqpgnRHCiqP8Qn122gMow2hQxehd
	NuTsKh+r2K44E6SdTFR3KzE4iRtmvnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793881016;
	b=hMgbCYkEKYX5sRGKCgeEzEjnWkFt+6zxQftwNvoYFezuX6KSyBJe8j4FkFsjzIOMifrS3S
	pL5V7Jgzw4yuLrMVzaTCqRgbL6zeO1UF1UsWEirXqGf4zgnibvMcBoqo8j38arMz6UJ71S
	AHIp2QFP548kp4dtJtKk7YvCAeP5ttE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cYe8TYsk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QIbMvVJs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qcWXmYyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YQFOqDtq;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 58A511F458;
	Thu,  5 Nov 2026 12:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793881014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ADzlvyamTQU4UnQoclm/eaQzV+qRhdj3W0LtVIZccYw=;
	b=cYe8TYskNgcCDl9X/k1KW8A+of6s9HPRYsn3eNTPIV5RsFlT7AWS/MQE3Ksi3uh3QV4KD5
	Hi2guTuJU7x2qqFFTRs6JOAz8i6Q55GuiUnI2xO+KTPomgEeNxSjhoYwnOYxznNqbm63Mo
	5qtfkmh5zv/NMPGB0+8MSe7zifKcXmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793881014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ADzlvyamTQU4UnQoclm/eaQzV+qRhdj3W0LtVIZccYw=;
	b=QIbMvVJsr8XvPWk78XYqkteMct1dWNms40BmNTEwa1LXYhQgAGTS+dajwGjNJCINSsxxSt
	HemSrC/mVhMQ9jBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793881013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ADzlvyamTQU4UnQoclm/eaQzV+qRhdj3W0LtVIZccYw=;
	b=qcWXmYyb5+mCW0254eM18Rdi4r0I1vVFScoBAC1JoCDgbQr+JVrkM2hgqEp84Kj2sVZnX6
	yOxI9PyPOhb6xWYpHefOBtPtMSEL6Mz2dqvUxPwKWIeCnNhnabJauUjOIrpt/Ne/cxy6NC
	ZAMNOvP3NI2+Dh4POTu44wQ8ZjW2uSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793881013;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ADzlvyamTQU4UnQoclm/eaQzV+qRhdj3W0LtVIZccYw=;
	b=YQFOqDtq+4SGdkOEWqs8BsjsIPs8cBY5Z7x8DRzRezIETmSxSypiEkth9ev7JNqvuGFopt
	jijBqci6GEVKGZDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F927133F6;
	Thu,  5 Nov 2026 12:16:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8uYuO7Rz7GpKHAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:16:53 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A35F0B6D5; Thu, 05 Nov 2026 13:16:52 +0100 (CET)
Date: Thu, 5 Nov 2026 13:16:52 +0100
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
Subject: Re: [PATCH RFC 31/38] proc: sysctl: resume readdir after the last
 name it returned
Message-ID: <ba3zz2mphlmojth4kk3gvistj555c2sos6ft4ofb6cm5xfcsnp@3xas2kz2irvu>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-31-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-31-59422ed3e465@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Stat-Signature: a8w41k3e5jb4up5iq1oi8issbjcdbuta
X-Rspamd-Queue-Id: 0C490180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793881015-55930
X-HE-Meta: U2FsdGVkX1+1X9rl4WUu1v4FiQzeBjPL48GQEwP/BHbTD+Mbq4OX0nEI5bbWNhrvWvITDRWnIfWTPmEiBJ88elSJvfzbAenBcA4oHhd8lNpxnVxbOhfJiNYjC0qcXHH68ge4AMeaIuSmRNYwLpDlDGTBeck8Ask03ynEl7jPcvVi98oDioIYucbdvqb8DVUGCGosjA5Z4nph7NmDO9kS0ARb0dhbzKo1hTOhHZ/RXdoHRhu2enKWRd/1pbu5NPD4GCXGxpZ6mEf54hrT6W+Wb71L5C1RhSs1JtTOvLVfxZTyCf/vkgcGLQ8BneKV8mUwoqg/EUs9oZJjtjZspmt2jpv/clEMJelBWpD3ZUWkb9t8mwoqJdB7E5fbyRaGv08KVRKW7kVO7DQCpnJEWEmK814DN5V0b8zt9NwevC0gNVhSOJV+/jtC6/Hp0lSv+6PNgqPqzZouoWO9OauxyuxXjx7kJjb5ti2WAcCpZg1nsK4T7Hfyk5IKIWZiAuPs2G/62cVxvUa4KCVHie4pasze42LmzrlN9mKvipDtraeWvY+gF925srKafT14SO59Q/nn/PDoFbqm7iKKA4Ue8i+gZbdVJfQ5NapSadVtSX77n4ON8b01j9yaiA13DFZ4f4U3H2IFXHcQqN9J/RQMLK8Z2fwPPtHjBsjRkU+ElDFFtOG3KrI+avc+CJVgY9W+/Beg3yoFIgXVM1Yb0kStd6LKPY/mw6WPBVMnKU5a+uZhcwgVsYuLYyg1UibdKNirqx137YJH/tKA+SuHg1yJLDPiTEdbp0exXnGFqC9xcdwF+ZbNvIlyUJ6uVD8E5Su3oxapD8cnGmVg8cYzyQDoGQGqj63gXXI2jpct0q+xBbdTOEAUvEDg6y2v02fPs4MO5EDqorMzKalRFd0msDzM02ZDbkoOo0WLXHe3YeJjpM6Gkh+h32zfDeC9Xr0b12YRmEt3mpnTmGfovynq5B07sbj
 FhkCJ3Ud
 82fsgEspprpiKUAhdhlUg/IJ8fqlAPYb+Holy94g1JxMlOIUZHqU5woxLWae0rJSwmF7YkDS8L61tj1OJR2RkSS2JE3cDnZl/COhvQAcBALmesg7HDlLc0dejMbox6qSvM9h+cL5e7i6R3a7bay4HXJUMj5gBaE6mxL9T0BbhRhlbI4s09S4wMecQkY8swNw00PDGW5I5e2FrkNiKnBThZryX1paJ6cPGYpdMi4kHkhzQsVeA4DirSte1ab3HRAXyHZjpmlWo6/A7AWCnW3AizQ7UBGY50m4ZeB6FLidxQIUaWf+c28P1i3aftFxef1VYsfQ2YqdqULF+AtNOi5WcMb5VxWDLs3uNCvRA+tKKmOJKTJFwtm1c0oMXtSAO+6g/NCtDllnNgrUSHU8Dlu3xW0CeYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:46, Christian Brauner wrote:
> proc_sys_readdir() counts the entries of a directory and resumes a
> listing at the number getdents64() stopped at. The entries are sorted
> by name, so one that is registered or unregistered in between shifts
> everything behind it by one. Listing /proc/sys/net/ipv4/conf with a
> buffer that holds ".", ".." and "all" and registering a device whose
> name sorts before "all" makes the next call return "all" a second time.
> Unregistering one that sorted before the position makes it skip an
> entry instead. So a listing that takes more than one call shows a name
> twice, or not at all. Even the 64k buffer of ls needs a second call to
> find the end of the directory, so a device that comes up right then
> repeats the last entry.
> 
> So remember the name of the last entry a call emitted in the file and
> resume at the first usable entry after it, like kernfs resumes after
> the node it stopped at. The entry itself can't be pinned across calls,
> unregistering waits for that. If the position was moved by a seek in
> between the listing counts from the start like before, seeking to an
> arbitrary position has never been better than that.
> 
> That also takes one walk down the tree to resume instead of a walk over
> every entry in front of the position with a round trip through
> sysctl_lock for each of them.
> 
> Fixes: 77b14db502cb ("[PATCH] sysctl: reimplement the sysctl proc support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Just one coding style nit below. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> +	if (!name) {
> +		after = rb_first(&dir->root);
> +	} else for (node = dir->root.rb_node; node;) {

This indentation looks too inventive to me :) I'd just use
	} else {
		for (...) {

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

