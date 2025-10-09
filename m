Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBA2CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566D98E00AC; Thu,  9 Oct 2025 15:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517468E0002; Thu,  9 Oct 2025 15:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF458E00AC; Thu,  9 Oct 2025 15:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29A518E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:26:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECC62140B1E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:26:30 +0000 (UTC)
X-FDA: 83979557340.22.C7D4BD8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8D17410000E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:26:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oxat8xjQ;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760037988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2B8vT5pvQD+mfwnpX1+1iKZS8FrGv7Z2N6yCTBVfn4=;
	b=fkKWjvPJah0qdupMOHqGNZVtiMue2qEfcTC8zZr3nKLjK8uPV0I2OTDOsixA8ZsCIsVfbh
	uPAoky0uoTYSeiFHy31hMJzK5jhjCxFXF11RVxqLRsMcPx70+/b4wH1gkCsuaoQFr9QwUj
	hampKYnomx6T5qKPAyBr64KM08TVxls=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oxat8xjQ;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760037988; a=rsa-sha256;
	cv=none;
	b=UIMYhrYLpuppcxSzoW8Fvxf4YnPXZSA8mDxdyusOVx77Bl7Om3X0r3Va2VVOCKVmGVIy3l
	jKfMycwjpQH40EoUUOxWOYiXU6Bd3r4rhs3pK5Fbg5yiuqadl9QvxAIEzyAIVKYIQFpm6d
	EttfFbs4xBZnJLjRg9nTAmLR8ohSkXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760037987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W2B8vT5pvQD+mfwnpX1+1iKZS8FrGv7Z2N6yCTBVfn4=;
	b=Oxat8xjQWOBkPZTCDSqayp4Kw5cjtcY702+BZnDgW4u2KwNJg+0j94Nzx0FGo62o9gP3af
	Rfwv7v18IOuZJGN0JzFGF7TQIjgZnWJ/Set471WZxapqJWUJwLcXUtMpulxa/czzyf9tCR
	f9twIRgKXG0VZBrWypqN+yK6O1ssqKI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-0YTJ--OOOZqtJApNApdsFA-1; Thu, 09 Oct 2025 15:26:26 -0400
X-MC-Unique: 0YTJ--OOOZqtJApNApdsFA-1
X-Mimecast-MFC-AGG-ID: 0YTJ--OOOZqtJApNApdsFA_1760037985
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdc9dbc5fso883505f8f.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760037985; x=1760642785;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W2B8vT5pvQD+mfwnpX1+1iKZS8FrGv7Z2N6yCTBVfn4=;
        b=bQpUaFloRL8VEdJXTsXMCYhtHKIHTpqEDkfZsOAhm6B5V3pHzZZsKJ40HdzJL71drZ
         LvutusjHDItPzZRV8HmEA1giiXEKcUoBCLB09xE5sSv9Jqlg+oyju8cJfGnuZgzHKeYq
         T95QNCJxZmYlNcJgnu8aY/sEWzYQqySw7y8gWE9VHefPXQ8IFAtzDJ70aOKhgcoiTiuG
         O+N7MjgdnZ2ZXyv3WbrHQ2rFlVxkdc7MsgEtcO/GJ1JtyWmCWMUvQIEepDoNcoKS+9sJ
         6Bahz8x18aWPAQim20e21wThm6FWwCPEnIlkldqg1tKxOtvrEPsCiUu8gRooddf+Y7aX
         zPPw==
X-Forwarded-Encrypted: i=1; AJvYcCV6hxibj+TR/f5wfbQ5sbkEilkn/pwXfCFXNzO/eUx7vDCwkZcDiHXbHdXwksVSI6oLnKjqrTH/8Q==@kvack.org
X-Gm-Message-State: AOJu0YzTB7pdxpuoviysjcx6HIbY7Rh3Yto9DJie3zn4oDvn7U5biShK
	pl7TMmcrHFZ7zjXkFwM6t6h6Rb5fjwnA4syJKakZxraQpBbJyHqpuSjzRl6au1b35G5x0KEdhOD
	5cUeV3blP/uyq06/XWvygZalD5f6E/oVnyrf7HfFRlx+M/ux6+I0H
X-Gm-Gg: ASbGncsGuFZ1A5mYSN+rGqbkDnBOf1TEptHHm+Gogs/RJ3+MpTN1nSE9EejA4PSOuqw
	jmLjMbfByCCxiyUJlDjYYbisWTb1ljcbp0ozQJK+ayxUcHqmYeOm9vdLC0nRSZcjBpMC3SB8l4v
	ToqOi+FyRGSttkOndao1/rG9Amewc8T4AYwHZgnj6bzkOP7VsVUYmIFXk0ucZLUfkwShl5zR2KD
	nGKMD+6ibeAJ8FYkWxP8ZpdbB6KjjR3Enp45fsVSIrAX0hyspW/spwh4yT/UljEO8zjOHJGpxMl
	fqD+fVmzOndEE3Inf0MZMLrzyolvGy4BrIBpcvOBSqO+Q9i/8nr78MfmqloxSC+A1X59f9zPegR
	VN2ZTi+Kg
X-Received: by 2002:a05:6000:1861:b0:3e7:4fda:fe0c with SMTP id ffacd0b85a97d-42666da6dd4mr5743426f8f.15.1760037985156;
        Thu, 09 Oct 2025 12:26:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHr53Oq5rgi0BWcMZ9Fm+pXJK59Y4s0sHr9nDLiWoMs2OEe75OxVzju/Ffcx6q/sukO2F7BzA==
