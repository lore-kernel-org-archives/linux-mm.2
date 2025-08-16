Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C97DCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132E190025E; Sat, 16 Aug 2025 02:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B178E000B; Sat, 16 Aug 2025 02:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0213790025E; Sat, 16 Aug 2025 02:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E47718E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:32:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97071116F95
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:32:30 +0000 (UTC)
X-FDA: 83781651660.05.61B6CC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 55B3220004
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:32:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VzDFyDMT;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755325948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfYakrmDEwMuGxlRf7o7XtZykiYhmHT/h/2wZuof0q4=;
	b=zZ7hHYaIXm5eLGxe/jM0WU2P1mOKnDWESD308/bUY0ILh64k1FjftO6a7cj9Or5Lg1aECW
	0mbH3qMSNrBif7ndt51tlKlqFklQ0gJHuyLJGqDZoUs8wQP9Fbl8NAi9MenKiDmBUNGXTT
	XEe6iOaO3enM8iHWMUNf1PIQ/N0iCS4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755325948; a=rsa-sha256;
	cv=none;
	b=O4AAjPdPK4albwTmni6Fm9Vbz9T19gBEhSygCfTgOdLJuG7CNY76YzF9ahVTHqJFtyTOB8
	8CBWdn7zDtslazikoavs8Fn5LqOi4Rq5EhzaCJwK87kr4aeOBiDoE8izXyQUT2m35MIXLo
	bbxzy3iz/LZc6l6iefxxn8gpFovsgng=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VzDFyDMT;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755325947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RfYakrmDEwMuGxlRf7o7XtZykiYhmHT/h/2wZuof0q4=;
	b=VzDFyDMTumvJvtz57z0SDxDv0IFkdh3uvt+0BNTFkZbHF7dSk49ket7f9eR35zbhRhdVX1
	fzGPxc3s8oY8OKkXhtqon0tcX2jKpvrceAfnJRTOyDJVr+THXN9dSxcXOiQnW3NVHyamNg
	v8jr0VvaBBoSZzHWCzoMpCrCxdwQRbU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-YALGt9_zMNW7oA4szlXtfA-1; Sat, 16 Aug 2025 02:32:23 -0400
X-MC-Unique: YALGt9_zMNW7oA4szlXtfA-1
X-Mimecast-MFC-AGG-ID: YALGt9_zMNW7oA4szlXtfA_1755325942
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9e4146aa2so1420222f8f.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755325942; x=1755930742;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RfYakrmDEwMuGxlRf7o7XtZykiYhmHT/h/2wZuof0q4=;
        b=CWu60w+VPHGY4MaMhugeAmrZpD1VrplzI+gWYA2TUyTK0y0XUvcdRWKY00Rsv/flxt
         XMTzz8F4bp9FxC9AhBrmQygj3znkyFlHNF+nXWT4721t2hbjTp9UA6U9EhzxjgxXtoAe
         fFYWZtwquI/5Mdhdz96FuO7tNsKpRNbCnNA+HC7REA7CgXb+hzITSZa/N7OybkvR6twX
         7VQ7sTv8vx7aIELDOT/NN1//Lt4QnyvZ5a1yDoBArDsHqYktO0bdguDldYZbybG+tCT/
         EDBHqRTCUEaGW+hiTjQITBGPVoTiJh788u56YoGQ7URCYoX6sQrHDqbtx66qk5IOwoGC
         z7mA==
X-Gm-Message-State: AOJu0YxQz17MmrD/m5YhqmceOwXLgOnhtIKEAQzLMgPmIVDL0q+b0giu
	tBsFOejk+wmc3x0+ZxKkFfApXcj9bOi1LSKUvPjjj6Y6RKWHo6s9I/YtjToG1gDDtP4ZJsMI/oq
	HJTmif1jFkbFIxULYbUfbwmLPIvxs5mo6oSzEBCE3BAGzY4DiA7PF
X-Gm-Gg: ASbGnctK2QFwcdxLqtz1+s3Hq2KgXdRat5OJ/WrZX6JDUbgbNwtMd8dTEXil8YCIG0k
	q3HumRfTFIZspRiEa7VbRHlmyOZbUF13Tz9CIC8c8LaBj/OC8u3Qm4o+21GMepA3QdH0jI4CVrj
	TExzR2cKY7ZDYNzYL7UKZRsSRd2zs6kSfswVmAX7RcpoDByQ3UKiLdTqhbf5s6kmgKdndLIGWBU
	7umznT+bUGa1tQgl6EOPq1yMlo+mbrn7/3CpoMQ6RKuJRYWuWl9wdvH/n8DyxEetvrx91mhZpXR
	WHfX/hGubBTMD6nYUQn1wAd3RyOqSoG3FZkNsBCQekzUym8qiGjrgHG3deyRd0RN4dRoACGX9Dp
	TU+Ad6yvbb3hJ4gG4R7wT7GOkRXlVeUG6divKRAWoZKkJKxwe6lMo55tgtqEEBAP/YqE=
X-Received: by 2002:a05:600c:358e:b0:459:dfa8:b854 with SMTP id 5b1f17b1804b1-45a2395a8c9mr30529305e9.5.1755325941923;
        Fri, 15 Aug 2025 23:32:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYohcjgkTvBdR4s32I5kXSbQJjF4MDLL2iMOi/C70W+VNhrgl1v8jooHP7XC8mFHqWH/c4Nw==
