Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B49E5CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 06:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCF86B0005; Thu,  4 Jun 2026 02:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D826B0088; Thu,  4 Jun 2026 02:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81BB6B008A; Thu,  4 Jun 2026 02:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4DD16B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:42:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 458A71C1EA2
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:42:46 +0000 (UTC)
X-FDA: 84841287132.25.786A01D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86538100004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:42:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+50t1Pg;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780555364;
	b=BZpniskfyTBx9ErJbiCn2Kh8wwvtuEY9lwr3gHskYa4zXqCG1pKyZ7bw0TBjki9wlNPR20
	rs3U+ORcEfyWi4QOyIPX4Q0OfrhlsF+GBgk1jwYhxSUQFYCdS+BcnLH8bcFoQgS9P3czcE
	Ff8TVc+08LKsV/kpC6zpUlzkClyNQLY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+50t1Pg;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780555364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMclXx+kWblJiogbVLMoBZ0CpsHeA61XhaKG9JaQqTk=;
	b=sIu32a7mJXCi30LQxNgua/vQSWpyhPQbMrdnlU/i3zxRdBZiK3MiT1i305Vs1AeeP41/4+
	Z3SBBPNvDkOWOl1+2yVWcCKS3gpN/Ec+6prv2931DBoEFun4Plqi4ulH/NNoWMNnbZbZNF
	0nHom2MjYLrmAq3zpp10+cyK1Txqzes=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F22C56014B;
	Thu,  4 Jun 2026 06:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7C21F00893;
	Thu,  4 Jun 2026 06:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780555363;
	bh=VMclXx+kWblJiogbVLMoBZ0CpsHeA61XhaKG9JaQqTk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e+50t1PgrCaMeZTZ8x/mxlH+D9K1C/NiPDgd8+IEPFh1Xg+SWnGrLXfEkOZjRdXHg
	 wa1EifUUzDl0FTIgUiFcGKzO8gyO77/Dl72Tl25+W7zdTK2GlotYf6NM1cjjjkhUNh
	 R6HSojOTtyva1iMrorbeCH6fZwr2rBECWy83uLN0phG3f4/6O1rhzZWnsgNakypP/r
	 pbg49MC/uk7G9KeAt9skEVkaDX2lafJBXbgyiwKVenn6+0sSWfE9dzalY2iNwngkr3
	 VIueFY5vWLxVmMP5ak5O75/qnzC4Q8z2vVSs3IxxypRNUWVlnsQDnquD1+vnNpNd2a
	 bSdyydBce3O7g==
Message-ID: <4de75e51-025c-4926-871a-4b9da479cefa@kernel.org>
Date: Thu, 4 Jun 2026 08:42:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
To: Xie Yuanbin <xieyuanbin1@huawei.com>, qiuxu.zhuo@intel.com, bp@alien8.de,
 akpm@linux-foundation.org, rostedt@goodmis.org, linmiaohe@huawei.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 mchehab+huawei@kernel.org, tony.luck@intel.com,
 torvalds@linux-foundation.org, yi1.lai@intel.com
References: <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
 <20260604014629.3144-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260604014629.3144-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 86538100004