X-Received: by 2002:a05:6000:1861:b0:3e7:4fda:fe0c with SMTP id ffacd0b85a97d-42666da6dd4mr5743402f8f.15.1760037984752;
        Thu, 09 Oct 2025 12:26:24 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5d0061sm434778f8f.30.2025.10.09.12.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 12:26:24 -0700 (PDT)
Message-ID: <646c392c-0a3d-46f6-9d81-c007d6a736da@redhat.com>
Date: Thu, 9 Oct 2025 21:26:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/8] mm: Introduce pure page table freeing function
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-5-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250919054007.472493-5-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fZ8kGAw9iC-Rz71DJXw9auwk4tJ1kqp6H1ntUw4mhOA_1760037985
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zopfirzfysyu78syhsfue357e4koxo1q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D17410000E
X-HE-Tag: 1760037988-100951
X-HE-Meta: U2FsdGVkX19PRXpsjlQ8gOyazbjE/HhYsgwEWsNRCMft/QMuHLN5jeBoT1hOQUytW8Oi4oGl1jdUnQd/P0se7aRYrO5BedCK17n1HGHLZvUHa/hUk7OCp8DQfqNRuJ/yRHrqoxX2b/5AFdX55cUkYjeKt4fPr66PIXll+CXQB/36bfMGqp5xLP80HjfabZ0bE8PVRm8ME0+6WhFKv4yaTd7pdIUwGn6kCtey7/eWJKhwIVgTwV0VL9sJoaJS0/STFSYVRYU8h3gsL6zpMDbnUH7rXsvmuhkjzYXiMww84eqQZDJaPV9IOJsC+es1xDHdGeRNsu5bXUSPk1w/q1Rff/bRIhoHDr+7vT508c+kBLMkrb+3GJ0YBFdo5BT0jAqmsS0KEF1SE4brDReeTqxJuiVhZticGM+P+nNid1VKByMARd/SM482uT1HMMSfJRS9XIpxyEx8rwgwYL62cq7jSyHrkWLKG5yJ/CJNv/SjRfbj+vMGwC2FhvzQQ+BSCX5Mmbo/7RD8p54+8mFkRmJtC0CqmncF0ydj/iWwux4jnETMr7+jyXvHS9IhrLJ4GbyUKDxQSMJxNgGQO4b8TTA8rNHN+iG58wY6598mGfupAvZA0yGf14w+z617fHFwJgMh6GKYlkduZI6+NGCBwBY2DoZ3TOwz05h5BYEpgzFTtnPr+JFtLx8c4gKSvws9hP5WkZiM6NKpnHB1hjUi6OVvr3qANCkWfnU0g5gdzS8HMybPZ8TIlfYnrq63WJgk0LCpPd+Q4SkROPDtL4o6uvXNjRu5xhoLCklapmxkaIyhAFp8SDcfSaUjsP0aNBE2uJIopEqkuFEgrwraUW2R9p1i9HpTCtTYtQsqo9wrVCm96/bV3y9kfzYB7FgBstVQ2NF4Je6sJ0ZzISWIS78UmfgVxPNFvkY3QozDab8WRjODPDj64J4LvQsbmD7R059zFzQQJVatBfRB8EUkCZP7e0a
 2RQkVAXo
 v/v6mKhG5BgNacaLcixZMzjg2+/H3pGK4NOpuwlZmNlPnL4lACMyqnR/dy3xHIhfTnzDdnRHM3+lyG36T4Ho/Gu+2xinvGNqCsiJe+5Td5wmFxAhBZrnxVF1S2hND3tqdrfaZX5sodJaktdsB7/V8SJFz3MnwSm1jORy/3/o27bFIBnFYBNHjznV8wtYq3Ryf4XIBggktKZbxhQi9Hf5IZ1POzMKcsU80emZSI71149SXq6q7NLRNR5g3hZ4OMNuvZJf9X/ZWxB1rwL+7RbESpilLFBcDTEUQLPmF1aoMtuH9iUtY8oUMZde5RvEfgAIJ22dNmYQjKIXWnh918ynEKc+rav/H3C7KkJh91Z8TAOZ39A4v2jdAkeUSH3Cmb7IToYVxZekIzGkGpdFS4R57KrFOfN9FEftwPyKYtqD/x1rBJ6jyhSuDqEQmisIMCVy39KGQtN5/YLQ8BlBFfvesz0uXBPQjtC/Q7+T1z06yVp6D3Hx/bw7vE5MPupMj6AfJP/6e+ljYq0b1Qvj0CDSNH4xZn7v4Op8xmFocpag158s2DLd14PETvSV1cAmgrL+QJzOxbVwxEmQNKYk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 07:40, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The pages used for ptdescs are currently freed back to the allocator
> in a single location. They will shortly be freed from a second
> location.
> 
> Create a simple helper that just frees them back to the allocator.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   include/linux/mm.h | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f3db3a5ebefe..668d519edc0f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2884,6 +2884,13 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
>   }
>   #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
>   
> +static inline void __pagetable_free(struct ptdesc *pt)
> +{
> +	struct page *page = ptdesc_page(pt);
> +
> +	__free_pages(page, compound_order(page));
> +}
> +
>   /**
>    * pagetable_free - Free pagetables
>    * @pt:	The page table descriptor
> @@ -2893,12 +2900,10 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
>    */
>   static inline void pagetable_free(struct ptdesc *pt)
>   {
> -	struct page *page = ptdesc_page(pt);
> -
>   	if (ptdesc_test_kernel(pt))
>   		ptdesc_clear_kernel(pt);
>   
> -	__free_pages(page, compound_order(page));
> +	__pagetable_free(pt);
>   }
>   
>   #if defined(CONFIG_SPLIT_PTE_PTLOCKS)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


