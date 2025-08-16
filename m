Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D65CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 17:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A390A8E0029; Sat, 16 Aug 2025 13:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F7A8E000A; Sat, 16 Aug 2025 13:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE588E0029; Sat, 16 Aug 2025 13:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C79F8E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 13:02:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2C3359163
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:02:57 +0000 (UTC)
X-FDA: 83783240394.04.0CA055C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 23B234000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:02:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GeH4NuFI;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755363775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFOP4bP93eQhTLAi/4pMwsYYbYyGFzwy8zCXssqgG+s=;
	b=0r5VOxl1uLtf07zCq3w0T3fbVwd8XvbVjWW+Fb6HMtWu2nTHmo0uZVvsqN4XAQsfqMKApn
	lxUAdChYP3mYi4zwCS1eX/My62UiOwrgvg0sujZ8o128sbu0mzxtOl3Ja7GwX33cSOu90Z
	lcuJsTqJ2BlJ9p6lPh4WcWHDShwNZpk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GeH4NuFI;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755363775; a=rsa-sha256;
	cv=none;
	b=kgQ20zcCflKSUXyfPtUgvuixf6a5bwmrhnLokgIGefCUyZ3VRqeYzzT04AlDMEZVYHBJre
	2T5ydnNhO+PlEX9CnZPj8B9fItWKqebhT/T3fvztAQem6PquiPFn3u9OCbXs2iq4xNeQh/
	v6K1I1OOpEfQCMSfY86fOTV6Vb6e/oI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755363774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rFOP4bP93eQhTLAi/4pMwsYYbYyGFzwy8zCXssqgG+s=;
	b=GeH4NuFIhqHNbHXtd2LC1Zqa2lxmM1LQ9cP7Chq9HVL6Onqs+d79hLIACKaIR2n6myBoN0
	9mfA2zSO/tuBDdG6NTN8FlDTtuS2X0Eb26jDmneWRBvRLHX4enm3C9uoEkHQJwdL+EHvDu
	SEp1eUBSZaePdCjO80K12NMU7Ta559I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-2XdfdPL2N8G2smcZXi2OZQ-1; Sat, 16 Aug 2025 13:02:53 -0400
X-MC-Unique: 2XdfdPL2N8G2smcZXi2OZQ-1
X-Mimecast-MFC-AGG-ID: 2XdfdPL2N8G2smcZXi2OZQ_1755363772
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0098c0so16694115e9.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755363772; x=1755968572;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rFOP4bP93eQhTLAi/4pMwsYYbYyGFzwy8zCXssqgG+s=;
        b=QRcqBN98VyH13Jb+/BceAZW5v6w/nOVFVm0qZm6YGyZ4lryve4Jq/pAdKGOn3l7U+2
         PWzRebP4F2Hv9cur16x8b4KMzF8MqaanEsXQpDHyY8wovwcq7dzJslvGmHPZmk3XRgcX
         wEMYpchswB3Qz4KA0nN0K/OiBPgIQEnhIGonFm8qS1cxkDUajzBfYQLK3LsxAb7fbnSz
         ePwPNlBGZMN3OGknc2F4byHptg78q5hyKq2qBeHMN9KkfMcsoy1z0NrhHlwLVEfmML0z
         /IxZZdbdt4/UxJ/Hg2WUTpSMfCJnI1zmKotbDBWId17JTaE14zh7Hwsv6c1IJRA1lEkE
         1yog==
X-Forwarded-Encrypted: i=1; AJvYcCWHcMqrWJjYCJT6Kk+utD6aD7t1fr053lRglnWEO7hghBXp2bW+SMGy4buqyfGPpq3Y2oup3WBPTQ==@kvack.org
X-Gm-Message-State: AOJu0YyFCCA9Rzz9MGE4Tc2DVasOcay3lQ77w8qFE+lpdNVwRk4w6jpP
	p40c2EN4RHnXkxxnC5XehNVEKtF+Sy6+SbH+9SnQKEr+HJvrvhKdJtwDcoH//aCx+oJBRIe7RWh
	kwOMpXZyoufpUTydjQJbt4rUlGY5vLScJd74YKB3Z20W8tQwqL6UH
