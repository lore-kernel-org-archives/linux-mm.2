Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E950AC5DF9D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7062D6B00A0; Mon, 24 Aug 2026 13:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD806B00A1; Mon, 24 Aug 2026 13:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3C66B00A2; Mon, 24 Aug 2026 13:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 350F56B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:02:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2349A01EC
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:33 +0000 (UTC)
X-FDA: 85136781786.15.68676F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1FBAD100007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SN4thJ/W";
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWo8y5s7j9MJICjDRJikNnWcZwvVCVhZEXRYA5uAtSw=;
	b=YX3k2ZJMDDNfQzLNncRvicCjvBnuqg+hVMoeqGlEZ0dtn1kO8MLCJAVpu15HzYzIU+f3P3
	GU4CC/v8VTOlAEkBAE5F3UY2qrym71h4ql3qXsFv450AYDS/0wpuyR+P+JzcIZZcqg+mOP
	8zaiQo0HAahOkpzGMM7TJxigJ+w5qEs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590952;
	b=EWaQ62FZ1UmIu3lqqFQ5rbsxlaUce4fSnssOk85W1PjhU5qsn4ovFy5dbHIhOytrijAcZa
	wopDsAQMdZ4HKHENSpz1BdLHNSulVL5mxxAmf5kXj6l3ou0QDQX6ppQmVWsOxHmQKbDkOL
	59aUkrLk94U6NmsuR/RUCqOrZFhvAx4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SN4thJ/W";
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4260E4114A;
	Mon, 24 Aug 2026 17:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3D1F000E9;
	Mon, 24 Aug 2026 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590951;
	bh=eWo8y5s7j9MJICjDRJikNnWcZwvVCVhZEXRYA5uAtSw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=SN4thJ/WJQM9Zykv4pJZWKcuQx2Qo/cbzcTyvouFW/nTHLWzigGAKH1RsJRnp3tHI
	 kQX2/6D/cGd3zZ6gA+fYkHP1Tn/0ZzcosNZVPCeMg7bi95lnSfGTbuNsFOPsBkpYXu
	 /DKXz0kiwbft+9t0xjrLsSQRsHp4q5++9eRQjTeMyzqMaEvc169B7sccC/YorWElHW
	 U6bGVf3Fzpapea9YJUQiluDyvaZmSYr/3fJ7gFYuqerIP5z6GEet1hCx82/J9v16BK
	 t1SPJ4d8qwxcS+2WDRPlPl1iqEcDLptbNOHcEsQZOU3CDWKtFMbgnhKasKYwcAn+iU
	 slzdbeycy5hkg==
Content-Type: multipart/mixed; boundary="===============4795484880704545916=="
MIME-Version: 1.0
Message-Id: <9d40f172903042acd1692be0fecf4fbafbdd2c627051f38faf962015d745884d@mail.kernel.org>
In-Reply-To: <20260824160523.3907021-7-usama.anjum@arm.com>
References: <20260824160523.3907021-7-usama.anjum@arm.com>
Subject: Re: [PATCH 5/7] maccess: Batch TCO handling in kernel nofault loops
From: bot+bpf-ci@kernel.org
To: usama.anjum@arm.com,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,linux-arm-kernel@lists.infradead.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org
Cc: usama.anjum@arm.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 24 Aug 2026 17:02:30 +0000 (UTC)
X-Rspam-User: 
X-Stat-Signature: ycjg1magk7srzyxe93xuoszj4oksczja
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1FBAD100007
X-HE-Tag: 1787590951-251399
X-HE-Meta: U2FsdGVkX1/VyT8MjJERK51rnMkzvDl2K6OP15q8MfP56/Zq6PPAYGiQbHn1P9LyUV1Ktcfnwj1GzO0WQn6mLBaWbn75ue7kwjXE+ypcMHamUFEwrk+OyjX+vbO9wBA8QGusheAsv7S+mJ//o8XuVo03ipx9bMjTId8R3Biry+OJtrC2g2vMYjwx9DPIOBeFWzqjXQrBZKU8QAR7g61zcUiMSoMToip+xYqGQFYguz6lRG/OiCILPFqjGMyNJm+E4pnbOqOghu7gboM2D7N+NnOyUnRMqJxvlDsfO5S9rvlYX/u6jvn36VvJ+BvI2tNkWQFQ5ifhL8w8w/8EpWlFD2YzZLJEn/vMm7rBgNqLFjkW3v7HsGAEdW+2VyIWZ/8mLYZayWJPcrj17faUY+oeH+133M6uX+oOclwDUEg6N+7/2Fef2CvYbXXpSDzp22JZaYDH1bFYnDL0K0+3n8KyY5yto6fZDJa+8O+ORXOsMZbY5wxNBwtTERGJms4PQaIo6Lk8jgQOmmfSM/foPyNZxbjgfuAVXsePRIT0Y/QfmF3OYiVjO7bHFTFV+GlZ+iGo3qmvmKNPBYAj+bOF3W84IMM2nW+YVRyyTl92GstWzMejKuwWsJXkehDazeQQZJglGdW/eXfRhRahNKWkt5j9LdVMjvBnrsYCMYq7CWkvDme1hI9neEyujMJbXwvguNsQ0PB3tLSVsv+shzg0YOjPsoo1O49vioorjqyC93GU88JBGPpsYLZuQFsBmapIjrhrDgN2oqzMniusRj1epnqN85eAQHbKKQhY/HDOzwLJhjUVsLWF5nr++gLM12F89QxFhGtIfE6vLtXXZJMsuHQzFECRIo2u6mu06RF4puV9OuYjdEly4w7mxoW4CMtG/o2ZFYQS/dopKZbf6X7OWjam09qz3NDYnpBR2L3UwpLiIpYdxhVXRq7C6hLifxgMNlWZ+hsMkokkDQKh36w2WSk
 BlaSGhuN
 LDvembfqBvC0H9g7GGhegPVByQpC9mdSSyIZgPpYB6ZVDaiKp/39Ev4yDx1dL+ktejNO63mbhoVB/vNzT3C2BphLyuWBV1puVTRaS6c+Bx4BRQbh2RTnWLHk5F9hLIEOj8JmTTJiByxwUV7m0rAPO6cHM3LH43eatby9rBks9XF9cvKC26IR4OdrquQc1wm8qjZ4OPbUdzYayGfAof+yLdLoeJiEv7OAGr+/nV6nBbZSdKyEvw0+fK4lx7KSujAA0n12aV2Y9Xvwq0Pplq7fXfNXk0m/lN/5I+ik9vzNtzleVCo6DvBJyh5UbPgFNcyc3x0SBkL828LJk6gAEc2KAOAiN2fGo6IiTi/7khEBTPt8OW91L+0CLM6A59gae6q+LeYSDWa2fD0QU20eLxlVYwdKMbhozF2hkkCEWZVSqKuMV1rnTE+bpG8oe0LtIdchIMm753ByUkN/lmmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4795484880704545916==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> The number of dynamic MSR TCO executions therefore changes as follows:
>
>     Work                         Before    After
>     N nofault accesses          2N        2
>     4 KiB nofault copy          1,024     2
>     N-byte strncpy              2N        2
>
> The 4 KiB case assumes 512 64-bit accesses. These figures come from the
> control flow rather than a runtime measurement, so the time saved depends
> on the CPU and workload.

This isn't a bug, but would it be worth either dropping the table in favour
of one sentence (one TCO pair per operation instead of one per access) or
backing it with a measurement on a real HW-tag-KASAN async config? Also,
could the "N nofault accesses" row say whether N accesses are within a
single batched operation?

> diff --git a/mm/maccess.c b/mm/maccess.c
> index f695ceefe6fc..87486bf98d15 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -19,7 +19,7 @@ bool __weak copy_from_kernel_nofault_allowed(const void *unsafe_src,
>   */
>  #define copy_from_kernel_nofault_loop(dst, src, len, type, err_label)	\
>  	while (len >= sizeof(type)) {					\
> -		__get_kernel_nofault(dst, src, type, err_label);	\
> +		__get_kernel_nofault_bare(dst, src, type, err_label);	\
>  		kmsan_check_memory(src, sizeof(type));			\
>  		dst += sizeof(type);					\
>  		src += sizeof(type);					\
> @@ -39,13 +39,15 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
>  		return 0;
>
>  	scoped_guard(pagefault) {
> -		if (!(align & 7))
> -			copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
> -		if (!(align & 3))
> -			copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
> -		if (!(align & 1))
> -			copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
> -		copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
> +		scoped_guard(__kernel_nofault_bare) {
> +			if (!(align & 7))
> +				copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
> +			if (!(align & 3))
> +				copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
> +			if (!(align & 1))
> +				copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
> +			copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
> +		}
>  	}
>  	return 0;
>  Efault:

A subsystem pattern flags this as potentially concerning: the nested
scoped_guard(__kernel_nofault_bare) introduces a second cleanup scope
inside an existing goto-based error path. include/linux/cleanup.h states
"the expectation is that usage of 'goto' and cleanup helpers is never
mixed in the same function. I.e. for a given routine, convert all
resources that need a 'goto' cleanup to scope-based cleanup, or convert
none of them." Every goto Efault now escapes two nested __cleanup()
scopes (the inner __kernel_nofault_bare and outer pagefault), relying on
the compiler to run both destructors in the correct order. The same
pattern also appears in copy_to_kernel_nofault and
strncpy_from_kernel_nofault below.

Tracing through the implementation suggests the unwind is correct in
practice: GCC and Clang run __attribute__((cleanup)) destructors when
leaving a scope via goto, in reverse order of declaration, so goto Efault
runs __end_kernel_nofault_bare() followed by pagefault_enable() in the
expected order. include/linux/uaccess.h's scoped-access documentation also
explicitly blesses leaving these scopes "with 'return', 'break' and 'goto'
at any point".

Is this an acceptable deepening of the goto-plus-guard mixing to two
levels, or should this be restructured to avoid the nested cleanup scopes?

This isn't a bug, but could this use guard(__kernel_nofault_bare)() as the
first statement of the existing pagefault scope instead of a nested
scoped_guard(), to keep the reindentation out of the diff and match the
form used in the BPF patch later in the series?

> @@ -55,7 +57,7 @@ EXPORT_SYMBOL_GPL(copy_from_kernel_nofault);
>
>  #define copy_to_kernel_nofault_loop(dst, src, len, type, err_label)	\
>  	while (len >= sizeof(type)) {					\
> -		__put_kernel_nofault(dst, src, type, err_label);	\
> +		__put_kernel_nofault_bare(dst, src, type, err_label);	\
>  		instrument_write(dst, sizeof(type));			\
>  		dst += sizeof(type);					\
>  		src += sizeof(type);					\

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32751368606
--===============4795484880704545916==--

