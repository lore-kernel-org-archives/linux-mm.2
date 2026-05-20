Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 161ACCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 03:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367156B0005; Tue, 19 May 2026 23:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318666B0088; Tue, 19 May 2026 23:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254A56B008A; Tue, 19 May 2026 23:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14B356B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:41:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8DA512014B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:40:59 +0000 (UTC)
X-FDA: 84786397038.16.5C949F2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4CCDE100003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:40:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nXAi6eGp;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779248458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixdAPYALMBfjHtlMi5593ygrQL5Cn1/ET3MN42moESc=;
	b=afAN0FYCbKVsyg5P4+8QVzJ0zkfrxiss/R0uhxlHeeWrRTaPUl6id/1TtikugMh+hf6MQe
	5gvdVqTZV7de2f1pHYPmRYeUnfhcHmU2gw/5kqrrs3ByN5xruB/oSJ0OUd3SN1EPFFZi0M
	PrwAWwRMlcyLTGbjKjIVGeQ3g0wqirc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nXAi6eGp;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779248458; a=rsa-sha256;
	cv=none;
	b=2UptAfO5dycER6Pu1PCTOEJyr0Te60I6S4BMgi8jBQ4uuDbXrnzIy5Ymy34xnNm+JdCX+4
	LJFvVhnjITteAX5b3gvcD0DbtkKJGy/a1gR7JiOJqocGNj8aSk7oPTSvjJi5HRMjNhnYZC
	TYMAPMuDGS/fV4McxqP0T3BQ5OypQjE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 572F83552;
	Tue, 19 May 2026 20:40:50 -0700 (PDT)
Received: from [10.164.148.41] (MacBook-Pro.blr.arm.com [10.164.148.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A84D63F632;
	Tue, 19 May 2026 20:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779248455; bh=aQd+PCw8b7BF4wIqmSCt8liHy0QTsX/ju76AwR0LZ7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nXAi6eGpG49BwLeuZ5K6Iu0DOJ6cwT5ftm/3BWj22C9BrV1ap/IfSGeyezvS3cDRW
	 TXBdq5BCMl+lEMT/38n3Hi0xibEuYnHJERTuEPRjQKP5zhktyLbxBXb/kNeM22vv88
	 WqrAGgPoR2snNJnGtPvPu+ceCfzNZtkC177zOuBA=
Message-ID: <e1aaa6a8-8b35-4fea-b2d7-b994064cc4db@arm.com>
Date: Wed, 20 May 2026 09:10:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Andrew Morton <akpm@linux-foundation.org>,
 Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com,
 baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
 Wen Jiang <jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260519131738.11a78ba88e1be28ba5cb26eb@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260519131738.11a78ba88e1be28ba5cb26eb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CCDE100003
X-Rspam-User: 
X-Stat-Signature: 8hcj5nykkruu8e5kpj1atw86g4tsu7mf
X-HE-Tag: 1779248456-482946
X-HE-Meta: U2FsdGVkX19uOVJqperHyEHz0X6UOARkmEQTREe5XBDUdTuqgWE+cKBCFlk7DBAjMHAxatjYPeo3GNE+IjFZeTmz7QoV+O0Mk0QEiCbZwEG6uosUmUEvS7ZKaKDX7fmVt0P4L/wTYR61IZDZHms6vUxccCM0QBb3s8KUhzpg410YJqOl+xuC94bZY/2vIoU5NsIPMSN9d7N80ikYS/3mFNWw+dECjKsqjps23ia5aHLSWRLoTDuM74aA4zAPOqvl57krS/QEKqTt4ztKqQBJ5oAQVwA/VN/yse7F8mkbaw3g2G1rywhZts7iYPVWhW5y0ELbQSEpkimifD3wB02mmoqRRlZ2OTD3Z6y0Xlcfi8RBv71TjomoSn4uadDbGfKirmNCtDGtb09PLm9+8N6zsYXXykCgle2u7YM1QcG8Nm9EE/e57tdnDcP+16K68y1tL6mlmY2Bk5qOeZZGbCRPs3e7yky2dcnLhFJER2QdNiNHDeSl8uS07bA3IRP0AODcThII5ZKkf+nEeUof4mK5omAMLzGSEPz3GVUrtNoZ5SA4U/gj5ZhUGZ4awjLmL9Vj3FBMO9Z1bGINIRXwbwMXfy1Xqo4Ue2zzc+EzvI/0AJhG8rcmva5NMLTCkTb0Q3RPMAIdhdcXmJOr1OhM7Zwg+44VDvUbyogF1fduyVQF9nU4C3dCwF1PoUf+oi1rxyoSlk3MZU48Ebw37YK5Qncjs2QUdZ38lBmlQ1Fk9NX3jfcm9BkMz4Uf6FoGCRglI0VnXyodNBqloJlaujzD1uvnLrVjYogUNI8AIPSyQT2zwv7yQOZ0rA1WKNQj4a9XSdAVVhkTC3pt7wkIFd6wbODPWdEIMrSOr1UxlxwKFmeUv9RRX3xt3hEkF/TyNe7BTuGmfFBkF2Jf4ucjyaPiLl5G2vJSouAYBdIVnChDfbPXtvoeETDdMscSvJ+3PAC6+mxxzXFxKo9p+lkyLwGCe3F
 EBtObVcs
 A85WRpwhSpMahmLMdzQaYKldHupILpchscTqmLxqekTm5eH0QBFDlLcx0qhpJNxqM0KDrHSQCuAeiw0e5bTt27B+/hSRymu2Qb2+B+SJ+4e8HmTMA3zgbcgVtSTq91zRMu0ydWM72CQ/G4+annUsM7kw8B0IEt9lzJyl8j2AGEh2+ZuIE8CCvv+dauwPIagqPyhOBQB3s6RF1bxrDnQMg4MOTxi1RfK5kRUgYAzMSWmXIntJklCnkgK6noe7EWxr7ckFZ9ynadJl++MjnpK66jIik3KyAKyp6Q7btyQzDqOe/HCOfOsLoT5o5cr+apaEXkhp4Fgk4J3w7mdaigDJ86gpNv56KHjjAjTy1LM2lHTe23/DGjR6U53lpgonu5ykkOSAgBB0TXZo7V0XY++ntjkykggQuTpWQvZiXhEW7Xmu2q97Ak67jDx6mnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/05/26 1:47 am, Andrew Morton wrote:
> On Thu, 14 May 2026 17:41:01 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> 
>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
>> is physically fully or partially contiguous.
>>
>> ...
>>
>> On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
>> the performance CPUfreq policy enabled, benchmark results:
>>
>> * ioremap(1 MB): 1.35× faster (3407 ns -> 2526 ns)
>> * vmalloc(1 MB) mapping time (excluding allocation) with
>>   VM_ALLOW_HUGE_VMAP: 1.42× faster (5.00 us -> 3.53us)
>> * vmap(100MB) with order-8 pages: 8.3× faster (1235 us -> 149 us)
> 
> Nice.
> 
> AI review found a bunch of things to ask about:
> 	https://sashiko.dev/#/patchset/20260514094108.2016201-1-jiangwen6@xiaomi.com
> 
> It doesn't appear that you'll be getting any more review on this
> series, so please check the above questions and resend?

I have to review this but struggling to find time right now. So please
don't wait for me : )
> 


