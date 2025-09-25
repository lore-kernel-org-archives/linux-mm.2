Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98500CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 20:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37AD8E0005; Thu, 25 Sep 2025 16:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F9D8E0001; Thu, 25 Sep 2025 16:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE148E0005; Thu, 25 Sep 2025 16:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0D3F8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:12:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5533B1A04D5
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:12:00 +0000 (UTC)
X-FDA: 83928868800.19.C137E6C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id DFD50C0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:11:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A9aFDeTF;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758831118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbdNHkZwL7Xvs1kb7Vz3lIvaavTg0vqw+U34Fq/laSM=;
	b=U05v43QpXvwQHoxbed++524FEE5hIAVTvzkrApC9p+3L5WAn9hFb0t1n8ZvbjBSoSTBoyz
	XLB7hFc9g74CjjJAR6emuP+PfzZGflLZHUmUJQ8R+4Ng00A18dk0KWT26uk1v4gDg/r09C
	mhsBVaG2ELgbB4LUJ2mvLZoxdMVm2q0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758831118; a=rsa-sha256;
	cv=none;
	b=1lFT/lujZ9rKTWHJdC+JqDavlpVHJ4EK7EM+AYM4OYoryJI3Z8/p/AlsRldGwFtotKXNos
	BDaIrG/eidOGTNrU4fZLxrc5svljbXeNLRckUk27wFaDwutualrqb1Ge13dYBo653+1TbF
	oSZUJQAMaiE+2FGuX0a2MMGusPz35f0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A9aFDeTF;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758831117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BbdNHkZwL7Xvs1kb7Vz3lIvaavTg0vqw+U34Fq/laSM=;
	b=A9aFDeTF4npcu3ZRqZTy+613499S5WTNvy4nASQbRz+C515ohjB3lRK4JD9k3sQsW5cOIU
	bptpvS272pJMryW0WAasO91XCw1hdQEhxwEkN9zednC3ahmFBFi8ykBDccaOdssqdg12wi
	cNapLtxhMEjxwgl7dLd1GSHAGFyHi+I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-VdkS34mJN6OACh559ZQlPw-1; Thu, 25 Sep 2025 16:11:55 -0400
X-MC-Unique: VdkS34mJN6OACh559ZQlPw-1
X-Mimecast-MFC-AGG-ID: VdkS34mJN6OACh559ZQlPw_1758831115
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2b9b99f0so8253395e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:11:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758831115; x=1759435915;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BbdNHkZwL7Xvs1kb7Vz3lIvaavTg0vqw+U34Fq/laSM=;
        b=gEUgNh+e2CQXaP/dRQpNLJJ9k1ViMGHe4iAPuzv5vZ6frn2Sak8DxcQku+6+NTj2Wc
         cQmweQjCSN9W8VLxjp1NpN/bk7lenjWvrU1soPKtioqRjG6yoDHMi1ZAOrYWkwj5GF7d
         JB70bjmP+7m0kBPrDkM/BDqu3X11xDskyoXvjudzAAD9w+52r5fDlI3QplO+7nPLJGQH
         AV4S24R4+XzFiDz96MJ7iy4RdlwxdC2slLVbWHRORA7yR8xZsnniI/bSw+TDlMkDfWL4
         W/5fpN0w+vZZGFU3ISwKYzsu84eA/nLOKwDs1p69puwLf+A1DQGWE+Ys8RFjwFuurmSw
         w1vQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRCoVPYjt6DxD68lTIHfyHoHSoidHHgs1QbvEvaK6rwC+rIQjcYvdYhiwDJo0YzMqgyQX0aNPK/Q==@kvack.org
X-Gm-Message-State: AOJu0YwWA+uqoh5vALmbb7vsbk2VEpMVoVf7OZifXz9zYuoZjBlbaC3q
	XwHEGNZs+caWYXD7d0ozWTGApU0z5VhANKnbhh8dltW4ejq44LxiFaFZZ5twHksmNZ2mMqwX0dS
	08zcWwsJn/2tsNuEA1MMNv/XBmkZnchQl8ZVp0v9y6+s4Ww0VIF4c
X-Gm-Gg: ASbGncsiZ1pbnVsbrFNXN/37iOn2AoQlPnJks+vplz8VKhiAE2EI2niIDafVdKjoJuN
	R7ingjz26aBonBWvMCtFDkN1HDB+hN2A8moZWlT0tEJRtj6ytMNo3DywapHrMxZbKjl3qA88WfZ
	qhtz3igvBFDmoSjkajVntWRwdMHE9kIbfRxL5Ssr92IJ2wrk3ymTSqzuWfVrO4/7vaE3Zl9nAdz
	s14SID0ppi1C1iJWm80HeMAfssikk2uvaGu4Ae8m84S4a/j+4HjLutHprV/1hhIFezETLb+dMIW
	bbz+TI8qUteDbh0rdmHdSrz5tm1BaYO8SNFxEpblZZGNCDZ/v4r9XaaSIMcJcs2iKP1I3iQ4U/I
	YKMjvykFnVSGWK0nsnzhib4uCCpNZxJmg1gDzFapCrnBk7KCfsBJgFMfborEMmIXGheTY
