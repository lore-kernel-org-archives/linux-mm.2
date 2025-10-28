Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7641CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E717D80134; Tue, 28 Oct 2025 05:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E271F80131; Tue, 28 Oct 2025 05:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D100880134; Tue, 28 Oct 2025 05:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7BCC80131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:44:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B30413AEE6
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:44:46 +0000 (UTC)
X-FDA: 84047038572.13.F939C3F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id BE7404000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:44:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IpPocVys;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761644684; a=rsa-sha256;
	cv=none;
	b=lgDC69+nId31CrAmSMCEBh1NtaJ90I0es7XUdroYpLjq3lvJiKc4afuVoqmWxFa4v9Ad8k
	eDVx/GWa0jCwsmsqVm+VbP9eN+6Xfr2eNm192vvyeiie3j+xWkRzJ1fa4rEW3Dc4Nn+5A+
	4YLU6mQVx8Nrz3JSkbGyQt4gbOEU2Lg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IpPocVys;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761644684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxcMaptV7eoYdZlbqSoVlIYopnhiS0mwWTyE9BWm+8I=;
	b=Cti7RxuoQwwspYR89QEfA6/su7ioycbWKezK5OQk+XbJwgvg4+w7oqVGz0fkKSrt+PSAAf
	sJj8m4CcCIhVysCGaNwUCo2NXplRQZyGao6pWfNoIGHyGrRucZ/obIib7zx+bkTONlX4JU
	8YLL1F4EU1AAOK3tx8U+wVJz8PUFw8E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761644683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YxcMaptV7eoYdZlbqSoVlIYopnhiS0mwWTyE9BWm+8I=;
	b=IpPocVysy3Mg/kkxnC09ewGsnGfxIDGN3poPNriYHxuMxlAPqEbaEHQKH70Cib9aUJpX4R
	8IZUaqK/Je8ExTCDKsGDSp8NZKCuo9pWapYe7H7RYDnhQnBMr7MKnECcVmCWMeOPiAmcjD
	QNB+mcD7SxxYpEqeBNtjBg7oQrRAoJo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-DsVAQFnOOiaRofz7h0QpgA-1; Tue, 28 Oct 2025 05:44:41 -0400
X-MC-Unique: DsVAQFnOOiaRofz7h0QpgA-1
X-Mimecast-MFC-AGG-ID: DsVAQFnOOiaRofz7h0QpgA_1761644680
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47717c2737bso2410625e9.2
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761644680; x=1762249480;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YxcMaptV7eoYdZlbqSoVlIYopnhiS0mwWTyE9BWm+8I=;
        b=Ylmtqc6VX21ObKX8EtHJohzLkdBguo/llkLfCGf0cjfCPzv2uceDMbQAcnV49/XzIn
         5WRhgDWI1eTi0BFehxOadH2h5oQ/vEBZYHlvwEa86ujZUaXBGaDXaq4lal72EH4JA1iO
         fLupWZQXfuhaQFXBRnI8G2aa5wNVS34Lq2cOK7vjbhCPaxlE0d/X5GEPOXxfpbwwf/Bu
         JINZWtbsc+rX+jqTjW/xXnhgMEsDt2t67GJF1qvjLrNFSJxnY4dqgvnGDAjAu1mYiG5O
         sMswydyBE8w+A0Fl2Wa/Mk83gh9JKYQp+dNTRejQbaKHBG9XQKdIHP47/dz2eyNvySEJ
         wP6g==
X-Forwarded-Encrypted: i=1; AJvYcCUod7f5XMe9COci5pZzyH8g+Wi/7GlWhov/8dEIboDN6/IlWqSTeeEfxBQFDYjqfkgjUpE7dMOg8Q==@kvack.org
X-Gm-Message-State: AOJu0YwkH+7XAWnSKicyymv60I7MP5d4o3JMHAGIX6kv0h8hVjxPjsHV
	+mmexePZw/XJ1uMK2AYxiVGai8FF1CmyncXGo1afFynuagfwgfGZr78hxGAAuoN5ZLDormvkPAU
	0k4Q8r7A5bEzZl2e5zabkq87mxUW7LeteH272TVZv7KsIeU7nJl6i
X-Gm-Gg: ASbGncvmRKSkkztg9aAZpzS7n5/LmWyFADcJaiz0t2zzo3ritc3z1F/LFqpwAYYTg94
	mYBcYk+z6kIkwpX3FPh2V3PUpjZdUShg0Bzz3D0w8INVYNAuB23tn0dqY6MPqExOfPk2xTjBajo
	dB5zv6LLywWnzDYR36ce82s1TyYtm6x/R1lafVYAAgLGe2bExNGfN/T7XtuENt3ZCunhyonEx4t
	xwlGY5SrRpYbN6c5eVd4CAIdqBuXV58k1L+lyQuWfi/DUzlMsfwlYtF1ZjtWus5CKYqRomoz/Td
	9MC3fMpjkdq68RZzawkDy+dJuBXKL6YstF97DZUAtfTkGQt6piWx4vb7ts9feQoTpyTh10IRSSG
	731Mtbj8AD+u5Y8yrystTjAsRGIgPyI50
X-Received: by 2002:a05:600c:548a:b0:46f:b43a:aef2 with SMTP id 5b1f17b1804b1-47717e7f4cfmr19256705e9.38.1761644680098;
        Tue, 28 Oct 2025 02:44:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFA0vSYLtxoOKqxkOZY7xYgAXRBusIt+EB6OwH5I1UUbtzv3C7HHhyCrwUYbutjJaFFl6AwZw==
X-Received: by 2002:a05:600c:548a:b0:46f:b43a:aef2 with SMTP id 5b1f17b1804b1-47717e7f4cfmr19256445e9.38.1761644679593;
        Tue, 28 Oct 2025 02:44:39 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952ca979sm19799481f8f.14.2025.10.28.02.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 02:44:38 -0700 (PDT)
Message-ID: <a675d644-38d0-43d7-be42-8bc3753c74ee@redhat.com>
Date: Tue, 28 Oct 2025 10:44:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: Longlong Xia <xialonglong2025@163.com>, linmiaohe@huawei.com,
 lance.yang@linux.dev