X-Gm-Gg: ASbGncvEp0CTBYXKrLnKGPFIY9Wb9tnGyo2OqWdopPBNGg56oJ2HHf5c473uMHYWHSS
	KfVfAB2s4vf22cPmCxwk6Lt7YE6EUC2LJ57Sc6oV1dvUGd4qNpvGq71q/dHK7EoQiVgb4LSrMNh
	2TFM4J0s2XJEbwxb14W59CVIp0OM/R0B25sD1rXe5TKMIBXgWIYoht+Zbl4KWJagavt8/aXrAKR
	y4zq+T229+2McBZU+DWe/qj8JEvL4pPzCszyk4CTk6i7K+XnW1erzxWWvZCRm7d34d/xh6Yw3ov
	bKO0AMpSkYf6ZiWgYYFZHWoUi8M4bIZEyHSDUR06yvSdJD3pRf1EJOfNzRvDg80XtnjF0TCwWrG
	TCkOo598+WmzH2J4NtRgiYtpVZdVQH2uB3PN1G1rFZSuO/qm/pd40tgqQsihJf9Reov0=
X-Received: by 2002:a05:600c:474e:b0:459:ddd6:1cc7 with SMTP id 5b1f17b1804b1-45a2177eb16mr61148525e9.0.1755363772092;
        Sat, 16 Aug 2025 10:02:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOyYAkn234G8pFJcO4TueuMIUSgTIyfD8FB92vg7RHPAiraVq7PwNpRBwY9X2yqOnzbai3+A==
X-Received: by 2002:a05:600c:474e:b0:459:ddd6:1cc7 with SMTP id 5b1f17b1804b1-45a2177eb16mr61148305e9.0.1755363771677;
        Sat, 16 Aug 2025 10:02:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64758463sm6419268f8f.4.2025.08.16.10.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 10:02:50 -0700 (PDT)
