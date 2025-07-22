Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA08EC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7B16B00AE; Tue, 22 Jul 2025 11:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF5B6B00AF; Tue, 22 Jul 2025 11:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4EE6B00B0; Tue, 22 Jul 2025 11:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3EF6B00AE
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:34:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B8411A041D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:34:15 +0000 (UTC)
X-FDA: 83692296870.06.1CF96EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9780CC000D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:34:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ca5g+ehT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753198452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFJzlzQIrZrtr5g5RWp1FU4rUmvP4NLit2nxv1lBD8w=;
	b=VAI8xaYICtSc+/naZeCJV2g8mHQc2rk3cCmMmYiUUn/hJhxLuGEdHwm0cs+UEUATeThxq2
	oYiPgnrhEqv3JSZPS5kXdgr5fNJck+hG86XL/hL4FtqR6xy5GiK19+oYfPakiqTpoO8yDv
	VJ6jtmIVVfmsC5/dJ0rm0RTulnz4m14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753198452; a=rsa-sha256;
	cv=none;
	b=1EOgAEQfW0tfSjfH+70L0IMer8bAFdbidGcV3juNnCtpugDRnqSWsiA8SSFbjUODhxaxEP
	wlkKtZKbpI9SwB4/F2H15GlsLR1uyh7DYmQ7RpUzPXF0UpK+v/6GWLsfmiAfeJRQkefuED
	oid+niVQxv9yvwhDItnuV0U8bLZZikw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ca5g+ehT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753198451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NFJzlzQIrZrtr5g5RWp1FU4rUmvP4NLit2nxv1lBD8w=;
	b=Ca5g+ehTuhfKoHLbK2KfYcgLDSrGsWttKRvah1J11oxaxCctDKjw050dWhB4FgFZE9gB1K
	qTdSVNsBsKCEep6z2kzmP9baKC+lrhqwB5mRzgaKuJUQndgaEABqcZxD8iVZZkgWMXaK4F
	TDm/Ks3Ycs/d/9Oa0Q/tkzNNI2orc4A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-v0_sVrPFNP-C8xoOfMj0uw-1; Tue, 22 Jul 2025 11:34:10 -0400
X-MC-Unique: v0_sVrPFNP-C8xoOfMj0uw-1
X-Mimecast-MFC-AGG-ID: v0_sVrPFNP-C8xoOfMj0uw_1753198449
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4eee2398bso2354268f8f.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753198449; x=1753803249;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NFJzlzQIrZrtr5g5RWp1FU4rUmvP4NLit2nxv1lBD8w=;
        b=jCrJgoYvNt+r7lxC+S7k5M0tY17JkV2xGQKmlF55fZKZUTIa/SNDT3Is7l+c2WuR0w
         XMF2sBKbm8E6UYqath9F0DP9texX2yUu3cFbQmODdNcyQ+TPpzStYp/LiRrxY4aZuFFx
         +RG7sWDldA+qObaWTochP4Alc5oqdpleJMsMkO1vj7vgaoFqI8shaQcbU9KrHdjRtmts
         t6MgBT7APgJ/K6SLdqhqJeT0bnPZ9e2s9gBd9vmEdOOAbtAB/6zQFQfTpp9Y62BiuTSF
         CmoYOKDgkuKUGkL3qYyDEda7htYzuAj+a3imArfqNbPCD+nHr8i7Im3JFWZIdHPFwUbu
         gJPw==
X-Forwarded-Encrypted: i=1; AJvYcCXvUgnC6gHyip0cxwtY/NyOwTeX89HlvU+YmAuRWwltfKlYt8TOEblq7EdUhaXd8Ni0Axc7XRZnqw==@kvack.org
X-Gm-Message-State: AOJu0Yy+sAI2NlWyFDvPJXQzeARxsLRKMlocsXkU9WzcYDdRhBuQREjf
	krfcEzJADy12IULonXD5bQ4F1B8E8LkC/GHQuEDAkcGefFpHLJtkdYeZEz8G4HDSVaWZ4r791t4
	dzo1acr0Z6eEs8Gv3j022Oaw/3B4vZhzboAx5hQdAirdpJeCMvL9K
X-Gm-Gg: ASbGnctcudSGM/StyG92zSGzp049eP6GTxFSLD73J8WU1Fmikw3BA7m87NIzUJ3JX5r
	IpoC38XaFqZXv77U70NSGhLZh1kXbk2fdZNS+e2UbuRC2balYlIvmTRwa2S7e2sna1gcq0Ds6Qk
	KRby5UUN6YdCqhB84fyydVe4I+bQILwrdZOuhha5duhDg6YOiSG4geXRwqrLNymGrAAUc3mz5m3
	blUKOOEG2N2ze3lmpaN9aoyowneVSMxnclLBWVaBTeFxJdGmvIUS01aUmR7bTUNhVJQBaFsxYyj
	ab2eyi30z1hPmYPPMJvdOEiaEeo6f+IcL0BXBzMKFBeiAeAHQyeb9RIUSioOAk1rjIhreBGe9iL
	vNmlNbMD29zkG/9WvEpWiDckL22zWtr3w0d08Hi2fR1tCApPA1poqtVuq8T0RcZD+Dxc=
X-Received: by 2002:a05:6000:18a4:b0:3aa:c95b:d1d9 with SMTP id ffacd0b85a97d-3b60dd643f2mr16706211f8f.6.1753198449299;
        Tue, 22 Jul 2025 08:34:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6zAHly2HfsHo0ZiS36DMz5VnskMV4roAjV49lglrClLRujakCNo+BgOMzFbCL+20f0T3bJw==
