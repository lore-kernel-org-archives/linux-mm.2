Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9215CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 11:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E551B8E0010; Tue,  9 Sep 2025 07:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05208E0001; Tue,  9 Sep 2025 07:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCCC68E0010; Tue,  9 Sep 2025 07:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8E138E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:42:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AB42140451
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:42:35 +0000 (UTC)
X-FDA: 83869524270.30.E84685A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 03ADB80006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:42:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XURj5asx;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757418153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUGU+TjHtTHHLTK2zHbFOGsi468ffG0Hp57VOnPF+Rk=;
	b=RuIa4sxS3TVuCvvkkugmlK3HyRFXxvN6Jc99QQUqTdSgdXJ/pq/APnzl+9sC9n8Y7e6ADi
	PhmDTj7LLNyX7yIEpybhlN8n0hucs7w/s0rm0TBt8G8S/KyLFNgnX3W9cSY36+wegy+hlb
	kwIuIrsnRp+R1xFO0cm9F+vmI691tZ8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XURj5asx;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757418153; a=rsa-sha256;
	cv=none;
	b=rko2ssJxtX4YDL1zpEXhoEsDbe20zivyUfWZRXnWVWtJOgttgw+UzGzwjdqtIkGf+aXHLI
	1EOTZ8bwvbJv5Zwsw3UACkcNX0h5IUGFXGMOcYl881Bc3mWfPH3nM2mt8ytWqp6xNsppfe
	1k1QSBUSmoLof32nnRFXxALkv+ByJQ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757418152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tUGU+TjHtTHHLTK2zHbFOGsi468ffG0Hp57VOnPF+Rk=;
	b=XURj5asx7KBEiw0pBstgaPKlyImzj/RMxcAmhiG56aNffbzvc7Sn+GqjVTIyMKG+3Wk2yn
	6zQ9qdZ5IMxdw4ntXJmoCqPJJ5P8xrRkKqPR19Z7qpTs2MRzkhQlp5tNkzF9xLevLHl1VZ
	7UKnRbqSWIkzdPVav3rylDR3RLJAS2E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-FTE6PP6yNRmzJNQWQKbmzA-1; Tue, 09 Sep 2025 07:42:31 -0400
X-MC-Unique: FTE6PP6yNRmzJNQWQKbmzA-1
X-Mimecast-MFC-AGG-ID: FTE6PP6yNRmzJNQWQKbmzA_1757418150
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e26569a11aso2748712f8f.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 04:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757418150; x=1758022950;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tUGU+TjHtTHHLTK2zHbFOGsi468ffG0Hp57VOnPF+Rk=;
        b=M9IDyjE1PCofOywqbYS0XI+dfsdWIIaJos0AliDFz/X8/nizXHROd0EqShh+H0daij
         ZYsiYBu+8ar6UIK4ZuYiz7oWQB37f08mtPAJ6rTZ9bguDkmtnItMXEIzpDMTjurpQxPZ
         hLirBZSkFySNi5DGuT8vmgaYiUMsufiqMMoReCoPYyxxuLn1bT6e8VPOGpkrWpODsqhd
         Z80S0wjKksHN6YytYHQCJRSz8eYWr2rEUT/FxPqJOhF7Utw2KLnYhpcVmsChV4ZZwd1Q
         yVjeeWmCsXR/8ZdX+fP2ahAP9g2dx9VsHgxbQJhZ4EFp5xcdpZYyUTW5iZ3RVnQHeNlH
         85kw==
X-Forwarded-Encrypted: i=1; AJvYcCWOCICPaQolxtwFcC9adeNZbWCQBEEk46cJIV3mDNPOdYNFEHajOYOvYcY+de2/iDJvc02GwY6hBg==@kvack.org
X-Gm-Message-State: AOJu0Yz8cbwTJU8/DiWI8tTLppGbj0XrHu09Ye5+zK7CQS8kKdGWn1vr
	tdfpX9ASPPT4A2ii+pH8X402aHDug6vwlRAr4LdsVEIRT5FP204Uxgx4ZEisSJ6iObluV1z825j
	l5yHap1sXeS2y6uMYkw0SuD4FzV88TN+v6GBxzuu/E96AA0+Nh1ZQ
X-Gm-Gg: ASbGncvIK1zydddeQT/OZMxdJfkz33oseBNVidK1Lvs3KRr1J5aEkb/iJz6wiAD9GLM
	GnulHNNvMvTsTXXl2PIJrfcd+WK1yg0BKJzGZr+NKEuDl14Qw8MoSX3TYo0bfkVhgrenlR+8+9u
	mavhL49Lzl4GS6jfnx/RsoOHozDRvi0FysXXVF7PnXweYbfT8qI/ZvIYSaorHKg7u2Pkalk+k8f
	4kQR6NGZne4L/HEiah1ddRcoIXwnCkcC6e9tWEvmKbRaojnfDnOKtC26RJkPk/B3on5GNigYIjh
	1Yw1veObO2Z9ruit9W9wzE1BQyvTC9uVk6+huCIgw+hxbh2WRtnrCIQJ3vUOqznrSDp+yw==
