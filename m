Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D197CC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 09:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5EE6B0089; Fri, 25 Jul 2025 05:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59DCA6B008A; Fri, 25 Jul 2025 05:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA316B008C; Fri, 25 Jul 2025 05:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F71F6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:17:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD9EDBABB1
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:17:52 +0000 (UTC)
X-FDA: 83702234784.03.3B0C03A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D07F1C000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:17:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=E7YyVHUg;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753435070; a=rsa-sha256;
	cv=none;
	b=3mNWOesWUs8SuyauD2Itf4hO4LG4q6TNY91N/ZsnF6+AsPHKn7BRNEBrfWm9wSi/y9ximb
	U9gWxRwx8TP/frCssK376HVU7K9OdAxgcG1HiWxaiMpW6K9exV87Uh1zQnSyujvefJEYOM
	ed57C9nfzDo12R6An/tWi6QC/bmX7E0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=E7YyVHUg;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753435070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMigFR4GTYexBo6+Jura8Z+QLDddAiinvpERM0QX96M=;
	b=d3sJYQOZh9fgrJzwg/TR4+BlbK2N9XLzv/GWIPb2zBH9Ax+Qo6k+68ILWIJMdDqlW06myN
	1uu45P4yjqhu7QeK257hYpiG7Srv0kRCUod9xMiwEIX4QZagIvLWNlGWgYVHsvm4c3L4rf
	d1ApERqkmJgSs0JJII74QGfe7ZBf9x4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753435065; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fMigFR4GTYexBo6+Jura8Z+QLDddAiinvpERM0QX96M=;
	b=E7YyVHUgRCIKoC0HYJUBBOXlMYCfj3u+q5g3T7VfXxZ9LS6CAV+V0QlO3EDsI2tWHwk2vG1jCHk6SU42mTtkF9PBmn3dls0epdhjmjRj0QnBF9FsR8iorQ3uRhvb01BhYsGEFipMy2l//F1OgksrPfzxKzA9KbPm5ILjRsnODTg=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjxRaCP_1753435063 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 25 Jul 2025 17:17:44 +0800
Message-ID: <4292fad4-1eb9-4ccd-8da7-957a745282b4@linux.alibaba.com>
Date: Fri, 25 Jul 2025 17:17:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: regression - mm: shmem: add large folio support for tmpfs affect
 GPU performance.
To: Patryk Kowalczyk <patryk@kowalczyk.ws>
Cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>,
 da.gomez@samsung.com, baohua@kernel.org, wangkefeng.wang@huawei.com,
 ioworker0@gmail.com, willy@infradead.org, ryan.roberts@arm.com,
 akpm@linux-foundation.org, eero.t.tamminen@intel.com,
 =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <CAJCW39JCDX6_S2Ojt1HMmX-h_qAKm2eBRzxX5kOHNJz60Zu=vw@mail.gmail.com>
 <d5c6ac93-1af0-4093-afea-94a29a387903@redhat.com>
 <63b69425-2fd1-2c77-06d6-e7ea25c92f34@google.com>
 <3f204974-26c8-4d5f-b7ae-4052cbfdf4ac@redhat.com>
 <a8ac7ec3-4cb3-4dd8-8d02-ede6905f322e@linux.alibaba.com>
 <da2ab844-98c9-4eb2-82ac-01d01bec30f3@linux.alibaba.com>
 <dab283bf-a9cf-30be-02ed-da0d7c8ffcf0@google.com>
 <0c9dc2fa-34c9-4db5-bea3-af4caf05ee6b@linux.alibaba.com>
 <CAJCW39JmaJpFCgoSGf6tSYkwVgxyUdSDFeeoFmf6ODLfsh4Cag@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAJCW39JmaJpFCgoSGf6tSYkwVgxyUdSDFeeoFmf6ODLfsh4Cag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D07F1C000F
