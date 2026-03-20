Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E27C108B8E3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35026B009D; Fri, 20 Mar 2026 05:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABEE96B00A1; Fri, 20 Mar 2026 05:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD236B00A2; Fri, 20 Mar 2026 05:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8631D6B009D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:51:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D7B6AAEC6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:51:08 +0000 (UTC)
X-FDA: 84565973016.20.34D74D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 95CED18000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:51:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rMPsxpgs;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjgtmC8zyOR4bRj2l2NGVlW59gVxzu2WKl5FiMk6itc=;
	b=jL6IMfepKyM+7OBbKBCswadXWlTQOUrGdpYGWogYGolbpx/wR4aZe8awkFaK963IFrnha0
	h0biaZ/zYrVgaa+6LqKWtUI0j6SCLNEGcGYNKGF6BfjooB9luHu6Muot81EOhVKNZsUcR4
	lJsXinz76GLwXzRoYhBCYtouwvphSOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000266; a=rsa-sha256;
	cv=none;
	b=EX+mPIlVhL3yQVxOfd+xEJYbDNsmSZJlsByRJjmkBfdsi9OqTyTI3aZjASL3fnESKsLQMK
	NhBhuHVuXrM1s7EWkSK+pxyoR1SrSUIjDuz7IDbCLMoI+smNWoIP7xCoq3pjdEuyZZE8Pp
	qIUmd2yvZnLex/zJAMv3M8QoVRHAIn0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rMPsxpgs;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65700434BE;
	Fri, 20 Mar 2026 09:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CCEC4CEF7;
	Fri, 20 Mar 2026 09:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774000265;
	bh=81ED6+CgUpFcKBNy6ByLtr+aptKTAvmkk3/Ukn0gmBc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rMPsxpgsCBHeuSgg8qY2Nz5pukutxWaiDYGQcI8hnuc4CKW3hbM/84G7qvfdfQVP5
	 pVDoYK8fMY4hZg24c21XfgYxEpgM27VBOp0wIiwgHXcAPfzVDGAY38TPXXTXBWIeij
	 JBgDhp+/ACVZmcXT02rVd+58+yXvzL8bzNXrSPf/rhm472rkuzJdVBvNkBnA612yLW
	 nHq3889haUH144daGOm/be8BWQRv43ij4lAF9lAZ0WOWyojVZ9JyqElQErYU53a3d+
	 NqEA8dipIZJo++E0/yfqpjJyYntl5/lAUK2kWV6Kwg3Gi5GWg7HyPz0uVazhKZOG5b
	 UJ5nlmiSOWKLg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 3/3] mm/memfd_luo: use i_size_write() to set inode
 size during retrieve
In-Reply-To: <20260319012845.29570-4-duanchenghao@kylinos.cn> (Chenghao Duan's
	message of "Thu, 19 Mar 2026 09:28:45 +0800")
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
	<20260319012845.29570-4-duanchenghao@kylinos.cn>
Date: Fri, 20 Mar 2026 09:51:01 +0000
Message-ID: <2vxzqzpebzi2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 95CED18000C
X-Stat-Signature: 93uwmtayrpadppkgnmq5pbhhr9rf9wk4
X-HE-Tag: 1774000266-310755
X-HE-Meta: U2FsdGVkX19vbuDxHjqSJS3v/UB1tUeQDO7uJT6u7ECSiVPqmQlZ0PPb+Tbe7Wj5gJu5YRodTnzZWQ9IkPycnr8Occ24GuqcHYNYP2Un0QwLqItGN6uiiDI8s3d1/mbQC630KdEIEEexN0UnwQCV3HFa05f3mrHhLqCxSjbIz3ieVQHewaxarAPMsybUygZ1Dp4xGU/cl8w7dwZm1wkPHGukQu6zZhOO3GPb99gE/4pm3lNjcpjA+KQhABkTYmax9IAdhnGuDb1VIoAEBzr4i3CLvd614ey/IhZKWi/A4M4nM2gsk5gefcXJfLXgMR6FoBwNZWqqXhmByY8giWHtdbmPCI90/jeAU2r0fn72We2MNouqBxoMgDNphh1FkIy9PaJovTW3Y2TrlMYEwXKTrdMY+aR4WXLMATqovZvO6381w4rS5wWmyRiuMhypx9J4n79JSJmDk2o886STkD07CjsIP2yUEcEIv5HGjjMmtF6+BGw6Gizgwsc+VOpx55+oqCGflDXMc8SLAwvrsO0FSq5GJE1fvkrMDv/ssSbaCJL/FQYcqqx7Lw2OZ690lQ9Ju8ciyRkowj3kbc8XhUh7BmL1Kx6u/xhM5atFKBtXNUcv3ADuAWuwGlqlVHyg1kmMVs7sTcj0TdOUKdhHYwACFbOg6vrESzFTS8wUejF9VTUs4uotVfAjs/2Ozxhu02gCNa+8ouiFkzFLtk+I9YnTV+iDH87S7JeqEiKWwTkL9uW7lPpNIRg+NNlH0kpeNE5/7hMgLZMpF9/6gstjViKHIb5E+BLRxZisJTj/zDhk1OYkgM7+EShIMQNKaagQteGdiMGckBUh1Q3i2jrvf8S4OGkNxeo6qv7HD27UiV/T7jJ6+CLyEbhcKzOTTEzO/djdH8rz5IvK2Dr2YF3y6/xmFVXdZHPifpNyqps2l+wksL0zLkPIuv9yUHuadZgd9viTA38PUiPNUqXS8KXxn25
 UD3X+Q6w
 LS7YdHABlY3cdo1x7v5wDqQyxrhNeG192F4QW0sItIL1v7pdY6zcLgR1MileNcNb49K1DFVwUzXOOpfDDZM6JIoAvGTkQzHFB1cSVErl2MmecP2b3m7tEw+UqLnTpijCa/d/4qI+WtkQmvkSAa8VZL/axWUwlAMXxMyIsNzSwk9w9ceg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19 2026, Chenghao Duan wrote:

> Use i_size_write() instead of directly assigning to inode->i_size
> when restoring the memfd size in memfd_luo_retrieve().

The commit message can be improved. It only explains _what_ the patch
does. Readers can see that by looking at the code. So it just repeats
information that is already there.

To be fair, for more complex patches explaining the what does make sense
since it might not always be obvious. But what is almost always be a lot
more useful is to explain _why_ this change is made.

I intentionally assigned i_size directly here. The reason for that being
that no one has access to the inode yet so there is no need for the
smp_store_release() since there won't be racy accesses. So my first
reaction on reading this was to check if I missed some sort of race
condition. I don't see any, but this is exactly the kind of thing the
commit message should say.

So please, explain why you made this change. The reason can be as simple
as "for consistency", but there should be one so reviewers aren't left
guessing.

>
> No functional change intended.
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>  mm/memfd_luo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 413df8c75c1d..5e5971f25c68 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -500,7 +500,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  	}
>  
>  	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
> -	file->f_inode->i_size = ser->size;
> +	i_size_write(file_inode(file), ser->size);

For the code change, I am neutral. I don't suppose it makes much of a
difference, but if people think this is cleaner fine by me.

>  
>  	if (ser->nr_folios) {
>  		folios_ser = kho_restore_vmalloc(&ser->folios);

-- 
Regards,
Pratyush Yadav

