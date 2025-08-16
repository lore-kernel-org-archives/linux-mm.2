Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF761CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 17:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7876B0344; Sat, 16 Aug 2025 13:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668EC6B0346; Sat, 16 Aug 2025 13:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E886B0344; Sat, 16 Aug 2025 13:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 412006B0344
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 13:04:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5F3EB9875
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:04:10 +0000 (UTC)
X-FDA: 83783243460.23.6C9611C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4E25C120016
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:04:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QDvUz5fF;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755363848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Vdzv3DmlnaOpYN+0D5wTRGqHnadxEawRnToIYrOHH0=;
	b=Xqe26Hk2NJa+gIEQYdlPnFpxS8pzuMczK8a9d3Nb12mPm1lrEenN6Jaw9EcbCeWSa/N6xN
	nFRIJfCk7+paOytzolbgWfUjxIYxwGlqC7yf9EZXiSzhVh42kwyhbnGTbLyxj/RIQCyJ6j
	i59YinXwe+Ww7/ZHoxg1Siyq133JUFE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QDvUz5fF;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755363848; a=rsa-sha256;
	cv=none;
	b=KjG6ZkG3LY8m7zdmQdBEi4Wi/6DP+k19S3NsRMuAoghInRYKYrUPHXYvXM/j6KSrhb6etL
	iLV+JwjpTxdikYOJMz06HytnhaeRPGjLVsNkNXUntR/4ss6+42AhjpEh7uA3S2i5AFee3x
	jecBYqLl5KoLD0AiKaOTcG9RXJeYz4I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755363847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4Vdzv3DmlnaOpYN+0D5wTRGqHnadxEawRnToIYrOHH0=;
	b=QDvUz5fFaH158V98NSSm9BNhCvPXccMT90FZaOH7U5h3701dhfF5l2+VWeLF2AwymkKogi
	o37l7dH3VY/4WxIfNGsJTvvRuJv4YO9rttoUhYsvwdTNspdbkRPXVL3XMiNLO5FLsJemDl
	v7S9IRfVjZDIwUU0G9eCqVI9GktJZIQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-qcNUGTiAPwavY3NIkFfxkQ-1; Sat, 16 Aug 2025 13:04:06 -0400
X-MC-Unique: qcNUGTiAPwavY3NIkFfxkQ-1
X-Mimecast-MFC-AGG-ID: qcNUGTiAPwavY3NIkFfxkQ_1755363845
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e87031d3e5so716245385a.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755363845; x=1755968645;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Vdzv3DmlnaOpYN+0D5wTRGqHnadxEawRnToIYrOHH0=;
        b=K/1qEPNMsbDV0OvXVg40CMKuYqrB9LygOZEnIiB1kjh8dw2i3WZJho9+HK+Rt0xk8z
         DsOw7LoZ9IpWPCdXBPbkb27Z1Z8Cx6JkttTTcSLZZz20n9MlG9CdqIdKoq4OsZFX5rtr
         NY+H1aqCXscMk1zNqjUY9AtSvdhEOLlHSLj4wCHEEPkVP2fIwnwPmEv/GINV0ThyVIB5
         NS4vFl0xc0I1FNE01P0eDr0Sk+CecZo1R66qF8MTmc7/xvKvEXv0xfBx1akxdjtsRd8G
         Z7KXow4j9KWLgX0R/mGSrY0vAfnsIsLqoWS9ZYx6fvxKM54+kMyxcsZDdpjcHjlidf4t
         51LA==
X-Forwarded-Encrypted: i=1; AJvYcCWFBkEZl1oZZJqm2yyBtBwNRhGF93qpMlOl7t2pP+DXvf5ZiPzwLASf6NcDxP6O7/oqRouoj1ZT+Q==@kvack.org
X-Gm-Message-State: AOJu0YxnZRoyTdJQAfa4tmY4fYZh7XKdQUaU3PWoIwqHK+3veMuYtpeE
	jFj1sLC6z3m3kCVd5CJeP6/W5dfqSA9dGzBBcaj5OmIgj3WCazaAQPRy6ANWjq0B7sNLrGsCnQX
	bNOzun0QtMusFRk0CONy99ONaPELqNW1NIwUsch4n59tLFmv6EuF5
