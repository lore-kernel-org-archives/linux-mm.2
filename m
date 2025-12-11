Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A68D3E782
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 06:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE416B0005; Thu, 11 Dec 2025 01:04:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9ECD6B0007; Thu, 11 Dec 2025 01:04:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4576B0008; Thu, 11 Dec 2025 01:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF316B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:04:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 124DA5B35E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:04:20 +0000 (UTC)
X-FDA: 84206150280.10.1799CD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C995C0002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:04:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RBQBsdtH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765433058; a=rsa-sha256;
	cv=none;
	b=ZTv94zZ/UuQoJeKm7kBkCX6nQAjYIucEcYudMpAwTV6NXUB3lx6XOYSrno1M96SOhGy0KV
	BAcAwxa3sLq1k/t/v64pOCNCyfn1yx8rRfeswdMnt+VbydM0isQEAogIyJ6rLVfPxL/jma
	mfvp3pvaTPzcwicBkLTmGWoIuDY8OpA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RBQBsdtH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765433058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sd58r0YfcpR0GUofnOsw2xNxZ/cSwsaP47SwSrxjjTA=;
	b=i81h904GC5wrBLALlON2nLf0MhcI6evLt1v7mwlzw6mbW/pFHXMvhOUJhUsaItvH7uJvTC
	MljD9b6t7TbmaIuvQVTOCDsoL8cHlRK40gEBELcrxAhlU5zHDpd2OM8m0e1CBriwYcpIyT
	1CtRkmwHkPvKzqL2fqBc8xBT2Jmunao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10B3F405FA;
	Thu, 11 Dec 2025 06:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E092C4CEFB;
	Thu, 11 Dec 2025 06:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765433056;
	bh=BVPTFvay2BavFmovTX+OOoOefFkQfN54jZGSLeoCJNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBQBsdtHO+uingZR4s55C823rSHJT9TLEELvdy5RwB4zRpzx0SA7f6PkpdZBY5Tms
	 zcaD/Nwr/kqJPi8YaDr2BuTs7Tern92Ss0DF0K7kcPrfounpN8ZxRifQH6K4yoJO6t
	 ljlvYOZPvFML62jA98n0pGFwRnYHfAGEcMu/BkbHdoFDvDZYncMm/iUJ4swiqgPuLs
	 hwH8zgzPosSVoZ5rhadruP7j5804gxIQlUEFZgfbj8ok/5mXlTBtcIw5EDui/bd4Go
	 J5R0zOuyjlolByr7jhLq6EmgtdeKsjrUdIIcWff6jYnZ13FB7Ae52jgIBZGnqvuPZo
	 7oV6d7PDdJyJQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
