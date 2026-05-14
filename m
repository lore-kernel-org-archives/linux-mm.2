Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BF1CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 12:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3416B0088; Thu, 14 May 2026 08:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CBE6B008A; Thu, 14 May 2026 08:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125526B008C; Thu, 14 May 2026 08:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F20A16B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:22:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84076120228
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:22:47 +0000 (UTC)
X-FDA: 84765939174.15.22D524D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F110B180006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:22:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ftng5STj;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778761366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+7OaBZ2j9vXfqnA8KMdCK5IFVREiPJ1SJTWBVmyIDg=;
	b=wsJhI+M5RSYbhJPpX3+xkDaK2ab9XL5fcC4rjEt/kHq5KDHDvNMlO+XXg/41x2t9lBT0lf
	LcuAJcP/f4wjE7635zODmUjHHrsmW/IVVBgB3qi22OHmwFc2fHK/iljsTkrFlnAt2+uWSh
	VC/7ufEyM37Xan4p98h7xwe+Ij+XuEU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ftng5STj;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778761366; a=rsa-sha256;
	cv=none;
	b=RdLjYsH5QLbSnELFJQhDzdiz/t43op8sbf4QJLq/v730jDMz37Mlb3rk+3g5GF1j51vYQO
	Lgts27IJ3D7n+qu3DqAvDKJ/BKF7bKQNHJxSQpV7T/dTGTL56c26naLA+nlzLbmz5h0Sew
	5mVRUbkCdZ+fGEIyqaz5ulqjYoD1knw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51F466012B;
	Thu, 14 May 2026 12:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A54C2BCB3;
	Thu, 14 May 2026 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778761365;
	bh=Yqxi9WNOyPgZenBZoE5iwSQ74FymEj/lLJ/BxCqBOGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ftng5STjO2s6+iHj2g0I612GVQ3PTkt0X7dfMBm2wU0xYyxE6wGGk9/LI9gfOwYho
	 6bXMo0/WoehHcZPHcOZBfCvCbhEhmLkvBXA/8UL6yMNClz6D0nIz0wHVH0IC5zbeZ8
	 Q38TtF+ASMr/NBV1VyczIFxmQjEvwDyhig31vk2oL8Kse+JVgq0jW/uZBqiZYNMxeO
	 U/rqQh68w0grpOhxnwEC4YcpxdgZCY0LzbTEDpXP84zmssvY8oH9V6F+QmfiEuIdbf
	 FwDtcRTz4XajzH2LFo0o96jo4AqxZdOBIVag3BqphmpAzXs9wPzUja0+0wlh4zsxkb
	 IJlz+KY46q5cQ==
Date: Thu, 14 May 2026 13:22:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 2/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_show() with helper arrays
Message-ID: <agW3KFDoBqZI7-kp@lucifer>
References: <20260513094508.50888-1-ranxiaokai627@163.com>
 <20260513094508.50888-2-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513094508.50888-2-ranxiaokai627@163.com>
