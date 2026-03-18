Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB2C1077609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B978E6B02E1; Wed, 18 Mar 2026 14:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26806B02E2; Wed, 18 Mar 2026 14:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8D66B02E3; Wed, 18 Mar 2026 14:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1ED6B02E1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:59:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CC6B1B6CA8
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:59:45 +0000 (UTC)
X-FDA: 84560097930.23.5C5D0BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id D386720003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:59:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B8XasKqU;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773860383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fuwby0KHsweEWRKxCnMlD+TvTgOd6VacPqQH1y0xBQ=;
	b=7kY8PMjokJeTyUs98JnYgt6EruYUtgGC3lj8Tjeb20TsaE2iBhP3mFYtOZjGHlmUB++Vmo
	xb73adDtARmF+jVg5GgAnnzmBN+CRTDYA693nTS67KsMPeTBXzFYYt8BpCR2NTqR7ecQ2+
	6jMhCxqknb49orA6sknE/c62IAxVowg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B8XasKqU;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773860383; a=rsa-sha256;
	cv=none;
	b=7+5t+cHtZig0lA4/aAQ5QUYOX4pN0JttkmFqt05I5K/7Ha/ag3GegKgMHbLDLlOj67hmIY
	MEWtqKOAAEFjoPbsE59d/1NmIzToPAkDJRpCPuyvYRNUnkZDQUuktIV/DhQokgsIzPf1PK
	uoTNsvTjDYfpDQs9a/xcr6+pX9N0lzM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773860382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8fuwby0KHsweEWRKxCnMlD+TvTgOd6VacPqQH1y0xBQ=;
	b=B8XasKqUYkPxlinzpE9EKUwbeWnJCc1JYWzRkfyvm3AfpLuqrovCaA89HmrZxPPC2KDXVw
	AoS1zcjpGCmoL0RhJwYr5jSQw/3Ydg1q1wUAIXwhEIJAmgl/Kb4B9cDBFHkwTbfDyf6sFH
	cOCtTKBt3sfnWZBiTEtr90Ec7lUNmCY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-TkI6z8T9NoumNuCvABjUNg-1; Wed, 18 Mar 2026 14:59:40 -0400
X-MC-Unique: TkI6z8T9NoumNuCvABjUNg-1
X-Mimecast-MFC-AGG-ID: TkI6z8T9NoumNuCvABjUNg_1773860380
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-899e89bf366so21344986d6.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773860380; x=1774465180;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8fuwby0KHsweEWRKxCnMlD+TvTgOd6VacPqQH1y0xBQ=;
        b=nR8qF83HxGTtp60+pzhf0MoWIAa465zop1LhbjVfv7ENJdWi5rLGNcDmUUbRCH6Gcr
         gmMFDFanBvs8x6UdcYOg5Tta1JYRN46chjgqSaeEHcMNaeDiXZSgnja8Y6wpPVjlNxWT
         DJiaoOCNi/ZvkuUbxCLBvQyM4V9nP1fJH7GsDElfkw22K1beJpBsDCvnsiTRd8NVA1Ln
         N3KR6Pq8VbfibY8PPhydSdjmcnTlr/TxgC6RRHVW4KxKSLqfQjrEFQLyeMJrreZHZE78
         ooIsIuB/qkMH4EHZ2Cba2nhrv+GlicAMLPOfIKCt7VaJFPW9leL9WrOPRxuUBNLzo4uf
         y3cA==
X-Forwarded-Encrypted: i=1; AJvYcCXS35/94lCGgeSsBkheJwlfsWBhfWGDizGa3CrXr4YudajZOfMni/zKRNvOBXULM9McH51ctV0LYQ==@kvack.org
X-Gm-Message-State: AOJu0Yzoc7PJCb+aZH0Q0/w0pWaCbrossRHCnHwGtiKEJcojFeASHZTz
	/yqt5KQECYc4E9m6QQfeDqIcGU/SIgaA5bHi67xghE7ll9SdFU99pdhChys04WFsP8GGL5D5v7d
	tYJrx9OMFhrc9V63Ff1XZNUpct1IA6ChTUqKHNI+GKH1vRirdljJF
