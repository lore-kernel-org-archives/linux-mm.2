Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92816D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008C86B00BE; Thu,  8 Jan 2026 12:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01FA6B00C2; Thu,  8 Jan 2026 12:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCE46B00C3; Thu,  8 Jan 2026 12:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAA646B00BE
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:34:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A10514021B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:34:22 +0000 (UTC)
X-FDA: 84309495564.28.3B68795
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 350EA4000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:34:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/EZdGIT";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ThMGOBot;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/EZdGIT";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ThMGOBot;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767893660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+CPMws/FnGYdGWk6ohH7U7LIk13uVJdlWREsvgP22k=;
	b=s6PSZtRvCDWj1nbaMeIku/PMsEIwvMQRJ/P61blbaV6L1u//MXillqUhib2CKfbQTlNVby
	Xmd+adKIibwe2Gs+67Fsc57V3OOXdh1AX39s/c/Gxpo6bXV3Y4QcJxke+95qatT4BYVOjJ
	45oVTO3wsOvEkBQJHO2zZovPyqIFWAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767893660; a=rsa-sha256;
	cv=none;
	b=CRMJhQIqsQgpWO1lB74nbNZCxSxAS0SDybXYuc6JPexfn4TEQR1IcemM7YSCJO4w6s3lcA
	n5fLoP787HXgVRg4aW3ik5sqk28gw11kXa5/FppI3UjFIFXUp0spTJo2/UTC/plimAbji3
	pe/5TisHb5HIYoX/HgOvFBrO0EKGFSI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/EZdGIT";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ThMGOBot;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/EZdGIT";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ThMGOBot;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3206A5CBBA;
	Thu,  8 Jan 2026 17:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F+CPMws/FnGYdGWk6ohH7U7LIk13uVJdlWREsvgP22k=;
	b=v/EZdGITitw8CsQiMuaGfXbUwWWx8X5TD/YRa/XZZpZ68ngQ9xwJ0IIhpHdhcnkJ73fsRf
	p+mufimcDsVx7itgUk6q88o1BMvGZdhe3E1n/AChQ7pU+p1eYtiCRpkctujSCJSu5bivTP
	E3j+OIjCP6YUECLftS1PCmGaQtp0d/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F+CPMws/FnGYdGWk6ohH7U7LIk13uVJdlWREsvgP22k=;
	b=ThMGOBotWNLGznhXYptjblJw1E5rrD2imFij6R6Qug5s3TyXHn8Vw/C9Wgt+x5X6XILeTi
	WJvEzDPbx8aSLDBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F+CPMws/FnGYdGWk6ohH7U7LIk13uVJdlWREsvgP22k=;
	b=v/EZdGITitw8CsQiMuaGfXbUwWWx8X5TD/YRa/XZZpZ68ngQ9xwJ0IIhpHdhcnkJ73fsRf
	p+mufimcDsVx7itgUk6q88o1BMvGZdhe3E1n/AChQ7pU+p1eYtiCRpkctujSCJSu5bivTP
	E3j+OIjCP6YUECLftS1PCmGaQtp0d/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F+CPMws/FnGYdGWk6ohH7U7LIk13uVJdlWREsvgP22k=;
	b=ThMGOBotWNLGznhXYptjblJw1E5rrD2imFij6R6Qug5s3TyXHn8Vw/C9Wgt+x5X6XILeTi
	WJvEzDPbx8aSLDBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A91D3EA63;
	Thu,  8 Jan 2026 17:34:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tcZtBprqX2kkfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:34:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C390EA0B23; Thu,  8 Jan 2026 18:34:13 +0100 (CET)
Date: Thu, 8 Jan 2026 18:34:13 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev, 
	linux-doc@vger.kernel.org, v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH 23/24] filelock: default to returning -EINVAL when
 ->setlease operation is NULL
