Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4677606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fIeOsCGd
Received: by kanga.kvack.org (Postfix)
	id 0C0556B05B7; Fri, 13 Nov 2026 15:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094A26B05B8; Fri, 13 Nov 2026 15:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF1C6B05B9; Fri, 13 Nov 2026 15:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9CEE6B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:18:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1417A76A9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:18:55 +0000 (UTC)
X-FDA: 85431209430.30.EF72805
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EC291A000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:18:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fIeOsCGd;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794601134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RR3Y/NZUPFI501cKXclm/UeWrDA7HHS1VJgbIHKj7OI=;
	b=67MXEsST+JJLV6TerA+/QY9JdlAnvsM8p4TW2sV8/yRSXAsjn+tvZAhATDr8Qq1s/6+y6y
	DZQgsNMPCWsT8CF94qchLFtl8bNEWFS8bkcdth+6zW2L06wU2syYiBlOxxHLTg0gMzRwbW
	/9U9S/NjHEjHSNNm8BjZjXJD1YARm3M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794601134;
	b=FHJX+9jgIte8zRd0TaQnS+Oq4vgbkYI6rpUsQ7WjFlHyJONcKXn9emhSymLE9X4WPUH7SS
	oRwlA65FEngrdr7pCyy6dhAdMN6hg6YwqyD0m18s2GLJH7rzKOlN8P5RANrH3En5duKWDi
	0hrZ9xa2ktjSQ4E5NrC2X6KYJDydFTY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fIeOsCGd;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2092141A77;
	Fri, 13 Nov 2026 20:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB0F1F000C4;
	Fri, 13 Nov 2026 20:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794601133;
	bh=RR3Y/NZUPFI501cKXclm/UeWrDA7HHS1VJgbIHKj7OI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fIeOsCGdnxwvFJMUPt1Xo/qhLodE1HQwNmuXbr31ALXJuAgdwOFGvA1kIxYMRvCXm
	 iQYJ7uI8+01PbMxvv1/N+VJ2f/Ij34JTgImZrOPreMn7rFxr7up6YhexXClvbrXFzc
	 ZBh9VpDIPrhnfN+Z/szMfhUI6Uxv8s773oYU5PJ3a4Sm8ojgXZASMPWrfJmYdBmNM4
	 1agCsYuBHrOFItJBWni7s9sup8AV7IGF5rKr7MghgPF4lDQI0aP1eknDAP4pZdn4BP
	 Z663i7PhxEMDA0xwRpaM8gJDgGwUZmUF8NZ9mM1uX/Rofjw0eyjbekqJohTFAeGemN
	 E+h4vdmz0tOFA==
