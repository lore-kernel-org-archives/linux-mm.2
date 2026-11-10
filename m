Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7955606A772
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Mnc4QrSZ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Mnc4QrSZ
Received: by kanga.kvack.org (Postfix)
	id ACD936B05DD; Tue, 10 Nov 2026 08:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4BE6B05DE; Tue, 10 Nov 2026 08:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993EE6B05DF; Tue, 10 Nov 2026 08:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 770D46B05DD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:03:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1530CA0875
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:03:23 +0000 (UTC)
X-FDA: 85419225486.27.F8805AF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id E44ECC0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:03:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mnc4QrSZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mnc4QrSZ;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=P2YYqdRnJNXpQf1kIMutR8iKFaiauw40tJN5o3Evsj/6BZjvEgm8OFcOMYvaxsJRKZ8g7o
	pMsWiTV5iLmZ3KL2z68i2FJHDUoA6IBNBu3dsXCP+M3mslOMnPkH1UY1tUntmolQ2K/ByM
	cOC1t0X5D2L+0RCC+VSGLKVAipz9MZw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mnc4QrSZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mnc4QrSZ;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315801;
	b=8DgGPwyYQhIfdNOa/GR2mnUBIDjogV2ndsQEP1srISJC7O5d5j8ham1ek6xrcWEnESOc/0
	4FpM7fAe5bF1XFTtuo4qxEEqhnc3Ef+vCmk7tRg2R2y5pUYb2Cz7puHqmIXE8I+B+NbUfB
	AslSvFrIH5/yLOlHO+NYds89IsH4G/8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C0D9421F77;
	Tue, 10 Nov 2026 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=nU4XxgALhU6j4K3Mxr5ngQH1kaedGJkQyEqwlGUplEx9hMxQ3fo4McMmOwr1ERv3Mkpxw3
	gLCfI+EWYKzq/l9mRzhXb6GJ0h3nlI+5tsg9MpjQ2PJDBC1XC/U5s6EqGl5dlEXIEKPAnz
	BBcKQlac9Q1+gcOvfNs3dKHhhfnARxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=Mnc4QrSZrRmpafaJe4iOnLi1RuOTcqJe/GGSNdftVub9UNeD+cHjavH2Su/fUJ6PuunSLs
	aVyAWefkY3MWbuCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=nU4XxgALhU6j4K3Mxr5ngQH1kaedGJkQyEqwlGUplEx9hMxQ3fo4McMmOwr1ERv3Mkpxw3
	gLCfI+EWYKzq/l9mRzhXb6GJ0h3nlI+5tsg9MpjQ2PJDBC1XC/U5s6EqGl5dlEXIEKPAnz
	BBcKQlac9Q1+gcOvfNs3dKHhhfnARxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=Mnc4QrSZrRmpafaJe4iOnLi1RuOTcqJe/GGSNdftVub9UNeD+cHjavH2Su/fUJ6PuunSLs
	aVyAWefkY3MWbuCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 960C61339F;
	Tue, 10 Nov 2026 13:03:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e3rfGxcW82q6SgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:03:19 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 35CB1224F7; Tue, 10 Nov 2026 14:03:15 +0100 (CET)
Date: Tue, 10 Nov 2026 14:03:15 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 34/41] loop: refuse files on pseudo filesystems as
 backing files
