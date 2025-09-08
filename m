Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B358FCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FF48E0003; Mon,  8 Sep 2025 07:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37218E0001; Mon,  8 Sep 2025 07:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26F48E0003; Mon,  8 Sep 2025 07:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C0D478E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:44:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C285BCF4D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:44:09 +0000 (UTC)
X-FDA: 83865899418.07.08E00C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 126AC180002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:44:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Awyojhmd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757331847; a=rsa-sha256;
	cv=none;
	b=LTXm+2ca8n3KtW7+VR7FHjM7dS2aNyIWshyA6qYrH6ObyOrdBtSJwnKlgIb21vMz4VPjK+
	pjXNItVIWvGtn7uP73Mnt8qKzLbJmfSPFpK6xSqjeGPNH+ZOlNlUovC60cIOoOiYP5tHJt
	15uPVvAb64xG2PuZGMxylwqKGwVui4Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Awyojhmd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757331847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmFdD4nxV6YC4HJPP8iLyH9DUD7av90TuxW2EMz1tUQ=;
	b=GeDig8xQmdnbwYv6Cdutznvhvkm5XxKu8UNnMSakedWKs/ouW7VTEUfYcMPgvcH6D2VQTG
	xOjTh5LMhHlF81EGUY0IJzvCRQignWyZUCKkzz+SM/IgRYVi8VkNWrZGxLHY3xmyTCJMK0
	0fJQRzJphmqI0AXR1lxC6gZ1kQi9GFc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757331846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CmFdD4nxV6YC4HJPP8iLyH9DUD7av90TuxW2EMz1tUQ=;
	b=AwyojhmdAEPFcy8rhRaxf3H0oZbh0sQ0vg5WCv4fOJXzetby7xmULPCz+2HsUABQk9xqpM
	nWzKMlixCDXutlr0aXilF9h8br1pgHbgliwuVoAJ4TxUnCFCRxZ9X2yrDKUEB/csu7qEi8
	KiAda2pYe5XSq9pZlA37nEtxfpnek5w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-jNWQ8Li3MzaLKdCXRaeUAQ-1; Mon, 08 Sep 2025 07:44:03 -0400
X-MC-Unique: jNWQ8Li3MzaLKdCXRaeUAQ-1
X-Mimecast-MFC-AGG-ID: jNWQ8Li3MzaLKdCXRaeUAQ_1757331842
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45dda7c0e5eso24550825e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 04:44:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757331842; x=1757936642;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CmFdD4nxV6YC4HJPP8iLyH9DUD7av90TuxW2EMz1tUQ=;
        b=WgMspeRPVyXBupGaxlPITSX8BvOmiVOwLtN5/0HUEHJJtHG6Bj/KGpIKesf2vPa60/
         Eo77UiEsOmhT46Yz/fJ8v29+c1cuZULxU76gPQ5JYceYTQbCMMvioqMmPLUoPFGw0UAr
         PmxVqDtlnyoaEOfEn4uQhlWzUqG7UmHWoTo9M+ZqE9jdDqy0kZMAImTeJjrt2ywy6F+5
         uP2QYiZ4RpAKoNuQrIaxTRYbQWLtP++2ZoC0KERqFXhanCzVkJFNKbAgpSgKaV7fvJxL
         fuafMI4B9p99JQMCDdEd42PXI7G9J+uOTF4WoCX4gKcoyO6YF6KeKOwNJOvN3mMqJLku
         dWvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGPkKAZ01kPEUliUHFVozjlv3+lYYBfgWKc9BoyIngZgNCXP/mi1ab47oukm4ZhLVdtWybjWkeJQ==@kvack.org
X-Gm-Message-State: AOJu0YykRqOHdY29KK25zso186BGGmDi4mzFzdOEG5AyeYitZWPtzUkQ
	w9txUmGSNFPTEKwaZISVdwGjbx2W1Wy/85y15E8wpcp7pt2DckDtASnhBi8w9/iQHBuHnzNmS0T
	jmg+wOy3F4G8FbIEHBLtH1+xpSajFk/PC7uolfYIgeFYMIpRZsxj0
X-Gm-Gg: ASbGncuROjCXW0MegUjpSwjf2aBqrscZ2qixzPQZBZMFfDzGd8UJqCvrBkTWYVJd/qX
	vKLzDQbd8DozeXS3fRQUx3XOAqoiXyof2jI+89t2iOSrXH2+eKPOYaAwhK8qcBIRbmFVkP8JeF+
	Iq/EKY3G2WtSx1qfaV9rKqaGvOR7l+0iv3GKN2Ttt2j2BqBgtKpas6eK5p7HHDAjU//GXX37FUb
	xHAG6Ugtn4Y3fQQwLO9SuxyadFrrAL53uNYmz73i+faUYRk7ROjuiCWtVpooI7kN4JlFPVzFZZS
	+x/9S4BA5MFrzPk0KG0DH/xnhGksq4ebBcO9Ib7E80C1zatWh16KmLrqWtzZSGTRX9mFC9aF1PP
	TkLrMxFSqYGoR+xirVwRV7v39NEvW2N089MKJi4PYTL2LIzKAljp17OX4+ZHl52Az
X-Received: by 2002:a05:600c:1f0e:b0:45d:e326:96ef with SMTP id 5b1f17b1804b1-45de5557e89mr35555035e9.15.1757331841950;
        Mon, 08 Sep 2025 04:44:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtBSAgOCpmqTXUYDC4XOAO5a81XVKsZONohNsCKy+e2Mdrkk9gBTpMEGZ9PIHtxa80WOMjqg==
