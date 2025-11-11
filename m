Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65FBCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2DA8E0003; Tue, 11 Nov 2025 02:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0648E8E0002; Tue, 11 Nov 2025 02:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB9F8E0003; Tue, 11 Nov 2025 02:53:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D34EE8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:53:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 778074BB17
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:53:20 +0000 (UTC)
X-FDA: 84097560960.09.54B04AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C54B140006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:53:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GT1YKP0D;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762847598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSsXNui30CdY93HhnZ9iVbgXJUzgciOVZvR9PGs4bjM=;
	b=lFcigZlHeOHWzcHyYsBwBSqmo9E7mGX6Ue/Ahf3r2MLmDdg4qkaSGnE6A9wPiO5/xHXGEn
	72MQbuO6cO5AhwyXro7kakgse4Grt/MEoJq/xgF4Ll5naBhahbILFh5gudRjNMNYdkN9u6
	lX32KMvhXGFmuoOX03lyr3xmiDUP1QA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GT1YKP0D;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762847599; a=rsa-sha256;
	cv=none;
	b=f70zYzoyRYJ4Y1LyeuShhT4fWsoNMxQfj8v6tPtb/VFvSqxEv3kTclpUa3d8sS5AgBd7IH
	ryJAWdyDbPvOvhm1bAzFi4XFu2pd+1HvCjQT74PAJTO9YiW7+z8vAO5WlNDeX+0jxpB2Rc
	KLJDrnmayuEDQ3NA43GqHfRThOt78M4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE47418B4;
	Tue, 11 Nov 2025 07:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EFAC116D0;
	Tue, 11 Nov 2025 07:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762847597;
	bh=6vLdCVtUOmwT2xBG2CthgZi9Ig8JOsV5A1e4sciMj58=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=GT1YKP0Dqo8Ysx1f1jn1aJnzunt/m+vgmkHza86dvdju2EoOZI6rbkPd7I+ZcBeM+
	 sMRoB0c30MgD2v1Yb5EZikViuPNT9qU6D1zpwh1o3OD7j4ZzdXpPAIauOb57UMw4bv
	 I60wtyPt3IyQJygJ4dixY3dw68KJmjTTO1siXWRgIfdzeLxoIP8G2HrfqFcRWayLag
	 434bWzG4C5dIXX3cv0RlRRd1dhjWeDIx9KMPU1TowHWPucntp2dQsJT9/iu1QfqbYc
	 Y/H5S/PxMIu45+cpnJF56ZFcZiXa6QAttdqqbIZMPl+jb91U6hNFBKXExqdER7dwwx
	 ib+6wzq9EnUzA==
