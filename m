Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E75CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CAFB6B0088; Wed, 13 May 2026 22:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BE76B008A; Wed, 13 May 2026 22:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7917D6B008C; Wed, 13 May 2026 22:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9BC6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:25:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1645C1A0511
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:25:24 +0000 (UTC)
X-FDA: 84764433768.18.D29893E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id B6576180006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:25:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UlIafEYI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778725521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1SGeIejERo1rp5IAxu3XCJqrbQpmZW3EKeLtz4XF1I=;
	b=wQIf/rDbWqx+k9Mw6fT/7sD0IEk8FFMiBkIlMb+EiKcND7P6VpCy01GPqiiSBtFFoasRQk
	Wh7amx9DYha2hRQO/G+Ub8st5n1yrx1NY97zIyLl8mMD3aHayNNVoHb2BHh/YzVuhTfb3a
	1aWxxhnHOTUcJOcZtd1gjFjl24lb7fc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778725521; a=rsa-sha256;
	cv=none;
	b=Qz5Mip17gCmZ2G1iIkXiMbzSdOXXMPQBHTYqhg/qyqpxKLWpwMCzLj2h85sLPp6L+pP8Rr
	9avsrzbflv3EWMZmd3oWyfII2ymuVoxJjJpMlnyfcEgFOvmJKvSzgIvCi+f6BjJOw+eCHU
	4U1FKHTWZOkfi+qSygBjiVGr4WHFmBg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UlIafEYI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778725521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P1SGeIejERo1rp5IAxu3XCJqrbQpmZW3EKeLtz4XF1I=;
	b=UlIafEYIYWM+OGxStZmwklh4OnLtCNKdVDLPSQUGb668nv3OrMYg1db7h89D61g1ALT2dm
	uvnmMD+NCuwWb7Tkz7xsANMeRJSYezgkz2PyHsKl3GMbeJhg5EMmU+rPodPeK8GoaDgC7E
	tk8R6444U6upBguke00ozIf+WL9Mvj0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-UjAkX7uZNoOmGel7Xdh27A-1; Wed, 13 May 2026 22:25:19 -0400
X-MC-Unique: UjAkX7uZNoOmGel7Xdh27A-1
X-Mimecast-MFC-AGG-ID: UjAkX7uZNoOmGel7Xdh27A_1778725519
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-910304978f3so231299385a.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 19:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778725519; x=1779330319;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P1SGeIejERo1rp5IAxu3XCJqrbQpmZW3EKeLtz4XF1I=;
        b=nO+r8QSaL9SFCrds07wno65pFBQvc+yZ/08XXlH+btqFdgKBU42/+mI+XbkqcebyEr
         N+xMhVHPlaQto4yNcjup85+xrwyABY+V+ggTj3yJKo1rOnHcOwd8IO0zXpBb1bSz+KFK
         c+TYJncdrPKYvJYIgzqi9griMsCc9FfUT6CIlCDqSs4tJ1unwakuBrVtdLTe8xg7PnRv
         NALpe/lpjH7ekmw57WuL26SWAt0h8Ix0SceJSR2usHVs5GAm/eUc1EcimBJTPQWOz/K/
         mOiL/sCu+M0j3LYx+SeAJlnIL0VnCQzMdI+EUstZgaJOXcIoY0DpP2RBxUBHyLW3mvUN
         eupw==
X-Forwarded-Encrypted: i=1; AFNElJ/v+GCFbIrT1HTz9EScHVIa+l7xOEm6BVbOnN/eZjXNq3NaJjrTGk+oz3Bx9k1lfO0LtwaVGvWUFA==@kvack.org
X-Gm-Message-State: AOJu0YzsTUBnEJtHxdiJEmg2IdOJ7b5FAHpV5YROscUKA3+JcCBBunSI
	+Vw5VAPpvy3R/yLxrholtJykmrbO8AMtv9gcc6VvmWy2DzIQhMKrMIItHds2YN6wLy92ySS+T1o
	3q3ypDdeH9N8EaCBfebeuseGJoyL+8K92m6F20jQjGIcbi4OZSgLT
