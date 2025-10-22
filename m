Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B68D0CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238388E0019; Wed, 22 Oct 2025 16:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FB68E0002; Wed, 22 Oct 2025 16:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE918E0019; Wed, 22 Oct 2025 16:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F16558E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:34:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1BC05BD90
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:34:23 +0000 (UTC)
X-FDA: 84026902806.16.9CCDAA2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20189180009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:34:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ord2jXGY;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761165261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCpIcRCuoZ+NFrE8wED3wBMc5noEyqWsY1apOXEuFwM=;
	b=Idc0iMUBSKIQZ8F67FBXAA5lfXJedMWOYsqsxdMpsFw+TEyAP1HEf7I9kEJU9+DL7xFTvI
	UmFnFTAHU5A+WMnQC+pPTSYvZOb2vpcf2X54FYpqhtE0KQbTtN0gbyfPA6VzZWTYLlseoy
	OsUjBIVPHbtxDF2FJbapUbjwxqWjTBs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ord2jXGY;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761165261; a=rsa-sha256;
	cv=none;
	b=zlb8oylWwOXo802ArEox5PMpMpOE0OM7VibBwcxMN7WwnJeHeMA9NLkrI4kTahRtXmSzRA
	HQuBz69sTewX1iS6DpPRspWxfEE6RtWNHFlB/B8/Or0NNljhaKMtktXMEJSE6X8q5XI3t6
	+frzNbdvvKeh34Hry/gz6I8wx+ZvHIo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761165260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MCpIcRCuoZ+NFrE8wED3wBMc5noEyqWsY1apOXEuFwM=;
	b=Ord2jXGYLVSy7uah8Beh0CBT+LUe/1tUqT/docnZCV/XrBtXC+1pHze+YoIwZ1KH89DCM7
	rCrC3dYZqPq0GLhPBtWCWecGGoEwsmxID5fdq1Y5Kf8IeBumdEFW3Je6O9nkpHNvveFeAw
	r2n6CUbaOD+F0BjxBscaQMNYgxAIRSs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-k0CbWDwyNWOpq_4ShbzfDw-1; Wed, 22 Oct 2025 16:34:19 -0400
X-MC-Unique: k0CbWDwyNWOpq_4ShbzfDw-1
X-Mimecast-MFC-AGG-ID: k0CbWDwyNWOpq_4ShbzfDw_1761165258
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42558f501adso22644f8f.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:34:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761165258; x=1761770058;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MCpIcRCuoZ+NFrE8wED3wBMc5noEyqWsY1apOXEuFwM=;
        b=h+KDEWlTgMmZLxAgj75VhfLZBxij/h6kmuM2zRjA5arL3sqSUJqmqRhulSf03X8xA+
         rdNi8Mav6VipUVboC3kUvU3GA+/oC7SZHQh13serbBb/jqu1WjFczaGriluedrgdGtS3
         V9Uyxlm0w5fjagBmacBrBN2v1g4i4BGXiHD06keuuGoNo+52lh/igFlqJmXad0OMnmdZ
         TeF/iLY+xJ0vmSf42nhhiTcQkJXXBr0xr/zbvdFPcVcqg+YbPyXFUgT2o+W9UtMkB1Ji
         qjvuWGU7bBxSw8VXdaYltM8i2H5r5UDmCmMhOgW+UEQ3p9SLJKf9NEsK6GWy7SlXz74Q
         RlMg==
X-Forwarded-Encrypted: i=1; AJvYcCVMy8+EdF1F+2efJhwOJm7Ws8P4SPRidRJjilullGewpA2lOO1i0HS2QppiKgGHReD3pXg4ZEgh3g==@kvack.org
X-Gm-Message-State: AOJu0YxN2uopyBlrI1mDVDNqF82+uKTGLMNR3zp+ThCeEvBIhyXYUCmq
	pm6TXhpCt5VKwJXC9IrbrlBZ0Y7D16ZXvyk77T0B2cz6qC558RolwI4EBIZvbrDsaVTzdiOMcsj
	34rXItHtxWwX12xd2fqYVrIDGaqkT8lvFytYhOQp0AEV0rnB5gIGI
X-Gm-Gg: ASbGncvwfm+7HP1EuM3mo4FjntMqIwChyjk02ldJo3FhqzYEf3xabYvHQqwHq4awDET
	q/cDv5VSf2js8ElgaQU/JvAd0yDZOySgl12GpoIZ5/Aqov6G/TfZOAK/gr04KukeFzQWlIT8i64
	9wXDM0qAUT/PoXYx/XgfHbe0MMmikftd3U6HuN8l5QUQBqNxagHplenv/vHU2ERUuc4RAhAQfBP
	tLatPZmDlyKYmxCFlnlFS1fl8Ij4QXN8i+83fB3OWyQnH0GkdWvORhSw9Jr7uLaTDpQdpQ8Khf3
	SQzeMQ38Izxpq7uWL/LeozmlwkL5/WiBLhND89WUkMIkMLSMGS79tcnCqkE6OXp/k2KOugU56Sq
	4jxFzC/1QJ0mbB0RI/5rNgUvQoHaMybKG2A76aStzPyND3m1EvPNSHHVtw9iymRqdRVUjzPsITb
	ECRZUdSIA5n6tVO/HnQIyZG2SJPLQ=
X-Received: by 2002:a5d:59af:0:b0:427:60d:c50d with SMTP id ffacd0b85a97d-427060dc758mr14291316f8f.51.1761165258043;
        Wed, 22 Oct 2025 13:34:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiFp/PzvHA2ojeVgZuHJ7PIytIU8hDkikqIVC3bIAAJDppHWer8LxxL625PQtTJr0DIUqs+g==
X-Received: by 2002:a5d:59af:0:b0:427:60d:c50d with SMTP id ffacd0b85a97d-427060dc758mr14291305f8f.51.1761165257634;
        Wed, 22 Oct 2025 13:34:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897e75absm322783f8f.7.2025.10.22.13.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 13:34:16 -0700 (PDT)
Message-ID: <3dfb5722-f81f-4712-af9a-9ea074fb792d@redhat.com>
Date: Wed, 22 Oct 2025 22:34:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/huge_memory: preserve PG_has_hwpoisoned if a
 folio is split to >0 order
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, jane.chu@oracle.com, kernel@pankajraghav.com,
 akpm@linux-foundation.org, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251022033531.389351-1-ziy@nvidia.com>
 <20251022033531.389351-2-ziy@nvidia.com>
 <d3d05898-5530-4990-9d61-8268bd483765@redhat.com>
 <5BB612B6-3A9C-4CC4-AAAC-107E4DC6670E@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5BB612B6-3A9C-4CC4-AAAC-107E4DC6670E@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fNpn1JRrV7Ux-vL9kVQ8CdQD_kyWvzVB1oX_PU9reyE_1761165258
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20189180009
X-Stat-Signature: kogr9urfog5p48icmw9347bt9o37uy3y
X-Rspam-User: 
X-HE-Tag: 1761165260-386519
X-HE-Meta: U2FsdGVkX19qfP/gw72mVAJ6lDW/L1Ha2BDhiwJfhtZKrjUTYxS1Vrv/XgQJTilEnrsmuEEJp9f1jya5VP8ScnIp1FXuDDteZWVuXkYvzIuFEAy0DOdoxpbAc7OwfQzplJDDuHs+m/fw5KU1ZD54dr/KaVa7P5vkUgIfFZ2d8mxkyyG1taIgve608U1w54/dwHaOc0w22cw6c9Cb4C1SHLKXXuvAT24TYRb9Jd+y4A0VC8rKl27xjoKGgOvto8g3HYCuS5RZ9FoHSuiDmx2cgaNPITHNEp5TpVeSwjj3Q2bPOzPUonRQe6L8zs/3KL9XJWn5T4R6qxFNcxU3iQBUj/HLan1JU2haTn1IHUAm8R1u98tdI2qv2tVfg/asWqdhW5fpCHJGFRKtSMch9jpg5SPC7qyDc3UjwuJMGKT+a4/E5OlnSLeAmVWvvY93wjn+xDfdC8kIlLfYwOm1eE1jVmIn2RMA4t2xYs1rNuvhJHTzPIJ+32PcW3l87wsVHY9s3yy1hG69ifePOgj05N1JoC5TAiI2KSb3Kksf4q2qPmTFUeFlPBhStdgmTD0nHVW7qLfoUfExewbdEjArym7PNsKqj7Fl+EMGEw3d8hnsQOUWEHHqP5S0erNgI8JKYAWaQOWUwvFgZ18DZxq6zG9qUJwG8PS6yuwpLgl0rsuCFNmPGsQxF5ENWkFlqcfR4jyzoAFhdmA0yBj06ZchsaMcUe84+DdD9AzneN3UE+tNEnHKmzgfwHtKH8JJaUgBW+WWNg2z/9aNyG1Lgj5tQNjsisL0Y0+W3Ec6PKynujLPLPuHf9qUMEKwASvI9JpLmZgBuxJiylJZXE0dr33BXNPFB/u2VgeDqxZyxNP8hV/JJVKwTPanV2U9byeYRc2BFFzJksmPvjmIEMX61rEZR1efeTu0lGTkY7gnOC+GUjyBlCwj6EiAYaA/6LeQ4pH/UtPE+elbGl2ZaR1v0nqK9V6
 SBNamjUI
 SNXY7d4LrNZAW9njT6ND13rXm1YnmONJtzWQNOZbKyS/Q1FSz7l8868pweK+wcU1LAgrW4J6YVvspGxiUb55f/NNIxgi4aOz3MjorLvU0NWsYtM/0Co5/v9WrLBY42J7SbI+pIR/koay8tbhgSL1RqRGEIzcGlghoENweWqUPTk4UxUCPbTk/E3+UjcQepm8n1CShGXOL3r28rv8hfkkxX/aDIhnD6Gp6VpZGva2P0XW2Syp376H7jmS2VwsazUkaC85My6nOOEdxZZHUGN8Vpf86CW36/cxQbv+9wrXHIBZufIxy2CBKnSaKXNlrUGCmBSW0lErQqs3WQ+IaHtgt0OG+eFS/c7O4VGaTz4YVs0SWjMBhHAskdbwexZZVwiiJLBaeYod5KWcWXXNWwKZilPUU7YgrT7TZWo/WeHht+T1AJaIkPNo543plI6EuJEwYcY/Hy6+hKZnjb3sb5eNv5qPAgUZewoea6xZfubG+8RqemQqIEvsFjwhW9cu7yGiWorIzCoOS8zEu54aNxsSm5g4enXatvCur0BrRfEuWb9iyl0E4jugZSIi9dajdqfmQCNM5dABIihCXF+ZtzL8vVJenU4v7NTniVmYMuWhxiQz9uxV4OPIDz9EfVxcMcwYH9eoPpbUQeRUx+xGsZjDeEBNuBkU29xCheVJU4ihIrFk36uk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 22:27, Zi Yan wrote:
> On 22 Oct 2025, at 16:09, David Hildenbrand wrote:
> 
>> On 22.10.25 05:35, Zi Yan wrote:
>>> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
>>> after-split folios containing pages with PG_hwpoisoned flag if the folio is
>>> split to >0 order folios. Scan all pages in a to-be-split folio to
>>> determine which after-split folios need the flag.
>>>
>>> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
>>> avoid the scan and set it on all after-split folios, but resulting false
>>> positive has undesirable negative impact. To remove false positive, caller
>>> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
>>> do the scan. That might be causing a hassle for current and future callers
>>> and more costly than doing the scan in the split code. More details are
>>> discussed in [1].
>>>
>>> It is OK that current implementation does not do this, because memory
>>> failure code always tries to split to order-0 folios and if a folio cannot
>>> be split to order-0, memory failure code either gives warnings or the split
>>> is not performed.
>>>
>>
>> We're losing PG_has_hwpoisoned for large folios, so likely this should be
>> a stable fix for splitting anything to an order > 0 ?
> 
> I was the borderline on this, because:
> 
> 1. before the hotfix, which prevents silently bumping target split order,
>     memory failure would give a warning when a folio is split to >0 order
>     folios. The warning is masking this issue.
> 2. after the hotfix, folios with PG_has_hwpoisoned will not be split
>     to >0 order folios since memory failure always wants to split a folio
>     to order 0 and a folio containing LBS folios will not be split, thus
>     without losing PG_has_hwpoisoned.
> 

I was rather wondering about something like

a) memory failure wants to split to some order (order-0?) but fails the 
split (e.g., raised reference). hwpoison is set.

b) Later, something else (truncation?) wants to split to order > 0 and 
loses the hwpoison bit.

Would that be possible?

> 
> I will add
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> and cc stable in the next version.

That would be better I think. But then you have to pull this patch out 
as well from this series, gah :)

-- 
Cheers

David / dhildenb


