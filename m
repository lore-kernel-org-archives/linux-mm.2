Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952E8C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72EAC6B0095; Thu, 20 Aug 2026 10:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8586B009B; Thu, 20 Aug 2026 10:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6A56B009D; Thu, 20 Aug 2026 10:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 354FD6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:05:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C81FA1C02C6
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:05:19 +0000 (UTC)
X-FDA: 85121819958.30.66DE5AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36CDD80009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:05:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZW7NfD3;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787234718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ylc+u/5RasCgGgNZnJ4+DIMEi8BfrrmNY9Qtx0gvX6k=;
	b=lCq3r3cawd/ZxCw7sdW5SywMe2BbCxGllC0weQrTgoPr0J2Gzg5HwbXkxkLyzTNu3U3Pln
	QUnMPzmk6jbaI1kDAqnH6uCPo3a8AyFGJZTQlDUXZ6dgf9SgtHcbVhZXU152VGIztKKRus
	eultev4CXSWupCy4wXYTQ+G5gxlWf6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787234718;
	b=wF7QuDZLlB4/miu3qKOHRqzuTn+YGG5NfQlgRyvDmlC80OWVZtlDa5vJNg4FWL3EpRb5NR
	0qB1OYKBRdRnW2c3FQT4AQaSQUDEDcbT4rYEFypszpFsCgaQfz9rERloPjs1mFFaK412U6
	mGYcfxvpok+fx6bX9ml11hxLCQtEH58=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZW7NfD3;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 990E060A76;
	Thu, 20 Aug 2026 14:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84571F00A3A;
	Thu, 20 Aug 2026 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787234717;
	bh=Ylc+u/5RasCgGgNZnJ4+DIMEi8BfrrmNY9Qtx0gvX6k=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=HZW7NfD3vUyrAmEEQMtgPM7Ox+7vPRIZmETPZAjvuyVGwjfWTHoX0YJFIFccaqH+j
	 GJ5/7r3axsNJJPjIs3blsLeJ2NWoTQ1BUgvz/pLYpvmU8kQRvqC7snAW7prz3VSVAL
	 KzcXXuFKEJ67CvMO3rsFSwcBGKgxE/LMArTRr6vFRbDpfv9U9/tv9GTNiC/KyFnJmV
	 UYTMBeWtDuhK7oq5U9wBHRjCHOJD44wmw/NUgcSK0Zvfwyg6zOwyYG+Gkl0C9M649w
	 R1NzYSv/zUzFJDlrUt6RnUu4XiyZG3aNyEjjUtCri9FPxhw2HkuWT6SuTJwXKoawuR
	 DWWW3BXXNmcDg==
