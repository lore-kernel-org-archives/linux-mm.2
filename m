Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EA0C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 01:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 084606B009F; Fri,  8 Aug 2025 21:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28AA6B00A0; Fri,  8 Aug 2025 21:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E176F6B00A1; Fri,  8 Aug 2025 21:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1A706B009F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 21:24:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85E94116878
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 01:24:00 +0000 (UTC)
X-FDA: 83755472640.18.79DFDD6
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf12.hostedemail.com (Postfix) with ESMTP id 30D3340005
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 01:23:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754702638; a=rsa-sha256;
	cv=none;
	b=01zA3xYId+lYb5XBJuhQg4qeGX6gFVtHrrtmrEoj5g6JfSbU3NxHM7ByeTD2iouCq4Cs/w
	nd2T5UOedETb+I+eW24MxrI2pd/rJY0uCc8IPiPadd9s2r4G9M6gMnC3rvJ/jfuehaQNwy
	vDfim8zo7+l/b0SkGgOc7rN4QAuwwKU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754702638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Lk/PnO8AvdyvTGyJEKTaGkXNKNryrYzNMJqFq6qIzc=;
	b=BhMOFAfASccbS2WRLc2LtmgJ224ITYRkSkY9rBXYrXLv7NHy7cVhU4NTABrUSzfmAWEvup
	3indSvc92wjkNXncE+vJ37Zg7BkXz08OM+PddsBQOYJl/462pRzi2G11ZI7+q2vf2EuHgZ
	AGlWoGCSx8KoDJdLqtSZMT5JnNfMZYo=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bzNMd5VN5z14MGc;
	Sat,  9 Aug 2025 09:18:53 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 33C611800B1;
	Sat,  9 Aug 2025 09:23:51 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 9 Aug 2025 09:23:50 +0800
Content-Type: multipart/alternative;
	boundary="------------0BeSeBVMaLG3eoBPdIV3UzOe"
Message-ID: <256ee1e4-72b4-4332-9bf4-2b70e2712887@huawei.com>
Date: Sat, 9 Aug 2025 09:23:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
To: David Hildenbrand <david@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>, <ziy@nvidia.com>,
	<osalvador@suse.de>, <linux-mm@kvack.org>
References: <20250806020520.631203-1-tujinjiang@huawei.com>
 <1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com>
 <35e24029-d58c-47e8-b5fe-e182f143ebff@huawei.com>
 <c5567040-6f1b-46d1-890e-7dc6b0b46703@redhat.com>
 <156267ef-f834-4bea-9dc0-c8ad32d066b0@huawei.com>
 <864f2ef6-51bd-42f3-9988-16b5e94f05d9@redhat.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <864f2ef6-51bd-42f3-9988-16b5e94f05d9@redhat.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Queue-Id: 30D3340005
