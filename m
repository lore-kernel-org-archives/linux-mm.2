Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FCD7CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06F28E0003; Mon, 15 Sep 2025 06:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDEF78E0001; Mon, 15 Sep 2025 06:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE348E0003; Mon, 15 Sep 2025 06:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A94068E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:29:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 627A6C0560
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:29:58 +0000 (UTC)
X-FDA: 83891114076.15.3EDB1DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF14E1C0006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:29:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K8dsV9qM;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757932196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PebzKIAGBeQ8UR0riCzpqXgEfEfj9FktP+eiMg1gg0s=;
	b=eGl0BmFhwTmWZguZcmPcXXqN7ZW5Mtw0zc4UXQbubyTijxNomxY+Nu65PM6lYtNl4ysJgv
	A6p4POHQYLaQkbKLtaAQupGd2pxoOVTIXeROVE/gFVE6hAkbv5MaGAibBU4DKsIcfbP9PW
	yGitt48JrmdivA0qjxBAH5ArRPxr0aQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K8dsV9qM;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757932196; a=rsa-sha256;
	cv=none;
	b=uH2MbtyiGVDqFMfMarwZMUl62P/FIxaovk+QWFQIxvFuOzwYElVRb58cvC1vbhsEFUkoum
	pEBIi44pfMDIhS/dwMZaz89fMSPSKw+D6VJIZvxrkOqH206rFDF+jopW6DtlPiZG1Ld0FE
	qMdUcZMcOmcWG6Z9OphnZPwXZK5eZrM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757932195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PebzKIAGBeQ8UR0riCzpqXgEfEfj9FktP+eiMg1gg0s=;
	b=K8dsV9qMEZQBLmviir0fijmYqL5nnHDsh5JI+icCaabBm8EI+0SluijSvwzH7eHRamqORt
	7hcXgIgvaeq658YuUp8SNRvLMPNfinH0n/WjXTZsDe/+ao0m3AU+W9wtRU47KyK3MbaghT
	mDvYx2MPYfaeOufNtM7yTc8Tsuimp3Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-Nt2IIAdsPzetMBKIfQnjDg-1; Mon, 15 Sep 2025 06:29:54 -0400
X-MC-Unique: Nt2IIAdsPzetMBKIfQnjDg-1
X-Mimecast-MFC-AGG-ID: Nt2IIAdsPzetMBKIfQnjDg_1757932193
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45de07b831dso21865825e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:29:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757932193; x=1758536993;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PebzKIAGBeQ8UR0riCzpqXgEfEfj9FktP+eiMg1gg0s=;
        b=Hke0NeaHOVpsfwm4/xD0bNvfeYVgfDeg8/GWqsPV5vZS0cfeTKYqjP+8RpfnnWR9bK
         kRXDO0MDqS3zb5txtoK41dBEVNx2FPhhcc/Dl2iLTTMZNC1gP6KSuebCd8oMmLhdydJ+
         R8im9LWqF9J93nrCdejM6OoYAMP3sbg4mBZAaBK9edIIHzPRFwClKYC+MZOAlNnRwHTP
         NbHFnUFwnaB1AkIM6oqM+tiIgU8aC36xnnPwI9GWzyfOmdsth+lloGqyOrMzVAF/nMKy
         wY5DPcDLYWpHcBMvvn+o5PLe93kqJwPTt1OJcQvuXHYxxRo+nUOlhM5IXl1dKNKiAIUf
         ug8g==
X-Forwarded-Encrypted: i=1; AJvYcCW03L9MRZytBXlJcmseDaMGGC1VX0K+oKqid4FQEffuw847KM9AihbsLQC+b19MpVmcgLegRyzy3A==@kvack.org
X-Gm-Message-State: AOJu0YzvHyV7cYLSqUBJFnnPa6R7lVGpG5tj+GkA/cL/nGLHNiPrWqRd
	9TPfEexyjc3KvE9bOLLf3OLcaXEePGcvE4XPcpGvR9RD93YHFOvpnWzNdGCuB/YvqdGOgjx1E1R
	4RWOz+Ldn/PNe6ZFFJ36l7ao4qa1X+bAVO+1PvS/2ckfleOmq+lbsjATfXUgL
