Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC2BBCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8A58E0024; Mon, 15 Sep 2025 09:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0198E000C; Mon, 15 Sep 2025 09:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF278E0024; Mon, 15 Sep 2025 09:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2DF8E000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:56:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFB6FC06A4
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:56:21 +0000 (UTC)
X-FDA: 83891634162.11.0B84314
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 965AF100012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:56:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aLkCQhhk;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhOG/fvp4vP62Eb6XPp5XNsran7BwQlb2XSK8gOzU1U=;
	b=NBzKphkgq/FtEfdCr3/raCRf4tfU0Vl6obmg0TyYTeNScRZ9l2ehkzhjyvcfGzr3FyAM7e
	zeaR7DpwXgLLnl4B5llrU2AxfdoYnagVmISwC7vAsoq4OI2d8/hVxL84tdEZKKS1ndSR6X
	qZEGCrqfR3G3dgilLxb4eMvRk8JCb8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944579; a=rsa-sha256;
	cv=none;
	b=SbP+WpcJ1NXoEoEaSsEVpZULYY9OKI4Y5jkPG75WMQ1x9dM3X+puJIvwENf4MKsSR18IWv
	sRblU72wl83KMc/bZY3p2SyMYqRVyWdtorSmkH81ISOkADk2pXJ7+V3nvNilIgaz/jFhke
	8J8VwpIVgoER3/y5wvVTnybIgqK0gVY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aLkCQhhk;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757944579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xhOG/fvp4vP62Eb6XPp5XNsran7BwQlb2XSK8gOzU1U=;
	b=aLkCQhhkguhckibGzIugPnFpq6lZfpU4M0OCITj402qRmZSvUUI+mKvULGh6kf2Nk/r4i1
	RU1ZZFPPbtyueE/+gfJokJIhC7LLwlgmq/kkDIzLjIkWH0GCQa93iJvXggvdKT0BiDGPIc
	A4SRTiE5M4tCLJS0w1ZdlirOYLC6LcE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-wE5P3os9MHqksnVh_sVlQQ-1; Mon, 15 Sep 2025 09:56:17 -0400
X-MC-Unique: wE5P3os9MHqksnVh_sVlQQ-1
X-Mimecast-MFC-AGG-ID: wE5P3os9MHqksnVh_sVlQQ_1757944576
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45f28552927so1762675e9.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757944576; x=1758549376;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhOG/fvp4vP62Eb6XPp5XNsran7BwQlb2XSK8gOzU1U=;
        b=QEPaWtu//ZE0WbP+mnGeMWXC9/qAv02R4fATUdbp9ykSqZvHodxv4UMegkBlmOH5lc
         Ty9daLsiss3J8rZ+GYq3FsZ3IxxL9pMtWgKdQt4iYcNw+25M+GlXuvO1tSoCKMDbOEBi
         nfEQEzRO/RkbHrSX3hobsV/5I7YV5pCwG5IzPQxj6+a2HVcWkAHD/UcLHq7yQFClt5RB
         MurrAwV7wN2pf4+87N5Qd8rytEgWp91d0L/DEHs98ZrX/jY17/yLMg8Dqdw7/uy/1c6C
         u02+9YM/QlCyhgB+/Bfd54fWBMfI22XrYjUcP+SkbN3DLro2BsgNjUr4EZ1CyFhKR/Jp
         +83w==
X-Forwarded-Encrypted: i=1; AJvYcCUrlX63x9zoO9uPjVh/t6mIgiKra5mRyD5oetgTtb8Y7c8CxECmawrO82TzEERfXQK19lDcCM9yZQ==@kvack.org
X-Gm-Message-State: AOJu0YxvW0iZQEyMgkxd/x+aGPomhWUiZXom4dNoCFp/wJ+C1oNQT0eY
	y49ZcLeZq5xp/cwV2milpwVWCnWpEew08s+fXRc88M81fb61uFEqcdqQaSd+bp6nuFLTmyvrwdN
	7IoNsRp8NhnNdZ7yS/6+q6D4N81KwEhgcOIcscl8p1BfWFKRmcVa5