X-Stat-Signature: wd54u5m98w5s87ymcbfd55orb4pqt4yw
X-Rspamd-Queue-Id: F110B180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778761365-738633
X-HE-Meta: U2FsdGVkX1+urgW++wYZEKoUwGXc6M6bMoAnGB6uomoo2vmu9HxquU8haftVD+56msMt0cfGgqNB31HQxQ6FpnDjHXfQjBG0Kv958k0Yh10HSTOGT5lw5zGfWrLlEWGFeTqUcQQSSvaIHafIPelUz+Ht4VNmWzIb2LXKK1Jxi3eiQVr/rpw75EGPSGzCSnTyOmZn8sffk96Vp1js3KUu9w27sfyndnRPqQcQOLpXOx0HNJr9dk89Qe5xNJbe1rq6dbneGFgf5svDSWfDcunID7mmWgJ6ZbikIsA/JfealwNGXBidvGwYYOjXOb1iLRWvioEK3FR8LAlaOFGdrrNuWbyOOOgcbjqrO9blJuwpHa3j7ZNcjDeJqbSlEkZdpdmx9/OF7imrSk6+15wDGedjxt7wnEJceRckU57Q/h+m9bAeVvREYS/U76TqXKn/zxYcVkPk4pTlgiUbMCT0FzevQysaKXITBVy6MIGfhxKL+cD3u5z4yCUhV3kKBBzbDsygDQVCRSljQYg1R3ZZJaVtMhI5mB4rYfnRScgzRWxsmkQuD9vZdumDR+7wJdUm0Hzs9HkmP1V4sW/L2y1KSNVmEec4+8nMqBTroVKkv/on+XSxBsiqR4jLCr0ACIJ1H5KpZabD/bJjAY0TY9MZPQL203ubNE6kHwHJRRvZErn9dzDr30MAST3MfiBhIK/IdwE0KBOvAnY74NVcaFRRBsDtB+DM62QtriBxnDBV6j5i87dWl8FwvI3QfEimBChvrFNnjFtLiDqXlKv2lDy8gS3D6iwY53oQySGo8I0i/haFUakNY5VuOBt9Ma5OCEXvErax8QhP1ULNRSQihpEhHUWa6ojIJr8W0zJS4Tgstgsn2qaNymk9kHNl2ARX4vGy6fiz6LK2EZbWRiHR2yCDEPudq6UPYPcqjyfLsibRDW6j0UlRNpoYgMUhgJ66PouXKpMqa3+U8R3rtJWyjrzi44e
 XiWTfl0S
 bDKwQaeNwAn0RhLfLmLr3t7NxBpmA2WAdp2LSMeYEo3qlytEN1sA+bS8HqLdJagvBaIP6oIPU8Nz4ulGlINAqcyAA3f2VksEX94AUtMPXWKPSZK5lb0movdvclVJ/GNPmXCWviGGhCsJL/gn1d3Q2CutuMefNqkqZa95fEbTNuDta1zdg8FiSQx+0BuVAYKgMmVf5ObB7Pn8LafhX61DeluBmKz/a4wcJIq2qhPYUnd1qjR7uneJfDDleWXs2DDlun8j0e1Hvdq2S0Du1TFkzfmpDBWfZKvSacXyf6HoVSeAYfqAoLOe02GsxvEvksPQhel/d5Vmej3RQe6W3x/E53Lz0rkqxmocxm9lw2ajuy8uBSwC5LNttf++NCH4WzVdAcLDuwu0T8cbAUNxsSMCW+adSZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(As I said in the 1/2)

Please don't send 2/2 in response to 1/2, and use a cover letter if you send
more than 1 patch!

On Wed, May 13, 2026 at 09:45:08AM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in thpsize_shmem_enabled_show() with a loop over
> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
>
> This makes thpsize_shmem_enabled_show() consistent with
> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

The logic looks good, I wish we could de-duplicate. But for now maybe better to
get this refactored first.

So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/shmem.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 60cb10854f11..086762e6de71 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5553,20 +5553,30 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>  					  struct kobj_attribute *attr, char *buf)
>  {
>  	int order = to_thpsize(kobj)->order;
> -	const char *output;
> -
> -	if (test_bit(order, &huge_shmem_orders_always))
> -		output = "[always] inherit within_size advise never";
> -	else if (test_bit(order, &huge_shmem_orders_inherit))
> -		output = "always [inherit] within_size advise never";
> -	else if (test_bit(order, &huge_shmem_orders_within_size))
> -		output = "always inherit [within_size] advise never";
> -	else if (test_bit(order, &huge_shmem_orders_madvise))
> -		output = "always inherit within_size [advise] never";
> -	else
> -		output = "always inherit within_size advise [never]";
> +	int active = HUGE_SHMEM_ENABLED_NEVER;
> +	int len = 0;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(huge_shmem_orders_by_mode); i++) {
> +		if (test_bit(order, huge_shmem_orders_by_mode[i])) {
> +			active = i;
> +			break;
> +		}
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(huge_shmem_enabled_mode_strings); i++) {
> +		if (i == active)
> +			len += sysfs_emit_at(buf, len, "[%s] ",
> +						huge_shmem_enabled_mode_strings[i]);
> +		else
> +			len += sysfs_emit_at(buf, len, "%s ",
> +						huge_shmem_enabled_mode_strings[i]);
> +	}
> +
> +	/* Replace trailing space with newline */
> +	buf[len - 1] = '\n';
>
> -	return sysfs_emit(buf, "%s\n", output);
> +	return len;
>  }

This is pretty mcuh a one-for-one copy/pasta of defrag_show(), I don't love that
we have the exact same code duplicated across two files like that.

You could write something like:

static ssize_t thp_sysfs_enabled_show(struct kobject *kobj,
	       struct kobj_attribute *attr, char *buf,
	       const char *names, int names_len,
	       const char *orders_by_mode, int orders_by_mode_len,
	       int default_mode)
{
	...
}

To abstract it, but that's kind of a horrible signature isn't it? :)

Could use a helper struct, but that feels a bit overkill for this hmm...

Really I wonder if we shouldn't have this in huge_memory.c anyway, it's a bit of
a weird thing to put it in mm/shmem.c, it's more huge pages than shmem imo.

Anyway. The logic itself looks fine so LGTM!

>
>  static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
> --
> 2.25.1
>
>

Cheers, Lorenzo