X-Gm-Gg: ASbGncv1d+G2UsV+Lo4fa+Uq+G+QWhm38gPtGcCOncSvF9qpd3NJH1/wIaHsw+xsG9W
	0cYNp95Uvh4xh6icEWpjmSHrZhElygAo2qxbvYmOJOpcU2D002+Xm9s7BGjLhkj8GSNFrF8+dZ+
	tD4bms6ojWeU/xcHO7JFm8vrjwL7ime0f+VmaM1BQaF0mnkehZlKCl/0zcir638P0c7XZ62zjh/
	SQumjCdV/mY4Ff6C9NMUBPzcD8O0hK2uyZFa3O4PW7GPIgmeQNq5u78UTc42alwhQjdHLMR3tuL
	J1JrpR8AVbEtaPaFGDBBMgPH3ihYiD95PsWPzOhVfDAxfQ8JqNjQQfVcBcVSd0dIM0P9JeVRvCU
	UjVMr1xhOaRsuOASl2LOBnaQ4zlApqETxQe9a4mzrKd8FobJU3r/shTJ2PNuPhTAHmkY=
X-Received: by 2002:a05:620a:319c:b0:7e6:3f78:8f08 with SMTP id af79cd13be357-7e88688587fmr514791085a.60.1755363845424;
        Sat, 16 Aug 2025 10:04:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNaUZO42WuGpZxpSuCZqndfUjaEylzUym4Cf72hFk1jzKC0ptFmeGKh1sj47e4Q0dIMo8G4g==
X-Received: by 2002:a05:620a:319c:b0:7e6:3f78:8f08 with SMTP id af79cd13be357-7e88688587fmr514786285a.60.1755363845013;
        Sat, 16 Aug 2025 10:04:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87e1e5a7bsm290177485a.75.2025.08.16.10.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 10:04:04 -0700 (PDT)
