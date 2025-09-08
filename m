Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77F1CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 08:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41786B0008; Mon,  8 Sep 2025 04:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA118E0001; Mon,  8 Sep 2025 04:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB19E6B000D; Mon,  8 Sep 2025 04:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B197B6B0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:33:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 644448708D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:33:29 +0000 (UTC)
X-FDA: 83865418938.10.D70F089
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id F2D8E40004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:33:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0E803If;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757320407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtnnjkE2sa/VAFor/J7GmB/F8L3NsbnUCYVr2WFGbAs=;
	b=7LOludNTAXNnKXLfy0jDvojKn6j1o4zBKWK/JC0ulMloj+yUkqa+EgUH20tYW+pLZQcRgn
	NdyLBQxTDkOWMC74AFKFMyQ2KqZvvUJXfASPm4luaaqpGznZ/WtdgXXk3g6zINuXR9kxPQ
	a2RFqpBwwDo0T/4u5z5IvgWUFMXpiGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757320407; a=rsa-sha256;
	cv=none;
	b=U/YWw/d6x07RrRpB7wWZnqmxNxd8HqdMvcrgqaIkJTRLOtEDtBIbfwRMYbh1LmroL6RV9d
	nu5PVp9z7hRVrt6PQh0GLDWY7vZP5XyOGtDog/fJDVI2P3w50Zj6f9G0JUklWREXRUwgxo
	gTRUymE6aJg1xf+ZTlaAwZ252pVzq2U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0E803If;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757320406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EtnnjkE2sa/VAFor/J7GmB/F8L3NsbnUCYVr2WFGbAs=;
	b=A0E803IfLhrdLA4hZ4cGhCmcvibZ7xUmO2Z+/THRtVupdSxhsLTz/pQHwEEzAjFTnO3SZa
	SXr6gXdLN2Hfzipys5LO57BxX3UWUE9z3WdXuaLKL6K44tvOjEyj69Ay/fQnWff9aS+x7m
	atcx+8aNJS1MqjMbOVRD4iHIQm05T0Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-Y2H47g3dMeGQXBr6y2uC6g-1; Mon, 08 Sep 2025 04:33:22 -0400
X-MC-Unique: Y2H47g3dMeGQXBr6y2uC6g-1
X-Mimecast-MFC-AGG-ID: Y2H47g3dMeGQXBr6y2uC6g_1757320402
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45d6c770066so21012235e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 01:33:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757320401; x=1757925201;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EtnnjkE2sa/VAFor/J7GmB/F8L3NsbnUCYVr2WFGbAs=;
        b=Zlrv59rUxP5T4dugkzoC310QI3Mxxw0qUNGJsix8BZ8P4/J23fm8AffrfWBdSuji7G
         NrXi26UmycV+I6qGsSVw3q3uBiQkxpRCoS0BrtyNAOC72YuBEX74sUwgYYtHFgkFe57h
         O2ZyPH7c3ze4cekQvm3OVguRT2g9k0BnzPItIVm3D61liaFiFKDQlSwCU0El4sF4umh1
         4m7VgyR5hfmFI8TXUe1SHGkRPVTCvDGDKT6n0c/QvsPy8eGajE2GyDSs328oaeVSwj/a
         ifvpWzFS3+aCklTYPJfeucC0yLd7llkwzaPBfD4hV6cUWIZZ9ytK9h9lgBCTZUkH61O7
         TRAg==
X-Forwarded-Encrypted: i=1; AJvYcCVAcUcGmL/ZlbNFCSgjcohw4EEMgfe2vMdgaR/PjJpppfYpYUX30cJaQXpK02/qB3d4eKy1icc4KA==@kvack.org
X-Gm-Message-State: AOJu0YzwypM9ZzrDdtHqe2ZLk+dqX39UUpije57KHriZ05rxD9dAEU1a
	kNeFpo2TV5Jn6TQmiTy06PT2f9wxCZvVlpVyXtgaAyo1VPENugdUULQam35XLStn1QBhaDKJGW7
	FzGbxzEKEE/QU72B9RE0SI0DT8eXOxeENZ5EikIMR0QFNHFvqEeVQ
X-Gm-Gg: ASbGncvWrrNsX5r03umZmaMV152qv9ZsN2mkOeFa6iIYHCf+nGn/kjfdXXBGb98WpCU
	P3InwmXoR0kmtvT1L4nXzOn8esAiOflzK5STIQV2SEZygCyXbRNnDZvWJSInhwpAzF7QZ94gMSx
	80+uc3ti7B9lMf9UdVoWFOuRJKFtu6ac+qUO2hOhVY9TwuBytucqApA7Zf5cpy8yth4zImXPsBu
	Dfil3Gp21GrCDMz6oHYOQkOKwzgH8ba4lT8T6dcHsbdDMWs5ug9IFTAi+rcrEXee0Cd3aJK2KHj
	oi5vnamLlPDrjWm1l+dt/KvYWyg/jPf4RWtFVIiRmQ1veaJqUMcFcRFYqkZfPFNo7GdjTvNjnSU
	eS3F6kVQA2uOJja2Vv7USH1eQ7h+AJFFiEV6L3Hxhy/qdIia6a4DphyD72t9P5idD
X-Received: by 2002:a05:600c:1912:b0:45d:d099:873 with SMTP id 5b1f17b1804b1-45de2547b9emr42261115e9.6.1757320401662;
        Mon, 08 Sep 2025 01:33:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZ92pLEjQluT6SnPXGlHxbIiEKvzSoTm/+xGYPMrbleY5GV6dWcIL/gu8xTjnvzK1RgQmRqg==
