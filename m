Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94CFCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 12:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284DB6B0088; Thu, 14 May 2026 08:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236656B008A; Thu, 14 May 2026 08:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171F46B008C; Thu, 14 May 2026 08:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 066EC6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:48:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DB9E1C1079
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:48:15 +0000 (UTC)
X-FDA: 84766003350.07.BB133E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CA9BA2000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:48:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HjjHoSdE;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778762893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kImZw7AFpaEliN4c6XXTn0LjPEGl9HL2VxhRs8oFggY=;
	b=R1iULPA0L1o5tIID3G2RBXv574QumJPhMkGBfbwljHXVM4qFNuTKgL6ctVoVxI6/Mjw1qp
	OPHp92xYtMRTaDrYhDKkrL+UGoceJvGyMTpDqzuGLSaCX64AK5gTTTZPMnMpj4otIx0Naa
	ockCQ7e9A0OSK9HZT+o068ZUY7NFS+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778762893; a=rsa-sha256;
	cv=none;
	b=jyKs0lXDxdHiBTvV0eTno2vr5du1diiK/ZxGn4ayixmnH9A14XY3qA0mdNDlwfUX9gcreY
	iElxxe6u06Rdo+rK6C2c7ZSbnAXomm7+CNANcQlDU32914vUktavrzv9Q9bCkBxP6/gT9V
	zzdCCBu31jtUMIWkwDEbZlakqN7TAeU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HjjHoSdE;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B1C060132;
	Thu, 14 May 2026 12:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9FCC2BCB8;
	Thu, 14 May 2026 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778762892;
	bh=G1DkMXq+FUFO53JRzt0zUDWwKVv3YrNEl39sArUxnPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HjjHoSdE7MEJ/k8vq4aPm8JhwINkmMtG/+qvatcE86Cy9PnFdl7OGPk5/orfoqq9U
	 Xo7HrIxReK9pIwLKp4Vb2sAWZqJsVr1ucabigzlh3cwQsxM8eHOj5ZEDUV6fOkz6Ps
	 /IMqllabf8t2AHmzU87sNFlWoPSNrgEHWIXTT3r48iF0u655NMktyFFmYEO5Bx7k4X
	 kRe8Kwd5D0bJDMg8PqGDx01eQwRnpbKbs/gYw7Dmo8kvPICmpxNzbI+4lfF537QnRP
	 7zNSHcdw966yR3NKQo1uWSfyMl7VN+fa1+FS1jz3dkACeo/gwxPnkL1H4xL/gMERqi
	 Ky3YlSIY5xd0A==
Date: Thu, 14 May 2026 13:48:08 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <agW_BR8qNsxzAKYi@lucifer>
References: <20260513094508.50888-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513094508.50888-1-ranxiaokai627@163.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA9BA2000A
X-Stat-Signature: fi8gox6xrm6q9ob9w9tox1efq588n3u1
X-Rspam-User: 
X-HE-Tag: 1778762893-423824
X-HE-Meta: U2FsdGVkX1/Zn6Eg3/IUp8wXJFntWSRwUuimNIU8W6AyKGrlBoe0RsZWVro2rUYYt5G/RgTgjfLzOAL/QQp5pTCclHxOhw58C1q0fa6qHU+d9uxlSfBgWg74po1WhackJ50+lQhIi2mPvj29QqPsDsRBNS1TC6+ZIR3+9anJrcAWU6DEpxiG+qeqQoaA/mKTqArkkImP9QzaNyg+G2CiSpv5ldOIdCvKD2W4XWkq6APW36HwrtMhYQU6t/XyHFOknDrXrkf0YElSX28O+0pplz+wXmXRGGNZIz8m24+opQTsz5Ynu3CPLipHIvxNaDo7yTpQy1gB75i2CevlLRTXFb5yilhPvv/WmTojF4UlZL24dYZu7A6nuZNQFgwx/wM3S+OI2V0XMhX0y2C40UcSWzUQ1xfuqiOQb0mXwSCNNo/JBamFwBUCZ9vHnfjMWoGDIPLXzqf1MVYLVdfH/jSlI2vwQddfwxtPF1g4TgjMVHD77uA87r1z0Rqky0+nzeSa+A7y5CdFg2DHs4ZHMZSQdCAp46niJvCGkc9ZaPpqs7uP9jtmqTd0zwEOttT1/V/KDY4Ba2Yw/0VKLfC7wBu7PZ8KAojBVyxD7ZuWOAGckEPP5o8t8Me0BV1OIOJ01ekhQTzQOGpR2+Y+rRP48uUiJ1/BjVW2CBYhMwU7gn4jJC5l0KQLSjCruIrRvdbxKs1ulgIPIAX1v8NFaTLgeWFdCA25st8d/5O3UzLs5bW8EnH4mufyzBLzozvgd+Q7XbG/G8OcLtgA8jpchdyJzUGlTC05pYa2t9Wc7/6OLqXgFNWRuHtgj+9BZDJt/n0ek8QlpsT1LWm5fxmP8Y/co8iI+rgGNwIX0GQXsfs8RiRX+GwIZXo0wnpwRa0ZbdziiObyE5Oz8GnI2A/Xf/4pBo9ERkyFI3MfFT9NF0rpz5x6Ti2jvwWm+GwVAUNjX8OcYOVKsRATuwd897EFu7HHod/
 FrPrzTJ6
 9qrf0vASK8FXx+kkzz1iu5z3RsxqLeqnL56BJgMmRQgWW4OQgHLdPmBuvM3uqRimMp9APCvjqjpcbQYwuKNCPtoZiiBYheqT3gRhPstlnN9yb2JPuSU8aNL2ZvYirHbC0KuVYSA3MPoF1ddWnoIeK++XFqFRW+h+sk0wqX9eLZBvPQk3JtAI3CkkyCNLcNtnNTttmfZE/hqaW72ivWUvPHAqHi7yv9vo3Y6jsROypbrv3ghdeen4LaLfWeIj4IGikgCASzGLOtG8Ta6QxPcflXvnNx1iWqDa9lZHfm0jTc3o6sIxSmCZClyj7PF7XVcoawlXZutuk1YXccZwEdFMGlnt1kEQDMet4fu79kTFbl5RIAxp1U8J3YIqDctacvj3PBTYN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:45:07AM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> thpsize_shmem_enabled_store() using sysfs_match_string().
> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> calls across all branches, reducing code duplication.

You are not mentioning that you're changing the stop/start behaviour. This
is a fundamental part of the change that should be documented in the commit
message.

>
> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> all test cases passed.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>  mm/shmem.c | 94 +++++++++++++++++++++++++++++-------------------------
>  1 file changed, 51 insertions(+), 43 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..60cb10854f11 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>  struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>  static DEFINE_SPINLOCK(huge_shmem_orders_lock);
>
> +enum huge_shmem_enabled_mode {
> +	HUGE_SHMEM_ENABLED_ALWAYS = 0,
> +	HUGE_SHMEM_ENABLED_INHERIT,
> +	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
> +	HUGE_SHMEM_ENABLED_ADVISE,
> +	HUGE_SHMEM_ENABLED_NEVER,
> +};
> +
> +static const char * const huge_shmem_enabled_mode_strings[] = {
> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
> +	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
> +	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
> +	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
> +};
> +
> +static unsigned long * const huge_shmem_orders_by_mode[] = {
> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
> +	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
> +	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
> +};

I think it's perfectly cromulent to put this within a function rather than as a
static value at file scope. See below.

> +
>  static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>  					  struct kobj_attribute *attr, char *buf)
>  {
> @@ -5551,57 +5574,42 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>  					   const char *buf, size_t count)
>  {
>  	int order = to_thpsize(kobj)->order;
> +	int mode, m;

I hate single letter variable names (yes I see set_anon_enabled_mode() has it, I
should have reviewed against that, oops :).

Please give it its type of enum huge_shmem_enalbed_mode.

>  	ssize_t ret = count;
> +	int err;

This is silly, we don't need ret and err (the ret is not your fault
obviously...)

On success, we return count, on failure we return err. Drop the ret here.

(I think Baolin reviewed similarly :)

> +	bool changed = false;
>
> -	if (sysfs_streq(buf, "always")) {
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_inherit);
> -		clear_bit(order, &huge_shmem_orders_madvise);
> -		clear_bit(order, &huge_shmem_orders_within_size);
> -		set_bit(order, &huge_shmem_orders_always);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else if (sysfs_streq(buf, "inherit")) {
> -		/* Do not override huge allocation policy with non-PMD sized mTHP */
> -		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> -			return -EINVAL;
> +	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
> +	if (mode < 0)
> +		return -EINVAL;

I don't know why we filter this error, it returns -EINVAL on error anyway, just
return mode in this case.

>
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_always);
> -		clear_bit(order, &huge_shmem_orders_madvise);
> -		clear_bit(order, &huge_shmem_orders_within_size);
> -		set_bit(order, &huge_shmem_orders_inherit);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else if (sysfs_streq(buf, "within_size")) {
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_always);
> -		clear_bit(order, &huge_shmem_orders_inherit);
> -		clear_bit(order, &huge_shmem_orders_madvise);
> -		set_bit(order, &huge_shmem_orders_within_size);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else if (sysfs_streq(buf, "advise")) {
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_always);
> -		clear_bit(order, &huge_shmem_orders_inherit);
> -		clear_bit(order, &huge_shmem_orders_within_size);
> -		set_bit(order, &huge_shmem_orders_madvise);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else if (sysfs_streq(buf, "never")) {
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_always);
> -		clear_bit(order, &huge_shmem_orders_inherit);
> -		clear_bit(order, &huge_shmem_orders_within_size);
> -		clear_bit(order, &huge_shmem_orders_madvise);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else {
> -		ret = -EINVAL;
> -	}
> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
> +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> +		return -EINVAL;
>
> -	if (ret > 0) {
> -		int err = start_stop_khugepaged();
> +	spin_lock(&huge_shmem_orders_lock);
> +	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
> +		if (m == mode)
> +			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[m]);
> +		else
> +			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[m]);
> +	}
> +	spin_unlock(&huge_shmem_orders_lock);

You're copy/pasta'ing anon_enabled_store() but not the nicer refactoring that's
there.

Please split this out like set_anon_enabled_mode() does. And put:

	static unsigned long *enabled_orders[] = {
		&huge_shmem_orders_always,
		&huge_shmem_orders_inherit,
		&huge_shmem_orders_within_size,
		&huge_shmem_orders_madvise,
	};

At the start of it like that does also.

Please don't reproduce the single letter var name though :)

> +};

>
> +	if (changed) {
> +		err = start_stop_khugepaged();
>  		if (err)
>  			ret = err;


> +	} else {
> +		/*
> +		 * Recalculate watermarks even when the mode hasn't changed
> +		 * to preserve the legacy behavior, as this is always called
> +		 * inside start_stop_khugepaged().
> +		 */
> +		set_recommended_min_free_kbytes();
>  	}
> +
>  	return ret;

return count;

>  }
>
> --
> 2.25.1
>
>

Cheers, Lorenzo

