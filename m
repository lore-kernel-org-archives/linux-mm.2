Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5243CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58CA8E0006; Thu,  4 Sep 2025 05:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E024A8E0002; Thu,  4 Sep 2025 05:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA408E0006; Thu,  4 Sep 2025 05:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC1368E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:28:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64C291DD9C2
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:28:30 +0000 (UTC)
X-FDA: 83851042380.10.403CB6E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1272C140011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:28:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JiNys9ep;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756978108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqtVp+dWESwWsztacKgmL2rUMUmFFYmojnDpgO2tdkE=;
	b=QTGVaoM7CLWrNPK3Fgf8KikRpVjsLiUHYecUGVQKuTIAqLIiZE6PYJcOzQtvWyBIQUTuR4
	qoOBOQWuxwOBorGtmwLARFZ2uo1vLYBjpxmb6tEbp+52vvpHu8kLxHNPjd/gJeLXwxxZd4
	+bocdjcKt1FvkVYmR0HpRGrsBv6vcIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756978108; a=rsa-sha256;
	cv=none;
	b=rK8qmj5ZGeHoauNiMIdSpZvw1gTVd1mzSB/GN6/7xmV7oQxAEnjnQ7mjbIHpBTYqxkzAQO
	bw6o4LeRWLt8vdWzWhwmmXUH9kuDJNttxxeLylxqMQuaTdSeeYOpo4APWq8GSbkxzNF8/N
	BPExDSag5Lx4xZTMJsMRzVizkn6ORoM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JiNys9ep;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756978107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rqtVp+dWESwWsztacKgmL2rUMUmFFYmojnDpgO2tdkE=;
	b=JiNys9epNiYevvMizoilLaFkqjQ6IX3y1POh7NDCAdP+AbTF4eEMBVCvPNybnyJt7AaMLL
	+3PioFHOfVW2dhWw8N7uE7d68sMLFj2iz1/As54yoDYsHILfSai7N+54OIJCh20x+UyUQD
	b8+Y9UPHdEro5adnuu2DFSgXCqqVUJU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-eRJ2iOrvN2ylcj3wjQk4Lg-1; Thu, 04 Sep 2025 05:28:26 -0400
X-MC-Unique: eRJ2iOrvN2ylcj3wjQk4Lg-1
X-Mimecast-MFC-AGG-ID: eRJ2iOrvN2ylcj3wjQk4Lg_1756978105
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e2055ce94bso173812f8f.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 02:28:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756978105; x=1757582905;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rqtVp+dWESwWsztacKgmL2rUMUmFFYmojnDpgO2tdkE=;
        b=Pl+jAobhOh7LhamGDqT72qIule5xrV2LfpStFcr0T3NzUKWHOvh2P2l+3z2Nog0w3n
         kJi/u++x3VwoeqzRydORbQLIQ0tOi8QzwpAixJGjp/DaoHzvipvGQCITyQMMem04x724
         2Q5ERgIeqAJCkzjMD2FGVTBQMx6xE4v5WSTQecSkG57rFkrIzCpqP3JoJBHpkb8Js3BK
         wceEJ2eVjOKnT5/Q/t1Mc9GOcIR5il2TpaCKdwpiA/twiiaJO7IqwtLhqSU48k8YenQW
         SA+WN4d16ouiRiakKzv7VitEfFYg1cr62N2VzcIpNwHFalKZJ9IhGsrUSEqYAboBUEui
         sO5Q==
X-Gm-Message-State: AOJu0YwdWgCgin+sdyDNYsQXCWQtKASassSyMiSYi+BMBob/dQnAJ7T6
	7wEj9OA9aV+Am+NBtil1dojFSWV40zU9nQZvycsa7C32mBnc6z7Pmeg/t2p92vGRJoiJ3c9Zj29
	yHqW9uO9M73/LeISDx621niQakzJyi4sYjkYlIH7njZExbvgi0V1t
X-Gm-Gg: ASbGncups8rpc9MuiiRep2n58WJ2G+SgUaa/uGOftsk6YX8RLmw+eeoo612/RGQz3Bz
	xxpc8KORt4aIVcKwtbCi78CdkrVIASBfIBxUllHiy9mVfUJ0HPww2OMEA7/n1X1f9xD1n6P0/rT
	f0Ellz/J6isQdNHckNtv04yBGnNtvQIFw5fJi1EUoh+rE2/l4Nj1jI85zuKSJO4SOrCE1wA69fG
	sbUwS6kWO+B6qmErJDh1XSeqO8u64f3dS67e5RRVgkVlnI+iPn1X9+dcO2VXhKwVg3nLvcav965
	PnGU4ltfWM9DOprsuZ7D7zQgmPOzWlcInKVHf6hMe2HQUkV8pgeAI2FMPwi+a/1G9h7UtT53bcg
	Z6/8X3hgDRetMzSvSbhgE7l6eLY5C/rvDsE7LhB5RcV8dDdV9Z2T6ly1yWbNgF5Ob
X-Received: by 2002:a05:6000:178f:b0:3d6:fe34:1178 with SMTP id ffacd0b85a97d-3d6fe3416c6mr10383650f8f.27.1756978104567;
        Thu, 04 Sep 2025 02:28:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPjjpCqdHOizCp1x9jFe7gjDg5+srRLP3tm8qElUsk9XFS3CXOS6UY0v+F/eqM7CoYz+ymVQ==
