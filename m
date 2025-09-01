Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38094CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C4C8E003A; Mon,  1 Sep 2025 11:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5608E0003; Mon,  1 Sep 2025 11:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56AE8E003A; Mon,  1 Sep 2025 11:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA078E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:35:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3957DC08FE
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:35:59 +0000 (UTC)
X-FDA: 83841082038.14.C6AAE77
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id D152540005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:35:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QtNoV/+R";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756740956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bItAgGic6pszMCrQXDuDJ/trqhNDQ63firEDd4uIpg=;
	b=pAQ/2nF+4/0H7U629deL0ClLGRasi9vXn9Bl6S2Jk3SSjDBKDrINAKVY8T8M8/dAF6fjrD
	jkbABTBXfB8GztCPFdQeW4BLs3QLTVpISrl0Mr13T9zNK+Y4ejctIpXbQru/yC3U70bhHe
	O1JAruZG6jHIEN5mnzwYFTktY8QwxcM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QtNoV/+R";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756740956; a=rsa-sha256;
	cv=none;
	b=XhWc+4/04/eipsPS8IFo3CsQvTL70Z1KsC7GQQ/9iOubfuEy5r3v79VbJuwz445eTb+ZNC
	zvgiKt5TlOQmy3I+d0Hsonyou4NbPiklb0NoRgnjKhZKBMie1EKZTH5HSx+w2LBO3WJU71
	sd3S4/J1YOL9EHTUzP53THLqxSOf97o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756740956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2bItAgGic6pszMCrQXDuDJ/trqhNDQ63firEDd4uIpg=;
	b=QtNoV/+RI+3+Mhky2tRYy4BucW+FlyFyTB9CwfzRSrC+M7a2iNEDSEVYonELPJwdRnTQEe
	mk4JQ4EmvygAH8KI5xrEih/mqj6Wb72iaNexy3lPRjzOoAv+gRr0cubvIepUGCHSjuacaf
	V7RyIyfrYlceorkvR8RcHxt5Izz7U9I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-sHX6X6yCMqGiJDY_EMKS5Q-1; Mon, 01 Sep 2025 11:35:54 -0400
X-MC-Unique: sHX6X6yCMqGiJDY_EMKS5Q-1
X-Mimecast-MFC-AGG-ID: sHX6X6yCMqGiJDY_EMKS5Q_1756740953
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b869d35e6so11886855e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756740953; x=1757345753;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2bItAgGic6pszMCrQXDuDJ/trqhNDQ63firEDd4uIpg=;
        b=BwVhVl8rZ07CPDsuHEMxYZkot3tk9OzE0MFRd4fp9NQQLQ80gwsiSjjxVAFwqTQ2b+
         miuQa0X28riaMx8xGL+Ee1NfDhCToPiy50j0vb9ZacTS3mbyc7NT2OQ8cZsuugdjOAZA
         Ps0ZR2wMuesY68YBzkUQK1sZBq1GGE+SEDfbYB8JI2+vm2QFQRplj8wnZkgaT1xhGop2
         S5mPXxJu1qhHrhj4eHql9xyvEdBMUTznu7WuzMKvoWZOZhwyCkezdM9EoJb0RG8MQ8On
         G3VSbfsoJm5syxwB54/hwuEiw3Q4l6SxrlDjKRyFEhdgqx+A1LejKYvUNT7y2HyqQJj8
         lJiw==
X-Forwarded-Encrypted: i=1; AJvYcCVTi+KJv5bSDNfmut03rkO6oBWsmEzzUJWoLcEXJaLqI4zMq1RZr+7NFUxXINdHihX4PVgx5nd3KQ==@kvack.org
X-Gm-Message-State: AOJu0YwuIi2Y6H3EiXz5uF1Zucdpusapow/EDobB2YYE26DrCtP5wY+Z
	TEO/HOZyri5ZwQHerVUhh7Na5O1AYkdGU++HaTTudN823ZxN78Dt0R/0t02EwepNVIW/zdcJYMy
	Ms8c8EW9Dn055NrigiMyDM2TyLrptaTb8PTXi63daTVKq+jGQ/uC9
