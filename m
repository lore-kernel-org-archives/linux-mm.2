Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C622C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692E06B008C; Fri, 31 Jul 2026 11:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6429A6B0092; Fri, 31 Jul 2026 11:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559186B0093; Fri, 31 Jul 2026 11:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 361A56B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:11:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A554C0476
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:11:20 +0000 (UTC)
X-FDA: 85049410320.14.25F6A1F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id DFE63A0006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:11:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jD5wOdrf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785510678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qo1LR7qrIwKJFtiU17ykHkbB13kJdtxhqwfYwUfZhvA=;
	b=QCeeZEvdvOVXpUXMld8VacYNOgO8nvcTJSdn16w0lZpChYr7Yt+pat1pp785i+C/ZswVfU
	0GUz6rLn5rA/xB1QwP+FpkR0gXn0gEhsHT8890mfOGWMeUbzp/7uFt8k+8V0XeJJohN5nz
	BcP1/ygYfAvK0VLsCHoOWXkJDk3Eeic=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jD5wOdrf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785510678;
	b=ZdWQcVd1uE0NsQY+WuCPvufmS6X/HM8iXRt9CJsoebUCT6c3ryF9Cve37UFnK6TDLDo5Ml
	6zCrsYoCkSijz7k6iyBygv7qICFF1iXclX1UwtBekLFk8LtLSaOnqRu7b1K46n4q+ihFNL
	3aSGoOXi0XJzkpkAJmM4CspFWE3eozM=
Date: Fri, 31 Jul 2026 23:11:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785510674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qo1LR7qrIwKJFtiU17ykHkbB13kJdtxhqwfYwUfZhvA=;
	b=jD5wOdrf8h5mlWbkWIIredTfjWIAiJ71znqBSjQ7zbpML8PWy6RmmcRGZa7BCDL9qZfsqO
	uttlq0r3C6Ao7WiRTJedjWVOP1f4x8cSC63BJ6wDixAojIUP2Bczt0P/nV4vsRWngQ7EiD
	bDcZFs4H/FkW1LFUeXED4/+7zqbkY44=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/swap: reject swapon() on filesystem-level encrypted
 files
Message-ID: <amy7Biucbf-et5O2@MiWiFi-R3L-srv>
References: <20260730184853.48347-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730184853.48347-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DFE63A0006
X-Rspam-User: 
X-Stat-Signature: fiwghqp8zcb46m1m6upqyts3ed7h7t9o
X-HE-Tag: 1785510676-173469
X-HE-Meta: U2FsdGVkX18Hnq71/Wtd4+DIupBhyjQU8o4cC8TtodFyh45V8WkEYhsBhBTBYVu8CxjbXWYySo1ExRxNx5e/IldFTCNVwzEc+5Gb+iw+yaW28lbI6DmKppN29b/2MAd3rthJ0sJlsrbUtWb6AERpQU/44aHZ3qn1FtODpMk3z7kS1uJvFadI+jI6+HYMGVvDYY393FIuNY7uQHiA9RtSkhel/Zf5QLTgM04XyXdmL7IX49F3Z9bfDIlXNg0O7e4b0DdfReUZ2b6v7bFlSJiDb4rpOumrx0c840ycJ59CYMF1UjDohMGzfXMpMmuSMU3qjt059knrlDBeT/ePRSnoRY4fvCgYTRvsyxdxlTgPbgLRGPMN4dZsUuBVMjYsh8So7o0JTcXj6DyUCjfu+9JR6QLIxzpBR0xjUBykyFANIDUuV8h7jrzroz3x7ZLEqkgEXYk8Z8GqwQrzxrphaviyD0qF7EAMQ7zXV6AmPmhbA44ZrfiSg9E6iE3K1Heq7nZu0tSbA547h3uXW4XYF1UE+VKoSHzb9N/vkyEQib6gZhSIcA6pDVLHXq1ijlfd2TO6ooxOn6F9z5rOkkgjJmxHnHvWYpxGCKP8leSseNnSIX1zelsTG/XBMflEPoIoQeILuoQyFOm5JnKMKtaN5glKbg7a8piFweED4HSnRcuXQ5OXgaRvNbxTNYmBWdCveMnrWSLwSYw50ghg/5kefBwXwZP3qaLWfZFrbAwLP3bqntkl4sHdWsgpWeAfgeVz4W9xezxc+nO1aZoRD8o42Tz4IQjy+hdzIQdr3v+bUIbhtp1MR98jGQf9CteN4w80EmqI6U3dL5EtQ0xNtVwAlnqSGgsM3/0IAru8VlATmk/bVMkJowOfMuX3pBdzh2zm+N66cEmERAWgikJglwZU2yb06YpPF9IaRgiUBFYWpw5NY4cpHktQgyo7I3MIc1mOYAHii5LlPW+Et7tRP+V30qc
 ko+E78Qi
 IL8S2PCswsFOoCdhiD/x7SPH8iXyuq8QH9KWf3yDRzCGaSh11xEmldxTsY7XNmHIQ5hcFgd9G7OFG9RsIZ9RPIhT9LYBWklJRy9y63WNM2ngYTMCe93fhofQWu4oZPl8yq7nGP1Nx/jXyu8V+4/6T/rES7x51qQEFUFsCfRkGHGF+UG84tPv1DYf5UoHVV9lF6qh1FyCzbT9t2Fc0c/QtUJzQXBc9y/xQt9pxRKFiXsphysofzLele98BQU7DEUBfk40J14VV2P9agQTMVVrQyw9B+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/30/26 at 11:48am, Eric Biggers wrote:
> ext4 and f2fs don't prevent filesystem-level encrypted files from being
> set up directly as swap files.  In this case, encryption is bypassed.
> 
> No one should be doing this, vs. the methods of encrypted swap that
> actually do work (such as swapping to a dm-crypt device, or swapping to
> a loopback device on top of a filesystem-level encrypted file).
> 
> Nevertheless, to prevent user error, make swapon() explicitly reject
> this case.  Document this behavior in fscrypt.rst as well.
> 
> Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  Documentation/filesystems/fscrypt.rst | 4 ++++
>  mm/swapfile.c                         | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index c0dd35f1af12..cba1989777da 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -1238,6 +1238,10 @@ astute users may notice some differences in behavior:
>  
>  - DAX (Direct Access) is not supported on encrypted files.
>  
> +- Encrypted files cannot be used directly as swap files.  To swap to
> +  an encrypted file, set up a loopback device on top of it.
> +  Alternatively, encrypted swap can use a dm-crypt device instead.
> +
>  - The maximum length of an encrypted symlink is 2 bytes shorter than
>    the maximum length of an unencrypted symlink.  For example, on an
>    EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 78b49b0658ad..e4991da81b5f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3650,6 +3650,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		error = -EBUSY;
>  		goto bad_swap_unlock_inode;
>  	}
> +	if (IS_ENCRYPTED(inode)) {
> +		error = -EINVAL;
> +		goto bad_swap_unlock_inode;
> +	}

Sounds reasonable to me.

One minor suggestion: it might be helpful to emit a pr_warn_once()
explaining *why* the swapon was rejected and pointing users to the
dm-crypt / loopback alternatives, so the -EINVAL isn't opaque.
Optional though -- the check itself is what matters.

And this patch updates fscrypt.rst. Would it be good to also
update the swapon(8) man page to document the new -EINVAL
condition?

Other than these,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>


>  
>  	/*
>  	 * The swap subsystem needs a major overhaul to support this.
> 
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
> -- 
> 2.55.0
> 

