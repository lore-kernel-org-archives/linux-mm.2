Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14127CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7508B8E001F; Tue,  2 Sep 2025 04:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728318E0015; Tue,  2 Sep 2025 04:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E1E8E001F; Tue,  2 Sep 2025 04:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52FA48E0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:19:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 906B313B0E2
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:03:44 +0000 (UTC)
X-FDA: 83843571168.15.F1834F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5016E20008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:03:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b4h3P23p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800222; a=rsa-sha256;
	cv=none;
	b=W87AqEm6ylBRqFxhW2YNNk4MtyLv1/WDC6NhTLTSRoUOaNj7JpXh+xU90A1CghzzJuyNfc
	od5Zr+DODSlAMlGkLrBPWoZAjdWfEKH5tlNG92/3gVEPFfiQsGAgWHFATRpOe7GZ6YGf0J
	OXM6vIcW/8SGHAscZgU+sj+ku4Q505o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b4h3P23p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aS4Vyr1Pain/urXoI8HpaIVdg+wdDq3QstyD3UxMikY=;
	b=8jMUQSZJFFp1V+jof8fZ5Y67LPdlz9Eq83b/hS9/tg38FXPoKiJXWgMofT7NiyzPMxhjsw
	YLHL5SJtzd0vNuF8bBYWp7lJWuSA/qwr5ktzrHOXsH4u8EBUjKEV4fdbqoYcJbE+UDaGof
	J5rgtlr0G/Wk9ja5BMiOYgaHTJ3sJfI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756800221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aS4Vyr1Pain/urXoI8HpaIVdg+wdDq3QstyD3UxMikY=;
	b=b4h3P23pb9ok7l0b4InavRynzp38A5K1rzIYUZ82JO/GmH4WClTEcoz5UDYzIlZVFe+lf+
	kPoUBLLw4n33ZUiv7GtluIvIgT4p++YwmgqJjr8kAl9t+cmG/q1gcLDf1iXeG9YrQn4PrG
	Yn+4oyxBHxHTpnf+2zmZqpyZBw40i/Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-3oUFui5kNnCimWFULJXiag-1; Tue, 02 Sep 2025 04:03:40 -0400
X-MC-Unique: 3oUFui5kNnCimWFULJXiag-1
X-Mimecast-MFC-AGG-ID: 3oUFui5kNnCimWFULJXiag_1756800219
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ce65accfc7so4586785f8f.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800219; x=1757405019;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aS4Vyr1Pain/urXoI8HpaIVdg+wdDq3QstyD3UxMikY=;
        b=GVkHlHHaLXCs9M2qATaIk3Y0bda+YfrSSeUuY7bMc4bzJA2LUhEmGdH4aVSwygluPu
         bhUuXmpW+2f9tTgT4ej9eAUXvDxk4G4T/VNajR4ujBhY0vf3jFLaAXLbH6kjQfxlNub9
         qBm9hh8E2JadhFV8q9EJO/DvFLrSoS10X8azoP+qhFItDNWcrUbJNjIRNnO/RMN/Frkn
         zqpSm7glUxOy08Chku+67y07bBneV/6KOAmLnysCHh6voHU32RrbJk385sZDiu2J8IC/
         7LZzT5mRfW/eXtR3I8rw1Qwa6OknaCA6peurQISTCZfHi6Y1Y+RzaSzsaaiJy3WRWbnI
         qGcw==
X-Forwarded-Encrypted: i=1; AJvYcCVaxSVs3daZnjoJYDlvawpDv3hx+H+zeEjPyANDAHGfkC04QN7t0OjJHdilNSRHJlQyjEy/Y9Rq/g==@kvack.org
X-Gm-Message-State: AOJu0YxtUp7O4RYTB9LFahgkg7bbK54jYS7AX73lrAotMN0SvEHu+s1o
	5C94XpZC4FMwwKHfpL7t3n2iFMcJ6HDCYK/0/8+f+jGwwRSdWbu58fGlwU8+GZ90gEQebZaiIKM
	0NueGYJ5upkr8NIUYzHFtv6dFVbgZhI+gGa3MQBNhElak3SodXqwC
X-Gm-Gg: ASbGncvJ8j9k9IBDaBlvP/XMScElIjMur8DRpo41h+6KffzpOjQStlKkcxvo6/sGqHY
	ZMMNs7wyMzNyuyzL0ntNDf7syVXPOt2XcLZl3402q3hBzkzzjaCRTt8AYbQpaihA9HawSJPIv57
	VzV4t3l/5zpc0ca2NwnBm3kXluiQcR7u+LLCSayhtsl/WPLlix8vdK/2Takb5LLy8l9hQHWUKU+
	gRC1Fr3X+t4KXvK/ogvyN6bgYrCvD3hYuuapFWagA0XmqCFom6c2BuuMKbehc6NAZw62J9zRmni
	r3SYguIdRiUKKVcIDppL283qTIL2/nFPLewzSYjCr/6lzCXZLFnpwLZ1vnAZvsavMV4UsIbDKgm
	MzgrbFjW40NzqR7vwp9vgNkn0+JZWprr6amTknf1b0XloA5gPmCndJEyxkHgiprKTKs8=