X-Gm-Gg: ASbGncsKdCbnhYFOQ95nSjPN9wGi708SLRazxjR5lOl9D6j0M7H9p9yXrJpynMAUopO
	CDbrN/9tQ0N2IKhzb5vant8Bssy+G00ZdaxfwjjSmNTNZKyqLCT6t0Fl7k7kie6uO8NvhK5T+DP
	PT0GBJZXRueykicDfOUdAxIPd0VXqKUFnfRsw7/ALgIWX6dzgh7VIkk0LhWk8JuHkWm9Ua7TTCl
	NY4iFzvv7Ohz9ctPHkhMsh18t8FQjIQFiHbptgTglCG9dYHFCE3uTPXV9lAwr5JZA1awX76wHH9
	wSD3zCw62rD3Ce5vQKHg/tiX7DhgVWu1/W4Uu6gBEddVXX0w4qwIkY04+29b5wO3hnHwD1gjBa2
	M68ujn0+GfK/3B0GQefzWR0GgyzU7b3jKhnhF0g2AaTeXj79h7ss0Xpxo9CoEn7NwalM=
X-Received: by 2002:a05:600c:1387:b0:45b:615c:cd2 with SMTP id 5b1f17b1804b1-45b85525da3mr79300215e9.8.1756740952991;
        Mon, 01 Sep 2025 08:35:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHavLnql0Xb0EyOZzHHbVUfKOnLFQ8rZYbaTiEbmA9ZWCeXLmTBJuPecePMMvEIIVgKRqEsFQ==
X-Received: by 2002:a05:600c:1387:b0:45b:615c:cd2 with SMTP id 5b1f17b1804b1-45b85525da3mr79299855e9.8.1756740952559;
        Mon, 01 Sep 2025 08:35:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b93fae643sm5496885e9.3.2025.09.01.08.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:35:51 -0700 (PDT)
Message-ID: <3b30e9fd-4035-42f2-a7ca-3a670bb79dd5@redhat.com>
Date: Mon, 1 Sep 2025 17:35:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, kas@kernel.org,
 willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250901074817.73012-1-dev.jain@arm.com>
 <620f01b4-8a6c-4dac-bcdd-7c48f5cd87f2@redhat.com>
 <e52cac79-fe1a-401e-9259-747a4d587bd1@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e52cac79-fe1a-401e-9259-747a4d587bd1@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sVkefMRjjKXs3Pm_hoc9VzfSr0OcXH2hUfJzvPuAKDg_1756740953
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D152540005
X-Stat-Signature: jr968i51duh1fikmk5ezygx9u6c5xorj
X-Rspam-User: 
X-HE-Tag: 1756740956-112601
X-HE-Meta: U2FsdGVkX196dDgXm2CCyftHZu8dCdstsNCE4wNc98QyCHD3f1eepdBsGGnUy5seZ4NUfR8qsGKP41kQvWhgtpRu6r5jsTwYFJ2EoRfojAlnILQeRBFixWPfJ6OEacnTTFUvuz2hVGREfzNem6D9DZ4r85RDWepDV4JyqTB6+D/qbrhsgdeD2CEy+bt3YXY1rWR8ACZF8fQDZM1HnDtDdOGThCJWiY1+3+mecOj6UpyKxMe4lGImWxJ1C/VjiZooMw+229TMysLSTel0ar3oCDo5bzlAjy1OpzmSwf3d4GUi0iHVr6ED7XhjAwsjprWB+KrYYiFM1XdGWVmFp6hyPCbXalIHKf9Qq4NhdWXMHQGGEgrgzU/9nLGZbQ6bULzcC80hLb2ZjsLnHL7zCNIcfnKUCK5Y8goUqQgkdNMEodrOteE5GKdSS/B0tKQcwM1Y7I1ZF4lzZyqVtZKEZ/UiMXISdg/aUIwIpDVrphkCLznCf9BbOTQXNAsi5c0Kb8JFEZ1q7DY90IDeBFkQebJm0pzCf0B5PSJdsSnk/tM2P7Vn9HSbwomn6LQySyEhjh7LfUsXSbIWYHIy0TzB2mPc0nmgScdw9DoixXOH3g6dDpLR/rKwAK7vWVNl5KWDxtfezS+/+15JCZJJt37Jp3Dkw2a7ThrwNTehdcsfNscgLzlILlZWS3xY1fSDuC8ZxOiOMV4uqVtdlYFBXheIRHGZD7ssr4+gVzh0CfLbF+6Jypvt2NrlkrlEYZcmVd3tSaYsr5arJNfuCLizq0uVQOdvMDHZoozU8s+JfpAolMnjHLQuLAlEf8xni3kWyKj/aLhfG7wOHrhEe/zPgelt2HpR2L+J1cXWNU3GYA5FEPjTG7rfrYf5Hwz4oMpJYFfZRQIiKL7NYjfHrTos4zRn3oIifOO41XMQ9UmI9G+GlzaizHuoKCr2RJB6smIWP0CaZKrILYfcgnygf7iTG56P7CF
 ZoIsBUiu
 2JGMm60CL/KX3S0reqY/6o8wLfTcJ3HAfMJzrCjcOuaNwPIHscWN0wWAPHzOVACgKeogO2U4V7QMqgrRqeU7Q1q1xrEjMnMmF9YnvIYr519f5YaAEKCsYHTamwWiwRgf3Z9r4ns99UBy55ncWdKIbNYL5XzAKjLgw598V/rmEKdp0FzT6caHFItG9aLbw+9aEkSHtjH+GiVlx3GiAjg69EjcxvZSgisyHLGLbIMVNNfZDaUSemMiEjbbH78JanO/j/qIvso7hNMbhqmn4xfY1tRVcLac8o7zzoQ1LkryPasQt8OIhZXG+jENlREd6ebecgDH0nL3PJigJlIlpfsv2ll3NEkxceG1t8tQkZuVo7wYJ1nHbP/OvLZIuFMl8b88VYdiawk4+7LP7yjjlhucfyG9wXxbtXR40HmmI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 17:26, Dev Jain wrote:
