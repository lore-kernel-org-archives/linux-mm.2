Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43DC606A331
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hlZduhvx
Received: by kanga.kvack.org (Postfix)
	id BE68E6B05B6; Wed, 11 Nov 2026 11:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBDBF6B05B7; Wed, 11 Nov 2026 11:54:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADC66B05B8; Wed, 11 Nov 2026 11:54:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72F096B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:54:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCE9B80347
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:54:56 +0000 (UTC)
X-FDA: 85423437792.20.076F81D
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id E35D240002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:54:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hlZduhvx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794416095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bt8vCFJ78PDhrhf1lGPW3TnU1901Xv/Y93kmnDKVKUQ=;
	b=IMUQ+dW9x/OkhB2zgJDD4b590uXJblIA2R2VuZm2tGgM/t0TyiGgSjcWMGhJp6F2GNQJmr
	l/qt2YbJkfTCE3JBuBQNsrISG93GPJ32oFAsTRKCeuPbjGSMdVbHgadT8yebX6qABxYF24
	j/d5bc1Nv9uWBRP0hv0J1V2s1EKprRc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hlZduhvx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794416095;
	b=ozS0VJhNdbf4ZHWP+PpGJ1vcs4WDBRlvkIMWVgkxNgq3H7iDJ57WYshELTc1/5Jg41V5Jv
	xigilRxsbSU9FZKC39bzKF4oRAoFIPzRXWnj0IPYvMEGf69EBNOBLMm8UPOl45GVO7RFOy
	X6XKrvy+dHIl4c5+2RmWb/cdpgqkZIs=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48dee593f18so2588370f8f.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794416093; x=1795020893; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bt8vCFJ78PDhrhf1lGPW3TnU1901Xv/Y93kmnDKVKUQ=;
        b=hlZduhvxMTQeS5cMqNs/n5aVvbHQdWJGYPsWxC38tQS0jDBQEnb8+wRPBM3BUc/Nod
         z0QASCHWYoYJDl4S6l96KsMDR95KAdljDtG9yf+nvAYNGHleGW9/BPzp6dWcl6EhvnRB
         essHsbuKCDeAbED0abNq8zdea0DSGSmRSNiepKK1O0QE3AyXc4arKY3ajigUC/s5sDT8
         FeSGdZdhMjyC4CW0xDHk50DVmU3BiLSxciDAkkWUVods6CcmGGEXmA3vuG3FFEYsQCGz
         8X3uNX7zuFlfSDRM3Q2V+glCPGQmiXbfkk0cwxwOkaHcS7ztQoi+O9jRwj4403LIKz0r
         G8xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794416093; x=1795020893;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bt8vCFJ78PDhrhf1lGPW3TnU1901Xv/Y93kmnDKVKUQ=;
        b=eqce+vd9Ypf86lmNmi/XPCYa66/F4Lw9Pl79fpdx2IG/fP2XZ9lblw9WKAw1yJ8M5y
         aPBdrdHrzg+V0usruyhFYzyOqNmaix/vXDG3VxrxhJ2R/TSximwqFl0HEpo6M1yjf260
         +fcwhke/y9u+GwwFvBXjTnp/ZylocVEk5ZaPp0DwhJ9vrfD+tgSbTgDofgsttYkGn4xh
         cLPZ7Va25wO0OrWsJM/2TAtn7oneyZCCr6D2zN1txLlqRCFlm56ZvuMsFjCNrZnokCYS
         q9W1WwWqTPFrakDUF9Q1vA/OVroE3U8PeyoyZY53EviifzjjJ0CghNKAYH464nxWaP3A
         hKhw==
X-Forwarded-Encrypted: i=1; AL+hErGP8r9gldEu/Z7+P9YWGr7y8Ofspg2MGwo1CTTTiNGSy0QBM5oRP5miyVBS1gK5P+YTDRGSemUrUQ==@kvack.org
X-Gm-Message-State: APuU4Z/RTCqhcQ34g60rA5Pc4pLZ1tEIzC2AWPjCy4xqttXFCuz3nY9I
	mXhmThkNUTL4z+XADI35h2FAqkdnji41dLqeZkosuF+XH12IRP13wZAP
