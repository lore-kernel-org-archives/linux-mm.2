Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0849C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 14:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D84C6B0095; Wed, 30 Jul 2025 10:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0456B0096; Wed, 30 Jul 2025 10:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29ED66B0098; Wed, 30 Jul 2025 10:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19E416B0095
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:04:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9E2A1140A1
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:04:38 +0000 (UTC)
X-FDA: 83721101436.15.17F997F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6278C100008
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:04:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UfZDQvUg;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753884276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3O2oNAXD8KVY8vBDD4aG+8v/vac45H/32JLje5KhFMI=;
	b=36YSQ9rs5AIg9m5vWh6f3BbkobXNVXaYdgYT2L73P9t6I4c4nhWDqEb58W0S6gJBEaU42t
	p3IJCq3/HdziuFtXQJsTpk/7QanNKfx6/fzqVvVy9PalgkZMLIShXyCOcOBgxEuhKEJkbS
	ZbVrLL1gqnQ7COAeG0/47iQLvQiivmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753884276; a=rsa-sha256;
	cv=none;
	b=cxfg9F8i4c07WpiaK2/7/w1qHaxyRb4Pa3mjO4U8lvlbExOt/3RMz4PKmTqNwS+ttiRXuD
	k7+3mNLwhTVrEyZYhgDtSRDAKfcR7E6PSxgLk3uXmGfaFxfexmmkmb/a+a9WAbScP2mHNA
	AUwaKZRW7U31vhW7Z3ZKEEBv8UICjPQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UfZDQvUg;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753884275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3O2oNAXD8KVY8vBDD4aG+8v/vac45H/32JLje5KhFMI=;
	b=UfZDQvUg7f9QXs/xnStmjnt61mRk8axk+gVKSryqCPhJbGq7YlKzkcSV0XziYMNZP9fGcw
	XfO7Rp16/qlNa/UGROBHJgvKqqiONCgvjpxFX0gET0rkH4QHNlr7eh7bFlCbtTvKNtOCSB
	gFQXRZ5coMUUDiMxy8dob7GI688nHT0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-Q6mcZNpEPdWkWB0mPkUgDQ-1; Wed, 30 Jul 2025 10:04:34 -0400
X-MC-Unique: Q6mcZNpEPdWkWB0mPkUgDQ-1
X-Mimecast-MFC-AGG-ID: Q6mcZNpEPdWkWB0mPkUgDQ_1753884273
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ae6d4c5f798so534675366b.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753884273; x=1754489073;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3O2oNAXD8KVY8vBDD4aG+8v/vac45H/32JLje5KhFMI=;
        b=rhkaW3CjgLA3pM7fIjNyb96hdaFt4Tb76f6h/ALE69upcsrvStIVQzrZ9yLCnBVSiD
         GZsQHnjuimOmtdb4jojcxKAJgH6GThNf/RxwoRVpp8vZZqGgiYWgZ/p7qvnRJOEtob6o
         azpxF71S31ETagMg1jKYJpE3iVwxQSFykg8IiY+LsF09/WPB20uCqOgvSjvvmHsLmx5R
         /ik+JXcsMC3RG3WnPy/eYtn3kR7xf+qwfZEBx30JE9pvydRRclmlukOY0CLWfQjcvmmx
         nFLN4cT9J7menAl1r281RnvktGSpEIYRmX/SIKDtHFdgihGjN+a1rRKR9Kbb57ass1Zq
         1WlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYaW5WpwTmVK7+4oDtjsUlouzzY2pLRSoRTxa2DRVak9UPFURBvCzCmUlc9eVB6+4LjZ0AFQt+3Q==@kvack.org
X-Gm-Message-State: AOJu0Yzj9y440j5kQEmMJKhWxsGIWzG/kNkeuaCo2eeOF4SpyBr23A6c
	dcdeLeoNifPjpIaRgqFkPxMmzktKUHx2GTu4kgkjYf90hfKVOdMAdpyLo/wFxXh81ZSZY3nuOvj
	ku+iyhI9Lq71pKxiavPJSvmOcefwiOSysnOF1lFolPEf0UvBzyjoyM0FPIkj0j0b+ag==