Cc: markus.elfring@web.de, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, qiuxu.zhuo@intel.com,
 xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20251016101813.484565-1-xialonglong2025@163.com>
 <20251016101813.484565-2-xialonglong2025@163.com>
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
In-Reply-To: <20251016101813.484565-2-xialonglong2025@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: epJ_tpb9yPRRvBUbobwkkBHT1Xc5dZAsPvgcRaINzLE_1761644680
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: odqhqf79ndy8onwiq5n3d7xw6oeic6oj
X-Rspamd-Queue-Id: BE7404000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761644683-157204
X-HE-Meta: U2FsdGVkX1+ENog+rpzXtwAFLSSXFUICOH7RujYpL7agXGRC3fcwRPJPO2BcCoqy1nzmJJta/YAhvL4s5CrniYCG6VbrKCjAEoWNWlCk1CIERbBDJJEg+BWSCcEoVjh8uItMhe5koYisTY5v8UlscJYkwWI/UTfL1Pd1UDrWypQwDbBeoU4YeQ8T0Y7QiTz5fVpfsrdkyV9sxKbFFNNpBIMB9DEiKeB8AaH0dprMcfDQBiH0bA+eEmmk3Zxl9b8E3IxuH+wFBRYZTlMDHy+6jaMpGWC1AHdNj211WDxKY6UBIiG6Z2/Kaa5owN/TZOQOm2r54yNnujiXQgywJUc6zdX2Gx2s0E+f5STJy12iM57SrrKHB0pWCsfdXQ11xSWxvwck67aE9nD80GQ+encgpf/VdTGo20kfrUPfOa6Pxlb4vcQbO8lfRpLlYkY3inUD81eFkY/oelkWQWgi9ZvDQEx0I3ZNSrJXXfdPumRzek44d7s9bwZ1nhwaYsDNqPCicD/W7br4yEJGjvp83JTKIIGz7AaaEbjXETYie04j13JAgNCxRIRVQsXraGEoVBB5Xl4ey7UVAmUHs1iDr3dEmvr306V6siBgN5gSCGGiUkbEclrH4LwqFDNchWxPeGinYmgk/2Gxyha6s/4I0OrWOyhGHjcou5cLsFysEFbvPY4Z7h6zsXYl2ZjTjAucq0lyybN9OW3nBlH70gkWcE+zEPHM/nm4A4FQ2/7BNawAUxh5/wbo4iI8oSxZYVVrGv6BkKwxJdJgwcnRmApMzpst929mps1twhFfYrwZAHxN3G5+WtmkCaAjF3Vmx8EfR/ceaseFVou/jC5h+WGjsycRkcCh89vuCbcd/z6pMkbJy34C4AiZGCdXvvP0dnd10V3pwwdfx8C7jpBFrcwIV1JEjuIwBNDCIL5aNRpbkqPVP9LsboG3wJX8epS1dZzEc1TuUbMvrj9C3NMtmOHFvHb
 j8OtWXZi
 uHT0ScoaCLxcxlSVrZQJjvrIHHAYkqnk2/u6H+9NxOeaQvOwa9+ryOU6KnbuGZxvP9dK2v92+trKSGuImxQD/cnol/tgtANwcjS9iSVGIQtZY0yn3TbEN3oQ4xLKysJYQW4P9PDymkecjGGID6P2T/PhAL8vYyhmVuFQROzZg6Dku8b93EROXSrU0oWdoezMeFKCCF7DxcYEopfHdYO+mj3yQIuz9lSt2iWH+FTCOMPGR8OdMSnPpNkWW4wEj8/yHP5ZTq9zULapWQ3nj0RPpOX1k2l0onGO79FpQw0CoeaMYIO2g2taZ/MaTQA3C3fUJ3Pg2Dt1JWwp6jlwklNxLO1CeA/QG1pYsWg0RflsYLJeH+OV6cid4BPn+qjinKEbhpIzC52XtEJ6H+f0h+fHokcKDkkQ2NP+cT41Pm+DnXMeBMxxI3pQGTTMEGhVSITo/pbvHozAoM79game8/dHyTKRLzyxfriHqRFhR2+1E0oBCZl4N2qBXiDzOjC0AnrHRc/qugkidD8nce3Iv89OUYwBLuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 12:18, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> When a hardware memory error occurs on a KSM page, the current
