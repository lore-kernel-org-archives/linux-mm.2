Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48DC8606BFE4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WWtetnZD;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yu1DhDEP;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WWtetnZD;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yu1DhDEP
Received: by kanga.kvack.org (Postfix)
	id 6FB636B05DC; Tue, 10 Nov 2026 08:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC556B05DD; Tue, 10 Nov 2026 08:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B026B05DE; Tue, 10 Nov 2026 08:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 331846B05DC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:02:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BACDEA861C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:02:56 +0000 (UTC)
X-FDA: 85419224352.19.8B2C81C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 869294000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:02:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WWtetnZD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yu1DhDEP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WWtetnZD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yu1DhDEP;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USDR2iE5M2UEpaP+1GfJYI3TDuWZn3GdzCTDZovKwBI=;
	b=aprVIlv/FzIQ3aTSHlH+JbGX2km0qRqDll/V19pikut8gsE9+xKhL65J97r9b5XYC2uPK/
	OVRzT1dWZBLIpFYMm9fJSdbJJEptbvyaJV243esAH5Ue4sRwUh2tRrpdEHHXFSH2WaU+bZ
	RbUvoImSBA84IWylDnnOxPlDt6zRnFs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WWtetnZD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yu1DhDEP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WWtetnZD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yu1DhDEP;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315774;
	b=oYJXERC9wkFog16RUIFlFB1KiDhTeoPW7twUwgZvCcqngGDLI2REPodMtNioXHSC56KWrp
	ZIJ3wRNoS6ZerqWpBaVzAIucLvJ1NvGnHscMebpc5UNlHIu1hhJpDhaWHztm9u1pcsnjpi
	aRr9gvkq5KtV+Pck28VTGr75Amtdhp0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4CBE01F461;
	Tue, 10 Nov 2026 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=USDR2iE5M2UEpaP+1GfJYI3TDuWZn3GdzCTDZovKwBI=;
	b=WWtetnZDdpY3CtAQ5P1ACc9FV+Q/S+5upWrfSvOHBVg/CDxzET4BPczhpbK/0nKTIvhIK1
	bJoSZBBd6xKzhenae5FUv3Cjcv6lVOt9c7qqlxsD1mkbGXiYDtk869K+0cd3OPJSH5NxR+
	UXFonm344KX222leLjP7xQc612byqXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315773;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=USDR2iE5M2UEpaP+1GfJYI3TDuWZn3GdzCTDZovKwBI=;
	b=yu1DhDEPEx3W2fYEUxbPsnXt4QMtwAIEJLkOMN58QZdMiOL9l/WrEOFLFJ9XB9CeUk/K09
	vhBCY/lPsE57BEAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=USDR2iE5M2UEpaP+1GfJYI3TDuWZn3GdzCTDZovKwBI=;
	b=WWtetnZDdpY3CtAQ5P1ACc9FV+Q/S+5upWrfSvOHBVg/CDxzET4BPczhpbK/0nKTIvhIK1
	bJoSZBBd6xKzhenae5FUv3Cjcv6lVOt9c7qqlxsD1mkbGXiYDtk869K+0cd3OPJSH5NxR+
	UXFonm344KX222leLjP7xQc612byqXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315773;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=USDR2iE5M2UEpaP+1GfJYI3TDuWZn3GdzCTDZovKwBI=;
	b=yu1DhDEPEx3W2fYEUxbPsnXt4QMtwAIEJLkOMN58QZdMiOL9l/WrEOFLFJ9XB9CeUk/K09
	vhBCY/lPsE57BEAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C287134F4;
	Tue, 10 Nov 2026 13:02:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Nyb9LPwV82qMSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:02:53 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7F6C6224F5; Tue, 10 Nov 2026 14:02:48 +0100 (CET)
