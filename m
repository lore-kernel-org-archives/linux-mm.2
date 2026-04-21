Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7EFF8FA90
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 15:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03996B0088; Tue, 21 Apr 2026 11:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB40B6B0089; Tue, 21 Apr 2026 11:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4356B008C; Tue, 21 Apr 2026 11:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85EB36B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:37:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C2825E292
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:37:31 +0000 (UTC)
X-FDA: 84682967502.24.D002F37
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA7D340010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:37:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Gw+ND6w8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8Ui9Z02f;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Gw+ND6w8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8Ui9Z02f;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776785849; a=rsa-sha256;
	cv=none;
	b=jGlO7jjV3NMri7PixPnfsjuRVmf4Z8vuua9m9UZZypk/93m5XYiE8J5wiqc1bfdFnL6z4X
	ebKZMLceOy0GqmeNkZHJEh6gUIQzu+U1rauOIG5ypfWxUk0bEz3aFE1ySTiiFPy3Ccgnmn
	Xw7BfcSViijjKkhz2ElEyEpdRGE8/Yg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Gw+ND6w8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8Ui9Z02f;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Gw+ND6w8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8Ui9Z02f;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776785849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uw6IqRgEY+vfODXlHN+dJEEHwH2Tp0tErQxt88DIksk=;
	b=NRRNx1l4UwgRQWRStZajfTeWLepMD5MGJ8LkaFMMpMTEqqPNNBr2EBnOnq0nopXJ4vqfcc
	rpHquYWmpAEotkOXT5dVbEMvELZ7CdfiWJ01HT6AhzfjsPPoNV7si+uR090EQNuYUXYc4P
	wQA+nQOie2HUjtHhgV+m5Q57Xn2mb6g=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 218146A802;
	Tue, 21 Apr 2026 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776785847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uw6IqRgEY+vfODXlHN+dJEEHwH2Tp0tErQxt88DIksk=;
	b=Gw+ND6w8gPbPHzST4PKoNQC+2YuZUQJtnTjkvOMqRdTnOFpMqZdkRrtjy3tA2d1EFJbwgm
	ocC2SMaZqAXcAFDwm0VAEb55FQ5lO2EA4GgkQIrs8ZqZyd0xDWXTqaqOBlx/RPLQWy6xCf
	DN8ZrstU1pgrYfYjWDgrTstVxHIirKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776785847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uw6IqRgEY+vfODXlHN+dJEEHwH2Tp0tErQxt88DIksk=;
	b=8Ui9Z02fzXv6Zg3rbtQ4Cd7jnOMKlzqH/EH27AsbLYw9La9F6+Y1DvzY4tAtCrcKQ209h9
	pYZd1+PQvfKDshCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776785847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uw6IqRgEY+vfODXlHN+dJEEHwH2Tp0tErQxt88DIksk=;
	b=Gw+ND6w8gPbPHzST4PKoNQC+2YuZUQJtnTjkvOMqRdTnOFpMqZdkRrtjy3tA2d1EFJbwgm
	ocC2SMaZqAXcAFDwm0VAEb55FQ5lO2EA4GgkQIrs8ZqZyd0xDWXTqaqOBlx/RPLQWy6xCf
	DN8ZrstU1pgrYfYjWDgrTstVxHIirKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776785847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uw6IqRgEY+vfODXlHN+dJEEHwH2Tp0tErQxt88DIksk=;
	b=8Ui9Z02fzXv6Zg3rbtQ4Cd7jnOMKlzqH/EH27AsbLYw9La9F6+Y1DvzY4tAtCrcKQ209h9
	pYZd1+PQvfKDshCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63744593AF;
	Tue, 21 Apr 2026 15:37:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uldnE7aZ52lRDwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 21 Apr 2026 15:37:26 +0000
Date: Tue, 21 Apr 2026 16:37:24 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Yibin Liu <liuyibin@hygon.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, mjguzik@gmail.com, wujianyong@hygon.cn, 
	huangsj@hygon.cn, zhongyuan@hygon.cn