Message-ID: <e06f23d9-adcf-4d0a-8ba1-bda6d4b483b1@redhat.com>
Date: Sat, 16 Aug 2025 19:02:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKCwjCJTEhX4Q6wW@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pT5Unh6eT3Y6iq4KbbNNOUFUhisHW5AW2E6Ht02JnU0_1755363772
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8ttkyd6yy7a796wim6p9whr3omu89ict
X-Rspam-User: 
X-Rspamd-Queue-Id: 23B234000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1755363774-881826
X-HE-Meta: U2FsdGVkX1/XpIstAcH2+g/ih0niIVL4CL6iOU0pO+853VtbOBHXhCRkcNFvLJhXEiCK84PhK0P3/TVWBT0UOdBxndL4ZntegEMfDkdybOmXh/UbHrgDZIMVSu9SMPozCzu5K2P6f8YlkSFcudxZojMHD1eY1zIfPwCCStwdCw59auwabUDRRLARATcmtizzz8fpdeCufe1AieLDs0jOwStW9ozffQGlJ1+K2fBx0w4pnYZtSxYO0cmkw3wK2EQkaJGrQs1KnM+4zolfMIqT9C8vkdgF8NxfjO0GncX1xNI6eq9G7YCwF0WE0v3pEGKg8AXjA0/AMW1U5YTSQqvsM1QMHkHFRpF8EkNGGv9Qw8IcMRpzAjxIcTkj3O4z+ZdcHXs96qP8EUcqJh+uFqUxx8LgArfTvtQp1daRx12GaRAhYPg1O0oN/TLETePYfjnNulWQsNy0sUe7rt9rZ5e0XwWO+/GO3saQWe4+2BG+ncas6f0ZgM5Q3pN1aSIvF8KLtktzLMCSIdXOLo+n1Z1+t8XTElgDWGuENrI+ja6G3/c1j9NgqbYGY8MyMFH1SBDoVeUIlm0yGyt+vwvg87MyNIaR8SjYhMpMgFsH/3l+Gnrv7kuliYUbYZqV+yt7Q4UeNaj7oyhK8owu+uQULxFuMPRT0KvXr6T6AVFGlq+qJse+ayl7bsGEY3wjF1DzEY7cx8ePYpHmUlWWMY9FkDvxcFMbJEo8BDY2lQH1wMbEF5G4G7/xJXfUZY11HeO4Q42tt8uERpoIfOVMT5vj0xsgTHr8reWm/EDH5fZIU4rmB2+NyvbMWuoymyD7IZpidRW82xD0Lhmy/8K05hI4LkwQeBxO7DX6swiaK56V/BgifvSo5X1HWUTuiJ1bi9ikjFexRJkLdyHji5LBo8yMU90e2uymz63LgCVuewYGJR0iSKxYHJufeve+R7MeBKZVe0heoro1GLj98xoHolyVHx6
 9ooGc+VV
 TtU5ES4Z8CL9wBQRDtwgXxg4Ysa5IDEbmZ2zicAZ/Pq6FNmF4Oc9l0T+3feCp76gr2sNepHYo5ggcYzi08NOopew9x55kf/8fnrIMt0Z+moJxlbRXXkzFKP8pYFYIp4dcH96e5a0pcvdcoobcLv4uaLyyJ+2n/0JSLMFV0DFzxjx6Gc6v8JFVEYgiRzkFmn9dhlyQSaHrLKrpv3Pl8+fIC/Yj5DD8Bb9XiRLdSF087gHs6CJ63fBcpT+LCkl8uP3HxR9s+9ySocjmBIFN9YC2ZL0ayidYK5t0Z5BbgSMoH50DqJUpwRILgV1wz7iPj1msvqn5M3f8fEgiIbpfEldV8wWXQ7GPtsIkChc9kO4KcyHGQj0ciUmfNC014JsqidIWqyHtl56LZlZ2GOiQ2XmnS/HNXaR0by0CTNSNxA6X2Y2e9muZEoRm2vuktcguLDq2rZ+/oZ4nQJw30cQEG6Pgqxm/zpc0Cyj44Sra
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 18:23, Matthew Wilcox wrote:
> On Sat, Aug 16, 2025 at 12:54:52PM +0200, David Hildenbrand wrote:
>> +++ b/mm/balloon_compaction.c
>> @@ -256,8 +256,10 @@ const struct movable_operations balloon_mops = {
>>   static int __init balloon_init(void)
>>   {
>> -	movable_ops[MOVABLE_BALLOON] = &balloon_mops;
>> -	return 0;
>> +	int rc;
>> +
>> +	rc = register_movable_ops(&balloon_mops, PGTY_offline);
>> +	return rc;
> 
> Using 'rc' as the name of this variable is an anti-pattern.  All it
> tells you is "this is the return value".  Calling it 'err' is far
> better because now we know it's an error number (or zero for success,
> of course).

I know, we all have our things to complain about. Some about Cc: above 
--, others about the name of error variables :P

$ git grep "int rc" | wc -l
12730
$ git grep "int ret" | wc -l
80386
$ git grep "int error" | wc -l
4349
$ git grep "int err " | wc -l
6117

> 
> It seems to be a particularly IBM derived antipattern ;-)

Careful miser :D

> Some internal style guide, perhaps?

Kernel-internal style guide maybe ;)

> 
>> +void unregister_movable_ops(const struct movable_operations *ops, enum pagetype type)
>> +{
>> +	switch (type) {
>> +	case PGTY_offline:
>> +		WARN_ON_ONCE(offline_movable_ops != ops);
>> +		offline_movable_ops = NULL;
>> +		break;
>> +	case PGTY_zsmalloc:
>> +		WARN_ON_ONCE(zsmalloc_movable_ops != ops);
>> +		zsmalloc_movable_ops = NULL;
>> +		break;
> 
> This might be a bit excessive ... just passing the pagetype and not
> having the sanity checks should be enough for the tiny number of users
> this interface will have.

Yeah, no strong opinion, this was a 3 minute hack.

-- 
Cheers

David / dhildenb


