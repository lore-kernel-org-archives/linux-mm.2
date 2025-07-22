Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595FCC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C810C8E0008; Tue, 22 Jul 2025 11:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C591E8E0007; Tue, 22 Jul 2025 11:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E6C8E0008; Tue, 22 Jul 2025 11:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A80CC8E0007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:40:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65666B9663
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:40:06 +0000 (UTC)
X-FDA: 83692311612.27.ACBA312
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E312F40003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:40:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VVHE471q;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753198804; a=rsa-sha256;
	cv=none;
	b=8pF3sqMGoRZWGQDUSJuf2DMAdgxi/0hYcsKnjlJHNM6+KvSRwqjaXOPpc0IIk0Vmj0v9SH
	o4sQvyw5nZ53ksmLaYtT7ZDzHJHDDdAAL8mdPQC4j1xP29u9HreKvaT3BAKlsUen7jSgVj
	UFmWovSHg2bFEszLwNld1OxK9qO0RhQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VVHE471q;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753198804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6oftsaw/Y8o1NDs+0pBZv6sXSPAX61Y+1sP2c3kKIk=;
	b=V8jd9/PQ3uaFdZjnGGNGxequW/FgEiErZ2Bl29/26Uc9JRZWEXGmwhO2YSDfaPzsXWxZwI
	z2/DA3jsSgL4EhakoZp8+nFg2BJLHiIos+8y/SgZKCgo2luIX1UQd3xrXUk/195F/uSt4o
	VpQt6KaFN67UUhruBm76QZcuAAuBHTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753198802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=P6oftsaw/Y8o1NDs+0pBZv6sXSPAX61Y+1sP2c3kKIk=;
	b=VVHE471qeCQAG8Gsx1oYzgDMU+0iWbJwMXxBUoXJwUlL5OTiUqZAiLYEq92mXrWIhebBAS
	nU2OfPPveRI7eO8TnPISOWdsT9/KMesMqbQsWIbGOk1zvItd4UvSyt+1MNr44/1b8Qj4T8
	Nvqvqe1hYKMQjom6f3ZvdEJgCYwMrgI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-lmkHqwawOqChn7DJk6wZ7g-1; Tue, 22 Jul 2025 11:39:58 -0400
X-MC-Unique: lmkHqwawOqChn7DJk6wZ7g-1
X-Mimecast-MFC-AGG-ID: lmkHqwawOqChn7DJk6wZ7g_1753198796
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4562985ac6aso57912165e9.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753198796; x=1753803596;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P6oftsaw/Y8o1NDs+0pBZv6sXSPAX61Y+1sP2c3kKIk=;
        b=XFCn6KF8NASVcaotYfyLGlrkZU4HnipPc7qEu+gqsfSXFhoqpMzzp02QXt/nqEpyKp
         YmhlvqJ/vBTzL9sTIMRFCpk+FR7QoV+4J2zI8zzRjigii7u5xliP/yvro0V6DuTJ/+8F
         YBAHvbyogQmdgOi3eOGQNhn/opItBiUiFFPyf75CWitYJ2BYPjg/CeVBYMhEdyc2QK53
         qNTEYuOB9FiJL0J8PcHIj+Rb155MHJ+5Dla35Xo6Nt3UnuWHJ47pZlmy6vJfkQlOt5rn
         bO1hedSJGtNH4wKoKrNeiYYNI2BYMpwV+mGxU3I3KYYSLsgsv1BTrUg1r2KPWb8/NlYb
         rrDg==
X-Forwarded-Encrypted: i=1; AJvYcCVV2YiyEp+hLon9PgWRjSXDJzQr1QRI0C/j3bBIcdJjDHJcvDq2YQYBrXXnZ4UCfpVG/mrYPu3d7w==@kvack.org
X-Gm-Message-State: AOJu0YwqSZNm8pFkHFa6ap6fsLPcEuml0zzi8EtRutAhXdOIYZK3kaHY
	uznkvSh5FKod3/9Uv+7l4OemHc8+7uSkCWOSk77ZfGOy3WAC2LA22Y5h1BjgoZQq7OXSP1jzQON
	f834Sx3QgI+pywZCnfWCHywBbP19Z1ddAUucJTq+qI8o0pF51CqLz
X-Gm-Gg: ASbGncvlK+2V+RFTPDCVDA2IMn3tqMIHedh1yjzn+U55Uuzyk5znMeiRtOKHvlVsBhW
	LEUTLd+V2aAJVEZkTlzJZRSn3sPm+z/zktzyEqJGL6O4xcxo5C9rq7guqIvty3sWTGmpP/aO1eB
	/y3GvX74GSEtJAnakSXqmRLKqDzYSVSDyHrgtcNckL23/mTowTfmyf8GTmkCKeyLG0OfEct58Z8
	J5s66Q2y1Jb7gkaaRfzQr//RQhrGQ7BZr3drpGLI9pARzRNxTkWGK0pL15U8VcpInWCazfz+8N/
	rrvIw+/yUZB37dtpDArRGFOFqlp+ZRL27BwLZEybcc+qforf2/j2c6wwrakYtfViWCMoCT3T1VV
	t4uBSTfjdgmnA6CGZyIEK2GAlxAM642o1aZHR01pXGqf1cpwvT72L2ujRHRlvnD0lpB8=
X-Received: by 2002:a05:600c:6097:b0:456:302:6dc3 with SMTP id 5b1f17b1804b1-4562e3c4b98mr196621605e9.26.1753198795542;
        Tue, 22 Jul 2025 08:39:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrkg4gxbARCuQj3vafGP/BU7uT0jLAHHDQrZ/pOOEsCiRZnt7P6SzdJq8yMA4UuzgS9LM8bQ==
