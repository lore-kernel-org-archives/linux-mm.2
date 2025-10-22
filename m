Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D001ACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E943F8E000C; Wed, 22 Oct 2025 03:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BAF8E0002; Wed, 22 Oct 2025 03:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81F88E000C; Wed, 22 Oct 2025 03:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9FD28E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:33:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8226B47DA5
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:33:43 +0000 (UTC)
X-FDA: 84024935526.03.07AFC57
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2894A1C000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:33:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=R7nLqGZT;
	spf=pass (imf21.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761118421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqsGVZ4SyFVwjVPf+wFK4DLy89I6GDvi6h9PlM5oYdg=;
	b=W0wDCcKGXPdebX2mP6bhVb8fhM9Jj0ldDGg+yCJuDd/XAKBmP5CY5w8F+Z/Ntt3x3+XFMB
	eW9SPl0kgp1tM97Gbp4jgWI4I2m1OXjxm49TXfIHRYYuH2WKcmlGKLmtbCwuSI3Bb+Ca+I
	hnyP4iTyHah2rlrK/sdZxUe/Ap/haxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761118421; a=rsa-sha256;
	cv=none;
	b=K6dnTJzoQ8PxjRf1N4Hu3tRTx76kNK8wtRibrRrdfZlEV4O6sCJFqm6gNeQ2Aa2528upLb
	IiyX6gKWIAaiifdiSfuVj8yQGWtYrcHMnLinr2GJwg2EeW4U9FZCBwjxoQLhgHdHqStJP4
	nnNdeZzF8SJAPvlpaGfy6hzs2oif8Bo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=R7nLqGZT;
	spf=pass (imf21.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761118418; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=CqsGVZ4SyFVwjVPf+wFK4DLy89I6GDvi6h9PlM5oYdg=;
	b=R7nLqGZTOo7CWCFIKqmF+y5Y1Tn8frZ93TuMKKel6Eszs3p/ggXwigbLf5jJS7XoVOcTHpxrKFJW5PURcQrWiOufwVGG1yglVUo5pCQzo2u7Z7QTmqKmqnTlQaHcPC9EzGddeYL5boQfZ1YVmpDlGyM8Q/6vPhEEGWAPWcDUjp8=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wqm1la1_1761118416 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 15:33:36 +0800
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
Date: Wed, 22 Oct 2025 15:33:35 +0800
Message-ID: <87ecqve6gg.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam05
X-Stat-Signature: 66ezikqzn11e1tgq6gwo4zi3a8bthqrp
X-Rspam-User: 
X-Rspamd-Queue-Id: 2894A1C000C
X-HE-Tag: 1761118420-927942
X-HE-Meta: U2FsdGVkX1/26RyE+Rhl8wVcpOgkJ+sf3Fa4dwaHm1q4USx38BfuaJ61vIRwn/TYVpNqgFZFsERbUzNoeX8OQFrQgqwV6s3SymuJytWdr2lMyiIyvNAOLwI/m3ozEqHWezjz13gDX47L/nSeEGscxL6X2NfLgyE7T3jReBawAnH/YrAx+JkgWZOrqmRKQDys+c6xlFu2TIKEVD8f2txJHryYYfwWGp8BiHm81/mwFiqg8rl84acDRYX6f4jwqpcjfqCUXgK4voZATDw3Ecge/4O/6+tHRMCTgcedzjcUk5JIyw0EwojmGBHX9e9/9sPg8v/FqORqmLQAWdrlUbO76x/WsH5UO78Nncc35Ry9dMt2KAyBx9Vb44kE6vWVBT40yfv9EOgUW3TfXllZOk5nYJKXPsJk9xJGDpObTTIjlzRS9aMzTP5pwoHrHr6Dgrw09trJr4xXqMb6JUgm3B/Hw8cJkw8tcdFgzuyM6Lp5LIB04+qM1QVMoN3MW1F5wETr6T/hcbeFAzx12UhdvF1/v32mjBI1oz+YbM6Ty1fZK2EqnYydLx/CZ0+2OFrRCpwkJbyeZheSI/R80XzA2SXBvTxdecRGZTbF2xMvMaZSZgkzCj7DRAGambmKQNW9+CkxS2/z+0pwrQFAQKWsaUNrI2bR5qY9pLjbg+WiB5RB+4lJJR49WIJc/I7Y4QP2ZHCTcdMDfYrFie9P2Sclti/lhwIahXTVRiAp0njVE6b4g3dDAQuylqiwapt1ZnF71yGOz+a1RtU2hv1Ma4ly36f15emmp7qn1zuYjkt145pmxdUhUVPaITJ/dFiGKmgI2eIPGejnTURTpRw3x8wEWptj52Dm6155+2qcohKvV5AzOjL9LQ/fi9GdA2PsCh9rJM+mX3iqNfXQa1zJRdw5jwcAKF035XPuL6IeIcIi/vkjvtz51bS52rDFzdD0wOG3GtvTyzrtLH74VGG/0gEqPvg
 SGxU5u09
 kCL6jUqmDgf7IQrda356Q4Xvp68+ukSk6mx7rW52VrGpm/6bYoWg+9gDHzqk+H0tzXKzIGHnf/2O6nzGeiTp/PXSQhGEP/yMkQdCXO0LMXs6xquSbIiCdmaGPiR0IZAmeWo2PzMo1DfVhMCaGfKvoW2CmKNbFOXQVz7pfpaNu2aU8voEKeFu92h3EH3ESpKeSnK6K4lvBgliM4qEti+KZJghl1EzV0xtWax6RxjCtPsx5MKqo+ZILNrjMBuCVfvph/emGSxkogo3ZiLnQvkgM5yFpbMmFaUvKK9fsLvWyfwo4yPD9ezR6D3xHm0imMJbSCXLG4+AwQzYFzZ5iv8hWXMLqT10+VKkGIvyFIWAjTC8gNP8a9P9SQ03IuG4KQe5Ob878ksQY+lJ6GAYjI0DXzPqekdQc78YcjvNeFQkL1bLHbLyxzeo1bStQRGesh/CIjXM7vrLgNwX96g+O2cFrgNoio7GkFPloHdO+oYMzWUOqjLBqZTlvm487lv7U3HUo32FzVDtPkk+YnGksx5TN6ztyQQ==
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

Why do you use

pte_mkwrite_novma(pte)

instead of

pte_mkwrite(pte, args->vma)

?

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
> +
>  	/*
>  	 * A huge page does not point to next level page table
>  	 * entry. Hence this must qualify as pmd_bad().

---
Best Regards,
Huang, Ying

