Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06547CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 09:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EE28E0012; Wed, 12 Nov 2025 04:33:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6408E0002; Wed, 12 Nov 2025 04:33:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533B38E0012; Wed, 12 Nov 2025 04:33:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA7F8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:33:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D02044BF40
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:33:53 +0000 (UTC)
X-FDA: 84101443146.30.9E7A6D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 295E7180005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:33:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UyDFIVHu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762940032; a=rsa-sha256;
	cv=none;
	b=lJ++bh2SIFPvyo1xIoHF7zTs4PIrYMtAaPplwYu//X+TCxzqX73QYfcdaRaLNZwoGgvY76
	wqlFpe9fF3aX9AcYPi31lAjZ3JdRuGv6GUDJYD6a4GWYMuqYuIXURANVvPdlRTPOSgy2Sf
	vfoo3TYFd0Dz/hZobFaOtXJhax/SruI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UyDFIVHu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762940032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tM+FUGYgnK6pFf5lagr7HaGwyj1RCHkwDGV9cosuYno=;
	b=6wP1VPkFnh1+qvAK/95JGh4sZy8Ix3Wg1Yig4ARlkiSFi8RX2td+CzWh+MjXxdH+t9jS1R
	6aU/AB7z1baur+JTYFxd8+iufWGHfo+DzyGsBgNnzWVq7CkR0Min74LuQDXoah6fjJDg35
	FqiAwEX1B/w1ROIGIZpHcRZG8FpPjrU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05D0744391;
	Wed, 12 Nov 2025 09:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190E7C4AF09;
	Wed, 12 Nov 2025 09:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762940030;
	bh=VaWvuF/ukzI6PWpHBDHmQqomQZveyXgP4iaU8vUBouQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UyDFIVHupVESBO5dKdFJrpimm/QKcIKr0pIBA+/nRs7CPrOokVE1j8R2pbbZo4+D6
	 LaLcQ4msb6O040l0Xlul+J1I0CxWKJtpzwQpFHibIydSaDzMYJLRAPITnAZrKB/7Xj
	 Cw4xqTjQFeN2a6S3mtZteOzH165g3rvMwinBE0FwcIc/6VSoKC5bUVF5vz1T4grRN3
	 02cWymyRwrBcC9ero4np0nIOiLCCkVhnPUQXIaF+rfVOWu4buqIhpWHkQya3TZ95al
	 puiWSHBqlsb7mXu0ckqvIpdIYrfcKU/4mAXxe7WT8wnXsdFy2CeSgWtdvibGgEaM8/
	 4p8JFjxn7NAEQ==
Date: Wed, 12 Nov 2025 10:33:46 +0100
From: Christian Brauner <brauner@kernel.org>
To: Mike Yuan <me@yhndnzj.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, 
	Hugh Dickins <hughd@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] shmem: fix tmpfs reconfiguration (remount) when noswap
 is set