X-Gm-Gg: Acq92OGnzV80Ts14mjt6qKYXM1jWaomC6LCueA9kzvwjAAqJH8vPcZ4xmbo63bO1SeN
	lXKuceoy+2+pTq9qsg2jMEINOCV4+n4wmg4hP3hrNWVLHS8W6gBBeumvd+o4Stt1q+JNIakqsEO
	lnaRxbj3ae31LPqyepina17NPviDwDDxt5bNdZKjFyTBHKOGP0osa+eYPwGovL0tBunUCCjLE9t
	q2wnD3758pSLrMBfSKkwVZGTqvFF25rHqeNttcru6tiOBrH3K+2nhPP/xxoPHfzOuFllx51hGdI
	Par9dYjCp9eA9ehwK7tZ/v2wT9goTNJiC2+UeMycETXfdzsDVCbwxOQr/1hxTtO/BlPVhbwXAsr
	Rwc4BpnLDRpVAUhThUp0r7y732pUD8XCoAYjnJJmvkeUqLPpD2rDfMWOOM/94XhtiQ37xHGQOZK
	IZOR/+WCqSUt1L
X-Received: by 2002:a05:620a:1789:b0:8d5:e63d:95b5 with SMTP id af79cd13be357-910ae993de5mr301422985a.2.1778725518997;
        Wed, 13 May 2026 19:25:18 -0700 (PDT)
X-Received: by 2002:a05:620a:1789:b0:8d5:e63d:95b5 with SMTP id af79cd13be357-910ae993de5mr301420585a.2.1778725518461;
        Wed, 13 May 2026 19:25:18 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910baf2236fsm125067385a.20.2026.05.13.19.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 19:25:18 -0700 (PDT)
