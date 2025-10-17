Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 659D6CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C136D8E0029; Fri, 17 Oct 2025 13:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9FD8E001F; Fri, 17 Oct 2025 13:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8C88E0029; Fri, 17 Oct 2025 13:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99D6D8E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:10:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4ECE71A02AC
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:10:36 +0000 (UTC)
X-FDA: 84008245272.29.7570BA8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id AF64412000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:10:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XeZXesqc;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760721033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UK8HD9G+Kwd4HVQdRALdCmHeg5SXgo45lh6yR0QBxjc=;
	b=F1ND4GBQWBLgplFNVvuLSus7ZS/Omslgi9oezcxsfWai363Wle4kgfC4voxwb2nOh1juGJ
	ta0Mzbp9yXoiB5jyoAz8vqjPjTZVGcaq6IDomS9B23XS0EccPyddP+QaPT0JULuHgx7Tkq
	/u22RhO4UnqM1b7vtUx+ntuNnGu7s4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760721033; a=rsa-sha256;
	cv=none;
	b=xuED7L6FW6MFw6si7h+u9lbDGRKr0ffZ41dy7VKv+TK94aYW9QF84fImJepEZJvWF7F1cE
	ntigrnS+MGo0dES1uET3vMWHyZ0jlrnBddblR8ul8mDoFKb75WRNlRWt6yB7t9i4ULCmzR
	wBWLUSOEuByXduxjhnz9WE9uXCUf4ys=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XeZXesqc;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760721032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UK8HD9G+Kwd4HVQdRALdCmHeg5SXgo45lh6yR0QBxjc=;
	b=XeZXesqcKcSzCERaE+ZcHSi71eLSGGUmPpiJ0NzzPICe9ZNtBXkHYbNUEcXIqNieaFMd/E
	EWi43DUwrNcZJPWd4+gNN9GVB+9Hj0gnpu0O1uumyBFq9pPJ9Mcx2s4f0cPRH1QR/vTn+q
	Y7kCneCmgghxjcVwHKMGwuwZonO+NFk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-pvaEcaJqP6S7LsVfrVRrmA-1; Fri, 17 Oct 2025 13:10:31 -0400
X-MC-Unique: pvaEcaJqP6S7LsVfrVRrmA-1
X-Mimecast-MFC-AGG-ID: pvaEcaJqP6S7LsVfrVRrmA_1760721030
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471168953bdso15403335e9.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760721030; x=1761325830;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UK8HD9G+Kwd4HVQdRALdCmHeg5SXgo45lh6yR0QBxjc=;
        b=Muy2AFBCfTeowFQLRoEMZ14ENZeRBQzdDgpfEUDQtELZRG511GGPRJ7VFlhf4ftdgs
         0UCLiJluDunrUmkjog9t9NmeJBvrAw5VwkJcHaQ4zjy7uRQt6rKsBZO+AicD02TUWGEe
         LrSXl5dUWVnrqBepYSIrkpblLPT/lS5ABmC7HNyK+VJVjB0JnQy6UuFzf/yttIH0MUjC
         xYWdQXdDK1q55EIgnNMQbqHDx1TF1xT3KD6N6o6R3eRjWwqGGT5hIMtIDkd/vsk9uJ6T
         xnhEwXcQT7VSIilVLfF2QpS6W2jNFZBvDFGKez8s9Su3YxqPrEZSCyStCWPaGpt5OhDK
         AHJw==
X-Forwarded-Encrypted: i=1; AJvYcCU9Ert5rdoI8K8tWeGN9qcIh2cGCNxN2T0LwEfQ8gLcZElIdFNbseYcae5vp0yPz3NsddxmRfjUMg==@kvack.org
X-Gm-Message-State: AOJu0Yyjx1NNMogCmGa6Qa6kyOnaiS5DHGxBEm4BjOU9K1Ftb3Plznyn
	UbUgtb/+Bo1PthG5vDKHWP1g7ZLPeJyMwKJ0SphyWwAKUeMOj3DeuAlOx6a6MTYvWLRuvt1+mC+
	FIvRuREUk55Jnswa14zP5R7uh0keNOupJTFbdeTyyDxPW50iNBCfT
