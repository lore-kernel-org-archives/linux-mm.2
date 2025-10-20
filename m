Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D45E2CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4498E0029; Mon, 20 Oct 2025 10:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3846D8E0002; Mon, 20 Oct 2025 10:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225B08E0029; Mon, 20 Oct 2025 10:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3608E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:19:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B01991A01C4
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:19:19 +0000 (UTC)
X-FDA: 84018700038.26.11AEDBE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 59BF9180006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:19:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F2UlWDd3;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65btNgY1S+uFcA06CrNMMM0YWdZBYxuJXH6kRyOL5H4=;
	b=3jn57ABzLuvpvyAR8fA8Z2oc3s7lLL8NT4z/FgLJQi/yzoRqxlznMR0ZCzrc1cYzd4pN5m
	CHXJ0i3X3WliOyvi4FqlrtRBiptYGRIE7C/R7BHh4o32n/78KVUr+g5yaSH1ZJ4XVFD+s9
	yG2Sb3K7iUpEp9nk0hTZumKaBs9ccgc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F2UlWDd3;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760969957; a=rsa-sha256;
	cv=none;
	b=5w4NCa+dls/1zRD4Uv0YAe+TPLoYpvW19ltdKdgCbugDeWB6gg+wj92HVTIUXkpi4A0agh
	y+qrFAPDm0fspzVn19+4amZvbn+qTb5bUVYp7K0rOP71wJArPhbKMHsH8SDdd4OD2XiHtt
	qD8sbFWFZEzvuayaXAas+h6022dCegw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760969956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=65btNgY1S+uFcA06CrNMMM0YWdZBYxuJXH6kRyOL5H4=;
	b=F2UlWDd33yHk3Dq9f92LIjJbSVW3FLaKBgV4Yr0IvAyuRk/rhUCU0ERgBnGyBaJs/0JhnO
	ZEQjHl6PuPtuRyGuJLydhi4rhmrRSET9TLu6ev90fbbqbXIeXnx2SUKC24TUiDvFYgjCDz
	oL/5rHZIivYiTyb5tKZ5HQPyna/4a00=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-AU19UJa7PEaHJhBv8E3Mtg-1; Mon, 20 Oct 2025 10:19:14 -0400
X-MC-Unique: AU19UJa7PEaHJhBv8E3Mtg-1
X-Mimecast-MFC-AGG-ID: AU19UJa7PEaHJhBv8E3Mtg_1760969953
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f924ae2a89so5445225f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760969953; x=1761574753;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65btNgY1S+uFcA06CrNMMM0YWdZBYxuJXH6kRyOL5H4=;
        b=azc+kaEzx1cQS3AiQwnSmLM0IgisEayEObEmtMbdDQQvrpWZnNnHMtWAgWIVUqdxfB
         kBxEGHWlVQEldQi1mbFGZkzlGFOagSatBhk5alxwM/ibUjc9qihCi0f4aAgOfPwa0xcm
         B8F+Pfrvl9XJrBWjdqpqiKtejDDgVWdrdXIdYiFftk22rDBwhY8fefmhg567GPe/YRjG
         2l07Noq0m+GGpvVKPg5FBT/LaCs1/ZZDmtjCVqFHdW5hCQroE6EtwOO4GZJOebruw1FR
         ng0B1NmH59iFDIiRQSCuiOpJ+DRaizlhrTKC0offPzPQ5MRrVk35ga6zMwMiHF71NdC0
         HN4w==
X-Forwarded-Encrypted: i=1; AJvYcCUp2ZPJVxtb/eWlH40K/7bIBJ/LibmGRFi1j8y/+ecQ9aI9VyFJWqllVrS4yXkMSF+2a3v4aZbxww==@kvack.org
X-Gm-Message-State: AOJu0Yy1syanj3wBV36+t/GN7+EoBZ/z80f/HOIyTTgBNnqzBOfsWxQl
	vRqMEWPsbOqddv/OBpnG8T8M1V8UbJsi7nqN/WUNkus05kasGQiFtBO6jupBtd59VkMPaCZ1FLV
	Y3wMK4PlkiNASWG8k1y9+cB36xNu5aliGJnF6Ntyn7DCe3KoHIL/N
X-Gm-Gg: ASbGncsBTdd0KD0DOBA+6bzYAOBi/NsB9830uyHOKLO0XIXdTWqDNyYZk1payAwVx0q
	Vm8EGgScTsHWHPqXuPVjcbfNpQXSWdeuuhmUyf9uDPUwjLqx40HC+GByyrdpjjA7dyBAApiU4Xb
	ckjpYSkrSLSQx4g62IaODTR2tAfmwhWH/cSLI9iki4//M2YkrBmymuizmZfaM2quRGt1QShuQu4
	4StLSv/ESK/QMLEUPRZFeW4kj8706JWPsS0phk6onE/c5fQiQQA9WLi4InctGnViEvgrWZnQxuK
	foJyYhWERrKmtAy32mlK5aumvwZ7sfpVdF3tAlX+AW/TxSM+AfIy0K1z1TK/UBY/MAJUm4Y2OsR
	XOboY9csSfMQXZoZBKy29RW0ccsPxDYOQkLO12ap88Q2MygGIIgseEpM5RmP24gt0Sp/a4JtNTO
	jyMjFlLU9IKbmx7DReZNeRkhBB4pw=
