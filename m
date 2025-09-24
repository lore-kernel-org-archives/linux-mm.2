Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4132DCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922AF8E000E; Wed, 24 Sep 2025 05:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA0B8E0001; Wed, 24 Sep 2025 05:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FF58E000E; Wed, 24 Sep 2025 05:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E20F8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:51:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33E5E13BAEF
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:51:08 +0000 (UTC)
X-FDA: 83923675416.19.ECC75E5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD9C51C0004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:51:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aMUwiYSa;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758707465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQMBR3G5+Db1duFANu1LlfQUqIsF8KEE1eC0NYFF1Ho=;
	b=DhPA9vqsxsjBKkC0VzDD6pxpyGlRSwdX60jwOVEgxLtHSahf9PxVHMRPWKubKjhbJfN52l
	8WmWrgYkPrp2hyKnxO9KK6HcKOHPzsKa5j77TDPLKfmSRhSv5FdtjkQQoCixZFKsRZY+gU
	VPCHw3K/AmRoSvTpo/Kp/K2TisFs5Yo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aMUwiYSa;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758707465; a=rsa-sha256;
	cv=none;
	b=OHIxxSuIKU3Ufa4BsWNc/Ni9Vhrahp/EPmoLtkJnHjQ8Ih3K3CzcNaUGydDEUEo0MACTIb
	OYTu8MOA0v3nJSmMJIyBWsflrrVjH8ODuxJO42M8SbqVW7VhRfW+p8uJrOwV/xI/Lbrfc8
	gO5yaPUCpYFYAmxSoMUUCRpjGj7RK8M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758707465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wQMBR3G5+Db1duFANu1LlfQUqIsF8KEE1eC0NYFF1Ho=;
	b=aMUwiYSaLjucRqcwtkLewkXxjai1Y1mOufpmPFJKlevCf2hN1c5oFQlWuERW5N8VGQSSFf
	uC3bY+Iy5aLWFuAyC+uxy1qldX0te7XFR+lF+0KepWFBms8VCq+O4wDteFQrZ1LUyQThah
	ySqEAie+rA3t5/NTmSwnlmXIVwIxjZA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-aosISUb9N2aYikmp9u7HSA-1; Wed, 24 Sep 2025 05:51:03 -0400
X-MC-Unique: aosISUb9N2aYikmp9u7HSA-1
X-Mimecast-MFC-AGG-ID: aosISUb9N2aYikmp9u7HSA_1758707462
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdd80ea44so521500f8f.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758707462; x=1759312262;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wQMBR3G5+Db1duFANu1LlfQUqIsF8KEE1eC0NYFF1Ho=;
        b=VOmJjYVefNAj3KpnSWiEr4T+yeAbG/78XswC5Qqfo2DHmULqL7VJFzw1kWz8It0UcZ
         cTtfz0ytZ8+fA6TK8M+KVlf9NUR6BPVG7Qx4Euh/evvmQb042t0GlV0kSU7Ku2JDjjpY
         Sh03HjlH6pkY16zpWowfyBIdhkXn3PEAhbgVWCX39sdX5EJ1vGadyHfxJbdW/lU8sEQ0
         LZthmA62fXlceb6ZDUklsfj7nCmeSPr+SjGA8qN7yznWhyCh+p/eSSlFbn/yyDXhRo7O
         TSSs+nK4XRWPOHkk/OoLovcmgiVjb5fmOF08tYC/j1UfiIzb6E/FjYd/GvNmNWhOBJk3
         s9NQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMsNJGhTopP3NX8YJj4YqkOm/OHlx/KjwMrJFwE+rX4BOa2VASzf48BEYy7bT2mu3sUD03KvI49g==@kvack.org
X-Gm-Message-State: AOJu0YwqxbW16uELZyv1FLBPXhpeduscS9PxLfvjgHtUevNE8Cvu8rch
	wbFaAlDPAmqLNpJUV6+W0lMSlETXlanNRHLFJsESi071SBlXN9n38onjcAkVjKmeZhd2dvH3/M7
	p5+yhi7UW1vdUmlve4WMdn3sqT4x4HMsYs53BJBDJBkbzcEPHzt1x