X-Gm-Gg: ASbGncuCDE2FtSvRYcgNft83PtRK1fhd8/mX76f6zbw4U4mRVypKDMLQRM6a9i4WeAm
	LEA+nGlnKr48AhCivW1I4+z/FeBwRFeQsVUb2sSO+pH1ftJ6WKv831k3j1BR41D3q8ang9IVgly
	0iTa/cBCUz76sDa8VOWpax8uR7gB7I4GhoroYVvSp1JF9YV4cRmiohmzfPeLwqQ1/gXmwqQTePE
	YoreiuI920uhI9NLdx096Gu2wqLRvww7ofQ5ouG8T5J79dsrUSri8w6t9koVDdw38OcjKNBdqGD
	w8iJW/Vg+uLrUAH9ZXTp8mUzmw4fk5YuoUdaZhd3qXxjRI/VtWMQBe50TRZnKzlZCog2tdIdLC1
	vBZYrtm6qb25uWqQRo2NApn6M3LUMVoGv7y8AjBuYviszb5TUzs8Phyn1y5E1cJ+fXEU=
X-Received: by 2002:a05:600c:3651:b0:45c:b53f:ad9 with SMTP id 5b1f17b1804b1-45f21201ec8mr80363995e9.33.1757932192812;
        Mon, 15 Sep 2025 03:29:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3bZLos3DfRvtT9BsWuTlXLHXo+egMc2YXhmHVbe7uN303AIQ6yQhhCgX44uqWOFSwoO/JaA==
X-Received: by 2002:a05:600c:3651:b0:45c:b53f:ad9 with SMTP id 5b1f17b1804b1-45f21201ec8mr80363685e9.33.1757932192307;
        Mon, 15 Sep 2025 03:29:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e017b2a32sm175369305e9.18.2025.09.15.03.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 03:29:51 -0700 (PDT)
