Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF85CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3ED8E000F; Mon,  8 Sep 2025 08:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D942F8E0003; Mon,  8 Sep 2025 08:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EB68E000F; Mon,  8 Sep 2025 08:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93268E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:30:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F8EB14012E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:30:11 +0000 (UTC)
X-FDA: 83866015422.20.37E3497
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E9EB40006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:30:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pkj2NyBS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757334609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAbu1qtNRXPF8YYyixaj0bXNlf5VN6++naM09nLWj/0=;
	b=DGHxTQjw7JOmYt2ll4+lYUPQ5sy4N6reCdCqqqDuo2n768FJIHD79Pd8JjkS4Cg1idA8mH
	p+bkZrzQLOGlucLu1yVfklvKSS9NlFz4CNcRZo7IDTMTGv7fNOQAFi2rQakqAOfs0VTd7d
	r0t+9Sg0OFwhXUcs9XfIrmUDFNdnqiU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pkj2NyBS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757334609; a=rsa-sha256;
	cv=none;
	b=CpOMj9HLkQNQBPqVi5U8SsZ6fkt+vBkdlU8tuVo1wW55k4q7qu8Zjrl3/4NncfHGmVvOQ8
	WUyzDuC25AC2VaDWbTiH2CwtsC099/w0JxRqTKPVB3K/LvglIIBHrr0WW/kMz5xom97EC3
	0MgEGYQbhF5rrUbq9gAj8TM4SxGtVP0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757334608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mAbu1qtNRXPF8YYyixaj0bXNlf5VN6++naM09nLWj/0=;
	b=Pkj2NyBSbaC2LhNk4WdBiH6wkE8j1GuhUuQ51Jgrp1SeLGGUUxYHcOel853QgoLRy2O7Hq
	AQuUmhHpRyJlOeeKKrhqPm0kaEyEIpPgph9gjrQneloX5Gn1IGwL8vrS1b3G+zKfukM2Ti
	aCy4ciqorFDpyi8aNWY0uNe0FdFxiJg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-oHVA-1q6NVOxYD5hquGeNQ-1; Mon, 08 Sep 2025 08:30:07 -0400
X-MC-Unique: oHVA-1q6NVOxYD5hquGeNQ-1
X-Mimecast-MFC-AGG-ID: oHVA-1q6NVOxYD5hquGeNQ_1757334606
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45ddbfd44aaso19669645e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757334606; x=1757939406;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mAbu1qtNRXPF8YYyixaj0bXNlf5VN6++naM09nLWj/0=;
        b=MRaEat/fzsSiOAwb8eyyy/1aIXo1WZwPCER1lfT7Pm3OtuRA70bumJCOYle5hVx2rb
         utbfj2JkIZ5UzzJzbKeKOlzsaKrfIopJnaHiu24Q8t4W70tT3HKA2U4S48WoZOiEWf+V
         PMkorVaLwPif1+h+ocLMIjLewrsqjUF65fW2L64/GNlfASD0ySNYP2Idz3KXCnU5KPH6
         tOQKnWMooh6x3skY4RavKTYVStnZVh/6TdlcwKLuaVZ6QBJ0JRotxifFhtJqiW2uOWf2
         jINXoAw1zo00AEijupZe+kSuocwPgBmi5IWkwPHXgfsqF9gm5pzx9iFBqT/w2+HVaJlW
         Q+iA==
X-Forwarded-Encrypted: i=1; AJvYcCUY3rXnalsDV9O9JVjj/9C7HEvtcAhZoqA32mpZAmYaiG/+dh6HGev+QZXJ7GM92Zb4D628ZUUaWw==@kvack.org
X-Gm-Message-State: AOJu0Yw9h0n5ObckMxvkjH46n9pk3G0ymVhqQhRq/tJK/otZ7VVBTz6J
	Fb3i0BFOhydSZOGcJJ4ETGH3f+lZlf8AxUYVuW2hycyWMLJ7ZyIRHW2zvp18UYo3mWBplBKctCq
	HgNEH+XzMW8jT2WXzz+XURL/xSgH6fq2lAgmERtsXRsIU0Pmpuqih
X-Gm-Gg: ASbGncvaaLP0ZPCrLPYAVDbwaaVBZkmVyzvHu9ZVoevUShbG4CWlrdZn/NRuB6/tOJv
	JWA/TUgXq4c4htCKvaUDzC+oY0EsrJKlsUOl6tGRsuXRXY0k4T4MpBjBl7hLwnNQZK+tAo57+F8
	2EVDx922cBNwIuYIkWpturs2XEFy/fvVgI3CpBSZwZxvd8EJ87ej378Zr3xjKyG+fnhaBCd/kVL
	qYSS3svyD9KGFbVJwkzCfeOWyO3jemfVqD0pxzQCdWB23WdhaeiojWNcWEjy2Plx+13rL9/P3I0
	sP+Sy85484rkaTOyHv+1MWGEz0007mRowfBic4VQJV7y3TlDThVIWzEgMUhk1xqmU5ryJpDgbkl
	dOE2fzvQc+wNrvQuqCpN+7slx0zYkTh79hi3/LBjgPndp/fBg5j4KfQq7WTsaMtYg
X-Received: by 2002:a5d:64e7:0:b0:3da:e7d7:f1ec with SMTP id ffacd0b85a97d-3e646257889mr6040230f8f.32.1757334606067;
        Mon, 08 Sep 2025 05:30:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPQ5u6lrJW7FYhM5BnRr+Yf5LHURy0+3MyMH+KFiHP7c+8mYlMSKgheCV33eJ2ujN2PhjoPw==