X-Received: by 2002:a5d:5d02:0:b0:3f7:b7ac:f3d2 with SMTP id ffacd0b85a97d-42704d9b22amr8367714f8f.43.1760969953321;
        Mon, 20 Oct 2025 07:19:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIQ86tVQBiVUCtXtty92ZgvqJuklg1r9FrAW/HfWuTtSRsNtewiudoCqYJbGF96Hka/1j4mQ==
X-Received: by 2002:a5d:5d02:0:b0:3f7:b7ac:f3d2 with SMTP id ffacd0b85a97d-42704d9b22amr8367680f8f.43.1760969952867;
        Mon, 20 Oct 2025 07:19:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0e9csm15752758f8f.5.2025.10.20.07.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 07:19:12 -0700 (PDT)
Message-ID: <dc0587af-5054-4da0-adf2-20aa5a10d40f@redhat.com>
Date: Mon, 20 Oct 2025 16:19:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm/hugetlb: Support vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Vlastimil Babka <vbabka@suse.cz>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins
 <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <20251014231501.2301398-4-peterx@redhat.com>
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
In-Reply-To: <20251014231501.2301398-4-peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sgzqV5JQbKJAqLi_NnOTzraFt9Zh6p9jXKzE1o6FOEM_1760969953
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59BF9180006
X-Stat-Signature: zuqsecpkp18zxu7nj7w1aox83z8n6d13
X-Rspam-User: 
X-HE-Tag: 1760969957-509766
X-HE-Meta: U2FsdGVkX1+3N7Bhe6Z9WkvQWqcg8lUFc0QXpfV1uG4iSxjAkVZlU2g5pEWoUMHS7zFU1KtRQvWYCqiV3YnoVZuXGl6G8TlOCoeCYXmimZNXPjWi9TFVYpZ0oW2oMHqAk67tO8jJg3mGlX7y+sU7PfQAfW9PddiMvITY+/mj9RmeQ+PYD9ubbLeA5+lLoeFtLQ37Yr0DjnKnfIWQwy+6Aro0wlu3vN7WQ3KuGjjnych9AohQCd8QQQCQK7fYVaYvzOo9PNX3sE7OB7OxLx4nyX4f1KDKqtA8ZDgO1vaLgXVFkHqbIAGF/jgIqf0ZqHSQWxkmF/BceENeE9V5SG/UnRuRqzORgGq95Owx2WgNygVBd3Ipj+XEFV840u7XMK/dAz5C4ZGvBkHKYbJiAuH54eD8n/sBdAHeHNKS8IL1TS2KXTNWXZdAXK3yFTgxYOEmGCB2GeX5m1JbzlYLlZnpLEu+FXhEOqCycaZXiCTsY3KTu2HRUVj7gN49HzlYzyXNPKArMQvIyN1hGfhT48OyPXwTlNvyk7aRIdxcceGipkRyYzZMINgwcGT/jOcudIafFLG46dIZ/CgGySvxaY7mqabIo8Wnus7wtxi9HgGMi9+SYV3FRof/n20O5Eh+iRxN5j0kj+/SpDHaV5BoRHqaG97zIS7AfFSprQMxfXd9Kqm2yftFn5OprJavYtB3/IkmM0yi4dRfGQdPUsMSN992BeccJLwGKqDaZ51u1JnwfRB34xU/DJQifxBtO4jpKN0GeNuWhCmKlaXdu74eZpD98tyROHbt8Uop49oy9G45gyPS4lmVgkggXwZOuxJspYBpxgoaZYm46aiOHIWi++13Ke1POwodbGidVcJnfoDIxigK5oxIbYCjMBNkj7oRVjYLtEYIqHj1C1v/OAZEQDiBvkQPqbSyuan/Fvwtal1KKiOX0HnEt3AzzfvQYIEmcIga7DLVghVKTiw8gTRy6c7
 R/3WtmOF
 eO2AgaEhBS0WmOewBCqagGJuK17GN4UaNJy/q+JoiM/yhfc2m/uPf1cnHaMvLS9zr4LTel7ngfnIkjtYciK2dFlGdIRQxJPLpcj6Rh38PhQURO+t/uDTZi/pReDHe2s2IuKwDeWrr80YU4u+6zmQRL2G9RiaGqllH1WWZR81KPqms9WyPMUWyMTdscybUcWNW8Ke+bE5sUsP4yesy5z0VEP5nkL73acHqlbtf3DO/XtfBAl4tCtMHS3tCNNkMZPhZdIdAM4lxnRsk3DNljimFEmNJ1OxeQlMvGDIwGV29VrKIdiUDEH6qt4A5wI/0v9XJZjwkVCNFspuGQTBeyGlZkCBXH1kXjuUJ0lcdFWtzKnZGxskLJ7QBAe5TCAtpREK6gleZLSx0vHMJycCv75Xgp87HdkaeFPGQKRPJ5wWHy9pvCUupjSvBHhPbKb8gTh1r5UkdjtDc+2aym7AMZ8xWGyKBwYqK1cpE4unIWk3j1S0Dik3fp6BeQBpfwjvK8cJYrPEf+IAeHsOFu0R1o1ICotSPt3spyLNgkOx4rjJuobfkIcQBOFVhiS5gFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 01:15, Peter Xu wrote:
> Add support for the new vm_uffd_ops API for hugetlb.  Note that this only
> introduces the support, the API is not yet used by core mm.
> 
> Due to legacy reasons, it's still not trivial to move hugetlb completely to
> the API.  But it will still use supported_ioctls properly on the API with
> all the implementations still hard coded in mm/.
> 
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Acked-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