X-Stat-Signature: 1ojx4sohws1191kfqm8ew4q3aqptgnd4
X-Rspam-User: 
X-HE-Tag: 1753435069-943323
X-HE-Meta: U2FsdGVkX192Rq5PCAyQNfOXszoiQz1+3XvRcwxonMqpn/1/Cc6CN/8HU7B+TY0VlncLwO8L0ydf8+c0P8SiUtrGMmnMnj6mAM57bDBuiq9n4ASYLWvRmMofdtvTBdM4NmLR1aKpoWCOxdy+eee4iGAFympYJqF0qNMiuXABSqh2f6Pmtftrvgte4Tiy43Jw85ibEI87at7LeCOTOOwhqy05dr2AcrFUC1pThdvY22U5XvCUbOS0wzc54qbShwEVYHrEk2YkFtAd7JEgxR3wmvRmtnl5vhOn/mLgkjDkogPvwHkQwdvOrXBu2XngbRWZfjdDcdTHIMGiZ1sepSs7CV/etj5b4/MqsHfFegwU0iLEZMM6VooI3IGZE/mB5c/z95ZpiiMC5TTXb5p8nb+TodP0ThbQPT4woby2pcDE9+oZLq2V5cgzqruL7T4CPUSZZ1lOIAoI0NPK3D/Pdc3rYVUmV5ljtyS+HQYLaJHw2xTSyib2k6uSpRi1NghnscUjpax1e/30kzAYUa9n/9EVoZuv3sq+O+Nj+m3rgWgqZbat74KMe51f2gABzjA1vn1iuT+TPTd76XR08fepuyehzi4a2QXTTXdD1IrcjdyjROwENxNoFtUv7LI8/x87B0qBV+R9WzAZso3xrOxuTYzddLSbZ3RZ1/eH+DLCB84VcW9eYtwa0n7oU2bgwRRQdCkahhv//A81fNstmFSz3Np8VBXTKHkjMkG5iOGMa3Jleao97Za4p7jqxOmGTb8xM4XxFwhmZ0yploo94j34ZeYDVW31KBukS7dlIuT018cojwITGgX59LchaF8ZONBZDkE76W27TopxfRoA4ehKhXl9EmZHqR0uQpYZ9KxvmOic4yuXrLM4qGTSH+we7pO4g0H+HHAT6zOrkYnxr0fAQvneLjSCyo2AR2YkwLTq/Gl7Qqg0wIgHHCq9NYGKLn0Y/kIFQnkjdl4oTqS/I3DPXY9
 M2jQHACm
 0RdXessJPjV8M18iq2SwHahvgvfEDSq8MdzL0nb2TWDwEFLgBZqrKP4V6zqxoP5Md5flCQE2QN5UCNZAWaNo892hb4H8PrL47s+5P6bMMJRWhLpXTdLyjKWZNxubCvd1Cvq4GnZ57lcW3lvdhOyJFjNBkcSjhMbYwuTPSppyES/MU9FjE7dnpnCDNBKLRNrrcUDvEk+5R9rIiBcf7JBvLGo2BnacRHeIAYf4DwU2Z7qqWOAP/1PSaSGFABtMwCd9FffXfYTTA8EJymo+xLh3/i36gV+x275A9HROrcyl7ggcgeVLOx9pdJX9XrvrUZWfUNBfyFFb+bqk1bb6zpUbLoFAlRn+tYpLGHeDR7uX48OVVnpjUPJjfBsM8/WOtPzk5CHSNVxuBYjlPPr3Dp5fLcEIiXzATdnNrgbzKSJ21QylFVYFXOHzKDhWGnU4zEjsX8DTQM8YW2q7hpGGkdKONDt9cV+XEa+eTE3VR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/25 16:36, Patryk Kowalczyk wrote:
> I have tested the fix for the i915 driver with kernel 6.16-rc7 and intel
> core ultra 155H.
> The performance in several tests is on the kernel 6.12 level,
> so from a functional standpoint, the issue has been resolved.

Thanks for testing. I need to wait for Hugh's opinion before sending out 
a formal fix patch.

> Additionally, I also see potential for further optimization of the Xe
> driver.

If you can guide me where the Xe driver allocates shmem memory, I can 
help with the fix. Thanks.

>> On 2025/7/25 12:47, Hugh Dickins wrote:
>>> On Fri, 25 Jul 2025, Baolin Wang wrote:
>>>>>
>>>>> I hope to correct the logic of i915 driver's shmem allocation, by
>> extending
>>>>> the shmem write length in the i915 driver to allocate PMD- sized THPs.
>> IIUC,
>>>>> some sample fix code is as follows (untested). Patryk, could you help
>> test
>>>>> it to see if this resolves your issue? Thanks.
>>>
>>> This patch cannot be the right fix.  It may be a very sensible workaround
>>> for some in-kernel drivers (I've not looked or tried); but unless I
>>> misunderstand, it does nothing to restore userspace behaviour on a
>>> huge=always tmpfs.
>>
>> Yes. Initially, we wanted to maintain compatibility with the 'huge='
>> option, meaning that 'huge=always' tmpfs mount would still allocate
>> PMD-sized THPs. However, the current implementation is the consensus we
>> reached after much debate:
>>
>> 1. “When using tmpfs as a filesystem, it should behave like other
>> filesystems. No more special mount options.” Per Matthew.
>> 2. “Do not let the 'huge=' mount option mean 'PMD-sized' when other
>> sizes exist.” Per David.
>>
>> At the time, we should have sought your advice, but we failed. The long
>> historical discussion is in this thread[1]. So now the strategy for
>> tmpfs supporting large folios is:
>>
>> "
>> Considering that tmpfs already has the 'huge=' option to control the
>> PMD-sized large folios allocation, we can extend the 'huge=' option to
>> allow any sized large folios. The semantics of the 'huge=' mount option
>> are:
>> huge=never: no any sized large folios
>> huge=always: any sized large folios
>> huge=within_size: like 'always' but respect i_size
>> huge=advise: like 'always' if requested with madvise()
>>
>> Note: For tmpfs mmap() faults, due to the lack of a write size hint,
>> still allocate the PMD-sized large folios if
>> huge=always/within_size/advise is set.
>>
>> Moreover, the 'deny' and 'force' testing options controlled by
>> '/sys/kernel/mm/transparent_hugepage/shmem_enabled' still retain the
>> same semantics. The 'deny' can disable any sized large folios for tmpfs,
>> while the 'force' can enable PMD sized large folios for tmpfs.
>> "
>>
>> Currently, we have observed regression in the i915 driver but have not
>> yet seen userspace regression on a huge=always tmpfs.
>>
>> If you have better suggestions, please feel free to point them out. Thanks.
>>
>> [1] https://lore.kernel.org/lkml/Zw_IT136rxW_KuhU@casper.infradead.org/
>>
>>> Please reread my comment earlier in the thread, in particular,
>>> Passing a new SIGBUS xfstest does not excuse a regression: strict
>> PAGE_SIZE
>>> SIGBUS behaviour is fine for the newly-featured mTHPs or large folios,
>>> but not for the long-established huge=always.
>>
>>
> 


