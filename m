Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C54ACAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 08:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BC88E000B; Tue, 30 Sep 2025 04:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3278E0002; Tue, 30 Sep 2025 04:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAFC8E000B; Tue, 30 Sep 2025 04:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3C98E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:54:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BFA187821
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:54:08 +0000 (UTC)
X-FDA: 83945304576.06.58EC72C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id A601420013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:54:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dHVrDJpL;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759222445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHYIX55sfVLVhuTSx6IpeMzw2EcC24ufO7Z5N6eDhnk=;
	b=Y93oDAKkAtQgZ1EhPa8J4Jm86U5wvJyS/gCDEhQA7yTFhvuRWcFzCkSksPVvjkep3PppEr
	9S1b2zDLAIaSekEVYgQc691HsVE/E/zmOfsWqS0iDQHBgUatmzeZw8YQAmvJLnxHm9AZ7B
	CUusoEeVN2QIbErzZoOiEzdYMWh4ck0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759222445; a=rsa-sha256;
	cv=none;
	b=dgR+7Wu6bn6qvrqstO+Xfxi1krEitZwSWEE05nQb7iyupDbg2v2/OoIk7eGDMureFQCMfR
	Y0WYbeXcongpgpOfEt0KNzdwn7xW/KURIDqPN74/ZPy7FUWhT6IaS+WdtCkm585WedV3KP
	/jTIPsj+qeK5g0nYhxeZ/ZM574vy/bI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dHVrDJpL;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759222445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HHYIX55sfVLVhuTSx6IpeMzw2EcC24ufO7Z5N6eDhnk=;
	b=dHVrDJpLThikvOibYBo1E0b9fM+H1p+8bLs3RBuWyHNFAhgY1trF30xCakYMTAGaoWfMDk
	wg1ypl6jzmOOZh9jBvPLpzJSMzyejzX396pWVebNvr0SPo1AO5FO+rvdRoph6ke3wO9YGD
	Kn3OFpIEUgdtOsY5MmCSd3zlQl6O8jg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-Q5P7L4kzPcmS5v_H46n9BQ-1; Tue, 30 Sep 2025 04:54:03 -0400
X-MC-Unique: Q5P7L4kzPcmS5v_H46n9BQ-1
X-Mimecast-MFC-AGG-ID: Q5P7L4kzPcmS5v_H46n9BQ_1759222442
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee10a24246so3244853f8f.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759222442; x=1759827242;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HHYIX55sfVLVhuTSx6IpeMzw2EcC24ufO7Z5N6eDhnk=;
        b=QV034RWh/BSQSb+OLibKNnf9e2hjm4c3UrGVzkT1+cUG11M+cairNtPdmc4a1+l20A
         paw2lb+VnK87cRxBp1EK2ga8gB3m/1pnpsnTKcZ/VlFAfmEMkW3lD35cL+Dd4ncZB/vt
         wFAMhqsUI6gvqw1hczPmP8nEuLE6HXDztIffaCcnjxzcX77gIqMyvilnpEuq0+zqF7/4
         iZOK8nR8BsHxj5CRXBoCN7KKCTgK+tXuJ/R/sDK2/MrU1V9G00IwJfHp1c2fGuGWa2LA
         nQJ4NhSVRdZB6eSo27uCVhkrheOwppzlyozkbf5H6boQdQQ/32XGsxpMYhXk/6VFRuhz
         +ExQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc7huZmu1tdoB14lM9/Ej+TqXP9p89WxtbwKQPRnWuU1C6okAc0NJgg6PuHb4sidWJYgvuKeUenQ==@kvack.org
X-Gm-Message-State: AOJu0YyULqhTOWD1HXNUxU/BC6q+PZYmOECT80E/SJdPgPJy+z9uoxQ+
	Mj2QSKhPQunmUT36Bp05eX6ofGZdWPNp6kbuBkmxJ5BUTbZ+LX5xLuEy9Vnl7qImJoxJEjeMSpU
	krF9kBIVPV5ztDnSPQPIWhHPCmnGDatbfiZxcikDblVXUrTdz5x3V