X-Gm-Gg: ASbGnctowWyacBDr/GdCWfSbTY0/ElYH4Q4OBxN+95B713CHSeVhRZByZVzLf2qKoLl
	2UmTbdgi9Jb+dfpBsJDdtD5i2ZUgU/BfLIcXDYhM7GQPWyyE2CAjbS3SqWEyNi+N9SderuKLK74
	htWOdkIRJKnJnBLBjs6+jvq/MaW1l7fs5nzjwz1pZnSUg0F28AtJLLPl41Wqp7iVtif5SWlmoRz
	tQ9zxkuXPDc5cPYJkurY+03HRksDykY5WkjWgFqm9JwGYXYFZV6lSqHUGcY8L/TXdLRoma+CSUI
	uphaLDAzR6HyQLLbLXLEYv6Z7TPUjoQNTgd79YPWUn6aIau4H7b9BLja/xNeCRB+mB1ay4iyelU
	8t8Q6tqv6IIlhWfKLuA6iZxXHj0W0wKHulmpSlZeFFhwsIcpGvxc+hRxntZ7OoR0ptA==
X-Received: by 2002:a05:6000:250e:b0:407:d776:4434 with SMTP id ffacd0b85a97d-40ad3e31090mr1902991f8f.30.1758707461968;
        Wed, 24 Sep 2025 02:51:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhPPRuD29fp3XB+dlfoXl2496knpnZNpdUhlWL76OfhvP5Pe0dNCs5vxe+nKDXGGk5bWGRAQ==
X-Received: by 2002:a05:6000:250e:b0:407:d776:4434 with SMTP id ffacd0b85a97d-40ad3e31090mr1902931f8f.30.1758707461451;
        Wed, 24 Sep 2025 02:51:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a998314sm29241655e9.3.2025.09.24.02.50.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 02:51:00 -0700 (PDT)
Message-ID: <f8571506-30c0-4dc8-9995-41a6469f8fc7@redhat.com>
Date: Wed, 24 Sep 2025 11:50:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] mm: add PMD-level huge page support for
 remap_pfn_range()
To: Yin Tirui <yintirui@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, anshuman.khandual@arm.com,
 yangyicong@hisilicon.com, ardb@kernel.org, willy@infradead.org,
 apopple@nvidia.com, samuel.holland@sifive.com, luxu.kernel@bytedance.com,
 abrestic@rivosinc.com, yongxuan.wang@sifive.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org