Message-ID: <20251112-vorbehalt-heizsysteme-3b11ba2b7ea3@brauner>
References: <20251108190930.440685-1-me@yhndnzj.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251108190930.440685-1-me@yhndnzj.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 295E7180005
X-Stat-Signature: sr3ysfzxdncgfi6ko4ipqm9piw9zjt4t
X-HE-Tag: 1762940031-372583
X-HE-Meta: U2FsdGVkX1/KJVUlmw6uzaQ3Y0T44wgT7LwFYfEegVOtKmBgQO0oxf158WHHPLXh4m9zGfMb0KIfoT+7IjnjNIgjx4ZD6/t/0+RiRoTtpfBtG0P8bfudnBygj1U0gntnnwruzOhYK11FZLV3TA7PPnMaq43qjJGfD352CYnYQV4ds5k5i84IkHRD+JKw7Krzutwq45lRS6Pfd4gHmfFSDAFT0fr+BKLC7rF8Cr3l47VsAs5budRnKPdTp6ip79nYXNfHl3ke5BU/iMyoi6D8owgQ64gpTRNrh3jwdhgylOOkkIU0KOQi5ReDD6itY43ym6+F6srzz74qr6VeGDyrwdOi8AmV9N905UtiXQp0bNNIkeD2NsVropqv+uPhgOw9rIJslmTsB5Sr2PUyNtcAiqsB4T3zV3+hG1DcWiY0UpIsTsNX45Utdkc0Atwy3KA4nW7rCURR/6NutY/hxw80l9NNpsCIsQojLVG/wLx5Xv1CkOOvuORj/vSuuP0h3ENXwfoBJ5vxvGRQhH9B9IHsoXgjQTCGlPCFDyL1YFnRbzmwJftUEdBWS/a+u3s5BoKybqZR+ZznkY3sdNYmY8YXO7LmI3H7LiUfNDLEm5/xg/N+JInSQUrSfiqR6E67h6WVP8FAsIwmm6TxfOJp1bij2oVlHmR0ZKygbaaALSRKm0yXgeAg/HojYjopR41zkugkKCzhVOsoDer21povZ72ktRRb92kvnBGt7YK+lJaeUTNJ2Y3N6RzjD12ygk3s2WcImFensV1oXtPC/yf6rqjvAS/CDHcXYbNwHFMYDA+OrZfvSMucpXppZ886DEbVez9oRlbAkmc7K8v+pYbR3q52dB4XBnOTBuW8ICXb/dA7ox6ZeGbgQEKEC7NKkMD8aKdZG4YE86igWyZNFbq2VTeXmK4YXsOnwdhxtclMAe8PXcmmktB0zA0XYQr9RXs7KtEBfu+ZjRdMLiuDZK6+tDY
 c7LE2Ci0
 Y4igpbRGLD4uMo6e/qy6PGMWTc+PXnDr2NcaH/ym9EWpxFdm9EzFb++QXAxIE94EhWgpE6GH+LfvlueiJPAOs7jGmFJ1dlsg7d1fmdYdO4MgSRvhSig/g5KgH/llt+/nJhq0Duf5M0fsfUYCelSXid2Z9J26+Cwt2lPipj1kIgH5+gB5A7KCTLUgcskkQX018HQj2yEvKHaKGMZlv+x2zeeeMF/YoDsvoINzgV8KeRMoH2zKd+Z+xjn4swV6EJvRUjAbHTFi1heK12tqD1Nd8xGd1HnJOecg5tgjH8aQRzT5hTHTrel+gVHtzTzWQpauXPjJZttqNNpzeyNxO2P2JkRRP0V9GVEV1G3OvJl7LMpyKzEBrUQZr/jUDtV2jnn5ZlPqhOrrU0Vwjn/uRUzh38vUq5FlhwJ5PNNC4dAhjJIxaIxo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 08, 2025 at 07:09:47PM +0000, Mike Yuan wrote:
> In systemd we're trying to switch the internal credentials setup logic
> to new mount API [1], and I noticed fsconfig(FSCONFIG_CMD_RECONFIGURE)
> consistently fails on tmpfs with noswap option. This can be trivially
> reproduced with the following:
> 
> ```
> int fs_fd = fsopen("tmpfs", 0);
> fsconfig(fs_fd, FSCONFIG_SET_FLAG, "noswap", NULL, 0);
> fsconfig(fs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
> fsmount(fs_fd, 0, 0);
> fsconfig(fs_fd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);  <------ EINVAL
> ```
> 
> After some digging the culprit is shmem_reconfigure() rejecting
> !(ctx->seen & SHMEM_SEEN_NOSWAP) && sbinfo->noswap, which is bogus
> as ctx->seen serves as a mask for whether certain options are touched
> at all. On top of that, noswap option doesn't use fsparam_flag_no,
> hence it's not really possible to "reenable" swap to begin with.
> Drop the check and redundant SHMEM_SEEN_NOSWAP flag.
> 
> [1] https://github.com/systemd/systemd/pull/39637
> 
> Fixes: 2c6efe9cf2d7 ("shmem: add support to ignore swap")
> Signed-off-by: Mike Yuan <me@yhndnzj.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

