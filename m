Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC2ADC5DF9D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B4C6B009B; Mon, 24 Aug 2026 13:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95156B009D; Mon, 24 Aug 2026 13:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83206B009F; Mon, 24 Aug 2026 13:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A74796B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:02:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A7604020B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:30 +0000 (UTC)
X-FDA: 85136781660.15.03F9AB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A81474000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iUNCpKEx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHNNIPLQoNO7IhBE1S2+bWd4n9+KcXQrEB8ySVE5EPM=;
	b=nzHOe155FaYn6ftL/70sjbEEv39T/iP4ASl5wE3lX1MJ19AcZw11U2qWocD2RpWT5OOXm0
	1cRhmx00FLYq/RN4bVdQd1vam4CsIUkPE1Tutss+jqaV0WUnX7xe9iLl4TDskOjfjG2ivq
	z5KAAmccF1nT53+QqMYwNKOz8CUveUU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iUNCpKEx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590948;
	b=l/EGuJ+8mvnYyi4j1iZdVadEIwOBYxbaAkjr034C/S61tRqMtQUP4gNbSukRuRp3YAL90o
	8ssUrFx7AfDdfEyLP4F2yYJw3gluoZpiZvN9h5veYgN9vMKKHfVcnZdBqWdHcF9A9w/i5g
	wMEMqh7Y9B1MLSyeUzccBfemQJsE1ls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4336F6020E;
	Mon, 24 Aug 2026 17:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F8E1F000E9;
	Mon, 24 Aug 2026 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590948;
	bh=jHNNIPLQoNO7IhBE1S2+bWd4n9+KcXQrEB8ySVE5EPM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=iUNCpKEx0Krsz1T+zlwFX9PCj9X/VmjsAwUeIQxSUgaTET4GJWoFMZWRCJnCLL7f+
	 DPBFTk6CbLrghm6f/4GsYKjvyZO/bBItjz/VfS6Sx5Vz9nwVmy3SzLT7VXO+f80gTK
	 uf0nairvLEYAJTBlNeSCnXCybWOqcKU7kDDPuitkg6ZvO+isQBFWnktOK3aHN8GQzv
	 mvlZajbpQHbWnFsSnE1P6o6pjCioF9yzEJepr2JPaNmCLqJZtpIB2NVCXU6r8zCaxf
	 45ZBwMPVBoIFs340wEIo3iIjEDlZtGXNUKp9wi0iKSYI9TVHhrf+GtwrStE7iwKHuy
	 33w9Ssflcm52g==
Content-Type: multipart/mixed; boundary="===============1703117813336268665=="
MIME-Version: 1.0
Message-Id: <828c12c509a1bd8805e32459146390e05510cc4e897ee83dcb6cd94ebbb06fb1@mail.kernel.org>
In-Reply-To: <20260824160523.3907021-5-usama.anjum@arm.com>
References: <20260824160523.3907021-5-usama.anjum@arm.com>
Subject: Re: [PATCH 4/7] maccess: Use a scoped guard for page faults
From: bot+bpf-ci@kernel.org
To: usama.anjum@arm.com,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,linux-arm-kernel@lists.infradead.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org
Cc: usama.anjum@arm.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 24 Aug 2026 17:02:27 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: A81474000C
X-Rspamd-Server: rspam07
X-Stat-Signature: n3b8o645xieacudjhnt1a46gqi66ejmd
X-HE-Tag: 1787590948-671431
X-HE-Meta: U2FsdGVkX19lww83XI+nvE6FJyv6j2z/bU/pgqZVXtDocsvikoIvGyyGFZ2j8xPq+tJsDWeEJ3FdFeS2A/N+s2q4QjXwqIFEGVWmih/Trpo7CglQbymyaLraJD7M7vlcZ5NpKzCGSNZ7Cg0uASXris14xJHcFxxF3qmhfmjIErpvD3UMcp0N2o7j0BQp7F0KPbg7EJPLYsn90LIncc56v/VIK2AKBSZXhI+X/e+Z4iHezqqAIj7ohbnTy51VeP0Ceco9vC5enh72L9vnZnv4r97sw98b8rg4Nq3dWtp68cViNDDJiKLJT4Eoa0k0W0ngcjL+SeajFjmz2LDvoT8+qf4iLAl9rx15YDYbZAMjzdtMJ7o0g/FgKyiTLDJ9M84o6kyZnQD5DzaafyVcN1k74WyLVIe63llXp7N5NDRjMm6FtRnQLyK6JnAbDlL4Natl6oSlk6lPW9i+Qggyn7MRhi+Nref5iW6LKv6ujOj1V847rZRY8NYvxPx99JIxdMRoAcR8i0WADixRCiBhgpdOLNQ35zdMAR/a4z7kLEE3/f76zqt9m0Li1folDj3FnPCelfBWuPDcrENwdP0DJ/vZS5nv9XauC+Ka1EKBdtMDD2T8RgLTtBi8A7sh6MlT+7LOYymOveHL0bkwC+1rkG93Iha4VwdnHtlMW+J2XZpBmF7md1a7diQ1yo1neaWZndnk7bC2ODgHvuO4bte0/FEQ9pMbIudkoZLvZJ6Ex9on8FwvrFQbptoF0V5sMQ7WOjZvH1XnA8Tm0hIQaMnKMjdZOCnuz1RdahmTy6iqnvWq1DqtngtzzxADnzA/EyIx5dM/WwqFNdqkip0psbK4nJoCM1siFnDu2+6vSgmTz1nQu8PKiIH4XtpKCSYYrTKu6PNZLmo1H8ZGpgeUppHcSC/AydeHGFLpyXBGuCLMNWXNAiCw/FSN4fg0UK2kUPHSwhlSvgkzqrik5DiQZbidpwt
 SymQ5Clj
 9wd+9Sa3WVDIASbyq+wScaTsRiWsdJNzzozet1rx+gbGBl6M43+GzRN/jnfymAtZCIhxS9c3TJEjIfPphIiI3IIuvFJoRHCwRc2XXYqtPdUhRC5HtwXXH25k+Y4ULYJmNQz9Y2kyJ8iU0QUesZMracWm3W4DaiomzrAhFt2tDfXyk/KKs6D7dW3TDTr/JAQ/xAqcvRpLbKl968Eiqi/U+a+vNH8cRw6QnCOXTcENEnmBzbM1FtB4JoALwWuB6ESedR70S1TeK6zsVkszZ7QSbFEqjQ4LWQprCfhyYJGu/98Y5tmivaa5FjDKjoUh5f0g+46py47MImnCkqri1o0qMFR1FxDkKK3iJXvcjrYafxuAAyKvWzNEttoT85eXJWMTx8zetUjcCZdwCT/V64zzMD3LZSKqfJjXjURlpBJ+Slu5ZJ2gfzvnG5CQJAHmsRiDOStK7J+b7H72AuCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1703117813336268665==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/maccess.c b/mm/maccess.c
