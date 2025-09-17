Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6B1CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0482B8E001F; Wed, 17 Sep 2025 09:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B178E0003; Wed, 17 Sep 2025 09:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02D18E001F; Wed, 17 Sep 2025 09:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8F698E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:29:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59F6311A621
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:29:59 +0000 (UTC)
X-FDA: 83898825318.20.F6F13FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA992160002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:29:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UtHN411b;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758115797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORcJ/40pST81yvYCAWc/eP0hnGAXGVPHAP2CtAwPNcM=;
	b=rwUTG8Ve3afxldfcWbiol7DU9GD0xfYnhySQV9E5vm4LqnB28RoZl8sHE4PyBYxwhRI2WF
	zDhMiF0ZSJOwFMXsVs9bVTjyDk5ekCuxH1rp8m3bve+8HXrxj2eZd/s6g7Jb0KTq3yER1K
	507JNxXBpnMyvQHmR7Y+tm7XJTavsaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758115797; a=rsa-sha256;
	cv=none;
	b=Va+GjX6+eAZUjRN331LqlN421mz8+gLzgbj8Cg0KkqQr9gGJTpcyaV2v1M42Es8WXVJGwX
	l5kgn2W3OrwgcT316tDzL8mwMcIaaeM9glVd2UjrSSyPTiW7bRcwexbkeptSO53imHc4gC
	qb6VYoT+PqSta9cLmN/fMW0IP/QeEQQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UtHN411b;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758115796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ORcJ/40pST81yvYCAWc/eP0hnGAXGVPHAP2CtAwPNcM=;
	b=UtHN411bjyGhrwbExCb4k4Keoi6ODdDEFpkU4fLTRIqM4yEhMZrzuX2l0lhsrIHFDDM+zT
	yrqHu0+J8MJCChJfnBR1xw92J6h1uDGLYS7my1vyTuWZ112EOGXQ+IxwW6k7MWTGjng/+u
	fTFLS0RQAW6JvYsjYmqZoGo5RuJVYLM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-Srio9ZR5MiuD_cu7frjD2A-1; Wed, 17 Sep 2025 09:29:54 -0400
X-MC-Unique: Srio9ZR5MiuD_cu7frjD2A-1
X-Mimecast-MFC-AGG-ID: Srio9ZR5MiuD_cu7frjD2A_1758115793
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f29eb22f8so18524585e9.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:29:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758115793; x=1758720593;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ORcJ/40pST81yvYCAWc/eP0hnGAXGVPHAP2CtAwPNcM=;
        b=VWdQjoQMnyEGnsTlu/QF9p6CQcvvu/CuoXEIXSfbS+oaCQbI1JO4mA/senTby2dW9N
         kXVn0w1cZElvVHDdzrNPpXor2YxexHWrVw6VO6fzIPafIrfPeqqAP91bImJBsmgdtx5E
         vexXNKonsOHC+fZm6O7s6iof+rSglv4OkLBNPFi7p64HQYkzV2VXvoLUPLjESAztTPU4
         FAsMm1bV57Zb/fLoF//9ptcp2KjXdsSZPpeUZZcbEAxpEbO+lsco5ydyZ/fso47fDsoN
         JdpI4GE7baImxdeEMLa36zByuy64L/1NCbbHE+1nlI7X/dTzY7ApRrdVES5Ek3tTo68N
         Nc0w==
X-Forwarded-Encrypted: i=1; AJvYcCX9hSw4cSkGbni37sD/FK87f6P+en2EFHf42yMpjZYodZNFsTsMZwYf74Cb8LWKv/pS1bFN3kvJvA==@kvack.org
X-Gm-Message-State: AOJu0YxkHjOyu2r4pUI/ricj8rn4M98y0T1dgF2vgzMhy27rxYLMGpiP
	Nmej+aUvyT+eIYrZSYDKVY2Wo+2y7y+io/m8Hu5Kse2RwJSXoDsQP/bsMd1y2StqLlmTlIF4qOk
	jKyWh7S2uWvyXbIOFpAPSubq6hQlCUbSbaq0BNtFma9a7RIxowAth
X-Gm-Gg: ASbGncshBlW/vn+ym+NTks8aKRIkCGywFDCawnowHOmewho3UgGl4pdYKbPSsD45tlv
	MZpaHc7NZZH3TPDWMYTzS4ukaB18Kf2XQz4Wz7ZxQwmTk+yTPdWqnU73lkMaOZK1P4Z2cDcfH7q
	GfVvOvDzTAR6j5eeS85Hag1pTmk1t/SOdc0bxwYbNqETOwfYYgyLkhGjMC2EnycNAIrcTtBAA9V
	mR+dmdmHPUG6TV5JGzc1ueAEqjI37+XFi5NH8qlWPSCxkSftgyZpza9G+u4VBTolaNrMgJTN14k
	bBUoqhzgWUTl0vrsD+AYeiQrUk6OgxcHgZGNsDE9M2iKUCAYqnVfH7Mr8WAi4qAW1CAXV/PJd3U
	JUyKcXrmXIKoKgKc+193bwQjsfsCQTjzAIKvhY+5GXFQxMXvnRUf48PzIcw9pVEXJ
X-Received: by 2002:a05:600c:1f0e:b0:45b:8adf:cf2c with SMTP id 5b1f17b1804b1-4620683f83amr19217995e9.26.1758115793372;
        Wed, 17 Sep 2025 06:29:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFi7ScQOvFIV87bvvmxFiQ/fPZp7fWi1TbijKapfO5dtDS3+Ivg3MogGqO325Ep+dlBbTlwFQ==
X-Received: by 2002:a05:600c:1f0e:b0:45b:8adf:cf2c with SMTP id 5b1f17b1804b1-4620683f83amr19217705e9.26.1758115792898;
        Wed, 17 Sep 2025 06:29:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613eb27f25sm38795825e9.23.2025.09.17.06.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 06:29:52 -0700 (PDT)
Message-ID: <aba22290-3577-44fa-97b3-71abd3429de7@redhat.com>
Date: Wed, 17 Sep 2025 15:29:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/memblock: Correct totalram_pages accounting with
 KMSAN
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, rppt@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, elver@google.com,
 dvyukov@google.com, kasan-dev@googlegroups.com,
 Aleksandr Nogikh <nogikh@google.com>
References: <20250917123250.3597556-1-glider@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250917123250.3597556-1-glider@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l9vgYte2Go4UZ04xf9fVGYyHxOTVuZzaJ9aREoFvxKY_1758115793
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DA992160002
X-Stat-Signature: ii44736ggdk1gpqf35bsuqekgpwzz3qm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758115796-290904
X-HE-Meta: U2FsdGVkX1/taW8/3evNF8CEwvIKr+x8zmdtYQftmR4/OmnWDY4uifxhNlcEBUE7X5MtvaQ4L/oneLxNdkuQrwO3hFY8dO1aIDStJ5B9w3wVrCa/YLK84wCuAImoTD6LYygAoV10EBd3qYcXkqIypq29e3RlWpq3IG2lpajxLzfvRoSG8d1d8Mw6Zi6ewFKRtU8dgW1SGyIYJN5mJUgf15gB5/+k/90MkMv5UXqj0AuZZXrSO6rWXlo5/WPIbtIKy5zdc7C0I49VZe50UfLUe7N9+clrkoYbejifekCdDD7PFs6vAlhXZOsjX/EeOTdjE4ZkGv2e9bc2J9IlcNRqPl082gl6g8cYi88lAxZAlzqhGiWS3Ghqd+PAE7pSWLGAVA88HkdYjJziOVebSAAj5ObCT5FVf0T9ih8nQ1oedd2EOiFwT94l8/5l2y8WrId4cyVnwOwjXFoAdu4ouXJEko/U0yCr65FwWi8JDqMhUn1hlEqK462iV6ifOm2MbdbFmeN0EFia6DtpROckhSCQm5sHdXuyPBi8DkUVKNBK8Nwp5m9mibhvsgen/L66cE41q9tm6v94LQ/dpNbKDgULtNZ2z+M2pRbEfSzoRdJoeXHD7o1ndIypwVKoUqC4kuqVYHs8kd5jkMTtdIXkx36T7skpsLP/XZE8tQ/0H69yNizLEEo6AUF9ht8uf6ub0yeP5f9GllVw6SNMqtYoeboM5y1aK4w23zFAZdbO/+cqP3si0C1Rcy1CyOitiOQouPG9bkzRO2VsFGqFDASWb0PIGZDkkLWnVc+i8iR0PfPRDMzaxRjgnciuPc7txkEM08m5hPoXNSy7UFtWhW/Te1gxyw9RnHs8Op3p+ZRfSr1pFyLlhHm5nqvUHT+zU2BLxnsyfTwJ66KbIySoxpwMIfmDDRP6JcDLAb6pxaj3iRsgqfjL8d7AIrGVQi9jdBx+nu0SlKcHkbuLejZNGW02kSu
 fTiHZGas
 ASZnyWNVHiUJZVi7+0v0rQvQprSS8+RH1pM4GjrBO45zgCZxAttfE7ClgWFKF4C4IcTJkOWNrviei3QItKgunamUkvGMJNATRoI+BwJiBwU+wDWN5GPmH4d8qKhlG8o7wu8PdKTMPHlN4QbvlhmDTTeP6LZ813SAYL0+eu/c4pb+2CBAvubSA5KFdmWgIx1GRNkdMBP/RoynQjJ+lDlFCBQ21uwDu93Prg9kDKJi/eSFrd28J0VX8DTrv9TU4+4cqDcDxnqudDdH3jTsspoN7vkFj5yvhPH2Bwvxv8BQ9x6U/6puziphslwP+18N0ZjCbMNy0m8xXjVVnI5kU905kjYUgutNUxfMtM5TpX7+9ZGQG5wHBgNwUq3bJl/x7LXR1tlPjcABUGQ2E5yq5GKfz7UFHgTFJG2nO0JVFmI2ZSGLENo1ma3L8MB1W8KKRCj+NT12hBAq3N1ic3Z3D39uFhjy5dN02p3c+iItBk8pW0eXYOsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 14:32, Alexander Potapenko wrote:
> When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
> for metadata instead of returning them to the early allocator. The callers,
> however, would unconditionally increment `totalram_pages`, assuming the
> pages were always freed. This resulted in an incorrect calculation of the
> total available RAM, causing the kernel to believe it had more memory than
> it actually did.
> 
> This patch refactors `memblock_free_pages()` to return the number of pages
> it successfully frees. If KMSAN stashes the pages, the function now
> returns 0; otherwise, it returns the number of pages in the block.
> 
> The callers in `memblock.c` have been updated to use this return value,
> ensuring that `totalram_pages` is incremented only by the number of pages
> actually returned to the allocator. This corrects the total RAM accounting
> when KMSAN is active.
> 
> Cc: Aleksandr Nogikh <nogikh@google.com>
> Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
> Signed-off-by: Alexander Potapenko <glider@google.com>
> ---
>   mm/internal.h |  4 ++--
>   mm/memblock.c | 18 +++++++++---------
>   mm/mm_init.c  |  9 +++++----
>   3 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 45b725c3dc030..ae1ee6e02eff9 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -742,8 +742,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
>   extern int __isolate_free_page(struct page *page, unsigned int order);
>   extern void __putback_isolated_page(struct page *page, unsigned int order,
>   				    int mt);
> -extern void memblock_free_pages(struct page *page, unsigned long pfn,
> -					unsigned int order);
> +extern unsigned long memblock_free_pages(struct page *page, unsigned long pfn,
> +					 unsigned int order);
>   extern void __free_pages_core(struct page *page, unsigned int order,
>   		enum meminit_context context);
>   
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 117d963e677c9..de7ff644d8f4f 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1834,10 +1834,9 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
>   	cursor = PFN_UP(base);
>   	end = PFN_DOWN(base + size);
>   
> -	for (; cursor < end; cursor++) {
> -		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
> -		totalram_pages_inc();
> -	}
> +	for (; cursor < end; cursor++)
> +		totalram_pages_add(
> +			memblock_free_pages(pfn_to_page(cursor), cursor, 0));
>   }

That part is clear. But for readability we should probably just do

if (memblock_free_pages(pfn_to_page(cursor), cursor, 0))
	totalram_pages_inc();

Or use a temp variable as an alternative.


LGTM

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