X-Gm-Gg: ASbGncvMZBVkDTCtyRCdo4r+nvCF+f2Vc9IevAW9+Wn6RCm9iVcGpIWo1KMgoJRiSgB
	iSMD6yz0LbnWPjHm+OBu7lkDsIkZlhyAZO5d5bqkiPk0uPWn2WQ1CB8tf336Jq0juIZ1/qxYYqz
	nkbSn9IlMsTmJ6qVAMm78UXHzPzZv8vnSIu95vW5RfPC1+KMOPAp7retzRGBu/yjnIT70gza/aK
	HJKcWWDP8/ct2RyyCocNPAFqyfUiUTBTqpeG0Nw2O83JfDW0xTqXKXIRmduk782DqIJOMS3jMoo
	c+AGR0AlidXRDe5C2wj/sxEclZch8x0a3IBWabIxjl3y/QBwPh8+qNQgS0m46ZDf/2CKN/JFSyN
	BZOXLNaD1nSwmBeaxV7anBbw286lNKiGWmlbXLTxIm5GYfuC1egQFM1cVKKWN6Fmuk3M9MFNkE2
	R722kzAjI8jT2VCUoXPWvcOSeFuts=
X-Received: by 2002:a05:600c:294b:b0:46f:b42e:e363 with SMTP id 5b1f17b1804b1-47109b5f8f4mr47517135e9.20.1760721030368;
        Fri, 17 Oct 2025 10:10:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvb0y9fCRtWnytuEMED2PPHaBvVSeuDvOip/abNeYWVJN8mhS8t8p9uAnDfOHyvUkNRDsLQw==
X-Received: by 2002:a05:600c:294b:b0:46f:b42e:e363 with SMTP id 5b1f17b1804b1-47109b5f8f4mr47516765e9.20.1760721029880;
        Fri, 17 Oct 2025 10:10:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715520dd65sm3981765e9.15.2025.10.17.10.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 10:10:29 -0700 (PDT)
