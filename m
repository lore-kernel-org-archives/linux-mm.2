Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5659CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4CB800F5; Mon, 27 Oct 2025 21:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194C2800E4; Mon, 27 Oct 2025 21:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AAA9800F5; Mon, 27 Oct 2025 21:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7B6F800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:15:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86DE0C02DF
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:15:43 +0000 (UTC)
X-FDA: 84045755766.03.5F4E5DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6BFD18000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:15:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D6YozAOS;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761614142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOQ1Ne0AqDDrph5fTBEt5Su6YDHYv0+Dldqs58lMnUg=;
	b=e6SLLrAQvSdc+JBaE0BmIZRlm+pXhYmex/ka6J5l6EFOWxt1Yt2qmCJ8hVoOC1b2dl1hc2
	fOE0ch+9ZSWiVCi9W6QnsKQA1wmw1InwE5TTzMY6htYJl8BnHCj1ObGpMT8sbphmfFfuER
	kHecURPUilw+aI9XdrstFv6SiS63vAw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D6YozAOS;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761614142; a=rsa-sha256;
	cv=none;
	b=RYIS1Y3L+2yTJfJxOwdfsFazNtqq19wDHpaPfiCatqrjDYXCwjYennWdlTdRRhS3nDdmIM
	8/7Ma2bpaTbzT+LFTSrdCpAW06wnHhht1sy64WSQFgKJO4mIi7WV3FV1t/CgX/ekw/xuTE
	esNBlcsg8INtHJmgSgDpgkEx7xTkHmg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97D8843D32;
	Tue, 28 Oct 2025 01:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D295C4CEF1;
	Tue, 28 Oct 2025 01:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761614140;
	bh=hZMNoT84NWTUnJ7xeU4dTqY3HFxtGS2LILZkNTb0rRQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=D6YozAOSL4ftkP1327QSAIyotS32B0Q61n32u8VQuijuZFU6ZGCDkPw9rpPPx2X/d
	 jPdBfxTrUvESTVDaPBpKoau0kghcyTvqfhAUE3k343cWjmoS8FFpTh9ENMdhx9nay3
	 DpIjPkZUoV0H561FWIL4G9bQoY03UPf13yRixAe5Zt9eMV8Gg9vBvvlEJs3R6mVNCO
	 cVvt8FKZ0wSlX84xMC2Q/FN0g9SoZSGxUOEDkrBpSJf4YjLIn2OLuu/+O+RjNnQS67
	 Nrcaqwl12T0AYIYui6OyoRJCoaCd+Bb4jdUMSvGLZiwMDSCkJ2jeFyQBv/NGmnACJ0
	 z5mJ/sXQZgy2A==
