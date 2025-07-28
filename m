Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8919DC87FCB
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 13:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53E86B0088; Mon, 28 Jul 2025 09:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04CC6B0089; Mon, 28 Jul 2025 09:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC9A6B008A; Mon, 28 Jul 2025 09:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 898A86B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:28:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 219B91D8B76
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:28:51 +0000 (UTC)
X-FDA: 83713753662.01.FC31640
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id A93A81C0012
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:28:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cisC2RQ4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753709328; a=rsa-sha256;
	cv=none;
	b=LANgy5Rp2YVCTcPmOmSHx2oV4zy35JgxLbceIL1JYqLnr5Y5u4SY662l46KFIKoCe9iQ1N
	uCalLRl2SkYaBp0VsxbEBJqfK0eT6ktFGkZOX02MufcJRh697M5MnfxGx6XsrMuVnfqnr3
	XM0vUtqIHm2Bvfjhmks6NAZ6Q9nnDBA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cisC2RQ4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753709328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Le65crWkL2r0S+fv/QPgs84i+1vkmflDFPmUD2ynLfM=;
	b=QKj879Ff/ooSckNJP9+luMUMHsy6vT/t3ABAwRaqXNbSNiOXYpxnzRTctvBdlQvfaz1fHl
	/4b895/Pdw6Yfztya6Lx0zWa8p9ctYPPIMkpC/T0SPCf/7rUaTG/48GZeQXsjrWPQf3n3H
	fOJfHhzbuvFFzZh/0gyXqF161wFk0DE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753709328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Le65crWkL2r0S+fv/QPgs84i+1vkmflDFPmUD2ynLfM=;
	b=cisC2RQ427Q03SUBhXnvlXYrVQJ8rFpN/C0YkOIK34AeLNdNNR6yoFZOaN/GYK71Mr0xBg
	2Qb27pZZlO0YbPSihza7K377kGIUHDMZyPUIM2Bq6NJNOKqRTM0tdMmn9+oSNKm2QrNhRb
	N3fwamXtDGJbEinYWAfYvreZ8+kK9Wg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-uNkVw68fO96pJoOudBQeCw-1; Mon, 28 Jul 2025 09:28:46 -0400
X-MC-Unique: uNkVw68fO96pJoOudBQeCw-1
X-Mimecast-MFC-AGG-ID: uNkVw68fO96pJoOudBQeCw_1753709324
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so17145695e9.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753709324; x=1754314124;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Le65crWkL2r0S+fv/QPgs84i+1vkmflDFPmUD2ynLfM=;
        b=LlOTpLOt9W+c75UXT3w6KUUY1rC78VLezVQhjn1sKkCJQBQCfrv22pqPrlKLUo7RtK
         kBDZbOsEpaBRe4jHC6bfbjjgNvPvNoU7PtGhq+kld43s9LkoaJuHIiKxJneNvetJIG1K
         dQM6pnHKglT2GsSLW51AsBb38v3/0N5HaXpx1g5Li5nG35yx8ncJl7CtsAJZJqoK6nrX
         MeO+RK0pBRd0IDqHTK8Pa8r/JSpH+rSuXFqF+V9YfBplFM6wrwaq4S/DHXjwQiq4nwXc
         4B6+NIfTv6XHAFdvvlHCybSVK4mElWYZFBK6TbdB57aQZWl9mrbGKlnc7XEaWgZo+frD
         pwNg==
X-Forwarded-Encrypted: i=1; AJvYcCULYMyUeYgP1gxnQ6sUniWoFrn9uf9h7meJYUUbKQHBxbZIAIYRpPbQhbreK+O26EZHfpVbW3AHtA==@kvack.org
X-Gm-Message-State: AOJu0Yziw/d5uSetkAEFrbOQUQ18ybpI21PVUFJ2uHfnybeUdV1dpXwq
	iQZyX87LswR78pRwWf/RGhlMOR8kJV3V2EBJgJ2FF7fOvgjkGxvVti7JPHLU16RbRcjzUDXCWpv
	ot6hD4AWATqPPxUCGcNaMPefjos2FwmYNkmoFRpJi+qFacX5yIp8N
X-Gm-Gg: ASbGncu5+ByN1zASM+42+ZOZbftmv7gcAu2Y4lrNQOCMwxwmmU3Rl0imgOnnVguG0re
	1kRxXBWH6CtjQ2zjBerVgZczCGzcVE3HEVdVzoRzjtE+o+XNvdfpj82EhPmCNwg7ZP/MaGnWtvz
	68gHgucFaitreD5M+UHjSwUlPn7HaXM2aFcRSxszL9KmWOBarj/EGgE03uuhZbWoeU+dKUAr2aJ
	9y1pPZG+2EE1PtGoayuyoe/F5ar+9euahGtx5LYGKKFq34TP1OL6F6dNnZq11ULlRnDfUUR7DMG
	Cb84MuaGEA/s8oNkrVlIIfkBvfPNgzkpMYOk7epfmJYt12gbKTwyFvWe61aDTn5T0rX7DDt8JB5
	5Qq56magQrjNSnJ9vA8V73ZkHpKnI/jkq5ep3wU3WejXw7NfGzJ3uGHPri1Q8eTxinVE=
X-Received: by 2002:a05:600c:821a:b0:450:d37d:7c with SMTP id 5b1f17b1804b1-45876447cfamr87418085e9.21.1753709324275;
        Mon, 28 Jul 2025 06:28:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsVPv+MWr7O6tN7PNmT8Q2J8IDZY4LgEZaJPbBaAXxPD+wuoWYfzqkdrvfI0jOOB8Ha1wgzg==
