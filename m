Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C912606D5DA
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Tg9pxHAG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=q20vaKKg;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Tg9pxHAG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=q20vaKKg
Received: by kanga.kvack.org (Postfix)
	id 76A976B05B0; Tue, 10 Nov 2026 07:59:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741FF6B05B8; Tue, 10 Nov 2026 07:59:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6584E6B05D5; Tue, 10 Nov 2026 07:59:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD996B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:59:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC6DE8058B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:29 +0000 (UTC)
X-FDA: 85419215658.01.4D65678
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 94EDFA0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tg9pxHAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q20vaKKg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tg9pxHAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q20vaKKg;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KLB44ZvNPPyRXKdiegczIQhHN8ao8apnQUZAyLWj+4=;
	b=6X4u6BJCT1WtgCMcgoqvdVIm5z5dtg9ql7I+hU7zidvgLie9iTLo8uDxxCCA0wNgMmPi9F
	pWGI9F564xFZ8bs8c/xTAQDhsEKtrxXw9wS9EgPcXGCwOZAPR1fGPho+LcAUwSHJzLYy7B
	jf9sjX4yKWxcRyLbJBhVOYAJjeQyiRY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315567;
	b=aPE7zR0WcgHzpchmYUOXvRS0V952wGq0qQep8M1LPsQNn3lNdn3iv63HFVKl6VT+RIcLPE
	hvSd+8dqMqCavyegiDeHMZ4AprN7idDn82vEX2d+XD205xh5BzIe97C5GFE8SNthcE3oMq
	7fGPyzuSKbgvRNUMl4hvoX0k/Ou3GlI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tg9pxHAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q20vaKKg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tg9pxHAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q20vaKKg;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 56C8E1FB86;
	Tue, 10 Nov 2026 12:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KLB44ZvNPPyRXKdiegczIQhHN8ao8apnQUZAyLWj+4=;
	b=Tg9pxHAGdtgSeS7Qu42jAWrI2LAmSaoDXcdfGHx1tuvTgldlFIm+epZXlZZj79RfQ/uyYs
	j7aTWHT3+26/dA5zpMh+gCzr5PQEW79hL4QQOyR+4ECdDFeslymvZjZejsnkfxlL2jXCBs
	ItKgb+Sl0jU9dDgVqfAl/iGxQ3BwU2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KLB44ZvNPPyRXKdiegczIQhHN8ao8apnQUZAyLWj+4=;
	b=q20vaKKgsSX1kEDHQVu62VroC195QLudNGL/QIvX4QmdixQN3bbqOd+0xO46gJ/KYR5M2p
	3Po4KFQU6XBLecCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KLB44ZvNPPyRXKdiegczIQhHN8ao8apnQUZAyLWj+4=;
	b=Tg9pxHAGdtgSeS7Qu42jAWrI2LAmSaoDXcdfGHx1tuvTgldlFIm+epZXlZZj79RfQ/uyYs
	j7aTWHT3+26/dA5zpMh+gCzr5PQEW79hL4QQOyR+4ECdDFeslymvZjZejsnkfxlL2jXCBs
	ItKgb+Sl0jU9dDgVqfAl/iGxQ3BwU2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KLB44ZvNPPyRXKdiegczIQhHN8ao8apnQUZAyLWj+4=;
	b=q20vaKKgsSX1kEDHQVu62VroC195QLudNGL/QIvX4QmdixQN3bbqOd+0xO46gJ/KYR5M2p
	3Po4KFQU6XBLecCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22D901339F;
	Tue, 10 Nov 2026 12:59:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o6G5AC4V82quRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:59:26 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B65D4224F1; Tue, 10 Nov 2026 13:59:25 +0100 (CET)
