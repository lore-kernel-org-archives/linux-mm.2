Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31E860A263C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dfqcbUnK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=I8IcNdZF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OFZt5G3N;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lARv1EHw
Received: by kanga.kvack.org (Postfix)
	id DA65E6B05C1; Tue, 10 Nov 2026 09:21:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DEC6B05C2; Tue, 10 Nov 2026 09:21:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94E16B05C3; Tue, 10 Nov 2026 09:21:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A26306B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:21:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0B381205EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:21:26 +0000 (UTC)
X-FDA: 85419422172.13.50C70ED
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5306420005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:21:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dfqcbUnK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I8IcNdZF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OFZt5G3N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lARv1EHw;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=inhqE4ly+tjCSY+mtlJZwPUhohwDnusxd2etIxzMBHWDDq4xhzi4RVe+Jpud3sTwRRTJmW
	iYW1yxu0xLBdMUSWm8FYlBtOyadcyxcDuoVG7RLOgaML/JmcawwzCUG05i7nq+ZpJKMySz
	PZqwocY98dTEoDX0Yl1JKmfil9bXqCo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dfqcbUnK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I8IcNdZF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OFZt5G3N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lARv1EHw;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320484;
	b=eEgSP+KGd4mu9Fq/7zQNt+x7N9ImdaUPXcc659ddZ+Pl6XOQxeH8c2AszekWbxFSowZDV8
	oH44rD/ioB6pieI/ySqTk0gIMsKxwQCeEnM6luU+i3gE6cla0lYOu8/jrqGlFB+S1Vb11h
	82ufjscBOZf4uCv/L9TsTPTgL+jGCs8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AFC4F21EA7;
	Tue, 10 Nov 2026 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=dfqcbUnKWeMMrbbtQxI4HQM7qrIh4AZ0rdet9B/6ElOBIqFSiDGiuE+1U00ut3ACwyb91k
	r11g0ukmfmgZpAkPLIoBt7FBxKQ00ygdxuqdgmhj2u4V8/naZ4cHPSCZhNnU3P0rUj/quR
	5maXirFkXXk4Lg3EkYDJXPDsbTG0ICY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=I8IcNdZFZSFtUgRgMf53UkGbuTtSJb1zzUPCSb1BODWP/tylJEZx0BmLFYU3bDgA6b05ut
	5Oej5bk5j+xTBnDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=OFZt5G3NjcxxJh9jY6RWrC7bvaHuyGavEEbdiAXuJUz/f1dYZmor5n2FYPrRYiQoiCED+w
	1FijM1hEbGwM1P7v2pYubJuTrAUHD24tVDcOF18S7gaHWryxvKiASS6IebdlsiiUolZCHc
	0QuxJjJxTEoiCmYYKfGjg6OEvasGjOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=lARv1EHwNdS7tCNwBSn9srQwOl9Kg5/ztnfBrMPMFrjJm7RNq+r333D6UmkiyHiKi5q76w
	+hVROod2CCZjqIBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7082C134F4;
	Tue, 10 Nov 2026 14:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7c+hEGEo82ozHAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:21:21 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D4BBB22538; Tue, 10 Nov 2026 15:21:16 +0100 (CET)
Date: Tue, 10 Nov 2026 15:21:16 +0100
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
Subject: Re: [PATCH v2 07/51] lockd: don't hand out the terminator of
 nlm_end_grace
