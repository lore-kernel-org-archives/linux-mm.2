Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10E3FCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B496B000D; Wed, 10 Sep 2025 08:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4433C6B000E; Wed, 10 Sep 2025 08:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3586B6B0010; Wed, 10 Sep 2025 08:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1466B000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:14:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 972CBC08F0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:14:28 +0000 (UTC)
X-FDA: 83873233416.09.5D90A8F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F1CD8000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:14:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pxUK7Ex4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9Ky4gXRZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pxUK7Ex4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9Ky4gXRZ;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757506466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5gaLRnDjWbSxcnFQcn+mJTPFqz2bFPqndDkLtin1DQ=;
	b=f6rewM1rgvMNTy+5yQ+8AwI+w2deCYlP9m/t96GpC92JOzSMoojjJIhqUi5Ps3bQnFyAdM
	5XGj/41Lz9tQ5sOBkvaJ/t8UW7StXgWuQTTqt/xlhs9WHs4E2QE0mUME+BDwMyYav05WrD
	KPkQVgwRTBOQeMBCnqmnuEkyIzJaDiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757506466; a=rsa-sha256;
	cv=none;
	b=2u92xZsZBexg2Aq0ZjkT1rfjppuvqf3/WZ0nxF4wfEBGEtdebkYrbALmJmm9bpEfCmgxJt
	vAoOfrbd2GjpSEeIAyIvEtZYy59C81eZQ3yowbMImUEApHQx5Vckjki/qa+GDxo/bX9z7r
	x5yxq1luHt91sXk+JUkWg0GkhkRyaZo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pxUK7Ex4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9Ky4gXRZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pxUK7Ex4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9Ky4gXRZ;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4790221C86;
	Wed, 10 Sep 2025 12:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757506462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N5gaLRnDjWbSxcnFQcn+mJTPFqz2bFPqndDkLtin1DQ=;
	b=pxUK7Ex4yGUYNZN5PAhw/Tv8WMvIaGVpDrwKkZypT8Tt/i7D8ZuxmpL/UcajxPIzwF7tEo
	7yqX/56rfaO8T8K4BA4kzZnZPmDrnda+0l6EoZmlxsQdE57FoTbaB1XrLnopGf2+mQL/Nh
	4zD0nijuHe6aMZY7DbzDYqXQEBWdGVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757506462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N5gaLRnDjWbSxcnFQcn+mJTPFqz2bFPqndDkLtin1DQ=;
	b=9Ky4gXRZ131dmOszA0mfrMQRRdIB/H1HsExL07hjq7MUHDiFjy1R943NmRUPW9NaYMiMeh
	5Y3L9e/6vzRzwxBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757506462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N5gaLRnDjWbSxcnFQcn+mJTPFqz2bFPqndDkLtin1DQ=;
	b=pxUK7Ex4yGUYNZN5PAhw/Tv8WMvIaGVpDrwKkZypT8Tt/i7D8ZuxmpL/UcajxPIzwF7tEo
	7yqX/56rfaO8T8K4BA4kzZnZPmDrnda+0l6EoZmlxsQdE57FoTbaB1XrLnopGf2+mQL/Nh
	4zD0nijuHe6aMZY7DbzDYqXQEBWdGVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757506462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N5gaLRnDjWbSxcnFQcn+mJTPFqz2bFPqndDkLtin1DQ=;
	b=9Ky4gXRZ131dmOszA0mfrMQRRdIB/H1HsExL07hjq7MUHDiFjy1R943NmRUPW9NaYMiMeh
	5Y3L9e/6vzRzwxBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7870713310;
	Wed, 10 Sep 2025 12:14:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4cE8GptrwWhadQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 10 Sep 2025 12:14:19 +0000
Date: Wed, 10 Sep 2025 13:14:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, andreyknvl@gmail.com, 
	arnd@arndb.de, bp@alien8.de, brauner@kernel.org, bsegall@google.com, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com, 
	dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org, 
	jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org, 
	liam.howlett@oracle.com, linyongting@bytedance.com, lorenzo.stoakes@oracle.com, 
	luto@kernel.org, markhemm@googlemail.com, maz@kernel.org, mhiramat@kernel.org, 
	mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, muchun.song@linux.dev, 
	neilb@suse.de, osalvador@suse.de, pcc@google.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com, 
	willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 01/22] mm: Add msharefs filesystem