Date: Tue, 10 Nov 2026 14:02:48 +0100
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
Subject: Re: [PATCH RFC 33/41] fs: add file_is_pseudo()
Message-ID: <xy7rgmmpufyq4ls4obs5te3y4mrzblqst7heachjo7rrkmvhot@x5kxqkbsw247>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
X-Spam-Score: -16.80
X-Spam-Level: 
X-Stat-Signature: ae1rc7xu41buuqs54cfdc6fatyzq6yyy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 869294000B
X-HE-Tag: 1794315774-962134
X-HE-Meta: U2FsdGVkX183DHdKQMH+esZHSsVseHKAl5tNJv90ZeF8Av00lx1x/lnVOHdBb7llxIsL5UyTjFOM59TIgFuLWUrEFa0FzazZBmmNHWq1cNXDbFpLKFZ6173FFWeF3UHRHSfs6EhfyLdKaKBKtI7Iz41TTUmJiAnibFo8BkJAhDJAq5OUbM5Eqj6NFenD6SJhr2ik89SSQGzdxI8C6+Sby94c47jRq94CyoA4DykAyQcubwufxVsHrcejQaensyenL5CCPunwgpWcBsexO2QjJ3svMuVa1eFY7HTZCdhf3uturP4azdbjkcX2qYKuo0x03jUxwlT06OAq9izUIZAV/MXVRykpDSJaks2WkDAmRZoAdWFqkVUZzBw8EV+6eoy/kBku1M+BGo8rklzD5fV90rCnUQ4/VhIQyCgXlwCHEpIG2TG4Ab2zmuj3YzJj52V30SdPBGpkKl3KYWG7eTYB+tfegGsGHg03vbHT79Zn6gv9JkEtJwPtOwZLriD/0Q8Rol/LlPmizpEt5H+9WRlIDfn5m13nFEy9jLWDVHOkL6j8+EBUl5b4zPn/XQ7yd7IEQHa0iHhYQfPWj29ZZdSq8RYIUrYsOLQ+BVlvLVjwilIM3mghap8vcXWWEXQhXcGlSonsTT0eR1wlzgLlgH9lVXzeq5WT1ZwmJ2ks/j3FvsgVvAirngOWhBh6TUfSJ5V61k2ds9xhWLb22RhXXA8M21MnONy4nbCOvY+fjs5jWRnST8ubUMMiN+ZbbPc3bvKktFrjlWRqanf5GSwk3XZI12DwaQqdNaPrtWhUFshUx+R53g8ZYeZMREiqUlwpxU1qZZBpRJ2ndt7aH2y7KDHxYeEEiEQgNh4pFvfd3NW9uUx6WiLsO7fmfXdSflh1al84AxaujMHr9GBDRBDdCh9KXbGfc5O6B1GYPZM2wj5ysy+YbH/LuNKjUAsO3yXTAip1Gq/KNuxGJUTMTH54ldh
 zrr+NiP0
 hz36wNNmDmlzAn/VS9KlSipWIAhdQKlz6VnR4+0/QcvXB4MTuFWiUzTNFJ9hxnNwQZqKH60JY5cCIOO+kpubVDo7k9/0cmBZmNGrI/pKHUzxD+QYjE4V425SzEVZ2exGELJCZ/+SYZF4jmUp/qgDW8Ut9Pu1SCvDB6865mBiDDix0x4rmkvMApxZSLeXNyzI30MkAfbs8CpcaPQpUEykk3WjS7vnMYD/BE64GtkpR0wrzm6uyoi5Uojm2Hquc6wpJaS3lpE2NKN599j8Mh4W5bmxmqg4LS9TUuM9zXmhVftc4QZPlMlLEqqhzg+udrHt8CQqgn/CrTE+u3KDNF4MeFJ6GKKQRUN8UnSAiIuI3nYmEvlyNIuHPkwQ1ogNp3em1v6/y5MlxUTAFiivRJlNUaL+NdeylhEQxuL3X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:49, Christian Brauner wrote:
> Add a helper to check whether a file is a regular file on a pseudo
> filesystem. Only regular files count. Device nodes on pseudo filesystems
> such as devpts, binderfs or the block devices on bdevfs are what they
> are.
> 
> Look at the inode that actually provides the data via d_real_inode().
> overlayfs accepts sysfs, cgroup2, debugfs, tracefs, configfs and
> securityfs as lower layers and reads of such an overlayfs file are
> served by the file on the pseudo filesystem. Checking the overlayfs
> inode would miss that.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/fs.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..407ffb6342ec 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,18 @@ static inline const struct inode *file_user_inode(const struct file *f)
>  	return file_inode(f);
>  }
>  
> +/*
> + * Regular files on pseudo filesystems are kernel interfaces and must not be
> + * used as storage. Look through stacking filesystems at the inode that
> + * provides the data.
> + */
> +static inline bool file_is_pseudo(const struct file *file)
> +{
> +	const struct inode *inode = d_real_inode(file->f_path.dentry);
> +
> +	return S_ISREG(inode->i_mode) && (inode->i_sb->s_iflags & SB_I_PSEUDO);
> +}
> +
>  static inline struct file *file_clone_open(struct file *file)
>  {
>  	return dentry_open(&file->f_path, file->f_flags, file->f_cred);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

