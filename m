Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E163CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0800F8E0014; Tue, 23 Sep 2025 04:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058928E0001; Tue, 23 Sep 2025 04:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAFCD8E0014; Tue, 23 Sep 2025 04:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC5DA8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:13:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67A221603B6
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:04:36 +0000 (UTC)
X-FDA: 83919778152.26.507E8A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 013E11A0007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:04:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cngXkU/t";
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758614674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Askvh1O4f5Tsh0uDpTj1jyMFwNHEO9gAWdh5DB6xzag=;
	b=Xjcufed7ytPQOwhS4CE8EhB6iXM2hkkwCRJlhflt2I8WC/bELhKmVMEusGhnoylBp+Tjns
	0XTEUtYbJlUQ48O4lEujcs4qYuUG24sqng8OjlX/SnMGcuiScYVk+iQ+4ANGbuztVz85j8
	TaizecOKWFLrrktCVD5ADcljVo09zl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758614674; a=rsa-sha256;
	cv=none;
	b=nPmuwM3PeSLTC1C6CnNhlf2dTU1FU64dIgVvNJtNDF8dcCda1ZXkQcmohpRuIIQRRcQoHI
	cMEJ66ZSTl/SYhn8FlzidX0e5MUkkmt6oBZUtKApUMtcVqa6NPqdfdEicDvfGjD1JDLhdZ
	kfcbjj4Ypzu2OqzbPdXBihlQO8k5Q6k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cngXkU/t";
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758614673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Askvh1O4f5Tsh0uDpTj1jyMFwNHEO9gAWdh5DB6xzag=;
	b=cngXkU/totYZ+UBHRSs2rYJ6g4Q8Znt1IzhKmUUQI0QlRRbWXL+E5A5Nqq2UjTORiKuGgn
	wLsxjuSpwltoVRUrVm03rBzct2uILDnmqtdpe9by8Zv2Oy3SF6nDt1kcbFTQHa83luR7ab
	/JZVQM4cc8SuQ1yt3peAs3Gexq9DVb8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-KbxGo-sqMQ-9m4MxvbVRig-1; Tue, 23 Sep 2025 04:04:31 -0400
X-MC-Unique: KbxGo-sqMQ-9m4MxvbVRig-1
X-Mimecast-MFC-AGG-ID: KbxGo-sqMQ-9m4MxvbVRig_1758614671
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3efe4fcc9ccso2369298f8f.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758614670; x=1759219470;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Askvh1O4f5Tsh0uDpTj1jyMFwNHEO9gAWdh5DB6xzag=;
        b=u9PicEIC4Vav2dc5hOLiiqqb/CSUVp9HFsiGbZ3ZNcQrsV7iiqka/WlY/ZDu1VUM5N
         3iSxqtiJWGj9cH5rJSNHg/rpUAa9WhOu8Na/xO8HZ1s20SQXkpR2q4pNYUy1lDILW4xY
         SBA+P9lay0uaizzlI6m9nReovI1F7vZXJ6QMnozeJux1lQm7VqdOnU3QjcnhAuJyiOwV
         +aJ7zOWuMV9qEhjGOfqsMVANi2kbRZL5hDK5GiAscGQz1XP+4Lvla2AzK8CxFwnE0hd5
         QR44CiW3h2WW2cc23f39lGtjpdXIuYUzBSiAvJOP16UjogrAdtqZeDv+Trkw1XDncW8l
         sreg==
X-Forwarded-Encrypted: i=1; AJvYcCW79ijPv6F1EmAD5/9HRm+Fz71y9vRsUfn/FXnDi7iA/QktcNkINy+FULnWUqqo2qrrXeWNrj+8jQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/iPXK6X2gWBtygBfcR9S0tBVlsA7mpEhUqC1irwdxuAe0HYUI
	RzHXXhi7Z9V9Qpy1m1yYurESvauFFKJqRhBhtPVzZTC8uDa/g8jXlTgcKxP0Oqx7l8YvPkwsbTJ
	S3Lt8a+C+zE8z1WKtmwDwmv4XozL3sNAlsLeh7hmrj25S/T72rCs1