Date: Wed, 10 Dec 2025 22:04:12 -0800
Message-ID: <20251211060413.60534-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6bJLf=LuBpm90n5poz8Sqhz9wjXtk5ypbPwkvhb1ptag@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6mi7zt3hqqf3wadc7wcmnxqqm3sq1chs
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C995C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1765433058-141297
X-HE-Meta: U2FsdGVkX1+8tleKa3A3pK5W13VuMzDUvrm2BZ2M/GhBJgnnzV2a+EAnGUceRtp26VRXRmKJ3y+gHr0X+0r5gwb4SJtEHeMWNMLW+B8CWTbmPQERO7PRs0wJzaJHLkKvz7gKLn0Fk8FSwoAj/7qvBc2Ef8Har4fISyJDl1LQxDJmHKH6z/itgc0lg77Uxaclva0e70SomVto41KMfy4zyfWu02v8sS/gvc7XvfBBY0m4j2OL695l5aGXEWgEckzoYJ6tCobeF5VhJYnC788hRl5ea1w7wPdAlHr2zlC7DpBucp9aMR5sa8Sfw00eQTM7+m7SSCd7UC7Mih+xt7asgoyn+xiSE7RCa7KtUXm+0hYvtYipLjn0f8NRiK86sMXNHsTXE9/xJ8gK+crSIoWiR0H6oo3Al7sGllKQjQEd7o4K6+bM/2/94iT/pB+mLlxw3P1tgSsQHOlmcEMzqifsTjdZIHVJahlst1EcOCyMtN93PJtubce8v1qjxb1ZNi4iOjsQM5pc2iRhi6KlcvpQDX8OUH0BdXBym8kUM7VX+XNKZ6ftb9kBzMbGGMA1IiQCPSufNyRxwadJp+59xYTe75uCDp91p2jmZgnw79tiA5Eq16IPuHYV/k7cAnTmWiJstmAL8wEv0mcUBqovTgepXNlWtoUASHUfK6H4BR8SVu0Yg5uGG38ImY0ye1q76pLfUitim24PRwHybjcUj1Mn/PZkBbMVIBdHGeYFzydqEqMhRbYjP4UU6ctP7MDXSoA//8+osdMNYTNGtBi7/gyjz2cH+5HvbLzaLmKqEnUxKuvgRqtb1vwQItdDNIJHexGRByRpqvT1TuyaUt140FWxtPL+d1tpfTVRMnB0RERggAa24bHVDaTQXI7OrFinF9gzqSbJXM6FtdYsz1WdP/1fo36RoHt5YBPq+xSRNoeYgQl/5Z/IiLmHxOCVFaa6l2/H3gnC/giNstiX7cujjwB
 UrYwq2NN
 YSchgvqKdhKjHBLUhu+IVH4h8cBtAUhNBPTYYV3PivHp9nPTrIeBaKA+ucYpLvGzCdLigwjcLnZISs+ynM7XZ7B/FXhJon3lORZOGxnY+y7ersgnEEOzwpx5udoTW5fmtnZ8c1lVLyJbAJIIpH9p7fFrYg9vrBPg3ovIjGSQubK5VJXrWM50e0iPyWdSvInaie44nZZDU7Q9nwhgCjhQDTSEduFyoFb2XQBLSA9yJTYa4YYeQo3xLLmNDV7QEzYjIZm0vCWpqt54Ozk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 12:29:59 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Wed, 10 Dec 2025 at 11:54, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Tue, 9 Dec 2025 21:20:42 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
[...]
> I suggested removing the dealloc_on_cancel condition from the patch.
> When using the damon_call_control structure, if you only use kmalloc()/kfree()
> when canceled without dealloc_on_cancel.  However, currently, in other modules,
> since it is static struct damon_call_control { ... }, kfree() is not allowed,
> so dealloc_on_cancel condition is additionally required.
> Because kmalloc()/kfree() and static are mixed together,
> dealloc_on_cancel condition is required.
> As you pointed out in the previous email, kmalloc()/kfree() has the burden of
> memory allocation and deallocation, and static has the disadvantage of
> increasing
> the code size.  Both have their pros and cons.
> Among these, I proposed unifying them into kmalloc()/kfree() methods and
> removing the dealloc_on_cancel

Thank you for kindly clarifying this, JeaJoon!

> 
> >
> > Meanwhile I find the feature might look complicated, or not well documented.
> > Specifically, dealloc_on_cancel should be set on only dynamic-allocated
> > damon_call_control object, but that is not well documented on the kernel-doc
> > comments.  Are you saying removing it is an advantage because it makes reading
> > code easier?  If that's the case, how about improving the documentation?
> >
> 
> dealloc_on_cancel is only used in mm/damon/sysfs.c.  Here, since kmalloc
> the damon_call_control structure, the dealloc_on_cancel=true condition is
> required.  If you want to keep the current code as is and only change the
> comment, it would be clearer to comment it out like this:
> 
> De-allocate when canceled.
> --> To perform kfree() if allocated with kmalloc() when canceled.

Sounds good.  Would you mind sending a patch for that?


Thanks,
SJ

[...]