X-Received: by 2002:a05:600c:358e:b0:459:dfa8:b854 with SMTP id 5b1f17b1804b1-45a2395a8c9mr30529105e9.5.1755325941481;
        Fri, 15 Aug 2025 23:32:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2232fea4sm44478985e9.28.2025.08.15.23.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:32:20 -0700 (PDT)
Message-ID: <ef8fd826-3abc-4c63-b25a-93eed18ed0b9@redhat.com>
Date: Sat, 16 Aug 2025 08:32:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/rmap: use folio_large_nr_pages() when we are sure
 it is a large folio
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, harry.yoo@oracle.com
Cc: linux-mm@kvack.org
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-4-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815084943.23063-4-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eXskZ5CVcO9cSe4yHu6WIWMf4oMvLFKoZQFzNTFzpK4_1755325942
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55B3220004
X-Stat-Signature: dh3wpxei1ea7k87xehw946q7uki51gy7
X-HE-Tag: 1755325948-935065
X-HE-Meta: U2FsdGVkX18F2D9BJhE7p+FzD/T2hi+uqE+uVtO/oZK6DVv58BBpUmsWqmFwouKyxO6ni/0N9T3JVaO58KzVUu5q7D2PnA2sFdRBJDQvpdqHwm+tcgwvgjR2NNJcmXfCIQ8DzDgOYLY9hmDwXA319yIkEuRSjQC6l3GRKAll89vKNd+yZdZgGLO1T4RoHMqM9IRfYVqmH3U7LztncOVyRZ2qa2czdq4oMWUpUJQsVl+ShRiDGy8fyeGgE9V43UE+XNFyTSqeQ6T8Afiv0mtCxxi8Wjfc8ifhgBRimKqxBDVfmxXn0+3P0UtLsJF5hw0G0o645Ox4tVwpGpXC2kuN0omep2ynPH20Wg5ayVLJAdjiPFJ1DXgmO0dv48TszAhJ0OfGwLc2ol/wUYSp24pXYL1OOfB7FPbt5+3FoL3Ar9vlmM43QL4pVBVfA43DLJ3eubxeLsjYeDxOFTZTsDbPc2CWBYARbs5N/vbP3s3qg2/lvnZyE2dwHkqC48/UY5xpfvnQW3jj0NH1T5Y4krndtiVjYiaU8ObEfAuRy864Fre+TNlPWb8hBBc0cQ/60/FIrUP6NdXy14+9aphTOAfSL6/k7vv8249VRdd2U+4fo7PE9huLsDaOKGO8tuSyV2fiZRIzravUP3nPSb9C22ehy6LLxYHKEKxz9EZG/aWxMy4dCT7WVBTxfa4xeqdioHU9xFrGZJyJQFaJIG8sAGga3C28Ct9t4TAXS7G5+w2JeFpiz9nhF015NS4N/Itx8HuKTgxILWMrLeB/iluCK71dEcupVv54uYEbySgV+JF6mwCf8oepUO9b3zJ3z+f9EM+cYjX+v/GiBFjCfeBhvTg+8shXO8nUlhsSeEc2kYlriIwRXdipGNaZ9WzcpHt3BJ3DANLDdR20X1Zo/A5M9CGKq84bWfGwTDCzzE15QBDsPr9yFOyTx6la+Vg3IUkGkoQOq2dkmPOZrzKIMn40vvu
 7YjWT+zI
 orcBUS1sMV/piB+ZK3M/QiAqB2oHfMIt99gpGh+BRY2hnkBgYAyDUPOGhiyo9EyFob/ACK3ulXWo2ud3vI+Yla4ls/i4DYMNidpLDJ6tbnzHFtLFzfY2SodoD3297b2RZ8Sh8IalZ1q0SLRKa37fxVPhrJpCFJz5fsbdT5fO8douwG1XhIFE9hYONjTTsdMcJqamql4eXClRJsbBc/V3XiVUFGRUO/QsltCvveFwr0aPxp74zTtAB8oiqPUyG6Z2BI1b2dsCBauCpAsiUg71R2fWfyl9g9x5OVOJ/lGg2pBKgCopfn7Ruc5FXPbp43R98chCwb56boL8XoQLmabhV7LWuL/PBAGf9v34KfdJcF63Q7VzjSwgKLUwuMbtpMI5QSulLMYZ7aQECL24/s3+fz5+lFaIZh84DcEXPmhZm7JIRVWwDDRMwEkrJrsSyhwH82LMujhjo9UEzBwDQ7y1oxlxjym7rZs9v1h9W+VI0UfZzxy+IiFcE6GVL8RGFxPZvM1wOn/31IqlWCW0OzXOrbEOq7GWvWXuK2VB2Hgx0vdcfe3eg2elByK6DwQu56bPS1DZDokyhO2tJ7XiS/QyZtLDXBwKB7JP0axlNUq62VDTZWSWkWM4NDVMu5m0H53n73NZTHoka0nUj/ygngufnmo3C8c5fmTwM7PAv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 10:49, Wei Yang wrote:
> Non-large folio is handled at the beginning, so it is a large folio for
> sure.
> 
> Use folio_large_nr_pages() here like elsewhere.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