X-Received: by 2002:a05:600c:6097:b0:456:302:6dc3 with SMTP id 5b1f17b1804b1-4562e3c4b98mr196621245e9.26.1753198794985;
        Tue, 22 Jul 2025 08:39:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b74f9c0sm135998155e9.28.2025.07.22.08.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:39:54 -0700 (PDT)
Message-ID: <0ab2aebd-a43d-4ef2-a91e-10eae593de67@redhat.com>
Date: Tue, 22 Jul 2025 17:39:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 12/14] khugepaged: improve tracepoints for mTHP orders
To: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250714003207.113275-1-npache@redhat.com>
 <20250714003207.113275-13-npache@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250714003207.113275-13-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4VTQwU50DHvEFrA3kH22vEP21vqL1UmG1HfcFXtzsRI_1753198796
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E312F40003
X-Stat-Signature: o867zi44gkibnqd4ugf4xa6ybz7afx6k
X-HE-Tag: 1753198803-404239
X-HE-Meta: U2FsdGVkX1/7Hfd1weWUB8FA+bYm97pm71BSuKA/USlkdtPschZiEvHBnDjgg+Z5TaHl5iBazK+7+x/rsbagFC3r/sRw7qiP1Vshlf6+315lABAz+xb597vraf7RU32RikntkgRhvRAAzoCf9QhQy3f0j8OrxNnTGcjoNEYHPQNeYsxBdK1deVmJJnQQPhQtHWYxGBU8hAyj0n36coAzjKgFOA+HckqXFi7bXxafY+XuMutsgumsRp2b2z9FaLw2L0XFxDxuFvJvIRJA8kcvywGJIwH32ZZP0UgdMrbBB8K8wBuB2JhnubKnWK9/pVZiSRvWl0Vcii1iTCV+elvLn1lo4kTRKkKNcebUplOUQIciUG4Ji/CuYo5JOfhc1J8+V63Cav3nnUDpfg/Rvi5CcqgvV5KrAu+pV4+UPQyirs5LCB2N8VFiMqt4TFOgZ2OlAktnJFVeYpoQ7oczZ/sl/ILGSQ/xRNoAhzoTo7VuKHNYqeUacWlZGTN3phIBxCyM6drl+gfH4VYidEc7nnkySZT3y8y1/2jix5qZERbtfGNM4S+DfE7D8CcFGbgyvpZaJ6GRfrKMculp38K+yLf/imQNm/VGJapN3zomPVDp0mVOC0dAQTqvSq58ocuETA4RoRMfyZ0SU36u397VNGx1ycQZFtNWgpYGjH22SOQHDXHTr1KUVDxxAXEIyFJ13ORq6DWAePo1nG4VYDE9TqzlNJs3LkZJXFtUKAYLRdB9ZqNAgq5VuBXuqV5XSxBgqbU8npjGSdU0oQ+93JLPwXPuwhZMZhzmmqRJLkzuzTs+Oh7GmQS2MGSe3Cju1Ozb2NK6w2qhO9kzO7BG/JWl/t/YrJNXnMkoA1n/xbgAncZ97Y+lz/23xpajw3sss4SP1m62A7rBZi5ADAnQSXKN7Hrewe4Z3DmXejmN/ZKS5bL8cNojxEv93BBcmAYouFeNFBYCYBmSd0lIcRdyc+nsr/M
 JnyPx8sJ
 +aEITxkGpj7B0R84H4J1CE6Rdize2d/meguGAEMj1Kv+axicCRCvAppGHZhw/ia9JABOe8QUvcStfhZ14pJV9yv23riegKllTemkmzFQpiOqwj1+gsFC1pIlRth7n3F1YEt54xxiRqLVBkpmXpoWg6uXEjWmhbm5LLxjn+WDY/PIbDXq3fwcPljKYqwzFwQfUD8RLgktkpAXouuozX5h+oUaWgdN/CI0sOjC38UlW/GVbWfrBc1R/AEhx43Sox3llowWRElH0wnGHKy9XEIeMPhsYy8gkFaiSp6aCMsFHQjuRS3HEaAAwIHKMxsoq4dtESlYkGT+Bqi5rRPmidVeeynbRVkoFJGd3LDaSSOCMHK7O303aYpEiZdEMb+4N1mQ606Mank0pDQCbvxVqLRFwuX7zU32cf28p2lrZ96UVlJlWwI3dvjnY+mfeIkZnCri/CKKvdSwzWG2Ow7Eytg1cJNEtZbaL1QJanzccwMd05QOx0EC7id1RcGcGoEbDd6ebwHWHzuWmiDDFeZvwpXX2KvTK9D9meNsBcMU/FtxbOFwNl0CxwdwNImXuPS7JXCihDB1IeflK7TEk22M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.07.25 02:32, Nico Pache wrote:
> Add the order to the tracepoints to give better insight into what order
> is being operated at for khugepaged.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

[...]

>   
>   TRACE_EVENT(mm_collapse_huge_page_swapin,
>   
> -	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret),
> +	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret,
> +			int order),


Indentation.

[...]

> +++ b/mm/khugepaged.c
> @@ -711,13 +711,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   	} else {
>   		result = SCAN_SUCCEED;
>   		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -						    referenced, writable, result);
> +						    referenced, writable, result,
> +						    order);
>   		return result;
>   	}
>   out:
>   	release_pte_pages(pte, _pte, compound_pagelist);
>   	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -					    referenced, writable, result);
> +					    referenced, writable, result, order);
>   	return result;
>   }
>   
> @@ -1097,7 +1098,8 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>   
>   	result = SCAN_SUCCEED;
>   out:
> -	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
> +	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
> +						order);

Dito.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


