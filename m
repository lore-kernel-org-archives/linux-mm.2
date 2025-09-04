Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3C6CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 07:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469F98E0010; Thu,  4 Sep 2025 03:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441868E0002; Thu,  4 Sep 2025 03:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331098E0010; Thu,  4 Sep 2025 03:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB698E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:10:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B61FD13BB89
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:10:07 +0000 (UTC)
X-FDA: 83850693654.14.C752457
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7AD6F10000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:10:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf14.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756969805; a=rsa-sha256;
	cv=none;
	b=RsVivzzJ2QXuRQjrOXE161q3eb65A5Ak7l9r45zqHIJc/rrfRzs1IW2OvLR3wBS2XwWbRU
	WODSYSfIkpqCNfdZnQiOBb8JYmgpYRaYyabR7k0tiqZcrJpwQB/ZaMPVKuhYHqG6mr4jfp
	A6nbzebQvTFYrXa/2MTNP0Jm79+EpC4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf14.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756969805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=28HQS0dhxfb3EtDkhwzavnP+Qfq1q2LO7iNoRzqKpY4=;
	b=NPmtQlu0zbze1j80OFiASK9YBfR+RHx4ZqUTcUbHPBnbMUSg2TRL7W9HBFBk2vUWUVhClT
	RKed/WQ9iJS4DrnLbgI7p1pTdnKLN2AbEgyquW7wyW0C6kV8/Hd3HJ9tMNWvvC7sGVxlfH
	G6+b6vhqmnPicVU8B8GOEZx6l+MFlEA=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cHVwp4xsdz9sVh;
	Thu,  4 Sep 2025 09:10:02 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WEv7Y2YJZkgd; Thu,  4 Sep 2025 09:10:02 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cHVwp4BWrz9sVk;
	Thu,  4 Sep 2025 09:10:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 784388B764;
	Thu,  4 Sep 2025 09:10:02 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id JZAEJLwTYdG3; Thu,  4 Sep 2025 09:10:02 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 23FBF8B763;
	Thu,  4 Sep 2025 09:10:02 +0200 (CEST)
Message-ID: <3b333f4e-9817-4a5b-bf0a-f8a9d33575e9@csgroup.eu>
Date: Thu, 4 Sep 2025 09:10:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] powerpc: Stop calling page_address() in
 free_pages()
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-efi@vger.kernel.org, virtualization@lists.linux.dev,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
 <20250903185921.1785167-6-vishal.moola@gmail.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250903185921.1785167-6-vishal.moola@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AD6F10000C
X-Stat-Signature: 8qifambfoimbj68hhfn3c8hqgbfjcayt
X-HE-Tag: 1756969805-551640
X-HE-Meta: U2FsdGVkX1+Mdk6hjvDmO/5S+7Vv6VPl/2L5wP0uXWFL5MNiekjyL64QMqVbqMJxCfP8g/STEGyNwIk9DMepnhe2fv90UtA0DoI2EGmIZEQnx0KYRBSZiy1hVLruuWq93SG6qeSLe8c6f8oKb6O7VD5b6BCUvFmaDVEElE7lPlQpj21a0YB322JmLlWim9pBwbnBAy4HeHNKQiMuhIGhYpSzjPR8N+jugnbMTjMKSBtroZA+u6/4JZsbmh7tPvNJAqVpPr2qBMbNjXSDlLxfVJ+fkSlmw+RJHZmHaEPNNop+G9oZRbib+pekrXZiTe8dSCv+8po9+pCxz8U9WajqbMUzr8JyLqZlI++YEXXpkVyAfBQq6AIa6xHeLwsvj7CbEWErywwjJ+bNpZGPcD10lAD9vonxWxu2gEpjhQsf29QoJBJJJZu2tUjz5Cj2d1n58XQIcKIjWlE21CCAbpmiJkzSEUadjJwDTBivJ996tPJ1qv7c4L7sVXskGAFXuTjUMOrjrLsLe3q8fSs2156caxZnp5XINTgY5z238sCca/O589/nIhDEozfSXNt1u5cVekIiVHqglNBImotiS8l4cnx3wz3IjRtt2FMTOdArowHDAG72csgjPYwkhPIVq/w6g7/d+EAJ/B6AXkiHTFLIKmnzBbPbZ+tAWXaztXhFaEegx+3MMzeVlIeN+FZgP1f2jIljMwLTTffsMq01rDG1ntXVQ72ZhYDiQQlDpuWSbs6nH7Q4C9eENQdnkBLsAkVnEKI1H3Xly+9Ohlnfe08/TeVgiRZZg3HMezHomDH1VmgHh7ji9WxWVsF52dRICHJJ1SSpES1gkA1eFZYwWRs+VyVNmSUpbfFgEEjL9quwsGBfcBUJ8kJbVhXGBlwHqqX1rQXFrXlF1y6ZSMDxw8rUuT5rAC3nDhLjslUfDbMt9HOqqz1TB6eO3C1C93sRV0/usM8OnisMAkwUWk5XDeU
 ZObQHwRH
 Z021970tZVL3jDXXh8kfSgVMZEtSYE+XP53pH4lWNY5GK2g2KHu5tseESGeXGT39WnADvV25XHZjYLH+kU7SdEaXTGyjO/pHYFHhSzVN2MmVR1Q/ATQwCGI7VVTmE26WdX6XlVcaqAUajp+5LqloZagxDQgXoOXHc+1Dpdrm7RPdXVn+NlIRIMRgEgAEy0Bsmz98V4gTod8/vtOpCQymfaureMxRJ54fv+yZwgli9TShVLt/prvfwGh0lXnNu1JJqjAtUT1cXHySHU/hI6+Aq7HxBfBJva5QNNppdcxwU0rbXdouhDMS7A0ZoYSOWTP3lPOnFQoGpqI0boPocCisvug/MIkyphUFCY3rw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 03/09/2025 à 20:59, Vishal Moola (Oracle) a écrit :
> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
>   arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
> index be523e5fe9c5..73977dbabcf2 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -780,7 +780,7 @@ static void __meminit free_vmemmap_pages(struct page *page,
>   		while (nr_pages--)
>   			free_reserved_page(page++);
>   	} else
> -		free_pages((unsigned long)page_address(page), order);
> +		__free_pages(page, order);
>   }
>   
>   static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,