X-Gm-Gg: AYBFou2/tFL/l4u/Mq+1X5aR3bOOvryd6uScv1L8Uh/jZBgMFVFbaQ7X5YFTZh7YIax
	SxhJ763qqgtwOREajx+N3RVyDnHsmTLzyKzzj/bNH0g1WdaRwjeNaIV3qj7FSgFHGL8OFsGqTaI
	yICjED2gIuW7lM/9bO3puPbbOZVDxF1I90tGD+B+2z5e5Snymy7h50n81KPBdhrWWiOhQ8NmYwG
	9VgthdwJeq2VNIFevD/cfeH15WD0KqvmqnZlN5FF15vzSs/QRpv2hz0XeqTJ6Uua3LrevM4K7CX
	UdgbjO26i287TTmXOHWN1+vSduH6KScfG46XAMIWhsP8A0af9qFan5N1UMT+BycUKbBjo1ZlTKA
	bTlCpQ6Z0EEcKKEWIxwtXpt2T033Q4udZzMZhR3KflyHutJB5abazSsVq37T+zQ+kVmDh9xvUQZ
	/UWj5Aeqi20PxsbZ3HprWe8mq7Rw2Oo2eNBwc2pHBLSOC0Qn+fKG2c1LBAnCHzTl8HiIGJX7a6t
	BfH1vo43sMoUHNiR/deVvIiNKuKVZatA+fzukvo6zSsWgTLyEw1uATdpp4S5e+L5wvPZcW9ID6G
	6L1pc7WLdeOyT0uc3PdRJNiAs8NOcd/qPA1FyDdAYJWIvVt4r7lVSTsSwokJgY0RkTUyYm8oQBs
	Ivw6n7CxuFQYwkA==
X-Received: by 2002:a05:6000:490a:b0:48b:a4b:5a2c with SMTP id ffacd0b85a97d-499c5783a79mr5463489f8f.3.1794416093393;
        Wed, 11 Nov 2026 08:54:53 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49836c835fcsm11451395f8f.59.2026.11.11.08.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 08:54:52 -0800 (PST)
Message-ID: <8c221ebf-ccc0-4541-bdc7-ae216d149dae@gmail.com>
Date: Wed, 11 Nov 2026 17:54:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/huge_memory: use the large-page PAT encoding for
 huge pfn mappings
To: Eliav Farber <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, William Kucharski <william.kucharski@linux.dev>,
 Vishal Moola <vishal.moola@gmail.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261111140655.34281-1-farbere@amazon.com>
 <20261111140655.34281-5-farbere@amazon.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261111140655.34281-5-farbere@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E35D240002
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3h4iqpfihjt7ig5ghbunzcie3d9dymqx
X-HE-Tag: 1794416094-274113
X-HE-Meta: U2FsdGVkX1+l1TC/sMJwR7y0M547U0G36vIC3Yuc0UVnwB4T6p507keqcEveoJ3dnHSFUS93EKhabyRBEcA98P/WgDJ033Y9U6ba0GjW3knJi3WJxHuqg0ca6oLfVWv194KEj+nQVJFrAahR09iFEjwkaysSXpVhI4Z6BzSE5QNeDEP7nyBxMqGoVUbwjMscuT6xoWbTR1hlRSN0muEJGh8X2v8BFoO8z7fSHCiBsX2mdogHzlk5LV98OeVkjwWTDHM33b/SXmIllNi3UAlV+DaqSbYtHbiI/Gxo4Crm/154ETJTH5bA1dHcXnwqsNIOMXOEB+AA3h41hnbOLNZu5wRXr5Jc5ZBDNG1d+a7f54fq2D8kOmD53XMbZTRG/39VX5Cok+MAC5NOuQudPbQcBmhpcQWJYvhAJuMDLr2jfGnynb2pHbm6KsJUIJkpHUNIi2hE1xld10hxTIxk7QRDY6jTQSMmh1PRjPy/wcG2R9x9hykcPYumdDirvTmSJjRdX1W5NTjCrUzwMLzLp1GrZKa8devIVGoOk7gasDmNRZ6gQna1vx1WvzTpYA8Y8zWRN/MrN0tONpYHVf0VuOZDXncfDlWHWPPcL6RoPJlra7G7nPfOJgRdW8m6H0h9WgiYSYz9tstQg5B4gGJqecIDmVNKRtmd+B7JK7ZI6ivcfKiYPPCDOcjHjgsDAfPV0yK5cF9ZePC0GGSWLGX4aZBmRCda7QhfJXTpMCXsK04H4s7ut84+1UkQ4gEuE5gvVHeYWrTld5scPK/Hl/VIke9eExAa3YVHyjK/5uUJ55modFUZ5RPzUkH0Z6Wthg8TZTmDYoXk/Z4WwDVPO2heMjZR3O+/UkbDYbWNa4WtLVsIlPaIFOWl65mpm5RQzSIOYhIU3Pcy6IsnON1OrTnMurOWQZFMG3s7PTRjr5zFp8adr5tLGnNuvHOXGZoXdgGFPgzMLA5yeSjDPhkVlvtXqWt
 YiVSeLL4
 KHk0vL8jStkNR3TwLR5ENiGAIj6x1tYC+I2LaWCYwkkWGueYpu15ZdjaHtdbKX9GQ376y3nfqk/0Ah/saE3I9wNtzL0mQK0t1iM9RBIcfoV0N+W+c2bntlcBg7yU8a5E/8n1WDhq12e2EbXJzCGjlEruqoKmPRLvqGd1iHXJuvPa5LgCZltMFS7OLOJ23+hiLUs73qO79J1oae6D0kWQcLf0BTy/+pOzFuJqAYNysdkgDGF7UuoxvETOL/ynPSFEDf8qnR2FKYMvO3Qe4t9HmjdsNPZCn6x/88FKh0CwrWdYbviMleMShh1bXJF0Jffb8hko4h7899JyUWmqgOtQmE1LOBlWlBjl01FMp4jJYV/hjLQik8DZa+fz8uVL3TNCLrQy+e7PsygqcwLogXEDebnhM+6czXBj9SSPaOwlyhc6hiSYOer4BSva5giHu2jhEFhiZYoYKKwCWzWVnYV/ixml9LisBx/gw259pWcx9W37DGbhneKYvFWRgyboXiTNyy3qhl2v2oB6/pn6INff4fqOVijmT/d8wwZEdQyU7tCXUEoXMVvzdcBI7G+ct61o+FofmULI5avVTrGP+9Tuv7wJbWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 3:06 PM, Eliav Farber wrote:
