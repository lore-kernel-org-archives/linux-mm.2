Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE29CCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 02:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393178E0031; Thu, 23 Oct 2025 22:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D348E0002; Thu, 23 Oct 2025 22:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233C28E0031; Thu, 23 Oct 2025 22:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8058E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 22:00:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9E69C0D21
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 02:00:32 +0000 (UTC)
X-FDA: 84031353504.09.58ADAC4
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id E7A3D40019
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 02:00:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=djn2EYtd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761271231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8/7AoCHvUPhdFk/Qd1hWlG/hm2n0G0zQ46sK7h9NoY=;
	b=rSUGdHoY8usey8Zg1JgZRRI6VJpF9bHkgohYG3CAPiKTU/FG7tmhiZg4OlMsehM+SlkNDw
	ZchPNzKXyUc1yfv9I4Wf1elVer0hDx37JWWgRtP3QbWLjy11Dv9AEHm43ID3TRnYG8YRG6
	o5aB/x0JhG02tnyTMeF6jN+J41aPjO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761271231; a=rsa-sha256;
	cv=none;
	b=lXNGKYaJfeHTui0BgIUsnBTeTZfOzZb6ap3MewyXCGWWqeeff1+x4OX/TUgS7UF9aqbox4
	uniXJ2B6P9mit6no6RW/uPkG50AmmbQ1OnAagm9ym2NouMcYHd8ZFYi1nWIboK+lxCZpvU
	8SkyqNPDH01xYitcvUX/3GKA+SvHAiQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=djn2EYtd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761271226; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=L8/7AoCHvUPhdFk/Qd1hWlG/hm2n0G0zQ46sK7h9NoY=;
	b=djn2EYtd9gl7PrJfR0xTnvAKxvX83HmN8H4wizZMkoWRZ981eGtxZ68b86AHsDre2hkqs3G17mS4Qr+eJit/vYh+GW5tIJgGGUpONEuhgmqDxoN+JzgtmbXozazq7W9uAHEUqV6prSrzl1F5is9TIuxe7OLl2MvCwjNQqI7jlxw=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqsUhQ8_1761271225 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 10:00:26 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@redhat.com>,  linux-kernel@vger.kernel.org,  Catalin
 Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V3] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
In-Reply-To: <20251024013137.136926-1-anshuman.khandual@arm.com> (Anshuman
	Khandual's message of "Fri, 24 Oct 2025 02:31:37 +0100")
References: <20251024013137.136926-1-anshuman.khandual@arm.com>
Date: Fri, 24 Oct 2025 10:00:25 +0800
Message-ID: <87h5vpvz2e.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam01
X-Stat-Signature: 5fr7j67xdannioyujut11uiu1joure5i
X-Rspam-User: 
X-Rspamd-Queue-Id: E7A3D40019
X-HE-Tag: 1761271229-680979
X-HE-Meta: U2FsdGVkX1+b+dckVUtkNlpRhMLvE2BEfmO2Lvy5jcBZrYDDTFX5eyjauJmixBc7dq+HHSmjsz1bq8hHCnMD/QrqfBRcWJ31hyYziv+eZjsLZ7x+3y+ibBYQwm9C68i9IE4yaQDA2KXWgiNVN43kJwJq0ATD1gdXmHF6puF1qOCG4DkW9Zn8gvv3YTyKivQq2kYyTqlvpYqaLGWL6C6wiYhrNsWw928Rd/gaf+UV0ej1qt4xAMeA5g1EsmvPG6tv7owxMaNvS1qG0ypm+jjhE06xPIkkWnweOw6ADnXs9920AZSG9VoLUu91CdkZebZcP89RWI1rlyyWkP8To++4bwLSWmSGTkGPtViM0AYxAOhkhernU04O5t9tXoUnv98P6XKAVOtD/cE60haU3HN1r2EBtJFardS0j6etR5rVwL0zCbQhBgzjIuacWPZbHQ0LI5RIZVODWGWiVmeqk/7GHJHDeRYJrZ3YezlpjmefKMG9xNBv4YTVq1AOcvrgoOsM8+Ay5D7O1+yu9C2lzcVtJ6yhMGVOw962OVxLW/nGSspt/bUvkXZWtTFqhGaxfjYzCDmvnYYN0RotEUrX4q1061sIf4eZ8sTxeMla7GzdUHuyPcmtsZFmayc0yrzmqX1aYiJ4rMpzRlvT+yjYwAOQRNqwIDhcUedZsGqfXILFtZ/gI7Z6zQW2bj5e1NdSnh5dKChEssb46MzTDkSE3HsfmmQ/x9T/1oozDRnIcRpvFU7GJmcVrM+8TYeutpv+IuWuwf0bM3CWa72oiHV0DYlVJgG0nHPkhs7MlR5lUcGdJ5wYO2yWwCefqHNpGilhpqCBzQ96ZT/t3wQyIkIt60+0JQ0/VaJh7p5hmMCU63SAuaKQcs8n6qDZW6hgxWLlk3cgl6dTqrqkCRDz3BqPFXbcbteuY6uxt9hTqBObBCTs/3sh04fP18hB1m7CC15wIv6s6BA05hSheipeG0suyDr
 QlETQFhY
 ZtIIkFJvWVhr85EFXM/HljutBkSdGPVWXUbxpQLreRkfZxW759XFgPqlAaCf4NjU1n2XTc95DFOBer6OHIGjgFoFUxMgc8lb7fdpmblg+Ws44n3vrYB+Im7tdWMc2tg0q+MTCqKqG0ZUnK2gAa9Z7m48A24/2qUbjHJazh4JIRKbHn4zSlQbGH8FIrJiSsa7/B9PCp+BvnqYG6ED2rvHrajS5gYewi1U5VCo8ke7GpZGCbXWBVgYlW4T434xxmd95rN2BI6d3yCfKt3f7dzYK1xL3QlO9G5laV8kGVNJTGF3FfyUa9Nyhz2lycbQOKhVxUyZlyHygDlXu8jKvHNqOJDlCjYAx+00Gf4iban9DSeqLzVx32g3sjxo3RtsuJztju3Js8vAsLWf9KZdUkgtVFW2Udyd2vdFUhHHGlJCTiBC5XbmNxVoeYlRys111xGv7uSm+PM3wX+gZmEXpEg7pajXMtlDYjOXdQhi1sPoo/kn2oGlSUl1vtui8V3pQlD9dN3XEJ96D//c7FlDF0apPzMJQbA==
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
> Changes in V3:
>
> - Added a new test combination per Huang
>
> Changes in V2:
>
> https://lore.kernel.org/all/20251022032951.3498553-1-anshuman.khandual@arm.com/
>
> - Added a new test combination per Huang
>
> Changes in V1:
>
> https://lore.kernel.org/all/20251021024424.2390325-1-anshuman.khandual@arm.com/
>
>  mm/debug_vm_pgtable.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..133543ca2821 100644
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
> @@ -195,6 +201,13 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
>  	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
>  	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
>  	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
> +
> +	WARN_ON(!pmd_dirty(pmd_mkwrite_novma(pmd_mkdirty(pmd))));
> +	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
> +	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
> +	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
> +	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
> +
>  	/*
>  	 * A huge page does not point to next level page table
>  	 * entry. Hence this must qualify as pmd_bad().

LGTM, feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

---
Best Regards,
Huang, Ying