Message-ID: <8fa35236-23f6-4cb3-8e8b-268bd1aa09ba@redhat.com>
Date: Mon, 15 Sep 2025 12:29:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, Barry Song <21cnbao@gmail.com>,
 Nicolas Geoffray <ngeoffray@google.com>,
 Lokesh Gidra <lokeshgidra@google.com>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
 SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
 Peter Xu <peterx@redhat.com>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
 <aMd-2argDQCHww_Q@casper.infradead.org>
 <18361483-5089-4414-b974-4c481189b9fa@redhat.com>
 <585b0ca3-cc56-4f74-9950-800d6faf8012@lucifer.local>
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
In-Reply-To: <585b0ca3-cc56-4f74-9950-800d6faf8012@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jCfJl9sg1wuvFiI06U4VyvbvCMS-Tci17s0CTVYbEOs_1757932193
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF14E1C0006
X-Rspamd-Server: rspam05
X-Stat-Signature: duenphq3t1eb3geeq94fse9q6gmwnm6k
X-Rspam-User: 
X-HE-Tag: 1757932195-68587
X-HE-Meta: U2FsdGVkX19x9HOzgtIGLwZD7oDfRD3YPjMNvhNDFun9QBDHNaFqqcaKn4+jEab9KDU5vKCu3Y55mAKmFUKPvvgNggGPLUDlKLw4uwMJk0rZEz7CG4xDnsdW/aKWaY4JiMl+BYYTe1g5Xu8UqAKCdlQqhezJW0/SzuAvPiX5JUqLo3t4LJHI9CXegVfUXhsGXQDOQdwY0dE+h1MPhteZjCcF8L62MAb/XCrM+nLGVgbjKMCwLVP8hwkxnAvSpMjgwk1kQ/6MoYrIOJwX5oR+jJybfcSwiTtcBfatXhtbqD4R4GD/klN5qYHGZ4wmWrXES/r8rVVeGwOwXQgNz32JwuluqM/VRak7DaSnS9aiAoycYJjRycgiUyn0tWWJPgaOZxYz2lM3RzAMv2M0EF5tZAk9Uu8njkxd/SGCBQ49kO3BrTmqVcHpY/2d/VCsp1wXa1BuKRKW/mBsdrgugLiOVR51I9QfM2OU5FG11Np9ge1eH5R2Sg+EmwCrxSdkdA87EFSDFAMRbJW2NITKAPsnx/1NP6QqtYThCK1MHUooZamnetskqBTrqcuMEVefbF8P8Y29CZD4Hk6OPbBgamKuelxZauCiI2+TPIvLMypaS2A6vrBvur8X9TzriKF4YmE8mIAyxy2k/pOhoZ0dNFq/Kpf3oHM5fr7p8TFB5Sdr99Jk1teutqoCBQqm3Qr6TOTZsPvWunOIdusFUqW29S6ov17a2gdHCL5EA/QcM75m0bKNdmHBS+G9GkUBcb5pe+EDZCaFcSsiz5+asovDcLVVDYKxGucxA7YsJ1UfHUfIv0InjjGmBmhjIiS/IIALNbht2GbZGIMjRewcuPwD6hrax6BA7DUlpiPS4oJQ04JWHiyAGggNK8aYWajaZC/ZGLKl24tAqU8D4/ix8MbJuEpNO/mmOFF9yb2Vm2fzmKG8Yp0+r5tfh9uHuYS4tBO6ifuwGHCtFXqch/eFbkKGAeq
 tcQ1A3nX
 ka7YngV/ujYs/PnNaTUjhZseXSpYKGndWbadOueEu84kbHj0PRwwKcx7PkCAu5m8Qhqr0GBfOPgrDIOaTpF/0TyghdkmK0byzQviYqJmz2/4EixuinaCfhrgDQYLuqfe5NyhgUr4ZTTJfRC+Em5EQ/rFTrVYCGPVwqHlxLxRnyKrTK/5iWm5RecQGH+SBdRlDhfWkiYOGyISr6vEj6/o/MTBS0swfOkYRMH5QTCJVj4tUZc3qRwdW1AVWPQsae9Ypq9ibrBYJklpaYEtaR+aqAyguKJR/KvWTvo3UcZxnKI8Lugv+DlLJKka+XWwdDvELSxeTZBpgZnRfEON4gwxkcY+yaltOfgfbXCCKeJHQrYt+HkoDW8kIu7RHrpslfLI6gqs8VWN8sQDK+aeBGqIgUfVSC6jLboRLY6OUUTDyi8tVx4TFpy/OOzRDSbUeMlB81x0B0NvuWWib1xC6LZfwJ2N+J3oNFct4NJYUIoO7wWSOUyXQmXwX3Am4Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 11:42, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 07:17:41AM +0200, David Hildenbrand wrote:
