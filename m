Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20730606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CLLeibpO
Received: by kanga.kvack.org (Postfix)
	id 1A8F76B0798; Wed, 21 Oct 2026 16:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10AF96B079A; Wed, 21 Oct 2026 16:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C006B079B; Wed, 21 Oct 2026 16:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B38856B0798
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:30:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13DE5160697
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:30:25 +0000 (UTC)
X-FDA: 85347776010.24.F2A84C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62463100007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:30:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLLeibpO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwBkRONY0CxUKcgJBta2oRbm5jvOfx9iSukmJuTzqv4=;
	b=Urmi3NFYu0rDlpM/nPNJecMa8iDn/uRUh5vYE8HyYNPn1OEgesDMBhyF5QizsVnFlmSsou
	r0qy3Os8+YcTb06j2ystbs6lbbFwGuxzaVjUjhmYKenxmSRCAlj3IWPkw3k/f2TwoGKEB9
	UMHFuMtGTThgTTPmHnPi8KJi7dj8kUg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLLeibpO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614623;
	b=VyxAfzToWIe74VmuBFc2DdUu9VoTK/7/uLpqxCc2wBkuGJacAlXUCGtmN72iWZ9N0hgwav
	GTYgF8ke5NXNA2d/PgCrFsNCz5S+fGaDIGTord9Q8sjrJUFbSzcfLKjgaZYgDFBNeIgAcP
	x3JN4I1XXKiqtnOmJR1rkBpbzI7T1IU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F5DA44515;
	Wed, 21 Oct 2026 20:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025CE1F000C2;
	Wed, 21 Oct 2026 20:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792614622;
	bh=uwBkRONY0CxUKcgJBta2oRbm5jvOfx9iSukmJuTzqv4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=CLLeibpO1keZ3tdRCvObTo1eEBK7tX6BN0OuXHfZaOGjHJtoExLwKdBOgi2bOXNrs
	 oVkQDSP7i1F/+PQbm0pGGr2VjSSEL/gvzz6ZZvHEJ7xX9WSihbVM11b7b73801RMW+
	 lRTD5UZaBxie7jPyczwPF60WZ8Bfx6dv+BjXsZZVgKBIspEyIh/vt7C7W4F3RnJ4Qj
	 vi7NdDmf2zXv9YPyNAPmIYNaygBi8inTgK6uoacsjBLio5WoruKGKuVuUNl+lQvaIW
	 lKmv7/BI3oVLIe9xbOdctGsoWyr0855n4mUEJtlf02X5aZC9CJPmIbTt5KLnUnDgcT
	 ZPXpPc1yr3S3w==
