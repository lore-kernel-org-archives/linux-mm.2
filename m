Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73BCFCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 13:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3748E0008; Wed, 27 Aug 2025 09:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880508E0001; Wed, 27 Aug 2025 09:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721078E0008; Wed, 27 Aug 2025 09:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B53A8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:57:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E1881A069B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:57:57 +0000 (UTC)
X-FDA: 83822690994.22.0230FDB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8375AC000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:57:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=idoQPOQu;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756303074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0pMMKUGlgiVp4RUtrgX9pnDpZRGAoSX+x85uDyLNVMk=;
	b=TUcJgQui2jjxQ3RJCvEc1435/g/mGBSVEgafTP5svk4A0YF0wyHsvctBBiPu6MwaBoqzSQ
	n9MeBCr2ZT0GRM1ZH1tkJNJ5rdXtY+6PBuImkDD5Fjqi0/RzhghoIsWYhevWiGUv26RC8r
	ItQsOY0Ll1xPIpHJ+umJe+dO8+8opyo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756303074; a=rsa-sha256;
	cv=none;
	b=w9G6SerrJGgJ7Y6u1cyjE+4V6LXIIW8SAC1Vyb8kwxptjsUXuH8PikQPpe+FX4DZNp/2w6
	dQeHz5giK9Sw6EB5MeAaTDEJHyl1T3q90lsUBAq25+re3kuGy8Q73yXUSADYvHsI3kiLq6
	LO/Vdndp0MJAFeqpOVxw7AV+AyyQkXQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=idoQPOQu;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756303073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0pMMKUGlgiVp4RUtrgX9pnDpZRGAoSX+x85uDyLNVMk=;
	b=idoQPOQub5ZusdCwainGkOS3gmMBH2SOLujuEo/D4zrFNSFtf5H8k+ReD4KjxlPwbVOVdk
	OzZ/QCEEPN/mMDbiwSQ2AnkTqlZ14hxh1qmwbKO1GOfdpzzQq8Xcd5uWNRJOTG+avAFEBm
	FYi/X0yPf17g96k6S3JvL/WOuOymGNo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-H-03bjNHPb-hAa9MIAMpPA-1; Wed, 27 Aug 2025 09:57:50 -0400
X-MC-Unique: H-03bjNHPb-hAa9MIAMpPA-1
X-Mimecast-MFC-AGG-ID: H-03bjNHPb-hAa9MIAMpPA_1756303070
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-70dd6d25947so39604886d6.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756303070; x=1756907870;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0pMMKUGlgiVp4RUtrgX9pnDpZRGAoSX+x85uDyLNVMk=;
        b=KrNT/WmAqsxRcz2/ye1S05cycR4vCDMtsdF2CmOSt1bb2EIUbuX6N4w6LIrDuOSQF2
         oJrtgNV/eUunywHbW9Rw0IxpuGq9QGL4JZyxGeehhON6FGz5u9bNS5Gq3d1c3dCetqCT
         towxCuAqq3Xh72ivrBRxGxUXMoEP3voR6vMFgRYymOOKm3ecw+u3qXZIb0b+qUsiiySn
         wxWCI9d5+ECIP/+ZKxpusVV5m8us4+vEoJDBBfXVltglxuz2Nm2QzLyp9RTaCJNRXwY4
         vLYkvNdwRjk8oWYSv5T9qs8n/7Q+QgZDSNjM5/qI2T0kMjiTeK2ye8tHFFsIsc6BOK9T
         l2PQ==
X-Gm-Message-State: AOJu0YwSSEKfIGsvL1in/MW/ZpA1lz9+YXdVtp/MUYKFarpERywhpxzf
	nOxwxh0Pg4uF8w/9mNDmuvgXcoy3ioVrWeaTz4urRqWf5T/C7n/f2fyhg2A1HrtsxT9EPZ17Us3
	jwWwMTC7RVKDZ1Rp8zeRYrCUs3EQlyA/7rDvOnX+FiY7X7Bm1inTmzu/8rr2ovxPA4w==
