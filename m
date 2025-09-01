Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C34CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C64C8E0058; Mon,  1 Sep 2025 09:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976998E0008; Mon,  1 Sep 2025 09:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E3B8E0058; Mon,  1 Sep 2025 09:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB328E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:49:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 218A814088B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:49:38 +0000 (UTC)
X-FDA: 83840814036.18.A33031A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id DD15F40013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:49:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cdE6w4EA;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeMaFkgVKLNhgkcf95y5bvTrYsmpJO9BxTkmeHvQCgg=;
	b=hTxa0OEYDKeTSIk5jbSaAguN1A4sp9CntMOxjVsjwQlWFkmJgZvkZxk9Kgq+Xn3346Hj2M
	fBkDnhRmjXqqjJneKfDmHkjaFRVdXfJS2WLquaOUL4SAIy35piJw0oMwzh32FS37ZbiNwx
	K+ardFBAeROLUAK8t0RSYMULZZ3Pjbo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cdE6w4EA;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734575; a=rsa-sha256;
	cv=none;
	b=LgMlupBf3ab8WLgJmuyg5XK6gslGTYhQweE+5uX52CN9HAMLdLqh5S92uXYOm08FPQ6mUv
	44Tk4lGTY9/mVlF6ARd9NYg25Ssg8Dl/qauAtklNkmJBIEvPMwt86Sbxh6ldkhenNZ/CW4
	gF2X+PIpbE4rosn/QmvALmx00+V5REA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756734575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QeMaFkgVKLNhgkcf95y5bvTrYsmpJO9BxTkmeHvQCgg=;
	b=cdE6w4EA8zmPgvtJYLaIRpsEnvAObc5Ngi2rhOj5QsB15B/iAkdOp6KWFvkwXbsSoEgihY
	+APS8JqrEWbineoyX+1Ijg9FOttEcBKy1Re3OVQSZkgzNJOutbiCs2BWYUf7V8vgw1wqUj
	b5TGCbiH1vKZWyw1sx1L87ei9UOnFGs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-LYO3nqK-NGCTwgO4u5uY_g-1; Mon, 01 Sep 2025 09:49:33 -0400
X-MC-Unique: LYO3nqK-NGCTwgO4u5uY_g-1
X-Mimecast-MFC-AGG-ID: LYO3nqK-NGCTwgO4u5uY_g_1756734572
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b8a307c12so6477715e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756734572; x=1757339372;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QeMaFkgVKLNhgkcf95y5bvTrYsmpJO9BxTkmeHvQCgg=;
        b=Kwwd5hPmqDU2/Zfi60C0QBfoK2prvfs8wwUkPA68nocQ2TkOYN6yLuXK+K/F/4GiFE
         BpoqZhYOy8Iwr7T1elBv4GuHL0RD1voYb8HM9/hr0IsDp7SPxcQLWO5BGvNRuBT+KwWB
         NN4AvT5iRTj7WUOHtn44u+vkJoju+s5bHFan+zdu+GROWPFsS157pWxUqC9i8skwmKOD
         8SmBJuxCmUysRK8U6Mx8CSePH1dq4DbSX0n5D1KzkthDvui4x4bWHaU+vNFptZb0XVQP
         tY5hPe4gWQnwUZFBHXjrIIVtIlwX7Kxsagmh3CsMMX6f6qJ1ZReq078KgaKQ+I+1VGLz
         7fKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIp5+jC6sThu/MmgCklufC6idIZq98p1jqfo0dCWLpnMXefWwfr4j4VqhGoblpWn1MIpBVGrF4KA==@kvack.org
X-Gm-Message-State: AOJu0YwxGFSeVuhMGUHgal6+EQB+kV7IPGimtvfVA3EEo4DfKCBL0MK1
	AjOxeMhl2zX2JMdphJrZPB45kKofMcxZIiBH8sUBsR2Xrm0NQ8USvY/2Q7zWR8hRkgVhmfifKmJ
	LD/vZPQI+8Rzz38ejn9KufiSmNT/zIVUB/y76wAwhzC9zMBb2wBck
X-Gm-Gg: ASbGncs8xkX9KrzxQxLI0nzHugdNg/QY/yHpTvkaejyN3p0C69TecyQgLbqBFffyaYk
	adTtd0+IZl/q1JKKvDV5sk0PlwReAn7ydm3NSUm2qJ0HEIWGUP2j3rpyh0/zHIiCMMu0Lwfn7gW
	+jCyATIDgnQghwGBAXaNJU6hcUOjc0IHUEcD+l2tZTJquQQYKv+ibLaTgFizhdrWRBV4uWMAh0z
	FQ/tuXZxxftvFTUNok0lbhjVMrIAZ3LQ/N9OqhLvZ9v3KxsyjZu85kAhyacDQ0tm1qv/WiWPvL4
	P8HOcUk1doCfaNl0bQKv2sKElARMbW06LBpRvEv3tv7svxxY6ZrNxuM/B8Dzx7AZrkh4bJcn5je
	PNOPQGh/OmnuHDriMAjLvfpY3MzpVv63svxVi4QDkOagGFAUQnwV4XHXSJJNbxBPfEDA=
