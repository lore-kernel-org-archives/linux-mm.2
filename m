Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0880CAC58C
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22CD08E000A; Wed, 10 Sep 2025 04:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD318E0003; Wed, 10 Sep 2025 04:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F1C8E000A; Wed, 10 Sep 2025 04:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3EF58E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:51:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DAB4BB898
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:51:18 +0000 (UTC)
X-FDA: 83872721436.08.1FB1FD2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13F1580002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:51:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SmVy4Teo;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757494276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxDchDCxzvL/sWuMLY6CnxonULRA1/iVTZkrVNF77OQ=;
	b=mTkBzTCzq88ynVeHUcFK2k6bucVLDM+8C5HVo5zBFpfSbk4z3HqEUCS89C7vBOH8QTQ7iP
	M+irRFqTvjZgeGk2LWxSbRzaWMhw/xvDOwUYwwV9lIAv6qbVqgXQBAc27eOaHegW4MmFAb
	GaBTHJPeLYAm7SP4zla7khMHw2zmaxU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SmVy4Teo;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757494276; a=rsa-sha256;
	cv=none;
	b=CpzCFo0W4NyOyDEeTiSMsoywVjFoicnnGjQCGSTJzcFPVir7fHYQ2s2+QQmX1QmO7fmhNC
	OUhdSOweaUMM9vqzk1YIqiWxe3ddljwZ7uBiPc/erfCjlnD67BCoovXMEq0jPbxX94EGVK
	QjPGkK2+8eqWy71CQ3yi3y9AKeOiMII=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757494275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YxDchDCxzvL/sWuMLY6CnxonULRA1/iVTZkrVNF77OQ=;
	b=SmVy4TeoGAoDx+yv4d2UaWxhS5MoQfq7gEG8jfCyy2iEh5DZpVbjiHKnPPiZluyuwQVCSa
	X5wuUOCRV1FW26TswQQZb/HGOFWwtu3dvzsKOKhfj1jdEOU5j35X/+dlfQxlGQjBpzhpnJ
	6CsHito9k4e2IjlIECyqSRl1iGuv3Y0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-D8lldl-pMzKzRrEoP5fmzQ-1; Wed, 10 Sep 2025 04:51:14 -0400
X-MC-Unique: D8lldl-pMzKzRrEoP5fmzQ-1
X-Mimecast-MFC-AGG-ID: D8lldl-pMzKzRrEoP5fmzQ_1757494273
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45ceeae0513so37271375e9.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757494273; x=1758099073;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YxDchDCxzvL/sWuMLY6CnxonULRA1/iVTZkrVNF77OQ=;
        b=Zh/PtVyb/Ur2McsChnilp2iTi9/HMsWQc0/4KdHcxnwlp9CM8t/CLj0oBAvHa3/JAN
         0ckqD1nkpq3VdQ1+l7Msadkh9TMA46vflTMyX02RWvhmoFUyYJMhXI0Vre82IUKjUQUs
         ovxWtdBCl2bWrRS+BqypTyOk8+QLDU267lDj1OiigaoedPQKWKkuXDuB9Gt8+Lp2HNbM
         jfD3xnKRs+r15hv7WiIp9Ra0gyMzBcPlj9bTi23l9Are2Nm9fb54IFkgm+WmnsCIiJZm
         WcgjE0yQPcJQ4x0cACjnTuqNrwN7gbYW8xwsnsPIcnqTQyXoa1xRlIWw6f8hJ4deIRmW
         kviA==
X-Forwarded-Encrypted: i=1; AJvYcCVqxlBC9lUM0aOtkuyJxFbi3waMepUQx8gLB+xiG9aIkdoysze+iSm0xR3h6co2mA6ncio4idtfZg==@kvack.org
X-Gm-Message-State: AOJu0YzPK7L8AJ3dm2b/qostMEeJS98PPK2qVbUS3ElXAThHUTPNAwt+
	Vn79e48/nxAo9uMFTeJP2FhV/snbgXKJ1QGEqwRogZrXgD0gyisJ9EAXKJ1BYaEYI8N3mvL0HAW
	4wbnJiOOrEwi8fY4ZyA2Iz1mTsL0iLnAaxwdjsExFUuz/ChufB2vW
