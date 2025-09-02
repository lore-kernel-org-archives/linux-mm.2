Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22C2CA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4468E0020; Tue,  2 Sep 2025 11:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3534F8E0002; Tue,  2 Sep 2025 11:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B948E0020; Tue,  2 Sep 2025 11:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4858E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:28:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD0AB16023A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:28:26 +0000 (UTC)
X-FDA: 83844691812.15.9864425
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 36CAF40016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:28:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="EC5UXrQ/";
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756826904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSh4ojjlck0In0Q+qbLzFlqnWtZCvC/pw08b7Fd5bkY=;
	b=JkaNJISWxHPhVmlE0OArMLl90MRI5DFpjw4ZTLBSPR71l+YZXxAL+A3vKbZZzZdgFbxeic
	UGmj+yTuHNYZbL5pL2F7H2/sjWbmgazWDh4zyayT8pRDRxVT7zcabiVWkxiJPe1+gpZRR1
	EAdGD7XTM7MNZb2gJJ+3qF2VlUD7zKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756826904; a=rsa-sha256;
	cv=none;
	b=fpJ6iXQwlcKbLlABWfuNfP1R7aZC7bpJ+I+3ADFR9kHSeoIDxCb8F99JTDnLdvtwdYysoK
	hXHjOwufAYyjBc9E5hh/CtPbGK2aMFvz6lQxxVRpJpkpRTwYl0trtaafvZIMGVyOzSXcuz
	4J/D+zxZth8ep4fIh9vEvkZdMui8Mt0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="EC5UXrQ/";
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756826903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hSh4ojjlck0In0Q+qbLzFlqnWtZCvC/pw08b7Fd5bkY=;
	b=EC5UXrQ/p44m2yw7STieSYjZD5gcX6hcH6NvqgLwCyQiiLdMcbqlD8EHELbPfUM/Ge5HGa
	/LEyljlBp9bAZ/Vy1C3kZd4lPTpsSFSOVnfaVD/1CakNZKjuDhp+krQ6zhMi1HnFrBUfqD
	f7HtAnsP3UjMKnw8rmvdDt2VVwGnmBc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-6XUeKZ-oPiC1xvOxAbUYFg-1; Tue, 02 Sep 2025 11:28:21 -0400
X-MC-Unique: 6XUeKZ-oPiC1xvOxAbUYFg-1
X-Mimecast-MFC-AGG-ID: 6XUeKZ-oPiC1xvOxAbUYFg_1756826901
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3cf48ec9fc1so2796721f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756826900; x=1757431700;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hSh4ojjlck0In0Q+qbLzFlqnWtZCvC/pw08b7Fd5bkY=;
        b=xP9jL9QWR1vmXth8rFAViguSKYDOR/GAx+MbVuKG/VmcBvO5D1/ossZExt4pD2Jj7C
         f4thqMmyi74cplfFrhFp62PPaDd2HR/8bcEJjAPXi2w8QREUZv1d7prjoagm2wunurz4
         gEfHLicIuTPqdg90sV+8xwpWemUPRwz4z+bSsZInf28XehR/n2fQ8sWXtb8oLmmjSTMq
         SMJJLJlC5jExx+8Jv9N36Yk//+nXqm4+Hbc8V3lQzQNaS2HIC4/BsdEc0fTEguWq7sSU
         tKiU6z+kmVbGY18qxx58nLMIfxzZxThjuIP5zoPEyU3JIlEUw8mO0WlKWqJGTj/iAJuP
         dD2w==
X-Forwarded-Encrypted: i=1; AJvYcCVEpQLEDdAs24W9wNw091BRmvx6TITjjdEUR6IrEHYLVtHfG3ie0Ka4dYpUDu0YLEBGvpnQxg2rNA==@kvack.org
X-Gm-Message-State: AOJu0YyiBRyEkMEzQofZ4bHzEVOVU2VcN8bpKZytHFKaif6NvXCUWWmn
	vebdI6XEUijFkwQs5AUIxcldQC4O8n9dpAz7mR/7oe8hieAwN4Nl03kjX0EFjE/cM36c3vFBIU4
	leUM1W0hpLLiRzPvb52BlMP/+v7v+fIgdGEJ8uLdXEOazJGZOxfWJ
