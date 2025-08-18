Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F9DCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4CE8E0019; Mon, 18 Aug 2025 03:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75598E0013; Mon, 18 Aug 2025 03:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D2B8E0019; Mon, 18 Aug 2025 03:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCA8F8E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:43:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26FDB83E6E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:43:12 +0000 (UTC)
X-FDA: 83789087424.29.3F5A8DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id B80F8C0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:43:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MoRclEqH;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755502989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Q9dfL5NkBeTOjHsVTZ5sPYGGBR76TYaJ3knIQdKHmo=;
	b=2rxVvh6VAQMtazBYl5AlCcE0fbkbFjSl47o0IRJ+PQmaZsetdg7cFhuZj6PtAnBYf9GAjb
	VIuXg3rhPodh6Y9qaAde6wLCLu25LLh1BRH4ZHDSXynhOXNk2ZTPQuZtRaPnVH07I1TD9g
	7jS173Zj1Dl27oPaG6clN/pXOiaXSzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755502989; a=rsa-sha256;
	cv=none;
	b=RwsUZ+Jg3OlJwKErDDFR+gpVDjKI9iEKs6aJIJ2KuKSFy5a4ddPBUysAv91yjafotLZO8o
	LZGbHaxB6A+TM6ksIyGf7lzfDF9OomKkHLCoy+LtdwY5r5e0Nwy+Ebir9g9coM7QjDsAMP
	8eb+DhF67wqC4rN0qnzmia2/4xFmPiY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MoRclEqH;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755502989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7Q9dfL5NkBeTOjHsVTZ5sPYGGBR76TYaJ3knIQdKHmo=;
	b=MoRclEqHsVa/6lYVzQX5ePjIPXJtHRFxkW87O1YTKaTI9N/GdoQDyG+sP+9zvYe671Pu15
	pudQPJOlZp0RooWiJNq2LoAHuSt+psrCC1XV9udb8lhUo1LjC5D1+h5H9ka+c40bf2DqA8
	f8ftdl4fSxfZGOOU4UvvPVlmNXkmIGo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-b8cPPAbNMiKRPOf0x3DaFg-1; Mon, 18 Aug 2025 03:43:07 -0400
X-MC-Unique: b8cPPAbNMiKRPOf0x3DaFg-1
X-Mimecast-MFC-AGG-ID: b8cPPAbNMiKRPOf0x3DaFg_1755502986
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b05d8d0so22215925e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755502986; x=1756107786;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Q9dfL5NkBeTOjHsVTZ5sPYGGBR76TYaJ3knIQdKHmo=;
        b=U0EKwCt+SeVV9duAuz283TBJ5wOmAEA6alZWN9XwvcadC5hEfZvGWdxOjPnwtvUXfz
         iTKHA62AghDD/RFNLDWeW4PBgc27INUSo0PXM/DDGh6+wrXnpePgDImxPIyW2zbsWUQ5
         6P8l0b7Z77VifzGSvmEeGEzVmV+m2S6VzNoJPEQ/2S7qIH5C8a/KXOm8u01VhbDt0ZSF
         CabJL668LvOJK70Pdh/ZcGbdHNmjcDHAhiS3EvtIu/6Rdn3ttc+ixtu2ukyq69t1KoHw
         AZpXqe+HjQ6pVPrgoBqII4nl+iDdschlSiX/33iqCRewClyWiqAWSZuYb3bF11noLhAn
         CofQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwphTXTtVxHRDENEaOW0ciOF8AEtTT74T+YRuRFh558oS0pKn0d0S0zMbHAYb7GKpsl/g5Oo+NgA==@kvack.org
X-Gm-Message-State: AOJu0YzjPvfeOEP05wzyuvWq4CyyZ+rfM4MKWRr/QYacuWnAIW0ezJfI
	p8SMKiPjFcP6ynudnEvTYbDuHe39VycimQmsgF50cCiB+6QmjLwJ4jMHWh/+usxzGcDBviT0xnB
	TYLWQ8sQ8ILjYVnQ42EPbTn+/Kw8RaEu11xPrngWpoEN/q133muqg
X-Gm-Gg: ASbGncuTWLWTrCY2cBzf70QKxzCN8n4GRlYNyTzxxfMbcmqkrtgRihDYMrjk9qYn4cN
	W47SHkIbhS6FeWarnIPnTORFFKlImuu1zx9WOGxRKLhPPiRW/WDSYS8tnI8CVOiu2+g2iEPtWLB
	0YxGVivuotiNBcnNoqBOwXNWv2xTDxC24DJIxRT4E9nj3cMBXXz+XRBpqXe+F4u4dLqb069Ourr
	xpTgBbFubzkl4SZeqazCjp5h3Gfb4ToFFTnlVW6ds/4KuhlbeTXT90V7ZrSGFMDmnd9Yh5wEiDs
	2z/9g6u7F0fuQBdV479hJJRcPnYgPMNN2Rpb5xn1MC7c4XzAqNIiLm2zbxDekAK0fmSz8qgblT+
	BQbuGaSkG5Jj01aEBu6ubpoF6UdsFj5PeucqybvR1MuSGC+ukjAW9E3/o80nqKzIr
X-Received: by 2002:a05:600c:3b27:b0:459:f90e:4f5a with SMTP id 5b1f17b1804b1-45a2180628dmr95908645e9.15.1755502986192;
        Mon, 18 Aug 2025 00:43:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbUO6Z15wcjLXZ1p7h5ZxBFKKm7y8rLmD0275SppxqeMk9vb+XVHeYCjL8BnaHtfWRGyYaMw==
X-Received: by 2002:a05:600c:3b27:b0:459:f90e:4f5a with SMTP id 5b1f17b1804b1-45a2180628dmr95908285e9.15.1755502985704;
        Mon, 18 Aug 2025 00:43:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a22329b12sm121196175e9.24.2025.08.18.00.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 00:43:05 -0700 (PDT)
Message-ID: <e05aaefc-1732-4dcd-81d2-413d74aab664@redhat.com>
Date: Mon, 18 Aug 2025 09:43:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] of_numa: fix uninitialized memory nodes causing kernel
 panic
To: Yin Tirui <yintirui@huawei.com>, robh@kernel.org, saravanak@google.com,
 dan.j.williams@intel.com, akpm@linux-foundation.org, rppt@kernel.org,
 Jonathan.Cameron@huawei.com, devicetree@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, chenjun102@huawei.com
