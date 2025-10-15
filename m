Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA58CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 11:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE908E0015; Wed, 15 Oct 2025 07:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F2B8E0002; Wed, 15 Oct 2025 07:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84F78E0015; Wed, 15 Oct 2025 07:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4F348E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:52:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73237C0114
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:52:24 +0000 (UTC)
X-FDA: 84000185808.22.9AF7832
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 049C240011
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:52:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U+P2Evuc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760529142; a=rsa-sha256;
	cv=none;
	b=YcYs2yX6+UzpWSH43nFoOZvuu7D0KgWrM9zasDUtidpYTKMFYJ4Vi08Z9wZfaat/ynoUC/
	mtwcA84QfzHn48+qBQCvlLeBRkAscdTbheeokFVYA0FdU2NSDlSZnSBcdZ4jnBFmTM+oOr
	4oqnSYp4eZjNP5/p64DMImWYb+6/JsI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U+P2Evuc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760529142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pedxTOqCnDHcJWjHS6sMRZ0lAfvMDjf4A7k3dRzT8q0=;
	b=l0fE/wMXmncKuNzKsuYj6P+RvFfTSqD33XhIv9a5CmqEmce97JvJug9iKnPwqlrq7BatW7
	zR1uA/F7HGXPEqrF6x7Rj0uUcWXhlOxLrKEv9Q0ohE7DSGZfXe9YQjveY4K+lMrNBiaVaH
	rdfSUZxRoVuzK58wUSWGZzSQBL5ytY8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760529141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=pedxTOqCnDHcJWjHS6sMRZ0lAfvMDjf4A7k3dRzT8q0=;
	b=U+P2Evucvu37r08rn9Tc/cp6WUzYKHn6vLQmV8bF9MuShtLovTv+//lRlhF4pLL8qV5Jeh
	NidVZaZOcAgTcb+HMQNBNe1Eml4GTZ3vVn0QDN3t4rcAFwXAI+N+OOnPNaJc/khFmRGUWt
	haGwkOrI5EwPEVdNnRl3Be0vV+EgDgA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-TeTXFrpWMt6DmAVekT914A-1; Wed, 15 Oct 2025 07:52:18 -0400
X-MC-Unique: TeTXFrpWMt6DmAVekT914A-1
X-Mimecast-MFC-AGG-ID: TeTXFrpWMt6DmAVekT914A_1760529137
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-780d26fb6b4so7242293b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760529137; x=1761133937;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pedxTOqCnDHcJWjHS6sMRZ0lAfvMDjf4A7k3dRzT8q0=;
        b=crTDZTlQ8ABGjRwtRLawvLZZPDOhIk2vBbDMUWxrYNS0ie7FHmZJqPifpcMwzekmGN
         ewrVF8haRQGV9n+IxJNurl8o7p7KTJXD9Ho74zL4c5tVXbxYXrBvpmodE7vVz/gDVP6O
         hx/GqQTt5k+7O3xqttPNe2EuQyKvu5nrkwuRopr9URz1Q3oxqSkirD5EafqmppfOuxN2
         TW5bPjrvr0JSyWAQeDCTDohsNvThqtCu5B57M2KX+5RESwnmP6AbBy4ukNNjGZuvkKUW
         s8hRcfdvj3GRydMj286NsITHozdcObZFbXn9og00m9OIzWfB0k4AT2ly3McsdwlsGCS5
         Ip6g==
X-Forwarded-Encrypted: i=1; AJvYcCWfjX6Ke+D61lPv45KKbkvMnWqIlzwJbg1NoPI6+ihtBOy/SXjTzxc/59ck7+OlAFcWdCyvmBUdgg==@kvack.org
X-Gm-Message-State: AOJu0Ywj5uQTE8hGRqz6uPHxMhNWpmsrZOGQJ7qU0OQ4EaqrXZQqBXtx
	Gcbacmwp4VwPzNgDhZjjuadf2lc5SZey+9nip0gG7R/5vlQaDptZ9OUo60OBqC7MiRtv0jI5fjO
	Q8TYp9K0x9QMCQyClRzFsRggQy4ZVz0mDIZQg5uOI0pUFJBi3hH+U
X-Gm-Gg: ASbGncsJkBHExlcyjSC+wv7BUn7cO+jSgw4GE/APoVk0mu33hdt6yXOokmEcfP5w/fT
	5efdtjolkwJt8rs5GuoKRdzqkiatkxsifXCxuree1tI0uJcPbdL6QKHOuG+VMJbug57VzqQLGym
	vZoEevG21usgxEVCund3YNaN50+ZXv3HG88IZrVtlp5RXdmULHFcEa8SHLrHpebppfYWRw5r6YP
	AezFxOG6cX6cWrcoKIxePa8TzYbKZB78iWnMlriwZzH8DopBEet/i7EmFpSYFN5lwvyJwJKmUUa
	7W69c7Vf0BcNz1JaEqlXIhI1rUA8qKDZSugCTNkWW2tYL1KjLdsc+fz3DYx7f5Q=
