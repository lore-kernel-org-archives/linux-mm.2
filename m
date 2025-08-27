Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C62BCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F4E6B0030; Wed, 27 Aug 2025 16:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906626B0031; Wed, 27 Aug 2025 16:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C196B0032; Wed, 27 Aug 2025 16:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7143C6B0030
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:26:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B17C160868
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:26:17 +0000 (UTC)
X-FDA: 83823669594.24.73A821A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 97B9D10000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:26:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eqBbZXhu;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756326374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOs3uJzXX/k9jmtMpMd9nBSE+OF57uMz5ApCLqXUPO0=;
	b=ArxhmQji3r63gqBHhQAXx2dtVcHeZOt/dOPwA7LGuEsgz2TkAoQxTFZ5EDg/AT2U0RifCS
	aetqKtXIIoirVXQ3TLmFMzFkmlmPqa9tMhp5gK9SO17PMLi1f8oIofh4X1UfjrflGZA/A1
	pakH0m9elVNUoWMFStbi/m2Zhdpj1jk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eqBbZXhu;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756326374; a=rsa-sha256;
	cv=none;
	b=m+R4ObWxYEDg+hBgQbGWaMaqWwhlRbDNbG130UuJcKDgh1TRygwWZpoXcPDiz80/7vYzBt
	WN9Zvo7o7IpPXjK2TbaaAV6s9rd3mcbOtGE8y3rgoXBPKU6bpDNNBXCX7B3dn/gtDXvxCT
	fseOsiakGJtzSsq1SoIvsswie4BC1wM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756326374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AOs3uJzXX/k9jmtMpMd9nBSE+OF57uMz5ApCLqXUPO0=;
	b=eqBbZXhulsP+kFC9+mgnY0oFvGhqU/uai0HGm3Ib4sfc56BWpuklD2G05Z6f8DCK1xPcoX
	P5r4tp9pLeoVf1dzb4i9QkSq/HkXLPSdRjP/9W3SEpfU60SBmOkBMECxzsK2k7fZnbhAbf
	brkJ0jeySNi8//qGPsIZ79VGvVO1NAU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-SpiQYU0JOpy7x8lcyMdBew-1; Wed, 27 Aug 2025 16:26:12 -0400
X-MC-Unique: SpiQYU0JOpy7x8lcyMdBew-1
X-Mimecast-MFC-AGG-ID: SpiQYU0JOpy7x8lcyMdBew_1756326371
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b71eef08eso900625e9.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756326371; x=1756931171;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AOs3uJzXX/k9jmtMpMd9nBSE+OF57uMz5ApCLqXUPO0=;
        b=OhACv6XrUltliu+BZNVAmjTH/mNYUX3UuT6LNcGi/Z9MuIsT/zS4iPC/KAOC3Qn4Ra
         Ac8uPxAEhHTxgQHFzdHslUknL0IurMI93ZKGRn/h+rDICw1ovTpp6Mdngm8+0EeEz2mn
         deKV7x6gW6AGOn83eN8MvvJ9pM5v/FWILj5sAGNXf+CO35AOZ1PVJAUP5xl6miouHSLs
         1JpPxWPn7BIEgiOazMUW5/ZwmA+v4CVRleR24sToSnno6ozC6LirCI626/ZnZyqzY8om
         whCE7CfXB6UITiC4jkAklcXikQwAzdzep34VOqmpF7hHuLM1BLjde3/iLQAuMqD6VSFh
         yi1g==
X-Forwarded-Encrypted: i=1; AJvYcCWkvjKuHG3AdMBKKP7QN5Non7smdnKSvQ2HyhYU4yHN8hzNGZrIiYpV8QJlYNKeWHywX74DYI4/FQ==@kvack.org
X-Gm-Message-State: AOJu0YxXG+PU+EfmfcXTxum+gi98fSHtcNmVJdNJHdchhSw47WIwClTg
	zf2kWLVg12aBXwpjwyNsfPIjCD/38HRLvOqh6VUzszgI0OuewSnYaxN9RD8MJG5WfeVaS0tCy1z
	ulxBynvIt6Hg+gftfwlbeJ2kyNZKefEOKqT8XIlBPgEvlqekD9pga