>> On 15.09.25 04:50, Matthew Wilcox wrote:
>>> On Mon, Sep 15, 2025 at 08:23:38AM +0800, Barry Song wrote:
>>
>> A couple of notes:
>>
>>>>> I wonder if we could fix this by adding a new syscall:
>>>>>
>>>>>           mremap(addr, size, size, MREMAP_COW_NOW);
>>>>>
>>>>> That would create a new VMA that contains the COWed pages from the
>>>>> old VMA, but crucially no longer attached to the anon_vma root of
>>>>> the zygote.  You wouldn't want to call this for every VMA, of course.
>>>>> Just the ones which are likely to be fully COWed.
>>
>> MADV_POPULATE does that for writable vMAs (excluding the rmap opt, but that
>> could likely be implemented).
>>
>> A student of mine implemented a MADV_UNSHARE that achieves the same by
>> triggering unshare-faults even for non-writable VMAs (again, excluding the
>> rmap opt).
> 
> I think the rmap bit is non-trivial as per my other replies.
> 
>>
>> We used MADV_UNSHARE to break COW asynchronously to the already-running
>> workload to keep fork() still short but avoid the overhead of COW faults
>> later.
>>
>> [ insert usualy comment about no weird mremap flags ]
> 
> Yup
> 
>>
>>>>>
>>>>> Maybe this isn't practical, but I thought it worth suggesting.
>>>>
>>>> Lorenzo suggested possibly unlinking the child anon_vma from the root once all
>>>> folios have been CoW-ed:
>>>>
>>>> "Right now, even if you entirely CoW everything in a VMA, we are still
>>>> attached to parents with all the overhead. That's something I can look at.
>>>> "
>>>>
>>>> My concern is that it’s difficult to determine whether a VMA has been completely
>>>> CoW-ed, and a single shared folio would prevent the unlink.
>>>> So I’m not sure this approach would work.
>>>
>>> I'm concerned that tracking how many folios remain shared may be
>>> inefficient.  Also that information needs to be gathered in both parent
>>> and child.
>>
>> Yeah, not a fan. Tracking per MM might work, tracking per VMA is problematic
>> due to the possibility for VMA splits.
> 
> Well, I think it's possible (maybe)... with a rework :>)
> 
> "Lorenzo's grand rework" etc. etc.
> 
>>
>>>
>>>> You seem to be proposing a forced CoW as a way to safely unlink from the root.
>>>>
>>>> A side effect is the potential for sudden, heavy memory allocation,
>>>> whereas CoW lets asynchronous tasks such as kswap work concurrently.
>>>
>>> Perhaps you could help us out with some stats on that -- how much
>>> anonymous memory starts out shared between the zygote and a newly
>>> spawned process?
>>>
>>>> Another issue is the extra memory use from folios that could have been
>>>> shared but aren’t—likely minor on Android, since only a small portion
>>>> of memory is actually shared, based on our observations.
>>>>
>>>> Calling mremap for each VMA might be difficult. Something applied to the
>>>> whole process could be more practical—similar to exec, but only
>>>> performing CoW and unlinking the anon_vma root.
>>>
>>> That seems like it would be worse for memory consumption than doing it
>>> on the VMAs in question.
>>
>> MADV_UNSHARE we implemented simply took a range and one could apply it to
>> the full process by supplying the full range.
>>
>> But yeah, the downside in any case is that you lose
> 
> You just lose? :P I assume you forgot to finish this thought :>)

"you lose the memory savings of COW" -- was still tired there.

> 
> I wonder from rmap point of view whether you could actually simply check to
> see if you're fully CoW'd.
> 
> E.g.:
> 
> 	madvise(..., MADV_ISOLATE_COWED)
> 
> And have it take the anon_vma write lock from root, have it walk the rmap,
> go and check to see if every folio in the VMA is now CoW'd, and if so,
> detatch the CoW'd anon_vma from its parent/root?

TBH, this all feels like things we should be optimizing internally somehow.

And don't get me started on

MADV_ISOLATE_COWED eww

NO_COWS eww

COW NOW eww

> 
> This would be a sort of after-the-fact thing, but maybe could be done
> periodically.
> 
> Of course then if you had one folio that was not yet CoW'd, that'd prevent
> this from completing.

[...]

>>>
>>> Another point in favour of COW_NOW or EAGER_COW is that we can choose to
>>> allocate folios of the appropriate size at that time.  Unless something's
>>> changed, I think we always COW individual pages rather than multiple
>>> pages at once.
>>
>> Yes. khugepaged will soon starting fixing that up later asynchronously I
>> hope.
> 
> But only at mTHP granularity a. once the relevant series lands and b. if
> mTHP is enabled (I mean for sub-PMD sized/aligned ranges) :>)

Well, we need khugepaged in one form or the other form mTHP in any case :P

And the glorious future will have all sizes enabled as default.

-- 
Cheers

David / dhildenb


