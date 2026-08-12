Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231FDC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1626B00D6; Wed, 12 Aug 2026 07:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91956B00D7; Wed, 12 Aug 2026 07:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931D86B00DA; Wed, 12 Aug 2026 07:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61C116B00D6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:28:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6D81160196
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:28:55 +0000 (UTC)
X-FDA: 85092395430.25.40F6D82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B7D440008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:28:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Spd7Z52S;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786534134;
	b=E5NzgBRFRhUZC3b/DnyNWUAILHn05MXoptFd0oBth0GX/W0Ilqi6cGWIdAdEuguOz27QsK
	Erg2CI1VkZMREgWR6J7dpqmeHL39AfH9KpVFQdpNryZty753sL84xQDhrtXX7fJYDFDiSM
	uSgEywGXgx1p6UoyyPP8cfW6lS4Z/nI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Spd7Z52S;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786534134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcnwOpb20k56OlzwMG66aE8z23tMLTn0GX7RmNBbTuo=;
	b=jsGc/skd1Z2On6nnmV8KjPX2R9MUSLlx2P8/U5mNMizmfCVIlik3QbQQxVpHhDoTw8dAfi
	IhwrxDxNlMA0OKbwmN3lpAqgatSrjKwELZM1HDlGXnYy4T5Vn9JLQbORtNRDgXm4LLe5y2
	hH4BUSLyEA3q8VtWO1qUalpM1iQ6JcQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5169141447;
	Wed, 12 Aug 2026 11:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662EA1F000E9;
	Wed, 12 Aug 2026 11:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786534133;
	bh=FcnwOpb20k56OlzwMG66aE8z23tMLTn0GX7RmNBbTuo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Spd7Z52S+anzxKYwnAgi/AtvjfESL5PwTKgIqubz4s2/gdBKPK1PBUL+UlGOLhMCN
	 Gx9nQBExt2+4xzfpf19qghT7hdbZtU4r2pYjDOTTMKOgshUiKAvXf9X7JdXURMw0fH
	 LgT83ZJzz7JUc2cD+zPnkxTRAw1/HGZPrammYkDmxGINgAjpR5xBV9YQn6w7l1PgnI
	 4NNTDruHwZfVoRA+X5ZvwsdnHZZwvu2aICh2gWtdpmmvvDzh1VFJcxfUX/veCwqvAc
	 0r7q5ksshsTKLeMxN29WYMJSFA8joiGkiYpaV39tgyHPTesTIKfhF8UTJiSXfjnGlQ
	 dSxsr7d0sngOw==
Message-ID: <7d8e17c2-9c9c-409e-ab4d-4e4fb0e51ec4@kernel.org>
Date: Wed, 12 Aug 2026 13:28:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 5/6] sh/mm: Stop using pgd_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-6-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811042119.3652929-6-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B7D440008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7m6ez7hke9by8bihxmjkzauwg8sp7od5
X-HE-Tag: 1786534133-176223
X-HE-Meta: U2FsdGVkX1/V9dv+IlkutLwDVn/Pyq/kHnP53AvRD5pjH8J8JLeqUuKq7ZwqrDW/f0ktFKt5G0QximQwPV3ThVrgNuCAir4tRXgIIOCTlT8ZK5gs0wfYC/8M8grT66zKhAt22nzKFWMcECj+JOm5lgDSl9kI2+W1QX/h1z+FogZuxG/L7bDic1mCXVNtzTzJ6MA7s1c1CHO0htj+tQTfaD//Oggxj4EO5riiw/vi3R+AIVoBsv/XR+l/p6wKfMxR7PHUWeShvJNdGSRrh2vQD0f/qRTIRCo+/zi5g8nKaztuPz+sC1/9sLdaoxoX3kwdE32V4/6Q/jZBBW8DOheh7IZKMVDxZRAr3I8BK/R6avkFmtqJZXy92UqS56EXK9uCoB7nr+QUJCd3uxrRa4qXfxW++7VR971J8+SM7Ng5lOGwEFUX6A5xagMDnKWPm7rZ7hPc2bxnHQIbTqX1GE1ZlPCA9a6NEwT17cmA54QSBLggX4E6D+ADSwd7HMjjqtloI65IlvE/YXKXeDhQC1fYg8aP9aNapYqnrRTSSXYHLHaPXcH/kWLCNF6RM6UNXyCuiVI5Hae2Q8G609/bnCzoKKYBJOXKaxZSyfUENijiNnkkDv3S5U4zQH+/ZG131bkTQJt/OW9SU8dA2nX76d45x39OlTuIemp29+WW4dH1t8NEcq7Uz3f8v+2eaAQugtMlRy42qjdpL8WO5OwKfkBeuXqbFmbgbjOvhRFAfE6z5+iIfjRUjStQerBkfw7zdmhG5F+gV4rufcpdKqwph0Trjf2bNlWVes70O9E3i7beeZwGS1bnbr5CSEpKX+/B2x36BKkNAK6DXS7EzHBQ4aUh9EiQp7I8jMvGGl7mATfNrRXQoos47meNEGTZ8ia87WMBJAWRfYzVaf3AhK7AEwIZDfXAAb6eUBAty2/NfpXKxYZBfyu9JLMiWbMX4EANyvwYUJav+WxzxxPl10Q17H4
 pgAlsCpQ
 JDG4fEcM6+E9xwJ8+HlMBUfj0rOdgQm3P1xJ+ah9On6cs0D9xsHl03fYhFZp/3uM3vn5eyhDha1XhSWuV36hOx9uv9s+f2YmEkMcVQIl7Oa6l8swX81EHIAR2Tn9to2CvnpFGWk3PSXgoz0OsTxEB4qf6OmtgfVAFYm9nrjsHcfiT1XManafyb/wN4ieHW2Np3q0L+5q2SQaBlJx+XcbWhH/KzW6Oc531i7Fn+9COgV3GDZwuelnlf67yW1iQESaPmxonoq2bjyuhhgHNECy4CmtFEMyops55i/4WQlre1rq9e9QmE1AeeZAtcqLBZ5O2HAqi279fCpaBabm/dyayUVuSHTbbE8xkyMNUYGiIk7JgLG73wSX+d4lCCQ3D/+3Jul+Xy4Sb7RL6vpShJz7EQaXrAAr2BXldGspez/rwwhVAgkV3FjQDs37hIKxYZVm5eoe+LXhD73/ozoDttuUflVmUSRLhlmwOO+OndYsSQU1R9BcEJSBWnKSIMDTit7p76ZtjLnJrPskGmts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 06:21, Anshuman Khandual wrote:
> Stop using pgd_ERROR() in __get_pte_phys() when page table entry is already
> known to be empty.
> 
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/sh/mm/init.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
> index 0bb8555568a4..585012293632 100644
> --- a/arch/sh/mm/init.c
> +++ b/arch/sh/mm/init.c
> @@ -52,10 +52,8 @@ static pte_t *__get_pte_phys(unsigned long addr)
>  	pmd_t *pmd;
>  
>  	pgd = pgd_offset_k(addr);
> -	if (pgd_none(*pgd)) {
> -		pgd_ERROR(*pgd);
> +	if (pgd_none(*pgd))
>  		return NULL;
> -	}
>  
>  	p4d = p4d_alloc(NULL, pgd, addr);
>  	if (unlikely(!p4d))

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

