Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E781CCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502BE8E0012; Wed, 22 Oct 2025 16:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA318E0003; Wed, 22 Oct 2025 16:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8FA8E0012; Wed, 22 Oct 2025 16:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BBC88E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:22:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4BC848DFB
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:22:18 +0000 (UTC)
X-FDA: 84026872356.09.B519CF7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 02084140010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:22:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BykJ0mtZ;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761164536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tj5wSQiFxb3TCQrEl/pvDEnruwQl/VFhjMYuvBzqn64=;
	b=v2xrefxgKGUZXRPX2kx7m+jcg6TxbVQCtFQaRfCmVYZxxXjq7nfDm+NVT5cGwFw2fTsrQe
	h7sqyV6xYmCajqA+Uw76Hc52YCbD3RqQQReVt/OVThKBtzvcREMJD+E30BAzUgD/no4+Oo
	U6gZmD18LSUopmbJ8pq1VmT3hqVTM+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761164536; a=rsa-sha256;
	cv=none;
	b=yuqGEyDT8rhvg43AVrABeBcJZGtrJ8J3B1eU10nUnM77OlfjdLGAXsHoHzT6rxU6b4zusq
	0XtSUSaZgaEtBthr3nZxGN/Wsfso+POjmo1zsIeZ0yzrHCYBeB2oPzvp++B1OTOzIDyNtt
	DSmV0/1rpX64NfOvXOBg2ypUe/46na8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BykJ0mtZ;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761164535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tj5wSQiFxb3TCQrEl/pvDEnruwQl/VFhjMYuvBzqn64=;
	b=BykJ0mtZ1oiPFMgrOtpT7lgvNQ0UvES+P+g0RWAFOgPLmMdwMyLAaGHl8t/Zrb+TyeyPyB
	0jlAXKPu5vEG1S3rtucd/SfSLVheaLYTxYm78lQUeX6EfBDNaWtj6ndAuz2MzNCsqMYkM7
	Xs5O2Yr97EqrBwIDJlBPEBfpon26xVA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-ETRwCQdQOpqWVuLvYExerA-1; Wed, 22 Oct 2025 16:22:13 -0400
X-MC-Unique: ETRwCQdQOpqWVuLvYExerA-1
X-Mimecast-MFC-AGG-ID: ETRwCQdQOpqWVuLvYExerA_1761164532
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42855d6875fso33397f8f.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761164532; x=1761769332;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tj5wSQiFxb3TCQrEl/pvDEnruwQl/VFhjMYuvBzqn64=;
        b=NaQNmhMGCLtGyHlkSaJIk5gXDiY2nqW+n+PA9RB6AyO/WoJTWtkO28Su2mXfWHBP26
         MqSTsidkqQmSusEFxx3y0EN1e6XYfMutaeyuuHvRDkZGgfyvdRfT9cKns759qS0uksPa
         DbzUCL6YAd2aEAvKPrhdjSqslSPQiRNGZUY/pUHph5giss0yebZq5OsjOXSTmy2saOTs
         qBZFCAJphcMsjepKaWLsqhHNewrQtiK4CJ2ujcjGTrNCmmZaBm+Xk30pn8kPq0oE9m4B
         WZCK+jq3kSYq6KTBjylz7hcLneI98qXjy63MMA9jYn87F7ML9HV/ImfvnneeT6gCue6Z
         SFrg==
X-Forwarded-Encrypted: i=1; AJvYcCVqvaog0eKuglCVMoqfiMdVA53NBNrIBy5hDBNFV4Mr2s3hzppFQ/Wpu83bO6LE/QU4qtcArL1skA==@kvack.org
X-Gm-Message-State: AOJu0Yw0QLPAMw1f29VGGQ3vvhbHFXUZkBy6lQLBCp0hZZul81XUeDsW
	jYpSyBFN1bpOKDsK7MQQn2fRMlhQsljLYTGt+VrJoXxmlkDt3OCouFLI+CoSJJOq9Mqd+UHnsSR
	hhyaLSWqnbjJReICME8Zp6BI+bWcfgzTPLz1dl9b8UHopWqmn4pFv
X-Gm-Gg: ASbGnctl8DYqfayq+dfkTkScz+A1GiwtfSumOjZzU3qQW1UHs1UbD9WHnrJKrxfeLpf
	GcoqF5LYloiemFk/x/lgS7XLSkvM3SUBZAKFq3xfNQm3qmM0l3l6OlBcmSVXxA0MzuhzVC/hsPg
	6aqDcvyxCKQM/aHvK7rYEbD/AoifXT+1FdIR5I9/hzsMYm5eaN0Z+vAYYLVbItmoKJWblbw7inL
	V2+TP4fteUqYBSSgm7XdbFl0xZKbxCdqBP6kE6jHhhbs2rXloRAZajCdfT6lNwE4tBENJpEhcU9
	mLvbKfDR7QdQWtYxjUmz0J8CCTIA25uLDEoUJchkAxul7AJNbLs5ISrn5+hmrpsDnUolAy4drn1
	BolDrOMmrq0y10Q7mqmtvk8Rm8wBxYuBJHYpQBi1CC0B0EXwN6rBCVG66L27LcoaK12JwM1A/CV
	/JvaIDITedzmRmA1nQJIWgfJbxUyU=
X-Received: by 2002:a05:6000:2486:b0:3ee:1125:fb6d with SMTP id ffacd0b85a97d-42704d442c9mr12627236f8f.9.1761164532351;
        Wed, 22 Oct 2025 13:22:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEflzts1g+chOUXVAtCNc6O8tJrLlNij/gSjJyaO7Hf4ROLo8+ofs8zI8OpGFogxXz82hoJpg==
X-Received: by 2002:a05:6000:2486:b0:3ee:1125:fb6d with SMTP id ffacd0b85a97d-42704d442c9mr12627220f8f.9.1761164531914;
        Wed, 22 Oct 2025 13:22:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897e785asm246899f8f.3.2025.10.22.13.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 13:22:11 -0700 (PDT)
Message-ID: <ed0887eb-6124-44ab-9d1f-1e87e9640e14@redhat.com>
Date: Wed, 22 Oct 2025 22:22:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 15/15] Documentation: mm: update the admin
 guide for mTHP collapse
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de, Bagas Sanjaya <bagasdotme@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-16-npache@redhat.com>
 <bba40f08-1b87-6b57-0e10-6e96e4d7bde6@gentwo.org>
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
In-Reply-To: <bba40f08-1b87-6b57-0e10-6e96e4d7bde6@gentwo.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7Ua4KKIZcPeWbicnncGpROT2UsNoSe0ONMLM13Q_PoU_1761164532
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: fsrg8khznkse8uq655crkcya43bf3rkm
X-Rspam-User: 
X-Rspamd-Queue-Id: 02084140010
X-HE-Tag: 1761164535-742345
X-HE-Meta: U2FsdGVkX1+4iKOo1SWw58S4F3Jm7+To6rXPlF7jZX0eyC6KCMalACd9n4xwNY5BZKhGCS4Qulm9XNKSiD/Q4GN5MC76y3TJRfGJxPOKhEAVGGkONR1DfeQ4Mvn7tggfiBqU/Pu0bRJNY4xmy4cvJkm9nMWeFp0oIkEvjpXqwtKsWUNLouipzWQByGuJAsc6HHs6BX9CHL3MTqdjxUzEoScggSM16kun4/5t1YbNYiSBQV4lj0CJl3c6BJOBvqgfIsUEfjs62WwPMrF1L4waUrSLCIq2JddDdQErEjd9sCoQb8fm9+9sto3BaGvqcgtI031L/+x3TaBAxUgQUtrgsMa/zVd6hKB0gcPDGK0LHYM+gYog2URxcG7HEfv1hUW3EztuKuUQGEkT5olhdfTr6yeCtdllOgx0/vXh3UcirgHu6TkZvjMC1ZBY3F/aC5R6PCgnrQZSwQGA3DGwOniCg41grfRkIRsfTCJbbYA1INgEbvQQptttweQ5+DDmOAMzL+9r37UVYq4JpfoXYOH2lrCaoNA5bhL6+bQ7O1MyCace7WMKTo7iyOz8Q44e0go0be5cqMs65jbhYuFUnRQYWwNfqVXF+seBQKn+1gaj7+9QfzAnpHLC/gW1q8GgQeGiT4ButVdSb553L1zLBG0tqay5DNqtZ4RVbpcpxSXtAfVW0d3NIVYnPq24iAGKpUm3W0yjq/wqEu+Fxz9kQvhmYTsV4ueAstTXV8UFlhzZxBD+ER9EH5bZ/Y/gcbuEc91fvefXsGaLcUJDm97uhhMrErMSfGavjxTfYqJg2cKXyaIvvQrScuj8ZlA6ixnqELkqE0fD5aBaEao2LG+DLlZkvxqG9uVuOa/tTxIAg/jzIA9dykzKcGRf4vdUTM1rTKQkFNZlSC1FAvcplykDkffXRCMdV2bbs8GRuT/jQBE2V8HQd3tfGUnflw5v1wPIPuY9HnxhUnE97zB3HnZE1ht
 QcBP64D8
 RGjo7UtTXql8TKIsMxwxLTEeenG+f00dh4kVPoC/EwMoBwpJrmDohOeG6NlFq2hSEt7WW7jrmhrIza8tAwdhuiu+6k/cytdjGafjcMkURLSiLFFdf94qbaLNJiRaSiNpiQ95nHuB0TTV9GarNC6c1qrp5k6gIDGR+s6L48vaY5LHgvsduSEyjaUq+W3VrwAz4DeVZ1vpwqtU9s5w7c06ZR9pN1rR0GMB64FDm9Hc7DnCKQoNVBXkynR4ZzsYEQAkz4x1BFvT2VUMuCXIo70IpEu+mfcsrYChAgxhL33+EsQjDL2IovNMfYLRuZpidRI/JC2EwUEVDhqnFsbCB8Vgs3im1xgwsTJzHYRgBLxvki86jC8WpZauBuPhWuwjLd9dBAo9mFJp/w2OQmbU/qCRAwonQKEOp9c9gfMNDvJFxU0/LhLhJntm8unx2eLQPr7PN6CAL3momWsQxJvU2CS6NfRRlnJLOGz2gc2yf+U4ZneeiXQybK37H1CLKUowpz8P26mkvqSJtUQcn/NUUQNGiCc7HsSROT/XMEUAK3qL52pcXYDmnhcoV7wxw931PC4CcZo00d1cVQG/VVN+s9nKhtyc1V50qDJEtdGDl70uHrvHtuIhrCKHE43BW1J00FsivD376
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 21:52, Christoph Lameter (Ampere) wrote:
> On Wed, 22 Oct 2025, Nico Pache wrote:
> 
>> Currently, madvise_collapse only supports collapsing to PMD-sized THPs +
>> and does not attempt mTHP collapses. +
> 
> madvise collapse is frequently used as far as I can tell from the THP
> loads being tested. Could we support madvise collapse for mTHP?

The big question is still how user space can communicate the desired 
order, and how we can not break existing users.

So I guess there will definitely be some support to trigger collapse to 
mTHP in the future, the big question is through which interface. So it 
will happen after this series.

Maybe through process_madvise() where we have an additional parameter, I 
think that was what people discussed in the past.

-- 
Cheers

David / dhildenb


