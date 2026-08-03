Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37EEC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45E06B0092; Mon,  3 Aug 2026 14:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DEC6B0093; Mon,  3 Aug 2026 14:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C335E6B0095; Mon,  3 Aug 2026 14:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A38626B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:41:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44355407C0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:41:46 +0000 (UTC)
X-FDA: 85060827012.17.6A013C1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 42084C0005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:41:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K99Ctjpq;
	spf=pass (imf10.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785782504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhKBhRE/Ogt+aoCiMYP5CpFhC51oTVXTWdgXC3JbEJM=;
	b=DgiY4rx25zxIdTeqxR7YtZH6pLoko051oN0LyHEjSjXJMb/J9U/zPA+cyJSeDKF+4iP0vv
	t2ilnRErA0VPQyVHWQghO9UsEUVkczfZf7JpErH0yAdlJsHdMlCX6SWlTqM7CZhgnqJIQ9
	y5mGFxu/eRjGpXuiCO6/Mfa/4jkXpD8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K99Ctjpq;
	spf=pass (imf10.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785782504;
	b=jCqc/WuYXo9HASD3rmMsUWVa211yOUfcTovBXjIzZQ3LRoUpV6KwxwaxOUGLfql2qFXUy+
	Cna9kyLY4Ts1yLB4zoEHLbZJ50yzkSHIeNNW8dbt+Fio8R3KDRp+U68mO3OjN1vAnmjERa
	29GspNnJ9MtfmuxREuJFZt1G8YjnOvI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31A3F143D;
	Mon,  3 Aug 2026 11:41:39 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6860C3F86F;
	Mon,  3 Aug 2026 11:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785782503; bh=uiQBz3mOQUpgseZ4BF2zQ1KUX0+aXrmMQaRmZKtIEvg=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=K99Ctjpq6y2hlz37u/iCbCYcWjnzA7RxwykGj/9EpUCw2VjHCOE67FIFoBWO9wTRV
	 jV6Nl4jQzuxB7a1/P1/uoWW0JENbjsv4wt8f0lUV/84T3HhUqwHK1BNJTLlmE8bYVF
	 s414pYK9IjtKApzagQxNFMgK7hZ43MgCPl2cGAfM=
Message-ID: <c5edac70-59f9-45a0-b316-c1d987a18ff4@arm.com>
Date: Mon, 3 Aug 2026 19:41:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 stable@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2] mm/swap: reject swapon() on filesystem-level encrypted
 files
To: Eric Biggers <ebiggers@kernel.org>
References: <20260803180426.3123-1-ebiggers@kernel.org>
Content-Language: en-US
From: Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <20260803180426.3123-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 42084C0005
X-Rspam-User: 
X-Stat-Signature: zmo5reyk95okpmcfamz3r6sgb9fz4pb1
X-Rspamd-Server: rspam04
X-HE-Tag: 1785782504-914725
X-HE-Meta: U2FsdGVkX18J0bjIBMIur9hn7rQA0zXmPVvJGQ6Y1r0w50A2RUqTK84CBy7f5W4QLDI3NTxGJs6Ah99NLnZ19GH4nm8sm3UrNT0h0RFJS++0MakJ53Pj1nfJHNRNId2Ygm5ofug5BW4EiKYJnvrOiiSLCeNu1Se6fUKd5uukJ5E/XE2agjg2lRHerX1yKTf1ivp+mCer32nNA+jpAuqON52VDtRLVfDov+sKsXXyBHbroMBsl3DEHRkA9aSDDxKPmbro8i967G3rqzZ7dZ4yAH2g0cySbCI+4AT0escY8by14QfedF+JZbe6kY71m/0SdJSNTuJQ72bk9y0rrycIXmknA1YFmxx2mLf5IJEH0AMxdVwMdijCku/KK6YQXVb5/S8EQudzJSxNwMApdLZq7YifvjvKwGb1onm1Lcm7xyOR9paoA8YUR5NVpvKl++syqAT+ZYKhr2XaxExQSsUP+UC3/ui6qqft9uPoOVmOyzte/AOl23O49xhPaQk2hzSOAQHLDJpepRGgGiQHW+dGpTa1v0/TnsnVunZ/fu5M1gVwC6IhTMtbxspCzNI319KLDrOaCjqxkIg7UzNm0Tqg8uPtcSkdOF6bYeJAuJpChLCzx+MSyMQ0B/9I+fwaDWfkV9l5Ql8KjV2gBi+9SKXNaewKjpMn6dtizOGGTOB4i29rt8X4wiedKjYdIQTON6ePJjEOmSrLtgVlQ2WtHnbGZQkbsmi5AqDfb1hZtOZ0j5sCkMbkUc0DRYeifeSNvPof84I3z5QzQ0g6X7dxZPrSf8WlnsA5x+DdXukbNdP6D/Q8OQ7DiWDZAFGuKp4pVm+4V3FZXZ/0d+AuQ7MQFlmnk/HQde3Iq6XuKBSdB7LPn9DNG2xTWJu/83a97y1gPdYD2iH80f10K+G5hF8EFtYReb5j08KlpeWdVoNgA3r23WZuGW1kJsDUyCYgEOGh/tp0SE8AEUAc6UsSw//jLrC
 47r740J5
 BRgNm7t6NhM+Z2X9wjNHFCF2mcM1yTTQPEixMzRhrenF2QadvlqVU93n76fjrwHjpStlx1E/OTSrljdX9VN160QJ8ocaV19MFajf2MXGn3CRMKG5SSPJjEZmzZ5/nTfrU7o5qU7IiuzfcW8UcVTW6C6wD6IdMpvNFq5cn2jiE45Y1Akawc1tgeMTpjn4xuOT1y56F5yGPywzxrZe8+FuHxmxVuvNuvDY/zCKxSPtSlSghcv9mnBhT2T3g9quPqYBaUM4/1cUVVE+IVb/k5t/j1XkuxiVLWm10r4DQIpOsQhtRueE0PHK4kfj5Y5V0mWP0LZlt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/08/2026 7:04 pm, Eric Biggers wrote:
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
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
In the past, I've certainly setup swap wrong. It'll help:

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>

> ---
> 
> Changed in v2:
>    - Added a pr_warn_once
>    - Removed unnecessary word from fscrypt.rst
>    - Added Reviewed-by
> 
>  Documentation/filesystems/fscrypt.rst | 4 ++++
>  mm/swapfile.c                         | 7 +++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index c0dd35f1af12..e4882b73120e 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -1238,6 +1238,10 @@ astute users may notice some differences in behavior:
>  
>  - DAX (Direct Access) is not supported on encrypted files.
>  
> +- Encrypted files cannot be used directly as swap files.  To swap to
> +  an encrypted file, set up a loopback device on top of it.
> +  Alternatively, encrypted swap can use a dm-crypt device.
> +
>  - The maximum length of an encrypted symlink is 2 bytes shorter than
>    the maximum length of an unencrypted symlink.  For example, on an
>    EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 78b49b0658ad..8538659acb9e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3650,6 +3650,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		error = -EBUSY;
>  		goto bad_swap_unlock_inode;
>  	}
> +	if (IS_ENCRYPTED(inode)) {
> +		pr_warn_once(
> +			"Filesystem-level encrypted swapfile '%s' is unsupported. Create a loop device over it, or use dm-crypt\n",
> +			name->name);
> +		error = -EINVAL;
> +		goto bad_swap_unlock_inode;
> +	}
>  
>  	/*
>  	 * The swap subsystem needs a major overhaul to support this.
> 
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff


