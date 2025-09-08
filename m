Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C450CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1CE8E0021; Mon,  8 Sep 2025 09:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79358E0014; Mon,  8 Sep 2025 09:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F5B8E0021; Mon,  8 Sep 2025 09:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97FCC8E0014
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:45:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 312D41A0184
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:45:20 +0000 (UTC)
X-FDA: 83866204800.11.780488D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id D69B5180016
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:45:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BY8EM177;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757339117; a=rsa-sha256;
	cv=none;
	b=Q4Nm7tDodC6/gNijUz7xXnXzHZURVcMD/tQYCCjQQrAajZXUEW7/nFqVslGlxDHRCgu99K
	oqCGF/ZsivKWaxuuieZw3BQLPJjUQqD1hxK6jZVzr9arajNmHho23gJDEGGCRYMzgS71WO
	Z+y/o3/Fmt+3hsQ9XQO7K2vMbHET/Ko=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BY8EM177;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757339117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLmwvDeh3uTocNuEY2RTW0+ExLFf6n+kGxhdcdtUOtY=;
	b=YbYqCKyLB9p0Jcq30uK3+ezYDXwDX79gQEGTpsJ060zRBui3icUHrHSu+7qiFWv8m1ha5N
	53BxTZUf59J1lIKyuYncPdqfRKv8efiqBJsthC+yxLY0x2tEFIaYd6NCcRYLyvHXNIcyj8
	gIWENsFjGFRq5jSFbAHZ0XU3pWRcP6Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757339117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qLmwvDeh3uTocNuEY2RTW0+ExLFf6n+kGxhdcdtUOtY=;
	b=BY8EM177P9rh86BQspn+LPmIYm9BpaHc0v3AbBTsnUsGoTGB0Dp36eDtPca9MO2A7nr+nc
	el6xbR/JXnd7SyZNXKgImoOG469Am58iuEbVxfpqsv7DmzPPsEZg7pBtus1LR+yDCDAgl5
	/l1rXWjeCt4aEdURRUjuHdJsPs+Cvrc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349--fBa8vnfOySyTUFF82PfMg-1; Mon, 08 Sep 2025 09:45:15 -0400
X-MC-Unique: -fBa8vnfOySyTUFF82PfMg-1
X-Mimecast-MFC-AGG-ID: -fBa8vnfOySyTUFF82PfMg_1757339115
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3da4c617a95so4103787f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 06:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757339115; x=1757943915;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qLmwvDeh3uTocNuEY2RTW0+ExLFf6n+kGxhdcdtUOtY=;
        b=CGvrNsKNnmlyUq2IUNWUloALxNUeMJGyBU5xgZGIQBiFO2iPv8NoPMoKtX+SwdbmD6
         FAYGKfUA6Sqncko9xVT+zzaN9fn0j4csrS7Aw6PoKXpV6+69Pywu0aGXmBjK+2yUOwBs
         U2cJS8QgwKq0Zgi/u2phMmpO8qNqvih+tqXuTE1h+GbxVimr4T6hVb2it8c380C9B6Th
         V5pc6VbE6rUs06dpsIY5HE/fI6VSqi9j8oTAejZbDJC+q7CVkEYET0oSyQfMeW5qoc7z
         pMQzOM0U+zaz5fcN8MompBa+6kTe9e6foAI5BTGnpx3ldJ4EVkpLoZtTizfWe0KyHoeR
         4EPA==
X-Forwarded-Encrypted: i=1; AJvYcCUeIsiY8u5Q8bhf4snDurkwuQfOvPnp89m7j5drcBfVOPSmJzkQSNPkHNc9rpmG/oRspPWEs38U/g==@kvack.org
X-Gm-Message-State: AOJu0Yz8yGTR9q03uZDUiaMSIiJk0lXp2g2q0XTRb8kHYwQtXo0CPRAR
	wbgu7b+NUXrVNt07dvl1SzafZnOd4/TuryjHHaSGPG1X4Itgw36kZYZuKviumoXPLY4LhDO2Y+l
	pfgA8nfIDSGn/9ralPB6148RhBRMNJq5c16c2ucfMqEAG6ujGn5op
