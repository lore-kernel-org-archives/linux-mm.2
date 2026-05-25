Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5497DCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC34F6B0093; Mon, 25 May 2026 12:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9AE26B0095; Mon, 25 May 2026 12:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0B66B0096; Mon, 25 May 2026 12:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98AC66B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:22:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52F2CA015D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:22:52 +0000 (UTC)
X-FDA: 84806460984.14.9CEA8D0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3137F40009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:22:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CROIlxN3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1pampqlv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="n/kIQAQb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yxxr3rsI;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779726170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0Rj6kZ0NZp1iUbs/A+rai1k6L44nNzXx4GMbHIbDpA=;
	b=MtKDs1NhwNoqBButo20rPkt2tYS8pMWsFHogWiIRJGjjnPtowmq2VT4ei3Kzn3KI+xn1+7
	ml+r8eg18pTWu+atWNVIZpFk/6mEsRMiTmkx5Ad8gjTDxvT0mhFnoGYH+cC59Ef90ateu8
	pIas8QZYC3uMRGEsz/lB04Kn5xoer6E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CROIlxN3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1pampqlv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="n/kIQAQb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yxxr3rsI;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779726170; a=rsa-sha256;
	cv=none;
	b=ytAKkKieeYEX/9NXil7DtZafaQ8LNd5Cs7D0Gow8dRrKSi/3LkjEdyb3je/1QfqlPGJJLT
	e7jvOsoGz1PjAS6xsOzdu0HMl0cO4pZTmvI8E5VYu6KZg45/kGcbfDqWmIj6/0B3B0O/5I
	n9JQ76VjFDDsTzriSKUP+3qbbRe/aG4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D6DBF759A8;
	Mon, 25 May 2026 16:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779726169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y0Rj6kZ0NZp1iUbs/A+rai1k6L44nNzXx4GMbHIbDpA=;
	b=CROIlxN3F0ObxWV/Iu/DxbyYO8fY1G/KsbUQjVbUZ7jNjGxq/axpM7Z6Hcrtp0J5kV95Os
	s69vQZu0pt0DWi79fEOAdoCyhdBxJrCrAru4VLMg0W8zEW/VGD6sRRpF41f3LIIGCX+b2A
	ELy2pw2Vs565hQN3S+A9+ISHXhrD26w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779726169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y0Rj6kZ0NZp1iUbs/A+rai1k6L44nNzXx4GMbHIbDpA=;
	b=1pampqlvhhCCMiFlEH4DgYdzfRSqFspW6orJv0PlK7a01gd8kl9Y1TDHGUZtqq7nL38yIC
	sqboCRZsUszSljBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779726167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y0Rj6kZ0NZp1iUbs/A+rai1k6L44nNzXx4GMbHIbDpA=;
	b=n/kIQAQbetBxxKWKB6ItGTA0HFXd4tac5/pOy5zzMmzts1tG/O6nlR6NxXk+nKchzZBjKk
	DMcMEzICYp0yyTtMb6X2ILX9D2jmehiUtkPCcd5+gsU4SgHzQz8y569zfIGMaZG+gu4DEK
	xTg9i/K/4IVCEWmy5UnZ72gXoIt+XHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779726167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y0Rj6kZ0NZp1iUbs/A+rai1k6L44nNzXx4GMbHIbDpA=;
	b=Yxxr3rsICOcg2IPAVwcgOH6KiMXLNJ6HUNyaDsFuA+/t13Z8MXxQPya+c8hsgablBldfKt
	dmDltR06SSFbbyCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C977559D2A;
	Mon, 25 May 2026 16:22:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z8orMVZ3FGpbJAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:22:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DCB17A08D7; Mon, 25 May 2026 18:22:45 +0200 (CEST)
