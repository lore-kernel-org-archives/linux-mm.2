Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55F83CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF768E000A; Tue,  2 Sep 2025 05:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9872D8E0001; Tue,  2 Sep 2025 05:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875D88E000A; Tue,  2 Sep 2025 05:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70E198E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:03:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32F451DF3AF
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:03:54 +0000 (UTC)
X-FDA: 83843722788.04.851028B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id D954420005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:03:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dJUdAiug;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756803831; a=rsa-sha256;
	cv=none;
	b=3Hq7zrAAQHm0QlJYpxeEkXmIxiHLph1HFZHPfjiWUuKyMD7CllQfhqMDVni+10IByWyLTk
	FVjqxFmBRT8TJcbFzXIS+xz9shshsvhcYmfh1PT79lQ71QcnU6ipaC4o6rFZrq6630Hn/X
	ne8I6/4GKrbfruGQRpn/eCgk++b6Bys=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dJUdAiug;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756803831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0WxnR2FR7ip9N19Qks8VM7/RT25qXBqQIJIfmfk1b4=;
	b=TTNGhtntcigvRfnMwgveGziAtf92mz5jBvumzj5i8ttPxE8pvqBQd9D9y5rPGSMId+Ze4Q
	9txkLyumHbXpokV7Td7VhprdkhBaZZedSstru8P0dMZkDPB7Wpdrhk7810aB6vRnCm77jL
	9OUYvwaTNPoRyJDYlQY0mBbNCutFze0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756803831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b0WxnR2FR7ip9N19Qks8VM7/RT25qXBqQIJIfmfk1b4=;
	b=dJUdAiugfWACaWr51T7WheimNXjzOIrF3HmfosYfq0BFETJDRiYjRg/UoO/GLNJr7D+JUL
	Y1fTAOwwHZewRYgAFcSQMtTCeIWN+YdSfb++na3v+2ZtypWVUPGxYtm6mucsf10hU1WR5/
	iO+lOgHVxmDHMe1eFGSwv1swn0fMWl0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-FO0q2QvFMBu9dwI6K75Alg-1; Tue, 02 Sep 2025 05:03:50 -0400
X-MC-Unique: FO0q2QvFMBu9dwI6K75Alg-1
X-Mimecast-MFC-AGG-ID: FO0q2QvFMBu9dwI6K75Alg_1756803829
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so46690375e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756803829; x=1757408629;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b0WxnR2FR7ip9N19Qks8VM7/RT25qXBqQIJIfmfk1b4=;
        b=ODshCXFPIvKb6E5IdBKs3Aa7FMPeUbVP0XvO6x6bJs2npzkwk4028Hof1GniP2TyV/
         EfkVj/AUJe+kAPxKhZDheER6RUPn7Cq7XMj9ukXJ8MJisNsM0SDxJOzTwBQF8X8DWH0I
         WaMJzSFgPafrSLzQCEaVISDnwwa/LXP/5wsrjKBxX1b08uYQqnaNx+T1e2d6ZPLMMaSH
         pLUaWS0lgkuD1GI4g1YVeL9Tn231HQBQjEFSKNPfJRZeh8vYEwZ1uixwNaLjTbLG4IGM
         RfjmRw/XJTySJB7UmENewRyEaCQsAgt8u7TVL9sgRxDgq3r3SiruQlL/4cfpL5k5Z5sX
         oQLg==
X-Forwarded-Encrypted: i=1; AJvYcCXxlk5Rl6n5vpj5+J68JlpWqdbVt+hsd5loGpqCrYFgdtSc1lnKmi9iE2d3CVASQVAaqvEQG4DbhQ==@kvack.org
X-Gm-Message-State: AOJu0YzwqGPTtk6zPfzdt/rHwhrFZvbNY86wMJTHi+eW+d1hy/sOwdrG
	3Zw4TeZE+9rdXEfySlBBI14iYEkNcpXvqcFVHeMLc4IpMogWVCbJ+oIWhR4mLbpPXGYFRBSgAYn
	tAfcKLEI8wWCpdg1DdHQEUZ/GVUuwQAAWknoT5zoZ2HNs88vSVyBw
X-Gm-Gg: ASbGncsQ0B/KvGbj2Y9iuvTVtpkCS14pexs/RKnwhanumyFHTxHkkOX02NjMytSKksE
	vmA/vTXHahuClHzOcbwX1dHYByBHhTGEamwOx74f6b1jzxYKc7x7XcGzH8yCSgGs4XCGQGyFgRf
	wGi/TPsf6Mck/+pk8hJAQhjrQFKYkI1XVm7Af8A/4aTHY91op7Tu/UBeO1LKp3qmn9NpACjRvVH
	nx4H/P5WNPAdIkE/ybZvsP579OWLSlHc+4pmSKaWDqXQUOZ0+f0Bvo0lKbXDdEdKeg/36QT0BSR
	sJ087m3YvLSVnXEYFVTSDm6f0/aY6BP6JZ+eTr6HmOLjasyzt4SsRALi00syeNFLHASNXoArDNy
	5mSt5XmZuMdRDoOim7EUHiet5bQcWNxzmnBNrsKhMn5tIKchfLfdvuLMi144eJQg+Fz8=
