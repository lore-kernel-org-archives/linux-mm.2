Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8F6CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07B28E00AD; Tue, 14 Oct 2025 04:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7478E00AB; Tue, 14 Oct 2025 04:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F338E00AD; Tue, 14 Oct 2025 04:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E49D8E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:56:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A0AC13BAA0
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:56:29 +0000 (UTC)
X-FDA: 83996113698.02.C7F6772
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id ABE908000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:56:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y7uexzAu;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760432186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXCdHwwxLDCnqwPCNGrUwIhvpRHdaZLAJF3D4SOjiTg=;
	b=rLd/I74v8I87tersmiaychgk74XZtJIjGdrCzSXDZeCfmEbTk3DApR/fXABquI4oAyljit
	i0g8pmbuap5j9COjsUaBOheWs0nTTQ7D97wxEZO/EiKKnBL9kezEK3X/kVBS4gMMLT48PB
	8RiGXbxMAXbQR8oEKGlSliuPS4SMZZs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y7uexzAu;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760432186; a=rsa-sha256;
	cv=none;
	b=wOZAy1fFyJAJjPqFJuzCcF4WGXXFPMjFeAqInUOaz553/lORtq/RdZ027GeFOs0Ml9scWZ
	0KmnbaCGVd0wnbk1R1PcIjX1WkjN8GhwfSacyqPSRoQkDTYq1GndX479msVgn+N4+h3jzh
	nn2Xe3LApBWzrzTYHfkjkMLOCDpS4RY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760432186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yXCdHwwxLDCnqwPCNGrUwIhvpRHdaZLAJF3D4SOjiTg=;
	b=Y7uexzAuOZw6vuD5sBuBoW5SHzgATcIpGF7e7lWhI+MqcLu7mzMKnBHZ5Sn/d0VJknvWK9
	/z3hfA94bcGzRsLCT4yACQAy3uVn4f/k63D54wb94zunNA05gqmNpYZSEuDRHnXbJ77qtI
	0azAxmo1ZmKYIbuVgokoIQUerIc0JuI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-H7_N70vpOPOrswFUZJMkUw-1; Tue, 14 Oct 2025 04:56:24 -0400
X-MC-Unique: H7_N70vpOPOrswFUZJMkUw-1
X-Mimecast-MFC-AGG-ID: H7_N70vpOPOrswFUZJMkUw_1760432184
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e45899798so32688105e9.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760432184; x=1761036984;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yXCdHwwxLDCnqwPCNGrUwIhvpRHdaZLAJF3D4SOjiTg=;
        b=ijVMZLY4NRGKPx34UMKsHoyUcgbKhkEtOMEwiNNAG6XhpLaoI+Y9KeX4NiS84gZxuR
         z7GQgQko/klJ76ir42k9N0f5w3zR/7dXC2oZ1TbcGdd9xuuMmh4WqAY4Eee0dK6ryotR
         EbcoFROyKUa0Y4QSp9XO9CTktp7/2PaIDTkbNS7dhZTNKwgJ3vreYLhxIrRnWAdUK4jK
         X+UyqQcGY8dOR2TedrveV6zuLItOQ5AMH5xLIG0Sz6PFzwUBBBBLuVZq5H46RfNZU7vD
         oFI8+vgo96FstybhX43CHg3pCoW3U1zPkkGSL/iC0joETh491M4YtSAWwn2H4InuyXJ7
         ufZw==
X-Forwarded-Encrypted: i=1; AJvYcCUuMpSXU5jIr7FpLeL+2IQYLJ0Jjy4VjQ89RtmWKlkIjhAKWunH5Y+9LgJiGmlqiUNhjSFoOyfiLQ==@kvack.org
X-Gm-Message-State: AOJu0YyacuNr4llHA9UTjU97PZauLzabnLFOCdWm3l3S/NsaLdJ4XCgd
	f41L4ydXW3typuEQ/c+92nZr/+GC9N4IjE70DEngewRgnti4+W3YAKTffKfcq8LepwPrft8Dmby
	J2oD8c9Od0wltSFQ/Ze/odqAYJVmKq0eei2+StsSs01TYaiGOqC6e
X-Gm-Gg: ASbGnctDseYGYa+FJ8KstuMapor3xv0UobXpHn7LrfFA2iVo2nEzb9PZwEy+pfTGrJx
	BGAMlDSG02M9gtsKuUdzAWVEPtuixE/s/0ClUZEXYtWD6wzj/3K4+Y9zIduUTdJ8CIoZ/v0Fiqr
	Hv6mEjP0lNk3wIDftnuK5zmXK/sUnQfIkhN9VnQKKajfLZiw+Gf+RKDpxOzXUuwTuFew+LHbIcm
	R22Fgln5POnbJPd6uxYXseGiqxvH3CBIOH7eAZgkOTxTXy1GzYShuCqW8mlFTIw+5fcoknEbuAX
	u2rYJkDl9RdB/3T9wgBll6o1hypckBMUnZ4yTtAkVOK6qEmphvFxH2hWxTwcGzcmVn+RZji2hA=
	=
X-Received: by 2002:a05:600c:37cd:b0:46e:6d5f:f6c with SMTP id 5b1f17b1804b1-46fa9a8c2ecmr167111895e9.3.1760432183641;
        Tue, 14 Oct 2025 01:56:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFljo4nQphtbBUy8R5y6R7UpkTzhzu0mUJcmJniIoTuu8r+8uLhyizs6R1SGYX86wZ808TTjQ==
X-Received: by 2002:a05:600c:37cd:b0:46e:6d5f:f6c with SMTP id 5b1f17b1804b1-46fa9a8c2ecmr167111625e9.3.1760432183194;
        Tue, 14 Oct 2025 01:56:23 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb48a60b8sm231360405e9.19.2025.10.14.01.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 01:56:22 -0700 (PDT)