Content-Type: multipart/mixed; boundary="===============4336261480514913956=="
MIME-Version: 1.0
Message-Id: <fa7f719852be56e25978cc87b269948179378ec6e17c5a7dd7999f20c37f48b1@mail.kernel.org>
In-Reply-To: <20260820131801.68759-2-tasos.papagiannnis@gmail.com>
References: <20260820131801.68759-2-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] mm: Add copy_remote_mm_str()
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,utilityemal77@gmail.com,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 20 Aug 2026 14:05:16 +0000 (UTC)
X-Rspam-User: 
X-Stat-Signature: qsoszrskoddkh64pewwden8daozts1f1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36CDD80009
X-HE-Tag: 1787234717-812182
X-HE-Meta: U2FsdGVkX1+MOk96YYaGFyh/xHzjq25G5Oiqvt+EEl6JvcpsloDO2rsgVgPU70SJ998amoKDNK5AKruLRto0hRVK/11QnRVaEcH46orro+GMFWCRUPtcd7/GFRQ2uLc0/Kd4QEdI/2GBOQ4jkqtYNgikcOFlfM3hOVE2CD7iJlqmIhXzulEyzwZt5zCC4pfYQOH4DeQ+jZrmmMYW/RSNX+aGb7GXBHBLgMLoY/FMkcaWNrSlzVZ6T5uFuliYuzQwJC9a6fQwUqEwh3B1BLokPzmY56nDFE2Blrp2qZaTjOoFd2S68H5vA43P6PTZUGBfkDJB6EB17XFmz6K9+Kxiv8uOmpbJllArvTURpsw2Lh+Jd0MrF4wvF430jDBq4iY59d3UCraBnU28YQuSEzTs8SWvSQiuukYfjCBEJ/aYppXSzoYqL1ipfBELsXcImmvIAmZV47DLp3JF8K2n7x9WzY/JMgq55vQefK75nYg7zgDTsDhHQEt3KHsAUbvESbpAMKE8IQHHuDZkXU3GVd8qsvgAAUYjFdcLaREI72iGUhYQLGMlYTv0UPEGYqV437Hw30AVkUfDIdsDOgzD12osGMpfVqlMcmQoaU8rsq8gZh+NdqZfMRSXwW/+X+vfkrVbv1Ki0lmC+de70v2+gcnL+2Bb7o7ZpWF1OOnIaPXqL8ot6uhZ/ydd2pqT/gcFfMZTg6d1PONGKXhhUPBfucCfawyx2LPHeDFUPgdY/43N5tatvNhSj2wnTWNLikZW7DyHYDr4AOBKH10RfTYMP/UvNcvXi7sLoZMLG1vM1HF6vBGauK9KrNbg7A5ddoOps0vRZO7P/53Qb1smCg3/vQAE4KecQtsOi8r44tRBAdwZAClqA436cs2TTTyglA5iJ3CcBEhRal6PdhsDlBRb7yOJ9ioyceqaGLDE3KFMVy6I8RqzjpLsCeBeoGhKJC14pbTg6NbKENA6lNnBJqvGv1g
 UVG35tll
 FOsOBPtXJ0DanfELwuTKeg3jT5mC7AOlLSPT7vDhTG8bg1p7MzD3sJGM6HuPU9kwgijz8hFnA+Nx65ssxDjZpzpGA2tNhWQ8VUUwXRcPNqMiyMWKIwcEEDV7nCs3KNx0XHeCgoo6zZ3OGf0L8XhWZcz0RP+1zAhG5BReZaJSzldI3Gp5j+E3vYjjv71E4ueaYAnYY5GAP5plQxa0igL3GSWeXARY0uWzFa1uQupShTPOMHsl6ASr8uGuhyrz7Fi7Wnv7olL6Z9uYoaeckr5/jwCIjmOhR96yyBprkj8mO1FVDPafyxwFuOockyuz5XYiLZYZEEV/lxYAHu4JOhs+xIlYqyZyyf9OenE2GXLXXKG82NTeeKYUMp3ck4RfvL6moJ7CZsGJ6zhRgdocwGuPTG/f9uGWQvT62lqoy9GYOBFE9cNMtrLKAPVWzz3SF9Lmf7wVfKLATgWqJrPwbpEZ9PiftLvUBE9O1c+KLTTyP7tgvqr1yy78PkizcLMuT8IFBUv4GA+XHALXHDj9HVnTrob/d4jH4tC3mMuz6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4336261480514913956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..eede435bf4a3 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3222,6 +3222,8 @@ extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  		void *buf, int len, unsigned int gup_flags);
>
>  #ifdef CONFIG_BPF_SYSCALL
> +extern int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			      void *buf, int len, unsigned int gup_flags);
>  extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
>  			      void *buf, int len, unsigned int gup_flags);
>  #endif

This isn't a bug, but does copy_remote_mm_str() read as expected next to
copy_remote_vm_str(tsk, ...)? In this area of mm/memory.c, the
established split is access_process_vm(struct task_struct *tsk, ...) for
the task-based entry point and access_remote_vm(struct mm_struct *mm,
...) for the mm-based one. By that convention _remote_vm already denotes
the variant that takes an mm, so having copy_remote_mm_str(mm, ...)
sitting next to copy_remote_vm_str(tsk, ...) inverts the expectation.

> diff --git a/mm/memory.c b/mm/memory.c
> index 6b8280cfc1db..da0010c4475d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7218,6 +7218,30 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  	return buf - old_buf;
>  }
>
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:	the remote address space
> + * @addr:	start address to read from
> + * @buf:	destination buffer
> + * @len:	number of bytes to copy
> + * @gup_flags:	flags modifying lookup behaviour
> + *
> + * The caller must hold a reference on @mm.
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destination),
> + * not including the trailing NUL. If @len is zero, return 0 without accessing
> + * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
> + * -EFAULT.
> + */
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +		       void *buf, int len, unsigned int gup_flags)
> +{
> +	if (unlikely(len == 0))
> +		return 0;
> +
> +	return __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
> +}
> +
>  /**
>   * copy_remote_vm_str - copy a string from another process's address space.
>   * @tsk:	the task of the target address space
> @@ -7247,7 +7271,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
>  		return -EFAULT;
>  	}
>
> -	ret = __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
> +	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
>
>  	mmput(mm);
>

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32375104040
--===============4336261480514913956==--

