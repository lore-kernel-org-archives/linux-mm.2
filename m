Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991FDCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 16:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00CB8E000C; Wed, 24 Sep 2025 12:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1778E0001; Wed, 24 Sep 2025 12:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6ED8E000C; Wed, 24 Sep 2025 12:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB9828E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:56:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81ACB4398F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:56:47 +0000 (UTC)
X-FDA: 83924748054.25.1A930FA
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E811120013
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:56:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=infradead.org header.s=zeniv-20220401 header.b=ADQuNtgD;
	spf=none (imf29.hostedemail.com: domain of jlbec@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=jlbec@ftp.linux.org.uk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758733005;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wItarYwJVipfmi89AjibX164xiYQ1sw1xgqIMHATn9c=;
	b=t3IMKLl9W7LG2XsmzQ0Zzdkta1P6hhcR09vJpF+F/gkdTipy/iJYG18jm6I2/InByb3Syp
	Wq4UqM3ybnxcuOZaefEmU0IT2eOZksIT4RKPK+qMwfIH/B0wplTVMYWRBzoti4UX1XGeza
	wC04xiYeUBZatfzxSIln5j6RkoGB/Xo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=infradead.org header.s=zeniv-20220401 header.b=ADQuNtgD;
	spf=none (imf29.hostedemail.com: domain of jlbec@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=jlbec@ftp.linux.org.uk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758733005; a=rsa-sha256;
	cv=none;
	b=GDVBL1+qtVUgl/3NgQ6XNxrmTJkYfM5XplmsCjHk/GQvgyrgkYtEK6wmyYqq+T68xTQSr+
	lAt366EW0o3dkKvDT5P/h0cXxgXo8VVwmTpGnbryNh+UBtIjF/K3GTdCgzwhut1l6W9u4Q
	bMSh/DJDlUWhb4A9NH/ITbSX8ek36lI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wItarYwJVipfmi89AjibX164xiYQ1sw1xgqIMHATn9c=; b=ADQuNtgDqCh42nShQdrRdwoDNL
	naHjDqhRxe/feBE3gx7YI+GF3SiATwjEKGTxF5HTe/Rd8zeJIPmiziHcLoJCArwg1LMjkST8yjMX2
	ICMQXn/VCEHj9XYcI5uyQ+z2vU1vDXRjgolv9kx1bsRE24R9kbKPxdEuZwyofsQb1h+8kmqDxmSvE
	RFGVyb/ITBh0FNHHuxEIh9mQxZOJejY+vTU5rnl3xDxkQaIqjkZC/dq692Uo/WRCE5uDVByN675eh
	qEjeBUgMKKK9qemuFENVjEtRnyWVd9FbPVfb+wYmBC8z4RcHVsS9yZrtq+r6BEE1D0owQ3AOE/asm
	tCqspHew==;
Received: from jlbec by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v1SnC-00000008hCv-35Ks;
	Wed, 24 Sep 2025 16:56:34 +0000
Date: Wed, 24 Sep 2025 09:56:30 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	borntraeger@linux.ibm.com
Subject: Re: [PATCH 08/39] configfs, securityfs: kill_litter_super() not
 needed
Message-ID: <aNQivg5O_Rx3WxlG@google.com>
Mail-Followup-To: Al Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	borntraeger@linux.ibm.com
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-8-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920074759.3564072-8-viro@zeniv.linux.org.uk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E811120013
X-Stat-Signature: ckbxquytt9h9h5gzn8tspumkoc8irpgs
X-HE-Tag: 1758733003-678845
X-HE-Meta: U2FsdGVkX18j41ao2KZ517NVqoKZ/Z8de/GswXR/sBZRzF+3PUub2mLsHtoqRcpqBxMc8TN56bXovJhsXkyHlSRgkGNQO10gKFAU1TSd6rSl5hAfTE2Ex3LG25+iJLWeqJZOufXEZq+qQDLh4s5aXaJM29Rz8pHl9FmZOM3S6myd196NfERV5iox/rvxx7mTlBBDVmZvyLXqPMIF7RLa8fctp7WUOoGSCNwUT+nuMufK9xJA48JvZFb9rGwXLTXb/69BUdu3PW4iA+AFIkCFbj4QYGp9sxiWfQvIGfSlhpVyQrcJJUwrAiAoped0L7Z6+Vp6j9FQrixFZYKVSG+r3Gx5DEUZuL22ahBeiwy5Vat4iQg0SV0opLXpyWvNp0SqX7z+uRVDKgriGZYAAzK1mOO8UfCjHgOJf9ahCPfeiOk4kzmz4g2OQRuGtwXPEkXbeyvJnH7kQcdBqAzwAjKiOrrIooaxdloKrgIpQ2JHEqjvGgYoeIvrkRIWm66S9mprC4qbFIVCJH+576OkCY97KR9KCUFwihLrFkgAH8/baX6NjV+W9b3RRz6OMvOea704gJeWaligt59AQ+sbonyt6iS5gQY1QH7UAJ4fCMbhggdolq0Q6tinMxtiypH8Bdfm7gd5y59+AuKBhOwY3WBQpjFVuLqC2iGFLGvlCpQJKsydZNTS4wvBJEd7EbdDbEdW4iN2O6Rro5nK0yVjad4MRrWuzKkslggASvSAk1Q4ZdI+k4eQKTN/ibj7SEnaJObdykWCvdPiutdgdRpY74Zup/UeinSv847wsaKxg0d7Jp13u6t0ko4OHV6c+CmK2ACIG8AZG0HnwH52GNCHZvPcDcpHabMEtdjUElOwR5GmDwIJU569OyxH4cOy6Uq95m1E2VyN4pIo6hiI9yzhnTXKL+T/hswiDm2TMg/uOgDXdsfS/Fh7u8juEoosUu8W2pk0UlOgpI/CK1idoQHReva
 KTYek8EW
 aygHod9xT1pQIYzjqXXAC+7KySP4jP+s2TisKypJv1YCFY9r95kzZGfoXFg52trP+EuaVr3cQKin7JoUuBT6g0SwU/YUvWmOyYQelYq838iVNYwLslDdSkIBerzMcKKIsTMZdNuKWxQOfocXfZq98HKJirCwBEMwRplUvOA2vQPxRlex1+dj025lyeXysen38LJeRRPUbSEQ8+/BvixDVPNezg2eNvp89s7ORsFyyUwTOAdrGk16MrYgTtU5p63+ANhYlDjqB06oOrydKCA1g5SHOj/rzaxglu6qluwnU7HYiki/1CVRGFrVjXf32nZscJvUKPH2j1QLzoCJa8LXS0zs02MvWK0SBEWPzIjQLEyV40w0AqsvcGQzmuoRXvUti18vN/hVpD+PwpVipBU1oY4Cv2YUaJSXGMcHYxs+reUIxU3BfrP+SEM7e+LnTjNSF7WUVzMHSxOhfRJMGU/eXZdwxydpcQ/NqFwaWkTmWKxw+dbSUh+alls/HX9UWZGL1gN9metbnsqDinPyImYIdsrzWsIKeyrJcgR4O6rDShTboxpc+haPYp/owqMrLQGHYfa54+Xz0vFaPAa2LVQ5b+LlugpPfsGorYk6m2fa7tKwmL2OzjdKwtnznlcYQKu/EZhP1VT1icbNpdOiGuEK2uCFOBUli8AJjrHoZV1fBIyNmZGXoNnKLEMs3inK1sjHXpjnl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Joel Becker <jlbec@evilplan.org>

On Sat, Sep 20, 2025 at 08:47:27AM +0100, Al Viro wrote:
> These are guaranteed to be empty by the time they are shut down;
> both are single-instance and there is an internal mount maintained
> for as long as there is any contents.
> 
> Both have that internal mount pinned by every object in root.
> 
> In other words, kill_litter_super() boils down to kill_anon_super()
> for those.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/configfs/mount.c | 2 +-
>  security/inode.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> index 740f18b60c9d..fa66e25f0d75 100644
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c
> @@ -116,7 +116,7 @@ static struct file_system_type configfs_fs_type = {
>  	.owner		= THIS_MODULE,
>  	.name		= "configfs",
>  	.init_fs_context = configfs_init_fs_context,
> -	.kill_sb	= kill_litter_super,
> +	.kill_sb	= kill_anon_super,
>  };
>  MODULE_ALIAS_FS("configfs");
>  
> diff --git a/security/inode.c b/security/inode.c
> index 43382ef8896e..bf7b5e2e6955 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -70,7 +70,7 @@ static struct file_system_type fs_type = {
>  	.owner =	THIS_MODULE,
>  	.name =		"securityfs",
>  	.init_fs_context = securityfs_init_fs_context,
> -	.kill_sb =	kill_litter_super,
> +	.kill_sb =	kill_anon_super,
>  };
>  
>  /**
> -- 
> 2.47.3
> 
> 

-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

			http://www.jlbec.org/
			jlbec@evilplan.org

