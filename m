Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA46B1073CA8
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6EB46B0088; Wed,  8 Apr 2026 08:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF83E6B0089; Wed,  8 Apr 2026 08:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A990D6B008A; Wed,  8 Apr 2026 08:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 958186B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:37:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33DEA160AA1
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:37:14 +0000 (UTC)
X-FDA: 84635338788.26.0A7B5AF
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5581C12000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:37:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LojMvni9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775651832; a=rsa-sha256;
	cv=none;
	b=eIkLW0hgaPDL0e3QyUMdZcY9UynNq9O/NIpDaSLOzw3lyeH3bYtT55/gzQq6VoKfX8w6UO
	TMhI1YTl6uCtZuLFIIxhAMt6AYF73radfmemLsFGkcoXOPruQlZq6wIwwj5Es3nvP/8qfR
	QPbcTtVKe8sX27LriZu6IX1xkWx0r4Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LojMvni9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775651832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7ozxszcWAzUiiO7dnD+2XLganhUT/yvfmOrIFi0J4o=;
	b=ZhkUz/Kih/SCyuWODnVrxdeksHrDGLR6VU34uqF/L3KVZlyZy9y2Xn2RYcKjv96kkYATB8
	pSWDQdOiWy7G6jvi7gdjJCRrjRlCpLu4zBJ2VAud7qzK/INPbAcHOkkddiYeTU7dJ0lOuI
	upHfdCAhc0XWk3R2IYxLjodgBqDboVQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775651830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w7ozxszcWAzUiiO7dnD+2XLganhUT/yvfmOrIFi0J4o=;
	b=LojMvni9LRcUFivfS2//FW6d4oquvN57vihlfqSaUW5XqAUIYTV/zoRXKgzs+sk1dtwBY3
	45254wkgwY7gkR/4eSAIZrf9nWHh+UlKN3vMXpTdOgS0uMkyQqYBaMlvMVPfi/FCBpSrnq
	j6fbEfOSQU7/VVrzdgvjzRlJd3kGoWM=
From: Usama Arif <usama.arif@linux.dev>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below mmap_min_addr
Date: Wed,  8 Apr 2026 05:36:59 -0700
Message-ID: <20260408123700.1596800-1-usama.arif@linux.dev>
In-Reply-To: <20260407081442.6256-1-komlomal@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ebm4u3g7in46ik3ourt37u7sqtck5yrf
X-Rspamd-Queue-Id: 5581C12000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775651832-451386
X-HE-Meta: U2FsdGVkX18hYaGQBmwIuFqI1KPz3O+3UzvCaxg00UQ4bEKv1Z/Xaje650T6vw54c2uy7PJcl8c3e1ccrseadwhPbEsG7Fs9K8jrSK65G60hlUe74GBaBU1ue20e2IXH6HIgNum25Dl4lliFCdrvpQFsw62ADKY5qIswVyF7ixiL4q0EUWTjdtuUMO1IIxEiUR2FWBMwbo6T9i2e/VuJwkpe8rcg2RVH7aMfDNoVLYTKLS4dxzn84AWwLQz55+lvmt6op85XOD/TV5K8ne0OfPR/S1y8dZ3HFbd34kEMJ5nVnW7/GJSw8qPpNHC6v4YClQLY3VNKGst2uSKL+C1947Xv9I5qNW1SBsEgCr4IkHS63wDR9NLv+Hoa1rpcz7iFOCfKR0EtsEyYymcfZgg8yCWHG8fnIaKUq+o7q71NmneJU4j5BkeY8wteC/F6liru6nf4TE2IcUtyzOmrvXE9lZ25wQDlEwg+UyQjmk8YQKkPRnDqmMW95QYtDhYkCL8HJJYP6noWj8INY7UWylF52JC0Zq+a3Qr15CkRceU+BW5PeODDIV8NXdDICz3Oz9hzJejgSq2092ME7QtgtBOwLHpjnO68GUhNnV94fxxiMBw2t7KJijQYhoxqq/n9ZSGosHSmeS+Mwn6cAXNLXFWFkPUfuyuHDg5HafiCWRjWOs0pZSqNhrdvJiH7U0EveSkW1gUZtXqc9bOE9dzUNBeQ1vI+5bvD54kUfNl+1QTikXYuVQgEBY/2SnnncEgLuB9fhpIkvz5q5WCMIEafuoQGzv/C8IJy6kI1n/+4rXzJGIB1v3KnMKCr7DNsLHP92FKQUu7RQQBG5XbRqmL3nk6xwn/FxwhGuU2Ev8nAL7MRDZjc5T30s+ZaEYU9Cn6361wDUJLRwlkbYjWD4ah4/5jdeGjlhelxRbivLgbvqV0LCWRUOoP3TbDoIEsLIiouuRQU7AVLj+XbN5fyUB3T04E
 zw+028N0
 NHkWt+qw/7WxqHAX62L6dF4AaiG3b4DEcgnxQb0tnpgXCZRw/6xbMYgDBNA2Vz6CsgCN88MDKAU3AgAY5y2BEkS0UX2Jn2437PDea/JMchgW4hznVYipbjwyYMWu27bP+ibLkqWDxf/culbe3/Z6Iyy/8UUaLE6hhkLrs995ZiuQ+3VrGjMyGqZ+CV4CWYDjQsF6otX8if4b+AvtmIjICbo7dUiesuV7bFOmM3jMvzIkuEL8GUE1PvCuEdYjSoupePevIGyIA5OhVkZwy+3brWafHDzHwMZAUOm/L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Apr 2026 11:14:42 +0300 "Denis M. Karpov" <komlomal@gmail.com> wrote:

> The current implementation of validate_range() in fs/userfaultfd.c
> performs a hard check against mmap_min_addr without considering
> capabilities, but the mmap() syscall uses security_mmap_addr()
> which allows privileged processes (with CAP_SYS_RAWIO) to map below
> mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() uses
> dac_mmap_min_addr variable which can be changed with
> /proc/sys/vm/mmap_min_addr.
> 
> Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
> with -EINVAL for valid memory areas that were successfully mapped
> below mmap_min_addr even with appropriate capabilities.
> 
> This prevents apps like binary compilers from using UFFD for valid memory
> regions mapped by application.
> 
> Replace the rigid mmap_min_addr check with security_mmap_addr() to align
> userfaultfd with the standard kernel memory mapping security policy.
> 
> Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> 
> ---
> Initial RFC following the discussion on the [BUG] thread.
> Link: https://lore.kernel.org/all/CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh4eY_hUmH29S=sejg@mail.gmail.com/
> ---
>  fs/userfaultfd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index bdc84e521..dbfe5b2a0 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned_range(
>  		return -EINVAL;
>  	if (!len)
>  		return -EINVAL;
> -	if (start < mmap_min_addr)
> -		return -EINVAL;
>  	if (start >= task_size)
>  		return -EINVAL;
>  	if (len > task_size - start)
>  		return -EINVAL;
>  	if (start + len <= start)
>  		return -EINVAL;
> -	return 0;
> +	return security_mmap_addr(start);

Is this introducing an ABI change?

The old code returned -EINVAL when start was below mmap_min_addr.
The new code calls security_mmap_addr() which returns -EPERM when
the caller lacks CAP_SYS_RAWIO. Existing userspace callers checking
specifically for -EINVAL would see different behavior start is
below mmap_min_addr.

>  }
>  
>  static __always_inline int validate_range(struct mm_struct *mm,
> -- 
> 2.47.3
> 
> 

