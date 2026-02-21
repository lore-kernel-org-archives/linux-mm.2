Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8123AC5CFF1
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 00:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1726B0005; Fri, 20 Feb 2026 19:03:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EE76B0089; Fri, 20 Feb 2026 19:03:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B556B008A; Fri, 20 Feb 2026 19:03:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADF036B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:03:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61B051C23F
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 00:03:30 +0000 (UTC)
X-FDA: 84466514580.19.E45B958
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 99246140003
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 00:03:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gTcXljw2;
	spf=pass (imf09.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771632208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmKPbG0rn/IwxZixewvNnkvJ1twLoxLjwi2Y6HdPwfs=;
	b=6aMxjoHuWALGrghxKhxHbRC56zrJY9vVvBDOHu5yh1yx2oc2PsHOcPmZNHjP1t/hex3NVI
	ujwdbJbEOu2YPOVYz/+ImkuCx2KbzaA+ibytRxqmllZLzFngc7J0jleGOfck6XpOsRA0uw
	dmOlSljGzJcvp+GI3KxW4mxnYfPO6pE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771632208; a=rsa-sha256;
	cv=none;
	b=hNv0DQQ5rFyV5QXVBJSw0VprDGActALKyKhbocmfr6bZ/47FJH0KPtilCNaeGLv7nRMVNv
	cC9Kk1uNlREm52BN7xMAiOEeFGNflzVaDrhy69C2MIjfmraH5m+yN/N0Mk79uFO+6GKEQK
	eMIV3j49TyJWOlez4vQe5LsvR6WTxQQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gTcXljw2;
	spf=pass (imf09.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 737C34034A;
	Sat, 21 Feb 2026 00:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43295C116C6;
	Sat, 21 Feb 2026 00:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771632207;
	bh=ZmGa5tIl8OA5KzSQQqrKLWKWS9mT3TwNVeOHxd0u60A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gTcXljw2vb7Kj9dQWNO0DAr4Fzq2ZV+nbvUzavcQDOCPQbhHsksbvN4P/mZQFiTTp
	 jxGFz/OR0+5GFzL0PTwcNdVZlGifjxqmXte5HjWO63X/t/GqESD9jDdBuUsRyb8+2v
	 C+SrYIWDq2y/C3DLPQfjDGJpx9K+nT/nlFvReuOhX3v0m4m6JuLrZtYX8jR4TmMuOG
	 OKbvv0xg5bNp47dmdtG/Jd4aNSWh9F2VXgMxZrh5G9z9MqHPf7P9kJo57rKIYe2Q1T
	 7VfnqWXai7h2I/MwJJQGGDy3wExJrV5M8KHm9+4fmdwT5DE4aMuzPGEt4b1d3CaF8M
	 N/g4IWbEgRHGQ==
Date: Fri, 20 Feb 2026 16:03:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 09/14] xattr: move user limits for xattrs to generic infra
Message-ID: <20260221000326.GB11076@frogsfrogsfrogs>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-9-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-9-c2efa4f74cb7@kernel.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: zhpadmxuegwbm8apkqojns9gymirkx81
X-Rspamd-Queue-Id: 99246140003
X-Rspam-User: 
X-HE-Tag: 1771632208-497653
X-HE-Meta: U2FsdGVkX1+w4I6fHRFk9ceX9ZFEC1E/HsnyK+WmAkYevlYQiz2ogNviJWhiU8o32vBOOWbvH7x3SbYo0qSXWOema2XUrxUkOOs8g8KzK6MwjkdihZupvn1wqggW3MeJtkGH96bl15BYCsmkDNqj7QyRaIgt55gWHSPrcIlxLavXTQVTXFSGAFyAwLy5phhpPJBnftOMZxl9VNU+eQpVlhIXwI7Bkxcx55Ytb+H704o+EFL3iUW1Mk2TJ0bZLFlWVgpS8otFJ3kaaRYcL8N/HyC+pLUwIJbtVO50L6QEyubj11xThsMqnFv0P4ZCWlEl1VbprT914WOkpfHIdXciIdp6qr3PgllTbrBIBP2s7k5Jww8Jpqxq4PwatDlQBI89VYOxYgvyg6InHz591DrZbm5THu5qN+HUQIHf7IGoVQKfj/grOKHOzTb1NpLPR9ZQdgiBk6l/x5h5AOWbG5p3EeSMi9Z16Ombz+Q+SC9awwA3fgf8Gz1vbMDvSAC2kKIM08R4G/jFl+eMpe7y+mA2L7vA+AIADkGx10KNY4a8IDTcvfQr1gBviemWijMevR1LIzAdo0MQxL7E09enb727kqatYmQJx9BHy1tjKorEZ90IP81qoeio50RbFrJybRf5SydAV7nKV7usgE+kp64w4XoJsiikHGeTiTrYjb2BkZUqy4W0h8vUWUaKCI31hqNhRMdToqnHQuUMZFteYSnSiG3MBnf8oAbs42Boc7Nk226MpIsjXmpLxtmHNRj2FbmLPOnm2Xv/na14maeCNMTZdS8ZK3CznUbnqDlIYZaP9hPwIoMyv4twRzwVn7fATKSa1tq2uuVbHyFd3K4h9L329q9zY+Og8FnEMeriZjLpGvFOiNk6TH3qrQLh7aUyqwdzy6RGFAr68BXW5Axxd6jYL3qLpBFLllp4a15nRpsqRCPzUAsy3OkSa8XVDfg+IFT49TZjx2kJPowMlsZ2Er1
 EpjfxRoE
 TUnerpvKXGX41oS+k+2okeHiZ4fb4sp1O5iLuSZIoOxPMv65CUcehz4bkQPxbaty/DmABM44baqZ6GTwGNAju0NMbjoCVqBbSnn3Zwb4UvTddsFuGIfny3CHEp2ld+slAFXGYPR/7J3mxsemTEHJ9613FMhHaw2SDBdV/Z2iBksITP8Pa13GXhGspnQ1Nu2Q5g8XwcCkHAqlpkMgkOr5voy787649L8BwmIWL3ZiaC0kTm5U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 02:32:05PM +0100, Christian Brauner wrote:
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/kernfs/inode.c           | 75 ++-------------------------------------------
>  fs/kernfs/kernfs-internal.h |  3 +-
>  fs/xattr.c                  | 65 +++++++++++++++++++++++++++++++++++++++
>  include/linux/kernfs.h      |  2 --
>  include/linux/xattr.h       | 18 +++++++++++
>  5 files changed, 87 insertions(+), 76 deletions(-)
> 

I know you're just moving code around and that looks ok, but:

> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index b5a5f32fdfd1..d8f57f0af5e4 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -99,8 +99,6 @@ enum kernfs_node_type {
>  
>  #define KERNFS_TYPE_MASK		0x000f
>  #define KERNFS_FLAG_MASK		~KERNFS_TYPE_MASK
> -#define KERNFS_MAX_USER_XATTRS		128
> -#define KERNFS_USER_XATTR_SIZE_LIMIT	(128 << 10)

I guess this means you can't have more than 128 xattrs total, and
sum(values) must be less than 128k?  The fixed limit is a little odd,
but it's all pinned kernel memory, right?

(IOWs, you haven't done anything wild ala xfile.c to make it possible to
swap that out to disk?)

--D

>  
>  enum kernfs_node_flag {
>  	KERNFS_ACTIVATED	= 0x0010,
> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> index f60357d9f938..90a43a117127 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -118,6 +118,20 @@ struct simple_xattr {
>  	char value[];
>  };
>  
> +#define SIMPLE_XATTR_MAX_NR		128
> +#define SIMPLE_XATTR_MAX_SIZE		(128 << 10)
> +
> +struct simple_xattr_limits {
> +	atomic_t	nr_xattrs;	/* current user.* xattr count */
> +	atomic_t	xattr_size;	/* current total user.* value bytes */
> +};
> +
> +static inline void simple_xattr_limits_init(struct simple_xattr_limits *limits)
> +{
> +	atomic_set(&limits->nr_xattrs, 0);
> +	atomic_set(&limits->xattr_size, 0);
> +}
> +
>  int simple_xattrs_init(struct simple_xattrs *xattrs);
>  struct simple_xattrs *simple_xattrs_alloc(void);
>  struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
> @@ -132,6 +146,10 @@ int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
>  struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,
>  				      const char *name, const void *value,
>  				      size_t size, int flags);
> +int simple_xattr_set_limited(struct simple_xattrs *xattrs,
> +			     struct simple_xattr_limits *limits,
> +			     const char *name, const void *value,
> +			     size_t size, int flags);
>  ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
>  			  char *buffer, size_t size);
>  int simple_xattr_add(struct simple_xattrs *xattrs,
> 
> -- 
> 2.47.3
> 
> 

