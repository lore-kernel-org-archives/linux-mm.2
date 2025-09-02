Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 818BACA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9FCA8E0018; Tue,  2 Sep 2025 04:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D506C8E0005; Tue,  2 Sep 2025 04:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19168E0018; Tue,  2 Sep 2025 04:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADCA58E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:43:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5570A11A8CC
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:43:27 +0000 (UTC)
X-FDA: 83843671254.12.E9DF7A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id E5D0B40009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:43:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WQVdI+U3;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756802605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPC0fHJHVlYuso8L6DuKnMgTiDgj+lznSR9AEbNPOrM=;
	b=x6s/aRtzo4V6erPpXrswwFh/G+gt0m9ejtFi4Vpy0mlOX8lIe162TOR6h0KVUjK+FbryVt
	U/rz7nBjf5dqPbtL6zHTM+GbKbNCdqTSDu2spmlONnUt1h0aM1bqwmpDeb3nM8CotmwZFR
	NmBjKaKydn4haowiNc0voyFuJZtVNf0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WQVdI+U3;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756802605; a=rsa-sha256;
	cv=none;
	b=3MsJso8AtLZdmKXJJw3uGvuxyQStCyv/+ea/ll3D0bHzRB+W70lm2GfsCgAKPk1e/5Kuje
	CGyqEYROTOKrrDMm3lZ4ip9v5IcCYlRE5R0AUdJpmVqVCosb1KlhU5WDDakrfotMJidRWM
	ElPC368wGhrqxCXux72SJQ3UpgQcW9M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756802604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yPC0fHJHVlYuso8L6DuKnMgTiDgj+lznSR9AEbNPOrM=;
	b=WQVdI+U3r2ldwNXDDxIxxdkIDwoe1DMIGW5QYuXaaqzPOZsoR7L0S1aWorXJJDBjtvjnDM
	ujP5ViEeJmvW0+0qvRPs6wCaAvgBboIoHuP9lEX8lHHA+43zOqOwsldJ+gnGKFELjaZ2wT
	VeS8GMvDyuEeeW7IUsg6jPhT5WUssuA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-fVVix-XPM9GrmPCPHg2U5Q-1; Tue, 02 Sep 2025 04:43:23 -0400
X-MC-Unique: fVVix-XPM9GrmPCPHg2U5Q-1
X-Mimecast-MFC-AGG-ID: fVVix-XPM9GrmPCPHg2U5Q_1756802602
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so2362215e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802602; x=1757407402;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yPC0fHJHVlYuso8L6DuKnMgTiDgj+lznSR9AEbNPOrM=;
        b=L8nnY7IOKiNSqS8Kr4aUzQYyMsb6QZuMXJa8h6xYrsCONUk2mPvsl6pfxyIj0xrdhl
         uH3ZicDDJFjaihj+5ZZWB2vE29JM517Vn0NhBf53v/y2uqoWQYPUadprPQGweuCfE9xI
         qmuJ5rn284L8qRrQGnAf6DNdR0f9gssnunD1XQfEaGAcf773ylEbBDq8tQSeycOsHs1a
         GySG5x2TP1NzBTQV6U7vG3Mcm2bugMMeUtx9nJA40TzNPQufZYn/NN7xYbxXryHj/SU6
         bRH979J3yE4m2gjHHRahpKbBVXMAPtVHbIbnyiLt/k16MkbgF4EsZf3fZnGXYa8VPVY8
         Pdag==
X-Forwarded-Encrypted: i=1; AJvYcCX1tszm3tAi6kksxbdwMN0SFL5q9RCEuV1maohH1qJrK68xMuaFB+prQfM8FeD26g9hRc4hVmRWQw==@kvack.org
X-Gm-Message-State: AOJu0YxvF4rZiRj/i4By5TCaVoCp2lga5y6BaO3Ai89isBjy+c9BBZt5
	RO8nJN7eNxM9WIlcnmmHVfa3hSCyl2R6CPbTuYKg+AtDx9ABti+G7tn40zlgMhsQQmLUBdLshYQ
	u753ja7YyroRxXfEokCD/b9FFidA+N+BwjrKnhJt5APAyk0JJSJN+
X-Gm-Gg: ASbGncvZe29tOLRH767XDyI7VsnjZRoG6Sc1azaBFPuBwvrICuk1ybl9MqUpqwCuj4Z
	SyBvr03PUserE5ksr4dU/zZjs8cDv4Bkuid+zBybpNSPnkrT2/AUfwPG3ynZLRoeRhuAoLRKQtS
	m7Dt9tr3lGsDglQIDpTg6ifmPTvB72C2kR0WPyK5RO5cpaao2az18iED3sgVcXpDdtm6SxEmAgL
	2EXoiCgRFjzF0eWZXRzDbSOYcOgG/NhrIap1JYLFhFIALbs2muUsle59qrSHRgPVWtYZPKucvT1
	fHo4Rsmauf71ARiz+m7Su+pnXNRtYQBc6WEK2MAx21zCsuSGVcE+PYUSc1NkgPoqulsnVtzPs0s
	n3pu7NK/oBFOz7Mbk9GfcbNM/VsfeGAby1pMN3BALF4b7r9K4NVbeyVZizXPB9fKMPjs=
