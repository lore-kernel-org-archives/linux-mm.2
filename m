Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED55606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z52LgjxR;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ySTWyVGk;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z52LgjxR;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ySTWyVGk
Received: by kanga.kvack.org (Postfix)
	id 338EF6B05B0; Mon,  9 Nov 2026 06:05:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA596B05B5; Mon,  9 Nov 2026 06:05:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B616B05BC; Mon,  9 Nov 2026 06:05:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE7366B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:05:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D1AB160635
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:05:27 +0000 (UTC)
X-FDA: 85415299494.18.8D9C79D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 17C8C40006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:05:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z52LgjxR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ySTWyVGk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z52LgjxR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ySTWyVGk;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794222325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWFtQ4TQ5CeU0nqdqMwSweeVRMq27o66vvOsG+uH2r8=;
	b=SJTWpwY+BflMSEgdKq4PE/dUq0JwAP3Q+M7yqEq9q+RKS0vip81LvCu0pApEIzTPU1JWhV
	ji1xvX8sCI/ZZL/SxiCXFgZkw3jgwr6UQsg0uMRondcNYPs5ds+xEegsMwaSKYKqRJ/9ra
	D0FrE/xxr2R+trWDGRuJEZo+HZhglZk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794222325;
	b=KW9qxtIGNvbjyhLL63twBnuEU4oj9SXEZXFZDdHCJckgYc9YITLJLCnHPQVdoxUXmAPirA
	ZJTRAqsSyIKmbgEO11EcvKT7/Jal9i4FkmgraDNVIB0q+3rFZbHDk0AFw/iQdW8r0tMMgZ
	71wuNcKfFqrmTA/o8sMWVum0k8GLU2g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z52LgjxR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ySTWyVGk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z52LgjxR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ySTWyVGk;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 987E521E11;
	Mon,  9 Nov 2026 11:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794222323; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWFtQ4TQ5CeU0nqdqMwSweeVRMq27o66vvOsG+uH2r8=;
	b=Z52LgjxRQ+uSgINi1sQ3a0lhgQX984kUJ/xNVi4kATxp2LTLk9LptokXOkzng5W/UK8l/p
	QXXQB/3yAKgAVdsIPYtSBFXa3NIpLAk/p6UfAnOx0I3Z/dfwFgjlfDu69gmnYPv6dkT3yj
	xry5syqXrhxoTSPbm/N2neJdlC6kdHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794222323;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWFtQ4TQ5CeU0nqdqMwSweeVRMq27o66vvOsG+uH2r8=;
	b=ySTWyVGkWKWnH5J0TWOAq41TS8WXavD8bRY5+XvZXAkm8X5+6PVpRiP/7frFWIVaZQDtA7
	DaIw5NNLnFpGEpAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794222323; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWFtQ4TQ5CeU0nqdqMwSweeVRMq27o66vvOsG+uH2r8=;
	b=Z52LgjxRQ+uSgINi1sQ3a0lhgQX984kUJ/xNVi4kATxp2LTLk9LptokXOkzng5W/UK8l/p
	QXXQB/3yAKgAVdsIPYtSBFXa3NIpLAk/p6UfAnOx0I3Z/dfwFgjlfDu69gmnYPv6dkT3yj
	xry5syqXrhxoTSPbm/N2neJdlC6kdHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794222323;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWFtQ4TQ5CeU0nqdqMwSweeVRMq27o66vvOsG+uH2r8=;
	b=ySTWyVGkWKWnH5J0TWOAq41TS8WXavD8bRY5+XvZXAkm8X5+6PVpRiP/7frFWIVaZQDtA7
	DaIw5NNLnFpGEpAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C4F313319;
	Mon,  9 Nov 2026 11:05:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ALyqEfOo8WrqDwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 11:05:23 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id EC4EE21EC1; Mon, 09 Nov 2026 12:05:18 +0100 (CET)
Date: Mon, 9 Nov 2026 12:05:18 +0100
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?TcOpdmVu?= Car <meven29@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	=?utf-8?B?TcOpdmVu?= Car <meven@kde.org>
Subject: Re: [RFC PATCH v2 1/3] fs: add filename_utimensat()
Message-ID: <35n54rrx6qq67j4fpxlvh67hal7zhmke2g5zcuhs5sbvxy22ez@nnnt4r4xng4r>
References: <20261104110604.126717-1-meven29@gmail.com>
 <20261104110604.126717-2-meven29@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261104110604.126717-2-meven29@gmail.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17C8C40006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n75ag75rkgxizkchhyrdbr7dbhy98het
