Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782F9CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F8F8E004A; Mon, 25 Aug 2025 12:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6738E0038; Mon, 25 Aug 2025 12:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8C68E004A; Mon, 25 Aug 2025 12:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93DA28E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:04:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BAA3590BF
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:04:50 +0000 (UTC)
X-FDA: 83815753140.06.2627B88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D756416000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:04:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bfY4MSXo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756137888; a=rsa-sha256;
	cv=none;
	b=CdQJ0hEr1E+hsqYryBpjfF/YSF35lywpHuMI+xwF7bJrCyIB0Eq016YHTVi/V8zL4OqLW3
	IQN4NLT5X6Zw1eTGhKsOM8N3Gh8ivFQxMOalagO4RAhtiYDTnh7EfnxlfffJBASy6AJaCm
	KgkDQ4hLJ44GFZJOBTbbVhF/BzexaHg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bfY4MSXo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756137888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MyZ3OtNfCvOIDwHkcmUtPUBmP76mzb4s7J5R7w3h4k=;
	b=z9/W13t6qWn4EC3GkDEg3UvCFMtRvRswomQhU8kroFOX9X9wKpC5d+r0sqBZG8ygQGTSCb
	IInHJOaRTTS6wumFWYYZ8J1u6I61HcfyEAOc+F1Q8vmU/oSQklS7j/GqUUqn+s1gWW+iYS
	OETb3Pl5j4jzVJSfqReIM0fqytiXtkQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756137887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6MyZ3OtNfCvOIDwHkcmUtPUBmP76mzb4s7J5R7w3h4k=;
	b=bfY4MSXoXTHGSTt0iTHWGNxguI/BH+OGgMc28H7/prH7Ul9+gq0Aw9U2gmyCPOeL4T4N3K
	K1lWrqA9FcPAAYb6yNtuLfsAGC1mu2nwDelQ4FTgFZcXu//4nss9/y2sPSt8qKztHjpXPI
	J+29ZvtM94MzC8+7x72nxu7KR+Qe6Cc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-3xC0FeEcMLuo6VY5XJCmaw-1; Mon, 25 Aug 2025 12:04:43 -0400
X-MC-Unique: 3xC0FeEcMLuo6VY5XJCmaw-1
X-Mimecast-MFC-AGG-ID: 3xC0FeEcMLuo6VY5XJCmaw_1756137882
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3cabe21a5a5so145386f8f.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756137882; x=1756742682;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6MyZ3OtNfCvOIDwHkcmUtPUBmP76mzb4s7J5R7w3h4k=;
        b=Rlpu5P6+OXP+rTonEhGqvGht4GKRQOcSAARFeSiXsjxXQwcnKLMaAjsBwxO7B3WPED
         5HRVhIAyff9wGBIdij/q97T4DB229psrLUW8Nx55Ui1IOD9Cag088+t/eO0k1QUB/5/J
         HgtJ3tYgrDKlEP9a6PlVSwE9BzFbNlagfmjRIxivdEPq5G5kqf5XZOgMxpfZIPPxFliR
         +W7zoIVwW//tuAoqLLsx2dbsVuiBd43HcwyAi6od+2DzU8CzkuO8bOhTRUTGkOTLQD2n
         GPxPn78PdKJYdQrjGT7Ong8xt7WGtZZRFHJEtFYFjTrK3Rgenm7bcahBkQrJPS/IBJy+
         8AGg==
X-Gm-Message-State: AOJu0YzoLgopHlAGjY5VYaxm5F0LOGRgyGPKDHk6LA8MU1GRUceSoH2V
	w9VS33mAZXXH571H9onsUO4iIwekuQUqKGaA4N2KXWsFu5kxtSaCgUMbWNjI0ePSkiNYW8htNJf
	YTjzD4RD87IIZ4KRAjZWUeZ9qf8tD3PNxWayZ/Y3Es/utNAPJ8qC1
X-Gm-Gg: ASbGncvMMAtFmYzKgeAA4dp+oBJPtG8+uA0C1VMhW/1Om742hebjJg2/AvDQWCFbGCc
	f9xT4NbixMS+DRyEL0XW7BMX1wRpBqGql9c94I4yfhM3dtwOZtoUVMnpvjWx6PcRfhpquW6XTZv
	NxZnGWyFbudHfswkhp7r1ClGI4LVvMkxxKGYGWfAoQe1hzGmbt8IxTKgNBydFX6r5dR0k8jZiCZ
	VBZoqH+kF1f5x5flPej3PfP/B4dpXEk0Je29U18x4/NGn3eilz0t9k+LzXd6/dY75rZXaxpm+j4
	9Ko+WSIMk3j41zqorO6TB4eKa1YLk8sHrKKTf833bOkwuELi4n0ZuxxyveTUBELKXIgsusElT4O
	HZZKNu5OCMHelaFbcZt1qg7K2mQgtyw/X8X6Mz5S0/zs3ZsHRPIQ+aKP8HrYeZNqoMD4=
X-Received: by 2002:a05:6000:4021:b0:3b7:9d87:9808 with SMTP id ffacd0b85a97d-3cb04248189mr84060f8f.15.1756137881639;
        Mon, 25 Aug 2025 09:04:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP2kHBp04DrmSVsxC1Pmyfq33GFQ537iiA7ViWhutMa83yN8mVo2ShcNNYVc3OSQ+D26O32Q==
X-Received: by 2002:a05:6000:4021:b0:3b7:9d87:9808 with SMTP id ffacd0b85a97d-3cb04248189mr84016f8f.15.1756137881091;
        Mon, 25 Aug 2025 09:04:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b60ab957bsm42578115e9.12.2025.08.25.09.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 09:04:40 -0700 (PDT)
Message-ID: <4193fe50-dddb-495a-bc8f-e86c5e98fb1a@redhat.com>
Date: Mon, 25 Aug 2025 18:04:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
To: Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 Ge Yang <yangge1116@126.com>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
 <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck>
 <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
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
In-Reply-To: <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2eOea94AoFSWmR2GglbJk7cJaS-RJcHfzNatAWMzusk_1756137882
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D756416000D
X-Stat-Signature: iki8ndk38x8zcn8xtkc5jbwgwqzecho9
X-HE-Tag: 1756137887-475471
X-HE-Meta: U2FsdGVkX19s2nBVvhZqHnvtZvHu+EQDhUp2FOhs1IL+LWdeOoz4RWLkEOsdOSe17Ja9QWfaeZwJ4MqNOV49IQBNCzoTuGkBgXy4V5u0XC4fA2toxASy18MYfnYXqw156i3b3ktMdfRgfCbL69Oo/SRA+X8Oe0Fa+xN/aAZsqxpH1XMTyCz2e/f+bJZofo7MSYZ0RAi0/lESps+cdD/CLaf7cUqJeaGdcjtAgYJ2jymaTPELkK4koQq4RE3KWqOp9CORZS3VnDVQqOONmh7tLopIbFBsXH0NRKr2U/DXeo13bE3N6JksDPnDEKAQWtGsWmMVu7i79NpTb6BLNlFJpAAFXg+73L6zK7nvcOgiwM/qocTxyFFQ2TWVS1WywXJs3InbCpZd5m4/rXkAqNUN2kzXmD2h5bnDeXEfrZtap1KLjD8pSM8SXDUPwM5Yt1ZVFAYDHr3P7aoH26gcOomBeHe+g/xWKkrFDhhHfXPpPmvk3dBIJznD0ii02hGUrng3kosENP8SnVSdsboilZMbcEb3StIsB9SoWWWahuzDTezikWMWKKk50hplGKaMFZzJEm4kDXLcGJJCDNgnOF3F2UDpMHtMLJXYrSiG1Z2g29WMIxtqWEE2ILTyIlaEFR43cuY0XdapECIV1+eBo9pGF9o7r7e6Hnri0UM9dgJSe55FWgP0vTQ6sY1jiDr07Ey4BH1luqIIyXG51dtcJ9TMYpPGwHRsZcb3tU790Txrv4E40JCJHZ7n4qt8CCkypLAINghrRkXf2lfdDWilYgjLRwFMhlrfYogak7Ep8SL1tbR2KtX+ft6tgZVDoc4RYPKAUa+hZmZ/BmsPUEPPhOCkuqwf/kH02BZ8/O6jk3g3zbu/u67Qr62Z5QqFj941biZQRDKMsmhOTunRKcHfZ9P9M1p5Lgl3iYhizp+CCzIMO5dDk2REdWhSoEBrFuDDVLsYQBi+m165sC4+m3nksIL
 QFLVs+mE
 gEkknWV+grFo8aS0qRzaZpKgoScegY2RdUWCSsi+Q4haDqWtAf5knUDKI5s9hVO7VNyTy2u2V8c6xfVLK3KhS7Y6SLcGLTz3l5U70mpLPkqs01427VAn/nakIZ7zISS7FFlNPK3iaQmUMENLYvK0ZzR2xfRjXWdxcVuFBszeNQyG5wPhb1Sqe8erwt2eMFKvlpL+3f1sPHPb1JYY8Fj0Kh9Cmwj9NBa6kwcANSXp63uSHl87GfOUVKmJTnGp9mOt6hBilfBWwoOLPoqmBH0ZNQN6LNtuPYg3R6wW0Mi9/Y5xyv6IGOBUEY4fTZ3X3V4Kvzl69T1E7rXS5ruVTwSFNGck3OaLnzJpvmg3CCOv9v16F1NAujMsDn0Bmc25GESFNmNZi9AjsPoEr1UT5Q9a4DtUnuNOey5lHsRWaf5a/d1oJmlHwXrXEzyJufg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.08.25 03:25, Hugh Dickins wrote:
> On Mon, 18 Aug 2025, Will Deacon wrote:
>> On Mon, Aug 18, 2025 at 02:31:42PM +0100, Will Deacon wrote:
>>> On Fri, Aug 15, 2025 at 09:14:48PM -0700, Hugh Dickins wrote:
>>>> I think replace the folio_test_mlocked(folio) part of it by
>>>> (folio_test_mlocked(folio) && !folio_test_unevictable(folio)).
>>>> That should reduce the extra calls to a much more reasonable
>>>> number, while still solving your issue.
>>>
>>> Alas, I fear that the folio may be unevictable by this point (which
>>> seems to coincide with the readahead fault adding it to the LRU above)
>>> but I can try it out.
>>
>> I gave this a spin but I still see failures with this change.
> 
> Many thanks, Will, for the precisely relevant traces (in which,
> by the way, mapcount=0 really means _mapcount=0 hence mapcount=1).
> 
> Yes, those do indeed illustrate a case which my suggested
> (folio_test_mlocked(folio) && !folio_test_unevictable(folio))
> failed to cover.  Very helpful to have an example of that.
> 
> And many thanks, David, for your reminder of commit 33dfe9204f29
> ("mm/gup: clear the LRU flag of a page before adding to LRU batch").
> 
> Yes, I strongly agree with your suggestion that the mlock batch
> be brought into line with its change to the ordinary LRU batches,
> and agree that doing so will be likely to solve Will's issue
> (and similar cases elsewhere, without needing to modify them).
> 
> Now I just have to cool my head and get back down into those
> mlock batches.  I am fearful that making a change there to suit
> this case will turn out later to break another case (and I just
> won't have time to redevelop as thorough a grasp of the races as
> I had back then).  But if we're lucky, applying that "one batch
> at a time" rule will actually make it all more comprehensible.
> 
> (I so wish we had spare room in struct page to keep the address
> of that one batch entry, or the CPU to which that one batch
> belongs: then, although that wouldn't eliminate all uses of
> lru_add_drain_all(), it would allow us to efficiently extract
> a target page from its LRU batch without a remote drain.)

I like the idea of identifying what exactly to drain, especially
regarding remote LRU draining.

With separately allocated folios we later might have that space, but it 
could mean growing the folio size, so it depends on other factors (and 
also how to store that information).

For now, I don't think we have any space to store this ... briefly 
thought about using folio->lru for that purpose, but the whole reason 
for batching is to no mess with folio->lru modifications but instead to 
... defer batch them :)


-- 
Cheers

David / dhildenb