> 
> On 01/09/25 2:02 pm, David Hildenbrand wrote:
>> On 01.09.25 09:48, Dev Jain wrote:
>>>
>>> @@ -19,7 +19,7 @@
>>>        EM( SCAN_PTE_NON_PRESENT,    "pte_non_present")        \
>>>        EM( SCAN_PTE_UFFD_WP,        "pte_uffd_wp")            \
>>>        EM( SCAN_PTE_MAPPED_HUGEPAGE, "pte_mapped_hugepage")        \
>>> -    EM( SCAN_PAGE_RO,        "no_writable_page")        \
>>> +    EM( SCAN_PAGE_RO,        "no_writable_page") /* deprecated */    \
>>>        EM( SCAN_LACK_REFERENCED_PAGE, "lack_referenced_page")        \
>>>        EM( SCAN_PAGE_NULL,        "page_null")            \
>>>        EM( SCAN_SCAN_ABORT,        "scan_aborted")            \
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 4ec324a4c1fe..5ef8482597a9 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -39,7 +39,7 @@ enum scan_result {
>>>        SCAN_PTE_NON_PRESENT,
>>>        SCAN_PTE_UFFD_WP,
>>>        SCAN_PTE_MAPPED_HUGEPAGE,
>>> -    SCAN_PAGE_RO,
>>> +    SCAN_PAGE_RO,    /* deprecated */
>>
>> Why can't we remove that completely.
> 
> (I raised this query in the other mail but due to not snipping stuff in
> between,
> 

I saw it but forgot to reply :)

> it may have been glossed over)
> 
> I was wondering whether a userspace script could break which assumes
> scan_page_ro
> 
> metric is there? I played with tracing long time back so I don't remember.

If it's part of a stable abi/api, then it could be a problem indeed.

I don't think trace events are in general not stable abi/api. In 
practice I think some are (e.g., in scheduler).

I assume we can safely drop it, just like we can add new stuff.

After all, if "SCAN_PAGE_RO" never happens anymore, we would never be 
running into the __print_symbolic() with that value.

-- 
Cheers

David / dhildenb