Message-ID: <d1a6c65c-6518-4227-8ec3-f2af4f7724ad@redhat.com>
Date: Fri, 17 Oct 2025 19:10:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: Baolu Lu <baolu.lu@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
 syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 dave.hansen@linux.intel.com, iommu@lists.linux.dev, jannh@google.com,
 jean-philippe@linaro.org, jgg@nvidia.com, joro@8bytes.org,
 kevin.tian@intel.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org,
 mhocko@kernel.org, mingo@redhat.com, peterz@infradead.org,
 robin.murphy@arm.com, rppt@kernel.org, security@kernel.org,
 stable@vger.kernel.org, tglx@linutronix.de, urezki@gmail.com,
 vasant.hegde@amd.com, vbabka@suse.cz, will@kernel.org, willy@infradead.org,
 x86@kernel.org, yi1.lai@intel.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68eeb99e.050a0220.91a22.0220.GAE@google.com>
 <89146527-3f41-4f1e-8511-0d06e169c09e@intel.com>
 <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r2BYNhbTjZL2AUWrVjoPETahMvOgVDAzEXZS0zPdfVY_1760721030
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: d8tizo6ro3eep4kan7ftoxyh1schnbxo
X-Rspam-User: 
X-Rspamd-Queue-Id: AF64412000F
X-HE-Tag: 1760721033-950137
X-HE-Meta: U2FsdGVkX19YRrUBxMhkMNOApHcKCNiA2YLRMv5XtJtUv1Xj+UyHll1Sx08PPAAy/EP/MwUpWCpTEbQjwppzUdVRVL+zYjYpEOgeY7+cDr8Ssk4hYqZa+IQLYJmYD4oQH+e74+pQL0Ty3xuYBojpdjTPFxcGQMjcVvQUGchM9q/8hpZKyEkutWAkrbadNFkg3UbVjyMDQaPdbh3NiAtjn9Ng1RvS2upuOjkmCdrC4EioiDEx6YKWAplIlWoICDj2cywlywcEV/uzl5EqLhSdtb+eLJ3A6AI8iH5icPdVeiCj2Xu3P31qTCkLm5tsi7shvoiw7Ju4cshHtsQRqc7sNbaNMJbZgWUTtOjELhyQDzEwm9uvfkEGPKmnsbdjoysIBuKEMC+3ZyTMlvtDnlXWiQ+0z1kgnQtBAy0xy9Ls1xfGBGM5b3tZ/LKlJZb0cZ6HbrEcVTSIyI4nIovKyX/fx13V/w4bapSUx6QJbDpY4Zt46V+xQS24JewHYf/Wg0rP0TMuZZ0iYtBO4A2jaaQ9Zn8mTAn6U0O/16Kf4xmWImHeJ4nUpxpMVsfkXwtRWL/ciO+H4uHKVufllkfFbSkY3LVjVMPX5oHqiwViGAGdrdDpe83yqN15nt6Nlfc/7lhDqzB4MBlJOc6A2wmpu7hGfTV1fuZCkJoAFCazHFALH3wHD/uh71sw/8L/UVeenE0UGwFrMA7X9LdIpk8pFCJeqhOheNngfq4GVhfmKTi//KSz6LjqDx/69b+CNFV9x+S+aN0X6OdOEvIiVZ5TXnBoNX7VOaSniOuCzfRJMrvEZGzFW38Slb7xJuSeUA/UFhf4wqh7A8Bpc0Dph6uLHhlY5BVcLLPMIubRyZ0O1SWR08mpB/9ofzYuOb6acDOOjtVHRWOvfFwznlEWSL0oI5oYV6woCOuqnDDmP+UXFsPzz4O5xzEwOXx0/tyQThHTZ2FXnd/ZuWPKAWJq97wPgKi
 qQPxJLIx
 K5qzDKWUZU/xSPXtpIUUGH5VlB/ww+Q8BsVcmA4r5FOJQjWMF//9N4elSjnz6/2EcBSxNd1AtmhzCIuMLyKiOPxb6EJFJYwnAHfqn3001uzW2SxcqwtN/b1lmcrqIt/1Ab0QWpbEi6WQ25epZdY945Ws++XIDTUu/LMBMFGACFWjgxotF+4A9WDm8X3LHw4tAW0zATDqK1esoCYEbWnTLogrwEkR0K6XSZ/dUAbvPaaDEvGp3VmVjlzCS3GKwq4jzpaDYnnEvyKZP+bA29UCuU4Qqh/czK2gy5VDCR7mSkCGMYv45drh1mDjWAB7IfS203HmJYwbQy94UGeYyZN5rshKxMb7YbleFpoC1FNIXBjp65HrF+hJCAWXnR0XQii0Lk9FQIdcXpIvb3JcIiEl2kQgwJS/I2mai4cD5vKkP/gozi66rI/+pZtuHoa2ZN4X9VXdM9PzrtrYJ7QLXkWAJxpGQypBRaIw+yQxcLJ+JQWv7FygMzjrlFhY0meoam6stu0TYsqLAVEbF7bJ7OnfSQ9Vx2WFPOJKC1rukYudsj9s9NaEYu1RYAZulXR6Blc3M6+xTIS3muJ0i/977/ZQPE9QfO6pgEaG/ASCr2IT8CS9wghI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 10:00, Baolu Lu wrote:
> On 10/16/25 00:25, Dave Hansen wrote:
>> Here's the part that confuses me:
>>
>> On 10/14/25 13:59, syzbot ci wrote:
>>> page last free pid 5965 tgid 5964 stack trace:
>>>    reset_page_owner include/linux/page_owner.h:25 [inline]
>>>    free_pages_prepare mm/page_alloc.c:1394 [inline]
>>>    __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
>>>    pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
>>>    vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
>> ...
>>
>> So, vmap_try_huge_pmd() did a pmd_free_pte_page(). Yet, somehow, the PMD
>> stuck around so that it *could* be used after being freed. It _looks_
>> like pmd_free_pte_page() freed the page, returned 0, and made
>> vmap_try_huge_pmd() return early, skipping the pmd pmd_set_huge().
>>
>> But I don't know how that could possibly happen.
> 
> The reported issue is only related to this patch:
> 
> - [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
> 
> It appears that the pmd_ptdesc() helper can't be used directly here in
> this patch. pmd_ptdesc() retrieves the page table page that the PMD
> entry resides in:
> 
> static inline struct page *pmd_pgtable_page(pmd_t *pmd)
> {
>           unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
>           return virt_to_page((void *)((unsigned long) pmd & mask));
> }
> 
> static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
> {
>           return page_ptdesc(pmd_pgtable_page(pmd));
> }
> 
> while, in this patch, we need the page descriptor that a pmd entry
> points to.

Ah. But that's just pointing at a leaf page table, right?

-- 
Cheers

David / dhildenb


