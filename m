Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F101093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244976B0420; Thu, 19 Mar 2026 23:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5026B0421; Thu, 19 Mar 2026 23:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B8F6B042D; Thu, 19 Mar 2026 23:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 026E76B0420
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:05:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EEE113BACF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:05:35 +0000 (UTC)
X-FDA: 84564951030.12.565F318
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf18.hostedemail.com (Postfix) with ESMTP id 078141C000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:05:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uhw262NK;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773975934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGXqSdrjifGxcMcDlLu7ZKp792LHAscB7o5xF4jfDt0=;
	b=zNmprdyC+bQyov/fV91xA2lk1A8ICif2yi7+7YXHHAZ+QbH4pmypS73TpXjBTq9lKzlAYU
	lit7yCL26YRfYdEnCrvqJiCZRgNPMX0n389eGfIiUwm+ILA/RZIVsttq5AZX+N0mNmFI0y
	/COKb1sFrHr9rdVe8fIjHROoBGIfMCE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uhw262NK;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773975934; a=rsa-sha256;
	cv=none;
	b=zBxPBqukLTnbdRJsQzIhhrvX7PY4QKAwQ7uaTb9/n/3nivQ56zeEyC25M89xMdHP6T3eqC
	WVU0/COCxXo6WRnP45oi+7k6e13+L3qUJa6ePuNd7QqFFVuZotdmWbtJMtVWeh7Bl0+k4H
	DXEpSTWUU8dBZhJSfJgkDISKHpD0CiQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773975930; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VGXqSdrjifGxcMcDlLu7ZKp792LHAscB7o5xF4jfDt0=;
	b=uhw262NK6EdzoppId407nkloacTQw/p1dv1dwdz0cgOnRy3iLKUqTki0rzDX4c6ap5HoBQiD8iCtRB7NMWnM75Pgt4Du0cQMoa5C8dkDX1s3ytO4aU5yYLxnIFXftySSVW4JEeRNjbzioZ883Il6KJxwZLfUn/S8RoD1RD5/WFg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.KE0mj_1773975927;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.KE0mj_1773975927 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:05:28 +0800