X-Gm-Gg: ASbGncvcyGGazXzJzmvJLfFkFSzuGx4QeGV5cNFIyUk4RorZd5DWox6uIipLfFaFC+B
	vPAPOzwXjpoelIKXXX0DEjDqHjtd6qWTJVnUsoQ73N57L2wCAaGxLtBCUQAX5czB+itiBHn1fim
	h8YgBs8ZsjuMtLknRusFpO+wW4gW9477DO6vizJ8HB4nDE/fgY90Z+XDRH8aq5f00mZbOK7aMtN
	Bv71JAYe+bpNfqSaqTNCIJ6q313Y1Nj3sdooQ01ft96PuvRptvYEdFwTwKg3xLoKdCXETL5Yzwh
	1I+iUdT2HA6+n1wRZgQMsN83plvSihzoaWcDYRFAfAZEqgR3Q0XWkMUgb9k8pqUAwlxZajB5zNE
	volucwgnGHRYbSZq1lTjwv/vuPHoWZUglcqmawA0wL3NxZCuz7pmDwB2Lm+IEEllb4/w=
X-Received: by 2002:a05:6000:1789:b0:3dc:1473:18f1 with SMTP id ffacd0b85a97d-3dc1473196cmr268162f8f.14.1756826900486;
        Tue, 02 Sep 2025 08:28:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnfEsLIQOhXITgQs5Nd0yn9CNhyySCm8tGdWnkDE1oq8HRfUeU1bl0fwY9TAfCj+Y9a/fGzQ==
X-Received: by 2002:a05:6000:1789:b0:3dc:1473:18f1 with SMTP id ffacd0b85a97d-3dc1473196cmr268139f8f.14.1756826900022;
        Tue, 02 Sep 2025 08:28:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9d37sm20334663f8f.49.2025.09.02.08.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 08:28:19 -0700 (PDT)