X-Gm-Gg: ASbGncukVj90tkydc3IS6wY/RaXQ6/CsXEeSk99V9QFYSo7qvq6WufDhziVdHpdMZBL
	gyUoccepmW13ycwHd8cmHND6h7OVEHV6lR+S7ZORUhTqlNQqIdD3WWLQX0riyHchy1AMAErKkNt
	hGpPyAL6R/Jx1bQdDCpxrNU7BI87kE4ChRCC2pTR+bJ5ZXY56th4uhWufJBHi2V5KlaarzcWAAf
	OVkIk3+lgwJd6l4B80GNdMv6Tazg4C+DLywdx8anXLhcFddpSOFWyzwPpKjIQo1Kf9dWyzPGGBd
	WvBS8qgHBfKaQ0/kP/drWa3qQz1aCXaV9xsKIidQEdSPoejVw3JkLa7VdgCvHPYJxHWhbLRH0zr
	fhi6Zn2XyVaBQeVRsUyx4z2+WrAS5c9W8zWGkxoGquCOLEsEnmYajfIBC4Xv0cJYBgKM=
X-Received: by 2002:a05:600c:3ba2:b0:45b:47e1:ef70 with SMTP id 5b1f17b1804b1-45b74421339mr17480195e9.35.1756326371208;
        Wed, 27 Aug 2025 13:26:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwWSfdQZlagbLP65+8+IBTZq+moTWEKls9nquyTJI8BJWVHR6V2mwVXtGXYC9Qu2jC34+VqQ==
