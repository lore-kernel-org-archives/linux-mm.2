Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99221CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E307A8E0083; Wed, 29 Oct 2025 11:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08248E0045; Wed, 29 Oct 2025 11:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6D38E0083; Wed, 29 Oct 2025 11:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD98A8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:04:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 962DF140841
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:04:21 +0000 (UTC)
X-FDA: 84051472722.06.B5AA2AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9F1A7C0007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:04:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Td2yM4va;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761750258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdVdVrXFh4tr+yuwwr+7pS48uqrz07GxlHo9XTXKnac=;
	b=bdLJOoGFR18iVpkwgQgLHK5tsmyB6jr7oBhAmJ/IXXQnXblAMLa1IZ1JVxvigWYecu2CVt
	EZbbRQepRVOBZE5jnj00ua9XSetKWxifgwNVK5D9pXF41SW96MyA9xikOOTzUbFwwZFp+d
	CLjQKBIZCKv+5TOWDJx8TYHTDbRort8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Td2yM4va;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761750258; a=rsa-sha256;
	cv=none;
	b=gycM9h4R4UHOrtomyMWu3S7OTaOB3k0knQfdte+jLeHhW5GK/L3OncKhOrXjjxGENxGscP
	qGL1UP//zMf5EBUGBQbUGmn3TVd4cuf9kLNYsS4J2nywCveVxIJHEy38FEoG0LtwWDv/px
	31CudUGlLpf2dJCjfWy6BSaolJ6yPtE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761750257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WdVdVrXFh4tr+yuwwr+7pS48uqrz07GxlHo9XTXKnac=;
	b=Td2yM4vaJzUELWtHZDezlJGASKRhMmfomO3ew1cwdoTMiFDjJhJYl9aWcmFWWgwtYp5Mkl
	9WQZQFOCJk42w7lAxnfaKy8DjnTdbIu4znkAlCc2MWV4Q+mog6gEFZsa2EGm1lr4kX2W1n
	yOc38cvzHU0VqxWPsGdh0a8iv+JCUNI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-RwHM709AOcKRUPJmLKY48Q-1; Wed, 29 Oct 2025 11:04:11 -0400
X-MC-Unique: RwHM709AOcKRUPJmLKY48Q-1
X-Mimecast-MFC-AGG-ID: RwHM709AOcKRUPJmLKY48Q_1761750250
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4298da9effcso5206496f8f.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761750250; x=1762355050;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WdVdVrXFh4tr+yuwwr+7pS48uqrz07GxlHo9XTXKnac=;
        b=pnGnsaKu0UY3GlVRx+iS9Kzv5MFx9LhbSRzLZ1wQCPVOt6ybSPgX9PxPRzEBTlMgGm
         0tjVWyim2FIooSOfeP8tDhV7iVZbK+2CSOOXx4NuhgW4i7yGaVYK3dHV6uHsOIQRppxB
         l2N7DuSVnfrfhjE3Y4vmyzadst2jDR7LNJ7A0Ihc/Sv7DM0llOs4GMyDhISUyGe08Fgy
         GH8E5gN/v8RZjIqhXiP0NVBSxtSYxd3eQL75jv3VtQMH1vEqQXO0WtZ8IgcGXGEvUUVg
         ZngUZoazhBJcPAP+GLCvaNNFi7dgqQeBlFaHeBVUGtaSLODaJuSw6CiJ5/rvgFuiiTNl
         cTfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWC5+ESLhvUn7cGc3Uk1cmfx/NdhLxvOVFyVauN3ZCsVdgSdnecWT/TXI8sfX48F8GDj6NvYAKbaA==@kvack.org
X-Gm-Message-State: AOJu0YwLsij9EcjoajpruzcaTw8+RNB2pd2gV6vTw/dtg06y11wy97j/
	JNhsmY636dHvusMNGKXyTI8yxosTMarP1zMfu9KbXKwShNGwTctaiFMO5VZ69nv+4d8Ya325RLa
	KQsQu2bS9jKcgoG+W14hYkjtoTz1JPSxjEGRV041VYBnrroE3/2rNM4sFmIEM
X-Gm-Gg: ASbGncv4IvLV8NmuhUFW5JxMHA2oXFaph2+z/JI0gTq5SvR+eF1qA1PK/zOITh8kVXR
	9zZakLNbYKCUwwJVr4xe7DQoDCt+7QjLDDCvKef35vs4EczTguiDeHA5hRQ7UftqPEGaStYURQd
	6lacGMR2JOkGJ5VBHozhnBOMfJMLkKDp5dPAA6fyT4xhgVnI1nAcUQLecfH75NZQ92WVMJIYAkp
	pAXdOnX778mUNkCdQB+f+bSAhfVpnUMgCU8+C0o/UbrYK1cEHLopMQ2APqguQU8GFx5djH/gXY+
	6Gr5cosjmTJcU2jpOwr3lkfntXJPuq3DVTsvN6ULf7M1RNFrH/w5JWqn5Vmaaj2EJFw6MizmdnX
	h0zL1nwVhoLEo4IkLKucS2g==
