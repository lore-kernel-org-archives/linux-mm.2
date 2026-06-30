Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86857C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 03:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484286B00AD; Mon, 29 Jun 2026 23:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45BD06B00AF; Mon, 29 Jun 2026 23:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B1D6B00B0; Mon, 29 Jun 2026 23:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0B86B00AD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:58:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 717D21A0339
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:58:58 +0000 (UTC)
X-FDA: 84935223156.06.EDA9F52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A753240004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:58:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LyAxgN98;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782791936;
	b=QP73rUE3tEy56VNebYpK5tq1/Tg7PBeF7JRgPHIP1rW8xJAlds+f16vXWpEf2TN5AIzuiK
	th0FpBDhrYdS8NNqNE/JH5mgCdyzMzRyIPalYMTY8S6pJ6uRxi87sv7fE47rf9V06KHO0L
	a5xmB6T8TCWIqSIMJPV3QWIRG+Zd4Tw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782791936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N89Up5BXPY/yDZUMYrHxzavh21D3+xcyvzN4VyJg2o0=;
	b=p9GcDEfg+azfQeRAwrAKZUoobrpAq1IqdQCgTzAjj4tT+pOAfyciDQZ7SIWVUPR7nZUuWc
	I0igtG6zUjP8nSRbjkHtIr7QQKO2eOz4C6ePMMVcEomvBmTOfcdU1IFm1TLKY/ohdkCTy5
	juoSEMbZIfJX0stwS/NpnE6Rd/snWOw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LyAxgN98;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EAAE4078E;
	Tue, 30 Jun 2026 03:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A33F1F000E9;
	Tue, 30 Jun 2026 03:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782791935;
	bh=N89Up5BXPY/yDZUMYrHxzavh21D3+xcyvzN4VyJg2o0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LyAxgN98kQZcX32CCab64mlHrDaYfRHMLVPQd4Z3hPWx4F/VUBubQdNILCdOwsGEz
	 mMkVWTgJnIG4KM7WGRIk9b16omEFl/XRAuOcUibLZDZTm+C5kTqi4OITXyCThUEuYJ
	 qiYxFdaLVl362tIBMrV+jB2QyOGfOoQHUBe+6fUg=