Message-ID: <j3qkk6xh6q76uorxfrqfp5gubc44qe6d3gqeshb55yxi3miexu@udfpls76gitt>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-23-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-23-ea4dec9b67fa@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 350EA4000C
X-Rspam-User: 
X-Stat-Signature: 7n6hgn48cfrpa1ucqjpjju3hwbbn8gg9
X-HE-Tag: 1767893659-791283
X-HE-Meta: U2FsdGVkX18LF49hNVWOc9tZcx0Rk3wSPuWS1yoMw+doV3YWh7jPA6sl9Br0UiyRjcU6eCsEsA8MR0lwoueVhoy/MIkaEyspfNCfOtpsjkYbyznyV0CNkk9PeOnimy79A1ynwNFFW7UWIID1HD1lL5Ng17ZTbA+SdigotOCuUh3pQCuZQD7W0KRid87QCNb9E2QkCF7Ctay7kUySc8Bq6NZKLCAqKH3WiFL6GBy19F5VxaRMEOIvDDYqqQqUCM6nIV1fVN1206hKzusT124Y+Ft6U83jQFH7wCMie+3xVtQiysdP9grekg5XIbQImD9ekq8CPlCllWlWjopS7kl9AwWKOF4kxAh2jfSufgUzz2CJStLLBKf6eH+vMft4rnu35wQuxrbYGOCpUY4cCIXDseOW7wxLFyA5PgUPSde88NboB10fFEFfkIzq3+0mMRgG8HSaGmuSkB2XnWBc+OEE9JcCds209bqZvxFjf5IScv1lISN0o841dp5fPZ64eRIcAGPBEqR3vF/1u7UIspp0aZGTPlcUy0ITk2baUIHdyGuTtTba/rOsgv2vgc7AsBNLcQJqRXtt24XNu6F+jycYDVDWthDiBQXPOxGxRrE1pVAbWJFzMs1MOJGmEP5d88bx2I/Su1yoIJ3pias2oc/E94rEJpt1SBzA+Uo147opF1ezho8oLQKgH0cbUPnuW2zDfeM7+vg3fOYVGVlW+h4ZnzSMxn5kgwQKdMa5wqTQqFRMV4up88T7ErCQqRDg3kNy+QqGKXjPz4HvXuq75OadIhwdcy5dSAOawWWVArfw4c7R7tySKlcPXKPs2lSBCmLzusLPUiIJP1hNgu/iUbnv9qIeOP0C52JY1diFnfBsstM/rHSCXOZJPNsHP4Cmhno2vSmQTegYVd9KbKs/EJJMth8q2/d1XHr1UHmLMBcgqjdC/Q6fuQfFEu3Akwm9Dc7K7cXFDi+phobXBwmQXV9
 71srpDkO
 RjhVJOuhjf8pIeQCA7Pow0VGpS+VrxsyN8MdfvRdYfdfcJf//prmdSxpUxO7k3NwE473PAgOJKbKagU9MavZM52vL9xtMaYyLkLTYotThKKkQilUgKm5eFkmrvL8etHu1beG03Mpo/E/mcszh7RzJvthvfUo/oyZdIFxwgKJCNC+TL2FUOsxvvONXLC7Nl9mB6xsNOM++LfgoesoOtw5EhBe4PltCeieqh7MWAwv8pLpZNb+Cj4/en2pODdbJ1GvIQedI6RZKdRF/uvgkAKfi/lVvZRxkP5pmitWJq491KI+hZggYSxAaYPqbuFkaAYkLQGrp1U1R/bB+/SPta6LGHnK4On9Y/gBQLF+svNraPohaJb4WJ++FJgSnEcV1J8tIgvuD9w9ZLEDkJ1V9NmuHdde0h1R61JlgtLNG+uV5SuzmsC0AbiO6Bk6Tlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 12:13:18, Jeff Layton wrote:
> Now that most filesystems where we expect to need lease support have
> their ->setlease() operations explicitly set, change kernel_setlease()
> to return -EINVAL when the setlease is a NULL pointer.
> 
> Also update the Documentation/ with info about this change.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/filesystems/porting.rst | 9 +++++++++
>  Documentation/filesystems/vfs.rst     | 9 ++++++---
>  fs/locks.c                            | 3 +--
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index 3397937ed838e5e7dfacc6379a9d71481cc30914..c0f7103628ab5ed70d142a5c7f6d95ca4734c741 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1334,3 +1334,12 @@ end_creating() and the parent will be unlocked precisely when necessary.
>  
>  kill_litter_super() is gone; convert to DCACHE_PERSISTENT use (as all
>  in-tree filesystems have done).
> +
> +---
> +
> +**mandatory**
> +
> +The ->setlease() file_operation must now be explicitly set in order to provide
> +support for leases. When set to NULL, the kernel will now return -EINVAL to
> +attempts to set a lease. Filesystems that wish to use the kernel-internal lease
> +implementation should set it to generic_setlease().
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 670ba66b60e4964927164a57e68adc0edfc681ee..21dc8921dd9ebedeafc4c108de7327f172138b6e 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -1180,9 +1180,12 @@ otherwise noted.
>  	method is used by the splice(2) system call
>  
>  ``setlease``
> -	called by the VFS to set or release a file lock lease.  setlease
> -	implementations should call generic_setlease to record or remove
> -	the lease in the inode after setting it.
> +	called by the VFS to set or release a file lock lease.  Local
> +	filesystems that wish to use the kernel-internal lease implementation
> +	should set this to generic_setlease(). Other setlease implementations
> +	should call generic_setlease() to record or remove the lease in the inode
> +	after setting it. When set to NULL, attempts to set or remove a lease will
> +	return -EINVAL.
>  
>  ``fallocate``
>  	called by the VFS to preallocate blocks or punch a hole.
> diff --git a/fs/locks.c b/fs/locks.c
> index e2036aa4bd3734be415296f9157d8f17166878aa..ea38a18f373c2202ba79e8e37125f8d32a0e2d42 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2016,8 +2016,7 @@ kernel_setlease(struct file *filp, int arg, struct file_lease **lease, void **pr
>  		setlease_notifier(arg, *lease);
>  	if (filp->f_op->setlease)
>  		return filp->f_op->setlease(filp, arg, lease, priv);
> -	else
> -		return generic_setlease(filp, arg, lease, priv);
> +	return -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(kernel_setlease);
>  
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