X-Received: by 2002:a5d:5d07:0:b0:3d5:4967:1895 with SMTP id ffacd0b85a97d-3d549671ee8mr6894424f8f.10.1756800219156;
        Tue, 02 Sep 2025 01:03:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQpyPxYTW4X3f3NKWjIgNaSxeeHpjwanEWaUJCVc+WrhnHijlVjaMRV/TGhD+ddM98xdJSAw==
X-Received: by 2002:a5d:5d07:0:b0:3d5:4967:1895 with SMTP id ffacd0b85a97d-3d549671ee8mr6894360f8f.10.1756800218588;
        Tue, 02 Sep 2025 01:03:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d690f2edf1sm7879366f8f.16.2025.09.02.01.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:03:38 -0700 (PDT)
Message-ID: <deaabbf6-655c-4a83-b5f8-131a6be7b2fa@redhat.com>
Date: Tue, 2 Sep 2025 10:03:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/12] mm: constify process_shares_mm() for improved
 const-correctness
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
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <20250901205021.3573313-6-max.kellermann@ionos.com>
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
In-Reply-To: <20250901205021.3573313-6-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hclIY0g0yuEe20Muc9jjJPCDYVNBuJyuT1SyVWs8dKU_1756800219
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5016E20008
X-Stat-Signature: 8ypd4cmaaf1tcxjdf3kb8nh6ycooy1zh
X-HE-Tag: 1756800222-811409
X-HE-Meta: U2FsdGVkX1+P3Uy/oL91HNWgJO2h7jaRw4EQCyy6VegKW4lrz04C/0LJWwlKQhDQOtGn/enFwjNcxzdRZkjBx0o0sf2ULl3/RLRlP63I49cvqqm309C8RUn9uHseEO/LWUMwh4mvcCUJ4Kglkd5kir2862U3Jj8r+06Rggiz6v10wBBjDB39sJtjkpwgQzB/svrqtP4BcEnOzXaouIjg1Tr97eaSAOzyGCo0+Q+0aqfus5dEIST31PMKbBUNX2j79fToBzM4PQxhBpcL3RTVznkNkk4L8wDQNMDABFzoZL9x97/S1bBPdNUtGJG3H7ZceAMk0dRtgnZCzZXRbjYG0FP9fu0u+z0W5Bz/NtOpaR94TrUsEZl3IEuV81MOXdBTrCN3J0pcBmZ8SGWyzfvTlOv5IKsc6Bi3FRQwWO9z7htyHjJ/odHkpQ4pWNbJipGgGXkY7tE7PYAMy9Hr1ZGGMoH0dB8Ux66IS/NrKWUznv/pBgfQ1xxcgWj2PnoJBg3q7AXa0+34vJebhyFIsvvygeBi4cMAXKBPhcTUOA1rn3F+DxRaW5ayroSABsx75Mt23cu5j5RZ/H9gkTutCxdj5HILIb6LO3XeEQUApLu5gWvv4yHqLP6Zdk5lit8mDRI6MztuNIH9lDdmPBKrx8JAKOypr1wykosn3niUfQ6MdmCUxCuR8K4aWirh0I4xumAD6NwGxF411RaxvLdQVzHSfuk01JD55ErDm7m1vntQdKvakRDuYrMl9qv2prwFEuKLPuqnTctTDtJIhGMdwTU5OIpjVB435uQRO/83HlyY2szj7fwIDFetsE636GQ2ehJQQVtEkTtjdxZWP/3JaTHVXOsmH/4mGoQC6KjSCSGQLXukMlU0IkmSvpFKNawkSXgabrBxDxrPxusqDTFL6XjL5l2UHlKRHPkbOTMjnQKlZa9YUdz2Kn3bdXhOBqm+xKL/INvsYp1MO7KaG+Dly4L
 j+GdBQtf
 OfX6NjJ4QNT7wJiGnNcAKZ8LWaYNpt98BShdoRZZAqcG7OZTde55FrKibSM7wVcp2RpvPx8Iyd3ajQpA6A13bKOqpC8tfbmma4NaV51yHyK3z3VC1Rtd8y9BPZ9J8/MFoDjsL9cSYEDshu1JyDYXYlAbBraToL26QFtSXqF7qv5aXZdWLN/VZO7Oqn7eV4RLQiQvuq87ZCcJA7xp+Fj1m8johb5En9mJbE2HKIT1mj0ToL7+mjCKY/ay4sBaPdJEcgW0EznYAfysJvolGXQupWkpi8+XP5gj4+DBIfH9nHEwlCnBaguADxjZZmQkW2m6loR/NBxq7L+axh82d3ngK3ff3FrMYdxfkw59Sv5ynciG8G+upUAl5fBAEOP1ZiBRyodtMRj29zrOrvBLYP9fN0J+qQerigOo67EI1Na0C8OWrOA+oPU+0Ec+9ljLmzLbdxPetpItZq1oDNG7WoyMAaecwRVWgpOgVUwgzxkfGHaHVktXO9uA6nkEURwHGDIcmr24CK07X4uKXkM/HjvoGk3ThbfORZxCpiUSH0grcqq6SN2ecRvVpD325AhqkO9YXNDp0sJm8KrqT70yV3TGN8UK+D1nhAG5HxtLongxBjloGRhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 22:50, Max Kellermann wrote:
> This function only reads from the pointer arguments.
> 
> Local (loop) variables are also annotated with `const` to clarify that
> these will not be written to.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