Message-ID: <xlql7gc5uyvehjvin4ls3okfnv32xxdj45bjvamf2vdkrakvjx@u4iwy4ydmphs>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Stat-Signature: mjrub6pf9jonmjgwoemwafijm5kn8db4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E44ECC0002
X-HE-Tag: 1794315800-262198
X-HE-Meta: U2FsdGVkX1+1wmvRFSiWjzICajyyIpLrKLKOHR/mdi0SloaArd7G6XidGmYgYmbQGng0BjXvLWxVIjBpaTURNOVlaHtOjHMxZY/GlJca7vKz/ahd6aMrF+TwmsJV3x1sce1UH7rhtTB8mhx2nS5B7Bh1D1AKGDQnZJ7wiQh3VNz7zEI+nUU5bKiteQeo/mjYfzMhnCWPdHniUR184OL/uN3MQvvPM9lB391NnKF6ZJrkTRRDAYd6f4D3G+BFBdJEkpKMGwIXbyjCtd8WyGay0vvUsIpBjVmrTfjD2YwV2NpReLID8wc8FNCXjehiXGOIvtpBuyxXoTPU40lpVDLuEHshu8YRTzMJv4hpOiiWyTFv4XBgzSxOAccvJBcfcSuUfn4O2cQBSx8CYganKD5Dw7Lx5CvIDJ75xHn3VNECkOg8em86OZpMK/zqgvgT2nqMHjt5Lh6i4iF1uDkBr///W4Tf+8pW+yhxxPw+Wr0lPpUbqFv6PZs/wU98BxSbg7mTBBEDEKAkP8oIyLCzD2bU1hO5xMMsVzZn5erax2hbM9lGTS/5ENcmIHR3okxkjQra9x4VghX+QzgpvpXJSU2EhVBG3OVgajIdfjxqkfXfbJaeDWr3UQ4mybdYeTrb9rpgCoDNdZQGvbeqol48X1oswHm//Esf7vrQ7wJg54ZnIizS9Wc/xP8z16DDJnjbOC0SwX+t2+Vkgnqnwx01UtPT0KnhOhYZVVxhnlpBQFX01OpcEDzY6cmSnzbES+n3zlJW9yt5enQnkSYZUo+xLJQvZGxukdWMCAFUctpJZBvuRgb7CRPmLkGAs/Zqn2CGxhGUoaLrG/WqNI/zs3ezufeGn+Fa1AnOBigy6GQwnOJfbJe3WM+5THw3Gc7nfeLzZA2bktE2W/u9LQ8xENJB55mySTF37wO++cOdFO5tpWa3tBZ/5ux858Evnj++LpzQ+2oPzAwgHVWLQLY/fhgvkoB
 mqyoPFCk
 GF/czmg5sq0C6PWl/uobYMwo0+c3teHhlaC7m153O4+MD9txbarIts45wc+haqNJieg4vlr7nUNAeKQyrIFAyX3bqHbC2oEJm3aeSYNS7tup/EMDnRyOqthyULGS0FUZf357JpAFC0+WSBLA7Cu4XMVoBMmoHxNDDl6iLaANAtJYj8mQcvXKEtRy4Cu4Kzk4wgX/XSkabDAK10JYFboGFiykq/IxNPXrU+NF2nNhAW+jbq7pK/4VyeRCDd6wNHCRZ9gGZrCpM+gp447ORfoZeNtA6DsxIc3CyLlHmcVjnbObb+ciODhhT/ql8bupFHUP8SmWvw5rjwhHkyVxIUI6eXSgF1cYqlNZd0zbhCMMrl0EemwAa/URfMsctNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:50, Christian Brauner wrote:
> Currently loop accepts any regular file that implements ->read_iter() as
> a backing file and any that also implements ->write_iter() as a writable
> one. That includes files on procfs, sysfs and other pseudo filesystems.
> For example, /proc/kcore attaches read-only as a loop device the size of
> the kernel's virtual address space, 64 PiB with 5-level paging. sysfs
> attributes attach read-write as 4096 byte loop devices. Writing a block
> to the loop device of /sys/kernel/mm/transparent_hugepage/enabled
> changes the THP setting.
> 
> That's not just nonsensical, it can be abused. Loop calls ->read_iter()
> and ->write_iter() of the backing file directly from its worker which
> runs with kernel credentials. But pseudo files enforce part of their
> access rules at read and write time against current. Dozens of sysfs
> ->show() and ->store() methods call capable(). Behind a loop device all
> of these checks are done against the loop worker instead of the task
> that opened the file. And setting up a loop device requires no
> capabilities, only access to the device nodes. So on v7.4-rc1:
> 
> - uid 0 without any capabilities can't write to /sys/kernel/reboot/mode
>   as mode_store() requires CAP_SYS_BOOT. Writing "warm" through a loop
>   device works.
> 
> - uid 0 without any capabilities can't read the files in
>   /sys/firmware/dmi/entries/*/ as dmi_sysfs_attr_show() requires
>   CAP_SYS_ADMIN. Reading them through a loop device works.
> 
> - An unprivileged container that was handed a loop device can't change
>   gro_flush_timeout of its own network devices as
>   gro_flush_timeout_store() requires CAP_NET_ADMIN in the initial user
>   namespace. Writing it through a loop device works.
> 
> The same goes for hard_offline_page, the md and sd attributes, rfkill
> and others.
> 
> Refuse files on pseudo filesystems as loop backing files. Note that
> file_is_pseudo() looks through overlayfs so stacking overlayfs on top of
> sysfs doesn't get around this.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/block/loop.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index c96e35c3ef42..1482580a1979 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -537,6 +537,9 @@ static int loop_check_backing_file(struct file *file)
>  	if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
>  		return -EINVAL;
>  
> +	if (file_is_pseudo(file))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