Message-ID: <do7cmy4eiiqd5ux62r3u2ghizc62ljg5m3mqx7qzy3im4kc2p6@upmigdbp7eat>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <20250820010415.699353-2-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820010415.699353-2-anthony.yznaga@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F1CD8000C
X-Stat-Signature: s51mstcinzikegyfyc5eyh44d8u1apff
X-Rspam-User: 
X-HE-Tag: 1757506466-324163
X-HE-Meta: U2FsdGVkX1+xUYr+5YA0RRyT4HVoCSQXgZl11l1Sk7+0c0VSTC1QQyoAahl45MeIqSSIVs7yrkEOuEt6xmTyGHyLxpO/hcT4/gt4gce62lelRcula5La+kkU1IUDbAAEEm2idEo6Tn/FgkTAZsiQBCgXxpas/JUJ5bXSADmIqHVmgi3pnqFkwN3sIXlOXEwyhVyicr1R2TFsxve47R7T2bWf5rlz5pqXePY8d5tAoxH4t2+AprzLxh2F2XNQc90b+6iEZmWMu19TY+9R1g0xbd7YUjvX3srBY6X7JPICNEKu6QKwlsbHV+ivSOxzWWqdOnoi2YDIPGmEuvMZTJuAPtIawop0/ql1Bosh/rY2QTyKlUWo9GM6ks4wO3wM+2EL9nTezI1kB37pq4QMT0OzGQ0Nr5MdtmiFncYPVYtDjmiLtpwnmZlOd/0fenQSmwkf1h6ZPcmMu3aqAxlDcyEBfq7L3nUZJdJkjRUTZHb3I8hDmCpJtI3v8YxSQDHHe5lrqxRIp0YSlo9g9VOd8vKVCin3vcs46ftYF9j08+dqg5mK5fxsFcHUsHQIvIMbo86smGvfsJXOkyBMOVEc6iRcUp2qhMVR5EGvN2x/JGiuBGDPxSDzuw6/Q1qB/Q52mY15mzeDe5eccRdHygmhJn1c+lUZoPj8mESPpZdm3rgwVwuqAANcpG19vUlrY0/e8v0ZwGo4HxfooHNal7sJ6GNcC73wzb5tvvKQ/UQz0MFIObZl/ttqVQQdwzbXp4DXB1wK6lFHAN5hVVaO9+qwsQJOaTzaW7bXwZNm9ENaeXwaJ2eXf7l1jNlYTUi4jVMkele2Ix+fs0T0S8dLtIu7mneLDeQnjUJW9si994ESO74aNtonBagZr9uPjD7nZElLx4LfBKT1uH/AYbx3OXf4mtnKE3JrtDV1GSyZTRK3wu1uwy28/keJOFS9pngki7vRS1IU21/nF0QUEo2SiYcsV7N
 gz2Rv1Tp
 ri7CZJyAxLptyCGWxCbPI04FkPvyeQ9JgYU3NpesDRB4DDCuS0MWdZGxDGOALpOq5hF03N2Csjt8Gmamdy3PCCp5AeIZaynn58d1icxNfrHYzkNYfIvhXqzgUnWCAdD/oz/36ynOLh4dOo4287eOQezgE31EiTcIicDveAKJ2Y5fbcZ9Rh9veEeZ988k5ypW6VG0tzCbe1DkNmKRlQ09h54eSlNqwZp+07XQK6FtAuHXrx+CXid9SIQdEyZqW20AJ87aWWzZkKzCIZVcikgmb98PE520P8mIQhWBCkd8d4Je3J5qntKxHsbS+HlIemtm9zEFK0w7xGDscLybsINvJav/g9x7sgYmVaZfY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 06:03:54PM -0700, Anthony Yznaga wrote:
> From: Khalid Aziz <khalid@kernel.org>
> 
> Add a pseudo filesystem that contains files and page table sharing
> information that enables processes to share page table entries.
> This patch adds the basic filesystem that can be mounted, a
> CONFIG_MSHARE option to enable the feature, and documentation.
> 
> Signed-off-by: Khalid Aziz <khalid@kernel.org>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---
>  Documentation/filesystems/index.rst    |  1 +
>  Documentation/filesystems/msharefs.rst | 96 +++++++++++++++++++++++++
>  include/uapi/linux/magic.h             |  1 +
>  mm/Kconfig                             | 11 +++
>  mm/Makefile                            |  4 ++
>  mm/mshare.c                            | 97 ++++++++++++++++++++++++++
>  6 files changed, 210 insertions(+)
>  create mode 100644 Documentation/filesystems/msharefs.rst
>  create mode 100644 mm/mshare.c
> 
> diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
> index 11a599387266..dcd6605eb228 100644
> --- a/Documentation/filesystems/index.rst
> +++ b/Documentation/filesystems/index.rst
> @@ -102,6 +102,7 @@ Documentation for filesystem implementations.
>     fuse-passthrough
>     inotify
>     isofs
> +   msharefs
>     nilfs2
>     nfs/index
>     ntfs3
> diff --git a/Documentation/filesystems/msharefs.rst b/Documentation/filesystems/msharefs.rst
> new file mode 100644
> index 000000000000..3e5b7d531821
> --- /dev/null
> +++ b/Documentation/filesystems/msharefs.rst
> @@ -0,0 +1,96 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=====================================================
> +Msharefs - A filesystem to support shared page tables
> +=====================================================
> +
> +What is msharefs?
> +-----------------
> +
> +msharefs is a pseudo filesystem that allows multiple processes to
> +share page table entries for shared pages. To enable support for
> +msharefs the kernel must be compiled with CONFIG_MSHARE set.
> +
> +msharefs is typically mounted like this::
> +
> +	mount -t msharefs none /sys/fs/mshare
> +
> +A file created on msharefs creates a new shared region where all
> +processes mapping that region will map it using shared page table
> +entries. Once the size of the region has been established via
> +ftruncate() or fallocate(), the region can be mapped into processes
> +and ioctls used to map and unmap objects within it. Note that an
> +msharefs file is a control file and accessing mapped objects within
> +a shared region through read or write of the file is not permitted.
> +

Welp. I really really don't like this API.
I assume this has been discussed previously, but why do we need a new
magical pseudofs mounted under some random /sys directory?

But, ok, assuming we're thinking about something hugetlbfs like, that's not too
bad, and programs already know how to use it.

> +How to use mshare
> +-----------------
> +
> +Here are the basic steps for using mshare:
> +
> +  1. Mount msharefs on /sys/fs/mshare::
> +
> +	mount -t msharefs msharefs /sys/fs/mshare
> +
> +  2. mshare regions have alignment and size requirements. Start
> +     address for the region must be aligned to an address boundary and
> +     be a multiple of fixed size. This alignment and size requirement
> +     can be obtained by reading the file ``/sys/fs/mshare/mshare_info``
> +     which returns a number in text format. mshare regions must be
> +     aligned to this boundary and be a multiple of this size.
> +

I don't see why size and alignment needs to be taken into consideration by
userspace. You can simply establish a mapping and pad it out.

> +  3. For the process creating an mshare region:
> +
> +    a. Create a file on /sys/fs/mshare, for example::
> +
> +        fd = open("/sys/fs/mshare/shareme",
> +                        O_RDWR|O_CREAT|O_EXCL, 0600);

Ok, makes sense.

> +
> +    b. Establish the size of the region::
> +
> +        fallocate(fd, 0, 0, BUF_SIZE);
> +
> +      or::
> +
> +        ftruncate(fd, BUF_SIZE);
> +

Yep.

> +    c. Map some memory in the region::
> +
> +	struct mshare_create mcreate;
> +
> +	mcreate.region_offset = 0;
> +	mcreate.size = BUF_SIZE;
> +	mcreate.offset = 0;
> +	mcreate.prot = PROT_READ | PROT_WRITE;
> +	mcreate.flags = MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED;
> +	mcreate.fd = -1;
> +
> +	ioctl(fd, MSHAREFS_CREATE_MAPPING, &mcreate);

Why?? Do you want to map mappings in msharefs files, that can themselves be
mapped? Why do we need an ioctl here?

Really, this feature seems very overengineered. If you want to go the fs route,
doing a new pseudofs that's just like hugetlb, but without the hugepages, sounds
like a decent idea. Or enhancing tmpfs to actually support this kind of stuff.
Or properly doing a syscall that can try to attach the page-table-sharing
property to random VMAs.

But I'm wholly opposed to the idea of "mapping a file that itself has more
mappings, mappings which you establish using a magic filesystem and ioctls".

-- 
Pedro