Date: Mon, 25 May 2026 18:22:45 +0200
From: Jan Kara <jack@suse.cz>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 15/17] configfs: replace __get_free_pages() with kzalloc()
Message-ID: <cnxlypiisnshulqluro2maw5vjnmmkbnvbkflfld3cv6j4m2zl@z3kwuj5nxx2u>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-15-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-15-275e36a83f0e@kernel.org>
X-Rspamd-Queue-Id: 3137F40009
X-Stat-Signature: isx3osi5fsjabfchxacbmemfsqim4tkg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779726170-777522
X-HE-Meta: U2FsdGVkX19hJfVDki7SVGlhunTgtT+m8N/feaY8bGRUGyb+FzCN6arX3N0idg1TRnerkL4XwmUV5FM1nG4cdTkvzC5QuRWPQA20oWwRWh/knaqRTiPnukOX48Z0ep1z5X5xHINZCIRvIVdg6+lNwb7tGiXD9nfwh02CuCIqun1P+QB5sCO9dhBAzHdTUt6cGvGD4cMgbkiGxP77UmtJk32j60rVp/EoYZQ9PGUoE/sWIfDb5KeArX9PiYd30xt2xqaAIhDp9U1KEU6ggOQnYDaw8BIaFvWfi366sF0y+B43kXCCcTOqGa5jy35m5xqdWmmHR9890A2ujTs8VWPsOijg2mujpoqaFHJYBzu9N1BEfGw7oNOS/ieQmJoLPhfjvPRLrVef8WY0CFGZVpW+Ur8Rv6wDcSPSKmW2sWJmnrnvwoivysQucoqi11FxUF/dD46WDdGOIrZJaNeoJSsKFcFXnOeABZO59bkQ6ga8uzodKmrS6ehbxUixSANgDJffIy28y7TMHYpvi/5nYSiWR3T9wb6yl/6rBGiBCQ3OOIqd3Pm1xq+4dyS8I50WP2C1RQpwyF2lQo9C405KTbVEztCg2aRePuSxM0XObJAyNSF3vAmpR44dx85YBpPPOqNCxvHPBQiyacc7IXpB82yRCericoymN48Wkd48G41lfmE4D4oaL+odSfakOds2XJ2PDZ5zTIsPKPo/6jcMgb58l1HHuu2KvBVA/qbK/o8RcWqCeV9sQGnba9ow3x23WfpHe40YVcxVLMk8p6i7+tsynzBr4uZxq2PxXxfukDGMqan8LpgwJ+Zv3yVFeybgAmQRpa4NaHsh6elRjXVff/GeGM9DRQL1/Hjc5XDEwZrTo/UbuZvlzizHH/ZJZD87QkjlOVDKGrp3Bhth3QkfxOvRDj0KNJQHdm0V/BMoirq4qn0aNFJHe7cMIvA8nta1TgeUEIFWJ24O/7T2j/5o+nE
 TChTvv8V
 wggth9mYuUUWL+n9OMW3v8jLc016pINdhCaQOBXrRIUtjfMkb4IOlvnaXnR860tZAbScALy8l2nj498VmZndFxaoxwSIvm5PvLR/Tt08+eoxb3QEzyUdgsnpjNdr9FrfFPJLTibVtGR8DjH7wQDxqO2aQ4R3I8ZFH457Lf07dm4f9y+kn1oc0zrR+4OANmszyt0HfWfdzdq2+xpo3rq0Dtsm/iF/DDmUh/73UD/kzc3i7mBWdeDWLJDPODiEVl/2hOS9x/HsoxxG6ez132uUCA9vn/a0ExH5zsINYrthh6dMZmq8HLDCqiTtJ9TfPkieJ399K9cy4lr9EBhYv93jdvudIDtKlB0jNZUW9tLuqTIPXCXtijjwmputIPgIrFvhJLfZgMy0xJNiWCZcH/3zArV44xaYF2CnHFzjXJ4/yAL9O/dSMFxC4Fl+wz4FS+Wfhyi6xhoAGilNBwNJz+ywjonLRu6LaY+Y4JVo8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 23-05-26 20:54:27, Mike Rapoport (Microsoft) wrote:
> configfs allocates staging buffers __get_free_pages().
> 
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_pages() with kzalloc().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/configfs/file.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/configfs/file.c b/fs/configfs/file.c
> index ef8c3cd10cc6..a48cece775a3 100644
> --- a/fs/configfs/file.c
> +++ b/fs/configfs/file.c
> @@ -59,7 +59,7 @@ static int fill_read_buffer(struct file *file, struct configfs_buffer *buffer)
>  	ssize_t count = -ENOENT;
>  
>  	if (!buffer->page)
> -		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
> +		buffer->page = kzalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!buffer->page)
>  		return -ENOMEM;
>  
> @@ -184,7 +184,7 @@ static int fill_write_buffer(struct configfs_buffer *buffer,
>  	int copied;
>  
>  	if (!buffer->page)
> -		buffer->page = (char *)__get_free_pages(GFP_KERNEL, 0);
> +		buffer->page = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!buffer->page)
>  		return -ENOMEM;
>  
> @@ -381,8 +381,7 @@ static int configfs_release(struct inode *inode, struct file *filp)
>  	struct configfs_buffer *buffer = filp->private_data;
>  
>  	module_put(buffer->owner);
> -	if (buffer->page)
> -		free_page((unsigned long)buffer->page);
> +	kfree(buffer->page);
>  	mutex_destroy(&buffer->mutex);
>  	kfree(buffer);
>  	return 0;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