> behavior is to kill all processes mapping that page. This can
> be overly aggressive when KSM has multiple duplicate pages in
> a chain where other duplicates are still healthy.
> 
> This patch introduces a recovery mechanism that attempts to
> migrate mappings from the failing KSM page to a newly
> allocated KSM page or another healthy duplicate already
> present in the same chain, before falling back to the
> process-killing procedure.
> 
> The recovery process works as follows:
> 1. Identify if the failing KSM page belongs to a stable node chain.
> 2. Locate a healthy duplicate KSM page within the same chain.
> 3. For each process mapping the failing page:
>     a. Attempt to allocate a new KSM page copy from healthy duplicate
>        KSM page. If successful, migrate the mapping to this new KSM page.
>     b. If allocation fails, migrate the mapping to the existing healthy
>        duplicate KSM page.
> 4. If all migrations succeed, remove the failing KSM page from the chain.
> 5. Only if recovery fails (e.g., no healthy duplicate found or migration
>     error) does the kernel fall back to killing the affected processes.
> 
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>   mm/ksm.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 246 insertions(+)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 160787bb121c..9099bad1ab35 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3084,6 +3084,246 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>   }
>   
>   #ifdef CONFIG_MEMORY_FAILURE
> +static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *dup_node)
> +{
> +	struct ksm_stable_node *stable_node, *dup;
> +	struct rb_node *node;
> +	int nid;
> +
> +	if (!is_stable_node_dup(dup_node))
> +		return NULL;
> +
> +	for (nid = 0; nid < ksm_nr_node_ids; nid++) {
> +		node = rb_first(root_stable_tree + nid);
> +		for (; node; node = rb_next(node)) {
> +			stable_node = rb_entry(node,
> +					struct ksm_stable_node,
> +					node);

Put that into a single line for readability, please.

You can also consider factoring out this inner loop in a helper function.

> +
> +			if (!is_stable_node_chain(stable_node))
> +				continue;
> +
> +			hlist_for_each_entry(dup, &stable_node->hlist,
> +					hlist_dup) {

Single line, or properly indent.

> +				if (dup == dup_node)
> +					return stable_node;
> +			}
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct folio *find_healthy_folio(struct ksm_stable_node *chain_head,
> +		struct ksm_stable_node *failing_node,
> +		struct ksm_stable_node **healthy_dupdup)
> +{
> +	struct ksm_stable_node *dup;
> +	struct hlist_node *hlist_safe;
> +	struct folio *healthy_folio;
> +
> +	if (!is_stable_node_chain(chain_head) || !is_stable_node_dup(failing_node))
> +		return NULL;
> +
> +	hlist_for_each_entry_safe(dup, hlist_safe, &chain_head->hlist, hlist_dup) {
> +		if (dup == failing_node)
> +			continue;
> +
> +		healthy_folio = ksm_get_folio(dup, KSM_GET_FOLIO_TRYLOCK);
> +		if (healthy_folio) {
> +			*healthy_dupdup = dup;
> +			return healthy_folio;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct page *create_new_stable_node_dup(struct ksm_stable_node *chain_head,
> +		struct folio *healthy_folio,
> +		struct ksm_stable_node **new_stable_node)
> +{
> +	int nid;
> +	unsigned long kpfn;
> +	struct page *new_page = NULL;
> +
> +	if (!is_stable_node_chain(chain_head))
> +		return NULL;
> +
> +	new_page = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_ZERO);
> +	if (!new_page)
> +		return NULL;
> +
> +	copy_highpage(new_page, folio_page(healthy_folio, 0));
> +
> +	*new_stable_node = alloc_stable_node();
> +	if (!*new_stable_node) {
> +		__free_page(new_page);
> +		return NULL;
> +	}
> +
> +	INIT_HLIST_HEAD(&(*new_stable_node)->hlist);
> +	kpfn = page_to_pfn(new_page);
> +	(*new_stable_node)->kpfn = kpfn;
> +	nid = get_kpfn_nid(kpfn);
> +	DO_NUMA((*new_stable_node)->nid = nid);
> +	(*new_stable_node)->rmap_hlist_len = 0;
> +
> +	(*new_stable_node)->head = STABLE_NODE_DUP_HEAD;
> +	hlist_add_head(&(*new_stable_node)->hlist_dup, &chain_head->hlist);
> +	ksm_stable_node_dups++;
> +	folio_set_stable_node(page_folio(new_page), *new_stable_node);
> +	folio_add_lru(page_folio(new_page));

There seems to be a lot of copy-paste. For example, why no reuse 
stable_node_chain_add_dup()?

Or why not try to reuse stable_tree_insert() in the first place?

Try to reuse or factor out instead of copy-pasting, please.

> +
> +	return new_page;
> +}
> +
> +static int replace_failing_page(struct vm_area_struct *vma, struct page *page,
> +		struct page *kpage, unsigned long addr)
> +{
> +	struct folio *kfolio = page_folio(kpage);
> +	struct mm_struct *mm = vma->vm_mm;
> +	struct folio *folio = page_folio(page);
> +	pmd_t *pmd;
> +	pte_t *ptep;
> +	pte_t newpte;
> +	spinlock_t *ptl;
> +	int err = -EFAULT;
> +	struct mmu_notifier_range range;
> +
> +	pmd = mm_find_pmd(mm, addr);
> +	if (!pmd)
> +		goto out;
> +
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
> +			addr + PAGE_SIZE);
> +	mmu_notifier_invalidate_range_start(&range);
> +
> +	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
> +	if (!ptep)
> +		goto out_mn;
> +
> +	folio_get(kfolio);
> +	folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NONE);
> +	newpte = mk_pte(kpage, vma->vm_page_prot);
> +
> +	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
> +	ptep_clear_flush(vma, addr, ptep);
> +	set_pte_at(mm, addr, ptep, newpte);
> +
> +	folio_remove_rmap_pte(folio, page, vma);
> +	if (!folio_mapped(folio))
> +		folio_free_swap(folio);
> +	folio_put(folio);
> +
> +	pte_unmap_unlock(ptep, ptl);
> +	err = 0;
> +out_mn:
> +	mmu_notifier_invalidate_range_end(&range);
> +out:
> +	return err;
> +}

This is a lot of copy-paste from replace_page(). Isn't there a way to 
avoid this duplication by unifying both functions in some way?

> +
> +static void migrate_to_target_dup(struct ksm_stable_node *failing_node,
> +		struct folio *failing_folio,
> +		struct folio *target_folio,
> +		struct ksm_stable_node *target_dup)
> +{
> +	struct ksm_rmap_item *rmap_item;
> +	struct hlist_node *hlist_safe;
> +	int err;
> +
> +	hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_node->hlist, hlist) {
> +		struct mm_struct *mm = rmap_item->mm;
> +		unsigned long addr = rmap_item->address & PAGE_MASK;

Can be const.

> +		struct vm_area_struct *vma;
> +
> +		if (!mmap_read_trylock(mm))
> +			continue;
> +
> +		if (ksm_test_exit(mm)) {
> +			mmap_read_unlock(mm);
> +			continue;
> +		}
> +
> +		vma = vma_lookup(mm, addr);
> +		if (!vma) {
> +			mmap_read_unlock(mm);
> +			continue;
> +		}
> +
> +		if (!folio_trylock(target_folio)) {

Can't we leave the target folio locked the whole time? The caller 
already locked it, why not keep it locked until we're done?

> +			mmap_read_unlock(mm);
> +			continue;
> +		}
> +
> +		err = replace_failing_page(vma, &failing_folio->page,
> +				folio_page(target_folio, 0), addr);
> +		if (!err) {
> +			hlist_del(&rmap_item->hlist);
> +			rmap_item->head = target_dup;
> +			hlist_add_head(&rmap_item->hlist, &target_dup->hlist);
> +			target_dup->rmap_hlist_len++;
> +			failing_node->rmap_hlist_len--;
> +		}
> +
> +		folio_unlock(target_folio);
> +		mmap_read_unlock(mm);
> +	}
> +
> +}
> +
> +static bool ksm_recover_within_chain(struct ksm_stable_node *failing_node)
> +{
> +	struct folio *failing_folio = NULL;
> +	struct ksm_stable_node *healthy_dupdup = NULL;
> +	struct folio *healthy_folio = NULL;
> +	struct ksm_stable_node *chain_head = NULL;
> +	struct page *new_page = NULL;
> +	struct ksm_stable_node *new_stable_node = NULL;

Only initialize what needs initialization (nothing in here?) and combine 
where possible.

Like

	struct folio *failing_folio, *healthy_folio;


> +
> +	if (!is_stable_node_dup(failing_node))
> +		return false;
> +
> +	guard(mutex)(&ksm_thread_mutex);
> +	failing_folio = ksm_get_folio(failing_node, KSM_GET_FOLIO_NOLOCK);
> +	if (!failing_folio)
> +		return false;
> +
> +	chain_head = find_chain_head(failing_node);
> +	if (!chain_head)
> +		return NULL;
> +
> +	healthy_folio = find_healthy_folio(chain_head, failing_node, &healthy_dupdup);
> +	if (!healthy_folio) {
> +		folio_put(failing_folio);
> +		return false;
> +	}
> +
> +	new_page = create_new_stable_node_dup(chain_head, healthy_folio, &new_stable_node);

Why are you returning a page here and not a folio?


-- 
Cheers

David / dhildenb


