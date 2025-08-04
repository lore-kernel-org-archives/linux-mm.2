Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23E7C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 17:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B7C6B00A0; Mon,  4 Aug 2025 13:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61CAA6B00A3; Mon,  4 Aug 2025 13:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510926B00A0; Mon,  4 Aug 2025 13:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA506B00A0
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:08:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 119B3135F41
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:08:20 +0000 (UTC)
X-FDA: 83739708360.08.01798E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62B69140008
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:08:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GbFjTkYz;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754327297; a=rsa-sha256;
	cv=none;
	b=315bplSKqU/QJunTxd4TJA6cSRAdLKze82kZ2cQp4g4IO+sQUjjn8LNhYh5rNfP7ySrdic
	xy/QJyDeIsoep/AqMZHcCHk+pbrX3XTi7lSlo6J0SCrOoEWSPBUikBYWxedpjxbYsXX7mb
	88izU/uJ4oL/7BUdNWTWgOeP10tbfII=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GbFjTkYz;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754327297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePyvgqQodTAe7mT85YIOOr5eczmwtpkJop4c22CcwJY=;
	b=qcxO5azHX+D8M+Dokm1s93Sdbo3bbZ/Jxfq11o8Z1yXUWPTSsyNr9Ax99MzQ09cRDN3RW7
	73Uq11LJMU+ZFD7qE1cpIG0IhpmRDMH2TeQVbfPy2Ni6MUP4f7yUI/9LbmdKtRawPsArmS
	5CmHrtTnntLJ2fKFzWFH3EdLM8Ltehg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754327296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ePyvgqQodTAe7mT85YIOOr5eczmwtpkJop4c22CcwJY=;
	b=GbFjTkYzsCYJ3xJPcJRvyt7kr0SXMA9ZD3z3CoJJzX03PGtDCVY/W2ZFH7eRIuW3dJWm4E
	w/0aPtND1ojWAFHEctJr6V2Q0uecyYNIA4aUo+wlwPF/WyjgQ65kr3gqxJgYdCbB7+ZbZw
	TH25Weew04EQ2zLYP7MGFFOAacmkE4I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-Cj4bfOSROlqtdMXZ1ZeYYg-1; Mon, 04 Aug 2025 13:08:15 -0400
X-MC-Unique: Cj4bfOSROlqtdMXZ1ZeYYg-1
X-Mimecast-MFC-AGG-ID: Cj4bfOSROlqtdMXZ1ZeYYg_1754327294
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459dde02e38so4551075e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 10:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754327294; x=1754932094;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ePyvgqQodTAe7mT85YIOOr5eczmwtpkJop4c22CcwJY=;
        b=EISd+s4nHlW+JhIkgMt8tZqCsGIBT3YBe8l+MG/7IcyO/okQDxk0lcya+WW3RLLIhO
         6WfgmlLJ3Hv43eVawaGinIrjttxMpp7AbTS8QwW+F/kQ1lOdXjLCCdSA4uCbB3/UpUDq
         p7vKZGT8aB5fRFS01M47yPlhY0hx9G+PPMhK+7QEPv5qQF5SA6sfPKXlrrlVpr1/RSja
         BV9N8kt6Eh6FGn281w+v8PXiIr8vuGP5Hnw/qPjHRK8yqRksrAtkNhirV2VCqrM7z4Xk
         sPuqj3u/cZtt0MW/SyiYJVd1+gnf6WbcTGrB80Aooe6Gk3m284enNFMbQ/m/MENcRwGk
         gaCQ==
X-Forwarded-Encrypted: i=1; AJvYcCViNvSwLbfDPld3fcfhMHmr8QwmH2Zc4luW9tfeHvFZyRp6eptujiW5rTNF3Sb18q06IbWkHsu1+A==@kvack.org
X-Gm-Message-State: AOJu0YznsDZ8TE6UPtew6yAbeUIGPBkDD1epZzs4cXRb8r2xrM8cTkPF
	S5Eg5zEJ/9lxUoEtKjj74TIkZWTGGDghfapyj6skj6JvxJwmuqx5ve8xqJfMvlfTqev+1A0JjBm
	k5UvjtVaF8i4iP329QRcEr8rN/G9sfH4tXryn3z66D+b3QAE249+R
X-Gm-Gg: ASbGncv+ryGxgPUys87FTOWBMzLQguKk2zQxibJVn1GsYpvReW/Y2lrAwtQaDGctwgX
	X7L6kIR5vX8hoUvr/tz135odix7NJeVuC3f53crpH1/wYEHi/kiDDBj6FvFCzsDGSz2BlxxnRux
	oVvj1mslIZD/QtHRwe2/Fq4Zl+Q01FN/VDyHUMfD2wV0Re7/0/gcjqS+7HMrdXFDpOLvSTisKLS
	zxxYa7EfehN+aD9uzSR+BKqFhgX+tqGDymY7lqZEiRlM//kfmARidU6SrIfuu+H4DRxwbHDXfI3
	gmXhrRb6tpgxCd4wyyG55XUc95VfMJMFN+iCIFXfzlwzYR2We7tZ4hnPLEfNUCH/Hjf5dfS+r38
	S3DRPnjdapiGO6reXqFt0ytuBWGlUVeLrLTqerMfBS22b3igXQ5uxZxJIWK5QDJyR62c=
X-Received: by 2002:a05:600c:4589:b0:459:df07:6da4 with SMTP id 5b1f17b1804b1-459df076f1bmr21148945e9.5.1754327294063;
        Mon, 04 Aug 2025 10:08:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXcoz6+nacCoSSnpua2VvOnWpL+nvr6I9+9jOpUQ7Z7N4/rvdf3huzUgi2tBKgpqINlpL98g==