X-Received: by 2002:a05:6000:22ca:b0:428:3f70:4b2 with SMTP id ffacd0b85a97d-429aefda8c1mr2684167f8f.63.1761750250313;
        Wed, 29 Oct 2025 08:04:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQD1xLBQ4VY8cCjZ9K04TQoxLh1bjMhMB/K9HMpgFhxu8cSEiLIZZCFGjX/uivaIO2mRj5FQ==
X-Received: by 2002:a05:6000:22ca:b0:428:3f70:4b2 with SMTP id ffacd0b85a97d-429aefda8c1mr2684117f8f.63.1761750249760;
        Wed, 29 Oct 2025 08:04:09 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47718427409sm46680625e9.1.2025.10.29.08.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 08:04:09 -0700 (PDT)
Message-ID: <2d8ed924-6d06-42e4-a876-381fb331f926@redhat.com>
Date: Wed, 29 Oct 2025 16:04:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
 <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local>
 <e2a89e74-1533-4a83-8d0f-3f4821750e25@redhat.com>
 <64b9a6cd-d2e4-4142-bf41-abe80bf1f61a@lucifer.local>
 <dc002ef9-53ee-4466-b963-baadfd5162b7@redhat.com>
 <a97780ab-6256-43b7-8c0a-80ecbdc3d52d@lucifer.local>
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
In-Reply-To: <a97780ab-6256-43b7-8c0a-80ecbdc3d52d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XOj9NTCLc7-tkLCHQ9_JF3EKjzGjV4ehHxSi_vQTTOA_1761750250
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rzo6pew1aq7gy31xs4xkd7o3ywr6n85z
X-Rspamd-Queue-Id: 9F1A7C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761750257-860417
X-HE-Meta: U2FsdGVkX1/AP9T+E+40/BiBxuwpoROBr3pJhLo2G8o+U2xHtkuIKFhJPLKBFXynt1IGdBBbGVvVTtiKIZzo+oPFGd8SUS6Opg8NrGrRjRSlYoZZriXYadV1TtQFQPy7SQgPQkW1knL+kqjNeq69QhCbVKKoHlFXACVr9cSHai7NY3NCTPq8B4sfVZlr3iCq7X/bM+2ybAdbUMHsspSH5oH+fPfp6xJQz36Se5Q0xP9A8g7/zn1SGvmi91dp/fRb8cm5C9NvqFjQyZM3E5Ke7GWkNEZ8H6PoFz9kzId1fZ6Orto3UuQoUtEIjiR4aG91vya6tfgm/lAzUPn9kfEgB/LsvtN071qWZNpOlmf1/Zu+bOo0Qkpj3t2twmVEVDjkT5e/vNXbmCupiPLyuMEmLtF46bAXu3CT2KEB54Ar2U1hcGZ6rCPljCI1XKPyHmx5PtgAHKrUfZNylSvt1FI4/GcLiswQ2mQqTKvUvfJopOX8B/dCsuwri5jsWC4WmQwcf5JhrLuUI6hk+lJthnzrmEDYFU9fp4abWVwDteU0b2yootrmHKgj7aWrHkkVASxurb1RZsVWvH3nRJMxiD0KQCsLubabzuWekSj7qWSphNmbLAmXOwPFBs2wcuoyZn1p0aTqLe1wK68Y62VL0nxgdSluWQHOuIQ6EllG7AsAD/fNNYNSSWx8rjmJzBsD9hoR/1jnENUTSh3a7ZhV7ge8AbpdlxxWOoJDdObfcnuDcXh/pvcFhvxHIY2hsKBDFFAoD4Gi+oHAkT2JDll4wWa6Frev+F1z3fL3jWI49DrmwBip/sxyKyXe23fPb6v/CLq68e9JgcZubKJENrDR6YLbhr0UTFvGfO9BHB7cMf5lVvqk0oR3a/ElISUhrAzyBc+rm/umDJNluWc+rQlnmn2aN93i1dZHkQF24RTKepIMPLyh+rmpNch0MthiUA4BzEuA8slxlaOcRHehTQAdeBV
 dwA8bBIL
 2p9W/88MKYme4HfkQCpBN+0Wor4KGwTtrJY1Ykwl0LoivT5nXC5AXO66fF/6QsIZMemKkOBShGkckDHcyrpeRKY53aN/5M+9tchMCY1tWOl3jHGL06dVavizevlwX23/AChEzXkwrW8uAjASKK/PtSYnQZH+lIs4MaKedGUgAqR1N4yDXj3tdh803cc508bXueSVx9rrmvRR5xzKZVpMoYExFGuVCF4ra0ePa4m/fKomUl0IoG1nVF+KEVD17T1r+jLe+9Bj5MSOC0wjdX6BJTtFNjooLpK3hb7WLjVZVNVVSkqsF8qFquh2xKy5hiroantmEa/NhW6SoRviyi7QOWaMK76rnLPkfLVpOgHy7+aoQuZO69B8P8sehyLgeD9fuFCAdeT2UJT9aRYWWjkye+q0JQwMDlJ8s7SC351skYh+Abbs233g/0xbiJWqtbR9IRfjCN1NaSA+JTBMGJ3u2oWZyKQGmiikwFfJb6OqJ84MaR7NB2RB0LvKG+AQTMssPs4ErZpGMa9Hu1XkuLyxatk7rjLso2T5k+lXa2+R4T9GrsprNTQ3O7ONpUzugmB6qEKltaSfxo4amUnTlCeOaPcG2e2AZchXqN/TA7J6mnrzS1PHWELlMsDJStA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> No creep, because you'll always collapse.
> 
> OK so in the 511 scenario, do we simply immediately collapse to the largest
> possible _mTHP_ page size if based on adjacent none/zero page entries in the
> PTE, and _never_ collapse to PMD on this basis even if we do have sufficient
> none/zero PTE entries to do so?

Right. And if we fail to allocate a PMD, we would collapse to smaller 
sizes, and later, once a PMD is possible, collapse to a PMD.

But there is no creep, as we would have collapsed a PMD right from the 
start either way.

> 
> And only collapse to PMD size if we have sufficient adjacent PTE entries that
> are populated?
> 
> Let's really nail this down actually so we can be super clear what the issue is
> here.
> 

I hope what I wrote above made sense.

> 
>>
>> Creep only happens if you wouldn't collapse a PMD without prior mTHP
>> collapse, but suddenly would in the same scenario simply because you had
>> prior mTHP collapse.
>>
>> At least that's my understanding.
> 
> OK, that makes sense, is the logic (this may be part of the bit I haven't
> reviewed yet tbh) then that for khugepaged mTHP we have the system where we
> always require prior mTHP collapse _first_?

So I would describe creep as

"we would not collapse a PMD THP because max_ptes_none is violated, but 
because we collapsed smaller mTHP THPs before, we essentially suddenly 
have more PTEs that are not none-or-zero, making us suddenly collapse a 
PMD THP at the same place".

Assume the following: max_ptes_none = 256

This means we would only collapse if at most half (256/512) of the PTEs 
are none-or-zero.

But imagine the (simplified) PTE layout with PMD = 8 entries to simplify:

[ P Z P Z P Z Z Z ]

3 Present vs. 5 Zero -> do not collapse a PMD (8)

But sssume we collapse smaller mTHP (2 entries) first

[ P P P P P P Z Z ]

We collapsed 3x "P Z" into "P P" because the ratio allowed for it.

Suddenly we have

6 Present vs 2 Zero and we collapse a PMD (8)

[ P P P P P P P P ]

That's the "creep" problem.

> 
>>
>>>
>>>> max_ptes_none == 0 -> collapse mTHP only if all non-none/zero
>>>>
>>>> And for the intermediate values
>>>>
>>>> (1) pr_warn() when mTHPs are enabled, stating that mTHP collapse is not
>>>> supported yet with other values
>>>
>>> It feels a bit much to issue a kernel warning every time somebody twiddles that
>>> value, and it's kind of against user expectation a bit.
>>
>> pr_warn_once() is what I meant.
> 
> Right, but even then it feels a bit extreme, warnings are pretty serious
> things. Then again there's precedent for this, and it may be the least worse
> solution.
> 
> I just picture a cloud provider turning this on with mTHP then getting their
> monitoring team reporting some urgent communication about warnings in dmesg :)

I mean, one could make the states mutually, maybe?

Disallow enabling mTHP with max_ptes_none set to unsupported values and 
the other way around.

That would probably be cleanest, although the implementation might get a 
bit more involved (but it's solvable).

But the concern could be that there are configs that could suddenly 
break: someone that set max_ptes_none and enabled mTHP.


I'll note that we could also consider only supporting "max_ptes_none = 
511" (default) to start with.

The nice thing about that value is that it us fully supported with the 
underused shrinker, because max_ptes_none=511 -> never shrink.

-- 
Cheers

David / dhildenb


