Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F99ECA1000
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 10:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C406B002E; Fri, 29 Aug 2025 06:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8038F6B0031; Fri, 29 Aug 2025 06:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F23C6B007B; Fri, 29 Aug 2025 06:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2B06B002E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:10:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E91B01DE53F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:10:39 +0000 (UTC)
X-FDA: 83829375798.27.B5B4FBE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6818A2000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:10:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DlCqGzux;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756462237; a=rsa-sha256;
	cv=none;
	b=H3NOBZs1gTKlumX/gO0D+oLGWD2HcWl27+zQZmUH/qoDlDVqopPh9bXHtbc0wN0FK3f2t6
	QHpbTm1tovLsyGcvysuI23n9N7ZQkLsNc21Ohrqtch4GuHVQ8DlFRNFaBfCuCHpfGIP/5F
	QHbxthxdhGSYDAqvoVSXWOGCZib+Ra8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DlCqGzux;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756462237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utCrFA9SyGV3mLz3PcpHz6c/4tyzaXDXayD3hFRPQRM=;
	b=fXJBVFjAc10v8VNjcAUn39nRXHgNob4wwAPxXvdHy+8aAEA+XelPXPLhT4EJmF/F+P92bT
	2TD+seu7juBF0I/srNRptOlF49rBV8Yi3WE9jPEidAsB+ex7es708Wa7nJr2BbjywJorMk
	sIDes5cZsW2+0RAe6A/5SrWzfruKdY4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756462236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=utCrFA9SyGV3mLz3PcpHz6c/4tyzaXDXayD3hFRPQRM=;
	b=DlCqGzuxpSUnEC5RbIm7bgsWh8H5Kkgaw8NA8Aklb27ibHHlzz0GsbvTp0IqTKAD5paVIq
	9PyirXekDKNsrT7Zs4X8rFHduUyL6MVYFJ+aWtqO/B86od4Ci/XrErWYgtcT6mbadxU//Y
	mfAxhuj58AjdWgmiqK1B3mRedRTBEAE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-JDjEnyyvOAW0y-avW9biwA-1; Fri, 29 Aug 2025 06:10:35 -0400
X-MC-Unique: JDjEnyyvOAW0y-avW9biwA-1
X-Mimecast-MFC-AGG-ID: JDjEnyyvOAW0y-avW9biwA_1756462234
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3cef6debe96so560558f8f.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756462234; x=1757067034;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=utCrFA9SyGV3mLz3PcpHz6c/4tyzaXDXayD3hFRPQRM=;
        b=bUwuClLTwmscs1BdXFIhEeRaAAD42KEUM3jjQbpwi14w5RvIZQc24hLq2LkmtuhxIK
         XT6hc94Hs23qEaaLm12qjU+r0fszj+BlqTA8LchoKg6yMSTP/N+2d1kNf1fH8xaMkpXL
         YOx3nGLM3V+hUKCWWXcyEH7Nb+lILsadbIeg2ybqdNOpHsvE4Q5+5+pBth+RTxjADjEK
         sP2tkRhr4PNCc3Asg3up8fDgviRnkYDlA9h3n80Ca09oiBJr7a9NilI3kLWNqtho603Y
         x9ypfnbdnz4P2F+rVEw0WfrtiA5xwKtu2LASWJrvaedw20mMk1IVyyp4/rsqrzGsNPD4
         UIGw==
X-Forwarded-Encrypted: i=1; AJvYcCVx2rplKvwuWfdtnT2t0jKu+jK/oTApAdvwG2LjpTPlIQ9L2DvEnnCEK7APqXQjGYWhSY8mCQk13w==@kvack.org
X-Gm-Message-State: AOJu0YzrLLUQ+APjrd/mU/3Kq7SwoP/DiSHJkA8coKsoYzV7+S7WR/Ce
	v8T+Ns6ZZoUjpz/C2TXjYo1WknoZ4O7jXhV5gDIPN0J0CQpctbuq9pK1HnNkgDaINuRRHPc1Tc6
	HXYIee99b1/LVBRNgF9QGMA3spFbosIfC2AitQLx5Qg8+CKRIVDgO
X-Gm-Gg: ASbGncuatGCxH7iCVOMIbdEQIs2fmmhv+qHssIrUEKDD5LbTTjOtLJ+N3sCzc3dZXJo
	2tBQqMNIwz7VdYBIYxE9iFFD6tpEXB7sOghWcSJSITuxske+O1skvgqOc22/rVjENz+hB19IH+1
	j/KzbiUI7k4k5uGdGLB7pw8wtI5IF1wE4BpMSG2hRPfRzoAU9NNQV36qKIOik2GN1poiAfvBEtJ
	P/L/Z2GcvgSaodp/HGPspTFlZNAc2J4iuW0q9j1UZlph5QJS6isg8LQF+3Oz7doKKM+5WNK+eKQ
	1i4hFPI5TI9AkA6T5XJv/Hi5q0fiJzfIw01YhMmD9yX5DfGRePNOSxk23LIe4lGMNs7Iw24ub3D
	TLt7/UuJlmU/nyjQCzzFNsaxZoKziE9Kx04QJtm4s25ZKoEClLl9QasoxdK4Ozvvp
X-Received: by 2002:a05:6000:4011:b0:3d0:bec0:6c35 with SMTP id ffacd0b85a97d-3d0bec06f52mr1040132f8f.34.1756462234026;
        Fri, 29 Aug 2025 03:10:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5N+hXboXv1Pvz2Dg0jTDmYwZsPnkQwUsFPtQ8nUdHm9G3EJc3XR4ExkZX65hTeoyT3mXdJQ==
X-Received: by 2002:a05:6000:4011:b0:3d0:bec0:6c35 with SMTP id ffacd0b85a97d-3d0bec06f52mr1040061f8f.34.1756462233448;
        Fri, 29 Aug 2025 03:10:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8879cesm31221455e9.12.2025.08.29.03.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 03:10:32 -0700 (PDT)
Message-ID: <a9b2b570-dc81-43dd-b2f3-a82a8de37705@redhat.com>
Date: Fri, 29 Aug 2025 12:10:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 10/36] mm: sanity-check maximum folio size in
 folio_set_order()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-11-david@redhat.com>
 <f0c6e9f6-df09-4b10-9338-7bfe4aa46601@lucifer.local>
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
In-Reply-To: <f0c6e9f6-df09-4b10-9338-7bfe4aa46601@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hNA1Zv64YB4-TexC2MioOHJ6o5ODFRqB-1TqJOjHS-s_1756462234
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6818A2000F
X-Stat-Signature: oqhx8zxgwk835djtcquek7x5mz8ueyd1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756462237-609283
X-HE-Meta: U2FsdGVkX18E4QOECv3UO/kRXUrSsvuPbG1yizCMczbBSFbnCuNlOmYgmGeJD135Vg+LDwG86nSyVVzqPBFjssh5rwq+QRovCjFFqdW5daZbgtndwG9n6D3hZ4m9p/M+iojPivybf8TgAqsVOUZ3tHNgYOdgDL2i9/r59+stOQFMkojA94stmWMXk92aj5Y20rm2L+qBgFczhf9noP1mQ7M/aiU9VEw0a46kYsHi421l7rMncSOFuD53k9lXsD20IrO32V4b3daqk7nZEPNFXCZu5V3IvwIWQZwLJiwrnBPLvl6Yfzx6LL0HkM4hodtZ1kQ8m6XHAQ44soZuCIpSkze/qkDXY1PtzVnW1ojhAWM2RmrZqro06KbT5434mAIIyq76dGmfiGIYDtevNakbjEnWTz9bzSRoVs6phX2LcprW7lOXQy6z/J8onm1CqSi+WXTG7oW1cvDbStA2Z3ewylClvkHvSNaE2Dig5aamBlHlEy+EhCPikbcfrc1bViW1nZN+esGaYuxHwHO0gnFJwH4BJyL4LTTXrKzoqGvf38/Nf/Vi3PQKR1Xs5RFbuRhaibuPsoCQ/wBT6ugB54IB2SvLbbumOnpX6hQiCBeN6AOPXrj8FROTcSIRCjA2m3hN1kYfROfJWxJ67utZNX4eiyB/jq7sIyilJT+ZyTsFIWa5SVSmKxbzrX138RgZpUCI7c237TkcQJ/kjBtTL9abgs39unn2kpd9C0qbZ0xcJ8M/tpHZx6zl/5FuDUYB4f+rUVwUlDmO1kpu4EQMfiejKsZFxiUZlmYCfTgmhNWrbrHWWJyGWaPCqUqU2d/YiAkIIwUZFqrglaXFnodf32cS5QPxZqdTrV+bj9ugjze9NQ/2keQYzLgNhhNd7yAiQe7CF0nhA944nMqpUswmRYpQpANIBkODNp4j5FM+q5b+OqhFMkKW2AA5JQvB5j5cu2sBAwoZ/Bo2aA4cOuO9AND
 7vBejPSo
 W7vdUTd6OmqD02mVGXQozf1cEzcTrKf4zhMnHmBeni7Fl4dAhUZc4vgKIqoFSooQhueORlkjB6Rxuix9gz6f8jpY0Cc458in+zXO4BaX5ACm/1Ebixii236Wds3OjxpqNROJUZuPO6g1zEAS4hsf8Lo0kbXVrtZCv1P5GuEc8cnR7+tl0eOL7212wmlbwbbgSWi843bicfrUKqFXMwBxu3oA4kVPGocLrIFoB5+beMy2FOSPjdhMQoLZ7z7XpGzUiVFAlBMCvNuq1Py0lh3TLnOwAWgfRa+mNb3Zv62cNeS0OXOQiprcs1A1Q2UVACSuTeBFXKjcWWDsCMO3gLYuVOrgUOM3fBQB4gN+s7pZ7VC56UgTjnwk2pAB0eRBY9MT0aK06NucJT/fNUgSqvpdOCu3N4S9zewZEyNWgLgtM3pCoi+45bJ8Axp1mNS5pojPQ7Upb5i+XSa4wll0WzwexwALt20rovlhRIBUZtgz0ip1RfrD15F4U43dMdjzle7NwZebF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 17:00, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:14AM +0200, David Hildenbrand wrote:
>> Let's sanity-check in folio_set_order() whether we would be trying to
>> create a folio with an order that would make it exceed MAX_FOLIO_ORDER.
>>
>> This will enable the check whenever a folio/compound page is initialized
>> through prepare_compound_head() / prepare_compound_page().
> 
> NIT: with CONFIG_DEBUG_VM set :)

Yes, will add that.

> 
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> LGTM (apart from nit below), so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>>   mm/internal.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 45da9ff5694f6..9b0129531d004 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
>>   {
>>   	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
>>   		return;
>> +	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
> 
> Given we have 'full-fat' WARN_ON*()'s above, maybe worth making this one too?

The idea is that if you reach this point here, previous such checks I 
added failed. So this is the safety net, and for that VM_WARN_ON_ONCE() 
is sufficient.

I think we should rather convert the WARN_ON_ONCE to VM_WARN_ON_ONCE() 
at some point, because no sane code should ever trigger that.

-- 
Cheers

David / dhildenb


