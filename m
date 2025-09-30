Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26856CCA471
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6F28E000C; Tue, 30 Sep 2025 06:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6974C8E0002; Tue, 30 Sep 2025 06:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FAB8E000C; Tue, 30 Sep 2025 06:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D73D8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:02:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09424BAAFF
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:02:01 +0000 (UTC)
X-FDA: 83945475642.28.C526076
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 968AFC0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:01:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HbXuV41F;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759226518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eg+v4IKPoz2FPKhU2l6uVp6hT3zjuuf5++3tVQs0spo=;
	b=2M2Bzejd6D8FaqXnc/b1SmhrY2Elf7DTEQ1N/MXCunPhXGZ1sn3Bwb3dI8XSt6vAkhwxxm
	dDOHs3Y5cBDO/XxQEA8fFHKbECVRIF3cz0yh1k47/vxQLiHKf8+BQBeP6qTBVyKxLa+zFH
	Yq/o/V/50LzBMLKxsG/v4KUzWoOsrIs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HbXuV41F;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759226518; a=rsa-sha256;
	cv=none;
	b=rDZUqIjH3K8j06jFl2eN942i0vb+StI/abyGJSJrNZ1X9JhlURb159DUlv+ILHnopO8c9I
	V5pE1/n4Ct/if7/uPp4awWnjJCRRg2kuaNyZZ8L0wiYRUCeVhShvb6zVkc1MuCgbGmyymr
	GTg9o+Tb4BZVvgG8YYbCLs7QsM75+OU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759226518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Eg+v4IKPoz2FPKhU2l6uVp6hT3zjuuf5++3tVQs0spo=;
	b=HbXuV41FD7wLz+EHui+9kVbVICBoZCWGI3Z8svaxJqoFFJQ+bWNqDZTFWbdgCrwqIIHwBO
	y0gunyEVaN2z7zvEUsikym7+SUYuGdELlf1h1xbeQxNHMoNog3ziuxD7wJGarPFciDoK65
	LbWHfVAHdzSQ0iGJ1Pi4CmCFUcjTKig=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-M4XvawDQOI-2KbDc2PBDRQ-1; Tue, 30 Sep 2025 06:01:54 -0400
X-MC-Unique: M4XvawDQOI-2KbDc2PBDRQ-1
X-Mimecast-MFC-AGG-ID: M4XvawDQOI-2KbDc2PBDRQ_1759226513
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee888281c3so5861609f8f.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759226513; x=1759831313;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eg+v4IKPoz2FPKhU2l6uVp6hT3zjuuf5++3tVQs0spo=;
        b=bstOLADCyToJgkAXATCIHsYWBtrqWYV35YvysTcTdJ2Jkjsx37CqIJ4uZXDeFGK4zN
         aLkKRqovCAeC5sBsZEaexuc+9gfEz+5j1KnOdkqMXHhsStTWMlO53mCeUBuENFjbWCKB
         K4utysm9ofYvjVVM9Zu+8NkdGy7UdfNCcCiKdcWtL0NKX0+34dFQS/9gx3WGuDH9Pu/e
         hedqNp3pjpzBix4aF8WW6Woc/KbBdEh+nSTzbUkf23sVao6zHDpUMLWSwzjazniqe0ff
         0jn5RICAZrvzNt4PRNrKsrBf1uguSMCXZyoAjzfW+pkGZSAKt1PU5A8L6TSXBKSn9V8W
         yb+A==
X-Forwarded-Encrypted: i=1; AJvYcCWBjGCpb2VWduFEbq0uM0/9j4MYD9hTz+kmoEA7hCVrJmiUjDnML8Op/BaWz+K/vcdOKaFw2xnYXQ==@kvack.org
X-Gm-Message-State: AOJu0YwNxnRCyNkJv7Hr+jv9CAQjHoyStdglsE3hzN5OPt09MgL+I/W+
	cRflri4m+YlA8uVFjaBaqgsp0OdNmq4k0q8HMRdAXyi6EYU/PL4LEiMyCGBXFvHBImLuLKDJYDv
	UrtksFMCSbd/pMfrsqY2sGO4a/LbXOjpqT+7bbc4n2Y8rcsDJ3r4Q
X-Gm-Gg: ASbGnctd1ULYTPZHZp7SuVU8RpR1H/VaXLEieYgheZ8xyXaNuHovy68tDZOMavw9YYQ
	81ZUhvHHctKXYCEQgI5OsTXu8Y3vtEjkHwfh8sn0yiyezISlXID1yIEVZq86u02FqBnrT2D7mzU
	zEnX+jVk/EXQjS2TTPlk7s9vmZxaRILXVCHk1bHQgQppcYeZraPHyvCH8QDIzkNzLnjeT//exMG
	tIA65j9O2apKc3Vzm60OhQ7lO0u1AxyAYY4mSzNXeql3ckuSLv7UeG/KDX8YcQH5mEgOUKJ6vxk
	yR3mRBT05D5cLf3AV5pTAKuncusOR5H09JplHlasEpCHnGwICSN7g8CDbTBiu4ZtxGwFu/AcjUm
	7+LDccxfI