Message-ID: <1d7e9c30-343e-41c4-814d-f6254b042509@redhat.com>
Date: Tue, 2 Sep 2025 17:28:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
 <27A308FD-C7D8-4C65-90BA-9B1DC117B014@nvidia.com>
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
In-Reply-To: <27A308FD-C7D8-4C65-90BA-9B1DC117B014@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k2zXMguEkIB9S01uHLc3Ih-dKRSV4uz6TOxGu3jv8qY_1756826901
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 36CAF40016
X-Stat-Signature: 8hse8756xg5ywkt8xgnebhrz84k8ngio
X-Rspam-User: 
X-HE-Tag: 1756826904-854258
X-HE-Meta: U2FsdGVkX18Z7Hfzy5XROpU0IJHC0PtNx65k/BtLawiiYxSubpGKMFPMVj45f6liuKJ98YUqpZLRIfDbo6VfyxWwcYR538VSZtS4cDndAs8/9Cz9XWwGMRoKoSXtb9E6WOcZuM6xZwkhPsX0X9lrWFdN/vzDG5jAyg1D6B1MBDizH2jk9XTMm+Z5S3sjnqiORmfoDckwSZeMRV3EfRNSW2wkL1E3AsVYiJkGO40x9l2fNoNpXD9fcsJ+m6ob6l8gavdH1fwSO2VL3Wu8lh8knYNM422Z06ytFl53R1HfGIt53IpWiOMOen6emLDg5HpV8nBE33VAOZ8zCiRKYSyrQahVRykRL/GIVacUxPc8GZv36tnnDmla1hB5j5Aj+M2a26L5/VMzPRlRdOnN9lc94U2WFjm3ZEciC5mFiJz9kqOkJoZOvI101Jem4qNK8h6PlgiLKn3iMdtjsUCzo/skAaNve40q6I7Xbygm3ct8IMJ4cQwEoZWJWLd03CpzQczA6629/NzWp5ocnLcG/cYh+VrzZ4PwoRsp/IdMrQHwEHs6fednwzB1bzH8esDjT4vk4brwHCHikLhWTuZ2qcvHaTxm/C0OdEJMs9L/fDI+8fSYshV3I+58+WMqljOBv9wHDjjiowIFxudPzUGf8w5aOsTlP8kkpzfptNFpIygiGa4tf/HcQCcfAGEXKuNI4cvPc9RYrinqNWNWa0+5sEsp9Y9lkYUe+YBoxwo1aqehtCzbpTOHgGm4KjXI0BcdqJOkrXDpgA5okKeAWZmvXAWGdx7gVz0LBm/uthKQa/j6UeLK8SBPLd4zhCjHbji5TzHLBpNL0SiMpcfEeL+2ixjnu9ACKu90x6LqcX96dqXo1XV2QIMUNr0MYcYsmmnFN0M0lKgqLNg3Pyl59LQo2awSYXkqusXlchxlWdLPSvyrFbpR8SXf4V4aNA2+s/u89PErNoHTyXXDn/vF0fNQGcg
 7+uaf2wS
 1cdpH4bFItpvayEKZ15FVyP4sFLkkEBB9VB2vMD0bX5NBQgysC/9OSvzaNUx7UQZLgS+DpXCvC/0vSYj1KKR5zmnznk4QgmoorINHrNanEt+15gJUSryHeqnWTqRwJRTO/bq8LfV+q2NQBLiCLngRynSshiyEFYJMJOoHnlXgaOR5WOZOwWrMVVQiTV123f6DA4Zr1OZtrQL+FMY9rrim2dTumDzaeWBLkRS3jbDrko4bAjQIPM4YnHFYwtlRNotpQ7Ksa/NmnIsawtYB12TTjv45NOHLtvvZWL6mXowLdg1FhyfpnruLWbUT5syQNZBWc2kngJlP5QpKa2DFUCKEhlO2LTdCUe+1DDOXHg561yznGLohyGRAHCOkufsmrF/J7RXGMngKf7Y9oDIKTFlitiA8MSXCA/mRN3to14Uy/M/plb9E2vmijulYYBdt0t6YHpLa2+y4LCU6PyOS9APOyv9/Ii6YS+okj5tr4E0X5XoPq6I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

