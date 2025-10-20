Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DDACCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40C9C8E002E; Mon, 20 Oct 2025 10:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3F48E0002; Mon, 20 Oct 2025 10:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2658E002E; Mon, 20 Oct 2025 10:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 15E4D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:26:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB4131A01B4
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:26:10 +0000 (UTC)
X-FDA: 84018717300.08.406865C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A9814000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:26:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bvQV5ree;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760970368; a=rsa-sha256;
	cv=none;
	b=asVat1KUsx5qAg1zdZC1THgX3ATY9FLTRxLk9UvQGIOqGZqLLxqI4MqTLvLzDps2xzJYpc
	qqzwi0OwVHS45RqMPPVjIFoHftZSegkfB3DJywGGZb2/EcsIq4FEQ5yXXUYnQitqbzFWHc
	sROSE1QH4+V57O+BMgDgBw13yr0ky+U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bvQV5ree;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQyqqPVnzX80M9s6VBgWNHBBaztCyITJ++CqjP/sV5c=;
	b=x8CEn8Dn68zr90cpks9A2v5N1zwal4Wi3yKcOENeFupe3fufRL/BMjVdtjfJybXlMnZCaO
	YfYB0bnwbkuNrD+RD1jEwtAB6ENh50wbjnqZ6JR2ZuzvkI/1SX6LLguEZqpn0U9kLjG+Sm
	PwovpWWABMJjnLzL9iNMI06r9NQvgDE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760970367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pQyqqPVnzX80M9s6VBgWNHBBaztCyITJ++CqjP/sV5c=;
	b=bvQV5reeDITVvD5GR0dHTxfpab0PuPAJhWWGjRqBMyd4472FqdbWQydPbRsZMU+vXjuUWx
	uF4B5eASoviQ0UZngUQUm4LTwI7hNXcd28se+HSKajIKOmDSXDccVsvuguLUIvtV1+bc3E
	peXs4YcZCZwJRe+er/bGS+aHD+ljSC4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-9ZzDcytROWKRvlb-m0AIyQ-1; Mon, 20 Oct 2025 10:26:06 -0400
X-MC-Unique: 9ZzDcytROWKRvlb-m0AIyQ-1
X-Mimecast-MFC-AGG-ID: 9ZzDcytROWKRvlb-m0AIyQ_1760970365
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47113dcc15dso32657915e9.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:26:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760970365; x=1761575165;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pQyqqPVnzX80M9s6VBgWNHBBaztCyITJ++CqjP/sV5c=;
        b=Trr2QTRblRP1wzFzmkmhfW7TkxEPhqWJuYmRNBJIEmzE72CqsTP25D92lmKHSwQ/mH
         SA7cLkrxe7Ce91leK6HX7ho3IAtQZOV1FjaaflJRFf6leOhyfigt3KnzUoGVjvU2G+Ac
         hIHSzmiCYnyc09Pzm5Il/Ei0j92pUWf19wEEWmRI1I0QZLS97lxM0jr5lPNJuGfALJxO
         3TzWUXLaL72TdJULrgi5OGrS2WHdzLUsFSmWBL+yXxXFDAY6mJVj6w1xaodyaVbnSpSh
         gsQg+xaCOggdPtRvALpRUxGTJbu/KOFbAGhe965lTpgxT31KTAO/TSMEzRP2d+LqZW8g
         TBjg==
X-Forwarded-Encrypted: i=1; AJvYcCW0uZIz0TjEE3hS7RTumua3J3wzCRF/BBLq5py50+M4n4p78i5YB9wgUyRdOQUWyQ23ecC/Wvwu/A==@kvack.org
X-Gm-Message-State: AOJu0YxqrY2GDvVswTHyo1JD4rSaBHbumtinPKtBtmCRRTg5ivPvsw0c
	ZaRJiu/Dq473cfDUs+uwQR4KvBzzNB77OmGP/z5TjOJoYEO3elAsBNgkcY1o22MHu8cC8NrQ+IH
	kJ/pKcYVytIrXb254LaqDh9DGbjO/b7uNzLE80KL5sz8+mMnlqB0d