X-Received: by 2002:a05:6000:1887:b0:3dd:8b62:5fe7 with SMTP id ffacd0b85a97d-40e4ca79f1bmr15726992f8f.49.1759226513294;
        Tue, 30 Sep 2025 03:01:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IED7gfrvzvniVIFECWpvOoBoj5giRqSLDnng1gFjrr0tfWABPkbygH7VH3YO344nCIvzj7nZQ==
X-Received: by 2002:a05:6000:1887:b0:3dd:8b62:5fe7 with SMTP id ffacd0b85a97d-40e4ca79f1bmr15726967f8f.49.1759226512875;
        Tue, 30 Sep 2025 03:01:52 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb871c811sm22014577f8f.15.2025.09.30.03.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 03:01:52 -0700 (PDT)
Message-ID: <645b34af-059f-49d4-b8ff-8b5b5d6fae56@redhat.com>
Date: Tue, 30 Sep 2025 12:01:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] mm: debug_vm_pgtable: add
 debug_vm_pgtable_free_huge_page()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-4-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250918132000.1951232-4-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JOz6Plkb9E6oBb1XywYGCIEX9zryTxPw9vmo7f3Glto_1759226513
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 968AFC0002
X-Stat-Signature: rb1eua1c9bne3sbuckn4c483xj4qzo71
X-HE-Tag: 1759226518-754536
X-HE-Meta: U2FsdGVkX18HzMsvyQCEeMCVjrF1BRcKwB5ge9djg4rr4GCHWofvwI/FNu+XyEeW/HlHu9ElXtawWpzIaOJHeIkyW6BDV2rmBRxwYJRGNe8S/8myZPixFTcHXzX23c1NV497bnp/oZTs9XrKfgjj+NX9hGTexQxuS+jSnlBgJeSVH2piwQTHD1in6fNwSg8k6kxBqIpsfnGzq7MuKUFlOL/fh63x/q1ycEkieqAh0i51z4b7g5qLuoqVrSXFHykp25FuE3B7997VDQ13qiqYkvDc+dkdH84NHnU3p85uHHW1vppeDwvtV5fBocZgdhFi1Eq7aBcIRVaznR3qdXrYUFzk4F3FOC52thbYwMBRoJceitGLo4+GS2bclKO/BwMoFy4kAXVsbwOAyNwyKmATqTch2dPCVx5UH1IB/A0vYPJe7erpYGkqTAXbq88bLcLSMK3vcgoT3eB4jYJWZEmau1xqdk/jphr4PalHj7rrTVPo7TvmOrMCzlCGrqx48HjtYb7TeRAf0KJLjRP90DKNIvKOQzIwyuvMJ6WitOq8+kQktNwgnqmZaDv9/FZtBOuEOSW0SlfhaYdmkShc7DsmP6eAlll06pYiR1kGariVh5Qz308KDNSdrHacmMYZRQt7G4O5HwG3lzXgiknAURuEY31TwU0UMYo/+tupnq6jCoDQ1/fA4MNK/wWD7wZXWH14KcBjs7Vx5CYihXEIH2/ZM7DJctKESPpCCx6w1VEApfW/A9/sU3esYzCD7PEGcJHTgzTpchLd4FcD6EMJVlICwcKaqCoV+lOd8Fvs4a0onHKaj+MIagZCTBaZ5BaiOU5ipFZWuZ7n3rtF063ZR2GMdmvTGm5xxRaRwa6reUkKtE1Xpl8VMQtFnA4OCUOOGJrpw7//xJ7LOp0HQx/DKzZ18wEH2BdQk4Efdn7zVWY9kUKX1FPKlyegT5oCJYFBEjv8jiWFy8UWgsGndj2R+5C
 voHrk4NX
 S2fuuLxGL65aic8scfSxmlDpALKTb3msx7dgZq8NKEQ78GgY7zVO7zG3gmMNH2ffh7Ao1+NAA+zfaPBUpE46+IiCkefd6xKPCe6hyypu0PhVr7rTDStWcT/nSjcU/DRd33KAKI7D523dCbpOpXNN3kBuOWlj4WJJavqNCdyqpK8010XRJWKLZ85YWfF+YUXgM/GtqrhIh5dyyuChfUI5MemCdYihIa6F6HNcZDYJt1ifOiGhrB5ZDdFgU1pNwBOQvbSPVJMV5pAQOeQjCHVZoZxz8akpDu6hjWAOf5FamIzBXvqC9anE6dgueHOGGLlKig21Zb/GOlApf/88q+YS6v09o3x/295QNWIV5mhh9PQ0LPm+4qkOvskAdlfl8tBgobXYTWV1GuZ3YEihbZVjRlJ3mWHD9+M9barAyB0CspGDQG73ghUc4Yuz5TlXpRRYIgFqHvWZH3lAmlifSGcu+U9T95RwxPZtNRTKK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 15:19, Kefeng Wang wrote:
> Add a new helper to free huge page to be consistency to
> debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER
> instead of open-code.
> 
> Also move the free_contig_range() under CONFIG_ALLOC_CONTIG
> since all caller are built with CONFIG_ALLOC_CONTIG.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