X-Gm-Gg: ASbGncsx5C3ss6XfqqoBfx5Lsl8fAxONNeeyTu92HohH5rVKYup4/5QQEr1emma6lMY
	aBfR3sRfsSR4rvh93MkceTnq00Yr+bsrcHuh16xsXPik0I/qm4nH2n5Ay968c363iAp5XWBtHAO
	1IEEM5MQsWpyMCIOF5DZsEnNtuHcImB+XfUk8qgnJZlVo1GgqATwJgYQiOGCvwWOaHAq4pu+hQS
	JZR+YmTeaDfyR2I1pSY8MYgpl/98XH0FVoGsB1vYGnhBmgEh3Z0OTidfKo6OmqgZV5Wa+fHAJ2g
	vCg84bhU0U2Na9jd8XGJzXnCIe4Sdt+J+1P9uz/JnoEb85AZFUoNjoUj3lG/EA==
X-Received: by 2002:a17:907:3f88:b0:af8:f9e8:6fae with SMTP id a640c23a62f3a-af8fd9f663amr404270666b.46.1753884272859;
        Wed, 30 Jul 2025 07:04:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4NPzv48+fUrubCDntYT5pIsBc9DKyFBE7vheDZ6rVTSQBnixNsW4Ss/KjIbgNUx7Mki1uOA==
X-Received: by 2002:a17:907:3f88:b0:af8:f9e8:6fae with SMTP id a640c23a62f3a-af8fd9f663amr404265066b.46.1753884272305;
        Wed, 30 Jul 2025 07:04:32 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af6358600a4sm754596166b.25.2025.07.30.07.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 07:04:31 -0700 (PDT)
Message-ID: <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
Date: Wed, 30 Jul 2025 16:04:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mqjNTDKzU5aku3kEWo4eoxh_biSnLLTEAIxfc71jQZI_1753884273
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6278C100008
X-Stat-Signature: tcxooo63z4s8peid7azer1h8qbejajb7
X-Rspam-User: 
X-HE-Tag: 1753884276-812143
X-HE-Meta: U2FsdGVkX1+WR0WikET9YAPKWzp9HUpN4wj8EM1gEu4wI0WzTIExQKQb9UgA5GZoTm1e7KilkRer+HW1Ej8Q1Te/oPF9D/aJXY462JggotxEWOhUoQhLlesjWvbYY0pE+cFmkKvNowwzFSnkWmxcIPG6MCgOf0dWP2TDVAUgMauRZIuYs8Hqp6cjfzxesVhK2pjvWbRRAy+dMD5yJeO9LQyJxOapnw19IAa6k1mYAfnjbrrXZP+9z9WzpmvRliUpcJ2OUudqF6Ca8khJL5AdO0DOqSDds9OHlR9I4vRrrmzxb34OdBnVrOgCEm24eVttkYdyKrD0TCUhl8n8s79EGv1bLA3uppMYTTEQDKXQFifKnxqSe+3jh0BTnTxULms3o/U/n2BkjDug86NB4n5iMuVL6LybwJCNHgtGCVW2p85YTfRQIfi6HWPmVKvofDnUahh2Iax9kVezoiQMkhamHbiCB/hZtaszQ0wPUH5CIzlsbklC7LIeQh1DKmXpKQko2sJsgrrsyy7OjxaQ6b3N8pK8DyAes47YXej7JesmKpjEzBRIO2iEA7xDlu2PmyckFq5GSEp7pJy6rP7CTjtGJahOBUoq8rGSUEWjv2D6JWUiZ3hGtuVm+tWWWOE7VSt2uF/oYCbMH4+bEOa79IZHx1mnnPD0DZ+7B0gVkBAsb1T41zI5jpYFdj26ZeI9omZhyCWZuk46SVMIrRWbzhCBwkLN6O7M1e/jX90J2+7X/B7pFEUXkFz+//JhmwAV9naJLNmVi67XVFSnTSjAc6P3shK21ao/zVOyF0oo5Wh6uHY9NT6XDtz0qahuEHbEE6fAYUpyKc+SQT+Wj6kzf7gygWMAQMIhIOwtvstIyRbx6Dt0KjPTOruv5Dx52bHt+O+3MELZ18ht7KejivovZExy0/OYrWxPyKd/KSh9lnwxC5VLMNeWEdfIeH3zk9iyp5llRoFDWsHulHOq2a92tLg
 1k1z6pcV
 i1uqg+2lH0dwQf8gpFXcSq4pv7725hPuMlmi5dVbN5UIaiNWXyKMcYwawL1Do1mzXWqCr8ffVDBByeEspYMUsa1wZ/HFATaOzv2HBgKnKrqmxhxDE1xRdrxz3rVVT36pPrlk60b2eEINfdEq9xsaJ8gquhe3iafPgyiaLH8nK9vdfHuHBynbEbUVv88BwF6M1PGpIRPdeeHP21goWgynBr4lQ0TnY7bmu2HPsRgJWOO3jsL0VG+YVNyG+DEo/GlpoHw7wbAqAx2beiTcCUqF8Qz7xlJho69SjNkQ14qfEg2zPZyNaJThapTtyzHAOJacBf+A/VwewvrtQX3uc2ooAD5GUtl/3y+LkUCQ4QZDj8GI41i+HtwhiS3n2iPVahCOIpRCUC+EXDpFiXQDLwI4fFTUvufwjA3wwuThJAjfn75EM/PWjyidlhMmEpQOAbZ0e1VtyOMCjeoe5v2Nf/dShLp3SsyPTamGWODliTsWIEgbcVTRzY3wVmhK2mO/YNgQm2Iep/Cq8HzhgkGzoFpey+7CD+x5ZlX0Iohhd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.07.25 15:57, Eugen Hristev wrote:
> Hello,
> 
> On 7/30/25 16:52, David Hildenbrand wrote:
>> On 24.07.25 15:55, Eugen Hristev wrote:
>>> Annotate vital static information into kmemdump:
>>>    - node_data
>>>
>>> Information on these variables is stored into dedicated kmemdump section.
>>>
>>> Register dynamic information into kmemdump:
>>>    - dynamic node data for each node
>>>
>>> This information is being allocated for each node, as physical address,
>>> so call kmemdump_phys_alloc_size that will allocate an unique kmemdump
>>> uid, and register the virtual address.
>>>
>>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>>> ---
>>>    mm/numa.c | 5 ++++-
>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/numa.c b/mm/numa.c
>>> index 7d5e06fe5bd4..88cada571171 100644
>>> --- a/mm/numa.c
>>> +++ b/mm/numa.c
>>> @@ -4,9 +4,11 @@
>>>    #include <linux/printk.h>
>>>    #include <linux/numa.h>
>>>    #include <linux/numa_memblks.h>
>>> +#include <linux/kmemdump.h>
>>>    
>>>    struct pglist_data *node_data[MAX_NUMNODES];
>>>    EXPORT_SYMBOL(node_data);
>>> +KMEMDUMP_VAR_CORE(node_data, MAX_NUMNODES * sizeof(struct pglist_data));
>>>    
>>>    /* Allocate NODE_DATA for a node on the local memory */
>>>    void __init alloc_node_data(int nid)
>>> @@ -16,7 +18,8 @@ void __init alloc_node_data(int nid)
>>>    	int tnid;
>>>    
>>>    	/* Allocate node data.  Try node-local memory and then any node. */
>>> -	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
>>> +	nd_pa = kmemdump_phys_alloc_size(nd_size, memblock_phys_alloc_try_nid,
>>> +					 nd_size, SMP_CACHE_BYTES, nid);
>>
>> Do we really want to wrap memblock allocations in such a way? :/
>>
>> Gah, no, no no.
>>
>> Can't we pass that as some magical flag, or just ... register *after*
>> allocating?
>>
> 
> Thanks for looking into my patch.
> 
> Yes, registering after is also an option. Initially this is how I
> designed the kmemdump API, I also had in mind to add a flag, but, after
> discussing with Thomas Gleixner, he came up with the macro wrapper idea
> here:
> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
> Do you think we can continue that discussion , or maybe start it here ?

Yeah, I don't like that, but I can see how we ended up here.

I also don't quite like the idea that we must encode here what to 
include in a dump and what not ...

For the vmcore we construct it at runtime in 
crash_save_vmcoreinfo_init(), where we e.g., have

VMCOREINFO_STRUCT_SIZE(pglist_data);

Could we similar have some place where we construct what to dump 
similarly, just not using the current values, but the memory ranges?

Did you consider that?

-- 
Cheers,

David / dhildenb