Message-ID: <07b17e1c-92e6-432a-9af6-13d3fc8246bc@redhat.com>
Date: Sat, 16 Aug 2025 19:04:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
From: David Hildenbrand <david@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Huacai Chen <chenhuacai@kernel.org>, Huacai Chen
 <chenhuacai@loongson.cn>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Michael S. Tsirkin" <mst@redhat.com>
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
 <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com>
 <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
 <66ebc632-6704-4637-b62d-1cb11e5a4782@redhat.com>
 <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
 <aKCwjCJTEhX4Q6wW@casper.infradead.org>
 <e06f23d9-adcf-4d0a-8ba1-bda6d4b483b1@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e06f23d9-adcf-4d0a-8ba1-bda6d4b483b1@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TqIz_QKe9L5GGbbB-WP-wAQkPnzIUqwyKWrt-39qE7U_1755363845
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4E25C120016
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jt3aqscj7t74ekkosrpfgbkapzc6hsp6
X-HE-Tag: 1755363848-591989
X-HE-Meta: U2FsdGVkX1/gp9LIb7u962J1T+TiqakPs8GBVsjuSSm2Q/71pmdS2Axx14AXrKwL0UcCyxU3LfkprBDG8NqlY8OBnL2YukSHfoMuIbs1GhniYCbfEmuizRvGKQULjSTJQI+UmGTjN7wgCRDDLzpHn/fBtUthsXNflLzjtfRv5QBad+fvx77Mv9Hagxfeeijwdb+UHMlS2emjK8/EY7EmrLbLhVJnUlTRvwaRO4mrZOBeGUjLKAD/lJ8DrBwdsxGac6BbHqFP3ShyY+3wlE63iGDp0pd4OCnTEVfleVSz4QNPP+FENGOVcETQRBCt+xolmBJdJRpqKzINTAhNideteTfjqSo9jseV4F12h0wVvZjcm3L8whvk1koBFyNQOKPLX7b42T0BNAwgTkXKIdw6anuCfg8TKxqWmfMysP9mlClQ7NwjpEmluBr+RwJY8mw2nSBW5hVm+qhV9KwarU82tVlOUAD0iMMQO2JvORpreJ1BSRw+x/vkwYEIwvMGF336o0hkFWVcteORvVgIFYLpp2QkRagDIxt25EzYKlFa0gkhoMfAICFRN2HcPceZzxtprxVtDLYsd+kuU7Qq7f7D7JRVMXnjY5QxMjJdDBq2uJfOYPT1g+65JkOLcB+w9VL/DDFFtGQQ8ujkjjLZ7Fc6AEAmFZxD85pOWU3+KRRMVJTv36phAO9x4ady1IQJwlO/QQO0i6vlPx84Yz0ZxGT4LycB+GX0W8JDHrAS8YppHgLcH+ur/u3YQf6qjRg8+w59dnJfpFW19jrFdUXluY3a5Hq0Xop1LQRZu9Jyy7ehF0aU6gwpRD6qv/ATCERqM0MJ8A8hgcgME34t6x7u5ccqMg4E+g/qHgEkQttUSISpWGCGHkWPfCDYb4++nhqM/kpx17q4zfmLVya44Ji2rKyg8RYpPio0E92qu08zENlh9aVgE1D0g5bDAkiUrhfN49EkAra7bKtsyt6Lh02anTm
 iOnE+uKd
 G86+WyWXbCp92CY2rKAuTAxQyx8ermkP+HCwq7aK7+Vhk98dvZhD00pYEsIx4r2oe3i5sevab2lXLahkCZn0JB4cXWqfGGkb+Nixmi72ZahP7P+uWpxcPgYSJMXWe/f3wuHiTAWuNYsa+OFVwCaCX15bVB6Gmuc0wSYzSNn/PIJiszRgryWZh8rXWbqRPqRw8cMxcFl/uczGUYL3upjYr/Hfjqj6rmsK6wITjhoQAZ1ZjjQp+gF1GpeXmqbqDV8io5Ut7mkd7+HUWeoCqqzhRR9vV4PPm6OtLIdRWY+LFQQlwxg2DVlZLGgj3umP+OLlnIBkp/V1Vao6+cGc0OIlAwGeA1PNs/G8A2BbTb2WQJEpSdTgyJPYjx5z4GAd8UkcCBPrGzkhX2kI6NTlBtZw5/+TRLwYubq9DD4wtE0EPDr6Z6SM8x3JLZa1XayOgthqXm2glyhH6mj5yjEeAdMDZwRPiiCB0i4q49jsNU4+VK70Ht+46UM6x96xRPRLJ2wk9lV9SRCIKFnU5/qLV+RIeAK5XdWXQyjb+C62De9ibKCbdn05yULEU9xEMfHHlYRvm03FHAC3NEymUQdT7DwlIRt98bSH2bYhh+1rV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 19:02, David Hildenbrand wrote:
> On 16.08.25 18:23, Matthew Wilcox wrote:
>> On Sat, Aug 16, 2025 at 12:54:52PM +0200, David Hildenbrand wrote:
>>> +++ b/mm/balloon_compaction.c
>>> @@ -256,8 +256,10 @@ const struct movable_operations balloon_mops = {
>>>    static int __init balloon_init(void)
>>>    {
>>> -	movable_ops[MOVABLE_BALLOON] = &balloon_mops;
>>> -	return 0;
>>> +	int rc;
>>> +
>>> +	rc = register_movable_ops(&balloon_mops, PGTY_offline);
>>> +	return rc;
>>
>> Using 'rc' as the name of this variable is an anti-pattern.  All it
>> tells you is "this is the return value".  Calling it 'err' is far
>> better because now we know it's an error number (or zero for success,
>> of course).
> 
> I know, we all have our things to complain about. Some about Cc: above
> --, others about the name of error variables :P
> 
> $ git grep "int rc" | wc -l
> 12730
> $ git grep "int ret" | wc -l
> 80386
> $ git grep "int error" | wc -l
> 4349
> $ git grep "int err " | wc -l
> 6117
> 
>>
>> It seems to be a particularly IBM derived antipattern ;-)
> 
> Careful miser :D

"mister". No idea if "miser" exist and if so, whether it could be 
considered offensive ;)

-- 
Cheers

David / dhildenb


