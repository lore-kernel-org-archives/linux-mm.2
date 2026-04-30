Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 432E7CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66956B0088; Thu, 30 Apr 2026 14:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16936B008A; Thu, 30 Apr 2026 14:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904DC6B008C; Thu, 30 Apr 2026 14:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8896B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:44:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BA99C17CD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:44:11 +0000 (UTC)
X-FDA: 84716097102.28.BECD1F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id B48C316000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:44:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iggrJQju;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777574648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l06I4xelml7EFeSQsTRAgMa6TIfSnLwPvqxz/YZ78Ik=;
	b=766rLDup9sLWssYYFMFhYLLki0lzMqrDCzknpiSfTal0Bxe5rL36dB6SZZcp7w4+Gke7hH
	c/plc+dY1QSbu4v9ShSSXYDgq8VFq8f6nNX+3szwUY6OhtQqQCk0F7Au3M27v18EjCxI7f
	o7Pe4jPh8Q7FeNtI74t8UHxIwEHDTwQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iggrJQju;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777574648; a=rsa-sha256;
	cv=none;
	b=X3MfohUY9NHj2kH+jA/EgEn/IGz5oBF/l/lancO9CSEeO5qwleHtcHuKvRlvQ+3dEqHSVm
	cWF7RCjWVFqCMqohaard4IiimnFqLgrZlVqqM1ZknWUHBvM82pTniqWmlxb0zzy1hhtnYK
	JMfBRLKU8Q8iCzqo8OfNTTUHoe2HGk4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777574648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l06I4xelml7EFeSQsTRAgMa6TIfSnLwPvqxz/YZ78Ik=;
	b=iggrJQjuanxoRAKiVPjobOtz+H8UVcfHBXeygwzpS0fNt/+7hY4EEfNGEUOQQuTmIfJwMi
	LQiFEtchwm8HArq7Li0gXrgXouS64QwWQPvTSy8zmfa0mTz4xHeqLYIZuAR6Whig3tKVWL
	LjHLlnqyGhJs+xYEW9FSzj5MLS7Nk+Y=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-VuVtNf4uOOqhUgLMI9LSBQ-1; Thu, 30 Apr 2026 14:44:04 -0400
X-MC-Unique: VuVtNf4uOOqhUgLMI9LSBQ-1
X-Mimecast-MFC-AGG-ID: VuVtNf4uOOqhUgLMI9LSBQ_1777574644
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8ee9a11aa75so282441385a.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777574644; x=1778179444;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l06I4xelml7EFeSQsTRAgMa6TIfSnLwPvqxz/YZ78Ik=;
        b=jfMVdCBCX9Cgyg2bDGHiVAmxXe1/vVI3pp8Dphd+7tlw4dHRbOVAQR5dEguiz6sTYv
         ulKYONFa5BCaKPEHP+fxrdV8iztAieXtj7pcWjv+BGGfJw12zWLh3QTfjgNC6MkxYcQ3
         gKtvNE7MP8lcBv22mdWdXk+J0q8UhinzVOsl3mOrGJZ4d27miPU2gHRvFhxjn883aogj
         Cyxoe8w3RfJDNUEUv4M4YGWFiaBbsBGIANwfagOJKv7N940Rl3p2gnB9I0CDGPGYc1j/
         QU9ocvvPD0SZbcxgPXROEC98CXClaZQmWvlDUowVugdURSjk5lyYW9xWnEQIOdei+YvJ
         WfeQ==
X-Forwarded-Encrypted: i=1; AFNElJ9LCQ4ll+iWE2m+G36z7tdpSOXYzj7T58s5GvT7ytfr+Uy6vKn9l137ah4sk7aut/e6hiPgxPxP1A==@kvack.org
X-Gm-Message-State: AOJu0Yy9Q5kNrDzp3GzC+fNJu+zUKib0YZBPMq1xX/RGRO5sT1lRszYG
	EeXdttrZDjoLr+FhRChgsJ+5zFCHznRHPlTpZFakdA9O7xW2G99wFXlmrBe9I/VdS7n5gKCssQr
	59h+8/R0mMTMZ2iRPeMuQYN4GyizT2i4Bki7YpopcUpcZViTtPlKK
X-Gm-Gg: AeBDieuAfxTUX842zwF+2nLM0+a7qtVUgUq8ucwWAbNdnsR6Cf08yemK0Y0N20Hggd1
	x/kxYAf36d6vpEaX/c2F1h9WkvLI8GNgGbRP3F1efser9mxVC1d0mbtinZjsWMZ1OIOjXIBzlya
	8gTY2z5TZAjHL/UCV8YdrUy54TQv4+QKhPbUJm6K48Rgop6nBEcO5yQsAgc+9KWPF9EDsPa3x6a
	eGNQfYz5l6mckumdxaybsrrvPL+zQOoa13M86rgs3p/B7XOiZR7ULs0asUbo0E1UQKlAQpzuQ1T
	GPXsW6HYLMnfZU7fX04qxzegm93N2a9Ny4bSA5WODo0EKNS1hhkmi0ac6XUR0OPBYnWm31WwTfQ
	/034KeecnOkyRJ1BjVBKyd/BZkfFX85Hie47Yh8TPR2lykCUdtT7low2sLeuv7uQHaWbw/EMAsE
	ZGCJw4rRz3PiLr2qrYNud2Sg0=
X-Received: by 2002:a05:620a:c45:b0:8c9:f8e5:9f12 with SMTP id af79cd13be357-8fab223a83emr548576785a.57.1777574643891;
        Thu, 30 Apr 2026 11:44:03 -0700 (PDT)
X-Received: by 2002:a05:620a:c45:b0:8c9:f8e5:9f12 with SMTP id af79cd13be357-8fab223a83emr548567185a.57.1777574643249;
        Thu, 30 Apr 2026 11:44:03 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fbb09fc9e7sm44487985a.1.2026.04.30.11.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 11:44:02 -0700 (PDT)
Message-ID: <e555a8d2-b319-43eb-a4ae-7c9b3ed995e0@redhat.com>
Date: Thu, 30 Apr 2026 14:44:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 51/54] selftests/mm: va_high_addr_switch: add setup of
 HugeTLB pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-52-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-52-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4oQQFF-ruG8pg906pqKrlXKaCSnd4Yn1Gm8-EgqeerY_1777574644
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8puqnybfubmhi1534cr4ecgx4p9y4frq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B48C316000C
X-Rspam-User: 
X-HE-Tag: 1777574648-299768
X-HE-Meta: U2FsdGVkX1/KgNKLZ1Ofme8xrgygv4UVm1TMsXk9Lz7vXmd+7ZUD2yIVMWO7YZSkx2BHw2ZAk5DHN5o+bVbRbuI0726B7k3ZTzRv/xQ/6tm4uOCGNESO36h6nJqxcHhF89jSeRfreHV0FeHf2t4+aZ6H8ZDi7K0bl+6B7uFpktrHyzwUO8VkP8m8AM+z5eej7qz9sq0HyKHfYhBoeEuskAnws2vkUMdSAhKDsIKy2T3M2OchSBEpYIjGaryve05XSGAlzQKTWyYrV0StcSNEGcNiv+3T8LhWGEwwIZiZsbpWW/ia0B3KTSyFu9fZEOQYI09Rn/4wXvTu06ZMPR/NLVGtfDaMOi9leeS/4/awn7JDoKESy2WpsuJ9HIbrf0K7QGRvoK8M1ZebZSKl5hrqiFsFK9M8SRxz0MUhGGxLd1mcmNvWYDBrMVLdh4MXDqPH2a2nmz3+laYBon4GpniAlHqkCj1MZtHalZHnmDByzA4cvXVP2w1uWby/c+v9a7EKFuKe6eP3i50mGd33/xFLY6xq+6quFExOwYl6ZO0njRTy6MAwbeWtYW2q7H8pCEu4c8+MqO3ryi26SNAQYx+pa7ADQxy1oFCTgAjqnE420N2bt4W6qb+OPeikx94ajQhY+hj5EvDWip2OvFd+MG9924SZKbmKeqEfA8KyHDKDlrBCXB1Hemqe4lwrCFPxvvoSiQzSWVyI7lpLUSu/YGrICDXZ5dICMoLEak+uMsMKVCuaMIRB+Gq/teaRVwzbo6Yu9cbKmLSzUefh0pByByuZkPp/DZ3b85WKRcno14AM505oDM1jTF9NkWjdLRQDS/NqFrAng7u90YStxKg8H4OaYBjaGWGQWlu8KnOiWNbl3GlxJ0eaC1BKJ7/Z6DUyUmM5CNciiYpaLQdDfvDE7azVoQR1ZBHQQZEtXd7uhMH30YtOJbRAKtxjK7t6g/s2zFgyBUSGSlIZnHgBmbIbXJp
 03l3wSFL
 1uN3AZu/2247EAD145nFuBUy821kbT/HYm92x2qp1/nD4CCQO0Gcq32HlJUlZfp70mgnYbDJQtX9bm+whIf2YSMQEV1k2Vt6tgq/jmKYt5Z9updkmfYpDW+4ysY0uVl/IbOnW2XQbmiAA1qSttOZCxHeYKrr6krVnOGpJdNWTGuj7T0bR+lFa6WayRJEYV94Ep00PwoHjMX5GaYcH0+s3tvIqlnxkzH05I4ZWyBFg7N1o9G+R839rC+3d8yvsIqgvdqa/FcbHJc2e8EgGolCEPMxr+ztMspbwXn8MnVryWTWgHjx0GnVgDIQ3SFRnwA/dOXhEA11zypascZLv108+4Yj6S4Dq9WNSoIuETGB7tTfUcP5vmW2HJ4Av9cfcVLImkpyqOzUpWb2DMjqaj16XsdEdk9RtRMJHA2PaogaRL4T/C9Bp65NQHZbkI55NfPltJ76xomnGixWRn3SobziKCn4fF8xSEzEB2gccsS7Xi3CLiu6shx3joN/+a3qoP/BpwiEHpse4K3z07pe70OOZeTptvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:42, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> va_high_addr_switch skips HugeTLB tests if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/va_high_addr_switch.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
> index 0b69bd4b901d..e24d7ba00b44 100644
> --- a/tools/testing/selftests/mm/va_high_addr_switch.c
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.c
> @@ -325,7 +325,7 @@ int main(int argc, char **argv)
>   	if (!supported_arch())
>   		ksft_exit_skip("Architecture not supported\n");
>   
> -	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> +	if (hugetlb_setup_default(6))
>   		run_hugetlb = true;
>   
>   	testcases_init();