Date: Mon, 29 Jun 2026 20:58:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Palmer <daniel@thingy.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH] tmpfs/ramfs: Let memfd_create() work on nommu
Message-Id: <20260629205854.0062b1fc9588ba9928bb1707@linux-foundation.org>
In-Reply-To: <20260523130445.1101818-1-daniel@thingy.jp>
References: <20260523130445.1101818-1-daniel@thingy.jp>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1dacfr8ywdjdpzrbgqmxkejbicrkmctn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A753240004
X-HE-Tag: 1782791936-995771
X-HE-Meta: U2FsdGVkX1+oQyMdz+w7/RnyV6u2f5/pd2kijTdgX7/AwRv9rMbCa7qe5Vu0FOGgH4ucvofF3axrsZGTZQMYNT3fvdMOAEIhheQzMflUNhLpWnAUpqjxcFrm/0jtXlmXS3/hf18KgwRSXgdobhu+GuHHi2hjiTBFRlmQyhcCx+47LblWzXTvJg6dQ4XzjzxMqJnduhtsIBfK7n9sSOPiPYTPtH8HFwE74AC2aOENXifbYxttoincUXe3StSno3Iq1fbLHVMXBwB5dUWeEPO3cnGrwc0X/rUzcuu7AUuP348eFgVSWe71uk1PxcpqN/2Jni6NAiECqg61Rkhs47Eops7N3ywmt1Emb4SjZ9taUgRVzkNSZ1+lLzXNrxiOm3X5udpTFILR6zKKwuY2YnhuqYwLaaG5uZIE8UjpAr0Or9srbtaasceLvNZk7IOlCPUCmLEbH/00KVLGTDlwMt8b3iA7X7JbgqI1dm3yFLic1D9mYb0AeFjZOH/q4aTpw+HIzGlFgcHoBJik+7lpMsS+lJ6Q+1TH6Ux8SBKOYafK6PLTeCuDzyE7LQazkSCxIyGufW60p792TzAD4wOqooylAQw9BdC1sP9p9aZq0RO6geks2YdAbcjxHfz8SWihtuM403JvnEcLavQeZ9LdIetj1me8UM+rwKoYjSYCt96Cnh/iDpNveH9pMUr0bVtRgzRswtj5ZVbbsI2fNeFt/m2rAr7Gu0Zj/QhMjXwF13UMfH8v4hiQe++4RuDCjZbv3v8H1V8yw+19rbzaG4p/A+OWGs25LEYszVzGLS491D4wPTyyFBHKdV58uOGehDpcolZzJb/vu/X8EnudCO4/woyBjq/wmX0vtYjjNnBrq/nhBqYzGLyPdKL5lbrxKHR2i/JM1xiy4KNHaqOrEXNs7TODbY4L3zsSwGZHFh2wL+azcoUr92ukxklBNbLW9Xlffir4gZfnLhGjsg4jVBugrVA
 hP8sTiwk
 xqJFNo3O5tCzKJ10AXH5L4dh1mv9u1V3EqpUpCQuvIaqlhCtR8ueb+qvr2vx6Fq/MgAgR7u0wArPimc9iQ3si+OHHmon6j5sl75faGVAn2Ku0QEKxbXsfL4HCHRjUkIuuDfiEDnc7zmQsmxoWWzem8FUqP99jfC9wwMdqh5l3aLzZvjR8HJkQxPoT8VmXk5VtrO0yCYVtFWYFx5HAGMqJtHlxb8rB2GhBVbD19w/qbwO2WqbJTun9L4Yb9OJjM6cfI0qXECyYmmynrM81IH9b92PbW+yhpiNb0IGRK2yFN5i/x0/cWHxK4R4/ZGASpygbh3lMx5tUQBU/95i61iH3bzJ6tz6Pd9uCZiDr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 22:04:45 +0900 Daniel Palmer <daniel@thingy.jp> wrote:

> Currently trying to use memfd_create() on nommu returns
> an error with errno set to EFBIG. The manpage memfd_create()
> doesn't have EFBIG as a possible error value.
> 
> Doing some digging this is coming from 0 getting passed as
> newsize to ramfs_nommu_expand_for_mapping() and that getting
> into get_order() and there "The result is undefined if the size is 0".
> 
> Whatever comes out of get_order() is then used in the following
> logic and that results in the EFBIG that causes the syscall
> to fail and the errno in userspace.
> 
> If newsize is 0 there is nothing to do so just return.
> 
> Roughly tested on m68k nommu by creating a process, creating
> an memfd, forking another process, mmap()ing the memfd in the
> child, writing into the mapping, then mmap()ing in the parent
> and checking that the right data is there.
> 

Old patch, older code.   Thanks.

> Really not sure if this is correct. It works for me but on
> nommu a lot of things just work because there is no MMU to
> shout about badness.
> 
> Maybe shashiko will say this is a dumb patch and explain
> the proper fix. :)

Sashiko had no complaints but it seems to have found some unrelated
bugs:

	https://sashiko.dev/#/patchset/20260523130445.1101818-1-daniel@thingy.jp

(tmpfs calls "ramfs_nommu" code.  Who knew?)

> Also I had almost no idea who to send this to from the output
> of get_maintainer.pl.

I suspect most would prefer it's someone else, but this is viro/brauner
stuff, if anyone)

> --- a/fs/ramfs/file-nommu.c
> +++ b/fs/ramfs/file-nommu.c
> @@ -69,6 +69,9 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
>  	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
>  
>  	/* make various checks */
> +	if (!newsize)
> +		return 0;
> +
>  	order = get_order(newsize);
>  	if (unlikely(order > MAX_PAGE_ORDER))
>  		return -EFBIG;

Oh well, thanks, I'll toss it onto the pile and see what happens.