X-Gm-Gg: ASbGncs5XKVlwnpniI9o6o3sPaJ3oX2BdlKCZfdI5mIdUS5Lwl7/RJU7l9eJDHIcSxY
	CH3n+YO/PAX9x3AwRidF+hlewLMa1+ky+tsVc3VAm552wqXtEQgJztRK1D0F8B69e4sagVkWtUe
	wnI/xHNltS/Ws8bP2gq0otIHejWeF+PNWCZed9QvUBGSC25GOJ1zvEzvtxLzWxLFl9A1z1xXLOk
	rVbtncIZ/JMsu+QoRtci/50Trd6JGFHM0dDErmhw1teAxOOnd/r44leSSuY0v9v8+exnkxlmvvy
	sHIrYIe6Necz4cpxcDsFQlCylW5WnxAHQJQkrqmapoA/M0cDIjSnjdmH/UsxwQ==
X-Received: by 2002:ad4:5de9:0:b0:704:f7d8:7030 with SMTP id 6a1803df08f44-70d97358f0fmr265013376d6.50.1756303069817;
        Wed, 27 Aug 2025 06:57:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWXjl5tZ83UA1+ay+aJoeZJMgZd6GNpXCtIp6lIpLZV6EWrRjgPphDax1GYOjslh+fV0VbDw==
X-Received: by 2002:ad4:5de9:0:b0:704:f7d8:7030 with SMTP id 6a1803df08f44-70d97358f0fmr265012716d6.50.1756303069173;
        Wed, 27 Aug 2025 06:57:49 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70dc949bcc6sm42209626d6.8.2025.08.27.06.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 06:57:48 -0700 (PDT)
