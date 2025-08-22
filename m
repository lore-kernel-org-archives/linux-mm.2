Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75556CA0FE8
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFFC76B8008; Fri, 22 Aug 2025 14:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7AD8E009D; Fri, 22 Aug 2025 14:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6926B8008; Fri, 22 Aug 2025 14:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3788E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:11:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FA571402B4
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:11:00 +0000 (UTC)
X-FDA: 83805184680.24.DE58C36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id ED57140008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:10:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IWgj6Fci;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755886258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cs65i5/BwS5INh2iU3PXL6F11yYfHDlCfNAhWqRXwfw=;
	b=I7VDqKzhRuAgtZ6ccqeLZrwsZjFtinUXyDl/EchwXa3Q6/L5JctM8HInAisCV1pgsOpX3Z
	TVRRhm5C0vSpl4oDgC2qmWk99zMsm/33TRIA1v7ECyKPhE9G+23zzgEQ9t0d2rkicOZE+4
	huMw6TlnQbmgqEVKDHqcsqkDljTRlGY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IWgj6Fci;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755886258; a=rsa-sha256;
	cv=none;
	b=Is1WT1g8/Q6zUWFq6ZgC6iDbsTKNytd2/cYymramUW8GSzvnSaaoaVcIzoKuCVhkBQixqZ
	MvTjl9utZX/lx2gV7wkazrxewJZg08Y0abhZyoLBPp/bjG2E8V0LKcdpkmN2iyaq9a9U0f
	Y0lui2Q4vyHb+grs3jZ7KCuCziX0/tI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755886257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Cs65i5/BwS5INh2iU3PXL6F11yYfHDlCfNAhWqRXwfw=;
	b=IWgj6Fci9ElqdFXj8byMf4hxIXgsBUs1GfAurgb2wzF4VBWb83+rfw8u9VAQN6Gfo45UHu
	8n35STJv+8SXFFdHtS6SdH0BBxPPZCgHCB4rhX4kCf2hW7REbooqNSsT24jWkplEqYppAh
	6nlXEQcj+Vdpc2pDBdPhGBzzZFG2Y6E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-QX7Jfw80OIee5EWARLBSlQ-1; Fri, 22 Aug 2025 14:10:56 -0400
X-MC-Unique: QX7Jfw80OIee5EWARLBSlQ-1
X-Mimecast-MFC-AGG-ID: QX7Jfw80OIee5EWARLBSlQ_1755886255
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c584459d02so645118f8f.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:10:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755886254; x=1756491054;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cs65i5/BwS5INh2iU3PXL6F11yYfHDlCfNAhWqRXwfw=;
        b=fpzjMAkV40w7x1G5LaZaYqmj7MC3hA8YPjJq+F+1LQ7Dv9yZ/I0fpL9D8uzpv2oWyk
         u4cdsDHLpZ2o2JbGPavc/Yf8+rDdQAP3vZb69TIregRou8AuYxHpzTgR77ofj9bAUJdD
         TcJcZf1ACAn19VBz8aPXJFMtbgLcb3+0lVbrJye33FTdecnTM6AMufW8Y+MWLk0iVmf2
         OFCtrz7U+8pWGcGUOh6nR8T7ej+xemBgbFAJUBEziyZ2JJClE0qpIMArFK/7fOks9oFG
         ktvGuBXk/UJ2I/OIMqmfhS3eHoB5Hq8R+Ju9MLweo5o8xTbxA9AFh+dlw8t6JNShuQ8P
         hgPg==
X-Forwarded-Encrypted: i=1; AJvYcCVAf1J7KxJ0KEuaHpoBXAIe9pjxnsrKcDpcDhdtMtuXAHNFP2uYeZ+nKi3/AZ2HNqseFYS2wAIOWw==@kvack.org
X-Gm-Message-State: AOJu0YyTc0BR2cCUXG0WeLfMhHXXMwWqCTTFyKB03OHAAcC58sajexWV
	3/eO/NJuX6qjjriCvhsuxvvcDmGcrLW/a4EWHd3uVCThwUh+1KsjJvHCnbuMPtmrGfGmA1EL8cH
	N2f/JkOvIJYbQ9lWtNjm3sHN258dAIgkA/kvjHmU5qt3dUGIUmE0u
X-Gm-Gg: ASbGncviufaMNZLuA7wgk9DxI/qSgP5CBbgkdYH0hPvK9Pl3IpIWLixJNcMcuWk8EXp
	nmCdjJYZpG/QFylBnSaehjc5trsD1llmUkwdXP79btNmzJfbp3BPunzYadUFyuBDB32CkMH/xGr
	LeO39ICc6cDwS+KUIJ5SYzx0AHM2Ug6X9CQlYumIDNDf5ltbwaAdUWlrW7zX7K24utEq7msWm/T
	qHkwreWO2UHLpt2TbUUI9MPTa1aA0n3FI3TxW8wZQTGi00FmcNM7QXsOlyX5CO4JoDJlUuaWTB3
	JYh3YxtL0jdaQ5n/GVgHAt4knTAW6q9uKI9EUgE1/xkJCsq9SLznCFmB2C/9h5E6yBBSGm3mWQ0
	pidkpzfQEa2Z2czPycs58i9eCwPbFJIqS5v6EaTLfug4qoh0/VbnFVVEK7P+p+Z8dcV0=
X-Received: by 2002:a05:6000:26ce:b0:3b7:83c0:a9e0 with SMTP id ffacd0b85a97d-3c5daefc76amr3207823f8f.25.1755886254512;
        Fri, 22 Aug 2025 11:10:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFruF/9yLWC9qQiiSeqlnaZybt0y1Lc6OlpmYaNOwlaf7dspYYth5O1iwJEpGlFoX5TNvjMRA==
