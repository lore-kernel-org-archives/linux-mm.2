Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A346C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2B76B0088; Thu, 27 Aug 2026 13:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CAC36B008A; Thu, 27 Aug 2026 13:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107016B008C; Thu, 27 Aug 2026 13:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E32A06B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:29:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7633E40136
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:29:49 +0000 (UTC)
X-FDA: 85147736898.18.494261B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id BBC3D1C0005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:29:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xt5BWeuV;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787851787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jzWefjFgm0stKBxYcV7Y1ItnNNRQhMMDOv7W8UlIyA=;
	b=KGN369fmEhRttxACh23v68dxfu79Ptl8QN4fdwQl+Bwpbv1Iv1R5AP/z4zcnwzyKVKTR7L
	jQa11n2KYKCKeI0CATWi6O2iXiucAOEgvRvJQ2dY5zm+xCcnPy/D+5E2A19DZVXTyPrjn1
	kGWhEDUHLsLxXIcAuQMrnJCb5PsJLjI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787851787;
	b=KKlPXgtkqvz2LlfyQTjuvujbLuh8SRBHX3x0hD1TS3aXBmMMsYzXvWcAIQwBABPWX9tJ9r
	P1LeqX5J93iw7ITzN1cItohsx/88tU4pjX4Kc4u3vOdbqrhe0lUBiP1do2sVgfn55MZEq+
	XYCv6LjXsOxEoFbVLmaKidsAEfQcCEU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xt5BWeuV;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6336B600D2;
	Thu, 27 Aug 2026 17:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EB11F000E9;
	Thu, 27 Aug 2026 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787851786;
	bh=4jzWefjFgm0stKBxYcV7Y1ItnNNRQhMMDOv7W8UlIyA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Xt5BWeuVVReseTy1oxgnCxUEi7ggfPYT+VOtJf/UEqDOhf6wSfzPpxwF+xIvXySS3
	 sOVt40YSi/JbCXsMs9nVRDU5poclv68G1PR0Esij2fFgUwUendKGYammJoU8wYn4Hw
	 ETiGa/jXEK3nMRtgf1/OLpsilzJzOfQS24OqZLSU=
Date: Thu, 27 Aug 2026 10:29:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kazuki Hanai <hnkz.64@gmail.com>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, =?ISO-8859-1?Q?Andr?=
 =?ISO-8859-1?Q?=E9?= Almeida <andrealmeid@igalia.com>, Christian Brauner
 <brauner@kernel.org>
Subject: Re: [PATCH v2] tmpfs: fix unicode_map leaks in casefold option
 handling
Message-Id: <20260827102945.998982ccac58119fbe35edd7@linux-foundation.org>
In-Reply-To: <20260827152516.805622-1-hnkz.64@gmail.com>
References: <20260827151426.796843-1-hnkz.64@gmail.com>
	<20260827152516.805622-1-hnkz.64@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1z88igw6gkbt5qjiqid7quomrkr3nfzf