X-Received: by 2002:a05:600c:1912:b0:45d:d099:873 with SMTP id 5b1f17b1804b1-45de2547b9emr42260735e9.6.1757320401253;
        Mon, 08 Sep 2025 01:33:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd05d0c43sm90946595e9.2.2025.09.08.01.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 01:33:20 -0700 (PDT)
Message-ID: <b30823ea-b987-4284-866b-9e179a2d8eb7@redhat.com>
Date: Mon, 8 Sep 2025 10:33:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: avoid processing mlocked THPs in deferred split
 shrinker
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com, akpm@linux-foundation.org
References: <20250908040713.42960-1-lance.yang@linux.dev>
 <5a1429ad-3900-404a-bdca-f25623ce603a@redhat.com>
 <bc1182e7-3f70-4645-b8c4-a97898e57041@linux.dev>
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
In-Reply-To: <bc1182e7-3f70-4645-b8c4-a97898e57041@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5UHY89EKiT6OcP2mIlZgPnodRWBTVn-gmsvmcj8b9lQ_1757320402
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2D8E40004
X-Stat-Signature: 7jrdff3jmz57jccgusqqhgcsoc5d69ec
X-Rspam-User: 
X-HE-Tag: 1757320406-462365
X-HE-Meta: U2FsdGVkX1+jPvC0EsrAgTWlZfTTcNIBiQ9KFPs9v66hFwVIdgeJWj4fBCSZ4fV2H9lIatXXSwc7Wqhk25PlCuImqC1E0mI67CI6uB0jozhO49wLE+lKAWFVbEAr7iJ79AR4+JIeXsoIN5Zir8MPZJpaQYMfGGsPVIavlIlykLRMFtjBQc/Zhxuc9zhIt+RrMDzY2x16JBV5rgAHxR7ioynszlGZoWXbPj6KzI07cu9HQ7/LoNhqMXNfO87LPp9sDsM7LNzn8XMjrh0aqsZ/ymBlmw8s7siKiu1Fa4evKyfk7MbyeiaNnC1F7WF4Fi8MT/Pz83pf1lBo5U6gCgnX0CC+pZXcOv9jH31T9M75iLpczcDOuI40QkRHgqkTU5RsDeHwgmNwPiEX+Cc0IFVhHARQ4H4U/sU+Ie+2KQMNvZHDabLX+S0xBeAH/bp5dmMcUZoXP6MUBbkSbM0FUQMaVhYkBPAJgvHWjZ8Q0B0ssbLClk5PdmEKVFBw08ocqBx6ix6zZy04h0878xMwKIfH0KWgMM8N/dd4Yo+C8mzai3IZTDJUu2JX3EWT54pn6cMO46rEX19boiczQZUNFfNQm9f24c63TKsMsFITzAu/ZGUC0nUSGnGJgw68eEJvDenaTdS14fF+WqGoZVvOLQhOw8tPmtIucVKgYmAGCL6vZYJEntlk2+bdv/XVfG2YT6t8h+JJsS6A8SUQ3ZFWSKAI73RsyIa6KpJ2CbsSfjPjTzwsjXPWGePjd6dxpohCs1synoJJQxrhLAeLunBjna5z/SzR8yzYr/e/GUDlvkCP/8ujWMsYxeGFPzvRD/0VfU68Tomljv/QkqdePY5zmSGWRJLgiie9JOkYUaQ0/83Vsv35xkZPuTioCqGF49++4ntsg6M2sLaV4o5T86+x9wfLcUFZhJOWcrs17Ts88Dyn+100MAIYXvJWyrvmCMjdQMi6y7JrR9qzBScTtHJPiNZ
 SuukOaMy
 iBUDwABNCbUpznOM+mwg4ovk/UYIdxt6agmmzIuE9N8RVaZT7oUlpEdSmQzXbnMhBMjo0k7W74o6YBBzuiWVnk44OJuX/naPSE9HWSKh0G4qIu4NVHBmzXnte7B5eVyw3Y9kCbLnBTT5M5vWNxuttP9hfFUiJ15oSbE0nrXUcOZpRwZACYNDJYzGpGDpwpMqn+evyvrfXwHWDGO363kCsa5H7ir4veejeWUyQ8zE2zgEirlq6YWwgfN/rLAw9nx+TGLYS+4sn8KrwuFoo01pL6aSBH+BuVT+/IUKSi21aZXhHB2WvQf38J4uZbx+eA8Ph+6/U188WvHpgb7e/1IltHZvqzUJ2Nb9aAoxhY8RVtKmoAWpFG6dTg8YxFhzj2/+LMI32bEbxt8bATU69iVH/P+v7jwgCswiSPlc4e9iXVaKItaBXw4J2Y+qVAYCkD7ps2Y6s6VLpqFkuXcA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> If I run my reproducer from [1] and mlock() the pages just after
>> allocating them, then I essentially get
>>
>> AnonHugePages:   1048576 kB
>>
>> converted to
>>
>> Anonymous:       1048580 kB
>>
>> Which makes sense (no memory optimized out) as discussed above.
> 
> Yes, my reproducer also shows exactly that. It's clear a lot of work is
> done but no memory is actually optimized out ;)

I'm not really concerned about the scanning overhead. The real harm is 
splitting a THP without any benefit.

-- 
Cheers

David / dhildenb


