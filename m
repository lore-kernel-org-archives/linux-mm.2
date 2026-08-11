Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB906C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85E96B0095; Tue, 11 Aug 2026 11:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CFC6B0099; Tue, 11 Aug 2026 11:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B732A6B009E; Tue, 11 Aug 2026 11:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 854046B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:47:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1E16C04A6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:47:28 +0000 (UTC)
X-FDA: 85089418176.11.D6B2AD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4D20D40003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:47:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgrgMgO4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786463247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkuepmDqjWQSzwu3ceqTZgODzsd43lLjqsd5McLVs/0=;
	b=M9FxSHX3gPcKG6+xNwDoApVkhpZ4XJxJf67B/ZnkijFz0XXtaNQ8aUjsP8fG8/kwPyoBGz
	BA7TyKNNRB3OdopavBA8i31+wUPomSBsN4WTbwyQwT501IUAr39r/lFvGtlY5Kpoi8lDnn
	yrEk6lifzVdnoIW0IvCpRNQbz97AGPo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgrgMgO4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786463247;
	b=oeYWkbZM+mmsBMCtkuSPkAxA8HF3rjGiYTWYiDYlFrr5Pw05NoRhQtBEugmgZhvJY2pKua
	dJ/vszMjkLnPGc15em/hS8QXt0LTzy36O3t9RUCQHBvWd5xVet3aiHP6hOMWvpaF94xEwo
	MgsBP7ypsmBMeSUcctmV11btsfBZT7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B13C6600AF;
	Tue, 11 Aug 2026 15:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E801F000E9;
	Tue, 11 Aug 2026 15:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786463246;
	bh=HkuepmDqjWQSzwu3ceqTZgODzsd43lLjqsd5McLVs/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GgrgMgO4XdTOq+R2D6nd4KR7/v9VTcV+XrLCb+/+Rn2gxbqKUtDZt4nLiwdMwEE34
	 XK9mrgx05mHoE+5Gb3iahlpPjjMctjXb1mLA678R9C4EVDYyXr0942JC+3OZfLt3JC
	 l1hrrsDfgYSjVQObNrGzh2uRda5Ub4SYVC/eYei2jbDaIvU1sKLGgewGWaughaoRYd
	 YP8ubwv3Y82GnjpT/EZKLocyucbUPLLJbKw8R/bMsXVfAP+Z4+xdJHOCuBd8yNr4PU
	 AIn6VZLacO2TyEZZRsu5XroOQ1ftyE2BRhxc4LVBTVqDl3vb+StqgzvaMF2hPL1nCP
	 iKVB3GjO/CagQ==
Message-ID: <a23dd413-1462-4b7a-9ce1-136e1d806ed8@kernel.org>
Date: Tue, 11 Aug 2026 17:47:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4D20D40003
X-Stat-Signature: 71radd9osgabe47c1rngd57hz9f5n19i
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786463247-697137
X-HE-Meta: U2FsdGVkX1/ywG8i3fUHJolGbJF5WLlmNoETGBWzKqGVnBJK+a/PkhZklFwK2aq9q8mS5hPczzAgTCq3atqynFLN0kAUFVu/ku68iuCNbnM4ou5m9yAK4hdpTbC8ivsq4ABYDXza6x8wyN1CnQPQVEIL4U7chXgyTuqPOu35Wytpn5NmRNf/RF4OgluOJgmHURnvFRLW+cz4hceMco61dJcAFNTbC51l6LDH/9nNOBlnnFPV3FGN/aZrxUopF8O3NQ9y91esMoj3lEx+YlAlvfRaW4TksN3gfspaIqnAJzHmMJ3Ov6glw+yNVHa8n6ELS6xsadV/IzgoeqRCMb15co33i1oOW1xQGkYLt+X3FrcGA6safPv1FUQPX+eRwjEVa4APKF8pK7Ju3Q5OtbPQnDrwrFcFEPeJJCWQCl2riyBonXvFFSOceZRscM8XgPPqX0ECXBZzeK/+3aLgWCS4Ako1fNO2IwYxj+zHEPFAbpoioMXFInOkoOl0MGdM8HeySOPsnOYwnSQfkJRcmuanR0BcRX5GyfysbYdGmyXhBQxgQxVwsnn5Hjr9Z1lg8HUzNcDiXO+MwIBkL8rq9X8dWmhoojIK7+KAeiJ+viRAUoO6KK6VQB7LRs6pH63EE4sfQ3/MKerVM2fK91RHPydJlL5nkDU1el846tog+1WtxyWpQ4tvHNebYxvQQnGj8YBY3dc+zBubX7Djffpg6jPIBJ3+ybzr+5mOp3L8MFYHDiTeAYKFPXciybNv2ELlWX+BkRptHbmvx5KX4zMwPkteM1WtqcvMn20Bvb4oEm4LJx4d04O9OFqS5F6s7vgbGJUA1byWoVbPNYgkm15XuPQmWuIw7tvtqjguG41kYdE+KpuPoZ3d4IaKS4EIpvuOsV0UdWcobs8178w7uz8tZMhL8Wu/YT3x1QbSXVgRasI4c5x338E1LMwzPnLpq117r+YVy/KB/U5Ee4jsS3zmDMh
 5qdECmqX
 r6NIRM4Uf6plnvhYnvgBmzp1iT1BaHvmMJ1J3ttScixuAT+PQvPxPUIBXD5F204dlLxTsjRTqUm45WW31J58+XJfPCf+cNgwAbisR4w87cctJ/nQQvZgokhkuzQSbYIDXbMbIdeyQYCt1orcg3r9PSy6GwN3Im0dMrflTqDyWnCYCorm9i8wKyOq88JjlLzN37XxVckv4SdSTNfZ1Ux68kJ5f25Om63mbIAm8tXvBBpQnz+mxzD+y4VYMJRAf8PXJy+OQQMryumbLq9FP6+1rAwsZzFTeU1J3DUtwhEY+2/ZH+jR3EytCARjrdU2TuDqM4NmdpLNm3atn3Es=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 14:48, Nico Pache (Red Hat) wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1e26ea97381a..8babd4c97db6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -672,6 +672,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>  
> +/*
> + * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
> + *
> + * Return: true if recent access was observed through either the folio state
> + * or the current PTE mapping.
> + */

No need for doc for such a trivial internal helper :)

> +static inline bool folio_pte_referenced(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
> +{
> +	/* The folio was referenced previously ... */
> +	if (folio_test_young(folio) || folio_test_referenced(folio))
> +		return true;
> +	/* ... or the PTE mapping was recently used */
> +	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
> +}
> +

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