X-Received: by 2002:a05:600c:4589:b0:459:df07:6da4 with SMTP id 5b1f17b1804b1-459df076f1bmr21148505e9.5.1754327293635;
        Mon, 04 Aug 2025 10:08:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dc7e1ddesm37027195e9.27.2025.08.04.10.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 10:08:13 -0700 (PDT)
Message-ID: <0e682d8e-12d8-4eac-b4ec-95444bf46ea8@redhat.com>
Date: Mon, 4 Aug 2025 19:08:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
From: David Hildenbrand <david@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
 linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <4463bc75-486d-4034-a19e-d531bec667e8@lucifer.local>
 <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V6c1qnQ0K-sr5Amtl5FKDuZNT5BC66PRCjVuqrVbyKI_1754327294
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62B69140008
X-Stat-Signature: sst936irmadbbexjspno3utnbma6t4yr
X-HE-Tag: 1754327297-5332
X-HE-Meta: U2FsdGVkX18cyeQ575hEY/9hQPTCetvuMgl5EAtjuFPuARYOsh3am+A3bMD3zscSI0zEafqEbVGX9sNKGUyVJ55DPhEnDByFHaQ9qHFC1qZhc0P4rPpA4zQHBrvsp71ejsMlomt7dw5uA30rhcIq2kJrkiDLTkVsapvoPRoCTag6B96Fg4ncisz0dA/qTkExZdznAuAV0D7xkBaYGh8OAAsnZZ1kgRAeuPYfmZbktfNMUgPppp9Bzv6oFCQnM0KM8VNFDXFbAYdh2b4QDgza83pF/w1Knav3NK+IZiiU6dLO0OqYqmz3SbVyxdraI3qKZO6jJTdkyGvGmq7z3RYUcRZ2SWh5Jnyz3Ka0vc+XVZZJhz2IxgGLXe2LvekwUKztS2mbh1/7ga6/21xNi6FOYNgqaSmOMEFlLyO1EnSE9C+S5qs1Eh0a7yei8FaLXB8zz1PLXxiaIQVv0aLgkQk521zWaXgE3GMy+w3+NuV89ufGIDNK1Ompy9fih8GJRJT2IbU2cblTcWHom+1tmvM2Kkp/mWZ8zS8QKmFKEn46HN6RbJuk+sc4ywM8tlUFCFwjP6GgJysiyK6ldYaBWwCL6ymzUVdu7jhvLEkRa3LNbIBR6Xb4p6Y43nCUyKqeDcdnbQyaB9FlDuihvLU+pLqpd3ueum89jF/Kte51dc2sVXv3Q6l45hchBZE+e/ZEtBYrQJUpQpot9njx39+KT8ElaMt2Fcbt6gh5bGeZrwY8cyZ9zYpD6K4uc0+pHKDjUKnyQdwJVXOdzCpW7DpBOAZWh4Qo8N/7JUQ7fIjzKY1EEss1bUPpQTn6o5jOy3IMGtVGxL5oBqYo4J8mf09RqWUE+pRzczS0t7Io7cLtQoqv10ESMRn+MqXmR7+K4qEEOck9t4TYBxZy09yyewpxFoJ4uMDpmiXrLqRwaI6YzG2/1uoVBZ1RuxSgm/a/IvICALqE/JoceBAxtvSWk8jg1WE
 q5zY6W2q
 LaHgoOQNUbSgMapCSLXvQxav7AfTJCoqiCceswOBshx3V52x86YmL9olohCwfPEvxRM2rqmwBikbh3+gdxMWjCfGqSqyK8OwFBEamCwETSVx+4c+n05oXHVMwlP3bHvKhCwX1vOk6fpESwzAouh5DWxwrwnN8l90eZYwR4L+s8LalQMucGrpemZz2dEdWe3yyIPAekQeEkFU/iINV5wLHJQRjHB/kNZ1tkHexifBDvVMed/52NQ4EHCKmtRYFRXnWB99FLmMAcFN41X/NBzM6hFF7kI3sVEecV1Mm4ee2qMB1JjJwW9oR00qmW5WactwEWBakjqBjfHoXJVAU8gO7JBJBrKq6S/6NtHQ3m24d0ntMgHwXEaZMwTV6NeX60DNZGylcdSs8r1rBF/dn706FszavSciazTCICOoPfXPmjWtGlb8J3wlhTP9dlWw5aJohfkUynzorkN3duHK1jwBiLkIhNQ/lnDxtHlcpw0lt3HfT3TOMnD6/cvhcjL3midB4p87Yrs9kKVtUDwYo0Zs4/Jxv/WkMP/0B2J4f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ff06dee213eb2..f65ba3e6f0824 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -866,9 +866,14 @@ static int __init thp_shrinker_init(void)
>    	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
>    	shrinker_register(huge_zero_folio_shrinker);
>    
> -	deferred_split_shrinker->count_objects = deferred_split_count;
> -	deferred_split_shrinker->scan_objects = deferred_split_scan;
> -	shrinker_register(deferred_split_shrinker);
> +	if (IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO)) {
> +		if (!get_huge_zero_folio())
> +			pr_warn("Allocating static huge zero folio failed\n");
> +	} else {
> +		deferred_split_shrinker->count_objects = deferred_split_count;
> +		deferred_split_shrinker->scan_objects = deferred_split_scan;
> +		shrinker_register(deferred_split_shrinker);
> +	}

^ disabled the wrong shrinker, but you should get the idea

-- 
Cheers,

David / dhildenb