Message-ID: <9282d8f3-4824-4109-9e9f-3b75284d2e04@redhat.com>
Date: Tue, 14 Oct 2025 10:56:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: mprotect: avoid unnecessary struct page accessing
 if pte_protnone()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
 <93d00bb0-8aa7-4f52-b9ba-ef777ec191dc@redhat.com>
 <4469b9c3-3656-44f5-897d-b024e030587f@huawei.com>
 <93736a75-3fc5-47b0-8985-96e1b0b98b8a@redhat.com>
 <364ceb89-6327-498a-9582-bb1fbe2bd98e@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <364ceb89-6327-498a-9582-bb1fbe2bd98e@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WV8mKRZj-x7h2GL_tNP44UJ7YsIobyqUSWZzH6Pn4gk_1760432184
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gfkuknykcbwieduxwk1wcgbx7hmnageh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ABE908000A
X-HE-Tag: 1760432186-171303
X-HE-Meta: U2FsdGVkX1+0ZF3tUbkJ13yMQUQcjN3qH5hhBzYwbKZZUtksjD8raCjCc+/yjBQtLbCM7O4gJmUvN2n3Otr+IwtJ6h5YH8f3P8e4tkipSqlE/GENel+NFQtL+m3A30V3qraGB0tvITxtC8pLx21mTK515Tj0SSJXVrVDK6uKjGp4AKFtKP15z84/ier4mPTez3xhCcIrc3htXTeWUoNZo3FHAiJTl2M/VJaJ8S+2L9R6Kx+XUxuZrfJaUOW52THZHADOxt5QUZwwKrTLT8DPp0Efb6knVUKPqxtMEw6X8ODChIHi7W6g/uAAaX/RhFLnBkm7jqROtuDsxUmjh2yd6pU2XN4UjISiZhDpoXyddRgLDM0bQ0MeXAGTH+AI4NFd1SquX4tFMx5r7uLdhtKqvMNvsCRtF2G5aVd8N+E6DK8AJj3zWbwiF5KvSZq9KYu8fCZp0+YvQXCnobthK7d1mJKbHmRQ76C0KIvdEy6/KFxlsQyk23Rp163FVrTwu046NT2P4pstbts5qiOlGui5nLmHQ8Dkv+ASsj7pqZ2P8NrxmdXgQEep//1nmOWqi78+OSqkE14QGgGZ4FAJ+2EonHz/+7xn0Pk9O8DTN1MxQwcJmyBLFmq8xtCyP2YvxLq+avvyT75Us8SNx46EqwJeh9+2+8rc8d68k0MISQ5FDlab7WBa6GkYPjZdz9LKi+IheujZEIVB+hKQCtMLLY7p7sDdMMnGTvUWrMAPMG+oaNKpkl7e+9cKwjH6iIAaklJePQWz8esgsOeO4KkbbfMXqpQMDoaHEg6qTrN3BQGP3cybrC001WVueyiqfz62P20Yn0fgkaBuGlsc6q5nqr8wDKGh/PaJKHruiLM4BkyzLdkm86U3EZxyMICE7AjG2w/7jfXBQcDbqicTQNrEei7we1Xr2mVcnw8XG4Tv/mkcllX56UEMyjRtTcFEEUtVbn4pLN0dIU7YwzFh6jj+wpV
 zvRggJD+
 xc297zzldqZgoLFUwS8SH4+rvd8prSsdYs8+AxxIzUcKfddOkUnVzhfFE5fNFdTUohzDKLk2pAqsKraocJ2hrkzUFTF+v6UhF7sseodlkd01NhPlsqBP+0mRNPi37AVXLuJRkXb1hEHIEVIFE+rejTB2qETiNCShauP6kRksH3S3YJ9Mj/Dms3uk/p8M8ffahjTPD8zDZK7NYI/e3GhIdttHrnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 10:02, Kefeng Wang wrote:
> 
> 
> On 2025/10/14 15:16, David Hildenbrand wrote:
>>>>
>>>>> +            if (prot_numa && pte_protnone(oldpte))
>>>>> +                continue;
>>>>> +
>>>>>                 page = vm_normal_page(vma, addr, oldpte);
>>>>>                 if (page)
>>>>>                     folio = page_folio(page);
>>>>
>>>> I could have sworn we discussed that while fixing the prot_numa_skip()
>>>> fallout.
>>>
>>> I'm not follow the thread, but we found that vm_normal_page does
>>> introduce regression for mprotect benchmark(libMicro) with
>>> this vm_normal_page().
>>>
>>
>> Right, I raised it here:
>>
>> https://lkml.kernel.org/r/aa496798-5ac6-4cb0-bdc2-91515172e935@redhat.com
> 
> Thanks for the links, let's fix it now ;)
> 
>>
>> I questioned how relevant it would be in practice.
>>
>> I'm surprised it shows up in a mprotect() benchmark: mprotect() itself
>> would never be able to set MM_CP_PROT_NUMA, so the code wold not
>> actually be executed.
>>
> 
> Sorry, my description is very clear, the regression is not about prot
> numa, I mean the vm_normal_page does introduce some regression when
> mprotect benchmark in libMicro, before cac1db8c3aad （"mm: optimize
> mprotect() by PTE batching"), we only call vm_normal_page in
> can_change_pte_writable(), but now it is unconditional called and
> 10% regression in some libMicro mprotect benchmark.

Right, I think we discussed that as well at some point, and possible 
ways to optimize if we ever have to. We don't have to optimize for each 
and every microbenchmark that heavily, though.

-- 
Cheers

David / dhildenb