X-Received: by 2002:a05:600c:3b25:b0:45b:8822:d6c6 with SMTP id 5b1f17b1804b1-45b88321d2bmr89649855e9.15.1756802602013;
        Tue, 02 Sep 2025 01:43:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH60SPINrFV8S13VnO7bzXjzRXFNuPCov0mkDO6FPkPgyTuB0VjmeJ6L20db9xSLB+WYMEnKw==
X-Received: by 2002:a05:600c:3b25:b0:45b:8822:d6c6 with SMTP id 5b1f17b1804b1-45b88321d2bmr89649595e9.15.1756802601610;
        Tue, 02 Sep 2025 01:43:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b661d87a7sm163776295e9.2.2025.09.02.01.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:43:21 -0700 (PDT)
Message-ID: <1acb705c-4846-4a12-9e90-f7853da8a295@redhat.com>
Date: Tue, 2 Sep 2025 10:43:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions when
 THP is disabled
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
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
In-Reply-To: <20250902084036.208921-1-kernel@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JS_uonP5FTOoTFcUH-B9U5Lw7IJTpWFHTy8vFL0sXss_1756802602
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5D0B40009
X-Stat-Signature: 4zdzznzktcwzsm8j8jsgmys6pzfo4ohm
X-Rspam-User: 
X-HE-Tag: 1756802604-167763
X-HE-Meta: U2FsdGVkX19P+KXEYwYOKX3SWlQRFLdqccr3ZLwtYInKBx5qZDRDz0xdwPMSqXsxrva0v7VAiBCi2AOOk0h8EdweM2f8cG+oCoJW9O0Kb19O/OK2Ofv9ztjXjcRDT8JHrZtDrTMOu/oIqwRbYbCAmfgblxpF5qIe7knCinkOsvaYna2gTrBafKhxCuDSxanKgBsdlR588RCkx3581HFkoBHljZqm9dC+Q2oa2Aw1T4I8ENhNuWfq3VDpQRtGxqd7Vrcr8Y1WIK5B3E3vKqzeC2q0RcdTYIXNHlgk4eXIIIXS89B18gKL9hLsovevhaZx4J3ByF2RwRkrPxP/Io/H6blDtxKmBgl5kkktauVbWxH3FWBiOWw0jEv1Dq1rpM8lVOMgPPr3ajvf7Lg3Q5FW9tcwoAl2QV2rgXZ0eXKcSMoNkEaHLDiIKwz1qIFdDlRzqb77vBAA2Z4wCIKzudx0Kbjl59984fBhommHxxlUi7P9KrsbpDpNQiKZWXqKx2rr4klinYuJaat33Bk7TG/txzv8/L1VQwK+n2gJEop/RO/QIjFj1HM8ycM0VZSsckcaa0VckwpgUetYhXrLuhuB1BhYvr3jrSIw9Ii7wTmXoawWnNgpjZiafTy6Tl+Wf0coOgAkqW2FROvJt6E+cYy+TnKuC5ji1p9i+xzkPIVAWyrFHbtR7lUqkzUzADcI3D9FCYGZcSxmttmb8PCuaGmmhUSApJzJz4o7TDnrVaJlWze4P/i57a2aqyUYVMz0lTBm18RHl+FDH6JDaXB2n0GUIrsoje1BSyVmk8tO73s+qWcCfArmR4+V5gd2oOcoTBEv0jjD6y1T/VMjGKTfO2R069I52f5mON6JC9GaiGN0v2RRci3E4GJPg6MWLjfEL+MC5jrEAGNBdlwpaD0h0KYLkqS0SpzZBuBI4Bh7zUjZxfFRGrTsgY4Dk6BPpcbiut/dfvzq9na9/Yr4ZH4UlLV
 khq9hv4P
 D+whaw7BGRZa7FTxoLWVC2xqWNsmDInTM1AGj5LEY0QDdDj3SBkWAH6Dz6gWSM1n7D3jQQTZVIfI3C79HVk39q/Yxu723d/MFBwLqlqZ7+v69nUTfFsQ5ekDY/zHqLHUOjCpnczls0bsDWr+EfaBbapKqVFDvURtjdFAQc8l9sqH5oI0z8p3TsJKfQy1zvU4YZof+99KSg19fqHPjmMK81OfW9O78x5nb5wwFvQ+5rHq+M9AfMLcFAZAlv2+c3pmtveN+zxKbEp1G17zNBXsr77sEJlqrdNtKlA0zN4pyjyasCewNFSMwYntrp51X7iL7OD/6YqWFnDDT1hqlBWf3LMCbZytHlClOzxOkwA6xLkY9cuKiguyRmODe4R4JB0hgFDw74GN+O2JxKeEe1rFKXgxKW54KliimjXbK41nLTqtV9KJGRt0GTicaKNjMAWPsxCKUBalpNwTe2E74g9he53ltvSvKbe+jIyLXbhQDOWs5gh3ltg7DuIrfEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 10:40, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> split_huge_page_to_list_[to_order](), split_huge_page() and
> try_folio_split() return 0 on success and error codes on failure.
> 
> When THP is disabled, these functions return 0 indicating success even
> though an error code should be returned as it is not possible to split a
> folio when THP is disabled.
> 
> Make all these functions return -EINVAL to indicate failure instead of
> 0.
> 
> This issue was discovered while experimenting enabling large folios
> without THP and found that returning 0 in these functions is resulting in
> undefined behavior in truncate operations. This change fixes the issue.

Currently large folios that could be split are impossible without THP, 
so why should this be a fix?

-- 
Cheers

David / dhildenb