X-Received: by 2002:a05:6000:178f:b0:3d6:fe34:1178 with SMTP id ffacd0b85a97d-3d6fe3416c6mr10383620f8f.27.1756978104124;
        Thu, 04 Sep 2025 02:28:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3df4fd372ccsm4936283f8f.32.2025.09.04.02.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 02:28:23 -0700 (PDT)
Message-ID: <21b8a9a7-b737-4ed6-9690-dfe07ee233b5@redhat.com>
Date: Thu, 4 Sep 2025 11:28:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-7-ryncsn@gmail.com>
 <c492b99e-b6fb-4da8-8055-1e93c6141a12@redhat.com>
 <CAMgjq7DAbMMmPVPqiGg_-2vghpPc9Jn8rkVNDFgq3reFx6CZtw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7DAbMMmPVPqiGg_-2vghpPc9Jn8rkVNDFgq3reFx6CZtw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zflddZWS-uMLc_nlbVLmE4PTcWD9wlYyTLaVk4rL8NQ_1756978105
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1272C140011
X-Stat-Signature: naeakxh547h6nsq89m3ebacqfzgsh74d
X-HE-Tag: 1756978107-613092
X-HE-Meta: U2FsdGVkX18ZDmQcGqVA0/zAK3pd7tW7A4LwMSDitb0XmGxkXAqKFw/PS4cHJK8kRJb/uCAKsZKWW3L4U9xI/L/K0O0chluNfqMkotMYLqL5lHDbNQU/CpZDZir7gcYSUPyB/wHi9hNFCfQHT/aNma39t2O7Gx2j85Hm6ELbgTEmYoAI2Uc/UW+t9iszSF52LWK+F+tZQzH+dvHc2T6bmEypaqpEe91wpKds7fN44Edt92MYgTLKPYgqohIsXNx2yPhKV8jHwzag+Vj9s2Mvgb+T0PKRBxMAmjVkvz723ND2OeTkXQBNrqqyDxVIHCmaNv2ErqZTnPNMtWCvBhhmZUkPtRERiZE3HNovhFt/wOgq35r7A3uFm/XBfY7y67/S8G2BOftVHBhUMYJ/gooF1AmHe4FCI4o/1ivJGK+y4cur07oa4CcIU0iRr8dCyDZNyOrW9LJNgWLAxYaucwKzHPGe1JCIbbYBvggS+0KLL5UGDC8R1DbZLmkcoue3dX45VRcs0KdR+qDyA4/Wq8mGNXQ+AWHMgGvI5DRs3d66AZ0xo2QE9nXctV4Dq4MPe2ltafUtMHz2riLd1H0C4srW9ZgHWKd4Bxaj0yHHVcuywBOiao3Cu75MHm9HJtrj4jwLPaat4UbDDdKKMzSG594TETJANYZvM5kwMeg2J149dLNFr5OfqzW0xSAMqQRHhAhzZ26qPJdnT6/VVnXFpJO16OyQo6dKIN/gniMoxH53OYCoerpAIWqw1r3Nt8/Ha5/hXGG7x48DM+LyMM7AH2wtcGffnqeR7gn2Tk4QHaM0eF1UmE7kUiQfpfrIFyS2yfxSvbraZ9sHdSF0EK8vfHCsfCGa4/q7EFfmwaadwP4lonsmqa/encoEWYidlSPxzl+VmGYjwx6Z/lhkUr7cIe0dAoxJVJi7dXotQeFkZxDHmydGhBW8c+RUfeXSB1OIv7NRzUutqNedk6Vqrjkqg6u
 QUWTWrJR
 HBzfAc7WUWGqJHw5kILwbqPb3hfmBOT73ESKfw4VAvymn0exlxd9lfQ1wBOx5Kn7tqI1rJgF95f7zKJVObC7q0W6LWDKJiXyen/jF95/ACRTNIHPYtP9ySWy9C3+HEig1oYlSktZ1XDY6L/S3iB73IEnHYSUhaIlV4+EarCtc58RlbNcNgx7J6rVeWuuPAEzdUANP1VY/a1J/E4iSS7pNaxoxkfJbYAVLs5E0xZaOKugWtQZ68GTXAhzHrg9pjFcGZf3fyle8Q51YsGdxHTuWPBjv+1UIMzNltP8bSLPnMEthMWw3DEZkCa85mAYQM8lbataoGoZA6LKokQzcgGUtwVGCAKKWxkyPnivT0RUxc3foQB7+RR80hTxOnoulYUeA38hz9bk4GqHIQuvHepiD1Ve32WwasHgf+Law+VWVFfKtIWhdhZFPQ2y5jjYMudMHAzSI6Qw4A9aslEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 2a47cd3bb649..209580d395a1 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3721,7 +3721,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>        /* Prevent deferred_split_scan() touching ->_refcount */
>>>        spin_lock(&ds_queue->split_queue_lock);
>>>        if (folio_ref_freeze(folio, 1 + extra_pins)) {
>>> -             struct address_space *swap_cache = NULL;
>>> +             struct swap_cluster_info *swp_ci = NULL;
>>
>> I'm wondering if we could also perform this change upfront, so we can ...
> 
> This one seems not very doable on itsown since the cluster idea wasn't
> used out side of swap before this patch..

I think there might be a way, but it's not that trivial. Anyhow, long 
story short, try to move as much as you that logically makes sense can 
out of this patch.

-- 
Cheers

David / dhildenb