X-Gm-Gg: ASbGncs7fgkFUuipEvtUghpsa7vJw/ZcfurEKnXvyLDRea7Kg8eoGGEfr03hKPJT9dM
	F0FW1fHlYlVrYJ+YjIDRTF9vQOTOyt4OF+tf8zmsNvp7JqRV5EzaeqjKZh4Y3ee2hyTNpGXOHT1
	/Tec5+h7NuHhA9G+1bk6xHpkyJ7WaOLF4FJwGc0aYBgxovf8VV1PY9ODbKpTkSofaaQz3yQnO8Q
	RANw0dNXMSo3BfgR8jbkIb3dbg9HfQR5hNVxfgnzKYLrBQOTiqx4H0CJQlN1+7IeV8dmHVv74Pl
	kUt+wvz+BTeanln4rdXn1wolUrxhmq6RcKJGagzff3/4s4Vs4W8TpabHZt6AFSZsq1CH66WpRz2
	q05yFbbBq
X-Received: by 2002:a05:6000:1884:b0:402:a740:1edd with SMTP id ffacd0b85a97d-40e4ba3a51dmr18681158f8f.39.1759222441986;
        Tue, 30 Sep 2025 01:54:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFC6R/XmmrHeMyW4Zs/2Re/vavWpGlrPLfb9nEQvvZzsfwcAir5u+bovZh6m70scQKSNO6HOA==
X-Received: by 2002:a05:6000:1884:b0:402:a740:1edd with SMTP id ffacd0b85a97d-40e4ba3a51dmr18681110f8f.39.1759222441480;
        Tue, 30 Sep 2025 01:54:01 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc88b0779sm21447278f8f.58.2025.09.30.01.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 01:54:01 -0700 (PDT)
Message-ID: <c980f6ae-ba44-425b-b7bf-511cb6957c2d@redhat.com>
Date: Tue, 30 Sep 2025 10:53:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: Lance Yang <lance.yang@linux.dev>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiaqi Yan <jiaqiyan@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "Chen, Farrah" <farrah.chen@intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
 <SA1PR11MB7130ABC25E060D2CC4749E45891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
 <SJ1PR11MB608350E5169EE77F86A51E2FFC1BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SA1PR11MB713082CA93E9B1C5F22CFBBE891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
 <c1294b63-eeee-4d99-82b6-93eb3a6d0af9@redhat.com>
 <CABzRoya5wuXoMWuGb_+F0oBc0mCDVrjbXTZsoMwcfRT99Y5z7g@mail.gmail.com>
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
In-Reply-To: <CABzRoya5wuXoMWuGb_+F0oBc0mCDVrjbXTZsoMwcfRT99Y5z7g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lv2GtICZ-AMbx2NJEOzkhnSx_Hk_KKJWA-vcKAa_zoE_1759222442
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8kycw7xb88n5y8wtnyigks3y8d6szwgk
X-Rspamd-Queue-Id: A601420013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759222445-708245
X-HE-Meta: U2FsdGVkX1+EF987SO3rMR/UAw8iQsn0DzT4DzdQDDbesjfW/Ll44g6fg/BzrSESIfvmMH5p3ZibIqlP2WfgYDZ1xfZjRSmXUtt9YB70JdbFgysQ0Tr7m+yN8MgNmL2wUshrSbFhaAAg1c3PSp6Bz0ZZQFOtJkhRamQeIQRSWTFYZbQwmggJ/gwHW4YBXDl1KirXoftnogzJ/oJ3uFP9rp7UVJOO1E0eRJFB/YEd5HmOMQ8ZUZYeNh+62Vj37hCMCi7IwkF6WRMIXjb5+47vLAOA4eqTDq+hKLPFwffHqDJlhQ8hdz8pTeunXiumSdBZTCBztI6QfpGGQAf309yjJ/ETobVZkEyiTIvaffzs8G8bLGX2B6tj48MoxK7lOhK3SK03eIiQjCBu6mwrOTAx68Za+h3UURVSov2c/lnWFpS9AZn7/u8nIxpfeVrJK7EFPaSYYapdYTbZ0jezEU+6TAytct5t7ED6R5sMkxmqL+QfCmk7va6jLc8ud0amQq0NaigKfbDYuvIOHJEa8c4g45FHknqJD17YDNAGQ8NOfa+c2HF+bzabXL7kmThP8anIaY7GKgZE8Fi5scDN1jx/N5fGIX6qoMX7wo1U/yxLwXGuE58v796aCKYYVjgOfQG8jUsXvwCd2cnUmZtJqMKkGGvHJZBGduzvSHnqtaGQPOeohgCHdOI1Xbzc3cxASzxUL/6n+UiDVd2kVACraXkYCp3RzwlsfvqZdedxAqcpRW04anHkeEfRncR4Kl73ZpQyHOPJBLtEFNIn4YXhuaZpA3D8KYBcAEGYQ9Ak159mGjftPcjUuMejyLu67/syTgtF6ewJUDagl3ccsu9ppWFnVMO+W57ZqVSRGwpG+5eiiemduPrCNOD6JOfuXdqOnJMvOVUW65ov4cy1NDyN4kEEK4CiGG0Mqd/PgYe6MKVct9Ix0qO7wVtrvnx+HODqlRWHfrOQ1rdDUkcYEklXrzF
 u2vWuZZX
 xUjgA+GGZ78+EjDFdbzoQTZobrzpEUAzsedfocR5MhawqOHZZlCto/Ty0t0UU7CiCw0wi5uxaxBndGcE28Xl01VCxL4Z5HIwRAUQ9Hct999rmu5WdjHGY+lCP2fHAGBh9R4txWpQR3z+yzf1sLMByHTy90dUDB6bzYuMGxGSfs8T/l963hLniHzZD1zEywqVRPK6z+mw/Mr9xageZPUcFjP6LklROhu78ZqLX23inV9/ZgZR0rbtHPvqgJ2KeE4bAedrmezU9DMWUtZpUGLRqfVVaK/9YoCutLAanCDReiK32F72FIDCHxDgBUzkH/CPV3pBYZM3x6KQLWUnp3CcVmM6uzKyfv2eF1qWMIv6ZO4ePjQmYe7mXDzDnJASSiZfS28XnRdEqmwGchi1j5pkx+I2BVCBXM2c4F25SLR2RdsOxJFvf6tOfaDwzoVgWwkXsQbu6kz6gGoNQv9v9tZ2OQ2ScOWcHNc5Nxcp+gSZneAzeTNt9yU15BErwECuP7DBfBJ2xpcuLsB1m9U9/+l9c1MCgI4EpG4BJnY7mRwhXyQ4T7xWWxKhDctCD0gBJE+RrEDNJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 03:48, Lance Yang wrote:
> On Tue, Sep 30, 2025 at 3:07 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 29.09.25 18:30, Zhuo, Qiuxu wrote:
>>> Hi Tony,
>>>
>>>> From: Luck, Tony <tony.luck@intel.com>
>>>> [...]
>>>> Subject: RE: [PATCH 1/1] mm: prevent poison consumption when splitting THP
>>>>
>>>>> Miaohe mentioned in another e-mail that there was an HWPoisoned flag
>>>> for the raw error 4K page.
>>>>> We could use that flag just to skip that raw error page and still use
>>>>> the zeropage for other healthy sub-pages. I'll try that.
>>>>
>>>> That HWPoisoned flag is only set for raw pages where an error has been
>>>> detected. Maybe Linux could implement an
>>>> "is_this_page_all_zero_mc_safe()"[1] that would catch undetected poison
>>>
>>> This sounds like a great suggestion to me.
>>> Let's see what others think about this and the name (though the name already LGTM 😊).
>>
>> The function name is just ... special. Not the good type of special IMHO. :)
>>
>> Note that we'll be moving to pages_identical() in [1]. Maybe we would
>> want a pages_identical_mc() or sth. like that as a follow up later.
>>
>>
>> So in any case, make that a follow-up work on top of a simple fix.
> 
> Yeah. IIRC, as David suggested earlier, we can just check if a page is
> poisoned using PageHWPoison().
> 
> Perhaps we should move this check into pages_identical()? This would make
> it a central place to determine if pages are safe to access and merge ;)

I would have to go into memcmp_pages(). Would be an option, but not sure 
if we should rather let callers deal with that.

For example, in some cases it might be sufficient to just check if the 
large folio has any poisoned page and give up early.

-- 
Cheers

David / dhildenb