X-Received: by 2002:a05:6a00:391a:b0:781:220c:d2c1 with SMTP id d2e1a72fcca58-79385709914mr35986746b3a.2.1760529136937;
        Wed, 15 Oct 2025 04:52:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGb7SrqycHuadlwdELKoeyFjQEpGJz99JROKqikDtE+OMa8GiO3fh4r0L35lafaemYLXPK3Jg==
X-Received: by 2002:a05:6a00:391a:b0:781:220c:d2c1 with SMTP id d2e1a72fcca58-79385709914mr35986708b3a.2.1760529136392;
        Wed, 15 Oct 2025 04:52:16 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d2d2e42sm18235247b3a.62.2025.10.15.04.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 04:52:16 -0700 (PDT)
Message-ID: <df452f66-7113-4842-b2fb-7752ccd59e9d@redhat.com>
Date: Wed, 15 Oct 2025 13:51:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-10-15
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
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wrdR8Jb5juMG2ZkbXGom190T7HH1ChJmnoINt41E11U_1760529137
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 049C240011
X-Stat-Signature: 5qsegwmm1ik716tna68jz3kagk8sga3y
X-HE-Tag: 1760529141-591447
X-HE-Meta: U2FsdGVkX1/WHWV1szNsRWd27Q2d46m6ZWKUgLGRCH80w21hZKEdvLExF1XVOCdQ32jPLCB3inYA2C0bzzueO6ARgxI/rfGoyVGcDjzhkBYvtZSalOP99igBvJ5hpNsC53dq6qwsP5UfT2UHbt6lDonJSB0XYo72dL5c7JUpVYFQAy334BHha5Wpd8optktdRD+HbrEwW2NLCjpH9lSdA7ULRpCofEtyqq+V+nBUzB6NvL0c19Ps6UWpeedhNNKdVM/WYaV4Byy9fPcUyUDjqujJO+I9gHzsLRnmvBnktGhmBnsPUGwoaHt97c0UYpCEkWK5UDYc3hhhp592FVwxRXkZCwZguhW/kE2W7bBtj7+ocOulNDas0392tA9Y0Uv2dKFsMZpjMf5O4vUswKyK7lReNS9+7ChotL4NmVqHd204q2KsCBNC1bEKNmk1C5bsGTLA8CW33nVYB2WETbvT0Loz5wwzGSTn7Rriw+l35629NMPklK0UOCyl2lC1ZSX79ydxN4NrswP5c2gkwYb77We2eqWmVcZLv0K3Ld+bBCcwHX2JekwFw/Rx5W/VZ/yKv+0OwKWoLGr8krO99WJNLwLRNnQXBPIbBXo58MFuqS2Dj4i5ZjKbPdeZrjynsVVlfp9Jmi/JxA65o0/jZlwRPaLTaJfUcL/481FsroyeGrcqHKXJFTahdaZa0ZenGcWl5GtG/kQoHKRFWHQ9XJlS2dXicAI5VEwP1QNYQP475ye3IX/+s8HmPhKpihXi5xMx9+Kzb0LWo21dV91nydd+GWv6wpnPvL2+lvv4AQYXMpL7NciKeNHM7ZxcM4loEe7BSLj3QaRU6PUTBBrZOQ/pcSL24VCLz+MamLpCpv9MFF17H8rVj0tRo3anJm2rV0bkGhagkJvhylyLod73/++ggZJoTGWa6TAqMGP79JE/c7CpJTBZhzESmkJIqnpKjWvTjFLVvtvQcRY6QiMuYBI
 6mhU1gkW
 5pPXp5Q6r3pXBQkHzXg+E6IxlGbbiYYcPLxq2KkD2zLdphnPibGLLCnwc8i/ql3PEDCUZdOtHiNj2zzrxrgk8nkQ7bxXeUq0OblnMcjWlkN7I8wzRAD26IVQOUDx0OXPQHbLfvxz1HICkNjOcYgHsqG7drFqguMsh3+fZHafpH+XkjXrNm5aqdnoaLMFPIIwiS60RLTPPzqcnugckmwLEshODnNd4Zs/W7W3M/mRKBn9GC+65VoSHuFiTI5nq80iH/QeVcTq1XQg7ftFNVXmYAFKNHoo1w/fNNaZDUiGHAF93itaVRo2Mqh9nvBWvXxMstg8HkAuUJ6zuN1xgTyuv8mg7bZEW04ZJlltWViujoJA5pb2MgkLF4Vol2wQNacjgl7bwgWYGe2b2swYGdgdxr2855AW2Qomy2joqiEyCEq6Q8w64wqk02IzxlPsJalFVKAsCfN30dyB8f2A6CG6sPfbmO8flmsWJKhNVJqMl51ZZ6QWnxGcCuu18de7dpVdhPjfVnpuMaip9uPjgLXhkwZQKJ+KW3wbnbmtMblx4VdPD/OvwpddlUuCCr9KcTM/kw+aLvGynvZJXbnnGzjNyM76OunyAjDl/Ogpi2U3/KS4jCL/wZEjDPfhO/XBwCObssUK1mpe5A161CKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-10-15 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David / dhildenb