X-Stat-Signature: mnjuh7jkztigu79dbsdpexgm4o6at9dw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754702636-229119
X-HE-Meta: U2FsdGVkX1+yhFwh5DicR28UoANL9rg3wMYB3xIUHj0/z6G9K6Z3YqW+IY308ztBoTjMdiiNtRdSHLQJcIwEd0B/TclJ7kO9kPrtB04RtRFnC/0Kz9NuK/FmK9fHYzAwSofDxqD+Dlj9znFOx68/66vY5f7LfL+2BCHVcZ6cjp6I2U7y3Zo9dCGb5b7ynRpfdVsEBOBtb8fNBogGmLX14Ydc49o60hBY0mDLpqs6BNcM5Jw68hgUMik69mR0jqehE3/67IWP+qOfEyBc2TjbpwF68pGxml4tx6HQKQ20ls8W/u7wnZgcjmZh+dR8IKOdkCQDn75F1FmrfK76+Z0LKQe1ddCjbPFhyWyvSeKW+awiHxSEVrenn0MUVjK0FF/iZ1BKHErflwOLd+QqPQJsuJQsrUgrOXgjWMFmEDR65rxZCEvJZDbgtsbUSDXiDyS4QYb0aL9yLThXsVYrBoXYyyJoXquT+9KWqIoV5hWtVDSgSZmttTV8yk9+4JbCJtxUI6oY+TwCyLngtBsmhmHpbp9h+fyn2XroJK7TC1RlayWheXe1NB+y2jfKgq1Og3VdMYI2W/ZRy8tdidYBS9a0zqQWLCXkymtx/ugqq4Tk9FjC5Dg56EslpVVyISY1yPmF9gU+/BI68p+LTGlcVVh1zAz8SUUTxWXmT5aMv89RNBC3iDjPHvNhJHfyi1sjfuMdCmNz+EgMyvRoYVHS7DonwnVf1XQdrNG2wng8NDpHe5xAqJf9sfGh1p2rEBOoTQIw/CeZYuIubyp71V0SjC6V34s7Ji9ATeBkk0d9kmhs4LB/YfVl/np+GumcGbZJR7DHsJ7tLiewxWos37BthFUrxarAmthJqVjaZtkcDPC1/iFVuvl/J6pH2lOuqWOCqaVijvO1dsHRBzdep9mWFM+pchMYd8iyQyEbcmQM9xRmj5rq49U8Mms5XVxFqgg+lg5FB7GCIvoSgQSMcQTBptQ
 IQrjmUR/
 AHK2yonbAL34ErFGu0TRriFFbeGoxnfFi9wiTwfrJnkUt/0QQwuOvgI//Ivk3NoqkibsanN5QYF7SRTO/ieeE3TqkP6RXeUa8q5ssn12lrBvSKaOBFWfbyImy5vwi+RllJh/v4p872JgU7Mt+2YH8JV0KkylQqQgSUslmjNP0a6rQA9OFr7WWYSLFzFdjCPwPHE0Zc1dL3tZQ3MQKWVQvurhAND7kvZdASZ9SwavFS6ctawkI7I9GMj7xxBqrbRIBcrkkLBiRpCnv+8IM1HBw4WkKvcLeNqVpO9p5ARcSD/cv9ahFc8mT1nOHeZDbMJDmOPZkp2yk0aTUp+pFS02Qq2VyEEoES8D3+LOcJ25xSVfAhxEjMfQyaCEQBOes0Rvj09iAEAceh7crImcS97l4viCe+7XU6Rb5wCRnSNYT8iQwb5zrPOuilGk6uQI8oDzeFD2KvXRt5iRqTJ8OVQW/8i4Zt670yjsC4YMKBPV6ObPlARs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------0BeSeBVMaLG3eoBPdIV3UzOe
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/8 16:21, David Hildenbrand 写道:
> On 07.08.25 13:13, Jinjiang Tu wrote:
>>
>> 在 2025/8/6 20:41, David Hildenbrand 写道:
>>> On 06.08.25 05:24, Jinjiang Tu wrote:
>>>>
>>>> 在 2025/8/6 11:05, Miaohe Lin 写道:
>>>>> On 2025/8/6 10:05, Jinjiang Tu wrote:
>>>>>> When memory_failure() is called for a already hwpoisoned pfn,
>>>>>> kill_accessing_process() will be called to kill current task. 
>>>>>> However, if
>>>>> Thanks for your patch.
>>>>>
>>>>>> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() 
>>>>>> will skip
>>>>>> the vma in walk_page_test() and return 0.
>>>>>>
>>>>>> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to 
>>>>>> processes
>>>>>> with recovered clean pages"), kill_accessing_process() will 
>>>>>> return EFAULT.
>>>>> I'm not sure but pfn_to_online_page should return NULL for 
>>>>> VM_PFNMAP pages?
>>>>> So memory_failure_dev_pagemap should handle these pages?
>>>>
>>>> We could call remap_pfn_range() for those pfns with struct page. 
>>>> IIUC, VM_PFNMAP
>>>> means we should assume the pfn doesn't have struct page, but it can 
>>>> have.
>>>>
>>>>>> For x86, the current task will be killed in kill_me_maybe().
>>>>>>
>>>>>> However, after this commit, kill_accessing_process() simplies 
>>>>>> return 0,
>>>>>> that means UCE is handled properly, but it doesn't actually. In 
>>>>>> such case,
>>>>>> the user task will trigger UCE infinitely.
>>>>> Did you ever trigger this loop?
>>>>
>>>> Yes. Our test is as follow steps:
>>>> 1) create a user task allocates a clean anonymous page, wihout 
>>>> accessing it.
>>>> 2) use einj to inject UCE for the page
>>>> 3) create task devmem to use /dev/mem to map the pfn and keep 
>>>> accessing it.
>>>
>>> What is the use case for that? It sounds extremely questionable.
>>>
>> This case is only for test, and is strange indeed.
>>
>> But considering another case, a driver may map same RAM pfn to 
>> several processes with remap_pfn_range().
>> If the first task triggers UCE when accessing the pfn, the task will 
>> be killed. But the other tasks couldn't be killed
>> and triggers UCE infinitely.
>
> Yes, the "anon page" example is confusing though. We really just want 
> to test here if the PFN is mapped. And I would agree that your patch 
> is correct in that case.
>
> For memory poisoning handling you really need a "struct page". 
> struct-less memory is only handled in special ways for DAX (see 
> pfn_to_online_page() logic in memory_failure()).
>
> So what you describe here really only works when a process uses 
> remap_pfn_range() to VM_PFNMAP a struct-page-backed PFN.
>
>
> Likely your patch description should be:
>
> "
> mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed page
>
> When memory_failure() is called for an already hardware poisoned page,
> kill_accessing_process() will conditionally send a SIGBUS to the 
> current (triggering) process if it still maps the page.
>
> However, in case the page is not ordinarily mapped, but was mapped 
> through remap_pfn_range(), kill_accessing_process() would not identify 
> it as mapped even though hwpoison_pte_range() would be prepared to 
> handle it, because walk_page_range() will skip VM_PFNMAP as default in 
> walk_page_test().
>
> walk_page_range() will return 0, assuming "not mapped" and the SIGBUS 
> will be skipped. In this case, the user task will trigger UCE 
> infinitely because it will not receive a SIGBUS on access and simply 
> retry.
>
>
> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to 
> processes with recovered clean pages"), kill_accessing_process() would 
> return EFAULT in that case, and on x86, the current task would be 
> killed in kill_me_maybe().
>
> Let's fix it by adding our custom .test_walk callback that will also
> process VM_PFNMAP VMAs.
> "
>
Thanks, I will update the patch description to emphasize the pfn is backed with struct page.