X-Gm-Gg: ASbGncsqt5U1CyKAclO6MekUuoKgYvzhqBYLHADHN1JH7u+xT7r9CljYSRQ9speAmVC
	56Gey0LA102NpDqWU41xNFXYXqcvnWLOq6bedf2YYMFpP1LGU26U78jwiPjlF1kCJpc7LlI0/Gr
	H1WXbmPC6/Htnt4C8WiM0iAuno/OQk/v2n18d6nPXwcV4kmxRygYplEELiUdR3sQNHnwjMlpvbx
	ziLVguCLeoWHW/27cHmCHYbwtmDouQEsEwyeupK20y5rkepYJo1yzaqJCpxc0vzBWBOgTqYkKnM
	1KkjZXiaUGdmNrzj0Mli5RaLjRDoeeUWrgcczaxN+BvZfckr+jAupu/HNf/IEur42VNL6qYg2sa
	DE3wciXAOFANSDdUQG99YnUwnTmhO0xXwams5aRMmzErtXCin5dk/xe5r9kWjnz2v
X-Received: by 2002:a05:6000:2f87:b0:3e3:921b:659f with SMTP id ffacd0b85a97d-3e641d46423mr5873106f8f.2.1757339114604;
        Mon, 08 Sep 2025 06:45:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBBGiwyzzjCzHwLoe0afie78c2i5NLd9se8NpB6lEvYgLnJlyiOeCh7rskc1RvoSZRj+HaIQ==
X-Received: by 2002:a05:6000:2f87:b0:3e3:921b:659f with SMTP id ffacd0b85a97d-3e641d46423mr5873074f8f.2.1757339114038;
        Mon, 08 Sep 2025 06:45:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e552618813sm9859106f8f.41.2025.09.08.06.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 06:45:13 -0700 (PDT)