X-Gm-Gg: ASbGnctH/ys5XwcOfevpbKVzHZWmXzDmE9M4s4uGYN2qG0EAXJjHJvxA8e2AfOU2Yd9
	ozYZD70J6I4QWcgbed/xgW/fBTYa7yWzqwKNzwlpo4bGSOzRZDN7j1PbRUbuK8N/lAFltED2f9y
	llTlsfO2c7Zr65ThyJ0xxQ8USEpUbkgxKV4DV+c+WnWPYZMH2RApIUdA7X+0Al/1IxJsgMEkni8
	xb9PPxR/Dd1C6kDcMMHNuNpXEobgJJuZCN9RLtnBoHVGWhL4+4vp5tvQ8V7VgImZ0LtADSL0awq
	1sQYnvkfl+KGcdmUMUxRLXQo0od2eX36qVyfAOPk4Yowk2EgRfqLS9iHwhR6/BKHzQyWD4qXqom
	nOJ/fk3Kf/PBm9ltDdOPv1vRmKKraIJ/gWHlGAcrip7n7PENaK0ogPqE4AcrHVSoYh+9ND7FfB+
	SUMzG3CSclb3ApDYafxr7S4hC3YH4=
X-Received: by 2002:a05:600d:62b1:b0:46f:b43a:aef4 with SMTP id 5b1f17b1804b1-471b5341411mr31713365e9.38.1760970364934;
        Mon, 20 Oct 2025 07:26:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFivef5uKK4dO0bLoUG5afbj0PkGjj8ivIcoCqNvXGcEAdVc8Dd+wjfTpX6dFddxGB9NaRtjw==
X-Received: by 2002:a05:600d:62b1:b0:46f:b43a:aef4 with SMTP id 5b1f17b1804b1-471b5341411mr31713105e9.38.1760970364447;
        Mon, 20 Oct 2025 07:26:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715520d753sm148339825e9.13.2025.10.20.07.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 07:26:03 -0700 (PDT)
Message-ID: <4f2066f8-f26e-4704-9f75-4652d4018cd9@redhat.com>
Date: Mon, 20 Oct 2025 16:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: Baolu Lu <baolu.lu@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
 syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 dave.hansen@linux.intel.com, iommu@lists.linux.dev, jannh@google.com,
 jean-philippe@linaro.org, jgg@nvidia.com, joro@8bytes.org,
 kevin.tian@intel.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org,
 mhocko@kernel.org, mingo@redhat.com, peterz@infradead.org,
 robin.murphy@arm.com, rppt@kernel.org, security@kernel.org,
 stable@vger.kernel.org, tglx@linutronix.de, urezki@gmail.com,
 vasant.hegde@amd.com, vbabka@suse.cz, will@kernel.org, willy@infradead.org,
 x86@kernel.org, yi1.lai@intel.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68eeb99e.050a0220.91a22.0220.GAE@google.com>
 <89146527-3f41-4f1e-8511-0d06e169c09e@intel.com>
 <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
 <d1a6c65c-6518-4227-8ec3-f2af4f7724ad@redhat.com>
 <13d660ea-9bff-47dc-9cd7-ae74869edc5a@linux.intel.com>
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
In-Reply-To: <13d660ea-9bff-47dc-9cd7-ae74869edc5a@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nmRo1dC2VHDDhqd8QS-GqaC3nMqh0qe5voTtlLcq5uA_1760970365
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8niaaa7394zqjiugkm9h8nqx7gd931zm
X-Rspamd-Queue-Id: 5A9814000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1760970368-401323
X-HE-Meta: U2FsdGVkX19p8MBmlpIvc2DufheSWSc40AmSn0nsi5tF/jAhRZS53NWWj1jOUERTm/223CHLKozHpQ1g+esXI+VZ5UDyG4TeuAs/QKG11z6ZX8Vu49CZzwfAco/ss5fydDHdVSgOFBbY7BdYK9sXK9A6xj2VApOiBLhRi3frJlh35O4bLlhi+QyjzukmmOoP6TWI4Y0m6MQoPj/BSkqcUGNHmxKKtd1YsijMUz1XB2yQuo7VsVAU9HZDOs5fIFrX8Ql+OioON6FnlS7Pssf85ysqOAw/8m+gvPafb0oyuRKyLjtW8K6JDTFIGiLeqlFTolB1pCiFFPiKP89G2qHVBjl6xRYHZc5PYvaAIciiXSbGecH6kHTY6CHcQ2ny89hDgPQlECume2OUiy8qZQAU3/TucyVSW6BgXRZRz7q66YsGFCO6ut93bJcf10Rc1lLnJjYIkHRi2HSUCs7WjH1DrKixrRqhpr8XYS0vQYeofSudVF7Y6HMvvO8SkjjSBnQ2iSDRSxtewUqNeWfkM8hetFBmsJvOev+AIIEPtAszMWGufY7X0sbEjYhUB1gV63pgZdmjHSCIOtA7rZ+jOQVGD10xpYPj3/2BD/TSpbiofxJY2xvpujt47EjvyuInTA6ly8FMbqhBb5wf7tK+mW8+G5Af9sVY0D3gxtl+WtCRYIP8Y0UVW70Y03eDuGL+CWA3W1W25ZEavX9wE87UT1A+53LHF6G3rRAEvIJ2g/nGAUx5EZU2jJnP184LCzHJSLfelscfdNBwnduetWegERbtPv2CyCTzHldRCtqOftx6xg5V9z02Koi+PHpuleSk7Ia9UDEdkiXoCK3sJOJlDxjkmWihLysLojETpyawRiVjKJpRneK6Za8V8+mpXNz0wvPINKjGicLQl1ykCPpZdX7O2hD+ZO0Fq1O7mcY0V8tGUuLcdNA2ue7d2avgpu+PvaanQWxXUrmHNWQvBxjrFUs
 MYaymtJ+
 pPUp3ntWO39qCzqeCWUrtnBb2bf0R/mZbet7V5m0BF3qac/lTyTiyfrKyzQm8VU8HU/TzMZe4+wskBK9l5rSZ1uB7UkZmDst0uiChvo5eYKsK1ukFLtePnkAuotX+fYAXsk+H3tRoDZY+mRfhzBgrIC/u3bIxmxPY183KHM16hWZAzHwRiREr0djlJSlfOPrB2O+Zh8JlEmXdYPfRF1RZQlGeaAqYOtmQOaXxv7hEb2RpkILpaB2j+zgrkccXqysWSV0bPJoQi/kj84OxAC0lOxjeW+hrfYWcTwnds6kqZnGZRu/Kkt69k8bK0+Rkt07Uh3MEmPQjnLYJNeO1TPl/vrwi0OmGVWDw7ryU9P4nZZupfq+frkkKLIVjLmujKYJLiCpD8NYSs3HCHvaBaZn+/MEBx38fKiWEUxVThM0YXhmVPgCZbO0yypQ7Y9u9pIakeK6IzXl+pyuqiN5HDX5yTPw6LL3eTJlHhp3Oc9ZYI453ds4XyKgSWnsCP9/yo/a9Gs9Cf0Bo+YL1JBL1lsbf1zxDlXkcRHHE0661NokSm12qOIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 07:34, Baolu Lu wrote:
> On 10/18/25 01:10, David Hildenbrand wrote:
>> On 16.10.25 10:00, Baolu Lu wrote:
>>> On 10/16/25 00:25, Dave Hansen wrote:
>>>> Here's the part that confuses me:
>>>>
>>>> On 10/14/25 13:59, syzbot ci wrote:
>>>>> page last free pid 5965 tgid 5964 stack trace:
>>>>>     reset_page_owner include/linux/page_owner.h:25 [inline]
>>>>>     free_pages_prepare mm/page_alloc.c:1394 [inline]
>>>>>     __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
>>>>>     pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
>>>>>     vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
>>>> ...
>>>>
>>>> So, vmap_try_huge_pmd() did a pmd_free_pte_page(). Yet, somehow, the PMD
>>>> stuck around so that it *could* be used after being freed. It _looks_
>>>> like pmd_free_pte_page() freed the page, returned 0, and made
>>>> vmap_try_huge_pmd() return early, skipping the pmd pmd_set_huge().
>>>>
>>>> But I don't know how that could possibly happen.
>>>
>>> The reported issue is only related to this patch:
>>>
>>> - [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
>>>
>>> It appears that the pmd_ptdesc() helper can't be used directly here in
>>> this patch. pmd_ptdesc() retrieves the page table page that the PMD
>>> entry resides in:
>>>
>>> static inline struct page *pmd_pgtable_page(pmd_t *pmd)
>>> {
>>>            unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
>>>            return virt_to_page((void *)((unsigned long) pmd & mask));
>>> }
>>>
>>> static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
>>> {
>>>            return page_ptdesc(pmd_pgtable_page(pmd));
>>> }
>>>
>>> while, in this patch, we need the page descriptor that a pmd entry
>>> points to.
>>
>> Ah. But that's just pointing at a leaf page table, right?
> 
> Yes, that points to a leaf page table.

Right, so I guess there is no simplifying that.

Like we have in pte_lockptr():

	return ptlock_ptr(page_ptdesc(pmd_page(*pmd)));

So page_ptdesc(pmd_page()) is the way to go for now.

Sorry for the confusion.

-- 
Cheers

David / dhildenb