Cc: wangkefeng.wang@huawei.com, chenjun102@huawei.com
References: <20250923133104.926672-1-yintirui@huawei.com>
 <20250923133104.926672-3-yintirui@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250923133104.926672-3-yintirui@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hAB5BZ9ci1yT15sdVgcpUwBcgF4GVn0iV__4sCZBkJc_1758707462
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BD9C51C0004
X-Rspamd-Server: rspam05
X-Stat-Signature: 1g34n6gte7sd1ja55pef8fjgjprr8jhb
X-Rspam-User: 
X-HE-Tag: 1758707465-641434
X-HE-Meta: U2FsdGVkX1+AIUIHxTypsZJFDtTfzdXvaUWiwZVRqVDnhya12EFwwGgksDm9WLtdw6X9RqpVUM7SL+T5RRZXLVoQdmvS9LLxQb+s0yCKniH4jfyflKYZZVy+YytJIEvGc4ONtXW49FbHGxiRtnQ7u3dP1f2MLI+smASERkMqCi2XiXA7IlUNt7nA0jPr9EEKTzWefi3zlcjwx0BGIB6Kx40OcVL/SRqPFt6niD0X7whYSgfKGWfJg8Z5gWtnamRhiysy0q9YnzPrnwvFb/53wa/iauOy8l9YkEvtuAxGDQ2J5SYqSzRaMMwF7I8oU9yzOUFmi7i/EkfMIuNDoQwe9DiErco5DI/hfpqwAMw7/C0UISRBPBO2Ttu3wSgfbkn+3SQkneIACjS4vRyUy4PajpCIJmACkEvrgSLQcM0VI8fP0ycTkCYRUf8zKwBxG4jm1keAaIxI4rwqVaG5yuDX/Iz89ocNQWUnbTO+HURQ5FPIl/ZIQ1V7eiaZF4sVfiNnkTg5+5hoNuGHJEemFqP2phRYHK0d59O9Wyx5XF2jhF6NlausxhKwhfBuVQtR0Am7JP5/bf/5CPt/28wJYJG8DIQCiQ/OvIVg2HwF2rRnkHqMrwLTKLMTDp3fornBp6rsPTuykzo9x+oT0z1cXUQXxSYx46LyF1Dx24MzdrKa852RG1l7fT5aT5HME9mOzIKUcpTM6vJFwCZtg4AHAUH3GkiOu2RRGkyBF6AbrjR7LEk9+j4xR84QED9LKqPc+ZFhQYeAAOLmhJiBsPRlmuTKI4ngSAkgIBXOV1GOcp/nWr5W12sVwgpWY242ylLJXSQOIUaYAYQ0pjWy0CSsDlR+cU7h4gf8a/UIH1/Pjlt71xXVbCB8rRNLaAOlx6TInUfOUW0qXxUEhwm16D81n1l4FuaMtFEG6U2hCUaprNmmiZ4WCt7CtATi/QwEHb+x2jzhsmRSTpEU+SwDD6pEnya
 UQl1Q/Kn
 WJy8R1PP6Fa/Zbq1JR1mfT7acQwSi1Vok2CgB5eoPnpoevJQ1UZ+uQ11ryi9EAnG/RzKzF9sgLoWiZdhaPh0LVS6k0FvdGUANzHvGC1HWZ1IZDmQ27S+8SylzxlLyjnzNnbiQBEPcVPhwTzKTmqwldKJ85cqV5illTRGhR0VclFYhWaHWt1JnU7bq32dBvvc79V1Mmd2XEG9I9UF1Yavp52/Ge1GnqXnKF9i49DFljPYfkFX3QMaQSW4nbM2Dchjz7PxPLbZEnyQW6Gw/Kx1u9hGSskReixSekf606c7TJDHi8Y7W9dxJEZB1v8DW7vKt3xCUJ4bkEoqDxsKSianBdJtRAe4BIJMVzbg6cxNFs1LZlY+5CPWVvGtiT+Zcs3do3zERJ+nKZ4vqA8O6DlCl3hywdESi++lwe4rwwow7E9vp4ZbzLvzxFW53cfeCNCoWGdceAZR/B1ZcgN1ROWlkH1tLpXRIm8bYkiL21n6ZJHJxm1A8H8PI8CmEtlaQoPxtCnJSpnj1qvHj/+2hJNlTifxWxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 15:31, Yin Tirui wrote:
> Add PMD-level huge page support to remap_pfn_range(), automatically
> creating huge mappings when prerequisites are satisfied (size, alignment,
> architecture support, etc.) and falling back to normal page mappings
> otherwise.
> 
> Implement special huge PMD splitting by utilizing the pgtable deposit/
> withdraw mechanism. When splitting is needed, the deposited pgtable is
> withdrawn and populated with individual PTEs created from the original
> huge mapping, using pte_clrhuge() to clear huge page attributes.
> 
> Update arch_needs_pgtable_deposit() to return true when PMD pfnmap
> support is enabled, ensuring proper pgtable management for huge
> pfnmap operations.
> 
> Introduce pfnmap_max_page_shift parameter to control maximum page
> size and "nohugepfnmap" boot option to disable huge pfnmap entirely.

Why? If an arch supports it we should just do it. Or what's the reason 
behind that?

> 
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---
>   include/linux/pgtable.h |  6 +++-
>   mm/huge_memory.c        | 22 ++++++++----
>   mm/memory.c             | 74 ++++++++++++++++++++++++++++++++++++-----
>   3 files changed, 85 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 4c035637eeb7..4028318552ca 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1025,7 +1025,11 @@ extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>   #endif
>   
>   #ifndef arch_needs_pgtable_deposit
> -#define arch_needs_pgtable_deposit() (false)
> +#define arch_needs_pgtable_deposit arch_needs_pgtable_deposit
> +static inline bool arch_needs_pgtable_deposit(void)
> +{
> +	return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
> +}
>   #endif
>   
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9c38a95e9f09..9f20adcbbb55 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2857,14 +2857,22 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   
>   	if (!vma_is_anonymous(vma)) {
>   		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
> -		/*
> -		 * We are going to unmap this huge page. So
> -		 * just go ahead and zap it
> -		 */
> -		if (arch_needs_pgtable_deposit())
> -			zap_deposited_table(mm, pmd);

Are you sure we can just entirely remove this block for 
!vma_is_anonymous(vma)?

-- 
Cheers

David / dhildenb