X-Gm-Gg: ASbGncvTdcsaK0SQO4wkE3/3WVCTB8xeMqVf6u+ewa3SSS7YJaw8rqJ8F2YmkUz75Po
	Rt+B8EzBIU1VwvklK07D0qQcW/abQb+7k0VcmJxTCMbmVFweyMbnOZZpLJ3QAW8il0eLjttEBTS
	8TcOOUxuzApwnCoehl9WfvaS3v4vm5zx6Gn8zyQjQsK8I4JtdKbQoAdGHQzWvbgqD0yRtHILwpZ
	hRNPSMgDrWHgZx1424LhSu3LaNcRAm+MfVFIYDMAiDBFkTPDkJHCp5zB8MT9O/1Sab96IDwpLAU
	w5bYYWoJbmLJAQIDWE56y76edrmq9CWjxhh/goYP2gTyhI4gopxeZZRGR5FHuaqMLWnw7/0=
X-Received: by 2002:a05:6000:2884:b0:3ee:15c6:9a60 with SMTP id ffacd0b85a97d-405c33a33f0mr1178443f8f.6.1758614670613;
        Tue, 23 Sep 2025 01:04:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpbmQG7jPygNYBQKqBxj357VhjdBy0/gBciPcLrIjmdT2uOD24mbn8y6yk8XI+xazCBSzTWg==
X-Received: by 2002:a05:6000:2884:b0:3ee:15c6:9a60 with SMTP id ffacd0b85a97d-405c33a33f0mr1178400f8f.6.1758614670123;
        Tue, 23 Sep 2025 01:04:30 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fd57.dip0.t-ipconnect.de. [79.241.253.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbd63a2sm22761239f8f.48.2025.09.23.01.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:04:29 -0700 (PDT)
Message-ID: <5ec85b0b-9848-4cee-98f4-37953d504773@redhat.com>
Date: Tue, 23 Sep 2025 10:04:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/16] mm: define clear_pages(), clear_user_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-11-ankur.a.arora@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250917152418.4077386-11-ankur.a.arora@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lz42KaSiQMjtl4G6BV3Fk89Da8zuTIKLys1GVxJHCME_1758614671
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c4uki535toxzwe4qj8s6gq1z7x68o87t
X-Rspam-User: 
X-Rspamd-Queue-Id: 013E11A0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1758614673-918808
X-HE-Meta: U2FsdGVkX1/4pKyc99/bbtjXHt2+G6nRTvHJ7yPFiOdZf2/mwKNDWhV70OFMKIAp7lt7CyrzcD76/jJNoEZQTb+iUdFb7KJowd7kuUeuzP684ucTJJml+JCOOXPJ+Cjeo98CzL59Obg5oi9/dyGhCs7y9I3Xo8BymjmO7Ss/P/UGht3bF0LJ4GiE7FuF2YUhcX6UbPNwLPv8PiYQ7tKbd2uuhpsNf9G1cA8skpqLY7n41LOp8S0P+bNwV3qQrOW3WniPKng3WD2atFTwmV3V19PAwcaQLCBWsZ5vHkkf+QygfB09EvYR+Lj1B2BkGY2RTs2yoi6r6i8Ptx8V69qq1NtfuZyla+CZw9CvG8TJ3HELpumwob7Dw/ZupjGLIIV4IAAeyMtihdSk0/JwWOIk0UUCdGleOG7qmb9n7dAuesDAQBxXg+WzdtAEKMD6W2V2+RrvJwp4KdDUZR7ug6BcE+DgKFsOkOcUmzgCb2bNYMdmfFtCSAENw+Z8jiG7yePKzmPDYjuWoYcERE5mdEjG2yQY9bBefiFWOLZiUFKwjhQQ95wbeSS/3jjAfHehgCcWL6s+RsDuPdRUgyb6e+A/VCMCLEDMsd1gKWCkxwwaCbCukJ0BV062WlFazHcfxJeWoiQdpn/ukZxEH01qOzkLr4NufEO3k20YWN4suCul1aTR83ZKmVm15RzEYQD9cgyq8/vnQ6R/DFKtlJ4AKMViSGivnDeMb95rh0TfkTNLh0VGfZkYEkogfd8/fG5AavoTYB7JFkBruf0eKJ+vTzh/h6nNrCJlRPt8oTpBVbCXnKa/+6jvSL+2UMTJnUhcs43eUESXob4ahU7ZdNVQDAtrvhQNthV8qDGt9G1w8elwyUyJ8iXJD3pm0jlvcyqLmv5s0XEdMks46yxRwT1M8I1kw8ARf0cXrL7YKcwtFX4Bq9MhOmWzR80jYw/IOgE50X+yGrh3z017ENgPCXT0kBH
 L90fbUuh
 FGsIAut71WGsCh4Zt6ZFoCizL6ZMwTIsHukqfVJRcNEGDAAtUX6fl0VISqHdYXVvBEmV8l1VsLXlnDYGQ82NxOTwt9Mw1TibsXXaDbZ+4Ok3JzXHaOjU8CZwZ5yIfB/YUNnFAvuiMniftkwCxxNMk3eGQ8zdIvk1zSqlKGk6fQq+Axk+Wc4Az30/JThcgSirRBsTADIbnVqG0zg8NHtm0HHTIQBqestLqJKzh8YGNd1/9J7FuJsx4fWuzPEDqSC9eh5BsHNXOW4tP+RfvO0CkZ5+M5XRJJD5IbEnAD78byxX8slzNXcrM2wu56IHcDpUqrgOY4Pcpnqkd69zY2ypGNAGKlW4Q10kVoJNPXdjsi2j7z+KZXWOjf6JSfWQlIV/RI7wtSYMWKOgAU74g9svTe0Z80W3J3I+B4oVwZTeTT7Fqbe2uUkxZtDJ3/Ycno+a3crOWubWDY3P4K7bAJ3+BzBvYcuS9zJdj/iC9VTnxuN7pIGs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 17:24, Ankur Arora wrote:
> Define fallback versions of clear_pages(), clear_user_pages().
> 
> In absence of architectural primitives, we just clear pages
> sequentially.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>   include/linux/mm.h | 38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..0cde9b01da5e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3768,6 +3768,44 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   				unsigned int order) {}
>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>   
> +#ifndef clear_pages
> +/**
> + * clear_pages() - clear a page range using a kernel virtual address.

I'd just call this "clear a page range for kernel-internal use"

> + * @addr: start address
> + * @npages: number of pages
> + *
> + * Assumes that (@addr, +@npages) references a kernel region.

And say here simply that "Use clear_user_pages() instead for clearing a 
page range to be mapped to user space".

> + * Does absolutely no exception handling.
> + */
> +static inline void clear_pages(void *addr, unsigned int npages)
> +{
> +	do {
> +		clear_page(addr);
> +		addr += PAGE_SIZE;
> +	} while (--npages);
> +}
> +#endif
> +
> +#ifndef clear_user_pages
> +/**
> + * clear_user_pages() - clear a page range mapped by the user.

I'd call this then "clear a page range to be mapped to user space"

Because it's usually called before we actually map it and it will 
properly flush the dcache if required.

> + * @addr: kernel mapped address

"start address"

> + * @vaddr: user mapped address

"start address of the user mapping" ?

> + * @pg: start page

Please just call it "page". I know, clear_user_page() has this weird 
page vs. pg thingy, but let's do it better here.

> + * @npages: number of pages
> + *
> + * Assumes that the region (@addr, +@npages) has been validated
> + * already so this does no exception handling.
> + */
> +#define clear_user_pages(addr, vaddr, pg, npages)	\
> +do {							\
> +	clear_user_page(addr, vaddr, pg);		\
> +	addr += PAGE_SIZE;				\
> +	vaddr += PAGE_SIZE;				\
> +	pg++;						\
> +} while (--npages)
> +#endif

Should indent with one tab. Any reason this is not a static inline 
function?

-- 
Cheers

David / dhildenb