X-Received: by 2002:a7b:c3ce:0:b0:456:19be:5e8 with SMTP id 5b1f17b1804b1-45b855c980dmr39003495e9.20.1756734572221;
        Mon, 01 Sep 2025 06:49:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWVzIbyD9cL1iRjU4Tl8hKX3/L75O9ja6UC34f0938iMOqSuaIgC8oMfdKLbCOOEuv/sCMTw==
X-Received: by 2002:a7b:c3ce:0:b0:456:19be:5e8 with SMTP id 5b1f17b1804b1-45b855c980dmr39003225e9.20.1756734571705;
        Mon, 01 Sep 2025 06:49:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e88785bsm158072995e9.14.2025.09.01.06.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:49:31 -0700 (PDT)
Message-ID: <e509a5c4-f71b-4fcd-9776-6a3d39761b4b@redhat.com>
Date: Mon, 1 Sep 2025 15:49:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/12] mm: constify pagemap related test functions for
 improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-3-max.kellermann@ionos.com>
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
In-Reply-To: <20250901123028.3383461-3-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aaQUPWRK47fclw4LR7yTr0aawLhqvZoQECcabofO0_0_1756734572
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DD15F40013
X-Rspam-User: 
X-Stat-Signature: tdteteqxy7wxaepf48pbyzys4z741rex
X-Rspamd-Server: rspam09
X-HE-Tag: 1756734575-375086
X-HE-Meta: U2FsdGVkX19LVAxeKPiWWmqrrgNHZh4NpEFy6sBblcGWVyNaDiHHN1SPN/+eNi1VwYB1GG92tR6oj8WO/12BWN1ZqGqySU9Ioklh6TXkX9YetY/mg/OflIhaSStoY9S2CiedY/Z8iJ24r7QW4mPZbBhNrUN37RoWOI4W+ISVGgyXzs3GqLKRNPoUL6gEdPUFgLmRcXP+qLkFqDeHrNG4ME1dOlV1vYsRoDli7Mqg9fE2YU6Qyd3/NiMqKI8oAlC0pxnocXlPHyWfP60LjlIscGQ5AgtzxTT7Pth/qYJXL1JvZkwQjg15HcNUZrSVLBI/ANDcjcLiTMAYEaf8/CIpIChO+y7BvLea8ZNqOY82jONpXL9OTz+FKlHPlVBqpF48n3LglK2QRgdyTs15mgjK8BaTU3xJ9/mJrnQyTaoT/rL+VT/ILaOF3Qd/5x9Ksvzttj+7/h5TV/lcNFQHURnCSfF6Ch72NPTeA6csxLm8z4xkhmykGe7lWNK87ur5Nt0vshQZR9pIwa0FnJUsoJh63S7TH+5j2UTAM02QfaCNSgCtuby93VWpfp9F4q2XEqqjRZhyI6w4lvMSLgAVB8vBWxt+B3eXN1LDuO4Toa61buAeqdC/8A8NruuZI383ph9mjk1KiX29vLmPYHccTJYNiAKbsS9grnS52u0X/x65X1fww0b2ts8QUyj2UbELwVxT+qC0QPmSsUeBtzuby4mJUyARJ5zmoMz8PIYs5+q99KIItjuOh8DF8LquwCDRoNUFewZWHS/A5ifkYZzgmqLNBJTu8m3iot3abAUMaqhJr4gkVmVHneG3pdyhTj5KOfMTQqKLgvbjkED40Mfg/rN8bEPbY542vxatYMq2JbHsXhyXrbF18RAwJjiodpDijQtSlxUCIcaHipEvVnayE0L8e/C2z+LpiHOaY9gBElet2002fgZiDRkcRYADXPS//kD+7gu6LnVwAvz2kT4xrRo
 nHAc9aft
 87JE+5ySBP4cor86pR7CPLiTm//9Vxxf76NOgNalupJi7a+m9rt5+Td7xVsrg0ioOaDIuW0JDudlzWZv4zIfeiJqgSq6bWUagc11y8CNNmhT7gf2A4uyVD2sKFTGr0E+lqC89Nga+SlKSI6a7zpdMK/Hhdji2/e5ahi5JyruriB1YO7zsDja5id2NNvXg1lXFAWoiwv9NIZzZUkBajnDZPJahRphASDamH0//42qSkIFPoEODhCeO1Np9jh+y3pI0XAfjGapqqeFBlMN7ryH5uRnO5Qzm4H2p/f3YfqrTP+ul4dwh/PUwgmu9hcvUHG/KgQ8lA0ehFCGlywGehaCou7GULFMHpENHzHWCH1iwTaqLi7O5mYG6ou33ewEj/JGRGcM91+Sk1pU++w3MnycqRjZYsyhh4acSyMpW9KnzJlckVgyBNKsmytCk25dPtnFL94WFKXr/8m78oKja6Tuig5MkchG6W6y6BXtxoAWUwzyB+xJX2Zo2lqjdyZE3BK71AP5cmtAuSYrg2EVN5AuX0ro78ew7JLFBFHRy51MFf9EgEK7iq6xeAfcXeJ+N9I2sXdHzBhVX+Cn3FQgWAmtYyQvSfY3GRMjLcR5OcftTd9SdfSuguaRmkvWImWWn49aG0WyJp9tV9ewRQwqWVhct8z0Dtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Not only test functions but also some other "getters" in there.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