Message-ID: <4e0847db-0503-406b-95b4-02ee7e8f9604@redhat.com>
Date: Mon, 8 Sep 2025 15:45:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
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
 <20250905191357.78298-12-ryncsn@gmail.com>
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
In-Reply-To: <20250905191357.78298-12-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X0aeLasuhTCR4HhlpiKhww3ZsMqM6-9fRLlb99fMe3I_1757339115
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D69B5180016
X-Stat-Signature: qzsb3gbsqhekyghfxmiiqib5ebm5o1pj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757339117-216514
X-HE-Meta: U2FsdGVkX19IsiqiwljWYeTrZJGxL9t0uL+jixhKUUulguNm7Op4/X/XoKdWuqq8aDjgUUIdFy1DLZVd+NQhGrWmwoKUJ+WEdSieLBGSEXNlZU6bMviWVAT/hpxr8NsXZy7qlJUJeUi+H1ANahjODxXSJSGndQ7BaKNm78F8CR+fdeOHM/v/TVcv4ygy8PElxjrrc1MxUDUOQaLunlMTyzlkQ50eIWs8W1edw3VZ66ZILCwk7jK7R2uN3w+gJqQOoxYBbPzFMHPnA7enw3KxIMO57T1AZeffNDsFZ3Oxyo5sFmg48I7xfu/kNZgnyDf+3l6AOfb8Fz0r7KXBOT5Ag88pz5HHl2EP00LpMc7PXQIvKF9zAjH/8rdoJ8QAzRiPo5huX4FwNqwVzKXzOOzr652Ew1tHfnYiG2uwShtS/6Tx5Mq8PUFKo66FGRa0x/ehix8j6dTuEvJ4I91/KWGD2uB+h1Wg9QztcEdmcvFil8r/WrY7Vy2J3ODM4i+bCYq9Ps80Uh4WEE7ptN4Nf0ee/3O/2XiRY2VA4JUxVEjELHO2JEDIgtMbXm2TWDdaZAsvnlwCcLH99Q54L8e1/cZXofgEeVGu7VHmCd8JHkJVi/h2mGpCPKcCUtEqTyKnwacO+LMpZ/MZ0tBocyGA1rkyah1aQEcXMUuiNvcMPrTh5akX1bFWeifSmfXex+iF2PwVlgo2lDF6UKnaFqlYiIjy7AV275vaRRfIb+HPwpJOqNEHoCwaRAHuKfoM//cPz6Hf4+OGSHsd0P6aZvWgHNOgAao5hqDLIgn50UyUrbw/y/ADUtJuLyYoSGw+m84gu1YtU94yBxY4yNNdOAcaK0SYc+5NtTQjJtLdJokEyA5xBgxCnPlpJMP/N+hNhU76JckuuGlQ6sBcJ8j0Uxt4Zd2gK3zTq9ibTxFbAW5XGmTWMruzLHuju677kX2vM0EIsKjN1bv69tM7tc1UeInhBiS
 iHGyCKLr
 gkIuI/SU+x8hmpCC80dAlR6hinwd2G6s7GG4WldNXRC1yEfe/IXXtkZJzdWeXT45px0N4Y633MsHTlmsBkq+2NRUkT7KtthtRM6ZQQ1Wh21mBLvf24Um1Mj8Wf7J2jTIHqyORvwX1qRtKUQoGRiuD3IWDCm7fje3RbFxSWce6pjod59hyts3dKJrEVb4Ted5BB9j81yuS5/vjsERo0g7DpOlvmUXdVDGsRJjzZnz0Gum/1OJ7H2uJjLf3e19hI0Kwdn4XroRbJfhioKmih8uB23modmenH2baJ3tww5safJXZuVqFsRYbj5hfp8jlWcV74C/ED55uTuag1JIE5YrIFOfjLlM/++z0AL/qiFYz1+dVVZVl7V9fR7FSc4puYVT4tm73gwrS6yU1GYXYKqRZKhfa8W8yIamzEvU3sGQQLEicw0kL/CpYfY7lQ6Q4aebq8f3q17QPR1ShMF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +static inline struct swap_cluster_info *swap_cluster_lock(
> +	struct swap_info_struct *si, pgoff_t offset, bool irq)
> +{
> +	return NULL;
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio(
> +		struct folio *folio)

I would probably call that "swap_cluster_get_and_lock" or sth like that ...

> +{
> +	return NULL;
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio_irq(
> +		struct folio *folio)
> +{

... then this would become "swap_cluster_get_and_lock_irq"


Alterantively, separate the lookup from the locking of the cluster.

swap_cluster_from_folio() / folio_get_swap_cluster()
swap_cluster_lock()
swap_cluster_lock_irq()

Which might look cleaner in the end.

[...]

> -struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
> -static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
> +struct address_space swap_space __read_mostly = {
> +	.a_ops = &swap_aops,
> +};
> +
>   static bool enable_vma_readahead __read_mostly = true;
>   
>   #define SWAP_RA_ORDER_CEILING	5
> @@ -83,11 +86,21 @@ void show_swap_cache_info(void)
>    */
>   struct folio *swap_cache_get_folio(swp_entry_t entry)
>   {
> -	struct folio *folio = filemap_get_folio(swap_address_space(entry),
> -						swap_cache_index(entry));
> -	if (IS_ERR(folio))
> -		return NULL;
> -	return folio;
> +

^ superfluous empty line.

[...]

>   
> @@ -420,6 +421,34 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
>   	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>   }
>   
> +static int swap_table_alloc_table(struct swap_cluster_info *ci)

swap_cluster_alloc_table ?

> +{
> +	WARN_ON(ci->table);
> +	ci->table = kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER, GFP_KERNEL);
> +	if (!ci->table)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void swap_cluster_free_table(struct swap_cluster_info *ci)
> +{
> +	unsigned int ci_off;
> +	unsigned long swp_tb;
> +
> +	if (!ci->table)
> +		return;
> +
> +	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> +		swp_tb = __swap_table_get(ci, ci_off);
> +		if (!swp_tb_is_null(swp_tb))
> +			pr_err_once("swap: unclean swap space on swapoff: 0x%lx",
> +				    swp_tb);
> +	}
> +
> +	kfree(ci->table);
> +	ci->table = NULL;
> +}
> +
>   static void move_cluster(struct swap_info_struct *si,
>   			 struct swap_cluster_info *ci, struct list_head *list,
>   			 enum swap_cluster_flags new_flags)
> @@ -702,6 +731,26 @@ static bool cluster_scan_range(struct swap_info_struct *si,
>   	return true;
>   }
>   
> +/*
> + * Currently, the swap table is not used for count tracking, just
> + * do a sanity check here to ensure nothing leaked, so the swap
> + * table should be empty upon freeing.
> + */
> +static void cluster_table_check(struct swap_cluster_info *ci,
> +				unsigned int start, unsigned int nr)

"swap_cluster_assert_table_empty()"

or sth like that that makes it clearer what you are checking for.

-- 
Cheers

David / dhildenb