X-Received: by 2002:a5d:64e7:0:b0:3da:e7d7:f1ec with SMTP id ffacd0b85a97d-3e646257889mr6040206f8f.32.1757334605599;
        Mon, 08 Sep 2025 05:30:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd2df4c8dsm171493185e9.15.2025.09.08.05.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:30:05 -0700 (PDT)
Message-ID: <c2ff433c-35d4-45e4-bf06-e725726fa515@redhat.com>
Date: Mon, 8 Sep 2025 14:30:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a
 helper
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-11-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905191357.78298-11-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F3QFGr6f6vhJfpQ5wx84plvaQlRfXLcsttn2qxyBxDk_1757334606
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E9EB40006
X-Stat-Signature: ehaxab4yefz44gci7ajdrax67xwq9mpd
X-Rspam-User: 
X-HE-Tag: 1757334608-534671
X-HE-Meta: U2FsdGVkX1/aPDSu9zUMd69cxvhhsouyMX22zD3nSItA/pJ3u2uHZjLv8gzuv4yuJyFJFzN9M6tySzGcso++vKx0MFQGjugiA+pDxM+cxNkzTyLseY+SPTNXi799I92BFNv1VdE0AsG9cwhZB0RF+VxzAD3z1RpinAbWVV//fYomJPQE/GeT+oC+udkld1PKboPcylEOOYGMbsgTEH6ZPoq5xr2OJDF/TURIgWxJ4cWhlGCUJ0hgAsoXgz9ReS6WkhLtUodYroZvbH4KlhPPAQs0UlcLsgLPqtFuybG54t5hfTdCVOVo7D8CwWGvGAqAdlyc4q/brR7amyZZFRu8vr8Y3ygwWy/80FnSdPb5PkBKwD1M6iWS3S6YZXRF0MKk2OstkM9yVzVCT0zMiFRShN0drU2j5jujPd84knSKIAnr7UEfQeM1ySFGzpw6llhMxim9+9ZCLcgGgmY88jhfIqtS7ao6y2OcnGTQL6tE7oTAGbEtDBVQwtqizNnYVXixhZMZpBMQRGzjhwMbFGV+p/1grEkz9cHTu9e608gOaQViwcU33LgNjoYycuZsiyOARGRcMYIMVCkpFgkplkOBFO3FG/8Ort4DB2+TYXMdPxgFSJ0hZFSrx4GJtymWFxgr2z54tic6v7PXxiQk102AjzGeCnDtz2mrpFj8cvdf5fIWJRdE4UYfvIP5xAjQVKFPNRCZKJBZ1JzjjXRIxpPc9mmdIVAFBT/en5oS1eVRQ3T64nd8K1D4Ivp5/la8GJSxkQOgiVUsidsLTtGzVnfKOn8vq+oZ9UN2Ifuk4cruiodganBnPbiUdUGXAXxoKnz8cn//6KiDJq23sLg1ZeVvmybIaMJ+PGVtlDFHFRTUD7kjhy49jpxP/+dY+qS3w1ZaUNIvfwoWsotI+DwmVpGflNRwpcASL4fbQgP9twTrgZCZq8ao49aOQS6YoHJpT9F0DbRkZODI4GChxqnJHAG
 s1mvF9AY
 oYlInfBXm0An82IciwafFA6BmyKgLavse29Ms3Z7GaoEb4sUuWfViO6fkepA1bMPb8YVlCa4iLaXGTskBvOmSKHL8kp21wHXx+JDwMPASwA/KN8n5kXQ1CI4aA4I/zPo434q1d2ZTNo2ONilpoi0EupjvCgILGN0lqC7qkV/d8FthjdN7DwhwudyhKjdJOSHXX7+JnWvc9cDvIVDYdfDnBLPPuo9TFGEihe5mJYBYeV526VULnkk7yG1khPolCzWHcNbYRAu+TZwPYEFHePD7l2BgN9kb7LPJtSB+W+bN0W8hXvxsLqrxewETzJPkHVklZyAILbRLxEqSdI9RGMCLHGL7jiHr/dn8L6jHfLOgwZpOZ5UyJT2SaB4ySkQksQ2VGPTpntIlXbF6OMVdzaw/EOQIRO9S8d+IZ27R6UHQKS7qRnR024yPLr+zNCdpSaM9yE1kPmNrR24PtYwaBRvLPT2+Nit3wb1Wwh+c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>   
> +/**
> + * __swap_cache_replace_folio - Replace a folio in the swap cache.
> + * @mapping: Swap mapping address space.
> + * @entry: The first swap entry that the new folio corresponds to.
> + * @old: The old folio to be replaced.
> + * @new: The new folio.
> + *
> + * Replace a existing folio in the swap cache with a new folio.
> + *
> + * Context: Caller must ensure both folios are locked, and lock the
> + * swap address_space that holds the entries to be replaced.
> + */
> +void __swap_cache_replace_folio(struct address_space *mapping,
> +				swp_entry_t entry,
> +				struct folio *old, struct folio *new)

Can't we just use "new->swap.val" directly and avoid passing in the 
entry, documenting that new->swap.val must be setup properly in advance?

Similarly, can't we obtain "mapping" from new?

-- 
Cheers

David / dhildenb