X-Received: by 2002:a05:600c:3ba2:b0:45b:47e1:ef70 with SMTP id 5b1f17b1804b1-45b74421339mr17480015e9.35.1756326370811;
        Wed, 27 Aug 2025 13:26:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:d000:d4e1:a22e:7d95:bb63? (p200300d82f1fd000d4e1a22e7d95bb63.dip0.t-ipconnect.de. [2003:d8:2f1f:d000:d4e1:a22e:7d95:bb63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66c383b1sm42788865e9.3.2025.08.27.13.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 13:26:10 -0700 (PDT)
Message-ID: <4927ed52-a250-4ae8-b596-6f81020eb31a@redhat.com>
Date: Wed, 27 Aug 2025 22:26:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] huge_mm.h: disallow is_huge_zero_folio(NULL)
From: David Hildenbrand <david@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, chrisl@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
 <20250827150330.280399-1-max.kellermann@ionos.com>
 <30f52bf5-ff37-4e22-ac57-7be0b03b1f51@lucifer.local>
 <0de24b30-70ad-498f-9eac-01596c8713df@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <0de24b30-70ad-498f-9eac-01596c8713df@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0NXwBMjIGH_htyFrcPoM8N1L4YnRq4RXNN5NmKYRWQk_1756326371
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97B9D10000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ugkrnnpj736r993ndkj7jth5ejr5siih
X-HE-Tag: 1756326374-414306
X-HE-Meta: U2FsdGVkX1+ZJ69ryPwtYBcVGE6E3nUAkJc0hKfiVD5qp5VVRW4mLlqKp/ugfAeyq+4EdROg3MQ9rj1KcrIYKDmUbWzQKyzdX2KXTDxPFr9EPjXA1h7OtUkbQgEgtJh4ZeqlTiWH7b/Gwdj9qOt4d2zyUNHO1lXJm7wTQ4a+zvMhfaANFUqLvUu1SetK0l9t5aeGX22s2KBw4HMHpd2H+iWuecPERGi34TaPYvgHFOC38/UZzJQwLPeMPpsGwYLKZ9oqdXoYoHQ8oayEGz3mH4sDKZLbrWmybrGqSopucYkgI49eyA6s+FYRCxaQy7b1E/IZr7nD+lAYLfBEkp1pNZICZ+AdfxGgWmbwn3/aLBwKj9aevsDp7nEASM7Fm3FULkn+xrqLiGDXDHMh6P5OpEJ4jctSiooWWCBRio6LOZ4iSAWrgoTbyZBjNyVKectqQKVnL27h7WRTLzgsrOLEMB6P5DI3Y9r98zZMi3RRTSXamYYq5q78/q6G4E44nZGV/hKkqeBU3p9iRx5yk/zNdOtePgVKYtdQ86VmMsQULt4C4qPJKofm/ydNjUmXgWsHhuVDwumCYGn37Z4gJY7k+1pZidDOjMRoRx4oam8W78C9/K78EYi+THQyfd/tg+fY0VxE1rezaYvHgG60SgdWB+xQvL1hunGQ5o//1jfaF7XKInxdoz+VqoT3sZtYmWInk48Pdb05cEdX1kh/CmLU757s6CoKj2nBqgV5Qo/ysWeGZ5mGS2NT+OnJlcaybeWc3thkSIFgAEi+9Bj+v9cFNnxKS6TlmfblcZHWnDhcFeZPBsu42z5XNKnu3BBydj1oehtV422yhSokFkw+i44fM13IWlEpCaJqyIVpmeX5FmENE0Px1+O5TGuOiBmNFviJighWFFwtwEWbGwJlnaPOmCKpPN5q1i/yCZt0DBp1T1qGEERMJNy6sgGRVDfjqXGczTf5cUy2IyihQLNkOwK
 lVO/sFMm
 mBOH5b4a7KSq0V3waqj2d5fIIYabNnqSzbWMpCu73Y/bFRnkGNqFixZ88Li/gUWArogCPidwstMuDGqF9WCR/a52emReIUG2vyqxEC/nKwz2RxdRJHgBsZ78YN1yddjsrG9x6+3/Qrg+wYz/4AE8lcatgp3o/uWBBsU3C8XZld0oe+qEqLnMmUbBk+Q14n8/bBpwpSbGYyDmTiySqUCSUFnT8UeIpBhL/MxneiV+seSL6vyeZRkNtwW+8COsSB+Fu6MNGo6msQxBL23Cvzkc7cEiWxKxQ90QNbuH+H+cdS1Pfbs16a18du7J7CEWQ6sQXHtzkaLw3rx2VX2SQ2tJGnlC/Ypj4Ntq6hYJawtyfLogQ062f4DOgBj8EXfiLMongcgcaVFHQoNX8MeH3O/ph67RnECXtoVSbeIdNG3pobmsWFZIDsLQRnLBwfcRkLG8MweH+N/HmpUzHmxIm9vL2MOLYFZ4/kp73Ls7og5YGgzDCuXVHO4rMWsjoqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 22:01, David Hildenbrand wrote:
> 
>> This seems not so great.
>>
>> I really think the VM_WARN_ON_ONCE() should be in folios_put_refs() based
>> on what you've said.
> 
> No.
> 
> Everything in folio_put_refs() will dereference the folio and properly
> crash the machine when doing something stupid.
> 
> This function, however, will silently swallow a "NULL" pointer.
> 
>>
>>>
>>> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
>>> ---
>>>    include/linux/huge_mm.h | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index 7748489fde1b..bc9ca7798f2e 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -2,6 +2,7 @@
>>>    #ifndef _LINUX_HUGE_MM_H
>>>    #define _LINUX_HUGE_MM_H
>>>
>>> +#include <linux/mmdebug.h> // for VM_WARN_ON_ONCE()
>>
>> Please don't do //.
>>
>> This include is suspect though, huge_mm.h is included from mm.h and thus
>> this very easily might break some arch that is weird about this stuff,
>> because a ton of stuff includes mm.h including things that might absolutely
>> baulk at mmdebug.
> 
> Jup. Very likely this is not required.

Took another look and including mmdebug.h should likely be fine, because 
all it includes is really

(1) include/linux/bug.h
(2) include/linux/stringify.h

But originally, I wonder if we even need mmdebug.h or if it is already 
implicitly included.

huge_mm.h includes mm_types.h (where we already do use VM_WARN...).

I assume there we get it implicitly through percpu.h, mmap_lock.h or 
percpu.h

So the include should just get dropped.

-- 
Cheers

David / dhildenb