Subject: Re: [PATCH] mm: Add RWH_RMAP_EXCLUDE flag to exclude files from rmap
 sharing
Message-ID: <rbc5ezm4uuzbcfaah6w6em6ndfbhamiug5jmp6srovqsx7u2zv@nvyvigon4hcw>
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421020932.3212532-1-liuyibin@hygon.cn>
X-Rspamd-Queue-Id: CA7D340010
X-Stat-Signature: t97shwwkbxaoqibbhx6tzehdycsk5wk5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776785848-209806
X-HE-Meta: U2FsdGVkX1+YKpQa+dUnmMJJFuSDZXcsoBiRg4Dku/+KmVR1MD+WQKh//a9nHsXnxIzobNnvbGZqNDXcekDfTZMs9LyTWm4Ax3YnTeHg/3IARbXzMXsiMynBLN7DaeAlgmC97Bj0PP5ZsDo8w7Mery2bPy19DaE9OtSqqLFbs6rZMDq8pAgEnBBYMV6io+kASs+aFnmmvFuuV618+LAL+jkc+s3Le1kgJfhCxP/ckQ21stIQpYmaXpeC1SjBxSX8A+cQPKEuy2+6bwO0ukwTe/ltLsAHWpazYEW0IzqzezKkWRR2cxgkFJ5UzHCGCDMp2qWWlT5J8u5ODXxNALQSPPFV3FvCoAFhsnVT5cqSk6I+N05kZpl7ppFF1bUIZxXCjWxzPlPgSypRk3+CNLxUun2L10PjRnQqPvHyaLnWp76OICuYNPeJGRZEm+Kf4BmOC83qzN9aBaB92hfcbBR0OOy1IYiPn+diCX0KrtxJlNES7fY0cLeHkyY7GbApY+LjeG+a8/kD9/ueHqx0+jneikz/ovHSYCzTgd5VBwhzNhto5HEDS1jpvt12JaQQcQz+a/wx8/pTGY3Q2moCWdnLAZOCwIbWtuFOhsHRz8sq4Wc1Ubh3T9Ppl/iADXbSe7gFa/uxHiQkhS2GBgKbLBF+tsLRlUcD637fRBfbBaIobRWKDVUaLjZkjM3jRNSnsXCp4ehnDHLbz7fxYsFFMuUM219lANt8SBxjIKnrqlP0iCWEsqjZFtvp3sa71cRZhYq0+sRvn+OdXKGmYxpQQhxX5Mw1S2NkDNLmzJ4PUaG5Nl5iJRs0fDQH1mpwhftpmaRMuCIHtWQ0w8bsX1avQDXWO6CWuYgZyQtkgnEO7ez88jyaIjLuBBFUrdOIaBuwha9gwzHjE35kf6CxNn36aLEjkgf/2/YQH/Ui/xe2dxRhAzITlZq57pJiaIW3BnMBhDpU51vXJOFNwuEhZ7exc9i
 NNZIntfR
 Niv/tEgkME/vRrmV/lXaYURg+cO6Rh2Nz6S7uh8p7nBdRY9VXe3PxC/LG1bh0mJzwdr0eNCp8hs8PcM/nynWwdHlbKK5w7EpLodObHwN/E1XNiTuRmUhaGTZDQ148NyCskt2UP4ok8bp3H2HG07CCWuS6KKo5Tml0i3cDT8IxVHML7ibwZpMv3QdTgGlsKLzDq9XKd7R4kBv7qurGLNk73LvIoGjPXSor9pbLW14QMFF/o8l8JQY05CPF02erUdk9yA98x6R25sprfT3frkhpHsKHWOP2WlJTV9U5O+hckpE5lfmGYJLFU32uFL0d56tMnRIwzawjkbjqAMT2rYy+WdzfN5Mke6Hkhcce
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm not sure how you're using get_maintainer.pl, but PLEASE CC people
correctly.