X-Received: by 2002:a05:600c:1f0e:b0:45d:e326:96ef with SMTP id 5b1f17b1804b1-45de5557e89mr35554775e9.15.1757331841536;
        Mon, 08 Sep 2025 04:44:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3deb99d10a0sm19732644f8f.37.2025.09.08.04.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 04:44:01 -0700 (PDT)
Message-ID: <ca6c572f-e63d-4de9-895f-2da4a2658c46@redhat.com>
Date: Mon, 8 Sep 2025 13:43:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/15] mm, swap: use unified helper for swap cache look
 up
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
 <20250905191357.78298-3-ryncsn@gmail.com>
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
In-Reply-To: <20250905191357.78298-3-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mr0nxWzst4rgVs7PbqafLcrBBB-34KGtCb5VRfD-SDM_1757331842
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 126AC180002
X-Stat-Signature: so4m8dciqe1qftiiaje49uacm1q88ort
X-HE-Tag: 1757331846-374016
X-HE-Meta: U2FsdGVkX1994n8LBe3AV8BEsKKk8LMg+F4Q4Cgn0oB+I1xqxJmv8RE/ws2oC6MNTomd9pXYTKgnPZRYYintDBPh14llZMWvIcto26yQcJ7YeHiz99pv8QS8QkQu8jDgS/Nqlxs9HyRnGkZCCM0+ehJy731TCEmkYJJUcalSAxAgO8WZsPswEWwk48JJ7DuoyEi4qOf+6KoCEF0ruu1ys62E/dqOms6RWpuYLeqC7S1FIOCupix9ExT4sGwVMXiuyUROX+q59baJRCJTUQHK0mVBg1K1j9N2u6WCT0ZICip+VChn1uovTWC6JOv1zSCqBw3DrrFt5XkbMuWDI8b3KWx53yTWc6fbRQp8mz6BTJbRydpJPw8ZwSIdvYkUTva/XhtjFtsC67hgglA8qADqMlKC69PuBmw2I+XBKMgNaXSWdqxve5GawHsvwVSEPk/hcYtdGGZQRWIPAOyaASQL+eZAa8hKPKhIJ0QsoLl/nHzJR5Bg0ntx9zZD+vYMN/ioyZRpHVgpR9A9LauIlvDuVM9b/ybdtIE25gvpoJPnPI08uxeZK2EYwlYYKNjz1rB1DelujS3/Nxqf3vhQREuf5rqKQD6T5WAVxJ+GLUqlY31vnSv1tk52UZBOJ4oVWFV+MzfAZYcEo0WHbcXLGG0db972/kQTKP8JugNsB96ychyj9cPoUgvVgyeUGrc9iB/7a06pOTLLOfAa6vkjgtyHVNl3QdJP97DtoN2b/oYdVY6baq2BOweE7pDHU7abAh/he9t5SqP0QNTSgYxiiOy0ilfcXuG5Upmbkkg709/az4Eyfqyj1X+wj5S2Yw9+xyBCuvuZGog7kYMcGaXFsnv9z7XdRYt6VoozM/eyjh2qR2h/XM8Ol6WxaWrBpfLRj91E1IQM4ArR7+fsmW7Wc4/LaozA2J0FUa879Fwwh4RieBjHFtR5SlKwXGCvKkKB00LHlXMmib93/EVl5hHI6Gp
 xtOoohGd
 QcOh0asx9jcECtHlCc8NxerpQXjt3MiAXFpCfpUadRbUz6mrYD2qq/BserKfd6lPwS4d4fTIoX7jbvXhNhLeI8cyYxssAS065mQsmLQdssnNCc3qlhvNcg10rTdHUMTHxToLHaDu23RbDZTRzEoN261OI7DI1rLsWSg8LzuniCPTwf0vCAziR+U0CLQqgk2DDhFpC13ZGPWRbAKmutKXDWLW9JzA+VN4qFKZ/oofoEUAOQINaP5gC00rIgWPt3HZpQ6Mgns11q7e2gNLQSIHduHC1oZWsrBbBATX+5pOja+R27GFeNxTHw2+YmdS6qaBJHv94GOQ7hp5EG8w7kRIQFpd1rxg0pJsFtKWWOCUvrI8vHBmYVFcie436TnwjXDZi6oPBMIElcngwYmdZXb+yMqFuT84r9i/Pv3CdDEatDcwDqmpzGh6iLtqfgJFWcTfBDraNaCqRDIezUbU8OVsrO6NxmuT43jxDrT9XW/ESqR6ssAQ+K9UkTbK4qRebxZ5Mf88k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 21:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The swap cache lookup helper swap_cache_get_folio currently does
> readahead updates as well, so callers that are not doing swapin from any
> VMA or mapping are forced to reuse filemap helpers instead, and have to
> access the swap cache space directly.
> 
> So decouple readahead update with swap cache lookup. Move the readahead
> update part into a standalone helper. Let the caller call the readahead
> update helper if they do readahead. And convert all swap cache lookups
> to use swap_cache_get_folio.
> 
> After this commit, there are only three special cases for accessing swap
> cache space now: huge memory splitting, migration, and shmem replacing,
> because they need to lock the XArray. The following commits will wrap
> their accesses to the swap cache too, with special helpers.
> 
> And worth noting, currently dropbehind is not supported for anon folio,
> and we will never see a dropbehind folio in swap cache. The unified
> helper can be updated later to handle that.
> 
> While at it, add proper kernedoc for touched helpers.
> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


