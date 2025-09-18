Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32718CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 09:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73CD48E00E2; Thu, 18 Sep 2025 05:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714418E0093; Thu, 18 Sep 2025 05:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602FB8E00E2; Thu, 18 Sep 2025 05:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 501678E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:03:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E96CF1A0851
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:03:10 +0000 (UTC)
X-FDA: 83901781740.30.CE60A04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9C9B818000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:03:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Y9h/r0Vp";
	spf=temperror (imf16.hostedemail.com: error in processing during lookup of david@redhat.com: DNS error) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758186188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFCZX9eN7thiq9pavKtpP8J9JCm4he2B7yCgrgp98u4=;
	b=5MIz8JVUq+lIPwS0B/DOdmGkOeVAI3rPnf4WC06AmBlXOrXvB4kKNZ0VjDMSdo1tzKmmRX
	eEEgxq/UI+k6zp9TcXrWWWMYWklAeycfDMMz6gzQALu8AHF/QMyfMepfAQ836QnbfzQRF+
	9Jgh41hc4QFH3jLrJi1VZcVFHqWbNl0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Y9h/r0Vp";
	spf=temperror (imf16.hostedemail.com: error in processing during lookup of david@redhat.com: DNS error) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758186188; a=rsa-sha256;
	cv=none;
	b=70sGXltmxNgQF7PBX6L1Hi2ldr51Wxt/tMVqtkqnp1WTHyBEdRBE9rdvUCQ4+SbE3Ij4lZ
	FsSwWFTkWaR7i/vVTyLyvS9EPsQDzkn1C3suoK+RDwrLZNNb4W6P161bBn2OCMV50DbzWe
	P6322gzIe7yLjUwDpEJiwSHMJUntJY4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758186187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XFCZX9eN7thiq9pavKtpP8J9JCm4he2B7yCgrgp98u4=;
	b=Y9h/r0VpHf3/ufpSzgH5A+J089yN3pUODumQjMB5qzLSECA4EMWXNyZvKKKLdh2tlbIh84
	5YZglV/yIwFnznq1IGjc2/cXpnseM00se45lrISAMhZoK4saJ6uMqAzq6VAynGnrw/9Yke
	zhZu5UE6zyYkBoawr88Tb7f7oivhKOg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-x4rMrcYkP32lO4UVplm-uw-1; Thu, 18 Sep 2025 05:03:06 -0400
X-MC-Unique: x4rMrcYkP32lO4UVplm-uw-1
X-Mimecast-MFC-AGG-ID: x4rMrcYkP32lO4UVplm-uw_1758186186
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so139270f8f.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758186185; x=1758790985;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XFCZX9eN7thiq9pavKtpP8J9JCm4he2B7yCgrgp98u4=;
        b=N1l/8ZBInqrymk7XoQLjuKR/sVQYbsK+B74fWp6WGVNkLFOBi7g7vZzltrFYbfCBpS
         pYUl6A0Iuv6fh4eM7tTrWYevZanH0ZmyE9XXqBo9FRCg1rAw1uYdQ8nAQCKiGgXqYw9S
         fA626KQAoS4S+0r30gIU/l8ElSDH5Y3hOoMysJTmuVM+ENFyEh/k09WQlBVz8TmzZ11R
         TsO2FMAJh3xsR1/PTVvGa7JwsiDIwP4VwqGNkPHmAEw3m3wjqacnfpVDDTs6yd5Lk5do
         yKKmKgRzWApgFUhNd+I1Fp21u51mOZp+GZ9DNQUWSXhVugbyW2lkXkH7iUURotdLUPdJ
         OD0w==
X-Forwarded-Encrypted: i=1; AJvYcCWNW7OIbCcEFubfGrXw0o90LHIhdu9iPKQOkoPlmumnCNZG4xpy9hhdTfCezKJDVrbFXwp5aY6tsg==@kvack.org
X-Gm-Message-State: AOJu0YwqPbl+fkk3crtGCFqx+J+jblb1+Lh7ihYxQboNMUr8jhnArMWu
	ATHyeja806aXtQ1mGwtwsR+2NhpaA0WUBwq1x/4okt78lMesMJ9I3GFiarT29a8EzI0LxVEQhKG
	GP1OL8WDfjKRJgLMsky3xCI4Pfx0/N+4vBqP9m6C9SVLPeHOt+/Ht
X-Gm-Gg: ASbGncusSneqHLHSKP4/+hDKr7/UvaACZH5RH6gOri/Czm2AMNr0AESy+FoTzr+uqAh
	T+l01HoYBwUFb2P67hF6RKRSrBMO1BFKrB3/FhfpKaTa+czd5vGkkP7aLPY4cAn6++Ntr//kbju
	EULgk1UWlIwdFwdJ5Ks8pTnvXwehLp26WYCdc3BJw3O6LHIZvRomgwzCz9nmPTpRCrUEA+ncreF
	CMhLFOmOYg8TnjVF9dsJkrjdfFD73PNAZunEj1F6mNenKoC8b7Z+ZpAbDWbHL/Fq+y23OGdcysc
	KJQbQEBP8yh7ZOoM4n5JeVqUxG6Jy6/LxurG9+qTxKkGmp63NJgAgQiJ6o1k48INSdSL0Fox8gn
	4SIm6/ILiajQAhN8D1BgN1wL90q2wddZs9zYmSkSUYdOEhg7WlPTJtzuNgI1fqznyGo5l
X-Received: by 2002:a05:6000:2313:b0:3e7:42ba:7e66 with SMTP id ffacd0b85a97d-3ecdf9f4477mr4804883f8f.3.1758186185380;
        Thu, 18 Sep 2025 02:03:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElkxupMxmNif5/lzfzUVobHl0PSoeQ1IdEubg1s704Bcn0Lb4/+vf/JHCv5gGV276WTwwYSg==
X-Received: by 2002:a05:6000:2313:b0:3e7:42ba:7e66 with SMTP id ffacd0b85a97d-3ecdf9f4477mr4804839f8f.3.1758186184853;
        Thu, 18 Sep 2025 02:03:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613e754140sm70721995e9.21.2025.09.18.02.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 02:03:04 -0700 (PDT)
Message-ID: <45cd1637-54f6-4941-9670-7130aaf080f0@redhat.com>
Date: Thu, 18 Sep 2025 11:03:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V14 1/6] mm: softdirty: Add pgtable_supports_soft_dirty()
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor@kernel.org>,
 Deepak Gupta <debug@rivosinc.com>, Ved Shanbhogue <ved@rivosinc.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
 <20250918083731.1820327-2-zhangchunyan@iscas.ac.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918083731.1820327-2-zhangchunyan@iscas.ac.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pspye9J77DSz3pt80JpmIE7xlLQ9V_Jr7zjHo_tBzZA_1758186186
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dqop5xeih6yywwhfcn74ohfhyhpx9ypp
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C9B818000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758186188-805736
X-HE-Meta: U2FsdGVkX19FY6JCqWVFf3hkURoheDb7v0ubeRCV80k3Bkek/tM6KW9UtenrmRsObETkVH0yk9r6rOAkrSlFxKbC6Bb2cOFJIYEoW0DO/U+MqLw50D8aaY2iSkRZ6Znloob6a1kBb1va5Mu80Z309Jtij+PJquBqCpoS3Xxl7vkBaGnI6bDc3uJfI1xhANPRDOIJZx6jFoxWNHTwaZOVJAjDQjdBRuFsEOpyRD/IyuPBpr+9fZBYU/nFDyDfwI0qwiK9RSXGmi6JwGc6XeXgXIAp2MEIZ8CFM5luTABdRwo4sCE9OjwIJADJI1rxed6u9YMzL3Cumoi3AtzSdJ4g9yfx0T8GL6sfyZ9I+ujSikLVoq+QeAkTZixL/9K/er9xK5pogL0iVHfkSN2g/rXjBGnfBDGV3FDT+yRPGYjEtD8QEEsfdQ942nRzIM2XqN8irDCYHkG1AVPF3qJu9knX1pCsRWVx/IfB9PixbtoY86zf8SR5f/s7Idfxl9G8NANzg7aDPEVbTNkOQZvukmlIbZ6lZz3nyj863lcYE/3Jgm5cKdmWo2+Z3RkgSVyVdf+0nW/nCSH1dWLUXtfVVadF78C+J5Z4ho6l1vDSL707e1e20uv3nPMsM708ogQ+hJ7sf9RaWs7J84x6p+mhHFBI9qaDd17mwqAhMeG4PaJFTfxApLsWBSwSwuzN9lVB2CtDBc0EcsWM840OICWx9MlUDsDwEc2Tea/uZ5Z2YG3qQ2r9FEFCBmFMzqsPq9rdX7L1y0A3rTJt9lv8xV+i6u1t4ztWChMeItUSq5mOrKluyAo1lfk/5KvEumTYJ2NbtwVFweYjUejcVH79Zm/EoGaBUx6fW3/2eEx3F3m5nMimJfAc6tzRjyshL2KpsrnCrmt37v0QzzizPcWATlKvBQeBnZxoy+0hu4vTp9dZ7PdgJmST0z09ugG05/+LK4+xppTGsOtyPBaaW/84Vz/GQ8T
 jwPtvAY/
 Dq388dQDZV1IaZcQHAhnZ9OieeN+jvSf0BeEO8oEYo82N1liJM/c/Z+25pZeoczM6vCfV++i1Z96wD1YakjdzGc2MADouaFh3ndJgwaqmO7BjuoNe+bxA/+a+6gOVYgfcb03iO1aAQc8nBUR+ag5O9Zm6MWn0yCw/bTeMBzmm4N7egoYfT0DukuiSp4wBTB6QWBRiOZAIH+zpitMMkwSnF+wp2m3czjUYa0lrxRLZJgQsmGUV2ci7U5HMfT4AQQUR2nW/rRw7DlGxbeYlK892+nmWNSaDyqu5M5Wi/CPxrtAfVqzdf6hjIG+5ooGV/Rles8ZmjVp2ZG67MyDyLoebTLv2mW/mdlSxURWxGiQMWMa2LcGISHSwuv0OQcQn8drbaTZTT1TWAX+Twc28wPdT63YxLcda3GnPTaqzZXcN/+aGJk8IY2dpaXAzeMfzVXfC22OUM6pvC+5ki6K7SIPE4twNiQRIZyFr7QdaZ+9FzZeZsZF+632Ofr5cNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 10:37, Chunyan Zhang wrote:
> Some platforms can customize the PTE PMD entry soft-dirty bit making it
> unavailable even if the architecture provides the resource.
> 
> Add an API which architectures can define their specific implementations
> to detect if soft-dirty bit is available on which device the kernel is
> running.
> 
> This patch is removing "ifdef CONFIG_MEM_SOFT_DIRTY" in favor of
> pgtable_supports_soft_dirty() checks that defaults to
> IS_ENABLED(CONFIG_MEM_SOFT_DIRTY), if not overridden by
> the architecture, no change in behavior is expected.
> 
> We make sure to never set VM_SOFTDIRTY if !pgtable_supports_soft_dirty(),
> so we will never run into VM_SOFTDIRTY checks.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---

[...]

>   mas_store_fail:
> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index 922ee51747a6..a822fb73f4e2 100644
> --- a/mm/vma_exec.c
> +++ b/mm/vma_exec.c
> @@ -107,6 +107,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
>   int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
>   			  unsigned long *top_mem_p)
>   {
> +	unsigned long flags  = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;

No need to resend because of this (probably can be fixed up when 
applying): there is a double space before the "="

-- 
Cheers

David / dhildenb