X-Gm-Gg: ATEYQzzoUVUPQtevR6dvng6at9LSw4bLhOqjMl6ddyztQ/3vxwmmhimvxJQJtKCrctH
	fYZ/wDaG+kAyyo+2XOzMoau3ycFsgi7c/aU0yjs5CiISlvEtMazcfumC6wzl2HjkB+pBnfIHVo1
	54J4Y/EEgOZ9s4IESsIjYeS2pGwsgNM840g0XhfZBZvSN/oGP7pA4/uQFJFHyKepiC3O0amKm7y
	23pZWD005ZrUmOmivuyrxl2kWHMsRtEuUMUfFovNEeIoMEvX63jsKkEp/cHJ6UXDHjLzhAglPPT
	l99bHQVte3ww1mz56GYGSdayHb7JOy7hu02dmTARzl3ZgRIgGE2jrE0MpUEk9HpBL9oYSr21Hot
	EV/GMUqYdXbhIrRZ6UJbEtiMmc3wwgHk0MPMUp+42DAu35V2u/zVzkjFt7tRW
X-Received: by 2002:a0c:f089:0:b0:89c:59d0:b056 with SMTP id 6a1803df08f44-89c6b5ca535mr54558126d6.30.1773860380037;
        Wed, 18 Mar 2026 11:59:40 -0700 (PDT)
X-Received: by 2002:a0c:f089:0:b0:89c:59d0:b056 with SMTP id 6a1803df08f44-89c6b5ca535mr54557206d6.30.1773860379310;
        Wed, 18 Mar 2026 11:59:39 -0700 (PDT)
Received: from [192.168.10.111] (c-76-154-99-94.hsd1.co.comcast.net. [76.154.99.94])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b9cea7bsm31502716d6.27.2026.03.18.11.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 11:59:38 -0700 (PDT)
Message-ID: <a9ddfa7b-5ee4-4c68-bac0-8a0c6c355bf7@redhat.com>
Date: Wed, 18 Mar 2026 12:59:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 11/13] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, david@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032631.234234-1-npache@redhat.com>
 <d8028d32-4791-4993-aae3-66506bf6d1bd@lucifer.local>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <d8028d32-4791-4993-aae3-66506bf6d1bd@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NEdmt8L_wLDdTnOQAvT1q2iJCAsMfXqHsoRfCO9miaE_1773860380
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D386720003
X-Stat-Signature: zwx43ry7jeossok1hiby9m4ixowg4hp4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773860382-844969
X-HE-Meta: U2FsdGVkX18IKL28DzmY1DNGx+WR37ayISLHhl06eoIt6U5YE266o+Y6pCG/zynwk89s0/LX5XbWiRR5iN3lifLoowTkeekz3DNRsRQ2j6AfxkBSfjcK8pF9/y03ycCUUkg10JLZzKCTJbAVGwGvH0VeJTcXQOzl576iPH3R/554e//7Hhd5iWEicoCPFcmy5Wvr7dkgMIzcV7uSX7QxvQEzdZD8DA7oyY2E7jRzackaCc62B7G/Z3F9UwV4VwqtT3SsP583DipX4n9/UGvk1bTpTEqUr0hP1GyOelXVEuQ5aUdYla7cKDZpv1nsthsjOirhoIs4TlWXZaNnpu2fbb4SClwUIi5NSWWjlqFrhykS5ICHAPSVZNCioD/MEN7dVQ4FX5xpwUK/QiWgIPg0JL7sI0PUrItYzU779G2BjXSS8wRmdLEY1WD2tN8PtppacfGDd8TXQgQbbvk0e7AhveUyhxftHGGiPlj6NX+qQHmC55Kj1/aTWAV1YyRgAC7FIycjY58bSbOAwzXlHfcL51Hma8X9+e3QxPuM9ruDahqyGVimMcVP1Det8Yfv0rnSsYP9U4NfmjbjHfhRzyq8m89sw2woV5lr3AafyvoNHE3gwxX+PR0iVVu6ZpJzlmpelFJAix4mbta347oIJJjw/PvpZBsd+QqL9eaLrCu23guOT/I6bAuMRzVnlAS7XtChJusmChnhda9b945mGFlSzmqzV9Gs9646PxEFj1MUziMq9eMJZio6VNOiXB4/nMnNMIn4GCmIl9ea7iql1OXiKihg9dl07JHS8VNFYuL4j7ak0ZUJwVu8YB74nORd3p7NzO0DNpYwemJoVOiKAKBVxVnmBVJ8EUVv89OX6+9VfU68OIqTutpQYhio/zDgfc5eh4+ZZ7VgGBBl5o3E+ruadwUuJiotgGbZ8BNwXQCxd54Q3w3TFrK5FOV3hC364sM8urocbb45p8HljOL1DHZ
 Xpyd9WP8
 cBvhOhNIaFBJKNe95cabrFkfY9qMwKC5s9ow3yXv5PHSPgZs9yjao0pd5yUnE+7S5HXhjcK7VgOama3CljJuocsHQfsTAmkHgHzvkqQpcFh5ZLuu8k51/QJrRG4Xwa98m+4ME/e/QGrqMWR+cNJg6G47j70O7Rtqg6u4x25Wn8Lf2KUwHB7Z43YfZR2ViQdwVR8HnqyxAizDd0pdvEcbKbgLozvNYKMe1VrgoJlVUoLpGUFQPUp5YeEG0nQMLzhzqI4fOQfIB3yw5lE5UZGQFPxLr8W9pJNLEIsiFy/GqT18xx4N1duB4eldy5v5ykn/Uykpdn3nb6P1E+ysYAC2R1wHWOlioqNAv6GH9u34xz3OsmhcOAFIBqWDutS2C3dKCinxarTUq0KcBoGZ43NH5uOBJJUf/lgjDb73aPRq1KbAzCDM7HRBr9NztcP5EKMQ6xy034xmPn+U86mqAGhOwpfJtpXqA+8xEbUMaMAcnpK0m0yvNpvhgwiFKuCtveJR81/Td5ji96a86Hb34BR0OfCi7XHq4RMjkpsPv++JcZCFqraY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/17/26 4:35 AM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Feb 25, 2026 at 08:26:31PM -0700, Nico Pache wrote:
