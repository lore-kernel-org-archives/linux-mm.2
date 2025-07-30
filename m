Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CE2C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 04:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCC86B0088; Wed, 30 Jul 2025 00:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D3E6B0089; Wed, 30 Jul 2025 00:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593406B008A; Wed, 30 Jul 2025 00:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 412166B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:28:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE833140343
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:28:56 +0000 (UTC)
X-FDA: 83719650672.10.BDDF829
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28221140008
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:28:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Pk+6pClk;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753849735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9R1UBW/b1ZuS+KhQMuwzciMhqrlD3Tzk3LhcekVZHRM=;
	b=m6MqiDdFtGpieQCUCY1oxNNa58YU2d0FQtWzuFSHofj/79sw7evisVxnL/IHUfB2n2XoUq
	PSEDbJyTsN6tjA6kJcW0x4pUQJ1D5ox9Xpdv5XsuMqRhUhbubW/AK3RBSBm0QG/lAF018U
	cvbR4tNtUbb1HeTMpyFGOnzz17LobrA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753849735; a=rsa-sha256;
	cv=none;
	b=pLhr5t/8SosCOjEBRgz+QNPMcJIDv/EA7hLDxKMv4CqjwHzqIh5phBW/+bPwokirLqWRi2
	g1E3Q/MgOrNJ6MesIwgMxHhctvj3RUhE+73yrphKXNfITXntVXimOJcCuzq/9Ufr1UhAvk
	1A6wakfMYsUPG9N3i9lX83cw1mvcklk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Pk+6pClk;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DCB345B27;
	Wed, 30 Jul 2025 04:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84163C4CEE7;
	Wed, 30 Jul 2025 04:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753849733;
	bh=drLoJbTRP+KNHfcwMqfWji3vrYtx7Ud+lktOzFvCha8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pk+6pClknZmS4mU1MOJ1z5hY/SwSk7PL3fG5Sfb4FCyLy1nTKMByt/hjWOY8muPBH
	 fPLoEVeclwMNmiWccdHkO7TjCBAyzwclglZVBcDGAKysxEYYQB0/KEiGhM8PfeZX3w
	 riQrOI3+5ZL/Vzt0Crtydp7JyomODS8/0UPV4W3o=
Date: Wed, 30 Jul 2025 06:28:51 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Zhang Qilong <zhangqilong3@huawei.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, wangkefeng.wang@huawei.com,
	sunnanyong@huawei.com
Subject: Re: [PATCH v2] /dev/zero: try to align PMD_SIZE for private mapping
Message-ID: <2025073039-confront-harmony-621d@gregkh>
References: <20250730022206.1349706-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730022206.1349706-1-zhangqilong3@huawei.com>
X-Rspamd-Queue-Id: 28221140008
X-Stat-Signature: kfocnzuyo6r74do4hr4ta184zwubb8s1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753849734-405171
X-HE-Meta: U2FsdGVkX1+/u1AkYPI5aTvTbFyIfDZMpq5xoKSNnBaYf8yYZG0TGwdhb5ihxnmpTRaIZ0hyL42LP3xqKI6cB2WAWjqnqCz5tS9SYeR0e/KR610+9d98ZeP60if6N++YKguvdjeEHo0HRDRm76GGMyzat1ayBqwfP4fVWanPsbf7c0aFvPwjb23Oogw2fj7PXZVtMIbemkMD+dyG+UFtF/16w9K2utaanAXvD/J/dzRoYyGy1gXDthGKtHKdZOQrSEmWXZ2xDmpnYGJLICjRf5fxvJ8rA7sjiIgX7wDIhjebcHU0s+hnVVLNlvqYHDuMmXr7sEy+rfLUcO0zFPEh+lu1nTxAZCpWDzn7ea2nsF2OgAJ+H0B1/KcE+FHvwUgnNkzBtHpqlFYW7DeUYqzOSJdUihOCd/jn6CAY0Ze6d7mrXt1TgZakYJKh2yiVo8pMNx1gxY11A8BWMlwqnmy5kptNys8RlgVHEZlAK2xzQccZzEc08/tZCpB3qDV+QrfjkQw1Tt8G4pQxLgRo+5Huus5ZOim0c6wVRMGj5Wtzrva/vh0O4TNxwNTmuYM8wg6olTy0VJhvSgmGs+W0ubkXYj9TkzbxTEKrVmg7lM1g9+dWoH+Pyw8LY2fiPAF0CIbTsQB5nVCzIZxpOqco/tvFBG5n/ExmPAo2FM8rnJ2uoqmkPxeP7oezJsDJMHPPZ80jwbmsCs0wrmZfHhQhxMDXXYqdp47AYatpjn4hfm7gfvkHEWnv2BqCYhPb0/MQpxXdYhE6j5JIJQ8hdOnZ7A99X/vv1WQqkY1cznhV0q62jOG9jYGsq1gFSyElXRKmvInLo/0N4ScRmQaEj+cMbBQbAaZqFTmzX8VqLiIGyVL5t9naHUwL2eGdQbpLCEw6sbIPi9z8yULOGLYAAjKSWOwUtvO0Roo3c4ZGHKiT74GcIvPk8EmCEUAPqiuzdL6xcYYhLoUpe1PAwPqMTKmW87g
 Os4LVyZC
 Z+TjrKBCgodZhGbb2t+ncI4Kh1KmI9g0kISS37Am2whxg5YV1Z8KnQcPZQxZaRpFRxDtFnDwNRomOQpaNllKF2+/+vY0mpLj0poqzTXsDyq6J9rHcZno7a5Va2qnCDMEpL6sR8MV1wrGlFAbt50Zxg6YlKs5lWrEXT+hG5cgDTmILnrHNXGg+YNXWZiacHaNVqDZ/HfSsfiE7d9jeBTS2Gdw8KTBAKd/rhB9leQAfOysloKSzX2CRs2UfjqUq6hdE7+O4KbuXOn39jl+wCwV3aPWnyr8VkCr+8c+W6oGHUmSlGEC1aVYEBE8N3UYEWlrag20KTWyjk6vka0YUB5X51NI/TRmsvj9mByo2Tf2THivLlcA8FYmMoQKSPqqzHPESY9d/AkAC04obU+E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 10:22:06AM +0800, Zhang Qilong wrote:
> If THP is enable, mapping /dev/zero with a size larger than 2MB could
> achieve performance gains by allocating aligned address. The mprot_tw4m
> in libMicro average execution time on arm64:
>   - Test case:        mprot_tw4m
>   - Before the patch:   22 us
>   - After the patch:    17 us
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  drivers/char/mem.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 48839958b0b1..3699e716b84e 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -525,12 +525,20 @@ static unsigned long get_unmapped_area_zero(struct file *file,
>  		 * so as not to confuse shmem with our handle on "/dev/zero".
>  		 */
>  		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
>  	}
>  
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	/*
> +	 * Attempt to map aligned to huge page size if possible, otherwise we
> +	 * fall back to system page size mappings in thp_get_unmapped_area.
> +	 */
> +	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
> +#else
>  	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
>  	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +#endif
>  #else
>  	return -ENOSYS;
>  #endif
>  }
>  
> -- 
> 2.43.0
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot

