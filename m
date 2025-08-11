Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB8FCA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 07:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4ECE8E000E; Mon, 11 Aug 2025 03:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26498E000A; Mon, 11 Aug 2025 03:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D151E8E000E; Mon, 11 Aug 2025 03:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C141E8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:55:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DD3FC0148
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:55:45 +0000 (UTC)
X-FDA: 83763717450.21.34A5535
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 39B301C0009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:55:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f43EEDPr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754898943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uv3XESjAB/y2it8V6P0vpP7JuBmzb6Wp3zSqu5Y7Lxk=;
	b=g1eNmqhT3V5se61gV2dNnfgNA87fq6k9R3gQYsZdp/sS+7Fmu8g9VUGG49WYrJenSZuyS7
	jFxEKsWtLhr8kjdmK62j0mJYsb0yrAaIZxcMdnjDxpN+r4A9qzwUASpwuuNja5EnTrSOzk
	5EQyGBrf5dOFA7Zuq5MoEWsWCearY4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754898943; a=rsa-sha256;
	cv=none;
	b=G1XdMjb6V/7ZJxUgoIWx/ftLmotOQ1TMdEmBPerJbenTKvSXvr1HJkqoGRFOAHri/A7Say
	6i20edpZqA4CoT+UgZvWPIAtCowxM4lMZoc3IwxitRUGQq2gH5MbBErWJiHRHRzVq9BDHx
	Pgh+8KH274SoiIcTQTPQSlIwCJGUcqo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f43EEDPr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754898942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Uv3XESjAB/y2it8V6P0vpP7JuBmzb6Wp3zSqu5Y7Lxk=;
	b=f43EEDPrpRQV9/FP5KQBBsgKrVL4wFkCvUXNP3R8ikZSIviXYWbamwoOkcYyhTY8vyKrQY
	qJm6hf0SNaSDKi5sXl9zpz0ZacHhEtJLS/1rjXYBP4di93OgDeyjZJrIYgMJusO1tmL08+
	6fSpqDwgj0diHRFJ1nqQ+QfI733cXQA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-cCdXpNSyPHCEb3UBmuLNtg-1; Mon, 11 Aug 2025 03:55:41 -0400
X-MC-Unique: cCdXpNSyPHCEb3UBmuLNtg-1
X-Mimecast-MFC-AGG-ID: cCdXpNSyPHCEb3UBmuLNtg_1754898940
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b8d62a680bso2233327f8f.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754898940; x=1755503740;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Uv3XESjAB/y2it8V6P0vpP7JuBmzb6Wp3zSqu5Y7Lxk=;
        b=RY2S111WqfvpBFOK0FGajIaMEkzfU4Zt65bJCVCz8b7qGAnPZDcL1To0kgEtNoSlYG
         iZZwMiUnexiwXnd8WQSIQbRUGdZifrPrlZTRq4aDCPFyX/qMgWTUt+tW0UPotUKnaNWu
         PSV1PoS0xZUjED6U/L3nKrU2Qn5GZdooXTeNjFpehGog/jvy30Ia2CXhSqli9tCO5ZQp
         t4jtMJVjE0b6CcekVkBOce4gXxzmUEzCrWxQLZzQgLJwQ+ZB8PLMtMmFIWQlYX7tzj/5
         2I3pbZ3nJAczAfazJr4BHq5DIcMylXFI2mOW/oe6kBC+z15CRsADlVVkYmqm3ByJrPRG
         W+zg==
X-Forwarded-Encrypted: i=1; AJvYcCV/xvGdDXsQcHrXepmSjeNHVlI/7vCXT+C5Xqt0izqhgHshs5iIE51XMm2ENw5ulDkLFvy2qlo6Ug==@kvack.org
X-Gm-Message-State: AOJu0YyN88Us8Wnc66zDAMzMwuiYKUb+9VU71HApFD9RzUFYeuZYKfO+
	HrJb7ITp5rGahcIMhElGeUPaHbMzGSLCdvjkFvnrSx38f/LJ9OTPsruTZmD+IP8GJbHAJwe/ZmC
	30siKqAKdGn/lU42G12fxqBOdfMDmPKQS/a0fDg5O7GwcBpa4GAu+
X-Gm-Gg: ASbGncuAxeKWswYxGynUpXDzd8TSFjW2kkSNYEvwt8xMVU6k3/8VNiKRNUYTo4wccy8
	ZVAPEw08G6dMA32Lma7HnbJOXwAyul7U29vFpYSDdrOpz3w4Caz3sNx4Scs1fb1eSYmRmdow5Ib
	hjCDXrr/Yysf43AF2Z6DiLdiBfn1k+UUm9QlBAij6EBfp4ns8z7NV78tJgvASDuwG0grNFgwFXu
	mfH4fZH9sRuqhRoA67hRrJVrX6UuT84iw8pwAEjDs7ttRDvbuQmCxoeP67rJDTJVxr6N6UN/8cM
	meMae+8QYZ86xI88FykN+gHDexq1xVTSQf5tfv5C7Xhmrs8jk6qiIE0ZOsIkCW1k4yI2sNE=
X-Received: by 2002:a05:6000:401e:b0:3b7:8ddc:8798 with SMTP id ffacd0b85a97d-3b900fc8b50mr9413806f8f.9.1754898939913;
        Mon, 11 Aug 2025 00:55:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFFmE4hdAisPiH8spgmJ3wBFx3S8E/+8JvMJN5n2ldzKDQC82ITPh71N2S+RjYzxCZ8lfaXA==
X-Received: by 2002:a05:6000:401e:b0:3b7:8ddc:8798 with SMTP id ffacd0b85a97d-3b900fc8b50mr9413784f8f.9.1754898939478;
        Mon, 11 Aug 2025 00:55:39 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a3d6.dip0.t-ipconnect.de. [87.161.163.214])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453333sm41007904f8f.45.2025.08.11.00.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 00:55:38 -0700 (PDT)
Message-ID: <6e6027de-dbf0-466b-a8b2-f719df90162c@redhat.com>
Date: Mon, 11 Aug 2025 09:55:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/huge_memory: add new_order and offset to
 split_huge_pages*() pr_debug.
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 wang lian <lianux.mm@gmail.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-2-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250808190144.797076-2-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q7Fee3mofoOyHCDckBc_sAOvOj45p2VOHwedS1DpBwA_1754898940
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 39B301C0009
X-Stat-Signature: icsb9czkupcoyd8npujsgxatkr8ecn96
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754898943-789172
X-HE-Meta: U2FsdGVkX19HMFnZtLTqwsV5ZPR6l5WZnWzdnfiZEUZNGCxpOJVl6bWKxPmILg6sU6r6bvLMisyeUYDCD++M9J/y3gYN/7I5CTmKcioyJH2KXZlRbn8eStJunTPqOXLZ0w5pcJ+BcAxX8ncK9xwTkeqRZm12PEkPzDyjlEMkL5HUMvDaH5Mg5a+HK7QY65N7oLQQ1zg97ggKNHjSkeSGlADlDJdoBXilm9lixX1+t+hqKJ5awLEHX1yHkFCBjvU0FS6LW1b3NUpOAr6VpME4fsYuL0rQl9rmlWc/Se1Wl2ydRFrYYnpSR2Z0UeeCtDXIb7AHgmUoxZfuAjorxtijCwpxuq8Kl2xMrIwJmt2aojflIe8GCXcUltGqsomxqVej97TWy3p0Uxk8d16uWt+S2gZLIP7eEg6x2ZyAy+hi1EfFiJkJiga4oUwfBiWkVldcMLWP6J3Q2vSmrO2iyZh+pamexGHoy9BhIrykLxNmYCwVO6wQpjp4rvWHCY181HpI49Fg1n9egxNpXx729daIc6XWONVBlLvW4+V/wyZkatGVYx/EZZXwFsKcfslEaI5bzcDXV88koKxhuNbxGlQIhUEDRN13xjMnGoUAu+72e0KmBQQfqKIvs4EiNjiR/SEdta/jN4q0fIYWHYptR5mq1AgDJTOAn/G+C40jJFa/1rdOL4SYsnKK+5aKoxdBJoyBKTWXu7lDroPCtwDFG7DqQj8E1DNBaaKqckFf6LgIpiKaOYxjVsaiHi4tJYnHc5ypMdgT5sqk99i8huZZYhEVqYu0nDe1FMU77e+UHvPDEzbJewL2LK4LCRNtLuIK4rptz7caArjgmjWbfqMNJg7a4XFRgKwq8n3ruiTw+AicqyfIrUmeUlTgYOULQ7+A7p++lMEdSeoHG5Srj/Nllf9sZdzNZghVr/ifZu7hoCx5C5XqHRJDYebRAbmMsZS9goOvTXLRJXGlLVzhqx5tfHC
 E+SDNH5i
 Cn1Uj8IsXUGIsyx9rNwPD41Q6yHnkdXTogo4IkKCl4IkRxQmdM34cE1dlSsdq6ilNqHQkZBq9JCvffD+bA3dVATSUFzROjl3nHefvPoA4xb418tu/9/CDiiRTWKl4ln94Nl+t2NxmjHfWiZ8+g8bOe1EM2A6wyZeHjHS4O0wq9FpNd0GICrQqEFmgWzifcx5U4ibz44UqdZqDMu7VC3KGb4HAX0ukctvWdmtmArIWOrIdiXEtg3DlRw/EM44MoYTuDOmEOBTK05zddei6gPMOkntF/Hox/QoNSVA3BC8YyvGarEG0xc7JdBuB7s4T1tIo+ZveMU+NpLg4VmzVCLiyoS8Akd43zaYFAIb6z0xw8SHXJTU+A58n78WTLNkH7Y6I7uuU+OpB6zrAzR6D/oyY/LD/YpExS9EIRBOqfOGYBm/dbVY+owZ52bLKdO3AJYh9ZhgKJQvki1sNH7bpLWHVgbQBplxb2bw15VnYYkRkk2brCdJYJr9xkwM8JyerNVT+V8G/I6jPaVXVGyoFA0Efk+XK8MqwV5jAdtQ7ehNyJaEhNl5VVn4/BomcewU65rECX08EUX11mdA/PBE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.08.25 21:01, Zi Yan wrote:
> They are useful information for debugging split huge page tests.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d..ebf875928bac 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4327,8 +4327,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>   		goto out;
>   	}
>   
> -	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
> -		 pid, vaddr_start, vaddr_end);
> +	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
> +		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
>   
>   	mmap_read_lock(mm);
>   	/*
> @@ -4438,8 +4438,8 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
>   	if (IS_ERR(candidate))
>   		goto out;
>   
> -	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx]\n",
> -		 file_path, off_start, off_end);
> +	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
> +		 file_path, off_start, off_end, new_order, in_folio_offset);
>   
>   	mapping = candidate->f_mapping;
>   	min_order = mapping_min_folio_order(mapping);

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