X-Received: by 2002:a05:6000:4313:b0:3d0:c6bf:60e1 with SMTP id ffacd0b85a97d-3d1b20d94f0mr9291839f8f.24.1756803828724;
        Tue, 02 Sep 2025 02:03:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHht42snrEs79iA+s2h/qI7OraYOWgxGTGcDie+mtZ0wLD5GtnIdk2F2nZntl4vgHTaHkpVuA==
X-Received: by 2002:a05:6000:4313:b0:3d0:c6bf:60e1 with SMTP id ffacd0b85a97d-3d1b20d94f0mr9291795f8f.24.1756803828088;
        Tue, 02 Sep 2025 02:03:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b88007a60sm70932175e9.8.2025.09.02.02.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 02:03:47 -0700 (PDT)
Message-ID: <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
Date: Tue, 2 Sep 2025 11:03:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
 <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
 <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
 <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
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
In-Reply-To: <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1hJCanv-Znfn2z6Z8rlnL6xREvcnm0OTS043ebVpuJU_1756803829
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D954420005
X-Stat-Signature: ekukiyxx4gtks8cwobqssne7fbcokyqx
X-Rspam-User: 
X-HE-Tag: 1756803831-690154
X-HE-Meta: U2FsdGVkX1+HLToNGZtb3vSmaR4/2aW3z/LivDRNl9dx/v+o+E2PcH1whP3t38dsIBH/4OyX1gXKaYirLhTQbHD6b3DOOoeCRcFSOob9TJnUXDKDROzdKUGXPMeKVRSXIQCR/U/dOp1MXIuBWgNybIRZqKZbIXhvNFmnW1h2tuiKhF9Idc4W4CJEOQsHAQboHXvfoprmE/pBewqbzQSKY7kmLhSg+R14MF8biLwpiCIU9n7KUi2/4z7zu+cEWF00X+wxzobcguNy1vW6BfWVs82SGywC4x7uB37gSqSuviAuLHe0D2QLB6DL9c8HuflbZeef0/ZbRxno23LxfP0W8Vo8DbXhx7pangsSftB76suS+47i1B9Y6AaOqeP9esHDH73cNPTZu3hltT0k484O94CFz5q/Pdx0rbg3Uw7Kjcwr0fDYs2Ol+7/EDZarpgWrHZ2xaB61gIyah4PLs7uYtZzbJuenmUFm7U+7nYNsTZiC3fYN7GGO/8dHXFIBH9TKv++SxiAM4yD0iZgrw/neipMQuAWBBGZyPEB97Q7vb9OpTcqjcLEn0lxA07mr6rgg0ZSq7uVQcjINU1Qh3q9SgROD7U8QCKizKOKjp+ZINQdCWmltORn9Q2UcRcixQ/8DK4CVmbFMRM7HZuIwJiaNROJpX4KQ42jYCcLGknqSKmL0yikZa90ylKA43zsd+5eV3oVFCNbEQz8JyQArgt8J8wxdGMvQ+PUobEe6deCw8Eus0gOVWPPyoVYOYWoV5f+B3AKu3cN9qwJiSl3kujX0JqNtL8zURSNM6v+ptnixEznKBQ1UbFHsHQto9iLaOjZK37bFehWAu56BI64Di3/9e0nSqk3zexvmpYykEs2V0lLlHYRXS3OJC6zSRsae0ePxC2CsgnsDvedrXmkiyLaIrBg+191P1LAg4B4RhdIV7P7JjzRv9Z43nH3idTlC2RzwOulW4n46WxJUA8MUkMv
 Aq/rIEc5
 0q42o5VrZjWJ6pFw1qfo9rR5djtWPO7CvsCOwOI4lJHLIPvj9QMA1oNjmq01cRjE4fSfhBnKIWxWBpjJvhdqoZHxaasfW+uG1HJKT6jVp23n3HIIvSRnIqL/rwtWBx+Zx8HxSI5pA7Ym3/GnF1Y2TXEGaAHDINLYj/n7fSUz2vPpMx3da3yRJ9Sk6zkk1tkDiCqJFw7tCVVyrULB+qZxpkBNSCwUiWJC18lHhgTmVivPDVYTsfmkPmN/naKCNnCNZQbXDgMfYicTpFSb2cYBa9ZbhRuAeAQTY6pMNFv6ES4Gfq6fws6VNoDgTbzFltNb0v3SdSNV4ivj8fp4/cyYlQDDmCkuZQg1HQ1Nrtsgwm7w+JclgCjd8hOtRlgqIu53QSSuj8WXt3cOMW1UBf1zSeD2eHNRL6wtjs8PWfMf8UBmavUVL1ya8tvQEVgXFnn++lZreO3dy51LBbyx8+vNiWLIcoJ4RQscySko+evh9IMB2i4U9bnp4LQ92i3pc8K+ro/8b80HOuwORfLysOjerb4IPPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 04:28, Baolin Wang wrote:
> 
> 
> On 2025/9/2 00:46, David Hildenbrand wrote:
>> On 29.08.25 03:55, Baolin Wang wrote:
>>>
>>>
>>> On 2025/8/28 18:48, Dev Jain wrote:
>>>>
>>>> On 28/08/25 3:16 pm, Baolin Wang wrote:
>>>>> (Sorry for chiming in late)
>>>>>
>>>>> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1),
>>>>>>>> but not sure
>>>>>>>> if we have to add that for now.
>>>>>>>
>>>>>>> Yeah not so sure about this, this is a 'just have to know' too, and
>>>>>>> yes you
>>>>>>> might add it to the docs, but people are going to be mightily
>>>>>>> confused, esp if
>>>>>>> it's a calculated value.
>>>>>>>
>>>>>>> I don't see any other way around having a separate tunable if we
>>>>>>> don't just have
>>>>>>> something VERY simple like on/off.
>>>>>>
>>>>>> Yeah, not advocating that we add support for other values than 0/511,
>>>>>> really.
>>>>>>
>>>>>>>
>>>>>>> Also the mentioned issue sounds like something that needs to be
>>>>>>> fixed elsewhere
>>>>>>> honestly in the algorithm used to figure out mTHP ranges (I may be
>>>>>>> wrong - and
>>>>>>> happy to stand corrected if this is somehow inherent, but reallly
>>>>>>> feels that
>>>>>>> way).
>>>>>>
>>>>>> I think the creep is unavoidable for certain values.
>>>>>>
>>>>>> If you have the first two pages of a PMD area populated, and you
>>>>>> allow for at least half of the #PTEs to be non/zero, you'd collapse
>>>>>> first a
>>>>>> order-2 folio, then and order-3 ... until you reached PMD order.
>>>>>>
>>>>>> So for now we really should just support 0 / 511 to say "don't
>>>>>> collapse if there are holes" vs. "always collapse if there is at
>>>>>> least one pte used".
>>>>>
>>>>> If we only allow setting 0 or 511, as Nico mentioned before, "At 511,
>>>>> no mTHP collapses would ever occur anyway, unless you have 2MB
>>>>> disabled and other mTHP sizes enabled. Technically, at 511, only the
>>>>> highest enabled order would ever be collapsed."
>>>> I didn't understand this statement. At 511, mTHP collapses will occur if
>>>> khugepaged cannot get a PMD folio. Our goal is to collapse to the
>>>> highest order folio.
>>>
>>> Yes, I’m not saying that it’s incorrect behavior when set to 511. What I
>>> mean is, as in the example I gave below, users may only want to allow a
>>> large order collapse when the number of present PTEs reaches half of the
>>> large folio, in order to avoid RSS bloat.
>>
>> How do these users control allocation at fault time where this parameter
>> is completely ignored?
> 
> Sorry, I did not get your point. Why does the 'max_pte_none' need to
> control allocation at fault time? Could you be more specific? Thanks.

The comment over khugepaged_max_ptes_none gives a hint:

/*
  * default collapse hugepages if there is at least one pte mapped like
  * it would have happened if the vma was large enough during page
  * fault.
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */

In the common case (for anything that really cares about RSS bloat) you will just a
get a THP during page fault and consequently RSS bloat.

As raised in my other reply, the only documented reason to set max_ptes_none=0 seems
to be when an application later (after once possibly getting a THP already during
page faults) did some MADV_DONTNEED and wants to control the usage of THPs itself using
MADV_COLLAPSE.

It's a questionable use case, that already got more problematic with mTHP and page
table reclaim.

Let me explain:

Before mTHP, if someone would MADV_DONTNEED (resulting in
a page table with at least one pte_none entry), there would have been no way we would
get memory over-allocated afterwards with max_ptes_none=0.

(1) Page faults would spot "there is a page table" and just fallback to order-0 pages.
(2) khugepaged was told to not collapse through max_ptes_none=0.

But now:

(A) With mTHP during page-faults, we can just end up over-allocating memory in such
     an area again: page faults will simply spot a bunch of pte_nones around the fault area
     and install an mTHP.

(B) With page table reclaim (when zapping all PTEs in a table at once), we will reclaim the
     page table. The next page fault will just try installing a PMD THP again, because there is
     no PTE table anymore.

So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.


-- 
Cheers

David / dhildenb