Date: Tue, 10 Nov 2026 13:59:25 +0100
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
Subject: Re: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
Message-ID: <huxjpffxqk5qugzjbc2mvrdvqab6idnvjqi7zla2far65t3im3@4lilbachmbvw>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Stat-Signature: 3r5qh1zm68wwjczbfu8z7mmqjahce78c
X-Rspamd-Queue-Id: 94EDFA0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794315567-669757
X-HE-Meta: U2FsdGVkX1/YyBzETMdJF4OQx67UmnjtGwzacOSi+sDYKEHBXPXv55rP3DlvC+7jfFx7dLVtmHAqR4vyhQHgOeEBRubqZZw/8TDQgZVjTLm5y3Dyk2FRcl3ORdkRQ5bK/vtg2EY7jgSGb93rsby5QZx6OULRx/Mexj3+OF0NbVgTRGyocY2VTPFUHwixfu3+z5usKXm2mu/P65ERRiiMVet1+CcV6pxOfJHwFo2DQqL1EewxffuB8rK2YqaXMAgpMSpk5ckMQhbadtVfX7AOEF3h/Jzzz8Y27uGr6mSBYyqC/Qd/46nfQwrQmHrp41l8FXmnf00iG2nlTBz0XkaETNzQNAIdtcRBSPwB7QMyY0mGISgF06g+aoDBgyrl3RpXRUJcxQyxaighqiEP2+3OcuVAeBVRHd6q0EEaO5ox/rdPZrEuV0sqMtrRr99vBYjH/OhIO8IxFjxVyl7eCHkZgG+IFob5gJolmxoIQPnZ8uNOI0tG8usarWlWID6h5c9IOuY7F4ioibAeBId3cRtUqbuDkKuLnhAPzClhfWORVFvRM5lJStB3KmVI9O0jpehCiKLIaYwESe9qSbPyk+Evb1JCIhWevP8DghK8C1cTQzwONBupL03XigFeLcqOjqmj/azHhXFPyXoxhIpeNRcM3tZ4Czgc/S/+2P9jYlUiqXzUzY4l9Z3USZ7haw4EJHfLXDVKgBEjtoeulp3qHTIuS6RZBa582q/mW4lNd41NI1m5EThQFgmkduYRNPbwMavYNJW4sd/aBjd+J/JInccLqLZOo8nFfwrlNqFUuGHS/apYY4Sz8yIFEDm381qELb10ndJSzR7R3f9XAYWjZMyXMGmzPu/TZO3HtvWwfG7HHYeVdGhWdFaIDuBVFl+tjGeJFFokzgXskv70hABu5siANHJcqdq7QQoilSXzFQFt6u4BrEBggrngzJLvC92k6RkrDGVZvi/RgFGwmczNHpH
 btYfmPE2
 I+YmWxVYch1KpIvIjMmHgm+w9cUjTOV8G+PiG7skLl/+/6Kb4I347IDLcCkTzyCdzwEM8K6rmL2z6B1mj8HeTE+qZxYy9Ll1rEgUzXtrOS9t7MZxv96DkY1uCSNHQU1aXbeoWaxpgw7TbyGQwPYtMDi+RjXTeWC4u4KXSJkhjzJKz8BmjFlT+igxITHkuosu6BoDgdgfUBsnNXS3627nnZxkkOoQ+MZy25nnoiVQZXt82exQP8ARIPvKfD59RQFqvijmEZdvdrcqcNf//1JOdhHjVl51COuV3Q9rsjjpxECFTKGBSJV7MjoBoQ9zvduBeMi86zH6wI2xNAUTqpcFitwZIGQlgH67h0pyspmpwsVtLy8je8tZSdPPiYu4Slo7OXQKRfro93CROwmLUA8D6byICfCdDI8vMgI3T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:32, Christian Brauner wrote:
> Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
> device nodes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/configfs/mount.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> index d8cac1cbf3bd..60ba24e7ae2b 100644
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/mount.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> @@ -106,6 +107,7 @@ static const struct fs_context_operations configfs_context_ops = {
>  
>  static int configfs_init_fs_context(struct fs_context *fc)
>  {
> +	fc_init_pseudo(fc);
>  	fc->ops = &configfs_context_ops;
>  	return 0;
>  }
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