> index c59a0e092d24..f695ceefe6fc 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -38,18 +38,17 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
>  	if (!size)
>  		return 0;
>
> -	pagefault_disable();
> -	if (!(align & 7))
> -		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
> -	if (!(align & 3))
> -		copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
> -	if (!(align & 1))
> -		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
> -	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
> -	pagefault_enable();
> +	scoped_guard(pagefault) {
> +		if (!(align & 7))
> +			copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
> +		if (!(align & 3))
> +			copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
> +		if (!(align & 1))
> +			copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
> +		copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
> +	}
>  	return 0;
>  Efault:
> -	pagefault_enable();
>  	return -EFAULT;
>  }

A subsystem pattern flags this as potentially concerning: include/linux/
cleanup.h states "the expectation is that usage of 'goto' and cleanup
helpers is never mixed in the same function. I.e. for a given routine,
convert all resources that need a 'goto' cleanup to scope-based cleanup,
or convert none of them."

After this change, copy_from_kernel_nofault() declares scoped_guard(
pagefault) while still using the goto-based Efault: label. Each
copy_from_kernel_nofault_loop() expands to __get_kernel_nofault(...,
Efault), which does 'goto Efault' from inside the guard scope to a label
outside it.

The concern is whether jumping out of the guard scope with goto is the
pattern cleanup.h discourages. Is this mixing safe in practice, or should
the function be fully converted to scope-based cleanup without the goto
label?

> @@ -73,18 +72,17 @@ long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
>  	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
>  		align = (unsigned long)dst | (unsigned long)src;
>
> -	pagefault_disable();
> -	if (!(align & 7))
> -		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
> -	if (!(align & 3))
> -		copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
> -	if (!(align & 1))
> -		copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
> -	copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
> -	pagefault_enable();
> +	scoped_guard(pagefault) {
> +		if (!(align & 7))
> +			copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
> +		if (!(align & 3))
> +			copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
> +		if (!(align & 1))
> +			copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
> +		copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
> +	}
>  	return 0;
>  Efault:
> -	pagefault_enable();
>  	return -EFAULT;
>  }

Same pattern here: copy_to_kernel_nofault() now has scoped_guard(pagefault)
with copy_to_kernel_nofault_loop() calls that 'goto Efault' out of the
guard scope.

> @@ -97,18 +95,17 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
>  	if (!copy_from_kernel_nofault_allowed(unsafe_addr, count))
>  		return -ERANGE;
>
> -	pagefault_disable();
> -	do {
> -		__get_kernel_nofault(dst, src, u8, Efault);
> -		dst++;
> -		src++;
> -	} while (dst[-1] && src - unsafe_addr < count);
> -	pagefault_enable();
> +	scoped_guard(pagefault) {
> +		do {
> +			__get_kernel_nofault(dst, src, u8, Efault);
> +			dst++;
> +			src++;
> +		} while (dst[-1] && src - unsafe_addr < count);
> +	}
>
>  	dst[-1] = '\0';
>  	return src - unsafe_addr;
>  Efault:
> -	pagefault_enable();
>  	dst[0] = '\0';
>  	return -EFAULT;
>  }

And again in strncpy_from_kernel_nofault(): scoped_guard(pagefault) with
__get_kernel_nofault(dst, src, u8, Efault) jumping out of the guard scope.

Does this refactoring align with the guidance in cleanup.h about not mixing
goto and cleanup helpers, or is there precedent for this pattern in uaccess
code?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32751368606
--===============1703117813336268665==--