> insert_pmd() and insert_pud() build the entry from the pgprot that
> vmf_insert_pfn_pmd()/_pud() took from vma->vm_page_prot and passed
> through pfnmap_setup_cachemode_pfn(). That pgprot carries the PTE-level
> cache mode encoding, but x86 keeps the high PAT bit at bit 7 for a PTE
> (_PAGE_BIT_PAT) and at bit 12 for a PMD or PUD (_PAGE_BIT_PAT_LARGE),
> where bit 7 is _PAGE_PSE.
> 
> A memtype that needs that bit, write-through or write-protected, loses
> it: the cache mode index of the huge entry drops from 4-7 to 0-3, so a
> write-through range is mapped write-back. The other x86 paths that build

here contradicts the cover letter, shouldn't it say the same as the 
cover letter since its the one right?

> a large entry from a PTE pgprot convert it first, see populate_pmd() and
> populate_pud().
> 
> Convert in the two huge pfn paths. Add a generic pgprot_4k_2_large()
> that returns its argument unchanged, so that only architectures which
> encode the levels differently have to define it, and x86's existing
> definition is picked up.
> 
> The folio paths keep using vma->vm_page_prot as is. They map
> struct-page-backed memory, which x86 maps write-back.
> 
> Fixes: 6857be5fecae ("mm: introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud")

I think that 5cad465d7fa6 ("mm: add vmf_insert_pfn_pmd()") would fit 
better, IMHO.

> Signed-off-by: Eliav Farber <farbere@amazon.com>
> ---
>   arch/x86/include/asm/pgtable_types.h | 2 ++
>   include/linux/pgtable.h              | 9 +++++++++
>   mm/huge_memory.c                     | 4 ++--
>   3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index b1a669e775f4..b1ffd72e47ef 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -497,6 +497,8 @@ static inline pgprotval_t protval_4k_2_large(pgprotval_t val)
>   	return (val & ~(_PAGE_PAT | _PAGE_PAT_LARGE)) |
>   		((val & _PAGE_PAT) << (_PAGE_BIT_PAT_LARGE - _PAGE_BIT_PAT));
>   }
> +
> +#define pgprot_4k_2_large pgprot_4k_2_large
>   static inline pgprot_t pgprot_4k_2_large(pgprot_t pgprot)
>   {
>   	return __pgprot(protval_4k_2_large(pgprot_val(pgprot)));
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 780fe849ff8b..112814d31f0c 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1787,6 +1787,15 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
>   #define pgprot_mhp(prot)	(prot)
>   #endif
>   
> +/*
> + * Convert a pgprot built for a PTE so that it can be used in a PMD or PUD
> + * entry. Only needed on architectures that encode attributes differently
> + * between the levels; elsewhere the pgprot is used as is.
> + */
> +#ifndef pgprot_4k_2_large
> +#define pgprot_4k_2_large(prot)	(prot)
> +#endif
> +
>   #ifdef CONFIG_MMU
>   #ifndef pgprot_modify
>   #define pgprot_modify pgprot_modify
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 052c50dadc48..945d480c1512 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1675,7 +1675,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>   			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
>   		}
>   	} else {
> -		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
> +		entry = pmd_mkhuge(pfn_pmd(fop.pfn, pgprot_4k_2_large(prot)));
>   		entry = pmd_mkspecial(entry);
>   	}
>   	if (write) {
> @@ -1804,7 +1804,7 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
>   		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
>   		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
>   	} else {
> -		entry = pud_mkhuge(pfn_pud(fop.pfn, prot));
> +		entry = pud_mkhuge(pfn_pud(fop.pfn, pgprot_4k_2_large(prot)));
>   		entry = pud_mkspecial(entry);
>   	}
>   	if (write) {

the code LGTM in general.

-- 
cheers,
jose a. p-a