On Tue, Apr 21, 2026 at 10:09:32AM +0800, Yibin Liu wrote:
> UnixBench execl/shellscript (dynamically linked binaries) at 64+ cores are
> bottlenecked on the i_mmap_rwsem semaphore due to heavy vma insert/remove
> operations on the i_mmap tree, where libc.so.6 is the most frequent,
> followed by ld-linux-x86-64.so.2 and the test executable itself.
> 
> This patch marks such files to skip rmap operations, avoiding frequent
> interval tree insert/remove that cause i_mmap_rwsem lock contention.
> The downside is these files can no longer be reclaimed (along with compact

This does not work.

> and ksm), but since they are small and resident anyway, it's acceptable.

Which ones? ELF executables commonly have a lot of padding. How do you know
what to mark as !no_rmap? Who has permissions for that? This patch allows
any user to create a full DoS of the system by simply marking a really large
file as no-reclaim.

> When all mapping processes exit, files can still be reclaimed normally.
> 
> Performance testing shows ~80% improvement in UnixBench execl/shellscript
> scores on Hygon 7490, AMD zen4 9754 and Intel emerald rapids platform.
> 
> Signed-off-by: Yibin Liu <liuyibin@hygon.cn>
> ---
>  fs/fcntl.c                 | 1 +
>  fs/open.c                  | 6 ++++++
>  include/linux/fs.h         | 3 +++
>  include/uapi/linux/fcntl.h | 1 +
>  mm/mmap.c                  | 3 ++-
>  mm/vma.c                   | 8 +++++---
>  6 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index beab8080badf..9b7cc1544735 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -349,6 +349,7 @@ static bool rw_hint_valid(u64 hint)
>  	case RWH_WRITE_LIFE_MEDIUM:
>  	case RWH_WRITE_LIFE_LONG:
>  	case RWH_WRITE_LIFE_EXTREME:
> +	case RWH_RMAP_EXCLUDE:
>  		return true;
>  	default:
>  		return false;
> diff --git a/fs/open.c b/fs/open.c
> index 681d405bc61e..643ab7c6b461 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -46,6 +46,10 @@ int do_truncate(struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (length < 0)
>  		return -EINVAL;
>  
> +	/* Prevent truncate on files marked as RMAP_EXCLUDE (e.g., libc, ld.so) */
> +	if (filp && (filp->f_mode & FMODE_RMAP_EXCLUDE))
> +		return -EPERM;
> +
>  	newattrs.ia_size = length;
>  	newattrs.ia_valid = ATTR_SIZE | time_attrs;
>  	if (filp) {
> @@ -892,6 +896,8 @@ static int do_dentry_open(struct file *f,
>  	path_get(&f->f_path);
>  	f->f_inode = inode;
>  	f->f_mapping = inode->i_mapping;
> +	if (inode->i_write_hint == RWH_RMAP_EXCLUDE)
> +		f->f_mode |= FMODE_RMAP_EXCLUDE;
>  	f->f_wb_err = filemap_sample_wb_err(f->f_mapping);
>  	f->f_sb_err = file_sample_sb_err(f);
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 11559c513dfb..d5c9e5a4c2b9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -189,6 +189,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  /* File does not contribute to nr_files count */
>  #define FMODE_NOACCOUNT		((__force fmode_t)(1 << 29))
>  
> +/* File should exclude vma from rmap interval tree */
> +#define FMODE_RMAP_EXCLUDE	((__force fmode_t)(1 << 30))
> +
>  /*
>   * The two FMODE_NONOTIFY* define which fsnotify events should not be generated
>   * for an open file. These are the possible values of
> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index aadfbf6e0cb3..4969b4762071 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -72,6 +72,7 @@
>  #define RWH_WRITE_LIFE_MEDIUM	3
>  #define RWH_WRITE_LIFE_LONG	4
>  #define RWH_WRITE_LIFE_EXTREME	5
> +#define RWH_RMAP_EXCLUDE	6

Userspace does not know what "rmap" is, nor does it need to know. Even if you
found a workable solution for the permission side, this is not a good solution,
and it's not a good interface. It also might solve it for you, but definitely
does not solve the whole issue with having a lock there (which you are, for
the record, still acquiring).

-- 
Pedro