Content-Type: multipart/mixed; boundary="===============3821749126373374714=="
MIME-Version: 1.0
Message-Id: <022fbcc8127b3bcf15731de7956ca892619da224487161febb9ef1ed4c71597a@mail.kernel.org>
In-Reply-To: <20251028004614.393374-24-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-24-viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 23/50] convert spufs
From: bot+bpf-ci@kernel.org
To: viro@zeniv.linux.org.uk,linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,brauner@kernel.org,jack@suse.cz,raven@themaw.net,miklos@szeredi.hu,neil@brown.name,a.hindborg@kernel.org,linux-mm@kvack.org,linux-efi@vger.kernel.org,ocfs2-devel@lists.linux.dev,kees@kernel.org,rostedt@goodmis.org,gregkh@linuxfoundation.org,linux-usb@vger.kernel.org,paul@paul-moore.com,casey@schaufler-ca.com,linuxppc-dev@lists.ozlabs.org,john.johansen@canonical.com,selinux@vger.kernel.org,borntraeger@linux.ibm.com,bpf@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 28 Oct 2025 01:15:38 +0000 (UTC)
X-Stat-Signature: unmihq4nmudd6upe5mbhjud7o9h4t5rq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D6BFD18000C
X-HE-Tag: 1761614141-75885
X-HE-Meta: U2FsdGVkX18Y99qi0jh22r9KKakgoYDjC0TDuszEMKvRxYIfpdE8FXfHQbbfpkS1Tqe41ibMxBKfZAmtfSe73qsd4ZGa/IqYCXfTiEvaFWJH/kAmDadqswf1jOX48iTohywGijr612kHK0I4AJiQSn+uqB4VNxGrXMNfkJYSObn+Xa9cHWPyd0uio/65nUZEKPYpzM6RwfigaMkGp0H94OrPedePenALMeRlWVeyxboAGSmaUhgbd93C6k2KqmgLYPq4vbWGgYveZ092jiE2So9hPkCQYTBgfjzP+IzbVjeAQBmZ3JBcqFA4jgJDcc5F8ygADEHaSpOpJlGcOJVTaga8eTBh/AmWIhtToVgIvW252iay3GkLOOyYKksPdMYb+AVW7Pje9MMFbWCcP1et12zRfc0BK4jpIDqKl88yfo8hD7LzXVio8xn361JfFCLugqpqw7K/QK2aAHptNr4Tt1JwxLO5U9W2LL5MzzB0cTmpa9J78bRsybscQqDStunv2FgmZ8eqKveKgEg+m2qmDkJrdz+ktbdHrPtMB5r+w0/IaaaFb7laPptwhFycjT46ioj4vz+TMQHT48a+76sIf2FiL6i4VTxNuf1wip7k1OcmOZBvzCalDd5Ws0FR0IvJjmDP6Fa3P4l9Rs5CsDcRFSMU5Vesxk2UjRGr+78/++JN0j5B08X2YpqEXvxxC/1vewIjT+ny3fuSL98OMqFDkS2x10ekgNLy+T0Jhd+JmtO9lkPwbJ99Lq2vznLt6exGq4hN5AM8EunrYakYanLsvFWJyN8pbHulVSLS3uRSNsdH1IMMBNm5oHx3vS/Nq/9xnH92FsPg9wkGdACAZcq5W1EhHEGmGcpSKdydTxGKbCz6L/ATetDqM6DuwBEIpNtcbTzRORGjvHOmKDEwpI8psxdVsWy491eHp9X1JzNkSIj2Oa9QpgklYl6aE3ezS9rFEdPBJ6qgscZ28eFV40e
 SK5ACyu9
 W8tdiQvGaN2CRXZ7wQMZT/c5PrnXOmkMjpiVsCzURM/92jTuEKu8l4G0+JrmK1C/AQE+sijSbxtDPYiPP6FnBXjGafpUpWssk4t2dDD86Bbm3DHlK9O/70zrLXcyM/EK0C9TBR8D1JnbGcWLOoQDOw4sa2sTi5UQOiJomy60VQ9QZA8s+5jomIpuWuv2XQ2DMAvFy+vLe7m/SmVe7fRXKnmYuxsXilLcSygap1XmMtH5GAcNew6/wAc6dPPdvYcWrtB7q+xtR2WkDsYDM3ORha46/dCQZwHTuVOhZAasMEbBC+XfU1pw8O1mHAwA8EB+HU/VE2QD0rao7WTYtBu5HYJS6p9iP866fJJLt1jrk5B24I1RmUau+LkgZPKNuPQvLQervvxxwmcfFhfB7fMVOofnzWCqkwTHaFk2tA+CEBDs2ZOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3821749126373374714==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit 0e359e5d712e3abcf8056b43da12f092c37e9f21
Author: Al Viro <viro@zeniv.linux.org.uk>

convert spufs

This commit converts spufs to use d_make_persistent() instead of d_add()
and d_instantiate(). The conversion includes making dput() unconditional
in callers and changing from kill_litter_super to kill_anon_super.

> diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
> index 7ec60290a..f21f7a76e 100644
> --- a/arch/powerpc/platforms/cell/spufs/inode.c
> +++ b/arch/powerpc/platforms/cell/spufs/inode.c

[ ... ]

> @@ -241,11 +240,10 @@ spufs_mkdir(struct inode *dir, struct dentry *dentry, unsigned int flags,
>
>  	inode_lock(inode);
>
> -	dget(dentry);
>  	inc_nlink(dir);
>  	inc_nlink(inode);
>
> -	d_instantiate(dentry, inode);
> +	d_make_persistent(dentry, inode);

[ ... ]

> @@ -479,10 +477,9 @@ spufs_mkgang(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	inode->i_op = &simple_dir_inode_operations;
>  	inode->i_fop = &simple_dir_operations;
>
> -	d_instantiate(dentry, inode);
> -	dget(dentry);
>  	inc_nlink(dir);
>  	inc_nlink(d_inode(dentry));
> +	d_make_persistent(dentry, inode);
>  	return ret;

In spufs_mkgang(), can this call inc_nlink(d_inode(dentry)) before
d_make_persistent() instantiates the dentry? The dentry is not
instantiated until d_make_persistent() is called, so d_inode(dentry)
returns NULL here.

In the old code, d_instantiate() was called first, then
inc_nlink(d_inode(dentry)). For comparison, spufs_mkdir() uses
inc_nlink(inode) directly instead of inc_nlink(d_inode(dentry)).

[ ... ]


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `convert spufs`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18860600716

--===============3821749126373374714==--