X-Received: by 2002:a05:600c:821a:b0:450:d37d:7c with SMTP id 5b1f17b1804b1-45876447cfamr87417625e9.21.1753709323785;
        Mon, 28 Jul 2025 06:28:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705377f0sm156708195e9.6.2025.07.28.06.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 06:28:43 -0700 (PDT)
Message-ID: <e83ac8e3-06fa-4ccb-95e5-4f95ba5aba7b@redhat.com>
Date: Mon, 28 Jul 2025 15:28:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm/huge_memory: convert "tva_flags" to "enum
 tva_type" for thp_vma_allowable_order*()
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
 <20250725162258.1043176-3-usamaarif642@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250725162258.1043176-3-usamaarif642@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BldrAsMTRqoe02Ku51AM_-OmHRNDpxFJzsppvUIL7rY_1753709324
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yedigktbc5f7a8jf9rp1tn6i7xqdxmwx
X-Rspam-User: 
X-Rspamd-Queue-Id: A93A81C0012
X-Rspamd-Server: rspam02
X-HE-Tag: 1753709328-17897
X-HE-Meta: U2FsdGVkX1+mktFpy8VzqA+JWY5UjDYFm7jo5+Nj91etNyLXbe6bVz0g4yRwb9JHbPE3RxvDp1mJa+FMyh8Yznbxmlf2vL8hbTuJWIkqIveECgK3O0lITP4BdxD9V8ysY8swQ1NhuokgebdrV4UnPH1Mka8aYxM3wMP7HZ5tkJj4O8Ou5Ezj0fU1ahw9Nh9DrtCBD1p5ZoFvc3N3vEizqkY/K5TV/7MIL6D89dhlNA4a17DMe8EeQy6vCjv0/GZ292Jmb4Qkcx6lyFbVX2fB5j97Etf8SKGrRf61B6qO0LXm9IMXezi/exXZG3vAuIc+sQALcWV3xJhdhokmIKURiISHBemh8Bp7o7hF0Bg21JyMYHh+saJoWiyzdQ0UnTcCBQh63AbPKM/UNz1Ib9h4o1st5Gm0s2RV2XJw8ypkbqXt1wyEul/CbapnoLPO7ep636J4AZYvOe81PGJsgiJ24Dgd3tOCzT0NXeuDJsAtoP/g/4iCuyICy5Z881rFWjknrrNzRc8MLfY2BrFhlut6U5yapeHlK+qcj2oajcsHYL1mKSYYCdsxvbGtK2hEmRryh+ZcQS/lRUKij5+lQ1k9+lEhSOCUM1FLnhNn2S6YIVvPZrrcqkxrtg3EYpWX2b3Jga2H6+S7Kj0ClLJ80VeLEcvhoBnaI1KhrS8/1MuzIioIhhJIeHaNofas7rAMYVSTp/1FDU6rxZfek+KSqddKf+jUG43HRlfl/mOieuG/yDWfC/LZXhYFSbEyRgKVbqiupL8CuHf23PXxPRNoKnA/Aqdjeoqt8Vve5I/dLcIPLcHB17JH6i/mCGbh55c+bIcBZUAvJ7iva3H6AfLJwp8SFrwTjtk3GS1ECmcTZe3foTQ+64ClCKbEkIoSA9WpBRWPokz2Mde8/q6sIOvQOrLtatn+brk9OmdqpFveTCMe2qJv21oSAxD7qauOJUD2cwo6XZ3Av+4UhQNiO544Rze
 pfcZ7oAf
 JKo/c5ExspqY6EN28+73lQ7R4iJR5ZAkdN5ZQz+FuQxcrgJ17/NeP1+eIJLV6RHs6rFn2hKG8qCorJfYJu7N+DSP/jO3OxkUzPcOPZ5CrYg41a9rx1Mo/roHDLET2yg9obkbMFGvL1hnktbB1o/PNj7mXZK+w0h4k5a9JukFPkCveQHu8egRVZ7ebLtwohdXYJAc1s7nwpPaPCVn1W4Z7UvisUq6DJu+vcCAn1WcpqhYI8kYySgCHZbDH8tBvK0mMYyE9up7m9RxLhhJo0OC5ezuaKZeplNzJlUkZfZ/Eue3FWJvbLsSST+jyW/FxqH2mNl8h91VZ3ufBhh9kMSKq2QWhO/m1H854ixugzzAWJyZ2qoQnTXZUG1oXdK5mXS35qyHCbJV69mlop/67F6MR+BhBPu91L7oV6sf1QDqGNmdaAciNJYIcVDRpe+7ImEnJB6YyA+3DBfkHF6C67t5WogNPUWiC5AnUugI2eVreABD28LrEJk5v4K1DgeDznvBA1F7TBIa+Ic08I019OS0gztIseAmNx2TI1yQg/cTrDYarMCAb8jF80gaEMd2XvTPvMSnKKRSc2ZNf7qUuHr0KY1GsdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 18:22, Usama Arif wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> Describing the context through a type is much clearer, and good enough
> for our case.
> 
> We have:
> * smaps handling for showing "THPeligible"
> * Pagefault handling
> * khugepaged handling
> * Forced collapse handling: primarily MADV_COLLAPSE, but one other odd case
> 
> Really, we want to ignore sysfs only when we are forcing a collapse
> through MADV_COLLAPSE, otherwise we want to enforce.
> 
> With this change, we immediately know if we are in the forced collapse
> case, which will be valuable next.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Acked-by: Usama Arif <usamaarif642@gmail.com>

Nit: if you forward patches untouched, make sure to add your SOB as well.

-- 
Cheers,

David / dhildenb