X-Received: by 2002:a05:6000:18a4:b0:3aa:c95b:d1d9 with SMTP id ffacd0b85a97d-3b60dd643f2mr16706173f8f.6.1753198448759;
        Tue, 22 Jul 2025 08:34:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca25678sm13586321f8f.12.2025.07.22.08.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:34:08 -0700 (PDT)
Message-ID: <5c46c13a-d558-475d-88ef-44b9ed8519f0@redhat.com>
Date: Tue, 22 Jul 2025 17:34:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/6] mm/huge_memory: convert VM_BUG* to VM_WARN* in
 __folio_split.
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dan Carpenter <dan.carpenter@linaro.org>,
 Antonio Quartulli <antonio@mandelbit.com>, Hugh Dickins <hughd@google.com>,
 Kirill Shutemov <k.shutemov@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Balbir Singh <balbirs@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, linux-kernel@vger.kernel.org
References: <20250718183720.4054515-1-ziy@nvidia.com>
 <20250718183720.4054515-5-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250718183720.4054515-5-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aKH7DD_cjxsU-HDqusoSB_Oe1YOMKTWTRN-fnwaqCvE_1753198449
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9780CC000D
X-Stat-Signature: 8qahzo4ihisnfz4jmadg4uqjrs1ncf85
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753198452-699759
X-HE-Meta: U2FsdGVkX1/NqRJKp5sgnmG/BlcDxni1Hde8BzVCyEvHSmS684axMgNqaZV9aOilS6RbpVaJ4KJYNjNZx4P2kYSanrLJGcUggjujCVy75PkcuWP4gVGJHdqG8vYCyBBbb22A8kZSoSrqrEJB2tbdOnEArh7wkvDg2RAGdFRc+KRZOTcoso4mjKrQbNh732cGTk/V3EIRjZNM7EJxb9ZZj+SvwPIOHo9G2SOUBDuq+uFzHitT+0Fw3WXZ22j0iw6qvJXpKmvXkQC8tK7K+07g0/dMBOhKq5kRuFcW6KyLjyDtrXtOuTnTnWA+uBesvRWYQmS6IetAr728U0AiY3Dd0SUu2Fth8CtVfMjCXkdfv5hNWh9dHi39jaoVJYj5MchSSh0cv6oM/bm7l2G44no/FNIC+//Moamgf/4yDxc1mHHOe0AOIjMMv+Maob3kuRvPdB38240vCjl3EJ//tCCCOpC5rrExpCARDPpu0ekH2mNtlmWRZQTqOTLJ9Ukrudae3H3K0m0vii3yT3aZca5oFWR5PAc9xZRe1BiW5b8R1tknr283A5YgrQ7kv18U0cyAEdoofZQvH4WM/BbQva2Mt0yTpmpJ8P272xqiuhfGx4hVVJepEUm49FGcTloFR61U9XjBPGXyJcbu9Tcae+I/azQCGWJDQPynee9VNdEg2k/by8h+CubjM1EKlPVQs7682E4JzP/U2EDdk6StC/WdToYHEqEM2d8CfbJqLK8gQmX0UdONYBO/IncgkpiXQnq8F7KYQifJgs5gS/GeZDTTDi2nUCcwqXvVoKah5uANtMbqME6th2m2sv+wu1woZzwBIbEwQNEzyefbb0vASJ6jCq9sjlmL6f7aJzoHtCPdl7mIOhU7DVNmhwzzrT9ATmWQcGXeqX68izQGjBHvTPJQFvfilDAfckWYTh9EUF9h53x6sQANJisxHmachp/IiDApcxl4W+IsUW7vgaBvp5l
 Kce4umR6
 uU54v5wn9rd3vOAANqE0LWBxps8+XaauIxkHROixSRc3YX1mCDDoe4aW883xWHvQ8Fpy63mkO187g5FbyASsTTtFiGRi8WLSuBvDX7pv+EeG2kCELzPlT4azD60jXLdL8RyXGYgzuYmL0f+K2OwG0ntK0wJDk7PvN16sLwW8Q9113YmXfF9ZeO04ZOkszEQEdxL248zFE4s3T1DikDLWkuuSXkKQoO7Nb0+XCWLRgTjsvzf4cf7TfucEfHeLJqohxYX+ygm3Mj2BDK6WPNfBCoXyYit5kq7nqGvul3TmVf8G8E11AkmupKg+vdIfcO+XkaZIzQK5aVEVGtoHR5jYr8c0Hv98yXmgkXRpHHodb218WYxmyAKrnfLPfpq2Va7DyaEVs7tBbbsBJLD7bnK95fc1eGRmjfd0Qr5ZyAMN5hrwojH6OPLIvvj/PLEiXXjLBNSsbKv5m5QWlg/ebSjn3fApD3FEWDYdhD+VOaajPEcQHfA6VKD3lcOAAP1iPSIgIEqgQy8nA8YboB44IpFaVpRZuD/kmWMPgR0qwPdBgz7dVdkStfM5wqLkmClo2RHPLtC3JTpojjpdUp56DWByQOzzf52cKHeixTjw0yAd7JAUd0rk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.07.25 20:37, Zi Yan wrote:
> These VM_BUG* can be handled gracefully without crashing kernel.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   mm/huge_memory.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d36f7bdaeb38..d98283164eda 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3601,8 +3601,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   	pgoff_t end;
>   	bool is_hzp;
>   
> -	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> -	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>   
>   	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
>   		return -EINVAL;
> @@ -3766,7 +3766,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   		}
>   
>   		if (folio_test_swapcache(folio)) {
> -			VM_BUG_ON(mapping);
> +			if (mapping) {
> +				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
> +				ret = -EINVAL;
> +				goto fail;
> +			}
>   
>   			swap_cache = swap_address_space(folio->swap);
>   			xa_lock(&swap_cache->i_pages);


Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


