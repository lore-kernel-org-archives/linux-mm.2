Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8B3CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8F66B00D5; Wed, 13 May 2026 11:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FED6B00D7; Wed, 13 May 2026 11:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096496B00D8; Wed, 13 May 2026 11:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EABFE6B00D5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:40:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAC1FA0159
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:55 +0000 (UTC)
X-FDA: 84762809670.07.4D7122B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D1EF64000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qcGvKxVu;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eVlbC1v1FPNJLQPoLRuRUV0/pwO5E9P4Y81MSdxLKY=;
	b=62yBMCFs2nUR20AN3m0zaOi3TJ+QqcacwonUD+Us8O5SvLT3KvMAGVJHyZDFk02Ew/wO5I
	/V6PHCGA/tHaVgosgMIxQU2WHJslZ5UKCfCJgBKzDsavdIRWDz3/PqSMhkWmxx6UByCE3d
	uI6+0p7uorA4/stuL2RPgDR930H//ok=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qcGvKxVu;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686854; a=rsa-sha256;
	cv=none;
	b=NJJr5CHf1N2wlfJkpiq4+UQafeGK0p/v3uk8S8bXnQV8wJtNlI/JRgElomAT5c7hHltvM3
	VgN0CGidxQUYOzo1XTPwJowGI/FICqpN7tlfQQ4PXrYX39c27kndywXcgBpUm6C46EM6NN
	0e3RYiytF91AQgnEJFZdMqJ3JZKkUZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCF4C408AE;
	Wed, 13 May 2026 15:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4A6C19425;
	Wed, 13 May 2026 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778686852;
	bh=ENtDq+CG51e3CyzmJrp2moPUZGkid5vPP6x83kgtnuc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qcGvKxVuLCKnAvkAq3i9f+cvWglWcg1fFNIQG9dEXt1/G5YmgMfZb+QKta5YWpa9e
	 6jGyAh+m7ZFTiRUZGORuELD4a/XNB5EtgLto+qLMq7b0hucc7YAZddcKIVv2CFCcfG
	 m2pFeMsOuRlvy0eRyNpAELmORhvwKaBsgov2U/ubODg49t/68nmNA/lXI+PEoWKLI/
	 TnQ3JcRNOxLgz7Xv5EfffSaFYfrI1Kzd/m6Q44m1dmFf1Fiih5UaaEviFoRe9KiKlv
	 wwfMDEc51kbaAKXUf2ffJAx/kM7k4rV6Dlu/hIZhGqQgv4cWYzWfulDKzu490gWmVl
	 tRvJwCYAXPMkw==
Message-ID: <2101c79a-e2ec-4e2f-8643-c68970036ef7@kernel.org>
Date: Wed, 13 May 2026 17:40:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] drivers: dax: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <cb854ba26a4b8036706c6da5f6844f10f386087f.1777663129.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cb854ba26a4b8036706c6da5f6844f10f386087f.1777663129.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w9uhnt3xixio479xn1mhywa4ouj5bq5u
X-Rspamd-Queue-Id: D1EF64000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778686853-360755
X-HE-Meta: U2FsdGVkX1+fF75OJ8AcUGFDJPl++FDpmseQXRx1oApf0Wq2EypeotUlpqTvATjCOh+ZV8xHsTlfkwwRJ5dU4zVKwC9hd5kazCLZahQ9ZzYmqWyKexK8CL1KoatK8pqJGV20/7NnFp9yGWgg+SaJ0x16Up/qR/s5ZQk/8DPUn/A9ODhnzkUqI1T3rBlf4Fn+p0RkpdEHRDgS7n1OR7rz1BMj4UE8idLf7jmiFgOr20xZl1dRJlvaXliDMUTcs/duxM6GWiYWVOMKw4XL8cSaZuVqM85n2q6E8UNif3i5FC7nAPqzYyB5bYNlgocYEKyT1gQULdHHbvEK1+VcZ0yrWKEtGZXmG8lz4h4tT3PS9stLndfdDkflAdoQQ56RVYoTuNdYxk5I/89C2STg9olbJ/xdllV121UYuK7X9lpb2YO7Ymam8f0dLXo1kY51l+8QsBMI5Fyte/NEVI8FrWlmCN2xlY+OGhbr518SaoqOBove68/NBDMYqv77zTa8ciHaabIc3cd7cyir1SxgB3C6rV80NtHVq1sG4Wn0mEZIHlwn2pu/hVkBiNlHuDPqpKhY7aRIxhnNFd2ay3H6fbmS2pWWBt8UcD/7FAsPAI12IQblm+erIM3piLUBUwD1Lf3Gbzc5InuLzc9T9+c2A95GIuYckd8N9Kdo39DVl6vjB2UvhHeWjBLnhH9Knry2WScECndVu5UPHO7ioUjaC5wER4BAhs0+acxWA7kCTGiqqxz9rzApWGWvbBAFMorcYU6TngRUvMzUb7zPCNrDdIUjGeW8ZPh3axVlR1FTPj5F5TIAdeF+Ih3Tdoz+CoPTFke0upw6DuWjWFjGSf7ILuXTQVRa9y3M8cTWIHZZrgPBEnICJ20TcFYi4qmvLMRB5dZgJ+Aj+GIP8q6eJeWpLYn9qtscEMR3yKekZa5bMq3TppXH8uTHRmBeOlp6oKVA6KjMfPAqo9viVnlTqFOPX/t
 ZF7Q7XiO
 JFi1P3ocO0HGqA4Jqrztw/+Yt1QhUmhmI2PAn127TpfRjWF3/0iwUiQl+qSwHPAIZGKYKNsKdKStQx/zFYBbgGi/kiAkY6Mc+33S+AR8GufTbID+sy0ZZt08cgAgcnFDXh/6Ii+zjBvce4Jilw21Whx9UFwUtsG79rOZ0bhycZGBBATjmxgOgTqclh4gvZ0P6zeX23DsB6GCONw8a+ljApjYzvhO26aatrqyDBXA2YwhOOUgq35VfGMLr6UCmxkGjF5ZirnQwq6NHc8t0BSG+YYws45nO7aqiS8Ol/TWPYRvQ4qg9bz7D09nrqk8kUle+DjoQLtDoDlaXWdjoUHcV0Yf4A0yAwkMd4aLc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 21:18, Luiz Capitulino wrote:
> dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
> pages are supported, use pgtable_has_pmd_leaves() instead.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  drivers/dax/dax-private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 81e4af49e39c..35744ff6592a 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -123,7 +123,7 @@ static inline bool dax_align_valid(unsigned long align)
>  {
>  	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
>  		return true;
> -	if (align == PMD_SIZE && has_transparent_hugepage())
> +	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
>  		return true;

I think this code really depends on the implied CONFIG_TRANSPARENT_HUGEPAGE check.

For now, should we just keep saying that pgtable_has_pmd_leaves() implies
CONFIG_TRANSPARENT_HUGEPAGE support?

That would also e.g., make patch #4 easier.

-- 
Cheers,

David