--------------0BeSeBVMaLG3eoBPdIV3UzOe
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/8/8 16:21, David Hildenbrand 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:864f2ef6-51bd-42f3-9988-16b5e94f05d9@redhat.com">On
      07.08.25 13:13, Jinjiang Tu wrote:
      <br>
      <blockquote type="cite">
        <br>
        在 2025/8/6 20:41, David Hildenbrand 写道:
        <br>
        <blockquote type="cite">On 06.08.25 05:24, Jinjiang Tu wrote:
          <br>
          <blockquote type="cite">
            <br>
            在 2025/8/6 11:05, Miaohe Lin 写道:
            <br>
            <blockquote type="cite">On 2025/8/6 10:05, Jinjiang Tu
              wrote:
              <br>
              <blockquote type="cite">When memory_failure() is called
                for a already hwpoisoned pfn,
                <br>
                kill_accessing_process() will be called to kill current
                task. However, if
                <br>
              </blockquote>
              Thanks for your patch.
              <br>
              <br>
              <blockquote type="cite">the vma of the accessing vaddr is
                VM_PFNMAP, walk_page_range() will skip
                <br>
                the vma in walk_page_test() and return 0.
                <br>
                <br>
                Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send
                SIGBUS to processes
                <br>
                with recovered clean pages"), kill_accessing_process()
                will return EFAULT.
                <br>
              </blockquote>
              I'm not sure but pfn_to_online_page should return NULL for
              VM_PFNMAP pages?
              <br>
              So memory_failure_dev_pagemap should handle these pages?
              <br>
            </blockquote>
            <br>
            We could call remap_pfn_range() for those pfns with struct
            page. IIUC, VM_PFNMAP
            <br>
            means we should assume the pfn doesn't have struct page, but
            it can have.
            <br>
            <br>
            <blockquote type="cite">
              <blockquote type="cite">For x86, the current task will be
                killed in kill_me_maybe().
                <br>
                <br>
                However, after this commit, kill_accessing_process()
                simplies return 0,
                <br>
                that means UCE is handled properly, but it doesn't
                actually. In such case,
                <br>
                the user task will trigger UCE infinitely.
                <br>
              </blockquote>
              Did you ever trigger this loop?
              <br>
            </blockquote>
            <br>
            Yes. Our test is as follow steps:
            <br>
            1) create a user task allocates a clean anonymous page,
            wihout accessing it.
            <br>
            2) use einj to inject UCE for the page
            <br>
            3) create task devmem to use /dev/mem to map the pfn and
            keep accessing it.
            <br>
          </blockquote>
          <br>
          What is the use case for that? It sounds extremely
          questionable.
          <br>
          <br>
        </blockquote>
        This case is only for test, and is strange indeed.
        <br>
        <br>
        But considering another case, a driver may map same RAM pfn to
        several processes with remap_pfn_range().
        <br>
        If the first task triggers UCE when accessing the pfn, the task
        will be killed. But the other tasks couldn't be killed
        <br>
        and triggers UCE infinitely.
        <br>
      </blockquote>
      <br>
      Yes, the "anon page" example is confusing though. We really just
      want to test here if the PFN is mapped. And I would agree that
      your patch is correct in that case.
      <br>
      <br>
      For memory poisoning handling you really need a "struct page".
      struct-less memory is only handled in special ways for DAX (see
      pfn_to_online_page() logic in memory_failure()).
      <br>
      <br>
      So what you describe here really only works when a process uses
      remap_pfn_range() to VM_PFNMAP a struct-page-backed PFN.
      <br>
      <br>
      <br>
      Likely your patch description should be:
      <br>
      <br>
      "
      <br>
      mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed page
      <br>
      <br>
      When memory_failure() is called for an already hardware poisoned
      page,
      <br>
      kill_accessing_process() will conditionally send a SIGBUS to the
      current (triggering) process if it still maps the page.
      <br>
      <br>
      However, in case the page is not ordinarily mapped, but was mapped
      through remap_pfn_range(), kill_accessing_process() would not
      identify it as mapped even though hwpoison_pte_range() would be
      prepared to handle it, because walk_page_range() will skip
      VM_PFNMAP as default in walk_page_test().
      <br>
      <br>
      walk_page_range() will return 0, assuming "not mapped" and the
      SIGBUS will be skipped. In this case, the user task will trigger
      UCE infinitely because it will not receive a SIGBUS on access and
      simply retry.
      <br>
      <br>
      <br>
      Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to
      processes with recovered clean pages"), kill_accessing_process()
      would return EFAULT in that case, and on x86, the current task
      would be killed in kill_me_maybe().
      <br>
      <br>
      Let's fix it by adding our custom .test_walk callback that will
      also
      <br>
      process VM_PFNMAP VMAs.
      <br>
      " <br>
      <br>
    </blockquote>
    <pre>Thanks, I will update the patch description to emphasize the pfn is backed with struct page.</pre>
  </body>
</html>

--------------0BeSeBVMaLG3eoBPdIV3UzOe--