Message-ID: <0a844460-d898-418c-92b8-671f6156a2db@redhat.com>
Date: Wed, 27 Aug 2025 15:57:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] powerpc/ptdump: rename "struct pgtable_level" to
 "struct ptdump_pglevel"
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, xen-devel@lists.xenproject.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Lance Yang <lance.yang@linux.dev>
References: <20250811112631.759341-1-david@redhat.com>
 <20250811112631.759341-7-david@redhat.com> <87a53mqc86.fsf@gmail.com>
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
In-Reply-To: <87a53mqc86.fsf@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _pe6CEq8zEla_ZkS-m_QQchhlHNPwOmmMNhw9Yjr7VM_1756303070
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8375AC000B
X-Stat-Signature: dkqtk3jhz1br4oj6gwf5ruax4dpr8ikb
X-HE-Tag: 1756303074-947665
X-HE-Meta: U2FsdGVkX1+AieK5Oc1tROkbXLfWW4ktxdkCjVSb2K8E81H2MXLSqDwBOChdJ7dWMSluISAtX5uheKMN4/6IczBvaAeTC4/c+kgASaRfc57ubFwHPuck/Lait/9et/2RsmJOa4R/PLL8b/Yk5MWew62kAJ+70rkgudf8+ODaWv+VoOOV0Fvp370ouzWFzFKQiM6rqTaQ4U+UQGJlzNSiuPCvBfIdPUhLo/Pj0r4UnXEbNWcS+uC5cnbXfdalg45ZFSK1FLnGN2mz9h/Yj3/aS+XqNAgqL/9C7BeR1R2OI/9U/iHd474A27Br6FWs+gbPEdef3GCE9uTQKdeP2MDUApG18irokC6L8GJ2FaQJy2Nxoa+nE9klPd2L/TOk4VPYiJCsirZ7HQc6vhGVOpDM6fzx7LM/2ylmf0uJYZs4+SNtT78anlPgTV5laeENwTFxvKPuNNrxPSpdAo4gXM+QuvQ8cI9baWYOYV8O+wNuE2SnsZ1oqmfRoJ/9VJTqH0vYMrHGpo7VOZ5RUocSf+GHQxXczghVU2okywz1nn/UNgkGGxUn/h+aQzoS1LZ71T/+em2zUrZPHMNnzxUT0rVZ5821fAKFXbUbbBgJ3nn96wb5a6fQg/Y6E0GlJdkHPJTGd7KhyAU3fvW2Jt3W0rleXFC5Zusl5uXcVqJEOeFX4jYMWiIgojlFiabEoYFRtr1rvOjrjanwpR04u2QFCP5ctF7/0Y5z5hX7uirq5NXAycYI5ZOWhrOyYfBKa/Lk4bCmOYIhLEZNSckldg8fisiEXak9aCgcUthzzLwzMyjq/za0kU9h7sam9p0n3niRsjVoX/aVWbaoZKK5TrJ/Psu61xIWaOcG0PzFKz3eoKp2iV7YgkbanmIDUNjZwU8YOlh11YzJef7HjFbuJU1anfNdlGvK3qEwD4OE4/UeLSb6VTyrDkvJB+Wc+OGshDJzaudy7umxyG7uG4uaNzUDFZ8
 csoYBLrJ
 qRhqjg+UQg6cPOZBQmB7NK32yZL9vHYGFJqoOl4mtMYmGDm+5HRTT+APkeymEGcF+l9CkvcdfMYtG6F2cJOIOFEy7MZ4zBI8uc+E/wg1AL9Ln4yEriUiqY0OU2PCI3EZ5A6PwgV1EQNqJcW/W9xYHl6y7YpXdMIPMA3w2h3M3QWYeL4Y04Hyp9B4zQJLjm6jLGsSilIm8GXT1yaIOWGO/ZKum0trjMQZvIn5fZ5Na4ur+5VoJjKmPB7veigYGPkdd19Sgl/7SVEr91uNtZUH2S4pra/mcw2QyOqXJRhIcovOWokj6S9oSkw4snSAAquGkaD8sENYPFQdkeUX3Gqm5DHbXCiSuExVW/+Q9IaJo7bGCTR7DWeJApmmeTPXLt1i+WdZSCNZHNFCD7/3rEGdl6aFqMJxJa436FLAOuUHrvUIpdmzzi50AFgNqmNN9QJOyKDtHbmksmQEGbHBAEYE1IGKhWPY0+vk86dwsFRZkN13FIZ5+3W3bDWBXQ66WD/pEnIdsplPXtd/nmo81OgUtX2pZy41kvWCa+FA9apHkwfZ7PvhIIbiLpmMHjm911761Ga+gE8yF0EEUR01m2RXlORtRT0W4fngnJ+eF4pYKuTl6LgfXCXDdYGQP2eMBlcUrvpWX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 18:28, Ritesh Harjani (IBM) wrote:
> David Hildenbrand <david@redhat.com> writes:
> 
>> We want to make use of "pgtable_level" for an enum in core-mm. Other
>> architectures seem to call "struct pgtable_level" either:
>> * "struct pg_level" when not exposed in a header (riscv, arm)
>> * "struct ptdump_pg_level" when expose in a header (arm64)
>>
>> So let's follow what arm64 does.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/powerpc/mm/ptdump/8xx.c      | 2 +-
>>   arch/powerpc/mm/ptdump/book3s64.c | 2 +-
>>   arch/powerpc/mm/ptdump/ptdump.h   | 4 ++--
>>   arch/powerpc/mm/ptdump/shared.c   | 2 +-
>>   4 files changed, 5 insertions(+), 5 deletions(-)
> 
> 
> As mentioned in commit msg mostly a mechanical change to convert
> "struct pgtable_level" to "struct ptdump_pg_level" for aforementioned purpose..
> 
> The patch looks ok and compiles fine on my book3s64 and ppc32 platform.
> 
> I think we should fix the subject line.. s/ptdump_pglevel/ptdump_pg_level
> 

Ahh, yes thanks.

@Andrew, can you fix that up?

> Otherwise the changes looks good to me. So please feel free to add -
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks!

-- 
Cheers

David / dhildenb