>> There are cases where, if an attempted collapse fails, all subsequent
>> orders are guaranteed to also fail. Avoid these collapse attempts by
>> bailing out early.
>>
>> Signed-off-by: Nico Pache <npache@redhat.com>
> 
> With David's concern addressed:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
>> ---
>>  mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1c3711ed4513..388d3f2537e2 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1492,9 +1492,42 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>>  			ret = collapse_huge_page(mm, collapse_address, referenced,
>>  						 unmapped, cc, mmap_locked,
>>  						 order);
>> -			if (ret == SCAN_SUCCEED) {
>> +
>> +			switch (ret) {
>> +			/* Cases were we continue to next collapse candidate */
>> +			case SCAN_SUCCEED:
>>  				collapsed += nr_pte_entries;
>> +				fallthrough;
>> +			case SCAN_PTE_MAPPED_HUGEPAGE:
>>  				continue;
>> +			/* Cases were lower orders might still succeed */
>> +			case SCAN_LACK_REFERENCED_PAGE:
>> +			case SCAN_EXCEED_NONE_PTE:
>> +			case SCAN_EXCEED_SWAP_PTE:
>> +			case SCAN_EXCEED_SHARED_PTE:
>> +			case SCAN_PAGE_LOCK:
>> +			case SCAN_PAGE_COUNT:
>> +			case SCAN_PAGE_LRU:
>> +			case SCAN_PAGE_NULL:
>> +			case SCAN_DEL_PAGE_LRU:
>> +			case SCAN_PTE_NON_PRESENT:
>> +			case SCAN_PTE_UFFD_WP:
>> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
>> +				goto next_order;
>> +			/* Cases were no further collapse is possible */
>> +			case SCAN_CGROUP_CHARGE_FAIL:
>> +			case SCAN_COPY_MC:
>> +			case SCAN_ADDRESS_RANGE:
>> +			case SCAN_NO_PTE_TABLE:
>> +			case SCAN_ANY_PROCESS:
>> +			case SCAN_VMA_NULL:
>> +			case SCAN_VMA_CHECK:
>> +			case SCAN_SCAN_ABORT:
>> +			case SCAN_PAGE_ANON:
>> +			case SCAN_PMD_MAPPED:
>> +			case SCAN_FAIL:
>> +			default:
> 
> Agree with david, let's spell them out please :)

I believe David is arguing for the opposite. To drop all these spelt out cases
and just leave the default case.

@david is that correct or did I misunderstand that.

-- Nico

> 
>> +				return collapsed;
>>  			}
>>  		}
>>
>> --
>> 2.53.0
>>
> 


