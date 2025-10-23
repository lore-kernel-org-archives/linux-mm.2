Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA2BCCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B238E000E; Wed, 22 Oct 2025 21:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B818E0002; Wed, 22 Oct 2025 21:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6883A8E000E; Wed, 22 Oct 2025 21:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8E68E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:17:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC09F88E46
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:17:13 +0000 (UTC)
X-FDA: 84027615546.23.E8FBDE3
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id DD136120002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:17:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nfvZwps1;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLGJy/2AZYKq6vVC4qpKJvBSxQ5OrU9VmKnnjRkvqm8=;
	b=HsvWhbbrzdq+raLHaCp8UC+ReLyMo4uOtRQfQuiae7tqZBn76WrnFqAVZLYF776SCUNfFb
	BPgm1aFDLKl+TBRdGh0CQmWSu/J5Kx6E7GnfPjg4J5PZ6EbgA9j1sofVGQzCpaAJp48Tij
	j4tET9q5GDcQ2pYo5sEdVC5tRvdNDpw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nfvZwps1;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182232; a=rsa-sha256;
	cv=none;
	b=4mBQIwCKL7agqiK2KX3kLqPktuJneskWV8b6nK0MXGMZgurKHQZu/PzFHtXZDK8ReGE4+7
	XATjqMDb/wgI8YexBG8NN8JDBzizi6YLasns1LfAIXX+hxQsDEjyP6snEa820Ra5IC0bV9
	deohBTSi5YzOA+kK8Z3K68RPAVrhRH4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761182229; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=tLGJy/2AZYKq6vVC4qpKJvBSxQ5OrU9VmKnnjRkvqm8=;
	b=nfvZwps1hnktH8TlDIr/2L5i/kNqcYhpLQdDatZHTtghWdNKvgoiV1tnxMre7kW2/coWBv5DF2O38znQf7Yrn4b64j7WF1TBoE0XSMLibjp++4Wf8VIXHr8wn4DukdXV+p360WYXyPpgDKzyPjOut0JNH42Jx+4+YSWFVM4+ZDI=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wqoktlp_1761182227 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Oct 2025 09:17:08 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@redhat.com>,  linux-kernel@vger.kernel.org,  Catalin
 Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V2] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
In-Reply-To: <20251022032951.3498553-1-anshuman.khandual@arm.com> (Anshuman
	Khandual's message of "Wed, 22 Oct 2025 04:29:51 +0100")
References: <20251022032951.3498553-1-anshuman.khandual@arm.com>
Date: Thu, 23 Oct 2025 09:17:06 +0800
Message-ID: <87ms5i2z8t.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD136120002
X-Stat-Signature: khtcwq8eufss4uc4ykwd9i7f8ra98hyy
X-Rspam-User: 
X-HE-Tag: 1761182231-331706
X-HE-Meta: U2FsdGVkX19VP4ApGCJ1rkUFvuWm7m1y0gbyEq2CBU3A7TuVeJnOu2jJV+9EbOTxqGjkapZsVHN7/eLc4n4w8/UwcpKQgBUv9uG5Brq27nlj2KR8QwNy6Bjqs8EhWjCkOAx7z478iC8gD0ATbv+FAAwAk3m9vnh3djFwIW4X04QdxoE85b6DqgVX1o/GpGyuekh7e3em48h5p2DBHi6pM63s9bJfEoH6eHfGEqJM9wlU8KKL12SgSOxTFeZXuNTO2X3lKXJ1JzVoO/7xv+HbEPJwggO9dXJ/mxuYkcJaRTz3FJsmwkN2R2aik8F0Y7X2WFZ+vnzEPRDHeW8rgVyx6TGBZ96ivsnCjuXgrCyBtJV/0q8UW1yUoTitp0D2+Uc4UuVXCwhmFFBe73e6y3WEM7F95AyKq0LMAVD8Ur5voEMAWBF4L8ZZU0NLk9jPW3jJkfa696NBLjo9ioRUOEJ0IzFyROUtLWG9asL7c8HXsQbQZBA88tKHlWBi9iVZe1QVmrSqu2db8XRycC5qiixuFzUku274AvhmTppHmHBeandPnIMfvQ3qptOA9zw0cQHpVysdAqRhuWYOp9bWZlGHfFhDs/XGOHWseQU2ggDc5rPnvvStkQe8J4W6UDoqoqiXRNBIxWSgLptDaXsIdFV5Rc6gaK2bOkwYh2cvuoOFoc7JvOM1B6VrbBY87Uykf75f8IYhnt1ZZzVmbLdm7cPJEAPdzfFz/X8B8i0X67VCQkJ6RNEiNJGFvLa+km45GnEYEjDt+U0IrRFiHarVQYqOE94WZGiXaDDvn5570otP0kkZ27d+L+q805bnOo4PZEiSE0Y2EljtFbH3f7m3rkFI2tH2vVFSaqKjPL/Gtgq6t90LNVpR2bUUbTSow/alW1Fpfw0T71xbGM+2eqHpJZ02noT3wPrYdth2hqv6bNj5KnN5WmVW2ST0FnrpdTz3BIdEKV4cK2cB7liVjwL/XJn
 DMhmrxM2
 U+iroBfk5/4SUO2Fsq+Z05ktVx6Agwe+QjJInBmoh3tRb3nHqGSunGDHJNYejFB9wiEJ/W5ySLpQlnjHlt+p5tgTVOJwfVW5PfblFVv6N0gDNk6ODtmsf3JIDcFWeyVh3tlGMc4659Q442BO/awo4Xi+v4J5mo7DeWQmfsWI05H1omMBhosgXuxvWdISCQbKOoVkZ1gM71gp3qYKhiLVjJzzB3MmxHT4+f8Fszp+8AB5q4jZdrJIqizrMGtsfXiIvRVwlacd5foRiCj+/Yq9QunARnt2lchsot7hE6sJ3lIO9+XtWRQJZ/IanXqmGTWAZc31+3rm0QzM7LwRZQ6XHwvLjSgbuqZHtwsYkh0Yjbr6WCWBIy6//tZ7TMckjtwYTb73pjw1aCqcQ21kB07FuKwptK+B9vdwmP3//Nelr1mpBnwdA2u/HO+pbUVLbQ0p5unYQb226LW8c5Zspz0oBJ5g/gLjaGojW7lO/4Vm/wa8OE02ZOD3x2ytYw8Qh1jrIbls7geU7DChaIXHTd4Q5rSnUlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Anshuman Khandual <anshuman.khandual@arm.com> writes:

> Add some [pte|pmd]_mkwrite_novma() relevant tests.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> These tests clear on arm64 platform after the following recent patch.
>
> https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/
>
> Changes in V2:
>
> - Added a new test combination per Huang
>
> Changes in V1:
>
> https://lore.kernel.org/all/20251021024424.2390325-1-anshuman.khandual@arm.com/
>
>  mm/debug_vm_pgtable.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..def344bb4a32 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -102,6 +102,12 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>  	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>  	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>  	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
> +
> +	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
> +	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
> +	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
> +	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
>  }
>  
>  static void __init pte_advanced_tests(struct pgtable_debug_args *args)
> @@ -195,6 +201,12 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
>  	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
>  	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
>  	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
> +
> +	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
> +	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
> +	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
> +	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));

Why not add

        WARN_ON(!pmd_dirty(pmd_mkwrite_novma(pmd_mkdirty(pte))));

too?

---
Best Regards,
Huang, Ying

> +
>  	/*
>  	 * A huge page does not point to next level page table
>  	 * entry. Hence this must qualify as pmd_bad().