References: <20250816073131.2674809-1-yintirui@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250816073131.2674809-1-yintirui@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bgOqCMYDRnn2Dt7v0wj-4EQkr0z-YFQR2C_bI1xYAyE_1755502986
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B80F8C0007
X-Stat-Signature: con8u8xf7n8u1hjtfbezghkowqu5eshn
X-Rspam-User: 
X-HE-Tag: 1755502989-304125
X-HE-Meta: U2FsdGVkX1+sP7DH6WlguB/sfWM3DrlwUHxMImEaKU3z2t0lspQnN0oFGI4nSr0JJKaJabIff+2y0Y57pFkczFiz6/Nv5E88LLvnSkjNhKLZ0s1xFT3GACnQRZ/I3QMFng9z+LpAnCsAY4mJaCRMx5x0E3KOWDuMKT5KncrqZ2oYORSmt8o+aP2ZG2NjElUTehQAvbhL3fC5tSHBXwSDmBKw5yj6RRv6PkksVNIdWQBon0UTnwjZyeKsWQZ1i6R9SypIgT94dByT9V0voDTZSnPdliIrOOo3jHI8eWtvBemEn+mtC82BOLUgKY33meyQEXDeWHwRbNLIC7icRpNJaAG5kLAmVft0xwFE+ugdUZH4AS3AVV8LD4cjOw7vZOqa0cAaHCXMoEbwOZZfus8xV6iyoNgbWn9m22zi6zkhYolxIVnP8PoFbWRr63Bk03yqhK5NiKvbyGlPK+g2pkXkz9mgFNMR38vlktj94xWL/eyd/AyECvAuRZlfvH5x5zJMOx+5MYes6U1Qr7trUZe8qsbV/HoRQZccncjoAju+h+7JxTpMiaiFtkfpyXB0DjtMft5diu9tSZ6SgrX5UuH4Pi9nq5dpN1rcIESiVr6tIzzU8I1P/u608zJF+8P4zPdSyvgxwpSvFanfthJo8lTLiUGPoN18FFX2i3Gnc8Is00oT/b9S4XEMn6ZkZdLBPdwlTvgQqDI2EvqAAiTsvUy62Qk+YmE58S3p0rSmFHyRfJDxTZswVf2HLQWtOsRux/VWPimr+yHxA3j1YLN4kHoEugu8XVvJbsvtW1/XNisf3iV/W5Bn0ANKuwPMl8Bv/QqQ4tSYP9JdxVyV09Htcj4hNLdtrBx5nQhhQpDisjg/PN46aiSSA/ZMRa+DxT7Uzmh76gkPUDAbHNBv0R0eXM2/MwY+/WNwl0C3ZoF9ALXdrsj1PqAWFAuzHEcGrDrvqnOGRp+tNEPrgogaV02Yw0f
 2SUzrEOr
 Q9yWIcq9kdttLaUCcLYdVEKGIol3t+9gzaIGfi0aKZoeM/B2mD18Caj2ZHx+Oeh2JtBJCUbtV+cjdTdhxr4GWoOU9zazfG0V4FdAo3zABQ5E+a/aJyTO1Xuq5jNUE4fHOZYaMNFyWWKyOeCV166qOutnVNC78Ai6XnTe3LcwGM1MJ/z6xFx1jm7/GzWiLvOB++6RDxGsXAASYXS/tQQcC+q/6T49spVY8q3v3ayHdioqUblc8SGLBaPdr4X+nX9iVk0eLkYX2n76h9bwwJg+r2TiwF4/6y1UDtMs46OZ3kqz4Nz80rO3mqBRW0Ncic2pWQu+njV2nNzggkUGNm0Benj5LCTnjOYuKOL3bucC/0YCgo8fQZA+pds10xUYVK4Lue6d1uVJuxCBLAzmJkQQ7QtaTDaN8ywNIxtMyuAmtkcS6lXdtg8v8T+GXBqH52Qh+PoU9g+IeYW/GQkrn+32rPbpmYTubNV06qhV3csAx9tQEGAg5RJVQv223w+7hw7nX+7baTfhLGz4VCu1JuWC9J1yLon0MKUmGLq7KPxvaeaBM5jH5NUhePug3+BJYR4QxNz6WfLdVyphQov7b+S/s//JP6WovUYyqjsL+5/YKp9PN86FlRSHqnuOhVDea840D9OqM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 09:31, Yin Tirui wrote:
> When the number of CPUs is fewer than the number of memory nodes,
> some memory nodes may not be properly initialized because they are
> not added to numa_nodes_parsed during memory parsing.
> 
> In of_numa_parse_memory_nodes(), after successfully adding a memory
> block via numa_add_memblk(), the corresponding node ID should be
> marked as parsed. However, the current implementation in numa_add_memblk()
> only adds the memory block to numa_meminfo but fails to update
> numa_nodes_parsed, leaving some nodes uninitialized.
> 
> During boot in a QEMU-emulated ARM64 NUMA environment, the kernel
> panics when free_area_init() attempts to access NODE_DATA() for
> memory nodes that were uninitialized.
> 
> [    0.000000] Call trace:
> [    0.000000]  free_area_init+0x620/0x106c (P)
> [    0.000000]  bootmem_init+0x110/0x1dc
> [    0.000000]  setup_arch+0x278/0x60c
> [    0.000000]  start_kernel+0x70/0x748
> [    0.000000]  __primary_switched+0x88/0x90
> 
> Cc: stable@vger.kernel.org
> Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> 
> ---
> 
> v2: Move the changes to the of_numa related. Correct the fixes tag.
> ---
>   drivers/of/of_numa.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
> index 230d5f628c1b..cd2dc8e825c9 100644
> --- a/drivers/of/of_numa.c
> +++ b/drivers/of/of_numa.c
> @@ -59,8 +59,11 @@ static int __init of_numa_parse_memory_nodes(void)
>   			r = -EINVAL;
>   		}
>   
> -		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
> +		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
>   			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
> +			if (!r)
> +				node_set(nid, numa_nodes_parsed);
> +		}
>   
>   		if (!i || r) {
>   			of_node_put(np);

With the changes Mike requested and a more detailed explanation you gave

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