X-Received: by 2002:a05:6000:26ce:b0:3b7:83c0:a9e0 with SMTP id ffacd0b85a97d-3c5daefc76amr3207779f8f.25.1755886254021;
        Fri, 22 Aug 2025 11:10:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2e:6100:d9da:ae87:764c:a77e? (p200300d82f2e6100d9daae87764ca77e.dip0.t-ipconnect.de. [2003:d8:2f2e:6100:d9da:ae87:764c:a77e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70f238640sm404818f8f.26.2025.08.22.11.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 11:10:53 -0700 (PDT)
Message-ID: <9a9eb9ca-a5ae-4230-8921-fd0e0a79ccbb@redhat.com>
Date: Fri, 22 Aug 2025 20:10:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 29/35] scsi: core: drop nth_page() usage within SG
 entry
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Doug Gilbert <dgilbert@interlog.com>, Alexander Potapenko
 <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-30-david@redhat.com>
 <58816f2c-d4a7-4ec0-a48e-66a876ea1168@acm.org>
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
In-Reply-To: <58816f2c-d4a7-4ec0-a48e-66a876ea1168@acm.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BBFeJ9XsiDhst0Dj6Jtgsc47pK8shz-QsAUMXrxa-lo_1755886255
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ED57140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mncnmrwajowc81o9unfpdqfq859czxdt
X-HE-Tag: 1755886257-632017
X-HE-Meta: U2FsdGVkX1+TQhs3Hb38KAQ2UnP1nMmMaxaCDbNZc5Y3fdJxP5cszjXiv7bhKtxLwChwqI/97ELJicgrYNehW8lP5LoY6W6szmKPDOcjglBbC1NNK3Jv07xBufv7byeTt5FngZbACEMnumLXxlqAVlMzFQITASM/e41LDybW+4gGP7vJHM51Y9c6nf83NqctZkFgaIYEe3m9Q/G9bApdaQL6szX1odgaVV2PeC72hdduu7m4kETXXOd3adLI3WieetQVLibvojuMPtNmj1eP5vZgSfYgY777Sd8vYj/vhKpj6m9Fb0/0MGyAxFvXQkHDKoCmcpAtXeQkXxw2lvgZhF8kbB//OGpDx5sNX6f6+roQPQrPfW6GlsgP8khytPgbl/9WIv/MdQmO6uJbCS6OvxjX+jaXt9QTFZs+zRjXoCqJ0TCwE5nSNnYOgPle7IR8MzymwEEkONgiXaW7voKMP34NKpasEpNlXC2n2Nxs7flD2aW1c1Ke1z1iG4lujsKbwpKUL6tFpSuLQ8ltZ3pg/YJuYPlmqZ2eQ+HGPPw1mm7xiWTP9ulnVK8Z5bcMBMdioqgx+SDWGi7QPcCfqB54AJ3qjNFwZTPViFfq4Or84Vi4MwqopQ8VMgZByjbx0ckGh9V6S+YejlVSSo7qDXwzZmxcPLoengqku55iC1vTOl3AbM5UITksDQHQJFcRf5rjc2DidxP0m/zw6ny4d3IUF0J7U2Zur2S5cZJ5eQtUXQIlyUMKeViWTi9nBfz6yFe4TqL5/nCquf7nuvJSF+wFnf0jqftmOxynk77qLEHS45tF5pPVV1bgQ4D0nWRAeLhTnZeqEEbrsWCxjJvkqEvM3z9fV4nTTB2hid1nqR80eya1dw8nBT+7lU2qPwiuaCCn54B2XMkeTrr9IEA7Qs7lv1aOq/upB9SoMoIQuW0tZykQaYicuKiqQKnNt+gD/C2dujbWBibC5Ms5U6HpcoT
 Vbzr4D5J
 mKn4i8n/lFi2YzY9I22t/lyHi7g/OCOUYY64HffZyxf4zI3tFUkXv0cFZw0hr1tTXXRWfy/IzKW2VStxPs/+ZtrF+eo7rAL9fe1ZrTOTl67H+ZjE05vKdezFUwRbO3NAC4VJHWvFdvWhZ6lDUxdRC4CiNknhj4zfqcu5ZYy4O37LxRUSbZjH2ldpKdC95VWVMrssqOFuzAH8N3doCYuilvRPd05K+YfrZLIhSp2GzVtq2ZkymcAKt8Y8mms+gXh/Zw/XdNBsCemJJm2jd3DxSUFhjzvfieegUK9LfjsGgbFRZqhxm0I8sQNTiXtMQTV5rnFzNPd9lHxQsgheJW8NtcANJ+tvAxcR/joGuwRrmTBWUHaJbMKddofyAf02o7zi1U6FF/eeqqWk809QI3Z4LSA9lfXL5tbhpWH5CMeJhsl3nVQAOPI7ssFAp7SoggmCeyEAweoki2mqllnvw7GXdAVoY1IwpnIJ6hYku
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 20:01, Bart Van Assche wrote:
> On 8/21/25 1:06 PM, David Hildenbrand wrote:
>> It's no longer required to use nth_page() when iterating pages within a
>> single SG entry, so let's drop the nth_page() usage.
> Usually the SCSI core and the SG I/O driver are updated separately.
> Anyway:

Thanks, I had it separately but decided to merge per broader subsystem 
before sending. I can split it up in the next version.

-- 
Cheers

David / dhildenb