>> @@ -390,67 +390,88 @@ static void split_pmd_thp_to_order(int order)
>>    static void split_pte_mapped_thp(void)
>>   {
>> -	char *one_page, *pte_mapped, *pte_mapped2;
>> -	size_t len = 4 * pmd_pagesize;
>> -	uint64_t thp_size;
>> +	const size_t nr_thps = 4;
>> +	const size_t thp_area_size = nr_thps * pmd_pagesize;
>> +	const size_t page_area_size = nr_thps * pagesize;
>> +	char *thp_area, *page_area = NULL, *tmp;
>>   	size_t i;
>>   -	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
>> +	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
>>   			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>> -	if (one_page == MAP_FAILED)
>> -		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
>> +	if (thp_area == MAP_FAILED) {
>> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>> +		goto out;
> 
> thp_area mmap failed and out label will try to munmap MAP_FAILED, which is
> (void *) -1. munmap will fail with -EINVAL.

Indeed, should just be a "return;"

> 
>> +	}
>>   -	madvise(one_page, len, MADV_HUGEPAGE);
>> +	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
>>   -	for (i = 0; i < len; i++)
>> -		one_page[i] = (char)i;
>> +	for (i = 0; i < thp_area_size; i++)
>> +		thp_area[i] = (char)i;
>>   -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
>> -		ksft_exit_fail_msg("No THP is allocated\n");
>> +	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
>> +		ksft_test_result_skip("Not all THPs allocated\n");
>> +		goto out;
>> +	}
>>   -	/* remap the first pagesize of first THP */
>> -	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
>> -
>> -	/* remap the Nth pagesize of Nth THP */
>> -	for (i = 1; i < 4; i++) {
>> -		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
>> -				     pagesize, pagesize,
>> -				     MREMAP_MAYMOVE|MREMAP_FIXED,
>> -				     pte_mapped + pagesize * i);
>> -		if (pte_mapped2 == MAP_FAILED)
>> -			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
>> -	}
>> -
>> -	/* smap does not show THPs after mremap, use kpageflags instead */
>> -	thp_size = 0;
>> -	for (i = 0; i < pagesize * 4; i++)
>> -		if (i % pagesize == 0 &&
>> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>> -			thp_size++;
>> -
>> -	if (thp_size != 4)
>> -		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
>> -
>> -	/* split all remapped THPs */
>> -	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
>> -		      (uint64_t)pte_mapped + pagesize * 4, 0);
>> -
>> -	/* smap does not show THPs after mremap, use kpageflags instead */
>> -	thp_size = 0;
>> -	for (i = 0; i < pagesize * 4; i++) {
>> -		if (pte_mapped[i] != (char)i)
>> -			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>> +	/*
>> +	 * To challenge spitting code, we will mremap page[x] of the
>> +	 * thp[x] into a smaller area, and trigger the split from that
>> +	 * smaller area. This will end up replacing the PMD mappings in
>> +	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
>> +	 */
>> +	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
>> +			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>> +	if (page_area == MAP_FAILED) {
>> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>> +		goto out;
>> +	}
>>   -		if (i % pagesize == 0 &&
>> -		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
>> -			thp_size++;
>> +	for (i = 0; i < nr_thps; i++) {
>> +		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
>> +			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
>> +			     page_area + pagesize * i);
>> +		if (tmp != MAP_FAILED)
>> +			continue;
>> +		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * Verify that our THPs were not split yet. Note that
>> +	 * check_huge_anon() cannot be used as it checks for PMD mappings.
>> +	 */
>> +	for (i = 0; i < nr_thps; i++) {
>> +		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
>> +				       pagemap_fd, kpageflags_fd))
>> +			continue;
>> +		ksft_test_result_fail("THP %zu missing after mremap\n", i);
>> +		goto out;
>>   	}
>>   -	if (thp_size)
>> -		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
>> +	/* Split all THPs through the remapped pages. */
>> +	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
>> +		      (uint64_t)page_area + page_area_size, 0);
>> +
>> +	/* Corruption during mremap or split? */
>> +	for (i = 0; i < page_area_size; i++) {
>> +		if (page_area[i] == (char)i)
>> +			continue;
>> +		ksft_test_result_fail("%zu byte corrupted\n", i);
>> +		goto out;
>> +	}
>> +
>> +	/* Split failed? */
>> +	for (i = 0; i < nr_thps; i++) {
>> +		if (is_backed_by_folio(&page_area[i], 0, pagemap_fd, kpageflags_fd))
> 			
> page_area + i * pagesize, like Wei pointed out in another email.
> 
>> +			continue;
>> +		ksft_test_result_fail("THP %zu not split\n", i);
>> +	}
>>    	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
>> -	munmap(one_page, len);
>> +out:
>> +	munmap(thp_area, thp_area_size);
>> +	if (page_area)
>> +		munmap(page_area, page_area_size);
>>   }
>>    static void split_file_backed_thp(int order)
>> -- 
>> 2.50.1
> 
> Otherwise, LGTM. With all the changes in this email and other email,
> feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com> when you send it
> out formally.

Thanks!

I'm currently chasing why I keep getting temporary

Bail out! Some THPs are missing during mremap

Already on the old test. Something doesn't work quite right as it seems.

-- 
Cheers

David / dhildenb