Content-Type: multipart/mixed; boundary="===============6870614147643086696=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <ee17ec2f4f03fc7b762617b22b31286cefc0e3eaaacb6b89e2cfb559b0b6ce6e@mail.kernel.org>
In-Reply-To: <20261021195759.119421-4-jolsa@kernel.org>
References: <20261021195759.119421-4-jolsa@kernel.org>
Subject: Re: [RFC bpf-next 3/9] mm: Expose locked mprotect operation
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,linux-mm@kvack.org,akpm@linux-foundation.org,liam@infradead.org,ljs@kernel.org,linux-kselftest@vger.kernel.org,shuah@kernel.org,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 21 Oct 2026 20:30:21 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62463100007
X-Stat-Signature: unb6pmihwhd4mr5oqpimj6am14a95m59
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792614623-986272
X-HE-Meta: U2FsdGVkX1/hqwhIT6mL0uZMptnBQ4w5yEmGi6DIL6Dt8+g5EY86Wep1Qi3RGNJxd+MzuDBTc/xhWXafeZeBKXbUO4uas9qsBC1q/i1F6y2QUbi10Clc4U2sJtowput8YSU7k5wnB6ZUbDTRVT6sUpx/tpJxtMx7ePSJJj8zj8gHROduWyIkDfTn4C1usGk+TAiKeBOTZzMcj4eTcAmzBwMXhFf5Qds5wGeosaccSYA0LUU7rFiTVSsHsWYY8cmQnk6cGwAbY2x7+YjPcW+mDR1pl3bSmRvtmpS8AX/s1s4jcaREQf0gvqJz8EOfZmi0DZ0eBRYKxOBysa18JbbmOgilt7ThpRyII4cvUWcd2IqY2mystyyfGjsIbtLlEOVzUJZXzHvNJNt00aqjv1mnUh61fUvyddFY2NLU/7ScMLt3banH6jdD7ANlXQNQSxB9HZr1WxBLl3B8f7nxWeOBX3Nk4BMAwP6oZsBcojrXXd+6wl6Zcfxtpwt3E6Qq9LOFEuDL85pKztZRY819V10VAjJ/4MX4tgIPXBvhouDhy+oVB6zD4RbyGI1upb6e7Rq7IpCTF71lZHYA0l6ubGd0WzdM3ufapopJsw1fQMp83AmI6a1ff2FzygI9Qf1ZP5X783CjZ0PccPvl19RHKf5tTRa+JD9/6MrHaleeKygMyRUXhc96YFZF1LqLhl7FxbMRtFuRVS8svmS3DvPZJcqnWMCz8AtEwRgrL/iPGPiSvsFx7DOVQ4piwUZV2wQOb+9Tkh4JYVAyQ9bYK/5IiGgG+F4iNs2ByqUe53ZrKGD5r5xf8avh4KpKRyqrdfiisqWX1rnpSjVnduZQQCc22P4Vz7svzpkF9XB+rbSWYS62iOv+qDfNUzdaF5qpsfMcuSqVznvK75u5rg/tua7cLKb2ZgVwsCzx1GkuZDu+e3/nIY9gi3L+YBGm4qhdQ3bvstxMWXwMlnfTprbT06PD9aQ
 ySXlGqk8
 HVhM5tczpf/d0Gm76C3mvbL9lo0jUiT7w5DpaorgLZztyMFoOqBX5v54TFOoWuap+3wRMvzvUKar5PHTRxCaetgR6iUZxdmR3FigN5b+V0nqov9RINwHUjiu5g6y747urB1Fe55Si+ilf+YoBp3MyZRtAvoT4m5j6MpeoxcmY/o/X49fBH2fcl8D+25M27DGybryNPLOSvYzlQLoj0+vju9FrlR/KJe0MJdEqDuzKSCfEMQJQG9hyZPk5wLFDwULUkq7dfOfOxQM+q8tRXlSXfMIrpT5Nmt43Rinlxag7yRyq5Vfbl37R9b1bm0fXP5Vu5UkB4NYHJU8BOJHCkCO1rYvMvmLM+1evM32hECQhbz6oWcQSM2kKfrn4yOs+Sbn0LLyWPAo+QjanwuK/Ab1w1fs8Uk1GTzrMkv2wTQw1VYJDVNLpxUw6yLTCBbyVQVX9wn0FwORdowgsdxk6dRXIIxqxw4u/u+So7nwiYlEAcwpZk8vYnbYLLq9i/kCnHHTzNd16ZeqwcNBoU6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============6870614147643086696==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mm: Expose locked mprotect operation

TL;DR: do_mprotect_pkey_locked() has no !CONFIG_MMU stub, so once the next
patch calls it, CONFIG_MMU=n with CONFIG_BPF_SYSCALL=y kernels may fail to
link.

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 63f40e615754..47e853093601 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3435,6 +3435,9 @@ extern long change_protection(struct mmu_gather *tlb,
>  extern int mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	  struct vm_area_struct *vma, struct vm_area_struct **pprev,
>  	  unsigned long start, unsigned long end, vm_flags_t newflags);
> +/* Caller must hold current->mm's mmap write lock. */
> +int do_mprotect_pkey_locked(unsigned long start, size_t len,
> +			    unsigned long prot, int pkey);

Can this declaration lead to an undefined reference on kernels built with
CONFIG_MMU=n and CONFIG_BPF_SYSCALL=y?

The prototype is unconditional and there is no !CONFIG_MMU stub, but the only
definition is in mm/mprotect.c, which is built only for MMU kernels:

mm/Makefile:
    mmu-$(CONFIG_MMU)	:= ... mprotect.o ...

The next patch in the series, f62943356e31 ("bpf: Add kfuncs to allocate and
seal user pages"), calls the helper from bpf_user_page_exec() in
kernel/bpf/helpers.c with no CONFIG_MMU guard:

    err = do_mprotect_pkey_locked(addr, PAGE_SIZE, PROT_READ | PROT_EXEC, -1);

helpers.o is built for any CONFIG_BPF_SYSCALL=y kernel, and BPF_SYSCALL has
no MMU dependency in kernel/bpf/Kconfig.  Builds without an MMU do appear to
be supported for bpf: arena.o is explicitly limited to
"ifeq ($(CONFIG_MMU)$(CONFIG_64BIT),yy)", and ced6a0993e2f fixed a
!MMU/32-bit bpf build break.

So once f62943356e31 is applied, would a CONFIG_MMU=n, CONFIG_BPF_SYSCALL=y
kernel fail to link?  This patch builds on its own, and nothing up to the end
of the series (1b0c19c85c7f) appears to add a fix.

Would it make sense to either declare the helper under "#ifdef CONFIG_MMU"
with a static inline stub that returns an error, or add a CONFIG_MMU guard
around the kfunc and its BTF_ID_FLAGS entry in the bpf patch?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39668036298
--===============6870614147643086696==--

