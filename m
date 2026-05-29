Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1F7CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAE06B0005; Fri, 29 May 2026 03:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79FE6B0088; Fri, 29 May 2026 03:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C683C6B008A; Fri, 29 May 2026 03:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5E566B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:47:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66B031A0B00
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:47:23 +0000 (UTC)
X-FDA: 84819677166.20.B2E6FEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 91C1F2000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:47:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q3iCK/ws";
	spf=pass (imf03.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780040841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJVHCIKDFd/VxKvCLnBm26kmDeQyFV1KEq89/6Ye570=;
	b=ExzPwGiufHmqe5aYdJ1+rRqqaaZ85iBkdXTguQTzaamoCyV1th4lMGidc4nJN5VdahPQBs
	wIMOi/w/w+UbPq0XUzB5tytyVHSdp7d2moLXg34GY5BzbNq2DbQgVLJE2tVanQ4ALX1Whu
	ShMbtr4avPPkYTlO6rjVhYUAfWSvOTM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q3iCK/ws";
	spf=pass (imf03.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780040841; a=rsa-sha256;
	cv=none;
	b=BfaBbHmDOfB5Bo4Z+iNa2c2PGEVMgwt7iPGvL5dRBCDcE1QZiS2s9dvtgvepO0dBiXRkcd
	Uun56nh6s727UPRr7ZG6Rp7eHwZ9gAQsS7vuQ5LpTF3JSD6IjA/+/BYp7/vS78Dikn7Zi0
	fgQ96vctD9ms58yWurID6aqA0QX8BSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5531C40368;
	Fri, 29 May 2026 07:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278C41F00893;
	Fri, 29 May 2026 07:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780040840;
	bh=KJVHCIKDFd/VxKvCLnBm26kmDeQyFV1KEq89/6Ye570=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q3iCK/wskmU2X7hkIWhpJyLWwu9ZWi+sB8uvRfb3Mtwfbb9MfE7d53l8Xl5IyUjir
	 TNe2uY2hwhiCLP/zPspwKPRVJlC1Nca6dzZbDXpRBExAXDeq5kCdj+GEp/ObNTdRMY
	 hq8smDF6QuL1pZqTPk87DywtWLLLCyXlrOolOhyI5ES5MgXfUK+Idobhy8QLzEC8e0
	 eA4MURci7szOKS39N9HuAEF0SstReoNm7zOEmyLe4vzcykBCwtZaQcN6f5yHDFPXnS
	 cjUkIYroJVzjXt93zdIeqoJ5Sr06EqvnL0t3QrjhulPRd++vjLk60qbbhMLZhDM8s+
	 cVbwL0/FZNEaA==
Message-ID: <aea14426-4ed2-4c3f-a200-bdad5a5aecca@kernel.org>
Date: Fri, 29 May 2026 09:47:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] vc_screen: replace __get_free_pages() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-serial@vger.kernel.org
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
 <20260528-b4-tty-v1-4-9da9f7aec5f2@kernel.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20260528-b4-tty-v1-4-9da9f7aec5f2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91C1F2000A
X-Stat-Signature: 9y9jri4odrn8y7hhx53do8xnqrixfk1y
X-HE-Tag: 1780040841-599381
X-HE-Meta: U2FsdGVkX1+DarU/hKKL7eAK7wRwX5tMyKINmego8ZxponvQPq3FbMrS0mzgbqmFFMOTntowric7wb1JPDgTa1+tbm19sdGPx8B9ffKroP13rl2h6N/QpSr5xMiUjdN4RmqL7egprDm8h2KR4QBrvL9xErFUdf/vtQOiPb+9AJm2sAbfWc/aCDdUNIrzioD9g1KXiCoSl6rTt8TpyJgca3Mq+TFv8JZxsA7M4DKARO2JyJqzkZAfa08FtQquIbc7HkUVXz1WSgldZX6F6dW0KWWCxg9y92oGnyZjHUZAHMUwzTvL665q31UhNXCCf94jDw9Vz1mY+2sH+5Tg4bUUCb+JGT0GntGLnLStThyQzv2sCNNp9zD7vfpww5JkDIRw8sKB4GdIS+sP5G3pq2f8gSdF3KW13ntS25FDFjAG8ekOg0Hv56/JFxg/rneb1CqglY6aNBiKpLc6eKsgyz3GMA2rlymAgOczgBiDKvsSmCtXZXP6uBkcwAx3D2EzccZ3bcUbfbpDy1vjdykZJ5QU0GFePbWkoSGUS4D+RaUa3ZnuXkhMVbTKo5csLTX/CFbBJ/JrqZaDPs/jEpEaUg1dvOT/06F3Wr4kd4btOYcqhxrEUQiqGr+AGnbMytCL3MCavHIeuEFPNae9GKbQcx0cPqHDSW6f0rdDBFPn9TbJDZNzbmdzhtRiGlP6RMDf32fRqACB3gCv3yIwCrYlhrqjdt4SFfwySEeRHfLdG6ZSkwAgt0CTRKBbXkXlBPHxH0Svz9hXTv/K9xCHrcL99vxkpIgS8EnE4itkvjx6JhQIO/Jf8/3dUJrzB7acm7pizb+dfYIg14wYA/nvEn7sm+gLFMaNPlcHQvCUdszfmEH6uoQx73F/Giukq6VsW3hdI+SPRQVkkUy9Na6tdR5mVnM1PnY+QDyxiqPyguycKPBraYTv3bCtzFKkF/gcDh8IJYPRjvPKC/CEPbO4KkulQAv
 CRwFB4kE
 mBJRRWix8oTR1US4aAorF1HGUUhPv1uq9oo3KzxQ+Dt4tN9WdsEKLUBm8tj+51BTE/irNcIZQp/ZluPz+91G7hsCRs2k+rnbxwKhJr3c/9cEe9e/7smYEMfDhySRILd3KQThoiXm9TrxNeQA4d6nFVMrh3lq+J7/ZnEwa/cCSbUWG/Kjf6VO51pnf/T7sNv8/U3gE+abfaZq2GlCeHz40H3Br0+VKn8mLQ4DsQ3+qLF3vElbCTm68ww6DpGyhbx2+QgTPWrMtNk7NLhk5JKbJVcGYutg+CAiRlY8eU+y4cHuOfwJcr/HxAmn94jLlvX0gBSenTfhhCMhoFEBWIj7ufrr2YxN01qf0KI9g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28. 05. 26, 12:24, Mike Rapoport (Microsoft) wrote:
> vcs_read() and vcs_write() allocate staging buffers with
> __get_free_pages().
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and it's a
> modern way of saying "I need a page-sized buffer"
> 
> Replace use of __get_free_page() with kmalloc() and drop unused now
> DEFINE_FREE(free_page_ptr ...)
> 
> Link: https://lore.kernel.org/all/700c5a5f-3128-4671-99aa-827ca73f5cdf@kernel.org
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/tty/vt/vc_screen.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
> index 4d2d46c95fef..386c80efc672 100644
> --- a/drivers/tty/vt/vc_screen.c
> +++ b/drivers/tty/vt/vc_screen.c
> @@ -53,8 +53,6 @@
>   #define HEADER_SIZE	4u
>   #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
>   
> -DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
> -

Indeed, I don't know why I came up with this in the first place :P.

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>

> @@ -371,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>   	loff_t pos;
>   	bool viewed, attr, uni_mode;
>   
> -	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
> +	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
>   	if (!con_buf)
>   		return -ENOMEM;
>   
> @@ -596,7 +594,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>   	if (use_unicode(inode))
>   		return -EOPNOTSUPP;
>   
> -	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
> +	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
>   	if (!con_buf)
>   		return -ENOMEM;
>   
> 


-- 
js
suse labs