Content-Type: multipart/mixed; boundary="===============1014260008914052501=="
MIME-Version: 1.0
Message-Id: <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
In-Reply-To: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 36/50] functionfs: switch to simple_remove_by_name()
From: bot+bpf-ci@kernel.org
To: viro@zeniv.linux.org.uk,linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,brauner@kernel.org,jack@suse.cz,raven@themaw.net,miklos@szeredi.hu,neil@brown.name,a.hindborg@kernel.org,linux-mm@kvack.org,linux-efi@vger.kernel.org,ocfs2-devel@lists.linux.dev,kees@kernel.org,rostedt@goodmis.org,gregkh@linuxfoundation.org,linux-usb@vger.kernel.org,paul@paul-moore.com,casey@schaufler-ca.com,linuxppc-dev@lists.ozlabs.org,john.johansen@canonical.com,selinux@vger.kernel.org,borntraeger@linux.ibm.com,bpf@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 11 Nov 2025 07:53:16 +0000 (UTC)
X-Rspamd-Queue-Id: C54B140006
X-Stat-Signature: a3qu68tziptufzp8n1mynsnwzmtbhnqz
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762847598-236824
X-HE-Meta: U2FsdGVkX1/MFMBsiN0JFMByiw9WraXu0k1LsgcuF+Kj5zOrwmyiYBs6edeqkb60KXf0DTbYJLhEEiF8KtEdCy7hygTa+gldb7ETH0TIr2uV+RXOvHtInQ6zyrOYUkkQpOr4fmmlrJ6ngcwMAq6UhAoGkbMZwQWR+lstvgYcyN2OKNZ4cnSh7740yKrR79+INjwfsi/SR2xBe/KpfuK3mVNsRBUIDKag/RrZSFKy2w27pF0gq5hYXvgh6DRkJHdR2qDMRkKvgIftXA+S6d9e2+MiWvrCxYcaXPzfF+4PuAuIuLfu8MU4PhaZmKo5m5rJOwAUnfuetBAQYT3gAnh/5LnXtjiR4ka5pJzB3VxNQVn+HxlC8mLDXE16x7xZD5+/rjsxuhC9vKnrjmISp+9ddUjVQNHTDyJn7mYWx9YgZNfQgLaz6nwB7J2jl9J0ALKDcNsV6FMZWc10F5KaovfHROefoWO/DMsnbvMp8dT+8RpsXqxnOzTMAxT2Pf0H/atYw0zR2d8Ysqyqt/d28TR357+WPNS5R4SDJKT3dPs8arxX9TDeqkRI7iRbDg3kFizfABVOMVFvJb51q1Z4+2WJpVLUsxq8wBJzrgiQY0A/a3Rq+c16JhCSS8BFGnMPT3dO0HE6I2E1O53ItGPcLjAypnKsHa6pRcsuer+18D3pBdCgwWilbrD95sUY89AASHkecYWidxAamQGz6h7CFk+AYKN6w5wjTOenGGQj7AghhqlZEz+/MqIrV/bfeqlTStlPICm0pfanS0OW7E+V/Db/0Se6U9Mrn2mLN+fE5Wd5yWkTgU/xJHWTpp2rqBjChWwO7zHiGbIukdf4+qEBTHAIfoAKb0WSv3ukBN7sbvcDeeldQyMUbv2JNL1by39WjU/oKYa4sKK2kPqgh5ixDCY4WLjHhcOuCOVFDjopE3hQYxniiuXThgkJVyLSaxZvOU/cAGm2Zsu3cTkcptF+L+P
 izMzz7h6
 nYQ/haw+bYm4WkuRGUa5p4N5um5lLJbe25KzuW4uVBm0xoO39KEm7c1l3mPrWj8lpaETXTTqIrR7rcA1lCqTexOsGbykGhacqOM2utoFefd4faWcjnwMANMmrOMxle0E8QG9n7jL7L4rQsQ2RuuHnAAVk+fQ/Mf7HKwXkpLexkLTJ0EQ/qBTSyu5ma75giPPRazHPFuzLLSXNOWy8o9W+47bjoABDldNwo66EP6LtAfx4uoh4EI/XbMFyLlU0IMyjLuWcbVazkn1OS6dgZS66aLVCWzFg/245rtYH/GYMIB+Hn9go/yOhzJQTz7QUM7zudNYtMdwQRed6xD/yQyn4g5SY8GakOEzjeEYQjRIu3hPbPf5JDKSgaEClWWZrqKCL7NUFW5musor3E4urVbC8rbQTwYts2Vh1a+tV9ATNcUlecWPDoCwq5aGy1pfLs5iPgzLB/tEOFaHMIwV4cqWYv1EhUi8XJz64ku8ch3CZj7uXPU1aq4SUxbhogzZEY5PI7OCP79tfv8GG22A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1014260008914052501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 47cfbe41f..43dcd39b7 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c

[ ... ]

> @@ -2323,6 +2316,7 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
>  {
>  	struct ffs_epfile *epfile, *epfiles;
>  	unsigned i, count;
> +	int err;
>
>  	count = ffs->eps_count;
>  	epfiles = kcalloc(count, sizeof(*epfiles), GFP_KERNEL);
> @@ -2339,12 +2333,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
>  			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
>  		else
>  			sprintf(epfile->name, "ep%u", i);
> -		epfile->dentry = ffs_sb_create_file(ffs->sb, epfile->name,
> -						 epfile,
> -						 &ffs_epfile_operations);
> -		if (!epfile->dentry) {
> +		err = ffs_sb_create_file(ffs->sb, epfile->name,
> +					 epfile, &ffs_epfile_operations);
> +		if (err) {
>  			ffs_epfiles_destroy(epfiles, i - 1);
> -			return -ENOMEM;
> +			return err;
>  		}
>  	}
>
> @@ -2355,13 +2348,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
>  static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
>  {
>  	struct ffs_epfile *epfile = epfiles;
> +	struct dentry *root = epfile->ffs->sb->s_root;

Can this dereference uninitialized memory in ffs_epfiles_destroy()?

When ffs_epfiles_create() calls ffs_epfiles_destroy(epfiles, i - 1) after
the first ffs_sb_create_file() call fails (when i=1), it passes count=0.
The initialization loop starts at i=1, so epfiles[0].ffs is never
initialized. The kcalloc() zeros the memory, making epfiles[0].ffs NULL.

The new code unconditionally dereferences epfile->ffs->sb->s_root before
the loop, causing a NULL pointer dereference when count=0. The old code
was safe because the dereference only happened inside the loop.

>
>  	for (; count; --count, ++epfile) {
>  		BUG_ON(mutex_is_locked(&epfile->mutex));
> -		if (epfile->dentry) {
> -			simple_recursive_removal(epfile->dentry, NULL);
> -			epfile->dentry = NULL;
> -		}
> +		simple_remove_by_name(root, epfile->name, NULL);
>  	}
>
>  	kfree(epfiles);


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/19257803162

--===============1014260008914052501==--