X-Rspamd-Queue-Id: BBC3D1C0005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787851787-53221
X-HE-Meta: U2FsdGVkX182359BVodHIk7ZYq5zcLYEAY3Ox7P3W+ryaLb80nrUUqWDhX6mXApEQvZhk+VkywvAlgD3uWi5P20f7SyAjKJUnshWI7mDOq15YyU/ENuzuiqhwKjuiRJwPp94vluNy7MvtNObUoC3rFvT5ibk4OcjpgriyHVylceRvrDz5T+DE8HVx0EOtmPHlF5OD4R3CsXH92MWIXK/rptP0jpHN0KvpIsNjOfnW+qXTEgyKY+Vhzmcrgc4WVeJxffh7+MCXwJunitI4hytfad4CjWofBEVWxZWyCRaW/mwxnUJ0PrUxIF8dMlBr3cBZ7l8Q4BUngDKn/pPGDi5jtSmI8Q7/2BMdW3/PadetExKh2mGk87Uvt2Bwm5znesH2buGSG7JhiLYe3JHeGyBDbTmAnegGyQsvhsECpW/Uq3DlTORXkGd8Lzq7ga9GUpu6dSh8ZgtcNAhNXogcMUYp6NC1CdHFbKSguLrMyB7yUrL87a+ID4GFUrPRAWLh71f36kdVMqJDC5SXzEYGfPW7fN2jMCwzHCKTmnywg8cBHQm2mHg8GkqJxEHCIEOxDLKm4KcxMv16aixH3OUKh9aTdEJCZr5ZzJ7Vtwf5qmxys4CXVx7f8TNJYdpUsVs6YUPpVbnSUWfO5IWqDtSEnCp3Ha3CfUl7zgnd6aIhYqQQVv2vB5kGJIWkA1ltzxpbKFUFLMgzZz/k9RJGd1tMQDVMfNf5fF0xMShslHSotxqhYX+41BoHAhiRI11yoHqHt8NVwIaRfnRoE2zyED5G73yLhokR4QiKq2PKiHdxWqjrw0dfUXyxZZ7djIk7qqcKqUoaoGGUVunRZoo30iyGvap8PnuqwhR63FblUXma5QxGT32aiL/w30/FhRhNeAC1GYbvEHMYukGutWHoZCaMsWtMurBoCzYqNUUf502WAuBHFYk8rnuREYJsFk4sPxLtbDfpig4O5+yMm4A3nEHACB
 0p9QG+MA
 gXTPCv+tKvmu8zbs5p2AvmJpl3uzzxhsxPrHVcvQBkBvJbD/ohNLzYcE/MIKQeZOAhSRjtOsmIw6XTBnyzAqOEERTuh5vlSy/tOrRy39tqjleagYq8SJJdHlbmrDTUpxVZa8Y0AFA07Ox7RxC+b7QIQFeTsfA6jRi4RQFkDarQXOiGFFzmuxS0y8ZTPpNrDbcmOYOKycgYMB6wnV9Z/X0dKdbOU85CItTbIMghsNFlEFbGY9HK6DrmT0JJltxnYSRqmLDhRqCPgNL8QyU2d8s9CJyNPNBsf4xTNRpo6A00+zHn8sRJson0hTL+qrhRxcrXqPikby+eGhHA0ITvvIrqDHaALT96/tYeE0AAgpbF1JiR8yzKt7r0YYzAqW0zmABlhoeBFK9yUbj54mX5pXGXISeYOes804YQ6bl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 00:25:16 +0900 Kazuki Hanai <hnkz.64@gmail.com> wrote:

> shmem_parse_opt_casefold() stores the unicode_map returned by
> utf8_load() in ctx->encoding. The casefold parameter can be supplied
> more than once for the same filesystem context, but replacing the
> stored map does not release the previous reference.
> 
> The final reference is also leaked when an unmounted filesystem
> context is freed.
> 
> Release the previous map before replacing it, clear ctx->encoding
> after transferring ownership to the superblock, and release any
> remaining reference from shmem_free_fc().
> 
> An unprivileged user can repeatedly set the casefold parameter on a
> tmpfs filesystem context from a user namespace. This causes
> unbounded kernel memory consumption and can result in a local denial
> of service.

Thanks.

> Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")

It's best to cc the people who were involved in the Fixes: patch.

> Cc: stable@vger.kernel.org
>
> ...
>
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4508,6 +4508,7 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
>  	pr_info("tmpfs: Using encoding : utf8-%u.%u.%u\n",
>  		unicode_major(version), unicode_minor(version), unicode_rev(version));
>  
> +	utf8_unload(ctx->encoding);
>  	ctx->encoding = encoding;
>  
>  	return 0;
> @@ -4976,6 +4977,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
>  
>  	if (ctx->encoding) {
>  		sb->s_encoding = ctx->encoding;
> +		ctx->encoding = NULL;
>  		set_default_d_op(sb, &shmem_ci_dentry_ops);
>  		if (ctx->strict_encoding)
>  			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
> @@ -5073,6 +5075,9 @@ static void shmem_free_fc(struct fs_context *fc)
>  	struct shmem_options *ctx = fc->fs_private;
>  
>  	if (ctx) {
> +#if IS_ENABLED(CONFIG_UNICODE)
> +		utf8_unload(ctx->encoding);
> +#endif
>  		mpol_put(ctx->mpol);
>  		kfree(ctx);
>  	}
> -- 
> 2.53.0