X-Gm-Gg: ASbGncuDkWvfq+iEpezCMeokgAPrdIJtoS6I1wJisUPfeFt/Vnke4T37/MCAKISoL4b
	U8tIV/c4Lcs4vW3kW8yPF1i3OOf/EYzW2InnOz8lqmk6cMtAPa1bKVBhdUYmEohesr5pD1fGX3g
	lhBiGP7rLyGbC5QnU8fLIQivXfZCTxNkZtUndZcRG7SraVCmhZsxH0t/9bkmbJtp9YBOCOtYfQ7
	XBjmSosQxkXKwRvRQMYlKXrooJT4BkRkK2+HscQFH4vpNGd4LBxKflWHutvk4jBSV3JZRyaY9us
	hmd/Du5uEdTg9n1i6+SKj61zHSjEVuuIfeBCmYvvlA3pEeMNf1c4qAoTyodEbHMsXqSLzWTwN+N
	mdxkBHTII8CBn0GhCEfnnmIp3iSXgBBvAh/djPgC7orUNWAp21B3JW0fnTELMTX3cjfQ=
X-Received: by 2002:a05:600c:154f:b0:45b:7f72:340 with SMTP id 5b1f17b1804b1-45dec73107dmr57540835e9.25.1757494273015;
        Wed, 10 Sep 2025 01:51:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEb4T8T/4bN/izbrmhcz9dw5qzIFBCO9XthnHygK+hqHa7tRGOdKsmmaUtKsFPouf6Ua2AQ5g==