Message-ID: <cc480b1f-6b90-44c8-9306-83d1c125a9cf@kernel.org>
Date: Fri, 13 Nov 2026 21:18:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use PFN_PHYS() in phys_mem_access_prot()
To: Ivan Ezequiel Rodriguez <ivanrwcm25@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ryifo4wf3pagpy84dqzcrfy6dytd9m14
X-Rspamd-Queue-Id: EC291A000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794601133-219240
X-HE-Meta: U2FsdGVkX1/HGnj0FymfnO3gNVoj59D5b+RyAxVMbYHWxZp/5mofoLudvqRJDnlKCKubAWRJhSWBo03NgK1lO12wuJ97dInBYWXz/Vu31B7fk2ueV1f433OYUcMsftR9HXu5+nXA/gTEocdsopdsYN+Pwql2SEn0riI0/c/OUwk1Mr2H+zMKb8+WtQd2mQsGCjjv5GCGCaICf0xbNYt5/Qx9dWIouug3FI/vTHSORnIIUvHR5202hmDvVhykRImib7VZDmUnbXgbvSJn5HdukrD14G3deZPTiEzdnPGkBojz7CyKn0GU+pQVSKmALnQp2PNiAyWMDlqc8YRvWTY1f4To0L+zzvVUB/QqasB3ZbTdSe7Xz1p5TPL8uupZmiulyNl5VlPthmGkeI8LSFFDclxz7isoDfhIs8SUTgWo+PhhyjRN2TH9rmmOqAmNirAr2GyIkYxHhpe6+kPuH6AtUC6uemMuUqmpEmJdKYtW9YfWNJ/AbnF72w+Cf/xyY/bqejDQbcNg5J6G3cPYkrUz9nEfRL1sNF2AbuH7OrIkyw3bJ3efdxDsSU2wlAG+5VO8n4f5zwBbVPJPO1UJ9hhxEmoia1UwXYTKHp21KwiV3+48hG9kq87WDNzA1IwDwbppBLQBI5daGBl9Eu98SwaKrr95dUheaLspEwK88nCydKkHe386Z8hHH0e33m1ZZgmr9e2wyJIRm1UryaWwTp8pbRtp8/oipfHKpvZs2qL41w4S3SqYGF4jhND6LQhIMsMY6sQzGwJlIevN8INODF/chb2gxMRZU27z2dK68LgPnUBbD6m7bJ+9LIIXS9A9pv2zSP8iY+z6GJffRWuIdK7hlbWBhQ/+4k5PHF6zjoC1qyr9rnhTmbDoy6j9lO2YKYMA/5UQDlqYUT5/T1rllrAZfBlE+WTZQb0xGluxUPgG1vKxE7BvpfTSHqVaBWzjQCzCASa2npQAL9o3+kzyn/Y
 1ewEtNdg
 IbfLMNKVwGiQkEJKSAEkPC8EzPsBLeIHCJlALhpZp8QIhG0D2R0WiRKA4IJIZUJWP5K8Foi/E9x4bzUpikrlQTjyGSHhDJK2SOYTOa7eLvG8njGhcdi8lvOfDSbe5QFY06FHAMdkTLmzvu7byMvY6PuTxlGwF0P2A9eqoZpaYCbTRbW1Qi8oRPGHNQd6idphOPgocvydWtnna3/3if87/fFZmoMRg2QIWNEgiI02WhxPe/TlG6fhNiPYOemAI9FqwG+J+jCI0zlFfl/OEQeBhTshRP/Zrb6/kKW8LDjuj34pI/k//+XGh+U4n6T40Fhm/oozz9foBAm93/AQzLM+wp0sf+pSlNbLsX/HWjH1zy+0hoRUmxNRPUHs+2PrtHzATIdbj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 20:38, Ivan Ezequiel Rodriguez wrote:
> From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
> 
> phys_mem_access_prot() stores "pfn << PAGE_SHIFT" in a phys_addr_t.
> The shift is evaluated as unsigned long, so on a 32-bit kernel with
> CONFIG_PHYS_ADDR_T_64BIT an address above 4 GiB is truncated before
> uncached_access() compares it with __pa(high_memory).
> 
> mmap_mem_prepare() already shifts in phys_addr_t, so the mapping is
> accepted and then left cacheable. PFN_PHYS() casts before the shift.
> 
> On a MIPS32 XPA Malta guest, mmap of /dev/mem at 0xf00000000 without
> O_DSYNC used the boot CCA. The same mapping with O_DSYNC was uncached.
> With PFN_PHYS() both are uncached.
> 
> Fixes: 7e6735c3578e ("/dev/mem: use phys_addr_t for physical addresses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
> ---
>  mm/char-mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index c5761ddedbd7..53ce0034a4c1 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
> @@ -272,7 +272,7 @@ static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>  				     unsigned long size, pgprot_t vma_prot)
>  {
>  #ifdef pgprot_noncached
> -	phys_addr_t offset = pfn << PAGE_SHIFT;
> +	phys_addr_t offset = PFN_PHYS(pfn);
>  
>  	if (uncached_access(file, offset))
>  		return pgprot_noncached(vma_prot);


Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

I'm relying on Andrew to pick this up.

-- 
Cheers,

David