X-Gm-Gg: ASbGncu7o3cP0KP0APOEmZ5fvGQnJK4iEkUExjOHWST0KaThXYCPCHcRsFobs9TaKuS
	PZxppacSrc6qXUoD06X/ZI6kQ3378G0Cv/lYLEqCOrqrOvt4tt20CfUSDNGzDXHJGJsFxCZ9GUV
	sFEAIeas6HBNiccqHrmUhcmV8ZOPj9Xs+QGd6p6cwMeQ7HjHH7GTiB69Qy2+iew+n07aG06Iddk
	aJZg5lKE6nN3x+3X52L6pqf1pHRgqGMf8/2tEhbkdhGNdwPs4dTxuuOXSEero7Fx/E9e3nm/dE9
	iZ4fqKdI5cbjEeyzYCFayiE7t4Ty9ksmnj4r5xWe755JhrTCfqSPAhB2z6E15XxrdETJxG4Pwoy
	pqlk/aFoK7A28eBpqPa6TK2OeBYbNXkQyeD43kOARuk413qx3qegm2vI5sSNey7Vv7LE=
X-Received: by 2002:a05:600c:6288:b0:45b:8adf:cf2b with SMTP id 5b1f17b1804b1-45f211f881dmr115966495e9.21.1757944576086;
        Mon, 15 Sep 2025 06:56:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtjLb9Ul6kS9hK8OGR9Dc+mdLSV5OClg6Pwy+q+DWumlQ5T+nt0OyxALBeSTSBr2gbzsMVcA==
X-Received: by 2002:a05:600c:6288:b0:45b:8adf:cf2b with SMTP id 5b1f17b1804b1-45f211f881dmr115965935e9.21.1757944575556;
        Mon, 15 Sep 2025 06:56:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e032a0522sm178750375e9.0.2025.09.15.06.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 06:56:15 -0700 (PDT)