X-Received: by 2002:a05:600c:154f:b0:45b:7f72:340 with SMTP id 5b1f17b1804b1-45dec73107dmr57540395e9.25.1757494272482;
        Wed, 10 Sep 2025 01:51:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f17:9c00:d650:ab5f:74c2:2175? (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bfe00sm6230360f8f.5.2025.09.10.01.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 01:51:11 -0700 (PDT)
Message-ID: <8f9a4a13-2881-4baf-ab62-3d0d79e0cd3c@redhat.com>
Date: Wed, 10 Sep 2025 10:51:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V10 1/5] mm: softdirty: Add pte_soft_dirty_available()
To: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Deepak Gupta <debug@rivosinc.com>,
 Ved Shanbhogue <ved@rivosinc.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
 <20250909095611.803898-2-zhangchunyan@iscas.ac.cn>
 <6b2f12aa-8ed9-476d-a69d-f05ea526f16a@redhat.com>
 <CAAfSe-vbvGQy9JozQY3vsqrrPrTaWYMcNw+NaDf3nReWz8ynZg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAAfSe-vbvGQy9JozQY3vsqrrPrTaWYMcNw+NaDf3nReWz8ynZg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XnggQ4EAboFnkjSeIu_3KkwZSyl3HwMDPg2UG0nMcNE_1757494273
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 13F1580002
X-Stat-Signature: utwyqsdnqawrb3azpi4obygxkgik4dkk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757494275-715966
X-HE-Meta: U2FsdGVkX1/+O81qjEThiLsizcohjzOBINySLozTtMSKFmPEdFIwmohW8HCH719tP2AdrTJoEMlHeE5g5ssd5ZK/WoGblsnaHiLR598N8R9io27Um9ZHCjHZSLODRqLPJBww7ZvQenBFauOFMkIcuswST91PPaY9ch3nS+nRTpNaSxKDZXEgZihlOJhLOV3R3W0lxARpvX/WrgGnLYpeSjkhG1/w8mOqTWP2Rn6ikZ0rl5reAlfFfb3Ev7wJUpOcsfk2sMdShM/IwF1AAvTUhbRqIxxUvkOPFzCDkC+G9F2w5du/7BohLCbMg+pIWgYKXtyNNt3rRuG63ZaQDOkRzm2k2IULlNPwFTxNuJ/hKFBYDY4NHoIXw9yujmRDokOLM4vq9z60vKeugF/tx4IZiB55hdvCplBc+b1NjpEi595JIdGGcRhzFyaBmblv2JpI9mf1d8fj1EnSY5tzYonFdhu4dfohRHw39OY/9wETW6I62A5cyEvnoMko/ed62pI1Adn0Kaxk7ZAAG42sSnKUqqZSFBw9ywllk1gku2VSNWgjPe+YRUKyKc3Lxp1/M//Kpk/4N4kHg03b3atL6X5vKkTxbGFHfQQKmzHV+0AdO0d81xHcVo+byW4etDjUAKaWmmqZ+M3lBP8zmfB0Qj1ydidhfK1qvtxd+kYl8URpd5ZwhvbXjwpNFIPIkFurBBWhhwnunZXptNvyImsrstUByOBUyaB3lv4BMIsRO1bPG0xCIkoF7MgSh8OPxtrXeoKomaufmN4QMo1AdwTfvjBPX/ayJQw1ub0ENrDzBdjNr7Jna5fX3epavjfU8udGUKN+GfEFw2GbJZXmApvWQnmDNs4HIYslQzRAdr6AwgFLg1VdRYMWHo9Yf94DaVEfH0VnhlOngbV6U/CqcPRWjjCfcGFy6QZx4dT5JX4hguJHXLP8o//4Y6tIBugGOuxswitT/IezCBZWn1+WF3fWrKQ
 Tw72Zqhp
 9EmGL2WdjQz3ohJfqXzCsKY/i6S7zaQUoWDFikMyKdzgcoIU5U07Y9u0/H0NokO6Q7tQh1a8HS9ROLyaU9bon0TwjDqnkDkCgRQmhLb1z9ZEzG0tyNenBYNOPe2W9HZXR+wmrRNZvubRnUJAKc+1BuapMqNDKGm2x22j3B2qc3GRXA4T2t0a7VKfVQO8uDF96JSoQLecBOsZAY9LaevRLcpJ/duk0Hgu6xkeu00Gz1PsH/Ljw6DLXRDRuqAMGT1tJLwHW/1BXJT5zKx8O+o5y+PSM02r10tAKyIJds+G/m0ZAaAQwCgoRaU77w9QeLZYpzirI3Gan6ykhnX3PKBPbvMd+Pp/hDaEUfiRG/bqmbkTVSPJXWLG7pVZrBKXnHyB8wjQYIJnlztCPGXiQwnGYq8PgpAZF2szml9yr000J8d8tqnAXZvmEy7cbOIW7d+kvqZsaS/Dwn593lU+4PBTD2lRHFTEUZ19jbDT3/UV4hEkMyGB2pG2tKIhm7R11TUrXi0ZHZ/RvHkQh2ONbYtUlZW8uIkyaq3RW1yfYDL4gJ3HMA+nAIlW4VJl9oABi9FvCxlLc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 10:25, Chunyan Zhang wrote:
> Hi David,
> 
> On Tue, 9 Sept 2025 at 19:42, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 09.09.25 11:56, Chunyan Zhang wrote:
>>> Some platforms can customize the PTE soft dirty bit and make it unavailable
>>> even if the architecture allows providing the PTE resource.
>>>
>>> Add an API which architectures can define their specific implementations
>>> to detect if the PTE soft-dirty bit is available, on which the kernel
>>> is running.
>>>
>>> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
>>> ---
>>>    fs/proc/task_mmu.c      | 17 ++++++++++++++++-
>>>    include/linux/pgtable.h | 10 ++++++++++
>>>    mm/debug_vm_pgtable.c   |  9 +++++----
>>>    mm/huge_memory.c        | 10 ++++++----
>>>    mm/internal.h           |  2 +-
>>>    mm/mremap.c             | 10 ++++++----
>>>    mm/userfaultfd.c        |  6 ++++--
>>>    7 files changed, 48 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>>> index 29cca0e6d0ff..20a609ec1ba6 100644
>>> --- a/fs/proc/task_mmu.c
>>> +++ b/fs/proc/task_mmu.c
>>> @@ -1058,7 +1058,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>>>         * -Werror=unterminated-string-initialization warning
>>>         *  with GCC 15
>>>         */
>>> -     static const char mnemonics[BITS_PER_LONG][3] = {
>>> +     static char mnemonics[BITS_PER_LONG][3] = {
>>>                /*
>>>                 * In case if we meet a flag we don't know about.
>>>                 */
>>> @@ -1129,6 +1129,16 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>>>                [ilog2(VM_SEALED)] = "sl",
>>>    #endif
>>>        };
>>> +/*
>>> + * We should remove the VM_SOFTDIRTY flag if the PTE soft-dirty bit is
>>> + * unavailable on which the kernel is running, even if the architecture
>>> + * allows providing the PTE resource and soft-dirty is compiled in.
>>> + */
>>> +#ifdef CONFIG_MEM_SOFT_DIRTY
>>> +     if (!pte_soft_dirty_available())
>>> +             mnemonics[ilog2(VM_SOFTDIRTY)][0] = 0;
>>> +#endif
>>> +
>>>        size_t i;
>>>
>>>        seq_puts(m, "VmFlags: ");
>>> @@ -1531,6 +1541,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
>>>    static inline void clear_soft_dirty(struct vm_area_struct *vma,
>>>                unsigned long addr, pte_t *pte)
>>>    {
>>> +     if (!pte_soft_dirty_available())
>>> +             return;
>>>        /*
>>>         * The soft-dirty tracker uses #PF-s to catch writes
>>>         * to pages, so write-protect the pte as well. See the
>>> @@ -1566,6 +1578,9 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
>>>    {
>>>        pmd_t old, pmd = *pmdp;
>>>
>>> +     if (!pte_soft_dirty_available())
>>> +             return;
>>> +
>>>        if (pmd_present(pmd)) {
>>>                /* See comment in change_huge_pmd() */
>>>                old = pmdp_invalidate(vma, addr, pmdp);
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index 4c035637eeb7..c0e2a6dc69f4 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -1538,6 +1538,15 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
>>>    #endif
>>>
>>>    #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
>>> +
>>> +/*
>>> + * Some platforms can customize the PTE soft dirty bit and make it unavailable
>>> + * even if the architecture allows providing the PTE resource.
>>> + */
>>> +#ifndef pte_soft_dirty_available
>>> +#define pte_soft_dirty_available()   (true)
>>> +#endif
>>> +
>>>    #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>    static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
>>>    {
>>> @@ -1555,6 +1564,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
>>>    }
>>>    #endif
>>>    #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
>>> +#define pte_soft_dirty_available()   (false)
>>>    static inline int pte_soft_dirty(pte_t pte)
>>>    {
>>>        return 0;
>>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>>> index 830107b6dd08..98ed7e22ccec 100644
>>> --- a/mm/debug_vm_pgtable.c
>>> +++ b/mm/debug_vm_pgtable.c
>>> @@ -690,7 +690,7 @@ static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
>>>    {
>>>        pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
>>>
>>> -     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
>>> +     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) || !pte_soft_dirty_available())
>>
>> I suggest that you instead make pte_soft_dirty_available() be false without CONFIG_MEM_SOFT_DIRTY.
>>
>> e.g., for the default implementation
>>
>> define pte_soft_dirty_available()       IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
>>
>> That way you can avoid some ifefs and cleanup these checks.
> 
> Do you mean something like this:
> 
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1538,6 +1538,16 @@ static inline pgprot_t pgprot_modify(pgprot_t
> oldprot, pgprot_t newprot)
>   #endif
> 
>   #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> +#ifndef arch_soft_dirty_available
> +#define arch_soft_dirty_available()     (true)
> +#endif
> +#define pgtable_soft_dirty_supported()
> (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && arch_soft_dirty_available())
> +
>   #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
>   static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
>   {
> @@ -1555,6 +1565,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
>   }
>   #endif
>   #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
> +#define pgtable_soft_dirty_supported() (false)

Maybe we can simplify to

#ifndef pgtable_soft_dirty_supported
#define pgtable_soft_dirty_supported()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
#endif

And then just let the arch that overrides this function just make it
respect IS_ENABLED(CONFIG_MEM_SOFT_DIRTY).

-- 
Cheers

David / dhildenb