Message-ID: <7f16fe7d-8cd6-4a2e-80ec-045b9c02400d@redhat.com>
Date: Wed, 13 May 2026 22:25:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] drivers: dax: use pgtable_has_pmd_leaves()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <cb854ba26a4b8036706c6da5f6844f10f386087f.1777663129.git.luizcap@redhat.com>
 <2101c79a-e2ec-4e2f-8643-c68970036ef7@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <2101c79a-e2ec-4e2f-8643-c68970036ef7@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RP2rBg7aIuR-fJDPmHHBDuh0TGAj8SojZzOQxAyq7l8_1778725519
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6576180006
X-Stat-Signature: 38gwyoaumu1a7mb3sm7syepp991e3yjh
X-Rspam-User: 
X-HE-Tag: 1778725521-822957
X-HE-Meta: U2FsdGVkX18NL8LZdBH12kyMd3J+cSLHyEDGFYcc94Rl4iTpcAHUiTAdLYwBXQuFqKH6kleVhVNZvt0PDMHWWnhbFebNjIbaVAJR+zUpckuo7eee4E/EdjgIVlSlFWj/TMHxRVz5oA0uWzMR3ro8nVAQjbV3G6G2XwE8eDYWpnwKgYqDbL3N5AvclPYhidZyvfoYGY6uWZKgNpcf2Zm1poH3nWfOazQiwEhgQrRYbosEhPxsRLA1ronNm58YCMB6yN0HALQqR3Qk8B3lwnxQUci3tmTdGyqOvtqCsjiaJ1q8wzaBKumUuYCDfND0gIJE9MNganVkT29h7/F+7IiEAcNWv6acUM/FNK42If4WGf15S1LhiigGnuUVum26m57C7Guw6zfUUT+2eiPieGeXtR3ZWbR5EHvUdx1z6XA/krvOReqYJkOruy+GESrbDMGf0C1z3mXej6OxxGuaGK1LEAFsgCRVLb2aagr9okHYsHKcevNB+7mhwWWJiDBCWnfr5PKaWrl5UfhlgW+N3i1yBfMruZXX+MCcz5RlG0RKLvgzlD4oCPl2xNOqcfRFGnejxF2WlPpKaiSq8fHR4yGExnM3XF1tYWhnHSUYOby5F9DEI+GllKHhpHSfL5wEYUzqvMO2Yas/3iU75lHxxJlwbMgogzJdpkECjnbLcjG7Fdcc8Cp0DnY4stAkoDxp6ZbUDLy2xtrNkEp/7W6vBPxvKQpNOz9bW/Yj6q+9QTuYKvF2CvQlIiLto66T95eHJ7y3Q6UkM84xRGTZ1Ttg/WJrN6B0RA2L2zwNv6mLbn93WZUQJAFjpPKDi/UxUmsp2Lg9xCbbc6umdMdy6JRDaHjwhkMYx4nXiikcuSk+uWcvbmZFHKjnx53rKhJjpwHVa89w6C1cfrhzI8FSEs292+RHKaZXNzRI3kTlNBKu6rJPp9niZH0X7w+K/dVJstFAG/n9b/YtcgG7EhUmGLMbnzB
 /8fNuWQf
 ADa5smj4sOa/hfESfBDo/qIZ8jgCX0W3+J6UX8l1iKkRulKQfz8DCZMRgkGHJ1aVN5avfPVdLj5aF4/WS+vaybI7qTU6dlvJKsLF3BAfqF0AuySh8ZQJ2qinJrnqA+tmcjbKSSh6qaEvAoTkVHlVwhpvVErRzaiJIcSfSa8RGS8SNfgyCyi4bw9OSjbVwcSgaDIOuWyxySDo+VAXlGp3Iy2Fhk29FDgGzT/Ar4Th+9YoiuArMM1F0FqvPjWhivP85ksRxrjtHvN039uYCYGjuTWkra1u77sPR7njH7mEkVWnHfz0HZQwnCcfde0wqV4OUmlVj1pyM61oFvYJvkEudgP4mqUEs3E7X/pg88a9ln7RMOtI4N4q+D9lLPwLMejjlKN7fdkATKGwW5YU9hs+AiVVEFQn7nIQeq91kxZNLF8irbfV5321XjeDaz3ge7IkRsGnzLlZ+w+VUxSrtZovXv9EgfFlTueSTiIlGze4wdcRn0M+2H/W8L6E3czeF0g3TIa9pUdLwkVc3yX2Cv4cVCZKyzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-13 11:40, David Hildenbrand (Arm) wrote:
> On 5/1/26 21:18, Luiz Capitulino wrote:
>> dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
>> pages are supported, use pgtable_has_pmd_leaves() instead.
>>
>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   drivers/dax/dax-private.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
>> index 81e4af49e39c..35744ff6592a 100644
>> --- a/drivers/dax/dax-private.h
>> +++ b/drivers/dax/dax-private.h
>> @@ -123,7 +123,7 @@ static inline bool dax_align_valid(unsigned long align)
>>   {
>>   	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
>>   		return true;
>> -	if (align == PMD_SIZE && has_transparent_hugepage())
>> +	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
>>   		return true;
> 
> I think this code really depends on the implied CONFIG_TRANSPARENT_HUGEPAGE check.
> 
> For now, should we just keep saying that pgtable_has_pmd_leaves() implies
> CONFIG_TRANSPARENT_HUGEPAGE support?

Yes, my thinking is that any caller that wants to use PMD-sized pages
with THP, should check for CONFIG_TRANSPARENT_HUGEPAGE. The way we're
doing this in this series is to add a call to
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) when calling
pgtable_has_pmd_leaves() (the interesting thing is that some
has_transparent_hugepage() callers were doing it already) or rely on
already existing guards like this case.

Btw, in a previous conversation I suggested a wrapper for this case
(say pgtable_has_pmd_thp()) but you didn't like it :)

> 
> That would also e.g., make patch #4 easier.
> 