Message-ID: <4isxnxlzjedh4t3hq73g5wjuwdtiudxx6llf6do2noyrno5lsb@6xwb4gw7wi7b>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-7-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-7-bbf7d5546809@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Stat-Signature: n9a8rwbpo93msuau74rbpnd68hjgk48x
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5306420005
X-HE-Tag: 1794320484-866053
X-HE-Meta: U2FsdGVkX181y+HlobxAJbGp3y2LTgDPTxGzSzNo0ySMmdBVjEc4YUwtZPTMMoZO2OGTLKEr4U3P9m56NuPSsxtQEtWTaFq/X+zDPZw2ZeOuaEOlUcGCEuFfvgvFIBsY9wSfmRQNcXwfsWaGh6yCQfoasiUMvR9DLg1xy6eD0bDHzfGq+OhDvblKEX+8b15zyIML+xLi3sUOntGwyKJqW2gApTQcpmLnyD0dJo7vfYt3ynMfGQzeApl0bSs89Nu/5nvsIKV0seSCkGfi1Yjav2sZktQdNDPuBcsDz08GtOZbDAgo02yCX4hNo8YS3LkY1nsAC+8KO4eCSU2irKsHaKnzV96RM2+XVqwdxHXhfsXM963jsQx/u+Ye6t9AhrLQd95c66DpFjMPwglCz9RrutwNiKC2ykTQ0PZH23PeL/Cv1kTgZafB3qlxQjhNBz/EybvFRpFBZ4O+Y1L8TTZ5qh3Fns9Zpg/OMdrbZHUNHYx+JNSef5wgBLF2LAWilDMYQCXJAlPJrnYJFljEwXEbWOC07DFc541EsMwtswzULHX1kzuMvZBygPsvh7nlKTuvZ6Clk3b5hLQT7gGNMfFCdqdtOcO63Stbq0Tg83mGMV6Cagys8KLNKe8k9++2hVZT11gJrnJB4ORuZFm5XFHCkCeaqUvucL2UPOIPcBQJnW/fB/zhlEmRSvnUOwMVXYK3BjmeR5iWsYwpPeJBD8fdCMDu5PGHSnEfDgQLgosaqL9Jp2kNYZlc7pnxpGDyjJ9Wte02K1Rz1Qr0TUcbFd++yassafP02WcWLOTTcKccipYbNvUYwTENVJU2nhON3Q+owLEPyFn+0fzXd6x+lzZlSjLCnNxmd4k2uV7o0lP3MmJABK41rEAwDMvQ4yZiFUh5J9/yo17lejHXLr4l+TlSXtNpwQQPs96YBhWeMe9WnJrrfbjR8zFWn4K2CAtJqPy37cuKkUG6roBHaKqKRbK
 5WV9Ns05
 KrqgpYRsQZtnXggGF0bBfi18NJeJcMdLT5cc8PcF2YFUDbtke+IgL7bkOqesx+5NbhlnC4HvLC1aC9gsUhic4MLG34MDjZNtV+ek+ZdgHrhlF7Lqnf1xt1XyDagbst9gwfFBwQlmlVyXqCiGf47TzR63qdvp3bPyQa3UP3EQgmMXNFYdqlj4qbSTlZ3P5aBEEYUdMjDWYjPnZMij5blNuZezzi/ymwhTfa5JwoikvshUxkdTLf06rlw7aI7ONlB4uO6kHVWUW83GW0QqkopZDVoQipsQ4VFTSE6Vrk8CfNAVIS8Dg3nHlx2NIvGBIfYVSDGYMVFVDy3JbK+Vi61NONyiYVw8cLNEExwwPSNIe5nivWxG9Z/AX17C5mGwuJUmaQ5kjewL3+tR4aQgnIqkmC8xS9t50LzQrNOoGo7XWh2UekOgIb9jtV5PczeecYuv/1XkN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 18:27:24, Christian Brauner wrote:
> nlm_end_grace_read() answers with "Y\n" or "N\n" from a three byte
> buffer and hands out all three bytes, the terminating NUL included.
> Leave the NUL out.
> 
> Fixes: d68e3c4aa416 ("lockd: add a /proc/fs/lockd/nlm_end_grace file")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/lockd/procfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/lockd/procfs.c b/fs/lockd/procfs.c
> index a01f08c8c2f3..74f7ab77535a 100644
> --- a/fs/lockd/procfs.c
> +++ b/fs/lockd/procfs.c
> @@ -57,7 +57,7 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
>  	resp[1] = '\n';
>  	resp[2] = '\0';
>  
> -	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp));
> +	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp) - 1);
>  }
>  
>  static const struct proc_ops lockd_end_grace_proc_ops = {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

