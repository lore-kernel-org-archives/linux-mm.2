Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFBB606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tcwd7Q8/
Received: by kanga.kvack.org (Postfix)
	id 001506B05B4; Tue, 10 Nov 2026 09:55:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BC76B05B5; Tue, 10 Nov 2026 09:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31FB6B05BD; Tue, 10 Nov 2026 09:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE9726B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:55:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4659580910
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:55:52 +0000 (UTC)
X-FDA: 85419508944.20.20B0540
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4BAA720004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:55:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tcwd7Q8/";
	spf=pass (imf13.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322550;
	b=mS4CmoUoB8f9hYwVMhjh9RSnSQiP0LLKdmiSt/Fv71SGwhvRjBrP1H/z/k66zdQEzYLIt6
	5sucazdPqEhb5Kgdu//yaN2tpgveD7iLHKU9fky+jVwT/1a95tde3GRcgXV7Ru/dzNz5pl
	bogiBl6n1kKYvGs9HuSb4spOYR66c9w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tcwd7Q8/";
	spf=pass (imf13.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSjXnOetE5oKa5v8S9LBrUhcmgizc8ch93AeD/W6gEI=;
	b=GEPoL8gLURHjLNcBmoZx7Ntd+LLOtw443x7iznZekdpgWgDofaToOHGoC6js2z3iLmp1nv
	YlVhc6dd8pL3v3AO8V+PQCLVq3a04NMEd5S7i9v8T8iNM0aI6VF0v8nMoO7PEUhZNt94kG
	JlimXLGUDycFVsjHmfs4ML6tQ0KZGww=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6AD8639EB;
	Tue, 10 Nov 2026 14:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8D71F008A2;
	Tue, 10 Nov 2026 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322549;
	bh=zSjXnOetE5oKa5v8S9LBrUhcmgizc8ch93AeD/W6gEI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Tcwd7Q8/BgCZr0AJA+q53XtkaEXHNBQAptcCIoE3INOkDT8T++JPLwFgnijhu6LIp
	 QoJCfJqeBNhK26M7LL9xd4MzXxKVISVDOEW1cYrYEyBiFKRmR2hdLsioEex6m+2Rc5
	 2AgfVzjCsuMDtAVvAKOrFX1qXAfAYeUYjVl2rownrESZ29DXkmWTHYRM7alPMZLQ6M
	 DZH727vPlYTYzZb+oco6o/Bkhlk4m5LBSezhlvCb0bhHHiXIMbUlIMDObU3PIfYN46
	 k7napT6YlagBuXnh78UDBF3WtFBwiJfcd2zG9H8WTZ7Zkc62YNaLopDBhwYuzfc472
	 iPuH2WgxnRVeQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id B2761F40069;
	Tue, 10 Nov 2026 09:55:47 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Tue, 10 Nov 2026 09:55:47 -0500
X-ME-Sender: <xms:czDzahOxHA_IGoa_FJdwV0BFPQw-nSdKO6kKGUN5puCfrxj2G2sK_w>
    <xme:czDzauxKYck9zKSqhpZaTHxPL9lIOi42MPCnrNTR7eaQqnpkmbe8dEx0PuhUogQkg
    tb2W38kOzksOJlDJ4uTGR7-rkbiwtctKuF5oVtOm556TqS1yjjUw9U>
X-ME-Proxy-Cause: dmFkZTE8jIcOTzT9axQiHwEjJScKTRkNH3ZVhgYbwXrBMnGwr/PZk5kUfGxy+RC0ezRM03
    2Axgl1A3kstcvJQqQJ+tEirxS634eXBQm2b+wwk+7byJnMoEdYYw7Lfb7185Bnwoliq1Mt
    XZ8lliUhOZ8AACZwbl4T2Tc7NYRy4GvnOujvSweRGBGAD4OQXGjTipshhA5n2cB6RQlk4p
    zmTRFZMOMjoY8cueG7e24ndoN2R/gq/lSNUbCVZu/PUOrAg9f6aovYYa9SSKBBYGtgXYMN
    0qbpFOi4S4kwXDcxuFcZlmK43Jt2p3+0W9uSzX8U3QJynW/odwma6a1hhpAbc8zEaSnbtk
    CFI/IAk8YwHJ0hyg7qaH8oiiVC3V/1ZiobIhoPO231VrqQk5oaP4jl+jS7yMnBbNxynDhF
    /tTsfxMaF/A9xwJBu4sKm+3lzwzMEEbqt79mE4Lq/VAgowI2/Z3gVdFMTE48DIB1KcUvAe
    gGFx1Bx/tQmWXfeE09uUSkiQ2KYN+OrlgTMnrepjVRxO73rY2t7sodPh2AhJIAG1ZYT5ga
    3nwb3G0mQrnmFOm4Qa4C2JwbajMdJBWMeam4uZKQraajbqcBHzCXvMtQm1fQbm3S2rexTo
    KA6wW/vDabSoXlut9Nm5uKTSjp20eGQ9lpLOxOz31c8eLm8Mlp10sjOYDNZA
X-ME-Proxy: <xmx:czDzaoanLMdLTFqhzMhrxv5H09chgFe3GMMhc1XBCkfiMJQ_ckta8Q>
    <xmx:czDzauzWTK7EYc76X_4JSXvP7e9Yqejr2yggz6O-tuvCpsEWBQGUaQ>
    <xmx:czDzasWQEDY8T3p3eaJhPzKDKFxYGPCQnFb1-n-prg7tBs3f0gJpWA>
    <xmx:czDzaqbpJaYjvNkk5zy3xoww5EsXMA5_awnvU25FYCgSdhgQQ41Hfg>
    <xmx:czDzavOKwCwywHfR1JNgdmNe33GAeUXrw31wmu_3YBRbMsucyl2ChD_t>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7D2B9780070; Tue, 10 Nov 2026 09:55:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AKCAcWHxcB8B
Date: Tue, 10 Nov 2026 09:55:27 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Jann Horn" <jannh@google.com>, "Chris Mason" <mason@kernel.org>,
 "Josef Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
 xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
 linux-s390@vger.kernel.org, "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>,
 linux-usb@vger.kernel.org, "Amir Goldstein" <amir73il@gmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Message-Id: <47b8b8cb-aadb-4f84-aa5c-c5a74d73fac1@app.fastmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-21-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-21-4c998976c6c7@kernel.org>
Subject: Re: [PATCH RFC 21/41] nfsd: use fc_init_pseudo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5e37gi1cu8xwyznjca9kihj9ir17b8zu
X-Rspamd-Queue-Id: 4BAA720004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794322550-19977
X-HE-Meta: U2FsdGVkX18+NEz5LU1XsUrhpxviSjDPc8+AjOlsV0wDKkeDmk8u7TyME2Kytf7Yf7Q6mtotMhKxobpBfEFuCIL2mtpLyHkgKPI0VpHjekEuqgdd0ETWqxr505hLWQZaQueGJmVMKofIAWGDJCsNY2OHg0mWyItuppDhi4u63n7rgnLa5iXN0PCI+8TIorQ6xukIE41+VFW/k0W28+L46o24An2gUoWnErw23ngcPYvx8SHH18+u/K17rbDSm9Egc7aPXPKsMWt1s4I6Pge8ysE8GjQHtrheLB0ZcIDG7AYJ6MMmaUlhHHNSsfYK19LBc9njRG+pEE6jD1G2yAgs7360WDpKlaE0hRdz38cjqI1coLIPbQb+lgJWgEMjLJr9YbndzNli8aDjvd1PwrAk/lVlTQd4mZFlMv6B0J2GEuB7HJZ+63x2BzVBtfFDh3yqASBu8OGLq04S8UyqxN21R0zTGO2+pOY6slZ17Sn9JQep2g6AOh0VUct3mWP2Ipwh2YEEWWgAiYgcwdOKq85932WwxAxmdVxm45Xpknr3PmnXjyjzQqr5DW9ulGaASInPmcnoWSYfGRkJ7IoAssI/Zp79+ZoROJuml9hTdXyJ3eCc2/mS7pj9+s0icQD8M5ewE13eDcQcJ9jMfVsmTWmgBzDyDSAlfKrj6A8W01+GSpZyDIPRU1vRLWc6FiLruaBRGVbZ2NmgthNUh2MYcUyo/D/9huclbGemWfWE96+kPxT6sSJqM+3iMJrdPejLcr0XVmlxyIWLZsV1LRGfYQRZremAAyVMIY7fDirf/MNXXx3XxM73BNroCw2RVIxdVsasi+o8SVCH1EjQhbekeABYdWRoFlOOuqo7zaRWVOOOfPBOrGXP15LySnbPjyiznSRObOj1V7GFbmR9gstoQEaeeOJr82mZcuODc8dF/zAI31QM9GVN/5V5+T54hXmj0rkc6H4F1xNzZmdVr1SnPZ+
 pBETH387
 ZFvzR79kDohz9p0ZS9RrMMpoRqce5LarrRDVjRqlenXeRV61iRiSbSx1zsf2EkhJRUtwbQOiullRpE5wxNyi5kVNVnyrQxPyvHWNHiOvtQLOiuALzAqhrmg06z1oXNuMkGGvbALxWMXe491OZTDTFmE1YcRkRYVpsPBt7ZKtxLLk+9UvqD2rCZ+3Q0hmsqYeN7ZO//xRdycOCbGrcoI1wGo6Pz8JfzA4qIOV4/GVVe46m6GwHIdHfu6Klb+sP2AmcBuOHM7VK2rzNCy5zaR1J13jp7M9VcXJxo7JCliujM4bCG/7RmcDRER/9Rhzi0yRWKwo2b/VnX5pxyC2lbg9aypP81gCsjGmJnLjHX3s/tlYI5nU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Tue, Nov 10, 2026, at 4:14 AM, Christian Brauner wrote:
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/nfsd/nfsctl.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf..ce2666deddbd 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
>  #include <linux/namei.h>
>  #include <linux/ctype.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> 
>  #include <linux/sunrpc/cache.h>
>  #include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct fs_context *fc)
>  {
>  	put_user_ns(fc->user_ns);
>  	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
>  	fc->ops = &nfsd_fs_context_ops;
>  	return 0;
>  }
>
> -- 
> 2.53.0

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