X-Received: by 2002:a05:6000:420f:b0:3e5:3346:6e91 with SMTP id ffacd0b85a97d-3e64383717dmr10654847f8f.34.1757418149851;
        Tue, 09 Sep 2025 04:42:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKFeXgvK0zu78cnS/MrxQ6hYkXo2ROCVXFAQC8NTjQM7+aKrD3KcmqhXZxE0LXSSAZhwTOPg==
X-Received: by 2002:a05:6000:420f:b0:3e5:3346:6e91 with SMTP id ffacd0b85a97d-3e64383717dmr10654811f8f.34.1757418149387;
        Tue, 09 Sep 2025 04:42:29 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a41f.dip0.t-ipconnect.de. [87.161.164.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e75223ea15sm2306665f8f.47.2025.09.09.04.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 04:42:28 -0700 (PDT)
Message-ID: <6b2f12aa-8ed9-476d-a69d-f05ea526f16a@redhat.com>
Date: Tue, 9 Sep 2025 13:42:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V10 1/5] mm: softdirty: Add pte_soft_dirty_available()
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Deepak Gupta <debug@rivosinc.com>,
 Ved Shanbhogue <ved@rivosinc.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
 <20250909095611.803898-2-zhangchunyan@iscas.ac.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250909095611.803898-2-zhangchunyan@iscas.ac.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K-9IJwBXHKKtnZatj5buJFqTQvQgIGE5W9za4oos-sQ_1757418150
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5zgn99akqfqidseq9kgux3hf45m1z9fx
X-Rspam-User: 
X-Rspamd-Queue-Id: 03ADB80006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757418152-172558
X-HE-Meta: U2FsdGVkX18G9RhPWH7ZgNRSW84eTFMTBYbF5qRKQSa1JIHBMVqvquMjqr4fVOOf+A9eUoFrhZzIXVdBywpA7ZQTQdfCwdC8l/aQiIMnIcX9Fg+18LGFF8mbxInabGEt7sz86HW2OK/nvnrOgP5Lcn+V3qzbt7WwpaTQptnRhDkU2S6XLdDFjfY09+59pUz4/JZRy7gFDF1m5x8S2mnwA2g6CNpMrUuJz/OZWsasXdJpyJVWutEMwHwgyiKKhLT+v8UKrsIXZZy7rvKkkOYnkQ8oHningcdBoFpoTok0VQGWbTCAylSG4DRFT0cbHziye01vyOsgkDpqTAEUisq1xLQW0SPLtMfPagv9ucL1Lcfd4q4dkhOtib3qCG5t+FHXaEFyM5QGjXlc7jS1cYuB6LL4lm4pN8N2e+sthWv3yr4aoIhUGbTU9+0KWZJlWyW+jC4ARPrPBdBWOfq/7rG/NssAktxp+zG8yFwdMoUaloVtBhL6l5utuAvWIE9f/fGVr1gnLK6E5wQMfpOSWXqUPGFCEf4x37uwGyXjJjaSyXyl6w06BdyIpKGU/N1RRPxi9t5B5j8+QjDyG30AJzvB2gZbtKQ8PxRfYg+Jz5/pBMopdmrRCJak2Qwptdpw6nWqJpRF0mg2ernWKsAdwa/3n6ITovjp7cVA1PiN5ecz1goKE4/jlsafr4FYa3Ioxoeg9dMlSVhJDVpwJ4D6mkiyeaAaeMF+nT9r0+J6RTuF0gNWZyRF35/LaW7t9SgKJ+EwUxsnN9NSYlLMkAWzBQ3fnlxz+Z7RmF9s5RzWyxyeHbiH2jpzrdPhVLyd1t3rYkHt84UCQwCigdq+MNj7qmEWDFy6ZZu1ULzRajClY5tG6aE3kjSXEB/gnqfSNm+HKzBm5dDem0KbPd/2xiA7/MMmrxCBBypxYp+ZhGH1xapK9GvDWNoZpzU1pIbkv/et8KkK9IGtS5CfM7ilGPQgxBC
 JgH0jwif
 7WTrnMvm0LNm4kJT5Nh8yl1lwpN7mx9sl6bSMURaSTZqxPihQGsOnq9V2wP963ZzarraNajxct4Iuu5PgkWzdk/ssuJWxcfqcuqCyBTimWTWDvWDjbNXp/5VEjESDk7xEsWzL0ylMDpOhHr/7ULI1I1diWIEeM09fvNAWPEOBzUZXDg2YYGJQ3/eq7+RynKSG/px7BjiMYp63Oo5U09tZxPfkSfeEPILYJFYWgkR1DSpO0CzE78m3aGRLymrHx8ndqbscazFiunFbdeKQdeHziabtqvswwlv5VaMYl2NdP7xBQaWM9jmR7EiSR3+N25H1N5SnMdgK7eXq2PQe03iBigJkkGUMo5M4Vu9mSqbc65WPd+/gLcBJEuqToe9foTRZnS4zZymPUrR5uubGXO0ezufmk4MZIXZzuMz8DLdd2KH4qZel6pLjKPY23g/Q1CnGFYBUWHolNGzFsMIJMr6vnn0pMZg3eVfJtAgs6rdKAziB71hx79o+eOXcdtvUmHmRj1MU2I692bKpVCLnAM9Lf5xYzAC/IH3Kapum
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 11:56, Chunyan Zhang wrote:
> Some platforms can customize the PTE soft dirty bit and make it unavailable
> even if the architecture allows providing the PTE resource.
> 
> Add an API which architectures can define their specific implementations
> to detect if the PTE soft-dirty bit is available, on which the kernel
> is running.
> 
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>   fs/proc/task_mmu.c      | 17 ++++++++++++++++-
>   include/linux/pgtable.h | 10 ++++++++++
>   mm/debug_vm_pgtable.c   |  9 +++++----
>   mm/huge_memory.c        | 10 ++++++----
>   mm/internal.h           |  2 +-
>   mm/mremap.c             | 10 ++++++----
>   mm/userfaultfd.c        |  6 ++++--
>   7 files changed, 48 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 29cca0e6d0ff..20a609ec1ba6 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1058,7 +1058,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>   	 * -Werror=unterminated-string-initialization warning
>   	 *  with GCC 15
>   	 */
> -	static const char mnemonics[BITS_PER_LONG][3] = {
> +	static char mnemonics[BITS_PER_LONG][3] = {
>   		/*
>   		 * In case if we meet a flag we don't know about.
>   		 */
> @@ -1129,6 +1129,16 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>   		[ilog2(VM_SEALED)] = "sl",
>   #endif
>   	};
> +/*
> + * We should remove the VM_SOFTDIRTY flag if the PTE soft-dirty bit is
> + * unavailable on which the kernel is running, even if the architecture
> + * allows providing the PTE resource and soft-dirty is compiled in.
> + */
> +#ifdef CONFIG_MEM_SOFT_DIRTY
> +	if (!pte_soft_dirty_available())
> +		mnemonics[ilog2(VM_SOFTDIRTY)][0] = 0;
> +#endif
> +
>   	size_t i;
>   
>   	seq_puts(m, "VmFlags: ");
> @@ -1531,6 +1541,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
>   static inline void clear_soft_dirty(struct vm_area_struct *vma,
>   		unsigned long addr, pte_t *pte)
>   {
> +	if (!pte_soft_dirty_available())
> +		return;
>   	/*
>   	 * The soft-dirty tracker uses #PF-s to catch writes
>   	 * to pages, so write-protect the pte as well. See the
> @@ -1566,6 +1578,9 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
>   {
>   	pmd_t old, pmd = *pmdp;
>   
> +	if (!pte_soft_dirty_available())
> +		return;
> +
>   	if (pmd_present(pmd)) {
>   		/* See comment in change_huge_pmd() */
>   		old = pmdp_invalidate(vma, addr, pmdp);
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 4c035637eeb7..c0e2a6dc69f4 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1538,6 +1538,15 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
>   #endif
>   
>   #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> +
> +/*
> + * Some platforms can customize the PTE soft dirty bit and make it unavailable
> + * even if the architecture allows providing the PTE resource.
> + */
> +#ifndef pte_soft_dirty_available
> +#define pte_soft_dirty_available()	(true)
> +#endif
> +
>   #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
>   static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
>   {
> @@ -1555,6 +1564,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
>   }
>   #endif
>   #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
> +#define pte_soft_dirty_available()	(false)
>   static inline int pte_soft_dirty(pte_t pte)
>   {
>   	return 0;
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..98ed7e22ccec 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -690,7 +690,7 @@ static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
>   {
>   	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
>   
> -	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
> +	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) || !pte_soft_dirty_available())

I suggest that you instead make pte_soft_dirty_available() be false without CONFIG_MEM_SOFT_DIRTY.

e.g., for the default implementation

define pte_soft_dirty_available()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)

That way you can avoid some ifefs and cleanup these checks.


But as we do also have PMD soft-dirty support, I guess we would want to call this
something more abstract "pgtable_soft_dirty_available" or "pgtable_soft_dirty_supported"

-- 
Cheers

David / dhildenb


