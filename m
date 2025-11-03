Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D807CCFA04
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894348E0095; Mon,  3 Nov 2025 11:53:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8449A8E0057; Mon,  3 Nov 2025 11:53:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733718E0095; Mon,  3 Nov 2025 11:53:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0478E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:53:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0591F49B97
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:53:30 +0000 (UTC)
X-FDA: 84069891780.14.AA6324E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34F64140008
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:53:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqZuypYw;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762188808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBF6BigqDGHpLohygKEBk47de1/glpe+s9mh/hweIEs=;
	b=yscTkm3rtpD8lTPHIpNWszgo5+M2AOZmJpKyyRP4stihZX6YI0xV8435u+0mJebPhwzWlW
	yXea4ZFM3pjPLsph4taQjpDHHz85YUd1lEoG2jUr19EVaw1UkpYNdI9Ja7NoFOrNXpjeiB
	4AOYvI18VlLnAvO2zSKsMkLcGXA+QvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762188808; a=rsa-sha256;
	cv=none;
	b=qoQidrPSvVr9O23JyIfCH/Brd2DY1qnR4HYoBO3JatzSkgOq8fV/q4WHqD+wHZG2iFyRAr
	FVCxpeN+yMyfETtmsOf1wndbh0FpI2m3yOXQu2ceyV2PXZsHSsxM6RGjx2/hDWS89rL6RL
	TQGwW9IQaoYTyhhR/37oQlfFnjZMyl4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqZuypYw;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85F706013C;
	Mon,  3 Nov 2025 16:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54741C4CEE7;
	Mon,  3 Nov 2025 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188807;
	bh=ZkLFIz0vvjDeD2wJOSQTr9Q/o5xR6ot5EVcHo9EzqcM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SqZuypYw81+njFxxCaYsGfEQYd+kxBwe0YRsRX1hV1YGEqo96Hxh0inlgQEfMWrJn
	 6tlXxeQY1lRmbVuXqstLs5+OTEyM8aZZuuVQuvjau7xitn8ECPIez/gTYYXyUZS8u5
	 DPrfzr0DXatM368eGnaT8jMeWvQtaWucQ0DEy/NOeaWu8+mIez5c3j2BA2nmeqd6R8
	 9XqUzerFozM0V/f7uS02Xk4gapLylS2u/Y8kgHCV1cfDAjWq2DCRcLa54SsQHZuahi
	 mRFXsM2qTglPv8wsD8hMi8b4s6SlHNR5ovQ/F/9PxU3YZLgxUMEqACdk/9RerJs/mC
	 /MmH3dF3KIP0Q==
Message-ID: <e323f1f3-f543-4e81-af6b-243fcf9ba750@kernel.org>
Date: Mon, 3 Nov 2025 17:53:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] ARM: mm: support memory-failure
To: Xie Yuanbin <xieyuanbin1@huawei.com>, linux@armlinux.org.uk,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 rmk+kernel@armlinux.org.uk, ardb@kernel.org, nathan@kernel.org,
 ebiggers@kernel.org, arnd@arndb.de, rostedt@goodmis.org, kees@kernel.org,
 dave@vasilevsky.ca, peterz@infradead.org
Cc: will@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <9c0cd24c-559b-4550-9fc8-5dc4bcc20bf7@app.fastmail.com>
 <20250923041005.9831-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20250923041005.9831-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 34F64140008
X-Stat-Signature: dokzo8wbj5ewk6gzuszg6fggtx3s1ksx
X-HE-Tag: 1762188808-717625
X-HE-Meta: U2FsdGVkX1+qVQhx44oClDiJUy3ERMzIAzB8wEHIQbuVw+8M8In9AZ7f9CU8s7qutf7+xX8dqCGXblPxtxgy9hdkWCUbrbOBZFUmM31UNPdF1GuqdT873av5gLp4Tvwago6/kaAsJvf2rX1AI5gwuwfg9UYEJjJlMeTUGTopoioTTzGu6OsveCSIpxkap6slRxJs2KW+Q2BWxk1PvhITDuppheZMSWtFoLC5qrWMI7Ycaze9a0v/rJv/V5/WD2BHpGmPC9Lb8/zZTIc+WTTBQ/6w9C1Vl4pmcmbPaJU6f6Jka90inEfl37hMhWQE/cQ4fiel/s2/Udoxkru/F7Nvj5TK2f/Bf+zevYPbCo4k/7cUKy2/RzCYi7fVpO25MDgmKFNGXYGQnhZs5Igp9k5p9TN6VcTqo0bpV0Y7DCSUb7cU06C0mAJJhNu76mS9dCJakgpqLEl3OSIXMBAvw3yBQcRmiqCeTPGL14ip0ZxgppBsdJ6SX3HlD9fXpCYI4uv1CsypOScJ1G8/53RRzTYbUYc7uykuRc/+iJ92QjyDIXZl+EDlWONAw0DQWpCZjZRk12mOAE7UJ81hvUUooVkxJv9ttAF+HEWcDZm4E2xnMRNN1r1eFBzmJIlI+uNGD7vZ4ihFeTCvs99RuZ1UwlmfYca3QOueLO2fbIYmItC4mxOC4qy/3+wUZfTbOx2k4wYTnQZMGU8zscMxSf5uyxetXbVcgx3ik5Kw9BMz4310nrzXKQ96aR9Ji9OGTE18tSbNSENihdjo2QEL3G8QU5i7Q+2gUvwpRNdHpPLXsq8aXNM6P3NqMKBJPxi0QdO1+oM6x/ZATfodn4aTJgOtWZ+UfugSDCJUrgO4WzcUGoOhqPZ8eMaChY18Agp9kIWD2C883XA8X1RwjICEOcrmr2Ra5fRPmFaA0nBAfU/vDdG9pXssKxJa8OYnyQQu/Un/b0Ro9Gr0d6KuTVH9VjF1vMz
 7+R+xQz2
 QA0BbYFmbDM4ivV3weJZTdKvBE5utz20+jaiKfDrvDIWMq3CGISsUE1AXka9Mrh6YvZ7IVFo+XrtyQabAlzPnJeXnBE8P06Q/hk4J8DS7P+N8UazeN6SEz6g7wuNExkHuF48ZLQvkjRHmn7LQ/TwacfkEu2zbFPcfac2E4GDG50wZltwtaFSgNPgu3E6NwUrQGYuSs0vOc2aETyi95s/7fEYSWf49JGZ40yXaADHeN9AXFXFoluxPt80qD9zZfVZAs93Z83r7rNnDFGbKvxJaRxsVHTvRXpLOR39wjmVRV8zklAPMEdU2w9Nv4cmQ+R+W9Unr9+MyXixLaFdbB7DD0kdgzQERTUPV0km6sZsV33e0oOReVur1A82xim1vP9A2cP9R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 06:10, Xie Yuanbin wrote:
> Arnd Bergmann wrote:
>>>> It would be helpful to be more specific about what you
>>>> want to do with this.
>>>>
>>>> Are you working on a driver that would actually make use of
>>>> the exported interface?
>>>
>>> Thanks for your reply.
>>>
>>> Yes, In fact, we have developed a hardware component to detect DDR bit
>>> transitions (software does not sense the detection behavior). Once a bit
>>> transition is detected, an interrupt is reported to the CPU.
>>>
>>> On the software side, we have developed a driver module ko to register
>>> the interrupt callback to perform soft page offline to the corresponding
>>> physical pages.
>>>
>>> In fact, we will export `soft_offline_page` for ko to use (we can ensure
>>> that it is not called in the interrupt context), but I have looked at the
>>> code and found that `memory_failure_queue` and `memory_failure` can also
>>> be used, which are already exported.
>>
>> Ok
>>
>>>> I see only a very small number of
>>>> drivers that call memory_failure(), and none of them are
>>>> usable on Arm.
>>>
>>> I think that not all drivers are in the open source kernel code.
>>> As far as I know, there should be similar third-party drivers in other
>>> architectures that use memory-failure functions, like x86 or arm64.
>>> I am not a specialist in drivers, so if I have made any mistakes,
>>> please correct me.
>>
>> I'm not familiar with the memory-failure support, but this sounds
>> like something that is usually done with a drivers/edac/ driver.
>> There are many SoC specific drivers, including for 32-bit Arm
>> SoCs.
>>
>> Have you considered adding an EDAC driver first? I don't know
>> how the other platforms that have EDAC drivers handle failures,
>> but I would assume that either that subsystem already contains
>> functionality for taking pages offline,
> 
> I'm very sorry, I tried my best to do this,
> but it seems impossible to achieve.
> I am a kernel developer rathder than a driver developer. I have tried to
> communicate with driver developers, but open source is very difficult due
> to the involvement of proprietary hardware and algorithms.
> 
>> or this is something
>> that should be done in a way that works for all of them without
>> requiring an extra driver.
> 
> Yes, I think that the memory-failure feature should not be associated with
> specific architectures or drivers.
> 
> I have read the memory-failure's doc and code,
> and found the following features, which are user useable,
> are not associated with specific drivers:
> 
> 1. `/sys/devices/system/memory/soft_offline_page`:
> see https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-memory-page-offline
> 
> This interface only exists when CONFIG_MEMORY_HOTPLUG is enabled, but
> ARM cannot enable it.
> However, I have read the code and believe that it should not require a
> lot of effort to decouple these two, allowing the interface to exist
> even if mem-hotplug is disabled.

It's all about the /sys/devices/system/memory/ directory, which 
traditionally only made sense for memory hotplug. Well, still does to 
most degree.

Not sure whether some user space (chmem?) senses for 
/sys/devices/system/memory/ to detect memory hotplug capabilities.

But given soft_offline_page is a pure testing mechanism, I wouldn't be 
too concerned about that for now.

> 
> 2. The syscall madvise with `MADV_SOFT_OFFLINE/MADV_HWPOISON` flags:
> 
> According to the documentation, this interface is currently only used for
> testing. However, if the user program can map the specified physical
> address, it can actually be used for memory-failure.

It's mostly a testing-only interface. It could be used for other things, 
but really detecting MCE and handling it properly is kernel responsibility.

> 
> 3. The CONFIG_HWPOISON_INJECT which depends on CONFIG_MEMORY_FAILURE:
> see https://docs.kernel.org/mm/hwpoison.html
> 
> It seems to allow input of physical addresses and trigger memory-failure,
> but according to the doc, it seems to be used only for testing.

Right, all these interfaces are testing only.

> 
> 
> Additionally, I noticed that in the memory-failure doc
> https://docs.kernel.org/mm/hwpoison.html, it mentions that
> "The main target right now is KVM guests, but it works for all kinds of
> applications." This seems to confirm my speculation that the
> memory-failure feature should not be associated with specific
> architectures or drivers.

Can you go into more details which exact functionality in 
memory-failure.c you would be interested in using?

Only soft-offlining or also the other (possibly architecture-specific) 
handling?

-- 
Cheers

David