X-Rspam-User: 
X-HE-Tag: 1794222324-891388
X-HE-Meta: U2FsdGVkX18ew370L+HqJhxABq/UrMlQXt6DSNhSSIGh3oOYsQOr4FaPopJ7xY3auwxMmv2TRfUN3nkVGP4ZJ0CTgbGtElotDPOq+8fOai/H9u7IyUT71mOcKhg+hd/QbA08gq51owMq/4aGRFyxYVLb/7uoUQuQycUqnsUa2KFZiQsWCfzjPW067xcajvzKoRApRZBnjO7hCuQsHsWlQaOk4i/jasUTMILO4szGP4PBsUabzCrnO/+DKNwPvS7Mo7847v+j0tLpwQo2ynezcPYHJ60kYcRDfxzkucaoqoMYX5oOG43GFqJnODDw+Y49vuHF2+x3sJTtcfQIOLzY4PtPGNsN8jBl0YMBMQr8E6h7bZsmesPlXC0OHRbYjwqK/opCil4989h9d6AaqB0NK9lmJO+zXTHHId4zoJHyFkL6BcG7vM2aNJ/IcBNGMvuwCPIy9fZhiUfjJ88hrOkJmx3vJhIE9ehXOp3n8LIUGO9OXgEGxf6kHfAhssWvDd4mkuRmwF2pSt8j+vCNh7NIvnWBe7naVTWiRWK3D4L+KdI8CqEZRAPm9TK5AIPyjw1AuF5j1miO+Ju7mkHQMqgV+G9/fKYv6dWqK6ISVLrcP5i4r8spUrFXBgN3TJJgKwn3tJ9YDRhe+GURrnCqrVi+SkpzDkBkDeEcHHRvOSArnRwSve7iorW/IAJ7XQfTeyzOAm6PdOzUxyIUhTp3onIO9Egby9yZfIFG0LziePz2Fn0HGZ7gxqHu3cF7yHzAuESx5vdRQwsFFbDTr/fMMayRgVHu8hNSJSXh9YKQXIXSVdZqM9HQN9C6h2Qk3/c2nrM6pTv/pbTILq0f3x9dDesCR9Q94qm7ad2ewJN1pTbUWTDnRXLLJ1+v/PYf8MTPQ8rJbePDrBQVdV243lqXcR5gz9WBDDpOEM2wKtuW1boCt4FbM/UOmlmQzu9+jQ+nKlNMG3fP7M7SoxB2cUFaphC
 MkzYDJvZ
 abFbCQqk0npzVcgPVE7+egbtUdcOLL4zirF9PNeNc7svi4QOFB36LhtybwWSIYrmhMDpJoL5jlXOhQN609+tYZR4rATVFGyL49LrJeBubZWk9cgXJNtmpD+2KknzDQdi+IWHz42RHG/Zkm1j54nvrt9ug5DU5GbXV1V2cgZlYQizXgR091FX28EcEdFM7/tfI495P0uWWWGZEaABrSEhmYED4eUYD7MzZtcXmN8f/oEwJkiJbwJnvPvrIPZe79RxZHdSxQinEweBWyBlrDNhPEMMTIKXh+bTFqUu7082LR407hgwS+Z3pDGr9b2aHmLBfRdZ0JtbhKeoe/FojciAGFtBbozaUoE8BhTMJClTi+k1cKrC1kZ1GovRpNTAFbcEQdvLJzS4t60r5xLCXAaUVFddq/jOQhcwlKFNlkSiiLEBnCwF7dDKKfptKUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 12:06:02, Méven Car wrote:
> From: Méven Car <meven@kde.org>
> 
> Copy utilities that preserve timestamps, like cp -p or a file manager,
> set the times of every copy after its last write. To do that through
> io_uring, the request needs the utimensat() lookup on a name that was
> imported at submission time.
> 
> io_uring takes the path of a request when it is submitted and looks it
> up later, from a worker thread. The path ops it already has call the
> filename_*() helpers of fs/namei.c with a struct filename. utimensat(2)
> had no such helper: do_utimes_path() took the user pointer and imported
> the name itself.
> 
> Split the lookup and the vfs_utimes() call out of do_utimes_path() into
> filename_utimensat(), declared in fs/internal.h next to the other
> filename_*() helpers. do_utimes_path() now only imports the name.
> 
> Signed-off-by: Méven Car <meven@kde.org>

Looks ok. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/internal.h |  2 ++
>  fs/utimes.c   | 12 +++++++++---
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index c658c8a5ebd5..985b2bc5895e 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -63,6 +63,8 @@ int filename_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int
>  int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
>  int filename_linkat(int olddfd, struct filename *old, int newdfd,
>  			struct filename *new, int flags);
> +int filename_utimensat(int dfd, struct filename *name,
> +		       struct timespec64 *times, int flags);
>  int vfs_tmpfile(struct mnt_idmap *idmap,
>  		const struct path *parentpath,
>  		struct file *file, umode_t mode);
> diff --git a/fs/utimes.c b/fs/utimes.c
> index e22664e4115f..8072f05ac8dc 100644
> --- a/fs/utimes.c
> +++ b/fs/utimes.c
> @@ -79,8 +79,8 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
>  }
>  EXPORT_SYMBOL_GPL(vfs_utimes);
>  
> -static int do_utimes_path(int dfd, const char __user *filename,
> -		struct timespec64 *times, int flags)
> +int filename_utimensat(int dfd, struct filename *name,
> +		       struct timespec64 *times, int flags)
>  {
>  	struct path path;
>  	int lookup_flags = 0, error;
> @@ -91,7 +91,6 @@ static int do_utimes_path(int dfd, const char __user *filename,
>  	if (!(flags & AT_SYMLINK_NOFOLLOW))
>  		lookup_flags |= LOOKUP_FOLLOW;
>  
> -	CLASS(filename_uflags, name)(filename, flags);
>  retry:
>  	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
>  	if (error)
> @@ -105,6 +104,13 @@ static int do_utimes_path(int dfd, const char __user *filename,
>  	return error;
>  }
>  
> +static int do_utimes_path(int dfd, const char __user *filename,
> +		struct timespec64 *times, int flags)
> +{
> +	CLASS(filename_uflags, name)(filename, flags);
> +	return filename_utimensat(dfd, name, times, flags);
> +}
> +
>  static int do_utimes_fd(int fd, struct timespec64 *times, int flags)
>  {
>  	if (flags)
> -- 
> 2.56.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