Message-ID: <f7831736-f48f-4b5f-908d-4acda5829403@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:05:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: change to return bool for
 ptep_clear_flush_young()/clear_flush_young_ptes()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <5d24b34d8b7860dc2188408b3fa530193bcc5caa.1773890510.git.baolin.wang@linux.alibaba.com>
 <46390a7c-164c-4ffb-a1b2-fad21e3829df@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <46390a7c-164c-4ffb-a1b2-fad21e3829df@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7y4fcuz6fmxb4puyk3xf1kozkweeskin
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 078141C000C
X-HE-Tag: 1773975932-960101
X-HE-Meta: U2FsdGVkX18GNegzO5v/90cWTXdWb1ABOvITQLRq/ZgRG7A/+0mJsfUMkrsNqiS4CsRYCJ6lAuQoH8ZXnO6BZEJYqyZ5kgfLhnOF4GgCZ+puMe8y+Jlkfk+VYt9iaHRxNVFBzLxfkQBVixcL3g75gESAgCfT1v+4Ij7qcYKogI/KJ165A6Y55M1qfzTVKYcrj1h8ruxl/alJydSENvZsmJqUKq4pcIBiHP+P4oRA6QvZkeamwMeUltR0LT/n2E7mFl5CWr9N3koqi0qsE/26csyUUX3DLd+2d6YIId+xi2he7bK2taPW0g9H6NxMwtqyuL+Rg7f12ihCZV06bHLLSubosG8mbi8m5X/8SD2/LadD/d+tWDhfidtgeiLk4YZdnqrl3GvdhecjMVAyAfAyLl8apIslCatKIbQI95BNRwYQWA+L95gfSTkiezBw4u2N8i/wfurcHQ7oCAydsduwP8BWMR6gpB2af/hxuU3eDcshZLTl6DZVsa1ycbvTbqP9C9/ZCnshpLtOoQ8Gcrry0Xg1rJiHVqv+wydFXPzN/E9BzUqkCeh50nmYOMl6/4UJ7jRkXunq2ulhlPn1KsQZ1O9HPo5goMgMgI0MloGX2MDOXeIW/Z/ORHDjJgQkJd0liusoM9bYfRgo5nRG54ayIAv3nJPamoI5M4z9nW75x6JZchy+mdeKtDQJr3V2py9sGHlHQASeh1J9W489Cv7sgpoD5lgfhwsPdcCYpTbWHSo8b/iA3yyNNMNM1GCuUcIhilMwKQ4ajxTx5Jz6lmR5wQqXbgdZFVQCw1H6VZYI/hhQg9e8YjPwGEUhMmBtSf8C1W3LSS9F9dU5XJsr+rM5edfRTY6935DW9cZbo+/Vi64rwEnbZXXu0xgmUrUyv4BZoCp3tt7ms/Zu/mizh7V6umFgZE01D85obC+r8LMN6jBaI/cvBJP3tWdxWw0ZrrYcwGXdRhCk4vD9+Ig5wvi
 VsIjkrqy
 O+sg2p1L2TPqQg+7cO8per2TFa1qPHzEcAJ5a/yL4BAN7cCGWDxVxtRyKsx2AsiHq8nyYaWC6YKWW6D5tO6aD/+HfOBkFD5xjmlFTcvnv+PVM9jv3fNzyuzdlefE62PpnB+1QLIRVWI9M+MSKMzSJKUQwyMyT4JAxu3Oqeyka7kT8g5L/Im4ckEAeeFHyk3/pNHWkDh8qWB7IHNmBkWv6Ksw3BlADYsd3T+FhNgzQX3wGPf6baJnSBgNlsYLrVS3DlOOCnlwgixE8/IsJetjaJStQgU2rIBl+SrVAEra2zqe24O5Vew7x0oP6sHuib0vkVMgjqEG2rbMc8N7XrxAsRmUaJsa6w9ppbPCStQb9Z8QR02v3psiS9nnFywVjW+/AV+ECxh3nZtdbrD4zmZs2Txidsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 7:30 PM, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 11:24:01AM +0800, Baolin Wang wrote:
>> The ptep_clear_flush_young() and clear_flush_young_ptes() are used to clear
>> the young flag and flush the TLB, returning whether the young flag was set.
>> Change the return type to bool to make the intention clearer.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Couple nits but LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks.

>> ---
>>   arch/arm64/include/asm/pgtable.h             | 15 +++++++--------
>>   arch/arm64/mm/contpte.c                      |  4 ++--
>>   arch/parisc/include/asm/pgtable.h            |  2 +-
>>   arch/parisc/kernel/cache.c                   |  8 ++++----
>>   arch/powerpc/include/asm/nohash/64/pgtable.h |  2 +-
>>   arch/riscv/include/asm/pgtable.h             |  4 ++--
>>   arch/s390/include/asm/pgtable.h              |  4 ++--
>>   arch/x86/include/asm/pgtable.h               |  4 ++--
>>   arch/x86/mm/pgtable.c                        |  4 ++--
>>   include/linux/pgtable.h                      |  8 ++++----
>>   mm/pgtable-generic.c                         |  7 ++++---
>>   11 files changed, 31 insertions(+), 31 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 8c651695204c..393a9d1873f6 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1299,10 +1299,10 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
>>   	return pte_young(pte);
>>   }
>>
>> -static inline int __ptep_clear_flush_young(struct vm_area_struct *vma,
>> -					 unsigned long address, pte_t *ptep)
>> +static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
>> +					    unsigned long address, pte_t *ptep)
> 
> I mean this is subjective stuff but can we just put 2nd line 2 tabs indented
> underneath? Makes it easier for changes like this to not propagate.
> 
> Same comment for all of these!

I usually use 2 tabs for indentation in the mm subsystem, but for other 
subsystems, I try to follow the existing style since I'm unsure of other 
maintainers' preferences:)

Anyway, I can do this if no other objections.