X-Received: by 2002:a05:600c:4ecc:b0:46e:33ed:bca4 with SMTP id 5b1f17b1804b1-46e33edbe6fmr36930105e9.15.1758831114653;
        Thu, 25 Sep 2025 13:11:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEhVhCGcgmO1k+G3XLxgUOwBHZ0rAO9DXf37klvFdy0hgaj1Ui37fjLWrqz9lgbSvmF4VzUg==
X-Received: by 2002:a05:600c:4ecc:b0:46e:33ed:bca4 with SMTP id 5b1f17b1804b1-46e33edbe6fmr36929885e9.15.1758831114203;
        Thu, 25 Sep 2025 13:11:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996bf1sm90335925e9.1.2025.09.25.13.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 13:11:53 -0700 (PDT)
Message-ID: <1497a41d-3e43-4654-a28a-2049ab4c4c0b@redhat.com>
Date: Thu, 25 Sep 2025 22:11:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: Eugen Hristev <eugen.hristev@linaro.org>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
 <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com> <87v7lh891c.ffs@tglx>
 <95ff36c2-284a-46ba-984b-a3286402ebf8@redhat.com>
 <24d6a51d-f5f8-44d7-94cb-58b71ebf473a@linaro.org>
 <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com> <87segk9az5.ffs@tglx>
 <f8d3c2d4-8399-4169-8527-3c87922f2ef1@redhat.com> <87jz1w88zq.ffs@tglx>
 <c3ab4a21-183f-495a-b3b5-cc74b392eebc@linaro.org>
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
In-Reply-To: <c3ab4a21-183f-495a-b3b5-cc74b392eebc@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g4EIqcRrx98vhqA7qMFDMOahXbRDjZkf6ZXSl8aejQo_1758831115
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFD50C0003
X-Stat-Signature: 8aaras1w6me34oxfgkypsscaoumeseo6
X-Rspam-User: 
X-HE-Tag: 1758831117-229864
X-HE-Meta: U2FsdGVkX1/0+ku6W4Y1wfxwxoHyrituhqB1c1viN3mFbt9JFGqfHp++090U9aUuVE+/jZuUfdZsB3ciSfVkFRpMC3Qqjby2L/PlKQwgmS3X68Px/OotmXtNSeu7x900nzo5AwZBvGGSZJrmLNzq+tKew57zZ1rsh7b6SImkEni/nMqWnJq9E/IccoD0rZ0j9Qe0Kz6ciKR6oyyE941eFwXtkhRE1SDRBLPxSp7X89xWj6/YzSkJgzTfNQly0Sl0mkCoJJSDElfJYXMGJ5c2j+KAzSdzhvbjPzTjcokL5k9I5D7icpRmJmRDKdT4g60aCBOVh3vEpGcNy6jReQXroxdhSRceKlhH74/rJmmk8hiB3DCX0QvkuZQRW/cbrY8u39l3pN1vHbwXLa2YLkB5Ah9G/UKov38pyqX9t+2i+xk0oQk9xIJjnREVi7y51cYzJvunUz1ZqzERCLgh/R0mJVFW+uWmAqa39a4Y8TkqQ1q+mPUuCG0uKGJrqSh9vqXedX8k2n04mniG47Wst+u8FoBK+sT3Jxy1DXqLBlWpMQJrIlFnI0YUyr0ugudOqkrzcvFDxsreSlwgmuHwx/AH6bGLtc6RUHNFCBXY0QXFlAkiXNz3C+nemx0r6MrK/rzWd8uEQEAHxHLesifw2uND95Wov/0WC3cAfC5JWDULHLBsX6XUdxQqcJJf5sc4ClfAPB/hQFTa4yk0snu6u/QblWHx1qHnrdEy/8YemNPUGrEpc8Lz/V33j6TwBO1YOA9851oFXMFFmyHT5A5nMgkWLK7WjWCVNVfYk4QW3RrLTPJcVi1Ia3sJTjSsIy9OqjD2u+MMJjBPAVH4NFgKGweB1PcYmRuEiI+lJMeAo2wKRyLDMWBm/ciGYq5sYwN+R6KHDqClEwK6YCrzAg7Fh4faYVqLrudr1o597UoaPbp2vAxsFRq80ouYnaxtKG4sRd0ketWJN0s0Or+vOnDsKLW
 0vGzfGUh
 JHRcS8iw1ubC57dK4u+w1sB0asalCSC7p1zXdbcsdUf7W9SG9o9uB/+wt+mCXfHUqIX8u0Yyzlk7MtAZwxFtNMviSfloGF/FSwOsc7Oft8/LRfUHkCe/GbWTjWrdZbPKkZe+U6UaK+yErebY9Vhzokcx9vPdYol6K/YAlyCl8IAe3NM8fNU/Se62yLCazDv9tp7uDLwgyNXdasYzLs39BANMqztpiwmzscsm8qj5eYqZ4o5+9YduiF1+3M14NjLaMQF5Sa+6hR46EyhqKjSI0yqg+Y41q7LqVjo/felUpUcMpwu4hRTgN6G44UyHG+79U8yptgZlWSOBq4AN7c/R57NSlDPWFcvAEa0UOdfOOw3k0/giEobJ6wkHXbP0fJBo0P5EMim40bv983xRWARDYqXXxGewDeIzSbSi6JHJrcO94eAq9o0IHrA+lmJz/8Ie08zK/X7UEBgmXU5jhKi6nhdVLItvJ84moVZRC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 15:53, Eugen Hristev wrote:
> 
> 
> On 9/18/25 11:23, Thomas Gleixner wrote:
>> On Wed, Sep 17 2025 at 21:03, David Hildenbrand wrote:
>>>> As this is specific for the compiled kernel version you can define an
>>>> extensible struct format for the table.
>>>>
>>>> struct inspect_entry {
>>>> 	unsigned long	properties;
>>>>           unsigned int	type;
>>>>           unsigned int	id;
>>>>           const char	name[$MAX_NAME_LEN];
>>>> 	unsigned long	address;
>>>>           unsigned long	length;
>>>>           ....
>>>> };
>>>>
>>>> @type
>>>>          refers either to a table with type information, which describes
>>>>          the struct in some way or just generate a detached compile time
>>>>          description.
>>>>
>>>> @id
>>>>          a unique id created at compile time or via registration at
>>>>          runtime. Might not be required
>>>
>>> We discussed that maybe one would want some kind of a "class"
>>> description. For example we might have to register one pgdat area per
>>> node. Giving each one a unique name might be impractical / unreasonable.
>>>
>>> Still, someone would want to select / filter out all entries of the same
>>> "class".
>>>
>>> Just a thought.
>>
>> Right. As I said this was mostly a insta brain dump to start a
>> discussion. Seems it worked :)
>>
>>>> @properties:
>>>>
>>>>           A "bitfield", which allows to mark this entry as (in)valid for a
>>>>           particular consumer.
>>>>
>>>>           That obviously requires to modify these properties when the
>>>>           requirements of a consumer change, new consumers arrive or new
>>>>           producers are added, but I think it's easier to do that at the
>>>>           producer side than maintaining filters on all consumer ends
>>>>           forever.
>>>
>>> Question would be if that is not up to a consumer to decide ("allowlist"
>>> / filter) by class or id, stored elsewhere.
>>
>> Yes, I looked at it the wrong way round. We should leave the filtering
>> to the consumers. If you use allow lists, then a newly introduced class
>> won't be automatically exposed everywhere.
>>
>> Thanks,
>>
>>          tglx
> 
> 
> So, one direction to follow from this discussion is to have the
> inspection entry and inspection table for all these entries.
> Now, one burning question open for debate, is, should this reside into mm ?
> mm/inspect.h would have to define the inspection entry struct, and some
> macros to help everyone add an inspection entry.
> E.g. INSPECTION_ENTRY(my ptr, my size);
> and this would be used all over the kernel wherever folks want to
> register something.

If we're moving this to kernel/ or similar I'd suggest to not call this 
only "inspect" but something that somehow contains the term "mem".

"mem-inspect.h" ?


> Now the second part is, where to keep all the inspection drivers ?
> Would it make sense to have mm/inspection/inspection_helpers.h which
> would keep the table start/end, some macros to traverse the tables, and
> this would be included by the inspection drivers.
> inspection drivers would then probe via any mechanism, and tap into the
> inspection table.

Good question. I think some examples of alternatives might help to 
driver that discussion.

> I am thinking that my model with a single backend can be enhanced by
> allowing any inspection driver to access it. And further on, each
> inspection driver would register a notifier to be called when an entry
> is being created or not. This would mean N possible drivers connected to
> the table at the same time. ( if that would make sense...)

Yeah, I think some notifier mechanism is what we want.

> Would it make sense for pstore to have an inspection driver that would
> be connected here to get different kinds of stuff ?

Something for the pstore folks to answer :)

> Would it make sense to have some debugfs driver that would just expose
> to user space different regions ? Perhaps something similar with
> /proc/kcore but not the whole kernel memory rather only the exposed
> inspection entries.

Definetly, this is what I previously mentioned. Maybe we would only 
indicate region metadata and actual access to regions would simply 
happen through /proc/kcore if someone wants to dump data from user space.

> Now, for the dynamic memory, e.g. memblock_alloc and friends ,
> would it be interesting to have a flag e.g. MEMBLOCK_INSPECT, that would
> be used when calling it, and in the background, this would request an
> inspection_entry being created ? Or it makes more sense to call some
> function like inspect_register as a different call directly at the
> allocation point ?

We'd probably want some interface to define the metadata 
(name/class/whatever), a simple flag likely will not do, right?

-- 
Cheers

David / dhildenb