X-Stat-Signature: 5crsxn9zyi3rkyyqe4d5zxqhpb5d5au6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780555364-90245
X-HE-Meta: U2FsdGVkX19VmVdW7e159ymlub5Hdn5sJAXmLioZaB++S7086mKwDytlf9ZWp2jCuQWlKcnVQXfcliYZ68ZXHGwlNQKTHCNkCSWH6QqJdvfis3WTnrnJz5+Fw9zoISoG3L+ziLP3Ngdy+dIQLT5sseU+VH+tSEvloPGWhqOVVu2ahbMVZEGl8mUSAAM2DB39pF5AdWN4G+fJbZ8XmekhANyAe5k35SC8aBdzZmfo6EB3mQ6deG394sY6WLcTAOkqZ+nG5CmnHFsT0QvVdT/dR87hVe3JsFmqj0kBCcvCDL/vPY8HCzlerFs0RTqtUz6AX5BiVjN7OH71GrPNNUqdKowbIGrj2OpqZEm1ZM+dsI5V+3MKr0+VpEWiHa8A570UZYfee5L4Lkmp/yJwh2wiB7QdLV5zUGdlsShy1wEx7m1k72Tsth2PcEr+PejdU1cLiKMaHRkd/KcgvrHhI3gb2A7ELAOvHH7U4ZnDGZY7d3E+hRH2xrzMsScp9/vNMH5h1X6XHvakGAl6zXSiWYyENxCw0i3hGA8jdjIUqUpUXV0RePIbvDJP2sh/N0qVNk6IzFe1Yzng/0TVJmsjvCNwtbs1PZbHMk5PuhvCO4wyI6puYkYLiP8PJ0NvXx0ud9f8slftCl3t3rFuU+k32Lq6uZNBbc2aKdevwIwUel9yLpSqXgh5TPMJjg+s8tG9LlhMyqsLHiWVzQv6k13T23YeLWp9WDfjflOzAa5QqM9tc4mXMq0B5zwg1QLCzWXKo+bQu0Xqd2Yjcs0F2fOPLqhy0hNlDb0b9cYP7uauqBQj7ezU/1W4ZmHXNXYUyjUc/IPzXoVHWxI4HvVNJcYWg/Ijfd/TkDNIiO7U+zccxA22Rpg+90/4G+tFCMtpEPMdj9a+xcOBYbOkSdBCZHziddzRfJqcshk1YYcAm0lRCg7SQHv1NWVmZc5vmg9lZYN1nPFRhPNe9b4GJqym6OgLZCV
 D7WoWbFB
 gMwhgEoWLUcGANaFMI2ypeipJQt6s3ru8zNUmxritbVKHjEZTQ9LA/nmWzhKU8zj9Ag2/5FuLn6tuyNL5vIo2Z3dtZ4rIuvgybQ/WK7n1pxNkQpOnshbNaTLL6WxlAPXOFKdToc1ZrMKK7b3gWsTwuz7Q/ERxO2JhcyAYhn1VwYygAxNUZEhlpE1p4550JVdS2sdtF0nrHuX8xMkCQoZEwl0Nayty8OkdsjBzuaDoavs91DVmxM8q5wIMZHXGQpfRO87tsLgy7FcmEOJagKjRNdZBQIwp9P6R2cQK6lrvgnvDL/YeGEHJ3Vj5lwtQeK6GRDVqu8m/uXEJTodSMl+LBKV8mrKORc3G9zviLsP7B0EHYzMAcxFU1gEjwnLj8AukIqTQxFdiTkEkUW2NfA8QnnR237TByOcWhPFg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 03:46, Xie Yuanbin wrote:
> On Wed, 3 Jun 2026 21:13:30 +0200, David Hildenbrand (Arm) wrote:
>> Would the following be sufficient to avoid a full revert and the dependency on CONFIG_RAS?
>>
>> diff --git a/include/trace/events/memory-failure.h b/include/trace/events/memory-failure.h
>> index aa57cc8f896b..c46b17602578 100644
>> --- a/include/trace/events/memory-failure.h
>> +++ b/include/trace/events/memory-failure.h
>> @@ -1,6 +1,7 @@
>>  /* SPDX-License-Identifier: GPL-2.0 */
>>  #undef TRACE_SYSTEM
>> -#define TRACE_SYSTEM memory_failure
>> +/* Some user space relies on ras/memory_failure_event */
>> +#define TRACE_SYSTEM ras
>>  #define TRACE_INCLUDE_FILE memory-failure
>>
>>  #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)
> 
> Yes, it should be. In fact, when I sent the V2 patch, I had already
> considered this issue, and that's exactly what I did:
> Link: https://lore.kernel.org/20251104072306.100738-3-xieyuanbin1@huawei.com
> 
> However, David Hildenbrand advised me at that time to completely
> remove the dependence on RAS:
> Link: https://lore.kernel.org/01b44e0f-ea2e-406f-9f65-b698b5504f42@kernel.org

Yeah, if only I had known that we would break user space by changing trace
events ... now we know :)

Do you have capacity to send a fix?

-- 
Cheers,

David