Message-ID: <37c8dd09-e0b1-4f76-a03b-4548c1fe4796@redhat.com>
Date: Mon, 15 Sep 2025 15:56:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V12 2/5] mm: userfaultfd: Add pgtable_supports_uffd_wp()
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
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
 <20250915101343.1449546-3-zhangchunyan@iscas.ac.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915101343.1449546-3-zhangchunyan@iscas.ac.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ndJocnbdzK6Fpd51kvnQmOQhRDj0JOipeq2AwmtcEP0_1757944576
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zs3egtx8fz5atte9zxkf4xhh3tsn3no3
X-Rspamd-Queue-Id: 965AF100012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757944579-34573
X-HE-Meta: U2FsdGVkX19AJ0MaoWEKbPHMnvhpm63BHYVoKWvVmYa3GnEJ+KpmJ7J6dArDFG/r6yZeBOyyYeEyLBO5n0X8/ux5eabkd87ZN3e5glL/iQg/TYMmdE6vTmQGbARf2bjUt2IUOZJiTRln1XNkHKr7VsZYoSCNBCTP8O9+NIYG+9KRiSAtQnD0kSYuyGfI1HShrwQBfs3y+UPhEBiQcezf+sLVQEZCvWAGkgxdqpuuGzBSoDXZgD4wNj0gIwDBTFhefZPr9jf0xRHIV74KVnbNFTD2E41Lihv/IeLT8nAibX1GbdEzxyzBJV4kIqQac8UmAfHgp9GicgERqyKStpqZeZY5pzxOJFvQwDuE+LoaZUlbbinxL2TIWOpk9c7Pk3RkENyL8YYN/qJtwW2dQS+QYG/YaWvvXp+VJbT1yWCklOB6FauBo09Bqn0uz2RddBDkmUcJbiN1cKlw+CR+r6U75B0eR1H0XmpsAUR0xUBQXmlsJJ3jiv4q5L7nMBW68t/YseBTRzfEeu2LAtB7leawyYTtNsols+3yUtdkk2OQvmHrypPqmZko4NP69/ajo8JgwLa4pz7DdOTjGSVEkWHdnuElw+9/uHBSlhWprrcEsPoXe8li3v2v5VJMkenIjCvawXs0K4VsfW97KMi9K4WDyAYUa6x8sX7sMznyXsww8oayRwWNZWlAZq0rjoJCSQebpQFSsGAE2HRqHwPevnhXyZ2RNmUZko227rOqVE2/IkErqdvUHlhCleh/pE5amDVNCBvt00ooKmfJ+ttbEfZV2FhHOjIk2dYZ50306c7qbXJBGc2ufpUdCriddRXcsPcBqVzc7r3P2z3h/AAMUSSZc4zPMAEGHAaBrIDYgc55hg1hodxI+r7iWM3/ItHCQ3RObNNR7ZrjphyJcLdc3QtiNe03+I9Lvv7T9fYfsI3T9f2bFotvzvXDqcVxquoVbzEblVajwGCj3NgQ2JIaeUt
 FjjTLVcg
 7U9nzBq0hr/MP9vdXHg+hb/5s5+/k7nnjWbzUJ0WT3umZIxjnStxWLekpti+9QnI9RScTIt4uI5R5zwy/zJIJ5ZjeDKCcJLBbMP1lovCPfOKG9KybCyUNTep7eQ1ulX2e9t2Vgq4m2Awp/Mfa3nrZngA2IynyaR2diZ7SamrgG4q0xO3NDs2e74Mi5gWZe0crG8RMI18RlPJKYnL9ReuQQI6KY0x8sLPsQ9mzO/RikFFMFq/uLnWDRKeVadkPfIr9M4z9iFcjMg1bcNfmr7NLijna8JaKA1hNvjxVSfo/OzXlyfzcWdCULkPXBDX55JwZlshjw46vF2gy0+4pfxd/3sz+o2MYNXFMhVuNA1Nb3lZMXm5bjlR//XiJWV1T07CA1KSCDLiPq3dg9Dx17u8SIQFJpV4rUyG9ynP7Y8sgTOi91/qH4Xn30ZBoflMReqStZLy38DOQj1C9q20Aq9KLHQps+UO2k7u8EWyEYGtth1283ZVQ2aSTWhkEiOIXLn/ZRnubN5fjBaAYK+AzEbG8T5DNmbqN+uGxPAHV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 12:13, Chunyan Zhang wrote:
> Some platforms can customize the PTE/PMD entry uffd-wp bit making
> it unavailable even if the architecture provides the resource.
> This patch adds a macro API that allows architectures to define their
> specific implementations to check if the uffd-wp bit is available
> on which device the kernel is running.
> 

Similar to my reply to #1, you should probably summarize what you do 
regarding ifdef and "No functional change expected".

> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---

[...]

LGTM, one not below, thanks!

Acked-by: David Hildenbrand <david@redhat.com>

> +/*
> + * Some platforms can customize the uffd-wp bit, making it unavailable
> + * even if the architecture provides the resource.
> + * Adding this API allows architectures to add their own checks for the
> + * devices on which the kernel is running.
> + * Note: When overriding it, please make sure the
> + * CONFIG_HAVE_ARCH_USERFAULTFD_WP is part of this macro.
> + */
> +#ifndef pgtable_supports_uffd_wp
> +#define pgtable_supports_uffd_wp()	IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP)
> +#endif
> +
> +static __always_inline bool uffd_supports_wp_marker(void)
> +{
> +	return pgtable_supports_uffd_wp() && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP);
> +}

Likely a simple "inline" should do the trick?

> +
>   #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
>   static __always_inline int pte_uffd_wp(pte_t pte)
>   {
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 89b518ff097e..d6526a7f034b 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -570,9 +570,15 @@ static inline bool
>   pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>   			      pte_t *pte, pte_t pteval)
>   {


-- 
Cheers

David / dhildenb


